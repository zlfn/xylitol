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
    local text_1333="${1}"
    local delimiter_1334="${2}"
    local result_1335=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1334}" read -rd '' -A result_1335 < <(printf %s "$text_1333")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1334}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1335+=("$REPLY"); done < <(echo "$text_1333")
            __status=$?
        else
            IFS="${delimiter_1334}" read -rd '' -a result_1335 < <(printf %s "$text_1333")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1334}" read -rd '' -a result_1335 < <(printf %s "$text_1333")
        __status=$?
    fi
    ret_split4_v0=("${result_1335[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_16423=("${!1}")
    local delimiter_16424="${2}"
    local command_1
    command_1="$(IFS="${delimiter_16424}" ; printf "%s
" "${list_16423[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1337="${1}"
    [ -n "${text_1337}" ] && [ "${text_1337}" -eq "${text_1337}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1337}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_2835="${1}"
    local prefix_2836="${2}"
    [[ "${text_2835}" == "${prefix_2836}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1415="${1}"
    local index_1416="${2}"
    local length_1417="${3}"
    local result_1418=""
    if [ "$(( length_1417 == 0 ))" != 0 ]; then
        local __length_2="${text_1415}"
        length_1417="$(( ${#__length_2} - index_1416 ))"
    fi
    if [ "$(( length_1417 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1418}"
        return 0
    fi
    result_1418="${text_1415: ${index_1416}: ${length_1417}}"
    __status=$?
    ret_slice24_v0="${result_1418}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_18358="${1}"
    local pad_18359="${2}"
    local length_18360="${3}"
    local __length_3="${text_18358}"
    if [ "$(( length_18360 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_18358}"
        return 0
    fi
    local __length_4="${text_18358}"
    local pad_len_18361="$(( length_18360 - ${#__length_4} ))"
    local padding_18362=""
    printf -v padding_18362 "%${pad_len_18361}s" ""
    __status=$?
    padding_18362="${padding_18362// /${pad_18359}}"
    __status=$?
    ret_lpad27_v0="${padding_18362}""${text_18358}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1395="${1}"
    local pad_1396="${2}"
    local length_1397="${3}"
    local __length_5="${text_1395}"
    if [ "$(( length_1397 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1395}"
        return 0
    fi
    local __length_6="${text_1395}"
    local pad_len_1398="$(( length_1397 - ${#__length_6} ))"
    local padding_1399=""
    printf -v padding_1399 "%${pad_len_1398}s" ""
    __status=$?
    padding_1399="${padding_1399// /${pad_1396}}"
    __status=$?
    ret_rpad28_v0="${text_1395}""${padding_1399}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_18352="${1}"
    local pad_18353="${2}"
    local length_18354="${3}"
    local __length_7="${text_18352}"
    local text_length_18355="${#__length_7}"
    if [ "$(( length_18354 <= text_length_18355 ))" != 0 ]; then
        ret_cpad29_v0="${text_18352}"
        return 0
    fi
    local total_padding_18356="$(( length_18354 - text_length_18355 ))"
    local left_padding_length_18357="$(( text_length_18355 + $(( total_padding_18356 / 2 )) ))"
    lpad__27_v0 "${text_18352}" "${pad_18353}" "${left_padding_length_18357}"
    local left_padded_18363="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_18363}" "${pad_18353}" "${length_18354}"
    local center_padded_18364="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_18364}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_28003="${1}"
    [ -d "${path_28003}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1360="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1360}")"
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
" "${(P)name_1360}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1360}")"
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
    local format_1357="${1}"
    local args_1358=("${!2}")
    args_1358=("${format_1357}" "${args_1358[@]}")
    __status=$?
    printf "${args_1358[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1370="${1}"
    local args_1371=("${!2}")
    args_1371=("${format_1370}" "${args_1371[@]}")
    __status=$?
    printf "${args_1371[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1367="${1}"
    local color_1368="${2}"
    local color_code_1369=0
        color_code_1369="${color_1368}"
    local array_11=("${message_1367}")
    printf__128_v1 "\\x1b[${color_code_1369}m%s\\x1b[0m
" array_11[@]
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_5="None"
# perl_available()
perl_available__210_v0() {
    if [ "$([ "_${_perl_state_5}" != "_None" ]; echo $?)" != 0 ]; then
        local command_12
        command_12="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_1353
        disabled_1353="$([ "_${command_12}" != "_No" ]; echo $?)"
        local command_13
        command_13="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1354
        found_1354="$(( $(( ! disabled_1353 )) && $([ "_${command_13}" != "_0" ]; echo $?) ))"
        _perl_state_5="$(if [ "${found_1354}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available210_v0="$([ "_${_perl_state_5}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__211_v0() {
    local text_1352="${1}"
    perl_available__210_v0 
    local ret_perl_available210_v0__22_12="${ret_perl_available210_v0}"
    if [ "$(( ! ret_perl_available210_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width211_v0=''
        return 1
    fi
    local command_14
    command_14="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1352}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width211_v0=''
        return "${__status}"
    fi
    local width_str_1355="${command_14}"
    parse_int__13_v0 "${width_str_1355}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width211_v0=''
        return "${__status}"
    fi
    local width_1356="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width211_v0="${width_1356}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_6=0
_term_size_7=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__222_v0() {
    local size_1332="${1}"
    if [ "$([ "_${size_1332}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size222_v0=0
        return 0
    fi
    split__4_v0 "${size_1332}" " "
    local parts_1336=("${ret_split4_v0[@]}")
    local __length_16=("${parts_1336[@]}")
    if [ "$(( ${#__length_16[@]} != 2 ))" != 0 ]; then
        ret_store_term_size222_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1336[1]?"Index out of bounds (at src/utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1336[0]?"Index out of bounds (at src/utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_7=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size222_v0=1
    return 0
}

# query_term_size()
query_term_size__223_v0() {
    local command_18
    command_18="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1339="${command_18}"
    store_term_size__222_v0 "${size_1339}"
    ret_query_term_size223_v0="${ret_store_term_size222_v0}"
    return 0
}

# stty_term_size()
stty_term_size__224_v0() {
    local command_19
    command_19="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1331="${command_19}"
    store_term_size__222_v0 "${size_1331}"
    ret_stty_term_size224_v0="${ret_store_term_size222_v0}"
    return 0
}

# get_term_size()
get_term_size__225_v0() {
    stty_term_size__224_v0 
    local detected_1338="${ret_stty_term_size224_v0}"
    if [ "$(( ! detected_1338 ))" != 0 ]; then
        query_term_size__223_v0 
        detected_1338="${ret_query_term_size223_v0}"
    fi
    _got_term_size_6=1
}

# term_width()
term_width__227_v0() {
    if [ "$(( ! _got_term_size_6 ))" != 0 ]; then
        get_term_size__225_v0 
    fi
    ret_term_width227_v0="${_term_size_7[0]?"Index out of bounds (at src/utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_8="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_9=0
_primary_color_10=(3 207 159 92)
_secondary_color_11=(3 118 206 94)
_accent_color_12=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__238_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1377="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1377}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor238_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__239_v0() {
    local message_1372="${1}"
    local r_1373="${2}"
    local g_1374="${3}"
    local b_1375="${4}"
    local fallback_1376="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb239_v0="\\x1b[38;2;${r_1373};${g_1374};${b_1375}m""${message_1372}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__238_v0 
        local ret_get_supports_truecolor238_v0__45_17="${ret_get_supports_truecolor238_v0}"
        if [ "${ret_get_supports_truecolor238_v0__45_17}" != 0 ]; then
            ret_colored_rgb239_v0="\\x1b[38;2;${r_1373};${g_1374};${b_1375}m""${message_1372}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1376 == 0 ))" != 0 ]; then
            ret_colored_rgb239_v0="${message_1372}"
            return 0
        else
            ret_colored_rgb239_v0="\\x1b[${fallback_1376}m""${message_1372}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1376 == 0 ))" != 0 ]; then
            ret_colored_rgb239_v0="${message_1372}"
            return 0
        fi
        ret_colored_rgb239_v0="\\x1b[${fallback_1376}m""${message_1372}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__241_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1361="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1361}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1361}" ";"
            local parts_1362=("${ret_split4_v0[@]}")
            local __length_23=("${parts_1362[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1362[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1362[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1362[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1362[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_10=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1363="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1363}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1363}" ";"
            local parts_1364=("${ret_split4_v0[@]}")
            local __length_25=("${parts_1364[@]}")
            if [ "$(( ${#__length_25[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1364[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1364[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1364[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1364[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_11=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1365="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1365}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1365}" ";"
            local parts_1366=("${ret_split4_v0[@]}")
            local __length_27=("${parts_1366[@]}")
            if [ "$(( ${#__length_27[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1366[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1366[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1366[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1366[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_12=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_9=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__242_v0() {
    inner_get_xylitol_colors__241_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_9=1
}

# colored_primary(message: Text)
colored_primary__243_v0() {
    local message_1359="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__242_v0 
    fi
    colored_rgb__239_v0 "${message_1359}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary243_v0="${ret_colored_rgb239_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__244_v0() {
    local message_1379="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__242_v0 
    fi
    colored_rgb__239_v0 "${message_1379}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary244_v0="${ret_colored_rgb239_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__245_v0() {
    local message_1425="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__242_v0 
    fi
    colored_rgb__239_v0 "${message_1425}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent245_v0="${ret_colored_rgb239_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__260_v0() {
    local message_28006="${1}"
    local color_28007="${2}"
    # Prints a text with a specified color.
    local array_29=("${message_28006}")
    printf__128_v1 "\\x1b[${color_28007}m%s\\x1b[0m" array_29[@]
}

# eprintf(format: Text, args: [Text])
eprintf__261_v0() {
    local format_148="${1}"
    local args_149=("${!2}")
    args_149=("${format_148}" "${args_149[@]}")
    __status=$?
    printf "${args_149[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__262_v0() {
    local message_146="${1}"
    local color_147="${2}"
    # Prints an error message with a specified color.
    local array_30=("${message_146}")
    eprintf__261_v0 "\\x1b[${color_147}m%s\\x1b[0m" array_30[@]
}

# colored(message: Text, color: Int)
colored__263_v0() {
    local message_1413="${1}"
    local color_1414="${2}"
    # Returns a text wrapped in color codes.
    ret_colored263_v0="\\x1b[${color_1414}m""${message_1413}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__274_v0() {
    local text_1345="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_31
    command_31="$([[ "${text_1345}" == *$'\x1b'* || "${text_1345}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1346="${command_31}"
    ret_has_ansi_escape274_v0="$([ "_${has_escape_1346}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__276_v0() {
    local text_1348="${1}"
    local command_32
    command_32="$(printf "%s" "${text_1348}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi276_v0="${command_32}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__277_v0() {
    local text_1350="${1}"
    local command_33
    command_33="$(printf "%s" "${text_1350}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1351="${command_33}"
    ret_is_all_ascii277_v0="$([ "_${result_1351}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__278_v0() {
    local text_1347="${1}"
    strip_ansi__276_v0 "${text_1347}"
    local stripped_1349="${ret_strip_ansi276_v0}"
    # Check if text is all ASCII
    is_all_ascii__277_v0 "${stripped_1349}"
    local ret_is_all_ascii277_v0__150_12="${ret_is_all_ascii277_v0}"
    if [ "$(( ! ret_is_all_ascii277_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__211_v0 "${stripped_1349}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_34="${stripped_1349}"
            ret_get_visible_len278_v0="${#__length_34}"
            return 0
        fi
        ret_get_visible_len278_v0="${ret_perl_get_cjk_width211_v0}"
        return 0
    else
        local __length_35="${stripped_1349}"
        ret_get_visible_len278_v0="${#__length_35}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__283_v0() {
    local pending_1410="${1}"
    local line_1411="${2}"
    local note_at_1412="${3}"
    if [ "$(( note_at_1412 < 0 ))" != 0 ]; then
        local array_36=()
        printf__128_v0 "${pending_1410}""${line_1411}""
" array_36[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1412 == 0 ))" != 0 ]; then
        colored__263_v0 "${line_1411}" 90
        local ret_colored263_v0__310_40="${ret_colored263_v0}"
        local array_37=()
        printf__128_v0 "${pending_1410}""${ret_colored263_v0__310_40}""
" array_37[@]
    else
        slice__24_v0 "${line_1411}" 0 "${note_at_1412}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1411}" "${note_at_1412}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__263_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored263_v0__311_58="${ret_colored263_v0}"
        local array_38=()
        printf__128_v0 "${pending_1410}""${ret_slice24_v0__311_32}""${ret_colored263_v0__311_58}""
" array_38[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__284_v0() {
    local names_1383=("${!1}")
    local texts_1384=("${!2}")
    local notes_1385=("${!3}")
    local min_name_width_1386="${4}"
    local __length_39=("${names_1383[@]}")
    local count_1387="${#__length_39[@]}"
    local name_width_1388="${min_name_width_1386}"
    local __range_start_1389=0
    local __range_end_1389="${count_1387}"
    local __dir_1389=$(( ${__range_start_1389} <= ${__range_end_1389} ? 1 : -1 ))
    for (( i_1389=${__range_start_1389}; i_1389 * ${__dir_1389} < ${__range_end_1389} * ${__dir_1389}; i_1389+=${__dir_1389} )); do
        local __length_40="${names_1383[${i_1389}]?"Index out of bounds (at src/./utils.ab:326:33)"}"
        local width_1390="${#__length_40}"
        if [ "$(( width_1390 > name_width_1388 ))" != 0 ]; then
            name_width_1388="${width_1390}"
        fi
done
    term_width__227_v0 
    local width_1391="${ret_term_width227_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1392="$(( name_width_1388 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1393="$(( $(( width_1391 - indent_1392 )) < 24 ))"
    if [ "${stacked_1393}" != 0 ]; then
        indent_1392=6
    fi
    local avail_1394="$(( width_1391 - indent_1392 ))"
    rpad__28_v0 "" " " "${indent_1392}"
    local blank_1400="${ret_rpad28_v0}"
    local __range_start_1401=0
    local __range_end_1401="${count_1387}"
    local __dir_1401=$(( ${__range_start_1401} <= ${__range_end_1401} ? 1 : -1 ))
    for (( i_1401=${__range_start_1401}; i_1401 * ${__dir_1401} < ${__range_end_1401} * ${__dir_1401}; i_1401+=${__dir_1401} )); do
        local pending_1402="${blank_1400}"
        if [ "${stacked_1393}" != 0 ]; then
            local array_41=()
            printf__128_v0 "  ""${names_1383[${i_1401}]?"Index out of bounds (at src/./utils.ab:346:33)"}""
" array_41[@]
        else
            rpad__28_v0 "  ""${names_1383[${i_1401}]?"Index out of bounds (at src/./utils.ab:348:41)"}" " " "${indent_1392}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_1402="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_1384[${i_1401}]?"Index out of bounds (at src/./utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_1403=("${ret_split4_v0__350_21[@]}")
        local __length_42=("${words_1403[@]}")
        local note_start_1404="${#__length_42[@]}"
        if [ "$([ "_${notes_1385[${i_1401}]?"Index out of bounds (at src/./utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_43="${notes_1385[${i_1401}]?"Index out of bounds (at src/./utils.ab:355:26)"}"
            if [ "$(( ${#__length_43} > avail_1394 ))" != 0 ]; then
                split__4_v0 "${notes_1385[${i_1401}]?"Index out of bounds (at src/./utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_1403+=("${ret_split4_v0__356_26[@]}")
            else
                local array_44=("${notes_1385[${i_1401}]?"Index out of bounds (at src/./utils.ab:358:33)"}")
                words_1403+=("${array_44[@]}")
            fi
        fi
        local line_1405=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1406=-1
        local __range_start_1407=0
        local __length_45=("${words_1403[@]}")
        local __range_end_1407="${#__length_45[@]}"
        local __dir_1407=$(( ${__range_start_1407} <= ${__range_end_1407} ? 1 : -1 ))
        for (( j_1407=${__range_start_1407}; j_1407 * ${__dir_1407} < ${__range_end_1407} * ${__dir_1407}; j_1407+=${__dir_1407} )); do
            local word_1408="${words_1403[${j_1407}]?"Index out of bounds (at src/./utils.ab:368:32)"}"
            local candidate_1409
            candidate_1409="$(if [ "$([ "_${line_1405}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1408}"; else echo "${line_1405}"" ""${word_1408}"; fi)"
            local __length_46="${candidate_1409}"
            if [ "$(( $(( ${#__length_46} > avail_1394 )) && $([ "_${line_1405}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__283_v0 "${pending_1402}" "${line_1405}" "${note_at_1406}"
                pending_1402="${blank_1400}"
                line_1405="${word_1408}"
                note_at_1406="$(if [ "$(( j_1407 >= note_start_1404 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1407 >= note_start_1404 )) && $(( note_at_1406 < 0 )) ))" != 0 ]; then
                    local __length_47="${candidate_1409}"
                    local __length_48="${word_1408}"
                    note_at_1406="$(( ${#__length_47} - ${#__length_48} ))"
                fi
                line_1405="${candidate_1409}"
            fi
done
        print_help_line__283_v0 "${pending_1402}" "${line_1405}" "${note_at_1406}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__285_v0() {
    local pieces_1330=("${!1}")
    term_width__227_v0 
    local width_1340="${ret_term_width227_v0}"
    local line_1341=""
    local line_len_1342=0
    for piece_1343 in "${pieces_1330[@]}"; do
        local __length_51="${piece_1343}"
        local piece_len_1344="${#__length_51}"
        has_ansi_escape__274_v0 "${piece_1343}"
        local ret_has_ansi_escape274_v0__397_12="${ret_has_ansi_escape274_v0}"
        if [ "${ret_has_ansi_escape274_v0__397_12}" != 0 ]; then
            get_visible_len__278_v0 "${piece_1343}"
            piece_len_1344="${ret_get_visible_len278_v0}"
        fi
        if [ "$([ "_${line_1341}" != "_" ]; echo $?)" != 0 ]; then
            line_1341="${piece_1343}"
            line_len_1342="${piece_len_1344}"
        elif [ "$(( $(( $(( line_len_1342 + 1 )) + piece_len_1344 )) > width_1340 ))" != 0 ]; then
            local array_52=()
            printf__128_v0 "${line_1341}""
" array_52[@]
            line_1341="${piece_1343}"
            line_len_1342="${piece_len_1344}"
        else
            line_1341+=" ""${piece_1343}"
            line_len_1342="$(( line_len_1342 + $(( 1 + piece_len_1344 )) ))"
        fi
    done
    if [ "$([ "_${line_1341}" == "_" ]; echo $?)" != 0 ]; then
        local array_53=()
        printf__128_v0 "${line_1341}""
" array_53[@]
    fi
}

# print_help()
print_help__429_v0() {
    local usage_1329=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__285_v0 usage_1329[@]
    printf '%s\n' ""
    colored_primary__243_v0 "Xylitol"
    local ret_colored_primary243_v0__9_21="${ret_colored_primary243_v0}"
    colored_primary__243_v0 "fresh"
    local ret_colored_primary243_v0__10_34="${ret_colored_primary243_v0}"
    local title_1378=("\\x1b[1m""${ret_colored_primary243_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary243_v0__10_34}" "shell" "scripts.")
    print_wrapped__285_v0 title_1378[@]
    printf '%s\n' ""
    colored_secondary__244_v0 "Flags:"
    local ret_colored_secondary244_v0__14_12="${ret_colored_secondary244_v0}"
    local array_56=()
    printf__128_v0 "${ret_colored_secondary244_v0__14_12}""
" array_56[@]
    local flag_names_1380=("-h, --help" "-v, --version")
    local flag_texts_1381=("Show this help message" "Show version information")
    local flag_notes_1382=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__284_v0 flag_names_1380[@] flag_texts_1381[@] flag_notes_1382[@] 13
    printf '%s\n' ""
    colored_secondary__244_v0 "Commands:"
    local ret_colored_secondary244_v0__21_12="${ret_colored_secondary244_v0}"
    local array_60=()
    printf__128_v0 "${ret_colored_secondary244_v0__21_12}""
" array_60[@]
    local cmd_names_1419=("input" "choose" "confirm" "file")
    local cmd_texts_1420=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1421=("" "" "" "")
    render_help_entries__284_v0 cmd_names_1419[@] cmd_texts_1420[@] cmd_notes_1421[@] 13
    printf '%s\n' ""
    colored_secondary__244_v0 "Envs:"
    local ret_colored_secondary244_v0__32_12="${ret_colored_secondary244_v0}"
    local array_64=()
    printf__128_v0 "${ret_colored_secondary244_v0__32_12}""
" array_64[@]
    local env_names_1422=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1423=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1424=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__284_v0 env_names_1422[@] env_texts_1423[@] env_notes_1424[@] 0
    printf '%s\n' ""
    colored_accent__245_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent245_v0__57_16="${ret_colored_accent245_v0}"
    local footer_1426=("Run" "${ret_colored_accent245_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__285_v0 footer_1426[@]
}

# math_floor(number: Int)
math_floor__510_v0() {
    local number_2900="${1}"
    local command_69
    command_69="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_2900}")"
    __status=$?
    ret_math_floor510_v0="${command_69}"
    return 0
}

# math_ceil(number: Int)
math_ceil__511_v0() {
    local number_2899="${1}"
    math_floor__510_v0 "${number_2899}"
    local ret_math_floor510_v0__52_12="${ret_math_floor510_v0}"
    ret_math_ceil511_v0="$(( ret_math_floor510_v0__52_12 + 1 ))"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_17="None"
# perl_available()
perl_available__571_v0() {
    if [ "$([ "_${_perl_state_17}" != "_None" ]; echo $?)" != 0 ]; then
        local command_70
        command_70="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_2786
        disabled_2786="$([ "_${command_70}" != "_No" ]; echo $?)"
        local command_71
        command_71="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_2787
        found_2787="$(( $(( ! disabled_2786 )) && $([ "_${command_71}" != "_0" ]; echo $?) ))"
        _perl_state_17="$(if [ "${found_2787}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available571_v0="$([ "_${_perl_state_17}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__572_v0() {
    local text_2785="${1}"
    perl_available__571_v0 
    local ret_perl_available571_v0__22_12="${ret_perl_available571_v0}"
    if [ "$(( ! ret_perl_available571_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width572_v0=''
        return 1
    fi
    local command_72
    command_72="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2785}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width572_v0=''
        return "${__status}"
    fi
    local width_str_2788="${command_72}"
    parse_int__13_v0 "${width_str_2788}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width572_v0=''
        return "${__status}"
    fi
    local width_2789="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width572_v0="${width_2789}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__573_v0() {
    local text_2854="${1}"
    local max_width_2855="${2}"
    perl_available__571_v0 
    local ret_perl_available571_v0__33_12="${ret_perl_available571_v0}"
    if [ "$(( ! ret_perl_available571_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk573_v0=''
        return 1
    fi
    local command_73
    command_73="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_2854}" ${max_width_2855} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk573_v0=''
        return "${__status}"
    fi
    local result_2856="${command_73}"
    ret_perl_truncate_cjk573_v0="${result_2856}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_18=0
_term_size_19=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__580_v0() {
    local command_75
    command_75="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_2843="${command_75}"
    parse_int__13_v0 "${count_2843}"
    __status=$?
    ret_stty_count580_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__581_v0() {
    stty_count__580_v0 
    local count_num_2844="${ret_stty_count580_v0}"
    if [ "$(( count_num_2844 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2844="$(( count_num_2844 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2844}
    __status=$?
}

# stty_unlock()
stty_unlock__582_v0() {
    stty_count__580_v0 
    local count_num_2897="${ret_stty_count580_v0}"
    if [ "$(( count_num_2897 > 0 ))" != 0 ]; then
        count_num_2897="$(( count_num_2897 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2897}
        __status=$?
        if [ "$(( count_num_2897 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__583_v0() {
    local size_2769="${1}"
    if [ "$([ "_${size_2769}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size583_v0=0
        return 0
    fi
    split__4_v0 "${size_2769}" " "
    local parts_2770=("${ret_split4_v0[@]}")
    local __length_76=("${parts_2770[@]}")
    if [ "$(( ${#__length_76[@]} != 2 ))" != 0 ]; then
        ret_store_term_size583_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2770[1]?"Index out of bounds (at src/./input/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2770[0]?"Index out of bounds (at src/./input/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_19=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size583_v0=1
    return 0
}

# query_term_size()
query_term_size__584_v0() {
    local command_78
    command_78="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2772="${command_78}"
    store_term_size__583_v0 "${size_2772}"
    ret_query_term_size584_v0="${ret_store_term_size583_v0}"
    return 0
}

# stty_term_size()
stty_term_size__585_v0() {
    local command_79
    command_79="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2768="${command_79}"
    store_term_size__583_v0 "${size_2768}"
    ret_stty_term_size585_v0="${ret_store_term_size583_v0}"
    return 0
}

# get_term_size()
get_term_size__586_v0() {
    stty_term_size__585_v0 
    local detected_2771="${ret_stty_term_size585_v0}"
    if [ "$(( ! detected_2771 ))" != 0 ]; then
        query_term_size__584_v0 
        detected_2771="${ret_query_term_size584_v0}"
    fi
    _got_term_size_18=1
}

# term_width()
term_width__588_v0() {
    if [ "$(( ! _got_term_size_18 ))" != 0 ]; then
        get_term_size__586_v0 
    fi
    ret_term_width588_v0="${_term_size_19[0]?"Index out of bounds (at src/./input/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_20="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_21=0
_primary_color_22=(3 207 159 92)
_secondary_color_23=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__599_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_2802="${ret_env_var_get120_v0}"
    _supports_truecolor_20="$(if [ "$([ "_${config_2802}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor599_v0="$([ "_${_supports_truecolor_20}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__600_v0() {
    local message_2797="${1}"
    local r_2798="${2}"
    local g_2799="${3}"
    local b_2800="${4}"
    local fallback_2801="${5}"
    if [ "$([ "_${_supports_truecolor_20}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb600_v0="\\x1b[38;2;${r_2798};${g_2799};${b_2800}m""${message_2797}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_20}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__599_v0 
        local ret_get_supports_truecolor599_v0__45_17="${ret_get_supports_truecolor599_v0}"
        if [ "${ret_get_supports_truecolor599_v0__45_17}" != 0 ]; then
            ret_colored_rgb600_v0="\\x1b[38;2;${r_2798};${g_2799};${b_2800}m""${message_2797}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2801 == 0 ))" != 0 ]; then
            ret_colored_rgb600_v0="${message_2797}"
            return 0
        else
            ret_colored_rgb600_v0="\\x1b[${fallback_2801}m""${message_2797}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2801 == 0 ))" != 0 ]; then
            ret_colored_rgb600_v0="${message_2797}"
            return 0
        fi
        ret_colored_rgb600_v0="\\x1b[${fallback_2801}m""${message_2797}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__602_v0() {
    if [ "$(( ! _got_xylitol_colors_21 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2791="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2791}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2791}" ";"
            local parts_2792=("${ret_split4_v0[@]}")
            local __length_83=("${parts_2792[@]}")
            if [ "$(( ${#__length_83[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2792[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2792[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2792[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2792[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_22=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2793="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2793}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2793}" ";"
            local parts_2794=("${ret_split4_v0[@]}")
            local __length_85=("${parts_2794[@]}")
            if [ "$(( ${#__length_85[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2794[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2794[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2794[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2794[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_23=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2795="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2795}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2795}" ";"
            local parts_2796=("${ret_split4_v0[@]}")
            local __length_87=("${parts_2796[@]}")
            if [ "$(( ${#__length_87[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2796[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2796[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2796[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2796[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors602_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_21=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__603_v0() {
    inner_get_xylitol_colors__602_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_21=1
}

# colored_primary(message: Text)
colored_primary__604_v0() {
    local message_2790="${1}"
    if [ "$(( ! _got_xylitol_colors_21 ))" != 0 ]; then
        get_xylitol_colors__603_v0 
    fi
    colored_rgb__600_v0 "${message_2790}" "${_primary_color_22[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_22[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_22[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_22[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary604_v0="${ret_colored_rgb600_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__605_v0() {
    local message_2804="${1}"
    if [ "$(( ! _got_xylitol_colors_21 ))" != 0 ]; then
        get_xylitol_colors__603_v0 
    fi
    colored_rgb__600_v0 "${message_2804}" "${_secondary_color_23[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_23[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_23[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_23[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary605_v0="${ret_colored_rgb600_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__619_v0() {
    local command_89
    command_89="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_2894="${command_89}"
    ret_get_char619_v0="${char_2894}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__622_v0() {
    local format_2872="${1}"
    local args_2873=("${!2}")
    args_2873=("${format_2872}" "${args_2873[@]}")
    __status=$?
    printf "${args_2873[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__623_v0() {
    local message_2882="${1}"
    local color_2883="${2}"
    # Prints an error message with a specified color.
    local array_90=("${message_2882}")
    eprintf__622_v0 "\\x1b[${color_2883}m%s\\x1b[0m" array_90[@]
}

# colored(message: Text, color: Int)
colored__624_v0() {
    local message_2833="${1}"
    local color_2834="${2}"
    # Returns a text wrapped in color codes.
    ret_colored624_v0="\\x1b[${color_2834}m""${message_2833}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__625_v0() {
    local cnt_2895="${1}"
    if [ "$(( cnt_2895 > 0 ))" != 0 ]; then
        local array_91=("")
        eprintf__622_v0 "\\x1b[${cnt_2895}D\\x1b[K" array_91[@]
    fi
}

# remove_line(cnt: Int)
remove_line__626_v0() {
    local cnt_2903="${1}"
    if [ "$(( cnt_2903 > 0 ))" != 0 ]; then
        local sequence_2904=""
        local __range_start_2905=0
        local __range_end_2905="${cnt_2903}"
        local __dir_2905=$(( ${__range_start_2905} <= ${__range_end_2905} ? 1 : -1 ))
        for (( ____2905=${__range_start_2905}; ____2905 * ${__dir_2905} < ${__range_end_2905} * ${__dir_2905}; ____2905+=${__dir_2905} )); do
            sequence_2904+="\\x1b[2K\\x1b[1A"
done
        local array_92=("")
        eprintf__622_v0 "${sequence_2904}" array_92[@]
    fi
    local array_93=("")
    eprintf__622_v0 "\\x1b[G" array_93[@]
}

# remove_current_line()
remove_current_line__627_v0() {
    local array_94=("")
    eprintf__622_v0 "\\x1b[2K\\x1b[G" array_94[@]
}

# new_line(cnt: Int)
new_line__629_v0() {
    local cnt_2874="${1}"
    local __range_start_2875=0
    local __range_end_2875="${cnt_2874}"
    local __dir_2875=$(( ${__range_start_2875} <= ${__range_end_2875} ? 1 : -1 ))
    for (( ____2875=${__range_start_2875}; ____2875 * ${__dir_2875} < ${__range_end_2875} * ${__dir_2875}; ____2875+=${__dir_2875} )); do
        local array_95=("")
        eprintf__622_v0 "
" array_95[@]
done
}

# go_up(cnt: Int)
go_up__630_v0() {
    local cnt_2891="${1}"
    local array_96=("")
    eprintf__622_v0 "\\x1b[${cnt_2891}A" array_96[@]
}

# go_down(cnt: Int)
go_down__631_v0() {
    local cnt_2902="${1}"
    local array_97=("")
    eprintf__622_v0 "\\x1b[${cnt_2902}B" array_97[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__635_v0() {
    local text_2778="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_98
    command_98="$([[ "${text_2778}" == *$'\x1b'* || "${text_2778}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2779="${command_98}"
    ret_has_ansi_escape635_v0="$([ "_${has_escape_2779}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__636_v0() {
    local text_2837="${1}"
    local command_99
    command_99="$(printf '%s' "${text_2837}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi636_v0="${command_99}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__637_v0() {
    local text_2781="${1}"
    local command_100
    command_100="$(printf "%s" "${text_2781}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi637_v0="${command_100}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__638_v0() {
    local text_2783="${1}"
    local command_101
    command_101="$(printf "%s" "${text_2783}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2784="${command_101}"
    ret_is_all_ascii638_v0="$([ "_${result_2784}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__639_v0() {
    local text_2780="${1}"
    strip_ansi__637_v0 "${text_2780}"
    local stripped_2782="${ret_strip_ansi637_v0}"
    # Check if text is all ASCII
    is_all_ascii__638_v0 "${stripped_2782}"
    local ret_is_all_ascii638_v0__150_12="${ret_is_all_ascii638_v0}"
    if [ "$(( ! ret_is_all_ascii638_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__572_v0 "${stripped_2782}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_102="${stripped_2782}"
            ret_get_visible_len639_v0="${#__length_102}"
            return 0
        fi
        ret_get_visible_len639_v0="${ret_perl_get_cjk_width572_v0}"
        return 0
    else
        local __length_103="${stripped_2782}"
        ret_get_visible_len639_v0="${#__length_103}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__640_v0() {
    local text_2851="${1}"
    local max_width_2852="${2}"
    get_visible_len__639_v0 "${text_2851}"
    local visible_len_2853="${ret_get_visible_len639_v0}"
    if [ "$(( visible_len_2853 <= max_width_2852 ))" != 0 ]; then
        ret_truncate_text640_v0="${text_2851}"
        return 0
    fi
    is_all_ascii__638_v0 "${text_2851}"
    local ret_is_all_ascii638_v0__167_12="${ret_is_all_ascii638_v0}"
    if [ "$(( ! ret_is_all_ascii638_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__573_v0 "${text_2851}" "${max_width_2852}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_2851}" | cut -c1-${max_width_2852}
            __status=$?
        fi
        ret_truncate_text640_v0="${ret_perl_truncate_cjk573_v0}"
        return 0
    fi
    local command_104
    command_104="$(printf "%s" "${text_2851}" | cut -c1-${max_width_2852})"
    __status=$?
    ret_truncate_text640_v0="${command_104}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__641_v0() {
    local text_2849="${1}"
    local max_width_2850="${2}"
    has_ansi_escape__635_v0 "${text_2849}"
    local ret_has_ansi_escape635_v0__179_12="${ret_has_ansi_escape635_v0}"
    if [ "$(( ! ret_has_ansi_escape635_v0__179_12 ))" != 0 ]; then
        truncate_text__640_v0 "${text_2849}" "${max_width_2850}"
        ret_truncate_ansi641_v0="${ret_truncate_text640_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_105
    command_105="$([[ "${text_2849}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_2857="${command_105}"
    # Replace \x1b[ with newline, then split
    local command_106
    command_106="$(t="${text_2849}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_2858="${command_106}"
    split__4_v0 "${replaced_2858}" "
"
    local parts_2859=("${ret_split4_v0[@]}")
    local result_2860=""
    local remaining_width_2861="${max_width_2850}"
    local __range_start_2862=0
    local __length_107=("${parts_2859[@]}")
    local __range_end_2862="${#__length_107[@]}"
    local __dir_2862=$(( ${__range_start_2862} <= ${__range_end_2862} ? 1 : -1 ))
    for (( idx_2862=${__range_start_2862}; idx_2862 * ${__dir_2862} < ${__range_end_2862} * ${__dir_2862}; idx_2862+=${__dir_2862} )); do
        local part_2863="${parts_2859[${idx_2862}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_2862 == 0 )) && $([ "_${starts_with_ansi_2857}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_2863}" == "_" ]; echo $?) && $(( remaining_width_2861 > 0 )) ))" != 0 ]; then
                truncate_text__640_v0 "${part_2863}" "${remaining_width_2861}"
                local ret_truncate_text640_v0__201_35="${ret_truncate_text640_v0}"
                local truncated_2864="${ret_truncate_text640_v0__201_35}"
                result_2860+="${truncated_2864}"
                get_visible_len__639_v0 "${truncated_2864}"
                local ret_get_visible_len639_v0__203_36="${ret_get_visible_len639_v0}"
                remaining_width_2861="$(( remaining_width_2861 - ret_get_visible_len639_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_108
            command_108="$(__p="${part_2863}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_2865="${command_108}"
            if [ "$([ "_${m_idx_2865}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_109
                command_109="$(__p="${part_2863}"; printf "%s" "${__p:0:${m_idx_2865}}")"
                __status=$?
                local ansi_params_2866="${command_109}"
                result_2860+="\\x1b[""${ansi_params_2866}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_2865}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_2867="${ret_parse_int13_v0__214_41}"
                local text_start_2868="$(( m_idx_num_2867 + 1 ))"
                local command_110
                command_110="$(__p="${part_2863}"; printf "%s" "${__p:${text_start_2868}}")"
                __status=$?
                local text_part_2869="${command_110}"
                if [ "$(( $([ "_${text_part_2869}" == "_" ]; echo $?) && $(( remaining_width_2861 > 0 )) ))" != 0 ]; then
                    truncate_text__640_v0 "${text_part_2869}" "${remaining_width_2861}"
                    local ret_truncate_text640_v0__218_39="${ret_truncate_text640_v0}"
                    local truncated_2870="${ret_truncate_text640_v0__218_39}"
                    result_2860+="${truncated_2870}"
                    get_visible_len__639_v0 "${truncated_2870}"
                    local ret_get_visible_len639_v0__220_40="${ret_get_visible_len639_v0}"
                    remaining_width_2861="$(( remaining_width_2861 - ret_get_visible_len639_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_2863}" == "_" ]; echo $?) && $(( remaining_width_2861 > 0 )) ))" != 0 ]; then
                    truncate_text__640_v0 "${part_2863}" "${remaining_width_2861}"
                    local ret_truncate_text640_v0__225_39="${ret_truncate_text640_v0}"
                    local truncated_2871="${ret_truncate_text640_v0__225_39}"
                    result_2860+="${truncated_2871}"
                    get_visible_len__639_v0 "${truncated_2871}"
                    local ret_get_visible_len639_v0__227_40="${ret_get_visible_len639_v0}"
                    remaining_width_2861="$(( remaining_width_2861 - ret_get_visible_len639_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi641_v0="${result_2860}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__642_v0() {
    local text_2846="${1}"
    local max_width_2847="${2}"
    get_visible_len__639_v0 "${text_2846}"
    local visible_len_2848="${ret_get_visible_len639_v0}"
    if [ "$(( visible_len_2848 <= max_width_2847 ))" != 0 ]; then
        ret_cutoff_text642_v0="${text_2846}"
        return 0
    fi
    truncate_ansi__641_v0 "${text_2846}" "$(( max_width_2847 - 3 ))"
    local ret_truncate_ansi641_v0__243_12="${ret_truncate_ansi641_v0}"
    ret_cutoff_text642_v0="${ret_truncate_ansi641_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__643_v0() {
    local items_2876=("${!1}")
    local total_len_2877="${2}"
    local term_width_2878="${3}"
    local separator_2879=" • "
    local separator_len_2880=3
    # Fast path: no truncation needed
    if [ "$(( total_len_2877 <= term_width_2878 ))" != 0 ]; then
        local iter_2881=0
        while :
        do
            local __length_111=("${items_2876[@]}")
            if [ "$(( iter_2881 >= ${#__length_111[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_2881 > 0 ))" != 0 ]; then
                eprintf_colored__623_v0 "${separator_2879}" 90
            fi
            colored__624_v0 "${items_2876[$(( iter_2881 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored624_v0__268_41="${ret_colored624_v0}"
            local array_112=("")
            eprintf__622_v0 "${items_2876[${iter_2881}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored624_v0__268_41}" array_112[@]
            iter_2881="$(( iter_2881 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_2884=0
        local first_2885=1
        local iter_2886=0
        while :
        do
            local __length_113=("${items_2876[@]}")
            if [ "$(( iter_2886 >= ${#__length_113[@]} ))" != 0 ]; then
                break
            fi
            local key_2887="${items_2876[${iter_2886}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_2888="${items_2876[$(( iter_2886 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_114="${key_2887}"
            local __length_115="${action_2888}"
            local part_len_2889="$(( $(( ${#__length_114} + 1 )) + ${#__length_115} ))"
            local needed_2890="${part_len_2889}"
            if [ "$(( ! first_2885 ))" != 0 ]; then
                needed_2890="$(( needed_2890 + separator_len_2880 ))"
            fi
            if [ "$(( $(( current_len_2884 + needed_2890 )) > term_width_2878 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_2885 ))" != 0 ]; then
                eprintf_colored__623_v0 "${separator_2879}" 90
            fi
            colored__624_v0 "${action_2888}" 2
            local ret_colored624_v0__296_33="${ret_colored624_v0}"
            local array_116=("")
            eprintf__622_v0 "${key_2887}"" ""${ret_colored624_v0__296_33}" array_116[@]
            current_len_2884="$(( current_len_2884 + needed_2890 ))"
            first_2885=0
            iter_2886="$(( iter_2886 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__644_v0() {
    local pending_2830="${1}"
    local line_2831="${2}"
    local note_at_2832="${3}"
    if [ "$(( note_at_2832 < 0 ))" != 0 ]; then
        local array_117=()
        printf__128_v0 "${pending_2830}""${line_2831}""
" array_117[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_2832 == 0 ))" != 0 ]; then
        colored__624_v0 "${line_2831}" 90
        local ret_colored624_v0__310_40="${ret_colored624_v0}"
        local array_118=()
        printf__128_v0 "${pending_2830}""${ret_colored624_v0__310_40}""
" array_118[@]
    else
        slice__24_v0 "${line_2831}" 0 "${note_at_2832}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_2831}" "${note_at_2832}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__624_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored624_v0__311_58="${ret_colored624_v0}"
        local array_119=()
        printf__128_v0 "${pending_2830}""${ret_slice24_v0__311_32}""${ret_colored624_v0__311_58}""
" array_119[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__645_v0() {
    local names_2808=("${!1}")
    local texts_2809=("${!2}")
    local notes_2810=("${!3}")
    local min_name_width_2811="${4}"
    local __length_120=("${names_2808[@]}")
    local count_2812="${#__length_120[@]}"
    local name_width_2813="${min_name_width_2811}"
    local __range_start_2814=0
    local __range_end_2814="${count_2812}"
    local __dir_2814=$(( ${__range_start_2814} <= ${__range_end_2814} ? 1 : -1 ))
    for (( i_2814=${__range_start_2814}; i_2814 * ${__dir_2814} < ${__range_end_2814} * ${__dir_2814}; i_2814+=${__dir_2814} )); do
        local __length_121="${names_2808[${i_2814}]?"Index out of bounds (at src/./input/../utils.ab:326:33)"}"
        local width_2815="${#__length_121}"
        if [ "$(( width_2815 > name_width_2813 ))" != 0 ]; then
            name_width_2813="${width_2815}"
        fi
done
    term_width__588_v0 
    local width_2816="${ret_term_width588_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2817="$(( name_width_2813 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2818="$(( $(( width_2816 - indent_2817 )) < 24 ))"
    if [ "${stacked_2818}" != 0 ]; then
        indent_2817=6
    fi
    local avail_2819="$(( width_2816 - indent_2817 ))"
    rpad__28_v0 "" " " "${indent_2817}"
    local blank_2820="${ret_rpad28_v0}"
    local __range_start_2821=0
    local __range_end_2821="${count_2812}"
    local __dir_2821=$(( ${__range_start_2821} <= ${__range_end_2821} ? 1 : -1 ))
    for (( i_2821=${__range_start_2821}; i_2821 * ${__dir_2821} < ${__range_end_2821} * ${__dir_2821}; i_2821+=${__dir_2821} )); do
        local pending_2822="${blank_2820}"
        if [ "${stacked_2818}" != 0 ]; then
            local array_122=()
            printf__128_v0 "  ""${names_2808[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:346:33)"}""
" array_122[@]
        else
            rpad__28_v0 "  ""${names_2808[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:348:41)"}" " " "${indent_2817}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_2822="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_2809[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_2823=("${ret_split4_v0__350_21[@]}")
        local __length_123=("${words_2823[@]}")
        local note_start_2824="${#__length_123[@]}"
        if [ "$([ "_${notes_2810[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_124="${notes_2810[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_124} > avail_2819 ))" != 0 ]; then
                split__4_v0 "${notes_2810[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_2823+=("${ret_split4_v0__356_26[@]}")
            else
                local array_125=("${notes_2810[${i_2821}]?"Index out of bounds (at src/./input/../utils.ab:358:33)"}")
                words_2823+=("${array_125[@]}")
            fi
        fi
        local line_2825=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2826=-1
        local __range_start_2827=0
        local __length_126=("${words_2823[@]}")
        local __range_end_2827="${#__length_126[@]}"
        local __dir_2827=$(( ${__range_start_2827} <= ${__range_end_2827} ? 1 : -1 ))
        for (( j_2827=${__range_start_2827}; j_2827 * ${__dir_2827} < ${__range_end_2827} * ${__dir_2827}; j_2827+=${__dir_2827} )); do
            local word_2828="${words_2823[${j_2827}]?"Index out of bounds (at src/./input/../utils.ab:368:32)"}"
            local candidate_2829
            candidate_2829="$(if [ "$([ "_${line_2825}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2828}"; else echo "${line_2825}"" ""${word_2828}"; fi)"
            local __length_127="${candidate_2829}"
            if [ "$(( $(( ${#__length_127} > avail_2819 )) && $([ "_${line_2825}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__644_v0 "${pending_2822}" "${line_2825}" "${note_at_2826}"
                pending_2822="${blank_2820}"
                line_2825="${word_2828}"
                note_at_2826="$(if [ "$(( j_2827 >= note_start_2824 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2827 >= note_start_2824 )) && $(( note_at_2826 < 0 )) ))" != 0 ]; then
                    local __length_128="${candidate_2829}"
                    local __length_129="${word_2828}"
                    note_at_2826="$(( ${#__length_128} - ${#__length_129} ))"
                fi
                line_2825="${candidate_2829}"
            fi
done
        print_help_line__644_v0 "${pending_2822}" "${line_2825}" "${note_at_2826}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__646_v0() {
    local pieces_2767=("${!1}")
    term_width__588_v0 
    local width_2773="${ret_term_width588_v0}"
    local line_2774=""
    local line_len_2775=0
    for piece_2776 in "${pieces_2767[@]}"; do
        local __length_132="${piece_2776}"
        local piece_len_2777="${#__length_132}"
        has_ansi_escape__635_v0 "${piece_2776}"
        local ret_has_ansi_escape635_v0__397_12="${ret_has_ansi_escape635_v0}"
        if [ "${ret_has_ansi_escape635_v0__397_12}" != 0 ]; then
            get_visible_len__639_v0 "${piece_2776}"
            piece_len_2777="${ret_get_visible_len639_v0}"
        fi
        if [ "$([ "_${line_2774}" != "_" ]; echo $?)" != 0 ]; then
            line_2774="${piece_2776}"
            line_len_2775="${piece_len_2777}"
        elif [ "$(( $(( $(( line_len_2775 + 1 )) + piece_len_2777 )) > width_2773 ))" != 0 ]; then
            local array_133=()
            printf__128_v0 "${line_2774}""
" array_133[@]
            line_2774="${piece_2776}"
            line_len_2775="${piece_len_2777}"
        else
            line_2774+=" ""${piece_2776}"
            line_len_2775="$(( line_len_2775 + $(( 1 + piece_len_2777 )) ))"
        fi
    done
    if [ "$([ "_${line_2774}" == "_" ]; echo $?)" != 0 ]; then
        local array_134=()
        printf__128_v0 "${line_2774}""
" array_134[@]
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__697_v0() {
    local prompt_2839="${1}"
    local placeholder_2840="${2}"
    local header_2841="${3}"
    local password_2842="${4}"
    stty_lock__581_v0 
    term_width__588_v0 
    local term_width_2845="${ret_term_width588_v0}"
    if [ "$([ "_${header_2841}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__642_v0 "${header_2841}" "${term_width_2845}"
        local ret_cutoff_text642_v0__25_17="${ret_cutoff_text642_v0}"
        local array_135=("")
        eprintf__622_v0 "${ret_cutoff_text642_v0__25_17}""
" array_135[@]
    fi
    new_line__629_v0 2
    # "enter submit" = 12
    local array_136=("enter" "submit")
    render_tooltip__643_v0 array_136[@] 12 "${term_width_2845}"
    go_up__630_v0 2
    local array_137=("")
    eprintf__622_v0 "\\x1b[G" array_137[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_138
    command_138="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_2892="${command_138}"
    local char_2893=""
    local array_139=("")
    eprintf__622_v0 "${prompt_2839}" array_139[@]
    if [ "$([ "_${can_preset_2892}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__623_v0 "${placeholder_2840}" 90
        get_char__619_v0 
        char_2893="${ret_get_char619_v0}"
        local __length_140="${placeholder_2840}"
        remove__625_v0 "$(( ${#__length_140} + 1 ))"
    fi
    local __length_141="${prompt_2839}"
    remove__625_v0 "${#__length_141}"
    local text_2896=""
    if [ "$(( ! password_2842 ))" != 0 ]; then
        stty_unlock__582_v0 
        local command_142
        command_142="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_2893}" -p "${prompt_2839}" text < /dev/tty; else read -e -p "${prompt_2839}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2896="${command_142}"
    else
        stty_unlock__582_v0 
        local command_143
        command_143="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_2893}" -p "${prompt_2839}" text < /dev/tty; else read -es -p "${prompt_2839}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2896="${command_143}"
    fi
    stty_lock__581_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__639_v0 "${prompt_2839}""${text_2896}"
    local input_display_len_2898="${ret_get_visible_len639_v0}"
    math_ceil__511_v0 "$(( input_display_len_2898 / term_width_2845 ))"
    local input_lines_2901="${ret_math_ceil511_v0}"
    if [ "$(( input_lines_2901 < 3 ))" != 0 ]; then
        go_down__631_v0 "$(( 2 - input_lines_2901 ))"
        remove_line__626_v0 2
        remove_current_line__627_v0 
    fi
    if [ "$(( input_lines_2901 >= 3 ))" != 0 ]; then
        remove_line__626_v0 "${input_lines_2901}"
    fi
    if [ "$([ "_${header_2841}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__626_v0 1
        remove_current_line__627_v0 
    fi
    stty_unlock__582_v0 
    ret_xyl_input697_v0="${text_2896}"
    return 0
}

# print_input_help()
print_input_help__791_v0() {
    local usage_2766=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__646_v0 usage_2766[@]
    printf '%s\n' ""
    colored_primary__604_v0 "input"
    local ret_colored_primary604_v0__8_20="${ret_colored_primary604_v0}"
    local title_2803=("${ret_colored_primary604_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__646_v0 title_2803[@]
    printf '%s\n' ""
    colored_secondary__605_v0 "Flags:"
    local ret_colored_secondary605_v0__11_12="${ret_colored_secondary605_v0}"
    local array_146=()
    printf__128_v0 "${ret_colored_secondary605_v0__11_12}""
" array_146[@]
    local names_2805=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2806=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2807=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__645_v0 names_2805[@] texts_2806[@] notes_2807[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__843_v0() {
    local parameters_2760=("${!1}")
    local prompt_2761="> "
    local placeholder_2762="Type here..."
    local header_2763=""
    local password_2764=0
    for param_2765 in "${parameters_2760[@]}"; do
        if [ "$(( $([ "_${param_2765}" != "_-h" ]; echo $?) || $([ "_${param_2765}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__791_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2765}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_152="--prompt="
            slice__24_v0 "${param_2765}" "${#__length_152}" 0
            prompt_2761="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2765}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_153="--placeholder="
            slice__24_v0 "${param_2765}" "${#__length_153}" 0
            placeholder_2762="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2765}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_154="--header="
            slice__24_v0 "${param_2765}" "${#__length_154}" 0
            header_2763="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2765}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2764=1
        fi
    done
    has_ansi_escape__635_v0 "${header_2763}"
    local ret_has_ansi_escape635_v0__31_44="${ret_has_ansi_escape635_v0}"
    escape_ansi__636_v0 "${header_2763}"
    local ret_escape_ansi636_v0__31_73="${ret_escape_ansi636_v0}"
    colored_primary__604_v0 "${header_2763}"
    local ret_colored_primary604_v0__31_111="${ret_colored_primary604_v0}"
    local display_header_2838
    display_header_2838="$(if [ "$(( $([ "_${header_2763}" != "_" ]; echo $?) || ret_has_ansi_escape635_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi636_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary604_v0__31_111}"; fi)"
    xyl_input__697_v0 "${prompt_2761}" "${placeholder_2762}" "${display_header_2838}" "${password_2764}"
    ret_execute_input843_v0="${ret_xyl_input697_v0}"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_30="None"
# perl_available()
perl_available__975_v0() {
    if [ "$([ "_${_perl_state_30}" != "_None" ]; echo $?)" != 0 ]; then
        local command_155
        command_155="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16263
        disabled_16263="$([ "_${command_155}" != "_No" ]; echo $?)"
        local command_156
        command_156="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16264
        found_16264="$(( $(( ! disabled_16263 )) && $([ "_${command_156}" != "_0" ]; echo $?) ))"
        _perl_state_30="$(if [ "${found_16264}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available975_v0="$([ "_${_perl_state_30}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__976_v0() {
    local text_16262="${1}"
    perl_available__975_v0 
    local ret_perl_available975_v0__22_12="${ret_perl_available975_v0}"
    if [ "$(( ! ret_perl_available975_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width976_v0=''
        return 1
    fi
    local command_157
    command_157="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16262}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width976_v0=''
        return "${__status}"
    fi
    local width_str_16265="${command_157}"
    parse_int__13_v0 "${width_str_16265}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width976_v0=''
        return "${__status}"
    fi
    local width_16266="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width976_v0="${width_16266}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__977_v0() {
    local text_16334="${1}"
    local max_width_16335="${2}"
    perl_available__975_v0 
    local ret_perl_available975_v0__33_12="${ret_perl_available975_v0}"
    if [ "$(( ! ret_perl_available975_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk977_v0=''
        return 1
    fi
    local command_158
    command_158="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16334}" ${max_width_16335} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk977_v0=''
        return "${__status}"
    fi
    local result_16336="${command_158}"
    ret_perl_truncate_cjk977_v0="${result_16336}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_31=0
_term_size_32=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__984_v0() {
    local command_160
    command_160="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_16322="${command_160}"
    parse_int__13_v0 "${count_16322}"
    __status=$?
    ret_stty_count984_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__985_v0() {
    stty_count__984_v0 
    local count_num_16323="${ret_stty_count984_v0}"
    if [ "$(( count_num_16323 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16323="$(( count_num_16323 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16323}
    __status=$?
}

# stty_unlock()
stty_unlock__986_v0() {
    stty_count__984_v0 
    local count_num_16418="${ret_stty_count984_v0}"
    if [ "$(( count_num_16418 > 0 ))" != 0 ]; then
        count_num_16418="$(( count_num_16418 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16418}
        __status=$?
        if [ "$(( count_num_16418 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__987_v0() {
    local size_16246="${1}"
    if [ "$([ "_${size_16246}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size987_v0=0
        return 0
    fi
    split__4_v0 "${size_16246}" " "
    local parts_16247=("${ret_split4_v0[@]}")
    local __length_161=("${parts_16247[@]}")
    if [ "$(( ${#__length_161[@]} != 2 ))" != 0 ]; then
        ret_store_term_size987_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16247[1]?"Index out of bounds (at src/./choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16247[0]?"Index out of bounds (at src/./choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_32=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size987_v0=1
    return 0
}

# query_term_size()
query_term_size__988_v0() {
    local command_163
    command_163="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16249="${command_163}"
    store_term_size__987_v0 "${size_16249}"
    ret_query_term_size988_v0="${ret_store_term_size987_v0}"
    return 0
}

# stty_term_size()
stty_term_size__989_v0() {
    local command_164
    command_164="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16245="${command_164}"
    store_term_size__987_v0 "${size_16245}"
    ret_stty_term_size989_v0="${ret_store_term_size987_v0}"
    return 0
}

# get_term_size()
get_term_size__990_v0() {
    stty_term_size__989_v0 
    local detected_16248="${ret_stty_term_size989_v0}"
    if [ "$(( ! detected_16248 ))" != 0 ]; then
        query_term_size__988_v0 
        detected_16248="${ret_query_term_size988_v0}"
    fi
    _got_term_size_31=1
}

# term_width()
term_width__992_v0() {
    if [ "$(( ! _got_term_size_31 ))" != 0 ]; then
        get_term_size__990_v0 
    fi
    ret_term_width992_v0="${_term_size_32[0]?"Index out of bounds (at src/./choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__993_v0() {
    if [ "$(( ! _got_term_size_31 ))" != 0 ]; then
        get_term_size__990_v0 
    fi
    ret_term_height993_v0="${_term_size_32[1]?"Index out of bounds (at src/./choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_33="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_34=0
_primary_color_35=(3 207 159 92)
_secondary_color_36=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1003_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_16234="${ret_env_var_get120_v0}"
    _supports_truecolor_33="$(if [ "$([ "_${config_16234}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1003_v0="$([ "_${_supports_truecolor_33}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1004_v0() {
    local message_16229="${1}"
    local r_16230="${2}"
    local g_16231="${3}"
    local b_16232="${4}"
    local fallback_16233="${5}"
    if [ "$([ "_${_supports_truecolor_33}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1004_v0="\\x1b[38;2;${r_16230};${g_16231};${b_16232}m""${message_16229}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_33}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1003_v0 
        local ret_get_supports_truecolor1003_v0__45_17="${ret_get_supports_truecolor1003_v0}"
        if [ "${ret_get_supports_truecolor1003_v0__45_17}" != 0 ]; then
            ret_colored_rgb1004_v0="\\x1b[38;2;${r_16230};${g_16231};${b_16232}m""${message_16229}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16233 == 0 ))" != 0 ]; then
            ret_colored_rgb1004_v0="${message_16229}"
            return 0
        else
            ret_colored_rgb1004_v0="\\x1b[${fallback_16233}m""${message_16229}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16233 == 0 ))" != 0 ]; then
            ret_colored_rgb1004_v0="${message_16229}"
            return 0
        fi
        ret_colored_rgb1004_v0="\\x1b[${fallback_16233}m""${message_16229}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1006_v0() {
    if [ "$(( ! _got_xylitol_colors_34 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16223="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16223}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16223}" ";"
            local parts_16224=("${ret_split4_v0[@]}")
            local __length_168=("${parts_16224[@]}")
            if [ "$(( ${#__length_168[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16224[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16224[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16224[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16224[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_35=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16225="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16225}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16225}" ";"
            local parts_16226=("${ret_split4_v0[@]}")
            local __length_170=("${parts_16226[@]}")
            if [ "$(( ${#__length_170[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16226[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16226[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16226[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16226[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_36=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16227="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16227}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16227}" ";"
            local parts_16228=("${ret_split4_v0[@]}")
            local __length_172=("${parts_16228[@]}")
            if [ "$(( ${#__length_172[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16228[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16228[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16228[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16228[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1006_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_34=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1007_v0() {
    inner_get_xylitol_colors__1006_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_34=1
}

# colored_primary(message: Text)
colored_primary__1008_v0() {
    local message_16222="${1}"
    if [ "$(( ! _got_xylitol_colors_34 ))" != 0 ]; then
        get_xylitol_colors__1007_v0 
    fi
    colored_rgb__1004_v0 "${message_16222}" "${_primary_color_35[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_35[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_35[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_35[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1008_v0="${ret_colored_rgb1004_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1009_v0() {
    local message_16268="${1}"
    if [ "$(( ! _got_xylitol_colors_34 ))" != 0 ]; then
        get_xylitol_colors__1007_v0 
    fi
    colored_rgb__1004_v0 "${message_16268}" "${_secondary_color_36[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_36[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_36[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_36[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1009_v0="${ret_colored_rgb1004_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1024_v0() {
    local command_174
    command_174="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16396="${command_174}"
    if [ "$([ "_${var_16396}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1024_v0="UP"
        return 0
    elif [ "$([ "_${var_16396}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1024_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16396}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1024_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16396}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1024_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16396}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1024_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16396}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1024_v0="INPUT"
        return 0
    else
        ret_get_key1024_v0="${var_16396}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1026_v0() {
    local format_16305="${1}"
    local args_16306=("${!2}")
    args_16306=("${format_16305}" "${args_16306[@]}")
    __status=$?
    printf "${args_16306[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1027_v0() {
    local message_16303="${1}"
    local color_16304="${2}"
    # Prints an error message with a specified color.
    local array_175=("${message_16303}")
    eprintf__1026_v0 "\\x1b[${color_16304}m%s\\x1b[0m" array_175[@]
}

# colored(message: Text, color: Int)
colored__1028_v0() {
    local message_16297="${1}"
    local color_16298="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1028_v0="\\x1b[${color_16298}m""${message_16297}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1030_v0() {
    local cnt_16393="${1}"
    if [ "$(( cnt_16393 > 0 ))" != 0 ]; then
        local sequence_16394=""
        local __range_start_16395=0
        local __range_end_16395="${cnt_16393}"
        local __dir_16395=$(( ${__range_start_16395} <= ${__range_end_16395} ? 1 : -1 ))
        for (( ____16395=${__range_start_16395}; ____16395 * ${__dir_16395} < ${__range_end_16395} * ${__dir_16395}; ____16395+=${__dir_16395} )); do
            sequence_16394+="\\x1b[2K\\x1b[1A"
done
        local array_176=("")
        eprintf__1026_v0 "${sequence_16394}" array_176[@]
    fi
    local array_177=("")
    eprintf__1026_v0 "\\x1b[G" array_177[@]
}

# remove_current_line()
remove_current_line__1031_v0() {
    local array_178=("")
    eprintf__1026_v0 "\\x1b[2K\\x1b[G" array_178[@]
}

# print_blank(cnt: Int)
print_blank__1032_v0() {
    local cnt_16384="${1}"
    printf '%*s' "${cnt_16384}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1033_v0() {
    local cnt_16353="${1}"
    local __range_start_16354=0
    local __range_end_16354="${cnt_16353}"
    local __dir_16354=$(( ${__range_start_16354} <= ${__range_end_16354} ? 1 : -1 ))
    for (( ____16354=${__range_start_16354}; ____16354 * ${__dir_16354} < ${__range_end_16354} * ${__dir_16354}; ____16354+=${__dir_16354} )); do
        local array_179=("")
        eprintf__1026_v0 "
" array_179[@]
done
}

# go_up(cnt: Int)
go_up__1034_v0() {
    local cnt_16368="${1}"
    local array_180=("")
    eprintf__1026_v0 "\\x1b[${cnt_16368}A" array_180[@]
}

# go_down(cnt: Int)
go_down__1035_v0() {
    local cnt_16405="${1}"
    local array_181=("")
    eprintf__1026_v0 "\\x1b[${cnt_16405}B" array_181[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1036_v0() {
    local cnt_16414="${1}"
    if [ "$(( cnt_16414 > 0 ))" != 0 ]; then
        go_down__1035_v0 "${cnt_16414}"
    else
        go_up__1034_v0 "$(( - cnt_16414 ))"
    fi
}

# hide_cursor()
hide_cursor__1037_v0() {
    local array_182=("")
    eprintf__1026_v0 "\\x1b[?25l" array_182[@]
}

# show_cursor()
show_cursor__1038_v0() {
    local array_183=("")
    eprintf__1026_v0 "\\x1b[?25h" array_183[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1039_v0() {
    local text_16255="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_184
    command_184="$([[ "${text_16255}" == *$'\x1b'* || "${text_16255}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16256="${command_184}"
    ret_has_ansi_escape1039_v0="$([ "_${has_escape_16256}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1040_v0() {
    local text_16308="${1}"
    local command_185
    command_185="$(printf '%s' "${text_16308}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1040_v0="${command_185}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1041_v0() {
    local text_16258="${1}"
    local command_186
    command_186="$(printf "%s" "${text_16258}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1041_v0="${command_186}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1042_v0() {
    local text_16260="${1}"
    local command_187
    command_187="$(printf "%s" "${text_16260}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16261="${command_187}"
    ret_is_all_ascii1042_v0="$([ "_${result_16261}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1043_v0() {
    local text_16257="${1}"
    strip_ansi__1041_v0 "${text_16257}"
    local stripped_16259="${ret_strip_ansi1041_v0}"
    # Check if text is all ASCII
    is_all_ascii__1042_v0 "${stripped_16259}"
    local ret_is_all_ascii1042_v0__150_12="${ret_is_all_ascii1042_v0}"
    if [ "$(( ! ret_is_all_ascii1042_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__976_v0 "${stripped_16259}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_188="${stripped_16259}"
            ret_get_visible_len1043_v0="${#__length_188}"
            return 0
        fi
        ret_get_visible_len1043_v0="${ret_perl_get_cjk_width976_v0}"
        return 0
    else
        local __length_189="${stripped_16259}"
        ret_get_visible_len1043_v0="${#__length_189}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1044_v0() {
    local text_16331="${1}"
    local max_width_16332="${2}"
    get_visible_len__1043_v0 "${text_16331}"
    local visible_len_16333="${ret_get_visible_len1043_v0}"
    if [ "$(( visible_len_16333 <= max_width_16332 ))" != 0 ]; then
        ret_truncate_text1044_v0="${text_16331}"
        return 0
    fi
    is_all_ascii__1042_v0 "${text_16331}"
    local ret_is_all_ascii1042_v0__167_12="${ret_is_all_ascii1042_v0}"
    if [ "$(( ! ret_is_all_ascii1042_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__977_v0 "${text_16331}" "${max_width_16332}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16331}" | cut -c1-${max_width_16332}
            __status=$?
        fi
        ret_truncate_text1044_v0="${ret_perl_truncate_cjk977_v0}"
        return 0
    fi
    local command_190
    command_190="$(printf "%s" "${text_16331}" | cut -c1-${max_width_16332})"
    __status=$?
    ret_truncate_text1044_v0="${command_190}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1045_v0() {
    local text_16329="${1}"
    local max_width_16330="${2}"
    has_ansi_escape__1039_v0 "${text_16329}"
    local ret_has_ansi_escape1039_v0__179_12="${ret_has_ansi_escape1039_v0}"
    if [ "$(( ! ret_has_ansi_escape1039_v0__179_12 ))" != 0 ]; then
        truncate_text__1044_v0 "${text_16329}" "${max_width_16330}"
        ret_truncate_ansi1045_v0="${ret_truncate_text1044_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_191
    command_191="$([[ "${text_16329}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16337="${command_191}"
    # Replace \x1b[ with newline, then split
    local command_192
    command_192="$(t="${text_16329}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16338="${command_192}"
    split__4_v0 "${replaced_16338}" "
"
    local parts_16339=("${ret_split4_v0[@]}")
    local result_16340=""
    local remaining_width_16341="${max_width_16330}"
    local __range_start_16342=0
    local __length_193=("${parts_16339[@]}")
    local __range_end_16342="${#__length_193[@]}"
    local __dir_16342=$(( ${__range_start_16342} <= ${__range_end_16342} ? 1 : -1 ))
    for (( idx_16342=${__range_start_16342}; idx_16342 * ${__dir_16342} < ${__range_end_16342} * ${__dir_16342}; idx_16342+=${__dir_16342} )); do
        local part_16343="${parts_16339[${idx_16342}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16342 == 0 )) && $([ "_${starts_with_ansi_16337}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16343}" == "_" ]; echo $?) && $(( remaining_width_16341 > 0 )) ))" != 0 ]; then
                truncate_text__1044_v0 "${part_16343}" "${remaining_width_16341}"
                local ret_truncate_text1044_v0__201_35="${ret_truncate_text1044_v0}"
                local truncated_16344="${ret_truncate_text1044_v0__201_35}"
                result_16340+="${truncated_16344}"
                get_visible_len__1043_v0 "${truncated_16344}"
                local ret_get_visible_len1043_v0__203_36="${ret_get_visible_len1043_v0}"
                remaining_width_16341="$(( remaining_width_16341 - ret_get_visible_len1043_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_194
            command_194="$(__p="${part_16343}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16345="${command_194}"
            if [ "$([ "_${m_idx_16345}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_195
                command_195="$(__p="${part_16343}"; printf "%s" "${__p:0:${m_idx_16345}}")"
                __status=$?
                local ansi_params_16346="${command_195}"
                result_16340+="\\x1b[""${ansi_params_16346}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16345}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_16347="${ret_parse_int13_v0__214_41}"
                local text_start_16348="$(( m_idx_num_16347 + 1 ))"
                local command_196
                command_196="$(__p="${part_16343}"; printf "%s" "${__p:${text_start_16348}}")"
                __status=$?
                local text_part_16349="${command_196}"
                if [ "$(( $([ "_${text_part_16349}" == "_" ]; echo $?) && $(( remaining_width_16341 > 0 )) ))" != 0 ]; then
                    truncate_text__1044_v0 "${text_part_16349}" "${remaining_width_16341}"
                    local ret_truncate_text1044_v0__218_39="${ret_truncate_text1044_v0}"
                    local truncated_16350="${ret_truncate_text1044_v0__218_39}"
                    result_16340+="${truncated_16350}"
                    get_visible_len__1043_v0 "${truncated_16350}"
                    local ret_get_visible_len1043_v0__220_40="${ret_get_visible_len1043_v0}"
                    remaining_width_16341="$(( remaining_width_16341 - ret_get_visible_len1043_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16343}" == "_" ]; echo $?) && $(( remaining_width_16341 > 0 )) ))" != 0 ]; then
                    truncate_text__1044_v0 "${part_16343}" "${remaining_width_16341}"
                    local ret_truncate_text1044_v0__225_39="${ret_truncate_text1044_v0}"
                    local truncated_16351="${ret_truncate_text1044_v0__225_39}"
                    result_16340+="${truncated_16351}"
                    get_visible_len__1043_v0 "${truncated_16351}"
                    local ret_get_visible_len1043_v0__227_40="${ret_get_visible_len1043_v0}"
                    remaining_width_16341="$(( remaining_width_16341 - ret_get_visible_len1043_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1045_v0="${result_16340}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1046_v0() {
    local text_16326="${1}"
    local max_width_16327="${2}"
    get_visible_len__1043_v0 "${text_16326}"
    local visible_len_16328="${ret_get_visible_len1043_v0}"
    if [ "$(( visible_len_16328 <= max_width_16327 ))" != 0 ]; then
        ret_cutoff_text1046_v0="${text_16326}"
        return 0
    fi
    truncate_ansi__1045_v0 "${text_16326}" "$(( max_width_16327 - 3 ))"
    local ret_truncate_ansi1045_v0__243_12="${ret_truncate_ansi1045_v0}"
    ret_cutoff_text1046_v0="${ret_truncate_ansi1045_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1047_v0() {
    local items_16355=("${!1}")
    local total_len_16356="${2}"
    local term_width_16357="${3}"
    local separator_16358=" • "
    local separator_len_16359=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16356 <= term_width_16357 ))" != 0 ]; then
        local iter_16360=0
        while :
        do
            local __length_197=("${items_16355[@]}")
            if [ "$(( iter_16360 >= ${#__length_197[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16360 > 0 ))" != 0 ]; then
                eprintf_colored__1027_v0 "${separator_16358}" 90
            fi
            colored__1028_v0 "${items_16355[$(( iter_16360 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1028_v0__268_41="${ret_colored1028_v0}"
            local array_198=("")
            eprintf__1026_v0 "${items_16355[${iter_16360}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1028_v0__268_41}" array_198[@]
            iter_16360="$(( iter_16360 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16361=0
        local first_16362=1
        local iter_16363=0
        while :
        do
            local __length_199=("${items_16355[@]}")
            if [ "$(( iter_16363 >= ${#__length_199[@]} ))" != 0 ]; then
                break
            fi
            local key_16364="${items_16355[${iter_16363}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_16365="${items_16355[$(( iter_16363 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_200="${key_16364}"
            local __length_201="${action_16365}"
            local part_len_16366="$(( $(( ${#__length_200} + 1 )) + ${#__length_201} ))"
            local needed_16367="${part_len_16366}"
            if [ "$(( ! first_16362 ))" != 0 ]; then
                needed_16367="$(( needed_16367 + separator_len_16359 ))"
            fi
            if [ "$(( $(( current_len_16361 + needed_16367 )) > term_width_16357 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16362 ))" != 0 ]; then
                eprintf_colored__1027_v0 "${separator_16358}" 90
            fi
            colored__1028_v0 "${action_16365}" 2
            local ret_colored1028_v0__296_33="${ret_colored1028_v0}"
            local array_202=("")
            eprintf__1026_v0 "${key_16364}"" ""${ret_colored1028_v0__296_33}" array_202[@]
            current_len_16361="$(( current_len_16361 + needed_16367 ))"
            first_16362=0
            iter_16363="$(( iter_16363 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1048_v0() {
    local pending_16294="${1}"
    local line_16295="${2}"
    local note_at_16296="${3}"
    if [ "$(( note_at_16296 < 0 ))" != 0 ]; then
        local array_203=()
        printf__128_v0 "${pending_16294}""${line_16295}""
" array_203[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16296 == 0 ))" != 0 ]; then
        colored__1028_v0 "${line_16295}" 90
        local ret_colored1028_v0__310_40="${ret_colored1028_v0}"
        local array_204=()
        printf__128_v0 "${pending_16294}""${ret_colored1028_v0__310_40}""
" array_204[@]
    else
        slice__24_v0 "${line_16295}" 0 "${note_at_16296}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16295}" "${note_at_16296}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1028_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1028_v0__311_58="${ret_colored1028_v0}"
        local array_205=()
        printf__128_v0 "${pending_16294}""${ret_slice24_v0__311_32}""${ret_colored1028_v0__311_58}""
" array_205[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1049_v0() {
    local names_16272=("${!1}")
    local texts_16273=("${!2}")
    local notes_16274=("${!3}")
    local min_name_width_16275="${4}"
    local __length_206=("${names_16272[@]}")
    local count_16276="${#__length_206[@]}"
    local name_width_16277="${min_name_width_16275}"
    local __range_start_16278=0
    local __range_end_16278="${count_16276}"
    local __dir_16278=$(( ${__range_start_16278} <= ${__range_end_16278} ? 1 : -1 ))
    for (( i_16278=${__range_start_16278}; i_16278 * ${__dir_16278} < ${__range_end_16278} * ${__dir_16278}; i_16278+=${__dir_16278} )); do
        local __length_207="${names_16272[${i_16278}]?"Index out of bounds (at src/./choose/../utils.ab:326:33)"}"
        local width_16279="${#__length_207}"
        if [ "$(( width_16279 > name_width_16277 ))" != 0 ]; then
            name_width_16277="${width_16279}"
        fi
done
    term_width__992_v0 
    local width_16280="${ret_term_width992_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16281="$(( name_width_16277 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16282="$(( $(( width_16280 - indent_16281 )) < 24 ))"
    if [ "${stacked_16282}" != 0 ]; then
        indent_16281=6
    fi
    local avail_16283="$(( width_16280 - indent_16281 ))"
    rpad__28_v0 "" " " "${indent_16281}"
    local blank_16284="${ret_rpad28_v0}"
    local __range_start_16285=0
    local __range_end_16285="${count_16276}"
    local __dir_16285=$(( ${__range_start_16285} <= ${__range_end_16285} ? 1 : -1 ))
    for (( i_16285=${__range_start_16285}; i_16285 * ${__dir_16285} < ${__range_end_16285} * ${__dir_16285}; i_16285+=${__dir_16285} )); do
        local pending_16286="${blank_16284}"
        if [ "${stacked_16282}" != 0 ]; then
            local array_208=()
            printf__128_v0 "  ""${names_16272[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:346:33)"}""
" array_208[@]
        else
            rpad__28_v0 "  ""${names_16272[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:348:41)"}" " " "${indent_16281}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_16286="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_16273[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_16287=("${ret_split4_v0__350_21[@]}")
        local __length_209=("${words_16287[@]}")
        local note_start_16288="${#__length_209[@]}"
        if [ "$([ "_${notes_16274[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_210="${notes_16274[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_210} > avail_16283 ))" != 0 ]; then
                split__4_v0 "${notes_16274[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_16287+=("${ret_split4_v0__356_26[@]}")
            else
                local array_211=("${notes_16274[${i_16285}]?"Index out of bounds (at src/./choose/../utils.ab:358:33)"}")
                words_16287+=("${array_211[@]}")
            fi
        fi
        local line_16289=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16290=-1
        local __range_start_16291=0
        local __length_212=("${words_16287[@]}")
        local __range_end_16291="${#__length_212[@]}"
        local __dir_16291=$(( ${__range_start_16291} <= ${__range_end_16291} ? 1 : -1 ))
        for (( j_16291=${__range_start_16291}; j_16291 * ${__dir_16291} < ${__range_end_16291} * ${__dir_16291}; j_16291+=${__dir_16291} )); do
            local word_16292="${words_16287[${j_16291}]?"Index out of bounds (at src/./choose/../utils.ab:368:32)"}"
            local candidate_16293
            candidate_16293="$(if [ "$([ "_${line_16289}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16292}"; else echo "${line_16289}"" ""${word_16292}"; fi)"
            local __length_213="${candidate_16293}"
            if [ "$(( $(( ${#__length_213} > avail_16283 )) && $([ "_${line_16289}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1048_v0 "${pending_16286}" "${line_16289}" "${note_at_16290}"
                pending_16286="${blank_16284}"
                line_16289="${word_16292}"
                note_at_16290="$(if [ "$(( j_16291 >= note_start_16288 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16291 >= note_start_16288 )) && $(( note_at_16290 < 0 )) ))" != 0 ]; then
                    local __length_214="${candidate_16293}"
                    local __length_215="${word_16292}"
                    note_at_16290="$(( ${#__length_214} - ${#__length_215} ))"
                fi
                line_16289="${candidate_16293}"
            fi
done
        print_help_line__1048_v0 "${pending_16286}" "${line_16289}" "${note_at_16290}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1050_v0() {
    local pieces_16244=("${!1}")
    term_width__992_v0 
    local width_16250="${ret_term_width992_v0}"
    local line_16251=""
    local line_len_16252=0
    for piece_16253 in "${pieces_16244[@]}"; do
        local __length_218="${piece_16253}"
        local piece_len_16254="${#__length_218}"
        has_ansi_escape__1039_v0 "${piece_16253}"
        local ret_has_ansi_escape1039_v0__397_12="${ret_has_ansi_escape1039_v0}"
        if [ "${ret_has_ansi_escape1039_v0__397_12}" != 0 ]; then
            get_visible_len__1043_v0 "${piece_16253}"
            piece_len_16254="${ret_get_visible_len1043_v0}"
        fi
        if [ "$([ "_${line_16251}" != "_" ]; echo $?)" != 0 ]; then
            line_16251="${piece_16253}"
            line_len_16252="${piece_len_16254}"
        elif [ "$(( $(( $(( line_len_16252 + 1 )) + piece_len_16254 )) > width_16250 ))" != 0 ]; then
            local array_219=()
            printf__128_v0 "${line_16251}""
" array_219[@]
            line_16251="${piece_16253}"
            line_len_16252="${piece_len_16254}"
        else
            line_16251+=" ""${piece_16253}"
            line_len_16252="$(( line_len_16252 + $(( 1 + piece_len_16254 )) ))"
        fi
    done
    if [ "$([ "_${line_16251}" == "_" ]; echo $?)" != 0 ]; then
        local array_220=()
        printf__128_v0 "${line_16251}""
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
__CHOOSER_CONTINUE_40=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_41=1
# The user confirmed the selection.
__CHOOSER_DONE_42=2
_total_43=0
_page_size_44=10
_display_count_45=0
_total_pages_46=1
_current_page_47=0
_selected_48=0
_cursor_49="> "
_multi_50=0
_limit_51=-1
_term_width_52=80
_has_header_53=0
_page_54=()
_page_count_55=0
_checked_56=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_57=0
_first_render_58=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_59=0
# render_single_page()
render_single_page__1198_v0() {
    local __length_223="${_cursor_49}"
    local cursor_len_16387="${#__length_223}"
    local max_option_width_16388="$(( $(( _term_width_52 - cursor_len_16387 )) - 1 ))"
    local __range_start_16389=0
    local __range_end_16389="${_page_count_55}"
    local __dir_16389=$(( ${__range_start_16389} <= ${__range_end_16389} ? 1 : -1 ))
    for (( i_16389=${__range_start_16389}; i_16389 * ${__dir_16389} < ${__range_end_16389} * ${__dir_16389}; i_16389+=${__dir_16389} )); do
        cutoff_text__1046_v0 "${_page_54[${i_16389}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_16388}"
        local ret_cutoff_text1046_v0__48_27="${ret_cutoff_text1046_v0}"
        local truncated_16390="${ret_cutoff_text1046_v0__48_27}"
        if [ "$(( i_16389 == _selected_48 ))" != 0 ]; then
            colored_secondary__1009_v0 "${_cursor_49}""${truncated_16390}""
"
            local ret_colored_secondary1009_v0__50_21="${ret_colored_secondary1009_v0}"
            local array_224=("")
            eprintf__1026_v0 "${ret_colored_secondary1009_v0__50_21}" array_224[@]
        else
            print_blank__1032_v0 "${cursor_len_16387}"
            local array_225=("")
            eprintf__1026_v0 "${truncated_16390}""
" array_225[@]
        fi
done
    local remaining_slots_16391="$(( _display_count_45 - _page_count_55 ))"
    if [ "$(( remaining_slots_16391 > 0 ))" != 0 ]; then
        local __range_start_16392=0
        local __range_end_16392="${remaining_slots_16391}"
        local __dir_16392=$(( ${__range_start_16392} <= ${__range_end_16392} ? 1 : -1 ))
        for (( ____16392=${__range_start_16392}; ____16392 * ${__dir_16392} < ${__range_end_16392} * ${__dir_16392}; ____16392+=${__dir_16392} )); do
            local array_226=("")
            eprintf__1026_v0 "\\x1b[K
" array_226[@]
done
    fi
}

# render_multi_page()
render_multi_page__1199_v0() {
    local __length_227="${_cursor_49}"
    local cursor_len_16377="${#__length_227}"
    local max_option_width_16378="$(( $(( _term_width_52 - cursor_len_16377 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1204_v0 
    local page_start_16379="${ret_chooser_page_start1204_v0}"
    local __range_start_16380=0
    local __range_end_16380="${_page_count_55}"
    local __dir_16380=$(( ${__range_start_16380} <= ${__range_end_16380} ? 1 : -1 ))
    for (( i_16380=${__range_start_16380}; i_16380 * ${__dir_16380} < ${__range_end_16380} * ${__dir_16380}; i_16380+=${__dir_16380} )); do
        local global_idx_16381="$(( page_start_16379 + i_16380 ))"
        local check_mark_16382
        check_mark_16382="$(if [ "${_checked_56[${global_idx_16381}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1046_v0 "${_page_54[${i_16380}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_16378}"
        local ret_cutoff_text1046_v0__71_27="${ret_cutoff_text1046_v0}"
        local truncated_16383="${ret_cutoff_text1046_v0__71_27}"
        if [ "$(( i_16380 == _selected_48 ))" != 0 ]; then
            colored_secondary__1009_v0 "${_cursor_49}""${check_mark_16382}""${truncated_16383}""
"
            local ret_colored_secondary1009_v0__73_37="${ret_colored_secondary1009_v0}"
            local array_228=("")
            eprintf__1026_v0 "${ret_colored_secondary1009_v0__73_37}" array_228[@]
        elif [ "${_checked_56[${global_idx_16381}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1032_v0 "${cursor_len_16377}"
            colored_secondary__1009_v0 "${check_mark_16382}""${truncated_16383}""
"
            local ret_colored_secondary1009_v0__76_25="${ret_colored_secondary1009_v0}"
            local array_229=("")
            eprintf__1026_v0 "${ret_colored_secondary1009_v0__76_25}" array_229[@]
        else
            print_blank__1032_v0 "${cursor_len_16377}"
            local array_230=("")
            eprintf__1026_v0 "${check_mark_16382}""${truncated_16383}""
" array_230[@]
        fi
done
    local remaining_slots_16385="$(( _display_count_45 - _page_count_55 ))"
    if [ "$(( remaining_slots_16385 > 0 ))" != 0 ]; then
        local __range_start_16386=0
        local __range_end_16386="${remaining_slots_16385}"
        local __dir_16386=$(( ${__range_start_16386} <= ${__range_end_16386} ? 1 : -1 ))
        for (( ____16386=${__range_start_16386}; ____16386 * ${__dir_16386} < ${__range_end_16386} * ${__dir_16386}; ____16386+=${__dir_16386} )); do
            local array_231=("")
            eprintf__1026_v0 "\\x1b[K
" array_231[@]
done
    fi
}

# render_page()
render_page__1200_v0() {
    if [ "${_multi_50}" != 0 ]; then
        render_multi_page__1199_v0 
    else
        render_single_page__1198_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1201_v0() {
    if [ "$(( _total_pages_46 > 1 ))" != 0 ]; then
        local array_232=("")
        eprintf__1026_v0 "\\x1b[G\\x1b[K" array_232[@]
        eprintf_colored__1027_v0 "Page $(( _current_page_47 + 1 ))/${_total_pages_46}" 90
        local array_233=("")
        eprintf__1026_v0 "\\x1b[G" array_233[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1202_v0() {
    if [ "$(( ! _multi_50 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_46 > 1 ))" != 0 ]; then
            local array_234=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1047_v0 array_234[@] 36 "${_term_width_52}"
        else
            local array_235=("↑↓" "select" "enter" "confirm")
            render_tooltip__1047_v0 array_235[@] 25 "${_term_width_52}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_46 > 1 )) && $(( _limit_51 < 0 )) ))" != 0 ]; then
            local array_236=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1047_v0 array_236[@] 55 "${_term_width_52}"
        elif [ "$(( _total_pages_46 > 1 ))" != 0 ]; then
            local array_237=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1047_v0 array_237[@] 47 "${_term_width_52}"
        elif [ "$(( _limit_51 < 0 ))" != 0 ]; then
            local array_238=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1047_v0 array_238[@] 44 "${_term_width_52}"
        else
            local array_239=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1047_v0 array_239[@] 36 "${_term_width_52}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1203_v0() {
    local total_16316="${1}"
    local page_size_16317="${2}"
    local header_16318="${3}"
    local cursor_16319="${4}"
    local multi_16320="${5}"
    local limit_16321="${6}"
    _total_43="${total_16316}"
    _cursor_49="${cursor_16319}"
    _multi_50="${multi_16320}"
    _limit_51="${limit_16321}"
    _current_page_47=0
    _selected_48=0
    _first_render_58=1
    _up_paged_59=0
    _checked_count_57=0
    _has_header_53="$([ "_${header_16318}" == "_" ]; echo $?)"
    stty_lock__985_v0 
    hide_cursor__1037_v0 
    term_width__992_v0 
    _term_width_52="${ret_term_width992_v0}"
    term_height__993_v0 
    local term_height_16324="${ret_term_height993_v0}"
    local max_page_size_16325
    max_page_size_16325="$(( term_height_16324 - $(if [ "${_has_header_53}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_44="${page_size_16317}"
    if [ "$(( _page_size_44 > max_page_size_16325 ))" != 0 ]; then
        _page_size_44="${max_page_size_16325}"
    fi
    if [ "${_has_header_53}" != 0 ]; then
        cutoff_text__1046_v0 "${header_16318}" "${_term_width_52}"
        local ret_cutoff_text1046_v0__157_17="${ret_cutoff_text1046_v0}"
        local array_240=("")
        eprintf__1026_v0 "${ret_cutoff_text1046_v0__157_17}""
" array_240[@]
    fi
    math_floor__510_v0 "$(( $(( $(( total_16316 + _page_size_44 )) - 1 )) / _page_size_44 ))"
    _total_pages_46="${ret_math_floor510_v0}"
    _display_count_45="${_page_size_44}"
    if [ "$(( total_16316 < _page_size_44 ))" != 0 ]; then
        _display_count_45="${total_16316}"
    fi
    if [ "${multi_16320}" != 0 ]; then
        _checked_56=()
        local __range_start_16352=0
        local __range_end_16352="${total_16316}"
        local __dir_16352=$(( ${__range_start_16352} <= ${__range_end_16352} ? 1 : -1 ))
        for (( ____16352=${__range_start_16352}; ____16352 * ${__dir_16352} < ${__range_end_16352} * ${__dir_16352}; ____16352+=${__dir_16352} )); do
            local array_242=(0)
            _checked_56+=("${array_242[@]}")
done
    fi
    new_line__1033_v0 "${_display_count_45}"
    local array_243=("")
    eprintf__1026_v0 "\\x1b[G" array_243[@]
    if [ "$(( _total_pages_46 > 1 ))" != 0 ]; then
        eprintf_colored__1027_v0 "Page $(( _current_page_47 + 1 ))/${_total_pages_46}" 90
    fi
    new_line__1033_v0 1
    render_tooltip_line__1202_v0 
    go_up__1034_v0 "$(( _display_count_45 + 1 ))"
    local array_244=("")
    eprintf__1026_v0 "\\x1b[G" array_244[@]
}

# chooser_page_start()
chooser_page_start__1204_v0() {
    ret_chooser_page_start1204_v0="$(( _current_page_47 * _page_size_44 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1205_v0() {
    chooser_page_start__1204_v0 
    local start_16372="${ret_chooser_page_start1204_v0}"
    local end_16373="$(( start_16372 + _page_size_44 ))"
    if [ "$(( end_16373 > _total_43 ))" != 0 ]; then
        end_16373="${_total_43}"
    fi
    ret_chooser_page_count1205_v0="$(( end_16373 - start_16372 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1206_v0() {
    local page_16376=("${!1}")
    _page_54=("${page_16376[@]}")
    local __length_245=("${page_16376[@]}")
    _page_count_55="${#__length_245[@]}"
    if [ "${_first_render_58}" != 0 ]; then
        _first_render_58=0
        render_page__1200_v0 
    else
        if [ "${_up_paged_59}" != 0 ]; then
            _selected_48="$(( _page_count_55 - 1 ))"
            _up_paged_59=0
        fi
        go_up__1034_v0 1
        remove_line__1030_v0 "$(( _display_count_45 - 1 ))"
        remove_current_line__1031_v0 
        local array_246=("")
        eprintf__1026_v0 "\\x1b[G" array_246[@]
        render_page__1200_v0 
        render_page_indicator__1201_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1207_v0() {
    local prev_selected_16408="${1}"
    chooser_page_start__1204_v0 
    local page_start_16409="${ret_chooser_page_start1204_v0}"
    local check_width_16410
    check_width_16410="$(if [ "${_multi_50}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_247="${_cursor_49}"
    local max_option_width_16411="$(( $(( _term_width_52 - ${#__length_247} )) - check_width_16410 ))"
    go_up__1034_v0 "$(( _display_count_45 - prev_selected_16408 ))"
    local array_248=("")
    eprintf__1026_v0 "\\x1b[K" array_248[@]
    local __length_249="${_cursor_49}"
    print_blank__1032_v0 "${#__length_249}"
    if [ "${_multi_50}" != 0 ]; then
        local was_checked_16412="${_checked_56[$(( page_start_16409 + prev_selected_16408 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1046_v0 "${_page_54[${prev_selected_16408}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_16411}"
        local ret_cutoff_text1046_v0__232_63="${ret_cutoff_text1046_v0}"
        local prev_line_16413
        prev_line_16413="$(if [ "${was_checked_16412}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1046_v0__232_63}"
        if [ "${was_checked_16412}" != 0 ]; then
            colored_secondary__1009_v0 "${prev_line_16413}"
            local ret_colored_secondary1009_v0__234_21="${ret_colored_secondary1009_v0}"
            local array_250=("")
            eprintf__1026_v0 "${ret_colored_secondary1009_v0__234_21}" array_250[@]
        else
            local array_251=("")
            eprintf__1026_v0 "${prev_line_16413}" array_251[@]
        fi
    else
        cutoff_text__1046_v0 "${_page_54[${prev_selected_16408}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_16411}"
        local ret_cutoff_text1046_v0__239_17="${ret_cutoff_text1046_v0}"
        local array_252=("")
        eprintf__1026_v0 "${ret_cutoff_text1046_v0__239_17}" array_252[@]
    fi
    go_up_or_down__1036_v0 "$(( _selected_48 - prev_selected_16408 ))"
    local array_253=("")
    eprintf__1026_v0 "\\x1b[G" array_253[@]
    local array_254=("")
    eprintf__1026_v0 "\\x1b[K" array_254[@]
    local mark_16415
    mark_16415="$(if [ "${_multi_50}" != 0 ]; then echo "$(if [ "${_checked_56[$(( page_start_16409 + _selected_48 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1046_v0 "${_page_54[${_selected_48}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_16411}"
    local ret_cutoff_text1046_v0__246_48="${ret_cutoff_text1046_v0}"
    colored_secondary__1009_v0 "${_cursor_49}""${mark_16415}""${ret_cutoff_text1046_v0__246_48}"
    local ret_colored_secondary1009_v0__246_13="${ret_colored_secondary1009_v0}"
    local array_255=("")
    eprintf__1026_v0 "${ret_colored_secondary1009_v0__246_13}" array_255[@]
    go_down__1035_v0 "$(( _display_count_45 - _selected_48 ))"
    local array_256=("")
    eprintf__1026_v0 "\\x1b[G" array_256[@]
}

# redraw_current_line()
redraw_current_line__1208_v0() {
    chooser_page_start__1204_v0 
    local page_start_16402="${ret_chooser_page_start1204_v0}"
    local __length_257="${_cursor_49}"
    local max_option_width_16403="$(( $(( _term_width_52 - ${#__length_257} )) - 3 ))"
    go_up__1034_v0 "$(( _display_count_45 - _selected_48 ))"
    local array_258=("")
    eprintf__1026_v0 "\\x1b[G" array_258[@]
    local array_259=("")
    eprintf__1026_v0 "\\x1b[K" array_259[@]
    local check_mark_16404
    check_mark_16404="$(if [ "${_checked_56[$(( page_start_16402 + _selected_48 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1046_v0 "${_page_54[${_selected_48}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_16403}"
    local ret_cutoff_text1046_v0__260_54="${ret_cutoff_text1046_v0}"
    colored_secondary__1009_v0 "${_cursor_49}""${check_mark_16404}""${ret_cutoff_text1046_v0__260_54}"
    local ret_colored_secondary1009_v0__260_13="${ret_colored_secondary1009_v0}"
    local array_260=("")
    eprintf__1026_v0 "${ret_colored_secondary1009_v0__260_13}" array_260[@]
    go_down__1035_v0 "$(( _display_count_45 - _selected_48 ))"
    local array_261=("")
    eprintf__1026_v0 "\\x1b[G" array_261[@]
}

# chooser_step()
chooser_step__1209_v0() {
    get_key__1024_v0 
    local key_16397="${ret_get_key1024_v0}"
    local prev_selected_16398="${_selected_48}"
    local prev_page_16399="${_current_page_47}"
    chooser_page_start__1204_v0 
    local page_start_16400="${ret_chooser_page_start1204_v0}"
    _up_paged_59=0
    if [ "$(( $([ "_${key_16397}" != "_UP" ]; echo $?) || $([ "_${key_16397}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_48 == 0 )) && $(( _total_pages_46 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_47 > 0 ))" != 0 ]; then
                _current_page_47="$(( _current_page_47 - 1 ))"
            else
                _current_page_47="$(( _total_pages_46 - 1 ))"
            fi
            _up_paged_59=1
        elif [ "$(( _selected_48 == 0 ))" != 0 ]; then
            _selected_48="$(( _page_count_55 - 1 ))"
        else
            _selected_48="$(( _selected_48 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_16397}" != "_DOWN" ]; echo $?) || $([ "_${key_16397}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_48 == $(( _page_count_55 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_47 < $(( _total_pages_46 - 1 )) ))" != 0 ]; then
                _current_page_47="$(( _current_page_47 + 1 ))"
            else
                _current_page_47=0
            fi
            _selected_48=0
        else
            _selected_48="$(( _selected_48 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_16397}" != "_LEFT" ]; echo $?) || $([ "_${key_16397}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_47 > 0 ))" != 0 ]; then
            _current_page_47="$(( _current_page_47 - 1 ))"
        fi
        _selected_48=0
    elif [ "$(( $([ "_${key_16397}" != "_RIGHT" ]; echo $?) || $([ "_${key_16397}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_47 < $(( _total_pages_46 - 1 )) ))" != 0 ]; then
            _current_page_47="$(( _current_page_47 + 1 ))"
            _selected_48=0
        else
            _selected_48="$(( _page_count_55 - 1 ))"
        fi
    elif [ "$(( _multi_50 && $(( $([ "_${key_16397}" != "_x" ]; echo $?) || $([ "_${key_16397}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_16401="$(( page_start_16400 + _selected_48 ))"
        if [ "${_checked_56[${global_selected_16401}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_56["${global_selected_16401}"]=0
            _checked_count_57="$(( _checked_count_57 - 1 ))"
        elif [ "$(( $(( _limit_51 < 0 )) || $(( _checked_count_57 < _limit_51 )) ))" != 0 ]; then
            _checked_56["${global_selected_16401}"]=1
            _checked_count_57="$(( _checked_count_57 + 1 ))"
        else
            ret_chooser_step1209_v0="${__CHOOSER_CONTINUE_40}"
            return 0
        fi
        redraw_current_line__1208_v0 
        ret_chooser_step1209_v0="${__CHOOSER_CONTINUE_40}"
        return 0
    elif [ "$(( $(( _multi_50 && $(( $([ "_${key_16397}" != "_a" ]; echo $?) || $([ "_${key_16397}" != "_A" ]; echo $?) )) )) && $(( _limit_51 < 0 )) ))" != 0 ]; then
        local all_checked_16406="$(( _checked_count_57 == _total_43 ))"
        local __range_start_16407=0
        local __range_end_16407="${_total_43}"
        local __dir_16407=$(( ${__range_start_16407} <= ${__range_end_16407} ? 1 : -1 ))
        for (( i_16407=${__range_start_16407}; i_16407 * ${__dir_16407} < ${__range_end_16407} * ${__dir_16407}; i_16407+=${__dir_16407} )); do
            _checked_56["${i_16407}"]="$(( ! all_checked_16406 ))"
done
        _checked_count_57="$(if [ "${all_checked_16406}" != 0 ]; then echo 0; else echo "${_total_43}"; fi)"
        go_up__1034_v0 "${_display_count_45}"
        local array_262=("")
        eprintf__1026_v0 "\\x1b[G" array_262[@]
        render_page__1200_v0 
        ret_chooser_step1209_v0="${__CHOOSER_CONTINUE_40}"
        return 0
    elif [ "$([ "_${key_16397}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1209_v0="${__CHOOSER_DONE_42}"
        return 0
    else
        ret_chooser_step1209_v0="${__CHOOSER_CONTINUE_40}"
        return 0
    fi
    if [ "$(( prev_page_16399 != _current_page_47 ))" != 0 ]; then
        ret_chooser_step1209_v0="${__CHOOSER_NEED_PAGE_41}"
        return 0
    fi
    if [ "$(( prev_selected_16398 != _selected_48 ))" != 0 ]; then
        redraw_selection__1207_v0 "${prev_selected_16398}"
    fi
    ret_chooser_step1209_v0="${__CHOOSER_CONTINUE_40}"
    return 0
}

# chooser_selected()
chooser_selected__1210_v0() {
    chooser_page_start__1204_v0 
    local ret_chooser_page_start1204_v0__362_12="${ret_chooser_page_start1204_v0}"
    ret_chooser_selected1210_v0="$(( ret_chooser_page_start1204_v0__362_12 + _selected_48 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1211_v0() {
    local index_16421="${1}"
    ret_chooser_is_checked1211_v0="${_checked_56[${index_16421}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1212_v0() {
    local total_lines_16417="$(( _display_count_45 + 2 ))"
    if [ "${_has_header_53}" != 0 ]; then
        total_lines_16417="$(( total_lines_16417 + 1 ))"
    fi
    go_down__1035_v0 1
    remove_line__1030_v0 "$(( total_lines_16417 - 1 ))"
    remove_current_line__1031_v0 
    stty_unlock__986_v0 
    show_cursor__1038_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1221_v0() {
    local options_16425=("${!1}")
    local cursor_16426="${2}"
    local header_16427="${3}"
    local page_size_16428="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_263=("${options_16425[@]}")
    local total_16429="${#__length_263[@]}"
    if [ "$(( total_16429 == 0 ))" != 0 ]; then
        eprintf_colored__1027_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1203_v0 "${total_16429}" "${page_size_16428}" "${header_16427}" "${cursor_16426}" 0 -1
    local need_page_16430=1
    while :
    do
        if [ "${need_page_16430}" != 0 ]; then
            local page_16431=()
            chooser_page_start__1204_v0 
            local start_16432="${ret_chooser_page_start1204_v0}"
            chooser_page_count__1205_v0 
            local count_16433="${ret_chooser_page_count1205_v0}"
            local __range_start_16434="${start_16432}"
            local __range_end_16434="$(( start_16432 + count_16433 ))"
            local __dir_16434=$(( ${__range_start_16434} <= ${__range_end_16434} ? 1 : -1 ))
            for (( i_16434=${__range_start_16434}; i_16434 * ${__dir_16434} < ${__range_end_16434} * ${__dir_16434}; i_16434+=${__dir_16434} )); do
                local array_265=("${options_16425[${i_16434}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_16431+=("${array_265[@]}")
done
            chooser_set_page__1206_v0 page_16431[@]
        fi
        chooser_step__1209_v0 
        local step_16435="${ret_chooser_step1209_v0}"
        if [ "$(( step_16435 == __CHOOSER_DONE_42 ))" != 0 ]; then
            break
        fi
        need_page_16430="$(( step_16435 == __CHOOSER_NEED_PAGE_41 ))"
    done
    chooser_selected__1210_v0 
    local selected_16436="${ret_chooser_selected1210_v0}"
    chooser_end__1212_v0 
    ret_xyl_choose1221_v0="${options_16425[${selected_16436}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1222_v0() {
    local options_16310=("${!1}")
    local cursor_16311="${2}"
    local header_16312="${3}"
    local limit_16313="${4}"
    local page_size_16314="${5}"
    local __length_266=("${options_16310[@]}")
    local total_16315="${#__length_266[@]}"
    if [ "$(( total_16315 == 0 ))" != 0 ]; then
        eprintf_colored__1027_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1222_v0=()
        return 0
    fi
    chooser_begin__1203_v0 "${total_16315}" "${page_size_16314}" "${header_16312}" "${cursor_16311}" 1 "${limit_16313}"
    local need_page_16369=1
    while :
    do
        if [ "${need_page_16369}" != 0 ]; then
            local page_16370=()
            chooser_page_start__1204_v0 
            local start_16371="${ret_chooser_page_start1204_v0}"
            chooser_page_count__1205_v0 
            local count_16374="${ret_chooser_page_count1205_v0}"
            local __range_start_16375="${start_16371}"
            local __range_end_16375="$(( start_16371 + count_16374 ))"
            local __dir_16375=$(( ${__range_start_16375} <= ${__range_end_16375} ? 1 : -1 ))
            for (( i_16375=${__range_start_16375}; i_16375 * ${__dir_16375} < ${__range_end_16375} * ${__dir_16375}; i_16375+=${__dir_16375} )); do
                local array_269=("${options_16310[${i_16375}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_16370+=("${array_269[@]}")
done
            chooser_set_page__1206_v0 page_16370[@]
        fi
        chooser_step__1209_v0 
        local step_16416="${ret_chooser_step1209_v0}"
        if [ "$(( step_16416 == __CHOOSER_DONE_42 ))" != 0 ]; then
            break
        fi
        need_page_16369="$(( step_16416 == __CHOOSER_NEED_PAGE_41 ))"
    done
    chooser_end__1212_v0 
    local result_16419=()
    local __range_start_16420=0
    local __range_end_16420="${total_16315}"
    local __dir_16420=$(( ${__range_start_16420} <= ${__range_end_16420} ? 1 : -1 ))
    for (( i_16420=${__range_start_16420}; i_16420 * ${__dir_16420} < ${__range_end_16420} * ${__dir_16420}; i_16420+=${__dir_16420} )); do
        chooser_is_checked__1211_v0 "${i_16420}"
        local ret_chooser_is_checked1211_v0__93_12="${ret_chooser_is_checked1211_v0}"
        if [ "${ret_chooser_is_checked1211_v0__93_12}" != 0 ]; then
            local array_271=("${options_16310[${i_16420}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_16419+=("${array_271[@]}")
        fi
done
    ret_xyl_multi_choose1222_v0=("${result_16419[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1317_v0() {
    local usage_16243=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1050_v0 usage_16243[@]
    printf '%s\n' ""
    colored_primary__1008_v0 "choose"
    local ret_colored_primary1008_v0__8_20="${ret_colored_primary1008_v0}"
    local title_16267=("${ret_colored_primary1008_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1050_v0 title_16267[@]
    printf '%s\n' ""
    colored_secondary__1009_v0 "Arguments:"
    local ret_colored_secondary1009_v0__11_12="${ret_colored_secondary1009_v0}"
    local array_274=()
    printf__128_v0 "${ret_colored_secondary1009_v0__11_12}""
" array_274[@]
    local arg_names_16269=("[<options> ...]")
    local arg_texts_16270=("List of options to choose from")
    local arg_notes_16271=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1049_v0 arg_names_16269[@] arg_texts_16270[@] arg_notes_16271[@] 20
    printf '%s\n' ""
    colored_secondary__1009_v0 "Flags:"
    local ret_colored_secondary1009_v0__18_12="${ret_colored_secondary1009_v0}"
    local array_278=()
    printf__128_v0 "${ret_colored_secondary1009_v0__18_12}""
" array_278[@]
    local names_16299=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_16300=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_16301=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1049_v0 names_16299[@] texts_16300[@] notes_16301[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1369_v0() {
    local options_16236=()
    local command_283
    command_283="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_16237="${command_283}"
    if [ "$([ "_${is_tty_16237}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_16236+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1369_v0=("${options_16236[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1370_v0() {
    local parameters_16220=("${!1}")
    local cursor_16221="> "
    colored_primary__1008_v0 "Choose: "
    local ret_colored_primary1008_v0__17_30="${ret_colored_primary1008_v0}"
    local header_16235="\\x1b[1m""${ret_colored_primary1008_v0__17_30}"
    read_stdin_options__1369_v0 
    local options_16238=("${ret_read_stdin_options1369_v0[@]}")
    local multi_16239=0
    local limit_16240=-1
    local page_size_16241=10
    local __length_287=("${parameters_16220[@]}")
    local slice_upper_286="${#__length_287[@]}"
    local slice_offset_288=2
    local slice_offset_288=$((${slice_offset_288} > 0 ? ${slice_offset_288} : 0))
    local slice_length_289="$(( slice_upper_286 - slice_offset_288 ))"
    local slice_length_289=$((${slice_length_289} > 0 ? ${slice_length_289} : 0))
    for param_16242 in "${parameters_16220[@]:${slice_offset_288}:${slice_length_289}}"; do
        starts_with__22_v0 "${param_16242}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16242}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16242}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16242}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16242}" != "_-h" ]; echo $?) || $([ "_${param_16242}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1317_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_290="--cursor="
            slice__24_v0 "${param_16242}" "${#__length_290}" 0
            cursor_16221="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_291="--header="
            slice__24_v0 "${param_16242}" "${#__length_291}" 0
            header_16235="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_292="--limit="
            slice__24_v0 "${param_16242}" "${#__length_292}" 0
            local value_16302="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16302}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1027_v0 "ERROR: Invalid limit value: ""${value_16302}""
" 31
                exit 1
            fi
            limit_16240="${ret_parse_int13_v0}"
            multi_16239=1
        elif [ "$([ "_${param_16242}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_16239=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_293="--page-size="
            slice__24_v0 "${param_16242}" "${#__length_293}" 0
            local value_16307="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16307}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1027_v0 "ERROR: Invalid page-size value: ""${value_16307}""
" 31
                exit 1
            fi
            page_size_16241="${ret_parse_int13_v0}"
        else
            options_16238+=("${param_16242}")
        fi
    done
    has_ansi_escape__1039_v0 "${header_16235}"
    local ret_has_ansi_escape1039_v0__59_44="${ret_has_ansi_escape1039_v0}"
    escape_ansi__1040_v0 "${header_16235}"
    local ret_escape_ansi1040_v0__59_73="${ret_escape_ansi1040_v0}"
    colored_primary__1008_v0 "${header_16235}"
    local ret_colored_primary1008_v0__59_111="${ret_colored_primary1008_v0}"
    local display_header_16309
    display_header_16309="$(if [ "$(( $([ "_${header_16235}" != "_" ]; echo $?) || ret_has_ansi_escape1039_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1040_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1008_v0__59_111}"; fi)"
    if [ "${multi_16239}" != 0 ]; then
        xyl_multi_choose__1222_v0 options_16238[@] "${cursor_16221}" "${display_header_16309}" "${limit_16240}" "${page_size_16241}"
        local results_16422=("${ret_xyl_multi_choose1222_v0[@]}")
        join__7_v0 results_16422[@] "
"
        ret_execute_choose1370_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1221_v0 options_16238[@] "${cursor_16221}" "${display_header_16309}" "${page_size_16241}"
    ret_execute_choose1370_v0="${ret_xyl_choose1221_v0}"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_67="None"
# perl_available()
perl_available__1545_v0() {
    if [ "$([ "_${_perl_state_67}" != "_None" ]; echo $?)" != 0 ]; then
        local command_295
        command_295="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18274
        disabled_18274="$([ "_${command_295}" != "_No" ]; echo $?)"
        local command_296
        command_296="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18275
        found_18275="$(( $(( ! disabled_18274 )) && $([ "_${command_296}" != "_0" ]; echo $?) ))"
        _perl_state_67="$(if [ "${found_18275}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1545_v0="$([ "_${_perl_state_67}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1546_v0() {
    local text_18273="${1}"
    perl_available__1545_v0 
    local ret_perl_available1545_v0__22_12="${ret_perl_available1545_v0}"
    if [ "$(( ! ret_perl_available1545_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1546_v0=''
        return 1
    fi
    local command_297
    command_297="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18273}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1546_v0=''
        return "${__status}"
    fi
    local width_str_18276="${command_297}"
    parse_int__13_v0 "${width_str_18276}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1546_v0=''
        return "${__status}"
    fi
    local width_18277="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1546_v0="${width_18277}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1547_v0() {
    local text_18330="${1}"
    local max_width_18331="${2}"
    perl_available__1545_v0 
    local ret_perl_available1545_v0__33_12="${ret_perl_available1545_v0}"
    if [ "$(( ! ret_perl_available1545_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1547_v0=''
        return 1
    fi
    local command_298
    command_298="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18330}" ${max_width_18331} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1547_v0=''
        return "${__status}"
    fi
    local result_18332="${command_298}"
    ret_perl_truncate_cjk1547_v0="${result_18332}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_68=0
_term_size_69=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1554_v0() {
    local command_300
    command_300="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_18319="${command_300}"
    parse_int__13_v0 "${count_18319}"
    __status=$?
    ret_stty_count1554_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1555_v0() {
    stty_count__1554_v0 
    local count_num_18320="${ret_stty_count1554_v0}"
    if [ "$(( count_num_18320 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_18320="$(( count_num_18320 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18320}
    __status=$?
}

# stty_unlock()
stty_unlock__1556_v0() {
    stty_count__1554_v0 
    local count_num_18396="${ret_stty_count1554_v0}"
    if [ "$(( count_num_18396 > 0 ))" != 0 ]; then
        count_num_18396="$(( count_num_18396 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18396}
        __status=$?
        if [ "$(( count_num_18396 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1557_v0() {
    local size_18257="${1}"
    if [ "$([ "_${size_18257}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1557_v0=0
        return 0
    fi
    split__4_v0 "${size_18257}" " "
    local parts_18258=("${ret_split4_v0[@]}")
    local __length_301=("${parts_18258[@]}")
    if [ "$(( ${#__length_301[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1557_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18258[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18258[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_69=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1557_v0=1
    return 0
}

# query_term_size()
query_term_size__1558_v0() {
    local command_303
    command_303="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18260="${command_303}"
    store_term_size__1557_v0 "${size_18260}"
    ret_query_term_size1558_v0="${ret_store_term_size1557_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1559_v0() {
    local command_304
    command_304="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18256="${command_304}"
    store_term_size__1557_v0 "${size_18256}"
    ret_stty_term_size1559_v0="${ret_store_term_size1557_v0}"
    return 0
}

# get_term_size()
get_term_size__1560_v0() {
    stty_term_size__1559_v0 
    local detected_18259="${ret_stty_term_size1559_v0}"
    if [ "$(( ! detected_18259 ))" != 0 ]; then
        query_term_size__1558_v0 
        detected_18259="${ret_query_term_size1558_v0}"
    fi
    _got_term_size_68=1
}

# term_width()
term_width__1562_v0() {
    if [ "$(( ! _got_term_size_68 ))" != 0 ]; then
        get_term_size__1560_v0 
    fi
    ret_term_width1562_v0="${_term_size_69[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_70="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_71=0
_primary_color_72=(3 207 159 92)
_secondary_color_73=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1573_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_18250="${ret_env_var_get120_v0}"
    _supports_truecolor_70="$(if [ "$([ "_${config_18250}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1573_v0="$([ "_${_supports_truecolor_70}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1574_v0() {
    local message_18245="${1}"
    local r_18246="${2}"
    local g_18247="${3}"
    local b_18248="${4}"
    local fallback_18249="${5}"
    if [ "$([ "_${_supports_truecolor_70}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1574_v0="\\x1b[38;2;${r_18246};${g_18247};${b_18248}m""${message_18245}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_70}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1573_v0 
        local ret_get_supports_truecolor1573_v0__45_17="${ret_get_supports_truecolor1573_v0}"
        if [ "${ret_get_supports_truecolor1573_v0__45_17}" != 0 ]; then
            ret_colored_rgb1574_v0="\\x1b[38;2;${r_18246};${g_18247};${b_18248}m""${message_18245}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_18249 == 0 ))" != 0 ]; then
            ret_colored_rgb1574_v0="${message_18245}"
            return 0
        else
            ret_colored_rgb1574_v0="\\x1b[${fallback_18249}m""${message_18245}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_18249 == 0 ))" != 0 ]; then
            ret_colored_rgb1574_v0="${message_18245}"
            return 0
        fi
        ret_colored_rgb1574_v0="\\x1b[${fallback_18249}m""${message_18245}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1575_v0() {
    local message_18369="${1}"
    local r_18370="${2}"
    local g_18371="${3}"
    local b_18372="${4}"
    local fallback_18373="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_18374="${fallback_18373}"
    if [ "$(( $(( fallback_18373 >= 30 )) && $(( fallback_18373 <= 37 )) ))" != 0 ]; then
        bg_fallback_18374="$(( fallback_18373 + 10 ))"
    fi
    if [ "$(( $(( fallback_18373 >= 90 )) && $(( fallback_18373 <= 97 )) ))" != 0 ]; then
        bg_fallback_18374="$(( fallback_18373 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_70}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1575_v0="\\x1b[48;2;${r_18370};${g_18371};${b_18372}m""${message_18369}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_70}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1573_v0 
        local ret_get_supports_truecolor1573_v0__87_17="${ret_get_supports_truecolor1573_v0}"
        if [ "${ret_get_supports_truecolor1573_v0__87_17}" != 0 ]; then
            ret_background_rgb1575_v0="\\x1b[48;2;${r_18370};${g_18371};${b_18372}m""${message_18369}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_18374 == 0 ))" != 0 ]; then
            ret_background_rgb1575_v0="${message_18369}"
            return 0
        else
            ret_background_rgb1575_v0="\\x1b[${bg_fallback_18374}m""${message_18369}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_18374 == 0 ))" != 0 ]; then
            ret_background_rgb1575_v0="${message_18369}"
            return 0
        fi
        ret_background_rgb1575_v0="\\x1b[${bg_fallback_18374}m""${message_18369}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1576_v0() {
    if [ "$(( ! _got_xylitol_colors_71 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_18239="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_18239}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_18239}" ";"
            local parts_18240=("${ret_split4_v0[@]}")
            local __length_308=("${parts_18240[@]}")
            if [ "$(( ${#__length_308[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18240[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18240[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18240[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18240[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_72=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_18241="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_18241}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_18241}" ";"
            local parts_18242=("${ret_split4_v0[@]}")
            local __length_310=("${parts_18242[@]}")
            if [ "$(( ${#__length_310[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18242[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18242[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18242[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18242[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_73=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_18243="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_18243}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_18243}" ";"
            local parts_18244=("${ret_split4_v0[@]}")
            local __length_312=("${parts_18244[@]}")
            if [ "$(( ${#__length_312[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18244[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18244[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18244[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18244[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1576_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_71=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1577_v0() {
    inner_get_xylitol_colors__1576_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_71=1
}

# colored_primary(message: Text)
colored_primary__1578_v0() {
    local message_18238="${1}"
    if [ "$(( ! _got_xylitol_colors_71 ))" != 0 ]; then
        get_xylitol_colors__1577_v0 
    fi
    colored_rgb__1574_v0 "${message_18238}" "${_primary_color_72[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_72[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_72[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_72[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1578_v0="${ret_colored_rgb1574_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1579_v0() {
    local message_18279="${1}"
    if [ "$(( ! _got_xylitol_colors_71 ))" != 0 ]; then
        get_xylitol_colors__1577_v0 
    fi
    colored_rgb__1574_v0 "${message_18279}" "${_secondary_color_73[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_73[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_73[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_73[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1579_v0="${ret_colored_rgb1574_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1582_v0() {
    local message_18368="${1}"
    if [ "$(( ! _got_xylitol_colors_71 ))" != 0 ]; then
        get_xylitol_colors__1577_v0 
    fi
    background_rgb__1575_v0 "${message_18368}" "${_secondary_color_73[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_73[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_73[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_73[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary1582_v0="${ret_background_rgb1575_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1594_v0() {
    local command_314
    command_314="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_18389="${command_314}"
    if [ "$([ "_${var_18389}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1594_v0="UP"
        return 0
    elif [ "$([ "_${var_18389}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1594_v0="DOWN"
        return 0
    elif [ "$([ "_${var_18389}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1594_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_18389}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1594_v0="LEFT"
        return 0
    elif [ "$([ "_${var_18389}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1594_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_18389}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1594_v0="INPUT"
        return 0
    else
        ret_get_key1594_v0="${var_18389}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1596_v0() {
    local format_18313="${1}"
    local args_18314=("${!2}")
    args_18314=("${format_18313}" "${args_18314[@]}")
    __status=$?
    printf "${args_18314[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1597_v0() {
    local message_18311="${1}"
    local color_18312="${2}"
    # Prints an error message with a specified color.
    local array_315=("${message_18311}")
    eprintf__1596_v0 "\\x1b[${color_18312}m%s\\x1b[0m" array_315[@]
}

# colored(message: Text, color: Int)
colored__1598_v0() {
    local message_18308="${1}"
    local color_18309="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1598_v0="\\x1b[${color_18309}m""${message_18308}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1600_v0() {
    local cnt_18393="${1}"
    if [ "$(( cnt_18393 > 0 ))" != 0 ]; then
        local sequence_18394=""
        local __range_start_18395=0
        local __range_end_18395="${cnt_18393}"
        local __dir_18395=$(( ${__range_start_18395} <= ${__range_end_18395} ? 1 : -1 ))
        for (( ____18395=${__range_start_18395}; ____18395 * ${__dir_18395} < ${__range_end_18395} * ${__dir_18395}; ____18395+=${__dir_18395} )); do
            sequence_18394+="\\x1b[2K\\x1b[1A"
done
        local array_316=("")
        eprintf__1596_v0 "${sequence_18394}" array_316[@]
    fi
    local array_317=("")
    eprintf__1596_v0 "\\x1b[G" array_317[@]
}

# remove_current_line()
remove_current_line__1601_v0() {
    local array_318=("")
    eprintf__1596_v0 "\\x1b[2K\\x1b[G" array_318[@]
}

# go_up(cnt: Int)
go_up__1604_v0() {
    local cnt_18388="${1}"
    local array_319=("")
    eprintf__1596_v0 "\\x1b[${cnt_18388}A" array_319[@]
}

# go_down(cnt: Int)
go_down__1605_v0() {
    local cnt_18392="${1}"
    local array_320=("")
    eprintf__1596_v0 "\\x1b[${cnt_18392}B" array_320[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1607_v0() {
    local array_321=("")
    eprintf__1596_v0 "\\x1b[?25l" array_321[@]
}

# show_cursor()
show_cursor__1608_v0() {
    local array_322=("")
    eprintf__1596_v0 "\\x1b[?25h" array_322[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1609_v0() {
    local text_18266="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_323
    command_323="$([[ "${text_18266}" == *$'\x1b'* || "${text_18266}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18267="${command_323}"
    ret_has_ansi_escape1609_v0="$([ "_${has_escape_18267}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1610_v0() {
    local text_18315="${1}"
    local command_324
    command_324="$(printf '%s' "${text_18315}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1610_v0="${command_324}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1611_v0() {
    local text_18269="${1}"
    local command_325
    command_325="$(printf "%s" "${text_18269}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1611_v0="${command_325}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1612_v0() {
    local text_18271="${1}"
    local command_326
    command_326="$(printf "%s" "${text_18271}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18272="${command_326}"
    ret_is_all_ascii1612_v0="$([ "_${result_18272}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1613_v0() {
    local text_18268="${1}"
    strip_ansi__1611_v0 "${text_18268}"
    local stripped_18270="${ret_strip_ansi1611_v0}"
    # Check if text is all ASCII
    is_all_ascii__1612_v0 "${stripped_18270}"
    local ret_is_all_ascii1612_v0__150_12="${ret_is_all_ascii1612_v0}"
    if [ "$(( ! ret_is_all_ascii1612_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1546_v0 "${stripped_18270}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_327="${stripped_18270}"
            ret_get_visible_len1613_v0="${#__length_327}"
            return 0
        fi
        ret_get_visible_len1613_v0="${ret_perl_get_cjk_width1546_v0}"
        return 0
    else
        local __length_328="${stripped_18270}"
        ret_get_visible_len1613_v0="${#__length_328}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1614_v0() {
    local text_18327="${1}"
    local max_width_18328="${2}"
    get_visible_len__1613_v0 "${text_18327}"
    local visible_len_18329="${ret_get_visible_len1613_v0}"
    if [ "$(( visible_len_18329 <= max_width_18328 ))" != 0 ]; then
        ret_truncate_text1614_v0="${text_18327}"
        return 0
    fi
    is_all_ascii__1612_v0 "${text_18327}"
    local ret_is_all_ascii1612_v0__167_12="${ret_is_all_ascii1612_v0}"
    if [ "$(( ! ret_is_all_ascii1612_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1547_v0 "${text_18327}" "${max_width_18328}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18327}" | cut -c1-${max_width_18328}
            __status=$?
        fi
        ret_truncate_text1614_v0="${ret_perl_truncate_cjk1547_v0}"
        return 0
    fi
    local command_329
    command_329="$(printf "%s" "${text_18327}" | cut -c1-${max_width_18328})"
    __status=$?
    ret_truncate_text1614_v0="${command_329}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1615_v0() {
    local text_18325="${1}"
    local max_width_18326="${2}"
    has_ansi_escape__1609_v0 "${text_18325}"
    local ret_has_ansi_escape1609_v0__179_12="${ret_has_ansi_escape1609_v0}"
    if [ "$(( ! ret_has_ansi_escape1609_v0__179_12 ))" != 0 ]; then
        truncate_text__1614_v0 "${text_18325}" "${max_width_18326}"
        ret_truncate_ansi1615_v0="${ret_truncate_text1614_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_330
    command_330="$([[ "${text_18325}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18333="${command_330}"
    # Replace \x1b[ with newline, then split
    local command_331
    command_331="$(t="${text_18325}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18334="${command_331}"
    split__4_v0 "${replaced_18334}" "
"
    local parts_18335=("${ret_split4_v0[@]}")
    local result_18336=""
    local remaining_width_18337="${max_width_18326}"
    local __range_start_18338=0
    local __length_332=("${parts_18335[@]}")
    local __range_end_18338="${#__length_332[@]}"
    local __dir_18338=$(( ${__range_start_18338} <= ${__range_end_18338} ? 1 : -1 ))
    for (( idx_18338=${__range_start_18338}; idx_18338 * ${__dir_18338} < ${__range_end_18338} * ${__dir_18338}; idx_18338+=${__dir_18338} )); do
        local part_18339="${parts_18335[${idx_18338}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18338 == 0 )) && $([ "_${starts_with_ansi_18333}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18339}" == "_" ]; echo $?) && $(( remaining_width_18337 > 0 )) ))" != 0 ]; then
                truncate_text__1614_v0 "${part_18339}" "${remaining_width_18337}"
                local ret_truncate_text1614_v0__201_35="${ret_truncate_text1614_v0}"
                local truncated_18340="${ret_truncate_text1614_v0__201_35}"
                result_18336+="${truncated_18340}"
                get_visible_len__1613_v0 "${truncated_18340}"
                local ret_get_visible_len1613_v0__203_36="${ret_get_visible_len1613_v0}"
                remaining_width_18337="$(( remaining_width_18337 - ret_get_visible_len1613_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_333
            command_333="$(__p="${part_18339}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18341="${command_333}"
            if [ "$([ "_${m_idx_18341}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_334
                command_334="$(__p="${part_18339}"; printf "%s" "${__p:0:${m_idx_18341}}")"
                __status=$?
                local ansi_params_18342="${command_334}"
                result_18336+="\\x1b[""${ansi_params_18342}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18341}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_18343="${ret_parse_int13_v0__214_41}"
                local text_start_18344="$(( m_idx_num_18343 + 1 ))"
                local command_335
                command_335="$(__p="${part_18339}"; printf "%s" "${__p:${text_start_18344}}")"
                __status=$?
                local text_part_18345="${command_335}"
                if [ "$(( $([ "_${text_part_18345}" == "_" ]; echo $?) && $(( remaining_width_18337 > 0 )) ))" != 0 ]; then
                    truncate_text__1614_v0 "${text_part_18345}" "${remaining_width_18337}"
                    local ret_truncate_text1614_v0__218_39="${ret_truncate_text1614_v0}"
                    local truncated_18346="${ret_truncate_text1614_v0__218_39}"
                    result_18336+="${truncated_18346}"
                    get_visible_len__1613_v0 "${truncated_18346}"
                    local ret_get_visible_len1613_v0__220_40="${ret_get_visible_len1613_v0}"
                    remaining_width_18337="$(( remaining_width_18337 - ret_get_visible_len1613_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18339}" == "_" ]; echo $?) && $(( remaining_width_18337 > 0 )) ))" != 0 ]; then
                    truncate_text__1614_v0 "${part_18339}" "${remaining_width_18337}"
                    local ret_truncate_text1614_v0__225_39="${ret_truncate_text1614_v0}"
                    local truncated_18347="${ret_truncate_text1614_v0__225_39}"
                    result_18336+="${truncated_18347}"
                    get_visible_len__1613_v0 "${truncated_18347}"
                    local ret_get_visible_len1613_v0__227_40="${ret_get_visible_len1613_v0}"
                    remaining_width_18337="$(( remaining_width_18337 - ret_get_visible_len1613_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1615_v0="${result_18336}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1616_v0() {
    local text_18322="${1}"
    local max_width_18323="${2}"
    get_visible_len__1613_v0 "${text_18322}"
    local visible_len_18324="${ret_get_visible_len1613_v0}"
    if [ "$(( visible_len_18324 <= max_width_18323 ))" != 0 ]; then
        ret_cutoff_text1616_v0="${text_18322}"
        return 0
    fi
    truncate_ansi__1615_v0 "${text_18322}" "$(( max_width_18323 - 3 ))"
    local ret_truncate_ansi1615_v0__243_12="${ret_truncate_ansi1615_v0}"
    ret_cutoff_text1616_v0="${ret_truncate_ansi1615_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1617_v0() {
    local items_18375=("${!1}")
    local total_len_18376="${2}"
    local term_width_18377="${3}"
    local separator_18378=" • "
    local separator_len_18379=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18376 <= term_width_18377 ))" != 0 ]; then
        local iter_18380=0
        while :
        do
            local __length_336=("${items_18375[@]}")
            if [ "$(( iter_18380 >= ${#__length_336[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18380 > 0 ))" != 0 ]; then
                eprintf_colored__1597_v0 "${separator_18378}" 90
            fi
            colored__1598_v0 "${items_18375[$(( iter_18380 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1598_v0__268_41="${ret_colored1598_v0}"
            local array_337=("")
            eprintf__1596_v0 "${items_18375[${iter_18380}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1598_v0__268_41}" array_337[@]
            iter_18380="$(( iter_18380 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18381=0
        local first_18382=1
        local iter_18383=0
        while :
        do
            local __length_338=("${items_18375[@]}")
            if [ "$(( iter_18383 >= ${#__length_338[@]} ))" != 0 ]; then
                break
            fi
            local key_18384="${items_18375[${iter_18383}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_18385="${items_18375[$(( iter_18383 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_339="${key_18384}"
            local __length_340="${action_18385}"
            local part_len_18386="$(( $(( ${#__length_339} + 1 )) + ${#__length_340} ))"
            local needed_18387="${part_len_18386}"
            if [ "$(( ! first_18382 ))" != 0 ]; then
                needed_18387="$(( needed_18387 + separator_len_18379 ))"
            fi
            if [ "$(( $(( current_len_18381 + needed_18387 )) > term_width_18377 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18382 ))" != 0 ]; then
                eprintf_colored__1597_v0 "${separator_18378}" 90
            fi
            colored__1598_v0 "${action_18385}" 2
            local ret_colored1598_v0__296_33="${ret_colored1598_v0}"
            local array_341=("")
            eprintf__1596_v0 "${key_18384}"" ""${ret_colored1598_v0__296_33}" array_341[@]
            current_len_18381="$(( current_len_18381 + needed_18387 ))"
            first_18382=0
            iter_18383="$(( iter_18383 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1618_v0() {
    local pending_18305="${1}"
    local line_18306="${2}"
    local note_at_18307="${3}"
    if [ "$(( note_at_18307 < 0 ))" != 0 ]; then
        local array_342=()
        printf__128_v0 "${pending_18305}""${line_18306}""
" array_342[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_18307 == 0 ))" != 0 ]; then
        colored__1598_v0 "${line_18306}" 90
        local ret_colored1598_v0__310_40="${ret_colored1598_v0}"
        local array_343=()
        printf__128_v0 "${pending_18305}""${ret_colored1598_v0__310_40}""
" array_343[@]
    else
        slice__24_v0 "${line_18306}" 0 "${note_at_18307}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_18306}" "${note_at_18307}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1598_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1598_v0__311_58="${ret_colored1598_v0}"
        local array_344=()
        printf__128_v0 "${pending_18305}""${ret_slice24_v0__311_32}""${ret_colored1598_v0__311_58}""
" array_344[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1619_v0() {
    local names_18283=("${!1}")
    local texts_18284=("${!2}")
    local notes_18285=("${!3}")
    local min_name_width_18286="${4}"
    local __length_345=("${names_18283[@]}")
    local count_18287="${#__length_345[@]}"
    local name_width_18288="${min_name_width_18286}"
    local __range_start_18289=0
    local __range_end_18289="${count_18287}"
    local __dir_18289=$(( ${__range_start_18289} <= ${__range_end_18289} ? 1 : -1 ))
    for (( i_18289=${__range_start_18289}; i_18289 * ${__dir_18289} < ${__range_end_18289} * ${__dir_18289}; i_18289+=${__dir_18289} )); do
        local __length_346="${names_18283[${i_18289}]?"Index out of bounds (at src/./confirm/../utils.ab:326:33)"}"
        local width_18290="${#__length_346}"
        if [ "$(( width_18290 > name_width_18288 ))" != 0 ]; then
            name_width_18288="${width_18290}"
        fi
done
    term_width__1562_v0 
    local width_18291="${ret_term_width1562_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_18292="$(( name_width_18288 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_18293="$(( $(( width_18291 - indent_18292 )) < 24 ))"
    if [ "${stacked_18293}" != 0 ]; then
        indent_18292=6
    fi
    local avail_18294="$(( width_18291 - indent_18292 ))"
    rpad__28_v0 "" " " "${indent_18292}"
    local blank_18295="${ret_rpad28_v0}"
    local __range_start_18296=0
    local __range_end_18296="${count_18287}"
    local __dir_18296=$(( ${__range_start_18296} <= ${__range_end_18296} ? 1 : -1 ))
    for (( i_18296=${__range_start_18296}; i_18296 * ${__dir_18296} < ${__range_end_18296} * ${__dir_18296}; i_18296+=${__dir_18296} )); do
        local pending_18297="${blank_18295}"
        if [ "${stacked_18293}" != 0 ]; then
            local array_347=()
            printf__128_v0 "  ""${names_18283[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:346:33)"}""
" array_347[@]
        else
            rpad__28_v0 "  ""${names_18283[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:348:41)"}" " " "${indent_18292}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_18297="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_18284[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_18298=("${ret_split4_v0__350_21[@]}")
        local __length_348=("${words_18298[@]}")
        local note_start_18299="${#__length_348[@]}"
        if [ "$([ "_${notes_18285[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_349="${notes_18285[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_349} > avail_18294 ))" != 0 ]; then
                split__4_v0 "${notes_18285[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_18298+=("${ret_split4_v0__356_26[@]}")
            else
                local array_350=("${notes_18285[${i_18296}]?"Index out of bounds (at src/./confirm/../utils.ab:358:33)"}")
                words_18298+=("${array_350[@]}")
            fi
        fi
        local line_18300=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_18301=-1
        local __range_start_18302=0
        local __length_351=("${words_18298[@]}")
        local __range_end_18302="${#__length_351[@]}"
        local __dir_18302=$(( ${__range_start_18302} <= ${__range_end_18302} ? 1 : -1 ))
        for (( j_18302=${__range_start_18302}; j_18302 * ${__dir_18302} < ${__range_end_18302} * ${__dir_18302}; j_18302+=${__dir_18302} )); do
            local word_18303="${words_18298[${j_18302}]?"Index out of bounds (at src/./confirm/../utils.ab:368:32)"}"
            local candidate_18304
            candidate_18304="$(if [ "$([ "_${line_18300}" != "_" ]; echo $?)" != 0 ]; then echo "${word_18303}"; else echo "${line_18300}"" ""${word_18303}"; fi)"
            local __length_352="${candidate_18304}"
            if [ "$(( $(( ${#__length_352} > avail_18294 )) && $([ "_${line_18300}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1618_v0 "${pending_18297}" "${line_18300}" "${note_at_18301}"
                pending_18297="${blank_18295}"
                line_18300="${word_18303}"
                note_at_18301="$(if [ "$(( j_18302 >= note_start_18299 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_18302 >= note_start_18299 )) && $(( note_at_18301 < 0 )) ))" != 0 ]; then
                    local __length_353="${candidate_18304}"
                    local __length_354="${word_18303}"
                    note_at_18301="$(( ${#__length_353} - ${#__length_354} ))"
                fi
                line_18300="${candidate_18304}"
            fi
done
        print_help_line__1618_v0 "${pending_18297}" "${line_18300}" "${note_at_18301}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1620_v0() {
    local pieces_18255=("${!1}")
    term_width__1562_v0 
    local width_18261="${ret_term_width1562_v0}"
    local line_18262=""
    local line_len_18263=0
    for piece_18264 in "${pieces_18255[@]}"; do
        local __length_357="${piece_18264}"
        local piece_len_18265="${#__length_357}"
        has_ansi_escape__1609_v0 "${piece_18264}"
        local ret_has_ansi_escape1609_v0__397_12="${ret_has_ansi_escape1609_v0}"
        if [ "${ret_has_ansi_escape1609_v0__397_12}" != 0 ]; then
            get_visible_len__1613_v0 "${piece_18264}"
            piece_len_18265="${ret_get_visible_len1613_v0}"
        fi
        if [ "$([ "_${line_18262}" != "_" ]; echo $?)" != 0 ]; then
            line_18262="${piece_18264}"
            line_len_18263="${piece_len_18265}"
        elif [ "$(( $(( $(( line_len_18263 + 1 )) + piece_len_18265 )) > width_18261 ))" != 0 ]; then
            local array_358=()
            printf__128_v0 "${line_18262}""
" array_358[@]
            line_18262="${piece_18264}"
            line_len_18263="${piece_len_18265}"
        else
            line_18262+=" ""${piece_18264}"
            line_len_18263="$(( line_len_18263 + $(( 1 + piece_len_18265 )) ))"
        fi
    done
    if [ "$([ "_${line_18262}" == "_" ]; echo $?)" != 0 ]; then
        local array_359=()
        printf__128_v0 "${line_18262}""
" array_359[@]
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1671_v0() {
    local selected_18349="${1}"
    local term_width_18350="${2}"
    local small_18351="$(( term_width_18350 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_18351}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_18365="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_18351}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_18366="${ret_cpad29_v0}"
    local gap_18367
    gap_18367="$(if [ "${small_18351}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_360=("")
    eprintf__1596_v0 " " array_360[@]
    if [ "${selected_18349}" != 0 ]; then
        # Yes selected
        background_secondary__1582_v0 "${yes_label_18365}"
        local ret_background_secondary1582_v0__16_30="${ret_background_secondary1582_v0}"
        local array_361=("")
        eprintf__1596_v0 "\\x1b[97m""${ret_background_secondary1582_v0__16_30}" array_361[@]
        local array_362=("")
        eprintf__1596_v0 "${gap_18367}" array_362[@]
        # No not selected (dim)
        local array_363=("")
        eprintf__1596_v0 "\\x1b[49;37m""${no_label_18366}""\\x1b[0m" array_363[@]
    else
        # No selected
        local array_364=("")
        eprintf__1596_v0 "\\x1b[49;37m""${yes_label_18365}""\\x1b[0m" array_364[@]
        local array_365=("")
        eprintf__1596_v0 "${gap_18367}" array_365[@]
        background_secondary__1582_v0 "${no_label_18366}"
        local ret_background_secondary1582_v0__24_30="${ret_background_secondary1582_v0}"
        local array_366=("")
        eprintf__1596_v0 "\\x1b[97m""${ret_background_secondary1582_v0__24_30}" array_366[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1672_v0() {
    local header_18317="${1}"
    local default_yes_18318="${2}"
    stty_lock__1555_v0 
    hide_cursor__1607_v0 
    term_width__1562_v0 
    local term_width_18321="${ret_term_width1562_v0}"
    if [ "$([ "_${header_18317}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1616_v0 "${header_18317}" "${term_width_18321}"
        local ret_cutoff_text1616_v0__46_17="${ret_cutoff_text1616_v0}"
        local array_367=("")
        eprintf__1596_v0 "${ret_cutoff_text1616_v0__46_17}""

" array_367[@]
    fi
    local selected_18348="${default_yes_18318}"
    # Render initial options
    render_confirm_options__1671_v0 "${selected_18348}" "${term_width_18321}"
    local array_368=("")
    eprintf__1596_v0 "

" array_368[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_369=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1617_v0 array_369[@] 40 "${term_width_18321}"
    go_up__1604_v0 2
    while :
    do
        get_key__1594_v0 
        local key_18390="${ret_get_key1594_v0}"
        if [ "$(( $(( $(( $([ "_${key_18390}" != "_LEFT" ]; echo $?) || $([ "_${key_18390}" != "_h" ]; echo $?) )) || $([ "_${key_18390}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_18390}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_18348}" != 0 ]; then
                selected_18348=0
                local array_370=("")
                eprintf__1596_v0 "\\x1b[G\\x1b[K" array_370[@]
                render_confirm_options__1671_v0 "${selected_18348}" "${term_width_18321}"
            elif [ "$(( ! selected_18348 ))" != 0 ]; then
                selected_18348=1
                local array_371=("")
                eprintf__1596_v0 "\\x1b[G\\x1b[K" array_371[@]
                render_confirm_options__1671_v0 "${selected_18348}" "${term_width_18321}"
            fi
        elif [ "$(( $([ "_${key_18390}" != "_y" ]; echo $?) || $([ "_${key_18390}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_18348=1
            break
        elif [ "$(( $([ "_${key_18390}" != "_n" ]; echo $?) || $([ "_${key_18390}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_18348=0
            break
        elif [ "$([ "_${key_18390}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_18391=4
    if [ "$([ "_${header_18317}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_18391="$(( total_lines_18391 + 1 ))"
    fi
    go_down__1605_v0 2
    remove_line__1600_v0 "$(( total_lines_18391 - 1 ))"
    remove_current_line__1601_v0 
    stty_unlock__1556_v0 
    show_cursor__1608_v0 
    ret_xyl_confirm1672_v0="${selected_18348}"
    return 0
}

# print_confirm_help()
print_confirm_help__1766_v0() {
    local usage_18254=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1620_v0 usage_18254[@]
    printf '%s\n' ""
    colored_primary__1578_v0 "confirm"
    local ret_colored_primary1578_v0__8_20="${ret_colored_primary1578_v0}"
    local title_18278=("${ret_colored_primary1578_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1620_v0 title_18278[@]
    printf '%s\n' ""
    colored_secondary__1579_v0 "Flags:"
    local ret_colored_secondary1579_v0__11_12="${ret_colored_secondary1579_v0}"
    local array_374=()
    printf__128_v0 "${ret_colored_secondary1579_v0__11_12}""
" array_374[@]
    local names_18280=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_18281=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_18282=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__1619_v0 names_18280[@] texts_18281[@] notes_18282[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1818_v0() {
    local parameters_18237=("${!1}")
    colored_primary__1578_v0 "Are you sure?"
    local ret_colored_primary1578_v0__9_30="${ret_colored_primary1578_v0}"
    local header_18251="\\x1b[1m""${ret_colored_primary1578_v0__9_30}"
    local default_yes_18252=1
    for param_18253 in "${parameters_18237[@]}"; do
        starts_with__22_v0 "${param_18253}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_18253}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_18253}" != "_-h" ]; echo $?) || $([ "_${param_18253}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1766_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_380="--header="
            slice__24_v0 "${param_18253}" "${#__length_380}" 0
            header_18251="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_381="--default="
            slice__24_v0 "${param_18253}" "${#__length_381}" 0
            local value_18310="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_18310}" != "_yes" ]; echo $?) || $([ "_${value_18310}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_18252=1
            elif [ "$(( $([ "_${value_18310}" != "_no" ]; echo $?) || $([ "_${value_18310}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_18252=0
            else
                eprintf_colored__1597_v0 "ERROR: Invalid default value: ""${value_18310}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1609_v0 "${header_18251}"
    local ret_has_ansi_escape1609_v0__35_44="${ret_has_ansi_escape1609_v0}"
    escape_ansi__1610_v0 "${header_18251}"
    local ret_escape_ansi1610_v0__35_73="${ret_escape_ansi1610_v0}"
    colored_primary__1578_v0 "${header_18251}"
    local ret_colored_primary1578_v0__35_111="${ret_colored_primary1578_v0}"
    local display_header_18316
    display_header_18316="$(if [ "$(( $([ "_${header_18251}" != "_" ]; echo $?) || ret_has_ansi_escape1609_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1610_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1578_v0__35_111}"; fi)"
    xyl_confirm__1672_v0 "${display_header_18316}" "${default_yes_18252}"
    local result_18397="${ret_xyl_confirm1672_v0}"
    ret_execute_confirm1818_v0="$(if [ "${result_18397}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_78=3
# get_directory_entries(path: Text)
get_directory_entries__1973_v0() {
    local path_27832="${1}"
    local __ls_path_382="${path_27832}"
    __ls_path_382="${__ls_path_382//\\/\\\\}"
    (( 1 )) && __ls_all_382="-A" || __ls_all_382=""
    (( 0 )) && __ls_rec_382="-R" || __ls_rec_382=""
    local __ls_382=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_382 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_382} ${__ls_rec_382} ${__ls_path_382}
    __status=$?
    );
    local names_27833=("${__ls_382[@]}")
    local command_383
    command_383="$(LC_ALL=C ls -lA "${path_27832}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_27834="${command_383}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_384
    command_384="$(LC_ALL=C ls -lA "${path_27832}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_27835="${command_384}"
    split__4_v0 "${types_output_27834}" "
"
    local types_27836=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_27835}" "
"
    local targets_27837=("${ret_split4_v0[@]}")
    local entries_27838=()
    local __range_start_27839=0
    local __length_386=("${names_27833[@]}")
    local __range_end_27839="${#__length_386[@]}"
    local __dir_27839=$(( ${__range_start_27839} <= ${__range_end_27839} ? 1 : -1 ))
    for (( i_27839=${__range_start_27839}; i_27839 * ${__dir_27839} < ${__range_end_27839} * ${__dir_27839}; i_27839+=${__dir_27839} )); do
        local array_387=("${names_27833[${i_27839}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_27838+=("${array_387[@]}")
        local array_388=("${types_27836[${i_27839}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_27838+=("${array_388[@]}")
        slice__24_v0 "${targets_27837[${i_27839}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_389=("${ret_slice24_v0__31_21}")
        entries_27838+=("${array_389[@]}")
done
    ret_get_directory_entries1973_v0=("${entries_27838[@]}")
    return 0
}

# get_cwd()
get_cwd__1974_v0() {
    local command_390
    command_390="$(pwd)"
    __status=$?
    ret_get_cwd1974_v0="${command_390}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1975_v0() {
    local path_27830="${1}"
    local command_391
    command_391="$(cd "${path_27830}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_27831="${command_391}"
    if [ "$([ "_${normalized_27831}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1975_v0="${path_27830}"
        return 0
    fi
    ret_normalize_path1975_v0="${normalized_27831}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1976_v0() {
    local base_27999="${1}"
    local child_28000="${2}"
    if [ "$([ "_${base_27999}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1976_v0="/""${child_28000}"
        return 0
    fi
    ret_path_join1976_v0="${base_27999}""/""${child_28000}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1977_v0() {
    local path_27997="${1}"
    local command_392
    command_392="$(dirname "${path_27997}")"
    __status=$?
    local parent_27998="${command_392}"
    ret_get_parent_dir1977_v0="${parent_27998}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_80="None"
# perl_available()
perl_available__1985_v0() {
    if [ "$([ "_${_perl_state_80}" != "_None" ]; echo $?)" != 0 ]; then
        local command_393
        command_393="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27766
        disabled_27766="$([ "_${command_393}" != "_No" ]; echo $?)"
        local command_394
        command_394="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27767
        found_27767="$(( $(( ! disabled_27766 )) && $([ "_${command_394}" != "_0" ]; echo $?) ))"
        _perl_state_80="$(if [ "${found_27767}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1985_v0="$([ "_${_perl_state_80}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1986_v0() {
    local text_27765="${1}"
    perl_available__1985_v0 
    local ret_perl_available1985_v0__22_12="${ret_perl_available1985_v0}"
    if [ "$(( ! ret_perl_available1985_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1986_v0=''
        return 1
    fi
    local command_395
    command_395="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27765}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1986_v0=''
        return "${__status}"
    fi
    local width_str_27768="${command_395}"
    parse_int__13_v0 "${width_str_27768}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1986_v0=''
        return "${__status}"
    fi
    local width_27769="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1986_v0="${width_27769}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_81=0
_term_size_82=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1994_v0() {
    local command_397
    command_397="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27827="${command_397}"
    parse_int__13_v0 "${count_27827}"
    __status=$?
    ret_stty_count1994_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1995_v0() {
    stty_count__1994_v0 
    local count_num_27828="${ret_stty_count1994_v0}"
    if [ "$(( count_num_27828 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_27828="$(( count_num_27828 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27828}
    __status=$?
}

# stty_unlock()
stty_unlock__1996_v0() {
    stty_count__1994_v0 
    local count_num_27849="${ret_stty_count1994_v0}"
    if [ "$(( count_num_27849 > 0 ))" != 0 ]; then
        count_num_27849="$(( count_num_27849 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27849}
        __status=$?
        if [ "$(( count_num_27849 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1997_v0() {
    local size_27749="${1}"
    if [ "$([ "_${size_27749}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1997_v0=0
        return 0
    fi
    split__4_v0 "${size_27749}" " "
    local parts_27750=("${ret_split4_v0[@]}")
    local __length_398=("${parts_27750[@]}")
    if [ "$(( ${#__length_398[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1997_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27750[1]?"Index out of bounds (at src/./file/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27750[0]?"Index out of bounds (at src/./file/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_82=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1997_v0=1
    return 0
}

# query_term_size()
query_term_size__1998_v0() {
    local command_400
    command_400="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27752="${command_400}"
    store_term_size__1997_v0 "${size_27752}"
    ret_query_term_size1998_v0="${ret_store_term_size1997_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1999_v0() {
    local command_401
    command_401="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27748="${command_401}"
    store_term_size__1997_v0 "${size_27748}"
    ret_stty_term_size1999_v0="${ret_store_term_size1997_v0}"
    return 0
}

# get_term_size()
get_term_size__2000_v0() {
    stty_term_size__1999_v0 
    local detected_27751="${ret_stty_term_size1999_v0}"
    if [ "$(( ! detected_27751 ))" != 0 ]; then
        query_term_size__1998_v0 
        detected_27751="${ret_query_term_size1998_v0}"
    fi
    _got_term_size_81=1
}

# term_width()
term_width__2002_v0() {
    if [ "$(( ! _got_term_size_81 ))" != 0 ]; then
        get_term_size__2000_v0 
    fi
    ret_term_width2002_v0="${_term_size_82[0]?"Index out of bounds (at src/./file/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_83="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_84=0
_primary_color_85=(3 207 159 92)
_secondary_color_86=(3 118 206 94)
_accent_color_87=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__2013_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_27782="${ret_env_var_get120_v0}"
    _supports_truecolor_83="$(if [ "$([ "_${config_27782}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2013_v0="$([ "_${_supports_truecolor_83}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2014_v0() {
    local message_27777="${1}"
    local r_27778="${2}"
    local g_27779="${3}"
    local b_27780="${4}"
    local fallback_27781="${5}"
    if [ "$([ "_${_supports_truecolor_83}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2014_v0="\\x1b[38;2;${r_27778};${g_27779};${b_27780}m""${message_27777}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_83}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2013_v0 
        local ret_get_supports_truecolor2013_v0__45_17="${ret_get_supports_truecolor2013_v0}"
        if [ "${ret_get_supports_truecolor2013_v0__45_17}" != 0 ]; then
            ret_colored_rgb2014_v0="\\x1b[38;2;${r_27778};${g_27779};${b_27780}m""${message_27777}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27781 == 0 ))" != 0 ]; then
            ret_colored_rgb2014_v0="${message_27777}"
            return 0
        else
            ret_colored_rgb2014_v0="\\x1b[${fallback_27781}m""${message_27777}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27781 == 0 ))" != 0 ]; then
            ret_colored_rgb2014_v0="${message_27777}"
            return 0
        fi
        ret_colored_rgb2014_v0="\\x1b[${fallback_27781}m""${message_27777}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2016_v0() {
    if [ "$(( ! _got_xylitol_colors_84 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27771="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27771}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27771}" ";"
            local parts_27772=("${ret_split4_v0[@]}")
            local __length_405=("${parts_27772[@]}")
            if [ "$(( ${#__length_405[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27772[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27772[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27772[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27772[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_85=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_27773="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27773}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27773}" ";"
            local parts_27774=("${ret_split4_v0[@]}")
            local __length_407=("${parts_27774[@]}")
            if [ "$(( ${#__length_407[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27774[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27774[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27774[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27774[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_86=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_27775="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27775}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27775}" ";"
            local parts_27776=("${ret_split4_v0[@]}")
            local __length_409=("${parts_27776[@]}")
            if [ "$(( ${#__length_409[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27776[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27776[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27776[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27776[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2016_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_87=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_84=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2017_v0() {
    inner_get_xylitol_colors__2016_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_84=1
}

# colored_primary(message: Text)
colored_primary__2018_v0() {
    local message_27770="${1}"
    if [ "$(( ! _got_xylitol_colors_84 ))" != 0 ]; then
        get_xylitol_colors__2017_v0 
    fi
    colored_rgb__2014_v0 "${message_27770}" "${_primary_color_85[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_85[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_85[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_85[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2018_v0="${ret_colored_rgb2014_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2019_v0() {
    local message_27784="${1}"
    if [ "$(( ! _got_xylitol_colors_84 ))" != 0 ]; then
        get_xylitol_colors__2017_v0 
    fi
    colored_rgb__2014_v0 "${message_27784}" "${_secondary_color_86[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_86[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_86[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_86[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2019_v0="${ret_colored_rgb2014_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2020_v0() {
    local message_27937="${1}"
    if [ "$(( ! _got_xylitol_colors_84 ))" != 0 ]; then
        get_xylitol_colors__2017_v0 
    fi
    colored_rgb__2014_v0 "${message_27937}" "${_accent_color_87[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_87[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_87[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_87[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent2020_v0="${ret_colored_rgb2014_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__2036_v0() {
    local format_27821="${1}"
    local args_27822=("${!2}")
    args_27822=("${format_27821}" "${args_27822[@]}")
    __status=$?
    printf "${args_27822[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2037_v0() {
    local message_27819="${1}"
    local color_27820="${2}"
    # Prints an error message with a specified color.
    local array_411=("${message_27819}")
    eprintf__2036_v0 "\\x1b[${color_27820}m%s\\x1b[0m" array_411[@]
}

# colored(message: Text, color: Int)
colored__2038_v0() {
    local message_27813="${1}"
    local color_27814="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2038_v0="\\x1b[${color_27814}m""${message_27813}""\\x1b[0m"
    return 0
}

# remove_current_line()
remove_current_line__2041_v0() {
    local array_412=("")
    eprintf__2036_v0 "\\x1b[2K\\x1b[G" array_412[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2049_v0() {
    local text_27758="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_413
    command_413="$([[ "${text_27758}" == *$'\x1b'* || "${text_27758}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27759="${command_413}"
    ret_has_ansi_escape2049_v0="$([ "_${has_escape_27759}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2051_v0() {
    local text_27761="${1}"
    local command_414
    command_414="$(printf "%s" "${text_27761}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2051_v0="${command_414}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2052_v0() {
    local text_27763="${1}"
    local command_415
    command_415="$(printf "%s" "${text_27763}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27764="${command_415}"
    ret_is_all_ascii2052_v0="$([ "_${result_27764}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2053_v0() {
    local text_27760="${1}"
    strip_ansi__2051_v0 "${text_27760}"
    local stripped_27762="${ret_strip_ansi2051_v0}"
    # Check if text is all ASCII
    is_all_ascii__2052_v0 "${stripped_27762}"
    local ret_is_all_ascii2052_v0__150_12="${ret_is_all_ascii2052_v0}"
    if [ "$(( ! ret_is_all_ascii2052_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1986_v0 "${stripped_27762}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_416="${stripped_27762}"
            ret_get_visible_len2053_v0="${#__length_416}"
            return 0
        fi
        ret_get_visible_len2053_v0="${ret_perl_get_cjk_width1986_v0}"
        return 0
    else
        local __length_417="${stripped_27762}"
        ret_get_visible_len2053_v0="${#__length_417}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2058_v0() {
    local pending_27810="${1}"
    local line_27811="${2}"
    local note_at_27812="${3}"
    if [ "$(( note_at_27812 < 0 ))" != 0 ]; then
        local array_418=()
        printf__128_v0 "${pending_27810}""${line_27811}""
" array_418[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27812 == 0 ))" != 0 ]; then
        colored__2038_v0 "${line_27811}" 90
        local ret_colored2038_v0__310_40="${ret_colored2038_v0}"
        local array_419=()
        printf__128_v0 "${pending_27810}""${ret_colored2038_v0__310_40}""
" array_419[@]
    else
        slice__24_v0 "${line_27811}" 0 "${note_at_27812}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27811}" "${note_at_27812}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__2038_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored2038_v0__311_58="${ret_colored2038_v0}"
        local array_420=()
        printf__128_v0 "${pending_27810}""${ret_slice24_v0__311_32}""${ret_colored2038_v0__311_58}""
" array_420[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2059_v0() {
    local names_27788=("${!1}")
    local texts_27789=("${!2}")
    local notes_27790=("${!3}")
    local min_name_width_27791="${4}"
    local __length_421=("${names_27788[@]}")
    local count_27792="${#__length_421[@]}"
    local name_width_27793="${min_name_width_27791}"
    local __range_start_27794=0
    local __range_end_27794="${count_27792}"
    local __dir_27794=$(( ${__range_start_27794} <= ${__range_end_27794} ? 1 : -1 ))
    for (( i_27794=${__range_start_27794}; i_27794 * ${__dir_27794} < ${__range_end_27794} * ${__dir_27794}; i_27794+=${__dir_27794} )); do
        local __length_422="${names_27788[${i_27794}]?"Index out of bounds (at src/./file/../utils.ab:326:33)"}"
        local width_27795="${#__length_422}"
        if [ "$(( width_27795 > name_width_27793 ))" != 0 ]; then
            name_width_27793="${width_27795}"
        fi
done
    term_width__2002_v0 
    local width_27796="${ret_term_width2002_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27797="$(( name_width_27793 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27798="$(( $(( width_27796 - indent_27797 )) < 24 ))"
    if [ "${stacked_27798}" != 0 ]; then
        indent_27797=6
    fi
    local avail_27799="$(( width_27796 - indent_27797 ))"
    rpad__28_v0 "" " " "${indent_27797}"
    local blank_27800="${ret_rpad28_v0}"
    local __range_start_27801=0
    local __range_end_27801="${count_27792}"
    local __dir_27801=$(( ${__range_start_27801} <= ${__range_end_27801} ? 1 : -1 ))
    for (( i_27801=${__range_start_27801}; i_27801 * ${__dir_27801} < ${__range_end_27801} * ${__dir_27801}; i_27801+=${__dir_27801} )); do
        local pending_27802="${blank_27800}"
        if [ "${stacked_27798}" != 0 ]; then
            local array_423=()
            printf__128_v0 "  ""${names_27788[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:346:33)"}""
" array_423[@]
        else
            rpad__28_v0 "  ""${names_27788[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:348:41)"}" " " "${indent_27797}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_27802="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_27789[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_27803=("${ret_split4_v0__350_21[@]}")
        local __length_424=("${words_27803[@]}")
        local note_start_27804="${#__length_424[@]}"
        if [ "$([ "_${notes_27790[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_425="${notes_27790[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_425} > avail_27799 ))" != 0 ]; then
                split__4_v0 "${notes_27790[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_27803+=("${ret_split4_v0__356_26[@]}")
            else
                local array_426=("${notes_27790[${i_27801}]?"Index out of bounds (at src/./file/../utils.ab:358:33)"}")
                words_27803+=("${array_426[@]}")
            fi
        fi
        local line_27805=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27806=-1
        local __range_start_27807=0
        local __length_427=("${words_27803[@]}")
        local __range_end_27807="${#__length_427[@]}"
        local __dir_27807=$(( ${__range_start_27807} <= ${__range_end_27807} ? 1 : -1 ))
        for (( j_27807=${__range_start_27807}; j_27807 * ${__dir_27807} < ${__range_end_27807} * ${__dir_27807}; j_27807+=${__dir_27807} )); do
            local word_27808="${words_27803[${j_27807}]?"Index out of bounds (at src/./file/../utils.ab:368:32)"}"
            local candidate_27809
            candidate_27809="$(if [ "$([ "_${line_27805}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27808}"; else echo "${line_27805}"" ""${word_27808}"; fi)"
            local __length_428="${candidate_27809}"
            if [ "$(( $(( ${#__length_428} > avail_27799 )) && $([ "_${line_27805}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2058_v0 "${pending_27802}" "${line_27805}" "${note_at_27806}"
                pending_27802="${blank_27800}"
                line_27805="${word_27808}"
                note_at_27806="$(if [ "$(( j_27807 >= note_start_27804 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27807 >= note_start_27804 )) && $(( note_at_27806 < 0 )) ))" != 0 ]; then
                    local __length_429="${candidate_27809}"
                    local __length_430="${word_27808}"
                    note_at_27806="$(( ${#__length_429} - ${#__length_430} ))"
                fi
                line_27805="${candidate_27809}"
            fi
done
        print_help_line__2058_v0 "${pending_27802}" "${line_27805}" "${note_at_27806}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__2060_v0() {
    local pieces_27747=("${!1}")
    term_width__2002_v0 
    local width_27753="${ret_term_width2002_v0}"
    local line_27754=""
    local line_len_27755=0
    for piece_27756 in "${pieces_27747[@]}"; do
        local __length_433="${piece_27756}"
        local piece_len_27757="${#__length_433}"
        has_ansi_escape__2049_v0 "${piece_27756}"
        local ret_has_ansi_escape2049_v0__397_12="${ret_has_ansi_escape2049_v0}"
        if [ "${ret_has_ansi_escape2049_v0__397_12}" != 0 ]; then
            get_visible_len__2053_v0 "${piece_27756}"
            piece_len_27757="${ret_get_visible_len2053_v0}"
        fi
        if [ "$([ "_${line_27754}" != "_" ]; echo $?)" != 0 ]; then
            line_27754="${piece_27756}"
            line_len_27755="${piece_len_27757}"
        elif [ "$(( $(( $(( line_len_27755 + 1 )) + piece_len_27757 )) > width_27753 ))" != 0 ]; then
            local array_434=()
            printf__128_v0 "${line_27754}""
" array_434[@]
            line_27754="${piece_27756}"
            line_len_27755="${piece_len_27757}"
        else
            line_27754+=" ""${piece_27756}"
            line_len_27755="$(( line_len_27755 + $(( 1 + piece_len_27757 )) ))"
        fi
    done
    if [ "$([ "_${line_27754}" == "_" ]; echo $?)" != 0 ]; then
        local array_435=()
        printf__128_v0 "${line_27754}""
" array_435[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_91="None"
# perl_available()
perl_available__2211_v0() {
    if [ "$([ "_${_perl_state_91}" != "_None" ]; echo $?)" != 0 ]; then
        local command_436
        command_436="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27876
        disabled_27876="$([ "_${command_436}" != "_No" ]; echo $?)"
        local command_437
        command_437="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27877
        found_27877="$(( $(( ! disabled_27876 )) && $([ "_${command_437}" != "_0" ]; echo $?) ))"
        _perl_state_91="$(if [ "${found_27877}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2211_v0="$([ "_${_perl_state_91}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2212_v0() {
    local text_27875="${1}"
    perl_available__2211_v0 
    local ret_perl_available2211_v0__22_12="${ret_perl_available2211_v0}"
    if [ "$(( ! ret_perl_available2211_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2212_v0=''
        return 1
    fi
    local command_438
    command_438="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27875}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2212_v0=''
        return "${__status}"
    fi
    local width_str_27878="${command_438}"
    parse_int__13_v0 "${width_str_27878}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2212_v0=''
        return "${__status}"
    fi
    local width_27879="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2212_v0="${width_27879}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2213_v0() {
    local text_27888="${1}"
    local max_width_27889="${2}"
    perl_available__2211_v0 
    local ret_perl_available2211_v0__33_12="${ret_perl_available2211_v0}"
    if [ "$(( ! ret_perl_available2211_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2213_v0=''
        return 1
    fi
    local command_439
    command_439="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27888}" ${max_width_27889} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2213_v0=''
        return "${__status}"
    fi
    local result_27890="${command_439}"
    ret_perl_truncate_cjk2213_v0="${result_27890}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_92=0
_term_size_93=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2220_v0() {
    local command_441
    command_441="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27857="${command_441}"
    parse_int__13_v0 "${count_27857}"
    __status=$?
    ret_stty_count2220_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2221_v0() {
    stty_count__2220_v0 
    local count_num_27858="${ret_stty_count2220_v0}"
    if [ "$(( count_num_27858 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_27858="$(( count_num_27858 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27858}
    __status=$?
}

# stty_unlock()
stty_unlock__2222_v0() {
    stty_count__2220_v0 
    local count_num_27994="${ret_stty_count2220_v0}"
    if [ "$(( count_num_27994 > 0 ))" != 0 ]; then
        count_num_27994="$(( count_num_27994 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27994}
        __status=$?
        if [ "$(( count_num_27994 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2223_v0() {
    local size_27862="${1}"
    if [ "$([ "_${size_27862}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2223_v0=0
        return 0
    fi
    split__4_v0 "${size_27862}" " "
    local parts_27863=("${ret_split4_v0[@]}")
    local __length_442=("${parts_27863[@]}")
    if [ "$(( ${#__length_442[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2223_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27863[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27863[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_93=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size2223_v0=1
    return 0
}

# query_term_size()
query_term_size__2224_v0() {
    local command_444
    command_444="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27865="${command_444}"
    store_term_size__2223_v0 "${size_27865}"
    ret_query_term_size2224_v0="${ret_store_term_size2223_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2225_v0() {
    local command_445
    command_445="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27861="${command_445}"
    store_term_size__2223_v0 "${size_27861}"
    ret_stty_term_size2225_v0="${ret_store_term_size2223_v0}"
    return 0
}

# get_term_size()
get_term_size__2226_v0() {
    stty_term_size__2225_v0 
    local detected_27864="${ret_stty_term_size2225_v0}"
    if [ "$(( ! detected_27864 ))" != 0 ]; then
        query_term_size__2224_v0 
        detected_27864="${ret_query_term_size2224_v0}"
    fi
    _got_term_size_92=1
}

# term_width()
term_width__2228_v0() {
    if [ "$(( ! _got_term_size_92 ))" != 0 ]; then
        get_term_size__2226_v0 
    fi
    ret_term_width2228_v0="${_term_size_93[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__2229_v0() {
    if [ "$(( ! _got_term_size_92 ))" != 0 ]; then
        get_term_size__2226_v0 
    fi
    ret_term_height2229_v0="${_term_size_93[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_94="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_95=0
_secondary_color_97=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2239_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_27958="${ret_env_var_get120_v0}"
    _supports_truecolor_94="$(if [ "$([ "_${config_27958}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2239_v0="$([ "_${_supports_truecolor_94}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2240_v0() {
    local message_27953="${1}"
    local r_27954="${2}"
    local g_27955="${3}"
    local b_27956="${4}"
    local fallback_27957="${5}"
    if [ "$([ "_${_supports_truecolor_94}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2240_v0="\\x1b[38;2;${r_27954};${g_27955};${b_27956}m""${message_27953}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_94}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2239_v0 
        local ret_get_supports_truecolor2239_v0__45_17="${ret_get_supports_truecolor2239_v0}"
        if [ "${ret_get_supports_truecolor2239_v0__45_17}" != 0 ]; then
            ret_colored_rgb2240_v0="\\x1b[38;2;${r_27954};${g_27955};${b_27956}m""${message_27953}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27957 == 0 ))" != 0 ]; then
            ret_colored_rgb2240_v0="${message_27953}"
            return 0
        else
            ret_colored_rgb2240_v0="\\x1b[${fallback_27957}m""${message_27953}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27957 == 0 ))" != 0 ]; then
            ret_colored_rgb2240_v0="${message_27953}"
            return 0
        fi
        ret_colored_rgb2240_v0="\\x1b[${fallback_27957}m""${message_27953}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2242_v0() {
    if [ "$(( ! _got_xylitol_colors_95 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27947="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27947}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27947}" ";"
            local parts_27948=("${ret_split4_v0[@]}")
            local __length_449=("${parts_27948[@]}")
            if [ "$(( ${#__length_449[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27948[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27948[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27948[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27948[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_27949="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27949}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27949}" ";"
            local parts_27950=("${ret_split4_v0[@]}")
            local __length_451=("${parts_27950[@]}")
            if [ "$(( ${#__length_451[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27950[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27950[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27950[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27950[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_97=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_27951="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27951}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27951}" ";"
            local parts_27952=("${ret_split4_v0[@]}")
            local __length_453=("${parts_27952[@]}")
            if [ "$(( ${#__length_453[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27952[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27952[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27952[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27952[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2242_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_95=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2243_v0() {
    inner_get_xylitol_colors__2242_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_95=1
}

# colored_secondary(message: Text)
colored_secondary__2245_v0() {
    local message_27946="${1}"
    if [ "$(( ! _got_xylitol_colors_95 ))" != 0 ]; then
        get_xylitol_colors__2243_v0 
    fi
    colored_rgb__2240_v0 "${message_27946}" "${_secondary_color_97[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_97[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_97[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_97[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2245_v0="${ret_colored_rgb2240_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2260_v0() {
    local command_455
    command_455="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_27971="${command_455}"
    if [ "$([ "_${var_27971}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2260_v0="UP"
        return 0
    elif [ "$([ "_${var_27971}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2260_v0="DOWN"
        return 0
    elif [ "$([ "_${var_27971}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2260_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_27971}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2260_v0="LEFT"
        return 0
    elif [ "$([ "_${var_27971}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2260_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_27971}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2260_v0="INPUT"
        return 0
    else
        ret_get_key2260_v0="${var_27971}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2262_v0() {
    local format_27859="${1}"
    local args_27860=("${!2}")
    args_27860=("${format_27859}" "${args_27860[@]}")
    __status=$?
    printf "${args_27860[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2263_v0() {
    local message_27909="${1}"
    local color_27910="${2}"
    # Prints an error message with a specified color.
    local array_456=("${message_27909}")
    eprintf__2262_v0 "\\x1b[${color_27910}m%s\\x1b[0m" array_456[@]
}

# colored(message: Text, color: Int)
colored__2264_v0() {
    local message_27917="${1}"
    local color_27918="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2264_v0="\\x1b[${color_27918}m""${message_27917}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2266_v0() {
    local cnt_27968="${1}"
    if [ "$(( cnt_27968 > 0 ))" != 0 ]; then
        local sequence_27969=""
        local __range_start_27970=0
        local __range_end_27970="${cnt_27968}"
        local __dir_27970=$(( ${__range_start_27970} <= ${__range_end_27970} ? 1 : -1 ))
        for (( ____27970=${__range_start_27970}; ____27970 * ${__dir_27970} < ${__range_end_27970} * ${__dir_27970}; ____27970+=${__dir_27970} )); do
            sequence_27969+="\\x1b[2K\\x1b[1A"
done
        local array_457=("")
        eprintf__2262_v0 "${sequence_27969}" array_457[@]
    fi
    local array_458=("")
    eprintf__2262_v0 "\\x1b[G" array_458[@]
}

# remove_current_line()
remove_current_line__2267_v0() {
    local array_459=("")
    eprintf__2262_v0 "\\x1b[2K\\x1b[G" array_459[@]
}

# print_blank(cnt: Int)
print_blank__2268_v0() {
    local cnt_27959="${1}"
    printf '%*s' "${cnt_27959}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2269_v0() {
    local cnt_27907="${1}"
    local __range_start_27908=0
    local __range_end_27908="${cnt_27907}"
    local __dir_27908=$(( ${__range_start_27908} <= ${__range_end_27908} ? 1 : -1 ))
    for (( ____27908=${__range_start_27908}; ____27908 * ${__dir_27908} < ${__range_end_27908} * ${__dir_27908}; ____27908+=${__dir_27908} )); do
        local array_460=("")
        eprintf__2262_v0 "
" array_460[@]
done
}

# go_up(cnt: Int)
go_up__2270_v0() {
    local cnt_27926="${1}"
    local array_461=("")
    eprintf__2262_v0 "\\x1b[${cnt_27926}A" array_461[@]
}

# go_down(cnt: Int)
go_down__2271_v0() {
    local cnt_27980="${1}"
    local array_462=("")
    eprintf__2262_v0 "\\x1b[${cnt_27980}B" array_462[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2272_v0() {
    local cnt_27989="${1}"
    if [ "$(( cnt_27989 > 0 ))" != 0 ]; then
        go_down__2271_v0 "${cnt_27989}"
    else
        go_up__2270_v0 "$(( - cnt_27989 ))"
    fi
}

# hide_cursor()
hide_cursor__2273_v0() {
    local array_463=("")
    eprintf__2262_v0 "\\x1b[?25l" array_463[@]
}

# show_cursor()
show_cursor__2274_v0() {
    local array_464=("")
    eprintf__2262_v0 "\\x1b[?25h" array_464[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2275_v0() {
    local text_27883="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_465
    command_465="$([[ "${text_27883}" == *$'\x1b'* || "${text_27883}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27884="${command_465}"
    ret_has_ansi_escape2275_v0="$([ "_${has_escape_27884}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2277_v0() {
    local text_27871="${1}"
    local command_466
    command_466="$(printf "%s" "${text_27871}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2277_v0="${command_466}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2278_v0() {
    local text_27873="${1}"
    local command_467
    command_467="$(printf "%s" "${text_27873}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27874="${command_467}"
    ret_is_all_ascii2278_v0="$([ "_${result_27874}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2279_v0() {
    local text_27870="${1}"
    strip_ansi__2277_v0 "${text_27870}"
    local stripped_27872="${ret_strip_ansi2277_v0}"
    # Check if text is all ASCII
    is_all_ascii__2278_v0 "${stripped_27872}"
    local ret_is_all_ascii2278_v0__150_12="${ret_is_all_ascii2278_v0}"
    if [ "$(( ! ret_is_all_ascii2278_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2212_v0 "${stripped_27872}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_468="${stripped_27872}"
            ret_get_visible_len2279_v0="${#__length_468}"
            return 0
        fi
        ret_get_visible_len2279_v0="${ret_perl_get_cjk_width2212_v0}"
        return 0
    else
        local __length_469="${stripped_27872}"
        ret_get_visible_len2279_v0="${#__length_469}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2280_v0() {
    local text_27885="${1}"
    local max_width_27886="${2}"
    get_visible_len__2279_v0 "${text_27885}"
    local visible_len_27887="${ret_get_visible_len2279_v0}"
    if [ "$(( visible_len_27887 <= max_width_27886 ))" != 0 ]; then
        ret_truncate_text2280_v0="${text_27885}"
        return 0
    fi
    is_all_ascii__2278_v0 "${text_27885}"
    local ret_is_all_ascii2278_v0__167_12="${ret_is_all_ascii2278_v0}"
    if [ "$(( ! ret_is_all_ascii2278_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2213_v0 "${text_27885}" "${max_width_27886}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27885}" | cut -c1-${max_width_27886}
            __status=$?
        fi
        ret_truncate_text2280_v0="${ret_perl_truncate_cjk2213_v0}"
        return 0
    fi
    local command_470
    command_470="$(printf "%s" "${text_27885}" | cut -c1-${max_width_27886})"
    __status=$?
    ret_truncate_text2280_v0="${command_470}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2281_v0() {
    local text_27881="${1}"
    local max_width_27882="${2}"
    has_ansi_escape__2275_v0 "${text_27881}"
    local ret_has_ansi_escape2275_v0__179_12="${ret_has_ansi_escape2275_v0}"
    if [ "$(( ! ret_has_ansi_escape2275_v0__179_12 ))" != 0 ]; then
        truncate_text__2280_v0 "${text_27881}" "${max_width_27882}"
        ret_truncate_ansi2281_v0="${ret_truncate_text2280_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_471
    command_471="$([[ "${text_27881}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27891="${command_471}"
    # Replace \x1b[ with newline, then split
    local command_472
    command_472="$(t="${text_27881}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27892="${command_472}"
    split__4_v0 "${replaced_27892}" "
"
    local parts_27893=("${ret_split4_v0[@]}")
    local result_27894=""
    local remaining_width_27895="${max_width_27882}"
    local __range_start_27896=0
    local __length_473=("${parts_27893[@]}")
    local __range_end_27896="${#__length_473[@]}"
    local __dir_27896=$(( ${__range_start_27896} <= ${__range_end_27896} ? 1 : -1 ))
    for (( idx_27896=${__range_start_27896}; idx_27896 * ${__dir_27896} < ${__range_end_27896} * ${__dir_27896}; idx_27896+=${__dir_27896} )); do
        local part_27897="${parts_27893[${idx_27896}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27896 == 0 )) && $([ "_${starts_with_ansi_27891}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27897}" == "_" ]; echo $?) && $(( remaining_width_27895 > 0 )) ))" != 0 ]; then
                truncate_text__2280_v0 "${part_27897}" "${remaining_width_27895}"
                local ret_truncate_text2280_v0__201_35="${ret_truncate_text2280_v0}"
                local truncated_27898="${ret_truncate_text2280_v0__201_35}"
                result_27894+="${truncated_27898}"
                get_visible_len__2279_v0 "${truncated_27898}"
                local ret_get_visible_len2279_v0__203_36="${ret_get_visible_len2279_v0}"
                remaining_width_27895="$(( remaining_width_27895 - ret_get_visible_len2279_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_474
            command_474="$(__p="${part_27897}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27899="${command_474}"
            if [ "$([ "_${m_idx_27899}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_475
                command_475="$(__p="${part_27897}"; printf "%s" "${__p:0:${m_idx_27899}}")"
                __status=$?
                local ansi_params_27900="${command_475}"
                result_27894+="\\x1b[""${ansi_params_27900}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27899}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_27901="${ret_parse_int13_v0__214_41}"
                local text_start_27902="$(( m_idx_num_27901 + 1 ))"
                local command_476
                command_476="$(__p="${part_27897}"; printf "%s" "${__p:${text_start_27902}}")"
                __status=$?
                local text_part_27903="${command_476}"
                if [ "$(( $([ "_${text_part_27903}" == "_" ]; echo $?) && $(( remaining_width_27895 > 0 )) ))" != 0 ]; then
                    truncate_text__2280_v0 "${text_part_27903}" "${remaining_width_27895}"
                    local ret_truncate_text2280_v0__218_39="${ret_truncate_text2280_v0}"
                    local truncated_27904="${ret_truncate_text2280_v0__218_39}"
                    result_27894+="${truncated_27904}"
                    get_visible_len__2279_v0 "${truncated_27904}"
                    local ret_get_visible_len2279_v0__220_40="${ret_get_visible_len2279_v0}"
                    remaining_width_27895="$(( remaining_width_27895 - ret_get_visible_len2279_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27897}" == "_" ]; echo $?) && $(( remaining_width_27895 > 0 )) ))" != 0 ]; then
                    truncate_text__2280_v0 "${part_27897}" "${remaining_width_27895}"
                    local ret_truncate_text2280_v0__225_39="${ret_truncate_text2280_v0}"
                    local truncated_27905="${ret_truncate_text2280_v0__225_39}"
                    result_27894+="${truncated_27905}"
                    get_visible_len__2279_v0 "${truncated_27905}"
                    local ret_get_visible_len2279_v0__227_40="${ret_get_visible_len2279_v0}"
                    remaining_width_27895="$(( remaining_width_27895 - ret_get_visible_len2279_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2281_v0="${result_27894}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2282_v0() {
    local text_27868="${1}"
    local max_width_27869="${2}"
    get_visible_len__2279_v0 "${text_27868}"
    local visible_len_27880="${ret_get_visible_len2279_v0}"
    if [ "$(( visible_len_27880 <= max_width_27869 ))" != 0 ]; then
        ret_cutoff_text2282_v0="${text_27868}"
        return 0
    fi
    truncate_ansi__2281_v0 "${text_27868}" "$(( max_width_27869 - 3 ))"
    local ret_truncate_ansi2281_v0__243_12="${ret_truncate_ansi2281_v0}"
    ret_cutoff_text2282_v0="${ret_truncate_ansi2281_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2283_v0() {
    local items_27911=("${!1}")
    local total_len_27912="${2}"
    local term_width_27913="${3}"
    local separator_27914=" • "
    local separator_len_27915=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27912 <= term_width_27913 ))" != 0 ]; then
        local iter_27916=0
        while :
        do
            local __length_477=("${items_27911[@]}")
            if [ "$(( iter_27916 >= ${#__length_477[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_27916 > 0 ))" != 0 ]; then
                eprintf_colored__2263_v0 "${separator_27914}" 90
            fi
            colored__2264_v0 "${items_27911[$(( iter_27916 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2264_v0__268_41="${ret_colored2264_v0}"
            local array_478=("")
            eprintf__2262_v0 "${items_27911[${iter_27916}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2264_v0__268_41}" array_478[@]
            iter_27916="$(( iter_27916 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_27919=0
        local first_27920=1
        local iter_27921=0
        while :
        do
            local __length_479=("${items_27911[@]}")
            if [ "$(( iter_27921 >= ${#__length_479[@]} ))" != 0 ]; then
                break
            fi
            local key_27922="${items_27911[${iter_27921}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_27923="${items_27911[$(( iter_27921 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_480="${key_27922}"
            local __length_481="${action_27923}"
            local part_len_27924="$(( $(( ${#__length_480} + 1 )) + ${#__length_481} ))"
            local needed_27925="${part_len_27924}"
            if [ "$(( ! first_27920 ))" != 0 ]; then
                needed_27925="$(( needed_27925 + separator_len_27915 ))"
            fi
            if [ "$(( $(( current_len_27919 + needed_27925 )) > term_width_27913 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_27920 ))" != 0 ]; then
                eprintf_colored__2263_v0 "${separator_27914}" 90
            fi
            colored__2264_v0 "${action_27923}" 2
            local ret_colored2264_v0__296_33="${ret_colored2264_v0}"
            local array_482=("")
            eprintf__2262_v0 "${key_27922}"" ""${ret_colored2264_v0__296_33}" array_482[@]
            current_len_27919="$(( current_len_27919 + needed_27925 ))"
            first_27920=0
            iter_27921="$(( iter_27921 + 2 ))"
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
__CHOOSER_CONTINUE_100=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_101=1
# The user confirmed the selection.
__CHOOSER_DONE_102=2
_total_103=0
_page_size_104=10
_display_count_105=0
_total_pages_106=1
_current_page_107=0
_selected_108=0
_cursor_109="> "
_multi_110=0
_limit_111=-1
_term_width_112=80
_has_header_113=0
_page_114=()
_page_count_115=0
_checked_116=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_117=0
_first_render_118=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_119=0
# render_single_page()
render_single_page__2337_v0() {
    local __length_485="${_cursor_109}"
    local cursor_len_27962="${#__length_485}"
    local max_option_width_27963="$(( $(( _term_width_112 - cursor_len_27962 )) - 1 ))"
    local __range_start_27964=0
    local __range_end_27964="${_page_count_115}"
    local __dir_27964=$(( ${__range_start_27964} <= ${__range_end_27964} ? 1 : -1 ))
    for (( i_27964=${__range_start_27964}; i_27964 * ${__dir_27964} < ${__range_end_27964} * ${__dir_27964}; i_27964+=${__dir_27964} )); do
        cutoff_text__2282_v0 "${_page_114[${i_27964}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_27963}"
        local ret_cutoff_text2282_v0__48_27="${ret_cutoff_text2282_v0}"
        local truncated_27965="${ret_cutoff_text2282_v0__48_27}"
        if [ "$(( i_27964 == _selected_108 ))" != 0 ]; then
            colored_secondary__2245_v0 "${_cursor_109}""${truncated_27965}""
"
            local ret_colored_secondary2245_v0__50_21="${ret_colored_secondary2245_v0}"
            local array_486=("")
            eprintf__2262_v0 "${ret_colored_secondary2245_v0__50_21}" array_486[@]
        else
            print_blank__2268_v0 "${cursor_len_27962}"
            local array_487=("")
            eprintf__2262_v0 "${truncated_27965}""
" array_487[@]
        fi
done
    local remaining_slots_27966="$(( _display_count_105 - _page_count_115 ))"
    if [ "$(( remaining_slots_27966 > 0 ))" != 0 ]; then
        local __range_start_27967=0
        local __range_end_27967="${remaining_slots_27966}"
        local __dir_27967=$(( ${__range_start_27967} <= ${__range_end_27967} ? 1 : -1 ))
        for (( ____27967=${__range_start_27967}; ____27967 * ${__dir_27967} < ${__range_end_27967} * ${__dir_27967}; ____27967+=${__dir_27967} )); do
            local array_488=("")
            eprintf__2262_v0 "\\x1b[K
" array_488[@]
done
    fi
}

# render_multi_page()
render_multi_page__2338_v0() {
    local __length_489="${_cursor_109}"
    local cursor_len_27939="${#__length_489}"
    local max_option_width_27940="$(( $(( _term_width_112 - cursor_len_27939 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2343_v0 
    local page_start_27941="${ret_chooser_page_start2343_v0}"
    local __range_start_27942=0
    local __range_end_27942="${_page_count_115}"
    local __dir_27942=$(( ${__range_start_27942} <= ${__range_end_27942} ? 1 : -1 ))
    for (( i_27942=${__range_start_27942}; i_27942 * ${__dir_27942} < ${__range_end_27942} * ${__dir_27942}; i_27942+=${__dir_27942} )); do
        local global_idx_27943="$(( page_start_27941 + i_27942 ))"
        local check_mark_27944
        check_mark_27944="$(if [ "${_checked_116[${global_idx_27943}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2282_v0 "${_page_114[${i_27942}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_27940}"
        local ret_cutoff_text2282_v0__71_27="${ret_cutoff_text2282_v0}"
        local truncated_27945="${ret_cutoff_text2282_v0__71_27}"
        if [ "$(( i_27942 == _selected_108 ))" != 0 ]; then
            colored_secondary__2245_v0 "${_cursor_109}""${check_mark_27944}""${truncated_27945}""
"
            local ret_colored_secondary2245_v0__73_37="${ret_colored_secondary2245_v0}"
            local array_490=("")
            eprintf__2262_v0 "${ret_colored_secondary2245_v0__73_37}" array_490[@]
        elif [ "${_checked_116[${global_idx_27943}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2268_v0 "${cursor_len_27939}"
            colored_secondary__2245_v0 "${check_mark_27944}""${truncated_27945}""
"
            local ret_colored_secondary2245_v0__76_25="${ret_colored_secondary2245_v0}"
            local array_491=("")
            eprintf__2262_v0 "${ret_colored_secondary2245_v0__76_25}" array_491[@]
        else
            print_blank__2268_v0 "${cursor_len_27939}"
            local array_492=("")
            eprintf__2262_v0 "${check_mark_27944}""${truncated_27945}""
" array_492[@]
        fi
done
    local remaining_slots_27960="$(( _display_count_105 - _page_count_115 ))"
    if [ "$(( remaining_slots_27960 > 0 ))" != 0 ]; then
        local __range_start_27961=0
        local __range_end_27961="${remaining_slots_27960}"
        local __dir_27961=$(( ${__range_start_27961} <= ${__range_end_27961} ? 1 : -1 ))
        for (( ____27961=${__range_start_27961}; ____27961 * ${__dir_27961} < ${__range_end_27961} * ${__dir_27961}; ____27961+=${__dir_27961} )); do
            local array_493=("")
            eprintf__2262_v0 "\\x1b[K
" array_493[@]
done
    fi
}

# render_page()
render_page__2339_v0() {
    if [ "${_multi_110}" != 0 ]; then
        render_multi_page__2338_v0 
    else
        render_single_page__2337_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2340_v0() {
    if [ "$(( _total_pages_106 > 1 ))" != 0 ]; then
        local array_494=("")
        eprintf__2262_v0 "\\x1b[G\\x1b[K" array_494[@]
        eprintf_colored__2263_v0 "Page $(( _current_page_107 + 1 ))/${_total_pages_106}" 90
        local array_495=("")
        eprintf__2262_v0 "\\x1b[G" array_495[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2341_v0() {
    if [ "$(( ! _multi_110 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_106 > 1 ))" != 0 ]; then
            local array_496=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2283_v0 array_496[@] 36 "${_term_width_112}"
        else
            local array_497=("↑↓" "select" "enter" "confirm")
            render_tooltip__2283_v0 array_497[@] 25 "${_term_width_112}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_106 > 1 )) && $(( _limit_111 < 0 )) ))" != 0 ]; then
            local array_498=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2283_v0 array_498[@] 55 "${_term_width_112}"
        elif [ "$(( _total_pages_106 > 1 ))" != 0 ]; then
            local array_499=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2283_v0 array_499[@] 47 "${_term_width_112}"
        elif [ "$(( _limit_111 < 0 ))" != 0 ]; then
            local array_500=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2283_v0 array_500[@] 44 "${_term_width_112}"
        else
            local array_501=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2283_v0 array_501[@] 36 "${_term_width_112}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2342_v0() {
    local total_27851="${1}"
    local page_size_27852="${2}"
    local header_27853="${3}"
    local cursor_27854="${4}"
    local multi_27855="${5}"
    local limit_27856="${6}"
    _total_103="${total_27851}"
    _cursor_109="${cursor_27854}"
    _multi_110="${multi_27855}"
    _limit_111="${limit_27856}"
    _current_page_107=0
    _selected_108=0
    _first_render_118=1
    _up_paged_119=0
    _checked_count_117=0
    _has_header_113="$([ "_${header_27853}" == "_" ]; echo $?)"
    stty_lock__2221_v0 
    hide_cursor__2273_v0 
    term_width__2228_v0 
    _term_width_112="${ret_term_width2228_v0}"
    term_height__2229_v0 
    local term_height_27866="${ret_term_height2229_v0}"
    local max_page_size_27867
    max_page_size_27867="$(( term_height_27866 - $(if [ "${_has_header_113}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_104="${page_size_27852}"
    if [ "$(( _page_size_104 > max_page_size_27867 ))" != 0 ]; then
        _page_size_104="${max_page_size_27867}"
    fi
    if [ "${_has_header_113}" != 0 ]; then
        cutoff_text__2282_v0 "${header_27853}" "${_term_width_112}"
        local ret_cutoff_text2282_v0__157_17="${ret_cutoff_text2282_v0}"
        local array_502=("")
        eprintf__2262_v0 "${ret_cutoff_text2282_v0__157_17}""
" array_502[@]
    fi
    math_floor__510_v0 "$(( $(( $(( total_27851 + _page_size_104 )) - 1 )) / _page_size_104 ))"
    _total_pages_106="${ret_math_floor510_v0}"
    _display_count_105="${_page_size_104}"
    if [ "$(( total_27851 < _page_size_104 ))" != 0 ]; then
        _display_count_105="${total_27851}"
    fi
    if [ "${multi_27855}" != 0 ]; then
        _checked_116=()
        local __range_start_27906=0
        local __range_end_27906="${total_27851}"
        local __dir_27906=$(( ${__range_start_27906} <= ${__range_end_27906} ? 1 : -1 ))
        for (( ____27906=${__range_start_27906}; ____27906 * ${__dir_27906} < ${__range_end_27906} * ${__dir_27906}; ____27906+=${__dir_27906} )); do
            local array_504=(0)
            _checked_116+=("${array_504[@]}")
done
    fi
    new_line__2269_v0 "${_display_count_105}"
    local array_505=("")
    eprintf__2262_v0 "\\x1b[G" array_505[@]
    if [ "$(( _total_pages_106 > 1 ))" != 0 ]; then
        eprintf_colored__2263_v0 "Page $(( _current_page_107 + 1 ))/${_total_pages_106}" 90
    fi
    new_line__2269_v0 1
    render_tooltip_line__2341_v0 
    go_up__2270_v0 "$(( _display_count_105 + 1 ))"
    local array_506=("")
    eprintf__2262_v0 "\\x1b[G" array_506[@]
}

# chooser_page_start()
chooser_page_start__2343_v0() {
    ret_chooser_page_start2343_v0="$(( _current_page_107 * _page_size_104 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2344_v0() {
    chooser_page_start__2343_v0 
    local start_27930="${ret_chooser_page_start2343_v0}"
    local end_27931="$(( start_27930 + _page_size_104 ))"
    if [ "$(( end_27931 > _total_103 ))" != 0 ]; then
        end_27931="${_total_103}"
    fi
    ret_chooser_page_count2344_v0="$(( end_27931 - start_27930 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2345_v0() {
    local page_27938=("${!1}")
    _page_114=("${page_27938[@]}")
    local __length_507=("${page_27938[@]}")
    _page_count_115="${#__length_507[@]}"
    if [ "${_first_render_118}" != 0 ]; then
        _first_render_118=0
        render_page__2339_v0 
    else
        if [ "${_up_paged_119}" != 0 ]; then
            _selected_108="$(( _page_count_115 - 1 ))"
            _up_paged_119=0
        fi
        go_up__2270_v0 1
        remove_line__2266_v0 "$(( _display_count_105 - 1 ))"
        remove_current_line__2267_v0 
        local array_508=("")
        eprintf__2262_v0 "\\x1b[G" array_508[@]
        render_page__2339_v0 
        render_page_indicator__2340_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2346_v0() {
    local prev_selected_27983="${1}"
    chooser_page_start__2343_v0 
    local page_start_27984="${ret_chooser_page_start2343_v0}"
    local check_width_27985
    check_width_27985="$(if [ "${_multi_110}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_509="${_cursor_109}"
    local max_option_width_27986="$(( $(( _term_width_112 - ${#__length_509} )) - check_width_27985 ))"
    go_up__2270_v0 "$(( _display_count_105 - prev_selected_27983 ))"
    local array_510=("")
    eprintf__2262_v0 "\\x1b[K" array_510[@]
    local __length_511="${_cursor_109}"
    print_blank__2268_v0 "${#__length_511}"
    if [ "${_multi_110}" != 0 ]; then
        local was_checked_27987="${_checked_116[$(( page_start_27984 + prev_selected_27983 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2282_v0 "${_page_114[${prev_selected_27983}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_27986}"
        local ret_cutoff_text2282_v0__232_63="${ret_cutoff_text2282_v0}"
        local prev_line_27988
        prev_line_27988="$(if [ "${was_checked_27987}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2282_v0__232_63}"
        if [ "${was_checked_27987}" != 0 ]; then
            colored_secondary__2245_v0 "${prev_line_27988}"
            local ret_colored_secondary2245_v0__234_21="${ret_colored_secondary2245_v0}"
            local array_512=("")
            eprintf__2262_v0 "${ret_colored_secondary2245_v0__234_21}" array_512[@]
        else
            local array_513=("")
            eprintf__2262_v0 "${prev_line_27988}" array_513[@]
        fi
    else
        cutoff_text__2282_v0 "${_page_114[${prev_selected_27983}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_27986}"
        local ret_cutoff_text2282_v0__239_17="${ret_cutoff_text2282_v0}"
        local array_514=("")
        eprintf__2262_v0 "${ret_cutoff_text2282_v0__239_17}" array_514[@]
    fi
    go_up_or_down__2272_v0 "$(( _selected_108 - prev_selected_27983 ))"
    local array_515=("")
    eprintf__2262_v0 "\\x1b[G" array_515[@]
    local array_516=("")
    eprintf__2262_v0 "\\x1b[K" array_516[@]
    local mark_27990
    mark_27990="$(if [ "${_multi_110}" != 0 ]; then echo "$(if [ "${_checked_116[$(( page_start_27984 + _selected_108 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2282_v0 "${_page_114[${_selected_108}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_27986}"
    local ret_cutoff_text2282_v0__246_48="${ret_cutoff_text2282_v0}"
    colored_secondary__2245_v0 "${_cursor_109}""${mark_27990}""${ret_cutoff_text2282_v0__246_48}"
    local ret_colored_secondary2245_v0__246_13="${ret_colored_secondary2245_v0}"
    local array_517=("")
    eprintf__2262_v0 "${ret_colored_secondary2245_v0__246_13}" array_517[@]
    go_down__2271_v0 "$(( _display_count_105 - _selected_108 ))"
    local array_518=("")
    eprintf__2262_v0 "\\x1b[G" array_518[@]
}

# redraw_current_line()
redraw_current_line__2347_v0() {
    chooser_page_start__2343_v0 
    local page_start_27977="${ret_chooser_page_start2343_v0}"
    local __length_519="${_cursor_109}"
    local max_option_width_27978="$(( $(( _term_width_112 - ${#__length_519} )) - 3 ))"
    go_up__2270_v0 "$(( _display_count_105 - _selected_108 ))"
    local array_520=("")
    eprintf__2262_v0 "\\x1b[G" array_520[@]
    local array_521=("")
    eprintf__2262_v0 "\\x1b[K" array_521[@]
    local check_mark_27979
    check_mark_27979="$(if [ "${_checked_116[$(( page_start_27977 + _selected_108 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2282_v0 "${_page_114[${_selected_108}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_27978}"
    local ret_cutoff_text2282_v0__260_54="${ret_cutoff_text2282_v0}"
    colored_secondary__2245_v0 "${_cursor_109}""${check_mark_27979}""${ret_cutoff_text2282_v0__260_54}"
    local ret_colored_secondary2245_v0__260_13="${ret_colored_secondary2245_v0}"
    local array_522=("")
    eprintf__2262_v0 "${ret_colored_secondary2245_v0__260_13}" array_522[@]
    go_down__2271_v0 "$(( _display_count_105 - _selected_108 ))"
    local array_523=("")
    eprintf__2262_v0 "\\x1b[G" array_523[@]
}

# chooser_step()
chooser_step__2348_v0() {
    get_key__2260_v0 
    local key_27972="${ret_get_key2260_v0}"
    local prev_selected_27973="${_selected_108}"
    local prev_page_27974="${_current_page_107}"
    chooser_page_start__2343_v0 
    local page_start_27975="${ret_chooser_page_start2343_v0}"
    _up_paged_119=0
    if [ "$(( $([ "_${key_27972}" != "_UP" ]; echo $?) || $([ "_${key_27972}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_108 == 0 )) && $(( _total_pages_106 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_107 > 0 ))" != 0 ]; then
                _current_page_107="$(( _current_page_107 - 1 ))"
            else
                _current_page_107="$(( _total_pages_106 - 1 ))"
            fi
            _up_paged_119=1
        elif [ "$(( _selected_108 == 0 ))" != 0 ]; then
            _selected_108="$(( _page_count_115 - 1 ))"
        else
            _selected_108="$(( _selected_108 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_27972}" != "_DOWN" ]; echo $?) || $([ "_${key_27972}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_108 == $(( _page_count_115 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_107 < $(( _total_pages_106 - 1 )) ))" != 0 ]; then
                _current_page_107="$(( _current_page_107 + 1 ))"
            else
                _current_page_107=0
            fi
            _selected_108=0
        else
            _selected_108="$(( _selected_108 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_27972}" != "_LEFT" ]; echo $?) || $([ "_${key_27972}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_107 > 0 ))" != 0 ]; then
            _current_page_107="$(( _current_page_107 - 1 ))"
        fi
        _selected_108=0
    elif [ "$(( $([ "_${key_27972}" != "_RIGHT" ]; echo $?) || $([ "_${key_27972}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_107 < $(( _total_pages_106 - 1 )) ))" != 0 ]; then
            _current_page_107="$(( _current_page_107 + 1 ))"
            _selected_108=0
        else
            _selected_108="$(( _page_count_115 - 1 ))"
        fi
    elif [ "$(( _multi_110 && $(( $([ "_${key_27972}" != "_x" ]; echo $?) || $([ "_${key_27972}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_27976="$(( page_start_27975 + _selected_108 ))"
        if [ "${_checked_116[${global_selected_27976}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_116["${global_selected_27976}"]=0
            _checked_count_117="$(( _checked_count_117 - 1 ))"
        elif [ "$(( $(( _limit_111 < 0 )) || $(( _checked_count_117 < _limit_111 )) ))" != 0 ]; then
            _checked_116["${global_selected_27976}"]=1
            _checked_count_117="$(( _checked_count_117 + 1 ))"
        else
            ret_chooser_step2348_v0="${__CHOOSER_CONTINUE_100}"
            return 0
        fi
        redraw_current_line__2347_v0 
        ret_chooser_step2348_v0="${__CHOOSER_CONTINUE_100}"
        return 0
    elif [ "$(( $(( _multi_110 && $(( $([ "_${key_27972}" != "_a" ]; echo $?) || $([ "_${key_27972}" != "_A" ]; echo $?) )) )) && $(( _limit_111 < 0 )) ))" != 0 ]; then
        local all_checked_27981="$(( _checked_count_117 == _total_103 ))"
        local __range_start_27982=0
        local __range_end_27982="${_total_103}"
        local __dir_27982=$(( ${__range_start_27982} <= ${__range_end_27982} ? 1 : -1 ))
        for (( i_27982=${__range_start_27982}; i_27982 * ${__dir_27982} < ${__range_end_27982} * ${__dir_27982}; i_27982+=${__dir_27982} )); do
            _checked_116["${i_27982}"]="$(( ! all_checked_27981 ))"
done
        _checked_count_117="$(if [ "${all_checked_27981}" != 0 ]; then echo 0; else echo "${_total_103}"; fi)"
        go_up__2270_v0 "${_display_count_105}"
        local array_524=("")
        eprintf__2262_v0 "\\x1b[G" array_524[@]
        render_page__2339_v0 
        ret_chooser_step2348_v0="${__CHOOSER_CONTINUE_100}"
        return 0
    elif [ "$([ "_${key_27972}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2348_v0="${__CHOOSER_DONE_102}"
        return 0
    else
        ret_chooser_step2348_v0="${__CHOOSER_CONTINUE_100}"
        return 0
    fi
    if [ "$(( prev_page_27974 != _current_page_107 ))" != 0 ]; then
        ret_chooser_step2348_v0="${__CHOOSER_NEED_PAGE_101}"
        return 0
    fi
    if [ "$(( prev_selected_27973 != _selected_108 ))" != 0 ]; then
        redraw_selection__2346_v0 "${prev_selected_27973}"
    fi
    ret_chooser_step2348_v0="${__CHOOSER_CONTINUE_100}"
    return 0
}

# chooser_selected()
chooser_selected__2349_v0() {
    chooser_page_start__2343_v0 
    local ret_chooser_page_start2343_v0__362_12="${ret_chooser_page_start2343_v0}"
    ret_chooser_selected2349_v0="$(( ret_chooser_page_start2343_v0__362_12 + _selected_108 ))"
    return 0
}

# chooser_end()
chooser_end__2351_v0() {
    local total_lines_27993="$(( _display_count_105 + 2 ))"
    if [ "${_has_header_113}" != 0 ]; then
        total_lines_27993="$(( total_lines_27993 + 1 ))"
    fi
    go_down__2271_v0 1
    remove_line__2266_v0 "$(( total_lines_27993 - 1 ))"
    remove_current_line__2267_v0 
    stty_unlock__2222_v0 
    show_cursor__2274_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2360_v0() {
    local name_27934="${1}"
    local file_type_27935="${2}"
    local target_27936="${3}"
    if [ "$([ "_${file_type_27935}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2018_v0 "/"
        local ret_colored_primary2018_v0__10_23="${ret_colored_primary2018_v0}"
        ret_format_entry_display2360_v0="${name_27934}""${ret_colored_primary2018_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_27935}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2020_v0 " > "
        local ret_colored_accent2020_v0__13_23="${ret_colored_accent2020_v0}"
        colored_primary__2018_v0 "${target_27936}"
        local ret_colored_primary2018_v0__13_47="${ret_colored_primary2018_v0}"
        ret_format_entry_display2360_v0="${name_27934}""${ret_colored_accent2020_v0__13_23}""${ret_colored_primary2018_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2360_v0="${name_27934}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2361_v0() {
    local start_path_27823="${1}"
    local cursor_27824="${2}"
    local show_hidden_27825="${3}"
    local page_size_27826="${4}"
    stty_lock__1995_v0 
    # Initialize current path
    local current_path_27829="${start_path_27823}"
    if [ "$([ "_${current_path_27829}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1974_v0 
        current_path_27829="${ret_get_cwd1974_v0}"
    fi
    normalize_path__1975_v0 "${current_path_27829}"
    current_path_27829="${ret_normalize_path1975_v0}"
    while :
    do
        colored_primary__2018_v0 "Loading files..."
        local ret_colored_primary2018_v0__41_17="${ret_colored_primary2018_v0}"
        local array_525=("")
        eprintf__2036_v0 "${ret_colored_primary2018_v0__41_17}" array_525[@]
        get_directory_entries__1973_v0 "${current_path_27829}"
        local listed_27840=("${ret_get_directory_entries1973_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_27841=()
        local types_27842=()
        local targets_27843=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_27829}" == "_/" ]; echo $?)" != 0 ]; then
            names_27841+=("..")
            types_27842+=("d")
            targets_27843+=("")
        fi
        local __length_532=("${listed_27840[@]}")
        local listed_count_27844="$(( ${#__length_532[@]} / __ENTRY_STRIDE_78 ))"
        local __range_start_27845=0
        local __range_end_27845="${listed_count_27844}"
        local __dir_27845=$(( ${__range_start_27845} <= ${__range_end_27845} ? 1 : -1 ))
        for (( i_27845=${__range_start_27845}; i_27845 * ${__dir_27845} < ${__range_end_27845} * ${__dir_27845}; i_27845+=${__dir_27845} )); do
            local at_27846="$(( i_27845 * __ENTRY_STRIDE_78 ))"
            local name_27847="${listed_27840[${at_27846}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_27847}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_27825 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_533=("${name_27847}")
            names_27841+=("${array_533[@]}")
            local array_534=("${listed_27840[$(( at_27846 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_27842+=("${array_534[@]}")
            local array_535=("${listed_27840[$(( at_27846 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_27843+=("${array_535[@]}")
done
        local __length_536=("${names_27841[@]}")
        local total_27848="${#__length_536[@]}"
        if [ "$(( total_27848 == 0 ))" != 0 ]; then
            eprintf_colored__2037_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1996_v0 
            ret_xyl_file2361_v0=""
            return 0
        fi
        colored_primary__2018_v0 "${current_path_27829}"
        local header_27850="${ret_colored_primary2018_v0}"
        remove_current_line__2041_v0 
        chooser_begin__2342_v0 "${total_27848}" "${page_size_27826}" "${header_27850}" "${cursor_27824}" 0 -1
        local need_page_27927=1
        while :
        do
            if [ "${need_page_27927}" != 0 ]; then
                local page_27928=()
                chooser_page_start__2343_v0 
                local start_27929="${ret_chooser_page_start2343_v0}"
                chooser_page_count__2344_v0 
                local count_27932="${ret_chooser_page_count2344_v0}"
                local __range_start_27933="${start_27929}"
                local __range_end_27933="$(( start_27929 + count_27932 ))"
                local __dir_27933=$(( ${__range_start_27933} <= ${__range_end_27933} ? 1 : -1 ))
                for (( i_27933=${__range_start_27933}; i_27933 * ${__dir_27933} < ${__range_end_27933} * ${__dir_27933}; i_27933+=${__dir_27933} )); do
                    format_entry_display__2360_v0 "${names_27841[${i_27933}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_27842[${i_27933}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_27843[${i_27933}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display2360_v0__90_30="${ret_format_entry_display2360_v0}"
                    local array_538=("${ret_format_entry_display2360_v0__90_30}")
                    page_27928+=("${array_538[@]}")
done
                chooser_set_page__2345_v0 page_27928[@]
            fi
            chooser_step__2348_v0 
            local step_27991="${ret_chooser_step2348_v0}"
            if [ "$(( step_27991 == __CHOOSER_DONE_102 ))" != 0 ]; then
                break
            fi
            need_page_27927="$(( step_27991 == __CHOOSER_NEED_PAGE_101 ))"
        done
        chooser_selected__2349_v0 
        local selected_idx_27992="${ret_chooser_selected2349_v0}"
        chooser_end__2351_v0 
        local name_27995="${names_27841[${selected_idx_27992}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_27996="${types_27842[${selected_idx_27992}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_27995}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1977_v0 "${current_path_27829}"
            current_path_27829="${ret_get_parent_dir1977_v0}"
        elif [ "$([ "_${file_type_27996}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1976_v0 "${current_path_27829}" "${name_27995}"
            current_path_27829="${ret_path_join1976_v0}"
            normalize_path__1975_v0 "${current_path_27829}"
            current_path_27829="${ret_normalize_path1975_v0}"
        elif [ "$([ "_${file_type_27996}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_28001="${targets_27843[${selected_idx_27992}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_28002="${target_28001}"
            starts_with__22_v0 "${target_28001}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__1976_v0 "${current_path_27829}" "${target_28001}"
                target_path_28002="${ret_path_join1976_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_28002}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_27829="${target_path_28002}"
                normalize_path__1975_v0 "${current_path_27829}"
                current_path_27829="${ret_normalize_path1975_v0}"
            else
                stty_unlock__1996_v0 
                path_join__1976_v0 "${current_path_27829}" "${name_27995}"
                ret_xyl_file2361_v0="${ret_path_join1976_v0}"
                return 0
            fi
        else
            stty_unlock__1996_v0 
            path_join__1976_v0 "${current_path_27829}" "${name_27995}"
            ret_xyl_file2361_v0="${ret_path_join1976_v0}"
            return 0
        fi
    done
    stty_unlock__1996_v0 
    ret_xyl_file2361_v0=""
    return 0
}

# print_file_help()
print_file_help__2455_v0() {
    local usage_27746=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2060_v0 usage_27746[@]
    printf '%s\n' ""
    colored_primary__2018_v0 "file"
    local ret_colored_primary2018_v0__8_20="${ret_colored_primary2018_v0}"
    local title_27783=("${ret_colored_primary2018_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2060_v0 title_27783[@]
    printf '%s\n' ""
    colored_secondary__2019_v0 "Arguments:"
    local ret_colored_secondary2019_v0__11_12="${ret_colored_secondary2019_v0}"
    local array_541=()
    printf__128_v0 "${ret_colored_secondary2019_v0__11_12}""
" array_541[@]
    local arg_names_27785=("[<path>]")
    local arg_texts_27786=("Starting directory path")
    local arg_notes_27787=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2059_v0 arg_names_27785[@] arg_texts_27786[@] arg_notes_27787[@] 20
    printf '%s\n' ""
    colored_secondary__2019_v0 "Flags:"
    local ret_colored_secondary2019_v0__18_12="${ret_colored_secondary2019_v0}"
    local array_545=()
    printf__128_v0 "${ret_colored_secondary2019_v0__18_12}""
" array_545[@]
    local names_27815=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_27816=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_27817=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2059_v0 names_27815[@] texts_27816[@] notes_27817[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2507_v0() {
    local parameters_27740=("${!1}")
    local cursor_27741="> "
    local start_path_27742=""
    local show_hidden_27743=0
    local page_size_27744=10
    local __length_552=("${parameters_27740[@]}")
    local slice_upper_551="${#__length_552[@]}"
    local slice_offset_553=2
    local slice_offset_553=$((${slice_offset_553} > 0 ? ${slice_offset_553} : 0))
    local slice_length_554="$(( slice_upper_551 - slice_offset_553 ))"
    local slice_length_554=$((${slice_length_554} > 0 ? ${slice_length_554} : 0))
    for param_27745 in "${parameters_27740[@]:${slice_offset_553}:${slice_length_554}}"; do
        starts_with__22_v0 "${param_27745}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27745}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27745}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27745}" != "_-h" ]; echo $?) || $([ "_${param_27745}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2455_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_555="--cursor="
            slice__24_v0 "${param_27745}" "${#__length_555}" 0
            cursor_27741="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_556="--path="
            slice__24_v0 "${param_27745}" "${#__length_556}" 0
            start_path_27742="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_27745}" != "_-a" ]; echo $?) || $([ "_${param_27745}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_27743=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_557="--page-size="
            slice__24_v0 "${param_27745}" "${#__length_557}" 0
            local value_27818="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27818}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2037_v0 "ERROR: Invalid page-size value: ""${value_27818}""
" 31
                exit 1
            fi
            page_size_27744="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_27742="${param_27745}"
        fi
    done
    xyl_file__2361_v0 "${start_path_27742}" "${cursor_27741}" "${show_hidden_27743}" "${page_size_27744}"
    ret_execute_file2507_v0="${ret_xyl_file2361_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_125="0.1.0"
__AMBER_VERSION_126="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2509_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__262_v0 "Error: " 91
        local array_558=("")
        eprintf__261_v0 "bc is not installed. Please install bc to use xylitol.
" array_558[@]
        local array_559=("")
        eprintf__261_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_559[@]
        local array_560=("")
        eprintf__261_v0 "  For Fedora: sudo dnf install bc
" array_560[@]
        local array_561=("")
        eprintf__261_v0 "  For Arch Linux: sudo pacman -S bc
" array_561[@]
        ret_check_prerequirements2509_v0=0
        return 0
    fi
    ret_check_prerequirements2509_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2510_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_127=("$0" "$@")
trap_cleanup__2510_v0 
check_prerequirements__2509_v0 
ret_check_prerequirements2509_v0__32_12="${ret_check_prerequirements2509_v0}"
if [ "$(( ! ret_check_prerequirements2509_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_563=("${args_127[@]}")
if [ "$(( ${#__length_563[@]} < 2 ))" != 0 ]; then
    print_help__429_v0 
    exit 0
fi
command_1427="${args_127[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1427}" != "_help" ]; echo $?) || $([ "_${command_1427}" != "_--help" ]; echo $?) )) || $([ "_${command_1427}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__429_v0 
elif [ "$([ "_${command_1427}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__843_v0 args_127[@]
    ret_execute_input843_v0__48_18="${ret_execute_input843_v0}"
    printf '%s\n' "${ret_execute_input843_v0__48_18}"
elif [ "$([ "_${command_1427}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1370_v0 args_127[@]
    ret_execute_choose1370_v0__51_18="${ret_execute_choose1370_v0}"
    printf '%s\n' "${ret_execute_choose1370_v0__51_18}"
elif [ "$([ "_${command_1427}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1818_v0 args_127[@]
    result_18398="${ret_execute_confirm1818_v0}"
    if [ "$([ "_${result_18398}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1427}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2507_v0 args_127[@]
    ret_execute_file2507_v0__61_18="${ret_execute_file2507_v0}"
    printf '%s\n' "${ret_execute_file2507_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1427}" != "_version" ]; echo $?) || $([ "_${command_1427}" != "_--version" ]; echo $?) )) || $([ "_${command_1427}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__243_v0 "xylitol.sh"
    ret_colored_primary243_v0__64_20="${ret_colored_primary243_v0}"
    array_564=()
    printf__128_v0 "${ret_colored_primary243_v0__64_20}" array_564[@]
    array_565=()
    printf__128_v0 " version: " array_565[@]
    colored_accent__245_v0 "${__VERSION_125}"
    ret_colored_accent245_v0__66_20="${ret_colored_accent245_v0}"
    array_566=()
    printf__128_v0 "${ret_colored_accent245_v0__66_20}" array_566[@]
    printf '%s\n' ""
    printf_colored__260_v0 "written in Amber: " 90
    printf_colored__260_v0 "  ""${__AMBER_VERSION_126}" 90
else
    print_help__429_v0 
    printf_colored__260_v0 "ERROR: Unknown command '""${command_1427}""'" 91
fi
