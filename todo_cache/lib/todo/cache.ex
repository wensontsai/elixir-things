defmodule Todo.Cache do
  use GenServer

  def init(_) do
    {:ok, HashDict.new}
  end

  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    # HashDict.fetch queries map
    case HashDict.fetch(todo_servers, todo_list_name) do
      # server exists in the map
      # we return value, leaving state unchanged
      {:ok, todo_server} -> 
        {:reply, todo_server, todo_servers}
      
      # server doesnt exist
      :error ->
        {:ok, new_server} = Todo.Server.start

        # we start a new server, return its pid
        # and insert name-value pair in the process state
        {
          :reply,
          new_server,
          HashDict.put(todo_servers, todo_list_name, new_server)
        }
    end
  end

  # :
  # INTERFACE FUNCTIONS
  # :
  def start do
    # __MODULE__ is replaced with name of current module during compilation
    # guards code against possible change of hardcoded module name
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

end