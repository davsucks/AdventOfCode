defmodule DaySeven do
  def parseDirectory([], [], acc), do: acc

  def parseDirectory([], [{dirName, dir}], acc) do
    parseDirectory([], [], Map.merge(acc, %{dirName => dir}))
  end

  def parseDirectory([], [{dirName, dir} | [{parentName, parent} | restDirs]], acc) do
    parent = Map.merge(parent, %{dirName => dir})
    parseDirectory([], [{parentName, parent} | restDirs], acc)
  end

  def parseDirectory([curInstr | restInstr], [{dirName, dir} | restDirs] = dirs, acc) do
    dirNameRegex = ~r/dir [\w+]/
    cdCommand = ~r/cd (?<dirName>\w+)/
    fileMatcher = ~r/(?<fileSize>\d+) (?<filename>.+)/

    cond do
      curInstr == "$ cd .." ->
        [{parentName, parent} | restDirs] = restDirs
        parent = Map.merge(parent, %{dirName => dir})
        parseDirectory(restInstr, [{parentName, parent} | restDirs], acc)

      String.match?(curInstr, dirNameRegex) || curInstr == "$ ls" ->
        parseDirectory(restInstr, dirs, acc)

      String.match?(curInstr, cdCommand) ->
        %{"dirName" => dirName} = Regex.named_captures(cdCommand, curInstr)
        parseDirectory(restInstr, [{dirName, %{}} | dirs], acc)

      String.match?(curInstr, fileMatcher) ->
        %{"fileSize" => fileSize, "filename" => filename} =
          Regex.named_captures(fileMatcher, curInstr)

        parseDirectory(
          restInstr,
          [{dirName, Map.merge(dir, %{filename => String.to_integer(fileSize)})} | restDirs],
          acc
        )
    end
  end


  def sizeDirectories(files, dirNames, lookup, acc) do
  end

  def sizeDirectory(files) do
    files
    |> Enum.reduce(0, fn {filename, filesize}, acc ->
      cond do
        is_map(filesize) ->
          acc + sizeDirectory(Enum.to_list(filesize))

        is_number(filesize) ->
          acc + filesize
      end
    end)
  end

  def partOne do
    input =
      Utils.parseInput("day_seven_test.txt")
      # drop cd /
      |> Enum.drop(1)
      |> Enum.map(&String.trim/1)
      |> parseDirectory([{"/", %{}}], %{})
      |> Enum.to_list()
      |> sizeDirectories("/", %{})
  end

  def partTwo do
  end
end
