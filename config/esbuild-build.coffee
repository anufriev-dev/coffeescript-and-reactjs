# building your code in bundle

Esbuild                       = require 'esbuild'
{ clean }                     = require './plugins'
{ errorLog }                  = require './helpers'
baseConfig                    = require './esbuild-config'
{ copyFileSync, readdirSync } = require 'node:fs'


build = ->
  return Esbuild.build {
    baseConfig...
    minify: yes
    drop : [ 'console' ]
    outdir: process.env['BUILD']
    plugins: [baseConfig.plugins..., clean process.env['BUILD']]
    # metafile: yes
  }
  .then (r) =>
    # require("fs").writeFileSync("metafile.json", JSON.stringify(r.metafile))
    paths = readdirSync process.env['PUBLIC']
    copyFileSync "#{process.env['PUBLIC']}/#{name}", "#{process.env['BUILD']}/#{name}" for name in paths

  .then =>
    console.log 'It done\n\n\x1b[32m  npm run start\n\x1b[0m \tStarts the production server.\n\n'
    process.exit 0

  .catch (e) =>
     errorLog('error build-config',e)


module.exports = build
