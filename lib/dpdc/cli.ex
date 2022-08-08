defmodule DPDC.CLI do
  def main(argv \\ []) do
    {_, args} = OptionParser.parse!(argv, switches: [])

    case args do
      [path] ->
        proto =
          path
          |> DPDC.Loader.load_file!()
          |> DPDC.Disasm.load_proto!()

        IO.inspect(proto,
          limit: :infinity,
          pretty: true,
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

      _ ->
        IO.puts("Usage: dpdc <example.luac>")
    end
  end
end
