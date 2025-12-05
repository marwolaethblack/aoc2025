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
    input = parse_input("lib/day05/input.txt")

    divider_index = Enum.find_index(input, fn x -> x == "" end)

    fresh_ranges = input |> Enum.slice(0..(divider_index - 1))

    # Sort ranges by range_start
    sorted_ranges =
      fresh_ranges
      |> Enum.sort_by(
        fn range ->
          [range_start, _] = String.split(range, "-")
          String.to_integer(range_start)
        end,
        :asc
      )
      |> Vector.new()

    {_, fresh_ids} =
      sorted_ranges
      |> Enum.reduce({0, 0}, fn range, {index, sum} ->
        [range_start, range_end] = String.split(range, "-")
        next_index = index + 1

        # if we are not at the end of the vector compare to next range
        overlap =
          if next_index < Vector.length(sorted_ranges) do
            next_range = sorted_ranges[index + 1]
            [next_range_start, next_range_end] = String.split(next_range, "-")

            # Ranges overlap if the first range end is after or equal next range start
            if String.to_integer(range_end) >= String.to_integer(next_range_start) do
              max_range_start =
                [String.to_integer(range_start), String.to_integer(next_range_start)]
                |> Enum.max()

              min_range_end =
                [String.to_integer(range_end), String.to_integer(next_range_end)] |> Enum.min()

              min_range_end - max_range_start + 1
            else
              0
            end
          else
            0
          end

        id_count = String.to_integer(range_end) - String.to_integer(range_start) + 1 - overlap

        {index + 1, sum + id_count}
      end)

    IO.puts("Result #{fresh_ids}")
  end
end
