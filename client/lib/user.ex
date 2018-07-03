defmodule User do
  def init() do
    map = %{:nickname => nil, :channelName => nil}
    Agent.start(fn -> map end)
  end

  def setNickname(pid, nickname) do
    Agent.update(pid, fn(map) -> Map.put(map, :nickname, nickname) end)
  end

  def getNickname(pid) do
    Agent.get(pid, fn(map) -> Map.get(map, :nickname) end)
  end

  def setChannelName(pid, channelName) do
    Agent.update(pid, fn(map) -> Map.put(map, :channelName, channelName) end)
  end

  def getChannelName(pid) do
    Agent.get(pid, fn(map) -> Map.get(map, :channelName) end)
  end
end