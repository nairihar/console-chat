const WebSocket = require('ws');
const uuid = require('uuid');

const wss = new WebSocket.Server({ port: 8888 });

const users = {};
const channels = {};

function joinChannel(userId, channelName) {
  const userWs = users[userId];
  const { nickname } = userWs;
  userWs.channelName = channelName;

  if (!channels[channelName]) {
    channels[channelName] = [];
  }

  channels[channelName].push(userId);
  sendChannelUsers(channelName, {
    action: 1,
    message: `${nickname} joined to channel.`
  });
}

function leaveChannel(userId) {
  const userWs = users[userId];
  const { channelName, nickname } = userWs;
  const channel = channels[channelName];

  if (channel) {
    channel.splice(channel.indexOf(userId), 1);
    sendChannelUsers(channelName, {
      action: 1,
      message: `${nickname} left from channel.`
    });
  }
}

function sendMessage(userId, message) {
  const userWs = users[userId];
  const { channelName } = userWs;
  sendChannelUsers(channelName, {
    message: `${userWs.nickname}: ${message}`
  });
}

function sendChannelUsers(channelName, data) {
  const channel = channels[channelName];
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
    try {
      const data = JSON.parse(message);
      switch (data.action) {
        case 0:
          joinChannel(userId, data.channelName);
          break;
        case 1:
          leaveChannel(userId);
          break;
        case 2:
          sendMessage(userId, data.message);
          break;
        case 3:
          ws.nickname = data.nickname;
          break;
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
    leaveChannel(userId);
    users[userId] = null;
  });
});

console.log('WSS Server running at 8888 port');
