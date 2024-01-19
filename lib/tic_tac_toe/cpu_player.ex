defmodule TicTacToe.CPUPlayer do
  @moduledoc """
  "AI" player for the game.
  """

  alias TicTacToe.Game

  @spec play(Game.t()) :: {:ok, Game.t()}
  def play(game) do
    x = Enum.random(0..2)
    y = Enum.random(0..2)

    case Game.play(game, x, y) do
      {:ok, new_game} -> {:ok, new_game}
      {:error, :occupied} -> play(game)
      {:error, :game_over} -> {:error, :game_over}
    end
  end
end
