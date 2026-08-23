#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.6.0-alpha
[ "$EUID" -ne 0 ] && { { command -v sudo >/dev/null 2>&1 && __sudo=sudo; } || { command -v doas >/dev/null 2>&1 && __sudo=doas; }; }
if [ -n "$ZSH_VERSION" ]; then
    EXEC_SHELL="zsh"
    IFS='.' read -A EXEC_SHELL_VERSION <<< "$ZSH_VERSION"
elif [ -n "$KSH_VERSION" ]; then
    EXEC_SHELL="ksh"
    __exec_shell_version="${.sh.version##*/}"
    IFS='.' read -a EXEC_SHELL_VERSION <<< "${__exec_shell_version%% *}"
else
    EXEC_SHELL="bash"
    EXEC_SHELL_VERSION=("${BASH_VERSINFO[0]}" "${BASH_VERSINFO[1]}" "${BASH_VERSINFO[2]}")
fi
# split(text: Text, delimiter: Text)
split__4_v0() {
    local text_637="${1}"
    local delimiter_638="${2}"
    local result_639=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_638}" read -rd '' -A result_639 < <(printf %s "$text_637")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_638}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_639+=("$REPLY"); done < <(echo "$text_637")
            __status=$?
        else
            IFS="${delimiter_638}" read -rd '' -a result_639 < <(printf %s "$text_637")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_638}" read -rd '' -a result_639 < <(printf %s "$text_637")
        __status=$?
    fi
    ret_split4_v0=("${result_639[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_7461=("${!1}")
    local delimiter_7462="${2}"
    local command_1
    command_1="$(IFS="${delimiter_7462}" ; printf "%s
" "${list_7461[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_641="${1}"
    [ -n "${text_641}" ] && [ "${text_641}" -eq "${text_641}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_641}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_1659="${1}"
    local prefix_1660="${2}"
    [[ "${text_1659}" == "${prefix_1660}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1661="${1}"
    local index_1662="${2}"
    local length_1663="${3}"
    local result_1664=""
    if [ "$(( length_1663 == 0 ))" != 0 ]; then
        local __length_2="${text_1661}"
        length_1663="$(( ${#__length_2} - index_1662 ))"
    fi
    if [ "$(( length_1663 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1664}"
        return 0
    fi
    result_1664="${text_1661: ${index_1662}: ${length_1663}}"
    __status=$?
    ret_slice24_v0="${result_1664}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_9104="${1}"
    local pad_9105="${2}"
    local length_9106="${3}"
    local __length_3="${text_9104}"
    if [ "$(( length_9106 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_9104}"
        return 0
    fi
    local __length_4="${text_9104}"
    local pad_len_9107="$(( length_9106 - ${#__length_4} ))"
    local padding_9108=""
    printf -v padding_9108 "%${pad_len_9107}s" ""
    __status=$?
    padding_9108="${padding_9108// /${pad_9105}}"
    __status=$?
    ret_lpad27_v0="${padding_9108}""${text_9104}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_9110="${1}"
    local pad_9111="${2}"
    local length_9112="${3}"
    local __length_5="${text_9110}"
    if [ "$(( length_9112 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_9110}"
        return 0
    fi
    local __length_6="${text_9110}"
    local pad_len_9113="$(( length_9112 - ${#__length_6} ))"
    local padding_9114=""
    printf -v padding_9114 "%${pad_len_9113}s" ""
    __status=$?
    padding_9114="${padding_9114// /${pad_9111}}"
    __status=$?
    ret_rpad28_v0="${text_9110}""${padding_9114}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_9098="${1}"
    local pad_9099="${2}"
    local length_9100="${3}"
    local __length_7="${text_9098}"
    local text_length_9101="${#__length_7}"
    if [ "$(( length_9100 <= text_length_9101 ))" != 0 ]; then
        ret_cpad29_v0="${text_9098}"
        return 0
    fi
    local total_padding_9102="$(( length_9100 - text_length_9101 ))"
    local left_padding_length_9103="$(( text_length_9101 + $(( total_padding_9102 / 2 )) ))"
    lpad__27_v0 "${text_9098}" "${pad_9099}" "${left_padding_length_9103}"
    local left_padded_9109="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_9109}" "${pad_9099}" "${length_9100}"
    local center_padded_9115="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_9115}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_13048="${1}"
    [ -d "${path_13048}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# array_find(array: [Text], value: Text)
array_find__67_v0() {
    local array_13034=("${!1}")
    local value_13035="${2}"
    index_13037=0;
    for element_13036 in "${array_13034[@]}"; do
        if [ "$([ "_${value_13035}" != "_${element_13036}" ]; echo $?)" != 0 ]; then
            ret_array_find67_v0="${index_13037}"
            return 0
        fi
        (( index_13037++ )) || true
    done
    ret_array_find67_v0=-1
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_635="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(printf "%s
" "${!name_635}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_10}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        local command_11
        command_11="$(printf "%s
" "${(P)name_635}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_11}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_12
        command_12="$(eval "echo \${$name_635}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_12}"
        return 0
    fi
}

# printf(format: Text, args: [Text])
printf__128_v0() {
    local format_649="${1}"
    local args_650=("${!2}")
    args_650=("${format_649}" "${args_650[@]}")
    __status=$?
    printf "${args_650[@]}"
    __status=$?
}

# printf(format: Text, args: [])
printf__128_v1() {
    local format_658="${1}"
    local args_659=("${!2}")
    args_659=("${format_658}" "${args_659[@]}")
    __status=$?
    printf "${args_659[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_646="${1}"
    local color_647="${2}"
    local color_code_648=0
        color_code_648="${color_647}"
    local array_13=("${message_646}")
    printf__128_v0 "\\x1b[${color_code_648}m%s\\x1b[0m
" array_13[@]
}

# Perl Extensions Utilities
command_14="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_3="$([ "_${command_14}" != "_No" ]; echo $?)"
command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_4="$(( $(( ! _perl_disabled_3 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_7="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_8=0
_primary_color_9=(3 207 159 92)
_secondary_color_10=(3 118 206 94)
_accent_color_11=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__237_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_656="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_656}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor237_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor237_v0=0
        return 0
    fi
    local colorterm_657="${ret_env_var_get120_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_657}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_657}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor237_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__238_v0() {
    local message_651="${1}"
    local r_652="${2}"
    local g_653="${3}"
    local b_654="${4}"
    local fallback_655="${5}"
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb238_v0="\\x1b[38;2;${r_652};${g_653};${b_654}m""${message_651}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__237_v0 
        local ret_get_supports_truecolor237_v0__50_17="${ret_get_supports_truecolor237_v0}"
        if [ "${ret_get_supports_truecolor237_v0__50_17}" != 0 ]; then
            ret_colored_rgb238_v0="\\x1b[38;2;${r_652};${g_653};${b_654}m""${message_651}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_655 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_651}"
            return 0
        else
            ret_colored_rgb238_v0="\\x1b[${fallback_655}m""${message_651}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_655 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_651}"
            return 0
        fi
        ret_colored_rgb238_v0="\\x1b[${fallback_655}m""${message_651}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__240_v0() {
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_636="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_636}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_636}" ";"
            local parts_640=("${ret_split4_v0[@]}")
            local __length_20=("${parts_640[@]}")
            if [ "$(( ${#__length_20[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_640[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_9=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_642="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_642}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_642}" ";"
            local parts_643=("${ret_split4_v0[@]}")
            local __length_22=("${parts_643[@]}")
            if [ "$(( ${#__length_22[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_643[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_10=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_644="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_644}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_644}" ";"
            local parts_645=("${ret_split4_v0[@]}")
            local __length_24=("${parts_645[@]}")
            if [ "$(( ${#__length_24[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_645[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_11=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_8=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__241_v0() {
    inner_get_xylitol_colors__240_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_8=1
}

# colored_primary(message: Text)
colored_primary__242_v0() {
    local message_634="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_634}" "${_primary_color_9[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_9[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_9[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_9[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary242_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__243_v0() {
    local message_660="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_660}" "${_secondary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary243_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__244_v0() {
    local message_663="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_663}" "${_accent_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent244_v0="${ret_colored_rgb238_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__259_v0() {
    local message_13051="${1}"
    local color_13052="${2}"
    # Prints a text with a specified color.
    local array_26=("${message_13051}")
    printf__128_v0 "\\x1b[${color_13052}m%s\\x1b[0m" array_26[@]
}

# eprintf(format: Text, args: [Text])
eprintf__260_v0() {
    local format_80="${1}"
    local args_81=("${!2}")
    args_81=("${format_80}" "${args_81[@]}")
    __status=$?
    printf "${args_81[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__261_v0() {
    local message_78="${1}"
    local color_79="${2}"
    # Prints an error message with a specified color.
    local array_27=("${message_78}")
    eprintf__260_v0 "\\x1b[${color_79}m%s\\x1b[0m" array_27[@]
}

# colored(message: Text, color: Int)
colored__262_v0() {
    local message_661="${1}"
    local color_662="${2}"
    # Returns a text wrapped in color codes.
    ret_colored262_v0="\\x1b[${color_662}m""${message_661}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# print_help()
print_help__423_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    printf '%s\n' ""
    colored_primary__242_v0 "Xylitol"
    local ret_colored_primary242_v0__7_24="${ret_colored_primary242_v0}"
    local array_28=()
    printf__128_v1 "\\x1b[1m""${ret_colored_primary242_v0__7_24}" array_28[@]
    local array_29=()
    printf__128_v1 " - A tool for " array_29[@]
    colored_primary__242_v0 "fresh"
    local ret_colored_primary242_v0__9_12="${ret_colored_primary242_v0}"
    local array_30=()
    printf__128_v1 "${ret_colored_primary242_v0__9_12}" array_30[@]
    local array_31=()
    printf__128_v1 " shell scripts." array_31[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__243_v0 "Flags: "
    local ret_colored_secondary243_v0__13_12="${ret_colored_secondary243_v0}"
    local array_32=()
    printf__128_v1 "${ret_colored_secondary243_v0__13_12}""
" array_32[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    printf '%s\n' ""
    colored_secondary__243_v0 "Commands: "
    local ret_colored_secondary243_v0__17_12="${ret_colored_secondary243_v0}"
    local array_33=()
    printf__128_v1 "${ret_colored_secondary243_v0__17_12}""
" array_33[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    printf '%s\n' ""
    colored_secondary__243_v0 "Envs: "
    local ret_colored_secondary243_v0__23_12="${ret_colored_secondary243_v0}"
    local array_34=()
    printf__128_v1 "${ret_colored_secondary243_v0__23_12}""
" array_34[@]
    colored__262_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored262_v0__24_78="${ret_colored262_v0}"
    local array_35=()
    printf__128_v1 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored262_v0__24_78}""
" array_35[@]
    colored__262_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored262_v0__25_78="${ret_colored262_v0}"
    local array_36=()
    printf__128_v1 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored262_v0__25_78}""
" array_36[@]
    colored__262_v0 "(default: 3;207;159;92)" 90
    local ret_colored262_v0__26_68="${ret_colored262_v0}"
    local array_37=()
    printf__128_v1 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored262_v0__26_68}""
" array_37[@]
    colored__262_v0 "(default: 3;118;206;94)" 90
    local ret_colored262_v0__27_70="${ret_colored262_v0}"
    local array_38=()
    printf__128_v1 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored262_v0__27_70}""
" array_38[@]
    colored__262_v0 "(default: 234;72;121;95)" 90
    local ret_colored262_v0__28_67="${ret_colored262_v0}"
    local array_39=()
    printf__128_v1 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored262_v0__28_67}""
" array_39[@]
    printf '%s\n' ""
    colored_accent__244_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent244_v0__30_21="${ret_colored_accent244_v0}"
    local array_40=()
    printf__128_v1 "Run ""${ret_colored_accent244_v0__30_21}"" for more information on a command.
" array_40[@]
}

# math_floor(number: Int)
math_floor__504_v0() {
    local number_1745="${1}"
    local command_41
    command_41="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_1745}")"
    __status=$?
    ret_math_floor504_v0="${command_41}"
    return 0
}

# math_ceil(number: Int)
math_ceil__505_v0() {
    local number_1744="${1}"
    math_floor__504_v0 "${number_1744}"
    local ret_math_floor504_v0__52_12="${ret_math_floor504_v0}"
    ret_math_ceil505_v0="$(( ret_math_floor504_v0__52_12 + 1 ))"
    return 0
}

# Perl Extensions Utilities
command_42="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_12="$([ "_${command_42}" != "_No" ]; echo $?)"
command_43="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_13="$(( $(( ! _perl_disabled_12 )) && $([ "_${command_43}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__566_v0() {
    local text_1688="${1}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_get_cjk_width566_v0=''
        return 1
    fi
    local command_44
    command_44="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1688}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width566_v0=''
        return "${__status}"
    fi
    local width_str_1689="${command_44}"
    parse_int__13_v0 "${width_str_1689}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width566_v0=''
        return "${__status}"
    fi
    local width_1690="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width566_v0="${width_1690}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__567_v0() {
    local text_1697="${1}"
    local max_width_1698="${2}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_truncate_cjk567_v0=''
        return 1
    fi
    local command_45
    command_45="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_1697}" ${max_width_1698} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk567_v0=''
        return "${__status}"
    fi
    local result_1699="${command_45}"
    ret_perl_truncate_cjk567_v0="${result_1699}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_14=0
_term_size_15=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__574_v0() {
    local command_47
    command_47="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_1673="${command_47}"
    parse_int__13_v0 "${count_1673}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_1674="${ret_parse_int13_v0}"
    if [ "$(( count_num_1674 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_1674="$(( count_num_1674 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_1674}
    __status=$?
}

# stty_unlock()
stty_unlock__575_v0() {
    local command_48
    command_48="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_1741="${command_48}"
    parse_int__13_v0 "${count_1741}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_1742="${ret_parse_int13_v0}"
    if [ "$(( count_num_1742 > 0 ))" != 0 ]; then
        count_num_1742="$(( count_num_1742 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_1742}
        __status=$?
        if [ "$(( count_num_1742 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__576_v0() {
    local size_1676="${1}"
    if [ "$([ "_${size_1676}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size576_v0=0
        return 0
    fi
    split__4_v0 "${size_1676}" " "
    local parts_1677=("${ret_split4_v0[@]}")
    local __length_49=("${parts_1677[@]}")
    if [ "$(( ${#__length_49[@]} != 2 ))" != 0 ]; then
        ret_store_term_size576_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1677[1]?"Index out of bounds (at src/./input/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1677[0]?"Index out of bounds (at src/./input/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_15=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size576_v0=1
    return 0
}

# query_term_size()
query_term_size__577_v0() {
    local command_51
    command_51="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1679="${command_51}"
    store_term_size__576_v0 "${size_1679}"
    ret_query_term_size577_v0="${ret_store_term_size576_v0}"
    return 0
}

# stty_term_size()
stty_term_size__578_v0() {
    local command_52
    command_52="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1675="${command_52}"
    store_term_size__576_v0 "${size_1675}"
    ret_stty_term_size578_v0="${ret_store_term_size576_v0}"
    return 0
}

# get_term_size()
get_term_size__579_v0() {
    stty_term_size__578_v0 
    local detected_1678="${ret_stty_term_size578_v0}"
    if [ "$(( ! detected_1678 ))" != 0 ]; then
        query_term_size__577_v0 
        detected_1678="${ret_query_term_size577_v0}"
    fi
    _got_term_size_14=1
}

# term_width()
term_width__581_v0() {
    if [ "$(( ! _got_term_size_14 ))" != 0 ]; then
        get_term_size__579_v0 
    fi
    ret_term_width581_v0="${_term_size_15[0]?"Index out of bounds (at src/./input/../utils/term.ab:88:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_16="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_17=0
_primary_color_18=(3 207 159 92)
_secondary_color_19=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__592_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_1656="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_1656}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor592_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor592_v0=0
        return 0
    fi
    local colorterm_1657="${ret_env_var_get120_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_1657}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_1657}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor592_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__593_v0() {
    local message_1651="${1}"
    local r_1652="${2}"
    local g_1653="${3}"
    local b_1654="${4}"
    local fallback_1655="${5}"
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb593_v0="\\x1b[38;2;${r_1652};${g_1653};${b_1654}m""${message_1651}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__592_v0 
        local ret_get_supports_truecolor592_v0__50_17="${ret_get_supports_truecolor592_v0}"
        if [ "${ret_get_supports_truecolor592_v0__50_17}" != 0 ]; then
            ret_colored_rgb593_v0="\\x1b[38;2;${r_1652};${g_1653};${b_1654}m""${message_1651}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1655 == 0 ))" != 0 ]; then
            ret_colored_rgb593_v0="${message_1651}"
            return 0
        else
            ret_colored_rgb593_v0="\\x1b[${fallback_1655}m""${message_1651}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1655 == 0 ))" != 0 ]; then
            ret_colored_rgb593_v0="${message_1651}"
            return 0
        fi
        ret_colored_rgb593_v0="\\x1b[${fallback_1655}m""${message_1651}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__595_v0() {
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_1645="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1645}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1645}" ";"
            local parts_1646=("${ret_split4_v0[@]}")
            local __length_56=("${parts_1646[@]}")
            if [ "$(( ${#__length_56[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1646[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1646[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1646[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1646[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_18=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_1647="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1647}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1647}" ";"
            local parts_1648=("${ret_split4_v0[@]}")
            local __length_58=("${parts_1648[@]}")
            if [ "$(( ${#__length_58[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1648[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1648[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1648[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1648[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_19=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_1649="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1649}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1649}" ";"
            local parts_1650=("${ret_split4_v0[@]}")
            local __length_60=("${parts_1650[@]}")
            if [ "$(( ${#__length_60[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1650[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1650[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1650[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1650[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors595_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__596_v0() {
    inner_get_xylitol_colors__595_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

# colored_primary(message: Text)
colored_primary__597_v0() {
    local message_1644="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__596_v0 
    fi
    colored_rgb__593_v0 "${message_1644}" "${_primary_color_18[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_18[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_18[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_18[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary597_v0="${ret_colored_rgb593_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__598_v0() {
    local message_1658="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__596_v0 
    fi
    colored_rgb__593_v0 "${message_1658}" "${_secondary_color_19[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_19[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_19[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_19[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary598_v0="${ret_colored_rgb593_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__612_v0() {
    local command_62
    command_62="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_1737="${command_62}"
    ret_get_char612_v0="${char_1737}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__615_v0() {
    local format_1715="${1}"
    local args_1716=("${!2}")
    args_1716=("${format_1715}" "${args_1716[@]}")
    __status=$?
    printf "${args_1716[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__616_v0() {
    local message_1725="${1}"
    local color_1726="${2}"
    # Prints an error message with a specified color.
    local array_63=("${message_1725}")
    eprintf__615_v0 "\\x1b[${color_1726}m%s\\x1b[0m" array_63[@]
}

# colored(message: Text, color: Int)
colored__617_v0() {
    local message_1727="${1}"
    local color_1728="${2}"
    # Returns a text wrapped in color codes.
    ret_colored617_v0="\\x1b[${color_1728}m""${message_1727}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__618_v0() {
    local cnt_1739="${1}"
    if [ "$(( cnt_1739 > 0 ))" != 0 ]; then
        local array_64=("")
        eprintf__615_v0 "\\x1b[${cnt_1739}D\\x1b[K" array_64[@]
    fi
}

# remove_line(cnt: Int)
remove_line__619_v0() {
    local cnt_1748="${1}"
    if [ "$(( cnt_1748 > 0 ))" != 0 ]; then
        local sequence_1749=""
        local __range_start_1750=0
        local __range_end_1750="${cnt_1748}"
        local __dir_1750=$(( ${__range_start_1750} <= ${__range_end_1750} ? 1 : -1 ))
        for (( ____1750=${__range_start_1750}; ____1750 * ${__dir_1750} < ${__range_end_1750} * ${__dir_1750}; ____1750+=${__dir_1750} )); do
            sequence_1749+="\\x1b[2K\\x1b[1A"
done
        local array_65=("")
        eprintf__615_v0 "${sequence_1749}" array_65[@]
    fi
    local array_66=("")
    eprintf__615_v0 "\\x1b[G" array_66[@]
}

# remove_current_line()
remove_current_line__620_v0() {
    local array_67=("")
    eprintf__615_v0 "\\x1b[2K\\x1b[G" array_67[@]
}

# new_line(cnt: Int)
new_line__622_v0() {
    local cnt_1717="${1}"
    local __range_start_1718=0
    local __range_end_1718="${cnt_1717}"
    local __dir_1718=$(( ${__range_start_1718} <= ${__range_end_1718} ? 1 : -1 ))
    for (( ____1718=${__range_start_1718}; ____1718 * ${__dir_1718} < ${__range_end_1718} * ${__dir_1718}; ____1718+=${__dir_1718} )); do
        local array_68=("")
        eprintf__615_v0 "
" array_68[@]
done
}

# go_up(cnt: Int)
go_up__623_v0() {
    local cnt_1736="${1}"
    local array_69=("")
    eprintf__615_v0 "\\x1b[${cnt_1736}A" array_69[@]
}

# go_down(cnt: Int)
go_down__624_v0() {
    local cnt_1747="${1}"
    local array_70=("")
    eprintf__615_v0 "\\x1b[${cnt_1747}B" array_70[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__628_v0() {
    local text_1665="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_71
    command_71="$([[ "${text_1665}" == *$'\x1b'* || "${text_1665}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1666="${command_71}"
    ret_has_ansi_escape628_v0="$([ "_${has_escape_1666}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__629_v0() {
    local text_1667="${1}"
    local command_72
    command_72="$(printf '%s' "${text_1667}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi629_v0="${command_72}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__630_v0() {
    local text_1684="${1}"
    local command_73
    command_73="$(printf "%s" "${text_1684}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi630_v0="${command_73}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__631_v0() {
    local text_1686="${1}"
    local command_74
    command_74="$(printf "%s" "${text_1686}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1687="${command_74}"
    ret_is_all_ascii631_v0="$([ "_${result_1687}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__632_v0() {
    local text_1683="${1}"
    strip_ansi__630_v0 "${text_1683}"
    local stripped_1685="${ret_strip_ansi630_v0}"
    # Check if text is all ASCII
    is_all_ascii__631_v0 "${stripped_1685}"
    local ret_is_all_ascii631_v0__150_12="${ret_is_all_ascii631_v0}"
    if [ "$(( ! ret_is_all_ascii631_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__566_v0 "${stripped_1685}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_75="${stripped_1685}"
            ret_get_visible_len632_v0="${#__length_75}"
            return 0
        fi
        ret_get_visible_len632_v0="${ret_perl_get_cjk_width566_v0}"
        return 0
    else
        local __length_76="${stripped_1685}"
        ret_get_visible_len632_v0="${#__length_76}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__633_v0() {
    local text_1694="${1}"
    local max_width_1695="${2}"
    get_visible_len__632_v0 "${text_1694}"
    local visible_len_1696="${ret_get_visible_len632_v0}"
    if [ "$(( visible_len_1696 <= max_width_1695 ))" != 0 ]; then
        ret_truncate_text633_v0="${text_1694}"
        return 0
    fi
    is_all_ascii__631_v0 "${text_1694}"
    local ret_is_all_ascii631_v0__167_12="${ret_is_all_ascii631_v0}"
    if [ "$(( ! ret_is_all_ascii631_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__567_v0 "${text_1694}" "${max_width_1695}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_1694}" | cut -c1-${max_width_1695}
            __status=$?
        fi
        ret_truncate_text633_v0="${ret_perl_truncate_cjk567_v0}"
        return 0
    fi
    local command_77
    command_77="$(printf "%s" "${text_1694}" | cut -c1-${max_width_1695})"
    __status=$?
    ret_truncate_text633_v0="${command_77}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__634_v0() {
    local text_1692="${1}"
    local max_width_1693="${2}"
    has_ansi_escape__628_v0 "${text_1692}"
    local ret_has_ansi_escape628_v0__179_12="${ret_has_ansi_escape628_v0}"
    if [ "$(( ! ret_has_ansi_escape628_v0__179_12 ))" != 0 ]; then
        truncate_text__633_v0 "${text_1692}" "${max_width_1693}"
        ret_truncate_ansi634_v0="${ret_truncate_text633_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_78
    command_78="$([[ "${text_1692}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_1700="${command_78}"
    # Replace \x1b[ with newline, then split
    local command_79
    command_79="$(t="${text_1692}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_1701="${command_79}"
    split__4_v0 "${replaced_1701}" "
"
    local parts_1702=("${ret_split4_v0[@]}")
    local result_1703=""
    local remaining_width_1704="${max_width_1693}"
    local __range_start_1705=0
    local __length_80=("${parts_1702[@]}")
    local __range_end_1705="${#__length_80[@]}"
    local __dir_1705=$(( ${__range_start_1705} <= ${__range_end_1705} ? 1 : -1 ))
    for (( idx_1705=${__range_start_1705}; idx_1705 * ${__dir_1705} < ${__range_end_1705} * ${__dir_1705}; idx_1705+=${__dir_1705} )); do
        local part_1706="${parts_1702[${idx_1705}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_1705 == 0 )) && $([ "_${starts_with_ansi_1700}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_1706}" == "_" ]; echo $?) && $(( remaining_width_1704 > 0 )) ))" != 0 ]; then
                truncate_text__633_v0 "${part_1706}" "${remaining_width_1704}"
                local ret_truncate_text633_v0__201_35="${ret_truncate_text633_v0}"
                local truncated_1707="${ret_truncate_text633_v0__201_35}"
                result_1703+="${truncated_1707}"
                get_visible_len__632_v0 "${truncated_1707}"
                local ret_get_visible_len632_v0__203_36="${ret_get_visible_len632_v0}"
                remaining_width_1704="$(( remaining_width_1704 - ret_get_visible_len632_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_81
            command_81="$(__p="${part_1706}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_1708="${command_81}"
            if [ "$([ "_${m_idx_1708}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_82
                command_82="$(__p="${part_1706}"; printf "%s" "${__p:0:${m_idx_1708}}")"
                __status=$?
                local ansi_params_1709="${command_82}"
                result_1703+="\\x1b[""${ansi_params_1709}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_1708}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_1710="${ret_parse_int13_v0__214_41}"
                local text_start_1711="$(( m_idx_num_1710 + 1 ))"
                local command_83
                command_83="$(__p="${part_1706}"; printf "%s" "${__p:${text_start_1711}}")"
                __status=$?
                local text_part_1712="${command_83}"
                if [ "$(( $([ "_${text_part_1712}" == "_" ]; echo $?) && $(( remaining_width_1704 > 0 )) ))" != 0 ]; then
                    truncate_text__633_v0 "${text_part_1712}" "${remaining_width_1704}"
                    local ret_truncate_text633_v0__218_39="${ret_truncate_text633_v0}"
                    local truncated_1713="${ret_truncate_text633_v0__218_39}"
                    result_1703+="${truncated_1713}"
                    get_visible_len__632_v0 "${truncated_1713}"
                    local ret_get_visible_len632_v0__220_40="${ret_get_visible_len632_v0}"
                    remaining_width_1704="$(( remaining_width_1704 - ret_get_visible_len632_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_1706}" == "_" ]; echo $?) && $(( remaining_width_1704 > 0 )) ))" != 0 ]; then
                    truncate_text__633_v0 "${part_1706}" "${remaining_width_1704}"
                    local ret_truncate_text633_v0__225_39="${ret_truncate_text633_v0}"
                    local truncated_1714="${ret_truncate_text633_v0__225_39}"
                    result_1703+="${truncated_1714}"
                    get_visible_len__632_v0 "${truncated_1714}"
                    local ret_get_visible_len632_v0__227_40="${ret_get_visible_len632_v0}"
                    remaining_width_1704="$(( remaining_width_1704 - ret_get_visible_len632_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi634_v0="${result_1703}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__635_v0() {
    local text_1681="${1}"
    local max_width_1682="${2}"
    get_visible_len__632_v0 "${text_1681}"
    local visible_len_1691="${ret_get_visible_len632_v0}"
    if [ "$(( visible_len_1691 <= max_width_1682 ))" != 0 ]; then
        ret_cutoff_text635_v0="${text_1681}"
        return 0
    fi
    truncate_ansi__634_v0 "${text_1681}" "$(( max_width_1682 - 3 ))"
    local ret_truncate_ansi634_v0__243_12="${ret_truncate_ansi634_v0}"
    ret_cutoff_text635_v0="${ret_truncate_ansi634_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__636_v0() {
    local items_1719=("${!1}")
    local total_len_1720="${2}"
    local term_width_1721="${3}"
    local separator_1722=" • "
    local separator_len_1723=3
    # Fast path: no truncation needed
    if [ "$(( total_len_1720 <= term_width_1721 ))" != 0 ]; then
        local iter_1724=0
        while :
        do
            local __length_84=("${items_1719[@]}")
            if [ "$(( iter_1724 >= ${#__length_84[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_1724 > 0 ))" != 0 ]; then
                eprintf_colored__616_v0 "${separator_1722}" 90
            fi
            colored__617_v0 "${items_1719[$(( iter_1724 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored617_v0__268_41="${ret_colored617_v0}"
            local array_85=("")
            eprintf__615_v0 "${items_1719[${iter_1724}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored617_v0__268_41}" array_85[@]
            iter_1724="$(( iter_1724 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_1729=0
        local first_1730=1
        local iter_1731=0
        while :
        do
            local __length_86=("${items_1719[@]}")
            if [ "$(( iter_1731 >= ${#__length_86[@]} ))" != 0 ]; then
                break
            fi
            local key_1732="${items_1719[${iter_1731}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_1733="${items_1719[$(( iter_1731 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_87="${key_1732}"
            local __length_88="${action_1733}"
            local part_len_1734="$(( $(( ${#__length_87} + 1 )) + ${#__length_88} ))"
            local needed_1735="${part_len_1734}"
            if [ "$(( ! first_1730 ))" != 0 ]; then
                needed_1735="$(( needed_1735 + separator_len_1723 ))"
            fi
            if [ "$(( $(( current_len_1729 + needed_1735 )) > term_width_1721 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_1730 ))" != 0 ]; then
                eprintf_colored__616_v0 "${separator_1722}" 90
            fi
            colored__617_v0 "${action_1733}" 2
            local ret_colored617_v0__296_33="${ret_colored617_v0}"
            local array_89=("")
            eprintf__615_v0 "${key_1732}"" ""${ret_colored617_v0__296_33}" array_89[@]
            current_len_1729="$(( current_len_1729 + needed_1735 ))"
            first_1730=0
            iter_1731="$(( iter_1731 + 2 ))"
        done
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__686_v0() {
    local prompt_1669="${1}"
    local placeholder_1670="${2}"
    local header_1671="${3}"
    local password_1672="${4}"
    stty_lock__574_v0 
    term_width__581_v0 
    local term_width_1680="${ret_term_width581_v0}"
    if [ "$([ "_${header_1671}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__635_v0 "${header_1671}" "${term_width_1680}"
        local ret_cutoff_text635_v0__23_17="${ret_cutoff_text635_v0}"
        local array_90=("")
        eprintf__615_v0 "${ret_cutoff_text635_v0__23_17}""
" array_90[@]
    fi
    new_line__622_v0 2
    # "enter submit" = 12
    local array_91=("enter" "submit")
    render_tooltip__636_v0 array_91[@] 12 "${term_width_1680}"
    go_up__623_v0 2
    local array_92=("")
    eprintf__615_v0 "\\x1b[G" array_92[@]
    local array_93=("")
    eprintf__615_v0 "${prompt_1669}" array_93[@]
    eprintf_colored__616_v0 "${placeholder_1670}" 90
    get_char__612_v0 
    local char_1738="${ret_get_char612_v0}"
    local __length_94="${prompt_1669}"
    remove__618_v0 "${#__length_94}"
    local __length_95="${placeholder_1670}"
    remove__618_v0 "$(( ${#__length_95} + 1 ))"
    local text_1740=""
    if [ "$(( ! password_1672 ))" != 0 ]; then
        stty_unlock__575_v0 
        local command_96
        command_96="$(read -e -i ${char_1738} -p "${prompt_1669}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1740="${command_96}"
    else
        stty_unlock__575_v0 
        local command_97
        command_97="$(read -es -i ${char_1738} -p "${prompt_1669}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1740="${command_97}"
    fi
    stty_lock__574_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__632_v0 "${prompt_1669}""${text_1740}"
    local input_display_len_1743="${ret_get_visible_len632_v0}"
    math_ceil__505_v0 "$(( input_display_len_1743 / term_width_1680 ))"
    local input_lines_1746="${ret_math_ceil505_v0}"
    if [ "$(( input_lines_1746 < 3 ))" != 0 ]; then
        go_down__624_v0 "$(( 2 - input_lines_1746 ))"
        remove_line__619_v0 2
        remove_current_line__620_v0 
    fi
    if [ "$(( input_lines_1746 >= 3 ))" != 0 ]; then
        remove_line__619_v0 "${input_lines_1746}"
    fi
    if [ "$([ "_${header_1671}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__619_v0 1
        remove_current_line__620_v0 
    fi
    stty_unlock__575_v0 
    ret_xyl_input686_v0="${text_1740}"
    return 0
}

# print_input_help()
print_input_help__779_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    printf '%s\n' ""
    colored_primary__597_v0 "input"
    local ret_colored_primary597_v0__7_12="${ret_colored_primary597_v0}"
    local array_98=()
    printf__128_v1 "${ret_colored_primary597_v0__7_12}" array_98[@]
    local array_99=()
    printf__128_v1 " - Prompt for some input from the user." array_99[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__598_v0 "Flags: "
    local ret_colored_secondary598_v0__11_12="${ret_colored_secondary598_v0}"
    local array_100=()
    printf__128_v1 "${ret_colored_secondary598_v0__11_12}""
" array_100[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__830_v0() {
    local parameters_1638=("${!1}")
    local prompt_1639="> "
    local placeholder_1640="Type here..."
    local header_1641=""
    local password_1642=0
    for param_1643 in "${parameters_1638[@]}"; do
        if [ "$(( $([ "_${param_1643}" != "_-h" ]; echo $?) || $([ "_${param_1643}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__779_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_1643}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_103="--prompt="
            slice__24_v0 "${param_1643}" "${#__length_103}" 0
            prompt_1639="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_1643}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_104="--placeholder="
            slice__24_v0 "${param_1643}" "${#__length_104}" 0
            placeholder_1640="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_1643}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_105="--header="
            slice__24_v0 "${param_1643}" "${#__length_105}" 0
            header_1641="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_1643}" != "_--password" ]; echo $?)" != 0 ]; then
            password_1642=1
        fi
    done
    has_ansi_escape__628_v0 "${header_1641}"
    local ret_has_ansi_escape628_v0__31_44="${ret_has_ansi_escape628_v0}"
    escape_ansi__629_v0 "${header_1641}"
    local ret_escape_ansi629_v0__31_73="${ret_escape_ansi629_v0}"
    colored_primary__597_v0 "${header_1641}"
    local ret_colored_primary597_v0__31_111="${ret_colored_primary597_v0}"
    local display_header_1668
    display_header_1668="$(if [ "$(( $([ "_${header_1641}" != "_" ]; echo $?) || ret_has_ansi_escape628_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi629_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary597_v0__31_111}"; fi)"
    xyl_input__686_v0 "${prompt_1639}" "${placeholder_1640}" "${display_header_1668}" "${password_1642}"
    ret_execute_input830_v0="${ret_xyl_input686_v0}"
    return 0
}

# Perl Extensions Utilities
command_106="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_106}" != "_No" ]; echo $?)"
command_107="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! _perl_disabled_21 )) && $([ "_${command_107}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__968_v0() {
    local text_7351="${1}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_get_cjk_width968_v0=''
        return 1
    fi
    local command_108
    command_108="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_7351}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width968_v0=''
        return "${__status}"
    fi
    local width_str_7352="${command_108}"
    parse_int__13_v0 "${width_str_7352}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width968_v0=''
        return "${__status}"
    fi
    local width_7353="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width968_v0="${width_7353}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__969_v0() {
    local text_7360="${1}"
    local max_width_7361="${2}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_truncate_cjk969_v0=''
        return 1
    fi
    local command_109
    command_109="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_7360}" ${max_width_7361} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk969_v0=''
        return "${__status}"
    fi
    local result_7362="${command_109}"
    ret_perl_truncate_cjk969_v0="${result_7362}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_23=0
_term_size_24=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__976_v0() {
    local command_111
    command_111="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_7334="${command_111}"
    parse_int__13_v0 "${count_7334}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_7335="${ret_parse_int13_v0}"
    if [ "$(( count_num_7335 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_7335="$(( count_num_7335 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_7335}
    __status=$?
}

# stty_unlock()
stty_unlock__977_v0() {
    local command_112
    command_112="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_7458="${command_112}"
    parse_int__13_v0 "${count_7458}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_7459="${ret_parse_int13_v0}"
    if [ "$(( count_num_7459 > 0 ))" != 0 ]; then
        count_num_7459="$(( count_num_7459 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_7459}
        __status=$?
        if [ "$(( count_num_7459 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__978_v0() {
    local size_7337="${1}"
    if [ "$([ "_${size_7337}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size978_v0=0
        return 0
    fi
    split__4_v0 "${size_7337}" " "
    local parts_7338=("${ret_split4_v0[@]}")
    local __length_113=("${parts_7338[@]}")
    if [ "$(( ${#__length_113[@]} != 2 ))" != 0 ]; then
        ret_store_term_size978_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_7338[1]?"Index out of bounds (at src/./choose/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_7338[0]?"Index out of bounds (at src/./choose/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_24=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size978_v0=1
    return 0
}

# query_term_size()
query_term_size__979_v0() {
    local command_115
    command_115="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_7340="${command_115}"
    store_term_size__978_v0 "${size_7340}"
    ret_query_term_size979_v0="${ret_store_term_size978_v0}"
    return 0
}

# stty_term_size()
stty_term_size__980_v0() {
    local command_116
    command_116="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_7336="${command_116}"
    store_term_size__978_v0 "${size_7336}"
    ret_stty_term_size980_v0="${ret_store_term_size978_v0}"
    return 0
}

# get_term_size()
get_term_size__981_v0() {
    stty_term_size__980_v0 
    local detected_7339="${ret_stty_term_size980_v0}"
    if [ "$(( ! detected_7339 ))" != 0 ]; then
        query_term_size__979_v0 
        detected_7339="${ret_query_term_size979_v0}"
    fi
    _got_term_size_23=1
}

# term_width()
term_width__983_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__981_v0 
    fi
    ret_term_width983_v0="${_term_size_24[0]?"Index out of bounds (at src/./choose/../utils/term.ab:88:23)"}"
    return 0
}

# term_height()
term_height__984_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__981_v0 
    fi
    ret_term_height984_v0="${_term_size_24[1]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_25="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_26=0
_primary_color_27=(3 207 159 92)
_secondary_color_28=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__994_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_7308="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_7308}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor994_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor994_v0=0
        return 0
    fi
    local colorterm_7309="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_7309}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_7309}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor994_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__995_v0() {
    local message_7303="${1}"
    local r_7304="${2}"
    local g_7305="${3}"
    local b_7306="${4}"
    local fallback_7307="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb995_v0="\\x1b[38;2;${r_7304};${g_7305};${b_7306}m""${message_7303}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__994_v0 
        local ret_get_supports_truecolor994_v0__50_17="${ret_get_supports_truecolor994_v0}"
        if [ "${ret_get_supports_truecolor994_v0__50_17}" != 0 ]; then
            ret_colored_rgb995_v0="\\x1b[38;2;${r_7304};${g_7305};${b_7306}m""${message_7303}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_7307 == 0 ))" != 0 ]; then
            ret_colored_rgb995_v0="${message_7303}"
            return 0
        else
            ret_colored_rgb995_v0="\\x1b[${fallback_7307}m""${message_7303}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_7307 == 0 ))" != 0 ]; then
            ret_colored_rgb995_v0="${message_7303}"
            return 0
        fi
        ret_colored_rgb995_v0="\\x1b[${fallback_7307}m""${message_7303}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__997_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_7297="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_7297}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_7297}" ";"
            local parts_7298=("${ret_split4_v0[@]}")
            local __length_120=("${parts_7298[@]}")
            if [ "$(( ${#__length_120[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7298[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7298[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7298[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7298[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_27=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_7299="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_7299}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_7299}" ";"
            local parts_7300=("${ret_split4_v0[@]}")
            local __length_122=("${parts_7300[@]}")
            if [ "$(( ${#__length_122[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7300[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7300[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7300[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7300[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_28=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_7301="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_7301}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_7301}" ";"
            local parts_7302=("${ret_split4_v0[@]}")
            local __length_124=("${parts_7302[@]}")
            if [ "$(( ${#__length_124[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7302[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7302[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7302[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7302[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors997_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__998_v0() {
    inner_get_xylitol_colors__997_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__999_v0() {
    local message_7296="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__998_v0 
    fi
    colored_rgb__995_v0 "${message_7296}" "${_primary_color_27[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary999_v0="${ret_colored_rgb995_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1000_v0() {
    local message_7318="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__998_v0 
    fi
    colored_rgb__995_v0 "${message_7318}" "${_secondary_color_28[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1000_v0="${ret_colored_rgb995_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1015_v0() {
    local command_126
    command_126="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_7430="${command_126}"
    if [ "$([ "_${var_7430}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1015_v0="UP"
        return 0
    elif [ "$([ "_${var_7430}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1015_v0="DOWN"
        return 0
    elif [ "$([ "_${var_7430}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1015_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_7430}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1015_v0="LEFT"
        return 0
    elif [ "$([ "_${var_7430}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1015_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_7430}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1015_v0="INPUT"
        return 0
    else
        ret_get_key1015_v0="${var_7430}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1017_v0() {
    local format_7322="${1}"
    local args_7323=("${!2}")
    args_7323=("${format_7322}" "${args_7323[@]}")
    __status=$?
    printf "${args_7323[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1018_v0() {
    local message_7320="${1}"
    local color_7321="${2}"
    # Prints an error message with a specified color.
    local array_127=("${message_7320}")
    eprintf__1017_v0 "\\x1b[${color_7321}m%s\\x1b[0m" array_127[@]
}

# colored(message: Text, color: Int)
colored__1019_v0() {
    local message_7390="${1}"
    local color_7391="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1019_v0="\\x1b[${color_7391}m""${message_7390}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1021_v0() {
    local cnt_7445="${1}"
    if [ "$(( cnt_7445 > 0 ))" != 0 ]; then
        local sequence_7446=""
        local __range_start_7447=0
        local __range_end_7447="${cnt_7445}"
        local __dir_7447=$(( ${__range_start_7447} <= ${__range_end_7447} ? 1 : -1 ))
        for (( ____7447=${__range_start_7447}; ____7447 * ${__dir_7447} < ${__range_end_7447} * ${__dir_7447}; ____7447+=${__dir_7447} )); do
            sequence_7446+="\\x1b[2K\\x1b[1A"
done
        local array_128=("")
        eprintf__1017_v0 "${sequence_7446}" array_128[@]
    fi
    local array_129=("")
    eprintf__1017_v0 "\\x1b[G" array_129[@]
}

# remove_current_line()
remove_current_line__1022_v0() {
    local array_130=("")
    eprintf__1017_v0 "\\x1b[2K\\x1b[G" array_130[@]
}

# print_blank(cnt: Int)
print_blank__1023_v0() {
    local cnt_7427="${1}"
    printf '%*s' "${cnt_7427}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1024_v0() {
    local cnt_7382="${1}"
    local __range_start_7383=0
    local __range_end_7383="${cnt_7382}"
    local __dir_7383=$(( ${__range_start_7383} <= ${__range_end_7383} ? 1 : -1 ))
    for (( ____7383=${__range_start_7383}; ____7383 * ${__dir_7383} < ${__range_end_7383} * ${__dir_7383}; ____7383+=${__dir_7383} )); do
        local array_131=("")
        eprintf__1017_v0 "
" array_131[@]
done
}

# go_up(cnt: Int)
go_up__1025_v0() {
    local cnt_7399="${1}"
    local array_132=("")
    eprintf__1017_v0 "\\x1b[${cnt_7399}A" array_132[@]
}

# go_down(cnt: Int)
go_down__1026_v0() {
    local cnt_7441="${1}"
    local array_133=("")
    eprintf__1017_v0 "\\x1b[${cnt_7441}B" array_133[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1027_v0() {
    local cnt_7452="${1}"
    if [ "$(( cnt_7452 > 0 ))" != 0 ]; then
        go_down__1026_v0 "${cnt_7452}"
    else
        go_up__1025_v0 "$(( - cnt_7452 ))"
    fi
}

# hide_cursor()
hide_cursor__1028_v0() {
    local array_134=("")
    eprintf__1017_v0 "\\x1b[?25l" array_134[@]
}

# show_cursor()
show_cursor__1029_v0() {
    local array_135=("")
    eprintf__1017_v0 "\\x1b[?25h" array_135[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1030_v0() {
    local text_7325="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_136
    command_136="$([[ "${text_7325}" == *$'\x1b'* || "${text_7325}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_7326="${command_136}"
    ret_has_ansi_escape1030_v0="$([ "_${has_escape_7326}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1031_v0() {
    local text_7327="${1}"
    local command_137
    command_137="$(printf '%s' "${text_7327}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1031_v0="${command_137}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1032_v0() {
    local text_7347="${1}"
    local command_138
    command_138="$(printf "%s" "${text_7347}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1032_v0="${command_138}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1033_v0() {
    local text_7349="${1}"
    local command_139
    command_139="$(printf "%s" "${text_7349}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_7350="${command_139}"
    ret_is_all_ascii1033_v0="$([ "_${result_7350}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1034_v0() {
    local text_7346="${1}"
    strip_ansi__1032_v0 "${text_7346}"
    local stripped_7348="${ret_strip_ansi1032_v0}"
    # Check if text is all ASCII
    is_all_ascii__1033_v0 "${stripped_7348}"
    local ret_is_all_ascii1033_v0__150_12="${ret_is_all_ascii1033_v0}"
    if [ "$(( ! ret_is_all_ascii1033_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__968_v0 "${stripped_7348}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_140="${stripped_7348}"
            ret_get_visible_len1034_v0="${#__length_140}"
            return 0
        fi
        ret_get_visible_len1034_v0="${ret_perl_get_cjk_width968_v0}"
        return 0
    else
        local __length_141="${stripped_7348}"
        ret_get_visible_len1034_v0="${#__length_141}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1035_v0() {
    local text_7357="${1}"
    local max_width_7358="${2}"
    get_visible_len__1034_v0 "${text_7357}"
    local visible_len_7359="${ret_get_visible_len1034_v0}"
    if [ "$(( visible_len_7359 <= max_width_7358 ))" != 0 ]; then
        ret_truncate_text1035_v0="${text_7357}"
        return 0
    fi
    is_all_ascii__1033_v0 "${text_7357}"
    local ret_is_all_ascii1033_v0__167_12="${ret_is_all_ascii1033_v0}"
    if [ "$(( ! ret_is_all_ascii1033_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__969_v0 "${text_7357}" "${max_width_7358}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_7357}" | cut -c1-${max_width_7358}
            __status=$?
        fi
        ret_truncate_text1035_v0="${ret_perl_truncate_cjk969_v0}"
        return 0
    fi
    local command_142
    command_142="$(printf "%s" "${text_7357}" | cut -c1-${max_width_7358})"
    __status=$?
    ret_truncate_text1035_v0="${command_142}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1036_v0() {
    local text_7355="${1}"
    local max_width_7356="${2}"
    has_ansi_escape__1030_v0 "${text_7355}"
    local ret_has_ansi_escape1030_v0__179_12="${ret_has_ansi_escape1030_v0}"
    if [ "$(( ! ret_has_ansi_escape1030_v0__179_12 ))" != 0 ]; then
        truncate_text__1035_v0 "${text_7355}" "${max_width_7356}"
        ret_truncate_ansi1036_v0="${ret_truncate_text1035_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_143
    command_143="$([[ "${text_7355}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_7363="${command_143}"
    # Replace \x1b[ with newline, then split
    local command_144
    command_144="$(t="${text_7355}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_7364="${command_144}"
    split__4_v0 "${replaced_7364}" "
"
    local parts_7365=("${ret_split4_v0[@]}")
    local result_7366=""
    local remaining_width_7367="${max_width_7356}"
    local __range_start_7368=0
    local __length_145=("${parts_7365[@]}")
    local __range_end_7368="${#__length_145[@]}"
    local __dir_7368=$(( ${__range_start_7368} <= ${__range_end_7368} ? 1 : -1 ))
    for (( idx_7368=${__range_start_7368}; idx_7368 * ${__dir_7368} < ${__range_end_7368} * ${__dir_7368}; idx_7368+=${__dir_7368} )); do
        local part_7369="${parts_7365[${idx_7368}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_7368 == 0 )) && $([ "_${starts_with_ansi_7363}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_7369}" == "_" ]; echo $?) && $(( remaining_width_7367 > 0 )) ))" != 0 ]; then
                truncate_text__1035_v0 "${part_7369}" "${remaining_width_7367}"
                local ret_truncate_text1035_v0__201_35="${ret_truncate_text1035_v0}"
                local truncated_7370="${ret_truncate_text1035_v0__201_35}"
                result_7366+="${truncated_7370}"
                get_visible_len__1034_v0 "${truncated_7370}"
                local ret_get_visible_len1034_v0__203_36="${ret_get_visible_len1034_v0}"
                remaining_width_7367="$(( remaining_width_7367 - ret_get_visible_len1034_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_146
            command_146="$(__p="${part_7369}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_7371="${command_146}"
            if [ "$([ "_${m_idx_7371}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_147
                command_147="$(__p="${part_7369}"; printf "%s" "${__p:0:${m_idx_7371}}")"
                __status=$?
                local ansi_params_7372="${command_147}"
                result_7366+="\\x1b[""${ansi_params_7372}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_7371}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_7373="${ret_parse_int13_v0__214_41}"
                local text_start_7374="$(( m_idx_num_7373 + 1 ))"
                local command_148
                command_148="$(__p="${part_7369}"; printf "%s" "${__p:${text_start_7374}}")"
                __status=$?
                local text_part_7375="${command_148}"
                if [ "$(( $([ "_${text_part_7375}" == "_" ]; echo $?) && $(( remaining_width_7367 > 0 )) ))" != 0 ]; then
                    truncate_text__1035_v0 "${text_part_7375}" "${remaining_width_7367}"
                    local ret_truncate_text1035_v0__218_39="${ret_truncate_text1035_v0}"
                    local truncated_7376="${ret_truncate_text1035_v0__218_39}"
                    result_7366+="${truncated_7376}"
                    get_visible_len__1034_v0 "${truncated_7376}"
                    local ret_get_visible_len1034_v0__220_40="${ret_get_visible_len1034_v0}"
                    remaining_width_7367="$(( remaining_width_7367 - ret_get_visible_len1034_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_7369}" == "_" ]; echo $?) && $(( remaining_width_7367 > 0 )) ))" != 0 ]; then
                    truncate_text__1035_v0 "${part_7369}" "${remaining_width_7367}"
                    local ret_truncate_text1035_v0__225_39="${ret_truncate_text1035_v0}"
                    local truncated_7377="${ret_truncate_text1035_v0__225_39}"
                    result_7366+="${truncated_7377}"
                    get_visible_len__1034_v0 "${truncated_7377}"
                    local ret_get_visible_len1034_v0__227_40="${ret_get_visible_len1034_v0}"
                    remaining_width_7367="$(( remaining_width_7367 - ret_get_visible_len1034_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1036_v0="${result_7366}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1037_v0() {
    local text_7344="${1}"
    local max_width_7345="${2}"
    get_visible_len__1034_v0 "${text_7344}"
    local visible_len_7354="${ret_get_visible_len1034_v0}"
    if [ "$(( visible_len_7354 <= max_width_7345 ))" != 0 ]; then
        ret_cutoff_text1037_v0="${text_7344}"
        return 0
    fi
    truncate_ansi__1036_v0 "${text_7344}" "$(( max_width_7345 - 3 ))"
    local ret_truncate_ansi1036_v0__243_12="${ret_truncate_ansi1036_v0}"
    ret_cutoff_text1037_v0="${ret_truncate_ansi1036_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1038_v0() {
    local items_7384=("${!1}")
    local total_len_7385="${2}"
    local term_width_7386="${3}"
    local separator_7387=" • "
    local separator_len_7388=3
    # Fast path: no truncation needed
    if [ "$(( total_len_7385 <= term_width_7386 ))" != 0 ]; then
        local iter_7389=0
        while :
        do
            local __length_149=("${items_7384[@]}")
            if [ "$(( iter_7389 >= ${#__length_149[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_7389 > 0 ))" != 0 ]; then
                eprintf_colored__1018_v0 "${separator_7387}" 90
            fi
            colored__1019_v0 "${items_7384[$(( iter_7389 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1019_v0__268_41="${ret_colored1019_v0}"
            local array_150=("")
            eprintf__1017_v0 "${items_7384[${iter_7389}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1019_v0__268_41}" array_150[@]
            iter_7389="$(( iter_7389 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_7392=0
        local first_7393=1
        local iter_7394=0
        while :
        do
            local __length_151=("${items_7384[@]}")
            if [ "$(( iter_7394 >= ${#__length_151[@]} ))" != 0 ]; then
                break
            fi
            local key_7395="${items_7384[${iter_7394}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_7396="${items_7384[$(( iter_7394 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_152="${key_7395}"
            local __length_153="${action_7396}"
            local part_len_7397="$(( $(( ${#__length_152} + 1 )) + ${#__length_153} ))"
            local needed_7398="${part_len_7397}"
            if [ "$(( ! first_7393 ))" != 0 ]; then
                needed_7398="$(( needed_7398 + separator_len_7388 ))"
            fi
            if [ "$(( $(( current_len_7392 + needed_7398 )) > term_width_7386 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_7393 ))" != 0 ]; then
                eprintf_colored__1018_v0 "${separator_7387}" 90
            fi
            colored__1019_v0 "${action_7396}" 2
            local ret_colored1019_v0__296_33="${ret_colored1019_v0}"
            local array_154=("")
            eprintf__1017_v0 "${key_7395}"" ""${ret_colored1019_v0__296_33}" array_154[@]
            current_len_7392="$(( current_len_7392 + needed_7398 ))"
            first_7393=0
            iter_7394="$(( iter_7394 + 2 ))"
        done
    fi
}

# get_page_options(options: [Text], page: Int, page_size: Int)
get_page_options__1088_v0() {
    local options_7402=("${!1}")
    local page_7403="${2}"
    local page_size_7404="${3}"
    local start_7405="$(( page_7403 * page_size_7404 ))"
    local end_7406="$(( start_7405 + page_size_7404 ))"
    local __length_155=("${options_7402[@]}")
    if [ "$(( end_7406 > ${#__length_155[@]} ))" != 0 ]; then
        local __length_156=("${options_7402[@]}")
        end_7406="${#__length_156[@]}"
    fi
    local result_7407=()
    local __range_start_7408="${start_7405}"
    local __range_end_7408="${end_7406}"
    local __dir_7408=$(( ${__range_start_7408} <= ${__range_end_7408} ? 1 : -1 ))
    for (( i_7408=${__range_start_7408}; i_7408 * ${__dir_7408} < ${__range_end_7408} * ${__dir_7408}; i_7408+=${__dir_7408} )); do
        local array_158=("${options_7402[${i_7408}]?"Index out of bounds (at src/./choose/./mod.ab:13:28)"}")
        result_7407+=("${array_158[@]}")
done
    ret_get_page_options1088_v0=("${result_7407[@]}")
    return 0
}

# get_page_start(page: Int, page_size: Int)
get_page_start__1089_v0() {
    local page_7410="${1}"
    local page_size_7411="${2}"
    ret_get_page_start1089_v0="$(( page_7410 * page_size_7411 ))"
    return 0
}

# render_choose_page(page_options: [Text], sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_choose_page__1090_v0() {
    local page_options_7475=("${!1}")
    local sel_7476="${2}"
    local cursor_7477="${3}"
    local display_count_7478="${4}"
    local term_width_7479="${5}"
    local __length_159="${cursor_7477}"
    local cursor_len_7480="${#__length_159}"
    local max_option_width_7481="$(( $(( term_width_7479 - cursor_len_7480 )) - 1 ))"
    local __range_start_7482=0
    local __length_160=("${page_options_7475[@]}")
    local __range_end_7482="${#__length_160[@]}"
    local __dir_7482=$(( ${__range_start_7482} <= ${__range_end_7482} ? 1 : -1 ))
    for (( i_7482=${__range_start_7482}; i_7482 * ${__dir_7482} < ${__range_end_7482} * ${__dir_7482}; i_7482+=${__dir_7482} )); do
        cutoff_text__1037_v0 "${page_options_7475[${i_7482}]?"Index out of bounds (at src/./choose/./mod.ab:26:59)"}" "${max_option_width_7481}"
        local ret_cutoff_text1037_v0__26_34="${ret_cutoff_text1037_v0}"
        local truncated_option_7483="${ret_cutoff_text1037_v0__26_34}"
        if [ "$(( i_7482 == sel_7476 ))" != 0 ]; then
            colored_secondary__1000_v0 "${cursor_7477}""${truncated_option_7483}""
"
            local ret_colored_secondary1000_v0__28_21="${ret_colored_secondary1000_v0}"
            local array_161=("")
            eprintf__1017_v0 "${ret_colored_secondary1000_v0__28_21}" array_161[@]
        else
            print_blank__1023_v0 "${cursor_len_7480}"
            local array_162=("")
            eprintf__1017_v0 "${truncated_option_7483}""
" array_162[@]
        fi
done
    local __length_163=("${page_options_7475[@]}")
    local remaining_slots_7484="$(( display_count_7478 - ${#__length_163[@]} ))"
    if [ "$(( remaining_slots_7484 > 0 ))" != 0 ]; then
        # Amber bug gaurd
        local __range_start_7485=0
        local __range_end_7485="${remaining_slots_7484}"
        local __dir_7485=$(( ${__range_start_7485} <= ${__range_end_7485} ? 1 : -1 ))
        for (( ____7485=${__range_start_7485}; ____7485 * ${__dir_7485} < ${__range_end_7485} * ${__dir_7485}; ____7485+=${__dir_7485} )); do
            local array_164=("")
            eprintf__1017_v0 "\\x1b[K
" array_164[@]
done
    fi
}

# render_multi_choose_page(page_options: [Text], checked: [Bool], page_start: Int, sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_multi_choose_page__1091_v0() {
    local page_options_7413=("${!1}")
    local checked_7414=("${!2}")
    local page_start_7415="${3}"
    local sel_7416="${4}"
    local cursor_7417="${5}"
    local display_count_7418="${6}"
    local term_width_7419="${7}"
    local __length_165="${cursor_7417}"
    local cursor_len_7420="${#__length_165}"
    local check_mark_len_7421=2
    # "✓ " or "• "
    local max_option_width_7422="$(( $(( $(( term_width_7419 - cursor_len_7420 )) - check_mark_len_7421 )) - 1 ))"
    local __range_start_7423=0
    local __length_166=("${page_options_7413[@]}")
    local __range_end_7423="${#__length_166[@]}"
    local __dir_7423=$(( ${__range_start_7423} <= ${__range_end_7423} ? 1 : -1 ))
    for (( i_7423=${__range_start_7423}; i_7423 * ${__dir_7423} < ${__range_end_7423} * ${__dir_7423}; i_7423+=${__dir_7423} )); do
        local global_idx_7424="$(( page_start_7415 + i_7423 ))"
        local check_mark_7425
        check_mark_7425="$(if [ "${checked_7414[${global_idx_7424}]?"Index out of bounds (at src/./choose/./mod.ab:48:36)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1037_v0 "${page_options_7413[${i_7423}]?"Index out of bounds (at src/./choose/./mod.ab:49:59)"}" "${max_option_width_7422}"
        local ret_cutoff_text1037_v0__49_34="${ret_cutoff_text1037_v0}"
        local truncated_option_7426="${ret_cutoff_text1037_v0__49_34}"
        if [ "$(( i_7423 == sel_7416 ))" != 0 ]; then
            colored_secondary__1000_v0 "${cursor_7417}""${check_mark_7425}""${truncated_option_7426}""
"
            local ret_colored_secondary1000_v0__51_31="${ret_colored_secondary1000_v0}"
            local array_167=("")
            eprintf__1017_v0 "${ret_colored_secondary1000_v0__51_31}" array_167[@]
        elif [ "${checked_7414[${global_idx_7424}]?"Index out of bounds (at src/./choose/./mod.ab:52:21)"}" != 0 ]; then
            print_blank__1023_v0 "${cursor_len_7420}"
            colored_secondary__1000_v0 "${check_mark_7425}""${truncated_option_7426}""
"
            local ret_colored_secondary1000_v0__54_25="${ret_colored_secondary1000_v0}"
            local array_168=("")
            eprintf__1017_v0 "${ret_colored_secondary1000_v0__54_25}" array_168[@]
        else
            print_blank__1023_v0 "${cursor_len_7420}"
            local array_169=("")
            eprintf__1017_v0 "${check_mark_7425}""${truncated_option_7426}""
" array_169[@]
        fi
done
    local __length_170=("${page_options_7413[@]}")
    local remaining_slots_7428="$(( display_count_7418 - ${#__length_170[@]} ))"
    if [ "$(( remaining_slots_7428 > 0 ))" != 0 ]; then
        # Amber bug guard
        local __range_start_7429=0
        local __range_end_7429="${remaining_slots_7428}"
        local __dir_7429=$(( ${__range_start_7429} <= ${__range_end_7429} ? 1 : -1 ))
        for (( ____7429=${__range_start_7429}; ____7429 * ${__dir_7429} < ${__range_end_7429} * ${__dir_7429}; ____7429+=${__dir_7429} )); do
            local array_171=("")
            eprintf__1017_v0 "\\x1b[K
" array_171[@]
done
    fi
}

# render_page_indicator(page: Int, total_pages: Int)
render_page_indicator__1092_v0() {
    local page_7448="${1}"
    local total_pages_7449="${2}"
    if [ "$(( total_pages_7449 > 1 ))" != 0 ]; then
        local array_172=("")
        eprintf__1017_v0 "\\x1b[G\\x1b[K" array_172[@]
        eprintf_colored__1018_v0 "Page $(( page_7448 + 1 ))/${total_pages_7449}" 90
        local array_173=("")
        eprintf__1017_v0 "\\x1b[G" array_173[@]
    fi
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1093_v0() {
    local options_7463=("${!1}")
    local cursor_7464="${2}"
    local header_7465="${3}"
    local page_size_7466="${4}"
    local __length_174=("${options_7463[@]}")
    if [ "$(( ${#__length_174[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1018_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__976_v0 
    hide_cursor__1028_v0 
    term_width__983_v0 
    local term_width_7467="${ret_term_width983_v0}"
    term_height__984_v0 
    local term_height_7468="${ret_term_height984_v0}"
    local max_page_size_7469
    max_page_size_7469="$(( term_height_7468 - $(if [ "$([ "_${header_7465}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_7466 > max_page_size_7469 ))" != 0 ]; then
        page_size_7466="${max_page_size_7469}"
    fi
    if [ "$([ "_${header_7465}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1037_v0 "${header_7465}" "${term_width_7467}"
        local ret_cutoff_text1037_v0__107_17="${ret_cutoff_text1037_v0}"
        local array_175=("")
        eprintf__1017_v0 "${ret_cutoff_text1037_v0__107_17}""
" array_175[@]
    fi
    local __length_176=("${options_7463[@]}")
    math_floor__504_v0 "$(( $(( $(( ${#__length_176[@]} + page_size_7466 )) - 1 )) / page_size_7466 ))"
    local total_pages_7470="${ret_math_floor504_v0}"
    local current_page_7471=0
    local selected_7472=0
    local display_count_7473="${page_size_7466}"
    local __length_177=("${options_7463[@]}")
    if [ "$(( ${#__length_177[@]} < page_size_7466 ))" != 0 ]; then
        local __length_178=("${options_7463[@]}")
        display_count_7473="${#__length_178[@]}"
    fi
    new_line__1024_v0 "${display_count_7473}"
    local array_179=("")
    eprintf__1017_v0 "\\x1b[G" array_179[@]
    if [ "$(( total_pages_7470 > 1 ))" != 0 ]; then
        eprintf_colored__1018_v0 "Page $(( current_page_7471 + 1 ))/${total_pages_7470}" 90
    fi
    new_line__1024_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( total_pages_7470 > 1 ))" != 0 ]; then
        local array_180=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1038_v0 array_180[@] 36 "${term_width_7467}"
    else
        local array_181=("↑↓" "select" "enter" "confirm")
        render_tooltip__1038_v0 array_181[@] 25 "${term_width_7467}"
    fi
    go_up__1025_v0 "$(( display_count_7473 + 1 ))"
    local array_182=("")
    eprintf__1017_v0 "\\x1b[G" array_182[@]
    get_page_options__1088_v0 options_7463[@] "${current_page_7471}" "${page_size_7466}"
    local page_options_7474=("${ret_get_page_options1088_v0[@]}")
    render_choose_page__1090_v0 page_options_7474[@] "${selected_7472}" "${cursor_7464}" "${display_count_7473}" "${term_width_7467}"
    while :
    do
        get_key__1015_v0 
        local key_7486="${ret_get_key1015_v0}"
        local prev_selected_7487="${selected_7472}"
        local prev_page_7488="${current_page_7471}"
        local up_paged_7489=0
        if [ "$(( $([ "_${key_7486}" != "_UP" ]; echo $?) || $([ "_${key_7486}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_7472 == 0 )) && $(( total_pages_7470 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7471 > 0 ))" != 0 ]; then
                    current_page_7471="$(( current_page_7471 - 1 ))"
                else
                    current_page_7471="$(( total_pages_7470 - 1 ))"
                fi
                up_paged_7489=1
            elif [ "$(( selected_7472 == 0 ))" != 0 ]; then
                local __length_183=("${page_options_7474[@]}")
                selected_7472="$(( ${#__length_183[@]} - 1 ))"
            else
                selected_7472="$(( selected_7472 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_7486}" != "_DOWN" ]; echo $?) || $([ "_${key_7486}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_184=("${page_options_7474[@]}")
            if [ "$(( selected_7472 == $(( ${#__length_184[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7471 < $(( total_pages_7470 - 1 )) ))" != 0 ]; then
                    current_page_7471="$(( current_page_7471 + 1 ))"
                    selected_7472=0
                else
                    current_page_7471=0
                    selected_7472=0
                fi
            else
                selected_7472="$(( selected_7472 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_7486}" != "_LEFT" ]; echo $?) || $([ "_${key_7486}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7471 > 0 ))" != 0 ]; then
                current_page_7471="$(( current_page_7471 - 1 ))"
                selected_7472=0
            else
                selected_7472=0
            fi
        elif [ "$(( $([ "_${key_7486}" != "_RIGHT" ]; echo $?) || $([ "_${key_7486}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7471 < $(( total_pages_7470 - 1 )) ))" != 0 ]; then
                current_page_7471="$(( current_page_7471 + 1 ))"
                selected_7472=0
            else
                local __length_185=("${page_options_7474[@]}")
                selected_7472="$(( ${#__length_185[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_7486}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_186="${cursor_7464}"
        local max_option_width_7490="$(( $(( term_width_7467 - ${#__length_186} )) - 1 ))"
        if [ "$(( prev_page_7488 != current_page_7471 ))" != 0 ]; then
            get_page_options__1088_v0 options_7463[@] "${current_page_7471}" "${page_size_7466}"
            page_options_7474=("${ret_get_page_options1088_v0[@]}")
            if [ "${up_paged_7489}" != 0 ]; then
                local __length_187=("${page_options_7474[@]}")
                selected_7472="$(( ${#__length_187[@]} - 1 ))"
            fi
            go_up__1025_v0 1
            remove_line__1021_v0 "$(( display_count_7473 - 1 ))"
            remove_current_line__1022_v0 
            local array_188=("")
            eprintf__1017_v0 "\\x1b[G" array_188[@]
            render_choose_page__1090_v0 page_options_7474[@] "${selected_7472}" "${cursor_7464}" "${display_count_7473}" "${term_width_7467}"
            render_page_indicator__1092_v0 "${current_page_7471}" "${total_pages_7470}"
        elif [ "$(( prev_selected_7487 != selected_7472 ))" != 0 ]; then
            go_up__1025_v0 "$(( display_count_7473 - prev_selected_7487 ))"
            local array_189=("")
            eprintf__1017_v0 "\\x1b[K" array_189[@]
            local __length_190="${cursor_7464}"
            print_blank__1023_v0 "${#__length_190}"
            cutoff_text__1037_v0 "${page_options_7474[${prev_selected_7487}]?"Index out of bounds (at src/./choose/./mod.ab:218:50)"}" "${max_option_width_7490}"
            local ret_cutoff_text1037_v0__218_25="${ret_cutoff_text1037_v0}"
            local array_191=("")
            eprintf__1017_v0 "${ret_cutoff_text1037_v0__218_25}" array_191[@]
            local diff_7491="$(( selected_7472 - prev_selected_7487 ))"
            go_up_or_down__1027_v0 "${diff_7491}"
            local array_192=("")
            eprintf__1017_v0 "\\x1b[G" array_192[@]
            local array_193=("")
            eprintf__1017_v0 "\\x1b[K" array_193[@]
            cutoff_text__1037_v0 "${page_options_7474[${selected_7472}]?"Index out of bounds (at src/./choose/./mod.ab:224:77)"}" "${max_option_width_7490}"
            local ret_cutoff_text1037_v0__224_52="${ret_cutoff_text1037_v0}"
            colored_secondary__1000_v0 "${cursor_7464}""${ret_cutoff_text1037_v0__224_52}"
            local ret_colored_secondary1000_v0__224_25="${ret_colored_secondary1000_v0}"
            local array_194=("")
            eprintf__1017_v0 "${ret_colored_secondary1000_v0__224_25}" array_194[@]
            go_down__1026_v0 "$(( display_count_7473 - selected_7472 ))"
            local array_195=("")
            eprintf__1017_v0 "\\x1b[G" array_195[@]
        fi
    done
    local total_lines_7492="$(( display_count_7473 + 2 ))"
    if [ "$([ "_${header_7465}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_7492="$(( total_lines_7492 + 1 ))"
    fi
    go_down__1026_v0 1
    remove_line__1021_v0 "$(( total_lines_7492 - 1 ))"
    remove_current_line__1022_v0 
    stty_unlock__977_v0 
    show_cursor__1029_v0 
    local global_selected_7493="$(( $(( current_page_7471 * page_size_7466 )) + selected_7472 ))"
    ret_xyl_choose1093_v0="${options_7463[${global_selected_7493}]?"Index out of bounds (at src/./choose/./mod.ab:244:20)"}"
    return 0
}

# count_checked(checked: [Bool])
count_checked__1094_v0() {
    local checked_7436=("${!1}")
    local count_7437=0
    for c_7438 in "${checked_7436[@]}"; do
        if [ "${c_7438}" != 0 ]; then
            count_7437="$(( count_7437 + 1 ))"
        fi
    done
    ret_count_checked1094_v0="${count_7437}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1095_v0() {
    local options_7329=("${!1}")
    local cursor_7330="${2}"
    local header_7331="${3}"
    local limit_7332="${4}"
    local page_size_7333="${5}"
    local __length_198=("${options_7329[@]}")
    if [ "$(( ${#__length_198[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1018_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1095_v0=()
        return 0
    fi
    stty_lock__976_v0 
    hide_cursor__1028_v0 
    term_width__983_v0 
    local term_width_7341="${ret_term_width983_v0}"
    term_height__984_v0 
    local term_height_7342="${ret_term_height984_v0}"
    local max_page_size_7343
    max_page_size_7343="$(( term_height_7342 - $(if [ "$([ "_${header_7331}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_7333 > max_page_size_7343 ))" != 0 ]; then
        page_size_7333="${max_page_size_7343}"
    fi
    if [ "$([ "_${header_7331}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1037_v0 "${header_7331}" "${term_width_7341}"
        local ret_cutoff_text1037_v0__288_17="${ret_cutoff_text1037_v0}"
        local array_200=("")
        eprintf__1017_v0 "${ret_cutoff_text1037_v0__288_17}""
" array_200[@]
    fi
    local __length_201=("${options_7329[@]}")
    math_floor__504_v0 "$(( $(( $(( ${#__length_201[@]} + page_size_7333 )) - 1 )) / page_size_7333 ))"
    local total_pages_7378="${ret_math_floor504_v0}"
    local current_page_7379=0
    local selected_7380=0
    local display_count_7381="${page_size_7333}"
    local __length_202=("${options_7329[@]}")
    if [ "$(( ${#__length_202[@]} < page_size_7333 ))" != 0 ]; then
        local __length_203=("${options_7329[@]}")
        display_count_7381="${#__length_203[@]}"
    fi
    new_line__1024_v0 "${display_count_7381}"
    local array_204=("")
    eprintf__1017_v0 "\\x1b[G" array_204[@]
    if [ "$(( total_pages_7378 > 1 ))" != 0 ]; then
        eprintf_colored__1018_v0 "Page $(( current_page_7379 + 1 ))/${total_pages_7378}" 90
    fi
    new_line__1024_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( total_pages_7378 > 1 )) && $(( limit_7332 < 0 )) ))" != 0 ]; then
        local array_205=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__1038_v0 array_205[@] 55 "${term_width_7341}"
    elif [ "$(( total_pages_7378 > 1 ))" != 0 ]; then
        local array_206=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__1038_v0 array_206[@] 47 "${term_width_7341}"
    elif [ "$(( limit_7332 < 0 ))" != 0 ]; then
        local array_207=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__1038_v0 array_207[@] 44 "${term_width_7341}"
    else
        local array_208=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__1038_v0 array_208[@] 36 "${term_width_7341}"
    fi
    go_up__1025_v0 "$(( display_count_7381 + 1 ))"
    local array_209=("")
    eprintf__1017_v0 "\\x1b[G" array_209[@]
    local checked_7400=()
    local __range_start_7401=0
    local __length_211=("${options_7329[@]}")
    local __range_end_7401="${#__length_211[@]}"
    local __dir_7401=$(( ${__range_start_7401} <= ${__range_end_7401} ? 1 : -1 ))
    for (( ____7401=${__range_start_7401}; ____7401 * ${__dir_7401} < ${__range_end_7401} * ${__dir_7401}; ____7401+=${__dir_7401} )); do
        local array_212=(0)
        checked_7400+=("${array_212[@]}")
done
    get_page_options__1088_v0 options_7329[@] "${current_page_7379}" "${page_size_7333}"
    local page_options_7409=("${ret_get_page_options1088_v0[@]}")
    get_page_start__1089_v0 "${current_page_7379}" "${page_size_7333}"
    local page_start_7412="${ret_get_page_start1089_v0}"
    render_multi_choose_page__1091_v0 page_options_7409[@] checked_7400[@] "${page_start_7412}" "${selected_7380}" "${cursor_7330}" "${display_count_7381}" "${term_width_7341}"
    while :
    do
        get_key__1015_v0 
        local key_7431="${ret_get_key1015_v0}"
        local prev_selected_7432="${selected_7380}"
        local prev_page_7433="${current_page_7379}"
        local global_selected_7434="$(( page_start_7412 + selected_7380 ))"
        local up_paged_7435=0
        if [ "$(( $([ "_${key_7431}" != "_UP" ]; echo $?) || $([ "_${key_7431}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_7380 == 0 )) && $(( total_pages_7378 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7379 > 0 ))" != 0 ]; then
                    current_page_7379="$(( current_page_7379 - 1 ))"
                else
                    current_page_7379="$(( total_pages_7378 - 1 ))"
                fi
                up_paged_7435=1
            elif [ "$(( selected_7380 == 0 ))" != 0 ]; then
                local __length_213=("${page_options_7409[@]}")
                selected_7380="$(( ${#__length_213[@]} - 1 ))"
            else
                selected_7380="$(( selected_7380 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_7431}" != "_DOWN" ]; echo $?) || $([ "_${key_7431}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_214=("${page_options_7409[@]}")
            if [ "$(( selected_7380 == $(( ${#__length_214[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7379 < $(( total_pages_7378 - 1 )) ))" != 0 ]; then
                    current_page_7379="$(( current_page_7379 + 1 ))"
                    selected_7380=0
                else
                    current_page_7379=0
                    selected_7380=0
                fi
            else
                selected_7380="$(( selected_7380 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_7431}" != "_LEFT" ]; echo $?) || $([ "_${key_7431}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7379 > 0 ))" != 0 ]; then
                current_page_7379="$(( current_page_7379 - 1 ))"
                selected_7380=0
            else
                selected_7380=0
            fi
        elif [ "$(( $([ "_${key_7431}" != "_RIGHT" ]; echo $?) || $([ "_${key_7431}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7379 < $(( total_pages_7378 - 1 )) ))" != 0 ]; then
                current_page_7379="$(( current_page_7379 + 1 ))"
                selected_7380=0
            else
                local __length_215=("${page_options_7409[@]}")
                selected_7380="$(( ${#__length_215[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_7431}" != "_x" ]; echo $?) || $([ "_${key_7431}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__1094_v0 checked_7400[@]
            local ret_count_checked1094_v0__390_34="${ret_count_checked1094_v0}"
            if [ "${checked_7400[${global_selected_7434}]?"Index out of bounds (at src/./choose/./mod.ab:387:29)"}" != 0 ]; then
                checked_7400["${global_selected_7434}"]=0
            elif [ "$(( $(( limit_7332 < 0 )) || $(( ret_count_checked1094_v0__390_34 < limit_7332 )) ))" != 0 ]; then
                checked_7400["${global_selected_7434}"]=1
            else
                continue
            fi
            local __length_216="${cursor_7330}"
            local max_option_width_7439="$(( $(( $(( term_width_7341 - ${#__length_216} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__1025_v0 "$(( display_count_7381 - selected_7380 ))"
            local array_217=("")
            eprintf__1017_v0 "\\x1b[G" array_217[@]
            local array_218=("")
            eprintf__1017_v0 "\\x1b[K" array_218[@]
            local check_mark_7440
            check_mark_7440="$(if [ "${checked_7400[${global_selected_7434}]?"Index out of bounds (at src/./choose/./mod.ab:399:44)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__1037_v0 "${page_options_7409[${selected_7380}]?"Index out of bounds (at src/./choose/./mod.ab:400:90)"}" "${max_option_width_7439}"
            local ret_cutoff_text1037_v0__400_65="${ret_cutoff_text1037_v0}"
            colored_secondary__1000_v0 "${cursor_7330}""${check_mark_7440}""${ret_cutoff_text1037_v0__400_65}"
            local ret_colored_secondary1000_v0__400_25="${ret_colored_secondary1000_v0}"
            local array_219=("")
            eprintf__1017_v0 "${ret_colored_secondary1000_v0__400_25}" array_219[@]
            go_down__1026_v0 "$(( display_count_7381 - selected_7380 ))"
            local array_220=("")
            eprintf__1017_v0 "\\x1b[G" array_220[@]
            continue
        elif [ "$(( $(( $([ "_${key_7431}" != "_a" ]; echo $?) || $([ "_${key_7431}" != "_A" ]; echo $?) )) && $(( limit_7332 < 0 )) ))" != 0 ]; then
            count_checked__1094_v0 checked_7400[@]
            local ret_count_checked1094_v0__406_37="${ret_count_checked1094_v0}"
            local __length_221=("${options_7329[@]}")
            local all_checked_7442="$(( ret_count_checked1094_v0__406_37 == ${#__length_221[@]} ))"
            local __range_start_7443=0
            local __length_222=("${checked_7400[@]}")
            local __range_end_7443="${#__length_222[@]}"
            local __dir_7443=$(( ${__range_start_7443} <= ${__range_end_7443} ? 1 : -1 ))
            for (( i_7443=${__range_start_7443}; i_7443 * ${__dir_7443} < ${__range_end_7443} * ${__dir_7443}; i_7443+=${__dir_7443} )); do
                checked_7400["${i_7443}"]="$(( ! all_checked_7442 ))"
done
            go_up__1025_v0 "${display_count_7381}"
            local array_223=("")
            eprintf__1017_v0 "\\x1b[G" array_223[@]
            render_multi_choose_page__1091_v0 page_options_7409[@] checked_7400[@] "${page_start_7412}" "${selected_7380}" "${cursor_7330}" "${display_count_7381}" "${term_width_7341}"
            continue
        elif [ "$([ "_${key_7431}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_224="${cursor_7330}"
        local max_option_width_7444="$(( $(( $(( term_width_7341 - ${#__length_224} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( prev_page_7433 != current_page_7379 ))" != 0 ]; then
            get_page_options__1088_v0 options_7329[@] "${current_page_7379}" "${page_size_7333}"
            page_options_7409=("${ret_get_page_options1088_v0[@]}")
            get_page_start__1089_v0 "${current_page_7379}" "${page_size_7333}"
            page_start_7412="${ret_get_page_start1089_v0}"
            if [ "${up_paged_7435}" != 0 ]; then
                local __length_225=("${page_options_7409[@]}")
                selected_7380="$(( ${#__length_225[@]} - 1 ))"
            fi
            go_up__1025_v0 1
            remove_line__1021_v0 "$(( display_count_7381 - 1 ))"
            remove_current_line__1022_v0 
            local array_226=("")
            eprintf__1017_v0 "\\x1b[G" array_226[@]
            render_multi_choose_page__1091_v0 page_options_7409[@] checked_7400[@] "${page_start_7412}" "${selected_7380}" "${cursor_7330}" "${display_count_7381}" "${term_width_7341}"
            render_page_indicator__1092_v0 "${current_page_7379}" "${total_pages_7378}"
        elif [ "$(( prev_selected_7432 != selected_7380 ))" != 0 ]; then
            local prev_global_7450="$(( page_start_7412 + prev_selected_7432 ))"
            go_up__1025_v0 "$(( display_count_7381 - prev_selected_7432 ))"
            local array_227=("")
            eprintf__1017_v0 "\\x1b[K" array_227[@]
            local __length_228="${cursor_7330}"
            print_blank__1023_v0 "${#__length_228}"
            if [ "${checked_7400[${prev_global_7450}]?"Index out of bounds (at src/./choose/./mod.ab:441:28)"}" != 0 ]; then
                cutoff_text__1037_v0 "${page_options_7409[${prev_selected_7432}]?"Index out of bounds (at src/./choose/./mod.ab:442:79)"}" "${max_option_width_7444}"
                local ret_cutoff_text1037_v0__442_54="${ret_cutoff_text1037_v0}"
                colored_secondary__1000_v0 "✓ ""${ret_cutoff_text1037_v0__442_54}"
                local ret_colored_secondary1000_v0__442_29="${ret_colored_secondary1000_v0}"
                local array_229=("")
                eprintf__1017_v0 "${ret_colored_secondary1000_v0__442_29}" array_229[@]
            else
                cutoff_text__1037_v0 "${page_options_7409[${prev_selected_7432}]?"Index out of bounds (at src/./choose/./mod.ab:444:61)"}" "${max_option_width_7444}"
                local ret_cutoff_text1037_v0__444_36="${ret_cutoff_text1037_v0}"
                local array_230=("")
                eprintf__1017_v0 "• ""${ret_cutoff_text1037_v0__444_36}" array_230[@]
            fi
            local diff_7451="$(( selected_7380 - prev_selected_7432 ))"
            go_up_or_down__1027_v0 "${diff_7451}"
            local array_231=("")
            eprintf__1017_v0 "\\x1b[G" array_231[@]
            local array_232=("")
            eprintf__1017_v0 "\\x1b[K" array_232[@]
            local new_global_7453="$(( page_start_7412 + selected_7380 ))"
            local check_mark_7454
            check_mark_7454="$(if [ "${checked_7400[${new_global_7453}]?"Index out of bounds (at src/./choose/./mod.ab:452:44)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__1037_v0 "${page_options_7409[${selected_7380}]?"Index out of bounds (at src/./choose/./mod.ab:453:90)"}" "${max_option_width_7444}"
            local ret_cutoff_text1037_v0__453_65="${ret_cutoff_text1037_v0}"
            colored_secondary__1000_v0 "${cursor_7330}""${check_mark_7454}""${ret_cutoff_text1037_v0__453_65}"
            local ret_colored_secondary1000_v0__453_25="${ret_colored_secondary1000_v0}"
            local array_233=("")
            eprintf__1017_v0 "${ret_colored_secondary1000_v0__453_25}" array_233[@]
            go_down__1026_v0 "$(( display_count_7381 - selected_7380 ))"
            local array_234=("")
            eprintf__1017_v0 "\\x1b[G" array_234[@]
        fi
    done
    local total_lines_7455="$(( display_count_7381 + 2 ))"
    if [ "$([ "_${header_7331}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_7455="$(( total_lines_7455 + 1 ))"
    fi
    go_down__1026_v0 1
    remove_line__1021_v0 "$(( total_lines_7455 - 1 ))"
    remove_current_line__1022_v0 
    local result_7456=()
    local __range_start_7457=0
    local __length_236=("${options_7329[@]}")
    local __range_end_7457="${#__length_236[@]}"
    local __dir_7457=$(( ${__range_start_7457} <= ${__range_end_7457} ? 1 : -1 ))
    for (( i_7457=${__range_start_7457}; i_7457 * ${__dir_7457} < ${__range_end_7457} * ${__dir_7457}; i_7457+=${__dir_7457} )); do
        if [ "${checked_7400[${i_7457}]?"Index out of bounds (at src/./choose/./mod.ab:472:20)"}" != 0 ]; then
            local array_237=("${options_7329[${i_7457}]?"Index out of bounds (at src/./choose/./mod.ab:473:32)"}")
            result_7456+=("${array_237[@]}")
        fi
done
    stty_unlock__977_v0 
    show_cursor__1029_v0 
    ret_xyl_multi_choose1095_v0=("${result_7456[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1189_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    printf '%s\n' ""
    colored_primary__999_v0 "choose"
    local ret_colored_primary999_v0__7_12="${ret_colored_primary999_v0}"
    local array_238=()
    printf__128_v1 "${ret_colored_primary999_v0__7_12}" array_238[@]
    local array_239=()
    printf__128_v1 " - Choose from a list of options." array_239[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1000_v0 "Arguments: "
    local ret_colored_secondary1000_v0__11_12="${ret_colored_secondary1000_v0}"
    local array_240=()
    printf__128_v1 "${ret_colored_secondary1000_v0__11_12}""
" array_240[@]
    echo "  [<options> ...]        List of options to choose from"
    printf '%s\n' ""
    colored_secondary__1000_v0 "Flags: "
    local ret_colored_secondary1000_v0__14_12="${ret_colored_secondary1000_v0}"
    local array_241=()
    printf__128_v1 "${ret_colored_secondary1000_v0__14_12}""
" array_241[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1240_v0() {
    local options_7311=()
    local command_243
    command_243="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_7312="${command_243}"
    if [ "$([ "_${is_tty_7312}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_7311+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1240_v0=("${options_7311[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1241_v0() {
    local parameters_7294=("${!1}")
    local cursor_7295="> "
    colored_primary__999_v0 "Choose: "
    local ret_colored_primary999_v0__17_30="${ret_colored_primary999_v0}"
    local header_7310="\\x1b[1m""${ret_colored_primary999_v0__17_30}"
    read_stdin_options__1240_v0 
    local options_7313=("${ret_read_stdin_options1240_v0[@]}")
    local multi_7314=0
    local limit_7315=-1
    local page_size_7316=10
    local __length_247=("${parameters_7294[@]}")
    local slice_upper_246="${#__length_247[@]}"
    local slice_offset_248=2
    local slice_offset_248=$((${slice_offset_248} > 0 ? ${slice_offset_248} : 0))
    local slice_length_249="$(( slice_upper_246 - slice_offset_248 ))"
    local slice_length_249=$((${slice_length_249} > 0 ? ${slice_length_249} : 0))
    for param_7317 in "${parameters_7294[@]:${slice_offset_248}:${slice_length_249}}"; do
        starts_with__22_v0 "${param_7317}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_7317}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_7317}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_7317}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_7317}" != "_-h" ]; echo $?) || $([ "_${param_7317}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1189_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_250="--cursor="
            slice__24_v0 "${param_7317}" "${#__length_250}" 0
            cursor_7295="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_251="--header="
            slice__24_v0 "${param_7317}" "${#__length_251}" 0
            header_7310="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_252="--limit="
            slice__24_v0 "${param_7317}" "${#__length_252}" 0
            local value_7319="${ret_slice24_v0}"
            parse_int__13_v0 "${value_7319}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1018_v0 "ERROR: Invalid limit value: ""${value_7319}""
" 31
                exit 1
            fi
            limit_7315="${ret_parse_int13_v0}"
            multi_7314=1
        elif [ "$([ "_${param_7317}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_7314=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_253="--page-size="
            slice__24_v0 "${param_7317}" "${#__length_253}" 0
            local value_7324="${ret_slice24_v0}"
            parse_int__13_v0 "${value_7324}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1018_v0 "ERROR: Invalid page-size value: ""${value_7324}""
" 31
                exit 1
            fi
            page_size_7316="${ret_parse_int13_v0}"
        else
            options_7313+=("${param_7317}")
        fi
    done
    has_ansi_escape__1030_v0 "${header_7310}"
    local ret_has_ansi_escape1030_v0__59_44="${ret_has_ansi_escape1030_v0}"
    escape_ansi__1031_v0 "${header_7310}"
    local ret_escape_ansi1031_v0__59_73="${ret_escape_ansi1031_v0}"
    colored_primary__999_v0 "${header_7310}"
    local ret_colored_primary999_v0__59_111="${ret_colored_primary999_v0}"
    local display_header_7328
    display_header_7328="$(if [ "$(( $([ "_${header_7310}" != "_" ]; echo $?) || ret_has_ansi_escape1030_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1031_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary999_v0__59_111}"; fi)"
    if [ "${multi_7314}" != 0 ]; then
        xyl_multi_choose__1095_v0 options_7313[@] "${cursor_7295}" "${display_header_7328}" "${limit_7315}" "${page_size_7316}"
        local results_7460=("${ret_xyl_multi_choose1095_v0[@]}")
        join__7_v0 results_7460[@] "
"
        ret_execute_choose1241_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1093_v0 options_7313[@] "${cursor_7295}" "${display_header_7328}" "${page_size_7316}"
    ret_execute_choose1241_v0="${ret_xyl_choose1093_v0}"
    return 0
}

# Perl Extensions Utilities
command_255="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_30="$([ "_${command_255}" != "_No" ]; echo $?)"
command_256="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_31="$(( $(( ! _perl_disabled_30 )) && $([ "_${command_256}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1417_v0() {
    local text_9067="${1}"
    if [ "$(( ! _perl_available_31 ))" != 0 ]; then
        ret_perl_get_cjk_width1417_v0=''
        return 1
    fi
    local command_257
    command_257="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_9067}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1417_v0=''
        return "${__status}"
    fi
    local width_str_9068="${command_257}"
    parse_int__13_v0 "${width_str_9068}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1417_v0=''
        return "${__status}"
    fi
    local width_9069="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1417_v0="${width_9069}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1418_v0() {
    local text_9076="${1}"
    local max_width_9077="${2}"
    if [ "$(( ! _perl_available_31 ))" != 0 ]; then
        ret_perl_truncate_cjk1418_v0=''
        return 1
    fi
    local command_258
    command_258="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_9076}" ${max_width_9077} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1418_v0=''
        return "${__status}"
    fi
    local result_9078="${command_258}"
    ret_perl_truncate_cjk1418_v0="${result_9078}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_32=0
_term_size_33=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1425_v0() {
    local command_260
    command_260="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_9052="${command_260}"
    parse_int__13_v0 "${count_9052}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_9053="${ret_parse_int13_v0}"
    if [ "$(( count_num_9053 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_9053="$(( count_num_9053 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_9053}
    __status=$?
}

# stty_unlock()
stty_unlock__1426_v0() {
    local command_261
    command_261="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_9149="${command_261}"
    parse_int__13_v0 "${count_9149}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_9150="${ret_parse_int13_v0}"
    if [ "$(( count_num_9150 > 0 ))" != 0 ]; then
        count_num_9150="$(( count_num_9150 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_9150}
        __status=$?
        if [ "$(( count_num_9150 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1427_v0() {
    local size_9055="${1}"
    if [ "$([ "_${size_9055}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1427_v0=0
        return 0
    fi
    split__4_v0 "${size_9055}" " "
    local parts_9056=("${ret_split4_v0[@]}")
    local __length_262=("${parts_9056[@]}")
    if [ "$(( ${#__length_262[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1427_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_9056[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_9056[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_33=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size1427_v0=1
    return 0
}

# query_term_size()
query_term_size__1428_v0() {
    local command_264
    command_264="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_9058="${command_264}"
    store_term_size__1427_v0 "${size_9058}"
    ret_query_term_size1428_v0="${ret_store_term_size1427_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1429_v0() {
    local command_265
    command_265="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_9054="${command_265}"
    store_term_size__1427_v0 "${size_9054}"
    ret_stty_term_size1429_v0="${ret_store_term_size1427_v0}"
    return 0
}

# get_term_size()
get_term_size__1430_v0() {
    stty_term_size__1429_v0 
    local detected_9057="${ret_stty_term_size1429_v0}"
    if [ "$(( ! detected_9057 ))" != 0 ]; then
        query_term_size__1428_v0 
        detected_9057="${ret_query_term_size1428_v0}"
    fi
    _got_term_size_32=1
}

# term_width()
term_width__1432_v0() {
    if [ "$(( ! _got_term_size_32 ))" != 0 ]; then
        get_term_size__1430_v0 
    fi
    ret_term_width1432_v0="${_term_size_33[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:88:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_34="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_35=0
_primary_color_36=(3 207 159 92)
_secondary_color_37=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1443_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_9035="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_9035}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1443_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1443_v0=0
        return 0
    fi
    local colorterm_9036="${ret_env_var_get120_v0}"
    _supports_truecolor_34="$(if [ "$(( $([ "_${colorterm_9036}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_9036}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1443_v0="$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1444_v0() {
    local message_9030="${1}"
    local r_9031="${2}"
    local g_9032="${3}"
    local b_9033="${4}"
    local fallback_9034="${5}"
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1444_v0="\\x1b[38;2;${r_9031};${g_9032};${b_9033}m""${message_9030}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1443_v0 
        local ret_get_supports_truecolor1443_v0__50_17="${ret_get_supports_truecolor1443_v0}"
        if [ "${ret_get_supports_truecolor1443_v0__50_17}" != 0 ]; then
            ret_colored_rgb1444_v0="\\x1b[38;2;${r_9031};${g_9032};${b_9033}m""${message_9030}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_9034 == 0 ))" != 0 ]; then
            ret_colored_rgb1444_v0="${message_9030}"
            return 0
        else
            ret_colored_rgb1444_v0="\\x1b[${fallback_9034}m""${message_9030}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_9034 == 0 ))" != 0 ]; then
            ret_colored_rgb1444_v0="${message_9030}"
            return 0
        fi
        ret_colored_rgb1444_v0="\\x1b[${fallback_9034}m""${message_9030}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1445_v0() {
    local message_9120="${1}"
    local r_9121="${2}"
    local g_9122="${3}"
    local b_9123="${4}"
    local fallback_9124="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_9125="${fallback_9124}"
    if [ "$(( $(( fallback_9124 >= 30 )) && $(( fallback_9124 <= 37 )) ))" != 0 ]; then
        bg_fallback_9125="$(( fallback_9124 + 10 ))"
    fi
    if [ "$(( $(( fallback_9124 >= 90 )) && $(( fallback_9124 <= 97 )) ))" != 0 ]; then
        bg_fallback_9125="$(( fallback_9124 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1445_v0="\\x1b[48;2;${r_9121};${g_9122};${b_9123}m""${message_9120}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1443_v0 
        local ret_get_supports_truecolor1443_v0__92_17="${ret_get_supports_truecolor1443_v0}"
        if [ "${ret_get_supports_truecolor1443_v0__92_17}" != 0 ]; then
            ret_background_rgb1445_v0="\\x1b[48;2;${r_9121};${g_9122};${b_9123}m""${message_9120}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_9125 == 0 ))" != 0 ]; then
            ret_background_rgb1445_v0="${message_9120}"
            return 0
        else
            ret_background_rgb1445_v0="\\x1b[${bg_fallback_9125}m""${message_9120}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_9125 == 0 ))" != 0 ]; then
            ret_background_rgb1445_v0="${message_9120}"
            return 0
        fi
        ret_background_rgb1445_v0="\\x1b[${bg_fallback_9125}m""${message_9120}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1446_v0() {
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_9024="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_9024}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_9024}" ";"
            local parts_9025=("${ret_split4_v0[@]}")
            local __length_269=("${parts_9025[@]}")
            if [ "$(( ${#__length_269[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9025[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9025[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9025[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9025[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_36=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_9026="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_9026}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_9026}" ";"
            local parts_9027=("${ret_split4_v0[@]}")
            local __length_271=("${parts_9027[@]}")
            if [ "$(( ${#__length_271[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9027[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9027[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9027[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9027[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_37=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_9028="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_9028}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_9028}" ";"
            local parts_9029=("${ret_split4_v0[@]}")
            local __length_273=("${parts_9029[@]}")
            if [ "$(( ${#__length_273[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9029[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9029[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9029[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9029[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_35=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1447_v0() {
    inner_get_xylitol_colors__1446_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_35=1
}

# colored_primary(message: Text)
colored_primary__1448_v0() {
    local message_9023="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1447_v0 
    fi
    colored_rgb__1444_v0 "${message_9023}" "${_primary_color_36[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_36[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_36[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_36[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1448_v0="${ret_colored_rgb1444_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1449_v0() {
    local message_9040="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1447_v0 
    fi
    colored_rgb__1444_v0 "${message_9040}" "${_secondary_color_37[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_37[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_37[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_37[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1449_v0="${ret_colored_rgb1444_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1452_v0() {
    local message_9119="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1447_v0 
    fi
    background_rgb__1445_v0 "${message_9119}" "${_secondary_color_37[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_37[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_37[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_37[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1452_v0="${ret_background_rgb1445_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1464_v0() {
    local command_275
    command_275="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_9142="${command_275}"
    if [ "$([ "_${var_9142}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1464_v0="UP"
        return 0
    elif [ "$([ "_${var_9142}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1464_v0="DOWN"
        return 0
    elif [ "$([ "_${var_9142}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1464_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_9142}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1464_v0="LEFT"
        return 0
    elif [ "$([ "_${var_9142}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1464_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_9142}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1464_v0="INPUT"
        return 0
    else
        ret_get_key1464_v0="${var_9142}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1466_v0() {
    local format_9044="${1}"
    local args_9045=("${!2}")
    args_9045=("${format_9044}" "${args_9045[@]}")
    __status=$?
    printf "${args_9045[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1467_v0() {
    local message_9042="${1}"
    local color_9043="${2}"
    # Prints an error message with a specified color.
    local array_276=("${message_9042}")
    eprintf__1466_v0 "\\x1b[${color_9043}m%s\\x1b[0m" array_276[@]
}

# colored(message: Text, color: Int)
colored__1468_v0() {
    local message_9132="${1}"
    local color_9133="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1468_v0="\\x1b[${color_9133}m""${message_9132}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1470_v0() {
    local cnt_9146="${1}"
    if [ "$(( cnt_9146 > 0 ))" != 0 ]; then
        local sequence_9147=""
        local __range_start_9148=0
        local __range_end_9148="${cnt_9146}"
        local __dir_9148=$(( ${__range_start_9148} <= ${__range_end_9148} ? 1 : -1 ))
        for (( ____9148=${__range_start_9148}; ____9148 * ${__dir_9148} < ${__range_end_9148} * ${__dir_9148}; ____9148+=${__dir_9148} )); do
            sequence_9147+="\\x1b[2K\\x1b[1A"
done
        local array_277=("")
        eprintf__1466_v0 "${sequence_9147}" array_277[@]
    fi
    local array_278=("")
    eprintf__1466_v0 "\\x1b[G" array_278[@]
}

# remove_current_line()
remove_current_line__1471_v0() {
    local array_279=("")
    eprintf__1466_v0 "\\x1b[2K\\x1b[G" array_279[@]
}

# go_up(cnt: Int)
go_up__1474_v0() {
    local cnt_9141="${1}"
    local array_280=("")
    eprintf__1466_v0 "\\x1b[${cnt_9141}A" array_280[@]
}

# go_down(cnt: Int)
go_down__1475_v0() {
    local cnt_9145="${1}"
    local array_281=("")
    eprintf__1466_v0 "\\x1b[${cnt_9145}B" array_281[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1477_v0() {
    local array_282=("")
    eprintf__1466_v0 "\\x1b[?25l" array_282[@]
}

# show_cursor()
show_cursor__1478_v0() {
    local array_283=("")
    eprintf__1466_v0 "\\x1b[?25h" array_283[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1479_v0() {
    local text_9046="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_284
    command_284="$([[ "${text_9046}" == *$'\x1b'* || "${text_9046}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_9047="${command_284}"
    ret_has_ansi_escape1479_v0="$([ "_${has_escape_9047}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1480_v0() {
    local text_9048="${1}"
    local command_285
    command_285="$(printf '%s' "${text_9048}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1480_v0="${command_285}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1481_v0() {
    local text_9063="${1}"
    local command_286
    command_286="$(printf "%s" "${text_9063}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1481_v0="${command_286}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1482_v0() {
    local text_9065="${1}"
    local command_287
    command_287="$(printf "%s" "${text_9065}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_9066="${command_287}"
    ret_is_all_ascii1482_v0="$([ "_${result_9066}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1483_v0() {
    local text_9062="${1}"
    strip_ansi__1481_v0 "${text_9062}"
    local stripped_9064="${ret_strip_ansi1481_v0}"
    # Check if text is all ASCII
    is_all_ascii__1482_v0 "${stripped_9064}"
    local ret_is_all_ascii1482_v0__150_12="${ret_is_all_ascii1482_v0}"
    if [ "$(( ! ret_is_all_ascii1482_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1417_v0 "${stripped_9064}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_288="${stripped_9064}"
            ret_get_visible_len1483_v0="${#__length_288}"
            return 0
        fi
        ret_get_visible_len1483_v0="${ret_perl_get_cjk_width1417_v0}"
        return 0
    else
        local __length_289="${stripped_9064}"
        ret_get_visible_len1483_v0="${#__length_289}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1484_v0() {
    local text_9073="${1}"
    local max_width_9074="${2}"
    get_visible_len__1483_v0 "${text_9073}"
    local visible_len_9075="${ret_get_visible_len1483_v0}"
    if [ "$(( visible_len_9075 <= max_width_9074 ))" != 0 ]; then
        ret_truncate_text1484_v0="${text_9073}"
        return 0
    fi
    is_all_ascii__1482_v0 "${text_9073}"
    local ret_is_all_ascii1482_v0__167_12="${ret_is_all_ascii1482_v0}"
    if [ "$(( ! ret_is_all_ascii1482_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1418_v0 "${text_9073}" "${max_width_9074}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_9073}" | cut -c1-${max_width_9074}
            __status=$?
        fi
        ret_truncate_text1484_v0="${ret_perl_truncate_cjk1418_v0}"
        return 0
    fi
    local command_290
    command_290="$(printf "%s" "${text_9073}" | cut -c1-${max_width_9074})"
    __status=$?
    ret_truncate_text1484_v0="${command_290}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1485_v0() {
    local text_9071="${1}"
    local max_width_9072="${2}"
    has_ansi_escape__1479_v0 "${text_9071}"
    local ret_has_ansi_escape1479_v0__179_12="${ret_has_ansi_escape1479_v0}"
    if [ "$(( ! ret_has_ansi_escape1479_v0__179_12 ))" != 0 ]; then
        truncate_text__1484_v0 "${text_9071}" "${max_width_9072}"
        ret_truncate_ansi1485_v0="${ret_truncate_text1484_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_291
    command_291="$([[ "${text_9071}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_9079="${command_291}"
    # Replace \x1b[ with newline, then split
    local command_292
    command_292="$(t="${text_9071}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_9080="${command_292}"
    split__4_v0 "${replaced_9080}" "
"
    local parts_9081=("${ret_split4_v0[@]}")
    local result_9082=""
    local remaining_width_9083="${max_width_9072}"
    local __range_start_9084=0
    local __length_293=("${parts_9081[@]}")
    local __range_end_9084="${#__length_293[@]}"
    local __dir_9084=$(( ${__range_start_9084} <= ${__range_end_9084} ? 1 : -1 ))
    for (( idx_9084=${__range_start_9084}; idx_9084 * ${__dir_9084} < ${__range_end_9084} * ${__dir_9084}; idx_9084+=${__dir_9084} )); do
        local part_9085="${parts_9081[${idx_9084}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_9084 == 0 )) && $([ "_${starts_with_ansi_9079}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_9085}" == "_" ]; echo $?) && $(( remaining_width_9083 > 0 )) ))" != 0 ]; then
                truncate_text__1484_v0 "${part_9085}" "${remaining_width_9083}"
                local ret_truncate_text1484_v0__201_35="${ret_truncate_text1484_v0}"
                local truncated_9086="${ret_truncate_text1484_v0__201_35}"
                result_9082+="${truncated_9086}"
                get_visible_len__1483_v0 "${truncated_9086}"
                local ret_get_visible_len1483_v0__203_36="${ret_get_visible_len1483_v0}"
                remaining_width_9083="$(( remaining_width_9083 - ret_get_visible_len1483_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_294
            command_294="$(__p="${part_9085}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_9087="${command_294}"
            if [ "$([ "_${m_idx_9087}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_295
                command_295="$(__p="${part_9085}"; printf "%s" "${__p:0:${m_idx_9087}}")"
                __status=$?
                local ansi_params_9088="${command_295}"
                result_9082+="\\x1b[""${ansi_params_9088}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_9087}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_9089="${ret_parse_int13_v0__214_41}"
                local text_start_9090="$(( m_idx_num_9089 + 1 ))"
                local command_296
                command_296="$(__p="${part_9085}"; printf "%s" "${__p:${text_start_9090}}")"
                __status=$?
                local text_part_9091="${command_296}"
                if [ "$(( $([ "_${text_part_9091}" == "_" ]; echo $?) && $(( remaining_width_9083 > 0 )) ))" != 0 ]; then
                    truncate_text__1484_v0 "${text_part_9091}" "${remaining_width_9083}"
                    local ret_truncate_text1484_v0__218_39="${ret_truncate_text1484_v0}"
                    local truncated_9092="${ret_truncate_text1484_v0__218_39}"
                    result_9082+="${truncated_9092}"
                    get_visible_len__1483_v0 "${truncated_9092}"
                    local ret_get_visible_len1483_v0__220_40="${ret_get_visible_len1483_v0}"
                    remaining_width_9083="$(( remaining_width_9083 - ret_get_visible_len1483_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_9085}" == "_" ]; echo $?) && $(( remaining_width_9083 > 0 )) ))" != 0 ]; then
                    truncate_text__1484_v0 "${part_9085}" "${remaining_width_9083}"
                    local ret_truncate_text1484_v0__225_39="${ret_truncate_text1484_v0}"
                    local truncated_9093="${ret_truncate_text1484_v0__225_39}"
                    result_9082+="${truncated_9093}"
                    get_visible_len__1483_v0 "${truncated_9093}"
                    local ret_get_visible_len1483_v0__227_40="${ret_get_visible_len1483_v0}"
                    remaining_width_9083="$(( remaining_width_9083 - ret_get_visible_len1483_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1485_v0="${result_9082}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1486_v0() {
    local text_9060="${1}"
    local max_width_9061="${2}"
    get_visible_len__1483_v0 "${text_9060}"
    local visible_len_9070="${ret_get_visible_len1483_v0}"
    if [ "$(( visible_len_9070 <= max_width_9061 ))" != 0 ]; then
        ret_cutoff_text1486_v0="${text_9060}"
        return 0
    fi
    truncate_ansi__1485_v0 "${text_9060}" "$(( max_width_9061 - 3 ))"
    local ret_truncate_ansi1485_v0__243_12="${ret_truncate_ansi1485_v0}"
    ret_cutoff_text1486_v0="${ret_truncate_ansi1485_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1487_v0() {
    local items_9126=("${!1}")
    local total_len_9127="${2}"
    local term_width_9128="${3}"
    local separator_9129=" • "
    local separator_len_9130=3
    # Fast path: no truncation needed
    if [ "$(( total_len_9127 <= term_width_9128 ))" != 0 ]; then
        local iter_9131=0
        while :
        do
            local __length_297=("${items_9126[@]}")
            if [ "$(( iter_9131 >= ${#__length_297[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_9131 > 0 ))" != 0 ]; then
                eprintf_colored__1467_v0 "${separator_9129}" 90
            fi
            colored__1468_v0 "${items_9126[$(( iter_9131 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1468_v0__268_41="${ret_colored1468_v0}"
            local array_298=("")
            eprintf__1466_v0 "${items_9126[${iter_9131}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1468_v0__268_41}" array_298[@]
            iter_9131="$(( iter_9131 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_9134=0
        local first_9135=1
        local iter_9136=0
        while :
        do
            local __length_299=("${items_9126[@]}")
            if [ "$(( iter_9136 >= ${#__length_299[@]} ))" != 0 ]; then
                break
            fi
            local key_9137="${items_9126[${iter_9136}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_9138="${items_9126[$(( iter_9136 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_300="${key_9137}"
            local __length_301="${action_9138}"
            local part_len_9139="$(( $(( ${#__length_300} + 1 )) + ${#__length_301} ))"
            local needed_9140="${part_len_9139}"
            if [ "$(( ! first_9135 ))" != 0 ]; then
                needed_9140="$(( needed_9140 + separator_len_9130 ))"
            fi
            if [ "$(( $(( current_len_9134 + needed_9140 )) > term_width_9128 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_9135 ))" != 0 ]; then
                eprintf_colored__1467_v0 "${separator_9129}" 90
            fi
            colored__1468_v0 "${action_9138}" 2
            local ret_colored1468_v0__296_33="${ret_colored1468_v0}"
            local array_302=("")
            eprintf__1466_v0 "${key_9137}"" ""${ret_colored1468_v0__296_33}" array_302[@]
            current_len_9134="$(( current_len_9134 + needed_9140 ))"
            first_9135=0
            iter_9136="$(( iter_9136 + 2 ))"
        done
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1537_v0() {
    local selected_9095="${1}"
    local term_width_9096="${2}"
    local small_9097="$(( term_width_9096 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_9097}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_9116="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_9097}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_9117="${ret_cpad29_v0}"
    local gap_9118
    gap_9118="$(if [ "${small_9097}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_303=("")
    eprintf__1466_v0 " " array_303[@]
    if [ "${selected_9095}" != 0 ]; then
        # Yes selected
        background_secondary__1452_v0 "${yes_label_9116}"
        local ret_background_secondary1452_v0__16_30="${ret_background_secondary1452_v0}"
        local array_304=("")
        eprintf__1466_v0 "\\x1b[97m""${ret_background_secondary1452_v0__16_30}" array_304[@]
        local array_305=("")
        eprintf__1466_v0 "${gap_9118}" array_305[@]
        # No not selected (dim)
        local array_306=("")
        eprintf__1466_v0 "\\x1b[49;37m""${no_label_9117}""\\x1b[0m" array_306[@]
    else
        # No selected
        local array_307=("")
        eprintf__1466_v0 "\\x1b[49;37m""${yes_label_9116}""\\x1b[0m" array_307[@]
        local array_308=("")
        eprintf__1466_v0 "${gap_9118}" array_308[@]
        background_secondary__1452_v0 "${no_label_9117}"
        local ret_background_secondary1452_v0__24_30="${ret_background_secondary1452_v0}"
        local array_309=("")
        eprintf__1466_v0 "\\x1b[97m""${ret_background_secondary1452_v0__24_30}" array_309[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1538_v0() {
    local header_9050="${1}"
    local default_yes_9051="${2}"
    stty_lock__1425_v0 
    hide_cursor__1477_v0 
    term_width__1432_v0 
    local term_width_9059="${ret_term_width1432_v0}"
    if [ "$([ "_${header_9050}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1486_v0 "${header_9050}" "${term_width_9059}"
        local ret_cutoff_text1486_v0__46_17="${ret_cutoff_text1486_v0}"
        local array_310=("")
        eprintf__1466_v0 "${ret_cutoff_text1486_v0__46_17}""

" array_310[@]
    fi
    local selected_9094="${default_yes_9051}"
    # Render initial options
    render_confirm_options__1537_v0 "${selected_9094}" "${term_width_9059}"
    local array_311=("")
    eprintf__1466_v0 "

" array_311[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_312=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1487_v0 array_312[@] 40 "${term_width_9059}"
    go_up__1474_v0 2
    while :
    do
        get_key__1464_v0 
        local key_9143="${ret_get_key1464_v0}"
        if [ "$(( $(( $(( $([ "_${key_9143}" != "_LEFT" ]; echo $?) || $([ "_${key_9143}" != "_h" ]; echo $?) )) || $([ "_${key_9143}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_9143}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_9094}" != 0 ]; then
                selected_9094=0
                local array_313=("")
                eprintf__1466_v0 "\\x1b[G\\x1b[K" array_313[@]
                render_confirm_options__1537_v0 "${selected_9094}" "${term_width_9059}"
            elif [ "$(( ! selected_9094 ))" != 0 ]; then
                selected_9094=1
                local array_314=("")
                eprintf__1466_v0 "\\x1b[G\\x1b[K" array_314[@]
                render_confirm_options__1537_v0 "${selected_9094}" "${term_width_9059}"
            fi
        elif [ "$(( $([ "_${key_9143}" != "_y" ]; echo $?) || $([ "_${key_9143}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_9094=1
            break
        elif [ "$(( $([ "_${key_9143}" != "_n" ]; echo $?) || $([ "_${key_9143}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_9094=0
            break
        elif [ "$([ "_${key_9143}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_9144=4
    if [ "$([ "_${header_9050}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_9144="$(( total_lines_9144 + 1 ))"
    fi
    go_down__1475_v0 2
    remove_line__1470_v0 "$(( total_lines_9144 - 1 ))"
    remove_current_line__1471_v0 
    stty_unlock__1426_v0 
    show_cursor__1478_v0 
    ret_xyl_confirm1538_v0="${selected_9094}"
    return 0
}

# print_confirm_help()
print_confirm_help__1631_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    printf '%s\n' ""
    colored_primary__1448_v0 "confirm"
    local ret_colored_primary1448_v0__7_12="${ret_colored_primary1448_v0}"
    local array_315=()
    printf__128_v1 "${ret_colored_primary1448_v0__7_12}" array_315[@]
    local array_316=()
    printf__128_v1 " - Display a Yes/No confirmation dialog." array_316[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1449_v0 "Flags: "
    local ret_colored_secondary1449_v0__11_12="${ret_colored_secondary1449_v0}"
    local array_317=()
    printf__128_v1 "${ret_colored_secondary1449_v0__11_12}""
" array_317[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1682_v0() {
    local parameters_9022=("${!1}")
    colored_primary__1448_v0 "Are you sure?"
    local ret_colored_primary1448_v0__9_30="${ret_colored_primary1448_v0}"
    local header_9037="\\x1b[1m""${ret_colored_primary1448_v0__9_30}"
    local default_yes_9038=1
    for param_9039 in "${parameters_9022[@]}"; do
        starts_with__22_v0 "${param_9039}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_9039}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_9039}" != "_-h" ]; echo $?) || $([ "_${param_9039}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1631_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_320="--header="
            slice__24_v0 "${param_9039}" "${#__length_320}" 0
            header_9037="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_321="--default="
            slice__24_v0 "${param_9039}" "${#__length_321}" 0
            local value_9041="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_9041}" != "_yes" ]; echo $?) || $([ "_${value_9041}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_9038=1
            elif [ "$(( $([ "_${value_9041}" != "_no" ]; echo $?) || $([ "_${value_9041}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_9038=0
            else
                eprintf_colored__1467_v0 "ERROR: Invalid default value: ""${value_9041}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1479_v0 "${header_9037}"
    local ret_has_ansi_escape1479_v0__35_44="${ret_has_ansi_escape1479_v0}"
    escape_ansi__1480_v0 "${header_9037}"
    local ret_escape_ansi1480_v0__35_73="${ret_escape_ansi1480_v0}"
    colored_primary__1448_v0 "${header_9037}"
    local ret_colored_primary1448_v0__35_111="${ret_colored_primary1448_v0}"
    local display_header_9049
    display_header_9049="$(if [ "$(( $([ "_${header_9037}" != "_" ]; echo $?) || ret_has_ansi_escape1479_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1480_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1448_v0__35_111}"; fi)"
    xyl_confirm__1538_v0 "${display_header_9049}" "${default_yes_9038}"
    local result_9151="${ret_xyl_confirm1538_v0}"
    ret_execute_confirm1682_v0="$(if [ "${result_9151}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# get_directory_entries(path: Text)
get_directory_entries__1837_v0() {
    local path_12881="${1}"
    # `names` comes from the `ls` builtin, which sorts under `LC_ALL=C`.
    # The long listings below must use the same collation, otherwise the
    # three arrays fall out of alignment for non-ASCII file names.
    local command_322
    command_322="$(LC_ALL=C ls -lA "${path_12881}" 2>/dev/null | tail -n +2)"
    __status=$?
    local raw_output_12882="${command_322}"
    local command_323
    command_323="$(LC_ALL=C ls -lA "${path_12881}" | tail -n +2 | sed -E 's/^(.).*/\1/')"
    __status=$?
    local types_output_12883="${command_323}"
    local __ls_path_324="${path_12881}"
    __ls_path_324="${__ls_path_324//\\/\\\\}"
    (( 1 )) && __ls_all_324="-A" || __ls_all_324=""
    (( 0 )) && __ls_rec_324="-R" || __ls_rec_324=""
    local __ls_324=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_324 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_324} ${__ls_rec_324} ${__ls_path_324}
    __status=$?
    );
    local names_12884=("${__ls_324[@]}")
    split__4_v0 "${types_output_12883}" "
"
    local types_12885=("${ret_split4_v0[@]}")
    split__4_v0 "${raw_output_12882}" "
"
    local raw_12886=("${ret_split4_v0[@]}")
    local entries_12887=()
    local __range_start_12888=0
    local __length_326=("${raw_12886[@]}")
    local __range_end_12888="${#__length_326[@]}"
    local __dir_12888=$(( ${__range_start_12888} <= ${__range_end_12888} ? 1 : -1 ))
    for (( i_12888=${__range_start_12888}; i_12888 * ${__dir_12888} < ${__range_end_12888} * ${__dir_12888}; i_12888+=${__dir_12888} )); do
        local file_type_12889="f"
        local target_12890=""
        if [ "$([ "_${types_12885[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:22:19)"}" != "_-" ]; echo $?)" != 0 ]; then
            file_type_12889="f"
        elif [ "$([ "_${types_12885[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:25:19)"}" != "_d" ]; echo $?)" != 0 ]; then
            file_type_12889="d"
        elif [ "$([ "_${types_12885[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:28:19)"}" != "_l" ]; echo $?)" != 0 ]; then
            local command_327
            command_327="$(echo ${raw_12886[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:44)"} | sed 's/.*-> //')"
            __status=$?
            target_12890="${command_327}"
            file_type_12889="l"
        fi
        if [ "$([ "_${file_type_12889}" != "_l" ]; echo $?)" != 0 ]; then
            local array_328=("${names_12884[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:35:33)"}	${types_12885[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:35:45)"}	${target_12890}")
            entries_12887+=("${array_328[@]}")
        else
            local array_329=("${names_12884[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:37:33)"}	${types_12885[${i_12888}]?"Index out of bounds (at src/./file/../utils/fs.ab:37:45)"}")
            entries_12887+=("${array_329[@]}")
        fi
done
    ret_get_directory_entries1837_v0=("${entries_12887[@]}")
    return 0
}

# parse_entry(entry: Text)
parse_entry__1838_v0() {
    local entry_12895="${1}"
    split__4_v0 "${entry_12895}" "	"
    ret_parse_entry1838_v0=("${ret_split4_v0[@]}")
    return 0
}

# get_cwd()
get_cwd__1839_v0() {
    local command_330
    command_330="$(pwd)"
    __status=$?
    ret_get_cwd1839_v0="${command_330}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1840_v0() {
    local path_12879="${1}"
    local command_331
    command_331="$(cd "${path_12879}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_12880="${command_331}"
    if [ "$([ "_${normalized_12880}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1840_v0="${path_12879}"
        return 0
    fi
    ret_normalize_path1840_v0="${normalized_12880}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1841_v0() {
    local base_13044="${1}"
    local child_13045="${2}"
    if [ "$([ "_${base_13044}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1841_v0="/""${child_13045}"
        return 0
    fi
    ret_path_join1841_v0="${base_13044}""/""${child_13045}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1842_v0() {
    local path_13042="${1}"
    local command_332
    command_332="$(dirname "${path_13042}")"
    __status=$?
    local parent_13043="${command_332}"
    ret_get_parent_dir1842_v0="${parent_13043}"
    return 0
}

# Perl Extensions Utilities
command_333="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_39="$([ "_${command_333}" != "_No" ]; echo $?)"
command_334="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_40="$(( $(( ! _perl_disabled_39 )) && $([ "_${command_334}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1859_v0() {
    local command_336
    command_336="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_12876="${command_336}"
    parse_int__13_v0 "${count_12876}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_12877="${ret_parse_int13_v0}"
    if [ "$(( count_num_12877 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_12877="$(( count_num_12877 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_12877}
    __status=$?
}

# stty_unlock()
stty_unlock__1860_v0() {
    local command_337
    command_337="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_12902="${command_337}"
    parse_int__13_v0 "${count_12902}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_12903="${ret_parse_int13_v0}"
    if [ "$(( count_num_12903 > 0 ))" != 0 ]; then
        count_num_12903="$(( count_num_12903 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_12903}
        __status=$?
        if [ "$(( count_num_12903 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_43="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_44=0
_primary_color_45=(3 207 159 92)
_secondary_color_46=(3 118 206 94)
_accent_color_47=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__1877_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_12864="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_12864}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1877_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1877_v0=0
        return 0
    fi
    local colorterm_12865="${ret_env_var_get120_v0}"
    _supports_truecolor_43="$(if [ "$(( $([ "_${colorterm_12865}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_12865}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1877_v0="$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1878_v0() {
    local message_12859="${1}"
    local r_12860="${2}"
    local g_12861="${3}"
    local b_12862="${4}"
    local fallback_12863="${5}"
    if [ "$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1878_v0="\\x1b[38;2;${r_12860};${g_12861};${b_12862}m""${message_12859}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_43}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1877_v0 
        local ret_get_supports_truecolor1877_v0__50_17="${ret_get_supports_truecolor1877_v0}"
        if [ "${ret_get_supports_truecolor1877_v0__50_17}" != 0 ]; then
            ret_colored_rgb1878_v0="\\x1b[38;2;${r_12860};${g_12861};${b_12862}m""${message_12859}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_12863 == 0 ))" != 0 ]; then
            ret_colored_rgb1878_v0="${message_12859}"
            return 0
        else
            ret_colored_rgb1878_v0="\\x1b[${fallback_12863}m""${message_12859}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_12863 == 0 ))" != 0 ]; then
            ret_colored_rgb1878_v0="${message_12859}"
            return 0
        fi
        ret_colored_rgb1878_v0="\\x1b[${fallback_12863}m""${message_12859}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1880_v0() {
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_12853="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_12853}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_12853}" ";"
            local parts_12854=("${ret_split4_v0[@]}")
            local __length_341=("${parts_12854[@]}")
            if [ "$(( ${#__length_341[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_12854[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12854[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12854[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12854[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_45=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_12855="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_12855}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_12855}" ";"
            local parts_12856=("${ret_split4_v0[@]}")
            local __length_343=("${parts_12856[@]}")
            if [ "$(( ${#__length_343[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_12856[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12856[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12856[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12856[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_46=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_12857="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_12857}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_12857}" ";"
            local parts_12858=("${ret_split4_v0[@]}")
            local __length_345=("${parts_12858[@]}")
            if [ "$(( ${#__length_345[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_12858[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12858[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12858[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12858[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1880_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_47=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_44=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1881_v0() {
    inner_get_xylitol_colors__1880_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_44=1
}

# colored_primary(message: Text)
colored_primary__1882_v0() {
    local message_12852="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1881_v0 
    fi
    colored_rgb__1878_v0 "${message_12852}" "${_primary_color_45[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_45[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_45[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_45[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1882_v0="${ret_colored_rgb1878_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1883_v0() {
    local message_12866="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1881_v0 
    fi
    colored_rgb__1878_v0 "${message_12866}" "${_secondary_color_46[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_46[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_46[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_46[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1883_v0="${ret_colored_rgb1878_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__1884_v0() {
    local message_12901="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1881_v0 
    fi
    colored_rgb__1878_v0 "${message_12901}" "${_accent_color_47[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_47[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_47[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_47[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent1884_v0="${ret_colored_rgb1878_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__1900_v0() {
    local format_12870="${1}"
    local args_12871=("${!2}")
    args_12871=("${format_12870}" "${args_12871[@]}")
    __status=$?
    printf "${args_12871[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1901_v0() {
    local message_12868="${1}"
    local color_12869="${2}"
    # Prints an error message with a specified color.
    local array_347=("${message_12868}")
    eprintf__1900_v0 "\\x1b[${color_12869}m%s\\x1b[0m" array_347[@]
}

# remove_current_line()
remove_current_line__1905_v0() {
    local array_348=("")
    eprintf__1900_v0 "\\x1b[2K\\x1b[G" array_348[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_349="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_48="$([ "_${command_349}" != "_No" ]; echo $?)"
command_350="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_49="$(( $(( ! _perl_disabled_48 )) && $([ "_${command_350}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2072_v0() {
    local text_12930="${1}"
    if [ "$(( ! _perl_available_49 ))" != 0 ]; then
        ret_perl_get_cjk_width2072_v0=''
        return 1
    fi
    local command_351
    command_351="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_12930}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2072_v0=''
        return "${__status}"
    fi
    local width_str_12931="${command_351}"
    parse_int__13_v0 "${width_str_12931}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2072_v0=''
        return "${__status}"
    fi
    local width_12932="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2072_v0="${width_12932}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2073_v0() {
    local text_12941="${1}"
    local max_width_12942="${2}"
    if [ "$(( ! _perl_available_49 ))" != 0 ]; then
        ret_perl_truncate_cjk2073_v0=''
        return 1
    fi
    local command_352
    command_352="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_12941}" ${max_width_12942} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2073_v0=''
        return "${__status}"
    fi
    local result_12943="${command_352}"
    ret_perl_truncate_cjk2073_v0="${result_12943}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_50=0
_term_size_51=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__2080_v0() {
    local command_354
    command_354="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_12913="${command_354}"
    parse_int__13_v0 "${count_12913}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_12914="${ret_parse_int13_v0}"
    if [ "$(( count_num_12914 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_12914="$(( count_num_12914 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_12914}
    __status=$?
}

# stty_unlock()
stty_unlock__2081_v0() {
    local command_355
    command_355="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13030="${command_355}"
    parse_int__13_v0 "${count_13030}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13031="${ret_parse_int13_v0}"
    if [ "$(( count_num_13031 > 0 ))" != 0 ]; then
        count_num_13031="$(( count_num_13031 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13031}
        __status=$?
        if [ "$(( count_num_13031 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2082_v0() {
    local size_12916="${1}"
    if [ "$([ "_${size_12916}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2082_v0=0
        return 0
    fi
    split__4_v0 "${size_12916}" " "
    local parts_12917=("${ret_split4_v0[@]}")
    local __length_356=("${parts_12917[@]}")
    if [ "$(( ${#__length_356[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2082_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_12917[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_12917[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_51=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size2082_v0=1
    return 0
}

# query_term_size()
query_term_size__2083_v0() {
    local command_358
    command_358="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_12919="${command_358}"
    store_term_size__2082_v0 "${size_12919}"
    ret_query_term_size2083_v0="${ret_store_term_size2082_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2084_v0() {
    local command_359
    command_359="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_12915="${command_359}"
    store_term_size__2082_v0 "${size_12915}"
    ret_stty_term_size2084_v0="${ret_store_term_size2082_v0}"
    return 0
}

# get_term_size()
get_term_size__2085_v0() {
    stty_term_size__2084_v0 
    local detected_12918="${ret_stty_term_size2084_v0}"
    if [ "$(( ! detected_12918 ))" != 0 ]; then
        query_term_size__2083_v0 
        detected_12918="${ret_query_term_size2083_v0}"
    fi
    _got_term_size_50=1
}

# term_width()
term_width__2087_v0() {
    if [ "$(( ! _got_term_size_50 ))" != 0 ]; then
        get_term_size__2085_v0 
    fi
    ret_term_width2087_v0="${_term_size_51[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:88:23)"}"
    return 0
}

# term_height()
term_height__2088_v0() {
    if [ "$(( ! _got_term_size_50 ))" != 0 ]; then
        get_term_size__2085_v0 
    fi
    ret_term_height2088_v0="${_term_size_51[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_52="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_53=0
_secondary_color_55=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2098_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_13010="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_13010}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor2098_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor2098_v0=0
        return 0
    fi
    local colorterm_13011="${ret_env_var_get120_v0}"
    _supports_truecolor_52="$(if [ "$(( $([ "_${colorterm_13011}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_13011}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2098_v0="$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2099_v0() {
    local message_13005="${1}"
    local r_13006="${2}"
    local g_13007="${3}"
    local b_13008="${4}"
    local fallback_13009="${5}"
    if [ "$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2099_v0="\\x1b[38;2;${r_13006};${g_13007};${b_13008}m""${message_13005}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_52}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2098_v0 
        local ret_get_supports_truecolor2098_v0__50_17="${ret_get_supports_truecolor2098_v0}"
        if [ "${ret_get_supports_truecolor2098_v0__50_17}" != 0 ]; then
            ret_colored_rgb2099_v0="\\x1b[38;2;${r_13006};${g_13007};${b_13008}m""${message_13005}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_13009 == 0 ))" != 0 ]; then
            ret_colored_rgb2099_v0="${message_13005}"
            return 0
        else
            ret_colored_rgb2099_v0="\\x1b[${fallback_13009}m""${message_13005}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_13009 == 0 ))" != 0 ]; then
            ret_colored_rgb2099_v0="${message_13005}"
            return 0
        fi
        ret_colored_rgb2099_v0="\\x1b[${fallback_13009}m""${message_13005}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2101_v0() {
    if [ "$(( ! _got_xylitol_colors_53 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_12999="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_12999}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_12999}" ";"
            local parts_13000=("${ret_split4_v0[@]}")
            local __length_363=("${parts_13000[@]}")
            if [ "$(( ${#__length_363[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13000[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13000[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13000[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13000[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_13001="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_13001}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_13001}" ";"
            local parts_13002=("${ret_split4_v0[@]}")
            local __length_365=("${parts_13002[@]}")
            if [ "$(( ${#__length_365[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13002[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13002[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13002[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13002[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_55=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_13003="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_13003}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_13003}" ";"
            local parts_13004=("${ret_split4_v0[@]}")
            local __length_367=("${parts_13004[@]}")
            if [ "$(( ${#__length_367[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13004[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13004[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13004[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13004[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2101_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_53=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2102_v0() {
    inner_get_xylitol_colors__2101_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_53=1
}

# colored_secondary(message: Text)
colored_secondary__2104_v0() {
    local message_12998="${1}"
    if [ "$(( ! _got_xylitol_colors_53 ))" != 0 ]; then
        get_xylitol_colors__2102_v0 
    fi
    colored_rgb__2099_v0 "${message_12998}" "${_secondary_color_55[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_55[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_55[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_55[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2104_v0="${ret_colored_rgb2099_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2119_v0() {
    local command_369
    command_369="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_13015="${command_369}"
    if [ "$([ "_${var_13015}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2119_v0="UP"
        return 0
    elif [ "$([ "_${var_13015}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2119_v0="DOWN"
        return 0
    elif [ "$([ "_${var_13015}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2119_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_13015}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2119_v0="LEFT"
        return 0
    elif [ "$([ "_${var_13015}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2119_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_13015}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2119_v0="INPUT"
        return 0
    else
        ret_get_key2119_v0="${var_13015}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2121_v0() {
    local format_12911="${1}"
    local args_12912=("${!2}")
    args_12912=("${format_12911}" "${args_12912[@]}")
    __status=$?
    printf "${args_12912[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2122_v0() {
    local message_12909="${1}"
    local color_12910="${2}"
    # Prints an error message with a specified color.
    local array_370=("${message_12909}")
    eprintf__2121_v0 "\\x1b[${color_12910}m%s\\x1b[0m" array_370[@]
}

# colored(message: Text, color: Int)
colored__2123_v0() {
    local message_12971="${1}"
    local color_12972="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2123_v0="\\x1b[${color_12972}m""${message_12971}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2125_v0() {
    local cnt_13021="${1}"
    if [ "$(( cnt_13021 > 0 ))" != 0 ]; then
        local sequence_13022=""
        local __range_start_13023=0
        local __range_end_13023="${cnt_13021}"
        local __dir_13023=$(( ${__range_start_13023} <= ${__range_end_13023} ? 1 : -1 ))
        for (( ____13023=${__range_start_13023}; ____13023 * ${__dir_13023} < ${__range_end_13023} * ${__dir_13023}; ____13023+=${__dir_13023} )); do
            sequence_13022+="\\x1b[2K\\x1b[1A"
done
        local array_371=("")
        eprintf__2121_v0 "${sequence_13022}" array_371[@]
    fi
    local array_372=("")
    eprintf__2121_v0 "\\x1b[G" array_372[@]
}

# remove_current_line()
remove_current_line__2126_v0() {
    local array_373=("")
    eprintf__2121_v0 "\\x1b[2K\\x1b[G" array_373[@]
}

# print_blank(cnt: Int)
print_blank__2127_v0() {
    local cnt_13012="${1}"
    printf '%*s' "${cnt_13012}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2128_v0() {
    local cnt_12963="${1}"
    local __range_start_12964=0
    local __range_end_12964="${cnt_12963}"
    local __dir_12964=$(( ${__range_start_12964} <= ${__range_end_12964} ? 1 : -1 ))
    for (( ____12964=${__range_start_12964}; ____12964 * ${__dir_12964} < ${__range_end_12964} * ${__dir_12964}; ____12964+=${__dir_12964} )); do
        local array_374=("")
        eprintf__2121_v0 "
" array_374[@]
done
}

# go_up(cnt: Int)
go_up__2129_v0() {
    local cnt_12980="${1}"
    local array_375=("")
    eprintf__2121_v0 "\\x1b[${cnt_12980}A" array_375[@]
}

# go_down(cnt: Int)
go_down__2130_v0() {
    local cnt_13028="${1}"
    local array_376=("")
    eprintf__2121_v0 "\\x1b[${cnt_13028}B" array_376[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2131_v0() {
    local cnt_13027="${1}"
    if [ "$(( cnt_13027 > 0 ))" != 0 ]; then
        go_down__2130_v0 "${cnt_13027}"
    else
        go_up__2129_v0 "$(( - cnt_13027 ))"
    fi
}

# hide_cursor()
hide_cursor__2132_v0() {
    local array_377=("")
    eprintf__2121_v0 "\\x1b[?25l" array_377[@]
}

# show_cursor()
show_cursor__2133_v0() {
    local array_378=("")
    eprintf__2121_v0 "\\x1b[?25h" array_378[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2134_v0() {
    local text_12936="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_379
    command_379="$([[ "${text_12936}" == *$'\x1b'* || "${text_12936}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_12937="${command_379}"
    ret_has_ansi_escape2134_v0="$([ "_${has_escape_12937}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2136_v0() {
    local text_12926="${1}"
    local command_380
    command_380="$(printf "%s" "${text_12926}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2136_v0="${command_380}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2137_v0() {
    local text_12928="${1}"
    local command_381
    command_381="$(printf "%s" "${text_12928}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_12929="${command_381}"
    ret_is_all_ascii2137_v0="$([ "_${result_12929}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2138_v0() {
    local text_12925="${1}"
    strip_ansi__2136_v0 "${text_12925}"
    local stripped_12927="${ret_strip_ansi2136_v0}"
    # Check if text is all ASCII
    is_all_ascii__2137_v0 "${stripped_12927}"
    local ret_is_all_ascii2137_v0__150_12="${ret_is_all_ascii2137_v0}"
    if [ "$(( ! ret_is_all_ascii2137_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2072_v0 "${stripped_12927}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_382="${stripped_12927}"
            ret_get_visible_len2138_v0="${#__length_382}"
            return 0
        fi
        ret_get_visible_len2138_v0="${ret_perl_get_cjk_width2072_v0}"
        return 0
    else
        local __length_383="${stripped_12927}"
        ret_get_visible_len2138_v0="${#__length_383}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2139_v0() {
    local text_12938="${1}"
    local max_width_12939="${2}"
    get_visible_len__2138_v0 "${text_12938}"
    local visible_len_12940="${ret_get_visible_len2138_v0}"
    if [ "$(( visible_len_12940 <= max_width_12939 ))" != 0 ]; then
        ret_truncate_text2139_v0="${text_12938}"
        return 0
    fi
    is_all_ascii__2137_v0 "${text_12938}"
    local ret_is_all_ascii2137_v0__167_12="${ret_is_all_ascii2137_v0}"
    if [ "$(( ! ret_is_all_ascii2137_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2073_v0 "${text_12938}" "${max_width_12939}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_12938}" | cut -c1-${max_width_12939}
            __status=$?
        fi
        ret_truncate_text2139_v0="${ret_perl_truncate_cjk2073_v0}"
        return 0
    fi
    local command_384
    command_384="$(printf "%s" "${text_12938}" | cut -c1-${max_width_12939})"
    __status=$?
    ret_truncate_text2139_v0="${command_384}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2140_v0() {
    local text_12934="${1}"
    local max_width_12935="${2}"
    has_ansi_escape__2134_v0 "${text_12934}"
    local ret_has_ansi_escape2134_v0__179_12="${ret_has_ansi_escape2134_v0}"
    if [ "$(( ! ret_has_ansi_escape2134_v0__179_12 ))" != 0 ]; then
        truncate_text__2139_v0 "${text_12934}" "${max_width_12935}"
        ret_truncate_ansi2140_v0="${ret_truncate_text2139_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_385
    command_385="$([[ "${text_12934}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_12944="${command_385}"
    # Replace \x1b[ with newline, then split
    local command_386
    command_386="$(t="${text_12934}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_12945="${command_386}"
    split__4_v0 "${replaced_12945}" "
"
    local parts_12946=("${ret_split4_v0[@]}")
    local result_12947=""
    local remaining_width_12948="${max_width_12935}"
    local __range_start_12949=0
    local __length_387=("${parts_12946[@]}")
    local __range_end_12949="${#__length_387[@]}"
    local __dir_12949=$(( ${__range_start_12949} <= ${__range_end_12949} ? 1 : -1 ))
    for (( idx_12949=${__range_start_12949}; idx_12949 * ${__dir_12949} < ${__range_end_12949} * ${__dir_12949}; idx_12949+=${__dir_12949} )); do
        local part_12950="${parts_12946[${idx_12949}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_12949 == 0 )) && $([ "_${starts_with_ansi_12944}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_12950}" == "_" ]; echo $?) && $(( remaining_width_12948 > 0 )) ))" != 0 ]; then
                truncate_text__2139_v0 "${part_12950}" "${remaining_width_12948}"
                local ret_truncate_text2139_v0__201_35="${ret_truncate_text2139_v0}"
                local truncated_12951="${ret_truncate_text2139_v0__201_35}"
                result_12947+="${truncated_12951}"
                get_visible_len__2138_v0 "${truncated_12951}"
                local ret_get_visible_len2138_v0__203_36="${ret_get_visible_len2138_v0}"
                remaining_width_12948="$(( remaining_width_12948 - ret_get_visible_len2138_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_388
            command_388="$(__p="${part_12950}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_12952="${command_388}"
            if [ "$([ "_${m_idx_12952}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_389
                command_389="$(__p="${part_12950}"; printf "%s" "${__p:0:${m_idx_12952}}")"
                __status=$?
                local ansi_params_12953="${command_389}"
                result_12947+="\\x1b[""${ansi_params_12953}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_12952}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_12954="${ret_parse_int13_v0__214_41}"
                local text_start_12955="$(( m_idx_num_12954 + 1 ))"
                local command_390
                command_390="$(__p="${part_12950}"; printf "%s" "${__p:${text_start_12955}}")"
                __status=$?
                local text_part_12956="${command_390}"
                if [ "$(( $([ "_${text_part_12956}" == "_" ]; echo $?) && $(( remaining_width_12948 > 0 )) ))" != 0 ]; then
                    truncate_text__2139_v0 "${text_part_12956}" "${remaining_width_12948}"
                    local ret_truncate_text2139_v0__218_39="${ret_truncate_text2139_v0}"
                    local truncated_12957="${ret_truncate_text2139_v0__218_39}"
                    result_12947+="${truncated_12957}"
                    get_visible_len__2138_v0 "${truncated_12957}"
                    local ret_get_visible_len2138_v0__220_40="${ret_get_visible_len2138_v0}"
                    remaining_width_12948="$(( remaining_width_12948 - ret_get_visible_len2138_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_12950}" == "_" ]; echo $?) && $(( remaining_width_12948 > 0 )) ))" != 0 ]; then
                    truncate_text__2139_v0 "${part_12950}" "${remaining_width_12948}"
                    local ret_truncate_text2139_v0__225_39="${ret_truncate_text2139_v0}"
                    local truncated_12958="${ret_truncate_text2139_v0__225_39}"
                    result_12947+="${truncated_12958}"
                    get_visible_len__2138_v0 "${truncated_12958}"
                    local ret_get_visible_len2138_v0__227_40="${ret_get_visible_len2138_v0}"
                    remaining_width_12948="$(( remaining_width_12948 - ret_get_visible_len2138_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2140_v0="${result_12947}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2141_v0() {
    local text_12923="${1}"
    local max_width_12924="${2}"
    get_visible_len__2138_v0 "${text_12923}"
    local visible_len_12933="${ret_get_visible_len2138_v0}"
    if [ "$(( visible_len_12933 <= max_width_12924 ))" != 0 ]; then
        ret_cutoff_text2141_v0="${text_12923}"
        return 0
    fi
    truncate_ansi__2140_v0 "${text_12923}" "$(( max_width_12924 - 3 ))"
    local ret_truncate_ansi2140_v0__243_12="${ret_truncate_ansi2140_v0}"
    ret_cutoff_text2141_v0="${ret_truncate_ansi2140_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2142_v0() {
    local items_12965=("${!1}")
    local total_len_12966="${2}"
    local term_width_12967="${3}"
    local separator_12968=" • "
    local separator_len_12969=3
    # Fast path: no truncation needed
    if [ "$(( total_len_12966 <= term_width_12967 ))" != 0 ]; then
        local iter_12970=0
        while :
        do
            local __length_391=("${items_12965[@]}")
            if [ "$(( iter_12970 >= ${#__length_391[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_12970 > 0 ))" != 0 ]; then
                eprintf_colored__2122_v0 "${separator_12968}" 90
            fi
            colored__2123_v0 "${items_12965[$(( iter_12970 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2123_v0__268_41="${ret_colored2123_v0}"
            local array_392=("")
            eprintf__2121_v0 "${items_12965[${iter_12970}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2123_v0__268_41}" array_392[@]
            iter_12970="$(( iter_12970 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_12973=0
        local first_12974=1
        local iter_12975=0
        while :
        do
            local __length_393=("${items_12965[@]}")
            if [ "$(( iter_12975 >= ${#__length_393[@]} ))" != 0 ]; then
                break
            fi
            local key_12976="${items_12965[${iter_12975}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_12977="${items_12965[$(( iter_12975 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_394="${key_12976}"
            local __length_395="${action_12977}"
            local part_len_12978="$(( $(( ${#__length_394} + 1 )) + ${#__length_395} ))"
            local needed_12979="${part_len_12978}"
            if [ "$(( ! first_12974 ))" != 0 ]; then
                needed_12979="$(( needed_12979 + separator_len_12969 ))"
            fi
            if [ "$(( $(( current_len_12973 + needed_12979 )) > term_width_12967 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_12974 ))" != 0 ]; then
                eprintf_colored__2122_v0 "${separator_12968}" 90
            fi
            colored__2123_v0 "${action_12977}" 2
            local ret_colored2123_v0__296_33="${ret_colored2123_v0}"
            local array_396=("")
            eprintf__2121_v0 "${key_12976}"" ""${ret_colored2123_v0__296_33}" array_396[@]
            current_len_12973="$(( current_len_12973 + needed_12979 ))"
            first_12974=0
            iter_12975="$(( iter_12975 + 2 ))"
        done
    fi
}

# get_page_options(options: [Text], page: Int, page_size: Int)
get_page_options__2192_v0() {
    local options_12981=("${!1}")
    local page_12982="${2}"
    local page_size_12983="${3}"
    local start_12984="$(( page_12982 * page_size_12983 ))"
    local end_12985="$(( start_12984 + page_size_12983 ))"
    local __length_397=("${options_12981[@]}")
    if [ "$(( end_12985 > ${#__length_397[@]} ))" != 0 ]; then
        local __length_398=("${options_12981[@]}")
        end_12985="${#__length_398[@]}"
    fi
    local result_12986=()
    local __range_start_12987="${start_12984}"
    local __range_end_12987="${end_12985}"
    local __dir_12987=$(( ${__range_start_12987} <= ${__range_end_12987} ? 1 : -1 ))
    for (( i_12987=${__range_start_12987}; i_12987 * ${__dir_12987} < ${__range_end_12987} * ${__dir_12987}; i_12987+=${__dir_12987} )); do
        local array_400=("${options_12981[${i_12987}]?"Index out of bounds (at src/./file/../choose/mod.ab:13:28)"}")
        result_12986+=("${array_400[@]}")
done
    ret_get_page_options2192_v0=("${result_12986[@]}")
    return 0
}

# render_choose_page(page_options: [Text], sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_choose_page__2194_v0() {
    local page_options_12989=("${!1}")
    local sel_12990="${2}"
    local cursor_12991="${3}"
    local display_count_12992="${4}"
    local term_width_12993="${5}"
    local __length_401="${cursor_12991}"
    local cursor_len_12994="${#__length_401}"
    local max_option_width_12995="$(( $(( term_width_12993 - cursor_len_12994 )) - 1 ))"
    local __range_start_12996=0
    local __length_402=("${page_options_12989[@]}")
    local __range_end_12996="${#__length_402[@]}"
    local __dir_12996=$(( ${__range_start_12996} <= ${__range_end_12996} ? 1 : -1 ))
    for (( i_12996=${__range_start_12996}; i_12996 * ${__dir_12996} < ${__range_end_12996} * ${__dir_12996}; i_12996+=${__dir_12996} )); do
        cutoff_text__2141_v0 "${page_options_12989[${i_12996}]?"Index out of bounds (at src/./file/../choose/mod.ab:26:59)"}" "${max_option_width_12995}"
        local ret_cutoff_text2141_v0__26_34="${ret_cutoff_text2141_v0}"
        local truncated_option_12997="${ret_cutoff_text2141_v0__26_34}"
        if [ "$(( i_12996 == sel_12990 ))" != 0 ]; then
            colored_secondary__2104_v0 "${cursor_12991}""${truncated_option_12997}""
"
            local ret_colored_secondary2104_v0__28_21="${ret_colored_secondary2104_v0}"
            local array_403=("")
            eprintf__2121_v0 "${ret_colored_secondary2104_v0__28_21}" array_403[@]
        else
            print_blank__2127_v0 "${cursor_len_12994}"
            local array_404=("")
            eprintf__2121_v0 "${truncated_option_12997}""
" array_404[@]
        fi
done
    local __length_405=("${page_options_12989[@]}")
    local remaining_slots_13013="$(( display_count_12992 - ${#__length_405[@]} ))"
    if [ "$(( remaining_slots_13013 > 0 ))" != 0 ]; then
        # Amber bug gaurd
        local __range_start_13014=0
        local __range_end_13014="${remaining_slots_13013}"
        local __dir_13014=$(( ${__range_start_13014} <= ${__range_end_13014} ? 1 : -1 ))
        for (( ____13014=${__range_start_13014}; ____13014 * ${__dir_13014} < ${__range_end_13014} * ${__dir_13014}; ____13014+=${__dir_13014} )); do
            local array_406=("")
            eprintf__2121_v0 "\\x1b[K
" array_406[@]
done
    fi
}

# render_page_indicator(page: Int, total_pages: Int)
render_page_indicator__2196_v0() {
    local page_13024="${1}"
    local total_pages_13025="${2}"
    if [ "$(( total_pages_13025 > 1 ))" != 0 ]; then
        local array_407=("")
        eprintf__2121_v0 "\\x1b[G\\x1b[K" array_407[@]
        eprintf_colored__2122_v0 "Page $(( page_13024 + 1 ))/${total_pages_13025}" 90
        local array_408=("")
        eprintf__2121_v0 "\\x1b[G" array_408[@]
    fi
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__2197_v0() {
    local options_12905=("${!1}")
    local cursor_12906="${2}"
    local header_12907="${3}"
    local page_size_12908="${4}"
    local __length_409=("${options_12905[@]}")
    if [ "$(( ${#__length_409[@]} == 0 ))" != 0 ]; then
        eprintf_colored__2122_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__2080_v0 
    hide_cursor__2132_v0 
    term_width__2087_v0 
    local term_width_12920="${ret_term_width2087_v0}"
    term_height__2088_v0 
    local term_height_12921="${ret_term_height2088_v0}"
    local max_page_size_12922
    max_page_size_12922="$(( term_height_12921 - $(if [ "$([ "_${header_12907}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_12908 > max_page_size_12922 ))" != 0 ]; then
        page_size_12908="${max_page_size_12922}"
    fi
    if [ "$([ "_${header_12907}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2141_v0 "${header_12907}" "${term_width_12920}"
        local ret_cutoff_text2141_v0__107_17="${ret_cutoff_text2141_v0}"
        local array_410=("")
        eprintf__2121_v0 "${ret_cutoff_text2141_v0__107_17}""
" array_410[@]
    fi
    local __length_411=("${options_12905[@]}")
    math_floor__504_v0 "$(( $(( $(( ${#__length_411[@]} + page_size_12908 )) - 1 )) / page_size_12908 ))"
    local total_pages_12959="${ret_math_floor504_v0}"
    local current_page_12960=0
    local selected_12961=0
    local display_count_12962="${page_size_12908}"
    local __length_412=("${options_12905[@]}")
    if [ "$(( ${#__length_412[@]} < page_size_12908 ))" != 0 ]; then
        local __length_413=("${options_12905[@]}")
        display_count_12962="${#__length_413[@]}"
    fi
    new_line__2128_v0 "${display_count_12962}"
    local array_414=("")
    eprintf__2121_v0 "\\x1b[G" array_414[@]
    if [ "$(( total_pages_12959 > 1 ))" != 0 ]; then
        eprintf_colored__2122_v0 "Page $(( current_page_12960 + 1 ))/${total_pages_12959}" 90
    fi
    new_line__2128_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( total_pages_12959 > 1 ))" != 0 ]; then
        local array_415=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__2142_v0 array_415[@] 36 "${term_width_12920}"
    else
        local array_416=("↑↓" "select" "enter" "confirm")
        render_tooltip__2142_v0 array_416[@] 25 "${term_width_12920}"
    fi
    go_up__2129_v0 "$(( display_count_12962 + 1 ))"
    local array_417=("")
    eprintf__2121_v0 "\\x1b[G" array_417[@]
    get_page_options__2192_v0 options_12905[@] "${current_page_12960}" "${page_size_12908}"
    local page_options_12988=("${ret_get_page_options2192_v0[@]}")
    render_choose_page__2194_v0 page_options_12988[@] "${selected_12961}" "${cursor_12906}" "${display_count_12962}" "${term_width_12920}"
    while :
    do
        get_key__2119_v0 
        local key_13016="${ret_get_key2119_v0}"
        local prev_selected_13017="${selected_12961}"
        local prev_page_13018="${current_page_12960}"
        local up_paged_13019=0
        if [ "$(( $([ "_${key_13016}" != "_UP" ]; echo $?) || $([ "_${key_13016}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_12961 == 0 )) && $(( total_pages_12959 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_12960 > 0 ))" != 0 ]; then
                    current_page_12960="$(( current_page_12960 - 1 ))"
                else
                    current_page_12960="$(( total_pages_12959 - 1 ))"
                fi
                up_paged_13019=1
            elif [ "$(( selected_12961 == 0 ))" != 0 ]; then
                local __length_418=("${page_options_12988[@]}")
                selected_12961="$(( ${#__length_418[@]} - 1 ))"
            else
                selected_12961="$(( selected_12961 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_13016}" != "_DOWN" ]; echo $?) || $([ "_${key_13016}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_419=("${page_options_12988[@]}")
            if [ "$(( selected_12961 == $(( ${#__length_419[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_12960 < $(( total_pages_12959 - 1 )) ))" != 0 ]; then
                    current_page_12960="$(( current_page_12960 + 1 ))"
                    selected_12961=0
                else
                    current_page_12960=0
                    selected_12961=0
                fi
            else
                selected_12961="$(( selected_12961 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_13016}" != "_LEFT" ]; echo $?) || $([ "_${key_13016}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_12960 > 0 ))" != 0 ]; then
                current_page_12960="$(( current_page_12960 - 1 ))"
                selected_12961=0
            else
                selected_12961=0
            fi
        elif [ "$(( $([ "_${key_13016}" != "_RIGHT" ]; echo $?) || $([ "_${key_13016}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_12960 < $(( total_pages_12959 - 1 )) ))" != 0 ]; then
                current_page_12960="$(( current_page_12960 + 1 ))"
                selected_12961=0
            else
                local __length_420=("${page_options_12988[@]}")
                selected_12961="$(( ${#__length_420[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_13016}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_421="${cursor_12906}"
        local max_option_width_13020="$(( $(( term_width_12920 - ${#__length_421} )) - 1 ))"
        if [ "$(( prev_page_13018 != current_page_12960 ))" != 0 ]; then
            get_page_options__2192_v0 options_12905[@] "${current_page_12960}" "${page_size_12908}"
            page_options_12988=("${ret_get_page_options2192_v0[@]}")
            if [ "${up_paged_13019}" != 0 ]; then
                local __length_422=("${page_options_12988[@]}")
                selected_12961="$(( ${#__length_422[@]} - 1 ))"
            fi
            go_up__2129_v0 1
            remove_line__2125_v0 "$(( display_count_12962 - 1 ))"
            remove_current_line__2126_v0 
            local array_423=("")
            eprintf__2121_v0 "\\x1b[G" array_423[@]
            render_choose_page__2194_v0 page_options_12988[@] "${selected_12961}" "${cursor_12906}" "${display_count_12962}" "${term_width_12920}"
            render_page_indicator__2196_v0 "${current_page_12960}" "${total_pages_12959}"
        elif [ "$(( prev_selected_13017 != selected_12961 ))" != 0 ]; then
            go_up__2129_v0 "$(( display_count_12962 - prev_selected_13017 ))"
            local array_424=("")
            eprintf__2121_v0 "\\x1b[K" array_424[@]
            local __length_425="${cursor_12906}"
            print_blank__2127_v0 "${#__length_425}"
            cutoff_text__2141_v0 "${page_options_12988[${prev_selected_13017}]?"Index out of bounds (at src/./file/../choose/mod.ab:218:50)"}" "${max_option_width_13020}"
            local ret_cutoff_text2141_v0__218_25="${ret_cutoff_text2141_v0}"
            local array_426=("")
            eprintf__2121_v0 "${ret_cutoff_text2141_v0__218_25}" array_426[@]
            local diff_13026="$(( selected_12961 - prev_selected_13017 ))"
            go_up_or_down__2131_v0 "${diff_13026}"
            local array_427=("")
            eprintf__2121_v0 "\\x1b[G" array_427[@]
            local array_428=("")
            eprintf__2121_v0 "\\x1b[K" array_428[@]
            cutoff_text__2141_v0 "${page_options_12988[${selected_12961}]?"Index out of bounds (at src/./file/../choose/mod.ab:224:77)"}" "${max_option_width_13020}"
            local ret_cutoff_text2141_v0__224_52="${ret_cutoff_text2141_v0}"
            colored_secondary__2104_v0 "${cursor_12906}""${ret_cutoff_text2141_v0__224_52}"
            local ret_colored_secondary2104_v0__224_25="${ret_colored_secondary2104_v0}"
            local array_429=("")
            eprintf__2121_v0 "${ret_colored_secondary2104_v0__224_25}" array_429[@]
            go_down__2130_v0 "$(( display_count_12962 - selected_12961 ))"
            local array_430=("")
            eprintf__2121_v0 "\\x1b[G" array_430[@]
        fi
    done
    local total_lines_13029="$(( display_count_12962 + 2 ))"
    if [ "$([ "_${header_12907}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_13029="$(( total_lines_13029 + 1 ))"
    fi
    go_down__2130_v0 1
    remove_line__2125_v0 "$(( total_lines_13029 - 1 ))"
    remove_current_line__2126_v0 
    stty_unlock__2081_v0 
    show_cursor__2133_v0 
    local global_selected_13032="$(( $(( current_page_12960 * page_size_12908 )) + selected_12961 ))"
    ret_xyl_choose2197_v0="${options_12905[${global_selected_13032}]?"Index out of bounds (at src/./file/../choose/mod.ab:244:20)"}"
    return 0
}

# format_entry_display(entry: [Text])
format_entry_display__2201_v0() {
    local entry_12898=("${!1}")
    local name_12899="${entry_12898[0]?"Index out of bounds (at src/./file/./mod.ab:10:24)"}"
    local file_type_12900="${entry_12898[1]?"Index out of bounds (at src/./file/./mod.ab:11:29)"}"
    if [ "$([ "_${file_type_12900}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1882_v0 "/"
        local ret_colored_primary1882_v0__14_23="${ret_colored_primary1882_v0}"
        ret_format_entry_display2201_v0="${name_12899}""${ret_colored_primary1882_v0__14_23}"
        return 0
    fi
    if [ "$([ "_${file_type_12900}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1884_v0 " > "
        local ret_colored_accent1884_v0__17_23="${ret_colored_accent1884_v0}"
        colored_primary__1882_v0 "${entry_12898[2]?"Index out of bounds (at src/./file/./mod.ab:17:69)"}"
        local ret_colored_primary1882_v0__17_47="${ret_colored_primary1882_v0}"
        ret_format_entry_display2201_v0="${name_12899}""${ret_colored_accent1884_v0__17_23}""${ret_colored_primary1882_v0__17_47}"
        return 0
    fi
    ret_format_entry_display2201_v0="${name_12899}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2202_v0() {
    local start_path_12872="${1}"
    local cursor_12873="${2}"
    local show_hidden_12874="${3}"
    local page_size_12875="${4}"
    stty_lock__1859_v0 
    # Initialize current path
    local current_path_12878="${start_path_12872}"
    if [ "$([ "_${current_path_12878}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1839_v0 
        current_path_12878="${ret_get_cwd1839_v0}"
    fi
    normalize_path__1840_v0 "${current_path_12878}"
    current_path_12878="${ret_normalize_path1840_v0}"
    while :
    do
        colored_primary__1882_v0 "Loading files..."
        local ret_colored_primary1882_v0__45_17="${ret_colored_primary1882_v0}"
        local array_431=("")
        eprintf__1900_v0 "${ret_colored_primary1882_v0__45_17}" array_431[@]
        # Get directory entries
        get_directory_entries__1837_v0 "${current_path_12878}"
        local raw_entries_12891=("${ret_get_directory_entries1837_v0[@]}")
        # Build options list and parallel entries list
        local options_12892=()
        local entries_12893=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_12878}" == "_/" ]; echo $?)" != 0 ]; then
            options_12892+=("..")
            entries_12893+=("..	d")
        fi
        for raw_entry_12894 in "${raw_entries_12891[@]}"; do
            parse_entry__1838_v0 "${raw_entry_12894}"
            local entry_12896=("${ret_parse_entry1838_v0[@]}")
            local name_12897="${entry_12896[0]?"Index out of bounds (at src/./file/./mod.ab:62:32)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_12897}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_12874 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            format_entry_display__2201_v0 entry_12896[@]
            local ret_format_entry_display2201_v0__67_25="${ret_format_entry_display2201_v0}"
            options_12892+=("${ret_format_entry_display2201_v0__67_25}")
            entries_12893+=("${raw_entry_12894}")
        done
        local __length_440=("${entries_12893[@]}")
        if [ "$(( ${#__length_440[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1901_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1860_v0 
            ret_xyl_file2202_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1882_v0 "${current_path_12878}"
        local header_12904="${ret_colored_primary1882_v0}"
        remove_current_line__1905_v0 
        xyl_choose__2197_v0 options_12892[@] "${cursor_12873}" "${header_12904}" "${page_size_12875}"
        local selected_option_13033="${ret_xyl_choose2197_v0}"
        # Find selected entry index
        array_find__67_v0 options_12892[@] "${selected_option_13033}"
        local selected_idx_13038="${ret_array_find67_v0}"
        if [ "$(( selected_idx_13038 < 0 ))" != 0 ]; then
            ret_xyl_file2202_v0=""
            return 0
        fi
        parse_entry__1838_v0 "${entries_12893[${selected_idx_13038}]?"Index out of bounds (at src/./file/./mod.ab:90:43)"}"
        local entry_13039=("${ret_parse_entry1838_v0[@]}")
        local name_13040="${entry_13039[0]?"Index out of bounds (at src/./file/./mod.ab:91:28)"}"
        local file_type_13041="${entry_13039[1]?"Index out of bounds (at src/./file/./mod.ab:92:33)"}"
        if [ "$([ "_${name_13040}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1842_v0 "${current_path_12878}"
            current_path_12878="${ret_get_parent_dir1842_v0}"
        elif [ "$([ "_${file_type_13041}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1841_v0 "${current_path_12878}" "${name_13040}"
            current_path_12878="${ret_path_join1841_v0}"
            normalize_path__1840_v0 "${current_path_12878}"
            current_path_12878="${ret_normalize_path1840_v0}"
        elif [ "$([ "_${file_type_13041}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_13046="${entry_13039[2]?"Index out of bounds (at src/./file/./mod.ab:104:38)"}"
            local target_path_13047="${target_13046}"
            starts_with__22_v0 "${target_13046}" "/"
            local ret_starts_with22_v0__106_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__106_24 ))" != 0 ]; then
                path_join__1841_v0 "${current_path_12878}" "${target_13046}"
                target_path_13047="${ret_path_join1841_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_13047}"
            local ret_dir_exists38_v0__110_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__110_20}" != 0 ]; then
                current_path_12878="${target_path_13047}"
                normalize_path__1840_v0 "${current_path_12878}"
                current_path_12878="${ret_normalize_path1840_v0}"
            else
                stty_unlock__1860_v0 
                path_join__1841_v0 "${current_path_12878}" "${name_13040}"
                ret_xyl_file2202_v0="${ret_path_join1841_v0}"
                return 0
            fi
        else
            stty_unlock__1860_v0 
            path_join__1841_v0 "${current_path_12878}" "${name_13040}"
            ret_xyl_file2202_v0="${ret_path_join1841_v0}"
            return 0
        fi
    done
    stty_unlock__1860_v0 
    ret_xyl_file2202_v0=""
    return 0
}

# print_file_help()
print_file_help__2295_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    printf '%s\n' ""
    colored_primary__1882_v0 "file"
    local ret_colored_primary1882_v0__7_12="${ret_colored_primary1882_v0}"
    local array_441=()
    printf__128_v1 "${ret_colored_primary1882_v0__7_12}" array_441[@]
    local array_442=()
    printf__128_v1 " - Browse filesystem and select a file." array_442[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1883_v0 "Arguments: "
    local ret_colored_secondary1883_v0__11_12="${ret_colored_secondary1883_v0}"
    local array_443=()
    printf__128_v1 "${ret_colored_secondary1883_v0__11_12}""
" array_443[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    printf '%s\n' ""
    colored_secondary__1883_v0 "Flags: "
    local ret_colored_secondary1883_v0__14_12="${ret_colored_secondary1883_v0}"
    local array_444=()
    printf__128_v1 "${ret_colored_secondary1883_v0__14_12}""
" array_444[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2346_v0() {
    local parameters_12846=("${!1}")
    local cursor_12847="> "
    local start_path_12848=""
    local show_hidden_12849=0
    local page_size_12850=10
    local __length_448=("${parameters_12846[@]}")
    local slice_upper_447="${#__length_448[@]}"
    local slice_offset_449=2
    local slice_offset_449=$((${slice_offset_449} > 0 ? ${slice_offset_449} : 0))
    local slice_length_450="$(( slice_upper_447 - slice_offset_449 ))"
    local slice_length_450=$((${slice_length_450} > 0 ? ${slice_length_450} : 0))
    for param_12851 in "${parameters_12846[@]:${slice_offset_449}:${slice_length_450}}"; do
        starts_with__22_v0 "${param_12851}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_12851}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_12851}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_12851}" != "_-h" ]; echo $?) || $([ "_${param_12851}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2295_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_451="--cursor="
            slice__24_v0 "${param_12851}" "${#__length_451}" 0
            cursor_12847="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_452="--path="
            slice__24_v0 "${param_12851}" "${#__length_452}" 0
            start_path_12848="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_12851}" != "_-a" ]; echo $?) || $([ "_${param_12851}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_12849=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_453="--page-size="
            slice__24_v0 "${param_12851}" "${#__length_453}" 0
            local value_12867="${ret_slice24_v0}"
            parse_int__13_v0 "${value_12867}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1901_v0 "ERROR: Invalid page-size value: ""${value_12867}""
" 31
                exit 1
            fi
            page_size_12850="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_12848="${param_12851}"
        fi
    done
    xyl_file__2202_v0 "${start_path_12848}" "${cursor_12847}" "${show_hidden_12849}" "${page_size_12850}"
    ret_execute_file2346_v0="${ret_xyl_file2202_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_57="0.1.0"
__AMBER_VERSION_58="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2348_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__261_v0 "Error: " 91
        local array_454=("")
        eprintf__260_v0 "bc is not installed. Please install bc to use xylitol.
" array_454[@]
        local array_455=("")
        eprintf__260_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_455[@]
        local array_456=("")
        eprintf__260_v0 "  For Fedora: sudo dnf install bc
" array_456[@]
        local array_457=("")
        eprintf__260_v0 "  For Arch Linux: sudo pacman -S bc
" array_457[@]
        ret_check_prerequirements2348_v0=0
        return 0
    fi
    ret_check_prerequirements2348_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2349_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_59=("$0" "$@")
trap_cleanup__2349_v0 
check_prerequirements__2348_v0 
ret_check_prerequirements2348_v0__32_12="${ret_check_prerequirements2348_v0}"
if [ "$(( ! ret_check_prerequirements2348_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_459=("${args_59[@]}")
if [ "$(( ${#__length_459[@]} < 2 ))" != 0 ]; then
    print_help__423_v0 
    exit 0
fi
command_664="${args_59[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_664}" != "_help" ]; echo $?) || $([ "_${command_664}" != "_--help" ]; echo $?) )) || $([ "_${command_664}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__423_v0 
elif [ "$([ "_${command_664}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__830_v0 args_59[@]
    ret_execute_input830_v0__48_18="${ret_execute_input830_v0}"
    printf '%s\n' "${ret_execute_input830_v0__48_18}"
elif [ "$([ "_${command_664}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1241_v0 args_59[@]
    ret_execute_choose1241_v0__51_18="${ret_execute_choose1241_v0}"
    printf '%s\n' "${ret_execute_choose1241_v0__51_18}"
elif [ "$([ "_${command_664}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1682_v0 args_59[@]
    result_9152="${ret_execute_confirm1682_v0}"
    if [ "$([ "_${result_9152}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_664}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2346_v0 args_59[@]
    ret_execute_file2346_v0__61_18="${ret_execute_file2346_v0}"
    printf '%s\n' "${ret_execute_file2346_v0__61_18}"
elif [ "$(( $(( $([ "_${command_664}" != "_version" ]; echo $?) || $([ "_${command_664}" != "_--version" ]; echo $?) )) || $([ "_${command_664}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__242_v0 "xylitol.sh"
    ret_colored_primary242_v0__64_20="${ret_colored_primary242_v0}"
    array_460=()
    printf__128_v1 "${ret_colored_primary242_v0__64_20}" array_460[@]
    array_461=()
    printf__128_v1 " version: " array_461[@]
    colored_accent__244_v0 "${__VERSION_57}"
    ret_colored_accent244_v0__66_20="${ret_colored_accent244_v0}"
    array_462=()
    printf__128_v1 "${ret_colored_accent244_v0__66_20}" array_462[@]
    printf '%s\n' ""
    printf_colored__259_v0 "written in Amber: " 90
    printf_colored__259_v0 "  ""${__AMBER_VERSION_58}" 90
else
    print_help__423_v0 
    printf_colored__259_v0 "ERROR: Unknown command '""${command_664}""'" 91
fi
