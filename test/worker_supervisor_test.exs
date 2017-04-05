defmodule WorkerSupervisorTest do
  use ExUnit.Case
  use Supervisor

  alias Little.Pooly.WorkerSupervisor
  alias Little.SampleWorker

  describe "start_link/1" do
    test "can start a Supervisor with Process" do
      {:ok, worker_sup} = WorkerSupervisor.start_link({SampleWorker, :start_link, []})

      {result, _value} = Supervisor.start_child(worker_sup, [[]])
      assert result === :ok
    end
  end
end
