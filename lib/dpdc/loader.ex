defmodule DPDC.Loader do
  alias DPDC.Loader.Base, as: Base
  alias DPDC.Loader.Header, as: Header
  alias DPDC.Loader.Proto, as: Proto

  def load(<<bytes::binary>>) do
    rest = Header.assert(bytes)
    {sizeupvalues, rest} = Base.load_byte(rest)
    {proto, rest} = Proto.load(rest)

    if sizeupvalues != length(proto.upvalues) do
      raise("Incorrect number of upvalues")
    end

    if rest != "" do
      raise("Not all bytes consumed")
    end

    proto
  end
end
