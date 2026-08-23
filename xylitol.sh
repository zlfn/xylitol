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
    local text_1706="${1}"
    local prefix_1707="${2}"
    [[ "${text_1706}" == "${prefix_1707}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1708="${1}"
    local index_1709="${2}"
    local length_1710="${3}"
    local result_1711=""
    if [ "$(( length_1710 == 0 ))" != 0 ]; then
        local __length_2="${text_1708}"
        length_1710="$(( ${#__length_2} - index_1709 ))"
    fi
    if [ "$(( length_1710 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1711}"
        return 0
    fi
    result_1711="${text_1708: ${index_1709}: ${length_1710}}"
    __status=$?
    ret_slice24_v0="${result_1711}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_15047="${1}"
    local pad_15048="${2}"
    local length_15049="${3}"
    local __length_3="${text_15047}"
    if [ "$(( length_15049 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_15047}"
        return 0
    fi
    local __length_4="${text_15047}"
    local pad_len_15050="$(( length_15049 - ${#__length_4} ))"
    local padding_15051=""
    printf -v padding_15051 "%${pad_len_15050}s" ""
    __status=$?
    padding_15051="${padding_15051// /${pad_15048}}"
    __status=$?
    ret_lpad27_v0="${padding_15051}""${text_15047}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_15053="${1}"
    local pad_15054="${2}"
    local length_15055="${3}"
    local __length_5="${text_15053}"
    if [ "$(( length_15055 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_15053}"
        return 0
    fi
    local __length_6="${text_15053}"
    local pad_len_15056="$(( length_15055 - ${#__length_6} ))"
    local padding_15057=""
    printf -v padding_15057 "%${pad_len_15056}s" ""
    __status=$?
    padding_15057="${padding_15057// /${pad_15054}}"
    __status=$?
    ret_rpad28_v0="${text_15053}""${padding_15057}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_15041="${1}"
    local pad_15042="${2}"
    local length_15043="${3}"
    local __length_7="${text_15041}"
    local text_length_15044="${#__length_7}"
    if [ "$(( length_15043 <= text_length_15044 ))" != 0 ]; then
        ret_cpad29_v0="${text_15041}"
        return 0
    fi
    local total_padding_15045="$(( length_15043 - text_length_15044 ))"
    local left_padding_length_15046="$(( text_length_15044 + $(( total_padding_15045 / 2 )) ))"
    lpad__27_v0 "${text_15041}" "${pad_15042}" "${left_padding_length_15046}"
    local left_padded_15052="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_15052}" "${pad_15042}" "${length_15043}"
    local center_padded_15058="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_15058}"
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
get_supports_truecolor__237_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_702="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_702}" != "_No" ]; echo $?)" != 0 ]; then
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
    local colorterm_703="${ret_env_var_get120_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_703}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_703}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor237_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__238_v0() {
    local message_697="${1}"
    local r_698="${2}"
    local g_699="${3}"
    local b_700="${4}"
    local fallback_701="${5}"
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb238_v0="\\x1b[38;2;${r_698};${g_699};${b_700}m""${message_697}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__237_v0 
        local ret_get_supports_truecolor237_v0__50_17="${ret_get_supports_truecolor237_v0}"
        if [ "${ret_get_supports_truecolor237_v0__50_17}" != 0 ]; then
            ret_colored_rgb238_v0="\\x1b[38;2;${r_698};${g_699};${b_700}m""${message_697}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_701 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_697}"
            return 0
        else
            ret_colored_rgb238_v0="\\x1b[${fallback_701}m""${message_697}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_701 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_697}"
            return 0
        fi
        ret_colored_rgb238_v0="\\x1b[${fallback_701}m""${message_697}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__240_v0() {
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_682="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_682}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_682}" ";"
            local parts_686=("${ret_split4_v0[@]}")
            local __length_18=("${parts_686[@]}")
            if [ "$(( ${#__length_18[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_686[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_686[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_686[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_686[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
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
        local secondary_env_688="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_688}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_688}" ";"
            local parts_689=("${ret_split4_v0[@]}")
            local __length_20=("${parts_689[@]}")
            if [ "$(( ${#__length_20[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_689[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_689[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_689[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_689[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
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
        local accent_env_690="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_690}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_690}" ";"
            local parts_691=("${ret_split4_v0[@]}")
            local __length_22=("${parts_691[@]}")
            if [ "$(( ${#__length_22[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_691[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_691[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_691[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_691[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
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
    local message_680="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_680}" "${_primary_color_9[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_9[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_9[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_9[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary242_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__243_v0() {
    local message_706="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_706}" "${_secondary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary243_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__244_v0() {
    local message_709="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_709}" "${_accent_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent244_v0="${ret_colored_rgb238_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__259_v0() {
    local message_23261="${1}"
    local color_23262="${2}"
    # Prints a text with a specified color.
    local array_24=("${message_23261}")
    printf__128_v0 "\\x1b[${color_23262}m%s\\x1b[0m" array_24[@]
}

# eprintf(format: Text, args: [Text])
eprintf__260_v0() {
    local format_126="${1}"
    local args_127=("${!2}")
    args_127=("${format_126}" "${args_127[@]}")
    __status=$?
    printf "${args_127[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__261_v0() {
    local message_124="${1}"
    local color_125="${2}"
    # Prints an error message with a specified color.
    local array_25=("${message_124}")
    eprintf__260_v0 "\\x1b[${color_125}m%s\\x1b[0m" array_25[@]
}

# colored(message: Text, color: Int)
colored__262_v0() {
    local message_707="${1}"
    local color_708="${2}"
    # Returns a text wrapped in color codes.
    ret_colored262_v0="\\x1b[${color_708}m""${message_707}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# print_help()
print_help__421_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    printf '%s\n' ""
    colored_primary__242_v0 "Xylitol"
    local ret_colored_primary242_v0__7_24="${ret_colored_primary242_v0}"
    local array_26=()
    printf__128_v1 "\\x1b[1m""${ret_colored_primary242_v0__7_24}" array_26[@]
    local array_27=()
    printf__128_v1 " - A tool for " array_27[@]
    colored_primary__242_v0 "fresh"
    local ret_colored_primary242_v0__9_12="${ret_colored_primary242_v0}"
    local array_28=()
    printf__128_v1 "${ret_colored_primary242_v0__9_12}" array_28[@]
    local array_29=()
    printf__128_v1 " shell scripts." array_29[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__243_v0 "Flags: "
    local ret_colored_secondary243_v0__13_12="${ret_colored_secondary243_v0}"
    local array_30=()
    printf__128_v1 "${ret_colored_secondary243_v0__13_12}""
" array_30[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    printf '%s\n' ""
    colored_secondary__243_v0 "Commands: "
    local ret_colored_secondary243_v0__17_12="${ret_colored_secondary243_v0}"
    local array_31=()
    printf__128_v1 "${ret_colored_secondary243_v0__17_12}""
" array_31[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    printf '%s\n' ""
    colored_secondary__243_v0 "Envs: "
    local ret_colored_secondary243_v0__23_12="${ret_colored_secondary243_v0}"
    local array_32=()
    printf__128_v1 "${ret_colored_secondary243_v0__23_12}""
" array_32[@]
    colored__262_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored262_v0__24_78="${ret_colored262_v0}"
    local array_33=()
    printf__128_v1 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored262_v0__24_78}""
" array_33[@]
    colored__262_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored262_v0__25_78="${ret_colored262_v0}"
    local array_34=()
    printf__128_v1 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored262_v0__25_78}""
" array_34[@]
    colored__262_v0 "(default: 3;207;159;92)" 90
    local ret_colored262_v0__26_68="${ret_colored262_v0}"
    local array_35=()
    printf__128_v1 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored262_v0__26_68}""
" array_35[@]
    colored__262_v0 "(default: 3;118;206;94)" 90
    local ret_colored262_v0__27_70="${ret_colored262_v0}"
    local array_36=()
    printf__128_v1 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored262_v0__27_70}""
" array_36[@]
    colored__262_v0 "(default: 234;72;121;95)" 90
    local ret_colored262_v0__28_67="${ret_colored262_v0}"
    local array_37=()
    printf__128_v1 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored262_v0__28_67}""
" array_37[@]
    printf '%s\n' ""
    colored_accent__244_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent244_v0__30_21="${ret_colored_accent244_v0}"
    local array_38=()
    printf__128_v1 "Run ""${ret_colored_accent244_v0__30_21}"" for more information on a command.
" array_38[@]
}

# math_floor(number: Int)
math_floor__502_v0() {
    local number_1791="${1}"
    local command_39
    command_39="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_1791}")"
    __status=$?
    ret_math_floor502_v0="${command_39}"
    return 0
}

# math_ceil(number: Int)
math_ceil__503_v0() {
    local number_1790="${1}"
    math_floor__502_v0 "${number_1790}"
    local ret_math_floor502_v0__52_12="${ret_math_floor502_v0}"
    ret_math_ceil503_v0="$(( ret_math_floor502_v0__52_12 + 1 ))"
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
perl_get_cjk_width__563_v0() {
    local text_1735="${1}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_get_cjk_width563_v0=''
        return 1
    fi
    local command_42
    command_42="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1735}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width563_v0=''
        return "${__status}"
    fi
    local width_str_1736="${command_42}"
    parse_int__13_v0 "${width_str_1736}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width563_v0=''
        return "${__status}"
    fi
    local width_1737="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width563_v0="${width_1737}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__564_v0() {
    local text_1744="${1}"
    local max_width_1745="${2}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_truncate_cjk564_v0=''
        return 1
    fi
    local command_43
    command_43="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_1744}" ${max_width_1745} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk564_v0=''
        return "${__status}"
    fi
    local result_1746="${command_43}"
    ret_perl_truncate_cjk564_v0="${result_1746}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_14=0
_term_size_15=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__571_v0() {
    local command_45
    command_45="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_1720="${command_45}"
    parse_int__13_v0 "${count_1720}"
    __status=$?
    ret_stty_count571_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__572_v0() {
    stty_count__571_v0 
    local count_num_1721="${ret_stty_count571_v0}"
    if [ "$(( count_num_1721 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_1721="$(( count_num_1721 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_1721}
    __status=$?
}

# stty_unlock()
stty_unlock__573_v0() {
    stty_count__571_v0 
    local count_num_1788="${ret_stty_count571_v0}"
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
store_term_size__574_v0() {
    local size_1723="${1}"
    if [ "$([ "_${size_1723}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size574_v0=0
        return 0
    fi
    split__4_v0 "${size_1723}" " "
    local parts_1724=("${ret_split4_v0[@]}")
    local __length_46=("${parts_1724[@]}")
    if [ "$(( ${#__length_46[@]} != 2 ))" != 0 ]; then
        ret_store_term_size574_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1724[1]?"Index out of bounds (at src/./input/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1724[0]?"Index out of bounds (at src/./input/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_15=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size574_v0=1
    return 0
}

# query_term_size()
query_term_size__575_v0() {
    local command_48
    command_48="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1726="${command_48}"
    store_term_size__574_v0 "${size_1726}"
    ret_query_term_size575_v0="${ret_store_term_size574_v0}"
    return 0
}

# stty_term_size()
stty_term_size__576_v0() {
    local command_49
    command_49="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1722="${command_49}"
    store_term_size__574_v0 "${size_1722}"
    ret_stty_term_size576_v0="${ret_store_term_size574_v0}"
    return 0
}

# get_term_size()
get_term_size__577_v0() {
    stty_term_size__576_v0 
    local detected_1725="${ret_stty_term_size576_v0}"
    if [ "$(( ! detected_1725 ))" != 0 ]; then
        query_term_size__575_v0 
        detected_1725="${ret_query_term_size575_v0}"
    fi
    _got_term_size_14=1
}

# term_width()
term_width__579_v0() {
    if [ "$(( ! _got_term_size_14 ))" != 0 ]; then
        get_term_size__577_v0 
    fi
    ret_term_width579_v0="${_term_size_15[0]?"Index out of bounds (at src/./input/../utils/term.ab:93:23)"}"
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
get_supports_truecolor__590_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1703="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_1703}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor590_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor590_v0=0
        return 0
    fi
    local colorterm_1704="${ret_env_var_get120_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_1704}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_1704}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor590_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__591_v0() {
    local message_1698="${1}"
    local r_1699="${2}"
    local g_1700="${3}"
    local b_1701="${4}"
    local fallback_1702="${5}"
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb591_v0="\\x1b[38;2;${r_1699};${g_1700};${b_1701}m""${message_1698}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__590_v0 
        local ret_get_supports_truecolor590_v0__50_17="${ret_get_supports_truecolor590_v0}"
        if [ "${ret_get_supports_truecolor590_v0__50_17}" != 0 ]; then
            ret_colored_rgb591_v0="\\x1b[38;2;${r_1699};${g_1700};${b_1701}m""${message_1698}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1702 == 0 ))" != 0 ]; then
            ret_colored_rgb591_v0="${message_1698}"
            return 0
        else
            ret_colored_rgb591_v0="\\x1b[${fallback_1702}m""${message_1698}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1702 == 0 ))" != 0 ]; then
            ret_colored_rgb591_v0="${message_1698}"
            return 0
        fi
        ret_colored_rgb591_v0="\\x1b[${fallback_1702}m""${message_1698}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__593_v0() {
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1692="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1692}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1692}" ";"
            local parts_1693=("${ret_split4_v0[@]}")
            local __length_53=("${parts_1693[@]}")
            if [ "$(( ${#__length_53[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1693[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1693[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1693[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1693[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_18=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1694="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1694}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1694}" ";"
            local parts_1695=("${ret_split4_v0[@]}")
            local __length_55=("${parts_1695[@]}")
            if [ "$(( ${#__length_55[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1695[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1695[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1695[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1695[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_19=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1696="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1696}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1696}" ";"
            local parts_1697=("${ret_split4_v0[@]}")
            local __length_57=("${parts_1697[@]}")
            if [ "$(( ${#__length_57[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1697[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1697[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1697[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1697[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors593_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__594_v0() {
    inner_get_xylitol_colors__593_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

# colored_primary(message: Text)
colored_primary__595_v0() {
    local message_1691="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__594_v0 
    fi
    colored_rgb__591_v0 "${message_1691}" "${_primary_color_18[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_18[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_18[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_18[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary595_v0="${ret_colored_rgb591_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__596_v0() {
    local message_1705="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__594_v0 
    fi
    colored_rgb__591_v0 "${message_1705}" "${_secondary_color_19[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_19[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_19[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_19[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary596_v0="${ret_colored_rgb591_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__610_v0() {
    local command_59
    command_59="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_1784="${command_59}"
    ret_get_char610_v0="${char_1784}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__613_v0() {
    local format_1762="${1}"
    local args_1763=("${!2}")
    args_1763=("${format_1762}" "${args_1763[@]}")
    __status=$?
    printf "${args_1763[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__614_v0() {
    local message_1772="${1}"
    local color_1773="${2}"
    # Prints an error message with a specified color.
    local array_60=("${message_1772}")
    eprintf__613_v0 "\\x1b[${color_1773}m%s\\x1b[0m" array_60[@]
}

# colored(message: Text, color: Int)
colored__615_v0() {
    local message_1774="${1}"
    local color_1775="${2}"
    # Returns a text wrapped in color codes.
    ret_colored615_v0="\\x1b[${color_1775}m""${message_1774}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__616_v0() {
    local cnt_1786="${1}"
    if [ "$(( cnt_1786 > 0 ))" != 0 ]; then
        local array_61=("")
        eprintf__613_v0 "\\x1b[${cnt_1786}D\\x1b[K" array_61[@]
    fi
}

# remove_line(cnt: Int)
remove_line__617_v0() {
    local cnt_1794="${1}"
    if [ "$(( cnt_1794 > 0 ))" != 0 ]; then
        local sequence_1795=""
        local __range_start_1796=0
        local __range_end_1796="${cnt_1794}"
        local __dir_1796=$(( ${__range_start_1796} <= ${__range_end_1796} ? 1 : -1 ))
        for (( ____1796=${__range_start_1796}; ____1796 * ${__dir_1796} < ${__range_end_1796} * ${__dir_1796}; ____1796+=${__dir_1796} )); do
            sequence_1795+="\\x1b[2K\\x1b[1A"
done
        local array_62=("")
        eprintf__613_v0 "${sequence_1795}" array_62[@]
    fi
    local array_63=("")
    eprintf__613_v0 "\\x1b[G" array_63[@]
}

# remove_current_line()
remove_current_line__618_v0() {
    local array_64=("")
    eprintf__613_v0 "\\x1b[2K\\x1b[G" array_64[@]
}

# new_line(cnt: Int)
new_line__620_v0() {
    local cnt_1764="${1}"
    local __range_start_1765=0
    local __range_end_1765="${cnt_1764}"
    local __dir_1765=$(( ${__range_start_1765} <= ${__range_end_1765} ? 1 : -1 ))
    for (( ____1765=${__range_start_1765}; ____1765 * ${__dir_1765} < ${__range_end_1765} * ${__dir_1765}; ____1765+=${__dir_1765} )); do
        local array_65=("")
        eprintf__613_v0 "
" array_65[@]
done
}

# go_up(cnt: Int)
go_up__621_v0() {
    local cnt_1783="${1}"
    local array_66=("")
    eprintf__613_v0 "\\x1b[${cnt_1783}A" array_66[@]
}

# go_down(cnt: Int)
go_down__622_v0() {
    local cnt_1793="${1}"
    local array_67=("")
    eprintf__613_v0 "\\x1b[${cnt_1793}B" array_67[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__626_v0() {
    local text_1712="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_68
    command_68="$([[ "${text_1712}" == *$'\x1b'* || "${text_1712}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1713="${command_68}"
    ret_has_ansi_escape626_v0="$([ "_${has_escape_1713}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__627_v0() {
    local text_1714="${1}"
    local command_69
    command_69="$(printf '%s' "${text_1714}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi627_v0="${command_69}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__628_v0() {
    local text_1731="${1}"
    local command_70
    command_70="$(printf "%s" "${text_1731}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi628_v0="${command_70}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__629_v0() {
    local text_1733="${1}"
    local command_71
    command_71="$(printf "%s" "${text_1733}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1734="${command_71}"
    ret_is_all_ascii629_v0="$([ "_${result_1734}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__630_v0() {
    local text_1730="${1}"
    strip_ansi__628_v0 "${text_1730}"
    local stripped_1732="${ret_strip_ansi628_v0}"
    # Check if text is all ASCII
    is_all_ascii__629_v0 "${stripped_1732}"
    local ret_is_all_ascii629_v0__150_12="${ret_is_all_ascii629_v0}"
    if [ "$(( ! ret_is_all_ascii629_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__563_v0 "${stripped_1732}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_72="${stripped_1732}"
            ret_get_visible_len630_v0="${#__length_72}"
            return 0
        fi
        ret_get_visible_len630_v0="${ret_perl_get_cjk_width563_v0}"
        return 0
    else
        local __length_73="${stripped_1732}"
        ret_get_visible_len630_v0="${#__length_73}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__631_v0() {
    local text_1741="${1}"
    local max_width_1742="${2}"
    get_visible_len__630_v0 "${text_1741}"
    local visible_len_1743="${ret_get_visible_len630_v0}"
    if [ "$(( visible_len_1743 <= max_width_1742 ))" != 0 ]; then
        ret_truncate_text631_v0="${text_1741}"
        return 0
    fi
    is_all_ascii__629_v0 "${text_1741}"
    local ret_is_all_ascii629_v0__167_12="${ret_is_all_ascii629_v0}"
    if [ "$(( ! ret_is_all_ascii629_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__564_v0 "${text_1741}" "${max_width_1742}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_1741}" | cut -c1-${max_width_1742}
            __status=$?
        fi
        ret_truncate_text631_v0="${ret_perl_truncate_cjk564_v0}"
        return 0
    fi
    local command_74
    command_74="$(printf "%s" "${text_1741}" | cut -c1-${max_width_1742})"
    __status=$?
    ret_truncate_text631_v0="${command_74}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__632_v0() {
    local text_1739="${1}"
    local max_width_1740="${2}"
    has_ansi_escape__626_v0 "${text_1739}"
    local ret_has_ansi_escape626_v0__179_12="${ret_has_ansi_escape626_v0}"
    if [ "$(( ! ret_has_ansi_escape626_v0__179_12 ))" != 0 ]; then
        truncate_text__631_v0 "${text_1739}" "${max_width_1740}"
        ret_truncate_ansi632_v0="${ret_truncate_text631_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_75
    command_75="$([[ "${text_1739}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_1747="${command_75}"
    # Replace \x1b[ with newline, then split
    local command_76
    command_76="$(t="${text_1739}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_1748="${command_76}"
    split__4_v0 "${replaced_1748}" "
"
    local parts_1749=("${ret_split4_v0[@]}")
    local result_1750=""
    local remaining_width_1751="${max_width_1740}"
    local __range_start_1752=0
    local __length_77=("${parts_1749[@]}")
    local __range_end_1752="${#__length_77[@]}"
    local __dir_1752=$(( ${__range_start_1752} <= ${__range_end_1752} ? 1 : -1 ))
    for (( idx_1752=${__range_start_1752}; idx_1752 * ${__dir_1752} < ${__range_end_1752} * ${__dir_1752}; idx_1752+=${__dir_1752} )); do
        local part_1753="${parts_1749[${idx_1752}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_1752 == 0 )) && $([ "_${starts_with_ansi_1747}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_1753}" == "_" ]; echo $?) && $(( remaining_width_1751 > 0 )) ))" != 0 ]; then
                truncate_text__631_v0 "${part_1753}" "${remaining_width_1751}"
                local ret_truncate_text631_v0__201_35="${ret_truncate_text631_v0}"
                local truncated_1754="${ret_truncate_text631_v0__201_35}"
                result_1750+="${truncated_1754}"
                get_visible_len__630_v0 "${truncated_1754}"
                local ret_get_visible_len630_v0__203_36="${ret_get_visible_len630_v0}"
                remaining_width_1751="$(( remaining_width_1751 - ret_get_visible_len630_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_78
            command_78="$(__p="${part_1753}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_1755="${command_78}"
            if [ "$([ "_${m_idx_1755}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_79
                command_79="$(__p="${part_1753}"; printf "%s" "${__p:0:${m_idx_1755}}")"
                __status=$?
                local ansi_params_1756="${command_79}"
                result_1750+="\\x1b[""${ansi_params_1756}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_1755}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_1757="${ret_parse_int13_v0__214_41}"
                local text_start_1758="$(( m_idx_num_1757 + 1 ))"
                local command_80
                command_80="$(__p="${part_1753}"; printf "%s" "${__p:${text_start_1758}}")"
                __status=$?
                local text_part_1759="${command_80}"
                if [ "$(( $([ "_${text_part_1759}" == "_" ]; echo $?) && $(( remaining_width_1751 > 0 )) ))" != 0 ]; then
                    truncate_text__631_v0 "${text_part_1759}" "${remaining_width_1751}"
                    local ret_truncate_text631_v0__218_39="${ret_truncate_text631_v0}"
                    local truncated_1760="${ret_truncate_text631_v0__218_39}"
                    result_1750+="${truncated_1760}"
                    get_visible_len__630_v0 "${truncated_1760}"
                    local ret_get_visible_len630_v0__220_40="${ret_get_visible_len630_v0}"
                    remaining_width_1751="$(( remaining_width_1751 - ret_get_visible_len630_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_1753}" == "_" ]; echo $?) && $(( remaining_width_1751 > 0 )) ))" != 0 ]; then
                    truncate_text__631_v0 "${part_1753}" "${remaining_width_1751}"
                    local ret_truncate_text631_v0__225_39="${ret_truncate_text631_v0}"
                    local truncated_1761="${ret_truncate_text631_v0__225_39}"
                    result_1750+="${truncated_1761}"
                    get_visible_len__630_v0 "${truncated_1761}"
                    local ret_get_visible_len630_v0__227_40="${ret_get_visible_len630_v0}"
                    remaining_width_1751="$(( remaining_width_1751 - ret_get_visible_len630_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi632_v0="${result_1750}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__633_v0() {
    local text_1728="${1}"
    local max_width_1729="${2}"
    get_visible_len__630_v0 "${text_1728}"
    local visible_len_1738="${ret_get_visible_len630_v0}"
    if [ "$(( visible_len_1738 <= max_width_1729 ))" != 0 ]; then
        ret_cutoff_text633_v0="${text_1728}"
        return 0
    fi
    truncate_ansi__632_v0 "${text_1728}" "$(( max_width_1729 - 3 ))"
    local ret_truncate_ansi632_v0__243_12="${ret_truncate_ansi632_v0}"
    ret_cutoff_text633_v0="${ret_truncate_ansi632_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__634_v0() {
    local items_1766=("${!1}")
    local total_len_1767="${2}"
    local term_width_1768="${3}"
    local separator_1769=" • "
    local separator_len_1770=3
    # Fast path: no truncation needed
    if [ "$(( total_len_1767 <= term_width_1768 ))" != 0 ]; then
        local iter_1771=0
        while :
        do
            local __length_81=("${items_1766[@]}")
            if [ "$(( iter_1771 >= ${#__length_81[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_1771 > 0 ))" != 0 ]; then
                eprintf_colored__614_v0 "${separator_1769}" 90
            fi
            colored__615_v0 "${items_1766[$(( iter_1771 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored615_v0__268_41="${ret_colored615_v0}"
            local array_82=("")
            eprintf__613_v0 "${items_1766[${iter_1771}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored615_v0__268_41}" array_82[@]
            iter_1771="$(( iter_1771 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_1776=0
        local first_1777=1
        local iter_1778=0
        while :
        do
            local __length_83=("${items_1766[@]}")
            if [ "$(( iter_1778 >= ${#__length_83[@]} ))" != 0 ]; then
                break
            fi
            local key_1779="${items_1766[${iter_1778}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_1780="${items_1766[$(( iter_1778 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_84="${key_1779}"
            local __length_85="${action_1780}"
            local part_len_1781="$(( $(( ${#__length_84} + 1 )) + ${#__length_85} ))"
            local needed_1782="${part_len_1781}"
            if [ "$(( ! first_1777 ))" != 0 ]; then
                needed_1782="$(( needed_1782 + separator_len_1770 ))"
            fi
            if [ "$(( $(( current_len_1776 + needed_1782 )) > term_width_1768 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_1777 ))" != 0 ]; then
                eprintf_colored__614_v0 "${separator_1769}" 90
            fi
            colored__615_v0 "${action_1780}" 2
            local ret_colored615_v0__296_33="${ret_colored615_v0}"
            local array_86=("")
            eprintf__613_v0 "${key_1779}"" ""${ret_colored615_v0__296_33}" array_86[@]
            current_len_1776="$(( current_len_1776 + needed_1782 ))"
            first_1777=0
            iter_1778="$(( iter_1778 + 2 ))"
        done
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__683_v0() {
    local prompt_1716="${1}"
    local placeholder_1717="${2}"
    local header_1718="${3}"
    local password_1719="${4}"
    stty_lock__572_v0 
    term_width__579_v0 
    local term_width_1727="${ret_term_width579_v0}"
    if [ "$([ "_${header_1718}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__633_v0 "${header_1718}" "${term_width_1727}"
        local ret_cutoff_text633_v0__23_17="${ret_cutoff_text633_v0}"
        local array_87=("")
        eprintf__613_v0 "${ret_cutoff_text633_v0__23_17}""
" array_87[@]
    fi
    new_line__620_v0 2
    # "enter submit" = 12
    local array_88=("enter" "submit")
    render_tooltip__634_v0 array_88[@] 12 "${term_width_1727}"
    go_up__621_v0 2
    local array_89=("")
    eprintf__613_v0 "\\x1b[G" array_89[@]
    local array_90=("")
    eprintf__613_v0 "${prompt_1716}" array_90[@]
    eprintf_colored__614_v0 "${placeholder_1717}" 90
    get_char__610_v0 
    local char_1785="${ret_get_char610_v0}"
    local __length_91="${prompt_1716}"
    remove__616_v0 "${#__length_91}"
    local __length_92="${placeholder_1717}"
    remove__616_v0 "$(( ${#__length_92} + 1 ))"
    local text_1787=""
    if [ "$(( ! password_1719 ))" != 0 ]; then
        stty_unlock__573_v0 
        local command_93
        command_93="$(read -e -i ${char_1785} -p "${prompt_1716}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1787="${command_93}"
    else
        stty_unlock__573_v0 
        local command_94
        command_94="$(read -es -i ${char_1785} -p "${prompt_1716}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1787="${command_94}"
    fi
    stty_lock__572_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__630_v0 "${prompt_1716}""${text_1787}"
    local input_display_len_1789="${ret_get_visible_len630_v0}"
    math_ceil__503_v0 "$(( input_display_len_1789 / term_width_1727 ))"
    local input_lines_1792="${ret_math_ceil503_v0}"
    if [ "$(( input_lines_1792 < 3 ))" != 0 ]; then
        go_down__622_v0 "$(( 2 - input_lines_1792 ))"
        remove_line__617_v0 2
        remove_current_line__618_v0 
    fi
    if [ "$(( input_lines_1792 >= 3 ))" != 0 ]; then
        remove_line__617_v0 "${input_lines_1792}"
    fi
    if [ "$([ "_${header_1718}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__617_v0 1
        remove_current_line__618_v0 
    fi
    stty_unlock__573_v0 
    ret_xyl_input683_v0="${text_1787}"
    return 0
}

# print_input_help()
print_input_help__775_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    printf '%s\n' ""
    colored_primary__595_v0 "input"
    local ret_colored_primary595_v0__7_12="${ret_colored_primary595_v0}"
    local array_95=()
    printf__128_v1 "${ret_colored_primary595_v0__7_12}" array_95[@]
    local array_96=()
    printf__128_v1 " - Prompt for some input from the user." array_96[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__596_v0 "Flags: "
    local ret_colored_secondary596_v0__11_12="${ret_colored_secondary596_v0}"
    local array_97=()
    printf__128_v1 "${ret_colored_secondary596_v0__11_12}""
" array_97[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__825_v0() {
    local parameters_1685=("${!1}")
    local prompt_1686="> "
    local placeholder_1687="Type here..."
    local header_1688=""
    local password_1689=0
    for param_1690 in "${parameters_1685[@]}"; do
        if [ "$(( $([ "_${param_1690}" != "_-h" ]; echo $?) || $([ "_${param_1690}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__775_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_1690}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_100="--prompt="
            slice__24_v0 "${param_1690}" "${#__length_100}" 0
            prompt_1686="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_1690}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_101="--placeholder="
            slice__24_v0 "${param_1690}" "${#__length_101}" 0
            placeholder_1687="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_1690}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_102="--header="
            slice__24_v0 "${param_1690}" "${#__length_102}" 0
            header_1688="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_1690}" != "_--password" ]; echo $?)" != 0 ]; then
            password_1689=1
        fi
    done
    has_ansi_escape__626_v0 "${header_1688}"
    local ret_has_ansi_escape626_v0__31_44="${ret_has_ansi_escape626_v0}"
    escape_ansi__627_v0 "${header_1688}"
    local ret_escape_ansi627_v0__31_73="${ret_escape_ansi627_v0}"
    colored_primary__595_v0 "${header_1688}"
    local ret_colored_primary595_v0__31_111="${ret_colored_primary595_v0}"
    local display_header_1715
    display_header_1715="$(if [ "$(( $([ "_${header_1688}" != "_" ]; echo $?) || ret_has_ansi_escape626_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi627_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary595_v0__31_111}"; fi)"
    xyl_input__683_v0 "${prompt_1686}" "${placeholder_1687}" "${display_header_1715}" "${password_1689}"
    ret_execute_input825_v0="${ret_xyl_input683_v0}"
    return 0
}

# Perl Extensions Utilities
command_103="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_103}" != "_No" ]; echo $?)"
command_104="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! _perl_disabled_21 )) && $([ "_${command_104}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__957_v0() {
    local text_13322="${1}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_get_cjk_width957_v0=''
        return 1
    fi
    local command_105
    command_105="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_13322}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width957_v0=''
        return "${__status}"
    fi
    local width_str_13323="${command_105}"
    parse_int__13_v0 "${width_str_13323}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width957_v0=''
        return "${__status}"
    fi
    local width_13324="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width957_v0="${width_13324}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__958_v0() {
    local text_13331="${1}"
    local max_width_13332="${2}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_truncate_cjk958_v0=''
        return 1
    fi
    local command_106
    command_106="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_13331}" ${max_width_13332} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk958_v0=''
        return "${__status}"
    fi
    local result_13333="${command_106}"
    ret_perl_truncate_cjk958_v0="${result_13333}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_23=0
_term_size_24=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__965_v0() {
    local command_108
    command_108="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_13306="${command_108}"
    parse_int__13_v0 "${count_13306}"
    __status=$?
    ret_stty_count965_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__966_v0() {
    stty_count__965_v0 
    local count_num_13307="${ret_stty_count965_v0}"
    if [ "$(( count_num_13307 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_13307="$(( count_num_13307 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13307}
    __status=$?
}

# stty_unlock()
stty_unlock__967_v0() {
    stty_count__965_v0 
    local count_num_13417="${ret_stty_count965_v0}"
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
store_term_size__968_v0() {
    local size_13309="${1}"
    if [ "$([ "_${size_13309}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size968_v0=0
        return 0
    fi
    split__4_v0 "${size_13309}" " "
    local parts_13310=("${ret_split4_v0[@]}")
    local __length_109=("${parts_13310[@]}")
    if [ "$(( ${#__length_109[@]} != 2 ))" != 0 ]; then
        ret_store_term_size968_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_13310[1]?"Index out of bounds (at src/./choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_13310[0]?"Index out of bounds (at src/./choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_24=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size968_v0=1
    return 0
}

# query_term_size()
query_term_size__969_v0() {
    local command_111
    command_111="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_13312="${command_111}"
    store_term_size__968_v0 "${size_13312}"
    ret_query_term_size969_v0="${ret_store_term_size968_v0}"
    return 0
}

# stty_term_size()
stty_term_size__970_v0() {
    local command_112
    command_112="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_13308="${command_112}"
    store_term_size__968_v0 "${size_13308}"
    ret_stty_term_size970_v0="${ret_store_term_size968_v0}"
    return 0
}

# get_term_size()
get_term_size__971_v0() {
    stty_term_size__970_v0 
    local detected_13311="${ret_stty_term_size970_v0}"
    if [ "$(( ! detected_13311 ))" != 0 ]; then
        query_term_size__969_v0 
        detected_13311="${ret_query_term_size969_v0}"
    fi
    _got_term_size_23=1
}

# term_width()
term_width__973_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__971_v0 
    fi
    ret_term_width973_v0="${_term_size_24[0]?"Index out of bounds (at src/./choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__974_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__971_v0 
    fi
    ret_term_height974_v0="${_term_size_24[1]?"Index out of bounds (at src/./choose/../utils/term.ab:101:23)"}"
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
get_supports_truecolor__984_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_13273="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_13273}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor984_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor984_v0=0
        return 0
    fi
    local colorterm_13274="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_13274}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_13274}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor984_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__985_v0() {
    local message_13268="${1}"
    local r_13269="${2}"
    local g_13270="${3}"
    local b_13271="${4}"
    local fallback_13272="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb985_v0="\\x1b[38;2;${r_13269};${g_13270};${b_13271}m""${message_13268}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__984_v0 
        local ret_get_supports_truecolor984_v0__50_17="${ret_get_supports_truecolor984_v0}"
        if [ "${ret_get_supports_truecolor984_v0__50_17}" != 0 ]; then
            ret_colored_rgb985_v0="\\x1b[38;2;${r_13269};${g_13270};${b_13271}m""${message_13268}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_13272 == 0 ))" != 0 ]; then
            ret_colored_rgb985_v0="${message_13268}"
            return 0
        else
            ret_colored_rgb985_v0="\\x1b[${fallback_13272}m""${message_13268}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_13272 == 0 ))" != 0 ]; then
            ret_colored_rgb985_v0="${message_13268}"
            return 0
        fi
        ret_colored_rgb985_v0="\\x1b[${fallback_13272}m""${message_13268}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__987_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_13262="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_13262}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_13262}" ";"
            local parts_13263=("${ret_split4_v0[@]}")
            local __length_116=("${parts_13263[@]}")
            if [ "$(( ${#__length_116[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13263[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13263[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13263[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13263[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_27=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_13264="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_13264}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_13264}" ";"
            local parts_13265=("${ret_split4_v0[@]}")
            local __length_118=("${parts_13265[@]}")
            if [ "$(( ${#__length_118[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13265[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13265[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13265[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13265[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_28=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_13266="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_13266}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_13266}" ";"
            local parts_13267=("${ret_split4_v0[@]}")
            local __length_120=("${parts_13267[@]}")
            if [ "$(( ${#__length_120[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13267[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13267[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13267[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13267[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors987_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__988_v0() {
    inner_get_xylitol_colors__987_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__989_v0() {
    local message_13261="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__988_v0 
    fi
    colored_rgb__985_v0 "${message_13261}" "${_primary_color_27[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary989_v0="${ret_colored_rgb985_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__990_v0() {
    local message_13283="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__988_v0 
    fi
    colored_rgb__985_v0 "${message_13283}" "${_secondary_color_28[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary990_v0="${ret_colored_rgb985_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1005_v0() {
    local command_122
    command_122="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_13395="${command_122}"
    if [ "$([ "_${var_13395}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1005_v0="UP"
        return 0
    elif [ "$([ "_${var_13395}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1005_v0="DOWN"
        return 0
    elif [ "$([ "_${var_13395}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1005_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_13395}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1005_v0="LEFT"
        return 0
    elif [ "$([ "_${var_13395}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1005_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_13395}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1005_v0="INPUT"
        return 0
    else
        ret_get_key1005_v0="${var_13395}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1007_v0() {
    local format_13287="${1}"
    local args_13288=("${!2}")
    args_13288=("${format_13287}" "${args_13288[@]}")
    __status=$?
    printf "${args_13288[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1008_v0() {
    local message_13285="${1}"
    local color_13286="${2}"
    # Prints an error message with a specified color.
    local array_123=("${message_13285}")
    eprintf__1007_v0 "\\x1b[${color_13286}m%s\\x1b[0m" array_123[@]
}

# colored(message: Text, color: Int)
colored__1009_v0() {
    local message_13358="${1}"
    local color_13359="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1009_v0="\\x1b[${color_13359}m""${message_13358}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1011_v0() {
    local cnt_13392="${1}"
    if [ "$(( cnt_13392 > 0 ))" != 0 ]; then
        local sequence_13393=""
        local __range_start_13394=0
        local __range_end_13394="${cnt_13392}"
        local __dir_13394=$(( ${__range_start_13394} <= ${__range_end_13394} ? 1 : -1 ))
        for (( ____13394=${__range_start_13394}; ____13394 * ${__dir_13394} < ${__range_end_13394} * ${__dir_13394}; ____13394+=${__dir_13394} )); do
            sequence_13393+="\\x1b[2K\\x1b[1A"
done
        local array_124=("")
        eprintf__1007_v0 "${sequence_13393}" array_124[@]
    fi
    local array_125=("")
    eprintf__1007_v0 "\\x1b[G" array_125[@]
}

# remove_current_line()
remove_current_line__1012_v0() {
    local array_126=("")
    eprintf__1007_v0 "\\x1b[2K\\x1b[G" array_126[@]
}

# print_blank(cnt: Int)
print_blank__1013_v0() {
    local cnt_13383="${1}"
    printf '%*s' "${cnt_13383}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1014_v0() {
    local cnt_13350="${1}"
    local __range_start_13351=0
    local __range_end_13351="${cnt_13350}"
    local __dir_13351=$(( ${__range_start_13351} <= ${__range_end_13351} ? 1 : -1 ))
    for (( ____13351=${__range_start_13351}; ____13351 * ${__dir_13351} < ${__range_end_13351} * ${__dir_13351}; ____13351+=${__dir_13351} )); do
        local array_127=("")
        eprintf__1007_v0 "
" array_127[@]
done
}

# go_up(cnt: Int)
go_up__1015_v0() {
    local cnt_13367="${1}"
    local array_128=("")
    eprintf__1007_v0 "\\x1b[${cnt_13367}A" array_128[@]
}

# go_down(cnt: Int)
go_down__1016_v0() {
    local cnt_13404="${1}"
    local array_129=("")
    eprintf__1007_v0 "\\x1b[${cnt_13404}B" array_129[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1017_v0() {
    local cnt_13413="${1}"
    if [ "$(( cnt_13413 > 0 ))" != 0 ]; then
        go_down__1016_v0 "${cnt_13413}"
    else
        go_up__1015_v0 "$(( - cnt_13413 ))"
    fi
}

# hide_cursor()
hide_cursor__1018_v0() {
    local array_130=("")
    eprintf__1007_v0 "\\x1b[?25l" array_130[@]
}

# show_cursor()
show_cursor__1019_v0() {
    local array_131=("")
    eprintf__1007_v0 "\\x1b[?25h" array_131[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1020_v0() {
    local text_13290="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_132
    command_132="$([[ "${text_13290}" == *$'\x1b'* || "${text_13290}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_13291="${command_132}"
    ret_has_ansi_escape1020_v0="$([ "_${has_escape_13291}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1021_v0() {
    local text_13292="${1}"
    local command_133
    command_133="$(printf '%s' "${text_13292}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1021_v0="${command_133}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1022_v0() {
    local text_13318="${1}"
    local command_134
    command_134="$(printf "%s" "${text_13318}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1022_v0="${command_134}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1023_v0() {
    local text_13320="${1}"
    local command_135
    command_135="$(printf "%s" "${text_13320}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_13321="${command_135}"
    ret_is_all_ascii1023_v0="$([ "_${result_13321}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1024_v0() {
    local text_13317="${1}"
    strip_ansi__1022_v0 "${text_13317}"
    local stripped_13319="${ret_strip_ansi1022_v0}"
    # Check if text is all ASCII
    is_all_ascii__1023_v0 "${stripped_13319}"
    local ret_is_all_ascii1023_v0__150_12="${ret_is_all_ascii1023_v0}"
    if [ "$(( ! ret_is_all_ascii1023_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__957_v0 "${stripped_13319}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_136="${stripped_13319}"
            ret_get_visible_len1024_v0="${#__length_136}"
            return 0
        fi
        ret_get_visible_len1024_v0="${ret_perl_get_cjk_width957_v0}"
        return 0
    else
        local __length_137="${stripped_13319}"
        ret_get_visible_len1024_v0="${#__length_137}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1025_v0() {
    local text_13328="${1}"
    local max_width_13329="${2}"
    get_visible_len__1024_v0 "${text_13328}"
    local visible_len_13330="${ret_get_visible_len1024_v0}"
    if [ "$(( visible_len_13330 <= max_width_13329 ))" != 0 ]; then
        ret_truncate_text1025_v0="${text_13328}"
        return 0
    fi
    is_all_ascii__1023_v0 "${text_13328}"
    local ret_is_all_ascii1023_v0__167_12="${ret_is_all_ascii1023_v0}"
    if [ "$(( ! ret_is_all_ascii1023_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__958_v0 "${text_13328}" "${max_width_13329}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_13328}" | cut -c1-${max_width_13329}
            __status=$?
        fi
        ret_truncate_text1025_v0="${ret_perl_truncate_cjk958_v0}"
        return 0
    fi
    local command_138
    command_138="$(printf "%s" "${text_13328}" | cut -c1-${max_width_13329})"
    __status=$?
    ret_truncate_text1025_v0="${command_138}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1026_v0() {
    local text_13326="${1}"
    local max_width_13327="${2}"
    has_ansi_escape__1020_v0 "${text_13326}"
    local ret_has_ansi_escape1020_v0__179_12="${ret_has_ansi_escape1020_v0}"
    if [ "$(( ! ret_has_ansi_escape1020_v0__179_12 ))" != 0 ]; then
        truncate_text__1025_v0 "${text_13326}" "${max_width_13327}"
        ret_truncate_ansi1026_v0="${ret_truncate_text1025_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_139
    command_139="$([[ "${text_13326}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_13334="${command_139}"
    # Replace \x1b[ with newline, then split
    local command_140
    command_140="$(t="${text_13326}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_13335="${command_140}"
    split__4_v0 "${replaced_13335}" "
"
    local parts_13336=("${ret_split4_v0[@]}")
    local result_13337=""
    local remaining_width_13338="${max_width_13327}"
    local __range_start_13339=0
    local __length_141=("${parts_13336[@]}")
    local __range_end_13339="${#__length_141[@]}"
    local __dir_13339=$(( ${__range_start_13339} <= ${__range_end_13339} ? 1 : -1 ))
    for (( idx_13339=${__range_start_13339}; idx_13339 * ${__dir_13339} < ${__range_end_13339} * ${__dir_13339}; idx_13339+=${__dir_13339} )); do
        local part_13340="${parts_13336[${idx_13339}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_13339 == 0 )) && $([ "_${starts_with_ansi_13334}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_13340}" == "_" ]; echo $?) && $(( remaining_width_13338 > 0 )) ))" != 0 ]; then
                truncate_text__1025_v0 "${part_13340}" "${remaining_width_13338}"
                local ret_truncate_text1025_v0__201_35="${ret_truncate_text1025_v0}"
                local truncated_13341="${ret_truncate_text1025_v0__201_35}"
                result_13337+="${truncated_13341}"
                get_visible_len__1024_v0 "${truncated_13341}"
                local ret_get_visible_len1024_v0__203_36="${ret_get_visible_len1024_v0}"
                remaining_width_13338="$(( remaining_width_13338 - ret_get_visible_len1024_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_142
            command_142="$(__p="${part_13340}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_13342="${command_142}"
            if [ "$([ "_${m_idx_13342}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_143
                command_143="$(__p="${part_13340}"; printf "%s" "${__p:0:${m_idx_13342}}")"
                __status=$?
                local ansi_params_13343="${command_143}"
                result_13337+="\\x1b[""${ansi_params_13343}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_13342}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_13344="${ret_parse_int13_v0__214_41}"
                local text_start_13345="$(( m_idx_num_13344 + 1 ))"
                local command_144
                command_144="$(__p="${part_13340}"; printf "%s" "${__p:${text_start_13345}}")"
                __status=$?
                local text_part_13346="${command_144}"
                if [ "$(( $([ "_${text_part_13346}" == "_" ]; echo $?) && $(( remaining_width_13338 > 0 )) ))" != 0 ]; then
                    truncate_text__1025_v0 "${text_part_13346}" "${remaining_width_13338}"
                    local ret_truncate_text1025_v0__218_39="${ret_truncate_text1025_v0}"
                    local truncated_13347="${ret_truncate_text1025_v0__218_39}"
                    result_13337+="${truncated_13347}"
                    get_visible_len__1024_v0 "${truncated_13347}"
                    local ret_get_visible_len1024_v0__220_40="${ret_get_visible_len1024_v0}"
                    remaining_width_13338="$(( remaining_width_13338 - ret_get_visible_len1024_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_13340}" == "_" ]; echo $?) && $(( remaining_width_13338 > 0 )) ))" != 0 ]; then
                    truncate_text__1025_v0 "${part_13340}" "${remaining_width_13338}"
                    local ret_truncate_text1025_v0__225_39="${ret_truncate_text1025_v0}"
                    local truncated_13348="${ret_truncate_text1025_v0__225_39}"
                    result_13337+="${truncated_13348}"
                    get_visible_len__1024_v0 "${truncated_13348}"
                    local ret_get_visible_len1024_v0__227_40="${ret_get_visible_len1024_v0}"
                    remaining_width_13338="$(( remaining_width_13338 - ret_get_visible_len1024_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1026_v0="${result_13337}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1027_v0() {
    local text_13315="${1}"
    local max_width_13316="${2}"
    get_visible_len__1024_v0 "${text_13315}"
    local visible_len_13325="${ret_get_visible_len1024_v0}"
    if [ "$(( visible_len_13325 <= max_width_13316 ))" != 0 ]; then
        ret_cutoff_text1027_v0="${text_13315}"
        return 0
    fi
    truncate_ansi__1026_v0 "${text_13315}" "$(( max_width_13316 - 3 ))"
    local ret_truncate_ansi1026_v0__243_12="${ret_truncate_ansi1026_v0}"
    ret_cutoff_text1027_v0="${ret_truncate_ansi1026_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1028_v0() {
    local items_13352=("${!1}")
    local total_len_13353="${2}"
    local term_width_13354="${3}"
    local separator_13355=" • "
    local separator_len_13356=3
    # Fast path: no truncation needed
    if [ "$(( total_len_13353 <= term_width_13354 ))" != 0 ]; then
        local iter_13357=0
        while :
        do
            local __length_145=("${items_13352[@]}")
            if [ "$(( iter_13357 >= ${#__length_145[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_13357 > 0 ))" != 0 ]; then
                eprintf_colored__1008_v0 "${separator_13355}" 90
            fi
            colored__1009_v0 "${items_13352[$(( iter_13357 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1009_v0__268_41="${ret_colored1009_v0}"
            local array_146=("")
            eprintf__1007_v0 "${items_13352[${iter_13357}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1009_v0__268_41}" array_146[@]
            iter_13357="$(( iter_13357 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_13360=0
        local first_13361=1
        local iter_13362=0
        while :
        do
            local __length_147=("${items_13352[@]}")
            if [ "$(( iter_13362 >= ${#__length_147[@]} ))" != 0 ]; then
                break
            fi
            local key_13363="${items_13352[${iter_13362}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_13364="${items_13352[$(( iter_13362 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_148="${key_13363}"
            local __length_149="${action_13364}"
            local part_len_13365="$(( $(( ${#__length_148} + 1 )) + ${#__length_149} ))"
            local needed_13366="${part_len_13365}"
            if [ "$(( ! first_13361 ))" != 0 ]; then
                needed_13366="$(( needed_13366 + separator_len_13356 ))"
            fi
            if [ "$(( $(( current_len_13360 + needed_13366 )) > term_width_13354 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_13361 ))" != 0 ]; then
                eprintf_colored__1008_v0 "${separator_13355}" 90
            fi
            colored__1009_v0 "${action_13364}" 2
            local ret_colored1009_v0__296_33="${ret_colored1009_v0}"
            local array_150=("")
            eprintf__1007_v0 "${key_13363}"" ""${ret_colored1009_v0__296_33}" array_150[@]
            current_len_13360="$(( current_len_13360 + needed_13366 ))"
            first_13361=0
            iter_13362="$(( iter_13362 + 2 ))"
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
render_single_page__1172_v0() {
    local __length_153="${_cursor_39}"
    local cursor_len_13386="${#__length_153}"
    local max_option_width_13387="$(( $(( _term_width_42 - cursor_len_13386 )) - 1 ))"
    local __range_start_13388=0
    local __range_end_13388="${_page_count_45}"
    local __dir_13388=$(( ${__range_start_13388} <= ${__range_end_13388} ? 1 : -1 ))
    for (( i_13388=${__range_start_13388}; i_13388 * ${__dir_13388} < ${__range_end_13388} * ${__dir_13388}; i_13388+=${__dir_13388} )); do
        cutoff_text__1027_v0 "${_page_44[${i_13388}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_13387}"
        local ret_cutoff_text1027_v0__48_27="${ret_cutoff_text1027_v0}"
        local truncated_13389="${ret_cutoff_text1027_v0__48_27}"
        if [ "$(( i_13388 == _selected_38 ))" != 0 ]; then
            colored_secondary__990_v0 "${_cursor_39}""${truncated_13389}""
"
            local ret_colored_secondary990_v0__50_21="${ret_colored_secondary990_v0}"
            local array_154=("")
            eprintf__1007_v0 "${ret_colored_secondary990_v0__50_21}" array_154[@]
        else
            print_blank__1013_v0 "${cursor_len_13386}"
            local array_155=("")
            eprintf__1007_v0 "${truncated_13389}""
" array_155[@]
        fi
done
    local remaining_slots_13390="$(( _display_count_35 - _page_count_45 ))"
    if [ "$(( remaining_slots_13390 > 0 ))" != 0 ]; then
        local __range_start_13391=0
        local __range_end_13391="${remaining_slots_13390}"
        local __dir_13391=$(( ${__range_start_13391} <= ${__range_end_13391} ? 1 : -1 ))
        for (( ____13391=${__range_start_13391}; ____13391 * ${__dir_13391} < ${__range_end_13391} * ${__dir_13391}; ____13391+=${__dir_13391} )); do
            local array_156=("")
            eprintf__1007_v0 "\\x1b[K
" array_156[@]
done
    fi
}

# render_multi_page()
render_multi_page__1173_v0() {
    local __length_157="${_cursor_39}"
    local cursor_len_13376="${#__length_157}"
    local max_option_width_13377="$(( $(( _term_width_42 - cursor_len_13376 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1178_v0 
    local page_start_13378="${ret_chooser_page_start1178_v0}"
    local __range_start_13379=0
    local __range_end_13379="${_page_count_45}"
    local __dir_13379=$(( ${__range_start_13379} <= ${__range_end_13379} ? 1 : -1 ))
    for (( i_13379=${__range_start_13379}; i_13379 * ${__dir_13379} < ${__range_end_13379} * ${__dir_13379}; i_13379+=${__dir_13379} )); do
        local global_idx_13380="$(( page_start_13378 + i_13379 ))"
        local check_mark_13381
        check_mark_13381="$(if [ "${_checked_46[${global_idx_13380}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1027_v0 "${_page_44[${i_13379}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_13377}"
        local ret_cutoff_text1027_v0__71_27="${ret_cutoff_text1027_v0}"
        local truncated_13382="${ret_cutoff_text1027_v0__71_27}"
        if [ "$(( i_13379 == _selected_38 ))" != 0 ]; then
            colored_secondary__990_v0 "${_cursor_39}""${check_mark_13381}""${truncated_13382}""
"
            local ret_colored_secondary990_v0__73_37="${ret_colored_secondary990_v0}"
            local array_158=("")
            eprintf__1007_v0 "${ret_colored_secondary990_v0__73_37}" array_158[@]
        elif [ "${_checked_46[${global_idx_13380}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1013_v0 "${cursor_len_13376}"
            colored_secondary__990_v0 "${check_mark_13381}""${truncated_13382}""
"
            local ret_colored_secondary990_v0__76_25="${ret_colored_secondary990_v0}"
            local array_159=("")
            eprintf__1007_v0 "${ret_colored_secondary990_v0__76_25}" array_159[@]
        else
            print_blank__1013_v0 "${cursor_len_13376}"
            local array_160=("")
            eprintf__1007_v0 "${check_mark_13381}""${truncated_13382}""
" array_160[@]
        fi
done
    local remaining_slots_13384="$(( _display_count_35 - _page_count_45 ))"
    if [ "$(( remaining_slots_13384 > 0 ))" != 0 ]; then
        local __range_start_13385=0
        local __range_end_13385="${remaining_slots_13384}"
        local __dir_13385=$(( ${__range_start_13385} <= ${__range_end_13385} ? 1 : -1 ))
        for (( ____13385=${__range_start_13385}; ____13385 * ${__dir_13385} < ${__range_end_13385} * ${__dir_13385}; ____13385+=${__dir_13385} )); do
            local array_161=("")
            eprintf__1007_v0 "\\x1b[K
" array_161[@]
done
    fi
}

# render_page()
render_page__1174_v0() {
    if [ "${_multi_40}" != 0 ]; then
        render_multi_page__1173_v0 
    else
        render_single_page__1172_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1175_v0() {
    if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
        local array_162=("")
        eprintf__1007_v0 "\\x1b[G\\x1b[K" array_162[@]
        eprintf_colored__1008_v0 "Page $(( _current_page_37 + 1 ))/${_total_pages_36}" 90
        local array_163=("")
        eprintf__1007_v0 "\\x1b[G" array_163[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1176_v0() {
    if [ "$(( ! _multi_40 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
            local array_164=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1028_v0 array_164[@] 36 "${_term_width_42}"
        else
            local array_165=("↑↓" "select" "enter" "confirm")
            render_tooltip__1028_v0 array_165[@] 25 "${_term_width_42}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_36 > 1 )) && $(( _limit_41 < 0 )) ))" != 0 ]; then
            local array_166=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1028_v0 array_166[@] 55 "${_term_width_42}"
        elif [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
            local array_167=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1028_v0 array_167[@] 47 "${_term_width_42}"
        elif [ "$(( _limit_41 < 0 ))" != 0 ]; then
            local array_168=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1028_v0 array_168[@] 44 "${_term_width_42}"
        else
            local array_169=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1028_v0 array_169[@] 36 "${_term_width_42}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1177_v0() {
    local total_13300="${1}"
    local page_size_13301="${2}"
    local header_13302="${3}"
    local cursor_13303="${4}"
    local multi_13304="${5}"
    local limit_13305="${6}"
    _total_33="${total_13300}"
    _cursor_39="${cursor_13303}"
    _multi_40="${multi_13304}"
    _limit_41="${limit_13305}"
    _current_page_37=0
    _selected_38=0
    _first_render_48=1
    _up_paged_49=0
    _checked_count_47=0
    _has_header_43="$([ "_${header_13302}" == "_" ]; echo $?)"
    stty_lock__966_v0 
    hide_cursor__1018_v0 
    term_width__973_v0 
    _term_width_42="${ret_term_width973_v0}"
    term_height__974_v0 
    local term_height_13313="${ret_term_height974_v0}"
    local max_page_size_13314
    max_page_size_13314="$(( term_height_13313 - $(if [ "${_has_header_43}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_34="${page_size_13301}"
    if [ "$(( _page_size_34 > max_page_size_13314 ))" != 0 ]; then
        _page_size_34="${max_page_size_13314}"
    fi
    if [ "${_has_header_43}" != 0 ]; then
        cutoff_text__1027_v0 "${header_13302}" "${_term_width_42}"
        local ret_cutoff_text1027_v0__157_17="${ret_cutoff_text1027_v0}"
        local array_170=("")
        eprintf__1007_v0 "${ret_cutoff_text1027_v0__157_17}""
" array_170[@]
    fi
    math_floor__502_v0 "$(( $(( $(( total_13300 + _page_size_34 )) - 1 )) / _page_size_34 ))"
    _total_pages_36="${ret_math_floor502_v0}"
    _display_count_35="${_page_size_34}"
    if [ "$(( total_13300 < _page_size_34 ))" != 0 ]; then
        _display_count_35="${total_13300}"
    fi
    if [ "${multi_13304}" != 0 ]; then
        _checked_46=()
        local __range_start_13349=0
        local __range_end_13349="${total_13300}"
        local __dir_13349=$(( ${__range_start_13349} <= ${__range_end_13349} ? 1 : -1 ))
        for (( ____13349=${__range_start_13349}; ____13349 * ${__dir_13349} < ${__range_end_13349} * ${__dir_13349}; ____13349+=${__dir_13349} )); do
            local array_172=(0)
            _checked_46+=("${array_172[@]}")
done
    fi
    new_line__1014_v0 "${_display_count_35}"
    local array_173=("")
    eprintf__1007_v0 "\\x1b[G" array_173[@]
    if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
        eprintf_colored__1008_v0 "Page $(( _current_page_37 + 1 ))/${_total_pages_36}" 90
    fi
    new_line__1014_v0 1
    render_tooltip_line__1176_v0 
    go_up__1015_v0 "$(( _display_count_35 + 1 ))"
    local array_174=("")
    eprintf__1007_v0 "\\x1b[G" array_174[@]
}

# chooser_page_start()
chooser_page_start__1178_v0() {
    ret_chooser_page_start1178_v0="$(( _current_page_37 * _page_size_34 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1179_v0() {
    chooser_page_start__1178_v0 
    local start_13371="${ret_chooser_page_start1178_v0}"
    local end_13372="$(( start_13371 + _page_size_34 ))"
    if [ "$(( end_13372 > _total_33 ))" != 0 ]; then
        end_13372="${_total_33}"
    fi
    ret_chooser_page_count1179_v0="$(( end_13372 - start_13371 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1180_v0() {
    local -n page_13375="${1}"
    _page_44=("${page_13375[@]}")
    local __length_175=("${page_13375[@]}")
    _page_count_45="${#__length_175[@]}"
    if [ "${_first_render_48}" != 0 ]; then
        _first_render_48=0
        render_page__1174_v0 
    else
        if [ "${_up_paged_49}" != 0 ]; then
            _selected_38="$(( _page_count_45 - 1 ))"
            _up_paged_49=0
        fi
        go_up__1015_v0 1
        remove_line__1011_v0 "$(( _display_count_35 - 1 ))"
        remove_current_line__1012_v0 
        local array_176=("")
        eprintf__1007_v0 "\\x1b[G" array_176[@]
        render_page__1174_v0 
        render_page_indicator__1175_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1181_v0() {
    local prev_selected_13407="${1}"
    chooser_page_start__1178_v0 
    local page_start_13408="${ret_chooser_page_start1178_v0}"
    local check_width_13409
    check_width_13409="$(if [ "${_multi_40}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_177="${_cursor_39}"
    local max_option_width_13410="$(( $(( _term_width_42 - ${#__length_177} )) - check_width_13409 ))"
    go_up__1015_v0 "$(( _display_count_35 - prev_selected_13407 ))"
    local array_178=("")
    eprintf__1007_v0 "\\x1b[K" array_178[@]
    local __length_179="${_cursor_39}"
    print_blank__1013_v0 "${#__length_179}"
    if [ "${_multi_40}" != 0 ]; then
        local was_checked_13411="${_checked_46[$(( page_start_13408 + prev_selected_13407 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1027_v0 "${_page_44[${prev_selected_13407}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_13410}"
        local ret_cutoff_text1027_v0__232_63="${ret_cutoff_text1027_v0}"
        local prev_line_13412
        prev_line_13412="$(if [ "${was_checked_13411}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1027_v0__232_63}"
        if [ "${was_checked_13411}" != 0 ]; then
            colored_secondary__990_v0 "${prev_line_13412}"
            local ret_colored_secondary990_v0__234_21="${ret_colored_secondary990_v0}"
            local array_180=("")
            eprintf__1007_v0 "${ret_colored_secondary990_v0__234_21}" array_180[@]
        else
            local array_181=("")
            eprintf__1007_v0 "${prev_line_13412}" array_181[@]
        fi
    else
        cutoff_text__1027_v0 "${_page_44[${prev_selected_13407}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_13410}"
        local ret_cutoff_text1027_v0__239_17="${ret_cutoff_text1027_v0}"
        local array_182=("")
        eprintf__1007_v0 "${ret_cutoff_text1027_v0__239_17}" array_182[@]
    fi
    go_up_or_down__1017_v0 "$(( _selected_38 - prev_selected_13407 ))"
    local array_183=("")
    eprintf__1007_v0 "\\x1b[G" array_183[@]
    local array_184=("")
    eprintf__1007_v0 "\\x1b[K" array_184[@]
    local mark_13414
    mark_13414="$(if [ "${_multi_40}" != 0 ]; then echo "$(if [ "${_checked_46[$(( page_start_13408 + _selected_38 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1027_v0 "${_page_44[${_selected_38}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_13410}"
    local ret_cutoff_text1027_v0__246_48="${ret_cutoff_text1027_v0}"
    colored_secondary__990_v0 "${_cursor_39}""${mark_13414}""${ret_cutoff_text1027_v0__246_48}"
    local ret_colored_secondary990_v0__246_13="${ret_colored_secondary990_v0}"
    local array_185=("")
    eprintf__1007_v0 "${ret_colored_secondary990_v0__246_13}" array_185[@]
    go_down__1016_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_186=("")
    eprintf__1007_v0 "\\x1b[G" array_186[@]
}

# redraw_current_line()
redraw_current_line__1182_v0() {
    chooser_page_start__1178_v0 
    local page_start_13401="${ret_chooser_page_start1178_v0}"
    local __length_187="${_cursor_39}"
    local max_option_width_13402="$(( $(( _term_width_42 - ${#__length_187} )) - 3 ))"
    go_up__1015_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_188=("")
    eprintf__1007_v0 "\\x1b[G" array_188[@]
    local array_189=("")
    eprintf__1007_v0 "\\x1b[K" array_189[@]
    local check_mark_13403
    check_mark_13403="$(if [ "${_checked_46[$(( page_start_13401 + _selected_38 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1027_v0 "${_page_44[${_selected_38}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_13402}"
    local ret_cutoff_text1027_v0__260_54="${ret_cutoff_text1027_v0}"
    colored_secondary__990_v0 "${_cursor_39}""${check_mark_13403}""${ret_cutoff_text1027_v0__260_54}"
    local ret_colored_secondary990_v0__260_13="${ret_colored_secondary990_v0}"
    local array_190=("")
    eprintf__1007_v0 "${ret_colored_secondary990_v0__260_13}" array_190[@]
    go_down__1016_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_191=("")
    eprintf__1007_v0 "\\x1b[G" array_191[@]
}

# chooser_step()
chooser_step__1183_v0() {
    get_key__1005_v0 
    local key_13396="${ret_get_key1005_v0}"
    local prev_selected_13397="${_selected_38}"
    local prev_page_13398="${_current_page_37}"
    chooser_page_start__1178_v0 
    local page_start_13399="${ret_chooser_page_start1178_v0}"
    _up_paged_49=0
    if [ "$(( $([ "_${key_13396}" != "_UP" ]; echo $?) || $([ "_${key_13396}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_13396}" != "_DOWN" ]; echo $?) || $([ "_${key_13396}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_13396}" != "_LEFT" ]; echo $?) || $([ "_${key_13396}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_37 > 0 ))" != 0 ]; then
            _current_page_37="$(( _current_page_37 - 1 ))"
        fi
        _selected_38=0
    elif [ "$(( $([ "_${key_13396}" != "_RIGHT" ]; echo $?) || $([ "_${key_13396}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_37 < $(( _total_pages_36 - 1 )) ))" != 0 ]; then
            _current_page_37="$(( _current_page_37 + 1 ))"
            _selected_38=0
        else
            _selected_38="$(( _page_count_45 - 1 ))"
        fi
    elif [ "$(( _multi_40 && $(( $([ "_${key_13396}" != "_x" ]; echo $?) || $([ "_${key_13396}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_13400="$(( page_start_13399 + _selected_38 ))"
        if [ "${_checked_46[${global_selected_13400}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_46["${global_selected_13400}"]=0
            _checked_count_47="$(( _checked_count_47 - 1 ))"
        elif [ "$(( $(( _limit_41 < 0 )) || $(( _checked_count_47 < _limit_41 )) ))" != 0 ]; then
            _checked_46["${global_selected_13400}"]=1
            _checked_count_47="$(( _checked_count_47 + 1 ))"
        else
            ret_chooser_step1183_v0="${__CHOOSER_CONTINUE_30}"
            return 0
        fi
        redraw_current_line__1182_v0 
        ret_chooser_step1183_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    elif [ "$(( $(( _multi_40 && $(( $([ "_${key_13396}" != "_a" ]; echo $?) || $([ "_${key_13396}" != "_A" ]; echo $?) )) )) && $(( _limit_41 < 0 )) ))" != 0 ]; then
        local all_checked_13405="$(( _checked_count_47 == _total_33 ))"
        local __range_start_13406=0
        local __range_end_13406="${_total_33}"
        local __dir_13406=$(( ${__range_start_13406} <= ${__range_end_13406} ? 1 : -1 ))
        for (( i_13406=${__range_start_13406}; i_13406 * ${__dir_13406} < ${__range_end_13406} * ${__dir_13406}; i_13406+=${__dir_13406} )); do
            _checked_46["${i_13406}"]="$(( ! all_checked_13405 ))"
done
        _checked_count_47="$(if [ "${all_checked_13405}" != 0 ]; then echo 0; else echo "${_total_33}"; fi)"
        go_up__1015_v0 "${_display_count_35}"
        local array_192=("")
        eprintf__1007_v0 "\\x1b[G" array_192[@]
        render_page__1174_v0 
        ret_chooser_step1183_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    elif [ "$([ "_${key_13396}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1183_v0="${__CHOOSER_DONE_32}"
        return 0
    else
        ret_chooser_step1183_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    fi
    if [ "$(( prev_page_13398 != _current_page_37 ))" != 0 ]; then
        ret_chooser_step1183_v0="${__CHOOSER_NEED_PAGE_31}"
        return 0
    fi
    if [ "$(( prev_selected_13397 != _selected_38 ))" != 0 ]; then
        redraw_selection__1181_v0 "${prev_selected_13397}"
    fi
    ret_chooser_step1183_v0="${__CHOOSER_CONTINUE_30}"
    return 0
}

# chooser_selected()
chooser_selected__1184_v0() {
    chooser_page_start__1178_v0 
    local ret_chooser_page_start1178_v0__362_12="${ret_chooser_page_start1178_v0}"
    ret_chooser_selected1184_v0="$(( ret_chooser_page_start1178_v0__362_12 + _selected_38 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1185_v0() {
    local index_13420="${1}"
    ret_chooser_is_checked1185_v0="${_checked_46[${index_13420}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1186_v0() {
    local total_lines_13416="$(( _display_count_35 + 2 ))"
    if [ "${_has_header_43}" != 0 ]; then
        total_lines_13416="$(( total_lines_13416 + 1 ))"
    fi
    go_down__1016_v0 1
    remove_line__1011_v0 "$(( total_lines_13416 - 1 ))"
    remove_current_line__1012_v0 
    stty_unlock__967_v0 
    show_cursor__1019_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1195_v0() {
    local -n options_13424="${1}"
    local cursor_13425="${2}"
    local header_13426="${3}"
    local page_size_13427="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_193=("${options_13424[@]}")
    local total_13428="${#__length_193[@]}"
    if [ "$(( total_13428 == 0 ))" != 0 ]; then
        eprintf_colored__1008_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1177_v0 "${total_13428}" "${page_size_13427}" "${header_13426}" "${cursor_13425}" 0 -1
    local need_page_13429=1
    while :
    do
        if [ "${need_page_13429}" != 0 ]; then
            local page_13430=()
            chooser_page_start__1178_v0 
            local start_13431="${ret_chooser_page_start1178_v0}"
            chooser_page_count__1179_v0 
            local count_13432="${ret_chooser_page_count1179_v0}"
            local __range_start_13433="${start_13431}"
            local __range_end_13433="$(( start_13431 + count_13432 ))"
            local __dir_13433=$(( ${__range_start_13433} <= ${__range_end_13433} ? 1 : -1 ))
            for (( i_13433=${__range_start_13433}; i_13433 * ${__dir_13433} < ${__range_end_13433} * ${__dir_13433}; i_13433+=${__dir_13433} )); do
                local array_195=("${options_13424[${i_13433}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_13430+=("${array_195[@]}")
done
            chooser_set_page__1180_v0 "page_13430"
        fi
        chooser_step__1183_v0 
        local step_13434="${ret_chooser_step1183_v0}"
        if [ "$(( step_13434 == __CHOOSER_DONE_32 ))" != 0 ]; then
            break
        fi
        need_page_13429="$(( step_13434 == __CHOOSER_NEED_PAGE_31 ))"
    done
    chooser_selected__1184_v0 
    local selected_13435="${ret_chooser_selected1184_v0}"
    chooser_end__1186_v0 
    ret_xyl_choose1195_v0="${options_13424[${selected_13435}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1196_v0() {
    local -n options_13294="${1}"
    local cursor_13295="${2}"
    local header_13296="${3}"
    local limit_13297="${4}"
    local page_size_13298="${5}"
    local __length_196=("${options_13294[@]}")
    local total_13299="${#__length_196[@]}"
    if [ "$(( total_13299 == 0 ))" != 0 ]; then
        eprintf_colored__1008_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1196_v0=()
        return 0
    fi
    chooser_begin__1177_v0 "${total_13299}" "${page_size_13298}" "${header_13296}" "${cursor_13295}" 1 "${limit_13297}"
    local need_page_13368=1
    while :
    do
        if [ "${need_page_13368}" != 0 ]; then
            local page_13369=()
            chooser_page_start__1178_v0 
            local start_13370="${ret_chooser_page_start1178_v0}"
            chooser_page_count__1179_v0 
            local count_13373="${ret_chooser_page_count1179_v0}"
            local __range_start_13374="${start_13370}"
            local __range_end_13374="$(( start_13370 + count_13373 ))"
            local __dir_13374=$(( ${__range_start_13374} <= ${__range_end_13374} ? 1 : -1 ))
            for (( i_13374=${__range_start_13374}; i_13374 * ${__dir_13374} < ${__range_end_13374} * ${__dir_13374}; i_13374+=${__dir_13374} )); do
                local array_199=("${options_13294[${i_13374}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_13369+=("${array_199[@]}")
done
            chooser_set_page__1180_v0 "page_13369"
        fi
        chooser_step__1183_v0 
        local step_13415="${ret_chooser_step1183_v0}"
        if [ "$(( step_13415 == __CHOOSER_DONE_32 ))" != 0 ]; then
            break
        fi
        need_page_13368="$(( step_13415 == __CHOOSER_NEED_PAGE_31 ))"
    done
    chooser_end__1186_v0 
    local result_13418=()
    local __range_start_13419=0
    local __range_end_13419="${total_13299}"
    local __dir_13419=$(( ${__range_start_13419} <= ${__range_end_13419} ? 1 : -1 ))
    for (( i_13419=${__range_start_13419}; i_13419 * ${__dir_13419} < ${__range_end_13419} * ${__dir_13419}; i_13419+=${__dir_13419} )); do
        chooser_is_checked__1185_v0 "${i_13419}"
        local ret_chooser_is_checked1185_v0__93_12="${ret_chooser_is_checked1185_v0}"
        if [ "${ret_chooser_is_checked1185_v0__93_12}" != 0 ]; then
            local array_201=("${options_13294[${i_13419}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_13418+=("${array_201[@]}")
        fi
done
    ret_xyl_multi_choose1196_v0=("${result_13418[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1289_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    printf '%s\n' ""
    colored_primary__989_v0 "choose"
    local ret_colored_primary989_v0__7_12="${ret_colored_primary989_v0}"
    local array_202=()
    printf__128_v1 "${ret_colored_primary989_v0__7_12}" array_202[@]
    local array_203=()
    printf__128_v1 " - Choose from a list of options." array_203[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__990_v0 "Arguments: "
    local ret_colored_secondary990_v0__11_12="${ret_colored_secondary990_v0}"
    local array_204=()
    printf__128_v1 "${ret_colored_secondary990_v0__11_12}""
" array_204[@]
    echo "  [<options> ...]        List of options to choose from"
    printf '%s\n' ""
    colored_secondary__990_v0 "Flags: "
    local ret_colored_secondary990_v0__14_12="${ret_colored_secondary990_v0}"
    local array_205=()
    printf__128_v1 "${ret_colored_secondary990_v0__14_12}""
" array_205[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1339_v0() {
    local options_13276=()
    local command_207
    command_207="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_13277="${command_207}"
    if [ "$([ "_${is_tty_13277}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_13276+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1339_v0=("${options_13276[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1340_v0() {
    local parameters_13259=("${!1}")
    local cursor_13260="> "
    colored_primary__989_v0 "Choose: "
    local ret_colored_primary989_v0__17_30="${ret_colored_primary989_v0}"
    local header_13275="\\x1b[1m""${ret_colored_primary989_v0__17_30}"
    read_stdin_options__1339_v0 
    local options_13278=("${ret_read_stdin_options1339_v0[@]}")
    local multi_13279=0
    local limit_13280=-1
    local page_size_13281=10
    local __length_211=("${parameters_13259[@]}")
    local slice_upper_210="${#__length_211[@]}"
    local slice_offset_212=2
    local slice_offset_212=$((${slice_offset_212} > 0 ? ${slice_offset_212} : 0))
    local slice_length_213="$(( slice_upper_210 - slice_offset_212 ))"
    local slice_length_213=$((${slice_length_213} > 0 ? ${slice_length_213} : 0))
    for param_13282 in "${parameters_13259[@]:${slice_offset_212}:${slice_length_213}}"; do
        starts_with__22_v0 "${param_13282}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_13282}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_13282}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_13282}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_13282}" != "_-h" ]; echo $?) || $([ "_${param_13282}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1289_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_214="--cursor="
            slice__24_v0 "${param_13282}" "${#__length_214}" 0
            cursor_13260="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_215="--header="
            slice__24_v0 "${param_13282}" "${#__length_215}" 0
            header_13275="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_216="--limit="
            slice__24_v0 "${param_13282}" "${#__length_216}" 0
            local value_13284="${ret_slice24_v0}"
            parse_int__13_v0 "${value_13284}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1008_v0 "ERROR: Invalid limit value: ""${value_13284}""
" 31
                exit 1
            fi
            limit_13280="${ret_parse_int13_v0}"
            multi_13279=1
        elif [ "$([ "_${param_13282}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_13279=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_217="--page-size="
            slice__24_v0 "${param_13282}" "${#__length_217}" 0
            local value_13289="${ret_slice24_v0}"
            parse_int__13_v0 "${value_13289}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1008_v0 "ERROR: Invalid page-size value: ""${value_13289}""
" 31
                exit 1
            fi
            page_size_13281="${ret_parse_int13_v0}"
        else
            options_13278+=("${param_13282}")
        fi
    done
    has_ansi_escape__1020_v0 "${header_13275}"
    local ret_has_ansi_escape1020_v0__59_44="${ret_has_ansi_escape1020_v0}"
    escape_ansi__1021_v0 "${header_13275}"
    local ret_escape_ansi1021_v0__59_73="${ret_escape_ansi1021_v0}"
    colored_primary__989_v0 "${header_13275}"
    local ret_colored_primary989_v0__59_111="${ret_colored_primary989_v0}"
    local display_header_13293
    display_header_13293="$(if [ "$(( $([ "_${header_13275}" != "_" ]; echo $?) || ret_has_ansi_escape1020_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1021_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary989_v0__59_111}"; fi)"
    if [ "${multi_13279}" != 0 ]; then
        xyl_multi_choose__1196_v0 "options_13278" "${cursor_13260}" "${display_header_13293}" "${limit_13280}" "${page_size_13281}"
        local results_13421=("${ret_xyl_multi_choose1196_v0[@]}")
        join__7_v0 results_13421[@] "
"
        ret_execute_choose1340_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1195_v0 "options_13278" "${cursor_13260}" "${display_header_13293}" "${page_size_13281}"
    ret_execute_choose1340_v0="${ret_xyl_choose1195_v0}"
    return 0
}

# Perl Extensions Utilities
command_219="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_53="$([ "_${command_219}" != "_No" ]; echo $?)"
command_220="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_54="$(( $(( ! _perl_disabled_53 )) && $([ "_${command_220}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1515_v0() {
    local text_15010="${1}"
    if [ "$(( ! _perl_available_54 ))" != 0 ]; then
        ret_perl_get_cjk_width1515_v0=''
        return 1
    fi
    local command_221
    command_221="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_15010}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1515_v0=''
        return "${__status}"
    fi
    local width_str_15011="${command_221}"
    parse_int__13_v0 "${width_str_15011}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1515_v0=''
        return "${__status}"
    fi
    local width_15012="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1515_v0="${width_15012}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1516_v0() {
    local text_15019="${1}"
    local max_width_15020="${2}"
    if [ "$(( ! _perl_available_54 ))" != 0 ]; then
        ret_perl_truncate_cjk1516_v0=''
        return 1
    fi
    local command_222
    command_222="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_15019}" ${max_width_15020} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1516_v0=''
        return "${__status}"
    fi
    local result_15021="${command_222}"
    ret_perl_truncate_cjk1516_v0="${result_15021}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_55=0
_term_size_56=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1523_v0() {
    local command_224
    command_224="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_14995="${command_224}"
    parse_int__13_v0 "${count_14995}"
    __status=$?
    ret_stty_count1523_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1524_v0() {
    stty_count__1523_v0 
    local count_num_14996="${ret_stty_count1523_v0}"
    if [ "$(( count_num_14996 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_14996="$(( count_num_14996 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14996}
    __status=$?
}

# stty_unlock()
stty_unlock__1525_v0() {
    stty_count__1523_v0 
    local count_num_15092="${ret_stty_count1523_v0}"
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
store_term_size__1526_v0() {
    local size_14998="${1}"
    if [ "$([ "_${size_14998}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1526_v0=0
        return 0
    fi
    split__4_v0 "${size_14998}" " "
    local parts_14999=("${ret_split4_v0[@]}")
    local __length_225=("${parts_14999[@]}")
    if [ "$(( ${#__length_225[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1526_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_14999[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_14999[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_56=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1526_v0=1
    return 0
}

# query_term_size()
query_term_size__1527_v0() {
    local command_227
    command_227="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_15001="${command_227}"
    store_term_size__1526_v0 "${size_15001}"
    ret_query_term_size1527_v0="${ret_store_term_size1526_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1528_v0() {
    local command_228
    command_228="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_14997="${command_228}"
    store_term_size__1526_v0 "${size_14997}"
    ret_stty_term_size1528_v0="${ret_store_term_size1526_v0}"
    return 0
}

# get_term_size()
get_term_size__1529_v0() {
    stty_term_size__1528_v0 
    local detected_15000="${ret_stty_term_size1528_v0}"
    if [ "$(( ! detected_15000 ))" != 0 ]; then
        query_term_size__1527_v0 
        detected_15000="${ret_query_term_size1527_v0}"
    fi
    _got_term_size_55=1
}

# term_width()
term_width__1531_v0() {
    if [ "$(( ! _got_term_size_55 ))" != 0 ]; then
        get_term_size__1529_v0 
    fi
    ret_term_width1531_v0="${_term_size_56[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:93:23)"}"
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
get_supports_truecolor__1542_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_14978="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_14978}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_57="No"
        ret_get_supports_truecolor1542_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_57="No"
        ret_get_supports_truecolor1542_v0=0
        return 0
    fi
    local colorterm_14979="${ret_env_var_get120_v0}"
    _supports_truecolor_57="$(if [ "$(( $([ "_${colorterm_14979}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_14979}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1542_v0="$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1543_v0() {
    local message_14973="${1}"
    local r_14974="${2}"
    local g_14975="${3}"
    local b_14976="${4}"
    local fallback_14977="${5}"
    if [ "$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1543_v0="\\x1b[38;2;${r_14974};${g_14975};${b_14976}m""${message_14973}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_57}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1542_v0 
        local ret_get_supports_truecolor1542_v0__50_17="${ret_get_supports_truecolor1542_v0}"
        if [ "${ret_get_supports_truecolor1542_v0__50_17}" != 0 ]; then
            ret_colored_rgb1543_v0="\\x1b[38;2;${r_14974};${g_14975};${b_14976}m""${message_14973}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_14977 == 0 ))" != 0 ]; then
            ret_colored_rgb1543_v0="${message_14973}"
            return 0
        else
            ret_colored_rgb1543_v0="\\x1b[${fallback_14977}m""${message_14973}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_14977 == 0 ))" != 0 ]; then
            ret_colored_rgb1543_v0="${message_14973}"
            return 0
        fi
        ret_colored_rgb1543_v0="\\x1b[${fallback_14977}m""${message_14973}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1544_v0() {
    local message_15063="${1}"
    local r_15064="${2}"
    local g_15065="${3}"
    local b_15066="${4}"
    local fallback_15067="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_15068="${fallback_15067}"
    if [ "$(( $(( fallback_15067 >= 30 )) && $(( fallback_15067 <= 37 )) ))" != 0 ]; then
        bg_fallback_15068="$(( fallback_15067 + 10 ))"
    fi
    if [ "$(( $(( fallback_15067 >= 90 )) && $(( fallback_15067 <= 97 )) ))" != 0 ]; then
        bg_fallback_15068="$(( fallback_15067 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1544_v0="\\x1b[48;2;${r_15064};${g_15065};${b_15066}m""${message_15063}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_57}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1542_v0 
        local ret_get_supports_truecolor1542_v0__92_17="${ret_get_supports_truecolor1542_v0}"
        if [ "${ret_get_supports_truecolor1542_v0__92_17}" != 0 ]; then
            ret_background_rgb1544_v0="\\x1b[48;2;${r_15064};${g_15065};${b_15066}m""${message_15063}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_15068 == 0 ))" != 0 ]; then
            ret_background_rgb1544_v0="${message_15063}"
            return 0
        else
            ret_background_rgb1544_v0="\\x1b[${bg_fallback_15068}m""${message_15063}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_15068 == 0 ))" != 0 ]; then
            ret_background_rgb1544_v0="${message_15063}"
            return 0
        fi
        ret_background_rgb1544_v0="\\x1b[${bg_fallback_15068}m""${message_15063}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1545_v0() {
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_14967="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_14967}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_14967}" ";"
            local parts_14968=("${ret_split4_v0[@]}")
            local __length_232=("${parts_14968[@]}")
            if [ "$(( ${#__length_232[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14968[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14968[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14968[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14968[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_59=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_14969="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_14969}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_14969}" ";"
            local parts_14970=("${ret_split4_v0[@]}")
            local __length_234=("${parts_14970[@]}")
            if [ "$(( ${#__length_234[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14970[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14970[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14970[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14970[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_60=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_14971="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_14971}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_14971}" ";"
            local parts_14972=("${ret_split4_v0[@]}")
            local __length_236=("${parts_14972[@]}")
            if [ "$(( ${#__length_236[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14972[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14972[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14972[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14972[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1545_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_58=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1546_v0() {
    inner_get_xylitol_colors__1545_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_58=1
}

# colored_primary(message: Text)
colored_primary__1547_v0() {
    local message_14966="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1546_v0 
    fi
    colored_rgb__1543_v0 "${message_14966}" "${_primary_color_59[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_59[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_59[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_59[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1547_v0="${ret_colored_rgb1543_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1548_v0() {
    local message_14983="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1546_v0 
    fi
    colored_rgb__1543_v0 "${message_14983}" "${_secondary_color_60[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_60[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_60[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_60[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1548_v0="${ret_colored_rgb1543_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1551_v0() {
    local message_15062="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1546_v0 
    fi
    background_rgb__1544_v0 "${message_15062}" "${_secondary_color_60[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_60[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_60[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_60[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1551_v0="${ret_background_rgb1544_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1563_v0() {
    local command_238
    command_238="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_15085="${command_238}"
    if [ "$([ "_${var_15085}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1563_v0="UP"
        return 0
    elif [ "$([ "_${var_15085}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1563_v0="DOWN"
        return 0
    elif [ "$([ "_${var_15085}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1563_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_15085}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1563_v0="LEFT"
        return 0
    elif [ "$([ "_${var_15085}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1563_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_15085}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1563_v0="INPUT"
        return 0
    else
        ret_get_key1563_v0="${var_15085}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1565_v0() {
    local format_14987="${1}"
    local args_14988=("${!2}")
    args_14988=("${format_14987}" "${args_14988[@]}")
    __status=$?
    printf "${args_14988[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1566_v0() {
    local message_14985="${1}"
    local color_14986="${2}"
    # Prints an error message with a specified color.
    local array_239=("${message_14985}")
    eprintf__1565_v0 "\\x1b[${color_14986}m%s\\x1b[0m" array_239[@]
}

# colored(message: Text, color: Int)
colored__1567_v0() {
    local message_15075="${1}"
    local color_15076="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1567_v0="\\x1b[${color_15076}m""${message_15075}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1569_v0() {
    local cnt_15089="${1}"
    if [ "$(( cnt_15089 > 0 ))" != 0 ]; then
        local sequence_15090=""
        local __range_start_15091=0
        local __range_end_15091="${cnt_15089}"
        local __dir_15091=$(( ${__range_start_15091} <= ${__range_end_15091} ? 1 : -1 ))
        for (( ____15091=${__range_start_15091}; ____15091 * ${__dir_15091} < ${__range_end_15091} * ${__dir_15091}; ____15091+=${__dir_15091} )); do
            sequence_15090+="\\x1b[2K\\x1b[1A"
done
        local array_240=("")
        eprintf__1565_v0 "${sequence_15090}" array_240[@]
    fi
    local array_241=("")
    eprintf__1565_v0 "\\x1b[G" array_241[@]
}

# remove_current_line()
remove_current_line__1570_v0() {
    local array_242=("")
    eprintf__1565_v0 "\\x1b[2K\\x1b[G" array_242[@]
}

# go_up(cnt: Int)
go_up__1573_v0() {
    local cnt_15084="${1}"
    local array_243=("")
    eprintf__1565_v0 "\\x1b[${cnt_15084}A" array_243[@]
}

# go_down(cnt: Int)
go_down__1574_v0() {
    local cnt_15088="${1}"
    local array_244=("")
    eprintf__1565_v0 "\\x1b[${cnt_15088}B" array_244[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1576_v0() {
    local array_245=("")
    eprintf__1565_v0 "\\x1b[?25l" array_245[@]
}

# show_cursor()
show_cursor__1577_v0() {
    local array_246=("")
    eprintf__1565_v0 "\\x1b[?25h" array_246[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1578_v0() {
    local text_14989="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_247
    command_247="$([[ "${text_14989}" == *$'\x1b'* || "${text_14989}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_14990="${command_247}"
    ret_has_ansi_escape1578_v0="$([ "_${has_escape_14990}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1579_v0() {
    local text_14991="${1}"
    local command_248
    command_248="$(printf '%s' "${text_14991}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1579_v0="${command_248}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1580_v0() {
    local text_15006="${1}"
    local command_249
    command_249="$(printf "%s" "${text_15006}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1580_v0="${command_249}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1581_v0() {
    local text_15008="${1}"
    local command_250
    command_250="$(printf "%s" "${text_15008}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_15009="${command_250}"
    ret_is_all_ascii1581_v0="$([ "_${result_15009}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1582_v0() {
    local text_15005="${1}"
    strip_ansi__1580_v0 "${text_15005}"
    local stripped_15007="${ret_strip_ansi1580_v0}"
    # Check if text is all ASCII
    is_all_ascii__1581_v0 "${stripped_15007}"
    local ret_is_all_ascii1581_v0__150_12="${ret_is_all_ascii1581_v0}"
    if [ "$(( ! ret_is_all_ascii1581_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1515_v0 "${stripped_15007}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_251="${stripped_15007}"
            ret_get_visible_len1582_v0="${#__length_251}"
            return 0
        fi
        ret_get_visible_len1582_v0="${ret_perl_get_cjk_width1515_v0}"
        return 0
    else
        local __length_252="${stripped_15007}"
        ret_get_visible_len1582_v0="${#__length_252}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1583_v0() {
    local text_15016="${1}"
    local max_width_15017="${2}"
    get_visible_len__1582_v0 "${text_15016}"
    local visible_len_15018="${ret_get_visible_len1582_v0}"
    if [ "$(( visible_len_15018 <= max_width_15017 ))" != 0 ]; then
        ret_truncate_text1583_v0="${text_15016}"
        return 0
    fi
    is_all_ascii__1581_v0 "${text_15016}"
    local ret_is_all_ascii1581_v0__167_12="${ret_is_all_ascii1581_v0}"
    if [ "$(( ! ret_is_all_ascii1581_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1516_v0 "${text_15016}" "${max_width_15017}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_15016}" | cut -c1-${max_width_15017}
            __status=$?
        fi
        ret_truncate_text1583_v0="${ret_perl_truncate_cjk1516_v0}"
        return 0
    fi
    local command_253
    command_253="$(printf "%s" "${text_15016}" | cut -c1-${max_width_15017})"
    __status=$?
    ret_truncate_text1583_v0="${command_253}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1584_v0() {
    local text_15014="${1}"
    local max_width_15015="${2}"
    has_ansi_escape__1578_v0 "${text_15014}"
    local ret_has_ansi_escape1578_v0__179_12="${ret_has_ansi_escape1578_v0}"
    if [ "$(( ! ret_has_ansi_escape1578_v0__179_12 ))" != 0 ]; then
        truncate_text__1583_v0 "${text_15014}" "${max_width_15015}"
        ret_truncate_ansi1584_v0="${ret_truncate_text1583_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_254
    command_254="$([[ "${text_15014}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_15022="${command_254}"
    # Replace \x1b[ with newline, then split
    local command_255
    command_255="$(t="${text_15014}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_15023="${command_255}"
    split__4_v0 "${replaced_15023}" "
"
    local parts_15024=("${ret_split4_v0[@]}")
    local result_15025=""
    local remaining_width_15026="${max_width_15015}"
    local __range_start_15027=0
    local __length_256=("${parts_15024[@]}")
    local __range_end_15027="${#__length_256[@]}"
    local __dir_15027=$(( ${__range_start_15027} <= ${__range_end_15027} ? 1 : -1 ))
    for (( idx_15027=${__range_start_15027}; idx_15027 * ${__dir_15027} < ${__range_end_15027} * ${__dir_15027}; idx_15027+=${__dir_15027} )); do
        local part_15028="${parts_15024[${idx_15027}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_15027 == 0 )) && $([ "_${starts_with_ansi_15022}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_15028}" == "_" ]; echo $?) && $(( remaining_width_15026 > 0 )) ))" != 0 ]; then
                truncate_text__1583_v0 "${part_15028}" "${remaining_width_15026}"
                local ret_truncate_text1583_v0__201_35="${ret_truncate_text1583_v0}"
                local truncated_15029="${ret_truncate_text1583_v0__201_35}"
                result_15025+="${truncated_15029}"
                get_visible_len__1582_v0 "${truncated_15029}"
                local ret_get_visible_len1582_v0__203_36="${ret_get_visible_len1582_v0}"
                remaining_width_15026="$(( remaining_width_15026 - ret_get_visible_len1582_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_257
            command_257="$(__p="${part_15028}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_15030="${command_257}"
            if [ "$([ "_${m_idx_15030}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_258
                command_258="$(__p="${part_15028}"; printf "%s" "${__p:0:${m_idx_15030}}")"
                __status=$?
                local ansi_params_15031="${command_258}"
                result_15025+="\\x1b[""${ansi_params_15031}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_15030}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_15032="${ret_parse_int13_v0__214_41}"
                local text_start_15033="$(( m_idx_num_15032 + 1 ))"
                local command_259
                command_259="$(__p="${part_15028}"; printf "%s" "${__p:${text_start_15033}}")"
                __status=$?
                local text_part_15034="${command_259}"
                if [ "$(( $([ "_${text_part_15034}" == "_" ]; echo $?) && $(( remaining_width_15026 > 0 )) ))" != 0 ]; then
                    truncate_text__1583_v0 "${text_part_15034}" "${remaining_width_15026}"
                    local ret_truncate_text1583_v0__218_39="${ret_truncate_text1583_v0}"
                    local truncated_15035="${ret_truncate_text1583_v0__218_39}"
                    result_15025+="${truncated_15035}"
                    get_visible_len__1582_v0 "${truncated_15035}"
                    local ret_get_visible_len1582_v0__220_40="${ret_get_visible_len1582_v0}"
                    remaining_width_15026="$(( remaining_width_15026 - ret_get_visible_len1582_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_15028}" == "_" ]; echo $?) && $(( remaining_width_15026 > 0 )) ))" != 0 ]; then
                    truncate_text__1583_v0 "${part_15028}" "${remaining_width_15026}"
                    local ret_truncate_text1583_v0__225_39="${ret_truncate_text1583_v0}"
                    local truncated_15036="${ret_truncate_text1583_v0__225_39}"
                    result_15025+="${truncated_15036}"
                    get_visible_len__1582_v0 "${truncated_15036}"
                    local ret_get_visible_len1582_v0__227_40="${ret_get_visible_len1582_v0}"
                    remaining_width_15026="$(( remaining_width_15026 - ret_get_visible_len1582_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1584_v0="${result_15025}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1585_v0() {
    local text_15003="${1}"
    local max_width_15004="${2}"
    get_visible_len__1582_v0 "${text_15003}"
    local visible_len_15013="${ret_get_visible_len1582_v0}"
    if [ "$(( visible_len_15013 <= max_width_15004 ))" != 0 ]; then
        ret_cutoff_text1585_v0="${text_15003}"
        return 0
    fi
    truncate_ansi__1584_v0 "${text_15003}" "$(( max_width_15004 - 3 ))"
    local ret_truncate_ansi1584_v0__243_12="${ret_truncate_ansi1584_v0}"
    ret_cutoff_text1585_v0="${ret_truncate_ansi1584_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1586_v0() {
    local items_15069=("${!1}")
    local total_len_15070="${2}"
    local term_width_15071="${3}"
    local separator_15072=" • "
    local separator_len_15073=3
    # Fast path: no truncation needed
    if [ "$(( total_len_15070 <= term_width_15071 ))" != 0 ]; then
        local iter_15074=0
        while :
        do
            local __length_260=("${items_15069[@]}")
            if [ "$(( iter_15074 >= ${#__length_260[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_15074 > 0 ))" != 0 ]; then
                eprintf_colored__1566_v0 "${separator_15072}" 90
            fi
            colored__1567_v0 "${items_15069[$(( iter_15074 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1567_v0__268_41="${ret_colored1567_v0}"
            local array_261=("")
            eprintf__1565_v0 "${items_15069[${iter_15074}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1567_v0__268_41}" array_261[@]
            iter_15074="$(( iter_15074 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_15077=0
        local first_15078=1
        local iter_15079=0
        while :
        do
            local __length_262=("${items_15069[@]}")
            if [ "$(( iter_15079 >= ${#__length_262[@]} ))" != 0 ]; then
                break
            fi
            local key_15080="${items_15069[${iter_15079}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_15081="${items_15069[$(( iter_15079 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_263="${key_15080}"
            local __length_264="${action_15081}"
            local part_len_15082="$(( $(( ${#__length_263} + 1 )) + ${#__length_264} ))"
            local needed_15083="${part_len_15082}"
            if [ "$(( ! first_15078 ))" != 0 ]; then
                needed_15083="$(( needed_15083 + separator_len_15073 ))"
            fi
            if [ "$(( $(( current_len_15077 + needed_15083 )) > term_width_15071 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_15078 ))" != 0 ]; then
                eprintf_colored__1566_v0 "${separator_15072}" 90
            fi
            colored__1567_v0 "${action_15081}" 2
            local ret_colored1567_v0__296_33="${ret_colored1567_v0}"
            local array_265=("")
            eprintf__1565_v0 "${key_15080}"" ""${ret_colored1567_v0__296_33}" array_265[@]
            current_len_15077="$(( current_len_15077 + needed_15083 ))"
            first_15078=0
            iter_15079="$(( iter_15079 + 2 ))"
        done
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1635_v0() {
    local selected_15038="${1}"
    local term_width_15039="${2}"
    local small_15040="$(( term_width_15039 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_15040}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_15059="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_15040}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_15060="${ret_cpad29_v0}"
    local gap_15061
    gap_15061="$(if [ "${small_15040}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_266=("")
    eprintf__1565_v0 " " array_266[@]
    if [ "${selected_15038}" != 0 ]; then
        # Yes selected
        background_secondary__1551_v0 "${yes_label_15059}"
        local ret_background_secondary1551_v0__16_30="${ret_background_secondary1551_v0}"
        local array_267=("")
        eprintf__1565_v0 "\\x1b[97m""${ret_background_secondary1551_v0__16_30}" array_267[@]
        local array_268=("")
        eprintf__1565_v0 "${gap_15061}" array_268[@]
        # No not selected (dim)
        local array_269=("")
        eprintf__1565_v0 "\\x1b[49;37m""${no_label_15060}""\\x1b[0m" array_269[@]
    else
        # No selected
        local array_270=("")
        eprintf__1565_v0 "\\x1b[49;37m""${yes_label_15059}""\\x1b[0m" array_270[@]
        local array_271=("")
        eprintf__1565_v0 "${gap_15061}" array_271[@]
        background_secondary__1551_v0 "${no_label_15060}"
        local ret_background_secondary1551_v0__24_30="${ret_background_secondary1551_v0}"
        local array_272=("")
        eprintf__1565_v0 "\\x1b[97m""${ret_background_secondary1551_v0__24_30}" array_272[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1636_v0() {
    local header_14993="${1}"
    local default_yes_14994="${2}"
    stty_lock__1524_v0 
    hide_cursor__1576_v0 
    term_width__1531_v0 
    local term_width_15002="${ret_term_width1531_v0}"
    if [ "$([ "_${header_14993}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1585_v0 "${header_14993}" "${term_width_15002}"
        local ret_cutoff_text1585_v0__46_17="${ret_cutoff_text1585_v0}"
        local array_273=("")
        eprintf__1565_v0 "${ret_cutoff_text1585_v0__46_17}""

" array_273[@]
    fi
    local selected_15037="${default_yes_14994}"
    # Render initial options
    render_confirm_options__1635_v0 "${selected_15037}" "${term_width_15002}"
    local array_274=("")
    eprintf__1565_v0 "

" array_274[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_275=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1586_v0 array_275[@] 40 "${term_width_15002}"
    go_up__1573_v0 2
    while :
    do
        get_key__1563_v0 
        local key_15086="${ret_get_key1563_v0}"
        if [ "$(( $(( $(( $([ "_${key_15086}" != "_LEFT" ]; echo $?) || $([ "_${key_15086}" != "_h" ]; echo $?) )) || $([ "_${key_15086}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_15086}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_15037}" != 0 ]; then
                selected_15037=0
                local array_276=("")
                eprintf__1565_v0 "\\x1b[G\\x1b[K" array_276[@]
                render_confirm_options__1635_v0 "${selected_15037}" "${term_width_15002}"
            elif [ "$(( ! selected_15037 ))" != 0 ]; then
                selected_15037=1
                local array_277=("")
                eprintf__1565_v0 "\\x1b[G\\x1b[K" array_277[@]
                render_confirm_options__1635_v0 "${selected_15037}" "${term_width_15002}"
            fi
        elif [ "$(( $([ "_${key_15086}" != "_y" ]; echo $?) || $([ "_${key_15086}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_15037=1
            break
        elif [ "$(( $([ "_${key_15086}" != "_n" ]; echo $?) || $([ "_${key_15086}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_15037=0
            break
        elif [ "$([ "_${key_15086}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_15087=4
    if [ "$([ "_${header_14993}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_15087="$(( total_lines_15087 + 1 ))"
    fi
    go_down__1574_v0 2
    remove_line__1569_v0 "$(( total_lines_15087 - 1 ))"
    remove_current_line__1570_v0 
    stty_unlock__1525_v0 
    show_cursor__1577_v0 
    ret_xyl_confirm1636_v0="${selected_15037}"
    return 0
}

# print_confirm_help()
print_confirm_help__1728_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    printf '%s\n' ""
    colored_primary__1547_v0 "confirm"
    local ret_colored_primary1547_v0__7_12="${ret_colored_primary1547_v0}"
    local array_278=()
    printf__128_v1 "${ret_colored_primary1547_v0__7_12}" array_278[@]
    local array_279=()
    printf__128_v1 " - Display a Yes/No confirmation dialog." array_279[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1548_v0 "Flags: "
    local ret_colored_secondary1548_v0__11_12="${ret_colored_secondary1548_v0}"
    local array_280=()
    printf__128_v1 "${ret_colored_secondary1548_v0__11_12}""
" array_280[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1778_v0() {
    local parameters_14965=("${!1}")
    colored_primary__1547_v0 "Are you sure?"
    local ret_colored_primary1547_v0__9_30="${ret_colored_primary1547_v0}"
    local header_14980="\\x1b[1m""${ret_colored_primary1547_v0__9_30}"
    local default_yes_14981=1
    for param_14982 in "${parameters_14965[@]}"; do
        starts_with__22_v0 "${param_14982}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14982}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_14982}" != "_-h" ]; echo $?) || $([ "_${param_14982}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1728_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_283="--header="
            slice__24_v0 "${param_14982}" "${#__length_283}" 0
            header_14980="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_284="--default="
            slice__24_v0 "${param_14982}" "${#__length_284}" 0
            local value_14984="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_14984}" != "_yes" ]; echo $?) || $([ "_${value_14984}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_14981=1
            elif [ "$(( $([ "_${value_14984}" != "_no" ]; echo $?) || $([ "_${value_14984}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_14981=0
            else
                eprintf_colored__1566_v0 "ERROR: Invalid default value: ""${value_14984}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1578_v0 "${header_14980}"
    local ret_has_ansi_escape1578_v0__35_44="${ret_has_ansi_escape1578_v0}"
    escape_ansi__1579_v0 "${header_14980}"
    local ret_escape_ansi1579_v0__35_73="${ret_escape_ansi1579_v0}"
    colored_primary__1547_v0 "${header_14980}"
    local ret_colored_primary1547_v0__35_111="${ret_colored_primary1547_v0}"
    local display_header_14992
    display_header_14992="$(if [ "$(( $([ "_${header_14980}" != "_" ]; echo $?) || ret_has_ansi_escape1578_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1579_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1547_v0__35_111}"; fi)"
    xyl_confirm__1636_v0 "${display_header_14992}" "${default_yes_14981}"
    local result_15093="${ret_xyl_confirm1636_v0}"
    ret_execute_confirm1778_v0="$(if [ "${result_15093}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# get_directory_entries(path: Text, names: [Text], types: [Text], targets: [Text])
get_directory_entries__1933_v0() {
    local path_23092="${1}"
    local -n names_23093="${2}"
    local -n types_23094="${3}"
    local -n targets_23095="${4}"
    local __ls_path_285="${path_23092}"
    __ls_path_285="${__ls_path_285//\\/\\\\}"
    (( 1 )) && __ls_all_285="-A" || __ls_all_285=""
    (( 0 )) && __ls_rec_285="-R" || __ls_rec_285=""
    local __ls_285=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_285 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_285} ${__ls_rec_285} ${__ls_path_285}
    __status=$?
    );
    names_23093+=("${__ls_285[@]}")
    local command_286
    command_286="$(LC_ALL=C ls -lA "${path_23092}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_23096="${command_286}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_287
    command_287="$(LC_ALL=C ls -lA "${path_23092}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_23097="${command_287}"
    split__4_v0 "${types_output_23096}" "
"
    types_23094+=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_23097}" "
"
    local ret_split4_v0__21_19=("${ret_split4_v0[@]}")
    for marked_23098 in "${ret_split4_v0__21_19[@]}"; do
        slice__24_v0 "${marked_23098}" 1 0
        local ret_slice24_v0__22_21="${ret_slice24_v0}"
        targets_23095+=("${ret_slice24_v0__22_21}")
    done
}

# get_cwd()
get_cwd__1934_v0() {
    local command_291
    command_291="$(pwd)"
    __status=$?
    ret_get_cwd1934_v0="${command_291}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1935_v0() {
    local path_23087="${1}"
    local command_292
    command_292="$(cd "${path_23087}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_23088="${command_292}"
    if [ "$([ "_${normalized_23088}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1935_v0="${path_23087}"
        return 0
    fi
    ret_normalize_path1935_v0="${normalized_23088}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1936_v0() {
    local base_23254="${1}"
    local child_23255="${2}"
    if [ "$([ "_${base_23254}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1936_v0="/""${child_23255}"
        return 0
    fi
    ret_path_join1936_v0="${base_23254}""/""${child_23255}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1937_v0() {
    local path_23252="${1}"
    local command_293
    command_293="$(dirname "${path_23252}")"
    __status=$?
    local parent_23253="${command_293}"
    ret_get_parent_dir1937_v0="${parent_23253}"
    return 0
}

# Perl Extensions Utilities
command_294="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_62="$([ "_${command_294}" != "_No" ]; echo $?)"
command_295="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_63="$(( $(( ! _perl_disabled_62 )) && $([ "_${command_295}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1953_v0() {
    local command_297
    command_297="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_23084="${command_297}"
    parse_int__13_v0 "${count_23084}"
    __status=$?
    ret_stty_count1953_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1954_v0() {
    stty_count__1953_v0 
    local count_num_23085="${ret_stty_count1953_v0}"
    if [ "$(( count_num_23085 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_23085="$(( count_num_23085 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23085}
    __status=$?
}

# stty_unlock()
stty_unlock__1955_v0() {
    stty_count__1953_v0 
    local count_num_23105="${ret_stty_count1953_v0}"
    if [ "$(( count_num_23105 > 0 ))" != 0 ]; then
        count_num_23105="$(( count_num_23105 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23105}
        __status=$?
        if [ "$(( count_num_23105 == 0 ))" != 0 ]; then
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
get_supports_truecolor__1972_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_23072="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_23072}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_66="No"
        ret_get_supports_truecolor1972_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_66="No"
        ret_get_supports_truecolor1972_v0=0
        return 0
    fi
    local colorterm_23073="${ret_env_var_get120_v0}"
    _supports_truecolor_66="$(if [ "$(( $([ "_${colorterm_23073}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_23073}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1972_v0="$([ "_${_supports_truecolor_66}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1973_v0() {
    local message_23067="${1}"
    local r_23068="${2}"
    local g_23069="${3}"
    local b_23070="${4}"
    local fallback_23071="${5}"
    if [ "$([ "_${_supports_truecolor_66}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1973_v0="\\x1b[38;2;${r_23068};${g_23069};${b_23070}m""${message_23067}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_66}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1972_v0 
        local ret_get_supports_truecolor1972_v0__50_17="${ret_get_supports_truecolor1972_v0}"
        if [ "${ret_get_supports_truecolor1972_v0__50_17}" != 0 ]; then
            ret_colored_rgb1973_v0="\\x1b[38;2;${r_23068};${g_23069};${b_23070}m""${message_23067}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_23071 == 0 ))" != 0 ]; then
            ret_colored_rgb1973_v0="${message_23067}"
            return 0
        else
            ret_colored_rgb1973_v0="\\x1b[${fallback_23071}m""${message_23067}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_23071 == 0 ))" != 0 ]; then
            ret_colored_rgb1973_v0="${message_23067}"
            return 0
        fi
        ret_colored_rgb1973_v0="\\x1b[${fallback_23071}m""${message_23067}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1975_v0() {
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_23061="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_23061}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_23061}" ";"
            local parts_23062=("${ret_split4_v0[@]}")
            local __length_301=("${parts_23062[@]}")
            if [ "$(( ${#__length_301[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23062[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23062[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23062[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23062[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_68=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_23063="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_23063}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_23063}" ";"
            local parts_23064=("${ret_split4_v0[@]}")
            local __length_303=("${parts_23064[@]}")
            if [ "$(( ${#__length_303[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23064[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23064[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23064[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23064[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_69=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_23065="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_23065}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_23065}" ";"
            local parts_23066=("${ret_split4_v0[@]}")
            local __length_305=("${parts_23066[@]}")
            if [ "$(( ${#__length_305[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23066[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23066[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23066[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23066[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1975_v0=''
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
get_xylitol_colors__1976_v0() {
    inner_get_xylitol_colors__1975_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_67=1
}

# colored_primary(message: Text)
colored_primary__1977_v0() {
    local message_23060="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__1976_v0 
    fi
    colored_rgb__1973_v0 "${message_23060}" "${_primary_color_68[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_68[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_68[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_68[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1977_v0="${ret_colored_rgb1973_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1978_v0() {
    local message_23074="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__1976_v0 
    fi
    colored_rgb__1973_v0 "${message_23074}" "${_secondary_color_69[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_69[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_69[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_69[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1978_v0="${ret_colored_rgb1973_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__1979_v0() {
    local message_23191="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__1976_v0 
    fi
    colored_rgb__1973_v0 "${message_23191}" "${_accent_color_70[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_70[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_70[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_70[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent1979_v0="${ret_colored_rgb1973_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__1995_v0() {
    local format_23078="${1}"
    local args_23079=("${!2}")
    args_23079=("${format_23078}" "${args_23079[@]}")
    __status=$?
    printf "${args_23079[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1996_v0() {
    local message_23076="${1}"
    local color_23077="${2}"
    # Prints an error message with a specified color.
    local array_307=("${message_23076}")
    eprintf__1995_v0 "\\x1b[${color_23077}m%s\\x1b[0m" array_307[@]
}

# remove_current_line()
remove_current_line__2000_v0() {
    local array_308=("")
    eprintf__1995_v0 "\\x1b[2K\\x1b[G" array_308[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_309="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_71="$([ "_${command_309}" != "_No" ]; echo $?)"
command_310="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_72="$(( $(( ! _perl_disabled_71 )) && $([ "_${command_310}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2165_v0() {
    local text_23131="${1}"
    if [ "$(( ! _perl_available_72 ))" != 0 ]; then
        ret_perl_get_cjk_width2165_v0=''
        return 1
    fi
    local command_311
    command_311="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_23131}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2165_v0=''
        return "${__status}"
    fi
    local width_str_23132="${command_311}"
    parse_int__13_v0 "${width_str_23132}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2165_v0=''
        return "${__status}"
    fi
    local width_23133="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2165_v0="${width_23133}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2166_v0() {
    local text_23142="${1}"
    local max_width_23143="${2}"
    if [ "$(( ! _perl_available_72 ))" != 0 ]; then
        ret_perl_truncate_cjk2166_v0=''
        return 1
    fi
    local command_312
    command_312="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_23142}" ${max_width_23143} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2166_v0=''
        return "${__status}"
    fi
    local result_23144="${command_312}"
    ret_perl_truncate_cjk2166_v0="${result_23144}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_73=0
_term_size_74=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2173_v0() {
    local command_314
    command_314="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_23113="${command_314}"
    parse_int__13_v0 "${count_23113}"
    __status=$?
    ret_stty_count2173_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2174_v0() {
    stty_count__2173_v0 
    local count_num_23114="${ret_stty_count2173_v0}"
    if [ "$(( count_num_23114 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_23114="$(( count_num_23114 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_23114}
    __status=$?
}

# stty_unlock()
stty_unlock__2175_v0() {
    stty_count__2173_v0 
    local count_num_23249="${ret_stty_count2173_v0}"
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
store_term_size__2176_v0() {
    local size_23118="${1}"
    if [ "$([ "_${size_23118}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2176_v0=0
        return 0
    fi
    split__4_v0 "${size_23118}" " "
    local parts_23119=("${ret_split4_v0[@]}")
    local __length_315=("${parts_23119[@]}")
    if [ "$(( ${#__length_315[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2176_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_23119[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_23119[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_74=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size2176_v0=1
    return 0
}

# query_term_size()
query_term_size__2177_v0() {
    local command_317
    command_317="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_23121="${command_317}"
    store_term_size__2176_v0 "${size_23121}"
    ret_query_term_size2177_v0="${ret_store_term_size2176_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2178_v0() {
    local command_318
    command_318="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_23117="${command_318}"
    store_term_size__2176_v0 "${size_23117}"
    ret_stty_term_size2178_v0="${ret_store_term_size2176_v0}"
    return 0
}

# get_term_size()
get_term_size__2179_v0() {
    stty_term_size__2178_v0 
    local detected_23120="${ret_stty_term_size2178_v0}"
    if [ "$(( ! detected_23120 ))" != 0 ]; then
        query_term_size__2177_v0 
        detected_23120="${ret_query_term_size2177_v0}"
    fi
    _got_term_size_73=1
}

# term_width()
term_width__2181_v0() {
    if [ "$(( ! _got_term_size_73 ))" != 0 ]; then
        get_term_size__2179_v0 
    fi
    ret_term_width2181_v0="${_term_size_74[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__2182_v0() {
    if [ "$(( ! _got_term_size_73 ))" != 0 ]; then
        get_term_size__2179_v0 
    fi
    ret_term_height2182_v0="${_term_size_74[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:101:23)"}"
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
get_supports_truecolor__2192_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_23212="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_23212}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_75="No"
        ret_get_supports_truecolor2192_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_75="No"
        ret_get_supports_truecolor2192_v0=0
        return 0
    fi
    local colorterm_23213="${ret_env_var_get120_v0}"
    _supports_truecolor_75="$(if [ "$(( $([ "_${colorterm_23213}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_23213}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2192_v0="$([ "_${_supports_truecolor_75}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2193_v0() {
    local message_23207="${1}"
    local r_23208="${2}"
    local g_23209="${3}"
    local b_23210="${4}"
    local fallback_23211="${5}"
    if [ "$([ "_${_supports_truecolor_75}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2193_v0="\\x1b[38;2;${r_23208};${g_23209};${b_23210}m""${message_23207}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_75}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2192_v0 
        local ret_get_supports_truecolor2192_v0__50_17="${ret_get_supports_truecolor2192_v0}"
        if [ "${ret_get_supports_truecolor2192_v0__50_17}" != 0 ]; then
            ret_colored_rgb2193_v0="\\x1b[38;2;${r_23208};${g_23209};${b_23210}m""${message_23207}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_23211 == 0 ))" != 0 ]; then
            ret_colored_rgb2193_v0="${message_23207}"
            return 0
        else
            ret_colored_rgb2193_v0="\\x1b[${fallback_23211}m""${message_23207}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_23211 == 0 ))" != 0 ]; then
            ret_colored_rgb2193_v0="${message_23207}"
            return 0
        fi
        ret_colored_rgb2193_v0="\\x1b[${fallback_23211}m""${message_23207}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2195_v0() {
    if [ "$(( ! _got_xylitol_colors_76 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_23201="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_23201}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_23201}" ";"
            local parts_23202=("${ret_split4_v0[@]}")
            local __length_322=("${parts_23202[@]}")
            if [ "$(( ${#__length_322[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23202[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23202[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23202[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23202[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_23203="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_23203}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_23203}" ";"
            local parts_23204=("${ret_split4_v0[@]}")
            local __length_324=("${parts_23204[@]}")
            if [ "$(( ${#__length_324[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23204[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23204[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23204[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23204[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_78=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_23205="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_23205}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_23205}" ";"
            local parts_23206=("${ret_split4_v0[@]}")
            local __length_326=("${parts_23206[@]}")
            if [ "$(( ${#__length_326[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_23206[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23206[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23206[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_23206[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2195_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_76=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2196_v0() {
    inner_get_xylitol_colors__2195_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_76=1
}

# colored_secondary(message: Text)
colored_secondary__2198_v0() {
    local message_23200="${1}"
    if [ "$(( ! _got_xylitol_colors_76 ))" != 0 ]; then
        get_xylitol_colors__2196_v0 
    fi
    colored_rgb__2193_v0 "${message_23200}" "${_secondary_color_78[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_78[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_78[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_78[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2198_v0="${ret_colored_rgb2193_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2213_v0() {
    local command_328
    command_328="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_23226="${command_328}"
    if [ "$([ "_${var_23226}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2213_v0="UP"
        return 0
    elif [ "$([ "_${var_23226}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2213_v0="DOWN"
        return 0
    elif [ "$([ "_${var_23226}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2213_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_23226}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2213_v0="LEFT"
        return 0
    elif [ "$([ "_${var_23226}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2213_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_23226}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2213_v0="INPUT"
        return 0
    else
        ret_get_key2213_v0="${var_23226}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2215_v0() {
    local format_23115="${1}"
    local args_23116=("${!2}")
    args_23116=("${format_23115}" "${args_23116[@]}")
    __status=$?
    printf "${args_23116[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2216_v0() {
    local message_23163="${1}"
    local color_23164="${2}"
    # Prints an error message with a specified color.
    local array_329=("${message_23163}")
    eprintf__2215_v0 "\\x1b[${color_23164}m%s\\x1b[0m" array_329[@]
}

# colored(message: Text, color: Int)
colored__2217_v0() {
    local message_23171="${1}"
    local color_23172="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2217_v0="\\x1b[${color_23172}m""${message_23171}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2219_v0() {
    local cnt_23223="${1}"
    if [ "$(( cnt_23223 > 0 ))" != 0 ]; then
        local sequence_23224=""
        local __range_start_23225=0
        local __range_end_23225="${cnt_23223}"
        local __dir_23225=$(( ${__range_start_23225} <= ${__range_end_23225} ? 1 : -1 ))
        for (( ____23225=${__range_start_23225}; ____23225 * ${__dir_23225} < ${__range_end_23225} * ${__dir_23225}; ____23225+=${__dir_23225} )); do
            sequence_23224+="\\x1b[2K\\x1b[1A"
done
        local array_330=("")
        eprintf__2215_v0 "${sequence_23224}" array_330[@]
    fi
    local array_331=("")
    eprintf__2215_v0 "\\x1b[G" array_331[@]
}

# remove_current_line()
remove_current_line__2220_v0() {
    local array_332=("")
    eprintf__2215_v0 "\\x1b[2K\\x1b[G" array_332[@]
}

# print_blank(cnt: Int)
print_blank__2221_v0() {
    local cnt_23214="${1}"
    printf '%*s' "${cnt_23214}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2222_v0() {
    local cnt_23161="${1}"
    local __range_start_23162=0
    local __range_end_23162="${cnt_23161}"
    local __dir_23162=$(( ${__range_start_23162} <= ${__range_end_23162} ? 1 : -1 ))
    for (( ____23162=${__range_start_23162}; ____23162 * ${__dir_23162} < ${__range_end_23162} * ${__dir_23162}; ____23162+=${__dir_23162} )); do
        local array_333=("")
        eprintf__2215_v0 "
" array_333[@]
done
}

# go_up(cnt: Int)
go_up__2223_v0() {
    local cnt_23180="${1}"
    local array_334=("")
    eprintf__2215_v0 "\\x1b[${cnt_23180}A" array_334[@]
}

# go_down(cnt: Int)
go_down__2224_v0() {
    local cnt_23235="${1}"
    local array_335=("")
    eprintf__2215_v0 "\\x1b[${cnt_23235}B" array_335[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2225_v0() {
    local cnt_23244="${1}"
    if [ "$(( cnt_23244 > 0 ))" != 0 ]; then
        go_down__2224_v0 "${cnt_23244}"
    else
        go_up__2223_v0 "$(( - cnt_23244 ))"
    fi
}

# hide_cursor()
hide_cursor__2226_v0() {
    local array_336=("")
    eprintf__2215_v0 "\\x1b[?25l" array_336[@]
}

# show_cursor()
show_cursor__2227_v0() {
    local array_337=("")
    eprintf__2215_v0 "\\x1b[?25h" array_337[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2228_v0() {
    local text_23137="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_338
    command_338="$([[ "${text_23137}" == *$'\x1b'* || "${text_23137}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_23138="${command_338}"
    ret_has_ansi_escape2228_v0="$([ "_${has_escape_23138}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2230_v0() {
    local text_23127="${1}"
    local command_339
    command_339="$(printf "%s" "${text_23127}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2230_v0="${command_339}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2231_v0() {
    local text_23129="${1}"
    local command_340
    command_340="$(printf "%s" "${text_23129}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_23130="${command_340}"
    ret_is_all_ascii2231_v0="$([ "_${result_23130}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2232_v0() {
    local text_23126="${1}"
    strip_ansi__2230_v0 "${text_23126}"
    local stripped_23128="${ret_strip_ansi2230_v0}"
    # Check if text is all ASCII
    is_all_ascii__2231_v0 "${stripped_23128}"
    local ret_is_all_ascii2231_v0__150_12="${ret_is_all_ascii2231_v0}"
    if [ "$(( ! ret_is_all_ascii2231_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2165_v0 "${stripped_23128}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_341="${stripped_23128}"
            ret_get_visible_len2232_v0="${#__length_341}"
            return 0
        fi
        ret_get_visible_len2232_v0="${ret_perl_get_cjk_width2165_v0}"
        return 0
    else
        local __length_342="${stripped_23128}"
        ret_get_visible_len2232_v0="${#__length_342}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2233_v0() {
    local text_23139="${1}"
    local max_width_23140="${2}"
    get_visible_len__2232_v0 "${text_23139}"
    local visible_len_23141="${ret_get_visible_len2232_v0}"
    if [ "$(( visible_len_23141 <= max_width_23140 ))" != 0 ]; then
        ret_truncate_text2233_v0="${text_23139}"
        return 0
    fi
    is_all_ascii__2231_v0 "${text_23139}"
    local ret_is_all_ascii2231_v0__167_12="${ret_is_all_ascii2231_v0}"
    if [ "$(( ! ret_is_all_ascii2231_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2166_v0 "${text_23139}" "${max_width_23140}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_23139}" | cut -c1-${max_width_23140}
            __status=$?
        fi
        ret_truncate_text2233_v0="${ret_perl_truncate_cjk2166_v0}"
        return 0
    fi
    local command_343
    command_343="$(printf "%s" "${text_23139}" | cut -c1-${max_width_23140})"
    __status=$?
    ret_truncate_text2233_v0="${command_343}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2234_v0() {
    local text_23135="${1}"
    local max_width_23136="${2}"
    has_ansi_escape__2228_v0 "${text_23135}"
    local ret_has_ansi_escape2228_v0__179_12="${ret_has_ansi_escape2228_v0}"
    if [ "$(( ! ret_has_ansi_escape2228_v0__179_12 ))" != 0 ]; then
        truncate_text__2233_v0 "${text_23135}" "${max_width_23136}"
        ret_truncate_ansi2234_v0="${ret_truncate_text2233_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_344
    command_344="$([[ "${text_23135}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_23145="${command_344}"
    # Replace \x1b[ with newline, then split
    local command_345
    command_345="$(t="${text_23135}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_23146="${command_345}"
    split__4_v0 "${replaced_23146}" "
"
    local parts_23147=("${ret_split4_v0[@]}")
    local result_23148=""
    local remaining_width_23149="${max_width_23136}"
    local __range_start_23150=0
    local __length_346=("${parts_23147[@]}")
    local __range_end_23150="${#__length_346[@]}"
    local __dir_23150=$(( ${__range_start_23150} <= ${__range_end_23150} ? 1 : -1 ))
    for (( idx_23150=${__range_start_23150}; idx_23150 * ${__dir_23150} < ${__range_end_23150} * ${__dir_23150}; idx_23150+=${__dir_23150} )); do
        local part_23151="${parts_23147[${idx_23150}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_23150 == 0 )) && $([ "_${starts_with_ansi_23145}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_23151}" == "_" ]; echo $?) && $(( remaining_width_23149 > 0 )) ))" != 0 ]; then
                truncate_text__2233_v0 "${part_23151}" "${remaining_width_23149}"
                local ret_truncate_text2233_v0__201_35="${ret_truncate_text2233_v0}"
                local truncated_23152="${ret_truncate_text2233_v0__201_35}"
                result_23148+="${truncated_23152}"
                get_visible_len__2232_v0 "${truncated_23152}"
                local ret_get_visible_len2232_v0__203_36="${ret_get_visible_len2232_v0}"
                remaining_width_23149="$(( remaining_width_23149 - ret_get_visible_len2232_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_347
            command_347="$(__p="${part_23151}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_23153="${command_347}"
            if [ "$([ "_${m_idx_23153}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_348
                command_348="$(__p="${part_23151}"; printf "%s" "${__p:0:${m_idx_23153}}")"
                __status=$?
                local ansi_params_23154="${command_348}"
                result_23148+="\\x1b[""${ansi_params_23154}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_23153}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_23155="${ret_parse_int13_v0__214_41}"
                local text_start_23156="$(( m_idx_num_23155 + 1 ))"
                local command_349
                command_349="$(__p="${part_23151}"; printf "%s" "${__p:${text_start_23156}}")"
                __status=$?
                local text_part_23157="${command_349}"
                if [ "$(( $([ "_${text_part_23157}" == "_" ]; echo $?) && $(( remaining_width_23149 > 0 )) ))" != 0 ]; then
                    truncate_text__2233_v0 "${text_part_23157}" "${remaining_width_23149}"
                    local ret_truncate_text2233_v0__218_39="${ret_truncate_text2233_v0}"
                    local truncated_23158="${ret_truncate_text2233_v0__218_39}"
                    result_23148+="${truncated_23158}"
                    get_visible_len__2232_v0 "${truncated_23158}"
                    local ret_get_visible_len2232_v0__220_40="${ret_get_visible_len2232_v0}"
                    remaining_width_23149="$(( remaining_width_23149 - ret_get_visible_len2232_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_23151}" == "_" ]; echo $?) && $(( remaining_width_23149 > 0 )) ))" != 0 ]; then
                    truncate_text__2233_v0 "${part_23151}" "${remaining_width_23149}"
                    local ret_truncate_text2233_v0__225_39="${ret_truncate_text2233_v0}"
                    local truncated_23159="${ret_truncate_text2233_v0__225_39}"
                    result_23148+="${truncated_23159}"
                    get_visible_len__2232_v0 "${truncated_23159}"
                    local ret_get_visible_len2232_v0__227_40="${ret_get_visible_len2232_v0}"
                    remaining_width_23149="$(( remaining_width_23149 - ret_get_visible_len2232_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2234_v0="${result_23148}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2235_v0() {
    local text_23124="${1}"
    local max_width_23125="${2}"
    get_visible_len__2232_v0 "${text_23124}"
    local visible_len_23134="${ret_get_visible_len2232_v0}"
    if [ "$(( visible_len_23134 <= max_width_23125 ))" != 0 ]; then
        ret_cutoff_text2235_v0="${text_23124}"
        return 0
    fi
    truncate_ansi__2234_v0 "${text_23124}" "$(( max_width_23125 - 3 ))"
    local ret_truncate_ansi2234_v0__243_12="${ret_truncate_ansi2234_v0}"
    ret_cutoff_text2235_v0="${ret_truncate_ansi2234_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2236_v0() {
    local items_23165=("${!1}")
    local total_len_23166="${2}"
    local term_width_23167="${3}"
    local separator_23168=" • "
    local separator_len_23169=3
    # Fast path: no truncation needed
    if [ "$(( total_len_23166 <= term_width_23167 ))" != 0 ]; then
        local iter_23170=0
        while :
        do
            local __length_350=("${items_23165[@]}")
            if [ "$(( iter_23170 >= ${#__length_350[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_23170 > 0 ))" != 0 ]; then
                eprintf_colored__2216_v0 "${separator_23168}" 90
            fi
            colored__2217_v0 "${items_23165[$(( iter_23170 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2217_v0__268_41="${ret_colored2217_v0}"
            local array_351=("")
            eprintf__2215_v0 "${items_23165[${iter_23170}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2217_v0__268_41}" array_351[@]
            iter_23170="$(( iter_23170 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_23173=0
        local first_23174=1
        local iter_23175=0
        while :
        do
            local __length_352=("${items_23165[@]}")
            if [ "$(( iter_23175 >= ${#__length_352[@]} ))" != 0 ]; then
                break
            fi
            local key_23176="${items_23165[${iter_23175}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_23177="${items_23165[$(( iter_23175 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_353="${key_23176}"
            local __length_354="${action_23177}"
            local part_len_23178="$(( $(( ${#__length_353} + 1 )) + ${#__length_354} ))"
            local needed_23179="${part_len_23178}"
            if [ "$(( ! first_23174 ))" != 0 ]; then
                needed_23179="$(( needed_23179 + separator_len_23169 ))"
            fi
            if [ "$(( $(( current_len_23173 + needed_23179 )) > term_width_23167 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_23174 ))" != 0 ]; then
                eprintf_colored__2216_v0 "${separator_23168}" 90
            fi
            colored__2217_v0 "${action_23177}" 2
            local ret_colored2217_v0__296_33="${ret_colored2217_v0}"
            local array_355=("")
            eprintf__2215_v0 "${key_23176}"" ""${ret_colored2217_v0__296_33}" array_355[@]
            current_len_23173="$(( current_len_23173 + needed_23179 ))"
            first_23174=0
            iter_23175="$(( iter_23175 + 2 ))"
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
render_single_page__2285_v0() {
    local __length_358="${_cursor_89}"
    local cursor_len_23217="${#__length_358}"
    local max_option_width_23218="$(( $(( _term_width_92 - cursor_len_23217 )) - 1 ))"
    local __range_start_23219=0
    local __range_end_23219="${_page_count_95}"
    local __dir_23219=$(( ${__range_start_23219} <= ${__range_end_23219} ? 1 : -1 ))
    for (( i_23219=${__range_start_23219}; i_23219 * ${__dir_23219} < ${__range_end_23219} * ${__dir_23219}; i_23219+=${__dir_23219} )); do
        cutoff_text__2235_v0 "${_page_94[${i_23219}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_23218}"
        local ret_cutoff_text2235_v0__48_27="${ret_cutoff_text2235_v0}"
        local truncated_23220="${ret_cutoff_text2235_v0__48_27}"
        if [ "$(( i_23219 == _selected_88 ))" != 0 ]; then
            colored_secondary__2198_v0 "${_cursor_89}""${truncated_23220}""
"
            local ret_colored_secondary2198_v0__50_21="${ret_colored_secondary2198_v0}"
            local array_359=("")
            eprintf__2215_v0 "${ret_colored_secondary2198_v0__50_21}" array_359[@]
        else
            print_blank__2221_v0 "${cursor_len_23217}"
            local array_360=("")
            eprintf__2215_v0 "${truncated_23220}""
" array_360[@]
        fi
done
    local remaining_slots_23221="$(( _display_count_85 - _page_count_95 ))"
    if [ "$(( remaining_slots_23221 > 0 ))" != 0 ]; then
        local __range_start_23222=0
        local __range_end_23222="${remaining_slots_23221}"
        local __dir_23222=$(( ${__range_start_23222} <= ${__range_end_23222} ? 1 : -1 ))
        for (( ____23222=${__range_start_23222}; ____23222 * ${__dir_23222} < ${__range_end_23222} * ${__dir_23222}; ____23222+=${__dir_23222} )); do
            local array_361=("")
            eprintf__2215_v0 "\\x1b[K
" array_361[@]
done
    fi
}

# render_multi_page()
render_multi_page__2286_v0() {
    local __length_362="${_cursor_89}"
    local cursor_len_23193="${#__length_362}"
    local max_option_width_23194="$(( $(( _term_width_92 - cursor_len_23193 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2291_v0 
    local page_start_23195="${ret_chooser_page_start2291_v0}"
    local __range_start_23196=0
    local __range_end_23196="${_page_count_95}"
    local __dir_23196=$(( ${__range_start_23196} <= ${__range_end_23196} ? 1 : -1 ))
    for (( i_23196=${__range_start_23196}; i_23196 * ${__dir_23196} < ${__range_end_23196} * ${__dir_23196}; i_23196+=${__dir_23196} )); do
        local global_idx_23197="$(( page_start_23195 + i_23196 ))"
        local check_mark_23198
        check_mark_23198="$(if [ "${_checked_96[${global_idx_23197}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2235_v0 "${_page_94[${i_23196}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_23194}"
        local ret_cutoff_text2235_v0__71_27="${ret_cutoff_text2235_v0}"
        local truncated_23199="${ret_cutoff_text2235_v0__71_27}"
        if [ "$(( i_23196 == _selected_88 ))" != 0 ]; then
            colored_secondary__2198_v0 "${_cursor_89}""${check_mark_23198}""${truncated_23199}""
"
            local ret_colored_secondary2198_v0__73_37="${ret_colored_secondary2198_v0}"
            local array_363=("")
            eprintf__2215_v0 "${ret_colored_secondary2198_v0__73_37}" array_363[@]
        elif [ "${_checked_96[${global_idx_23197}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2221_v0 "${cursor_len_23193}"
            colored_secondary__2198_v0 "${check_mark_23198}""${truncated_23199}""
"
            local ret_colored_secondary2198_v0__76_25="${ret_colored_secondary2198_v0}"
            local array_364=("")
            eprintf__2215_v0 "${ret_colored_secondary2198_v0__76_25}" array_364[@]
        else
            print_blank__2221_v0 "${cursor_len_23193}"
            local array_365=("")
            eprintf__2215_v0 "${check_mark_23198}""${truncated_23199}""
" array_365[@]
        fi
done
    local remaining_slots_23215="$(( _display_count_85 - _page_count_95 ))"
    if [ "$(( remaining_slots_23215 > 0 ))" != 0 ]; then
        local __range_start_23216=0
        local __range_end_23216="${remaining_slots_23215}"
        local __dir_23216=$(( ${__range_start_23216} <= ${__range_end_23216} ? 1 : -1 ))
        for (( ____23216=${__range_start_23216}; ____23216 * ${__dir_23216} < ${__range_end_23216} * ${__dir_23216}; ____23216+=${__dir_23216} )); do
            local array_366=("")
            eprintf__2215_v0 "\\x1b[K
" array_366[@]
done
    fi
}

# render_page()
render_page__2287_v0() {
    if [ "${_multi_90}" != 0 ]; then
        render_multi_page__2286_v0 
    else
        render_single_page__2285_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2288_v0() {
    if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
        local array_367=("")
        eprintf__2215_v0 "\\x1b[G\\x1b[K" array_367[@]
        eprintf_colored__2216_v0 "Page $(( _current_page_87 + 1 ))/${_total_pages_86}" 90
        local array_368=("")
        eprintf__2215_v0 "\\x1b[G" array_368[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2289_v0() {
    if [ "$(( ! _multi_90 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
            local array_369=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2236_v0 array_369[@] 36 "${_term_width_92}"
        else
            local array_370=("↑↓" "select" "enter" "confirm")
            render_tooltip__2236_v0 array_370[@] 25 "${_term_width_92}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_86 > 1 )) && $(( _limit_91 < 0 )) ))" != 0 ]; then
            local array_371=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2236_v0 array_371[@] 55 "${_term_width_92}"
        elif [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
            local array_372=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2236_v0 array_372[@] 47 "${_term_width_92}"
        elif [ "$(( _limit_91 < 0 ))" != 0 ]; then
            local array_373=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2236_v0 array_373[@] 44 "${_term_width_92}"
        else
            local array_374=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2236_v0 array_374[@] 36 "${_term_width_92}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2290_v0() {
    local total_23107="${1}"
    local page_size_23108="${2}"
    local header_23109="${3}"
    local cursor_23110="${4}"
    local multi_23111="${5}"
    local limit_23112="${6}"
    _total_83="${total_23107}"
    _cursor_89="${cursor_23110}"
    _multi_90="${multi_23111}"
    _limit_91="${limit_23112}"
    _current_page_87=0
    _selected_88=0
    _first_render_98=1
    _up_paged_99=0
    _checked_count_97=0
    _has_header_93="$([ "_${header_23109}" == "_" ]; echo $?)"
    stty_lock__2174_v0 
    hide_cursor__2226_v0 
    term_width__2181_v0 
    _term_width_92="${ret_term_width2181_v0}"
    term_height__2182_v0 
    local term_height_23122="${ret_term_height2182_v0}"
    local max_page_size_23123
    max_page_size_23123="$(( term_height_23122 - $(if [ "${_has_header_93}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_84="${page_size_23108}"
    if [ "$(( _page_size_84 > max_page_size_23123 ))" != 0 ]; then
        _page_size_84="${max_page_size_23123}"
    fi
    if [ "${_has_header_93}" != 0 ]; then
        cutoff_text__2235_v0 "${header_23109}" "${_term_width_92}"
        local ret_cutoff_text2235_v0__157_17="${ret_cutoff_text2235_v0}"
        local array_375=("")
        eprintf__2215_v0 "${ret_cutoff_text2235_v0__157_17}""
" array_375[@]
    fi
    math_floor__502_v0 "$(( $(( $(( total_23107 + _page_size_84 )) - 1 )) / _page_size_84 ))"
    _total_pages_86="${ret_math_floor502_v0}"
    _display_count_85="${_page_size_84}"
    if [ "$(( total_23107 < _page_size_84 ))" != 0 ]; then
        _display_count_85="${total_23107}"
    fi
    if [ "${multi_23111}" != 0 ]; then
        _checked_96=()
        local __range_start_23160=0
        local __range_end_23160="${total_23107}"
        local __dir_23160=$(( ${__range_start_23160} <= ${__range_end_23160} ? 1 : -1 ))
        for (( ____23160=${__range_start_23160}; ____23160 * ${__dir_23160} < ${__range_end_23160} * ${__dir_23160}; ____23160+=${__dir_23160} )); do
            local array_377=(0)
            _checked_96+=("${array_377[@]}")
done
    fi
    new_line__2222_v0 "${_display_count_85}"
    local array_378=("")
    eprintf__2215_v0 "\\x1b[G" array_378[@]
    if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
        eprintf_colored__2216_v0 "Page $(( _current_page_87 + 1 ))/${_total_pages_86}" 90
    fi
    new_line__2222_v0 1
    render_tooltip_line__2289_v0 
    go_up__2223_v0 "$(( _display_count_85 + 1 ))"
    local array_379=("")
    eprintf__2215_v0 "\\x1b[G" array_379[@]
}

# chooser_page_start()
chooser_page_start__2291_v0() {
    ret_chooser_page_start2291_v0="$(( _current_page_87 * _page_size_84 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2292_v0() {
    chooser_page_start__2291_v0 
    local start_23184="${ret_chooser_page_start2291_v0}"
    local end_23185="$(( start_23184 + _page_size_84 ))"
    if [ "$(( end_23185 > _total_83 ))" != 0 ]; then
        end_23185="${_total_83}"
    fi
    ret_chooser_page_count2292_v0="$(( end_23185 - start_23184 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2293_v0() {
    local -n page_23192="${1}"
    _page_94=("${page_23192[@]}")
    local __length_380=("${page_23192[@]}")
    _page_count_95="${#__length_380[@]}"
    if [ "${_first_render_98}" != 0 ]; then
        _first_render_98=0
        render_page__2287_v0 
    else
        if [ "${_up_paged_99}" != 0 ]; then
            _selected_88="$(( _page_count_95 - 1 ))"
            _up_paged_99=0
        fi
        go_up__2223_v0 1
        remove_line__2219_v0 "$(( _display_count_85 - 1 ))"
        remove_current_line__2220_v0 
        local array_381=("")
        eprintf__2215_v0 "\\x1b[G" array_381[@]
        render_page__2287_v0 
        render_page_indicator__2288_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2294_v0() {
    local prev_selected_23238="${1}"
    chooser_page_start__2291_v0 
    local page_start_23239="${ret_chooser_page_start2291_v0}"
    local check_width_23240
    check_width_23240="$(if [ "${_multi_90}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_382="${_cursor_89}"
    local max_option_width_23241="$(( $(( _term_width_92 - ${#__length_382} )) - check_width_23240 ))"
    go_up__2223_v0 "$(( _display_count_85 - prev_selected_23238 ))"
    local array_383=("")
    eprintf__2215_v0 "\\x1b[K" array_383[@]
    local __length_384="${_cursor_89}"
    print_blank__2221_v0 "${#__length_384}"
    if [ "${_multi_90}" != 0 ]; then
        local was_checked_23242="${_checked_96[$(( page_start_23239 + prev_selected_23238 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2235_v0 "${_page_94[${prev_selected_23238}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_23241}"
        local ret_cutoff_text2235_v0__232_63="${ret_cutoff_text2235_v0}"
        local prev_line_23243
        prev_line_23243="$(if [ "${was_checked_23242}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2235_v0__232_63}"
        if [ "${was_checked_23242}" != 0 ]; then
            colored_secondary__2198_v0 "${prev_line_23243}"
            local ret_colored_secondary2198_v0__234_21="${ret_colored_secondary2198_v0}"
            local array_385=("")
            eprintf__2215_v0 "${ret_colored_secondary2198_v0__234_21}" array_385[@]
        else
            local array_386=("")
            eprintf__2215_v0 "${prev_line_23243}" array_386[@]
        fi
    else
        cutoff_text__2235_v0 "${_page_94[${prev_selected_23238}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_23241}"
        local ret_cutoff_text2235_v0__239_17="${ret_cutoff_text2235_v0}"
        local array_387=("")
        eprintf__2215_v0 "${ret_cutoff_text2235_v0__239_17}" array_387[@]
    fi
    go_up_or_down__2225_v0 "$(( _selected_88 - prev_selected_23238 ))"
    local array_388=("")
    eprintf__2215_v0 "\\x1b[G" array_388[@]
    local array_389=("")
    eprintf__2215_v0 "\\x1b[K" array_389[@]
    local mark_23245
    mark_23245="$(if [ "${_multi_90}" != 0 ]; then echo "$(if [ "${_checked_96[$(( page_start_23239 + _selected_88 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2235_v0 "${_page_94[${_selected_88}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_23241}"
    local ret_cutoff_text2235_v0__246_48="${ret_cutoff_text2235_v0}"
    colored_secondary__2198_v0 "${_cursor_89}""${mark_23245}""${ret_cutoff_text2235_v0__246_48}"
    local ret_colored_secondary2198_v0__246_13="${ret_colored_secondary2198_v0}"
    local array_390=("")
    eprintf__2215_v0 "${ret_colored_secondary2198_v0__246_13}" array_390[@]
    go_down__2224_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_391=("")
    eprintf__2215_v0 "\\x1b[G" array_391[@]
}

# redraw_current_line()
redraw_current_line__2295_v0() {
    chooser_page_start__2291_v0 
    local page_start_23232="${ret_chooser_page_start2291_v0}"
    local __length_392="${_cursor_89}"
    local max_option_width_23233="$(( $(( _term_width_92 - ${#__length_392} )) - 3 ))"
    go_up__2223_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_393=("")
    eprintf__2215_v0 "\\x1b[G" array_393[@]
    local array_394=("")
    eprintf__2215_v0 "\\x1b[K" array_394[@]
    local check_mark_23234
    check_mark_23234="$(if [ "${_checked_96[$(( page_start_23232 + _selected_88 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2235_v0 "${_page_94[${_selected_88}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_23233}"
    local ret_cutoff_text2235_v0__260_54="${ret_cutoff_text2235_v0}"
    colored_secondary__2198_v0 "${_cursor_89}""${check_mark_23234}""${ret_cutoff_text2235_v0__260_54}"
    local ret_colored_secondary2198_v0__260_13="${ret_colored_secondary2198_v0}"
    local array_395=("")
    eprintf__2215_v0 "${ret_colored_secondary2198_v0__260_13}" array_395[@]
    go_down__2224_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_396=("")
    eprintf__2215_v0 "\\x1b[G" array_396[@]
}

# chooser_step()
chooser_step__2296_v0() {
    get_key__2213_v0 
    local key_23227="${ret_get_key2213_v0}"
    local prev_selected_23228="${_selected_88}"
    local prev_page_23229="${_current_page_87}"
    chooser_page_start__2291_v0 
    local page_start_23230="${ret_chooser_page_start2291_v0}"
    _up_paged_99=0
    if [ "$(( $([ "_${key_23227}" != "_UP" ]; echo $?) || $([ "_${key_23227}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_23227}" != "_DOWN" ]; echo $?) || $([ "_${key_23227}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_23227}" != "_LEFT" ]; echo $?) || $([ "_${key_23227}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_87 > 0 ))" != 0 ]; then
            _current_page_87="$(( _current_page_87 - 1 ))"
        fi
        _selected_88=0
    elif [ "$(( $([ "_${key_23227}" != "_RIGHT" ]; echo $?) || $([ "_${key_23227}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_87 < $(( _total_pages_86 - 1 )) ))" != 0 ]; then
            _current_page_87="$(( _current_page_87 + 1 ))"
            _selected_88=0
        else
            _selected_88="$(( _page_count_95 - 1 ))"
        fi
    elif [ "$(( _multi_90 && $(( $([ "_${key_23227}" != "_x" ]; echo $?) || $([ "_${key_23227}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_23231="$(( page_start_23230 + _selected_88 ))"
        if [ "${_checked_96[${global_selected_23231}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_96["${global_selected_23231}"]=0
            _checked_count_97="$(( _checked_count_97 - 1 ))"
        elif [ "$(( $(( _limit_91 < 0 )) || $(( _checked_count_97 < _limit_91 )) ))" != 0 ]; then
            _checked_96["${global_selected_23231}"]=1
            _checked_count_97="$(( _checked_count_97 + 1 ))"
        else
            ret_chooser_step2296_v0="${__CHOOSER_CONTINUE_80}"
            return 0
        fi
        redraw_current_line__2295_v0 
        ret_chooser_step2296_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    elif [ "$(( $(( _multi_90 && $(( $([ "_${key_23227}" != "_a" ]; echo $?) || $([ "_${key_23227}" != "_A" ]; echo $?) )) )) && $(( _limit_91 < 0 )) ))" != 0 ]; then
        local all_checked_23236="$(( _checked_count_97 == _total_83 ))"
        local __range_start_23237=0
        local __range_end_23237="${_total_83}"
        local __dir_23237=$(( ${__range_start_23237} <= ${__range_end_23237} ? 1 : -1 ))
        for (( i_23237=${__range_start_23237}; i_23237 * ${__dir_23237} < ${__range_end_23237} * ${__dir_23237}; i_23237+=${__dir_23237} )); do
            _checked_96["${i_23237}"]="$(( ! all_checked_23236 ))"
done
        _checked_count_97="$(if [ "${all_checked_23236}" != 0 ]; then echo 0; else echo "${_total_83}"; fi)"
        go_up__2223_v0 "${_display_count_85}"
        local array_397=("")
        eprintf__2215_v0 "\\x1b[G" array_397[@]
        render_page__2287_v0 
        ret_chooser_step2296_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    elif [ "$([ "_${key_23227}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2296_v0="${__CHOOSER_DONE_82}"
        return 0
    else
        ret_chooser_step2296_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    fi
    if [ "$(( prev_page_23229 != _current_page_87 ))" != 0 ]; then
        ret_chooser_step2296_v0="${__CHOOSER_NEED_PAGE_81}"
        return 0
    fi
    if [ "$(( prev_selected_23228 != _selected_88 ))" != 0 ]; then
        redraw_selection__2294_v0 "${prev_selected_23228}"
    fi
    ret_chooser_step2296_v0="${__CHOOSER_CONTINUE_80}"
    return 0
}

# chooser_selected()
chooser_selected__2297_v0() {
    chooser_page_start__2291_v0 
    local ret_chooser_page_start2291_v0__362_12="${ret_chooser_page_start2291_v0}"
    ret_chooser_selected2297_v0="$(( ret_chooser_page_start2291_v0__362_12 + _selected_88 ))"
    return 0
}

# chooser_end()
chooser_end__2299_v0() {
    local total_lines_23248="$(( _display_count_85 + 2 ))"
    if [ "${_has_header_93}" != 0 ]; then
        total_lines_23248="$(( total_lines_23248 + 1 ))"
    fi
    go_down__2224_v0 1
    remove_line__2219_v0 "$(( total_lines_23248 - 1 ))"
    remove_current_line__2220_v0 
    stty_unlock__2175_v0 
    show_cursor__2227_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2308_v0() {
    local name_23188="${1}"
    local file_type_23189="${2}"
    local target_23190="${3}"
    if [ "$([ "_${file_type_23189}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1977_v0 "/"
        local ret_colored_primary1977_v0__10_23="${ret_colored_primary1977_v0}"
        ret_format_entry_display2308_v0="${name_23188}""${ret_colored_primary1977_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_23189}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1979_v0 " > "
        local ret_colored_accent1979_v0__13_23="${ret_colored_accent1979_v0}"
        colored_primary__1977_v0 "${target_23190}"
        local ret_colored_primary1977_v0__13_47="${ret_colored_primary1977_v0}"
        ret_format_entry_display2308_v0="${name_23188}""${ret_colored_accent1979_v0__13_23}""${ret_colored_primary1977_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2308_v0="${name_23188}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2309_v0() {
    local start_path_23080="${1}"
    local cursor_23081="${2}"
    local show_hidden_23082="${3}"
    local page_size_23083="${4}"
    stty_lock__1954_v0 
    # Initialize current path
    local current_path_23086="${start_path_23080}"
    if [ "$([ "_${current_path_23086}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1934_v0 
        current_path_23086="${ret_get_cwd1934_v0}"
    fi
    normalize_path__1935_v0 "${current_path_23086}"
    current_path_23086="${ret_normalize_path1935_v0}"
    while :
    do
        colored_primary__1977_v0 "Loading files..."
        local ret_colored_primary1977_v0__41_17="${ret_colored_primary1977_v0}"
        local array_398=("")
        eprintf__1995_v0 "${ret_colored_primary1977_v0__41_17}" array_398[@]
        # Get directory entries
        local listed_names_23089=()
        local listed_types_23090=()
        local listed_targets_23091=()
        get_directory_entries__1933_v0 "${current_path_23086}" "listed_names_23089" "listed_types_23090" "listed_targets_23091"
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_23099=()
        local types_23100=()
        local targets_23101=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_23086}" == "_/" ]; echo $?)" != 0 ]; then
            names_23099+=("..")
            types_23100+=("d")
            targets_23101+=("")
        fi
        local __range_start_23102=0
        local __length_408=("${listed_names_23089[@]}")
        local __range_end_23102="${#__length_408[@]}"
        local __dir_23102=$(( ${__range_start_23102} <= ${__range_end_23102} ? 1 : -1 ))
        for (( i_23102=${__range_start_23102}; i_23102 * ${__dir_23102} < ${__range_end_23102} * ${__dir_23102}; i_23102+=${__dir_23102} )); do
            local name_23103="${listed_names_23089[${i_23102}]?"Index out of bounds (at src/./file/./mod.ab:64:39)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_23103}" "."
            local ret_starts_with22_v0__66_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_23082 )) && ret_starts_with22_v0__66_36 ))" != 0 ]; then
                continue
            fi
            local array_409=("${name_23103}")
            names_23099+=("${array_409[@]}")
            local array_410=("${listed_types_23090[${i_23102}]?"Index out of bounds (at src/./file/./mod.ab:70:36)"}")
            types_23100+=("${array_410[@]}")
            local array_411=("${listed_targets_23091[${i_23102}]?"Index out of bounds (at src/./file/./mod.ab:71:40)"}")
            targets_23101+=("${array_411[@]}")
done
        local __length_412=("${names_23099[@]}")
        local total_23104="${#__length_412[@]}"
        if [ "$(( total_23104 == 0 ))" != 0 ]; then
            eprintf_colored__1996_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1955_v0 
            ret_xyl_file2309_v0=""
            return 0
        fi
        colored_primary__1977_v0 "${current_path_23086}"
        local header_23106="${ret_colored_primary1977_v0}"
        remove_current_line__2000_v0 
        chooser_begin__2290_v0 "${total_23104}" "${page_size_23083}" "${header_23106}" "${cursor_23081}" 0 -1
        local need_page_23181=1
        while :
        do
            if [ "${need_page_23181}" != 0 ]; then
                local page_23182=()
                chooser_page_start__2291_v0 
                local start_23183="${ret_chooser_page_start2291_v0}"
                chooser_page_count__2292_v0 
                local count_23186="${ret_chooser_page_count2292_v0}"
                local __range_start_23187="${start_23183}"
                local __range_end_23187="$(( start_23183 + count_23186 ))"
                local __dir_23187=$(( ${__range_start_23187} <= ${__range_end_23187} ? 1 : -1 ))
                for (( i_23187=${__range_start_23187}; i_23187 * ${__dir_23187} < ${__range_end_23187} * ${__dir_23187}; i_23187+=${__dir_23187} )); do
                    format_entry_display__2308_v0 "${names_23099[${i_23187}]?"Index out of bounds (at src/./file/./mod.ab:92:57)"}" "${types_23100[${i_23187}]?"Index out of bounds (at src/./file/./mod.ab:92:67)"}" "${targets_23101[${i_23187}]?"Index out of bounds (at src/./file/./mod.ab:92:79)"}"
                    local ret_format_entry_display2308_v0__92_30="${ret_format_entry_display2308_v0}"
                    local array_414=("${ret_format_entry_display2308_v0__92_30}")
                    page_23182+=("${array_414[@]}")
done
                chooser_set_page__2293_v0 "page_23182"
            fi
            chooser_step__2296_v0 
            local step_23246="${ret_chooser_step2296_v0}"
            if [ "$(( step_23246 == __CHOOSER_DONE_82 ))" != 0 ]; then
                break
            fi
            need_page_23181="$(( step_23246 == __CHOOSER_NEED_PAGE_81 ))"
        done
        chooser_selected__2297_v0 
        local selected_idx_23247="${ret_chooser_selected2297_v0}"
        chooser_end__2299_v0 
        local name_23250="${names_23099[${selected_idx_23247}]?"Index out of bounds (at src/./file/./mod.ab:105:28)"}"
        local file_type_23251="${types_23100[${selected_idx_23247}]?"Index out of bounds (at src/./file/./mod.ab:106:33)"}"
        if [ "$([ "_${name_23250}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1937_v0 "${current_path_23086}"
            current_path_23086="${ret_get_parent_dir1937_v0}"
        elif [ "$([ "_${file_type_23251}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1936_v0 "${current_path_23086}" "${name_23250}"
            current_path_23086="${ret_path_join1936_v0}"
            normalize_path__1935_v0 "${current_path_23086}"
            current_path_23086="${ret_normalize_path1935_v0}"
        elif [ "$([ "_${file_type_23251}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_23256="${targets_23101[${selected_idx_23247}]?"Index out of bounds (at src/./file/./mod.ab:118:40)"}"
            local target_path_23257="${target_23256}"
            starts_with__22_v0 "${target_23256}" "/"
            local ret_starts_with22_v0__120_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__120_24 ))" != 0 ]; then
                path_join__1936_v0 "${current_path_23086}" "${target_23256}"
                target_path_23257="${ret_path_join1936_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_23257}"
            local ret_dir_exists38_v0__124_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__124_20}" != 0 ]; then
                current_path_23086="${target_path_23257}"
                normalize_path__1935_v0 "${current_path_23086}"
                current_path_23086="${ret_normalize_path1935_v0}"
            else
                stty_unlock__1955_v0 
                path_join__1936_v0 "${current_path_23086}" "${name_23250}"
                ret_xyl_file2309_v0="${ret_path_join1936_v0}"
                return 0
            fi
        else
            stty_unlock__1955_v0 
            path_join__1936_v0 "${current_path_23086}" "${name_23250}"
            ret_xyl_file2309_v0="${ret_path_join1936_v0}"
            return 0
        fi
    done
    stty_unlock__1955_v0 
    ret_xyl_file2309_v0=""
    return 0
}

# print_file_help()
print_file_help__2401_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    printf '%s\n' ""
    colored_primary__1977_v0 "file"
    local ret_colored_primary1977_v0__7_12="${ret_colored_primary1977_v0}"
    local array_415=()
    printf__128_v1 "${ret_colored_primary1977_v0__7_12}" array_415[@]
    local array_416=()
    printf__128_v1 " - Browse filesystem and select a file." array_416[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1978_v0 "Arguments: "
    local ret_colored_secondary1978_v0__11_12="${ret_colored_secondary1978_v0}"
    local array_417=()
    printf__128_v1 "${ret_colored_secondary1978_v0__11_12}""
" array_417[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    printf '%s\n' ""
    colored_secondary__1978_v0 "Flags: "
    local ret_colored_secondary1978_v0__14_12="${ret_colored_secondary1978_v0}"
    local array_418=()
    printf__128_v1 "${ret_colored_secondary1978_v0__14_12}""
" array_418[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2451_v0() {
    local parameters_23054=("${!1}")
    local cursor_23055="> "
    local start_path_23056=""
    local show_hidden_23057=0
    local page_size_23058=10
    local __length_422=("${parameters_23054[@]}")
    local slice_upper_421="${#__length_422[@]}"
    local slice_offset_423=2
    local slice_offset_423=$((${slice_offset_423} > 0 ? ${slice_offset_423} : 0))
    local slice_length_424="$(( slice_upper_421 - slice_offset_423 ))"
    local slice_length_424=$((${slice_length_424} > 0 ? ${slice_length_424} : 0))
    for param_23059 in "${parameters_23054[@]:${slice_offset_423}:${slice_length_424}}"; do
        starts_with__22_v0 "${param_23059}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_23059}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_23059}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_23059}" != "_-h" ]; echo $?) || $([ "_${param_23059}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2401_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_425="--cursor="
            slice__24_v0 "${param_23059}" "${#__length_425}" 0
            cursor_23055="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_426="--path="
            slice__24_v0 "${param_23059}" "${#__length_426}" 0
            start_path_23056="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_23059}" != "_-a" ]; echo $?) || $([ "_${param_23059}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_23057=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_427="--page-size="
            slice__24_v0 "${param_23059}" "${#__length_427}" 0
            local value_23075="${ret_slice24_v0}"
            parse_int__13_v0 "${value_23075}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1996_v0 "ERROR: Invalid page-size value: ""${value_23075}""
" 31
                exit 1
            fi
            page_size_23058="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_23056="${param_23059}"
        fi
    done
    xyl_file__2309_v0 "${start_path_23056}" "${cursor_23055}" "${show_hidden_23057}" "${page_size_23058}"
    ret_execute_file2451_v0="${ret_xyl_file2309_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_103="0.1.0"
__AMBER_VERSION_104="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2453_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__261_v0 "Error: " 91
        local array_428=("")
        eprintf__260_v0 "bc is not installed. Please install bc to use xylitol.
" array_428[@]
        local array_429=("")
        eprintf__260_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_429[@]
        local array_430=("")
        eprintf__260_v0 "  For Fedora: sudo dnf install bc
" array_430[@]
        local array_431=("")
        eprintf__260_v0 "  For Arch Linux: sudo pacman -S bc
" array_431[@]
        ret_check_prerequirements2453_v0=0
        return 0
    fi
    ret_check_prerequirements2453_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2454_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_105=("$0" "$@")
trap_cleanup__2454_v0 
check_prerequirements__2453_v0 
ret_check_prerequirements2453_v0__32_12="${ret_check_prerequirements2453_v0}"
if [ "$(( ! ret_check_prerequirements2453_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_433=("${args_105[@]}")
if [ "$(( ${#__length_433[@]} < 2 ))" != 0 ]; then
    print_help__421_v0 
    exit 0
fi
command_710="${args_105[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_710}" != "_help" ]; echo $?) || $([ "_${command_710}" != "_--help" ]; echo $?) )) || $([ "_${command_710}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__421_v0 
elif [ "$([ "_${command_710}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__825_v0 args_105[@]
    ret_execute_input825_v0__48_18="${ret_execute_input825_v0}"
    printf '%s\n' "${ret_execute_input825_v0__48_18}"
elif [ "$([ "_${command_710}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1340_v0 args_105[@]
    ret_execute_choose1340_v0__51_18="${ret_execute_choose1340_v0}"
    printf '%s\n' "${ret_execute_choose1340_v0__51_18}"
elif [ "$([ "_${command_710}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1778_v0 args_105[@]
    result_15094="${ret_execute_confirm1778_v0}"
    if [ "$([ "_${result_15094}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_710}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2451_v0 args_105[@]
    ret_execute_file2451_v0__61_18="${ret_execute_file2451_v0}"
    printf '%s\n' "${ret_execute_file2451_v0__61_18}"
elif [ "$(( $(( $([ "_${command_710}" != "_version" ]; echo $?) || $([ "_${command_710}" != "_--version" ]; echo $?) )) || $([ "_${command_710}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__242_v0 "xylitol.sh"
    ret_colored_primary242_v0__64_20="${ret_colored_primary242_v0}"
    array_434=()
    printf__128_v1 "${ret_colored_primary242_v0__64_20}" array_434[@]
    array_435=()
    printf__128_v1 " version: " array_435[@]
    colored_accent__244_v0 "${__VERSION_103}"
    ret_colored_accent244_v0__66_20="${ret_colored_accent244_v0}"
    array_436=()
    printf__128_v1 "${ret_colored_accent244_v0__66_20}" array_436[@]
    printf '%s\n' ""
    printf_colored__259_v0 "written in Amber: " 90
    printf_colored__259_v0 "  ""${__AMBER_VERSION_104}" 90
else
    print_help__421_v0 
    printf_colored__259_v0 "ERROR: Unknown command '""${command_710}""'" 91
fi
