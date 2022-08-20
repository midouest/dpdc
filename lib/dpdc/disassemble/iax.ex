defmodule DPDC.Disassemble.IAX do
  def load(op, <<ax::25>>) do
    %{op: op, ax: ax}
  end
end
