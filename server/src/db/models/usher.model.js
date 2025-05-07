import { model, Schema } from "mongoose";
import bcrypt from "bcryptjs";
import { generateUniqueUsername } from "../../utils/usernameGenerator.js";

const usherSchema = new Schema(
  {
    firstName: { type: String, required: true, set: (val) => val.toLowerCase() },
    lastName: { type: String, required: true, set: (val) => val.toLowerCase() },
    email: { type: String, required: true, unique: true, lowercase: true },
    password: { type: String, required: true },
    userName: { type: String, unique: true },
    phone: { type: String, required: true, unique: true },
    gender: { type: String, required: true, enum: ["male", "female"] },
    address: { type: String },
    birthdate: { type: Date, required: true },
    experience: String,
    experienceLevel: { type: String },
    experienceRole: [{type : String }],
    feedback: [{ type: String }],
    profilePicture:   { type: String, default: "https://yourcdn.com/default-profile.png" },
    role: { type: String, default: "usher" },
    isConfirmed: { type: Boolean, default: false },
    expiresAt: { type: Date, default: () => Date.now() + 30 * 60 * 1000 },
    lastUserNameChange: { type: Date, default: null },
    jobs: [{ type: Schema.Types.ObjectId, ref: "Job" }],
    offers: [{ type: Schema.Types.ObjectId, ref: "Offer" }],
    resetOtp: { type: String, default: null },
    otpExpires: { type: Date, default: null },
    verificationCode: { type: String, default: null }
  },
  { timestamps: true }
);


usherSchema.pre("save", async function (next) {
  if (this.isConfirmed) {
    this.expiresAt = null; 
  }
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

usherSchema.pre("validate", async function (next) {
  if (!this.userName) {
    this.userName = await generateUniqueUsername(this.firstName, this.lastName);
  }
  next();
});

usherSchema.methods.canChangeUserName = function () {
  if (!this.lastUserNameChange) return true;
  const fourteenDays = 14 * 24 * 60 * 60 * 1000;
  return Date.now() - this.lastUserNameChange.getTime() > fourteenDays;
};

usherSchema.methods.updateUserName = async function (newUserName) {
  if (!this.canChangeUserName()) {
    throw new Error("You can only update your username every 14 days.");
  }
  this.userName = newUserName;
  this.lastUserNameChange = new Date();
  await this.save();
};

export const Usher = model("Usher", usherSchema);
