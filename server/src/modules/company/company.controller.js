import { Company } from "../../db/models/company.model.js";
import { Job } from "../../db/models/job.model.js";

export const getCompanyProfile = async (req, res) => {
  try {
    const companyId =  req.user.id;

    const company = await Company.findById(companyId).select("name email phone address profilePicture").lean();
    if (!company) return res.status(404).json({ message: "Company not found" });

    const now = new Date();

    const jobs = await Job.find({ company: companyId }).select("title startDate endDate");

    const previousProjects = jobs.filter(job => job.endDate < now);
    const inProgressProjects = jobs.filter(job => job.startDate <= now && job.endDate >= now);

    res.json({
      ...company,
      previousProjects,
      inProgressProjects
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
export const updateCompanyProfile = async (req, res) => {
    try {
      const companyId = req.user.id;
  
      const allowedFields = ["name", "phone", "address"];
      const updates = {};
  
      for (let key of allowedFields) {
        if (req.body[key]) updates[key] = req.body[key];
      }
  
      const updatedCompany = await Company.findByIdAndUpdate(
        companyId,
        updates,
        { new: true, runValidators: true }
      ).select("name phone address profilePicture");
  
      if (!updatedCompany) {
        return res.status(404).json({ message: "Company not found" });
      }
  
      res.json({ message: "Company profile updated", company: updatedCompany });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  };
  