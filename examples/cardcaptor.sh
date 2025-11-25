#!/usr/bin/env bash

printf "\e[96mOh, Key of Clow … power of magic, power of light, surrender the wand, let the force ignite! \e[0m" >&2
printf "\e[96;1mRelease!!! ✨\e[0m\n" >&2

card=$(cat inputs/clow_cards.txt | source ../xylitol.sh choose --header="\e[96;1m🌸 Choose Your Clow Cards\e[0m" --no-limit)

if [ -z "$card" ]; then
    printf "\e[91;1mNo cards selected, release canceled!\e[0m\n" >&2
    exit 1
fi

prompt="\e[92;1mAre you sure with this cards?:\e[0m "
card=${card//$'\n'/, }
(source ../xylitol.sh confirm --header="$prompt$card")
if [ $? -ne 0 ]; then
    printf "\e[91;1mRelease canceled!\e[0m\n" >&2
    exit 1
fi

printf "\e[96;1m$card,\e[96m release and dispe!!!\e[0m" >&2
