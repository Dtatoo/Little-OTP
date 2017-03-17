defmodule Chapter2_4Test do
  use ExUnit.Case

  alias Little.MeterToLengthConverter.{Feet, Inch}

  describe "Feet.convert/1" do
    test "zero meter is zero feet" do
      assert 0 |> Feet.convert === 0.0
    end

    test "10 meter is 32.8084 feet" do
      assert 10 |> Feet.convert === 32.8084
    end
  end

  describe "Inch.convert/1" do
    test "zero meter is zero inch" do
      assert 0 |> Inch.convert === 0.0
    end

    test "10 meter is 393.701 inches" do
      assert 10 |> Inch.convert === 393.701
    end
  end
end
