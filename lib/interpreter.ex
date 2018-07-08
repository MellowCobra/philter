defmodule Interpreter do
  def interpret(ast) do
    visit(ast, %Environment{})
  end

  defp visit(node = %Stmt.Compound{}, env) do
    case node.statements do
      [statement | statements] ->
        {result, env} = visit(statement, env)
        visit(%Stmt.Compound{statements: statements}, env)

      [] ->
        {:ok, env}
    end
  end

  defp visit(node = %Stmt.Print{}, env) do
    {result, env} = visit(node.expr, env)
    IO.puts(result)
    {result, env}
  end

  defp visit(node = %Stmt.Assign{}, env) do
    {value, env} = visit(node.expr, env)
    environment = Environment.define(env, node.name, value)
    {:ok, environment}
  end

  defp visit(node = %Expr.Literal{}, env) do
    {node.value, env}
  end

  defp visit(node = %Expr.Binary{}, env) do
    {left, _} = visit(node.left, env)
    {right, _} = visit(node.right, env)

    result =
      case node.operator.type do
        :PLUS -> left + right
        :MINUS -> left - right
        :STAR -> left * right
        :SLASH -> left / right
      end

    {result, env}
  end

  defp visit(node = %Expr.Var{}, env) do
    {Environment.get(env, node.name), env}
  end
end
