defmodule DesignPatterns.Behavioral.CommandTest do
  use ExUnit.Case
  alias DesignPatterns.Behavioral.Command.{Copy, Create, Delete, Runner}

  test "runs commands" do
    :sys.replace_state(Runner, fn _ -> %{done: [], undone: []} end)

    commands = [
      {Create, "file1.txt", data: "hello world"},
      {Copy, "file1.txt", to: "file2.txt"},
      {Delete, "file1.txt"}
    ]

    assert Runner.exec(commands) == :ok
    assert :sys.get_state(Runner) == %{done: Enum.reverse(commands), undone: []}

    assert Runner.undo() == :ok
    assert Runner.undo() == :ok
    assert Runner.undo() == :ok
    assert :sys.get_state(Runner) == %{done: [], undone: commands}

    assert Runner.redo() == :ok
    assert Runner.redo() == :ok
    assert Runner.redo() == :ok
    assert :sys.get_state(Runner) == %{done: Enum.reverse(commands), undone: []}
  end
end
