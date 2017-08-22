defmodule Puzzle.Prisoner do
  use GenServer
  require Logger

  defstruct [id: 0, day: 1, times_in_room: 0, known_count: 0]
  
  alias __MODULE__, as: State

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end

  def spend_day_in_cell(id) do
    GenServer.cast(via_tuple(id), :spend_day_in_cell)
  end

  def visit_room(id) do
    GenServer.call(via_tuple(id), {:visit_room, true})
  end

  def peek(id) do
    GenServer.call(via_tuple(id), :peek)
  end

  defp via_tuple(id), do: {:via, Registry, {PrisonerRegistry, id}}
  
  def init(id) do
    state = %State{id: id}
    {:ok, state}
  end

  def handle_cast(:spend_day_in_cell, state) do
    {:noreply, state}  
  end

  def handle_call(:peek, _from, state) do
    {:reply, state, state} 
  end

  def handle_call({:visit_room, light_on_at_arrival?}, _from, state) do
    {:reply, %{light_on_at_exit: light_on_at_arrival?}, state}  
  end
end