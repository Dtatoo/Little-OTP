defmodule PoolyTest do
  use ExUnit.Case, async: true
  alias Pooly

  describe "Pooly.start/2" do
    test "can start a supervisor process" do
      {:ok, sup_pid} = Pooly.start()
      assert Process.alive?(sup_pid)
    end
  end
end
