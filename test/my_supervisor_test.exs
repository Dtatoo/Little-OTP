defmodule MySupervisorTest do
  use ExUnit.Case, async: true

  import Little.MySuperVisor

  describe "MySupervisor.start_link/1" do
    test "can start childern" do
      {:ok, sup_pid} = MySupervisor.start_link(child_spec_list)
      assert true === Process.alive? sup_pid
    end
  end
end
