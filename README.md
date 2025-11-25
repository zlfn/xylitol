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

## Choose
Choose an option from a list of choices

![화면 기록 2025-11-25 오후 1 10 13](https://github.com/user-attachments/assets/38a404bf-f141-4537-9ffd-79a0ff2cb0b1)

```bash
cat songs.txt | ./xylitol.sh
cat foods.txt | ./xylitol.sh --header "Grocery Shopping"
```


## Input
Prompt for input with a simple command.

![화면 기록 2025-11-25 오전 5 01 35](https://github.com/user-attachments/assets/7a5f9e8a-ea30-4b93-b9f9-459cb3ae6736)


```bash
./xylitol.sh input > answer.txt
./xylitol.sh input --prompt="Enter password: " --password > password.txt
```


### Tested on
```
- macOS 15+ / iTerm2 3.6.2+
  - GNU bash 5.3.3+
  - Bash subshell in zsh(oh-my-zsh) 5.9+
  - Bash subshell in nushell 0.101.0+
```
