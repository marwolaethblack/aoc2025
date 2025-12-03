defmodule AOC.Day03 do
  require Integer

  def parse_input(filename) do
    case File.read(filename) do
      {:ok, contents} ->
        String.trim(contents) |> String.split("\n")

      {:error, :enoent} ->
        []
    end
  end

  def parse_numbers(string_number_list) do
    string_number_list |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def number_to_digit_list(number, list \\ []) do
    if number === 0 do
      list
    else
      new_list = [rem(number, 10)] ++ list
      new_number = div(number, 10)
      number_to_digit_list(new_number, new_list)
    end
  end

  def part1() do
    input = parse_input("input.txt") |> parse_numbers

    max_joltages =
      Enum.reduce(input, 0, fn battery_array, acc ->
        digit_list = number_to_digit_list(battery_array)
        last_index = length(digit_list) - 1

        # Find first max number that is not last, (we delete the last number in the list for this purpose)
        first_max = List.delete_at(digit_list, last_index) |> Enum.max()
        found_index = Enum.find_index(digit_list, fn x -> x === first_max end)

        # Slice the list to contain all the numbers after the found first_max
        sliced = Enum.slice(digit_list, (found_index + 1)..last_index)

        # Find the second max, it can be at the end
        second_max = Enum.max(sliced)

        total = first_max * 10 + second_max

        acc = acc + total
        acc
      end)

    IO.puts("Result: #{max_joltages}")
    max_joltages
  end

  def part2() do
  end
end

AOC.Day03.part1()
