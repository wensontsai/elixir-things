defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn -> 
      initial_state = callback_module.init
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(
          request,
          current_state
        )

        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(
          request, 
          current_state
        )

        loop(callback_module, new_state)

    end
  end

  # call => synchronous
  def call(server_pid, request) do
    send(server_pid, {:call, request, self})

    receive do
      {:response, response} ->
        response
    end
  end

  # cast => asynchronous
  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

end


defmodule KeyValueStore do
  # ::
  # callback functions - internal
  # ::
  def init do
    HashDict.new
  end

  def handle_call({:put, key, value}, state) do
    {:ok, HashDict.put(state, key, value)}
  end

  def handle_call({:get, key}, state) do
    {HashDict.get(state, key), state}
  end

  def handle_cast({:put, key, value}, state) do
    HashDict.put(state, key, value)
  end

  # :: 
  # INTERFACE FUNCTIONS 
  # :: #
  def start do
    ServerProcess.start(KeyValueStore)
  end

  def put(pid, key, value) do
    ServerProcess.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    ServerProcess.call(pid, {:get, key})
  end

end