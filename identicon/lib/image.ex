defmodule Identicon.Image do
  # struct will hold all data for our app
  # similar to maps but with extras
  # only things we can place on a struct must be declared
  # if we know properties we are working with, 
  # usually use a struct
  defstruct hex: nil

  # to create the struct
  # %Identicon.Image{}
  #> %Identicon.Image{hex: nil}
end