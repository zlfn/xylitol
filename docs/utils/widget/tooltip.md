## `render_tooltip`

```ab
pub fun render_tooltip(items: [Text], total_len: Int, term_width: Int): Null 
```

Render a tooltip line with key-action pairs.
Format: "key action • key action • ..."
Truncates if exceeds term_width.

### Parameters
- `items`: Flat array of key, action pairs. e.g. ["↑↓", "select", "enter", "confirm"]
- `total_len`: Pre-calculated total visible length of the tooltip.
- `term_width`: Terminal width to truncate output.

