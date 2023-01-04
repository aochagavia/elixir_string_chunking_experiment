defmodule RustStringChunker do
  def chunk(s, max_chunk_byte_size), do: StringChunkerHelper.chunk(s, max_chunk_byte_size)
end
