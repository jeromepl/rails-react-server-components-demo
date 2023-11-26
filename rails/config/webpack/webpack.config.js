// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker');
const ReactServerWebpackPlugin = require('react-server-dom-webpack/plugin');

const isProduction = process.env.NODE_ENV === 'production';
const config =
  {
    mode: isProduction ? 'production' : 'development',
    devtool: isProduction ? 'source-map' : 'cheap-module-source-map',
    module: {
      rules: [
        {
          test: /\.js$/,
          use: 'babel-loader',
          exclude: /node_modules/,
        },
      ],
    },
    plugins: [
      new ReactServerWebpackPlugin({isServer: false}),
    ],
  };

const webpackConfig = generateWebpackConfig(config);

module.exports = webpackConfig;
