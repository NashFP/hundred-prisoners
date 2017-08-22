defmodule Puzzle.Room do
  use GenServer
  require Logger

  defstruct [is_light_on?: true, visit_log: []]
  alias __MODULE__, as: State

  def start_link() do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  def log_visit(id, left_with_light_on?) do
    GenServer.cast(__MODULE__, {:log_visit, id, left_with_light_on?})
  end

  def is_light_on?() do
    GenServer.call(__MODULE__, :is_light_on?)
  end

  def get_days_passed() do
    GenServer.call(__MODULE__, :get_days_passed)
  end

  def declare_all_have_visited() do
    GenServer.cast(__MODULE__, :declare_all_have_visited)
  end

  def have_all_prisoners_visited?() do
    GenServer.call(__MODULE__, :have_all_prisoners_visited?)
  end

  def handle_cast({:log_visit, id, left_with_light_on?}, state) do
    {:noreply, state}  
  end
  
  def handle_cast(:declare_all_have_visited, state) do
    {:noreply, state}  
  end
  
  def handle_call(:is_light_on?, _from, state) do
    {:reply, state.is_light_on?, state}
  end
  
  def handle_call(:get_days_passed, _from, state) do
    {:reply, 0, state}
  end

  def handle_call(:have_all_prisoners_visited?, _from, state) do
    {:reply, false, state}
  end

end