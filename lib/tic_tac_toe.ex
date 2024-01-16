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

  def play!(game, x, y) do
    case play(game, x, y) do
      {:ok, game} -> game
      {:error, error} -> raise "play! failed with error #{error}"
    end
  end

  def play(game, x, y) do
    with :ok <- check_play_in_bounds(x, y),
         :ok <- check_play_is_free(game, x, y) do
      {:ok, do_play(game, x, y)}
    end
  end

  defp check_play_in_bounds(x, y) do
    if x < 0 or y < 0 or x > 2 or y > 2 do
      {:error, :out_of_bounds}
    else
      :ok
    end
  end

  defp check_play_is_free(%Game{x: x_plays, o: o_plays}, x, y) do
    if {x, y} in x_plays or {x, y} in o_plays do
      {:error, :occupied}
    else
      :ok
    end
  end

  defp do_play(%Game{turn: :x, x: plays} = game, x, y) do
    %Game{game | turn: :o, x: MapSet.put(plays, {x, y})}
  end

  defp do_play(%Game{turn: :o, o: plays} = game, x, y) do
    %Game{game | turn: :x, o: MapSet.put(plays, {x, y})}
  end
end
