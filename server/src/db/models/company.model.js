import { model, Schema } from "mongoose";
import bcrypt from "bcryptjs";

const companySchema = new Schema(
  {
    name: { type: String, required: true, set: (val) => val.toLowerCase() },
    email: { type: String, required: true, unique: true, lowercase: true },
    password: { type: String, required: true },
    phone: { type: String, required: true, unique: true },
    address: String,
    profilePicture: { type: String, default: "https://yourcdn.com/default-profile.png" },
    role: { type: String, default: "company" },
    isConfirmed: { type: Boolean, default: false },
    jobs: [{ type: Schema.Types.ObjectId, ref: "Job" }],
    resetOtp: { type: String, default: null },
    otpExpires: { type: Date, default: null },
    verificationCode: { type: String, default: null }
  },
  { timestamps: true }
);

companySchema.pre("save", async function (next) {
  if (this.isConfirmed) {
    this.expiresAt = null; 
  }
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

companySchema.methods.clearOtp = async function () {
  this.resetOtp = null;
  this.otpExpires = null;
  await this.save();
};

export const Company = model("Company", companySchema);
