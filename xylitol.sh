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
    local text_1347="${1}"
    local delimiter_1348="${2}"
    local result_1349=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1348}" read -rd '' -A result_1349 < <(printf %s "$text_1347")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1348}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1349+=("$REPLY"); done < <(echo "$text_1347")
            __status=$?
        else
            IFS="${delimiter_1348}" read -rd '' -a result_1349 < <(printf %s "$text_1347")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1348}" read -rd '' -a result_1349 < <(printf %s "$text_1347")
        __status=$?
    fi
    ret_split4_v0=("${result_1349[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_14824=("${!1}")
    local delimiter_14825="${2}"
    local command_1
    command_1="$(IFS="${delimiter_14825}" ; printf "%s
" "${list_14824[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1351="${1}"
    [ -n "${text_1351}" ] && [ "${text_1351}" -eq "${text_1351}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1351}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_2736="${1}"
    local prefix_2737="${2}"
    [[ "${text_2736}" == "${prefix_2737}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1428="${1}"
    local index_1429="${2}"
    local length_1430="${3}"
    local result_1431=""
    if [ "$(( length_1430 == 0 ))" != 0 ]; then
        local __length_2="${text_1428}"
        length_1430="$(( ${#__length_2} - index_1429 ))"
    fi
    if [ "$(( length_1430 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1431}"
        return 0
    fi
    result_1431="${text_1428: ${index_1429}: ${length_1430}}"
    __status=$?
    ret_slice24_v0="${result_1431}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_16668="${1}"
    local pad_16669="${2}"
    local length_16670="${3}"
    local __length_3="${text_16668}"
    if [ "$(( length_16670 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_16668}"
        return 0
    fi
    local __length_4="${text_16668}"
    local pad_len_16671="$(( length_16670 - ${#__length_4} ))"
    local padding_16672=""
    printf -v padding_16672 "%${pad_len_16671}s" ""
    __status=$?
    padding_16672="${padding_16672// /${pad_16669}}"
    __status=$?
    ret_lpad27_v0="${padding_16672}""${text_16668}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1408="${1}"
    local pad_1409="${2}"
    local length_1410="${3}"
    local __length_5="${text_1408}"
    if [ "$(( length_1410 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1408}"
        return 0
    fi
    local __length_6="${text_1408}"
    local pad_len_1411="$(( length_1410 - ${#__length_6} ))"
    local padding_1412=""
    printf -v padding_1412 "%${pad_len_1411}s" ""
    __status=$?
    padding_1412="${padding_1412// /${pad_1409}}"
    __status=$?
    ret_rpad28_v0="${text_1408}""${padding_1412}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_16662="${1}"
    local pad_16663="${2}"
    local length_16664="${3}"
    local __length_7="${text_16662}"
    local text_length_16665="${#__length_7}"
    if [ "$(( length_16664 <= text_length_16665 ))" != 0 ]; then
        ret_cpad29_v0="${text_16662}"
        return 0
    fi
    local total_padding_16666="$(( length_16664 - text_length_16665 ))"
    local left_padding_length_16667="$(( text_length_16665 + $(( total_padding_16666 / 2 )) ))"
    lpad__27_v0 "${text_16662}" "${pad_16663}" "${left_padding_length_16667}"
    local left_padded_16673="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_16673}" "${pad_16663}" "${length_16664}"
    local center_padded_16674="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_16674}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_25325="${1}"
    [ -d "${path_25325}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1372="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1372}")"
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
" "${(P)name_1372}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1372}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_10}"
        return 0
    fi
}

# printf(format: Text, args: [])
printf__128_v0() {
    local format_1369="${1}"
    local args_1370=("${!2}")
    args_1370=("${format_1369}" "${args_1370[@]}")
    __status=$?
    printf "${args_1370[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1382="${1}"
    local args_1383=("${!2}")
    args_1383=("${format_1382}" "${args_1383[@]}")
    __status=$?
    printf "${args_1383[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1379="${1}"
    local color_1380="${2}"
    local color_code_1381=0
        color_code_1381="${color_1380}"
    local array_11=("${message_1379}")
    printf__128_v1 "\\x1b[${color_code_1381}m%s\\x1b[0m
" array_11[@]
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
command_12="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_5="$([ "_${command_12}" != "_No" ]; echo $?)"
command_13="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_6="$(( $(( ! _perl_disabled_5 )) && $([ "_${command_13}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__210_v0() {
    local text_1366="${1}"
    if [ "$(( ! _perl_available_6 ))" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return 1
    fi
    local command_14
    command_14="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1366}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return "${__status}"
    fi
    local width_str_1367="${command_14}"
    parse_int__13_v0 "${width_str_1367}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return "${__status}"
    fi
    local width_1368="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width210_v0="${width_1368}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_7=0
_term_size_8=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__221_v0() {
    local size_1346="${1}"
    if [ "$([ "_${size_1346}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size221_v0=0
        return 0
    fi
    split__4_v0 "${size_1346}" " "
    local parts_1350=("${ret_split4_v0[@]}")
    local __length_16=("${parts_1350[@]}")
    if [ "$(( ${#__length_16[@]} != 2 ))" != 0 ]; then
        ret_store_term_size221_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1350[1]?"Index out of bounds (at src/utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1350[0]?"Index out of bounds (at src/utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_8=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size221_v0=1
    return 0
}

# query_term_size()
query_term_size__222_v0() {
    local command_18
    command_18="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1353="${command_18}"
    store_term_size__221_v0 "${size_1353}"
    ret_query_term_size222_v0="${ret_store_term_size221_v0}"
    return 0
}

# stty_term_size()
stty_term_size__223_v0() {
    local command_19
    command_19="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1345="${command_19}"
    store_term_size__221_v0 "${size_1345}"
    ret_stty_term_size223_v0="${ret_store_term_size221_v0}"
    return 0
}

# get_term_size()
get_term_size__224_v0() {
    stty_term_size__223_v0 
    local detected_1352="${ret_stty_term_size223_v0}"
    if [ "$(( ! detected_1352 ))" != 0 ]; then
        query_term_size__222_v0 
        detected_1352="${ret_query_term_size222_v0}"
    fi
    _got_term_size_7=1
}

# term_width()
term_width__226_v0() {
    if [ "$(( ! _got_term_size_7 ))" != 0 ]; then
        get_term_size__224_v0 
    fi
    ret_term_width226_v0="${_term_size_8[0]?"Index out of bounds (at src/utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_9="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_10=0
_primary_color_11=(3 207 159 92)
_secondary_color_12=(3 118 206 94)
_accent_color_13=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__237_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1389="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_1389}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_9="No"
        ret_get_supports_truecolor237_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_9="No"
        ret_get_supports_truecolor237_v0=0
        return 0
    fi
    local colorterm_1390="${ret_env_var_get120_v0}"
    _supports_truecolor_9="$(if [ "$(( $([ "_${colorterm_1390}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_1390}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor237_v0="$([ "_${_supports_truecolor_9}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__238_v0() {
    local message_1384="${1}"
    local r_1385="${2}"
    local g_1386="${3}"
    local b_1387="${4}"
    local fallback_1388="${5}"
    if [ "$([ "_${_supports_truecolor_9}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb238_v0="\\x1b[38;2;${r_1385};${g_1386};${b_1387}m""${message_1384}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_9}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__237_v0 
        local ret_get_supports_truecolor237_v0__50_17="${ret_get_supports_truecolor237_v0}"
        if [ "${ret_get_supports_truecolor237_v0__50_17}" != 0 ]; then
            ret_colored_rgb238_v0="\\x1b[38;2;${r_1385};${g_1386};${b_1387}m""${message_1384}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1388 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_1384}"
            return 0
        else
            ret_colored_rgb238_v0="\\x1b[${fallback_1388}m""${message_1384}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1388 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_1384}"
            return 0
        fi
        ret_colored_rgb238_v0="\\x1b[${fallback_1388}m""${message_1384}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__240_v0() {
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1373="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1373}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1373}" ";"
            local parts_1374=("${ret_split4_v0[@]}")
            local __length_23=("${parts_1374[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1374[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1374[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1374[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1374[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_11=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1375="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1375}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1375}" ";"
            local parts_1376=("${ret_split4_v0[@]}")
            local __length_25=("${parts_1376[@]}")
            if [ "$(( ${#__length_25[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1376[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1376[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1376[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1376[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_12=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1377="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1377}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1377}" ";"
            local parts_1378=("${ret_split4_v0[@]}")
            local __length_27=("${parts_1378[@]}")
            if [ "$(( ${#__length_27[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1378[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1378[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1378[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1378[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_13=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_10=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__241_v0() {
    inner_get_xylitol_colors__240_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_10=1
}

# colored_primary(message: Text)
colored_primary__242_v0() {
    local message_1371="${1}"
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1371}" "${_primary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary242_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__243_v0() {
    local message_1392="${1}"
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1392}" "${_secondary_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary243_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__244_v0() {
    local message_1438="${1}"
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1438}" "${_accent_color_13[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_13[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_13[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_13[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent244_v0="${ret_colored_rgb238_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__259_v0() {
    local message_25328="${1}"
    local color_25329="${2}"
    # Prints a text with a specified color.
    local array_29=("${message_25328}")
    printf__128_v1 "\\x1b[${color_25329}m%s\\x1b[0m" array_29[@]
}

# eprintf(format: Text, args: [Text])
eprintf__260_v0() {
    local format_154="${1}"
    local args_155=("${!2}")
    args_155=("${format_154}" "${args_155[@]}")
    __status=$?
    printf "${args_155[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__261_v0() {
    local message_152="${1}"
    local color_153="${2}"
    # Prints an error message with a specified color.
    local array_30=("${message_152}")
    eprintf__260_v0 "\\x1b[${color_153}m%s\\x1b[0m" array_30[@]
}

# colored(message: Text, color: Int)
colored__262_v0() {
    local message_1426="${1}"
    local color_1427="${2}"
    # Returns a text wrapped in color codes.
    ret_colored262_v0="\\x1b[${color_1427}m""${message_1426}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__273_v0() {
    local text_1359="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_31
    command_31="$([[ "${text_1359}" == *$'\x1b'* || "${text_1359}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1360="${command_31}"
    ret_has_ansi_escape273_v0="$([ "_${has_escape_1360}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__275_v0() {
    local text_1362="${1}"
    local command_32
    command_32="$(printf "%s" "${text_1362}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi275_v0="${command_32}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__276_v0() {
    local text_1364="${1}"
    local command_33
    command_33="$(printf "%s" "${text_1364}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1365="${command_33}"
    ret_is_all_ascii276_v0="$([ "_${result_1365}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__277_v0() {
    local text_1361="${1}"
    strip_ansi__275_v0 "${text_1361}"
    local stripped_1363="${ret_strip_ansi275_v0}"
    # Check if text is all ASCII
    is_all_ascii__276_v0 "${stripped_1363}"
    local ret_is_all_ascii276_v0__150_12="${ret_is_all_ascii276_v0}"
    if [ "$(( ! ret_is_all_ascii276_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__210_v0 "${stripped_1363}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_34="${stripped_1363}"
            ret_get_visible_len277_v0="${#__length_34}"
            return 0
        fi
        ret_get_visible_len277_v0="${ret_perl_get_cjk_width210_v0}"
        return 0
    else
        local __length_35="${stripped_1363}"
        ret_get_visible_len277_v0="${#__length_35}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__282_v0() {
    local pending_1423="${1}"
    local line_1424="${2}"
    local note_at_1425="${3}"
    if [ "$(( note_at_1425 < 0 ))" != 0 ]; then
        local array_36=()
        printf__128_v0 "${pending_1423}""${line_1424}""
" array_36[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1425 == 0 ))" != 0 ]; then
        colored__262_v0 "${line_1424}" 90
        local ret_colored262_v0__310_40="${ret_colored262_v0}"
        local array_37=()
        printf__128_v0 "${pending_1423}""${ret_colored262_v0__310_40}""
" array_37[@]
    else
        slice__24_v0 "${line_1424}" 0 "${note_at_1425}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1424}" "${note_at_1425}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__262_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored262_v0__311_58="${ret_colored262_v0}"
        local array_38=()
        printf__128_v0 "${pending_1423}""${ret_slice24_v0__311_32}""${ret_colored262_v0__311_58}""
" array_38[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__283_v0() {
    local names_1396=("${!1}")
    local texts_1397=("${!2}")
    local notes_1398=("${!3}")
    local min_name_width_1399="${4}"
    local __length_39=("${names_1396[@]}")
    local count_1400="${#__length_39[@]}"
    local name_width_1401="${min_name_width_1399}"
    local __range_start_1402=0
    local __range_end_1402="${count_1400}"
    local __dir_1402=$(( ${__range_start_1402} <= ${__range_end_1402} ? 1 : -1 ))
    for (( i_1402=${__range_start_1402}; i_1402 * ${__dir_1402} < ${__range_end_1402} * ${__dir_1402}; i_1402+=${__dir_1402} )); do
        local __length_40="${names_1396[${i_1402}]?"Index out of bounds (at src/./utils.ab:326:33)"}"
        local width_1403="${#__length_40}"
        if [ "$(( width_1403 > name_width_1401 ))" != 0 ]; then
            name_width_1401="${width_1403}"
        fi
done
    term_width__226_v0 
    local width_1404="${ret_term_width226_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1405="$(( name_width_1401 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1406="$(( $(( width_1404 - indent_1405 )) < 24 ))"
    if [ "${stacked_1406}" != 0 ]; then
        indent_1405=6
    fi
    local avail_1407="$(( width_1404 - indent_1405 ))"
    rpad__28_v0 "" " " "${indent_1405}"
    local blank_1413="${ret_rpad28_v0}"
    local __range_start_1414=0
    local __range_end_1414="${count_1400}"
    local __dir_1414=$(( ${__range_start_1414} <= ${__range_end_1414} ? 1 : -1 ))
    for (( i_1414=${__range_start_1414}; i_1414 * ${__dir_1414} < ${__range_end_1414} * ${__dir_1414}; i_1414+=${__dir_1414} )); do
        local pending_1415="${blank_1413}"
        if [ "${stacked_1406}" != 0 ]; then
            local array_41=()
            printf__128_v0 "  ""${names_1396[${i_1414}]?"Index out of bounds (at src/./utils.ab:346:33)"}""
" array_41[@]
        else
            rpad__28_v0 "  ""${names_1396[${i_1414}]?"Index out of bounds (at src/./utils.ab:348:41)"}" " " "${indent_1405}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_1415="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_1397[${i_1414}]?"Index out of bounds (at src/./utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_1416=("${ret_split4_v0__350_21[@]}")
        local __length_42=("${words_1416[@]}")
        local note_start_1417="${#__length_42[@]}"
        if [ "$([ "_${notes_1398[${i_1414}]?"Index out of bounds (at src/./utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_43="${notes_1398[${i_1414}]?"Index out of bounds (at src/./utils.ab:355:26)"}"
            if [ "$(( ${#__length_43} > avail_1407 ))" != 0 ]; then
                split__4_v0 "${notes_1398[${i_1414}]?"Index out of bounds (at src/./utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_1416+=("${ret_split4_v0__356_26[@]}")
            else
                local array_44=("${notes_1398[${i_1414}]?"Index out of bounds (at src/./utils.ab:358:33)"}")
                words_1416+=("${array_44[@]}")
            fi
        fi
        local line_1418=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1419=-1
        local __range_start_1420=0
        local __length_45=("${words_1416[@]}")
        local __range_end_1420="${#__length_45[@]}"
        local __dir_1420=$(( ${__range_start_1420} <= ${__range_end_1420} ? 1 : -1 ))
        for (( j_1420=${__range_start_1420}; j_1420 * ${__dir_1420} < ${__range_end_1420} * ${__dir_1420}; j_1420+=${__dir_1420} )); do
            local word_1421="${words_1416[${j_1420}]?"Index out of bounds (at src/./utils.ab:368:32)"}"
            local candidate_1422
            candidate_1422="$(if [ "$([ "_${line_1418}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1421}"; else echo "${line_1418}"" ""${word_1421}"; fi)"
            local __length_46="${candidate_1422}"
            if [ "$(( $(( ${#__length_46} > avail_1407 )) && $([ "_${line_1418}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__282_v0 "${pending_1415}" "${line_1418}" "${note_at_1419}"
                pending_1415="${blank_1413}"
                line_1418="${word_1421}"
                note_at_1419="$(if [ "$(( j_1420 >= note_start_1417 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1420 >= note_start_1417 )) && $(( note_at_1419 < 0 )) ))" != 0 ]; then
                    local __length_47="${candidate_1422}"
                    local __length_48="${word_1421}"
                    note_at_1419="$(( ${#__length_47} - ${#__length_48} ))"
                fi
                line_1418="${candidate_1422}"
            fi
done
        print_help_line__282_v0 "${pending_1415}" "${line_1418}" "${note_at_1419}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__284_v0() {
    local pieces_1344=("${!1}")
    term_width__226_v0 
    local width_1354="${ret_term_width226_v0}"
    local line_1355=""
    local line_len_1356=0
    for piece_1357 in "${pieces_1344[@]}"; do
        local __length_51="${piece_1357}"
        local piece_len_1358="${#__length_51}"
        has_ansi_escape__273_v0 "${piece_1357}"
        local ret_has_ansi_escape273_v0__397_12="${ret_has_ansi_escape273_v0}"
        if [ "${ret_has_ansi_escape273_v0__397_12}" != 0 ]; then
            get_visible_len__277_v0 "${piece_1357}"
            piece_len_1358="${ret_get_visible_len277_v0}"
        fi
        if [ "$([ "_${line_1355}" != "_" ]; echo $?)" != 0 ]; then
            line_1355="${piece_1357}"
            line_len_1356="${piece_len_1358}"
        elif [ "$(( $(( $(( line_len_1356 + 1 )) + piece_len_1358 )) > width_1354 ))" != 0 ]; then
            local array_52=()
            printf__128_v0 "${line_1355}""
" array_52[@]
            line_1355="${piece_1357}"
            line_len_1356="${piece_len_1358}"
        else
            line_1355+=" ""${piece_1357}"
            line_len_1356="$(( line_len_1356 + $(( 1 + piece_len_1358 )) ))"
        fi
    done
    if [ "$([ "_${line_1355}" == "_" ]; echo $?)" != 0 ]; then
        local array_53=()
        printf__128_v0 "${line_1355}""
" array_53[@]
    fi
}

# print_help()
print_help__428_v0() {
    local usage_1343=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__284_v0 usage_1343[@]
    printf '%s\n' ""
    colored_primary__242_v0 "Xylitol"
    local ret_colored_primary242_v0__9_21="${ret_colored_primary242_v0}"
    colored_primary__242_v0 "fresh"
    local ret_colored_primary242_v0__10_34="${ret_colored_primary242_v0}"
    local title_1391=("\\x1b[1m""${ret_colored_primary242_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary242_v0__10_34}" "shell" "scripts.")
    print_wrapped__284_v0 title_1391[@]
    printf '%s\n' ""
    colored_secondary__243_v0 "Flags:"
    local ret_colored_secondary243_v0__14_12="${ret_colored_secondary243_v0}"
    local array_56=()
    printf__128_v0 "${ret_colored_secondary243_v0__14_12}""
" array_56[@]
    local flag_names_1393=("-h, --help" "-v, --version")
    local flag_texts_1394=("Show this help message" "Show version information")
    local flag_notes_1395=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__283_v0 flag_names_1393[@] flag_texts_1394[@] flag_notes_1395[@] 13
    printf '%s\n' ""
    colored_secondary__243_v0 "Commands:"
    local ret_colored_secondary243_v0__21_12="${ret_colored_secondary243_v0}"
    local array_60=()
    printf__128_v0 "${ret_colored_secondary243_v0__21_12}""
" array_60[@]
    local cmd_names_1432=("input" "choose" "confirm" "file")
    local cmd_texts_1433=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1434=("" "" "" "")
    render_help_entries__283_v0 cmd_names_1432[@] cmd_texts_1433[@] cmd_notes_1434[@] 13
    printf '%s\n' ""
    colored_secondary__243_v0 "Envs:"
    local ret_colored_secondary243_v0__32_12="${ret_colored_secondary243_v0}"
    local array_64=()
    printf__128_v0 "${ret_colored_secondary243_v0__32_12}""
" array_64[@]
    local env_names_1435=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1436=("Use Perl for CJK / Optimization" "Enable 24-bit truecolor support" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1437=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: Yes)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__283_v0 env_names_1435[@] env_texts_1436[@] env_notes_1437[@] 0
    printf '%s\n' ""
    colored_accent__244_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent244_v0__57_16="${ret_colored_accent244_v0}"
    local footer_1439=("Run" "${ret_colored_accent244_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__284_v0 footer_1439[@]
}

# math_floor(number: Int)
math_floor__509_v0() {
    local number_2801="${1}"
    local command_69
    command_69="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_2801}")"
    __status=$?
    ret_math_floor509_v0="${command_69}"
    return 0
}

# math_ceil(number: Int)
math_ceil__510_v0() {
    local number_2800="${1}"
    math_floor__509_v0 "${number_2800}"
    local ret_math_floor509_v0__52_12="${ret_math_floor509_v0}"
    ret_math_ceil510_v0="$(( ret_math_floor509_v0__52_12 + 1 ))"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
command_70="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_18="$([ "_${command_70}" != "_No" ]; echo $?)"
command_71="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_19="$(( $(( ! _perl_disabled_18 )) && $([ "_${command_71}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__570_v0() {
    local text_2687="${1}"
    if [ "$(( ! _perl_available_19 ))" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return 1
    fi
    local command_72
    command_72="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2687}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return "${__status}"
    fi
    local width_str_2688="${command_72}"
    parse_int__13_v0 "${width_str_2688}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return "${__status}"
    fi
    local width_2689="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width570_v0="${width_2689}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__571_v0() {
    local text_2755="${1}"
    local max_width_2756="${2}"
    if [ "$(( ! _perl_available_19 ))" != 0 ]; then
        ret_perl_truncate_cjk571_v0=''
        return 1
    fi
    local command_73
    command_73="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_2755}" ${max_width_2756} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk571_v0=''
        return "${__status}"
    fi
    local result_2757="${command_73}"
    ret_perl_truncate_cjk571_v0="${result_2757}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_20=0
_term_size_21=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__578_v0() {
    local command_75
    command_75="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_2744="${command_75}"
    parse_int__13_v0 "${count_2744}"
    __status=$?
    ret_stty_count578_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__579_v0() {
    stty_count__578_v0 
    local count_num_2745="${ret_stty_count578_v0}"
    if [ "$(( count_num_2745 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2745="$(( count_num_2745 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2745}
    __status=$?
}

# stty_unlock()
stty_unlock__580_v0() {
    stty_count__578_v0 
    local count_num_2798="${ret_stty_count578_v0}"
    if [ "$(( count_num_2798 > 0 ))" != 0 ]; then
        count_num_2798="$(( count_num_2798 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2798}
        __status=$?
        if [ "$(( count_num_2798 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__581_v0() {
    local size_2671="${1}"
    if [ "$([ "_${size_2671}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size581_v0=0
        return 0
    fi
    split__4_v0 "${size_2671}" " "
    local parts_2672=("${ret_split4_v0[@]}")
    local __length_76=("${parts_2672[@]}")
    if [ "$(( ${#__length_76[@]} != 2 ))" != 0 ]; then
        ret_store_term_size581_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2672[1]?"Index out of bounds (at src/./input/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2672[0]?"Index out of bounds (at src/./input/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_21=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size581_v0=1
    return 0
}

# query_term_size()
query_term_size__582_v0() {
    local command_78
    command_78="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2674="${command_78}"
    store_term_size__581_v0 "${size_2674}"
    ret_query_term_size582_v0="${ret_store_term_size581_v0}"
    return 0
}

# stty_term_size()
stty_term_size__583_v0() {
    local command_79
    command_79="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2670="${command_79}"
    store_term_size__581_v0 "${size_2670}"
    ret_stty_term_size583_v0="${ret_store_term_size581_v0}"
    return 0
}

# get_term_size()
get_term_size__584_v0() {
    stty_term_size__583_v0 
    local detected_2673="${ret_stty_term_size583_v0}"
    if [ "$(( ! detected_2673 ))" != 0 ]; then
        query_term_size__582_v0 
        detected_2673="${ret_query_term_size582_v0}"
    fi
    _got_term_size_20=1
}

# term_width()
term_width__586_v0() {
    if [ "$(( ! _got_term_size_20 ))" != 0 ]; then
        get_term_size__584_v0 
    fi
    ret_term_width586_v0="${_term_size_21[0]?"Index out of bounds (at src/./input/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_22="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_23=0
_primary_color_24=(3 207 159 92)
_secondary_color_25=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__597_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_2702="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_2702}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_22="No"
        ret_get_supports_truecolor597_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_22="No"
        ret_get_supports_truecolor597_v0=0
        return 0
    fi
    local colorterm_2703="${ret_env_var_get120_v0}"
    _supports_truecolor_22="$(if [ "$(( $([ "_${colorterm_2703}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_2703}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor597_v0="$([ "_${_supports_truecolor_22}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__598_v0() {
    local message_2697="${1}"
    local r_2698="${2}"
    local g_2699="${3}"
    local b_2700="${4}"
    local fallback_2701="${5}"
    if [ "$([ "_${_supports_truecolor_22}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb598_v0="\\x1b[38;2;${r_2698};${g_2699};${b_2700}m""${message_2697}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_22}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__597_v0 
        local ret_get_supports_truecolor597_v0__50_17="${ret_get_supports_truecolor597_v0}"
        if [ "${ret_get_supports_truecolor597_v0__50_17}" != 0 ]; then
            ret_colored_rgb598_v0="\\x1b[38;2;${r_2698};${g_2699};${b_2700}m""${message_2697}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2701 == 0 ))" != 0 ]; then
            ret_colored_rgb598_v0="${message_2697}"
            return 0
        else
            ret_colored_rgb598_v0="\\x1b[${fallback_2701}m""${message_2697}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2701 == 0 ))" != 0 ]; then
            ret_colored_rgb598_v0="${message_2697}"
            return 0
        fi
        ret_colored_rgb598_v0="\\x1b[${fallback_2701}m""${message_2697}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__600_v0() {
    if [ "$(( ! _got_xylitol_colors_23 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2691="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2691}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2691}" ";"
            local parts_2692=("${ret_split4_v0[@]}")
            local __length_83=("${parts_2692[@]}")
            if [ "$(( ${#__length_83[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2692[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2692[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2692[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2692[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_24=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2693="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2693}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2693}" ";"
            local parts_2694=("${ret_split4_v0[@]}")
            local __length_85=("${parts_2694[@]}")
            if [ "$(( ${#__length_85[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2694[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2694[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2694[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2694[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_25=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2695="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2695}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2695}" ";"
            local parts_2696=("${ret_split4_v0[@]}")
            local __length_87=("${parts_2696[@]}")
            if [ "$(( ${#__length_87[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2696[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2696[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2696[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2696[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_23=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__601_v0() {
    inner_get_xylitol_colors__600_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_23=1
}

# colored_primary(message: Text)
colored_primary__602_v0() {
    local message_2690="${1}"
    if [ "$(( ! _got_xylitol_colors_23 ))" != 0 ]; then
        get_xylitol_colors__601_v0 
    fi
    colored_rgb__598_v0 "${message_2690}" "${_primary_color_24[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_24[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_24[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_24[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary602_v0="${ret_colored_rgb598_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__603_v0() {
    local message_2705="${1}"
    if [ "$(( ! _got_xylitol_colors_23 ))" != 0 ]; then
        get_xylitol_colors__601_v0 
    fi
    colored_rgb__598_v0 "${message_2705}" "${_secondary_color_25[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_25[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_25[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_25[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary603_v0="${ret_colored_rgb598_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__617_v0() {
    local command_89
    command_89="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_2795="${command_89}"
    ret_get_char617_v0="${char_2795}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__620_v0() {
    local format_2773="${1}"
    local args_2774=("${!2}")
    args_2774=("${format_2773}" "${args_2774[@]}")
    __status=$?
    printf "${args_2774[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__621_v0() {
    local message_2783="${1}"
    local color_2784="${2}"
    # Prints an error message with a specified color.
    local array_90=("${message_2783}")
    eprintf__620_v0 "\\x1b[${color_2784}m%s\\x1b[0m" array_90[@]
}

# colored(message: Text, color: Int)
colored__622_v0() {
    local message_2734="${1}"
    local color_2735="${2}"
    # Returns a text wrapped in color codes.
    ret_colored622_v0="\\x1b[${color_2735}m""${message_2734}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__623_v0() {
    local cnt_2796="${1}"
    if [ "$(( cnt_2796 > 0 ))" != 0 ]; then
        local array_91=("")
        eprintf__620_v0 "\\x1b[${cnt_2796}D\\x1b[K" array_91[@]
    fi
}

# remove_line(cnt: Int)
remove_line__624_v0() {
    local cnt_2804="${1}"
    if [ "$(( cnt_2804 > 0 ))" != 0 ]; then
        local sequence_2805=""
        local __range_start_2806=0
        local __range_end_2806="${cnt_2804}"
        local __dir_2806=$(( ${__range_start_2806} <= ${__range_end_2806} ? 1 : -1 ))
        for (( ____2806=${__range_start_2806}; ____2806 * ${__dir_2806} < ${__range_end_2806} * ${__dir_2806}; ____2806+=${__dir_2806} )); do
            sequence_2805+="\\x1b[2K\\x1b[1A"
done
        local array_92=("")
        eprintf__620_v0 "${sequence_2805}" array_92[@]
    fi
    local array_93=("")
    eprintf__620_v0 "\\x1b[G" array_93[@]
}

# remove_current_line()
remove_current_line__625_v0() {
    local array_94=("")
    eprintf__620_v0 "\\x1b[2K\\x1b[G" array_94[@]
}

# new_line(cnt: Int)
new_line__627_v0() {
    local cnt_2775="${1}"
    local __range_start_2776=0
    local __range_end_2776="${cnt_2775}"
    local __dir_2776=$(( ${__range_start_2776} <= ${__range_end_2776} ? 1 : -1 ))
    for (( ____2776=${__range_start_2776}; ____2776 * ${__dir_2776} < ${__range_end_2776} * ${__dir_2776}; ____2776+=${__dir_2776} )); do
        local array_95=("")
        eprintf__620_v0 "
" array_95[@]
done
}

# go_up(cnt: Int)
go_up__628_v0() {
    local cnt_2792="${1}"
    local array_96=("")
    eprintf__620_v0 "\\x1b[${cnt_2792}A" array_96[@]
}

# go_down(cnt: Int)
go_down__629_v0() {
    local cnt_2803="${1}"
    local array_97=("")
    eprintf__620_v0 "\\x1b[${cnt_2803}B" array_97[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__633_v0() {
    local text_2680="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_98
    command_98="$([[ "${text_2680}" == *$'\x1b'* || "${text_2680}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2681="${command_98}"
    ret_has_ansi_escape633_v0="$([ "_${has_escape_2681}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__634_v0() {
    local text_2738="${1}"
    local command_99
    command_99="$(printf '%s' "${text_2738}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi634_v0="${command_99}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__635_v0() {
    local text_2683="${1}"
    local command_100
    command_100="$(printf "%s" "${text_2683}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi635_v0="${command_100}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__636_v0() {
    local text_2685="${1}"
    local command_101
    command_101="$(printf "%s" "${text_2685}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2686="${command_101}"
    ret_is_all_ascii636_v0="$([ "_${result_2686}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__637_v0() {
    local text_2682="${1}"
    strip_ansi__635_v0 "${text_2682}"
    local stripped_2684="${ret_strip_ansi635_v0}"
    # Check if text is all ASCII
    is_all_ascii__636_v0 "${stripped_2684}"
    local ret_is_all_ascii636_v0__150_12="${ret_is_all_ascii636_v0}"
    if [ "$(( ! ret_is_all_ascii636_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__570_v0 "${stripped_2684}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_102="${stripped_2684}"
            ret_get_visible_len637_v0="${#__length_102}"
            return 0
        fi
        ret_get_visible_len637_v0="${ret_perl_get_cjk_width570_v0}"
        return 0
    else
        local __length_103="${stripped_2684}"
        ret_get_visible_len637_v0="${#__length_103}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__638_v0() {
    local text_2752="${1}"
    local max_width_2753="${2}"
    get_visible_len__637_v0 "${text_2752}"
    local visible_len_2754="${ret_get_visible_len637_v0}"
    if [ "$(( visible_len_2754 <= max_width_2753 ))" != 0 ]; then
        ret_truncate_text638_v0="${text_2752}"
        return 0
    fi
    is_all_ascii__636_v0 "${text_2752}"
    local ret_is_all_ascii636_v0__167_12="${ret_is_all_ascii636_v0}"
    if [ "$(( ! ret_is_all_ascii636_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__571_v0 "${text_2752}" "${max_width_2753}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_2752}" | cut -c1-${max_width_2753}
            __status=$?
        fi
        ret_truncate_text638_v0="${ret_perl_truncate_cjk571_v0}"
        return 0
    fi
    local command_104
    command_104="$(printf "%s" "${text_2752}" | cut -c1-${max_width_2753})"
    __status=$?
    ret_truncate_text638_v0="${command_104}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__639_v0() {
    local text_2750="${1}"
    local max_width_2751="${2}"
    has_ansi_escape__633_v0 "${text_2750}"
    local ret_has_ansi_escape633_v0__179_12="${ret_has_ansi_escape633_v0}"
    if [ "$(( ! ret_has_ansi_escape633_v0__179_12 ))" != 0 ]; then
        truncate_text__638_v0 "${text_2750}" "${max_width_2751}"
        ret_truncate_ansi639_v0="${ret_truncate_text638_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_105
    command_105="$([[ "${text_2750}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_2758="${command_105}"
    # Replace \x1b[ with newline, then split
    local command_106
    command_106="$(t="${text_2750}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_2759="${command_106}"
    split__4_v0 "${replaced_2759}" "
"
    local parts_2760=("${ret_split4_v0[@]}")
    local result_2761=""
    local remaining_width_2762="${max_width_2751}"
    local __range_start_2763=0
    local __length_107=("${parts_2760[@]}")
    local __range_end_2763="${#__length_107[@]}"
    local __dir_2763=$(( ${__range_start_2763} <= ${__range_end_2763} ? 1 : -1 ))
    for (( idx_2763=${__range_start_2763}; idx_2763 * ${__dir_2763} < ${__range_end_2763} * ${__dir_2763}; idx_2763+=${__dir_2763} )); do
        local part_2764="${parts_2760[${idx_2763}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_2763 == 0 )) && $([ "_${starts_with_ansi_2758}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_2764}" == "_" ]; echo $?) && $(( remaining_width_2762 > 0 )) ))" != 0 ]; then
                truncate_text__638_v0 "${part_2764}" "${remaining_width_2762}"
                local ret_truncate_text638_v0__201_35="${ret_truncate_text638_v0}"
                local truncated_2765="${ret_truncate_text638_v0__201_35}"
                result_2761+="${truncated_2765}"
                get_visible_len__637_v0 "${truncated_2765}"
                local ret_get_visible_len637_v0__203_36="${ret_get_visible_len637_v0}"
                remaining_width_2762="$(( remaining_width_2762 - ret_get_visible_len637_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_108
            command_108="$(__p="${part_2764}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_2766="${command_108}"
            if [ "$([ "_${m_idx_2766}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_109
                command_109="$(__p="${part_2764}"; printf "%s" "${__p:0:${m_idx_2766}}")"
                __status=$?
                local ansi_params_2767="${command_109}"
                result_2761+="\\x1b[""${ansi_params_2767}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_2766}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_2768="${ret_parse_int13_v0__214_41}"
                local text_start_2769="$(( m_idx_num_2768 + 1 ))"
                local command_110
                command_110="$(__p="${part_2764}"; printf "%s" "${__p:${text_start_2769}}")"
                __status=$?
                local text_part_2770="${command_110}"
                if [ "$(( $([ "_${text_part_2770}" == "_" ]; echo $?) && $(( remaining_width_2762 > 0 )) ))" != 0 ]; then
                    truncate_text__638_v0 "${text_part_2770}" "${remaining_width_2762}"
                    local ret_truncate_text638_v0__218_39="${ret_truncate_text638_v0}"
                    local truncated_2771="${ret_truncate_text638_v0__218_39}"
                    result_2761+="${truncated_2771}"
                    get_visible_len__637_v0 "${truncated_2771}"
                    local ret_get_visible_len637_v0__220_40="${ret_get_visible_len637_v0}"
                    remaining_width_2762="$(( remaining_width_2762 - ret_get_visible_len637_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_2764}" == "_" ]; echo $?) && $(( remaining_width_2762 > 0 )) ))" != 0 ]; then
                    truncate_text__638_v0 "${part_2764}" "${remaining_width_2762}"
                    local ret_truncate_text638_v0__225_39="${ret_truncate_text638_v0}"
                    local truncated_2772="${ret_truncate_text638_v0__225_39}"
                    result_2761+="${truncated_2772}"
                    get_visible_len__637_v0 "${truncated_2772}"
                    local ret_get_visible_len637_v0__227_40="${ret_get_visible_len637_v0}"
                    remaining_width_2762="$(( remaining_width_2762 - ret_get_visible_len637_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi639_v0="${result_2761}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__640_v0() {
    local text_2747="${1}"
    local max_width_2748="${2}"
    get_visible_len__637_v0 "${text_2747}"
    local visible_len_2749="${ret_get_visible_len637_v0}"
    if [ "$(( visible_len_2749 <= max_width_2748 ))" != 0 ]; then
        ret_cutoff_text640_v0="${text_2747}"
        return 0
    fi
    truncate_ansi__639_v0 "${text_2747}" "$(( max_width_2748 - 3 ))"
    local ret_truncate_ansi639_v0__243_12="${ret_truncate_ansi639_v0}"
    ret_cutoff_text640_v0="${ret_truncate_ansi639_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__641_v0() {
    local items_2777=("${!1}")
    local total_len_2778="${2}"
    local term_width_2779="${3}"
    local separator_2780=" • "
    local separator_len_2781=3
    # Fast path: no truncation needed
    if [ "$(( total_len_2778 <= term_width_2779 ))" != 0 ]; then
        local iter_2782=0
        while :
        do
            local __length_111=("${items_2777[@]}")
            if [ "$(( iter_2782 >= ${#__length_111[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_2782 > 0 ))" != 0 ]; then
                eprintf_colored__621_v0 "${separator_2780}" 90
            fi
            colored__622_v0 "${items_2777[$(( iter_2782 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored622_v0__268_41="${ret_colored622_v0}"
            local array_112=("")
            eprintf__620_v0 "${items_2777[${iter_2782}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored622_v0__268_41}" array_112[@]
            iter_2782="$(( iter_2782 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_2785=0
        local first_2786=1
        local iter_2787=0
        while :
        do
            local __length_113=("${items_2777[@]}")
            if [ "$(( iter_2787 >= ${#__length_113[@]} ))" != 0 ]; then
                break
            fi
            local key_2788="${items_2777[${iter_2787}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_2789="${items_2777[$(( iter_2787 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_114="${key_2788}"
            local __length_115="${action_2789}"
            local part_len_2790="$(( $(( ${#__length_114} + 1 )) + ${#__length_115} ))"
            local needed_2791="${part_len_2790}"
            if [ "$(( ! first_2786 ))" != 0 ]; then
                needed_2791="$(( needed_2791 + separator_len_2781 ))"
            fi
            if [ "$(( $(( current_len_2785 + needed_2791 )) > term_width_2779 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_2786 ))" != 0 ]; then
                eprintf_colored__621_v0 "${separator_2780}" 90
            fi
            colored__622_v0 "${action_2789}" 2
            local ret_colored622_v0__296_33="${ret_colored622_v0}"
            local array_116=("")
            eprintf__620_v0 "${key_2788}"" ""${ret_colored622_v0__296_33}" array_116[@]
            current_len_2785="$(( current_len_2785 + needed_2791 ))"
            first_2786=0
            iter_2787="$(( iter_2787 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__642_v0() {
    local pending_2731="${1}"
    local line_2732="${2}"
    local note_at_2733="${3}"
    if [ "$(( note_at_2733 < 0 ))" != 0 ]; then
        local array_117=()
        printf__128_v0 "${pending_2731}""${line_2732}""
" array_117[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_2733 == 0 ))" != 0 ]; then
        colored__622_v0 "${line_2732}" 90
        local ret_colored622_v0__310_40="${ret_colored622_v0}"
        local array_118=()
        printf__128_v0 "${pending_2731}""${ret_colored622_v0__310_40}""
" array_118[@]
    else
        slice__24_v0 "${line_2732}" 0 "${note_at_2733}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_2732}" "${note_at_2733}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__622_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored622_v0__311_58="${ret_colored622_v0}"
        local array_119=()
        printf__128_v0 "${pending_2731}""${ret_slice24_v0__311_32}""${ret_colored622_v0__311_58}""
" array_119[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__643_v0() {
    local names_2709=("${!1}")
    local texts_2710=("${!2}")
    local notes_2711=("${!3}")
    local min_name_width_2712="${4}"
    local __length_120=("${names_2709[@]}")
    local count_2713="${#__length_120[@]}"
    local name_width_2714="${min_name_width_2712}"
    local __range_start_2715=0
    local __range_end_2715="${count_2713}"
    local __dir_2715=$(( ${__range_start_2715} <= ${__range_end_2715} ? 1 : -1 ))
    for (( i_2715=${__range_start_2715}; i_2715 * ${__dir_2715} < ${__range_end_2715} * ${__dir_2715}; i_2715+=${__dir_2715} )); do
        local __length_121="${names_2709[${i_2715}]?"Index out of bounds (at src/./input/../utils.ab:326:33)"}"
        local width_2716="${#__length_121}"
        if [ "$(( width_2716 > name_width_2714 ))" != 0 ]; then
            name_width_2714="${width_2716}"
        fi
done
    term_width__586_v0 
    local width_2717="${ret_term_width586_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2718="$(( name_width_2714 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2719="$(( $(( width_2717 - indent_2718 )) < 24 ))"
    if [ "${stacked_2719}" != 0 ]; then
        indent_2718=6
    fi
    local avail_2720="$(( width_2717 - indent_2718 ))"
    rpad__28_v0 "" " " "${indent_2718}"
    local blank_2721="${ret_rpad28_v0}"
    local __range_start_2722=0
    local __range_end_2722="${count_2713}"
    local __dir_2722=$(( ${__range_start_2722} <= ${__range_end_2722} ? 1 : -1 ))
    for (( i_2722=${__range_start_2722}; i_2722 * ${__dir_2722} < ${__range_end_2722} * ${__dir_2722}; i_2722+=${__dir_2722} )); do
        local pending_2723="${blank_2721}"
        if [ "${stacked_2719}" != 0 ]; then
            local array_122=()
            printf__128_v0 "  ""${names_2709[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:346:33)"}""
" array_122[@]
        else
            rpad__28_v0 "  ""${names_2709[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:348:41)"}" " " "${indent_2718}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_2723="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_2710[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_2724=("${ret_split4_v0__350_21[@]}")
        local __length_123=("${words_2724[@]}")
        local note_start_2725="${#__length_123[@]}"
        if [ "$([ "_${notes_2711[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_124="${notes_2711[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_124} > avail_2720 ))" != 0 ]; then
                split__4_v0 "${notes_2711[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_2724+=("${ret_split4_v0__356_26[@]}")
            else
                local array_125=("${notes_2711[${i_2722}]?"Index out of bounds (at src/./input/../utils.ab:358:33)"}")
                words_2724+=("${array_125[@]}")
            fi
        fi
        local line_2726=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2727=-1
        local __range_start_2728=0
        local __length_126=("${words_2724[@]}")
        local __range_end_2728="${#__length_126[@]}"
        local __dir_2728=$(( ${__range_start_2728} <= ${__range_end_2728} ? 1 : -1 ))
        for (( j_2728=${__range_start_2728}; j_2728 * ${__dir_2728} < ${__range_end_2728} * ${__dir_2728}; j_2728+=${__dir_2728} )); do
            local word_2729="${words_2724[${j_2728}]?"Index out of bounds (at src/./input/../utils.ab:368:32)"}"
            local candidate_2730
            candidate_2730="$(if [ "$([ "_${line_2726}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2729}"; else echo "${line_2726}"" ""${word_2729}"; fi)"
            local __length_127="${candidate_2730}"
            if [ "$(( $(( ${#__length_127} > avail_2720 )) && $([ "_${line_2726}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__642_v0 "${pending_2723}" "${line_2726}" "${note_at_2727}"
                pending_2723="${blank_2721}"
                line_2726="${word_2729}"
                note_at_2727="$(if [ "$(( j_2728 >= note_start_2725 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2728 >= note_start_2725 )) && $(( note_at_2727 < 0 )) ))" != 0 ]; then
                    local __length_128="${candidate_2730}"
                    local __length_129="${word_2729}"
                    note_at_2727="$(( ${#__length_128} - ${#__length_129} ))"
                fi
                line_2726="${candidate_2730}"
            fi
done
        print_help_line__642_v0 "${pending_2723}" "${line_2726}" "${note_at_2727}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__644_v0() {
    local pieces_2669=("${!1}")
    term_width__586_v0 
    local width_2675="${ret_term_width586_v0}"
    local line_2676=""
    local line_len_2677=0
    for piece_2678 in "${pieces_2669[@]}"; do
        local __length_132="${piece_2678}"
        local piece_len_2679="${#__length_132}"
        has_ansi_escape__633_v0 "${piece_2678}"
        local ret_has_ansi_escape633_v0__397_12="${ret_has_ansi_escape633_v0}"
        if [ "${ret_has_ansi_escape633_v0__397_12}" != 0 ]; then
            get_visible_len__637_v0 "${piece_2678}"
            piece_len_2679="${ret_get_visible_len637_v0}"
        fi
        if [ "$([ "_${line_2676}" != "_" ]; echo $?)" != 0 ]; then
            line_2676="${piece_2678}"
            line_len_2677="${piece_len_2679}"
        elif [ "$(( $(( $(( line_len_2677 + 1 )) + piece_len_2679 )) > width_2675 ))" != 0 ]; then
            local array_133=()
            printf__128_v0 "${line_2676}""
" array_133[@]
            line_2676="${piece_2678}"
            line_len_2677="${piece_len_2679}"
        else
            line_2676+=" ""${piece_2678}"
            line_len_2677="$(( line_len_2677 + $(( 1 + piece_len_2679 )) ))"
        fi
    done
    if [ "$([ "_${line_2676}" == "_" ]; echo $?)" != 0 ]; then
        local array_134=()
        printf__128_v0 "${line_2676}""
" array_134[@]
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__695_v0() {
    local prompt_2740="${1}"
    local placeholder_2741="${2}"
    local header_2742="${3}"
    local password_2743="${4}"
    stty_lock__579_v0 
    term_width__586_v0 
    local term_width_2746="${ret_term_width586_v0}"
    if [ "$([ "_${header_2742}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__640_v0 "${header_2742}" "${term_width_2746}"
        local ret_cutoff_text640_v0__25_17="${ret_cutoff_text640_v0}"
        local array_135=("")
        eprintf__620_v0 "${ret_cutoff_text640_v0__25_17}""
" array_135[@]
    fi
    new_line__627_v0 2
    # "enter submit" = 12
    local array_136=("enter" "submit")
    render_tooltip__641_v0 array_136[@] 12 "${term_width_2746}"
    go_up__628_v0 2
    local array_137=("")
    eprintf__620_v0 "\\x1b[G" array_137[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_138
    command_138="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_2793="${command_138}"
    local char_2794=""
    local array_139=("")
    eprintf__620_v0 "${prompt_2740}" array_139[@]
    if [ "$([ "_${can_preset_2793}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__621_v0 "${placeholder_2741}" 90
        get_char__617_v0 
        char_2794="${ret_get_char617_v0}"
        local __length_140="${placeholder_2741}"
        remove__623_v0 "$(( ${#__length_140} + 1 ))"
    fi
    local __length_141="${prompt_2740}"
    remove__623_v0 "${#__length_141}"
    local text_2797=""
    if [ "$(( ! password_2743 ))" != 0 ]; then
        stty_unlock__580_v0 
        local command_142
        command_142="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_2794}" -p "${prompt_2740}" text < /dev/tty; else read -e -p "${prompt_2740}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2797="${command_142}"
    else
        stty_unlock__580_v0 
        local command_143
        command_143="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_2794}" -p "${prompt_2740}" text < /dev/tty; else read -es -p "${prompt_2740}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2797="${command_143}"
    fi
    stty_lock__579_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__637_v0 "${prompt_2740}""${text_2797}"
    local input_display_len_2799="${ret_get_visible_len637_v0}"
    math_ceil__510_v0 "$(( input_display_len_2799 / term_width_2746 ))"
    local input_lines_2802="${ret_math_ceil510_v0}"
    if [ "$(( input_lines_2802 < 3 ))" != 0 ]; then
        go_down__629_v0 "$(( 2 - input_lines_2802 ))"
        remove_line__624_v0 2
        remove_current_line__625_v0 
    fi
    if [ "$(( input_lines_2802 >= 3 ))" != 0 ]; then
        remove_line__624_v0 "${input_lines_2802}"
    fi
    if [ "$([ "_${header_2742}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__624_v0 1
        remove_current_line__625_v0 
    fi
    stty_unlock__580_v0 
    ret_xyl_input695_v0="${text_2797}"
    return 0
}

# print_input_help()
print_input_help__789_v0() {
    local usage_2668=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__644_v0 usage_2668[@]
    printf '%s\n' ""
    colored_primary__602_v0 "input"
    local ret_colored_primary602_v0__8_20="${ret_colored_primary602_v0}"
    local title_2704=("${ret_colored_primary602_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__644_v0 title_2704[@]
    printf '%s\n' ""
    colored_secondary__603_v0 "Flags:"
    local ret_colored_secondary603_v0__11_12="${ret_colored_secondary603_v0}"
    local array_146=()
    printf__128_v0 "${ret_colored_secondary603_v0__11_12}""
" array_146[@]
    local names_2706=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2707=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2708=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__643_v0 names_2706[@] texts_2707[@] notes_2708[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__841_v0() {
    local parameters_2662=("${!1}")
    local prompt_2663="> "
    local placeholder_2664="Type here..."
    local header_2665=""
    local password_2666=0
    for param_2667 in "${parameters_2662[@]}"; do
        if [ "$(( $([ "_${param_2667}" != "_-h" ]; echo $?) || $([ "_${param_2667}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__789_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2667}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_152="--prompt="
            slice__24_v0 "${param_2667}" "${#__length_152}" 0
            prompt_2663="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2667}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_153="--placeholder="
            slice__24_v0 "${param_2667}" "${#__length_153}" 0
            placeholder_2664="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2667}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_154="--header="
            slice__24_v0 "${param_2667}" "${#__length_154}" 0
            header_2665="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2667}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2666=1
        fi
    done
    has_ansi_escape__633_v0 "${header_2665}"
    local ret_has_ansi_escape633_v0__31_44="${ret_has_ansi_escape633_v0}"
    escape_ansi__634_v0 "${header_2665}"
    local ret_escape_ansi634_v0__31_73="${ret_escape_ansi634_v0}"
    colored_primary__602_v0 "${header_2665}"
    local ret_colored_primary602_v0__31_111="${ret_colored_primary602_v0}"
    local display_header_2739
    display_header_2739="$(if [ "$(( $([ "_${header_2665}" != "_" ]; echo $?) || ret_has_ansi_escape633_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi634_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary602_v0__31_111}"; fi)"
    xyl_input__695_v0 "${prompt_2663}" "${placeholder_2664}" "${display_header_2739}" "${password_2666}"
    ret_execute_input841_v0="${ret_xyl_input695_v0}"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
command_155="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_32="$([ "_${command_155}" != "_No" ]; echo $?)"
command_156="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_33="$(( $(( ! _perl_disabled_32 )) && $([ "_${command_156}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__973_v0() {
    local text_14665="${1}"
    if [ "$(( ! _perl_available_33 ))" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return 1
    fi
    local command_157
    command_157="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_14665}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return "${__status}"
    fi
    local width_str_14666="${command_157}"
    parse_int__13_v0 "${width_str_14666}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return "${__status}"
    fi
    local width_14667="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width973_v0="${width_14667}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__974_v0() {
    local text_14735="${1}"
    local max_width_14736="${2}"
    if [ "$(( ! _perl_available_33 ))" != 0 ]; then
        ret_perl_truncate_cjk974_v0=''
        return 1
    fi
    local command_158
    command_158="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_14735}" ${max_width_14736} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk974_v0=''
        return "${__status}"
    fi
    local result_14737="${command_158}"
    ret_perl_truncate_cjk974_v0="${result_14737}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_34=0
_term_size_35=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__981_v0() {
    local command_160
    command_160="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_14723="${command_160}"
    parse_int__13_v0 "${count_14723}"
    __status=$?
    ret_stty_count981_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__982_v0() {
    stty_count__981_v0 
    local count_num_14724="${ret_stty_count981_v0}"
    if [ "$(( count_num_14724 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_14724="$(( count_num_14724 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14724}
    __status=$?
}

# stty_unlock()
stty_unlock__983_v0() {
    stty_count__981_v0 
    local count_num_14819="${ret_stty_count981_v0}"
    if [ "$(( count_num_14819 > 0 ))" != 0 ]; then
        count_num_14819="$(( count_num_14819 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14819}
        __status=$?
        if [ "$(( count_num_14819 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__984_v0() {
    local size_14649="${1}"
    if [ "$([ "_${size_14649}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size984_v0=0
        return 0
    fi
    split__4_v0 "${size_14649}" " "
    local parts_14650=("${ret_split4_v0[@]}")
    local __length_161=("${parts_14650[@]}")
    if [ "$(( ${#__length_161[@]} != 2 ))" != 0 ]; then
        ret_store_term_size984_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_14650[1]?"Index out of bounds (at src/./choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_14650[0]?"Index out of bounds (at src/./choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_35=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size984_v0=1
    return 0
}

# query_term_size()
query_term_size__985_v0() {
    local command_163
    command_163="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_14652="${command_163}"
    store_term_size__984_v0 "${size_14652}"
    ret_query_term_size985_v0="${ret_store_term_size984_v0}"
    return 0
}

# stty_term_size()
stty_term_size__986_v0() {
    local command_164
    command_164="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_14648="${command_164}"
    store_term_size__984_v0 "${size_14648}"
    ret_stty_term_size986_v0="${ret_store_term_size984_v0}"
    return 0
}

# get_term_size()
get_term_size__987_v0() {
    stty_term_size__986_v0 
    local detected_14651="${ret_stty_term_size986_v0}"
    if [ "$(( ! detected_14651 ))" != 0 ]; then
        query_term_size__985_v0 
        detected_14651="${ret_query_term_size985_v0}"
    fi
    _got_term_size_34=1
}

# term_width()
term_width__989_v0() {
    if [ "$(( ! _got_term_size_34 ))" != 0 ]; then
        get_term_size__987_v0 
    fi
    ret_term_width989_v0="${_term_size_35[0]?"Index out of bounds (at src/./choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__990_v0() {
    if [ "$(( ! _got_term_size_34 ))" != 0 ]; then
        get_term_size__987_v0 
    fi
    ret_term_height990_v0="${_term_size_35[1]?"Index out of bounds (at src/./choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_36="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_37=0
_primary_color_38=(3 207 159 92)
_secondary_color_39=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1000_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_14636="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_14636}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_36="No"
        ret_get_supports_truecolor1000_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_36="No"
        ret_get_supports_truecolor1000_v0=0
        return 0
    fi
    local colorterm_14637="${ret_env_var_get120_v0}"
    _supports_truecolor_36="$(if [ "$(( $([ "_${colorterm_14637}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_14637}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1000_v0="$([ "_${_supports_truecolor_36}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1001_v0() {
    local message_14631="${1}"
    local r_14632="${2}"
    local g_14633="${3}"
    local b_14634="${4}"
    local fallback_14635="${5}"
    if [ "$([ "_${_supports_truecolor_36}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1001_v0="\\x1b[38;2;${r_14632};${g_14633};${b_14634}m""${message_14631}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_36}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1000_v0 
        local ret_get_supports_truecolor1000_v0__50_17="${ret_get_supports_truecolor1000_v0}"
        if [ "${ret_get_supports_truecolor1000_v0__50_17}" != 0 ]; then
            ret_colored_rgb1001_v0="\\x1b[38;2;${r_14632};${g_14633};${b_14634}m""${message_14631}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_14635 == 0 ))" != 0 ]; then
            ret_colored_rgb1001_v0="${message_14631}"
            return 0
        else
            ret_colored_rgb1001_v0="\\x1b[${fallback_14635}m""${message_14631}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_14635 == 0 ))" != 0 ]; then
            ret_colored_rgb1001_v0="${message_14631}"
            return 0
        fi
        ret_colored_rgb1001_v0="\\x1b[${fallback_14635}m""${message_14631}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1003_v0() {
    if [ "$(( ! _got_xylitol_colors_37 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_14625="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_14625}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_14625}" ";"
            local parts_14626=("${ret_split4_v0[@]}")
            local __length_168=("${parts_14626[@]}")
            if [ "$(( ${#__length_168[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14626[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14626[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14626[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14626[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_38=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_14627="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_14627}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_14627}" ";"
            local parts_14628=("${ret_split4_v0[@]}")
            local __length_170=("${parts_14628[@]}")
            if [ "$(( ${#__length_170[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14628[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14628[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14628[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14628[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_39=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_14629="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_14629}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_14629}" ";"
            local parts_14630=("${ret_split4_v0[@]}")
            local __length_172=("${parts_14630[@]}")
            if [ "$(( ${#__length_172[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14630[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14630[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14630[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14630[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_37=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1004_v0() {
    inner_get_xylitol_colors__1003_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_37=1
}

# colored_primary(message: Text)
colored_primary__1005_v0() {
    local message_14624="${1}"
    if [ "$(( ! _got_xylitol_colors_37 ))" != 0 ]; then
        get_xylitol_colors__1004_v0 
    fi
    colored_rgb__1001_v0 "${message_14624}" "${_primary_color_38[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_38[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_38[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_38[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1005_v0="${ret_colored_rgb1001_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1006_v0() {
    local message_14669="${1}"
    if [ "$(( ! _got_xylitol_colors_37 ))" != 0 ]; then
        get_xylitol_colors__1004_v0 
    fi
    colored_rgb__1001_v0 "${message_14669}" "${_secondary_color_39[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_39[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_39[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_39[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1006_v0="${ret_colored_rgb1001_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1021_v0() {
    local command_174
    command_174="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_14797="${command_174}"
    if [ "$([ "_${var_14797}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="UP"
        return 0
    elif [ "$([ "_${var_14797}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="DOWN"
        return 0
    elif [ "$([ "_${var_14797}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_14797}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="LEFT"
        return 0
    elif [ "$([ "_${var_14797}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_14797}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="INPUT"
        return 0
    else
        ret_get_key1021_v0="${var_14797}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1023_v0() {
    local format_14706="${1}"
    local args_14707=("${!2}")
    args_14707=("${format_14706}" "${args_14707[@]}")
    __status=$?
    printf "${args_14707[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1024_v0() {
    local message_14704="${1}"
    local color_14705="${2}"
    # Prints an error message with a specified color.
    local array_175=("${message_14704}")
    eprintf__1023_v0 "\\x1b[${color_14705}m%s\\x1b[0m" array_175[@]
}

# colored(message: Text, color: Int)
colored__1025_v0() {
    local message_14698="${1}"
    local color_14699="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1025_v0="\\x1b[${color_14699}m""${message_14698}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1027_v0() {
    local cnt_14794="${1}"
    if [ "$(( cnt_14794 > 0 ))" != 0 ]; then
        local sequence_14795=""
        local __range_start_14796=0
        local __range_end_14796="${cnt_14794}"
        local __dir_14796=$(( ${__range_start_14796} <= ${__range_end_14796} ? 1 : -1 ))
        for (( ____14796=${__range_start_14796}; ____14796 * ${__dir_14796} < ${__range_end_14796} * ${__dir_14796}; ____14796+=${__dir_14796} )); do
            sequence_14795+="\\x1b[2K\\x1b[1A"
done
        local array_176=("")
        eprintf__1023_v0 "${sequence_14795}" array_176[@]
    fi
    local array_177=("")
    eprintf__1023_v0 "\\x1b[G" array_177[@]
}

# remove_current_line()
remove_current_line__1028_v0() {
    local array_178=("")
    eprintf__1023_v0 "\\x1b[2K\\x1b[G" array_178[@]
}

# print_blank(cnt: Int)
print_blank__1029_v0() {
    local cnt_14785="${1}"
    printf '%*s' "${cnt_14785}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1030_v0() {
    local cnt_14754="${1}"
    local __range_start_14755=0
    local __range_end_14755="${cnt_14754}"
    local __dir_14755=$(( ${__range_start_14755} <= ${__range_end_14755} ? 1 : -1 ))
    for (( ____14755=${__range_start_14755}; ____14755 * ${__dir_14755} < ${__range_end_14755} * ${__dir_14755}; ____14755+=${__dir_14755} )); do
        local array_179=("")
        eprintf__1023_v0 "
" array_179[@]
done
}

# go_up(cnt: Int)
go_up__1031_v0() {
    local cnt_14769="${1}"
    local array_180=("")
    eprintf__1023_v0 "\\x1b[${cnt_14769}A" array_180[@]
}

# go_down(cnt: Int)
go_down__1032_v0() {
    local cnt_14806="${1}"
    local array_181=("")
    eprintf__1023_v0 "\\x1b[${cnt_14806}B" array_181[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1033_v0() {
    local cnt_14815="${1}"
    if [ "$(( cnt_14815 > 0 ))" != 0 ]; then
        go_down__1032_v0 "${cnt_14815}"
    else
        go_up__1031_v0 "$(( - cnt_14815 ))"
    fi
}

# hide_cursor()
hide_cursor__1034_v0() {
    local array_182=("")
    eprintf__1023_v0 "\\x1b[?25l" array_182[@]
}

# show_cursor()
show_cursor__1035_v0() {
    local array_183=("")
    eprintf__1023_v0 "\\x1b[?25h" array_183[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1036_v0() {
    local text_14658="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_184
    command_184="$([[ "${text_14658}" == *$'\x1b'* || "${text_14658}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_14659="${command_184}"
    ret_has_ansi_escape1036_v0="$([ "_${has_escape_14659}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1037_v0() {
    local text_14709="${1}"
    local command_185
    command_185="$(printf '%s' "${text_14709}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1037_v0="${command_185}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1038_v0() {
    local text_14661="${1}"
    local command_186
    command_186="$(printf "%s" "${text_14661}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1038_v0="${command_186}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1039_v0() {
    local text_14663="${1}"
    local command_187
    command_187="$(printf "%s" "${text_14663}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_14664="${command_187}"
    ret_is_all_ascii1039_v0="$([ "_${result_14664}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1040_v0() {
    local text_14660="${1}"
    strip_ansi__1038_v0 "${text_14660}"
    local stripped_14662="${ret_strip_ansi1038_v0}"
    # Check if text is all ASCII
    is_all_ascii__1039_v0 "${stripped_14662}"
    local ret_is_all_ascii1039_v0__150_12="${ret_is_all_ascii1039_v0}"
    if [ "$(( ! ret_is_all_ascii1039_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__973_v0 "${stripped_14662}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_188="${stripped_14662}"
            ret_get_visible_len1040_v0="${#__length_188}"
            return 0
        fi
        ret_get_visible_len1040_v0="${ret_perl_get_cjk_width973_v0}"
        return 0
    else
        local __length_189="${stripped_14662}"
        ret_get_visible_len1040_v0="${#__length_189}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1041_v0() {
    local text_14732="${1}"
    local max_width_14733="${2}"
    get_visible_len__1040_v0 "${text_14732}"
    local visible_len_14734="${ret_get_visible_len1040_v0}"
    if [ "$(( visible_len_14734 <= max_width_14733 ))" != 0 ]; then
        ret_truncate_text1041_v0="${text_14732}"
        return 0
    fi
    is_all_ascii__1039_v0 "${text_14732}"
    local ret_is_all_ascii1039_v0__167_12="${ret_is_all_ascii1039_v0}"
    if [ "$(( ! ret_is_all_ascii1039_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__974_v0 "${text_14732}" "${max_width_14733}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_14732}" | cut -c1-${max_width_14733}
            __status=$?
        fi
        ret_truncate_text1041_v0="${ret_perl_truncate_cjk974_v0}"
        return 0
    fi
    local command_190
    command_190="$(printf "%s" "${text_14732}" | cut -c1-${max_width_14733})"
    __status=$?
    ret_truncate_text1041_v0="${command_190}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1042_v0() {
    local text_14730="${1}"
    local max_width_14731="${2}"
    has_ansi_escape__1036_v0 "${text_14730}"
    local ret_has_ansi_escape1036_v0__179_12="${ret_has_ansi_escape1036_v0}"
    if [ "$(( ! ret_has_ansi_escape1036_v0__179_12 ))" != 0 ]; then
        truncate_text__1041_v0 "${text_14730}" "${max_width_14731}"
        ret_truncate_ansi1042_v0="${ret_truncate_text1041_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_191
    command_191="$([[ "${text_14730}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_14738="${command_191}"
    # Replace \x1b[ with newline, then split
    local command_192
    command_192="$(t="${text_14730}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_14739="${command_192}"
    split__4_v0 "${replaced_14739}" "
"
    local parts_14740=("${ret_split4_v0[@]}")
    local result_14741=""
    local remaining_width_14742="${max_width_14731}"
    local __range_start_14743=0
    local __length_193=("${parts_14740[@]}")
    local __range_end_14743="${#__length_193[@]}"
    local __dir_14743=$(( ${__range_start_14743} <= ${__range_end_14743} ? 1 : -1 ))
    for (( idx_14743=${__range_start_14743}; idx_14743 * ${__dir_14743} < ${__range_end_14743} * ${__dir_14743}; idx_14743+=${__dir_14743} )); do
        local part_14744="${parts_14740[${idx_14743}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_14743 == 0 )) && $([ "_${starts_with_ansi_14738}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_14744}" == "_" ]; echo $?) && $(( remaining_width_14742 > 0 )) ))" != 0 ]; then
                truncate_text__1041_v0 "${part_14744}" "${remaining_width_14742}"
                local ret_truncate_text1041_v0__201_35="${ret_truncate_text1041_v0}"
                local truncated_14745="${ret_truncate_text1041_v0__201_35}"
                result_14741+="${truncated_14745}"
                get_visible_len__1040_v0 "${truncated_14745}"
                local ret_get_visible_len1040_v0__203_36="${ret_get_visible_len1040_v0}"
                remaining_width_14742="$(( remaining_width_14742 - ret_get_visible_len1040_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_194
            command_194="$(__p="${part_14744}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_14746="${command_194}"
            if [ "$([ "_${m_idx_14746}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_195
                command_195="$(__p="${part_14744}"; printf "%s" "${__p:0:${m_idx_14746}}")"
                __status=$?
                local ansi_params_14747="${command_195}"
                result_14741+="\\x1b[""${ansi_params_14747}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_14746}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_14748="${ret_parse_int13_v0__214_41}"
                local text_start_14749="$(( m_idx_num_14748 + 1 ))"
                local command_196
                command_196="$(__p="${part_14744}"; printf "%s" "${__p:${text_start_14749}}")"
                __status=$?
                local text_part_14750="${command_196}"
                if [ "$(( $([ "_${text_part_14750}" == "_" ]; echo $?) && $(( remaining_width_14742 > 0 )) ))" != 0 ]; then
                    truncate_text__1041_v0 "${text_part_14750}" "${remaining_width_14742}"
                    local ret_truncate_text1041_v0__218_39="${ret_truncate_text1041_v0}"
                    local truncated_14751="${ret_truncate_text1041_v0__218_39}"
                    result_14741+="${truncated_14751}"
                    get_visible_len__1040_v0 "${truncated_14751}"
                    local ret_get_visible_len1040_v0__220_40="${ret_get_visible_len1040_v0}"
                    remaining_width_14742="$(( remaining_width_14742 - ret_get_visible_len1040_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_14744}" == "_" ]; echo $?) && $(( remaining_width_14742 > 0 )) ))" != 0 ]; then
                    truncate_text__1041_v0 "${part_14744}" "${remaining_width_14742}"
                    local ret_truncate_text1041_v0__225_39="${ret_truncate_text1041_v0}"
                    local truncated_14752="${ret_truncate_text1041_v0__225_39}"
                    result_14741+="${truncated_14752}"
                    get_visible_len__1040_v0 "${truncated_14752}"
                    local ret_get_visible_len1040_v0__227_40="${ret_get_visible_len1040_v0}"
                    remaining_width_14742="$(( remaining_width_14742 - ret_get_visible_len1040_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1042_v0="${result_14741}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1043_v0() {
    local text_14727="${1}"
    local max_width_14728="${2}"
    get_visible_len__1040_v0 "${text_14727}"
    local visible_len_14729="${ret_get_visible_len1040_v0}"
    if [ "$(( visible_len_14729 <= max_width_14728 ))" != 0 ]; then
        ret_cutoff_text1043_v0="${text_14727}"
        return 0
    fi
    truncate_ansi__1042_v0 "${text_14727}" "$(( max_width_14728 - 3 ))"
    local ret_truncate_ansi1042_v0__243_12="${ret_truncate_ansi1042_v0}"
    ret_cutoff_text1043_v0="${ret_truncate_ansi1042_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1044_v0() {
    local items_14756=("${!1}")
    local total_len_14757="${2}"
    local term_width_14758="${3}"
    local separator_14759=" • "
    local separator_len_14760=3
    # Fast path: no truncation needed
    if [ "$(( total_len_14757 <= term_width_14758 ))" != 0 ]; then
        local iter_14761=0
        while :
        do
            local __length_197=("${items_14756[@]}")
            if [ "$(( iter_14761 >= ${#__length_197[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_14761 > 0 ))" != 0 ]; then
                eprintf_colored__1024_v0 "${separator_14759}" 90
            fi
            colored__1025_v0 "${items_14756[$(( iter_14761 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1025_v0__268_41="${ret_colored1025_v0}"
            local array_198=("")
            eprintf__1023_v0 "${items_14756[${iter_14761}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1025_v0__268_41}" array_198[@]
            iter_14761="$(( iter_14761 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_14762=0
        local first_14763=1
        local iter_14764=0
        while :
        do
            local __length_199=("${items_14756[@]}")
            if [ "$(( iter_14764 >= ${#__length_199[@]} ))" != 0 ]; then
                break
            fi
            local key_14765="${items_14756[${iter_14764}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_14766="${items_14756[$(( iter_14764 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_200="${key_14765}"
            local __length_201="${action_14766}"
            local part_len_14767="$(( $(( ${#__length_200} + 1 )) + ${#__length_201} ))"
            local needed_14768="${part_len_14767}"
            if [ "$(( ! first_14763 ))" != 0 ]; then
                needed_14768="$(( needed_14768 + separator_len_14760 ))"
            fi
            if [ "$(( $(( current_len_14762 + needed_14768 )) > term_width_14758 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_14763 ))" != 0 ]; then
                eprintf_colored__1024_v0 "${separator_14759}" 90
            fi
            colored__1025_v0 "${action_14766}" 2
            local ret_colored1025_v0__296_33="${ret_colored1025_v0}"
            local array_202=("")
            eprintf__1023_v0 "${key_14765}"" ""${ret_colored1025_v0__296_33}" array_202[@]
            current_len_14762="$(( current_len_14762 + needed_14768 ))"
            first_14763=0
            iter_14764="$(( iter_14764 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1045_v0() {
    local pending_14695="${1}"
    local line_14696="${2}"
    local note_at_14697="${3}"
    if [ "$(( note_at_14697 < 0 ))" != 0 ]; then
        local array_203=()
        printf__128_v0 "${pending_14695}""${line_14696}""
" array_203[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_14697 == 0 ))" != 0 ]; then
        colored__1025_v0 "${line_14696}" 90
        local ret_colored1025_v0__310_40="${ret_colored1025_v0}"
        local array_204=()
        printf__128_v0 "${pending_14695}""${ret_colored1025_v0__310_40}""
" array_204[@]
    else
        slice__24_v0 "${line_14696}" 0 "${note_at_14697}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_14696}" "${note_at_14697}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1025_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1025_v0__311_58="${ret_colored1025_v0}"
        local array_205=()
        printf__128_v0 "${pending_14695}""${ret_slice24_v0__311_32}""${ret_colored1025_v0__311_58}""
" array_205[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1046_v0() {
    local names_14673=("${!1}")
    local texts_14674=("${!2}")
    local notes_14675=("${!3}")
    local min_name_width_14676="${4}"
    local __length_206=("${names_14673[@]}")
    local count_14677="${#__length_206[@]}"
    local name_width_14678="${min_name_width_14676}"
    local __range_start_14679=0
    local __range_end_14679="${count_14677}"
    local __dir_14679=$(( ${__range_start_14679} <= ${__range_end_14679} ? 1 : -1 ))
    for (( i_14679=${__range_start_14679}; i_14679 * ${__dir_14679} < ${__range_end_14679} * ${__dir_14679}; i_14679+=${__dir_14679} )); do
        local __length_207="${names_14673[${i_14679}]?"Index out of bounds (at src/./choose/../utils.ab:326:33)"}"
        local width_14680="${#__length_207}"
        if [ "$(( width_14680 > name_width_14678 ))" != 0 ]; then
            name_width_14678="${width_14680}"
        fi
done
    term_width__989_v0 
    local width_14681="${ret_term_width989_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_14682="$(( name_width_14678 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_14683="$(( $(( width_14681 - indent_14682 )) < 24 ))"
    if [ "${stacked_14683}" != 0 ]; then
        indent_14682=6
    fi
    local avail_14684="$(( width_14681 - indent_14682 ))"
    rpad__28_v0 "" " " "${indent_14682}"
    local blank_14685="${ret_rpad28_v0}"
    local __range_start_14686=0
    local __range_end_14686="${count_14677}"
    local __dir_14686=$(( ${__range_start_14686} <= ${__range_end_14686} ? 1 : -1 ))
    for (( i_14686=${__range_start_14686}; i_14686 * ${__dir_14686} < ${__range_end_14686} * ${__dir_14686}; i_14686+=${__dir_14686} )); do
        local pending_14687="${blank_14685}"
        if [ "${stacked_14683}" != 0 ]; then
            local array_208=()
            printf__128_v0 "  ""${names_14673[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:346:33)"}""
" array_208[@]
        else
            rpad__28_v0 "  ""${names_14673[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:348:41)"}" " " "${indent_14682}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_14687="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_14674[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_14688=("${ret_split4_v0__350_21[@]}")
        local __length_209=("${words_14688[@]}")
        local note_start_14689="${#__length_209[@]}"
        if [ "$([ "_${notes_14675[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_210="${notes_14675[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_210} > avail_14684 ))" != 0 ]; then
                split__4_v0 "${notes_14675[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_14688+=("${ret_split4_v0__356_26[@]}")
            else
                local array_211=("${notes_14675[${i_14686}]?"Index out of bounds (at src/./choose/../utils.ab:358:33)"}")
                words_14688+=("${array_211[@]}")
            fi
        fi
        local line_14690=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_14691=-1
        local __range_start_14692=0
        local __length_212=("${words_14688[@]}")
        local __range_end_14692="${#__length_212[@]}"
        local __dir_14692=$(( ${__range_start_14692} <= ${__range_end_14692} ? 1 : -1 ))
        for (( j_14692=${__range_start_14692}; j_14692 * ${__dir_14692} < ${__range_end_14692} * ${__dir_14692}; j_14692+=${__dir_14692} )); do
            local word_14693="${words_14688[${j_14692}]?"Index out of bounds (at src/./choose/../utils.ab:368:32)"}"
            local candidate_14694
            candidate_14694="$(if [ "$([ "_${line_14690}" != "_" ]; echo $?)" != 0 ]; then echo "${word_14693}"; else echo "${line_14690}"" ""${word_14693}"; fi)"
            local __length_213="${candidate_14694}"
            if [ "$(( $(( ${#__length_213} > avail_14684 )) && $([ "_${line_14690}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1045_v0 "${pending_14687}" "${line_14690}" "${note_at_14691}"
                pending_14687="${blank_14685}"
                line_14690="${word_14693}"
                note_at_14691="$(if [ "$(( j_14692 >= note_start_14689 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_14692 >= note_start_14689 )) && $(( note_at_14691 < 0 )) ))" != 0 ]; then
                    local __length_214="${candidate_14694}"
                    local __length_215="${word_14693}"
                    note_at_14691="$(( ${#__length_214} - ${#__length_215} ))"
                fi
                line_14690="${candidate_14694}"
            fi
done
        print_help_line__1045_v0 "${pending_14687}" "${line_14690}" "${note_at_14691}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1047_v0() {
    local pieces_14647=("${!1}")
    term_width__989_v0 
    local width_14653="${ret_term_width989_v0}"
    local line_14654=""
    local line_len_14655=0
    for piece_14656 in "${pieces_14647[@]}"; do
        local __length_218="${piece_14656}"
        local piece_len_14657="${#__length_218}"
        has_ansi_escape__1036_v0 "${piece_14656}"
        local ret_has_ansi_escape1036_v0__397_12="${ret_has_ansi_escape1036_v0}"
        if [ "${ret_has_ansi_escape1036_v0__397_12}" != 0 ]; then
            get_visible_len__1040_v0 "${piece_14656}"
            piece_len_14657="${ret_get_visible_len1040_v0}"
        fi
        if [ "$([ "_${line_14654}" != "_" ]; echo $?)" != 0 ]; then
            line_14654="${piece_14656}"
            line_len_14655="${piece_len_14657}"
        elif [ "$(( $(( $(( line_len_14655 + 1 )) + piece_len_14657 )) > width_14653 ))" != 0 ]; then
            local array_219=()
            printf__128_v0 "${line_14654}""
" array_219[@]
            line_14654="${piece_14656}"
            line_len_14655="${piece_len_14657}"
        else
            line_14654+=" ""${piece_14656}"
            line_len_14655="$(( line_len_14655 + $(( 1 + piece_len_14657 )) ))"
        fi
    done
    if [ "$([ "_${line_14654}" == "_" ]; echo $?)" != 0 ]; then
        local array_220=()
        printf__128_v0 "${line_14654}""
" array_220[@]
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
__CHOOSER_CONTINUE_43=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_44=1
# The user confirmed the selection.
__CHOOSER_DONE_45=2
_total_46=0
_page_size_47=10
_display_count_48=0
_total_pages_49=1
_current_page_50=0
_selected_51=0
_cursor_52="> "
_multi_53=0
_limit_54=-1
_term_width_55=80
_has_header_56=0
_page_57=()
_page_count_58=0
_checked_59=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_60=0
_first_render_61=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_62=0
# render_single_page()
render_single_page__1195_v0() {
    local __length_223="${_cursor_52}"
    local cursor_len_14788="${#__length_223}"
    local max_option_width_14789="$(( $(( _term_width_55 - cursor_len_14788 )) - 1 ))"
    local __range_start_14790=0
    local __range_end_14790="${_page_count_58}"
    local __dir_14790=$(( ${__range_start_14790} <= ${__range_end_14790} ? 1 : -1 ))
    for (( i_14790=${__range_start_14790}; i_14790 * ${__dir_14790} < ${__range_end_14790} * ${__dir_14790}; i_14790+=${__dir_14790} )); do
        cutoff_text__1043_v0 "${_page_57[${i_14790}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_14789}"
        local ret_cutoff_text1043_v0__48_27="${ret_cutoff_text1043_v0}"
        local truncated_14791="${ret_cutoff_text1043_v0__48_27}"
        if [ "$(( i_14790 == _selected_51 ))" != 0 ]; then
            colored_secondary__1006_v0 "${_cursor_52}""${truncated_14791}""
"
            local ret_colored_secondary1006_v0__50_21="${ret_colored_secondary1006_v0}"
            local array_224=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__50_21}" array_224[@]
        else
            print_blank__1029_v0 "${cursor_len_14788}"
            local array_225=("")
            eprintf__1023_v0 "${truncated_14791}""
" array_225[@]
        fi
done
    local remaining_slots_14792="$(( _display_count_48 - _page_count_58 ))"
    if [ "$(( remaining_slots_14792 > 0 ))" != 0 ]; then
        local __range_start_14793=0
        local __range_end_14793="${remaining_slots_14792}"
        local __dir_14793=$(( ${__range_start_14793} <= ${__range_end_14793} ? 1 : -1 ))
        for (( ____14793=${__range_start_14793}; ____14793 * ${__dir_14793} < ${__range_end_14793} * ${__dir_14793}; ____14793+=${__dir_14793} )); do
            local array_226=("")
            eprintf__1023_v0 "\\x1b[K
" array_226[@]
done
    fi
}

# render_multi_page()
render_multi_page__1196_v0() {
    local __length_227="${_cursor_52}"
    local cursor_len_14778="${#__length_227}"
    local max_option_width_14779="$(( $(( _term_width_55 - cursor_len_14778 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1201_v0 
    local page_start_14780="${ret_chooser_page_start1201_v0}"
    local __range_start_14781=0
    local __range_end_14781="${_page_count_58}"
    local __dir_14781=$(( ${__range_start_14781} <= ${__range_end_14781} ? 1 : -1 ))
    for (( i_14781=${__range_start_14781}; i_14781 * ${__dir_14781} < ${__range_end_14781} * ${__dir_14781}; i_14781+=${__dir_14781} )); do
        local global_idx_14782="$(( page_start_14780 + i_14781 ))"
        local check_mark_14783
        check_mark_14783="$(if [ "${_checked_59[${global_idx_14782}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1043_v0 "${_page_57[${i_14781}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_14779}"
        local ret_cutoff_text1043_v0__71_27="${ret_cutoff_text1043_v0}"
        local truncated_14784="${ret_cutoff_text1043_v0__71_27}"
        if [ "$(( i_14781 == _selected_51 ))" != 0 ]; then
            colored_secondary__1006_v0 "${_cursor_52}""${check_mark_14783}""${truncated_14784}""
"
            local ret_colored_secondary1006_v0__73_37="${ret_colored_secondary1006_v0}"
            local array_228=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__73_37}" array_228[@]
        elif [ "${_checked_59[${global_idx_14782}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1029_v0 "${cursor_len_14778}"
            colored_secondary__1006_v0 "${check_mark_14783}""${truncated_14784}""
"
            local ret_colored_secondary1006_v0__76_25="${ret_colored_secondary1006_v0}"
            local array_229=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__76_25}" array_229[@]
        else
            print_blank__1029_v0 "${cursor_len_14778}"
            local array_230=("")
            eprintf__1023_v0 "${check_mark_14783}""${truncated_14784}""
" array_230[@]
        fi
done
    local remaining_slots_14786="$(( _display_count_48 - _page_count_58 ))"
    if [ "$(( remaining_slots_14786 > 0 ))" != 0 ]; then
        local __range_start_14787=0
        local __range_end_14787="${remaining_slots_14786}"
        local __dir_14787=$(( ${__range_start_14787} <= ${__range_end_14787} ? 1 : -1 ))
        for (( ____14787=${__range_start_14787}; ____14787 * ${__dir_14787} < ${__range_end_14787} * ${__dir_14787}; ____14787+=${__dir_14787} )); do
            local array_231=("")
            eprintf__1023_v0 "\\x1b[K
" array_231[@]
done
    fi
}

# render_page()
render_page__1197_v0() {
    if [ "${_multi_53}" != 0 ]; then
        render_multi_page__1196_v0 
    else
        render_single_page__1195_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1198_v0() {
    if [ "$(( _total_pages_49 > 1 ))" != 0 ]; then
        local array_232=("")
        eprintf__1023_v0 "\\x1b[G\\x1b[K" array_232[@]
        eprintf_colored__1024_v0 "Page $(( _current_page_50 + 1 ))/${_total_pages_49}" 90
        local array_233=("")
        eprintf__1023_v0 "\\x1b[G" array_233[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1199_v0() {
    if [ "$(( ! _multi_53 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_49 > 1 ))" != 0 ]; then
            local array_234=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1044_v0 array_234[@] 36 "${_term_width_55}"
        else
            local array_235=("↑↓" "select" "enter" "confirm")
            render_tooltip__1044_v0 array_235[@] 25 "${_term_width_55}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_49 > 1 )) && $(( _limit_54 < 0 )) ))" != 0 ]; then
            local array_236=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1044_v0 array_236[@] 55 "${_term_width_55}"
        elif [ "$(( _total_pages_49 > 1 ))" != 0 ]; then
            local array_237=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1044_v0 array_237[@] 47 "${_term_width_55}"
        elif [ "$(( _limit_54 < 0 ))" != 0 ]; then
            local array_238=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1044_v0 array_238[@] 44 "${_term_width_55}"
        else
            local array_239=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1044_v0 array_239[@] 36 "${_term_width_55}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1200_v0() {
    local total_14717="${1}"
    local page_size_14718="${2}"
    local header_14719="${3}"
    local cursor_14720="${4}"
    local multi_14721="${5}"
    local limit_14722="${6}"
    _total_46="${total_14717}"
    _cursor_52="${cursor_14720}"
    _multi_53="${multi_14721}"
    _limit_54="${limit_14722}"
    _current_page_50=0
    _selected_51=0
    _first_render_61=1
    _up_paged_62=0
    _checked_count_60=0
    _has_header_56="$([ "_${header_14719}" == "_" ]; echo $?)"
    stty_lock__982_v0 
    hide_cursor__1034_v0 
    term_width__989_v0 
    _term_width_55="${ret_term_width989_v0}"
    term_height__990_v0 
    local term_height_14725="${ret_term_height990_v0}"
    local max_page_size_14726
    max_page_size_14726="$(( term_height_14725 - $(if [ "${_has_header_56}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_47="${page_size_14718}"
    if [ "$(( _page_size_47 > max_page_size_14726 ))" != 0 ]; then
        _page_size_47="${max_page_size_14726}"
    fi
    if [ "${_has_header_56}" != 0 ]; then
        cutoff_text__1043_v0 "${header_14719}" "${_term_width_55}"
        local ret_cutoff_text1043_v0__157_17="${ret_cutoff_text1043_v0}"
        local array_240=("")
        eprintf__1023_v0 "${ret_cutoff_text1043_v0__157_17}""
" array_240[@]
    fi
    math_floor__509_v0 "$(( $(( $(( total_14717 + _page_size_47 )) - 1 )) / _page_size_47 ))"
    _total_pages_49="${ret_math_floor509_v0}"
    _display_count_48="${_page_size_47}"
    if [ "$(( total_14717 < _page_size_47 ))" != 0 ]; then
        _display_count_48="${total_14717}"
    fi
    if [ "${multi_14721}" != 0 ]; then
        _checked_59=()
        local __range_start_14753=0
        local __range_end_14753="${total_14717}"
        local __dir_14753=$(( ${__range_start_14753} <= ${__range_end_14753} ? 1 : -1 ))
        for (( ____14753=${__range_start_14753}; ____14753 * ${__dir_14753} < ${__range_end_14753} * ${__dir_14753}; ____14753+=${__dir_14753} )); do
            local array_242=(0)
            _checked_59+=("${array_242[@]}")
done
    fi
    new_line__1030_v0 "${_display_count_48}"
    local array_243=("")
    eprintf__1023_v0 "\\x1b[G" array_243[@]
    if [ "$(( _total_pages_49 > 1 ))" != 0 ]; then
        eprintf_colored__1024_v0 "Page $(( _current_page_50 + 1 ))/${_total_pages_49}" 90
    fi
    new_line__1030_v0 1
    render_tooltip_line__1199_v0 
    go_up__1031_v0 "$(( _display_count_48 + 1 ))"
    local array_244=("")
    eprintf__1023_v0 "\\x1b[G" array_244[@]
}

# chooser_page_start()
chooser_page_start__1201_v0() {
    ret_chooser_page_start1201_v0="$(( _current_page_50 * _page_size_47 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1202_v0() {
    chooser_page_start__1201_v0 
    local start_14773="${ret_chooser_page_start1201_v0}"
    local end_14774="$(( start_14773 + _page_size_47 ))"
    if [ "$(( end_14774 > _total_46 ))" != 0 ]; then
        end_14774="${_total_46}"
    fi
    ret_chooser_page_count1202_v0="$(( end_14774 - start_14773 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1203_v0() {
    local page_14777=("${!1}")
    _page_57=("${page_14777[@]}")
    local __length_245=("${page_14777[@]}")
    _page_count_58="${#__length_245[@]}"
    if [ "${_first_render_61}" != 0 ]; then
        _first_render_61=0
        render_page__1197_v0 
    else
        if [ "${_up_paged_62}" != 0 ]; then
            _selected_51="$(( _page_count_58 - 1 ))"
            _up_paged_62=0
        fi
        go_up__1031_v0 1
        remove_line__1027_v0 "$(( _display_count_48 - 1 ))"
        remove_current_line__1028_v0 
        local array_246=("")
        eprintf__1023_v0 "\\x1b[G" array_246[@]
        render_page__1197_v0 
        render_page_indicator__1198_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1204_v0() {
    local prev_selected_14809="${1}"
    chooser_page_start__1201_v0 
    local page_start_14810="${ret_chooser_page_start1201_v0}"
    local check_width_14811
    check_width_14811="$(if [ "${_multi_53}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_247="${_cursor_52}"
    local max_option_width_14812="$(( $(( _term_width_55 - ${#__length_247} )) - check_width_14811 ))"
    go_up__1031_v0 "$(( _display_count_48 - prev_selected_14809 ))"
    local array_248=("")
    eprintf__1023_v0 "\\x1b[K" array_248[@]
    local __length_249="${_cursor_52}"
    print_blank__1029_v0 "${#__length_249}"
    if [ "${_multi_53}" != 0 ]; then
        local was_checked_14813="${_checked_59[$(( page_start_14810 + prev_selected_14809 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1043_v0 "${_page_57[${prev_selected_14809}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_14812}"
        local ret_cutoff_text1043_v0__232_63="${ret_cutoff_text1043_v0}"
        local prev_line_14814
        prev_line_14814="$(if [ "${was_checked_14813}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1043_v0__232_63}"
        if [ "${was_checked_14813}" != 0 ]; then
            colored_secondary__1006_v0 "${prev_line_14814}"
            local ret_colored_secondary1006_v0__234_21="${ret_colored_secondary1006_v0}"
            local array_250=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__234_21}" array_250[@]
        else
            local array_251=("")
            eprintf__1023_v0 "${prev_line_14814}" array_251[@]
        fi
    else
        cutoff_text__1043_v0 "${_page_57[${prev_selected_14809}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_14812}"
        local ret_cutoff_text1043_v0__239_17="${ret_cutoff_text1043_v0}"
        local array_252=("")
        eprintf__1023_v0 "${ret_cutoff_text1043_v0__239_17}" array_252[@]
    fi
    go_up_or_down__1033_v0 "$(( _selected_51 - prev_selected_14809 ))"
    local array_253=("")
    eprintf__1023_v0 "\\x1b[G" array_253[@]
    local array_254=("")
    eprintf__1023_v0 "\\x1b[K" array_254[@]
    local mark_14816
    mark_14816="$(if [ "${_multi_53}" != 0 ]; then echo "$(if [ "${_checked_59[$(( page_start_14810 + _selected_51 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1043_v0 "${_page_57[${_selected_51}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_14812}"
    local ret_cutoff_text1043_v0__246_48="${ret_cutoff_text1043_v0}"
    colored_secondary__1006_v0 "${_cursor_52}""${mark_14816}""${ret_cutoff_text1043_v0__246_48}"
    local ret_colored_secondary1006_v0__246_13="${ret_colored_secondary1006_v0}"
    local array_255=("")
    eprintf__1023_v0 "${ret_colored_secondary1006_v0__246_13}" array_255[@]
    go_down__1032_v0 "$(( _display_count_48 - _selected_51 ))"
    local array_256=("")
    eprintf__1023_v0 "\\x1b[G" array_256[@]
}

# redraw_current_line()
redraw_current_line__1205_v0() {
    chooser_page_start__1201_v0 
    local page_start_14803="${ret_chooser_page_start1201_v0}"
    local __length_257="${_cursor_52}"
    local max_option_width_14804="$(( $(( _term_width_55 - ${#__length_257} )) - 3 ))"
    go_up__1031_v0 "$(( _display_count_48 - _selected_51 ))"
    local array_258=("")
    eprintf__1023_v0 "\\x1b[G" array_258[@]
    local array_259=("")
    eprintf__1023_v0 "\\x1b[K" array_259[@]
    local check_mark_14805
    check_mark_14805="$(if [ "${_checked_59[$(( page_start_14803 + _selected_51 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1043_v0 "${_page_57[${_selected_51}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_14804}"
    local ret_cutoff_text1043_v0__260_54="${ret_cutoff_text1043_v0}"
    colored_secondary__1006_v0 "${_cursor_52}""${check_mark_14805}""${ret_cutoff_text1043_v0__260_54}"
    local ret_colored_secondary1006_v0__260_13="${ret_colored_secondary1006_v0}"
    local array_260=("")
    eprintf__1023_v0 "${ret_colored_secondary1006_v0__260_13}" array_260[@]
    go_down__1032_v0 "$(( _display_count_48 - _selected_51 ))"
    local array_261=("")
    eprintf__1023_v0 "\\x1b[G" array_261[@]
}

# chooser_step()
chooser_step__1206_v0() {
    get_key__1021_v0 
    local key_14798="${ret_get_key1021_v0}"
    local prev_selected_14799="${_selected_51}"
    local prev_page_14800="${_current_page_50}"
    chooser_page_start__1201_v0 
    local page_start_14801="${ret_chooser_page_start1201_v0}"
    _up_paged_62=0
    if [ "$(( $([ "_${key_14798}" != "_UP" ]; echo $?) || $([ "_${key_14798}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_51 == 0 )) && $(( _total_pages_49 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_50 > 0 ))" != 0 ]; then
                _current_page_50="$(( _current_page_50 - 1 ))"
            else
                _current_page_50="$(( _total_pages_49 - 1 ))"
            fi
            _up_paged_62=1
        elif [ "$(( _selected_51 == 0 ))" != 0 ]; then
            _selected_51="$(( _page_count_58 - 1 ))"
        else
            _selected_51="$(( _selected_51 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_14798}" != "_DOWN" ]; echo $?) || $([ "_${key_14798}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_51 == $(( _page_count_58 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_50 < $(( _total_pages_49 - 1 )) ))" != 0 ]; then
                _current_page_50="$(( _current_page_50 + 1 ))"
            else
                _current_page_50=0
            fi
            _selected_51=0
        else
            _selected_51="$(( _selected_51 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_14798}" != "_LEFT" ]; echo $?) || $([ "_${key_14798}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_50 > 0 ))" != 0 ]; then
            _current_page_50="$(( _current_page_50 - 1 ))"
        fi
        _selected_51=0
    elif [ "$(( $([ "_${key_14798}" != "_RIGHT" ]; echo $?) || $([ "_${key_14798}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_50 < $(( _total_pages_49 - 1 )) ))" != 0 ]; then
            _current_page_50="$(( _current_page_50 + 1 ))"
            _selected_51=0
        else
            _selected_51="$(( _page_count_58 - 1 ))"
        fi
    elif [ "$(( _multi_53 && $(( $([ "_${key_14798}" != "_x" ]; echo $?) || $([ "_${key_14798}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_14802="$(( page_start_14801 + _selected_51 ))"
        if [ "${_checked_59[${global_selected_14802}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_59["${global_selected_14802}"]=0
            _checked_count_60="$(( _checked_count_60 - 1 ))"
        elif [ "$(( $(( _limit_54 < 0 )) || $(( _checked_count_60 < _limit_54 )) ))" != 0 ]; then
            _checked_59["${global_selected_14802}"]=1
            _checked_count_60="$(( _checked_count_60 + 1 ))"
        else
            ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
            return 0
        fi
        redraw_current_line__1205_v0 
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
        return 0
    elif [ "$(( $(( _multi_53 && $(( $([ "_${key_14798}" != "_a" ]; echo $?) || $([ "_${key_14798}" != "_A" ]; echo $?) )) )) && $(( _limit_54 < 0 )) ))" != 0 ]; then
        local all_checked_14807="$(( _checked_count_60 == _total_46 ))"
        local __range_start_14808=0
        local __range_end_14808="${_total_46}"
        local __dir_14808=$(( ${__range_start_14808} <= ${__range_end_14808} ? 1 : -1 ))
        for (( i_14808=${__range_start_14808}; i_14808 * ${__dir_14808} < ${__range_end_14808} * ${__dir_14808}; i_14808+=${__dir_14808} )); do
            _checked_59["${i_14808}"]="$(( ! all_checked_14807 ))"
done
        _checked_count_60="$(if [ "${all_checked_14807}" != 0 ]; then echo 0; else echo "${_total_46}"; fi)"
        go_up__1031_v0 "${_display_count_48}"
        local array_262=("")
        eprintf__1023_v0 "\\x1b[G" array_262[@]
        render_page__1197_v0 
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
        return 0
    elif [ "$([ "_${key_14798}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1206_v0="${__CHOOSER_DONE_45}"
        return 0
    else
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
        return 0
    fi
    if [ "$(( prev_page_14800 != _current_page_50 ))" != 0 ]; then
        ret_chooser_step1206_v0="${__CHOOSER_NEED_PAGE_44}"
        return 0
    fi
    if [ "$(( prev_selected_14799 != _selected_51 ))" != 0 ]; then
        redraw_selection__1204_v0 "${prev_selected_14799}"
    fi
    ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
    return 0
}

# chooser_selected()
chooser_selected__1207_v0() {
    chooser_page_start__1201_v0 
    local ret_chooser_page_start1201_v0__362_12="${ret_chooser_page_start1201_v0}"
    ret_chooser_selected1207_v0="$(( ret_chooser_page_start1201_v0__362_12 + _selected_51 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1208_v0() {
    local index_14822="${1}"
    ret_chooser_is_checked1208_v0="${_checked_59[${index_14822}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1209_v0() {
    local total_lines_14818="$(( _display_count_48 + 2 ))"
    if [ "${_has_header_56}" != 0 ]; then
        total_lines_14818="$(( total_lines_14818 + 1 ))"
    fi
    go_down__1032_v0 1
    remove_line__1027_v0 "$(( total_lines_14818 - 1 ))"
    remove_current_line__1028_v0 
    stty_unlock__983_v0 
    show_cursor__1035_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1218_v0() {
    local options_14826=("${!1}")
    local cursor_14827="${2}"
    local header_14828="${3}"
    local page_size_14829="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_263=("${options_14826[@]}")
    local total_14830="${#__length_263[@]}"
    if [ "$(( total_14830 == 0 ))" != 0 ]; then
        eprintf_colored__1024_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1200_v0 "${total_14830}" "${page_size_14829}" "${header_14828}" "${cursor_14827}" 0 -1
    local need_page_14831=1
    while :
    do
        if [ "${need_page_14831}" != 0 ]; then
            local page_14832=()
            chooser_page_start__1201_v0 
            local start_14833="${ret_chooser_page_start1201_v0}"
            chooser_page_count__1202_v0 
            local count_14834="${ret_chooser_page_count1202_v0}"
            local __range_start_14835="${start_14833}"
            local __range_end_14835="$(( start_14833 + count_14834 ))"
            local __dir_14835=$(( ${__range_start_14835} <= ${__range_end_14835} ? 1 : -1 ))
            for (( i_14835=${__range_start_14835}; i_14835 * ${__dir_14835} < ${__range_end_14835} * ${__dir_14835}; i_14835+=${__dir_14835} )); do
                local array_265=("${options_14826[${i_14835}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_14832+=("${array_265[@]}")
done
            chooser_set_page__1203_v0 page_14832[@]
        fi
        chooser_step__1206_v0 
        local step_14836="${ret_chooser_step1206_v0}"
        if [ "$(( step_14836 == __CHOOSER_DONE_45 ))" != 0 ]; then
            break
        fi
        need_page_14831="$(( step_14836 == __CHOOSER_NEED_PAGE_44 ))"
    done
    chooser_selected__1207_v0 
    local selected_14837="${ret_chooser_selected1207_v0}"
    chooser_end__1209_v0 
    ret_xyl_choose1218_v0="${options_14826[${selected_14837}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1219_v0() {
    local options_14711=("${!1}")
    local cursor_14712="${2}"
    local header_14713="${3}"
    local limit_14714="${4}"
    local page_size_14715="${5}"
    local __length_266=("${options_14711[@]}")
    local total_14716="${#__length_266[@]}"
    if [ "$(( total_14716 == 0 ))" != 0 ]; then
        eprintf_colored__1024_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1219_v0=()
        return 0
    fi
    chooser_begin__1200_v0 "${total_14716}" "${page_size_14715}" "${header_14713}" "${cursor_14712}" 1 "${limit_14714}"
    local need_page_14770=1
    while :
    do
        if [ "${need_page_14770}" != 0 ]; then
            local page_14771=()
            chooser_page_start__1201_v0 
            local start_14772="${ret_chooser_page_start1201_v0}"
            chooser_page_count__1202_v0 
            local count_14775="${ret_chooser_page_count1202_v0}"
            local __range_start_14776="${start_14772}"
            local __range_end_14776="$(( start_14772 + count_14775 ))"
            local __dir_14776=$(( ${__range_start_14776} <= ${__range_end_14776} ? 1 : -1 ))
            for (( i_14776=${__range_start_14776}; i_14776 * ${__dir_14776} < ${__range_end_14776} * ${__dir_14776}; i_14776+=${__dir_14776} )); do
                local array_269=("${options_14711[${i_14776}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_14771+=("${array_269[@]}")
done
            chooser_set_page__1203_v0 page_14771[@]
        fi
        chooser_step__1206_v0 
        local step_14817="${ret_chooser_step1206_v0}"
        if [ "$(( step_14817 == __CHOOSER_DONE_45 ))" != 0 ]; then
            break
        fi
        need_page_14770="$(( step_14817 == __CHOOSER_NEED_PAGE_44 ))"
    done
    chooser_end__1209_v0 
    local result_14820=()
    local __range_start_14821=0
    local __range_end_14821="${total_14716}"
    local __dir_14821=$(( ${__range_start_14821} <= ${__range_end_14821} ? 1 : -1 ))
    for (( i_14821=${__range_start_14821}; i_14821 * ${__dir_14821} < ${__range_end_14821} * ${__dir_14821}; i_14821+=${__dir_14821} )); do
        chooser_is_checked__1208_v0 "${i_14821}"
        local ret_chooser_is_checked1208_v0__93_12="${ret_chooser_is_checked1208_v0}"
        if [ "${ret_chooser_is_checked1208_v0__93_12}" != 0 ]; then
            local array_271=("${options_14711[${i_14821}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_14820+=("${array_271[@]}")
        fi
done
    ret_xyl_multi_choose1219_v0=("${result_14820[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1314_v0() {
    local usage_14646=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1047_v0 usage_14646[@]
    printf '%s\n' ""
    colored_primary__1005_v0 "choose"
    local ret_colored_primary1005_v0__8_20="${ret_colored_primary1005_v0}"
    local title_14668=("${ret_colored_primary1005_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1047_v0 title_14668[@]
    printf '%s\n' ""
    colored_secondary__1006_v0 "Arguments:"
    local ret_colored_secondary1006_v0__11_12="${ret_colored_secondary1006_v0}"
    local array_274=()
    printf__128_v0 "${ret_colored_secondary1006_v0__11_12}""
" array_274[@]
    local arg_names_14670=("[<options> ...]")
    local arg_texts_14671=("List of options to choose from")
    local arg_notes_14672=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1046_v0 arg_names_14670[@] arg_texts_14671[@] arg_notes_14672[@] 20
    printf '%s\n' ""
    colored_secondary__1006_v0 "Flags:"
    local ret_colored_secondary1006_v0__18_12="${ret_colored_secondary1006_v0}"
    local array_278=()
    printf__128_v0 "${ret_colored_secondary1006_v0__18_12}""
" array_278[@]
    local names_14700=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_14701=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_14702=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1046_v0 names_14700[@] texts_14701[@] notes_14702[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1366_v0() {
    local options_14639=()
    local command_283
    command_283="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_14640="${command_283}"
    if [ "$([ "_${is_tty_14640}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_14639+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1366_v0=("${options_14639[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1367_v0() {
    local parameters_14622=("${!1}")
    local cursor_14623="> "
    colored_primary__1005_v0 "Choose: "
    local ret_colored_primary1005_v0__17_30="${ret_colored_primary1005_v0}"
    local header_14638="\\x1b[1m""${ret_colored_primary1005_v0__17_30}"
    read_stdin_options__1366_v0 
    local options_14641=("${ret_read_stdin_options1366_v0[@]}")
    local multi_14642=0
    local limit_14643=-1
    local page_size_14644=10
    local __length_287=("${parameters_14622[@]}")
    local slice_upper_286="${#__length_287[@]}"
    local slice_offset_288=2
    local slice_offset_288=$((${slice_offset_288} > 0 ? ${slice_offset_288} : 0))
    local slice_length_289="$(( slice_upper_286 - slice_offset_288 ))"
    local slice_length_289=$((${slice_length_289} > 0 ? ${slice_length_289} : 0))
    for param_14645 in "${parameters_14622[@]:${slice_offset_288}:${slice_length_289}}"; do
        starts_with__22_v0 "${param_14645}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14645}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14645}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14645}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_14645}" != "_-h" ]; echo $?) || $([ "_${param_14645}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1314_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_290="--cursor="
            slice__24_v0 "${param_14645}" "${#__length_290}" 0
            cursor_14623="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_291="--header="
            slice__24_v0 "${param_14645}" "${#__length_291}" 0
            header_14638="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_292="--limit="
            slice__24_v0 "${param_14645}" "${#__length_292}" 0
            local value_14703="${ret_slice24_v0}"
            parse_int__13_v0 "${value_14703}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1024_v0 "ERROR: Invalid limit value: ""${value_14703}""
" 31
                exit 1
            fi
            limit_14643="${ret_parse_int13_v0}"
            multi_14642=1
        elif [ "$([ "_${param_14645}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_14642=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_293="--page-size="
            slice__24_v0 "${param_14645}" "${#__length_293}" 0
            local value_14708="${ret_slice24_v0}"
            parse_int__13_v0 "${value_14708}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1024_v0 "ERROR: Invalid page-size value: ""${value_14708}""
" 31
                exit 1
            fi
            page_size_14644="${ret_parse_int13_v0}"
        else
            options_14641+=("${param_14645}")
        fi
    done
    has_ansi_escape__1036_v0 "${header_14638}"
    local ret_has_ansi_escape1036_v0__59_44="${ret_has_ansi_escape1036_v0}"
    escape_ansi__1037_v0 "${header_14638}"
    local ret_escape_ansi1037_v0__59_73="${ret_escape_ansi1037_v0}"
    colored_primary__1005_v0 "${header_14638}"
    local ret_colored_primary1005_v0__59_111="${ret_colored_primary1005_v0}"
    local display_header_14710
    display_header_14710="$(if [ "$(( $([ "_${header_14638}" != "_" ]; echo $?) || ret_has_ansi_escape1036_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1037_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1005_v0__59_111}"; fi)"
    if [ "${multi_14642}" != 0 ]; then
        xyl_multi_choose__1219_v0 options_14641[@] "${cursor_14623}" "${display_header_14710}" "${limit_14643}" "${page_size_14644}"
        local results_14823=("${ret_xyl_multi_choose1219_v0[@]}")
        join__7_v0 results_14823[@] "
"
        ret_execute_choose1367_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1218_v0 options_14641[@] "${cursor_14623}" "${display_header_14710}" "${page_size_14644}"
    ret_execute_choose1367_v0="${ret_xyl_choose1218_v0}"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
command_295="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_70="$([ "_${command_295}" != "_No" ]; echo $?)"
command_296="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_71="$(( $(( ! _perl_disabled_70 )) && $([ "_${command_296}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1542_v0() {
    local text_16585="${1}"
    if [ "$(( ! _perl_available_71 ))" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return 1
    fi
    local command_297
    command_297="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16585}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return "${__status}"
    fi
    local width_str_16586="${command_297}"
    parse_int__13_v0 "${width_str_16586}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return "${__status}"
    fi
    local width_16587="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1542_v0="${width_16587}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1543_v0() {
    local text_16640="${1}"
    local max_width_16641="${2}"
    if [ "$(( ! _perl_available_71 ))" != 0 ]; then
        ret_perl_truncate_cjk1543_v0=''
        return 1
    fi
    local command_298
    command_298="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16640}" ${max_width_16641} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1543_v0=''
        return "${__status}"
    fi
    local result_16642="${command_298}"
    ret_perl_truncate_cjk1543_v0="${result_16642}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_72=0
_term_size_73=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1550_v0() {
    local command_300
    command_300="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_16629="${command_300}"
    parse_int__13_v0 "${count_16629}"
    __status=$?
    ret_stty_count1550_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1551_v0() {
    stty_count__1550_v0 
    local count_num_16630="${ret_stty_count1550_v0}"
    if [ "$(( count_num_16630 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16630="$(( count_num_16630 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16630}
    __status=$?
}

# stty_unlock()
stty_unlock__1552_v0() {
    stty_count__1550_v0 
    local count_num_16706="${ret_stty_count1550_v0}"
    if [ "$(( count_num_16706 > 0 ))" != 0 ]; then
        count_num_16706="$(( count_num_16706 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16706}
        __status=$?
        if [ "$(( count_num_16706 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1553_v0() {
    local size_16569="${1}"
    if [ "$([ "_${size_16569}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1553_v0=0
        return 0
    fi
    split__4_v0 "${size_16569}" " "
    local parts_16570=("${ret_split4_v0[@]}")
    local __length_301=("${parts_16570[@]}")
    if [ "$(( ${#__length_301[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1553_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16570[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16570[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_73=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1553_v0=1
    return 0
}

# query_term_size()
query_term_size__1554_v0() {
    local command_303
    command_303="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16572="${command_303}"
    store_term_size__1553_v0 "${size_16572}"
    ret_query_term_size1554_v0="${ret_store_term_size1553_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1555_v0() {
    local command_304
    command_304="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16568="${command_304}"
    store_term_size__1553_v0 "${size_16568}"
    ret_stty_term_size1555_v0="${ret_store_term_size1553_v0}"
    return 0
}

# get_term_size()
get_term_size__1556_v0() {
    stty_term_size__1555_v0 
    local detected_16571="${ret_stty_term_size1555_v0}"
    if [ "$(( ! detected_16571 ))" != 0 ]; then
        query_term_size__1554_v0 
        detected_16571="${ret_query_term_size1554_v0}"
    fi
    _got_term_size_72=1
}

# term_width()
term_width__1558_v0() {
    if [ "$(( ! _got_term_size_72 ))" != 0 ]; then
        get_term_size__1556_v0 
    fi
    ret_term_width1558_v0="${_term_size_73[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_74="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_75=0
_primary_color_76=(3 207 159 92)
_secondary_color_77=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1569_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_16561="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_16561}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_74="No"
        ret_get_supports_truecolor1569_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_74="No"
        ret_get_supports_truecolor1569_v0=0
        return 0
    fi
    local colorterm_16562="${ret_env_var_get120_v0}"
    _supports_truecolor_74="$(if [ "$(( $([ "_${colorterm_16562}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_16562}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1569_v0="$([ "_${_supports_truecolor_74}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1570_v0() {
    local message_16556="${1}"
    local r_16557="${2}"
    local g_16558="${3}"
    local b_16559="${4}"
    local fallback_16560="${5}"
    if [ "$([ "_${_supports_truecolor_74}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1570_v0="\\x1b[38;2;${r_16557};${g_16558};${b_16559}m""${message_16556}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_74}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1569_v0 
        local ret_get_supports_truecolor1569_v0__50_17="${ret_get_supports_truecolor1569_v0}"
        if [ "${ret_get_supports_truecolor1569_v0__50_17}" != 0 ]; then
            ret_colored_rgb1570_v0="\\x1b[38;2;${r_16557};${g_16558};${b_16559}m""${message_16556}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16560 == 0 ))" != 0 ]; then
            ret_colored_rgb1570_v0="${message_16556}"
            return 0
        else
            ret_colored_rgb1570_v0="\\x1b[${fallback_16560}m""${message_16556}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16560 == 0 ))" != 0 ]; then
            ret_colored_rgb1570_v0="${message_16556}"
            return 0
        fi
        ret_colored_rgb1570_v0="\\x1b[${fallback_16560}m""${message_16556}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1571_v0() {
    local message_16679="${1}"
    local r_16680="${2}"
    local g_16681="${3}"
    local b_16682="${4}"
    local fallback_16683="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_16684="${fallback_16683}"
    if [ "$(( $(( fallback_16683 >= 30 )) && $(( fallback_16683 <= 37 )) ))" != 0 ]; then
        bg_fallback_16684="$(( fallback_16683 + 10 ))"
    fi
    if [ "$(( $(( fallback_16683 >= 90 )) && $(( fallback_16683 <= 97 )) ))" != 0 ]; then
        bg_fallback_16684="$(( fallback_16683 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_74}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1571_v0="\\x1b[48;2;${r_16680};${g_16681};${b_16682}m""${message_16679}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_74}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1569_v0 
        local ret_get_supports_truecolor1569_v0__92_17="${ret_get_supports_truecolor1569_v0}"
        if [ "${ret_get_supports_truecolor1569_v0__92_17}" != 0 ]; then
            ret_background_rgb1571_v0="\\x1b[48;2;${r_16680};${g_16681};${b_16682}m""${message_16679}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_16684 == 0 ))" != 0 ]; then
            ret_background_rgb1571_v0="${message_16679}"
            return 0
        else
            ret_background_rgb1571_v0="\\x1b[${bg_fallback_16684}m""${message_16679}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_16684 == 0 ))" != 0 ]; then
            ret_background_rgb1571_v0="${message_16679}"
            return 0
        fi
        ret_background_rgb1571_v0="\\x1b[${bg_fallback_16684}m""${message_16679}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1572_v0() {
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16550="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16550}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16550}" ";"
            local parts_16551=("${ret_split4_v0[@]}")
            local __length_308=("${parts_16551[@]}")
            if [ "$(( ${#__length_308[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16551[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16551[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16551[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16551[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_76=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16552="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16552}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16552}" ";"
            local parts_16553=("${ret_split4_v0[@]}")
            local __length_310=("${parts_16553[@]}")
            if [ "$(( ${#__length_310[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16553[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16553[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16553[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16553[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_77=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16554="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16554}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16554}" ";"
            local parts_16555=("${ret_split4_v0[@]}")
            local __length_312=("${parts_16555[@]}")
            if [ "$(( ${#__length_312[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16555[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16555[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16555[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16555[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_75=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1573_v0() {
    inner_get_xylitol_colors__1572_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_75=1
}

# colored_primary(message: Text)
colored_primary__1574_v0() {
    local message_16549="${1}"
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    colored_rgb__1570_v0 "${message_16549}" "${_primary_color_76[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_76[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_76[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_76[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1574_v0="${ret_colored_rgb1570_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1575_v0() {
    local message_16589="${1}"
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    colored_rgb__1570_v0 "${message_16589}" "${_secondary_color_77[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_77[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_77[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_77[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1575_v0="${ret_colored_rgb1570_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1578_v0() {
    local message_16678="${1}"
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    background_rgb__1571_v0 "${message_16678}" "${_secondary_color_77[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_77[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_77[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_77[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1578_v0="${ret_background_rgb1571_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1590_v0() {
    local command_314
    command_314="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16699="${command_314}"
    if [ "$([ "_${var_16699}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="UP"
        return 0
    elif [ "$([ "_${var_16699}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16699}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16699}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16699}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16699}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="INPUT"
        return 0
    else
        ret_get_key1590_v0="${var_16699}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1592_v0() {
    local format_16623="${1}"
    local args_16624=("${!2}")
    args_16624=("${format_16623}" "${args_16624[@]}")
    __status=$?
    printf "${args_16624[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1593_v0() {
    local message_16621="${1}"
    local color_16622="${2}"
    # Prints an error message with a specified color.
    local array_315=("${message_16621}")
    eprintf__1592_v0 "\\x1b[${color_16622}m%s\\x1b[0m" array_315[@]
}

# colored(message: Text, color: Int)
colored__1594_v0() {
    local message_16618="${1}"
    local color_16619="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1594_v0="\\x1b[${color_16619}m""${message_16618}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1596_v0() {
    local cnt_16703="${1}"
    if [ "$(( cnt_16703 > 0 ))" != 0 ]; then
        local sequence_16704=""
        local __range_start_16705=0
        local __range_end_16705="${cnt_16703}"
        local __dir_16705=$(( ${__range_start_16705} <= ${__range_end_16705} ? 1 : -1 ))
        for (( ____16705=${__range_start_16705}; ____16705 * ${__dir_16705} < ${__range_end_16705} * ${__dir_16705}; ____16705+=${__dir_16705} )); do
            sequence_16704+="\\x1b[2K\\x1b[1A"
done
        local array_316=("")
        eprintf__1592_v0 "${sequence_16704}" array_316[@]
    fi
    local array_317=("")
    eprintf__1592_v0 "\\x1b[G" array_317[@]
}

# remove_current_line()
remove_current_line__1597_v0() {
    local array_318=("")
    eprintf__1592_v0 "\\x1b[2K\\x1b[G" array_318[@]
}

# go_up(cnt: Int)
go_up__1600_v0() {
    local cnt_16698="${1}"
    local array_319=("")
    eprintf__1592_v0 "\\x1b[${cnt_16698}A" array_319[@]
}

# go_down(cnt: Int)
go_down__1601_v0() {
    local cnt_16702="${1}"
    local array_320=("")
    eprintf__1592_v0 "\\x1b[${cnt_16702}B" array_320[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1603_v0() {
    local array_321=("")
    eprintf__1592_v0 "\\x1b[?25l" array_321[@]
}

# show_cursor()
show_cursor__1604_v0() {
    local array_322=("")
    eprintf__1592_v0 "\\x1b[?25h" array_322[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1605_v0() {
    local text_16578="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_323
    command_323="$([[ "${text_16578}" == *$'\x1b'* || "${text_16578}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16579="${command_323}"
    ret_has_ansi_escape1605_v0="$([ "_${has_escape_16579}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1606_v0() {
    local text_16625="${1}"
    local command_324
    command_324="$(printf '%s' "${text_16625}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1606_v0="${command_324}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1607_v0() {
    local text_16581="${1}"
    local command_325
    command_325="$(printf "%s" "${text_16581}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1607_v0="${command_325}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1608_v0() {
    local text_16583="${1}"
    local command_326
    command_326="$(printf "%s" "${text_16583}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16584="${command_326}"
    ret_is_all_ascii1608_v0="$([ "_${result_16584}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1609_v0() {
    local text_16580="${1}"
    strip_ansi__1607_v0 "${text_16580}"
    local stripped_16582="${ret_strip_ansi1607_v0}"
    # Check if text is all ASCII
    is_all_ascii__1608_v0 "${stripped_16582}"
    local ret_is_all_ascii1608_v0__150_12="${ret_is_all_ascii1608_v0}"
    if [ "$(( ! ret_is_all_ascii1608_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1542_v0 "${stripped_16582}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_327="${stripped_16582}"
            ret_get_visible_len1609_v0="${#__length_327}"
            return 0
        fi
        ret_get_visible_len1609_v0="${ret_perl_get_cjk_width1542_v0}"
        return 0
    else
        local __length_328="${stripped_16582}"
        ret_get_visible_len1609_v0="${#__length_328}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1610_v0() {
    local text_16637="${1}"
    local max_width_16638="${2}"
    get_visible_len__1609_v0 "${text_16637}"
    local visible_len_16639="${ret_get_visible_len1609_v0}"
    if [ "$(( visible_len_16639 <= max_width_16638 ))" != 0 ]; then
        ret_truncate_text1610_v0="${text_16637}"
        return 0
    fi
    is_all_ascii__1608_v0 "${text_16637}"
    local ret_is_all_ascii1608_v0__167_12="${ret_is_all_ascii1608_v0}"
    if [ "$(( ! ret_is_all_ascii1608_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1543_v0 "${text_16637}" "${max_width_16638}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16637}" | cut -c1-${max_width_16638}
            __status=$?
        fi
        ret_truncate_text1610_v0="${ret_perl_truncate_cjk1543_v0}"
        return 0
    fi
    local command_329
    command_329="$(printf "%s" "${text_16637}" | cut -c1-${max_width_16638})"
    __status=$?
    ret_truncate_text1610_v0="${command_329}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1611_v0() {
    local text_16635="${1}"
    local max_width_16636="${2}"
    has_ansi_escape__1605_v0 "${text_16635}"
    local ret_has_ansi_escape1605_v0__179_12="${ret_has_ansi_escape1605_v0}"
    if [ "$(( ! ret_has_ansi_escape1605_v0__179_12 ))" != 0 ]; then
        truncate_text__1610_v0 "${text_16635}" "${max_width_16636}"
        ret_truncate_ansi1611_v0="${ret_truncate_text1610_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_330
    command_330="$([[ "${text_16635}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16643="${command_330}"
    # Replace \x1b[ with newline, then split
    local command_331
    command_331="$(t="${text_16635}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16644="${command_331}"
    split__4_v0 "${replaced_16644}" "
"
    local parts_16645=("${ret_split4_v0[@]}")
    local result_16646=""
    local remaining_width_16647="${max_width_16636}"
    local __range_start_16648=0
    local __length_332=("${parts_16645[@]}")
    local __range_end_16648="${#__length_332[@]}"
    local __dir_16648=$(( ${__range_start_16648} <= ${__range_end_16648} ? 1 : -1 ))
    for (( idx_16648=${__range_start_16648}; idx_16648 * ${__dir_16648} < ${__range_end_16648} * ${__dir_16648}; idx_16648+=${__dir_16648} )); do
        local part_16649="${parts_16645[${idx_16648}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16648 == 0 )) && $([ "_${starts_with_ansi_16643}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16649}" == "_" ]; echo $?) && $(( remaining_width_16647 > 0 )) ))" != 0 ]; then
                truncate_text__1610_v0 "${part_16649}" "${remaining_width_16647}"
                local ret_truncate_text1610_v0__201_35="${ret_truncate_text1610_v0}"
                local truncated_16650="${ret_truncate_text1610_v0__201_35}"
                result_16646+="${truncated_16650}"
                get_visible_len__1609_v0 "${truncated_16650}"
                local ret_get_visible_len1609_v0__203_36="${ret_get_visible_len1609_v0}"
                remaining_width_16647="$(( remaining_width_16647 - ret_get_visible_len1609_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_333
            command_333="$(__p="${part_16649}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16651="${command_333}"
            if [ "$([ "_${m_idx_16651}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_334
                command_334="$(__p="${part_16649}"; printf "%s" "${__p:0:${m_idx_16651}}")"
                __status=$?
                local ansi_params_16652="${command_334}"
                result_16646+="\\x1b[""${ansi_params_16652}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16651}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_16653="${ret_parse_int13_v0__214_41}"
                local text_start_16654="$(( m_idx_num_16653 + 1 ))"
                local command_335
                command_335="$(__p="${part_16649}"; printf "%s" "${__p:${text_start_16654}}")"
                __status=$?
                local text_part_16655="${command_335}"
                if [ "$(( $([ "_${text_part_16655}" == "_" ]; echo $?) && $(( remaining_width_16647 > 0 )) ))" != 0 ]; then
                    truncate_text__1610_v0 "${text_part_16655}" "${remaining_width_16647}"
                    local ret_truncate_text1610_v0__218_39="${ret_truncate_text1610_v0}"
                    local truncated_16656="${ret_truncate_text1610_v0__218_39}"
                    result_16646+="${truncated_16656}"
                    get_visible_len__1609_v0 "${truncated_16656}"
                    local ret_get_visible_len1609_v0__220_40="${ret_get_visible_len1609_v0}"
                    remaining_width_16647="$(( remaining_width_16647 - ret_get_visible_len1609_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16649}" == "_" ]; echo $?) && $(( remaining_width_16647 > 0 )) ))" != 0 ]; then
                    truncate_text__1610_v0 "${part_16649}" "${remaining_width_16647}"
                    local ret_truncate_text1610_v0__225_39="${ret_truncate_text1610_v0}"
                    local truncated_16657="${ret_truncate_text1610_v0__225_39}"
                    result_16646+="${truncated_16657}"
                    get_visible_len__1609_v0 "${truncated_16657}"
                    local ret_get_visible_len1609_v0__227_40="${ret_get_visible_len1609_v0}"
                    remaining_width_16647="$(( remaining_width_16647 - ret_get_visible_len1609_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1611_v0="${result_16646}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1612_v0() {
    local text_16632="${1}"
    local max_width_16633="${2}"
    get_visible_len__1609_v0 "${text_16632}"
    local visible_len_16634="${ret_get_visible_len1609_v0}"
    if [ "$(( visible_len_16634 <= max_width_16633 ))" != 0 ]; then
        ret_cutoff_text1612_v0="${text_16632}"
        return 0
    fi
    truncate_ansi__1611_v0 "${text_16632}" "$(( max_width_16633 - 3 ))"
    local ret_truncate_ansi1611_v0__243_12="${ret_truncate_ansi1611_v0}"
    ret_cutoff_text1612_v0="${ret_truncate_ansi1611_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1613_v0() {
    local items_16685=("${!1}")
    local total_len_16686="${2}"
    local term_width_16687="${3}"
    local separator_16688=" • "
    local separator_len_16689=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16686 <= term_width_16687 ))" != 0 ]; then
        local iter_16690=0
        while :
        do
            local __length_336=("${items_16685[@]}")
            if [ "$(( iter_16690 >= ${#__length_336[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16690 > 0 ))" != 0 ]; then
                eprintf_colored__1593_v0 "${separator_16688}" 90
            fi
            colored__1594_v0 "${items_16685[$(( iter_16690 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1594_v0__268_41="${ret_colored1594_v0}"
            local array_337=("")
            eprintf__1592_v0 "${items_16685[${iter_16690}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1594_v0__268_41}" array_337[@]
            iter_16690="$(( iter_16690 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16691=0
        local first_16692=1
        local iter_16693=0
        while :
        do
            local __length_338=("${items_16685[@]}")
            if [ "$(( iter_16693 >= ${#__length_338[@]} ))" != 0 ]; then
                break
            fi
            local key_16694="${items_16685[${iter_16693}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_16695="${items_16685[$(( iter_16693 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_339="${key_16694}"
            local __length_340="${action_16695}"
            local part_len_16696="$(( $(( ${#__length_339} + 1 )) + ${#__length_340} ))"
            local needed_16697="${part_len_16696}"
            if [ "$(( ! first_16692 ))" != 0 ]; then
                needed_16697="$(( needed_16697 + separator_len_16689 ))"
            fi
            if [ "$(( $(( current_len_16691 + needed_16697 )) > term_width_16687 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16692 ))" != 0 ]; then
                eprintf_colored__1593_v0 "${separator_16688}" 90
            fi
            colored__1594_v0 "${action_16695}" 2
            local ret_colored1594_v0__296_33="${ret_colored1594_v0}"
            local array_341=("")
            eprintf__1592_v0 "${key_16694}"" ""${ret_colored1594_v0__296_33}" array_341[@]
            current_len_16691="$(( current_len_16691 + needed_16697 ))"
            first_16692=0
            iter_16693="$(( iter_16693 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1614_v0() {
    local pending_16615="${1}"
    local line_16616="${2}"
    local note_at_16617="${3}"
    if [ "$(( note_at_16617 < 0 ))" != 0 ]; then
        local array_342=()
        printf__128_v0 "${pending_16615}""${line_16616}""
" array_342[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16617 == 0 ))" != 0 ]; then
        colored__1594_v0 "${line_16616}" 90
        local ret_colored1594_v0__310_40="${ret_colored1594_v0}"
        local array_343=()
        printf__128_v0 "${pending_16615}""${ret_colored1594_v0__310_40}""
" array_343[@]
    else
        slice__24_v0 "${line_16616}" 0 "${note_at_16617}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16616}" "${note_at_16617}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1594_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1594_v0__311_58="${ret_colored1594_v0}"
        local array_344=()
        printf__128_v0 "${pending_16615}""${ret_slice24_v0__311_32}""${ret_colored1594_v0__311_58}""
" array_344[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1615_v0() {
    local names_16593=("${!1}")
    local texts_16594=("${!2}")
    local notes_16595=("${!3}")
    local min_name_width_16596="${4}"
    local __length_345=("${names_16593[@]}")
    local count_16597="${#__length_345[@]}"
    local name_width_16598="${min_name_width_16596}"
    local __range_start_16599=0
    local __range_end_16599="${count_16597}"
    local __dir_16599=$(( ${__range_start_16599} <= ${__range_end_16599} ? 1 : -1 ))
    for (( i_16599=${__range_start_16599}; i_16599 * ${__dir_16599} < ${__range_end_16599} * ${__dir_16599}; i_16599+=${__dir_16599} )); do
        local __length_346="${names_16593[${i_16599}]?"Index out of bounds (at src/./confirm/../utils.ab:326:33)"}"
        local width_16600="${#__length_346}"
        if [ "$(( width_16600 > name_width_16598 ))" != 0 ]; then
            name_width_16598="${width_16600}"
        fi
done
    term_width__1558_v0 
    local width_16601="${ret_term_width1558_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16602="$(( name_width_16598 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16603="$(( $(( width_16601 - indent_16602 )) < 24 ))"
    if [ "${stacked_16603}" != 0 ]; then
        indent_16602=6
    fi
    local avail_16604="$(( width_16601 - indent_16602 ))"
    rpad__28_v0 "" " " "${indent_16602}"
    local blank_16605="${ret_rpad28_v0}"
    local __range_start_16606=0
    local __range_end_16606="${count_16597}"
    local __dir_16606=$(( ${__range_start_16606} <= ${__range_end_16606} ? 1 : -1 ))
    for (( i_16606=${__range_start_16606}; i_16606 * ${__dir_16606} < ${__range_end_16606} * ${__dir_16606}; i_16606+=${__dir_16606} )); do
        local pending_16607="${blank_16605}"
        if [ "${stacked_16603}" != 0 ]; then
            local array_347=()
            printf__128_v0 "  ""${names_16593[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:346:33)"}""
" array_347[@]
        else
            rpad__28_v0 "  ""${names_16593[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:348:41)"}" " " "${indent_16602}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_16607="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_16594[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_16608=("${ret_split4_v0__350_21[@]}")
        local __length_348=("${words_16608[@]}")
        local note_start_16609="${#__length_348[@]}"
        if [ "$([ "_${notes_16595[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_349="${notes_16595[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_349} > avail_16604 ))" != 0 ]; then
                split__4_v0 "${notes_16595[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_16608+=("${ret_split4_v0__356_26[@]}")
            else
                local array_350=("${notes_16595[${i_16606}]?"Index out of bounds (at src/./confirm/../utils.ab:358:33)"}")
                words_16608+=("${array_350[@]}")
            fi
        fi
        local line_16610=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16611=-1
        local __range_start_16612=0
        local __length_351=("${words_16608[@]}")
        local __range_end_16612="${#__length_351[@]}"
        local __dir_16612=$(( ${__range_start_16612} <= ${__range_end_16612} ? 1 : -1 ))
        for (( j_16612=${__range_start_16612}; j_16612 * ${__dir_16612} < ${__range_end_16612} * ${__dir_16612}; j_16612+=${__dir_16612} )); do
            local word_16613="${words_16608[${j_16612}]?"Index out of bounds (at src/./confirm/../utils.ab:368:32)"}"
            local candidate_16614
            candidate_16614="$(if [ "$([ "_${line_16610}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16613}"; else echo "${line_16610}"" ""${word_16613}"; fi)"
            local __length_352="${candidate_16614}"
            if [ "$(( $(( ${#__length_352} > avail_16604 )) && $([ "_${line_16610}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1614_v0 "${pending_16607}" "${line_16610}" "${note_at_16611}"
                pending_16607="${blank_16605}"
                line_16610="${word_16613}"
                note_at_16611="$(if [ "$(( j_16612 >= note_start_16609 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16612 >= note_start_16609 )) && $(( note_at_16611 < 0 )) ))" != 0 ]; then
                    local __length_353="${candidate_16614}"
                    local __length_354="${word_16613}"
                    note_at_16611="$(( ${#__length_353} - ${#__length_354} ))"
                fi
                line_16610="${candidate_16614}"
            fi
done
        print_help_line__1614_v0 "${pending_16607}" "${line_16610}" "${note_at_16611}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1616_v0() {
    local pieces_16567=("${!1}")
    term_width__1558_v0 
    local width_16573="${ret_term_width1558_v0}"
    local line_16574=""
    local line_len_16575=0
    for piece_16576 in "${pieces_16567[@]}"; do
        local __length_357="${piece_16576}"
        local piece_len_16577="${#__length_357}"
        has_ansi_escape__1605_v0 "${piece_16576}"
        local ret_has_ansi_escape1605_v0__397_12="${ret_has_ansi_escape1605_v0}"
        if [ "${ret_has_ansi_escape1605_v0__397_12}" != 0 ]; then
            get_visible_len__1609_v0 "${piece_16576}"
            piece_len_16577="${ret_get_visible_len1609_v0}"
        fi
        if [ "$([ "_${line_16574}" != "_" ]; echo $?)" != 0 ]; then
            line_16574="${piece_16576}"
            line_len_16575="${piece_len_16577}"
        elif [ "$(( $(( $(( line_len_16575 + 1 )) + piece_len_16577 )) > width_16573 ))" != 0 ]; then
            local array_358=()
            printf__128_v0 "${line_16574}""
" array_358[@]
            line_16574="${piece_16576}"
            line_len_16575="${piece_len_16577}"
        else
            line_16574+=" ""${piece_16576}"
            line_len_16575="$(( line_len_16575 + $(( 1 + piece_len_16577 )) ))"
        fi
    done
    if [ "$([ "_${line_16574}" == "_" ]; echo $?)" != 0 ]; then
        local array_359=()
        printf__128_v0 "${line_16574}""
" array_359[@]
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1667_v0() {
    local selected_16659="${1}"
    local term_width_16660="${2}"
    local small_16661="$(( term_width_16660 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_16661}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_16675="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_16661}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_16676="${ret_cpad29_v0}"
    local gap_16677
    gap_16677="$(if [ "${small_16661}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_360=("")
    eprintf__1592_v0 " " array_360[@]
    if [ "${selected_16659}" != 0 ]; then
        # Yes selected
        background_secondary__1578_v0 "${yes_label_16675}"
        local ret_background_secondary1578_v0__16_30="${ret_background_secondary1578_v0}"
        local array_361=("")
        eprintf__1592_v0 "\\x1b[97m""${ret_background_secondary1578_v0__16_30}" array_361[@]
        local array_362=("")
        eprintf__1592_v0 "${gap_16677}" array_362[@]
        # No not selected (dim)
        local array_363=("")
        eprintf__1592_v0 "\\x1b[49;37m""${no_label_16676}""\\x1b[0m" array_363[@]
    else
        # No selected
        local array_364=("")
        eprintf__1592_v0 "\\x1b[49;37m""${yes_label_16675}""\\x1b[0m" array_364[@]
        local array_365=("")
        eprintf__1592_v0 "${gap_16677}" array_365[@]
        background_secondary__1578_v0 "${no_label_16676}"
        local ret_background_secondary1578_v0__24_30="${ret_background_secondary1578_v0}"
        local array_366=("")
        eprintf__1592_v0 "\\x1b[97m""${ret_background_secondary1578_v0__24_30}" array_366[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1668_v0() {
    local header_16627="${1}"
    local default_yes_16628="${2}"
    stty_lock__1551_v0 
    hide_cursor__1603_v0 
    term_width__1558_v0 
    local term_width_16631="${ret_term_width1558_v0}"
    if [ "$([ "_${header_16627}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1612_v0 "${header_16627}" "${term_width_16631}"
        local ret_cutoff_text1612_v0__46_17="${ret_cutoff_text1612_v0}"
        local array_367=("")
        eprintf__1592_v0 "${ret_cutoff_text1612_v0__46_17}""

" array_367[@]
    fi
    local selected_16658="${default_yes_16628}"
    # Render initial options
    render_confirm_options__1667_v0 "${selected_16658}" "${term_width_16631}"
    local array_368=("")
    eprintf__1592_v0 "

" array_368[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_369=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1613_v0 array_369[@] 40 "${term_width_16631}"
    go_up__1600_v0 2
    while :
    do
        get_key__1590_v0 
        local key_16700="${ret_get_key1590_v0}"
        if [ "$(( $(( $(( $([ "_${key_16700}" != "_LEFT" ]; echo $?) || $([ "_${key_16700}" != "_h" ]; echo $?) )) || $([ "_${key_16700}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_16700}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_16658}" != 0 ]; then
                selected_16658=0
                local array_370=("")
                eprintf__1592_v0 "\\x1b[G\\x1b[K" array_370[@]
                render_confirm_options__1667_v0 "${selected_16658}" "${term_width_16631}"
            elif [ "$(( ! selected_16658 ))" != 0 ]; then
                selected_16658=1
                local array_371=("")
                eprintf__1592_v0 "\\x1b[G\\x1b[K" array_371[@]
                render_confirm_options__1667_v0 "${selected_16658}" "${term_width_16631}"
            fi
        elif [ "$(( $([ "_${key_16700}" != "_y" ]; echo $?) || $([ "_${key_16700}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_16658=1
            break
        elif [ "$(( $([ "_${key_16700}" != "_n" ]; echo $?) || $([ "_${key_16700}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_16658=0
            break
        elif [ "$([ "_${key_16700}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_16701=4
    if [ "$([ "_${header_16627}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_16701="$(( total_lines_16701 + 1 ))"
    fi
    go_down__1601_v0 2
    remove_line__1596_v0 "$(( total_lines_16701 - 1 ))"
    remove_current_line__1597_v0 
    stty_unlock__1552_v0 
    show_cursor__1604_v0 
    ret_xyl_confirm1668_v0="${selected_16658}"
    return 0
}

# print_confirm_help()
print_confirm_help__1762_v0() {
    local usage_16566=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1616_v0 usage_16566[@]
    printf '%s\n' ""
    colored_primary__1574_v0 "confirm"
    local ret_colored_primary1574_v0__8_20="${ret_colored_primary1574_v0}"
    local title_16588=("${ret_colored_primary1574_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1616_v0 title_16588[@]
    printf '%s\n' ""
    colored_secondary__1575_v0 "Flags:"
    local ret_colored_secondary1575_v0__11_12="${ret_colored_secondary1575_v0}"
    local array_374=()
    printf__128_v0 "${ret_colored_secondary1575_v0__11_12}""
" array_374[@]
    local names_16590=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_16591=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_16592=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__1615_v0 names_16590[@] texts_16591[@] notes_16592[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1814_v0() {
    local parameters_16548=("${!1}")
    colored_primary__1574_v0 "Are you sure?"
    local ret_colored_primary1574_v0__9_30="${ret_colored_primary1574_v0}"
    local header_16563="\\x1b[1m""${ret_colored_primary1574_v0__9_30}"
    local default_yes_16564=1
    for param_16565 in "${parameters_16548[@]}"; do
        starts_with__22_v0 "${param_16565}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16565}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16565}" != "_-h" ]; echo $?) || $([ "_${param_16565}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1762_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_380="--header="
            slice__24_v0 "${param_16565}" "${#__length_380}" 0
            header_16563="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_381="--default="
            slice__24_v0 "${param_16565}" "${#__length_381}" 0
            local value_16620="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_16620}" != "_yes" ]; echo $?) || $([ "_${value_16620}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_16564=1
            elif [ "$(( $([ "_${value_16620}" != "_no" ]; echo $?) || $([ "_${value_16620}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_16564=0
            else
                eprintf_colored__1593_v0 "ERROR: Invalid default value: ""${value_16620}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1605_v0 "${header_16563}"
    local ret_has_ansi_escape1605_v0__35_44="${ret_has_ansi_escape1605_v0}"
    escape_ansi__1606_v0 "${header_16563}"
    local ret_escape_ansi1606_v0__35_73="${ret_escape_ansi1606_v0}"
    colored_primary__1574_v0 "${header_16563}"
    local ret_colored_primary1574_v0__35_111="${ret_colored_primary1574_v0}"
    local display_header_16626
    display_header_16626="$(if [ "$(( $([ "_${header_16563}" != "_" ]; echo $?) || ret_has_ansi_escape1605_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1606_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1574_v0__35_111}"; fi)"
    xyl_confirm__1668_v0 "${display_header_16626}" "${default_yes_16564}"
    local result_16707="${ret_xyl_confirm1668_v0}"
    ret_execute_confirm1814_v0="$(if [ "${result_16707}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_82=3
# get_directory_entries(path: Text)
get_directory_entries__1969_v0() {
    local path_25155="${1}"
    local __ls_path_382="${path_25155}"
    __ls_path_382="${__ls_path_382//\\/\\\\}"
    (( 1 )) && __ls_all_382="-A" || __ls_all_382=""
    (( 0 )) && __ls_rec_382="-R" || __ls_rec_382=""
    local __ls_382=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_382 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_382} ${__ls_rec_382} ${__ls_path_382}
    __status=$?
    );
    local names_25156=("${__ls_382[@]}")
    local command_383
    command_383="$(LC_ALL=C ls -lA "${path_25155}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_25157="${command_383}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_384
    command_384="$(LC_ALL=C ls -lA "${path_25155}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_25158="${command_384}"
    split__4_v0 "${types_output_25157}" "
"
    local types_25159=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_25158}" "
"
    local targets_25160=("${ret_split4_v0[@]}")
    local entries_25161=()
    local __range_start_25162=0
    local __length_386=("${names_25156[@]}")
    local __range_end_25162="${#__length_386[@]}"
    local __dir_25162=$(( ${__range_start_25162} <= ${__range_end_25162} ? 1 : -1 ))
    for (( i_25162=${__range_start_25162}; i_25162 * ${__dir_25162} < ${__range_end_25162} * ${__dir_25162}; i_25162+=${__dir_25162} )); do
        local array_387=("${names_25156[${i_25162}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_25161+=("${array_387[@]}")
        local array_388=("${types_25159[${i_25162}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_25161+=("${array_388[@]}")
        slice__24_v0 "${targets_25160[${i_25162}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_389=("${ret_slice24_v0__31_21}")
        entries_25161+=("${array_389[@]}")
done
    ret_get_directory_entries1969_v0=("${entries_25161[@]}")
    return 0
}

# get_cwd()
get_cwd__1970_v0() {
    local command_390
    command_390="$(pwd)"
    __status=$?
    ret_get_cwd1970_v0="${command_390}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1971_v0() {
    local path_25153="${1}"
    local command_391
    command_391="$(cd "${path_25153}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_25154="${command_391}"
    if [ "$([ "_${normalized_25154}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1971_v0="${path_25153}"
        return 0
    fi
    ret_normalize_path1971_v0="${normalized_25154}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1972_v0() {
    local base_25321="${1}"
    local child_25322="${2}"
    if [ "$([ "_${base_25321}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1972_v0="/""${child_25322}"
        return 0
    fi
    ret_path_join1972_v0="${base_25321}""/""${child_25322}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1973_v0() {
    local path_25319="${1}"
    local command_392
    command_392="$(dirname "${path_25319}")"
    __status=$?
    local parent_25320="${command_392}"
    ret_get_parent_dir1973_v0="${parent_25320}"
    return 0
}

# Perl Extensions Utilities
command_393="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_84="$([ "_${command_393}" != "_No" ]; echo $?)"
command_394="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_85="$(( $(( ! _perl_disabled_84 )) && $([ "_${command_394}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1981_v0() {
    local text_25089="${1}"
    if [ "$(( ! _perl_available_85 ))" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return 1
    fi
    local command_395
    command_395="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_25089}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return "${__status}"
    fi
    local width_str_25090="${command_395}"
    parse_int__13_v0 "${width_str_25090}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return "${__status}"
    fi
    local width_25091="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1981_v0="${width_25091}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_86=0
_term_size_87=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1989_v0() {
    local command_397
    command_397="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_25150="${command_397}"
    parse_int__13_v0 "${count_25150}"
    __status=$?
    ret_stty_count1989_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1990_v0() {
    stty_count__1989_v0 
    local count_num_25151="${ret_stty_count1989_v0}"
    if [ "$(( count_num_25151 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_25151="$(( count_num_25151 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25151}
    __status=$?
}

# stty_unlock()
stty_unlock__1991_v0() {
    stty_count__1989_v0 
    local count_num_25172="${ret_stty_count1989_v0}"
    if [ "$(( count_num_25172 > 0 ))" != 0 ]; then
        count_num_25172="$(( count_num_25172 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25172}
        __status=$?
        if [ "$(( count_num_25172 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1992_v0() {
    local size_25073="${1}"
    if [ "$([ "_${size_25073}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1992_v0=0
        return 0
    fi
    split__4_v0 "${size_25073}" " "
    local parts_25074=("${ret_split4_v0[@]}")
    local __length_398=("${parts_25074[@]}")
    if [ "$(( ${#__length_398[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1992_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_25074[1]?"Index out of bounds (at src/./file/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_25074[0]?"Index out of bounds (at src/./file/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_87=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1992_v0=1
    return 0
}

# query_term_size()
query_term_size__1993_v0() {
    local command_400
    command_400="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_25076="${command_400}"
    store_term_size__1992_v0 "${size_25076}"
    ret_query_term_size1993_v0="${ret_store_term_size1992_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1994_v0() {
    local command_401
    command_401="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_25072="${command_401}"
    store_term_size__1992_v0 "${size_25072}"
    ret_stty_term_size1994_v0="${ret_store_term_size1992_v0}"
    return 0
}

# get_term_size()
get_term_size__1995_v0() {
    stty_term_size__1994_v0 
    local detected_25075="${ret_stty_term_size1994_v0}"
    if [ "$(( ! detected_25075 ))" != 0 ]; then
        query_term_size__1993_v0 
        detected_25075="${ret_query_term_size1993_v0}"
    fi
    _got_term_size_86=1
}

# term_width()
term_width__1997_v0() {
    if [ "$(( ! _got_term_size_86 ))" != 0 ]; then
        get_term_size__1995_v0 
    fi
    ret_term_width1997_v0="${_term_size_87[0]?"Index out of bounds (at src/./file/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_88="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_89=0
_primary_color_90=(3 207 159 92)
_secondary_color_91=(3 118 206 94)
_accent_color_92=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__2008_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_25104="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_25104}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_88="No"
        ret_get_supports_truecolor2008_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_88="No"
        ret_get_supports_truecolor2008_v0=0
        return 0
    fi
    local colorterm_25105="${ret_env_var_get120_v0}"
    _supports_truecolor_88="$(if [ "$(( $([ "_${colorterm_25105}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_25105}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2008_v0="$([ "_${_supports_truecolor_88}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2009_v0() {
    local message_25099="${1}"
    local r_25100="${2}"
    local g_25101="${3}"
    local b_25102="${4}"
    local fallback_25103="${5}"
    if [ "$([ "_${_supports_truecolor_88}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2009_v0="\\x1b[38;2;${r_25100};${g_25101};${b_25102}m""${message_25099}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_88}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2008_v0 
        local ret_get_supports_truecolor2008_v0__50_17="${ret_get_supports_truecolor2008_v0}"
        if [ "${ret_get_supports_truecolor2008_v0__50_17}" != 0 ]; then
            ret_colored_rgb2009_v0="\\x1b[38;2;${r_25100};${g_25101};${b_25102}m""${message_25099}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_25103 == 0 ))" != 0 ]; then
            ret_colored_rgb2009_v0="${message_25099}"
            return 0
        else
            ret_colored_rgb2009_v0="\\x1b[${fallback_25103}m""${message_25099}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_25103 == 0 ))" != 0 ]; then
            ret_colored_rgb2009_v0="${message_25099}"
            return 0
        fi
        ret_colored_rgb2009_v0="\\x1b[${fallback_25103}m""${message_25099}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2011_v0() {
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_25093="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_25093}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_25093}" ";"
            local parts_25094=("${ret_split4_v0[@]}")
            local __length_405=("${parts_25094[@]}")
            if [ "$(( ${#__length_405[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25094[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25094[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25094[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25094[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_90=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_25095="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_25095}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_25095}" ";"
            local parts_25096=("${ret_split4_v0[@]}")
            local __length_407=("${parts_25096[@]}")
            if [ "$(( ${#__length_407[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25096[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25096[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25096[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25096[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_91=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_25097="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_25097}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_25097}" ";"
            local parts_25098=("${ret_split4_v0[@]}")
            local __length_409=("${parts_25098[@]}")
            if [ "$(( ${#__length_409[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25098[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25098[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25098[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25098[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_92=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_89=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2012_v0() {
    inner_get_xylitol_colors__2011_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_89=1
}

# colored_primary(message: Text)
colored_primary__2013_v0() {
    local message_25092="${1}"
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25092}" "${_primary_color_90[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_90[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_90[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_90[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary2013_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2014_v0() {
    local message_25107="${1}"
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25107}" "${_secondary_color_91[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_91[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_91[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_91[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2014_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2015_v0() {
    local message_25258="${1}"
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25258}" "${_accent_color_92[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_92[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_92[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_92[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent2015_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__2031_v0() {
    local format_25144="${1}"
    local args_25145=("${!2}")
    args_25145=("${format_25144}" "${args_25145[@]}")
    __status=$?
    printf "${args_25145[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2032_v0() {
    local message_25142="${1}"
    local color_25143="${2}"
    # Prints an error message with a specified color.
    local array_411=("${message_25142}")
    eprintf__2031_v0 "\\x1b[${color_25143}m%s\\x1b[0m" array_411[@]
}

# colored(message: Text, color: Int)
colored__2033_v0() {
    local message_25136="${1}"
    local color_25137="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2033_v0="\\x1b[${color_25137}m""${message_25136}""\\x1b[0m"
    return 0
}

# remove_current_line()
remove_current_line__2036_v0() {
    local array_412=("")
    eprintf__2031_v0 "\\x1b[2K\\x1b[G" array_412[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2044_v0() {
    local text_25082="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_413
    command_413="$([[ "${text_25082}" == *$'\x1b'* || "${text_25082}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_25083="${command_413}"
    ret_has_ansi_escape2044_v0="$([ "_${has_escape_25083}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2046_v0() {
    local text_25085="${1}"
    local command_414
    command_414="$(printf "%s" "${text_25085}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2046_v0="${command_414}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2047_v0() {
    local text_25087="${1}"
    local command_415
    command_415="$(printf "%s" "${text_25087}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_25088="${command_415}"
    ret_is_all_ascii2047_v0="$([ "_${result_25088}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2048_v0() {
    local text_25084="${1}"
    strip_ansi__2046_v0 "${text_25084}"
    local stripped_25086="${ret_strip_ansi2046_v0}"
    # Check if text is all ASCII
    is_all_ascii__2047_v0 "${stripped_25086}"
    local ret_is_all_ascii2047_v0__150_12="${ret_is_all_ascii2047_v0}"
    if [ "$(( ! ret_is_all_ascii2047_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1981_v0 "${stripped_25086}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_416="${stripped_25086}"
            ret_get_visible_len2048_v0="${#__length_416}"
            return 0
        fi
        ret_get_visible_len2048_v0="${ret_perl_get_cjk_width1981_v0}"
        return 0
    else
        local __length_417="${stripped_25086}"
        ret_get_visible_len2048_v0="${#__length_417}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2053_v0() {
    local pending_25133="${1}"
    local line_25134="${2}"
    local note_at_25135="${3}"
    if [ "$(( note_at_25135 < 0 ))" != 0 ]; then
        local array_418=()
        printf__128_v0 "${pending_25133}""${line_25134}""
" array_418[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_25135 == 0 ))" != 0 ]; then
        colored__2033_v0 "${line_25134}" 90
        local ret_colored2033_v0__310_40="${ret_colored2033_v0}"
        local array_419=()
        printf__128_v0 "${pending_25133}""${ret_colored2033_v0__310_40}""
" array_419[@]
    else
        slice__24_v0 "${line_25134}" 0 "${note_at_25135}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_25134}" "${note_at_25135}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__2033_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored2033_v0__311_58="${ret_colored2033_v0}"
        local array_420=()
        printf__128_v0 "${pending_25133}""${ret_slice24_v0__311_32}""${ret_colored2033_v0__311_58}""
" array_420[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2054_v0() {
    local names_25111=("${!1}")
    local texts_25112=("${!2}")
    local notes_25113=("${!3}")
    local min_name_width_25114="${4}"
    local __length_421=("${names_25111[@]}")
    local count_25115="${#__length_421[@]}"
    local name_width_25116="${min_name_width_25114}"
    local __range_start_25117=0
    local __range_end_25117="${count_25115}"
    local __dir_25117=$(( ${__range_start_25117} <= ${__range_end_25117} ? 1 : -1 ))
    for (( i_25117=${__range_start_25117}; i_25117 * ${__dir_25117} < ${__range_end_25117} * ${__dir_25117}; i_25117+=${__dir_25117} )); do
        local __length_422="${names_25111[${i_25117}]?"Index out of bounds (at src/./file/../utils.ab:326:33)"}"
        local width_25118="${#__length_422}"
        if [ "$(( width_25118 > name_width_25116 ))" != 0 ]; then
            name_width_25116="${width_25118}"
        fi
done
    term_width__1997_v0 
    local width_25119="${ret_term_width1997_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_25120="$(( name_width_25116 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_25121="$(( $(( width_25119 - indent_25120 )) < 24 ))"
    if [ "${stacked_25121}" != 0 ]; then
        indent_25120=6
    fi
    local avail_25122="$(( width_25119 - indent_25120 ))"
    rpad__28_v0 "" " " "${indent_25120}"
    local blank_25123="${ret_rpad28_v0}"
    local __range_start_25124=0
    local __range_end_25124="${count_25115}"
    local __dir_25124=$(( ${__range_start_25124} <= ${__range_end_25124} ? 1 : -1 ))
    for (( i_25124=${__range_start_25124}; i_25124 * ${__dir_25124} < ${__range_end_25124} * ${__dir_25124}; i_25124+=${__dir_25124} )); do
        local pending_25125="${blank_25123}"
        if [ "${stacked_25121}" != 0 ]; then
            local array_423=()
            printf__128_v0 "  ""${names_25111[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:346:33)"}""
" array_423[@]
        else
            rpad__28_v0 "  ""${names_25111[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:348:41)"}" " " "${indent_25120}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_25125="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_25112[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_25126=("${ret_split4_v0__350_21[@]}")
        local __length_424=("${words_25126[@]}")
        local note_start_25127="${#__length_424[@]}"
        if [ "$([ "_${notes_25113[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_425="${notes_25113[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_425} > avail_25122 ))" != 0 ]; then
                split__4_v0 "${notes_25113[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_25126+=("${ret_split4_v0__356_26[@]}")
            else
                local array_426=("${notes_25113[${i_25124}]?"Index out of bounds (at src/./file/../utils.ab:358:33)"}")
                words_25126+=("${array_426[@]}")
            fi
        fi
        local line_25128=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_25129=-1
        local __range_start_25130=0
        local __length_427=("${words_25126[@]}")
        local __range_end_25130="${#__length_427[@]}"
        local __dir_25130=$(( ${__range_start_25130} <= ${__range_end_25130} ? 1 : -1 ))
        for (( j_25130=${__range_start_25130}; j_25130 * ${__dir_25130} < ${__range_end_25130} * ${__dir_25130}; j_25130+=${__dir_25130} )); do
            local word_25131="${words_25126[${j_25130}]?"Index out of bounds (at src/./file/../utils.ab:368:32)"}"
            local candidate_25132
            candidate_25132="$(if [ "$([ "_${line_25128}" != "_" ]; echo $?)" != 0 ]; then echo "${word_25131}"; else echo "${line_25128}"" ""${word_25131}"; fi)"
            local __length_428="${candidate_25132}"
            if [ "$(( $(( ${#__length_428} > avail_25122 )) && $([ "_${line_25128}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2053_v0 "${pending_25125}" "${line_25128}" "${note_at_25129}"
                pending_25125="${blank_25123}"
                line_25128="${word_25131}"
                note_at_25129="$(if [ "$(( j_25130 >= note_start_25127 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_25130 >= note_start_25127 )) && $(( note_at_25129 < 0 )) ))" != 0 ]; then
                    local __length_429="${candidate_25132}"
                    local __length_430="${word_25131}"
                    note_at_25129="$(( ${#__length_429} - ${#__length_430} ))"
                fi
                line_25128="${candidate_25132}"
            fi
done
        print_help_line__2053_v0 "${pending_25125}" "${line_25128}" "${note_at_25129}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__2055_v0() {
    local pieces_25071=("${!1}")
    term_width__1997_v0 
    local width_25077="${ret_term_width1997_v0}"
    local line_25078=""
    local line_len_25079=0
    for piece_25080 in "${pieces_25071[@]}"; do
        local __length_433="${piece_25080}"
        local piece_len_25081="${#__length_433}"
        has_ansi_escape__2044_v0 "${piece_25080}"
        local ret_has_ansi_escape2044_v0__397_12="${ret_has_ansi_escape2044_v0}"
        if [ "${ret_has_ansi_escape2044_v0__397_12}" != 0 ]; then
            get_visible_len__2048_v0 "${piece_25080}"
            piece_len_25081="${ret_get_visible_len2048_v0}"
        fi
        if [ "$([ "_${line_25078}" != "_" ]; echo $?)" != 0 ]; then
            line_25078="${piece_25080}"
            line_len_25079="${piece_len_25081}"
        elif [ "$(( $(( $(( line_len_25079 + 1 )) + piece_len_25081 )) > width_25077 ))" != 0 ]; then
            local array_434=()
            printf__128_v0 "${line_25078}""
" array_434[@]
            line_25078="${piece_25080}"
            line_len_25079="${piece_len_25081}"
        else
            line_25078+=" ""${piece_25080}"
            line_len_25079="$(( line_len_25079 + $(( 1 + piece_len_25081 )) ))"
        fi
    done
    if [ "$([ "_${line_25078}" == "_" ]; echo $?)" != 0 ]; then
        local array_435=()
        printf__128_v0 "${line_25078}""
" array_435[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
command_436="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_96="$([ "_${command_436}" != "_No" ]; echo $?)"
command_437="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_97="$(( $(( ! _perl_disabled_96 )) && $([ "_${command_437}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2206_v0() {
    local text_25198="${1}"
    if [ "$(( ! _perl_available_97 ))" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return 1
    fi
    local command_438
    command_438="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_25198}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return "${__status}"
    fi
    local width_str_25199="${command_438}"
    parse_int__13_v0 "${width_str_25199}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return "${__status}"
    fi
    local width_25200="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2206_v0="${width_25200}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2207_v0() {
    local text_25209="${1}"
    local max_width_25210="${2}"
    if [ "$(( ! _perl_available_97 ))" != 0 ]; then
        ret_perl_truncate_cjk2207_v0=''
        return 1
    fi
    local command_439
    command_439="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_25209}" ${max_width_25210} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2207_v0=''
        return "${__status}"
    fi
    local result_25211="${command_439}"
    ret_perl_truncate_cjk2207_v0="${result_25211}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_98=0
_term_size_99=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2214_v0() {
    local command_441
    command_441="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_25180="${command_441}"
    parse_int__13_v0 "${count_25180}"
    __status=$?
    ret_stty_count2214_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2215_v0() {
    stty_count__2214_v0 
    local count_num_25181="${ret_stty_count2214_v0}"
    if [ "$(( count_num_25181 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_25181="$(( count_num_25181 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25181}
    __status=$?
}

# stty_unlock()
stty_unlock__2216_v0() {
    stty_count__2214_v0 
    local count_num_25316="${ret_stty_count2214_v0}"
    if [ "$(( count_num_25316 > 0 ))" != 0 ]; then
        count_num_25316="$(( count_num_25316 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25316}
        __status=$?
        if [ "$(( count_num_25316 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2217_v0() {
    local size_25185="${1}"
    if [ "$([ "_${size_25185}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2217_v0=0
        return 0
    fi
    split__4_v0 "${size_25185}" " "
    local parts_25186=("${ret_split4_v0[@]}")
    local __length_442=("${parts_25186[@]}")
    if [ "$(( ${#__length_442[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_25186[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_25186[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_99=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size2217_v0=1
    return 0
}

# query_term_size()
query_term_size__2218_v0() {
    local command_444
    command_444="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_25188="${command_444}"
    store_term_size__2217_v0 "${size_25188}"
    ret_query_term_size2218_v0="${ret_store_term_size2217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2219_v0() {
    local command_445
    command_445="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_25184="${command_445}"
    store_term_size__2217_v0 "${size_25184}"
    ret_stty_term_size2219_v0="${ret_store_term_size2217_v0}"
    return 0
}

# get_term_size()
get_term_size__2220_v0() {
    stty_term_size__2219_v0 
    local detected_25187="${ret_stty_term_size2219_v0}"
    if [ "$(( ! detected_25187 ))" != 0 ]; then
        query_term_size__2218_v0 
        detected_25187="${ret_query_term_size2218_v0}"
    fi
    _got_term_size_98=1
}

# term_width()
term_width__2222_v0() {
    if [ "$(( ! _got_term_size_98 ))" != 0 ]; then
        get_term_size__2220_v0 
    fi
    ret_term_width2222_v0="${_term_size_99[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__2223_v0() {
    if [ "$(( ! _got_term_size_98 ))" != 0 ]; then
        get_term_size__2220_v0 
    fi
    ret_term_height2223_v0="${_term_size_99[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_100="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_101=0
_secondary_color_103=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2233_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_25279="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_25279}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_100="No"
        ret_get_supports_truecolor2233_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_100="No"
        ret_get_supports_truecolor2233_v0=0
        return 0
    fi
    local colorterm_25280="${ret_env_var_get120_v0}"
    _supports_truecolor_100="$(if [ "$(( $([ "_${colorterm_25280}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_25280}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2233_v0="$([ "_${_supports_truecolor_100}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2234_v0() {
    local message_25274="${1}"
    local r_25275="${2}"
    local g_25276="${3}"
    local b_25277="${4}"
    local fallback_25278="${5}"
    if [ "$([ "_${_supports_truecolor_100}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2234_v0="\\x1b[38;2;${r_25275};${g_25276};${b_25277}m""${message_25274}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_100}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2233_v0 
        local ret_get_supports_truecolor2233_v0__50_17="${ret_get_supports_truecolor2233_v0}"
        if [ "${ret_get_supports_truecolor2233_v0__50_17}" != 0 ]; then
            ret_colored_rgb2234_v0="\\x1b[38;2;${r_25275};${g_25276};${b_25277}m""${message_25274}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_25278 == 0 ))" != 0 ]; then
            ret_colored_rgb2234_v0="${message_25274}"
            return 0
        else
            ret_colored_rgb2234_v0="\\x1b[${fallback_25278}m""${message_25274}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_25278 == 0 ))" != 0 ]; then
            ret_colored_rgb2234_v0="${message_25274}"
            return 0
        fi
        ret_colored_rgb2234_v0="\\x1b[${fallback_25278}m""${message_25274}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2236_v0() {
    if [ "$(( ! _got_xylitol_colors_101 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_25268="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_25268}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_25268}" ";"
            local parts_25269=("${ret_split4_v0[@]}")
            local __length_449=("${parts_25269[@]}")
            if [ "$(( ${#__length_449[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25269[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25269[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25269[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25269[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_25270="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_25270}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_25270}" ";"
            local parts_25271=("${ret_split4_v0[@]}")
            local __length_451=("${parts_25271[@]}")
            if [ "$(( ${#__length_451[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25271[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25271[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25271[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25271[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_103=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_25272="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_25272}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_25272}" ";"
            local parts_25273=("${ret_split4_v0[@]}")
            local __length_453=("${parts_25273[@]}")
            if [ "$(( ${#__length_453[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25273[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25273[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25273[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25273[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_101=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2237_v0() {
    inner_get_xylitol_colors__2236_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_101=1
}

# colored_secondary(message: Text)
colored_secondary__2239_v0() {
    local message_25267="${1}"
    if [ "$(( ! _got_xylitol_colors_101 ))" != 0 ]; then
        get_xylitol_colors__2237_v0 
    fi
    colored_rgb__2234_v0 "${message_25267}" "${_secondary_color_103[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_103[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_103[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_103[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2239_v0="${ret_colored_rgb2234_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2254_v0() {
    local command_455
    command_455="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_25293="${command_455}"
    if [ "$([ "_${var_25293}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="UP"
        return 0
    elif [ "$([ "_${var_25293}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="DOWN"
        return 0
    elif [ "$([ "_${var_25293}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_25293}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="LEFT"
        return 0
    elif [ "$([ "_${var_25293}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_25293}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="INPUT"
        return 0
    else
        ret_get_key2254_v0="${var_25293}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2256_v0() {
    local format_25182="${1}"
    local args_25183=("${!2}")
    args_25183=("${format_25182}" "${args_25183[@]}")
    __status=$?
    printf "${args_25183[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2257_v0() {
    local message_25230="${1}"
    local color_25231="${2}"
    # Prints an error message with a specified color.
    local array_456=("${message_25230}")
    eprintf__2256_v0 "\\x1b[${color_25231}m%s\\x1b[0m" array_456[@]
}

# colored(message: Text, color: Int)
colored__2258_v0() {
    local message_25238="${1}"
    local color_25239="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2258_v0="\\x1b[${color_25239}m""${message_25238}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2260_v0() {
    local cnt_25290="${1}"
    if [ "$(( cnt_25290 > 0 ))" != 0 ]; then
        local sequence_25291=""
        local __range_start_25292=0
        local __range_end_25292="${cnt_25290}"
        local __dir_25292=$(( ${__range_start_25292} <= ${__range_end_25292} ? 1 : -1 ))
        for (( ____25292=${__range_start_25292}; ____25292 * ${__dir_25292} < ${__range_end_25292} * ${__dir_25292}; ____25292+=${__dir_25292} )); do
            sequence_25291+="\\x1b[2K\\x1b[1A"
done
        local array_457=("")
        eprintf__2256_v0 "${sequence_25291}" array_457[@]
    fi
    local array_458=("")
    eprintf__2256_v0 "\\x1b[G" array_458[@]
}

# remove_current_line()
remove_current_line__2261_v0() {
    local array_459=("")
    eprintf__2256_v0 "\\x1b[2K\\x1b[G" array_459[@]
}

# print_blank(cnt: Int)
print_blank__2262_v0() {
    local cnt_25281="${1}"
    printf '%*s' "${cnt_25281}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2263_v0() {
    local cnt_25228="${1}"
    local __range_start_25229=0
    local __range_end_25229="${cnt_25228}"
    local __dir_25229=$(( ${__range_start_25229} <= ${__range_end_25229} ? 1 : -1 ))
    for (( ____25229=${__range_start_25229}; ____25229 * ${__dir_25229} < ${__range_end_25229} * ${__dir_25229}; ____25229+=${__dir_25229} )); do
        local array_460=("")
        eprintf__2256_v0 "
" array_460[@]
done
}

# go_up(cnt: Int)
go_up__2264_v0() {
    local cnt_25247="${1}"
    local array_461=("")
    eprintf__2256_v0 "\\x1b[${cnt_25247}A" array_461[@]
}

# go_down(cnt: Int)
go_down__2265_v0() {
    local cnt_25302="${1}"
    local array_462=("")
    eprintf__2256_v0 "\\x1b[${cnt_25302}B" array_462[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2266_v0() {
    local cnt_25311="${1}"
    if [ "$(( cnt_25311 > 0 ))" != 0 ]; then
        go_down__2265_v0 "${cnt_25311}"
    else
        go_up__2264_v0 "$(( - cnt_25311 ))"
    fi
}

# hide_cursor()
hide_cursor__2267_v0() {
    local array_463=("")
    eprintf__2256_v0 "\\x1b[?25l" array_463[@]
}

# show_cursor()
show_cursor__2268_v0() {
    local array_464=("")
    eprintf__2256_v0 "\\x1b[?25h" array_464[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2269_v0() {
    local text_25204="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_465
    command_465="$([[ "${text_25204}" == *$'\x1b'* || "${text_25204}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_25205="${command_465}"
    ret_has_ansi_escape2269_v0="$([ "_${has_escape_25205}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2271_v0() {
    local text_25194="${1}"
    local command_466
    command_466="$(printf "%s" "${text_25194}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2271_v0="${command_466}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2272_v0() {
    local text_25196="${1}"
    local command_467
    command_467="$(printf "%s" "${text_25196}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_25197="${command_467}"
    ret_is_all_ascii2272_v0="$([ "_${result_25197}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2273_v0() {
    local text_25193="${1}"
    strip_ansi__2271_v0 "${text_25193}"
    local stripped_25195="${ret_strip_ansi2271_v0}"
    # Check if text is all ASCII
    is_all_ascii__2272_v0 "${stripped_25195}"
    local ret_is_all_ascii2272_v0__150_12="${ret_is_all_ascii2272_v0}"
    if [ "$(( ! ret_is_all_ascii2272_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2206_v0 "${stripped_25195}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_468="${stripped_25195}"
            ret_get_visible_len2273_v0="${#__length_468}"
            return 0
        fi
        ret_get_visible_len2273_v0="${ret_perl_get_cjk_width2206_v0}"
        return 0
    else
        local __length_469="${stripped_25195}"
        ret_get_visible_len2273_v0="${#__length_469}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2274_v0() {
    local text_25206="${1}"
    local max_width_25207="${2}"
    get_visible_len__2273_v0 "${text_25206}"
    local visible_len_25208="${ret_get_visible_len2273_v0}"
    if [ "$(( visible_len_25208 <= max_width_25207 ))" != 0 ]; then
        ret_truncate_text2274_v0="${text_25206}"
        return 0
    fi
    is_all_ascii__2272_v0 "${text_25206}"
    local ret_is_all_ascii2272_v0__167_12="${ret_is_all_ascii2272_v0}"
    if [ "$(( ! ret_is_all_ascii2272_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2207_v0 "${text_25206}" "${max_width_25207}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_25206}" | cut -c1-${max_width_25207}
            __status=$?
        fi
        ret_truncate_text2274_v0="${ret_perl_truncate_cjk2207_v0}"
        return 0
    fi
    local command_470
    command_470="$(printf "%s" "${text_25206}" | cut -c1-${max_width_25207})"
    __status=$?
    ret_truncate_text2274_v0="${command_470}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2275_v0() {
    local text_25202="${1}"
    local max_width_25203="${2}"
    has_ansi_escape__2269_v0 "${text_25202}"
    local ret_has_ansi_escape2269_v0__179_12="${ret_has_ansi_escape2269_v0}"
    if [ "$(( ! ret_has_ansi_escape2269_v0__179_12 ))" != 0 ]; then
        truncate_text__2274_v0 "${text_25202}" "${max_width_25203}"
        ret_truncate_ansi2275_v0="${ret_truncate_text2274_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_471
    command_471="$([[ "${text_25202}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_25212="${command_471}"
    # Replace \x1b[ with newline, then split
    local command_472
    command_472="$(t="${text_25202}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_25213="${command_472}"
    split__4_v0 "${replaced_25213}" "
"
    local parts_25214=("${ret_split4_v0[@]}")
    local result_25215=""
    local remaining_width_25216="${max_width_25203}"
    local __range_start_25217=0
    local __length_473=("${parts_25214[@]}")
    local __range_end_25217="${#__length_473[@]}"
    local __dir_25217=$(( ${__range_start_25217} <= ${__range_end_25217} ? 1 : -1 ))
    for (( idx_25217=${__range_start_25217}; idx_25217 * ${__dir_25217} < ${__range_end_25217} * ${__dir_25217}; idx_25217+=${__dir_25217} )); do
        local part_25218="${parts_25214[${idx_25217}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_25217 == 0 )) && $([ "_${starts_with_ansi_25212}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_25218}" == "_" ]; echo $?) && $(( remaining_width_25216 > 0 )) ))" != 0 ]; then
                truncate_text__2274_v0 "${part_25218}" "${remaining_width_25216}"
                local ret_truncate_text2274_v0__201_35="${ret_truncate_text2274_v0}"
                local truncated_25219="${ret_truncate_text2274_v0__201_35}"
                result_25215+="${truncated_25219}"
                get_visible_len__2273_v0 "${truncated_25219}"
                local ret_get_visible_len2273_v0__203_36="${ret_get_visible_len2273_v0}"
                remaining_width_25216="$(( remaining_width_25216 - ret_get_visible_len2273_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_474
            command_474="$(__p="${part_25218}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_25220="${command_474}"
            if [ "$([ "_${m_idx_25220}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_475
                command_475="$(__p="${part_25218}"; printf "%s" "${__p:0:${m_idx_25220}}")"
                __status=$?
                local ansi_params_25221="${command_475}"
                result_25215+="\\x1b[""${ansi_params_25221}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_25220}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_25222="${ret_parse_int13_v0__214_41}"
                local text_start_25223="$(( m_idx_num_25222 + 1 ))"
                local command_476
                command_476="$(__p="${part_25218}"; printf "%s" "${__p:${text_start_25223}}")"
                __status=$?
                local text_part_25224="${command_476}"
                if [ "$(( $([ "_${text_part_25224}" == "_" ]; echo $?) && $(( remaining_width_25216 > 0 )) ))" != 0 ]; then
                    truncate_text__2274_v0 "${text_part_25224}" "${remaining_width_25216}"
                    local ret_truncate_text2274_v0__218_39="${ret_truncate_text2274_v0}"
                    local truncated_25225="${ret_truncate_text2274_v0__218_39}"
                    result_25215+="${truncated_25225}"
                    get_visible_len__2273_v0 "${truncated_25225}"
                    local ret_get_visible_len2273_v0__220_40="${ret_get_visible_len2273_v0}"
                    remaining_width_25216="$(( remaining_width_25216 - ret_get_visible_len2273_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_25218}" == "_" ]; echo $?) && $(( remaining_width_25216 > 0 )) ))" != 0 ]; then
                    truncate_text__2274_v0 "${part_25218}" "${remaining_width_25216}"
                    local ret_truncate_text2274_v0__225_39="${ret_truncate_text2274_v0}"
                    local truncated_25226="${ret_truncate_text2274_v0__225_39}"
                    result_25215+="${truncated_25226}"
                    get_visible_len__2273_v0 "${truncated_25226}"
                    local ret_get_visible_len2273_v0__227_40="${ret_get_visible_len2273_v0}"
                    remaining_width_25216="$(( remaining_width_25216 - ret_get_visible_len2273_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2275_v0="${result_25215}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2276_v0() {
    local text_25191="${1}"
    local max_width_25192="${2}"
    get_visible_len__2273_v0 "${text_25191}"
    local visible_len_25201="${ret_get_visible_len2273_v0}"
    if [ "$(( visible_len_25201 <= max_width_25192 ))" != 0 ]; then
        ret_cutoff_text2276_v0="${text_25191}"
        return 0
    fi
    truncate_ansi__2275_v0 "${text_25191}" "$(( max_width_25192 - 3 ))"
    local ret_truncate_ansi2275_v0__243_12="${ret_truncate_ansi2275_v0}"
    ret_cutoff_text2276_v0="${ret_truncate_ansi2275_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2277_v0() {
    local items_25232=("${!1}")
    local total_len_25233="${2}"
    local term_width_25234="${3}"
    local separator_25235=" • "
    local separator_len_25236=3
    # Fast path: no truncation needed
    if [ "$(( total_len_25233 <= term_width_25234 ))" != 0 ]; then
        local iter_25237=0
        while :
        do
            local __length_477=("${items_25232[@]}")
            if [ "$(( iter_25237 >= ${#__length_477[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_25237 > 0 ))" != 0 ]; then
                eprintf_colored__2257_v0 "${separator_25235}" 90
            fi
            colored__2258_v0 "${items_25232[$(( iter_25237 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2258_v0__268_41="${ret_colored2258_v0}"
            local array_478=("")
            eprintf__2256_v0 "${items_25232[${iter_25237}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2258_v0__268_41}" array_478[@]
            iter_25237="$(( iter_25237 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_25240=0
        local first_25241=1
        local iter_25242=0
        while :
        do
            local __length_479=("${items_25232[@]}")
            if [ "$(( iter_25242 >= ${#__length_479[@]} ))" != 0 ]; then
                break
            fi
            local key_25243="${items_25232[${iter_25242}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_25244="${items_25232[$(( iter_25242 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_480="${key_25243}"
            local __length_481="${action_25244}"
            local part_len_25245="$(( $(( ${#__length_480} + 1 )) + ${#__length_481} ))"
            local needed_25246="${part_len_25245}"
            if [ "$(( ! first_25241 ))" != 0 ]; then
                needed_25246="$(( needed_25246 + separator_len_25236 ))"
            fi
            if [ "$(( $(( current_len_25240 + needed_25246 )) > term_width_25234 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_25241 ))" != 0 ]; then
                eprintf_colored__2257_v0 "${separator_25235}" 90
            fi
            colored__2258_v0 "${action_25244}" 2
            local ret_colored2258_v0__296_33="${ret_colored2258_v0}"
            local array_482=("")
            eprintf__2256_v0 "${key_25243}"" ""${ret_colored2258_v0__296_33}" array_482[@]
            current_len_25240="$(( current_len_25240 + needed_25246 ))"
            first_25241=0
            iter_25242="$(( iter_25242 + 2 ))"
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
__CHOOSER_CONTINUE_106=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_107=1
# The user confirmed the selection.
__CHOOSER_DONE_108=2
_total_109=0
_page_size_110=10
_display_count_111=0
_total_pages_112=1
_current_page_113=0
_selected_114=0
_cursor_115="> "
_multi_116=0
_limit_117=-1
_term_width_118=80
_has_header_119=0
_page_120=()
_page_count_121=0
_checked_122=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_123=0
_first_render_124=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_125=0
# render_single_page()
render_single_page__2331_v0() {
    local __length_485="${_cursor_115}"
    local cursor_len_25284="${#__length_485}"
    local max_option_width_25285="$(( $(( _term_width_118 - cursor_len_25284 )) - 1 ))"
    local __range_start_25286=0
    local __range_end_25286="${_page_count_121}"
    local __dir_25286=$(( ${__range_start_25286} <= ${__range_end_25286} ? 1 : -1 ))
    for (( i_25286=${__range_start_25286}; i_25286 * ${__dir_25286} < ${__range_end_25286} * ${__dir_25286}; i_25286+=${__dir_25286} )); do
        cutoff_text__2276_v0 "${_page_120[${i_25286}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_25285}"
        local ret_cutoff_text2276_v0__48_27="${ret_cutoff_text2276_v0}"
        local truncated_25287="${ret_cutoff_text2276_v0__48_27}"
        if [ "$(( i_25286 == _selected_114 ))" != 0 ]; then
            colored_secondary__2239_v0 "${_cursor_115}""${truncated_25287}""
"
            local ret_colored_secondary2239_v0__50_21="${ret_colored_secondary2239_v0}"
            local array_486=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__50_21}" array_486[@]
        else
            print_blank__2262_v0 "${cursor_len_25284}"
            local array_487=("")
            eprintf__2256_v0 "${truncated_25287}""
" array_487[@]
        fi
done
    local remaining_slots_25288="$(( _display_count_111 - _page_count_121 ))"
    if [ "$(( remaining_slots_25288 > 0 ))" != 0 ]; then
        local __range_start_25289=0
        local __range_end_25289="${remaining_slots_25288}"
        local __dir_25289=$(( ${__range_start_25289} <= ${__range_end_25289} ? 1 : -1 ))
        for (( ____25289=${__range_start_25289}; ____25289 * ${__dir_25289} < ${__range_end_25289} * ${__dir_25289}; ____25289+=${__dir_25289} )); do
            local array_488=("")
            eprintf__2256_v0 "\\x1b[K
" array_488[@]
done
    fi
}

# render_multi_page()
render_multi_page__2332_v0() {
    local __length_489="${_cursor_115}"
    local cursor_len_25260="${#__length_489}"
    local max_option_width_25261="$(( $(( _term_width_118 - cursor_len_25260 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2337_v0 
    local page_start_25262="${ret_chooser_page_start2337_v0}"
    local __range_start_25263=0
    local __range_end_25263="${_page_count_121}"
    local __dir_25263=$(( ${__range_start_25263} <= ${__range_end_25263} ? 1 : -1 ))
    for (( i_25263=${__range_start_25263}; i_25263 * ${__dir_25263} < ${__range_end_25263} * ${__dir_25263}; i_25263+=${__dir_25263} )); do
        local global_idx_25264="$(( page_start_25262 + i_25263 ))"
        local check_mark_25265
        check_mark_25265="$(if [ "${_checked_122[${global_idx_25264}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2276_v0 "${_page_120[${i_25263}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_25261}"
        local ret_cutoff_text2276_v0__71_27="${ret_cutoff_text2276_v0}"
        local truncated_25266="${ret_cutoff_text2276_v0__71_27}"
        if [ "$(( i_25263 == _selected_114 ))" != 0 ]; then
            colored_secondary__2239_v0 "${_cursor_115}""${check_mark_25265}""${truncated_25266}""
"
            local ret_colored_secondary2239_v0__73_37="${ret_colored_secondary2239_v0}"
            local array_490=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__73_37}" array_490[@]
        elif [ "${_checked_122[${global_idx_25264}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2262_v0 "${cursor_len_25260}"
            colored_secondary__2239_v0 "${check_mark_25265}""${truncated_25266}""
"
            local ret_colored_secondary2239_v0__76_25="${ret_colored_secondary2239_v0}"
            local array_491=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__76_25}" array_491[@]
        else
            print_blank__2262_v0 "${cursor_len_25260}"
            local array_492=("")
            eprintf__2256_v0 "${check_mark_25265}""${truncated_25266}""
" array_492[@]
        fi
done
    local remaining_slots_25282="$(( _display_count_111 - _page_count_121 ))"
    if [ "$(( remaining_slots_25282 > 0 ))" != 0 ]; then
        local __range_start_25283=0
        local __range_end_25283="${remaining_slots_25282}"
        local __dir_25283=$(( ${__range_start_25283} <= ${__range_end_25283} ? 1 : -1 ))
        for (( ____25283=${__range_start_25283}; ____25283 * ${__dir_25283} < ${__range_end_25283} * ${__dir_25283}; ____25283+=${__dir_25283} )); do
            local array_493=("")
            eprintf__2256_v0 "\\x1b[K
" array_493[@]
done
    fi
}

# render_page()
render_page__2333_v0() {
    if [ "${_multi_116}" != 0 ]; then
        render_multi_page__2332_v0 
    else
        render_single_page__2331_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2334_v0() {
    if [ "$(( _total_pages_112 > 1 ))" != 0 ]; then
        local array_494=("")
        eprintf__2256_v0 "\\x1b[G\\x1b[K" array_494[@]
        eprintf_colored__2257_v0 "Page $(( _current_page_113 + 1 ))/${_total_pages_112}" 90
        local array_495=("")
        eprintf__2256_v0 "\\x1b[G" array_495[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2335_v0() {
    if [ "$(( ! _multi_116 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_112 > 1 ))" != 0 ]; then
            local array_496=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2277_v0 array_496[@] 36 "${_term_width_118}"
        else
            local array_497=("↑↓" "select" "enter" "confirm")
            render_tooltip__2277_v0 array_497[@] 25 "${_term_width_118}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_112 > 1 )) && $(( _limit_117 < 0 )) ))" != 0 ]; then
            local array_498=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2277_v0 array_498[@] 55 "${_term_width_118}"
        elif [ "$(( _total_pages_112 > 1 ))" != 0 ]; then
            local array_499=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2277_v0 array_499[@] 47 "${_term_width_118}"
        elif [ "$(( _limit_117 < 0 ))" != 0 ]; then
            local array_500=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2277_v0 array_500[@] 44 "${_term_width_118}"
        else
            local array_501=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2277_v0 array_501[@] 36 "${_term_width_118}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2336_v0() {
    local total_25174="${1}"
    local page_size_25175="${2}"
    local header_25176="${3}"
    local cursor_25177="${4}"
    local multi_25178="${5}"
    local limit_25179="${6}"
    _total_109="${total_25174}"
    _cursor_115="${cursor_25177}"
    _multi_116="${multi_25178}"
    _limit_117="${limit_25179}"
    _current_page_113=0
    _selected_114=0
    _first_render_124=1
    _up_paged_125=0
    _checked_count_123=0
    _has_header_119="$([ "_${header_25176}" == "_" ]; echo $?)"
    stty_lock__2215_v0 
    hide_cursor__2267_v0 
    term_width__2222_v0 
    _term_width_118="${ret_term_width2222_v0}"
    term_height__2223_v0 
    local term_height_25189="${ret_term_height2223_v0}"
    local max_page_size_25190
    max_page_size_25190="$(( term_height_25189 - $(if [ "${_has_header_119}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_110="${page_size_25175}"
    if [ "$(( _page_size_110 > max_page_size_25190 ))" != 0 ]; then
        _page_size_110="${max_page_size_25190}"
    fi
    if [ "${_has_header_119}" != 0 ]; then
        cutoff_text__2276_v0 "${header_25176}" "${_term_width_118}"
        local ret_cutoff_text2276_v0__157_17="${ret_cutoff_text2276_v0}"
        local array_502=("")
        eprintf__2256_v0 "${ret_cutoff_text2276_v0__157_17}""
" array_502[@]
    fi
    math_floor__509_v0 "$(( $(( $(( total_25174 + _page_size_110 )) - 1 )) / _page_size_110 ))"
    _total_pages_112="${ret_math_floor509_v0}"
    _display_count_111="${_page_size_110}"
    if [ "$(( total_25174 < _page_size_110 ))" != 0 ]; then
        _display_count_111="${total_25174}"
    fi
    if [ "${multi_25178}" != 0 ]; then
        _checked_122=()
        local __range_start_25227=0
        local __range_end_25227="${total_25174}"
        local __dir_25227=$(( ${__range_start_25227} <= ${__range_end_25227} ? 1 : -1 ))
        for (( ____25227=${__range_start_25227}; ____25227 * ${__dir_25227} < ${__range_end_25227} * ${__dir_25227}; ____25227+=${__dir_25227} )); do
            local array_504=(0)
            _checked_122+=("${array_504[@]}")
done
    fi
    new_line__2263_v0 "${_display_count_111}"
    local array_505=("")
    eprintf__2256_v0 "\\x1b[G" array_505[@]
    if [ "$(( _total_pages_112 > 1 ))" != 0 ]; then
        eprintf_colored__2257_v0 "Page $(( _current_page_113 + 1 ))/${_total_pages_112}" 90
    fi
    new_line__2263_v0 1
    render_tooltip_line__2335_v0 
    go_up__2264_v0 "$(( _display_count_111 + 1 ))"
    local array_506=("")
    eprintf__2256_v0 "\\x1b[G" array_506[@]
}

# chooser_page_start()
chooser_page_start__2337_v0() {
    ret_chooser_page_start2337_v0="$(( _current_page_113 * _page_size_110 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2338_v0() {
    chooser_page_start__2337_v0 
    local start_25251="${ret_chooser_page_start2337_v0}"
    local end_25252="$(( start_25251 + _page_size_110 ))"
    if [ "$(( end_25252 > _total_109 ))" != 0 ]; then
        end_25252="${_total_109}"
    fi
    ret_chooser_page_count2338_v0="$(( end_25252 - start_25251 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2339_v0() {
    local page_25259=("${!1}")
    _page_120=("${page_25259[@]}")
    local __length_507=("${page_25259[@]}")
    _page_count_121="${#__length_507[@]}"
    if [ "${_first_render_124}" != 0 ]; then
        _first_render_124=0
        render_page__2333_v0 
    else
        if [ "${_up_paged_125}" != 0 ]; then
            _selected_114="$(( _page_count_121 - 1 ))"
            _up_paged_125=0
        fi
        go_up__2264_v0 1
        remove_line__2260_v0 "$(( _display_count_111 - 1 ))"
        remove_current_line__2261_v0 
        local array_508=("")
        eprintf__2256_v0 "\\x1b[G" array_508[@]
        render_page__2333_v0 
        render_page_indicator__2334_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2340_v0() {
    local prev_selected_25305="${1}"
    chooser_page_start__2337_v0 
    local page_start_25306="${ret_chooser_page_start2337_v0}"
    local check_width_25307
    check_width_25307="$(if [ "${_multi_116}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_509="${_cursor_115}"
    local max_option_width_25308="$(( $(( _term_width_118 - ${#__length_509} )) - check_width_25307 ))"
    go_up__2264_v0 "$(( _display_count_111 - prev_selected_25305 ))"
    local array_510=("")
    eprintf__2256_v0 "\\x1b[K" array_510[@]
    local __length_511="${_cursor_115}"
    print_blank__2262_v0 "${#__length_511}"
    if [ "${_multi_116}" != 0 ]; then
        local was_checked_25309="${_checked_122[$(( page_start_25306 + prev_selected_25305 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2276_v0 "${_page_120[${prev_selected_25305}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_25308}"
        local ret_cutoff_text2276_v0__232_63="${ret_cutoff_text2276_v0}"
        local prev_line_25310
        prev_line_25310="$(if [ "${was_checked_25309}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2276_v0__232_63}"
        if [ "${was_checked_25309}" != 0 ]; then
            colored_secondary__2239_v0 "${prev_line_25310}"
            local ret_colored_secondary2239_v0__234_21="${ret_colored_secondary2239_v0}"
            local array_512=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__234_21}" array_512[@]
        else
            local array_513=("")
            eprintf__2256_v0 "${prev_line_25310}" array_513[@]
        fi
    else
        cutoff_text__2276_v0 "${_page_120[${prev_selected_25305}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_25308}"
        local ret_cutoff_text2276_v0__239_17="${ret_cutoff_text2276_v0}"
        local array_514=("")
        eprintf__2256_v0 "${ret_cutoff_text2276_v0__239_17}" array_514[@]
    fi
    go_up_or_down__2266_v0 "$(( _selected_114 - prev_selected_25305 ))"
    local array_515=("")
    eprintf__2256_v0 "\\x1b[G" array_515[@]
    local array_516=("")
    eprintf__2256_v0 "\\x1b[K" array_516[@]
    local mark_25312
    mark_25312="$(if [ "${_multi_116}" != 0 ]; then echo "$(if [ "${_checked_122[$(( page_start_25306 + _selected_114 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2276_v0 "${_page_120[${_selected_114}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_25308}"
    local ret_cutoff_text2276_v0__246_48="${ret_cutoff_text2276_v0}"
    colored_secondary__2239_v0 "${_cursor_115}""${mark_25312}""${ret_cutoff_text2276_v0__246_48}"
    local ret_colored_secondary2239_v0__246_13="${ret_colored_secondary2239_v0}"
    local array_517=("")
    eprintf__2256_v0 "${ret_colored_secondary2239_v0__246_13}" array_517[@]
    go_down__2265_v0 "$(( _display_count_111 - _selected_114 ))"
    local array_518=("")
    eprintf__2256_v0 "\\x1b[G" array_518[@]
}

# redraw_current_line()
redraw_current_line__2341_v0() {
    chooser_page_start__2337_v0 
    local page_start_25299="${ret_chooser_page_start2337_v0}"
    local __length_519="${_cursor_115}"
    local max_option_width_25300="$(( $(( _term_width_118 - ${#__length_519} )) - 3 ))"
    go_up__2264_v0 "$(( _display_count_111 - _selected_114 ))"
    local array_520=("")
    eprintf__2256_v0 "\\x1b[G" array_520[@]
    local array_521=("")
    eprintf__2256_v0 "\\x1b[K" array_521[@]
    local check_mark_25301
    check_mark_25301="$(if [ "${_checked_122[$(( page_start_25299 + _selected_114 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2276_v0 "${_page_120[${_selected_114}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_25300}"
    local ret_cutoff_text2276_v0__260_54="${ret_cutoff_text2276_v0}"
    colored_secondary__2239_v0 "${_cursor_115}""${check_mark_25301}""${ret_cutoff_text2276_v0__260_54}"
    local ret_colored_secondary2239_v0__260_13="${ret_colored_secondary2239_v0}"
    local array_522=("")
    eprintf__2256_v0 "${ret_colored_secondary2239_v0__260_13}" array_522[@]
    go_down__2265_v0 "$(( _display_count_111 - _selected_114 ))"
    local array_523=("")
    eprintf__2256_v0 "\\x1b[G" array_523[@]
}

# chooser_step()
chooser_step__2342_v0() {
    get_key__2254_v0 
    local key_25294="${ret_get_key2254_v0}"
    local prev_selected_25295="${_selected_114}"
    local prev_page_25296="${_current_page_113}"
    chooser_page_start__2337_v0 
    local page_start_25297="${ret_chooser_page_start2337_v0}"
    _up_paged_125=0
    if [ "$(( $([ "_${key_25294}" != "_UP" ]; echo $?) || $([ "_${key_25294}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_114 == 0 )) && $(( _total_pages_112 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_113 > 0 ))" != 0 ]; then
                _current_page_113="$(( _current_page_113 - 1 ))"
            else
                _current_page_113="$(( _total_pages_112 - 1 ))"
            fi
            _up_paged_125=1
        elif [ "$(( _selected_114 == 0 ))" != 0 ]; then
            _selected_114="$(( _page_count_121 - 1 ))"
        else
            _selected_114="$(( _selected_114 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_25294}" != "_DOWN" ]; echo $?) || $([ "_${key_25294}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_114 == $(( _page_count_121 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_113 < $(( _total_pages_112 - 1 )) ))" != 0 ]; then
                _current_page_113="$(( _current_page_113 + 1 ))"
            else
                _current_page_113=0
            fi
            _selected_114=0
        else
            _selected_114="$(( _selected_114 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_25294}" != "_LEFT" ]; echo $?) || $([ "_${key_25294}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_113 > 0 ))" != 0 ]; then
            _current_page_113="$(( _current_page_113 - 1 ))"
        fi
        _selected_114=0
    elif [ "$(( $([ "_${key_25294}" != "_RIGHT" ]; echo $?) || $([ "_${key_25294}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_113 < $(( _total_pages_112 - 1 )) ))" != 0 ]; then
            _current_page_113="$(( _current_page_113 + 1 ))"
            _selected_114=0
        else
            _selected_114="$(( _page_count_121 - 1 ))"
        fi
    elif [ "$(( _multi_116 && $(( $([ "_${key_25294}" != "_x" ]; echo $?) || $([ "_${key_25294}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_25298="$(( page_start_25297 + _selected_114 ))"
        if [ "${_checked_122[${global_selected_25298}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_122["${global_selected_25298}"]=0
            _checked_count_123="$(( _checked_count_123 - 1 ))"
        elif [ "$(( $(( _limit_117 < 0 )) || $(( _checked_count_123 < _limit_117 )) ))" != 0 ]; then
            _checked_122["${global_selected_25298}"]=1
            _checked_count_123="$(( _checked_count_123 + 1 ))"
        else
            ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
            return 0
        fi
        redraw_current_line__2341_v0 
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
        return 0
    elif [ "$(( $(( _multi_116 && $(( $([ "_${key_25294}" != "_a" ]; echo $?) || $([ "_${key_25294}" != "_A" ]; echo $?) )) )) && $(( _limit_117 < 0 )) ))" != 0 ]; then
        local all_checked_25303="$(( _checked_count_123 == _total_109 ))"
        local __range_start_25304=0
        local __range_end_25304="${_total_109}"
        local __dir_25304=$(( ${__range_start_25304} <= ${__range_end_25304} ? 1 : -1 ))
        for (( i_25304=${__range_start_25304}; i_25304 * ${__dir_25304} < ${__range_end_25304} * ${__dir_25304}; i_25304+=${__dir_25304} )); do
            _checked_122["${i_25304}"]="$(( ! all_checked_25303 ))"
done
        _checked_count_123="$(if [ "${all_checked_25303}" != 0 ]; then echo 0; else echo "${_total_109}"; fi)"
        go_up__2264_v0 "${_display_count_111}"
        local array_524=("")
        eprintf__2256_v0 "\\x1b[G" array_524[@]
        render_page__2333_v0 
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
        return 0
    elif [ "$([ "_${key_25294}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2342_v0="${__CHOOSER_DONE_108}"
        return 0
    else
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
        return 0
    fi
    if [ "$(( prev_page_25296 != _current_page_113 ))" != 0 ]; then
        ret_chooser_step2342_v0="${__CHOOSER_NEED_PAGE_107}"
        return 0
    fi
    if [ "$(( prev_selected_25295 != _selected_114 ))" != 0 ]; then
        redraw_selection__2340_v0 "${prev_selected_25295}"
    fi
    ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
    return 0
}

# chooser_selected()
chooser_selected__2343_v0() {
    chooser_page_start__2337_v0 
    local ret_chooser_page_start2337_v0__362_12="${ret_chooser_page_start2337_v0}"
    ret_chooser_selected2343_v0="$(( ret_chooser_page_start2337_v0__362_12 + _selected_114 ))"
    return 0
}

# chooser_end()
chooser_end__2345_v0() {
    local total_lines_25315="$(( _display_count_111 + 2 ))"
    if [ "${_has_header_119}" != 0 ]; then
        total_lines_25315="$(( total_lines_25315 + 1 ))"
    fi
    go_down__2265_v0 1
    remove_line__2260_v0 "$(( total_lines_25315 - 1 ))"
    remove_current_line__2261_v0 
    stty_unlock__2216_v0 
    show_cursor__2268_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2354_v0() {
    local name_25255="${1}"
    local file_type_25256="${2}"
    local target_25257="${3}"
    if [ "$([ "_${file_type_25256}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2013_v0 "/"
        local ret_colored_primary2013_v0__10_23="${ret_colored_primary2013_v0}"
        ret_format_entry_display2354_v0="${name_25255}""${ret_colored_primary2013_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_25256}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2015_v0 " > "
        local ret_colored_accent2015_v0__13_23="${ret_colored_accent2015_v0}"
        colored_primary__2013_v0 "${target_25257}"
        local ret_colored_primary2013_v0__13_47="${ret_colored_primary2013_v0}"
        ret_format_entry_display2354_v0="${name_25255}""${ret_colored_accent2015_v0__13_23}""${ret_colored_primary2013_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2354_v0="${name_25255}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2355_v0() {
    local start_path_25146="${1}"
    local cursor_25147="${2}"
    local show_hidden_25148="${3}"
    local page_size_25149="${4}"
    stty_lock__1990_v0 
    # Initialize current path
    local current_path_25152="${start_path_25146}"
    if [ "$([ "_${current_path_25152}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1970_v0 
        current_path_25152="${ret_get_cwd1970_v0}"
    fi
    normalize_path__1971_v0 "${current_path_25152}"
    current_path_25152="${ret_normalize_path1971_v0}"
    while :
    do
        colored_primary__2013_v0 "Loading files..."
        local ret_colored_primary2013_v0__41_17="${ret_colored_primary2013_v0}"
        local array_525=("")
        eprintf__2031_v0 "${ret_colored_primary2013_v0__41_17}" array_525[@]
        get_directory_entries__1969_v0 "${current_path_25152}"
        local listed_25163=("${ret_get_directory_entries1969_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_25164=()
        local types_25165=()
        local targets_25166=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_25152}" == "_/" ]; echo $?)" != 0 ]; then
            names_25164+=("..")
            types_25165+=("d")
            targets_25166+=("")
        fi
        local __length_532=("${listed_25163[@]}")
        local listed_count_25167="$(( ${#__length_532[@]} / __ENTRY_STRIDE_82 ))"
        local __range_start_25168=0
        local __range_end_25168="${listed_count_25167}"
        local __dir_25168=$(( ${__range_start_25168} <= ${__range_end_25168} ? 1 : -1 ))
        for (( i_25168=${__range_start_25168}; i_25168 * ${__dir_25168} < ${__range_end_25168} * ${__dir_25168}; i_25168+=${__dir_25168} )); do
            local at_25169="$(( i_25168 * __ENTRY_STRIDE_82 ))"
            local name_25170="${listed_25163[${at_25169}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_25170}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_25148 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_533=("${name_25170}")
            names_25164+=("${array_533[@]}")
            local array_534=("${listed_25163[$(( at_25169 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_25165+=("${array_534[@]}")
            local array_535=("${listed_25163[$(( at_25169 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_25166+=("${array_535[@]}")
done
        local __length_536=("${names_25164[@]}")
        local total_25171="${#__length_536[@]}"
        if [ "$(( total_25171 == 0 ))" != 0 ]; then
            eprintf_colored__2032_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1991_v0 
            ret_xyl_file2355_v0=""
            return 0
        fi
        colored_primary__2013_v0 "${current_path_25152}"
        local header_25173="${ret_colored_primary2013_v0}"
        remove_current_line__2036_v0 
        chooser_begin__2336_v0 "${total_25171}" "${page_size_25149}" "${header_25173}" "${cursor_25147}" 0 -1
        local need_page_25248=1
        while :
        do
            if [ "${need_page_25248}" != 0 ]; then
                local page_25249=()
                chooser_page_start__2337_v0 
                local start_25250="${ret_chooser_page_start2337_v0}"
                chooser_page_count__2338_v0 
                local count_25253="${ret_chooser_page_count2338_v0}"
                local __range_start_25254="${start_25250}"
                local __range_end_25254="$(( start_25250 + count_25253 ))"
                local __dir_25254=$(( ${__range_start_25254} <= ${__range_end_25254} ? 1 : -1 ))
                for (( i_25254=${__range_start_25254}; i_25254 * ${__dir_25254} < ${__range_end_25254} * ${__dir_25254}; i_25254+=${__dir_25254} )); do
                    format_entry_display__2354_v0 "${names_25164[${i_25254}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_25165[${i_25254}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_25166[${i_25254}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display2354_v0__90_30="${ret_format_entry_display2354_v0}"
                    local array_538=("${ret_format_entry_display2354_v0__90_30}")
                    page_25249+=("${array_538[@]}")
done
                chooser_set_page__2339_v0 page_25249[@]
            fi
            chooser_step__2342_v0 
            local step_25313="${ret_chooser_step2342_v0}"
            if [ "$(( step_25313 == __CHOOSER_DONE_108 ))" != 0 ]; then
                break
            fi
            need_page_25248="$(( step_25313 == __CHOOSER_NEED_PAGE_107 ))"
        done
        chooser_selected__2343_v0 
        local selected_idx_25314="${ret_chooser_selected2343_v0}"
        chooser_end__2345_v0 
        local name_25317="${names_25164[${selected_idx_25314}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_25318="${types_25165[${selected_idx_25314}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_25317}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1973_v0 "${current_path_25152}"
            current_path_25152="${ret_get_parent_dir1973_v0}"
        elif [ "$([ "_${file_type_25318}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1972_v0 "${current_path_25152}" "${name_25317}"
            current_path_25152="${ret_path_join1972_v0}"
            normalize_path__1971_v0 "${current_path_25152}"
            current_path_25152="${ret_normalize_path1971_v0}"
        elif [ "$([ "_${file_type_25318}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_25323="${targets_25166[${selected_idx_25314}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_25324="${target_25323}"
            starts_with__22_v0 "${target_25323}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__1972_v0 "${current_path_25152}" "${target_25323}"
                target_path_25324="${ret_path_join1972_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_25324}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_25152="${target_path_25324}"
                normalize_path__1971_v0 "${current_path_25152}"
                current_path_25152="${ret_normalize_path1971_v0}"
            else
                stty_unlock__1991_v0 
                path_join__1972_v0 "${current_path_25152}" "${name_25317}"
                ret_xyl_file2355_v0="${ret_path_join1972_v0}"
                return 0
            fi
        else
            stty_unlock__1991_v0 
            path_join__1972_v0 "${current_path_25152}" "${name_25317}"
            ret_xyl_file2355_v0="${ret_path_join1972_v0}"
            return 0
        fi
    done
    stty_unlock__1991_v0 
    ret_xyl_file2355_v0=""
    return 0
}

# print_file_help()
print_file_help__2449_v0() {
    local usage_25070=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2055_v0 usage_25070[@]
    printf '%s\n' ""
    colored_primary__2013_v0 "file"
    local ret_colored_primary2013_v0__8_20="${ret_colored_primary2013_v0}"
    local title_25106=("${ret_colored_primary2013_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2055_v0 title_25106[@]
    printf '%s\n' ""
    colored_secondary__2014_v0 "Arguments:"
    local ret_colored_secondary2014_v0__11_12="${ret_colored_secondary2014_v0}"
    local array_541=()
    printf__128_v0 "${ret_colored_secondary2014_v0__11_12}""
" array_541[@]
    local arg_names_25108=("[<path>]")
    local arg_texts_25109=("Starting directory path")
    local arg_notes_25110=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2054_v0 arg_names_25108[@] arg_texts_25109[@] arg_notes_25110[@] 20
    printf '%s\n' ""
    colored_secondary__2014_v0 "Flags:"
    local ret_colored_secondary2014_v0__18_12="${ret_colored_secondary2014_v0}"
    local array_545=()
    printf__128_v0 "${ret_colored_secondary2014_v0__18_12}""
" array_545[@]
    local names_25138=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_25139=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_25140=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2054_v0 names_25138[@] texts_25139[@] notes_25140[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2501_v0() {
    local parameters_25064=("${!1}")
    local cursor_25065="> "
    local start_path_25066=""
    local show_hidden_25067=0
    local page_size_25068=10
    local __length_552=("${parameters_25064[@]}")
    local slice_upper_551="${#__length_552[@]}"
    local slice_offset_553=2
    local slice_offset_553=$((${slice_offset_553} > 0 ? ${slice_offset_553} : 0))
    local slice_length_554="$(( slice_upper_551 - slice_offset_553 ))"
    local slice_length_554=$((${slice_length_554} > 0 ? ${slice_length_554} : 0))
    for param_25069 in "${parameters_25064[@]:${slice_offset_553}:${slice_length_554}}"; do
        starts_with__22_v0 "${param_25069}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_25069}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_25069}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_25069}" != "_-h" ]; echo $?) || $([ "_${param_25069}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2449_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_555="--cursor="
            slice__24_v0 "${param_25069}" "${#__length_555}" 0
            cursor_25065="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_556="--path="
            slice__24_v0 "${param_25069}" "${#__length_556}" 0
            start_path_25066="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_25069}" != "_-a" ]; echo $?) || $([ "_${param_25069}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_25067=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_557="--page-size="
            slice__24_v0 "${param_25069}" "${#__length_557}" 0
            local value_25141="${ret_slice24_v0}"
            parse_int__13_v0 "${value_25141}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2032_v0 "ERROR: Invalid page-size value: ""${value_25141}""
" 31
                exit 1
            fi
            page_size_25068="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_25066="${param_25069}"
        fi
    done
    xyl_file__2355_v0 "${start_path_25066}" "${cursor_25065}" "${show_hidden_25067}" "${page_size_25068}"
    ret_execute_file2501_v0="${ret_xyl_file2355_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_131="0.1.0"
__AMBER_VERSION_132="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2503_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__261_v0 "Error: " 91
        local array_558=("")
        eprintf__260_v0 "bc is not installed. Please install bc to use xylitol.
" array_558[@]
        local array_559=("")
        eprintf__260_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_559[@]
        local array_560=("")
        eprintf__260_v0 "  For Fedora: sudo dnf install bc
" array_560[@]
        local array_561=("")
        eprintf__260_v0 "  For Arch Linux: sudo pacman -S bc
" array_561[@]
        ret_check_prerequirements2503_v0=0
        return 0
    fi
    ret_check_prerequirements2503_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2504_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_133=("$0" "$@")
trap_cleanup__2504_v0 
check_prerequirements__2503_v0 
ret_check_prerequirements2503_v0__32_12="${ret_check_prerequirements2503_v0}"
if [ "$(( ! ret_check_prerequirements2503_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_563=("${args_133[@]}")
if [ "$(( ${#__length_563[@]} < 2 ))" != 0 ]; then
    print_help__428_v0 
    exit 0
fi
command_1440="${args_133[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1440}" != "_help" ]; echo $?) || $([ "_${command_1440}" != "_--help" ]; echo $?) )) || $([ "_${command_1440}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__428_v0 
elif [ "$([ "_${command_1440}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__841_v0 args_133[@]
    ret_execute_input841_v0__48_18="${ret_execute_input841_v0}"
    printf '%s\n' "${ret_execute_input841_v0__48_18}"
elif [ "$([ "_${command_1440}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1367_v0 args_133[@]
    ret_execute_choose1367_v0__51_18="${ret_execute_choose1367_v0}"
    printf '%s\n' "${ret_execute_choose1367_v0__51_18}"
elif [ "$([ "_${command_1440}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1814_v0 args_133[@]
    result_16708="${ret_execute_confirm1814_v0}"
    if [ "$([ "_${result_16708}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1440}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2501_v0 args_133[@]
    ret_execute_file2501_v0__61_18="${ret_execute_file2501_v0}"
    printf '%s\n' "${ret_execute_file2501_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1440}" != "_version" ]; echo $?) || $([ "_${command_1440}" != "_--version" ]; echo $?) )) || $([ "_${command_1440}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__242_v0 "xylitol.sh"
    ret_colored_primary242_v0__64_20="${ret_colored_primary242_v0}"
    array_564=()
    printf__128_v0 "${ret_colored_primary242_v0__64_20}" array_564[@]
    array_565=()
    printf__128_v0 " version: " array_565[@]
    colored_accent__244_v0 "${__VERSION_131}"
    ret_colored_accent244_v0__66_20="${ret_colored_accent244_v0}"
    array_566=()
    printf__128_v0 "${ret_colored_accent244_v0__66_20}" array_566[@]
    printf '%s\n' ""
    printf_colored__259_v0 "written in Amber: " 90
    printf_colored__259_v0 "  ""${__AMBER_VERSION_132}" 90
else
    print_help__428_v0 
    printf_colored__259_v0 "ERROR: Unknown command '""${command_1440}""'" 91
fi
