defmodule Watchlist.MovieView do
  use Watchlist.Web, :view

  def render("index.json", %{movies: movies}) do
    movies
  end
end