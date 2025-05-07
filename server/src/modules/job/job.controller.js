import { Job } from "../../db/models/job.model.js"; import { Usher } from "../../db/models/usher.model.js"; import axios from "axios"; // to call Python Flask API

export const createJob = async (req, res) => {
         try {
             const { title, description, startDate, endDate, startTime, endTime, location, numOfUshers, preferred_gender } = req.body;
             // 1️⃣ Create job in DB
   const job = new Job({
    title,
    description,
    startDate,
    endDate,
    startTime,
    endTime,
    location,
    numOfUshers,
    company: req.user.id
  });
  
  await job.save();
  
  // 2️⃣ Send data to Python AI recommender
  const response = await axios.post("http://your-ngrok-url.ngrok.io/recommend", {
    description,
    location,
    preferred_gender,
    numOfUshers
  });
  
  const recommendedUshers = response.data;
  
  // 3️⃣ Return both job info and recommended ushers
  res.status(201).json(
    { message: "Job created successfully",
    jobId: job._id,
    recommendedUshers 
});


             
         }
             
catch (error) { console.error(error); res.status(500).json({ message: "Something went wrong", error: error.message }); } };