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

  describe "Cache.delete/1" do
    test "can remove stored key value pair" do
      Cache.write @key, @value
      Cache.delete @key

      refute Cache.exist? @key
    end

    test "only remove a targeted key value" do
      Cache.write @key, @value
      Cache.write :other_key, @array_value

      Cache.delete @key

      refute Cache.exist? @key
      assert Cache.exist? :other_key
    end
  end

  describe "Cache.clear/0" do
    test "will clear all cache" do
      Cache.write :key_1, @value
      Cache.write :key_2, @array_value
      Cache.write :key_3, @map_value

      Cache.clear @key

      refute Cache.exist? :key_1
      refute Cache.exist? :key_2
      refute Cache.exist? :key_3
    end
  end

  describe "Cache.exist?/1" do
    test "returns true if exist" do
      Cache.write @key, @value

      assert Cache.exist? @key
    end

    test "returns false if exist" do
      refute Cache.exist? @key
    end
  end
end
