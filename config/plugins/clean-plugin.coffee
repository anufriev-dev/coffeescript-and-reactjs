# clean-plugin: deletes folder before begin

fs = require 'node:fs'

name = 'clean-plugin'


clean = (outdir) ->
  name: name
  setup: (build) =>
    try
      build.onStart =>
        fs.rmSync outdir, recursive: yes if fs.existsSync outdir
    catch e
      console.log "error: #{name}:"
      console.error e
      process.exit 1


module.exports = clean
