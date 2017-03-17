defmodule Chapter2ExercisesTest do
  use ExUnit.Case, async: true

  def sum([]), do: {:error, "Empty Array"}
  def sum array do
    result = array |> Enum.reduce(fn element, acc -> element + acc end)
    {:ok, result}
  end

  describe "my_sum/1" do
    test "can handle empty array" do
      assert [] |> sum() == {:error, "Empty Array"}
    end

    test "can handle one element" do
      assert [1] |> sum() == {:ok, 1}
    end

    test "can handle more than one element" do
      list = Enum.to_list(1..9)
      assert list |> sum() == {:ok, 45}
    end
  end

end
