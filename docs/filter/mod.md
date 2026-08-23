## `move_selection`

```ab
fun move_selection(step: Int): Bool 
```

Move the highlight by `step`, scrolling the window when it runs off an end.
Returns whether the whole window has to be drawn again.

## `option_index`

```ab
fun option_index(row: Int): Int 
```

Position in `_options` of the match drawn on `row`.

## `option_width`

```ab
fun option_width(): Int 
```

## `refresh_matches`

```ab
fun refresh_matches(): Null 
```

Positions of the options holding the query, ignoring case, ranked so that an
exact hit comes before a prefix and a prefix before a hit further in. Ties
keep the order the options were given in. One shell pass.

## `render_count`

```ab
fun render_count(): Null 
```

## `render_query`

```ab
fun render_query(): Null 
```

## `render_rows`

```ab
fun render_rows(): Null 
```

Draw every row of the window, from the line the cursor rests on.

## `render_tooltip_line`

```ab
fun render_tooltip_line(): Null 
```

## `row_line`

```ab
fun row_line(row: Int, highlighted: Bool): Text 
```

## `visible_count`

```ab
fun visible_count(): Int 
```

## `xyl_filter`

```ab
pub fun xyl_filter(options: [Text], prompt: Text = "/ ", placeholder: Text = "Filter...", header: Text = "", cursor: Text = "> ", multi: Bool = false, limit: Int = - 1, height: Int = 10,): [Text] 
```

Prompts the user to pick from a list narrowed by typing.

### Parameters
- `options`: The list of options to pick from.
- `prompt`: The text shown in front of the query.
- `placeholder`: The text shown while the query is empty.
- `header`: An optional header message to display above the query. (ANSI supported)
- `cursor`: The cursor text to indicate the highlighted option.
- `multi`: Whether more than one option can be picked.
- `limit`: The maximum number of options that can be picked. Use -1 for no limit.
- `height`: The number of options to display at once.

