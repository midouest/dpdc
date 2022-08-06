defmodule Dpdc.Loader.Proto do
  defstruct [
    :source,
    :lastdefined,
    :lastlinedefined,
    :numparams,
    :isvararg,
    :maxstacksize,
    :code,
    :sizecode,
    :k,
    :sizek,
    :sizeupvalues,
    :upvalues,
    :sizep,
    :p,
    :lineinfo,
    :sizelineinfo,
    :sizeabslineinfo,
    :abslineinfo,
    :locvars,
    :sizelocvars
  ]

  alias __MODULE__, as: Proto
  alias Dpdc.Loader.Base

  def load(<<bytes::binary>>, psource \\ nil) do
    {source, rest} =
      case Base.load_string(bytes) do
        {nil, rest} ->
          {psource, rest}

        {source, rest} ->
          {source, rest}
      end

    {lastdefined, rest} = Base.load_int(rest)
    {lastlinedefined, rest} = Base.load_int(rest)

    {numparams, rest} = Base.load_byte(rest)
    {isvararg, rest} = Base.load_byte(rest)
    {maxstacksize, rest} = Base.load_byte(rest)

    {sizecode, rest} = Base.load_int(rest)
    {code, rest} = Base.load_block(rest, sizecode * 4)

    {sizek, rest} = Base.load_int(rest)
    {k, rest} = load_constants(rest, sizek)

    {sizeupvalues, rest} = Base.load_int(rest)
    {upvalues, rest} = load_upvalues(rest, sizeupvalues)

    {sizep, rest} = Base.load_int(rest)
    # {p, rest} = load_protos(rest, source, sizep)

    proto = %Proto{
      source: source,
      lastdefined: lastdefined,
      lastlinedefined: lastlinedefined,
      numparams: numparams,
      isvararg: isvararg,
      maxstacksize: maxstacksize,
      sizecode: sizecode,
      code: code,
      sizek: sizek,
      k: k,
      sizeupvalues: sizeupvalues,
      upvalues: upvalues,
      sizep: sizep
      # p: p
    }

    {proto, rest}
  end

  defp load_constants(<<bytes::binary>>, n), do: load_constants(bytes, [], n)
  defp load_constants(<<bytes::binary>>, constants, 0), do: {constants, bytes}

  defp load_constants(<<bytes::binary>>, constants, n) do
    {t, rest} = Base.load_byte(bytes)

    {constant, rest} =
      case t do
        3 ->
          Base.load_integer(rest)

        4 ->
          Base.load_string(rest)

        19 ->
          Base.load_number(rest)

        _ ->
          raise("Unrecognized constant type #{t}")
      end

    load_constants(rest, [constant | constants], n - 1)
  end

  defp load_upvalues(<<bytes::binary>>, n), do: load_upvalues(bytes, [], n)
  defp load_upvalues(<<bytes::binary>>, upvalues, 0), do: {upvalues, bytes}

  defp load_upvalues(<<bytes::binary>>, upvalues, n) do
    {in_stack, rest} = Base.load_byte(bytes)
    {idx, rest} = Base.load_byte(rest)
    {kind, rest} = Base.load_byte(rest)
    upvalue = %{name: nil, in_stack: in_stack, idx: idx, kind: kind}
    load_upvalues(rest, [upvalue | upvalues], n - 1)
  end

  # defp load_protos(<<bytes::binary>>, psource, n), do: load_protos(bytes, psource, [], n)
  # defp load_protos(<<bytes::binary>>, _, protos, 0), do: {protos, bytes}

  # defp load_protos(<<bytes::binary>>, psource, protos, n) do
  #   {proto, rest} = load(bytes, psource)
  #   load_protos(rest, psource, [proto | protos], n - 1)
  # end
end
