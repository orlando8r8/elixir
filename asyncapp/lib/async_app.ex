defmodule AsyncApp do
  use Application

  def start(_type, _args) do
    DiceGame.start_game()
    {:ok, self()}
  end
end
