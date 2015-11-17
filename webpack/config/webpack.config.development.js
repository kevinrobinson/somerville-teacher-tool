var path = require('path');
var sharedConfig = require('./webpack.config.shared.js');

var merge = function(first, second) {
  var merged = {}
  Object.keys(first).forEach(function(key) {
    merged[key] = first[key];
  });
  Object.keys(second).forEach(function(key) {
    merged[key] = second[key];
  });
  return merged;
};

module.exports = merge(sharedConfig, {
  output: {
    path: path.resolve('/mnt', 'build', 'dev'),
    publicPath: '/webpack_build/dev/',
    filename: 'webpack_bundle.js'
  },
  devtool: "source-map", // or "inline-source-map"
  watchOptions: {
    poll: true
  }
});