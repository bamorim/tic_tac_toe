defmodule TicTacToeTest do
  use ExUnit.Case
  doctest TicTacToe

  alias TicTacToe.Game

  describe "new_game/0" do
    test "returns an empty board" do
      empty = MapSet.new()
      assert %Game{winner: nil, turn: :x, x: ^empty, o: ^empty} = TicTacToe.new_game()
    end
  end
end
