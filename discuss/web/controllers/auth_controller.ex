defmodule Discuss.AuthController do
  use Discuss.Web, :controller 
  plug Ueberauth

  def callback(conn, params) do
    # conn.assigns place to store some data
    # can use token for making requests on behalf of user acct
    IO.inspect(conn.assigns)
    IO.inspect(params)
  end

end