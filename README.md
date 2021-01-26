# WebApp template

This repo aim to help you to build a webapp using

-  fastapi
-  react
-  typescript
-  tailwindcss
-  webpack

You can either clone the repo and start playing with it or start from scratch follwing the below guide.

## Python

```
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

# React

For more info read https://create-react-app.dev/docs/adding-typescript/

1. Create files and folders

```
mkdir js
cd js
npm init -y
npm install --save-dev react react-dom typescript @types/react @types/react-dom
npm install --save-dev webpack webpack-cli webpack-dev-server
npm install --save-dev ts-loader style-loader css-loader file-loader babel-loader

touch App.tsx
touch tsconfig.json
touch webpack.config.js
```

2. Edit App.tsx

```
import React from "react"
import ReactDom from "react-dom"

interface AppProps {
    userName: string;
    language: string;
}

const App = (props: AppProps) => (
  <h1>
    Hello world !!!
  </h1>
)

ReactDom.render(
    <App userName="user" language="en"/>,
    document.getElementById("app")
)
```

3. Edit tsconfig.json

```
{
    "compilerOptions": {
        "jsx": "react",
        "target": "es6",
        "module": "es6",
        "sourceMap": true,
        "strict": true,
        "moduleResolution": "node",
        "noImplicitAny": true,
        "esModuleInterop": true,
    },
}
```

4. Edit webpack.config.js

```
module.exports = {
   entry: {
      main: "./app.tsx",
   },
   resolve: {
      extensions: [".js", ".json", ".ts", ".tsx"],
   },
   module: {
      rules: [
         {
            test: /\.js$/,
            exclude: /node_modules/,
            use: {
               loader: "babel-loader",
               options: {
                  presets: ["@babel/preset-env", "@babel/preset-react"],
                  plugins: ["@babel/plugin-proposal-object-rest-spread"],
               },
            },
         },
         {
            test: /\.(svg|png|jpg|jpeg|gif)$/,
            loader: "file-loader",
            exclude: /node_modules/,
            options: {
               name: "[name].[ext]",
               outputPath: "../../static/dist",
            },
         },
         {
            test: /\.css$/i,
            use: ["style-loader", "css-loader"],
         },
         {
            test: /\.(ts|tsx)$/,
            use: "ts-loader",
            exclude: /node_modules/,
         },
      ],
   },
   output: {
      path: __dirname + "/../web/static/dist",
      filename: "[name].bundle.js",
   },
   devtool: "source-map",
}
```

5. Edit package.json adding in the _scripts_ section

```
    "watch": "webpack --watch --mode development --color --progress",
    "dev": "webpack --mode development --color --progress",
    "build": "webpack --mode production --color --progress"
```

# Add TailwindCSS

```
npm --save-dev install tailwindcss postcss-cli autoprefixer
```

1. Initialize TailwindCSS by creating the default configurations

```
npx tailwind init tailwind.js --full
```

2. Configure TailwindCSS

```
touch postcss.config.js
```

and add the below code

```
const tailwindcss = require('tailwindcss');
module.exports = {
    plugins: [
        tailwindcss('./tailwind.js'),
        require('autoprefixer')
    ],
};
```

3. create the _styles.css_ source for TailwindCSS

```
mkdir css
```

edit the _styles.css_

```
@tailwind base;

@tailwind components;

@tailwind utilities;

* {
   margin: 0;
   padding: 0;
   box-sizing: border-box;
}

body {
   font-size: 14px;
   font-family: 'Open Sans';
}
```
4. Install concurrently to run `postcss` and `webpack` in watch mode at the same time

```
npm install --save-dev concurrently
```
 
5. Edit your _package.json_ adding the following lines

```
"prewatch": "clear; npx postcss css/styles.css -o ../web/static/dist/styles.css --verbose --map",
"predev": "clear; npx postcss  css/styles.css -o ../web/static/dist/styles.css --verbose --map",
"prebuild": "clear; npx postcss  css/styles.css -o ../web/static/dist/styles.css --verbose",
```

# Docker

### Create a Docker image

```
FROM python:3.7.9-slim

ENV ENV debug
ENV LC_ALL C.UTF-8
ENV TERM xterm-256color
ENV PYTHONUNBUFFERED True

EXPOSE 8080

# copy the files
COPY ./web /web
COPY requirements.txt /web/requirements.txt

# update the image
RUN apt-get update && \
    apt-get upgrade -y


# install libsndfile1
RUN apt-get install libsndfile1 -y

# install node - Node.js LTS (v14.x)
# from https://github.com/nodesource/distributions 
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# install the React app
WORKDIR /web/js
RUN npm install && \
    npm audit fix && \
    npm run build

# the the working dir
WORKDIR /web

# install the python dependencies
RUN pip install -r /web/requirements.txt

# setup gsutil
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y      

# PRODUCTION
CMD exec gunicorn --bind 0.0.0.0:8080 --workers 1 --worker-class uvicorn.workers.UvicornWorker --timeout 180  --threads 8 app:app
# - DEVELOPMENT
#   - gunicorn
#       CMD exec gunicorn --reload --bind 0.0.0.0:8080 --workers 1 --worker-class uvicorn.workers.UvicornWorker  --threads 8 app:app
#   - uvicorn
#       CMD exec uvicorn --reload --host 0.0.0.0 --port 8080 app:app
```

### Play with Docker

#### build
```docker build -t tagger:latest .```
#### run
```
docker run -p 8080:8080 tagger:latest
docker run -p 8080:8080 -v `pwd`/web:/web tagger:latest
```
#### sh into if running
```docker exec -it tagger:latest /bin/bash```
#### sh into if not running
```docker run -it -p 8080:8080 tagger:latest /bin/bash```

# Cloud run

### build and push a new image
```gcloud builds submit --tag eu.gcr.io/bling-movetocloud/miner:latest```

### deploy an image
```gcloud beta run deploy --image eu.gcr.io/bling-movetocloud/miner:latest --platform managed --region europe-west1```
