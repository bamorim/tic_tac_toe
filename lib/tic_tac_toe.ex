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
    with :ok <- check_play_in_bounds(x, y),
         :ok <- check_play_is_free(game, x, y) do
      {:ok,
       game
       |> do_play(x, y)
       |> next_turn()}
    end
  end

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
end
