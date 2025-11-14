import * as nodemailer from "nodemailer";
import {APP_CONFIG} from "../config/constants";

export interface EmailOptions {
  to: string;
  subject: string;
  html: string;
  replyTo?: string;
  from?: string;
}

export class EmailService {
  private transporter: nodemailer.Transporter;

  constructor() {
    this.transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST || "smtp.gmail.com",
      port: parseInt(process.env.SMTP_PORT || "587"),
      secure: false,
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
    });
  }

  async sendEmail(options: EmailOptions): Promise<void> {
    try {
      const fromEmail = options.from || APP_CONFIG.supportEmail;
      await this.transporter.sendMail({
        from: `"${APP_CONFIG.appName}" <${fromEmail}>`,
        replyTo: options.replyTo || APP_CONFIG.supportEmail,
        to: options.to,
        subject: options.subject,
        html: options.html,
      });
      console.log(`Email sent successfully to ${options.to}`);
    } catch (error) {
      console.error(`Failed to send email to ${options.to}:`, error);
      throw error;
    }
  }
}

export const emailService = new EmailService();
