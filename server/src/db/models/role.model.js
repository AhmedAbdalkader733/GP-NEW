import { model, Schema } from "mongoose"
import { type } from "os";




const roleSchema = new Schema(
    {
     email :{ type : String , required : true , unique : true , lowercase : true } ,
     password : {type: String ,required : true } ,
     userName :{ type : String , required : true , unique : true  },
     phone : {type : String , required : true , unique : true } ,
     gender : {type : String , required : true ,enum : Object.values(genders) },
     address :{type : String  } ,
     birthdate: { type: Date, required: true },
     experience: { type: String },
     feedback : [{type : String}], //arry
     profilePicture: { type: String , required : true}, // to do cloud
     role : {type : String , default : "usher" },
     isConfirmed : {type : Boolean , default : false },
     jobs: [{ type: Schema.Types.ObjectId, ref: 'Job' }],
     offers : [{type : Schema.Types.ObjectId , ref : 'Offer'}]

    },
    {
    timestamps : true,
    }
);


// model


export const Usher = model("usher",usherSchema);