defmodule DPDC.Load.Header do
  def check!(<<bytes::binary>>) do
    bytes
    |> check_signature!()
    |> check_luac_version!()
    |> check_luac_format!()
    |> check_luac_data!()
    |> check_instruction_size!()
    |> check_lua_integer_size!()
    |> check_lua_number_size!()
    |> check_luac_int!()
    |> check_luac_num!()
  end

  defp check_signature!(<<"\eLua", rest::binary>>), do: rest
  defp check_signature!(_), do: raise("Signature did not match")

  defp check_luac_version!(<<0x54, rest::binary>>), do: rest
  defp check_luac_version!(_), do: raise("Luac version did not match")

  defp check_luac_format!(<<0x00, rest::binary>>), do: rest
  defp check_luac_format!(_), do: raise("Luac format did not match")

  defp check_luac_data!(<<0x19, 0x93, 0x0D, 0x0A, 0x1A, 0x0A, rest::binary>>), do: rest
  defp check_luac_data!(_), do: raise("Luac data did not match")

  defp check_instruction_size!(<<0x04, rest::binary>>), do: rest
  defp check_instruction_size!(_), do: raise("Instruction size did not match")

  defp check_lua_integer_size!(<<0x04, rest::binary>>), do: rest
  defp check_lua_integer_size!(_), do: raise("Lua integer size did not match")

  defp check_lua_number_size!(<<0x04, rest::binary>>), do: rest
  defp check_lua_number_size!(_), do: raise("Lua number size did not match")

  defp check_luac_int!(<<0x78, 0x56, 0x00, 0x00, rest::binary>>), do: rest
  defp check_luac_int!(_), do: raise("Luac int did not match")

  defp check_luac_num!(<<0x00, 0x40, 0xB9, 0x43, rest::binary>>), do: rest
  defp check_luac_num!(_), do: raise("Luac num did not match")
end
