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
    local text_683="${1}"
    local delimiter_684="${2}"
    local result_685=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_684}" read -rd '' -A result_685 < <(printf %s "$text_683")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_684}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_685+=("$REPLY"); done < <(echo "$text_683")
            __status=$?
        else
            IFS="${delimiter_684}" read -rd '' -a result_685 < <(printf %s "$text_683")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_684}" read -rd '' -a result_685 < <(printf %s "$text_683")
        __status=$?
    fi
    ret_split4_v0=("${result_685[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_13422=("${!1}")
    local delimiter_13423="${2}"
    local command_1
    command_1="$(IFS="${delimiter_13423}" ; printf "%s
" "${list_13422[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_687="${1}"
    [ -n "${text_687}" ] && [ "${text_687}" -eq "${text_687}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_687}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_1705="${1}"
    local prefix_1706="${2}"
    [[ "${text_1705}" == "${prefix_1706}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1707="${1}"
    local index_1708="${2}"
    local length_1709="${3}"
    local result_1710=""
    if [ "$(( length_1709 == 0 ))" != 0 ]; then
        local __length_2="${text_1707}"
        length_1709="$(( ${#__length_2} - index_1708 ))"
    fi
    if [ "$(( length_1709 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1710}"
        return 0
    fi
    result_1710="${text_1707: ${index_1708}: ${length_1709}}"
    __status=$?
    ret_slice24_v0="${result_1710}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_15046="${1}"
    local pad_15047="${2}"
    local length_15048="${3}"
    local __length_3="${text_15046}"
    if [ "$(( length_15048 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_15046}"
        return 0
    fi
    local __length_4="${text_15046}"
    local pad_len_15049="$(( length_15048 - ${#__length_4} ))"
    local padding_15050=""
    printf -v padding_15050 "%${pad_len_15049}s" ""
    __status=$?
    padding_15050="${padding_15050// /${pad_15047}}"
    __status=$?
    ret_lpad27_v0="${padding_15050}""${text_15046}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_15052="${1}"
    local pad_15053="${2}"
    local length_15054="${3}"
    local __length_5="${text_15052}"
    if [ "$(( length_15054 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_15052}"
        return 0
    fi
    local __length_6="${text_15052}"
    local pad_len_15055="$(( length_15054 - ${#__length_6} ))"
    local padding_15056=""
    printf -v padding_15056 "%${pad_len_15055}s" ""
    __status=$?
    padding_15056="${padding_15056// /${pad_15053}}"
    __status=$?
    ret_rpad28_v0="${text_15052}""${padding_15056}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_15040="${1}"
    local pad_15041="${2}"
    local length_15042="${3}"
    local __length_7="${text_15040}"
    local text_length_15043="${#__length_7}"
    if [ "$(( length_15042 <= text_length_15043 ))" != 0 ]; then
        ret_cpad29_v0="${text_15040}"
        return 0
    fi
    local total_padding_15044="$(( length_15042 - text_length_15043 ))"
    local left_padding_length_15045="$(( text_length_15043 + $(( total_padding_15044 / 2 )) ))"
    lpad__27_v0 "${text_15040}" "${pad_15041}" "${left_padding_length_15045}"
    local left_padded_15051="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_15051}" "${pad_15041}" "${length_15042}"
    local center_padded_15057="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_15057}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_23258="${1}"
    [ -d "${path_23258}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_681="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_681}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_8}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        local command_9
        command_9="$(printf "%s
" "${(P)name_681}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_681}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_10}"
        return 0
    fi
}

# printf(format: Text, args: [Text])
printf__128_v0() {
    local format_695="${1}"
    local args_696=("${!2}")
    args_696=("${format_695}" "${args_696[@]}")
    __status=$?
    printf "${args_696[@]}"
    __status=$?
}

# printf(format: Text, args: [])
printf__128_v1() {
    local format_704="${1}"
    local args_705=("${!2}")
    args_705=("${format_704}" "${args_705[@]}")
    __status=$?
    printf "${args_705[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_692="${1}"
    local color_693="${2}"
    local color_code_694=0
        color_code_694="${color_693}"
    local array_11=("${message_692}")
    printf__128_v0 "\\x1b[${color_code_694}m%s\\x1b[0m
" array_11[@]
}

# Perl Extensions Utilities
command_12="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_3="$([ "_${command_12}" != "_No" ]; echo $?)"
command_13="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_4="$(( $(( ! _perl_disabled_3 )) && $([ "_${command_13}" != "_0" ]; echo $?) ))"
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
get_supports_truecolor__236_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_702="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_702}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor236_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor236_v0=0
        return 0
    fi
    local colorterm_703="${ret_env_var_get120_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_703}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_703}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor236_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__237_v0() {
    local message_697="${1}"
    local r_698="${2}"
    local g_699="${3}"
    local b_700="${4}"
    local fallback_701="${5}"
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb237_v0="\\x1b[38;2;${r_698};${g_699};${b_700}m""${message_697}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__236_v0 
        local ret_get_supports_truecolor236_v0__50_17="${ret_get_supports_truecolor236_v0}"
        if [ "${ret_get_supports_truecolor236_v0__50_17}" != 0 ]; then
            ret_colored_rgb237_v0="\\x1b[38;2;${r_698};${g_699};${b_700}m""${message_697}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_701 == 0 ))" != 0 ]; then
            ret_colored_rgb237_v0="${message_697}"
            return 0
        else
            ret_colored_rgb237_v0="\\x1b[${fallback_701}m""${message_697}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_701 == 0 ))" != 0 ]; then
            ret_colored_rgb237_v0="${message_697}"
            return 0
        fi
        ret_colored_rgb237_v0="\\x1b[${fallback_701}m""${message_697}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__239_v0() {
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_682="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_682}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_682}" ";"
            local parts_686=("${ret_split4_v0[@]}")
            local __length_18=("${parts_686[@]}")
            if [ "$(( ${#__length_18[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_686[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_686[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_686[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_686[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
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
        local secondary_env_688="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_688}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_688}" ";"
            local parts_689=("${ret_split4_v0[@]}")
            local __length_20=("${parts_689[@]}")
            if [ "$(( ${#__length_20[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_689[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_689[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_689[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_689[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
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
        local accent_env_690="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_690}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_690}" ";"
            local parts_691=("${ret_split4_v0[@]}")
            local __length_22=("${parts_691[@]}")
            if [ "$(( ${#__length_22[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_691[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_691[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_691[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_691[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
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
get_xylitol_colors__240_v0() {
    inner_get_xylitol_colors__239_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_8=1
}

# colored_primary(message: Text)
colored_primary__241_v0() {
    local message_680="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__240_v0 
    fi
    colored_rgb__237_v0 "${message_680}" "${_primary_color_9[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_9[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_9[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_9[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary241_v0="${ret_colored_rgb237_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__242_v0() {
    local message_706="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__240_v0 
    fi
    colored_rgb__237_v0 "${message_706}" "${_secondary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary242_v0="${ret_colored_rgb237_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__243_v0() {
    local message_709="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__240_v0 
    fi
    colored_rgb__237_v0 "${message_709}" "${_accent_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent243_v0="${ret_colored_rgb237_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__258_v0() {
    local message_23261="${1}"
    local color_23262="${2}"
    # Prints a text with a specified color.
    local array_24=("${message_23261}")
    printf__128_v0 "\\x1b[${color_23262}m%s\\x1b[0m" array_24[@]
}

# eprintf(format: Text, args: [Text])
eprintf__259_v0() {
    local format_126="${1}"
    local args_127=("${!2}")
    args_127=("${format_126}" "${args_127[@]}")
    __status=$?
    printf "${args_127[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__260_v0() {
    local message_124="${1}"
    local color_125="${2}"
    # Prints an error message with a specified color.
    local array_25=("${message_124}")
    eprintf__259_v0 "\\x1b[${color_125}m%s\\x1b[0m" array_25[@]
}

# colored(message: Text, color: Int)
colored__261_v0() {
    local message_707="${1}"
    local color_708="${2}"
    # Returns a text wrapped in color codes.
    ret_colored261_v0="\\x1b[${color_708}m""${message_707}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# print_help()
print_help__420_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    printf '%s\n' ""
    colored_primary__241_v0 "Xylitol"
    local ret_colored_primary241_v0__7_24="${ret_colored_primary241_v0}"
    local array_26=()
    printf__128_v1 "\\x1b[1m""${ret_colored_primary241_v0__7_24}" array_26[@]
    local array_27=()
    printf__128_v1 " - A tool for " array_27[@]
    colored_primary__241_v0 "fresh"
    local ret_colored_primary241_v0__9_12="${ret_colored_primary241_v0}"
    local array_28=()
    printf__128_v1 "${ret_colored_primary241_v0__9_12}" array_28[@]
    local array_29=()
    printf__128_v1 " shell scripts." array_29[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__242_v0 "Flags: "
    local ret_colored_secondary242_v0__13_12="${ret_colored_secondary242_v0}"
    local array_30=()
    printf__128_v1 "${ret_colored_secondary242_v0__13_12}""
" array_30[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    printf '%s\n' ""
    colored_secondary__242_v0 "Commands: "
    local ret_colored_secondary242_v0__17_12="${ret_colored_secondary242_v0}"
    local array_31=()
    printf__128_v1 "${ret_colored_secondary242_v0__17_12}""
" array_31[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    printf '%s\n' ""
    colored_secondary__242_v0 "Envs: "
    local ret_colored_secondary242_v0__23_12="${ret_colored_secondary242_v0}"
    local array_32=()
    printf__128_v1 "${ret_colored_secondary242_v0__23_12}""
" array_32[@]
    colored__261_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored261_v0__24_78="${ret_colored261_v0}"
    local array_33=()
    printf__128_v1 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored261_v0__24_78}""
" array_33[@]
    colored__261_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored261_v0__25_78="${ret_colored261_v0}"
    local array_34=()
    printf__128_v1 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored261_v0__25_78}""
" array_34[@]
    colored__261_v0 "(default: 3;207;159;92)" 90
    local ret_colored261_v0__26_68="${ret_colored261_v0}"
    local array_35=()
    printf__128_v1 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored261_v0__26_68}""
" array_35[@]
    colored__261_v0 "(default: 3;118;206;94)" 90
    local ret_colored261_v0__27_70="${ret_colored261_v0}"
    local array_36=()
    printf__128_v1 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored261_v0__27_70}""
" array_36[@]
    colored__261_v0 "(default: 234;72;121;95)" 90
    local ret_colored261_v0__28_67="${ret_colored261_v0}"
    local array_37=()
    printf__128_v1 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored261_v0__28_67}""
" array_37[@]
    printf '%s\n' ""
    colored_accent__243_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent243_v0__30_21="${ret_colored_accent243_v0}"
    local array_38=()
    printf__128_v1 "Run ""${ret_colored_accent243_v0__30_21}"" for more information on a command.
" array_38[@]
}

# math_floor(number: Int)
math_floor__501_v0() {
    local number_1791="${1}"
    local command_39
    command_39="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_1791}")"
    __status=$?
    ret_math_floor501_v0="${command_39}"
    return 0
}

# math_ceil(number: Int)
math_ceil__502_v0() {
    local number_1790="${1}"
    math_floor__501_v0 "${number_1790}"
    local ret_math_floor501_v0__52_12="${ret_math_floor501_v0}"
    ret_math_ceil502_v0="$(( ret_math_floor501_v0__52_12 + 1 ))"
    return 0
}

# Perl Extensions Utilities
command_40="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_12="$([ "_${command_40}" != "_No" ]; echo $?)"
command_41="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_13="$(( $(( ! _perl_disabled_12 )) && $([ "_${command_41}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__562_v0() {
    local text_1734="${1}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_get_cjk_width562_v0=''
        return 1
    fi
    local command_42
    command_42="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1734}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width562_v0=''
        return "${__status}"
    fi
    local width_str_1735="${command_42}"
    parse_int__13_v0 "${width_str_1735}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width562_v0=''
        return "${__status}"
    fi
    local width_1736="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width562_v0="${width_1736}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__563_v0() {
    local text_1743="${1}"
    local max_width_1744="${2}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_truncate_cjk563_v0=''
        return 1
    fi
    local command_43
    command_43="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_1743}" ${max_width_1744} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk563_v0=''
        return "${__status}"
    fi
    local result_1745="${command_43}"
    ret_perl_truncate_cjk563_v0="${result_1745}"
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
stty_lock__570_v0() {
    local command_45
    command_45="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_1719="${command_45}"
    parse_int__13_v0 "${count_1719}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_1720="${ret_parse_int13_v0}"
    if [ "$(( count_num_1720 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_1720="$(( count_num_1720 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_1720}
    __status=$?
}

# stty_unlock()
stty_unlock__571_v0() {
    local command_46
    command_46="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_1787="${command_46}"
    parse_int__13_v0 "${count_1787}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_1788="${ret_parse_int13_v0}"
    if [ "$(( count_num_1788 > 0 ))" != 0 ]; then
        count_num_1788="$(( count_num_1788 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_1788}
        __status=$?
        if [ "$(( count_num_1788 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__572_v0() {
    local size_1722="${1}"
    if [ "$([ "_${size_1722}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size572_v0=0
        return 0
    fi
    split__4_v0 "${size_1722}" " "
    local parts_1723=("${ret_split4_v0[@]}")
    local __length_47=("${parts_1723[@]}")
    if [ "$(( ${#__length_47[@]} != 2 ))" != 0 ]; then
        ret_store_term_size572_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1723[1]?"Index out of bounds (at src/./input/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1723[0]?"Index out of bounds (at src/./input/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_15=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size572_v0=1
    return 0
}

# query_term_size()
query_term_size__573_v0() {
    local command_49
    command_49="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1725="${command_49}"
    store_term_size__572_v0 "${size_1725}"
    ret_query_term_size573_v0="${ret_store_term_size572_v0}"
    return 0
}

# stty_term_size()
stty_term_size__574_v0() {
    local command_50
    command_50="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1721="${command_50}"
    store_term_size__572_v0 "${size_1721}"
    ret_stty_term_size574_v0="${ret_store_term_size572_v0}"
    return 0
}

# get_term_size()
get_term_size__575_v0() {
    stty_term_size__574_v0 
    local detected_1724="${ret_stty_term_size574_v0}"
    if [ "$(( ! detected_1724 ))" != 0 ]; then
        query_term_size__573_v0 
        detected_1724="${ret_query_term_size573_v0}"
    fi
    _got_term_size_14=1
}

# term_width()
term_width__577_v0() {
    if [ "$(( ! _got_term_size_14 ))" != 0 ]; then
        get_term_size__575_v0 
    fi
    ret_term_width577_v0="${_term_size_15[0]?"Index out of bounds (at src/./input/../utils/term.ab:88:23)"}"
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
get_supports_truecolor__588_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_1702="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_1702}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor588_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor588_v0=0
        return 0
    fi
    local colorterm_1703="${ret_env_var_get120_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_1703}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_1703}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor588_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__589_v0() {
    local message_1697="${1}"
    local r_1698="${2}"
    local g_1699="${3}"
    local b_1700="${4}"
    local fallback_1701="${5}"
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb589_v0="\\x1b[38;2;${r_1698};${g_1699};${b_1700}m""${message_1697}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__588_v0 
        local ret_get_supports_truecolor588_v0__50_17="${ret_get_supports_truecolor588_v0}"
        if [ "${ret_get_supports_truecolor588_v0__50_17}" != 0 ]; then
            ret_colored_rgb589_v0="\\x1b[38;2;${r_1698};${g_1699};${b_1700}m""${message_1697}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1701 == 0 ))" != 0 ]; then
            ret_colored_rgb589_v0="${message_1697}"
            return 0
        else
            ret_colored_rgb589_v0="\\x1b[${fallback_1701}m""${message_1697}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1701 == 0 ))" != 0 ]; then
            ret_colored_rgb589_v0="${message_1697}"
            return 0
        fi
        ret_colored_rgb589_v0="\\x1b[${fallback_1701}m""${message_1697}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__591_v0() {
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_1691="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1691}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1691}" ";"
            local parts_1692=("${ret_split4_v0[@]}")
            local __length_54=("${parts_1692[@]}")
            if [ "$(( ${#__length_54[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1692[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1692[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1692[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1692[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
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
        local secondary_env_1693="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1693}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1693}" ";"
            local parts_1694=("${ret_split4_v0[@]}")
            local __length_56=("${parts_1694[@]}")
            if [ "$(( ${#__length_56[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1694[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1694[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1694[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1694[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
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
        local accent_env_1695="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1695}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1695}" ";"
            local parts_1696=("${ret_split4_v0[@]}")
            local __length_58=("${parts_1696[@]}")
            if [ "$(( ${#__length_58[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1696[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1696[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1696[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1696[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__592_v0() {
    inner_get_xylitol_colors__591_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

# colored_primary(message: Text)
colored_primary__593_v0() {
    local message_1690="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__592_v0 
    fi
    colored_rgb__589_v0 "${message_1690}" "${_primary_color_18[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_18[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_18[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_18[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary593_v0="${ret_colored_rgb589_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__594_v0() {
    local message_1704="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__592_v0 
    fi
    colored_rgb__589_v0 "${message_1704}" "${_secondary_color_19[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_19[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_19[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_19[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary594_v0="${ret_colored_rgb589_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__608_v0() {
    local command_60
    command_60="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_1783="${command_60}"
    ret_get_char608_v0="${char_1783}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__611_v0() {
    local format_1761="${1}"
    local args_1762=("${!2}")
    args_1762=("${format_1761}" "${args_1762[@]}")
    __status=$?
    printf "${args_1762[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__612_v0() {
    local message_1771="${1}"
    local color_1772="${2}"
    # Prints an error message with a specified color.
    local array_61=("${message_1771}")
    eprintf__611_v0 "\\x1b[${color_1772}m%s\\x1b[0m" array_61[@]
}

# colored(message: Text, color: Int)
colored__613_v0() {
    local message_1773="${1}"
    local color_1774="${2}"
    # Returns a text wrapped in color codes.
    ret_colored613_v0="\\x1b[${color_1774}m""${message_1773}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__614_v0() {
    local cnt_1785="${1}"
    if [ "$(( cnt_1785 > 0 ))" != 0 ]; then
        local array_62=("")
        eprintf__611_v0 "\\x1b[${cnt_1785}D\\x1b[K" array_62[@]
    fi
}

# remove_line(cnt: Int)
remove_line__615_v0() {
    local cnt_1794="${1}"
    if [ "$(( cnt_1794 > 0 ))" != 0 ]; then
        local sequence_1795=""
        local __range_start_1796=0
        local __range_end_1796="${cnt_1794}"
        local __dir_1796=$(( ${__range_start_1796} <= ${__range_end_1796} ? 1 : -1 ))
        for (( ____1796=${__range_start_1796}; ____1796 * ${__dir_1796} < ${__range_end_1796} * ${__dir_1796}; ____1796+=${__dir_1796} )); do
            sequence_1795+="\\x1b[2K\\x1b[1A"
done
        local array_63=("")
        eprintf__611_v0 "${sequence_1795}" array_63[@]
    fi
    local array_64=("")
    eprintf__611_v0 "\\x1b[G" array_64[@]
}

# remove_current_line()
remove_current_line__616_v0() {
    local array_65=("")
    eprintf__611_v0 "\\x1b[2K\\x1b[G" array_65[@]
}

# new_line(cnt: Int)
new_line__618_v0() {
    local cnt_1763="${1}"
    local __range_start_1764=0
    local __range_end_1764="${cnt_1763}"
    local __dir_1764=$(( ${__range_start_1764} <= ${__range_end_1764} ? 1 : -1 ))
    for (( ____1764=${__range_start_1764}; ____1764 * ${__dir_1764} < ${__range_end_1764} * ${__dir_1764}; ____1764+=${__dir_1764} )); do
        local array_66=("")
        eprintf__611_v0 "
" array_66[@]
done
}

# go_up(cnt: Int)
go_up__619_v0() {
    local cnt_1782="${1}"
    local array_67=("")
    eprintf__611_v0 "\\x1b[${cnt_1782}A" array_67[@]
}

# go_down(cnt: Int)
go_down__620_v0() {
    local cnt_1793="${1}"
    local array_68=("")
    eprintf__611_v0 "\\x1b[${cnt_1793}B" array_68[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__624_v0() {
    local text_1711="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_69
    command_69="$([[ "${text_1711}" == *$'\x1b'* || "${text_1711}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1712="${command_69}"
    ret_has_ansi_escape624_v0="$([ "_${has_escape_1712}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__625_v0() {
    local text_1713="${1}"
    local command_70
    command_70="$(printf '%s' "${text_1713}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi625_v0="${command_70}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__626_v0() {
    local text_1730="${1}"
    local command_71
    command_71="$(printf "%s" "${text_1730}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi626_v0="${command_71}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__627_v0() {
    local text_1732="${1}"
    local command_72
    command_72="$(printf "%s" "${text_1732}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1733="${command_72}"
    ret_is_all_ascii627_v0="$([ "_${result_1733}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__628_v0() {
    local text_1729="${1}"
    strip_ansi__626_v0 "${text_1729}"
    local stripped_1731="${ret_strip_ansi626_v0}"
    # Check if text is all ASCII
    is_all_ascii__627_v0 "${stripped_1731}"
    local ret_is_all_ascii627_v0__150_12="${ret_is_all_ascii627_v0}"
    if [ "$(( ! ret_is_all_ascii627_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__562_v0 "${stripped_1731}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_73="${stripped_1731}"
            ret_get_visible_len628_v0="${#__length_73}"
            return 0
        fi
        ret_get_visible_len628_v0="${ret_perl_get_cjk_width562_v0}"
        return 0
    else
        local __length_74="${stripped_1731}"
        ret_get_visible_len628_v0="${#__length_74}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__629_v0() {
    local text_1740="${1}"
    local max_width_1741="${2}"
    get_visible_len__628_v0 "${text_1740}"
    local visible_len_1742="${ret_get_visible_len628_v0}"
    if [ "$(( visible_len_1742 <= max_width_1741 ))" != 0 ]; then
        ret_truncate_text629_v0="${text_1740}"
        return 0
    fi
    is_all_ascii__627_v0 "${text_1740}"
    local ret_is_all_ascii627_v0__167_12="${ret_is_all_ascii627_v0}"
    if [ "$(( ! ret_is_all_ascii627_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__563_v0 "${text_1740}" "${max_width_1741}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_1740}" | cut -c1-${max_width_1741}
            __status=$?
        fi
        ret_truncate_text629_v0="${ret_perl_truncate_cjk563_v0}"
        return 0
    fi
    local command_75
    command_75="$(printf "%s" "${text_1740}" | cut -c1-${max_width_1741})"
    __status=$?
    ret_truncate_text629_v0="${command_75}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__630_v0() {
    local text_1738="${1}"
    local max_width_1739="${2}"
    has_ansi_escape__624_v0 "${text_1738}"
    local ret_has_ansi_escape624_v0__179_12="${ret_has_ansi_escape624_v0}"
    if [ "$(( ! ret_has_ansi_escape624_v0__179_12 ))" != 0 ]; then
        truncate_text__629_v0 "${text_1738}" "${max_width_1739}"
        ret_truncate_ansi630_v0="${ret_truncate_text629_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_76
    command_76="$([[ "${text_1738}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_1746="${command_76}"
    # Replace \x1b[ with newline, then split
    local command_77
    command_77="$(t="${text_1738}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_1747="${command_77}"
    split__4_v0 "${replaced_1747}" "
"
    local parts_1748=("${ret_split4_v0[@]}")
    local result_1749=""
    local remaining_width_1750="${max_width_1739}"
    local __range_start_1751=0
    local __length_78=("${parts_1748[@]}")
    local __range_end_1751="${#__length_78[@]}"
    local __dir_1751=$(( ${__range_start_1751} <= ${__range_end_1751} ? 1 : -1 ))
    for (( idx_1751=${__range_start_1751}; idx_1751 * ${__dir_1751} < ${__range_end_1751} * ${__dir_1751}; idx_1751+=${__dir_1751} )); do
        local part_1752="${parts_1748[${idx_1751}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_1751 == 0 )) && $([ "_${starts_with_ansi_1746}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_1752}" == "_" ]; echo $?) && $(( remaining_width_1750 > 0 )) ))" != 0 ]; then
                truncate_text__629_v0 "${part_1752}" "${remaining_width_1750}"
                local ret_truncate_text629_v0__201_35="${ret_truncate_text629_v0}"
                local truncated_1753="${ret_truncate_text629_v0__201_35}"
                result_1749+="${truncated_1753}"
                get_visible_len__628_v0 "${truncated_1753}"
                local ret_get_visible_len628_v0__203_36="${ret_get_visible_len628_v0}"
                remaining_width_1750="$(( remaining_width_1750 - ret_get_visible_len628_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_79
            command_79="$(__p="${part_1752}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_1754="${command_79}"
            if [ "$([ "_${m_idx_1754}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_80
                command_80="$(__p="${part_1752}"; printf "%s" "${__p:0:${m_idx_1754}}")"
                __status=$?
                local ansi_params_1755="${command_80}"
                result_1749+="\\x1b[""${ansi_params_1755}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_1754}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_1756="${ret_parse_int13_v0__214_41}"
                local text_start_1757="$(( m_idx_num_1756 + 1 ))"
                local command_81
                command_81="$(__p="${part_1752}"; printf "%s" "${__p:${text_start_1757}}")"
                __status=$?
                local text_part_1758="${command_81}"
                if [ "$(( $([ "_${text_part_1758}" == "_" ]; echo $?) && $(( remaining_width_1750 > 0 )) ))" != 0 ]; then
                    truncate_text__629_v0 "${text_part_1758}" "${remaining_width_1750}"
                    local ret_truncate_text629_v0__218_39="${ret_truncate_text629_v0}"
                    local truncated_1759="${ret_truncate_text629_v0__218_39}"
                    result_1749+="${truncated_1759}"
                    get_visible_len__628_v0 "${truncated_1759}"
                    local ret_get_visible_len628_v0__220_40="${ret_get_visible_len628_v0}"
                    remaining_width_1750="$(( remaining_width_1750 - ret_get_visible_len628_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_1752}" == "_" ]; echo $?) && $(( remaining_width_1750 > 0 )) ))" != 0 ]; then
                    truncate_text__629_v0 "${part_1752}" "${remaining_width_1750}"
                    local ret_truncate_text629_v0__225_39="${ret_truncate_text629_v0}"
                    local truncated_1760="${ret_truncate_text629_v0__225_39}"
                    result_1749+="${truncated_1760}"
                    get_visible_len__628_v0 "${truncated_1760}"
                    local ret_get_visible_len628_v0__227_40="${ret_get_visible_len628_v0}"
                    remaining_width_1750="$(( remaining_width_1750 - ret_get_visible_len628_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi630_v0="${result_1749}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__631_v0() {
    local text_1727="${1}"
    local max_width_1728="${2}"
    get_visible_len__628_v0 "${text_1727}"
    local visible_len_1737="${ret_get_visible_len628_v0}"
    if [ "$(( visible_len_1737 <= max_width_1728 ))" != 0 ]; then
        ret_cutoff_text631_v0="${text_1727}"
        return 0
    fi
    truncate_ansi__630_v0 "${text_1727}" "$(( max_width_1728 - 3 ))"
    local ret_truncate_ansi630_v0__243_12="${ret_truncate_ansi630_v0}"
    ret_cutoff_text631_v0="${ret_truncate_ansi630_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__632_v0() {
    local items_1765=("${!1}")
    local total_len_1766="${2}"
    local term_width_1767="${3}"
    local separator_1768=" • "
    local separator_len_1769=3
    # Fast path: no truncation needed
    if [ "$(( total_len_1766 <= term_width_1767 ))" != 0 ]; then
        local iter_1770=0
        while :
        do
            local __length_82=("${items_1765[@]}")
            if [ "$(( iter_1770 >= ${#__length_82[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_1770 > 0 ))" != 0 ]; then
                eprintf_colored__612_v0 "${separator_1768}" 90
            fi
            colored__613_v0 "${items_1765[$(( iter_1770 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored613_v0__268_41="${ret_colored613_v0}"
            local array_83=("")
            eprintf__611_v0 "${items_1765[${iter_1770}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored613_v0__268_41}" array_83[@]
            iter_1770="$(( iter_1770 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_1775=0
        local first_1776=1
        local iter_1777=0
        while :
        do
            local __length_84=("${items_1765[@]}")
            if [ "$(( iter_1777 >= ${#__length_84[@]} ))" != 0 ]; then
                break
            fi
            local key_1778="${items_1765[${iter_1777}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_1779="${items_1765[$(( iter_1777 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_85="${key_1778}"
            local __length_86="${action_1779}"
            local part_len_1780="$(( $(( ${#__length_85} + 1 )) + ${#__length_86} ))"
            local needed_1781="${part_len_1780}"
            if [ "$(( ! first_1776 ))" != 0 ]; then
                needed_1781="$(( needed_1781 + separator_len_1769 ))"
            fi
            if [ "$(( $(( current_len_1775 + needed_1781 )) > term_width_1767 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_1776 ))" != 0 ]; then
                eprintf_colored__612_v0 "${separator_1768}" 90
            fi
            colored__613_v0 "${action_1779}" 2
            local ret_colored613_v0__296_33="${ret_colored613_v0}"
            local array_87=("")
            eprintf__611_v0 "${key_1778}"" ""${ret_colored613_v0__296_33}" array_87[@]
            current_len_1775="$(( current_len_1775 + needed_1781 ))"
            first_1776=0
            iter_1777="$(( iter_1777 + 2 ))"
        done
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__681_v0() {
    local prompt_1715="${1}"
    local placeholder_1716="${2}"
    local header_1717="${3}"
    local password_1718="${4}"
    stty_lock__570_v0 
    term_width__577_v0 
    local term_width_1726="${ret_term_width577_v0}"
    if [ "$([ "_${header_1717}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__631_v0 "${header_1717}" "${term_width_1726}"
        local ret_cutoff_text631_v0__23_17="${ret_cutoff_text631_v0}"
        local array_88=("")
        eprintf__611_v0 "${ret_cutoff_text631_v0__23_17}""
" array_88[@]
    fi
    new_line__618_v0 2
    # "enter submit" = 12
    local array_89=("enter" "submit")
    render_tooltip__632_v0 array_89[@] 12 "${term_width_1726}"
    go_up__619_v0 2
    local array_90=("")
    eprintf__611_v0 "\\x1b[G" array_90[@]
    local array_91=("")
    eprintf__611_v0 "${prompt_1715}" array_91[@]
    eprintf_colored__612_v0 "${placeholder_1716}" 90
    get_char__608_v0 
    local char_1784="${ret_get_char608_v0}"
    local __length_92="${prompt_1715}"
    remove__614_v0 "${#__length_92}"
    local __length_93="${placeholder_1716}"
    remove__614_v0 "$(( ${#__length_93} + 1 ))"
    local text_1786=""
    if [ "$(( ! password_1718 ))" != 0 ]; then
        stty_unlock__571_v0 
        local command_94
        command_94="$(read -e -i ${char_1784} -p "${prompt_1715}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1786="${command_94}"
    else
        stty_unlock__571_v0 
        local command_95
        command_95="$(read -es -i ${char_1784} -p "${prompt_1715}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1786="${command_95}"
    fi
    stty_lock__570_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__628_v0 "${prompt_1715}""${text_1786}"
    local input_display_len_1789="${ret_get_visible_len628_v0}"
    math_ceil__502_v0 "$(( input_display_len_1789 / term_width_1726 ))"
    local input_lines_1792="${ret_math_ceil502_v0}"
    if [ "$(( input_lines_1792 < 3 ))" != 0 ]; then
        go_down__620_v0 "$(( 2 - input_lines_1792 ))"
        remove_line__615_v0 2
        remove_current_line__616_v0 
    fi
    if [ "$(( input_lines_1792 >= 3 ))" != 0 ]; then
        remove_line__615_v0 "${input_lines_1792}"
    fi
    if [ "$([ "_${header_1717}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__615_v0 1
        remove_current_line__616_v0 
    fi
    stty_unlock__571_v0 
    ret_xyl_input681_v0="${text_1786}"
    return 0
}

# print_input_help()
print_input_help__773_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    printf '%s\n' ""
    colored_primary__593_v0 "input"
    local ret_colored_primary593_v0__7_12="${ret_colored_primary593_v0}"
    local array_96=()
    printf__128_v1 "${ret_colored_primary593_v0__7_12}" array_96[@]
    local array_97=()
    printf__128_v1 " - Prompt for some input from the user." array_97[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__594_v0 "Flags: "
    local ret_colored_secondary594_v0__11_12="${ret_colored_secondary594_v0}"
    local array_98=()
    printf__128_v1 "${ret_colored_secondary594_v0__11_12}""
" array_98[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__823_v0() {
    local parameters_1684=("${!1}")
    local prompt_1685="> "
    local placeholder_1686="Type here..."
    local header_1687=""
    local password_1688=0
    for param_1689 in "${parameters_1684[@]}"; do
        if [ "$(( $([ "_${param_1689}" != "_-h" ]; echo $?) || $([ "_${param_1689}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__773_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_1689}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_101="--prompt="
            slice__24_v0 "${param_1689}" "${#__length_101}" 0
            prompt_1685="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_1689}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_102="--placeholder="
            slice__24_v0 "${param_1689}" "${#__length_102}" 0
            placeholder_1686="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_1689}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_103="--header="
            slice__24_v0 "${param_1689}" "${#__length_103}" 0
            header_1687="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_1689}" != "_--password" ]; echo $?)" != 0 ]; then
            password_1688=1
        fi
    done
    has_ansi_escape__624_v0 "${header_1687}"
    local ret_has_ansi_escape624_v0__31_44="${ret_has_ansi_escape624_v0}"
    escape_ansi__625_v0 "${header_1687}"
    local ret_escape_ansi625_v0__31_73="${ret_escape_ansi625_v0}"
    colored_primary__593_v0 "${header_1687}"
    local ret_colored_primary593_v0__31_111="${ret_colored_primary593_v0}"
    local display_header_1714
    display_header_1714="$(if [ "$(( $([ "_${header_1687}" != "_" ]; echo $?) || ret_has_ansi_escape624_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi625_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary593_v0__31_111}"; fi)"
    xyl_input__681_v0 "${prompt_1685}" "${placeholder_1686}" "${display_header_1714}" "${password_1688}"
    ret_execute_input823_v0="${ret_xyl_input681_v0}"
    return 0
}

# Perl Extensions Utilities
command_104="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_104}" != "_No" ]; echo $?)"
command_105="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! _perl_disabled_21 )) && $([ "_${command_105}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__955_v0() {
    local text_13321="${1}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_get_cjk_width955_v0=''
        return 1
    fi
    local command_106
    command_106="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_13321}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width955_v0=''
        return "${__status}"
    fi
    local width_str_13322="${command_106}"
    parse_int__13_v0 "${width_str_13322}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width955_v0=''
        return "${__status}"
    fi
    local width_13323="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width955_v0="${width_13323}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__956_v0() {
    local text_13330="${1}"
    local max_width_13331="${2}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_truncate_cjk956_v0=''
        return 1
    fi
    local command_107
    command_107="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_13330}" ${max_width_13331} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk956_v0=''
        return "${__status}"
    fi
    local result_13332="${command_107}"
    ret_perl_truncate_cjk956_v0="${result_13332}"
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
stty_lock__963_v0() {
    local command_109
    command_109="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13305="${command_109}"
    parse_int__13_v0 "${count_13305}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13306="${ret_parse_int13_v0}"
    if [ "$(( count_num_13306 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_13306="$(( count_num_13306 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13306}
    __status=$?
}

# stty_unlock()
stty_unlock__964_v0() {
    local command_110
    command_110="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13416="${command_110}"
    parse_int__13_v0 "${count_13416}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13417="${ret_parse_int13_v0}"
    if [ "$(( count_num_13417 > 0 ))" != 0 ]; then
        count_num_13417="$(( count_num_13417 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13417}
        __status=$?
        if [ "$(( count_num_13417 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__965_v0() {
    local size_13308="${1}"
    if [ "$([ "_${size_13308}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size965_v0=0
        return 0
    fi
    split__4_v0 "${size_13308}" " "
    local parts_13309=("${ret_split4_v0[@]}")
    local __length_111=("${parts_13309[@]}")
    if [ "$(( ${#__length_111[@]} != 2 ))" != 0 ]; then
        ret_store_term_size965_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_13309[1]?"Index out of bounds (at src/./choose/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_13309[0]?"Index out of bounds (at src/./choose/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_24=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size965_v0=1
    return 0
}

# query_term_size()
query_term_size__966_v0() {
    local command_113
    command_113="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_13311="${command_113}"
    store_term_size__965_v0 "${size_13311}"
    ret_query_term_size966_v0="${ret_store_term_size965_v0}"
    return 0
}

# stty_term_size()
stty_term_size__967_v0() {
    local command_114
    command_114="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_13307="${command_114}"
    store_term_size__965_v0 "${size_13307}"
    ret_stty_term_size967_v0="${ret_store_term_size965_v0}"
    return 0
}

# get_term_size()
get_term_size__968_v0() {
    stty_term_size__967_v0 
    local detected_13310="${ret_stty_term_size967_v0}"
    if [ "$(( ! detected_13310 ))" != 0 ]; then
        query_term_size__966_v0 
        detected_13310="${ret_query_term_size966_v0}"
    fi
    _got_term_size_23=1
}

# term_width()
term_width__970_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__968_v0 
    fi
    ret_term_width970_v0="${_term_size_24[0]?"Index out of bounds (at src/./choose/../utils/term.ab:88:23)"}"
    return 0
}

# term_height()
term_height__971_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__968_v0 
    fi
    ret_term_height971_v0="${_term_size_24[1]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
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
get_supports_truecolor__981_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_13272="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_13272}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor981_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor981_v0=0
        return 0
    fi
    local colorterm_13273="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_13273}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_13273}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor981_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__982_v0() {
    local message_13267="${1}"
    local r_13268="${2}"
    local g_13269="${3}"
    local b_13270="${4}"
    local fallback_13271="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb982_v0="\\x1b[38;2;${r_13268};${g_13269};${b_13270}m""${message_13267}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__981_v0 
        local ret_get_supports_truecolor981_v0__50_17="${ret_get_supports_truecolor981_v0}"
        if [ "${ret_get_supports_truecolor981_v0__50_17}" != 0 ]; then
            ret_colored_rgb982_v0="\\x1b[38;2;${r_13268};${g_13269};${b_13270}m""${message_13267}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_13271 == 0 ))" != 0 ]; then
            ret_colored_rgb982_v0="${message_13267}"
            return 0
        else
            ret_colored_rgb982_v0="\\x1b[${fallback_13271}m""${message_13267}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_13271 == 0 ))" != 0 ]; then
            ret_colored_rgb982_v0="${message_13267}"
            return 0
        fi
        ret_colored_rgb982_v0="\\x1b[${fallback_13271}m""${message_13267}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__984_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_13261="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_13261}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_13261}" ";"
            local parts_13262=("${ret_split4_v0[@]}")
            local __length_118=("${parts_13262[@]}")
            if [ "$(( ${#__length_118[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13262[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13262[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13262[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13262[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
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
        local secondary_env_13263="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_13263}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_13263}" ";"
            local parts_13264=("${ret_split4_v0[@]}")
            local __length_120=("${parts_13264[@]}")
            if [ "$(( ${#__length_120[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13264[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13264[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13264[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13264[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
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
        local accent_env_13265="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_13265}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_13265}" ";"
            local parts_13266=("${ret_split4_v0[@]}")
            local __length_122=("${parts_13266[@]}")
            if [ "$(( ${#__length_122[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13266[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13266[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13266[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13266[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors984_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__985_v0() {
    inner_get_xylitol_colors__984_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__986_v0() {
    local message_13260="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__985_v0 
    fi
    colored_rgb__982_v0 "${message_13260}" "${_primary_color_27[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary986_v0="${ret_colored_rgb982_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__987_v0() {
    local message_13282="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__985_v0 
    fi
    colored_rgb__982_v0 "${message_13282}" "${_secondary_color_28[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary987_v0="${ret_colored_rgb982_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1002_v0() {
    local command_124
    command_124="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_13394="${command_124}"
    if [ "$([ "_${var_13394}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1002_v0="UP"
        return 0
    elif [ "$([ "_${var_13394}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1002_v0="DOWN"
        return 0
    elif [ "$([ "_${var_13394}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1002_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_13394}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1002_v0="LEFT"
        return 0
    elif [ "$([ "_${var_13394}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1002_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_13394}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1002_v0="INPUT"
        return 0
    else
        ret_get_key1002_v0="${var_13394}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1004_v0() {
    local format_13286="${1}"
    local args_13287=("${!2}")
    args_13287=("${format_13286}" "${args_13287[@]}")
    __status=$?
    printf "${args_13287[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1005_v0() {
    local message_13284="${1}"
    local color_13285="${2}"
    # Prints an error message with a specified color.
    local array_125=("${message_13284}")
    eprintf__1004_v0 "\\x1b[${color_13285}m%s\\x1b[0m" array_125[@]
}

# colored(message: Text, color: Int)
colored__1006_v0() {
    local message_13357="${1}"
    local color_13358="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1006_v0="\\x1b[${color_13358}m""${message_13357}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1008_v0() {
    local cnt_13391="${1}"
    if [ "$(( cnt_13391 > 0 ))" != 0 ]; then
        local sequence_13392=""
        local __range_start_13393=0
        local __range_end_13393="${cnt_13391}"
        local __dir_13393=$(( ${__range_start_13393} <= ${__range_end_13393} ? 1 : -1 ))
        for (( ____13393=${__range_start_13393}; ____13393 * ${__dir_13393} < ${__range_end_13393} * ${__dir_13393}; ____13393+=${__dir_13393} )); do
            sequence_13392+="\\x1b[2K\\x1b[1A"
done
        local array_126=("")
        eprintf__1004_v0 "${sequence_13392}" array_126[@]
    fi
    local array_127=("")
    eprintf__1004_v0 "\\x1b[G" array_127[@]
}

# remove_current_line()
remove_current_line__1009_v0() {
    local array_128=("")
    eprintf__1004_v0 "\\x1b[2K\\x1b[G" array_128[@]
}

# print_blank(cnt: Int)
print_blank__1010_v0() {
    local cnt_13382="${1}"
    printf '%*s' "${cnt_13382}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1011_v0() {
    local cnt_13349="${1}"
    local __range_start_13350=0
    local __range_end_13350="${cnt_13349}"
    local __dir_13350=$(( ${__range_start_13350} <= ${__range_end_13350} ? 1 : -1 ))
    for (( ____13350=${__range_start_13350}; ____13350 * ${__dir_13350} < ${__range_end_13350} * ${__dir_13350}; ____13350+=${__dir_13350} )); do
        local array_129=("")
        eprintf__1004_v0 "
" array_129[@]
done
}

# go_up(cnt: Int)
go_up__1012_v0() {
    local cnt_13366="${1}"
    local array_130=("")
    eprintf__1004_v0 "\\x1b[${cnt_13366}A" array_130[@]
}

# go_down(cnt: Int)
go_down__1013_v0() {
    local cnt_13403="${1}"
    local array_131=("")
    eprintf__1004_v0 "\\x1b[${cnt_13403}B" array_131[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1014_v0() {
    local cnt_13412="${1}"
    if [ "$(( cnt_13412 > 0 ))" != 0 ]; then
        go_down__1013_v0 "${cnt_13412}"
    else
        go_up__1012_v0 "$(( - cnt_13412 ))"
    fi
}

# hide_cursor()
hide_cursor__1015_v0() {
    local array_132=("")
    eprintf__1004_v0 "\\x1b[?25l" array_132[@]
}

# show_cursor()
show_cursor__1016_v0() {
    local array_133=("")
    eprintf__1004_v0 "\\x1b[?25h" array_133[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1017_v0() {
    local text_13289="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_134
    command_134="$([[ "${text_13289}" == *$'\x1b'* || "${text_13289}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_13290="${command_134}"
    ret_has_ansi_escape1017_v0="$([ "_${has_escape_13290}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1018_v0() {
    local text_13291="${1}"
    local command_135
    command_135="$(printf '%s' "${text_13291}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1018_v0="${command_135}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1019_v0() {
    local text_13317="${1}"
    local command_136
    command_136="$(printf "%s" "${text_13317}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1019_v0="${command_136}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1020_v0() {
    local text_13319="${1}"
    local command_137
    command_137="$(printf "%s" "${text_13319}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_13320="${command_137}"
    ret_is_all_ascii1020_v0="$([ "_${result_13320}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1021_v0() {
    local text_13316="${1}"
    strip_ansi__1019_v0 "${text_13316}"
    local stripped_13318="${ret_strip_ansi1019_v0}"
    # Check if text is all ASCII
    is_all_ascii__1020_v0 "${stripped_13318}"
    local ret_is_all_ascii1020_v0__150_12="${ret_is_all_ascii1020_v0}"
    if [ "$(( ! ret_is_all_ascii1020_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__955_v0 "${stripped_13318}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_138="${stripped_13318}"
            ret_get_visible_len1021_v0="${#__length_138}"
            return 0
        fi
        ret_get_visible_len1021_v0="${ret_perl_get_cjk_width955_v0}"
        return 0
    else
        local __length_139="${stripped_13318}"
        ret_get_visible_len1021_v0="${#__length_139}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1022_v0() {
    local text_13327="${1}"
    local max_width_13328="${2}"
    get_visible_len__1021_v0 "${text_13327}"
    local visible_len_13329="${ret_get_visible_len1021_v0}"
    if [ "$(( visible_len_13329 <= max_width_13328 ))" != 0 ]; then
        ret_truncate_text1022_v0="${text_13327}"
        return 0
    fi
    is_all_ascii__1020_v0 "${text_13327}"
    local ret_is_all_ascii1020_v0__167_12="${ret_is_all_ascii1020_v0}"
    if [ "$(( ! ret_is_all_ascii1020_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__956_v0 "${text_13327}" "${max_width_13328}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_13327}" | cut -c1-${max_width_13328}
            __status=$?
        fi
        ret_truncate_text1022_v0="${ret_perl_truncate_cjk956_v0}"
        return 0
    fi
    local command_140
    command_140="$(printf "%s" "${text_13327}" | cut -c1-${max_width_13328})"
    __status=$?
    ret_truncate_text1022_v0="${command_140}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1023_v0() {
    local text_13325="${1}"
    local max_width_13326="${2}"
    has_ansi_escape__1017_v0 "${text_13325}"
    local ret_has_ansi_escape1017_v0__179_12="${ret_has_ansi_escape1017_v0}"
    if [ "$(( ! ret_has_ansi_escape1017_v0__179_12 ))" != 0 ]; then
        truncate_text__1022_v0 "${text_13325}" "${max_width_13326}"
        ret_truncate_ansi1023_v0="${ret_truncate_text1022_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_141
    command_141="$([[ "${text_13325}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_13333="${command_141}"
    # Replace \x1b[ with newline, then split
    local command_142
    command_142="$(t="${text_13325}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_13334="${command_142}"
    split__4_v0 "${replaced_13334}" "
"
    local parts_13335=("${ret_split4_v0[@]}")
    local result_13336=""
    local remaining_width_13337="${max_width_13326}"
    local __range_start_13338=0
    local __length_143=("${parts_13335[@]}")
    local __range_end_13338="${#__length_143[@]}"
    local __dir_13338=$(( ${__range_start_13338} <= ${__range_end_13338} ? 1 : -1 ))
    for (( idx_13338=${__range_start_13338}; idx_13338 * ${__dir_13338} < ${__range_end_13338} * ${__dir_13338}; idx_13338+=${__dir_13338} )); do
        local part_13339="${parts_13335[${idx_13338}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_13338 == 0 )) && $([ "_${starts_with_ansi_13333}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_13339}" == "_" ]; echo $?) && $(( remaining_width_13337 > 0 )) ))" != 0 ]; then
                truncate_text__1022_v0 "${part_13339}" "${remaining_width_13337}"
                local ret_truncate_text1022_v0__201_35="${ret_truncate_text1022_v0}"
                local truncated_13340="${ret_truncate_text1022_v0__201_35}"
                result_13336+="${truncated_13340}"
                get_visible_len__1021_v0 "${truncated_13340}"
                local ret_get_visible_len1021_v0__203_36="${ret_get_visible_len1021_v0}"
                remaining_width_13337="$(( remaining_width_13337 - ret_get_visible_len1021_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_144
            command_144="$(__p="${part_13339}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_13341="${command_144}"
            if [ "$([ "_${m_idx_13341}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_145
                command_145="$(__p="${part_13339}"; printf "%s" "${__p:0:${m_idx_13341}}")"
                __status=$?
                local ansi_params_13342="${command_145}"
                result_13336+="\\x1b[""${ansi_params_13342}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_13341}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_13343="${ret_parse_int13_v0__214_41}"
                local text_start_13344="$(( m_idx_num_13343 + 1 ))"
                local command_146
                command_146="$(__p="${part_13339}"; printf "%s" "${__p:${text_start_13344}}")"
                __status=$?
                local text_part_13345="${command_146}"
                if [ "$(( $([ "_${text_part_13345}" == "_" ]; echo $?) && $(( remaining_width_13337 > 0 )) ))" != 0 ]; then
                    truncate_text__1022_v0 "${text_part_13345}" "${remaining_width_13337}"
                    local ret_truncate_text1022_v0__218_39="${ret_truncate_text1022_v0}"
                    local truncated_13346="${ret_truncate_text1022_v0__218_39}"
                    result_13336+="${truncated_13346}"
                    get_visible_len__1021_v0 "${truncated_13346}"
                    local ret_get_visible_len1021_v0__220_40="${ret_get_visible_len1021_v0}"
                    remaining_width_13337="$(( remaining_width_13337 - ret_get_visible_len1021_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_13339}" == "_" ]; echo $?) && $(( remaining_width_13337 > 0 )) ))" != 0 ]; then
                    truncate_text__1022_v0 "${part_13339}" "${remaining_width_13337}"
                    local ret_truncate_text1022_v0__225_39="${ret_truncate_text1022_v0}"
                    local truncated_13347="${ret_truncate_text1022_v0__225_39}"
                    result_13336+="${truncated_13347}"
                    get_visible_len__1021_v0 "${truncated_13347}"
                    local ret_get_visible_len1021_v0__227_40="${ret_get_visible_len1021_v0}"
                    remaining_width_13337="$(( remaining_width_13337 - ret_get_visible_len1021_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1023_v0="${result_13336}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1024_v0() {
    local text_13314="${1}"
    local max_width_13315="${2}"
    get_visible_len__1021_v0 "${text_13314}"
    local visible_len_13324="${ret_get_visible_len1021_v0}"
    if [ "$(( visible_len_13324 <= max_width_13315 ))" != 0 ]; then
        ret_cutoff_text1024_v0="${text_13314}"
        return 0
    fi
    truncate_ansi__1023_v0 "${text_13314}" "$(( max_width_13315 - 3 ))"
    local ret_truncate_ansi1023_v0__243_12="${ret_truncate_ansi1023_v0}"
    ret_cutoff_text1024_v0="${ret_truncate_ansi1023_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1025_v0() {
    local items_13351=("${!1}")
    local total_len_13352="${2}"
    local term_width_13353="${3}"
    local separator_13354=" • "
    local separator_len_13355=3
    # Fast path: no truncation needed
    if [ "$(( total_len_13352 <= term_width_13353 ))" != 0 ]; then
        local iter_13356=0
        while :
        do
            local __length_147=("${items_13351[@]}")
            if [ "$(( iter_13356 >= ${#__length_147[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_13356 > 0 ))" != 0 ]; then
                eprintf_colored__1005_v0 "${separator_13354}" 90
            fi
            colored__1006_v0 "${items_13351[$(( iter_13356 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1006_v0__268_41="${ret_colored1006_v0}"
            local array_148=("")
            eprintf__1004_v0 "${items_13351[${iter_13356}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1006_v0__268_41}" array_148[@]
            iter_13356="$(( iter_13356 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_13359=0
        local first_13360=1
        local iter_13361=0
        while :
        do
            local __length_149=("${items_13351[@]}")
            if [ "$(( iter_13361 >= ${#__length_149[@]} ))" != 0 ]; then
                break
            fi
            local key_13362="${items_13351[${iter_13361}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_13363="${items_13351[$(( iter_13361 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_150="${key_13362}"
            local __length_151="${action_13363}"
            local part_len_13364="$(( $(( ${#__length_150} + 1 )) + ${#__length_151} ))"
            local needed_13365="${part_len_13364}"
            if [ "$(( ! first_13360 ))" != 0 ]; then
                needed_13365="$(( needed_13365 + separator_len_13355 ))"
            fi
            if [ "$(( $(( current_len_13359 + needed_13365 )) > term_width_13353 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_13360 ))" != 0 ]; then
                eprintf_colored__1005_v0 "${separator_13354}" 90
            fi
            colored__1006_v0 "${action_13363}" 2
            local ret_colored1006_v0__296_33="${ret_colored1006_v0}"
            local array_152=("")
            eprintf__1004_v0 "${key_13362}"" ""${ret_colored1006_v0__296_33}" array_152[@]
            current_len_13359="$(( current_len_13359 + needed_13365 ))"
            first_13360=0
            iter_13361="$(( iter_13361 + 2 ))"
        done
    fi
}

# A chooser driven by its caller.
# 
# Amber has no callbacks, so the engine cannot ask for an item's text on its
# own. The caller runs the loop instead and hands over one page of labels at
# a time, which is what lets it build them lazily. `xyl_choose` and
# `xyl_file` show the shape of that loop.
# 
# Only the engine writes to the terminal; callers just produce text.
# `chooser_step` handled the key and redrew whatever changed.
__CHOOSER_CONTINUE_30=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_31=1
# The user confirmed the selection.
__CHOOSER_DONE_32=2
_total_33=0
_page_size_34=10
_display_count_35=0
_total_pages_36=1
_current_page_37=0
_selected_38=0
_cursor_39="> "
_multi_40=0
_limit_41=-1
_term_width_42=80
_has_header_43=0
_page_44=()
_page_count_45=0
_checked_46=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_47=0
_first_render_48=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_49=0
# render_single_page()
render_single_page__1169_v0() {
    local __length_155="${_cursor_39}"
    local cursor_len_13385="${#__length_155}"
    local max_option_width_13386="$(( $(( _term_width_42 - cursor_len_13385 )) - 1 ))"
    local __range_start_13387=0
    local __range_end_13387="${_page_count_45}"
    local __dir_13387=$(( ${__range_start_13387} <= ${__range_end_13387} ? 1 : -1 ))
    for (( i_13387=${__range_start_13387}; i_13387 * ${__dir_13387} < ${__range_end_13387} * ${__dir_13387}; i_13387+=${__dir_13387} )); do
        cutoff_text__1024_v0 "${_page_44[${i_13387}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_13386}"
        local ret_cutoff_text1024_v0__48_27="${ret_cutoff_text1024_v0}"
        local truncated_13388="${ret_cutoff_text1024_v0__48_27}"
        if [ "$(( i_13387 == _selected_38 ))" != 0 ]; then
            colored_secondary__987_v0 "${_cursor_39}""${truncated_13388}""
"
            local ret_colored_secondary987_v0__50_21="${ret_colored_secondary987_v0}"
            local array_156=("")
            eprintf__1004_v0 "${ret_colored_secondary987_v0__50_21}" array_156[@]
        else
            print_blank__1010_v0 "${cursor_len_13385}"
            local array_157=("")
            eprintf__1004_v0 "${truncated_13388}""
" array_157[@]
        fi
done
    local remaining_slots_13389="$(( _display_count_35 - _page_count_45 ))"
    if [ "$(( remaining_slots_13389 > 0 ))" != 0 ]; then
        local __range_start_13390=0
        local __range_end_13390="${remaining_slots_13389}"
        local __dir_13390=$(( ${__range_start_13390} <= ${__range_end_13390} ? 1 : -1 ))
        for (( ____13390=${__range_start_13390}; ____13390 * ${__dir_13390} < ${__range_end_13390} * ${__dir_13390}; ____13390+=${__dir_13390} )); do
            local array_158=("")
            eprintf__1004_v0 "\\x1b[K
" array_158[@]
done
    fi
}

# render_multi_page()
render_multi_page__1170_v0() {
    local __length_159="${_cursor_39}"
    local cursor_len_13375="${#__length_159}"
    local max_option_width_13376="$(( $(( _term_width_42 - cursor_len_13375 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1175_v0 
    local page_start_13377="${ret_chooser_page_start1175_v0}"
    local __range_start_13378=0
    local __range_end_13378="${_page_count_45}"
    local __dir_13378=$(( ${__range_start_13378} <= ${__range_end_13378} ? 1 : -1 ))
    for (( i_13378=${__range_start_13378}; i_13378 * ${__dir_13378} < ${__range_end_13378} * ${__dir_13378}; i_13378+=${__dir_13378} )); do
        local global_idx_13379="$(( page_start_13377 + i_13378 ))"
        local check_mark_13380
        check_mark_13380="$(if [ "${_checked_46[${global_idx_13379}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1024_v0 "${_page_44[${i_13378}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_13376}"
        local ret_cutoff_text1024_v0__71_27="${ret_cutoff_text1024_v0}"
        local truncated_13381="${ret_cutoff_text1024_v0__71_27}"
        if [ "$(( i_13378 == _selected_38 ))" != 0 ]; then
            colored_secondary__987_v0 "${_cursor_39}""${check_mark_13380}""${truncated_13381}""
"
            local ret_colored_secondary987_v0__73_37="${ret_colored_secondary987_v0}"
            local array_160=("")
            eprintf__1004_v0 "${ret_colored_secondary987_v0__73_37}" array_160[@]
        elif [ "${_checked_46[${global_idx_13379}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1010_v0 "${cursor_len_13375}"
            colored_secondary__987_v0 "${check_mark_13380}""${truncated_13381}""
"
            local ret_colored_secondary987_v0__76_25="${ret_colored_secondary987_v0}"
            local array_161=("")
            eprintf__1004_v0 "${ret_colored_secondary987_v0__76_25}" array_161[@]
        else
            print_blank__1010_v0 "${cursor_len_13375}"
            local array_162=("")
            eprintf__1004_v0 "${check_mark_13380}""${truncated_13381}""
" array_162[@]
        fi
done
    local remaining_slots_13383="$(( _display_count_35 - _page_count_45 ))"
    if [ "$(( remaining_slots_13383 > 0 ))" != 0 ]; then
        local __range_start_13384=0
        local __range_end_13384="${remaining_slots_13383}"
        local __dir_13384=$(( ${__range_start_13384} <= ${__range_end_13384} ? 1 : -1 ))
        for (( ____13384=${__range_start_13384}; ____13384 * ${__dir_13384} < ${__range_end_13384} * ${__dir_13384}; ____13384+=${__dir_13384} )); do
            local array_163=("")
            eprintf__1004_v0 "\\x1b[K
" array_163[@]
done
    fi
}

# render_page()
render_page__1171_v0() {
    if [ "${_multi_40}" != 0 ]; then
        render_multi_page__1170_v0 
    else
        render_single_page__1169_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1172_v0() {
    if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
        local array_164=("")
        eprintf__1004_v0 "\\x1b[G\\x1b[K" array_164[@]
        eprintf_colored__1005_v0 "Page $(( _current_page_37 + 1 ))/${_total_pages_36}" 90
        local array_165=("")
        eprintf__1004_v0 "\\x1b[G" array_165[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1173_v0() {
    if [ "$(( ! _multi_40 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
            local array_166=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1025_v0 array_166[@] 36 "${_term_width_42}"
        else
            local array_167=("↑↓" "select" "enter" "confirm")
            render_tooltip__1025_v0 array_167[@] 25 "${_term_width_42}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_36 > 1 )) && $(( _limit_41 < 0 )) ))" != 0 ]; then
            local array_168=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1025_v0 array_168[@] 55 "${_term_width_42}"
        elif [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
            local array_169=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1025_v0 array_169[@] 47 "${_term_width_42}"
        elif [ "$(( _limit_41 < 0 ))" != 0 ]; then
            local array_170=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1025_v0 array_170[@] 44 "${_term_width_42}"
        else
            local array_171=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1025_v0 array_171[@] 36 "${_term_width_42}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1174_v0() {
    local total_13299="${1}"
    local page_size_13300="${2}"
    local header_13301="${3}"
    local cursor_13302="${4}"
    local multi_13303="${5}"
    local limit_13304="${6}"
    _total_33="${total_13299}"
    _cursor_39="${cursor_13302}"
    _multi_40="${multi_13303}"
    _limit_41="${limit_13304}"
    _current_page_37=0
    _selected_38=0
    _first_render_48=1
    _up_paged_49=0
    _checked_count_47=0
    _has_header_43="$([ "_${header_13301}" == "_" ]; echo $?)"
    stty_lock__963_v0 
    hide_cursor__1015_v0 
    term_width__970_v0 
    _term_width_42="${ret_term_width970_v0}"
    term_height__971_v0 
    local term_height_13312="${ret_term_height971_v0}"
    local max_page_size_13313
    max_page_size_13313="$(( term_height_13312 - $(if [ "${_has_header_43}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_34="${page_size_13300}"
    if [ "$(( _page_size_34 > max_page_size_13313 ))" != 0 ]; then
        _page_size_34="${max_page_size_13313}"
    fi
    if [ "${_has_header_43}" != 0 ]; then
        cutoff_text__1024_v0 "${header_13301}" "${_term_width_42}"
        local ret_cutoff_text1024_v0__157_17="${ret_cutoff_text1024_v0}"
        local array_172=("")
        eprintf__1004_v0 "${ret_cutoff_text1024_v0__157_17}""
" array_172[@]
    fi
    math_floor__501_v0 "$(( $(( $(( total_13299 + _page_size_34 )) - 1 )) / _page_size_34 ))"
    _total_pages_36="${ret_math_floor501_v0}"
    _display_count_35="${_page_size_34}"
    if [ "$(( total_13299 < _page_size_34 ))" != 0 ]; then
        _display_count_35="${total_13299}"
    fi
    if [ "${multi_13303}" != 0 ]; then
        _checked_46=()
        local __range_start_13348=0
        local __range_end_13348="${total_13299}"
        local __dir_13348=$(( ${__range_start_13348} <= ${__range_end_13348} ? 1 : -1 ))
        for (( ____13348=${__range_start_13348}; ____13348 * ${__dir_13348} < ${__range_end_13348} * ${__dir_13348}; ____13348+=${__dir_13348} )); do
            local array_174=(0)
            _checked_46+=("${array_174[@]}")
done
    fi
    new_line__1011_v0 "${_display_count_35}"
    local array_175=("")
    eprintf__1004_v0 "\\x1b[G" array_175[@]
    if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
        eprintf_colored__1005_v0 "Page $(( _current_page_37 + 1 ))/${_total_pages_36}" 90
    fi
    new_line__1011_v0 1
    render_tooltip_line__1173_v0 
    go_up__1012_v0 "$(( _display_count_35 + 1 ))"
    local array_176=("")
    eprintf__1004_v0 "\\x1b[G" array_176[@]
}

# chooser_page_start()
chooser_page_start__1175_v0() {
    ret_chooser_page_start1175_v0="$(( _current_page_37 * _page_size_34 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1176_v0() {
    chooser_page_start__1175_v0 
    local start_13370="${ret_chooser_page_start1175_v0}"
    local end_13371="$(( start_13370 + _page_size_34 ))"
    if [ "$(( end_13371 > _total_33 ))" != 0 ]; then
        end_13371="${_total_33}"
    fi
    ret_chooser_page_count1176_v0="$(( end_13371 - start_13370 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1177_v0() {
    local -n page_13374="${1}"
    _page_44=("${page_13374[@]}")
    local __length_177=("${page_13374[@]}")
    _page_count_45="${#__length_177[@]}"
    if [ "${_first_render_48}" != 0 ]; then
        _first_render_48=0
        render_page__1171_v0 
    else
        if [ "${_up_paged_49}" != 0 ]; then
            _selected_38="$(( _page_count_45 - 1 ))"
            _up_paged_49=0
        fi
        go_up__1012_v0 1
        remove_line__1008_v0 "$(( _display_count_35 - 1 ))"
        remove_current_line__1009_v0 
        local array_178=("")
        eprintf__1004_v0 "\\x1b[G" array_178[@]
        render_page__1171_v0 
        render_page_indicator__1172_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1178_v0() {
    local prev_selected_13406="${1}"
    chooser_page_start__1175_v0 
    local page_start_13407="${ret_chooser_page_start1175_v0}"
    local check_width_13408
    check_width_13408="$(if [ "${_multi_40}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_179="${_cursor_39}"
    local max_option_width_13409="$(( $(( _term_width_42 - ${#__length_179} )) - check_width_13408 ))"
    go_up__1012_v0 "$(( _display_count_35 - prev_selected_13406 ))"
    local array_180=("")
    eprintf__1004_v0 "\\x1b[K" array_180[@]
    local __length_181="${_cursor_39}"
    print_blank__1010_v0 "${#__length_181}"
    if [ "${_multi_40}" != 0 ]; then
        local was_checked_13410="${_checked_46[$(( page_start_13407 + prev_selected_13406 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1024_v0 "${_page_44[${prev_selected_13406}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_13409}"
        local ret_cutoff_text1024_v0__232_63="${ret_cutoff_text1024_v0}"
        local prev_line_13411
        prev_line_13411="$(if [ "${was_checked_13410}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1024_v0__232_63}"
        if [ "${was_checked_13410}" != 0 ]; then
            colored_secondary__987_v0 "${prev_line_13411}"
            local ret_colored_secondary987_v0__234_21="${ret_colored_secondary987_v0}"
            local array_182=("")
            eprintf__1004_v0 "${ret_colored_secondary987_v0__234_21}" array_182[@]
        else
            local array_183=("")
            eprintf__1004_v0 "${prev_line_13411}" array_183[@]
        fi
    else
        cutoff_text__1024_v0 "${_page_44[${prev_selected_13406}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_13409}"
        local ret_cutoff_text1024_v0__239_17="${ret_cutoff_text1024_v0}"
        local array_184=("")
        eprintf__1004_v0 "${ret_cutoff_text1024_v0__239_17}" array_184[@]
    fi
    go_up_or_down__1014_v0 "$(( _selected_38 - prev_selected_13406 ))"
    local array_185=("")
    eprintf__1004_v0 "\\x1b[G" array_185[@]
    local array_186=("")
    eprintf__1004_v0 "\\x1b[K" array_186[@]
    local mark_13413
    mark_13413="$(if [ "${_multi_40}" != 0 ]; then echo "$(if [ "${_checked_46[$(( page_start_13407 + _selected_38 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1024_v0 "${_page_44[${_selected_38}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_13409}"
    local ret_cutoff_text1024_v0__246_48="${ret_cutoff_text1024_v0}"
    colored_secondary__987_v0 "${_cursor_39}""${mark_13413}""${ret_cutoff_text1024_v0__246_48}"
    local ret_colored_secondary987_v0__246_13="${ret_colored_secondary987_v0}"
    local array_187=("")
    eprintf__1004_v0 "${ret_colored_secondary987_v0__246_13}" array_187[@]
    go_down__1013_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_188=("")
    eprintf__1004_v0 "\\x1b[G" array_188[@]
}

# redraw_current_line()
redraw_current_line__1179_v0() {
    chooser_page_start__1175_v0 
    local page_start_13400="${ret_chooser_page_start1175_v0}"
    local __length_189="${_cursor_39}"
    local max_option_width_13401="$(( $(( _term_width_42 - ${#__length_189} )) - 3 ))"
    go_up__1012_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_190=("")
    eprintf__1004_v0 "\\x1b[G" array_190[@]
    local array_191=("")
    eprintf__1004_v0 "\\x1b[K" array_191[@]
    local check_mark_13402
    check_mark_13402="$(if [ "${_checked_46[$(( page_start_13400 + _selected_38 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1024_v0 "${_page_44[${_selected_38}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_13401}"
    local ret_cutoff_text1024_v0__260_54="${ret_cutoff_text1024_v0}"
    colored_secondary__987_v0 "${_cursor_39}""${check_mark_13402}""${ret_cutoff_text1024_v0__260_54}"
    local ret_colored_secondary987_v0__260_13="${ret_colored_secondary987_v0}"
    local array_192=("")
    eprintf__1004_v0 "${ret_colored_secondary987_v0__260_13}" array_192[@]
    go_down__1013_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_193=("")
    eprintf__1004_v0 "\\x1b[G" array_193[@]
}

# chooser_step()
chooser_step__1180_v0() {
    get_key__1002_v0 
    local key_13395="${ret_get_key1002_v0}"
    local prev_selected_13396="${_selected_38}"
    local prev_page_13397="${_current_page_37}"
    chooser_page_start__1175_v0 
    local page_start_13398="${ret_chooser_page_start1175_v0}"
    _up_paged_49=0
    if [ "$(( $([ "_${key_13395}" != "_UP" ]; echo $?) || $([ "_${key_13395}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_38 == 0 )) && $(( _total_pages_36 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_37 > 0 ))" != 0 ]; then
                _current_page_37="$(( _current_page_37 - 1 ))"
            else
                _current_page_37="$(( _total_pages_36 - 1 ))"
            fi
            _up_paged_49=1
        elif [ "$(( _selected_38 == 0 ))" != 0 ]; then
            _selected_38="$(( _page_count_45 - 1 ))"
        else
            _selected_38="$(( _selected_38 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_13395}" != "_DOWN" ]; echo $?) || $([ "_${key_13395}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_38 == $(( _page_count_45 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_37 < $(( _total_pages_36 - 1 )) ))" != 0 ]; then
                _current_page_37="$(( _current_page_37 + 1 ))"
            else
                _current_page_37=0
            fi
            _selected_38=0
        else
            _selected_38="$(( _selected_38 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_13395}" != "_LEFT" ]; echo $?) || $([ "_${key_13395}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_37 > 0 ))" != 0 ]; then
            _current_page_37="$(( _current_page_37 - 1 ))"
        fi
        _selected_38=0
    elif [ "$(( $([ "_${key_13395}" != "_RIGHT" ]; echo $?) || $([ "_${key_13395}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_37 < $(( _total_pages_36 - 1 )) ))" != 0 ]; then
            _current_page_37="$(( _current_page_37 + 1 ))"
            _selected_38=0
        else
            _selected_38="$(( _page_count_45 - 1 ))"
        fi
    elif [ "$(( _multi_40 && $(( $([ "_${key_13395}" != "_x" ]; echo $?) || $([ "_${key_13395}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_13399="$(( page_start_13398 + _selected_38 ))"
        if [ "${_checked_46[${global_selected_13399}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_46["${global_selected_13399}"]=0
            _checked_count_47="$(( _checked_count_47 - 1 ))"
        elif [ "$(( $(( _limit_41 < 0 )) || $(( _checked_count_47 < _limit_41 )) ))" != 0 ]; then
            _checked_46["${global_selected_13399}"]=1
            _checked_count_47="$(( _checked_count_47 + 1 ))"
        else
            ret_chooser_step1180_v0="${__CHOOSER_CONTINUE_30}"
            return 0
        fi
        redraw_current_line__1179_v0 
        ret_chooser_step1180_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    elif [ "$(( $(( _multi_40 && $(( $([ "_${key_13395}" != "_a" ]; echo $?) || $([ "_${key_13395}" != "_A" ]; echo $?) )) )) && $(( _limit_41 < 0 )) ))" != 0 ]; then
        local all_checked_13404="$(( _checked_count_47 == _total_33 ))"
        local __range_start_13405=0
        local __range_end_13405="${_total_33}"
        local __dir_13405=$(( ${__range_start_13405} <= ${__range_end_13405} ? 1 : -1 ))
        for (( i_13405=${__range_start_13405}; i_13405 * ${__dir_13405} < ${__range_end_13405} * ${__dir_13405}; i_13405+=${__dir_13405} )); do
            _checked_46["${i_13405}"]="$(( ! all_checked_13404 ))"
done
        _checked_count_47="$(if [ "${all_checked_13404}" != 0 ]; then echo 0; else echo "${_total_33}"; fi)"
        go_up__1012_v0 "${_display_count_35}"
        local array_194=("")
        eprintf__1004_v0 "\\x1b[G" array_194[@]
        render_page__1171_v0 
        ret_chooser_step1180_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    elif [ "$([ "_${key_13395}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1180_v0="${__CHOOSER_DONE_32}"
        return 0
    else
        ret_chooser_step1180_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    fi
    if [ "$(( prev_page_13397 != _current_page_37 ))" != 0 ]; then
        ret_chooser_step1180_v0="${__CHOOSER_NEED_PAGE_31}"
        return 0
    fi
    if [ "$(( prev_selected_13396 != _selected_38 ))" != 0 ]; then
        redraw_selection__1178_v0 "${prev_selected_13396}"
    fi
    ret_chooser_step1180_v0="${__CHOOSER_CONTINUE_30}"
    return 0
}

# chooser_selected()
chooser_selected__1181_v0() {
    chooser_page_start__1175_v0 
    local ret_chooser_page_start1175_v0__362_12="${ret_chooser_page_start1175_v0}"
    ret_chooser_selected1181_v0="$(( ret_chooser_page_start1175_v0__362_12 + _selected_38 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1182_v0() {
    local index_13420="${1}"
    ret_chooser_is_checked1182_v0="${_checked_46[${index_13420}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1183_v0() {
    local total_lines_13415="$(( _display_count_35 + 2 ))"
    if [ "${_has_header_43}" != 0 ]; then
        total_lines_13415="$(( total_lines_13415 + 1 ))"
    fi
    go_down__1013_v0 1
    remove_line__1008_v0 "$(( total_lines_13415 - 1 ))"
    remove_current_line__1009_v0 
    stty_unlock__964_v0 
    show_cursor__1016_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1192_v0() {
    local -n options_13424="${1}"
    local cursor_13425="${2}"
    local header_13426="${3}"
    local page_size_13427="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_195=("${options_13424[@]}")
    local total_13428="${#__length_195[@]}"
    if [ "$(( total_13428 == 0 ))" != 0 ]; then
        eprintf_colored__1005_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1174_v0 "${total_13428}" "${page_size_13427}" "${header_13426}" "${cursor_13425}" 0 -1
    local need_page_13429=1
    while :
    do
        if [ "${need_page_13429}" != 0 ]; then
            local page_13430=()
            chooser_page_start__1175_v0 
            local start_13431="${ret_chooser_page_start1175_v0}"
            chooser_page_count__1176_v0 
            local count_13432="${ret_chooser_page_count1176_v0}"
            local __range_start_13433="${start_13431}"
            local __range_end_13433="$(( start_13431 + count_13432 ))"
            local __dir_13433=$(( ${__range_start_13433} <= ${__range_end_13433} ? 1 : -1 ))
            for (( i_13433=${__range_start_13433}; i_13433 * ${__dir_13433} < ${__range_end_13433} * ${__dir_13433}; i_13433+=${__dir_13433} )); do
                local array_197=("${options_13424[${i_13433}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_13430+=("${array_197[@]}")
done
            chooser_set_page__1177_v0 "page_13430"
        fi
        chooser_step__1180_v0 
        local step_13434="${ret_chooser_step1180_v0}"
        if [ "$(( step_13434 == __CHOOSER_DONE_32 ))" != 0 ]; then
            break
        fi
        need_page_13429="$(( step_13434 == __CHOOSER_NEED_PAGE_31 ))"
    done
    chooser_selected__1181_v0 
    local selected_13435="${ret_chooser_selected1181_v0}"
    chooser_end__1183_v0 
    ret_xyl_choose1192_v0="${options_13424[${selected_13435}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1193_v0() {
    local -n options_13293="${1}"
    local cursor_13294="${2}"
    local header_13295="${3}"
    local limit_13296="${4}"
    local page_size_13297="${5}"
    local __length_198=("${options_13293[@]}")
    local total_13298="${#__length_198[@]}"
    if [ "$(( total_13298 == 0 ))" != 0 ]; then
        eprintf_colored__1005_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1193_v0=()
        return 0
    fi
    chooser_begin__1174_v0 "${total_13298}" "${page_size_13297}" "${header_13295}" "${cursor_13294}" 1 "${limit_13296}"
    local need_page_13367=1
    while :
    do
        if [ "${need_page_13367}" != 0 ]; then
            local page_13368=()
            chooser_page_start__1175_v0 
            local start_13369="${ret_chooser_page_start1175_v0}"
            chooser_page_count__1176_v0 
            local count_13372="${ret_chooser_page_count1176_v0}"
            local __range_start_13373="${start_13369}"
            local __range_end_13373="$(( start_13369 + count_13372 ))"
            local __dir_13373=$(( ${__range_start_13373} <= ${__range_end_13373} ? 1 : -1 ))
            for (( i_13373=${__range_start_13373}; i_13373 * ${__dir_13373} < ${__range_end_13373} * ${__dir_13373}; i_13373+=${__dir_13373} )); do
                local array_201=("${options_13293[${i_13373}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_13368+=("${array_201[@]}")
done
            chooser_set_page__1177_v0 "page_13368"
        fi
        chooser_step__1180_v0 
        local step_13414="${ret_chooser_step1180_v0}"
        if [ "$(( step_13414 == __CHOOSER_DONE_32 ))" != 0 ]; then
            break
        fi
        need_page_13367="$(( step_13414 == __CHOOSER_NEED_PAGE_31 ))"
    done
    chooser_end__1183_v0 
    local result_13418=()
    local __range_start_13419=0
    local __range_end_13419="${total_13298}"
    local __dir_13419=$(( ${__range_start_13419} <= ${__range_end_13419} ? 1 : -1 ))
    for (( i_13419=${__range_start_13419}; i_13419 * ${__dir_13419} < ${__range_end_13419} * ${__dir_13419}; i_13419+=${__dir_13419} )); do
        chooser_is_checked__1182_v0 "${i_13419}"
        local ret_chooser_is_checked1182_v0__93_12="${ret_chooser_is_checked1182_v0}"
        if [ "${ret_chooser_is_checked1182_v0__93_12}" != 0 ]; then
            local array_203=("${options_13293[${i_13419}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_13418+=("${array_203[@]}")
        fi
done
    ret_xyl_multi_choose1193_v0=("${result_13418[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1286_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    printf '%s\n' ""
    colored_primary__986_v0 "choose"
    local ret_colored_primary986_v0__7_12="${ret_colored_primary986_v0}"
    local array_204=()
    printf__128_v1 "${ret_colored_primary986_v0__7_12}" array_204[@]
    local array_205=()
    printf__128_v1 " - Choose from a list of options." array_205[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__987_v0 "Arguments: "
    local ret_colored_secondary987_v0__11_12="${ret_colored_secondary987_v0}"
    local array_206=()
    printf__128_v1 "${ret_colored_secondary987_v0__11_12}""
" array_206[@]
    echo "  [<options> ...]        List of options to choose from"
    printf '%s\n' ""
    colored_secondary__987_v0 "Flags: "
    local ret_colored_secondary987_v0__14_12="${ret_colored_secondary987_v0}"
    local array_207=()
    printf__128_v1 "${ret_colored_secondary987_v0__14_12}""
" array_207[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1336_v0() {
    local options_13275=()
    local command_209
    command_209="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_13276="${command_209}"
    if [ "$([ "_${is_tty_13276}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_13275+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1336_v0=("${options_13275[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1337_v0() {
    local parameters_13258=("${!1}")
    local cursor_13259="> "
    colored_primary__986_v0 "Choose: "
    local ret_colored_primary986_v0__17_30="${ret_colored_primary986_v0}"
    local header_13274="\\x1b[1m""${ret_colored_primary986_v0__17_30}"
    read_stdin_options__1336_v0 
    local options_13277=("${ret_read_stdin_options1336_v0[@]}")
    local multi_13278=0
    local limit_13279=-1
    local page_size_13280=10
    local __length_213=("${parameters_13258[@]}")
    local slice_upper_212="${#__length_213[@]}"
    local slice_offset_214=2
    local slice_offset_214=$((${slice_offset_214} > 0 ? ${slice_offset_214} : 0))
    local slice_length_215="$(( slice_upper_212 - slice_offset_214 ))"
    local slice_length_215=$((${slice_length_215} > 0 ? ${slice_length_215} : 0))
    for param_13281 in "${parameters_13258[@]:${slice_offset_214}:${slice_length_215}}"; do
        starts_with__22_v0 "${param_13281}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_13281}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_13281}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_13281}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_13281}" != "_-h" ]; echo $?) || $([ "_${param_13281}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1286_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_216="--cursor="
            slice__24_v0 "${param_13281}" "${#__length_216}" 0
            cursor_13259="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_217="--header="
            slice__24_v0 "${param_13281}" "${#__length_217}" 0
            header_13274="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_218="--limit="
            slice__24_v0 "${param_13281}" "${#__length_218}" 0
            local value_13283="${ret_slice24_v0}"
            parse_int__13_v0 "${value_13283}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1005_v0 "ERROR: Invalid limit value: ""${value_13283}""
" 31
                exit 1
            fi
            limit_13279="${ret_parse_int13_v0}"
            multi_13278=1
        elif [ "$([ "_${param_13281}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_13278=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_219="--page-size="
            slice__24_v0 "${param_13281}" "${#__length_219}" 0
            local value_13288="${ret_slice24_v0}"
            parse_int__13_v0 "${value_13288}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1005_v0 "ERROR: Invalid page-size value: ""${value_13288}""
" 31
                exit 1
            fi
            page_size_13280="${ret_parse_int13_v0}"
        else
            options_13277+=("${param_13281}")
        fi
    done
    has_ansi_escape__1017_v0 "${header_13274}"
    local ret_has_ansi_escape1017_v0__59_44="${ret_has_ansi_escape1017_v0}"
    escape_ansi__1018_v0 "${header_13274}"
    local ret_escape_ansi1018_v0__59_73="${ret_escape_ansi1018_v0}"
    colored_primary__986_v0 "${header_13274}"
    local ret_colored_primary986_v0__59_111="${ret_colored_primary986_v0}"
    local display_header_13292
    display_header_13292="$(if [ "$(( $([ "_${header_13274}" != "_" ]; echo $?) || ret_has_ansi_escape1017_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1018_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary986_v0__59_111}"; fi)"
    if [ "${multi_13278}" != 0 ]; then
        xyl_multi_choose__1193_v0 "options_13277" "${cursor_13259}" "${display_header_13292}" "${limit_13279}" "${page_size_13280}"
        local results_13421=("${ret_xyl_multi_choose1193_v0[@]}")
        join__7_v0 results_13421[@] "
"
        ret_execute_choose1337_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1192_v0 "options_13277" "${cursor_13259}" "${display_header_13292}" "${page_size_13280}"
    ret_execute_choose1337_v0="${ret_xyl_choose1192_v0}"
    return 0
}

# Perl Extensions Utilities
command_221="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_53="$([ "_${command_221}" != "_No" ]; echo $?)"
command_222="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_54="$(( $(( ! _perl_disabled_53 )) && $([ "_${command_222}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1512_v0() {
    local text_15009="${1}"
    if [ "$(( ! _perl_available_54 ))" != 0 ]; then
        ret_perl_get_cjk_width1512_v0=''
        return 1
    fi
    local command_223
    command_223="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_15009}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1512_v0=''
        return "${__status}"
    fi
    local width_str_15010="${command_223}"
    parse_int__13_v0 "${width_str_15010}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1512_v0=''
        return "${__status}"
    fi
    local width_15011="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1512_v0="${width_15011}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1513_v0() {
    local text_15018="${1}"
    local max_width_15019="${2}"
    if [ "$(( ! _perl_available_54 ))" != 0 ]; then
        ret_perl_truncate_cjk1513_v0=''
        return 1
    fi
    local command_224
    command_224="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_15018}" ${max_width_15019} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1513_v0=''
        return "${__status}"
    fi
    local result_15020="${command_224}"
    ret_perl_truncate_cjk1513_v0="${result_15020}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_55=0
_term_size_56=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1520_v0() {
    local command_226
    command_226="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_14994="${command_226}"
    parse_int__13_v0 "${count_14994}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_14995="${ret_parse_int13_v0}"
    if [ "$(( count_num_14995 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_14995="$(( count_num_14995 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14995}
    __status=$?
}

# stty_unlock()
stty_unlock__1521_v0() {
    local command_227
    command_227="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_15091="${command_227}"
    parse_int__13_v0 "${count_15091}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_15092="${ret_parse_int13_v0}"
    if [ "$(( count_num_15092 > 0 ))" != 0 ]; then
        count_num_15092="$(( count_num_15092 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_15092}
        __status=$?
        if [ "$(( count_num_15092 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1522_v0() {
    local size_14997="${1}"
    if [ "$([ "_${size_14997}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1522_v0=0
        return 0
    fi
    split__4_v0 "${size_14997}" " "
    local parts_14998=("${ret_split4_v0[@]}")
    local __length_228=("${parts_14998[@]}")
    if [ "$(( ${#__length_228[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1522_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_14998[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_14998[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_56=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size1522_v0=1
    return 0
}

# query_term_size()
query_term_size__1523_v0() {
    local command_230
    command_230="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_15000="${command_230}"
    store_term_size__1522_v0 "${size_15000}"
    ret_query_term_size1523_v0="${ret_store_term_size1522_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1524_v0() {
    local command_231
    command_231="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_14996="${command_231}"
    store_term_size__1522_v0 "${size_14996}"
    ret_stty_term_size1524_v0="${ret_store_term_size1522_v0}"
    return 0
}

# get_term_size()
get_term_size__1525_v0() {
    stty_term_size__1524_v0 
    local detected_14999="${ret_stty_term_size1524_v0}"
    if [ "$(( ! detected_14999 ))" != 0 ]; then
        query_term_size__1523_v0 
        detected_14999="${ret_query_term_size1523_v0}"
    fi
    _got_term_size_55=1
}

# term_width()
term_width__1527_v0() {
    if [ "$(( ! _got_term_size_55 ))" != 0 ]; then
        get_term_size__1525_v0 
    fi
    ret_term_width1527_v0="${_term_size_56[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:88:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_57="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_58=0
_primary_color_59=(3 207 159 92)
_secondary_color_60=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1538_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_14977="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_14977}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_57="No"
        ret_get_supports_truecolor1538_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_57="No"
        ret_get_supports_truecolor1538_v0=0
        return 0
    fi
    local colorterm_14978="${ret_env_var_get120_v0}"
    _supports_truecolor_57="$(if [ "$(( $([ "_${colorterm_14978}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_14978}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1538_v0="$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1539_v0() {
    local message_14972="${1}"
    local r_14973="${2}"
    local g_14974="${3}"
    local b_14975="${4}"
    local fallback_14976="${5}"
    if [ "$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1539_v0="\\x1b[38;2;${r_14973};${g_14974};${b_14975}m""${message_14972}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_57}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1538_v0 
        local ret_get_supports_truecolor1538_v0__50_17="${ret_get_supports_truecolor1538_v0}"
        if [ "${ret_get_supports_truecolor1538_v0__50_17}" != 0 ]; then
            ret_colored_rgb1539_v0="\\x1b[38;2;${r_14973};${g_14974};${b_14975}m""${message_14972}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_14976 == 0 ))" != 0 ]; then
            ret_colored_rgb1539_v0="${message_14972}"
            return 0
        else
            ret_colored_rgb1539_v0="\\x1b[${fallback_14976}m""${message_14972}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_14976 == 0 ))" != 0 ]; then
            ret_colored_rgb1539_v0="${message_14972}"
            return 0
        fi
        ret_colored_rgb1539_v0="\\x1b[${fallback_14976}m""${message_14972}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1540_v0() {
    local message_15062="${1}"
    local r_15063="${2}"
    local g_15064="${3}"
    local b_15065="${4}"
    local fallback_15066="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_15067="${fallback_15066}"
    if [ "$(( $(( fallback_15066 >= 30 )) && $(( fallback_15066 <= 37 )) ))" != 0 ]; then
        bg_fallback_15067="$(( fallback_15066 + 10 ))"
    fi
    if [ "$(( $(( fallback_15066 >= 90 )) && $(( fallback_15066 <= 97 )) ))" != 0 ]; then
        bg_fallback_15067="$(( fallback_15066 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1540_v0="\\x1b[48;2;${r_15063};${g_15064};${b_15065}m""${message_15062}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_57}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1538_v0 
        local ret_get_supports_truecolor1538_v0__92_17="${ret_get_supports_truecolor1538_v0}"
        if [ "${ret_get_supports_truecolor1538_v0__92_17}" != 0 ]; then
            ret_background_rgb1540_v0="\\x1b[48;2;${r_15063};${g_15064};${b_15065}m""${message_15062}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_15067 == 0 ))" != 0 ]; then
            ret_background_rgb1540_v0="${message_15062}"
            return 0
        else
            ret_background_rgb1540_v0="\\x1b[${bg_fallback_15067}m""${message_15062}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_15067 == 0 ))" != 0 ]; then
            ret_background_rgb1540_v0="${message_15062}"
            return 0
        fi
        ret_background_rgb1540_v0="\\x1b[${bg_fallback_15067}m""${message_15062}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1541_v0() {
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_14966="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_14966}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_14966}" ";"
            local parts_14967=("${ret_split4_v0[@]}")
            local __length_235=("${parts_14967[@]}")
            if [ "$(( ${#__length_235[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14967[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14967[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14967[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14967[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_59=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_14968="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_14968}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_14968}" ";"
            local parts_14969=("${ret_split4_v0[@]}")
            local __length_237=("${parts_14969[@]}")
            if [ "$(( ${#__length_237[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14969[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14969[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14969[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14969[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_60=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_14970="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_14970}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_14970}" ";"
            local parts_14971=("${ret_split4_v0[@]}")
            local __length_239=("${parts_14971[@]}")
            if [ "$(( ${#__length_239[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14971[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14971[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14971[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14971[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_58=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1542_v0() {
    inner_get_xylitol_colors__1541_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_58=1
}

# colored_primary(message: Text)
colored_primary__1543_v0() {
    local message_14965="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1542_v0 
    fi
    colored_rgb__1539_v0 "${message_14965}" "${_primary_color_59[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_59[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_59[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_59[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1543_v0="${ret_colored_rgb1539_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1544_v0() {
    local message_14982="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1542_v0 
    fi
    colored_rgb__1539_v0 "${message_14982}" "${_secondary_color_60[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_60[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_60[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_60[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1544_v0="${ret_colored_rgb1539_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1547_v0() {
    local message_15061="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1542_v0 
    fi
    background_rgb__1540_v0 "${message_15061}" "${_secondary_color_60[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_60[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_60[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_60[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1547_v0="${ret_background_rgb1540_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1559_v0() {
    local command_241
    command_241="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_15084="${command_241}"
    if [ "$([ "_${var_15084}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1559_v0="UP"
        return 0
    elif [ "$([ "_${var_15084}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1559_v0="DOWN"
        return 0
    elif [ "$([ "_${var_15084}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1559_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_15084}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1559_v0="LEFT"
        return 0
    elif [ "$([ "_${var_15084}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1559_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_15084}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1559_v0="INPUT"
        return 0
    else
        ret_get_key1559_v0="${var_15084}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1561_v0() {
    local format_14986="${1}"
    local args_14987=("${!2}")
    args_14987=("${format_14986}" "${args_14987[@]}")
    __status=$?
    printf "${args_14987[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1562_v0() {
    local message_14984="${1}"
    local color_14985="${2}"
    # Prints an error message with a specified color.
    local array_242=("${message_14984}")
    eprintf__1561_v0 "\\x1b[${color_14985}m%s\\x1b[0m" array_242[@]
}

# colored(message: Text, color: Int)
colored__1563_v0() {
    local message_15074="${1}"
    local color_15075="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1563_v0="\\x1b[${color_15075}m""${message_15074}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1565_v0() {
    local cnt_15088="${1}"
    if [ "$(( cnt_15088 > 0 ))" != 0 ]; then
        local sequence_15089=""
        local __range_start_15090=0
        local __range_end_15090="${cnt_15088}"
        local __dir_15090=$(( ${__range_start_15090} <= ${__range_end_15090} ? 1 : -1 ))
        for (( ____15090=${__range_start_15090}; ____15090 * ${__dir_15090} < ${__range_end_15090} * ${__dir_15090}; ____15090+=${__dir_15090} )); do
            sequence_15089+="\\x1b[2K\\x1b[1A"
done
        local array_243=("")
        eprintf__1561_v0 "${sequence_15089}" array_243[@]
    fi
    local array_244=("")
    eprintf__1561_v0 "\\x1b[G" array_244[@]
}

# remove_current_line()
remove_current_line__1566_v0() {
    local array_245=("")
    eprintf__1561_v0 "\\x1b[2K\\x1b[G" array_245[@]
}

# go_up(cnt: Int)
go_up__1569_v0() {
    local cnt_15083="${1}"
    local array_246=("")
    eprintf__1561_v0 "\\x1b[${cnt_15083}A" array_246[@]
}

# go_down(cnt: Int)
go_down__1570_v0() {
    local cnt_15087="${1}"
    local array_247=("")
    eprintf__1561_v0 "\\x1b[${cnt_15087}B" array_247[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1572_v0() {
    local array_248=("")
    eprintf__1561_v0 "\\x1b[?25l" array_248[@]
}

# show_cursor()
show_cursor__1573_v0() {
    local array_249=("")
    eprintf__1561_v0 "\\x1b[?25h" array_249[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1574_v0() {
    local text_14988="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_250
    command_250="$([[ "${text_14988}" == *$'\x1b'* || "${text_14988}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_14989="${command_250}"
    ret_has_ansi_escape1574_v0="$([ "_${has_escape_14989}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1575_v0() {
    local text_14990="${1}"
    local command_251
    command_251="$(printf '%s' "${text_14990}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1575_v0="${command_251}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1576_v0() {
    local text_15005="${1}"
    local command_252
    command_252="$(printf "%s" "${text_15005}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1576_v0="${command_252}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1577_v0() {
    local text_15007="${1}"
    local command_253
    command_253="$(printf "%s" "${text_15007}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_15008="${command_253}"
    ret_is_all_ascii1577_v0="$([ "_${result_15008}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1578_v0() {
    local text_15004="${1}"
    strip_ansi__1576_v0 "${text_15004}"
    local stripped_15006="${ret_strip_ansi1576_v0}"
    # Check if text is all ASCII
    is_all_ascii__1577_v0 "${stripped_15006}"
    local ret_is_all_ascii1577_v0__150_12="${ret_is_all_ascii1577_v0}"
    if [ "$(( ! ret_is_all_ascii1577_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1512_v0 "${stripped_15006}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_254="${stripped_15006}"
            ret_get_visible_len1578_v0="${#__length_254}"
            return 0
        fi
        ret_get_visible_len1578_v0="${ret_perl_get_cjk_width1512_v0}"
        return 0
    else
        local __length_255="${stripped_15006}"
        ret_get_visible_len1578_v0="${#__length_255}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1579_v0() {
    local text_15015="${1}"
    local max_width_15016="${2}"
    get_visible_len__1578_v0 "${text_15015}"
    local visible_len_15017="${ret_get_visible_len1578_v0}"
    if [ "$(( visible_len_15017 <= max_width_15016 ))" != 0 ]; then
        ret_truncate_text1579_v0="${text_15015}"
        return 0
    fi
    is_all_ascii__1577_v0 "${text_15015}"
    local ret_is_all_ascii1577_v0__167_12="${ret_is_all_ascii1577_v0}"
    if [ "$(( ! ret_is_all_ascii1577_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1513_v0 "${text_15015}" "${max_width_15016}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_15015}" | cut -c1-${max_width_15016}
            __status=$?
        fi
        ret_truncate_text1579_v0="${ret_perl_truncate_cjk1513_v0}"
        return 0
    fi
    local command_256
    command_256="$(printf "%s" "${text_15015}" | cut -c1-${max_width_15016})"
    __status=$?
    ret_truncate_text1579_v0="${command_256}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1580_v0() {
    local text_15013="${1}"
    local max_width_15014="${2}"
    has_ansi_escape__1574_v0 "${text_15013}"
    local ret_has_ansi_escape1574_v0__179_12="${ret_has_ansi_escape1574_v0}"
    if [ "$(( ! ret_has_ansi_escape1574_v0__179_12 ))" != 0 ]; then
        truncate_text__1579_v0 "${text_15013}" "${max_width_15014}"
        ret_truncate_ansi1580_v0="${ret_truncate_text1579_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_257
    command_257="$([[ "${text_15013}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_15021="${command_257}"
    # Replace \x1b[ with newline, then split
    local command_258
    command_258="$(t="${text_15013}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_15022="${command_258}"
    split__4_v0 "${replaced_15022}" "
"
    local parts_15023=("${ret_split4_v0[@]}")
    local result_15024=""
    local remaining_width_15025="${max_width_15014}"
    local __range_start_15026=0
    local __length_259=("${parts_15023[@]}")
    local __range_end_15026="${#__length_259[@]}"
    local __dir_15026=$(( ${__range_start_15026} <= ${__range_end_15026} ? 1 : -1 ))
    for (( idx_15026=${__range_start_15026}; idx_15026 * ${__dir_15026} < ${__range_end_15026} * ${__dir_15026}; idx_15026+=${__dir_15026} )); do
        local part_15027="${parts_15023[${idx_15026}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_15026 == 0 )) && $([ "_${starts_with_ansi_15021}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_15027}" == "_" ]; echo $?) && $(( remaining_width_15025 > 0 )) ))" != 0 ]; then
                truncate_text__1579_v0 "${part_15027}" "${remaining_width_15025}"
                local ret_truncate_text1579_v0__201_35="${ret_truncate_text1579_v0}"
                local truncated_15028="${ret_truncate_text1579_v0__201_35}"
                result_15024+="${truncated_15028}"
                get_visible_len__1578_v0 "${truncated_15028}"
                local ret_get_visible_len1578_v0__203_36="${ret_get_visible_len1578_v0}"
                remaining_width_15025="$(( remaining_width_15025 - ret_get_visible_len1578_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_260
            command_260="$(__p="${part_15027}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_15029="${command_260}"
            if [ "$([ "_${m_idx_15029}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_261
                command_261="$(__p="${part_15027}"; printf "%s" "${__p:0:${m_idx_15029}}")"
                __status=$?
                local ansi_params_15030="${command_261}"
                result_15024+="\\x1b[""${ansi_params_15030}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_15029}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_15031="${ret_parse_int13_v0__214_41}"
                local text_start_15032="$(( m_idx_num_15031 + 1 ))"
                local command_262
                command_262="$(__p="${part_15027}"; printf "%s" "${__p:${text_start_15032}}")"
                __status=$?
                local text_part_15033="${command_262}"
                if [ "$(( $([ "_${text_part_15033}" == "_" ]; echo $?) && $(( remaining_width_15025 > 0 )) ))" != 0 ]; then
                    truncate_text__1579_v0 "${text_part_15033}" "${remaining_width_15025}"
                    local ret_truncate_text1579_v0__218_39="${ret_truncate_text1579_v0}"
                    local truncated_15034="${ret_truncate_text1579_v0__218_39}"
                    result_15024+="${truncated_15034}"
                    get_visible_len__1578_v0 "${truncated_15034}"
                    local ret_get_visible_len1578_v0__220_40="${ret_get_visible_len1578_v0}"
                    remaining_width_15025="$(( remaining_width_15025 - ret_get_visible_len1578_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_15027}" == "_" ]; echo $?) && $(( remaining_width_15025 > 0 )) ))" != 0 ]; then
                    truncate_text__1579_v0 "${part_15027}" "${remaining_width_15025}"
                    local ret_truncate_text1579_v0__225_39="${ret_truncate_text1579_v0}"
                    local truncated_15035="${ret_truncate_text1579_v0__225_39}"
                    result_15024+="${truncated_15035}"
                    get_visible_len__1578_v0 "${truncated_15035}"
                    local ret_get_visible_len1578_v0__227_40="${ret_get_visible_len1578_v0}"
                    remaining_width_15025="$(( remaining_width_15025 - ret_get_visible_len1578_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1580_v0="${result_15024}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1581_v0() {
    local text_15002="${1}"
    local max_width_15003="${2}"
    get_visible_len__1578_v0 "${text_15002}"
    local visible_len_15012="${ret_get_visible_len1578_v0}"
    if [ "$(( visible_len_15012 <= max_width_15003 ))" != 0 ]; then
        ret_cutoff_text1581_v0="${text_15002}"
        return 0
    fi
    truncate_ansi__1580_v0 "${text_15002}" "$(( max_width_15003 - 3 ))"
    local ret_truncate_ansi1580_v0__243_12="${ret_truncate_ansi1580_v0}"
    ret_cutoff_text1581_v0="${ret_truncate_ansi1580_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1582_v0() {
    local items_15068=("${!1}")
    local total_len_15069="${2}"
    local term_width_15070="${3}"
    local separator_15071=" • "
    local separator_len_15072=3
    # Fast path: no truncation needed
    if [ "$(( total_len_15069 <= term_width_15070 ))" != 0 ]; then
        local iter_15073=0
        while :
        do
            local __length_263=("${items_15068[@]}")
            if [ "$(( iter_15073 >= ${#__length_263[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_15073 > 0 ))" != 0 ]; then
                eprintf_colored__1562_v0 "${separator_15071}" 90
            fi
            colored__1563_v0 "${items_15068[$(( iter_15073 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1563_v0__268_41="${ret_colored1563_v0}"
            local array_264=("")
            eprintf__1561_v0 "${items_15068[${iter_15073}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1563_v0__268_41}" array_264[@]
            iter_15073="$(( iter_15073 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_15076=0
        local first_15077=1
        local iter_15078=0
        while :
        do
            local __length_265=("${items_15068[@]}")
            if [ "$(( iter_15078 >= ${#__length_265[@]} ))" != 0 ]; then
                break
            fi
            local key_15079="${items_15068[${iter_15078}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_15080="${items_15068[$(( iter_15078 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_266="${key_15079}"
            local __length_267="${action_15080}"
            local part_len_15081="$(( $(( ${#__length_266} + 1 )) + ${#__length_267} ))"
            local needed_15082="${part_len_15081}"
            if [ "$(( ! first_15077 ))" != 0 ]; then
                needed_15082="$(( needed_15082 + separator_len_15072 ))"
            fi
            if [ "$(( $(( current_len_15076 + needed_15082 )) > term_width_15070 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_15077 ))" != 0 ]; then
                eprintf_colored__1562_v0 "${separator_15071}" 90
            fi
            colored__1563_v0 "${action_15080}" 2
            local ret_colored1563_v0__296_33="${ret_colored1563_v0}"
            local array_268=("")
            eprintf__1561_v0 "${key_15079}"" ""${ret_colored1563_v0__296_33}" array_268[@]
            current_len_15076="$(( current_len_15076 + needed_15082 ))"
            first_15077=0
            iter_15078="$(( iter_15078 + 2 ))"
        done
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1631_v0() {
    local selected_15037="${1}"
    local term_width_15038="${2}"
    local small_15039="$(( term_width_15038 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_15039}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_15058="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_15039}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_15059="${ret_cpad29_v0}"
    local gap_15060
    gap_15060="$(if [ "${small_15039}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_269=("")
    eprintf__1561_v0 " " array_269[@]
    if [ "${selected_15037}" != 0 ]; then
        # Yes selected
        background_secondary__1547_v0 "${yes_label_15058}"
        local ret_background_secondary1547_v0__16_30="${ret_background_secondary1547_v0}"
        local array_270=("")
        eprintf__1561_v0 "\\x1b[97m""${ret_background_secondary1547_v0__16_30}" array_270[@]
        local array_271=("")
        eprintf__1561_v0 "${gap_15060}" array_271[@]
        # No not selected (dim)
        local array_272=("")
        eprintf__1561_v0 "\\x1b[49;37m""${no_label_15059}""\\x1b[0m" array_272[@]
    else
        # No selected
        local array_273=("")
        eprintf__1561_v0 "\\x1b[49;37m""${yes_label_15058}""\\x1b[0m" array_273[@]
        local array_274=("")
        eprintf__1561_v0 "${gap_15060}" array_274[@]
        background_secondary__1547_v0 "${no_label_15059}"
        local ret_background_secondary1547_v0__24_30="${ret_background_secondary1547_v0}"
        local array_275=("")
        eprintf__1561_v0 "\\x1b[97m""${ret_background_secondary1547_v0__24_30}" array_275[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1632_v0() {
    local header_14992="${1}"
    local default_yes_14993="${2}"
    stty_lock__1520_v0 
    hide_cursor__1572_v0 
    term_width__1527_v0 
    local term_width_15001="${ret_term_width1527_v0}"
    if [ "$([ "_${header_14992}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1581_v0 "${header_14992}" "${term_width_15001}"
        local ret_cutoff_text1581_v0__46_17="${ret_cutoff_text1581_v0}"
        local array_276=("")
        eprintf__1561_v0 "${ret_cutoff_text1581_v0__46_17}""

" array_276[@]
    fi
    local selected_15036="${default_yes_14993}"
    # Render initial options
    render_confirm_options__1631_v0 "${selected_15036}" "${term_width_15001}"
    local array_277=("")
    eprintf__1561_v0 "

" array_277[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_278=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1582_v0 array_278[@] 40 "${term_width_15001}"
    go_up__1569_v0 2
    while :
    do
        get_key__1559_v0 
        local key_15085="${ret_get_key1559_v0}"
        if [ "$(( $(( $(( $([ "_${key_15085}" != "_LEFT" ]; echo $?) || $([ "_${key_15085}" != "_h" ]; echo $?) )) || $([ "_${key_15085}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_15085}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_15036}" != 0 ]; then
                selected_15036=0
                local array_279=("")
                eprintf__1561_v0 "\\x1b[G\\x1b[K" array_279[@]
                render_confirm_options__1631_v0 "${selected_15036}" "${term_width_15001}"
            elif [ "$(( ! selected_15036 ))" != 0 ]; then
                selected_15036=1
                local array_280=("")
                eprintf__1561_v0 "\\x1b[G\\x1b[K" array_280[@]
                render_confirm_options__1631_v0 "${selected_15036}" "${term_width_15001}"
            fi
        elif [ "$(( $([ "_${key_15085}" != "_y" ]; echo $?) || $([ "_${key_15085}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_15036=1
            break
        elif [ "$(( $([ "_${key_15085}" != "_n" ]; echo $?) || $([ "_${key_15085}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_15036=0
            break
        elif [ "$([ "_${key_15085}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_15086=4
    if [ "$([ "_${header_14992}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_15086="$(( total_lines_15086 + 1 ))"
    fi
    go_down__1570_v0 2
    remove_line__1565_v0 "$(( total_lines_15086 - 1 ))"
    remove_current_line__1566_v0 
    stty_unlock__1521_v0 
    show_cursor__1573_v0 
    ret_xyl_confirm1632_v0="${selected_15036}"
    return 0
}

# print_confirm_help()
print_confirm_help__1724_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    printf '%s\n' ""
    colored_primary__1543_v0 "confirm"
    local ret_colored_primary1543_v0__7_12="${ret_colored_primary1543_v0}"
    local array_281=()
    printf__128_v1 "${ret_colored_primary1543_v0__7_12}" array_281[@]
    local array_282=()
    printf__128_v1 " - Display a Yes/No confirmation dialog." array_282[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1544_v0 "Flags: "
    local ret_colored_secondary1544_v0__11_12="${ret_colored_secondary1544_v0}"
    local array_283=()
    printf__128_v1 "${ret_colored_secondary1544_v0__11_12}""
" array_283[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1774_v0() {
    local parameters_14964=("${!1}")
    colored_primary__1543_v0 "Are you sure?"
    local ret_colored_primary1543_v0__9_30="${ret_colored_primary1543_v0}"
    local header_14979="\\x1b[1m""${ret_colored_primary1543_v0__9_30}"
    local default_yes_14980=1
    for param_14981 in "${parameters_14964[@]}"; do
        starts_with__22_v0 "${param_14981}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14981}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_14981}" != "_-h" ]; echo $?) || $([ "_${param_14981}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1724_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_286="--header="
            slice__24_v0 "${param_14981}" "${#__length_286}" 0
            header_14979="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_287="--default="
            slice__24_v0 "${param_14981}" "${#__length_287}" 0
            local value_14983="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_14983}" != "_yes" ]; echo $?) || $([ "_${value_14983}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_14980=1
            elif [ "$(( $([ "_${value_14983}" != "_no" ]; echo $?) || $([ "_${value_14983}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_14980=0
            else
                eprintf_colored__1562_v0 "ERROR: Invalid default value: ""${value_14983}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1574_v0 "${header_14979}"
    local ret_has_ansi_escape1574_v0__35_44="${ret_has_ansi_escape1574_v0}"
    escape_ansi__1575_v0 "${header_14979}"
    local ret_escape_ansi1575_v0__35_73="${ret_escape_ansi1575_v0}"
    colored_primary__1543_v0 "${header_14979}"
    local ret_colored_primary1543_v0__35_111="${ret_colored_primary1543_v0}"
    local display_header_14991
    display_header_14991="$(if [ "$(( $([ "_${header_14979}" != "_" ]; echo $?) || ret_has_ansi_escape1574_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1575_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1543_v0__35_111}"; fi)"
    xyl_confirm__1632_v0 "${display_header_14991}" "${default_yes_14980}"
    local result_15093="${ret_xyl_confirm1632_v0}"
    ret_execute_confirm1774_v0="$(if [ "${result_15093}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# get_directory_entries(path: Text, names: [Text], types: [Text], targets: [Text])
get_directory_entries__1929_v0() {
    local path_23090="${1}"
    local -n names_23091="${2}"
    local -n types_23092="${3}"
    local -n targets_23093="${4}"
    local __ls_path_288="${path_23090}"
    __ls_path_288="${__ls_path_288//\\/\\\\}"
    (( 1 )) && __ls_all_288="-A" || __ls_all_288=""
    (( 0 )) && __ls_rec_288="-R" || __ls_rec_288=""
    local __ls_288=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_288 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_288} ${__ls_rec_288} ${__ls_path_288}
    __status=$?
    );
    names_23091+=("${__ls_288[@]}")
    local command_289
    command_289="$(LC_ALL=C ls -lA "${path_23090}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_23094="${command_289}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_290
    command_290="$(LC_ALL=C ls -lA "${path_23090}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_23095="${command_290}"
    split__4_v0 "${types_output_23094}" "
"
    types_23092+=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_23095}" "
"
    local ret_split4_v0__21_19=("${ret_split4_v0[@]}")
    for marked_23096 in "${ret_split4_v0__21_19[@]}"; do
        slice__24_v0 "${marked_23096}" 1 0
        local ret_slice24_v0__22_21="${ret_slice24_v0}"
        targets_23093+=("${ret_slice24_v0__22_21}")
    done
}

# get_cwd()
get_cwd__1930_v0() {
    local command_294
    command_294="$(pwd)"
    __status=$?
    ret_get_cwd1930_v0="${command_294}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1931_v0() {
    local path_23085="${1}"
    local command_295
    command_295="$(cd "${path_23085}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_23086="${command_295}"
    if [ "$([ "_${normalized_23086}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1931_v0="${path_23085}"
        return 0
    fi
    ret_normalize_path1931_v0="${normalized_23086}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1932_v0() {
    local base_23254="${1}"
    local child_23255="${2}"
    if [ "$([ "_${base_23254}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1932_v0="/""${child_23255}"
        return 0
    fi
    ret_path_join1932_v0="${base_23254}""/""${child_23255}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1933_v0() {
    local path_23252="${1}"
    local command_296
    command_296="$(dirname "${path_23252}")"
    __status=$?
    local parent_23253="${command_296}"
    ret_get_parent_dir1933_v0="${parent_23253}"
    return 0
}

# Perl Extensions Utilities
command_297="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_62="$([ "_${command_297}" != "_No" ]; echo $?)"
command_298="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_63="$(( $(( ! _perl_disabled_62 )) && $([ "_${command_298}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1949_v0() {
    local command_300
    command_300="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_23082="${command_300}"
    parse_int__13_v0 "${count_23082}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_23083="${ret_parse_int13_v0}"
    if [ "$(( count_num_23083 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_23083="$(( count_num_23083 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23083}
    __status=$?
}

# stty_unlock()
stty_unlock__1950_v0() {
    local command_301
    command_301="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_23103="${command_301}"
    parse_int__13_v0 "${count_23103}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_23104="${ret_parse_int13_v0}"
    if [ "$(( count_num_23104 > 0 ))" != 0 ]; then
        count_num_23104="$(( count_num_23104 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23104}
        __status=$?
        if [ "$(( count_num_23104 == 0 ))" != 0 ]; then
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
_supports_truecolor_66="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_67=0
_primary_color_68=(3 207 159 92)
_secondary_color_69=(3 118 206 94)
_accent_color_70=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__1967_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_23070="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_23070}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_66="No"
        ret_get_supports_truecolor1967_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_66="No"
        ret_get_supports_truecolor1967_v0=0
        return 0
    fi
    local colorterm_23071="${ret_env_var_get120_v0}"
    _supports_truecolor_66="$(if [ "$(( $([ "_${colorterm_23071}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_23071}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1967_v0="$([ "_${_supports_truecolor_66}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1968_v0() {
    local message_23065="${1}"
    local r_23066="${2}"
    local g_23067="${3}"
    local b_23068="${4}"
    local fallback_23069="${5}"
    if [ "$([ "_${_supports_truecolor_66}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1968_v0="\\x1b[38;2;${r_23066};${g_23067};${b_23068}m""${message_23065}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_66}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1967_v0 
        local ret_get_supports_truecolor1967_v0__50_17="${ret_get_supports_truecolor1967_v0}"
        if [ "${ret_get_supports_truecolor1967_v0__50_17}" != 0 ]; then
            ret_colored_rgb1968_v0="\\x1b[38;2;${r_23066};${g_23067};${b_23068}m""${message_23065}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_23069 == 0 ))" != 0 ]; then
            ret_colored_rgb1968_v0="${message_23065}"
            return 0
        else
            ret_colored_rgb1968_v0="\\x1b[${fallback_23069}m""${message_23065}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_23069 == 0 ))" != 0 ]; then
            ret_colored_rgb1968_v0="${message_23065}"
            return 0
        fi
        ret_colored_rgb1968_v0="\\x1b[${fallback_23069}m""${message_23065}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1970_v0() {
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_23059="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_23059}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_23059}" ";"
            local parts_23060=("${ret_split4_v0[@]}")
            local __length_305=("${parts_23060[@]}")
            if [ "$(( ${#__length_305[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23060[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23060[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23060[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23060[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_68=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_23061="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_23061}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_23061}" ";"
            local parts_23062=("${ret_split4_v0[@]}")
            local __length_307=("${parts_23062[@]}")
            if [ "$(( ${#__length_307[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23062[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23062[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23062[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23062[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_69=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_23063="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_23063}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_23063}" ";"
            local parts_23064=("${ret_split4_v0[@]}")
            local __length_309=("${parts_23064[@]}")
            if [ "$(( ${#__length_309[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23064[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23064[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23064[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23064[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1970_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_70=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_67=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1971_v0() {
    inner_get_xylitol_colors__1970_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_67=1
}

# colored_primary(message: Text)
colored_primary__1972_v0() {
    local message_23058="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__1971_v0 
    fi
    colored_rgb__1968_v0 "${message_23058}" "${_primary_color_68[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_68[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_68[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_68[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1972_v0="${ret_colored_rgb1968_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1973_v0() {
    local message_23072="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__1971_v0 
    fi
    colored_rgb__1968_v0 "${message_23072}" "${_secondary_color_69[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_69[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_69[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_69[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1973_v0="${ret_colored_rgb1968_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__1974_v0() {
    local message_23190="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__1971_v0 
    fi
    colored_rgb__1968_v0 "${message_23190}" "${_accent_color_70[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_70[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_70[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_70[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent1974_v0="${ret_colored_rgb1968_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__1990_v0() {
    local format_23076="${1}"
    local args_23077=("${!2}")
    args_23077=("${format_23076}" "${args_23077[@]}")
    __status=$?
    printf "${args_23077[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1991_v0() {
    local message_23074="${1}"
    local color_23075="${2}"
    # Prints an error message with a specified color.
    local array_311=("${message_23074}")
    eprintf__1990_v0 "\\x1b[${color_23075}m%s\\x1b[0m" array_311[@]
}

# remove_current_line()
remove_current_line__1995_v0() {
    local array_312=("")
    eprintf__1990_v0 "\\x1b[2K\\x1b[G" array_312[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_313="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_71="$([ "_${command_313}" != "_No" ]; echo $?)"
command_314="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_72="$(( $(( ! _perl_disabled_71 )) && $([ "_${command_314}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2160_v0() {
    local text_23130="${1}"
    if [ "$(( ! _perl_available_72 ))" != 0 ]; then
        ret_perl_get_cjk_width2160_v0=''
        return 1
    fi
    local command_315
    command_315="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_23130}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2160_v0=''
        return "${__status}"
    fi
    local width_str_23131="${command_315}"
    parse_int__13_v0 "${width_str_23131}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2160_v0=''
        return "${__status}"
    fi
    local width_23132="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2160_v0="${width_23132}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2161_v0() {
    local text_23141="${1}"
    local max_width_23142="${2}"
    if [ "$(( ! _perl_available_72 ))" != 0 ]; then
        ret_perl_truncate_cjk2161_v0=''
        return 1
    fi
    local command_316
    command_316="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_23141}" ${max_width_23142} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2161_v0=''
        return "${__status}"
    fi
    local result_23143="${command_316}"
    ret_perl_truncate_cjk2161_v0="${result_23143}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_73=0
_term_size_74=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__2168_v0() {
    local command_318
    command_318="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_23112="${command_318}"
    parse_int__13_v0 "${count_23112}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_23113="${ret_parse_int13_v0}"
    if [ "$(( count_num_23113 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_23113="$(( count_num_23113 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23113}
    __status=$?
}

# stty_unlock()
stty_unlock__2169_v0() {
    local command_319
    command_319="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_23248="${command_319}"
    parse_int__13_v0 "${count_23248}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_23249="${ret_parse_int13_v0}"
    if [ "$(( count_num_23249 > 0 ))" != 0 ]; then
        count_num_23249="$(( count_num_23249 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23249}
        __status=$?
        if [ "$(( count_num_23249 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2170_v0() {
    local size_23117="${1}"
    if [ "$([ "_${size_23117}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2170_v0=0
        return 0
    fi
    split__4_v0 "${size_23117}" " "
    local parts_23118=("${ret_split4_v0[@]}")
    local __length_320=("${parts_23118[@]}")
    if [ "$(( ${#__length_320[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2170_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_23118[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_23118[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_74=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size2170_v0=1
    return 0
}

# query_term_size()
query_term_size__2171_v0() {
    local command_322
    command_322="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_23120="${command_322}"
    store_term_size__2170_v0 "${size_23120}"
    ret_query_term_size2171_v0="${ret_store_term_size2170_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2172_v0() {
    local command_323
    command_323="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_23116="${command_323}"
    store_term_size__2170_v0 "${size_23116}"
    ret_stty_term_size2172_v0="${ret_store_term_size2170_v0}"
    return 0
}

# get_term_size()
get_term_size__2173_v0() {
    stty_term_size__2172_v0 
    local detected_23119="${ret_stty_term_size2172_v0}"
    if [ "$(( ! detected_23119 ))" != 0 ]; then
        query_term_size__2171_v0 
        detected_23119="${ret_query_term_size2171_v0}"
    fi
    _got_term_size_73=1
}

# term_width()
term_width__2175_v0() {
    if [ "$(( ! _got_term_size_73 ))" != 0 ]; then
        get_term_size__2173_v0 
    fi
    ret_term_width2175_v0="${_term_size_74[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:88:23)"}"
    return 0
}

# term_height()
term_height__2176_v0() {
    if [ "$(( ! _got_term_size_73 ))" != 0 ]; then
        get_term_size__2173_v0 
    fi
    ret_term_height2176_v0="${_term_size_74[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_75="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_76=0
_secondary_color_78=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2186_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_23211="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_23211}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_75="No"
        ret_get_supports_truecolor2186_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_75="No"
        ret_get_supports_truecolor2186_v0=0
        return 0
    fi
    local colorterm_23212="${ret_env_var_get120_v0}"
    _supports_truecolor_75="$(if [ "$(( $([ "_${colorterm_23212}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_23212}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2186_v0="$([ "_${_supports_truecolor_75}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2187_v0() {
    local message_23206="${1}"
    local r_23207="${2}"
    local g_23208="${3}"
    local b_23209="${4}"
    local fallback_23210="${5}"
    if [ "$([ "_${_supports_truecolor_75}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2187_v0="\\x1b[38;2;${r_23207};${g_23208};${b_23209}m""${message_23206}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_75}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2186_v0 
        local ret_get_supports_truecolor2186_v0__50_17="${ret_get_supports_truecolor2186_v0}"
        if [ "${ret_get_supports_truecolor2186_v0__50_17}" != 0 ]; then
            ret_colored_rgb2187_v0="\\x1b[38;2;${r_23207};${g_23208};${b_23209}m""${message_23206}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_23210 == 0 ))" != 0 ]; then
            ret_colored_rgb2187_v0="${message_23206}"
            return 0
        else
            ret_colored_rgb2187_v0="\\x1b[${fallback_23210}m""${message_23206}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_23210 == 0 ))" != 0 ]; then
            ret_colored_rgb2187_v0="${message_23206}"
            return 0
        fi
        ret_colored_rgb2187_v0="\\x1b[${fallback_23210}m""${message_23206}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2189_v0() {
    if [ "$(( ! _got_xylitol_colors_76 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_23200="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_23200}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_23200}" ";"
            local parts_23201=("${ret_split4_v0[@]}")
            local __length_327=("${parts_23201[@]}")
            if [ "$(( ${#__length_327[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23201[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23201[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23201[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23201[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
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
        local secondary_env_23202="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_23202}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_23202}" ";"
            local parts_23203=("${ret_split4_v0[@]}")
            local __length_329=("${parts_23203[@]}")
            if [ "$(( ${#__length_329[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23203[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23203[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23203[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23203[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_78=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_23204="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_23204}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_23204}" ";"
            local parts_23205=("${ret_split4_v0[@]}")
            local __length_331=("${parts_23205[@]}")
            if [ "$(( ${#__length_331[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23205[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23205[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23205[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23205[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2189_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_76=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2190_v0() {
    inner_get_xylitol_colors__2189_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_76=1
}

# colored_secondary(message: Text)
colored_secondary__2192_v0() {
    local message_23199="${1}"
    if [ "$(( ! _got_xylitol_colors_76 ))" != 0 ]; then
        get_xylitol_colors__2190_v0 
    fi
    colored_rgb__2187_v0 "${message_23199}" "${_secondary_color_78[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_78[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_78[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_78[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2192_v0="${ret_colored_rgb2187_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2207_v0() {
    local command_333
    command_333="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_23225="${command_333}"
    if [ "$([ "_${var_23225}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2207_v0="UP"
        return 0
    elif [ "$([ "_${var_23225}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2207_v0="DOWN"
        return 0
    elif [ "$([ "_${var_23225}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2207_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_23225}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2207_v0="LEFT"
        return 0
    elif [ "$([ "_${var_23225}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2207_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_23225}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2207_v0="INPUT"
        return 0
    else
        ret_get_key2207_v0="${var_23225}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2209_v0() {
    local format_23114="${1}"
    local args_23115=("${!2}")
    args_23115=("${format_23114}" "${args_23115[@]}")
    __status=$?
    printf "${args_23115[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2210_v0() {
    local message_23162="${1}"
    local color_23163="${2}"
    # Prints an error message with a specified color.
    local array_334=("${message_23162}")
    eprintf__2209_v0 "\\x1b[${color_23163}m%s\\x1b[0m" array_334[@]
}

# colored(message: Text, color: Int)
colored__2211_v0() {
    local message_23170="${1}"
    local color_23171="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2211_v0="\\x1b[${color_23171}m""${message_23170}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2213_v0() {
    local cnt_23222="${1}"
    if [ "$(( cnt_23222 > 0 ))" != 0 ]; then
        local sequence_23223=""
        local __range_start_23224=0
        local __range_end_23224="${cnt_23222}"
        local __dir_23224=$(( ${__range_start_23224} <= ${__range_end_23224} ? 1 : -1 ))
        for (( ____23224=${__range_start_23224}; ____23224 * ${__dir_23224} < ${__range_end_23224} * ${__dir_23224}; ____23224+=${__dir_23224} )); do
            sequence_23223+="\\x1b[2K\\x1b[1A"
done
        local array_335=("")
        eprintf__2209_v0 "${sequence_23223}" array_335[@]
    fi
    local array_336=("")
    eprintf__2209_v0 "\\x1b[G" array_336[@]
}

# remove_current_line()
remove_current_line__2214_v0() {
    local array_337=("")
    eprintf__2209_v0 "\\x1b[2K\\x1b[G" array_337[@]
}

# print_blank(cnt: Int)
print_blank__2215_v0() {
    local cnt_23213="${1}"
    printf '%*s' "${cnt_23213}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2216_v0() {
    local cnt_23160="${1}"
    local __range_start_23161=0
    local __range_end_23161="${cnt_23160}"
    local __dir_23161=$(( ${__range_start_23161} <= ${__range_end_23161} ? 1 : -1 ))
    for (( ____23161=${__range_start_23161}; ____23161 * ${__dir_23161} < ${__range_end_23161} * ${__dir_23161}; ____23161+=${__dir_23161} )); do
        local array_338=("")
        eprintf__2209_v0 "
" array_338[@]
done
}

# go_up(cnt: Int)
go_up__2217_v0() {
    local cnt_23179="${1}"
    local array_339=("")
    eprintf__2209_v0 "\\x1b[${cnt_23179}A" array_339[@]
}

# go_down(cnt: Int)
go_down__2218_v0() {
    local cnt_23234="${1}"
    local array_340=("")
    eprintf__2209_v0 "\\x1b[${cnt_23234}B" array_340[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2219_v0() {
    local cnt_23243="${1}"
    if [ "$(( cnt_23243 > 0 ))" != 0 ]; then
        go_down__2218_v0 "${cnt_23243}"
    else
        go_up__2217_v0 "$(( - cnt_23243 ))"
    fi
}

# hide_cursor()
hide_cursor__2220_v0() {
    local array_341=("")
    eprintf__2209_v0 "\\x1b[?25l" array_341[@]
}

# show_cursor()
show_cursor__2221_v0() {
    local array_342=("")
    eprintf__2209_v0 "\\x1b[?25h" array_342[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2222_v0() {
    local text_23136="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_343
    command_343="$([[ "${text_23136}" == *$'\x1b'* || "${text_23136}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_23137="${command_343}"
    ret_has_ansi_escape2222_v0="$([ "_${has_escape_23137}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2224_v0() {
    local text_23126="${1}"
    local command_344
    command_344="$(printf "%s" "${text_23126}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2224_v0="${command_344}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2225_v0() {
    local text_23128="${1}"
    local command_345
    command_345="$(printf "%s" "${text_23128}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_23129="${command_345}"
    ret_is_all_ascii2225_v0="$([ "_${result_23129}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2226_v0() {
    local text_23125="${1}"
    strip_ansi__2224_v0 "${text_23125}"
    local stripped_23127="${ret_strip_ansi2224_v0}"
    # Check if text is all ASCII
    is_all_ascii__2225_v0 "${stripped_23127}"
    local ret_is_all_ascii2225_v0__150_12="${ret_is_all_ascii2225_v0}"
    if [ "$(( ! ret_is_all_ascii2225_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2160_v0 "${stripped_23127}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_346="${stripped_23127}"
            ret_get_visible_len2226_v0="${#__length_346}"
            return 0
        fi
        ret_get_visible_len2226_v0="${ret_perl_get_cjk_width2160_v0}"
        return 0
    else
        local __length_347="${stripped_23127}"
        ret_get_visible_len2226_v0="${#__length_347}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2227_v0() {
    local text_23138="${1}"
    local max_width_23139="${2}"
    get_visible_len__2226_v0 "${text_23138}"
    local visible_len_23140="${ret_get_visible_len2226_v0}"
    if [ "$(( visible_len_23140 <= max_width_23139 ))" != 0 ]; then
        ret_truncate_text2227_v0="${text_23138}"
        return 0
    fi
    is_all_ascii__2225_v0 "${text_23138}"
    local ret_is_all_ascii2225_v0__167_12="${ret_is_all_ascii2225_v0}"
    if [ "$(( ! ret_is_all_ascii2225_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2161_v0 "${text_23138}" "${max_width_23139}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_23138}" | cut -c1-${max_width_23139}
            __status=$?
        fi
        ret_truncate_text2227_v0="${ret_perl_truncate_cjk2161_v0}"
        return 0
    fi
    local command_348
    command_348="$(printf "%s" "${text_23138}" | cut -c1-${max_width_23139})"
    __status=$?
    ret_truncate_text2227_v0="${command_348}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2228_v0() {
    local text_23134="${1}"
    local max_width_23135="${2}"
    has_ansi_escape__2222_v0 "${text_23134}"
    local ret_has_ansi_escape2222_v0__179_12="${ret_has_ansi_escape2222_v0}"
    if [ "$(( ! ret_has_ansi_escape2222_v0__179_12 ))" != 0 ]; then
        truncate_text__2227_v0 "${text_23134}" "${max_width_23135}"
        ret_truncate_ansi2228_v0="${ret_truncate_text2227_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_349
    command_349="$([[ "${text_23134}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_23144="${command_349}"
    # Replace \x1b[ with newline, then split
    local command_350
    command_350="$(t="${text_23134}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_23145="${command_350}"
    split__4_v0 "${replaced_23145}" "
"
    local parts_23146=("${ret_split4_v0[@]}")
    local result_23147=""
    local remaining_width_23148="${max_width_23135}"
    local __range_start_23149=0
    local __length_351=("${parts_23146[@]}")
    local __range_end_23149="${#__length_351[@]}"
    local __dir_23149=$(( ${__range_start_23149} <= ${__range_end_23149} ? 1 : -1 ))
    for (( idx_23149=${__range_start_23149}; idx_23149 * ${__dir_23149} < ${__range_end_23149} * ${__dir_23149}; idx_23149+=${__dir_23149} )); do
        local part_23150="${parts_23146[${idx_23149}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_23149 == 0 )) && $([ "_${starts_with_ansi_23144}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_23150}" == "_" ]; echo $?) && $(( remaining_width_23148 > 0 )) ))" != 0 ]; then
                truncate_text__2227_v0 "${part_23150}" "${remaining_width_23148}"
                local ret_truncate_text2227_v0__201_35="${ret_truncate_text2227_v0}"
                local truncated_23151="${ret_truncate_text2227_v0__201_35}"
                result_23147+="${truncated_23151}"
                get_visible_len__2226_v0 "${truncated_23151}"
                local ret_get_visible_len2226_v0__203_36="${ret_get_visible_len2226_v0}"
                remaining_width_23148="$(( remaining_width_23148 - ret_get_visible_len2226_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_352
            command_352="$(__p="${part_23150}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_23152="${command_352}"
            if [ "$([ "_${m_idx_23152}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_353
                command_353="$(__p="${part_23150}"; printf "%s" "${__p:0:${m_idx_23152}}")"
                __status=$?
                local ansi_params_23153="${command_353}"
                result_23147+="\\x1b[""${ansi_params_23153}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_23152}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_23154="${ret_parse_int13_v0__214_41}"
                local text_start_23155="$(( m_idx_num_23154 + 1 ))"
                local command_354
                command_354="$(__p="${part_23150}"; printf "%s" "${__p:${text_start_23155}}")"
                __status=$?
                local text_part_23156="${command_354}"
                if [ "$(( $([ "_${text_part_23156}" == "_" ]; echo $?) && $(( remaining_width_23148 > 0 )) ))" != 0 ]; then
                    truncate_text__2227_v0 "${text_part_23156}" "${remaining_width_23148}"
                    local ret_truncate_text2227_v0__218_39="${ret_truncate_text2227_v0}"
                    local truncated_23157="${ret_truncate_text2227_v0__218_39}"
                    result_23147+="${truncated_23157}"
                    get_visible_len__2226_v0 "${truncated_23157}"
                    local ret_get_visible_len2226_v0__220_40="${ret_get_visible_len2226_v0}"
                    remaining_width_23148="$(( remaining_width_23148 - ret_get_visible_len2226_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_23150}" == "_" ]; echo $?) && $(( remaining_width_23148 > 0 )) ))" != 0 ]; then
                    truncate_text__2227_v0 "${part_23150}" "${remaining_width_23148}"
                    local ret_truncate_text2227_v0__225_39="${ret_truncate_text2227_v0}"
                    local truncated_23158="${ret_truncate_text2227_v0__225_39}"
                    result_23147+="${truncated_23158}"
                    get_visible_len__2226_v0 "${truncated_23158}"
                    local ret_get_visible_len2226_v0__227_40="${ret_get_visible_len2226_v0}"
                    remaining_width_23148="$(( remaining_width_23148 - ret_get_visible_len2226_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2228_v0="${result_23147}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2229_v0() {
    local text_23123="${1}"
    local max_width_23124="${2}"
    get_visible_len__2226_v0 "${text_23123}"
    local visible_len_23133="${ret_get_visible_len2226_v0}"
    if [ "$(( visible_len_23133 <= max_width_23124 ))" != 0 ]; then
        ret_cutoff_text2229_v0="${text_23123}"
        return 0
    fi
    truncate_ansi__2228_v0 "${text_23123}" "$(( max_width_23124 - 3 ))"
    local ret_truncate_ansi2228_v0__243_12="${ret_truncate_ansi2228_v0}"
    ret_cutoff_text2229_v0="${ret_truncate_ansi2228_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2230_v0() {
    local items_23164=("${!1}")
    local total_len_23165="${2}"
    local term_width_23166="${3}"
    local separator_23167=" • "
    local separator_len_23168=3
    # Fast path: no truncation needed
    if [ "$(( total_len_23165 <= term_width_23166 ))" != 0 ]; then
        local iter_23169=0
        while :
        do
            local __length_355=("${items_23164[@]}")
            if [ "$(( iter_23169 >= ${#__length_355[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_23169 > 0 ))" != 0 ]; then
                eprintf_colored__2210_v0 "${separator_23167}" 90
            fi
            colored__2211_v0 "${items_23164[$(( iter_23169 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2211_v0__268_41="${ret_colored2211_v0}"
            local array_356=("")
            eprintf__2209_v0 "${items_23164[${iter_23169}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2211_v0__268_41}" array_356[@]
            iter_23169="$(( iter_23169 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_23172=0
        local first_23173=1
        local iter_23174=0
        while :
        do
            local __length_357=("${items_23164[@]}")
            if [ "$(( iter_23174 >= ${#__length_357[@]} ))" != 0 ]; then
                break
            fi
            local key_23175="${items_23164[${iter_23174}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_23176="${items_23164[$(( iter_23174 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_358="${key_23175}"
            local __length_359="${action_23176}"
            local part_len_23177="$(( $(( ${#__length_358} + 1 )) + ${#__length_359} ))"
            local needed_23178="${part_len_23177}"
            if [ "$(( ! first_23173 ))" != 0 ]; then
                needed_23178="$(( needed_23178 + separator_len_23168 ))"
            fi
            if [ "$(( $(( current_len_23172 + needed_23178 )) > term_width_23166 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_23173 ))" != 0 ]; then
                eprintf_colored__2210_v0 "${separator_23167}" 90
            fi
            colored__2211_v0 "${action_23176}" 2
            local ret_colored2211_v0__296_33="${ret_colored2211_v0}"
            local array_360=("")
            eprintf__2209_v0 "${key_23175}"" ""${ret_colored2211_v0__296_33}" array_360[@]
            current_len_23172="$(( current_len_23172 + needed_23178 ))"
            first_23173=0
            iter_23174="$(( iter_23174 + 2 ))"
        done
    fi
}

# A chooser driven by its caller.
# 
# Amber has no callbacks, so the engine cannot ask for an item's text on its
# own. The caller runs the loop instead and hands over one page of labels at
# a time, which is what lets it build them lazily. `xyl_choose` and
# `xyl_file` show the shape of that loop.
# 
# Only the engine writes to the terminal; callers just produce text.
# `chooser_step` handled the key and redrew whatever changed.
__CHOOSER_CONTINUE_80=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_81=1
# The user confirmed the selection.
__CHOOSER_DONE_82=2
_total_83=0
_page_size_84=10
_display_count_85=0
_total_pages_86=1
_current_page_87=0
_selected_88=0
_cursor_89="> "
_multi_90=0
_limit_91=-1
_term_width_92=80
_has_header_93=0
_page_94=()
_page_count_95=0
_checked_96=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_97=0
_first_render_98=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_99=0
# render_single_page()
render_single_page__2279_v0() {
    local __length_363="${_cursor_89}"
    local cursor_len_23216="${#__length_363}"
    local max_option_width_23217="$(( $(( _term_width_92 - cursor_len_23216 )) - 1 ))"
    local __range_start_23218=0
    local __range_end_23218="${_page_count_95}"
    local __dir_23218=$(( ${__range_start_23218} <= ${__range_end_23218} ? 1 : -1 ))
    for (( i_23218=${__range_start_23218}; i_23218 * ${__dir_23218} < ${__range_end_23218} * ${__dir_23218}; i_23218+=${__dir_23218} )); do
        cutoff_text__2229_v0 "${_page_94[${i_23218}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_23217}"
        local ret_cutoff_text2229_v0__48_27="${ret_cutoff_text2229_v0}"
        local truncated_23219="${ret_cutoff_text2229_v0__48_27}"
        if [ "$(( i_23218 == _selected_88 ))" != 0 ]; then
            colored_secondary__2192_v0 "${_cursor_89}""${truncated_23219}""
"
            local ret_colored_secondary2192_v0__50_21="${ret_colored_secondary2192_v0}"
            local array_364=("")
            eprintf__2209_v0 "${ret_colored_secondary2192_v0__50_21}" array_364[@]
        else
            print_blank__2215_v0 "${cursor_len_23216}"
            local array_365=("")
            eprintf__2209_v0 "${truncated_23219}""
" array_365[@]
        fi
done
    local remaining_slots_23220="$(( _display_count_85 - _page_count_95 ))"
    if [ "$(( remaining_slots_23220 > 0 ))" != 0 ]; then
        local __range_start_23221=0
        local __range_end_23221="${remaining_slots_23220}"
        local __dir_23221=$(( ${__range_start_23221} <= ${__range_end_23221} ? 1 : -1 ))
        for (( ____23221=${__range_start_23221}; ____23221 * ${__dir_23221} < ${__range_end_23221} * ${__dir_23221}; ____23221+=${__dir_23221} )); do
            local array_366=("")
            eprintf__2209_v0 "\\x1b[K
" array_366[@]
done
    fi
}

# render_multi_page()
render_multi_page__2280_v0() {
    local __length_367="${_cursor_89}"
    local cursor_len_23192="${#__length_367}"
    local max_option_width_23193="$(( $(( _term_width_92 - cursor_len_23192 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2285_v0 
    local page_start_23194="${ret_chooser_page_start2285_v0}"
    local __range_start_23195=0
    local __range_end_23195="${_page_count_95}"
    local __dir_23195=$(( ${__range_start_23195} <= ${__range_end_23195} ? 1 : -1 ))
    for (( i_23195=${__range_start_23195}; i_23195 * ${__dir_23195} < ${__range_end_23195} * ${__dir_23195}; i_23195+=${__dir_23195} )); do
        local global_idx_23196="$(( page_start_23194 + i_23195 ))"
        local check_mark_23197
        check_mark_23197="$(if [ "${_checked_96[${global_idx_23196}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2229_v0 "${_page_94[${i_23195}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_23193}"
        local ret_cutoff_text2229_v0__71_27="${ret_cutoff_text2229_v0}"
        local truncated_23198="${ret_cutoff_text2229_v0__71_27}"
        if [ "$(( i_23195 == _selected_88 ))" != 0 ]; then
            colored_secondary__2192_v0 "${_cursor_89}""${check_mark_23197}""${truncated_23198}""
"
            local ret_colored_secondary2192_v0__73_37="${ret_colored_secondary2192_v0}"
            local array_368=("")
            eprintf__2209_v0 "${ret_colored_secondary2192_v0__73_37}" array_368[@]
        elif [ "${_checked_96[${global_idx_23196}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2215_v0 "${cursor_len_23192}"
            colored_secondary__2192_v0 "${check_mark_23197}""${truncated_23198}""
"
            local ret_colored_secondary2192_v0__76_25="${ret_colored_secondary2192_v0}"
            local array_369=("")
            eprintf__2209_v0 "${ret_colored_secondary2192_v0__76_25}" array_369[@]
        else
            print_blank__2215_v0 "${cursor_len_23192}"
            local array_370=("")
            eprintf__2209_v0 "${check_mark_23197}""${truncated_23198}""
" array_370[@]
        fi
done
    local remaining_slots_23214="$(( _display_count_85 - _page_count_95 ))"
    if [ "$(( remaining_slots_23214 > 0 ))" != 0 ]; then
        local __range_start_23215=0
        local __range_end_23215="${remaining_slots_23214}"
        local __dir_23215=$(( ${__range_start_23215} <= ${__range_end_23215} ? 1 : -1 ))
        for (( ____23215=${__range_start_23215}; ____23215 * ${__dir_23215} < ${__range_end_23215} * ${__dir_23215}; ____23215+=${__dir_23215} )); do
            local array_371=("")
            eprintf__2209_v0 "\\x1b[K
" array_371[@]
done
    fi
}

# render_page()
render_page__2281_v0() {
    if [ "${_multi_90}" != 0 ]; then
        render_multi_page__2280_v0 
    else
        render_single_page__2279_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2282_v0() {
    if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
        local array_372=("")
        eprintf__2209_v0 "\\x1b[G\\x1b[K" array_372[@]
        eprintf_colored__2210_v0 "Page $(( _current_page_87 + 1 ))/${_total_pages_86}" 90
        local array_373=("")
        eprintf__2209_v0 "\\x1b[G" array_373[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2283_v0() {
    if [ "$(( ! _multi_90 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
            local array_374=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2230_v0 array_374[@] 36 "${_term_width_92}"
        else
            local array_375=("↑↓" "select" "enter" "confirm")
            render_tooltip__2230_v0 array_375[@] 25 "${_term_width_92}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_86 > 1 )) && $(( _limit_91 < 0 )) ))" != 0 ]; then
            local array_376=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2230_v0 array_376[@] 55 "${_term_width_92}"
        elif [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
            local array_377=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2230_v0 array_377[@] 47 "${_term_width_92}"
        elif [ "$(( _limit_91 < 0 ))" != 0 ]; then
            local array_378=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2230_v0 array_378[@] 44 "${_term_width_92}"
        else
            local array_379=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2230_v0 array_379[@] 36 "${_term_width_92}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2284_v0() {
    local total_23106="${1}"
    local page_size_23107="${2}"
    local header_23108="${3}"
    local cursor_23109="${4}"
    local multi_23110="${5}"
    local limit_23111="${6}"
    _total_83="${total_23106}"
    _cursor_89="${cursor_23109}"
    _multi_90="${multi_23110}"
    _limit_91="${limit_23111}"
    _current_page_87=0
    _selected_88=0
    _first_render_98=1
    _up_paged_99=0
    _checked_count_97=0
    _has_header_93="$([ "_${header_23108}" == "_" ]; echo $?)"
    stty_lock__2168_v0 
    hide_cursor__2220_v0 
    term_width__2175_v0 
    _term_width_92="${ret_term_width2175_v0}"
    term_height__2176_v0 
    local term_height_23121="${ret_term_height2176_v0}"
    local max_page_size_23122
    max_page_size_23122="$(( term_height_23121 - $(if [ "${_has_header_93}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_84="${page_size_23107}"
    if [ "$(( _page_size_84 > max_page_size_23122 ))" != 0 ]; then
        _page_size_84="${max_page_size_23122}"
    fi
    if [ "${_has_header_93}" != 0 ]; then
        cutoff_text__2229_v0 "${header_23108}" "${_term_width_92}"
        local ret_cutoff_text2229_v0__157_17="${ret_cutoff_text2229_v0}"
        local array_380=("")
        eprintf__2209_v0 "${ret_cutoff_text2229_v0__157_17}""
" array_380[@]
    fi
    math_floor__501_v0 "$(( $(( $(( total_23106 + _page_size_84 )) - 1 )) / _page_size_84 ))"
    _total_pages_86="${ret_math_floor501_v0}"
    _display_count_85="${_page_size_84}"
    if [ "$(( total_23106 < _page_size_84 ))" != 0 ]; then
        _display_count_85="${total_23106}"
    fi
    if [ "${multi_23110}" != 0 ]; then
        _checked_96=()
        local __range_start_23159=0
        local __range_end_23159="${total_23106}"
        local __dir_23159=$(( ${__range_start_23159} <= ${__range_end_23159} ? 1 : -1 ))
        for (( ____23159=${__range_start_23159}; ____23159 * ${__dir_23159} < ${__range_end_23159} * ${__dir_23159}; ____23159+=${__dir_23159} )); do
            local array_382=(0)
            _checked_96+=("${array_382[@]}")
done
    fi
    new_line__2216_v0 "${_display_count_85}"
    local array_383=("")
    eprintf__2209_v0 "\\x1b[G" array_383[@]
    if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
        eprintf_colored__2210_v0 "Page $(( _current_page_87 + 1 ))/${_total_pages_86}" 90
    fi
    new_line__2216_v0 1
    render_tooltip_line__2283_v0 
    go_up__2217_v0 "$(( _display_count_85 + 1 ))"
    local array_384=("")
    eprintf__2209_v0 "\\x1b[G" array_384[@]
}

# chooser_page_start()
chooser_page_start__2285_v0() {
    ret_chooser_page_start2285_v0="$(( _current_page_87 * _page_size_84 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2286_v0() {
    chooser_page_start__2285_v0 
    local start_23183="${ret_chooser_page_start2285_v0}"
    local end_23184="$(( start_23183 + _page_size_84 ))"
    if [ "$(( end_23184 > _total_83 ))" != 0 ]; then
        end_23184="${_total_83}"
    fi
    ret_chooser_page_count2286_v0="$(( end_23184 - start_23183 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2287_v0() {
    local -n page_23191="${1}"
    _page_94=("${page_23191[@]}")
    local __length_385=("${page_23191[@]}")
    _page_count_95="${#__length_385[@]}"
    if [ "${_first_render_98}" != 0 ]; then
        _first_render_98=0
        render_page__2281_v0 
    else
        if [ "${_up_paged_99}" != 0 ]; then
            _selected_88="$(( _page_count_95 - 1 ))"
            _up_paged_99=0
        fi
        go_up__2217_v0 1
        remove_line__2213_v0 "$(( _display_count_85 - 1 ))"
        remove_current_line__2214_v0 
        local array_386=("")
        eprintf__2209_v0 "\\x1b[G" array_386[@]
        render_page__2281_v0 
        render_page_indicator__2282_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2288_v0() {
    local prev_selected_23237="${1}"
    chooser_page_start__2285_v0 
    local page_start_23238="${ret_chooser_page_start2285_v0}"
    local check_width_23239
    check_width_23239="$(if [ "${_multi_90}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_387="${_cursor_89}"
    local max_option_width_23240="$(( $(( _term_width_92 - ${#__length_387} )) - check_width_23239 ))"
    go_up__2217_v0 "$(( _display_count_85 - prev_selected_23237 ))"
    local array_388=("")
    eprintf__2209_v0 "\\x1b[K" array_388[@]
    local __length_389="${_cursor_89}"
    print_blank__2215_v0 "${#__length_389}"
    if [ "${_multi_90}" != 0 ]; then
        local was_checked_23241="${_checked_96[$(( page_start_23238 + prev_selected_23237 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2229_v0 "${_page_94[${prev_selected_23237}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_23240}"
        local ret_cutoff_text2229_v0__232_63="${ret_cutoff_text2229_v0}"
        local prev_line_23242
        prev_line_23242="$(if [ "${was_checked_23241}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2229_v0__232_63}"
        if [ "${was_checked_23241}" != 0 ]; then
            colored_secondary__2192_v0 "${prev_line_23242}"
            local ret_colored_secondary2192_v0__234_21="${ret_colored_secondary2192_v0}"
            local array_390=("")
            eprintf__2209_v0 "${ret_colored_secondary2192_v0__234_21}" array_390[@]
        else
            local array_391=("")
            eprintf__2209_v0 "${prev_line_23242}" array_391[@]
        fi
    else
        cutoff_text__2229_v0 "${_page_94[${prev_selected_23237}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_23240}"
        local ret_cutoff_text2229_v0__239_17="${ret_cutoff_text2229_v0}"
        local array_392=("")
        eprintf__2209_v0 "${ret_cutoff_text2229_v0__239_17}" array_392[@]
    fi
    go_up_or_down__2219_v0 "$(( _selected_88 - prev_selected_23237 ))"
    local array_393=("")
    eprintf__2209_v0 "\\x1b[G" array_393[@]
    local array_394=("")
    eprintf__2209_v0 "\\x1b[K" array_394[@]
    local mark_23244
    mark_23244="$(if [ "${_multi_90}" != 0 ]; then echo "$(if [ "${_checked_96[$(( page_start_23238 + _selected_88 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2229_v0 "${_page_94[${_selected_88}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_23240}"
    local ret_cutoff_text2229_v0__246_48="${ret_cutoff_text2229_v0}"
    colored_secondary__2192_v0 "${_cursor_89}""${mark_23244}""${ret_cutoff_text2229_v0__246_48}"
    local ret_colored_secondary2192_v0__246_13="${ret_colored_secondary2192_v0}"
    local array_395=("")
    eprintf__2209_v0 "${ret_colored_secondary2192_v0__246_13}" array_395[@]
    go_down__2218_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_396=("")
    eprintf__2209_v0 "\\x1b[G" array_396[@]
}

# redraw_current_line()
redraw_current_line__2289_v0() {
    chooser_page_start__2285_v0 
    local page_start_23231="${ret_chooser_page_start2285_v0}"
    local __length_397="${_cursor_89}"
    local max_option_width_23232="$(( $(( _term_width_92 - ${#__length_397} )) - 3 ))"
    go_up__2217_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_398=("")
    eprintf__2209_v0 "\\x1b[G" array_398[@]
    local array_399=("")
    eprintf__2209_v0 "\\x1b[K" array_399[@]
    local check_mark_23233
    check_mark_23233="$(if [ "${_checked_96[$(( page_start_23231 + _selected_88 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2229_v0 "${_page_94[${_selected_88}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_23232}"
    local ret_cutoff_text2229_v0__260_54="${ret_cutoff_text2229_v0}"
    colored_secondary__2192_v0 "${_cursor_89}""${check_mark_23233}""${ret_cutoff_text2229_v0__260_54}"
    local ret_colored_secondary2192_v0__260_13="${ret_colored_secondary2192_v0}"
    local array_400=("")
    eprintf__2209_v0 "${ret_colored_secondary2192_v0__260_13}" array_400[@]
    go_down__2218_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_401=("")
    eprintf__2209_v0 "\\x1b[G" array_401[@]
}

# chooser_step()
chooser_step__2290_v0() {
    get_key__2207_v0 
    local key_23226="${ret_get_key2207_v0}"
    local prev_selected_23227="${_selected_88}"
    local prev_page_23228="${_current_page_87}"
    chooser_page_start__2285_v0 
    local page_start_23229="${ret_chooser_page_start2285_v0}"
    _up_paged_99=0
    if [ "$(( $([ "_${key_23226}" != "_UP" ]; echo $?) || $([ "_${key_23226}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_88 == 0 )) && $(( _total_pages_86 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_87 > 0 ))" != 0 ]; then
                _current_page_87="$(( _current_page_87 - 1 ))"
            else
                _current_page_87="$(( _total_pages_86 - 1 ))"
            fi
            _up_paged_99=1
        elif [ "$(( _selected_88 == 0 ))" != 0 ]; then
            _selected_88="$(( _page_count_95 - 1 ))"
        else
            _selected_88="$(( _selected_88 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_23226}" != "_DOWN" ]; echo $?) || $([ "_${key_23226}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_88 == $(( _page_count_95 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_87 < $(( _total_pages_86 - 1 )) ))" != 0 ]; then
                _current_page_87="$(( _current_page_87 + 1 ))"
            else
                _current_page_87=0
            fi
            _selected_88=0
        else
            _selected_88="$(( _selected_88 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_23226}" != "_LEFT" ]; echo $?) || $([ "_${key_23226}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_87 > 0 ))" != 0 ]; then
            _current_page_87="$(( _current_page_87 - 1 ))"
        fi
        _selected_88=0
    elif [ "$(( $([ "_${key_23226}" != "_RIGHT" ]; echo $?) || $([ "_${key_23226}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_87 < $(( _total_pages_86 - 1 )) ))" != 0 ]; then
            _current_page_87="$(( _current_page_87 + 1 ))"
            _selected_88=0
        else
            _selected_88="$(( _page_count_95 - 1 ))"
        fi
    elif [ "$(( _multi_90 && $(( $([ "_${key_23226}" != "_x" ]; echo $?) || $([ "_${key_23226}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_23230="$(( page_start_23229 + _selected_88 ))"
        if [ "${_checked_96[${global_selected_23230}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_96["${global_selected_23230}"]=0
            _checked_count_97="$(( _checked_count_97 - 1 ))"
        elif [ "$(( $(( _limit_91 < 0 )) || $(( _checked_count_97 < _limit_91 )) ))" != 0 ]; then
            _checked_96["${global_selected_23230}"]=1
            _checked_count_97="$(( _checked_count_97 + 1 ))"
        else
            ret_chooser_step2290_v0="${__CHOOSER_CONTINUE_80}"
            return 0
        fi
        redraw_current_line__2289_v0 
        ret_chooser_step2290_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    elif [ "$(( $(( _multi_90 && $(( $([ "_${key_23226}" != "_a" ]; echo $?) || $([ "_${key_23226}" != "_A" ]; echo $?) )) )) && $(( _limit_91 < 0 )) ))" != 0 ]; then
        local all_checked_23235="$(( _checked_count_97 == _total_83 ))"
        local __range_start_23236=0
        local __range_end_23236="${_total_83}"
        local __dir_23236=$(( ${__range_start_23236} <= ${__range_end_23236} ? 1 : -1 ))
        for (( i_23236=${__range_start_23236}; i_23236 * ${__dir_23236} < ${__range_end_23236} * ${__dir_23236}; i_23236+=${__dir_23236} )); do
            _checked_96["${i_23236}"]="$(( ! all_checked_23235 ))"
done
        _checked_count_97="$(if [ "${all_checked_23235}" != 0 ]; then echo 0; else echo "${_total_83}"; fi)"
        go_up__2217_v0 "${_display_count_85}"
        local array_402=("")
        eprintf__2209_v0 "\\x1b[G" array_402[@]
        render_page__2281_v0 
        ret_chooser_step2290_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    elif [ "$([ "_${key_23226}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2290_v0="${__CHOOSER_DONE_82}"
        return 0
    else
        ret_chooser_step2290_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    fi
    if [ "$(( prev_page_23228 != _current_page_87 ))" != 0 ]; then
        ret_chooser_step2290_v0="${__CHOOSER_NEED_PAGE_81}"
        return 0
    fi
    if [ "$(( prev_selected_23227 != _selected_88 ))" != 0 ]; then
        redraw_selection__2288_v0 "${prev_selected_23227}"
    fi
    ret_chooser_step2290_v0="${__CHOOSER_CONTINUE_80}"
    return 0
}

# chooser_selected()
chooser_selected__2291_v0() {
    chooser_page_start__2285_v0 
    local ret_chooser_page_start2285_v0__362_12="${ret_chooser_page_start2285_v0}"
    ret_chooser_selected2291_v0="$(( ret_chooser_page_start2285_v0__362_12 + _selected_88 ))"
    return 0
}

# chooser_end()
chooser_end__2293_v0() {
    local total_lines_23247="$(( _display_count_85 + 2 ))"
    if [ "${_has_header_93}" != 0 ]; then
        total_lines_23247="$(( total_lines_23247 + 1 ))"
    fi
    go_down__2218_v0 1
    remove_line__2213_v0 "$(( total_lines_23247 - 1 ))"
    remove_current_line__2214_v0 
    stty_unlock__2169_v0 
    show_cursor__2221_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2302_v0() {
    local name_23187="${1}"
    local file_type_23188="${2}"
    local target_23189="${3}"
    if [ "$([ "_${file_type_23188}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1972_v0 "/"
        local ret_colored_primary1972_v0__10_23="${ret_colored_primary1972_v0}"
        ret_format_entry_display2302_v0="${name_23187}""${ret_colored_primary1972_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_23188}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1974_v0 " > "
        local ret_colored_accent1974_v0__13_23="${ret_colored_accent1974_v0}"
        colored_primary__1972_v0 "${target_23189}"
        local ret_colored_primary1972_v0__13_47="${ret_colored_primary1972_v0}"
        ret_format_entry_display2302_v0="${name_23187}""${ret_colored_accent1974_v0__13_23}""${ret_colored_primary1972_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2302_v0="${name_23187}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2303_v0() {
    local start_path_23078="${1}"
    local cursor_23079="${2}"
    local show_hidden_23080="${3}"
    local page_size_23081="${4}"
    stty_lock__1949_v0 
    # Initialize current path
    local current_path_23084="${start_path_23078}"
    if [ "$([ "_${current_path_23084}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1930_v0 
        current_path_23084="${ret_get_cwd1930_v0}"
    fi
    normalize_path__1931_v0 "${current_path_23084}"
    current_path_23084="${ret_normalize_path1931_v0}"
    while :
    do
        colored_primary__1972_v0 "Loading files..."
        local ret_colored_primary1972_v0__41_17="${ret_colored_primary1972_v0}"
        local array_403=("")
        eprintf__1990_v0 "${ret_colored_primary1972_v0__41_17}" array_403[@]
        # Get directory entries
        local listed_names_23087=()
        local listed_types_23088=()
        local listed_targets_23089=()
        get_directory_entries__1929_v0 "${current_path_23084}" "listed_names_23087" "listed_types_23088" "listed_targets_23089"
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_23097=()
        local types_23098=()
        local targets_23099=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_23084}" == "_/" ]; echo $?)" != 0 ]; then
            names_23097+=("..")
            types_23098+=("d")
            targets_23099+=("")
        fi
        local __range_start_23100=0
        local __length_413=("${listed_names_23087[@]}")
        local __range_end_23100="${#__length_413[@]}"
        local __dir_23100=$(( ${__range_start_23100} <= ${__range_end_23100} ? 1 : -1 ))
        for (( i_23100=${__range_start_23100}; i_23100 * ${__dir_23100} < ${__range_end_23100} * ${__dir_23100}; i_23100+=${__dir_23100} )); do
            local name_23101="${listed_names_23087[${i_23100}]?"Index out of bounds (at src/./file/./mod.ab:64:39)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_23101}" "."
            local ret_starts_with22_v0__66_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_23080 )) && ret_starts_with22_v0__66_36 ))" != 0 ]; then
                continue
            fi
            local array_414=("${name_23101}")
            names_23097+=("${array_414[@]}")
            local array_415=("${listed_types_23088[${i_23100}]?"Index out of bounds (at src/./file/./mod.ab:70:36)"}")
            types_23098+=("${array_415[@]}")
            local array_416=("${listed_targets_23089[${i_23100}]?"Index out of bounds (at src/./file/./mod.ab:71:40)"}")
            targets_23099+=("${array_416[@]}")
done
        local __length_417=("${names_23097[@]}")
        local total_23102="${#__length_417[@]}"
        if [ "$(( total_23102 == 0 ))" != 0 ]; then
            eprintf_colored__1991_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1950_v0 
            ret_xyl_file2303_v0=""
            return 0
        fi
        colored_primary__1972_v0 "${current_path_23084}"
        local header_23105="${ret_colored_primary1972_v0}"
        remove_current_line__1995_v0 
        chooser_begin__2284_v0 "${total_23102}" "${page_size_23081}" "${header_23105}" "${cursor_23079}" 0 -1
        local need_page_23180=1
        while :
        do
            if [ "${need_page_23180}" != 0 ]; then
                local page_23181=()
                chooser_page_start__2285_v0 
                local start_23182="${ret_chooser_page_start2285_v0}"
                chooser_page_count__2286_v0 
                local count_23185="${ret_chooser_page_count2286_v0}"
                local __range_start_23186="${start_23182}"
                local __range_end_23186="$(( start_23182 + count_23185 ))"
                local __dir_23186=$(( ${__range_start_23186} <= ${__range_end_23186} ? 1 : -1 ))
                for (( i_23186=${__range_start_23186}; i_23186 * ${__dir_23186} < ${__range_end_23186} * ${__dir_23186}; i_23186+=${__dir_23186} )); do
                    format_entry_display__2302_v0 "${names_23097[${i_23186}]?"Index out of bounds (at src/./file/./mod.ab:92:57)"}" "${types_23098[${i_23186}]?"Index out of bounds (at src/./file/./mod.ab:92:67)"}" "${targets_23099[${i_23186}]?"Index out of bounds (at src/./file/./mod.ab:92:79)"}"
                    local ret_format_entry_display2302_v0__92_30="${ret_format_entry_display2302_v0}"
                    local array_419=("${ret_format_entry_display2302_v0__92_30}")
                    page_23181+=("${array_419[@]}")
done
                chooser_set_page__2287_v0 "page_23181"
            fi
            chooser_step__2290_v0 
            local step_23245="${ret_chooser_step2290_v0}"
            if [ "$(( step_23245 == __CHOOSER_DONE_82 ))" != 0 ]; then
                break
            fi
            need_page_23180="$(( step_23245 == __CHOOSER_NEED_PAGE_81 ))"
        done
        chooser_selected__2291_v0 
        local selected_idx_23246="${ret_chooser_selected2291_v0}"
        chooser_end__2293_v0 
        local name_23250="${names_23097[${selected_idx_23246}]?"Index out of bounds (at src/./file/./mod.ab:105:28)"}"
        local file_type_23251="${types_23098[${selected_idx_23246}]?"Index out of bounds (at src/./file/./mod.ab:106:33)"}"
        if [ "$([ "_${name_23250}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1933_v0 "${current_path_23084}"
            current_path_23084="${ret_get_parent_dir1933_v0}"
        elif [ "$([ "_${file_type_23251}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1932_v0 "${current_path_23084}" "${name_23250}"
            current_path_23084="${ret_path_join1932_v0}"
            normalize_path__1931_v0 "${current_path_23084}"
            current_path_23084="${ret_normalize_path1931_v0}"
        elif [ "$([ "_${file_type_23251}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_23256="${targets_23099[${selected_idx_23246}]?"Index out of bounds (at src/./file/./mod.ab:118:40)"}"
            local target_path_23257="${target_23256}"
            starts_with__22_v0 "${target_23256}" "/"
            local ret_starts_with22_v0__120_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__120_24 ))" != 0 ]; then
                path_join__1932_v0 "${current_path_23084}" "${target_23256}"
                target_path_23257="${ret_path_join1932_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_23257}"
            local ret_dir_exists38_v0__124_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__124_20}" != 0 ]; then
                current_path_23084="${target_path_23257}"
                normalize_path__1931_v0 "${current_path_23084}"
                current_path_23084="${ret_normalize_path1931_v0}"
            else
                stty_unlock__1950_v0 
                path_join__1932_v0 "${current_path_23084}" "${name_23250}"
                ret_xyl_file2303_v0="${ret_path_join1932_v0}"
                return 0
            fi
        else
            stty_unlock__1950_v0 
            path_join__1932_v0 "${current_path_23084}" "${name_23250}"
            ret_xyl_file2303_v0="${ret_path_join1932_v0}"
            return 0
        fi
    done
    stty_unlock__1950_v0 
    ret_xyl_file2303_v0=""
    return 0
}

# print_file_help()
print_file_help__2395_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    printf '%s\n' ""
    colored_primary__1972_v0 "file"
    local ret_colored_primary1972_v0__7_12="${ret_colored_primary1972_v0}"
    local array_420=()
    printf__128_v1 "${ret_colored_primary1972_v0__7_12}" array_420[@]
    local array_421=()
    printf__128_v1 " - Browse filesystem and select a file." array_421[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1973_v0 "Arguments: "
    local ret_colored_secondary1973_v0__11_12="${ret_colored_secondary1973_v0}"
    local array_422=()
    printf__128_v1 "${ret_colored_secondary1973_v0__11_12}""
" array_422[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    printf '%s\n' ""
    colored_secondary__1973_v0 "Flags: "
    local ret_colored_secondary1973_v0__14_12="${ret_colored_secondary1973_v0}"
    local array_423=()
    printf__128_v1 "${ret_colored_secondary1973_v0__14_12}""
" array_423[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2445_v0() {
    local parameters_23052=("${!1}")
    local cursor_23053="> "
    local start_path_23054=""
    local show_hidden_23055=0
    local page_size_23056=10
    local __length_427=("${parameters_23052[@]}")
    local slice_upper_426="${#__length_427[@]}"
    local slice_offset_428=2
    local slice_offset_428=$((${slice_offset_428} > 0 ? ${slice_offset_428} : 0))
    local slice_length_429="$(( slice_upper_426 - slice_offset_428 ))"
    local slice_length_429=$((${slice_length_429} > 0 ? ${slice_length_429} : 0))
    for param_23057 in "${parameters_23052[@]:${slice_offset_428}:${slice_length_429}}"; do
        starts_with__22_v0 "${param_23057}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_23057}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_23057}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_23057}" != "_-h" ]; echo $?) || $([ "_${param_23057}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2395_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_430="--cursor="
            slice__24_v0 "${param_23057}" "${#__length_430}" 0
            cursor_23053="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_431="--path="
            slice__24_v0 "${param_23057}" "${#__length_431}" 0
            start_path_23054="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_23057}" != "_-a" ]; echo $?) || $([ "_${param_23057}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_23055=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_432="--page-size="
            slice__24_v0 "${param_23057}" "${#__length_432}" 0
            local value_23073="${ret_slice24_v0}"
            parse_int__13_v0 "${value_23073}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1991_v0 "ERROR: Invalid page-size value: ""${value_23073}""
" 31
                exit 1
            fi
            page_size_23056="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_23054="${param_23057}"
        fi
    done
    xyl_file__2303_v0 "${start_path_23054}" "${cursor_23053}" "${show_hidden_23055}" "${page_size_23056}"
    ret_execute_file2445_v0="${ret_xyl_file2303_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_103="0.1.0"
__AMBER_VERSION_104="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2447_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__260_v0 "Error: " 91
        local array_433=("")
        eprintf__259_v0 "bc is not installed. Please install bc to use xylitol.
" array_433[@]
        local array_434=("")
        eprintf__259_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_434[@]
        local array_435=("")
        eprintf__259_v0 "  For Fedora: sudo dnf install bc
" array_435[@]
        local array_436=("")
        eprintf__259_v0 "  For Arch Linux: sudo pacman -S bc
" array_436[@]
        ret_check_prerequirements2447_v0=0
        return 0
    fi
    ret_check_prerequirements2447_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2448_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_105=("$0" "$@")
trap_cleanup__2448_v0 
check_prerequirements__2447_v0 
ret_check_prerequirements2447_v0__32_12="${ret_check_prerequirements2447_v0}"
if [ "$(( ! ret_check_prerequirements2447_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_438=("${args_105[@]}")
if [ "$(( ${#__length_438[@]} < 2 ))" != 0 ]; then
    print_help__420_v0 
    exit 0
fi
command_710="${args_105[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_710}" != "_help" ]; echo $?) || $([ "_${command_710}" != "_--help" ]; echo $?) )) || $([ "_${command_710}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__420_v0 
elif [ "$([ "_${command_710}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__823_v0 args_105[@]
    ret_execute_input823_v0__48_18="${ret_execute_input823_v0}"
    printf '%s\n' "${ret_execute_input823_v0__48_18}"
elif [ "$([ "_${command_710}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1337_v0 args_105[@]
    ret_execute_choose1337_v0__51_18="${ret_execute_choose1337_v0}"
    printf '%s\n' "${ret_execute_choose1337_v0__51_18}"
elif [ "$([ "_${command_710}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1774_v0 args_105[@]
    result_15094="${ret_execute_confirm1774_v0}"
    if [ "$([ "_${result_15094}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_710}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2445_v0 args_105[@]
    ret_execute_file2445_v0__61_18="${ret_execute_file2445_v0}"
    printf '%s\n' "${ret_execute_file2445_v0__61_18}"
elif [ "$(( $(( $([ "_${command_710}" != "_version" ]; echo $?) || $([ "_${command_710}" != "_--version" ]; echo $?) )) || $([ "_${command_710}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__241_v0 "xylitol.sh"
    ret_colored_primary241_v0__64_20="${ret_colored_primary241_v0}"
    array_439=()
    printf__128_v1 "${ret_colored_primary241_v0__64_20}" array_439[@]
    array_440=()
    printf__128_v1 " version: " array_440[@]
    colored_accent__243_v0 "${__VERSION_103}"
    ret_colored_accent243_v0__66_20="${ret_colored_accent243_v0}"
    array_441=()
    printf__128_v1 "${ret_colored_accent243_v0__66_20}" array_441[@]
    printf '%s\n' ""
    printf_colored__258_v0 "written in Amber: " 90
    printf_colored__258_v0 "  ""${__AMBER_VERSION_104}" 90
else
    print_help__420_v0 
    printf_colored__258_v0 "ERROR: Unknown command '""${command_710}""'" 91
fi
