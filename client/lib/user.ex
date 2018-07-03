defmodule User do
  @nickname nil
  @channelName nil

  def setNickname(name) do
    nickname = name
  end

  def getNickname() do
    @nickname
  end

  def setChannelName(channelName) do
    channelName = channelName
  end

  def getChannelName() do
    @channelName
  end
end