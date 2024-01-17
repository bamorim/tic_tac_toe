defmodule Game.GameTest do
  use ExUnit.Case

  alias TicTacToe.Game

  describe "new/0" do
    test "returns an empty board" do
      assert %Game{
               winner: nil,
               turn: :x,
               board: {
                 {nil, nil, nil},
                 {nil, nil, nil},
                 {nil, nil, nil}
               }
             } = Game.new()
    end
  end

  describe "play!/3" do
    test "returns game if play is fine" do
      game = Game.new()
      {:ok, expected} = Game.play(game, 0, 0)
      assert ^expected = Game.play!(game, 0, 0)
    end

    test "raises if play is invalid" do
      game = Game.new()

      assert_raise(RuntimeError, fn ->
        Game.play!(game, 3, 0)
      end)
    end
  end

  describe "play/3" do
    test "adds a play to the x player play list" do
      game = Game.new()

      assert {:ok, %Game{turn: :o} = new_game} = Game.play(game, 0, 0)
      assert :x = Game.get(new_game, 0, 0)
    end

    test "adds a play to the o player play list" do
      game = Game.new() |> Game.play!(1, 0)

      assert {:ok, %Game{turn: :x} = new_game} = Game.play(game, 0, 0)
      assert :o = Game.get(new_game, 0, 0)
    end

    test "returns error when play is out of bounds" do
      game = Game.new()
      assert {:error, :out_of_bounds} = Game.play(game, -1, -1)
      assert {:error, :out_of_bounds} = Game.play(game, 3, 3)
      assert {:error, :out_of_bounds} = Game.play(game, 0, 3)
      assert {:error, :out_of_bounds} = Game.play(game, 3, 0)
      assert {:error, :out_of_bounds} = Game.play(game, 0, -1)
      assert {:error, :out_of_bounds} = Game.play(game, -1, 0)
    end

    test "returns error when position of play is occupied" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(1, 0)

      assert {:error, :occupied} = Game.play(game, 0, 0)
      assert {:error, :occupied} = Game.play(game, 1, 0)
    end

    test "ends game with winner x (row 0)" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(1, 0)
        |> Game.play!(0, 1)
        |> Game.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 0, 2)
    end

    test "ends game with winner o (row 0)" do
      game =
        Game.new()
        |> Game.play!(1, 0)
        |> Game.play!(0, 0)
        |> Game.play!(1, 1)
        |> Game.play!(0, 1)
        |> Game.play!(2, 0)

      assert {:ok, %Game{winner: :o, turn: nil}} = Game.play(game, 0, 2)
    end

    test "ends game with winner x (row 1)" do
      game =
        Game.new()
        |> Game.play!(1, 0)
        |> Game.play!(2, 0)
        |> Game.play!(1, 1)
        |> Game.play!(2, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 1, 2)
    end

    test "ends game with winner x (row 2)" do
      game =
        Game.new()
        |> Game.play!(2, 0)
        |> Game.play!(1, 0)
        |> Game.play!(2, 1)
        |> Game.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 2, 2)
    end

    test "ends game with winner x (col 0)" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(0, 1)
        |> Game.play!(1, 0)
        |> Game.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 2, 0)
    end

    test "ends game with winner x (col 1)" do
      game =
        Game.new()
        |> Game.play!(0, 1)
        |> Game.play!(0, 2)
        |> Game.play!(1, 1)
        |> Game.play!(1, 2)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 2, 1)
    end

    test "ends game with winner x (col 2)" do
      game =
        Game.new()
        |> Game.play!(0, 2)
        |> Game.play!(0, 1)
        |> Game.play!(1, 2)
        |> Game.play!(1, 1)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 2, 2)
    end

    test "ends game with winner x (diag 1)" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(0, 1)
        |> Game.play!(1, 1)
        |> Game.play!(0, 2)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 2, 2)
    end

    test "ends game with winner x (diag 2)" do
      game =
        Game.new()
        |> Game.play!(2, 0)
        |> Game.play!(2, 1)
        |> Game.play!(1, 1)
        |> Game.play!(2, 2)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 0, 2)
    end

    test "cannot play when game have a winner" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(1, 0)
        |> Game.play!(0, 1)
        |> Game.play!(1, 1)
        |> Game.play!(0, 2)

      assert {:error, :game_over} = Game.play(game, 1, 2)
    end

    test "ends game with a tie" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(0, 1)
        |> Game.play!(1, 1)
        |> Game.play!(0, 2)
        |> Game.play!(1, 2)
        |> Game.play!(1, 0)
        |> Game.play!(2, 0)
        |> Game.play!(2, 2)

      assert {:ok, %Game{winner: :tie, turn: nil}} = Game.play(game, 2, 1)
    end

    test "can win on the last possible play" do
      game =
        Game.new()
        |> Game.play!(0, 0)
        |> Game.play!(0, 1)
        |> Game.play!(0, 2)
        |> Game.play!(1, 0)
        |> Game.play!(1, 1)
        |> Game.play!(1, 2)
        |> Game.play!(2, 1)
        |> Game.play!(2, 0)

      assert {:ok, %Game{winner: :x, turn: nil}} = Game.play(game, 2, 2)
    end
  end
end
