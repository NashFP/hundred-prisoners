defmodule Puzzle do
  def run() do
    1..100 
    |> Stream.cycle()
    |> Stream.take(10_000)
    |> run()
  end

  def run(visit_stream) do
    visit_stream
    |> Enum.each(&(Puzzle.Prisoner.visit_room(&1)))
  end
end
