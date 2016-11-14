defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Returns a list of strings that represent a deck of playing cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for value <- values, suit <- suits do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be in the hand.

  ## Examples
      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
  """
  def deal(deck, hand_size) do
    # returns a tuple
    # {deck, the rest of deck}
    # to extract, you must pattern match to access
    # because elements match, they are assigned from RIGHT to LEFT hand side
    # MIRROR
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    # calling erlang code with :erlang
    # deck argument converted to saveable object in file system
    # pass to File.write
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    # {status, binary} = File.read(filename)

    # case status do
    #   :ok -> :erlang.binary_to_term(binary)
    #   :error -> "That file does not exist!"
    # end

    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    # no need for assigning deck var
    # return value is automatically passed to next 
    # through pipe as 1st argument
    # therefore, be careful with consistent FIRST ARGUMENT
    Cards.create_deck 
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end
