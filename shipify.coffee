express = require('express')

app = express.createServer(express.logger())
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
app.get '/', (request, response)->

  redis.get 'lastCommit', (err, value) ->
    response.send(value)

app.post '/', (request, response)->

  # Already parsed
  commit = request.body


  redis.set('lastCommit', JSON.stringify(commit))
  response.send commit

app.post '/hook', (request, response)->

  # Already parsed
  commit = request.body


  redis.set('lastCommit', JSON.stringify(commit))
  response.send commit


port = process.env.PORT || 5000
app.listen(port, ->
  console.log("Listening on " + port)
)