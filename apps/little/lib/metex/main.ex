defmodule Little.Metex do
  alias Little.Metex

  def tempertures_of cities do
    coordinator_pid =
      spawn Metex.Coordinator, :loop, [[], Enum.count cities]

      cities |> Enum.each(&spawn(Metex.Worker, :loop, []) |> send({coordinator_pid, &1}))
  end
end
