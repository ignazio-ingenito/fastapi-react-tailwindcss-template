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
