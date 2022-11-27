# dev server

Esbuild       = require 'esbuild'
http          = require 'node:http'
EventEmitter  = require 'node:events'
baseConfig    = require './esbuild-config'

emitter       = new EventEmitter


dev = ->
  Esbuild.build {
    baseConfig...
    write: false
    outdir: process.env['PUBLIC']
    watch:
      onRebuild: (error, result) =>
        emitter.emit 'refresh'
  }
  .catch => process.exit 1

  Esbuild.serve {
    servedir: process.env['PUBLIC']
  }, {
    baseConfig...
    banner:
      js: '// Self executing function\n (() => { console.log("Event Source Starting..."); \nconst es = new EventSource("/sub"); es.addEventListener("message", () => window.location.reload()) })();'
  }
  .then (result) =>
    { host, port } = result
    server = http.createServer (req, res) =>
      { method, url, headers } = req

      if req.url is '/sub'
        res.writeHead 200,
          'Content-Type'  : 'text/event-stream'
          'Cache-Control' : 'no-cache'
          'Connection'    : 'keep-alive'
        emitter.once 'refresh', =>
          res.write 'data: err\n\n'
        return
      # Catch requests and if it's a file serve the file
      # Otherwise if it's a directory default to index.html
      # Ex: /out/index.js
      pathAsArray = url.split '/'
      # ['', 'out', 'index.js']
      endOfPathArray = do pathAsArray.pop
      # index.js
      isFile =  '.' in endOfPathArray
      # true
      path = if isFile then url else '/index.html'
      # /out/index.js
      # if /out => /index.html

      # Pass the request to esbuild and get the result
      # from a proxy request and serve the proxy result
      req.pipe(http.request({ port, hostname: host, path, method, headers }, (proxyRes) ->
        res.writeHead proxyRes.statusCode, proxyRes.headers
        proxyRes.pipe res, end: true
        return
      ), end: on)

    server.listen +process.env['PORT']

  .then =>
    console.log "⚡ \x1b[32mserver started\x1b[0m to \x1b[34mhttp://localhost:#{process.env['PORT']}\x1b[0m"

  .catch (e) =>
    console.log "error dev-config:"
    console.error e
    process.exit 1


module.exports = dev
