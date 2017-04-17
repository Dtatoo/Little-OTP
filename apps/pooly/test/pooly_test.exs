defmodule PoolyTest do
  use ExUnit.Case, async: true
  alias Pooly

  setup do
    {:ok, pid} = Pooly.start([],[])

    on_exit(fn ->
      Application.stop(:pooly)
      Application.unload(:pooly)
      assert_down(pid)
    end)
    {:ok, %{app_pid: pid}}

  end

  describe "Pooly.start/2" do
    test "can start a supervisor process", %{app_pid: pid} do
      assert Process.alive?(pid)
    end

  end

  describe "Pooly.checkout/0" do
    test "can checkout a worker" do
      pid = Pooly.checkout()
      assert Process.alive?(pid)
    end

    test "if there is no worker to checkout it throws noproc" do
      # size 5 is hardcoded
       workers =
         [Pooly.checkout(),
          Pooly.checkout(),
          Pooly.checkout(),
          Pooly.checkout(),
          Pooly.checkout(),
          Pooly.checkout()]

      assert Enum.find(workers, fn worker -> worker === :noproc end)
    end

  end

  # describe "Pooly.checkin/1" do
  #   # test "can return worker pid" do
  #   # end
  # end

  defp assert_down(pid) do
    ref = Process.monitor(pid)
    assert_receive {:DOWN, ^ref, _, _, _}
  end

end

