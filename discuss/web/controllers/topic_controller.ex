defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  # allows for Topic in Topic.changeset etc.
  alias Discuss.Topic

  # aliased.. Discuss.Repo.all(Discuss.Topic)
  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
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

  def create(conn, %{"topic" => topic}) do
    # validate
    # insert into db
    changeset = Topic.changeset(%Topic{}, topic)

    # MAGIC - Ecto orm imported with :controller...
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

end