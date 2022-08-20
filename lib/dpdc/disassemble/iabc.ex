defmodule DPDC.Disassemble.IABC do
  def load(op, <<c::8, b::8, k::1, a::8>>) do
    %{op: op, a: a, k: k, b: b, c: c}
  end
end
