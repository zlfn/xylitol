## `render_confirm_options`

```ab
fun render_confirm_options(selected: Bool, term_width: Num): Null 
```

Renders the Yes/No selection with background colors
Uses smaller buttons when terminal width is below 30 characters


## `xyl_confirm`

```ab
pub fun xyl_confirm(header: Text = "\e[1mAre you sure?\e[0m", default_yes: Bool = true,): Bool 
```

Prompts the user with a Yes/No confirmation dialog.

### Parameters
- `header`: The header message to display above the options. (ANSI supported)
- `default_yes`: Whether Yes is selected by default. Default is true.

### Returns
- `true` if the user selected Yes, `false` if No.


