defmodule TicTacToe.CPUPlayerTest do
  use ExUnit.Case

  alias TicTacToe.Game
  alias TicTacToe.CPUPlayer

  describe "play/1" do
    test "makes a play for the current player" do
      game = Game.new()

      {:ok, new_game} = CPUPlayer.play(game)
      refute board_is_empty?(new_game)
      assert new_game.turn != game.turn
    end

    test "plays in an non-occupied position" do
      for i <- 0..2, j <- 0..2 do
        game =
          Game.new()
          |> Game.play!(i, j)

        {:ok, new_game} = CPUPlayer.play(game)
        assert board_size(new_game) == board_size(game) + 1
        assert new_game.turn != game.turn
      end
    end
  end

  defp all_cells(%{board: board}) do
    board
    |> Tuple.to_list()
    |> Enum.flat_map(&Tuple.to_list/1)
  end

  defp board_size(game) do
    game
    |> all_cells()
    |> Enum.reject(&is_nil/1)
    |> length()
  end

  defp board_is_empty?(game) do
    game
    |> all_cells()
    |> Enum.all?(&is_nil/1)
  end
end
