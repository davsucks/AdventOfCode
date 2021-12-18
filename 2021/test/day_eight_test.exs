defmodule DayEightTest do
  use ExUnit.Case
  doctest DayEight

  test "decodes one" do
    # cf
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    assert DayEight.decode_digit("ca", key) === "1"
  end

  test "decodes two" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # acdeg
    assert DayEight.decode_digit("gdafe", key) === "2"
  end

  test "decodes three" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # acdfg
    assert DayEight.decode_digit("fadce", key) === "3"
  end

  test "decodes four" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # bcdf
    assert DayEight.decode_digit("cdab", key) === "4"
  end

  test "decodes five" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # abdfg
    assert DayEight.decode_digit("fbdce", key) === "5"
  end

  test "decodes six" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # abdefg
    assert DayEight.decode_digit("fbgdce", key) === "6"
  end

  test "decodes seven" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # acf
    assert DayEight.decode_digit("afc", key) === "7"
  end

  test "decodes eight" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # abcdefg
    assert DayEight.decode_digit("edcgfab", key) === "8"
  end

  test "decodes nine" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # abcdfg
    assert DayEight.decode_digit("fbadce", key) === "9"
  end

  test "decodes zero" do
    key = %Display{a: "f", b: "b", c: "a", d: "d", e: "g", f: "c", g: "e"}
    # abcefg
    assert DayEight.decode_digit("fbagce", key) === "0"
  end

  test "decodes the key" do
    wires = [
      "acedgfb",
      "cdfbe",
      "gcdfa",
      "fbcad",
      "dab",
      "cefabd",
      "cdfgeb",
      "eafb",
      "cagedb",
      "ab"
    ]

    key = DayEight.decode_digits(wires)

    assert key.a === "d"
    assert key.b === "e"
    assert key.c === "a"
    assert key.d === "f"
    assert key.e === "g"
    assert key.f === "b"
    assert key.g === "c"
  end
end
