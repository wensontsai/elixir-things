defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  # allows for Topic in Topic.changeset etc.
  alias Discuss.Topic

  # this plug will now execute before any handlers
  # guard clause lets :index pass out of all requests
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  # function plug, only using in single module so do this
  plug :check_topic_owner when action in [:update, :edit, "delete"]
  

  # aliased.. Discuss.Repo.all(Discuss.Topic)
  def index(conn, _params) do
    # %{user: %Discuss.User{__meta__: #Ecto.Schema.Metadata<:loaded, "users">,
    # email: "", id: 1,
    # inserted_at: #Ecto.DateTime<2017-02-25 21:00:58>, provider: "github",
    # token: "",
    # updated_at: #Ecto.DateTime<2017-02-25 21:00:58>}}
    # ^^
    # IO.inspect(conn.assigns)

    # Ecto module provides Repo

    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    # get! tosses back 404 on fail
    # or else `nil` is assigned to topic
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  # controller.new/2 - takes 2 args
  # fires action/2 - needs to do something i.e. render, etc.
  def new(conn, _params) do
    # creates new changeset to create form
    changeset = Topic.changeset(%Topic{}, %{})

    # pass changeset into template
    # MAGIC... creating changeset and passing to form
    render conn, "new.html", changeset: changeset
  end

  # now tie topic created to logged in user_id
  def create(conn, %{"topic" => topic}) do
    # validate
    # insert into db
    # conn.assigns.user is same as conn.assigns[:user]

    # Association API - 
    # Ecto module ->
    # take user
    # pass user to build_assoc
    # assoc with topic

    changeset = conn.assigns.user
      |> build_assoc(:topics)
      # produces Topic Struct, which is piped next
      |> Topic.changeset(topic)

    # MAGIC - Ecto ORM imported with :controller...
    # Repo.insert does validation..
    # if errors, show them form again... ^
    case Repo.insert(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "new.html", changeset: changeset
    end
  end

  # params has :id object
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    # insert changeset into db &&
    # verify update success
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    # get! allows for additional error handling
    # passes a error 422 (record doenst exist or you dont have permissions)
    # we do not need case statement bc of ^
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    # fetch topic out of db
    # validate user_id
    # else redirect
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else 
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      # break pass loop of conn/plugs, send back to client
      |> halt()
    end
  end

end