defmodule Stmt do
  defmodule Compound do
    defstruct statements: []
  end

  defmodule Print do
    defstruct expr: nil
  end

  defmodule Assign do
    defstruct name: nil, expr: nil
  end
end
