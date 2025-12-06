defmodule AOC.Day06 do
  require Integer
  use Tensor

  def parse_input(filename) do
    case File.cwd!() |> Path.join(filename) |> File.read() do
      {:ok, contents} ->
        String.trim(contents) |> String.split("\n")

      {:error, :enoent} ->
        []
    end
  end

  def part1() do
    parsed_input = parse_input("lib/day06/input.txt")

    instructions =
      parsed_input
      |> Enum.map(fn x -> String.split(x, ~r/ +/) |> Vector.new() end)
      |> Vector.new()

    rows = Enum.to_list(0..(Vector.length(instructions[0]) - 1))

    {_, total} =
      rows
      |> Enum.reduce({0, 0}, fn row, {x_index, sum} ->
        {_, instructions_sum} =
          Enum.reduce(instructions, {0, 0}, fn _, {y_index, instr_sum} ->
            operation = instructions[Vector.length(instructions) - 1][x_index]

            instruction = instructions[y_index][x_index]

            if instruction == operation do
              {y_index + 1, instr_sum}
            else
              case operation do
                "+" -> {y_index + 1, instr_sum + String.to_integer(instruction)}
                "*" -> {y_index + 1, Enum.max([instr_sum, 1]) * String.to_integer(instruction)}
                true -> {y_index + 1, instr_sum}
              end
            end
          end)

        {x_index + 1, sum + instructions_sum}
      end)

    IO.puts(total)
  end

  def part2() do
  end
end
