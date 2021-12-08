defmodule DayThree do
  def pull_character_from(input, index) do
    input |> Enum.map(fn line -> String.at(line, index) end) |> Enum.map(&String.to_integer/1)
  end

  def translate_to_binary(condition) do
    if condition do
      "1"
    else
      "0"
    end
  end

  def partOne do
    input =
      File.read!("input/day_three.txt")
      |> String.split("\n")
      |> Enum.filter(fn input -> String.trim(input) != "" end)

    %{
      first: firstCounts,
      second: secondCounts,
      third: thirdCounts,
      fourth: fourthCounts,
      fifth: fifthCounts,
      sixth: sixthCounts,
      seventh: seventhCounts,
      eighth: eighthCounts,
      ninth: ninthCounts,
      tenth: tenthCounts,
      eleventh: eleventhCounts,
      twelfth: twelfthCounts
    } =
      Enum.reduce(
        input,
        %{
          first: 0,
          second: 0,
          third: 0,
          fourth: 0,
          fifth: 0,
          sixth: 0,
          seventh: 0,
          eighth: 0,
          ninth: 0,
          tenth: 0,
          eleventh: 0,
          twelfth: 0
        },
        fn x,
           %{
             first: first,
             second: second,
             third: third,
             fourth: fourth,
             fifth: fifth,
             sixth: sixth,
             seventh: seventh,
             eighth: eighth,
             ninth: ninth,
             tenth: tenth,
             eleventh: eleventh,
             twelfth: twelfth
           } ->
          parsed_input = String.graphemes(x) |> Enum.map(&String.to_integer/1)

          %{
            first: first + Enum.at(parsed_input, 0, nil),
            second: second + Enum.at(parsed_input, 1, nil),
            third: third + Enum.at(parsed_input, 2, nil),
            fourth: fourth + Enum.at(parsed_input, 3, nil),
            fifth: fifth + Enum.at(parsed_input, 4, nil),
            sixth: sixth + Enum.at(parsed_input, 5, nil),
            seventh: seventh + Enum.at(parsed_input, 6, nil),
            eighth: eighth + Enum.at(parsed_input, 7, nil),
            ninth: ninth + Enum.at(parsed_input, 8, nil),
            tenth: tenth + Enum.at(parsed_input, 9, nil),
            eleventh: eleventh + Enum.at(parsed_input, 10, nil),
            twelfth: twelfth + Enum.at(parsed_input, 11, nil)
          }
        end
      )

    total_readings = length(input)
    half_of_the_readings = ceil(total_readings / 2)

    calculatedCounts = %{
      firstGamma: firstCounts > half_of_the_readings,
      firstEpsilon: firstCounts <= half_of_the_readings,
      secondGamma: secondCounts > half_of_the_readings,
      secondEpsilon: secondCounts <= half_of_the_readings,
      thirdGamma: thirdCounts > half_of_the_readings,
      thirdEpsilon: thirdCounts <= half_of_the_readings,
      fourthGamma: fourthCounts > half_of_the_readings,
      fourthEpsilon: fourthCounts <= half_of_the_readings,
      fifthGamma: fifthCounts > half_of_the_readings,
      fifthEpsilon: fifthCounts <= half_of_the_readings,
      sixthGamma: sixthCounts > half_of_the_readings,
      sixthEpsilon: sixthCounts <= half_of_the_readings,
      seventhGamma: seventhCounts > half_of_the_readings,
      seventhEpsilon: seventhCounts <= half_of_the_readings,
      eighthGamma: eighthCounts > half_of_the_readings,
      eighthEpsilon: eighthCounts <= half_of_the_readings,
      ninthGamma: ninthCounts > half_of_the_readings,
      ninthEpsilon: ninthCounts <= half_of_the_readings,
      tenthGamma: tenthCounts > half_of_the_readings,
      tenthEpsilon: tenthCounts <= half_of_the_readings,
      eleventhGamma: eleventhCounts > half_of_the_readings,
      eleventhEpsilon: eleventhCounts <= half_of_the_readings,
      twelfthGamma: twelfthCounts > half_of_the_readings,
      twelfthEpsilon: twelfthCounts <= half_of_the_readings
    }

    gamma_graphemes = [
      translate_to_binary(Map.fetch!(calculatedCounts, :firstGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :secondGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :thirdGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :fourthGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :fifthGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :sixthGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :seventhGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :eighthGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :ninthGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :tenthGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :eleventhGamma)),
      translate_to_binary(Map.fetch!(calculatedCounts, :twelfthGamma))
    ]

    gamma_rate =
      gamma_graphemes
      |> List.to_string()
      |> String.to_integer(2)

    epsilon_graphemes = [
      translate_to_binary(Map.fetch!(calculatedCounts, :firstEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :secondEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :thirdEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :fourthEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :fifthEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :sixthEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :seventhEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :eighthEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :ninthEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :tenthEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :eleventhEpsilon)),
      translate_to_binary(Map.fetch!(calculatedCounts, :twelfthEpsilon))
    ]

    epsilon_rate =
      epsilon_graphemes
      |> List.to_string()
      |> String.to_integer(2)

    gamma_rate * epsilon_rate
  end

  def count_numbers_and_determine_condition(input, position, comparator) do
    %{zeros: zeros, ones: ones} =
      Enum.reduce(input, %{zeros: 0, ones: 0}, fn line, acc ->
        %{zeros: zeros, ones: ones} = acc

        if String.at(line, position) == "1" do
          %{acc | ones: ones + 1}
        else
          %{acc | zeros: zeros + 1}
        end
      end)

    if comparator.(zeros, ones) do
      "0"
    else
      "1"
    end
  end

  def determine_least_common_character_at(input, position) do
    count_numbers_and_determine_condition(input, position, &Kernel.<=/2)
  end

  def determine_most_common_character_at(input, position) do
    count_numbers_and_determine_condition(input, position, &Kernel.>/2)
  end

  def filter_digit(input, position, digit) do
    Enum.filter(input, fn line -> String.at(line, position) == digit end)
  end

  def reducer(input, position, operation) do
    if length(input) == 1 do
      List.first(input)
    else
      cond do
        length(input) == 0 ->
          raise "Filtered all things out of input"

        position > String.length(List.first(input)) ->
          raise "We're about to go over the edge"

        true ->
          result = operation.(input, position)
          filtered_input = filter_digit(input, position, result)
          reducer(filtered_input, position + 1, operation)
      end
    end
  end

  def oxygen_generator_rating(input) do
    reducer(input, 0, &determine_most_common_character_at/2)
  end

  def co2_scrubber_rating(input) do
    reducer(input, 0, &determine_least_common_character_at/2)
  end

  def part_two() do
    input =
      File.read!("input/day_three.txt")
      |> String.split("\n")
      |> Enum.filter(fn input -> String.trim(input) != "" end)

    oxygen_rating_bin = oxygen_generator_rating(input)
    co2_rating_bin = co2_scrubber_rating(input)

    String.to_integer(oxygen_rating_bin, 2) * String.to_integer(co2_rating_bin, 2)
  end
end
