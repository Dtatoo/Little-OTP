defmodule Little.Metex.GenWorker do
  use GenServer

  @name MW

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def get_temperature location do
    GenServer.call @name, {:location, location}
  end

  def get_state do
    GenServer.call @name, :get_state
  end

  def reset_state do
    GenServer.cast @name, :reset_state
  end

  def stop do
    GenServer.cast @name, :stop
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call {:location, location}, _from, state do
    case temperature_of location do
    {:ok, temp} ->
      new_state = update_state(state, location)
      {:reply, "#{temp}C", new_state}
    _ ->
      {:reply, :error, state}
    end
  end

  def handle_call :get_state, _from, state do
    {:reply, state, state}
  end

  def handle_cast :reset_state, _state do
    {:noreply, %{}}
  end

  def handle_cast :stop, state do
    {:stop, :normal, state}
  end

  def handle_info msg, state do
    IO.puts "received #{inspect msg}"
    {:noreply, state}
  end

  def terminate reason, state do
    IO.puts "server terminated because of #{inspect reason}"
    inspect state
    :ok
  end

  ## Helper Functions
  defp temperature_of location do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  defp url_for location do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end
  defp parse_response(_), do: :error


  defp compute_temperature(json) do
    try do
      # used constant since temperture is coming back as kelvin
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
      rescue
        _ -> :error
    end
  end

  defp apikey(), do: Application.get_env(:little, :api_key)

  defp update_state old_state, location do
    IO.inspect location
    case Map.has_key?(old_state, location) do
      true ->
        Map.update!(old_state, location, &(&1 + 1))
      false ->
        Map.put_new(old_state, location, 1)
    end
  end
end
