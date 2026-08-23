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
    local text_1325="${1}"
    local delimiter_1326="${2}"
    local result_1327=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1326}" read -rd '' -A result_1327 < <(printf %s "$text_1325")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1326}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1327+=("$REPLY"); done < <(echo "$text_1325")
            __status=$?
        else
            IFS="${delimiter_1326}" read -rd '' -a result_1327 < <(printf %s "$text_1325")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1326}" read -rd '' -a result_1327 < <(printf %s "$text_1325")
        __status=$?
    fi
    ret_split4_v0=("${result_1327[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_14709=("${!1}")
    local delimiter_14710="${2}"
    local command_1
    command_1="$(IFS="${delimiter_14710}" ; printf "%s
" "${list_14709[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1329="${1}"
    [ -n "${text_1329}" ] && [ "${text_1329}" -eq "${text_1329}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1329}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_2703="${1}"
    local prefix_2704="${2}"
    [[ "${text_2703}" == "${prefix_2704}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1405="${1}"
    local index_1406="${2}"
    local length_1407="${3}"
    local result_1408=""
    if [ "$(( length_1407 == 0 ))" != 0 ]; then
        local __length_2="${text_1405}"
        length_1407="$(( ${#__length_2} - index_1406 ))"
    fi
    if [ "$(( length_1407 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1408}"
        return 0
    fi
    result_1408="${text_1405: ${index_1406}: ${length_1407}}"
    __status=$?
    ret_slice24_v0="${result_1408}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_16526="${1}"
    local pad_16527="${2}"
    local length_16528="${3}"
    local __length_3="${text_16526}"
    if [ "$(( length_16528 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_16526}"
        return 0
    fi
    local __length_4="${text_16526}"
    local pad_len_16529="$(( length_16528 - ${#__length_4} ))"
    local padding_16530=""
    printf -v padding_16530 "%${pad_len_16529}s" ""
    __status=$?
    padding_16530="${padding_16530// /${pad_16527}}"
    __status=$?
    ret_lpad27_v0="${padding_16530}""${text_16526}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1385="${1}"
    local pad_1386="${2}"
    local length_1387="${3}"
    local __length_5="${text_1385}"
    if [ "$(( length_1387 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1385}"
        return 0
    fi
    local __length_6="${text_1385}"
    local pad_len_1388="$(( length_1387 - ${#__length_6} ))"
    local padding_1389=""
    printf -v padding_1389 "%${pad_len_1388}s" ""
    __status=$?
    padding_1389="${padding_1389// /${pad_1386}}"
    __status=$?
    ret_rpad28_v0="${text_1385}""${padding_1389}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_16520="${1}"
    local pad_16521="${2}"
    local length_16522="${3}"
    local __length_7="${text_16520}"
    local text_length_16523="${#__length_7}"
    if [ "$(( length_16522 <= text_length_16523 ))" != 0 ]; then
        ret_cpad29_v0="${text_16520}"
        return 0
    fi
    local total_padding_16524="$(( length_16522 - text_length_16523 ))"
    local left_padding_length_16525="$(( text_length_16523 + $(( total_padding_16524 / 2 )) ))"
    lpad__27_v0 "${text_16520}" "${pad_16521}" "${left_padding_length_16525}"
    local left_padded_16531="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_16531}" "${pad_16521}" "${length_16522}"
    local center_padded_16532="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_16532}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_25109="${1}"
    [ -d "${path_25109}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1350="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1350}")"
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
" "${(P)name_1350}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1350}")"
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
    local format_1347="${1}"
    local args_1348=("${!2}")
    args_1348=("${format_1347}" "${args_1348[@]}")
    __status=$?
    printf "${args_1348[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1360="${1}"
    local args_1361=("${!2}")
    args_1361=("${format_1360}" "${args_1361[@]}")
    __status=$?
    printf "${args_1361[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1357="${1}"
    local color_1358="${2}"
    local color_code_1359=0
        color_code_1359="${color_1358}"
    local array_11=("${message_1357}")
    printf__128_v1 "\\x1b[${color_code_1359}m%s\\x1b[0m
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
    local text_1344="${1}"
    if [ "$(( ! _perl_available_6 ))" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return 1
    fi
    local command_14
    command_14="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1344}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return "${__status}"
    fi
    local width_str_1345="${command_14}"
    parse_int__13_v0 "${width_str_1345}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return "${__status}"
    fi
    local width_1346="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width210_v0="${width_1346}"
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
    local size_1324="${1}"
    if [ "$([ "_${size_1324}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size221_v0=0
        return 0
    fi
    split__4_v0 "${size_1324}" " "
    local parts_1328=("${ret_split4_v0[@]}")
    local __length_16=("${parts_1328[@]}")
    if [ "$(( ${#__length_16[@]} != 2 ))" != 0 ]; then
        ret_store_term_size221_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1328[1]?"Index out of bounds (at src/utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1328[0]?"Index out of bounds (at src/utils/term.ab:50:68)"}"
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
    local size_1331="${command_18}"
    store_term_size__221_v0 "${size_1331}"
    ret_query_term_size222_v0="${ret_store_term_size221_v0}"
    return 0
}

# stty_term_size()
stty_term_size__223_v0() {
    local command_19
    command_19="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1323="${command_19}"
    store_term_size__221_v0 "${size_1323}"
    ret_stty_term_size223_v0="${ret_store_term_size221_v0}"
    return 0
}

# get_term_size()
get_term_size__224_v0() {
    stty_term_size__223_v0 
    local detected_1330="${ret_stty_term_size223_v0}"
    if [ "$(( ! detected_1330 ))" != 0 ]; then
        query_term_size__222_v0 
        detected_1330="${ret_query_term_size222_v0}"
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
    local config_1367="${ret_env_var_get120_v0}"
    _supports_truecolor_9="$(if [ "$([ "_${config_1367}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor237_v0="$([ "_${_supports_truecolor_9}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__238_v0() {
    local message_1362="${1}"
    local r_1363="${2}"
    local g_1364="${3}"
    local b_1365="${4}"
    local fallback_1366="${5}"
    if [ "$([ "_${_supports_truecolor_9}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb238_v0="\\x1b[38;2;${r_1363};${g_1364};${b_1365}m""${message_1362}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_9}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__237_v0 
        local ret_get_supports_truecolor237_v0__45_17="${ret_get_supports_truecolor237_v0}"
        if [ "${ret_get_supports_truecolor237_v0__45_17}" != 0 ]; then
            ret_colored_rgb238_v0="\\x1b[38;2;${r_1363};${g_1364};${b_1365}m""${message_1362}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1366 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_1362}"
            return 0
        else
            ret_colored_rgb238_v0="\\x1b[${fallback_1366}m""${message_1362}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1366 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_1362}"
            return 0
        fi
        ret_colored_rgb238_v0="\\x1b[${fallback_1366}m""${message_1362}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__240_v0() {
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1351="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1351}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1351}" ";"
            local parts_1352=("${ret_split4_v0[@]}")
            local __length_23=("${parts_1352[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1352[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1352[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1352[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1352[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_11=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1353="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1353}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1353}" ";"
            local parts_1354=("${ret_split4_v0[@]}")
            local __length_25=("${parts_1354[@]}")
            if [ "$(( ${#__length_25[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1354[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1354[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1354[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1354[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_12=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1355="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1355}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1355}" ";"
            local parts_1356=("${ret_split4_v0[@]}")
            local __length_27=("${parts_1356[@]}")
            if [ "$(( ${#__length_27[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1356[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1356[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1356[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1356[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_13=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
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
    local message_1349="${1}"
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1349}" "${_primary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary242_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__243_v0() {
    local message_1369="${1}"
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1369}" "${_secondary_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary243_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__244_v0() {
    local message_1415="${1}"
    if [ "$(( ! _got_xylitol_colors_10 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1415}" "${_accent_color_13[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_13[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_13[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_13[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent244_v0="${ret_colored_rgb238_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__259_v0() {
    local message_25112="${1}"
    local color_25113="${2}"
    # Prints a text with a specified color.
    local array_29=("${message_25112}")
    printf__128_v1 "\\x1b[${color_25113}m%s\\x1b[0m" array_29[@]
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
    local message_1403="${1}"
    local color_1404="${2}"
    # Returns a text wrapped in color codes.
    ret_colored262_v0="\\x1b[${color_1404}m""${message_1403}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__273_v0() {
    local text_1337="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_31
    command_31="$([[ "${text_1337}" == *$'\x1b'* || "${text_1337}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1338="${command_31}"
    ret_has_ansi_escape273_v0="$([ "_${has_escape_1338}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__275_v0() {
    local text_1340="${1}"
    local command_32
    command_32="$(printf "%s" "${text_1340}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi275_v0="${command_32}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__276_v0() {
    local text_1342="${1}"
    local command_33
    command_33="$(printf "%s" "${text_1342}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1343="${command_33}"
    ret_is_all_ascii276_v0="$([ "_${result_1343}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__277_v0() {
    local text_1339="${1}"
    strip_ansi__275_v0 "${text_1339}"
    local stripped_1341="${ret_strip_ansi275_v0}"
    # Check if text is all ASCII
    is_all_ascii__276_v0 "${stripped_1341}"
    local ret_is_all_ascii276_v0__150_12="${ret_is_all_ascii276_v0}"
    if [ "$(( ! ret_is_all_ascii276_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__210_v0 "${stripped_1341}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_34="${stripped_1341}"
            ret_get_visible_len277_v0="${#__length_34}"
            return 0
        fi
        ret_get_visible_len277_v0="${ret_perl_get_cjk_width210_v0}"
        return 0
    else
        local __length_35="${stripped_1341}"
        ret_get_visible_len277_v0="${#__length_35}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__282_v0() {
    local pending_1400="${1}"
    local line_1401="${2}"
    local note_at_1402="${3}"
    if [ "$(( note_at_1402 < 0 ))" != 0 ]; then
        local array_36=()
        printf__128_v0 "${pending_1400}""${line_1401}""
" array_36[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1402 == 0 ))" != 0 ]; then
        colored__262_v0 "${line_1401}" 90
        local ret_colored262_v0__310_40="${ret_colored262_v0}"
        local array_37=()
        printf__128_v0 "${pending_1400}""${ret_colored262_v0__310_40}""
" array_37[@]
    else
        slice__24_v0 "${line_1401}" 0 "${note_at_1402}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1401}" "${note_at_1402}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__262_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored262_v0__311_58="${ret_colored262_v0}"
        local array_38=()
        printf__128_v0 "${pending_1400}""${ret_slice24_v0__311_32}""${ret_colored262_v0__311_58}""
" array_38[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__283_v0() {
    local names_1373=("${!1}")
    local texts_1374=("${!2}")
    local notes_1375=("${!3}")
    local min_name_width_1376="${4}"
    local __length_39=("${names_1373[@]}")
    local count_1377="${#__length_39[@]}"
    local name_width_1378="${min_name_width_1376}"
    local __range_start_1379=0
    local __range_end_1379="${count_1377}"
    local __dir_1379=$(( ${__range_start_1379} <= ${__range_end_1379} ? 1 : -1 ))
    for (( i_1379=${__range_start_1379}; i_1379 * ${__dir_1379} < ${__range_end_1379} * ${__dir_1379}; i_1379+=${__dir_1379} )); do
        local __length_40="${names_1373[${i_1379}]?"Index out of bounds (at src/./utils.ab:326:33)"}"
        local width_1380="${#__length_40}"
        if [ "$(( width_1380 > name_width_1378 ))" != 0 ]; then
            name_width_1378="${width_1380}"
        fi
done
    term_width__226_v0 
    local width_1381="${ret_term_width226_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1382="$(( name_width_1378 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1383="$(( $(( width_1381 - indent_1382 )) < 24 ))"
    if [ "${stacked_1383}" != 0 ]; then
        indent_1382=6
    fi
    local avail_1384="$(( width_1381 - indent_1382 ))"
    rpad__28_v0 "" " " "${indent_1382}"
    local blank_1390="${ret_rpad28_v0}"
    local __range_start_1391=0
    local __range_end_1391="${count_1377}"
    local __dir_1391=$(( ${__range_start_1391} <= ${__range_end_1391} ? 1 : -1 ))
    for (( i_1391=${__range_start_1391}; i_1391 * ${__dir_1391} < ${__range_end_1391} * ${__dir_1391}; i_1391+=${__dir_1391} )); do
        local pending_1392="${blank_1390}"
        if [ "${stacked_1383}" != 0 ]; then
            local array_41=()
            printf__128_v0 "  ""${names_1373[${i_1391}]?"Index out of bounds (at src/./utils.ab:346:33)"}""
" array_41[@]
        else
            rpad__28_v0 "  ""${names_1373[${i_1391}]?"Index out of bounds (at src/./utils.ab:348:41)"}" " " "${indent_1382}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_1392="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_1374[${i_1391}]?"Index out of bounds (at src/./utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_1393=("${ret_split4_v0__350_21[@]}")
        local __length_42=("${words_1393[@]}")
        local note_start_1394="${#__length_42[@]}"
        if [ "$([ "_${notes_1375[${i_1391}]?"Index out of bounds (at src/./utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_43="${notes_1375[${i_1391}]?"Index out of bounds (at src/./utils.ab:355:26)"}"
            if [ "$(( ${#__length_43} > avail_1384 ))" != 0 ]; then
                split__4_v0 "${notes_1375[${i_1391}]?"Index out of bounds (at src/./utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_1393+=("${ret_split4_v0__356_26[@]}")
            else
                local array_44=("${notes_1375[${i_1391}]?"Index out of bounds (at src/./utils.ab:358:33)"}")
                words_1393+=("${array_44[@]}")
            fi
        fi
        local line_1395=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1396=-1
        local __range_start_1397=0
        local __length_45=("${words_1393[@]}")
        local __range_end_1397="${#__length_45[@]}"
        local __dir_1397=$(( ${__range_start_1397} <= ${__range_end_1397} ? 1 : -1 ))
        for (( j_1397=${__range_start_1397}; j_1397 * ${__dir_1397} < ${__range_end_1397} * ${__dir_1397}; j_1397+=${__dir_1397} )); do
            local word_1398="${words_1393[${j_1397}]?"Index out of bounds (at src/./utils.ab:368:32)"}"
            local candidate_1399
            candidate_1399="$(if [ "$([ "_${line_1395}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1398}"; else echo "${line_1395}"" ""${word_1398}"; fi)"
            local __length_46="${candidate_1399}"
            if [ "$(( $(( ${#__length_46} > avail_1384 )) && $([ "_${line_1395}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__282_v0 "${pending_1392}" "${line_1395}" "${note_at_1396}"
                pending_1392="${blank_1390}"
                line_1395="${word_1398}"
                note_at_1396="$(if [ "$(( j_1397 >= note_start_1394 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1397 >= note_start_1394 )) && $(( note_at_1396 < 0 )) ))" != 0 ]; then
                    local __length_47="${candidate_1399}"
                    local __length_48="${word_1398}"
                    note_at_1396="$(( ${#__length_47} - ${#__length_48} ))"
                fi
                line_1395="${candidate_1399}"
            fi
done
        print_help_line__282_v0 "${pending_1392}" "${line_1395}" "${note_at_1396}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__284_v0() {
    local pieces_1322=("${!1}")
    term_width__226_v0 
    local width_1332="${ret_term_width226_v0}"
    local line_1333=""
    local line_len_1334=0
    for piece_1335 in "${pieces_1322[@]}"; do
        local __length_51="${piece_1335}"
        local piece_len_1336="${#__length_51}"
        has_ansi_escape__273_v0 "${piece_1335}"
        local ret_has_ansi_escape273_v0__397_12="${ret_has_ansi_escape273_v0}"
        if [ "${ret_has_ansi_escape273_v0__397_12}" != 0 ]; then
            get_visible_len__277_v0 "${piece_1335}"
            piece_len_1336="${ret_get_visible_len277_v0}"
        fi
        if [ "$([ "_${line_1333}" != "_" ]; echo $?)" != 0 ]; then
            line_1333="${piece_1335}"
            line_len_1334="${piece_len_1336}"
        elif [ "$(( $(( $(( line_len_1334 + 1 )) + piece_len_1336 )) > width_1332 ))" != 0 ]; then
            local array_52=()
            printf__128_v0 "${line_1333}""
" array_52[@]
            line_1333="${piece_1335}"
            line_len_1334="${piece_len_1336}"
        else
            line_1333+=" ""${piece_1335}"
            line_len_1334="$(( line_len_1334 + $(( 1 + piece_len_1336 )) ))"
        fi
    done
    if [ "$([ "_${line_1333}" == "_" ]; echo $?)" != 0 ]; then
        local array_53=()
        printf__128_v0 "${line_1333}""
" array_53[@]
    fi
}

# print_help()
print_help__428_v0() {
    local usage_1321=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__284_v0 usage_1321[@]
    printf '%s\n' ""
    colored_primary__242_v0 "Xylitol"
    local ret_colored_primary242_v0__9_21="${ret_colored_primary242_v0}"
    colored_primary__242_v0 "fresh"
    local ret_colored_primary242_v0__10_34="${ret_colored_primary242_v0}"
    local title_1368=("\\x1b[1m""${ret_colored_primary242_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary242_v0__10_34}" "shell" "scripts.")
    print_wrapped__284_v0 title_1368[@]
    printf '%s\n' ""
    colored_secondary__243_v0 "Flags:"
    local ret_colored_secondary243_v0__14_12="${ret_colored_secondary243_v0}"
    local array_56=()
    printf__128_v0 "${ret_colored_secondary243_v0__14_12}""
" array_56[@]
    local flag_names_1370=("-h, --help" "-v, --version")
    local flag_texts_1371=("Show this help message" "Show version information")
    local flag_notes_1372=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__283_v0 flag_names_1370[@] flag_texts_1371[@] flag_notes_1372[@] 13
    printf '%s\n' ""
    colored_secondary__243_v0 "Commands:"
    local ret_colored_secondary243_v0__21_12="${ret_colored_secondary243_v0}"
    local array_60=()
    printf__128_v0 "${ret_colored_secondary243_v0__21_12}""
" array_60[@]
    local cmd_names_1409=("input" "choose" "confirm" "file")
    local cmd_texts_1410=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1411=("" "" "" "")
    render_help_entries__283_v0 cmd_names_1409[@] cmd_texts_1410[@] cmd_notes_1411[@] 13
    printf '%s\n' ""
    colored_secondary__243_v0 "Envs:"
    local ret_colored_secondary243_v0__32_12="${ret_colored_secondary243_v0}"
    local array_64=()
    printf__128_v0 "${ret_colored_secondary243_v0__32_12}""
" array_64[@]
    local env_names_1412=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1413=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1414=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__283_v0 env_names_1412[@] env_texts_1413[@] env_notes_1414[@] 0
    printf '%s\n' ""
    colored_accent__244_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent244_v0__57_16="${ret_colored_accent244_v0}"
    local footer_1416=("Run" "${ret_colored_accent244_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__284_v0 footer_1416[@]
}

# math_floor(number: Int)
math_floor__509_v0() {
    local number_2768="${1}"
    local command_69
    command_69="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_2768}")"
    __status=$?
    ret_math_floor509_v0="${command_69}"
    return 0
}

# math_ceil(number: Int)
math_ceil__510_v0() {
    local number_2767="${1}"
    math_floor__509_v0 "${number_2767}"
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
    local text_2655="${1}"
    if [ "$(( ! _perl_available_19 ))" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return 1
    fi
    local command_72
    command_72="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2655}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return "${__status}"
    fi
    local width_str_2656="${command_72}"
    parse_int__13_v0 "${width_str_2656}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return "${__status}"
    fi
    local width_2657="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width570_v0="${width_2657}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__571_v0() {
    local text_2722="${1}"
    local max_width_2723="${2}"
    if [ "$(( ! _perl_available_19 ))" != 0 ]; then
        ret_perl_truncate_cjk571_v0=''
        return 1
    fi
    local command_73
    command_73="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_2722}" ${max_width_2723} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk571_v0=''
        return "${__status}"
    fi
    local result_2724="${command_73}"
    ret_perl_truncate_cjk571_v0="${result_2724}"
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
    local count_2711="${command_75}"
    parse_int__13_v0 "${count_2711}"
    __status=$?
    ret_stty_count578_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__579_v0() {
    stty_count__578_v0 
    local count_num_2712="${ret_stty_count578_v0}"
    if [ "$(( count_num_2712 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2712="$(( count_num_2712 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2712}
    __status=$?
}

# stty_unlock()
stty_unlock__580_v0() {
    stty_count__578_v0 
    local count_num_2765="${ret_stty_count578_v0}"
    if [ "$(( count_num_2765 > 0 ))" != 0 ]; then
        count_num_2765="$(( count_num_2765 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2765}
        __status=$?
        if [ "$(( count_num_2765 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__581_v0() {
    local size_2639="${1}"
    if [ "$([ "_${size_2639}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size581_v0=0
        return 0
    fi
    split__4_v0 "${size_2639}" " "
    local parts_2640=("${ret_split4_v0[@]}")
    local __length_76=("${parts_2640[@]}")
    if [ "$(( ${#__length_76[@]} != 2 ))" != 0 ]; then
        ret_store_term_size581_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2640[1]?"Index out of bounds (at src/./input/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2640[0]?"Index out of bounds (at src/./input/../utils/term.ab:50:68)"}"
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
    local size_2642="${command_78}"
    store_term_size__581_v0 "${size_2642}"
    ret_query_term_size582_v0="${ret_store_term_size581_v0}"
    return 0
}

# stty_term_size()
stty_term_size__583_v0() {
    local command_79
    command_79="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2638="${command_79}"
    store_term_size__581_v0 "${size_2638}"
    ret_stty_term_size583_v0="${ret_store_term_size581_v0}"
    return 0
}

# get_term_size()
get_term_size__584_v0() {
    stty_term_size__583_v0 
    local detected_2641="${ret_stty_term_size583_v0}"
    if [ "$(( ! detected_2641 ))" != 0 ]; then
        query_term_size__582_v0 
        detected_2641="${ret_query_term_size582_v0}"
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
    local config_2670="${ret_env_var_get120_v0}"
    _supports_truecolor_22="$(if [ "$([ "_${config_2670}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor597_v0="$([ "_${_supports_truecolor_22}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__598_v0() {
    local message_2665="${1}"
    local r_2666="${2}"
    local g_2667="${3}"
    local b_2668="${4}"
    local fallback_2669="${5}"
    if [ "$([ "_${_supports_truecolor_22}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb598_v0="\\x1b[38;2;${r_2666};${g_2667};${b_2668}m""${message_2665}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_22}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__597_v0 
        local ret_get_supports_truecolor597_v0__45_17="${ret_get_supports_truecolor597_v0}"
        if [ "${ret_get_supports_truecolor597_v0__45_17}" != 0 ]; then
            ret_colored_rgb598_v0="\\x1b[38;2;${r_2666};${g_2667};${b_2668}m""${message_2665}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2669 == 0 ))" != 0 ]; then
            ret_colored_rgb598_v0="${message_2665}"
            return 0
        else
            ret_colored_rgb598_v0="\\x1b[${fallback_2669}m""${message_2665}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2669 == 0 ))" != 0 ]; then
            ret_colored_rgb598_v0="${message_2665}"
            return 0
        fi
        ret_colored_rgb598_v0="\\x1b[${fallback_2669}m""${message_2665}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__600_v0() {
    if [ "$(( ! _got_xylitol_colors_23 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2659="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2659}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2659}" ";"
            local parts_2660=("${ret_split4_v0[@]}")
            local __length_83=("${parts_2660[@]}")
            if [ "$(( ${#__length_83[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2660[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2660[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2660[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2660[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_24=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2661="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2661}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2661}" ";"
            local parts_2662=("${ret_split4_v0[@]}")
            local __length_85=("${parts_2662[@]}")
            if [ "$(( ${#__length_85[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2662[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2662[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2662[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2662[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_25=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2663="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2663}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2663}" ";"
            local parts_2664=("${ret_split4_v0[@]}")
            local __length_87=("${parts_2664[@]}")
            if [ "$(( ${#__length_87[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2664[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2664[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2664[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2664[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
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
    local message_2658="${1}"
    if [ "$(( ! _got_xylitol_colors_23 ))" != 0 ]; then
        get_xylitol_colors__601_v0 
    fi
    colored_rgb__598_v0 "${message_2658}" "${_primary_color_24[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_24[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_24[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_24[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary602_v0="${ret_colored_rgb598_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__603_v0() {
    local message_2672="${1}"
    if [ "$(( ! _got_xylitol_colors_23 ))" != 0 ]; then
        get_xylitol_colors__601_v0 
    fi
    colored_rgb__598_v0 "${message_2672}" "${_secondary_color_25[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_25[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_25[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_25[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary603_v0="${ret_colored_rgb598_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__617_v0() {
    local command_89
    command_89="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_2762="${command_89}"
    ret_get_char617_v0="${char_2762}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__620_v0() {
    local format_2740="${1}"
    local args_2741=("${!2}")
    args_2741=("${format_2740}" "${args_2741[@]}")
    __status=$?
    printf "${args_2741[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__621_v0() {
    local message_2750="${1}"
    local color_2751="${2}"
    # Prints an error message with a specified color.
    local array_90=("${message_2750}")
    eprintf__620_v0 "\\x1b[${color_2751}m%s\\x1b[0m" array_90[@]
}

# colored(message: Text, color: Int)
colored__622_v0() {
    local message_2701="${1}"
    local color_2702="${2}"
    # Returns a text wrapped in color codes.
    ret_colored622_v0="\\x1b[${color_2702}m""${message_2701}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__623_v0() {
    local cnt_2763="${1}"
    if [ "$(( cnt_2763 > 0 ))" != 0 ]; then
        local array_91=("")
        eprintf__620_v0 "\\x1b[${cnt_2763}D\\x1b[K" array_91[@]
    fi
}

# remove_line(cnt: Int)
remove_line__624_v0() {
    local cnt_2771="${1}"
    if [ "$(( cnt_2771 > 0 ))" != 0 ]; then
        local sequence_2772=""
        local __range_start_2773=0
        local __range_end_2773="${cnt_2771}"
        local __dir_2773=$(( ${__range_start_2773} <= ${__range_end_2773} ? 1 : -1 ))
        for (( ____2773=${__range_start_2773}; ____2773 * ${__dir_2773} < ${__range_end_2773} * ${__dir_2773}; ____2773+=${__dir_2773} )); do
            sequence_2772+="\\x1b[2K\\x1b[1A"
done
        local array_92=("")
        eprintf__620_v0 "${sequence_2772}" array_92[@]
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
    local cnt_2742="${1}"
    local __range_start_2743=0
    local __range_end_2743="${cnt_2742}"
    local __dir_2743=$(( ${__range_start_2743} <= ${__range_end_2743} ? 1 : -1 ))
    for (( ____2743=${__range_start_2743}; ____2743 * ${__dir_2743} < ${__range_end_2743} * ${__dir_2743}; ____2743+=${__dir_2743} )); do
        local array_95=("")
        eprintf__620_v0 "
" array_95[@]
done
}

# go_up(cnt: Int)
go_up__628_v0() {
    local cnt_2759="${1}"
    local array_96=("")
    eprintf__620_v0 "\\x1b[${cnt_2759}A" array_96[@]
}

# go_down(cnt: Int)
go_down__629_v0() {
    local cnt_2770="${1}"
    local array_97=("")
    eprintf__620_v0 "\\x1b[${cnt_2770}B" array_97[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__633_v0() {
    local text_2648="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_98
    command_98="$([[ "${text_2648}" == *$'\x1b'* || "${text_2648}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2649="${command_98}"
    ret_has_ansi_escape633_v0="$([ "_${has_escape_2649}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__634_v0() {
    local text_2705="${1}"
    local command_99
    command_99="$(printf '%s' "${text_2705}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi634_v0="${command_99}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__635_v0() {
    local text_2651="${1}"
    local command_100
    command_100="$(printf "%s" "${text_2651}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi635_v0="${command_100}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__636_v0() {
    local text_2653="${1}"
    local command_101
    command_101="$(printf "%s" "${text_2653}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2654="${command_101}"
    ret_is_all_ascii636_v0="$([ "_${result_2654}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__637_v0() {
    local text_2650="${1}"
    strip_ansi__635_v0 "${text_2650}"
    local stripped_2652="${ret_strip_ansi635_v0}"
    # Check if text is all ASCII
    is_all_ascii__636_v0 "${stripped_2652}"
    local ret_is_all_ascii636_v0__150_12="${ret_is_all_ascii636_v0}"
    if [ "$(( ! ret_is_all_ascii636_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__570_v0 "${stripped_2652}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_102="${stripped_2652}"
            ret_get_visible_len637_v0="${#__length_102}"
            return 0
        fi
        ret_get_visible_len637_v0="${ret_perl_get_cjk_width570_v0}"
        return 0
    else
        local __length_103="${stripped_2652}"
        ret_get_visible_len637_v0="${#__length_103}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__638_v0() {
    local text_2719="${1}"
    local max_width_2720="${2}"
    get_visible_len__637_v0 "${text_2719}"
    local visible_len_2721="${ret_get_visible_len637_v0}"
    if [ "$(( visible_len_2721 <= max_width_2720 ))" != 0 ]; then
        ret_truncate_text638_v0="${text_2719}"
        return 0
    fi
    is_all_ascii__636_v0 "${text_2719}"
    local ret_is_all_ascii636_v0__167_12="${ret_is_all_ascii636_v0}"
    if [ "$(( ! ret_is_all_ascii636_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__571_v0 "${text_2719}" "${max_width_2720}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_2719}" | cut -c1-${max_width_2720}
            __status=$?
        fi
        ret_truncate_text638_v0="${ret_perl_truncate_cjk571_v0}"
        return 0
    fi
    local command_104
    command_104="$(printf "%s" "${text_2719}" | cut -c1-${max_width_2720})"
    __status=$?
    ret_truncate_text638_v0="${command_104}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__639_v0() {
    local text_2717="${1}"
    local max_width_2718="${2}"
    has_ansi_escape__633_v0 "${text_2717}"
    local ret_has_ansi_escape633_v0__179_12="${ret_has_ansi_escape633_v0}"
    if [ "$(( ! ret_has_ansi_escape633_v0__179_12 ))" != 0 ]; then
        truncate_text__638_v0 "${text_2717}" "${max_width_2718}"
        ret_truncate_ansi639_v0="${ret_truncate_text638_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_105
    command_105="$([[ "${text_2717}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_2725="${command_105}"
    # Replace \x1b[ with newline, then split
    local command_106
    command_106="$(t="${text_2717}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_2726="${command_106}"
    split__4_v0 "${replaced_2726}" "
"
    local parts_2727=("${ret_split4_v0[@]}")
    local result_2728=""
    local remaining_width_2729="${max_width_2718}"
    local __range_start_2730=0
    local __length_107=("${parts_2727[@]}")
    local __range_end_2730="${#__length_107[@]}"
    local __dir_2730=$(( ${__range_start_2730} <= ${__range_end_2730} ? 1 : -1 ))
    for (( idx_2730=${__range_start_2730}; idx_2730 * ${__dir_2730} < ${__range_end_2730} * ${__dir_2730}; idx_2730+=${__dir_2730} )); do
        local part_2731="${parts_2727[${idx_2730}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_2730 == 0 )) && $([ "_${starts_with_ansi_2725}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_2731}" == "_" ]; echo $?) && $(( remaining_width_2729 > 0 )) ))" != 0 ]; then
                truncate_text__638_v0 "${part_2731}" "${remaining_width_2729}"
                local ret_truncate_text638_v0__201_35="${ret_truncate_text638_v0}"
                local truncated_2732="${ret_truncate_text638_v0__201_35}"
                result_2728+="${truncated_2732}"
                get_visible_len__637_v0 "${truncated_2732}"
                local ret_get_visible_len637_v0__203_36="${ret_get_visible_len637_v0}"
                remaining_width_2729="$(( remaining_width_2729 - ret_get_visible_len637_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_108
            command_108="$(__p="${part_2731}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_2733="${command_108}"
            if [ "$([ "_${m_idx_2733}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_109
                command_109="$(__p="${part_2731}"; printf "%s" "${__p:0:${m_idx_2733}}")"
                __status=$?
                local ansi_params_2734="${command_109}"
                result_2728+="\\x1b[""${ansi_params_2734}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_2733}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_2735="${ret_parse_int13_v0__214_41}"
                local text_start_2736="$(( m_idx_num_2735 + 1 ))"
                local command_110
                command_110="$(__p="${part_2731}"; printf "%s" "${__p:${text_start_2736}}")"
                __status=$?
                local text_part_2737="${command_110}"
                if [ "$(( $([ "_${text_part_2737}" == "_" ]; echo $?) && $(( remaining_width_2729 > 0 )) ))" != 0 ]; then
                    truncate_text__638_v0 "${text_part_2737}" "${remaining_width_2729}"
                    local ret_truncate_text638_v0__218_39="${ret_truncate_text638_v0}"
                    local truncated_2738="${ret_truncate_text638_v0__218_39}"
                    result_2728+="${truncated_2738}"
                    get_visible_len__637_v0 "${truncated_2738}"
                    local ret_get_visible_len637_v0__220_40="${ret_get_visible_len637_v0}"
                    remaining_width_2729="$(( remaining_width_2729 - ret_get_visible_len637_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_2731}" == "_" ]; echo $?) && $(( remaining_width_2729 > 0 )) ))" != 0 ]; then
                    truncate_text__638_v0 "${part_2731}" "${remaining_width_2729}"
                    local ret_truncate_text638_v0__225_39="${ret_truncate_text638_v0}"
                    local truncated_2739="${ret_truncate_text638_v0__225_39}"
                    result_2728+="${truncated_2739}"
                    get_visible_len__637_v0 "${truncated_2739}"
                    local ret_get_visible_len637_v0__227_40="${ret_get_visible_len637_v0}"
                    remaining_width_2729="$(( remaining_width_2729 - ret_get_visible_len637_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi639_v0="${result_2728}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__640_v0() {
    local text_2714="${1}"
    local max_width_2715="${2}"
    get_visible_len__637_v0 "${text_2714}"
    local visible_len_2716="${ret_get_visible_len637_v0}"
    if [ "$(( visible_len_2716 <= max_width_2715 ))" != 0 ]; then
        ret_cutoff_text640_v0="${text_2714}"
        return 0
    fi
    truncate_ansi__639_v0 "${text_2714}" "$(( max_width_2715 - 3 ))"
    local ret_truncate_ansi639_v0__243_12="${ret_truncate_ansi639_v0}"
    ret_cutoff_text640_v0="${ret_truncate_ansi639_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__641_v0() {
    local items_2744=("${!1}")
    local total_len_2745="${2}"
    local term_width_2746="${3}"
    local separator_2747=" • "
    local separator_len_2748=3
    # Fast path: no truncation needed
    if [ "$(( total_len_2745 <= term_width_2746 ))" != 0 ]; then
        local iter_2749=0
        while :
        do
            local __length_111=("${items_2744[@]}")
            if [ "$(( iter_2749 >= ${#__length_111[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_2749 > 0 ))" != 0 ]; then
                eprintf_colored__621_v0 "${separator_2747}" 90
            fi
            colored__622_v0 "${items_2744[$(( iter_2749 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored622_v0__268_41="${ret_colored622_v0}"
            local array_112=("")
            eprintf__620_v0 "${items_2744[${iter_2749}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored622_v0__268_41}" array_112[@]
            iter_2749="$(( iter_2749 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_2752=0
        local first_2753=1
        local iter_2754=0
        while :
        do
            local __length_113=("${items_2744[@]}")
            if [ "$(( iter_2754 >= ${#__length_113[@]} ))" != 0 ]; then
                break
            fi
            local key_2755="${items_2744[${iter_2754}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_2756="${items_2744[$(( iter_2754 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_114="${key_2755}"
            local __length_115="${action_2756}"
            local part_len_2757="$(( $(( ${#__length_114} + 1 )) + ${#__length_115} ))"
            local needed_2758="${part_len_2757}"
            if [ "$(( ! first_2753 ))" != 0 ]; then
                needed_2758="$(( needed_2758 + separator_len_2748 ))"
            fi
            if [ "$(( $(( current_len_2752 + needed_2758 )) > term_width_2746 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_2753 ))" != 0 ]; then
                eprintf_colored__621_v0 "${separator_2747}" 90
            fi
            colored__622_v0 "${action_2756}" 2
            local ret_colored622_v0__296_33="${ret_colored622_v0}"
            local array_116=("")
            eprintf__620_v0 "${key_2755}"" ""${ret_colored622_v0__296_33}" array_116[@]
            current_len_2752="$(( current_len_2752 + needed_2758 ))"
            first_2753=0
            iter_2754="$(( iter_2754 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__642_v0() {
    local pending_2698="${1}"
    local line_2699="${2}"
    local note_at_2700="${3}"
    if [ "$(( note_at_2700 < 0 ))" != 0 ]; then
        local array_117=()
        printf__128_v0 "${pending_2698}""${line_2699}""
" array_117[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_2700 == 0 ))" != 0 ]; then
        colored__622_v0 "${line_2699}" 90
        local ret_colored622_v0__310_40="${ret_colored622_v0}"
        local array_118=()
        printf__128_v0 "${pending_2698}""${ret_colored622_v0__310_40}""
" array_118[@]
    else
        slice__24_v0 "${line_2699}" 0 "${note_at_2700}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_2699}" "${note_at_2700}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__622_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored622_v0__311_58="${ret_colored622_v0}"
        local array_119=()
        printf__128_v0 "${pending_2698}""${ret_slice24_v0__311_32}""${ret_colored622_v0__311_58}""
" array_119[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__643_v0() {
    local names_2676=("${!1}")
    local texts_2677=("${!2}")
    local notes_2678=("${!3}")
    local min_name_width_2679="${4}"
    local __length_120=("${names_2676[@]}")
    local count_2680="${#__length_120[@]}"
    local name_width_2681="${min_name_width_2679}"
    local __range_start_2682=0
    local __range_end_2682="${count_2680}"
    local __dir_2682=$(( ${__range_start_2682} <= ${__range_end_2682} ? 1 : -1 ))
    for (( i_2682=${__range_start_2682}; i_2682 * ${__dir_2682} < ${__range_end_2682} * ${__dir_2682}; i_2682+=${__dir_2682} )); do
        local __length_121="${names_2676[${i_2682}]?"Index out of bounds (at src/./input/../utils.ab:326:33)"}"
        local width_2683="${#__length_121}"
        if [ "$(( width_2683 > name_width_2681 ))" != 0 ]; then
            name_width_2681="${width_2683}"
        fi
done
    term_width__586_v0 
    local width_2684="${ret_term_width586_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2685="$(( name_width_2681 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2686="$(( $(( width_2684 - indent_2685 )) < 24 ))"
    if [ "${stacked_2686}" != 0 ]; then
        indent_2685=6
    fi
    local avail_2687="$(( width_2684 - indent_2685 ))"
    rpad__28_v0 "" " " "${indent_2685}"
    local blank_2688="${ret_rpad28_v0}"
    local __range_start_2689=0
    local __range_end_2689="${count_2680}"
    local __dir_2689=$(( ${__range_start_2689} <= ${__range_end_2689} ? 1 : -1 ))
    for (( i_2689=${__range_start_2689}; i_2689 * ${__dir_2689} < ${__range_end_2689} * ${__dir_2689}; i_2689+=${__dir_2689} )); do
        local pending_2690="${blank_2688}"
        if [ "${stacked_2686}" != 0 ]; then
            local array_122=()
            printf__128_v0 "  ""${names_2676[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:346:33)"}""
" array_122[@]
        else
            rpad__28_v0 "  ""${names_2676[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:348:41)"}" " " "${indent_2685}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_2690="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_2677[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_2691=("${ret_split4_v0__350_21[@]}")
        local __length_123=("${words_2691[@]}")
        local note_start_2692="${#__length_123[@]}"
        if [ "$([ "_${notes_2678[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_124="${notes_2678[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_124} > avail_2687 ))" != 0 ]; then
                split__4_v0 "${notes_2678[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_2691+=("${ret_split4_v0__356_26[@]}")
            else
                local array_125=("${notes_2678[${i_2689}]?"Index out of bounds (at src/./input/../utils.ab:358:33)"}")
                words_2691+=("${array_125[@]}")
            fi
        fi
        local line_2693=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2694=-1
        local __range_start_2695=0
        local __length_126=("${words_2691[@]}")
        local __range_end_2695="${#__length_126[@]}"
        local __dir_2695=$(( ${__range_start_2695} <= ${__range_end_2695} ? 1 : -1 ))
        for (( j_2695=${__range_start_2695}; j_2695 * ${__dir_2695} < ${__range_end_2695} * ${__dir_2695}; j_2695+=${__dir_2695} )); do
            local word_2696="${words_2691[${j_2695}]?"Index out of bounds (at src/./input/../utils.ab:368:32)"}"
            local candidate_2697
            candidate_2697="$(if [ "$([ "_${line_2693}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2696}"; else echo "${line_2693}"" ""${word_2696}"; fi)"
            local __length_127="${candidate_2697}"
            if [ "$(( $(( ${#__length_127} > avail_2687 )) && $([ "_${line_2693}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__642_v0 "${pending_2690}" "${line_2693}" "${note_at_2694}"
                pending_2690="${blank_2688}"
                line_2693="${word_2696}"
                note_at_2694="$(if [ "$(( j_2695 >= note_start_2692 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2695 >= note_start_2692 )) && $(( note_at_2694 < 0 )) ))" != 0 ]; then
                    local __length_128="${candidate_2697}"
                    local __length_129="${word_2696}"
                    note_at_2694="$(( ${#__length_128} - ${#__length_129} ))"
                fi
                line_2693="${candidate_2697}"
            fi
done
        print_help_line__642_v0 "${pending_2690}" "${line_2693}" "${note_at_2694}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__644_v0() {
    local pieces_2637=("${!1}")
    term_width__586_v0 
    local width_2643="${ret_term_width586_v0}"
    local line_2644=""
    local line_len_2645=0
    for piece_2646 in "${pieces_2637[@]}"; do
        local __length_132="${piece_2646}"
        local piece_len_2647="${#__length_132}"
        has_ansi_escape__633_v0 "${piece_2646}"
        local ret_has_ansi_escape633_v0__397_12="${ret_has_ansi_escape633_v0}"
        if [ "${ret_has_ansi_escape633_v0__397_12}" != 0 ]; then
            get_visible_len__637_v0 "${piece_2646}"
            piece_len_2647="${ret_get_visible_len637_v0}"
        fi
        if [ "$([ "_${line_2644}" != "_" ]; echo $?)" != 0 ]; then
            line_2644="${piece_2646}"
            line_len_2645="${piece_len_2647}"
        elif [ "$(( $(( $(( line_len_2645 + 1 )) + piece_len_2647 )) > width_2643 ))" != 0 ]; then
            local array_133=()
            printf__128_v0 "${line_2644}""
" array_133[@]
            line_2644="${piece_2646}"
            line_len_2645="${piece_len_2647}"
        else
            line_2644+=" ""${piece_2646}"
            line_len_2645="$(( line_len_2645 + $(( 1 + piece_len_2647 )) ))"
        fi
    done
    if [ "$([ "_${line_2644}" == "_" ]; echo $?)" != 0 ]; then
        local array_134=()
        printf__128_v0 "${line_2644}""
" array_134[@]
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__695_v0() {
    local prompt_2707="${1}"
    local placeholder_2708="${2}"
    local header_2709="${3}"
    local password_2710="${4}"
    stty_lock__579_v0 
    term_width__586_v0 
    local term_width_2713="${ret_term_width586_v0}"
    if [ "$([ "_${header_2709}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__640_v0 "${header_2709}" "${term_width_2713}"
        local ret_cutoff_text640_v0__25_17="${ret_cutoff_text640_v0}"
        local array_135=("")
        eprintf__620_v0 "${ret_cutoff_text640_v0__25_17}""
" array_135[@]
    fi
    new_line__627_v0 2
    # "enter submit" = 12
    local array_136=("enter" "submit")
    render_tooltip__641_v0 array_136[@] 12 "${term_width_2713}"
    go_up__628_v0 2
    local array_137=("")
    eprintf__620_v0 "\\x1b[G" array_137[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_138
    command_138="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_2760="${command_138}"
    local char_2761=""
    local array_139=("")
    eprintf__620_v0 "${prompt_2707}" array_139[@]
    if [ "$([ "_${can_preset_2760}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__621_v0 "${placeholder_2708}" 90
        get_char__617_v0 
        char_2761="${ret_get_char617_v0}"
        local __length_140="${placeholder_2708}"
        remove__623_v0 "$(( ${#__length_140} + 1 ))"
    fi
    local __length_141="${prompt_2707}"
    remove__623_v0 "${#__length_141}"
    local text_2764=""
    if [ "$(( ! password_2710 ))" != 0 ]; then
        stty_unlock__580_v0 
        local command_142
        command_142="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_2761}" -p "${prompt_2707}" text < /dev/tty; else read -e -p "${prompt_2707}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2764="${command_142}"
    else
        stty_unlock__580_v0 
        local command_143
        command_143="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_2761}" -p "${prompt_2707}" text < /dev/tty; else read -es -p "${prompt_2707}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2764="${command_143}"
    fi
    stty_lock__579_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__637_v0 "${prompt_2707}""${text_2764}"
    local input_display_len_2766="${ret_get_visible_len637_v0}"
    math_ceil__510_v0 "$(( input_display_len_2766 / term_width_2713 ))"
    local input_lines_2769="${ret_math_ceil510_v0}"
    if [ "$(( input_lines_2769 < 3 ))" != 0 ]; then
        go_down__629_v0 "$(( 2 - input_lines_2769 ))"
        remove_line__624_v0 2
        remove_current_line__625_v0 
    fi
    if [ "$(( input_lines_2769 >= 3 ))" != 0 ]; then
        remove_line__624_v0 "${input_lines_2769}"
    fi
    if [ "$([ "_${header_2709}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__624_v0 1
        remove_current_line__625_v0 
    fi
    stty_unlock__580_v0 
    ret_xyl_input695_v0="${text_2764}"
    return 0
}

# print_input_help()
print_input_help__789_v0() {
    local usage_2636=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__644_v0 usage_2636[@]
    printf '%s\n' ""
    colored_primary__602_v0 "input"
    local ret_colored_primary602_v0__8_20="${ret_colored_primary602_v0}"
    local title_2671=("${ret_colored_primary602_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__644_v0 title_2671[@]
    printf '%s\n' ""
    colored_secondary__603_v0 "Flags:"
    local ret_colored_secondary603_v0__11_12="${ret_colored_secondary603_v0}"
    local array_146=()
    printf__128_v0 "${ret_colored_secondary603_v0__11_12}""
" array_146[@]
    local names_2673=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2674=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2675=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__643_v0 names_2673[@] texts_2674[@] notes_2675[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__841_v0() {
    local parameters_2630=("${!1}")
    local prompt_2631="> "
    local placeholder_2632="Type here..."
    local header_2633=""
    local password_2634=0
    for param_2635 in "${parameters_2630[@]}"; do
        if [ "$(( $([ "_${param_2635}" != "_-h" ]; echo $?) || $([ "_${param_2635}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__789_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2635}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_152="--prompt="
            slice__24_v0 "${param_2635}" "${#__length_152}" 0
            prompt_2631="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2635}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_153="--placeholder="
            slice__24_v0 "${param_2635}" "${#__length_153}" 0
            placeholder_2632="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2635}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_154="--header="
            slice__24_v0 "${param_2635}" "${#__length_154}" 0
            header_2633="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2635}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2634=1
        fi
    done
    has_ansi_escape__633_v0 "${header_2633}"
    local ret_has_ansi_escape633_v0__31_44="${ret_has_ansi_escape633_v0}"
    escape_ansi__634_v0 "${header_2633}"
    local ret_escape_ansi634_v0__31_73="${ret_escape_ansi634_v0}"
    colored_primary__602_v0 "${header_2633}"
    local ret_colored_primary602_v0__31_111="${ret_colored_primary602_v0}"
    local display_header_2706
    display_header_2706="$(if [ "$(( $([ "_${header_2633}" != "_" ]; echo $?) || ret_has_ansi_escape633_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi634_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary602_v0__31_111}"; fi)"
    xyl_input__695_v0 "${prompt_2631}" "${placeholder_2632}" "${display_header_2706}" "${password_2634}"
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
    local text_14550="${1}"
    if [ "$(( ! _perl_available_33 ))" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return 1
    fi
    local command_157
    command_157="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_14550}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return "${__status}"
    fi
    local width_str_14551="${command_157}"
    parse_int__13_v0 "${width_str_14551}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return "${__status}"
    fi
    local width_14552="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width973_v0="${width_14552}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__974_v0() {
    local text_14620="${1}"
    local max_width_14621="${2}"
    if [ "$(( ! _perl_available_33 ))" != 0 ]; then
        ret_perl_truncate_cjk974_v0=''
        return 1
    fi
    local command_158
    command_158="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_14620}" ${max_width_14621} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk974_v0=''
        return "${__status}"
    fi
    local result_14622="${command_158}"
    ret_perl_truncate_cjk974_v0="${result_14622}"
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
    local count_14608="${command_160}"
    parse_int__13_v0 "${count_14608}"
    __status=$?
    ret_stty_count981_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__982_v0() {
    stty_count__981_v0 
    local count_num_14609="${ret_stty_count981_v0}"
    if [ "$(( count_num_14609 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_14609="$(( count_num_14609 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14609}
    __status=$?
}

# stty_unlock()
stty_unlock__983_v0() {
    stty_count__981_v0 
    local count_num_14704="${ret_stty_count981_v0}"
    if [ "$(( count_num_14704 > 0 ))" != 0 ]; then
        count_num_14704="$(( count_num_14704 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14704}
        __status=$?
        if [ "$(( count_num_14704 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__984_v0() {
    local size_14534="${1}"
    if [ "$([ "_${size_14534}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size984_v0=0
        return 0
    fi
    split__4_v0 "${size_14534}" " "
    local parts_14535=("${ret_split4_v0[@]}")
    local __length_161=("${parts_14535[@]}")
    if [ "$(( ${#__length_161[@]} != 2 ))" != 0 ]; then
        ret_store_term_size984_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_14535[1]?"Index out of bounds (at src/./choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_14535[0]?"Index out of bounds (at src/./choose/../utils/term.ab:50:68)"}"
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
    local size_14537="${command_163}"
    store_term_size__984_v0 "${size_14537}"
    ret_query_term_size985_v0="${ret_store_term_size984_v0}"
    return 0
}

# stty_term_size()
stty_term_size__986_v0() {
    local command_164
    command_164="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_14533="${command_164}"
    store_term_size__984_v0 "${size_14533}"
    ret_stty_term_size986_v0="${ret_store_term_size984_v0}"
    return 0
}

# get_term_size()
get_term_size__987_v0() {
    stty_term_size__986_v0 
    local detected_14536="${ret_stty_term_size986_v0}"
    if [ "$(( ! detected_14536 ))" != 0 ]; then
        query_term_size__985_v0 
        detected_14536="${ret_query_term_size985_v0}"
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
    local config_14522="${ret_env_var_get120_v0}"
    _supports_truecolor_36="$(if [ "$([ "_${config_14522}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1000_v0="$([ "_${_supports_truecolor_36}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1001_v0() {
    local message_14517="${1}"
    local r_14518="${2}"
    local g_14519="${3}"
    local b_14520="${4}"
    local fallback_14521="${5}"
    if [ "$([ "_${_supports_truecolor_36}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1001_v0="\\x1b[38;2;${r_14518};${g_14519};${b_14520}m""${message_14517}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_36}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1000_v0 
        local ret_get_supports_truecolor1000_v0__45_17="${ret_get_supports_truecolor1000_v0}"
        if [ "${ret_get_supports_truecolor1000_v0__45_17}" != 0 ]; then
            ret_colored_rgb1001_v0="\\x1b[38;2;${r_14518};${g_14519};${b_14520}m""${message_14517}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_14521 == 0 ))" != 0 ]; then
            ret_colored_rgb1001_v0="${message_14517}"
            return 0
        else
            ret_colored_rgb1001_v0="\\x1b[${fallback_14521}m""${message_14517}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_14521 == 0 ))" != 0 ]; then
            ret_colored_rgb1001_v0="${message_14517}"
            return 0
        fi
        ret_colored_rgb1001_v0="\\x1b[${fallback_14521}m""${message_14517}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1003_v0() {
    if [ "$(( ! _got_xylitol_colors_37 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_14511="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_14511}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_14511}" ";"
            local parts_14512=("${ret_split4_v0[@]}")
            local __length_168=("${parts_14512[@]}")
            if [ "$(( ${#__length_168[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14512[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14512[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14512[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14512[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_38=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_14513="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_14513}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_14513}" ";"
            local parts_14514=("${ret_split4_v0[@]}")
            local __length_170=("${parts_14514[@]}")
            if [ "$(( ${#__length_170[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14514[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14514[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14514[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14514[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_39=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_14515="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_14515}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_14515}" ";"
            local parts_14516=("${ret_split4_v0[@]}")
            local __length_172=("${parts_14516[@]}")
            if [ "$(( ${#__length_172[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14516[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14516[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14516[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14516[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
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
    local message_14510="${1}"
    if [ "$(( ! _got_xylitol_colors_37 ))" != 0 ]; then
        get_xylitol_colors__1004_v0 
    fi
    colored_rgb__1001_v0 "${message_14510}" "${_primary_color_38[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_38[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_38[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_38[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1005_v0="${ret_colored_rgb1001_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1006_v0() {
    local message_14554="${1}"
    if [ "$(( ! _got_xylitol_colors_37 ))" != 0 ]; then
        get_xylitol_colors__1004_v0 
    fi
    colored_rgb__1001_v0 "${message_14554}" "${_secondary_color_39[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_39[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_39[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_39[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1006_v0="${ret_colored_rgb1001_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1021_v0() {
    local command_174
    command_174="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_14682="${command_174}"
    if [ "$([ "_${var_14682}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="UP"
        return 0
    elif [ "$([ "_${var_14682}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="DOWN"
        return 0
    elif [ "$([ "_${var_14682}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_14682}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="LEFT"
        return 0
    elif [ "$([ "_${var_14682}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_14682}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="INPUT"
        return 0
    else
        ret_get_key1021_v0="${var_14682}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1023_v0() {
    local format_14591="${1}"
    local args_14592=("${!2}")
    args_14592=("${format_14591}" "${args_14592[@]}")
    __status=$?
    printf "${args_14592[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1024_v0() {
    local message_14589="${1}"
    local color_14590="${2}"
    # Prints an error message with a specified color.
    local array_175=("${message_14589}")
    eprintf__1023_v0 "\\x1b[${color_14590}m%s\\x1b[0m" array_175[@]
}

# colored(message: Text, color: Int)
colored__1025_v0() {
    local message_14583="${1}"
    local color_14584="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1025_v0="\\x1b[${color_14584}m""${message_14583}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1027_v0() {
    local cnt_14679="${1}"
    if [ "$(( cnt_14679 > 0 ))" != 0 ]; then
        local sequence_14680=""
        local __range_start_14681=0
        local __range_end_14681="${cnt_14679}"
        local __dir_14681=$(( ${__range_start_14681} <= ${__range_end_14681} ? 1 : -1 ))
        for (( ____14681=${__range_start_14681}; ____14681 * ${__dir_14681} < ${__range_end_14681} * ${__dir_14681}; ____14681+=${__dir_14681} )); do
            sequence_14680+="\\x1b[2K\\x1b[1A"
done
        local array_176=("")
        eprintf__1023_v0 "${sequence_14680}" array_176[@]
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
    local cnt_14670="${1}"
    printf '%*s' "${cnt_14670}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1030_v0() {
    local cnt_14639="${1}"
    local __range_start_14640=0
    local __range_end_14640="${cnt_14639}"
    local __dir_14640=$(( ${__range_start_14640} <= ${__range_end_14640} ? 1 : -1 ))
    for (( ____14640=${__range_start_14640}; ____14640 * ${__dir_14640} < ${__range_end_14640} * ${__dir_14640}; ____14640+=${__dir_14640} )); do
        local array_179=("")
        eprintf__1023_v0 "
" array_179[@]
done
}

# go_up(cnt: Int)
go_up__1031_v0() {
    local cnt_14654="${1}"
    local array_180=("")
    eprintf__1023_v0 "\\x1b[${cnt_14654}A" array_180[@]
}

# go_down(cnt: Int)
go_down__1032_v0() {
    local cnt_14691="${1}"
    local array_181=("")
    eprintf__1023_v0 "\\x1b[${cnt_14691}B" array_181[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1033_v0() {
    local cnt_14700="${1}"
    if [ "$(( cnt_14700 > 0 ))" != 0 ]; then
        go_down__1032_v0 "${cnt_14700}"
    else
        go_up__1031_v0 "$(( - cnt_14700 ))"
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
    local text_14543="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_184
    command_184="$([[ "${text_14543}" == *$'\x1b'* || "${text_14543}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_14544="${command_184}"
    ret_has_ansi_escape1036_v0="$([ "_${has_escape_14544}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1037_v0() {
    local text_14594="${1}"
    local command_185
    command_185="$(printf '%s' "${text_14594}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1037_v0="${command_185}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1038_v0() {
    local text_14546="${1}"
    local command_186
    command_186="$(printf "%s" "${text_14546}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1038_v0="${command_186}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1039_v0() {
    local text_14548="${1}"
    local command_187
    command_187="$(printf "%s" "${text_14548}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_14549="${command_187}"
    ret_is_all_ascii1039_v0="$([ "_${result_14549}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1040_v0() {
    local text_14545="${1}"
    strip_ansi__1038_v0 "${text_14545}"
    local stripped_14547="${ret_strip_ansi1038_v0}"
    # Check if text is all ASCII
    is_all_ascii__1039_v0 "${stripped_14547}"
    local ret_is_all_ascii1039_v0__150_12="${ret_is_all_ascii1039_v0}"
    if [ "$(( ! ret_is_all_ascii1039_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__973_v0 "${stripped_14547}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_188="${stripped_14547}"
            ret_get_visible_len1040_v0="${#__length_188}"
            return 0
        fi
        ret_get_visible_len1040_v0="${ret_perl_get_cjk_width973_v0}"
        return 0
    else
        local __length_189="${stripped_14547}"
        ret_get_visible_len1040_v0="${#__length_189}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1041_v0() {
    local text_14617="${1}"
    local max_width_14618="${2}"
    get_visible_len__1040_v0 "${text_14617}"
    local visible_len_14619="${ret_get_visible_len1040_v0}"
    if [ "$(( visible_len_14619 <= max_width_14618 ))" != 0 ]; then
        ret_truncate_text1041_v0="${text_14617}"
        return 0
    fi
    is_all_ascii__1039_v0 "${text_14617}"
    local ret_is_all_ascii1039_v0__167_12="${ret_is_all_ascii1039_v0}"
    if [ "$(( ! ret_is_all_ascii1039_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__974_v0 "${text_14617}" "${max_width_14618}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_14617}" | cut -c1-${max_width_14618}
            __status=$?
        fi
        ret_truncate_text1041_v0="${ret_perl_truncate_cjk974_v0}"
        return 0
    fi
    local command_190
    command_190="$(printf "%s" "${text_14617}" | cut -c1-${max_width_14618})"
    __status=$?
    ret_truncate_text1041_v0="${command_190}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1042_v0() {
    local text_14615="${1}"
    local max_width_14616="${2}"
    has_ansi_escape__1036_v0 "${text_14615}"
    local ret_has_ansi_escape1036_v0__179_12="${ret_has_ansi_escape1036_v0}"
    if [ "$(( ! ret_has_ansi_escape1036_v0__179_12 ))" != 0 ]; then
        truncate_text__1041_v0 "${text_14615}" "${max_width_14616}"
        ret_truncate_ansi1042_v0="${ret_truncate_text1041_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_191
    command_191="$([[ "${text_14615}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_14623="${command_191}"
    # Replace \x1b[ with newline, then split
    local command_192
    command_192="$(t="${text_14615}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_14624="${command_192}"
    split__4_v0 "${replaced_14624}" "
"
    local parts_14625=("${ret_split4_v0[@]}")
    local result_14626=""
    local remaining_width_14627="${max_width_14616}"
    local __range_start_14628=0
    local __length_193=("${parts_14625[@]}")
    local __range_end_14628="${#__length_193[@]}"
    local __dir_14628=$(( ${__range_start_14628} <= ${__range_end_14628} ? 1 : -1 ))
    for (( idx_14628=${__range_start_14628}; idx_14628 * ${__dir_14628} < ${__range_end_14628} * ${__dir_14628}; idx_14628+=${__dir_14628} )); do
        local part_14629="${parts_14625[${idx_14628}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_14628 == 0 )) && $([ "_${starts_with_ansi_14623}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_14629}" == "_" ]; echo $?) && $(( remaining_width_14627 > 0 )) ))" != 0 ]; then
                truncate_text__1041_v0 "${part_14629}" "${remaining_width_14627}"
                local ret_truncate_text1041_v0__201_35="${ret_truncate_text1041_v0}"
                local truncated_14630="${ret_truncate_text1041_v0__201_35}"
                result_14626+="${truncated_14630}"
                get_visible_len__1040_v0 "${truncated_14630}"
                local ret_get_visible_len1040_v0__203_36="${ret_get_visible_len1040_v0}"
                remaining_width_14627="$(( remaining_width_14627 - ret_get_visible_len1040_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_194
            command_194="$(__p="${part_14629}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_14631="${command_194}"
            if [ "$([ "_${m_idx_14631}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_195
                command_195="$(__p="${part_14629}"; printf "%s" "${__p:0:${m_idx_14631}}")"
                __status=$?
                local ansi_params_14632="${command_195}"
                result_14626+="\\x1b[""${ansi_params_14632}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_14631}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_14633="${ret_parse_int13_v0__214_41}"
                local text_start_14634="$(( m_idx_num_14633 + 1 ))"
                local command_196
                command_196="$(__p="${part_14629}"; printf "%s" "${__p:${text_start_14634}}")"
                __status=$?
                local text_part_14635="${command_196}"
                if [ "$(( $([ "_${text_part_14635}" == "_" ]; echo $?) && $(( remaining_width_14627 > 0 )) ))" != 0 ]; then
                    truncate_text__1041_v0 "${text_part_14635}" "${remaining_width_14627}"
                    local ret_truncate_text1041_v0__218_39="${ret_truncate_text1041_v0}"
                    local truncated_14636="${ret_truncate_text1041_v0__218_39}"
                    result_14626+="${truncated_14636}"
                    get_visible_len__1040_v0 "${truncated_14636}"
                    local ret_get_visible_len1040_v0__220_40="${ret_get_visible_len1040_v0}"
                    remaining_width_14627="$(( remaining_width_14627 - ret_get_visible_len1040_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_14629}" == "_" ]; echo $?) && $(( remaining_width_14627 > 0 )) ))" != 0 ]; then
                    truncate_text__1041_v0 "${part_14629}" "${remaining_width_14627}"
                    local ret_truncate_text1041_v0__225_39="${ret_truncate_text1041_v0}"
                    local truncated_14637="${ret_truncate_text1041_v0__225_39}"
                    result_14626+="${truncated_14637}"
                    get_visible_len__1040_v0 "${truncated_14637}"
                    local ret_get_visible_len1040_v0__227_40="${ret_get_visible_len1040_v0}"
                    remaining_width_14627="$(( remaining_width_14627 - ret_get_visible_len1040_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1042_v0="${result_14626}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1043_v0() {
    local text_14612="${1}"
    local max_width_14613="${2}"
    get_visible_len__1040_v0 "${text_14612}"
    local visible_len_14614="${ret_get_visible_len1040_v0}"
    if [ "$(( visible_len_14614 <= max_width_14613 ))" != 0 ]; then
        ret_cutoff_text1043_v0="${text_14612}"
        return 0
    fi
    truncate_ansi__1042_v0 "${text_14612}" "$(( max_width_14613 - 3 ))"
    local ret_truncate_ansi1042_v0__243_12="${ret_truncate_ansi1042_v0}"
    ret_cutoff_text1043_v0="${ret_truncate_ansi1042_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1044_v0() {
    local items_14641=("${!1}")
    local total_len_14642="${2}"
    local term_width_14643="${3}"
    local separator_14644=" • "
    local separator_len_14645=3
    # Fast path: no truncation needed
    if [ "$(( total_len_14642 <= term_width_14643 ))" != 0 ]; then
        local iter_14646=0
        while :
        do
            local __length_197=("${items_14641[@]}")
            if [ "$(( iter_14646 >= ${#__length_197[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_14646 > 0 ))" != 0 ]; then
                eprintf_colored__1024_v0 "${separator_14644}" 90
            fi
            colored__1025_v0 "${items_14641[$(( iter_14646 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1025_v0__268_41="${ret_colored1025_v0}"
            local array_198=("")
            eprintf__1023_v0 "${items_14641[${iter_14646}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1025_v0__268_41}" array_198[@]
            iter_14646="$(( iter_14646 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_14647=0
        local first_14648=1
        local iter_14649=0
        while :
        do
            local __length_199=("${items_14641[@]}")
            if [ "$(( iter_14649 >= ${#__length_199[@]} ))" != 0 ]; then
                break
            fi
            local key_14650="${items_14641[${iter_14649}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_14651="${items_14641[$(( iter_14649 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_200="${key_14650}"
            local __length_201="${action_14651}"
            local part_len_14652="$(( $(( ${#__length_200} + 1 )) + ${#__length_201} ))"
            local needed_14653="${part_len_14652}"
            if [ "$(( ! first_14648 ))" != 0 ]; then
                needed_14653="$(( needed_14653 + separator_len_14645 ))"
            fi
            if [ "$(( $(( current_len_14647 + needed_14653 )) > term_width_14643 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_14648 ))" != 0 ]; then
                eprintf_colored__1024_v0 "${separator_14644}" 90
            fi
            colored__1025_v0 "${action_14651}" 2
            local ret_colored1025_v0__296_33="${ret_colored1025_v0}"
            local array_202=("")
            eprintf__1023_v0 "${key_14650}"" ""${ret_colored1025_v0__296_33}" array_202[@]
            current_len_14647="$(( current_len_14647 + needed_14653 ))"
            first_14648=0
            iter_14649="$(( iter_14649 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1045_v0() {
    local pending_14580="${1}"
    local line_14581="${2}"
    local note_at_14582="${3}"
    if [ "$(( note_at_14582 < 0 ))" != 0 ]; then
        local array_203=()
        printf__128_v0 "${pending_14580}""${line_14581}""
" array_203[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_14582 == 0 ))" != 0 ]; then
        colored__1025_v0 "${line_14581}" 90
        local ret_colored1025_v0__310_40="${ret_colored1025_v0}"
        local array_204=()
        printf__128_v0 "${pending_14580}""${ret_colored1025_v0__310_40}""
" array_204[@]
    else
        slice__24_v0 "${line_14581}" 0 "${note_at_14582}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_14581}" "${note_at_14582}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1025_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1025_v0__311_58="${ret_colored1025_v0}"
        local array_205=()
        printf__128_v0 "${pending_14580}""${ret_slice24_v0__311_32}""${ret_colored1025_v0__311_58}""
" array_205[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1046_v0() {
    local names_14558=("${!1}")
    local texts_14559=("${!2}")
    local notes_14560=("${!3}")
    local min_name_width_14561="${4}"
    local __length_206=("${names_14558[@]}")
    local count_14562="${#__length_206[@]}"
    local name_width_14563="${min_name_width_14561}"
    local __range_start_14564=0
    local __range_end_14564="${count_14562}"
    local __dir_14564=$(( ${__range_start_14564} <= ${__range_end_14564} ? 1 : -1 ))
    for (( i_14564=${__range_start_14564}; i_14564 * ${__dir_14564} < ${__range_end_14564} * ${__dir_14564}; i_14564+=${__dir_14564} )); do
        local __length_207="${names_14558[${i_14564}]?"Index out of bounds (at src/./choose/../utils.ab:326:33)"}"
        local width_14565="${#__length_207}"
        if [ "$(( width_14565 > name_width_14563 ))" != 0 ]; then
            name_width_14563="${width_14565}"
        fi
done
    term_width__989_v0 
    local width_14566="${ret_term_width989_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_14567="$(( name_width_14563 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_14568="$(( $(( width_14566 - indent_14567 )) < 24 ))"
    if [ "${stacked_14568}" != 0 ]; then
        indent_14567=6
    fi
    local avail_14569="$(( width_14566 - indent_14567 ))"
    rpad__28_v0 "" " " "${indent_14567}"
    local blank_14570="${ret_rpad28_v0}"
    local __range_start_14571=0
    local __range_end_14571="${count_14562}"
    local __dir_14571=$(( ${__range_start_14571} <= ${__range_end_14571} ? 1 : -1 ))
    for (( i_14571=${__range_start_14571}; i_14571 * ${__dir_14571} < ${__range_end_14571} * ${__dir_14571}; i_14571+=${__dir_14571} )); do
        local pending_14572="${blank_14570}"
        if [ "${stacked_14568}" != 0 ]; then
            local array_208=()
            printf__128_v0 "  ""${names_14558[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:346:33)"}""
" array_208[@]
        else
            rpad__28_v0 "  ""${names_14558[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:348:41)"}" " " "${indent_14567}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_14572="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_14559[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_14573=("${ret_split4_v0__350_21[@]}")
        local __length_209=("${words_14573[@]}")
        local note_start_14574="${#__length_209[@]}"
        if [ "$([ "_${notes_14560[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_210="${notes_14560[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_210} > avail_14569 ))" != 0 ]; then
                split__4_v0 "${notes_14560[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_14573+=("${ret_split4_v0__356_26[@]}")
            else
                local array_211=("${notes_14560[${i_14571}]?"Index out of bounds (at src/./choose/../utils.ab:358:33)"}")
                words_14573+=("${array_211[@]}")
            fi
        fi
        local line_14575=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_14576=-1
        local __range_start_14577=0
        local __length_212=("${words_14573[@]}")
        local __range_end_14577="${#__length_212[@]}"
        local __dir_14577=$(( ${__range_start_14577} <= ${__range_end_14577} ? 1 : -1 ))
        for (( j_14577=${__range_start_14577}; j_14577 * ${__dir_14577} < ${__range_end_14577} * ${__dir_14577}; j_14577+=${__dir_14577} )); do
            local word_14578="${words_14573[${j_14577}]?"Index out of bounds (at src/./choose/../utils.ab:368:32)"}"
            local candidate_14579
            candidate_14579="$(if [ "$([ "_${line_14575}" != "_" ]; echo $?)" != 0 ]; then echo "${word_14578}"; else echo "${line_14575}"" ""${word_14578}"; fi)"
            local __length_213="${candidate_14579}"
            if [ "$(( $(( ${#__length_213} > avail_14569 )) && $([ "_${line_14575}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1045_v0 "${pending_14572}" "${line_14575}" "${note_at_14576}"
                pending_14572="${blank_14570}"
                line_14575="${word_14578}"
                note_at_14576="$(if [ "$(( j_14577 >= note_start_14574 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_14577 >= note_start_14574 )) && $(( note_at_14576 < 0 )) ))" != 0 ]; then
                    local __length_214="${candidate_14579}"
                    local __length_215="${word_14578}"
                    note_at_14576="$(( ${#__length_214} - ${#__length_215} ))"
                fi
                line_14575="${candidate_14579}"
            fi
done
        print_help_line__1045_v0 "${pending_14572}" "${line_14575}" "${note_at_14576}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1047_v0() {
    local pieces_14532=("${!1}")
    term_width__989_v0 
    local width_14538="${ret_term_width989_v0}"
    local line_14539=""
    local line_len_14540=0
    for piece_14541 in "${pieces_14532[@]}"; do
        local __length_218="${piece_14541}"
        local piece_len_14542="${#__length_218}"
        has_ansi_escape__1036_v0 "${piece_14541}"
        local ret_has_ansi_escape1036_v0__397_12="${ret_has_ansi_escape1036_v0}"
        if [ "${ret_has_ansi_escape1036_v0__397_12}" != 0 ]; then
            get_visible_len__1040_v0 "${piece_14541}"
            piece_len_14542="${ret_get_visible_len1040_v0}"
        fi
        if [ "$([ "_${line_14539}" != "_" ]; echo $?)" != 0 ]; then
            line_14539="${piece_14541}"
            line_len_14540="${piece_len_14542}"
        elif [ "$(( $(( $(( line_len_14540 + 1 )) + piece_len_14542 )) > width_14538 ))" != 0 ]; then
            local array_219=()
            printf__128_v0 "${line_14539}""
" array_219[@]
            line_14539="${piece_14541}"
            line_len_14540="${piece_len_14542}"
        else
            line_14539+=" ""${piece_14541}"
            line_len_14540="$(( line_len_14540 + $(( 1 + piece_len_14542 )) ))"
        fi
    done
    if [ "$([ "_${line_14539}" == "_" ]; echo $?)" != 0 ]; then
        local array_220=()
        printf__128_v0 "${line_14539}""
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
    local cursor_len_14673="${#__length_223}"
    local max_option_width_14674="$(( $(( _term_width_55 - cursor_len_14673 )) - 1 ))"
    local __range_start_14675=0
    local __range_end_14675="${_page_count_58}"
    local __dir_14675=$(( ${__range_start_14675} <= ${__range_end_14675} ? 1 : -1 ))
    for (( i_14675=${__range_start_14675}; i_14675 * ${__dir_14675} < ${__range_end_14675} * ${__dir_14675}; i_14675+=${__dir_14675} )); do
        cutoff_text__1043_v0 "${_page_57[${i_14675}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_14674}"
        local ret_cutoff_text1043_v0__48_27="${ret_cutoff_text1043_v0}"
        local truncated_14676="${ret_cutoff_text1043_v0__48_27}"
        if [ "$(( i_14675 == _selected_51 ))" != 0 ]; then
            colored_secondary__1006_v0 "${_cursor_52}""${truncated_14676}""
"
            local ret_colored_secondary1006_v0__50_21="${ret_colored_secondary1006_v0}"
            local array_224=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__50_21}" array_224[@]
        else
            print_blank__1029_v0 "${cursor_len_14673}"
            local array_225=("")
            eprintf__1023_v0 "${truncated_14676}""
" array_225[@]
        fi
done
    local remaining_slots_14677="$(( _display_count_48 - _page_count_58 ))"
    if [ "$(( remaining_slots_14677 > 0 ))" != 0 ]; then
        local __range_start_14678=0
        local __range_end_14678="${remaining_slots_14677}"
        local __dir_14678=$(( ${__range_start_14678} <= ${__range_end_14678} ? 1 : -1 ))
        for (( ____14678=${__range_start_14678}; ____14678 * ${__dir_14678} < ${__range_end_14678} * ${__dir_14678}; ____14678+=${__dir_14678} )); do
            local array_226=("")
            eprintf__1023_v0 "\\x1b[K
" array_226[@]
done
    fi
}

# render_multi_page()
render_multi_page__1196_v0() {
    local __length_227="${_cursor_52}"
    local cursor_len_14663="${#__length_227}"
    local max_option_width_14664="$(( $(( _term_width_55 - cursor_len_14663 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1201_v0 
    local page_start_14665="${ret_chooser_page_start1201_v0}"
    local __range_start_14666=0
    local __range_end_14666="${_page_count_58}"
    local __dir_14666=$(( ${__range_start_14666} <= ${__range_end_14666} ? 1 : -1 ))
    for (( i_14666=${__range_start_14666}; i_14666 * ${__dir_14666} < ${__range_end_14666} * ${__dir_14666}; i_14666+=${__dir_14666} )); do
        local global_idx_14667="$(( page_start_14665 + i_14666 ))"
        local check_mark_14668
        check_mark_14668="$(if [ "${_checked_59[${global_idx_14667}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1043_v0 "${_page_57[${i_14666}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_14664}"
        local ret_cutoff_text1043_v0__71_27="${ret_cutoff_text1043_v0}"
        local truncated_14669="${ret_cutoff_text1043_v0__71_27}"
        if [ "$(( i_14666 == _selected_51 ))" != 0 ]; then
            colored_secondary__1006_v0 "${_cursor_52}""${check_mark_14668}""${truncated_14669}""
"
            local ret_colored_secondary1006_v0__73_37="${ret_colored_secondary1006_v0}"
            local array_228=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__73_37}" array_228[@]
        elif [ "${_checked_59[${global_idx_14667}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1029_v0 "${cursor_len_14663}"
            colored_secondary__1006_v0 "${check_mark_14668}""${truncated_14669}""
"
            local ret_colored_secondary1006_v0__76_25="${ret_colored_secondary1006_v0}"
            local array_229=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__76_25}" array_229[@]
        else
            print_blank__1029_v0 "${cursor_len_14663}"
            local array_230=("")
            eprintf__1023_v0 "${check_mark_14668}""${truncated_14669}""
" array_230[@]
        fi
done
    local remaining_slots_14671="$(( _display_count_48 - _page_count_58 ))"
    if [ "$(( remaining_slots_14671 > 0 ))" != 0 ]; then
        local __range_start_14672=0
        local __range_end_14672="${remaining_slots_14671}"
        local __dir_14672=$(( ${__range_start_14672} <= ${__range_end_14672} ? 1 : -1 ))
        for (( ____14672=${__range_start_14672}; ____14672 * ${__dir_14672} < ${__range_end_14672} * ${__dir_14672}; ____14672+=${__dir_14672} )); do
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
    local total_14602="${1}"
    local page_size_14603="${2}"
    local header_14604="${3}"
    local cursor_14605="${4}"
    local multi_14606="${5}"
    local limit_14607="${6}"
    _total_46="${total_14602}"
    _cursor_52="${cursor_14605}"
    _multi_53="${multi_14606}"
    _limit_54="${limit_14607}"
    _current_page_50=0
    _selected_51=0
    _first_render_61=1
    _up_paged_62=0
    _checked_count_60=0
    _has_header_56="$([ "_${header_14604}" == "_" ]; echo $?)"
    stty_lock__982_v0 
    hide_cursor__1034_v0 
    term_width__989_v0 
    _term_width_55="${ret_term_width989_v0}"
    term_height__990_v0 
    local term_height_14610="${ret_term_height990_v0}"
    local max_page_size_14611
    max_page_size_14611="$(( term_height_14610 - $(if [ "${_has_header_56}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_47="${page_size_14603}"
    if [ "$(( _page_size_47 > max_page_size_14611 ))" != 0 ]; then
        _page_size_47="${max_page_size_14611}"
    fi
    if [ "${_has_header_56}" != 0 ]; then
        cutoff_text__1043_v0 "${header_14604}" "${_term_width_55}"
        local ret_cutoff_text1043_v0__157_17="${ret_cutoff_text1043_v0}"
        local array_240=("")
        eprintf__1023_v0 "${ret_cutoff_text1043_v0__157_17}""
" array_240[@]
    fi
    math_floor__509_v0 "$(( $(( $(( total_14602 + _page_size_47 )) - 1 )) / _page_size_47 ))"
    _total_pages_49="${ret_math_floor509_v0}"
    _display_count_48="${_page_size_47}"
    if [ "$(( total_14602 < _page_size_47 ))" != 0 ]; then
        _display_count_48="${total_14602}"
    fi
    if [ "${multi_14606}" != 0 ]; then
        _checked_59=()
        local __range_start_14638=0
        local __range_end_14638="${total_14602}"
        local __dir_14638=$(( ${__range_start_14638} <= ${__range_end_14638} ? 1 : -1 ))
        for (( ____14638=${__range_start_14638}; ____14638 * ${__dir_14638} < ${__range_end_14638} * ${__dir_14638}; ____14638+=${__dir_14638} )); do
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
    local start_14658="${ret_chooser_page_start1201_v0}"
    local end_14659="$(( start_14658 + _page_size_47 ))"
    if [ "$(( end_14659 > _total_46 ))" != 0 ]; then
        end_14659="${_total_46}"
    fi
    ret_chooser_page_count1202_v0="$(( end_14659 - start_14658 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1203_v0() {
    local page_14662=("${!1}")
    _page_57=("${page_14662[@]}")
    local __length_245=("${page_14662[@]}")
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
    local prev_selected_14694="${1}"
    chooser_page_start__1201_v0 
    local page_start_14695="${ret_chooser_page_start1201_v0}"
    local check_width_14696
    check_width_14696="$(if [ "${_multi_53}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_247="${_cursor_52}"
    local max_option_width_14697="$(( $(( _term_width_55 - ${#__length_247} )) - check_width_14696 ))"
    go_up__1031_v0 "$(( _display_count_48 - prev_selected_14694 ))"
    local array_248=("")
    eprintf__1023_v0 "\\x1b[K" array_248[@]
    local __length_249="${_cursor_52}"
    print_blank__1029_v0 "${#__length_249}"
    if [ "${_multi_53}" != 0 ]; then
        local was_checked_14698="${_checked_59[$(( page_start_14695 + prev_selected_14694 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1043_v0 "${_page_57[${prev_selected_14694}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_14697}"
        local ret_cutoff_text1043_v0__232_63="${ret_cutoff_text1043_v0}"
        local prev_line_14699
        prev_line_14699="$(if [ "${was_checked_14698}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1043_v0__232_63}"
        if [ "${was_checked_14698}" != 0 ]; then
            colored_secondary__1006_v0 "${prev_line_14699}"
            local ret_colored_secondary1006_v0__234_21="${ret_colored_secondary1006_v0}"
            local array_250=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__234_21}" array_250[@]
        else
            local array_251=("")
            eprintf__1023_v0 "${prev_line_14699}" array_251[@]
        fi
    else
        cutoff_text__1043_v0 "${_page_57[${prev_selected_14694}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_14697}"
        local ret_cutoff_text1043_v0__239_17="${ret_cutoff_text1043_v0}"
        local array_252=("")
        eprintf__1023_v0 "${ret_cutoff_text1043_v0__239_17}" array_252[@]
    fi
    go_up_or_down__1033_v0 "$(( _selected_51 - prev_selected_14694 ))"
    local array_253=("")
    eprintf__1023_v0 "\\x1b[G" array_253[@]
    local array_254=("")
    eprintf__1023_v0 "\\x1b[K" array_254[@]
    local mark_14701
    mark_14701="$(if [ "${_multi_53}" != 0 ]; then echo "$(if [ "${_checked_59[$(( page_start_14695 + _selected_51 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1043_v0 "${_page_57[${_selected_51}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_14697}"
    local ret_cutoff_text1043_v0__246_48="${ret_cutoff_text1043_v0}"
    colored_secondary__1006_v0 "${_cursor_52}""${mark_14701}""${ret_cutoff_text1043_v0__246_48}"
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
    local page_start_14688="${ret_chooser_page_start1201_v0}"
    local __length_257="${_cursor_52}"
    local max_option_width_14689="$(( $(( _term_width_55 - ${#__length_257} )) - 3 ))"
    go_up__1031_v0 "$(( _display_count_48 - _selected_51 ))"
    local array_258=("")
    eprintf__1023_v0 "\\x1b[G" array_258[@]
    local array_259=("")
    eprintf__1023_v0 "\\x1b[K" array_259[@]
    local check_mark_14690
    check_mark_14690="$(if [ "${_checked_59[$(( page_start_14688 + _selected_51 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1043_v0 "${_page_57[${_selected_51}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_14689}"
    local ret_cutoff_text1043_v0__260_54="${ret_cutoff_text1043_v0}"
    colored_secondary__1006_v0 "${_cursor_52}""${check_mark_14690}""${ret_cutoff_text1043_v0__260_54}"
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
    local key_14683="${ret_get_key1021_v0}"
    local prev_selected_14684="${_selected_51}"
    local prev_page_14685="${_current_page_50}"
    chooser_page_start__1201_v0 
    local page_start_14686="${ret_chooser_page_start1201_v0}"
    _up_paged_62=0
    if [ "$(( $([ "_${key_14683}" != "_UP" ]; echo $?) || $([ "_${key_14683}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_14683}" != "_DOWN" ]; echo $?) || $([ "_${key_14683}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_14683}" != "_LEFT" ]; echo $?) || $([ "_${key_14683}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_50 > 0 ))" != 0 ]; then
            _current_page_50="$(( _current_page_50 - 1 ))"
        fi
        _selected_51=0
    elif [ "$(( $([ "_${key_14683}" != "_RIGHT" ]; echo $?) || $([ "_${key_14683}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_50 < $(( _total_pages_49 - 1 )) ))" != 0 ]; then
            _current_page_50="$(( _current_page_50 + 1 ))"
            _selected_51=0
        else
            _selected_51="$(( _page_count_58 - 1 ))"
        fi
    elif [ "$(( _multi_53 && $(( $([ "_${key_14683}" != "_x" ]; echo $?) || $([ "_${key_14683}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_14687="$(( page_start_14686 + _selected_51 ))"
        if [ "${_checked_59[${global_selected_14687}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_59["${global_selected_14687}"]=0
            _checked_count_60="$(( _checked_count_60 - 1 ))"
        elif [ "$(( $(( _limit_54 < 0 )) || $(( _checked_count_60 < _limit_54 )) ))" != 0 ]; then
            _checked_59["${global_selected_14687}"]=1
            _checked_count_60="$(( _checked_count_60 + 1 ))"
        else
            ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
            return 0
        fi
        redraw_current_line__1205_v0 
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
        return 0
    elif [ "$(( $(( _multi_53 && $(( $([ "_${key_14683}" != "_a" ]; echo $?) || $([ "_${key_14683}" != "_A" ]; echo $?) )) )) && $(( _limit_54 < 0 )) ))" != 0 ]; then
        local all_checked_14692="$(( _checked_count_60 == _total_46 ))"
        local __range_start_14693=0
        local __range_end_14693="${_total_46}"
        local __dir_14693=$(( ${__range_start_14693} <= ${__range_end_14693} ? 1 : -1 ))
        for (( i_14693=${__range_start_14693}; i_14693 * ${__dir_14693} < ${__range_end_14693} * ${__dir_14693}; i_14693+=${__dir_14693} )); do
            _checked_59["${i_14693}"]="$(( ! all_checked_14692 ))"
done
        _checked_count_60="$(if [ "${all_checked_14692}" != 0 ]; then echo 0; else echo "${_total_46}"; fi)"
        go_up__1031_v0 "${_display_count_48}"
        local array_262=("")
        eprintf__1023_v0 "\\x1b[G" array_262[@]
        render_page__1197_v0 
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
        return 0
    elif [ "$([ "_${key_14683}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1206_v0="${__CHOOSER_DONE_45}"
        return 0
    else
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_43}"
        return 0
    fi
    if [ "$(( prev_page_14685 != _current_page_50 ))" != 0 ]; then
        ret_chooser_step1206_v0="${__CHOOSER_NEED_PAGE_44}"
        return 0
    fi
    if [ "$(( prev_selected_14684 != _selected_51 ))" != 0 ]; then
        redraw_selection__1204_v0 "${prev_selected_14684}"
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
    local index_14707="${1}"
    ret_chooser_is_checked1208_v0="${_checked_59[${index_14707}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1209_v0() {
    local total_lines_14703="$(( _display_count_48 + 2 ))"
    if [ "${_has_header_56}" != 0 ]; then
        total_lines_14703="$(( total_lines_14703 + 1 ))"
    fi
    go_down__1032_v0 1
    remove_line__1027_v0 "$(( total_lines_14703 - 1 ))"
    remove_current_line__1028_v0 
    stty_unlock__983_v0 
    show_cursor__1035_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1218_v0() {
    local options_14711=("${!1}")
    local cursor_14712="${2}"
    local header_14713="${3}"
    local page_size_14714="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_263=("${options_14711[@]}")
    local total_14715="${#__length_263[@]}"
    if [ "$(( total_14715 == 0 ))" != 0 ]; then
        eprintf_colored__1024_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1200_v0 "${total_14715}" "${page_size_14714}" "${header_14713}" "${cursor_14712}" 0 -1
    local need_page_14716=1
    while :
    do
        if [ "${need_page_14716}" != 0 ]; then
            local page_14717=()
            chooser_page_start__1201_v0 
            local start_14718="${ret_chooser_page_start1201_v0}"
            chooser_page_count__1202_v0 
            local count_14719="${ret_chooser_page_count1202_v0}"
            local __range_start_14720="${start_14718}"
            local __range_end_14720="$(( start_14718 + count_14719 ))"
            local __dir_14720=$(( ${__range_start_14720} <= ${__range_end_14720} ? 1 : -1 ))
            for (( i_14720=${__range_start_14720}; i_14720 * ${__dir_14720} < ${__range_end_14720} * ${__dir_14720}; i_14720+=${__dir_14720} )); do
                local array_265=("${options_14711[${i_14720}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_14717+=("${array_265[@]}")
done
            chooser_set_page__1203_v0 page_14717[@]
        fi
        chooser_step__1206_v0 
        local step_14721="${ret_chooser_step1206_v0}"
        if [ "$(( step_14721 == __CHOOSER_DONE_45 ))" != 0 ]; then
            break
        fi
        need_page_14716="$(( step_14721 == __CHOOSER_NEED_PAGE_44 ))"
    done
    chooser_selected__1207_v0 
    local selected_14722="${ret_chooser_selected1207_v0}"
    chooser_end__1209_v0 
    ret_xyl_choose1218_v0="${options_14711[${selected_14722}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1219_v0() {
    local options_14596=("${!1}")
    local cursor_14597="${2}"
    local header_14598="${3}"
    local limit_14599="${4}"
    local page_size_14600="${5}"
    local __length_266=("${options_14596[@]}")
    local total_14601="${#__length_266[@]}"
    if [ "$(( total_14601 == 0 ))" != 0 ]; then
        eprintf_colored__1024_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1219_v0=()
        return 0
    fi
    chooser_begin__1200_v0 "${total_14601}" "${page_size_14600}" "${header_14598}" "${cursor_14597}" 1 "${limit_14599}"
    local need_page_14655=1
    while :
    do
        if [ "${need_page_14655}" != 0 ]; then
            local page_14656=()
            chooser_page_start__1201_v0 
            local start_14657="${ret_chooser_page_start1201_v0}"
            chooser_page_count__1202_v0 
            local count_14660="${ret_chooser_page_count1202_v0}"
            local __range_start_14661="${start_14657}"
            local __range_end_14661="$(( start_14657 + count_14660 ))"
            local __dir_14661=$(( ${__range_start_14661} <= ${__range_end_14661} ? 1 : -1 ))
            for (( i_14661=${__range_start_14661}; i_14661 * ${__dir_14661} < ${__range_end_14661} * ${__dir_14661}; i_14661+=${__dir_14661} )); do
                local array_269=("${options_14596[${i_14661}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_14656+=("${array_269[@]}")
done
            chooser_set_page__1203_v0 page_14656[@]
        fi
        chooser_step__1206_v0 
        local step_14702="${ret_chooser_step1206_v0}"
        if [ "$(( step_14702 == __CHOOSER_DONE_45 ))" != 0 ]; then
            break
        fi
        need_page_14655="$(( step_14702 == __CHOOSER_NEED_PAGE_44 ))"
    done
    chooser_end__1209_v0 
    local result_14705=()
    local __range_start_14706=0
    local __range_end_14706="${total_14601}"
    local __dir_14706=$(( ${__range_start_14706} <= ${__range_end_14706} ? 1 : -1 ))
    for (( i_14706=${__range_start_14706}; i_14706 * ${__dir_14706} < ${__range_end_14706} * ${__dir_14706}; i_14706+=${__dir_14706} )); do
        chooser_is_checked__1208_v0 "${i_14706}"
        local ret_chooser_is_checked1208_v0__93_12="${ret_chooser_is_checked1208_v0}"
        if [ "${ret_chooser_is_checked1208_v0__93_12}" != 0 ]; then
            local array_271=("${options_14596[${i_14706}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_14705+=("${array_271[@]}")
        fi
done
    ret_xyl_multi_choose1219_v0=("${result_14705[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1314_v0() {
    local usage_14531=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1047_v0 usage_14531[@]
    printf '%s\n' ""
    colored_primary__1005_v0 "choose"
    local ret_colored_primary1005_v0__8_20="${ret_colored_primary1005_v0}"
    local title_14553=("${ret_colored_primary1005_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1047_v0 title_14553[@]
    printf '%s\n' ""
    colored_secondary__1006_v0 "Arguments:"
    local ret_colored_secondary1006_v0__11_12="${ret_colored_secondary1006_v0}"
    local array_274=()
    printf__128_v0 "${ret_colored_secondary1006_v0__11_12}""
" array_274[@]
    local arg_names_14555=("[<options> ...]")
    local arg_texts_14556=("List of options to choose from")
    local arg_notes_14557=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1046_v0 arg_names_14555[@] arg_texts_14556[@] arg_notes_14557[@] 20
    printf '%s\n' ""
    colored_secondary__1006_v0 "Flags:"
    local ret_colored_secondary1006_v0__18_12="${ret_colored_secondary1006_v0}"
    local array_278=()
    printf__128_v0 "${ret_colored_secondary1006_v0__18_12}""
" array_278[@]
    local names_14585=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_14586=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_14587=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1046_v0 names_14585[@] texts_14586[@] notes_14587[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1366_v0() {
    local options_14524=()
    local command_283
    command_283="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_14525="${command_283}"
    if [ "$([ "_${is_tty_14525}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_14524+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1366_v0=("${options_14524[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1367_v0() {
    local parameters_14508=("${!1}")
    local cursor_14509="> "
    colored_primary__1005_v0 "Choose: "
    local ret_colored_primary1005_v0__17_30="${ret_colored_primary1005_v0}"
    local header_14523="\\x1b[1m""${ret_colored_primary1005_v0__17_30}"
    read_stdin_options__1366_v0 
    local options_14526=("${ret_read_stdin_options1366_v0[@]}")
    local multi_14527=0
    local limit_14528=-1
    local page_size_14529=10
    local __length_287=("${parameters_14508[@]}")
    local slice_upper_286="${#__length_287[@]}"
    local slice_offset_288=2
    local slice_offset_288=$((${slice_offset_288} > 0 ? ${slice_offset_288} : 0))
    local slice_length_289="$(( slice_upper_286 - slice_offset_288 ))"
    local slice_length_289=$((${slice_length_289} > 0 ? ${slice_length_289} : 0))
    for param_14530 in "${parameters_14508[@]:${slice_offset_288}:${slice_length_289}}"; do
        starts_with__22_v0 "${param_14530}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14530}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14530}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14530}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_14530}" != "_-h" ]; echo $?) || $([ "_${param_14530}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1314_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_290="--cursor="
            slice__24_v0 "${param_14530}" "${#__length_290}" 0
            cursor_14509="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_291="--header="
            slice__24_v0 "${param_14530}" "${#__length_291}" 0
            header_14523="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_292="--limit="
            slice__24_v0 "${param_14530}" "${#__length_292}" 0
            local value_14588="${ret_slice24_v0}"
            parse_int__13_v0 "${value_14588}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1024_v0 "ERROR: Invalid limit value: ""${value_14588}""
" 31
                exit 1
            fi
            limit_14528="${ret_parse_int13_v0}"
            multi_14527=1
        elif [ "$([ "_${param_14530}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_14527=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_293="--page-size="
            slice__24_v0 "${param_14530}" "${#__length_293}" 0
            local value_14593="${ret_slice24_v0}"
            parse_int__13_v0 "${value_14593}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1024_v0 "ERROR: Invalid page-size value: ""${value_14593}""
" 31
                exit 1
            fi
            page_size_14529="${ret_parse_int13_v0}"
        else
            options_14526+=("${param_14530}")
        fi
    done
    has_ansi_escape__1036_v0 "${header_14523}"
    local ret_has_ansi_escape1036_v0__59_44="${ret_has_ansi_escape1036_v0}"
    escape_ansi__1037_v0 "${header_14523}"
    local ret_escape_ansi1037_v0__59_73="${ret_escape_ansi1037_v0}"
    colored_primary__1005_v0 "${header_14523}"
    local ret_colored_primary1005_v0__59_111="${ret_colored_primary1005_v0}"
    local display_header_14595
    display_header_14595="$(if [ "$(( $([ "_${header_14523}" != "_" ]; echo $?) || ret_has_ansi_escape1036_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1037_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1005_v0__59_111}"; fi)"
    if [ "${multi_14527}" != 0 ]; then
        xyl_multi_choose__1219_v0 options_14526[@] "${cursor_14509}" "${display_header_14595}" "${limit_14528}" "${page_size_14529}"
        local results_14708=("${ret_xyl_multi_choose1219_v0[@]}")
        join__7_v0 results_14708[@] "
"
        ret_execute_choose1367_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1218_v0 options_14526[@] "${cursor_14509}" "${display_header_14595}" "${page_size_14529}"
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
    local text_16443="${1}"
    if [ "$(( ! _perl_available_71 ))" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return 1
    fi
    local command_297
    command_297="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16443}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return "${__status}"
    fi
    local width_str_16444="${command_297}"
    parse_int__13_v0 "${width_str_16444}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return "${__status}"
    fi
    local width_16445="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1542_v0="${width_16445}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1543_v0() {
    local text_16498="${1}"
    local max_width_16499="${2}"
    if [ "$(( ! _perl_available_71 ))" != 0 ]; then
        ret_perl_truncate_cjk1543_v0=''
        return 1
    fi
    local command_298
    command_298="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16498}" ${max_width_16499} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1543_v0=''
        return "${__status}"
    fi
    local result_16500="${command_298}"
    ret_perl_truncate_cjk1543_v0="${result_16500}"
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
    local count_16487="${command_300}"
    parse_int__13_v0 "${count_16487}"
    __status=$?
    ret_stty_count1550_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1551_v0() {
    stty_count__1550_v0 
    local count_num_16488="${ret_stty_count1550_v0}"
    if [ "$(( count_num_16488 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16488="$(( count_num_16488 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16488}
    __status=$?
}

# stty_unlock()
stty_unlock__1552_v0() {
    stty_count__1550_v0 
    local count_num_16564="${ret_stty_count1550_v0}"
    if [ "$(( count_num_16564 > 0 ))" != 0 ]; then
        count_num_16564="$(( count_num_16564 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16564}
        __status=$?
        if [ "$(( count_num_16564 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1553_v0() {
    local size_16427="${1}"
    if [ "$([ "_${size_16427}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1553_v0=0
        return 0
    fi
    split__4_v0 "${size_16427}" " "
    local parts_16428=("${ret_split4_v0[@]}")
    local __length_301=("${parts_16428[@]}")
    if [ "$(( ${#__length_301[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1553_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16428[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16428[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:68)"}"
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
    local size_16430="${command_303}"
    store_term_size__1553_v0 "${size_16430}"
    ret_query_term_size1554_v0="${ret_store_term_size1553_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1555_v0() {
    local command_304
    command_304="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16426="${command_304}"
    store_term_size__1553_v0 "${size_16426}"
    ret_stty_term_size1555_v0="${ret_store_term_size1553_v0}"
    return 0
}

# get_term_size()
get_term_size__1556_v0() {
    stty_term_size__1555_v0 
    local detected_16429="${ret_stty_term_size1555_v0}"
    if [ "$(( ! detected_16429 ))" != 0 ]; then
        query_term_size__1554_v0 
        detected_16429="${ret_query_term_size1554_v0}"
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
    local config_16420="${ret_env_var_get120_v0}"
    _supports_truecolor_74="$(if [ "$([ "_${config_16420}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1569_v0="$([ "_${_supports_truecolor_74}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1570_v0() {
    local message_16415="${1}"
    local r_16416="${2}"
    local g_16417="${3}"
    local b_16418="${4}"
    local fallback_16419="${5}"
    if [ "$([ "_${_supports_truecolor_74}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1570_v0="\\x1b[38;2;${r_16416};${g_16417};${b_16418}m""${message_16415}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_74}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1569_v0 
        local ret_get_supports_truecolor1569_v0__45_17="${ret_get_supports_truecolor1569_v0}"
        if [ "${ret_get_supports_truecolor1569_v0__45_17}" != 0 ]; then
            ret_colored_rgb1570_v0="\\x1b[38;2;${r_16416};${g_16417};${b_16418}m""${message_16415}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16419 == 0 ))" != 0 ]; then
            ret_colored_rgb1570_v0="${message_16415}"
            return 0
        else
            ret_colored_rgb1570_v0="\\x1b[${fallback_16419}m""${message_16415}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16419 == 0 ))" != 0 ]; then
            ret_colored_rgb1570_v0="${message_16415}"
            return 0
        fi
        ret_colored_rgb1570_v0="\\x1b[${fallback_16419}m""${message_16415}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1571_v0() {
    local message_16537="${1}"
    local r_16538="${2}"
    local g_16539="${3}"
    local b_16540="${4}"
    local fallback_16541="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_16542="${fallback_16541}"
    if [ "$(( $(( fallback_16541 >= 30 )) && $(( fallback_16541 <= 37 )) ))" != 0 ]; then
        bg_fallback_16542="$(( fallback_16541 + 10 ))"
    fi
    if [ "$(( $(( fallback_16541 >= 90 )) && $(( fallback_16541 <= 97 )) ))" != 0 ]; then
        bg_fallback_16542="$(( fallback_16541 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_74}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1571_v0="\\x1b[48;2;${r_16538};${g_16539};${b_16540}m""${message_16537}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_74}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1569_v0 
        local ret_get_supports_truecolor1569_v0__87_17="${ret_get_supports_truecolor1569_v0}"
        if [ "${ret_get_supports_truecolor1569_v0__87_17}" != 0 ]; then
            ret_background_rgb1571_v0="\\x1b[48;2;${r_16538};${g_16539};${b_16540}m""${message_16537}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_16542 == 0 ))" != 0 ]; then
            ret_background_rgb1571_v0="${message_16537}"
            return 0
        else
            ret_background_rgb1571_v0="\\x1b[${bg_fallback_16542}m""${message_16537}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_16542 == 0 ))" != 0 ]; then
            ret_background_rgb1571_v0="${message_16537}"
            return 0
        fi
        ret_background_rgb1571_v0="\\x1b[${bg_fallback_16542}m""${message_16537}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1572_v0() {
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16409="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16409}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16409}" ";"
            local parts_16410=("${ret_split4_v0[@]}")
            local __length_308=("${parts_16410[@]}")
            if [ "$(( ${#__length_308[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16410[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16410[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16410[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16410[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_76=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16411="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16411}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16411}" ";"
            local parts_16412=("${ret_split4_v0[@]}")
            local __length_310=("${parts_16412[@]}")
            if [ "$(( ${#__length_310[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16412[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16412[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16412[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16412[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_77=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16413="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16413}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16413}" ";"
            local parts_16414=("${ret_split4_v0[@]}")
            local __length_312=("${parts_16414[@]}")
            if [ "$(( ${#__length_312[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16414[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16414[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16414[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16414[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
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
    local message_16408="${1}"
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    colored_rgb__1570_v0 "${message_16408}" "${_primary_color_76[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_76[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_76[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_76[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1574_v0="${ret_colored_rgb1570_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1575_v0() {
    local message_16447="${1}"
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    colored_rgb__1570_v0 "${message_16447}" "${_secondary_color_77[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_77[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_77[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_77[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1575_v0="${ret_colored_rgb1570_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1578_v0() {
    local message_16536="${1}"
    if [ "$(( ! _got_xylitol_colors_75 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    background_rgb__1571_v0 "${message_16536}" "${_secondary_color_77[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_77[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_77[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_77[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary1578_v0="${ret_background_rgb1571_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1590_v0() {
    local command_314
    command_314="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16557="${command_314}"
    if [ "$([ "_${var_16557}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="UP"
        return 0
    elif [ "$([ "_${var_16557}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16557}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16557}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16557}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16557}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="INPUT"
        return 0
    else
        ret_get_key1590_v0="${var_16557}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1592_v0() {
    local format_16481="${1}"
    local args_16482=("${!2}")
    args_16482=("${format_16481}" "${args_16482[@]}")
    __status=$?
    printf "${args_16482[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1593_v0() {
    local message_16479="${1}"
    local color_16480="${2}"
    # Prints an error message with a specified color.
    local array_315=("${message_16479}")
    eprintf__1592_v0 "\\x1b[${color_16480}m%s\\x1b[0m" array_315[@]
}

# colored(message: Text, color: Int)
colored__1594_v0() {
    local message_16476="${1}"
    local color_16477="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1594_v0="\\x1b[${color_16477}m""${message_16476}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1596_v0() {
    local cnt_16561="${1}"
    if [ "$(( cnt_16561 > 0 ))" != 0 ]; then
        local sequence_16562=""
        local __range_start_16563=0
        local __range_end_16563="${cnt_16561}"
        local __dir_16563=$(( ${__range_start_16563} <= ${__range_end_16563} ? 1 : -1 ))
        for (( ____16563=${__range_start_16563}; ____16563 * ${__dir_16563} < ${__range_end_16563} * ${__dir_16563}; ____16563+=${__dir_16563} )); do
            sequence_16562+="\\x1b[2K\\x1b[1A"
done
        local array_316=("")
        eprintf__1592_v0 "${sequence_16562}" array_316[@]
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
    local cnt_16556="${1}"
    local array_319=("")
    eprintf__1592_v0 "\\x1b[${cnt_16556}A" array_319[@]
}

# go_down(cnt: Int)
go_down__1601_v0() {
    local cnt_16560="${1}"
    local array_320=("")
    eprintf__1592_v0 "\\x1b[${cnt_16560}B" array_320[@]
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
    local text_16436="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_323
    command_323="$([[ "${text_16436}" == *$'\x1b'* || "${text_16436}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16437="${command_323}"
    ret_has_ansi_escape1605_v0="$([ "_${has_escape_16437}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1606_v0() {
    local text_16483="${1}"
    local command_324
    command_324="$(printf '%s' "${text_16483}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1606_v0="${command_324}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1607_v0() {
    local text_16439="${1}"
    local command_325
    command_325="$(printf "%s" "${text_16439}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1607_v0="${command_325}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1608_v0() {
    local text_16441="${1}"
    local command_326
    command_326="$(printf "%s" "${text_16441}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16442="${command_326}"
    ret_is_all_ascii1608_v0="$([ "_${result_16442}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1609_v0() {
    local text_16438="${1}"
    strip_ansi__1607_v0 "${text_16438}"
    local stripped_16440="${ret_strip_ansi1607_v0}"
    # Check if text is all ASCII
    is_all_ascii__1608_v0 "${stripped_16440}"
    local ret_is_all_ascii1608_v0__150_12="${ret_is_all_ascii1608_v0}"
    if [ "$(( ! ret_is_all_ascii1608_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1542_v0 "${stripped_16440}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_327="${stripped_16440}"
            ret_get_visible_len1609_v0="${#__length_327}"
            return 0
        fi
        ret_get_visible_len1609_v0="${ret_perl_get_cjk_width1542_v0}"
        return 0
    else
        local __length_328="${stripped_16440}"
        ret_get_visible_len1609_v0="${#__length_328}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1610_v0() {
    local text_16495="${1}"
    local max_width_16496="${2}"
    get_visible_len__1609_v0 "${text_16495}"
    local visible_len_16497="${ret_get_visible_len1609_v0}"
    if [ "$(( visible_len_16497 <= max_width_16496 ))" != 0 ]; then
        ret_truncate_text1610_v0="${text_16495}"
        return 0
    fi
    is_all_ascii__1608_v0 "${text_16495}"
    local ret_is_all_ascii1608_v0__167_12="${ret_is_all_ascii1608_v0}"
    if [ "$(( ! ret_is_all_ascii1608_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1543_v0 "${text_16495}" "${max_width_16496}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16495}" | cut -c1-${max_width_16496}
            __status=$?
        fi
        ret_truncate_text1610_v0="${ret_perl_truncate_cjk1543_v0}"
        return 0
    fi
    local command_329
    command_329="$(printf "%s" "${text_16495}" | cut -c1-${max_width_16496})"
    __status=$?
    ret_truncate_text1610_v0="${command_329}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1611_v0() {
    local text_16493="${1}"
    local max_width_16494="${2}"
    has_ansi_escape__1605_v0 "${text_16493}"
    local ret_has_ansi_escape1605_v0__179_12="${ret_has_ansi_escape1605_v0}"
    if [ "$(( ! ret_has_ansi_escape1605_v0__179_12 ))" != 0 ]; then
        truncate_text__1610_v0 "${text_16493}" "${max_width_16494}"
        ret_truncate_ansi1611_v0="${ret_truncate_text1610_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_330
    command_330="$([[ "${text_16493}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16501="${command_330}"
    # Replace \x1b[ with newline, then split
    local command_331
    command_331="$(t="${text_16493}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16502="${command_331}"
    split__4_v0 "${replaced_16502}" "
"
    local parts_16503=("${ret_split4_v0[@]}")
    local result_16504=""
    local remaining_width_16505="${max_width_16494}"
    local __range_start_16506=0
    local __length_332=("${parts_16503[@]}")
    local __range_end_16506="${#__length_332[@]}"
    local __dir_16506=$(( ${__range_start_16506} <= ${__range_end_16506} ? 1 : -1 ))
    for (( idx_16506=${__range_start_16506}; idx_16506 * ${__dir_16506} < ${__range_end_16506} * ${__dir_16506}; idx_16506+=${__dir_16506} )); do
        local part_16507="${parts_16503[${idx_16506}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16506 == 0 )) && $([ "_${starts_with_ansi_16501}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16507}" == "_" ]; echo $?) && $(( remaining_width_16505 > 0 )) ))" != 0 ]; then
                truncate_text__1610_v0 "${part_16507}" "${remaining_width_16505}"
                local ret_truncate_text1610_v0__201_35="${ret_truncate_text1610_v0}"
                local truncated_16508="${ret_truncate_text1610_v0__201_35}"
                result_16504+="${truncated_16508}"
                get_visible_len__1609_v0 "${truncated_16508}"
                local ret_get_visible_len1609_v0__203_36="${ret_get_visible_len1609_v0}"
                remaining_width_16505="$(( remaining_width_16505 - ret_get_visible_len1609_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_333
            command_333="$(__p="${part_16507}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16509="${command_333}"
            if [ "$([ "_${m_idx_16509}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_334
                command_334="$(__p="${part_16507}"; printf "%s" "${__p:0:${m_idx_16509}}")"
                __status=$?
                local ansi_params_16510="${command_334}"
                result_16504+="\\x1b[""${ansi_params_16510}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16509}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_16511="${ret_parse_int13_v0__214_41}"
                local text_start_16512="$(( m_idx_num_16511 + 1 ))"
                local command_335
                command_335="$(__p="${part_16507}"; printf "%s" "${__p:${text_start_16512}}")"
                __status=$?
                local text_part_16513="${command_335}"
                if [ "$(( $([ "_${text_part_16513}" == "_" ]; echo $?) && $(( remaining_width_16505 > 0 )) ))" != 0 ]; then
                    truncate_text__1610_v0 "${text_part_16513}" "${remaining_width_16505}"
                    local ret_truncate_text1610_v0__218_39="${ret_truncate_text1610_v0}"
                    local truncated_16514="${ret_truncate_text1610_v0__218_39}"
                    result_16504+="${truncated_16514}"
                    get_visible_len__1609_v0 "${truncated_16514}"
                    local ret_get_visible_len1609_v0__220_40="${ret_get_visible_len1609_v0}"
                    remaining_width_16505="$(( remaining_width_16505 - ret_get_visible_len1609_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16507}" == "_" ]; echo $?) && $(( remaining_width_16505 > 0 )) ))" != 0 ]; then
                    truncate_text__1610_v0 "${part_16507}" "${remaining_width_16505}"
                    local ret_truncate_text1610_v0__225_39="${ret_truncate_text1610_v0}"
                    local truncated_16515="${ret_truncate_text1610_v0__225_39}"
                    result_16504+="${truncated_16515}"
                    get_visible_len__1609_v0 "${truncated_16515}"
                    local ret_get_visible_len1609_v0__227_40="${ret_get_visible_len1609_v0}"
                    remaining_width_16505="$(( remaining_width_16505 - ret_get_visible_len1609_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1611_v0="${result_16504}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1612_v0() {
    local text_16490="${1}"
    local max_width_16491="${2}"
    get_visible_len__1609_v0 "${text_16490}"
    local visible_len_16492="${ret_get_visible_len1609_v0}"
    if [ "$(( visible_len_16492 <= max_width_16491 ))" != 0 ]; then
        ret_cutoff_text1612_v0="${text_16490}"
        return 0
    fi
    truncate_ansi__1611_v0 "${text_16490}" "$(( max_width_16491 - 3 ))"
    local ret_truncate_ansi1611_v0__243_12="${ret_truncate_ansi1611_v0}"
    ret_cutoff_text1612_v0="${ret_truncate_ansi1611_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1613_v0() {
    local items_16543=("${!1}")
    local total_len_16544="${2}"
    local term_width_16545="${3}"
    local separator_16546=" • "
    local separator_len_16547=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16544 <= term_width_16545 ))" != 0 ]; then
        local iter_16548=0
        while :
        do
            local __length_336=("${items_16543[@]}")
            if [ "$(( iter_16548 >= ${#__length_336[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16548 > 0 ))" != 0 ]; then
                eprintf_colored__1593_v0 "${separator_16546}" 90
            fi
            colored__1594_v0 "${items_16543[$(( iter_16548 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1594_v0__268_41="${ret_colored1594_v0}"
            local array_337=("")
            eprintf__1592_v0 "${items_16543[${iter_16548}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1594_v0__268_41}" array_337[@]
            iter_16548="$(( iter_16548 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16549=0
        local first_16550=1
        local iter_16551=0
        while :
        do
            local __length_338=("${items_16543[@]}")
            if [ "$(( iter_16551 >= ${#__length_338[@]} ))" != 0 ]; then
                break
            fi
            local key_16552="${items_16543[${iter_16551}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_16553="${items_16543[$(( iter_16551 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_339="${key_16552}"
            local __length_340="${action_16553}"
            local part_len_16554="$(( $(( ${#__length_339} + 1 )) + ${#__length_340} ))"
            local needed_16555="${part_len_16554}"
            if [ "$(( ! first_16550 ))" != 0 ]; then
                needed_16555="$(( needed_16555 + separator_len_16547 ))"
            fi
            if [ "$(( $(( current_len_16549 + needed_16555 )) > term_width_16545 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16550 ))" != 0 ]; then
                eprintf_colored__1593_v0 "${separator_16546}" 90
            fi
            colored__1594_v0 "${action_16553}" 2
            local ret_colored1594_v0__296_33="${ret_colored1594_v0}"
            local array_341=("")
            eprintf__1592_v0 "${key_16552}"" ""${ret_colored1594_v0__296_33}" array_341[@]
            current_len_16549="$(( current_len_16549 + needed_16555 ))"
            first_16550=0
            iter_16551="$(( iter_16551 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1614_v0() {
    local pending_16473="${1}"
    local line_16474="${2}"
    local note_at_16475="${3}"
    if [ "$(( note_at_16475 < 0 ))" != 0 ]; then
        local array_342=()
        printf__128_v0 "${pending_16473}""${line_16474}""
" array_342[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16475 == 0 ))" != 0 ]; then
        colored__1594_v0 "${line_16474}" 90
        local ret_colored1594_v0__310_40="${ret_colored1594_v0}"
        local array_343=()
        printf__128_v0 "${pending_16473}""${ret_colored1594_v0__310_40}""
" array_343[@]
    else
        slice__24_v0 "${line_16474}" 0 "${note_at_16475}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16474}" "${note_at_16475}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1594_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1594_v0__311_58="${ret_colored1594_v0}"
        local array_344=()
        printf__128_v0 "${pending_16473}""${ret_slice24_v0__311_32}""${ret_colored1594_v0__311_58}""
" array_344[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1615_v0() {
    local names_16451=("${!1}")
    local texts_16452=("${!2}")
    local notes_16453=("${!3}")
    local min_name_width_16454="${4}"
    local __length_345=("${names_16451[@]}")
    local count_16455="${#__length_345[@]}"
    local name_width_16456="${min_name_width_16454}"
    local __range_start_16457=0
    local __range_end_16457="${count_16455}"
    local __dir_16457=$(( ${__range_start_16457} <= ${__range_end_16457} ? 1 : -1 ))
    for (( i_16457=${__range_start_16457}; i_16457 * ${__dir_16457} < ${__range_end_16457} * ${__dir_16457}; i_16457+=${__dir_16457} )); do
        local __length_346="${names_16451[${i_16457}]?"Index out of bounds (at src/./confirm/../utils.ab:326:33)"}"
        local width_16458="${#__length_346}"
        if [ "$(( width_16458 > name_width_16456 ))" != 0 ]; then
            name_width_16456="${width_16458}"
        fi
done
    term_width__1558_v0 
    local width_16459="${ret_term_width1558_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16460="$(( name_width_16456 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16461="$(( $(( width_16459 - indent_16460 )) < 24 ))"
    if [ "${stacked_16461}" != 0 ]; then
        indent_16460=6
    fi
    local avail_16462="$(( width_16459 - indent_16460 ))"
    rpad__28_v0 "" " " "${indent_16460}"
    local blank_16463="${ret_rpad28_v0}"
    local __range_start_16464=0
    local __range_end_16464="${count_16455}"
    local __dir_16464=$(( ${__range_start_16464} <= ${__range_end_16464} ? 1 : -1 ))
    for (( i_16464=${__range_start_16464}; i_16464 * ${__dir_16464} < ${__range_end_16464} * ${__dir_16464}; i_16464+=${__dir_16464} )); do
        local pending_16465="${blank_16463}"
        if [ "${stacked_16461}" != 0 ]; then
            local array_347=()
            printf__128_v0 "  ""${names_16451[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:346:33)"}""
" array_347[@]
        else
            rpad__28_v0 "  ""${names_16451[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:348:41)"}" " " "${indent_16460}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_16465="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_16452[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_16466=("${ret_split4_v0__350_21[@]}")
        local __length_348=("${words_16466[@]}")
        local note_start_16467="${#__length_348[@]}"
        if [ "$([ "_${notes_16453[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_349="${notes_16453[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_349} > avail_16462 ))" != 0 ]; then
                split__4_v0 "${notes_16453[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_16466+=("${ret_split4_v0__356_26[@]}")
            else
                local array_350=("${notes_16453[${i_16464}]?"Index out of bounds (at src/./confirm/../utils.ab:358:33)"}")
                words_16466+=("${array_350[@]}")
            fi
        fi
        local line_16468=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16469=-1
        local __range_start_16470=0
        local __length_351=("${words_16466[@]}")
        local __range_end_16470="${#__length_351[@]}"
        local __dir_16470=$(( ${__range_start_16470} <= ${__range_end_16470} ? 1 : -1 ))
        for (( j_16470=${__range_start_16470}; j_16470 * ${__dir_16470} < ${__range_end_16470} * ${__dir_16470}; j_16470+=${__dir_16470} )); do
            local word_16471="${words_16466[${j_16470}]?"Index out of bounds (at src/./confirm/../utils.ab:368:32)"}"
            local candidate_16472
            candidate_16472="$(if [ "$([ "_${line_16468}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16471}"; else echo "${line_16468}"" ""${word_16471}"; fi)"
            local __length_352="${candidate_16472}"
            if [ "$(( $(( ${#__length_352} > avail_16462 )) && $([ "_${line_16468}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1614_v0 "${pending_16465}" "${line_16468}" "${note_at_16469}"
                pending_16465="${blank_16463}"
                line_16468="${word_16471}"
                note_at_16469="$(if [ "$(( j_16470 >= note_start_16467 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16470 >= note_start_16467 )) && $(( note_at_16469 < 0 )) ))" != 0 ]; then
                    local __length_353="${candidate_16472}"
                    local __length_354="${word_16471}"
                    note_at_16469="$(( ${#__length_353} - ${#__length_354} ))"
                fi
                line_16468="${candidate_16472}"
            fi
done
        print_help_line__1614_v0 "${pending_16465}" "${line_16468}" "${note_at_16469}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1616_v0() {
    local pieces_16425=("${!1}")
    term_width__1558_v0 
    local width_16431="${ret_term_width1558_v0}"
    local line_16432=""
    local line_len_16433=0
    for piece_16434 in "${pieces_16425[@]}"; do
        local __length_357="${piece_16434}"
        local piece_len_16435="${#__length_357}"
        has_ansi_escape__1605_v0 "${piece_16434}"
        local ret_has_ansi_escape1605_v0__397_12="${ret_has_ansi_escape1605_v0}"
        if [ "${ret_has_ansi_escape1605_v0__397_12}" != 0 ]; then
            get_visible_len__1609_v0 "${piece_16434}"
            piece_len_16435="${ret_get_visible_len1609_v0}"
        fi
        if [ "$([ "_${line_16432}" != "_" ]; echo $?)" != 0 ]; then
            line_16432="${piece_16434}"
            line_len_16433="${piece_len_16435}"
        elif [ "$(( $(( $(( line_len_16433 + 1 )) + piece_len_16435 )) > width_16431 ))" != 0 ]; then
            local array_358=()
            printf__128_v0 "${line_16432}""
" array_358[@]
            line_16432="${piece_16434}"
            line_len_16433="${piece_len_16435}"
        else
            line_16432+=" ""${piece_16434}"
            line_len_16433="$(( line_len_16433 + $(( 1 + piece_len_16435 )) ))"
        fi
    done
    if [ "$([ "_${line_16432}" == "_" ]; echo $?)" != 0 ]; then
        local array_359=()
        printf__128_v0 "${line_16432}""
" array_359[@]
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1667_v0() {
    local selected_16517="${1}"
    local term_width_16518="${2}"
    local small_16519="$(( term_width_16518 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_16519}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_16533="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_16519}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_16534="${ret_cpad29_v0}"
    local gap_16535
    gap_16535="$(if [ "${small_16519}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_360=("")
    eprintf__1592_v0 " " array_360[@]
    if [ "${selected_16517}" != 0 ]; then
        # Yes selected
        background_secondary__1578_v0 "${yes_label_16533}"
        local ret_background_secondary1578_v0__16_30="${ret_background_secondary1578_v0}"
        local array_361=("")
        eprintf__1592_v0 "\\x1b[97m""${ret_background_secondary1578_v0__16_30}" array_361[@]
        local array_362=("")
        eprintf__1592_v0 "${gap_16535}" array_362[@]
        # No not selected (dim)
        local array_363=("")
        eprintf__1592_v0 "\\x1b[49;37m""${no_label_16534}""\\x1b[0m" array_363[@]
    else
        # No selected
        local array_364=("")
        eprintf__1592_v0 "\\x1b[49;37m""${yes_label_16533}""\\x1b[0m" array_364[@]
        local array_365=("")
        eprintf__1592_v0 "${gap_16535}" array_365[@]
        background_secondary__1578_v0 "${no_label_16534}"
        local ret_background_secondary1578_v0__24_30="${ret_background_secondary1578_v0}"
        local array_366=("")
        eprintf__1592_v0 "\\x1b[97m""${ret_background_secondary1578_v0__24_30}" array_366[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1668_v0() {
    local header_16485="${1}"
    local default_yes_16486="${2}"
    stty_lock__1551_v0 
    hide_cursor__1603_v0 
    term_width__1558_v0 
    local term_width_16489="${ret_term_width1558_v0}"
    if [ "$([ "_${header_16485}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1612_v0 "${header_16485}" "${term_width_16489}"
        local ret_cutoff_text1612_v0__46_17="${ret_cutoff_text1612_v0}"
        local array_367=("")
        eprintf__1592_v0 "${ret_cutoff_text1612_v0__46_17}""

" array_367[@]
    fi
    local selected_16516="${default_yes_16486}"
    # Render initial options
    render_confirm_options__1667_v0 "${selected_16516}" "${term_width_16489}"
    local array_368=("")
    eprintf__1592_v0 "

" array_368[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_369=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1613_v0 array_369[@] 40 "${term_width_16489}"
    go_up__1600_v0 2
    while :
    do
        get_key__1590_v0 
        local key_16558="${ret_get_key1590_v0}"
        if [ "$(( $(( $(( $([ "_${key_16558}" != "_LEFT" ]; echo $?) || $([ "_${key_16558}" != "_h" ]; echo $?) )) || $([ "_${key_16558}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_16558}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_16516}" != 0 ]; then
                selected_16516=0
                local array_370=("")
                eprintf__1592_v0 "\\x1b[G\\x1b[K" array_370[@]
                render_confirm_options__1667_v0 "${selected_16516}" "${term_width_16489}"
            elif [ "$(( ! selected_16516 ))" != 0 ]; then
                selected_16516=1
                local array_371=("")
                eprintf__1592_v0 "\\x1b[G\\x1b[K" array_371[@]
                render_confirm_options__1667_v0 "${selected_16516}" "${term_width_16489}"
            fi
        elif [ "$(( $([ "_${key_16558}" != "_y" ]; echo $?) || $([ "_${key_16558}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_16516=1
            break
        elif [ "$(( $([ "_${key_16558}" != "_n" ]; echo $?) || $([ "_${key_16558}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_16516=0
            break
        elif [ "$([ "_${key_16558}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_16559=4
    if [ "$([ "_${header_16485}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_16559="$(( total_lines_16559 + 1 ))"
    fi
    go_down__1601_v0 2
    remove_line__1596_v0 "$(( total_lines_16559 - 1 ))"
    remove_current_line__1597_v0 
    stty_unlock__1552_v0 
    show_cursor__1604_v0 
    ret_xyl_confirm1668_v0="${selected_16516}"
    return 0
}

# print_confirm_help()
print_confirm_help__1762_v0() {
    local usage_16424=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1616_v0 usage_16424[@]
    printf '%s\n' ""
    colored_primary__1574_v0 "confirm"
    local ret_colored_primary1574_v0__8_20="${ret_colored_primary1574_v0}"
    local title_16446=("${ret_colored_primary1574_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1616_v0 title_16446[@]
    printf '%s\n' ""
    colored_secondary__1575_v0 "Flags:"
    local ret_colored_secondary1575_v0__11_12="${ret_colored_secondary1575_v0}"
    local array_374=()
    printf__128_v0 "${ret_colored_secondary1575_v0__11_12}""
" array_374[@]
    local names_16448=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_16449=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_16450=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__1615_v0 names_16448[@] texts_16449[@] notes_16450[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1814_v0() {
    local parameters_16407=("${!1}")
    colored_primary__1574_v0 "Are you sure?"
    local ret_colored_primary1574_v0__9_30="${ret_colored_primary1574_v0}"
    local header_16421="\\x1b[1m""${ret_colored_primary1574_v0__9_30}"
    local default_yes_16422=1
    for param_16423 in "${parameters_16407[@]}"; do
        starts_with__22_v0 "${param_16423}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16423}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16423}" != "_-h" ]; echo $?) || $([ "_${param_16423}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1762_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_380="--header="
            slice__24_v0 "${param_16423}" "${#__length_380}" 0
            header_16421="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_381="--default="
            slice__24_v0 "${param_16423}" "${#__length_381}" 0
            local value_16478="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_16478}" != "_yes" ]; echo $?) || $([ "_${value_16478}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_16422=1
            elif [ "$(( $([ "_${value_16478}" != "_no" ]; echo $?) || $([ "_${value_16478}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_16422=0
            else
                eprintf_colored__1593_v0 "ERROR: Invalid default value: ""${value_16478}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1605_v0 "${header_16421}"
    local ret_has_ansi_escape1605_v0__35_44="${ret_has_ansi_escape1605_v0}"
    escape_ansi__1606_v0 "${header_16421}"
    local ret_escape_ansi1606_v0__35_73="${ret_escape_ansi1606_v0}"
    colored_primary__1574_v0 "${header_16421}"
    local ret_colored_primary1574_v0__35_111="${ret_colored_primary1574_v0}"
    local display_header_16484
    display_header_16484="$(if [ "$(( $([ "_${header_16421}" != "_" ]; echo $?) || ret_has_ansi_escape1605_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1606_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1574_v0__35_111}"; fi)"
    xyl_confirm__1668_v0 "${display_header_16484}" "${default_yes_16422}"
    local result_16565="${ret_xyl_confirm1668_v0}"
    ret_execute_confirm1814_v0="$(if [ "${result_16565}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_82=3
# get_directory_entries(path: Text)
get_directory_entries__1969_v0() {
    local path_24940="${1}"
    local __ls_path_382="${path_24940}"
    __ls_path_382="${__ls_path_382//\\/\\\\}"
    (( 1 )) && __ls_all_382="-A" || __ls_all_382=""
    (( 0 )) && __ls_rec_382="-R" || __ls_rec_382=""
    local __ls_382=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_382 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_382} ${__ls_rec_382} ${__ls_path_382}
    __status=$?
    );
    local names_24941=("${__ls_382[@]}")
    local command_383
    command_383="$(LC_ALL=C ls -lA "${path_24940}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_24942="${command_383}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_384
    command_384="$(LC_ALL=C ls -lA "${path_24940}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_24943="${command_384}"
    split__4_v0 "${types_output_24942}" "
"
    local types_24944=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_24943}" "
"
    local targets_24945=("${ret_split4_v0[@]}")
    local entries_24946=()
    local __range_start_24947=0
    local __length_386=("${names_24941[@]}")
    local __range_end_24947="${#__length_386[@]}"
    local __dir_24947=$(( ${__range_start_24947} <= ${__range_end_24947} ? 1 : -1 ))
    for (( i_24947=${__range_start_24947}; i_24947 * ${__dir_24947} < ${__range_end_24947} * ${__dir_24947}; i_24947+=${__dir_24947} )); do
        local array_387=("${names_24941[${i_24947}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_24946+=("${array_387[@]}")
        local array_388=("${types_24944[${i_24947}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_24946+=("${array_388[@]}")
        slice__24_v0 "${targets_24945[${i_24947}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_389=("${ret_slice24_v0__31_21}")
        entries_24946+=("${array_389[@]}")
done
    ret_get_directory_entries1969_v0=("${entries_24946[@]}")
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
    local path_24938="${1}"
    local command_391
    command_391="$(cd "${path_24938}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_24939="${command_391}"
    if [ "$([ "_${normalized_24939}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1971_v0="${path_24938}"
        return 0
    fi
    ret_normalize_path1971_v0="${normalized_24939}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1972_v0() {
    local base_25105="${1}"
    local child_25106="${2}"
    if [ "$([ "_${base_25105}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1972_v0="/""${child_25106}"
        return 0
    fi
    ret_path_join1972_v0="${base_25105}""/""${child_25106}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1973_v0() {
    local path_25103="${1}"
    local command_392
    command_392="$(dirname "${path_25103}")"
    __status=$?
    local parent_25104="${command_392}"
    ret_get_parent_dir1973_v0="${parent_25104}"
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
    local text_24875="${1}"
    if [ "$(( ! _perl_available_85 ))" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return 1
    fi
    local command_395
    command_395="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_24875}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return "${__status}"
    fi
    local width_str_24876="${command_395}"
    parse_int__13_v0 "${width_str_24876}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return "${__status}"
    fi
    local width_24877="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1981_v0="${width_24877}"
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
    local count_24935="${command_397}"
    parse_int__13_v0 "${count_24935}"
    __status=$?
    ret_stty_count1989_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1990_v0() {
    stty_count__1989_v0 
    local count_num_24936="${ret_stty_count1989_v0}"
    if [ "$(( count_num_24936 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_24936="$(( count_num_24936 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_24936}
    __status=$?
}

# stty_unlock()
stty_unlock__1991_v0() {
    stty_count__1989_v0 
    local count_num_24957="${ret_stty_count1989_v0}"
    if [ "$(( count_num_24957 > 0 ))" != 0 ]; then
        count_num_24957="$(( count_num_24957 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_24957}
        __status=$?
        if [ "$(( count_num_24957 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1992_v0() {
    local size_24859="${1}"
    if [ "$([ "_${size_24859}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1992_v0=0
        return 0
    fi
    split__4_v0 "${size_24859}" " "
    local parts_24860=("${ret_split4_v0[@]}")
    local __length_398=("${parts_24860[@]}")
    if [ "$(( ${#__length_398[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1992_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_24860[1]?"Index out of bounds (at src/./file/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_24860[0]?"Index out of bounds (at src/./file/../utils/term.ab:50:68)"}"
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
    local size_24862="${command_400}"
    store_term_size__1992_v0 "${size_24862}"
    ret_query_term_size1993_v0="${ret_store_term_size1992_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1994_v0() {
    local command_401
    command_401="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_24858="${command_401}"
    store_term_size__1992_v0 "${size_24858}"
    ret_stty_term_size1994_v0="${ret_store_term_size1992_v0}"
    return 0
}

# get_term_size()
get_term_size__1995_v0() {
    stty_term_size__1994_v0 
    local detected_24861="${ret_stty_term_size1994_v0}"
    if [ "$(( ! detected_24861 ))" != 0 ]; then
        query_term_size__1993_v0 
        detected_24861="${ret_query_term_size1993_v0}"
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
    local config_24890="${ret_env_var_get120_v0}"
    _supports_truecolor_88="$(if [ "$([ "_${config_24890}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2008_v0="$([ "_${_supports_truecolor_88}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2009_v0() {
    local message_24885="${1}"
    local r_24886="${2}"
    local g_24887="${3}"
    local b_24888="${4}"
    local fallback_24889="${5}"
    if [ "$([ "_${_supports_truecolor_88}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2009_v0="\\x1b[38;2;${r_24886};${g_24887};${b_24888}m""${message_24885}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_88}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2008_v0 
        local ret_get_supports_truecolor2008_v0__45_17="${ret_get_supports_truecolor2008_v0}"
        if [ "${ret_get_supports_truecolor2008_v0__45_17}" != 0 ]; then
            ret_colored_rgb2009_v0="\\x1b[38;2;${r_24886};${g_24887};${b_24888}m""${message_24885}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_24889 == 0 ))" != 0 ]; then
            ret_colored_rgb2009_v0="${message_24885}"
            return 0
        else
            ret_colored_rgb2009_v0="\\x1b[${fallback_24889}m""${message_24885}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_24889 == 0 ))" != 0 ]; then
            ret_colored_rgb2009_v0="${message_24885}"
            return 0
        fi
        ret_colored_rgb2009_v0="\\x1b[${fallback_24889}m""${message_24885}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2011_v0() {
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_24879="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_24879}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_24879}" ";"
            local parts_24880=("${ret_split4_v0[@]}")
            local __length_405=("${parts_24880[@]}")
            if [ "$(( ${#__length_405[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_24880[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24880[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24880[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24880[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_90=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_24881="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_24881}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_24881}" ";"
            local parts_24882=("${ret_split4_v0[@]}")
            local __length_407=("${parts_24882[@]}")
            if [ "$(( ${#__length_407[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_24882[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24882[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24882[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24882[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_91=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_24883="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_24883}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_24883}" ";"
            local parts_24884=("${ret_split4_v0[@]}")
            local __length_409=("${parts_24884[@]}")
            if [ "$(( ${#__length_409[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_24884[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24884[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24884[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24884[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_92=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
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
    local message_24878="${1}"
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_24878}" "${_primary_color_90[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_90[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_90[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_90[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2013_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2014_v0() {
    local message_24892="${1}"
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_24892}" "${_secondary_color_91[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_91[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_91[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_91[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2014_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2015_v0() {
    local message_25043="${1}"
    if [ "$(( ! _got_xylitol_colors_89 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25043}" "${_accent_color_92[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_92[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_92[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_92[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent2015_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__2031_v0() {
    local format_24929="${1}"
    local args_24930=("${!2}")
    args_24930=("${format_24929}" "${args_24930[@]}")
    __status=$?
    printf "${args_24930[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2032_v0() {
    local message_24927="${1}"
    local color_24928="${2}"
    # Prints an error message with a specified color.
    local array_411=("${message_24927}")
    eprintf__2031_v0 "\\x1b[${color_24928}m%s\\x1b[0m" array_411[@]
}

# colored(message: Text, color: Int)
colored__2033_v0() {
    local message_24921="${1}"
    local color_24922="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2033_v0="\\x1b[${color_24922}m""${message_24921}""\\x1b[0m"
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
    local text_24868="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_413
    command_413="$([[ "${text_24868}" == *$'\x1b'* || "${text_24868}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_24869="${command_413}"
    ret_has_ansi_escape2044_v0="$([ "_${has_escape_24869}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2046_v0() {
    local text_24871="${1}"
    local command_414
    command_414="$(printf "%s" "${text_24871}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2046_v0="${command_414}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2047_v0() {
    local text_24873="${1}"
    local command_415
    command_415="$(printf "%s" "${text_24873}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_24874="${command_415}"
    ret_is_all_ascii2047_v0="$([ "_${result_24874}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2048_v0() {
    local text_24870="${1}"
    strip_ansi__2046_v0 "${text_24870}"
    local stripped_24872="${ret_strip_ansi2046_v0}"
    # Check if text is all ASCII
    is_all_ascii__2047_v0 "${stripped_24872}"
    local ret_is_all_ascii2047_v0__150_12="${ret_is_all_ascii2047_v0}"
    if [ "$(( ! ret_is_all_ascii2047_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1981_v0 "${stripped_24872}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_416="${stripped_24872}"
            ret_get_visible_len2048_v0="${#__length_416}"
            return 0
        fi
        ret_get_visible_len2048_v0="${ret_perl_get_cjk_width1981_v0}"
        return 0
    else
        local __length_417="${stripped_24872}"
        ret_get_visible_len2048_v0="${#__length_417}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2053_v0() {
    local pending_24918="${1}"
    local line_24919="${2}"
    local note_at_24920="${3}"
    if [ "$(( note_at_24920 < 0 ))" != 0 ]; then
        local array_418=()
        printf__128_v0 "${pending_24918}""${line_24919}""
" array_418[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_24920 == 0 ))" != 0 ]; then
        colored__2033_v0 "${line_24919}" 90
        local ret_colored2033_v0__310_40="${ret_colored2033_v0}"
        local array_419=()
        printf__128_v0 "${pending_24918}""${ret_colored2033_v0__310_40}""
" array_419[@]
    else
        slice__24_v0 "${line_24919}" 0 "${note_at_24920}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_24919}" "${note_at_24920}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__2033_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored2033_v0__311_58="${ret_colored2033_v0}"
        local array_420=()
        printf__128_v0 "${pending_24918}""${ret_slice24_v0__311_32}""${ret_colored2033_v0__311_58}""
" array_420[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2054_v0() {
    local names_24896=("${!1}")
    local texts_24897=("${!2}")
    local notes_24898=("${!3}")
    local min_name_width_24899="${4}"
    local __length_421=("${names_24896[@]}")
    local count_24900="${#__length_421[@]}"
    local name_width_24901="${min_name_width_24899}"
    local __range_start_24902=0
    local __range_end_24902="${count_24900}"
    local __dir_24902=$(( ${__range_start_24902} <= ${__range_end_24902} ? 1 : -1 ))
    for (( i_24902=${__range_start_24902}; i_24902 * ${__dir_24902} < ${__range_end_24902} * ${__dir_24902}; i_24902+=${__dir_24902} )); do
        local __length_422="${names_24896[${i_24902}]?"Index out of bounds (at src/./file/../utils.ab:326:33)"}"
        local width_24903="${#__length_422}"
        if [ "$(( width_24903 > name_width_24901 ))" != 0 ]; then
            name_width_24901="${width_24903}"
        fi
done
    term_width__1997_v0 
    local width_24904="${ret_term_width1997_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_24905="$(( name_width_24901 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_24906="$(( $(( width_24904 - indent_24905 )) < 24 ))"
    if [ "${stacked_24906}" != 0 ]; then
        indent_24905=6
    fi
    local avail_24907="$(( width_24904 - indent_24905 ))"
    rpad__28_v0 "" " " "${indent_24905}"
    local blank_24908="${ret_rpad28_v0}"
    local __range_start_24909=0
    local __range_end_24909="${count_24900}"
    local __dir_24909=$(( ${__range_start_24909} <= ${__range_end_24909} ? 1 : -1 ))
    for (( i_24909=${__range_start_24909}; i_24909 * ${__dir_24909} < ${__range_end_24909} * ${__dir_24909}; i_24909+=${__dir_24909} )); do
        local pending_24910="${blank_24908}"
        if [ "${stacked_24906}" != 0 ]; then
            local array_423=()
            printf__128_v0 "  ""${names_24896[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:346:33)"}""
" array_423[@]
        else
            rpad__28_v0 "  ""${names_24896[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:348:41)"}" " " "${indent_24905}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_24910="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_24897[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_24911=("${ret_split4_v0__350_21[@]}")
        local __length_424=("${words_24911[@]}")
        local note_start_24912="${#__length_424[@]}"
        if [ "$([ "_${notes_24898[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_425="${notes_24898[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_425} > avail_24907 ))" != 0 ]; then
                split__4_v0 "${notes_24898[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_24911+=("${ret_split4_v0__356_26[@]}")
            else
                local array_426=("${notes_24898[${i_24909}]?"Index out of bounds (at src/./file/../utils.ab:358:33)"}")
                words_24911+=("${array_426[@]}")
            fi
        fi
        local line_24913=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_24914=-1
        local __range_start_24915=0
        local __length_427=("${words_24911[@]}")
        local __range_end_24915="${#__length_427[@]}"
        local __dir_24915=$(( ${__range_start_24915} <= ${__range_end_24915} ? 1 : -1 ))
        for (( j_24915=${__range_start_24915}; j_24915 * ${__dir_24915} < ${__range_end_24915} * ${__dir_24915}; j_24915+=${__dir_24915} )); do
            local word_24916="${words_24911[${j_24915}]?"Index out of bounds (at src/./file/../utils.ab:368:32)"}"
            local candidate_24917
            candidate_24917="$(if [ "$([ "_${line_24913}" != "_" ]; echo $?)" != 0 ]; then echo "${word_24916}"; else echo "${line_24913}"" ""${word_24916}"; fi)"
            local __length_428="${candidate_24917}"
            if [ "$(( $(( ${#__length_428} > avail_24907 )) && $([ "_${line_24913}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2053_v0 "${pending_24910}" "${line_24913}" "${note_at_24914}"
                pending_24910="${blank_24908}"
                line_24913="${word_24916}"
                note_at_24914="$(if [ "$(( j_24915 >= note_start_24912 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_24915 >= note_start_24912 )) && $(( note_at_24914 < 0 )) ))" != 0 ]; then
                    local __length_429="${candidate_24917}"
                    local __length_430="${word_24916}"
                    note_at_24914="$(( ${#__length_429} - ${#__length_430} ))"
                fi
                line_24913="${candidate_24917}"
            fi
done
        print_help_line__2053_v0 "${pending_24910}" "${line_24913}" "${note_at_24914}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__2055_v0() {
    local pieces_24857=("${!1}")
    term_width__1997_v0 
    local width_24863="${ret_term_width1997_v0}"
    local line_24864=""
    local line_len_24865=0
    for piece_24866 in "${pieces_24857[@]}"; do
        local __length_433="${piece_24866}"
        local piece_len_24867="${#__length_433}"
        has_ansi_escape__2044_v0 "${piece_24866}"
        local ret_has_ansi_escape2044_v0__397_12="${ret_has_ansi_escape2044_v0}"
        if [ "${ret_has_ansi_escape2044_v0__397_12}" != 0 ]; then
            get_visible_len__2048_v0 "${piece_24866}"
            piece_len_24867="${ret_get_visible_len2048_v0}"
        fi
        if [ "$([ "_${line_24864}" != "_" ]; echo $?)" != 0 ]; then
            line_24864="${piece_24866}"
            line_len_24865="${piece_len_24867}"
        elif [ "$(( $(( $(( line_len_24865 + 1 )) + piece_len_24867 )) > width_24863 ))" != 0 ]; then
            local array_434=()
            printf__128_v0 "${line_24864}""
" array_434[@]
            line_24864="${piece_24866}"
            line_len_24865="${piece_len_24867}"
        else
            line_24864+=" ""${piece_24866}"
            line_len_24865="$(( line_len_24865 + $(( 1 + piece_len_24867 )) ))"
        fi
    done
    if [ "$([ "_${line_24864}" == "_" ]; echo $?)" != 0 ]; then
        local array_435=()
        printf__128_v0 "${line_24864}""
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
    local text_24983="${1}"
    if [ "$(( ! _perl_available_97 ))" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return 1
    fi
    local command_438
    command_438="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_24983}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return "${__status}"
    fi
    local width_str_24984="${command_438}"
    parse_int__13_v0 "${width_str_24984}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return "${__status}"
    fi
    local width_24985="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2206_v0="${width_24985}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2207_v0() {
    local text_24994="${1}"
    local max_width_24995="${2}"
    if [ "$(( ! _perl_available_97 ))" != 0 ]; then
        ret_perl_truncate_cjk2207_v0=''
        return 1
    fi
    local command_439
    command_439="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_24994}" ${max_width_24995} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2207_v0=''
        return "${__status}"
    fi
    local result_24996="${command_439}"
    ret_perl_truncate_cjk2207_v0="${result_24996}"
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
    local count_24965="${command_441}"
    parse_int__13_v0 "${count_24965}"
    __status=$?
    ret_stty_count2214_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2215_v0() {
    stty_count__2214_v0 
    local count_num_24966="${ret_stty_count2214_v0}"
    if [ "$(( count_num_24966 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_24966="$(( count_num_24966 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_24966}
    __status=$?
}

# stty_unlock()
stty_unlock__2216_v0() {
    stty_count__2214_v0 
    local count_num_25100="${ret_stty_count2214_v0}"
    if [ "$(( count_num_25100 > 0 ))" != 0 ]; then
        count_num_25100="$(( count_num_25100 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25100}
        __status=$?
        if [ "$(( count_num_25100 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2217_v0() {
    local size_24970="${1}"
    if [ "$([ "_${size_24970}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2217_v0=0
        return 0
    fi
    split__4_v0 "${size_24970}" " "
    local parts_24971=("${ret_split4_v0[@]}")
    local __length_442=("${parts_24971[@]}")
    if [ "$(( ${#__length_442[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_24971[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_24971[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:68)"}"
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
    local size_24973="${command_444}"
    store_term_size__2217_v0 "${size_24973}"
    ret_query_term_size2218_v0="${ret_store_term_size2217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2219_v0() {
    local command_445
    command_445="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_24969="${command_445}"
    store_term_size__2217_v0 "${size_24969}"
    ret_stty_term_size2219_v0="${ret_store_term_size2217_v0}"
    return 0
}

# get_term_size()
get_term_size__2220_v0() {
    stty_term_size__2219_v0 
    local detected_24972="${ret_stty_term_size2219_v0}"
    if [ "$(( ! detected_24972 ))" != 0 ]; then
        query_term_size__2218_v0 
        detected_24972="${ret_query_term_size2218_v0}"
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
    local config_25064="${ret_env_var_get120_v0}"
    _supports_truecolor_100="$(if [ "$([ "_${config_25064}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2233_v0="$([ "_${_supports_truecolor_100}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2234_v0() {
    local message_25059="${1}"
    local r_25060="${2}"
    local g_25061="${3}"
    local b_25062="${4}"
    local fallback_25063="${5}"
    if [ "$([ "_${_supports_truecolor_100}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2234_v0="\\x1b[38;2;${r_25060};${g_25061};${b_25062}m""${message_25059}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_100}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2233_v0 
        local ret_get_supports_truecolor2233_v0__45_17="${ret_get_supports_truecolor2233_v0}"
        if [ "${ret_get_supports_truecolor2233_v0__45_17}" != 0 ]; then
            ret_colored_rgb2234_v0="\\x1b[38;2;${r_25060};${g_25061};${b_25062}m""${message_25059}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_25063 == 0 ))" != 0 ]; then
            ret_colored_rgb2234_v0="${message_25059}"
            return 0
        else
            ret_colored_rgb2234_v0="\\x1b[${fallback_25063}m""${message_25059}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_25063 == 0 ))" != 0 ]; then
            ret_colored_rgb2234_v0="${message_25059}"
            return 0
        fi
        ret_colored_rgb2234_v0="\\x1b[${fallback_25063}m""${message_25059}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2236_v0() {
    if [ "$(( ! _got_xylitol_colors_101 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_25053="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_25053}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_25053}" ";"
            local parts_25054=("${ret_split4_v0[@]}")
            local __length_449=("${parts_25054[@]}")
            if [ "$(( ${#__length_449[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25054[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25054[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25054[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25054[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_25055="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_25055}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_25055}" ";"
            local parts_25056=("${ret_split4_v0[@]}")
            local __length_451=("${parts_25056[@]}")
            if [ "$(( ${#__length_451[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25056[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25056[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25056[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25056[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_103=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_25057="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_25057}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_25057}" ";"
            local parts_25058=("${ret_split4_v0[@]}")
            local __length_453=("${parts_25058[@]}")
            if [ "$(( ${#__length_453[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25058[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25058[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25058[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25058[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
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
    local message_25052="${1}"
    if [ "$(( ! _got_xylitol_colors_101 ))" != 0 ]; then
        get_xylitol_colors__2237_v0 
    fi
    colored_rgb__2234_v0 "${message_25052}" "${_secondary_color_103[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_103[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_103[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_103[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2239_v0="${ret_colored_rgb2234_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2254_v0() {
    local command_455
    command_455="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_25077="${command_455}"
    if [ "$([ "_${var_25077}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="UP"
        return 0
    elif [ "$([ "_${var_25077}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="DOWN"
        return 0
    elif [ "$([ "_${var_25077}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_25077}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="LEFT"
        return 0
    elif [ "$([ "_${var_25077}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_25077}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="INPUT"
        return 0
    else
        ret_get_key2254_v0="${var_25077}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2256_v0() {
    local format_24967="${1}"
    local args_24968=("${!2}")
    args_24968=("${format_24967}" "${args_24968[@]}")
    __status=$?
    printf "${args_24968[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2257_v0() {
    local message_25015="${1}"
    local color_25016="${2}"
    # Prints an error message with a specified color.
    local array_456=("${message_25015}")
    eprintf__2256_v0 "\\x1b[${color_25016}m%s\\x1b[0m" array_456[@]
}

# colored(message: Text, color: Int)
colored__2258_v0() {
    local message_25023="${1}"
    local color_25024="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2258_v0="\\x1b[${color_25024}m""${message_25023}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2260_v0() {
    local cnt_25074="${1}"
    if [ "$(( cnt_25074 > 0 ))" != 0 ]; then
        local sequence_25075=""
        local __range_start_25076=0
        local __range_end_25076="${cnt_25074}"
        local __dir_25076=$(( ${__range_start_25076} <= ${__range_end_25076} ? 1 : -1 ))
        for (( ____25076=${__range_start_25076}; ____25076 * ${__dir_25076} < ${__range_end_25076} * ${__dir_25076}; ____25076+=${__dir_25076} )); do
            sequence_25075+="\\x1b[2K\\x1b[1A"
done
        local array_457=("")
        eprintf__2256_v0 "${sequence_25075}" array_457[@]
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
    local cnt_25065="${1}"
    printf '%*s' "${cnt_25065}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2263_v0() {
    local cnt_25013="${1}"
    local __range_start_25014=0
    local __range_end_25014="${cnt_25013}"
    local __dir_25014=$(( ${__range_start_25014} <= ${__range_end_25014} ? 1 : -1 ))
    for (( ____25014=${__range_start_25014}; ____25014 * ${__dir_25014} < ${__range_end_25014} * ${__dir_25014}; ____25014+=${__dir_25014} )); do
        local array_460=("")
        eprintf__2256_v0 "
" array_460[@]
done
}

# go_up(cnt: Int)
go_up__2264_v0() {
    local cnt_25032="${1}"
    local array_461=("")
    eprintf__2256_v0 "\\x1b[${cnt_25032}A" array_461[@]
}

# go_down(cnt: Int)
go_down__2265_v0() {
    local cnt_25086="${1}"
    local array_462=("")
    eprintf__2256_v0 "\\x1b[${cnt_25086}B" array_462[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2266_v0() {
    local cnt_25095="${1}"
    if [ "$(( cnt_25095 > 0 ))" != 0 ]; then
        go_down__2265_v0 "${cnt_25095}"
    else
        go_up__2264_v0 "$(( - cnt_25095 ))"
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
    local text_24989="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_465
    command_465="$([[ "${text_24989}" == *$'\x1b'* || "${text_24989}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_24990="${command_465}"
    ret_has_ansi_escape2269_v0="$([ "_${has_escape_24990}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2271_v0() {
    local text_24979="${1}"
    local command_466
    command_466="$(printf "%s" "${text_24979}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2271_v0="${command_466}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2272_v0() {
    local text_24981="${1}"
    local command_467
    command_467="$(printf "%s" "${text_24981}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_24982="${command_467}"
    ret_is_all_ascii2272_v0="$([ "_${result_24982}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2273_v0() {
    local text_24978="${1}"
    strip_ansi__2271_v0 "${text_24978}"
    local stripped_24980="${ret_strip_ansi2271_v0}"
    # Check if text is all ASCII
    is_all_ascii__2272_v0 "${stripped_24980}"
    local ret_is_all_ascii2272_v0__150_12="${ret_is_all_ascii2272_v0}"
    if [ "$(( ! ret_is_all_ascii2272_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2206_v0 "${stripped_24980}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_468="${stripped_24980}"
            ret_get_visible_len2273_v0="${#__length_468}"
            return 0
        fi
        ret_get_visible_len2273_v0="${ret_perl_get_cjk_width2206_v0}"
        return 0
    else
        local __length_469="${stripped_24980}"
        ret_get_visible_len2273_v0="${#__length_469}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2274_v0() {
    local text_24991="${1}"
    local max_width_24992="${2}"
    get_visible_len__2273_v0 "${text_24991}"
    local visible_len_24993="${ret_get_visible_len2273_v0}"
    if [ "$(( visible_len_24993 <= max_width_24992 ))" != 0 ]; then
        ret_truncate_text2274_v0="${text_24991}"
        return 0
    fi
    is_all_ascii__2272_v0 "${text_24991}"
    local ret_is_all_ascii2272_v0__167_12="${ret_is_all_ascii2272_v0}"
    if [ "$(( ! ret_is_all_ascii2272_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2207_v0 "${text_24991}" "${max_width_24992}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_24991}" | cut -c1-${max_width_24992}
            __status=$?
        fi
        ret_truncate_text2274_v0="${ret_perl_truncate_cjk2207_v0}"
        return 0
    fi
    local command_470
    command_470="$(printf "%s" "${text_24991}" | cut -c1-${max_width_24992})"
    __status=$?
    ret_truncate_text2274_v0="${command_470}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2275_v0() {
    local text_24987="${1}"
    local max_width_24988="${2}"
    has_ansi_escape__2269_v0 "${text_24987}"
    local ret_has_ansi_escape2269_v0__179_12="${ret_has_ansi_escape2269_v0}"
    if [ "$(( ! ret_has_ansi_escape2269_v0__179_12 ))" != 0 ]; then
        truncate_text__2274_v0 "${text_24987}" "${max_width_24988}"
        ret_truncate_ansi2275_v0="${ret_truncate_text2274_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_471
    command_471="$([[ "${text_24987}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_24997="${command_471}"
    # Replace \x1b[ with newline, then split
    local command_472
    command_472="$(t="${text_24987}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_24998="${command_472}"
    split__4_v0 "${replaced_24998}" "
"
    local parts_24999=("${ret_split4_v0[@]}")
    local result_25000=""
    local remaining_width_25001="${max_width_24988}"
    local __range_start_25002=0
    local __length_473=("${parts_24999[@]}")
    local __range_end_25002="${#__length_473[@]}"
    local __dir_25002=$(( ${__range_start_25002} <= ${__range_end_25002} ? 1 : -1 ))
    for (( idx_25002=${__range_start_25002}; idx_25002 * ${__dir_25002} < ${__range_end_25002} * ${__dir_25002}; idx_25002+=${__dir_25002} )); do
        local part_25003="${parts_24999[${idx_25002}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_25002 == 0 )) && $([ "_${starts_with_ansi_24997}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_25003}" == "_" ]; echo $?) && $(( remaining_width_25001 > 0 )) ))" != 0 ]; then
                truncate_text__2274_v0 "${part_25003}" "${remaining_width_25001}"
                local ret_truncate_text2274_v0__201_35="${ret_truncate_text2274_v0}"
                local truncated_25004="${ret_truncate_text2274_v0__201_35}"
                result_25000+="${truncated_25004}"
                get_visible_len__2273_v0 "${truncated_25004}"
                local ret_get_visible_len2273_v0__203_36="${ret_get_visible_len2273_v0}"
                remaining_width_25001="$(( remaining_width_25001 - ret_get_visible_len2273_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_474
            command_474="$(__p="${part_25003}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_25005="${command_474}"
            if [ "$([ "_${m_idx_25005}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_475
                command_475="$(__p="${part_25003}"; printf "%s" "${__p:0:${m_idx_25005}}")"
                __status=$?
                local ansi_params_25006="${command_475}"
                result_25000+="\\x1b[""${ansi_params_25006}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_25005}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_25007="${ret_parse_int13_v0__214_41}"
                local text_start_25008="$(( m_idx_num_25007 + 1 ))"
                local command_476
                command_476="$(__p="${part_25003}"; printf "%s" "${__p:${text_start_25008}}")"
                __status=$?
                local text_part_25009="${command_476}"
                if [ "$(( $([ "_${text_part_25009}" == "_" ]; echo $?) && $(( remaining_width_25001 > 0 )) ))" != 0 ]; then
                    truncate_text__2274_v0 "${text_part_25009}" "${remaining_width_25001}"
                    local ret_truncate_text2274_v0__218_39="${ret_truncate_text2274_v0}"
                    local truncated_25010="${ret_truncate_text2274_v0__218_39}"
                    result_25000+="${truncated_25010}"
                    get_visible_len__2273_v0 "${truncated_25010}"
                    local ret_get_visible_len2273_v0__220_40="${ret_get_visible_len2273_v0}"
                    remaining_width_25001="$(( remaining_width_25001 - ret_get_visible_len2273_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_25003}" == "_" ]; echo $?) && $(( remaining_width_25001 > 0 )) ))" != 0 ]; then
                    truncate_text__2274_v0 "${part_25003}" "${remaining_width_25001}"
                    local ret_truncate_text2274_v0__225_39="${ret_truncate_text2274_v0}"
                    local truncated_25011="${ret_truncate_text2274_v0__225_39}"
                    result_25000+="${truncated_25011}"
                    get_visible_len__2273_v0 "${truncated_25011}"
                    local ret_get_visible_len2273_v0__227_40="${ret_get_visible_len2273_v0}"
                    remaining_width_25001="$(( remaining_width_25001 - ret_get_visible_len2273_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2275_v0="${result_25000}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2276_v0() {
    local text_24976="${1}"
    local max_width_24977="${2}"
    get_visible_len__2273_v0 "${text_24976}"
    local visible_len_24986="${ret_get_visible_len2273_v0}"
    if [ "$(( visible_len_24986 <= max_width_24977 ))" != 0 ]; then
        ret_cutoff_text2276_v0="${text_24976}"
        return 0
    fi
    truncate_ansi__2275_v0 "${text_24976}" "$(( max_width_24977 - 3 ))"
    local ret_truncate_ansi2275_v0__243_12="${ret_truncate_ansi2275_v0}"
    ret_cutoff_text2276_v0="${ret_truncate_ansi2275_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2277_v0() {
    local items_25017=("${!1}")
    local total_len_25018="${2}"
    local term_width_25019="${3}"
    local separator_25020=" • "
    local separator_len_25021=3
    # Fast path: no truncation needed
    if [ "$(( total_len_25018 <= term_width_25019 ))" != 0 ]; then
        local iter_25022=0
        while :
        do
            local __length_477=("${items_25017[@]}")
            if [ "$(( iter_25022 >= ${#__length_477[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_25022 > 0 ))" != 0 ]; then
                eprintf_colored__2257_v0 "${separator_25020}" 90
            fi
            colored__2258_v0 "${items_25017[$(( iter_25022 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2258_v0__268_41="${ret_colored2258_v0}"
            local array_478=("")
            eprintf__2256_v0 "${items_25017[${iter_25022}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2258_v0__268_41}" array_478[@]
            iter_25022="$(( iter_25022 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_25025=0
        local first_25026=1
        local iter_25027=0
        while :
        do
            local __length_479=("${items_25017[@]}")
            if [ "$(( iter_25027 >= ${#__length_479[@]} ))" != 0 ]; then
                break
            fi
            local key_25028="${items_25017[${iter_25027}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_25029="${items_25017[$(( iter_25027 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_480="${key_25028}"
            local __length_481="${action_25029}"
            local part_len_25030="$(( $(( ${#__length_480} + 1 )) + ${#__length_481} ))"
            local needed_25031="${part_len_25030}"
            if [ "$(( ! first_25026 ))" != 0 ]; then
                needed_25031="$(( needed_25031 + separator_len_25021 ))"
            fi
            if [ "$(( $(( current_len_25025 + needed_25031 )) > term_width_25019 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_25026 ))" != 0 ]; then
                eprintf_colored__2257_v0 "${separator_25020}" 90
            fi
            colored__2258_v0 "${action_25029}" 2
            local ret_colored2258_v0__296_33="${ret_colored2258_v0}"
            local array_482=("")
            eprintf__2256_v0 "${key_25028}"" ""${ret_colored2258_v0__296_33}" array_482[@]
            current_len_25025="$(( current_len_25025 + needed_25031 ))"
            first_25026=0
            iter_25027="$(( iter_25027 + 2 ))"
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
    local cursor_len_25068="${#__length_485}"
    local max_option_width_25069="$(( $(( _term_width_118 - cursor_len_25068 )) - 1 ))"
    local __range_start_25070=0
    local __range_end_25070="${_page_count_121}"
    local __dir_25070=$(( ${__range_start_25070} <= ${__range_end_25070} ? 1 : -1 ))
    for (( i_25070=${__range_start_25070}; i_25070 * ${__dir_25070} < ${__range_end_25070} * ${__dir_25070}; i_25070+=${__dir_25070} )); do
        cutoff_text__2276_v0 "${_page_120[${i_25070}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_25069}"
        local ret_cutoff_text2276_v0__48_27="${ret_cutoff_text2276_v0}"
        local truncated_25071="${ret_cutoff_text2276_v0__48_27}"
        if [ "$(( i_25070 == _selected_114 ))" != 0 ]; then
            colored_secondary__2239_v0 "${_cursor_115}""${truncated_25071}""
"
            local ret_colored_secondary2239_v0__50_21="${ret_colored_secondary2239_v0}"
            local array_486=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__50_21}" array_486[@]
        else
            print_blank__2262_v0 "${cursor_len_25068}"
            local array_487=("")
            eprintf__2256_v0 "${truncated_25071}""
" array_487[@]
        fi
done
    local remaining_slots_25072="$(( _display_count_111 - _page_count_121 ))"
    if [ "$(( remaining_slots_25072 > 0 ))" != 0 ]; then
        local __range_start_25073=0
        local __range_end_25073="${remaining_slots_25072}"
        local __dir_25073=$(( ${__range_start_25073} <= ${__range_end_25073} ? 1 : -1 ))
        for (( ____25073=${__range_start_25073}; ____25073 * ${__dir_25073} < ${__range_end_25073} * ${__dir_25073}; ____25073+=${__dir_25073} )); do
            local array_488=("")
            eprintf__2256_v0 "\\x1b[K
" array_488[@]
done
    fi
}

# render_multi_page()
render_multi_page__2332_v0() {
    local __length_489="${_cursor_115}"
    local cursor_len_25045="${#__length_489}"
    local max_option_width_25046="$(( $(( _term_width_118 - cursor_len_25045 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2337_v0 
    local page_start_25047="${ret_chooser_page_start2337_v0}"
    local __range_start_25048=0
    local __range_end_25048="${_page_count_121}"
    local __dir_25048=$(( ${__range_start_25048} <= ${__range_end_25048} ? 1 : -1 ))
    for (( i_25048=${__range_start_25048}; i_25048 * ${__dir_25048} < ${__range_end_25048} * ${__dir_25048}; i_25048+=${__dir_25048} )); do
        local global_idx_25049="$(( page_start_25047 + i_25048 ))"
        local check_mark_25050
        check_mark_25050="$(if [ "${_checked_122[${global_idx_25049}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2276_v0 "${_page_120[${i_25048}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_25046}"
        local ret_cutoff_text2276_v0__71_27="${ret_cutoff_text2276_v0}"
        local truncated_25051="${ret_cutoff_text2276_v0__71_27}"
        if [ "$(( i_25048 == _selected_114 ))" != 0 ]; then
            colored_secondary__2239_v0 "${_cursor_115}""${check_mark_25050}""${truncated_25051}""
"
            local ret_colored_secondary2239_v0__73_37="${ret_colored_secondary2239_v0}"
            local array_490=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__73_37}" array_490[@]
        elif [ "${_checked_122[${global_idx_25049}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2262_v0 "${cursor_len_25045}"
            colored_secondary__2239_v0 "${check_mark_25050}""${truncated_25051}""
"
            local ret_colored_secondary2239_v0__76_25="${ret_colored_secondary2239_v0}"
            local array_491=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__76_25}" array_491[@]
        else
            print_blank__2262_v0 "${cursor_len_25045}"
            local array_492=("")
            eprintf__2256_v0 "${check_mark_25050}""${truncated_25051}""
" array_492[@]
        fi
done
    local remaining_slots_25066="$(( _display_count_111 - _page_count_121 ))"
    if [ "$(( remaining_slots_25066 > 0 ))" != 0 ]; then
        local __range_start_25067=0
        local __range_end_25067="${remaining_slots_25066}"
        local __dir_25067=$(( ${__range_start_25067} <= ${__range_end_25067} ? 1 : -1 ))
        for (( ____25067=${__range_start_25067}; ____25067 * ${__dir_25067} < ${__range_end_25067} * ${__dir_25067}; ____25067+=${__dir_25067} )); do
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
    local total_24959="${1}"
    local page_size_24960="${2}"
    local header_24961="${3}"
    local cursor_24962="${4}"
    local multi_24963="${5}"
    local limit_24964="${6}"
    _total_109="${total_24959}"
    _cursor_115="${cursor_24962}"
    _multi_116="${multi_24963}"
    _limit_117="${limit_24964}"
    _current_page_113=0
    _selected_114=0
    _first_render_124=1
    _up_paged_125=0
    _checked_count_123=0
    _has_header_119="$([ "_${header_24961}" == "_" ]; echo $?)"
    stty_lock__2215_v0 
    hide_cursor__2267_v0 
    term_width__2222_v0 
    _term_width_118="${ret_term_width2222_v0}"
    term_height__2223_v0 
    local term_height_24974="${ret_term_height2223_v0}"
    local max_page_size_24975
    max_page_size_24975="$(( term_height_24974 - $(if [ "${_has_header_119}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_110="${page_size_24960}"
    if [ "$(( _page_size_110 > max_page_size_24975 ))" != 0 ]; then
        _page_size_110="${max_page_size_24975}"
    fi
    if [ "${_has_header_119}" != 0 ]; then
        cutoff_text__2276_v0 "${header_24961}" "${_term_width_118}"
        local ret_cutoff_text2276_v0__157_17="${ret_cutoff_text2276_v0}"
        local array_502=("")
        eprintf__2256_v0 "${ret_cutoff_text2276_v0__157_17}""
" array_502[@]
    fi
    math_floor__509_v0 "$(( $(( $(( total_24959 + _page_size_110 )) - 1 )) / _page_size_110 ))"
    _total_pages_112="${ret_math_floor509_v0}"
    _display_count_111="${_page_size_110}"
    if [ "$(( total_24959 < _page_size_110 ))" != 0 ]; then
        _display_count_111="${total_24959}"
    fi
    if [ "${multi_24963}" != 0 ]; then
        _checked_122=()
        local __range_start_25012=0
        local __range_end_25012="${total_24959}"
        local __dir_25012=$(( ${__range_start_25012} <= ${__range_end_25012} ? 1 : -1 ))
        for (( ____25012=${__range_start_25012}; ____25012 * ${__dir_25012} < ${__range_end_25012} * ${__dir_25012}; ____25012+=${__dir_25012} )); do
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
    local start_25036="${ret_chooser_page_start2337_v0}"
    local end_25037="$(( start_25036 + _page_size_110 ))"
    if [ "$(( end_25037 > _total_109 ))" != 0 ]; then
        end_25037="${_total_109}"
    fi
    ret_chooser_page_count2338_v0="$(( end_25037 - start_25036 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2339_v0() {
    local page_25044=("${!1}")
    _page_120=("${page_25044[@]}")
    local __length_507=("${page_25044[@]}")
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
    local prev_selected_25089="${1}"
    chooser_page_start__2337_v0 
    local page_start_25090="${ret_chooser_page_start2337_v0}"
    local check_width_25091
    check_width_25091="$(if [ "${_multi_116}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_509="${_cursor_115}"
    local max_option_width_25092="$(( $(( _term_width_118 - ${#__length_509} )) - check_width_25091 ))"
    go_up__2264_v0 "$(( _display_count_111 - prev_selected_25089 ))"
    local array_510=("")
    eprintf__2256_v0 "\\x1b[K" array_510[@]
    local __length_511="${_cursor_115}"
    print_blank__2262_v0 "${#__length_511}"
    if [ "${_multi_116}" != 0 ]; then
        local was_checked_25093="${_checked_122[$(( page_start_25090 + prev_selected_25089 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2276_v0 "${_page_120[${prev_selected_25089}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_25092}"
        local ret_cutoff_text2276_v0__232_63="${ret_cutoff_text2276_v0}"
        local prev_line_25094
        prev_line_25094="$(if [ "${was_checked_25093}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2276_v0__232_63}"
        if [ "${was_checked_25093}" != 0 ]; then
            colored_secondary__2239_v0 "${prev_line_25094}"
            local ret_colored_secondary2239_v0__234_21="${ret_colored_secondary2239_v0}"
            local array_512=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__234_21}" array_512[@]
        else
            local array_513=("")
            eprintf__2256_v0 "${prev_line_25094}" array_513[@]
        fi
    else
        cutoff_text__2276_v0 "${_page_120[${prev_selected_25089}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_25092}"
        local ret_cutoff_text2276_v0__239_17="${ret_cutoff_text2276_v0}"
        local array_514=("")
        eprintf__2256_v0 "${ret_cutoff_text2276_v0__239_17}" array_514[@]
    fi
    go_up_or_down__2266_v0 "$(( _selected_114 - prev_selected_25089 ))"
    local array_515=("")
    eprintf__2256_v0 "\\x1b[G" array_515[@]
    local array_516=("")
    eprintf__2256_v0 "\\x1b[K" array_516[@]
    local mark_25096
    mark_25096="$(if [ "${_multi_116}" != 0 ]; then echo "$(if [ "${_checked_122[$(( page_start_25090 + _selected_114 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2276_v0 "${_page_120[${_selected_114}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_25092}"
    local ret_cutoff_text2276_v0__246_48="${ret_cutoff_text2276_v0}"
    colored_secondary__2239_v0 "${_cursor_115}""${mark_25096}""${ret_cutoff_text2276_v0__246_48}"
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
    local page_start_25083="${ret_chooser_page_start2337_v0}"
    local __length_519="${_cursor_115}"
    local max_option_width_25084="$(( $(( _term_width_118 - ${#__length_519} )) - 3 ))"
    go_up__2264_v0 "$(( _display_count_111 - _selected_114 ))"
    local array_520=("")
    eprintf__2256_v0 "\\x1b[G" array_520[@]
    local array_521=("")
    eprintf__2256_v0 "\\x1b[K" array_521[@]
    local check_mark_25085
    check_mark_25085="$(if [ "${_checked_122[$(( page_start_25083 + _selected_114 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2276_v0 "${_page_120[${_selected_114}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_25084}"
    local ret_cutoff_text2276_v0__260_54="${ret_cutoff_text2276_v0}"
    colored_secondary__2239_v0 "${_cursor_115}""${check_mark_25085}""${ret_cutoff_text2276_v0__260_54}"
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
    local key_25078="${ret_get_key2254_v0}"
    local prev_selected_25079="${_selected_114}"
    local prev_page_25080="${_current_page_113}"
    chooser_page_start__2337_v0 
    local page_start_25081="${ret_chooser_page_start2337_v0}"
    _up_paged_125=0
    if [ "$(( $([ "_${key_25078}" != "_UP" ]; echo $?) || $([ "_${key_25078}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_25078}" != "_DOWN" ]; echo $?) || $([ "_${key_25078}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_25078}" != "_LEFT" ]; echo $?) || $([ "_${key_25078}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_113 > 0 ))" != 0 ]; then
            _current_page_113="$(( _current_page_113 - 1 ))"
        fi
        _selected_114=0
    elif [ "$(( $([ "_${key_25078}" != "_RIGHT" ]; echo $?) || $([ "_${key_25078}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_113 < $(( _total_pages_112 - 1 )) ))" != 0 ]; then
            _current_page_113="$(( _current_page_113 + 1 ))"
            _selected_114=0
        else
            _selected_114="$(( _page_count_121 - 1 ))"
        fi
    elif [ "$(( _multi_116 && $(( $([ "_${key_25078}" != "_x" ]; echo $?) || $([ "_${key_25078}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_25082="$(( page_start_25081 + _selected_114 ))"
        if [ "${_checked_122[${global_selected_25082}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_122["${global_selected_25082}"]=0
            _checked_count_123="$(( _checked_count_123 - 1 ))"
        elif [ "$(( $(( _limit_117 < 0 )) || $(( _checked_count_123 < _limit_117 )) ))" != 0 ]; then
            _checked_122["${global_selected_25082}"]=1
            _checked_count_123="$(( _checked_count_123 + 1 ))"
        else
            ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
            return 0
        fi
        redraw_current_line__2341_v0 
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
        return 0
    elif [ "$(( $(( _multi_116 && $(( $([ "_${key_25078}" != "_a" ]; echo $?) || $([ "_${key_25078}" != "_A" ]; echo $?) )) )) && $(( _limit_117 < 0 )) ))" != 0 ]; then
        local all_checked_25087="$(( _checked_count_123 == _total_109 ))"
        local __range_start_25088=0
        local __range_end_25088="${_total_109}"
        local __dir_25088=$(( ${__range_start_25088} <= ${__range_end_25088} ? 1 : -1 ))
        for (( i_25088=${__range_start_25088}; i_25088 * ${__dir_25088} < ${__range_end_25088} * ${__dir_25088}; i_25088+=${__dir_25088} )); do
            _checked_122["${i_25088}"]="$(( ! all_checked_25087 ))"
done
        _checked_count_123="$(if [ "${all_checked_25087}" != 0 ]; then echo 0; else echo "${_total_109}"; fi)"
        go_up__2264_v0 "${_display_count_111}"
        local array_524=("")
        eprintf__2256_v0 "\\x1b[G" array_524[@]
        render_page__2333_v0 
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
        return 0
    elif [ "$([ "_${key_25078}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2342_v0="${__CHOOSER_DONE_108}"
        return 0
    else
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_106}"
        return 0
    fi
    if [ "$(( prev_page_25080 != _current_page_113 ))" != 0 ]; then
        ret_chooser_step2342_v0="${__CHOOSER_NEED_PAGE_107}"
        return 0
    fi
    if [ "$(( prev_selected_25079 != _selected_114 ))" != 0 ]; then
        redraw_selection__2340_v0 "${prev_selected_25079}"
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
    local total_lines_25099="$(( _display_count_111 + 2 ))"
    if [ "${_has_header_119}" != 0 ]; then
        total_lines_25099="$(( total_lines_25099 + 1 ))"
    fi
    go_down__2265_v0 1
    remove_line__2260_v0 "$(( total_lines_25099 - 1 ))"
    remove_current_line__2261_v0 
    stty_unlock__2216_v0 
    show_cursor__2268_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2354_v0() {
    local name_25040="${1}"
    local file_type_25041="${2}"
    local target_25042="${3}"
    if [ "$([ "_${file_type_25041}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2013_v0 "/"
        local ret_colored_primary2013_v0__10_23="${ret_colored_primary2013_v0}"
        ret_format_entry_display2354_v0="${name_25040}""${ret_colored_primary2013_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_25041}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2015_v0 " > "
        local ret_colored_accent2015_v0__13_23="${ret_colored_accent2015_v0}"
        colored_primary__2013_v0 "${target_25042}"
        local ret_colored_primary2013_v0__13_47="${ret_colored_primary2013_v0}"
        ret_format_entry_display2354_v0="${name_25040}""${ret_colored_accent2015_v0__13_23}""${ret_colored_primary2013_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2354_v0="${name_25040}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2355_v0() {
    local start_path_24931="${1}"
    local cursor_24932="${2}"
    local show_hidden_24933="${3}"
    local page_size_24934="${4}"
    stty_lock__1990_v0 
    # Initialize current path
    local current_path_24937="${start_path_24931}"
    if [ "$([ "_${current_path_24937}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1970_v0 
        current_path_24937="${ret_get_cwd1970_v0}"
    fi
    normalize_path__1971_v0 "${current_path_24937}"
    current_path_24937="${ret_normalize_path1971_v0}"
    while :
    do
        colored_primary__2013_v0 "Loading files..."
        local ret_colored_primary2013_v0__41_17="${ret_colored_primary2013_v0}"
        local array_525=("")
        eprintf__2031_v0 "${ret_colored_primary2013_v0__41_17}" array_525[@]
        get_directory_entries__1969_v0 "${current_path_24937}"
        local listed_24948=("${ret_get_directory_entries1969_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_24949=()
        local types_24950=()
        local targets_24951=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_24937}" == "_/" ]; echo $?)" != 0 ]; then
            names_24949+=("..")
            types_24950+=("d")
            targets_24951+=("")
        fi
        local __length_532=("${listed_24948[@]}")
        local listed_count_24952="$(( ${#__length_532[@]} / __ENTRY_STRIDE_82 ))"
        local __range_start_24953=0
        local __range_end_24953="${listed_count_24952}"
        local __dir_24953=$(( ${__range_start_24953} <= ${__range_end_24953} ? 1 : -1 ))
        for (( i_24953=${__range_start_24953}; i_24953 * ${__dir_24953} < ${__range_end_24953} * ${__dir_24953}; i_24953+=${__dir_24953} )); do
            local at_24954="$(( i_24953 * __ENTRY_STRIDE_82 ))"
            local name_24955="${listed_24948[${at_24954}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_24955}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_24933 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_533=("${name_24955}")
            names_24949+=("${array_533[@]}")
            local array_534=("${listed_24948[$(( at_24954 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_24950+=("${array_534[@]}")
            local array_535=("${listed_24948[$(( at_24954 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_24951+=("${array_535[@]}")
done
        local __length_536=("${names_24949[@]}")
        local total_24956="${#__length_536[@]}"
        if [ "$(( total_24956 == 0 ))" != 0 ]; then
            eprintf_colored__2032_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1991_v0 
            ret_xyl_file2355_v0=""
            return 0
        fi
        colored_primary__2013_v0 "${current_path_24937}"
        local header_24958="${ret_colored_primary2013_v0}"
        remove_current_line__2036_v0 
        chooser_begin__2336_v0 "${total_24956}" "${page_size_24934}" "${header_24958}" "${cursor_24932}" 0 -1
        local need_page_25033=1
        while :
        do
            if [ "${need_page_25033}" != 0 ]; then
                local page_25034=()
                chooser_page_start__2337_v0 
                local start_25035="${ret_chooser_page_start2337_v0}"
                chooser_page_count__2338_v0 
                local count_25038="${ret_chooser_page_count2338_v0}"
                local __range_start_25039="${start_25035}"
                local __range_end_25039="$(( start_25035 + count_25038 ))"
                local __dir_25039=$(( ${__range_start_25039} <= ${__range_end_25039} ? 1 : -1 ))
                for (( i_25039=${__range_start_25039}; i_25039 * ${__dir_25039} < ${__range_end_25039} * ${__dir_25039}; i_25039+=${__dir_25039} )); do
                    format_entry_display__2354_v0 "${names_24949[${i_25039}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_24950[${i_25039}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_24951[${i_25039}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display2354_v0__90_30="${ret_format_entry_display2354_v0}"
                    local array_538=("${ret_format_entry_display2354_v0__90_30}")
                    page_25034+=("${array_538[@]}")
done
                chooser_set_page__2339_v0 page_25034[@]
            fi
            chooser_step__2342_v0 
            local step_25097="${ret_chooser_step2342_v0}"
            if [ "$(( step_25097 == __CHOOSER_DONE_108 ))" != 0 ]; then
                break
            fi
            need_page_25033="$(( step_25097 == __CHOOSER_NEED_PAGE_107 ))"
        done
        chooser_selected__2343_v0 
        local selected_idx_25098="${ret_chooser_selected2343_v0}"
        chooser_end__2345_v0 
        local name_25101="${names_24949[${selected_idx_25098}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_25102="${types_24950[${selected_idx_25098}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_25101}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1973_v0 "${current_path_24937}"
            current_path_24937="${ret_get_parent_dir1973_v0}"
        elif [ "$([ "_${file_type_25102}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1972_v0 "${current_path_24937}" "${name_25101}"
            current_path_24937="${ret_path_join1972_v0}"
            normalize_path__1971_v0 "${current_path_24937}"
            current_path_24937="${ret_normalize_path1971_v0}"
        elif [ "$([ "_${file_type_25102}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_25107="${targets_24951[${selected_idx_25098}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_25108="${target_25107}"
            starts_with__22_v0 "${target_25107}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__1972_v0 "${current_path_24937}" "${target_25107}"
                target_path_25108="${ret_path_join1972_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_25108}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_24937="${target_path_25108}"
                normalize_path__1971_v0 "${current_path_24937}"
                current_path_24937="${ret_normalize_path1971_v0}"
            else
                stty_unlock__1991_v0 
                path_join__1972_v0 "${current_path_24937}" "${name_25101}"
                ret_xyl_file2355_v0="${ret_path_join1972_v0}"
                return 0
            fi
        else
            stty_unlock__1991_v0 
            path_join__1972_v0 "${current_path_24937}" "${name_25101}"
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
    local usage_24856=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2055_v0 usage_24856[@]
    printf '%s\n' ""
    colored_primary__2013_v0 "file"
    local ret_colored_primary2013_v0__8_20="${ret_colored_primary2013_v0}"
    local title_24891=("${ret_colored_primary2013_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2055_v0 title_24891[@]
    printf '%s\n' ""
    colored_secondary__2014_v0 "Arguments:"
    local ret_colored_secondary2014_v0__11_12="${ret_colored_secondary2014_v0}"
    local array_541=()
    printf__128_v0 "${ret_colored_secondary2014_v0__11_12}""
" array_541[@]
    local arg_names_24893=("[<path>]")
    local arg_texts_24894=("Starting directory path")
    local arg_notes_24895=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2054_v0 arg_names_24893[@] arg_texts_24894[@] arg_notes_24895[@] 20
    printf '%s\n' ""
    colored_secondary__2014_v0 "Flags:"
    local ret_colored_secondary2014_v0__18_12="${ret_colored_secondary2014_v0}"
    local array_545=()
    printf__128_v0 "${ret_colored_secondary2014_v0__18_12}""
" array_545[@]
    local names_24923=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_24924=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_24925=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2054_v0 names_24923[@] texts_24924[@] notes_24925[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2501_v0() {
    local parameters_24850=("${!1}")
    local cursor_24851="> "
    local start_path_24852=""
    local show_hidden_24853=0
    local page_size_24854=10
    local __length_552=("${parameters_24850[@]}")
    local slice_upper_551="${#__length_552[@]}"
    local slice_offset_553=2
    local slice_offset_553=$((${slice_offset_553} > 0 ? ${slice_offset_553} : 0))
    local slice_length_554="$(( slice_upper_551 - slice_offset_553 ))"
    local slice_length_554=$((${slice_length_554} > 0 ? ${slice_length_554} : 0))
    for param_24855 in "${parameters_24850[@]:${slice_offset_553}:${slice_length_554}}"; do
        starts_with__22_v0 "${param_24855}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24855}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24855}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_24855}" != "_-h" ]; echo $?) || $([ "_${param_24855}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2449_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_555="--cursor="
            slice__24_v0 "${param_24855}" "${#__length_555}" 0
            cursor_24851="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_556="--path="
            slice__24_v0 "${param_24855}" "${#__length_556}" 0
            start_path_24852="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_24855}" != "_-a" ]; echo $?) || $([ "_${param_24855}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_24853=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_557="--page-size="
            slice__24_v0 "${param_24855}" "${#__length_557}" 0
            local value_24926="${ret_slice24_v0}"
            parse_int__13_v0 "${value_24926}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2032_v0 "ERROR: Invalid page-size value: ""${value_24926}""
" 31
                exit 1
            fi
            page_size_24854="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_24852="${param_24855}"
        fi
    done
    xyl_file__2355_v0 "${start_path_24852}" "${cursor_24851}" "${show_hidden_24853}" "${page_size_24854}"
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
command_1417="${args_133[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1417}" != "_help" ]; echo $?) || $([ "_${command_1417}" != "_--help" ]; echo $?) )) || $([ "_${command_1417}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__428_v0 
elif [ "$([ "_${command_1417}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__841_v0 args_133[@]
    ret_execute_input841_v0__48_18="${ret_execute_input841_v0}"
    printf '%s\n' "${ret_execute_input841_v0__48_18}"
elif [ "$([ "_${command_1417}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1367_v0 args_133[@]
    ret_execute_choose1367_v0__51_18="${ret_execute_choose1367_v0}"
    printf '%s\n' "${ret_execute_choose1367_v0__51_18}"
elif [ "$([ "_${command_1417}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1814_v0 args_133[@]
    result_16566="${ret_execute_confirm1814_v0}"
    if [ "$([ "_${result_16566}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1417}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2501_v0 args_133[@]
    ret_execute_file2501_v0__61_18="${ret_execute_file2501_v0}"
    printf '%s\n' "${ret_execute_file2501_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1417}" != "_version" ]; echo $?) || $([ "_${command_1417}" != "_--version" ]; echo $?) )) || $([ "_${command_1417}" != "_-v" ]; echo $?) ))" != 0 ]; then
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
    printf_colored__259_v0 "ERROR: Unknown command '""${command_1417}""'" 91
fi
