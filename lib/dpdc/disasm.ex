defmodule DPDC.Disasm do
  alias DPDC.Disasm.OpCode
  alias DPDC.Loader.Proto

  def load_proto!(proto) do
    proto
    |> Proto.update_code(&load_instructions!/1)
    |> Proto.update_protos(&load_proto!/1)
  end

  defp load_instructions!(<<bytes::binary>>), do: load_instructions!(bytes, [])
  defp load_instructions!(<<>>, instructions), do: Enum.reverse(instructions)

  defp load_instructions!(<<bytes::little-32, rest::binary>>, instructions) do
    load_instructions!(rest, [load_instruction!(<<bytes::32>>) | instructions])
  end

  defp load_instruction!(<<rest::25, op_code::7>>) do
    with op when op != nil <- Enum.at(OpCode.op_codes(), op_code),
         mode when mode != nil <- Map.get(OpCode.op_modes(), op),
         fun when fun != nil <- Map.get(OpCode.mode_funs(), mode) do
      fun.(op, <<rest::25>>)
    else
      _ -> raise "Unrecognized op code: #{op_code}"
    end
  end
end
