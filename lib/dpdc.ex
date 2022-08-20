defmodule DPDC do
  def cast_luaint(n) do
    <<x::integer-signed-little-size(32)>> = n
    x
  end

  def cast_luanum(n) do
    <<x::float-little-size(32)>> = n
    x
  end
end
