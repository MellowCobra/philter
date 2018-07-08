defmodule Environment do
  defstruct enclosing: nil, values: %{}

  def define(%Environment{} = env, %Token{} = name, value) do
    values = Map.put(env.values, name, value)
    %Environment{enclosing: env.enclosing, values: values}
  end

  def get(%Environment{} = env, %Token{} = name) do
    cond do
      Map.has_key?(env.values, name) ->
        Map.get(env.values, name)

      env.enclosing != nil ->
        get(env.enclosing, name)

      true ->
        raise RuntimeError, message: "Undefined variable '#{name.lexeme}'"
    end
  end

  def assign(%Environment{} = env, %Token{} = name, value) do
    cond do
      Map.has_key?(env.values, name) ->
        values = Map.put(env.values, name, value)
        %Environment{enclosing: env.enclosing, values: values}

      env.enclosing != nil ->
        enclosing = assign(env.enclosing, name, value)
        %Environment{enclosing: enclosing, values: env.values}

      true ->
        raise RuntimeError, message: "Cannot assign value to undefined variable '#{name.lexeme}'"
    end
  end
end
