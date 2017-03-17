defmodule Chapter2Test do
  use ExUnit.Case

  import Little.MeterToFootConverter

  test "zero meter is zero foot!" do
    assert 0 |> convert === 0.0
  end

  test "it will convert meter to foot" do
    assert 1 |> convert === 3.28084
  end
end
