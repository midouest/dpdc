defmodule DPDC.Disassemble.ISJ do
  @k trunc(Integer.pow(2, 25) / 2)

  def load(op, <<xk::25>>) do
    sj = xk - @k
    %{op: op, sj: sj}
  end
end
