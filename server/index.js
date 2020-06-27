const Hapi = require('@hapi/hapi')
const Inert = require('@hapi/inert')
const path = require('path')
const Gate = require('./gate')
const routes = require('./routes')

const init = async () => {
  const port = process.env.PORT || 3000
  const relativeTo = path.join(process.cwd(), 'deploy')

  const server = Hapi.server({
    port,
    host: '0.0.0.0',
    routes: {
      cors: true,
      files: {
        relativeTo
      }
    }
  })

  await server.register(Inert)
  await server.register({
    plugin: Gate,
    options: {
      https: process.env.SERVER_HTTPS || false,
      www: process.env.SERVER_WWW || true
    }
  })

  server.route(routes)

  // when all routes fail, redirect to index.
  // also works with history api
  server.ext('onPreResponse', (req, h) => {
    const { response } = req
    if (response.isBoom && response.output.statusCode === 404) {
      return h.file('index.html')
    }
    return h.continue
  })

  await server.start()
  console.log(`🚀  Server running on ${server.info.uri}`)
}

process.on('unhandledRejection', err => {
  console.log(err)
  process.exit(1)
})

init()
