# dpdc

Disassemble Playdate Lua bytecode

## Usage

Use [pdz.py](https://github.com/jaames/playdate-reverse-engineering) to unpack `.luac` files from the `.pdz` file in the `.pdx` bundle.

The disassembler can be used interactively by executing `iex -S mix` in a terminal:

```elixir
iex(1)> proto = DPDC.Loader.load_file!("path/to/main.luac")
%DPDC.Loader.Proto{...}
```
