import { Router } from "express";
import { getUsherProfile, updateUsherProfile, completeUsherProfile } from "./usher.controller.js";
import authMiddleware from "../../middlewares/auth.middleware.js";
import { validateUsherProfile } from "../../middlewares/usher.validation.js";
import { validateRequest } from "../../middlewares/validateRequest.js";
import upload from "../../utils/multer.js";
import { uploadUsherProfilePicture } from "./usher.controller.js";


const router = Router();

router.get("/profile", authMiddleware, getUsherProfile);
router.patch("/profile", authMiddleware, validateUsherProfile, validateRequest, updateUsherProfile);
router.post("/complete-profile", authMiddleware, validateUsherProfile, validateRequest, completeUsherProfile);
router.patch("/profile/upload-picture",authMiddleware,upload.single( "profilePicture" )  , uploadUsherProfilePicture );
  

export default router;
