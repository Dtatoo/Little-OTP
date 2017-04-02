defmodule Little.MySupervisor do
  use GenServer

  # Client API
  #
  def start_link child_spec_list do
    GenServer.start_link(__MODULE__, [child_spec_list])
  end

  def start_child supervisor, child_spec do
    GenServer.call supervisor, {:start_child, child_spec}
  end

  def terminate_child supervisor, pid when is_pid(pid) do
    GenServer.call supervisor, {:terminate_child, pid}
  end

  def restart_child supervisor, pid, child_spec do
    GenServer.call supervisor, {:restart_child, pid, child_spec}
  end

  def count_children supervisor do
    GenServer.call supervisor, :count_children
  end

  def which_children supervisor do
    GenServer.call supervisor, :which_children
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
