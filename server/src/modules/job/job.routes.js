import { Router } from "express"; import { createJob } from "./job.controller.js"; import authMiddleware from "../../middlewares/auth.middleware.js";

const router = Router();

router.post("/", authMiddleware, createJob);

export default router;