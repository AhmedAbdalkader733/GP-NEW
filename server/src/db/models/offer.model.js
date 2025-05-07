import { model, Schema } from "mongoose";

const offerSchema = new Schema(
  {
    job: { type: Schema.Types.ObjectId, ref: "Job", required: true },
    company: { type: Schema.Types.ObjectId, ref: "Company", required: true },
    ushers: [{ type: Schema.Types.ObjectId, ref: "Usher" }],
    contentCreators: [{ type: Schema.Types.ObjectId, ref: "ContentCreator" }],
    requiredPositions: { type: Number, required: true }, // Number of people needed
    acceptedCount: { type: Number, default: 0 }, // Track how many accepted
    isAvailable: { type: Boolean, default: true },
  },
  { timestamps: true }
);

export const Offer = model("Offer", offerSchema);
