defmodule Chat.Cli do
  def main(_args) do
    IO.puts("\nWelcome to console based chat.")
    :ets.new(:buckets_registry, [:named_table, :public])
    User.init()
    status = SocketClient.start_link()
    if status == :error do
      exit_cli()      
    end    
    print_help_messages()
    recive_command()
  end

  def exit_cli() do
    ColorPrint.yellow "\nShutting down process!"
    System.halt(0)
  end

  @commands %{
    "/help" => "Shows chat supported commands",
    "/nickname" => "Example: \"/nickname Nairi\".",
    "/join" => "Example: \"/join channelName\".",
    "/left" => "Left from chat.",
    "/exit" => "Exit from chat."
  }

  defp exec_command(["/help" | _]) do
    print_help_messages()
    recive_command()
  end

  defp exec_command(["/nickname" | params]) do
    nickname = Enum.at(params, 0)
    if nickname == nil do      
      ColorPrint.warn "\nPlease specify valid nickname"
    else
      User.setNickname(nickname)
      ColorPrint.green "\nHi #{nickname}"
      send(%{ "action" => 3, "nickname" => nickname})
    end    
    recive_command()
  end

  defp exec_command(["/join" | params]) do
    channelName = Enum.at(params, 0)
    if channelName == nil do
      ColorPrint.warn "\nPlease specify channelName."
    else
      nickname = User.getNickname()
      if nickname == nil do
        ColorPrint.warn "\nPlease set nickname before joining."
      else
        joinedChannelName = User.getChannelName()
        if joinedChannelName != nil do
          ColorPrint.warn "\nPlease left from current channel befor joining other."
        else        
          User.setChannelName(channelName)
          send(%{ "action" => 0, "channelName" => channelName})
        end
      end
    end    
    recive_command()
  end

  defp exec_command(["/left" | _]) do
    channelName = User.getChannelName()
    if channelName == nil do
      ColorPrint.warn "\nPlease join a channel before lefting."
    else
      User.setChannelName(nil)
      send(%{ "action" => 1 })
    end    
    recive_command()
  end

  defp exec_command(["/exit" | _]) do
    IO.puts("\nExiting from chat...")
  end

  defp exec_command(messages) do
    channelName = User.getChannelName()
    if channelName == nil do
      ColorPrint.warn "\nPlease join a channel before send a message."
    else
      send(%{"action" => 2, "message" => Enum.join(messages, " ")})
    end
    recive_command()
  end

  defp send(data) do
    buckets = :ets.lookup(:buckets_registry, "socket")
    {_, socketPid} = Enum.at(buckets, 0)
    jsonStr = Poison.encode!(data)
    SocketClient.send(socketPid, jsonStr)
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