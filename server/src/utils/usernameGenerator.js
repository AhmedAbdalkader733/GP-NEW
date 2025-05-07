import { Usher } from "../db/models/usher.model.js";
import { ContentCreator } from "../db/models/contentCreator.model.js";



export const generateUniqueUsername = async (firstName, lastName) => {
  let baseUsername = `${firstName.toLowerCase()}${lastName.toLowerCase()}`;
  let username = baseUsername;
  let counter = 1;

  while (
    await Usher.findOne({ userName: username }) ||
    await ContentCreator.findOne({ userName: username })
  ) {
    username = `${baseUsername}${counter}`;
    counter++;
  }

  return username;
};
