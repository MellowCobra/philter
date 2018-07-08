defmodule Parser do
  def parse(tokens) do
    {ast, _} = compound_stmt(tokens)
    ast
  end

  def compound_stmt(tokens, statements \\ []) do
    {statement, rest} = stmt(tokens)
    # NOTE that this is putting statements into the statement list in REVERSE order
    statements = Enum.reverse([statement | Enum.reverse(statements)])

    case rest do
      [current | rest] ->
        cond do
          match(current, [:SEMI]) ->
            {compound, rest} = compound_stmt(rest, statements)
            # Remember we are pushing the statements in REVERSE order
            {%Stmt.Compound{statements: compound.statements}, rest}

            # true ->
            #   {%Stmt.Compound{statements: statements}, rest}
        end

      [] ->
        {%Stmt.Compound{statements: statements}, []}
    end
  end

  def stmt(tokens) do
    case tokens do
      [current | rest] ->
        cond do
          match(current, [:PRINT]) ->
            print_stmt(rest)

          match(current, [:VAR]) ->
            var_stmt(rest)

          true ->
            raise RuntimeError, message: "Expected a statement"
        end

      _ ->
        raise RuntimeError, message: "Expected a statement"
    end
  end

  def print_stmt(tokens) do
    {expression, rest} = expr(tokens)
    {%Stmt.Print{expr: expression}, rest}
  end

  def var_stmt(tokens) do
    case tokens do
      [id, %Token{lexeme: "=", type: :EQUAL} | rest] ->
        {expression, rest} = expr(rest)
        {%Stmt.Assign{name: id, expr: expression}, rest}

      _ ->
        raise RuntimeError, message: "There is a problem with your var statement"
    end
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

      match(current, [:LPR]) ->
        case expr(rest) do
          {expression, [%Token{lexeme: ")", type: :RPR} | rest]} ->
            {expression, rest}

          {_expression, _} ->
            raise RuntimeError, message: "Missing ')' at end of grouping expression"
        end

      match(current, [:IDENTIFIER]) ->
        var_expr(tokens)

      true ->
        raise RuntimeError, message: "Expect expression"
    end
  end

  def var_expr(tokens) do
    [current | rest] = tokens
    {%Expr.Var{name: current}, rest}
  end

  defp match(current, types) do
    Enum.member?(types, current.type)
  end
end
