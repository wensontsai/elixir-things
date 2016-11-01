defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(Todo.Server, nil)
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end


  def init(params) do
    # GenServer.start returns only after the process has been initialized
    # long-running init/1 function will cause creator process to block
    # long initialization of todo server will block the cache process
    # which is used by many clients

    # can use init/1 to send yourself an internal mesage
    # then initialize the process state in corresponding handle_info callback
    send(self, :real_init)
    register(self, :some_alias) # manual alias registration prevents local registry clash
  end

  def handle_info(:real_init, state) do
    # initialization here

  end

  defmodule Todo.Server do
    use GenServer

    def start do
      GenServer.start(Todo.Server, nil)
    end

    def add_entry(todo_server, new_entry) do
      GenServer.cast(todo_server, {:add_entry, new_entry})
    end

    def entries(todo_server, date) do
      GenServer.call(todo_server, {:entries, date})
    end


    def init(_) do
      {:ok, Todo.List.new}
    end


    # def handle_cast({:add_entry, new_entry}, todo_list) do
    #   new_state = Todo.List.add_entry(todo_list, new_entry)
    #   {:noreply, new_state}
    # end

    def handle_Cast({:add_entry, new_entry}, {name, todo_list}) do
      new_state = Todo.List.add_entry(todo_list, new_entry)
      # persists the data using todo list name as key
      Todo.Database.store(name, new_state)
      # 
      {:noreply, {name, new_state}}
    end


    def handle_call({:entries, date}, _, todo_list) do
      {
        :reply,
        Todo.List.entries(todo_list, date),
        todo_list
      }
    end

    # Needed for testing purposes
    def handle_info(:stop, todo_list), do: {:stop, :normal, todo_list}
    def handle_info(_, state), do: {:noreply, state}
  end
  def handle_cast({:add_entry, new_entry}, todo_list) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    {:noreply, new_state}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      todo_list
    }
  end
end