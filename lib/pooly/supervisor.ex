defmodule Little.Pooly.Supervisor do
  use Supervisor

  alias Little.Pooly.Server

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config)
  end

  def init(pool_config) do
    children = [
      worker(Server, [self(), pool_config])
    ]

    opts = [strategy: :one_for_all]

    supervise(children, opts)
  end
end
