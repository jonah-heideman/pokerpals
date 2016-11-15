let data = {
  username: 'nil',
  channelId: 'nil',
  setUsername: function(username){
    this.username = username;
  },
  getUsername: function(){
    return username;
  },
  setChannelId: function(channelId){
    this.channelId = channelId;
  }
}

export default {
  setUsername: data.setUsername,
  setChannelId: data.setChannelId
}
