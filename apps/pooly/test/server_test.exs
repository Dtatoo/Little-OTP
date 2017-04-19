defmodule PoolyServerTest do
  use ExUnit.Case, async: true

  alias Pooly.Application, as: App

  @pool_config [mfa: {SampleWorker, :start_link, []}, size: 5]

  setup do
    {:ok, worker_pid} = SampleWorker.start_link([])
    {:ok, pid} = Server.start_link(worker_pid, @pool_config)

    {:ok, pid: pid}
  end

  describe "Pooly.Application.start/2" do
    test "can start a processes with configuration", %{pid: pid} do
      assert Process.alive?(pid)
    end
  end

  describe "Pooly.Application.start_link/2" do
    test "can return a worker" do
      worker_pid = App.checkout()
      assert Process.alive?(worker_pid)
    end
  end

  describe "Server.checkin/1" do
  end

  describe "Server.status/0" do
  end
end
