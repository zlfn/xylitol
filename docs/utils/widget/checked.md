## `checked_all`

```ab
pub fun checked_all(): Bool 
```

Tick everything, or clear it all when everything already is.
Refuses while a limit is set, since it could not be honoured.
Returns whether anything changed.

## `checked_count`

```ab
pub fun checked_count(): Int 
```

## `checked_init`

```ab
pub fun checked_init(total: Int, limit: Int): Null 
```

Start over with `total` unticked items. A `limit` below zero means no cap.

## `checked_is`

```ab
pub fun checked_is(index: Int): Bool 
```

## `checked_toggle`

```ab
pub fun checked_toggle(index: Int): Bool 
```

Flip item `index`, unless ticking it would pass the limit.
Returns whether anything changed.

