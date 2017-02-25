defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  # assign comes from here ^
  import Phoenix.Controller
  # get_session comes from ^

  # look into conn, grab user_id out of session
  # fetch user
  # tiny transform of conn, and set user model on conn
  # so all plugs/funcs will have user model on conn object after

  alias Discuss.Repo
  alias Discuss.User 

  def init(_params) do
    # nothing to init with here.

    # one time for life of application

    # USECASES for init,..
    # Expensive operations,.. computations after initial query
    # for example... then after that its loaded on conn object

  end

  # called every time request comes through

  def call(conn, _params) do
    # _params comes from init func return..
    # get user_id off session object
    # must return conn

    user_id = get_session(conn, :user_id)

    # case vs cond statements
    # first one that evals to true is executed..
    cond do
      # both assigning user, and also handling conditional true
      user = user_id && Repo.get(User, user_id) ->
        # function to modify is called `assign`
        # but bucket is called `assigns` with an `s`
        assign(conn, :user, user)
        # `assign` comes from Plug.Conn

      # default
      true ->
        assign(conn, :user, nil)
    end
  end

end