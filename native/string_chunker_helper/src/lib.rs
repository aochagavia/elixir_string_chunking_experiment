mod hybrid_chunker;
mod rust_chunker;

rustler::init!("Elixir.StringChunkerHelper", [
  hybrid_chunker::next_word_length,
  rust_chunker::chunk
]);
