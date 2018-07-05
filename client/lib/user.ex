defmodule User do
  def init() do
    map = %{:nickname => nil, :channelName => nil}
    Agent.start(fn -> map end, name: __MODULE__)
  end

  def setNickname(nickname) do
    Agent.update(__MODULE__, fn(map) -> Map.put(map, :nickname, nickname) end)
  end

  def getNickname() do
    Agent.get(__MODULE__, fn(map) -> Map.get(map, :nickname) end)
  end

  def setChannelName(channelName) do
    Agent.update(__MODULE__, fn(map) -> Map.put(map, :channelName, channelName) end)
  end

  def getChannelName() do
    Agent.get(__MODULE__, fn(map) -> Map.get(map, :channelName) end)
  end
end