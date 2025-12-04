defmodule AOC.Day02 do
  require Integer

  def parse_input(filename) do
    case File.cwd!() |> Path.join(filename) |> File.read() do
      {:ok, contents} ->
        String.trim(contents) |> String.split(",")

      {:error, :enoent} ->
        []
    end
  end

  def parse_range(range) do
    String.split(range, "-") |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def part1() do
    ranges = parse_input("lib/day02/input.txt")
    parsed_ranges = ranges |> Enum.map(fn range -> parse_range(range) end)

    invalid_ids =
      parsed_ranges
      |> Enum.reduce([], fn range, acc ->
        [st, ed] = range
        range_list = Enum.to_list(st..ed)

        invalid_ids =
          range_list
          |> Enum.filter(fn number ->
            integer_string = Integer.to_string(number)
            string_length = integer_string |> String.length()
            is_even = string_length |> Integer.is_even()

            case is_even do
              true ->
                {part1, part2} = integer_string |> String.split_at(div(string_length, 2))
                part1 == part2

              false ->
                false
            end
          end)

        acc = acc ++ invalid_ids
        acc
      end)

    sum = Enum.sum(invalid_ids)
    IO.inspect("Result: #{sum}")

    sum
  end

  # This is slow try to improve perf later
  def part2() do
    ranges = parse_input("lib/day02/input.txt")
    parsed_ranges = ranges |> Enum.map(fn range -> parse_range(range) end)

    invalid_ids =
      parsed_ranges
      |> Enum.reduce([], fn range, acc ->
        [st, ed] = range
        range_list = Enum.to_list(st..ed)

        invalid_ids =
          range_list
          |> Enum.filter(fn number ->
            integer_string = Integer.to_string(number)
            string_length = integer_string |> String.length()

            match =
              if string_length === 1 do
                false
              else
                Enum.find(Enum.to_list(1..div(string_length, 2)), fn x ->
                  {substr, str} = String.split_at(integer_string, x)
                  replacement = String.replace(str, substr, "")

                  if replacement == "" do
                    true
                  else
                    false
                  end
                end)
              end

            match
          end)

        acc = acc ++ invalid_ids
        acc
      end)

    sum = Enum.sum(invalid_ids)
    IO.inspect("Result: #{sum}")

    sum
  end
end
