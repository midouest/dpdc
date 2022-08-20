defmodule DPDC.Disassemble.IABX do
  def load(op, <<bx::17, a::8>>) do
    %{op: op, a: a, bx: bx}
  end
end
