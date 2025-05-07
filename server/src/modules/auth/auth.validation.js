import Joi from "joi";

export const registerSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  userName: Joi.string().min(3).required(),
  phone: Joi.string().min(10).required(),
  gender: Joi.string().valid("male", "female"),
  role: Joi.string().valid("usher", "contentCreator", "company").required(),
});

export const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});
