## `count_checked`

```ab
fun count_checked(checked: [Bool]): Num 
```
## `get_page_options`

```ab
fun get_page_options(options: [Text], page: Num, page_size: Num): [Text] 
```
## `get_page_start`

```ab
fun get_page_start(page: Num, page_size: Num): Num 
```
## `render_choose_page`

```ab
fun render_choose_page(options: [Text], page: Num, sel: Num, cursor: Text, page_size: Num, display_count: Num): Null 
```
## `render_multi_choose_page`

```ab
fun render_multi_choose_page(options: [Text], checked: [Bool], page: Num, sel: Num, cursor: Text, page_size: Num, display_count: Num): Null 
```
## `render_page_indicator`

```ab
fun render_page_indicator(page: Num, total_pages: Num): Null 
```
## `xyl_choose`

```ab
pub fun xyl_choose(options: [Text], cursor: Text = "> ", header: Text = "\e[96mChoose:\e[0m", page_size: Num = 10,): Text 
```

Prompts the user to choose a single option from a list.

### Parameters
- `options`: The list of options to choose from.
- `cursor`: The cursor text to indicate the selected option.
- `header`: An optional header message to display above the options. (ANSI supported)
- `page_size`: The number of options to display per page.


## `xyl_multi_choose`

```ab
pub fun xyl_multi_choose(options: [Text], cursor: Text = "> ", header: Text = "\e[96mChoose:\e[0m", limit: Num = - 1, page_size: Num = 10,): [Text] 
```

Prompts the user to choose multiple options from a list.

/ ### Parameters
- `options`: The list of options to choose from.
- `cursor`: The cursor text to indicate the selected option.
- `header`: An optional header message to display above the options. (ANSI supported)
- `limit`: The maximum number of options the user can select. Use -1 for no limit.
- `page_size`: The number of options to display per page.


