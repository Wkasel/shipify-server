express = require('express')

app = express.createServer(express.logger())
io = require('socket.io').listen(app);

# Config
#
#
#
app.use(express.bodyParser())

# Process
#
#
#

app.get '/trigger', (request, response)->
  io.sockets.emit 'commit', 
    username: 'nottombrown'
    message: "Test message"
  response.send "Triggered"


app.post '/callback', (request, response)->
  # Already parsed
  payload = JSON.parse(request.body.payload)

  lastCommit = payload.commits[payload.commits.length-1]

  commit =
    username: lastCommit.committer.username
    message: lastCommit.message
    timestamp: lastCommit.timestamp

  io.sockets.emit 'commit', commit

  response.send commit


port = process.env.PORT || 5000

app.listen(port, ->
  console.log("Listening on " + port)
)


io.sockets.on 'connection', (socket)->
  console.log "Connected"
  socket.emit 'commit', { hello: 'world' }

  socket.on 'my other event', (data)->
    console.log(data)
