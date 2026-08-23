## `get_cwd`

```ab
pub fun get_cwd(): Text 
```

Get current working directory

## `get_directory_entries`

```ab
pub fun get_directory_entries(path: Text): [Text] 
```

Read the entries of `path` as a flat array holding a name, a type and a
link target for each one, so `entries[i * ENTRY_STRIDE]` is the name of
entry `i`. The type is the first character of the long listing, so "d"
for a directory and "l" for a symbolic link, and the target is empty for
anything that is not a symbolic link.

Names come from the `ls` builtin, which sorts under `LC_ALL=C`. The long
listings below must use the same collation, otherwise the three sources
fall out of alignment for non-ASCII file names.

## `get_parent_dir`

```ab
pub fun get_parent_dir(path: Text): Text 
```

Get parent directory

## `normalize_path`

```ab
pub fun normalize_path(path: Text): Text 
```

Normalize a path (resolve .. and .)

## `path_join`

```ab
pub fun path_join(base: Text, child: Text): Text 
```

Join two path components

