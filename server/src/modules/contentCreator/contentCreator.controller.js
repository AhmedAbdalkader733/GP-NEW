import { ContentCreator } from "../../db/models/contentCreator.model.js";



export const getContentCreatorProfile = async (req, res) => {
  try {
    const contentCreator = await ContentCreator.findById(req.user.id)
      .select("email phone gender fieldOfWork portfolioLinks offers profilePicture ")
      .populate("offers");

    if (!contentCreator) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({ profile: contentCreator });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};




export const updateContentCreatorProfile = async (req, res) => {
    try {
      const { phone, fieldOfWork, portfolioLinks } = req.body;
      const contentCreator = await ContentCreator.findById(req.user.id);
  
      if (!contentCreator) {
        return res.status(404).json({ message: "User not found" });
      }
  
      if (phone) contentCreator.phone = phone;
      if (fieldOfWork) contentCreator.fieldOfWork = fieldOfWork;
      if (portfolioLinks) contentCreator.portfolioLinks = portfolioLinks;
  
      await contentCreator.save();
      const updatedProfile = await ContentCreator.findById(req.user.id)
      .select("email phone gender fieldOfWork portfolioLinks offers profilePicture")
      .populate("offers");

    res.status(200).json({ message: "Profile updated successfully", profile: updatedProfile });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 

export const uploadProfilePicture = async (req, res) => {
  try {
    const contentCreator = await ContentCreator.findById(req.user.id);

    if (!contentCreator) {
      return res.status(404).json({ message: "User not found" });
    }

    contentCreator.profilePicture = req.file.path; // Save image path
    await contentCreator.save();

    res.status(200).json({ message: "Profile picture updated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
