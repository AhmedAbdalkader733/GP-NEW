import { Router } from "express";
import { registerUsher, registerContentCreator, registerCompany, login, verifyEmail } from "./auth.controller.js";import authMiddleware from "../../middlewares/auth.middleware.js";
import { registerSchema, loginSchema } from "./auth.validation.js";
import { forgotPassword ,  verifyOtp , resetPassword ,  } from "./forgotPassword.controller.js";


const router = Router();

router.post("/register/usher", registerUsher);
router.post("/register/content-creator", registerContentCreator);
router.post("/register/company", registerCompany);
router.post("/login", login);
router.post("/forgot-password", forgotPassword);
router.post("/verify-otp", verifyOtp);
router.post("/reset-password", resetPassword);
router.post("/verify-email", verifyEmail);


router.get("/protected", authMiddleware, (req, res) => {
    res.json({ message: "You have access!", user: req.user });
});

export default router;
