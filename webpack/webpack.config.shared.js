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
      { test: /\.css$/, loader: "style-loader!css-loader" },
      { test: /\.scss$/, loaders: ["style", "css", "sass"] },
      { test: /\.png$/, loader: 'url-loader?limit=100000' },
      { test: /\.jpg$/, loader: 'file-loader' },
      { test: /\.svg$/, loader: 'file-loader' }
    ]
  }
};