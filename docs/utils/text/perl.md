## `perl_available`

```ab
fun perl_available(): Bool 
```

## `perl_get_cjk_width`

```ab
pub fun perl_get_cjk_width(text: Text): Int? 
```

Get the CJK width of the given text using Perl's Unicode properties.

## `perl_substr_cjk`

```ab
pub fun perl_substr_cjk(text: Text, start: Int, end: Int): Text? 
```

Substring text by display width range [start, end), considering CJK character widths.
Returns characters whose display positions fall within [start, end).

## `perl_truncate_cjk`

```ab
pub fun perl_truncate_cjk(text: Text, max_width: Int): Text? 
```

Truncate text to fit within a given display width, considering CJK character widths.
Returns the truncated string that fits within max_width display columns.

