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
    local list_7476=("${!1}")
    local delimiter_7477="${2}"
    local command_1
    command_1="$(IFS="${delimiter_7477}" ; printf "%s
" "${list_7476[*]}")"
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
    local text_9120="${1}"
    local pad_9121="${2}"
    local length_9122="${3}"
    local __length_3="${text_9120}"
    if [ "$(( length_9122 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_9120}"
        return 0
    fi
    local __length_4="${text_9120}"
    local pad_len_9123="$(( length_9122 - ${#__length_4} ))"
    local padding_9124=""
    printf -v padding_9124 "%${pad_len_9123}s" ""
    __status=$?
    padding_9124="${padding_9124// /${pad_9121}}"
    __status=$?
    ret_lpad27_v0="${padding_9124}""${text_9120}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_9126="${1}"
    local pad_9127="${2}"
    local length_9128="${3}"
    local __length_5="${text_9126}"
    if [ "$(( length_9128 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_9126}"
        return 0
    fi
    local __length_6="${text_9126}"
    local pad_len_9129="$(( length_9128 - ${#__length_6} ))"
    local padding_9130=""
    printf -v padding_9130 "%${pad_len_9129}s" ""
    __status=$?
    padding_9130="${padding_9130// /${pad_9127}}"
    __status=$?
    ret_rpad28_v0="${text_9126}""${padding_9130}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_9114="${1}"
    local pad_9115="${2}"
    local length_9116="${3}"
    local __length_7="${text_9114}"
    local text_length_9117="${#__length_7}"
    if [ "$(( length_9116 <= text_length_9117 ))" != 0 ]; then
        ret_cpad29_v0="${text_9114}"
        return 0
    fi
    local total_padding_9118="$(( length_9116 - text_length_9117 ))"
    local left_padding_length_9119="$(( text_length_9117 + $(( total_padding_9118 / 2 )) ))"
    lpad__27_v0 "${text_9114}" "${pad_9115}" "${left_padding_length_9119}"
    local left_padded_9125="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_9125}" "${pad_9115}" "${length_9116}"
    local center_padded_9131="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_9131}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_13064="${1}"
    [ -d "${path_13064}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# array_find(array: [Text], value: Text)
array_find__67_v0() {
    local array_13051=("${!1}")
    local value_13052="${2}"
    index_13054=0;
    for element_13053 in "${array_13051[@]}"; do
        if [ "$([ "_${value_13052}" != "_${element_13053}" ]; echo $?)" != 0 ]; then
            ret_array_find67_v0="${index_13054}"
            return 0
        fi
        (( index_13054++ )) || true
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
get_supports_truecolor__236_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_656="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_656}" != "_No" ]; echo $?)" != 0 ]; then
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
    local colorterm_657="${ret_env_var_get120_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_657}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_657}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor236_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__237_v0() {
    local message_651="${1}"
    local r_652="${2}"
    local g_653="${3}"
    local b_654="${4}"
    local fallback_655="${5}"
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb237_v0="\\x1b[38;2;${r_652};${g_653};${b_654}m""${message_651}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__236_v0 
        local ret_get_supports_truecolor236_v0__50_17="${ret_get_supports_truecolor236_v0}"
        if [ "${ret_get_supports_truecolor236_v0__50_17}" != 0 ]; then
            ret_colored_rgb237_v0="\\x1b[38;2;${r_652};${g_653};${b_654}m""${message_651}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_655 == 0 ))" != 0 ]; then
            ret_colored_rgb237_v0="${message_651}"
            return 0
        else
            ret_colored_rgb237_v0="\\x1b[${fallback_655}m""${message_651}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_655 == 0 ))" != 0 ]; then
            ret_colored_rgb237_v0="${message_651}"
            return 0
        fi
        ret_colored_rgb237_v0="\\x1b[${fallback_655}m""${message_651}""\\x1b[0m"
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
        local primary_env_636="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_636}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_636}" ";"
            local parts_640=("${ret_split4_v0[@]}")
            local __length_20=("${parts_640[@]}")
            if [ "$(( ${#__length_20[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_640[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
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
        local secondary_env_642="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_642}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_642}" ";"
            local parts_643=("${ret_split4_v0[@]}")
            local __length_22=("${parts_643[@]}")
            if [ "$(( ${#__length_22[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_643[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
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
        local accent_env_644="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_644}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_644}" ";"
            local parts_645=("${ret_split4_v0[@]}")
            local __length_24=("${parts_645[@]}")
            if [ "$(( ${#__length_24[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_645[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors239_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
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
    local message_634="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__240_v0 
    fi
    colored_rgb__237_v0 "${message_634}" "${_primary_color_9[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_9[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_9[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_9[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary241_v0="${ret_colored_rgb237_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__242_v0() {
    local message_660="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__240_v0 
    fi
    colored_rgb__237_v0 "${message_660}" "${_secondary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary242_v0="${ret_colored_rgb237_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__243_v0() {
    local message_663="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__240_v0 
    fi
    colored_rgb__237_v0 "${message_663}" "${_accent_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent243_v0="${ret_colored_rgb237_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__258_v0() {
    local message_13067="${1}"
    local color_13068="${2}"
    # Prints a text with a specified color.
    local array_26=("${message_13067}")
    printf__128_v0 "\\x1b[${color_13068}m%s\\x1b[0m" array_26[@]
}

# eprintf(format: Text, args: [Text])
eprintf__259_v0() {
    local format_80="${1}"
    local args_81=("${!2}")
    args_81=("${format_80}" "${args_81[@]}")
    __status=$?
    printf "${args_81[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__260_v0() {
    local message_78="${1}"
    local color_79="${2}"
    # Prints an error message with a specified color.
    local array_27=("${message_78}")
    eprintf__259_v0 "\\x1b[${color_79}m%s\\x1b[0m" array_27[@]
}

# colored(message: Text, color: Int)
colored__261_v0() {
    local message_661="${1}"
    local color_662="${2}"
    # Returns a text wrapped in color codes.
    ret_colored261_v0="\\x1b[${color_662}m""${message_661}""\\x1b[0m"
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
    local array_28=()
    printf__128_v1 "\\x1b[1m""${ret_colored_primary241_v0__7_24}" array_28[@]
    local array_29=()
    printf__128_v1 " - A tool for " array_29[@]
    colored_primary__241_v0 "fresh"
    local ret_colored_primary241_v0__9_12="${ret_colored_primary241_v0}"
    local array_30=()
    printf__128_v1 "${ret_colored_primary241_v0__9_12}" array_30[@]
    local array_31=()
    printf__128_v1 " shell scripts." array_31[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__242_v0 "Flags: "
    local ret_colored_secondary242_v0__13_12="${ret_colored_secondary242_v0}"
    local array_32=()
    printf__128_v1 "${ret_colored_secondary242_v0__13_12}""
" array_32[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    printf '%s\n' ""
    colored_secondary__242_v0 "Commands: "
    local ret_colored_secondary242_v0__17_12="${ret_colored_secondary242_v0}"
    local array_33=()
    printf__128_v1 "${ret_colored_secondary242_v0__17_12}""
" array_33[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    printf '%s\n' ""
    colored_secondary__242_v0 "Envs: "
    local ret_colored_secondary242_v0__23_12="${ret_colored_secondary242_v0}"
    local array_34=()
    printf__128_v1 "${ret_colored_secondary242_v0__23_12}""
" array_34[@]
    colored__261_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored261_v0__24_78="${ret_colored261_v0}"
    local array_35=()
    printf__128_v1 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored261_v0__24_78}""
" array_35[@]
    colored__261_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored261_v0__25_78="${ret_colored261_v0}"
    local array_36=()
    printf__128_v1 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored261_v0__25_78}""
" array_36[@]
    colored__261_v0 "(default: 3;207;159;92)" 90
    local ret_colored261_v0__26_68="${ret_colored261_v0}"
    local array_37=()
    printf__128_v1 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored261_v0__26_68}""
" array_37[@]
    colored__261_v0 "(default: 3;118;206;94)" 90
    local ret_colored261_v0__27_70="${ret_colored261_v0}"
    local array_38=()
    printf__128_v1 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored261_v0__27_70}""
" array_38[@]
    colored__261_v0 "(default: 234;72;121;95)" 90
    local ret_colored261_v0__28_67="${ret_colored261_v0}"
    local array_39=()
    printf__128_v1 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored261_v0__28_67}""
" array_39[@]
    printf '%s\n' ""
    colored_accent__243_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent243_v0__30_21="${ret_colored_accent243_v0}"
    local array_40=()
    printf__128_v1 "Run ""${ret_colored_accent243_v0__30_21}"" for more information on a command.
" array_40[@]
}

# math_floor(number: Int)
math_floor__501_v0() {
    local number_1745="${1}"
    local command_41
    command_41="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_1745}")"
    __status=$?
    ret_math_floor501_v0="${command_41}"
    return 0
}

# math_ceil(number: Int)
math_ceil__502_v0() {
    local number_1744="${1}"
    math_floor__501_v0 "${number_1744}"
    local ret_math_floor501_v0__52_12="${ret_math_floor501_v0}"
    ret_math_ceil502_v0="$(( ret_math_floor501_v0__52_12 + 1 ))"
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
perl_get_cjk_width__562_v0() {
    local text_1688="${1}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_get_cjk_width562_v0=''
        return 1
    fi
    local command_44
    command_44="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1688}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width562_v0=''
        return "${__status}"
    fi
    local width_str_1689="${command_44}"
    parse_int__13_v0 "${width_str_1689}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width562_v0=''
        return "${__status}"
    fi
    local width_1690="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width562_v0="${width_1690}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__563_v0() {
    local text_1697="${1}"
    local max_width_1698="${2}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_truncate_cjk563_v0=''
        return 1
    fi
    local command_45
    command_45="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_1697}" ${max_width_1698} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk563_v0=''
        return "${__status}"
    fi
    local result_1699="${command_45}"
    ret_perl_truncate_cjk563_v0="${result_1699}"
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
stty_unlock__571_v0() {
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
store_term_size__572_v0() {
    local size_1676="${1}"
    if [ "$([ "_${size_1676}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size572_v0=0
        return 0
    fi
    split__4_v0 "${size_1676}" " "
    local parts_1677=("${ret_split4_v0[@]}")
    local __length_49=("${parts_1677[@]}")
    if [ "$(( ${#__length_49[@]} != 2 ))" != 0 ]; then
        ret_store_term_size572_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1677[1]?"Index out of bounds (at src/./input/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1677[0]?"Index out of bounds (at src/./input/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_15=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size572_v0=1
    return 0
}

# query_term_size()
query_term_size__573_v0() {
    local command_51
    command_51="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1679="${command_51}"
    store_term_size__572_v0 "${size_1679}"
    ret_query_term_size573_v0="${ret_store_term_size572_v0}"
    return 0
}

# stty_term_size()
stty_term_size__574_v0() {
    local command_52
    command_52="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1675="${command_52}"
    store_term_size__572_v0 "${size_1675}"
    ret_stty_term_size574_v0="${ret_store_term_size572_v0}"
    return 0
}

# get_term_size()
get_term_size__575_v0() {
    stty_term_size__574_v0 
    local detected_1678="${ret_stty_term_size574_v0}"
    if [ "$(( ! detected_1678 ))" != 0 ]; then
        query_term_size__573_v0 
        detected_1678="${ret_query_term_size573_v0}"
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
    local config_1656="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_1656}" != "_No" ]; echo $?)" != 0 ]; then
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
    local colorterm_1657="${ret_env_var_get120_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_1657}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_1657}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor588_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__589_v0() {
    local message_1651="${1}"
    local r_1652="${2}"
    local g_1653="${3}"
    local b_1654="${4}"
    local fallback_1655="${5}"
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb589_v0="\\x1b[38;2;${r_1652};${g_1653};${b_1654}m""${message_1651}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__588_v0 
        local ret_get_supports_truecolor588_v0__50_17="${ret_get_supports_truecolor588_v0}"
        if [ "${ret_get_supports_truecolor588_v0__50_17}" != 0 ]; then
            ret_colored_rgb589_v0="\\x1b[38;2;${r_1652};${g_1653};${b_1654}m""${message_1651}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1655 == 0 ))" != 0 ]; then
            ret_colored_rgb589_v0="${message_1651}"
            return 0
        else
            ret_colored_rgb589_v0="\\x1b[${fallback_1655}m""${message_1651}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1655 == 0 ))" != 0 ]; then
            ret_colored_rgb589_v0="${message_1651}"
            return 0
        fi
        ret_colored_rgb589_v0="\\x1b[${fallback_1655}m""${message_1651}""\\x1b[0m"
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
        local primary_env_1645="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1645}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1645}" ";"
            local parts_1646=("${ret_split4_v0[@]}")
            local __length_56=("${parts_1646[@]}")
            if [ "$(( ${#__length_56[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1646[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1646[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1646[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1646[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
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
        local secondary_env_1647="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1647}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1647}" ";"
            local parts_1648=("${ret_split4_v0[@]}")
            local __length_58=("${parts_1648[@]}")
            if [ "$(( ${#__length_58[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1648[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1648[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1648[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1648[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
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
        local accent_env_1649="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1649}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1649}" ";"
            local parts_1650=("${ret_split4_v0[@]}")
            local __length_60=("${parts_1650[@]}")
            if [ "$(( ${#__length_60[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1650[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1650[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1650[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors591_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1650[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
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
    local message_1644="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__592_v0 
    fi
    colored_rgb__589_v0 "${message_1644}" "${_primary_color_18[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_18[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_18[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_18[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary593_v0="${ret_colored_rgb589_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__594_v0() {
    local message_1658="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__592_v0 
    fi
    colored_rgb__589_v0 "${message_1658}" "${_secondary_color_19[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_19[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_19[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_19[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary594_v0="${ret_colored_rgb589_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__608_v0() {
    local command_62
    command_62="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_1737="${command_62}"
    ret_get_char608_v0="${char_1737}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__611_v0() {
    local format_1715="${1}"
    local args_1716=("${!2}")
    args_1716=("${format_1715}" "${args_1716[@]}")
    __status=$?
    printf "${args_1716[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__612_v0() {
    local message_1725="${1}"
    local color_1726="${2}"
    # Prints an error message with a specified color.
    local array_63=("${message_1725}")
    eprintf__611_v0 "\\x1b[${color_1726}m%s\\x1b[0m" array_63[@]
}

# colored(message: Text, color: Int)
colored__613_v0() {
    local message_1727="${1}"
    local color_1728="${2}"
    # Returns a text wrapped in color codes.
    ret_colored613_v0="\\x1b[${color_1728}m""${message_1727}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__614_v0() {
    local cnt_1739="${1}"
    if [ "$(( cnt_1739 > 0 ))" != 0 ]; then
        local array_64=("")
        eprintf__611_v0 "\\x1b[${cnt_1739}D\\x1b[K" array_64[@]
    fi
}

# remove_line(cnt: Int)
remove_line__615_v0() {
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
        eprintf__611_v0 "${sequence_1749}" array_65[@]
    fi
    local array_66=("")
    eprintf__611_v0 "\\x1b[G" array_66[@]
}

# remove_current_line()
remove_current_line__616_v0() {
    local array_67=("")
    eprintf__611_v0 "\\x1b[2K\\x1b[G" array_67[@]
}

# new_line(cnt: Int)
new_line__618_v0() {
    local cnt_1717="${1}"
    local __range_start_1718=0
    local __range_end_1718="${cnt_1717}"
    local __dir_1718=$(( ${__range_start_1718} <= ${__range_end_1718} ? 1 : -1 ))
    for (( ____1718=${__range_start_1718}; ____1718 * ${__dir_1718} < ${__range_end_1718} * ${__dir_1718}; ____1718+=${__dir_1718} )); do
        local array_68=("")
        eprintf__611_v0 "
" array_68[@]
done
}

# go_up(cnt: Int)
go_up__619_v0() {
    local cnt_1736="${1}"
    local array_69=("")
    eprintf__611_v0 "\\x1b[${cnt_1736}A" array_69[@]
}

# go_down(cnt: Int)
go_down__620_v0() {
    local cnt_1747="${1}"
    local array_70=("")
    eprintf__611_v0 "\\x1b[${cnt_1747}B" array_70[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__624_v0() {
    local text_1665="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_71
    command_71="$([[ "${text_1665}" == *$'\x1b'* || "${text_1665}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1666="${command_71}"
    ret_has_ansi_escape624_v0="$([ "_${has_escape_1666}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__625_v0() {
    local text_1667="${1}"
    local command_72
    command_72="$(printf '%s' "${text_1667}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi625_v0="${command_72}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__626_v0() {
    local text_1684="${1}"
    local command_73
    command_73="$(printf "%s" "${text_1684}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi626_v0="${command_73}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__627_v0() {
    local text_1686="${1}"
    local command_74
    command_74="$(printf "%s" "${text_1686}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1687="${command_74}"
    ret_is_all_ascii627_v0="$([ "_${result_1687}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__628_v0() {
    local text_1683="${1}"
    strip_ansi__626_v0 "${text_1683}"
    local stripped_1685="${ret_strip_ansi626_v0}"
    # Check if text is all ASCII
    is_all_ascii__627_v0 "${stripped_1685}"
    local ret_is_all_ascii627_v0__150_12="${ret_is_all_ascii627_v0}"
    if [ "$(( ! ret_is_all_ascii627_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__562_v0 "${stripped_1685}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_75="${stripped_1685}"
            ret_get_visible_len628_v0="${#__length_75}"
            return 0
        fi
        ret_get_visible_len628_v0="${ret_perl_get_cjk_width562_v0}"
        return 0
    else
        local __length_76="${stripped_1685}"
        ret_get_visible_len628_v0="${#__length_76}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__629_v0() {
    local text_1694="${1}"
    local max_width_1695="${2}"
    get_visible_len__628_v0 "${text_1694}"
    local visible_len_1696="${ret_get_visible_len628_v0}"
    if [ "$(( visible_len_1696 <= max_width_1695 ))" != 0 ]; then
        ret_truncate_text629_v0="${text_1694}"
        return 0
    fi
    is_all_ascii__627_v0 "${text_1694}"
    local ret_is_all_ascii627_v0__167_12="${ret_is_all_ascii627_v0}"
    if [ "$(( ! ret_is_all_ascii627_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__563_v0 "${text_1694}" "${max_width_1695}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_1694}" | cut -c1-${max_width_1695}
            __status=$?
        fi
        ret_truncate_text629_v0="${ret_perl_truncate_cjk563_v0}"
        return 0
    fi
    local command_77
    command_77="$(printf "%s" "${text_1694}" | cut -c1-${max_width_1695})"
    __status=$?
    ret_truncate_text629_v0="${command_77}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__630_v0() {
    local text_1692="${1}"
    local max_width_1693="${2}"
    has_ansi_escape__624_v0 "${text_1692}"
    local ret_has_ansi_escape624_v0__179_12="${ret_has_ansi_escape624_v0}"
    if [ "$(( ! ret_has_ansi_escape624_v0__179_12 ))" != 0 ]; then
        truncate_text__629_v0 "${text_1692}" "${max_width_1693}"
        ret_truncate_ansi630_v0="${ret_truncate_text629_v0}"
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
                truncate_text__629_v0 "${part_1706}" "${remaining_width_1704}"
                local ret_truncate_text629_v0__201_35="${ret_truncate_text629_v0}"
                local truncated_1707="${ret_truncate_text629_v0__201_35}"
                result_1703+="${truncated_1707}"
                get_visible_len__628_v0 "${truncated_1707}"
                local ret_get_visible_len628_v0__203_36="${ret_get_visible_len628_v0}"
                remaining_width_1704="$(( remaining_width_1704 - ret_get_visible_len628_v0__203_36 ))"
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
                    truncate_text__629_v0 "${text_part_1712}" "${remaining_width_1704}"
                    local ret_truncate_text629_v0__218_39="${ret_truncate_text629_v0}"
                    local truncated_1713="${ret_truncate_text629_v0__218_39}"
                    result_1703+="${truncated_1713}"
                    get_visible_len__628_v0 "${truncated_1713}"
                    local ret_get_visible_len628_v0__220_40="${ret_get_visible_len628_v0}"
                    remaining_width_1704="$(( remaining_width_1704 - ret_get_visible_len628_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_1706}" == "_" ]; echo $?) && $(( remaining_width_1704 > 0 )) ))" != 0 ]; then
                    truncate_text__629_v0 "${part_1706}" "${remaining_width_1704}"
                    local ret_truncate_text629_v0__225_39="${ret_truncate_text629_v0}"
                    local truncated_1714="${ret_truncate_text629_v0__225_39}"
                    result_1703+="${truncated_1714}"
                    get_visible_len__628_v0 "${truncated_1714}"
                    local ret_get_visible_len628_v0__227_40="${ret_get_visible_len628_v0}"
                    remaining_width_1704="$(( remaining_width_1704 - ret_get_visible_len628_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi630_v0="${result_1703}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__631_v0() {
    local text_1681="${1}"
    local max_width_1682="${2}"
    get_visible_len__628_v0 "${text_1681}"
    local visible_len_1691="${ret_get_visible_len628_v0}"
    if [ "$(( visible_len_1691 <= max_width_1682 ))" != 0 ]; then
        ret_cutoff_text631_v0="${text_1681}"
        return 0
    fi
    truncate_ansi__630_v0 "${text_1681}" "$(( max_width_1682 - 3 ))"
    local ret_truncate_ansi630_v0__243_12="${ret_truncate_ansi630_v0}"
    ret_cutoff_text631_v0="${ret_truncate_ansi630_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__632_v0() {
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
                eprintf_colored__612_v0 "${separator_1722}" 90
            fi
            colored__613_v0 "${items_1719[$(( iter_1724 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored613_v0__268_41="${ret_colored613_v0}"
            local array_85=("")
            eprintf__611_v0 "${items_1719[${iter_1724}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored613_v0__268_41}" array_85[@]
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
                eprintf_colored__612_v0 "${separator_1722}" 90
            fi
            colored__613_v0 "${action_1733}" 2
            local ret_colored613_v0__296_33="${ret_colored613_v0}"
            local array_89=("")
            eprintf__611_v0 "${key_1732}"" ""${ret_colored613_v0__296_33}" array_89[@]
            current_len_1729="$(( current_len_1729 + needed_1735 ))"
            first_1730=0
            iter_1731="$(( iter_1731 + 2 ))"
        done
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__681_v0() {
    local prompt_1669="${1}"
    local placeholder_1670="${2}"
    local header_1671="${3}"
    local password_1672="${4}"
    stty_lock__570_v0 
    term_width__577_v0 
    local term_width_1680="${ret_term_width577_v0}"
    if [ "$([ "_${header_1671}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__631_v0 "${header_1671}" "${term_width_1680}"
        local ret_cutoff_text631_v0__23_17="${ret_cutoff_text631_v0}"
        local array_90=("")
        eprintf__611_v0 "${ret_cutoff_text631_v0__23_17}""
" array_90[@]
    fi
    new_line__618_v0 2
    # "enter submit" = 12
    local array_91=("enter" "submit")
    render_tooltip__632_v0 array_91[@] 12 "${term_width_1680}"
    go_up__619_v0 2
    local array_92=("")
    eprintf__611_v0 "\\x1b[G" array_92[@]
    local array_93=("")
    eprintf__611_v0 "${prompt_1669}" array_93[@]
    eprintf_colored__612_v0 "${placeholder_1670}" 90
    get_char__608_v0 
    local char_1738="${ret_get_char608_v0}"
    local __length_94="${prompt_1669}"
    remove__614_v0 "${#__length_94}"
    local __length_95="${placeholder_1670}"
    remove__614_v0 "$(( ${#__length_95} + 1 ))"
    local text_1740=""
    if [ "$(( ! password_1672 ))" != 0 ]; then
        stty_unlock__571_v0 
        local command_96
        command_96="$(read -e -i ${char_1738} -p "${prompt_1669}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1740="${command_96}"
    else
        stty_unlock__571_v0 
        local command_97
        command_97="$(read -es -i ${char_1738} -p "${prompt_1669}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_1740="${command_97}"
    fi
    stty_lock__570_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__628_v0 "${prompt_1669}""${text_1740}"
    local input_display_len_1743="${ret_get_visible_len628_v0}"
    math_ceil__502_v0 "$(( input_display_len_1743 / term_width_1680 ))"
    local input_lines_1746="${ret_math_ceil502_v0}"
    if [ "$(( input_lines_1746 < 3 ))" != 0 ]; then
        go_down__620_v0 "$(( 2 - input_lines_1746 ))"
        remove_line__615_v0 2
        remove_current_line__616_v0 
    fi
    if [ "$(( input_lines_1746 >= 3 ))" != 0 ]; then
        remove_line__615_v0 "${input_lines_1746}"
    fi
    if [ "$([ "_${header_1671}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__615_v0 1
        remove_current_line__616_v0 
    fi
    stty_unlock__571_v0 
    ret_xyl_input681_v0="${text_1740}"
    return 0
}

# print_input_help()
print_input_help__773_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    printf '%s\n' ""
    colored_primary__593_v0 "input"
    local ret_colored_primary593_v0__7_12="${ret_colored_primary593_v0}"
    local array_98=()
    printf__128_v1 "${ret_colored_primary593_v0__7_12}" array_98[@]
    local array_99=()
    printf__128_v1 " - Prompt for some input from the user." array_99[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__594_v0 "Flags: "
    local ret_colored_secondary594_v0__11_12="${ret_colored_secondary594_v0}"
    local array_100=()
    printf__128_v1 "${ret_colored_secondary594_v0__11_12}""
" array_100[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__823_v0() {
    local parameters_1638=("${!1}")
    local prompt_1639="> "
    local placeholder_1640="Type here..."
    local header_1641=""
    local password_1642=0
    for param_1643 in "${parameters_1638[@]}"; do
        if [ "$(( $([ "_${param_1643}" != "_-h" ]; echo $?) || $([ "_${param_1643}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__773_v0 
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
    has_ansi_escape__624_v0 "${header_1641}"
    local ret_has_ansi_escape624_v0__31_44="${ret_has_ansi_escape624_v0}"
    escape_ansi__625_v0 "${header_1641}"
    local ret_escape_ansi625_v0__31_73="${ret_escape_ansi625_v0}"
    colored_primary__593_v0 "${header_1641}"
    local ret_colored_primary593_v0__31_111="${ret_colored_primary593_v0}"
    local display_header_1668
    display_header_1668="$(if [ "$(( $([ "_${header_1641}" != "_" ]; echo $?) || ret_has_ansi_escape624_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi625_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary593_v0__31_111}"; fi)"
    xyl_input__681_v0 "${prompt_1639}" "${placeholder_1640}" "${display_header_1668}" "${password_1642}"
    ret_execute_input823_v0="${ret_xyl_input681_v0}"
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
perl_get_cjk_width__960_v0() {
    local text_7365="${1}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_get_cjk_width960_v0=''
        return 1
    fi
    local command_108
    command_108="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_7365}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width960_v0=''
        return "${__status}"
    fi
    local width_str_7366="${command_108}"
    parse_int__13_v0 "${width_str_7366}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width960_v0=''
        return "${__status}"
    fi
    local width_7367="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width960_v0="${width_7367}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__961_v0() {
    local text_7374="${1}"
    local max_width_7375="${2}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_truncate_cjk961_v0=''
        return 1
    fi
    local command_109
    command_109="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_7374}" ${max_width_7375} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk961_v0=''
        return "${__status}"
    fi
    local result_7376="${command_109}"
    ret_perl_truncate_cjk961_v0="${result_7376}"
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
stty_lock__968_v0() {
    local command_111
    command_111="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_7348="${command_111}"
    parse_int__13_v0 "${count_7348}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_7349="${ret_parse_int13_v0}"
    if [ "$(( count_num_7349 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_7349="$(( count_num_7349 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_7349}
    __status=$?
}

# stty_unlock()
stty_unlock__969_v0() {
    local command_112
    command_112="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_7473="${command_112}"
    parse_int__13_v0 "${count_7473}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_7474="${ret_parse_int13_v0}"
    if [ "$(( count_num_7474 > 0 ))" != 0 ]; then
        count_num_7474="$(( count_num_7474 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_7474}
        __status=$?
        if [ "$(( count_num_7474 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__970_v0() {
    local size_7351="${1}"
    if [ "$([ "_${size_7351}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size970_v0=0
        return 0
    fi
    split__4_v0 "${size_7351}" " "
    local parts_7352=("${ret_split4_v0[@]}")
    local __length_113=("${parts_7352[@]}")
    if [ "$(( ${#__length_113[@]} != 2 ))" != 0 ]; then
        ret_store_term_size970_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_7352[1]?"Index out of bounds (at src/./choose/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_7352[0]?"Index out of bounds (at src/./choose/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_24=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size970_v0=1
    return 0
}

# query_term_size()
query_term_size__971_v0() {
    local command_115
    command_115="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_7354="${command_115}"
    store_term_size__970_v0 "${size_7354}"
    ret_query_term_size971_v0="${ret_store_term_size970_v0}"
    return 0
}

# stty_term_size()
stty_term_size__972_v0() {
    local command_116
    command_116="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_7350="${command_116}"
    store_term_size__970_v0 "${size_7350}"
    ret_stty_term_size972_v0="${ret_store_term_size970_v0}"
    return 0
}

# get_term_size()
get_term_size__973_v0() {
    stty_term_size__972_v0 
    local detected_7353="${ret_stty_term_size972_v0}"
    if [ "$(( ! detected_7353 ))" != 0 ]; then
        query_term_size__971_v0 
        detected_7353="${ret_query_term_size971_v0}"
    fi
    _got_term_size_23=1
}

# term_width()
term_width__975_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__973_v0 
    fi
    ret_term_width975_v0="${_term_size_24[0]?"Index out of bounds (at src/./choose/../utils/term.ab:88:23)"}"
    return 0
}

# term_height()
term_height__976_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__973_v0 
    fi
    ret_term_height976_v0="${_term_size_24[1]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
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
get_supports_truecolor__986_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_7321="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_7321}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor986_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor986_v0=0
        return 0
    fi
    local colorterm_7322="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_7322}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_7322}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor986_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__987_v0() {
    local message_7316="${1}"
    local r_7317="${2}"
    local g_7318="${3}"
    local b_7319="${4}"
    local fallback_7320="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb987_v0="\\x1b[38;2;${r_7317};${g_7318};${b_7319}m""${message_7316}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__986_v0 
        local ret_get_supports_truecolor986_v0__50_17="${ret_get_supports_truecolor986_v0}"
        if [ "${ret_get_supports_truecolor986_v0__50_17}" != 0 ]; then
            ret_colored_rgb987_v0="\\x1b[38;2;${r_7317};${g_7318};${b_7319}m""${message_7316}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_7320 == 0 ))" != 0 ]; then
            ret_colored_rgb987_v0="${message_7316}"
            return 0
        else
            ret_colored_rgb987_v0="\\x1b[${fallback_7320}m""${message_7316}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_7320 == 0 ))" != 0 ]; then
            ret_colored_rgb987_v0="${message_7316}"
            return 0
        fi
        ret_colored_rgb987_v0="\\x1b[${fallback_7320}m""${message_7316}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__989_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_7310="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_7310}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_7310}" ";"
            local parts_7311=("${ret_split4_v0[@]}")
            local __length_120=("${parts_7311[@]}")
            if [ "$(( ${#__length_120[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7311[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7311[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7311[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7311[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
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
        local secondary_env_7312="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_7312}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_7312}" ";"
            local parts_7313=("${ret_split4_v0[@]}")
            local __length_122=("${parts_7313[@]}")
            if [ "$(( ${#__length_122[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7313[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7313[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7313[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7313[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
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
        local accent_env_7314="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_7314}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_7314}" ";"
            local parts_7315=("${ret_split4_v0[@]}")
            local __length_124=("${parts_7315[@]}")
            if [ "$(( ${#__length_124[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7315[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7315[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7315[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7315[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors989_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__990_v0() {
    inner_get_xylitol_colors__989_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__991_v0() {
    local message_7309="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__990_v0 
    fi
    colored_rgb__987_v0 "${message_7309}" "${_primary_color_27[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary991_v0="${ret_colored_rgb987_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__992_v0() {
    local message_7331="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__990_v0 
    fi
    colored_rgb__987_v0 "${message_7331}" "${_secondary_color_28[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary992_v0="${ret_colored_rgb987_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1007_v0() {
    local command_126
    command_126="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_7445="${command_126}"
    if [ "$([ "_${var_7445}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1007_v0="UP"
        return 0
    elif [ "$([ "_${var_7445}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1007_v0="DOWN"
        return 0
    elif [ "$([ "_${var_7445}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1007_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_7445}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1007_v0="LEFT"
        return 0
    elif [ "$([ "_${var_7445}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1007_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_7445}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1007_v0="INPUT"
        return 0
    else
        ret_get_key1007_v0="${var_7445}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1009_v0() {
    local format_7335="${1}"
    local args_7336=("${!2}")
    args_7336=("${format_7335}" "${args_7336[@]}")
    __status=$?
    printf "${args_7336[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1010_v0() {
    local message_7333="${1}"
    local color_7334="${2}"
    # Prints an error message with a specified color.
    local array_127=("${message_7333}")
    eprintf__1009_v0 "\\x1b[${color_7334}m%s\\x1b[0m" array_127[@]
}

# colored(message: Text, color: Int)
colored__1011_v0() {
    local message_7404="${1}"
    local color_7405="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1011_v0="\\x1b[${color_7405}m""${message_7404}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1013_v0() {
    local cnt_7460="${1}"
    if [ "$(( cnt_7460 > 0 ))" != 0 ]; then
        local sequence_7461=""
        local __range_start_7462=0
        local __range_end_7462="${cnt_7460}"
        local __dir_7462=$(( ${__range_start_7462} <= ${__range_end_7462} ? 1 : -1 ))
        for (( ____7462=${__range_start_7462}; ____7462 * ${__dir_7462} < ${__range_end_7462} * ${__dir_7462}; ____7462+=${__dir_7462} )); do
            sequence_7461+="\\x1b[2K\\x1b[1A"
done
        local array_128=("")
        eprintf__1009_v0 "${sequence_7461}" array_128[@]
    fi
    local array_129=("")
    eprintf__1009_v0 "\\x1b[G" array_129[@]
}

# remove_current_line()
remove_current_line__1014_v0() {
    local array_130=("")
    eprintf__1009_v0 "\\x1b[2K\\x1b[G" array_130[@]
}

# print_blank(cnt: Int)
print_blank__1015_v0() {
    local cnt_7442="${1}"
    printf '%*s' "${cnt_7442}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1016_v0() {
    local cnt_7396="${1}"
    local __range_start_7397=0
    local __range_end_7397="${cnt_7396}"
    local __dir_7397=$(( ${__range_start_7397} <= ${__range_end_7397} ? 1 : -1 ))
    for (( ____7397=${__range_start_7397}; ____7397 * ${__dir_7397} < ${__range_end_7397} * ${__dir_7397}; ____7397+=${__dir_7397} )); do
        local array_131=("")
        eprintf__1009_v0 "
" array_131[@]
done
}

# go_up(cnt: Int)
go_up__1017_v0() {
    local cnt_7413="${1}"
    local array_132=("")
    eprintf__1009_v0 "\\x1b[${cnt_7413}A" array_132[@]
}

# go_down(cnt: Int)
go_down__1018_v0() {
    local cnt_7456="${1}"
    local array_133=("")
    eprintf__1009_v0 "\\x1b[${cnt_7456}B" array_133[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1019_v0() {
    local cnt_7467="${1}"
    if [ "$(( cnt_7467 > 0 ))" != 0 ]; then
        go_down__1018_v0 "${cnt_7467}"
    else
        go_up__1017_v0 "$(( - cnt_7467 ))"
    fi
}

# hide_cursor()
hide_cursor__1020_v0() {
    local array_134=("")
    eprintf__1009_v0 "\\x1b[?25l" array_134[@]
}

# show_cursor()
show_cursor__1021_v0() {
    local array_135=("")
    eprintf__1009_v0 "\\x1b[?25h" array_135[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1022_v0() {
    local text_7338="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_136
    command_136="$([[ "${text_7338}" == *$'\x1b'* || "${text_7338}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_7339="${command_136}"
    ret_has_ansi_escape1022_v0="$([ "_${has_escape_7339}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1023_v0() {
    local text_7340="${1}"
    local command_137
    command_137="$(printf '%s' "${text_7340}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1023_v0="${command_137}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1024_v0() {
    local text_7361="${1}"
    local command_138
    command_138="$(printf "%s" "${text_7361}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1024_v0="${command_138}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1025_v0() {
    local text_7363="${1}"
    local command_139
    command_139="$(printf "%s" "${text_7363}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_7364="${command_139}"
    ret_is_all_ascii1025_v0="$([ "_${result_7364}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1026_v0() {
    local text_7360="${1}"
    strip_ansi__1024_v0 "${text_7360}"
    local stripped_7362="${ret_strip_ansi1024_v0}"
    # Check if text is all ASCII
    is_all_ascii__1025_v0 "${stripped_7362}"
    local ret_is_all_ascii1025_v0__150_12="${ret_is_all_ascii1025_v0}"
    if [ "$(( ! ret_is_all_ascii1025_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__960_v0 "${stripped_7362}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_140="${stripped_7362}"
            ret_get_visible_len1026_v0="${#__length_140}"
            return 0
        fi
        ret_get_visible_len1026_v0="${ret_perl_get_cjk_width960_v0}"
        return 0
    else
        local __length_141="${stripped_7362}"
        ret_get_visible_len1026_v0="${#__length_141}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1027_v0() {
    local text_7371="${1}"
    local max_width_7372="${2}"
    get_visible_len__1026_v0 "${text_7371}"
    local visible_len_7373="${ret_get_visible_len1026_v0}"
    if [ "$(( visible_len_7373 <= max_width_7372 ))" != 0 ]; then
        ret_truncate_text1027_v0="${text_7371}"
        return 0
    fi
    is_all_ascii__1025_v0 "${text_7371}"
    local ret_is_all_ascii1025_v0__167_12="${ret_is_all_ascii1025_v0}"
    if [ "$(( ! ret_is_all_ascii1025_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__961_v0 "${text_7371}" "${max_width_7372}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_7371}" | cut -c1-${max_width_7372}
            __status=$?
        fi
        ret_truncate_text1027_v0="${ret_perl_truncate_cjk961_v0}"
        return 0
    fi
    local command_142
    command_142="$(printf "%s" "${text_7371}" | cut -c1-${max_width_7372})"
    __status=$?
    ret_truncate_text1027_v0="${command_142}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1028_v0() {
    local text_7369="${1}"
    local max_width_7370="${2}"
    has_ansi_escape__1022_v0 "${text_7369}"
    local ret_has_ansi_escape1022_v0__179_12="${ret_has_ansi_escape1022_v0}"
    if [ "$(( ! ret_has_ansi_escape1022_v0__179_12 ))" != 0 ]; then
        truncate_text__1027_v0 "${text_7369}" "${max_width_7370}"
        ret_truncate_ansi1028_v0="${ret_truncate_text1027_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_143
    command_143="$([[ "${text_7369}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_7377="${command_143}"
    # Replace \x1b[ with newline, then split
    local command_144
    command_144="$(t="${text_7369}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_7378="${command_144}"
    split__4_v0 "${replaced_7378}" "
"
    local parts_7379=("${ret_split4_v0[@]}")
    local result_7380=""
    local remaining_width_7381="${max_width_7370}"
    local __range_start_7382=0
    local __length_145=("${parts_7379[@]}")
    local __range_end_7382="${#__length_145[@]}"
    local __dir_7382=$(( ${__range_start_7382} <= ${__range_end_7382} ? 1 : -1 ))
    for (( idx_7382=${__range_start_7382}; idx_7382 * ${__dir_7382} < ${__range_end_7382} * ${__dir_7382}; idx_7382+=${__dir_7382} )); do
        local part_7383="${parts_7379[${idx_7382}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_7382 == 0 )) && $([ "_${starts_with_ansi_7377}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_7383}" == "_" ]; echo $?) && $(( remaining_width_7381 > 0 )) ))" != 0 ]; then
                truncate_text__1027_v0 "${part_7383}" "${remaining_width_7381}"
                local ret_truncate_text1027_v0__201_35="${ret_truncate_text1027_v0}"
                local truncated_7384="${ret_truncate_text1027_v0__201_35}"
                result_7380+="${truncated_7384}"
                get_visible_len__1026_v0 "${truncated_7384}"
                local ret_get_visible_len1026_v0__203_36="${ret_get_visible_len1026_v0}"
                remaining_width_7381="$(( remaining_width_7381 - ret_get_visible_len1026_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_146
            command_146="$(__p="${part_7383}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_7385="${command_146}"
            if [ "$([ "_${m_idx_7385}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_147
                command_147="$(__p="${part_7383}"; printf "%s" "${__p:0:${m_idx_7385}}")"
                __status=$?
                local ansi_params_7386="${command_147}"
                result_7380+="\\x1b[""${ansi_params_7386}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_7385}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_7387="${ret_parse_int13_v0__214_41}"
                local text_start_7388="$(( m_idx_num_7387 + 1 ))"
                local command_148
                command_148="$(__p="${part_7383}"; printf "%s" "${__p:${text_start_7388}}")"
                __status=$?
                local text_part_7389="${command_148}"
                if [ "$(( $([ "_${text_part_7389}" == "_" ]; echo $?) && $(( remaining_width_7381 > 0 )) ))" != 0 ]; then
                    truncate_text__1027_v0 "${text_part_7389}" "${remaining_width_7381}"
                    local ret_truncate_text1027_v0__218_39="${ret_truncate_text1027_v0}"
                    local truncated_7390="${ret_truncate_text1027_v0__218_39}"
                    result_7380+="${truncated_7390}"
                    get_visible_len__1026_v0 "${truncated_7390}"
                    local ret_get_visible_len1026_v0__220_40="${ret_get_visible_len1026_v0}"
                    remaining_width_7381="$(( remaining_width_7381 - ret_get_visible_len1026_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_7383}" == "_" ]; echo $?) && $(( remaining_width_7381 > 0 )) ))" != 0 ]; then
                    truncate_text__1027_v0 "${part_7383}" "${remaining_width_7381}"
                    local ret_truncate_text1027_v0__225_39="${ret_truncate_text1027_v0}"
                    local truncated_7391="${ret_truncate_text1027_v0__225_39}"
                    result_7380+="${truncated_7391}"
                    get_visible_len__1026_v0 "${truncated_7391}"
                    local ret_get_visible_len1026_v0__227_40="${ret_get_visible_len1026_v0}"
                    remaining_width_7381="$(( remaining_width_7381 - ret_get_visible_len1026_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1028_v0="${result_7380}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1029_v0() {
    local text_7358="${1}"
    local max_width_7359="${2}"
    get_visible_len__1026_v0 "${text_7358}"
    local visible_len_7368="${ret_get_visible_len1026_v0}"
    if [ "$(( visible_len_7368 <= max_width_7359 ))" != 0 ]; then
        ret_cutoff_text1029_v0="${text_7358}"
        return 0
    fi
    truncate_ansi__1028_v0 "${text_7358}" "$(( max_width_7359 - 3 ))"
    local ret_truncate_ansi1028_v0__243_12="${ret_truncate_ansi1028_v0}"
    ret_cutoff_text1029_v0="${ret_truncate_ansi1028_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1030_v0() {
    local items_7398=("${!1}")
    local total_len_7399="${2}"
    local term_width_7400="${3}"
    local separator_7401=" • "
    local separator_len_7402=3
    # Fast path: no truncation needed
    if [ "$(( total_len_7399 <= term_width_7400 ))" != 0 ]; then
        local iter_7403=0
        while :
        do
            local __length_149=("${items_7398[@]}")
            if [ "$(( iter_7403 >= ${#__length_149[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_7403 > 0 ))" != 0 ]; then
                eprintf_colored__1010_v0 "${separator_7401}" 90
            fi
            colored__1011_v0 "${items_7398[$(( iter_7403 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1011_v0__268_41="${ret_colored1011_v0}"
            local array_150=("")
            eprintf__1009_v0 "${items_7398[${iter_7403}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1011_v0__268_41}" array_150[@]
            iter_7403="$(( iter_7403 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_7406=0
        local first_7407=1
        local iter_7408=0
        while :
        do
            local __length_151=("${items_7398[@]}")
            if [ "$(( iter_7408 >= ${#__length_151[@]} ))" != 0 ]; then
                break
            fi
            local key_7409="${items_7398[${iter_7408}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_7410="${items_7398[$(( iter_7408 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_152="${key_7409}"
            local __length_153="${action_7410}"
            local part_len_7411="$(( $(( ${#__length_152} + 1 )) + ${#__length_153} ))"
            local needed_7412="${part_len_7411}"
            if [ "$(( ! first_7407 ))" != 0 ]; then
                needed_7412="$(( needed_7412 + separator_len_7402 ))"
            fi
            if [ "$(( $(( current_len_7406 + needed_7412 )) > term_width_7400 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_7407 ))" != 0 ]; then
                eprintf_colored__1010_v0 "${separator_7401}" 90
            fi
            colored__1011_v0 "${action_7410}" 2
            local ret_colored1011_v0__296_33="${ret_colored1011_v0}"
            local array_154=("")
            eprintf__1009_v0 "${key_7409}"" ""${ret_colored1011_v0__296_33}" array_154[@]
            current_len_7406="$(( current_len_7406 + needed_7412 ))"
            first_7407=0
            iter_7408="$(( iter_7408 + 2 ))"
        done
    fi
}

# get_page_options(options: [Text], total: Int, page: Int, page_size: Int)
get_page_options__1079_v0() {
    local -n options_7416="${1}"
    local total_7417="${2}"
    local page_7418="${3}"
    local page_size_7419="${4}"
    local start_7420="$(( page_7418 * page_size_7419 ))"
    local end_7421="$(( start_7420 + page_size_7419 ))"
    if [ "$(( end_7421 > total_7417 ))" != 0 ]; then
        end_7421="${total_7417}"
    fi
    local result_7422=()
    local __range_start_7423="${start_7420}"
    local __range_end_7423="${end_7421}"
    local __dir_7423=$(( ${__range_start_7423} <= ${__range_end_7423} ? 1 : -1 ))
    for (( i_7423=${__range_start_7423}; i_7423 * ${__dir_7423} < ${__range_end_7423} * ${__dir_7423}; i_7423+=${__dir_7423} )); do
        local array_156=("${options_7416[${i_7423}]?"Index out of bounds (at src/./choose/./mod.ab:16:28)"}")
        result_7422+=("${array_156[@]}")
done
    ret_get_page_options1079_v0=("${result_7422[@]}")
    return 0
}

# get_page_start(page: Int, page_size: Int)
get_page_start__1080_v0() {
    local page_7425="${1}"
    local page_size_7426="${2}"
    ret_get_page_start1080_v0="$(( page_7425 * page_size_7426 ))"
    return 0
}

# render_choose_page(page_options: [Text], sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_choose_page__1081_v0() {
    local page_options_7491=("${!1}")
    local sel_7492="${2}"
    local cursor_7493="${3}"
    local display_count_7494="${4}"
    local term_width_7495="${5}"
    local __length_157="${cursor_7493}"
    local cursor_len_7496="${#__length_157}"
    local max_option_width_7497="$(( $(( term_width_7495 - cursor_len_7496 )) - 1 ))"
    local __range_start_7498=0
    local __length_158=("${page_options_7491[@]}")
    local __range_end_7498="${#__length_158[@]}"
    local __dir_7498=$(( ${__range_start_7498} <= ${__range_end_7498} ? 1 : -1 ))
    for (( i_7498=${__range_start_7498}; i_7498 * ${__dir_7498} < ${__range_end_7498} * ${__dir_7498}; i_7498+=${__dir_7498} )); do
        cutoff_text__1029_v0 "${page_options_7491[${i_7498}]?"Index out of bounds (at src/./choose/./mod.ab:29:59)"}" "${max_option_width_7497}"
        local ret_cutoff_text1029_v0__29_34="${ret_cutoff_text1029_v0}"
        local truncated_option_7499="${ret_cutoff_text1029_v0__29_34}"
        if [ "$(( i_7498 == sel_7492 ))" != 0 ]; then
            colored_secondary__992_v0 "${cursor_7493}""${truncated_option_7499}""
"
            local ret_colored_secondary992_v0__31_21="${ret_colored_secondary992_v0}"
            local array_159=("")
            eprintf__1009_v0 "${ret_colored_secondary992_v0__31_21}" array_159[@]
        else
            print_blank__1015_v0 "${cursor_len_7496}"
            local array_160=("")
            eprintf__1009_v0 "${truncated_option_7499}""
" array_160[@]
        fi
done
    local __length_161=("${page_options_7491[@]}")
    local remaining_slots_7500="$(( display_count_7494 - ${#__length_161[@]} ))"
    if [ "$(( remaining_slots_7500 > 0 ))" != 0 ]; then
        # Amber bug gaurd
        local __range_start_7501=0
        local __range_end_7501="${remaining_slots_7500}"
        local __dir_7501=$(( ${__range_start_7501} <= ${__range_end_7501} ? 1 : -1 ))
        for (( ____7501=${__range_start_7501}; ____7501 * ${__dir_7501} < ${__range_end_7501} * ${__dir_7501}; ____7501+=${__dir_7501} )); do
            local array_162=("")
            eprintf__1009_v0 "\\x1b[K
" array_162[@]
done
    fi
}

# render_multi_choose_page(page_options: [Text], checked: [Bool], page_start: Int, sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_multi_choose_page__1082_v0() {
    local page_options_7428=("${!1}")
    local checked_7429=("${!2}")
    local page_start_7430="${3}"
    local sel_7431="${4}"
    local cursor_7432="${5}"
    local display_count_7433="${6}"
    local term_width_7434="${7}"
    local __length_163="${cursor_7432}"
    local cursor_len_7435="${#__length_163}"
    local check_mark_len_7436=2
    # "✓ " or "• "
    local max_option_width_7437="$(( $(( $(( term_width_7434 - cursor_len_7435 )) - check_mark_len_7436 )) - 1 ))"
    local __range_start_7438=0
    local __length_164=("${page_options_7428[@]}")
    local __range_end_7438="${#__length_164[@]}"
    local __dir_7438=$(( ${__range_start_7438} <= ${__range_end_7438} ? 1 : -1 ))
    for (( i_7438=${__range_start_7438}; i_7438 * ${__dir_7438} < ${__range_end_7438} * ${__dir_7438}; i_7438+=${__dir_7438} )); do
        local global_idx_7439="$(( page_start_7430 + i_7438 ))"
        local check_mark_7440
        check_mark_7440="$(if [ "${checked_7429[${global_idx_7439}]?"Index out of bounds (at src/./choose/./mod.ab:51:36)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1029_v0 "${page_options_7428[${i_7438}]?"Index out of bounds (at src/./choose/./mod.ab:52:59)"}" "${max_option_width_7437}"
        local ret_cutoff_text1029_v0__52_34="${ret_cutoff_text1029_v0}"
        local truncated_option_7441="${ret_cutoff_text1029_v0__52_34}"
        if [ "$(( i_7438 == sel_7431 ))" != 0 ]; then
            colored_secondary__992_v0 "${cursor_7432}""${check_mark_7440}""${truncated_option_7441}""
"
            local ret_colored_secondary992_v0__54_31="${ret_colored_secondary992_v0}"
            local array_165=("")
            eprintf__1009_v0 "${ret_colored_secondary992_v0__54_31}" array_165[@]
        elif [ "${checked_7429[${global_idx_7439}]?"Index out of bounds (at src/./choose/./mod.ab:55:21)"}" != 0 ]; then
            print_blank__1015_v0 "${cursor_len_7435}"
            colored_secondary__992_v0 "${check_mark_7440}""${truncated_option_7441}""
"
            local ret_colored_secondary992_v0__57_25="${ret_colored_secondary992_v0}"
            local array_166=("")
            eprintf__1009_v0 "${ret_colored_secondary992_v0__57_25}" array_166[@]
        else
            print_blank__1015_v0 "${cursor_len_7435}"
            local array_167=("")
            eprintf__1009_v0 "${check_mark_7440}""${truncated_option_7441}""
" array_167[@]
        fi
done
    local __length_168=("${page_options_7428[@]}")
    local remaining_slots_7443="$(( display_count_7433 - ${#__length_168[@]} ))"
    if [ "$(( remaining_slots_7443 > 0 ))" != 0 ]; then
        # Amber bug guard
        local __range_start_7444=0
        local __range_end_7444="${remaining_slots_7443}"
        local __dir_7444=$(( ${__range_start_7444} <= ${__range_end_7444} ? 1 : -1 ))
        for (( ____7444=${__range_start_7444}; ____7444 * ${__dir_7444} < ${__range_end_7444} * ${__dir_7444}; ____7444+=${__dir_7444} )); do
            local array_169=("")
            eprintf__1009_v0 "\\x1b[K
" array_169[@]
done
    fi
}

# render_page_indicator(page: Int, total_pages: Int)
render_page_indicator__1083_v0() {
    local page_7463="${1}"
    local total_pages_7464="${2}"
    if [ "$(( total_pages_7464 > 1 ))" != 0 ]; then
        local array_170=("")
        eprintf__1009_v0 "\\x1b[G\\x1b[K" array_170[@]
        eprintf_colored__1010_v0 "Page $(( page_7463 + 1 ))/${total_pages_7464}" 90
        local array_171=("")
        eprintf__1009_v0 "\\x1b[G" array_171[@]
    fi
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1084_v0() {
    local -n options_7478="${1}"
    local cursor_7479="${2}"
    local header_7480="${3}"
    local page_size_7481="${4}"
    # Counted once, see `get_page_options`.
    local __length_172=("${options_7478[@]}")
    local total_7482="${#__length_172[@]}"
    if [ "$(( total_7482 == 0 ))" != 0 ]; then
        eprintf_colored__1010_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__968_v0 
    hide_cursor__1020_v0 
    term_width__975_v0 
    local term_width_7483="${ret_term_width975_v0}"
    term_height__976_v0 
    local term_height_7484="${ret_term_height976_v0}"
    local max_page_size_7485
    max_page_size_7485="$(( term_height_7484 - $(if [ "$([ "_${header_7480}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_7481 > max_page_size_7485 ))" != 0 ]; then
        page_size_7481="${max_page_size_7485}"
    fi
    if [ "$([ "_${header_7480}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1029_v0 "${header_7480}" "${term_width_7483}"
        local ret_cutoff_text1029_v0__112_17="${ret_cutoff_text1029_v0}"
        local array_173=("")
        eprintf__1009_v0 "${ret_cutoff_text1029_v0__112_17}""
" array_173[@]
    fi
    math_floor__501_v0 "$(( $(( $(( total_7482 + page_size_7481 )) - 1 )) / page_size_7481 ))"
    local total_pages_7486="${ret_math_floor501_v0}"
    local current_page_7487=0
    local selected_7488=0
    local display_count_7489="${page_size_7481}"
    if [ "$(( total_7482 < page_size_7481 ))" != 0 ]; then
        display_count_7489="${total_7482}"
    fi
    new_line__1016_v0 "${display_count_7489}"
    local array_174=("")
    eprintf__1009_v0 "\\x1b[G" array_174[@]
    if [ "$(( total_pages_7486 > 1 ))" != 0 ]; then
        eprintf_colored__1010_v0 "Page $(( current_page_7487 + 1 ))/${total_pages_7486}" 90
    fi
    new_line__1016_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( total_pages_7486 > 1 ))" != 0 ]; then
        local array_175=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1030_v0 array_175[@] 36 "${term_width_7483}"
    else
        local array_176=("↑↓" "select" "enter" "confirm")
        render_tooltip__1030_v0 array_176[@] 25 "${term_width_7483}"
    fi
    go_up__1017_v0 "$(( display_count_7489 + 1 ))"
    local array_177=("")
    eprintf__1009_v0 "\\x1b[G" array_177[@]
    get_page_options__1079_v0 "${!options_7478}" "${total_7482}" "${current_page_7487}" "${page_size_7481}"
    local page_options_7490=("${ret_get_page_options1079_v0[@]}")
    render_choose_page__1081_v0 page_options_7490[@] "${selected_7488}" "${cursor_7479}" "${display_count_7489}" "${term_width_7483}"
    while :
    do
        get_key__1007_v0 
        local key_7502="${ret_get_key1007_v0}"
        local prev_selected_7503="${selected_7488}"
        local prev_page_7504="${current_page_7487}"
        local up_paged_7505=0
        if [ "$(( $([ "_${key_7502}" != "_UP" ]; echo $?) || $([ "_${key_7502}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_7488 == 0 )) && $(( total_pages_7486 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7487 > 0 ))" != 0 ]; then
                    current_page_7487="$(( current_page_7487 - 1 ))"
                else
                    current_page_7487="$(( total_pages_7486 - 1 ))"
                fi
                up_paged_7505=1
            elif [ "$(( selected_7488 == 0 ))" != 0 ]; then
                local __length_178=("${page_options_7490[@]}")
                selected_7488="$(( ${#__length_178[@]} - 1 ))"
            else
                selected_7488="$(( selected_7488 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_7502}" != "_DOWN" ]; echo $?) || $([ "_${key_7502}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_179=("${page_options_7490[@]}")
            if [ "$(( selected_7488 == $(( ${#__length_179[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7487 < $(( total_pages_7486 - 1 )) ))" != 0 ]; then
                    current_page_7487="$(( current_page_7487 + 1 ))"
                    selected_7488=0
                else
                    current_page_7487=0
                    selected_7488=0
                fi
            else
                selected_7488="$(( selected_7488 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_7502}" != "_LEFT" ]; echo $?) || $([ "_${key_7502}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7487 > 0 ))" != 0 ]; then
                current_page_7487="$(( current_page_7487 - 1 ))"
                selected_7488=0
            else
                selected_7488=0
            fi
        elif [ "$(( $([ "_${key_7502}" != "_RIGHT" ]; echo $?) || $([ "_${key_7502}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7487 < $(( total_pages_7486 - 1 )) ))" != 0 ]; then
                current_page_7487="$(( current_page_7487 + 1 ))"
                selected_7488=0
            else
                local __length_180=("${page_options_7490[@]}")
                selected_7488="$(( ${#__length_180[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_7502}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_181="${cursor_7479}"
        local max_option_width_7506="$(( $(( term_width_7483 - ${#__length_181} )) - 1 ))"
        if [ "$(( prev_page_7504 != current_page_7487 ))" != 0 ]; then
            get_page_options__1079_v0 "${!options_7478}" "${total_7482}" "${current_page_7487}" "${page_size_7481}"
            page_options_7490=("${ret_get_page_options1079_v0[@]}")
            if [ "${up_paged_7505}" != 0 ]; then
                local __length_182=("${page_options_7490[@]}")
                selected_7488="$(( ${#__length_182[@]} - 1 ))"
            fi
            go_up__1017_v0 1
            remove_line__1013_v0 "$(( display_count_7489 - 1 ))"
            remove_current_line__1014_v0 
            local array_183=("")
            eprintf__1009_v0 "\\x1b[G" array_183[@]
            render_choose_page__1081_v0 page_options_7490[@] "${selected_7488}" "${cursor_7479}" "${display_count_7489}" "${term_width_7483}"
            render_page_indicator__1083_v0 "${current_page_7487}" "${total_pages_7486}"
        elif [ "$(( prev_selected_7503 != selected_7488 ))" != 0 ]; then
            go_up__1017_v0 "$(( display_count_7489 - prev_selected_7503 ))"
            local array_184=("")
            eprintf__1009_v0 "\\x1b[K" array_184[@]
            local __length_185="${cursor_7479}"
            print_blank__1015_v0 "${#__length_185}"
            cutoff_text__1029_v0 "${page_options_7490[${prev_selected_7503}]?"Index out of bounds (at src/./choose/./mod.ab:223:50)"}" "${max_option_width_7506}"
            local ret_cutoff_text1029_v0__223_25="${ret_cutoff_text1029_v0}"
            local array_186=("")
            eprintf__1009_v0 "${ret_cutoff_text1029_v0__223_25}" array_186[@]
            local diff_7507="$(( selected_7488 - prev_selected_7503 ))"
            go_up_or_down__1019_v0 "${diff_7507}"
            local array_187=("")
            eprintf__1009_v0 "\\x1b[G" array_187[@]
            local array_188=("")
            eprintf__1009_v0 "\\x1b[K" array_188[@]
            cutoff_text__1029_v0 "${page_options_7490[${selected_7488}]?"Index out of bounds (at src/./choose/./mod.ab:229:77)"}" "${max_option_width_7506}"
            local ret_cutoff_text1029_v0__229_52="${ret_cutoff_text1029_v0}"
            colored_secondary__992_v0 "${cursor_7479}""${ret_cutoff_text1029_v0__229_52}"
            local ret_colored_secondary992_v0__229_25="${ret_colored_secondary992_v0}"
            local array_189=("")
            eprintf__1009_v0 "${ret_colored_secondary992_v0__229_25}" array_189[@]
            go_down__1018_v0 "$(( display_count_7489 - selected_7488 ))"
            local array_190=("")
            eprintf__1009_v0 "\\x1b[G" array_190[@]
        fi
    done
    local total_lines_7508="$(( display_count_7489 + 2 ))"
    if [ "$([ "_${header_7480}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_7508="$(( total_lines_7508 + 1 ))"
    fi
    go_down__1018_v0 1
    remove_line__1013_v0 "$(( total_lines_7508 - 1 ))"
    remove_current_line__1014_v0 
    stty_unlock__969_v0 
    show_cursor__1021_v0 
    local global_selected_7509="$(( $(( current_page_7487 * page_size_7481 )) + selected_7488 ))"
    ret_xyl_choose1084_v0="${options_7478[${global_selected_7509}]?"Index out of bounds (at src/./choose/./mod.ab:249:20)"}"
    return 0
}

# count_checked(checked: [Bool])
count_checked__1085_v0() {
    local checked_7451=("${!1}")
    local count_7452=0
    for c_7453 in "${checked_7451[@]}"; do
        if [ "${c_7453}" != 0 ]; then
            count_7452="$(( count_7452 + 1 ))"
        fi
    done
    ret_count_checked1085_v0="${count_7452}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1086_v0() {
    local -n options_7342="${1}"
    local cursor_7343="${2}"
    local header_7344="${3}"
    local limit_7345="${4}"
    local page_size_7346="${5}"
    # Counted once, see `get_page_options`.
    local __length_193=("${options_7342[@]}")
    local total_7347="${#__length_193[@]}"
    if [ "$(( total_7347 == 0 ))" != 0 ]; then
        eprintf_colored__1010_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1086_v0=()
        return 0
    fi
    stty_lock__968_v0 
    hide_cursor__1020_v0 
    term_width__975_v0 
    local term_width_7355="${ret_term_width975_v0}"
    term_height__976_v0 
    local term_height_7356="${ret_term_height976_v0}"
    local max_page_size_7357
    max_page_size_7357="$(( term_height_7356 - $(if [ "$([ "_${header_7344}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_7346 > max_page_size_7357 ))" != 0 ]; then
        page_size_7346="${max_page_size_7357}"
    fi
    if [ "$([ "_${header_7344}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1029_v0 "${header_7344}" "${term_width_7355}"
        local ret_cutoff_text1029_v0__295_17="${ret_cutoff_text1029_v0}"
        local array_195=("")
        eprintf__1009_v0 "${ret_cutoff_text1029_v0__295_17}""
" array_195[@]
    fi
    math_floor__501_v0 "$(( $(( $(( total_7347 + page_size_7346 )) - 1 )) / page_size_7346 ))"
    local total_pages_7392="${ret_math_floor501_v0}"
    local current_page_7393=0
    local selected_7394=0
    local display_count_7395="${page_size_7346}"
    if [ "$(( total_7347 < page_size_7346 ))" != 0 ]; then
        display_count_7395="${total_7347}"
    fi
    new_line__1016_v0 "${display_count_7395}"
    local array_196=("")
    eprintf__1009_v0 "\\x1b[G" array_196[@]
    if [ "$(( total_pages_7392 > 1 ))" != 0 ]; then
        eprintf_colored__1010_v0 "Page $(( current_page_7393 + 1 ))/${total_pages_7392}" 90
    fi
    new_line__1016_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( total_pages_7392 > 1 )) && $(( limit_7345 < 0 )) ))" != 0 ]; then
        local array_197=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__1030_v0 array_197[@] 55 "${term_width_7355}"
    elif [ "$(( total_pages_7392 > 1 ))" != 0 ]; then
        local array_198=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__1030_v0 array_198[@] 47 "${term_width_7355}"
    elif [ "$(( limit_7345 < 0 ))" != 0 ]; then
        local array_199=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__1030_v0 array_199[@] 44 "${term_width_7355}"
    else
        local array_200=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__1030_v0 array_200[@] 36 "${term_width_7355}"
    fi
    go_up__1017_v0 "$(( display_count_7395 + 1 ))"
    local array_201=("")
    eprintf__1009_v0 "\\x1b[G" array_201[@]
    local checked_7414=()
    local __range_start_7415=0
    local __range_end_7415="${total_7347}"
    local __dir_7415=$(( ${__range_start_7415} <= ${__range_end_7415} ? 1 : -1 ))
    for (( ____7415=${__range_start_7415}; ____7415 * ${__dir_7415} < ${__range_end_7415} * ${__dir_7415}; ____7415+=${__dir_7415} )); do
        local array_203=(0)
        checked_7414+=("${array_203[@]}")
done
    get_page_options__1079_v0 "${!options_7342}" "${total_7347}" "${current_page_7393}" "${page_size_7346}"
    local page_options_7424=("${ret_get_page_options1079_v0[@]}")
    get_page_start__1080_v0 "${current_page_7393}" "${page_size_7346}"
    local page_start_7427="${ret_get_page_start1080_v0}"
    render_multi_choose_page__1082_v0 page_options_7424[@] checked_7414[@] "${page_start_7427}" "${selected_7394}" "${cursor_7343}" "${display_count_7395}" "${term_width_7355}"
    while :
    do
        get_key__1007_v0 
        local key_7446="${ret_get_key1007_v0}"
        local prev_selected_7447="${selected_7394}"
        local prev_page_7448="${current_page_7393}"
        local global_selected_7449="$(( page_start_7427 + selected_7394 ))"
        local up_paged_7450=0
        if [ "$(( $([ "_${key_7446}" != "_UP" ]; echo $?) || $([ "_${key_7446}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_7394 == 0 )) && $(( total_pages_7392 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7393 > 0 ))" != 0 ]; then
                    current_page_7393="$(( current_page_7393 - 1 ))"
                else
                    current_page_7393="$(( total_pages_7392 - 1 ))"
                fi
                up_paged_7450=1
            elif [ "$(( selected_7394 == 0 ))" != 0 ]; then
                local __length_204=("${page_options_7424[@]}")
                selected_7394="$(( ${#__length_204[@]} - 1 ))"
            else
                selected_7394="$(( selected_7394 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_7446}" != "_DOWN" ]; echo $?) || $([ "_${key_7446}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_205=("${page_options_7424[@]}")
            if [ "$(( selected_7394 == $(( ${#__length_205[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_7393 < $(( total_pages_7392 - 1 )) ))" != 0 ]; then
                    current_page_7393="$(( current_page_7393 + 1 ))"
                    selected_7394=0
                else
                    current_page_7393=0
                    selected_7394=0
                fi
            else
                selected_7394="$(( selected_7394 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_7446}" != "_LEFT" ]; echo $?) || $([ "_${key_7446}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7393 > 0 ))" != 0 ]; then
                current_page_7393="$(( current_page_7393 - 1 ))"
                selected_7394=0
            else
                selected_7394=0
            fi
        elif [ "$(( $([ "_${key_7446}" != "_RIGHT" ]; echo $?) || $([ "_${key_7446}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_7393 < $(( total_pages_7392 - 1 )) ))" != 0 ]; then
                current_page_7393="$(( current_page_7393 + 1 ))"
                selected_7394=0
            else
                local __length_206=("${page_options_7424[@]}")
                selected_7394="$(( ${#__length_206[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_7446}" != "_x" ]; echo $?) || $([ "_${key_7446}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__1085_v0 checked_7414[@]
            local ret_count_checked1085_v0__397_34="${ret_count_checked1085_v0}"
            if [ "${checked_7414[${global_selected_7449}]?"Index out of bounds (at src/./choose/./mod.ab:394:29)"}" != 0 ]; then
                checked_7414["${global_selected_7449}"]=0
            elif [ "$(( $(( limit_7345 < 0 )) || $(( ret_count_checked1085_v0__397_34 < limit_7345 )) ))" != 0 ]; then
                checked_7414["${global_selected_7449}"]=1
            else
                continue
            fi
            local __length_207="${cursor_7343}"
            local max_option_width_7454="$(( $(( $(( term_width_7355 - ${#__length_207} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__1017_v0 "$(( display_count_7395 - selected_7394 ))"
            local array_208=("")
            eprintf__1009_v0 "\\x1b[G" array_208[@]
            local array_209=("")
            eprintf__1009_v0 "\\x1b[K" array_209[@]
            local check_mark_7455
            check_mark_7455="$(if [ "${checked_7414[${global_selected_7449}]?"Index out of bounds (at src/./choose/./mod.ab:406:44)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__1029_v0 "${page_options_7424[${selected_7394}]?"Index out of bounds (at src/./choose/./mod.ab:407:90)"}" "${max_option_width_7454}"
            local ret_cutoff_text1029_v0__407_65="${ret_cutoff_text1029_v0}"
            colored_secondary__992_v0 "${cursor_7343}""${check_mark_7455}""${ret_cutoff_text1029_v0__407_65}"
            local ret_colored_secondary992_v0__407_25="${ret_colored_secondary992_v0}"
            local array_210=("")
            eprintf__1009_v0 "${ret_colored_secondary992_v0__407_25}" array_210[@]
            go_down__1018_v0 "$(( display_count_7395 - selected_7394 ))"
            local array_211=("")
            eprintf__1009_v0 "\\x1b[G" array_211[@]
            continue
        elif [ "$(( $(( $([ "_${key_7446}" != "_a" ]; echo $?) || $([ "_${key_7446}" != "_A" ]; echo $?) )) && $(( limit_7345 < 0 )) ))" != 0 ]; then
            count_checked__1085_v0 checked_7414[@]
            local ret_count_checked1085_v0__413_37="${ret_count_checked1085_v0}"
            local all_checked_7457="$(( ret_count_checked1085_v0__413_37 == total_7347 ))"
            local __range_start_7458=0
            local __length_212=("${checked_7414[@]}")
            local __range_end_7458="${#__length_212[@]}"
            local __dir_7458=$(( ${__range_start_7458} <= ${__range_end_7458} ? 1 : -1 ))
            for (( i_7458=${__range_start_7458}; i_7458 * ${__dir_7458} < ${__range_end_7458} * ${__dir_7458}; i_7458+=${__dir_7458} )); do
                checked_7414["${i_7458}"]="$(( ! all_checked_7457 ))"
done
            go_up__1017_v0 "${display_count_7395}"
            local array_213=("")
            eprintf__1009_v0 "\\x1b[G" array_213[@]
            render_multi_choose_page__1082_v0 page_options_7424[@] checked_7414[@] "${page_start_7427}" "${selected_7394}" "${cursor_7343}" "${display_count_7395}" "${term_width_7355}"
            continue
        elif [ "$([ "_${key_7446}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_214="${cursor_7343}"
        local max_option_width_7459="$(( $(( $(( term_width_7355 - ${#__length_214} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( prev_page_7448 != current_page_7393 ))" != 0 ]; then
            get_page_options__1079_v0 "${!options_7342}" "${total_7347}" "${current_page_7393}" "${page_size_7346}"
            page_options_7424=("${ret_get_page_options1079_v0[@]}")
            get_page_start__1080_v0 "${current_page_7393}" "${page_size_7346}"
            page_start_7427="${ret_get_page_start1080_v0}"
            if [ "${up_paged_7450}" != 0 ]; then
                local __length_215=("${page_options_7424[@]}")
                selected_7394="$(( ${#__length_215[@]} - 1 ))"
            fi
            go_up__1017_v0 1
            remove_line__1013_v0 "$(( display_count_7395 - 1 ))"
            remove_current_line__1014_v0 
            local array_216=("")
            eprintf__1009_v0 "\\x1b[G" array_216[@]
            render_multi_choose_page__1082_v0 page_options_7424[@] checked_7414[@] "${page_start_7427}" "${selected_7394}" "${cursor_7343}" "${display_count_7395}" "${term_width_7355}"
            render_page_indicator__1083_v0 "${current_page_7393}" "${total_pages_7392}"
        elif [ "$(( prev_selected_7447 != selected_7394 ))" != 0 ]; then
            local prev_global_7465="$(( page_start_7427 + prev_selected_7447 ))"
            go_up__1017_v0 "$(( display_count_7395 - prev_selected_7447 ))"
            local array_217=("")
            eprintf__1009_v0 "\\x1b[K" array_217[@]
            local __length_218="${cursor_7343}"
            print_blank__1015_v0 "${#__length_218}"
            if [ "${checked_7414[${prev_global_7465}]?"Index out of bounds (at src/./choose/./mod.ab:448:28)"}" != 0 ]; then
                cutoff_text__1029_v0 "${page_options_7424[${prev_selected_7447}]?"Index out of bounds (at src/./choose/./mod.ab:449:79)"}" "${max_option_width_7459}"
                local ret_cutoff_text1029_v0__449_54="${ret_cutoff_text1029_v0}"
                colored_secondary__992_v0 "✓ ""${ret_cutoff_text1029_v0__449_54}"
                local ret_colored_secondary992_v0__449_29="${ret_colored_secondary992_v0}"
                local array_219=("")
                eprintf__1009_v0 "${ret_colored_secondary992_v0__449_29}" array_219[@]
            else
                cutoff_text__1029_v0 "${page_options_7424[${prev_selected_7447}]?"Index out of bounds (at src/./choose/./mod.ab:451:61)"}" "${max_option_width_7459}"
                local ret_cutoff_text1029_v0__451_36="${ret_cutoff_text1029_v0}"
                local array_220=("")
                eprintf__1009_v0 "• ""${ret_cutoff_text1029_v0__451_36}" array_220[@]
            fi
            local diff_7466="$(( selected_7394 - prev_selected_7447 ))"
            go_up_or_down__1019_v0 "${diff_7466}"
            local array_221=("")
            eprintf__1009_v0 "\\x1b[G" array_221[@]
            local array_222=("")
            eprintf__1009_v0 "\\x1b[K" array_222[@]
            local new_global_7468="$(( page_start_7427 + selected_7394 ))"
            local check_mark_7469
            check_mark_7469="$(if [ "${checked_7414[${new_global_7468}]?"Index out of bounds (at src/./choose/./mod.ab:459:44)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__1029_v0 "${page_options_7424[${selected_7394}]?"Index out of bounds (at src/./choose/./mod.ab:460:90)"}" "${max_option_width_7459}"
            local ret_cutoff_text1029_v0__460_65="${ret_cutoff_text1029_v0}"
            colored_secondary__992_v0 "${cursor_7343}""${check_mark_7469}""${ret_cutoff_text1029_v0__460_65}"
            local ret_colored_secondary992_v0__460_25="${ret_colored_secondary992_v0}"
            local array_223=("")
            eprintf__1009_v0 "${ret_colored_secondary992_v0__460_25}" array_223[@]
            go_down__1018_v0 "$(( display_count_7395 - selected_7394 ))"
            local array_224=("")
            eprintf__1009_v0 "\\x1b[G" array_224[@]
        fi
    done
    local total_lines_7470="$(( display_count_7395 + 2 ))"
    if [ "$([ "_${header_7344}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_7470="$(( total_lines_7470 + 1 ))"
    fi
    go_down__1018_v0 1
    remove_line__1013_v0 "$(( total_lines_7470 - 1 ))"
    remove_current_line__1014_v0 
    local result_7471=()
    local __range_start_7472=0
    local __range_end_7472="${total_7347}"
    local __dir_7472=$(( ${__range_start_7472} <= ${__range_end_7472} ? 1 : -1 ))
    for (( i_7472=${__range_start_7472}; i_7472 * ${__dir_7472} < ${__range_end_7472} * ${__dir_7472}; i_7472+=${__dir_7472} )); do
        if [ "${checked_7414[${i_7472}]?"Index out of bounds (at src/./choose/./mod.ab:479:20)"}" != 0 ]; then
            local array_226=("${options_7342[${i_7472}]?"Index out of bounds (at src/./choose/./mod.ab:480:32)"}")
            result_7471+=("${array_226[@]}")
        fi
done
    stty_unlock__969_v0 
    show_cursor__1021_v0 
    ret_xyl_multi_choose1086_v0=("${result_7471[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1179_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    printf '%s\n' ""
    colored_primary__991_v0 "choose"
    local ret_colored_primary991_v0__7_12="${ret_colored_primary991_v0}"
    local array_227=()
    printf__128_v1 "${ret_colored_primary991_v0__7_12}" array_227[@]
    local array_228=()
    printf__128_v1 " - Choose from a list of options." array_228[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__992_v0 "Arguments: "
    local ret_colored_secondary992_v0__11_12="${ret_colored_secondary992_v0}"
    local array_229=()
    printf__128_v1 "${ret_colored_secondary992_v0__11_12}""
" array_229[@]
    echo "  [<options> ...]        List of options to choose from"
    printf '%s\n' ""
    colored_secondary__992_v0 "Flags: "
    local ret_colored_secondary992_v0__14_12="${ret_colored_secondary992_v0}"
    local array_230=()
    printf__128_v1 "${ret_colored_secondary992_v0__14_12}""
" array_230[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1229_v0() {
    local options_7324=()
    local command_232
    command_232="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_7325="${command_232}"
    if [ "$([ "_${is_tty_7325}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_7324+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1229_v0=("${options_7324[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1230_v0() {
    local parameters_7307=("${!1}")
    local cursor_7308="> "
    colored_primary__991_v0 "Choose: "
    local ret_colored_primary991_v0__17_30="${ret_colored_primary991_v0}"
    local header_7323="\\x1b[1m""${ret_colored_primary991_v0__17_30}"
    read_stdin_options__1229_v0 
    local options_7326=("${ret_read_stdin_options1229_v0[@]}")
    local multi_7327=0
    local limit_7328=-1
    local page_size_7329=10
    local __length_236=("${parameters_7307[@]}")
    local slice_upper_235="${#__length_236[@]}"
    local slice_offset_237=2
    local slice_offset_237=$((${slice_offset_237} > 0 ? ${slice_offset_237} : 0))
    local slice_length_238="$(( slice_upper_235 - slice_offset_237 ))"
    local slice_length_238=$((${slice_length_238} > 0 ? ${slice_length_238} : 0))
    for param_7330 in "${parameters_7307[@]:${slice_offset_237}:${slice_length_238}}"; do
        starts_with__22_v0 "${param_7330}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_7330}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_7330}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_7330}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_7330}" != "_-h" ]; echo $?) || $([ "_${param_7330}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1179_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_239="--cursor="
            slice__24_v0 "${param_7330}" "${#__length_239}" 0
            cursor_7308="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_240="--header="
            slice__24_v0 "${param_7330}" "${#__length_240}" 0
            header_7323="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_241="--limit="
            slice__24_v0 "${param_7330}" "${#__length_241}" 0
            local value_7332="${ret_slice24_v0}"
            parse_int__13_v0 "${value_7332}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1010_v0 "ERROR: Invalid limit value: ""${value_7332}""
" 31
                exit 1
            fi
            limit_7328="${ret_parse_int13_v0}"
            multi_7327=1
        elif [ "$([ "_${param_7330}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_7327=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_242="--page-size="
            slice__24_v0 "${param_7330}" "${#__length_242}" 0
            local value_7337="${ret_slice24_v0}"
            parse_int__13_v0 "${value_7337}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1010_v0 "ERROR: Invalid page-size value: ""${value_7337}""
" 31
                exit 1
            fi
            page_size_7329="${ret_parse_int13_v0}"
        else
            options_7326+=("${param_7330}")
        fi
    done
    has_ansi_escape__1022_v0 "${header_7323}"
    local ret_has_ansi_escape1022_v0__59_44="${ret_has_ansi_escape1022_v0}"
    escape_ansi__1023_v0 "${header_7323}"
    local ret_escape_ansi1023_v0__59_73="${ret_escape_ansi1023_v0}"
    colored_primary__991_v0 "${header_7323}"
    local ret_colored_primary991_v0__59_111="${ret_colored_primary991_v0}"
    local display_header_7341
    display_header_7341="$(if [ "$(( $([ "_${header_7323}" != "_" ]; echo $?) || ret_has_ansi_escape1022_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1023_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary991_v0__59_111}"; fi)"
    if [ "${multi_7327}" != 0 ]; then
        xyl_multi_choose__1086_v0 "options_7326" "${cursor_7308}" "${display_header_7341}" "${limit_7328}" "${page_size_7329}"
        local results_7475=("${ret_xyl_multi_choose1086_v0[@]}")
        join__7_v0 results_7475[@] "
"
        ret_execute_choose1230_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1084_v0 "options_7326" "${cursor_7308}" "${display_header_7341}" "${page_size_7329}"
    ret_execute_choose1230_v0="${ret_xyl_choose1084_v0}"
    return 0
}

# Perl Extensions Utilities
command_244="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_30="$([ "_${command_244}" != "_No" ]; echo $?)"
command_245="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_31="$(( $(( ! _perl_disabled_30 )) && $([ "_${command_245}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1405_v0() {
    local text_9083="${1}"
    if [ "$(( ! _perl_available_31 ))" != 0 ]; then
        ret_perl_get_cjk_width1405_v0=''
        return 1
    fi
    local command_246
    command_246="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_9083}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1405_v0=''
        return "${__status}"
    fi
    local width_str_9084="${command_246}"
    parse_int__13_v0 "${width_str_9084}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1405_v0=''
        return "${__status}"
    fi
    local width_9085="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1405_v0="${width_9085}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1406_v0() {
    local text_9092="${1}"
    local max_width_9093="${2}"
    if [ "$(( ! _perl_available_31 ))" != 0 ]; then
        ret_perl_truncate_cjk1406_v0=''
        return 1
    fi
    local command_247
    command_247="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_9092}" ${max_width_9093} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1406_v0=''
        return "${__status}"
    fi
    local result_9094="${command_247}"
    ret_perl_truncate_cjk1406_v0="${result_9094}"
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
stty_lock__1413_v0() {
    local command_249
    command_249="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_9068="${command_249}"
    parse_int__13_v0 "${count_9068}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_9069="${ret_parse_int13_v0}"
    if [ "$(( count_num_9069 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_9069="$(( count_num_9069 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_9069}
    __status=$?
}

# stty_unlock()
stty_unlock__1414_v0() {
    local command_250
    command_250="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_9165="${command_250}"
    parse_int__13_v0 "${count_9165}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_9166="${ret_parse_int13_v0}"
    if [ "$(( count_num_9166 > 0 ))" != 0 ]; then
        count_num_9166="$(( count_num_9166 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_9166}
        __status=$?
        if [ "$(( count_num_9166 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1415_v0() {
    local size_9071="${1}"
    if [ "$([ "_${size_9071}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1415_v0=0
        return 0
    fi
    split__4_v0 "${size_9071}" " "
    local parts_9072=("${ret_split4_v0[@]}")
    local __length_251=("${parts_9072[@]}")
    if [ "$(( ${#__length_251[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1415_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_9072[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_9072[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_33=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size1415_v0=1
    return 0
}

# query_term_size()
query_term_size__1416_v0() {
    local command_253
    command_253="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_9074="${command_253}"
    store_term_size__1415_v0 "${size_9074}"
    ret_query_term_size1416_v0="${ret_store_term_size1415_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1417_v0() {
    local command_254
    command_254="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_9070="${command_254}"
    store_term_size__1415_v0 "${size_9070}"
    ret_stty_term_size1417_v0="${ret_store_term_size1415_v0}"
    return 0
}

# get_term_size()
get_term_size__1418_v0() {
    stty_term_size__1417_v0 
    local detected_9073="${ret_stty_term_size1417_v0}"
    if [ "$(( ! detected_9073 ))" != 0 ]; then
        query_term_size__1416_v0 
        detected_9073="${ret_query_term_size1416_v0}"
    fi
    _got_term_size_32=1
}

# term_width()
term_width__1420_v0() {
    if [ "$(( ! _got_term_size_32 ))" != 0 ]; then
        get_term_size__1418_v0 
    fi
    ret_term_width1420_v0="${_term_size_33[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:88:23)"}"
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
get_supports_truecolor__1431_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_9051="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_9051}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1431_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1431_v0=0
        return 0
    fi
    local colorterm_9052="${ret_env_var_get120_v0}"
    _supports_truecolor_34="$(if [ "$(( $([ "_${colorterm_9052}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_9052}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1431_v0="$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1432_v0() {
    local message_9046="${1}"
    local r_9047="${2}"
    local g_9048="${3}"
    local b_9049="${4}"
    local fallback_9050="${5}"
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1432_v0="\\x1b[38;2;${r_9047};${g_9048};${b_9049}m""${message_9046}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1431_v0 
        local ret_get_supports_truecolor1431_v0__50_17="${ret_get_supports_truecolor1431_v0}"
        if [ "${ret_get_supports_truecolor1431_v0__50_17}" != 0 ]; then
            ret_colored_rgb1432_v0="\\x1b[38;2;${r_9047};${g_9048};${b_9049}m""${message_9046}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_9050 == 0 ))" != 0 ]; then
            ret_colored_rgb1432_v0="${message_9046}"
            return 0
        else
            ret_colored_rgb1432_v0="\\x1b[${fallback_9050}m""${message_9046}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_9050 == 0 ))" != 0 ]; then
            ret_colored_rgb1432_v0="${message_9046}"
            return 0
        fi
        ret_colored_rgb1432_v0="\\x1b[${fallback_9050}m""${message_9046}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1433_v0() {
    local message_9136="${1}"
    local r_9137="${2}"
    local g_9138="${3}"
    local b_9139="${4}"
    local fallback_9140="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_9141="${fallback_9140}"
    if [ "$(( $(( fallback_9140 >= 30 )) && $(( fallback_9140 <= 37 )) ))" != 0 ]; then
        bg_fallback_9141="$(( fallback_9140 + 10 ))"
    fi
    if [ "$(( $(( fallback_9140 >= 90 )) && $(( fallback_9140 <= 97 )) ))" != 0 ]; then
        bg_fallback_9141="$(( fallback_9140 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1433_v0="\\x1b[48;2;${r_9137};${g_9138};${b_9139}m""${message_9136}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1431_v0 
        local ret_get_supports_truecolor1431_v0__92_17="${ret_get_supports_truecolor1431_v0}"
        if [ "${ret_get_supports_truecolor1431_v0__92_17}" != 0 ]; then
            ret_background_rgb1433_v0="\\x1b[48;2;${r_9137};${g_9138};${b_9139}m""${message_9136}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_9141 == 0 ))" != 0 ]; then
            ret_background_rgb1433_v0="${message_9136}"
            return 0
        else
            ret_background_rgb1433_v0="\\x1b[${bg_fallback_9141}m""${message_9136}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_9141 == 0 ))" != 0 ]; then
            ret_background_rgb1433_v0="${message_9136}"
            return 0
        fi
        ret_background_rgb1433_v0="\\x1b[${bg_fallback_9141}m""${message_9136}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1434_v0() {
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_9040="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_9040}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_9040}" ";"
            local parts_9041=("${ret_split4_v0[@]}")
            local __length_258=("${parts_9041[@]}")
            if [ "$(( ${#__length_258[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9041[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9041[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9041[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9041[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
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
        local secondary_env_9042="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_9042}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_9042}" ";"
            local parts_9043=("${ret_split4_v0[@]}")
            local __length_260=("${parts_9043[@]}")
            if [ "$(( ${#__length_260[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9043[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9043[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9043[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9043[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
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
        local accent_env_9044="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_9044}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_9044}" ";"
            local parts_9045=("${ret_split4_v0[@]}")
            local __length_262=("${parts_9045[@]}")
            if [ "$(( ${#__length_262[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9045[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9045[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9045[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9045[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1434_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_35=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1435_v0() {
    inner_get_xylitol_colors__1434_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_35=1
}

# colored_primary(message: Text)
colored_primary__1436_v0() {
    local message_9039="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1435_v0 
    fi
    colored_rgb__1432_v0 "${message_9039}" "${_primary_color_36[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_36[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_36[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_36[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1436_v0="${ret_colored_rgb1432_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1437_v0() {
    local message_9056="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1435_v0 
    fi
    colored_rgb__1432_v0 "${message_9056}" "${_secondary_color_37[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_37[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_37[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_37[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1437_v0="${ret_colored_rgb1432_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1440_v0() {
    local message_9135="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1435_v0 
    fi
    background_rgb__1433_v0 "${message_9135}" "${_secondary_color_37[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_37[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_37[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_37[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1440_v0="${ret_background_rgb1433_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1452_v0() {
    local command_264
    command_264="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_9158="${command_264}"
    if [ "$([ "_${var_9158}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1452_v0="UP"
        return 0
    elif [ "$([ "_${var_9158}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1452_v0="DOWN"
        return 0
    elif [ "$([ "_${var_9158}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1452_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_9158}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1452_v0="LEFT"
        return 0
    elif [ "$([ "_${var_9158}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1452_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_9158}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1452_v0="INPUT"
        return 0
    else
        ret_get_key1452_v0="${var_9158}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1454_v0() {
    local format_9060="${1}"
    local args_9061=("${!2}")
    args_9061=("${format_9060}" "${args_9061[@]}")
    __status=$?
    printf "${args_9061[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1455_v0() {
    local message_9058="${1}"
    local color_9059="${2}"
    # Prints an error message with a specified color.
    local array_265=("${message_9058}")
    eprintf__1454_v0 "\\x1b[${color_9059}m%s\\x1b[0m" array_265[@]
}

# colored(message: Text, color: Int)
colored__1456_v0() {
    local message_9148="${1}"
    local color_9149="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1456_v0="\\x1b[${color_9149}m""${message_9148}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1458_v0() {
    local cnt_9162="${1}"
    if [ "$(( cnt_9162 > 0 ))" != 0 ]; then
        local sequence_9163=""
        local __range_start_9164=0
        local __range_end_9164="${cnt_9162}"
        local __dir_9164=$(( ${__range_start_9164} <= ${__range_end_9164} ? 1 : -1 ))
        for (( ____9164=${__range_start_9164}; ____9164 * ${__dir_9164} < ${__range_end_9164} * ${__dir_9164}; ____9164+=${__dir_9164} )); do
            sequence_9163+="\\x1b[2K\\x1b[1A"
done
        local array_266=("")
        eprintf__1454_v0 "${sequence_9163}" array_266[@]
    fi
    local array_267=("")
    eprintf__1454_v0 "\\x1b[G" array_267[@]
}

# remove_current_line()
remove_current_line__1459_v0() {
    local array_268=("")
    eprintf__1454_v0 "\\x1b[2K\\x1b[G" array_268[@]
}

# go_up(cnt: Int)
go_up__1462_v0() {
    local cnt_9157="${1}"
    local array_269=("")
    eprintf__1454_v0 "\\x1b[${cnt_9157}A" array_269[@]
}

# go_down(cnt: Int)
go_down__1463_v0() {
    local cnt_9161="${1}"
    local array_270=("")
    eprintf__1454_v0 "\\x1b[${cnt_9161}B" array_270[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1465_v0() {
    local array_271=("")
    eprintf__1454_v0 "\\x1b[?25l" array_271[@]
}

# show_cursor()
show_cursor__1466_v0() {
    local array_272=("")
    eprintf__1454_v0 "\\x1b[?25h" array_272[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1467_v0() {
    local text_9062="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_273
    command_273="$([[ "${text_9062}" == *$'\x1b'* || "${text_9062}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_9063="${command_273}"
    ret_has_ansi_escape1467_v0="$([ "_${has_escape_9063}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1468_v0() {
    local text_9064="${1}"
    local command_274
    command_274="$(printf '%s' "${text_9064}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1468_v0="${command_274}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1469_v0() {
    local text_9079="${1}"
    local command_275
    command_275="$(printf "%s" "${text_9079}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1469_v0="${command_275}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1470_v0() {
    local text_9081="${1}"
    local command_276
    command_276="$(printf "%s" "${text_9081}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_9082="${command_276}"
    ret_is_all_ascii1470_v0="$([ "_${result_9082}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1471_v0() {
    local text_9078="${1}"
    strip_ansi__1469_v0 "${text_9078}"
    local stripped_9080="${ret_strip_ansi1469_v0}"
    # Check if text is all ASCII
    is_all_ascii__1470_v0 "${stripped_9080}"
    local ret_is_all_ascii1470_v0__150_12="${ret_is_all_ascii1470_v0}"
    if [ "$(( ! ret_is_all_ascii1470_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1405_v0 "${stripped_9080}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_277="${stripped_9080}"
            ret_get_visible_len1471_v0="${#__length_277}"
            return 0
        fi
        ret_get_visible_len1471_v0="${ret_perl_get_cjk_width1405_v0}"
        return 0
    else
        local __length_278="${stripped_9080}"
        ret_get_visible_len1471_v0="${#__length_278}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1472_v0() {
    local text_9089="${1}"
    local max_width_9090="${2}"
    get_visible_len__1471_v0 "${text_9089}"
    local visible_len_9091="${ret_get_visible_len1471_v0}"
    if [ "$(( visible_len_9091 <= max_width_9090 ))" != 0 ]; then
        ret_truncate_text1472_v0="${text_9089}"
        return 0
    fi
    is_all_ascii__1470_v0 "${text_9089}"
    local ret_is_all_ascii1470_v0__167_12="${ret_is_all_ascii1470_v0}"
    if [ "$(( ! ret_is_all_ascii1470_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1406_v0 "${text_9089}" "${max_width_9090}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_9089}" | cut -c1-${max_width_9090}
            __status=$?
        fi
        ret_truncate_text1472_v0="${ret_perl_truncate_cjk1406_v0}"
        return 0
    fi
    local command_279
    command_279="$(printf "%s" "${text_9089}" | cut -c1-${max_width_9090})"
    __status=$?
    ret_truncate_text1472_v0="${command_279}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1473_v0() {
    local text_9087="${1}"
    local max_width_9088="${2}"
    has_ansi_escape__1467_v0 "${text_9087}"
    local ret_has_ansi_escape1467_v0__179_12="${ret_has_ansi_escape1467_v0}"
    if [ "$(( ! ret_has_ansi_escape1467_v0__179_12 ))" != 0 ]; then
        truncate_text__1472_v0 "${text_9087}" "${max_width_9088}"
        ret_truncate_ansi1473_v0="${ret_truncate_text1472_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_280
    command_280="$([[ "${text_9087}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_9095="${command_280}"
    # Replace \x1b[ with newline, then split
    local command_281
    command_281="$(t="${text_9087}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_9096="${command_281}"
    split__4_v0 "${replaced_9096}" "
"
    local parts_9097=("${ret_split4_v0[@]}")
    local result_9098=""
    local remaining_width_9099="${max_width_9088}"
    local __range_start_9100=0
    local __length_282=("${parts_9097[@]}")
    local __range_end_9100="${#__length_282[@]}"
    local __dir_9100=$(( ${__range_start_9100} <= ${__range_end_9100} ? 1 : -1 ))
    for (( idx_9100=${__range_start_9100}; idx_9100 * ${__dir_9100} < ${__range_end_9100} * ${__dir_9100}; idx_9100+=${__dir_9100} )); do
        local part_9101="${parts_9097[${idx_9100}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_9100 == 0 )) && $([ "_${starts_with_ansi_9095}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_9101}" == "_" ]; echo $?) && $(( remaining_width_9099 > 0 )) ))" != 0 ]; then
                truncate_text__1472_v0 "${part_9101}" "${remaining_width_9099}"
                local ret_truncate_text1472_v0__201_35="${ret_truncate_text1472_v0}"
                local truncated_9102="${ret_truncate_text1472_v0__201_35}"
                result_9098+="${truncated_9102}"
                get_visible_len__1471_v0 "${truncated_9102}"
                local ret_get_visible_len1471_v0__203_36="${ret_get_visible_len1471_v0}"
                remaining_width_9099="$(( remaining_width_9099 - ret_get_visible_len1471_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_283
            command_283="$(__p="${part_9101}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_9103="${command_283}"
            if [ "$([ "_${m_idx_9103}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_284
                command_284="$(__p="${part_9101}"; printf "%s" "${__p:0:${m_idx_9103}}")"
                __status=$?
                local ansi_params_9104="${command_284}"
                result_9098+="\\x1b[""${ansi_params_9104}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_9103}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_9105="${ret_parse_int13_v0__214_41}"
                local text_start_9106="$(( m_idx_num_9105 + 1 ))"
                local command_285
                command_285="$(__p="${part_9101}"; printf "%s" "${__p:${text_start_9106}}")"
                __status=$?
                local text_part_9107="${command_285}"
                if [ "$(( $([ "_${text_part_9107}" == "_" ]; echo $?) && $(( remaining_width_9099 > 0 )) ))" != 0 ]; then
                    truncate_text__1472_v0 "${text_part_9107}" "${remaining_width_9099}"
                    local ret_truncate_text1472_v0__218_39="${ret_truncate_text1472_v0}"
                    local truncated_9108="${ret_truncate_text1472_v0__218_39}"
                    result_9098+="${truncated_9108}"
                    get_visible_len__1471_v0 "${truncated_9108}"
                    local ret_get_visible_len1471_v0__220_40="${ret_get_visible_len1471_v0}"
                    remaining_width_9099="$(( remaining_width_9099 - ret_get_visible_len1471_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_9101}" == "_" ]; echo $?) && $(( remaining_width_9099 > 0 )) ))" != 0 ]; then
                    truncate_text__1472_v0 "${part_9101}" "${remaining_width_9099}"
                    local ret_truncate_text1472_v0__225_39="${ret_truncate_text1472_v0}"
                    local truncated_9109="${ret_truncate_text1472_v0__225_39}"
                    result_9098+="${truncated_9109}"
                    get_visible_len__1471_v0 "${truncated_9109}"
                    local ret_get_visible_len1471_v0__227_40="${ret_get_visible_len1471_v0}"
                    remaining_width_9099="$(( remaining_width_9099 - ret_get_visible_len1471_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1473_v0="${result_9098}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1474_v0() {
    local text_9076="${1}"
    local max_width_9077="${2}"
    get_visible_len__1471_v0 "${text_9076}"
    local visible_len_9086="${ret_get_visible_len1471_v0}"
    if [ "$(( visible_len_9086 <= max_width_9077 ))" != 0 ]; then
        ret_cutoff_text1474_v0="${text_9076}"
        return 0
    fi
    truncate_ansi__1473_v0 "${text_9076}" "$(( max_width_9077 - 3 ))"
    local ret_truncate_ansi1473_v0__243_12="${ret_truncate_ansi1473_v0}"
    ret_cutoff_text1474_v0="${ret_truncate_ansi1473_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1475_v0() {
    local items_9142=("${!1}")
    local total_len_9143="${2}"
    local term_width_9144="${3}"
    local separator_9145=" • "
    local separator_len_9146=3
    # Fast path: no truncation needed
    if [ "$(( total_len_9143 <= term_width_9144 ))" != 0 ]; then
        local iter_9147=0
        while :
        do
            local __length_286=("${items_9142[@]}")
            if [ "$(( iter_9147 >= ${#__length_286[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_9147 > 0 ))" != 0 ]; then
                eprintf_colored__1455_v0 "${separator_9145}" 90
            fi
            colored__1456_v0 "${items_9142[$(( iter_9147 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1456_v0__268_41="${ret_colored1456_v0}"
            local array_287=("")
            eprintf__1454_v0 "${items_9142[${iter_9147}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1456_v0__268_41}" array_287[@]
            iter_9147="$(( iter_9147 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_9150=0
        local first_9151=1
        local iter_9152=0
        while :
        do
            local __length_288=("${items_9142[@]}")
            if [ "$(( iter_9152 >= ${#__length_288[@]} ))" != 0 ]; then
                break
            fi
            local key_9153="${items_9142[${iter_9152}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_9154="${items_9142[$(( iter_9152 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_289="${key_9153}"
            local __length_290="${action_9154}"
            local part_len_9155="$(( $(( ${#__length_289} + 1 )) + ${#__length_290} ))"
            local needed_9156="${part_len_9155}"
            if [ "$(( ! first_9151 ))" != 0 ]; then
                needed_9156="$(( needed_9156 + separator_len_9146 ))"
            fi
            if [ "$(( $(( current_len_9150 + needed_9156 )) > term_width_9144 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_9151 ))" != 0 ]; then
                eprintf_colored__1455_v0 "${separator_9145}" 90
            fi
            colored__1456_v0 "${action_9154}" 2
            local ret_colored1456_v0__296_33="${ret_colored1456_v0}"
            local array_291=("")
            eprintf__1454_v0 "${key_9153}"" ""${ret_colored1456_v0__296_33}" array_291[@]
            current_len_9150="$(( current_len_9150 + needed_9156 ))"
            first_9151=0
            iter_9152="$(( iter_9152 + 2 ))"
        done
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1524_v0() {
    local selected_9111="${1}"
    local term_width_9112="${2}"
    local small_9113="$(( term_width_9112 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_9113}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_9132="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_9113}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_9133="${ret_cpad29_v0}"
    local gap_9134
    gap_9134="$(if [ "${small_9113}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_292=("")
    eprintf__1454_v0 " " array_292[@]
    if [ "${selected_9111}" != 0 ]; then
        # Yes selected
        background_secondary__1440_v0 "${yes_label_9132}"
        local ret_background_secondary1440_v0__16_30="${ret_background_secondary1440_v0}"
        local array_293=("")
        eprintf__1454_v0 "\\x1b[97m""${ret_background_secondary1440_v0__16_30}" array_293[@]
        local array_294=("")
        eprintf__1454_v0 "${gap_9134}" array_294[@]
        # No not selected (dim)
        local array_295=("")
        eprintf__1454_v0 "\\x1b[49;37m""${no_label_9133}""\\x1b[0m" array_295[@]
    else
        # No selected
        local array_296=("")
        eprintf__1454_v0 "\\x1b[49;37m""${yes_label_9132}""\\x1b[0m" array_296[@]
        local array_297=("")
        eprintf__1454_v0 "${gap_9134}" array_297[@]
        background_secondary__1440_v0 "${no_label_9133}"
        local ret_background_secondary1440_v0__24_30="${ret_background_secondary1440_v0}"
        local array_298=("")
        eprintf__1454_v0 "\\x1b[97m""${ret_background_secondary1440_v0__24_30}" array_298[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1525_v0() {
    local header_9066="${1}"
    local default_yes_9067="${2}"
    stty_lock__1413_v0 
    hide_cursor__1465_v0 
    term_width__1420_v0 
    local term_width_9075="${ret_term_width1420_v0}"
    if [ "$([ "_${header_9066}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1474_v0 "${header_9066}" "${term_width_9075}"
        local ret_cutoff_text1474_v0__46_17="${ret_cutoff_text1474_v0}"
        local array_299=("")
        eprintf__1454_v0 "${ret_cutoff_text1474_v0__46_17}""

" array_299[@]
    fi
    local selected_9110="${default_yes_9067}"
    # Render initial options
    render_confirm_options__1524_v0 "${selected_9110}" "${term_width_9075}"
    local array_300=("")
    eprintf__1454_v0 "

" array_300[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_301=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1475_v0 array_301[@] 40 "${term_width_9075}"
    go_up__1462_v0 2
    while :
    do
        get_key__1452_v0 
        local key_9159="${ret_get_key1452_v0}"
        if [ "$(( $(( $(( $([ "_${key_9159}" != "_LEFT" ]; echo $?) || $([ "_${key_9159}" != "_h" ]; echo $?) )) || $([ "_${key_9159}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_9159}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_9110}" != 0 ]; then
                selected_9110=0
                local array_302=("")
                eprintf__1454_v0 "\\x1b[G\\x1b[K" array_302[@]
                render_confirm_options__1524_v0 "${selected_9110}" "${term_width_9075}"
            elif [ "$(( ! selected_9110 ))" != 0 ]; then
                selected_9110=1
                local array_303=("")
                eprintf__1454_v0 "\\x1b[G\\x1b[K" array_303[@]
                render_confirm_options__1524_v0 "${selected_9110}" "${term_width_9075}"
            fi
        elif [ "$(( $([ "_${key_9159}" != "_y" ]; echo $?) || $([ "_${key_9159}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_9110=1
            break
        elif [ "$(( $([ "_${key_9159}" != "_n" ]; echo $?) || $([ "_${key_9159}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_9110=0
            break
        elif [ "$([ "_${key_9159}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_9160=4
    if [ "$([ "_${header_9066}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_9160="$(( total_lines_9160 + 1 ))"
    fi
    go_down__1463_v0 2
    remove_line__1458_v0 "$(( total_lines_9160 - 1 ))"
    remove_current_line__1459_v0 
    stty_unlock__1414_v0 
    show_cursor__1466_v0 
    ret_xyl_confirm1525_v0="${selected_9110}"
    return 0
}

# print_confirm_help()
print_confirm_help__1617_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    printf '%s\n' ""
    colored_primary__1436_v0 "confirm"
    local ret_colored_primary1436_v0__7_12="${ret_colored_primary1436_v0}"
    local array_304=()
    printf__128_v1 "${ret_colored_primary1436_v0__7_12}" array_304[@]
    local array_305=()
    printf__128_v1 " - Display a Yes/No confirmation dialog." array_305[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1437_v0 "Flags: "
    local ret_colored_secondary1437_v0__11_12="${ret_colored_secondary1437_v0}"
    local array_306=()
    printf__128_v1 "${ret_colored_secondary1437_v0__11_12}""
" array_306[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1667_v0() {
    local parameters_9038=("${!1}")
    colored_primary__1436_v0 "Are you sure?"
    local ret_colored_primary1436_v0__9_30="${ret_colored_primary1436_v0}"
    local header_9053="\\x1b[1m""${ret_colored_primary1436_v0__9_30}"
    local default_yes_9054=1
    for param_9055 in "${parameters_9038[@]}"; do
        starts_with__22_v0 "${param_9055}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_9055}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_9055}" != "_-h" ]; echo $?) || $([ "_${param_9055}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1617_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_309="--header="
            slice__24_v0 "${param_9055}" "${#__length_309}" 0
            header_9053="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_310="--default="
            slice__24_v0 "${param_9055}" "${#__length_310}" 0
            local value_9057="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_9057}" != "_yes" ]; echo $?) || $([ "_${value_9057}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_9054=1
            elif [ "$(( $([ "_${value_9057}" != "_no" ]; echo $?) || $([ "_${value_9057}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_9054=0
            else
                eprintf_colored__1455_v0 "ERROR: Invalid default value: ""${value_9057}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1467_v0 "${header_9053}"
    local ret_has_ansi_escape1467_v0__35_44="${ret_has_ansi_escape1467_v0}"
    escape_ansi__1468_v0 "${header_9053}"
    local ret_escape_ansi1468_v0__35_73="${ret_escape_ansi1468_v0}"
    colored_primary__1436_v0 "${header_9053}"
    local ret_colored_primary1436_v0__35_111="${ret_colored_primary1436_v0}"
    local display_header_9065
    display_header_9065="$(if [ "$(( $([ "_${header_9053}" != "_" ]; echo $?) || ret_has_ansi_escape1467_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1468_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1436_v0__35_111}"; fi)"
    xyl_confirm__1525_v0 "${display_header_9065}" "${default_yes_9054}"
    local result_9167="${ret_xyl_confirm1525_v0}"
    ret_execute_confirm1667_v0="$(if [ "${result_9167}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# get_directory_entries(path: Text, names: [Text], types: [Text], targets: [Text])
get_directory_entries__1823_v0() {
    local path_12900="${1}"
    local -n names_12901="${2}"
    local -n types_12902="${3}"
    local -n targets_12903="${4}"
    local __ls_path_311="${path_12900}"
    __ls_path_311="${__ls_path_311//\\/\\\\}"
    (( 1 )) && __ls_all_311="-A" || __ls_all_311=""
    (( 0 )) && __ls_rec_311="-R" || __ls_rec_311=""
    local __ls_311=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_311 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_311} ${__ls_rec_311} ${__ls_path_311}
    __status=$?
    );
    names_12901+=("${__ls_311[@]}")
    local command_312
    command_312="$(LC_ALL=C ls -lA "${path_12900}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_12904="${command_312}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_313
    command_313="$(LC_ALL=C ls -lA "${path_12900}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_12905="${command_313}"
    split__4_v0 "${types_output_12904}" "
"
    types_12902+=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_12905}" "
"
    local ret_split4_v0__21_19=("${ret_split4_v0[@]}")
    for marked_12906 in "${ret_split4_v0__21_19[@]}"; do
        slice__24_v0 "${marked_12906}" 1 0
        local ret_slice24_v0__22_21="${ret_slice24_v0}"
        targets_12903+=("${ret_slice24_v0__22_21}")
    done
}

# get_cwd()
get_cwd__1824_v0() {
    local command_317
    command_317="$(pwd)"
    __status=$?
    ret_get_cwd1824_v0="${command_317}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1825_v0() {
    local path_12895="${1}"
    local command_318
    command_318="$(cd "${path_12895}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_12896="${command_318}"
    if [ "$([ "_${normalized_12896}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1825_v0="${path_12895}"
        return 0
    fi
    ret_normalize_path1825_v0="${normalized_12896}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1826_v0() {
    local base_13060="${1}"
    local child_13061="${2}"
    if [ "$([ "_${base_13060}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1826_v0="/""${child_13061}"
        return 0
    fi
    ret_path_join1826_v0="${base_13060}""/""${child_13061}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1827_v0() {
    local path_13058="${1}"
    local command_319
    command_319="$(dirname "${path_13058}")"
    __status=$?
    local parent_13059="${command_319}"
    ret_get_parent_dir1827_v0="${parent_13059}"
    return 0
}

# Perl Extensions Utilities
command_320="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_39="$([ "_${command_320}" != "_No" ]; echo $?)"
command_321="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_40="$(( $(( ! _perl_disabled_39 )) && $([ "_${command_321}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1843_v0() {
    local command_323
    command_323="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_12892="${command_323}"
    parse_int__13_v0 "${count_12892}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_12893="${ret_parse_int13_v0}"
    if [ "$(( count_num_12893 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_12893="$(( count_num_12893 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_12893}
    __status=$?
}

# stty_unlock()
stty_unlock__1844_v0() {
    local command_324
    command_324="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_12917="${command_324}"
    parse_int__13_v0 "${count_12917}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_12918="${ret_parse_int13_v0}"
    if [ "$(( count_num_12918 > 0 ))" != 0 ]; then
        count_num_12918="$(( count_num_12918 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_12918}
        __status=$?
        if [ "$(( count_num_12918 == 0 ))" != 0 ]; then
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
get_supports_truecolor__1861_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_12880="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_12880}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1861_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1861_v0=0
        return 0
    fi
    local colorterm_12881="${ret_env_var_get120_v0}"
    _supports_truecolor_43="$(if [ "$(( $([ "_${colorterm_12881}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_12881}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1861_v0="$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1862_v0() {
    local message_12875="${1}"
    local r_12876="${2}"
    local g_12877="${3}"
    local b_12878="${4}"
    local fallback_12879="${5}"
    if [ "$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1862_v0="\\x1b[38;2;${r_12876};${g_12877};${b_12878}m""${message_12875}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_43}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1861_v0 
        local ret_get_supports_truecolor1861_v0__50_17="${ret_get_supports_truecolor1861_v0}"
        if [ "${ret_get_supports_truecolor1861_v0__50_17}" != 0 ]; then
            ret_colored_rgb1862_v0="\\x1b[38;2;${r_12876};${g_12877};${b_12878}m""${message_12875}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_12879 == 0 ))" != 0 ]; then
            ret_colored_rgb1862_v0="${message_12875}"
            return 0
        else
            ret_colored_rgb1862_v0="\\x1b[${fallback_12879}m""${message_12875}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_12879 == 0 ))" != 0 ]; then
            ret_colored_rgb1862_v0="${message_12875}"
            return 0
        fi
        ret_colored_rgb1862_v0="\\x1b[${fallback_12879}m""${message_12875}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1864_v0() {
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_12869="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_12869}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_12869}" ";"
            local parts_12870=("${ret_split4_v0[@]}")
            local __length_328=("${parts_12870[@]}")
            if [ "$(( ${#__length_328[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_12870[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12870[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12870[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12870[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
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
        local secondary_env_12871="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_12871}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_12871}" ";"
            local parts_12872=("${ret_split4_v0[@]}")
            local __length_330=("${parts_12872[@]}")
            if [ "$(( ${#__length_330[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_12872[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12872[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12872[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12872[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
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
        local accent_env_12873="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_12873}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_12873}" ";"
            local parts_12874=("${ret_split4_v0[@]}")
            local __length_332=("${parts_12874[@]}")
            if [ "$(( ${#__length_332[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_12874[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12874[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12874[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_12874[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1864_v0=''
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
get_xylitol_colors__1865_v0() {
    inner_get_xylitol_colors__1864_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_44=1
}

# colored_primary(message: Text)
colored_primary__1866_v0() {
    local message_12868="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1865_v0 
    fi
    colored_rgb__1862_v0 "${message_12868}" "${_primary_color_45[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_45[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_45[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_45[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1866_v0="${ret_colored_rgb1862_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1867_v0() {
    local message_12882="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1865_v0 
    fi
    colored_rgb__1862_v0 "${message_12882}" "${_secondary_color_46[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_46[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_46[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_46[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1867_v0="${ret_colored_rgb1862_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__1868_v0() {
    local message_12916="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1865_v0 
    fi
    colored_rgb__1862_v0 "${message_12916}" "${_accent_color_47[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_47[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_47[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_47[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent1868_v0="${ret_colored_rgb1862_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__1884_v0() {
    local format_12886="${1}"
    local args_12887=("${!2}")
    args_12887=("${format_12886}" "${args_12887[@]}")
    __status=$?
    printf "${args_12887[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1885_v0() {
    local message_12884="${1}"
    local color_12885="${2}"
    # Prints an error message with a specified color.
    local array_334=("${message_12884}")
    eprintf__1884_v0 "\\x1b[${color_12885}m%s\\x1b[0m" array_334[@]
}

# remove_current_line()
remove_current_line__1889_v0() {
    local array_335=("")
    eprintf__1884_v0 "\\x1b[2K\\x1b[G" array_335[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_336="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_48="$([ "_${command_336}" != "_No" ]; echo $?)"
command_337="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_49="$(( $(( ! _perl_disabled_48 )) && $([ "_${command_337}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2054_v0() {
    local text_12946="${1}"
    if [ "$(( ! _perl_available_49 ))" != 0 ]; then
        ret_perl_get_cjk_width2054_v0=''
        return 1
    fi
    local command_338
    command_338="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_12946}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2054_v0=''
        return "${__status}"
    fi
    local width_str_12947="${command_338}"
    parse_int__13_v0 "${width_str_12947}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2054_v0=''
        return "${__status}"
    fi
    local width_12948="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2054_v0="${width_12948}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2055_v0() {
    local text_12957="${1}"
    local max_width_12958="${2}"
    if [ "$(( ! _perl_available_49 ))" != 0 ]; then
        ret_perl_truncate_cjk2055_v0=''
        return 1
    fi
    local command_339
    command_339="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_12957}" ${max_width_12958} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2055_v0=''
        return "${__status}"
    fi
    local result_12959="${command_339}"
    ret_perl_truncate_cjk2055_v0="${result_12959}"
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
stty_lock__2062_v0() {
    local command_341
    command_341="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_12929="${command_341}"
    parse_int__13_v0 "${count_12929}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_12930="${ret_parse_int13_v0}"
    if [ "$(( count_num_12930 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_12930="$(( count_num_12930 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_12930}
    __status=$?
}

# stty_unlock()
stty_unlock__2063_v0() {
    local command_342
    command_342="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13047="${command_342}"
    parse_int__13_v0 "${count_13047}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13048="${ret_parse_int13_v0}"
    if [ "$(( count_num_13048 > 0 ))" != 0 ]; then
        count_num_13048="$(( count_num_13048 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13048}
        __status=$?
        if [ "$(( count_num_13048 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2064_v0() {
    local size_12932="${1}"
    if [ "$([ "_${size_12932}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2064_v0=0
        return 0
    fi
    split__4_v0 "${size_12932}" " "
    local parts_12933=("${ret_split4_v0[@]}")
    local __length_343=("${parts_12933[@]}")
    if [ "$(( ${#__length_343[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2064_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_12933[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:45:41)"}"
    __status=$?
    local ret_parse_int13_v0__45_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_12933[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:45:68)"}"
    __status=$?
    local ret_parse_int13_v0__45_52="${ret_parse_int13_v0}"
    _term_size_51=("${ret_parse_int13_v0__45_25}" "${ret_parse_int13_v0__45_52}")
    ret_store_term_size2064_v0=1
    return 0
}

# query_term_size()
query_term_size__2065_v0() {
    local command_345
    command_345="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_12935="${command_345}"
    store_term_size__2064_v0 "${size_12935}"
    ret_query_term_size2065_v0="${ret_store_term_size2064_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2066_v0() {
    local command_346
    command_346="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_12931="${command_346}"
    store_term_size__2064_v0 "${size_12931}"
    ret_stty_term_size2066_v0="${ret_store_term_size2064_v0}"
    return 0
}

# get_term_size()
get_term_size__2067_v0() {
    stty_term_size__2066_v0 
    local detected_12934="${ret_stty_term_size2066_v0}"
    if [ "$(( ! detected_12934 ))" != 0 ]; then
        query_term_size__2065_v0 
        detected_12934="${ret_query_term_size2065_v0}"
    fi
    _got_term_size_50=1
}

# term_width()
term_width__2069_v0() {
    if [ "$(( ! _got_term_size_50 ))" != 0 ]; then
        get_term_size__2067_v0 
    fi
    ret_term_width2069_v0="${_term_size_51[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:88:23)"}"
    return 0
}

# term_height()
term_height__2070_v0() {
    if [ "$(( ! _got_term_size_50 ))" != 0 ]; then
        get_term_size__2067_v0 
    fi
    ret_term_height2070_v0="${_term_size_51[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
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
get_supports_truecolor__2080_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_13027="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_13027}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor2080_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor2080_v0=0
        return 0
    fi
    local colorterm_13028="${ret_env_var_get120_v0}"
    _supports_truecolor_52="$(if [ "$(( $([ "_${colorterm_13028}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_13028}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2080_v0="$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2081_v0() {
    local message_13022="${1}"
    local r_13023="${2}"
    local g_13024="${3}"
    local b_13025="${4}"
    local fallback_13026="${5}"
    if [ "$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2081_v0="\\x1b[38;2;${r_13023};${g_13024};${b_13025}m""${message_13022}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_52}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2080_v0 
        local ret_get_supports_truecolor2080_v0__50_17="${ret_get_supports_truecolor2080_v0}"
        if [ "${ret_get_supports_truecolor2080_v0__50_17}" != 0 ]; then
            ret_colored_rgb2081_v0="\\x1b[38;2;${r_13023};${g_13024};${b_13025}m""${message_13022}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_13026 == 0 ))" != 0 ]; then
            ret_colored_rgb2081_v0="${message_13022}"
            return 0
        else
            ret_colored_rgb2081_v0="\\x1b[${fallback_13026}m""${message_13022}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_13026 == 0 ))" != 0 ]; then
            ret_colored_rgb2081_v0="${message_13022}"
            return 0
        fi
        ret_colored_rgb2081_v0="\\x1b[${fallback_13026}m""${message_13022}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2083_v0() {
    if [ "$(( ! _got_xylitol_colors_53 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_13016="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_13016}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_13016}" ";"
            local parts_13017=("${ret_split4_v0[@]}")
            local __length_350=("${parts_13017[@]}")
            if [ "$(( ${#__length_350[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13017[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13017[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13017[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13017[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
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
        local secondary_env_13018="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_13018}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_13018}" ";"
            local parts_13019=("${ret_split4_v0[@]}")
            local __length_352=("${parts_13019[@]}")
            if [ "$(( ${#__length_352[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13019[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13019[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13019[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13019[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
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
        local accent_env_13020="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_13020}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_13020}" ";"
            local parts_13021=("${ret_split4_v0[@]}")
            local __length_354=("${parts_13021[@]}")
            if [ "$(( ${#__length_354[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13021[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13021[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13021[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13021[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2083_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_53=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2084_v0() {
    inner_get_xylitol_colors__2083_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_53=1
}

# colored_secondary(message: Text)
colored_secondary__2086_v0() {
    local message_13015="${1}"
    if [ "$(( ! _got_xylitol_colors_53 ))" != 0 ]; then
        get_xylitol_colors__2084_v0 
    fi
    colored_rgb__2081_v0 "${message_13015}" "${_secondary_color_55[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_55[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_55[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_55[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2086_v0="${ret_colored_rgb2081_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2101_v0() {
    local command_356
    command_356="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_13032="${command_356}"
    if [ "$([ "_${var_13032}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2101_v0="UP"
        return 0
    elif [ "$([ "_${var_13032}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2101_v0="DOWN"
        return 0
    elif [ "$([ "_${var_13032}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2101_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_13032}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2101_v0="LEFT"
        return 0
    elif [ "$([ "_${var_13032}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2101_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_13032}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2101_v0="INPUT"
        return 0
    else
        ret_get_key2101_v0="${var_13032}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2103_v0() {
    local format_12927="${1}"
    local args_12928=("${!2}")
    args_12928=("${format_12927}" "${args_12928[@]}")
    __status=$?
    printf "${args_12928[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2104_v0() {
    local message_12925="${1}"
    local color_12926="${2}"
    # Prints an error message with a specified color.
    local array_357=("${message_12925}")
    eprintf__2103_v0 "\\x1b[${color_12926}m%s\\x1b[0m" array_357[@]
}

# colored(message: Text, color: Int)
colored__2105_v0() {
    local message_12987="${1}"
    local color_12988="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2105_v0="\\x1b[${color_12988}m""${message_12987}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2107_v0() {
    local cnt_13038="${1}"
    if [ "$(( cnt_13038 > 0 ))" != 0 ]; then
        local sequence_13039=""
        local __range_start_13040=0
        local __range_end_13040="${cnt_13038}"
        local __dir_13040=$(( ${__range_start_13040} <= ${__range_end_13040} ? 1 : -1 ))
        for (( ____13040=${__range_start_13040}; ____13040 * ${__dir_13040} < ${__range_end_13040} * ${__dir_13040}; ____13040+=${__dir_13040} )); do
            sequence_13039+="\\x1b[2K\\x1b[1A"
done
        local array_358=("")
        eprintf__2103_v0 "${sequence_13039}" array_358[@]
    fi
    local array_359=("")
    eprintf__2103_v0 "\\x1b[G" array_359[@]
}

# remove_current_line()
remove_current_line__2108_v0() {
    local array_360=("")
    eprintf__2103_v0 "\\x1b[2K\\x1b[G" array_360[@]
}

# print_blank(cnt: Int)
print_blank__2109_v0() {
    local cnt_13029="${1}"
    printf '%*s' "${cnt_13029}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2110_v0() {
    local cnt_12979="${1}"
    local __range_start_12980=0
    local __range_end_12980="${cnt_12979}"
    local __dir_12980=$(( ${__range_start_12980} <= ${__range_end_12980} ? 1 : -1 ))
    for (( ____12980=${__range_start_12980}; ____12980 * ${__dir_12980} < ${__range_end_12980} * ${__dir_12980}; ____12980+=${__dir_12980} )); do
        local array_361=("")
        eprintf__2103_v0 "
" array_361[@]
done
}

# go_up(cnt: Int)
go_up__2111_v0() {
    local cnt_12996="${1}"
    local array_362=("")
    eprintf__2103_v0 "\\x1b[${cnt_12996}A" array_362[@]
}

# go_down(cnt: Int)
go_down__2112_v0() {
    local cnt_13045="${1}"
    local array_363=("")
    eprintf__2103_v0 "\\x1b[${cnt_13045}B" array_363[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2113_v0() {
    local cnt_13044="${1}"
    if [ "$(( cnt_13044 > 0 ))" != 0 ]; then
        go_down__2112_v0 "${cnt_13044}"
    else
        go_up__2111_v0 "$(( - cnt_13044 ))"
    fi
}

# hide_cursor()
hide_cursor__2114_v0() {
    local array_364=("")
    eprintf__2103_v0 "\\x1b[?25l" array_364[@]
}

# show_cursor()
show_cursor__2115_v0() {
    local array_365=("")
    eprintf__2103_v0 "\\x1b[?25h" array_365[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2116_v0() {
    local text_12952="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_366
    command_366="$([[ "${text_12952}" == *$'\x1b'* || "${text_12952}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_12953="${command_366}"
    ret_has_ansi_escape2116_v0="$([ "_${has_escape_12953}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2118_v0() {
    local text_12942="${1}"
    local command_367
    command_367="$(printf "%s" "${text_12942}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2118_v0="${command_367}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2119_v0() {
    local text_12944="${1}"
    local command_368
    command_368="$(printf "%s" "${text_12944}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_12945="${command_368}"
    ret_is_all_ascii2119_v0="$([ "_${result_12945}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2120_v0() {
    local text_12941="${1}"
    strip_ansi__2118_v0 "${text_12941}"
    local stripped_12943="${ret_strip_ansi2118_v0}"
    # Check if text is all ASCII
    is_all_ascii__2119_v0 "${stripped_12943}"
    local ret_is_all_ascii2119_v0__150_12="${ret_is_all_ascii2119_v0}"
    if [ "$(( ! ret_is_all_ascii2119_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2054_v0 "${stripped_12943}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_369="${stripped_12943}"
            ret_get_visible_len2120_v0="${#__length_369}"
            return 0
        fi
        ret_get_visible_len2120_v0="${ret_perl_get_cjk_width2054_v0}"
        return 0
    else
        local __length_370="${stripped_12943}"
        ret_get_visible_len2120_v0="${#__length_370}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2121_v0() {
    local text_12954="${1}"
    local max_width_12955="${2}"
    get_visible_len__2120_v0 "${text_12954}"
    local visible_len_12956="${ret_get_visible_len2120_v0}"
    if [ "$(( visible_len_12956 <= max_width_12955 ))" != 0 ]; then
        ret_truncate_text2121_v0="${text_12954}"
        return 0
    fi
    is_all_ascii__2119_v0 "${text_12954}"
    local ret_is_all_ascii2119_v0__167_12="${ret_is_all_ascii2119_v0}"
    if [ "$(( ! ret_is_all_ascii2119_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2055_v0 "${text_12954}" "${max_width_12955}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_12954}" | cut -c1-${max_width_12955}
            __status=$?
        fi
        ret_truncate_text2121_v0="${ret_perl_truncate_cjk2055_v0}"
        return 0
    fi
    local command_371
    command_371="$(printf "%s" "${text_12954}" | cut -c1-${max_width_12955})"
    __status=$?
    ret_truncate_text2121_v0="${command_371}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2122_v0() {
    local text_12950="${1}"
    local max_width_12951="${2}"
    has_ansi_escape__2116_v0 "${text_12950}"
    local ret_has_ansi_escape2116_v0__179_12="${ret_has_ansi_escape2116_v0}"
    if [ "$(( ! ret_has_ansi_escape2116_v0__179_12 ))" != 0 ]; then
        truncate_text__2121_v0 "${text_12950}" "${max_width_12951}"
        ret_truncate_ansi2122_v0="${ret_truncate_text2121_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_372
    command_372="$([[ "${text_12950}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_12960="${command_372}"
    # Replace \x1b[ with newline, then split
    local command_373
    command_373="$(t="${text_12950}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_12961="${command_373}"
    split__4_v0 "${replaced_12961}" "
"
    local parts_12962=("${ret_split4_v0[@]}")
    local result_12963=""
    local remaining_width_12964="${max_width_12951}"
    local __range_start_12965=0
    local __length_374=("${parts_12962[@]}")
    local __range_end_12965="${#__length_374[@]}"
    local __dir_12965=$(( ${__range_start_12965} <= ${__range_end_12965} ? 1 : -1 ))
    for (( idx_12965=${__range_start_12965}; idx_12965 * ${__dir_12965} < ${__range_end_12965} * ${__dir_12965}; idx_12965+=${__dir_12965} )); do
        local part_12966="${parts_12962[${idx_12965}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_12965 == 0 )) && $([ "_${starts_with_ansi_12960}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_12966}" == "_" ]; echo $?) && $(( remaining_width_12964 > 0 )) ))" != 0 ]; then
                truncate_text__2121_v0 "${part_12966}" "${remaining_width_12964}"
                local ret_truncate_text2121_v0__201_35="${ret_truncate_text2121_v0}"
                local truncated_12967="${ret_truncate_text2121_v0__201_35}"
                result_12963+="${truncated_12967}"
                get_visible_len__2120_v0 "${truncated_12967}"
                local ret_get_visible_len2120_v0__203_36="${ret_get_visible_len2120_v0}"
                remaining_width_12964="$(( remaining_width_12964 - ret_get_visible_len2120_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_375
            command_375="$(__p="${part_12966}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_12968="${command_375}"
            if [ "$([ "_${m_idx_12968}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_376
                command_376="$(__p="${part_12966}"; printf "%s" "${__p:0:${m_idx_12968}}")"
                __status=$?
                local ansi_params_12969="${command_376}"
                result_12963+="\\x1b[""${ansi_params_12969}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_12968}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_12970="${ret_parse_int13_v0__214_41}"
                local text_start_12971="$(( m_idx_num_12970 + 1 ))"
                local command_377
                command_377="$(__p="${part_12966}"; printf "%s" "${__p:${text_start_12971}}")"
                __status=$?
                local text_part_12972="${command_377}"
                if [ "$(( $([ "_${text_part_12972}" == "_" ]; echo $?) && $(( remaining_width_12964 > 0 )) ))" != 0 ]; then
                    truncate_text__2121_v0 "${text_part_12972}" "${remaining_width_12964}"
                    local ret_truncate_text2121_v0__218_39="${ret_truncate_text2121_v0}"
                    local truncated_12973="${ret_truncate_text2121_v0__218_39}"
                    result_12963+="${truncated_12973}"
                    get_visible_len__2120_v0 "${truncated_12973}"
                    local ret_get_visible_len2120_v0__220_40="${ret_get_visible_len2120_v0}"
                    remaining_width_12964="$(( remaining_width_12964 - ret_get_visible_len2120_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_12966}" == "_" ]; echo $?) && $(( remaining_width_12964 > 0 )) ))" != 0 ]; then
                    truncate_text__2121_v0 "${part_12966}" "${remaining_width_12964}"
                    local ret_truncate_text2121_v0__225_39="${ret_truncate_text2121_v0}"
                    local truncated_12974="${ret_truncate_text2121_v0__225_39}"
                    result_12963+="${truncated_12974}"
                    get_visible_len__2120_v0 "${truncated_12974}"
                    local ret_get_visible_len2120_v0__227_40="${ret_get_visible_len2120_v0}"
                    remaining_width_12964="$(( remaining_width_12964 - ret_get_visible_len2120_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2122_v0="${result_12963}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2123_v0() {
    local text_12939="${1}"
    local max_width_12940="${2}"
    get_visible_len__2120_v0 "${text_12939}"
    local visible_len_12949="${ret_get_visible_len2120_v0}"
    if [ "$(( visible_len_12949 <= max_width_12940 ))" != 0 ]; then
        ret_cutoff_text2123_v0="${text_12939}"
        return 0
    fi
    truncate_ansi__2122_v0 "${text_12939}" "$(( max_width_12940 - 3 ))"
    local ret_truncate_ansi2122_v0__243_12="${ret_truncate_ansi2122_v0}"
    ret_cutoff_text2123_v0="${ret_truncate_ansi2122_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2124_v0() {
    local items_12981=("${!1}")
    local total_len_12982="${2}"
    local term_width_12983="${3}"
    local separator_12984=" • "
    local separator_len_12985=3
    # Fast path: no truncation needed
    if [ "$(( total_len_12982 <= term_width_12983 ))" != 0 ]; then
        local iter_12986=0
        while :
        do
            local __length_378=("${items_12981[@]}")
            if [ "$(( iter_12986 >= ${#__length_378[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_12986 > 0 ))" != 0 ]; then
                eprintf_colored__2104_v0 "${separator_12984}" 90
            fi
            colored__2105_v0 "${items_12981[$(( iter_12986 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2105_v0__268_41="${ret_colored2105_v0}"
            local array_379=("")
            eprintf__2103_v0 "${items_12981[${iter_12986}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2105_v0__268_41}" array_379[@]
            iter_12986="$(( iter_12986 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_12989=0
        local first_12990=1
        local iter_12991=0
        while :
        do
            local __length_380=("${items_12981[@]}")
            if [ "$(( iter_12991 >= ${#__length_380[@]} ))" != 0 ]; then
                break
            fi
            local key_12992="${items_12981[${iter_12991}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_12993="${items_12981[$(( iter_12991 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_381="${key_12992}"
            local __length_382="${action_12993}"
            local part_len_12994="$(( $(( ${#__length_381} + 1 )) + ${#__length_382} ))"
            local needed_12995="${part_len_12994}"
            if [ "$(( ! first_12990 ))" != 0 ]; then
                needed_12995="$(( needed_12995 + separator_len_12985 ))"
            fi
            if [ "$(( $(( current_len_12989 + needed_12995 )) > term_width_12983 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_12990 ))" != 0 ]; then
                eprintf_colored__2104_v0 "${separator_12984}" 90
            fi
            colored__2105_v0 "${action_12993}" 2
            local ret_colored2105_v0__296_33="${ret_colored2105_v0}"
            local array_383=("")
            eprintf__2103_v0 "${key_12992}"" ""${ret_colored2105_v0__296_33}" array_383[@]
            current_len_12989="$(( current_len_12989 + needed_12995 ))"
            first_12990=0
            iter_12991="$(( iter_12991 + 2 ))"
        done
    fi
}

# get_page_options(options: [Text], total: Int, page: Int, page_size: Int)
get_page_options__2173_v0() {
    local -n options_12997="${1}"
    local total_12998="${2}"
    local page_12999="${3}"
    local page_size_13000="${4}"
    local start_13001="$(( page_12999 * page_size_13000 ))"
    local end_13002="$(( start_13001 + page_size_13000 ))"
    if [ "$(( end_13002 > total_12998 ))" != 0 ]; then
        end_13002="${total_12998}"
    fi
    local result_13003=()
    local __range_start_13004="${start_13001}"
    local __range_end_13004="${end_13002}"
    local __dir_13004=$(( ${__range_start_13004} <= ${__range_end_13004} ? 1 : -1 ))
    for (( i_13004=${__range_start_13004}; i_13004 * ${__dir_13004} < ${__range_end_13004} * ${__dir_13004}; i_13004+=${__dir_13004} )); do
        local array_385=("${options_12997[${i_13004}]?"Index out of bounds (at src/./file/../choose/mod.ab:16:28)"}")
        result_13003+=("${array_385[@]}")
done
    ret_get_page_options2173_v0=("${result_13003[@]}")
    return 0
}

# render_choose_page(page_options: [Text], sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_choose_page__2175_v0() {
    local page_options_13006=("${!1}")
    local sel_13007="${2}"
    local cursor_13008="${3}"
    local display_count_13009="${4}"
    local term_width_13010="${5}"
    local __length_386="${cursor_13008}"
    local cursor_len_13011="${#__length_386}"
    local max_option_width_13012="$(( $(( term_width_13010 - cursor_len_13011 )) - 1 ))"
    local __range_start_13013=0
    local __length_387=("${page_options_13006[@]}")
    local __range_end_13013="${#__length_387[@]}"
    local __dir_13013=$(( ${__range_start_13013} <= ${__range_end_13013} ? 1 : -1 ))
    for (( i_13013=${__range_start_13013}; i_13013 * ${__dir_13013} < ${__range_end_13013} * ${__dir_13013}; i_13013+=${__dir_13013} )); do
        cutoff_text__2123_v0 "${page_options_13006[${i_13013}]?"Index out of bounds (at src/./file/../choose/mod.ab:29:59)"}" "${max_option_width_13012}"
        local ret_cutoff_text2123_v0__29_34="${ret_cutoff_text2123_v0}"
        local truncated_option_13014="${ret_cutoff_text2123_v0__29_34}"
        if [ "$(( i_13013 == sel_13007 ))" != 0 ]; then
            colored_secondary__2086_v0 "${cursor_13008}""${truncated_option_13014}""
"
            local ret_colored_secondary2086_v0__31_21="${ret_colored_secondary2086_v0}"
            local array_388=("")
            eprintf__2103_v0 "${ret_colored_secondary2086_v0__31_21}" array_388[@]
        else
            print_blank__2109_v0 "${cursor_len_13011}"
            local array_389=("")
            eprintf__2103_v0 "${truncated_option_13014}""
" array_389[@]
        fi
done
    local __length_390=("${page_options_13006[@]}")
    local remaining_slots_13030="$(( display_count_13009 - ${#__length_390[@]} ))"
    if [ "$(( remaining_slots_13030 > 0 ))" != 0 ]; then
        # Amber bug gaurd
        local __range_start_13031=0
        local __range_end_13031="${remaining_slots_13030}"
        local __dir_13031=$(( ${__range_start_13031} <= ${__range_end_13031} ? 1 : -1 ))
        for (( ____13031=${__range_start_13031}; ____13031 * ${__dir_13031} < ${__range_end_13031} * ${__dir_13031}; ____13031+=${__dir_13031} )); do
            local array_391=("")
            eprintf__2103_v0 "\\x1b[K
" array_391[@]
done
    fi
}

# render_page_indicator(page: Int, total_pages: Int)
render_page_indicator__2177_v0() {
    local page_13041="${1}"
    local total_pages_13042="${2}"
    if [ "$(( total_pages_13042 > 1 ))" != 0 ]; then
        local array_392=("")
        eprintf__2103_v0 "\\x1b[G\\x1b[K" array_392[@]
        eprintf_colored__2104_v0 "Page $(( page_13041 + 1 ))/${total_pages_13042}" 90
        local array_393=("")
        eprintf__2103_v0 "\\x1b[G" array_393[@]
    fi
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__2178_v0() {
    local -n options_12920="${1}"
    local cursor_12921="${2}"
    local header_12922="${3}"
    local page_size_12923="${4}"
    # Counted once, see `get_page_options`.
    local __length_394=("${options_12920[@]}")
    local total_12924="${#__length_394[@]}"
    if [ "$(( total_12924 == 0 ))" != 0 ]; then
        eprintf_colored__2104_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__2062_v0 
    hide_cursor__2114_v0 
    term_width__2069_v0 
    local term_width_12936="${ret_term_width2069_v0}"
    term_height__2070_v0 
    local term_height_12937="${ret_term_height2070_v0}"
    local max_page_size_12938
    max_page_size_12938="$(( term_height_12937 - $(if [ "$([ "_${header_12922}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_12923 > max_page_size_12938 ))" != 0 ]; then
        page_size_12923="${max_page_size_12938}"
    fi
    if [ "$([ "_${header_12922}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2123_v0 "${header_12922}" "${term_width_12936}"
        local ret_cutoff_text2123_v0__112_17="${ret_cutoff_text2123_v0}"
        local array_395=("")
        eprintf__2103_v0 "${ret_cutoff_text2123_v0__112_17}""
" array_395[@]
    fi
    math_floor__501_v0 "$(( $(( $(( total_12924 + page_size_12923 )) - 1 )) / page_size_12923 ))"
    local total_pages_12975="${ret_math_floor501_v0}"
    local current_page_12976=0
    local selected_12977=0
    local display_count_12978="${page_size_12923}"
    if [ "$(( total_12924 < page_size_12923 ))" != 0 ]; then
        display_count_12978="${total_12924}"
    fi
    new_line__2110_v0 "${display_count_12978}"
    local array_396=("")
    eprintf__2103_v0 "\\x1b[G" array_396[@]
    if [ "$(( total_pages_12975 > 1 ))" != 0 ]; then
        eprintf_colored__2104_v0 "Page $(( current_page_12976 + 1 ))/${total_pages_12975}" 90
    fi
    new_line__2110_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( total_pages_12975 > 1 ))" != 0 ]; then
        local array_397=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__2124_v0 array_397[@] 36 "${term_width_12936}"
    else
        local array_398=("↑↓" "select" "enter" "confirm")
        render_tooltip__2124_v0 array_398[@] 25 "${term_width_12936}"
    fi
    go_up__2111_v0 "$(( display_count_12978 + 1 ))"
    local array_399=("")
    eprintf__2103_v0 "\\x1b[G" array_399[@]
    get_page_options__2173_v0 "${!options_12920}" "${total_12924}" "${current_page_12976}" "${page_size_12923}"
    local page_options_13005=("${ret_get_page_options2173_v0[@]}")
    render_choose_page__2175_v0 page_options_13005[@] "${selected_12977}" "${cursor_12921}" "${display_count_12978}" "${term_width_12936}"
    while :
    do
        get_key__2101_v0 
        local key_13033="${ret_get_key2101_v0}"
        local prev_selected_13034="${selected_12977}"
        local prev_page_13035="${current_page_12976}"
        local up_paged_13036=0
        if [ "$(( $([ "_${key_13033}" != "_UP" ]; echo $?) || $([ "_${key_13033}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_12977 == 0 )) && $(( total_pages_12975 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_12976 > 0 ))" != 0 ]; then
                    current_page_12976="$(( current_page_12976 - 1 ))"
                else
                    current_page_12976="$(( total_pages_12975 - 1 ))"
                fi
                up_paged_13036=1
            elif [ "$(( selected_12977 == 0 ))" != 0 ]; then
                local __length_400=("${page_options_13005[@]}")
                selected_12977="$(( ${#__length_400[@]} - 1 ))"
            else
                selected_12977="$(( selected_12977 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_13033}" != "_DOWN" ]; echo $?) || $([ "_${key_13033}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_401=("${page_options_13005[@]}")
            if [ "$(( selected_12977 == $(( ${#__length_401[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_12976 < $(( total_pages_12975 - 1 )) ))" != 0 ]; then
                    current_page_12976="$(( current_page_12976 + 1 ))"
                    selected_12977=0
                else
                    current_page_12976=0
                    selected_12977=0
                fi
            else
                selected_12977="$(( selected_12977 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_13033}" != "_LEFT" ]; echo $?) || $([ "_${key_13033}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_12976 > 0 ))" != 0 ]; then
                current_page_12976="$(( current_page_12976 - 1 ))"
                selected_12977=0
            else
                selected_12977=0
            fi
        elif [ "$(( $([ "_${key_13033}" != "_RIGHT" ]; echo $?) || $([ "_${key_13033}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_12976 < $(( total_pages_12975 - 1 )) ))" != 0 ]; then
                current_page_12976="$(( current_page_12976 + 1 ))"
                selected_12977=0
            else
                local __length_402=("${page_options_13005[@]}")
                selected_12977="$(( ${#__length_402[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_13033}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_403="${cursor_12921}"
        local max_option_width_13037="$(( $(( term_width_12936 - ${#__length_403} )) - 1 ))"
        if [ "$(( prev_page_13035 != current_page_12976 ))" != 0 ]; then
            get_page_options__2173_v0 "${!options_12920}" "${total_12924}" "${current_page_12976}" "${page_size_12923}"
            page_options_13005=("${ret_get_page_options2173_v0[@]}")
            if [ "${up_paged_13036}" != 0 ]; then
                local __length_404=("${page_options_13005[@]}")
                selected_12977="$(( ${#__length_404[@]} - 1 ))"
            fi
            go_up__2111_v0 1
            remove_line__2107_v0 "$(( display_count_12978 - 1 ))"
            remove_current_line__2108_v0 
            local array_405=("")
            eprintf__2103_v0 "\\x1b[G" array_405[@]
            render_choose_page__2175_v0 page_options_13005[@] "${selected_12977}" "${cursor_12921}" "${display_count_12978}" "${term_width_12936}"
            render_page_indicator__2177_v0 "${current_page_12976}" "${total_pages_12975}"
        elif [ "$(( prev_selected_13034 != selected_12977 ))" != 0 ]; then
            go_up__2111_v0 "$(( display_count_12978 - prev_selected_13034 ))"
            local array_406=("")
            eprintf__2103_v0 "\\x1b[K" array_406[@]
            local __length_407="${cursor_12921}"
            print_blank__2109_v0 "${#__length_407}"
            cutoff_text__2123_v0 "${page_options_13005[${prev_selected_13034}]?"Index out of bounds (at src/./file/../choose/mod.ab:223:50)"}" "${max_option_width_13037}"
            local ret_cutoff_text2123_v0__223_25="${ret_cutoff_text2123_v0}"
            local array_408=("")
            eprintf__2103_v0 "${ret_cutoff_text2123_v0__223_25}" array_408[@]
            local diff_13043="$(( selected_12977 - prev_selected_13034 ))"
            go_up_or_down__2113_v0 "${diff_13043}"
            local array_409=("")
            eprintf__2103_v0 "\\x1b[G" array_409[@]
            local array_410=("")
            eprintf__2103_v0 "\\x1b[K" array_410[@]
            cutoff_text__2123_v0 "${page_options_13005[${selected_12977}]?"Index out of bounds (at src/./file/../choose/mod.ab:229:77)"}" "${max_option_width_13037}"
            local ret_cutoff_text2123_v0__229_52="${ret_cutoff_text2123_v0}"
            colored_secondary__2086_v0 "${cursor_12921}""${ret_cutoff_text2123_v0__229_52}"
            local ret_colored_secondary2086_v0__229_25="${ret_colored_secondary2086_v0}"
            local array_411=("")
            eprintf__2103_v0 "${ret_colored_secondary2086_v0__229_25}" array_411[@]
            go_down__2112_v0 "$(( display_count_12978 - selected_12977 ))"
            local array_412=("")
            eprintf__2103_v0 "\\x1b[G" array_412[@]
        fi
    done
    local total_lines_13046="$(( display_count_12978 + 2 ))"
    if [ "$([ "_${header_12922}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_13046="$(( total_lines_13046 + 1 ))"
    fi
    go_down__2112_v0 1
    remove_line__2107_v0 "$(( total_lines_13046 - 1 ))"
    remove_current_line__2108_v0 
    stty_unlock__2063_v0 
    show_cursor__2115_v0 
    local global_selected_13049="$(( $(( current_page_12976 * page_size_12923 )) + selected_12977 ))"
    ret_xyl_choose2178_v0="${options_12920[${global_selected_13049}]?"Index out of bounds (at src/./file/../choose/mod.ab:249:20)"}"
    return 0
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2182_v0() {
    local name_12913="${1}"
    local file_type_12914="${2}"
    local target_12915="${3}"
    if [ "$([ "_${file_type_12914}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1866_v0 "/"
        local ret_colored_primary1866_v0__11_23="${ret_colored_primary1866_v0}"
        ret_format_entry_display2182_v0="${name_12913}""${ret_colored_primary1866_v0__11_23}"
        return 0
    fi
    if [ "$([ "_${file_type_12914}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1868_v0 " > "
        local ret_colored_accent1868_v0__14_23="${ret_colored_accent1868_v0}"
        colored_primary__1866_v0 "${target_12915}"
        local ret_colored_primary1866_v0__14_47="${ret_colored_primary1866_v0}"
        ret_format_entry_display2182_v0="${name_12913}""${ret_colored_accent1868_v0__14_23}""${ret_colored_primary1866_v0__14_47}"
        return 0
    fi
    ret_format_entry_display2182_v0="${name_12913}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2183_v0() {
    local start_path_12888="${1}"
    local cursor_12889="${2}"
    local show_hidden_12890="${3}"
    local page_size_12891="${4}"
    stty_lock__1843_v0 
    # Initialize current path
    local current_path_12894="${start_path_12888}"
    if [ "$([ "_${current_path_12894}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1824_v0 
        current_path_12894="${ret_get_cwd1824_v0}"
    fi
    normalize_path__1825_v0 "${current_path_12894}"
    current_path_12894="${ret_normalize_path1825_v0}"
    while :
    do
        colored_primary__1866_v0 "Loading files..."
        local ret_colored_primary1866_v0__42_17="${ret_colored_primary1866_v0}"
        local array_413=("")
        eprintf__1884_v0 "${ret_colored_primary1866_v0__42_17}" array_413[@]
        # Get directory entries
        local listed_names_12897=()
        local listed_types_12898=()
        local listed_targets_12899=()
        get_directory_entries__1823_v0 "${current_path_12894}" "listed_names_12897" "listed_types_12898" "listed_targets_12899"
        # Build options list and parallel entry lists
        local options_12907=()
        local names_12908=()
        local types_12909=()
        local targets_12910=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_12894}" == "_/" ]; echo $?)" != 0 ]; then
            options_12907+=("..")
            names_12908+=("..")
            types_12909+=("d")
            targets_12910+=("")
        fi
        local __range_start_12911=0
        local __length_425=("${listed_names_12897[@]}")
        local __range_end_12911="${#__length_425[@]}"
        local __dir_12911=$(( ${__range_start_12911} <= ${__range_end_12911} ? 1 : -1 ))
        for (( i_12911=${__range_start_12911}; i_12911 * ${__dir_12911} < ${__range_end_12911} * ${__dir_12911}; i_12911+=${__dir_12911} )); do
            local name_12912="${listed_names_12897[${i_12911}]?"Index out of bounds (at src/./file/./mod.ab:65:39)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_12912}" "."
            local ret_starts_with22_v0__67_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_12890 )) && ret_starts_with22_v0__67_36 ))" != 0 ]; then
                continue
            fi
            format_entry_display__2182_v0 "${name_12912}" "${listed_types_12898[${i_12911}]?"Index out of bounds (at src/./file/./mod.ab:70:65)"}" "${listed_targets_12899[${i_12911}]?"Index out of bounds (at src/./file/./mod.ab:70:84)"}"
            local ret_format_entry_display2182_v0__70_25="${ret_format_entry_display2182_v0}"
            local array_426=("${ret_format_entry_display2182_v0__70_25}")
            options_12907+=("${array_426[@]}")
            local array_427=("${name_12912}")
            names_12908+=("${array_427[@]}")
            local array_428=("${listed_types_12898[${i_12911}]?"Index out of bounds (at src/./file/./mod.ab:72:36)"}")
            types_12909+=("${array_428[@]}")
            local array_429=("${listed_targets_12899[${i_12911}]?"Index out of bounds (at src/./file/./mod.ab:73:40)"}")
            targets_12910+=("${array_429[@]}")
done
        local __length_430=("${names_12908[@]}")
        if [ "$(( ${#__length_430[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1885_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1844_v0 
            ret_xyl_file2183_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1866_v0 "${current_path_12894}"
        local header_12919="${ret_colored_primary1866_v0}"
        remove_current_line__1889_v0 
        xyl_choose__2178_v0 "options_12907" "${cursor_12889}" "${header_12919}" "${page_size_12891}"
        local selected_option_13050="${ret_xyl_choose2178_v0}"
        # Find selected entry index
        array_find__67_v0 options_12907[@] "${selected_option_13050}"
        local selected_idx_13055="${ret_array_find67_v0}"
        if [ "$(( selected_idx_13055 < 0 ))" != 0 ]; then
            ret_xyl_file2183_v0=""
            return 0
        fi
        local name_13056="${names_12908[${selected_idx_13055}]?"Index out of bounds (at src/./file/./mod.ab:95:28)"}"
        local file_type_13057="${types_12909[${selected_idx_13055}]?"Index out of bounds (at src/./file/./mod.ab:96:33)"}"
        if [ "$([ "_${name_13056}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1827_v0 "${current_path_12894}"
            current_path_12894="${ret_get_parent_dir1827_v0}"
        elif [ "$([ "_${file_type_13057}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1826_v0 "${current_path_12894}" "${name_13056}"
            current_path_12894="${ret_path_join1826_v0}"
            normalize_path__1825_v0 "${current_path_12894}"
            current_path_12894="${ret_normalize_path1825_v0}"
        elif [ "$([ "_${file_type_13057}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_13062="${targets_12910[${selected_idx_13055}]?"Index out of bounds (at src/./file/./mod.ab:108:40)"}"
            local target_path_13063="${target_13062}"
            starts_with__22_v0 "${target_13062}" "/"
            local ret_starts_with22_v0__110_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__110_24 ))" != 0 ]; then
                path_join__1826_v0 "${current_path_12894}" "${target_13062}"
                target_path_13063="${ret_path_join1826_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_13063}"
            local ret_dir_exists38_v0__114_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__114_20}" != 0 ]; then
                current_path_12894="${target_path_13063}"
                normalize_path__1825_v0 "${current_path_12894}"
                current_path_12894="${ret_normalize_path1825_v0}"
            else
                stty_unlock__1844_v0 
                path_join__1826_v0 "${current_path_12894}" "${name_13056}"
                ret_xyl_file2183_v0="${ret_path_join1826_v0}"
                return 0
            fi
        else
            stty_unlock__1844_v0 
            path_join__1826_v0 "${current_path_12894}" "${name_13056}"
            ret_xyl_file2183_v0="${ret_path_join1826_v0}"
            return 0
        fi
    done
    stty_unlock__1844_v0 
    ret_xyl_file2183_v0=""
    return 0
}

# print_file_help()
print_file_help__2275_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    printf '%s\n' ""
    colored_primary__1866_v0 "file"
    local ret_colored_primary1866_v0__7_12="${ret_colored_primary1866_v0}"
    local array_431=()
    printf__128_v1 "${ret_colored_primary1866_v0__7_12}" array_431[@]
    local array_432=()
    printf__128_v1 " - Browse filesystem and select a file." array_432[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1867_v0 "Arguments: "
    local ret_colored_secondary1867_v0__11_12="${ret_colored_secondary1867_v0}"
    local array_433=()
    printf__128_v1 "${ret_colored_secondary1867_v0__11_12}""
" array_433[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    printf '%s\n' ""
    colored_secondary__1867_v0 "Flags: "
    local ret_colored_secondary1867_v0__14_12="${ret_colored_secondary1867_v0}"
    local array_434=()
    printf__128_v1 "${ret_colored_secondary1867_v0__14_12}""
" array_434[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2325_v0() {
    local parameters_12862=("${!1}")
    local cursor_12863="> "
    local start_path_12864=""
    local show_hidden_12865=0
    local page_size_12866=10
    local __length_438=("${parameters_12862[@]}")
    local slice_upper_437="${#__length_438[@]}"
    local slice_offset_439=2
    local slice_offset_439=$((${slice_offset_439} > 0 ? ${slice_offset_439} : 0))
    local slice_length_440="$(( slice_upper_437 - slice_offset_439 ))"
    local slice_length_440=$((${slice_length_440} > 0 ? ${slice_length_440} : 0))
    for param_12867 in "${parameters_12862[@]:${slice_offset_439}:${slice_length_440}}"; do
        starts_with__22_v0 "${param_12867}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_12867}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_12867}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_12867}" != "_-h" ]; echo $?) || $([ "_${param_12867}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2275_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_441="--cursor="
            slice__24_v0 "${param_12867}" "${#__length_441}" 0
            cursor_12863="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_442="--path="
            slice__24_v0 "${param_12867}" "${#__length_442}" 0
            start_path_12864="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_12867}" != "_-a" ]; echo $?) || $([ "_${param_12867}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_12865=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_443="--page-size="
            slice__24_v0 "${param_12867}" "${#__length_443}" 0
            local value_12883="${ret_slice24_v0}"
            parse_int__13_v0 "${value_12883}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1885_v0 "ERROR: Invalid page-size value: ""${value_12883}""
" 31
                exit 1
            fi
            page_size_12866="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_12864="${param_12867}"
        fi
    done
    xyl_file__2183_v0 "${start_path_12864}" "${cursor_12863}" "${show_hidden_12865}" "${page_size_12866}"
    ret_execute_file2325_v0="${ret_xyl_file2183_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_57="0.1.0"
__AMBER_VERSION_58="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2327_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__260_v0 "Error: " 91
        local array_444=("")
        eprintf__259_v0 "bc is not installed. Please install bc to use xylitol.
" array_444[@]
        local array_445=("")
        eprintf__259_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_445[@]
        local array_446=("")
        eprintf__259_v0 "  For Fedora: sudo dnf install bc
" array_446[@]
        local array_447=("")
        eprintf__259_v0 "  For Arch Linux: sudo pacman -S bc
" array_447[@]
        ret_check_prerequirements2327_v0=0
        return 0
    fi
    ret_check_prerequirements2327_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2328_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_59=("$0" "$@")
trap_cleanup__2328_v0 
check_prerequirements__2327_v0 
ret_check_prerequirements2327_v0__32_12="${ret_check_prerequirements2327_v0}"
if [ "$(( ! ret_check_prerequirements2327_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_449=("${args_59[@]}")
if [ "$(( ${#__length_449[@]} < 2 ))" != 0 ]; then
    print_help__420_v0 
    exit 0
fi
command_664="${args_59[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_664}" != "_help" ]; echo $?) || $([ "_${command_664}" != "_--help" ]; echo $?) )) || $([ "_${command_664}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__420_v0 
elif [ "$([ "_${command_664}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__823_v0 args_59[@]
    ret_execute_input823_v0__48_18="${ret_execute_input823_v0}"
    printf '%s\n' "${ret_execute_input823_v0__48_18}"
elif [ "$([ "_${command_664}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1230_v0 args_59[@]
    ret_execute_choose1230_v0__51_18="${ret_execute_choose1230_v0}"
    printf '%s\n' "${ret_execute_choose1230_v0__51_18}"
elif [ "$([ "_${command_664}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1667_v0 args_59[@]
    result_9168="${ret_execute_confirm1667_v0}"
    if [ "$([ "_${result_9168}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_664}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2325_v0 args_59[@]
    ret_execute_file2325_v0__61_18="${ret_execute_file2325_v0}"
    printf '%s\n' "${ret_execute_file2325_v0__61_18}"
elif [ "$(( $(( $([ "_${command_664}" != "_version" ]; echo $?) || $([ "_${command_664}" != "_--version" ]; echo $?) )) || $([ "_${command_664}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__241_v0 "xylitol.sh"
    ret_colored_primary241_v0__64_20="${ret_colored_primary241_v0}"
    array_450=()
    printf__128_v1 "${ret_colored_primary241_v0__64_20}" array_450[@]
    array_451=()
    printf__128_v1 " version: " array_451[@]
    colored_accent__243_v0 "${__VERSION_57}"
    ret_colored_accent243_v0__66_20="${ret_colored_accent243_v0}"
    array_452=()
    printf__128_v1 "${ret_colored_accent243_v0__66_20}" array_452[@]
    printf '%s\n' ""
    printf_colored__258_v0 "written in Amber: " 90
    printf_colored__258_v0 "  ""${__AMBER_VERSION_58}" 90
else
    print_help__420_v0 
    printf_colored__258_v0 "ERROR: Unknown command '""${command_664}""'" 91
fi
