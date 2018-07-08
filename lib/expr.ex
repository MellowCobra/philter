defmodule Expr do
  defmodule Literal do
    defstruct value: nil
  end

  defmodule Binary do
    defstruct left: nil, operator: nil, right: nil
  end

  defmodule Var do
    defstruct name: nil
  end
end
