defmodule Dpdc.Loader do
  defstruct [
    :bytes,
    :size_upvalues,
    :proto
  ]

  alias __MODULE__, as: Loader
  alias Dpdc.Loader.Base, as: Base
  alias Dpdc.Loader.Header, as: Header
  alias Dpdc.Loader.Proto, as: Proto

  def load(<<bytes::binary>>) do
    rest = Header.assert(bytes)

    {size_upvalues, rest} = Base.load_byte(rest)

    {proto, rest} = Proto.load(rest)

    %Loader{bytes: rest, size_upvalues: size_upvalues, proto: proto}
  end
end
