## `xyl_choose`

```ab
pub fun xyl_choose(options: [Text], cursor: Text = "> ", header: Text = "\x1b[1mChoose:\x1b[0m", page_size: Int = 10,): Text 
```

Prompts the user to choose a single option from a list.

### Parameters
- `options`: The list of options to choose from.
- `cursor`: The cursor text to indicate the selected option.
- `header`: An optional header message to display above the options. (ANSI supported)
- `page_size`: The number of options to display per page.

## `xyl_multi_choose`

```ab
pub fun xyl_multi_choose(options: [Text], cursor: Text = "> ", header: Text = "Choose:", limit: Int = - 1, page_size: Int = 10,): [Text] 
```

Prompts the user to choose multiple options from a list.

### Parameters
- `options`: The list of options to choose from.
- `cursor`: The cursor text to indicate the selected option.
- `header`: An optional header message to display above the options. (ANSI supported)
- `limit`: The maximum number of options the user can select. Use -1 for no limit.
- `page_size`: The number of options to display per page.

