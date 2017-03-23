defmodule CacheTest do
  use ExUnit.Case

  alias Little.Cache

  @key :name
  @value "Testerson"
  @map_value %{hello: world}
  @array_value [1,2,3,4,5]

  test "can spawn process" do
    {:ok, pid}= Cache.start_link()
    assert Process.alive? pid
  end

  describe "Cache.read/1" do
    test "can read state" do
      Cache.write @key, @value
      {:reply, value} = Cache.read @key

      assert value === @value
    end
  end

  describe "Cache.write/2" do
    test "can handle binary type (string)" do
      Cache.write @key, @value
      {:reply, value} = Cache.read @key

      assert value === @value
    end

    test "can handle array type" do
      Cache.write @key, @array_value
      {:reply, value} = Cache.read @key

      assert value === @array_value
    end

    test "can handle map type" do
      Cache.write @key, @map_value
      {:reply, value} = Cache.read @key

      assert value === @map_value
    end
  end
end
