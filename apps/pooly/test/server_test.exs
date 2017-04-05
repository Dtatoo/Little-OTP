defmodule PoolyServerTest do
  use ExUnit.Case, async: true

  alias Pooly.Server
  alias Pooly.SampleWorker

  @pool_config [mfa: {SampleWorker, :start_link, []}, size: 5]

  setup do
    {:ok, pid} = Server.start_link(self(), @pool_config)

    {:ok, pid: pid}
  end

  describe "Server.start_link/2" do
    test "can start a processes with configuration", %{pid: pid} do
      assert Process.alive?(pid)
    end
  end

  describe "Server.checkout/0" do
    test "can return a worker" do
      assert Server.checkout()
    end
  end

  describe "Server.checkin/1" do
  end

  describe "Server.status/0" do
  end
end
