## `cutoff_text`

```ab
pub fun cutoff_text(text: Text, max_width: Int): Text 
```

Truncate text to fit within max_width, adding "..." if truncated.
The max_width includes the "..." suffix.

## `escape_ansi`

```ab
pub fun escape_ansi(text: Text): Text 
```

Convert real ESC characters (0x1b) to literal \x1b string.
This normalizes ANSI escape sequences for internal processing.

## `get_visible_len`

```ab
pub fun get_visible_len(text: Text): Int 
```

Get visible length of ANSI-colored text (excluding escape sequences).

### Parameters
- `text`: Text that may contain ANSI escape sequences.

## `has_ansi_escape`

```ab
pub fun has_ansi_escape(text: Text): Bool 
```

Checks if the text contains ANSI escape sequences.
Returns true if the text contains "\x1b[".

## `is_all_ascii`

```ab
pub fun is_all_ascii(text: Text): Bool 
```

Check if the text is all ASCII characters (code points 32-126).

## `strip_ansi`

```ab
pub fun strip_ansi(text: Text): Text 
```

Remove ANSI escape sequences from text.

## `truncate_ansi`

```ab
pub fun truncate_ansi(text: Text, max_width: Int): Text 
```

Truncate ANSI-colored text to fit within max_width.
Preserves ANSI escape sequences while truncating visible content.
ANSI sequences are expected in literal \x1b format.

## `truncate_text`

```ab
pub fun truncate_text(text: Text, max_width: Int): Text 
```

Truncate text to fit within max_width without adding any suffix.
Simply cuts the text to fit within the specified width.

