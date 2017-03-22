defmodule Chapter2Test do
  use ExUnit.Case, async: true

  import Little.MeterToFootConverter

  alias Little.MeterToLengthConverter.{Feet, Inch, FeetInchYard}

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

  describe "Foot.convert/1" do
    test "zero meter is zero foot!" do
      assert 0 |> convert === 0.0
    end

    test "it will convert meter to foot" do
      assert 1 |> convert === 3.28084
    end
  end

  describe "FeetInchYard.convert/2" do
    test "when number isn't given" do
      assert_raise FunctionClauseError, fn -> FeetInchYard.convert(:feet, "string") end
      assert_raise FunctionClauseError, fn -> FeetInchYard.convert(:inch, "string") end
      assert_raise FunctionClauseError, fn -> FeetInchYard.convert(:yard, "string") end
    end

    test "0 meter is still 0 in any other units" do
      assert FeetInchYard.convert(:feet, 0) === 0.0
      assert FeetInchYard.convert(:inch, 0) === 0.0
      assert FeetInchYard.convert(:yard, 0) === 0.0
    end

    test "10 meter to other units convert test" do
      assert FeetInchYard.convert(:feet, 10) === 32.8084
      assert FeetInchYard.convert(:inch, 10) === 393.701
      assert FeetInchYard.convert(:yard, 10) === 10.9361
    end
  end
end
