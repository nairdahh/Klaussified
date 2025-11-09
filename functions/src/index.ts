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
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

initializeApp();

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/**
 * Assigns a Secret Santa to a user in a group.
 * Uses a fair random assignment algorithm ensuring no self-assignments
 * and that each person is assigned exactly once.
 */
export const assignSecretSanta = onCall(async (request) => {
  // Verify user is authenticated
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const {groupId, userId} = request.data;
  console.log(
    `assignSecretSanta called with groupId: ${groupId}, userId: ${userId}`
  );

  if (!groupId || !userId) {
    throw new HttpsError("invalid-argument", "Missing groupId or userId");
  }

  const db = getFirestore();

  try {
    // Get group document
    const groupRef = db.collection("groups").doc(groupId);
    console.log(`Fetching group document: groups/${groupId}`);
    const groupSnap = await groupRef.get();
    console.log(`Group exists: ${groupSnap.exists}`);

    if (!groupSnap.exists) {
      console.error(`Group not found: ${groupId}`);
      throw new HttpsError("not-found", "Group not found");
    }

    const groupData = groupSnap.data();

    // Verify group has started
    if (groupData?.isPending === true) {
      throw new HttpsError(
        "failed-precondition",
        "Group has not started yet"
      );
    }

    // Verify user is a member of the group
    if (!groupData?.memberIds?.includes(userId)) {
      throw new HttpsError(
        "permission-denied",
        "User is not a member of this group"
      );
    }

    // Check if user has already picked
    const memberRef = groupRef.collection("members").doc(userId);
    const memberSnap = await memberRef.get();

    if (memberSnap.exists && memberSnap.data()?.hasPicked === true) {
      // User already picked, return their existing assignment
      const assignedToUserId = memberSnap.data()?.assignedToUserId;
      if (assignedToUserId) {
        return {assignedToUserId};
      }
      throw new HttpsError(
        "failed-precondition",
        "User marked as picked but no assignment found"
      );
    }

    // Get all members
    const membersSnap = await groupRef.collection("members").get();
    const members = membersSnap.docs.map((doc) => {
      const data = doc.data() as {assignedToUserId?: string};
      return {
        userId: doc.id,
        ...data,
      };
    });

    // Filter out users who have already been assigned to someone
    const assignedUserIds = new Set(
      members
        .filter((m) => m.assignedToUserId)
        .map((m) => m.assignedToUserId as string)
    );

    // Get potential recipients (not self, not already assigned)
    const potentialRecipients = members.filter(
      (m) =>
        m.userId !== userId && !assignedUserIds.has(m.userId)
    );

    if (potentialRecipients.length === 0) {
      throw new HttpsError(
        "failed-precondition",
        "No available recipients for assignment"
      );
    }

    // Randomly select a recipient
    const randomIndex = Math.floor(
      Math.random() * potentialRecipients.length
    );
    const assignedToUserId = potentialRecipients[randomIndex].userId;

    // Update the member document with the assignment
    await memberRef.update({
      assignedToUserId,
      hasPicked: true,
      pickedAt: new Date(),
    });

    return {assignedToUserId};
  } catch (error: unknown) {
    // If it's already an HttpsError, rethrow it
    if (error instanceof HttpsError) {
      throw error;
    }

    // Otherwise wrap in internal error
    console.error("Error in assignSecretSanta:", error);
    const errorMessage = error instanceof Error ?
      error.message :
      String(error);
    throw new HttpsError("internal", `Internal error: ${errorMessage}`);
  }
});
