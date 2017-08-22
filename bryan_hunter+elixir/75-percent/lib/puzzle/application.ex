defmodule Puzzle.Application do
  use Application
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Junk.Worker.start_link(arg1, arg2, arg3)
      # worker(Junk.Worker, [arg1, arg2, arg3]),
      worker(Puzzle.Room, []),
      supervisor(Puzzle.PrisonerSupervisor, [])
    ]
    Registry.start_link(keys: :unique, name: PrisonerRegistry)

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Puzzle.Supervisor]
    result = Supervisor.start_link(children, opts)
    
    1..100 |> Enum.each(&(Puzzle.PrisonerSupervisor.start_child(&1)))

    result
  end

end