defmodule Mix.Tasks.RunDay do
  @moduledoc "The run_day mix task: `mix help run_day`"
  use Mix.Task

  @shortdoc "Calls the part1 and part2 functionsfunction."
  def run(args) do
    module_name = List.first(args)

    apply(String.to_existing_atom("Elixir.AOC." <> module_name), :part1, [])
    apply(String.to_existing_atom("Elixir.AOC." <> module_name), :part2, [])
  end
end
