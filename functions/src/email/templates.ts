import {APP_CONFIG} from "../config/constants";

export function getInvitationEmailTemplate(
  invitedBy: string,
  groupName: string,
  unsubscribeToken: string
): string {
  const {appUrl} = APP_CONFIG;
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>You're Invited to Join a Secret Santa Group!</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f4f4; padding: 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
          <tr>
            <td style="background-color: #C41E3A; padding: 30px; text-align: center;">
              <h1 style="color: #FFFAFA; margin: 0; font-size: 32px;">🎄 Klaussified</h1>
              <p style="color: #FFFAFA; margin: 10px 0 0 0; font-size: 16px;">Secret Santa Made Easy</p>
            </td>
          </tr>

          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #165B33; margin: 0 0 20px 0; font-size: 24px;">You've Been Invited!</h2>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                <strong>${invitedBy}</strong> invited you to join <strong>${groupName}</strong> group on Klaussified
              </p>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 20px 0;">
                Get ready for a fun gift exchange! Accept the invitation to see the details and join the festivities.
              </p>

              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 30px 0;">
                <tr>
                  <td align="center">
                    <a href="${appUrl}/invitations" style="display: inline-block; background-color: #165B33; color: #FFFAFA; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-size: 16px; font-weight: bold;">
                      View Invitation
                    </a>
                  </td>
                </tr>
              </table>

              <p style="color: #666666; font-size: 14px; line-height: 1.6; margin: 20px 0 0 0;">
                If you didn't expect this invitation, you can safely ignore this email or decline the invitation in the app.
              </p>
            </td>
          </tr>

          ${getUnsubscribeFooter(unsubscribeToken, "invites")}

          <tr>
            <td style="background-color: #f8f9fa; padding: 10px 30px; text-align: center;">
              <p style="color: #999999; font-size: 11px; margin: 0;">
                &copy; 2025 Klaussified. All rights reserved.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

export function getDrawStartedEmailTemplate(
  groupName: string,
  ownerName: string,
  groupId: string,
  unsubscribeToken: string
): string {
  const {appUrl} = APP_CONFIG;
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Secret Santa Draw Has Started!</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f4f4; padding: 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
          <tr>
            <td style="background-color: #C41E3A; padding: 30px; text-align: center;">
              <h1 style="color: #FFFAFA; margin: 0; font-size: 32px;">🎅 It's Time!</h1>
              <p style="color: #FFFAFA; margin: 10px 0 0 0; font-size: 16px;">The Draw Has Begun</p>
            </td>
          </tr>

          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #165B33; margin: 0 0 20px 0; font-size: 24px;">Your Secret Santa Awaits!</h2>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                Great news! <strong>${ownerName}</strong> has started the Secret Santa draw for:
              </p>

              <div style="background-color: #f8f9fa; border-left: 4px solid #165B33; padding: 20px; margin: 20px 0;">
                <h3 style="color: #165B33; margin: 0 0 10px 0; font-size: 20px;">${groupName}</h3>
              </div>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 20px 0;">
                You can now reveal who you'll be Secret Santa for! Click the button below to see your assignment and their gift wishes.
              </p>

              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 30px 0;">
                <tr>
                  <td align="center">
                    <a href="${appUrl}/group/${groupId}" style="display: inline-block; background-color: #C41E3A; color: #FFFAFA; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-size: 16px; font-weight: bold;">
                      Reveal Your Secret Santa
                    </a>
                  </td>
                </tr>
              </table>

              <div style="background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;">
                <p style="color: #856404; font-size: 14px; margin: 0; line-height: 1.6;">
                  <strong>Remember:</strong> Keep your assignment secret! The magic of Secret Santa is in the surprise. 🤫
                </p>
              </div>
            </td>
          </tr>

          ${getUnsubscribeFooter(unsubscribeToken, "all")}

          <tr>
            <td style="background-color: #f8f9fa; padding: 10px 30px; text-align: center;">
              <p style="color: #999999; font-size: 11px; margin: 0;">
                &copy; 2025 Klaussified. All rights reserved.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

export function getDeadlineReminderEmailTemplate(
  groupName: string,
  deadline: string,
  daysLeft: number,
  groupId: string,
  unsubscribeToken: string
): string {
  const {appUrl} = APP_CONFIG;
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Secret Santa Deadline Reminder</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f4f4; padding: 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
          <tr>
            <td style="background-color: #C41E3A; padding: 30px; text-align: center;">
              <h1 style="color: #FFFAFA; margin: 0; font-size: 32px;">⏰ Reminder</h1>
              <p style="color: #FFFAFA; margin: 10px 0 0 0; font-size: 16px;">Your Secret Santa Exchange is Coming Up!</p>
            </td>
          </tr>

          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #165B33; margin: 0 0 20px 0; font-size: 24px;">Don't Forget!</h2>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                The gift exchange for <strong>${groupName}</strong> is approaching:
              </p>

              <div style="background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 20px 0; text-align: center;">
                <h3 style="color: #856404; margin: 0 0 10px 0; font-size: 24px;">${daysLeft} ${daysLeft === 1 ? "Day" : "Days"} Left</h3>
                <p style="color: #856404; margin: 0; font-size: 16px;">Exchange Date: <strong>${deadline}</strong></p>
              </div>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 20px 0;">
                Time to finalize your gift! Check your Secret Santa's profile for their gift wishes and preferences.
              </p>

              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 30px 0;">
                <tr>
                  <td align="center">
                    <a href="${appUrl}/group/${groupId}" style="display: inline-block; background-color: #165B33; color: #FFFAFA; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-size: 16px; font-weight: bold;">
                      View Group Details
                    </a>
                  </td>
                </tr>
              </table>

              <div style="background-color: #d4edda; border-left: 4px solid #28a745; padding: 15px; margin: 20px 0;">
                <p style="color: #155724; font-size: 14px; margin: 0; line-height: 1.6;">
                  <strong>Pro tip:</strong> Remember to check their hobbies and gift wishes for inspiration! 🎁
                </p>
              </div>
            </td>
          </tr>

          ${getUnsubscribeFooter(unsubscribeToken, "deadlines")}

          <tr>
            <td style="background-color: #f8f9fa; padding: 10px 30px; text-align: center;">
              <p style="color: #999999; font-size: 11px; margin: 0;">
                &copy; 2025 Klaussified. All rights reserved.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

export function getWelcomeEmailTemplate(
  displayName: string,
  username: string,
  email: string,
  unsubscribeToken: string
): string {
  const {appUrl} = APP_CONFIG;
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome to Klaussified!</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f4f4; padding: 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
          <tr>
            <td style="background-color: #C41E3A; padding: 40px; text-align: center;">
              <h1 style="color: #FFFAFA; margin: 0; font-size: 36px;">🎄 Welcome to Klaussified!</h1>
              <p style="color: #FFFAFA; margin: 15px 0 0 0; font-size: 18px;">Secret Santa Made Easy</p>
            </td>
          </tr>

          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #165B33; margin: 0 0 20px 0; font-size: 26px;">Hi ${displayName}! 👋</h2>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                We're excited to have you join the Klaussified community! Your account has been successfully created, and you're ready to start organizing amazing Secret Santa gift exchanges.
              </p>

              <div style="background-color: #f8f9fa; border-left: 4px solid #165B33; padding: 20px; margin: 20px 0;">
                <h3 style="color: #165B33; margin: 0 0 15px 0; font-size: 18px;">Your Account Details</h3>
                <p style="color: #333333; margin: 5px 0; font-size: 15px;"><strong>Username:</strong> ${username}</p>
                <p style="color: #333333; margin: 5px 0; font-size: 15px;"><strong>Email:</strong> ${email}</p>
              </div>

              <h3 style="color: #C41E3A; margin: 30px 0 15px 0; font-size: 22px;">How Klaussified Works</h3>

              <div style="margin: 20px 0;">
                <div style="margin-bottom: 15px;">
                  <strong style="color: #165B33; font-size: 16px;">1. Create a Group</strong>
                  <p style="color: #666666; margin: 5px 0 0 0; font-size: 14px;">Set up your Secret Santa group with a name, exchange date, and budget.</p>
                </div>

                <div style="margin-bottom: 15px;">
                  <strong style="color: #165B33; font-size: 16px;">2. Invite Friends</strong>
                  <p style="color: #666666; margin: 5px 0 0 0; font-size: 14px;">Send invitations to participants via email. They can accept and join your group.</p>
                </div>

                <div style="margin-bottom: 15px;">
                  <strong style="color: #165B33; font-size: 16px;">3. Start the Draw</strong>
                  <p style="color: #666666; margin: 5px 0 0 0; font-size: 14px;">When everyone's ready, start the draw. Our algorithm ensures fair, random assignments.</p>
                </div>

                <div style="margin-bottom: 15px;">
                  <strong style="color: #165B33; font-size: 16px;">4. Discover Your Secret Santa</strong>
                  <p style="color: #666666; margin: 5px 0 0 0; font-size: 14px;">Reveal who you're buying for, check their wishlist, and keep it secret until the exchange!</p>
                </div>
              </div>

              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 30px 0;">
                <tr>
                  <td align="center">
                    <a href="${appUrl}/home" style="display: inline-block; background-color: #C41E3A; color: #FFFAFA; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-size: 16px; font-weight: bold; margin-bottom: 10px;">
                      Go to Your Dashboard
                    </a>
                  </td>
                </tr>
              </table>

              <div style="background-color: #d4edda; border-left: 4px solid #28a745; padding: 15px; margin: 20px 0;">
                <p style="color: #155724; font-size: 14px; margin: 0; line-height: 1.6;">
                  <strong>Pro tip:</strong> Complete your profile and add your gift wishes so others know what you'd love to receive! 🎁
                </p>
              </div>

              <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 20px 0;">
                Need help getting started? Check out your profile to personalize your account, or jump right in and create your first Secret Santa group!
              </p>
            </td>
          </tr>

          ${getUnsubscribeFooter(unsubscribeToken, "all")}

          <tr>
            <td style="background-color: #f8f9fa; padding: 10px 30px; text-align: center;">
              <p style="color: #999999; font-size: 11px; margin: 0;">
                &copy; 2025 Klaussified. All rights reserved.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}


// Helper function to generate unsubscribe footer with Support Us and Unsubscribe
export function getUnsubscribeFooter(
  unsubscribeToken: string,
  unsubscribeType: "invites" | "deadlines" | "all" = "all"
): string {
  const {appUrl} = APP_CONFIG;
  const unsubscribeUrl =
    `${appUrl}/unsubscribe?token=${unsubscribeToken}&type=${unsubscribeType}`;

  return `
    <tr>
      <td style="background-color: #f8f9fa; padding: 15px 30px; border-top: 1px solid #eeeeee;">
        <p style="color: #999999; font-size: 11px; margin: 0; text-align: center;">
          <a href="${appUrl}/about" style="color: #C41E3A; text-decoration: none;">About</a> |
          <a href="mailto:hello@klaussified.com" style="color: #C41E3A; text-decoration: none;">Contact Us</a> |
          <a href="https://ko-fi.com/nairdah" style="color: #C41E3A; text-decoration: none;">Support Us</a> |
          <a href="${unsubscribeUrl}" style="color: #C41E3A; text-decoration: none;">Unsubscribe</a>
        </p>
      </td>
    </tr>
  `;
}

