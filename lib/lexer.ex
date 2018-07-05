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
      cond do
        is_whitespace(current) ->
          scan_tokens(rest, token_list)

        is_alpha(current) ->
          {next_token, rest} = identifier(rest, [current])
          scan_tokens(rest, [next_token | token_list])

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

        [current] == '(' ->
          next_token = %Token{lexeme: to_string([current]), type: :LPR}
          scan_tokens(rest, [next_token | token_list])

        [current] == ')' ->
          next_token = %Token{lexeme: to_string([current]), type: :RPR}
          scan_tokens(rest, [next_token | token_list])

        [current] == '=' ->
          next_token = %Token{lexeme: to_string([current]), type: :EQUAL}
          scan_tokens(rest, [next_token | token_list])

        true ->
          raise RuntimeError, message: "unknown token \"" <> to_string([current]) <> "\""
      end
    end
  end

  def identifier(source, chars \\ []) do
    if source == [] do
      lexeme = chars |> Enum.reverse() |> to_string
      {%Token{lexeme: lexeme, type: :IDENTIFIER, value: lexeme}, []}
    else
      [current | rest] = source

      if is_alpha(current) || is_digit(current) do
        identifier(rest, [current | chars])
      else
        lexeme = chars |> Enum.reverse() |> to_string
        {%Token{lexeme: lexeme, type: :IDENTIFIER, value: lexeme}, source}
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

  def is_alpha(char) do
    ([char] >= 'a' && [char] <= 'z') || ([char] >= 'A' && [char] <= 'Z') || [char] == '_'
  end

  def is_digit(char) do
    [char] >= '0' && [char] <= '9'
  end

  def is_whitespace(char) do
    [char] in ['\n', '\t', '\s']
  end
end
