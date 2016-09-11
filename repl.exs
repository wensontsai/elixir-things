# name = 'elixir'

# IO.puts "Hello\n#{name}"

# hello - fn -> {1,2,3} end
# hello.()

# File.open("./README.md")

# card = 88
# win = fn (88) ->  IO.puts "Bingo!" end
# lose = fn (_) ->  IO.puts "no win" end
# win.(card)
# lose.(card)
# IO.puts bingo.(card)


# --------------------------------- #
# keyword lists
# --------------------------------- #
cook = fn (heat, foods) -> Keyword.values(foods) |> Enum.map(&(heat <> &1 <> " :) ")) end
IO.puts cook.("Fried ", [meat: "sausage", veg: "beans"])

# if statement is a keyword list
if true, do: :this, else: :that
if(true, [do: :this, else: : that])


# --------------------------------- #
# maps
# --------------------------------- #