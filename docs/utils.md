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
## `get_key`

```ab
pub fun get_key(): Text 
```
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
## `hide_cursor`

```ab
pub fun hide_cursor(): Null 
```
## `print_blank`

```ab
pub fun print_blank(cnt: Num): Null 
```
## `printf_colored`

```ab
pub fun printf_colored(message: Text, color: Num): Null 
```
## `remove`

```ab
pub fun remove(cnt: Num): Null 
```

remove `cnt` characters from the terminal.


## `remove_line`

```ab
pub fun remove_line(cnt: Num): Null 
```

remove `cnt` lines from the terminal.


## `show_cursor`

```ab
pub fun show_cursor(): Null 
```
