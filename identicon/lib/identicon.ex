defmodule Identicon do
  # hashes string
  # and turns into image (generates identicon)
  def main(input) do
    input
    |> hash_input  
    |> pick_color 
    |> build_grid
  end

  # all following functions are step by step
  # pipe functions
  # run by main
  def hash_input(input) do
    # :crypto.hash returns series of bytes that represent input string
    # Base.encode16(hash) returns string hash
    # :binary.bin_to_list(hash) generates list of 16 numbers, that we need to generate an image
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    # sets hex to our struct 
    %Identicon.Image{hex: hex}
  end

  # take first 3 numbers of hash_input(input) as RGB values
  # [head | tail]
  # pattern match directly out of argument list
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # never modify existing data
    # always create new struct, take existing properties from image
    # and throwing color tuple on top of that
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    # pipe operator will stick pass hex in as first arg
    # -> Enum.chunk(hex, 3)

    # if you refer to a function, it will invoke it by default.
    # unlike JS, these are not references!
    # &mirror_row/1 -> & defines a reference to a function
    # and /1 -> defines arity

    # List.flatten flattens nesting 

    # Enum.with_index turns every element in list
    # into a two element tuple, 
    # second value is index
    # ALL iterators in elixir DO NOT tell index!!
    grid = 
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

      # capture grid as result of pipes
      # attach to image struct
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # input -> [145, 46, 200]
    [first, second | _tail] = row

    # output -> [145, 46, 200, 46, 145]
    # ++  => concat list
    row ++ [second, first]
  end

  #### JS equivalent ####
  # pickColor: (image) => {
  #   image.color = {
  #     r: image.hex[0],
  #     g: image.hex[1],
  #     b: image.hex[2]
  #   };
  #   return image
  # }
  #######################

  # take 15 values as first 3 out of 5 columns
  # then mirror across on last 2 columns
  # disgard 16th number
  # if number inside square is even, we color
  # if odd, we leave white
  def generate_grid() do
    
  end
end
