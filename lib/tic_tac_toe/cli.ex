defmodule TicTacToe.CLI do
  alias TicTacToe.Game
  alias TicTacToe.CPUPlayer

  def main(_args) do
    Game.new()
    |> maybe_start_with_cpu_player()
    |> game_loop()
  end

  defp maybe_start_with_cpu_player(game) do
    if Enum.random([true, false]) do
      {:ok, game} = CPUPlayer.play(game)
      game
    else
      game
    end
  end

  defp game_loop(%Game{winner: nil} = game) do
    render_board(game.board) |> IO.puts()
    IO.puts("Current turn: #{render_cell(game.turn)}")

    game
    |> play_loop()
    |> game_loop()
  end

  defp game_loop(game) do
    render_board(game.board) |> IO.puts()
    IO.puts("Game is Over!")
    game.winner |> render_result() |> IO.puts()
  end

  defp play_loop(game) do
    {x, y} = ask_play()

    case Game.play(game, x, y) do
      {:ok, game} ->
        IO.puts("")

        case CPUPlayer.play(game) do
          {:ok, game} -> game
          _ -> game
        end

      {:error, error} ->
        render_error(error) |> IO.puts()
        IO.puts("")
        play_loop(game)
    end
  end

  @template """
            +-----+-----+-----+
            |     |     |     |
            |  ?  |  ?  |  ?  |
            |     |     |     |
            +-----+-----+-----+
            |     |     |     |
            |  ?  |  ?  |  ?  |
            |     |     |     |
            +-----+-----+-----+
            |     |     |     |
            |  ?  |  ?  |  ?  |
            |     |     |     |
            +-----+-----+-----+
            """
            |> String.split("?")

  defp render_board(rows) do
    rows
    |> Tuple.to_list()
    |> Enum.flat_map(&Tuple.to_list/1)
    |> Enum.map(&render_cell/1)
    |> then(&["" | &1])
    |> Enum.zip(@template)
    |> Enum.map_join(fn {left, right} -> left <> right end)
  end

  defp render_cell(:x), do: "X"
  defp render_cell(:o), do: "O"
  defp render_cell(nil), do: " "

  defp render_error(:out_of_bounds), do: "Error: play is out of bounds!"
  defp render_error(:occupied), do: "Error: cannot play in occupied cell!"

  defp render_result(:tie), do: "It's a tie!"
  defp render_result(winner), do: "#{render_cell(winner)} wins!"

  defp ask_play() do
    input = IO.gets("Next play? (format row,col)\n> ")

    with [row, col] <- String.split(input, ~r/\s*,\s*/),
         {row, _} <- Integer.parse(row),
         {col, _} <- Integer.parse(col) do
      {row, col}
    else
      _ ->
        ask_play()
    end
  end
end
