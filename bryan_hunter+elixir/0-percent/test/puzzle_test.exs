defmodule PuzzleTest do
  use ExUnit.Case
  doctest Puzzle

  test "greets the world" do
    assert Puzzle.hello() == :world
  end
end
