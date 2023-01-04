defmodule RustStringChunkerTest do
  use ExUnit.Case, async: true

  describe "chunk/2" do
    test "returns a list with an empty string if the input string is empty" do
      assert [""] == RustStringChunker.chunk("", 20)
    end

    test "returns a single chunk if the string fits in the maximum chunk size" do
      str = "Lorem ipsum"
      assert [str] == RustStringChunker.chunk(str, 20)
    end

    test "returns multiple chunks if the string is longer than the maximum chunk size" do
      str = "Lorem ipsum dolor sit amet. Consectetur adipiscing elit."

      assert ["Lorem ipsum dolor ", "sit amet. ", "Consectetur ", "adipiscing elit."] ==
               RustStringChunker.chunk(str, 20)

      assert ["Lorem ipsum dolor sit amet. ", "Consectetur adipiscing elit."] ==
               RustStringChunker.chunk(str, 30)

      assert ["Lorem ipsum dolor sit amet. Consectetur ", "adipiscing elit."] ==
               RustStringChunker.chunk(str, 40)
    end

    test "splits words if words are longer than the maximum chunk size" do
      str = "Lorem ipsum dolor sit amet. Consectetur adipiscing elit."

      assert [
               "Lorem ",
               "ipsum ",
               "dolor sit ",
               "amet. ",
               "Consectetu",
               "r ",
               "adipiscing",
               " elit."
             ] ==
               RustStringChunker.chunk(str, 10)
    end

    test "does not trim whitespace at the beginning and the end of the chunk" do
      str = "Lorem ipsum dolor sit amet.\nConsectetur adipiscing elit."

      assert [
               "Lorem ",
               "ipsum ",
               "dolor sit ",
               "amet.\n",
               "Consectetu",
               "r ",
               "adipiscing",
               " elit."
             ] ==
               RustStringChunker.chunk(str, 10)

      assert ["Lorem ipsum dolor ", "sit amet.\n", "Consectetur ", "adipiscing elit."] ==
               RustStringChunker.chunk(str, 20)

      assert ["Lorem ipsum dolor sit amet.\n", "Consectetur adipiscing elit."] ==
               RustStringChunker.chunk(str, 30)

      assert ["Lorem ipsum dolor sit amet.\nConsectetur ", "adipiscing elit."] ==
               RustStringChunker.chunk(str, 40)

      assert ["Lorem ipsum dolor sit amet.\nConsectetur adipiscing elit."] ==
               RustStringChunker.chunk(str, 100)
    end

    test "keeps multi-byte graphemes" do
      str = "Lorem😀 ipsum"
      assert ["Lorem", "😀 ", "ipsum"] == RustStringChunker.chunk(str, 8)

      str = "復活節彩蛋"
      assert ["復活節", "彩蛋"] == RustStringChunker.chunk(str, 10)
    end

    test "splits graphemes longer than the maximum chunk size" do
      str = "Lorem😀 ipsum"

      assert ["Lor", "em", <<240, 159, 152>>, <<128>> <> " ", "ips", "um"] ==
               RustStringChunker.chunk(str, 3)
    end

    test "splits according to words even in the presence of invalid utf8" do
      assert ["Lore" <> <<240>> <> " ", "mipsum"] ==
               RustStringChunker.chunk("Lore" <> <<240>> <> " mipsum", 8)
    end
  end
end
