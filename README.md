# XYLITOL
Add **cleanliness** and **freshness** to your shell scripts.

XYLITOL plays a role similar to [gum](https://github.com/charmbracelet/gum), but since it's written in [Amber](https://amber-lang.com/),  
it doesn't depend on external binaries and remains fully portable.

## Execution

Just download and execute `xylitol.sh` script. (Bash 3.2+ is required.)  
ANSI support is required for the terminal.

or use [Amber](https://amber-lang.com/) to compile Bash script from amber code.

```
bash <(curl -sL "https://github.com/amber-lang/amber/releases/download/0.6.0-alpha/install.sh")
amber build --target bash-3.2 src/main.ab xylitol.sh
```

## Commands
* [`choose`](#choose): Choose an option from a list of choices
* [`input`](#input): Prompt the user for input.
* [`confirm`](#confirm): Prompt the user for confirmation (yes/no).
* [`file`](#file): Pick a file from system.

## Choose
Choose an option from a list of choices

<img width="1200" height="500" alt="choose" src="https://github.com/user-attachments/assets/0e257fcd-975a-49c7-80dd-bca68f245baa" />

```bash
cat songs.txt | ./xylitol.sh choose
cat foods.txt | ./xylitol.sh choose --header="Grocery Shopping"
```


## Input
Prompt for input with a simple command.

<img width="1200" height="280" alt="input" src="https://github.com/user-attachments/assets/014c06b4-de1d-4740-9760-36ad3f647ba7" />

```bash
./xylitol.sh input > answer.txt
./xylitol.sh input --prompt="Enter password: " --password > password.txt
```


## Confirm
Prompt the user for confirmation (yes/no).

<img width="1200" height="320" alt="confirm" src="https://github.com/user-attachments/assets/ea726595-612c-4098-a5a7-e6f3c2cedfd7" />

```bash
./xylitol.sh confirm && rm file.txt || echo "File not removed"
```

## File
Prompt the user to select a file from the file tree.

<img width="1200" height="560" alt="file" src="https://github.com/user-attachments/assets/f8a930b8-7dcf-4051-98e0-cdd9518e5f61" />

```bash
./xylitol.sh file ~/.config
```

### Tested on
Every push drives the built script through a pseudo terminal on:
```
- Ubuntu / docker bash 3.2, 4.0, 4.3, 4.4, 5.0, 5.2
- macOS / /bin/bash (3.2)
```
