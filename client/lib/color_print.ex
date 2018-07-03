defmodule ColorPrint do
    def green(text) do
        out = IO.ANSI.format([IO.ANSI.light_green(), text, IO.ANSI.light_white()])
        IO.puts out
    end

    def red(text) do
        out = IO.ANSI.format([IO.ANSI.light_red(), text, IO.ANSI.light_white()])
        IO.puts out
    end

    def yellow(text) do
        out = IO.ANSI.format([IO.ANSI.light_yellow(), text, IO.ANSI.light_white()])
        IO.puts out
    end
end