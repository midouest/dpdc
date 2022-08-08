# dpdc

Disassemble Playdate Lua bytecode

## Build

```shell
$ mix escript.build
```

## Usage

Use [pdz.py](https://github.com/jaames/playdate-reverse-engineering) to unpack `.luac` files from the `.pdz` file in the `.pdx` bundle.

Execute `dpdc` with the target `.luac` file as the only argument:

```shell
$ ./dpdc path/to/main.luac
```
