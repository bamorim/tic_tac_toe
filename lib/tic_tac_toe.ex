defmodule TicTacToe do
  @moduledoc """
  Documentation for `TicTacToe`.
  """

  defmodule Game do
    defstruct [:winner, :turn, :board]
  end

  def new_game do
    %Game{
      winner: nil,
      turn: :x,
      board:
        nil
        |> Tuple.duplicate(3)
        |> Tuple.duplicate(3)
    }
  end

  def get(%Game{board: board}, x, y) do
    board
    |> elem(x)
    |> elem(y)
  end

  def play!(game, x, y) do
    case play(game, x, y) do
      {:ok, game} -> game
      {:error, error} -> raise "play! failed with error #{error}"
    end
  end

  def play(game, x, y) do
    with :ok <- check_game_over(game),
         :ok <- check_play_in_bounds(x, y),
         :ok <- check_play_is_free(game, x, y) do
      {:ok,
       game
       |> do_play(x, y)
       |> next_turn()
       |> maybe_end_game()}
    end
  end

  defp check_game_over(%{winner: nil}), do: :ok
  defp check_game_over(%{winner: _}), do: {:error, :game_over}

  defp check_play_in_bounds(x, y) do
    if x < 0 or y < 0 or x > 2 or y > 2 do
      {:error, :out_of_bounds}
    else
      :ok
    end
  end

  defp check_play_is_free(%Game{} = game, x, y) do
    case get(game, x, y) do
      nil -> :ok
      _ -> {:error, :occupied}
    end
  end

  defp do_play(%Game{turn: player, board: board} = game, x, y) do
    row = board |> elem(x) |> put_elem(y, player)
    board = put_elem(board, x, row)

    %Game{game | board: board}
  end

  defp next_turn(%Game{turn: :x} = game), do: %Game{game | turn: :o}
  defp next_turn(%Game{turn: :o} = game), do: %Game{game | turn: :x}

  defp maybe_end_game(game) do
    case winner(game) do
      nil -> game
      winner -> %Game{game | winner: winner, turn: nil}
    end
  end

  def winner(%Game{board: {row0, row1, row2} = board}) do
    any_empty_cell? =
      board
      |> Tuple.to_list()
      |> Enum.flat_map(&Tuple.to_list/1)
      |> Enum.any?(&is_nil/1)

    if any_empty_cell? do
      {col0, col1, col2} = transpose(board)
      {diag1, diag2} = diagonals(board)

      with nil <- winner_at(row0),
           nil <- winner_at(row1),
           nil <- winner_at(row2),
           nil <- winner_at(col0),
           nil <- winner_at(col1),
           nil <- winner_at(col2),
           nil <- winner_at(diag1),
           nil <- winner_at(diag2) do
        nil
      end
    else
      :tie
    end
  end

  defp transpose({{c00, c01, c02}, {c10, c11, c12}, {c20, c21, c22}}) do
    {{c00, c10, c20}, {c01, c11, c21}, {c02, c12, c22}}
  end

  defp diagonals({
         {c00, _01, c02},
         {_10, c11, _12},
         {c20, _21, c22}
       }) do
    {
      {c00, c11, c22},
      {c20, c11, c02}
    }
  end

  defp winner_at({a, a, a}), do: a
  defp winner_at(_), do: nil
end
