defmodule DPDC.Disassemble.OpMode do
  def load_abc(op, <<c::8, b::8, k::1, a::8>>) do
    %{op: op, a: a, k: k, b: b, c: c}
  end

  def load_abx(op, <<bx::17, a::8>>) do
    %{op: op, a: a, bx: bx}
  end

  @k_sbx Integer.pow(2, 16) - 1

  def load_asbx(op, <<xk::17, a::8>>) do
    sbx = xk - @k_sbx
    %{op: op, a: a, sbx: sbx}
  end

  def load_ax(op, <<ax::25>>) do
    %{op: op, ax: ax}
  end

  @k_sj Integer.pow(2, 24) - 1

  def load_sj(op, <<xk::25>>) do
    sj = xk - @k_sj
    %{op: op, sj: sj}
  end
end
