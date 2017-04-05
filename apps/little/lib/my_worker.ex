defmodule Little.MyWorker do
  def start_link do
    spawn(fn -> loop() end)
  end
  def loop do
    receive do
      :stop -> :ok

      msg ->
        IO.inspect msg
        loop()
    end
  end

  def cause_error do
    []
  end
end
