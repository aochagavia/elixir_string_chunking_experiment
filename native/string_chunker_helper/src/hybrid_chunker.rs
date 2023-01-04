use bstr::ByteSlice;

const MAX_WORD_SIZE: usize = 500;

#[rustler::nif]
fn next_word_length(s: rustler::Binary) -> usize {
  // Only consider words up to MAX_WORD_SIZE, to ensure the function never takes more than a
  // millisecond before returning (which is required for NIFs)
  let len = std::cmp::min(s.len(), MAX_WORD_SIZE + 1);
  let next_word_length = next_word_length_internal(&s[..len]);

  if next_word_length <= 500 {
    return next_word_length;
  }

  // The next_word_length was 501, and it might be a legitimate word, but we can't know for sure
  // because the algorithm did not scan the rest of the string. Returning 0 indicates that no word
  // was found, so the caller can fall back to a different chunking method
  0
}

fn next_word_length_internal(s: &[u8]) -> usize {
  s.words_with_break_indices()
      .next()
      .map(|(start_inclusive, end_exclusive, _)| end_exclusive - start_inclusive)
      .unwrap_or(0)
}
