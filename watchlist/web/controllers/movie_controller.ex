defmodule Watchlist.MovieController do
  use Watchlist.Web, :controller

  def index(conn, _params) do
    render conn, movies: []
  end
end