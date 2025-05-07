import { Usher } from "../../db/models/usher.model.js";
import axios from "axios";


export const getUsherProfile = async (req, res) => {
  try {
    const usher = await Usher.findById(req.user.id).select("-password ");
    if (!usher) return res.status(404).json({ message: "User not found" });

    res.status(200).json({ profile: usher });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


export const updateUsherProfile = async (req, res) => {
  try {
    const { firstName, lastName, profilePicture, phone, address, userName, experience } = req.body;
    const usher = await Usher.findById(req.user.id);
if (!usher) return res.status(404).json({ message: "User not found" });

if (userName && !usher.canChangeUserName()) {
  return res.status(400).json({ message: "You can only update your username every 14 days." });
}


if (firstName) usher.firstName = firstName;
if (lastName) usher.lastName = lastName;
if (profilePicture) usher.profilePicture = profilePicture;
if (phone) usher.phone = phone;
if (address) usher.address = address;
if (userName) {
  usher.userName = userName;
  usher.lastUserNameChange = new Date();
}
if (experience !== undefined) {
  usher.experience = experience;


  try {
    const aiResponse = await axios.post("http://127.0.0.1:5000/predict", {
      experience: experience,
      gender: usher.gender || "unspecified"
    });

    const { experienceLevel, experienceTask } = aiResponse.data;
    if (experienceLevel) usher.experienceLevel = experienceLevel;
    if (experienceTask && Array.isArray(experienceTask)) usher.experienceRole = experienceTask;
  } catch (aiError) {
    console.error("AI model prediction failed:", aiError.message);
   
  }
}

  await usher.save();

  const selectedProfileData = {
  firstName: usher.firstName,
  lastName: usher.lastName,
  email: usher.email,
  experience: usher.experience,
  experienceLevel: usher.experienceLevel,
  experienceRole: usher.experienceRole,
  username: usher.userName,
  profilePicture: usher.profilePicture,
};

res.status(200).json({ message: "Profile updated successfully", profile: selectedProfileData });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};




export const completeUsherProfile = async (req, res) => {
  
  const { experience } = req.body;
  const usher = await Usher.findById(req.user.id);

  if (!usher) {
    return res.status(404).json({ message: "User not found" });
  }
  
  if (usher.experience) {
    return res.status(400).json({
      message: "Experience already added. Use /profile to edit it.",
    });
  }
  
  // 1️⃣ Save experience to DB
  if (experience !== undefined) {
    usher.experience = experience;
  }
  
  // 2️⃣ Try to send data to AI model
  try {
    const aiResponse = await axios.post("http://127.0.0.1:5000/predict", {
      experience: usher.experience,
      gender: usher.gender,
    });
  
    const { experienceLevel, experienceTask } = aiResponse.data;
  
    // 3️⃣ Save AI predictions
    usher.experienceLevel = experienceLevel;
    usher.experienceRole = Array.isArray(experienceTask)
      ? experienceTask
      : experienceTask.split(",").map((role) => role.trim());
  
  } catch (aiError) {
    console.error("❌ AI Prediction Error:", aiError.message);
    // Optional: continue without predictions or use fallback values
    // usher.experienceLevel = "Unknown";
    // usher.experienceRole = [];
  }
  
  await usher.save();
  
  return res.status(200).json({
    message: "Profile completed successfully.",
    profile: usher,
  });
  
};




export const uploadUsherProfilePicture = async (req, res) => {
  try {
    const usher = await Usher.findById(req.user.id);

    if (!usher) {
      return res.status(404).json({ message: "User not found" });
    }

    usher.profilePicture = req.file.path; // Save image path
    await usher.save();

    res.status(200).json({ message: "Profile picture updated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
