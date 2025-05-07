// import { Usher } from "../../db/models/usher.model";

// export const registerUsher = async (req, res, next) => {
//   try {
   
//       const {userName,email,password,phone,gender,birthdate} = req.body;

      
//       const createdUsher = await Usher.create({userName,email,password,phone,gender,birthdate});


//   } catch (error) {
//     return res
//       .status(500)
//       .json({ success: false, message: error.message, error });
//   }
// };



// export const registerContent = (req, res, next) => {
//   try {
//   const {} = req.body;


// } catch (error) {
// return res
//   .status(500)
//   .json({ success: false, message: error.message, error });
// }};



// export const registerCompany = (req, res, next) => {
//   try {
//   const {} = req.body;


// } catch (error) {
// return res
//   .status(500)
//   .json({ success: false, message: error.message, error });
// }};

// export const loginUsher = (req, res, next) => {};
// export const loginContent = (req, res, next) => {};
// export const loginCompany = (req, res, next) => {};
