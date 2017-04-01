defmodule Little.MySupervisor do
  use GenServer

  # Client API
  #
  def start_link child_spec_list do
    GenServer.start_link(__MODULE__, [child_spec_list])
  end

  # Server API

  def init [child_spec_list] do
    Process.flag :trab_exit, true
    state = child_spec_list
      |> start_children()
      |> Enum.into(Map.new())
    {:ok, state}
  end

  def handle_call {:start_child, child_spec}, _from, state do
      case start_child(child_spec) do
        {:ok, pid} ->
          new_state = Map.put state, pid, child_spec
          {:reply, {:ok, pid}, new_state}
        :error ->
          {:reply, {:error, "error starting child"}, state}
      end
  end

#   # Helper function
  defp start_children [child_spec | rest] do
    case start_child child_spec do
      {:ok, pid} ->
        [{pid, child_spec} | start_children rest]
      :error ->
        :error
    end
  end
  defp start_children [], do: []

  defp start_child {mod, fun, args} do
    case apply(mod, fun, args)do
      pid when is_pid(pid) ->
        Process.link pid
        {:ok, pid}
      _ ->
        :error
    end
  end
end
