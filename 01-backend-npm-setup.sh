#!/bin/bash

# Uses jq command, test first that it is installed
test_json=$(echo "{ }" | jq)
if [ "$test_json" != "{}" ]; then
        echo "jq not installed, download from https://stedolan.github.io/jq/"
        exit 1
fi

# Take name from passed in arguement, or use default
backend_name=${1:-backend-task-manager}

mkdir $backend_name

cd $backend_name
# Initialise the project and create package.json
npm init -y

# Specifies configuration options for ts compiler
touch tsconfig.json
echo '{
    "compilerOptions": {
      "target": "es6",
      "module": "commonjs",
      "outDir": "dist/js",
      "rootDir": "src",
      "strict": true,
      "esModuleInterop": true,
      "forceConsistentCasingInFileNames": true
    },
    "include": ["src/**/*"],
    "exclude": ["src/types/*.ts", "node_modules", ".vscode"]
  }' > tsconfig.json

# Install required dependencies
npm install typescript

# Builds node.js server, handles http requests
npm install express 
  
# Automatically restarts erver
npm install nodemon 
  
# Object Domain Mapping (ODM) library for node.js and MongoDB
npm install mongoose 

# For Cross-Origin Resource Sharing
npm install cors 

# Install typescript types for packages
npm install @types/express @types/mongoose @types/dotenv @types/cors

# Stores ts files
mkdir src

# build Node.js server
touch src/app.ts
echo "import express, {Express} from 'express';
const app: Express = express();

app.use(express.json());

const PORT  = 5000;

app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`)
})" > src/app.ts

# Runs both server and client processes simultaneously
npm install concurrently

# Edit package.json to start concurrently
contents="$(jq '.scripts= {"start"}' package.json)" && \
echo -E "${contents}" > package.json

contents="$(jq '.scripts.start= "concurrently \"tsc -w\" \"nodemon dist/js/app\""' package.json)" && \
echo -E "${contents}" > package.json

# Start server
# npm start