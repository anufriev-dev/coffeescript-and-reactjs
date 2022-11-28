# coffee-script-plugin: compiles coffeescript to javascript

path              = require 'node:path'
coffee            = require 'coffeescript'
{ readFileSync }  = require 'node:fs'
{ errorLog }      = require '../helpers'

name              = 'coffee-script-plugin'

omit = (obj, keys) ->
  Object.keys obj
    .filter (key) => not keys.includes key
    .reduce (res, key) =>
      Object.assign res, [key]: obj[key]
    ,{}

compileCoffee = (code, options) -> coffee.compile code, options


coffeeScriptPlugin = (options = {}, onLoadResult = {}) ->
  name: name
  setup: (build) =>
    build.onLoad filter: /.\.(coffee)$/, (args) =>
      source = readFileSync args.path, 'utf8'
      filename = path.relative do process.cwd, args.path
      opt = omit options, ['sourceMap']

      try
        contents = compileCoffee source, { filename, opt... }
        return {
            contents
            onLoadResult...
        }
      catch e
        errorLog(name,e)

module.exports = coffeeScriptPlugin
