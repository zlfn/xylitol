#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-11-26 11:43:18
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
printf_colored__141_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_5=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_5[@];
    __AF_printf99_v0__26_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__26_5" > /dev/null 2>&1
}
eprintf__142_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__143_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_6=("${message}");
    eprintf__142_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_6[@];
    __AF_eprintf142_v0__36_5="$__AF_eprintf142_v0";
    echo "$__AF_eprintf142_v0__36_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
print_help__226_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    printf_colored__141_v0 "Xylitol" 92;
    __AF_printf_colored141_v0__7_5="$__AF_printf_colored141_v0";
    echo "$__AF_printf_colored141_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_7=("");
    printf__99_v0 " - A tool for " __AMBER_ARRAY_7[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    printf_colored__141_v0 "fresh" 92;
    __AF_printf_colored141_v0__9_5="$__AF_printf_colored141_v0";
    echo "$__AF_printf_colored141_v0__9_5" > /dev/null 2>&1
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
    printf_colored__141_v0 "./xylitol.sh <command> --help" 93;
    __AF_printf_colored141_v0__22_5="$__AF_printf_colored141_v0";
    echo "$__AF_printf_colored141_v0__22_5" > /dev/null 2>&1
    __AMBER_ARRAY_10=("");
    printf__99_v0 " for more information on a command." __AMBER_ARRAY_10[@];
    __AF_printf99_v0__23_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__23_5" > /dev/null 2>&1
    echo ""
}
math_floor__255_v0() {
    local number=$1
    __AMBER_VAL_11=$( echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' );
    __AS=$?;
    __AF_math_floor255_v0="${__AMBER_VAL_11}";
    return 0
}
math_ceil__256_v0() {
    local number=$1
    math_floor__255_v0 ${number};
    __AF_math_floor255_v0__26_12="$__AF_math_floor255_v0";
    __AF_math_ceil256_v0=$(echo "$__AF_math_floor255_v0__26_12" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
get_char__292_v0() {
    __AMBER_VAL_12=$( read -n 1 key < /dev/tty; printf "%s" "$key" );
    __AS=$?;
    local char="${__AMBER_VAL_12}"
    __AF_get_char292_v0="${char}";
    return 0
}
printf_colored__294_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_13=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_13[@];
    __AF_printf99_v0__26_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__26_5" > /dev/null 2>&1
}
eprintf__295_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__296_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_14=("${message}");
    eprintf__295_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_14[@];
    __AF_eprintf295_v0__36_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__36_5" > /dev/null 2>&1
}
colored__297_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored297_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove__298_v0() {
    local cnt=$1
     printf '%0.s\b \b' $(seq 1 ${cnt}) >&2 ;
    __AS=$?
}
remove_line__299_v0() {
    local cnt=$1
     printf '\e[2K\e[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_15=("");
    eprintf__295_v0 "\e[9999D" __AMBER_ARRAY_15[@];
    __AF_eprintf295_v0__52_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__52_5" > /dev/null 2>&1
}
remove_current_line__300_v0() {
    __AMBER_ARRAY_16=("");
    eprintf__295_v0 "\e[2K\e[9999D" __AMBER_ARRAY_16[@];
    __AF_eprintf295_v0__57_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__57_5" > /dev/null 2>&1
}
new_line__302_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_17=("");
        eprintf__295_v0 "
" __AMBER_ARRAY_17[@];
        __AF_eprintf295_v0__69_9="$__AF_eprintf295_v0";
        echo "$__AF_eprintf295_v0__69_9" > /dev/null 2>&1
done
}
go_up__303_v0() {
    local cnt=$1
    __AMBER_ARRAY_18=("");
    eprintf__295_v0 "\e[${cnt}A" __AMBER_ARRAY_18[@];
    __AF_eprintf295_v0__75_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__75_5" > /dev/null 2>&1
}
go_down__304_v0() {
    local cnt=$1
    __AMBER_ARRAY_19=("");
    eprintf__295_v0 "\e[${cnt}B" __AMBER_ARRAY_19[@];
    __AF_eprintf295_v0__80_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__80_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
get_term_size__308_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_20=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_20}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__104_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__104_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_21=(80 24);
        __AF_get_term_size308_v0=("${__AMBER_ARRAY_21[@]}");
        return 0
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_22=(80 24);
        __AF_get_term_size308_v0=("${__AMBER_ARRAY_22[@]}");
        return 0
fi;
    __AF_parse_number12_v0__108_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__108_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_23=(80 24);
        __AF_get_term_size308_v0=("${__AMBER_ARRAY_23[@]}");
        return 0
fi;
    __AF_parse_number12_v0__111_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__111_16"
    __AMBER_ARRAY_24=(${cols} ${rows});
    __AF_get_term_size308_v0=("${__AMBER_ARRAY_24[@]}");
    return 0
}
get_term_width__309_v0() {
    get_term_size__308_v0 ;
    __AF_get_term_size308_v0__119_16=("${__AF_get_term_size308_v0[@]}");
    local size=("${__AF_get_term_size308_v0__119_16[@]}")
    __AF_get_term_width309_v0="${size[0]}";
    return 0
}
truncate_text__311_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo ${max_width} '<' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text311_v0="${text}";
        return 0
fi
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text311_v0="${text}";
        return 0
fi
    __AMBER_VAL_25=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_25}"
    __AF_truncate_text311_v0="${truncated}""...""\e[0m";
    return 0
}
render_tooltip__312_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    local separator=" • "
    local separator_len=3
    # Fast path: no truncation needed
    if [ $(echo ${total_len} '<=' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        local iter=0
        while :
do
            if [ $(echo ${iter} '>=' "${#items[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
elif [ $(echo ${iter} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                eprintf_colored__296_v0 "${separator}" 90;
                __AF_eprintf_colored296_v0__161_27="$__AF_eprintf_colored296_v0";
                echo "$__AF_eprintf_colored296_v0__161_27" > /dev/null 2>&1
fi
            colored__297_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored297_v0__163_41="${__AF_colored297_v0}";
            __AMBER_ARRAY_26=("");
            eprintf__295_v0 "${items[${iter}]}"" ""${__AF_colored297_v0__163_41}" __AMBER_ARRAY_26[@];
            __AF_eprintf295_v0__163_13="$__AF_eprintf295_v0";
            echo "$__AF_eprintf295_v0__163_13" > /dev/null 2>&1
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
else
        # Slow path: truncate
        local current_len=0
        local first=1
        local iter=0
        while :
do
            if [ $(echo ${iter} '>=' "${#items[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
fi
            local key="${items[${iter}]}"
            local action="${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${key}";
            __AMBER_LEN="${action}";
            local part_len=$(echo $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local needed=${part_len}
            if [ $(echo  '!' ${first} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                needed=$(echo ${needed} '+' ${separator_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            if [ $(echo $(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '>' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
fi
            if [ $(echo  '!' ${first} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                eprintf_colored__296_v0 "${separator}" 90;
                __AF_eprintf_colored296_v0__189_17="$__AF_eprintf_colored296_v0";
                echo "$__AF_eprintf_colored296_v0__189_17" > /dev/null 2>&1
fi
            colored__297_v0 "${action}" 2;
            __AF_colored297_v0__191_33="${__AF_colored297_v0}";
            __AMBER_ARRAY_27=("");
            eprintf__295_v0 "${key}"" ""${__AF_colored297_v0__191_33}" __AMBER_ARRAY_27[@];
            __AF_eprintf295_v0__191_13="$__AF_eprintf295_v0";
            echo "$__AF_eprintf295_v0__191_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
xyl_input__333_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
     stty -echo < /dev/tty ;
    __AS=$?
    get_term_width__309_v0 ;
    __AF_get_term_width309_v0__20_22="$__AF_get_term_width309_v0";
    local term_width="$__AF_get_term_width309_v0__20_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__311_v0 "${header}" ${term_width};
        __AF_truncate_text311_v0__23_17="${__AF_truncate_text311_v0}";
        __AMBER_ARRAY_28=("");
        eprintf__295_v0 "${__AF_truncate_text311_v0__23_17}""
" __AMBER_ARRAY_28[@];
        __AF_eprintf295_v0__23_9="$__AF_eprintf295_v0";
        echo "$__AF_eprintf295_v0__23_9" > /dev/null 2>&1
fi
    new_line__302_v0 2;
    __AF_new_line302_v0__26_5="$__AF_new_line302_v0";
    echo "$__AF_new_line302_v0__26_5" > /dev/null 2>&1
    # "enter submit" = 12
    __AMBER_ARRAY_29=("enter" "submit");
    render_tooltip__312_v0 __AMBER_ARRAY_29[@] 12 ${term_width};
    __AF_render_tooltip312_v0__28_5="$__AF_render_tooltip312_v0";
    echo "$__AF_render_tooltip312_v0__28_5" > /dev/null 2>&1
    go_up__303_v0 2;
    __AF_go_up303_v0__29_5="$__AF_go_up303_v0";
    echo "$__AF_go_up303_v0__29_5" > /dev/null 2>&1
    __AMBER_ARRAY_30=("");
    eprintf__295_v0 "\e[99999D" __AMBER_ARRAY_30[@];
    __AF_eprintf295_v0__30_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__30_5" > /dev/null 2>&1
    __AMBER_ARRAY_31=("");
    eprintf__295_v0 "${prompt}" __AMBER_ARRAY_31[@];
    __AF_eprintf295_v0__32_5="$__AF_eprintf295_v0";
    echo "$__AF_eprintf295_v0__32_5" > /dev/null 2>&1
    eprintf_colored__296_v0 "${placeholder}" 90;
    __AF_eprintf_colored296_v0__33_5="$__AF_eprintf_colored296_v0";
    echo "$__AF_eprintf_colored296_v0__33_5" > /dev/null 2>&1
    get_char__292_v0 ;
    __AF_get_char292_v0__35_16="${__AF_get_char292_v0}";
    local char="${__AF_get_char292_v0__35_16}"
    __AMBER_LEN="${prompt}";
    remove__298_v0 "${#__AMBER_LEN}";
    __AF_remove298_v0__36_5="$__AF_remove298_v0";
    echo "$__AF_remove298_v0__36_5" > /dev/null 2>&1
    __AMBER_LEN="${placeholder}";
    remove__298_v0 $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove298_v0__37_5="$__AF_remove298_v0";
    echo "$__AF_remove298_v0__37_5" > /dev/null 2>&1
    local text=""
    if [ $(echo  '!' ${password} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_32=$( read -e -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_32}"
else
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_33=$( read -es -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_33}"
fi
     stty -echo < /dev/tty ;
    __AS=$?
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_term_width__309_v0 ;
    __AF_get_term_width309_v0__51_22="$__AF_get_term_width309_v0";
    local term_width="$__AF_get_term_width309_v0__51_22"
    __AMBER_LEN="${prompt}""${text}";
    local input_display_len="${#__AMBER_LEN}"
    math_ceil__256_v0 $(echo ${input_display_len} '/' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_ceil256_v0__53_23="$__AF_math_ceil256_v0";
    local input_lines="$__AF_math_ceil256_v0__53_23"
    if [ $(echo ${input_lines} '<' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__304_v0 $(echo 2 '-' ${input_lines} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_down304_v0__56_9="$__AF_go_down304_v0";
        echo "$__AF_go_down304_v0__56_9" > /dev/null 2>&1
        remove_line__299_v0 2;
        __AF_remove_line299_v0__57_9="$__AF_remove_line299_v0";
        echo "$__AF_remove_line299_v0__57_9" > /dev/null 2>&1
        remove_current_line__300_v0 ;
        __AF_remove_current_line300_v0__58_9="$__AF_remove_current_line300_v0";
        echo "$__AF_remove_current_line300_v0__58_9" > /dev/null 2>&1
fi
    if [ $(echo ${input_lines} '>=' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        remove_line__299_v0 ${input_lines};
        __AF_remove_line299_v0__61_9="$__AF_remove_line299_v0";
        echo "$__AF_remove_line299_v0__61_9" > /dev/null 2>&1
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        remove_line__299_v0 1;
        __AF_remove_line299_v0__64_9="$__AF_remove_line299_v0";
        echo "$__AF_remove_line299_v0__64_9" > /dev/null 2>&1
        remove_current_line__300_v0 ;
        __AF_remove_current_line300_v0__65_9="$__AF_remove_current_line300_v0";
        echo "$__AF_remove_current_line300_v0__65_9" > /dev/null 2>&1
fi
     stty echo < /dev/tty ;
    __AS=$?
    __AF_xyl_input333_v0="${text}";
    return 0
}
print_input_help__380_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    printf_colored__294_v0 "input" 92;
    __AF_printf_colored294_v0__7_5="$__AF_printf_colored294_v0";
    echo "$__AF_printf_colored294_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_34=("");
    printf__99_v0 " - Prompt for some input from the user." __AMBER_ARRAY_34[@];
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
execute_input__410_v0() {
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
            print_input_help__380_v0 ;
            __AF_print_input_help380_v0__13_13="$__AF_print_input_help380_v0";
            echo "$__AF_print_input_help380_v0__13_13" > /dev/null 2>&1
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
    xyl_input__333_v0 "${prompt}" "${placeholder}" "${header}" ${password};
    __AF_xyl_input333_v0__33_12="${__AF_xyl_input333_v0}";
    __AF_execute_input410_v0="${__AF_xyl_input333_v0__33_12}";
    return 0
}
get_key__472_v0() {
    __AMBER_VAL_35=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_35}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key472_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key472_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key472_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key472_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key472_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key472_v0="INPUT";
        return 0
else
        __AF_get_key472_v0="${var}";
        return 0
fi
}
printf_colored__473_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_36=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_36[@];
    __AF_printf99_v0__26_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__26_5" > /dev/null 2>&1
}
eprintf__474_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__475_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_37=("${message}");
    eprintf__474_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_37[@];
    __AF_eprintf474_v0__36_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__36_5" > /dev/null 2>&1
}
colored__476_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored476_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__478_v0() {
    local cnt=$1
     printf '\e[2K\e[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_38=("");
    eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_38[@];
    __AF_eprintf474_v0__52_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__52_5" > /dev/null 2>&1
}
remove_current_line__479_v0() {
    __AMBER_ARRAY_39=("");
    eprintf__474_v0 "\e[2K\e[9999D" __AMBER_ARRAY_39[@];
    __AF_eprintf474_v0__57_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__57_5" > /dev/null 2>&1
}
print_blank__480_v0() {
    local cnt=$1
     printf '%*s' "${cnt}" ' ' >&2 ;
    __AS=$?
}
new_line__481_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_40=("");
        eprintf__474_v0 "
" __AMBER_ARRAY_40[@];
        __AF_eprintf474_v0__69_9="$__AF_eprintf474_v0";
        echo "$__AF_eprintf474_v0__69_9" > /dev/null 2>&1
done
}
go_up__482_v0() {
    local cnt=$1
    __AMBER_ARRAY_41=("");
    eprintf__474_v0 "\e[${cnt}A" __AMBER_ARRAY_41[@];
    __AF_eprintf474_v0__75_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__75_5" > /dev/null 2>&1
}
go_down__483_v0() {
    local cnt=$1
    __AMBER_ARRAY_42=("");
    eprintf__474_v0 "\e[${cnt}B" __AMBER_ARRAY_42[@];
    __AF_eprintf474_v0__80_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__80_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
go_up_or_down__484_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__483_v0 ${cnt};
        __AF_go_down483_v0__86_9="$__AF_go_down483_v0";
        echo "$__AF_go_down483_v0__86_9" > /dev/null 2>&1
else
        go_up__482_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up482_v0__88_9="$__AF_go_up482_v0";
        echo "$__AF_go_up482_v0__88_9" > /dev/null 2>&1
fi
}
hide_cursor__485_v0() {
    __AMBER_ARRAY_43=("");
    eprintf__474_v0 "\e[?25l" __AMBER_ARRAY_43[@];
    __AF_eprintf474_v0__93_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__93_5" > /dev/null 2>&1
}
show_cursor__486_v0() {
    __AMBER_ARRAY_44=("");
    eprintf__474_v0 "\e[?25h" __AMBER_ARRAY_44[@];
    __AF_eprintf474_v0__97_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__97_5" > /dev/null 2>&1
}
get_term_size__487_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_45=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_45}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__104_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__104_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_46=(80 24);
        __AF_get_term_size487_v0=("${__AMBER_ARRAY_46[@]}");
        return 0
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_47=(80 24);
        __AF_get_term_size487_v0=("${__AMBER_ARRAY_47[@]}");
        return 0
fi;
    __AF_parse_number12_v0__108_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__108_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_48=(80 24);
        __AF_get_term_size487_v0=("${__AMBER_ARRAY_48[@]}");
        return 0
fi;
    __AF_parse_number12_v0__111_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__111_16"
    __AMBER_ARRAY_49=(${cols} ${rows});
    __AF_get_term_size487_v0=("${__AMBER_ARRAY_49[@]}");
    return 0
}
get_term_width__488_v0() {
    get_term_size__487_v0 ;
    __AF_get_term_size487_v0__119_16=("${__AF_get_term_size487_v0[@]}");
    local size=("${__AF_get_term_size487_v0__119_16[@]}")
    __AF_get_term_width488_v0="${size[0]}";
    return 0
}
get_term_height__489_v0() {
    get_term_size__487_v0 ;
    __AF_get_term_size487_v0__125_16=("${__AF_get_term_size487_v0[@]}");
    local size=("${__AF_get_term_size487_v0__125_16[@]}")
    __AF_get_term_height489_v0="${size[1]}";
    return 0
}
truncate_text__490_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo ${max_width} '<' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text490_v0="${text}";
        return 0
fi
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text490_v0="${text}";
        return 0
fi
    __AMBER_VAL_50=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_50}"
    __AF_truncate_text490_v0="${truncated}""...""\e[0m";
    return 0
}
render_tooltip__491_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    local separator=" • "
    local separator_len=3
    # Fast path: no truncation needed
    if [ $(echo ${total_len} '<=' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        local iter=0
        while :
do
            if [ $(echo ${iter} '>=' "${#items[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
elif [ $(echo ${iter} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                eprintf_colored__475_v0 "${separator}" 90;
                __AF_eprintf_colored475_v0__161_27="$__AF_eprintf_colored475_v0";
                echo "$__AF_eprintf_colored475_v0__161_27" > /dev/null 2>&1
fi
            colored__476_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored476_v0__163_41="${__AF_colored476_v0}";
            __AMBER_ARRAY_51=("");
            eprintf__474_v0 "${items[${iter}]}"" ""${__AF_colored476_v0__163_41}" __AMBER_ARRAY_51[@];
            __AF_eprintf474_v0__163_13="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__163_13" > /dev/null 2>&1
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
else
        # Slow path: truncate
        local current_len=0
        local first=1
        local iter=0
        while :
do
            if [ $(echo ${iter} '>=' "${#items[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
fi
            local key="${items[${iter}]}"
            local action="${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${key}";
            __AMBER_LEN="${action}";
            local part_len=$(echo $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local needed=${part_len}
            if [ $(echo  '!' ${first} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                needed=$(echo ${needed} '+' ${separator_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            if [ $(echo $(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '>' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
fi
            if [ $(echo  '!' ${first} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                eprintf_colored__475_v0 "${separator}" 90;
                __AF_eprintf_colored475_v0__189_17="$__AF_eprintf_colored475_v0";
                echo "$__AF_eprintf_colored475_v0__189_17" > /dev/null 2>&1
fi
            colored__476_v0 "${action}" 2;
            __AF_colored476_v0__191_33="${__AF_colored476_v0}";
            __AMBER_ARRAY_52=("");
            eprintf__474_v0 "${key}"" ""${__AF_colored476_v0__191_33}" __AMBER_ARRAY_52[@];
            __AF_eprintf474_v0__191_13="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__191_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
get_page_options__512_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    local start=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local end=$(echo ${start} '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${end} '>' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        end="${#options[@]}"
fi
    __AMBER_ARRAY_53=();
    local result=("${__AMBER_ARRAY_53[@]}")
    for i in $(seq ${start} $(echo ${end} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_54=("${options[${i}]}");
        result+=("${__AMBER_ARRAY_54[@]}")
done
    __AF_get_page_options512_v0=("${result[@]}");
    return 0
}
get_page_start__513_v0() {
    local page=$1
    local page_size=$2
    __AF_get_page_start513_v0=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
render_choose_page__514_v0() {
    local options=("${!1}")
    local page=$2
    local sel=$3
    local cursor=$4
    local page_size=$5
    local display_count=$6
    local term_width=$7
    get_page_options__512_v0 options[@] ${page} ${page_size};
    __AF_get_page_options512_v0__23_24=("${__AF_get_page_options512_v0[@]}");
    local page_options=("${__AF_get_page_options512_v0__23_24[@]}")
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local max_option_width=$(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        truncate_text__490_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_truncate_text490_v0__27_32="${__AF_truncate_text490_v0}";
        local truncated_option="${__AF_truncate_text490_v0__27_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__475_v0 "${cursor}""${truncated_option}""
" 32;
            __AF_eprintf_colored475_v0__29_13="$__AF_eprintf_colored475_v0";
            echo "$__AF_eprintf_colored475_v0__29_13" > /dev/null 2>&1
else
            print_blank__480_v0 ${cursor_len};
            __AF_print_blank480_v0__31_13="$__AF_print_blank480_v0";
            echo "$__AF_print_blank480_v0__31_13" > /dev/null 2>&1
            __AMBER_ARRAY_55=("");
            eprintf__474_v0 "${truncated_option}""
" __AMBER_ARRAY_55[@];
            __AF_eprintf474_v0__32_13="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__32_13" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug gaurd
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_56=("");
            eprintf__474_v0 "\e[K
" __AMBER_ARRAY_56[@];
            __AF_eprintf474_v0__38_13="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__38_13" > /dev/null 2>&1
done
fi
}
render_multi_choose_page__515_v0() {
    local options=("${!1}")
    local checked=("${!2}")
    local page=$3
    local sel=$4
    local cursor=$5
    local page_size=$6
    local display_count=$7
    local term_width=$8
    get_page_options__512_v0 options[@] ${page} ${page_size};
    __AF_get_page_options512_v0__44_24=("${__AF_get_page_options512_v0[@]}");
    local page_options=("${__AF_get_page_options512_v0__44_24[@]}")
    get_page_start__513_v0 ${page} ${page_size};
    __AF_get_page_start513_v0__45_17="$__AF_get_page_start513_v0";
    local start="$__AF_get_page_start513_v0__45_17"
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local check_mark_len=2
    # "✓ " or "• "
    local max_option_width=$(echo $(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' ${check_mark_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local global_idx=$(echo ${start} '+' ${i} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        local check_mark=$(if [ "${checked[${global_idx}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
        truncate_text__490_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_truncate_text490_v0__52_32="${__AF_truncate_text490_v0}";
        local truncated_option="${__AF_truncate_text490_v0__52_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__475_v0 "${cursor}""${check_mark}""${truncated_option}""
" 32;
            __AF_eprintf_colored475_v0__54_23="$__AF_eprintf_colored475_v0";
            echo "$__AF_eprintf_colored475_v0__54_23" > /dev/null 2>&1
elif [ "${checked[${global_idx}]}" != 0 ]; then
                            print_blank__480_v0 ${cursor_len};
                __AF_print_blank480_v0__56_17="$__AF_print_blank480_v0";
                echo "$__AF_print_blank480_v0__56_17" > /dev/null 2>&1
                eprintf_colored__475_v0 "${check_mark}""${truncated_option}""
" 32;
                __AF_eprintf_colored475_v0__57_17="$__AF_eprintf_colored475_v0";
                echo "$__AF_eprintf_colored475_v0__57_17" > /dev/null 2>&1
else
                            print_blank__480_v0 ${cursor_len};
                __AF_print_blank480_v0__60_17="$__AF_print_blank480_v0";
                echo "$__AF_print_blank480_v0__60_17" > /dev/null 2>&1
                __AMBER_ARRAY_57=("");
                eprintf__474_v0 "${check_mark}""${truncated_option}""
" __AMBER_ARRAY_57[@];
                __AF_eprintf474_v0__61_17="$__AF_eprintf474_v0";
                echo "$__AF_eprintf474_v0__61_17" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug guard
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_58=("");
            eprintf__474_v0 "\e[K
" __AMBER_ARRAY_58[@];
            __AF_eprintf474_v0__68_13="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__68_13" > /dev/null 2>&1
done
fi
}
render_page_indicator__516_v0() {
    local page=$1
    local total_pages=$2
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_59=("");
        eprintf__474_v0 "\e[9999D\e[K" __AMBER_ARRAY_59[@];
        __AF_eprintf474_v0__75_9="$__AF_eprintf474_v0";
        echo "$__AF_eprintf474_v0__75_9" > /dev/null 2>&1
        eprintf_colored__475_v0 "Page $(echo ${page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored475_v0__76_9="$__AF_eprintf_colored475_v0";
        echo "$__AF_eprintf_colored475_v0__76_9" > /dev/null 2>&1
        __AMBER_ARRAY_60=("");
        eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_60[@];
        __AF_eprintf474_v0__77_9="$__AF_eprintf474_v0";
        echo "$__AF_eprintf474_v0__77_9" > /dev/null 2>&1
fi
}
xyl_choose__517_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__475_v0 "No options provided.
" 31;
        __AF_eprintf_colored475_v0__95_9="$__AF_eprintf_colored475_v0";
        echo "$__AF_eprintf_colored475_v0__95_9" > /dev/null 2>&1
        exit 1
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__485_v0 ;
    __AF_hide_cursor485_v0__100_5="$__AF_hide_cursor485_v0";
    echo "$__AF_hide_cursor485_v0__100_5" > /dev/null 2>&1
    get_term_width__488_v0 ;
    __AF_get_term_width488_v0__102_22="$__AF_get_term_width488_v0";
    local term_width="$__AF_get_term_width488_v0__102_22"
    get_term_height__489_v0 ;
    __AF_get_term_height489_v0__103_23="$__AF_get_term_height489_v0";
    local term_height="$__AF_get_term_height489_v0__103_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__490_v0 "${header}" ${term_width};
        __AF_truncate_text490_v0__110_17="${__AF_truncate_text490_v0}";
        __AMBER_ARRAY_61=("");
        eprintf__474_v0 "${__AF_truncate_text490_v0__110_17}""
" __AMBER_ARRAY_61[@];
        __AF_eprintf474_v0__110_9="$__AF_eprintf474_v0";
        echo "$__AF_eprintf474_v0__110_9" > /dev/null 2>&1
fi
    math_floor__255_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor255_v0__113_23="$__AF_math_floor255_v0";
    local total_pages="$__AF_math_floor255_v0__113_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__481_v0 ${display_count};
    __AF_new_line481_v0__122_5="$__AF_new_line481_v0";
    echo "$__AF_new_line481_v0__122_5" > /dev/null 2>&1
    __AMBER_ARRAY_62=("");
    eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_62[@];
    __AF_eprintf474_v0__123_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__123_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__475_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored475_v0__125_9="$__AF_eprintf_colored475_v0";
        echo "$__AF_eprintf_colored475_v0__125_9" > /dev/null 2>&1
fi
    new_line__481_v0 1;
    __AF_new_line481_v0__127_5="$__AF_new_line481_v0";
    echo "$__AF_new_line481_v0__127_5" > /dev/null 2>&1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_63=("↑↓" "select" "←→" "page" "enter" "confirm");
        render_tooltip__491_v0 __AMBER_ARRAY_63[@] 36 ${term_width};
        __AF_render_tooltip491_v0__132_9="$__AF_render_tooltip491_v0";
        echo "$__AF_render_tooltip491_v0__132_9" > /dev/null 2>&1
else
        __AMBER_ARRAY_64=("↑↓" "select" "enter" "confirm");
        render_tooltip__491_v0 __AMBER_ARRAY_64[@] 25 ${term_width};
        __AF_render_tooltip491_v0__134_9="$__AF_render_tooltip491_v0";
        echo "$__AF_render_tooltip491_v0__134_9" > /dev/null 2>&1
fi
    go_up__482_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up482_v0__136_5="$__AF_go_up482_v0";
    echo "$__AF_go_up482_v0__136_5" > /dev/null 2>&1
    __AMBER_ARRAY_65=("");
    eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_65[@];
    __AF_eprintf474_v0__137_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__137_5" > /dev/null 2>&1
    render_choose_page__514_v0 options[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
    __AF_render_choose_page514_v0__139_5="$__AF_render_choose_page514_v0";
    echo "$__AF_render_choose_page514_v0__139_5" > /dev/null 2>&1
    while :
do
        get_key__472_v0 ;
        __AF_get_key472_v0__142_19="${__AF_get_key472_v0}";
        local key="${__AF_get_key472_v0__142_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        get_page_options__512_v0 options[@] ${current_page} ${page_size};
        __AF_get_page_options512_v0__146_28=("${__AF_get_page_options512_v0[@]}");
        local page_options=("${__AF_get_page_options512_v0__146_28[@]}")
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__512_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options512_v0__153_48=("${__AF_get_page_options512_v0[@]}");
                    local new_page_options=("${__AF_get_page_options512_v0__153_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__512_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options512_v0__157_48=("${__AF_get_page_options512_v0[@]}");
                    local new_page_options=("${__AF_get_page_options512_v0__157_48[@]}")
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
        __AMBER_LEN="${cursor}";
        local max_option_width=$(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        if [ $(echo ${prev_page} '!=' ${current_page} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__482_v0 1;
            __AF_go_up482_v0__202_17="$__AF_go_up482_v0";
            echo "$__AF_go_up482_v0__202_17" > /dev/null 2>&1
            remove_line__478_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line478_v0__203_17="$__AF_remove_line478_v0";
            echo "$__AF_remove_line478_v0__203_17" > /dev/null 2>&1
            remove_current_line__479_v0 ;
            __AF_remove_current_line479_v0__204_17="$__AF_remove_current_line479_v0";
            echo "$__AF_remove_current_line479_v0__204_17" > /dev/null 2>&1
            __AMBER_ARRAY_66=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_66[@];
            __AF_eprintf474_v0__205_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__205_17" > /dev/null 2>&1
            render_choose_page__514_v0 options[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
            __AF_render_choose_page514_v0__206_17="$__AF_render_choose_page514_v0";
            echo "$__AF_render_choose_page514_v0__206_17" > /dev/null 2>&1
            render_page_indicator__516_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator516_v0__207_17="$__AF_render_page_indicator516_v0";
            echo "$__AF_render_page_indicator516_v0__207_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__482_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up482_v0__210_17="$__AF_go_up482_v0";
            echo "$__AF_go_up482_v0__210_17" > /dev/null 2>&1
            __AMBER_ARRAY_67=("");
            eprintf__474_v0 "\e[K" __AMBER_ARRAY_67[@];
            __AF_eprintf474_v0__211_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__211_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__480_v0 "${#__AMBER_LEN}";
            __AF_print_blank480_v0__212_17="$__AF_print_blank480_v0";
            echo "$__AF_print_blank480_v0__212_17" > /dev/null 2>&1
            truncate_text__490_v0 "${page_options[${prev_selected}]}" ${max_option_width};
            __AF_truncate_text490_v0__213_25="${__AF_truncate_text490_v0}";
            __AMBER_ARRAY_68=("");
            eprintf__474_v0 "${__AF_truncate_text490_v0__213_25}" __AMBER_ARRAY_68[@];
            __AF_eprintf474_v0__213_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__213_17" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__484_v0 ${diff};
            __AF_go_up_or_down484_v0__216_17="$__AF_go_up_or_down484_v0";
            echo "$__AF_go_up_or_down484_v0__216_17" > /dev/null 2>&1
            __AMBER_ARRAY_69=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_69[@];
            __AF_eprintf474_v0__217_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__217_17" > /dev/null 2>&1
            __AMBER_ARRAY_70=("");
            eprintf__474_v0 "\e[K" __AMBER_ARRAY_70[@];
            __AF_eprintf474_v0__218_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__218_17" > /dev/null 2>&1
            get_page_options__512_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options512_v0__219_44=("${__AF_get_page_options512_v0[@]}");
            local current_page_options=("${__AF_get_page_options512_v0__219_44[@]}")
            truncate_text__490_v0 "${current_page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text490_v0__220_42="${__AF_truncate_text490_v0}";
            eprintf_colored__475_v0 "${cursor}""${__AF_truncate_text490_v0__220_42}" 32;
            __AF_eprintf_colored475_v0__220_17="$__AF_eprintf_colored475_v0";
            echo "$__AF_eprintf_colored475_v0__220_17" > /dev/null 2>&1
            go_down__483_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down483_v0__222_17="$__AF_go_down483_v0";
            echo "$__AF_go_down483_v0__222_17" > /dev/null 2>&1
            __AMBER_ARRAY_71=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_71[@];
            __AF_eprintf474_v0__223_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__223_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__483_v0 1;
    __AF_go_down483_v0__233_5="$__AF_go_down483_v0";
    echo "$__AF_go_down483_v0__233_5" > /dev/null 2>&1
    remove_line__478_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line478_v0__234_5="$__AF_remove_line478_v0";
    echo "$__AF_remove_line478_v0__234_5" > /dev/null 2>&1
    remove_current_line__479_v0 ;
    __AF_remove_current_line479_v0__235_5="$__AF_remove_current_line479_v0";
    echo "$__AF_remove_current_line479_v0__235_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__486_v0 ;
    __AF_show_cursor486_v0__238_5="$__AF_show_cursor486_v0";
    echo "$__AF_show_cursor486_v0__238_5" > /dev/null 2>&1
    local global_selected=$(echo $(echo ${current_page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_xyl_choose517_v0="${options[${global_selected}]}";
    return 0
}
count_checked__518_v0() {
    local checked=("${!1}")
    local count=0
    for c in "${checked[@]}"; do
        if [ ${c} != 0 ]; then
            count=$(echo ${count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
done
    __AF_count_checked518_v0=${count};
    return 0
}
xyl_multi_choose__519_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__475_v0 "No options provided.
" 31;
        __AF_eprintf_colored475_v0__269_9="$__AF_eprintf_colored475_v0";
        echo "$__AF_eprintf_colored475_v0__269_9" > /dev/null 2>&1
        __AMBER_ARRAY_72=();
        __AF_xyl_multi_choose519_v0=("${__AMBER_ARRAY_72[@]}");
        return 0
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__485_v0 ;
    __AF_hide_cursor485_v0__274_5="$__AF_hide_cursor485_v0";
    echo "$__AF_hide_cursor485_v0__274_5" > /dev/null 2>&1
    get_term_width__488_v0 ;
    __AF_get_term_width488_v0__276_22="$__AF_get_term_width488_v0";
    local term_width="$__AF_get_term_width488_v0__276_22"
    get_term_height__489_v0 ;
    __AF_get_term_height489_v0__277_23="$__AF_get_term_height489_v0";
    local term_height="$__AF_get_term_height489_v0__277_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__490_v0 "${header}" ${term_width};
        __AF_truncate_text490_v0__284_17="${__AF_truncate_text490_v0}";
        __AMBER_ARRAY_73=("");
        eprintf__474_v0 "${__AF_truncate_text490_v0__284_17}""
" __AMBER_ARRAY_73[@];
        __AF_eprintf474_v0__284_9="$__AF_eprintf474_v0";
        echo "$__AF_eprintf474_v0__284_9" > /dev/null 2>&1
fi
    math_floor__255_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor255_v0__287_23="$__AF_math_floor255_v0";
    local total_pages="$__AF_math_floor255_v0__287_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__481_v0 ${display_count};
    __AF_new_line481_v0__296_5="$__AF_new_line481_v0";
    echo "$__AF_new_line481_v0__296_5" > /dev/null 2>&1
    __AMBER_ARRAY_74=("");
    eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_74[@];
    __AF_eprintf474_v0__297_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__297_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__475_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored475_v0__299_9="$__AF_eprintf_colored475_v0";
        echo "$__AF_eprintf_colored475_v0__299_9" > /dev/null 2>&1
fi
    new_line__481_v0 1;
    __AF_new_line481_v0__301_5="$__AF_new_line481_v0";
    echo "$__AF_new_line481_v0__301_5" > /dev/null 2>&1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ $(echo $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_75=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm");
        render_tooltip__491_v0 __AMBER_ARRAY_75[@] 55 ${term_width};
        __AF_render_tooltip491_v0__308_40="$__AF_render_tooltip491_v0";
        echo "$__AF_render_tooltip491_v0__308_40" > /dev/null 2>&1
elif [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_76=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm");
        render_tooltip__491_v0 __AMBER_ARRAY_76[@] 47 ${term_width};
        __AF_render_tooltip491_v0__309_26="$__AF_render_tooltip491_v0";
        echo "$__AF_render_tooltip491_v0__309_26" > /dev/null 2>&1
elif [ $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_77=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm");
        render_tooltip__491_v0 __AMBER_ARRAY_77[@] 44 ${term_width};
        __AF_render_tooltip491_v0__310_20="$__AF_render_tooltip491_v0";
        echo "$__AF_render_tooltip491_v0__310_20" > /dev/null 2>&1
else
        __AMBER_ARRAY_78=("↑↓" "select" "x" "toggle" "enter" "confirm");
        render_tooltip__491_v0 __AMBER_ARRAY_78[@] 36 ${term_width};
        __AF_render_tooltip491_v0__311_15="$__AF_render_tooltip491_v0";
        echo "$__AF_render_tooltip491_v0__311_15" > /dev/null 2>&1
fi
    go_up__482_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up482_v0__313_5="$__AF_go_up482_v0";
    echo "$__AF_go_up482_v0__313_5" > /dev/null 2>&1
    __AMBER_ARRAY_79=("");
    eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_79[@];
    __AF_eprintf474_v0__314_5="$__AF_eprintf474_v0";
    echo "$__AF_eprintf474_v0__314_5" > /dev/null 2>&1
    __AMBER_ARRAY_80=();
    local checked=("${__AMBER_ARRAY_80[@]}")
    for _ in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_81=(0);
        checked+=("${__AMBER_ARRAY_81[@]}")
done
    render_multi_choose_page__515_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
    __AF_render_multi_choose_page515_v0__321_5="$__AF_render_multi_choose_page515_v0";
    echo "$__AF_render_multi_choose_page515_v0__321_5" > /dev/null 2>&1
    while :
do
        get_key__472_v0 ;
        __AF_get_key472_v0__324_19="${__AF_get_key472_v0}";
        local key="${__AF_get_key472_v0__324_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        get_page_options__512_v0 options[@] ${current_page} ${page_size};
        __AF_get_page_options512_v0__328_28=("${__AF_get_page_options512_v0[@]}");
        local page_options=("${__AF_get_page_options512_v0__328_28[@]}")
        get_page_start__513_v0 ${current_page} ${page_size};
        __AF_get_page_start513_v0__329_31="$__AF_get_page_start513_v0";
        local global_selected=$(echo "$__AF_get_page_start513_v0__329_31" '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__512_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options512_v0__336_48=("${__AF_get_page_options512_v0[@]}");
                    local new_page_options=("${__AF_get_page_options512_v0__336_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__512_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options512_v0__340_48=("${__AF_get_page_options512_v0[@]}");
                    local new_page_options=("${__AF_get_page_options512_v0__340_48[@]}")
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
            count_checked__518_v0 checked[@];
            __AF_count_checked518_v0__381_34="$__AF_count_checked518_v0";
            if [ "${checked[${global_selected}]}" != 0 ]; then
                checked[${global_selected}]=0
elif [ $(echo $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $(echo "$__AF_count_checked518_v0__381_34" '<' ${limit} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                checked[${global_selected}]=1
else
                continue
fi
            __AMBER_LEN="${cursor}";
            local max_option_width=$(echo $(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            # 2 for check mark
            go_up__482_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up482_v0__387_17="$__AF_go_up482_v0";
            echo "$__AF_go_up482_v0__387_17" > /dev/null 2>&1
            __AMBER_ARRAY_82=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_82[@];
            __AF_eprintf474_v0__388_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__388_17" > /dev/null 2>&1
            __AMBER_ARRAY_83=("");
            eprintf__474_v0 "\e[K" __AMBER_ARRAY_83[@];
            __AF_eprintf474_v0__389_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__389_17" > /dev/null 2>&1
            local check_mark=$(if [ "${checked[${global_selected}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            get_page_options__512_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options512_v0__391_44=("${__AF_get_page_options512_v0[@]}");
            local current_page_options=("${__AF_get_page_options512_v0__391_44[@]}")
            truncate_text__490_v0 "${current_page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text490_v0__392_55="${__AF_truncate_text490_v0}";
            eprintf_colored__475_v0 "${cursor}""${check_mark}""${__AF_truncate_text490_v0__392_55}" 32;
            __AF_eprintf_colored475_v0__392_17="$__AF_eprintf_colored475_v0";
            echo "$__AF_eprintf_colored475_v0__392_17" > /dev/null 2>&1
            go_down__483_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down483_v0__393_17="$__AF_go_down483_v0";
            echo "$__AF_go_down483_v0__393_17" > /dev/null 2>&1
            __AMBER_ARRAY_84=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_84[@];
            __AF_eprintf474_v0__394_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__394_17" > /dev/null 2>&1
            continue
elif [ $(echo $(echo $([ "_${key}" != "_a" ]; echo $?) '||' $([ "_${key}" != "_A" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            count_checked__518_v0 checked[@];
            __AF_count_checked518_v0__398_35="$__AF_count_checked518_v0";
            local all_checked=$(echo "$__AF_count_checked518_v0__398_35" '==' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            for i in $(seq 0 $(echo "${#checked[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
                checked[${i}]=$(echo  '!' ${all_checked} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
            go_up__482_v0 ${display_count};
            __AF_go_up482_v0__402_17="$__AF_go_up482_v0";
            echo "$__AF_go_up482_v0__402_17" > /dev/null 2>&1
            __AMBER_ARRAY_85=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_85[@];
            __AF_eprintf474_v0__403_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__403_17" > /dev/null 2>&1
            render_multi_choose_page__515_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
            __AF_render_multi_choose_page515_v0__404_17="$__AF_render_multi_choose_page515_v0";
            echo "$__AF_render_multi_choose_page515_v0__404_17" > /dev/null 2>&1
            continue
elif [ $([ "_${key}" != "_INPUT" ]; echo $?) != 0 ]; then
            break
else
            continue
fi
        __AMBER_LEN="${cursor}";
        local max_option_width=$(echo $(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        # 2 for check mark
        if [ $(echo ${prev_page} '!=' ${current_page} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__482_v0 1;
            __AF_go_up482_v0__416_17="$__AF_go_up482_v0";
            echo "$__AF_go_up482_v0__416_17" > /dev/null 2>&1
            remove_line__478_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line478_v0__417_17="$__AF_remove_line478_v0";
            echo "$__AF_remove_line478_v0__417_17" > /dev/null 2>&1
            remove_current_line__479_v0 ;
            __AF_remove_current_line479_v0__418_17="$__AF_remove_current_line479_v0";
            echo "$__AF_remove_current_line479_v0__418_17" > /dev/null 2>&1
            __AMBER_ARRAY_86=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_86[@];
            __AF_eprintf474_v0__419_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__419_17" > /dev/null 2>&1
            render_multi_choose_page__515_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
            __AF_render_multi_choose_page515_v0__420_17="$__AF_render_multi_choose_page515_v0";
            echo "$__AF_render_multi_choose_page515_v0__420_17" > /dev/null 2>&1
            render_page_indicator__516_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator516_v0__421_17="$__AF_render_page_indicator516_v0";
            echo "$__AF_render_page_indicator516_v0__421_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            get_page_start__513_v0 ${current_page} ${page_size};
            __AF_get_page_start513_v0__424_29="$__AF_get_page_start513_v0";
            local start="$__AF_get_page_start513_v0__424_29"
            local prev_global=$(echo ${start} '+' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up__482_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up482_v0__426_17="$__AF_go_up482_v0";
            echo "$__AF_go_up482_v0__426_17" > /dev/null 2>&1
            __AMBER_ARRAY_87=("");
            eprintf__474_v0 "\e[K" __AMBER_ARRAY_87[@];
            __AF_eprintf474_v0__427_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__427_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__480_v0 "${#__AMBER_LEN}";
            __AF_print_blank480_v0__428_17="$__AF_print_blank480_v0";
            echo "$__AF_print_blank480_v0__428_17" > /dev/null 2>&1
            local prev_check_mark=$(if [ "${checked[${prev_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            if [ "${checked[${prev_global}]}" != 0 ]; then
                truncate_text__490_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_truncate_text490_v0__431_44="${__AF_truncate_text490_v0}";
                eprintf_colored__475_v0 "✓ ""${__AF_truncate_text490_v0__431_44}" 32;
                __AF_eprintf_colored475_v0__431_21="$__AF_eprintf_colored475_v0";
                echo "$__AF_eprintf_colored475_v0__431_21" > /dev/null 2>&1
else
                truncate_text__490_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_truncate_text490_v0__433_36="${__AF_truncate_text490_v0}";
                __AMBER_ARRAY_88=("");
                eprintf__474_v0 "• ""${__AF_truncate_text490_v0__433_36}" __AMBER_ARRAY_88[@];
                __AF_eprintf474_v0__433_21="$__AF_eprintf474_v0";
                echo "$__AF_eprintf474_v0__433_21" > /dev/null 2>&1
fi
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__484_v0 ${diff};
            __AF_go_up_or_down484_v0__437_17="$__AF_go_up_or_down484_v0";
            echo "$__AF_go_up_or_down484_v0__437_17" > /dev/null 2>&1
            __AMBER_ARRAY_89=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_89[@];
            __AF_eprintf474_v0__438_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__438_17" > /dev/null 2>&1
            __AMBER_ARRAY_90=("");
            eprintf__474_v0 "\e[K" __AMBER_ARRAY_90[@];
            __AF_eprintf474_v0__439_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__439_17" > /dev/null 2>&1
            local new_global=$(echo ${start} '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local check_mark=$(if [ "${checked[${new_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            get_page_options__512_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options512_v0__442_44=("${__AF_get_page_options512_v0[@]}");
            local current_page_options=("${__AF_get_page_options512_v0__442_44[@]}")
            truncate_text__490_v0 "${current_page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text490_v0__443_55="${__AF_truncate_text490_v0}";
            eprintf_colored__475_v0 "${cursor}""${check_mark}""${__AF_truncate_text490_v0__443_55}" 32;
            __AF_eprintf_colored475_v0__443_17="$__AF_eprintf_colored475_v0";
            echo "$__AF_eprintf_colored475_v0__443_17" > /dev/null 2>&1
            go_down__483_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down483_v0__445_17="$__AF_go_down483_v0";
            echo "$__AF_go_down483_v0__445_17" > /dev/null 2>&1
            __AMBER_ARRAY_91=("");
            eprintf__474_v0 "\e[9999D" __AMBER_ARRAY_91[@];
            __AF_eprintf474_v0__446_17="$__AF_eprintf474_v0";
            echo "$__AF_eprintf474_v0__446_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__483_v0 1;
    __AF_go_down483_v0__456_5="$__AF_go_down483_v0";
    echo "$__AF_go_down483_v0__456_5" > /dev/null 2>&1
    remove_line__478_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line478_v0__457_5="$__AF_remove_line478_v0";
    echo "$__AF_remove_line478_v0__457_5" > /dev/null 2>&1
    remove_current_line__479_v0 ;
    __AF_remove_current_line479_v0__458_5="$__AF_remove_current_line479_v0";
    echo "$__AF_remove_current_line479_v0__458_5" > /dev/null 2>&1
    __AMBER_ARRAY_92=();
    local result=("${__AMBER_ARRAY_92[@]}")
    for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ "${checked[${i}]}" != 0 ]; then
            __AMBER_ARRAY_93=("${options[${i}]}");
            result+=("${__AMBER_ARRAY_93[@]}")
fi
done
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__486_v0 ;
    __AF_show_cursor486_v0__468_5="$__AF_show_cursor486_v0";
    echo "$__AF_show_cursor486_v0__468_5" > /dev/null 2>&1
    __AF_xyl_multi_choose519_v0=("${result[@]}");
    return 0
}
print_choose_help__567_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    printf_colored__473_v0 "choose" 92;
    __AF_printf_colored473_v0__7_5="$__AF_printf_colored473_v0";
    echo "$__AF_printf_colored473_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_94=("");
    printf__99_v0 " - Choose from a list of options." __AMBER_ARRAY_94[@];
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
read_stdin_options__617_v0() {
    __AMBER_ARRAY_95=();
    local options=("${__AMBER_ARRAY_95[@]}")
    __AMBER_VAL_96=$( [ -t 0 ] && echo "true" || echo "false" );
    __AS=$?;
    local is_tty="${__AMBER_VAL_96}"
    if [ $([ "_${is_tty}" != "_false" ]; echo $?) != 0 ]; then
         while IFS= read -r line || [[ -n "$line" ]]; do options+=("$line"); done ;
        __AS=$?
fi
    __AF_read_stdin_options617_v0=("${options[@]}");
    return 0
}
execute_choose__618_v0() {
    local parameters=("${!1}")
    local cursor="> "
    local header="\e[96;1mChoose:\e[0m"
    read_stdin_options__617_v0 ;
    __AF_read_stdin_options617_v0__18_19=("${__AF_read_stdin_options617_v0[@]}");
    local options=("${__AF_read_stdin_options617_v0__18_19[@]}")
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
            print_choose_help__567_v0 ;
            __AF_print_choose_help567_v0__26_17="$__AF_print_choose_help567_v0";
            echo "$__AF_print_choose_help567_v0__26_17" > /dev/null 2>&1
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
                eprintf_colored__475_v0 "Invalid limit value: ""${result[1]}""
" 31;
                __AF_eprintf_colored475_v0__40_21="$__AF_eprintf_colored475_v0";
                echo "$__AF_eprintf_colored475_v0__40_21" > /dev/null 2>&1
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
                eprintf_colored__475_v0 "Invalid page-size value: ""${result[1]}""
" 31;
                __AF_eprintf_colored475_v0__51_21="$__AF_eprintf_colored475_v0";
                echo "$__AF_eprintf_colored475_v0__51_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__50_29="$__AF_parse_number12_v0";
            page_size="$__AF_parse_number12_v0__50_29"
else
            __AMBER_ARRAY_97=("${param}");
            options+=("${__AMBER_ARRAY_97[@]}")
fi
done
    if [ ${multi} != 0 ]; then
        xyl_multi_choose__519_v0 options[@] "${cursor}" "${header}" ${limit} ${page_size};
        __AF_xyl_multi_choose519_v0__62_23=("${__AF_xyl_multi_choose519_v0[@]}");
        local results=("${__AF_xyl_multi_choose519_v0__62_23[@]}")
        join__6_v0 results[@] "
";
        __AF_join6_v0__63_16="${__AF_join6_v0}";
        __AF_execute_choose618_v0="${__AF_join6_v0__63_16}";
        return 0
fi
    xyl_choose__517_v0 options[@] "${cursor}" "${header}" ${page_size};
    __AF_xyl_choose517_v0__66_12="${__AF_xyl_choose517_v0}";
    __AF_execute_choose618_v0="${__AF_xyl_choose517_v0__66_12}";
    return 0
}
get_key__675_v0() {
    __AMBER_VAL_98=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_98}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key675_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key675_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key675_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key675_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key675_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key675_v0="INPUT";
        return 0
else
        __AF_get_key675_v0="${var}";
        return 0
fi
}
printf_colored__676_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_99=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_99[@];
    __AF_printf99_v0__26_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__26_5" > /dev/null 2>&1
}
eprintf__677_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__678_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_100=("${message}");
    eprintf__677_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_100[@];
    __AF_eprintf677_v0__36_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__36_5" > /dev/null 2>&1
}
colored__679_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored679_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__681_v0() {
    local cnt=$1
     printf '\e[2K\e[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_101=("");
    eprintf__677_v0 "\e[9999D" __AMBER_ARRAY_101[@];
    __AF_eprintf677_v0__52_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__52_5" > /dev/null 2>&1
}
remove_current_line__682_v0() {
    __AMBER_ARRAY_102=("");
    eprintf__677_v0 "\e[2K\e[9999D" __AMBER_ARRAY_102[@];
    __AF_eprintf677_v0__57_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__57_5" > /dev/null 2>&1
}
new_line__684_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_103=("");
        eprintf__677_v0 "
" __AMBER_ARRAY_103[@];
        __AF_eprintf677_v0__69_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__69_9" > /dev/null 2>&1
done
}
go_up__685_v0() {
    local cnt=$1
    __AMBER_ARRAY_104=("");
    eprintf__677_v0 "\e[${cnt}A" __AMBER_ARRAY_104[@];
    __AF_eprintf677_v0__75_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__75_5" > /dev/null 2>&1
}
go_down__686_v0() {
    local cnt=$1
    __AMBER_ARRAY_105=("");
    eprintf__677_v0 "\e[${cnt}B" __AMBER_ARRAY_105[@];
    __AF_eprintf677_v0__80_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__80_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
hide_cursor__688_v0() {
    __AMBER_ARRAY_106=("");
    eprintf__677_v0 "\e[?25l" __AMBER_ARRAY_106[@];
    __AF_eprintf677_v0__93_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__93_5" > /dev/null 2>&1
}
show_cursor__689_v0() {
    __AMBER_ARRAY_107=("");
    eprintf__677_v0 "\e[?25h" __AMBER_ARRAY_107[@];
    __AF_eprintf677_v0__97_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__97_5" > /dev/null 2>&1
}
get_term_size__690_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_108=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_108}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__104_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__104_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_109=(80 24);
        __AF_get_term_size690_v0=("${__AMBER_ARRAY_109[@]}");
        return 0
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_110=(80 24);
        __AF_get_term_size690_v0=("${__AMBER_ARRAY_110[@]}");
        return 0
fi;
    __AF_parse_number12_v0__108_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__108_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_111=(80 24);
        __AF_get_term_size690_v0=("${__AMBER_ARRAY_111[@]}");
        return 0
fi;
    __AF_parse_number12_v0__111_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__111_16"
    __AMBER_ARRAY_112=(${cols} ${rows});
    __AF_get_term_size690_v0=("${__AMBER_ARRAY_112[@]}");
    return 0
}
get_term_width__691_v0() {
    get_term_size__690_v0 ;
    __AF_get_term_size690_v0__119_16=("${__AF_get_term_size690_v0[@]}");
    local size=("${__AF_get_term_size690_v0__119_16[@]}")
    __AF_get_term_width691_v0="${size[0]}";
    return 0
}
truncate_text__693_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo ${max_width} '<' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text693_v0="${text}";
        return 0
fi
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text693_v0="${text}";
        return 0
fi
    __AMBER_VAL_113=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_113}"
    __AF_truncate_text693_v0="${truncated}""...""\e[0m";
    return 0
}
render_tooltip__694_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    local separator=" • "
    local separator_len=3
    # Fast path: no truncation needed
    if [ $(echo ${total_len} '<=' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        local iter=0
        while :
do
            if [ $(echo ${iter} '>=' "${#items[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
elif [ $(echo ${iter} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                eprintf_colored__678_v0 "${separator}" 90;
                __AF_eprintf_colored678_v0__161_27="$__AF_eprintf_colored678_v0";
                echo "$__AF_eprintf_colored678_v0__161_27" > /dev/null 2>&1
fi
            colored__679_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored679_v0__163_41="${__AF_colored679_v0}";
            __AMBER_ARRAY_114=("");
            eprintf__677_v0 "${items[${iter}]}"" ""${__AF_colored679_v0__163_41}" __AMBER_ARRAY_114[@];
            __AF_eprintf677_v0__163_13="$__AF_eprintf677_v0";
            echo "$__AF_eprintf677_v0__163_13" > /dev/null 2>&1
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
else
        # Slow path: truncate
        local current_len=0
        local first=1
        local iter=0
        while :
do
            if [ $(echo ${iter} '>=' "${#items[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
fi
            local key="${items[${iter}]}"
            local action="${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${key}";
            __AMBER_LEN="${action}";
            local part_len=$(echo $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local needed=${part_len}
            if [ $(echo  '!' ${first} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                needed=$(echo ${needed} '+' ${separator_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            if [ $(echo $(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '>' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                break
fi
            if [ $(echo  '!' ${first} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                eprintf_colored__678_v0 "${separator}" 90;
                __AF_eprintf_colored678_v0__189_17="$__AF_eprintf_colored678_v0";
                echo "$__AF_eprintf_colored678_v0__189_17" > /dev/null 2>&1
fi
            colored__679_v0 "${action}" 2;
            __AF_colored679_v0__191_33="${__AF_colored679_v0}";
            __AMBER_ARRAY_115=("");
            eprintf__677_v0 "${key}"" ""${__AF_colored679_v0__191_33}" __AMBER_ARRAY_115[@];
            __AF_eprintf677_v0__191_13="$__AF_eprintf677_v0";
            echo "$__AF_eprintf677_v0__191_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
render_confirm_options__715_v0() {
    local selected=$1
    __AMBER_ARRAY_116=("");
    eprintf__677_v0 " " __AMBER_ARRAY_116[@];
    __AF_eprintf677_v0__6_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__6_5" > /dev/null 2>&1
    if [ ${selected} != 0 ]; then
        # Yes selected (green background)
        __AMBER_ARRAY_117=("");
        eprintf__677_v0 "\e[42;37m    Yes    \e[0m" __AMBER_ARRAY_117[@];
        __AF_eprintf677_v0__9_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__9_9" > /dev/null 2>&1
        __AMBER_ARRAY_118=("");
        eprintf__677_v0 "  " __AMBER_ARRAY_118[@];
        __AF_eprintf677_v0__10_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__10_9" > /dev/null 2>&1
        # No not selected (dim)
        __AMBER_ARRAY_119=("");
        eprintf__677_v0 "\e[49;37m    No    \e[0m" __AMBER_ARRAY_119[@];
        __AF_eprintf677_v0__12_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__12_9" > /dev/null 2>&1
else
        # Yes not selected (dim)
        __AMBER_ARRAY_120=("");
        eprintf__677_v0 "\e[49;37m    Yes    \e[0m" __AMBER_ARRAY_120[@];
        __AF_eprintf677_v0__15_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_121=("");
        eprintf__677_v0 "  " __AMBER_ARRAY_121[@];
        __AF_eprintf677_v0__16_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__16_9" > /dev/null 2>&1
        # No selected (red background)
        __AMBER_ARRAY_122=("");
        eprintf__677_v0 "\e[41;37m    No    \e[0m" __AMBER_ARRAY_122[@];
        __AF_eprintf677_v0__18_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__18_9" > /dev/null 2>&1
fi
}
xyl_confirm__716_v0() {
    local header=$1
    local default_yes=$2
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__688_v0 ;
    __AF_hide_cursor688_v0__35_5="$__AF_hide_cursor688_v0";
    echo "$__AF_hide_cursor688_v0__35_5" > /dev/null 2>&1
    get_term_width__691_v0 ;
    __AF_get_term_width691_v0__37_22="$__AF_get_term_width691_v0";
    local term_width="$__AF_get_term_width691_v0__37_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__693_v0 "${header}" ${term_width};
        __AF_truncate_text693_v0__40_17="${__AF_truncate_text693_v0}";
        __AMBER_ARRAY_123=("");
        eprintf__677_v0 "${__AF_truncate_text693_v0__40_17}""

" __AMBER_ARRAY_123[@];
        __AF_eprintf677_v0__40_9="$__AF_eprintf677_v0";
        echo "$__AF_eprintf677_v0__40_9" > /dev/null 2>&1
else
        new_line__684_v0 1;
        __AF_new_line684_v0__42_9="$__AF_new_line684_v0";
        echo "$__AF_new_line684_v0__42_9" > /dev/null 2>&1
fi
    local selected=${default_yes}
    # Render initial options
    render_confirm_options__715_v0 ${selected};
    __AF_render_confirm_options715_v0__48_5="$__AF_render_confirm_options715_v0";
    echo "$__AF_render_confirm_options715_v0__48_5" > /dev/null 2>&1
    __AMBER_ARRAY_124=("");
    eprintf__677_v0 "

" __AMBER_ARRAY_124[@];
    __AF_eprintf677_v0__50_5="$__AF_eprintf677_v0";
    echo "$__AF_eprintf677_v0__50_5" > /dev/null 2>&1
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    __AMBER_ARRAY_125=("←→" "select" "enter" "confirm" "y" "yes" "n" "no");
    render_tooltip__694_v0 __AMBER_ARRAY_125[@] 40 ${term_width};
    __AF_render_tooltip694_v0__52_5="$__AF_render_tooltip694_v0";
    echo "$__AF_render_tooltip694_v0__52_5" > /dev/null 2>&1
    go_up__685_v0 2;
    __AF_go_up685_v0__53_5="$__AF_go_up685_v0";
    echo "$__AF_go_up685_v0__53_5" > /dev/null 2>&1
    while :
do
        get_key__675_v0 ;
        __AF_get_key675_v0__56_19="${__AF_get_key675_v0}";
        local key="${__AF_get_key675_v0__56_19}"
        if [ $(echo $(echo $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_RIGHT" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ ${selected} != 0 ]; then
                selected=0
                __AMBER_ARRAY_126=("");
                eprintf__677_v0 "\e[9999D\e[K" __AMBER_ARRAY_126[@];
                __AF_eprintf677_v0__63_25="$__AF_eprintf677_v0";
                echo "$__AF_eprintf677_v0__63_25" > /dev/null 2>&1
                render_confirm_options__715_v0 ${selected};
                __AF_render_confirm_options715_v0__64_25="$__AF_render_confirm_options715_v0";
                echo "$__AF_render_confirm_options715_v0__64_25" > /dev/null 2>&1
elif [ $(echo  '!' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=1
                __AMBER_ARRAY_127=("");
                eprintf__677_v0 "\e[9999D\e[K" __AMBER_ARRAY_127[@];
                __AF_eprintf677_v0__68_25="$__AF_eprintf677_v0";
                echo "$__AF_eprintf677_v0__68_25" > /dev/null 2>&1
                render_confirm_options__715_v0 ${selected};
                __AF_render_confirm_options715_v0__69_25="$__AF_render_confirm_options715_v0";
                echo "$__AF_render_confirm_options715_v0__69_25" > /dev/null 2>&1
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
    local total_lines=4
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__686_v0 2;
    __AF_go_down686_v0__94_5="$__AF_go_down686_v0";
    echo "$__AF_go_down686_v0__94_5" > /dev/null 2>&1
    remove_line__681_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line681_v0__95_5="$__AF_remove_line681_v0";
    echo "$__AF_remove_line681_v0__95_5" > /dev/null 2>&1
    remove_current_line__682_v0 ;
    __AF_remove_current_line682_v0__96_5="$__AF_remove_current_line682_v0";
    echo "$__AF_remove_current_line682_v0__96_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__689_v0 ;
    __AF_show_cursor689_v0__99_5="$__AF_show_cursor689_v0";
    echo "$__AF_show_cursor689_v0__99_5" > /dev/null 2>&1
    __AF_xyl_confirm716_v0=${selected};
    return 0
}
print_confirm_help__763_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    printf_colored__676_v0 "confirm" 92;
    __AF_printf_colored676_v0__7_5="$__AF_printf_colored676_v0";
    echo "$__AF_printf_colored676_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_128=("");
    printf__99_v0 " - Display a Yes/No confirmation dialog." __AMBER_ARRAY_128[@];
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
execute_confirm__838_v0() {
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
            print_confirm_help__763_v0 ;
            __AF_print_confirm_help763_v0__14_17="$__AF_print_confirm_help763_v0";
            echo "$__AF_print_confirm_help763_v0__14_17" > /dev/null 2>&1
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
                                    eprintf_colored__678_v0 "Invalid default value: ""${result[1]}"". Use 'yes' or 'no'.
" 31;
                    __AF_eprintf_colored678_v0__27_25="$__AF_eprintf_colored678_v0";
                    echo "$__AF_eprintf_colored678_v0__27_25" > /dev/null 2>&1
                    exit 1
fi
fi
done
    xyl_confirm__716_v0 "${header}" ${default_yes};
    __AF_xyl_confirm716_v0__35_18="$__AF_xyl_confirm716_v0";
    local result="$__AF_xyl_confirm716_v0__35_18"
    __AF_execute_confirm838_v0=$(if [ ${result} != 0 ]; then echo "yes"; else echo "no"; fi);
    return 0
}
# #!/usr/bin/env amber
__0_VERSION="0.1.0"
__1_AMBER_VERSION="0.4.0"
check_prerequirements__840_v0() {
     echo "0" | bc -l > /dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
        eprintf_colored__143_v0 "Error: " 91;
        __AF_eprintf_colored143_v0__14_9="$__AF_eprintf_colored143_v0";
        echo "$__AF_eprintf_colored143_v0__14_9" > /dev/null 2>&1
        __AMBER_ARRAY_129=("");
        eprintf__142_v0 "bc is not installed. Please install bc to use xylitol.
" __AMBER_ARRAY_129[@];
        __AF_eprintf142_v0__15_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_130=("");
        eprintf__142_v0 "  For Debian/Ubuntu: sudo apt install bc
" __AMBER_ARRAY_130[@];
        __AF_eprintf142_v0__16_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__16_9" > /dev/null 2>&1
        __AMBER_ARRAY_131=("");
        eprintf__142_v0 "  For Fedora: sudo dnf install bc
" __AMBER_ARRAY_131[@];
        __AF_eprintf142_v0__17_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_132=("");
        eprintf__142_v0 "  For Arch Linux: sudo pacman -S bc
" __AMBER_ARRAY_132[@];
        __AF_eprintf142_v0__18_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__18_9" > /dev/null 2>&1
        __AF_check_prerequirements840_v0=0;
        return 0
fi
    __AF_check_prerequirements840_v0=1;
    return 0
}
trap_cleanup__841_v0() {
     trap 'printf "\e[?25h\e[0m" >&2; stty echo < /dev/tty' EXIT ;
    __AS=$?
}
declare -r arguments=("$0" "$@")
    trap_cleanup__841_v0 ;
    __AF_trap_cleanup841_v0__29_5="$__AF_trap_cleanup841_v0";
    echo "$__AF_trap_cleanup841_v0__29_5" > /dev/null 2>&1
    check_prerequirements__840_v0 ;
    __AF_check_prerequirements840_v0__30_12="$__AF_check_prerequirements840_v0";
    if [ $(echo  '!' "$__AF_check_prerequirements840_v0__30_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit 1
fi
    if [ $([ "_${arguments[1]}" != "_input" ]; echo $?) != 0 ]; then
                    execute_input__410_v0 arguments[@];
            __AF_execute_input410_v0__33_18="${__AF_execute_input410_v0}";
            echo "${__AF_execute_input410_v0__33_18}"
elif [ $([ "_${arguments[1]}" != "_choose" ]; echo $?) != 0 ]; then
                    execute_choose__618_v0 arguments[@];
            __AF_execute_choose618_v0__36_18="${__AF_execute_choose618_v0}";
            echo "${__AF_execute_choose618_v0__36_18}"
elif [ $([ "_${arguments[1]}" != "_confirm" ]; echo $?) != 0 ]; then
                    execute_confirm__838_v0 arguments[@];
            __AF_execute_confirm838_v0__39_26="${__AF_execute_confirm838_v0}";
            result="${__AF_execute_confirm838_v0__39_26}"
            if [ $([ "_${result}" != "_yes" ]; echo $?) != 0 ]; then
                exit 0
else
                exit 1
fi
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_help" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    print_help__226_v0 ;
            __AF_print_help226_v0__46_13="$__AF_print_help226_v0";
            echo "$__AF_print_help226_v0__46_13" > /dev/null 2>&1
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_version" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--version" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-v" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    __AMBER_ARRAY_133=("");
            printf__99_v0 "xylitol.sh version: " __AMBER_ARRAY_133[@];
            __AF_printf99_v0__50_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__50_13" > /dev/null 2>&1
            printf_colored__141_v0 "${__0_VERSION}" 93;
            __AF_printf_colored141_v0__51_13="$__AF_printf_colored141_v0";
            echo "$__AF_printf_colored141_v0__51_13" > /dev/null 2>&1
            echo ""
            echo ""
            printf_colored__141_v0 "written in " 90;
            __AF_printf_colored141_v0__54_13="$__AF_printf_colored141_v0";
            echo "$__AF_printf_colored141_v0__54_13" > /dev/null 2>&1
            printf_colored__141_v0 "🧡Amber" 33;
            __AF_printf_colored141_v0__55_13="$__AF_printf_colored141_v0";
            echo "$__AF_printf_colored141_v0__55_13" > /dev/null 2>&1
            printf_colored__141_v0 " ""${__1_AMBER_VERSION}" 90;
            __AF_printf_colored141_v0__56_13="$__AF_printf_colored141_v0";
            echo "$__AF_printf_colored141_v0__56_13" > /dev/null 2>&1
else
                    print_help__226_v0 ;
            __AF_print_help226_v0__60_13="$__AF_print_help226_v0";
            echo "$__AF_print_help226_v0__60_13" > /dev/null 2>&1
            printf_colored__141_v0 "Error: " 91;
            __AF_printf_colored141_v0__61_13="$__AF_printf_colored141_v0";
            echo "$__AF_printf_colored141_v0__61_13" > /dev/null 2>&1
            echo "Unknown command '""${arguments[1]}""'"
fi
