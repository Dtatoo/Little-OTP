defmodule Pooly.Supervisor do
  use Supervisor

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config)
  end

  def init(pools_config) do
    children = [
      worker(Pooly.Server, [self(), pool_config])
    ]

    opts = [strategy: :one_for_all,
            max_restart: 1,
            max_time: 3600]

    supervise(children, opts)
  end

end
