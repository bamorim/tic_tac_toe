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

  def play(_game, x, y) when x < 0 or y < 0 or x > 2 or y > 2 do
    {:error, :out_of_bounds}
  end

  def play(%Game{turn: :x, x: plays} = game, x, y) do
    {:ok, %Game{game | turn: :o, x: MapSet.put(plays, {x, y})}}
  end

  def play(%Game{turn: :o, o: plays} = game, x, y) do
    {:ok, %Game{game | turn: :x, o: MapSet.put(plays, {x, y})}}
  end
end
