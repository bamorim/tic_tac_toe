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

  describe "play/3" do
    test "adds a play to the x player play list" do
      game = TicTacToe.new_game()

      assert {:ok, %Game{turn: :o} = new_game} = TicTacToe.play(game, 0, 0)
      assert new_game.o == game.o
      assert MapSet.size(new_game.x) == 1
      assert {0, 0} in new_game.x
    end

    test "adds a play to the o player play list" do
      {:ok, game} = TicTacToe.new_game() |> TicTacToe.play(0, 0)

      assert {:ok, %Game{turn: :x} = new_game} = TicTacToe.play(game, 1, 0)
      assert new_game.x == game.x
      assert MapSet.size(new_game.o) == 1
      assert {1, 0} in new_game.o
    end

    test "returns error when play is out of bounds" do
      game = TicTacToe.new_game()
      assert {:error, :out_of_bounds} = TicTacToe.play(game, -1, -1)
      assert {:error, :out_of_bounds} = TicTacToe.play(game, 3, 3)
      assert {:error, :out_of_bounds} = TicTacToe.play(game, 0, 3)
      assert {:error, :out_of_bounds} = TicTacToe.play(game, 3, 0)
      assert {:error, :out_of_bounds} = TicTacToe.play(game, 0, -1)
      assert {:error, :out_of_bounds} = TicTacToe.play(game, -1, 0)
    end

    test "returns error when position of play is occupied" do
      {:ok, game} =
        TicTacToe.new_game()
        |> TicTacToe.play(0, 0)
        |> elem(1)
        |> TicTacToe.play(1, 0)

      assert {:error, :occupied} = TicTacToe.play(game, 0, 0)
      assert {:error, :occupied} = TicTacToe.play(game, 1, 0)
    end
  end
end
