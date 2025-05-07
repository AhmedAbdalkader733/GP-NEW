import { body } from "express-validator";

export const validateUsherProfile = [
  body("firstName")
    .optional()
    .trim()
    .notEmpty().withMessage("First name cannot be empty."),
  
  body("lastName")
    .optional()
    .trim()
    .notEmpty().withMessage("Last name cannot be empty."),
  
  body("phone")
    .optional()
    .matches(/^\+?[0-9]{10,15}$/)
    .withMessage("Invalid phone number format."),
  
  body("address")
    .optional()
    .trim()
    .notEmpty().withMessage("Address cannot be empty."),

  body("userName")
    .optional()
    .trim()
    .notEmpty().withMessage("Username cannot be empty."),

  body("experience")
    .optional() 
];
