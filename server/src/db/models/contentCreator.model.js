import { model, Schema } from "mongoose";
import bcrypt from "bcryptjs";
import { generateUniqueUsername } from "../../utils/usernameGenerator.js";
import { Offer } from "./offer.model.js";

const contentCreatorSchema = new Schema(
  {
    firstName: { type: String, required: true, set: (val) => val.toLowerCase() },
    lastName: { type: String, required: true, set: (val) => val.toLowerCase() },
    email: { type: String, required: true, unique: true, lowercase: true },
    password: { type: String, required: true },
    userName: { type: String, unique: true },
    phone: { type: String, required: true, unique: true },
    gender: { type: String, required: true, enum: ["male", "female"] },
    address: String,
    birthdate: { type: Date, required: true },
    experience: String,
    portfolioLinks: {
      website: {
        type: String,
        validate: {
          validator: function(v) {
            if (!v) return true;
            return /^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$/.test(v);
          },
          message: "Invalid website URL"
        },
        trim: true,
        lowercase: true
      },
      facebook: {
        type: String,
        validate: {
          validator: function(v) {
            if (!v) return true;
            return /^(https?:\/\/)?(www\.)?facebook\.com\/(profile\.php\?id=\d+|[a-zA-Z0-9.]+)\/?$/.test(v);
          },
          message: "Must be a valid Facebook profile URL"
        },
        trim: true,
        lowercase: true
      },
      instagram: {
        type: String,
        validate: {
          validator: function(v) {
            if (!v) return true;
            return /^(https?:\/\/)?(www\.)?instagram\.com\/([a-zA-Z0-9._]+)\/?$/.test(v);
          },
          message: "Must be a valid Instagram profile URL"
        },
        trim: true,
        lowercase: true
      },
      youtube: {
        type: String,
        validate: {
          validator: function(v) {
            if (!v) return true;
            return /^(https?:\/\/)?(www\.)?youtube\.com\/(c\/|channel\/|user\/)?([a-zA-Z0-9_-]+)\/?$/.test(v);
          },
          message: "Must be a valid YouTube channel URL"
        },
        trim: true,
        lowercase: true
      },
      tiktok: {
        type: String,
        validate: {
          validator: function(v) {
            if (!v) return true;
            return /^(https?:\/\/)?(www\.)?tiktok\.com\/@([a-zA-Z0-9._-]+)\/?$/.test(v);
          },
          message: "Must be a valid TikTok profile URL"
        },
        trim: true,
        lowercase: true
      }
    },
    fieldOfWork: { type: [String], required: true },
    feedback: [{ type: String }],
    profilePicture: { type: String, default: "https://yourcdn.com/default-profile.png" },
    role: { type: String, default: "contentCreator" },
    isConfirmed: { type: Boolean, default: false },
    lastUserNameChange: { type: Date, default: null },
    jobs: [{ type: Schema.Types.ObjectId, ref: "Job" }],
    offers: [{ type: Schema.Types.ObjectId, ref: "Offer" }],
    resetOtp: { type: String, default: null },
    otpExpires: { type: Date, default: null },
    verificationCode: { type: String, default: null }
  },
  { timestamps: true }
);

contentCreatorSchema.pre("save", async function (next) {
  try {
    // Normalize social links
    if (this.portfolioLinks) {
      for (const [platform, url] of Object.entries(this.portfolioLinks)) {
        if (url && !url.startsWith('http')) {
          this.portfolioLinks[platform] = `https://${url}`;
        }
      }
    }
    
    // Existing pre-save logic
    if (this.firstName) this.firstName = this.firstName.toLowerCase();
    if (this.lastName) this.lastName = this.lastName.toLowerCase();
    if (this.email) this.email = this.email.toLowerCase();
    if (this.isConfirmed) {
      this.expiresAt = null;
    }
   
    if (this.isModified("password") && this.password) {
      this.password = await bcrypt.hash(this.password, 10);
    }

    next();
  } catch (err) {
    next(err);
  }
});


// Rest of your existing methods...
contentCreatorSchema.pre("validate", async function (next) {
  if (!this.userName) {
    this.userName = await generateUniqueUsername(this.firstName, this.lastName);
  }
  next();
});

contentCreatorSchema.methods.canChangeUserName = function () {
  if (!this.lastUserNameChange) return true;
  const fourteenDays = 14 * 24 * 60 * 60 * 1000;
  return Date.now() - this.lastUserNameChange.getTime() > fourteenDays;
};

contentCreatorSchema.methods.updateUserName = async function (newUserName) {
  if (!this.canChangeUserName()) {
    throw new Error("You can only update your username every 14 days.");
  }
  this.userName = newUserName;
  this.lastUserNameChange = new Date();
  await this.save();
};

export const ContentCreator = model("ContentCreator", contentCreatorSchema);