defmodule AOC.Day05 do
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
    input = parse_input("lib/day05/input.txt")

    divider_index = Enum.find_index(input, fn x -> x == "" end)

    fresh_ranges = input |> Enum.slice(0..(divider_index - 1))
    ids = input |> Enum.slice((divider_index + 1)..length(input))

    fresh_ids =
      ids
      |> Enum.reduce(0, fn id, acc ->
        in_range =
          fresh_ranges
          |> Enum.any?(fn range ->
            [range_start, range_end] = String.split(range, "-")
            numeric_id = String.to_integer(id)

            numeric_id >= String.to_integer(range_start) and
              numeric_id <= String.to_integer(range_end)
          end)

        if in_range do
          acc + 1
        else
          acc
        end
      end)

    IO.puts("Result: #{fresh_ids}")
  end

  def part2() do
  end
end
