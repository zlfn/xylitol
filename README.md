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

## Choose
Choose an option from a list of choices

<img width="2000" height="532" alt="image" src="https://github.com/user-attachments/assets/d66cf28d-d796-4cb8-a6c3-a7f1231f4375" />


```bash
cat songs.txt | ./xylitol.sh choose
cat foods.txt | ./xylitol.sh choose --header "Grocery Shopping"
```


## Input
Prompt for input with a simple command.

<img width="2000" height="228" alt="image" src="https://github.com/user-attachments/assets/f90586dd-c63f-47a5-a602-a0ef47bf39e7" />


```bash
./xylitol.sh input > answer.txt
./xylitol.sh input --prompt="Enter password: " --password > password.txt
```


## Confirm
Prompt the user for confirmation (yes/no).

<img width="2000" height="272" alt="image" src="https://github.com/user-attachments/assets/7cdcd94a-5a2d-47a5-ae75-08f46442b358" />

```bash
./xylitol.sh confirm && rm file.txt || echo "File not removed"
```



### Tested on
```
- macOS 15+ / iTerm2 3.6.2+
  - GNU bash 5.3.3+
  - Bash subshell in zsh(oh-my-zsh) 5.9+
  - Bash subshell in nushell 0.101.0+
```

