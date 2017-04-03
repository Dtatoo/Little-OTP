defmodule MySupervisorTest do
  use ExUnit.Case, async: true

  alias Little.{MyWorker, MySupervisor}

  setup do
    {:ok, sup_pid} = MySupervisor.start_link([])
    {:ok, sup_pid: sup_pid}
  end

  describe "MySupervisor.start_link/1" do
    test "can start supervisor", %{sup_pid: sup_pid} do
      assert Process.alive? sup_pid
    end
  end

  describe "MySupervisor.start_child/2" do
    test "can add a worker", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      assert Process.alive?(pid)
    end

    test "can throw error", %{sup_pid: sup_pid} do
      {error, _message}= MySupervisor.start_child(sup_pid, {MyWorker, :cause_error, []})
      assert error === :error
    end
  end

  describe "MySupervisor.terminate_child" do
    test "can terminate child process", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      assert Process.alive?(pid)
      MySupervisor.terminate_child sup_pid, pid
      refute Process.alive?(pid)
    end
  end

  describe "MySupervisor.restart_child/3" do
    test "can restart dead process with process id", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      {:ok, new_pid} = MySupervisor.restart_child sup_pid, pid, {MyWorker, :start_link, []}
      refute Process.alive?(pid) # make sure the old process is dead
      assert Process.alive?(new_pid)
    end
  end

  describe "MySupervisor.count_children/1" do
    test "can count zero children", %{sup_pid: sup_pid} do
      size = MySupervisor.count_children sup_pid
      assert size === 0
    end

    test "can count a children", %{sup_pid: sup_pid} do
      MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      size = MySupervisor.count_children sup_pid
      assert size === 1
    end

    test "can multiple childrens", %{sup_pid: sup_pid} do
      MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      size = MySupervisor.count_children sup_pid
      assert size === 3
    end
  end

  describe "MySupervisor.which_children/1" do
    test "can return state with no process", %{sup_pid: sup_pid} do
      empty_state = MySupervisor.which_children sup_pid
      assert empty_state === %{}
    end

    test "can return state with a process", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      state = MySupervisor.which_children sup_pid
      assert state === %{pid => {MyWorker, :start_link, []}}
    end

    test "can return state with mulitple processes", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      {:ok, pid2} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      {:ok, pid3} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      state = MySupervisor.which_children sup_pid
      assert state |> Map.has_key?(pid)
      assert state |> Map.has_key?(pid2)
      assert state |> Map.has_key?(pid3)
      assert state |> Map.values() |> Enum.count() === 3 # make sure state only contain 3 processes
    end
  end

  describe "MySupervisor.handle_info/2" do
    test "can recover from normal crash", %{sup_pid: sup_pid} do
      {:ok, pid} = MySupervisor.start_child(sup_pid, {MyWorker, :start_link, []})
      ref = Process.monitor(pid)
      send pid, :ok
      assert_receive {:DOWN, ^ref, _, _, :normal}, 500
      Process.alive?(pid)|> IO.inspect()
    end
  end

end
