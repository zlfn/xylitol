#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-11-26 02:35:09
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
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
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
    __AF_eprintf142_v0__34_5="$__AF_eprintf142_v0";
    echo "$__AF_eprintf142_v0__34_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
print_help__223_v0() {
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
math_floor__252_v0() {
    local number=$1
    __AMBER_VAL_11=$( echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' );
    __AS=$?;
    __AF_math_floor252_v0="${__AMBER_VAL_11}";
    return 0
}
math_ceil__253_v0() {
    local number=$1
    math_floor__252_v0 ${number};
    __AF_math_floor252_v0__26_12="$__AF_math_floor252_v0";
    __AF_math_ceil253_v0=$(echo "$__AF_math_floor252_v0__26_12" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
get_char__289_v0() {
    __AMBER_VAL_12=$( read -n 1 key < /dev/tty; printf "%s" "$key");
    __AS=$?;
    local char="${__AMBER_VAL_12}"
    __AF_get_char289_v0="${char}";
    return 0
}
printf_colored__291_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_13=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_13[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__292_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__293_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_14=("${message}");
    eprintf__292_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_14[@];
    __AF_eprintf292_v0__34_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__34_5" > /dev/null 2>&1
}
colored__294_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored294_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove__295_v0() {
    local cnt=$1
    __AMBER_ARRAY_15=();
    local remove_text=("${__AMBER_ARRAY_15[@]}")
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_16=("\b \b");
        remove_text+=("${__AMBER_ARRAY_16[@]}")
done
    join__6_v0 remove_text[@] "";
    __AF_join6_v0__48_13="${__AF_join6_v0}";
    __AMBER_ARRAY_17=("");
    eprintf__292_v0 "${__AF_join6_v0__48_13}" __AMBER_ARRAY_17[@];
    __AF_eprintf292_v0__48_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__48_5" > /dev/null 2>&1
}
remove_line__296_v0() {
    local cnt=$1
    __AMBER_ARRAY_18=("");
    eprintf__292_v0 "\e[2K" __AMBER_ARRAY_18[@];
    __AF_eprintf292_v0__53_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__53_5" > /dev/null 2>&1
    for i in $(seq 0 $(echo $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_19=("");
        eprintf__292_v0 "\e[A\e[2K" __AMBER_ARRAY_19[@];
        __AF_eprintf292_v0__55_9="$__AF_eprintf292_v0";
        echo "$__AF_eprintf292_v0__55_9" > /dev/null 2>&1
done
    __AMBER_ARRAY_20=("");
    eprintf__292_v0 "\e[9999D" __AMBER_ARRAY_20[@];
    __AF_eprintf292_v0__57_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__57_5" > /dev/null 2>&1
}
new_line__298_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_21=("");
        eprintf__292_v0 "
" __AMBER_ARRAY_21[@];
        __AF_eprintf292_v0__69_9="$__AF_eprintf292_v0";
        echo "$__AF_eprintf292_v0__69_9" > /dev/null 2>&1
done
}
go_up__299_v0() {
    local cnt=$1
    __AMBER_ARRAY_22=("");
    eprintf__292_v0 "\e[${cnt}A" __AMBER_ARRAY_22[@];
    __AF_eprintf292_v0__75_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__75_5" > /dev/null 2>&1
}
go_down__300_v0() {
    local cnt=$1
    __AMBER_ARRAY_23=("");
    eprintf__292_v0 "\e[${cnt}B" __AMBER_ARRAY_23[@];
    __AF_eprintf292_v0__80_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__80_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
get_term_size__304_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_24=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_24}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__104_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__104_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_25=(80 24);
        __AF_get_term_size304_v0=("${__AMBER_ARRAY_25[@]}");
        return 0
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_26=(80 24);
        __AF_get_term_size304_v0=("${__AMBER_ARRAY_26[@]}");
        return 0
fi;
    __AF_parse_number12_v0__108_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__108_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_27=(80 24);
        __AF_get_term_size304_v0=("${__AMBER_ARRAY_27[@]}");
        return 0
fi;
    __AF_parse_number12_v0__111_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__111_16"
    __AMBER_ARRAY_28=(${cols} ${rows});
    __AF_get_term_size304_v0=("${__AMBER_ARRAY_28[@]}");
    return 0
}
get_term_width__305_v0() {
    get_term_size__304_v0 ;
    __AF_get_term_size304_v0__119_16=("${__AF_get_term_size304_v0[@]}");
    local size=("${__AF_get_term_size304_v0__119_16[@]}")
    __AF_get_term_width305_v0="${size[0]}";
    return 0
}
truncate_text__307_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo ${max_width} '<' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text307_v0="${text}";
        return 0
fi
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text307_v0="${text}";
        return 0
fi
    __AMBER_VAL_29=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_29}"
    __AF_truncate_text307_v0="${truncated}""...""\e[0m";
    return 0
}
render_tooltip__308_v0() {
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
                eprintf_colored__293_v0 "${separator}" 90;
                __AF_eprintf_colored293_v0__161_27="$__AF_eprintf_colored293_v0";
                echo "$__AF_eprintf_colored293_v0__161_27" > /dev/null 2>&1
fi
            colored__294_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored294_v0__163_41="${__AF_colored294_v0}";
            __AMBER_ARRAY_30=("");
            eprintf__292_v0 "${items[${iter}]}"" ""${__AF_colored294_v0__163_41}" __AMBER_ARRAY_30[@];
            __AF_eprintf292_v0__163_13="$__AF_eprintf292_v0";
            echo "$__AF_eprintf292_v0__163_13" > /dev/null 2>&1
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
                eprintf_colored__293_v0 "${separator}" 90;
                __AF_eprintf_colored293_v0__189_17="$__AF_eprintf_colored293_v0";
                echo "$__AF_eprintf_colored293_v0__189_17" > /dev/null 2>&1
fi
            colored__294_v0 "${action}" 2;
            __AF_colored294_v0__191_33="${__AF_colored294_v0}";
            __AMBER_ARRAY_31=("");
            eprintf__292_v0 "${key}"" ""${__AF_colored294_v0__191_33}" __AMBER_ARRAY_31[@];
            __AF_eprintf292_v0__191_13="$__AF_eprintf292_v0";
            echo "$__AF_eprintf292_v0__191_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
xyl_input__328_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
    get_term_width__305_v0 ;
    __AF_get_term_width305_v0__18_22="$__AF_get_term_width305_v0";
    local term_width="$__AF_get_term_width305_v0__18_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__307_v0 "${header}" ${term_width};
        __AF_truncate_text307_v0__21_17="${__AF_truncate_text307_v0}";
        __AMBER_ARRAY_32=("");
        eprintf__292_v0 "${__AF_truncate_text307_v0__21_17}""
" __AMBER_ARRAY_32[@];
        __AF_eprintf292_v0__21_9="$__AF_eprintf292_v0";
        echo "$__AF_eprintf292_v0__21_9" > /dev/null 2>&1
fi
    new_line__298_v0 2;
    __AF_new_line298_v0__24_5="$__AF_new_line298_v0";
    echo "$__AF_new_line298_v0__24_5" > /dev/null 2>&1
    # "enter submit" = 12
    __AMBER_ARRAY_33=("enter" "submit");
    render_tooltip__308_v0 __AMBER_ARRAY_33[@] 12 ${term_width};
    __AF_render_tooltip308_v0__26_5="$__AF_render_tooltip308_v0";
    echo "$__AF_render_tooltip308_v0__26_5" > /dev/null 2>&1
    go_up__299_v0 2;
    __AF_go_up299_v0__27_5="$__AF_go_up299_v0";
    echo "$__AF_go_up299_v0__27_5" > /dev/null 2>&1
    __AMBER_ARRAY_34=("");
    eprintf__292_v0 "\e[99999D" __AMBER_ARRAY_34[@];
    __AF_eprintf292_v0__28_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__28_5" > /dev/null 2>&1
    __AMBER_ARRAY_35=("");
    eprintf__292_v0 "${prompt}" __AMBER_ARRAY_35[@];
    __AF_eprintf292_v0__30_5="$__AF_eprintf292_v0";
    echo "$__AF_eprintf292_v0__30_5" > /dev/null 2>&1
    eprintf_colored__293_v0 "${placeholder}" 90;
    __AF_eprintf_colored293_v0__31_5="$__AF_eprintf_colored293_v0";
    echo "$__AF_eprintf_colored293_v0__31_5" > /dev/null 2>&1
     stty -echo < /dev/tty ;
    __AS=$?
    get_char__289_v0 ;
    __AF_get_char289_v0__34_16="${__AF_get_char289_v0}";
    local char="${__AF_get_char289_v0__34_16}"
    __AMBER_LEN="${prompt}";
    remove__295_v0 "${#__AMBER_LEN}";
    __AF_remove295_v0__35_5="$__AF_remove295_v0";
    echo "$__AF_remove295_v0__35_5" > /dev/null 2>&1
    __AMBER_LEN="${placeholder}";
    remove__295_v0 $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove295_v0__36_5="$__AF_remove295_v0";
    echo "$__AF_remove295_v0__36_5" > /dev/null 2>&1
    local text=""
    if [ $(echo  '!' ${password} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_36=$( read -e -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_36}"
else
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_37=$( read -es -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_37}"
fi
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_term_width__305_v0 ;
    __AF_get_term_width305_v0__48_22="$__AF_get_term_width305_v0";
    local term_width="$__AF_get_term_width305_v0__48_22"
    __AMBER_LEN="${prompt}""${text}";
    local input_display_len="${#__AMBER_LEN}"
    math_ceil__253_v0 $(echo ${input_display_len} '/' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_ceil253_v0__50_23="$__AF_math_ceil253_v0";
    local input_lines="$__AF_math_ceil253_v0__50_23"
    if [ $(echo ${input_lines} '<' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        input_lines=1
fi
    local header_line=0
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        header_line=1
fi
    if [ $(echo ${input_lines} '<' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__300_v0 $(echo 3 '-' ${input_lines} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_down300_v0__61_9="$__AF_go_down300_v0";
        echo "$__AF_go_down300_v0__61_9" > /dev/null 2>&1
        remove_line__296_v0 $(echo ${header_line} '+' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_remove_line296_v0__62_9="$__AF_remove_line296_v0";
        echo "$__AF_remove_line296_v0__62_9" > /dev/null 2>&1
fi
    if [ $(echo ${input_lines} '>=' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        remove_line__296_v0 $(echo $(echo ${input_lines} '+' ${header_line} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_remove_line296_v0__65_9="$__AF_remove_line296_v0";
        echo "$__AF_remove_line296_v0__65_9" > /dev/null 2>&1
fi
    __AF_xyl_input328_v0="${text}";
    return 0
}
print_input_help__374_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    printf_colored__291_v0 "input" 92;
    __AF_printf_colored291_v0__7_5="$__AF_printf_colored291_v0";
    echo "$__AF_printf_colored291_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_38=("");
    printf__99_v0 " - Prompt for some input from the user." __AMBER_ARRAY_38[@];
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
execute_input__404_v0() {
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
            print_input_help__374_v0 ;
            __AF_print_input_help374_v0__13_13="$__AF_print_input_help374_v0";
            echo "$__AF_print_input_help374_v0__13_13" > /dev/null 2>&1
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
    xyl_input__328_v0 "${prompt}" "${placeholder}" "${header}" ${password};
    __AF_xyl_input328_v0__33_12="${__AF_xyl_input328_v0}";
    __AF_execute_input404_v0="${__AF_xyl_input328_v0__33_12}";
    return 0
}
get_key__466_v0() {
    __AMBER_VAL_39=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_39}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key466_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key466_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key466_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key466_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key466_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key466_v0="INPUT";
        return 0
else
        __AF_get_key466_v0="${var}";
        return 0
fi
}
printf_colored__467_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_40=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_40[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__468_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__469_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_41=("${message}");
    eprintf__468_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_41[@];
    __AF_eprintf468_v0__34_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__34_5" > /dev/null 2>&1
}
colored__470_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored470_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__472_v0() {
    local cnt=$1
    __AMBER_ARRAY_42=("");
    eprintf__468_v0 "\e[2K" __AMBER_ARRAY_42[@];
    __AF_eprintf468_v0__53_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__53_5" > /dev/null 2>&1
    for i in $(seq 0 $(echo $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_43=("");
        eprintf__468_v0 "\e[A\e[2K" __AMBER_ARRAY_43[@];
        __AF_eprintf468_v0__55_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__55_9" > /dev/null 2>&1
done
    __AMBER_ARRAY_44=("");
    eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_44[@];
    __AF_eprintf468_v0__57_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__57_5" > /dev/null 2>&1
}
print_blank__473_v0() {
    local cnt=$1
    # Prints blank spaces.
    for _ in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_45=("");
        eprintf__468_v0 " " __AMBER_ARRAY_45[@];
        __AF_eprintf468_v0__63_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__63_9" > /dev/null 2>&1
done
}
new_line__474_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_46=("");
        eprintf__468_v0 "
" __AMBER_ARRAY_46[@];
        __AF_eprintf468_v0__69_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__69_9" > /dev/null 2>&1
done
}
go_up__475_v0() {
    local cnt=$1
    __AMBER_ARRAY_47=("");
    eprintf__468_v0 "\e[${cnt}A" __AMBER_ARRAY_47[@];
    __AF_eprintf468_v0__75_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__75_5" > /dev/null 2>&1
}
go_down__476_v0() {
    local cnt=$1
    __AMBER_ARRAY_48=("");
    eprintf__468_v0 "\e[${cnt}B" __AMBER_ARRAY_48[@];
    __AF_eprintf468_v0__80_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__80_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
go_up_or_down__477_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__476_v0 ${cnt};
        __AF_go_down476_v0__86_9="$__AF_go_down476_v0";
        echo "$__AF_go_down476_v0__86_9" > /dev/null 2>&1
else
        go_up__475_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up475_v0__88_9="$__AF_go_up475_v0";
        echo "$__AF_go_up475_v0__88_9" > /dev/null 2>&1
fi
}
hide_cursor__478_v0() {
    __AMBER_ARRAY_49=("");
    eprintf__468_v0 "\e[?25l" __AMBER_ARRAY_49[@];
    __AF_eprintf468_v0__93_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__93_5" > /dev/null 2>&1
}
show_cursor__479_v0() {
    __AMBER_ARRAY_50=("");
    eprintf__468_v0 "\e[?25h" __AMBER_ARRAY_50[@];
    __AF_eprintf468_v0__97_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__97_5" > /dev/null 2>&1
}
get_term_size__480_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_51=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_51}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__104_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__104_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_52=(80 24);
        __AF_get_term_size480_v0=("${__AMBER_ARRAY_52[@]}");
        return 0
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_53=(80 24);
        __AF_get_term_size480_v0=("${__AMBER_ARRAY_53[@]}");
        return 0
fi;
    __AF_parse_number12_v0__108_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__108_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_54=(80 24);
        __AF_get_term_size480_v0=("${__AMBER_ARRAY_54[@]}");
        return 0
fi;
    __AF_parse_number12_v0__111_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__111_16"
    __AMBER_ARRAY_55=(${cols} ${rows});
    __AF_get_term_size480_v0=("${__AMBER_ARRAY_55[@]}");
    return 0
}
get_term_width__481_v0() {
    get_term_size__480_v0 ;
    __AF_get_term_size480_v0__119_16=("${__AF_get_term_size480_v0[@]}");
    local size=("${__AF_get_term_size480_v0__119_16[@]}")
    __AF_get_term_width481_v0="${size[0]}";
    return 0
}
get_term_height__482_v0() {
    get_term_size__480_v0 ;
    __AF_get_term_size480_v0__125_16=("${__AF_get_term_size480_v0[@]}");
    local size=("${__AF_get_term_size480_v0__125_16[@]}")
    __AF_get_term_height482_v0="${size[1]}";
    return 0
}
truncate_text__483_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo ${max_width} '<' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text483_v0="${text}";
        return 0
fi
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text483_v0="${text}";
        return 0
fi
    __AMBER_VAL_56=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_56}"
    __AF_truncate_text483_v0="${truncated}""...""\e[0m";
    return 0
}
render_tooltip__484_v0() {
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
                eprintf_colored__469_v0 "${separator}" 90;
                __AF_eprintf_colored469_v0__161_27="$__AF_eprintf_colored469_v0";
                echo "$__AF_eprintf_colored469_v0__161_27" > /dev/null 2>&1
fi
            colored__470_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored470_v0__163_41="${__AF_colored470_v0}";
            __AMBER_ARRAY_57=("");
            eprintf__468_v0 "${items[${iter}]}"" ""${__AF_colored470_v0__163_41}" __AMBER_ARRAY_57[@];
            __AF_eprintf468_v0__163_13="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__163_13" > /dev/null 2>&1
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
                eprintf_colored__469_v0 "${separator}" 90;
                __AF_eprintf_colored469_v0__189_17="$__AF_eprintf_colored469_v0";
                echo "$__AF_eprintf_colored469_v0__189_17" > /dev/null 2>&1
fi
            colored__470_v0 "${action}" 2;
            __AF_colored470_v0__191_33="${__AF_colored470_v0}";
            __AMBER_ARRAY_58=("");
            eprintf__468_v0 "${key}"" ""${__AF_colored470_v0__191_33}" __AMBER_ARRAY_58[@];
            __AF_eprintf468_v0__191_13="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__191_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
get_page_options__504_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    local start=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local end=$(echo ${start} '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${end} '>' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        end="${#options[@]}"
fi
    __AMBER_ARRAY_59=();
    local result=("${__AMBER_ARRAY_59[@]}")
    for i in $(seq ${start} $(echo ${end} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_60=("${options[${i}]}");
        result+=("${__AMBER_ARRAY_60[@]}")
done
    __AF_get_page_options504_v0=("${result[@]}");
    return 0
}
get_page_start__505_v0() {
    local page=$1
    local page_size=$2
    __AF_get_page_start505_v0=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
render_choose_page__506_v0() {
    local options=("${!1}")
    local page=$2
    local sel=$3
    local cursor=$4
    local page_size=$5
    local display_count=$6
    local term_width=$7
    get_page_options__504_v0 options[@] ${page} ${page_size};
    __AF_get_page_options504_v0__23_24=("${__AF_get_page_options504_v0[@]}");
    local page_options=("${__AF_get_page_options504_v0__23_24[@]}")
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local max_option_width=$(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        truncate_text__483_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_truncate_text483_v0__27_32="${__AF_truncate_text483_v0}";
        local truncated_option="${__AF_truncate_text483_v0__27_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__469_v0 "${cursor}""${truncated_option}""
" 32;
            __AF_eprintf_colored469_v0__29_13="$__AF_eprintf_colored469_v0";
            echo "$__AF_eprintf_colored469_v0__29_13" > /dev/null 2>&1
else
            print_blank__473_v0 ${cursor_len};
            __AF_print_blank473_v0__31_13="$__AF_print_blank473_v0";
            echo "$__AF_print_blank473_v0__31_13" > /dev/null 2>&1
            __AMBER_ARRAY_61=("");
            eprintf__468_v0 "${truncated_option}""
" __AMBER_ARRAY_61[@];
            __AF_eprintf468_v0__32_13="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__32_13" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug gaurd
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_62=("");
            eprintf__468_v0 "\e[K
" __AMBER_ARRAY_62[@];
            __AF_eprintf468_v0__38_13="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__38_13" > /dev/null 2>&1
done
fi
}
render_multi_choose_page__507_v0() {
    local options=("${!1}")
    local checked=("${!2}")
    local page=$3
    local sel=$4
    local cursor=$5
    local page_size=$6
    local display_count=$7
    local term_width=$8
    get_page_options__504_v0 options[@] ${page} ${page_size};
    __AF_get_page_options504_v0__44_24=("${__AF_get_page_options504_v0[@]}");
    local page_options=("${__AF_get_page_options504_v0__44_24[@]}")
    get_page_start__505_v0 ${page} ${page_size};
    __AF_get_page_start505_v0__45_17="$__AF_get_page_start505_v0";
    local start="$__AF_get_page_start505_v0__45_17"
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local check_mark_len=2
    # "✓ " or "• "
    local max_option_width=$(echo $(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' ${check_mark_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local global_idx=$(echo ${start} '+' ${i} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        local check_mark=$(if [ "${checked[${global_idx}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
        truncate_text__483_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_truncate_text483_v0__52_32="${__AF_truncate_text483_v0}";
        local truncated_option="${__AF_truncate_text483_v0__52_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__469_v0 "${cursor}""${check_mark}""${truncated_option}""
" 32;
            __AF_eprintf_colored469_v0__54_23="$__AF_eprintf_colored469_v0";
            echo "$__AF_eprintf_colored469_v0__54_23" > /dev/null 2>&1
elif [ "${checked[${global_idx}]}" != 0 ]; then
                            print_blank__473_v0 ${cursor_len};
                __AF_print_blank473_v0__56_17="$__AF_print_blank473_v0";
                echo "$__AF_print_blank473_v0__56_17" > /dev/null 2>&1
                eprintf_colored__469_v0 "${check_mark}""${truncated_option}""
" 32;
                __AF_eprintf_colored469_v0__57_17="$__AF_eprintf_colored469_v0";
                echo "$__AF_eprintf_colored469_v0__57_17" > /dev/null 2>&1
else
                            print_blank__473_v0 ${cursor_len};
                __AF_print_blank473_v0__60_17="$__AF_print_blank473_v0";
                echo "$__AF_print_blank473_v0__60_17" > /dev/null 2>&1
                __AMBER_ARRAY_63=("");
                eprintf__468_v0 "${check_mark}""${truncated_option}""
" __AMBER_ARRAY_63[@];
                __AF_eprintf468_v0__61_17="$__AF_eprintf468_v0";
                echo "$__AF_eprintf468_v0__61_17" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug guard
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_64=("");
            eprintf__468_v0 "\e[K
" __AMBER_ARRAY_64[@];
            __AF_eprintf468_v0__68_13="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__68_13" > /dev/null 2>&1
done
fi
}
render_page_indicator__508_v0() {
    local page=$1
    local total_pages=$2
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_65=("");
        eprintf__468_v0 "\e[9999D\e[K" __AMBER_ARRAY_65[@];
        __AF_eprintf468_v0__75_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__75_9" > /dev/null 2>&1
        eprintf_colored__469_v0 "Page $(echo ${page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored469_v0__76_9="$__AF_eprintf_colored469_v0";
        echo "$__AF_eprintf_colored469_v0__76_9" > /dev/null 2>&1
        __AMBER_ARRAY_66=("");
        eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_66[@];
        __AF_eprintf468_v0__77_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__77_9" > /dev/null 2>&1
fi
}
xyl_choose__509_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__469_v0 "No options provided.
" 31;
        __AF_eprintf_colored469_v0__95_9="$__AF_eprintf_colored469_v0";
        echo "$__AF_eprintf_colored469_v0__95_9" > /dev/null 2>&1
        exit 1
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__478_v0 ;
    __AF_hide_cursor478_v0__100_5="$__AF_hide_cursor478_v0";
    echo "$__AF_hide_cursor478_v0__100_5" > /dev/null 2>&1
    get_term_width__481_v0 ;
    __AF_get_term_width481_v0__102_22="$__AF_get_term_width481_v0";
    local term_width="$__AF_get_term_width481_v0__102_22"
    get_term_height__482_v0 ;
    __AF_get_term_height482_v0__103_23="$__AF_get_term_height482_v0";
    local term_height="$__AF_get_term_height482_v0__103_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__483_v0 "${header}" ${term_width};
        __AF_truncate_text483_v0__110_17="${__AF_truncate_text483_v0}";
        __AMBER_ARRAY_67=("");
        eprintf__468_v0 "${__AF_truncate_text483_v0__110_17}""
" __AMBER_ARRAY_67[@];
        __AF_eprintf468_v0__110_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__110_9" > /dev/null 2>&1
fi
    math_floor__252_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor252_v0__113_23="$__AF_math_floor252_v0";
    local total_pages="$__AF_math_floor252_v0__113_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__474_v0 ${display_count};
    __AF_new_line474_v0__122_5="$__AF_new_line474_v0";
    echo "$__AF_new_line474_v0__122_5" > /dev/null 2>&1
    __AMBER_ARRAY_68=("");
    eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_68[@];
    __AF_eprintf468_v0__123_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__123_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__469_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored469_v0__125_9="$__AF_eprintf_colored469_v0";
        echo "$__AF_eprintf_colored469_v0__125_9" > /dev/null 2>&1
fi
    new_line__474_v0 1;
    __AF_new_line474_v0__127_5="$__AF_new_line474_v0";
    echo "$__AF_new_line474_v0__127_5" > /dev/null 2>&1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_69=("↑↓" "select" "←→" "page" "enter" "confirm");
        render_tooltip__484_v0 __AMBER_ARRAY_69[@] 36 ${term_width};
        __AF_render_tooltip484_v0__132_9="$__AF_render_tooltip484_v0";
        echo "$__AF_render_tooltip484_v0__132_9" > /dev/null 2>&1
else
        __AMBER_ARRAY_70=("↑↓" "select" "enter" "confirm");
        render_tooltip__484_v0 __AMBER_ARRAY_70[@] 25 ${term_width};
        __AF_render_tooltip484_v0__134_9="$__AF_render_tooltip484_v0";
        echo "$__AF_render_tooltip484_v0__134_9" > /dev/null 2>&1
fi
    go_up__475_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up475_v0__136_5="$__AF_go_up475_v0";
    echo "$__AF_go_up475_v0__136_5" > /dev/null 2>&1
    __AMBER_ARRAY_71=("");
    eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_71[@];
    __AF_eprintf468_v0__137_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__137_5" > /dev/null 2>&1
    render_choose_page__506_v0 options[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
    __AF_render_choose_page506_v0__139_5="$__AF_render_choose_page506_v0";
    echo "$__AF_render_choose_page506_v0__139_5" > /dev/null 2>&1
    while :
do
        get_key__466_v0 ;
        __AF_get_key466_v0__142_19="${__AF_get_key466_v0}";
        local key="${__AF_get_key466_v0__142_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        get_page_options__504_v0 options[@] ${current_page} ${page_size};
        __AF_get_page_options504_v0__146_28=("${__AF_get_page_options504_v0[@]}");
        local page_options=("${__AF_get_page_options504_v0__146_28[@]}")
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__504_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options504_v0__153_48=("${__AF_get_page_options504_v0[@]}");
                    local new_page_options=("${__AF_get_page_options504_v0__153_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__504_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options504_v0__157_48=("${__AF_get_page_options504_v0[@]}");
                    local new_page_options=("${__AF_get_page_options504_v0__157_48[@]}")
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
            go_up__475_v0 1;
            __AF_go_up475_v0__202_17="$__AF_go_up475_v0";
            echo "$__AF_go_up475_v0__202_17" > /dev/null 2>&1
            remove_line__472_v0 ${display_count};
            __AF_remove_line472_v0__203_17="$__AF_remove_line472_v0";
            echo "$__AF_remove_line472_v0__203_17" > /dev/null 2>&1
            __AMBER_ARRAY_72=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_72[@];
            __AF_eprintf468_v0__204_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__204_17" > /dev/null 2>&1
            render_choose_page__506_v0 options[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
            __AF_render_choose_page506_v0__205_17="$__AF_render_choose_page506_v0";
            echo "$__AF_render_choose_page506_v0__205_17" > /dev/null 2>&1
            render_page_indicator__508_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator508_v0__206_17="$__AF_render_page_indicator508_v0";
            echo "$__AF_render_page_indicator508_v0__206_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__475_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up475_v0__209_17="$__AF_go_up475_v0";
            echo "$__AF_go_up475_v0__209_17" > /dev/null 2>&1
            __AMBER_ARRAY_73=("");
            eprintf__468_v0 "\e[K" __AMBER_ARRAY_73[@];
            __AF_eprintf468_v0__210_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__210_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__473_v0 "${#__AMBER_LEN}";
            __AF_print_blank473_v0__211_17="$__AF_print_blank473_v0";
            echo "$__AF_print_blank473_v0__211_17" > /dev/null 2>&1
            truncate_text__483_v0 "${page_options[${prev_selected}]}" ${max_option_width};
            __AF_truncate_text483_v0__212_25="${__AF_truncate_text483_v0}";
            __AMBER_ARRAY_74=("");
            eprintf__468_v0 "${__AF_truncate_text483_v0__212_25}" __AMBER_ARRAY_74[@];
            __AF_eprintf468_v0__212_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__212_17" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__477_v0 ${diff};
            __AF_go_up_or_down477_v0__215_17="$__AF_go_up_or_down477_v0";
            echo "$__AF_go_up_or_down477_v0__215_17" > /dev/null 2>&1
            __AMBER_ARRAY_75=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_75[@];
            __AF_eprintf468_v0__216_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__216_17" > /dev/null 2>&1
            __AMBER_ARRAY_76=("");
            eprintf__468_v0 "\e[K" __AMBER_ARRAY_76[@];
            __AF_eprintf468_v0__217_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__217_17" > /dev/null 2>&1
            get_page_options__504_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options504_v0__218_44=("${__AF_get_page_options504_v0[@]}");
            local current_page_options=("${__AF_get_page_options504_v0__218_44[@]}")
            truncate_text__483_v0 "${current_page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text483_v0__219_42="${__AF_truncate_text483_v0}";
            eprintf_colored__469_v0 "${cursor}""${__AF_truncate_text483_v0__219_42}" 32;
            __AF_eprintf_colored469_v0__219_17="$__AF_eprintf_colored469_v0";
            echo "$__AF_eprintf_colored469_v0__219_17" > /dev/null 2>&1
            go_down__476_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down476_v0__221_17="$__AF_go_down476_v0";
            echo "$__AF_go_down476_v0__221_17" > /dev/null 2>&1
            __AMBER_ARRAY_77=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_77[@];
            __AF_eprintf468_v0__222_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__222_17" > /dev/null 2>&1
fi
done
    local info_lines=1
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        info_lines=$(echo ${info_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__476_v0 ${info_lines};
    __AF_go_down476_v0__236_5="$__AF_go_down476_v0";
    echo "$__AF_go_down476_v0__236_5" > /dev/null 2>&1
    remove_line__472_v0 ${total_lines};
    __AF_remove_line472_v0__237_5="$__AF_remove_line472_v0";
    echo "$__AF_remove_line472_v0__237_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__479_v0 ;
    __AF_show_cursor479_v0__240_5="$__AF_show_cursor479_v0";
    echo "$__AF_show_cursor479_v0__240_5" > /dev/null 2>&1
    local global_selected=$(echo $(echo ${current_page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_xyl_choose509_v0="${options[${global_selected}]}";
    return 0
}
count_checked__510_v0() {
    local checked=("${!1}")
    local count=0
    for c in "${checked[@]}"; do
        if [ ${c} != 0 ]; then
            count=$(echo ${count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
done
    __AF_count_checked510_v0=${count};
    return 0
}
xyl_multi_choose__511_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__469_v0 "No options provided.
" 31;
        __AF_eprintf_colored469_v0__271_9="$__AF_eprintf_colored469_v0";
        echo "$__AF_eprintf_colored469_v0__271_9" > /dev/null 2>&1
        __AMBER_ARRAY_78=();
        __AF_xyl_multi_choose511_v0=("${__AMBER_ARRAY_78[@]}");
        return 0
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__478_v0 ;
    __AF_hide_cursor478_v0__276_5="$__AF_hide_cursor478_v0";
    echo "$__AF_hide_cursor478_v0__276_5" > /dev/null 2>&1
    get_term_width__481_v0 ;
    __AF_get_term_width481_v0__278_22="$__AF_get_term_width481_v0";
    local term_width="$__AF_get_term_width481_v0__278_22"
    get_term_height__482_v0 ;
    __AF_get_term_height482_v0__279_23="$__AF_get_term_height482_v0";
    local term_height="$__AF_get_term_height482_v0__279_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__483_v0 "${header}" ${term_width};
        __AF_truncate_text483_v0__286_17="${__AF_truncate_text483_v0}";
        __AMBER_ARRAY_79=("");
        eprintf__468_v0 "${__AF_truncate_text483_v0__286_17}""
" __AMBER_ARRAY_79[@];
        __AF_eprintf468_v0__286_9="$__AF_eprintf468_v0";
        echo "$__AF_eprintf468_v0__286_9" > /dev/null 2>&1
fi
    math_floor__252_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor252_v0__289_23="$__AF_math_floor252_v0";
    local total_pages="$__AF_math_floor252_v0__289_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__474_v0 ${display_count};
    __AF_new_line474_v0__298_5="$__AF_new_line474_v0";
    echo "$__AF_new_line474_v0__298_5" > /dev/null 2>&1
    __AMBER_ARRAY_80=("");
    eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_80[@];
    __AF_eprintf468_v0__299_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__299_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__469_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored469_v0__301_9="$__AF_eprintf_colored469_v0";
        echo "$__AF_eprintf_colored469_v0__301_9" > /dev/null 2>&1
fi
    new_line__474_v0 1;
    __AF_new_line474_v0__303_5="$__AF_new_line474_v0";
    echo "$__AF_new_line474_v0__303_5" > /dev/null 2>&1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ $(echo $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_81=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm");
        render_tooltip__484_v0 __AMBER_ARRAY_81[@] 55 ${term_width};
        __AF_render_tooltip484_v0__310_40="$__AF_render_tooltip484_v0";
        echo "$__AF_render_tooltip484_v0__310_40" > /dev/null 2>&1
elif [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_82=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm");
        render_tooltip__484_v0 __AMBER_ARRAY_82[@] 47 ${term_width};
        __AF_render_tooltip484_v0__311_26="$__AF_render_tooltip484_v0";
        echo "$__AF_render_tooltip484_v0__311_26" > /dev/null 2>&1
elif [ $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_83=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm");
        render_tooltip__484_v0 __AMBER_ARRAY_83[@] 44 ${term_width};
        __AF_render_tooltip484_v0__312_20="$__AF_render_tooltip484_v0";
        echo "$__AF_render_tooltip484_v0__312_20" > /dev/null 2>&1
else
        __AMBER_ARRAY_84=("↑↓" "select" "x" "toggle" "enter" "confirm");
        render_tooltip__484_v0 __AMBER_ARRAY_84[@] 36 ${term_width};
        __AF_render_tooltip484_v0__313_15="$__AF_render_tooltip484_v0";
        echo "$__AF_render_tooltip484_v0__313_15" > /dev/null 2>&1
fi
    go_up__475_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up475_v0__315_5="$__AF_go_up475_v0";
    echo "$__AF_go_up475_v0__315_5" > /dev/null 2>&1
    __AMBER_ARRAY_85=("");
    eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_85[@];
    __AF_eprintf468_v0__316_5="$__AF_eprintf468_v0";
    echo "$__AF_eprintf468_v0__316_5" > /dev/null 2>&1
    __AMBER_ARRAY_86=();
    local checked=("${__AMBER_ARRAY_86[@]}")
    for _ in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_87=(0);
        checked+=("${__AMBER_ARRAY_87[@]}")
done
    render_multi_choose_page__507_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
    __AF_render_multi_choose_page507_v0__323_5="$__AF_render_multi_choose_page507_v0";
    echo "$__AF_render_multi_choose_page507_v0__323_5" > /dev/null 2>&1
    while :
do
        get_key__466_v0 ;
        __AF_get_key466_v0__326_19="${__AF_get_key466_v0}";
        local key="${__AF_get_key466_v0__326_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        get_page_options__504_v0 options[@] ${current_page} ${page_size};
        __AF_get_page_options504_v0__330_28=("${__AF_get_page_options504_v0[@]}");
        local page_options=("${__AF_get_page_options504_v0__330_28[@]}")
        get_page_start__505_v0 ${current_page} ${page_size};
        __AF_get_page_start505_v0__331_31="$__AF_get_page_start505_v0";
        local global_selected=$(echo "$__AF_get_page_start505_v0__331_31" '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__504_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options504_v0__338_48=("${__AF_get_page_options504_v0[@]}");
                    local new_page_options=("${__AF_get_page_options504_v0__338_48[@]}")
                    selected=$(echo "${#new_page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                    get_page_options__504_v0 options[@] ${current_page} ${page_size};
                    __AF_get_page_options504_v0__342_48=("${__AF_get_page_options504_v0[@]}");
                    local new_page_options=("${__AF_get_page_options504_v0__342_48[@]}")
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
            count_checked__510_v0 checked[@];
            __AF_count_checked510_v0__383_34="$__AF_count_checked510_v0";
            if [ "${checked[${global_selected}]}" != 0 ]; then
                checked[${global_selected}]=0
elif [ $(echo $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $(echo "$__AF_count_checked510_v0__383_34" '<' ${limit} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                checked[${global_selected}]=1
else
                continue
fi
            __AMBER_LEN="${cursor}";
            local max_option_width=$(echo $(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            # 2 for check mark
            go_up__475_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up475_v0__389_17="$__AF_go_up475_v0";
            echo "$__AF_go_up475_v0__389_17" > /dev/null 2>&1
            __AMBER_ARRAY_88=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_88[@];
            __AF_eprintf468_v0__390_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__390_17" > /dev/null 2>&1
            __AMBER_ARRAY_89=("");
            eprintf__468_v0 "\e[K" __AMBER_ARRAY_89[@];
            __AF_eprintf468_v0__391_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__391_17" > /dev/null 2>&1
            local check_mark=$(if [ "${checked[${global_selected}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            get_page_options__504_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options504_v0__393_44=("${__AF_get_page_options504_v0[@]}");
            local current_page_options=("${__AF_get_page_options504_v0__393_44[@]}")
            truncate_text__483_v0 "${current_page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text483_v0__394_55="${__AF_truncate_text483_v0}";
            eprintf_colored__469_v0 "${cursor}""${check_mark}""${__AF_truncate_text483_v0__394_55}" 32;
            __AF_eprintf_colored469_v0__394_17="$__AF_eprintf_colored469_v0";
            echo "$__AF_eprintf_colored469_v0__394_17" > /dev/null 2>&1
            go_down__476_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down476_v0__395_17="$__AF_go_down476_v0";
            echo "$__AF_go_down476_v0__395_17" > /dev/null 2>&1
            __AMBER_ARRAY_90=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_90[@];
            __AF_eprintf468_v0__396_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__396_17" > /dev/null 2>&1
            continue
elif [ $(echo $(echo $([ "_${key}" != "_a" ]; echo $?) '||' $([ "_${key}" != "_A" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            count_checked__510_v0 checked[@];
            __AF_count_checked510_v0__400_35="$__AF_count_checked510_v0";
            local all_checked=$(echo "$__AF_count_checked510_v0__400_35" '==' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            for i in $(seq 0 $(echo "${#checked[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
                checked[${i}]=$(echo  '!' ${all_checked} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
            go_up__475_v0 ${display_count};
            __AF_go_up475_v0__404_17="$__AF_go_up475_v0";
            echo "$__AF_go_up475_v0__404_17" > /dev/null 2>&1
            __AMBER_ARRAY_91=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_91[@];
            __AF_eprintf468_v0__405_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__405_17" > /dev/null 2>&1
            render_multi_choose_page__507_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
            __AF_render_multi_choose_page507_v0__406_17="$__AF_render_multi_choose_page507_v0";
            echo "$__AF_render_multi_choose_page507_v0__406_17" > /dev/null 2>&1
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
            go_up__475_v0 1;
            __AF_go_up475_v0__418_17="$__AF_go_up475_v0";
            echo "$__AF_go_up475_v0__418_17" > /dev/null 2>&1
            remove_line__472_v0 ${display_count};
            __AF_remove_line472_v0__419_17="$__AF_remove_line472_v0";
            echo "$__AF_remove_line472_v0__419_17" > /dev/null 2>&1
            __AMBER_ARRAY_92=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_92[@];
            __AF_eprintf468_v0__420_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__420_17" > /dev/null 2>&1
            render_multi_choose_page__507_v0 options[@] checked[@] ${current_page} ${selected} "${cursor}" ${page_size} ${display_count} ${term_width};
            __AF_render_multi_choose_page507_v0__421_17="$__AF_render_multi_choose_page507_v0";
            echo "$__AF_render_multi_choose_page507_v0__421_17" > /dev/null 2>&1
            render_page_indicator__508_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator508_v0__422_17="$__AF_render_page_indicator508_v0";
            echo "$__AF_render_page_indicator508_v0__422_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            get_page_start__505_v0 ${current_page} ${page_size};
            __AF_get_page_start505_v0__425_29="$__AF_get_page_start505_v0";
            local start="$__AF_get_page_start505_v0__425_29"
            local prev_global=$(echo ${start} '+' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up__475_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up475_v0__427_17="$__AF_go_up475_v0";
            echo "$__AF_go_up475_v0__427_17" > /dev/null 2>&1
            __AMBER_ARRAY_93=("");
            eprintf__468_v0 "\e[K" __AMBER_ARRAY_93[@];
            __AF_eprintf468_v0__428_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__428_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__473_v0 "${#__AMBER_LEN}";
            __AF_print_blank473_v0__429_17="$__AF_print_blank473_v0";
            echo "$__AF_print_blank473_v0__429_17" > /dev/null 2>&1
            local prev_check_mark=$(if [ "${checked[${prev_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            if [ "${checked[${prev_global}]}" != 0 ]; then
                truncate_text__483_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_truncate_text483_v0__432_44="${__AF_truncate_text483_v0}";
                eprintf_colored__469_v0 "✓ ""${__AF_truncate_text483_v0__432_44}" 32;
                __AF_eprintf_colored469_v0__432_21="$__AF_eprintf_colored469_v0";
                echo "$__AF_eprintf_colored469_v0__432_21" > /dev/null 2>&1
else
                truncate_text__483_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_truncate_text483_v0__434_36="${__AF_truncate_text483_v0}";
                __AMBER_ARRAY_94=("");
                eprintf__468_v0 "• ""${__AF_truncate_text483_v0__434_36}" __AMBER_ARRAY_94[@];
                __AF_eprintf468_v0__434_21="$__AF_eprintf468_v0";
                echo "$__AF_eprintf468_v0__434_21" > /dev/null 2>&1
fi
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__477_v0 ${diff};
            __AF_go_up_or_down477_v0__438_17="$__AF_go_up_or_down477_v0";
            echo "$__AF_go_up_or_down477_v0__438_17" > /dev/null 2>&1
            __AMBER_ARRAY_95=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_95[@];
            __AF_eprintf468_v0__439_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__439_17" > /dev/null 2>&1
            __AMBER_ARRAY_96=("");
            eprintf__468_v0 "\e[K" __AMBER_ARRAY_96[@];
            __AF_eprintf468_v0__440_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__440_17" > /dev/null 2>&1
            local new_global=$(echo ${start} '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local check_mark=$(if [ "${checked[${new_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            get_page_options__504_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options504_v0__443_44=("${__AF_get_page_options504_v0[@]}");
            local current_page_options=("${__AF_get_page_options504_v0__443_44[@]}")
            truncate_text__483_v0 "${current_page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text483_v0__444_55="${__AF_truncate_text483_v0}";
            eprintf_colored__469_v0 "${cursor}""${check_mark}""${__AF_truncate_text483_v0__444_55}" 32;
            __AF_eprintf_colored469_v0__444_17="$__AF_eprintf_colored469_v0";
            echo "$__AF_eprintf_colored469_v0__444_17" > /dev/null 2>&1
            go_down__476_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down476_v0__446_17="$__AF_go_down476_v0";
            echo "$__AF_go_down476_v0__446_17" > /dev/null 2>&1
            __AMBER_ARRAY_97=("");
            eprintf__468_v0 "\e[9999D" __AMBER_ARRAY_97[@];
            __AF_eprintf468_v0__447_17="$__AF_eprintf468_v0";
            echo "$__AF_eprintf468_v0__447_17" > /dev/null 2>&1
fi
done
    local info_lines=1
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        info_lines=$(echo ${info_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__476_v0 ${info_lines};
    __AF_go_down476_v0__461_5="$__AF_go_down476_v0";
    echo "$__AF_go_down476_v0__461_5" > /dev/null 2>&1
    remove_line__472_v0 ${total_lines};
    __AF_remove_line472_v0__462_5="$__AF_remove_line472_v0";
    echo "$__AF_remove_line472_v0__462_5" > /dev/null 2>&1
    __AMBER_ARRAY_98=();
    local result=("${__AMBER_ARRAY_98[@]}")
    for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ "${checked[${i}]}" != 0 ]; then
            __AMBER_ARRAY_99=("${options[${i}]}");
            result+=("${__AMBER_ARRAY_99[@]}")
fi
done
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__479_v0 ;
    __AF_show_cursor479_v0__472_5="$__AF_show_cursor479_v0";
    echo "$__AF_show_cursor479_v0__472_5" > /dev/null 2>&1
    __AF_xyl_multi_choose511_v0=("${result[@]}");
    return 0
}
print_choose_help__558_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    printf_colored__467_v0 "choose" 92;
    __AF_printf_colored467_v0__7_5="$__AF_printf_colored467_v0";
    echo "$__AF_printf_colored467_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_100=("");
    printf__99_v0 " - Choose from a list of options." __AMBER_ARRAY_100[@];
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
read_stdin_options__607_v0() {
    __AMBER_ARRAY_101=();
    local options=("${__AMBER_ARRAY_101[@]}")
    __AMBER_VAL_102=$( [ -t 0 ] && echo "true" || echo "false" );
    __AS=$?;
    local is_tty="${__AMBER_VAL_102}"
    if [ $([ "_${is_tty}" != "_false" ]; echo $?) != 0 ]; then
         while IFS= read -r line || [[ -n "$line" ]]; do options+=("$line"); done ;
        __AS=$?
fi
    __AF_read_stdin_options607_v0=("${options[@]}");
    return 0
}
execute_choose__608_v0() {
    local parameters=("${!1}")
    local cursor="> "
    local header="\e[96;1mChoose:\e[0m"
    read_stdin_options__607_v0 ;
    __AF_read_stdin_options607_v0__18_19=("${__AF_read_stdin_options607_v0[@]}");
    local options=("${__AF_read_stdin_options607_v0__18_19[@]}")
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
            print_choose_help__558_v0 ;
            __AF_print_choose_help558_v0__26_17="$__AF_print_choose_help558_v0";
            echo "$__AF_print_choose_help558_v0__26_17" > /dev/null 2>&1
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
                eprintf_colored__469_v0 "Invalid limit value: ""${result[1]}""
" 31;
                __AF_eprintf_colored469_v0__40_21="$__AF_eprintf_colored469_v0";
                echo "$__AF_eprintf_colored469_v0__40_21" > /dev/null 2>&1
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
                eprintf_colored__469_v0 "Invalid page-size value: ""${result[1]}""
" 31;
                __AF_eprintf_colored469_v0__51_21="$__AF_eprintf_colored469_v0";
                echo "$__AF_eprintf_colored469_v0__51_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__50_29="$__AF_parse_number12_v0";
            page_size="$__AF_parse_number12_v0__50_29"
else
            __AMBER_ARRAY_103=("${param}");
            options+=("${__AMBER_ARRAY_103[@]}")
fi
done
    if [ ${multi} != 0 ]; then
        xyl_multi_choose__511_v0 options[@] "${cursor}" "${header}" ${limit} ${page_size};
        __AF_xyl_multi_choose511_v0__62_23=("${__AF_xyl_multi_choose511_v0[@]}");
        local results=("${__AF_xyl_multi_choose511_v0__62_23[@]}")
        join__6_v0 results[@] "
";
        __AF_join6_v0__63_16="${__AF_join6_v0}";
        __AF_execute_choose608_v0="${__AF_join6_v0__63_16}";
        return 0
fi
    xyl_choose__509_v0 options[@] "${cursor}" "${header}" ${page_size};
    __AF_xyl_choose509_v0__66_12="${__AF_xyl_choose509_v0}";
    __AF_execute_choose608_v0="${__AF_xyl_choose509_v0__66_12}";
    return 0
}
get_key__665_v0() {
    __AMBER_VAL_104=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_104}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key665_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key665_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key665_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key665_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key665_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key665_v0="INPUT";
        return 0
else
        __AF_get_key665_v0="${var}";
        return 0
fi
}
printf_colored__666_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_105=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_105[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
}
eprintf__667_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__668_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_106=("${message}");
    eprintf__667_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_106[@];
    __AF_eprintf667_v0__34_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__34_5" > /dev/null 2>&1
}
colored__669_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored669_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__671_v0() {
    local cnt=$1
    __AMBER_ARRAY_107=("");
    eprintf__667_v0 "\e[2K" __AMBER_ARRAY_107[@];
    __AF_eprintf667_v0__53_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__53_5" > /dev/null 2>&1
    for i in $(seq 0 $(echo $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_108=("");
        eprintf__667_v0 "\e[A\e[2K" __AMBER_ARRAY_108[@];
        __AF_eprintf667_v0__55_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__55_9" > /dev/null 2>&1
done
    __AMBER_ARRAY_109=("");
    eprintf__667_v0 "\e[9999D" __AMBER_ARRAY_109[@];
    __AF_eprintf667_v0__57_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__57_5" > /dev/null 2>&1
}
go_up__674_v0() {
    local cnt=$1
    __AMBER_ARRAY_110=("");
    eprintf__667_v0 "\e[${cnt}A" __AMBER_ARRAY_110[@];
    __AF_eprintf667_v0__75_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__75_5" > /dev/null 2>&1
}
go_down__675_v0() {
    local cnt=$1
    __AMBER_ARRAY_111=("");
    eprintf__667_v0 "\e[${cnt}B" __AMBER_ARRAY_111[@];
    __AF_eprintf667_v0__80_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__80_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
hide_cursor__677_v0() {
    __AMBER_ARRAY_112=("");
    eprintf__667_v0 "\e[?25l" __AMBER_ARRAY_112[@];
    __AF_eprintf667_v0__93_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__93_5" > /dev/null 2>&1
}
show_cursor__678_v0() {
    __AMBER_ARRAY_113=("");
    eprintf__667_v0 "\e[?25h" __AMBER_ARRAY_113[@];
    __AF_eprintf667_v0__97_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__97_5" > /dev/null 2>&1
}
get_term_size__679_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_114=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_114}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__104_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__104_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_115=(80 24);
        __AF_get_term_size679_v0=("${__AMBER_ARRAY_115[@]}");
        return 0
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_116=(80 24);
        __AF_get_term_size679_v0=("${__AMBER_ARRAY_116[@]}");
        return 0
fi;
    __AF_parse_number12_v0__108_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__108_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AMBER_ARRAY_117=(80 24);
        __AF_get_term_size679_v0=("${__AMBER_ARRAY_117[@]}");
        return 0
fi;
    __AF_parse_number12_v0__111_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__111_16"
    __AMBER_ARRAY_118=(${cols} ${rows});
    __AF_get_term_size679_v0=("${__AMBER_ARRAY_118[@]}");
    return 0
}
get_term_width__680_v0() {
    get_term_size__679_v0 ;
    __AF_get_term_size679_v0__119_16=("${__AF_get_term_size679_v0[@]}");
    local size=("${__AF_get_term_size679_v0__119_16[@]}")
    __AF_get_term_width680_v0="${size[0]}";
    return 0
}
truncate_text__682_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo ${max_width} '<' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text682_v0="${text}";
        return 0
fi
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text682_v0="${text}";
        return 0
fi
    __AMBER_VAL_119=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_119}"
    __AF_truncate_text682_v0="${truncated}""...""\e[0m";
    return 0
}
render_tooltip__683_v0() {
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
                eprintf_colored__668_v0 "${separator}" 90;
                __AF_eprintf_colored668_v0__161_27="$__AF_eprintf_colored668_v0";
                echo "$__AF_eprintf_colored668_v0__161_27" > /dev/null 2>&1
fi
            colored__669_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored669_v0__163_41="${__AF_colored669_v0}";
            __AMBER_ARRAY_120=("");
            eprintf__667_v0 "${items[${iter}]}"" ""${__AF_colored669_v0__163_41}" __AMBER_ARRAY_120[@];
            __AF_eprintf667_v0__163_13="$__AF_eprintf667_v0";
            echo "$__AF_eprintf667_v0__163_13" > /dev/null 2>&1
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
                eprintf_colored__668_v0 "${separator}" 90;
                __AF_eprintf_colored668_v0__189_17="$__AF_eprintf_colored668_v0";
                echo "$__AF_eprintf_colored668_v0__189_17" > /dev/null 2>&1
fi
            colored__669_v0 "${action}" 2;
            __AF_colored669_v0__191_33="${__AF_colored669_v0}";
            __AMBER_ARRAY_121=("");
            eprintf__667_v0 "${key}"" ""${__AF_colored669_v0__191_33}" __AMBER_ARRAY_121[@];
            __AF_eprintf667_v0__191_13="$__AF_eprintf667_v0";
            echo "$__AF_eprintf667_v0__191_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
render_confirm_options__703_v0() {
    local selected=$1
    __AMBER_ARRAY_122=("");
    eprintf__667_v0 " " __AMBER_ARRAY_122[@];
    __AF_eprintf667_v0__6_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__6_5" > /dev/null 2>&1
    if [ ${selected} != 0 ]; then
        # Yes selected (green background)
        __AMBER_ARRAY_123=("");
        eprintf__667_v0 "\e[42;37m    Yes    \e[0m" __AMBER_ARRAY_123[@];
        __AF_eprintf667_v0__9_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__9_9" > /dev/null 2>&1
        __AMBER_ARRAY_124=("");
        eprintf__667_v0 "  " __AMBER_ARRAY_124[@];
        __AF_eprintf667_v0__10_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__10_9" > /dev/null 2>&1
        # No not selected (dim)
        __AMBER_ARRAY_125=("");
        eprintf__667_v0 "\e[49;37m    No    \e[0m" __AMBER_ARRAY_125[@];
        __AF_eprintf667_v0__12_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__12_9" > /dev/null 2>&1
else
        # Yes not selected (dim)
        __AMBER_ARRAY_126=("");
        eprintf__667_v0 "\e[49;37m    Yes    \e[0m" __AMBER_ARRAY_126[@];
        __AF_eprintf667_v0__15_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_127=("");
        eprintf__667_v0 "  " __AMBER_ARRAY_127[@];
        __AF_eprintf667_v0__16_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__16_9" > /dev/null 2>&1
        # No selected (red background)
        __AMBER_ARRAY_128=("");
        eprintf__667_v0 "\e[41;37m    No    \e[0m" __AMBER_ARRAY_128[@];
        __AF_eprintf667_v0__18_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__18_9" > /dev/null 2>&1
fi
}
xyl_confirm__704_v0() {
    local header=$1
    local default_yes=$2
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__677_v0 ;
    __AF_hide_cursor677_v0__35_5="$__AF_hide_cursor677_v0";
    echo "$__AF_hide_cursor677_v0__35_5" > /dev/null 2>&1
    get_term_width__680_v0 ;
    __AF_get_term_width680_v0__37_22="$__AF_get_term_width680_v0";
    local term_width="$__AF_get_term_width680_v0__37_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__682_v0 "${header}" ${term_width};
        __AF_truncate_text682_v0__40_17="${__AF_truncate_text682_v0}";
        __AMBER_ARRAY_129=("");
        eprintf__667_v0 "${__AF_truncate_text682_v0__40_17}""

" __AMBER_ARRAY_129[@];
        __AF_eprintf667_v0__40_9="$__AF_eprintf667_v0";
        echo "$__AF_eprintf667_v0__40_9" > /dev/null 2>&1
fi
    local selected=${default_yes}
    # Render initial options
    render_confirm_options__703_v0 ${selected};
    __AF_render_confirm_options703_v0__46_5="$__AF_render_confirm_options703_v0";
    echo "$__AF_render_confirm_options703_v0__46_5" > /dev/null 2>&1
    __AMBER_ARRAY_130=("");
    eprintf__667_v0 "

" __AMBER_ARRAY_130[@];
    __AF_eprintf667_v0__48_5="$__AF_eprintf667_v0";
    echo "$__AF_eprintf667_v0__48_5" > /dev/null 2>&1
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    __AMBER_ARRAY_131=("←→" "select" "enter" "confirm" "y" "yes" "n" "no");
    render_tooltip__683_v0 __AMBER_ARRAY_131[@] 40 ${term_width};
    __AF_render_tooltip683_v0__50_5="$__AF_render_tooltip683_v0";
    echo "$__AF_render_tooltip683_v0__50_5" > /dev/null 2>&1
    go_up__674_v0 2;
    __AF_go_up674_v0__51_5="$__AF_go_up674_v0";
    echo "$__AF_go_up674_v0__51_5" > /dev/null 2>&1
    while :
do
        get_key__665_v0 ;
        __AF_get_key665_v0__54_19="${__AF_get_key665_v0}";
        local key="${__AF_get_key665_v0__54_19}"
        if [ $(echo $(echo $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_RIGHT" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ ${selected} != 0 ]; then
                selected=0
                __AMBER_ARRAY_132=("");
                eprintf__667_v0 "\e[9999D\e[K" __AMBER_ARRAY_132[@];
                __AF_eprintf667_v0__61_25="$__AF_eprintf667_v0";
                echo "$__AF_eprintf667_v0__61_25" > /dev/null 2>&1
                render_confirm_options__703_v0 ${selected};
                __AF_render_confirm_options703_v0__62_25="$__AF_render_confirm_options703_v0";
                echo "$__AF_render_confirm_options703_v0__62_25" > /dev/null 2>&1
elif [ $(echo  '!' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=1
                __AMBER_ARRAY_133=("");
                eprintf__667_v0 "\e[9999D\e[K" __AMBER_ARRAY_133[@];
                __AF_eprintf667_v0__66_25="$__AF_eprintf667_v0";
                echo "$__AF_eprintf667_v0__66_25" > /dev/null 2>&1
                render_confirm_options__703_v0 ${selected};
                __AF_render_confirm_options703_v0__67_25="$__AF_render_confirm_options703_v0";
                echo "$__AF_render_confirm_options703_v0__67_25" > /dev/null 2>&1
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
    go_down__675_v0 2;
    __AF_go_down675_v0__92_5="$__AF_go_down675_v0";
    echo "$__AF_go_down675_v0__92_5" > /dev/null 2>&1
    remove_line__671_v0 ${total_lines};
    __AF_remove_line671_v0__93_5="$__AF_remove_line671_v0";
    echo "$__AF_remove_line671_v0__93_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__678_v0 ;
    __AF_show_cursor678_v0__96_5="$__AF_show_cursor678_v0";
    echo "$__AF_show_cursor678_v0__96_5" > /dev/null 2>&1
    __AF_xyl_confirm704_v0=${selected};
    return 0
}
print_confirm_help__750_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    printf_colored__666_v0 "confirm" 92;
    __AF_printf_colored666_v0__7_5="$__AF_printf_colored666_v0";
    echo "$__AF_printf_colored666_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_134=("");
    printf__99_v0 " - Display a Yes/No confirmation dialog." __AMBER_ARRAY_134[@];
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
execute_confirm__824_v0() {
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
            print_confirm_help__750_v0 ;
            __AF_print_confirm_help750_v0__14_17="$__AF_print_confirm_help750_v0";
            echo "$__AF_print_confirm_help750_v0__14_17" > /dev/null 2>&1
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
                                    eprintf_colored__668_v0 "Invalid default value: ""${result[1]}"". Use 'yes' or 'no'.
" 31;
                    __AF_eprintf_colored668_v0__27_25="$__AF_eprintf_colored668_v0";
                    echo "$__AF_eprintf_colored668_v0__27_25" > /dev/null 2>&1
                    exit 1
fi
fi
done
    xyl_confirm__704_v0 "${header}" ${default_yes};
    __AF_xyl_confirm704_v0__35_18="$__AF_xyl_confirm704_v0";
    local result="$__AF_xyl_confirm704_v0__35_18"
    __AF_execute_confirm824_v0=$(if [ ${result} != 0 ]; then echo "yes"; else echo "no"; fi);
    return 0
}
# #!/usr/bin/env amber
__0_VERSION="0.1.0"
__1_AMBER_VERSION="0.4.0"
check_prerequirements__826_v0() {
     echo "0" | bc -l > /dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
        eprintf_colored__143_v0 "Error: " 91;
        __AF_eprintf_colored143_v0__14_9="$__AF_eprintf_colored143_v0";
        echo "$__AF_eprintf_colored143_v0__14_9" > /dev/null 2>&1
        __AMBER_ARRAY_135=("");
        eprintf__142_v0 "bc is not installed. Please install bc to use xylitol.
" __AMBER_ARRAY_135[@];
        __AF_eprintf142_v0__15_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_136=("");
        eprintf__142_v0 "  For Debian/Ubuntu: sudo apt install bc
" __AMBER_ARRAY_136[@];
        __AF_eprintf142_v0__16_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__16_9" > /dev/null 2>&1
        __AMBER_ARRAY_137=("");
        eprintf__142_v0 "  For Fedora: sudo dnf install bc
" __AMBER_ARRAY_137[@];
        __AF_eprintf142_v0__17_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_138=("");
        eprintf__142_v0 "  For Arch Linux: sudo pacman -S bc
" __AMBER_ARRAY_138[@];
        __AF_eprintf142_v0__18_9="$__AF_eprintf142_v0";
        echo "$__AF_eprintf142_v0__18_9" > /dev/null 2>&1
        __AF_check_prerequirements826_v0=0;
        return 0
fi
    __AF_check_prerequirements826_v0=1;
    return 0
}
trap_cleanup__827_v0() {
     trap 'printf "\e[?25h\e[0m" >&2; stty echo < /dev/tty' EXIT ;
    __AS=$?
}
declare -r arguments=("$0" "$@")
    trap_cleanup__827_v0 ;
    __AF_trap_cleanup827_v0__29_5="$__AF_trap_cleanup827_v0";
    echo "$__AF_trap_cleanup827_v0__29_5" > /dev/null 2>&1
    check_prerequirements__826_v0 ;
    __AF_check_prerequirements826_v0__30_12="$__AF_check_prerequirements826_v0";
    if [ $(echo  '!' "$__AF_check_prerequirements826_v0__30_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit 1
fi
    if [ $([ "_${arguments[1]}" != "_input" ]; echo $?) != 0 ]; then
                    execute_input__404_v0 arguments[@];
            __AF_execute_input404_v0__33_18="${__AF_execute_input404_v0}";
            echo "${__AF_execute_input404_v0__33_18}"
elif [ $([ "_${arguments[1]}" != "_choose" ]; echo $?) != 0 ]; then
                    execute_choose__608_v0 arguments[@];
            __AF_execute_choose608_v0__36_18="${__AF_execute_choose608_v0}";
            echo "${__AF_execute_choose608_v0__36_18}"
elif [ $([ "_${arguments[1]}" != "_confirm" ]; echo $?) != 0 ]; then
                    execute_confirm__824_v0 arguments[@];
            __AF_execute_confirm824_v0__39_26="${__AF_execute_confirm824_v0}";
            result="${__AF_execute_confirm824_v0__39_26}"
            if [ $([ "_${result}" != "_yes" ]; echo $?) != 0 ]; then
                exit 0
else
                exit 1
fi
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_help" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    print_help__223_v0 ;
            __AF_print_help223_v0__46_13="$__AF_print_help223_v0";
            echo "$__AF_print_help223_v0__46_13" > /dev/null 2>&1
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_version" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--version" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-v" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    __AMBER_ARRAY_139=("");
            printf__99_v0 "xylitol.sh version: " __AMBER_ARRAY_139[@];
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
                    print_help__223_v0 ;
            __AF_print_help223_v0__60_13="$__AF_print_help223_v0";
            echo "$__AF_print_help223_v0__60_13" > /dev/null 2>&1
            printf_colored__141_v0 "Error: " 91;
            __AF_printf_colored141_v0__61_13="$__AF_printf_colored141_v0";
            echo "$__AF_printf_colored141_v0__61_13" > /dev/null 2>&1
            echo "Unknown command '""${arguments[1]}""'"
fi
