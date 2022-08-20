defmodule DPDC.Disassemble.IABC do
  defstruct [:op, :a, :k, :b, :c]

  alias __MODULE__, as: IABC

  def load(op, <<c::8, b::8, k::1, a::8>>) do
    %IABC{op: op, a: a, k: k, b: b, c: c}
  end
end
