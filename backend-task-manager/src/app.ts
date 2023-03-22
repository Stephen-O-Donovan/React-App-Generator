import express, { Express } from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app: Express = express();
const PORT: string | number = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const uri: string = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/task-manager';
mongoose.connect(uri)
  .then(() => {
    console.log('MongoDB connected successfully...');
  })
  .catch((err) => {
    console.log();
  });

app.listen(PORT, () => {
  console.log();
});
