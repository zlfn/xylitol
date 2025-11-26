## `colored`

```ab
pub fun colored(message: Text, color: Num): Text 
```
## `eprintf`

```ab
pub fun eprintf(format: Text, args: [Text] = [""]): Null 
```
## `eprintf_colored`

```ab
pub fun eprintf_colored(message: Text, color: Num): Null 
```
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


## `go_down`

```ab
pub fun go_down(cnt: Num): Null 
```

move the cursor down `cnt` lines.


## `go_up`

```ab
pub fun go_up(cnt: Num): Null 
```

move the cursor up `cnt` lines.


## `go_up_or_down`

```ab
pub fun go_up_or_down(cnt: Num): Null 
```
## `has_ansi_escape`

```ab
pub fun has_ansi_escape(text: Text): Bool 
```

Checks if the text contains ANSI escape sequences.
Returns true if the text contains "\e[" or "\x1b[".


## `hide_cursor`

```ab
pub fun hide_cursor(): Null 
```
## `new_line`

```ab
pub fun new_line(cnt: Num): Null 
```
## `print_blank`

```ab
pub fun print_blank(cnt: Num): Null 
```

Prints blank spaces.
### Parameters
- `cnt`: Number of spaces to print.


## `printf_colored`

```ab
pub fun printf_colored(message: Text, color: Num): Null 
```
## `remove`

```ab
pub fun remove(cnt: Num): Null 
```

remove `cnt` characters from the terminal.


## `remove_current_line`

```ab
pub fun remove_current_line(): Null 
```

remove the current line from the terminal.


## `remove_line`

```ab
pub fun remove_line(cnt: Num): Null 
```

remove `cnt` lines from the terminal (starting from current line, going up).


## `render_tooltip`

```ab
pub fun render_tooltip(items: [Text], total_len: Num, term_width: Num): Null 
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
## `truncate_text`

```ab
pub fun truncate_text(text: Text, max_width: Num): Text 
```

Truncate text to fit within max_width, adding "..." if truncated.
The max_width includes the "..." suffix.


