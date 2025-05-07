    import express from "express";
    import connectDb from "./db/connection.js";
    import authRouter from "./modules/auth/auth.routes.js";
    import usherRouter from "./modules/usher/usher.routes.js"; 
    import companyRouter from "./modules/company/company.routes.js"
    import contentCreatorRouter from "./modules/contentCreator/contentCreator.routes.js";
    import JobRouter  from "./modules/job/job.routes.js";
    import cors from "cors";
    import path from "path";


    const bootstrap = async (app) => {
        app.use(cors());
        app.use(express.json());
        await connectDb();
        app.use("/auth", authRouter);
        app.use("/usher", usherRouter);
        app.use("/content-creator", contentCreatorRouter);
        app.use("/company",companyRouter);
        app.use("/jobs",JobRouter)
        app.all("*", (_, res) => res.status(404).json({ message: "Invalid URL" }));
        app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

    
    };

    export default bootstrap;
