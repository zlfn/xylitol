## `get_term_size`

```ab
fun get_term_size(): Null 
```

Get the terminal size (columns, rows).
The tty is asked first because it answers without a round trip; the
xterm extension is only needed when the tty does not know its size.
Keeps the default size when it cannot be detected by any means.

## `query_term_size`

```ab
fun query_term_size(): Bool 
```

Ask the terminal for its size with the xterm `\x1b[18t` extension.
Response format: `\x1b[8;rows;colst`.
The read times out, otherwise terminals without the extension would
wait for a reply that never arrives.

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

