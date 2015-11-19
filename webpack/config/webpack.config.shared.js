var path = require('path');

module.exports = {
  entry: {
    app: ['./src/index.js']
  },
  resolve: {
    extensions: ['', '.js']
  },
  module: {
    noParse: '/(\.min\.js|\.min\.css)$/',
    loaders: [
      { test: /\.css$/, loader: "style-loader!css-loader" },
      { test: /\.scss$/, loaders: ["style", "css", "sass"] },
      { test: /\.png$/, loader: 'url-loader?limit=100000' },
      { test: /\.jpg$/, loader: 'file-loader' },
      { test: /\.svg$/, loader: 'file-loader' },
      { test: /\.jsx$/, loader: 'babel', query: {
        cacheDirectory: true,
        presets: ['es2015', 'react', 'stage-2']
      } }
    ]
  }
};