defmodule Discuss.AuthController do
  use Discuss.Web, :controller 
  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    # conn.assigns place to store some data
    # can use token for making requests on behalf of user acct
    # IO.inspect(conn.assigns)
    # IO.inspect(params)

    # take changeset, insert into db
    # pull email, and token
    # IO.inspect(auth)
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)
    
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  # put_session, put_flash all from Plug.Controller
  
  defp signin(conn, changeset) do
    # cookies are encrypted, no session hijack
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  # changeset has changes property :/
  # returns a user or nil
  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end