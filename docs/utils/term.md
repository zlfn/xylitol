## `get_term_size`

```ab
fun get_term_size(): Null 
```

Get the terminal size (columns, rows).
The tty is asked first because it answers without a round trip; the
xterm extension is only needed when the tty does not know its size.
Keeps the default size when it cannot be detected by any means.

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

## `hide_cursor`

```ab
pub fun hide_cursor(): Null 
```

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

## `print_wrapped`

```ab
pub fun print_wrapped(pieces: [Text]): Null 
```

Print `pieces` as one paragraph wrapped to the terminal width.

Pieces are joined with single spaces and a break can only happen between
them, so a piece that already carries colour stays intact.

## `query_term_size`

```ab
fun query_term_size(): Bool 
```

Ask the terminal for its size with the xterm `\x1b[18t` extension.
Response format: `\x1b[8;rows;colst`.
The read times out, otherwise terminals without the extension would
wait for a reply that never arrives.

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

## `show_cursor`

```ab
pub fun show_cursor(): Null 
```

## `store_term_size`

```ab
fun store_term_size(size: Text): Bool 
```

Store the size, given as a "rows columns" text of two positive integers.
Both values are validated by the caller, so parsing cannot fail here.

## `stty_count`

```ab
fun stty_count(): Int 
```

Read the reference count, treating anything that is not a number as zero.
The check happens in the shell so that `parse_int` cannot fail.

## `stty_lock`

```ab
pub fun stty_lock(): Null 
```

Lock the terminal (disable echo). Uses reference counting via environment variable.

## `stty_term_size`

```ab
fun stty_term_size(): Bool 
```

Read the terminal size from the tty itself with a `TIOCGWINSZ` ioctl.

## `stty_unlock`

```ab
pub fun stty_unlock(): Null 
```

Unlock the terminal (enable echo). Uses reference counting via environment variable.

## `term_height`

```ab
pub fun term_height(): Int 
```

Get the terminal height (rows).

## `term_size`

```ab
pub fun term_size(): [Int] 
```

## `term_width`

```ab
pub fun term_width(): Int 
```

Get the terminal width (columns).

