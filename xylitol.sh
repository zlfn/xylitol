#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-11-28 05:52:30
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
starts_with__20_v0() {
    local text=$1
    local prefix=$2
    __AMBER_VAL_4=$( if [[ "${text}" == "${prefix}"* ]]; then
    echo 1
  fi );
    __AS=$?;
    local result="${__AMBER_VAL_4}"
    __AF_starts_with20_v0=$([ "_${result}" != "_1" ]; echo $?);
    return 0
}

env_const_get__89_v0() {
    local name=$1
    __AMBER_VAL_5=$( echo ${!name} );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_env_const_get89_v0=''
return $__AS
fi;
    __AF_env_const_get89_v0="${__AMBER_VAL_5}";
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
    __AMBER_ARRAY_6=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m
" __AMBER_ARRAY_6[@];
    __AF_printf99_v0__142_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__142_5" > /dev/null 2>&1
}
# Perl Extensions Utilities
__AMBER_VAL_7=$( echo "$XYLITOL_USE_PERL" );
__AS=$?;
__0__perl_disabled=$([ "_${__AMBER_VAL_7}" != "_No" ]; echo $?)
__AMBER_VAL_8=$( command -v perl > /dev/null && echo 0 || echo 1 );
__AS=$?;
__1__perl_available=$(echo $(echo  '!' ${__0__perl_disabled} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${__AMBER_VAL_8}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
# // IO Functions /////
printf_colored__148_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    __AMBER_ARRAY_9=("${message}");
    printf__99_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_9[@];
    __AF_printf99_v0__29_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__29_5" > /dev/null 2>&1
}
eprintf__149_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__150_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_10=("${message}");
    eprintf__149_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_10[@];
    __AF_eprintf149_v0__39_5="$__AF_eprintf149_v0";
    echo "$__AF_eprintf149_v0__39_5" > /dev/null 2>&1
}
colored__151_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored151_v0="\x1b[${color}m""${message}""\x1b[0m";
    return 0
}
# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__2__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__3__got_xylitol_colors=0
__AMBER_ARRAY_11=(3 207 159 92);
__4__primary_color=("${__AMBER_ARRAY_11[@]}")
__AMBER_ARRAY_12=(3 118 206 95);
__5__secondary_color=("${__AMBER_ARRAY_12[@]}")
__AMBER_ARRAY_13=(234 72 121 94);
__6__accent_color=("${__AMBER_ARRAY_13[@]}")
get_supports_truecolor__200_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __2__supports_truecolor="No"
        __AF_get_supports_truecolor200_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __2__supports_truecolor="No"
        __AF_get_supports_truecolor200_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __2__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor200_v0=$([ "_${__2__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__201_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__2__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb201_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__2__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__200_v0 ;
            __AF_get_supports_truecolor200_v0__50_17="$__AF_get_supports_truecolor200_v0";
            if [ "$__AF_get_supports_truecolor200_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb201_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb201_v0="${message}";
                return 0
else
                __AF_colored_rgb201_v0="\x1b[${fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb201_v0="${message}";
            return 0
fi
        __AF_colored_rgb201_v0="\x1b[${fallback}m""${message}""\x1b[0m";
        return 0
fi
}
inner_get_xylitol_colors__203_v0() {
    if [ $(echo  '!' ${__3__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_14=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __4__primary_color=("${__AMBER_ARRAY_14[@]}")
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
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_15=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __5__secondary_color=("${__AMBER_ARRAY_15[@]}")
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
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors203_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_16=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __6__accent_color=("${__AMBER_ARRAY_16[@]}")
fi
fi
        __3__got_xylitol_colors=1
fi
}
get_xylitol_colors__204_v0() {
    inner_get_xylitol_colors__203_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors203_v0__154_5="$__AF_inner_get_xylitol_colors203_v0";
    echo "$__AF_inner_get_xylitol_colors203_v0__154_5" > /dev/null 2>&1
    __3__got_xylitol_colors=1
}
colored_primary__205_v0() {
    local message=$1
    if [ $(echo  '!' ${__3__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__204_v0 ;
        __AF_get_xylitol_colors204_v0__162_9="$__AF_get_xylitol_colors204_v0";
        echo "$__AF_get_xylitol_colors204_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__201_v0 "${message}" "${__4__primary_color[0]}" "${__4__primary_color[1]}" "${__4__primary_color[2]}" "${__4__primary_color[3]}";
    __AF_colored_rgb201_v0__164_12="${__AF_colored_rgb201_v0}";
    __AF_colored_primary205_v0="${__AF_colored_rgb201_v0__164_12}";
    return 0
}
colored_secondary__206_v0() {
    local message=$1
    if [ $(echo  '!' ${__3__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__204_v0 ;
        __AF_get_xylitol_colors204_v0__169_9="$__AF_get_xylitol_colors204_v0";
        echo "$__AF_get_xylitol_colors204_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__201_v0 "${message}" "${__5__secondary_color[0]}" "${__5__secondary_color[1]}" "${__5__secondary_color[2]}" "${__5__secondary_color[3]}";
    __AF_colored_rgb201_v0__171_12="${__AF_colored_rgb201_v0}";
    __AF_colored_secondary206_v0="${__AF_colored_rgb201_v0__171_12}";
    return 0
}
colored_accent__207_v0() {
    local message=$1
    if [ $(echo  '!' ${__3__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__204_v0 ;
        __AF_get_xylitol_colors204_v0__176_9="$__AF_get_xylitol_colors204_v0";
        echo "$__AF_get_xylitol_colors204_v0__176_9" > /dev/null 2>&1
fi
    colored_rgb__201_v0 "${message}" "${__6__accent_color[0]}" "${__6__accent_color[1]}" "${__6__accent_color[2]}" "${__6__accent_color[3]}";
    __AF_colored_rgb201_v0__178_12="${__AF_colored_rgb201_v0}";
    __AF_colored_accent207_v0="${__AF_colored_rgb201_v0__178_12}";
    return 0
}
print_help__280_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    colored_primary__205_v0 "Xylitol";
    __AF_colored_primary205_v0__8_24="${__AF_colored_primary205_v0}";
    __AMBER_ARRAY_17=("");
    printf__99_v0 "\x1b[1m""${__AF_colored_primary205_v0__8_24}" __AMBER_ARRAY_17[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    __AMBER_ARRAY_18=("");
    printf__99_v0 " - A tool for " __AMBER_ARRAY_18[@];
    __AF_printf99_v0__9_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__9_5" > /dev/null 2>&1
    colored_primary__205_v0 "fresh";
    __AF_colored_primary205_v0__10_12="${__AF_colored_primary205_v0}";
    __AMBER_ARRAY_19=("");
    printf__99_v0 "${__AF_colored_primary205_v0__10_12}" __AMBER_ARRAY_19[@];
    __AF_printf99_v0__10_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__10_5" > /dev/null 2>&1
    __AMBER_ARRAY_20=("");
    printf__99_v0 " shell scripts." __AMBER_ARRAY_20[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__206_v0 "Flags: ";
    __AF_colored_secondary206_v0__14_12="${__AF_colored_secondary206_v0}";
    __AMBER_ARRAY_21=("");
    printf__99_v0 "${__AF_colored_secondary206_v0__14_12}""
" __AMBER_ARRAY_21[@];
    __AF_printf99_v0__14_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__14_5" > /dev/null 2>&1
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    echo ""
    colored_secondary__206_v0 "Commands: ";
    __AF_colored_secondary206_v0__18_12="${__AF_colored_secondary206_v0}";
    __AMBER_ARRAY_22=("");
    printf__99_v0 "${__AF_colored_secondary206_v0__18_12}""
" __AMBER_ARRAY_22[@];
    __AF_printf99_v0__18_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__18_5" > /dev/null 2>&1
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    echo ""
    colored_secondary__206_v0 "Envs: ";
    __AF_colored_secondary206_v0__24_12="${__AF_colored_secondary206_v0}";
    __AMBER_ARRAY_23=("");
    printf__99_v0 "${__AF_colored_secondary206_v0__24_12}""
" __AMBER_ARRAY_23[@];
    __AF_printf99_v0__24_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__24_5" > /dev/null 2>&1
    colored__151_v0 "(\"Yes\" or \"No\", default: Yes)" 90;
    __AF_colored151_v0__25_78="${__AF_colored151_v0}";
    __AMBER_ARRAY_24=("");
    printf__99_v0 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${__AF_colored151_v0__25_78}""
" __AMBER_ARRAY_24[@];
    __AF_printf99_v0__25_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__25_5" > /dev/null 2>&1
    colored__151_v0 "(\"Yes\" or \"No\", default: Yes)" 90;
    __AF_colored151_v0__26_78="${__AF_colored151_v0}";
    __AMBER_ARRAY_25=("");
    printf__99_v0 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${__AF_colored151_v0__26_78}""
" __AMBER_ARRAY_25[@];
    __AF_printf99_v0__26_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__26_5" > /dev/null 2>&1
    colored__151_v0 "(default: 3;207;159;92)" 90;
    __AF_colored151_v0__27_68="${__AF_colored151_v0}";
    __AMBER_ARRAY_26=("");
    printf__99_v0 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${__AF_colored151_v0__27_68}""
" __AMBER_ARRAY_26[@];
    __AF_printf99_v0__27_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__27_5" > /dev/null 2>&1
    colored__151_v0 "(default: 3;118;206;95)" 90;
    __AF_colored151_v0__28_70="${__AF_colored151_v0}";
    __AMBER_ARRAY_27=("");
    printf__99_v0 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${__AF_colored151_v0__28_70}""
" __AMBER_ARRAY_27[@];
    __AF_printf99_v0__28_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__28_5" > /dev/null 2>&1
    colored__151_v0 "(default: 234;72;121;94)" 90;
    __AF_colored151_v0__29_67="${__AF_colored151_v0}";
    __AMBER_ARRAY_28=("");
    printf__99_v0 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${__AF_colored151_v0__29_67}""
" __AMBER_ARRAY_28[@];
    __AF_printf99_v0__29_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__29_5" > /dev/null 2>&1
    echo ""
    colored_accent__207_v0 "./xylitol.sh <command> --help";
    __AF_colored_accent207_v0__31_21="${__AF_colored_accent207_v0}";
    __AMBER_ARRAY_29=("");
    printf__99_v0 "Run ""${__AF_colored_accent207_v0__31_21}"" for more information on a command.
" __AMBER_ARRAY_29[@];
    __AF_printf99_v0__31_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__31_5" > /dev/null 2>&1
}
math_floor__309_v0() {
    local number=$1
    __AMBER_VAL_30=$( echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' );
    __AS=$?;
    __AF_math_floor309_v0="${__AMBER_VAL_30}";
    return 0
}
math_ceil__310_v0() {
    local number=$1
    math_floor__309_v0 ${number};
    __AF_math_floor309_v0__26_12="$__AF_math_floor309_v0";
    __AF_math_ceil310_v0=$(echo "$__AF_math_floor309_v0__26_12" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
# Perl Extensions Utilities
__AMBER_VAL_31=$( echo "$XYLITOL_USE_PERL" );
__AS=$?;
__7__perl_disabled=$([ "_${__AMBER_VAL_31}" != "_No" ]; echo $?)
__AMBER_VAL_32=$( command -v perl > /dev/null && echo 0 || echo 1 );
__AS=$?;
__8__perl_available=$(echo $(echo  '!' ${__7__perl_disabled} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${__AMBER_VAL_32}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
perl_get_cjk_width__347_v0() {
    local text=$1
    if [ $(echo  '!' ${__8__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_get_cjk_width347_v0='';
        return 1
fi
    __AMBER_VAL_33=$( perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width347_v0=''
return $__AS
fi;
    local width_str="${__AMBER_VAL_33}"
    parse_number__12_v0 "${width_str}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width347_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__14_17="$__AF_parse_number12_v0";
    local width="$__AF_parse_number12_v0__14_17"
    __AF_perl_get_cjk_width347_v0=${width};
    return 0
}
perl_truncate_cjk__348_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo  '!' ${__8__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_truncate_cjk348_v0='';
        return 1
fi
    __AMBER_VAL_34=$( perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_truncate_cjk348_v0=''
return $__AS
fi;
    local result="${__AMBER_VAL_34}"
    __AF_perl_truncate_cjk348_v0="${result}";
    return 0
}
# // IO Functions /////
get_char__353_v0() {
    __AMBER_VAL_35=$( read -n 1 key < /dev/tty; printf "%s" "$key" );
    __AS=$?;
    local char="${__AMBER_VAL_35}"
    __AF_get_char353_v0="${char}";
    return 0
}
eprintf__356_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__357_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_36=("${message}");
    eprintf__356_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_36[@];
    __AF_eprintf356_v0__39_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__39_5" > /dev/null 2>&1
}
colored__358_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored358_v0="\x1b[${color}m""${message}""\x1b[0m";
    return 0
}
remove__359_v0() {
    local cnt=$1
     printf '%0.s\b \b' $(seq 1 ${cnt}) >&2 ;
    __AS=$?
}
remove_line__360_v0() {
    local cnt=$1
     printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_37=("");
    eprintf__356_v0 "\x1b[9999D" __AMBER_ARRAY_37[@];
    __AF_eprintf356_v0__55_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__55_5" > /dev/null 2>&1
}
remove_current_line__361_v0() {
    __AMBER_ARRAY_38=("");
    eprintf__356_v0 "\x1b[2K\x1b[9999D" __AMBER_ARRAY_38[@];
    __AF_eprintf356_v0__60_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__60_5" > /dev/null 2>&1
}
new_line__363_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_39=("");
        eprintf__356_v0 "
" __AMBER_ARRAY_39[@];
        __AF_eprintf356_v0__72_9="$__AF_eprintf356_v0";
        echo "$__AF_eprintf356_v0__72_9" > /dev/null 2>&1
done
}
go_up__364_v0() {
    local cnt=$1
    __AMBER_ARRAY_40=("");
    eprintf__356_v0 "\x1b[${cnt}A" __AMBER_ARRAY_40[@];
    __AF_eprintf356_v0__78_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__78_5" > /dev/null 2>&1
}
go_down__365_v0() {
    local cnt=$1
    __AMBER_ARRAY_41=("");
    eprintf__356_v0 "\x1b[${cnt}B" __AMBER_ARRAY_41[@];
    __AF_eprintf356_v0__83_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__83_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
# / Text Utilities /////
has_ansi_escape__369_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    __AMBER_VAL_42=$( [[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_42}"
    __AF_has_ansi_escape369_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
escape_ansi__370_v0() {
    local text=$1
    __AMBER_VAL_43=$( printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g' );
    __AS=$?;
    __AF_escape_ansi370_v0="${__AMBER_VAL_43}";
    return 0
}
strip_ansi__371_v0() {
    local text=$1
    __AMBER_VAL_44=$( printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g' );
    __AS=$?;
    __AF_strip_ansi371_v0="${__AMBER_VAL_44}";
    return 0
}
is_all_ascii__372_v0() {
    local text=$1
    __AMBER_VAL_45=$( printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1 );
    __AS=$?;
    local result="${__AMBER_VAL_45}"
    __AF_is_all_ascii372_v0=$([ "_${result}" != "_0" ]; echo $?);
    return 0
}
get_visible_len__373_v0() {
    local text=$1
    strip_ansi__371_v0 "${text}";
    __AF_strip_ansi371_v0__135_20="${__AF_strip_ansi371_v0}";
    local stripped="${__AF_strip_ansi371_v0__135_20}"
    # Check if text is all ASCII
    is_all_ascii__372_v0 "${stripped}";
    __AF_is_all_ascii372_v0__137_12="$__AF_is_all_ascii372_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii372_v0__137_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Try using perl
        perl_get_cjk_width__347_v0 "${stripped}";
        __AS=$?;
if [ $__AS != 0 ]; then
            __AMBER_LEN="${stripped}";
            __AF_get_visible_len373_v0="${#__AMBER_LEN}";
            return 0
fi;
        __AF_perl_get_cjk_width347_v0__139_16="$__AF_perl_get_cjk_width347_v0";
        __AF_get_visible_len373_v0="$__AF_perl_get_cjk_width347_v0__139_16";
        return 0
else
        __AMBER_LEN="${stripped}";
        __AF_get_visible_len373_v0="${#__AMBER_LEN}";
        return 0
fi
}
truncate_text__374_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__373_v0 "${text}";
    __AF_get_visible_len373_v0__150_23="$__AF_get_visible_len373_v0";
    local visible_len="$__AF_get_visible_len373_v0__150_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text374_v0="${text}";
        return 0
fi
    is_all_ascii__372_v0 "${text}";
    __AF_is_all_ascii372_v0__154_12="$__AF_is_all_ascii372_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii372_v0__154_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        perl_truncate_cjk__348_v0 "${text}" ${max_width};
        __AS=$?;
if [ $__AS != 0 ]; then
             printf "%s" "${text}" | cut -c1-${max_width} ;
            __AS=$?
fi;
        __AF_perl_truncate_cjk348_v0__155_16="${__AF_perl_truncate_cjk348_v0}";
        __AF_truncate_text374_v0="${__AF_perl_truncate_cjk348_v0__155_16}";
        return 0
fi
    __AMBER_VAL_46=$( printf "%s" "${text}" | cut -c1-${max_width} );
    __AS=$?;
    __AF_truncate_text374_v0="${__AMBER_VAL_46}";
    return 0
}
truncate_ansi__375_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__369_v0 "${text}";
    __AF_has_ansi_escape369_v0__166_12="$__AF_has_ansi_escape369_v0";
    if [ $(echo  '!' "$__AF_has_ansi_escape369_v0__166_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        truncate_text__374_v0 "${text}" ${max_width};
        __AF_truncate_text374_v0__167_16="${__AF_truncate_text374_v0}";
        __AF_truncate_ansi375_v0="${__AF_truncate_text374_v0__167_16}";
        return 0
fi
    # Check if text starts with \x1b[
    __AMBER_VAL_47=$( [[ "${text}" == '\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local starts_with_ansi="${__AMBER_VAL_47}"
    # Replace \x1b[ with newline, then split
    __AMBER_VAL_48=$( t="${text}"; printf '%s' "${t//\\x1b[/
}" );
    __AS=$?;
    local replaced="${__AMBER_VAL_48}"
    split__3_v0 "${replaced}" "
";
    __AF_split3_v0__176_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__176_17[@]}")
    local result=""
    local remaining_width=${max_width}
    for idx in $(seq 0 $(echo "${#parts[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local part="${parts[${idx}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ $(echo $(echo ${idx} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${starts_with_ansi}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                truncate_text__374_v0 "${part}" ${remaining_width};
                __AF_truncate_text374_v0__188_33="${__AF_truncate_text374_v0}";
                local truncated="${__AF_truncate_text374_v0__188_33}"
                result+="${truncated}"
                get_visible_len__373_v0 "${truncated}";
                __AF_get_visible_len373_v0__190_36="$__AF_get_visible_len373_v0";
                remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len373_v0__190_36" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
            # Part is "ANSIparams m text" format - find first 'm'
            __AMBER_VAL_49=$( __p="${part}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done );
            __AS=$?;
            local m_idx="${__AMBER_VAL_49}"
            if [ $([ "_${m_idx}" == "_" ]; echo $?) != 0 ]; then
                # Reconstruct ANSI sequence
                __AMBER_VAL_50=$( __p="${part}"; printf "%s" "${__p:0:${m_idx}}" );
                __AS=$?;
                local ansi_params="${__AMBER_VAL_50}"
                result+="\\x1b[""${ansi_params}""m"
                # Rest is text content
                parse_number__12_v0 "${m_idx}";
                __AS=$?;
                __AF_parse_number12_v0__201_39="$__AF_parse_number12_v0";
                local m_idx_num="$__AF_parse_number12_v0__201_39"
                local text_start=$(echo ${m_idx_num} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                __AMBER_VAL_51=$( __p="${part}"; printf "%s" "${__p:${text_start}}" );
                __AS=$?;
                local text_part="${__AMBER_VAL_51}"
                if [ $(echo $([ "_${text_part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__374_v0 "${text_part}" ${remaining_width};
                    __AF_truncate_text374_v0__205_37="${__AF_truncate_text374_v0}";
                    local truncated="${__AF_truncate_text374_v0__205_37}"
                    result+="${truncated}"
                    get_visible_len__373_v0 "${truncated}";
                    __AF_get_visible_len373_v0__207_40="$__AF_get_visible_len373_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len373_v0__207_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
                # No 'm' found, treat as text
                if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__374_v0 "${part}" ${remaining_width};
                    __AF_truncate_text374_v0__212_37="${__AF_truncate_text374_v0}";
                    local truncated="${__AF_truncate_text374_v0__212_37}"
                    result+="${truncated}"
                    get_visible_len__373_v0 "${truncated}";
                    __AF_get_visible_len373_v0__214_40="$__AF_get_visible_len373_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len373_v0__214_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
fi
fi
done
    __AF_truncate_ansi375_v0="${result}";
    return 0
}
cutoff_text__376_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__373_v0 "${text}";
    __AF_get_visible_len373_v0__226_23="$__AF_get_visible_len373_v0";
    local visible_len="$__AF_get_visible_len373_v0__226_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_cutoff_text376_v0="${text}";
        return 0
fi
    truncate_ansi__375_v0 "${text}" $(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_truncate_ansi375_v0__230_12="${__AF_truncate_ansi375_v0}";
    __AF_cutoff_text376_v0="${__AF_truncate_ansi375_v0__230_12}""...";
    return 0
}
# // Application Utilities /////
render_tooltip__377_v0() {
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
                eprintf_colored__357_v0 "${separator}" 90;
                __AF_eprintf_colored357_v0__253_27="$__AF_eprintf_colored357_v0";
                echo "$__AF_eprintf_colored357_v0__253_27" > /dev/null 2>&1
fi
            colored__358_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored358_v0__255_41="${__AF_colored358_v0}";
            __AMBER_ARRAY_52=("");
            eprintf__356_v0 "${items[${iter}]}"" ""${__AF_colored358_v0__255_41}" __AMBER_ARRAY_52[@];
            __AF_eprintf356_v0__255_13="$__AF_eprintf356_v0";
            echo "$__AF_eprintf356_v0__255_13" > /dev/null 2>&1
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
                eprintf_colored__357_v0 "${separator}" 90;
                __AF_eprintf_colored357_v0__281_17="$__AF_eprintf_colored357_v0";
                echo "$__AF_eprintf_colored357_v0__281_17" > /dev/null 2>&1
fi
            colored__358_v0 "${action}" 2;
            __AF_colored358_v0__283_33="${__AF_colored358_v0}";
            __AMBER_ARRAY_53=("");
            eprintf__356_v0 "${key}"" ""${__AF_colored358_v0__283_33}" __AMBER_ARRAY_53[@];
            __AF_eprintf356_v0__283_13="$__AF_eprintf356_v0";
            echo "$__AF_eprintf356_v0__283_13" > /dev/null 2>&1
            current_len=$(echo ${current_len} '+' ${needed} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            first=0
            iter=$(echo ${iter} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
fi
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__9__got_term_size=0
__AMBER_ARRAY_54=(80 24);
__10__term_size=("${__AMBER_ARRAY_54[@]}")
get_term_size__405_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    __AMBER_VAL_55=$( printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_55}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size405_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size405_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size405_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_56=(${cols} ${rows});
    __10__term_size=("${__AMBER_ARRAY_56[@]}")
    __9__got_term_size=1
}
term_width__407_v0() {
    if [ $(echo  '!' ${__9__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__405_v0 ;
        __AS=$?;
        __AF_get_term_size405_v0__33_15="$__AF_get_term_size405_v0";
        echo "$__AF_get_term_size405_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width407_v0="${__10__term_size[0]}";
    return 0
}
xyl_input__412_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
     stty -echo < /dev/tty ;
    __AS=$?
    term_width__407_v0 ;
    __AF_term_width407_v0__21_22="$__AF_term_width407_v0";
    local term_width="$__AF_term_width407_v0__21_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        cutoff_text__376_v0 "${header}" ${term_width};
        __AF_cutoff_text376_v0__24_17="${__AF_cutoff_text376_v0}";
        __AMBER_ARRAY_57=("");
        eprintf__356_v0 "${__AF_cutoff_text376_v0__24_17}""
" __AMBER_ARRAY_57[@];
        __AF_eprintf356_v0__24_9="$__AF_eprintf356_v0";
        echo "$__AF_eprintf356_v0__24_9" > /dev/null 2>&1
fi
    new_line__363_v0 2;
    __AF_new_line363_v0__27_5="$__AF_new_line363_v0";
    echo "$__AF_new_line363_v0__27_5" > /dev/null 2>&1
    # "enter submit" = 12
    __AMBER_ARRAY_58=("enter" "submit");
    render_tooltip__377_v0 __AMBER_ARRAY_58[@] 12 ${term_width};
    __AF_render_tooltip377_v0__29_5="$__AF_render_tooltip377_v0";
    echo "$__AF_render_tooltip377_v0__29_5" > /dev/null 2>&1
    go_up__364_v0 2;
    __AF_go_up364_v0__30_5="$__AF_go_up364_v0";
    echo "$__AF_go_up364_v0__30_5" > /dev/null 2>&1
    __AMBER_ARRAY_59=("");
    eprintf__356_v0 "\x1b[99999D" __AMBER_ARRAY_59[@];
    __AF_eprintf356_v0__31_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__31_5" > /dev/null 2>&1
    __AMBER_ARRAY_60=("");
    eprintf__356_v0 "${prompt}" __AMBER_ARRAY_60[@];
    __AF_eprintf356_v0__33_5="$__AF_eprintf356_v0";
    echo "$__AF_eprintf356_v0__33_5" > /dev/null 2>&1
    eprintf_colored__357_v0 "${placeholder}" 90;
    __AF_eprintf_colored357_v0__34_5="$__AF_eprintf_colored357_v0";
    echo "$__AF_eprintf_colored357_v0__34_5" > /dev/null 2>&1
    get_char__353_v0 ;
    __AF_get_char353_v0__36_16="${__AF_get_char353_v0}";
    local char="${__AF_get_char353_v0__36_16}"
    __AMBER_LEN="${prompt}";
    remove__359_v0 "${#__AMBER_LEN}";
    __AF_remove359_v0__37_5="$__AF_remove359_v0";
    echo "$__AF_remove359_v0__37_5" > /dev/null 2>&1
    __AMBER_LEN="${placeholder}";
    remove__359_v0 $(echo "${#__AMBER_LEN}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove359_v0__38_5="$__AF_remove359_v0";
    echo "$__AF_remove359_v0__38_5" > /dev/null 2>&1
    local text=""
    if [ $(echo  '!' ${password} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_61=$( read -e -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_61}"
else
         stty echo < /dev/tty ;
        __AS=$?
        __AMBER_VAL_62=$( read -es -i ${char} -p "${prompt}" text < /dev/tty; printf "%s" "$text" );
        __AS=$?;
        text="${__AMBER_VAL_62}"
fi
     stty -echo < /dev/tty ;
    __AS=$?
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__373_v0 "${prompt}""${text}";
    __AF_get_visible_len373_v0__52_29="$__AF_get_visible_len373_v0";
    local input_display_len="$__AF_get_visible_len373_v0__52_29"
    math_ceil__310_v0 $(echo ${input_display_len} '/' ${term_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_ceil310_v0__53_23="$__AF_math_ceil310_v0";
    local input_lines="$__AF_math_ceil310_v0__53_23"
    if [ $(echo ${input_lines} '<' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__365_v0 $(echo 2 '-' ${input_lines} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_down365_v0__56_9="$__AF_go_down365_v0";
        echo "$__AF_go_down365_v0__56_9" > /dev/null 2>&1
        remove_line__360_v0 2;
        __AF_remove_line360_v0__57_9="$__AF_remove_line360_v0";
        echo "$__AF_remove_line360_v0__57_9" > /dev/null 2>&1
        remove_current_line__361_v0 ;
        __AF_remove_current_line361_v0__58_9="$__AF_remove_current_line361_v0";
        echo "$__AF_remove_current_line361_v0__58_9" > /dev/null 2>&1
fi
    if [ $(echo ${input_lines} '>=' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        remove_line__360_v0 ${input_lines};
        __AF_remove_line360_v0__61_9="$__AF_remove_line360_v0";
        echo "$__AF_remove_line360_v0__61_9" > /dev/null 2>&1
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        remove_line__360_v0 1;
        __AF_remove_line360_v0__64_9="$__AF_remove_line360_v0";
        echo "$__AF_remove_line360_v0__64_9" > /dev/null 2>&1
        remove_current_line__361_v0 ;
        __AF_remove_current_line361_v0__65_9="$__AF_remove_current_line361_v0";
        echo "$__AF_remove_current_line361_v0__65_9" > /dev/null 2>&1
fi
     stty echo < /dev/tty ;
    __AS=$?
    __AF_xyl_input412_v0="${text}";
    return 0
}
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__11__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__12__got_xylitol_colors=0
__AMBER_ARRAY_63=(3 207 159 92);
__13__primary_color=("${__AMBER_ARRAY_63[@]}")
__AMBER_ARRAY_64=(3 118 206 95);
__14__secondary_color=("${__AMBER_ARRAY_64[@]}")
__AMBER_ARRAY_65=(234 72 121 94);
__15__accent_color=("${__AMBER_ARRAY_65[@]}")
get_supports_truecolor__443_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __11__supports_truecolor="No"
        __AF_get_supports_truecolor443_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __11__supports_truecolor="No"
        __AF_get_supports_truecolor443_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __11__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor443_v0=$([ "_${__11__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__444_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__11__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb444_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__11__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__443_v0 ;
            __AF_get_supports_truecolor443_v0__50_17="$__AF_get_supports_truecolor443_v0";
            if [ "$__AF_get_supports_truecolor443_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb444_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb444_v0="${message}";
                return 0
else
                __AF_colored_rgb444_v0="\x1b[${fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb444_v0="${message}";
            return 0
fi
        __AF_colored_rgb444_v0="\x1b[${fallback}m""${message}""\x1b[0m";
        return 0
fi
}
inner_get_xylitol_colors__446_v0() {
    if [ $(echo  '!' ${__12__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_66=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __13__primary_color=("${__AMBER_ARRAY_66[@]}")
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
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_67=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __14__secondary_color=("${__AMBER_ARRAY_67[@]}")
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
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors446_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_68=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __15__accent_color=("${__AMBER_ARRAY_68[@]}")
fi
fi
        __12__got_xylitol_colors=1
fi
}
get_xylitol_colors__447_v0() {
    inner_get_xylitol_colors__446_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors446_v0__154_5="$__AF_inner_get_xylitol_colors446_v0";
    echo "$__AF_inner_get_xylitol_colors446_v0__154_5" > /dev/null 2>&1
    __12__got_xylitol_colors=1
}
colored_primary__448_v0() {
    local message=$1
    if [ $(echo  '!' ${__12__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__447_v0 ;
        __AF_get_xylitol_colors447_v0__162_9="$__AF_get_xylitol_colors447_v0";
        echo "$__AF_get_xylitol_colors447_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__444_v0 "${message}" "${__13__primary_color[0]}" "${__13__primary_color[1]}" "${__13__primary_color[2]}" "${__13__primary_color[3]}";
    __AF_colored_rgb444_v0__164_12="${__AF_colored_rgb444_v0}";
    __AF_colored_primary448_v0="${__AF_colored_rgb444_v0__164_12}";
    return 0
}
colored_secondary__449_v0() {
    local message=$1
    if [ $(echo  '!' ${__12__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__447_v0 ;
        __AF_get_xylitol_colors447_v0__169_9="$__AF_get_xylitol_colors447_v0";
        echo "$__AF_get_xylitol_colors447_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__444_v0 "${message}" "${__14__secondary_color[0]}" "${__14__secondary_color[1]}" "${__14__secondary_color[2]}" "${__14__secondary_color[3]}";
    __AF_colored_rgb444_v0__171_12="${__AF_colored_rgb444_v0}";
    __AF_colored_secondary449_v0="${__AF_colored_rgb444_v0__171_12}";
    return 0
}
print_input_help__463_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    colored_primary__448_v0 "input";
    __AF_colored_primary448_v0__7_12="${__AF_colored_primary448_v0}";
    __AMBER_ARRAY_69=("");
    printf__99_v0 "${__AF_colored_primary448_v0__7_12}" __AMBER_ARRAY_69[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_70=("");
    printf__99_v0 " - Prompt for some input from the user." __AMBER_ARRAY_70[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__449_v0 "Flags: ";
    __AF_colored_secondary449_v0__11_12="${__AF_colored_secondary449_v0}";
    __AMBER_ARRAY_71=("");
    printf__99_v0 "${__AF_colored_secondary449_v0__11_12}""
" __AMBER_ARRAY_71[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    echo ""
}
execute_input__527_v0() {
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
            print_input_help__463_v0 ;
            __AF_print_input_help463_v0__15_13="$__AF_print_input_help463_v0";
            echo "$__AF_print_input_help463_v0__15_13" > /dev/null 2>&1
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
    has_ansi_escape__369_v0 "${header}";
    __AF_has_ansi_escape369_v0__35_42="$__AF_has_ansi_escape369_v0";
    escape_ansi__370_v0 "${header}";
    __AF_escape_ansi370_v0__35_71="${__AF_escape_ansi370_v0}";
    colored_primary__448_v0 "${header}";
    __AF_colored_primary448_v0__35_109="${__AF_colored_primary448_v0}";
    local display_header=$(if [ $(echo $([ "_${header}" != "_" ]; echo $?) '||' "$__AF_has_ansi_escape369_v0__35_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "${__AF_escape_ansi370_v0__35_71}"; else echo "\\x1b[1m""${__AF_colored_primary448_v0__35_109}"; fi)
    xyl_input__412_v0 "${prompt}" "${placeholder}" "${display_header}" ${password};
    __AF_xyl_input412_v0__36_12="${__AF_xyl_input412_v0}";
    __AF_execute_input527_v0="${__AF_xyl_input412_v0__36_12}";
    return 0
}
# Perl Extensions Utilities
__AMBER_VAL_72=$( echo "$XYLITOL_USE_PERL" );
__AS=$?;
__16__perl_disabled=$([ "_${__AMBER_VAL_72}" != "_No" ]; echo $?)
__AMBER_VAL_73=$( command -v perl > /dev/null && echo 0 || echo 1 );
__AS=$?;
__17__perl_available=$(echo $(echo  '!' ${__16__perl_disabled} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${__AMBER_VAL_73}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
perl_get_cjk_width__589_v0() {
    local text=$1
    if [ $(echo  '!' ${__17__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_get_cjk_width589_v0='';
        return 1
fi
    __AMBER_VAL_74=$( perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width589_v0=''
return $__AS
fi;
    local width_str="${__AMBER_VAL_74}"
    parse_number__12_v0 "${width_str}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width589_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__14_17="$__AF_parse_number12_v0";
    local width="$__AF_parse_number12_v0__14_17"
    __AF_perl_get_cjk_width589_v0=${width};
    return 0
}
perl_truncate_cjk__590_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo  '!' ${__17__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_truncate_cjk590_v0='';
        return 1
fi
    __AMBER_VAL_75=$( perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_truncate_cjk590_v0=''
return $__AS
fi;
    local result="${__AMBER_VAL_75}"
    __AF_perl_truncate_cjk590_v0="${result}";
    return 0
}
# // IO Functions /////
get_key__596_v0() {
    __AMBER_VAL_76=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_76}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key596_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key596_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key596_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key596_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key596_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key596_v0="INPUT";
        return 0
else
        __AF_get_key596_v0="${var}";
        return 0
fi
}
eprintf__598_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__599_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_77=("${message}");
    eprintf__598_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_77[@];
    __AF_eprintf598_v0__39_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__39_5" > /dev/null 2>&1
}
colored__600_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored600_v0="\x1b[${color}m""${message}""\x1b[0m";
    return 0
}
remove_line__602_v0() {
    local cnt=$1
     printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_78=("");
    eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_78[@];
    __AF_eprintf598_v0__55_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__55_5" > /dev/null 2>&1
}
remove_current_line__603_v0() {
    __AMBER_ARRAY_79=("");
    eprintf__598_v0 "\x1b[2K\x1b[9999D" __AMBER_ARRAY_79[@];
    __AF_eprintf598_v0__60_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__60_5" > /dev/null 2>&1
}
print_blank__604_v0() {
    local cnt=$1
     printf '%*s' "${cnt}" ' ' >&2 ;
    __AS=$?
}
new_line__605_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_80=("");
        eprintf__598_v0 "
" __AMBER_ARRAY_80[@];
        __AF_eprintf598_v0__72_9="$__AF_eprintf598_v0";
        echo "$__AF_eprintf598_v0__72_9" > /dev/null 2>&1
done
}
go_up__606_v0() {
    local cnt=$1
    __AMBER_ARRAY_81=("");
    eprintf__598_v0 "\x1b[${cnt}A" __AMBER_ARRAY_81[@];
    __AF_eprintf598_v0__78_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__78_5" > /dev/null 2>&1
}
go_down__607_v0() {
    local cnt=$1
    __AMBER_ARRAY_82=("");
    eprintf__598_v0 "\x1b[${cnt}B" __AMBER_ARRAY_82[@];
    __AF_eprintf598_v0__83_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__83_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
go_up_or_down__608_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__607_v0 ${cnt};
        __AF_go_down607_v0__89_9="$__AF_go_down607_v0";
        echo "$__AF_go_down607_v0__89_9" > /dev/null 2>&1
else
        go_up__606_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up606_v0__91_9="$__AF_go_up606_v0";
        echo "$__AF_go_up606_v0__91_9" > /dev/null 2>&1
fi
}
hide_cursor__609_v0() {
    __AMBER_ARRAY_83=("");
    eprintf__598_v0 "\x1b[?25l" __AMBER_ARRAY_83[@];
    __AF_eprintf598_v0__96_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__96_5" > /dev/null 2>&1
}
show_cursor__610_v0() {
    __AMBER_ARRAY_84=("");
    eprintf__598_v0 "\x1b[?25h" __AMBER_ARRAY_84[@];
    __AF_eprintf598_v0__100_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__100_5" > /dev/null 2>&1
}
# / Text Utilities /////
has_ansi_escape__611_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    __AMBER_VAL_85=$( [[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_85}"
    __AF_has_ansi_escape611_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
escape_ansi__612_v0() {
    local text=$1
    __AMBER_VAL_86=$( printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g' );
    __AS=$?;
    __AF_escape_ansi612_v0="${__AMBER_VAL_86}";
    return 0
}
strip_ansi__613_v0() {
    local text=$1
    __AMBER_VAL_87=$( printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g' );
    __AS=$?;
    __AF_strip_ansi613_v0="${__AMBER_VAL_87}";
    return 0
}
is_all_ascii__614_v0() {
    local text=$1
    __AMBER_VAL_88=$( printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1 );
    __AS=$?;
    local result="${__AMBER_VAL_88}"
    __AF_is_all_ascii614_v0=$([ "_${result}" != "_0" ]; echo $?);
    return 0
}
get_visible_len__615_v0() {
    local text=$1
    strip_ansi__613_v0 "${text}";
    __AF_strip_ansi613_v0__135_20="${__AF_strip_ansi613_v0}";
    local stripped="${__AF_strip_ansi613_v0__135_20}"
    # Check if text is all ASCII
    is_all_ascii__614_v0 "${stripped}";
    __AF_is_all_ascii614_v0__137_12="$__AF_is_all_ascii614_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii614_v0__137_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Try using perl
        perl_get_cjk_width__589_v0 "${stripped}";
        __AS=$?;
if [ $__AS != 0 ]; then
            __AMBER_LEN="${stripped}";
            __AF_get_visible_len615_v0="${#__AMBER_LEN}";
            return 0
fi;
        __AF_perl_get_cjk_width589_v0__139_16="$__AF_perl_get_cjk_width589_v0";
        __AF_get_visible_len615_v0="$__AF_perl_get_cjk_width589_v0__139_16";
        return 0
else
        __AMBER_LEN="${stripped}";
        __AF_get_visible_len615_v0="${#__AMBER_LEN}";
        return 0
fi
}
truncate_text__616_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__615_v0 "${text}";
    __AF_get_visible_len615_v0__150_23="$__AF_get_visible_len615_v0";
    local visible_len="$__AF_get_visible_len615_v0__150_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text616_v0="${text}";
        return 0
fi
    is_all_ascii__614_v0 "${text}";
    __AF_is_all_ascii614_v0__154_12="$__AF_is_all_ascii614_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii614_v0__154_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        perl_truncate_cjk__590_v0 "${text}" ${max_width};
        __AS=$?;
if [ $__AS != 0 ]; then
             printf "%s" "${text}" | cut -c1-${max_width} ;
            __AS=$?
fi;
        __AF_perl_truncate_cjk590_v0__155_16="${__AF_perl_truncate_cjk590_v0}";
        __AF_truncate_text616_v0="${__AF_perl_truncate_cjk590_v0__155_16}";
        return 0
fi
    __AMBER_VAL_89=$( printf "%s" "${text}" | cut -c1-${max_width} );
    __AS=$?;
    __AF_truncate_text616_v0="${__AMBER_VAL_89}";
    return 0
}
truncate_ansi__617_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__611_v0 "${text}";
    __AF_has_ansi_escape611_v0__166_12="$__AF_has_ansi_escape611_v0";
    if [ $(echo  '!' "$__AF_has_ansi_escape611_v0__166_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        truncate_text__616_v0 "${text}" ${max_width};
        __AF_truncate_text616_v0__167_16="${__AF_truncate_text616_v0}";
        __AF_truncate_ansi617_v0="${__AF_truncate_text616_v0__167_16}";
        return 0
fi
    # Check if text starts with \x1b[
    __AMBER_VAL_90=$( [[ "${text}" == '\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local starts_with_ansi="${__AMBER_VAL_90}"
    # Replace \x1b[ with newline, then split
    __AMBER_VAL_91=$( t="${text}"; printf '%s' "${t//\\x1b[/
}" );
    __AS=$?;
    local replaced="${__AMBER_VAL_91}"
    split__3_v0 "${replaced}" "
";
    __AF_split3_v0__176_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__176_17[@]}")
    local result=""
    local remaining_width=${max_width}
    for idx in $(seq 0 $(echo "${#parts[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local part="${parts[${idx}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ $(echo $(echo ${idx} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${starts_with_ansi}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                truncate_text__616_v0 "${part}" ${remaining_width};
                __AF_truncate_text616_v0__188_33="${__AF_truncate_text616_v0}";
                local truncated="${__AF_truncate_text616_v0__188_33}"
                result+="${truncated}"
                get_visible_len__615_v0 "${truncated}";
                __AF_get_visible_len615_v0__190_36="$__AF_get_visible_len615_v0";
                remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len615_v0__190_36" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
            # Part is "ANSIparams m text" format - find first 'm'
            __AMBER_VAL_92=$( __p="${part}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done );
            __AS=$?;
            local m_idx="${__AMBER_VAL_92}"
            if [ $([ "_${m_idx}" == "_" ]; echo $?) != 0 ]; then
                # Reconstruct ANSI sequence
                __AMBER_VAL_93=$( __p="${part}"; printf "%s" "${__p:0:${m_idx}}" );
                __AS=$?;
                local ansi_params="${__AMBER_VAL_93}"
                result+="\\x1b[""${ansi_params}""m"
                # Rest is text content
                parse_number__12_v0 "${m_idx}";
                __AS=$?;
                __AF_parse_number12_v0__201_39="$__AF_parse_number12_v0";
                local m_idx_num="$__AF_parse_number12_v0__201_39"
                local text_start=$(echo ${m_idx_num} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                __AMBER_VAL_94=$( __p="${part}"; printf "%s" "${__p:${text_start}}" );
                __AS=$?;
                local text_part="${__AMBER_VAL_94}"
                if [ $(echo $([ "_${text_part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__616_v0 "${text_part}" ${remaining_width};
                    __AF_truncate_text616_v0__205_37="${__AF_truncate_text616_v0}";
                    local truncated="${__AF_truncate_text616_v0__205_37}"
                    result+="${truncated}"
                    get_visible_len__615_v0 "${truncated}";
                    __AF_get_visible_len615_v0__207_40="$__AF_get_visible_len615_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len615_v0__207_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
                # No 'm' found, treat as text
                if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__616_v0 "${part}" ${remaining_width};
                    __AF_truncate_text616_v0__212_37="${__AF_truncate_text616_v0}";
                    local truncated="${__AF_truncate_text616_v0__212_37}"
                    result+="${truncated}"
                    get_visible_len__615_v0 "${truncated}";
                    __AF_get_visible_len615_v0__214_40="$__AF_get_visible_len615_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len615_v0__214_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
fi
fi
done
    __AF_truncate_ansi617_v0="${result}";
    return 0
}
cutoff_text__618_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__615_v0 "${text}";
    __AF_get_visible_len615_v0__226_23="$__AF_get_visible_len615_v0";
    local visible_len="$__AF_get_visible_len615_v0__226_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_cutoff_text618_v0="${text}";
        return 0
fi
    truncate_ansi__617_v0 "${text}" $(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_truncate_ansi617_v0__230_12="${__AF_truncate_ansi617_v0}";
    __AF_cutoff_text618_v0="${__AF_truncate_ansi617_v0__230_12}""...";
    return 0
}
# // Application Utilities /////
render_tooltip__619_v0() {
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
                eprintf_colored__599_v0 "${separator}" 90;
                __AF_eprintf_colored599_v0__253_27="$__AF_eprintf_colored599_v0";
                echo "$__AF_eprintf_colored599_v0__253_27" > /dev/null 2>&1
fi
            colored__600_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored600_v0__255_41="${__AF_colored600_v0}";
            __AMBER_ARRAY_95=("");
            eprintf__598_v0 "${items[${iter}]}"" ""${__AF_colored600_v0__255_41}" __AMBER_ARRAY_95[@];
            __AF_eprintf598_v0__255_13="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__255_13" > /dev/null 2>&1
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
                eprintf_colored__599_v0 "${separator}" 90;
                __AF_eprintf_colored599_v0__281_17="$__AF_eprintf_colored599_v0";
                echo "$__AF_eprintf_colored599_v0__281_17" > /dev/null 2>&1
fi
            colored__600_v0 "${action}" 2;
            __AF_colored600_v0__283_33="${__AF_colored600_v0}";
            __AMBER_ARRAY_96=("");
            eprintf__598_v0 "${key}"" ""${__AF_colored600_v0__283_33}" __AMBER_ARRAY_96[@];
            __AF_eprintf598_v0__283_13="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__283_13" > /dev/null 2>&1
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
__18__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__19__got_xylitol_colors=0
__AMBER_ARRAY_97=(3 207 159 92);
__20__primary_color=("${__AMBER_ARRAY_97[@]}")
__AMBER_ARRAY_98=(3 118 206 95);
__21__secondary_color=("${__AMBER_ARRAY_98[@]}")
__AMBER_ARRAY_99=(234 72 121 94);
__22__accent_color=("${__AMBER_ARRAY_99[@]}")
get_supports_truecolor__649_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __18__supports_truecolor="No"
        __AF_get_supports_truecolor649_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __18__supports_truecolor="No"
        __AF_get_supports_truecolor649_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __18__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor649_v0=$([ "_${__18__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__650_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__18__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb650_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__18__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__649_v0 ;
            __AF_get_supports_truecolor649_v0__50_17="$__AF_get_supports_truecolor649_v0";
            if [ "$__AF_get_supports_truecolor649_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb650_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb650_v0="${message}";
                return 0
else
                __AF_colored_rgb650_v0="\x1b[${fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb650_v0="${message}";
            return 0
fi
        __AF_colored_rgb650_v0="\x1b[${fallback}m""${message}""\x1b[0m";
        return 0
fi
}
inner_get_xylitol_colors__652_v0() {
    if [ $(echo  '!' ${__19__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_100=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __20__primary_color=("${__AMBER_ARRAY_100[@]}")
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
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_101=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __21__secondary_color=("${__AMBER_ARRAY_101[@]}")
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
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors652_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_102=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __22__accent_color=("${__AMBER_ARRAY_102[@]}")
fi
fi
        __19__got_xylitol_colors=1
fi
}
get_xylitol_colors__653_v0() {
    inner_get_xylitol_colors__652_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors652_v0__154_5="$__AF_inner_get_xylitol_colors652_v0";
    echo "$__AF_inner_get_xylitol_colors652_v0__154_5" > /dev/null 2>&1
    __19__got_xylitol_colors=1
}
colored_primary__654_v0() {
    local message=$1
    if [ $(echo  '!' ${__19__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__653_v0 ;
        __AF_get_xylitol_colors653_v0__162_9="$__AF_get_xylitol_colors653_v0";
        echo "$__AF_get_xylitol_colors653_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__650_v0 "${message}" "${__20__primary_color[0]}" "${__20__primary_color[1]}" "${__20__primary_color[2]}" "${__20__primary_color[3]}";
    __AF_colored_rgb650_v0__164_12="${__AF_colored_rgb650_v0}";
    __AF_colored_primary654_v0="${__AF_colored_rgb650_v0__164_12}";
    return 0
}
colored_secondary__655_v0() {
    local message=$1
    if [ $(echo  '!' ${__19__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__653_v0 ;
        __AF_get_xylitol_colors653_v0__169_9="$__AF_get_xylitol_colors653_v0";
        echo "$__AF_get_xylitol_colors653_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__650_v0 "${message}" "${__21__secondary_color[0]}" "${__21__secondary_color[1]}" "${__21__secondary_color[2]}" "${__21__secondary_color[3]}";
    __AF_colored_rgb650_v0__171_12="${__AF_colored_rgb650_v0}";
    __AF_colored_secondary655_v0="${__AF_colored_rgb650_v0__171_12}";
    return 0
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__23__got_term_size=0
__AMBER_ARRAY_103=(80 24);
__24__term_size=("${__AMBER_ARRAY_103[@]}")
get_term_size__671_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    __AMBER_VAL_104=$( printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_104}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size671_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size671_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size671_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_105=(${cols} ${rows});
    __24__term_size=("${__AMBER_ARRAY_105[@]}")
    __23__got_term_size=1
}
term_width__673_v0() {
    if [ $(echo  '!' ${__23__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__671_v0 ;
        __AS=$?;
        __AF_get_term_size671_v0__33_15="$__AF_get_term_size671_v0";
        echo "$__AF_get_term_size671_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width673_v0="${__24__term_size[0]}";
    return 0
}
term_height__674_v0() {
    if [ $(echo  '!' ${__23__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__671_v0 ;
        __AS=$?;
        __AF_get_term_size671_v0__41_15="$__AF_get_term_size671_v0";
        echo "$__AF_get_term_size671_v0__41_15" > /dev/null 2>&1
fi
    __AF_term_height674_v0="${__24__term_size[1]}";
    return 0
}
get_page_options__678_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    local start=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local end=$(echo ${start} '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${end} '>' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        end="${#options[@]}"
fi
    __AMBER_ARRAY_106=();
    local result=("${__AMBER_ARRAY_106[@]}")
    for i in $(seq ${start} $(echo ${end} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_107=("${options[${i}]}");
        result+=("${__AMBER_ARRAY_107[@]}")
done
    __AF_get_page_options678_v0=("${result[@]}");
    return 0
}
get_page_start__679_v0() {
    local page=$1
    local page_size=$2
    __AF_get_page_start679_v0=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
render_choose_page__680_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local max_option_width=$(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        cutoff_text__618_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_cutoff_text618_v0__28_32="${__AF_cutoff_text618_v0}";
        local truncated_option="${__AF_cutoff_text618_v0__28_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            colored_secondary__655_v0 "${cursor}""${truncated_option}""
";
            __AF_colored_secondary655_v0__30_21="${__AF_colored_secondary655_v0}";
            __AMBER_ARRAY_108=("");
            eprintf__598_v0 "${__AF_colored_secondary655_v0__30_21}" __AMBER_ARRAY_108[@];
            __AF_eprintf598_v0__30_13="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__30_13" > /dev/null 2>&1
else
            print_blank__604_v0 ${cursor_len};
            __AF_print_blank604_v0__32_13="$__AF_print_blank604_v0";
            echo "$__AF_print_blank604_v0__32_13" > /dev/null 2>&1
            __AMBER_ARRAY_109=("");
            eprintf__598_v0 "${truncated_option}""
" __AMBER_ARRAY_109[@];
            __AF_eprintf598_v0__33_13="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__33_13" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug gaurd
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_110=("");
            eprintf__598_v0 "\x1b[K
" __AMBER_ARRAY_110[@];
            __AF_eprintf598_v0__39_13="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__39_13" > /dev/null 2>&1
done
fi
}
render_multi_choose_page__681_v0() {
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
        cutoff_text__618_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_cutoff_text618_v0__51_32="${__AF_cutoff_text618_v0}";
        local truncated_option="${__AF_cutoff_text618_v0__51_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            colored_secondary__655_v0 "${cursor}""${check_mark}""${truncated_option}""
";
            __AF_colored_secondary655_v0__53_31="${__AF_colored_secondary655_v0}";
            __AMBER_ARRAY_111=("");
            eprintf__598_v0 "${__AF_colored_secondary655_v0__53_31}" __AMBER_ARRAY_111[@];
            __AF_eprintf598_v0__53_23="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__53_23" > /dev/null 2>&1
elif [ "${checked[${global_idx}]}" != 0 ]; then
                            print_blank__604_v0 ${cursor_len};
                __AF_print_blank604_v0__55_17="$__AF_print_blank604_v0";
                echo "$__AF_print_blank604_v0__55_17" > /dev/null 2>&1
                colored_secondary__655_v0 "${check_mark}""${truncated_option}""
";
                __AF_colored_secondary655_v0__56_25="${__AF_colored_secondary655_v0}";
                __AMBER_ARRAY_112=("");
                eprintf__598_v0 "${__AF_colored_secondary655_v0__56_25}" __AMBER_ARRAY_112[@];
                __AF_eprintf598_v0__56_17="$__AF_eprintf598_v0";
                echo "$__AF_eprintf598_v0__56_17" > /dev/null 2>&1
else
                            print_blank__604_v0 ${cursor_len};
                __AF_print_blank604_v0__59_17="$__AF_print_blank604_v0";
                echo "$__AF_print_blank604_v0__59_17" > /dev/null 2>&1
                __AMBER_ARRAY_113=("");
                eprintf__598_v0 "${check_mark}""${truncated_option}""
" __AMBER_ARRAY_113[@];
                __AF_eprintf598_v0__60_17="$__AF_eprintf598_v0";
                echo "$__AF_eprintf598_v0__60_17" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug guard
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_114=("");
            eprintf__598_v0 "\x1b[K
" __AMBER_ARRAY_114[@];
            __AF_eprintf598_v0__67_13="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__67_13" > /dev/null 2>&1
done
fi
}
render_page_indicator__682_v0() {
    local page=$1
    local total_pages=$2
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_115=("");
        eprintf__598_v0 "\x1b[9999D\x1b[K" __AMBER_ARRAY_115[@];
        __AF_eprintf598_v0__74_9="$__AF_eprintf598_v0";
        echo "$__AF_eprintf598_v0__74_9" > /dev/null 2>&1
        eprintf_colored__599_v0 "Page $(echo ${page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored599_v0__75_9="$__AF_eprintf_colored599_v0";
        echo "$__AF_eprintf_colored599_v0__75_9" > /dev/null 2>&1
        __AMBER_ARRAY_116=("");
        eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_116[@];
        __AF_eprintf598_v0__76_9="$__AF_eprintf598_v0";
        echo "$__AF_eprintf598_v0__76_9" > /dev/null 2>&1
fi
}
xyl_choose__683_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__599_v0 "ERROR: No options provided.
" 31;
        __AF_eprintf_colored599_v0__94_9="$__AF_eprintf_colored599_v0";
        echo "$__AF_eprintf_colored599_v0__94_9" > /dev/null 2>&1
        exit 1
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__609_v0 ;
    __AF_hide_cursor609_v0__99_5="$__AF_hide_cursor609_v0";
    echo "$__AF_hide_cursor609_v0__99_5" > /dev/null 2>&1
    term_width__673_v0 ;
    __AF_term_width673_v0__101_22="$__AF_term_width673_v0";
    local term_width="$__AF_term_width673_v0__101_22"
    term_height__674_v0 ;
    __AF_term_height674_v0__102_23="$__AF_term_height674_v0";
    local term_height="$__AF_term_height674_v0__102_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        cutoff_text__618_v0 "${header}" ${term_width};
        __AF_cutoff_text618_v0__109_17="${__AF_cutoff_text618_v0}";
        __AMBER_ARRAY_117=("");
        eprintf__598_v0 "${__AF_cutoff_text618_v0__109_17}""
" __AMBER_ARRAY_117[@];
        __AF_eprintf598_v0__109_9="$__AF_eprintf598_v0";
        echo "$__AF_eprintf598_v0__109_9" > /dev/null 2>&1
fi
    math_floor__309_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor309_v0__112_23="$__AF_math_floor309_v0";
    local total_pages="$__AF_math_floor309_v0__112_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__605_v0 ${display_count};
    __AF_new_line605_v0__121_5="$__AF_new_line605_v0";
    echo "$__AF_new_line605_v0__121_5" > /dev/null 2>&1
    __AMBER_ARRAY_118=("");
    eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_118[@];
    __AF_eprintf598_v0__122_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__122_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__599_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored599_v0__124_9="$__AF_eprintf_colored599_v0";
        echo "$__AF_eprintf_colored599_v0__124_9" > /dev/null 2>&1
fi
    new_line__605_v0 1;
    __AF_new_line605_v0__126_5="$__AF_new_line605_v0";
    echo "$__AF_new_line605_v0__126_5" > /dev/null 2>&1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_119=("↑↓" "select" "←→" "page" "enter" "confirm");
        render_tooltip__619_v0 __AMBER_ARRAY_119[@] 36 ${term_width};
        __AF_render_tooltip619_v0__131_9="$__AF_render_tooltip619_v0";
        echo "$__AF_render_tooltip619_v0__131_9" > /dev/null 2>&1
else
        __AMBER_ARRAY_120=("↑↓" "select" "enter" "confirm");
        render_tooltip__619_v0 __AMBER_ARRAY_120[@] 25 ${term_width};
        __AF_render_tooltip619_v0__133_9="$__AF_render_tooltip619_v0";
        echo "$__AF_render_tooltip619_v0__133_9" > /dev/null 2>&1
fi
    go_up__606_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up606_v0__135_5="$__AF_go_up606_v0";
    echo "$__AF_go_up606_v0__135_5" > /dev/null 2>&1
    __AMBER_ARRAY_121=("");
    eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_121[@];
    __AF_eprintf598_v0__136_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__136_5" > /dev/null 2>&1
    get_page_options__678_v0 options[@] ${current_page} ${page_size};
    __AF_get_page_options678_v0__138_24=("${__AF_get_page_options678_v0[@]}");
    local page_options=("${__AF_get_page_options678_v0__138_24[@]}")
    render_choose_page__680_v0 page_options[@] ${selected} "${cursor}" ${display_count} ${term_width};
    __AF_render_choose_page680_v0__139_5="$__AF_render_choose_page680_v0";
    echo "$__AF_render_choose_page680_v0__139_5" > /dev/null 2>&1
    while :
do
        get_key__596_v0 ;
        __AF_get_key596_v0__142_19="${__AF_get_key596_v0}";
        local key="${__AF_get_key596_v0__142_19}"
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
            get_page_options__678_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options678_v0__205_32=("${__AF_get_page_options678_v0[@]}");
            page_options=("${__AF_get_page_options678_v0__205_32[@]}")
            if [ ${up_paged} != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            go_up__606_v0 1;
            __AF_go_up606_v0__209_17="$__AF_go_up606_v0";
            echo "$__AF_go_up606_v0__209_17" > /dev/null 2>&1
            remove_line__602_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line602_v0__210_17="$__AF_remove_line602_v0";
            echo "$__AF_remove_line602_v0__210_17" > /dev/null 2>&1
            remove_current_line__603_v0 ;
            __AF_remove_current_line603_v0__211_17="$__AF_remove_current_line603_v0";
            echo "$__AF_remove_current_line603_v0__211_17" > /dev/null 2>&1
            __AMBER_ARRAY_122=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_122[@];
            __AF_eprintf598_v0__212_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__212_17" > /dev/null 2>&1
            render_choose_page__680_v0 page_options[@] ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_choose_page680_v0__213_17="$__AF_render_choose_page680_v0";
            echo "$__AF_render_choose_page680_v0__213_17" > /dev/null 2>&1
            render_page_indicator__682_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator682_v0__214_17="$__AF_render_page_indicator682_v0";
            echo "$__AF_render_page_indicator682_v0__214_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__606_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up606_v0__217_17="$__AF_go_up606_v0";
            echo "$__AF_go_up606_v0__217_17" > /dev/null 2>&1
            __AMBER_ARRAY_123=("");
            eprintf__598_v0 "\x1b[K" __AMBER_ARRAY_123[@];
            __AF_eprintf598_v0__218_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__218_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__604_v0 "${#__AMBER_LEN}";
            __AF_print_blank604_v0__219_17="$__AF_print_blank604_v0";
            echo "$__AF_print_blank604_v0__219_17" > /dev/null 2>&1
            cutoff_text__618_v0 "${page_options[${prev_selected}]}" ${max_option_width};
            __AF_cutoff_text618_v0__220_25="${__AF_cutoff_text618_v0}";
            __AMBER_ARRAY_124=("");
            eprintf__598_v0 "${__AF_cutoff_text618_v0__220_25}" __AMBER_ARRAY_124[@];
            __AF_eprintf598_v0__220_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__220_17" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__608_v0 ${diff};
            __AF_go_up_or_down608_v0__223_17="$__AF_go_up_or_down608_v0";
            echo "$__AF_go_up_or_down608_v0__223_17" > /dev/null 2>&1
            __AMBER_ARRAY_125=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_125[@];
            __AF_eprintf598_v0__224_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__224_17" > /dev/null 2>&1
            __AMBER_ARRAY_126=("");
            eprintf__598_v0 "\x1b[K" __AMBER_ARRAY_126[@];
            __AF_eprintf598_v0__225_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__225_17" > /dev/null 2>&1
            cutoff_text__618_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_cutoff_text618_v0__226_52="${__AF_cutoff_text618_v0}";
            colored_secondary__655_v0 "${cursor}""${__AF_cutoff_text618_v0__226_52}";
            __AF_colored_secondary655_v0__226_25="${__AF_colored_secondary655_v0}";
            __AMBER_ARRAY_127=("");
            eprintf__598_v0 "${__AF_colored_secondary655_v0__226_25}" __AMBER_ARRAY_127[@];
            __AF_eprintf598_v0__226_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__226_17" > /dev/null 2>&1
            go_down__607_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down607_v0__228_17="$__AF_go_down607_v0";
            echo "$__AF_go_down607_v0__228_17" > /dev/null 2>&1
            __AMBER_ARRAY_128=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_128[@];
            __AF_eprintf598_v0__229_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__229_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__607_v0 1;
    __AF_go_down607_v0__239_5="$__AF_go_down607_v0";
    echo "$__AF_go_down607_v0__239_5" > /dev/null 2>&1
    remove_line__602_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line602_v0__240_5="$__AF_remove_line602_v0";
    echo "$__AF_remove_line602_v0__240_5" > /dev/null 2>&1
    remove_current_line__603_v0 ;
    __AF_remove_current_line603_v0__241_5="$__AF_remove_current_line603_v0";
    echo "$__AF_remove_current_line603_v0__241_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__610_v0 ;
    __AF_show_cursor610_v0__244_5="$__AF_show_cursor610_v0";
    echo "$__AF_show_cursor610_v0__244_5" > /dev/null 2>&1
    local global_selected=$(echo $(echo ${current_page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_xyl_choose683_v0="${options[${global_selected}]}";
    return 0
}
count_checked__684_v0() {
    local checked=("${!1}")
    local count=0
    for c in "${checked[@]}"; do
        if [ ${c} != 0 ]; then
            count=$(echo ${count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
done
    __AF_count_checked684_v0=${count};
    return 0
}
xyl_multi_choose__685_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__599_v0 "ERROR: No options provided.
" 31;
        __AF_eprintf_colored599_v0__275_9="$__AF_eprintf_colored599_v0";
        echo "$__AF_eprintf_colored599_v0__275_9" > /dev/null 2>&1
        __AMBER_ARRAY_129=();
        __AF_xyl_multi_choose685_v0=("${__AMBER_ARRAY_129[@]}");
        return 0
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__609_v0 ;
    __AF_hide_cursor609_v0__280_5="$__AF_hide_cursor609_v0";
    echo "$__AF_hide_cursor609_v0__280_5" > /dev/null 2>&1
    term_width__673_v0 ;
    __AF_term_width673_v0__282_22="$__AF_term_width673_v0";
    local term_width="$__AF_term_width673_v0__282_22"
    term_height__674_v0 ;
    __AF_term_height674_v0__283_23="$__AF_term_height674_v0";
    local term_height="$__AF_term_height674_v0__283_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        cutoff_text__618_v0 "${header}" ${term_width};
        __AF_cutoff_text618_v0__290_17="${__AF_cutoff_text618_v0}";
        __AMBER_ARRAY_130=("");
        eprintf__598_v0 "${__AF_cutoff_text618_v0__290_17}""
" __AMBER_ARRAY_130[@];
        __AF_eprintf598_v0__290_9="$__AF_eprintf598_v0";
        echo "$__AF_eprintf598_v0__290_9" > /dev/null 2>&1
fi
    math_floor__309_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor309_v0__293_23="$__AF_math_floor309_v0";
    local total_pages="$__AF_math_floor309_v0__293_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__605_v0 ${display_count};
    __AF_new_line605_v0__302_5="$__AF_new_line605_v0";
    echo "$__AF_new_line605_v0__302_5" > /dev/null 2>&1
    __AMBER_ARRAY_131=("");
    eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_131[@];
    __AF_eprintf598_v0__303_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__303_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__599_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored599_v0__305_9="$__AF_eprintf_colored599_v0";
        echo "$__AF_eprintf_colored599_v0__305_9" > /dev/null 2>&1
fi
    new_line__605_v0 1;
    __AF_new_line605_v0__307_5="$__AF_new_line605_v0";
    echo "$__AF_new_line605_v0__307_5" > /dev/null 2>&1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ $(echo $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_132=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm");
        render_tooltip__619_v0 __AMBER_ARRAY_132[@] 55 ${term_width};
        __AF_render_tooltip619_v0__314_40="$__AF_render_tooltip619_v0";
        echo "$__AF_render_tooltip619_v0__314_40" > /dev/null 2>&1
elif [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_133=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm");
        render_tooltip__619_v0 __AMBER_ARRAY_133[@] 47 ${term_width};
        __AF_render_tooltip619_v0__315_26="$__AF_render_tooltip619_v0";
        echo "$__AF_render_tooltip619_v0__315_26" > /dev/null 2>&1
elif [ $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_134=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm");
        render_tooltip__619_v0 __AMBER_ARRAY_134[@] 44 ${term_width};
        __AF_render_tooltip619_v0__316_20="$__AF_render_tooltip619_v0";
        echo "$__AF_render_tooltip619_v0__316_20" > /dev/null 2>&1
else
        __AMBER_ARRAY_135=("↑↓" "select" "x" "toggle" "enter" "confirm");
        render_tooltip__619_v0 __AMBER_ARRAY_135[@] 36 ${term_width};
        __AF_render_tooltip619_v0__317_15="$__AF_render_tooltip619_v0";
        echo "$__AF_render_tooltip619_v0__317_15" > /dev/null 2>&1
fi
    go_up__606_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up606_v0__319_5="$__AF_go_up606_v0";
    echo "$__AF_go_up606_v0__319_5" > /dev/null 2>&1
    __AMBER_ARRAY_136=("");
    eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_136[@];
    __AF_eprintf598_v0__320_5="$__AF_eprintf598_v0";
    echo "$__AF_eprintf598_v0__320_5" > /dev/null 2>&1
    __AMBER_ARRAY_137=();
    local checked=("${__AMBER_ARRAY_137[@]}")
    for _ in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_138=(0);
        checked+=("${__AMBER_ARRAY_138[@]}")
done
    get_page_options__678_v0 options[@] ${current_page} ${page_size};
    __AF_get_page_options678_v0__327_24=("${__AF_get_page_options678_v0[@]}");
    local page_options=("${__AF_get_page_options678_v0__327_24[@]}")
    get_page_start__679_v0 ${current_page} ${page_size};
    __AF_get_page_start679_v0__328_22="$__AF_get_page_start679_v0";
    local page_start="$__AF_get_page_start679_v0__328_22"
    render_multi_choose_page__681_v0 page_options[@] checked[@] ${page_start} ${selected} "${cursor}" ${display_count} ${term_width};
    __AF_render_multi_choose_page681_v0__329_5="$__AF_render_multi_choose_page681_v0";
    echo "$__AF_render_multi_choose_page681_v0__329_5" > /dev/null 2>&1
    while :
do
        get_key__596_v0 ;
        __AF_get_key596_v0__332_19="${__AF_get_key596_v0}";
        local key="${__AF_get_key596_v0__332_19}"
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
            count_checked__684_v0 checked[@];
            __AF_count_checked684_v0__392_34="$__AF_count_checked684_v0";
            if [ "${checked[${global_selected}]}" != 0 ]; then
                checked[${global_selected}]=0
elif [ $(echo $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $(echo "$__AF_count_checked684_v0__392_34" '<' ${limit} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                checked[${global_selected}]=1
else
                continue
fi
            __AMBER_LEN="${cursor}";
            local max_option_width=$(echo $(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            # 2 for check mark
            go_up__606_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up606_v0__398_17="$__AF_go_up606_v0";
            echo "$__AF_go_up606_v0__398_17" > /dev/null 2>&1
            __AMBER_ARRAY_139=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_139[@];
            __AF_eprintf598_v0__399_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__399_17" > /dev/null 2>&1
            __AMBER_ARRAY_140=("");
            eprintf__598_v0 "\x1b[K" __AMBER_ARRAY_140[@];
            __AF_eprintf598_v0__400_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__400_17" > /dev/null 2>&1
            local check_mark=$(if [ "${checked[${global_selected}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            cutoff_text__618_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_cutoff_text618_v0__402_65="${__AF_cutoff_text618_v0}";
            colored_secondary__655_v0 "${cursor}""${check_mark}""${__AF_cutoff_text618_v0__402_65}";
            __AF_colored_secondary655_v0__402_25="${__AF_colored_secondary655_v0}";
            __AMBER_ARRAY_141=("");
            eprintf__598_v0 "${__AF_colored_secondary655_v0__402_25}" __AMBER_ARRAY_141[@];
            __AF_eprintf598_v0__402_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__402_17" > /dev/null 2>&1
            go_down__607_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down607_v0__403_17="$__AF_go_down607_v0";
            echo "$__AF_go_down607_v0__403_17" > /dev/null 2>&1
            __AMBER_ARRAY_142=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_142[@];
            __AF_eprintf598_v0__404_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__404_17" > /dev/null 2>&1
            continue
elif [ $(echo $(echo $([ "_${key}" != "_a" ]; echo $?) '||' $([ "_${key}" != "_A" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo ${limit} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            count_checked__684_v0 checked[@];
            __AF_count_checked684_v0__408_35="$__AF_count_checked684_v0";
            local all_checked=$(echo "$__AF_count_checked684_v0__408_35" '==' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            for i in $(seq 0 $(echo "${#checked[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
                checked[${i}]=$(echo  '!' ${all_checked} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
done
            go_up__606_v0 ${display_count};
            __AF_go_up606_v0__412_17="$__AF_go_up606_v0";
            echo "$__AF_go_up606_v0__412_17" > /dev/null 2>&1
            __AMBER_ARRAY_143=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_143[@];
            __AF_eprintf598_v0__413_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__413_17" > /dev/null 2>&1
            render_multi_choose_page__681_v0 page_options[@] checked[@] ${page_start} ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_multi_choose_page681_v0__414_17="$__AF_render_multi_choose_page681_v0";
            echo "$__AF_render_multi_choose_page681_v0__414_17" > /dev/null 2>&1
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
            get_page_options__678_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options678_v0__426_32=("${__AF_get_page_options678_v0[@]}");
            page_options=("${__AF_get_page_options678_v0__426_32[@]}")
            get_page_start__679_v0 ${current_page} ${page_size};
            __AF_get_page_start679_v0__427_30="$__AF_get_page_start679_v0";
            page_start="$__AF_get_page_start679_v0__427_30"
            if [ ${up_paged} != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            go_up__606_v0 1;
            __AF_go_up606_v0__431_17="$__AF_go_up606_v0";
            echo "$__AF_go_up606_v0__431_17" > /dev/null 2>&1
            remove_line__602_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line602_v0__432_17="$__AF_remove_line602_v0";
            echo "$__AF_remove_line602_v0__432_17" > /dev/null 2>&1
            remove_current_line__603_v0 ;
            __AF_remove_current_line603_v0__433_17="$__AF_remove_current_line603_v0";
            echo "$__AF_remove_current_line603_v0__433_17" > /dev/null 2>&1
            __AMBER_ARRAY_144=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_144[@];
            __AF_eprintf598_v0__434_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__434_17" > /dev/null 2>&1
            render_multi_choose_page__681_v0 page_options[@] checked[@] ${page_start} ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_multi_choose_page681_v0__435_17="$__AF_render_multi_choose_page681_v0";
            echo "$__AF_render_multi_choose_page681_v0__435_17" > /dev/null 2>&1
            render_page_indicator__682_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator682_v0__436_17="$__AF_render_page_indicator682_v0";
            echo "$__AF_render_page_indicator682_v0__436_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local prev_global=$(echo ${page_start} '+' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up__606_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up606_v0__440_17="$__AF_go_up606_v0";
            echo "$__AF_go_up606_v0__440_17" > /dev/null 2>&1
            __AMBER_ARRAY_145=("");
            eprintf__598_v0 "\x1b[K" __AMBER_ARRAY_145[@];
            __AF_eprintf598_v0__441_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__441_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__604_v0 "${#__AMBER_LEN}";
            __AF_print_blank604_v0__442_17="$__AF_print_blank604_v0";
            echo "$__AF_print_blank604_v0__442_17" > /dev/null 2>&1
            if [ "${checked[${prev_global}]}" != 0 ]; then
                cutoff_text__618_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_cutoff_text618_v0__444_54="${__AF_cutoff_text618_v0}";
                colored_secondary__655_v0 "✓ ""${__AF_cutoff_text618_v0__444_54}";
                __AF_colored_secondary655_v0__444_29="${__AF_colored_secondary655_v0}";
                __AMBER_ARRAY_146=("");
                eprintf__598_v0 "${__AF_colored_secondary655_v0__444_29}" __AMBER_ARRAY_146[@];
                __AF_eprintf598_v0__444_21="$__AF_eprintf598_v0";
                echo "$__AF_eprintf598_v0__444_21" > /dev/null 2>&1
else
                cutoff_text__618_v0 "${page_options[${prev_selected}]}" ${max_option_width};
                __AF_cutoff_text618_v0__446_36="${__AF_cutoff_text618_v0}";
                __AMBER_ARRAY_147=("");
                eprintf__598_v0 "• ""${__AF_cutoff_text618_v0__446_36}" __AMBER_ARRAY_147[@];
                __AF_eprintf598_v0__446_21="$__AF_eprintf598_v0";
                echo "$__AF_eprintf598_v0__446_21" > /dev/null 2>&1
fi
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__608_v0 ${diff};
            __AF_go_up_or_down608_v0__450_17="$__AF_go_up_or_down608_v0";
            echo "$__AF_go_up_or_down608_v0__450_17" > /dev/null 2>&1
            __AMBER_ARRAY_148=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_148[@];
            __AF_eprintf598_v0__451_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__451_17" > /dev/null 2>&1
            __AMBER_ARRAY_149=("");
            eprintf__598_v0 "\x1b[K" __AMBER_ARRAY_149[@];
            __AF_eprintf598_v0__452_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__452_17" > /dev/null 2>&1
            local new_global=$(echo ${page_start} '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            local check_mark=$(if [ "${checked[${new_global}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)
            cutoff_text__618_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_cutoff_text618_v0__455_65="${__AF_cutoff_text618_v0}";
            colored_secondary__655_v0 "${cursor}""${check_mark}""${__AF_cutoff_text618_v0__455_65}";
            __AF_colored_secondary655_v0__455_25="${__AF_colored_secondary655_v0}";
            __AMBER_ARRAY_150=("");
            eprintf__598_v0 "${__AF_colored_secondary655_v0__455_25}" __AMBER_ARRAY_150[@];
            __AF_eprintf598_v0__455_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__455_17" > /dev/null 2>&1
            go_down__607_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down607_v0__457_17="$__AF_go_down607_v0";
            echo "$__AF_go_down607_v0__457_17" > /dev/null 2>&1
            __AMBER_ARRAY_151=("");
            eprintf__598_v0 "\x1b[9999D" __AMBER_ARRAY_151[@];
            __AF_eprintf598_v0__458_17="$__AF_eprintf598_v0";
            echo "$__AF_eprintf598_v0__458_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__607_v0 1;
    __AF_go_down607_v0__468_5="$__AF_go_down607_v0";
    echo "$__AF_go_down607_v0__468_5" > /dev/null 2>&1
    remove_line__602_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line602_v0__469_5="$__AF_remove_line602_v0";
    echo "$__AF_remove_line602_v0__469_5" > /dev/null 2>&1
    remove_current_line__603_v0 ;
    __AF_remove_current_line603_v0__470_5="$__AF_remove_current_line603_v0";
    echo "$__AF_remove_current_line603_v0__470_5" > /dev/null 2>&1
    __AMBER_ARRAY_152=();
    local result=("${__AMBER_ARRAY_152[@]}")
    for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        if [ "${checked[${i}]}" != 0 ]; then
            __AMBER_ARRAY_153=("${options[${i}]}");
            result+=("${__AMBER_ARRAY_153[@]}")
fi
done
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__610_v0 ;
    __AF_show_cursor610_v0__480_5="$__AF_show_cursor610_v0";
    echo "$__AF_show_cursor610_v0__480_5" > /dev/null 2>&1
    __AF_xyl_multi_choose685_v0=("${result[@]}");
    return 0
}
print_choose_help__750_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    colored_primary__654_v0 "choose";
    __AF_colored_primary654_v0__7_12="${__AF_colored_primary654_v0}";
    __AMBER_ARRAY_154=("");
    printf__99_v0 "${__AF_colored_primary654_v0__7_12}" __AMBER_ARRAY_154[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_155=("");
    printf__99_v0 " - Choose from a list of options." __AMBER_ARRAY_155[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__655_v0 "Arguments: ";
    __AF_colored_secondary655_v0__11_12="${__AF_colored_secondary655_v0}";
    __AMBER_ARRAY_156=("");
    printf__99_v0 "${__AF_colored_secondary655_v0__11_12}""
" __AMBER_ARRAY_156[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  [<options> ...]        List of options to choose from"
    echo ""
    colored_secondary__655_v0 "Flags: ";
    __AF_colored_secondary655_v0__14_12="${__AF_colored_secondary655_v0}";
    __AMBER_ARRAY_157=("");
    printf__99_v0 "${__AF_colored_secondary655_v0__14_12}""
" __AMBER_ARRAY_157[@];
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
read_stdin_options__786_v0() {
    __AMBER_ARRAY_158=();
    local options=("${__AMBER_ARRAY_158[@]}")
    __AMBER_VAL_159=$( [ -t 0 ] && echo "true" || echo "false" );
    __AS=$?;
    local is_tty="${__AMBER_VAL_159}"
    if [ $([ "_${is_tty}" != "_false" ]; echo $?) != 0 ]; then
         while IFS= read -r line || [[ -n "$line" ]]; do options+=("$line"); done ;
        __AS=$?
fi
    __AF_read_stdin_options786_v0=("${options[@]}");
    return 0
}
execute_choose__787_v0() {
    local parameters=("${!1}")
    local cursor="> "
    colored_primary__654_v0 "Choose: ";
    __AF_colored_primary654_v0__18_30="${__AF_colored_primary654_v0}";
    local header="\x1b[1m""${__AF_colored_primary654_v0__18_30}"
    read_stdin_options__786_v0 ;
    __AF_read_stdin_options786_v0__19_19=("${__AF_read_stdin_options786_v0[@]}");
    local options=("${__AF_read_stdin_options786_v0__19_19[@]}")
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
            print_choose_help__750_v0 ;
            __AF_print_choose_help750_v0__27_17="$__AF_print_choose_help750_v0";
            echo "$__AF_print_choose_help750_v0__27_17" > /dev/null 2>&1
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
                eprintf_colored__599_v0 "ERROR: Invalid limit value: ""${result[1]}""
" 31;
                __AF_eprintf_colored599_v0__41_21="$__AF_eprintf_colored599_v0";
                echo "$__AF_eprintf_colored599_v0__41_21" > /dev/null 2>&1
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
                eprintf_colored__599_v0 "ERROR: Invalid page-size value: ""${result[1]}""
" 31;
                __AF_eprintf_colored599_v0__52_21="$__AF_eprintf_colored599_v0";
                echo "$__AF_eprintf_colored599_v0__52_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__51_29="$__AF_parse_number12_v0";
            page_size="$__AF_parse_number12_v0__51_29"
else
            __AMBER_ARRAY_160=("${param}");
            options+=("${__AMBER_ARRAY_160[@]}")
fi
done
    has_ansi_escape__611_v0 "${header}";
    __AF_has_ansi_escape611_v0__62_42="$__AF_has_ansi_escape611_v0";
    escape_ansi__612_v0 "${header}";
    __AF_escape_ansi612_v0__62_71="${__AF_escape_ansi612_v0}";
    colored_primary__654_v0 "${header}";
    __AF_colored_primary654_v0__62_109="${__AF_colored_primary654_v0}";
    local display_header=$(if [ $(echo $([ "_${header}" != "_" ]; echo $?) '||' "$__AF_has_ansi_escape611_v0__62_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "${__AF_escape_ansi612_v0__62_71}"; else echo "\\x1b[1m""${__AF_colored_primary654_v0__62_109}"; fi)
    if [ ${multi} != 0 ]; then
        xyl_multi_choose__685_v0 options[@] "${cursor}" "${display_header}" ${limit} ${page_size};
        __AF_xyl_multi_choose685_v0__65_23=("${__AF_xyl_multi_choose685_v0[@]}");
        local results=("${__AF_xyl_multi_choose685_v0__65_23[@]}")
        join__6_v0 results[@] "
";
        __AF_join6_v0__66_16="${__AF_join6_v0}";
        __AF_execute_choose787_v0="${__AF_join6_v0__66_16}";
        return 0
fi
    xyl_choose__683_v0 options[@] "${cursor}" "${display_header}" ${page_size};
    __AF_xyl_choose683_v0__69_12="${__AF_xyl_choose683_v0}";
    __AF_execute_choose787_v0="${__AF_xyl_choose683_v0__69_12}";
    return 0
}
# Perl Extensions Utilities
__AMBER_VAL_161=$( echo "$XYLITOL_USE_PERL" );
__AS=$?;
__25__perl_disabled=$([ "_${__AMBER_VAL_161}" != "_No" ]; echo $?)
__AMBER_VAL_162=$( command -v perl > /dev/null && echo 0 || echo 1 );
__AS=$?;
__26__perl_available=$(echo $(echo  '!' ${__25__perl_disabled} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${__AMBER_VAL_162}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
perl_get_cjk_width__897_v0() {
    local text=$1
    if [ $(echo  '!' ${__26__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_get_cjk_width897_v0='';
        return 1
fi
    __AMBER_VAL_163=$( perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width897_v0=''
return $__AS
fi;
    local width_str="${__AMBER_VAL_163}"
    parse_number__12_v0 "${width_str}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width897_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__14_17="$__AF_parse_number12_v0";
    local width="$__AF_parse_number12_v0__14_17"
    __AF_perl_get_cjk_width897_v0=${width};
    return 0
}
perl_truncate_cjk__898_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo  '!' ${__26__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_truncate_cjk898_v0='';
        return 1
fi
    __AMBER_VAL_164=$( perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_truncate_cjk898_v0=''
return $__AS
fi;
    local result="${__AMBER_VAL_164}"
    __AF_perl_truncate_cjk898_v0="${result}";
    return 0
}
# // IO Functions /////
get_key__904_v0() {
    __AMBER_VAL_165=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_165}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key904_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key904_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key904_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key904_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key904_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key904_v0="INPUT";
        return 0
else
        __AF_get_key904_v0="${var}";
        return 0
fi
}
eprintf__906_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__907_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_166=("${message}");
    eprintf__906_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_166[@];
    __AF_eprintf906_v0__39_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__39_5" > /dev/null 2>&1
}
colored__908_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored908_v0="\x1b[${color}m""${message}""\x1b[0m";
    return 0
}
remove_line__910_v0() {
    local cnt=$1
     printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_167=("");
    eprintf__906_v0 "\x1b[9999D" __AMBER_ARRAY_167[@];
    __AF_eprintf906_v0__55_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__55_5" > /dev/null 2>&1
}
remove_current_line__911_v0() {
    __AMBER_ARRAY_168=("");
    eprintf__906_v0 "\x1b[2K\x1b[9999D" __AMBER_ARRAY_168[@];
    __AF_eprintf906_v0__60_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__60_5" > /dev/null 2>&1
}
go_up__914_v0() {
    local cnt=$1
    __AMBER_ARRAY_169=("");
    eprintf__906_v0 "\x1b[${cnt}A" __AMBER_ARRAY_169[@];
    __AF_eprintf906_v0__78_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__78_5" > /dev/null 2>&1
}
go_down__915_v0() {
    local cnt=$1
    __AMBER_ARRAY_170=("");
    eprintf__906_v0 "\x1b[${cnt}B" __AMBER_ARRAY_170[@];
    __AF_eprintf906_v0__83_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__83_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
hide_cursor__917_v0() {
    __AMBER_ARRAY_171=("");
    eprintf__906_v0 "\x1b[?25l" __AMBER_ARRAY_171[@];
    __AF_eprintf906_v0__96_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__96_5" > /dev/null 2>&1
}
show_cursor__918_v0() {
    __AMBER_ARRAY_172=("");
    eprintf__906_v0 "\x1b[?25h" __AMBER_ARRAY_172[@];
    __AF_eprintf906_v0__100_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__100_5" > /dev/null 2>&1
}
# / Text Utilities /////
has_ansi_escape__919_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    __AMBER_VAL_173=$( [[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_173}"
    __AF_has_ansi_escape919_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
escape_ansi__920_v0() {
    local text=$1
    __AMBER_VAL_174=$( printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g' );
    __AS=$?;
    __AF_escape_ansi920_v0="${__AMBER_VAL_174}";
    return 0
}
strip_ansi__921_v0() {
    local text=$1
    __AMBER_VAL_175=$( printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g' );
    __AS=$?;
    __AF_strip_ansi921_v0="${__AMBER_VAL_175}";
    return 0
}
is_all_ascii__922_v0() {
    local text=$1
    __AMBER_VAL_176=$( printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1 );
    __AS=$?;
    local result="${__AMBER_VAL_176}"
    __AF_is_all_ascii922_v0=$([ "_${result}" != "_0" ]; echo $?);
    return 0
}
get_visible_len__923_v0() {
    local text=$1
    strip_ansi__921_v0 "${text}";
    __AF_strip_ansi921_v0__135_20="${__AF_strip_ansi921_v0}";
    local stripped="${__AF_strip_ansi921_v0__135_20}"
    # Check if text is all ASCII
    is_all_ascii__922_v0 "${stripped}";
    __AF_is_all_ascii922_v0__137_12="$__AF_is_all_ascii922_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii922_v0__137_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Try using perl
        perl_get_cjk_width__897_v0 "${stripped}";
        __AS=$?;
if [ $__AS != 0 ]; then
            __AMBER_LEN="${stripped}";
            __AF_get_visible_len923_v0="${#__AMBER_LEN}";
            return 0
fi;
        __AF_perl_get_cjk_width897_v0__139_16="$__AF_perl_get_cjk_width897_v0";
        __AF_get_visible_len923_v0="$__AF_perl_get_cjk_width897_v0__139_16";
        return 0
else
        __AMBER_LEN="${stripped}";
        __AF_get_visible_len923_v0="${#__AMBER_LEN}";
        return 0
fi
}
truncate_text__924_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__923_v0 "${text}";
    __AF_get_visible_len923_v0__150_23="$__AF_get_visible_len923_v0";
    local visible_len="$__AF_get_visible_len923_v0__150_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text924_v0="${text}";
        return 0
fi
    is_all_ascii__922_v0 "${text}";
    __AF_is_all_ascii922_v0__154_12="$__AF_is_all_ascii922_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii922_v0__154_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        perl_truncate_cjk__898_v0 "${text}" ${max_width};
        __AS=$?;
if [ $__AS != 0 ]; then
             printf "%s" "${text}" | cut -c1-${max_width} ;
            __AS=$?
fi;
        __AF_perl_truncate_cjk898_v0__155_16="${__AF_perl_truncate_cjk898_v0}";
        __AF_truncate_text924_v0="${__AF_perl_truncate_cjk898_v0__155_16}";
        return 0
fi
    __AMBER_VAL_177=$( printf "%s" "${text}" | cut -c1-${max_width} );
    __AS=$?;
    __AF_truncate_text924_v0="${__AMBER_VAL_177}";
    return 0
}
truncate_ansi__925_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__919_v0 "${text}";
    __AF_has_ansi_escape919_v0__166_12="$__AF_has_ansi_escape919_v0";
    if [ $(echo  '!' "$__AF_has_ansi_escape919_v0__166_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        truncate_text__924_v0 "${text}" ${max_width};
        __AF_truncate_text924_v0__167_16="${__AF_truncate_text924_v0}";
        __AF_truncate_ansi925_v0="${__AF_truncate_text924_v0__167_16}";
        return 0
fi
    # Check if text starts with \x1b[
    __AMBER_VAL_178=$( [[ "${text}" == '\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local starts_with_ansi="${__AMBER_VAL_178}"
    # Replace \x1b[ with newline, then split
    __AMBER_VAL_179=$( t="${text}"; printf '%s' "${t//\\x1b[/
}" );
    __AS=$?;
    local replaced="${__AMBER_VAL_179}"
    split__3_v0 "${replaced}" "
";
    __AF_split3_v0__176_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__176_17[@]}")
    local result=""
    local remaining_width=${max_width}
    for idx in $(seq 0 $(echo "${#parts[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local part="${parts[${idx}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ $(echo $(echo ${idx} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${starts_with_ansi}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                truncate_text__924_v0 "${part}" ${remaining_width};
                __AF_truncate_text924_v0__188_33="${__AF_truncate_text924_v0}";
                local truncated="${__AF_truncate_text924_v0__188_33}"
                result+="${truncated}"
                get_visible_len__923_v0 "${truncated}";
                __AF_get_visible_len923_v0__190_36="$__AF_get_visible_len923_v0";
                remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len923_v0__190_36" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
            # Part is "ANSIparams m text" format - find first 'm'
            __AMBER_VAL_180=$( __p="${part}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done );
            __AS=$?;
            local m_idx="${__AMBER_VAL_180}"
            if [ $([ "_${m_idx}" == "_" ]; echo $?) != 0 ]; then
                # Reconstruct ANSI sequence
                __AMBER_VAL_181=$( __p="${part}"; printf "%s" "${__p:0:${m_idx}}" );
                __AS=$?;
                local ansi_params="${__AMBER_VAL_181}"
                result+="\\x1b[""${ansi_params}""m"
                # Rest is text content
                parse_number__12_v0 "${m_idx}";
                __AS=$?;
                __AF_parse_number12_v0__201_39="$__AF_parse_number12_v0";
                local m_idx_num="$__AF_parse_number12_v0__201_39"
                local text_start=$(echo ${m_idx_num} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                __AMBER_VAL_182=$( __p="${part}"; printf "%s" "${__p:${text_start}}" );
                __AS=$?;
                local text_part="${__AMBER_VAL_182}"
                if [ $(echo $([ "_${text_part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__924_v0 "${text_part}" ${remaining_width};
                    __AF_truncate_text924_v0__205_37="${__AF_truncate_text924_v0}";
                    local truncated="${__AF_truncate_text924_v0__205_37}"
                    result+="${truncated}"
                    get_visible_len__923_v0 "${truncated}";
                    __AF_get_visible_len923_v0__207_40="$__AF_get_visible_len923_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len923_v0__207_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
                # No 'm' found, treat as text
                if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__924_v0 "${part}" ${remaining_width};
                    __AF_truncate_text924_v0__212_37="${__AF_truncate_text924_v0}";
                    local truncated="${__AF_truncate_text924_v0__212_37}"
                    result+="${truncated}"
                    get_visible_len__923_v0 "${truncated}";
                    __AF_get_visible_len923_v0__214_40="$__AF_get_visible_len923_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len923_v0__214_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
fi
fi
done
    __AF_truncate_ansi925_v0="${result}";
    return 0
}
cutoff_text__926_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__923_v0 "${text}";
    __AF_get_visible_len923_v0__226_23="$__AF_get_visible_len923_v0";
    local visible_len="$__AF_get_visible_len923_v0__226_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_cutoff_text926_v0="${text}";
        return 0
fi
    truncate_ansi__925_v0 "${text}" $(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_truncate_ansi925_v0__230_12="${__AF_truncate_ansi925_v0}";
    __AF_cutoff_text926_v0="${__AF_truncate_ansi925_v0__230_12}""...";
    return 0
}
# // Application Utilities /////
render_tooltip__927_v0() {
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
                eprintf_colored__907_v0 "${separator}" 90;
                __AF_eprintf_colored907_v0__253_27="$__AF_eprintf_colored907_v0";
                echo "$__AF_eprintf_colored907_v0__253_27" > /dev/null 2>&1
fi
            colored__908_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored908_v0__255_41="${__AF_colored908_v0}";
            __AMBER_ARRAY_183=("");
            eprintf__906_v0 "${items[${iter}]}"" ""${__AF_colored908_v0__255_41}" __AMBER_ARRAY_183[@];
            __AF_eprintf906_v0__255_13="$__AF_eprintf906_v0";
            echo "$__AF_eprintf906_v0__255_13" > /dev/null 2>&1
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
                eprintf_colored__907_v0 "${separator}" 90;
                __AF_eprintf_colored907_v0__281_17="$__AF_eprintf_colored907_v0";
                echo "$__AF_eprintf_colored907_v0__281_17" > /dev/null 2>&1
fi
            colored__908_v0 "${action}" 2;
            __AF_colored908_v0__283_33="${__AF_colored908_v0}";
            __AMBER_ARRAY_184=("");
            eprintf__906_v0 "${key}"" ""${__AF_colored908_v0__283_33}" __AMBER_ARRAY_184[@];
            __AF_eprintf906_v0__283_13="$__AF_eprintf906_v0";
            echo "$__AF_eprintf906_v0__283_13" > /dev/null 2>&1
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
__27__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__28__got_xylitol_colors=0
__AMBER_ARRAY_185=(3 207 159 92);
__29__primary_color=("${__AMBER_ARRAY_185[@]}")
__AMBER_ARRAY_186=(3 118 206 95);
__30__secondary_color=("${__AMBER_ARRAY_186[@]}")
__AMBER_ARRAY_187=(234 72 121 94);
__31__accent_color=("${__AMBER_ARRAY_187[@]}")
get_supports_truecolor__957_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __27__supports_truecolor="No"
        __AF_get_supports_truecolor957_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __27__supports_truecolor="No"
        __AF_get_supports_truecolor957_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __27__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor957_v0=$([ "_${__27__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__958_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__27__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb958_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__27__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__957_v0 ;
            __AF_get_supports_truecolor957_v0__50_17="$__AF_get_supports_truecolor957_v0";
            if [ "$__AF_get_supports_truecolor957_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb958_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb958_v0="${message}";
                return 0
else
                __AF_colored_rgb958_v0="\x1b[${fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb958_v0="${message}";
            return 0
fi
        __AF_colored_rgb958_v0="\x1b[${fallback}m""${message}""\x1b[0m";
        return 0
fi
}
background_rgb__959_v0() {
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
    if [ $([ "_${__27__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_background_rgb959_v0="\x1b[48;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__27__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__957_v0 ;
            __AF_get_supports_truecolor957_v0__92_17="$__AF_get_supports_truecolor957_v0";
            if [ "$__AF_get_supports_truecolor957_v0__92_17" != 0 ]; then
                                    __AF_background_rgb959_v0="\x1b[48;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${bg_fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_background_rgb959_v0="${message}";
                return 0
else
                __AF_background_rgb959_v0="\x1b[${bg_fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${bg_fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_background_rgb959_v0="${message}";
            return 0
fi
        __AF_background_rgb959_v0="\x1b[${bg_fallback}m""${message}""\x1b[0m";
        return 0
fi
}
inner_get_xylitol_colors__960_v0() {
    if [ $(echo  '!' ${__28__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_188=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __29__primary_color=("${__AMBER_ARRAY_188[@]}")
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
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_189=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __30__secondary_color=("${__AMBER_ARRAY_189[@]}")
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
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors960_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_190=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __31__accent_color=("${__AMBER_ARRAY_190[@]}")
fi
fi
        __28__got_xylitol_colors=1
fi
}
get_xylitol_colors__961_v0() {
    inner_get_xylitol_colors__960_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors960_v0__154_5="$__AF_inner_get_xylitol_colors960_v0";
    echo "$__AF_inner_get_xylitol_colors960_v0__154_5" > /dev/null 2>&1
    __28__got_xylitol_colors=1
}
colored_primary__962_v0() {
    local message=$1
    if [ $(echo  '!' ${__28__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__961_v0 ;
        __AF_get_xylitol_colors961_v0__162_9="$__AF_get_xylitol_colors961_v0";
        echo "$__AF_get_xylitol_colors961_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__958_v0 "${message}" "${__29__primary_color[0]}" "${__29__primary_color[1]}" "${__29__primary_color[2]}" "${__29__primary_color[3]}";
    __AF_colored_rgb958_v0__164_12="${__AF_colored_rgb958_v0}";
    __AF_colored_primary962_v0="${__AF_colored_rgb958_v0__164_12}";
    return 0
}
colored_secondary__963_v0() {
    local message=$1
    if [ $(echo  '!' ${__28__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__961_v0 ;
        __AF_get_xylitol_colors961_v0__169_9="$__AF_get_xylitol_colors961_v0";
        echo "$__AF_get_xylitol_colors961_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__958_v0 "${message}" "${__30__secondary_color[0]}" "${__30__secondary_color[1]}" "${__30__secondary_color[2]}" "${__30__secondary_color[3]}";
    __AF_colored_rgb958_v0__171_12="${__AF_colored_rgb958_v0}";
    __AF_colored_secondary963_v0="${__AF_colored_rgb958_v0__171_12}";
    return 0
}
background_secondary__966_v0() {
    local message=$1
    if [ $(echo  '!' ${__28__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__961_v0 ;
        __AF_get_xylitol_colors961_v0__190_9="$__AF_get_xylitol_colors961_v0";
        echo "$__AF_get_xylitol_colors961_v0__190_9" > /dev/null 2>&1
fi
    background_rgb__959_v0 "${message}" "${__30__secondary_color[0]}" "${__30__secondary_color[1]}" "${__30__secondary_color[2]}" "${__30__secondary_color[3]}";
    __AF_background_rgb959_v0__192_12="${__AF_background_rgb959_v0}";
    __AF_background_secondary966_v0="${__AF_background_rgb959_v0__192_12}";
    return 0
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__32__got_term_size=0
__AMBER_ARRAY_191=(80 24);
__33__term_size=("${__AMBER_ARRAY_191[@]}")
get_term_size__979_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    __AMBER_VAL_192=$( printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_192}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size979_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size979_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size979_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_193=(${cols} ${rows});
    __33__term_size=("${__AMBER_ARRAY_193[@]}")
    __32__got_term_size=1
}
term_width__981_v0() {
    if [ $(echo  '!' ${__32__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__979_v0 ;
        __AS=$?;
        __AF_get_term_size979_v0__33_15="$__AF_get_term_size979_v0";
        echo "$__AF_get_term_size979_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width981_v0="${__33__term_size[0]}";
    return 0
}
render_confirm_options__986_v0() {
    local selected=$1
    local term_width=$2
    local small=$(echo ${term_width} '<' 30 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local yes_label=$(if [ ${small} != 0 ]; then echo " Yes "; else echo "    Yes    "; fi)
    local no_label=$(if [ ${small} != 0 ]; then echo " No "; else echo "    No    "; fi)
    local gap=$(if [ ${small} != 0 ]; then echo " "; else echo "  "; fi)
    __AMBER_ARRAY_194=("");
    eprintf__906_v0 " " __AMBER_ARRAY_194[@];
    __AF_eprintf906_v0__14_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__14_5" > /dev/null 2>&1
    if [ ${selected} != 0 ]; then
        # Yes selected
        background_secondary__966_v0 "${yes_label}";
        __AF_background_secondary966_v0__17_30="${__AF_background_secondary966_v0}";
        __AMBER_ARRAY_195=("");
        eprintf__906_v0 "\x1b[97m""${__AF_background_secondary966_v0__17_30}" __AMBER_ARRAY_195[@];
        __AF_eprintf906_v0__17_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_196=("");
        eprintf__906_v0 "${gap}" __AMBER_ARRAY_196[@];
        __AF_eprintf906_v0__18_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__18_9" > /dev/null 2>&1
        # No not selected (dim)
        __AMBER_ARRAY_197=("");
        eprintf__906_v0 "\x1b[49;37m""${no_label}""\x1b[0m" __AMBER_ARRAY_197[@];
        __AF_eprintf906_v0__20_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__20_9" > /dev/null 2>&1
else
        # No selected
        __AMBER_ARRAY_198=("");
        eprintf__906_v0 "\x1b[49;37m""${yes_label}""\x1b[0m" __AMBER_ARRAY_198[@];
        __AF_eprintf906_v0__23_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__23_9" > /dev/null 2>&1
        __AMBER_ARRAY_199=("");
        eprintf__906_v0 "${gap}" __AMBER_ARRAY_199[@];
        __AF_eprintf906_v0__24_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__24_9" > /dev/null 2>&1
        background_secondary__966_v0 "${no_label}";
        __AF_background_secondary966_v0__25_30="${__AF_background_secondary966_v0}";
        __AMBER_ARRAY_200=("");
        eprintf__906_v0 "\x1b[97m""${__AF_background_secondary966_v0__25_30}" __AMBER_ARRAY_200[@];
        __AF_eprintf906_v0__25_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__25_9" > /dev/null 2>&1
fi
}
xyl_confirm__987_v0() {
    local header=$1
    local default_yes=$2
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__917_v0 ;
    __AF_hide_cursor917_v0__42_5="$__AF_hide_cursor917_v0";
    echo "$__AF_hide_cursor917_v0__42_5" > /dev/null 2>&1
    term_width__981_v0 ;
    __AF_term_width981_v0__44_22="$__AF_term_width981_v0";
    local term_width="$__AF_term_width981_v0__44_22"
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        cutoff_text__926_v0 "${header}" ${term_width};
        __AF_cutoff_text926_v0__47_17="${__AF_cutoff_text926_v0}";
        __AMBER_ARRAY_201=("");
        eprintf__906_v0 "${__AF_cutoff_text926_v0__47_17}""

" __AMBER_ARRAY_201[@];
        __AF_eprintf906_v0__47_9="$__AF_eprintf906_v0";
        echo "$__AF_eprintf906_v0__47_9" > /dev/null 2>&1
fi
    local selected=${default_yes}
    # Render initial options
    render_confirm_options__986_v0 ${selected} ${term_width};
    __AF_render_confirm_options986_v0__53_5="$__AF_render_confirm_options986_v0";
    echo "$__AF_render_confirm_options986_v0__53_5" > /dev/null 2>&1
    __AMBER_ARRAY_202=("");
    eprintf__906_v0 "

" __AMBER_ARRAY_202[@];
    __AF_eprintf906_v0__55_5="$__AF_eprintf906_v0";
    echo "$__AF_eprintf906_v0__55_5" > /dev/null 2>&1
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    __AMBER_ARRAY_203=("←→" "select" "enter" "confirm" "y" "yes" "n" "no");
    render_tooltip__927_v0 __AMBER_ARRAY_203[@] 40 ${term_width};
    __AF_render_tooltip927_v0__57_5="$__AF_render_tooltip927_v0";
    echo "$__AF_render_tooltip927_v0__57_5" > /dev/null 2>&1
    go_up__914_v0 2;
    __AF_go_up914_v0__58_5="$__AF_go_up914_v0";
    echo "$__AF_go_up914_v0__58_5" > /dev/null 2>&1
    while :
do
        get_key__904_v0 ;
        __AF_get_key904_v0__61_19="${__AF_get_key904_v0}";
        local key="${__AF_get_key904_v0__61_19}"
        if [ $(echo $(echo $(echo $([ "_${key}" != "_LEFT" ]; echo $?) '||' $([ "_${key}" != "_h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_RIGHT" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${key}" != "_l" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            if [ ${selected} != 0 ]; then
                selected=0
                __AMBER_ARRAY_204=("");
                eprintf__906_v0 "\x1b[9999D\x1b[K" __AMBER_ARRAY_204[@];
                __AF_eprintf906_v0__68_25="$__AF_eprintf906_v0";
                echo "$__AF_eprintf906_v0__68_25" > /dev/null 2>&1
                render_confirm_options__986_v0 ${selected} ${term_width};
                __AF_render_confirm_options986_v0__69_25="$__AF_render_confirm_options986_v0";
                echo "$__AF_render_confirm_options986_v0__69_25" > /dev/null 2>&1
elif [ $(echo  '!' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                selected=1
                __AMBER_ARRAY_205=("");
                eprintf__906_v0 "\x1b[9999D\x1b[K" __AMBER_ARRAY_205[@];
                __AF_eprintf906_v0__73_25="$__AF_eprintf906_v0";
                echo "$__AF_eprintf906_v0__73_25" > /dev/null 2>&1
                render_confirm_options__986_v0 ${selected} ${term_width};
                __AF_render_confirm_options986_v0__74_25="$__AF_render_confirm_options986_v0";
                echo "$__AF_render_confirm_options986_v0__74_25" > /dev/null 2>&1
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
    go_down__915_v0 2;
    __AF_go_down915_v0__99_5="$__AF_go_down915_v0";
    echo "$__AF_go_down915_v0__99_5" > /dev/null 2>&1
    remove_line__910_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line910_v0__100_5="$__AF_remove_line910_v0";
    echo "$__AF_remove_line910_v0__100_5" > /dev/null 2>&1
    remove_current_line__911_v0 ;
    __AF_remove_current_line911_v0__101_5="$__AF_remove_current_line911_v0";
    echo "$__AF_remove_current_line911_v0__101_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__918_v0 ;
    __AF_show_cursor918_v0__104_5="$__AF_show_cursor918_v0";
    echo "$__AF_show_cursor918_v0__104_5" > /dev/null 2>&1
    __AF_xyl_confirm987_v0=${selected};
    return 0
}
print_confirm_help__1023_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    colored_primary__962_v0 "confirm";
    __AF_colored_primary962_v0__7_12="${__AF_colored_primary962_v0}";
    __AMBER_ARRAY_206=("");
    printf__99_v0 "${__AF_colored_primary962_v0__7_12}" __AMBER_ARRAY_206[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_207=("");
    printf__99_v0 " - Display a Yes/No confirmation dialog." __AMBER_ARRAY_207[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__963_v0 "Flags: ";
    __AF_colored_secondary963_v0__11_12="${__AF_colored_secondary963_v0}";
    __AMBER_ARRAY_208=("");
    printf__99_v0 "${__AF_colored_secondary963_v0__11_12}""
" __AMBER_ARRAY_208[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    echo ""
}
execute_confirm__1059_v0() {
    local parameters=("${!1}")
    colored_primary__962_v0 "Are you sure?";
    __AF_colored_primary962_v0__10_30="${__AF_colored_primary962_v0}";
    local header="\x1b[1m""${__AF_colored_primary962_v0__10_30}"
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
            print_confirm_help__1023_v0 ;
            __AF_print_confirm_help1023_v0__16_17="$__AF_print_confirm_help1023_v0";
            echo "$__AF_print_confirm_help1023_v0__16_17" > /dev/null 2>&1
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
                                    eprintf_colored__907_v0 "ERROR: Invalid default value: ""${result[1]}"". Use 'yes' or 'no'.
" 31;
                    __AF_eprintf_colored907_v0__29_25="$__AF_eprintf_colored907_v0";
                    echo "$__AF_eprintf_colored907_v0__29_25" > /dev/null 2>&1
                    exit 1
fi
fi
done
    has_ansi_escape__919_v0 "${header}";
    __AF_has_ansi_escape919_v0__37_42="$__AF_has_ansi_escape919_v0";
    escape_ansi__920_v0 "${header}";
    __AF_escape_ansi920_v0__37_71="${__AF_escape_ansi920_v0}";
    colored_primary__962_v0 "${header}";
    __AF_colored_primary962_v0__37_109="${__AF_colored_primary962_v0}";
    local display_header=$(if [ $(echo $([ "_${header}" != "_" ]; echo $?) '||' "$__AF_has_ansi_escape919_v0__37_42" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "${__AF_escape_ansi920_v0__37_71}"; else echo "\\x1b[1m""${__AF_colored_primary962_v0__37_109}"; fi)
    xyl_confirm__987_v0 "${display_header}" ${default_yes};
    __AF_xyl_confirm987_v0__38_18="$__AF_xyl_confirm987_v0";
    local result="$__AF_xyl_confirm987_v0__38_18"
    __AF_execute_confirm1059_v0=$(if [ ${result} != 0 ]; then echo "yes"; else echo "no"; fi);
    return 0
}
# Perl Extensions Utilities
__AMBER_VAL_209=$( echo "$XYLITOL_USE_PERL" );
__AS=$?;
__34__perl_disabled=$([ "_${__AMBER_VAL_209}" != "_No" ]; echo $?)
__AMBER_VAL_210=$( command -v perl > /dev/null && echo 0 || echo 1 );
__AS=$?;
__35__perl_available=$(echo $(echo  '!' ${__34__perl_disabled} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${__AMBER_VAL_210}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
# // IO Functions /////
eprintf__1153_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__1154_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_211=("${message}");
    eprintf__1153_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_211[@];
    __AF_eprintf1153_v0__39_5="$__AF_eprintf1153_v0";
    echo "$__AF_eprintf1153_v0__39_5" > /dev/null 2>&1
}
remove_current_line__1158_v0() {
    __AMBER_ARRAY_212=("");
    eprintf__1153_v0 "\x1b[2K\x1b[9999D" __AMBER_ARRAY_212[@];
    __AF_eprintf1153_v0__60_5="$__AF_eprintf1153_v0";
    echo "$__AF_eprintf1153_v0__60_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
__36__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__37__got_xylitol_colors=0
__AMBER_ARRAY_213=(3 207 159 92);
__38__primary_color=("${__AMBER_ARRAY_213[@]}")
__AMBER_ARRAY_214=(3 118 206 95);
__39__secondary_color=("${__AMBER_ARRAY_214[@]}")
__AMBER_ARRAY_215=(234 72 121 94);
__40__accent_color=("${__AMBER_ARRAY_215[@]}")
get_supports_truecolor__1204_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __36__supports_truecolor="No"
        __AF_get_supports_truecolor1204_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __36__supports_truecolor="No"
        __AF_get_supports_truecolor1204_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __36__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor1204_v0=$([ "_${__36__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__1205_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__36__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb1205_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__36__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__1204_v0 ;
            __AF_get_supports_truecolor1204_v0__50_17="$__AF_get_supports_truecolor1204_v0";
            if [ "$__AF_get_supports_truecolor1204_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb1205_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb1205_v0="${message}";
                return 0
else
                __AF_colored_rgb1205_v0="\x1b[${fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb1205_v0="${message}";
            return 0
fi
        __AF_colored_rgb1205_v0="\x1b[${fallback}m""${message}""\x1b[0m";
        return 0
fi
}
inner_get_xylitol_colors__1207_v0() {
    if [ $(echo  '!' ${__37__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_216=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __38__primary_color=("${__AMBER_ARRAY_216[@]}")
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
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_217=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __39__secondary_color=("${__AMBER_ARRAY_217[@]}")
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
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1207_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_218=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __40__accent_color=("${__AMBER_ARRAY_218[@]}")
fi
fi
        __37__got_xylitol_colors=1
fi
}
get_xylitol_colors__1208_v0() {
    inner_get_xylitol_colors__1207_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors1207_v0__154_5="$__AF_inner_get_xylitol_colors1207_v0";
    echo "$__AF_inner_get_xylitol_colors1207_v0__154_5" > /dev/null 2>&1
    __37__got_xylitol_colors=1
}
colored_primary__1209_v0() {
    local message=$1
    if [ $(echo  '!' ${__37__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__1208_v0 ;
        __AF_get_xylitol_colors1208_v0__162_9="$__AF_get_xylitol_colors1208_v0";
        echo "$__AF_get_xylitol_colors1208_v0__162_9" > /dev/null 2>&1
fi
    colored_rgb__1205_v0 "${message}" "${__38__primary_color[0]}" "${__38__primary_color[1]}" "${__38__primary_color[2]}" "${__38__primary_color[3]}";
    __AF_colored_rgb1205_v0__164_12="${__AF_colored_rgb1205_v0}";
    __AF_colored_primary1209_v0="${__AF_colored_rgb1205_v0__164_12}";
    return 0
}
colored_secondary__1210_v0() {
    local message=$1
    if [ $(echo  '!' ${__37__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__1208_v0 ;
        __AF_get_xylitol_colors1208_v0__169_9="$__AF_get_xylitol_colors1208_v0";
        echo "$__AF_get_xylitol_colors1208_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__1205_v0 "${message}" "${__39__secondary_color[0]}" "${__39__secondary_color[1]}" "${__39__secondary_color[2]}" "${__39__secondary_color[3]}";
    __AF_colored_rgb1205_v0__171_12="${__AF_colored_rgb1205_v0}";
    __AF_colored_secondary1210_v0="${__AF_colored_rgb1205_v0__171_12}";
    return 0
}
colored_accent__1211_v0() {
    local message=$1
    if [ $(echo  '!' ${__37__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__1208_v0 ;
        __AF_get_xylitol_colors1208_v0__176_9="$__AF_get_xylitol_colors1208_v0";
        echo "$__AF_get_xylitol_colors1208_v0__176_9" > /dev/null 2>&1
fi
    colored_rgb__1205_v0 "${message}" "${__40__accent_color[0]}" "${__40__accent_color[1]}" "${__40__accent_color[2]}" "${__40__accent_color[3]}";
    __AF_colored_rgb1205_v0__178_12="${__AF_colored_rgb1205_v0}";
    __AF_colored_accent1211_v0="${__AF_colored_rgb1205_v0__178_12}";
    return 0
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__41__got_term_size=0
__AMBER_ARRAY_219=(80 24);
__42__term_size=("${__AMBER_ARRAY_219[@]}")
get_term_size__1226_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    __AMBER_VAL_220=$( printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_220}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size1226_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size1226_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size1226_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_221=(${cols} ${rows});
    __42__term_size=("${__AMBER_ARRAY_221[@]}")
    __41__got_term_size=1
}
term_width__1228_v0() {
    if [ $(echo  '!' ${__41__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__1226_v0 ;
        __AS=$?;
        __AF_get_term_size1226_v0__33_15="$__AF_get_term_size1226_v0";
        echo "$__AF_get_term_size1226_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width1228_v0="${__42__term_size[0]}";
    return 0
}
get_directory_entries__1236_v0() {
    local path=$1
    __AMBER_VAL_222=$( ls -lA "${path}" 2>/dev/null | tail -n +2 );
    __AS=$?;
    local raw="${__AMBER_VAL_222}"
    __AMBER_VAL_223=$( ls -lA "${path}" | tail -n +2 | sed -E 's/^(.).*/\1/' );
    __AS=$?;
    local types="${__AMBER_VAL_223}"
    __AMBER_VAL_224=$( ls -1A "${path}" );
    __AS=$?;
    local names="${__AMBER_VAL_224}"
    split__3_v0 "${types}" "
";
    __AF_split3_v0__10_17=("${__AF_split3_v0[@]}");
    local types=("${__AF_split3_v0__10_17[@]}")
    split__3_v0 "${raw}" "
";
    __AF_split3_v0__11_15=("${__AF_split3_v0[@]}");
    local raw=("${__AF_split3_v0__11_15[@]}")
    split__3_v0 "${names}" "
";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local names=("${__AF_split3_v0__12_17[@]}")
    __AMBER_ARRAY_225=();
    local entries=("${__AMBER_ARRAY_225[@]}")
    for i in $(seq 0 $(echo "${#raw[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local file_type="f"
        local target=""
        if [ $([ "_${types[${i}]}" != "_-" ]; echo $?) != 0 ]; then
            file_type="f"
elif [ $([ "_${types[${i}]}" != "_l" ]; echo $?) != 0 ]; then
            __AMBER_VAL_226=$( echo ${raw[${i}]} | sed 's/.*-> //' );
            __AS=$?;
            target="${__AMBER_VAL_226}"
            file_type="l"
fi
        if [ $([ "_${file_type}" != "_l" ]; echo $?) != 0 ]; then
            __AMBER_ARRAY_227=("${names[${i}]}	${types[${i}]}	${target}");
            entries+=("${__AMBER_ARRAY_227[@]}")
else
            __AMBER_ARRAY_228=("${names[${i}]}	${types[${i}]}");
            entries+=("${__AMBER_ARRAY_228[@]}")
fi
done
    __AF_get_directory_entries1236_v0=("${entries[@]}");
    return 0
}
parse_entry__1237_v0() {
    local entry=$1
    split__3_v0 "${entry}" "	";
    __AF_split3_v0__40_12=("${__AF_split3_v0[@]}");
    __AF_parse_entry1237_v0=("${__AF_split3_v0__40_12[@]}");
    return 0
}
get_cwd__1238_v0() {
    __AMBER_VAL_229=$( pwd );
    __AS=$?;
    __AF_get_cwd1238_v0="${__AMBER_VAL_229}";
    return 0
}
normalize_path__1239_v0() {
    local path=$1
    __AMBER_VAL_230=$( cd "${path}" 2>/dev/null && pwd );
    __AS=$?;
    local normalized="${__AMBER_VAL_230}"
    if [ $([ "_${normalized}" != "_" ]; echo $?) != 0 ]; then
        __AF_normalize_path1239_v0="${path}";
        return 0
fi
    __AF_normalize_path1239_v0="${normalized}";
    return 0
}
path_join__1241_v0() {
    local base=$1
    local child=$2
    if [ $([ "_${base}" != "_/" ]; echo $?) != 0 ]; then
        __AF_path_join1241_v0="/""${child}";
        return 0
fi
    __AF_path_join1241_v0="${base}""/""${child}";
    return 0
}
get_parent_dir__1242_v0() {
    local path=$1
    __AMBER_VAL_231=$( dirname "${path}" );
    __AS=$?;
    local parent="${__AMBER_VAL_231}"
    __AF_get_parent_dir1242_v0="${parent}";
    return 0
}
# Perl Extensions Utilities
__AMBER_VAL_232=$( echo "$XYLITOL_USE_PERL" );
__AS=$?;
__43__perl_disabled=$([ "_${__AMBER_VAL_232}" != "_No" ]; echo $?)
__AMBER_VAL_233=$( command -v perl > /dev/null && echo 0 || echo 1 );
__AS=$?;
__44__perl_available=$(echo $(echo  '!' ${__43__perl_disabled} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${__AMBER_VAL_233}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
perl_get_cjk_width__1310_v0() {
    local text=$1
    if [ $(echo  '!' ${__44__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_get_cjk_width1310_v0='';
        return 1
fi
    __AMBER_VAL_234=$( perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width1310_v0=''
return $__AS
fi;
    local width_str="${__AMBER_VAL_234}"
    parse_number__12_v0 "${width_str}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_get_cjk_width1310_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__14_17="$__AF_parse_number12_v0";
    local width="$__AF_parse_number12_v0__14_17"
    __AF_perl_get_cjk_width1310_v0=${width};
    return 0
}
perl_truncate_cjk__1311_v0() {
    local text=$1
    local max_width=$2
    if [ $(echo  '!' ${__44__perl_available} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_perl_truncate_cjk1311_v0='';
        return 1
fi
    __AMBER_VAL_235=$( perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_perl_truncate_cjk1311_v0=''
return $__AS
fi;
    local result="${__AMBER_VAL_235}"
    __AF_perl_truncate_cjk1311_v0="${result}";
    return 0
}
# // IO Functions /////
get_key__1317_v0() {
    __AMBER_VAL_236=$( read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k" );
    __AS=$?;
    local var="${__AMBER_VAL_236}"
    if [ $([ "_${var}" != "_\$'\E[A'" ]; echo $?) != 0 ]; then
        __AF_get_key1317_v0="UP";
        return 0
elif [ $([ "_${var}" != "_\$'\E[B'" ]; echo $?) != 0 ]; then
        __AF_get_key1317_v0="DOWN";
        return 0
elif [ $([ "_${var}" != "_\$'\E[C'" ]; echo $?) != 0 ]; then
        __AF_get_key1317_v0="RIGHT";
        return 0
elif [ $([ "_${var}" != "_\$'\E[D'" ]; echo $?) != 0 ]; then
        __AF_get_key1317_v0="LEFT";
        return 0
elif [ $([ "_${var}" != "_\$'\177'" ]; echo $?) != 0 ]; then
        __AF_get_key1317_v0="BACKSPACE";
        return 0
elif [ $([ "_${var}" != "_''" ]; echo $?) != 0 ]; then
        __AF_get_key1317_v0="INPUT";
        return 0
else
        __AF_get_key1317_v0="${var}";
        return 0
fi
}
eprintf__1319_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" >&2 ;
    __AS=$?
}
eprintf_colored__1320_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    __AMBER_ARRAY_237=("${message}");
    eprintf__1319_v0 "\x1b[${color}m%s\x1b[0m" __AMBER_ARRAY_237[@];
    __AF_eprintf1319_v0__39_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__39_5" > /dev/null 2>&1
}
colored__1321_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    __AF_colored1321_v0="\x1b[${color}m""${message}""\x1b[0m";
    return 0
}
remove_line__1323_v0() {
    local cnt=$1
     printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2 ;
    __AS=$?
    __AMBER_ARRAY_238=("");
    eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_238[@];
    __AF_eprintf1319_v0__55_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__55_5" > /dev/null 2>&1
}
remove_current_line__1324_v0() {
    __AMBER_ARRAY_239=("");
    eprintf__1319_v0 "\x1b[2K\x1b[9999D" __AMBER_ARRAY_239[@];
    __AF_eprintf1319_v0__60_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__60_5" > /dev/null 2>&1
}
print_blank__1325_v0() {
    local cnt=$1
     printf '%*s' "${cnt}" ' ' >&2 ;
    __AS=$?
}
new_line__1326_v0() {
    local cnt=$1
    for i in $(seq 0 $(echo ${cnt} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_240=("");
        eprintf__1319_v0 "
" __AMBER_ARRAY_240[@];
        __AF_eprintf1319_v0__72_9="$__AF_eprintf1319_v0";
        echo "$__AF_eprintf1319_v0__72_9" > /dev/null 2>&1
done
}
go_up__1327_v0() {
    local cnt=$1
    __AMBER_ARRAY_241=("");
    eprintf__1319_v0 "\x1b[${cnt}A" __AMBER_ARRAY_241[@];
    __AF_eprintf1319_v0__78_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__78_5" > /dev/null 2>&1
}
go_down__1328_v0() {
    local cnt=$1
    __AMBER_ARRAY_242=("");
    eprintf__1319_v0 "\x1b[${cnt}B" __AMBER_ARRAY_242[@];
    __AF_eprintf1319_v0__83_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__83_5" > /dev/null 2>&1
}
# move the cursor up or down `cnt` lines.
go_up_or_down__1329_v0() {
    local cnt=$1
    if [ $(echo ${cnt} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        go_down__1328_v0 ${cnt};
        __AF_go_down1328_v0__89_9="$__AF_go_down1328_v0";
        echo "$__AF_go_down1328_v0__89_9" > /dev/null 2>&1
else
        go_up__1327_v0 $(echo  '-' ${cnt} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
        __AF_go_up1327_v0__91_9="$__AF_go_up1327_v0";
        echo "$__AF_go_up1327_v0__91_9" > /dev/null 2>&1
fi
}
hide_cursor__1330_v0() {
    __AMBER_ARRAY_243=("");
    eprintf__1319_v0 "\x1b[?25l" __AMBER_ARRAY_243[@];
    __AF_eprintf1319_v0__96_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__96_5" > /dev/null 2>&1
}
show_cursor__1331_v0() {
    __AMBER_ARRAY_244=("");
    eprintf__1319_v0 "\x1b[?25h" __AMBER_ARRAY_244[@];
    __AF_eprintf1319_v0__100_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__100_5" > /dev/null 2>&1
}
# / Text Utilities /////
has_ansi_escape__1332_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    __AMBER_VAL_245=$( [[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local has_escape="${__AMBER_VAL_245}"
    __AF_has_ansi_escape1332_v0=$([ "_${has_escape}" != "_1" ]; echo $?);
    return 0
}
strip_ansi__1334_v0() {
    local text=$1
    __AMBER_VAL_246=$( printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g' );
    __AS=$?;
    __AF_strip_ansi1334_v0="${__AMBER_VAL_246}";
    return 0
}
is_all_ascii__1335_v0() {
    local text=$1
    __AMBER_VAL_247=$( printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1 );
    __AS=$?;
    local result="${__AMBER_VAL_247}"
    __AF_is_all_ascii1335_v0=$([ "_${result}" != "_0" ]; echo $?);
    return 0
}
get_visible_len__1336_v0() {
    local text=$1
    strip_ansi__1334_v0 "${text}";
    __AF_strip_ansi1334_v0__135_20="${__AF_strip_ansi1334_v0}";
    local stripped="${__AF_strip_ansi1334_v0__135_20}"
    # Check if text is all ASCII
    is_all_ascii__1335_v0 "${stripped}";
    __AF_is_all_ascii1335_v0__137_12="$__AF_is_all_ascii1335_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii1335_v0__137_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1310_v0 "${stripped}";
        __AS=$?;
if [ $__AS != 0 ]; then
            __AMBER_LEN="${stripped}";
            __AF_get_visible_len1336_v0="${#__AMBER_LEN}";
            return 0
fi;
        __AF_perl_get_cjk_width1310_v0__139_16="$__AF_perl_get_cjk_width1310_v0";
        __AF_get_visible_len1336_v0="$__AF_perl_get_cjk_width1310_v0__139_16";
        return 0
else
        __AMBER_LEN="${stripped}";
        __AF_get_visible_len1336_v0="${#__AMBER_LEN}";
        return 0
fi
}
truncate_text__1337_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1336_v0 "${text}";
    __AF_get_visible_len1336_v0__150_23="$__AF_get_visible_len1336_v0";
    local visible_len="$__AF_get_visible_len1336_v0__150_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_truncate_text1337_v0="${text}";
        return 0
fi
    is_all_ascii__1335_v0 "${text}";
    __AF_is_all_ascii1335_v0__154_12="$__AF_is_all_ascii1335_v0";
    if [ $(echo  '!' "$__AF_is_all_ascii1335_v0__154_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        perl_truncate_cjk__1311_v0 "${text}" ${max_width};
        __AS=$?;
if [ $__AS != 0 ]; then
             printf "%s" "${text}" | cut -c1-${max_width} ;
            __AS=$?
fi;
        __AF_perl_truncate_cjk1311_v0__155_16="${__AF_perl_truncate_cjk1311_v0}";
        __AF_truncate_text1337_v0="${__AF_perl_truncate_cjk1311_v0__155_16}";
        return 0
fi
    __AMBER_VAL_248=$( printf "%s" "${text}" | cut -c1-${max_width} );
    __AS=$?;
    __AF_truncate_text1337_v0="${__AMBER_VAL_248}";
    return 0
}
truncate_ansi__1338_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1332_v0 "${text}";
    __AF_has_ansi_escape1332_v0__166_12="$__AF_has_ansi_escape1332_v0";
    if [ $(echo  '!' "$__AF_has_ansi_escape1332_v0__166_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        truncate_text__1337_v0 "${text}" ${max_width};
        __AF_truncate_text1337_v0__167_16="${__AF_truncate_text1337_v0}";
        __AF_truncate_ansi1338_v0="${__AF_truncate_text1337_v0__167_16}";
        return 0
fi
    # Check if text starts with \x1b[
    __AMBER_VAL_249=$( [[ "${text}" == '\x1b['* ]] && echo "1" || echo "0" );
    __AS=$?;
    local starts_with_ansi="${__AMBER_VAL_249}"
    # Replace \x1b[ with newline, then split
    __AMBER_VAL_250=$( t="${text}"; printf '%s' "${t//\\x1b[/
}" );
    __AS=$?;
    local replaced="${__AMBER_VAL_250}"
    split__3_v0 "${replaced}" "
";
    __AF_split3_v0__176_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__176_17[@]}")
    local result=""
    local remaining_width=${max_width}
    for idx in $(seq 0 $(echo "${#parts[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        local part="${parts[${idx}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ $(echo $(echo ${idx} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${starts_with_ansi}" != "_0" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                truncate_text__1337_v0 "${part}" ${remaining_width};
                __AF_truncate_text1337_v0__188_33="${__AF_truncate_text1337_v0}";
                local truncated="${__AF_truncate_text1337_v0__188_33}"
                result+="${truncated}"
                get_visible_len__1336_v0 "${truncated}";
                __AF_get_visible_len1336_v0__190_36="$__AF_get_visible_len1336_v0";
                remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len1336_v0__190_36" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
            # Part is "ANSIparams m text" format - find first 'm'
            __AMBER_VAL_251=$( __p="${part}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done );
            __AS=$?;
            local m_idx="${__AMBER_VAL_251}"
            if [ $([ "_${m_idx}" == "_" ]; echo $?) != 0 ]; then
                # Reconstruct ANSI sequence
                __AMBER_VAL_252=$( __p="${part}"; printf "%s" "${__p:0:${m_idx}}" );
                __AS=$?;
                local ansi_params="${__AMBER_VAL_252}"
                result+="\\x1b[""${ansi_params}""m"
                # Rest is text content
                parse_number__12_v0 "${m_idx}";
                __AS=$?;
                __AF_parse_number12_v0__201_39="$__AF_parse_number12_v0";
                local m_idx_num="$__AF_parse_number12_v0__201_39"
                local text_start=$(echo ${m_idx_num} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
                __AMBER_VAL_253=$( __p="${part}"; printf "%s" "${__p:${text_start}}" );
                __AS=$?;
                local text_part="${__AMBER_VAL_253}"
                if [ $(echo $([ "_${text_part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__1337_v0 "${text_part}" ${remaining_width};
                    __AF_truncate_text1337_v0__205_37="${__AF_truncate_text1337_v0}";
                    local truncated="${__AF_truncate_text1337_v0__205_37}"
                    result+="${truncated}"
                    get_visible_len__1336_v0 "${truncated}";
                    __AF_get_visible_len1336_v0__207_40="$__AF_get_visible_len1336_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len1336_v0__207_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
else
                # No 'm' found, treat as text
                if [ $(echo $([ "_${part}" == "_" ]; echo $?) '&&' $(echo ${remaining_width} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    truncate_text__1337_v0 "${part}" ${remaining_width};
                    __AF_truncate_text1337_v0__212_37="${__AF_truncate_text1337_v0}";
                    local truncated="${__AF_truncate_text1337_v0__212_37}"
                    result+="${truncated}"
                    get_visible_len__1336_v0 "${truncated}";
                    __AF_get_visible_len1336_v0__214_40="$__AF_get_visible_len1336_v0";
                    remaining_width=$(echo ${remaining_width} '-' "$__AF_get_visible_len1336_v0__214_40" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
fi
fi
done
    __AF_truncate_ansi1338_v0="${result}";
    return 0
}
cutoff_text__1339_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1336_v0 "${text}";
    __AF_get_visible_len1336_v0__226_23="$__AF_get_visible_len1336_v0";
    local visible_len="$__AF_get_visible_len1336_v0__226_23"
    if [ $(echo ${visible_len} '<=' ${max_width} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_cutoff_text1339_v0="${text}";
        return 0
fi
    truncate_ansi__1338_v0 "${text}" $(echo ${max_width} '-' 3 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_truncate_ansi1338_v0__230_12="${__AF_truncate_ansi1338_v0}";
    __AF_cutoff_text1339_v0="${__AF_truncate_ansi1338_v0__230_12}""...";
    return 0
}
# // Application Utilities /////
render_tooltip__1340_v0() {
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
                eprintf_colored__1320_v0 "${separator}" 90;
                __AF_eprintf_colored1320_v0__253_27="$__AF_eprintf_colored1320_v0";
                echo "$__AF_eprintf_colored1320_v0__253_27" > /dev/null 2>&1
fi
            colored__1321_v0 "${items[$(echo ${iter} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}" 2;
            __AF_colored1321_v0__255_41="${__AF_colored1321_v0}";
            __AMBER_ARRAY_254=("");
            eprintf__1319_v0 "${items[${iter}]}"" ""${__AF_colored1321_v0__255_41}" __AMBER_ARRAY_254[@];
            __AF_eprintf1319_v0__255_13="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__255_13" > /dev/null 2>&1
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
                eprintf_colored__1320_v0 "${separator}" 90;
                __AF_eprintf_colored1320_v0__281_17="$__AF_eprintf_colored1320_v0";
                echo "$__AF_eprintf_colored1320_v0__281_17" > /dev/null 2>&1
fi
            colored__1321_v0 "${action}" 2;
            __AF_colored1321_v0__283_33="${__AF_colored1321_v0}";
            __AMBER_ARRAY_255=("");
            eprintf__1319_v0 "${key}"" ""${__AF_colored1321_v0__283_33}" __AMBER_ARRAY_255[@];
            __AF_eprintf1319_v0__283_13="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__283_13" > /dev/null 2>&1
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
__45__supports_truecolor="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
__46__got_xylitol_colors=0
__AMBER_ARRAY_256=(3 207 159 92);
__47__primary_color=("${__AMBER_ARRAY_256[@]}")
__AMBER_ARRAY_257=(3 118 206 95);
__48__secondary_color=("${__AMBER_ARRAY_257[@]}")
__AMBER_ARRAY_258=(234 72 121 94);
__49__accent_color=("${__AMBER_ARRAY_258[@]}")
get_supports_truecolor__1370_v0() {
    env_const_get__89_v0 "XYLITOL_TRUECOLOR";
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "" > /dev/null 2>&1
fi;
    __AF_env_const_get89_v0__20_18="${__AF_env_const_get89_v0}";
    local config="${__AF_env_const_get89_v0__20_18}"
    if [ $([ "_${config}" != "_No" ]; echo $?) != 0 ]; then
        __45__supports_truecolor="No"
        __AF_get_supports_truecolor1370_v0=0;
        return 0
fi
    env_const_get__89_v0 "COLORTERM";
    __AS=$?;
if [ $__AS != 0 ]; then
        __45__supports_truecolor="No"
        __AF_get_supports_truecolor1370_v0=0;
        return 0
fi;
    __AF_env_const_get89_v0__25_21="${__AF_env_const_get89_v0}";
    local colorterm="${__AF_env_const_get89_v0__25_21}"
    __45__supports_truecolor=$(if [ $(echo $([ "_${colorterm}" != "_truecolor" ]; echo $?) '||' $([ "_${colorterm}" != "_24bit" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "Yes"; else echo "No"; fi)
    __AF_get_supports_truecolor1370_v0=$([ "_${__45__supports_truecolor}" != "_Yes" ]; echo $?);
    return 0
}
colored_rgb__1371_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ $([ "_${__45__supports_truecolor}" != "_Yes" ]; echo $?) != 0 ]; then
                    __AF_colored_rgb1371_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
            return 0
elif [ $([ "_${__45__supports_truecolor}" != "_None" ]; echo $?) != 0 ]; then
                    get_supports_truecolor__1370_v0 ;
            __AF_get_supports_truecolor1370_v0__50_17="$__AF_get_supports_truecolor1370_v0";
            if [ "$__AF_get_supports_truecolor1370_v0__50_17" != 0 ]; then
                                    __AF_colored_rgb1371_v0="\x1b[38;2;${r};${g};${b}m""${message}""\x1b[0m";
                    return 0
elif [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AF_colored_rgb1371_v0="${message}";
                return 0
else
                __AF_colored_rgb1371_v0="\x1b[${fallback}m""${message}""\x1b[0m";
                return 0
fi
else
        if [ $(echo ${fallback} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_colored_rgb1371_v0="${message}";
            return 0
fi
        __AF_colored_rgb1371_v0="\x1b[${fallback}m""${message}""\x1b[0m";
        return 0
fi
}
inner_get_xylitol_colors__1373_v0() {
    if [ $(echo  '!' ${__46__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__115_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__116_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__117_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__118_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_259=("$__AF_parse_number12_v0__115_21" "$__AF_parse_number12_v0__116_21" "$__AF_parse_number12_v0__117_21" "$__AF_parse_number12_v0__118_21");
                __47__primary_color=("${__AMBER_ARRAY_259[@]}")
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
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__128_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__129_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__130_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__131_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_260=("$__AF_parse_number12_v0__128_21" "$__AF_parse_number12_v0__129_21" "$__AF_parse_number12_v0__130_21" "$__AF_parse_number12_v0__131_21");
                __48__secondary_color=("${__AMBER_ARRAY_260[@]}")
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
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__141_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[1]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__142_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[2]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__143_21="$__AF_parse_number12_v0";
                parse_number__12_v0 "${parts[3]}";
                __AS=$?;
if [ $__AS != 0 ]; then
__AF_inner_get_xylitol_colors1373_v0=''
return $__AS
fi;
                __AF_parse_number12_v0__144_21="$__AF_parse_number12_v0";
                __AMBER_ARRAY_261=("$__AF_parse_number12_v0__141_21" "$__AF_parse_number12_v0__142_21" "$__AF_parse_number12_v0__143_21" "$__AF_parse_number12_v0__144_21");
                __49__accent_color=("${__AMBER_ARRAY_261[@]}")
fi
fi
        __46__got_xylitol_colors=1
fi
}
get_xylitol_colors__1374_v0() {
    inner_get_xylitol_colors__1373_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_colored__105_v0 "WARN: Failed to parse Xylitol colors from envs." 33;
        __AF_echo_colored105_v0__155_9="$__AF_echo_colored105_v0";
        echo "$__AF_echo_colored105_v0__155_9" > /dev/null 2>&1
fi;
    __AF_inner_get_xylitol_colors1373_v0__154_5="$__AF_inner_get_xylitol_colors1373_v0";
    echo "$__AF_inner_get_xylitol_colors1373_v0__154_5" > /dev/null 2>&1
    __46__got_xylitol_colors=1
}
colored_secondary__1376_v0() {
    local message=$1
    if [ $(echo  '!' ${__46__got_xylitol_colors} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_xylitol_colors__1374_v0 ;
        __AF_get_xylitol_colors1374_v0__169_9="$__AF_get_xylitol_colors1374_v0";
        echo "$__AF_get_xylitol_colors1374_v0__169_9" > /dev/null 2>&1
fi
    colored_rgb__1371_v0 "${message}" "${__48__secondary_color[0]}" "${__48__secondary_color[1]}" "${__48__secondary_color[2]}" "${__48__secondary_color[3]}";
    __AF_colored_rgb1371_v0__171_12="${__AF_colored_rgb1371_v0}";
    __AF_colored_secondary1376_v0="${__AF_colored_rgb1371_v0__171_12}";
    return 0
}
# global variables to store terminal size
# (prevent multiple queries in one session)
__50__got_term_size=0
__AMBER_ARRAY_262=(80 24);
__51__term_size=("${__AMBER_ARRAY_262[@]}")
get_term_size__1392_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    __AMBER_VAL_263=$( printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width" );
    __AS=$?;
    local result="${__AMBER_VAL_263}"
    split__3_v0 "${result}" ";";
    __AF_split3_v0__12_17=("${__AF_split3_v0[@]}");
    local parts=("${__AF_split3_v0__12_17[@]}")
    if [ $(echo "${#parts[@]}" '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_get_term_size1392_v0='';
        return 1
fi
    parse_number__12_v0 "${parts[0]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size1392_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__16_16="$__AF_parse_number12_v0";
    local rows="$__AF_parse_number12_v0__16_16"
    parse_number__12_v0 "${parts[1]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_get_term_size1392_v0=''
return $__AS
fi;
    __AF_parse_number12_v0__17_16="$__AF_parse_number12_v0";
    local cols="$__AF_parse_number12_v0__17_16"
    __AMBER_ARRAY_264=(${cols} ${rows});
    __51__term_size=("${__AMBER_ARRAY_264[@]}")
    __50__got_term_size=1
}
term_width__1394_v0() {
    if [ $(echo  '!' ${__50__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__1392_v0 ;
        __AS=$?;
        __AF_get_term_size1392_v0__33_15="$__AF_get_term_size1392_v0";
        echo "$__AF_get_term_size1392_v0__33_15" > /dev/null 2>&1
fi
    __AF_term_width1394_v0="${__51__term_size[0]}";
    return 0
}
term_height__1395_v0() {
    if [ $(echo  '!' ${__50__got_term_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        get_term_size__1392_v0 ;
        __AS=$?;
        __AF_get_term_size1392_v0__41_15="$__AF_get_term_size1392_v0";
        echo "$__AF_get_term_size1392_v0__41_15" > /dev/null 2>&1
fi
    __AF_term_height1395_v0="${__51__term_size[1]}";
    return 0
}
get_page_options__1399_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    local start=$(echo ${page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    local end=$(echo ${start} '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${end} '>' "${#options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        end="${#options[@]}"
fi
    __AMBER_ARRAY_265=();
    local result=("${__AMBER_ARRAY_265[@]}")
    for i in $(seq ${start} $(echo ${end} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        __AMBER_ARRAY_266=("${options[${i}]}");
        result+=("${__AMBER_ARRAY_266[@]}")
done
    __AF_get_page_options1399_v0=("${result[@]}");
    return 0
}
render_choose_page__1401_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __AMBER_LEN="${cursor}";
    local cursor_len="${#__AMBER_LEN}"
    local max_option_width=$(echo $(echo ${term_width} '-' ${cursor_len} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    for i in $(seq 0 $(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
        cutoff_text__1339_v0 "${page_options[${i}]}" ${max_option_width};
        __AF_cutoff_text1339_v0__28_32="${__AF_cutoff_text1339_v0}";
        local truncated_option="${__AF_cutoff_text1339_v0__28_32}"
        if [ $(echo ${i} '==' ${sel} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            colored_secondary__1376_v0 "${cursor}""${truncated_option}""
";
            __AF_colored_secondary1376_v0__30_21="${__AF_colored_secondary1376_v0}";
            __AMBER_ARRAY_267=("");
            eprintf__1319_v0 "${__AF_colored_secondary1376_v0__30_21}" __AMBER_ARRAY_267[@];
            __AF_eprintf1319_v0__30_13="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__30_13" > /dev/null 2>&1
else
            print_blank__1325_v0 ${cursor_len};
            __AF_print_blank1325_v0__32_13="$__AF_print_blank1325_v0";
            echo "$__AF_print_blank1325_v0__32_13" > /dev/null 2>&1
            __AMBER_ARRAY_268=("");
            eprintf__1319_v0 "${truncated_option}""
" __AMBER_ARRAY_268[@];
            __AF_eprintf1319_v0__33_13="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__33_13" > /dev/null 2>&1
fi
done
    local remaining_slots=$(echo ${display_count} '-' "${#page_options[@]}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${remaining_slots} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        # Amber bug gaurd
        for _ in $(seq 0 $(echo ${remaining_slots} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            __AMBER_ARRAY_269=("");
            eprintf__1319_v0 "\x1b[K
" __AMBER_ARRAY_269[@];
            __AF_eprintf1319_v0__39_13="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__39_13" > /dev/null 2>&1
done
fi
}
render_page_indicator__1403_v0() {
    local page=$1
    local total_pages=$2
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_270=("");
        eprintf__1319_v0 "\x1b[9999D\x1b[K" __AMBER_ARRAY_270[@];
        __AF_eprintf1319_v0__74_9="$__AF_eprintf1319_v0";
        echo "$__AF_eprintf1319_v0__74_9" > /dev/null 2>&1
        eprintf_colored__1320_v0 "Page $(echo ${page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored1320_v0__75_9="$__AF_eprintf_colored1320_v0";
        echo "$__AF_eprintf_colored1320_v0__75_9" > /dev/null 2>&1
        __AMBER_ARRAY_271=("");
        eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_271[@];
        __AF_eprintf1319_v0__76_9="$__AF_eprintf1319_v0";
        echo "$__AF_eprintf1319_v0__76_9" > /dev/null 2>&1
fi
}
xyl_choose__1404_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    if [ $(echo "${#options[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__1320_v0 "ERROR: No options provided.
" 31;
        __AF_eprintf_colored1320_v0__94_9="$__AF_eprintf_colored1320_v0";
        echo "$__AF_eprintf_colored1320_v0__94_9" > /dev/null 2>&1
        exit 1
fi
     stty -echo < /dev/tty ;
    __AS=$?
    hide_cursor__1330_v0 ;
    __AF_hide_cursor1330_v0__99_5="$__AF_hide_cursor1330_v0";
    echo "$__AF_hide_cursor1330_v0__99_5" > /dev/null 2>&1
    term_width__1394_v0 ;
    __AF_term_width1394_v0__101_22="$__AF_term_width1394_v0";
    local term_width="$__AF_term_width1394_v0__101_22"
    term_height__1395_v0 ;
    __AF_term_height1395_v0__102_23="$__AF_term_height1395_v0";
    local term_height="$__AF_term_height1395_v0__102_23"
    local max_page_size=$(echo ${term_height} '-' $(if [ $([ "_${header}" != "_" ]; echo $?) != 0 ]; then echo 2; else echo 3; fi) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $(echo ${page_size} '>' ${max_page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        page_size=${max_page_size}
fi
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        cutoff_text__1339_v0 "${header}" ${term_width};
        __AF_cutoff_text1339_v0__109_17="${__AF_cutoff_text1339_v0}";
        __AMBER_ARRAY_272=("");
        eprintf__1319_v0 "${__AF_cutoff_text1339_v0__109_17}""
" __AMBER_ARRAY_272[@];
        __AF_eprintf1319_v0__109_9="$__AF_eprintf1319_v0";
        echo "$__AF_eprintf1319_v0__109_9" > /dev/null 2>&1
fi
    math_floor__309_v0 $(echo $(echo $(echo "${#options[@]}" '+' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '/' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_math_floor309_v0__112_23="$__AF_math_floor309_v0";
    local total_pages="$__AF_math_floor309_v0__112_23"
    local current_page=0
    local selected=0
    local display_count=${page_size}
    if [ $(echo "${#options[@]}" '<' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        display_count="${#options[@]}"
fi
    new_line__1326_v0 ${display_count};
    __AF_new_line1326_v0__121_5="$__AF_new_line1326_v0";
    echo "$__AF_new_line1326_v0__121_5" > /dev/null 2>&1
    __AMBER_ARRAY_273=("");
    eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_273[@];
    __AF_eprintf1319_v0__122_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__122_5" > /dev/null 2>&1
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        eprintf_colored__1320_v0 "Page $(echo ${current_page} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')/${total_pages}" 90;
        __AF_eprintf_colored1320_v0__124_9="$__AF_eprintf_colored1320_v0";
        echo "$__AF_eprintf_colored1320_v0__124_9" > /dev/null 2>&1
fi
    new_line__1326_v0 1;
    __AF_new_line1326_v0__126_5="$__AF_new_line1326_v0";
    echo "$__AF_new_line1326_v0__126_5" > /dev/null 2>&1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ $(echo ${total_pages} '>' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_274=("↑↓" "select" "←→" "page" "enter" "confirm");
        render_tooltip__1340_v0 __AMBER_ARRAY_274[@] 36 ${term_width};
        __AF_render_tooltip1340_v0__131_9="$__AF_render_tooltip1340_v0";
        echo "$__AF_render_tooltip1340_v0__131_9" > /dev/null 2>&1
else
        __AMBER_ARRAY_275=("↑↓" "select" "enter" "confirm");
        render_tooltip__1340_v0 __AMBER_ARRAY_275[@] 25 ${term_width};
        __AF_render_tooltip1340_v0__133_9="$__AF_render_tooltip1340_v0";
        echo "$__AF_render_tooltip1340_v0__133_9" > /dev/null 2>&1
fi
    go_up__1327_v0 $(echo ${display_count} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_go_up1327_v0__135_5="$__AF_go_up1327_v0";
    echo "$__AF_go_up1327_v0__135_5" > /dev/null 2>&1
    __AMBER_ARRAY_276=("");
    eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_276[@];
    __AF_eprintf1319_v0__136_5="$__AF_eprintf1319_v0";
    echo "$__AF_eprintf1319_v0__136_5" > /dev/null 2>&1
    get_page_options__1399_v0 options[@] ${current_page} ${page_size};
    __AF_get_page_options1399_v0__138_24=("${__AF_get_page_options1399_v0[@]}");
    local page_options=("${__AF_get_page_options1399_v0__138_24[@]}")
    render_choose_page__1401_v0 page_options[@] ${selected} "${cursor}" ${display_count} ${term_width};
    __AF_render_choose_page1401_v0__139_5="$__AF_render_choose_page1401_v0";
    echo "$__AF_render_choose_page1401_v0__139_5" > /dev/null 2>&1
    while :
do
        get_key__1317_v0 ;
        __AF_get_key1317_v0__142_19="${__AF_get_key1317_v0}";
        local key="${__AF_get_key1317_v0__142_19}"
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
            get_page_options__1399_v0 options[@] ${current_page} ${page_size};
            __AF_get_page_options1399_v0__205_32=("${__AF_get_page_options1399_v0[@]}");
            page_options=("${__AF_get_page_options1399_v0__205_32[@]}")
            if [ ${up_paged} != 0 ]; then
                selected=$(echo "${#page_options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
            go_up__1327_v0 1;
            __AF_go_up1327_v0__209_17="$__AF_go_up1327_v0";
            echo "$__AF_go_up1327_v0__209_17" > /dev/null 2>&1
            remove_line__1323_v0 $(echo ${display_count} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_remove_line1323_v0__210_17="$__AF_remove_line1323_v0";
            echo "$__AF_remove_line1323_v0__210_17" > /dev/null 2>&1
            remove_current_line__1324_v0 ;
            __AF_remove_current_line1324_v0__211_17="$__AF_remove_current_line1324_v0";
            echo "$__AF_remove_current_line1324_v0__211_17" > /dev/null 2>&1
            __AMBER_ARRAY_277=("");
            eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_277[@];
            __AF_eprintf1319_v0__212_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__212_17" > /dev/null 2>&1
            render_choose_page__1401_v0 page_options[@] ${selected} "${cursor}" ${display_count} ${term_width};
            __AF_render_choose_page1401_v0__213_17="$__AF_render_choose_page1401_v0";
            echo "$__AF_render_choose_page1401_v0__213_17" > /dev/null 2>&1
            render_page_indicator__1403_v0 ${current_page} ${total_pages};
            __AF_render_page_indicator1403_v0__214_17="$__AF_render_page_indicator1403_v0";
            echo "$__AF_render_page_indicator1403_v0__214_17" > /dev/null 2>&1
elif [ $(echo ${prev_selected} '!=' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            go_up__1327_v0 $(echo ${display_count} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_up1327_v0__217_17="$__AF_go_up1327_v0";
            echo "$__AF_go_up1327_v0__217_17" > /dev/null 2>&1
            __AMBER_ARRAY_278=("");
            eprintf__1319_v0 "\x1b[K" __AMBER_ARRAY_278[@];
            __AF_eprintf1319_v0__218_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__218_17" > /dev/null 2>&1
            __AMBER_LEN="${cursor}";
            print_blank__1325_v0 "${#__AMBER_LEN}";
            __AF_print_blank1325_v0__219_17="$__AF_print_blank1325_v0";
            echo "$__AF_print_blank1325_v0__219_17" > /dev/null 2>&1
            cutoff_text__1339_v0 "${page_options[${prev_selected}]}" ${max_option_width};
            __AF_cutoff_text1339_v0__220_25="${__AF_cutoff_text1339_v0}";
            __AMBER_ARRAY_279=("");
            eprintf__1319_v0 "${__AF_cutoff_text1339_v0__220_25}" __AMBER_ARRAY_279[@];
            __AF_eprintf1319_v0__220_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__220_17" > /dev/null 2>&1
            local diff=$(echo ${selected} '-' ${prev_selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
            go_up_or_down__1329_v0 ${diff};
            __AF_go_up_or_down1329_v0__223_17="$__AF_go_up_or_down1329_v0";
            echo "$__AF_go_up_or_down1329_v0__223_17" > /dev/null 2>&1
            __AMBER_ARRAY_280=("");
            eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_280[@];
            __AF_eprintf1319_v0__224_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__224_17" > /dev/null 2>&1
            __AMBER_ARRAY_281=("");
            eprintf__1319_v0 "\x1b[K" __AMBER_ARRAY_281[@];
            __AF_eprintf1319_v0__225_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__225_17" > /dev/null 2>&1
            cutoff_text__1339_v0 "${page_options[${selected}]}" ${max_option_width};
            __AF_cutoff_text1339_v0__226_52="${__AF_cutoff_text1339_v0}";
            colored_secondary__1376_v0 "${cursor}""${__AF_cutoff_text1339_v0__226_52}";
            __AF_colored_secondary1376_v0__226_25="${__AF_colored_secondary1376_v0}";
            __AMBER_ARRAY_282=("");
            eprintf__1319_v0 "${__AF_colored_secondary1376_v0__226_25}" __AMBER_ARRAY_282[@];
            __AF_eprintf1319_v0__226_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__226_17" > /dev/null 2>&1
            go_down__1328_v0 $(echo ${display_count} '-' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
            __AF_go_down1328_v0__228_17="$__AF_go_down1328_v0";
            echo "$__AF_go_down1328_v0__228_17" > /dev/null 2>&1
            __AMBER_ARRAY_283=("");
            eprintf__1319_v0 "\x1b[9999D" __AMBER_ARRAY_283[@];
            __AF_eprintf1319_v0__229_17="$__AF_eprintf1319_v0";
            echo "$__AF_eprintf1319_v0__229_17" > /dev/null 2>&1
fi
done
    local total_lines=$(echo ${display_count} '+' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    if [ $([ "_${header}" == "_" ]; echo $?) != 0 ]; then
        total_lines=$(echo ${total_lines} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    go_down__1328_v0 1;
    __AF_go_down1328_v0__239_5="$__AF_go_down1328_v0";
    echo "$__AF_go_down1328_v0__239_5" > /dev/null 2>&1
    remove_line__1323_v0 $(echo ${total_lines} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    __AF_remove_line1323_v0__240_5="$__AF_remove_line1323_v0";
    echo "$__AF_remove_line1323_v0__240_5" > /dev/null 2>&1
    remove_current_line__1324_v0 ;
    __AF_remove_current_line1324_v0__241_5="$__AF_remove_current_line1324_v0";
    echo "$__AF_remove_current_line1324_v0__241_5" > /dev/null 2>&1
     stty echo < /dev/tty ;
    __AS=$?
    show_cursor__1331_v0 ;
    __AF_show_cursor1331_v0__244_5="$__AF_show_cursor1331_v0";
    echo "$__AF_show_cursor1331_v0__244_5" > /dev/null 2>&1
    local global_selected=$(echo $(echo ${current_page} '*' ${page_size} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' ${selected} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_xyl_choose1404_v0="${options[${global_selected}]}";
    return 0
}
format_entry_display__1408_v0() {
    local entry=("${!1}")
    local name="${entry[0]}"
    local file_type="${entry[1]}"
    if [ $([ "_${file_type}" != "_d" ]; echo $?) != 0 ]; then
        colored_primary__1209_v0 "/";
        __AF_colored_primary1209_v0__16_23="${__AF_colored_primary1209_v0}";
        __AF_format_entry_display1408_v0="${name}""${__AF_colored_primary1209_v0__16_23}";
        return 0
fi
    if [ $([ "_${file_type}" != "_l" ]; echo $?) != 0 ]; then
        colored_accent__1211_v0 " > ";
        __AF_colored_accent1211_v0__19_23="${__AF_colored_accent1211_v0}";
        colored_primary__1209_v0 "${entry[2]}";
        __AF_colored_primary1209_v0__19_47="${__AF_colored_primary1209_v0}";
        __AF_format_entry_display1408_v0="${name}""${__AF_colored_accent1211_v0__19_23}""${__AF_colored_primary1209_v0__19_47}";
        return 0
fi
    __AF_format_entry_display1408_v0="${name}";
    return 0
}
xyl_file__1409_v0() {
    local start_path=$1
    local cursor=$2
    local show_hidden=$3
    local page_size=$4
     stty -echo < /dev/tty ;
    __AS=$?
    term_width__1228_v0 ;
    __AF_term_width1228_v0__39_22="$__AF_term_width1228_v0";
    local term_width="$__AF_term_width1228_v0__39_22"
    __AMBER_LEN="${cursor}";
    local max_entry_width=$(echo $(echo ${term_width} '-' "${#__AMBER_LEN}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    # Initialize current path
    local current_path="${start_path}"
    if [ $([ "_${current_path}" != "_" ]; echo $?) != 0 ]; then
        get_cwd__1238_v0 ;
        __AF_get_cwd1238_v0__45_24="${__AF_get_cwd1238_v0}";
        current_path="${__AF_get_cwd1238_v0__45_24}"
fi
    normalize_path__1239_v0 "${current_path}";
    __AF_normalize_path1239_v0__47_20="${__AF_normalize_path1239_v0}";
    current_path="${__AF_normalize_path1239_v0__47_20}"
    while :
do
        colored_primary__1209_v0 "Loading files...";
        __AF_colored_primary1209_v0__50_17="${__AF_colored_primary1209_v0}";
        __AMBER_ARRAY_284=("");
        eprintf__1153_v0 "${__AF_colored_primary1209_v0__50_17}" __AMBER_ARRAY_284[@];
        __AF_eprintf1153_v0__50_9="$__AF_eprintf1153_v0";
        echo "$__AF_eprintf1153_v0__50_9" > /dev/null 2>&1
        # Get directory entries
        get_directory_entries__1236_v0 "${current_path}";
        __AF_get_directory_entries1236_v0__53_27=("${__AF_get_directory_entries1236_v0[@]}");
        local raw_entries=("${__AF_get_directory_entries1236_v0__53_27[@]}")
        # Build options list and parallel entries list
        __AMBER_ARRAY_285=();
        local options=("${__AMBER_ARRAY_285[@]}")
        __AMBER_ARRAY_286=();
        local entries=("${__AMBER_ARRAY_286[@]}")
        # Add parent directory entry (..)
        if [ $([ "_${current_path}" == "_/" ]; echo $?) != 0 ]; then
            __AMBER_ARRAY_287=("..");
            options+=("${__AMBER_ARRAY_287[@]}")
            __AMBER_ARRAY_288=("..	d");
            entries+=("${__AMBER_ARRAY_288[@]}")
fi
        for raw_entry in "${raw_entries[@]}"; do
            parse_entry__1237_v0 "${raw_entry}";
            __AF_parse_entry1237_v0__66_25=("${__AF_parse_entry1237_v0[@]}");
            local entry=("${__AF_parse_entry1237_v0__66_25[@]}")
            local name="${entry[0]}"
            # Skip hidden files if not showing them
            __AMBER_VAL_289=$( echo "${name}" | cut -c1 );
            __AS=$?;
            local first_char="${__AMBER_VAL_289}"
            if [ $(echo $(echo  '!' ${show_hidden} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $([ "_${first_char}" != "_." ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                continue
fi
            format_entry_display__1408_v0 entry[@];
            __AF_format_entry_display1408_v0__73_25="${__AF_format_entry_display1408_v0}";
            __AMBER_ARRAY_290=("${__AF_format_entry_display1408_v0__73_25}");
            options+=("${__AMBER_ARRAY_290[@]}")
            __AMBER_ARRAY_291=("${raw_entry}");
            entries+=("${__AMBER_ARRAY_291[@]}")
done
        if [ $(echo "${#entries[@]}" '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            eprintf_colored__1154_v0 "ERROR: Directory is empty or inaccessible.
" 31;
            __AF_eprintf_colored1154_v0__78_13="$__AF_eprintf_colored1154_v0";
            echo "$__AF_eprintf_colored1154_v0__78_13" > /dev/null 2>&1
             stty echo < /dev/tty ;
            __AS=$?
            __AF_xyl_file1409_v0="";
            return 0
fi
        # Use xyl_choose with current path as header
        colored_primary__1209_v0 "${current_path}";
        __AF_colored_primary1209_v0__84_22="${__AF_colored_primary1209_v0}";
        local header="${__AF_colored_primary1209_v0__84_22}"
        remove_current_line__1158_v0 ;
        __AF_remove_current_line1158_v0__86_9="$__AF_remove_current_line1158_v0";
        echo "$__AF_remove_current_line1158_v0__86_9" > /dev/null 2>&1
        xyl_choose__1404_v0 options[@] "${cursor}" "${header}" ${page_size};
        __AF_xyl_choose1404_v0__87_31="${__AF_xyl_choose1404_v0}";
        local selected_option="${__AF_xyl_choose1404_v0__87_31}"
         stty -echo < /dev/tty ;
        __AS=$?
        # Find selected entry index
        local selected_idx=$(echo  '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
        for i in $(seq 0 $(echo "${#options[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')); do
            if [ $([ "_${options[${i}]}" != "_${selected_option}" ]; echo $?) != 0 ]; then
                selected_idx=${i}
                break
fi
done
        if [ $(echo ${selected_idx} '<' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_xyl_file1409_v0="";
            return 0
fi
        parse_entry__1237_v0 "${entries[${selected_idx}]}";
        __AF_parse_entry1237_v0__103_21=("${__AF_parse_entry1237_v0[@]}");
        local entry=("${__AF_parse_entry1237_v0__103_21[@]}")
        local name="${entry[0]}"
        local file_type="${entry[1]}"
        if [ $([ "_${name}" != "_.." ]; echo $?) != 0 ]; then
            get_parent_dir__1242_v0 "${current_path}";
            __AF_get_parent_dir1242_v0__109_32="${__AF_get_parent_dir1242_v0}";
            current_path="${__AF_get_parent_dir1242_v0__109_32}"
elif [ $([ "_${file_type}" != "_d" ]; echo $?) != 0 ]; then
            path_join__1241_v0 "${current_path}" "${name}";
            __AF_path_join1241_v0__112_32="${__AF_path_join1241_v0}";
            current_path="${__AF_path_join1241_v0__112_32}"
            normalize_path__1239_v0 "${current_path}";
            __AF_normalize_path1239_v0__113_32="${__AF_normalize_path1239_v0}";
            current_path="${__AF_normalize_path1239_v0__113_32}"
elif [ $([ "_${file_type}" != "_l" ]; echo $?) != 0 ]; then
            # For symlinks, check if they point to a directory
            starts_with__20_v0 "${entry[2]}" "/";
            __AF_starts_with20_v0__117_20="$__AF_starts_with20_v0";
            if [ "$__AF_starts_with20_v0__117_20" != 0 ]; then
                current_path="${entry[2]}"
                normalize_path__1239_v0 "${current_path}";
                __AF_normalize_path1239_v0__119_36="${__AF_normalize_path1239_v0}";
                current_path="${__AF_normalize_path1239_v0__119_36}"
else
                 stty echo < /dev/tty ;
                __AS=$?
                path_join__1241_v0 "${current_path}" "${entry[2]}";
                __AF_path_join1241_v0__122_28="${__AF_path_join1241_v0}";
                __AF_xyl_file1409_v0="${__AF_path_join1241_v0__122_28}";
                return 0
fi
else
                             stty echo < /dev/tty ;
                __AS=$?
                path_join__1241_v0 "${current_path}" "${name}";
                __AF_path_join1241_v0__127_24="${__AF_path_join1241_v0}";
                __AF_xyl_file1409_v0="${__AF_path_join1241_v0__127_24}";
                return 0
fi
done
     stty echo < /dev/tty ;
    __AS=$?
    __AF_xyl_file1409_v0="";
    return 0
}
print_file_help__1473_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    echo ""
    colored_primary__1209_v0 "file";
    __AF_colored_primary1209_v0__7_12="${__AF_colored_primary1209_v0}";
    __AMBER_ARRAY_292=("");
    printf__99_v0 "${__AF_colored_primary1209_v0__7_12}" __AMBER_ARRAY_292[@];
    __AF_printf99_v0__7_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__7_5" > /dev/null 2>&1
    __AMBER_ARRAY_293=("");
    printf__99_v0 " - Browse filesystem and select a file." __AMBER_ARRAY_293[@];
    __AF_printf99_v0__8_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__8_5" > /dev/null 2>&1
    echo ""
    echo ""
    colored_secondary__1210_v0 "Arguments: ";
    __AF_colored_secondary1210_v0__11_12="${__AF_colored_secondary1210_v0}";
    __AMBER_ARRAY_294=("");
    printf__99_v0 "${__AF_colored_secondary1210_v0__11_12}""
" __AMBER_ARRAY_294[@];
    __AF_printf99_v0__11_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__11_5" > /dev/null 2>&1
    echo "  [<path>]               Starting directory path (default: current directory)"
    echo ""
    colored_secondary__1210_v0 "Flags: ";
    __AF_colored_secondary1210_v0__14_12="${__AF_colored_secondary1210_v0}";
    __AMBER_ARRAY_295=("");
    printf__99_v0 "${__AF_colored_secondary1210_v0__14_12}""
" __AMBER_ARRAY_295[@];
    __AF_printf99_v0__14_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__14_5" > /dev/null 2>&1
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    echo ""
}
execute_file__1500_v0() {
    local parameters=("${!1}")
    local cursor="> "
    local start_path=""
    local show_hidden=0
    local page_size=10
    for param in "${parameters[@]:2:9997}"; do
        match_regex__17_v0 "${param}" "^-h\$" 0;
        __AF_match_regex17_v0__14_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--help\$" 0;
        __AF_match_regex17_v0__14_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--cursor=.*\$" 0;
        __AF_match_regex17_v0__18_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--path=.*\$" 0;
        __AF_match_regex17_v0__22_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^-a\$" 0;
        __AF_match_regex17_v0__26_13="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--all\$" 0;
        __AF_match_regex17_v0__26_43="$__AF_match_regex17_v0";
        match_regex__17_v0 "${param}" "^--page-size=.*\$" 0;
        __AF_match_regex17_v0__29_13="$__AF_match_regex17_v0";
        if [ $(echo "$__AF_match_regex17_v0__14_13" '||' "$__AF_match_regex17_v0__14_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            print_file_help__1473_v0 ;
            __AF_print_file_help1473_v0__15_17="$__AF_print_file_help1473_v0";
            echo "$__AF_print_file_help1473_v0__15_17" > /dev/null 2>&1
            exit 0
elif [ "$__AF_match_regex17_v0__18_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__19_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__19_30[@]}")
            cursor="${result[1]}"
elif [ "$__AF_match_regex17_v0__22_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__23_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__23_30[@]}")
            start_path="${result[1]}"
elif [ $(echo "$__AF_match_regex17_v0__26_13" '||' "$__AF_match_regex17_v0__26_43" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            show_hidden=1
elif [ "$__AF_match_regex17_v0__29_13" != 0 ]; then
            split__3_v0 "${param}" "=";
            __AF_split3_v0__30_30=("${__AF_split3_v0[@]}");
            local result=("${__AF_split3_v0__30_30[@]}")
            parse_number__12_v0 "${result[1]}";
            __AS=$?;
if [ $__AS != 0 ]; then
                eprintf_colored__1154_v0 "ERROR: Invalid page-size value: ""${result[1]}""
" 31;
                __AF_eprintf_colored1154_v0__32_21="$__AF_eprintf_colored1154_v0";
                echo "$__AF_eprintf_colored1154_v0__32_21" > /dev/null 2>&1
                exit 1
fi;
            __AF_parse_number12_v0__31_29="$__AF_parse_number12_v0";
            page_size="$__AF_parse_number12_v0__31_29"
else
            # Treat as start path if not a flag
            start_path="${param}"
fi
done
    xyl_file__1409_v0 "${start_path}" "${cursor}" ${show_hidden} ${page_size};
    __AF_xyl_file1409_v0__43_12="${__AF_xyl_file1409_v0}";
    __AF_execute_file1500_v0="${__AF_xyl_file1409_v0__43_12}";
    return 0
}
# #!/usr/bin/env amber
__52_VERSION="0.1.0"
__53_AMBER_VERSION="0.4.0"
check_prerequirements__1502_v0() {
     echo "0" | bc -l > /dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
        eprintf_colored__150_v0 "Error: " 91;
        __AF_eprintf_colored150_v0__16_9="$__AF_eprintf_colored150_v0";
        echo "$__AF_eprintf_colored150_v0__16_9" > /dev/null 2>&1
        __AMBER_ARRAY_296=("");
        eprintf__149_v0 "bc is not installed. Please install bc to use xylitol.
" __AMBER_ARRAY_296[@];
        __AF_eprintf149_v0__17_9="$__AF_eprintf149_v0";
        echo "$__AF_eprintf149_v0__17_9" > /dev/null 2>&1
        __AMBER_ARRAY_297=("");
        eprintf__149_v0 "  For Debian/Ubuntu: sudo apt install bc
" __AMBER_ARRAY_297[@];
        __AF_eprintf149_v0__18_9="$__AF_eprintf149_v0";
        echo "$__AF_eprintf149_v0__18_9" > /dev/null 2>&1
        __AMBER_ARRAY_298=("");
        eprintf__149_v0 "  For Fedora: sudo dnf install bc
" __AMBER_ARRAY_298[@];
        __AF_eprintf149_v0__19_9="$__AF_eprintf149_v0";
        echo "$__AF_eprintf149_v0__19_9" > /dev/null 2>&1
        __AMBER_ARRAY_299=("");
        eprintf__149_v0 "  For Arch Linux: sudo pacman -S bc
" __AMBER_ARRAY_299[@];
        __AF_eprintf149_v0__20_9="$__AF_eprintf149_v0";
        echo "$__AF_eprintf149_v0__20_9" > /dev/null 2>&1
        __AF_check_prerequirements1502_v0=0;
        return 0
fi
    __AF_check_prerequirements1502_v0=1;
    return 0
}
trap_cleanup__1503_v0() {
     trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT ;
    __AS=$?
}
declare -r arguments=("$0" "$@")
    trap_cleanup__1503_v0 ;
    __AF_trap_cleanup1503_v0__32_5="$__AF_trap_cleanup1503_v0";
    echo "$__AF_trap_cleanup1503_v0__32_5" > /dev/null 2>&1
    check_prerequirements__1502_v0 ;
    __AF_check_prerequirements1502_v0__33_12="$__AF_check_prerequirements1502_v0";
    if [ $(echo  '!' "$__AF_check_prerequirements1502_v0__33_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit 1
fi
    get_xylitol_colors__204_v0 ;
    __AF_get_xylitol_colors204_v0__34_5="$__AF_get_xylitol_colors204_v0";
    echo "$__AF_get_xylitol_colors204_v0__34_5" > /dev/null 2>&1
    if [ $(echo $(echo $(echo $(echo "${#arguments[@]}" '<' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_--help" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-h" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    print_help__280_v0 ;
            __AF_print_help280_v0__38_13="$__AF_print_help280_v0";
            echo "$__AF_print_help280_v0__38_13" > /dev/null 2>&1
elif [ $([ "_${arguments[1]}" != "_input" ]; echo $?) != 0 ]; then
                    execute_input__527_v0 arguments[@];
            __AF_execute_input527_v0__41_18="${__AF_execute_input527_v0}";
            echo "${__AF_execute_input527_v0__41_18}"
elif [ $([ "_${arguments[1]}" != "_choose" ]; echo $?) != 0 ]; then
                    execute_choose__787_v0 arguments[@];
            __AF_execute_choose787_v0__44_18="${__AF_execute_choose787_v0}";
            echo "${__AF_execute_choose787_v0__44_18}"
elif [ $([ "_${arguments[1]}" != "_confirm" ]; echo $?) != 0 ]; then
                    execute_confirm__1059_v0 arguments[@];
            __AF_execute_confirm1059_v0__47_26="${__AF_execute_confirm1059_v0}";
            result="${__AF_execute_confirm1059_v0__47_26}"
            if [ $([ "_${result}" != "_yes" ]; echo $?) != 0 ]; then
                exit 0
else
                exit 1
fi
elif [ $([ "_${arguments[1]}" != "_file" ]; echo $?) != 0 ]; then
                    execute_file__1500_v0 arguments[@];
            __AF_execute_file1500_v0__54_18="${__AF_execute_file1500_v0}";
            echo "${__AF_execute_file1500_v0__54_18}"
elif [ $(echo $(echo $([ "_${arguments[1]}" != "_version" ]; echo $?) '||' $([ "_${arguments[1]}" != "_--version" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $([ "_${arguments[1]}" != "_-v" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                    colored_primary__205_v0 "xylitol.sh";
            __AF_colored_primary205_v0__57_20="${__AF_colored_primary205_v0}";
            __AMBER_ARRAY_300=("");
            printf__99_v0 "${__AF_colored_primary205_v0__57_20}" __AMBER_ARRAY_300[@];
            __AF_printf99_v0__57_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__57_13" > /dev/null 2>&1
            __AMBER_ARRAY_301=("");
            printf__99_v0 " version: " __AMBER_ARRAY_301[@];
            __AF_printf99_v0__58_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__58_13" > /dev/null 2>&1
            colored_accent__207_v0 "${__52_VERSION}";
            __AF_colored_accent207_v0__59_20="${__AF_colored_accent207_v0}";
            __AMBER_ARRAY_302=("");
            printf__99_v0 "${__AF_colored_accent207_v0__59_20}" __AMBER_ARRAY_302[@];
            __AF_printf99_v0__59_13="$__AF_printf99_v0";
            echo "$__AF_printf99_v0__59_13" > /dev/null 2>&1
            echo ""
            printf_colored__148_v0 "written in Amber: " 90;
            __AF_printf_colored148_v0__61_13="$__AF_printf_colored148_v0";
            echo "$__AF_printf_colored148_v0__61_13" > /dev/null 2>&1
            printf_colored__148_v0 "  ""${__53_AMBER_VERSION}" 90;
            __AF_printf_colored148_v0__62_13="$__AF_printf_colored148_v0";
            echo "$__AF_printf_colored148_v0__62_13" > /dev/null 2>&1
else
                    print_help__280_v0 ;
            __AF_print_help280_v0__65_13="$__AF_print_help280_v0";
            echo "$__AF_print_help280_v0__65_13" > /dev/null 2>&1
            printf_colored__148_v0 "ERROR: Unknown command '""${arguments[1]}""'" 91;
            __AF_printf_colored148_v0__66_13="$__AF_printf_colored148_v0";
            echo "$__AF_printf_colored148_v0__66_13" > /dev/null 2>&1
fi
