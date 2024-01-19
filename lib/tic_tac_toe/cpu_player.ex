defmodule TicTacToe.CPUPlayer do
  @moduledoc """
  "AI" player for the game.
  """

  alias TicTacToe.Game

  @spec play(Game.t()) :: {:ok, Game.t()} | {:error, :game_over}
  def play(%{winner: nil} = game) do
    {x, y} =
      game
      |> empty_positions()
      |> Enum.sort_by(&evaluate_play(game, &1), :desc)
      # TODO: Test for full board later
      |> List.first()

    Game.play(game, x, y)
  end

  def play(_game), do: {:error, :game_over}

  @spec evaluate_play(Game.t(), {integer(), integer()}) :: integer()
  defp evaluate_play(game, {x, y}) do
    {:ok, new_game} = Game.play(game, x, y)
    evaluate_position(new_game, game.turn)
  end

  # Heuristic taken from:
  # https://kartikkukreja.wordpress.com/2013/03/30/heuristic-function-for-tic-tac-toe/
  @winning_positions [
    [{0, 0}, {0, 1}, {0, 2}],
    [{1, 0}, {1, 1}, {1, 2}],
    [{2, 0}, {2, 1}, {2, 2}],
    [{0, 0}, {1, 0}, {2, 0}],
    [{0, 1}, {1, 1}, {2, 1}],
    [{0, 2}, {1, 2}, {2, 2}],
    [{0, 0}, {1, 1}, {2, 2}],
    [{0, 2}, {1, 1}, {2, 0}]
  ]

  defp evaluate_position(game, player) do
    @winning_positions
    |> Enum.map(&compute_stake(game, player, &1))
    |> Enum.sum()
  end

  defp compute_stake(game, player, positions) do
    counts =
      positions
      |> Enum.map(fn {x, y} -> Game.get(game, x, y) end)
      |> Enum.frequencies()

    other = if player == :x, do: :o, else: :x

    position_stake(Map.get(counts, player, 0), Map.get(counts, other, 0))
  end

  defp position_stake(1, 0), do: 10
  defp position_stake(2, 0), do: 100
  defp position_stake(3, 0), do: 1000
  defp position_stake(0, 1), do: -10
  defp position_stake(0, 2), do: -100
  defp position_stake(0, 3), do: -1000
  defp position_stake(_, _), do: 0

  defp empty_positions(%{board: board}) do
    board
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, x} ->
      row
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.map(fn {cell, y} -> {{x, y}, cell} end)
    end)
    |> Enum.filter(fn {_pos, cell} -> is_nil(cell) end)
    |> Enum.map(&elem(&1, 0))
  end
end
