defmodule Identicon.Image do
  # struct will hold all data for our app
  # similar to maps but with extras
  # only things we can place on a struct must be declared
  # if we know properties we are working with, 
  # usually use a struct
  # initialize all property values
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil

  # to create the struct
  # %Identicon.Image{}
  #> %Identicon.Image{hex: nil}
end