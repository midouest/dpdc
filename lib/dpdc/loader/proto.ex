defmodule DPDC.Loader.Proto do
  defstruct [
    :source,
    :lastdefined,
    :lastlinedefined,
    :numparams,
    :isvararg,
    :maxstacksize,
    :code,
    :k,
    :upvalues,
    :p,
    :lineinfo,
    :abslineinfo,
    :locvars
  ]

  alias __MODULE__, as: Proto
  alias DPDC.Loader.Base

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
    {p, rest} = load_protos(rest, source, sizep)

    {sizelineinfo, rest} = Base.load_int(rest)
    {lineinfo, rest} = Base.load_block(rest, sizelineinfo)
    {sizeabslineinfo, rest} = Base.load_int(rest)
    {abslineinfo, rest} = load_abslineinfo(rest, sizeabslineinfo)
    {sizelocvars, rest} = Base.load_int(rest)
    {locvars, rest} = load_locvars(rest, sizelocvars)
    {sizeupvaluenames, rest} = Base.load_int(rest)
    {upvalues, rest} = load_upvaluenames(rest, upvalues, sizeupvaluenames)

    proto = %Proto{
      source: source,
      lastdefined: lastdefined,
      lastlinedefined: lastlinedefined,
      numparams: numparams,
      isvararg: isvararg,
      maxstacksize: maxstacksize,
      code: code,
      k: k,
      upvalues: upvalues,
      p: p,
      lineinfo: lineinfo,
      abslineinfo: abslineinfo,
      locvars: locvars
    }

    {proto, rest}
  end

  defp load_constants(<<bytes::binary>>, n), do: load_constants(bytes, [], n)
  defp load_constants(<<bytes::binary>>, constants, 0), do: {Enum.reverse(constants), bytes}

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
  defp load_upvalues(<<bytes::binary>>, upvalues, 0), do: {Enum.reverse(upvalues), bytes}

  defp load_upvalues(<<bytes::binary>>, upvalues, n) do
    {in_stack, rest} = Base.load_byte(bytes)
    {idx, rest} = Base.load_byte(rest)
    {kind, rest} = Base.load_byte(rest)
    upvalue = %{name: nil, in_stack: in_stack, idx: idx, kind: kind}
    load_upvalues(rest, [upvalue | upvalues], n - 1)
  end

  defp load_protos(<<bytes::binary>>, psource, n), do: load_protos(bytes, psource, [], n)
  defp load_protos(<<bytes::binary>>, _, protos, 0), do: {Enum.reverse(protos), bytes}

  defp load_protos(<<bytes::binary>>, psource, protos, n) do
    {proto, rest} = load(bytes, psource)
    load_protos(rest, psource, [proto | protos], n - 1)
  end

  defp load_abslineinfo(<<bytes::binary>>, n), do: load_abslineinfo(bytes, [], n)
  defp load_abslineinfo(<<bytes::binary>>, infos, 0), do: {Enum.reverse(infos), bytes}

  defp load_abslineinfo(<<bytes::binary>>, infos, n) do
    {pc, rest} = Base.load_int(bytes)
    {line, rest} = Base.load_int(rest)
    info = %{pc: pc, line: line}
    load_abslineinfo(rest, [info | infos], n - 1)
  end

  defp load_locvars(<<bytes::binary>>, n), do: load_locvars(bytes, [], n)
  defp load_locvars(<<bytes::binary>>, vars, 0), do: {Enum.reverse(vars), bytes}

  defp load_locvars(<<bytes::binary>>, vars, n) do
    {varname, rest} = Base.load_string(bytes)
    {startpc, rest} = Base.load_int(rest)
    {endpc, rest} = Base.load_int(rest)
    var = %{varname: varname, startpc: startpc, endpc: endpc}
    load_locvars(rest, [var | vars], n - 1)
  end

  defp load_upvaluenames(<<bytes::binary>>, upvalues, n),
    do: load_upvaluenames(bytes, upvalues, [], n)

  defp load_upvaluenames(<<bytes::binary>>, upvalues, names, 0) do
    upvalues =
      names
      |> Enum.reverse()
      |> Enum.zip(upvalues)
      |> Enum.map(fn {name, upvalue} ->
        %{upvalue | name: name}
      end)

    {upvalues, bytes}
  end

  defp load_upvaluenames(<<bytes::binary>>, upvalues, names, n) do
    {name, rest} = Base.load_string(bytes)
    load_upvaluenames(rest, upvalues, [name | names], n - 1)
  end
end
