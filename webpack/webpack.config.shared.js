var path = require('path');

module.exports = {
  entry: {
    app: ['./src/index.js']
  },
  resolve: {
    extensions: ['', '.js']
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loaders: ["style", "css", "sass"] }
    ]
  }
};