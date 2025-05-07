import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const authMiddleware = (req, res, next) => {
    try {
        if (!req.headers?.authorization) {
            return res.status(401).json({ message: "Access Denied: No token provided" });
        }

        const authHeader = req.headers.authorization;
        if (!authHeader.startsWith("Bearer ")) {
            return res.status(401).json({ message: "Invalid token format" });
        }

        const token = authHeader.split(" ")[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        if (!decoded) {
            return res.status(403).json({ message: "Invalid token" });
        }

        req.user = decoded;

        console.log("🔹 Decoded Token:", decoded); // Debugging (Remove later)

        if (!req.user.isConfirmed) {
            return res.status(403).json({ message: "Email not verified. Please verify your email to proceed." });
        }

        next();
    } catch (error) {
        console.error("❌ Middleware Error:", error.message);
        return res.status(403).json({ message: "Invalid token" });
    }
};

export default authMiddleware;
