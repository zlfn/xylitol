# Contribution Guidelines
Thank you for considering contributing to this project!

## Terminal Requirements
Bash is a highly limited language, and controlling all possible terminal cases is difficult.
Therefore, XYLITOL only supports a reasonable terminal environments, and all execution environments 
are assumed to meet at least the following conditions:
- ANSI Escape Sequences are supported, including color output and cursor movement.
- XTerm Control Sequences are supported.
- POSIX standard utilities (such as `sed`, `bc`, etc.) are available.
- The terminal width is at least 20 columns.
- The terminal height is at least 10 lines.
- The terminal will not be resized during execution.

XYLITOL aims to ensure compatibility with terminals as wide as possible, but issues that arise in
terminals that do not meet the above requirements will not be accepted as vaild.

However, pull requests that address problems on such terminals are welcome, as long as they 
do not cause significant performance regressions.

## Quality of Operation Guarantee
XYLITOL is expected to work well across all environments and inputs, 
but it cannot be perfect in every possible senario.  

The following environments are expected to work *perfectly*. This means XYLITOL should theoretically
behave correctly for all input cases. Contributions that break functionality in these environments may be
rejected or withheld until fixed.
- Linux / macOS / WSL with all standard POSIX utilities installed.
- ASCII input excluding control characters

The following environments are expected to work *adequetely*. This means XYLITOL should work
correctly in most situations, but may behave incorrectly in some extreme cases.
Any contribution that causes issues in these environments will still be accepted.
However, contributions that fix issues in these environments are encouraged.
- Windows / FreeBSD
- ANSI string input (only in cases explicitly documented as supported)
- CJK text input

The following environments are *not guaranteed* to work correctly.
Behavior in these environments may be inconsistent, and issues specific to them may not be addressed.
- Terminals that do not meet the requirements listed in the "Terminal Requirements" section.
- Input containing control characters (e.g. newlines, tabs, backspaces, etc.)
- Extremely large input (e.g. more than 10,000 options)
