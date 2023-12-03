#! /usr/bin/env bash

day=$1

touch input/day_${day}_test.txt
touch input/day_${day}.txt
touch lib/day_${day}.ex


cat <<EOT >> lib/day_${day}.ex
defmodule Day${day^} do
  def part_one do
  end

  def part_two do
  end
end
EOT
