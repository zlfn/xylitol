#!/usr/bin/env bash

# The exact colors below only apply when truecolor is asked for; without this
# xylitol uses the 95/93 fallbacks, which follow the terminal's own theme.
export XYLITOL_TRUECOLOR="Yes"
export XYLITOL_PRIMARY_COLOR="246;177;206;95" # Pink
export XYLITOL_SECONDARY_COLOR="239;224;127;93" # Yellow

# ccsakura.txt is from https://aahub.org
function print_sakura() {
    printf "\e[38;2;246;177;206m" >&2
    (cat inputs/ccsakura.txt)
    printf "\e[0m" >&2
}

lang=$(../xylitol.sh choose --header="🌸 Select Language" "English" "日本語" "한국어")

if [ "$lang" = "English" ]; then
    printf "Key which hides the power of the dark,\n" >&2
    printf "Reveal your true from before me.\n" >&2
    printf "I, Sakura Kinomoto, command you under our contact.\n" >&2
    printf "\e[38;2;246;177;206;1m✨ Release!!! ✨\e[0m\n" >&2

    while true; do
        card=$(cat inputs/clow_cards_en.txt | ../xylitol.sh choose --header="🌸 Choose Clow Card")

        prompt="Are you sure with this card?: "
        card=${card//$'\n'/、}
        (../xylitol.sh confirm --header="$prompt$card")
        if [ $? -eq 0 ]; then
            break
        fi
    done

    print_sakura
    printf "\e[38;2;246;177;206;1m" >&2
    printf "      $card,"
    printf "\e[38;2;239;224;127m" >&2
    printf " return to the form that you were meant to be in!!!\n"
    printf "\e[0m" >&2
elif [ "$lang" = "日本語" ]; then
    printf "闇の力を秘めし鍵よ、\n真の姿を我の前に示せ。\n契約のもとさくらが命じる。\n" >&2
    printf "\e[38;2;246;177;206;1m✨ レリーズ!!! ✨\e[0m\n" >&2

    while true; do
        card=$(cat inputs/clow_cards_jp.txt | ../xylitol.sh choose --header="🌸 クロウカードを選んでね")

        prompt="このカードでいい?: "
        card=${card//$'\n'/、}
        (../xylitol.sh confirm --header="$prompt$card")
        if [ $? -eq 0 ]; then
            break
        fi
    done

    print_sakura
    printf "\e[38;2;239;224;127;1m" >&2
    printf "                  汝のあるべき姿に戻れ!"
    printf "\e[38;2;246;177;206;1m" >&2
    printf " $card!\n"
    printf "\e[0m" >&2
else
    printf "어둠의 힘을 지니고 있는 열쇠여,\n진정한 모습 내 앞에 나타나라.\n너와의 계약에 따라 체리가 명한다.\n" >&2
    printf "\e[38;2;246;177;206;1m✨ 봉인해제!!! ✨\e[0m\n" >&2

    while true; do
        card=$(cat inputs/clow_cards_ko.txt | ../xylitol.sh choose --header="🌸 크로우 카드를 선택하세요")

        prompt="이 카드로 할까요?: "
        card=${card//$'\n'/、}
        (../xylitol.sh confirm --header="$prompt$card")
        if [ $? -eq 0 ]; then
            break
        fi
    done

    print_sakura
    printf "\e[38;2;239;224;127;1m" >&2
    printf "           너의 본모습으로 돌아갈 것을 명한다!"
    printf "\e[38;2;246;177;206;1m" >&2
    printf " $card!\n"
    printf "\e[0m" >&2
fi

printf "\e[38;2;246;177;206m" >&2
echo "------------------------------------------------------------------------"
printf "\e[0m" >&2
