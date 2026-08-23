## `redraw_row`

```ab
pub fun redraw_row(display_count: Int, index: Int, line: Text): Null 
```

Rewrite one row of the block a widget reserved, then park the cursor back
where widgets keep it: column one of the line below the block.

`index` counts from the top of the block, which is `display_count` rows tall.

