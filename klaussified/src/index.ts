/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

// Initialize Firebase Admin
admin.initializeApp();

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({maxInstances: 5}, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({maxInstances: 10}) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

/**
 * Assign Secret Santa - Server-side function to prevent race conditions
 * and ensure secure random assignment
 */
export const assignSecretSanta = onCall(async (request) => {
  const {groupId, userId} = request.data;

  // Verify authentication
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Authentication required to assign Secret Santa"
    );
  }

  // Verify user is calling for themselves
  if (request.auth.uid !== userId) {
    throw new HttpsError(
      "permission-denied",
      "You can only assign Secret Santa for yourself"
    );
  }

  try {
    return await admin.firestore().runTransaction(async (transaction) => {
      const groupRef = admin.firestore().collection("groups").doc(groupId);
      const groupDoc = await transaction.get(groupRef);

      if (!groupDoc.exists) {
        throw new HttpsError("not-found", "Group not found");
      }

      const groupData = groupDoc.data();

      // Verify group has started
      if (groupData?.status !== "started") {
        throw new HttpsError(
          "failed-precondition",
          "Group has not started yet"
        );
      }

      // Check if user is a member of the group
      if (!groupData?.memberIds?.includes(userId)) {
        throw new HttpsError(
          "permission-denied",
          "You are not a member of this group"
        );
      }

      const memberRef = admin.firestore()
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .doc(userId);

      const memberDoc = await transaction.get(memberRef);

      if (!memberDoc.exists) {
        throw new HttpsError("not-found", "Member not found");
      }

      const memberData = memberDoc.data();

      // Check if user has already picked
      if (memberData?.hasPicked) {
        throw new HttpsError(
          "already-exists",
          "You have already picked your Secret Santa"
        );
      }

      // Get all members who haven't been assigned yet
      const membersSnapshot = await admin.firestore()
        .collection("groups")
        .doc(groupId)
        .collection("members")
        .get();

      const allMembers = membersSnapshot.docs.map((doc) => doc.id);

      // Get all members who have already been assigned
      const assignedMembers: string[] = [];
      membersSnapshot.docs.forEach((doc) => {
        const data = doc.data();
        if (data.assignedToUserId) {
          assignedMembers.push(data.assignedToUserId);
        }
      });

      // Filter available members (not assigned yet and not self)
      const availableMembers = allMembers.filter(
        (memberId) =>
          !assignedMembers.includes(memberId) && memberId !== userId
      );

      if (availableMembers.length === 0) {
        throw new HttpsError(
          "failed-precondition",
          "No available members to assign"
        );
      }

      // Randomly select from available members
      const randomIndex = Math.floor(Math.random() * availableMembers.length);
      const assignedToUserId = availableMembers[randomIndex];

      // Atomically update member document
      transaction.update(memberRef, {
        assignedToUserId: assignedToUserId,
        hasPicked: true,
        pickedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Increment picked count in group
      transaction.update(groupRef, {
        pickedCount: admin.firestore.FieldValue.increment(1),
      });

      return {success: true, assignedToUserId};
    });
  } catch (error) {
    // Re-throw HttpsErrors
    if (error instanceof HttpsError) {
      throw error;
    }

    // Wrap other errors
    throw new HttpsError(
      "internal",
      "An error occurred while assigning Secret Santa",
      error
    );
  }
});
