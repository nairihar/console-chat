defmodule Chat.Supervisor do
  use Supervisor

  def main(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      Chat.Cli,
      SocketClient,
      User
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end