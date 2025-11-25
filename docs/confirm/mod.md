## `render_confirm_options`

```ab
fun render_confirm_options(selected: Bool): Null 
```

Renders the Yes/No selection with background colors


## `xyl_confirm`

```ab
pub fun xyl_confirm(header: Text = "\e[96;1mAre you sure?\e[0m", default_yes: Bool = true,): Bool 
```

Prompts the user with a Yes/No confirmation dialog.

### Parameters
- `header`: The header message to display above the options. (ANSI supported)
- `default_yes`: Whether Yes is selected by default. Default is true.

### Returns
- `true` if the user selected Yes, `false` if No.


