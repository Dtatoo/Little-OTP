defmodule Chapter1Test do
  use ExUnit.Case

  import Little.Recursive

  test "It will handle 0!" do
    assert fac(0) === 1
  end
end
