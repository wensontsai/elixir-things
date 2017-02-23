defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    # get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit
    # put "/topics/:id", TopicController, :update

    # follows RESTful - shortcut gives all verbs
    # `mix phoenix.routes` to see
    resources "/", TopicController
  end

  scope "/auth", Discuss do
    pipe_through :browser # before we hit any route, do pre processing through these

    # ueberauth knows :provider
    get "/:provider", AuthController,  :request # request also defined by ueberauth
    get "/:provider/callback", AuthController, :callback #kickbacks here post Oauth

  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
