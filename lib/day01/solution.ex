defmodule AOC.Day01 do
  def parse_input(filename) do
    case File.cwd!() |> Path.join(filename) |> File.read() do
      {:ok, contents} ->
        String.split(contents, "\n")

      {:error, :enoent} ->
        []
    end
  end

  def parse_instruction(instruction) do
    {direction, rotation} = String.split_at(instruction, 1)
    {rotation, _remainder} = Integer.parse(rotation)

    {direction, rotation}
  end

  def part1() do
    dial_start = 50
    min_dial = 0
    max_dial = 99

    split_parts = parse_input("lib/day01/input.txt")

    results_map =
      Enum.reduce(split_parts, %{stopped_at_zero: 0, dial_position: dial_start}, fn list_item,
                                                                                    acc ->
        {direction, rotation} = parse_instruction(list_item)
        dial_position = Map.get(acc, :dial_position)

        remainder_rotation = rem(rotation, max_dial + 1)

        dial_position =
          case direction do
            # Left is minus
            "L" ->
              dial_position - remainder_rotation

            # Right is plus
            "R" ->
              dial_position + remainder_rotation
          end

        dial_position =
          cond do
            dial_position > max_dial ->
              dial_position - max_dial - 1

            dial_position < min_dial ->
              dial_position + max_dial + 1

            true ->
              dial_position
          end

        acc =
          if dial_position == 0 do
            %{
              acc
              | dial_position: dial_position,
                stopped_at_zero: Map.get(acc, :stopped_at_zero) + 1
            }
          else
            %{
              acc
              | dial_position: dial_position
            }
          end

        acc
      end)

    stopped_at_zero = Map.get(results_map, :stopped_at_zero, 0)

    IO.puts("Results: #{stopped_at_zero}")
    stopped_at_zero
  end

  def part2() do
    dial_start = 50
    min_dial = 0
    max_dial = 99

    split_parts = parse_input("lib/day01/input.txt")

    {passed_zero, _} =
      split_parts
      |> Enum.reduce({0, dial_start}, fn list_item, {passed_zero, dial_position} ->
        {direction, rotation} = parse_instruction(list_item)

        remainder_rotation = rem(rotation, max_dial + 1)
        extra_full_rotations = div(rotation, max_dial + 1)

        new_dial_position =
          case direction do
            # Left is minus
            "L" ->
              dial_position - remainder_rotation

            # Right is plus
            "R" ->
              dial_position + remainder_rotation
          end

        extra_rotations =
          if new_dial_position > max_dial || new_dial_position < min_dial ||
               new_dial_position == 0 do
            1
          else
            0
          end

        new_dial_position =
          cond do
            new_dial_position > max_dial ->
              new_dial_position - max_dial - 1

            new_dial_position < min_dial ->
              new_dial_position + max_dial + 1

            true ->
              new_dial_position
          end

        File.write!(
          File.cwd!() |> Path.join("lib/day01/debug_log.txt"),
          """
          Directions #{list_item} current rotation #{dial_position}
          New dial pos #{new_dial_position}
          Full rotations #{extra_full_rotations}, extra rotations #{extra_rotations}
          Rotation total before #{passed_zero}
          Rotation total after #{passed_zero + extra_full_rotations + extra_rotations}
          """,
          [:append]
        )

        {
          passed_zero + extra_full_rotations + extra_rotations,
          new_dial_position
        }
      end)

    IO.puts("Results: #{passed_zero}")
    passed_zero
  end
end
