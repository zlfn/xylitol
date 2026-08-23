## `colored`

```ab
pub fun colored(message: Text, color: Int): Text 
```

## `cutoff_text`

```ab
pub fun cutoff_text(text: Text, max_width: Int): Text 
```

Truncate text to fit within max_width, adding "..." if truncated.
The max_width includes the "..." suffix.

## `eprintf`

```ab
pub fun eprintf(format: Text, args: [Text] = [""]): Null 
```

## `eprintf_colored`

```ab
pub fun eprintf_colored(message: Text, color: Int): Null 
```

## `escape_ansi`

```ab
pub fun escape_ansi(text: Text): Text 
```

Convert real ESC characters (0x1b) to literal \x1b string.
This normalizes ANSI escape sequences for internal processing.

## `get_char`

```ab
pub fun get_char(): Text 
```

Reads a single character from terminal.

## `get_key`

```ab
pub fun get_key(): Text 
```

Reads a key from terminal, including special keys (arrows, backspace, etc.)

## `get_visible_len`

```ab
pub fun get_visible_len(text: Text): Int 
```

Get visible length of ANSI-colored text (excluding escape sequences).

### Parameters
- `text`: Text that may contain ANSI escape sequences.

## `go_down`

```ab
pub fun go_down(cnt: Int): Null 
```

move the cursor down `cnt` lines.

## `go_up`

```ab
pub fun go_up(cnt: Int): Null 
```

move the cursor up `cnt` lines.

## `go_up_or_down`

```ab
pub fun go_up_or_down(cnt: Int): Null 
```

## `has_ansi_escape`

```ab
pub fun has_ansi_escape(text: Text): Bool 
```

Checks if the text contains ANSI escape sequences.
Returns true if the text contains "\x1b[".

## `hide_cursor`

```ab
pub fun hide_cursor(): Null 
```

## `is_all_ascii`

```ab
pub fun is_all_ascii(text: Text): Bool 
```

Check if the text is all ASCII characters (code points 32-126).

## `new_line`

```ab
pub fun new_line(cnt: Int): Null 
```

## `print_blank`

```ab
pub fun print_blank(cnt: Int): Null 
```

Prints blank spaces.
### Parameters
- `cnt`: Number of spaces to print.

## `print_help_line`

```ab
fun print_help_line(pending: Text, line: Text, note_at: Int): Null 
```

Print one wrapped help line, dimming it from `note_at` onwards.

## `print_wrapped`

```ab
pub fun print_wrapped(pieces: [Text]): Null 
```

Print `pieces` as one paragraph wrapped to the terminal width.

Pieces are joined with single spaces and a break can only happen between
them, so a piece that already carries colour stays intact.

## `printf_colored`

```ab
pub fun printf_colored(message: Text, color: Int): Null 
```

## `remove`

```ab
pub fun remove(cnt: Int): Null 
```

remove `cnt` characters to the left of the cursor, clearing to end of line.
Does nothing when `cnt` is not positive.

## `remove_current_line`

```ab
pub fun remove_current_line(): Null 
```

remove the current line from the terminal.

## `remove_line`

```ab
pub fun remove_line(cnt: Int): Null 
```

remove `cnt` lines from the terminal (starting from current line, going up).
Removes no line when `cnt` is not positive.

## `render_help_entries`

```ab
pub fun render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int = 0): Null 
```

Render aligned help entries.

The name column is sized to the longest name. A description and its note
flow as one paragraph that wraps under that column, with the note dimmed
wherever it lands.
`min_name_width` keeps neighbouring sections on the same column when their
longest names differ.

## `render_tooltip`

```ab
pub fun render_tooltip(items: [Text], total_len: Int, term_width: Int): Null 
```

Render a tooltip line with key-action pairs.
Format: "key action • key action • ..."
Truncates if exceeds term_width.

### Parameters
- `items`: Flat array of key, action pairs. e.g. ["↑↓", "select", "enter", "confirm"]
- `total_len`: Pre-calculated total visible length of the tooltip.
- `term_width`: Terminal width to truncate output.

## `show_cursor`

```ab
pub fun show_cursor(): Null 
```

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

