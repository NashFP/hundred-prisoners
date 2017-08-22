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
    is_light_on? = Puzzle.Room.is_light_on?()
    GenServer.call(via_tuple(id), {:visit_room, is_light_on?})
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
    new_state = %State{state | day: state.day + 1}
    {:noreply, new_state}  
  end

  def handle_call(:peek, _from, state) do
    {:reply, state, state} 
  end

  def handle_call({:visit_room, light_on_at_arrival?}, _from, state) do
    1..100 
    |> Enum.filter(&(&1 != state.id)) 
    |> Enum.each(&(Puzzle.Prisoner.spend_day_in_cell(&1)))
    
    Puzzle.Room.log_visit(state.id, light_at_exit)

    if (known_count == 100) do
      Logger.warn "On day #{state.day} prisoner #{state.id} declares all prisoners have visited!"
      Puzzle.Room.declare_all_have_visited()
    end
    
    new_state = %State{state | day: state.day + 1, known_count: known_count}
    {:reply, %{light_on_at_exit: light_at_exit}, new_state}  
  end


end