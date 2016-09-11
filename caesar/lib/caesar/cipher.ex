defmodule Caesar.Cipher do
  require Logger

  # @alphabet_size 26
  @alphabet_size Application.get_env(:caesar, :alphabet_size)

  @moduledoc """
  Caesar Cipher module, which maps characters to new characters/
  """

  @doc """
  Encrypt the message by applying a mapping that shifts the alphabet by the 'shift' value.

  ## Examples

    iex> Caesar.Cipher.encrypt("hello world!", 1)
    "gdkkn vnqkc!"
    
  """

  def encrypt(msg, shift) do
    Logger.debug("encrypting \"#{msg}\" with a shift number: #{shift}")
    # convert msg to char_list
    msg
      |> to_char_list
      # iterate over list apply shift mapping
      |> Enum.map(&shift_char(&1, shift))
      # return list as a binary string
      |> List.to_string
  end

  defp shift_char(char, shift) do
    case char do
      chr when chr in (?a..?z) -> calculate_mapping(?a, chr, shift)
      chr when chr in (?A..?Z) -> calculate_mapping(?A, chr, shift)
      chr -> chr
    end
  end

  def calculate_mapping(base_letter, char, shift) do
    # find the ASCII integer of the char and normalize it
    # by subtracting the size of the alphabet
    normalize = &(&1 - @alphabet_size)
    # ensure shift number is within the alphabet size
    shift_num = rem(shift, @alphabet_size)
    # calculate the shifted value
    base_letter + rem(char - normalize  .(base_letter) - shift_num, @alphabet_size)
  end

end