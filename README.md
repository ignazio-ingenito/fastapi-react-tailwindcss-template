# WebApp template

This repo aimo help you building a webapp using

-  fastapi
-  react
-  typescript
-  tailwindcss
-  webpack

You can clone the repo and start playing with it or you can start from scratch follwing the guide below.

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

4. Edit your _package.json_ adding the following lines

```
"prewatch": "clear; npx postcss css/styles.css -o ../web/static/dist/styles.css --verbose --map",
"predev": "clear; npx postcss  css/styles.css -o ../web/static/dist/styles.css --verbose --map",
"prebuild": "clear; npx postcss  css/styles.css -o ../web/static/dist/styles.css --verbose",
```
