const WebSocket = require('ws');
const uuid = require('uuid');

const wss = new WebSocket.Server({ port: 8888 });

const users = {};
const channels = {};

function joinChannel(userId, channelName) {
  const userWs = users[userId];
  userWs.channelName = channelName;

  if (!channels[channelName]) {
    channels[channelName] = [];
  }

  channels[channelName].push(userId);
  sendChannelUsers(channelName, {
    action: 1,
    message: `${ws.nickname} joined to channel.`
  });
}

function leaveChannel(userId) {
  const userWs = users[userId];
  const channel = channels[userWs.channelName];

  channel.splice(channel.indexOf(userId), 1);
  sendChannelUsers(userWs.channelName, {
    action: 1,
    message: `${ws.nickname} left from channel.`
  });
}

function sendChannelUsers(channelName, data) {
  const channel = channels[userWs.channelName];
  channel.forEach((userId) => {
    sendToUser(userId, data);
  });
}

function sendToUser(userId, data) {
  const userWs = users[userId];
  userWs.send(JSON.stringify(data));
}

wss.on('connection', (ws) => {
  const userId = uuid.v4();
  ws.id = userId;
  users[userId] = ws;
  console.log(`Connected: ${userId}`);

  ws.on('message', (message) => {
    console.log(`Received - ${userId}: ${message}`);
    try {
      const data = JSON.parse(message);
      switch (data.action) {
        case 0:
          joinChannel(userId, data.channelName);
        case 1:
          leaveChannel(userId);
        case 2:
          sendMessage(userId, data.message);
        // TODO :: nickname, default
      }
    } catch(err) {
      console.log('============== Error: message parse ==============');
      console.log(userId);
      console.log(message);
      console.log(err);
      console.log('==================================================');
    }
  });

  ws.on('close', () => {
    console.log(`Disconnected: ${userId}`);
    users[userId] = null;
  });
});

console.log('WSS Server running at 8888 port');
