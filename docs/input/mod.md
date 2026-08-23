## `xyl_input`

```ab
pub fun xyl_input(prompt: Text, placeholder: Text, header: Text = "", password: Bool = false,): Text 
```

Prompts the user single-line input with a placeholder.

### Parameters
- `prompt`: The prompt message to display to the user.
- `placeholder`: The placeholder text to show in the input field. Shown
only on Bash 4.0 and later, which can put the keypress that dismisses it
back into the line being edited.
- `header`: An optional header message to display above the prompt. (ANSI supported)
- `password`: A boolean indicating whether the input should be masked.

