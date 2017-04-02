defmodule MySupervisorTest do
  use ExUnit.Case, async: true

  alias Little.{MyWorker, MySupervisor}

  setup do
    {:ok, sup_pid} = MySupervisor.start_link([])
    {:ok, sup_pid: sup_pid}
  end

  describe "MySupervisor.start_link/1" do
    test "can start supervisor", %{sup_pid: sup_pid} do
      assert true === Process.alive? sup_pid
    end
  end

  describe "MySupervisor.start_child/2" do
    test "can add a worker", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      assert Process.alive?(pid) === true
    end

    test "can throw error", %{sup_pid: sup_pid} do
      {error, _message}= MySupervisor.start_child(sup_pid, {MyWorker, :cause_error, []})
      assert error === :error
    end
  end

  describe "MySupervisor.terminate_child" do
    test "can terminate child process" do
    end
  end
end
