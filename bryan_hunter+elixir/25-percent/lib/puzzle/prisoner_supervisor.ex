defmodule Puzzle.PrisonerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Puzzle.Prisoner, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_child(prisoner_id) do
    Supervisor.start_child(__MODULE__, [prisoner_id])
  end
end