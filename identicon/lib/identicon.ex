defmodule Identicon do
  # hashes string
  # and turns into image (generates identicon)
  def main(input) do
    input
    |> hash_input  
    |> pick_color  
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
  def pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    [r, g, b]
  end

  # take 15 values as first 3 out of 5 columns
  # then mirror across on last 2 columns
  # disgard 16th number
  # if number inside square is even, we color
  # if odd, we leave white
  def generate_grid() do
    
  end
end
