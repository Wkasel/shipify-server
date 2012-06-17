express = require('express')

app = express.createServer(express.logger())
io = require('socket.io').listen(app);

# Config
#
#
#
app.use(express.bodyParser())
io.configure ->
  io.set("transports", ["xhr-polling"])
  io.set("polling duration", 10)

# Process
#
#
#

app.get '/trigger', (request, response)->
  io.sockets.emit 'commit',
    username: 'nottombrown'
    message: "Test message"
  response.send "Triggered"


app.post '/', (request, response)->

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


# io.sockets.on 'connection', (socket)->
#   socket.emit 'connected', { connected: 'Hell yes' }

#   socket.on 'my other event', (data)->
#     console.log(data)
