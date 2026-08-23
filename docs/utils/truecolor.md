## `background_accent`

```ab
pub fun background_accent(message: Text): Text 
```

## `background_primary`

```ab
pub fun background_primary(message: Text): Text 
```

## `background_rgb`

```ab
pub fun background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int = 0): Text 
```

Returns a text wrapped in 24-bit true color background codes.
If truecolor is not enabled, falls back to the specified fallback color code.

### Parameters
- `message`: The text to colorize.
- `r`: Red component (0-255).
- `g`: Green component (0-255).
- `b`: Blue component (0-255).
- `fallback`: Fallback ANSI foreground color code (40-47, 100-107). Converted to background automatically.

## `background_secondary`

```ab
pub fun background_secondary(message: Text): Text 
```

## `colored_accent`

```ab
pub fun colored_accent(message: Text): Text 
```

## `colored_primary`

```ab
pub fun colored_primary(message: Text): Text 
```

## `colored_rgb`

```ab
pub fun colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int = 0): Text 
```

Returns a text wrapped in 24-bit true color codes.
If truecolor is not enabled, falls back to the specified fallback color code.

### Parameters
- `message`: The text to colorize.
- `r`: Red component (0-255).
- `g`: Green component (0-255).
- `b`: Blue component (0-255).
- `fallback`: Fallback ANSI color code (default: 0 = default color).

## `colored_secondary`

```ab
pub fun colored_secondary(message: Text): Text 
```

## `get_supports_truecolor`

```ab
fun get_supports_truecolor(): Bool 
```

Checks whether 24-bit true color was asked for, which it is not by default.

The fallback codes name entries in the terminal's own palette, so they
follow whatever theme it is dressed in. A fixed RGB triple does not, and
picking one for somebody else's terminal is not ours to do. Set
`XYLITOL_TRUECOLOR` to "Yes" to get the exact colors instead.

## `get_xylitol_colors`

```ab
pub fun get_xylitol_colors(): Null 
```

## `inner_get_xylitol_colors`

```ab
fun inner_get_xylitol_colors(): Null? 
```

