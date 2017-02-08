defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  # allows for Topic in Topic.changeset etc.
  alias Discuss.Topic

  # controller.new/2 - takes 2 args
  # fires action/2 - needs to do something i.e. render, etc.
  def new(conn, params) do
    # creates new changeset to create form
    changeset = Topic.changeset(%Topic{}, %{})

    # pass changeset into template
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    topic
  end
end