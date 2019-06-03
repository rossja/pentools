const request = require('request-json')

const host = process.argv.slice(2)
const proto = 'http'
const port = '10255'
const path = '/pods'

const reqUrl = proto + '://' + host + ':' + port
const client = request.createClient(reqUrl)

// client.headers['Cookie'] = 'Your cookie'

client.get(path, function (err, res, body) {
  if (err) throw err
  const items = body.items
  items.forEach(function (item) {
    if (item.status.podIP !== undefined) {
      return console.log(item.status.podIP)
    }
  })
})
