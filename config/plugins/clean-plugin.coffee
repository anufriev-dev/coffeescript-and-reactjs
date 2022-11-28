# clean-plugin: deletes folder before begin

{ existsSync, rmSync }  = require 'node:fs'
{ errorLog }            = require '../helpers'

name                    = 'clean-plugin'


clean = (outdir) ->
  name: name
  setup: (build) =>
    try
      build.onStart =>
        rmSync outdir, recursive: yes if existsSync outdir
    catch e
      errorLog(name,e)


module.exports = clean
