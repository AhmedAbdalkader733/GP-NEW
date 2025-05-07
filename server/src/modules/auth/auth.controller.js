import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import crypto from "crypto";
import nodemailer from "nodemailer";
import dotenv from "dotenv";
import { Usher } from "../../db/models/usher.model.js";
import { Company } from "../../db/models/company.model.js";
import { ContentCreator } from "../../db/models/contentCreator.model.js";

dotenv.config();

const generateToken = (user) => {
  return jwt.sign(
    { id: user._id, role: user.role, isConfirmed: user.isConfirmed }, 
    process.env.JWT_SECRET, 
    { expiresIn: process.env.JWT_EXPIRATION }
  );
};



const sendEmail = async (email, subject, message) => {
  try {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS },
    });

    await transporter.sendMail({
      from: `"Ushreel Support" <${process.env.EMAIL_USER}>`,
      to: email,
      subject,
      text: message,
    });

    return true;
  } catch (error) {
    return false;
  }
};

const isEmailOrPhoneTaken = async (email, phone) => {
  return (
    (await Usher.findOne({ $or: [{ email }, { phone }] })) ||
    (await ContentCreator.findOne({ $or: [{ email }, { phone }] })) ||
    (await Company.findOne({ $or: [{ email }, { phone }] }))
  );
};

export const registerUsher = async (req, res) => {
  try {
    const { email, phone, password, firstName, lastName, gender, birthdate ,address } = req.body;
    if (!email || !phone || !password || !firstName || !lastName) {
      return res.status(400).json({ message: "All fields are required" });
    }
    if (await isEmailOrPhoneTaken(email, phone)) {
      return res.status(400).json({ message: "Email or phone number already exists" });
    }

    const verificationCode = crypto.randomInt(100000, 999999).toString();
    const usher = new Usher({ email, phone, password, firstName, lastName, gender, birthdate, verificationCode , address });
    await usher.save();

    const emailSent = await sendEmail(email, "Email Verification Code", `Your verification code: ${verificationCode}`);
    if (!emailSent) {
      return res.status(500).json({ message: "Failed to send verification email" });
    }

    res.status(201).json({ message: "Usher registered successfully. Please verify your email." });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const registerContentCreator = async (req, res) => {
  try {
    const { email, phone, password, firstName, lastName, gender, birthdate, fieldOfWork } = req.body;
    if (!email || !phone || !password || !firstName || !lastName || !fieldOfWork) {
      return res.status(400).json({ message: "All fields are required" });
    }
    if (await isEmailOrPhoneTaken(email, phone)) {
      return res.status(400).json({ message: "Email or phone number already exists" });
    }

    const verificationCode = crypto.randomInt(100000, 999999).toString();
    const contentCreator = new ContentCreator({
      email, phone, password, firstName, lastName, gender, birthdate, fieldOfWork, verificationCode
    });
    await contentCreator.save();

    const emailSent = await sendEmail(email, "Email Verification Code", `Your verification code: ${verificationCode}`);
    if (!emailSent) {
      return res.status(500).json({ message: "Failed to send verification email" });
    }

    res.status(201).json({ message: "Content Creator registered successfully. Please verify your email." });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const registerCompany = async (req, res) => {
  try {
    const { email, phone, password, name, address } = req.body;
    if (!email || !phone || !password || !name) {
      return res.status(400).json({ message: "All fields are required" });
    }
    if (await isEmailOrPhoneTaken(email, phone)) {
      return res.status(400).json({ message: "Email or phone number already exists" });
    }

    const verificationCode = crypto.randomInt(100000, 999999).toString();
    const company = new Company({ email, phone, password, name, address, verificationCode });
    await company.save();

    const emailSent = await sendEmail(email, "Email Verification Code", `Your verification code: ${verificationCode}`);
    if (!emailSent) {
      return res.status(500).json({ message: "Failed to send verification email" });
    }

    res.status(201).json({ message: "Company registered successfully. Please verify your email." });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const verifyEmail = async (req, res) => {
  try {
    const { email, verificationCode } = req.body;
    const user = 
      (await Usher.findOne({ email })) ||
      (await ContentCreator.findOne({ email })) ||
      (await Company.findOne({ email }));

    if (!user) return res.status(404).json({ message: "User not found" });
    if (user.isConfirmed) return res.status(400).json({ message: "Email already verified" });
    if (user.verificationCode !== verificationCode) return res.status(400).json({ message: "Invalid verification code" });

    user.isConfirmed = true;
    user.verificationCode = null;
    await user.save();

    res.json({ message: "Email verified successfully. You can now log in." });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

  export const login = async (req, res) => {
    try {
      const { emailOrPhoneOrUsername, password } = req.body;

      let user =
        (await Usher.findOne({ $or: [{ email: emailOrPhoneOrUsername }, { phone: emailOrPhoneOrUsername }, { userName: emailOrPhoneOrUsername }] })) ||
        (await ContentCreator.findOne({ $or: [{ email: emailOrPhoneOrUsername }, { phone: emailOrPhoneOrUsername }, { userName: emailOrPhoneOrUsername }] })) ||
        (await Company.findOne({ $or: [{ email: emailOrPhoneOrUsername }, { phone: emailOrPhoneOrUsername }] }));

      if (!user) return res.status(400).json({ message: "Invalid credentials" });
      if (!user.isConfirmed) return res.status(403).json({ message: "Email verification required", redirect: "/verify-email" });

      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

      const token = generateToken(user);

    
      res.cookie("token", token, {
        httpOnly: true, 
        secure: process.env.NODE_ENV === "production", 
        sameSite: "Strict", 
      });
      res.json({ message: "Login successful", token, role: user.role });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }





  };
