defmodule RingTest do
  use ExUnit.Case, async: true

  import Little.Ring

  describe "create_processes/1" do
    test "can create 10 processes" do
      processes = create_processes 10
      assert processes |> Enum.count() === 10
    end
  end

  describe "link_processes/1" do
    test "can link processes" do
      processes = create_processes 2
      assert :ok === link_processes processes
    end

    test "does contain correct link to other processes" do
      pids = create_processes 2
      link_processes pids
      [first_process, second_process] = pids
      with {:links, first_linked} <- Process.info(first_process, :links),
           {:links, second_linked} <- Process.info(second_process, :links)
      do
        assert first_linked === [second_process]
        assert second_linked === [first_process]
      end
    end
  end
end
