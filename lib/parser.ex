defmodule Parser do
  def parse(tokens) do
    {ast, _} = expr(tokens)
    ast
  end

  def expr(tokens) do
    # Get the left-hand side of the expression
    {left, rest} = term(tokens)

    if rest != [] do
      # Extract the current token from the rest of the list
      [current | rest] = rest

      # If current token is a PLUS or MINUS, calculate the rest of the expression
      cond do
        match(current, [:PLUS, :MINUS]) ->
          {right, rest} = expr(rest)
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

    if rest != [] do
      # Extract the current token from the rest of the list
      [current | rest] = rest

      # If current token is a STAR or SLASH, calculate the rest of the term
      cond do
        match(current, [:STAR, :SLASH]) ->
          {right, rest} = term(rest)
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
        {%Expr.Literal{value: current.value}, rest}

      true ->
        raise RuntimeError, message: "Expect INT literal"
    end
  end

  defp match(current, types) do
    matches = Enum.member?(types, current.type)
    matches
  end
end
