import { Usher } from "../db/models/usher.model.js";
import { ContentCreator } from "../db/models/contentCreator.model.js";
import { Company } from "../db/models/company.model.js";

const deleteUnconfirmedUsers = async () => {
  const now = new Date();

  await Usher.deleteMany({ isConfirmed: false, expiresAt: { $lt: now } });
  await ContentCreator.deleteMany({ isConfirmed: false, expiresAt: { $lt: now } });
  await Company.deleteMany({ isConfirmed: false, expiresAt: { $lt: now } });

  
};

export default deleteUnconfirmedUsers;
