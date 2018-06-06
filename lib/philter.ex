defmodule Philter do
  def start do
    IO.puts("Welcome to the Philer REPL!")
    IO.puts("Enter an integer arithmetic expression, and I will convert it to a token stream")
    repl()
  end

  def repl do
    input = IO.gets("-> ") |> String.trim()

    unless input == "quit" do
      expr = input |> to_charlist

      # token_list = Lexer.scan_tokens(expr, [])

      # IO.inspect(token_list)

      Lexer.scan_tokens(expr, [])
      |> Parser.parse()

      repl()
    end
  end
end
