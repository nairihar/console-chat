defmodule SocketClient do
  use WebSockex

  def start_link() do
    url = Application.get_env(:socket, :url)
    res = WebSockex.start_link(url, __MODULE__, :fake_state)
    case res do
      {:ok, pid} ->
        IO.puts("Socket Connected!")
      {:error, term} ->
        IO.inspect(term)
    end
  end

  def handle_connect(_conn, :fake_state) do
    IO.puts("Socket Connected!")
    {:ok, :fake_state}
  end

  def handle_frame({type, msg}, :fake_state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, :fake_state}
  end

  def handle_cast({:send, {type, msg} = frame}, :fake_state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, :fake_state}
  end
end
