defmodule DPDC.Disassemble.IABX do
  defstruct [:op, :a, :bx]

  alias __MODULE__, as: IABX

  def load(op, <<bx::17, a::8>>) do
    %IABX{op: op, a: a, bx: bx}
  end
end
