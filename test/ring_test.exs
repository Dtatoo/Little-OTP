defmodule RingTest do
  use ExUnit.Case, async: true

  import Little.Ring

  describe "create_processes/1" do
    test "can create 10 processes" do
      processes = create_processes 10
      assert processes |> Enum.count() === 10
    end

    @tag :capture_log
    test "can trap :crash call" do
      [pid1, pid2, pid3] = create_processes 3
      link_processes [pid1, pid2, pid3]

      # Enable pid to trap exit call
      send pid1, :trap_exit
      send pid2, :trap_exit

      Process.sleep(100)
      send pid3, :crash
      Process.sleep(100)

      assert pid1 |> Process.alive? === true
      assert pid2 |> Process.alive? === true
      refute pid3 |> Process.alive? === true
    end
  end

  describe "link_processes/1" do
    test "can link processes" do
      processes = create_processes 2
      assert :ok === link_processes processes
    end

    test "does contain correct link to other processes" do
      [pid1, pid2] = create_processes 2
      :ok = link_processes [pid1, pid2]

      # Make sure message is handled
      Process.sleep(1)
      assert {:links, [pid2]} === Process.info pid1, :links
      assert {:links, [pid1]} === Process.info pid2, :links
    end
  end
end
