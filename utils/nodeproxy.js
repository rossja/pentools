// ------------------------------------------------------------------
// simple web proxy for nodejs
// only uses core modules so there's no deps
// useful for proxying through SSH for example:
// ssh -L 8080:localhost:8080 user@remote.host
// then you can point your browser to localhost:8080 for web proxy
// and hit remote servers accessible from your remote host
// ------------------------------------------------------------------
// version: 0.1.0
// author: jason ross <algorythm@gmail.com>
// credits:
// this is based on the code at http://www.catonmat.net/http-proxy-in-nodejs/
// but I've changed it significantly to deal with changes to nodejs and to
// better suit my needs as a pentester.
// ------------------------------------------------------------------
// TODO: build in support for https: current version deals with random
// ports well, but if they are using https this barfs.
// ------------------------------------------------------------------
var http = require('http');
var fs   = require('fs');

var proxyPort   = 8080
var ipWhitelist = ['::1','127.0.0.1'];

const DBUG = 0;

function ip_allowed(ip) {
  for (i in ipWhitelist) {
    if (ipWhitelist[i] == ip) {
      return true;
    }
  }
  return false;
}

http.createServer(function(request, response) {
  var ip = request.connection.remoteAddress;
  if (!ip_allowed(ip)) {
    msg = "IP " + ip + " is not allowed to use this proxy";
    deny(response, msg);
    console.log(msg);
    return;
  }

  console.log("Got request from host: " + ip + " for url: " + request.url);

  var host = request.headers['host'].split(':')[0];
  var port = parseInt( request.headers['host'].split(':')[1] );
  var method = request.method;
  var headers = request.headers;
  var path = request.url;

  if (DBUG === 1) {
    console.log("host == " + host + "\nport == " + port + "\nmethod == " + method + "\npath == " + path);
    console.log("raw header dump:\n" + request.rawHeaders + "\n");
  }

  var proxy_request = http.request({
    port: port,
    host: host,
    method: method,
    path: path,
    headers: headers
  });

  proxy_request.addListener('response', function(proxy_response) {
    // send the remote response back to the proxy client
    proxy_response.addListener('data', function(chunk) {
      if (DBUG === 1) { console.log("sending back to the client:\n" + chunk); }
      response.write(chunk, 'binary');
    });
    proxy_response.addListener('end', function() {
      if (DBUG === 1) { console.log("ending proxy response..."); }
      response.end();
    });
    response.writeHead(proxy_response.statusCode, proxy_response.headers);
  });

  // send the data to the remote host
  request.addListener('data', function(chunk) {
    proxy_request.write(chunk, 'binary');
    if (DBUG === 1) { console.log("sending to the remote host:\n" + chunk); }
  });
  request.addListener('end', function() {
    if (DBUG === 1) { console.log("ending proxy request..."); }
    proxy_request.end();
  });

}).listen(proxyPort);

console.log("proxy is up and running on port 8080!");
