defmodule Little.Cache do
  use GenServer

  @name :cache

  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: @name])
  end

  def write key, value do
    GenServer.cast @name, {:write, key, value}
  end

  def read key do
    GenServer.call @name, {:read, key}
  end

  def delete key do
    GenServer.cast @name, {:delete, key}
  end

  def exist? key do
    GenServer.call @name, {:exist?, key}
  end

  def clear do
    GenServer.cast @name, :clear
  end


  # Server API

  def init :ok do
    {:ok, %{}}
  end

  def handle_cast {:write, key, value}, state do
    new_state = state |> Map.merge(%{key => value})
    {:noreply, new_state}
  end

  def handle_cast {:delete, key}, state do
    new_state = state |> Map.drop([key])
    {:noreply, new_state}
  end

  def handle_cast :clear, _state do
    {:noreply, %{}}
  end

  def handle_call {:read, key}, _from, state do
    value = state |> Map.get(key)
    {:reply, value, state}
  end

  def handle_call {:exist?, key}, _from, state do
    has_key = state |> Map.has_key?(key)
    {:reply, has_key, state}
  end

end
