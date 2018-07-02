defmodule Chat.Cli do
  def main(_args) do
    IO.puts("\nWelcome to console based chat.")
    res = SocketClient.start_link()
    if res == :error do
      exit_cli()      
    end

    print_help_messages()
    recive_command()
  end

  def exit_cli() do
    IO.puts("\nShutting down process!")
    System.halt(0)
  end

  @commands %{
    "/help" => "Shows chat supported commands",
    "/nickname" => "Example: \"/nickname Nairi\".",
    "/join" => "Example: \"/join channelName\".",
    "/leave" => "Leaves chat.",
    "/exit" => "Exits from chat."
  }

  defp exec_command(["/help" | _]) do
    print_help_messages()
    recive_command()
  end

  defp exec_command(["/nickname" | params]) do
    nickname = Enum.at(params, 0)
    if nickname == nil do      
      IO.puts("\nPlease specify valid nickname")
    else
      User.setNickname(nickname)
      IO.puts("\nHi #{nickname}")      
    end
    recive_command()
  end

  defp exec_command(["/join" | _]) do
    # TODO
  end

  defp exec_command(["/leave" | params]) do
    channelName = User.getChannelName()
    if channelName == nil do
      IO.puts("\nPlease join a channel before leaving")
    else
      IO.puts("\nLeaving from #{channelName} channel.")
    end
    recive_command()
  end

  defp exec_command(["/exit" | _]) do
    IO.puts("\nExiting from chat...")
  end

  defp exec_command(_) do
    IO.puts("\nWrong command.")
    recive_command()
  end

  defp print_help_messages do
    IO.puts("\nConsole base chat supports following commands:\n")
    @commands
    |> Enum.map(fn({c, desc}) -> IO.puts("  #{c} - #{desc}") end)
  end

  defp recive_command do
    IO.gets("\n> ")
    |> String.trim
    |> String.split(" ")
    |> exec_command
  end
end