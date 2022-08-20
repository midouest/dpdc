defmodule DPDC.CLI do
  def main(argv \\ []) do
    {parsed, rest} =
      OptionParser.parse!(argv,
        switches: [colors: :boolean],
        aliases: [c: :colors]
      )

    case rest do
      [path] ->
        proto =
          path
          |> DPDC.Load.load_file!()
          |> DPDC.Disassemble.load_proto!()

        IO.inspect(proto, inspect_opts(parsed))

      _ ->
        IO.puts("Usage: dpdc <example.luac>")
    end
  end

  defp inspect_opts([]), do: [limit: :infinity, pretty: true]

  defp inspect_opts(colors: true) do
    Keyword.merge(inspect_opts([]),
      syntax_colors: [
        atom: :cyan,
        binary: :white,
        boolean: :magenta,
        list: :white,
        map: :white,
        number: :yellow,
        string: :green,
        tuple: :white
      ]
    )
  end
end
