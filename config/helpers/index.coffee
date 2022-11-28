# helpers

errorLog = (name,e) =>
  console.log "error: #{name}:"
  console.error e
  process.exit 1


module.exports = {
  errorLog
}
