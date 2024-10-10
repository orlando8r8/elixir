defmodule DiceGame do
  @moduledoc """
  A module for simulating a dice game. This module allows you to start a game, roll dice, roll multiple times, and stop the game.

  ## Functions

    * `start_game/0` - Starts the game by spawning a process to listen for dice rolls.
    * `roll_dice/1` - Rolls two dice and sends the result to the listener process.
    * `roll_multiple_times/2` - Rolls the dice multiple times and sends each result to the listener process.
    * `stop_game/1` - Stops the game by sending a stop message to the listener process.
  """

  @doc """
  Starts the game by spawning a process to listen for dice rolls.

  ## Examples

      iex> {:ok, pid} = DiceGame.start_game()
      iex> DiceGame.roll_multiple_times(pid, 5)
      iex> DiceGame.stop_game(pid)

  """
  def start_game do
    pid = spawn(fn -> listen_for_rolls(%{}) end)
    {:ok, pid}
  end

  @doc """
  Rolls two dice and sends the result to the listener process.

  ## Parameters

    - `listener_pid`: The PID of the listener process.

  ## Examples

      iex> {:ok, pid} = DiceGame.start_game()
      iex> DiceGame.roll_dice(pid)
      :ok

  """
  def roll_dice(listener_pid) do
    spawn(fn ->
      die1 = :rand.uniform(6)
      die2 = :rand.uniform(6)
      send(listener_pid, {:dice_roll, die1, die2})
    end)
  end

  @doc """
  Rolls the dice multiple times and sends each result to the listener process.

  ## Parameters

    - `listener_pid`: The PID of the listener process.
    - `n`: The number of times to roll the dice.

  ## Examples

      iex> {:ok, pid} = DiceGame.start_game()
      iex> DiceGame.roll_multiple_times(pid, 3)
      :ok

  """
  def roll_multiple_times(listener_pid, n) when n > 0 do
    for _ <- 1..n do
      roll_dice(listener_pid)
    end
  end

  @doc """
  Stops the game by sending a stop message to the listener process.

  ## Parameters

    - `listener_pid`: The PID of the listener process.

  ## Examples

      iex> {:ok, pid} = DiceGame.start_game()
      iex> DiceGame.stop_game(pid)
      :ok

  """
  def stop_game(listener_pid) do
    send(listener_pid, :stop)
  end

  defp listen_for_rolls(results) do
    receive do
      {:dice_roll, die1, die2} ->
        new_results = Map.update(results, :rolls, 1, &(&1 + 1))
        updated_results = Map.update(new_results, :results, [{die1, die2}], &[{die1, die2} | &1])

        IO.inspect(updated_results)

        listen_for_rolls(updated_results)

      :stop ->
        IO.puts("Stopping the game.")
        IO.inspect(results, label: "Final state")
    end
  end
end