import express from "express";
import { getCompanyProfile, updateCompanyProfile } from "./company.controller.js";
import authMiddleware from "../../middlewares/auth.middleware.js";

const router = express.Router();

router.get("/profile", authMiddleware, getCompanyProfile);
router.patch("/profile", authMiddleware, updateCompanyProfile);

export default router;
