express = require('express')

app = express.createServer(express.logger())
redis = require('redis-url').connect(process.env.REDISTOGO_URL)


app.get('/', (request, response)-> 
  redis.set('foo', 'barnc')

  redis.get('foo', (err, value) -> 
    response.send('Hello!'+value)
  )


)

port = process.env.PORT || 5000
app.listen(port, -> 
  console.log("Listening on " + port)
)