defmodule ElixirTodox.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Bandit, plug: ElixirTodox.Router, scheme: :http, port: bandit_port()}
    ]
    opts = [strategy: :one_for_one, name: ElixirTodox.Supervisor]

    Logger.info("Starting Application...")

    Supervisor.start_link(children, opts)
  end

  defp bandit_port, do: Application.get_env(:elixir_todox, :bandit_port, 8000)
end
