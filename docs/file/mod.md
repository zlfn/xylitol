## `format_entry_display`

```ab
fun format_entry_display(name: Text, file_type: Text, target: Text): Text 
```

Format a single entry for display
Directories are colored with accent color and have trailing /

## `xyl_file`

```ab
pub fun xyl_file(start_path: Text = "", cursor: Text = "> ", show_hidden: Bool = false, page_size: Int = 10,): Text 
```

File browser that lets user navigate and select a file.

### Parameters
- `start_path`: Starting directory path (default: current directory).
- `cursor`: The cursor text to indicate the selected option.
- `show_hidden`: Whether to show hidden files (starting with .).
- `page_size`: The number of entries to display per page.

