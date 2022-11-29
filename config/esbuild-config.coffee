# base configuration

{ coffeeScriptPlugin, sassPlugin, stylusPlugin  } = require './plugins'

baseConfig =
  bundle: yes
  publicPath: '.'                             # root in outdir
  nodePaths: ['./', './src']                  # absolute import / export
  jsx: "automatic"                            # automatic import React in every file
  resolveExtensions: ['.coffee']              # omit extension in import
  entryPoints: ['./src/main.coffee']
  entryNames : 'static/index'                 # main files in outdir
  assetNames: 'static/assets/[name]-[hash]'   # folder in outdir where loader it is file
  loader:
    '.svg'  : 'file'
    '.json' : 'json'
    '.png'  : 'file'
    '.jpeg' : 'file'
    '.gif'  : 'file'
  plugins: [
    sassPlugin loader: 'css'
    stylusPlugin loader: 'css'
    coffeeScriptPlugin {}, loader: 'jsx'
  ]


module.exports = baseConfig
