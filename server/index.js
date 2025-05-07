import cron from "node-cron";
import deleteUnconfirmedUsers from "./src/utils/deleteUnconfirmedUsers.js";
import express from "express";
import bootstrap from "./src/app.controller.js"; 


const app = express();
bootstrap(app, express); 

const port = 3000;
app.listen(port, () => {
    console.log("Server is running on port", port);
});

cron.schedule("*/5 * * * *", () => {
    console.log("🕒 Running cleanup job to delete unconfirmed users...");
    deleteUnconfirmedUsers();
  });

  