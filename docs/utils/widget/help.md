## `print_help_line`

```ab
fun print_help_line(pending: Text, line: Text, note_at: Int): Null 
```

Print one wrapped help line, dimming it from `note_at` onwards.

## `render_help_entries`

```ab
pub fun render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int = 0): Null 
```

Render aligned help entries.

The name column is sized to the longest name. A description and its note
flow as one paragraph that wraps under that column, with the note dimmed
wherever it lands.
`min_name_width` keeps neighbouring sections on the same column when their
longest names differ.

