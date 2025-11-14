import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {defineSecret} from "firebase-functions/params";
import {emailService} from "./email/emailService";
import {
  getWelcomeEmailTemplate,
  getInvitationEmailTemplate,
  getDeadlineReminderEmailTemplate,
} from "./email/templates";
import {isAdmin} from "./config/admin";

initializeApp();

setGlobalOptions({maxInstances: 10});

// Define secrets for email functionality
const smtpHost = defineSecret("SMTP_HOST");
const smtpPort = defineSecret("SMTP_PORT");
const smtpUser = defineSecret("SMTP_USER");
const smtpPass = defineSecret("SMTP_PASS");

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

export const sendWelcomeEmail = onCall(
  {secrets: [smtpHost, smtpPort, smtpUser, smtpPass]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const {email, displayName, username} = request.data;

    if (!email || !displayName || !username) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: email, displayName, username"
      );
    }

    try {
      const db = getFirestore();

      // Generate unsubscribe token
      const randomStr = Math.random().toString(36).substring(7);
      const unsubscribeToken = Buffer.from(
        `${request.auth.uid}-${Date.now()}-${randomStr}`
      )
        .toString("base64")
        .replace(/[+/=]/g, "");

      // Store token in Firestore
      const expiresAt = new Date();
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);

      await db.collection("unsubscribeTokens").doc(unsubscribeToken).set({
        userId: request.auth.uid,
        createdAt: new Date(),
        expiresAt: expiresAt,
      });

      const html = getWelcomeEmailTemplate(
        displayName,
        username,
        email,
        unsubscribeToken
      );

      await emailService.sendEmail({
        to: email,
        subject: "Welcome to Klaussified - Let's Start Your Secret Santa!",
        html: html,
      });

      console.log(`Welcome email sent successfully to ${email}`);

      return {success: true, message: "Welcome email sent"};
    } catch (error) {
      console.error("Error sending welcome email:", error);
      const errorMessage = error instanceof Error ?
        error.message :
        String(error);
      throw new HttpsError(
        "internal",
        `Failed to send welcome email: ${errorMessage}`
      );
    }
  }
);

// Test function to manually send welcome email
export const testWelcomeEmail = onCall(
  {secrets: [smtpHost, smtpPort, smtpUser, smtpPass]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    // Get user data from Firestore
    const db = getFirestore();
    const userDoc = await db.collection("users").doc(request.auth.uid).get();

    if (!userDoc.exists) {
      throw new HttpsError("not-found", "User not found");
    }

    const userData = userDoc.data();
    const email = userData?.email;
    const displayName = userData?.displayName;
    const username = userData?.username;

    if (!email || !displayName || !username) {
      throw new HttpsError(
        "failed-precondition",
        "User data incomplete"
      );
    }

    try {
      // Generate unsubscribe token
      const randomStr = Math.random().toString(36).substring(7);
      const unsubscribeToken = Buffer.from(
        `${request.auth.uid}-${Date.now()}-${randomStr}`
      )
        .toString("base64")
        .replace(/[+/=]/g, "");

      // Store token in Firestore
      const expiresAt = new Date();
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);

      await db.collection("unsubscribeTokens").doc(unsubscribeToken).set({
        userId: request.auth.uid,
        createdAt: new Date(),
        expiresAt: expiresAt,
      });

      const html = getWelcomeEmailTemplate(
        displayName,
        username,
        email,
        unsubscribeToken
      );

      await emailService.sendEmail({
        to: email,
        subject: "Welcome to Klaussified - Let's Start Your Secret Santa!",
        html: html,
      });

      console.log(`Test welcome email sent successfully to ${email}`);

      return {
        success: true,
        message: `Welcome email sent to ${email}`,
      };
    } catch (error) {
      console.error("Error sending test welcome email:", error);
      const errorMessage = error instanceof Error ?
        error.message :
        String(error);
      throw new HttpsError(
        "internal",
        `Failed to send test email: ${errorMessage}`
      );
    }
  }
);

// Admin function to send welcome email to specific user
export const sendWelcomeEmailToUser = onCall(
  {secrets: [smtpHost, smtpPort, smtpUser, smtpPass]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const {targetUserId} = request.data;

    if (!targetUserId) {
      throw new HttpsError(
        "invalid-argument",
        "targetUserId is required"
      );
    }

    // Get caller (admin) data from Firestore
    const db = getFirestore();
    const callerDoc = await db.collection("users").doc(request.auth.uid).get();

    if (!callerDoc.exists) {
      throw new HttpsError("not-found", "Caller user not found");
    }

    const callerData = callerDoc.data();
    const callerEmail = callerData?.email;

    // Verify caller is admin (hardcoded for now)
    const adminUID = "LblZXIFcQ2fpZWo6mJxVGYkP1Um2";
    const adminEmail = "adrian28awesome@gmail.com";

    if (request.auth.uid !== adminUID || callerEmail !== adminEmail) {
      throw new HttpsError(
        "permission-denied",
        "Only admin can send welcome emails to users"
      );
    }

    // Get target user data
    const targetUserDoc = await db.collection("users").doc(targetUserId).get();

    if (!targetUserDoc.exists) {
      throw new HttpsError("not-found", "Target user not found");
    }

    const targetUserData = targetUserDoc.data();
    const targetEmail = targetUserData?.email;
    const targetDisplayName = targetUserData?.displayName;
    const targetUsername = targetUserData?.username;

    if (!targetEmail || !targetDisplayName || !targetUsername) {
      throw new HttpsError(
        "failed-precondition",
        "Target user data incomplete"
      );
    }

    try {
      // Generate unsubscribe token
      const randomStr = Math.random().toString(36).substring(7);
      const unsubscribeToken = Buffer.from(
        `${targetUserId}-${Date.now()}-${randomStr}`
      )
        .toString("base64")
        .replace(/[+/=]/g, "");

      // Store token in Firestore
      const expiresAt = new Date();
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);

      await db.collection("unsubscribeTokens").doc(unsubscribeToken).set({
        userId: targetUserId,
        createdAt: new Date(),
        expiresAt: expiresAt,
      });

      const html = getWelcomeEmailTemplate(
        targetDisplayName,
        targetUsername,
        targetEmail,
        unsubscribeToken
      );

      await emailService.sendEmail({
        to: targetEmail,
        subject: "Welcome to Klaussified - Let's Start Your Secret Santa!",
        html: html,
      });

      console.log(
        `Admin ${request.auth.uid} sent welcome email to user ${targetUserId}`
      );

      return {
        success: true,
        message: `Welcome email sent to ${targetDisplayName} (${targetEmail})`,
        targetUserId: targetUserId,
        targetEmail: targetEmail,
      };
    } catch (error) {
      console.error("Error sending welcome email to user:", error);
      const errorMessage = error instanceof Error ?
        error.message :
        String(error);
      throw new HttpsError(
        "internal",
        `Failed to send welcome email: ${errorMessage}`
      );
    }
  }
);

// Automatically send welcome email when a new user document is created
export const sendWelcomeEmailOnUserCreation = onDocumentCreated(
  {
    document: "users/{userId}",
    secrets: [smtpHost, smtpPort, smtpUser, smtpPass],
  },
  async (event) => {
    const snapshot = event.data;

    if (!snapshot) {
      console.error(
        "No data associated with the event in sendWelcomeEmailOnUserCreation"
      );
      return;
    }

    const userData = snapshot.data();
    const userId = snapshot.id;
    const userEmail = userData.email;
    const userDisplayName = userData.displayName;
    const userUsername = userData.username;

    // Validate required fields
    if (!userEmail || !userDisplayName || !userUsername) {
      console.error(
        "Missing required fields for welcome email. " +
        `UserId: ${userId}, Email: ${userEmail}, ` +
        `DisplayName: ${userDisplayName}, Username: ${userUsername}`
      );
      return;
    }

    try {
      const db = getFirestore();

      // Generate unsubscribe token
      const randomStr = Math.random().toString(36).substring(7);
      const unsubscribeToken = Buffer.from(
        `${userId}-${Date.now()}-${randomStr}`
      )
        .toString("base64")
        .replace(/[+/=]/g, "");

      // Store token in Firestore with 1 year expiration
      const expiresAt = new Date();
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);

      await db.collection("unsubscribeTokens").doc(unsubscribeToken).set({
        userId: userId,
        createdAt: new Date(),
        expiresAt: expiresAt,
      });

      // Get email HTML template
      const html = getWelcomeEmailTemplate(
        userDisplayName,
        userUsername,
        userEmail,
        unsubscribeToken
      );

      // Send email
      await emailService.sendEmail({
        to: userEmail,
        subject: "Welcome to Klaussified - Let's Start Your Secret Santa!",
        html: html,
      });

      console.log(
        `Welcome email sent to new user: ${userEmail} (UID: ${userId})`
      );
    } catch (error) {
      console.error(
        `Error sending automatic welcome email to ${userEmail}:`,
        error
      );
      // Don't throw - don't fail user creation if email fails
    }
  }
);

// Generate unsubscribe token for a user
export const generateUnsubscribeToken = onCall(async (request) => {
  const {userId} = request.data;

  if (!userId) {
    throw new HttpsError("invalid-argument", "userId is required");
  }

  const db = getFirestore();

  try {
    // Generate a unique token
    const token = Buffer.from(
      `${userId}-${Date.now()}-${Math.random().toString(36).substring(7)}`
    )
      .toString("base64")
      .replace(/[+/=]/g, "");

    // Store token in Firestore with expiration (1 year from now)
    const expiresAt = new Date();
    expiresAt.setFullYear(expiresAt.getFullYear() + 1);

    await db.collection("unsubscribeTokens").doc(token).set({
      userId: userId,
      createdAt: new Date(),
      expiresAt: expiresAt,
    });

    return {
      success: true,
      token: token,
    };
  } catch (error) {
    console.error("Error generating unsubscribe token:", error);
    throw new HttpsError("internal", "Failed to generate unsubscribe token");
  }
});

// Process unsubscribe request
export const processUnsubscribe = onCall(async (request) => {
  const {token, unsubscribeType} = request.data;

  if (!token || !unsubscribeType) {
    throw new HttpsError(
      "invalid-argument",
      "token and unsubscribeType are required"
    );
  }

  const db = getFirestore();

  try {
    // Verify token
    const tokenDoc = await db.collection("unsubscribeTokens").doc(token).get();

    if (!tokenDoc.exists) {
      throw new HttpsError("not-found", "Invalid unsubscribe token");
    }

    const tokenData = tokenDoc.data();
    const userId = tokenData?.userId;

    if (!userId) {
      throw new HttpsError("internal", "Invalid token data");
    }

    // Check expiration
    const expiresAt = tokenData?.expiresAt?.toDate();
    if (expiresAt && expiresAt < new Date()) {
      throw new HttpsError("failed-precondition", "Token has expired");
    }

    // Update user preferences based on unsubscribe type
    const userRef = db.collection("users").doc(userId);
    const updateData: {[key: string]: boolean} = {};

    if (unsubscribeType === "all") {
      updateData.emailNotificationsEnabled = false;
      updateData.emailInviteNotifications = false;
      updateData.emailDeadlineNotifications = false;
    } else if (unsubscribeType === "invites") {
      updateData.emailInviteNotifications = false;
    } else if (unsubscribeType === "deadlines") {
      updateData.emailDeadlineNotifications = false;
    } else {
      throw new HttpsError("invalid-argument", "Invalid unsubscribe type");
    }

    await userRef.update(updateData);

    console.log(`User ${userId} unsubscribed from ${unsubscribeType}`);

    return {
      success: true,
      message: "Successfully unsubscribed",
      unsubscribeType: unsubscribeType,
    };
  } catch (error) {
    console.error("Error processing unsubscribe:", error);
    if (error instanceof HttpsError) {
      throw error;
    }
    throw new HttpsError("internal", "Failed to process unsubscribe");
  }
});

// Send invitation email when a new invitation is created
export const sendInvitationEmail = onDocumentCreated(
  {
    document: "invites/{inviteId}",
    secrets: [smtpHost, smtpPort, smtpUser, smtpPass],
  },
  async (event) => {
    const invitationData = event.data?.data();

    if (!invitationData) {
      console.error("No invitation data found");
      return;
    }

    const {inviteeUserId, groupId, invitedBy, invitedByName} = invitationData;

    if (!inviteeUserId || !groupId || !invitedBy) {
      console.error("Missing required invitation data");
      return;
    }

    const db = getFirestore();

    try {
      // Get invited user data
      const invitedUserDoc =
        await db.collection("users").doc(inviteeUserId).get();
      if (!invitedUserDoc.exists) {
        console.error(`Invited user ${inviteeUserId} not found`);
        return;
      }

      const invitedUserData = invitedUserDoc.data();
      const invitedUserEmail = invitedUserData?.email;
      const emailInviteNotifications =
        invitedUserData?.emailInviteNotifications;

      // Check if user has email notifications enabled for invites
      if (!emailInviteNotifications) {
        console.log(`User ${inviteeUserId} invitation emails disabled`);
        return;
      }

      if (!invitedUserEmail) {
        console.error(`User ${inviteeUserId} has no email address`);
        return;
      }

      // Get group data
      const groupDoc = await db.collection("groups").doc(groupId).get();
      if (!groupDoc.exists) {
        console.error(`Group ${groupId} not found`);
        return;
      }

      const groupData = groupDoc.data();
      const groupName = groupData?.name || "Secret Santa Group";
      const inviterName = invitedByName || "Someone";

      // Generate unsubscribe token directly
      const randomPart = Math.random().toString(36).substring(7);
      const token = Buffer.from(
        `${inviteeUserId}-${Date.now()}-${randomPart}`
      )
        .toString("base64")
        .replace(/[+/=]/g, "");

      const expiresAt = new Date();
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);

      await db.collection("unsubscribeTokens").doc(token).set({
        userId: inviteeUserId,
        createdAt: new Date(),
        expiresAt: expiresAt,
      });

      const unsubscribeToken = token;

      // Generate email HTML
      const html = getInvitationEmailTemplate(
        inviterName,
        groupName,
        unsubscribeToken
      );

      // Send email
      await emailService.sendEmail({
        to: invitedUserEmail,
        subject: `You're Invited to Join ${groupName}!`,
        html: html,
      });

      console.log(
        `Invitation email sent to ${invitedUserEmail} for ${groupName}`
      );
    } catch (error) {
      console.error("Error sending invitation email:", error);
    }
  }
);

// Scheduled function to send deadline reminders daily at 10:00 AM
export const sendDeadlineReminders = onSchedule(
  {
    schedule: "0 10 * * *", // Every day at 10:00 AM
    timeZone: "Europe/Bucharest",
    secrets: [smtpHost, smtpPort, smtpUser, smtpPass],
  },
  async () => {
    const db = getFirestore();

    try {
      console.log("Starting deadline reminder job...");

      // Get all groups that have started and have a deadline
      const groupsSnapshot = await db
        .collection("groups")
        .where("status", "==", "started")
        .get();

      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(0, 0, 0, 0);

      const dayAfterTomorrow = new Date(tomorrow);
      dayAfterTomorrow.setDate(dayAfterTomorrow.getDate() + 1);

      for (const groupDoc of groupsSnapshot.docs) {
        const groupData = groupDoc.data();
        const groupId = groupDoc.id;
        const groupName = groupData?.name || "Secret Santa Group";
        const eventDate = groupData?.eventDate?.toDate();

        // Skip if no event date or event date is not within 24 hours
        if (!eventDate) {
          continue;
        }

        const eventDateTime = eventDate.getTime();
        const tomorrowTime = tomorrow.getTime();
        const dayAfterTomorrowTime = dayAfterTomorrow.getTime();

        // Check if event date is tomorrow (within the next 24-48 hours)
        if (
          eventDateTime < tomorrowTime ||
          eventDateTime >= dayAfterTomorrowTime
        ) {
          continue;
        }

        console.log(
          `Processing deadline reminders for ${groupName} (${groupId})`
        );

        // Get all members of the group
        const membersSnapshot = await db
          .collection("groups")
          .doc(groupId)
          .collection("members")
          .get();

        for (const memberDoc of membersSnapshot.docs) {
          const memberData = memberDoc.data();
          const userId = memberDoc.id;
          const hasPicked = memberData?.hasPicked;

          // CRITICAL: Only send reminder if user hasn't picked yet
          if (hasPicked === true) {
            console.log(
              `User ${userId} has already picked, skipping reminder`
            );
            continue;
          }

          // Get user data
          const userDoc = await db.collection("users").doc(userId).get();
          if (!userDoc.exists) {
            console.error(`User ${userId} not found`);
            continue;
          }

          const userData = userDoc.data();
          const userEmail = userData?.email;
          const emailDeadlineNotifications =
            userData?.emailDeadlineNotifications;

          // Check if user has deadline email notifications enabled
          if (!emailDeadlineNotifications) {
            console.log(`User ${userId} has deadline emails disabled`);
            continue;
          }

          if (!userEmail) {
            console.error(`User ${userId} has no email address`);
            continue;
          }

          // Generate unsubscribe token directly
          const randomToken = Math.random().toString(36).substring(7);
          const token = Buffer.from(`${userId}-${Date.now()}-${randomToken}`)
            .toString("base64")
            .replace(/[+/=]/g, "");

          const tokenExpiresAt = new Date();
          tokenExpiresAt.setFullYear(tokenExpiresAt.getFullYear() + 1);

          await db.collection("unsubscribeTokens").doc(token).set({
            userId: userId,
            createdAt: new Date(),
            expiresAt: tokenExpiresAt,
          });

          const unsubscribeToken = token;

          // Format deadline
          const deadlineFormatted = eventDate.toLocaleDateString("en-US", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric",
          });

          // Calculate days left (always 1 since we're checking tomorrow)
          const daysLeft = 1;

          // Generate email HTML
          const html = getDeadlineReminderEmailTemplate(
            groupName,
            deadlineFormatted,
            daysLeft,
            groupId,
            unsubscribeToken
          );

          // Send email
          await emailService.sendEmail({
            to: userEmail,
            subject: `Reminder: ${groupName} Exchange is Tomorrow!`,
            html: html,
          });

          console.log(
            `Deadline reminder sent to ${userEmail} for ${groupName}`
          );
        }
      }

      console.log("Deadline reminder job completed successfully");
    } catch (error) {
      console.error("Error in deadline reminder job:", error);
    }
  }
);

// Migration function to enable all notifications for existing users
export const enableNotificationsForAllUsers = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  // Only allow admins to run this function
  const db = getFirestore();
  const userDoc = await db.collection("users").doc(request.auth.uid).get();
  const userEmail = userDoc.data()?.email;

  if (!isAdmin(request.auth.uid, userEmail)) {
    throw new HttpsError(
      "permission-denied",
      "Only admins can run this migration"
    );
  }

  try {
    const usersSnapshot = await db.collection("users").get();
    let updatedCount = 0;

    const batch = db.batch();
    const batchLimit = 500; // Firestore batch limit
    let operationCount = 0;

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();

      // Check if notification settings are missing or disabled
      const needsUpdate =
        userData.emailInviteNotifications === false ||
        userData.emailDeadlineNotifications === false ||
        userData.emailNotificationsEnabled === false ||
        userData.emailInviteNotifications === undefined ||
        userData.emailDeadlineNotifications === undefined;

      if (needsUpdate) {
        batch.update(userDoc.ref, {
          emailNotificationsEnabled: true,
          emailInviteNotifications: true,
          emailDeadlineNotifications: true,
        });
        updatedCount++;
        operationCount++;

        // Commit batch if we reach the limit
        if (operationCount >= batchLimit) {
          await batch.commit();
          operationCount = 0;
        }
      }
    }

    // Commit any remaining operations
    if (operationCount > 0) {
      await batch.commit();
    }

    console.log(`Migration completed. Updated ${updatedCount} users`);

    return {
      success: true,
      message: `Successfully enabled notifications for ${updatedCount} users`,
      updatedCount,
      totalUsers: usersSnapshot.docs.length,
    };
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error("Error in migration:", errorMessage);
    throw new HttpsError(
      "internal",
      `Migration failed: ${errorMessage}`
    );
  }
});

// Contact form function to send emails to hello@klaussified.com
export const sendContactForm = onCall(
  {secrets: [smtpHost, smtpPort, smtpUser, smtpPass]},
  async (request) => {
    const {name, email, message} = request.data;

    if (!name || !email || !message) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: name, email, message"
      );
    }

    // Basic email validation
    if (!email.includes("@")) {
      throw new HttpsError("invalid-argument", "Invalid email address");
    }

    try {
      const redBg = "background-color: #C41E3A;";
      const greenBorder = "border-left: 4px solid #165B33;";
      const centerText = "text-align: center;";
      const pStyle = "color: #333; font-size: 16px; line-height: 1.6;";

      const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8">
<title>Contact Form</title></head>
<body style="margin:0;padding:0;font-family:Arial,sans-serif;">
<table width="100%" cellpadding="0" cellspacing="0"
style="background-color:#f4f4f4;padding:20px;">
<tr><td align="center">
<table width="600" cellpadding="0" cellspacing="0"
style="background-color:#fff;border-radius:8px;">
<tr><td style="${redBg}padding:30px;${centerText}">
<h1 style="color:#FFFAFA;margin:0;font-size:32px;">🎄 Klaussified</h1>
<p style="color:#FFFAFA;margin:10px 0 0 0;">Contact Form</p>
</td></tr>
<tr><td style="padding:40px 30px;">
<h2 style="color:#165B33;margin:0 0 20px 0;">New Message</h2>
<p style="${pStyle}margin:0 0 15px 0;">
<strong>From:</strong> ${name}</p>
<p style="${pStyle}margin:0 0 15px 0;">
<strong>Email:</strong>
<a href="mailto:${email}" style="color:#C41E3A;">${email}</a></p>
<p style="${pStyle}margin:0 0 10px 0;"><strong>Message:</strong></p>
<div style="background-color:#f8f9fa;padding:20px;${greenBorder}
border-radius:4px;margin:15px 0;">
<p style="${pStyle}margin:0;white-space:pre-wrap;">${message}</p>
</div></td></tr>
<tr><td style="background-color:#f8f9fa;padding:20px 30px;
${centerText}border-top:1px solid #eee;">
<p style="color:#999;font-size:12px;margin:0;">
Sent via Klaussified contact form.</p>
</td></tr></table></td></tr></table></body></html>`;

      await emailService.sendEmail({
        to: "hello@klaussified.com",
        subject: `Contact Form: Message from ${name}`,
        html: html,
        replyTo: email,
        from: "contact@klaussified.com",
      });

      console.log(`Contact form email sent from ${email}`);

      return {
        success: true,
        message: "Your message has been sent successfully!",
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      console.error("Error sending contact form:", errorMessage);
      throw new HttpsError(
        "internal",
        `Failed to send message: ${errorMessage}`
      );
    }
  }
);
