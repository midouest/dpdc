defmodule DPDC.CLI do
  def main(argv \\ []) do
    {_, args} = OptionParser.parse!(argv, switches: [])

    case args do
      [path] ->
        proto = DPDC.Loader.load_file!(path)

        IO.inspect(proto,
          limit: :infinity,
          pretty: true,
          syntax_colors: [
            atom: :cyan,
            binary: :black,
            boolean: :magenta,
            list: :black,
            map: :black,
            number: :yellow,
            string: :green,
            tuple: :black
          ]
        )

      _ ->
        IO.puts("Usage: dpdc <example.luac>")
    end
  end
end
