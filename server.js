const path = require('path')
const express = require('express')
const cors = require('cors')
const compression = require('compression')

const PATH_DIST = path.join(process.cwd(), 'deploy')

const PORT = process.env.PORT || 8080

const app = express()
app.use(compression())
app.use(cors())
app.options('*', cors())

app.listen(PORT, () => console.log(`Listening on ${PORT}`))

// all other routes
app.use(express.static(PATH_DIST))
app.get('*', (req, res) => {
  res.sendFile('index.html', {
    root: PATH_DIST
  })
})
