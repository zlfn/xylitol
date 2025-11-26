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
pub fun background_rgb(message: Text, r: Num, g: Num, b: Num, fallback: Num = 0): Text 
```

Returns a text wrapped in 24-bit true color background codes.
If truecolor is not supported, falls back to the specified fallback color code.

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
pub fun colored_rgb(message: Text, r: Num, g: Num, b: Num, fallback: Num = 0): Text 
```

Returns a text wrapped in 24-bit true color codes.
If truecolor is not supported, falls back to the specified fallback color code.

### Parameters
- `message`: The text to colorize.
- `r`: Red component (0-255).
- `g`: Green component (0-255).
- `b`: Blue component (0-255).
- `truecolor`: Whether the terminal supports truecolor.
- `fallback`: Fallback ANSI color code (default: 0 = default color).


## `colored_secondary`

```ab
pub fun colored_secondary(message: Text): Text 
```
## `get_supports_truecolor`

```ab
fun get_supports_truecolor(): Bool 
```

Checks if the terminal supports 24-bit true color.
Returns true if COLORTERM is "truecolor" or "24bit".


## `get_xylitol_colors`

```ab
pub fun get_xylitol_colors(): Null 
```
## `inner_get_xylitol_colors`

```ab
fun inner_get_xylitol_colors(): Null ? 
```
