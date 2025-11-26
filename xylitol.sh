#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-11-27 03:19:41
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

env_const_get__89_v0() {
    local name=$1
    __AMBER_VAL_4=$( echo ${!name} );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_env_const_get89_v0=''
return $__AS
fi;
    __AF_env_const_get89_v0="${__AMBER_VAL_4}";
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
    __AMBER_ARRAY_5=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m
" __AMBER_ARRAY_5[@];
    __AF_printf99_v0__142_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__142_5" > /dev/null 2>&1
}
printf_colored__142_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_6=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_6[@];
    __AF_printf99_v0__34_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__34_5" > /dev/null 2>&1
}
eprintf__143_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__144_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_7=("${message}");
    eprintf__143_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_7[@];
    __AF_eprintf143_v0__44_5="$__AF_eprintf143_v0";
    echo "$__AF_eprintf143_v0__44_5" > /dev/null 2>&1
}
colored__145_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored145_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
# move the cursor up or down `cnt` lines.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__0__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__1__got_xylitol_colors=0
__AMBER_ARRAY_8=(3 207 159 92);
__2__primary_color=("${__AMBER_ARRAY_8[@]}")
__AMBER_ARRAY_9=(3 118 206 95);
__3__secondary_color=("${__AMBER_ARRAY_9[@]}")
__AMBER_ARRAY_10=(234 72 121 94);
__4__accent_color=("${__AMBER_ARRAY_10[@]}")
get_supports_truecolor__181_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __0__supports_truecolor="No"
        __AF_get_supports_truecolor181_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __0__supports_truecolor="No"
        __AF_get_supports_truecolor181_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __0__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor181_v0=$([ "_${__0__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__182_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__0__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb182_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
            return 0
elif [ $([ "_${__0__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__181_v0 ;
            __AF_get_supports_truecolor181_v0__50_17="$__AF_get_supports_truecolor181_v0";
            if [ "$__AF_get_supports_truecolor181_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb182_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb182_v0="${message}";
                return 0
else
                __AF_colored_rgb182_v0="\e[${fallback}m""${message}""\e[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb182_v0="${message}";
            return 0
fi
        __AF_colored_rgb182_v0="\e[${fallback}m""${message}""\e[0m";
        return 0
fi
}
inner_get_xylitol_colors__184_v0() {
    if [ $(echo  '!' ${__1__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_const_get__89_v0 "XYLITOL_PRIMARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__110_27="${__AF_env_const_get89_v0}";
        local primary_env="${__AF_env_const_get89_v0__110_27}"
        if [ $([ "_${primary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${primary_env}" ";";
            __AF_split3_v0__112_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__112_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_11=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __2__primary_color=("${__AMBER_ARRAY_11[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_SECONDARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__123_29="${__AF_env_const_get89_v0}";
        local secondary_env="${__AF_env_const_get89_v0__123_29}"
        if [ $([ "_${secondary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${secondary_env}" ";";
            __AF_split3_v0__125_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__125_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_12=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __3__secondary_color=("${__AMBER_ARRAY_12[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_ACCENT_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__136_26="${__AF_env_const_get89_v0}";
        local accent_env="${__AF_env_const_get89_v0__136_26}"
        if [ $([ "_${accent_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${accent_env}" ";";
            __AF_split3_v0__138_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__138_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors184_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_13=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __4__accent_color=("${__AMBER_ARRAY_13[@]}")
fi
fi
        __1__got_xylitol_colors=1
fi
}
get_xylitol_colors__185_v0() {
    inner_get_xylitol_colors__184_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors184_v0__154_5="$__AF_inner_get_xylitol_colors184_v0";
    echo "$__AF_inner_get_xylitol_colors184_v0__154_5" > /dev/null 2>&1
    __1__got_xylitol_colors=1
}
colored_primary__186_v0() {
    local message=$1
    if [ $(echo  '!' ${__1__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__185_v0 ;
        __AF_get_xylitol_colors185_v0__162_9="$__AF_get_xylitol_colors185_v0";
        echo "$__AF_get_xylitol_colors185_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__182_v0 "${message}" "${__2__primary_color[0]}" "${__2__primary_color[1]}" "${__2__primary_color[2]}" "${__2__primary_color[3]}";
    __AF_colored_rgb182_v0__164_12="${__AF_colored_rgb182_v0}";
    __AF_colored_primary186_v0="${__AF_colored_rgb182_v0__164_12}";
    return 0
}
colored_secondary__187_v0() {
    local message=$1
    if [ $(echo  '!' ${__1__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__185_v0 ;
        __AF_get_xylitol_colors185_v0__169_9="$__AF_get_xylitol_colors185_v0";
        echo "$__AF_get_xylitol_colors185_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__182_v0 "${message}" "${__3__secondary_color[0]}" "${__3__secondary_color[1]}" "${__3__secondary_color[2]}" "${__3__secondary_color[3]}";
    __AF_colored_rgb182_v0__171_12="${__AF_colored_rgb182_v0}";
    __AF_colored_secondary187_v0="${__AF_colored_rgb182_v0__171_12}";
    return 0
}
colored_accent__188_v0() {
    local message=$1
    if [ $(echo  '!' ${__1__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__185_v0 ;
        __AF_get_xylitol_colors185_v0__176_9="$__AF_get_xylitol_colors185_v0";
        echo "$__AF_get_xylitol_colors185_v0__176_9" > /dev/null 2>&1
fi
    colored_rgb__182_v0 "${message}" "${__4__accent_color[0]}" "${__4__accent_color[1]}" "${__4__accent_color[2]}" "${__4__accent_color[3]}";
    __AF_colored_rgb182_v0__178_12="${__AF_colored_rgb182_v0}";
    __AF_colored_accent188_v0="${__AF_colored_rgb182_v0__178_12}";
    return 0
}
print_help__255_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    colored_primary__186_v0 "Xylitol";
    __AF_colored_primary186_v0__8_22="${__AF_colored_primary186_v0}";
    __AMBER_ARRAY_14=("");
    printf__99_v0 "\e[1m""${__AF_colored_primary186_v0__8_22}" __AMBER_ARRAY_14[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    __AMBER_ARRAY_15=("");
    printf__99_v0 " - A tool for " __AMBER_ARRAY_15[@];
    __AF_printf99_v0__9_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__9_5" > /dev/null 2>&1
    colored_primary__186_v0 "fresh";
    __AF_colored_primary186_v0__10_12="${__AF_colored_primary186_v0}";
    __AMBER_ARRAY_16=("");
    printf__99_v0 "${__AF_colored_primary186_v0__10_12}" __AMBER_ARRAY_16[@];
    __AF_printf99_v0__10_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__10_5" > /dev/null 2>&1
    __AMBER_ARRAY_17=("");
    printf__99_v0 " shell scripts." __AMBER_ARRAY_17[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__187_v0 "Flags: ";
    __AF_colored_secondary187_v0__14_12="${__AF_colored_secondary187_v0}";
    __AMBER_ARRAY_18=("");
    printf__99_v0 "${__AF_colored_secondary187_v0__14_12}""
" __AMBER_ARRAY_18[@];
    __AF_printf99_v0__14_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__14_5" > /dev/null 2>&1
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    echo ""
    colored_secondary__187_v0 "Commands: ";
    __AF_colored_secondary187_v0__18_12="${__AF_colored_secondary187_v0}";
    __AMBER_ARRAY_19=("");
    printf__99_v0 "${__AF_colored_secondary187_v0__18_12}""
" __AMBER_ARRAY_19[@];
    __AF_printf99_v0__18_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__18_5" > /dev/null 2>&1
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo ""
    colored_secondary__187_v0 "Envs: ";
    __AF_colored_secondary187_v0__23_12="${__AF_colored_secondary187_v0}";
    __AMBER_ARRAY_20=("");
    printf__99_v0 "${__AF_colored_secondary187_v0__23_12}""
" __AMBER_ARRAY_20[@];
    __AF_printf99_v0__23_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__23_5" > /dev/null 2>&1
    colored__145_v0 "(\"Yes\" or \"No\", default: Yes)" 90;
    __AF_colored145_v0__24_78="${__AF_colored145_v0}";
    __AMBER_ARRAY_21=("");
    printf__99_v0 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${__AF_colored145_v0__24_78}""
" __AMBER_ARRAY_21[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
    colored__145_v0 "(default: 3;207;159;92)" 90;
    __AF_colored145_v0__25_68="${__AF_colored145_v0}";
    __AMBER_ARRAY_22=("");
    printf__99_v0 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${__AF_colored145_v0__25_68}""
" __AMBER_ARRAY_22[@];
    __AF_printf99_v0__25_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__25_5" > /dev/null 2>&1
    colored__145_v0 "(default: 3;118;206;95)" 90;
    __AF_colored145_v0__26_70="${__AF_colored145_v0}";
    __AMBER_ARRAY_23=("");
    printf__99_v0 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${__AF_colored145_v0__26_70}""
" __AMBER_ARRAY_23[@];
    __AF_printf99_v0__26_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__26_5" > /dev/null 2>&1
    colored__145_v0 "(default: 234;72;121;94)" 90;
    __AF_colored145_v0__27_67="${__AF_colored145_v0}";
    __AMBER_ARRAY_24=("");
    printf__99_v0 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${__AF_colored145_v0__27_67}""
" __AMBER_ARRAY_24[@];
    __AF_printf99_v0__27_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__27_5" > /dev/null 2>&1
    echo ""
    colored_accent__188_v0 "./xylitol.sh <command> --help";
    __AF_colored_accent188_v0__29_21="${__AF_colored_accent188_v0}";
    __AMBER_ARRAY_25=("");
    printf__99_v0 "Run ""${__AF_colored_accent188_v0__29_21}"" for more information on a command.
" __AMBER_ARRAY_25[@];
    __AF_printf99_v0__29_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__29_5" > /dev/null 2>&1
}
math_floor__284_v0() {
    local number=$1
    __AMBER_VAL_26=$( echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' );
    __AS=$?;
    __AF_math_floor284_v0="${__AMBER_VAL_26}";
    return 0
}
math_ceil__285_v0() {
    local number=$1
    math_floor__284_v0 ${number};
    __AF_math_floor284_v0__26_12="$__AF_math_floor284_v0";
    __AF_math_ceil285_v0=$(echo "$__AF_math_floor284_v0__26_12" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
has_ansi_escape__321_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27)
    __AMBER_VAL_27=$( [[ "${text}" == *$'\e'* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_27}"
    __AF_has_ansi_escape321_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
get_char__322_v0() {
    __AMBER_VAL_28=$( read -n 1 key < /dev/tty; printf "%s" "$key" );
    __AS=$?;
    local char="${__AMBER_VAL_28}"
    __AF_get_char322_v0="${char}";
    return 0
}
eprintf__325_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__326_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_29=("${message}");
    eprintf__325_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_29[@];
    __AF_eprintf325_v0__44_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__44_5" > /dev/null 2>&1
}
colored__327_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored327_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove__328_v0() {
    local cnt=$1
     printf '%0.s\b \b' $(seq 1 ${cnt}) >&2 ;
    __AS=$?
}
remove_line__329_v0() {
    local cnt=$1
     printf '\e[2K\e[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_30=("");
    eprintf__325_v0 "\e[9999D" __AMBER_ARRAY_30[@];
    __AF_eprintf325_v0__60_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__60_5" > /dev/null 2>&1
}
remove_current_line__330_v0() {
    __AMBER_ARRAY_31=("");
    eprintf__325_v0 "\e[2K\e[9999D" __AMBER_ARRAY_31[@];
    __AF_eprintf325_v0__65_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__65_5" > /dev/null 2>&1
}
new_line__332_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_32=("");
        eprintf__325_v0 "
" __AMBER_ARRAY_32[@];
        __AF_eprintf325_v0__77_9="$__AF_eprintf325_v0";
        echo "$__AF_eprintf325_v0__77_9" > /dev/null 2>&1
done
}
go_up__333_v0() {
    local cnt=$1
    __AMBER_ARRAY_33=("");
    eprintf__325_v0 "\e[${cnt}A" __AMBER_ARRAY_33[@];
    __AF_eprintf325_v0__83_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__83_5" > /dev/null 2>&1
}
go_down__334_v0() {
    local cnt=$1
    __AMBER_ARRAY_34=("");
    eprintf__325_v0 "\e[${cnt}B" __AMBER_ARRAY_34[@];
    __AF_eprintf325_v0__88_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__88_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
truncate_text__338_v0() {
    local text=$1
    local max_width=$2
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text338_v0="${text}";
        return 0
fi
    __AMBER_VAL_35=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_35}"
    __AF_truncate_text338_v0="${truncated}""...";
    return 0
}
render_tooltip__339_v0() {
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
                eprintf_colored__326_v0 "${separator}" 90;
                __AF_eprintf_colored326_v0__136_27="$__AF_eprintf_colored326_v0";
                echo "$__AF_eprintf_colored326_v0__136_27" > /dev/null 2>&1
fi
            colored__327_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored327_v0__138_41="${__AF_colored327_v0}";
            __AMBER_ARRAY_36=("");
            eprintf__325_v0 "${items[${iter}]}"" ""${__AF_colored327_v0__138_41}" __AMBER_ARRAY_36[@];
            __AF_eprintf325_v0__138_13="$__AF_eprintf325_v0";
            echo "$__AF_eprintf325_v0__138_13" > /dev/null 2>&1
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
                eprintf_colored__326_v0 "${separator}" 90;
                __AF_eprintf_colored326_v0__164_17="$__AF_eprintf_colored326_v0";
                echo "$__AF_eprintf_colored326_v0__164_17" > /dev/null 2>&1
fi
            colored__327_v0 "${action}" 2;
            __AF_colored327_v0__166_33="${__AF_colored327_v0}";
            __AMBER_ARRAY_37=("");
            eprintf__325_v0 "${key}"" ""${__AF_colored327_v0__166_33}" __AMBER_ARRAY_37[@];
            __AF_eprintf325_v0__166_13="$__AF_eprintf325_v0";
            echo "$__AF_eprintf325_v0__166_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__5__got_term_size=0
__AMBER_ARRAY_38=(80 24);
__6__term_size=("${__AMBER_ARRAY_38[@]}")
get_term_size__361_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_39=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_39}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size361_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size361_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size361_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_40=(${cols} ${rows});
    __6__term_size=("${__AMBER_ARRAY_40[@]}")
    __5__got_term_size=1
}
term_width__363_v0() {
    if [ $(echo  '!' ${__5__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__361_v0 ;
        __AS=$?;
        __AF_get_term_size361_v0__33_15="$__AF_get_term_size361_v0";
        echo "$__AF_get_term_size361_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width363_v0="${__6__term_size[0]}";
    return 0
}
xyl_input__368_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
     stty -echo < /dev/tty ;
    __AS=$?
    term_width__363_v0 ;
    __AF_term_width363_v0__21_22="$__AF_term_width363_v0";
    local term_width="$__AF_term_width363_v0__21_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__338_v0 "${header}" ${term_width};
        __AF_truncate_text338_v0__24_17="${__AF_truncate_text338_v0}";
        __AMBER_ARRAY_41=("");
        eprintf__325_v0 "${__AF_truncate_text338_v0__24_17}""
" __AMBER_ARRAY_41[@];
        __AF_eprintf325_v0__24_9="$__AF_eprintf325_v0";
        echo "$__AF_eprintf325_v0__24_9" > /dev/null 2>&1
fi
    new_line__332_v0 2;
    __AF_new_line332_v0__27_5="$__AF_new_line332_v0";
    echo "$__AF_new_line332_v0__27_5" > /dev/null 2>&1
    # "enter submit" = 12
    __AMBER_ARRAY_42=("enter" "submit");
    render_tooltip__339_v0 __AMBER_ARRAY_42[@] 12 ${term_width};
    __AF_render_tooltip339_v0__29_5="$__AF_render_tooltip339_v0";
    echo "$__AF_render_tooltip339_v0__29_5" > /dev/null 2>&1
    go_up__333_v0 2;
    __AF_go_up333_v0__30_5="$__AF_go_up333_v0";
    echo "$__AF_go_up333_v0__30_5" > /dev/null 2>&1
    __AMBER_ARRAY_43=("");
    eprintf__325_v0 "\e[99999D" __AMBER_ARRAY_43[@];
    __AF_eprintf325_v0__31_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__31_5" > /dev/null 2>&1
    __AMBER_ARRAY_44=("");
    eprintf__325_v0 "${prompt}" __AMBER_ARRAY_44[@];
    __AF_eprintf325_v0__33_5="$__AF_eprintf325_v0";
    echo "$__AF_eprintf325_v0__33_5" > /dev/null 2>&1
    eprintf_colored__326_v0 "${placeholder}" 90;
    __AF_eprintf_colored326_v0__34_5="$__AF_eprintf_colored326_v0";
    echo "$__AF_eprintf_colored326_v0__34_5" > /dev/null 2>&1
    get_char__322_v0 ;
    __AF_get_char322_v0__36_16="${__AF_get_char322_v0}";
    local char="${__AF_get_char322_v0__36_16}"
    __AMBER_LEN="${prompt}";
    remove__328_v0 "${#__AMBER_LEN}";
    __AF_remove328_v0__37_5="$__AF_remove328_v0";
    echo "$__AF_remove328_v0__37_5" > /dev/null 2>&1
    __AMBER_LEN="${placeholder}";
    remove__328_v0 $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove328_v0__38_5="$__AF_remove328_v0";
    echo "$__AF_remove328_v0__38_5" > /dev/null 2>&1
    local text=""
    if [ $(echo  '!' ${password} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_45=$( read -e -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_45}"
else
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_46=$( read -es -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_46}"
fi
     stty -echo < /dev/tty ;
    __AS=$?
    # Calculate how many lines the input takes up (prompt + text may wrap)
    __AMBER_LEN="${prompt}""${text}";
    local input_display_len="${#__AMBER_LEN}"
    math_ceil__285_v0 $(echo ${input_display_len} '/' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_ceil285_v0__53_23="$__AF_math_ceil285_v0";
    local input_lines="$__AF_math_ceil285_v0__53_23"
    if [ $(echo ${input_lines} '<' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__334_v0 $(echo 2 '-' ${input_lines} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_down334_v0__56_9="$__AF_go_down334_v0";
        echo "$__AF_go_down334_v0__56_9" > /dev/null 2>&1
        remove_line__329_v0 2;
        __AF_remove_line329_v0__57_9="$__AF_remove_line329_v0";
        echo "$__AF_remove_line329_v0__57_9" > /dev/null 2>&1
        remove_current_line__330_v0 ;
        __AF_remove_current_line330_v0__58_9="$__AF_remove_current_line330_v0";
        echo "$__AF_remove_current_line330_v0__58_9" > /dev/null 2>&1
fi
    if [ $(echo ${input_lines} '>=' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        remove_line__329_v0 ${input_lines};
        __AF_remove_line329_v0__61_9="$__AF_remove_line329_v0";
        echo "$__AF_remove_line329_v0__61_9" > /dev/null 2>&1
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        remove_line__329_v0 1;
        __AF_remove_line329_v0__64_9="$__AF_remove_line329_v0";
        echo "$__AF_remove_line329_v0__64_9" > /dev/null 2>&1
        remove_current_line__330_v0 ;
        __AF_remove_current_line330_v0__65_9="$__AF_remove_current_line330_v0";
        echo "$__AF_remove_current_line330_v0__65_9" > /dev/null 2>&1
fi
     stty echo < /dev/tty ;
    __AS=$?
    __AF_xyl_input368_v0="${text}";
    return 0
}
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__7__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__8__got_xylitol_colors=0
__AMBER_ARRAY_47=(3 207 159 92);
__9__primary_color=("${__AMBER_ARRAY_47[@]}")
__AMBER_ARRAY_48=(3 118 206 95);
__10__secondary_color=("${__AMBER_ARRAY_48[@]}")
__AMBER_ARRAY_49=(234 72 121 94);
__11__accent_color=("${__AMBER_ARRAY_49[@]}")
get_supports_truecolor__399_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __7__supports_truecolor="No"
        __AF_get_supports_truecolor399_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __7__supports_truecolor="No"
        __AF_get_supports_truecolor399_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __7__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor399_v0=$([ "_${__7__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__400_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__7__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb400_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
            return 0
elif [ $([ "_${__7__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__399_v0 ;
            __AF_get_supports_truecolor399_v0__50_17="$__AF_get_supports_truecolor399_v0";
            if [ "$__AF_get_supports_truecolor399_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb400_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb400_v0="${message}";
                return 0
else
                __AF_colored_rgb400_v0="\e[${fallback}m""${message}""\e[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb400_v0="${message}";
            return 0
fi
        __AF_colored_rgb400_v0="\e[${fallback}m""${message}""\e[0m";
        return 0
fi
}
inner_get_xylitol_colors__402_v0() {
    if [ $(echo  '!' ${__8__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_const_get__89_v0 "XYLITOL_PRIMARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__110_27="${__AF_env_const_get89_v0}";
        local primary_env="${__AF_env_const_get89_v0__110_27}"
        if [ $([ "_${primary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${primary_env}" ";";
            __AF_split3_v0__112_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__112_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_50=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __9__primary_color=("${__AMBER_ARRAY_50[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_SECONDARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__123_29="${__AF_env_const_get89_v0}";
        local secondary_env="${__AF_env_const_get89_v0__123_29}"
        if [ $([ "_${secondary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${secondary_env}" ";";
            __AF_split3_v0__125_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__125_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_51=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __10__secondary_color=("${__AMBER_ARRAY_51[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_ACCENT_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__136_26="${__AF_env_const_get89_v0}";
        local accent_env="${__AF_env_const_get89_v0__136_26}"
        if [ $([ "_${accent_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${accent_env}" ";";
            __AF_split3_v0__138_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__138_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors402_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_52=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __11__accent_color=("${__AMBER_ARRAY_52[@]}")
fi
fi
        __8__got_xylitol_colors=1
fi
}
get_xylitol_colors__403_v0() {
    inner_get_xylitol_colors__402_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors402_v0__154_5="$__AF_inner_get_xylitol_colors402_v0";
    echo "$__AF_inner_get_xylitol_colors402_v0__154_5" > /dev/null 2>&1
    __8__got_xylitol_colors=1
}
colored_primary__404_v0() {
    local message=$1
    if [ $(echo  '!' ${__8__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__403_v0 ;
        __AF_get_xylitol_colors403_v0__162_9="$__AF_get_xylitol_colors403_v0";
        echo "$__AF_get_xylitol_colors403_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__400_v0 "${message}" "${__9__primary_color[0]}" "${__9__primary_color[1]}" "${__9__primary_color[2]}" "${__9__primary_color[3]}";
    __AF_colored_rgb400_v0__164_12="${__AF_colored_rgb400_v0}";
    __AF_colored_primary404_v0="${__AF_colored_rgb400_v0__164_12}";
    return 0
}
colored_secondary__405_v0() {
    local message=$1
    if [ $(echo  '!' ${__8__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__403_v0 ;
        __AF_get_xylitol_colors403_v0__169_9="$__AF_get_xylitol_colors403_v0";
        echo "$__AF_get_xylitol_colors403_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__400_v0 "${message}" "${__10__secondary_color[0]}" "${__10__secondary_color[1]}" "${__10__secondary_color[2]}" "${__10__secondary_color[3]}";
    __AF_colored_rgb400_v0__171_12="${__AF_colored_rgb400_v0}";
    __AF_colored_secondary405_v0="${__AF_colored_rgb400_v0__171_12}";
    return 0
}
print_input_help__419_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    colored_primary__404_v0 "input";
    __AF_colored_primary404_v0__7_12="${__AF_colored_primary404_v0}";
    __AMBER_ARRAY_53=("");
    printf__99_v0 "${__AF_colored_primary404_v0__7_12}" __AMBER_ARRAY_53[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_54=("");
    printf__99_v0 " - Prompt for some input from the user." __AMBER_ARRAY_54[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__405_v0 "Flags: ";
    __AF_colored_secondary405_v0__11_12="${__AF_colored_secondary405_v0}";
    __AMBER_ARRAY_55=("");
    printf__99_v0 "${__AF_colored_secondary405_v0__11_12}""
" __AMBER_ARRAY_55[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    echo ""
}
execute_input__477_v0() {
    local parameters=("${!1}")
    local prompt="> "
    local placeholder="Type here..."
    local header=""
    local password=0
    for param in "${parameters[@]}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__14_12="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__14_42="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__14_12" '||' "$__AF_match_regex17_v0__14_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_input_help__419_v0 ;
            __AF_print_input_help419_v0__15_13="$__AF_print_input_help419_v0";
            echo "$__AF_print_input_help419_v0__15_13" > /dev/null 2>&1
            exit 0
fi
        match_regex__17_v0 "${param}" "^--prompt=.*\$" 0;
        __AF_match_regex17_v0__18_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__18_12" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__19_26=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__19_26[@]}")
            prompt="${result[1]}"
fi
        match_regex__17_v0 "${param}" "^--placeholder=.*\$" 0;
        __AF_match_regex17_v0__22_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__22_12" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__23_26=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__23_26[@]}")
            placeholder="${result[1]}"
fi
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__26_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__26_12" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__27_26=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__27_26[@]}")
            header="${result[1]}"
fi
        match_regex__17_v0 "${param}" "^--password\$" 0;
        __AF_match_regex17_v0__30_12="$__AF_match_regex17_v0";
        if [ "$__AF_match_regex17_v0__30_12" != 0 ]; then
            password=1
fi
done
    has_ansi_escape__321_v0 "${header}";
    __AF_has_ansi_escape321_v0__35_42="$__AF_has_ansi_escape321_v0";
    colored_primary__404_v0 "${header}";
    __AF_colored_primary404_v0__35_93="${__AF_colored_primary404_v0}";
    local display_header=$(if [ $(echo $([ "_${header}" != "_" ]; echo $?) '||' "$__AF_has_ansi_escape321_v0__35_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "${header}"; else echo "\e[1m""${__AF_colored_primary404_v0__35_93}"; fi)
    xyl_input__368_v0 "${prompt}" "${placeholder}" "${display_header}" ${password};
    __AF_xyl_input368_v0__36_12="${__AF_xyl_input368_v0}";
    __AF_execute_input477_v0="${__AF_xyl_input368_v0__36_12}";
    return 0
}
has_ansi_escape__538_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27)
    __AMBER_VAL_56=$( [[ "${text}" == *$'\e'* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_56}"
    __AF_has_ansi_escape538_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
get_key__540_v0() {
    __AMBER_VAL_57=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_57}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key540_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key540_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key540_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key540_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key540_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key540_v0="INPUT";
        return 0
else
        __AF_get_key540_v0="${var}";
        return 0
fi
}
eprintf__542_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__543_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_58=("${message}");
    eprintf__542_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_58[@];
    __AF_eprintf542_v0__44_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__44_5" > /dev/null 2>&1
}
colored__544_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored544_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__546_v0() {
    local cnt=$1
     printf '\e[2K\e[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_59=("");
    eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_59[@];
    __AF_eprintf542_v0__60_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__60_5" > /dev/null 2>&1
}
remove_current_line__547_v0() {
    __AMBER_ARRAY_60=("");
    eprintf__542_v0 "\e[2K\e[9999D" __AMBER_ARRAY_60[@];
    __AF_eprintf542_v0__65_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__65_5" > /dev/null 2>&1
}
print_blank__548_v0() {
    local cnt=$1
     printf '%*s' "${cnt}" ' ' >&2 ;
    __AS=$?
}
new_line__549_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_61=("");
        eprintf__542_v0 "
" __AMBER_ARRAY_61[@];
        __AF_eprintf542_v0__77_9="$__AF_eprintf542_v0";
        echo "$__AF_eprintf542_v0__77_9" > /dev/null 2>&1
done
}
go_up__550_v0() {
    local cnt=$1
    __AMBER_ARRAY_62=("");
    eprintf__542_v0 "\e[${cnt}A" __AMBER_ARRAY_62[@];
    __AF_eprintf542_v0__83_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__83_5" > /dev/null 2>&1
}
go_down__551_v0() {
    local cnt=$1
    __AMBER_ARRAY_63=("");
    eprintf__542_v0 "\e[${cnt}B" __AMBER_ARRAY_63[@];
    __AF_eprintf542_v0__88_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__88_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
go_up_or_down__552_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__551_v0 ${cnt};
        __AF_go_down551_v0__94_9="$__AF_go_down551_v0";
        echo "$__AF_go_down551_v0__94_9" > /dev/null 2>&1
else
        go_up__550_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up550_v0__96_9="$__AF_go_up550_v0";
        echo "$__AF_go_up550_v0__96_9" > /dev/null 2>&1
fi
}
hide_cursor__553_v0() {
    __AMBER_ARRAY_64=("");
    eprintf__542_v0 "\e[?25l" __AMBER_ARRAY_64[@];
    __AF_eprintf542_v0__101_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__101_5" > /dev/null 2>&1
}
show_cursor__554_v0() {
    __AMBER_ARRAY_65=("");
    eprintf__542_v0 "\e[?25h" __AMBER_ARRAY_65[@];
    __AF_eprintf542_v0__105_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__105_5" > /dev/null 2>&1
}
truncate_text__555_v0() {
    local text=$1
    local max_width=$2
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text555_v0="${text}";
        return 0
fi
    __AMBER_VAL_66=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_66}"
    __AF_truncate_text555_v0="${truncated}""...";
    return 0
}
render_tooltip__556_v0() {
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
                eprintf_colored__543_v0 "${separator}" 90;
                __AF_eprintf_colored543_v0__136_27="$__AF_eprintf_colored543_v0";
                echo "$__AF_eprintf_colored543_v0__136_27" > /dev/null 2>&1
fi
            colored__544_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored544_v0__138_41="${__AF_colored544_v0}";
            __AMBER_ARRAY_67=("");
            eprintf__542_v0 "${items[${iter}]}"" ""${__AF_colored544_v0__138_41}" __AMBER_ARRAY_67[@];
            __AF_eprintf542_v0__138_13="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__138_13" > /dev/null 2>&1
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
                eprintf_colored__543_v0 "${separator}" 90;
                __AF_eprintf_colored543_v0__164_17="$__AF_eprintf_colored543_v0";
                echo "$__AF_eprintf_colored543_v0__164_17" > /dev/null 2>&1
fi
            colored__544_v0 "${action}" 2;
            __AF_colored544_v0__166_33="${__AF_colored544_v0}";
            __AMBER_ARRAY_68=("");
            eprintf__542_v0 "${key}"" ""${__AF_colored544_v0__166_33}" __AMBER_ARRAY_68[@];
            __AF_eprintf542_v0__166_13="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__166_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__12__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__13__got_xylitol_colors=0
__AMBER_ARRAY_69=(3 207 159 92);
__14__primary_color=("${__AMBER_ARRAY_69[@]}")
__AMBER_ARRAY_70=(3 118 206 95);
__15__secondary_color=("${__AMBER_ARRAY_70[@]}")
__AMBER_ARRAY_71=(234 72 121 94);
__16__accent_color=("${__AMBER_ARRAY_71[@]}")
get_supports_truecolor__580_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __12__supports_truecolor="No"
        __AF_get_supports_truecolor580_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __12__supports_truecolor="No"
        __AF_get_supports_truecolor580_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __12__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor580_v0=$([ "_${__12__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__581_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__12__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb581_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
            return 0
elif [ $([ "_${__12__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__580_v0 ;
            __AF_get_supports_truecolor580_v0__50_17="$__AF_get_supports_truecolor580_v0";
            if [ "$__AF_get_supports_truecolor580_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb581_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb581_v0="${message}";
                return 0
else
                __AF_colored_rgb581_v0="\e[${fallback}m""${message}""\e[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb581_v0="${message}";
            return 0
fi
        __AF_colored_rgb581_v0="\e[${fallback}m""${message}""\e[0m";
        return 0
fi
}
inner_get_xylitol_colors__583_v0() {
    if [ $(echo  '!' ${__13__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_const_get__89_v0 "XYLITOL_PRIMARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__110_27="${__AF_env_const_get89_v0}";
        local primary_env="${__AF_env_const_get89_v0__110_27}"
        if [ $([ "_${primary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${primary_env}" ";";
            __AF_split3_v0__112_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__112_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_72=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __14__primary_color=("${__AMBER_ARRAY_72[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_SECONDARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__123_29="${__AF_env_const_get89_v0}";
        local secondary_env="${__AF_env_const_get89_v0__123_29}"
        if [ $([ "_${secondary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${secondary_env}" ";";
            __AF_split3_v0__125_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__125_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_73=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __15__secondary_color=("${__AMBER_ARRAY_73[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_ACCENT_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__136_26="${__AF_env_const_get89_v0}";
        local accent_env="${__AF_env_const_get89_v0__136_26}"
        if [ $([ "_${accent_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${accent_env}" ";";
            __AF_split3_v0__138_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__138_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors583_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_74=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __16__accent_color=("${__AMBER_ARRAY_74[@]}")
fi
fi
        __13__got_xylitol_colors=1
fi
}
get_xylitol_colors__584_v0() {
    inner_get_xylitol_colors__583_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors583_v0__154_5="$__AF_inner_get_xylitol_colors583_v0";
    echo "$__AF_inner_get_xylitol_colors583_v0__154_5" > /dev/null 2>&1
    __13__got_xylitol_colors=1
}
colored_primary__585_v0() {
    local message=$1
    if [ $(echo  '!' ${__13__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__584_v0 ;
        __AF_get_xylitol_colors584_v0__162_9="$__AF_get_xylitol_colors584_v0";
        echo "$__AF_get_xylitol_colors584_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__581_v0 "${message}" "${__14__primary_color[0]}" "${__14__primary_color[1]}" "${__14__primary_color[2]}" "${__14__primary_color[3]}";
    __AF_colored_rgb581_v0__164_12="${__AF_colored_rgb581_v0}";
    __AF_colored_primary585_v0="${__AF_colored_rgb581_v0__164_12}";
    return 0
}
colored_secondary__586_v0() {
    local message=$1
    if [ $(echo  '!' ${__13__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__584_v0 ;
        __AF_get_xylitol_colors584_v0__169_9="$__AF_get_xylitol_colors584_v0";
        echo "$__AF_get_xylitol_colors584_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__581_v0 "${message}" "${__15__secondary_color[0]}" "${__15__secondary_color[1]}" "${__15__secondary_color[2]}" "${__15__secondary_color[3]}";
    __AF_colored_rgb581_v0__171_12="${__AF_colored_rgb581_v0}";
    __AF_colored_secondary586_v0="${__AF_colored_rgb581_v0__171_12}";
    return 0
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__17__got_term_size=0
__AMBER_ARRAY_75=(80 24);
__18__term_size=("${__AMBER_ARRAY_75[@]}")
get_term_size__602_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_76=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_76}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size602_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size602_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size602_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_77=(${cols} ${rows});
    __18__term_size=("${__AMBER_ARRAY_77[@]}")
    __17__got_term_size=1
}
term_width__604_v0() {
    if [ $(echo  '!' ${__17__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__602_v0 ;
        __AS=$?;
        __AF_get_term_size602_v0__33_15="$__AF_get_term_size602_v0";
        echo "$__AF_get_term_size602_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width604_v0="${__18__term_size[0]}";
    return 0
}
term_height__605_v0() {
    if [ $(echo  '!' ${__17__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__602_v0 ;
        __AS=$?;
        __AF_get_term_size602_v0__41_15="$__AF_get_term_size602_v0";
        echo "$__AF_get_term_size602_v0__41_15" > /dev/null 2>&1
fi
    __AF_term_height605_v0="${__18__term_size[1]}";
    return 0
}
get_page_options__609_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    local start=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local end=$(echo ${start} '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${end} '>' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        end="${#options[@]}"
fi
    __AMBER_ARRAY_78=();
    local result=("${__AMBER_ARRAY_78[@]}")
    for i in $(seq ${start} $(echo ${end} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_79=("${options[${i}]}");
        result+=("${__AMBER_ARRAY_79[@]}")
done
    __AF_get_page_options609_v0=("${result[@]}");
    return 0
}
get_page_start__610_v0() {
    local page=$1
    local page_size=$2
    __AF_get_page_start610_v0=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
render_choose_page__611_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local max_option_width=$(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        truncate_text__555_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_truncate_text555_v0__28_32="${__AF_truncate_text555_v0}";
        local truncated_option="${__AF_truncate_text555_v0__28_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            colored_secondary__586_v0 "${cursor}""${truncated_option}""
";
            __AF_colored_secondary586_v0__30_21="${__AF_colored_secondary586_v0}";
            __AMBER_ARRAY_80=("");
            eprintf__542_v0 "${__AF_colored_secondary586_v0__30_21}" __AMBER_ARRAY_80[@];
            __AF_eprintf542_v0__30_13="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__30_13" > /dev/null 2>&1
else
            print_blank__548_v0 ${cursor_len};
            __AF_print_blank548_v0__32_13="$__AF_print_blank548_v0";
            echo "$__AF_print_blank548_v0__32_13" > /dev/null 2>&1
            __AMBER_ARRAY_81=("");
            eprintf__542_v0 "${truncated_option}""
" __AMBER_ARRAY_81[@];
            __AF_eprintf542_v0__33_13="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__33_13" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug gaurd
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_82=("");
            eprintf__542_v0 "\e[K
" __AMBER_ARRAY_82[@];
            __AF_eprintf542_v0__39_13="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__39_13" > /dev/null 2>&1
done
fi
}
render_multi_choose_page__612_v0() {
    local page_options=("${!1}")
    local checked=("${!2}")
    local page_start=$3
    local sel=$4
    local cursor=$5
    local display_count=$6
    local term_width=$7
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local check_mark_len=2
    # "✓ " or "• "
    local max_option_width=$(echo $(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' ${check_mark_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local global_idx=$(echo ${page_start} '+' ${i} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        local check_mark=$(if [ "${checked[${global_idx}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
        truncate_text__555_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_truncate_text555_v0__51_32="${__AF_truncate_text555_v0}";
        local truncated_option="${__AF_truncate_text555_v0__51_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            colored_secondary__586_v0 "${cursor}""${check_mark}""${truncated_option}""
";
            __AF_colored_secondary586_v0__53_31="${__AF_colored_secondary586_v0}";
            __AMBER_ARRAY_83=("");
            eprintf__542_v0 "${__AF_colored_secondary586_v0__53_31}" __AMBER_ARRAY_83[@];
            __AF_eprintf542_v0__53_23="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__53_23" > /dev/null 2>&1
elif [ "${checked[${global_idx}]}" != 0 ]; then
                            print_blank__548_v0 ${cursor_len};
                __AF_print_blank548_v0__55_17="$__AF_print_blank548_v0";
                echo "$__AF_print_blank548_v0__55_17" > /dev/null 2>&1
                colored_secondary__586_v0 "${check_mark}""${truncated_option}""
";
                __AF_colored_secondary586_v0__56_25="${__AF_colored_secondary586_v0}";
                __AMBER_ARRAY_84=("");
                eprintf__542_v0 "${__AF_colored_secondary586_v0__56_25}" __AMBER_ARRAY_84[@];
                __AF_eprintf542_v0__56_17="$__AF_eprintf542_v0";
                echo "$__AF_eprintf542_v0__56_17" > /dev/null 2>&1
else
                            print_blank__548_v0 ${cursor_len};
                __AF_print_blank548_v0__59_17="$__AF_print_blank548_v0";
                echo "$__AF_print_blank548_v0__59_17" > /dev/null 2>&1
                __AMBER_ARRAY_85=("");
                eprintf__542_v0 "${check_mark}""${truncated_option}""
" __AMBER_ARRAY_85[@];
                __AF_eprintf542_v0__60_17="$__AF_eprintf542_v0";
                echo "$__AF_eprintf542_v0__60_17" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug guard
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_86=("");
            eprintf__542_v0 "\e[K
" __AMBER_ARRAY_86[@];
            __AF_eprintf542_v0__67_13="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__67_13" > /dev/null 2>&1
done
fi
}
render_page_indicator__613_v0() {
    local page=$1
    local total_pages=$2
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_87=("");
        eprintf__542_v0 "\e[9999D\e[K" __AMBER_ARRAY_87[@];
        __AF_eprintf542_v0__74_9="$__AF_eprintf542_v0";
        echo "$__AF_eprintf542_v0__74_9" > /dev/null 2>&1
        eprintf_colored__543_v0 "Page $(echo ${page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored543_v0__75_9="$__AF_eprintf_colored543_v0";
        echo "$__AF_eprintf_colored543_v0__75_9" > /dev/null 2>&1
        __AMBER_ARRAY_88=("");
        eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_88[@];
        __AF_eprintf542_v0__76_9="$__AF_eprintf542_v0";
        echo "$__AF_eprintf542_v0__76_9" > /dev/null 2>&1
fi
}
xyl_choose__614_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__543_v0 "ERROR: No options provided.
" 31;
        __AF_eprintf_colored543_v0__94_9="$__AF_eprintf_colored543_v0";
        echo "$__AF_eprintf_colored543_v0__94_9" > /dev/null 2>&1
        exit 1
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__553_v0 ;
    __AF_hide_cursor553_v0__99_5="$__AF_hide_cursor553_v0";
    echo "$__AF_hide_cursor553_v0__99_5" > /dev/null 2>&1
    term_width__604_v0 ;
    __AF_term_width604_v0__101_22="$__AF_term_width604_v0";
    local term_width="$__AF_term_width604_v0__101_22"
    term_height__605_v0 ;
    __AF_term_height605_v0__102_23="$__AF_term_height605_v0";
    local term_height="$__AF_term_height605_v0__102_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__555_v0 "${header}" ${term_width};
        __AF_truncate_text555_v0__109_17="${__AF_truncate_text555_v0}";
        __AMBER_ARRAY_89=("");
        eprintf__542_v0 "${__AF_truncate_text555_v0__109_17}""
" __AMBER_ARRAY_89[@];
        __AF_eprintf542_v0__109_9="$__AF_eprintf542_v0";
        echo "$__AF_eprintf542_v0__109_9" > /dev/null 2>&1
fi
    math_floor__284_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor284_v0__112_23="$__AF_math_floor284_v0";
    local total_pages="$__AF_math_floor284_v0__112_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__549_v0 ${display_count};
    __AF_new_line549_v0__121_5="$__AF_new_line549_v0";
    echo "$__AF_new_line549_v0__121_5" > /dev/null 2>&1
    __AMBER_ARRAY_90=("");
    eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_90[@];
    __AF_eprintf542_v0__122_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__122_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__543_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored543_v0__124_9="$__AF_eprintf_colored543_v0";
        echo "$__AF_eprintf_colored543_v0__124_9" > /dev/null 2>&1
fi
    new_line__549_v0 1;
    __AF_new_line549_v0__126_5="$__AF_new_line549_v0";
    echo "$__AF_new_line549_v0__126_5" > /dev/null 2>&1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_91=("↑↓" "select" "←→" "page" "enter" "confirm");
        render_tooltip__556_v0 __AMBER_ARRAY_91[@] 36 ${term_width};
        __AF_render_tooltip556_v0__131_9="$__AF_render_tooltip556_v0";
        echo "$__AF_render_tooltip556_v0__131_9" > /dev/null 2>&1
else
        __AMBER_ARRAY_92=("↑↓" "select" "enter" "confirm");
        render_tooltip__556_v0 __AMBER_ARRAY_92[@] 25 ${term_width};
        __AF_render_tooltip556_v0__133_9="$__AF_render_tooltip556_v0";
        echo "$__AF_render_tooltip556_v0__133_9" > /dev/null 2>&1
fi
    go_up__550_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up550_v0__135_5="$__AF_go_up550_v0";
    echo "$__AF_go_up550_v0__135_5" > /dev/null 2>&1
    __AMBER_ARRAY_93=("");
    eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_93[@];
    __AF_eprintf542_v0__136_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__136_5" > /dev/null 2>&1
    get_page_options__609_v0 options[@] ${current_page} ${page_size};
    __AF_get_page_options609_v0__138_24=("${__AF_get_page_options609_v0[@]}");
    local page_options=("${__AF_get_page_options609_v0__138_24[@]}")
    render_choose_page__611_v0 page_options[@] ${selected} "${cursor}" ${display_count} ${term_width};
    __AF_render_choose_page611_v0__139_5="$__AF_render_choose_page611_v0";
    echo "$__AF_render_choose_page611_v0__139_5" > /dev/null 2>&1
    while :
do
        get_key__540_v0 ;
        __AF_get_key540_v0__142_19="${__AF_get_key540_v0}";
        local key="${__AF_get_key540_v0__142_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        local up_paged=0
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
                up_paged=1
elif [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
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
            get_page_options__609_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options609_v0__205_32=("${__AF_get_page_options609_v0[@]}");
            page_options=("${__AF_get_page_options609_v0__205_32[@]}")
            if [ ${up_paged} != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            go_up__550_v0 1;
            __AF_go_up550_v0__209_17="$__AF_go_up550_v0";
            echo "$__AF_go_up550_v0__209_17" > /dev/null 2>&1
            remove_line__546_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line546_v0__210_17="$__AF_remove_line546_v0";
            echo "$__AF_remove_line546_v0__210_17" > /dev/null 2>&1
            remove_current_line__547_v0 ;
            __AF_remove_current_line547_v0__211_17="$__AF_remove_current_line547_v0";
            echo "$__AF_remove_current_line547_v0__211_17" > /dev/null 2>&1
            __AMBER_ARRAY_94=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_94[@];
            __AF_eprintf542_v0__212_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__212_17" > /dev/null 2>&1
            render_choose_page__611_v0 page_options[@] ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_choose_page611_v0__213_17="$__AF_render_choose_page611_v0";
            echo "$__AF_render_choose_page611_v0__213_17" > /dev/null 2>&1
            render_page_indicator__613_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator613_v0__214_17="$__AF_render_page_indicator613_v0";
            echo "$__AF_render_page_indicator613_v0__214_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__550_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up550_v0__217_17="$__AF_go_up550_v0";
            echo "$__AF_go_up550_v0__217_17" > /dev/null 2>&1
            __AMBER_ARRAY_95=("");
            eprintf__542_v0 "\e[K" __AMBER_ARRAY_95[@];
            __AF_eprintf542_v0__218_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__218_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__548_v0 "${#__AMBER_LEN}";
            __AF_print_blank548_v0__219_17="$__AF_print_blank548_v0";
            echo "$__AF_print_blank548_v0__219_17" > /dev/null 2>&1
            truncate_text__555_v0 "${page_options[${prev_selected}]}" ${max_option_width};
            __AF_truncate_text555_v0__220_25="${__AF_truncate_text555_v0}";
            __AMBER_ARRAY_96=("");
            eprintf__542_v0 "${__AF_truncate_text555_v0__220_25}" __AMBER_ARRAY_96[@];
            __AF_eprintf542_v0__220_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__220_17" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__552_v0 ${diff};
            __AF_go_up_or_down552_v0__223_17="$__AF_go_up_or_down552_v0";
            echo "$__AF_go_up_or_down552_v0__223_17" > /dev/null 2>&1
            __AMBER_ARRAY_97=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_97[@];
            __AF_eprintf542_v0__224_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__224_17" > /dev/null 2>&1
            __AMBER_ARRAY_98=("");
            eprintf__542_v0 "\e[K" __AMBER_ARRAY_98[@];
            __AF_eprintf542_v0__225_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__225_17" > /dev/null 2>&1
            truncate_text__555_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text555_v0__226_52="${__AF_truncate_text555_v0}";
            colored_secondary__586_v0 "${cursor}""${__AF_truncate_text555_v0__226_52}";
            __AF_colored_secondary586_v0__226_25="${__AF_colored_secondary586_v0}";
            __AMBER_ARRAY_99=("");
            eprintf__542_v0 "${__AF_colored_secondary586_v0__226_25}" __AMBER_ARRAY_99[@];
            __AF_eprintf542_v0__226_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__226_17" > /dev/null 2>&1
            go_down__551_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down551_v0__228_17="$__AF_go_down551_v0";
            echo "$__AF_go_down551_v0__228_17" > /dev/null 2>&1
            __AMBER_ARRAY_100=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_100[@];
            __AF_eprintf542_v0__229_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__229_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__551_v0 1;
    __AF_go_down551_v0__239_5="$__AF_go_down551_v0";
    echo "$__AF_go_down551_v0__239_5" > /dev/null 2>&1
    remove_line__546_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line546_v0__240_5="$__AF_remove_line546_v0";
    echo "$__AF_remove_line546_v0__240_5" > /dev/null 2>&1
    remove_current_line__547_v0 ;
    __AF_remove_current_line547_v0__241_5="$__AF_remove_current_line547_v0";
    echo "$__AF_remove_current_line547_v0__241_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__554_v0 ;
    __AF_show_cursor554_v0__244_5="$__AF_show_cursor554_v0";
    echo "$__AF_show_cursor554_v0__244_5" > /dev/null 2>&1
    local global_selected=$(echo $(echo ${current_page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_xyl_choose614_v0="${options[${global_selected}]}";
    return 0
}
count_checked__615_v0() {
    local checked=("${!1}")
    local count=0
    for c in "${checked[@]}"; do
        if [ ${c} != 0 ]; then
            count=$(echo ${count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
done
    __AF_count_checked615_v0=${count};
    return 0
}
xyl_multi_choose__616_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__543_v0 "ERROR: No options provided.
" 31;
        __AF_eprintf_colored543_v0__275_9="$__AF_eprintf_colored543_v0";
        echo "$__AF_eprintf_colored543_v0__275_9" > /dev/null 2>&1
        __AMBER_ARRAY_101=();
        __AF_xyl_multi_choose616_v0=("${__AMBER_ARRAY_101[@]}");
        return 0
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__553_v0 ;
    __AF_hide_cursor553_v0__280_5="$__AF_hide_cursor553_v0";
    echo "$__AF_hide_cursor553_v0__280_5" > /dev/null 2>&1
    term_width__604_v0 ;
    __AF_term_width604_v0__282_22="$__AF_term_width604_v0";
    local term_width="$__AF_term_width604_v0__282_22"
    term_height__605_v0 ;
    __AF_term_height605_v0__283_23="$__AF_term_height605_v0";
    local term_height="$__AF_term_height605_v0__283_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__555_v0 "${header}" ${term_width};
        __AF_truncate_text555_v0__290_17="${__AF_truncate_text555_v0}";
        __AMBER_ARRAY_102=("");
        eprintf__542_v0 "${__AF_truncate_text555_v0__290_17}""
" __AMBER_ARRAY_102[@];
        __AF_eprintf542_v0__290_9="$__AF_eprintf542_v0";
        echo "$__AF_eprintf542_v0__290_9" > /dev/null 2>&1
fi
    math_floor__284_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor284_v0__293_23="$__AF_math_floor284_v0";
    local total_pages="$__AF_math_floor284_v0__293_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__549_v0 ${display_count};
    __AF_new_line549_v0__302_5="$__AF_new_line549_v0";
    echo "$__AF_new_line549_v0__302_5" > /dev/null 2>&1
    __AMBER_ARRAY_103=("");
    eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_103[@];
    __AF_eprintf542_v0__303_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__303_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__543_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored543_v0__305_9="$__AF_eprintf_colored543_v0";
        echo "$__AF_eprintf_colored543_v0__305_9" > /dev/null 2>&1
fi
    new_line__549_v0 1;
    __AF_new_line549_v0__307_5="$__AF_new_line549_v0";
    echo "$__AF_new_line549_v0__307_5" > /dev/null 2>&1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ $(echo $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_104=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm");
        render_tooltip__556_v0 __AMBER_ARRAY_104[@] 55 ${term_width};
        __AF_render_tooltip556_v0__314_40="$__AF_render_tooltip556_v0";
        echo "$__AF_render_tooltip556_v0__314_40" > /dev/null 2>&1
elif [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_105=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm");
        render_tooltip__556_v0 __AMBER_ARRAY_105[@] 47 ${term_width};
        __AF_render_tooltip556_v0__315_26="$__AF_render_tooltip556_v0";
        echo "$__AF_render_tooltip556_v0__315_26" > /dev/null 2>&1
elif [ $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_106=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm");
        render_tooltip__556_v0 __AMBER_ARRAY_106[@] 44 ${term_width};
        __AF_render_tooltip556_v0__316_20="$__AF_render_tooltip556_v0";
        echo "$__AF_render_tooltip556_v0__316_20" > /dev/null 2>&1
else
        __AMBER_ARRAY_107=("↑↓" "select" "x" "toggle" "enter" "confirm");
        render_tooltip__556_v0 __AMBER_ARRAY_107[@] 36 ${term_width};
        __AF_render_tooltip556_v0__317_15="$__AF_render_tooltip556_v0";
        echo "$__AF_render_tooltip556_v0__317_15" > /dev/null 2>&1
fi
    go_up__550_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up550_v0__319_5="$__AF_go_up550_v0";
    echo "$__AF_go_up550_v0__319_5" > /dev/null 2>&1
    __AMBER_ARRAY_108=("");
    eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_108[@];
    __AF_eprintf542_v0__320_5="$__AF_eprintf542_v0";
    echo "$__AF_eprintf542_v0__320_5" > /dev/null 2>&1
    __AMBER_ARRAY_109=();
    local checked=("${__AMBER_ARRAY_109[@]}")
    for _ in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_110=(0);
        checked+=("${__AMBER_ARRAY_110[@]}")
done
    get_page_options__609_v0 options[@] ${current_page} ${page_size};
    __AF_get_page_options609_v0__327_24=("${__AF_get_page_options609_v0[@]}");
    local page_options=("${__AF_get_page_options609_v0__327_24[@]}")
    get_page_start__610_v0 ${current_page} ${page_size};
    __AF_get_page_start610_v0__328_22="$__AF_get_page_start610_v0";
    local page_start="$__AF_get_page_start610_v0__328_22"
    render_multi_choose_page__612_v0 page_options[@] checked[@] ${page_start} ${selected} "${cursor}" ${display_count} ${term_width};
    __AF_render_multi_choose_page612_v0__329_5="$__AF_render_multi_choose_page612_v0";
    echo "$__AF_render_multi_choose_page612_v0__329_5" > /dev/null 2>&1
    while :
do
        get_key__540_v0 ;
        __AF_get_key540_v0__332_19="${__AF_get_key540_v0}";
        local key="${__AF_get_key540_v0__332_19}"
        local prev_selected=${selected}
        local prev_page=${current_page}
        local global_selected=$(echo ${page_start} '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        local up_paged=0
        if [ $(echo $([ "_${key}" != "_UP" ]; echo $?) '||' $([ "_${key}" != "_k" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ $(echo $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                if [ $(echo ${current_page} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    current_page=$(echo ${current_page} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
else
                    current_page=$(echo ${total_pages} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
                up_paged=1
elif [ $(echo ${selected} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
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
            count_checked__615_v0 checked[@];
            __AF_count_checked615_v0__392_34="$__AF_count_checked615_v0";
            if [ "${checked[${global_selected}]}" != 0 ]; then
                checked[${global_selected}]=0
elif [ $(echo $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $(echo "$__AF_count_checked615_v0__392_34" '<' ${limit} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                checked[${global_selected}]=1
else
                continue
fi
            __AMBER_LEN="${cursor}";
            local max_option_width=$(echo $(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            # 2 for check mark
            go_up__550_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up550_v0__398_17="$__AF_go_up550_v0";
            echo "$__AF_go_up550_v0__398_17" > /dev/null 2>&1
            __AMBER_ARRAY_111=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_111[@];
            __AF_eprintf542_v0__399_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__399_17" > /dev/null 2>&1
            __AMBER_ARRAY_112=("");
            eprintf__542_v0 "\e[K" __AMBER_ARRAY_112[@];
            __AF_eprintf542_v0__400_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__400_17" > /dev/null 2>&1
            local check_mark=$(if [ "${checked[${global_selected}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            truncate_text__555_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text555_v0__402_65="${__AF_truncate_text555_v0}";
            colored_secondary__586_v0 "${cursor}""${check_mark}""${__AF_truncate_text555_v0__402_65}";
            __AF_colored_secondary586_v0__402_25="${__AF_colored_secondary586_v0}";
            __AMBER_ARRAY_113=("");
            eprintf__542_v0 "${__AF_colored_secondary586_v0__402_25}" __AMBER_ARRAY_113[@];
            __AF_eprintf542_v0__402_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__402_17" > /dev/null 2>&1
            go_down__551_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down551_v0__403_17="$__AF_go_down551_v0";
            echo "$__AF_go_down551_v0__403_17" > /dev/null 2>&1
            __AMBER_ARRAY_114=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_114[@];
            __AF_eprintf542_v0__404_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__404_17" > /dev/null 2>&1
            continue
elif [ $(echo $(echo $([ "_${key}" != "_a" ]; echo $?) '||' $([ "_${key}" != "_A" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            count_checked__615_v0 checked[@];
            __AF_count_checked615_v0__408_35="$__AF_count_checked615_v0";
            local all_checked=$(echo "$__AF_count_checked615_v0__408_35" '==' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            for i in $(seq 0 $(echo "${#checked[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
                checked[${i}]=$(echo  '!' ${all_checked} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
            go_up__550_v0 ${display_count};
            __AF_go_up550_v0__412_17="$__AF_go_up550_v0";
            echo "$__AF_go_up550_v0__412_17" > /dev/null 2>&1
            __AMBER_ARRAY_115=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_115[@];
            __AF_eprintf542_v0__413_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__413_17" > /dev/null 2>&1
            render_multi_choose_page__612_v0 page_options[@] checked[@] ${page_start} ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_multi_choose_page612_v0__414_17="$__AF_render_multi_choose_page612_v0";
            echo "$__AF_render_multi_choose_page612_v0__414_17" > /dev/null 2>&1
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
            get_page_options__609_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options609_v0__426_32=("${__AF_get_page_options609_v0[@]}");
            page_options=("${__AF_get_page_options609_v0__426_32[@]}")
            get_page_start__610_v0 ${current_page} ${page_size};
            __AF_get_page_start610_v0__427_30="$__AF_get_page_start610_v0";
            page_start="$__AF_get_page_start610_v0__427_30"
            if [ ${up_paged} != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            go_up__550_v0 1;
            __AF_go_up550_v0__431_17="$__AF_go_up550_v0";
            echo "$__AF_go_up550_v0__431_17" > /dev/null 2>&1
            remove_line__546_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line546_v0__432_17="$__AF_remove_line546_v0";
            echo "$__AF_remove_line546_v0__432_17" > /dev/null 2>&1
            remove_current_line__547_v0 ;
            __AF_remove_current_line547_v0__433_17="$__AF_remove_current_line547_v0";
            echo "$__AF_remove_current_line547_v0__433_17" > /dev/null 2>&1
            __AMBER_ARRAY_116=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_116[@];
            __AF_eprintf542_v0__434_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__434_17" > /dev/null 2>&1
            render_multi_choose_page__612_v0 page_options[@] checked[@] ${page_start} ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_multi_choose_page612_v0__435_17="$__AF_render_multi_choose_page612_v0";
            echo "$__AF_render_multi_choose_page612_v0__435_17" > /dev/null 2>&1
            render_page_indicator__613_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator613_v0__436_17="$__AF_render_page_indicator613_v0";
            echo "$__AF_render_page_indicator613_v0__436_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local prev_global=$(echo ${page_start} '+' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up__550_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up550_v0__440_17="$__AF_go_up550_v0";
            echo "$__AF_go_up550_v0__440_17" > /dev/null 2>&1
            __AMBER_ARRAY_117=("");
            eprintf__542_v0 "\e[K" __AMBER_ARRAY_117[@];
            __AF_eprintf542_v0__441_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__441_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__548_v0 "${#__AMBER_LEN}";
            __AF_print_blank548_v0__442_17="$__AF_print_blank548_v0";
            echo "$__AF_print_blank548_v0__442_17" > /dev/null 2>&1
            if [ "${checked[${prev_global}]}" != 0 ]; then
                truncate_text__555_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_truncate_text555_v0__444_54="${__AF_truncate_text555_v0}";
                colored_secondary__586_v0 "✓ ""${__AF_truncate_text555_v0__444_54}";
                __AF_colored_secondary586_v0__444_29="${__AF_colored_secondary586_v0}";
                __AMBER_ARRAY_118=("");
                eprintf__542_v0 "${__AF_colored_secondary586_v0__444_29}" __AMBER_ARRAY_118[@];
                __AF_eprintf542_v0__444_21="$__AF_eprintf542_v0";
                echo "$__AF_eprintf542_v0__444_21" > /dev/null 2>&1
else
                truncate_text__555_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_truncate_text555_v0__446_36="${__AF_truncate_text555_v0}";
                __AMBER_ARRAY_119=("");
                eprintf__542_v0 "• ""${__AF_truncate_text555_v0__446_36}" __AMBER_ARRAY_119[@];
                __AF_eprintf542_v0__446_21="$__AF_eprintf542_v0";
                echo "$__AF_eprintf542_v0__446_21" > /dev/null 2>&1
fi
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__552_v0 ${diff};
            __AF_go_up_or_down552_v0__450_17="$__AF_go_up_or_down552_v0";
            echo "$__AF_go_up_or_down552_v0__450_17" > /dev/null 2>&1
            __AMBER_ARRAY_120=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_120[@];
            __AF_eprintf542_v0__451_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__451_17" > /dev/null 2>&1
            __AMBER_ARRAY_121=("");
            eprintf__542_v0 "\e[K" __AMBER_ARRAY_121[@];
            __AF_eprintf542_v0__452_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__452_17" > /dev/null 2>&1
            local new_global=$(echo ${page_start} '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local check_mark=$(if [ "${checked[${new_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            truncate_text__555_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_truncate_text555_v0__455_65="${__AF_truncate_text555_v0}";
            colored_secondary__586_v0 "${cursor}""${check_mark}""${__AF_truncate_text555_v0__455_65}";
            __AF_colored_secondary586_v0__455_25="${__AF_colored_secondary586_v0}";
            __AMBER_ARRAY_122=("");
            eprintf__542_v0 "${__AF_colored_secondary586_v0__455_25}" __AMBER_ARRAY_122[@];
            __AF_eprintf542_v0__455_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__455_17" > /dev/null 2>&1
            go_down__551_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down551_v0__457_17="$__AF_go_down551_v0";
            echo "$__AF_go_down551_v0__457_17" > /dev/null 2>&1
            __AMBER_ARRAY_123=("");
            eprintf__542_v0 "\e[9999D" __AMBER_ARRAY_123[@];
            __AF_eprintf542_v0__458_17="$__AF_eprintf542_v0";
            echo "$__AF_eprintf542_v0__458_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__551_v0 1;
    __AF_go_down551_v0__468_5="$__AF_go_down551_v0";
    echo "$__AF_go_down551_v0__468_5" > /dev/null 2>&1
    remove_line__546_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line546_v0__469_5="$__AF_remove_line546_v0";
    echo "$__AF_remove_line546_v0__469_5" > /dev/null 2>&1
    remove_current_line__547_v0 ;
    __AF_remove_current_line547_v0__470_5="$__AF_remove_current_line547_v0";
    echo "$__AF_remove_current_line547_v0__470_5" > /dev/null 2>&1
    __AMBER_ARRAY_124=();
    local result=("${__AMBER_ARRAY_124[@]}")
    for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ "${checked[${i}]}" != 0 ]; then
            __AMBER_ARRAY_125=("${options[${i}]}");
            result+=("${__AMBER_ARRAY_125[@]}")
fi
done
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__554_v0 ;
    __AF_show_cursor554_v0__480_5="$__AF_show_cursor554_v0";
    echo "$__AF_show_cursor554_v0__480_5" > /dev/null 2>&1
    __AF_xyl_multi_choose616_v0=("${result[@]}");
    return 0
}
print_choose_help__681_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    colored_primary__585_v0 "choose";
    __AF_colored_primary585_v0__7_12="${__AF_colored_primary585_v0}";
    __AMBER_ARRAY_126=("");
    printf__99_v0 "${__AF_colored_primary585_v0__7_12}" __AMBER_ARRAY_126[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_127=("");
    printf__99_v0 " - Choose from a list of options." __AMBER_ARRAY_127[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__586_v0 "Arguments: ";
    __AF_colored_secondary586_v0__11_12="${__AF_colored_secondary586_v0}";
    __AMBER_ARRAY_128=("");
    printf__99_v0 "${__AF_colored_secondary586_v0__11_12}""
" __AMBER_ARRAY_128[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  [<options> ...]        List of options to choose from"
    echo ""
    colored_secondary__586_v0 "Flags: ";
    __AF_colored_secondary586_v0__14_12="${__AF_colored_secondary586_v0}";
    __AMBER_ARRAY_129=("");
    printf__99_v0 "${__AF_colored_secondary586_v0__14_12}""
" __AMBER_ARRAY_129[@];
    __AF_printf99_v0__14_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__14_5" > /dev/null 2>&1
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    echo ""
}
read_stdin_options__711_v0() {
    __AMBER_ARRAY_130=();
    local options=("${__AMBER_ARRAY_130[@]}")
    __AMBER_VAL_131=$( [ -t 0 ] && echo "true" || echo "false" );
    __AS=$?;
    local is_tty="${__AMBER_VAL_131}"
    if [ $([ "_${is_tty}" != "_false" ]; echo $?) != 0 ]; then
         while IFS= read -r line || [[ -n "$line" ]]; do options+=("$line"); done ;
        __AS=$?
fi
    __AF_read_stdin_options711_v0=("${options[@]}");
    return 0
}
execute_choose__712_v0() {
    local parameters=("${!1}")
    local cursor="> "
    colored_primary__585_v0 "Choose: ";
    __AF_colored_primary585_v0__18_28="${__AF_colored_primary585_v0}";
    local header="\e[1m""${__AF_colored_primary585_v0__18_28}"
    read_stdin_options__711_v0 ;
    __AF_read_stdin_options711_v0__19_19=("${__AF_read_stdin_options711_v0[@]}");
    local options=("${__AF_read_stdin_options711_v0__19_19[@]}")
    local multi=0
    local limit=$(echo  '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local page_size=10
    for param in "${parameters[@]:2:9997}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__26_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__26_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--cursor=.*\$" 0;
        __AF_match_regex17_v0__30_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__34_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--limit=.*\$" 0;
        __AF_match_regex17_v0__38_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--no-limit\$" 0;
        __AF_match_regex17_v0__46_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--page-size=.*\$" 0;
        __AF_match_regex17_v0__49_13="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__26_13" '||' "$__AF_match_regex17_v0__26_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_choose_help__681_v0 ;
            __AF_print_choose_help681_v0__27_17="$__AF_print_choose_help681_v0";
            echo "$__AF_print_choose_help681_v0__27_17" > /dev/null 2>&1
            exit 0
elif [ "$__AF_match_regex17_v0__30_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__31_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__31_30[@]}")
            cursor="${result[1]}"
elif [ "$__AF_match_regex17_v0__34_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__35_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__35_30[@]}")
            header="${result[1]}"
elif [ "$__AF_match_regex17_v0__38_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__39_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__39_30[@]}")
            parse_number__12_v0 "${result[1]}";
            __AS=$?;
if [ $__AS != 0 ]; then
                eprintf_colored__543_v0 "ERROR: Invalid limit value: ""${result[1]}""
" 31;
                __AF_eprintf_colored543_v0__41_21="$__AF_eprintf_colored543_v0";
                echo "$__AF_eprintf_colored543_v0__41_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__40_25="$__AF_parse_number12_v0";
            limit="$__AF_parse_number12_v0__40_25"
            multi=1
elif [ "$__AF_match_regex17_v0__46_13" != 0 ]; then
            multi=1
elif [ "$__AF_match_regex17_v0__49_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__50_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__50_30[@]}")
            parse_number__12_v0 "${result[1]}";
            __AS=$?;
if [ $__AS != 0 ]; then
                eprintf_colored__543_v0 "ERROR: Invalid page-size value: ""${result[1]}""
" 31;
                __AF_eprintf_colored543_v0__52_21="$__AF_eprintf_colored543_v0";
                echo "$__AF_eprintf_colored543_v0__52_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__51_29="$__AF_parse_number12_v0";
            page_size="$__AF_parse_number12_v0__51_29"
else
            __AMBER_ARRAY_132=("${param}");
            options+=("${__AMBER_ARRAY_132[@]}")
fi
done
    has_ansi_escape__538_v0 "${header}";
    __AF_has_ansi_escape538_v0__62_42="$__AF_has_ansi_escape538_v0";
    colored_primary__585_v0 "${header}";
    __AF_colored_primary585_v0__62_93="${__AF_colored_primary585_v0}";
    local display_header=$(if [ $(echo $([ "_${header}" != "_" ]; echo $?) '||' "$__AF_has_ansi_escape538_v0__62_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "${header}"; else echo "\e[1m""${__AF_colored_primary585_v0__62_93}"; fi)
    if [ ${multi} != 0 ]; then
        xyl_multi_choose__616_v0 options[@] "${cursor}" "${display_header}" ${limit} ${page_size};
        __AF_xyl_multi_choose616_v0__65_23=("${__AF_xyl_multi_choose616_v0[@]}");
        local results=("${__AF_xyl_multi_choose616_v0__65_23[@]}")
        join__6_v0 results[@] "
";
        __AF_join6_v0__66_16="${__AF_join6_v0}";
        __AF_execute_choose712_v0="${__AF_join6_v0__66_16}";
        return 0
fi
    xyl_choose__614_v0 options[@] "${cursor}" "${display_header}" ${page_size};
    __AF_xyl_choose614_v0__69_12="${__AF_xyl_choose614_v0}";
    __AF_execute_choose712_v0="${__AF_xyl_choose614_v0__69_12}";
    return 0
}
has_ansi_escape__821_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27)
    __AMBER_VAL_133=$( [[ "${text}" == *$'\e'* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_133}"
    __AF_has_ansi_escape821_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
get_key__823_v0() {
    __AMBER_VAL_134=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_134}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key823_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key823_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key823_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key823_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key823_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key823_v0="INPUT";
        return 0
else
        __AF_get_key823_v0="${var}";
        return 0
fi
}
eprintf__825_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__826_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_135=("${message}");
    eprintf__825_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_135[@];
    __AF_eprintf825_v0__44_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__44_5" > /dev/null 2>&1
}
colored__827_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored827_v0="\e[${color}m""${message}""\e[0m";
    return 0
}
remove_line__829_v0() {
    local cnt=$1
     printf '\e[2K\e[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_136=("");
    eprintf__825_v0 "\e[9999D" __AMBER_ARRAY_136[@];
    __AF_eprintf825_v0__60_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__60_5" > /dev/null 2>&1
}
remove_current_line__830_v0() {
    __AMBER_ARRAY_137=("");
    eprintf__825_v0 "\e[2K\e[9999D" __AMBER_ARRAY_137[@];
    __AF_eprintf825_v0__65_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__65_5" > /dev/null 2>&1
}
new_line__832_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_138=("");
        eprintf__825_v0 "
" __AMBER_ARRAY_138[@];
        __AF_eprintf825_v0__77_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__77_9" > /dev/null 2>&1
done
}
go_up__833_v0() {
    local cnt=$1
    __AMBER_ARRAY_139=("");
    eprintf__825_v0 "\e[${cnt}A" __AMBER_ARRAY_139[@];
    __AF_eprintf825_v0__83_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__83_5" > /dev/null 2>&1
}
go_down__834_v0() {
    local cnt=$1
    __AMBER_ARRAY_140=("");
    eprintf__825_v0 "\e[${cnt}B" __AMBER_ARRAY_140[@];
    __AF_eprintf825_v0__88_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__88_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
hide_cursor__836_v0() {
    __AMBER_ARRAY_141=("");
    eprintf__825_v0 "\e[?25l" __AMBER_ARRAY_141[@];
    __AF_eprintf825_v0__101_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__101_5" > /dev/null 2>&1
}
show_cursor__837_v0() {
    __AMBER_ARRAY_142=("");
    eprintf__825_v0 "\e[?25h" __AMBER_ARRAY_142[@];
    __AF_eprintf825_v0__105_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__105_5" > /dev/null 2>&1
}
truncate_text__838_v0() {
    local text=$1
    local max_width=$2
    __AMBER_LEN="${text}";
    if [ $(echo "${#__AMBER_LEN}" '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text838_v0="${text}";
        return 0
fi
    __AMBER_VAL_143=$( printf "%s" "${text}" | cut -c1-$(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') );
    __AS=$?;
    local truncated="${__AMBER_VAL_143}"
    __AF_truncate_text838_v0="${truncated}""...";
    return 0
}
render_tooltip__839_v0() {
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
                eprintf_colored__826_v0 "${separator}" 90;
                __AF_eprintf_colored826_v0__136_27="$__AF_eprintf_colored826_v0";
                echo "$__AF_eprintf_colored826_v0__136_27" > /dev/null 2>&1
fi
            colored__827_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored827_v0__138_41="${__AF_colored827_v0}";
            __AMBER_ARRAY_144=("");
            eprintf__825_v0 "${items[${iter}]}"" ""${__AF_colored827_v0__138_41}" __AMBER_ARRAY_144[@];
            __AF_eprintf825_v0__138_13="$__AF_eprintf825_v0";
            echo "$__AF_eprintf825_v0__138_13" > /dev/null 2>&1
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
                eprintf_colored__826_v0 "${separator}" 90;
                __AF_eprintf_colored826_v0__164_17="$__AF_eprintf_colored826_v0";
                echo "$__AF_eprintf_colored826_v0__164_17" > /dev/null 2>&1
fi
            colored__827_v0 "${action}" 2;
            __AF_colored827_v0__166_33="${__AF_colored827_v0}";
            __AMBER_ARRAY_145=("");
            eprintf__825_v0 "${key}"" ""${__AF_colored827_v0__166_33}" __AMBER_ARRAY_145[@];
            __AF_eprintf825_v0__166_13="$__AF_eprintf825_v0";
            echo "$__AF_eprintf825_v0__166_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__19__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__20__got_xylitol_colors=0
__AMBER_ARRAY_146=(3 207 159 92);
__21__primary_color=("${__AMBER_ARRAY_146[@]}")
__AMBER_ARRAY_147=(3 118 206 95);
__22__secondary_color=("${__AMBER_ARRAY_147[@]}")
__AMBER_ARRAY_148=(234 72 121 94);
__23__accent_color=("${__AMBER_ARRAY_148[@]}")
get_supports_truecolor__863_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __19__supports_truecolor="No"
        __AF_get_supports_truecolor863_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __19__supports_truecolor="No"
        __AF_get_supports_truecolor863_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __19__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor863_v0=$([ "_${__19__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__864_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__19__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb864_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
            return 0
elif [ $([ "_${__19__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__863_v0 ;
            __AF_get_supports_truecolor863_v0__50_17="$__AF_get_supports_truecolor863_v0";
            if [ "$__AF_get_supports_truecolor863_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb864_v0="\e[38;2;${r};${g};${b}m""${message}""\e[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb864_v0="${message}";
                return 0
else
                __AF_colored_rgb864_v0="\e[${fallback}m""${message}""\e[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb864_v0="${message}";
            return 0
fi
        __AF_colored_rgb864_v0="\e[${fallback}m""${message}""\e[0m";
        return 0
fi
}
background_rgb__865_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback=${fallback}
    if [ $(echo $(echo ${fallback} '>=' 30 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${fallback} '<=' 37 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        bg_fallback=$(echo ${fallback} '+' 10 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $(echo $(echo ${fallback} '>=' 90 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${fallback} '<=' 97 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        bg_fallback=$(echo ${fallback} '+' 10 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $([ "_${__19__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_background_rgb865_v0="\e[48;2;${r};${g};${b}m""${message}""\e[0m";
            return 0
elif [ $([ "_${__19__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__863_v0 ;
            __AF_get_supports_truecolor863_v0__92_17="$__AF_get_supports_truecolor863_v0";
            if [ "$__AF_get_supports_truecolor863_v0__92_17" != 0 ]; then
                                    __AF_background_rgb865_v0="\e[48;2;${r};${g};${b}m""${message}""\e[0m";
                    return 0
elif [ $(echo ${bg_fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_background_rgb865_v0="${message}";
                return 0
else
                __AF_background_rgb865_v0="\e[${bg_fallback}m""${message}""\e[0m";
                return 0
fi
else
        if [ $(echo ${bg_fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_background_rgb865_v0="${message}";
            return 0
fi
        __AF_background_rgb865_v0="\e[${bg_fallback}m""${message}""\e[0m";
        return 0
fi
}
inner_get_xylitol_colors__866_v0() {
    if [ $(echo  '!' ${__20__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_const_get__89_v0 "XYLITOL_PRIMARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__110_27="${__AF_env_const_get89_v0}";
        local primary_env="${__AF_env_const_get89_v0__110_27}"
        if [ $([ "_${primary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${primary_env}" ";";
            __AF_split3_v0__112_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__112_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_149=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __21__primary_color=("${__AMBER_ARRAY_149[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_SECONDARY_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__123_29="${__AF_env_const_get89_v0}";
        local secondary_env="${__AF_env_const_get89_v0__123_29}"
        if [ $([ "_${secondary_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${secondary_env}" ";";
            __AF_split3_v0__125_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__125_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_150=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __22__secondary_color=("${__AMBER_ARRAY_150[@]}")
fi
fi
        env_const_get__89_v0 "XYLITOL_ACCENT_COLOR";
        __AS=$?;
if [ $__AS != 0 ]; then
            echo "" > /dev/null 2>&1
fi;
        __AF_env_const_get89_v0__136_26="${__AF_env_const_get89_v0}";
        local accent_env="${__AF_env_const_get89_v0__136_26}"
        if [ $([ "_${accent_env}" == "_" ]; echo $?) != 0 ]; then
            split__3_v0 "${accent_env}" ";";
            __AF_split3_v0__138_25=("${__AF_split3_v0[@]}");
            local parts=("${__AF_split3_v0__138_25[@]}")
            if [ $(echo "${#parts[@]}" '==' 4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                parse_number__12_v0 "${parts[0]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors866_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_151=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __23__accent_color=("${__AMBER_ARRAY_151[@]}")
fi
fi
        __20__got_xylitol_colors=1
fi
}
get_xylitol_colors__867_v0() {
    inner_get_xylitol_colors__866_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors866_v0__154_5="$__AF_inner_get_xylitol_colors866_v0";
    echo "$__AF_inner_get_xylitol_colors866_v0__154_5" > /dev/null 2>&1
    __20__got_xylitol_colors=1
}
colored_primary__868_v0() {
    local message=$1
    if [ $(echo  '!' ${__20__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__867_v0 ;
        __AF_get_xylitol_colors867_v0__162_9="$__AF_get_xylitol_colors867_v0";
        echo "$__AF_get_xylitol_colors867_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__864_v0 "${message}" "${__21__primary_color[0]}" "${__21__primary_color[1]}" "${__21__primary_color[2]}" "${__21__primary_color[3]}";
    __AF_colored_rgb864_v0__164_12="${__AF_colored_rgb864_v0}";
    __AF_colored_primary868_v0="${__AF_colored_rgb864_v0__164_12}";
    return 0
}
colored_secondary__869_v0() {
    local message=$1
    if [ $(echo  '!' ${__20__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__867_v0 ;
        __AF_get_xylitol_colors867_v0__169_9="$__AF_get_xylitol_colors867_v0";
        echo "$__AF_get_xylitol_colors867_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__864_v0 "${message}" "${__22__secondary_color[0]}" "${__22__secondary_color[1]}" "${__22__secondary_color[2]}" "${__22__secondary_color[3]}";
    __AF_colored_rgb864_v0__171_12="${__AF_colored_rgb864_v0}";
    __AF_colored_secondary869_v0="${__AF_colored_rgb864_v0__171_12}";
    return 0
}
background_secondary__872_v0() {
    local message=$1
    if [ $(echo  '!' ${__20__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__867_v0 ;
        __AF_get_xylitol_colors867_v0__190_9="$__AF_get_xylitol_colors867_v0";
        echo "$__AF_get_xylitol_colors867_v0__190_9" > /dev/null 2>&1
fi
    background_rgb__865_v0 "${message}" "${__22__secondary_color[0]}" "${__22__secondary_color[1]}" "${__22__secondary_color[2]}" "${__22__secondary_color[3]}";
    __AF_background_rgb865_v0__192_12="${__AF_background_rgb865_v0}";
    __AF_background_secondary872_v0="${__AF_background_rgb865_v0__192_12}";
    return 0
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__24__got_term_size=0
__AMBER_ARRAY_152=(80 24);
__25__term_size=("${__AMBER_ARRAY_152[@]}")
get_term_size__885_v0() {
    # Query terminal size with \e[18t, response format: \e[8;rows;colst
    __AMBER_VAL_153=$( printf '\e[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_153}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size885_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size885_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size885_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_154=(${cols} ${rows});
    __25__term_size=("${__AMBER_ARRAY_154[@]}")
    __24__got_term_size=1
}
term_width__887_v0() {
    if [ $(echo  '!' ${__24__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__885_v0 ;
        __AS=$?;
        __AF_get_term_size885_v0__33_15="$__AF_get_term_size885_v0";
        echo "$__AF_get_term_size885_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width887_v0="${__25__term_size[0]}";
    return 0
}
render_confirm_options__892_v0() {
    local selected=$1
    local term_width=$2
    local small=$(echo ${term_width} '<' 30 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local yes_label=$(if [ ${small} != 0 ]; then echo " Yes "; else echo "    Yes    "; fi)
    local no_label=$(if [ ${small} != 0 ]; then echo " No "; else echo "    No    "; fi)
    local gap=$(if [ ${small} != 0 ]; then echo " "; else echo "  "; fi)
    __AMBER_ARRAY_155=("");
    eprintf__825_v0 " " __AMBER_ARRAY_155[@];
    __AF_eprintf825_v0__14_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__14_5" > /dev/null 2>&1
    if [ ${selected} != 0 ]; then
        # Yes selected
        background_secondary__872_v0 "${yes_label}";
        __AF_background_secondary872_v0__17_28="${__AF_background_secondary872_v0}";
        __AMBER_ARRAY_156=("");
        eprintf__825_v0 "\e[97m""${__AF_background_secondary872_v0__17_28}" __AMBER_ARRAY_156[@];
        __AF_eprintf825_v0__17_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_157=("");
        eprintf__825_v0 "${gap}" __AMBER_ARRAY_157[@];
        __AF_eprintf825_v0__18_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__18_9" > /dev/null 2>&1
        # No not selected (dim)
        __AMBER_ARRAY_158=("");
        eprintf__825_v0 "\e[49;37m""${no_label}""\e[0m" __AMBER_ARRAY_158[@];
        __AF_eprintf825_v0__20_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__20_9" > /dev/null 2>&1
else
        # No selected
        __AMBER_ARRAY_159=("");
        eprintf__825_v0 "\e[49;37m""${yes_label}""\e[0m" __AMBER_ARRAY_159[@];
        __AF_eprintf825_v0__23_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__23_9" > /dev/null 2>&1
        __AMBER_ARRAY_160=("");
        eprintf__825_v0 "${gap}" __AMBER_ARRAY_160[@];
        __AF_eprintf825_v0__24_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__24_9" > /dev/null 2>&1
        background_secondary__872_v0 "${no_label}";
        __AF_background_secondary872_v0__25_28="${__AF_background_secondary872_v0}";
        __AMBER_ARRAY_161=("");
        eprintf__825_v0 "\e[97m""${__AF_background_secondary872_v0__25_28}" __AMBER_ARRAY_161[@];
        __AF_eprintf825_v0__25_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__25_9" > /dev/null 2>&1
fi
}
xyl_confirm__893_v0() {
    local header=$1
    local default_yes=$2
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__836_v0 ;
    __AF_hide_cursor836_v0__42_5="$__AF_hide_cursor836_v0";
    echo "$__AF_hide_cursor836_v0__42_5" > /dev/null 2>&1
    term_width__887_v0 ;
    __AF_term_width887_v0__44_22="$__AF_term_width887_v0";
    local term_width="$__AF_term_width887_v0__44_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        truncate_text__838_v0 "${header}" ${term_width};
        __AF_truncate_text838_v0__47_17="${__AF_truncate_text838_v0}";
        __AMBER_ARRAY_162=("");
        eprintf__825_v0 "${__AF_truncate_text838_v0__47_17}""

" __AMBER_ARRAY_162[@];
        __AF_eprintf825_v0__47_9="$__AF_eprintf825_v0";
        echo "$__AF_eprintf825_v0__47_9" > /dev/null 2>&1
else
        new_line__832_v0 1;
        __AF_new_line832_v0__49_9="$__AF_new_line832_v0";
        echo "$__AF_new_line832_v0__49_9" > /dev/null 2>&1
fi
    local selected=${default_yes}
    # Render initial options
    render_confirm_options__892_v0 ${selected} ${term_width};
    __AF_render_confirm_options892_v0__55_5="$__AF_render_confirm_options892_v0";
    echo "$__AF_render_confirm_options892_v0__55_5" > /dev/null 2>&1
    __AMBER_ARRAY_163=("");
    eprintf__825_v0 "

" __AMBER_ARRAY_163[@];
    __AF_eprintf825_v0__57_5="$__AF_eprintf825_v0";
    echo "$__AF_eprintf825_v0__57_5" > /dev/null 2>&1
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    __AMBER_ARRAY_164=("←→" "select" "enter" "confirm" "y" "yes" "n" "no");
    render_tooltip__839_v0 __AMBER_ARRAY_164[@] 40 ${term_width};
    __AF_render_tooltip839_v0__59_5="$__AF_render_tooltip839_v0";
    echo "$__AF_render_tooltip839_v0__59_5" > /dev/null 2>&1
    go_up__833_v0 2;
    __AF_go_up833_v0__60_5="$__AF_go_up833_v0";
    echo "$__AF_go_up833_v0__60_5" > /dev/null 2>&1
    while :
do
        get_key__823_v0 ;
        __AF_get_key823_v0__63_19="${__AF_get_key823_v0}";
        local key="${__AF_get_key823_v0__63_19}"
        if [ $(echo $(echo $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_RIGHT" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ ${selected} != 0 ]; then
                selected=0
                __AMBER_ARRAY_165=("");
                eprintf__825_v0 "\e[9999D\e[K" __AMBER_ARRAY_165[@];
                __AF_eprintf825_v0__70_25="$__AF_eprintf825_v0";
                echo "$__AF_eprintf825_v0__70_25" > /dev/null 2>&1
                render_confirm_options__892_v0 ${selected} ${term_width};
                __AF_render_confirm_options892_v0__71_25="$__AF_render_confirm_options892_v0";
                echo "$__AF_render_confirm_options892_v0__71_25" > /dev/null 2>&1
elif [ $(echo  '!' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=1
                __AMBER_ARRAY_166=("");
                eprintf__825_v0 "\e[9999D\e[K" __AMBER_ARRAY_166[@];
                __AF_eprintf825_v0__75_25="$__AF_eprintf825_v0";
                echo "$__AF_eprintf825_v0__75_25" > /dev/null 2>&1
                render_confirm_options__892_v0 ${selected} ${term_width};
                __AF_render_confirm_options892_v0__76_25="$__AF_render_confirm_options892_v0";
                echo "$__AF_render_confirm_options892_v0__76_25" > /dev/null 2>&1
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
    go_down__834_v0 2;
    __AF_go_down834_v0__101_5="$__AF_go_down834_v0";
    echo "$__AF_go_down834_v0__101_5" > /dev/null 2>&1
    remove_line__829_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line829_v0__102_5="$__AF_remove_line829_v0";
    echo "$__AF_remove_line829_v0__102_5" > /dev/null 2>&1
    remove_current_line__830_v0 ;
    __AF_remove_current_line830_v0__103_5="$__AF_remove_current_line830_v0";
    echo "$__AF_remove_current_line830_v0__103_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__837_v0 ;
    __AF_show_cursor837_v0__106_5="$__AF_show_cursor837_v0";
    echo "$__AF_show_cursor837_v0__106_5" > /dev/null 2>&1
    __AF_xyl_confirm893_v0=${selected};
    return 0
}
print_confirm_help__929_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    colored_primary__868_v0 "confirm";
    __AF_colored_primary868_v0__7_12="${__AF_colored_primary868_v0}";
    __AMBER_ARRAY_167=("");
    printf__99_v0 "${__AF_colored_primary868_v0__7_12}" __AMBER_ARRAY_167[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_168=("");
    printf__99_v0 " - Display a Yes/No confirmation dialog." __AMBER_ARRAY_168[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__869_v0 "Flags: ";
    __AF_colored_secondary869_v0__11_12="${__AF_colored_secondary869_v0}";
    __AMBER_ARRAY_169=("");
    printf__99_v0 "${__AF_colored_secondary869_v0__11_12}""
" __AMBER_ARRAY_169[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    echo ""
}
execute_confirm__959_v0() {
    local parameters=("${!1}")
    colored_primary__868_v0 "Are you sure?";
    __AF_colored_primary868_v0__10_28="${__AF_colored_primary868_v0}";
    local header="\e[1m""${__AF_colored_primary868_v0__10_28}"
    local default_yes=1
    for param in "${parameters[@]}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__15_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__15_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--header=.*\$" 0;
        __AF_match_regex17_v0__19_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--default=.*\$" 0;
        __AF_match_regex17_v0__23_13="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__15_13" '||' "$__AF_match_regex17_v0__15_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_confirm_help__929_v0 ;
            __AF_print_confirm_help929_v0__16_17="$__AF_print_confirm_help929_v0";
            echo "$__AF_print_confirm_help929_v0__16_17" > /dev/null 2>&1
            exit 0
elif [ "$__AF_match_regex17_v0__19_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__20_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__20_30[@]}")
            header="${result[1]}"
elif [ "$__AF_match_regex17_v0__23_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__24_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__24_30[@]}")
            if [ $(echo $([ "_${result[1]}" != "_yes" ]; echo $?) '||' $([ "_${result[1]}" != "_y" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                default_yes=1
elif [ $(echo $([ "_${result[1]}" != "_no" ]; echo $?) '||' $([ "_${result[1]}" != "_n" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                default_yes=0
else
                                    eprintf_colored__826_v0 "ERROR: Invalid default value: ""${result[1]}"". Use 'yes' or 'no'.
" 31;
                    __AF_eprintf_colored826_v0__29_25="$__AF_eprintf_colored826_v0";
                    echo "$__AF_eprintf_colored826_v0__29_25" > /dev/null 2>&1
                    exit 1
fi
fi
done
    has_ansi_escape__821_v0 "${header}";
    __AF_has_ansi_escape821_v0__37_42="$__AF_has_ansi_escape821_v0";
    colored_primary__868_v0 "${header}";
    __AF_colored_primary868_v0__37_93="${__AF_colored_primary868_v0}";
    local display_header=$(if [ $(echo $([ "_${header}" != "_" ]; echo $?) '||' "$__AF_has_ansi_escape821_v0__37_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "${header}"; else echo "\e[1m""${__AF_colored_primary868_v0__37_93}"; fi)
    xyl_confirm__893_v0 "${display_header}" ${default_yes};
    __AF_xyl_confirm893_v0__38_18="$__AF_xyl_confirm893_v0";
    local result="$__AF_xyl_confirm893_v0__38_18"
    __AF_execute_confirm959_v0=$(if [ ${result} != 0 ]; then echo "yes"; else echo "no"; fi);
    return 0
}
# #!/usr/bin/env amber
__26_VERSION="0.1.0"
__27_AMBER_VERSION="0.4.0"
check_prerequirements__961_v0() {
     echo "0" | bc -l > /dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
        eprintf_colored__144_v0 "Error: " 91;
        __AF_eprintf_colored144_v0__15_9="$__AF_eprintf_colored144_v0";
        echo "$__AF_eprintf_colored144_v0__15_9" > /dev/null 2>&1
        __AMBER_ARRAY_170=("");
        eprintf__143_v0 "bc is not installed. Please install bc to use xylitol.
" __AMBER_ARRAY_170[@];
        __AF_eprintf143_v0__16_9="$__AF_eprintf143_v0";
        echo "$__AF_eprintf143_v0__16_9" > /dev/null 2>&1
        __AMBER_ARRAY_171=("");
        eprintf__143_v0 "  For Debian/Ubuntu: sudo apt install bc
" __AMBER_ARRAY_171[@];
        __AF_eprintf143_v0__17_9="$__AF_eprintf143_v0";
        echo "$__AF_eprintf143_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_172=("");
        eprintf__143_v0 "  For Fedora: sudo dnf install bc
" __AMBER_ARRAY_172[@];
        __AF_eprintf143_v0__18_9="$__AF_eprintf143_v0";
        echo "$__AF_eprintf143_v0__18_9" > /dev/null 2>&1
        __AMBER_ARRAY_173=("");
        eprintf__143_v0 "  For Arch Linux: sudo pacman -S bc
" __AMBER_ARRAY_173[@];
        __AF_eprintf143_v0__19_9="$__AF_eprintf143_v0";
        echo "$__AF_eprintf143_v0__19_9" > /dev/null 2>&1
        __AF_check_prerequirements961_v0=0;
        return 0
fi
    __AF_check_prerequirements961_v0=1;
    return 0
}
trap_cleanup__962_v0() {
     trap 'printf "\e[?25h\e[0m" >&2; stty echo < /dev/tty' EXIT ;
    __AS=$?
}
declare -r arguments=("$0" "$@")
    trap_cleanup__962_v0 ;
    __AF_trap_cleanup962_v0__30_5="$__AF_trap_cleanup962_v0";
    echo "$__AF_trap_cleanup962_v0__30_5" > /dev/null 2>&1
    check_prerequirements__961_v0 ;
    __AF_check_prerequirements961_v0__31_12="$__AF_check_prerequirements961_v0";
    if [ $(echo  '!' "$__AF_check_prerequirements961_v0__31_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit 1
fi
    get_xylitol_colors__185_v0 ;
    __AF_get_xylitol_colors185_v0__32_5="$__AF_get_xylitol_colors185_v0";
    echo "$__AF_get_xylitol_colors185_v0__32_5" > /dev/null 2>&1
    if [ $(echo $(echo $(echo $(echo "${#arguments[@]}" '<' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_--help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    print_help__255_v0 ;
            __AF_print_help255_v0__36_13="$__AF_print_help255_v0";
            echo "$__AF_print_help255_v0__36_13" > /dev/null 2>&1
elif [ $([ "_${arguments[1]}" != "_input" ]; echo $?) != 0 ]; then
                    execute_input__477_v0 arguments[@];
            __AF_execute_input477_v0__39_18="${__AF_execute_input477_v0}";
            echo "${__AF_execute_input477_v0__39_18}"
elif [ $([ "_${arguments[1]}" != "_choose" ]; echo $?) != 0 ]; then
                    execute_choose__712_v0 arguments[@];
            __AF_execute_choose712_v0__42_18="${__AF_execute_choose712_v0}";
            echo "${__AF_execute_choose712_v0__42_18}"
elif [ $([ "_${arguments[1]}" != "_confirm" ]; echo $?) != 0 ]; then
                    execute_confirm__959_v0 arguments[@];
            __AF_execute_confirm959_v0__45_26="${__AF_execute_confirm959_v0}";
            result="${__AF_execute_confirm959_v0__45_26}"
            if [ $([ "_${result}" != "_yes" ]; echo $?) != 0 ]; then
                exit 0
else
                exit 1
fi
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_version" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--version" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-v" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    colored_primary__186_v0 "xylitol.sh";
            __AF_colored_primary186_v0__52_20="${__AF_colored_primary186_v0}";
            __AMBER_ARRAY_174=("");
            printf__99_v0 "${__AF_colored_primary186_v0__52_20}" __AMBER_ARRAY_174[@];
            __AF_printf99_v0__52_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__52_13" > /dev/null 2>&1
            __AMBER_ARRAY_175=("");
            printf__99_v0 " version: " __AMBER_ARRAY_175[@];
            __AF_printf99_v0__53_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__53_13" > /dev/null 2>&1
            colored_accent__188_v0 "${__26_VERSION}";
            __AF_colored_accent188_v0__54_20="${__AF_colored_accent188_v0}";
            __AMBER_ARRAY_176=("");
            printf__99_v0 "${__AF_colored_accent188_v0__54_20}" __AMBER_ARRAY_176[@];
            __AF_printf99_v0__54_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__54_13" > /dev/null 2>&1
            echo ""
            printf_colored__142_v0 "written in Amber: " 90;
            __AF_printf_colored142_v0__56_13="$__AF_printf_colored142_v0";
            echo "$__AF_printf_colored142_v0__56_13" > /dev/null 2>&1
            printf_colored__142_v0 "  ""${__27_AMBER_VERSION}" 90;
            __AF_printf_colored142_v0__57_13="$__AF_printf_colored142_v0";
            echo "$__AF_printf_colored142_v0__57_13" > /dev/null 2>&1
else
                    print_help__255_v0 ;
            __AF_print_help255_v0__60_13="$__AF_print_help255_v0";
            echo "$__AF_print_help255_v0__60_13" > /dev/null 2>&1
            printf_colored__142_v0 "ERROR: Unknown command '""${arguments[1]}""'" 91;
            __AF_printf_colored142_v0__61_13="$__AF_printf_colored142_v0";
            echo "$__AF_printf_colored142_v0__61_13" > /dev/null 2>&1
fi
