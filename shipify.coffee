express = require('express')

app = express.createServer(express.logger())
io = require('socket.io').listen(app);
redis = require('redis-url').connect(process.env.REDISTOGO_URL)

# Config
#
#
#
app.use(express.bodyParser())

# Process
#
#
#

app.post '/callback', (request, response)->

  # Already parsed
  payload = JSON.parse(request.body.payload)

  lastCommit = payload.commits[payload.commits.length-1]

  commit =
    username: lastCommit.committer.username
    message: lastCommit.message
    timestamp: lastCommit.timestamp

  redis.set('commit', JSON.stringify(commit))
  response.send commit


port = process.env.PORT || 5000

app.listen(port, ->
  console.log("Listening on " + port)
)


io.sockets.on 'connection', (socket)->

  socket.emit('news', { hello: 'world' })

  socket.on 'my other event', (data)->
    console.log(data)
