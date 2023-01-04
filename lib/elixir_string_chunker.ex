defmodule ElixirStringChunker do
  # The root unicode locale, used to identify word boundaries
  @default_locale "root"

  @doc """
  Split a string into chunks of `max_chunk_byte_size` size, keeping words intact, if possible. Note
  that this function does not discard whitespace, but you can use `Enum.map(&String.trim(&1))` on
  the result if desired.

  Example:
  iex> chunk("Lorem ipsum dolor sit amet.\nConsectetur adipiscing elit.", 10)
  ...> [
  ...>   "Lorem ",
  ...>   "ipsum ",
  ...>   "dolor sit ",
  ...>   "amet.\n",
  ...>   "Consectetu",
  ...>   "r ",
  ...>   "adipiscing",
  ...>   " elit."
  ...> ]

  The word "consectetur" has more than 10 characters, so it is split to make sure a sentence is
  never longer than `max_chunk_byte_size`.
  """
  def chunk("", _) do
    [""]
  end

  def chunk(str, max_chunk_byte_size) do
    do_chunk(str, max_chunk_byte_size)
  end

  defp do_chunk("", _) do
    []
  end

  defp do_chunk(str, max_chunk_byte_size) do
    chunk_length = next_chunk_length(str, max_chunk_byte_size)
    <<chunk::binary-size(chunk_length), rest::binary>> = str
    [chunk | do_chunk(rest, max_chunk_byte_size)]
  end

  defp next_chunk_length(str, max_chunk_byte_size) do
    # 0 indicates that the next word or grapheme does not fit the max chunk size
    with 0 <- next_word_chunk_length(str, max_chunk_byte_size, 0),
         0 <- next_grapheme_chunk_length(str, max_chunk_byte_size, 0) do
      # Fall back to splitting raw bytes
      min(byte_size(str), max_chunk_byte_size)
    end
  end

  defp next_word_chunk_length("", _, current_chunk_byte_size) do
    current_chunk_byte_size
  end

  defp next_word_chunk_length(str, max_chunk_byte_size, current_chunk_byte_size)
       when byte_size(str) + current_chunk_byte_size <= max_chunk_byte_size do
    byte_size(str) + current_chunk_byte_size
  end

  defp next_word_chunk_length(str, max_chunk_byte_size, current_chunk_byte_size) do
    {word, rest} = Unicode.String.Break.next(str, @default_locale, :word, [])
    extended_chunk_byte_size = current_chunk_byte_size + byte_size(word)

    if extended_chunk_byte_size > max_chunk_byte_size do
      current_chunk_byte_size
    else
      next_word_chunk_length(
        rest,
        max_chunk_byte_size,
        extended_chunk_byte_size
      )
    end
  rescue
    # Unicode.String raises an error if the string contains invalid utf8
    # See https://github.com/elixir-unicode/unicode_string/issues/3 for details
    _ -> 0
  end

  defp next_grapheme_chunk_length("", _, current_chunk_byte_size) do
    current_chunk_byte_size
  end

  defp next_grapheme_chunk_length(str, max_chunk_byte_size, current_chunk_byte_size)
       when byte_size(str) + current_chunk_byte_size <= max_chunk_byte_size do
    byte_size(str) + current_chunk_byte_size
  end

  defp next_grapheme_chunk_length(str, max_chunk_byte_size, current_chunk_byte_size) do
    {grapheme, rest} = String.next_grapheme(str)
    grapheme_size = byte_size(grapheme)
    extended_chunk_byte_size = current_chunk_byte_size + grapheme_size

    if extended_chunk_byte_size > max_chunk_byte_size do
      current_chunk_byte_size
    else
      next_grapheme_chunk_length(
        rest,
        max_chunk_byte_size,
        extended_chunk_byte_size
      )
    end
  end
end
