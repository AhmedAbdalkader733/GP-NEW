import { Router } from "express";
import * as controller from "./contentCreator.controller.js";
import authMiddleware from "../../middlewares/auth.middleware.js";
import upload from "../../utils/multer.js";
import { uploadProfilePicture } from "./contentCreator.controller.js";


const router = Router();

router.get("/profile", authMiddleware, controller.getContentCreatorProfile);
router.patch("/profile", authMiddleware, controller.updateContentCreatorProfile);
router.patch( "/profile/upload-picture", authMiddleware, upload.single("profilePicture"), uploadProfilePicture );


export default router;
