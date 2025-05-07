import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config(); 

async function connectDb() {
  try {
    await mongoose.connect(process.env.DB_URL); 
    console.log("✅ Database connected successfully");
  } catch (error) {
    console.error("❌ Failed to connect to DB:", error.message);
    process.exit(1); 
  }
}

export default connectDb;
