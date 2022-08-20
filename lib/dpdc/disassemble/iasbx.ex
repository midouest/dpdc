defmodule DPDC.Disassemble.IASBX do
  defstruct [:op, :a, :sbx]

  alias __MODULE__, as: IASBX

  @k trunc(Integer.pow(2, 17) / 2)

  def load(op, <<xk::17, a::8>>) do
    sbx = xk - @k
    %IASBX{op: op, a: a, sbx: sbx}
  end
end
