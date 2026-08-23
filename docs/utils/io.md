## `colored`

```ab
pub fun colored(message: Text, color: Int): Text 
```

## `eprintf`

```ab
pub fun eprintf(format: Text, args: [Text] = [""]): Null 
```

## `eprintf_colored`

```ab
pub fun eprintf_colored(message: Text, color: Int): Null 
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
IFS is cleared so that space and tab do not arrive as an empty string.
Keys with no name of their own come back as the characters that were typed.

## `printf_colored`

```ab
pub fun printf_colored(message: Text, color: Int): Null 
```

