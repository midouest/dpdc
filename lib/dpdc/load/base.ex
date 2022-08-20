defmodule DPDC.Load.Base do
  import Bitwise

  def load_string(<<bytes::binary>>) do
    {n, rest} = load_size(bytes)
    if n == 0, do: {nil, rest}, else: load_block(rest, n - 1)
  end

  def load_number(<<bytes::binary>>) do
    # assume numbers are 4 bytes as in header check
    {n, rest} = load_block(bytes, 4)
    {DPDC.cast_luanum(n), rest}
  end

  def load_integer(<<bytes::binary>>) do
    # assume integers are 4 bytes as in header check
    {n, rest} = load_block(bytes, 4)
    {DPDC.cast_luaint(n), rest}
  end

  def load_block(<<bytes::binary>>, n) do
    block = binary_part(bytes, 0, n)
    rem = byte_size(bytes) - n
    rest = binary_part(bytes, n, rem)
    {block, rest}
  end

  def load_int(<<bytes::binary>>) do
    {n, rest} = load_unsigned(bytes, 2_147_483_647)
    <<x::integer-signed-size(32)>> = <<n::integer-unsigned-size(32)>>
    {x, rest}
  end

  def load_size(<<bytes::binary>>), do: load_unsigned(bytes, ~~~0)

  def load_unsigned(<<bytes::binary>>, limit), do: load_unsigned(bytes, 0, <<limit >>> 7>>)
  def load_unsigned(_, x, limit) when x >= limit, do: raise("Integer overflow")

  def load_unsigned(<<bytes::binary>>, x, limit) do
    {b, rest} = load_byte(bytes)
    x = x <<< 7 ||| (b &&& 0x7F)

    if (b &&& 0x80) != 0x00 do
      {x, rest}
    else
      load_unsigned(rest, x, limit)
    end
  end

  def load_byte(<<byte, rest::binary>>), do: {byte, rest}
end
