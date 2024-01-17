# TicTacToe

This is an implementation of a CLI-based TicTacToe game.

## Building

To build it, you need:

- Elixir
- Erlang

Easiest way is to use [asdf](https://asdf-vm.com/) and install the versions defined in `.tool-versions`

Then you just do:
- `mix deps.get`
- `mix escript.build`

## Running

After building, you should have an executable named `tic_tac_toe` which you can run with `./tic_tac_toe`

## Ensuring quality

This repository uses:
- ExUnit for unit tests
- Dialyzer for type checking

Before running tests or dialyzer, make sure you fetched dependencies with `mix deps.get`

To run all tests, just run `mix test`. To check types with dialyzer do `mix dialyzer`.