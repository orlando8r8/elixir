defmodule Company.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Company.GenServer, []}
    ]

    opts = [strategy: :one_for_one, name: Company.Supervisor]
    Supervisor.start_link(children, opts)
  end
end