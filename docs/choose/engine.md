## `chooser_begin`

```ab
pub fun chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int): Null 
```

Start a chooser over `total` items. Locks the terminal and reserves the
lines the widget draws on, which `chooser_end` releases.

## `chooser_end`

```ab
pub fun chooser_end(): Null 
```

Erase the widget and unlock the terminal.

## `chooser_is_checked`

```ab
pub fun chooser_is_checked(index: Int): Bool 
```

Whether item `index` is checked. Only meaningful in multi mode.

## `chooser_page_count`

```ab
pub fun chooser_page_count(): Int 
```

## `chooser_page_start`

```ab
pub fun chooser_page_start(): Int 
```

## `chooser_selected`

```ab
pub fun chooser_selected(): Int 
```

Index of the highlighted item within the whole list.

## `chooser_set_page`

```ab
pub fun chooser_set_page(page: [Text]): Null 
```

Hand the engine the labels of the current page and draw them.
`page` must hold exactly `chooser_page_count()` labels, for the items
starting at `chooser_page_start()`.

## `chooser_step`

```ab
pub fun chooser_step(): Int 
```

Read one key and update the selection.

## `option_width`

```ab
fun option_width(): Int 
```

Move the highlight from `prev_selected` to `_selected`, redrawing only
those two lines.
Width left for an option once the cursor and any check mark are placed.

## `redraw_current_line`

```ab
fun redraw_current_line(): Null 
```

Redraw the highlighted row after its check mark changed. Multi mode only.

## `redraw_selection`

```ab
fun redraw_selection(prev_selected: Int): Null 
```

Move the highlight from `prev_selected` to `_selected`, redrawing only
those two rows.

## `render_multi_page`

```ab
fun render_multi_page(): Null 
```

## `render_page`

```ab
fun render_page(): Null 
```

## `render_page_indicator`

```ab
fun render_page_indicator(): Null 
```

## `render_single_page`

```ab
fun render_single_page(): Null 
```

## `render_tooltip_line`

```ab
fun render_tooltip_line(): Null 
```

## `selected_line`

```ab
fun selected_line(index: Int): Text 
```

The row for `index` on the current page, as it looks highlighted.

## `unselected_line`

```ab
fun unselected_line(index: Int): Text 
```

The row for `index` on the current page, as it looks unhighlighted.

