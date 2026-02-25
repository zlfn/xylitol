# XYLITOL
Add **cleanliness** and **freshness** to your shell scripts.

XYLITOL plays a role similar to [gum](https://github.com/charmbracelet/gum), but since it's written in [Amber](https://amber-lang.com/),  
it doesn't depend on external binaries and remains fully portable.

## Execution

Just download and execute `xylitol.sh` script. (Bash 4.0+ is required.)  
ANSI support is required for the terminal.

or use [Amber](https://amber-lang.com/) to compile Bash script from amber code.

```
bash <(curl -s "https://raw.githubusercontent.com/amber-lang/amber/master/setup/install.sh")
amber build src/main.ab xylitol.sh
```

## Commands
* [`choose`](#choose): Choose an option from a list of choices
* [`input`](#input): Prompt the user for input.
* [`confirm`](#confirm): Prompt the user for confirmation (yes/no).
* [`file`](#file): Pick a file from system.

## Choose
Choose an option from a list of choices

<img width="1200" height="381" alt="image" src="https://github.com/user-attachments/assets/dca320f6-6bdd-4fa1-abe2-b97a6f7a4cde" />


```bash
cat songs.txt | ./xylitol.sh choose
cat foods.txt | ./xylitol.sh choose --header="Grocery Shopping"
```


## Input
Prompt for input with a simple command.

<img width="1200" height="151" alt="image" src="https://github.com/user-attachments/assets/8ffcd022-a55c-4614-aa6a-5b2783c7ea71" />



```bash
./xylitol.sh input > answer.txt
./xylitol.sh input --prompt="Enter password: " --password > password.txt
```


## Confirm
Prompt the user for confirmation (yes/no).

<img width="1200" height="184" alt="image" src="https://github.com/user-attachments/assets/2eb07a60-eae6-44e6-aa36-a28c4e33c720" />


```bash
./xylitol.sh confirm && rm file.txt || echo "File not removed"
```

## File
Prompt the user to select a file from the file tree.

<img width="1200" height="449" alt="image" src="https://github.com/user-attachments/assets/94d44b95-7be6-48e6-9ddf-6588bb787b91" />

```bash
./xylitol.sh file ~/.config
```

### Tested on
```
- macOS 15+ / iTerm2 3.6.2+ / GNU bash 5.3.3+
- macOS 15+ / iTerm2 3.6.2+ / Bash subshell in nushell 0.101.0+
- Arch Linux ARM / Wezterm 20240203+ / GNU bash 5.3.3+
```
