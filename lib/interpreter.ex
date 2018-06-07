defmodule Interpreter do
  def interpret(ast) do
    visit(ast)
  end

  defp visit(node = %Expr.Literal{}) do
    node.value
  end

  defp visit(node = %Expr.Binary{}) do
    case node.operator.type do
      :PLUS -> visit(node.left) + visit(node.right)
      :MINUS -> visit(node.left) - visit(node.right)
      :STAR -> visit(node.left) * visit(node.right)
      :SLASH -> visit(node.left) / visit(node.right)
    end
  end
end
