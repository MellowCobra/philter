defmodule Lexer do
  # Main function of the lexer.
  # Takes a charlist and scans it into a list of tokens
  def scan_tokens(source, token_list \\ []) do
    # If the source is an empty list, return the token list
    if source == [] do
      eof = %Token{lexeme: "\0", type: :EOF, value: nil}
      [eof | token_list] |> Enum.reverse()
    else
      [current | rest] = source

      # If whitespace, consume and keep trucking
      if is_whitespace(current) do
        scan_tokens(rest, token_list)
      else
        cond do
          is_digit(current) ->
            {next_token, rest} = int(source)
            scan_tokens(rest, [next_token | token_list])

          [current] == '+' ->
            next_token = %Token{lexeme: to_string([current]), type: :PLUS}
            scan_tokens(rest, [next_token | token_list])

          [current] == '-' ->
            next_token = %Token{lexeme: to_string([current]), type: :MINUS}
            scan_tokens(rest, [next_token | token_list])

          [current] == '*' ->
            next_token = %Token{lexeme: to_string([current]), type: :STAR}
            scan_tokens(rest, [next_token | token_list])

          [current] == '/' ->
            next_token = %Token{lexeme: to_string([current]), type: :SLASH}
            scan_tokens(rest, [next_token | token_list])

          true ->
            raise RuntimeError, message: "unknown token \"" <> to_string([current]) <> "\""
        end
      end
    end
  end

  def int(source, ints \\ []) do
    if source == [] do
      lexeme = ints |> Enum.reverse() |> to_string
      int_value = lexeme |> String.to_integer()
      {%Token{lexeme: lexeme, type: :INT, value: int_value}, []}
    else
      [current | rest] = source

      if is_digit(current) do
        int(rest, [current | ints])
      else
        lexeme = ints |> Enum.reverse() |> to_string
        int_value = lexeme |> String.to_integer()
        {%Token{lexeme: lexeme, type: :INT, value: int_value}, source}
      end
    end
  end

  def is_digit(char) do
    cond do
      [char] >= '0' && [char] <= '9' -> true
      true -> false
    end
  end

  def is_whitespace(char) do
    cond do
      [char] in ['\n', '\t', '\s'] -> true
      true -> false
    end
  end
end
