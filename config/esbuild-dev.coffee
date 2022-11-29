# dev server

Esbuild                 = require 'esbuild'
http                    = require 'node:http'
EventEmitter            = require 'node:events'
{ basename, extname }   = require 'node:path'
baseConfig              = require './esbuild-config'
{ errorLog }            = require './helpers'

emitter                 = new EventEmitter


dev = ->
  Esbuild.build {
    baseConfig...
    write: false
    outdir: process.env['PUBLIC__DIR']
    watch:
      onRebuild: () =>
        emitter.emit 'refresh'
  }
  .catch => process.exit 1

  Esbuild.serve {
    servedir: process.env['PUBLIC__DIR']
  }, {
    baseConfig...
    banner:
      js: ';(() => { console.log("Event Source Starting...") \nconst es = new EventSource("/sub"); es.addEventListener("message", () => window.location.reload()) })();'
  }
  .then (result) =>
    { host, port } = result
    server = http.createServer (req, res) =>
      { method, url, headers } = req

      if req.url is '/sub'
        res.writeHead 200,
          'Cache-Control' : 'no-cache'
          'Connection'    : 'keep-alive'
          'Content-Type'  : 'text/event-stream'
        emitter.once 'refresh', =>
          res.write 'data: err\n\n'
        return

      # parsing url
      bn = basename url
      path = if extname bn then url else '/index.html'

      # proxy
      options = { port, hostname: host, path, method, headers }

      req.pipe http.request options, (proxyRes) ->
        res.writeHead proxyRes.statusCode, proxyRes.headers
        proxyRes.pipe res

    server.listen +process.env['PORT']

  .then =>
    console.log "⚡ \x1b[32mserver started\x1b[0m to \x1b[34mhttp://localhost:#{process.env['PORT']}\x1b[0m"

  .catch (e) =>
    errorLog('error dev-config',e)


module.exports = dev
