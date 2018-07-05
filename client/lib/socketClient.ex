defmodule SocketClient do
  use WebSockex

  def start_link() do
    url = Application.get_env(:socket, :url)
    res = WebSockex.start_link(url, __MODULE__, :fake_state)
    case res do
      {:ok, pid} ->
        :ets.insert(:buckets_registry, {"socket", pid})
        ColorPrint.green "\nSocket Connected!"
        :ok
      {:error, term} ->
        ColorPrint.red "***\nError during Socket connection!\n"
        IO.inspect(term)
        ColorPrint.red "\n***"
        :error
    end
  end

  def send(pid, message) do
    IO.puts("\nSending: #{message}")
    WebSockex.send_frame(pid, {:text, message})
  end

  def terminate(_, _) do
    ColorPrint.red "\nSocket Disconnected!"
    Chat.Cli.exit_cli()
  end

  def handle_frame({type, msg}, :fake_state) do
    IO.puts("\nReceived Message - Type: #{inspect type} -- Message: #{inspect msg}")
    {:ok, :fake_state}
  end
end
