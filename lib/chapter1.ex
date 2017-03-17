defmodule Littel.Recursive do
  def fac n when n == do, do: 1
  def fac n when n > 0 do
    n * fac(n-1)
  end
end
