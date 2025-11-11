import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

initializeApp();

setGlobalOptions({maxInstances: 10});

export const generateAllAssignments = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const {groupId} = request.data;
  const callerId = request.auth.uid;

  if (!groupId) {
    throw new HttpsError("invalid-argument", "groupId is required");
  }

  const db = getFirestore();
  const groupRef = db.collection("groups").doc(groupId);

  const groupSnap = await groupRef.get();
  if (!groupSnap.exists) {
    throw new HttpsError("not-found", "Group not found");
  }

  const groupData = groupSnap.data();

  if (groupData?.ownerId !== callerId) {
    throw new HttpsError(
      "permission-denied",
      "Only group owner can start the draw"
    );
  }

  if (groupData?.status !== "pending") {
    throw new HttpsError(
      "failed-precondition",
      "Draw has already been started"
    );
  }

  const membersSnap = await groupRef.collection("members").get();
  const members = membersSnap.docs.map((doc) => ({
    userId: doc.id,
    ...doc.data(),
  }));

  if (members.length < 3) {
    throw new HttpsError(
      "failed-precondition",
      "Need at least 3 members to start Secret Santa"
    );
  }

  const userIds = members.map((m) => m.userId);

  const assignments = generateDerangement(userIds);

  const batch = db.batch();

  const assignmentLog: Array<{from: string; to: string}> = [];

  for (const [secretSantaId, pickId] of assignments.entries()) {
    const memberRef = groupRef.collection("members").doc(secretSantaId);
    batch.update(memberRef, {
      assignedToUserId: pickId,
      hasPicked: false,
      assignmentGeneratedAt: new Date(),
    });

    assignmentLog.push({from: secretSantaId, to: pickId});
  }

  batch.update(groupRef, {
    status: "started",
    startedAt: new Date(),
    drawStartedBy: callerId,
    drawStartedAt: new Date(),
    assignmentLog: assignmentLog,
  });

  await batch.commit();

  console.log(`Generated ${assignments.size} assignments for group ${groupId}`);

  return {
    success: true,
    memberCount: members.length,
    assignments: assignmentLog,
  };
});

/**
 * Generates a valid derangement for Secret Santa assignments.
 * @param {string[]} userIds - Array of user IDs
 * @return {Map<string, string>} Map of assignments
 */
function generateDerangement(
  userIds: string[]
): Map<string, string> {
  const n = userIds.length;

  for (let attempt = 0; attempt < 1000; attempt++) {
    const assignments = new Map<string, string>();
    const recipients = [...userIds];

    for (let i = n - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [recipients[i], recipients[j]] = [recipients[j], recipients[i]];
    }

    let isValid = true;
    for (let i = 0; i < n; i++) {
      if (userIds[i] === recipients[i]) {
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      continue;
    }

    for (let i = 0; i < n; i++) {
      assignments.set(userIds[i], recipients[i]);
    }

    const allRecipients = new Set(Array.from(assignments.values()));
    if (allRecipients.size !== n) {
      continue;
    }

    let hasSelfAssignment = false;
    for (const [giver, receiver] of assignments.entries()) {
      if (giver === receiver) {
        hasSelfAssignment = true;
        break;
      }
    }

    if (hasSelfAssignment) {
      continue;
    }

    return assignments;
  }

  throw new HttpsError("internal", "Failed to generate valid assignments");
}

export const assignSecretSanta = onCall(async (request) => {
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
    const groupRef = db.collection("groups").doc(groupId);
    console.log(`Fetching group document: groups/${groupId}`);
    const groupSnap = await groupRef.get();
    console.log(`Group exists: ${groupSnap.exists}`);

    if (!groupSnap.exists) {
      console.error(`Group not found: ${groupId}`);
      throw new HttpsError("not-found", "Group not found");
    }

    const groupData = groupSnap.data();

    if (groupData?.isPending === true) {
      throw new HttpsError(
        "failed-precondition",
        "Group has not started yet"
      );
    }

    if (!groupData?.memberIds?.includes(userId)) {
      throw new HttpsError(
        "permission-denied",
        "User is not a member of this group"
      );
    }

    const memberRef = groupRef.collection("members").doc(userId);
    const memberSnap = await memberRef.get();

    if (memberSnap.exists && memberSnap.data()?.hasPicked === true) {
      const assignedToUserId = memberSnap.data()?.assignedToUserId;
      if (assignedToUserId) {
        return {assignedToUserId};
      }
      throw new HttpsError(
        "failed-precondition",
        "User marked as picked but no assignment found"
      );
    }

    const membersSnap = await groupRef.collection("members").get();
    const members = membersSnap.docs.map((doc) => {
      const data = doc.data() as {
        assignedToUserId?: string;
        hasPicked?: boolean;
      };
      return {
        userId: doc.id,
        ...data,
      };
    });

    const assignedUserIds = new Set(
      members
        .filter((m) => m.assignedToUserId)
        .map((m) => m.assignedToUserId as string)
    );

    const unassignedMembers = members.filter(
      (m) => !assignedUserIds.has(m.userId)
    );

    if (unassignedMembers.length <= 3 && unassignedMembers.length >= 2) {
      console.log(
        `Critical situation: ${unassignedMembers.length} remaining`
      );

      if (unassignedMembers.some((m) => m.userId === userId)) {
        console.log("Current user in critical group, creating cycle...");

        const cycle = new Map<string, string>();

        for (let i = 0; i < unassignedMembers.length; i++) {
          const currentUser = unassignedMembers[i].userId;
          const nextUser =
            unassignedMembers[(i + 1) % unassignedMembers.length].userId;
          cycle.set(currentUser, nextUser);
        }

        if (cycle.size !== unassignedMembers.length) {
          throw new HttpsError(
            "internal",
            "Failed to create complete cycle for remaining members"
          );
        }

        console.log(
          "Saving cyclic assignments for all members:",
          Array.from(cycle.entries())
        );

        const batch = db.batch();
        for (const [secretSantaId, pickId] of cycle.entries()) {
          const memberDocRef =
            groupRef.collection("members").doc(secretSantaId);
          batch.update(memberDocRef, {
            assignedToUserId: pickId,
            hasPicked: true,
            pickedAt: new Date(),
          });
        }

        await batch.commit();

        const assignedToUserId = cycle.get(userId);
        if (!assignedToUserId) {
          throw new HttpsError(
            "internal",
            "Failed to get assignment for current user"
          );
        }

        console.log(
          `Cyclic assignment complete. User ${userId} → ${assignedToUserId}`
        );
        return {assignedToUserId};
      }
    }

    const potentialRecipients = members.filter(
      (m) =>
        m.userId !== userId &&
        !assignedUserIds.has(m.userId)
    );

    if (potentialRecipients.length === 0) {
      throw new HttpsError(
        "failed-precondition",
        "No available recipients for assignment"
      );
    }

    const randomIndex = Math.floor(
      Math.random() * potentialRecipients.length
    );
    const assignedToUserId = potentialRecipients[randomIndex].userId;

    await memberRef.update({
      assignedToUserId,
      hasPicked: true,
      pickedAt: new Date(),
    });

    return {assignedToUserId};
  } catch (error: unknown) {
    if (error instanceof HttpsError) {
      throw error;
    }

    console.error("Error in assignSecretSanta:", error);
    const errorMessage = error instanceof Error ?
      error.message :
      String(error);
    throw new HttpsError("internal", `Internal error: ${errorMessage}`);
  }
});

export const revealAssignment = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const {groupId, userId} = request.data;
  console.log(
    `revealAssignment called with groupId: ${groupId}, userId: ${userId}`
  );

  if (!groupId || !userId) {
    throw new HttpsError("invalid-argument", "Missing groupId or userId");
  }

  if (request.auth.uid !== userId) {
    throw new HttpsError(
      "permission-denied",
      "You can only reveal your own assignment"
    );
  }

  const db = getFirestore();

  try {
    const groupRef = db.collection("groups").doc(groupId);
    const groupSnap = await groupRef.get();

    if (!groupSnap.exists) {
      throw new HttpsError("not-found", "Group not found");
    }

    const groupData = groupSnap.data();

    if (groupData?.status !== "started") {
      throw new HttpsError(
        "failed-precondition",
        "Secret Santa draw has not been started yet"
      );
    }

    if (!groupData?.memberIds?.includes(userId)) {
      throw new HttpsError(
        "permission-denied",
        "You are not a member of this group"
      );
    }

    const memberRef = groupRef.collection("members").doc(userId);
    const memberSnap = await memberRef.get();

    if (!memberSnap.exists) {
      throw new HttpsError("not-found", "Member record not found");
    }

    const memberData = memberSnap.data();

    if (memberData?.hasPicked === true) {
      const assignedToUserId = memberData?.assignedToUserId;
      if (!assignedToUserId) {
        throw new HttpsError(
          "internal",
          "Assignment marked as revealed but no assignment found"
        );
      }
      console.log(`User ${userId} already revealed: ${assignedToUserId}`);
      return {assignedToUserId};
    }

    const assignedToUserId = memberData?.assignedToUserId;

    if (!assignedToUserId) {
      throw new HttpsError(
        "failed-precondition",
        "No assignment found. Owner must start the draw first."
      );
    }

    if (assignedToUserId === userId) {
      throw new HttpsError("internal", "Invalid self-assignment detected");
    }

    await memberRef.update({
      hasPicked: true,
      revealedAt: new Date(),
    });

    await groupRef.update({
      pickedCount: (groupData?.pickedCount || 0) + 1,
    });

    console.log(`User ${userId} revealed assignment: ${assignedToUserId}`);

    return {assignedToUserId};
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }

    console.error("Error in revealAssignment:", error);
    const errorMessage = error instanceof Error ?
      error.message :
      String(error);
    throw new HttpsError("internal", `Internal error: ${errorMessage}`);
  }
});
