/**
* ? Pulled from The System. Deploys light express server to host React app
* ? Can either consolidate somehow to and serve from Rails or find some other way
* ? procfile -> NODE_ENV=production yarn start could work, but doesn't use prod build
**/

const express = require('express');
const serveStatic = require('serve-static');
var history = require('connect-history-api-fallback');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');

// const proxyTable = {
//   '/api': {
//     target: 'http://localhost:3000',
//     changeOrigin: true
//   }
// }

let app = express();
app.use(history());
app.use(serveStatic(__dirname + "/dist"));
app.use(express.static(path.join(__dirname, './build')));
app.get('*', function(req, res) {
  res.sendFile(path.join(__dirname, './build', 'index.html'));
});



// proxy api requests
// Object.keys(proxyTable).forEach(function (context) {
//   let options = proxyTable[context]
//   if (typeof options === 'string') {
//     options = { target: options }
//   }
//   app.use(createProxyMiddleware("/api", { target: "http://localhost:3000" }));
// })


const port = process.env.PORT || 5001;
app.listen(port, () => {
  console.log('Listening on port ' + port)
});
