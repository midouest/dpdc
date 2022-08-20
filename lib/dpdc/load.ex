defmodule DPDC.Load do
  alias DPDC.Load.Base, as: Base
  alias DPDC.Load.Header, as: Header
  alias DPDC.Load.Proto, as: Proto

  def load_file!(path) do
    path
    |> File.read!()
    |> load_binary!()
  end

  def load_binary!(<<bytes::binary>>) do
    # See https://github.com/lua/lua/blob/v5.4-beta/lundump.c for loading the
    # luac format used by pdc
    rest = Header.check!(bytes)
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
