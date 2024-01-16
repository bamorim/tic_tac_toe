defmodule TicTacToeTest do
  use ExUnit.Case
  doctest TicTacToe

  alias TicTacToe.Game

  describe "new_game/0" do
    test "returns an empty board" do
      assert %Game{
               winner: nil,
               turn: :x,
               board: {
                 {nil, nil, nil},
                 {nil, nil, nil},
                 {nil, nil, nil}
               }
             } = TicTacToe.new_game()
    end
  end

  describe "play!/3" do
    test "returns game if play is fine" do
      game = TicTacToe.new_game()
      {:ok, expected} = TicTacToe.play(game, 0, 0)
      assert ^expected = TicTacToe.play!(game, 0, 0)
    end

    test "raises if play is invalid" do
      game = TicTacToe.new_game()

      assert_raise(RuntimeError, fn ->
        TicTacToe.play!(game, 3, 0)
      end)
    end
  end

  describe "play/3" do
    test "adds a play to the x player play list" do
      game = TicTacToe.new_game()

      assert {:ok, %Game{turn: :o} = new_game} = TicTacToe.play(game, 0, 0)
      assert :x = TicTacToe.get(new_game, 0, 0)
    end

    test "adds a play to the o player play list" do
      game = TicTacToe.new_game() |> TicTacToe.play!(1, 0)

      assert {:ok, %Game{turn: :x} = new_game} = TicTacToe.play(game, 0, 0)
      assert :o = TicTacToe.get(new_game, 0, 0)
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
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 0)
        |> TicTacToe.play!(1, 0)

      assert {:error, :occupied} = TicTacToe.play(game, 0, 0)
      assert {:error, :occupied} = TicTacToe.play(game, 1, 0)
    end

    test "ends game with winner x (row 0)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 0)
        |> TicTacToe.play!(1, 0)
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 0, 2)
    end

    test "ends game with winner o (row 0)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(1, 0)
        |> TicTacToe.play!(0, 0)
        |> TicTacToe.play!(1, 1)
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(2, 0)

      assert {:ok, %Game{winner: :o, turn: nil}} = TicTacToe.play(game, 0, 2)
    end

    test "ends game with winner x (row 1)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(1, 0)
        |> TicTacToe.play!(2, 0)
        |> TicTacToe.play!(1, 1)
        |> TicTacToe.play!(2, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 1, 2)
    end

    test "ends game with winner x (row 2)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(2, 0)
        |> TicTacToe.play!(1, 0)
        |> TicTacToe.play!(2, 1)
        |> TicTacToe.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 2, 2)
    end

    test "ends game with winner x (col 0)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 0)
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(1, 0)
        |> TicTacToe.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 2, 0)
    end

    test "ends game with winner x (col 1)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(0, 2)
        |> TicTacToe.play!(1, 1)
        |> TicTacToe.play!(1, 2)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 2, 1)
    end

    test "ends game with winner x (col 2)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 2)
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(1, 2)
        |> TicTacToe.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 2, 2)
    end

    test "ends game with winner x (diag 1)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 0)
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(1, 1)
        |> TicTacToe.play!(0, 2)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 2, 2)
    end

    test "ends game with winner x (diag 2)" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(2, 0)
        |> TicTacToe.play!(2, 1)
        |> TicTacToe.play!(1, 1)
        |> TicTacToe.play!(2, 2)

      assert {:ok, %Game{winner: :x, turn: nil}} = TicTacToe.play(game, 0, 2)
    end

    test "cannot play when game have a winner" do
      game =
        TicTacToe.new_game()
        |> TicTacToe.play!(0, 0)
        |> TicTacToe.play!(1, 0)
        |> TicTacToe.play!(0, 1)
        |> TicTacToe.play!(1, 1)
        |> TicTacToe.play!(0, 2)

      assert {:error, :game_over} = TicTacToe.play(game, 1, 2)
    end
  end
end
