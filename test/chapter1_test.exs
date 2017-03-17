defmodule Chapter1Test do
@moduledoc"""
Test for Chatpter 1
"""

  use Exunit.Case
  import Little.Recursive

  test "It will handle 0!" do
    assert fac(0) === 1
  end

end
