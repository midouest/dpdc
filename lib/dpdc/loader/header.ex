defmodule Dpdc.Loader.Header do
  def assert(<<bytes::binary>>) do
    bytes
    |> assert_signature
    |> assert_luac_version
    |> assert_luac_format
    |> assert_luac_data
    |> assert_instruction_size
    |> assert_lua_integer_size
    |> assert_lua_number_size
    |> assert_luac_int
    |> assert_luac_num
  end

  defp assert_signature(<<"\eLua", rest::binary>>), do: rest
  defp assert_signature(_), do: raise("Signature did not match")

  defp assert_luac_version(<<0x54, rest::binary>>), do: rest
  defp assert_luac_version(_), do: raise("Luac version did not match")

  defp assert_luac_format(<<0x00, rest::binary>>), do: rest
  defp assert_luac_format(_), do: raise("Luac format did not match")

  defp assert_luac_data(<<0x19, 0x93, 0x0D, 0x0A, 0x1A, 0x0A, rest::binary>>), do: rest
  defp assert_luac_data(_), do: raise("Luac data did not match")

  defp assert_instruction_size(<<0x04, rest::binary>>), do: rest
  defp assert_instruction_size(_), do: raise("Instruction size did not match")

  defp assert_lua_integer_size(<<0x04, rest::binary>>), do: rest
  defp assert_lua_integer_size(_), do: raise("Lua integer size did not match")

  defp assert_lua_number_size(<<0x04, rest::binary>>), do: rest
  defp assert_lua_number_size(_), do: raise("Lua number size did not match")

  defp assert_luac_int(<<0x78, 0x56, 0x00, 0x00, rest::binary>>), do: rest
  defp assert_luac_int(_), do: raise("Luac int did not match")

  defp assert_luac_num(<<0x00, 0x40, 0xB9, 0x43, rest::binary>>), do: rest
  defp assert_luac_num(_), do: raise("Luac num did not match")
end
