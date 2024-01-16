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
end
