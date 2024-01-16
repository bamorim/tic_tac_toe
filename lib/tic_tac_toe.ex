defmodule TicTacToe do
  @moduledoc """
  Documentation for `TicTacToe`.
  """

  defmodule Game do
    defstruct [:winner, :turn, :x, :o]
  end

  def new_game do
    %Game{winner: nil, turn: :x, x: MapSet.new(), o: MapSet.new()}
  end

  def play(%Game{turn: :x, x: plays} = game, x, y) do
    {:ok, %Game{game | turn: :o, x: MapSet.put(plays, {x, y})}}
  end

  def play(%Game{turn: :o, o: plays} = game, x, y) do
    {:ok, %Game{game | turn: :x, o: MapSet.put(plays, {x, y})}}
  end
end
