import crypto from "crypto";
import { Usher } from "../../db/models/usher.model.js";
import { Company } from "../../db/models/company.model.js";
import { ContentCreator } from "../../db/models/contentCreator.model.js";
import dotenv from "dotenv";
import bcrypt from "bcryptjs";
import nodemailer from "nodemailer";

dotenv.config();

const findUserByEmail = async (email) => {
  return (
    (await Usher.findOne({ email })) ||
    (await ContentCreator.findOne({ email })) ||
    (await Company.findOne({ email }))
  );
};

const sendEmail = async (email, subject, message, isHtml = false) => {
  try {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    const mailOptions = {
      from: `"Ushreel Support" <${process.env.EMAIL_USER}>`,
      to: email,
      subject: subject,
      [isHtml ? "html" : "text"]: message,
    };

    await transporter.sendMail(mailOptions);
    return true;
  } catch {
    return false;
  }
};

export const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await findUserByEmail(email);
    if (!user) return res.status(404).json({ message: "User not found" });

    const otp = crypto.randomInt(100000, 999999).toString();
    user.resetOtp = otp;
    user.otpExpires = Date.now() + 5 * 60 * 1000;
    await user.save();

    const emailSent = await sendEmail(
      email,
      "Password Reset OTP",
      `Your OTP for password reset is: ${otp}. It expires in 5 minutes.`,
      false
    );

    if (!emailSent) return res.status(500).json({ message: "Failed to send OTP email" });

    res.json({ message: "OTP sent to email" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const user = await findUserByEmail(email);
    if (!user) return res.status(404).json({ message: "User not found" });

    if (!user.resetOtp || user.resetOtp !== otp || Date.now() > user.otpExpires) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    res.json({ message: "OTP verified successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const resetPassword = async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body;
    const user = await findUserByEmail(email);
    if (!user) return res.status(404).json({ message: "User not found" });

    if (!user.resetOtp || user.resetOtp !== otp || Date.now() > user.otpExpires) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    user.password = newPassword;
    user.resetOtp = null;
    user.otpExpires = null;
    await user.save();

    res.json({ message: "Password reset successfully. You can now log in with your new password." });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
