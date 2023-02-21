defmodule DesignPatterns.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: DesignPatterns.Worker.start_link(arg)
      # {DesignPatterns.Worker, arg}
      DesignPatterns.Creational.Singleton,
      DesignPatterns.Behavioral.Command.Runner,
      DesignPatterns.Behavioral.Observer.HR
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DesignPatterns.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
