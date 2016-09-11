ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Watchlist.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Watchlist.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Watchlist.Repo)

