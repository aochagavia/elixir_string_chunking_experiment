use bstr::ByteSlice;
use rustler::Binary;

#[rustler::nif]
fn chunk(bin: Binary, max_chunk_byte_size: usize) -> Vec<Binary> {
    let mut s = bin.as_slice();

    let mut chunks = Vec::new();
    let mut offset = 0;

    while s.len() != 0 && s.len() > max_chunk_byte_size {
        let boundary = next_chunk_length(s, max_chunk_byte_size);
        chunks.push(bin.make_subbinary(offset, boundary).unwrap());
        offset += boundary;
        s = &s[boundary..];
    }

    chunks.push(
        bin.make_subbinary(offset, bin.as_slice().len() - offset)
            .unwrap(),
    );

    chunks
}

fn next_chunk_length(s: &[u8], max_chunk_byte_size: usize) -> usize {
    let word_chunk_length = next_word_chunk_length(s, max_chunk_byte_size);
    if word_chunk_length > 0 {
        return word_chunk_length;
    }

    // The next word is too big, fall back to grapheme chunking
    let grapheme_chunk_length = next_grapheme_chunk_length(s, max_chunk_byte_size);
    if grapheme_chunk_length > 0 {
        return grapheme_chunk_length;
    }

    // The next grapheme is too big, fall back to byte chunking
    std::cmp::min(s.len(), max_chunk_byte_size)
}

pub fn next_word_chunk_length(s: &[u8], max_chunk_byte_size: usize) -> usize {
    let mut chunk_length = 0;
    for (start_inclusive, end_exclusive, _word) in s.words_with_break_indices() {
        let word_length = end_exclusive - start_inclusive;
        if chunk_length + word_length > max_chunk_byte_size {
            break;
        }

        chunk_length += word_length;
    }

    chunk_length
}

fn next_grapheme_chunk_length(s: &[u8], max_chunk_byte_size: usize) -> usize {
    let mut chunk_length = 0;
    for (start_inclusive, end_exclusive, _grapheme) in s.grapheme_indices() {
        let grapheme_length = end_exclusive - start_inclusive;
        if chunk_length + grapheme_length > max_chunk_byte_size {
            break;
        }

        chunk_length += grapheme_length;
    }

    chunk_length
}
