const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8888 });

wss.on('connection', (ws) => {
  console.log('Connected');

  ws.on('message', (message) => {
    console.log('Received: %s', message);
  });

  ws.send('something');
});

console.log('WSS Server running at 8888 port');
