## ----------------------------------------
## UPDATING MAPS
## ----------------------------------------
colors = %{primary: "red"}
#> %{primary: "red"}
colors2 = Map.put(colors, :primary, "blue")
#> %{primary: "blue"}

%{ colors | primary: "blue" }
#> %{primary: "blue"}


## ----------------------------------------
## ADDING VALUES TO MAPS
## ----------------------------------------
Map.put(colors, :secondary_color, "green")
#> %{primary: "red", secondary_color: "green"}


## ----------------------------------------
## KEYWORD LISTS (LISTS AND TUPLES TOGETHER)
## lists that return value of tuple when given key
## ----------------------------------------
colors = [{:primary, "red"}, {:secondary, "green"}]
#> [primary: "red", secondary: "green"]
colors[:primary]
#> "red"
colors = [primary: "red", secondary: "blue"]
#> [primary: "red", secondary: "blue"]

# with maps you can only have one key, and the values overwrite it.
# with keyword list, you can make key as many times as you want, and it will not be overwritten

colors = [primary: "red", primary: "red"]
#> [primary: "red", primary: "red"]

# using Ecto, database queries use keyword lists
query = User.find_where([where: user.age > 10, where: user.subscribed == true])
# or, can drop list brackets if keyword list is LAST argument in function
query = User.find_where(where: user.age > 10, where: user.subscribed == true)
# or dropping parenthesis for last argument
query = User.find_where where: user.age > 10, where: user.subscribed == true
