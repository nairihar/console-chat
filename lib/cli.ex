defmodule CHAT.CLI do
  def main(_args) do
    IO.puts("Welcome to console based chat.")
    print_help_messages()
    recive_command()
  end

  @commands %{
    "/help" => "Shows chat supported commands",
    "/nickname" => "Example: \"/nickname Nairi\".",
    "/join" => "Example: \"/join channelName\".",
    "/leave" => "Leaves chat.",
    "/exit" => "Exits from chat."
  }

  defp exec_command("/help") do
    print_help_messages()
  end

  defp exec_command("/exit") do
    IO.puts("Exiting from chat...")
  end

  defp print_help_messages do
    IO.puts("\nConsole base chat supports following commands:\n")
    @commands
    |> Enum.map(fn({c, desc}) -> IO.puts("  #{c} - #{desc}") end)
  end

  defp recive_command do
    IO.gets("\n> ")
    |> String.trim
    |> String.downcase
    |> String.split(" ")
    |> exec_command
  end
end