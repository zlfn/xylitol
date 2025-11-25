#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-11-25 22:16:34
replace__0_v0() {
    local source=$1
    local search=$2
    local replace=$3
    __AF_replace0_v0="${source//${search}/${replace}}";
    return 0
}
split__3_v0() {
    local text=$1
    local delimiter=$2
    __AMBER_ARRAY_0=();
    local result=("${__AMBER_ARRAY_0[@]}")
     IFS="${delimiter}" read -rd '' -a result < <(printf %s "$text") ;
    __AS=$?
    __AF_split3_v0=("${result[@]}");
    return 0
}
join__6_v0() {
    local list=("${!1}")
    local delimiter=$2
    __AMBER_VAL_1=$( IFS="${delimiter}" ; echo "${list[*]}" );
    __AS=$?;
    __AF_join6_v0="${__AMBER_VAL_1}";
    return 0
}
parse_number__12_v0() {
    local text=$1
     [ -n "${text}" ] && [ "${text}" -eq "${text}" ] 2>/dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_parse_number12_v0=''
return $__AS
fi
    __AF_parse_number12_v0="${text}";
    return 0
}
match_regex__17_v0() {
    local source=$1
    local search=$2
    local extended=$3
            replace__0_v0 "${search}" "/" "\/";
        __AF_replace0_v0__130_18="${__AF_replace0_v0}";
        search="${__AF_replace0_v0__130_18}"
        local output=""
        if [ ${extended} != 0 ]; then
            # GNU sed versions 4.0 through 4.2 support extended regex syntax,
            # but only via the "-r" option; use that if the version information
            # contains "GNU sed".
             re='\bCopyright\b.+\bFree Software Foundation\b'; [[ $(sed --version 2>/dev/null) =~ $re ]] ;
            __AS=$?
            local flag=$(if [ $(echo $__AS '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "-r"; else echo "-E"; fi)
            __AMBER_VAL_2=$( echo "${source}" | sed "${flag}" -ne "/${search}/p" );
            __AS=$?;
            output="${__AMBER_VAL_2}"
else
            __AMBER_VAL_3=$( echo "${source}" | sed -ne "/${search}/p" );
            __AS=$?;
            output="${__AMBER_VAL_3}"
fi
        if [ $([ "_${output}" == "_" ]; echo $?) != 0 ]; then
            __AF_match_regex17_v0=1;
            return 0
fi
    __AF_match_regex17_v0=0;
    return 0
}

printf__99_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" ;
    __AS=$?
}
echo_colored__105_v0() {
    local message=$1
    local color=$2
    __AMBER_ARRAY_4=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m
" __AMBER_ARRAY_4[@];
    __AF_printf99_v0__142_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__142_5" > /dev/null 2>&1
}
printf_colored__114_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_5=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_5[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__115_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__116_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_6=("${message}");
    eprintf__115_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_6[@];
    __AF_eprintf115_v0__34_5="$__AF_eprintf115_v0";
    echo "$__AF_eprintf115_v0__34_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
print_help__180_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    printf_colored__114_v0 "Xylitol" 92;
    __AF_printf_colored114_v0__7_5="$__AF_printf_colored114_v0";
    echo "$__AF_printf_colored114_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_7=("");
    printf__99_v0 " - A tool for " __AMBER_ARRAY_7[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    printf_colored__114_v0 "fresh" 92;
    __AF_printf_colored114_v0__9_5="$__AF_printf_colored114_v0";
    echo "$__AF_printf_colored114_v0__9_5" > /dev/null 2>&1
    __AMBER_ARRAY_8=("");
    printf__99_v0 " shell scripts." __AMBER_ARRAY_8[@];
    __AF_printf99_v0__10_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__10_5" > /dev/null 2>&1
    echo ""
    echo ""
    echo_colored__105_v0 "Flags: " 96;
    __AF_echo_colored105_v0__13_5="$__AF_echo_colored105_v0";
    echo "$__AF_echo_colored105_v0__13_5" > /dev/null 2>&1
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    echo ""
    echo_colored__105_v0 "Commands: " 96;
    __AF_echo_colored105_v0__17_5="$__AF_echo_colored105_v0";
    echo "$__AF_echo_colored105_v0__17_5" > /dev/null 2>&1
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo ""
    __AMBER_ARRAY_9=("");
    printf__99_v0 "Run " __AMBER_ARRAY_9[@];
    __AF_printf99_v0__21_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__21_5" > /dev/null 2>&1
    printf_colored__114_v0 "./xylitol.sh <command> --help" 93;
    __AF_printf_colored114_v0__22_5="$__AF_printf_colored114_v0";
    echo "$__AF_printf_colored114_v0__22_5" > /dev/null 2>&1
    __AMBER_ARRAY_10=("");
    printf__99_v0 " for more information on a command." __AMBER_ARRAY_10[@];
    __AF_printf99_v0__23_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__23_5" > /dev/null 2>&1
    echo ""
}
get_char__209_v0() {
    __AMBER_VAL_11=$( read -n 1 key < /dev/tty; printf "%s" "$key");
    __AS=$?;
    local char="${__AMBER_VAL_11}"
    __AF_get_char209_v0="${char}";
    return 0
}
printf_colored__211_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_12=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_12[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__212_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__213_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_13=("${message}");
    eprintf__212_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_13[@];
    __AF_eprintf212_v0__34_5="$__AF_eprintf212_v0";
    echo "$__AF_eprintf212_v0__34_5" > /dev/null 2>&1
}
remove__215_v0() {
    local cnt=$1
    __AMBER_ARRAY_14=();
    local remove_text=("${__AMBER_ARRAY_14[@]}")
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_15=("\b \b");
        remove_text+=("${__AMBER_ARRAY_15[@]}")
done
    join__6_v0 remove_text[@] "";
    __AF_join6_v0__48_13="${__AF_join6_v0}";
    __AMBER_ARRAY_16=("");
    eprintf__212_v0 "${__AF_join6_v0__48_13}" __AMBER_ARRAY_16[@];
    __AF_eprintf212_v0__48_5="$__AF_eprintf212_v0";
    echo "$__AF_eprintf212_v0__48_5" > /dev/null 2>&1
}
remove_line__216_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_17=("");
        eprintf__212_v0 "\e[A\e[K" __AMBER_ARRAY_17[@];
        __AF_eprintf212_v0__54_9="$__AF_eprintf212_v0";
        echo "$__AF_eprintf212_v0__54_9" > /dev/null 2>&1
done
}
go_down__218_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_18=("");
        eprintf__212_v0 "
" __AMBER_ARRAY_18[@];
        __AF_eprintf212_v0__69_9="$__AF_eprintf212_v0";
        echo "$__AF_eprintf212_v0__69_9" > /dev/null 2>&1
done
}
go_up__219_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_19=("");
        eprintf__212_v0 "\e[1A" __AMBER_ARRAY_19[@];
        __AF_eprintf212_v0__76_9="$__AF_eprintf212_v0";
        echo "$__AF_eprintf212_v0__76_9" > /dev/null 2>&1
done
}
# move the cursor up or down `cnt` lines.
xyl_input__237_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_20=("");
        eprintf__212_v0 "${header}""
" __AMBER_ARRAY_20[@];
        __AF_eprintf212_v0__18_9="$__AF_eprintf212_v0";
        echo "$__AF_eprintf212_v0__18_9" > /dev/null 2>&1
fi
    go_down__218_v0 2;
    __AF_go_down218_v0__21_5="$__AF_go_down218_v0";
    echo "$__AF_go_down218_v0__21_5" > /dev/null 2>&1
    eprintf_colored__213_v0 "enter" 0;
    __AF_eprintf_colored213_v0__22_5="$__AF_eprintf_colored213_v0";
    echo "$__AF_eprintf_colored213_v0__22_5" > /dev/null 2>&1
    eprintf_colored__213_v0 " submit" 2;
    __AF_eprintf_colored213_v0__23_5="$__AF_eprintf_colored213_v0";
    echo "$__AF_eprintf_colored213_v0__23_5" > /dev/null 2>&1
    go_up__219_v0 2;
    __AF_go_up219_v0__24_5="$__AF_go_up219_v0";
    echo "$__AF_go_up219_v0__24_5" > /dev/null 2>&1
    __AMBER_ARRAY_21=("");
    eprintf__212_v0 "\e[99999D" __AMBER_ARRAY_21[@];
    __AF_eprintf212_v0__25_5="$__AF_eprintf212_v0";
    echo "$__AF_eprintf212_v0__25_5" > /dev/null 2>&1
    __AMBER_ARRAY_22=("");
    eprintf__212_v0 "${prompt}" __AMBER_ARRAY_22[@];
    __AF_eprintf212_v0__27_5="$__AF_eprintf212_v0";
    echo "$__AF_eprintf212_v0__27_5" > /dev/null 2>&1
    eprintf_colored__213_v0 "${placeholder}" 90;
    __AF_eprintf_colored213_v0__28_5="$__AF_eprintf_colored213_v0";
    echo "$__AF_eprintf_colored213_v0__28_5" > /dev/null 2>&1
     stty -echo < /dev/tty ;
    __AS=$?
    get_char__209_v0 ;
    __AF_get_char209_v0__31_16="${__AF_get_char209_v0}";
    local char="${__AF_get_char209_v0__31_16}"
    __AMBER_LEN="${prompt}";
    remove__215_v0 "${#__AMBER_LEN}";
    __AF_remove215_v0__32_5="$__AF_remove215_v0";
    echo "$__AF_remove215_v0__32_5" > /dev/null 2>&1
    __AMBER_LEN="${placeholder}";
    remove__215_v0 $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove215_v0__33_5="$__AF_remove215_v0";
    echo "$__AF_remove215_v0__33_5" > /dev/null 2>&1
    local text=""
    if [ $(echo  '!' ${password} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_23=$( read -e -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_23}"
else
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_24=$( read -es -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_24}"
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        go_down__218_v0 2;
        __AF_go_down218_v0__45_9="$__AF_go_down218_v0";
        echo "$__AF_go_down218_v0__45_9" > /dev/null 2>&1
        remove_line__216_v0 4;
        __AF_remove_line216_v0__46_9="$__AF_remove_line216_v0";
        echo "$__AF_remove_line216_v0__46_9" > /dev/null 2>&1
else
        go_down__218_v0 2;
        __AF_go_down218_v0__48_9="$__AF_go_down218_v0";
        echo "$__AF_go_down218_v0__48_9" > /dev/null 2>&1
        remove_line__216_v0 3;
        __AF_remove_line216_v0__49_9="$__AF_remove_line216_v0";
        echo "$__AF_remove_line216_v0__49_9" > /dev/null 2>&1
fi
    __AF_xyl_input237_v0="${text}";
    return 0
}
print_input_help__278_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    printf_colored__211_v0 "input" 92;
    __AF_printf_colored211_v0__7_5="$__AF_printf_colored211_v0";
    echo "$__AF_printf_colored211_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_25=("");
    printf__99_v0 " - Prompt for some input from the user." __AMBER_ARRAY_25[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    echo_colored__105_v0 "Flags: " 96;
    __AF_echo_colored105_v0__11_5="$__AF_echo_colored105_v0";
    echo "$__AF_echo_colored105_v0__11_5" > /dev/null 2>&1
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    echo ""
}
execute_input__308_v0() {
    local parameters=("${!1}")
    local prompt="> "
    local placeholder="Type here..."
    local header=""
    local password=0
    for param in "${parameters[@]}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__12_12="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__12_42="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__12_12" '||' "$__AF_match_regex17_v0__12_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_input_help__278_v0 ;
            __AF_print_input_help278_v0__13_13="$__AF_print_input_help278_v0";
            echo "$__AF_print_input_help278_v0__13_13" > /dev/null 2>&1
            exit 0
fi
        match_regex__17_v0 "${param}" "^--prompt=.*\$" 0;
        __AF_match_regex17_v0__16_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__16_12" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__17_26=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__17_26[@]}")
            prompt="${result[1]}"
fi
        match_regex__17_v0 "${param}" "^--placeholder=.*\$" 0;
        __AF_match_regex17_v0__20_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__20_12" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__21_26=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__21_26[@]}")
            placeholder="${result[1]}"
fi
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__24_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__24_12" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__25_26=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__25_26[@]}")
            header="${result[1]}"
fi
        match_regex__17_v0 "${param}" "^--password\$" 0;
        __AF_match_regex17_v0__28_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__28_12" != 0 ]; then
            password=1
fi
done
    xyl_input__237_v0 "${prompt}" "${placeholder}" "${header}" ${password};
    __AF_xyl_input237_v0__33_12="${__AF_xyl_input237_v0}";
    __AF_execute_input308_v0="${__AF_xyl_input237_v0__33_12}";
    return 0
}
math_floor__337_v0() {
    local number=$1
    __AMBER_VAL_26=$( echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' );
    __AS=$?;
    __AF_math_floor337_v0="${__AMBER_VAL_26}";
    return 0
}
get_key__348_v0() {
    __AMBER_VAL_27=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_27}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key348_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key348_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key348_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key348_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key348_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key348_v0="INPUT";
        return 0
else
        __AF_get_key348_v0="${var}";
        return 0
fi
}
printf_colored__349_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_28=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_28[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__350_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__351_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_29=("${message}");
    eprintf__350_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_29[@];
    __AF_eprintf350_v0__34_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__34_5" > /dev/null 2>&1
}
remove_line__354_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_30=("");
        eprintf__350_v0 "\e[A\e[K" __AMBER_ARRAY_30[@];
        __AF_eprintf350_v0__54_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__54_9" > /dev/null 2>&1
done
}
print_blank__355_v0() {
    local cnt=$1
    # Prints blank spaces.
    for _ in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_31=("");
        eprintf__350_v0 " " __AMBER_ARRAY_31[@];
        __AF_eprintf350_v0__61_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__61_9" > /dev/null 2>&1
done
}
go_down__356_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_32=("");
        eprintf__350_v0 "
" __AMBER_ARRAY_32[@];
        __AF_eprintf350_v0__69_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__69_9" > /dev/null 2>&1
done
}
go_up__357_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_33=("");
        eprintf__350_v0 "\e[1A" __AMBER_ARRAY_33[@];
        __AF_eprintf350_v0__76_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__76_9" > /dev/null 2>&1
done
}
# move the cursor up or down `cnt` lines.
go_up_or_down__358_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__356_v0 ${cnt};
        __AF_go_down356_v0__83_9="$__AF_go_down356_v0";
        echo "$__AF_go_down356_v0__83_9" > /dev/null 2>&1
else
        go_up__357_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up357_v0__85_9="$__AF_go_up357_v0";
        echo "$__AF_go_up357_v0__85_9" > /dev/null 2>&1
fi
}
hide_cursor__359_v0() {
    __AMBER_ARRAY_34=("");
    eprintf__350_v0 "\e[?25l" __AMBER_ARRAY_34[@];
    __AF_eprintf350_v0__90_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__90_5" > /dev/null 2>&1
}
show_cursor__360_v0() {
    __AMBER_ARRAY_35=("");
    eprintf__350_v0 "\e[?25h" __AMBER_ARRAY_35[@];
    __AF_eprintf350_v0__94_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__94_5" > /dev/null 2>&1
}
get_page_options__375_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    local start=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local end=$(echo ${start} '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${end} '>' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        end="${#options[@]}"
fi
    __AMBER_ARRAY_36=();
    local result=("${__AMBER_ARRAY_36[@]}")
    for i in $(seq ${start} $(echo ${end} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_37=("${options[${i}]}");
        result+=("${__AMBER_ARRAY_37[@]}")
done
    __AF_get_page_options375_v0=("${result[@]}");
    return 0
}
get_page_start__376_v0() {
    local page=$1
    local page_size=$2
    __AF_get_page_start376_v0=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
render_choose_page__377_v0() {
    local options=("${!1}")
    local page=$2
    local sel=$3
    local cursor=$4
    local page_size=$5
    local display_count=$6
    get_page_options__375_v0 options[@] ${page} ${page_size};
    __AF_get_page_options375_v0__23_24=("${__AF_get_page_options375_v0[@]}");
    local page_options=("${__AF_get_page_options375_v0__23_24[@]}")
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__351_v0 "${cursor}""${page_options[${i}]}""
" 32;
            __AF_eprintf_colored351_v0__26_13="$__AF_eprintf_colored351_v0";
            echo "$__AF_eprintf_colored351_v0__26_13" > /dev/null 2>&1
else
            __AMBER_LEN="${cursor}";
            print_blank__355_v0 "${#__AMBER_LEN}";
            __AF_print_blank355_v0__28_13="$__AF_print_blank355_v0";
            echo "$__AF_print_blank355_v0__28_13" > /dev/null 2>&1
            __AMBER_ARRAY_38=("");
            eprintf__350_v0 "${page_options[${i}]}""
" __AMBER_ARRAY_38[@];
            __AF_eprintf350_v0__29_13="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__29_13" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug gaurd
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_39=("");
            eprintf__350_v0 "\e[K
" __AMBER_ARRAY_39[@];
            __AF_eprintf350_v0__35_13="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__35_13" > /dev/null 2>&1
done
fi
}
render_multi_choose_page__378_v0() {
    local options=("${!1}")
    local checked=("${!2}")
    local page=$3
    local sel=$4
    local cursor=$5
    local page_size=$6
    local display_count=$7
    get_page_options__375_v0 options[@] ${page} ${page_size};
    __AF_get_page_options375_v0__41_24=("${__AF_get_page_options375_v0[@]}");
    local page_options=("${__AF_get_page_options375_v0__41_24[@]}")
    get_page_start__376_v0 ${page} ${page_size};
    __AF_get_page_start376_v0__42_17="$__AF_get_page_start376_v0";
    local start="$__AF_get_page_start376_v0__42_17"
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local global_idx=$(echo ${start} '+' ${i} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        local check_mark=$(if [ "${checked[${global_idx}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__351_v0 "${cursor}""${check_mark}""${page_options[${i}]}""
" 32;
            __AF_eprintf_colored351_v0__47_23="$__AF_eprintf_colored351_v0";
            echo "$__AF_eprintf_colored351_v0__47_23" > /dev/null 2>&1
elif [ "${checked[${global_idx}]}" != 0 ]; then
                            __AMBER_LEN="${cursor}";
                print_blank__355_v0 "${#__AMBER_LEN}";
                __AF_print_blank355_v0__49_17="$__AF_print_blank355_v0";
                echo "$__AF_print_blank355_v0__49_17" > /dev/null 2>&1
                eprintf_colored__351_v0 "${check_mark}""${page_options[${i}]}""
" 32;
                __AF_eprintf_colored351_v0__50_17="$__AF_eprintf_colored351_v0";
                echo "$__AF_eprintf_colored351_v0__50_17" > /dev/null 2>&1
else
                            __AMBER_LEN="${cursor}";
                print_blank__355_v0 "${#__AMBER_LEN}";
                __AF_print_blank355_v0__53_17="$__AF_print_blank355_v0";
                echo "$__AF_print_blank355_v0__53_17" > /dev/null 2>&1
                __AMBER_ARRAY_40=("");
                eprintf__350_v0 "${check_mark}""${page_options[${i}]}""
" __AMBER_ARRAY_40[@];
                __AF_eprintf350_v0__54_17="$__AF_eprintf350_v0";
                echo "$__AF_eprintf350_v0__54_17" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug guard
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_41=("");
            eprintf__350_v0 "\e[K
" __AMBER_ARRAY_41[@];
            __AF_eprintf350_v0__61_13="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__61_13" > /dev/null 2>&1
done
fi
}
render_page_indicator__379_v0() {
    local page=$1
    local total_pages=$2
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_42=("");
        eprintf__350_v0 "\e[9999D\e[K" __AMBER_ARRAY_42[@];
        __AF_eprintf350_v0__68_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__68_9" > /dev/null 2>&1
        eprintf_colored__351_v0 "Page $(echo ${page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored351_v0__69_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__69_9" > /dev/null 2>&1
        __AMBER_ARRAY_43=("");
        eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_43[@];
        __AF_eprintf350_v0__70_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__70_9" > /dev/null 2>&1
fi
}
xyl_choose__380_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__351_v0 "No options provided.
" 31;
        __AF_eprintf_colored351_v0__88_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__88_9" > /dev/null 2>&1
        exit 1
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__359_v0 ;
    __AF_hide_cursor359_v0__93_5="$__AF_hide_cursor359_v0";
    echo "$__AF_hide_cursor359_v0__93_5" > /dev/null 2>&1
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_44=("");
        eprintf__350_v0 "${header}""
" __AMBER_ARRAY_44[@];
        __AF_eprintf350_v0__96_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__96_9" > /dev/null 2>&1
fi
    math_floor__337_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor337_v0__99_23="$__AF_math_floor337_v0";
    local total_pages="$__AF_math_floor337_v0__99_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    go_down__356_v0 ${display_count};
    __AF_go_down356_v0__108_5="$__AF_go_down356_v0";
    echo "$__AF_go_down356_v0__108_5" > /dev/null 2>&1
    __AMBER_ARRAY_45=("");
    eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_45[@];
    __AF_eprintf350_v0__109_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__109_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__351_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored351_v0__111_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__111_9" > /dev/null 2>&1
fi
    go_down__356_v0 1;
    __AF_go_down356_v0__113_5="$__AF_go_down356_v0";
    echo "$__AF_go_down356_v0__113_5" > /dev/null 2>&1
    eprintf_colored__351_v0 "↑↓" 0;
    __AF_eprintf_colored351_v0__115_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__115_5" > /dev/null 2>&1
    eprintf_colored__351_v0 " select" 2;
    __AF_eprintf_colored351_v0__116_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__116_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__351_v0 " • " 90;
        __AF_eprintf_colored351_v0__118_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__118_9" > /dev/null 2>&1
        eprintf_colored__351_v0 "←→" 0;
        __AF_eprintf_colored351_v0__119_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__119_9" > /dev/null 2>&1
        eprintf_colored__351_v0 " page" 2;
        __AF_eprintf_colored351_v0__120_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__120_9" > /dev/null 2>&1
fi
    eprintf_colored__351_v0 " • " 90;
    __AF_eprintf_colored351_v0__122_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__122_5" > /dev/null 2>&1
    eprintf_colored__351_v0 "enter" 0;
    __AF_eprintf_colored351_v0__123_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__123_5" > /dev/null 2>&1
    eprintf_colored__351_v0 " confirm" 2;
    __AF_eprintf_colored351_v0__124_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__124_5" > /dev/null 2>&1
    go_up__357_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up357_v0__125_5="$__AF_go_up357_v0";
    echo "$__AF_go_up357_v0__125_5" > /dev/null 2>&1
    __AMBER_ARRAY_46=("");
    eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_46[@];
    __AF_eprintf350_v0__126_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__126_5" > /dev/null 2>&1
    render_choose_page__377_v0 options[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count};
    __AF_render_choose_page377_v0__128_5="$__AF_render_choose_page377_v0";
    echo "$__AF_render_choose_page377_v0__128_5" > /dev/null 2>&1
    while :
do
        get_key__348_v0 ;
        __AF_get_key348_v0__131_19="${__AF_get_key348_v0}";
        local key="${__AF_get_key348_v0__131_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        get_page_options__375_v0 options[@] ${current_page} ${page_size};
        __AF_get_page_options375_v0__135_28=("${__AF_get_page_options375_v0[@]}");
        local page_options=("${__AF_get_page_options375_v0__135_28[@]}")
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__375_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options375_v0__142_48=("${__AF_get_page_options375_v0[@]}");
                    local new_page_options=("${__AF_get_page_options375_v0__142_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__375_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options375_v0__146_48=("${__AF_get_page_options375_v0[@]}");
                    local new_page_options=("${__AF_get_page_options375_v0__146_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
                selected=$(echo ${selected} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $(echo $([ "_${key}" != "_DOWN" ]; echo $?) '||' $([ "_${key}" != "_j" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '<' $(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    selected=0
else
                    current_page=0
                    selected=0
fi
else
                selected=$(echo ${selected} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                selected=0
else
                selected=0
fi
elif [ $(echo $([ "_${key}" != "_RIGHT" ]; echo $?) '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${current_page} '<' $(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                current_page=$(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                selected=0
else
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $([ "_${key}" != "_INPUT" ]; echo $?) != 0 ]; then
            break
else
            continue
fi
        if [ $(echo ${prev_page} '!=' ${current_page} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            remove_line__354_v0 ${display_count};
            __AF_remove_line354_v0__190_17="$__AF_remove_line354_v0";
            echo "$__AF_remove_line354_v0__190_17" > /dev/null 2>&1
            __AMBER_ARRAY_47=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_47[@];
            __AF_eprintf350_v0__191_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__191_17" > /dev/null 2>&1
            render_choose_page__377_v0 options[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count};
            __AF_render_choose_page377_v0__192_17="$__AF_render_choose_page377_v0";
            echo "$__AF_render_choose_page377_v0__192_17" > /dev/null 2>&1
            render_page_indicator__379_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator379_v0__193_17="$__AF_render_page_indicator379_v0";
            echo "$__AF_render_page_indicator379_v0__193_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__357_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up357_v0__196_17="$__AF_go_up357_v0";
            echo "$__AF_go_up357_v0__196_17" > /dev/null 2>&1
            __AMBER_ARRAY_48=("");
            eprintf__350_v0 "\e[K" __AMBER_ARRAY_48[@];
            __AF_eprintf350_v0__197_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__197_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__355_v0 "${#__AMBER_LEN}";
            __AF_print_blank355_v0__198_17="$__AF_print_blank355_v0";
            echo "$__AF_print_blank355_v0__198_17" > /dev/null 2>&1
            __AMBER_ARRAY_49=("");
            eprintf__350_v0 "${page_options[${prev_selected}]}" __AMBER_ARRAY_49[@];
            __AF_eprintf350_v0__199_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__199_17" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__358_v0 ${diff};
            __AF_go_up_or_down358_v0__202_17="$__AF_go_up_or_down358_v0";
            echo "$__AF_go_up_or_down358_v0__202_17" > /dev/null 2>&1
            __AMBER_ARRAY_50=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_50[@];
            __AF_eprintf350_v0__203_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__203_17" > /dev/null 2>&1
            __AMBER_ARRAY_51=("");
            eprintf__350_v0 "\e[K" __AMBER_ARRAY_51[@];
            __AF_eprintf350_v0__204_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__204_17" > /dev/null 2>&1
            get_page_options__375_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options375_v0__205_44=("${__AF_get_page_options375_v0[@]}");
            local current_page_options=("${__AF_get_page_options375_v0__205_44[@]}")
            eprintf_colored__351_v0 "${cursor}""${current_page_options[${selected}]}" 32;
            __AF_eprintf_colored351_v0__206_17="$__AF_eprintf_colored351_v0";
            echo "$__AF_eprintf_colored351_v0__206_17" > /dev/null 2>&1
            go_down__356_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down356_v0__208_17="$__AF_go_down356_v0";
            echo "$__AF_go_down356_v0__208_17" > /dev/null 2>&1
            __AMBER_ARRAY_52=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_52[@];
            __AF_eprintf350_v0__209_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__209_17" > /dev/null 2>&1
fi
done
    local info_lines=1
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        info_lines=$(echo ${info_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__356_v0 $(echo ${info_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_down356_v0__224_5="$__AF_go_down356_v0";
    echo "$__AF_go_down356_v0__224_5" > /dev/null 2>&1
    remove_line__354_v0 ${total_lines};
    __AF_remove_line354_v0__225_5="$__AF_remove_line354_v0";
    echo "$__AF_remove_line354_v0__225_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__360_v0 ;
    __AF_show_cursor360_v0__228_5="$__AF_show_cursor360_v0";
    echo "$__AF_show_cursor360_v0__228_5" > /dev/null 2>&1
    local global_selected=$(echo $(echo ${current_page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_xyl_choose380_v0="${options[${global_selected}]}";
    return 0
}
count_checked__381_v0() {
    local checked=("${!1}")
    local count=0
    for c in "${checked[@]}"; do
        if [ ${c} != 0 ]; then
            count=$(echo ${count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
done
    __AF_count_checked381_v0=${count};
    return 0
}
xyl_multi_choose__382_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__351_v0 "No options provided.
" 31;
        __AF_eprintf_colored351_v0__259_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__259_9" > /dev/null 2>&1
        __AMBER_ARRAY_53=();
        __AF_xyl_multi_choose382_v0=("${__AMBER_ARRAY_53[@]}");
        return 0
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__359_v0 ;
    __AF_hide_cursor359_v0__264_5="$__AF_hide_cursor359_v0";
    echo "$__AF_hide_cursor359_v0__264_5" > /dev/null 2>&1
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_54=("");
        eprintf__350_v0 "${header}""
" __AMBER_ARRAY_54[@];
        __AF_eprintf350_v0__267_9="$__AF_eprintf350_v0";
        echo "$__AF_eprintf350_v0__267_9" > /dev/null 2>&1
fi
    math_floor__337_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor337_v0__270_23="$__AF_math_floor337_v0";
    local total_pages="$__AF_math_floor337_v0__270_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    go_down__356_v0 ${display_count};
    __AF_go_down356_v0__279_5="$__AF_go_down356_v0";
    echo "$__AF_go_down356_v0__279_5" > /dev/null 2>&1
    __AMBER_ARRAY_55=("");
    eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_55[@];
    __AF_eprintf350_v0__280_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__280_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__351_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored351_v0__282_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__282_9" > /dev/null 2>&1
fi
    go_down__356_v0 1;
    __AF_go_down356_v0__284_5="$__AF_go_down356_v0";
    echo "$__AF_go_down356_v0__284_5" > /dev/null 2>&1
    eprintf_colored__351_v0 "↑↓" 0;
    __AF_eprintf_colored351_v0__286_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__286_5" > /dev/null 2>&1
    eprintf_colored__351_v0 " select" 2;
    __AF_eprintf_colored351_v0__287_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__287_5" > /dev/null 2>&1
    eprintf_colored__351_v0 " • " 90;
    __AF_eprintf_colored351_v0__288_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__288_5" > /dev/null 2>&1
    eprintf_colored__351_v0 "x" 0;
    __AF_eprintf_colored351_v0__289_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__289_5" > /dev/null 2>&1
    eprintf_colored__351_v0 " toggle" 2;
    __AF_eprintf_colored351_v0__290_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__290_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__351_v0 " • " 90;
        __AF_eprintf_colored351_v0__292_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__292_9" > /dev/null 2>&1
        eprintf_colored__351_v0 "←→" 0;
        __AF_eprintf_colored351_v0__293_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__293_9" > /dev/null 2>&1
        eprintf_colored__351_v0 " page" 2;
        __AF_eprintf_colored351_v0__294_9="$__AF_eprintf_colored351_v0";
        echo "$__AF_eprintf_colored351_v0__294_9" > /dev/null 2>&1
fi
    eprintf_colored__351_v0 " • " 90;
    __AF_eprintf_colored351_v0__296_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__296_5" > /dev/null 2>&1
    eprintf_colored__351_v0 "enter" 0;
    __AF_eprintf_colored351_v0__297_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__297_5" > /dev/null 2>&1
    eprintf_colored__351_v0 " confirm" 2;
    __AF_eprintf_colored351_v0__298_5="$__AF_eprintf_colored351_v0";
    echo "$__AF_eprintf_colored351_v0__298_5" > /dev/null 2>&1
    go_up__357_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up357_v0__299_5="$__AF_go_up357_v0";
    echo "$__AF_go_up357_v0__299_5" > /dev/null 2>&1
    __AMBER_ARRAY_56=("");
    eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_56[@];
    __AF_eprintf350_v0__300_5="$__AF_eprintf350_v0";
    echo "$__AF_eprintf350_v0__300_5" > /dev/null 2>&1
    __AMBER_ARRAY_57=();
    local checked=("${__AMBER_ARRAY_57[@]}")
    for _ in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_58=(0);
        checked+=("${__AMBER_ARRAY_58[@]}")
done
    render_multi_choose_page__378_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count};
    __AF_render_multi_choose_page378_v0__307_5="$__AF_render_multi_choose_page378_v0";
    echo "$__AF_render_multi_choose_page378_v0__307_5" > /dev/null 2>&1
    while :
do
        get_key__348_v0 ;
        __AF_get_key348_v0__310_19="${__AF_get_key348_v0}";
        local key="${__AF_get_key348_v0__310_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        get_page_options__375_v0 options[@] ${current_page} ${page_size};
        __AF_get_page_options375_v0__314_28=("${__AF_get_page_options375_v0[@]}");
        local page_options=("${__AF_get_page_options375_v0__314_28[@]}")
        get_page_start__376_v0 ${current_page} ${page_size};
        __AF_get_page_start376_v0__315_31="$__AF_get_page_start376_v0";
        local global_selected=$(echo "$__AF_get_page_start376_v0__315_31" '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__375_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options375_v0__322_48=("${__AF_get_page_options375_v0[@]}");
                    local new_page_options=("${__AF_get_page_options375_v0__322_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__375_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options375_v0__326_48=("${__AF_get_page_options375_v0[@]}");
                    local new_page_options=("${__AF_get_page_options375_v0__326_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
                selected=$(echo ${selected} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $(echo $([ "_${key}" != "_DOWN" ]; echo $?) '||' $([ "_${key}" != "_j" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '<' $(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    selected=0
else
                    current_page=0
                    selected=0
fi
else
                selected=$(echo ${selected} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                selected=0
else
                selected=0
fi
elif [ $(echo $([ "_${key}" != "_RIGHT" ]; echo $?) '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${current_page} '<' $(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                current_page=$(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                selected=0
else
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $(echo $([ "_${key}" != "_x" ]; echo $?) '||' $([ "_${key}" != "_X" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            count_checked__381_v0 checked[@];
            __AF_count_checked381_v0__367_34="$__AF_count_checked381_v0";
            if [ "${checked[${global_selected}]}" != 0 ]; then
                checked[${global_selected}]=0
elif [ $(echo $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $(echo "$__AF_count_checked381_v0__367_34" '<' ${limit} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                checked[${global_selected}]=1
else
                continue
fi
            go_up__357_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up357_v0__372_17="$__AF_go_up357_v0";
            echo "$__AF_go_up357_v0__372_17" > /dev/null 2>&1
            __AMBER_ARRAY_59=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_59[@];
            __AF_eprintf350_v0__373_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__373_17" > /dev/null 2>&1
            __AMBER_ARRAY_60=("");
            eprintf__350_v0 "\e[K" __AMBER_ARRAY_60[@];
            __AF_eprintf350_v0__374_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__374_17" > /dev/null 2>&1
            local check_mark=$(if [ "${checked[${global_selected}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            get_page_options__375_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options375_v0__376_44=("${__AF_get_page_options375_v0[@]}");
            local current_page_options=("${__AF_get_page_options375_v0__376_44[@]}")
            eprintf_colored__351_v0 "${cursor}""${check_mark}""${current_page_options[${selected}]}" 32;
            __AF_eprintf_colored351_v0__377_17="$__AF_eprintf_colored351_v0";
            echo "$__AF_eprintf_colored351_v0__377_17" > /dev/null 2>&1
            go_down__356_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down356_v0__378_17="$__AF_go_down356_v0";
            echo "$__AF_go_down356_v0__378_17" > /dev/null 2>&1
            __AMBER_ARRAY_61=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_61[@];
            __AF_eprintf350_v0__379_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__379_17" > /dev/null 2>&1
            continue
elif [ $([ "_${key}" != "_INPUT" ]; echo $?) != 0 ]; then
            break
else
            continue
fi
        if [ $(echo ${prev_page} '!=' ${current_page} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            remove_line__354_v0 ${display_count};
            __AF_remove_line354_v0__390_17="$__AF_remove_line354_v0";
            echo "$__AF_remove_line354_v0__390_17" > /dev/null 2>&1
            __AMBER_ARRAY_62=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_62[@];
            __AF_eprintf350_v0__391_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__391_17" > /dev/null 2>&1
            render_multi_choose_page__378_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count};
            __AF_render_multi_choose_page378_v0__392_17="$__AF_render_multi_choose_page378_v0";
            echo "$__AF_render_multi_choose_page378_v0__392_17" > /dev/null 2>&1
            render_page_indicator__379_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator379_v0__393_17="$__AF_render_page_indicator379_v0";
            echo "$__AF_render_page_indicator379_v0__393_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            get_page_start__376_v0 ${current_page} ${page_size};
            __AF_get_page_start376_v0__396_29="$__AF_get_page_start376_v0";
            local start="$__AF_get_page_start376_v0__396_29"
            local prev_global=$(echo ${start} '+' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up__357_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up357_v0__398_17="$__AF_go_up357_v0";
            echo "$__AF_go_up357_v0__398_17" > /dev/null 2>&1
            __AMBER_ARRAY_63=("");
            eprintf__350_v0 "\e[K" __AMBER_ARRAY_63[@];
            __AF_eprintf350_v0__399_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__399_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__355_v0 "${#__AMBER_LEN}";
            __AF_print_blank355_v0__400_17="$__AF_print_blank355_v0";
            echo "$__AF_print_blank355_v0__400_17" > /dev/null 2>&1
            local prev_check_mark=$(if [ "${checked[${prev_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            if [ "${checked[${prev_global}]}" != 0 ]; then
                eprintf_colored__351_v0 "✓ ""${page_options[${prev_selected}]}" 32;
                __AF_eprintf_colored351_v0__403_21="$__AF_eprintf_colored351_v0";
                echo "$__AF_eprintf_colored351_v0__403_21" > /dev/null 2>&1
else
                __AMBER_ARRAY_64=("");
                eprintf__350_v0 "• ""${page_options[${prev_selected}]}" __AMBER_ARRAY_64[@];
                __AF_eprintf350_v0__405_21="$__AF_eprintf350_v0";
                echo "$__AF_eprintf350_v0__405_21" > /dev/null 2>&1
fi
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__358_v0 ${diff};
            __AF_go_up_or_down358_v0__409_17="$__AF_go_up_or_down358_v0";
            echo "$__AF_go_up_or_down358_v0__409_17" > /dev/null 2>&1
            __AMBER_ARRAY_65=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_65[@];
            __AF_eprintf350_v0__410_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__410_17" > /dev/null 2>&1
            __AMBER_ARRAY_66=("");
            eprintf__350_v0 "\e[K" __AMBER_ARRAY_66[@];
            __AF_eprintf350_v0__411_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__411_17" > /dev/null 2>&1
            local new_global=$(echo ${start} '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local check_mark=$(if [ "${checked[${new_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            get_page_options__375_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options375_v0__414_44=("${__AF_get_page_options375_v0[@]}");
            local current_page_options=("${__AF_get_page_options375_v0__414_44[@]}")
            eprintf_colored__351_v0 "${cursor}""${check_mark}""${current_page_options[${selected}]}" 32;
            __AF_eprintf_colored351_v0__415_17="$__AF_eprintf_colored351_v0";
            echo "$__AF_eprintf_colored351_v0__415_17" > /dev/null 2>&1
            go_down__356_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down356_v0__417_17="$__AF_go_down356_v0";
            echo "$__AF_go_down356_v0__417_17" > /dev/null 2>&1
            __AMBER_ARRAY_67=("");
            eprintf__350_v0 "\e[9999D" __AMBER_ARRAY_67[@];
            __AF_eprintf350_v0__418_17="$__AF_eprintf350_v0";
            echo "$__AF_eprintf350_v0__418_17" > /dev/null 2>&1
fi
done
    local info_lines=1
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        info_lines=$(echo ${info_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__356_v0 $(echo ${info_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_down356_v0__433_5="$__AF_go_down356_v0";
    echo "$__AF_go_down356_v0__433_5" > /dev/null 2>&1
    remove_line__354_v0 ${total_lines};
    __AF_remove_line354_v0__434_5="$__AF_remove_line354_v0";
    echo "$__AF_remove_line354_v0__434_5" > /dev/null 2>&1
    __AMBER_ARRAY_68=();
    local result=("${__AMBER_ARRAY_68[@]}")
    for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ "${checked[${i}]}" != 0 ]; then
            __AMBER_ARRAY_69=("${options[${i}]}");
            result+=("${__AMBER_ARRAY_69[@]}")
fi
done
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__360_v0 ;
    __AF_show_cursor360_v0__444_5="$__AF_show_cursor360_v0";
    echo "$__AF_show_cursor360_v0__444_5" > /dev/null 2>&1
    __AF_xyl_multi_choose382_v0=("${result[@]}");
    return 0
}
print_choose_help__424_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    printf_colored__349_v0 "choose" 92;
    __AF_printf_colored349_v0__7_5="$__AF_printf_colored349_v0";
    echo "$__AF_printf_colored349_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_70=("");
    printf__99_v0 " - Choose from a list of options." __AMBER_ARRAY_70[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    echo_colored__105_v0 "Arguments: " 96;
    __AF_echo_colored105_v0__11_5="$__AF_echo_colored105_v0";
    echo "$__AF_echo_colored105_v0__11_5" > /dev/null 2>&1
    echo "  [<options> ...]        List of options to choose from"
    echo ""
    echo_colored__105_v0 "Flags: " 96;
    __AF_echo_colored105_v0__14_5="$__AF_echo_colored105_v0";
    echo "$__AF_echo_colored105_v0__14_5" > /dev/null 2>&1
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    echo ""
}
read_stdin_options__468_v0() {
    __AMBER_ARRAY_71=();
    local options=("${__AMBER_ARRAY_71[@]}")
    __AMBER_VAL_72=$( [ -t 0 ] && echo "true" || echo "false" );
    __AS=$?;
    local is_tty="${__AMBER_VAL_72}"
    if [ $([ "_${is_tty}" != "_false" ]; echo $?) != 0 ]; then
         while IFS= read -r line || [[ -n "$line" ]]; do options+=("$line"); done ;
        __AS=$?
fi
    __AF_read_stdin_options468_v0=("${options[@]}");
    return 0
}
execute_choose__469_v0() {
    local parameters=("${!1}")
    local cursor="> "
    local header="\e[96;1mChoose:\e[0m"
    read_stdin_options__468_v0 ;
    __AF_read_stdin_options468_v0__18_19=("${__AF_read_stdin_options468_v0[@]}");
    local options=("${__AF_read_stdin_options468_v0__18_19[@]}")
    local multi=0
    local limit=$(echo  '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local page_size=10
    for param in "${parameters[@]:2:9997}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__25_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__25_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--cursor=.*\$" 0;
        __AF_match_regex17_v0__29_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__33_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--limit=.*\$" 0;
        __AF_match_regex17_v0__37_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--no-limit\$" 0;
        __AF_match_regex17_v0__45_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--page-size=.*\$" 0;
        __AF_match_regex17_v0__48_13="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__25_13" '||' "$__AF_match_regex17_v0__25_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_choose_help__424_v0 ;
            __AF_print_choose_help424_v0__26_17="$__AF_print_choose_help424_v0";
            echo "$__AF_print_choose_help424_v0__26_17" > /dev/null 2>&1
            exit 0
elif [ "$__AF_match_regex17_v0__29_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__30_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__30_30[@]}")
            cursor="${result[1]}"
elif [ "$__AF_match_regex17_v0__33_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__34_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__34_30[@]}")
            header="${result[1]}"
elif [ "$__AF_match_regex17_v0__37_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__38_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__38_30[@]}")
            parse_number__12_v0 "${result[1]}";
            __AS=$?;
if [ $__AS != 0 ]; then
                eprintf_colored__351_v0 "Invalid limit value: ""${result[1]}""
" 31;
                __AF_eprintf_colored351_v0__40_21="$__AF_eprintf_colored351_v0";
                echo "$__AF_eprintf_colored351_v0__40_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__39_25="$__AF_parse_number12_v0";
            limit="$__AF_parse_number12_v0__39_25"
            multi=1
elif [ "$__AF_match_regex17_v0__45_13" != 0 ]; then
            multi=1
elif [ "$__AF_match_regex17_v0__48_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__49_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__49_30[@]}")
            parse_number__12_v0 "${result[1]}";
            __AS=$?;
if [ $__AS != 0 ]; then
                eprintf_colored__351_v0 "Invalid page-size value: ""${result[1]}""
" 31;
                __AF_eprintf_colored351_v0__51_21="$__AF_eprintf_colored351_v0";
                echo "$__AF_eprintf_colored351_v0__51_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__50_29="$__AF_parse_number12_v0";
            page_size="$__AF_parse_number12_v0__50_29"
else
            __AMBER_ARRAY_73=("${param}");
            options+=("${__AMBER_ARRAY_73[@]}")
fi
done
    if [ ${multi} != 0 ]; then
        xyl_multi_choose__382_v0 options[@] "${cursor}" "${header}" ${limit} ${page_size};
        __AF_xyl_multi_choose382_v0__62_23=("${__AF_xyl_multi_choose382_v0[@]}");
        local results=("${__AF_xyl_multi_choose382_v0__62_23[@]}")
        join__6_v0 results[@] "
";
        __AF_join6_v0__63_16="${__AF_join6_v0}";
        __AF_execute_choose469_v0="${__AF_join6_v0__63_16}";
        return 0
fi
    xyl_choose__380_v0 options[@] "${cursor}" "${header}" ${page_size};
    __AF_xyl_choose380_v0__66_12="${__AF_xyl_choose380_v0}";
    __AF_execute_choose469_v0="${__AF_xyl_choose380_v0__66_12}";
    return 0
}
get_key__499_v0() {
    __AMBER_VAL_74=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_74}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key499_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key499_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key499_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key499_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key499_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key499_v0="INPUT";
        return 0
else
        __AF_get_key499_v0="${var}";
        return 0
fi
}
printf_colored__500_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_75=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_75[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__501_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__502_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_76=("${message}");
    eprintf__501_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_76[@];
    __AF_eprintf501_v0__34_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__34_5" > /dev/null 2>&1
}
remove_line__505_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_77=("");
        eprintf__501_v0 "\e[A\e[K" __AMBER_ARRAY_77[@];
        __AF_eprintf501_v0__54_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__54_9" > /dev/null 2>&1
done
}
go_down__507_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_78=("");
        eprintf__501_v0 "
" __AMBER_ARRAY_78[@];
        __AF_eprintf501_v0__69_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__69_9" > /dev/null 2>&1
done
}
go_up__508_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_79=("");
        eprintf__501_v0 "\e[1A" __AMBER_ARRAY_79[@];
        __AF_eprintf501_v0__76_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__76_9" > /dev/null 2>&1
done
}
# move the cursor up or down `cnt` lines.
hide_cursor__510_v0() {
    __AMBER_ARRAY_80=("");
    eprintf__501_v0 "\e[?25l" __AMBER_ARRAY_80[@];
    __AF_eprintf501_v0__90_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__90_5" > /dev/null 2>&1
}
show_cursor__511_v0() {
    __AMBER_ARRAY_81=("");
    eprintf__501_v0 "\e[?25h" __AMBER_ARRAY_81[@];
    __AF_eprintf501_v0__94_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__94_5" > /dev/null 2>&1
}
render_confirm_options__526_v0() {
    local selected=$1
    __AMBER_ARRAY_82=("");
    eprintf__501_v0 " " __AMBER_ARRAY_82[@];
    __AF_eprintf501_v0__6_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__6_5" > /dev/null 2>&1
    if [ ${selected} != 0 ]; then
        # Yes selected (green background)
        __AMBER_ARRAY_83=("");
        eprintf__501_v0 "\e[42;37m    Yes    \e[0m" __AMBER_ARRAY_83[@];
        __AF_eprintf501_v0__9_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__9_9" > /dev/null 2>&1
        __AMBER_ARRAY_84=("");
        eprintf__501_v0 "  " __AMBER_ARRAY_84[@];
        __AF_eprintf501_v0__10_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__10_9" > /dev/null 2>&1
        # No not selected (dim)
        __AMBER_ARRAY_85=("");
        eprintf__501_v0 "\e[49;37m    No    \e[0m" __AMBER_ARRAY_85[@];
        __AF_eprintf501_v0__12_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__12_9" > /dev/null 2>&1
else
        # Yes not selected (dim)
        __AMBER_ARRAY_86=("");
        eprintf__501_v0 "\e[49;37m    Yes    \e[0m" __AMBER_ARRAY_86[@];
        __AF_eprintf501_v0__15_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_87=("");
        eprintf__501_v0 "  " __AMBER_ARRAY_87[@];
        __AF_eprintf501_v0__16_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__16_9" > /dev/null 2>&1
        # No selected (red background)
        __AMBER_ARRAY_88=("");
        eprintf__501_v0 "\e[41;37m    No    \e[0m" __AMBER_ARRAY_88[@];
        __AF_eprintf501_v0__18_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__18_9" > /dev/null 2>&1
fi
}
xyl_confirm__527_v0() {
    local header=$1
    local default_yes=$2
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__510_v0 ;
    __AF_hide_cursor510_v0__35_5="$__AF_hide_cursor510_v0";
    echo "$__AF_hide_cursor510_v0__35_5" > /dev/null 2>&1
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_89=("");
        eprintf__501_v0 "${header}""

" __AMBER_ARRAY_89[@];
        __AF_eprintf501_v0__38_9="$__AF_eprintf501_v0";
        echo "$__AF_eprintf501_v0__38_9" > /dev/null 2>&1
fi
    local selected=${default_yes}
    # Render initial options
    render_confirm_options__526_v0 ${selected};
    __AF_render_confirm_options526_v0__44_5="$__AF_render_confirm_options526_v0";
    echo "$__AF_render_confirm_options526_v0__44_5" > /dev/null 2>&1
    __AMBER_ARRAY_90=("");
    eprintf__501_v0 "

" __AMBER_ARRAY_90[@];
    __AF_eprintf501_v0__46_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__46_5" > /dev/null 2>&1
    __AMBER_ARRAY_91=("");
    eprintf__501_v0 "←→" __AMBER_ARRAY_91[@];
    __AF_eprintf501_v0__47_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__47_5" > /dev/null 2>&1
    eprintf_colored__502_v0 " select • " 90;
    __AF_eprintf_colored502_v0__48_5="$__AF_eprintf_colored502_v0";
    echo "$__AF_eprintf_colored502_v0__48_5" > /dev/null 2>&1
    __AMBER_ARRAY_92=("");
    eprintf__501_v0 "enter" __AMBER_ARRAY_92[@];
    __AF_eprintf501_v0__49_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__49_5" > /dev/null 2>&1
    eprintf_colored__502_v0 " confirm • " 90;
    __AF_eprintf_colored502_v0__50_5="$__AF_eprintf_colored502_v0";
    echo "$__AF_eprintf_colored502_v0__50_5" > /dev/null 2>&1
    __AMBER_ARRAY_93=("");
    eprintf__501_v0 "y" __AMBER_ARRAY_93[@];
    __AF_eprintf501_v0__51_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__51_5" > /dev/null 2>&1
    eprintf_colored__502_v0 " yes • " 90;
    __AF_eprintf_colored502_v0__52_5="$__AF_eprintf_colored502_v0";
    echo "$__AF_eprintf_colored502_v0__52_5" > /dev/null 2>&1
    __AMBER_ARRAY_94=("");
    eprintf__501_v0 "n" __AMBER_ARRAY_94[@];
    __AF_eprintf501_v0__53_5="$__AF_eprintf501_v0";
    echo "$__AF_eprintf501_v0__53_5" > /dev/null 2>&1
    eprintf_colored__502_v0 " no" 90;
    __AF_eprintf_colored502_v0__54_5="$__AF_eprintf_colored502_v0";
    echo "$__AF_eprintf_colored502_v0__54_5" > /dev/null 2>&1
    go_up__508_v0 2;
    __AF_go_up508_v0__55_5="$__AF_go_up508_v0";
    echo "$__AF_go_up508_v0__55_5" > /dev/null 2>&1
    while :
do
        get_key__499_v0 ;
        __AF_get_key499_v0__58_19="${__AF_get_key499_v0}";
        local key="${__AF_get_key499_v0__58_19}"
        if [ $(echo $(echo $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_RIGHT" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ ${selected} != 0 ]; then
                selected=0
                __AMBER_ARRAY_95=("");
                eprintf__501_v0 "\e[9999D\e[K" __AMBER_ARRAY_95[@];
                __AF_eprintf501_v0__65_25="$__AF_eprintf501_v0";
                echo "$__AF_eprintf501_v0__65_25" > /dev/null 2>&1
                render_confirm_options__526_v0 ${selected};
                __AF_render_confirm_options526_v0__66_25="$__AF_render_confirm_options526_v0";
                echo "$__AF_render_confirm_options526_v0__66_25" > /dev/null 2>&1
elif [ $(echo  '!' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=1
                __AMBER_ARRAY_96=("");
                eprintf__501_v0 "\e[9999D\e[K" __AMBER_ARRAY_96[@];
                __AF_eprintf501_v0__70_25="$__AF_eprintf501_v0";
                echo "$__AF_eprintf501_v0__70_25" > /dev/null 2>&1
                render_confirm_options__526_v0 ${selected};
                __AF_render_confirm_options526_v0__71_25="$__AF_render_confirm_options526_v0";
                echo "$__AF_render_confirm_options526_v0__71_25" > /dev/null 2>&1
fi
elif [ $(echo $([ "_${key}" != "_y" ]; echo $?) '||' $([ "_${key}" != "_Y" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            selected=1
            break
elif [ $(echo $([ "_${key}" != "_n" ]; echo $?) '||' $([ "_${key}" != "_N" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            selected=0
            break
elif [ $([ "_${key}" != "_INPUT" ]; echo $?) != 0 ]; then
            break
else
            continue
fi
done
    # Clean up: remove options line and hint line
    local total_lines=3
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__507_v0 2;
    __AF_go_down507_v0__96_5="$__AF_go_down507_v0";
    echo "$__AF_go_down507_v0__96_5" > /dev/null 2>&1
    remove_line__505_v0 ${total_lines};
    __AF_remove_line505_v0__97_5="$__AF_remove_line505_v0";
    echo "$__AF_remove_line505_v0__97_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__511_v0 ;
    __AF_show_cursor511_v0__100_5="$__AF_show_cursor511_v0";
    echo "$__AF_show_cursor511_v0__100_5" > /dev/null 2>&1
    __AF_xyl_confirm527_v0=${selected};
    return 0
}
print_confirm_help__568_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    printf_colored__500_v0 "confirm" 92;
    __AF_printf_colored500_v0__7_5="$__AF_printf_colored500_v0";
    echo "$__AF_printf_colored500_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_97=("");
    printf__99_v0 " - Display a Yes/No confirmation dialog." __AMBER_ARRAY_97[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    echo_colored__105_v0 "Flags: " 96;
    __AF_echo_colored105_v0__11_5="$__AF_echo_colored105_v0";
    echo "$__AF_echo_colored105_v0__11_5" > /dev/null 2>&1
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    echo ""
}
execute_confirm__637_v0() {
    local parameters=("${!1}")
    local header="\e[96;1mAre you sure?\e[0m"
    local default_yes=1
    for param in "${parameters[@]}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__13_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__13_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__17_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--default=.*\$" 0;
        __AF_match_regex17_v0__21_13="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__13_13" '||' "$__AF_match_regex17_v0__13_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_confirm_help__568_v0 ;
            __AF_print_confirm_help568_v0__14_17="$__AF_print_confirm_help568_v0";
            echo "$__AF_print_confirm_help568_v0__14_17" > /dev/null 2>&1
            exit 0
elif [ "$__AF_match_regex17_v0__17_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__18_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__18_30[@]}")
            header="${result[1]}"
elif [ "$__AF_match_regex17_v0__21_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__22_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__22_30[@]}")
            if [ $(echo $([ "_${result[1]}" != "_yes" ]; echo $?) '||' $([ "_${result[1]}" != "_y" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                default_yes=1
elif [ $(echo $([ "_${result[1]}" != "_no" ]; echo $?) '||' $([ "_${result[1]}" != "_n" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                default_yes=0
else
                                    eprintf_colored__502_v0 "Invalid default value: ""${result[1]}"". Use 'yes' or 'no'.
" 31;
                    __AF_eprintf_colored502_v0__27_25="$__AF_eprintf_colored502_v0";
                    echo "$__AF_eprintf_colored502_v0__27_25" > /dev/null 2>&1
                    exit 1
fi
fi
done
    xyl_confirm__527_v0 "${header}" ${default_yes};
    __AF_xyl_confirm527_v0__35_18="$__AF_xyl_confirm527_v0";
    local result="$__AF_xyl_confirm527_v0__35_18"
    __AF_execute_confirm637_v0=$(if [ ${result} != 0 ]; then echo "yes"; else echo "no"; fi);
    return 0
}
# #!/usr/bin/env amber
__0_VERSION="0.1.0"
__1_AMBER_VERSION="0.4.0"
check_prerequirements__639_v0() {
     echo "0" | bc -l > /dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
        eprintf_colored__116_v0 "Error: " 91;
        __AF_eprintf_colored116_v0__14_9="$__AF_eprintf_colored116_v0";
        echo "$__AF_eprintf_colored116_v0__14_9" > /dev/null 2>&1
        __AMBER_ARRAY_98=("");
        eprintf__115_v0 "bc is not installed. Please install bc to use xylitol.
" __AMBER_ARRAY_98[@];
        __AF_eprintf115_v0__15_9="$__AF_eprintf115_v0";
        echo "$__AF_eprintf115_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_99=("");
        eprintf__115_v0 "  For Debian/Ubuntu: sudo apt install bc
" __AMBER_ARRAY_99[@];
        __AF_eprintf115_v0__16_9="$__AF_eprintf115_v0";
        echo "$__AF_eprintf115_v0__16_9" > /dev/null 2>&1
        __AMBER_ARRAY_100=("");
        eprintf__115_v0 "  For Fedora: sudo dnf install bc
" __AMBER_ARRAY_100[@];
        __AF_eprintf115_v0__17_9="$__AF_eprintf115_v0";
        echo "$__AF_eprintf115_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_101=("");
        eprintf__115_v0 "  For Arch Linux: sudo pacman -S bc
" __AMBER_ARRAY_101[@];
        __AF_eprintf115_v0__18_9="$__AF_eprintf115_v0";
        echo "$__AF_eprintf115_v0__18_9" > /dev/null 2>&1
        __AF_check_prerequirements639_v0=0;
        return 0
fi
    __AF_check_prerequirements639_v0=1;
    return 0
}
trap_cleanup__640_v0() {
     trap 'printf "\e[?25h\e[0m" >&2; stty echo < /dev/tty' EXIT ;
    __AS=$?
}
declare -r arguments=("$0" "$@")
    trap_cleanup__640_v0 ;
    __AF_trap_cleanup640_v0__29_5="$__AF_trap_cleanup640_v0";
    echo "$__AF_trap_cleanup640_v0__29_5" > /dev/null 2>&1
    check_prerequirements__639_v0 ;
    __AF_check_prerequirements639_v0__30_12="$__AF_check_prerequirements639_v0";
    if [ $(echo  '!' "$__AF_check_prerequirements639_v0__30_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit 1
fi
    if [ $([ "_${arguments[1]}" != "_input" ]; echo $?) != 0 ]; then
                    execute_input__308_v0 arguments[@];
            __AF_execute_input308_v0__33_18="${__AF_execute_input308_v0}";
            echo "${__AF_execute_input308_v0__33_18}"
elif [ $([ "_${arguments[1]}" != "_choose" ]; echo $?) != 0 ]; then
                    execute_choose__469_v0 arguments[@];
            __AF_execute_choose469_v0__36_18="${__AF_execute_choose469_v0}";
            echo "${__AF_execute_choose469_v0__36_18}"
elif [ $([ "_${arguments[1]}" != "_confirm" ]; echo $?) != 0 ]; then
                    execute_confirm__637_v0 arguments[@];
            __AF_execute_confirm637_v0__39_26="${__AF_execute_confirm637_v0}";
            result="${__AF_execute_confirm637_v0__39_26}"
            if [ $([ "_${result}" != "_yes" ]; echo $?) != 0 ]; then
                exit 0
else
                exit 1
fi
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_help" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    print_help__180_v0 ;
            __AF_print_help180_v0__46_13="$__AF_print_help180_v0";
            echo "$__AF_print_help180_v0__46_13" > /dev/null 2>&1
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_version" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--version" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-v" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    __AMBER_ARRAY_102=("");
            printf__99_v0 "xylitol.sh version: " __AMBER_ARRAY_102[@];
            __AF_printf99_v0__50_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__50_13" > /dev/null 2>&1
            printf_colored__114_v0 "${__0_VERSION}" 93;
            __AF_printf_colored114_v0__51_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__51_13" > /dev/null 2>&1
            echo ""
            echo ""
            printf_colored__114_v0 "written in " 90;
            __AF_printf_colored114_v0__54_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__54_13" > /dev/null 2>&1
            printf_colored__114_v0 "🧡Amber" 33;
            __AF_printf_colored114_v0__55_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__55_13" > /dev/null 2>&1
            printf_colored__114_v0 " ""${__1_AMBER_VERSION}" 90;
            __AF_printf_colored114_v0__56_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__56_13" > /dev/null 2>&1
else
                    print_help__180_v0 ;
            __AF_print_help180_v0__60_13="$__AF_print_help180_v0";
            echo "$__AF_print_help180_v0__60_13" > /dev/null 2>&1
            printf_colored__114_v0 "Error: " 91;
            __AF_printf_colored114_v0__61_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__61_13" > /dev/null 2>&1
            echo "Unknown command '""${arguments[1]}""'"
fi
