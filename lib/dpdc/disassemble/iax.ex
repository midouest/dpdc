defmodule DPDC.Disassemble.IAX do
  defstruct [:op, :ax]

  alias __MODULE__, as: IAX

  def load(op, <<ax::25>>) do
    %IAX{op: op, ax: ax}
  end
end
