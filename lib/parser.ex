defmodule Parser do
  def parse(tokens) do
    {ast, rest} = expr(tokens)
  end

  def expr(tokens) do
    # Get the left-hand side of the expression
    {left, rest} = term(tokens)

    IO.puts("expr left")
    IO.inspect(left)
    IO.inspect(rest, label: 'expr rest')

    if rest != [] do
      # Extract the current token from the rest of the list
      [current | rest] = rest

      # If current token is a PLUS or MINUS, calculate the rest of the expression
      cond do
        match(current, [:PLUS, :MINUS]) ->
          {right, rest} = expr(rest)
          IO.puts("expr right")
          IO.inspect(right)
          {%Expr.Binary{left: left, operator: current, right: right}, rest}

        match(current, [:EOF]) ->
          {left, []}

        true ->
          {left, [current | rest]}
      end
    else
      {left, []}
    end
  end

  def term(tokens) do
    # Get the left-hand side of the term
    {left, rest} = factor(tokens)

    IO.puts("term left")
    IO.inspect(left)
    IO.inspect(rest, label: "term rest")

    if rest != [] do
      # Extract the current token from the rest of the list
      [current | rest] = rest

      # If current token is a STAR or SLASH, calculate the rest of the term
      cond do
        match(current, [:STAR, :SLASH]) ->
          {right, rest} = term(rest)
          IO.puts("term right")
          IO.inspect(right)
          {%Expr.Binary{left: left, operator: current, right: right}, rest}

        match(current, [:EOF]) ->
          {left, []}

        true ->
          {left, [current | rest]}
      end
    else
      {left, []}
    end
  end

  def factor(tokens) do
    [current | rest] = tokens

    cond do
      match(current, [:INT]) ->
        IO.puts("INTEGER LITERAL")
        IO.inspect(rest)
        {%Expr.Literal{value: current.value}, rest}

      true ->
        raise RuntimeError, message: "Expect INT literal"
    end
  end

  defp match(current, types) do
    matches = Enum.member?(types, current.type)
    IO.puts("matches?")
    IO.inspect({current, types, matches})
    matches
  end
end
