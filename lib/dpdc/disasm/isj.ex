defmodule DPDC.Disasm.ISJ do
  defstruct [:op, :sj]

  alias __MODULE__, as: ISJ

  @k trunc(Integer.pow(2, 25) / 2)

  def load(op, <<xk::25>>) do
    sj = xk - @k
    %ISJ{op: op, sj: sj}
  end
end
