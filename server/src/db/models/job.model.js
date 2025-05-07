import { model, Schema } from "mongoose";

const jobSchema = new Schema(
  {
    title: { type: String, required: true },
    description: { type: String },

    company: { type: Schema.Types.ObjectId, ref: "Company", required: true },

    ushers: [{ type: Schema.Types.ObjectId, ref: "Usher" }],
    contentCreators: [{ type: Schema.Types.ObjectId, ref: "ContentCreator" }],

    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },

    startTime: { type: String, required: true }, // : "09:00"
    endTime: { type: String, required: true },   // : "18:00"

    location: { type: String, required: true },

    numOfUshers: {
      type: Number,
      required: true,
      min: [1, "Minimum number of ushers is 1"],
      max: [200, "Maximum number of ushers is 200"],
    },
  },
  { timestamps: true }
);

export const Job = model("Job", jobSchema);
