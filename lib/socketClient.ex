defmodule SocketClient do
  use WebSockex

  def start_link() do
    url = Application.get_env(:socket, :url)
    res = WebSockex.start_link(url, __MODULE__, :fake_state)
    case res do
      {:ok, _} ->
        IO.puts("\nSocket Connected!")
        :ok
      {:error, term} ->
        IO.puts("***\nError during Socket connection!\n***")
        IO.inspect(term)        
        :error
    end
  end

  def terminate(_, _) do
    IO.puts("\nSocket Disconnected!")
    Chat.Cli.exit_cli()
  end

  def handle_frame({type, msg}, :fake_state) do
    IO.puts("\nReceived Message - Type: #{inspect type} -- Message: #{inspect msg}")
    {:ok, :fake_state}
  end

  def handle_cast({:send, {type, msg} = frame}, :fake_state) do
    IO.puts("\nSending #{type} frame with payload: #{msg}")
    {:reply, frame, :fake_state}
  end
end
