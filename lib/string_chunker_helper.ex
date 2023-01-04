defmodule StringChunkerHelper do
  use Rustler, otp_app: :string_chunking, crate: "string_chunker_helper"

  def chunk(_s, _max_chunk_byte_size), do: :erlang.nif_error(:nif_not_loaded)
  def next_word_length(_s), do: :erlang.nif_error(:nif_not_loaded)
end
