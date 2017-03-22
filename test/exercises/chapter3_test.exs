defmodule Exercises.Chapter3 do
  use ExUnit.Case

  import Little.Ex.Chapter3

  test "both processes are sucessfully created" do
    {pid, pid2} = create_process()

    assert Process.alive? pid
    assert Process.alive? pid2
  end

  test "can return pong when ping is sent" do
    {pid, _pid2} = create_process()
    send(pid, {self(), :ping})
    receive do
      pong ->
        assert pong === :pong
    end
  end

  test "can return ping when pong is sent" do
    {_pid, pid2} = create_process()
    send(pid2, {self(), :pong})
    receive do
      ping ->
        assert ping === :ping
    end
  end
end
