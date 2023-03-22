#!/bin/bash

# Take name from passed in arguement, or use default
backend_name=${1:-backend-task-manager}

# Create database folders
# if [ ! -d "C:\data\db" ]; then
#   echo "C:\data\db does not exist, creating"
#   mkdir "C:\data"
#   mkdir "C:\data\db"
# fi

# touch ~/.bash_profile

# echo 'alias mongod="/c/Program\ files/MongoDB/Server/6.0/bin/mongod.exe"' >>~/.bash_profile

# source ~/.bash_profile

echo "import express, { Express } from 'express';
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
    console.log(`MongoDB connection error: ${err}`);
  });

app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});" > $backend_name/src/app.ts