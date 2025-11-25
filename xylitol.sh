#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-11-25 12:52:25
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
# move the cursor up or down `cnt` lines.
print_help__174_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    printf_colored__114_v0 "Xylitol" 92;
    __AF_printf_colored114_v0__7_5="$__AF_printf_colored114_v0";
    echo "$__AF_printf_colored114_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_6=("");
    printf__99_v0 " - A tool for " __AMBER_ARRAY_6[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    printf_colored__114_v0 "fresh" 92;
    __AF_printf_colored114_v0__9_5="$__AF_printf_colored114_v0";
    echo "$__AF_printf_colored114_v0__9_5" > /dev/null 2>&1
    __AMBER_ARRAY_7=("");
    printf__99_v0 " shell scripts." __AMBER_ARRAY_7[@];
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
    __AMBER_ARRAY_8=("");
    printf__99_v0 "Run " __AMBER_ARRAY_8[@];
    __AF_printf99_v0__21_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__21_5" > /dev/null 2>&1
    printf_colored__114_v0 "./xylitol.sh <command> --help" 93;
    __AF_printf_colored114_v0__22_5="$__AF_printf_colored114_v0";
    echo "$__AF_printf_colored114_v0__22_5" > /dev/null 2>&1
    __AMBER_ARRAY_9=("");
    printf__99_v0 " for more information on a command." __AMBER_ARRAY_9[@];
    __AF_printf99_v0__23_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__23_5" > /dev/null 2>&1
    echo ""
}
get_char__203_v0() {
    __AMBER_VAL_10=$( read -n 1 key; printf "%s" "$key");
    __AS=$?;
    local char="${__AMBER_VAL_10}"
    __AF_get_char203_v0="${char}";
    return 0
}
printf_colored__205_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_11=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_11[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__206_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__207_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_12=("${message}");
    eprintf__206_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_12[@];
    __AF_eprintf206_v0__34_5="$__AF_eprintf206_v0";
    echo "$__AF_eprintf206_v0__34_5" > /dev/null 2>&1
}
remove__209_v0() {
    local cnt=$1
    __AMBER_ARRAY_13=();
    local remove_text=("${__AMBER_ARRAY_13[@]}")
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_14=("\b \b");
        remove_text+=("${__AMBER_ARRAY_14[@]}")
done
    join__6_v0 remove_text[@] "";
    __AF_join6_v0__48_13="${__AF_join6_v0}";
    __AMBER_ARRAY_15=("");
    eprintf__206_v0 "${__AF_join6_v0__48_13}" __AMBER_ARRAY_15[@];
    __AF_eprintf206_v0__48_5="$__AF_eprintf206_v0";
    echo "$__AF_eprintf206_v0__48_5" > /dev/null 2>&1
}
remove_line__210_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_16=("");
        eprintf__206_v0 "\e[A\e[K" __AMBER_ARRAY_16[@];
        __AF_eprintf206_v0__54_9="$__AF_eprintf206_v0";
        echo "$__AF_eprintf206_v0__54_9" > /dev/null 2>&1
done
}
go_down__212_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_17=("");
        eprintf__206_v0 "
" __AMBER_ARRAY_17[@];
        __AF_eprintf206_v0__69_9="$__AF_eprintf206_v0";
        echo "$__AF_eprintf206_v0__69_9" > /dev/null 2>&1
done
}
go_up__213_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_18=("");
        eprintf__206_v0 "\e[1A" __AMBER_ARRAY_18[@];
        __AF_eprintf206_v0__76_9="$__AF_eprintf206_v0";
        echo "$__AF_eprintf206_v0__76_9" > /dev/null 2>&1
done
}
# move the cursor up or down `cnt` lines.
xyl_input__227_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_19=("");
        eprintf__206_v0 "${header}""
" __AMBER_ARRAY_19[@];
        __AF_eprintf206_v0__18_9="$__AF_eprintf206_v0";
        echo "$__AF_eprintf206_v0__18_9" > /dev/null 2>&1
fi
    go_down__212_v0 2;
    __AF_go_down212_v0__21_5="$__AF_go_down212_v0";
    echo "$__AF_go_down212_v0__21_5" > /dev/null 2>&1
    eprintf_colored__207_v0 "enter" 0;
    __AF_eprintf_colored207_v0__22_5="$__AF_eprintf_colored207_v0";
    echo "$__AF_eprintf_colored207_v0__22_5" > /dev/null 2>&1
    eprintf_colored__207_v0 " submit" 2;
    __AF_eprintf_colored207_v0__23_5="$__AF_eprintf_colored207_v0";
    echo "$__AF_eprintf_colored207_v0__23_5" > /dev/null 2>&1
    go_up__213_v0 2;
    __AF_go_up213_v0__24_5="$__AF_go_up213_v0";
    echo "$__AF_go_up213_v0__24_5" > /dev/null 2>&1
    __AMBER_ARRAY_20=("");
    eprintf__206_v0 "\e[99999D" __AMBER_ARRAY_20[@];
    __AF_eprintf206_v0__25_5="$__AF_eprintf206_v0";
    echo "$__AF_eprintf206_v0__25_5" > /dev/null 2>&1
    __AMBER_ARRAY_21=("");
    eprintf__206_v0 "${prompt}" __AMBER_ARRAY_21[@];
    __AF_eprintf206_v0__27_5="$__AF_eprintf206_v0";
    echo "$__AF_eprintf206_v0__27_5" > /dev/null 2>&1
    eprintf_colored__207_v0 "${placeholder}" 90;
    __AF_eprintf_colored207_v0__28_5="$__AF_eprintf_colored207_v0";
    echo "$__AF_eprintf_colored207_v0__28_5" > /dev/null 2>&1
     stty -echo ;
    __AS=$?
    get_char__203_v0 ;
    __AF_get_char203_v0__31_16="${__AF_get_char203_v0}";
    local char="${__AF_get_char203_v0__31_16}"
    __AMBER_LEN="${prompt}";
    remove__209_v0 "${#__AMBER_LEN}";
    __AF_remove209_v0__32_5="$__AF_remove209_v0";
    echo "$__AF_remove209_v0__32_5" > /dev/null 2>&1
    __AMBER_LEN="${placeholder}";
    remove__209_v0 "${#__AMBER_LEN}";
    __AF_remove209_v0__33_5="$__AF_remove209_v0";
    echo "$__AF_remove209_v0__33_5" > /dev/null 2>&1
    remove__209_v0 1;
    __AF_remove209_v0__34_5="$__AF_remove209_v0";
    echo "$__AF_remove209_v0__34_5" > /dev/null 2>&1
    local text=""
    if [ $(echo  '!' ${password} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         stty echo ;
        __AS=$?
        __AMBER_VAL_22=$( read -e -i ${char} -p "${prompt}" text; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_22}"
else
         stty echo ;
        __AS=$?
        __AMBER_VAL_23=$( read -es -i ${char} -p "${prompt}" text; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_23}"
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        go_down__212_v0 2;
        __AF_go_down212_v0__46_9="$__AF_go_down212_v0";
        echo "$__AF_go_down212_v0__46_9" > /dev/null 2>&1
        remove_line__210_v0 4;
        __AF_remove_line210_v0__47_9="$__AF_remove_line210_v0";
        echo "$__AF_remove_line210_v0__47_9" > /dev/null 2>&1
else
        go_down__212_v0 2;
        __AF_go_down212_v0__49_9="$__AF_go_down212_v0";
        echo "$__AF_go_down212_v0__49_9" > /dev/null 2>&1
        remove_line__210_v0 3;
        __AF_remove_line210_v0__50_9="$__AF_remove_line210_v0";
        echo "$__AF_remove_line210_v0__50_9" > /dev/null 2>&1
fi
    __AF_xyl_input227_v0="${text}";
    return 0
}
print_input_help__266_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    printf_colored__205_v0 "input" 92;
    __AF_printf_colored205_v0__7_5="$__AF_printf_colored205_v0";
    echo "$__AF_printf_colored205_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_24=("");
    printf__99_v0 " - Prompt for some input from the user." __AMBER_ARRAY_24[@];
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
execute_input__296_v0() {
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
            print_input_help__266_v0 ;
            __AF_print_input_help266_v0__13_13="$__AF_print_input_help266_v0";
            echo "$__AF_print_input_help266_v0__13_13" > /dev/null 2>&1
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
    xyl_input__227_v0 "${prompt}" "${placeholder}" "${header}" ${password};
    __AF_xyl_input227_v0__33_12="${__AF_xyl_input227_v0}";
    __AF_execute_input296_v0="${__AF_xyl_input227_v0__33_12}";
    return 0
}
get_key__326_v0() {
    __AMBER_VAL_25=$( read -rsn1 k; if [[ "$k" == $'\e' ]]; then read -rsn2 r; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_25}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key326_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key326_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key326_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key326_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key326_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key326_v0="INPUT";
        return 0
else
        __AF_get_key326_v0="${var}";
        return 0
fi
}
printf_colored__327_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_26=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_26[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__328_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__329_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_27=("${message}");
    eprintf__328_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_27[@];
    __AF_eprintf328_v0__34_5="$__AF_eprintf328_v0";
    echo "$__AF_eprintf328_v0__34_5" > /dev/null 2>&1
}
colored__330_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored330_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__332_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_28=("");
        eprintf__328_v0 "\e[A\e[K" __AMBER_ARRAY_28[@];
        __AF_eprintf328_v0__54_9="$__AF_eprintf328_v0";
        echo "$__AF_eprintf328_v0__54_9" > /dev/null 2>&1
done
}
print_blank__333_v0() {
    local cnt=$1
    # Prints blank spaces.
    for _ in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_29=("");
        eprintf__328_v0 " " __AMBER_ARRAY_29[@];
        __AF_eprintf328_v0__61_9="$__AF_eprintf328_v0";
        echo "$__AF_eprintf328_v0__61_9" > /dev/null 2>&1
done
}
go_down__334_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_30=("");
        eprintf__328_v0 "
" __AMBER_ARRAY_30[@];
        __AF_eprintf328_v0__69_9="$__AF_eprintf328_v0";
        echo "$__AF_eprintf328_v0__69_9" > /dev/null 2>&1
done
}
go_up__335_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_31=("");
        eprintf__328_v0 "\e[1A" __AMBER_ARRAY_31[@];
        __AF_eprintf328_v0__76_9="$__AF_eprintf328_v0";
        echo "$__AF_eprintf328_v0__76_9" > /dev/null 2>&1
done
}
# move the cursor up or down `cnt` lines.
go_up_or_down__336_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__334_v0 ${cnt};
        __AF_go_down334_v0__83_9="$__AF_go_down334_v0";
        echo "$__AF_go_down334_v0__83_9" > /dev/null 2>&1
else
        go_up__335_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up335_v0__85_9="$__AF_go_up335_v0";
        echo "$__AF_go_up335_v0__85_9" > /dev/null 2>&1
fi
}
xyl_choose__349_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
     stty -echo ;
    __AS=$?
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__329_v0 "No options provided.
" 31;
        __AF_eprintf_colored329_v0__12_9="$__AF_eprintf_colored329_v0";
        echo "$__AF_eprintf_colored329_v0__12_9" > /dev/null 2>&1
         stty echo ;
        __AS=$?
        exit 1
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_32=("");
        eprintf__328_v0 "${header}""
" __AMBER_ARRAY_32[@];
        __AF_eprintf328_v0__18_9="$__AF_eprintf328_v0";
        echo "$__AF_eprintf328_v0__18_9" > /dev/null 2>&1
fi
    go_down__334_v0 $(echo "${#options[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_down334_v0__21_5="$__AF_go_down334_v0";
    echo "$__AF_go_down334_v0__21_5" > /dev/null 2>&1
    eprintf_colored__329_v0 "↑↓" 0;
    __AF_eprintf_colored329_v0__22_5="$__AF_eprintf_colored329_v0";
    echo "$__AF_eprintf_colored329_v0__22_5" > /dev/null 2>&1
    eprintf_colored__329_v0 " select" 2;
    __AF_eprintf_colored329_v0__23_5="$__AF_eprintf_colored329_v0";
    echo "$__AF_eprintf_colored329_v0__23_5" > /dev/null 2>&1
    eprintf_colored__329_v0 " • " 90;
    __AF_eprintf_colored329_v0__24_5="$__AF_eprintf_colored329_v0";
    echo "$__AF_eprintf_colored329_v0__24_5" > /dev/null 2>&1
    eprintf_colored__329_v0 "enter" 0;
    __AF_eprintf_colored329_v0__25_5="$__AF_eprintf_colored329_v0";
    echo "$__AF_eprintf_colored329_v0__25_5" > /dev/null 2>&1
    eprintf_colored__329_v0 " confirm" 2;
    __AF_eprintf_colored329_v0__26_5="$__AF_eprintf_colored329_v0";
    echo "$__AF_eprintf_colored329_v0__26_5" > /dev/null 2>&1
    go_up__335_v0 $(echo "${#options[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up335_v0__27_5="$__AF_go_up335_v0";
    echo "$__AF_go_up335_v0__27_5" > /dev/null 2>&1
    __AMBER_ARRAY_33=("");
    eprintf__328_v0 "\e[9999D" __AMBER_ARRAY_33[@];
    __AF_eprintf328_v0__28_5="$__AF_eprintf328_v0";
    echo "$__AF_eprintf328_v0__28_5" > /dev/null 2>&1
    local selected=0
    for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ $(echo ${i} '==' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__329_v0 "${cursor}""${options[${i}]}""
" 32;
            __AF_eprintf_colored329_v0__34_13="$__AF_eprintf_colored329_v0";
            echo "$__AF_eprintf_colored329_v0__34_13" > /dev/null 2>&1
else
            __AMBER_LEN="${cursor}";
            print_blank__333_v0 "${#__AMBER_LEN}";
            __AF_print_blank333_v0__36_13="$__AF_print_blank333_v0";
            echo "$__AF_print_blank333_v0__36_13" > /dev/null 2>&1
            __AMBER_ARRAY_34=("");
            eprintf__328_v0 "${options[${i}]}""
" __AMBER_ARRAY_34[@];
            __AF_eprintf328_v0__37_13="$__AF_eprintf328_v0";
            echo "$__AF_eprintf328_v0__37_13" > /dev/null 2>&1
fi
done
    while :
do
        get_key__326_v0 ;
        __AF_get_key326_v0__42_19="${__AF_get_key326_v0}";
        local key="${__AF_get_key326_v0__42_19}"
        local prev_selected=${selected}
        if [ $([ "_${key}" != "_UP" ]; echo $?) != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=$(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                selected=$(echo ${selected} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $([ "_${key}" != "_DOWN" ]; echo $?) != 0 ]; then
            if [ $(echo ${selected} '==' $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=0
else
                selected=$(echo ${selected} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
elif [ $([ "_${key}" != "_INPUT" ]; echo $?) != 0 ]; then
            break
else
            continue
fi
        if [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__335_v0 $(echo "${#options[@]}" '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up335_v0__68_13="$__AF_go_up335_v0";
            echo "$__AF_go_up335_v0__68_13" > /dev/null 2>&1
            __AMBER_ARRAY_35=("");
            eprintf__328_v0 "\e[K" __AMBER_ARRAY_35[@];
            __AF_eprintf328_v0__69_13="$__AF_eprintf328_v0";
            echo "$__AF_eprintf328_v0__69_13" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__333_v0 "${#__AMBER_LEN}";
            __AF_print_blank333_v0__70_13="$__AF_print_blank333_v0";
            echo "$__AF_print_blank333_v0__70_13" > /dev/null 2>&1
            __AMBER_ARRAY_36=("");
            eprintf__328_v0 "${options[${prev_selected}]}" __AMBER_ARRAY_36[@];
            __AF_eprintf328_v0__71_13="$__AF_eprintf328_v0";
            echo "$__AF_eprintf328_v0__71_13" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__336_v0 ${diff};
            __AF_go_up_or_down336_v0__74_13="$__AF_go_up_or_down336_v0";
            echo "$__AF_go_up_or_down336_v0__74_13" > /dev/null 2>&1
            __AMBER_ARRAY_37=("");
            eprintf__328_v0 "\e[9999D" __AMBER_ARRAY_37[@];
            __AF_eprintf328_v0__75_13="$__AF_eprintf328_v0";
            echo "$__AF_eprintf328_v0__75_13" > /dev/null 2>&1
            __AMBER_ARRAY_38=("");
            eprintf__328_v0 "\e[K" __AMBER_ARRAY_38[@];
            __AF_eprintf328_v0__76_13="$__AF_eprintf328_v0";
            echo "$__AF_eprintf328_v0__76_13" > /dev/null 2>&1
            eprintf_colored__329_v0 "${cursor}""${options[${selected}]}" 32;
            __AF_eprintf_colored329_v0__77_13="$__AF_eprintf_colored329_v0";
            echo "$__AF_eprintf_colored329_v0__77_13" > /dev/null 2>&1
            go_down__334_v0 $(echo "${#options[@]}" '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down334_v0__79_13="$__AF_go_down334_v0";
            echo "$__AF_go_down334_v0__79_13" > /dev/null 2>&1
            __AMBER_ARRAY_39=("");
            eprintf__328_v0 "\e[9999D" __AMBER_ARRAY_39[@];
            __AF_eprintf328_v0__80_13="$__AF_eprintf328_v0";
            echo "$__AF_eprintf328_v0__80_13" > /dev/null 2>&1
fi
done
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        go_down__334_v0 6;
        __AF_go_down334_v0__85_9="$__AF_go_down334_v0";
        echo "$__AF_go_down334_v0__85_9" > /dev/null 2>&1
        remove_line__332_v0 $(echo "${#options[@]}" '+' 7 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_remove_line332_v0__86_9="$__AF_remove_line332_v0";
        echo "$__AF_remove_line332_v0__86_9" > /dev/null 2>&1
else
        go_down__334_v0 6;
        __AF_go_down334_v0__88_9="$__AF_go_down334_v0";
        echo "$__AF_go_down334_v0__88_9" > /dev/null 2>&1
        remove_line__332_v0 $(echo "${#options[@]}" '+' 6 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_remove_line332_v0__89_9="$__AF_remove_line332_v0";
        echo "$__AF_remove_line332_v0__89_9" > /dev/null 2>&1
fi
     stty echo ;
    __AS=$?
    __AF_xyl_choose349_v0="${options[${selected}]}";
    return 0
}
print_choose_help__388_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    printf_colored__327_v0 "choose" 92;
    __AF_printf_colored327_v0__7_5="$__AF_printf_colored327_v0";
    echo "$__AF_printf_colored327_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_40=("");
    printf__99_v0 " - Choose from a list of options." __AMBER_ARRAY_40[@];
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
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo ""
}
execute_choose__430_v0() {
    local parameters=("${!1}")
    local cursor="> "
    colored__330_v0 "Choose:" 34;
    __AF_colored330_v0__8_18="${__AF_colored330_v0}";
    local header="${__AF_colored330_v0__8_18}"
    __AMBER_ARRAY_41=();
    local options=("${__AMBER_ARRAY_41[@]}")
    for param in "${parameters[@]:2:9997}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__13_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__13_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--cursor=.*\$" 0;
        __AF_match_regex17_v0__17_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__21_13="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__13_13" '||' "$__AF_match_regex17_v0__13_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_choose_help__388_v0 ;
            __AF_print_choose_help388_v0__14_17="$__AF_print_choose_help388_v0";
            echo "$__AF_print_choose_help388_v0__14_17" > /dev/null 2>&1
            exit 0
elif [ "$__AF_match_regex17_v0__17_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__18_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__18_30[@]}")
            cursor="${result[1]}"
elif [ "$__AF_match_regex17_v0__21_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__22_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__22_30[@]}")
            header="${result[1]}"
else
            __AMBER_ARRAY_42=("${param}");
            options+=("${__AMBER_ARRAY_42[@]}")
fi
done
    xyl_choose__349_v0 options[@] "${cursor}" "${header}";
    __AF_xyl_choose349_v0__31_12="${__AF_xyl_choose349_v0}";
    __AF_execute_choose430_v0="${__AF_xyl_choose349_v0__31_12}";
    return 0
}
# #!/usr/bin/env amber
__0_VERSION="0.1.0"
__1_AMBER_VERSION="0.4.0"
declare -r arguments=("$0" "$@")
    if [ $([ "_${arguments[1]}" != "_input" ]; echo $?) != 0 ]; then
                    execute_input__296_v0 arguments[@];
            __AF_execute_input296_v0__14_18="${__AF_execute_input296_v0}";
            echo "${__AF_execute_input296_v0__14_18}"
elif [ $([ "_${arguments[1]}" != "_choose" ]; echo $?) != 0 ]; then
                    execute_choose__430_v0 arguments[@];
            __AF_execute_choose430_v0__17_18="${__AF_execute_choose430_v0}";
            echo "${__AF_execute_choose430_v0__17_18}"
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_help" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    print_help__174_v0 ;
            __AF_print_help174_v0__20_13="$__AF_print_help174_v0";
            echo "$__AF_print_help174_v0__20_13" > /dev/null 2>&1
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_version" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--version" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-v" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    __AMBER_ARRAY_43=("");
            printf__99_v0 "xylitol.sh version: " __AMBER_ARRAY_43[@];
            __AF_printf99_v0__24_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__24_13" > /dev/null 2>&1
            printf_colored__114_v0 "${__0_VERSION}" 93;
            __AF_printf_colored114_v0__25_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__25_13" > /dev/null 2>&1
            echo ""
            echo ""
            printf_colored__114_v0 "written in " 90;
            __AF_printf_colored114_v0__28_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__28_13" > /dev/null 2>&1
            printf_colored__114_v0 "🧡Amber" 33;
            __AF_printf_colored114_v0__29_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__29_13" > /dev/null 2>&1
            printf_colored__114_v0 " ""${__1_AMBER_VERSION}" 90;
            __AF_printf_colored114_v0__30_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__30_13" > /dev/null 2>&1
else
                    print_help__174_v0 ;
            __AF_print_help174_v0__34_13="$__AF_print_help174_v0";
            echo "$__AF_print_help174_v0__34_13" > /dev/null 2>&1
            printf_colored__114_v0 "Error: " 91;
            __AF_printf_colored114_v0__35_13="$__AF_printf_colored114_v0";
            echo "$__AF_printf_colored114_v0__35_13" > /dev/null 2>&1
            echo "Unknown command '""${arguments[1]}""'"
fi
