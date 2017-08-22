defmodule PuzzleTest do
  use ExUnit.Case
  doctest Puzzle

  test "run everyone through in order repeatedly" do
    visit_stream = 1..100 |> Stream.cycle() |> Stream.take(10_000)
    Puzzle.run(visit_stream)

    
  end
end
