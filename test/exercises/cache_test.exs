defmodule CacheTest do
  use ExUnit.Case, async: true

  alias Little.Cache

  @map %{}
  @array []

  @key :queuetest

  @binary_data "Kevin"
  @array_data [1, 2, 3]
  @map_data %{hello: "world"}

  setup do
    {:ok, pid} = Cache.start_link
    {:pid, pid}
  end

  test "can spawn process" context do
    assert Process.alive? context.pid
  end

  describe "Cache.read/1" do
    test "can read state" do
      Cache.write @key, @binary_data

      {:reply, value} = Cache.read @key
      assert value === @binary_data
    end
  end

  describe "Cache.write/2" do
    test "can write binary" do
      Cache.write @key, @binary_data
      {:reply, value} = Cache.read @key

      assert value === @binary_data
    end

    test "can write array" do
      Cache.write @key, @array_data
      {:reply, value} = Cache.read @key

      assert value === @array_data
    end

    test "can write map" do
      Cache.write @key, @map_data
      {:reply, value} = Cache.read @key

      assert value === @map_data
    end
  end

  describe "Cache.delete/1" do
    test "can remove stored key value pair" do
      Cache.write @key, @binary_data
      Cache.delete @key

      refute Cache.exist? @key
    end

    test "only remove a targeted key value" do
      Cache.write @key, @map_data
      Cache.write :other_key, @array_data

      Cache.delete @key

      refute Cache.exist? @key
      assert Cache.exist? :other_key
    end
  end

  describe "Cache.clear/0" do
    test "will clear all cache" do
      Cache.write :key_1, @value
      Cache.write :key_2, @array_data
      Cache.write :key_3, @map_data

      Cache.clear

      refute Cache.exist? :key_1
      refute Cache.exist? :key_2
      refute Cache.exist? :key_3
    end
  end

  describe "Cache.exist?/1" do
    test "returns true if exist" do
      Cache.write @key, @binary_data

      assert Cache.exist? @key
    end

    test "returns false if does not exist" do
      refute Cache.exist? @key
    end
  end
end
