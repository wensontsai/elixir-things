defmodule Todo.Database do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder,
      name: :database_server
      )
  end

  def store(key, data) do
    # using cast because client not interested in response
    # cast promotes scalability of the system
    # but downside is user can't know if request was successfully handled
    GenServer.cast(:database_server, {:store, key, data})
  end

  def get(key) do
    GenServer.call(:database_server, {:get, key})
  end

  def init(db_folder) do
    # make sure folder exists
    File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  # :
  # GenServer callbacks
  # :
  def handle_cast({:store, key, data}, db_folder) do
    file_name(db_folder, key)
    |> File.write!(:erlant.term_to_binary(data))

    {:noreply, db_folder}
  end

  def handle_call({:get, key}, _, db_folder) do
    data = case File.read(file_name(db_folder, key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      # if file doesn't exist on disk, return nil
      _ -> nil
    end

    {:reply, data, db_folder}
  end

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"
end