const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const svg = require('./loaders/svg_transform_loader')
const url = require('./loaders/url_loader')

const webpack = require('webpack')
environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

environment.loaders.prepend('url', url)
environment.loaders.get('file').test = /\.(tiff|ico|eot|otf|ttf|woff|woff2)$/i
environment.loaders.prepend('svg', svg)
environment.loaders.prepend('erb', erb)
module.exports = environment
