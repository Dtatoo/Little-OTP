defmodule Pooly.Supervisor do
  use Supervisor

  alias Pooly.PoolsSupervisor
  alias Pooly.Server

  def start_link(pools_config) do
    Supervisor.start_link(__MODULE__, pools_config, name: __MODULE__)
  end

  def init(pools_config) do
    children = [
      supervisor(PoolsSupervisor, []),
      worker(Server, [pools_config])
    ]

    opts = [strategy: :one_for_all,
            max_restart: 1,
            max_time: 3600]

    supervise(children, opts)
  end
end
