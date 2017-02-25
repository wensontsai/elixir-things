defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  # assign comes from here ^
  # halt

  import Phoenix.Controller
  # get_session comes from ^

  # look into conn, grab user_id out of session
  # fetch user
  # tiny transform of conn, and set user model on conn
  # so all plugs/funcs will have user model on conn object after

  alias Discuss.Router.Helpers

  def init(_params) do
    # nothing to init with here.

    # one time for the life of application

    # USECASES for init,..
    # Expensive operations,.. computations after initial query
    # for example... then after that its loaded on conn object

  end

  # called every time request comes through

  def call(conn, _params) do
    # _params comes from init func return..
    # get user_id off session object
    # must return conn

    # if logged in, let them pass through
    # continue
    if conn.assigns[:user] do
      conn
    else 
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      # halt - do not send conn to next plug flow, this conn is done
      |> halt()
    end
    # if not then make them log in

  end

end