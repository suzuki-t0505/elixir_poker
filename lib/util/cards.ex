defmodule Cards do

  def main do
    deck =
      create_deckpath
      |> shuffle()
    {mydeck, deck} = deal(deck, 5)
    {enemydeck, _}= deal(deck, 5)
    {mydeck,enemydeck}
  end
  def create_deck do
    number = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Spead", "Clover", "Diamond", "Heart"]

    for num <- number, suit <- suits do
      "#{num}_of_#{suit}"
    end
  end

  def shuffle(deck), do: Enum.shuffle(deck)


  def contains?(deck, str), do: Enum.member?(deck, str)


  def deal(deck, deal_size) do
    Enum.split(deck, deal_size)
  end


  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end


  def load(filename) do
    {status, binary} = File.read(filename)

    case status do
      :ok -> :erlang.binary_to_term(binary)
      :error -> "ファイルが違います"
    end
  end

  def create_deckpath do
    number = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    suits = ["spade", "club", "diamond", "heart"]

    for num <- number, suit <- suits do
      "#{suit}_#{num}"
    end
  end

  def chacksuits(deck) do
    data =
    Enum.map(deck, & String.split(&1, "_") |> Enum.at(0))
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.filter(& &1 == 5)

    case data do
      [5] -> check_straight(deck)
      [] -> pair(deck)
    end
  end

  def check_straight(deck) do
    card = changenumber(deck) |> Enum.sort()
    max = Enum.max(card)
    min = Enum.min(card)

    cond do
      card == [10, 11, 12, 13, 14] -> 9
      true -> if max - min == 4, do: 8, else: 5
    end
  end

  def pair(deck) do
    card = changenumber(deck) |> Enum.sort()
    max = Enum.max(card)
    min = Enum.min(card)

    cond do
      max - min == 4 -> 4
      true -> chackrole(card)
    end
  end

  def changenumber(deck) do
    changei =
    &cond do
      &1 == "A" -> 14
      &1 == "J" -> 11
      &1 == "Q" -> 12
      &1 =="K" -> 13
      true -> String.to_integer(&1)
    end

    Enum.map(deck, &String.replace(&1, ["spade_", "club_", "diamond_", "heart_"], "") |> changei.())

  end
  def chackrole(deck) do
    chack =
    &cond do
      &1 == [2] -> 1
      &1 == [2, 2] -> 2
      &1 == [3] -> 3
      &1 == [2, 3] -> 6
      &1 == [3, 2] -> 6
      &1 == [4] -> 7
      true -> 0
    end
    Enum.frequencies(deck)
    |> Map.values()
    |> Enum.filter(& &1 >= 2)
    |> chack.()
  end

  def winorlose(mypoint, enemypoint) do
    cond do
      mypoint > enemypoint -> "Your Win"
      enemypoint > mypoint -> "Your Lose"
      true -> "Draw"
    end
  end

  def pairviw(pair) do
    case pair do
      0 -> "ノーペア"
      1 -> "ワンペア"
      2 -> "ツーペア"
      3 -> "スリーカード"
      4 -> "ストレート"
      5 -> "フラッシュ"
      6 -> "フルハウス"
      7 -> "フォーカード"
      8 -> "ストレート・フラッシュ"
      9 -> "ロイヤル・ストレート・フラッシュ"
    end
  end

end
