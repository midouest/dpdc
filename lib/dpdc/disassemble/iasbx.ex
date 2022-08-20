defmodule DPDC.Disassemble.IASBX do
  @k trunc(Integer.pow(2, 17) / 2)

  def load(op, <<xk::17, a::8>>) do
    sbx = xk - @k
    %{op: op, a: a, sbx: sbx}
  end
end
