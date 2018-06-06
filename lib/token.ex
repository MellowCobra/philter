defmodule Token do
  defstruct lexeme: '\0', type: :EOF, line: 0, value: nil
end
