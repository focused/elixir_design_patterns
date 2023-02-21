defmodule DesignPatterns.Behavioral.ObserverTest do
  use ExUnit.Case
  alias DesignPatterns.Behavioral.Observer.{Employee, HR, Payroll}

  test "handles observing event" do
    fred = %Employee{name: "Fred Flinstone", title: "Crane Operator", salary: 30000}
    {:ok, pid} = Payroll.start_link(self())

    :sys.replace_state(HR, fn _ -> %{event_handler: pid, employee: fred} end)

    assert HR.update(%{salary: 35000}) == :ok
    employee = %Employee{fred | salary: 35000}

    assert %{employee: ^employee, event_handler: ^pid} = :sys.get_state(HR)
    assert_received {:changed, ^employee}
  end
end
