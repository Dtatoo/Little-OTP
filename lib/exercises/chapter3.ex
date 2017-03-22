defmodule Little.Ex.Chapter3 do
  def send_ping do
    receive do
      {sender, :ping} ->
        send sender, :pong
      {sender, :pong} ->
        send sender, :ping
      _ ->
        send_ping()
    end
    send_ping()
  end

  def create_process do
    process_1 = spawn &send_ping/0
    process_2 = spawn &send_ping/0
    {process_1, process_2}
  end
end
