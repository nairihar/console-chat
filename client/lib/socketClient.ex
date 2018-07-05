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
    WebSockex.send_frame(pid, {:text, message})
  end

  def terminate(_, _) do
    ColorPrint.red "\nSocket Disconnected!"
    Chat.Cli.exit_cli()
  end

  def handle_frame({_, res}, :fake_state) do
    map = Poison.decode!(res)
    {:ok, message } = Map.fetch(map, "message")
    ColorPrint.blue message
    {:ok, :fake_state}
  end
end
