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
    local text_1440="${1}"
    local delimiter_1441="${2}"
    local result_1442=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1441}" read -rd '' -A result_1442 < <(printf %s "$text_1440")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1441}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1442+=("$REPLY"); done < <(echo "$text_1440")
            __status=$?
        else
            IFS="${delimiter_1441}" read -rd '' -a result_1442 < <(printf %s "$text_1440")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1441}" read -rd '' -a result_1442 < <(printf %s "$text_1440")
        __status=$?
    fi
    ret_split4_v0=("${result_1442[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_16442=("${!1}")
    local delimiter_16443="${2}"
    local command_1
    command_1="$(IFS="${delimiter_16443}" ; printf "%s
" "${list_16442[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1444="${1}"
    [ -n "${text_1444}" ] && [ "${text_1444}" -eq "${text_1444}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1444}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_3004="${1}"
    local prefix_3005="${2}"
    [[ "${text_3004}" == "${prefix_3005}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1527="${1}"
    local index_1528="${2}"
    local length_1529="${3}"
    local result_1530=""
    if [ "$(( length_1529 == 0 ))" != 0 ]; then
        local __length_2="${text_1527}"
        length_1529="$(( ${#__length_2} - index_1528 ))"
    fi
    if [ "$(( length_1529 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1530}"
        return 0
    fi
    result_1530="${text_1527: ${index_1528}: ${length_1529}}"
    __status=$?
    ret_slice24_v0="${result_1530}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_18448="${1}"
    local pad_18449="${2}"
    local length_18450="${3}"
    local __length_3="${text_18448}"
    if [ "$(( length_18450 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_18448}"
        return 0
    fi
    local __length_4="${text_18448}"
    local pad_len_18451="$(( length_18450 - ${#__length_4} ))"
    local padding_18452=""
    printf -v padding_18452 "%${pad_len_18451}s" ""
    __status=$?
    padding_18452="${padding_18452// /${pad_18449}}"
    __status=$?
    ret_lpad27_v0="${padding_18452}""${text_18448}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1507="${1}"
    local pad_1508="${2}"
    local length_1509="${3}"
    local __length_5="${text_1507}"
    if [ "$(( length_1509 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1507}"
        return 0
    fi
    local __length_6="${text_1507}"
    local pad_len_1510="$(( length_1509 - ${#__length_6} ))"
    local padding_1511=""
    printf -v padding_1511 "%${pad_len_1510}s" ""
    __status=$?
    padding_1511="${padding_1511// /${pad_1508}}"
    __status=$?
    ret_rpad28_v0="${text_1507}""${padding_1511}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_18442="${1}"
    local pad_18443="${2}"
    local length_18444="${3}"
    local __length_7="${text_18442}"
    local text_length_18445="${#__length_7}"
    if [ "$(( length_18444 <= text_length_18445 ))" != 0 ]; then
        ret_cpad29_v0="${text_18442}"
        return 0
    fi
    local total_padding_18446="$(( length_18444 - text_length_18445 ))"
    local left_padding_length_18447="$(( text_length_18445 + $(( total_padding_18446 / 2 )) ))"
    lpad__27_v0 "${text_18442}" "${pad_18443}" "${left_padding_length_18447}"
    local left_padded_18453="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_18453}" "${pad_18443}" "${length_18444}"
    local center_padded_18454="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_18454}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_28098="${1}"
    [ -d "${path_28098}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1467="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1467}")"
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
" "${(P)name_1467}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1467}")"
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
    local format_1464="${1}"
    local args_1465=("${!2}")
    args_1465=("${format_1464}" "${args_1465[@]}")
    __status=$?
    printf "${args_1465[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1477="${1}"
    local args_1478=("${!2}")
    args_1478=("${format_1477}" "${args_1478[@]}")
    __status=$?
    printf "${args_1478[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1474="${1}"
    local color_1475="${2}"
    local color_code_1476=0
        color_code_1476="${color_1475}"
    local array_11=("${message_1474}")
    printf__128_v1 "\\x1b[${color_code_1476}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_28101="${1}"
    local color_28102="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_28101}")
    printf__128_v1 "\\x1b[${color_28102}m%s\\x1b[0m" array_12[@]
}

# eprintf(format: Text, args: [Text])
eprintf__161_v0() {
    local format_198="${1}"
    local args_199=("${!2}")
    args_199=("${format_198}" "${args_199[@]}")
    __status=$?
    printf "${args_199[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__162_v0() {
    local message_196="${1}"
    local color_197="${2}"
    # Prints an error message with a specified color.
    local array_13=("${message_196}")
    eprintf__161_v0 "\\x1b[${color_197}m%s\\x1b[0m" array_13[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_3="None"
# perl_available()
perl_available__184_v0() {
    if [ "$([ "_${_perl_state_3}" != "_None" ]; echo $?)" != 0 ]; then
        local command_14
        command_14="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_1460
        disabled_1460="$([ "_${command_14}" != "_No" ]; echo $?)"
        local command_15
        command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1461
        found_1461="$(( $(( ! disabled_1460 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1461}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available184_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__185_v0() {
    local text_1459="${1}"
    perl_available__184_v0 
    local ret_perl_available184_v0__22_12="${ret_perl_available184_v0}"
    if [ "$(( ! ret_perl_available184_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return 1
    fi
    local command_16
    command_16="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1459}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_str_1462="${command_16}"
    parse_int__13_v0 "${width_str_1462}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_1463="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width185_v0="${width_1463}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__190_v0() {
    local text_1452="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_17
    command_17="$([[ "${text_1452}" == *$'\x1b'* || "${text_1452}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1453="${command_17}"
    ret_has_ansi_escape190_v0="$([ "_${has_escape_1453}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__192_v0() {
    local text_1455="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1455}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi192_v0="${command_18}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__193_v0() {
    local text_1457="${1}"
    local command_19
    command_19="$(printf "%s" "${text_1457}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1458="${command_19}"
    ret_is_all_ascii193_v0="$([ "_${result_1458}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__194_v0() {
    local text_1454="${1}"
    strip_ansi__192_v0 "${text_1454}"
    local stripped_1456="${ret_strip_ansi192_v0}"
    # Check if text is all ASCII
    is_all_ascii__193_v0 "${stripped_1456}"
    local ret_is_all_ascii193_v0__36_12="${ret_is_all_ascii193_v0}"
    if [ "$(( ! ret_is_all_ascii193_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__185_v0 "${stripped_1456}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_20="${stripped_1456}"
            ret_get_visible_len194_v0="${#__length_20}"
            return 0
        fi
        ret_get_visible_len194_v0="${ret_perl_get_cjk_width185_v0}"
        return 0
    else
        local __length_21="${stripped_1456}"
        ret_get_visible_len194_v0="${#__length_21}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_4=0
_term_size_5=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__203_v0() {
    local size_1439="${1}"
    if [ "$([ "_${size_1439}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size203_v0=0
        return 0
    fi
    split__4_v0 "${size_1439}" " "
    local parts_1443=("${ret_split4_v0[@]}")
    local __length_23=("${parts_1443[@]}")
    if [ "$(( ${#__length_23[@]} != 2 ))" != 0 ]; then
        ret_store_term_size203_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1443[1]?"Index out of bounds (at src/utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1443[0]?"Index out of bounds (at src/utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_5=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size203_v0=1
    return 0
}

# query_term_size()
query_term_size__204_v0() {
    local command_25
    command_25="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1446="${command_25}"
    store_term_size__203_v0 "${size_1446}"
    ret_query_term_size204_v0="${ret_store_term_size203_v0}"
    return 0
}

# stty_term_size()
stty_term_size__205_v0() {
    local command_26
    command_26="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1438="${command_26}"
    store_term_size__203_v0 "${size_1438}"
    ret_stty_term_size205_v0="${ret_store_term_size203_v0}"
    return 0
}

# get_term_size()
get_term_size__206_v0() {
    stty_term_size__205_v0 
    local detected_1445="${ret_stty_term_size205_v0}"
    if [ "$(( ! detected_1445 ))" != 0 ]; then
        query_term_size__204_v0 
        detected_1445="${ret_query_term_size204_v0}"
    fi
    _got_term_size_4=1
}

# term_width()
term_width__208_v0() {
    if [ "$(( ! _got_term_size_4 ))" != 0 ]; then
        get_term_size__206_v0 
    fi
    ret_term_width208_v0="${_term_size_5[0]?"Index out of bounds (at src/utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__220_v0() {
    local pieces_1437=("${!1}")
    term_width__208_v0 
    local width_1447="${ret_term_width208_v0}"
    local line_1448=""
    local line_len_1449=0
    for piece_1450 in "${pieces_1437[@]}"; do
        local __length_29="${piece_1450}"
        local piece_len_1451="${#__length_29}"
        has_ansi_escape__190_v0 "${piece_1450}"
        local ret_has_ansi_escape190_v0__186_12="${ret_has_ansi_escape190_v0}"
        if [ "${ret_has_ansi_escape190_v0__186_12}" != 0 ]; then
            get_visible_len__194_v0 "${piece_1450}"
            piece_len_1451="${ret_get_visible_len194_v0}"
        fi
        if [ "$([ "_${line_1448}" != "_" ]; echo $?)" != 0 ]; then
            line_1448="${piece_1450}"
            line_len_1449="${piece_len_1451}"
        elif [ "$(( $(( $(( line_len_1449 + 1 )) + piece_len_1451 )) > width_1447 ))" != 0 ]; then
            local array_30=()
            printf__128_v0 "${line_1448}""
" array_30[@]
            line_1448="${piece_1450}"
            line_len_1449="${piece_len_1451}"
        else
            line_1448+=" ""${piece_1450}"
            line_len_1449="$(( line_len_1449 + $(( 1 + piece_len_1451 )) ))"
        fi
    done
    if [ "$([ "_${line_1448}" == "_" ]; echo $?)" != 0 ]; then
        local array_31=()
        printf__128_v0 "${line_1448}""
" array_31[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
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
get_supports_truecolor__257_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1484="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1484}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor257_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__258_v0() {
    local message_1479="${1}"
    local r_1480="${2}"
    local g_1481="${3}"
    local b_1482="${4}"
    local fallback_1483="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb258_v0="\\x1b[38;2;${r_1480};${g_1481};${b_1482}m""${message_1479}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__257_v0 
        local ret_get_supports_truecolor257_v0__45_17="${ret_get_supports_truecolor257_v0}"
        if [ "${ret_get_supports_truecolor257_v0__45_17}" != 0 ]; then
            ret_colored_rgb258_v0="\\x1b[38;2;${r_1480};${g_1481};${b_1482}m""${message_1479}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1483 == 0 ))" != 0 ]; then
            ret_colored_rgb258_v0="${message_1479}"
            return 0
        else
            ret_colored_rgb258_v0="\\x1b[${fallback_1483}m""${message_1479}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1483 == 0 ))" != 0 ]; then
            ret_colored_rgb258_v0="${message_1479}"
            return 0
        fi
        ret_colored_rgb258_v0="\\x1b[${fallback_1483}m""${message_1479}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__260_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1468="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1468}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1468}" ";"
            local parts_1469=("${ret_split4_v0[@]}")
            local __length_35=("${parts_1469[@]}")
            if [ "$(( ${#__length_35[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1469[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1469[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1469[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1469[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_10=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1470="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1470}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1470}" ";"
            local parts_1471=("${ret_split4_v0[@]}")
            local __length_37=("${parts_1471[@]}")
            if [ "$(( ${#__length_37[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1471[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1471[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1471[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1471[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_11=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1472="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1472}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1472}" ";"
            local parts_1473=("${ret_split4_v0[@]}")
            local __length_39=("${parts_1473[@]}")
            if [ "$(( ${#__length_39[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1473[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1473[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1473[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1473[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
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
get_xylitol_colors__261_v0() {
    inner_get_xylitol_colors__260_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_9=1
}

# colored_primary(message: Text)
colored_primary__262_v0() {
    local message_1466="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1466}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary262_v0="${ret_colored_rgb258_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__263_v0() {
    local message_1486="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1486}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary263_v0="${ret_colored_rgb258_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__264_v0() {
    local message_1537="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1537}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent264_v0="${ret_colored_rgb258_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# colored(message: Text, color: Int)
colored__316_v0() {
    local message_1525="${1}"
    local color_1526="${2}"
    # Returns a text wrapped in color codes.
    ret_colored316_v0="\\x1b[${color_1526}m""${message_1525}""\\x1b[0m"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_16=0
_term_size_17=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__356_v0() {
    local size_1499="${1}"
    if [ "$([ "_${size_1499}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size356_v0=0
        return 0
    fi
    split__4_v0 "${size_1499}" " "
    local parts_1500=("${ret_split4_v0[@]}")
    local __length_42=("${parts_1500[@]}")
    if [ "$(( ${#__length_42[@]} != 2 ))" != 0 ]; then
        ret_store_term_size356_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1500[1]?"Index out of bounds (at src/utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1500[0]?"Index out of bounds (at src/utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_17=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size356_v0=1
    return 0
}

# query_term_size()
query_term_size__357_v0() {
    local command_44
    command_44="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1502="${command_44}"
    store_term_size__356_v0 "${size_1502}"
    ret_query_term_size357_v0="${ret_store_term_size356_v0}"
    return 0
}

# stty_term_size()
stty_term_size__358_v0() {
    local command_45
    command_45="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1498="${command_45}"
    store_term_size__356_v0 "${size_1498}"
    ret_stty_term_size358_v0="${ret_store_term_size356_v0}"
    return 0
}

# get_term_size()
get_term_size__359_v0() {
    stty_term_size__358_v0 
    local detected_1501="${ret_stty_term_size358_v0}"
    if [ "$(( ! detected_1501 ))" != 0 ]; then
        query_term_size__357_v0 
        detected_1501="${ret_query_term_size357_v0}"
    fi
    _got_term_size_16=1
}

# term_width()
term_width__361_v0() {
    if [ "$(( ! _got_term_size_16 ))" != 0 ]; then
        get_term_size__359_v0 
    fi
    ret_term_width361_v0="${_term_size_17[0]?"Index out of bounds (at src/utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# 
# The state sits at module level, so only one such widget may be open at a
# time. Reach it through `utils.ab` rather than importing this file directly:
# the compiler keys modules by the literal text of the import path, so a
# second spelling would hand that caller its own copy of these variables.
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__394_v0() {
    local pending_1522="${1}"
    local line_1523="${2}"
    local note_at_1524="${3}"
    if [ "$(( note_at_1524 < 0 ))" != 0 ]; then
        local array_47=()
        printf__128_v0 "${pending_1522}""${line_1523}""
" array_47[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1524 == 0 ))" != 0 ]; then
        colored__316_v0 "${line_1523}" 90
        local ret_colored316_v0__12_40="${ret_colored316_v0}"
        local array_48=()
        printf__128_v0 "${pending_1522}""${ret_colored316_v0__12_40}""
" array_48[@]
    else
        slice__24_v0 "${line_1523}" 0 "${note_at_1524}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1523}" "${note_at_1524}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__316_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored316_v0__13_58="${ret_colored316_v0}"
        local array_49=()
        printf__128_v0 "${pending_1522}""${ret_slice24_v0__13_32}""${ret_colored316_v0__13_58}""
" array_49[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__395_v0() {
    local names_1490=("${!1}")
    local texts_1491=("${!2}")
    local notes_1492=("${!3}")
    local min_name_width_1493="${4}"
    local __length_50=("${names_1490[@]}")
    local count_1494="${#__length_50[@]}"
    local name_width_1495="${min_name_width_1493}"
    local __range_start_1496=0
    local __range_end_1496="${count_1494}"
    local __dir_1496=$(( ${__range_start_1496} <= ${__range_end_1496} ? 1 : -1 ))
    for (( i_1496=${__range_start_1496}; i_1496 * ${__dir_1496} < ${__range_end_1496} * ${__dir_1496}; i_1496+=${__dir_1496} )); do
        local __length_51="${names_1490[${i_1496}]?"Index out of bounds (at src/utils/widget/help.ab:28:33)"}"
        local width_1497="${#__length_51}"
        if [ "$(( width_1497 > name_width_1495 ))" != 0 ]; then
            name_width_1495="${width_1497}"
        fi
done
    term_width__361_v0 
    local width_1503="${ret_term_width361_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1504="$(( name_width_1495 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1505="$(( $(( width_1503 - indent_1504 )) < 24 ))"
    if [ "${stacked_1505}" != 0 ]; then
        indent_1504=6
    fi
    local avail_1506="$(( width_1503 - indent_1504 ))"
    rpad__28_v0 "" " " "${indent_1504}"
    local blank_1512="${ret_rpad28_v0}"
    local __range_start_1513=0
    local __range_end_1513="${count_1494}"
    local __dir_1513=$(( ${__range_start_1513} <= ${__range_end_1513} ? 1 : -1 ))
    for (( i_1513=${__range_start_1513}; i_1513 * ${__dir_1513} < ${__range_end_1513} * ${__dir_1513}; i_1513+=${__dir_1513} )); do
        local pending_1514="${blank_1512}"
        if [ "${stacked_1505}" != 0 ]; then
            local array_52=()
            printf__128_v0 "  ""${names_1490[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:48:33)"}""
" array_52[@]
        else
            rpad__28_v0 "  ""${names_1490[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:50:41)"}" " " "${indent_1504}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_1514="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_1491[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_1515=("${ret_split4_v0__52_21[@]}")
        local __length_53=("${words_1515[@]}")
        local note_start_1516="${#__length_53[@]}"
        if [ "$([ "_${notes_1492[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_54="${notes_1492[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_54} > avail_1506 ))" != 0 ]; then
                split__4_v0 "${notes_1492[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_1515+=("${ret_split4_v0__58_26[@]}")
            else
                local array_55=("${notes_1492[${i_1513}]?"Index out of bounds (at src/utils/widget/help.ab:60:33)"}")
                words_1515+=("${array_55[@]}")
            fi
        fi
        local line_1517=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1518=-1
        local __range_start_1519=0
        local __length_56=("${words_1515[@]}")
        local __range_end_1519="${#__length_56[@]}"
        local __dir_1519=$(( ${__range_start_1519} <= ${__range_end_1519} ? 1 : -1 ))
        for (( j_1519=${__range_start_1519}; j_1519 * ${__dir_1519} < ${__range_end_1519} * ${__dir_1519}; j_1519+=${__dir_1519} )); do
            local word_1520="${words_1515[${j_1519}]?"Index out of bounds (at src/utils/widget/help.ab:70:32)"}"
            local candidate_1521
            candidate_1521="$(if [ "$([ "_${line_1517}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1520}"; else echo "${line_1517}"" ""${word_1520}"; fi)"
            local __length_57="${candidate_1521}"
            if [ "$(( $(( ${#__length_57} > avail_1506 )) && $([ "_${line_1517}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__394_v0 "${pending_1514}" "${line_1517}" "${note_at_1518}"
                pending_1514="${blank_1512}"
                line_1517="${word_1520}"
                note_at_1518="$(if [ "$(( j_1519 >= note_start_1516 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1519 >= note_start_1516 )) && $(( note_at_1518 < 0 )) ))" != 0 ]; then
                    local __length_58="${candidate_1521}"
                    local __length_59="${word_1520}"
                    note_at_1518="$(( ${#__length_58} - ${#__length_59} ))"
                fi
                line_1517="${candidate_1521}"
            fi
done
        print_help_line__394_v0 "${pending_1514}" "${line_1517}" "${note_at_1518}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__552_v0() {
    local usage_1436=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__220_v0 usage_1436[@]
    printf '%s\n' ""
    colored_primary__262_v0 "Xylitol"
    local ret_colored_primary262_v0__9_21="${ret_colored_primary262_v0}"
    colored_primary__262_v0 "fresh"
    local ret_colored_primary262_v0__10_34="${ret_colored_primary262_v0}"
    local title_1485=("\\x1b[1m""${ret_colored_primary262_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary262_v0__10_34}" "shell" "scripts.")
    print_wrapped__220_v0 title_1485[@]
    printf '%s\n' ""
    colored_secondary__263_v0 "Flags:"
    local ret_colored_secondary263_v0__14_12="${ret_colored_secondary263_v0}"
    local array_62=()
    printf__128_v0 "${ret_colored_secondary263_v0__14_12}""
" array_62[@]
    local flag_names_1487=("-h, --help" "-v, --version")
    local flag_texts_1488=("Show this help message" "Show version information")
    local flag_notes_1489=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__395_v0 flag_names_1487[@] flag_texts_1488[@] flag_notes_1489[@] 13
    printf '%s\n' ""
    colored_secondary__263_v0 "Commands:"
    local ret_colored_secondary263_v0__21_12="${ret_colored_secondary263_v0}"
    local array_66=()
    printf__128_v0 "${ret_colored_secondary263_v0__21_12}""
" array_66[@]
    local cmd_names_1531=("input" "choose" "confirm" "file")
    local cmd_texts_1532=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1533=("" "" "" "")
    render_help_entries__395_v0 cmd_names_1531[@] cmd_texts_1532[@] cmd_notes_1533[@] 13
    printf '%s\n' ""
    colored_secondary__263_v0 "Envs:"
    local ret_colored_secondary263_v0__32_12="${ret_colored_secondary263_v0}"
    local array_70=()
    printf__128_v0 "${ret_colored_secondary263_v0__32_12}""
" array_70[@]
    local env_names_1534=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1535=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1536=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__395_v0 env_names_1534[@] env_texts_1535[@] env_notes_1536[@] 0
    printf '%s\n' ""
    colored_accent__264_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent264_v0__57_16="${ret_colored_accent264_v0}"
    local footer_1538=("Run" "${ret_colored_accent264_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__220_v0 footer_1538[@]
}

# math_floor(number: Int)
math_floor__633_v0() {
    local number_3087="${1}"
    local command_75
    command_75="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_3087}")"
    __status=$?
    ret_math_floor633_v0="${command_75}"
    return 0
}

# math_ceil(number: Int)
math_ceil__634_v0() {
    local number_3086="${1}"
    math_floor__633_v0 "${number_3086}"
    local ret_math_floor633_v0__52_12="${ret_math_floor633_v0}"
    ret_math_ceil634_v0="$(( ret_math_floor633_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__642_v0() {
    local command_76
    command_76="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3081="${command_76}"
    ret_get_char642_v0="${char_3081}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__645_v0() {
    local format_3053="${1}"
    local args_3054=("${!2}")
    args_3054=("${format_3053}" "${args_3054[@]}")
    __status=$?
    printf "${args_3054[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__646_v0() {
    local message_3079="${1}"
    local color_3080="${2}"
    # Prints an error message with a specified color.
    local array_77=("${message_3079}")
    eprintf__645_v0 "\\x1b[${color_3080}m%s\\x1b[0m" array_77[@]
}

# eprintf(format: Text, args: [Text])
eprintf__661_v0() {
    local format_3057="${1}"
    local args_3058=("${!2}")
    args_3058=("${format_3057}" "${args_3058[@]}")
    __status=$?
    printf "${args_3058[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_24="None"
# perl_available()
perl_available__668_v0() {
    if [ "$([ "_${_perl_state_24}" != "_None" ]; echo $?)" != 0 ]; then
        local command_78
        command_78="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_2950
        disabled_2950="$([ "_${command_78}" != "_No" ]; echo $?)"
        local command_79
        command_79="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_2951
        found_2951="$(( $(( ! disabled_2950 )) && $([ "_${command_79}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_2951}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available668_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__669_v0() {
    local text_2949="${1}"
    perl_available__668_v0 
    local ret_perl_available668_v0__22_12="${ret_perl_available668_v0}"
    if [ "$(( ! ret_perl_available668_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width669_v0=''
        return 1
    fi
    local command_80
    command_80="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2949}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width669_v0=''
        return "${__status}"
    fi
    local width_str_2952="${command_80}"
    parse_int__13_v0 "${width_str_2952}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width669_v0=''
        return "${__status}"
    fi
    local width_2953="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width669_v0="${width_2953}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__674_v0() {
    local text_2942="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_81
    command_81="$([[ "${text_2942}" == *$'\x1b'* || "${text_2942}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2943="${command_81}"
    ret_has_ansi_escape674_v0="$([ "_${has_escape_2943}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__676_v0() {
    local text_2945="${1}"
    local command_82
    command_82="$(printf "%s" "${text_2945}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi676_v0="${command_82}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__677_v0() {
    local text_2947="${1}"
    local command_83
    command_83="$(printf "%s" "${text_2947}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2948="${command_83}"
    ret_is_all_ascii677_v0="$([ "_${result_2948}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__678_v0() {
    local text_2944="${1}"
    strip_ansi__676_v0 "${text_2944}"
    local stripped_2946="${ret_strip_ansi676_v0}"
    # Check if text is all ASCII
    is_all_ascii__677_v0 "${stripped_2946}"
    local ret_is_all_ascii677_v0__36_12="${ret_is_all_ascii677_v0}"
    if [ "$(( ! ret_is_all_ascii677_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__669_v0 "${stripped_2946}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_84="${stripped_2946}"
            ret_get_visible_len678_v0="${#__length_84}"
            return 0
        fi
        ret_get_visible_len678_v0="${ret_perl_get_cjk_width669_v0}"
        return 0
    else
        local __length_85="${stripped_2946}"
        ret_get_visible_len678_v0="${#__length_85}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_25=0
_term_size_26=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__684_v0() {
    local command_87
    command_87="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_3014="${command_87}"
    parse_int__13_v0 "${count_3014}"
    __status=$?
    ret_stty_count684_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__685_v0() {
    stty_count__684_v0 
    local count_num_3015="${ret_stty_count684_v0}"
    if [ "$(( count_num_3015 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_3015="$(( count_num_3015 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3015}
    __status=$?
}

# stty_unlock()
stty_unlock__686_v0() {
    stty_count__684_v0 
    local count_num_3084="${ret_stty_count684_v0}"
    if [ "$(( count_num_3084 > 0 ))" != 0 ]; then
        count_num_3084="$(( count_num_3084 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3084}
        __status=$?
        if [ "$(( count_num_3084 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__687_v0() {
    local size_2933="${1}"
    if [ "$([ "_${size_2933}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size687_v0=0
        return 0
    fi
    split__4_v0 "${size_2933}" " "
    local parts_2934=("${ret_split4_v0[@]}")
    local __length_88=("${parts_2934[@]}")
    if [ "$(( ${#__length_88[@]} != 2 ))" != 0 ]; then
        ret_store_term_size687_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2934[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2934[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_26=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size687_v0=1
    return 0
}

# query_term_size()
query_term_size__688_v0() {
    local command_90
    command_90="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2936="${command_90}"
    store_term_size__687_v0 "${size_2936}"
    ret_query_term_size688_v0="${ret_store_term_size687_v0}"
    return 0
}

# stty_term_size()
stty_term_size__689_v0() {
    local command_91
    command_91="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2932="${command_91}"
    store_term_size__687_v0 "${size_2932}"
    ret_stty_term_size689_v0="${ret_store_term_size687_v0}"
    return 0
}

# get_term_size()
get_term_size__690_v0() {
    stty_term_size__689_v0 
    local detected_2935="${ret_stty_term_size689_v0}"
    if [ "$(( ! detected_2935 ))" != 0 ]; then
        query_term_size__688_v0 
        detected_2935="${ret_query_term_size688_v0}"
    fi
    _got_term_size_25=1
}

# term_width()
term_width__692_v0() {
    if [ "$(( ! _got_term_size_25 ))" != 0 ]; then
        get_term_size__690_v0 
    fi
    ret_term_width692_v0="${_term_size_26[0]?"Index out of bounds (at src/./input/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove(cnt: Int)
remove__694_v0() {
    local cnt_3082="${1}"
    if [ "$(( cnt_3082 > 0 ))" != 0 ]; then
        local array_92=("")
        eprintf__661_v0 "\\x1b[${cnt_3082}D\\x1b[K" array_92[@]
    fi
}

# remove_line(cnt: Int)
remove_line__695_v0() {
    local cnt_3090="${1}"
    if [ "$(( cnt_3090 > 0 ))" != 0 ]; then
        local sequence_3091=""
        local __range_start_3092=0
        local __range_end_3092="${cnt_3090}"
        local __dir_3092=$(( ${__range_start_3092} <= ${__range_end_3092} ? 1 : -1 ))
        for (( ____3092=${__range_start_3092}; ____3092 * ${__dir_3092} < ${__range_end_3092} * ${__dir_3092}; ____3092+=${__dir_3092} )); do
            sequence_3091+="\\x1b[2K\\x1b[1A"
done
        local array_93=("")
        eprintf__661_v0 "${sequence_3091}" array_93[@]
    fi
    local array_94=("")
    eprintf__661_v0 "\\x1b[G" array_94[@]
}

# remove_current_line()
remove_current_line__696_v0() {
    local array_95=("")
    eprintf__661_v0 "\\x1b[2K\\x1b[G" array_95[@]
}

# new_line(cnt: Int)
new_line__698_v0() {
    local cnt_3055="${1}"
    local __range_start_3056=0
    local __range_end_3056="${cnt_3055}"
    local __dir_3056=$(( ${__range_start_3056} <= ${__range_end_3056} ? 1 : -1 ))
    for (( ____3056=${__range_start_3056}; ____3056 * ${__dir_3056} < ${__range_end_3056} * ${__dir_3056}; ____3056+=${__dir_3056} )); do
        local array_96=("")
        eprintf__661_v0 "
" array_96[@]
done
}

# go_up(cnt: Int)
go_up__699_v0() {
    local cnt_3076="${1}"
    local array_97=("")
    eprintf__661_v0 "\\x1b[${cnt_3076}A" array_97[@]
}

# go_down(cnt: Int)
go_down__700_v0() {
    local cnt_3089="${1}"
    local array_98=("")
    eprintf__661_v0 "\\x1b[${cnt_3089}B" array_98[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__704_v0() {
    local pieces_2931=("${!1}")
    term_width__692_v0 
    local width_2937="${ret_term_width692_v0}"
    local line_2938=""
    local line_len_2939=0
    for piece_2940 in "${pieces_2931[@]}"; do
        local __length_101="${piece_2940}"
        local piece_len_2941="${#__length_101}"
        has_ansi_escape__674_v0 "${piece_2940}"
        local ret_has_ansi_escape674_v0__186_12="${ret_has_ansi_escape674_v0}"
        if [ "${ret_has_ansi_escape674_v0__186_12}" != 0 ]; then
            get_visible_len__678_v0 "${piece_2940}"
            piece_len_2941="${ret_get_visible_len678_v0}"
        fi
        if [ "$([ "_${line_2938}" != "_" ]; echo $?)" != 0 ]; then
            line_2938="${piece_2940}"
            line_len_2939="${piece_len_2941}"
        elif [ "$(( $(( $(( line_len_2939 + 1 )) + piece_len_2941 )) > width_2937 ))" != 0 ]; then
            local array_102=()
            printf__128_v0 "${line_2938}""
" array_102[@]
            line_2938="${piece_2940}"
            line_len_2939="${piece_len_2941}"
        else
            line_2938+=" ""${piece_2940}"
            line_len_2939="$(( line_len_2939 + $(( 1 + piece_len_2941 )) ))"
        fi
    done
    if [ "$([ "_${line_2938}" == "_" ]; echo $?)" != 0 ]; then
        local array_103=()
        printf__128_v0 "${line_2938}""
" array_103[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_29="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_30=0
_primary_color_31=(3 207 159 92)
_secondary_color_32=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__741_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_2966="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_2966}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor741_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__742_v0() {
    local message_2961="${1}"
    local r_2962="${2}"
    local g_2963="${3}"
    local b_2964="${4}"
    local fallback_2965="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb742_v0="\\x1b[38;2;${r_2962};${g_2963};${b_2964}m""${message_2961}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__741_v0 
        local ret_get_supports_truecolor741_v0__45_17="${ret_get_supports_truecolor741_v0}"
        if [ "${ret_get_supports_truecolor741_v0__45_17}" != 0 ]; then
            ret_colored_rgb742_v0="\\x1b[38;2;${r_2962};${g_2963};${b_2964}m""${message_2961}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2965 == 0 ))" != 0 ]; then
            ret_colored_rgb742_v0="${message_2961}"
            return 0
        else
            ret_colored_rgb742_v0="\\x1b[${fallback_2965}m""${message_2961}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2965 == 0 ))" != 0 ]; then
            ret_colored_rgb742_v0="${message_2961}"
            return 0
        fi
        ret_colored_rgb742_v0="\\x1b[${fallback_2965}m""${message_2961}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__744_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2955="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2955}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2955}" ";"
            local parts_2956=("${ret_split4_v0[@]}")
            local __length_107=("${parts_2956[@]}")
            if [ "$(( ${#__length_107[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2956[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2956[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2956[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2956[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_31=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2957="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2957}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2957}" ";"
            local parts_2958=("${ret_split4_v0[@]}")
            local __length_109=("${parts_2958[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2958[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2958[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2958[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2958[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_32=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2959="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2959}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2959}" ";"
            local parts_2960=("${ret_split4_v0[@]}")
            local __length_111=("${parts_2960[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2960[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2960[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2960[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2960[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_30=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__745_v0() {
    inner_get_xylitol_colors__744_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_30=1
}

# colored_primary(message: Text)
colored_primary__746_v0() {
    local message_2954="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__745_v0 
    fi
    colored_rgb__742_v0 "${message_2954}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary746_v0="${ret_colored_rgb742_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__747_v0() {
    local message_2968="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__745_v0 
    fi
    colored_rgb__742_v0 "${message_2968}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary747_v0="${ret_colored_rgb742_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_34="None"
# perl_available()
perl_available__764_v0() {
    if [ "$([ "_${_perl_state_34}" != "_None" ]; echo $?)" != 0 ]; then
        local command_113
        command_113="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3025
        disabled_3025="$([ "_${command_113}" != "_No" ]; echo $?)"
        local command_114
        command_114="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3026
        found_3026="$(( $(( ! disabled_3025 )) && $([ "_${command_114}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3026}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available764_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__765_v0() {
    local text_3024="${1}"
    perl_available__764_v0 
    local ret_perl_available764_v0__22_12="${ret_perl_available764_v0}"
    if [ "$(( ! ret_perl_available764_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width765_v0=''
        return 1
    fi
    local command_115
    command_115="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3024}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width765_v0=''
        return "${__status}"
    fi
    local width_str_3027="${command_115}"
    parse_int__13_v0 "${width_str_3027}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width765_v0=''
        return "${__status}"
    fi
    local width_3028="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width765_v0="${width_3028}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__766_v0() {
    local text_3035="${1}"
    local max_width_3036="${2}"
    perl_available__764_v0 
    local ret_perl_available764_v0__33_12="${ret_perl_available764_v0}"
    if [ "$(( ! ret_perl_available764_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk766_v0=''
        return 1
    fi
    local command_116
    command_116="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3035}" ${max_width_3036} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk766_v0=''
        return "${__status}"
    fi
    local result_3037="${command_116}"
    ret_perl_truncate_cjk766_v0="${result_3037}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__770_v0() {
    local text_3006="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_117
    command_117="$([[ "${text_3006}" == *$'\x1b'* || "${text_3006}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3007="${command_117}"
    ret_has_ansi_escape770_v0="$([ "_${has_escape_3007}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__771_v0() {
    local text_3008="${1}"
    local command_118
    command_118="$(printf '%s' "${text_3008}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi771_v0="${command_118}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__772_v0() {
    local text_3020="${1}"
    local command_119
    command_119="$(printf "%s" "${text_3020}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi772_v0="${command_119}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__773_v0() {
    local text_3022="${1}"
    local command_120
    command_120="$(printf "%s" "${text_3022}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3023="${command_120}"
    ret_is_all_ascii773_v0="$([ "_${result_3023}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__774_v0() {
    local text_3019="${1}"
    strip_ansi__772_v0 "${text_3019}"
    local stripped_3021="${ret_strip_ansi772_v0}"
    # Check if text is all ASCII
    is_all_ascii__773_v0 "${stripped_3021}"
    local ret_is_all_ascii773_v0__36_12="${ret_is_all_ascii773_v0}"
    if [ "$(( ! ret_is_all_ascii773_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__765_v0 "${stripped_3021}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_121="${stripped_3021}"
            ret_get_visible_len774_v0="${#__length_121}"
            return 0
        fi
        ret_get_visible_len774_v0="${ret_perl_get_cjk_width765_v0}"
        return 0
    else
        local __length_122="${stripped_3021}"
        ret_get_visible_len774_v0="${#__length_122}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__775_v0() {
    local text_3032="${1}"
    local max_width_3033="${2}"
    get_visible_len__774_v0 "${text_3032}"
    local visible_len_3034="${ret_get_visible_len774_v0}"
    if [ "$(( visible_len_3034 <= max_width_3033 ))" != 0 ]; then
        ret_truncate_text775_v0="${text_3032}"
        return 0
    fi
    is_all_ascii__773_v0 "${text_3032}"
    local ret_is_all_ascii773_v0__53_12="${ret_is_all_ascii773_v0}"
    if [ "$(( ! ret_is_all_ascii773_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__766_v0 "${text_3032}" "${max_width_3033}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3032}" | cut -c1-${max_width_3033}
            __status=$?
        fi
        ret_truncate_text775_v0="${ret_perl_truncate_cjk766_v0}"
        return 0
    fi
    local command_123
    command_123="$(printf "%s" "${text_3032}" | cut -c1-${max_width_3033})"
    __status=$?
    ret_truncate_text775_v0="${command_123}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__776_v0() {
    local text_3030="${1}"
    local max_width_3031="${2}"
    has_ansi_escape__770_v0 "${text_3030}"
    local ret_has_ansi_escape770_v0__65_12="${ret_has_ansi_escape770_v0}"
    if [ "$(( ! ret_has_ansi_escape770_v0__65_12 ))" != 0 ]; then
        truncate_text__775_v0 "${text_3030}" "${max_width_3031}"
        ret_truncate_ansi776_v0="${ret_truncate_text775_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_124
    command_124="$([[ "${text_3030}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3038="${command_124}"
    # Replace \x1b[ with newline, then split
    local command_125
    command_125="$(t="${text_3030}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3039="${command_125}"
    split__4_v0 "${replaced_3039}" "
"
    local parts_3040=("${ret_split4_v0[@]}")
    local result_3041=""
    local remaining_width_3042="${max_width_3031}"
    local __range_start_3043=0
    local __length_126=("${parts_3040[@]}")
    local __range_end_3043="${#__length_126[@]}"
    local __dir_3043=$(( ${__range_start_3043} <= ${__range_end_3043} ? 1 : -1 ))
    for (( idx_3043=${__range_start_3043}; idx_3043 * ${__dir_3043} < ${__range_end_3043} * ${__dir_3043}; idx_3043+=${__dir_3043} )); do
        local part_3044="${parts_3040[${idx_3043}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3043 == 0 )) && $([ "_${starts_with_ansi_3038}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3044}" == "_" ]; echo $?) && $(( remaining_width_3042 > 0 )) ))" != 0 ]; then
                truncate_text__775_v0 "${part_3044}" "${remaining_width_3042}"
                local ret_truncate_text775_v0__87_35="${ret_truncate_text775_v0}"
                local truncated_3045="${ret_truncate_text775_v0__87_35}"
                result_3041+="${truncated_3045}"
                get_visible_len__774_v0 "${truncated_3045}"
                local ret_get_visible_len774_v0__89_36="${ret_get_visible_len774_v0}"
                remaining_width_3042="$(( remaining_width_3042 - ret_get_visible_len774_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_127
            command_127="$(__p="${part_3044}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3046="${command_127}"
            if [ "$([ "_${m_idx_3046}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_128
                command_128="$(__p="${part_3044}"; printf "%s" "${__p:0:${m_idx_3046}}")"
                __status=$?
                local ansi_params_3047="${command_128}"
                result_3041+="\\x1b[""${ansi_params_3047}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3046}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_3048="${ret_parse_int13_v0__100_41}"
                local text_start_3049="$(( m_idx_num_3048 + 1 ))"
                local command_129
                command_129="$(__p="${part_3044}"; printf "%s" "${__p:${text_start_3049}}")"
                __status=$?
                local text_part_3050="${command_129}"
                if [ "$(( $([ "_${text_part_3050}" == "_" ]; echo $?) && $(( remaining_width_3042 > 0 )) ))" != 0 ]; then
                    truncate_text__775_v0 "${text_part_3050}" "${remaining_width_3042}"
                    local ret_truncate_text775_v0__104_39="${ret_truncate_text775_v0}"
                    local truncated_3051="${ret_truncate_text775_v0__104_39}"
                    result_3041+="${truncated_3051}"
                    get_visible_len__774_v0 "${truncated_3051}"
                    local ret_get_visible_len774_v0__106_40="${ret_get_visible_len774_v0}"
                    remaining_width_3042="$(( remaining_width_3042 - ret_get_visible_len774_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3044}" == "_" ]; echo $?) && $(( remaining_width_3042 > 0 )) ))" != 0 ]; then
                    truncate_text__775_v0 "${part_3044}" "${remaining_width_3042}"
                    local ret_truncate_text775_v0__111_39="${ret_truncate_text775_v0}"
                    local truncated_3052="${ret_truncate_text775_v0__111_39}"
                    result_3041+="${truncated_3052}"
                    get_visible_len__774_v0 "${truncated_3052}"
                    local ret_get_visible_len774_v0__113_40="${ret_get_visible_len774_v0}"
                    remaining_width_3042="$(( remaining_width_3042 - ret_get_visible_len774_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi776_v0="${result_3041}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__777_v0() {
    local text_3017="${1}"
    local max_width_3018="${2}"
    get_visible_len__774_v0 "${text_3017}"
    local visible_len_3029="${ret_get_visible_len774_v0}"
    if [ "$(( visible_len_3029 <= max_width_3018 ))" != 0 ]; then
        ret_cutoff_text777_v0="${text_3017}"
        return 0
    fi
    truncate_ansi__776_v0 "${text_3017}" "$(( max_width_3018 - 3 ))"
    local ret_truncate_ansi776_v0__129_12="${ret_truncate_ansi776_v0}"
    ret_cutoff_text777_v0="${ret_truncate_ansi776_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__798_v0() {
    local format_3067="${1}"
    local args_3068=("${!2}")
    args_3068=("${format_3067}" "${args_3068[@]}")
    __status=$?
    printf "${args_3068[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__799_v0() {
    local message_3065="${1}"
    local color_3066="${2}"
    # Prints an error message with a specified color.
    local array_130=("${message_3065}")
    eprintf__798_v0 "\\x1b[${color_3066}m%s\\x1b[0m" array_130[@]
}

# colored(message: Text, color: Int)
colored__800_v0() {
    local message_3002="${1}"
    local color_3003="${2}"
    # Returns a text wrapped in color codes.
    ret_colored800_v0="\\x1b[${color_3003}m""${message_3002}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__804_v0() {
    local items_3059=("${!1}")
    local total_len_3060="${2}"
    local term_width_3061="${3}"
    local separator_3062=" • "
    local separator_len_3063=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3060 <= term_width_3061 ))" != 0 ]; then
        local iter_3064=0
        while :
        do
            local __length_131=("${items_3059[@]}")
            if [ "$(( iter_3064 >= ${#__length_131[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3064 > 0 ))" != 0 ]; then
                eprintf_colored__799_v0 "${separator_3062}" 90
            fi
            colored__800_v0 "${items_3059[$(( iter_3064 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored800_v0__23_41="${ret_colored800_v0}"
            local array_132=("")
            eprintf__798_v0 "${items_3059[${iter_3064}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored800_v0__23_41}" array_132[@]
            iter_3064="$(( iter_3064 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3069=0
        local first_3070=1
        local iter_3071=0
        while :
        do
            local __length_133=("${items_3059[@]}")
            if [ "$(( iter_3071 >= ${#__length_133[@]} ))" != 0 ]; then
                break
            fi
            local key_3072="${items_3059[${iter_3071}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3073="${items_3059[$(( iter_3071 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_134="${key_3072}"
            local __length_135="${action_3073}"
            local part_len_3074="$(( $(( ${#__length_134} + 1 )) + ${#__length_135} ))"
            local needed_3075="${part_len_3074}"
            if [ "$(( ! first_3070 ))" != 0 ]; then
                needed_3075="$(( needed_3075 + separator_len_3063 ))"
            fi
            if [ "$(( $(( current_len_3069 + needed_3075 )) > term_width_3061 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3070 ))" != 0 ]; then
                eprintf_colored__799_v0 "${separator_3062}" 90
            fi
            colored__800_v0 "${action_3073}" 2
            local ret_colored800_v0__51_33="${ret_colored800_v0}"
            local array_136=("")
            eprintf__798_v0 "${key_3072}"" ""${ret_colored800_v0__51_33}" array_136[@]
            current_len_3069="$(( current_len_3069 + needed_3075 ))"
            first_3070=0
            iter_3071="$(( iter_3071 + 2 ))"
        done
    fi
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_37=0
_term_size_38=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__840_v0() {
    local size_2981="${1}"
    if [ "$([ "_${size_2981}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size840_v0=0
        return 0
    fi
    split__4_v0 "${size_2981}" " "
    local parts_2982=("${ret_split4_v0[@]}")
    local __length_138=("${parts_2982[@]}")
    if [ "$(( ${#__length_138[@]} != 2 ))" != 0 ]; then
        ret_store_term_size840_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2982[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2982[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_38=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size840_v0=1
    return 0
}

# query_term_size()
query_term_size__841_v0() {
    local command_140
    command_140="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2984="${command_140}"
    store_term_size__840_v0 "${size_2984}"
    ret_query_term_size841_v0="${ret_store_term_size840_v0}"
    return 0
}

# stty_term_size()
stty_term_size__842_v0() {
    local command_141
    command_141="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2980="${command_141}"
    store_term_size__840_v0 "${size_2980}"
    ret_stty_term_size842_v0="${ret_store_term_size840_v0}"
    return 0
}

# get_term_size()
get_term_size__843_v0() {
    stty_term_size__842_v0 
    local detected_2983="${ret_stty_term_size842_v0}"
    if [ "$(( ! detected_2983 ))" != 0 ]; then
        query_term_size__841_v0 
        detected_2983="${ret_query_term_size841_v0}"
    fi
    _got_term_size_37=1
}

# term_width()
term_width__845_v0() {
    if [ "$(( ! _got_term_size_37 ))" != 0 ]; then
        get_term_size__843_v0 
    fi
    ret_term_width845_v0="${_term_size_38[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# 
# The state sits at module level, so only one such widget may be open at a
# time. Reach it through `utils.ab` rather than importing this file directly:
# the compiler keys modules by the literal text of the import path, so a
# second spelling would hand that caller its own copy of these variables.
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__878_v0() {
    local pending_2999="${1}"
    local line_3000="${2}"
    local note_at_3001="${3}"
    if [ "$(( note_at_3001 < 0 ))" != 0 ]; then
        local array_143=()
        printf__128_v0 "${pending_2999}""${line_3000}""
" array_143[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3001 == 0 ))" != 0 ]; then
        colored__800_v0 "${line_3000}" 90
        local ret_colored800_v0__12_40="${ret_colored800_v0}"
        local array_144=()
        printf__128_v0 "${pending_2999}""${ret_colored800_v0__12_40}""
" array_144[@]
    else
        slice__24_v0 "${line_3000}" 0 "${note_at_3001}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3000}" "${note_at_3001}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__800_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored800_v0__13_58="${ret_colored800_v0}"
        local array_145=()
        printf__128_v0 "${pending_2999}""${ret_slice24_v0__13_32}""${ret_colored800_v0__13_58}""
" array_145[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__879_v0() {
    local names_2972=("${!1}")
    local texts_2973=("${!2}")
    local notes_2974=("${!3}")
    local min_name_width_2975="${4}"
    local __length_146=("${names_2972[@]}")
    local count_2976="${#__length_146[@]}"
    local name_width_2977="${min_name_width_2975}"
    local __range_start_2978=0
    local __range_end_2978="${count_2976}"
    local __dir_2978=$(( ${__range_start_2978} <= ${__range_end_2978} ? 1 : -1 ))
    for (( i_2978=${__range_start_2978}; i_2978 * ${__dir_2978} < ${__range_end_2978} * ${__dir_2978}; i_2978+=${__dir_2978} )); do
        local __length_147="${names_2972[${i_2978}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_2979="${#__length_147}"
        if [ "$(( width_2979 > name_width_2977 ))" != 0 ]; then
            name_width_2977="${width_2979}"
        fi
done
    term_width__845_v0 
    local width_2985="${ret_term_width845_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2986="$(( name_width_2977 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2987="$(( $(( width_2985 - indent_2986 )) < 24 ))"
    if [ "${stacked_2987}" != 0 ]; then
        indent_2986=6
    fi
    local avail_2988="$(( width_2985 - indent_2986 ))"
    rpad__28_v0 "" " " "${indent_2986}"
    local blank_2989="${ret_rpad28_v0}"
    local __range_start_2990=0
    local __range_end_2990="${count_2976}"
    local __dir_2990=$(( ${__range_start_2990} <= ${__range_end_2990} ? 1 : -1 ))
    for (( i_2990=${__range_start_2990}; i_2990 * ${__dir_2990} < ${__range_end_2990} * ${__dir_2990}; i_2990+=${__dir_2990} )); do
        local pending_2991="${blank_2989}"
        if [ "${stacked_2987}" != 0 ]; then
            local array_148=()
            printf__128_v0 "  ""${names_2972[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_148[@]
        else
            rpad__28_v0 "  ""${names_2972[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_2986}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_2991="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_2973[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_2992=("${ret_split4_v0__52_21[@]}")
        local __length_149=("${words_2992[@]}")
        local note_start_2993="${#__length_149[@]}"
        if [ "$([ "_${notes_2974[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_150="${notes_2974[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_150} > avail_2988 ))" != 0 ]; then
                split__4_v0 "${notes_2974[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_2992+=("${ret_split4_v0__58_26[@]}")
            else
                local array_151=("${notes_2974[${i_2990}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_2992+=("${array_151[@]}")
            fi
        fi
        local line_2994=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2995=-1
        local __range_start_2996=0
        local __length_152=("${words_2992[@]}")
        local __range_end_2996="${#__length_152[@]}"
        local __dir_2996=$(( ${__range_start_2996} <= ${__range_end_2996} ? 1 : -1 ))
        for (( j_2996=${__range_start_2996}; j_2996 * ${__dir_2996} < ${__range_end_2996} * ${__dir_2996}; j_2996+=${__dir_2996} )); do
            local word_2997="${words_2992[${j_2996}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_2998
            candidate_2998="$(if [ "$([ "_${line_2994}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2997}"; else echo "${line_2994}"" ""${word_2997}"; fi)"
            local __length_153="${candidate_2998}"
            if [ "$(( $(( ${#__length_153} > avail_2988 )) && $([ "_${line_2994}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__878_v0 "${pending_2991}" "${line_2994}" "${note_at_2995}"
                pending_2991="${blank_2989}"
                line_2994="${word_2997}"
                note_at_2995="$(if [ "$(( j_2996 >= note_start_2993 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2996 >= note_start_2993 )) && $(( note_at_2995 < 0 )) ))" != 0 ]; then
                    local __length_154="${candidate_2998}"
                    local __length_155="${word_2997}"
                    note_at_2995="$(( ${#__length_154} - ${#__length_155} ))"
                fi
                line_2994="${candidate_2998}"
            fi
done
        print_help_line__878_v0 "${pending_2991}" "${line_2994}" "${note_at_2995}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__937_v0() {
    local prompt_3010="${1}"
    local placeholder_3011="${2}"
    local header_3012="${3}"
    local password_3013="${4}"
    stty_lock__685_v0 
    term_width__692_v0 
    local term_width_3016="${ret_term_width692_v0}"
    if [ "$([ "_${header_3012}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__777_v0 "${header_3012}" "${term_width_3016}"
        local ret_cutoff_text777_v0__25_17="${ret_cutoff_text777_v0}"
        local array_156=("")
        eprintf__645_v0 "${ret_cutoff_text777_v0__25_17}""
" array_156[@]
    fi
    new_line__698_v0 2
    # "enter submit" = 12
    local array_157=("enter" "submit")
    render_tooltip__804_v0 array_157[@] 12 "${term_width_3016}"
    go_up__699_v0 2
    local array_158=("")
    eprintf__645_v0 "\\x1b[G" array_158[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_159
    command_159="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3077="${command_159}"
    local char_3078=""
    local array_160=("")
    eprintf__645_v0 "${prompt_3010}" array_160[@]
    if [ "$([ "_${can_preset_3077}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__646_v0 "${placeholder_3011}" 90
        get_char__642_v0 
        char_3078="${ret_get_char642_v0}"
        local __length_161="${placeholder_3011}"
        remove__694_v0 "$(( ${#__length_161} + 1 ))"
    fi
    local __length_162="${prompt_3010}"
    remove__694_v0 "${#__length_162}"
    local text_3083=""
    if [ "$(( ! password_3013 ))" != 0 ]; then
        stty_unlock__686_v0 
        local command_163
        command_163="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3078}" -p "${prompt_3010}" text < /dev/tty; else read -e -p "${prompt_3010}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3083="${command_163}"
    else
        stty_unlock__686_v0 
        local command_164
        command_164="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3078}" -p "${prompt_3010}" text < /dev/tty; else read -es -p "${prompt_3010}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3083="${command_164}"
    fi
    stty_lock__685_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__774_v0 "${prompt_3010}""${text_3083}"
    local input_display_len_3085="${ret_get_visible_len774_v0}"
    math_ceil__634_v0 "$(( input_display_len_3085 / term_width_3016 ))"
    local input_lines_3088="${ret_math_ceil634_v0}"
    if [ "$(( input_lines_3088 < 3 ))" != 0 ]; then
        go_down__700_v0 "$(( 2 - input_lines_3088 ))"
        remove_line__695_v0 2
        remove_current_line__696_v0 
    fi
    if [ "$(( input_lines_3088 >= 3 ))" != 0 ]; then
        remove_line__695_v0 "${input_lines_3088}"
    fi
    if [ "$([ "_${header_3012}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__695_v0 1
        remove_current_line__696_v0 
    fi
    stty_unlock__686_v0 
    ret_xyl_input937_v0="${text_3083}"
    return 0
}

# print_input_help()
print_input_help__1037_v0() {
    local usage_2930=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__704_v0 usage_2930[@]
    printf '%s\n' ""
    colored_primary__746_v0 "input"
    local ret_colored_primary746_v0__8_20="${ret_colored_primary746_v0}"
    local title_2967=("${ret_colored_primary746_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__704_v0 title_2967[@]
    printf '%s\n' ""
    colored_secondary__747_v0 "Flags:"
    local ret_colored_secondary747_v0__11_12="${ret_colored_secondary747_v0}"
    local array_167=()
    printf__128_v0 "${ret_colored_secondary747_v0__11_12}""
" array_167[@]
    local names_2969=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2970=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2971=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__879_v0 names_2969[@] texts_2970[@] notes_2971[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1095_v0() {
    local parameters_2924=("${!1}")
    local prompt_2925="> "
    local placeholder_2926="Type here..."
    local header_2927=""
    local password_2928=0
    for param_2929 in "${parameters_2924[@]}"; do
        if [ "$(( $([ "_${param_2929}" != "_-h" ]; echo $?) || $([ "_${param_2929}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1037_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2929}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_173="--prompt="
            slice__24_v0 "${param_2929}" "${#__length_173}" 0
            prompt_2925="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2929}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_174="--placeholder="
            slice__24_v0 "${param_2929}" "${#__length_174}" 0
            placeholder_2926="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2929}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_175="--header="
            slice__24_v0 "${param_2929}" "${#__length_175}" 0
            header_2927="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2929}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2928=1
        fi
    done
    has_ansi_escape__770_v0 "${header_2927}"
    local ret_has_ansi_escape770_v0__31_44="${ret_has_ansi_escape770_v0}"
    escape_ansi__771_v0 "${header_2927}"
    local ret_escape_ansi771_v0__31_73="${ret_escape_ansi771_v0}"
    colored_primary__746_v0 "${header_2927}"
    local ret_colored_primary746_v0__31_111="${ret_colored_primary746_v0}"
    local display_header_3009
    display_header_3009="$(if [ "$(( $([ "_${header_2927}" != "_" ]; echo $?) || ret_has_ansi_escape770_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi771_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary746_v0__31_111}"; fi)"
    xyl_input__937_v0 "${prompt_2925}" "${placeholder_2926}" "${display_header_3009}" "${password_2928}"
    ret_execute_input1095_v0="${ret_xyl_input937_v0}"
    return 0
}

# get_key()
get_key__1176_v0() {
    local command_176
    command_176="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16411="${command_176}"
    if [ "$([ "_${var_16411}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1176_v0="UP"
        return 0
    elif [ "$([ "_${var_16411}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1176_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16411}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1176_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16411}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1176_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16411}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1176_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16411}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1176_v0="INPUT"
        return 0
    else
        ret_get_key1176_v0="${var_16411}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1178_v0() {
    local format_16299="${1}"
    local args_16300=("${!2}")
    args_16300=("${format_16299}" "${args_16300[@]}")
    __status=$?
    printf "${args_16300[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1179_v0() {
    local message_16297="${1}"
    local color_16298="${2}"
    # Prints an error message with a specified color.
    local array_177=("${message_16297}")
    eprintf__1178_v0 "\\x1b[${color_16298}m%s\\x1b[0m" array_177[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1194_v0() {
    local format_16320="${1}"
    local args_16321=("${!2}")
    args_16321=("${format_16320}" "${args_16321[@]}")
    __status=$?
    printf "${args_16321[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_46="None"
# perl_available()
perl_available__1201_v0() {
    if [ "$([ "_${_perl_state_46}" != "_None" ]; echo $?)" != 0 ]; then
        local command_178
        command_178="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16252
        disabled_16252="$([ "_${command_178}" != "_No" ]; echo $?)"
        local command_179
        command_179="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16253
        found_16253="$(( $(( ! disabled_16252 )) && $([ "_${command_179}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_16253}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1201_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1202_v0() {
    local text_16251="${1}"
    perl_available__1201_v0 
    local ret_perl_available1201_v0__22_12="${ret_perl_available1201_v0}"
    if [ "$(( ! ret_perl_available1201_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1202_v0=''
        return 1
    fi
    local command_180
    command_180="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16251}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1202_v0=''
        return "${__status}"
    fi
    local width_str_16254="${command_180}"
    parse_int__13_v0 "${width_str_16254}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1202_v0=''
        return "${__status}"
    fi
    local width_16255="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1202_v0="${width_16255}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1207_v0() {
    local text_16244="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_181
    command_181="$([[ "${text_16244}" == *$'\x1b'* || "${text_16244}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16245="${command_181}"
    ret_has_ansi_escape1207_v0="$([ "_${has_escape_16245}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1209_v0() {
    local text_16247="${1}"
    local command_182
    command_182="$(printf "%s" "${text_16247}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1209_v0="${command_182}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1210_v0() {
    local text_16249="${1}"
    local command_183
    command_183="$(printf "%s" "${text_16249}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16250="${command_183}"
    ret_is_all_ascii1210_v0="$([ "_${result_16250}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1211_v0() {
    local text_16246="${1}"
    strip_ansi__1209_v0 "${text_16246}"
    local stripped_16248="${ret_strip_ansi1209_v0}"
    # Check if text is all ASCII
    is_all_ascii__1210_v0 "${stripped_16248}"
    local ret_is_all_ascii1210_v0__36_12="${ret_is_all_ascii1210_v0}"
    if [ "$(( ! ret_is_all_ascii1210_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1202_v0 "${stripped_16248}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_184="${stripped_16248}"
            ret_get_visible_len1211_v0="${#__length_184}"
            return 0
        fi
        ret_get_visible_len1211_v0="${ret_perl_get_cjk_width1202_v0}"
        return 0
    else
        local __length_185="${stripped_16248}"
        ret_get_visible_len1211_v0="${#__length_185}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_47=0
_term_size_48=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1217_v0() {
    local command_187
    command_187="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_16318="${command_187}"
    parse_int__13_v0 "${count_16318}"
    __status=$?
    ret_stty_count1217_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1218_v0() {
    stty_count__1217_v0 
    local count_num_16319="${ret_stty_count1217_v0}"
    if [ "$(( count_num_16319 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16319="$(( count_num_16319 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16319}
    __status=$?
}

# stty_unlock()
stty_unlock__1219_v0() {
    stty_count__1217_v0 
    local count_num_16437="${ret_stty_count1217_v0}"
    if [ "$(( count_num_16437 > 0 ))" != 0 ]; then
        count_num_16437="$(( count_num_16437 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16437}
        __status=$?
        if [ "$(( count_num_16437 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1220_v0() {
    local size_16235="${1}"
    if [ "$([ "_${size_16235}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1220_v0=0
        return 0
    fi
    split__4_v0 "${size_16235}" " "
    local parts_16236=("${ret_split4_v0[@]}")
    local __length_188=("${parts_16236[@]}")
    if [ "$(( ${#__length_188[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1220_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16236[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16236[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_48=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1220_v0=1
    return 0
}

# query_term_size()
query_term_size__1221_v0() {
    local command_190
    command_190="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16238="${command_190}"
    store_term_size__1220_v0 "${size_16238}"
    ret_query_term_size1221_v0="${ret_store_term_size1220_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1222_v0() {
    local command_191
    command_191="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16234="${command_191}"
    store_term_size__1220_v0 "${size_16234}"
    ret_stty_term_size1222_v0="${ret_store_term_size1220_v0}"
    return 0
}

# get_term_size()
get_term_size__1223_v0() {
    stty_term_size__1222_v0 
    local detected_16237="${ret_stty_term_size1222_v0}"
    if [ "$(( ! detected_16237 ))" != 0 ]; then
        query_term_size__1221_v0 
        detected_16237="${ret_query_term_size1221_v0}"
    fi
    _got_term_size_47=1
}

# term_width()
term_width__1225_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1223_v0 
    fi
    ret_term_width1225_v0="${_term_size_48[0]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1226_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1223_v0 
    fi
    ret_term_height1226_v0="${_term_size_48[1]?"Index out of bounds (at src/./choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1228_v0() {
    local cnt_16408="${1}"
    if [ "$(( cnt_16408 > 0 ))" != 0 ]; then
        local sequence_16409=""
        local __range_start_16410=0
        local __range_end_16410="${cnt_16408}"
        local __dir_16410=$(( ${__range_start_16410} <= ${__range_end_16410} ? 1 : -1 ))
        for (( ____16410=${__range_start_16410}; ____16410 * ${__dir_16410} < ${__range_end_16410} * ${__dir_16410}; ____16410+=${__dir_16410} )); do
            sequence_16409+="\\x1b[2K\\x1b[1A"
done
        local array_192=("")
        eprintf__1194_v0 "${sequence_16409}" array_192[@]
    fi
    local array_193=("")
    eprintf__1194_v0 "\\x1b[G" array_193[@]
}

# remove_current_line()
remove_current_line__1229_v0() {
    local array_194=("")
    eprintf__1194_v0 "\\x1b[2K\\x1b[G" array_194[@]
}

# print_blank(cnt: Int)
print_blank__1230_v0() {
    local cnt_16399="${1}"
    printf '%*s' "${cnt_16399}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1231_v0() {
    local cnt_16363="${1}"
    local __range_start_16364=0
    local __range_end_16364="${cnt_16363}"
    local __dir_16364=$(( ${__range_start_16364} <= ${__range_end_16364} ? 1 : -1 ))
    for (( ____16364=${__range_start_16364}; ____16364 * ${__dir_16364} < ${__range_end_16364} * ${__dir_16364}; ____16364+=${__dir_16364} )); do
        local array_195=("")
        eprintf__1194_v0 "
" array_195[@]
done
}

# go_up(cnt: Int)
go_up__1232_v0() {
    local cnt_16382="${1}"
    local array_196=("")
    eprintf__1194_v0 "\\x1b[${cnt_16382}A" array_196[@]
}

# go_down(cnt: Int)
go_down__1233_v0() {
    local cnt_16436="${1}"
    local array_197=("")
    eprintf__1194_v0 "\\x1b[${cnt_16436}B" array_197[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1235_v0() {
    local array_198=("")
    eprintf__1194_v0 "\\x1b[?25l" array_198[@]
}

# show_cursor()
show_cursor__1236_v0() {
    local array_199=("")
    eprintf__1194_v0 "\\x1b[?25h" array_199[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1237_v0() {
    local pieces_16233=("${!1}")
    term_width__1225_v0 
    local width_16239="${ret_term_width1225_v0}"
    local line_16240=""
    local line_len_16241=0
    for piece_16242 in "${pieces_16233[@]}"; do
        local __length_202="${piece_16242}"
        local piece_len_16243="${#__length_202}"
        has_ansi_escape__1207_v0 "${piece_16242}"
        local ret_has_ansi_escape1207_v0__186_12="${ret_has_ansi_escape1207_v0}"
        if [ "${ret_has_ansi_escape1207_v0__186_12}" != 0 ]; then
            get_visible_len__1211_v0 "${piece_16242}"
            piece_len_16243="${ret_get_visible_len1211_v0}"
        fi
        if [ "$([ "_${line_16240}" != "_" ]; echo $?)" != 0 ]; then
            line_16240="${piece_16242}"
            line_len_16241="${piece_len_16243}"
        elif [ "$(( $(( $(( line_len_16241 + 1 )) + piece_len_16243 )) > width_16239 ))" != 0 ]; then
            local array_203=()
            printf__128_v0 "${line_16240}""
" array_203[@]
            line_16240="${piece_16242}"
            line_len_16241="${piece_len_16243}"
        else
            line_16240+=" ""${piece_16242}"
            line_len_16241="$(( line_len_16241 + $(( 1 + piece_len_16243 )) ))"
        fi
    done
    if [ "$([ "_${line_16240}" == "_" ]; echo $?)" != 0 ]; then
        local array_204=()
        printf__128_v0 "${line_16240}""
" array_204[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_51="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_52=0
_primary_color_53=(3 207 159 92)
_secondary_color_54=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1274_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_16223="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_16223}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1274_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1275_v0() {
    local message_16218="${1}"
    local r_16219="${2}"
    local g_16220="${3}"
    local b_16221="${4}"
    local fallback_16222="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1275_v0="\\x1b[38;2;${r_16219};${g_16220};${b_16221}m""${message_16218}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1274_v0 
        local ret_get_supports_truecolor1274_v0__45_17="${ret_get_supports_truecolor1274_v0}"
        if [ "${ret_get_supports_truecolor1274_v0__45_17}" != 0 ]; then
            ret_colored_rgb1275_v0="\\x1b[38;2;${r_16219};${g_16220};${b_16221}m""${message_16218}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16222 == 0 ))" != 0 ]; then
            ret_colored_rgb1275_v0="${message_16218}"
            return 0
        else
            ret_colored_rgb1275_v0="\\x1b[${fallback_16222}m""${message_16218}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16222 == 0 ))" != 0 ]; then
            ret_colored_rgb1275_v0="${message_16218}"
            return 0
        fi
        ret_colored_rgb1275_v0="\\x1b[${fallback_16222}m""${message_16218}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1277_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16212="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16212}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16212}" ";"
            local parts_16213=("${ret_split4_v0[@]}")
            local __length_208=("${parts_16213[@]}")
            if [ "$(( ${#__length_208[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16213[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16213[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16213[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16213[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_53=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16214="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16214}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16214}" ";"
            local parts_16215=("${ret_split4_v0[@]}")
            local __length_210=("${parts_16215[@]}")
            if [ "$(( ${#__length_210[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16215[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16215[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16215[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16215[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_54=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16216="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16216}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16216}" ";"
            local parts_16217=("${ret_split4_v0[@]}")
            local __length_212=("${parts_16217[@]}")
            if [ "$(( ${#__length_212[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16217[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16217[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16217[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16217[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_52=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1278_v0() {
    inner_get_xylitol_colors__1277_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_52=1
}

# colored_primary(message: Text)
colored_primary__1279_v0() {
    local message_16211="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1278_v0 
    fi
    colored_rgb__1275_v0 "${message_16211}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1279_v0="${ret_colored_rgb1275_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1280_v0() {
    local message_16257="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1278_v0 
    fi
    colored_rgb__1275_v0 "${message_16257}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1280_v0="${ret_colored_rgb1275_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_56="None"
# perl_available()
perl_available__1297_v0() {
    if [ "$([ "_${_perl_state_56}" != "_None" ]; echo $?)" != 0 ]; then
        local command_214
        command_214="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16332
        disabled_16332="$([ "_${command_214}" != "_No" ]; echo $?)"
        local command_215
        command_215="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16333
        found_16333="$(( $(( ! disabled_16332 )) && $([ "_${command_215}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_16333}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1297_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1298_v0() {
    local text_16331="${1}"
    perl_available__1297_v0 
    local ret_perl_available1297_v0__22_12="${ret_perl_available1297_v0}"
    if [ "$(( ! ret_perl_available1297_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1298_v0=''
        return 1
    fi
    local command_216
    command_216="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16331}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1298_v0=''
        return "${__status}"
    fi
    local width_str_16334="${command_216}"
    parse_int__13_v0 "${width_str_16334}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1298_v0=''
        return "${__status}"
    fi
    local width_16335="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1298_v0="${width_16335}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1299_v0() {
    local text_16342="${1}"
    local max_width_16343="${2}"
    perl_available__1297_v0 
    local ret_perl_available1297_v0__33_12="${ret_perl_available1297_v0}"
    if [ "$(( ! ret_perl_available1297_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1299_v0=''
        return 1
    fi
    local command_217
    command_217="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16342}" ${max_width_16343} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1299_v0=''
        return "${__status}"
    fi
    local result_16344="${command_217}"
    ret_perl_truncate_cjk1299_v0="${result_16344}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1303_v0() {
    local text_16302="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_218
    command_218="$([[ "${text_16302}" == *$'\x1b'* || "${text_16302}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16303="${command_218}"
    ret_has_ansi_escape1303_v0="$([ "_${has_escape_16303}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1304_v0() {
    local text_16304="${1}"
    local command_219
    command_219="$(printf '%s' "${text_16304}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1304_v0="${command_219}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1305_v0() {
    local text_16327="${1}"
    local command_220
    command_220="$(printf "%s" "${text_16327}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1305_v0="${command_220}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1306_v0() {
    local text_16329="${1}"
    local command_221
    command_221="$(printf "%s" "${text_16329}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16330="${command_221}"
    ret_is_all_ascii1306_v0="$([ "_${result_16330}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1307_v0() {
    local text_16326="${1}"
    strip_ansi__1305_v0 "${text_16326}"
    local stripped_16328="${ret_strip_ansi1305_v0}"
    # Check if text is all ASCII
    is_all_ascii__1306_v0 "${stripped_16328}"
    local ret_is_all_ascii1306_v0__36_12="${ret_is_all_ascii1306_v0}"
    if [ "$(( ! ret_is_all_ascii1306_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1298_v0 "${stripped_16328}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_222="${stripped_16328}"
            ret_get_visible_len1307_v0="${#__length_222}"
            return 0
        fi
        ret_get_visible_len1307_v0="${ret_perl_get_cjk_width1298_v0}"
        return 0
    else
        local __length_223="${stripped_16328}"
        ret_get_visible_len1307_v0="${#__length_223}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1308_v0() {
    local text_16339="${1}"
    local max_width_16340="${2}"
    get_visible_len__1307_v0 "${text_16339}"
    local visible_len_16341="${ret_get_visible_len1307_v0}"
    if [ "$(( visible_len_16341 <= max_width_16340 ))" != 0 ]; then
        ret_truncate_text1308_v0="${text_16339}"
        return 0
    fi
    is_all_ascii__1306_v0 "${text_16339}"
    local ret_is_all_ascii1306_v0__53_12="${ret_is_all_ascii1306_v0}"
    if [ "$(( ! ret_is_all_ascii1306_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1299_v0 "${text_16339}" "${max_width_16340}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16339}" | cut -c1-${max_width_16340}
            __status=$?
        fi
        ret_truncate_text1308_v0="${ret_perl_truncate_cjk1299_v0}"
        return 0
    fi
    local command_224
    command_224="$(printf "%s" "${text_16339}" | cut -c1-${max_width_16340})"
    __status=$?
    ret_truncate_text1308_v0="${command_224}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1309_v0() {
    local text_16337="${1}"
    local max_width_16338="${2}"
    has_ansi_escape__1303_v0 "${text_16337}"
    local ret_has_ansi_escape1303_v0__65_12="${ret_has_ansi_escape1303_v0}"
    if [ "$(( ! ret_has_ansi_escape1303_v0__65_12 ))" != 0 ]; then
        truncate_text__1308_v0 "${text_16337}" "${max_width_16338}"
        ret_truncate_ansi1309_v0="${ret_truncate_text1308_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_225
    command_225="$([[ "${text_16337}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16345="${command_225}"
    # Replace \x1b[ with newline, then split
    local command_226
    command_226="$(t="${text_16337}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16346="${command_226}"
    split__4_v0 "${replaced_16346}" "
"
    local parts_16347=("${ret_split4_v0[@]}")
    local result_16348=""
    local remaining_width_16349="${max_width_16338}"
    local __range_start_16350=0
    local __length_227=("${parts_16347[@]}")
    local __range_end_16350="${#__length_227[@]}"
    local __dir_16350=$(( ${__range_start_16350} <= ${__range_end_16350} ? 1 : -1 ))
    for (( idx_16350=${__range_start_16350}; idx_16350 * ${__dir_16350} < ${__range_end_16350} * ${__dir_16350}; idx_16350+=${__dir_16350} )); do
        local part_16351="${parts_16347[${idx_16350}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16350 == 0 )) && $([ "_${starts_with_ansi_16345}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16351}" == "_" ]; echo $?) && $(( remaining_width_16349 > 0 )) ))" != 0 ]; then
                truncate_text__1308_v0 "${part_16351}" "${remaining_width_16349}"
                local ret_truncate_text1308_v0__87_35="${ret_truncate_text1308_v0}"
                local truncated_16352="${ret_truncate_text1308_v0__87_35}"
                result_16348+="${truncated_16352}"
                get_visible_len__1307_v0 "${truncated_16352}"
                local ret_get_visible_len1307_v0__89_36="${ret_get_visible_len1307_v0}"
                remaining_width_16349="$(( remaining_width_16349 - ret_get_visible_len1307_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_228
            command_228="$(__p="${part_16351}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16353="${command_228}"
            if [ "$([ "_${m_idx_16353}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_229
                command_229="$(__p="${part_16351}"; printf "%s" "${__p:0:${m_idx_16353}}")"
                __status=$?
                local ansi_params_16354="${command_229}"
                result_16348+="\\x1b[""${ansi_params_16354}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16353}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_16355="${ret_parse_int13_v0__100_41}"
                local text_start_16356="$(( m_idx_num_16355 + 1 ))"
                local command_230
                command_230="$(__p="${part_16351}"; printf "%s" "${__p:${text_start_16356}}")"
                __status=$?
                local text_part_16357="${command_230}"
                if [ "$(( $([ "_${text_part_16357}" == "_" ]; echo $?) && $(( remaining_width_16349 > 0 )) ))" != 0 ]; then
                    truncate_text__1308_v0 "${text_part_16357}" "${remaining_width_16349}"
                    local ret_truncate_text1308_v0__104_39="${ret_truncate_text1308_v0}"
                    local truncated_16358="${ret_truncate_text1308_v0__104_39}"
                    result_16348+="${truncated_16358}"
                    get_visible_len__1307_v0 "${truncated_16358}"
                    local ret_get_visible_len1307_v0__106_40="${ret_get_visible_len1307_v0}"
                    remaining_width_16349="$(( remaining_width_16349 - ret_get_visible_len1307_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16351}" == "_" ]; echo $?) && $(( remaining_width_16349 > 0 )) ))" != 0 ]; then
                    truncate_text__1308_v0 "${part_16351}" "${remaining_width_16349}"
                    local ret_truncate_text1308_v0__111_39="${ret_truncate_text1308_v0}"
                    local truncated_16359="${ret_truncate_text1308_v0__111_39}"
                    result_16348+="${truncated_16359}"
                    get_visible_len__1307_v0 "${truncated_16359}"
                    local ret_get_visible_len1307_v0__113_40="${ret_get_visible_len1307_v0}"
                    remaining_width_16349="$(( remaining_width_16349 - ret_get_visible_len1307_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1309_v0="${result_16348}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1310_v0() {
    local text_16324="${1}"
    local max_width_16325="${2}"
    get_visible_len__1307_v0 "${text_16324}"
    local visible_len_16336="${ret_get_visible_len1307_v0}"
    if [ "$(( visible_len_16336 <= max_width_16325 ))" != 0 ]; then
        ret_cutoff_text1310_v0="${text_16324}"
        return 0
    fi
    truncate_ansi__1309_v0 "${text_16324}" "$(( max_width_16325 - 3 ))"
    local ret_truncate_ansi1309_v0__129_12="${ret_truncate_ansi1309_v0}"
    ret_cutoff_text1310_v0="${ret_truncate_ansi1309_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__1331_v0() {
    local format_16373="${1}"
    local args_16374=("${!2}")
    args_16374=("${format_16373}" "${args_16374[@]}")
    __status=$?
    printf "${args_16374[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1332_v0() {
    local message_16371="${1}"
    local color_16372="${2}"
    # Prints an error message with a specified color.
    local array_231=("${message_16371}")
    eprintf__1331_v0 "\\x1b[${color_16372}m%s\\x1b[0m" array_231[@]
}

# colored(message: Text, color: Int)
colored__1333_v0() {
    local message_16291="${1}"
    local color_16292="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1333_v0="\\x1b[${color_16292}m""${message_16291}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1337_v0() {
    local items_16365=("${!1}")
    local total_len_16366="${2}"
    local term_width_16367="${3}"
    local separator_16368=" • "
    local separator_len_16369=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16366 <= term_width_16367 ))" != 0 ]; then
        local iter_16370=0
        while :
        do
            local __length_232=("${items_16365[@]}")
            if [ "$(( iter_16370 >= ${#__length_232[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16370 > 0 ))" != 0 ]; then
                eprintf_colored__1332_v0 "${separator_16368}" 90
            fi
            colored__1333_v0 "${items_16365[$(( iter_16370 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1333_v0__23_41="${ret_colored1333_v0}"
            local array_233=("")
            eprintf__1331_v0 "${items_16365[${iter_16370}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1333_v0__23_41}" array_233[@]
            iter_16370="$(( iter_16370 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16375=0
        local first_16376=1
        local iter_16377=0
        while :
        do
            local __length_234=("${items_16365[@]}")
            if [ "$(( iter_16377 >= ${#__length_234[@]} ))" != 0 ]; then
                break
            fi
            local key_16378="${items_16365[${iter_16377}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_16379="${items_16365[$(( iter_16377 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_235="${key_16378}"
            local __length_236="${action_16379}"
            local part_len_16380="$(( $(( ${#__length_235} + 1 )) + ${#__length_236} ))"
            local needed_16381="${part_len_16380}"
            if [ "$(( ! first_16376 ))" != 0 ]; then
                needed_16381="$(( needed_16381 + separator_len_16369 ))"
            fi
            if [ "$(( $(( current_len_16375 + needed_16381 )) > term_width_16367 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16376 ))" != 0 ]; then
                eprintf_colored__1332_v0 "${separator_16368}" 90
            fi
            colored__1333_v0 "${action_16379}" 2
            local ret_colored1333_v0__51_33="${ret_colored1333_v0}"
            local array_237=("")
            eprintf__1331_v0 "${key_16378}"" ""${ret_colored1333_v0__51_33}" array_237[@]
            current_len_16375="$(( current_len_16375 + needed_16381 ))"
            first_16376=0
            iter_16377="$(( iter_16377 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1347_v0() {
    local format_16425="${1}"
    local args_16426=("${!2}")
    args_16426=("${format_16425}" "${args_16426[@]}")
    __status=$?
    printf "${args_16426[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_59=0
_term_size_60=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__1373_v0() {
    local size_16270="${1}"
    if [ "$([ "_${size_16270}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1373_v0=0
        return 0
    fi
    split__4_v0 "${size_16270}" " "
    local parts_16271=("${ret_split4_v0[@]}")
    local __length_239=("${parts_16271[@]}")
    if [ "$(( ${#__length_239[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1373_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16271[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16271[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_60=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1373_v0=1
    return 0
}

# query_term_size()
query_term_size__1374_v0() {
    local command_241
    command_241="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16273="${command_241}"
    store_term_size__1373_v0 "${size_16273}"
    ret_query_term_size1374_v0="${ret_store_term_size1373_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1375_v0() {
    local command_242
    command_242="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16269="${command_242}"
    store_term_size__1373_v0 "${size_16269}"
    ret_stty_term_size1375_v0="${ret_store_term_size1373_v0}"
    return 0
}

# get_term_size()
get_term_size__1376_v0() {
    stty_term_size__1375_v0 
    local detected_16272="${ret_stty_term_size1375_v0}"
    if [ "$(( ! detected_16272 ))" != 0 ]; then
        query_term_size__1374_v0 
        detected_16272="${ret_query_term_size1374_v0}"
    fi
    _got_term_size_59=1
}

# term_width()
term_width__1378_v0() {
    if [ "$(( ! _got_term_size_59 ))" != 0 ]; then
        get_term_size__1376_v0 
    fi
    ret_term_width1378_v0="${_term_size_60[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__1385_v0() {
    local cnt_16424="${1}"
    local array_243=("")
    eprintf__1347_v0 "\\x1b[${cnt_16424}A" array_243[@]
}

# go_down(cnt: Int)
go_down__1386_v0() {
    local cnt_16427="${1}"
    local array_244=("")
    eprintf__1347_v0 "\\x1b[${cnt_16427}B" array_244[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1393_v0() {
    local display_count_16421="${1}"
    local index_16422="${2}"
    local line_16423="${3}"
    go_up__1385_v0 "$(( display_count_16421 - index_16422 ))"
    local array_245=("")
    eprintf__1331_v0 "\\x1b[G\\x1b[K" array_245[@]
    local array_246=("")
    eprintf__1331_v0 "${line_16423}" array_246[@]
    go_down__1386_v0 "$(( display_count_16421 - index_16422 ))"
    local array_247=("")
    eprintf__1331_v0 "\\x1b[G" array_247[@]
}

# Which items of a multi-select widget are ticked.
# 
# The state sits at module level, so only one such widget may be open at a
# time. Reach it through `utils.ab` rather than importing this file directly:
# the compiler keys modules by the literal text of the import path, so a
# second spelling would hand that caller its own copy of these variables.
_checked_61=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list.
_count_62=0
_total_63=0
_limit_64=-1
# checked_init(total: Int, limit: Int)
checked_init__1395_v0() {
    local total_16360="${1}"
    local limit_16361="${2}"
    _checked_61=()
    local __range_start_16362=0
    local __range_end_16362="${total_16360}"
    local __dir_16362=$(( ${__range_start_16362} <= ${__range_end_16362} ? 1 : -1 ))
    for (( ____16362=${__range_start_16362}; ____16362 * ${__dir_16362} < ${__range_end_16362} * ${__dir_16362}; ____16362+=${__dir_16362} )); do
        local array_250=(0)
        _checked_61+=("${array_250[@]}")
done
    _count_62=0
    _total_63="${total_16360}"
    _limit_64="${limit_16361}"
}

# checked_is(index: Int)
checked_is__1396_v0() {
    local index_16396="${1}"
    ret_checked_is1396_v0="${_checked_61[${index_16396}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:26:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1398_v0() {
    local index_16416="${1}"
    if [ "${_checked_61[${index_16416}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:36:17)"}" != 0 ]; then
        _checked_61["${index_16416}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1398_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1398_v0=0
        return 0
    fi
    _checked_61["${index_16416}"]=1
    _count_62="$(( _count_62 + 1 ))"
    ret_checked_toggle1398_v0=1
    return 0
}

# checked_all()
checked_all__1399_v0() {
    if [ "$(( _limit_64 >= 0 ))" != 0 ]; then
        ret_checked_all1399_v0=0
        return 0
    fi
    local was_all_16428="$(( _count_62 == _total_63 ))"
    local __range_start_16429=0
    local __range_end_16429="${_total_63}"
    local __dir_16429=$(( ${__range_start_16429} <= ${__range_end_16429} ? 1 : -1 ))
    for (( i_16429=${__range_start_16429}; i_16429 * ${__dir_16429} < ${__range_end_16429} * ${__dir_16429}; i_16429+=${__dir_16429} )); do
        _checked_61["${i_16429}"]="$(( ! was_all_16428 ))"
done
    if [ "${was_all_16428}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1399_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1411_v0() {
    local pending_16288="${1}"
    local line_16289="${2}"
    local note_at_16290="${3}"
    if [ "$(( note_at_16290 < 0 ))" != 0 ]; then
        local array_251=()
        printf__128_v0 "${pending_16288}""${line_16289}""
" array_251[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16290 == 0 ))" != 0 ]; then
        colored__1333_v0 "${line_16289}" 90
        local ret_colored1333_v0__12_40="${ret_colored1333_v0}"
        local array_252=()
        printf__128_v0 "${pending_16288}""${ret_colored1333_v0__12_40}""
" array_252[@]
    else
        slice__24_v0 "${line_16289}" 0 "${note_at_16290}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16289}" "${note_at_16290}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1333_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1333_v0__13_58="${ret_colored1333_v0}"
        local array_253=()
        printf__128_v0 "${pending_16288}""${ret_slice24_v0__13_32}""${ret_colored1333_v0__13_58}""
" array_253[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1412_v0() {
    local names_16261=("${!1}")
    local texts_16262=("${!2}")
    local notes_16263=("${!3}")
    local min_name_width_16264="${4}"
    local __length_254=("${names_16261[@]}")
    local count_16265="${#__length_254[@]}"
    local name_width_16266="${min_name_width_16264}"
    local __range_start_16267=0
    local __range_end_16267="${count_16265}"
    local __dir_16267=$(( ${__range_start_16267} <= ${__range_end_16267} ? 1 : -1 ))
    for (( i_16267=${__range_start_16267}; i_16267 * ${__dir_16267} < ${__range_end_16267} * ${__dir_16267}; i_16267+=${__dir_16267} )); do
        local __length_255="${names_16261[${i_16267}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_16268="${#__length_255}"
        if [ "$(( width_16268 > name_width_16266 ))" != 0 ]; then
            name_width_16266="${width_16268}"
        fi
done
    term_width__1378_v0 
    local width_16274="${ret_term_width1378_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16275="$(( name_width_16266 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16276="$(( $(( width_16274 - indent_16275 )) < 24 ))"
    if [ "${stacked_16276}" != 0 ]; then
        indent_16275=6
    fi
    local avail_16277="$(( width_16274 - indent_16275 ))"
    rpad__28_v0 "" " " "${indent_16275}"
    local blank_16278="${ret_rpad28_v0}"
    local __range_start_16279=0
    local __range_end_16279="${count_16265}"
    local __dir_16279=$(( ${__range_start_16279} <= ${__range_end_16279} ? 1 : -1 ))
    for (( i_16279=${__range_start_16279}; i_16279 * ${__dir_16279} < ${__range_end_16279} * ${__dir_16279}; i_16279+=${__dir_16279} )); do
        local pending_16280="${blank_16278}"
        if [ "${stacked_16276}" != 0 ]; then
            local array_256=()
            printf__128_v0 "  ""${names_16261[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_256[@]
        else
            rpad__28_v0 "  ""${names_16261[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_16275}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_16280="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_16262[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_16281=("${ret_split4_v0__52_21[@]}")
        local __length_257=("${words_16281[@]}")
        local note_start_16282="${#__length_257[@]}"
        if [ "$([ "_${notes_16263[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_258="${notes_16263[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_258} > avail_16277 ))" != 0 ]; then
                split__4_v0 "${notes_16263[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_16281+=("${ret_split4_v0__58_26[@]}")
            else
                local array_259=("${notes_16263[${i_16279}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_16281+=("${array_259[@]}")
            fi
        fi
        local line_16283=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16284=-1
        local __range_start_16285=0
        local __length_260=("${words_16281[@]}")
        local __range_end_16285="${#__length_260[@]}"
        local __dir_16285=$(( ${__range_start_16285} <= ${__range_end_16285} ? 1 : -1 ))
        for (( j_16285=${__range_start_16285}; j_16285 * ${__dir_16285} < ${__range_end_16285} * ${__dir_16285}; j_16285+=${__dir_16285} )); do
            local word_16286="${words_16281[${j_16285}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_16287
            candidate_16287="$(if [ "$([ "_${line_16283}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16286}"; else echo "${line_16283}"" ""${word_16286}"; fi)"
            local __length_261="${candidate_16287}"
            if [ "$(( $(( ${#__length_261} > avail_16277 )) && $([ "_${line_16283}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1411_v0 "${pending_16280}" "${line_16283}" "${note_at_16284}"
                pending_16280="${blank_16278}"
                line_16283="${word_16286}"
                note_at_16284="$(if [ "$(( j_16285 >= note_start_16282 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16285 >= note_start_16282 )) && $(( note_at_16284 < 0 )) ))" != 0 ]; then
                    local __length_262="${candidate_16287}"
                    local __length_263="${word_16286}"
                    note_at_16284="$(( ${#__length_262} - ${#__length_263} ))"
                fi
                line_16283="${candidate_16287}"
            fi
done
        print_help_line__1411_v0 "${pending_16280}" "${line_16283}" "${note_at_16284}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# A chooser driven by its caller.
# 
# Amber has no callbacks, so the engine cannot ask for an item's text on its
# own. The caller runs the loop instead and hands over one page of labels at
# a time, which is what lets it build them lazily. `xyl_choose` and
# `xyl_file` show the shape of that loop.
# 
# Only the engine writes to the terminal; callers just produce text.
# `chooser_step` handled the key and redrew whatever changed.
__CHOOSER_CONTINUE_67=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_68=1
# The user confirmed the selection.
__CHOOSER_DONE_69=2
_total_70=0
_page_size_71=10
_display_count_72=0
_total_pages_73=1
_current_page_74=0
_selected_75=0
_cursor_76="> "
_multi_77=0
_limit_78=-1
_term_width_79=80
_has_header_80=0
_page_81=()
_page_count_82=0
_first_render_83=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_84=0
# render_single_page()
render_single_page__1574_v0() {
    local __length_265="${_cursor_76}"
    local cursor_len_16402="${#__length_265}"
    local max_option_width_16403="$(( $(( _term_width_79 - cursor_len_16402 )) - 1 ))"
    local __range_start_16404=0
    local __range_end_16404="${_page_count_82}"
    local __dir_16404=$(( ${__range_start_16404} <= ${__range_end_16404} ? 1 : -1 ))
    for (( i_16404=${__range_start_16404}; i_16404 * ${__dir_16404} < ${__range_end_16404} * ${__dir_16404}; i_16404+=${__dir_16404} )); do
        cutoff_text__1310_v0 "${_page_81[${i_16404}]?"Index out of bounds (at src/./choose/./engine.ab:45:45)"}" "${max_option_width_16403}"
        local ret_cutoff_text1310_v0__45_27="${ret_cutoff_text1310_v0}"
        local truncated_16405="${ret_cutoff_text1310_v0__45_27}"
        if [ "$(( i_16404 == _selected_75 ))" != 0 ]; then
            colored_secondary__1280_v0 "${_cursor_76}""${truncated_16405}""
"
            local ret_colored_secondary1280_v0__47_21="${ret_colored_secondary1280_v0}"
            local array_266=("")
            eprintf__1178_v0 "${ret_colored_secondary1280_v0__47_21}" array_266[@]
        else
            print_blank__1230_v0 "${cursor_len_16402}"
            local array_267=("")
            eprintf__1178_v0 "${truncated_16405}""
" array_267[@]
        fi
done
    local remaining_slots_16406="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_16406 > 0 ))" != 0 ]; then
        local __range_start_16407=0
        local __range_end_16407="${remaining_slots_16406}"
        local __dir_16407=$(( ${__range_start_16407} <= ${__range_end_16407} ? 1 : -1 ))
        for (( ____16407=${__range_start_16407}; ____16407 * ${__dir_16407} < ${__range_end_16407} * ${__dir_16407}; ____16407+=${__dir_16407} )); do
            local array_268=("")
            eprintf__1178_v0 "\\x1b[K
" array_268[@]
done
    fi
}

# render_multi_page()
render_multi_page__1575_v0() {
    local __length_269="${_cursor_76}"
    local cursor_len_16391="${#__length_269}"
    local max_option_width_16392="$(( $(( _term_width_79 - cursor_len_16391 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1580_v0 
    local page_start_16393="${ret_chooser_page_start1580_v0}"
    local __range_start_16394=0
    local __range_end_16394="${_page_count_82}"
    local __dir_16394=$(( ${__range_start_16394} <= ${__range_end_16394} ? 1 : -1 ))
    for (( i_16394=${__range_start_16394}; i_16394 * ${__dir_16394} < ${__range_end_16394} * ${__dir_16394}; i_16394+=${__dir_16394} )); do
        local global_idx_16395="$(( page_start_16393 + i_16394 ))"
        checked_is__1396_v0 "${global_idx_16395}"
        local ret_checked_is1396_v0__67_28="${ret_checked_is1396_v0}"
        local check_mark_16397
        check_mark_16397="$(if [ "${ret_checked_is1396_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1310_v0 "${_page_81[${i_16394}]?"Index out of bounds (at src/./choose/./engine.ab:68:45)"}" "${max_option_width_16392}"
        local ret_cutoff_text1310_v0__68_27="${ret_cutoff_text1310_v0}"
        local truncated_16398="${ret_cutoff_text1310_v0__68_27}"
        checked_is__1396_v0 "${global_idx_16395}"
        local ret_checked_is1396_v0__71_13="${ret_checked_is1396_v0}"
        if [ "$(( i_16394 == _selected_75 ))" != 0 ]; then
            colored_secondary__1280_v0 "${_cursor_76}""${check_mark_16397}""${truncated_16398}""
"
            local ret_colored_secondary1280_v0__70_37="${ret_colored_secondary1280_v0}"
            local array_270=("")
            eprintf__1178_v0 "${ret_colored_secondary1280_v0__70_37}" array_270[@]
        elif [ "${ret_checked_is1396_v0__71_13}" != 0 ]; then
            print_blank__1230_v0 "${cursor_len_16391}"
            colored_secondary__1280_v0 "${check_mark_16397}""${truncated_16398}""
"
            local ret_colored_secondary1280_v0__73_25="${ret_colored_secondary1280_v0}"
            local array_271=("")
            eprintf__1178_v0 "${ret_colored_secondary1280_v0__73_25}" array_271[@]
        else
            print_blank__1230_v0 "${cursor_len_16391}"
            local array_272=("")
            eprintf__1178_v0 "${check_mark_16397}""${truncated_16398}""
" array_272[@]
        fi
done
    local remaining_slots_16400="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_16400 > 0 ))" != 0 ]; then
        local __range_start_16401=0
        local __range_end_16401="${remaining_slots_16400}"
        local __dir_16401=$(( ${__range_start_16401} <= ${__range_end_16401} ? 1 : -1 ))
        for (( ____16401=${__range_start_16401}; ____16401 * ${__dir_16401} < ${__range_end_16401} * ${__dir_16401}; ____16401+=${__dir_16401} )); do
            local array_273=("")
            eprintf__1178_v0 "\\x1b[K
" array_273[@]
done
    fi
}

# render_page()
render_page__1576_v0() {
    if [ "${_multi_77}" != 0 ]; then
        render_multi_page__1575_v0 
    else
        render_single_page__1574_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1577_v0() {
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        local array_274=("")
        eprintf__1178_v0 "\\x1b[G\\x1b[K" array_274[@]
        eprintf_colored__1179_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
        local array_275=("")
        eprintf__1178_v0 "\\x1b[G" array_275[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1578_v0() {
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_276=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1337_v0 array_276[@] 36 "${_term_width_79}"
        else
            local array_277=("↑↓" "select" "enter" "confirm")
            render_tooltip__1337_v0 array_277[@] 25 "${_term_width_79}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_73 > 1 )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
            local array_278=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1337_v0 array_278[@] 55 "${_term_width_79}"
        elif [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_279=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1337_v0 array_279[@] 47 "${_term_width_79}"
        elif [ "$(( _limit_78 < 0 ))" != 0 ]; then
            local array_280=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1337_v0 array_280[@] 44 "${_term_width_79}"
        else
            local array_281=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1337_v0 array_281[@] 36 "${_term_width_79}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1579_v0() {
    local total_16312="${1}"
    local page_size_16313="${2}"
    local header_16314="${3}"
    local cursor_16315="${4}"
    local multi_16316="${5}"
    local limit_16317="${6}"
    _total_70="${total_16312}"
    _cursor_76="${cursor_16315}"
    _multi_77="${multi_16316}"
    _limit_78="${limit_16317}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_16314}" == "_" ]; echo $?)"
    stty_lock__1218_v0 
    hide_cursor__1235_v0 
    term_width__1225_v0 
    _term_width_79="${ret_term_width1225_v0}"
    term_height__1226_v0 
    local term_height_16322="${ret_term_height1226_v0}"
    local max_page_size_16323
    max_page_size_16323="$(( term_height_16322 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_16313}"
    if [ "$(( _page_size_71 > max_page_size_16323 ))" != 0 ]; then
        _page_size_71="${max_page_size_16323}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1310_v0 "${header_16314}" "${_term_width_79}"
        local ret_cutoff_text1310_v0__153_17="${ret_cutoff_text1310_v0}"
        local array_282=("")
        eprintf__1178_v0 "${ret_cutoff_text1310_v0__153_17}""
" array_282[@]
    fi
    math_floor__633_v0 "$(( $(( $(( total_16312 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _total_pages_73="${ret_math_floor633_v0}"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_16312 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_16312}"
    fi
    if [ "${multi_16316}" != 0 ]; then
        checked_init__1395_v0 "${total_16312}" "${limit_16317}"
    fi
    new_line__1231_v0 "${_display_count_72}"
    local array_283=("")
    eprintf__1178_v0 "\\x1b[G" array_283[@]
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        eprintf_colored__1179_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
    fi
    new_line__1231_v0 1
    render_tooltip_line__1578_v0 
    go_up__1232_v0 "$(( _display_count_72 + 1 ))"
    local array_284=("")
    eprintf__1178_v0 "\\x1b[G" array_284[@]
}

# chooser_page_start()
chooser_page_start__1580_v0() {
    ret_chooser_page_start1580_v0="$(( _current_page_74 * _page_size_71 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1581_v0() {
    chooser_page_start__1580_v0 
    local start_16386="${ret_chooser_page_start1580_v0}"
    local end_16387="$(( start_16386 + _page_size_71 ))"
    if [ "$(( end_16387 > _total_70 ))" != 0 ]; then
        end_16387="${_total_70}"
    fi
    ret_chooser_page_count1581_v0="$(( end_16387 - start_16386 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1582_v0() {
    local page_16390=("${!1}")
    _page_81=("${page_16390[@]}")
    local __length_285=("${page_16390[@]}")
    _page_count_82="${#__length_285[@]}"
    if [ "${_first_render_83}" != 0 ]; then
        _first_render_83=0
        render_page__1576_v0 
    else
        if [ "${_up_paged_84}" != 0 ]; then
            _selected_75="$(( _page_count_82 - 1 ))"
            _up_paged_84=0
        fi
        go_up__1232_v0 1
        remove_line__1228_v0 "$(( _display_count_72 - 1 ))"
        remove_current_line__1229_v0 
        local array_286=("")
        eprintf__1178_v0 "\\x1b[G" array_286[@]
        render_page__1576_v0 
        render_page_indicator__1577_v0 
    fi
}

# option_width()
option_width__1583_v0() {
    local check_width_16418
    check_width_16418="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_287="${_cursor_76}"
    ret_option_width1583_v0="$(( $(( _term_width_79 - ${#__length_287} )) - check_width_16418 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1584_v0() {
    local index_16431="${1}"
    local __length_288="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_288}"
    local blank_16432="${ret_rpad28_v0}"
    option_width__1583_v0 
    local ret_option_width1583_v0__224_49="${ret_option_width1583_v0}"
    cutoff_text__1310_v0 "${_page_81[${index_16431}]?"Index out of bounds (at src/./choose/./engine.ab:224:41)"}" "${ret_option_width1583_v0__224_49}"
    local truncated_16433="${ret_cutoff_text1310_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1584_v0="${blank_16432}""${truncated_16433}"
        return 0
    fi
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__228_19="${ret_chooser_page_start1580_v0}"
    checked_is__1396_v0 "$(( ret_chooser_page_start1580_v0__228_19 + index_16431 ))"
    local ret_checked_is1396_v0__228_8="${ret_checked_is1396_v0}"
    if [ "${ret_checked_is1396_v0__228_8}" != 0 ]; then
        colored_secondary__1280_v0 "✓ ""${truncated_16433}"
        local ret_colored_secondary1280_v0__229_24="${ret_colored_secondary1280_v0}"
        ret_unselected_line1584_v0="${blank_16432}""${ret_colored_secondary1280_v0__229_24}"
        return 0
    fi
    ret_unselected_line1584_v0="${blank_16432}""• ""${truncated_16433}"
    return 0
}

# selected_line(index: Int)
selected_line__1585_v0() {
    local index_16417="${1}"
    option_width__1583_v0 
    local ret_option_width1583_v0__236_49="${ret_option_width1583_v0}"
    cutoff_text__1310_v0 "${_page_81[${index_16417}]?"Index out of bounds (at src/./choose/./engine.ab:236:41)"}" "${ret_option_width1583_v0__236_49}"
    local truncated_16419="${ret_cutoff_text1310_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1280_v0 "${_cursor_76}""${truncated_16419}"
        ret_selected_line1585_v0="${ret_colored_secondary1280_v0}"
        return 0
    fi
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__240_29="${ret_chooser_page_start1580_v0}"
    checked_is__1396_v0 "$(( ret_chooser_page_start1580_v0__240_29 + index_16417 ))"
    local ret_checked_is1396_v0__240_18="${ret_checked_is1396_v0}"
    local mark_16420
    mark_16420="$(if [ "${ret_checked_is1396_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1280_v0 "${_cursor_76}""${mark_16420}""${truncated_16419}"
    ret_selected_line1585_v0="${ret_colored_secondary1280_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1586_v0() {
    local prev_selected_16430="${1}"
    unselected_line__1584_v0 "${prev_selected_16430}"
    local ret_unselected_line1584_v0__247_47="${ret_unselected_line1584_v0}"
    redraw_row__1393_v0 "${_display_count_72}" "${prev_selected_16430}" "${ret_unselected_line1584_v0__247_47}"
    selected_line__1585_v0 "${_selected_75}"
    local ret_selected_line1585_v0__248_43="${ret_selected_line1585_v0}"
    redraw_row__1393_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1585_v0__248_43}"
}

# redraw_current_line()
redraw_current_line__1587_v0() {
    selected_line__1585_v0 "${_selected_75}"
    local ret_selected_line1585_v0__253_43="${ret_selected_line1585_v0}"
    redraw_row__1393_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1585_v0__253_43}"
}

# chooser_step()
chooser_step__1588_v0() {
    get_key__1176_v0 
    local key_16412="${ret_get_key1176_v0}"
    local prev_selected_16413="${_selected_75}"
    local prev_page_16414="${_current_page_74}"
    chooser_page_start__1580_v0 
    local page_start_16415="${ret_chooser_page_start1580_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_16412}" != "_UP" ]; echo $?) || $([ "_${key_16412}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_75 == 0 )) && $(( _total_pages_73 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
                _current_page_74="$(( _current_page_74 - 1 ))"
            else
                _current_page_74="$(( _total_pages_73 - 1 ))"
            fi
            _up_paged_84=1
        elif [ "$(( _selected_75 == 0 ))" != 0 ]; then
            _selected_75="$(( _page_count_82 - 1 ))"
        else
            _selected_75="$(( _selected_75 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_16412}" != "_DOWN" ]; echo $?) || $([ "_${key_16412}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_75 == $(( _page_count_82 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
                _current_page_74="$(( _current_page_74 + 1 ))"
            else
                _current_page_74=0
            fi
            _selected_75=0
        else
            _selected_75="$(( _selected_75 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_16412}" != "_LEFT" ]; echo $?) || $([ "_${key_16412}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_16412}" != "_RIGHT" ]; echo $?) || $([ "_${key_16412}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $([ "_${key_16412}" != "_x" ]; echo $?) || $([ "_${key_16412}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1398_v0 "$(( page_start_16415 + _selected_75 ))"
        local ret_checked_toggle1398_v0__310_16="${ret_checked_toggle1398_v0}"
        if [ "${ret_checked_toggle1398_v0__310_16}" != 0 ]; then
            redraw_current_line__1587_v0 
        fi
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $([ "_${key_16412}" != "_a" ]; echo $?) || $([ "_${key_16412}" != "_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
        checked_all__1399_v0 
        local ret_checked_all1399_v0__316_16="${ret_checked_all1399_v0}"
        if [ "${ret_checked_all1399_v0__316_16}" != 0 ]; then
            go_up__1232_v0 "${_display_count_72}"
            local array_289=("")
            eprintf__1178_v0 "\\x1b[G" array_289[@]
            render_page__1576_v0 
        fi
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$([ "_${key_16412}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1588_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_16414 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1588_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_16413 != _selected_75 ))" != 0 ]; then
        redraw_selection__1586_v0 "${prev_selected_16413}"
    fi
    ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
    return 0
}

# chooser_selected()
chooser_selected__1589_v0() {
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__340_12="${ret_chooser_page_start1580_v0}"
    ret_chooser_selected1589_v0="$(( ret_chooser_page_start1580_v0__340_12 + _selected_75 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1590_v0() {
    local index_16440="${1}"
    checked_is__1396_v0 "${index_16440}"
    ret_chooser_is_checked1590_v0="${ret_checked_is1396_v0}"
    return 0
}

# chooser_end()
chooser_end__1591_v0() {
    local total_lines_16435="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_16435="$(( total_lines_16435 + 1 ))"
    fi
    go_down__1233_v0 1
    remove_line__1228_v0 "$(( total_lines_16435 - 1 ))"
    remove_current_line__1229_v0 
    stty_unlock__1219_v0 
    show_cursor__1236_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1600_v0() {
    local options_16444=("${!1}")
    local cursor_16445="${2}"
    local header_16446="${3}"
    local page_size_16447="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_290=("${options_16444[@]}")
    local total_16448="${#__length_290[@]}"
    if [ "$(( total_16448 == 0 ))" != 0 ]; then
        eprintf_colored__1179_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1579_v0 "${total_16448}" "${page_size_16447}" "${header_16446}" "${cursor_16445}" 0 -1
    local need_page_16449=1
    while :
    do
        if [ "${need_page_16449}" != 0 ]; then
            local page_16450=()
            chooser_page_start__1580_v0 
            local start_16451="${ret_chooser_page_start1580_v0}"
            chooser_page_count__1581_v0 
            local count_16452="${ret_chooser_page_count1581_v0}"
            local __range_start_16453="${start_16451}"
            local __range_end_16453="$(( start_16451 + count_16452 ))"
            local __dir_16453=$(( ${__range_start_16453} <= ${__range_end_16453} ? 1 : -1 ))
            for (( i_16453=${__range_start_16453}; i_16453 * ${__dir_16453} < ${__range_end_16453} * ${__dir_16453}; i_16453+=${__dir_16453} )); do
                local array_292=("${options_16444[${i_16453}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_16450+=("${array_292[@]}")
done
            chooser_set_page__1582_v0 page_16450[@]
        fi
        chooser_step__1588_v0 
        local step_16454="${ret_chooser_step1588_v0}"
        if [ "$(( step_16454 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_16449="$(( step_16454 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1589_v0 
    local selected_16455="${ret_chooser_selected1589_v0}"
    chooser_end__1591_v0 
    ret_xyl_choose1600_v0="${options_16444[${selected_16455}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1601_v0() {
    local options_16306=("${!1}")
    local cursor_16307="${2}"
    local header_16308="${3}"
    local limit_16309="${4}"
    local page_size_16310="${5}"
    local __length_293=("${options_16306[@]}")
    local total_16311="${#__length_293[@]}"
    if [ "$(( total_16311 == 0 ))" != 0 ]; then
        eprintf_colored__1179_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1601_v0=()
        return 0
    fi
    chooser_begin__1579_v0 "${total_16311}" "${page_size_16310}" "${header_16308}" "${cursor_16307}" 1 "${limit_16309}"
    local need_page_16383=1
    while :
    do
        if [ "${need_page_16383}" != 0 ]; then
            local page_16384=()
            chooser_page_start__1580_v0 
            local start_16385="${ret_chooser_page_start1580_v0}"
            chooser_page_count__1581_v0 
            local count_16388="${ret_chooser_page_count1581_v0}"
            local __range_start_16389="${start_16385}"
            local __range_end_16389="$(( start_16385 + count_16388 ))"
            local __dir_16389=$(( ${__range_start_16389} <= ${__range_end_16389} ? 1 : -1 ))
            for (( i_16389=${__range_start_16389}; i_16389 * ${__dir_16389} < ${__range_end_16389} * ${__dir_16389}; i_16389+=${__dir_16389} )); do
                local array_296=("${options_16306[${i_16389}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_16384+=("${array_296[@]}")
done
            chooser_set_page__1582_v0 page_16384[@]
        fi
        chooser_step__1588_v0 
        local step_16434="${ret_chooser_step1588_v0}"
        if [ "$(( step_16434 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_16383="$(( step_16434 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1591_v0 
    local result_16438=()
    local __range_start_16439=0
    local __range_end_16439="${total_16311}"
    local __dir_16439=$(( ${__range_start_16439} <= ${__range_end_16439} ? 1 : -1 ))
    for (( i_16439=${__range_start_16439}; i_16439 * ${__dir_16439} < ${__range_end_16439} * ${__dir_16439}; i_16439+=${__dir_16439} )); do
        chooser_is_checked__1590_v0 "${i_16439}"
        local ret_chooser_is_checked1590_v0__93_12="${ret_chooser_is_checked1590_v0}"
        if [ "${ret_chooser_is_checked1590_v0__93_12}" != 0 ]; then
            local array_298=("${options_16306[${i_16439}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_16438+=("${array_298[@]}")
        fi
done
    ret_xyl_multi_choose1601_v0=("${result_16438[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1702_v0() {
    local usage_16232=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1237_v0 usage_16232[@]
    printf '%s\n' ""
    colored_primary__1279_v0 "choose"
    local ret_colored_primary1279_v0__8_20="${ret_colored_primary1279_v0}"
    local title_16256=("${ret_colored_primary1279_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1237_v0 title_16256[@]
    printf '%s\n' ""
    colored_secondary__1280_v0 "Arguments:"
    local ret_colored_secondary1280_v0__11_12="${ret_colored_secondary1280_v0}"
    local array_301=()
    printf__128_v0 "${ret_colored_secondary1280_v0__11_12}""
" array_301[@]
    local arg_names_16258=("[<options> ...]")
    local arg_texts_16259=("List of options to choose from")
    local arg_notes_16260=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1412_v0 arg_names_16258[@] arg_texts_16259[@] arg_notes_16260[@] 20
    printf '%s\n' ""
    colored_secondary__1280_v0 "Flags:"
    local ret_colored_secondary1280_v0__18_12="${ret_colored_secondary1280_v0}"
    local array_305=()
    printf__128_v0 "${ret_colored_secondary1280_v0__18_12}""
" array_305[@]
    local names_16293=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_16294=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_16295=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1412_v0 names_16293[@] texts_16294[@] notes_16295[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1760_v0() {
    local options_16225=()
    local command_310
    command_310="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_16226="${command_310}"
    if [ "$([ "_${is_tty_16226}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_16225+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1760_v0=("${options_16225[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1761_v0() {
    local parameters_16209=("${!1}")
    local cursor_16210="> "
    colored_primary__1279_v0 "Choose: "
    local ret_colored_primary1279_v0__17_30="${ret_colored_primary1279_v0}"
    local header_16224="\\x1b[1m""${ret_colored_primary1279_v0__17_30}"
    read_stdin_options__1760_v0 
    local options_16227=("${ret_read_stdin_options1760_v0[@]}")
    local multi_16228=0
    local limit_16229=-1
    local page_size_16230=10
    local __length_314=("${parameters_16209[@]}")
    local slice_upper_313="${#__length_314[@]}"
    local slice_offset_315=2
    local slice_offset_315=$((${slice_offset_315} > 0 ? ${slice_offset_315} : 0))
    local slice_length_316="$(( slice_upper_313 - slice_offset_315 ))"
    local slice_length_316=$((${slice_length_316} > 0 ? ${slice_length_316} : 0))
    for param_16231 in "${parameters_16209[@]:${slice_offset_315}:${slice_length_316}}"; do
        starts_with__22_v0 "${param_16231}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16231}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16231}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16231}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16231}" != "_-h" ]; echo $?) || $([ "_${param_16231}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1702_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_317="--cursor="
            slice__24_v0 "${param_16231}" "${#__length_317}" 0
            cursor_16210="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_318="--header="
            slice__24_v0 "${param_16231}" "${#__length_318}" 0
            header_16224="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_319="--limit="
            slice__24_v0 "${param_16231}" "${#__length_319}" 0
            local value_16296="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16296}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1179_v0 "ERROR: Invalid limit value: ""${value_16296}""
" 31
                exit 1
            fi
            limit_16229="${ret_parse_int13_v0}"
            multi_16228=1
        elif [ "$([ "_${param_16231}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_16228=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_320="--page-size="
            slice__24_v0 "${param_16231}" "${#__length_320}" 0
            local value_16301="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16301}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1179_v0 "ERROR: Invalid page-size value: ""${value_16301}""
" 31
                exit 1
            fi
            page_size_16230="${ret_parse_int13_v0}"
        else
            options_16227+=("${param_16231}")
        fi
    done
    has_ansi_escape__1303_v0 "${header_16224}"
    local ret_has_ansi_escape1303_v0__59_44="${ret_has_ansi_escape1303_v0}"
    escape_ansi__1304_v0 "${header_16224}"
    local ret_escape_ansi1304_v0__59_73="${ret_escape_ansi1304_v0}"
    colored_primary__1279_v0 "${header_16224}"
    local ret_colored_primary1279_v0__59_111="${ret_colored_primary1279_v0}"
    local display_header_16305
    display_header_16305="$(if [ "$(( $([ "_${header_16224}" != "_" ]; echo $?) || ret_has_ansi_escape1303_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1304_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1279_v0__59_111}"; fi)"
    if [ "${multi_16228}" != 0 ]; then
        xyl_multi_choose__1601_v0 options_16227[@] "${cursor_16210}" "${display_header_16305}" "${limit_16229}" "${page_size_16230}"
        local results_16441=("${ret_xyl_multi_choose1601_v0[@]}")
        join__7_v0 results_16441[@] "
"
        ret_execute_choose1761_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1600_v0 options_16227[@] "${cursor_16210}" "${display_header_16305}" "${page_size_16230}"
    ret_execute_choose1761_v0="${ret_xyl_choose1600_v0}"
    return 0
}

# get_key()
get_key__1885_v0() {
    local command_322
    command_322="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_18483="${command_322}"
    if [ "$([ "_${var_18483}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1885_v0="UP"
        return 0
    elif [ "$([ "_${var_18483}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1885_v0="DOWN"
        return 0
    elif [ "$([ "_${var_18483}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1885_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_18483}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1885_v0="LEFT"
        return 0
    elif [ "$([ "_${var_18483}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1885_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_18483}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1885_v0="INPUT"
        return 0
    else
        ret_get_key1885_v0="${var_18483}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1887_v0() {
    local format_18389="${1}"
    local args_18390=("${!2}")
    args_18390=("${format_18389}" "${args_18390[@]}")
    __status=$?
    printf "${args_18390[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1888_v0() {
    local message_18387="${1}"
    local color_18388="${2}"
    # Prints an error message with a specified color.
    local array_323=("${message_18387}")
    eprintf__1887_v0 "\\x1b[${color_18388}m%s\\x1b[0m" array_323[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1903_v0() {
    local format_18399="${1}"
    local args_18400=("${!2}")
    args_18400=("${format_18399}" "${args_18400[@]}")
    __status=$?
    printf "${args_18400[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_90="None"
# perl_available()
perl_available__1910_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_324
        command_324="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18345
        disabled_18345="$([ "_${command_324}" != "_No" ]; echo $?)"
        local command_325
        command_325="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18346
        found_18346="$(( $(( ! disabled_18345 )) && $([ "_${command_325}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_18346}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1910_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1911_v0() {
    local text_18344="${1}"
    perl_available__1910_v0 
    local ret_perl_available1910_v0__22_12="${ret_perl_available1910_v0}"
    if [ "$(( ! ret_perl_available1910_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1911_v0=''
        return 1
    fi
    local command_326
    command_326="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18344}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1911_v0=''
        return "${__status}"
    fi
    local width_str_18347="${command_326}"
    parse_int__13_v0 "${width_str_18347}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1911_v0=''
        return "${__status}"
    fi
    local width_18348="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1911_v0="${width_18348}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1916_v0() {
    local text_18337="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_327
    command_327="$([[ "${text_18337}" == *$'\x1b'* || "${text_18337}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18338="${command_327}"
    ret_has_ansi_escape1916_v0="$([ "_${has_escape_18338}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1918_v0() {
    local text_18340="${1}"
    local command_328
    command_328="$(printf "%s" "${text_18340}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1918_v0="${command_328}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1919_v0() {
    local text_18342="${1}"
    local command_329
    command_329="$(printf "%s" "${text_18342}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18343="${command_329}"
    ret_is_all_ascii1919_v0="$([ "_${result_18343}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1920_v0() {
    local text_18339="${1}"
    strip_ansi__1918_v0 "${text_18339}"
    local stripped_18341="${ret_strip_ansi1918_v0}"
    # Check if text is all ASCII
    is_all_ascii__1919_v0 "${stripped_18341}"
    local ret_is_all_ascii1919_v0__36_12="${ret_is_all_ascii1919_v0}"
    if [ "$(( ! ret_is_all_ascii1919_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1911_v0 "${stripped_18341}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_330="${stripped_18341}"
            ret_get_visible_len1920_v0="${#__length_330}"
            return 0
        fi
        ret_get_visible_len1920_v0="${ret_perl_get_cjk_width1911_v0}"
        return 0
    else
        local __length_331="${stripped_18341}"
        ret_get_visible_len1920_v0="${#__length_331}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_91=0
_term_size_92=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1926_v0() {
    local command_333
    command_333="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_18397="${command_333}"
    parse_int__13_v0 "${count_18397}"
    __status=$?
    ret_stty_count1926_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1927_v0() {
    stty_count__1926_v0 
    local count_num_18398="${ret_stty_count1926_v0}"
    if [ "$(( count_num_18398 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_18398="$(( count_num_18398 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18398}
    __status=$?
}

# stty_unlock()
stty_unlock__1928_v0() {
    stty_count__1926_v0 
    local count_num_18490="${ret_stty_count1926_v0}"
    if [ "$(( count_num_18490 > 0 ))" != 0 ]; then
        count_num_18490="$(( count_num_18490 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18490}
        __status=$?
        if [ "$(( count_num_18490 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1929_v0() {
    local size_18328="${1}"
    if [ "$([ "_${size_18328}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1929_v0=0
        return 0
    fi
    split__4_v0 "${size_18328}" " "
    local parts_18329=("${ret_split4_v0[@]}")
    local __length_334=("${parts_18329[@]}")
    if [ "$(( ${#__length_334[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1929_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18329[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18329[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_92=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1929_v0=1
    return 0
}

# query_term_size()
query_term_size__1930_v0() {
    local command_336
    command_336="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18331="${command_336}"
    store_term_size__1929_v0 "${size_18331}"
    ret_query_term_size1930_v0="${ret_store_term_size1929_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1931_v0() {
    local command_337
    command_337="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18327="${command_337}"
    store_term_size__1929_v0 "${size_18327}"
    ret_stty_term_size1931_v0="${ret_store_term_size1929_v0}"
    return 0
}

# get_term_size()
get_term_size__1932_v0() {
    stty_term_size__1931_v0 
    local detected_18330="${ret_stty_term_size1931_v0}"
    if [ "$(( ! detected_18330 ))" != 0 ]; then
        query_term_size__1930_v0 
        detected_18330="${ret_query_term_size1930_v0}"
    fi
    _got_term_size_91=1
}

# term_width()
term_width__1934_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1932_v0 
    fi
    ret_term_width1934_v0="${_term_size_92[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1937_v0() {
    local cnt_18487="${1}"
    if [ "$(( cnt_18487 > 0 ))" != 0 ]; then
        local sequence_18488=""
        local __range_start_18489=0
        local __range_end_18489="${cnt_18487}"
        local __dir_18489=$(( ${__range_start_18489} <= ${__range_end_18489} ? 1 : -1 ))
        for (( ____18489=${__range_start_18489}; ____18489 * ${__dir_18489} < ${__range_end_18489} * ${__dir_18489}; ____18489+=${__dir_18489} )); do
            sequence_18488+="\\x1b[2K\\x1b[1A"
done
        local array_338=("")
        eprintf__1903_v0 "${sequence_18488}" array_338[@]
    fi
    local array_339=("")
    eprintf__1903_v0 "\\x1b[G" array_339[@]
}

# remove_current_line()
remove_current_line__1938_v0() {
    local array_340=("")
    eprintf__1903_v0 "\\x1b[2K\\x1b[G" array_340[@]
}

# go_up(cnt: Int)
go_up__1941_v0() {
    local cnt_18482="${1}"
    local array_341=("")
    eprintf__1903_v0 "\\x1b[${cnt_18482}A" array_341[@]
}

# go_down(cnt: Int)
go_down__1942_v0() {
    local cnt_18486="${1}"
    local array_342=("")
    eprintf__1903_v0 "\\x1b[${cnt_18486}B" array_342[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1944_v0() {
    local array_343=("")
    eprintf__1903_v0 "\\x1b[?25l" array_343[@]
}

# show_cursor()
show_cursor__1945_v0() {
    local array_344=("")
    eprintf__1903_v0 "\\x1b[?25h" array_344[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1946_v0() {
    local pieces_18326=("${!1}")
    term_width__1934_v0 
    local width_18332="${ret_term_width1934_v0}"
    local line_18333=""
    local line_len_18334=0
    for piece_18335 in "${pieces_18326[@]}"; do
        local __length_347="${piece_18335}"
        local piece_len_18336="${#__length_347}"
        has_ansi_escape__1916_v0 "${piece_18335}"
        local ret_has_ansi_escape1916_v0__186_12="${ret_has_ansi_escape1916_v0}"
        if [ "${ret_has_ansi_escape1916_v0__186_12}" != 0 ]; then
            get_visible_len__1920_v0 "${piece_18335}"
            piece_len_18336="${ret_get_visible_len1920_v0}"
        fi
        if [ "$([ "_${line_18333}" != "_" ]; echo $?)" != 0 ]; then
            line_18333="${piece_18335}"
            line_len_18334="${piece_len_18336}"
        elif [ "$(( $(( $(( line_len_18334 + 1 )) + piece_len_18336 )) > width_18332 ))" != 0 ]; then
            local array_348=()
            printf__128_v0 "${line_18333}""
" array_348[@]
            line_18333="${piece_18335}"
            line_len_18334="${piece_len_18336}"
        else
            line_18333+=" ""${piece_18335}"
            line_len_18334="$(( line_len_18334 + $(( 1 + piece_len_18336 )) ))"
        fi
    done
    if [ "$([ "_${line_18333}" == "_" ]; echo $?)" != 0 ]; then
        local array_349=()
        printf__128_v0 "${line_18333}""
" array_349[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_95="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_96=0
_primary_color_97=(3 207 159 92)
_secondary_color_98=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1983_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_18321="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_18321}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1983_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1984_v0() {
    local message_18316="${1}"
    local r_18317="${2}"
    local g_18318="${3}"
    local b_18319="${4}"
    local fallback_18320="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1984_v0="\\x1b[38;2;${r_18317};${g_18318};${b_18319}m""${message_18316}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1983_v0 
        local ret_get_supports_truecolor1983_v0__45_17="${ret_get_supports_truecolor1983_v0}"
        if [ "${ret_get_supports_truecolor1983_v0__45_17}" != 0 ]; then
            ret_colored_rgb1984_v0="\\x1b[38;2;${r_18317};${g_18318};${b_18319}m""${message_18316}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_18320 == 0 ))" != 0 ]; then
            ret_colored_rgb1984_v0="${message_18316}"
            return 0
        else
            ret_colored_rgb1984_v0="\\x1b[${fallback_18320}m""${message_18316}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_18320 == 0 ))" != 0 ]; then
            ret_colored_rgb1984_v0="${message_18316}"
            return 0
        fi
        ret_colored_rgb1984_v0="\\x1b[${fallback_18320}m""${message_18316}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1985_v0() {
    local message_18459="${1}"
    local r_18460="${2}"
    local g_18461="${3}"
    local b_18462="${4}"
    local fallback_18463="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_18464="${fallback_18463}"
    if [ "$(( $(( fallback_18463 >= 30 )) && $(( fallback_18463 <= 37 )) ))" != 0 ]; then
        bg_fallback_18464="$(( fallback_18463 + 10 ))"
    fi
    if [ "$(( $(( fallback_18463 >= 90 )) && $(( fallback_18463 <= 97 )) ))" != 0 ]; then
        bg_fallback_18464="$(( fallback_18463 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1985_v0="\\x1b[48;2;${r_18460};${g_18461};${b_18462}m""${message_18459}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1983_v0 
        local ret_get_supports_truecolor1983_v0__87_17="${ret_get_supports_truecolor1983_v0}"
        if [ "${ret_get_supports_truecolor1983_v0__87_17}" != 0 ]; then
            ret_background_rgb1985_v0="\\x1b[48;2;${r_18460};${g_18461};${b_18462}m""${message_18459}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_18464 == 0 ))" != 0 ]; then
            ret_background_rgb1985_v0="${message_18459}"
            return 0
        else
            ret_background_rgb1985_v0="\\x1b[${bg_fallback_18464}m""${message_18459}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_18464 == 0 ))" != 0 ]; then
            ret_background_rgb1985_v0="${message_18459}"
            return 0
        fi
        ret_background_rgb1985_v0="\\x1b[${bg_fallback_18464}m""${message_18459}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1986_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_18310="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_18310}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_18310}" ";"
            local parts_18311=("${ret_split4_v0[@]}")
            local __length_353=("${parts_18311[@]}")
            if [ "$(( ${#__length_353[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18311[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18311[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18311[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18311[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_97=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_18312="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_18312}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_18312}" ";"
            local parts_18313=("${ret_split4_v0[@]}")
            local __length_355=("${parts_18313[@]}")
            if [ "$(( ${#__length_355[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18313[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18313[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18313[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18313[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_98=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_18314="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_18314}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_18314}" ";"
            local parts_18315=("${ret_split4_v0[@]}")
            local __length_357=("${parts_18315[@]}")
            if [ "$(( ${#__length_357[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18315[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18315[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18315[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18315[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1986_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_96=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1987_v0() {
    inner_get_xylitol_colors__1986_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_96=1
}

# colored_primary(message: Text)
colored_primary__1988_v0() {
    local message_18309="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1987_v0 
    fi
    colored_rgb__1984_v0 "${message_18309}" "${_primary_color_97[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1988_v0="${ret_colored_rgb1984_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1989_v0() {
    local message_18350="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1987_v0 
    fi
    colored_rgb__1984_v0 "${message_18350}" "${_secondary_color_98[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1989_v0="${ret_colored_rgb1984_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1992_v0() {
    local message_18458="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1987_v0 
    fi
    background_rgb__1985_v0 "${message_18458}" "${_secondary_color_98[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary1992_v0="${ret_background_rgb1985_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_100="None"
# perl_available()
perl_available__2006_v0() {
    if [ "$([ "_${_perl_state_100}" != "_None" ]; echo $?)" != 0 ]; then
        local command_359
        command_359="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18410
        disabled_18410="$([ "_${command_359}" != "_No" ]; echo $?)"
        local command_360
        command_360="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18411
        found_18411="$(( $(( ! disabled_18410 )) && $([ "_${command_360}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_18411}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2006_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2007_v0() {
    local text_18409="${1}"
    perl_available__2006_v0 
    local ret_perl_available2006_v0__22_12="${ret_perl_available2006_v0}"
    if [ "$(( ! ret_perl_available2006_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2007_v0=''
        return 1
    fi
    local command_361
    command_361="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18409}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2007_v0=''
        return "${__status}"
    fi
    local width_str_18412="${command_361}"
    parse_int__13_v0 "${width_str_18412}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2007_v0=''
        return "${__status}"
    fi
    local width_18413="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2007_v0="${width_18413}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2008_v0() {
    local text_18420="${1}"
    local max_width_18421="${2}"
    perl_available__2006_v0 
    local ret_perl_available2006_v0__33_12="${ret_perl_available2006_v0}"
    if [ "$(( ! ret_perl_available2006_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2008_v0=''
        return 1
    fi
    local command_362
    command_362="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18420}" ${max_width_18421} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2008_v0=''
        return "${__status}"
    fi
    local result_18422="${command_362}"
    ret_perl_truncate_cjk2008_v0="${result_18422}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2012_v0() {
    local text_18391="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_363
    command_363="$([[ "${text_18391}" == *$'\x1b'* || "${text_18391}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18392="${command_363}"
    ret_has_ansi_escape2012_v0="$([ "_${has_escape_18392}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2013_v0() {
    local text_18393="${1}"
    local command_364
    command_364="$(printf '%s' "${text_18393}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2013_v0="${command_364}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2014_v0() {
    local text_18405="${1}"
    local command_365
    command_365="$(printf "%s" "${text_18405}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2014_v0="${command_365}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2015_v0() {
    local text_18407="${1}"
    local command_366
    command_366="$(printf "%s" "${text_18407}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18408="${command_366}"
    ret_is_all_ascii2015_v0="$([ "_${result_18408}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2016_v0() {
    local text_18404="${1}"
    strip_ansi__2014_v0 "${text_18404}"
    local stripped_18406="${ret_strip_ansi2014_v0}"
    # Check if text is all ASCII
    is_all_ascii__2015_v0 "${stripped_18406}"
    local ret_is_all_ascii2015_v0__36_12="${ret_is_all_ascii2015_v0}"
    if [ "$(( ! ret_is_all_ascii2015_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2007_v0 "${stripped_18406}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_367="${stripped_18406}"
            ret_get_visible_len2016_v0="${#__length_367}"
            return 0
        fi
        ret_get_visible_len2016_v0="${ret_perl_get_cjk_width2007_v0}"
        return 0
    else
        local __length_368="${stripped_18406}"
        ret_get_visible_len2016_v0="${#__length_368}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2017_v0() {
    local text_18417="${1}"
    local max_width_18418="${2}"
    get_visible_len__2016_v0 "${text_18417}"
    local visible_len_18419="${ret_get_visible_len2016_v0}"
    if [ "$(( visible_len_18419 <= max_width_18418 ))" != 0 ]; then
        ret_truncate_text2017_v0="${text_18417}"
        return 0
    fi
    is_all_ascii__2015_v0 "${text_18417}"
    local ret_is_all_ascii2015_v0__53_12="${ret_is_all_ascii2015_v0}"
    if [ "$(( ! ret_is_all_ascii2015_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__2008_v0 "${text_18417}" "${max_width_18418}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18417}" | cut -c1-${max_width_18418}
            __status=$?
        fi
        ret_truncate_text2017_v0="${ret_perl_truncate_cjk2008_v0}"
        return 0
    fi
    local command_369
    command_369="$(printf "%s" "${text_18417}" | cut -c1-${max_width_18418})"
    __status=$?
    ret_truncate_text2017_v0="${command_369}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2018_v0() {
    local text_18415="${1}"
    local max_width_18416="${2}"
    has_ansi_escape__2012_v0 "${text_18415}"
    local ret_has_ansi_escape2012_v0__65_12="${ret_has_ansi_escape2012_v0}"
    if [ "$(( ! ret_has_ansi_escape2012_v0__65_12 ))" != 0 ]; then
        truncate_text__2017_v0 "${text_18415}" "${max_width_18416}"
        ret_truncate_ansi2018_v0="${ret_truncate_text2017_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_370
    command_370="$([[ "${text_18415}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18423="${command_370}"
    # Replace \x1b[ with newline, then split
    local command_371
    command_371="$(t="${text_18415}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18424="${command_371}"
    split__4_v0 "${replaced_18424}" "
"
    local parts_18425=("${ret_split4_v0[@]}")
    local result_18426=""
    local remaining_width_18427="${max_width_18416}"
    local __range_start_18428=0
    local __length_372=("${parts_18425[@]}")
    local __range_end_18428="${#__length_372[@]}"
    local __dir_18428=$(( ${__range_start_18428} <= ${__range_end_18428} ? 1 : -1 ))
    for (( idx_18428=${__range_start_18428}; idx_18428 * ${__dir_18428} < ${__range_end_18428} * ${__dir_18428}; idx_18428+=${__dir_18428} )); do
        local part_18429="${parts_18425[${idx_18428}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18428 == 0 )) && $([ "_${starts_with_ansi_18423}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18429}" == "_" ]; echo $?) && $(( remaining_width_18427 > 0 )) ))" != 0 ]; then
                truncate_text__2017_v0 "${part_18429}" "${remaining_width_18427}"
                local ret_truncate_text2017_v0__87_35="${ret_truncate_text2017_v0}"
                local truncated_18430="${ret_truncate_text2017_v0__87_35}"
                result_18426+="${truncated_18430}"
                get_visible_len__2016_v0 "${truncated_18430}"
                local ret_get_visible_len2016_v0__89_36="${ret_get_visible_len2016_v0}"
                remaining_width_18427="$(( remaining_width_18427 - ret_get_visible_len2016_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_373
            command_373="$(__p="${part_18429}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18431="${command_373}"
            if [ "$([ "_${m_idx_18431}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_374
                command_374="$(__p="${part_18429}"; printf "%s" "${__p:0:${m_idx_18431}}")"
                __status=$?
                local ansi_params_18432="${command_374}"
                result_18426+="\\x1b[""${ansi_params_18432}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18431}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_18433="${ret_parse_int13_v0__100_41}"
                local text_start_18434="$(( m_idx_num_18433 + 1 ))"
                local command_375
                command_375="$(__p="${part_18429}"; printf "%s" "${__p:${text_start_18434}}")"
                __status=$?
                local text_part_18435="${command_375}"
                if [ "$(( $([ "_${text_part_18435}" == "_" ]; echo $?) && $(( remaining_width_18427 > 0 )) ))" != 0 ]; then
                    truncate_text__2017_v0 "${text_part_18435}" "${remaining_width_18427}"
                    local ret_truncate_text2017_v0__104_39="${ret_truncate_text2017_v0}"
                    local truncated_18436="${ret_truncate_text2017_v0__104_39}"
                    result_18426+="${truncated_18436}"
                    get_visible_len__2016_v0 "${truncated_18436}"
                    local ret_get_visible_len2016_v0__106_40="${ret_get_visible_len2016_v0}"
                    remaining_width_18427="$(( remaining_width_18427 - ret_get_visible_len2016_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18429}" == "_" ]; echo $?) && $(( remaining_width_18427 > 0 )) ))" != 0 ]; then
                    truncate_text__2017_v0 "${part_18429}" "${remaining_width_18427}"
                    local ret_truncate_text2017_v0__111_39="${ret_truncate_text2017_v0}"
                    local truncated_18437="${ret_truncate_text2017_v0__111_39}"
                    result_18426+="${truncated_18437}"
                    get_visible_len__2016_v0 "${truncated_18437}"
                    local ret_get_visible_len2016_v0__113_40="${ret_get_visible_len2016_v0}"
                    remaining_width_18427="$(( remaining_width_18427 - ret_get_visible_len2016_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2018_v0="${result_18426}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2019_v0() {
    local text_18402="${1}"
    local max_width_18403="${2}"
    get_visible_len__2016_v0 "${text_18402}"
    local visible_len_18414="${ret_get_visible_len2016_v0}"
    if [ "$(( visible_len_18414 <= max_width_18403 ))" != 0 ]; then
        ret_cutoff_text2019_v0="${text_18402}"
        return 0
    fi
    truncate_ansi__2018_v0 "${text_18402}" "$(( max_width_18403 - 3 ))"
    local ret_truncate_ansi2018_v0__129_12="${ret_truncate_ansi2018_v0}"
    ret_cutoff_text2019_v0="${ret_truncate_ansi2018_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__2040_v0() {
    local format_18473="${1}"
    local args_18474=("${!2}")
    args_18474=("${format_18473}" "${args_18474[@]}")
    __status=$?
    printf "${args_18474[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2041_v0() {
    local message_18471="${1}"
    local color_18472="${2}"
    # Prints an error message with a specified color.
    local array_376=("${message_18471}")
    eprintf__2040_v0 "\\x1b[${color_18472}m%s\\x1b[0m" array_376[@]
}

# colored(message: Text, color: Int)
colored__2042_v0() {
    local message_18384="${1}"
    local color_18385="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2042_v0="\\x1b[${color_18385}m""${message_18384}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2046_v0() {
    local items_18465=("${!1}")
    local total_len_18466="${2}"
    local term_width_18467="${3}"
    local separator_18468=" • "
    local separator_len_18469=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18466 <= term_width_18467 ))" != 0 ]; then
        local iter_18470=0
        while :
        do
            local __length_377=("${items_18465[@]}")
            if [ "$(( iter_18470 >= ${#__length_377[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18470 > 0 ))" != 0 ]; then
                eprintf_colored__2041_v0 "${separator_18468}" 90
            fi
            colored__2042_v0 "${items_18465[$(( iter_18470 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2042_v0__23_41="${ret_colored2042_v0}"
            local array_378=("")
            eprintf__2040_v0 "${items_18465[${iter_18470}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2042_v0__23_41}" array_378[@]
            iter_18470="$(( iter_18470 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18475=0
        local first_18476=1
        local iter_18477=0
        while :
        do
            local __length_379=("${items_18465[@]}")
            if [ "$(( iter_18477 >= ${#__length_379[@]} ))" != 0 ]; then
                break
            fi
            local key_18478="${items_18465[${iter_18477}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_18479="${items_18465[$(( iter_18477 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_380="${key_18478}"
            local __length_381="${action_18479}"
            local part_len_18480="$(( $(( ${#__length_380} + 1 )) + ${#__length_381} ))"
            local needed_18481="${part_len_18480}"
            if [ "$(( ! first_18476 ))" != 0 ]; then
                needed_18481="$(( needed_18481 + separator_len_18469 ))"
            fi
            if [ "$(( $(( current_len_18475 + needed_18481 )) > term_width_18467 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18476 ))" != 0 ]; then
                eprintf_colored__2041_v0 "${separator_18468}" 90
            fi
            colored__2042_v0 "${action_18479}" 2
            local ret_colored2042_v0__51_33="${ret_colored2042_v0}"
            local array_382=("")
            eprintf__2040_v0 "${key_18478}"" ""${ret_colored2042_v0__51_33}" array_382[@]
            current_len_18475="$(( current_len_18475 + needed_18481 ))"
            first_18476=0
            iter_18477="$(( iter_18477 + 2 ))"
        done
    fi
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_103=0
_term_size_104=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__2082_v0() {
    local size_18363="${1}"
    if [ "$([ "_${size_18363}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2082_v0=0
        return 0
    fi
    split__4_v0 "${size_18363}" " "
    local parts_18364=("${ret_split4_v0[@]}")
    local __length_384=("${parts_18364[@]}")
    if [ "$(( ${#__length_384[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2082_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18364[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18364[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_104=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2082_v0=1
    return 0
}

# query_term_size()
query_term_size__2083_v0() {
    local command_386
    command_386="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18366="${command_386}"
    store_term_size__2082_v0 "${size_18366}"
    ret_query_term_size2083_v0="${ret_store_term_size2082_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2084_v0() {
    local command_387
    command_387="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18362="${command_387}"
    store_term_size__2082_v0 "${size_18362}"
    ret_stty_term_size2084_v0="${ret_store_term_size2082_v0}"
    return 0
}

# get_term_size()
get_term_size__2085_v0() {
    stty_term_size__2084_v0 
    local detected_18365="${ret_stty_term_size2084_v0}"
    if [ "$(( ! detected_18365 ))" != 0 ]; then
        query_term_size__2083_v0 
        detected_18365="${ret_query_term_size2083_v0}"
    fi
    _got_term_size_103=1
}

# term_width()
term_width__2087_v0() {
    if [ "$(( ! _got_term_size_103 ))" != 0 ]; then
        get_term_size__2085_v0 
    fi
    ret_term_width2087_v0="${_term_size_104[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# 
# The state sits at module level, so only one such widget may be open at a
# time. Reach it through `utils.ab` rather than importing this file directly:
# the compiler keys modules by the literal text of the import path, so a
# second spelling would hand that caller its own copy of these variables.
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2120_v0() {
    local pending_18381="${1}"
    local line_18382="${2}"
    local note_at_18383="${3}"
    if [ "$(( note_at_18383 < 0 ))" != 0 ]; then
        local array_389=()
        printf__128_v0 "${pending_18381}""${line_18382}""
" array_389[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_18383 == 0 ))" != 0 ]; then
        colored__2042_v0 "${line_18382}" 90
        local ret_colored2042_v0__12_40="${ret_colored2042_v0}"
        local array_390=()
        printf__128_v0 "${pending_18381}""${ret_colored2042_v0__12_40}""
" array_390[@]
    else
        slice__24_v0 "${line_18382}" 0 "${note_at_18383}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_18382}" "${note_at_18383}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2042_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2042_v0__13_58="${ret_colored2042_v0}"
        local array_391=()
        printf__128_v0 "${pending_18381}""${ret_slice24_v0__13_32}""${ret_colored2042_v0__13_58}""
" array_391[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2121_v0() {
    local names_18354=("${!1}")
    local texts_18355=("${!2}")
    local notes_18356=("${!3}")
    local min_name_width_18357="${4}"
    local __length_392=("${names_18354[@]}")
    local count_18358="${#__length_392[@]}"
    local name_width_18359="${min_name_width_18357}"
    local __range_start_18360=0
    local __range_end_18360="${count_18358}"
    local __dir_18360=$(( ${__range_start_18360} <= ${__range_end_18360} ? 1 : -1 ))
    for (( i_18360=${__range_start_18360}; i_18360 * ${__dir_18360} < ${__range_end_18360} * ${__dir_18360}; i_18360+=${__dir_18360} )); do
        local __length_393="${names_18354[${i_18360}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_18361="${#__length_393}"
        if [ "$(( width_18361 > name_width_18359 ))" != 0 ]; then
            name_width_18359="${width_18361}"
        fi
done
    term_width__2087_v0 
    local width_18367="${ret_term_width2087_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_18368="$(( name_width_18359 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_18369="$(( $(( width_18367 - indent_18368 )) < 24 ))"
    if [ "${stacked_18369}" != 0 ]; then
        indent_18368=6
    fi
    local avail_18370="$(( width_18367 - indent_18368 ))"
    rpad__28_v0 "" " " "${indent_18368}"
    local blank_18371="${ret_rpad28_v0}"
    local __range_start_18372=0
    local __range_end_18372="${count_18358}"
    local __dir_18372=$(( ${__range_start_18372} <= ${__range_end_18372} ? 1 : -1 ))
    for (( i_18372=${__range_start_18372}; i_18372 * ${__dir_18372} < ${__range_end_18372} * ${__dir_18372}; i_18372+=${__dir_18372} )); do
        local pending_18373="${blank_18371}"
        if [ "${stacked_18369}" != 0 ]; then
            local array_394=()
            printf__128_v0 "  ""${names_18354[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_394[@]
        else
            rpad__28_v0 "  ""${names_18354[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_18368}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_18373="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_18355[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_18374=("${ret_split4_v0__52_21[@]}")
        local __length_395=("${words_18374[@]}")
        local note_start_18375="${#__length_395[@]}"
        if [ "$([ "_${notes_18356[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_396="${notes_18356[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_396} > avail_18370 ))" != 0 ]; then
                split__4_v0 "${notes_18356[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_18374+=("${ret_split4_v0__58_26[@]}")
            else
                local array_397=("${notes_18356[${i_18372}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_18374+=("${array_397[@]}")
            fi
        fi
        local line_18376=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_18377=-1
        local __range_start_18378=0
        local __length_398=("${words_18374[@]}")
        local __range_end_18378="${#__length_398[@]}"
        local __dir_18378=$(( ${__range_start_18378} <= ${__range_end_18378} ? 1 : -1 ))
        for (( j_18378=${__range_start_18378}; j_18378 * ${__dir_18378} < ${__range_end_18378} * ${__dir_18378}; j_18378+=${__dir_18378} )); do
            local word_18379="${words_18374[${j_18378}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_18380
            candidate_18380="$(if [ "$([ "_${line_18376}" != "_" ]; echo $?)" != 0 ]; then echo "${word_18379}"; else echo "${line_18376}"" ""${word_18379}"; fi)"
            local __length_399="${candidate_18380}"
            if [ "$(( $(( ${#__length_399} > avail_18370 )) && $([ "_${line_18376}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2120_v0 "${pending_18373}" "${line_18376}" "${note_at_18377}"
                pending_18373="${blank_18371}"
                line_18376="${word_18379}"
                note_at_18377="$(if [ "$(( j_18378 >= note_start_18375 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_18378 >= note_start_18375 )) && $(( note_at_18377 < 0 )) ))" != 0 ]; then
                    local __length_400="${candidate_18380}"
                    local __length_401="${word_18379}"
                    note_at_18377="$(( ${#__length_400} - ${#__length_401} ))"
                fi
                line_18376="${candidate_18380}"
            fi
done
        print_help_line__2120_v0 "${pending_18373}" "${line_18376}" "${note_at_18377}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2179_v0() {
    local selected_18439="${1}"
    local term_width_18440="${2}"
    local small_18441="$(( term_width_18440 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_18441}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_18455="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_18441}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_18456="${ret_cpad29_v0}"
    local gap_18457
    gap_18457="$(if [ "${small_18441}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_402=("")
    eprintf__1887_v0 " " array_402[@]
    if [ "${selected_18439}" != 0 ]; then
        # Yes selected
        background_secondary__1992_v0 "${yes_label_18455}"
        local ret_background_secondary1992_v0__16_30="${ret_background_secondary1992_v0}"
        local array_403=("")
        eprintf__1887_v0 "\\x1b[97m""${ret_background_secondary1992_v0__16_30}" array_403[@]
        local array_404=("")
        eprintf__1887_v0 "${gap_18457}" array_404[@]
        # No not selected (dim)
        local array_405=("")
        eprintf__1887_v0 "\\x1b[49;37m""${no_label_18456}""\\x1b[0m" array_405[@]
    else
        # No selected
        local array_406=("")
        eprintf__1887_v0 "\\x1b[49;37m""${yes_label_18455}""\\x1b[0m" array_406[@]
        local array_407=("")
        eprintf__1887_v0 "${gap_18457}" array_407[@]
        background_secondary__1992_v0 "${no_label_18456}"
        local ret_background_secondary1992_v0__24_30="${ret_background_secondary1992_v0}"
        local array_408=("")
        eprintf__1887_v0 "\\x1b[97m""${ret_background_secondary1992_v0__24_30}" array_408[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2180_v0() {
    local header_18395="${1}"
    local default_yes_18396="${2}"
    stty_lock__1927_v0 
    hide_cursor__1944_v0 
    term_width__1934_v0 
    local term_width_18401="${ret_term_width1934_v0}"
    if [ "$([ "_${header_18395}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2019_v0 "${header_18395}" "${term_width_18401}"
        local ret_cutoff_text2019_v0__46_17="${ret_cutoff_text2019_v0}"
        local array_409=("")
        eprintf__1887_v0 "${ret_cutoff_text2019_v0__46_17}""

" array_409[@]
    fi
    local selected_18438="${default_yes_18396}"
    # Render initial options
    render_confirm_options__2179_v0 "${selected_18438}" "${term_width_18401}"
    local array_410=("")
    eprintf__1887_v0 "

" array_410[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_411=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2046_v0 array_411[@] 40 "${term_width_18401}"
    go_up__1941_v0 2
    while :
    do
        get_key__1885_v0 
        local key_18484="${ret_get_key1885_v0}"
        if [ "$(( $(( $(( $([ "_${key_18484}" != "_LEFT" ]; echo $?) || $([ "_${key_18484}" != "_h" ]; echo $?) )) || $([ "_${key_18484}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_18484}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_18438}" != 0 ]; then
                selected_18438=0
                local array_412=("")
                eprintf__1887_v0 "\\x1b[G\\x1b[K" array_412[@]
                render_confirm_options__2179_v0 "${selected_18438}" "${term_width_18401}"
            elif [ "$(( ! selected_18438 ))" != 0 ]; then
                selected_18438=1
                local array_413=("")
                eprintf__1887_v0 "\\x1b[G\\x1b[K" array_413[@]
                render_confirm_options__2179_v0 "${selected_18438}" "${term_width_18401}"
            fi
        elif [ "$(( $([ "_${key_18484}" != "_y" ]; echo $?) || $([ "_${key_18484}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_18438=1
            break
        elif [ "$(( $([ "_${key_18484}" != "_n" ]; echo $?) || $([ "_${key_18484}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_18438=0
            break
        elif [ "$([ "_${key_18484}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_18485=4
    if [ "$([ "_${header_18395}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_18485="$(( total_lines_18485 + 1 ))"
    fi
    go_down__1942_v0 2
    remove_line__1937_v0 "$(( total_lines_18485 - 1 ))"
    remove_current_line__1938_v0 
    stty_unlock__1928_v0 
    show_cursor__1945_v0 
    ret_xyl_confirm2180_v0="${selected_18438}"
    return 0
}

# print_confirm_help()
print_confirm_help__2280_v0() {
    local usage_18325=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1946_v0 usage_18325[@]
    printf '%s\n' ""
    colored_primary__1988_v0 "confirm"
    local ret_colored_primary1988_v0__8_20="${ret_colored_primary1988_v0}"
    local title_18349=("${ret_colored_primary1988_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1946_v0 title_18349[@]
    printf '%s\n' ""
    colored_secondary__1989_v0 "Flags:"
    local ret_colored_secondary1989_v0__11_12="${ret_colored_secondary1989_v0}"
    local array_416=()
    printf__128_v0 "${ret_colored_secondary1989_v0__11_12}""
" array_416[@]
    local names_18351=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_18352=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_18353=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2121_v0 names_18351[@] texts_18352[@] notes_18353[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2338_v0() {
    local parameters_18308=("${!1}")
    colored_primary__1988_v0 "Are you sure?"
    local ret_colored_primary1988_v0__9_30="${ret_colored_primary1988_v0}"
    local header_18322="\\x1b[1m""${ret_colored_primary1988_v0__9_30}"
    local default_yes_18323=1
    for param_18324 in "${parameters_18308[@]}"; do
        starts_with__22_v0 "${param_18324}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_18324}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_18324}" != "_-h" ]; echo $?) || $([ "_${param_18324}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2280_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_422="--header="
            slice__24_v0 "${param_18324}" "${#__length_422}" 0
            header_18322="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_423="--default="
            slice__24_v0 "${param_18324}" "${#__length_423}" 0
            local value_18386="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_18386}" != "_yes" ]; echo $?) || $([ "_${value_18386}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_18323=1
            elif [ "$(( $([ "_${value_18386}" != "_no" ]; echo $?) || $([ "_${value_18386}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_18323=0
            else
                eprintf_colored__1888_v0 "ERROR: Invalid default value: ""${value_18386}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2012_v0 "${header_18322}"
    local ret_has_ansi_escape2012_v0__35_44="${ret_has_ansi_escape2012_v0}"
    escape_ansi__2013_v0 "${header_18322}"
    local ret_escape_ansi2013_v0__35_73="${ret_escape_ansi2013_v0}"
    colored_primary__1988_v0 "${header_18322}"
    local ret_colored_primary1988_v0__35_111="${ret_colored_primary1988_v0}"
    local display_header_18394
    display_header_18394="$(if [ "$(( $([ "_${header_18322}" != "_" ]; echo $?) || ret_has_ansi_escape2012_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2013_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1988_v0__35_111}"; fi)"
    xyl_confirm__2180_v0 "${display_header_18394}" "${default_yes_18323}"
    local result_18491="${ret_xyl_confirm2180_v0}"
    ret_execute_confirm2338_v0="$(if [ "${result_18491}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2456_v0() {
    local format_27901="${1}"
    local args_27902=("${!2}")
    args_27902=("${format_27901}" "${args_27902[@]}")
    __status=$?
    printf "${args_27902[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2457_v0() {
    local message_27899="${1}"
    local color_27900="${2}"
    # Prints an error message with a specified color.
    local array_424=("${message_27899}")
    eprintf__2456_v0 "\\x1b[${color_27900}m%s\\x1b[0m" array_424[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2472_v0() {
    local format_27931="${1}"
    local args_27932=("${!2}")
    args_27932=("${format_27931}" "${args_27932[@]}")
    __status=$?
    printf "${args_27932[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_112="None"
# perl_available()
perl_available__2479_v0() {
    if [ "$([ "_${_perl_state_112}" != "_None" ]; echo $?)" != 0 ]; then
        local command_425
        command_425="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27841
        disabled_27841="$([ "_${command_425}" != "_No" ]; echo $?)"
        local command_426
        command_426="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27842
        found_27842="$(( $(( ! disabled_27841 )) && $([ "_${command_426}" != "_0" ]; echo $?) ))"
        _perl_state_112="$(if [ "${found_27842}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2479_v0="$([ "_${_perl_state_112}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2480_v0() {
    local text_27840="${1}"
    perl_available__2479_v0 
    local ret_perl_available2479_v0__22_12="${ret_perl_available2479_v0}"
    if [ "$(( ! ret_perl_available2479_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2480_v0=''
        return 1
    fi
    local command_427
    command_427="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27840}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2480_v0=''
        return "${__status}"
    fi
    local width_str_27843="${command_427}"
    parse_int__13_v0 "${width_str_27843}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2480_v0=''
        return "${__status}"
    fi
    local width_27844="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2480_v0="${width_27844}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2485_v0() {
    local text_27833="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_428
    command_428="$([[ "${text_27833}" == *$'\x1b'* || "${text_27833}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27834="${command_428}"
    ret_has_ansi_escape2485_v0="$([ "_${has_escape_27834}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2487_v0() {
    local text_27836="${1}"
    local command_429
    command_429="$(printf "%s" "${text_27836}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2487_v0="${command_429}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2488_v0() {
    local text_27838="${1}"
    local command_430
    command_430="$(printf "%s" "${text_27838}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27839="${command_430}"
    ret_is_all_ascii2488_v0="$([ "_${result_27839}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2489_v0() {
    local text_27835="${1}"
    strip_ansi__2487_v0 "${text_27835}"
    local stripped_27837="${ret_strip_ansi2487_v0}"
    # Check if text is all ASCII
    is_all_ascii__2488_v0 "${stripped_27837}"
    local ret_is_all_ascii2488_v0__36_12="${ret_is_all_ascii2488_v0}"
    if [ "$(( ! ret_is_all_ascii2488_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2480_v0 "${stripped_27837}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_431="${stripped_27837}"
            ret_get_visible_len2489_v0="${#__length_431}"
            return 0
        fi
        ret_get_visible_len2489_v0="${ret_perl_get_cjk_width2480_v0}"
        return 0
    else
        local __length_432="${stripped_27837}"
        ret_get_visible_len2489_v0="${#__length_432}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_113=0
_term_size_114=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2495_v0() {
    local command_434
    command_434="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27907="${command_434}"
    parse_int__13_v0 "${count_27907}"
    __status=$?
    ret_stty_count2495_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2496_v0() {
    stty_count__2495_v0 
    local count_num_27908="${ret_stty_count2495_v0}"
    if [ "$(( count_num_27908 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_27908="$(( count_num_27908 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27908}
    __status=$?
}

# stty_unlock()
stty_unlock__2497_v0() {
    stty_count__2495_v0 
    local count_num_27929="${ret_stty_count2495_v0}"
    if [ "$(( count_num_27929 > 0 ))" != 0 ]; then
        count_num_27929="$(( count_num_27929 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27929}
        __status=$?
        if [ "$(( count_num_27929 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2498_v0() {
    local size_27824="${1}"
    if [ "$([ "_${size_27824}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2498_v0=0
        return 0
    fi
    split__4_v0 "${size_27824}" " "
    local parts_27825=("${ret_split4_v0[@]}")
    local __length_435=("${parts_27825[@]}")
    if [ "$(( ${#__length_435[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2498_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27825[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27825[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_114=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2498_v0=1
    return 0
}

# query_term_size()
query_term_size__2499_v0() {
    local command_437
    command_437="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27827="${command_437}"
    store_term_size__2498_v0 "${size_27827}"
    ret_query_term_size2499_v0="${ret_store_term_size2498_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2500_v0() {
    local command_438
    command_438="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27823="${command_438}"
    store_term_size__2498_v0 "${size_27823}"
    ret_stty_term_size2500_v0="${ret_store_term_size2498_v0}"
    return 0
}

# get_term_size()
get_term_size__2501_v0() {
    stty_term_size__2500_v0 
    local detected_27826="${ret_stty_term_size2500_v0}"
    if [ "$(( ! detected_27826 ))" != 0 ]; then
        query_term_size__2499_v0 
        detected_27826="${ret_query_term_size2499_v0}"
    fi
    _got_term_size_113=1
}

# term_width()
term_width__2503_v0() {
    if [ "$(( ! _got_term_size_113 ))" != 0 ]; then
        get_term_size__2501_v0 
    fi
    ret_term_width2503_v0="${_term_size_114[0]?"Index out of bounds (at src/./file/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__2507_v0() {
    local array_439=("")
    eprintf__2472_v0 "\\x1b[2K\\x1b[G" array_439[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__2515_v0() {
    local pieces_27822=("${!1}")
    term_width__2503_v0 
    local width_27828="${ret_term_width2503_v0}"
    local line_27829=""
    local line_len_27830=0
    for piece_27831 in "${pieces_27822[@]}"; do
        local __length_442="${piece_27831}"
        local piece_len_27832="${#__length_442}"
        has_ansi_escape__2485_v0 "${piece_27831}"
        local ret_has_ansi_escape2485_v0__186_12="${ret_has_ansi_escape2485_v0}"
        if [ "${ret_has_ansi_escape2485_v0__186_12}" != 0 ]; then
            get_visible_len__2489_v0 "${piece_27831}"
            piece_len_27832="${ret_get_visible_len2489_v0}"
        fi
        if [ "$([ "_${line_27829}" != "_" ]; echo $?)" != 0 ]; then
            line_27829="${piece_27831}"
            line_len_27830="${piece_len_27832}"
        elif [ "$(( $(( $(( line_len_27830 + 1 )) + piece_len_27832 )) > width_27828 ))" != 0 ]; then
            local array_443=()
            printf__128_v0 "${line_27829}""
" array_443[@]
            line_27829="${piece_27831}"
            line_len_27830="${piece_len_27832}"
        else
            line_27829+=" ""${piece_27831}"
            line_len_27830="$(( line_len_27830 + $(( 1 + piece_len_27832 )) ))"
        fi
    done
    if [ "$([ "_${line_27829}" == "_" ]; echo $?)" != 0 ]; then
        local array_444=()
        printf__128_v0 "${line_27829}""
" array_444[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_115=3
# get_directory_entries(path: Text)
get_directory_entries__2537_v0() {
    local path_27912="${1}"
    local __ls_path_445="${path_27912}"
    __ls_path_445="${__ls_path_445//\\/\\\\}"
    (( 1 )) && __ls_all_445="-A" || __ls_all_445=""
    (( 0 )) && __ls_rec_445="-R" || __ls_rec_445=""
    local __ls_445=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_445 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_445} ${__ls_rec_445} ${__ls_path_445}
    __status=$?
    );
    local names_27913=("${__ls_445[@]}")
    local command_446
    command_446="$(LC_ALL=C ls -lA "${path_27912}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_27914="${command_446}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_447
    command_447="$(LC_ALL=C ls -lA "${path_27912}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_27915="${command_447}"
    split__4_v0 "${types_output_27914}" "
"
    local types_27916=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_27915}" "
"
    local targets_27917=("${ret_split4_v0[@]}")
    local entries_27918=()
    local __range_start_27919=0
    local __length_449=("${names_27913[@]}")
    local __range_end_27919="${#__length_449[@]}"
    local __dir_27919=$(( ${__range_start_27919} <= ${__range_end_27919} ? 1 : -1 ))
    for (( i_27919=${__range_start_27919}; i_27919 * ${__dir_27919} < ${__range_end_27919} * ${__dir_27919}; i_27919+=${__dir_27919} )); do
        local array_450=("${names_27913[${i_27919}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_27918+=("${array_450[@]}")
        local array_451=("${types_27916[${i_27919}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_27918+=("${array_451[@]}")
        slice__24_v0 "${targets_27917[${i_27919}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_452=("${ret_slice24_v0__31_21}")
        entries_27918+=("${array_452[@]}")
done
    ret_get_directory_entries2537_v0=("${entries_27918[@]}")
    return 0
}

# get_cwd()
get_cwd__2538_v0() {
    local command_453
    command_453="$(pwd)"
    __status=$?
    ret_get_cwd2538_v0="${command_453}"
    return 0
}

# normalize_path(path: Text)
normalize_path__2539_v0() {
    local path_27910="${1}"
    local command_454
    command_454="$(cd "${path_27910}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_27911="${command_454}"
    if [ "$([ "_${normalized_27911}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path2539_v0="${path_27910}"
        return 0
    fi
    ret_normalize_path2539_v0="${normalized_27911}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__2540_v0() {
    local base_28094="${1}"
    local child_28095="${2}"
    if [ "$([ "_${base_28094}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join2540_v0="/""${child_28095}"
        return 0
    fi
    ret_path_join2540_v0="${base_28094}""/""${child_28095}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__2541_v0() {
    local path_28092="${1}"
    local command_455
    command_455="$(dirname "${path_28092}")"
    __status=$?
    local parent_28093="${command_455}"
    ret_get_parent_dir2541_v0="${parent_28093}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_117="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_118=0
_primary_color_119=(3 207 159 92)
_secondary_color_120=(3 118 206 94)
_accent_color_121=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__2552_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_27857="${ret_env_var_get120_v0}"
    _supports_truecolor_117="$(if [ "$([ "_${config_27857}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2552_v0="$([ "_${_supports_truecolor_117}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2553_v0() {
    local message_27852="${1}"
    local r_27853="${2}"
    local g_27854="${3}"
    local b_27855="${4}"
    local fallback_27856="${5}"
    if [ "$([ "_${_supports_truecolor_117}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2553_v0="\\x1b[38;2;${r_27853};${g_27854};${b_27855}m""${message_27852}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_117}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2552_v0 
        local ret_get_supports_truecolor2552_v0__45_17="${ret_get_supports_truecolor2552_v0}"
        if [ "${ret_get_supports_truecolor2552_v0__45_17}" != 0 ]; then
            ret_colored_rgb2553_v0="\\x1b[38;2;${r_27853};${g_27854};${b_27855}m""${message_27852}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27856 == 0 ))" != 0 ]; then
            ret_colored_rgb2553_v0="${message_27852}"
            return 0
        else
            ret_colored_rgb2553_v0="\\x1b[${fallback_27856}m""${message_27852}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27856 == 0 ))" != 0 ]; then
            ret_colored_rgb2553_v0="${message_27852}"
            return 0
        fi
        ret_colored_rgb2553_v0="\\x1b[${fallback_27856}m""${message_27852}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2555_v0() {
    if [ "$(( ! _got_xylitol_colors_118 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27846="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27846}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27846}" ";"
            local parts_27847=("${ret_split4_v0[@]}")
            local __length_459=("${parts_27847[@]}")
            if [ "$(( ${#__length_459[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27847[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27847[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27847[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27847[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_119=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_27848="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27848}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27848}" ";"
            local parts_27849=("${ret_split4_v0[@]}")
            local __length_461=("${parts_27849[@]}")
            if [ "$(( ${#__length_461[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27849[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27849[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27849[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27849[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_120=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_27850="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27850}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27850}" ";"
            local parts_27851=("${ret_split4_v0[@]}")
            local __length_463=("${parts_27851[@]}")
            if [ "$(( ${#__length_463[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27851[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27851[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27851[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27851[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2555_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_121=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_118=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2556_v0() {
    inner_get_xylitol_colors__2555_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_118=1
}

# colored_primary(message: Text)
colored_primary__2557_v0() {
    local message_27845="${1}"
    if [ "$(( ! _got_xylitol_colors_118 ))" != 0 ]; then
        get_xylitol_colors__2556_v0 
    fi
    colored_rgb__2553_v0 "${message_27845}" "${_primary_color_119[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_119[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_119[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_119[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2557_v0="${ret_colored_rgb2553_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2558_v0() {
    local message_27859="${1}"
    if [ "$(( ! _got_xylitol_colors_118 ))" != 0 ]; then
        get_xylitol_colors__2556_v0 
    fi
    colored_rgb__2553_v0 "${message_27859}" "${_secondary_color_120[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_120[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_120[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_120[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2558_v0="${ret_colored_rgb2553_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2559_v0() {
    local message_28027="${1}"
    if [ "$(( ! _got_xylitol_colors_118 ))" != 0 ]; then
        get_xylitol_colors__2556_v0 
    fi
    colored_rgb__2553_v0 "${message_28027}" "${_accent_color_121[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_121[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_121[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_121[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent2559_v0="${ret_colored_rgb2553_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# colored(message: Text, color: Int)
colored__2611_v0() {
    local message_27893="${1}"
    local color_27894="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2611_v0="\\x1b[${color_27894}m""${message_27893}""\\x1b[0m"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_125=0
_term_size_126=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__2651_v0() {
    local size_27872="${1}"
    if [ "$([ "_${size_27872}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2651_v0=0
        return 0
    fi
    split__4_v0 "${size_27872}" " "
    local parts_27873=("${ret_split4_v0[@]}")
    local __length_466=("${parts_27873[@]}")
    if [ "$(( ${#__length_466[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2651_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27873[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27873[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_126=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2651_v0=1
    return 0
}

# query_term_size()
query_term_size__2652_v0() {
    local command_468
    command_468="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27875="${command_468}"
    store_term_size__2651_v0 "${size_27875}"
    ret_query_term_size2652_v0="${ret_store_term_size2651_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2653_v0() {
    local command_469
    command_469="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27871="${command_469}"
    store_term_size__2651_v0 "${size_27871}"
    ret_stty_term_size2653_v0="${ret_store_term_size2651_v0}"
    return 0
}

# get_term_size()
get_term_size__2654_v0() {
    stty_term_size__2653_v0 
    local detected_27874="${ret_stty_term_size2653_v0}"
    if [ "$(( ! detected_27874 ))" != 0 ]; then
        query_term_size__2652_v0 
        detected_27874="${ret_query_term_size2652_v0}"
    fi
    _got_term_size_125=1
}

# term_width()
term_width__2656_v0() {
    if [ "$(( ! _got_term_size_125 ))" != 0 ]; then
        get_term_size__2654_v0 
    fi
    ret_term_width2656_v0="${_term_size_126[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# 
# The state sits at module level, so only one such widget may be open at a
# time. Reach it through `utils.ab` rather than importing this file directly:
# the compiler keys modules by the literal text of the import path, so a
# second spelling would hand that caller its own copy of these variables.
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2689_v0() {
    local pending_27890="${1}"
    local line_27891="${2}"
    local note_at_27892="${3}"
    if [ "$(( note_at_27892 < 0 ))" != 0 ]; then
        local array_471=()
        printf__128_v0 "${pending_27890}""${line_27891}""
" array_471[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27892 == 0 ))" != 0 ]; then
        colored__2611_v0 "${line_27891}" 90
        local ret_colored2611_v0__12_40="${ret_colored2611_v0}"
        local array_472=()
        printf__128_v0 "${pending_27890}""${ret_colored2611_v0__12_40}""
" array_472[@]
    else
        slice__24_v0 "${line_27891}" 0 "${note_at_27892}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27891}" "${note_at_27892}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2611_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2611_v0__13_58="${ret_colored2611_v0}"
        local array_473=()
        printf__128_v0 "${pending_27890}""${ret_slice24_v0__13_32}""${ret_colored2611_v0__13_58}""
" array_473[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2690_v0() {
    local names_27863=("${!1}")
    local texts_27864=("${!2}")
    local notes_27865=("${!3}")
    local min_name_width_27866="${4}"
    local __length_474=("${names_27863[@]}")
    local count_27867="${#__length_474[@]}"
    local name_width_27868="${min_name_width_27866}"
    local __range_start_27869=0
    local __range_end_27869="${count_27867}"
    local __dir_27869=$(( ${__range_start_27869} <= ${__range_end_27869} ? 1 : -1 ))
    for (( i_27869=${__range_start_27869}; i_27869 * ${__dir_27869} < ${__range_end_27869} * ${__dir_27869}; i_27869+=${__dir_27869} )); do
        local __length_475="${names_27863[${i_27869}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_27870="${#__length_475}"
        if [ "$(( width_27870 > name_width_27868 ))" != 0 ]; then
            name_width_27868="${width_27870}"
        fi
done
    term_width__2656_v0 
    local width_27876="${ret_term_width2656_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27877="$(( name_width_27868 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27878="$(( $(( width_27876 - indent_27877 )) < 24 ))"
    if [ "${stacked_27878}" != 0 ]; then
        indent_27877=6
    fi
    local avail_27879="$(( width_27876 - indent_27877 ))"
    rpad__28_v0 "" " " "${indent_27877}"
    local blank_27880="${ret_rpad28_v0}"
    local __range_start_27881=0
    local __range_end_27881="${count_27867}"
    local __dir_27881=$(( ${__range_start_27881} <= ${__range_end_27881} ? 1 : -1 ))
    for (( i_27881=${__range_start_27881}; i_27881 * ${__dir_27881} < ${__range_end_27881} * ${__dir_27881}; i_27881+=${__dir_27881} )); do
        local pending_27882="${blank_27880}"
        if [ "${stacked_27878}" != 0 ]; then
            local array_476=()
            printf__128_v0 "  ""${names_27863[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_476[@]
        else
            rpad__28_v0 "  ""${names_27863[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_27877}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_27882="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_27864[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_27883=("${ret_split4_v0__52_21[@]}")
        local __length_477=("${words_27883[@]}")
        local note_start_27884="${#__length_477[@]}"
        if [ "$([ "_${notes_27865[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_478="${notes_27865[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_478} > avail_27879 ))" != 0 ]; then
                split__4_v0 "${notes_27865[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_27883+=("${ret_split4_v0__58_26[@]}")
            else
                local array_479=("${notes_27865[${i_27881}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_27883+=("${array_479[@]}")
            fi
        fi
        local line_27885=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27886=-1
        local __range_start_27887=0
        local __length_480=("${words_27883[@]}")
        local __range_end_27887="${#__length_480[@]}"
        local __dir_27887=$(( ${__range_start_27887} <= ${__range_end_27887} ? 1 : -1 ))
        for (( j_27887=${__range_start_27887}; j_27887 * ${__dir_27887} < ${__range_end_27887} * ${__dir_27887}; j_27887+=${__dir_27887} )); do
            local word_27888="${words_27883[${j_27887}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_27889
            candidate_27889="$(if [ "$([ "_${line_27885}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27888}"; else echo "${line_27885}"" ""${word_27888}"; fi)"
            local __length_481="${candidate_27889}"
            if [ "$(( $(( ${#__length_481} > avail_27879 )) && $([ "_${line_27885}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2689_v0 "${pending_27882}" "${line_27885}" "${note_at_27886}"
                pending_27882="${blank_27880}"
                line_27885="${word_27888}"
                note_at_27886="$(if [ "$(( j_27887 >= note_start_27884 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27887 >= note_start_27884 )) && $(( note_at_27886 < 0 )) ))" != 0 ]; then
                    local __length_482="${candidate_27889}"
                    local __length_483="${word_27888}"
                    note_at_27886="$(( ${#__length_482} - ${#__length_483} ))"
                fi
                line_27885="${candidate_27889}"
            fi
done
        print_help_line__2689_v0 "${pending_27882}" "${line_27885}" "${note_at_27886}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__2798_v0() {
    local command_484
    command_484="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_28062="${command_484}"
    if [ "$([ "_${var_28062}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2798_v0="UP"
        return 0
    elif [ "$([ "_${var_28062}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2798_v0="DOWN"
        return 0
    elif [ "$([ "_${var_28062}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2798_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_28062}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2798_v0="LEFT"
        return 0
    elif [ "$([ "_${var_28062}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2798_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_28062}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2798_v0="INPUT"
        return 0
    else
        ret_get_key2798_v0="${var_28062}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2800_v0() {
    local format_27988="${1}"
    local args_27989=("${!2}")
    args_27989=("${format_27988}" "${args_27989[@]}")
    __status=$?
    printf "${args_27989[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2801_v0() {
    local message_27995="${1}"
    local color_27996="${2}"
    # Prints an error message with a specified color.
    local array_485=("${message_27995}")
    eprintf__2800_v0 "\\x1b[${color_27996}m%s\\x1b[0m" array_485[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2816_v0() {
    local format_27941="${1}"
    local args_27942=("${!2}")
    args_27942=("${format_27941}" "${args_27942[@]}")
    __status=$?
    printf "${args_27942[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_133=0
_term_size_134=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2839_v0() {
    local command_487
    command_487="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27939="${command_487}"
    parse_int__13_v0 "${count_27939}"
    __status=$?
    ret_stty_count2839_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2840_v0() {
    stty_count__2839_v0 
    local count_num_27940="${ret_stty_count2839_v0}"
    if [ "$(( count_num_27940 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_27940="$(( count_num_27940 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27940}
    __status=$?
}

# stty_unlock()
stty_unlock__2841_v0() {
    stty_count__2839_v0 
    local count_num_28089="${ret_stty_count2839_v0}"
    if [ "$(( count_num_28089 > 0 ))" != 0 ]; then
        count_num_28089="$(( count_num_28089 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28089}
        __status=$?
        if [ "$(( count_num_28089 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2842_v0() {
    local size_27944="${1}"
    if [ "$([ "_${size_27944}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2842_v0=0
        return 0
    fi
    split__4_v0 "${size_27944}" " "
    local parts_27945=("${ret_split4_v0[@]}")
    local __length_488=("${parts_27945[@]}")
    if [ "$(( ${#__length_488[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2842_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27945[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27945[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_134=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2842_v0=1
    return 0
}

# query_term_size()
query_term_size__2843_v0() {
    local command_490
    command_490="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27947="${command_490}"
    store_term_size__2842_v0 "${size_27947}"
    ret_query_term_size2843_v0="${ret_store_term_size2842_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2844_v0() {
    local command_491
    command_491="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27943="${command_491}"
    store_term_size__2842_v0 "${size_27943}"
    ret_stty_term_size2844_v0="${ret_store_term_size2842_v0}"
    return 0
}

# get_term_size()
get_term_size__2845_v0() {
    stty_term_size__2844_v0 
    local detected_27946="${ret_stty_term_size2844_v0}"
    if [ "$(( ! detected_27946 ))" != 0 ]; then
        query_term_size__2843_v0 
        detected_27946="${ret_query_term_size2843_v0}"
    fi
    _got_term_size_133=1
}

# term_width()
term_width__2847_v0() {
    if [ "$(( ! _got_term_size_133 ))" != 0 ]; then
        get_term_size__2845_v0 
    fi
    ret_term_width2847_v0="${_term_size_134[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__2848_v0() {
    if [ "$(( ! _got_term_size_133 ))" != 0 ]; then
        get_term_size__2845_v0 
    fi
    ret_term_height2848_v0="${_term_size_134[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2850_v0() {
    local cnt_28059="${1}"
    if [ "$(( cnt_28059 > 0 ))" != 0 ]; then
        local sequence_28060=""
        local __range_start_28061=0
        local __range_end_28061="${cnt_28059}"
        local __dir_28061=$(( ${__range_start_28061} <= ${__range_end_28061} ? 1 : -1 ))
        for (( ____28061=${__range_start_28061}; ____28061 * ${__dir_28061} < ${__range_end_28061} * ${__dir_28061}; ____28061+=${__dir_28061} )); do
            sequence_28060+="\\x1b[2K\\x1b[1A"
done
        local array_492=("")
        eprintf__2816_v0 "${sequence_28060}" array_492[@]
    fi
    local array_493=("")
    eprintf__2816_v0 "\\x1b[G" array_493[@]
}

# remove_current_line()
remove_current_line__2851_v0() {
    local array_494=("")
    eprintf__2816_v0 "\\x1b[2K\\x1b[G" array_494[@]
}

# print_blank(cnt: Int)
print_blank__2852_v0() {
    local cnt_28050="${1}"
    printf '%*s' "${cnt_28050}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2853_v0() {
    local cnt_27993="${1}"
    local __range_start_27994=0
    local __range_end_27994="${cnt_27993}"
    local __dir_27994=$(( ${__range_start_27994} <= ${__range_end_27994} ? 1 : -1 ))
    for (( ____27994=${__range_start_27994}; ____27994 * ${__dir_27994} < ${__range_end_27994} * ${__dir_27994}; ____27994+=${__dir_27994} )); do
        local array_495=("")
        eprintf__2816_v0 "
" array_495[@]
done
}

# go_up(cnt: Int)
go_up__2854_v0() {
    local cnt_28016="${1}"
    local array_496=("")
    eprintf__2816_v0 "\\x1b[${cnt_28016}A" array_496[@]
}

# go_down(cnt: Int)
go_down__2855_v0() {
    local cnt_28088="${1}"
    local array_497=("")
    eprintf__2816_v0 "\\x1b[${cnt_28088}B" array_497[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__2857_v0() {
    local array_498=("")
    eprintf__2816_v0 "\\x1b[?25l" array_498[@]
}

# show_cursor()
show_cursor__2858_v0() {
    local array_499=("")
    eprintf__2816_v0 "\\x1b[?25h" array_499[@]
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_137="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_138=0
_secondary_color_140=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2896_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_28049="${ret_env_var_get120_v0}"
    _supports_truecolor_137="$(if [ "$([ "_${config_28049}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2896_v0="$([ "_${_supports_truecolor_137}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2897_v0() {
    local message_28044="${1}"
    local r_28045="${2}"
    local g_28046="${3}"
    local b_28047="${4}"
    local fallback_28048="${5}"
    if [ "$([ "_${_supports_truecolor_137}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2897_v0="\\x1b[38;2;${r_28045};${g_28046};${b_28047}m""${message_28044}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_137}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2896_v0 
        local ret_get_supports_truecolor2896_v0__45_17="${ret_get_supports_truecolor2896_v0}"
        if [ "${ret_get_supports_truecolor2896_v0__45_17}" != 0 ]; then
            ret_colored_rgb2897_v0="\\x1b[38;2;${r_28045};${g_28046};${b_28047}m""${message_28044}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_28048 == 0 ))" != 0 ]; then
            ret_colored_rgb2897_v0="${message_28044}"
            return 0
        else
            ret_colored_rgb2897_v0="\\x1b[${fallback_28048}m""${message_28044}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_28048 == 0 ))" != 0 ]; then
            ret_colored_rgb2897_v0="${message_28044}"
            return 0
        fi
        ret_colored_rgb2897_v0="\\x1b[${fallback_28048}m""${message_28044}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2899_v0() {
    if [ "$(( ! _got_xylitol_colors_138 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_28038="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_28038}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_28038}" ";"
            local parts_28039=("${ret_split4_v0[@]}")
            local __length_503=("${parts_28039[@]}")
            if [ "$(( ${#__length_503[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28039[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28039[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28039[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28039[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_28040="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_28040}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_28040}" ";"
            local parts_28041=("${ret_split4_v0[@]}")
            local __length_505=("${parts_28041[@]}")
            if [ "$(( ${#__length_505[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28041[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28041[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28041[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28041[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_140=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_28042="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_28042}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_28042}" ";"
            local parts_28043=("${ret_split4_v0[@]}")
            local __length_507=("${parts_28043[@]}")
            if [ "$(( ${#__length_507[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28043[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28043[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28043[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28043[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2899_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_138=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2900_v0() {
    inner_get_xylitol_colors__2899_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_138=1
}

# colored_secondary(message: Text)
colored_secondary__2902_v0() {
    local message_28037="${1}"
    if [ "$(( ! _got_xylitol_colors_138 ))" != 0 ]; then
        get_xylitol_colors__2900_v0 
    fi
    colored_rgb__2897_v0 "${message_28037}" "${_secondary_color_140[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_140[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_140[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_140[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2902_v0="${ret_colored_rgb2897_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_142="None"
# perl_available()
perl_available__2919_v0() {
    if [ "$([ "_${_perl_state_142}" != "_None" ]; echo $?)" != 0 ]; then
        local command_509
        command_509="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27958
        disabled_27958="$([ "_${command_509}" != "_No" ]; echo $?)"
        local command_510
        command_510="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27959
        found_27959="$(( $(( ! disabled_27958 )) && $([ "_${command_510}" != "_0" ]; echo $?) ))"
        _perl_state_142="$(if [ "${found_27959}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2919_v0="$([ "_${_perl_state_142}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2920_v0() {
    local text_27957="${1}"
    perl_available__2919_v0 
    local ret_perl_available2919_v0__22_12="${ret_perl_available2919_v0}"
    if [ "$(( ! ret_perl_available2919_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2920_v0=''
        return 1
    fi
    local command_511
    command_511="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27957}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2920_v0=''
        return "${__status}"
    fi
    local width_str_27960="${command_511}"
    parse_int__13_v0 "${width_str_27960}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2920_v0=''
        return "${__status}"
    fi
    local width_27961="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2920_v0="${width_27961}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2921_v0() {
    local text_27970="${1}"
    local max_width_27971="${2}"
    perl_available__2919_v0 
    local ret_perl_available2919_v0__33_12="${ret_perl_available2919_v0}"
    if [ "$(( ! ret_perl_available2919_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2921_v0=''
        return 1
    fi
    local command_512
    command_512="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27970}" ${max_width_27971} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2921_v0=''
        return "${__status}"
    fi
    local result_27972="${command_512}"
    ret_perl_truncate_cjk2921_v0="${result_27972}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2925_v0() {
    local text_27965="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_513
    command_513="$([[ "${text_27965}" == *$'\x1b'* || "${text_27965}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27966="${command_513}"
    ret_has_ansi_escape2925_v0="$([ "_${has_escape_27966}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2927_v0() {
    local text_27953="${1}"
    local command_514
    command_514="$(printf "%s" "${text_27953}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2927_v0="${command_514}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2928_v0() {
    local text_27955="${1}"
    local command_515
    command_515="$(printf "%s" "${text_27955}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27956="${command_515}"
    ret_is_all_ascii2928_v0="$([ "_${result_27956}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2929_v0() {
    local text_27952="${1}"
    strip_ansi__2927_v0 "${text_27952}"
    local stripped_27954="${ret_strip_ansi2927_v0}"
    # Check if text is all ASCII
    is_all_ascii__2928_v0 "${stripped_27954}"
    local ret_is_all_ascii2928_v0__36_12="${ret_is_all_ascii2928_v0}"
    if [ "$(( ! ret_is_all_ascii2928_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2920_v0 "${stripped_27954}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_516="${stripped_27954}"
            ret_get_visible_len2929_v0="${#__length_516}"
            return 0
        fi
        ret_get_visible_len2929_v0="${ret_perl_get_cjk_width2920_v0}"
        return 0
    else
        local __length_517="${stripped_27954}"
        ret_get_visible_len2929_v0="${#__length_517}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2930_v0() {
    local text_27967="${1}"
    local max_width_27968="${2}"
    get_visible_len__2929_v0 "${text_27967}"
    local visible_len_27969="${ret_get_visible_len2929_v0}"
    if [ "$(( visible_len_27969 <= max_width_27968 ))" != 0 ]; then
        ret_truncate_text2930_v0="${text_27967}"
        return 0
    fi
    is_all_ascii__2928_v0 "${text_27967}"
    local ret_is_all_ascii2928_v0__53_12="${ret_is_all_ascii2928_v0}"
    if [ "$(( ! ret_is_all_ascii2928_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__2921_v0 "${text_27967}" "${max_width_27968}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27967}" | cut -c1-${max_width_27968}
            __status=$?
        fi
        ret_truncate_text2930_v0="${ret_perl_truncate_cjk2921_v0}"
        return 0
    fi
    local command_518
    command_518="$(printf "%s" "${text_27967}" | cut -c1-${max_width_27968})"
    __status=$?
    ret_truncate_text2930_v0="${command_518}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2931_v0() {
    local text_27963="${1}"
    local max_width_27964="${2}"
    has_ansi_escape__2925_v0 "${text_27963}"
    local ret_has_ansi_escape2925_v0__65_12="${ret_has_ansi_escape2925_v0}"
    if [ "$(( ! ret_has_ansi_escape2925_v0__65_12 ))" != 0 ]; then
        truncate_text__2930_v0 "${text_27963}" "${max_width_27964}"
        ret_truncate_ansi2931_v0="${ret_truncate_text2930_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_519
    command_519="$([[ "${text_27963}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27973="${command_519}"
    # Replace \x1b[ with newline, then split
    local command_520
    command_520="$(t="${text_27963}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27974="${command_520}"
    split__4_v0 "${replaced_27974}" "
"
    local parts_27975=("${ret_split4_v0[@]}")
    local result_27976=""
    local remaining_width_27977="${max_width_27964}"
    local __range_start_27978=0
    local __length_521=("${parts_27975[@]}")
    local __range_end_27978="${#__length_521[@]}"
    local __dir_27978=$(( ${__range_start_27978} <= ${__range_end_27978} ? 1 : -1 ))
    for (( idx_27978=${__range_start_27978}; idx_27978 * ${__dir_27978} < ${__range_end_27978} * ${__dir_27978}; idx_27978+=${__dir_27978} )); do
        local part_27979="${parts_27975[${idx_27978}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27978 == 0 )) && $([ "_${starts_with_ansi_27973}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27979}" == "_" ]; echo $?) && $(( remaining_width_27977 > 0 )) ))" != 0 ]; then
                truncate_text__2930_v0 "${part_27979}" "${remaining_width_27977}"
                local ret_truncate_text2930_v0__87_35="${ret_truncate_text2930_v0}"
                local truncated_27980="${ret_truncate_text2930_v0__87_35}"
                result_27976+="${truncated_27980}"
                get_visible_len__2929_v0 "${truncated_27980}"
                local ret_get_visible_len2929_v0__89_36="${ret_get_visible_len2929_v0}"
                remaining_width_27977="$(( remaining_width_27977 - ret_get_visible_len2929_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_522
            command_522="$(__p="${part_27979}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27981="${command_522}"
            if [ "$([ "_${m_idx_27981}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_523
                command_523="$(__p="${part_27979}"; printf "%s" "${__p:0:${m_idx_27981}}")"
                __status=$?
                local ansi_params_27982="${command_523}"
                result_27976+="\\x1b[""${ansi_params_27982}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27981}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_27983="${ret_parse_int13_v0__100_41}"
                local text_start_27984="$(( m_idx_num_27983 + 1 ))"
                local command_524
                command_524="$(__p="${part_27979}"; printf "%s" "${__p:${text_start_27984}}")"
                __status=$?
                local text_part_27985="${command_524}"
                if [ "$(( $([ "_${text_part_27985}" == "_" ]; echo $?) && $(( remaining_width_27977 > 0 )) ))" != 0 ]; then
                    truncate_text__2930_v0 "${text_part_27985}" "${remaining_width_27977}"
                    local ret_truncate_text2930_v0__104_39="${ret_truncate_text2930_v0}"
                    local truncated_27986="${ret_truncate_text2930_v0__104_39}"
                    result_27976+="${truncated_27986}"
                    get_visible_len__2929_v0 "${truncated_27986}"
                    local ret_get_visible_len2929_v0__106_40="${ret_get_visible_len2929_v0}"
                    remaining_width_27977="$(( remaining_width_27977 - ret_get_visible_len2929_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27979}" == "_" ]; echo $?) && $(( remaining_width_27977 > 0 )) ))" != 0 ]; then
                    truncate_text__2930_v0 "${part_27979}" "${remaining_width_27977}"
                    local ret_truncate_text2930_v0__111_39="${ret_truncate_text2930_v0}"
                    local truncated_27987="${ret_truncate_text2930_v0__111_39}"
                    result_27976+="${truncated_27987}"
                    get_visible_len__2929_v0 "${truncated_27987}"
                    local ret_get_visible_len2929_v0__113_40="${ret_get_visible_len2929_v0}"
                    remaining_width_27977="$(( remaining_width_27977 - ret_get_visible_len2929_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2931_v0="${result_27976}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2932_v0() {
    local text_27950="${1}"
    local max_width_27951="${2}"
    get_visible_len__2929_v0 "${text_27950}"
    local visible_len_27962="${ret_get_visible_len2929_v0}"
    if [ "$(( visible_len_27962 <= max_width_27951 ))" != 0 ]; then
        ret_cutoff_text2932_v0="${text_27950}"
        return 0
    fi
    truncate_ansi__2931_v0 "${text_27950}" "$(( max_width_27951 - 3 ))"
    local ret_truncate_ansi2931_v0__129_12="${ret_truncate_ansi2931_v0}"
    ret_cutoff_text2932_v0="${ret_truncate_ansi2931_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__2953_v0() {
    local format_28005="${1}"
    local args_28006=("${!2}")
    args_28006=("${format_28005}" "${args_28006[@]}")
    __status=$?
    printf "${args_28006[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2954_v0() {
    local message_28003="${1}"
    local color_28004="${2}"
    # Prints an error message with a specified color.
    local array_525=("${message_28003}")
    eprintf__2953_v0 "\\x1b[${color_28004}m%s\\x1b[0m" array_525[@]
}

# colored(message: Text, color: Int)
colored__2955_v0() {
    local message_28007="${1}"
    local color_28008="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2955_v0="\\x1b[${color_28008}m""${message_28007}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2959_v0() {
    local items_27997=("${!1}")
    local total_len_27998="${2}"
    local term_width_27999="${3}"
    local separator_28000=" • "
    local separator_len_28001=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27998 <= term_width_27999 ))" != 0 ]; then
        local iter_28002=0
        while :
        do
            local __length_526=("${items_27997[@]}")
            if [ "$(( iter_28002 >= ${#__length_526[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_28002 > 0 ))" != 0 ]; then
                eprintf_colored__2954_v0 "${separator_28000}" 90
            fi
            colored__2955_v0 "${items_27997[$(( iter_28002 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2955_v0__23_41="${ret_colored2955_v0}"
            local array_527=("")
            eprintf__2953_v0 "${items_27997[${iter_28002}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2955_v0__23_41}" array_527[@]
            iter_28002="$(( iter_28002 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_28009=0
        local first_28010=1
        local iter_28011=0
        while :
        do
            local __length_528=("${items_27997[@]}")
            if [ "$(( iter_28011 >= ${#__length_528[@]} ))" != 0 ]; then
                break
            fi
            local key_28012="${items_27997[${iter_28011}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_28013="${items_27997[$(( iter_28011 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_529="${key_28012}"
            local __length_530="${action_28013}"
            local part_len_28014="$(( $(( ${#__length_529} + 1 )) + ${#__length_530} ))"
            local needed_28015="${part_len_28014}"
            if [ "$(( ! first_28010 ))" != 0 ]; then
                needed_28015="$(( needed_28015 + separator_len_28001 ))"
            fi
            if [ "$(( $(( current_len_28009 + needed_28015 )) > term_width_27999 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_28010 ))" != 0 ]; then
                eprintf_colored__2954_v0 "${separator_28000}" 90
            fi
            colored__2955_v0 "${action_28013}" 2
            local ret_colored2955_v0__51_33="${ret_colored2955_v0}"
            local array_531=("")
            eprintf__2953_v0 "${key_28012}"" ""${ret_colored2955_v0__51_33}" array_531[@]
            current_len_28009="$(( current_len_28009 + needed_28015 ))"
            first_28010=0
            iter_28011="$(( iter_28011 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2969_v0() {
    local format_28076="${1}"
    local args_28077=("${!2}")
    args_28077=("${format_28076}" "${args_28077[@]}")
    __status=$?
    printf "${args_28077[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# // Cursor /////
# go_up(cnt: Int)
go_up__3007_v0() {
    local cnt_28075="${1}"
    local array_533=("")
    eprintf__2969_v0 "\\x1b[${cnt_28075}A" array_533[@]
}

# go_down(cnt: Int)
go_down__3008_v0() {
    local cnt_28078="${1}"
    local array_534=("")
    eprintf__2969_v0 "\\x1b[${cnt_28078}B" array_534[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3015_v0() {
    local display_count_28072="${1}"
    local index_28073="${2}"
    local line_28074="${3}"
    go_up__3007_v0 "$(( display_count_28072 - index_28073 ))"
    local array_535=("")
    eprintf__2953_v0 "\\x1b[G\\x1b[K" array_535[@]
    local array_536=("")
    eprintf__2953_v0 "${line_28074}" array_536[@]
    go_down__3008_v0 "$(( display_count_28072 - index_28073 ))"
    local array_537=("")
    eprintf__2953_v0 "\\x1b[G" array_537[@]
}

# Which items of a multi-select widget are ticked.
# 
# The state sits at module level, so only one such widget may be open at a
# time. Reach it through `utils.ab` rather than importing this file directly:
# the compiler keys modules by the literal text of the import path, so a
# second spelling would hand that caller its own copy of these variables.
_checked_147=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list.
_count_148=0
_total_149=0
_limit_150=-1
# checked_init(total: Int, limit: Int)
checked_init__3017_v0() {
    local total_27990="${1}"
    local limit_27991="${2}"
    _checked_147=()
    local __range_start_27992=0
    local __range_end_27992="${total_27990}"
    local __dir_27992=$(( ${__range_start_27992} <= ${__range_end_27992} ? 1 : -1 ))
    for (( ____27992=${__range_start_27992}; ____27992 * ${__dir_27992} < ${__range_end_27992} * ${__dir_27992}; ____27992+=${__dir_27992} )); do
        local array_540=(0)
        _checked_147+=("${array_540[@]}")
done
    _count_148=0
    _total_149="${total_27990}"
    _limit_150="${limit_27991}"
}

# checked_is(index: Int)
checked_is__3018_v0() {
    local index_28034="${1}"
    ret_checked_is3018_v0="${_checked_147[${index_28034}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:26:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3020_v0() {
    local index_28067="${1}"
    if [ "${_checked_147[${index_28067}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:36:17)"}" != 0 ]; then
        _checked_147["${index_28067}"]=0
        _count_148="$(( _count_148 - 1 ))"
        ret_checked_toggle3020_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_150 >= 0 )) && $(( _count_148 >= _limit_150 )) ))" != 0 ]; then
        ret_checked_toggle3020_v0=0
        return 0
    fi
    _checked_147["${index_28067}"]=1
    _count_148="$(( _count_148 + 1 ))"
    ret_checked_toggle3020_v0=1
    return 0
}

# checked_all()
checked_all__3021_v0() {
    if [ "$(( _limit_150 >= 0 ))" != 0 ]; then
        ret_checked_all3021_v0=0
        return 0
    fi
    local was_all_28079="$(( _count_148 == _total_149 ))"
    local __range_start_28080=0
    local __range_end_28080="${_total_149}"
    local __dir_28080=$(( ${__range_start_28080} <= ${__range_end_28080} ? 1 : -1 ))
    for (( i_28080=${__range_start_28080}; i_28080 * ${__dir_28080} < ${__range_end_28080} * ${__dir_28080}; i_28080+=${__dir_28080} )); do
        _checked_147["${i_28080}"]="$(( ! was_all_28079 ))"
done
    if [ "${was_all_28079}" != 0 ]; then
        _count_148=0
    else
        _count_148="${_total_149}"
    fi
    ret_checked_all3021_v0=1
    return 0
}

# Facade over the helper modules, so every caller keeps importing one path.
# A chooser driven by its caller.
# 
# Amber has no callbacks, so the engine cannot ask for an item's text on its
# own. The caller runs the loop instead and hands over one page of labels at
# a time, which is what lets it build them lazily. `xyl_choose` and
# `xyl_file` show the shape of that loop.
# 
# Only the engine writes to the terminal; callers just produce text.
# `chooser_step` handled the key and redrew whatever changed.
__CHOOSER_CONTINUE_152=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_153=1
# The user confirmed the selection.
__CHOOSER_DONE_154=2
_total_155=0
_page_size_156=10
_display_count_157=0
_total_pages_158=1
_current_page_159=0
_selected_160=0
_cursor_161="> "
_multi_162=0
_limit_163=-1
_term_width_164=80
_has_header_165=0
_page_166=()
_page_count_167=0
_first_render_168=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_169=0
# render_single_page()
render_single_page__3092_v0() {
    local __length_542="${_cursor_161}"
    local cursor_len_28053="${#__length_542}"
    local max_option_width_28054="$(( $(( _term_width_164 - cursor_len_28053 )) - 1 ))"
    local __range_start_28055=0
    local __range_end_28055="${_page_count_167}"
    local __dir_28055=$(( ${__range_start_28055} <= ${__range_end_28055} ? 1 : -1 ))
    for (( i_28055=${__range_start_28055}; i_28055 * ${__dir_28055} < ${__range_end_28055} * ${__dir_28055}; i_28055+=${__dir_28055} )); do
        cutoff_text__2932_v0 "${_page_166[${i_28055}]?"Index out of bounds (at src/./file/../choose/engine.ab:45:45)"}" "${max_option_width_28054}"
        local ret_cutoff_text2932_v0__45_27="${ret_cutoff_text2932_v0}"
        local truncated_28056="${ret_cutoff_text2932_v0__45_27}"
        if [ "$(( i_28055 == _selected_160 ))" != 0 ]; then
            colored_secondary__2902_v0 "${_cursor_161}""${truncated_28056}""
"
            local ret_colored_secondary2902_v0__47_21="${ret_colored_secondary2902_v0}"
            local array_543=("")
            eprintf__2800_v0 "${ret_colored_secondary2902_v0__47_21}" array_543[@]
        else
            print_blank__2852_v0 "${cursor_len_28053}"
            local array_544=("")
            eprintf__2800_v0 "${truncated_28056}""
" array_544[@]
        fi
done
    local remaining_slots_28057="$(( _display_count_157 - _page_count_167 ))"
    if [ "$(( remaining_slots_28057 > 0 ))" != 0 ]; then
        local __range_start_28058=0
        local __range_end_28058="${remaining_slots_28057}"
        local __dir_28058=$(( ${__range_start_28058} <= ${__range_end_28058} ? 1 : -1 ))
        for (( ____28058=${__range_start_28058}; ____28058 * ${__dir_28058} < ${__range_end_28058} * ${__dir_28058}; ____28058+=${__dir_28058} )); do
            local array_545=("")
            eprintf__2800_v0 "\\x1b[K
" array_545[@]
done
    fi
}

# render_multi_page()
render_multi_page__3093_v0() {
    local __length_546="${_cursor_161}"
    local cursor_len_28029="${#__length_546}"
    local max_option_width_28030="$(( $(( _term_width_164 - cursor_len_28029 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3098_v0 
    local page_start_28031="${ret_chooser_page_start3098_v0}"
    local __range_start_28032=0
    local __range_end_28032="${_page_count_167}"
    local __dir_28032=$(( ${__range_start_28032} <= ${__range_end_28032} ? 1 : -1 ))
    for (( i_28032=${__range_start_28032}; i_28032 * ${__dir_28032} < ${__range_end_28032} * ${__dir_28032}; i_28032+=${__dir_28032} )); do
        local global_idx_28033="$(( page_start_28031 + i_28032 ))"
        checked_is__3018_v0 "${global_idx_28033}"
        local ret_checked_is3018_v0__67_28="${ret_checked_is3018_v0}"
        local check_mark_28035
        check_mark_28035="$(if [ "${ret_checked_is3018_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2932_v0 "${_page_166[${i_28032}]?"Index out of bounds (at src/./file/../choose/engine.ab:68:45)"}" "${max_option_width_28030}"
        local ret_cutoff_text2932_v0__68_27="${ret_cutoff_text2932_v0}"
        local truncated_28036="${ret_cutoff_text2932_v0__68_27}"
        checked_is__3018_v0 "${global_idx_28033}"
        local ret_checked_is3018_v0__71_13="${ret_checked_is3018_v0}"
        if [ "$(( i_28032 == _selected_160 ))" != 0 ]; then
            colored_secondary__2902_v0 "${_cursor_161}""${check_mark_28035}""${truncated_28036}""
"
            local ret_colored_secondary2902_v0__70_37="${ret_colored_secondary2902_v0}"
            local array_547=("")
            eprintf__2800_v0 "${ret_colored_secondary2902_v0__70_37}" array_547[@]
        elif [ "${ret_checked_is3018_v0__71_13}" != 0 ]; then
            print_blank__2852_v0 "${cursor_len_28029}"
            colored_secondary__2902_v0 "${check_mark_28035}""${truncated_28036}""
"
            local ret_colored_secondary2902_v0__73_25="${ret_colored_secondary2902_v0}"
            local array_548=("")
            eprintf__2800_v0 "${ret_colored_secondary2902_v0__73_25}" array_548[@]
        else
            print_blank__2852_v0 "${cursor_len_28029}"
            local array_549=("")
            eprintf__2800_v0 "${check_mark_28035}""${truncated_28036}""
" array_549[@]
        fi
done
    local remaining_slots_28051="$(( _display_count_157 - _page_count_167 ))"
    if [ "$(( remaining_slots_28051 > 0 ))" != 0 ]; then
        local __range_start_28052=0
        local __range_end_28052="${remaining_slots_28051}"
        local __dir_28052=$(( ${__range_start_28052} <= ${__range_end_28052} ? 1 : -1 ))
        for (( ____28052=${__range_start_28052}; ____28052 * ${__dir_28052} < ${__range_end_28052} * ${__dir_28052}; ____28052+=${__dir_28052} )); do
            local array_550=("")
            eprintf__2800_v0 "\\x1b[K
" array_550[@]
done
    fi
}

# render_page()
render_page__3094_v0() {
    if [ "${_multi_162}" != 0 ]; then
        render_multi_page__3093_v0 
    else
        render_single_page__3092_v0 
    fi
}

# render_page_indicator()
render_page_indicator__3095_v0() {
    if [ "$(( _total_pages_158 > 1 ))" != 0 ]; then
        local array_551=("")
        eprintf__2800_v0 "\\x1b[G\\x1b[K" array_551[@]
        eprintf_colored__2801_v0 "Page $(( _current_page_159 + 1 ))/${_total_pages_158}" 90
        local array_552=("")
        eprintf__2800_v0 "\\x1b[G" array_552[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__3096_v0() {
    if [ "$(( ! _multi_162 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_158 > 1 ))" != 0 ]; then
            local array_553=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2959_v0 array_553[@] 36 "${_term_width_164}"
        else
            local array_554=("↑↓" "select" "enter" "confirm")
            render_tooltip__2959_v0 array_554[@] 25 "${_term_width_164}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_158 > 1 )) && $(( _limit_163 < 0 )) ))" != 0 ]; then
            local array_555=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2959_v0 array_555[@] 55 "${_term_width_164}"
        elif [ "$(( _total_pages_158 > 1 ))" != 0 ]; then
            local array_556=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2959_v0 array_556[@] 47 "${_term_width_164}"
        elif [ "$(( _limit_163 < 0 ))" != 0 ]; then
            local array_557=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2959_v0 array_557[@] 44 "${_term_width_164}"
        else
            local array_558=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2959_v0 array_558[@] 36 "${_term_width_164}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__3097_v0() {
    local total_27933="${1}"
    local page_size_27934="${2}"
    local header_27935="${3}"
    local cursor_27936="${4}"
    local multi_27937="${5}"
    local limit_27938="${6}"
    _total_155="${total_27933}"
    _cursor_161="${cursor_27936}"
    _multi_162="${multi_27937}"
    _limit_163="${limit_27938}"
    _current_page_159=0
    _selected_160=0
    _first_render_168=1
    _up_paged_169=0
    _has_header_165="$([ "_${header_27935}" == "_" ]; echo $?)"
    stty_lock__2840_v0 
    hide_cursor__2857_v0 
    term_width__2847_v0 
    _term_width_164="${ret_term_width2847_v0}"
    term_height__2848_v0 
    local term_height_27948="${ret_term_height2848_v0}"
    local max_page_size_27949
    max_page_size_27949="$(( term_height_27948 - $(if [ "${_has_header_165}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_156="${page_size_27934}"
    if [ "$(( _page_size_156 > max_page_size_27949 ))" != 0 ]; then
        _page_size_156="${max_page_size_27949}"
    fi
    if [ "${_has_header_165}" != 0 ]; then
        cutoff_text__2932_v0 "${header_27935}" "${_term_width_164}"
        local ret_cutoff_text2932_v0__153_17="${ret_cutoff_text2932_v0}"
        local array_559=("")
        eprintf__2800_v0 "${ret_cutoff_text2932_v0__153_17}""
" array_559[@]
    fi
    math_floor__633_v0 "$(( $(( $(( total_27933 + _page_size_156 )) - 1 )) / _page_size_156 ))"
    _total_pages_158="${ret_math_floor633_v0}"
    _display_count_157="${_page_size_156}"
    if [ "$(( total_27933 < _page_size_156 ))" != 0 ]; then
        _display_count_157="${total_27933}"
    fi
    if [ "${multi_27937}" != 0 ]; then
        checked_init__3017_v0 "${total_27933}" "${limit_27938}"
    fi
    new_line__2853_v0 "${_display_count_157}"
    local array_560=("")
    eprintf__2800_v0 "\\x1b[G" array_560[@]
    if [ "$(( _total_pages_158 > 1 ))" != 0 ]; then
        eprintf_colored__2801_v0 "Page $(( _current_page_159 + 1 ))/${_total_pages_158}" 90
    fi
    new_line__2853_v0 1
    render_tooltip_line__3096_v0 
    go_up__2854_v0 "$(( _display_count_157 + 1 ))"
    local array_561=("")
    eprintf__2800_v0 "\\x1b[G" array_561[@]
}

# chooser_page_start()
chooser_page_start__3098_v0() {
    ret_chooser_page_start3098_v0="$(( _current_page_159 * _page_size_156 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__3099_v0() {
    chooser_page_start__3098_v0 
    local start_28020="${ret_chooser_page_start3098_v0}"
    local end_28021="$(( start_28020 + _page_size_156 ))"
    if [ "$(( end_28021 > _total_155 ))" != 0 ]; then
        end_28021="${_total_155}"
    fi
    ret_chooser_page_count3099_v0="$(( end_28021 - start_28020 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3100_v0() {
    local page_28028=("${!1}")
    _page_166=("${page_28028[@]}")
    local __length_562=("${page_28028[@]}")
    _page_count_167="${#__length_562[@]}"
    if [ "${_first_render_168}" != 0 ]; then
        _first_render_168=0
        render_page__3094_v0 
    else
        if [ "${_up_paged_169}" != 0 ]; then
            _selected_160="$(( _page_count_167 - 1 ))"
            _up_paged_169=0
        fi
        go_up__2854_v0 1
        remove_line__2850_v0 "$(( _display_count_157 - 1 ))"
        remove_current_line__2851_v0 
        local array_563=("")
        eprintf__2800_v0 "\\x1b[G" array_563[@]
        render_page__3094_v0 
        render_page_indicator__3095_v0 
    fi
}

# option_width()
option_width__3101_v0() {
    local check_width_28069
    check_width_28069="$(if [ "${_multi_162}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_564="${_cursor_161}"
    ret_option_width3101_v0="$(( $(( _term_width_164 - ${#__length_564} )) - check_width_28069 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3102_v0() {
    local index_28082="${1}"
    local __length_565="${_cursor_161}"
    rpad__28_v0 "" " " "${#__length_565}"
    local blank_28083="${ret_rpad28_v0}"
    option_width__3101_v0 
    local ret_option_width3101_v0__224_49="${ret_option_width3101_v0}"
    cutoff_text__2932_v0 "${_page_166[${index_28082}]?"Index out of bounds (at src/./file/../choose/engine.ab:224:41)"}" "${ret_option_width3101_v0__224_49}"
    local truncated_28084="${ret_cutoff_text2932_v0}"
    if [ "$(( ! _multi_162 ))" != 0 ]; then
        ret_unselected_line3102_v0="${blank_28083}""${truncated_28084}"
        return 0
    fi
    chooser_page_start__3098_v0 
    local ret_chooser_page_start3098_v0__228_19="${ret_chooser_page_start3098_v0}"
    checked_is__3018_v0 "$(( ret_chooser_page_start3098_v0__228_19 + index_28082 ))"
    local ret_checked_is3018_v0__228_8="${ret_checked_is3018_v0}"
    if [ "${ret_checked_is3018_v0__228_8}" != 0 ]; then
        colored_secondary__2902_v0 "✓ ""${truncated_28084}"
        local ret_colored_secondary2902_v0__229_24="${ret_colored_secondary2902_v0}"
        ret_unselected_line3102_v0="${blank_28083}""${ret_colored_secondary2902_v0__229_24}"
        return 0
    fi
    ret_unselected_line3102_v0="${blank_28083}""• ""${truncated_28084}"
    return 0
}

# selected_line(index: Int)
selected_line__3103_v0() {
    local index_28068="${1}"
    option_width__3101_v0 
    local ret_option_width3101_v0__236_49="${ret_option_width3101_v0}"
    cutoff_text__2932_v0 "${_page_166[${index_28068}]?"Index out of bounds (at src/./file/../choose/engine.ab:236:41)"}" "${ret_option_width3101_v0__236_49}"
    local truncated_28070="${ret_cutoff_text2932_v0}"
    if [ "$(( ! _multi_162 ))" != 0 ]; then
        colored_secondary__2902_v0 "${_cursor_161}""${truncated_28070}"
        ret_selected_line3103_v0="${ret_colored_secondary2902_v0}"
        return 0
    fi
    chooser_page_start__3098_v0 
    local ret_chooser_page_start3098_v0__240_29="${ret_chooser_page_start3098_v0}"
    checked_is__3018_v0 "$(( ret_chooser_page_start3098_v0__240_29 + index_28068 ))"
    local ret_checked_is3018_v0__240_18="${ret_checked_is3018_v0}"
    local mark_28071
    mark_28071="$(if [ "${ret_checked_is3018_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__2902_v0 "${_cursor_161}""${mark_28071}""${truncated_28070}"
    ret_selected_line3103_v0="${ret_colored_secondary2902_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3104_v0() {
    local prev_selected_28081="${1}"
    unselected_line__3102_v0 "${prev_selected_28081}"
    local ret_unselected_line3102_v0__247_47="${ret_unselected_line3102_v0}"
    redraw_row__3015_v0 "${_display_count_157}" "${prev_selected_28081}" "${ret_unselected_line3102_v0__247_47}"
    selected_line__3103_v0 "${_selected_160}"
    local ret_selected_line3103_v0__248_43="${ret_selected_line3103_v0}"
    redraw_row__3015_v0 "${_display_count_157}" "${_selected_160}" "${ret_selected_line3103_v0__248_43}"
}

# redraw_current_line()
redraw_current_line__3105_v0() {
    selected_line__3103_v0 "${_selected_160}"
    local ret_selected_line3103_v0__253_43="${ret_selected_line3103_v0}"
    redraw_row__3015_v0 "${_display_count_157}" "${_selected_160}" "${ret_selected_line3103_v0__253_43}"
}

# chooser_step()
chooser_step__3106_v0() {
    get_key__2798_v0 
    local key_28063="${ret_get_key2798_v0}"
    local prev_selected_28064="${_selected_160}"
    local prev_page_28065="${_current_page_159}"
    chooser_page_start__3098_v0 
    local page_start_28066="${ret_chooser_page_start3098_v0}"
    _up_paged_169=0
    if [ "$(( $([ "_${key_28063}" != "_UP" ]; echo $?) || $([ "_${key_28063}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_160 == 0 )) && $(( _total_pages_158 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_159 > 0 ))" != 0 ]; then
                _current_page_159="$(( _current_page_159 - 1 ))"
            else
                _current_page_159="$(( _total_pages_158 - 1 ))"
            fi
            _up_paged_169=1
        elif [ "$(( _selected_160 == 0 ))" != 0 ]; then
            _selected_160="$(( _page_count_167 - 1 ))"
        else
            _selected_160="$(( _selected_160 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_28063}" != "_DOWN" ]; echo $?) || $([ "_${key_28063}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_160 == $(( _page_count_167 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_159 < $(( _total_pages_158 - 1 )) ))" != 0 ]; then
                _current_page_159="$(( _current_page_159 + 1 ))"
            else
                _current_page_159=0
            fi
            _selected_160=0
        else
            _selected_160="$(( _selected_160 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_28063}" != "_LEFT" ]; echo $?) || $([ "_${key_28063}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_159 > 0 ))" != 0 ]; then
            _current_page_159="$(( _current_page_159 - 1 ))"
        fi
        _selected_160=0
    elif [ "$(( $([ "_${key_28063}" != "_RIGHT" ]; echo $?) || $([ "_${key_28063}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_159 < $(( _total_pages_158 - 1 )) ))" != 0 ]; then
            _current_page_159="$(( _current_page_159 + 1 ))"
            _selected_160=0
        else
            _selected_160="$(( _page_count_167 - 1 ))"
        fi
    elif [ "$(( _multi_162 && $(( $([ "_${key_28063}" != "_x" ]; echo $?) || $([ "_${key_28063}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3020_v0 "$(( page_start_28066 + _selected_160 ))"
        local ret_checked_toggle3020_v0__310_16="${ret_checked_toggle3020_v0}"
        if [ "${ret_checked_toggle3020_v0__310_16}" != 0 ]; then
            redraw_current_line__3105_v0 
        fi
        ret_chooser_step3106_v0="${__CHOOSER_CONTINUE_152}"
        return 0
    elif [ "$(( $(( _multi_162 && $(( $([ "_${key_28063}" != "_a" ]; echo $?) || $([ "_${key_28063}" != "_A" ]; echo $?) )) )) && $(( _limit_163 < 0 )) ))" != 0 ]; then
        checked_all__3021_v0 
        local ret_checked_all3021_v0__316_16="${ret_checked_all3021_v0}"
        if [ "${ret_checked_all3021_v0__316_16}" != 0 ]; then
            go_up__2854_v0 "${_display_count_157}"
            local array_566=("")
            eprintf__2800_v0 "\\x1b[G" array_566[@]
            render_page__3094_v0 
        fi
        ret_chooser_step3106_v0="${__CHOOSER_CONTINUE_152}"
        return 0
    elif [ "$([ "_${key_28063}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step3106_v0="${__CHOOSER_DONE_154}"
        return 0
    else
        ret_chooser_step3106_v0="${__CHOOSER_CONTINUE_152}"
        return 0
    fi
    if [ "$(( prev_page_28065 != _current_page_159 ))" != 0 ]; then
        ret_chooser_step3106_v0="${__CHOOSER_NEED_PAGE_153}"
        return 0
    fi
    if [ "$(( prev_selected_28064 != _selected_160 ))" != 0 ]; then
        redraw_selection__3104_v0 "${prev_selected_28064}"
    fi
    ret_chooser_step3106_v0="${__CHOOSER_CONTINUE_152}"
    return 0
}

# chooser_selected()
chooser_selected__3107_v0() {
    chooser_page_start__3098_v0 
    local ret_chooser_page_start3098_v0__340_12="${ret_chooser_page_start3098_v0}"
    ret_chooser_selected3107_v0="$(( ret_chooser_page_start3098_v0__340_12 + _selected_160 ))"
    return 0
}

# chooser_end()
chooser_end__3109_v0() {
    local total_lines_28087="$(( _display_count_157 + 2 ))"
    if [ "${_has_header_165}" != 0 ]; then
        total_lines_28087="$(( total_lines_28087 + 1 ))"
    fi
    go_down__2855_v0 1
    remove_line__2850_v0 "$(( total_lines_28087 - 1 ))"
    remove_current_line__2851_v0 
    stty_unlock__2841_v0 
    show_cursor__2858_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3118_v0() {
    local name_28024="${1}"
    local file_type_28025="${2}"
    local target_28026="${3}"
    if [ "$([ "_${file_type_28025}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2557_v0 "/"
        local ret_colored_primary2557_v0__10_23="${ret_colored_primary2557_v0}"
        ret_format_entry_display3118_v0="${name_28024}""${ret_colored_primary2557_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_28025}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2559_v0 " > "
        local ret_colored_accent2559_v0__13_23="${ret_colored_accent2559_v0}"
        colored_primary__2557_v0 "${target_28026}"
        local ret_colored_primary2557_v0__13_47="${ret_colored_primary2557_v0}"
        ret_format_entry_display3118_v0="${name_28024}""${ret_colored_accent2559_v0__13_23}""${ret_colored_primary2557_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3118_v0="${name_28024}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3119_v0() {
    local start_path_27903="${1}"
    local cursor_27904="${2}"
    local show_hidden_27905="${3}"
    local page_size_27906="${4}"
    stty_lock__2496_v0 
    # Initialize current path
    local current_path_27909="${start_path_27903}"
    if [ "$([ "_${current_path_27909}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__2538_v0 
        current_path_27909="${ret_get_cwd2538_v0}"
    fi
    normalize_path__2539_v0 "${current_path_27909}"
    current_path_27909="${ret_normalize_path2539_v0}"
    while :
    do
        colored_primary__2557_v0 "Loading files..."
        local ret_colored_primary2557_v0__41_17="${ret_colored_primary2557_v0}"
        local array_567=("")
        eprintf__2456_v0 "${ret_colored_primary2557_v0__41_17}" array_567[@]
        get_directory_entries__2537_v0 "${current_path_27909}"
        local listed_27920=("${ret_get_directory_entries2537_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_27921=()
        local types_27922=()
        local targets_27923=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_27909}" == "_/" ]; echo $?)" != 0 ]; then
            names_27921+=("..")
            types_27922+=("d")
            targets_27923+=("")
        fi
        local __length_574=("${listed_27920[@]}")
        local listed_count_27924="$(( ${#__length_574[@]} / __ENTRY_STRIDE_115 ))"
        local __range_start_27925=0
        local __range_end_27925="${listed_count_27924}"
        local __dir_27925=$(( ${__range_start_27925} <= ${__range_end_27925} ? 1 : -1 ))
        for (( i_27925=${__range_start_27925}; i_27925 * ${__dir_27925} < ${__range_end_27925} * ${__dir_27925}; i_27925+=${__dir_27925} )); do
            local at_27926="$(( i_27925 * __ENTRY_STRIDE_115 ))"
            local name_27927="${listed_27920[${at_27926}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_27927}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_27905 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_575=("${name_27927}")
            names_27921+=("${array_575[@]}")
            local array_576=("${listed_27920[$(( at_27926 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_27922+=("${array_576[@]}")
            local array_577=("${listed_27920[$(( at_27926 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_27923+=("${array_577[@]}")
done
        local __length_578=("${names_27921[@]}")
        local total_27928="${#__length_578[@]}"
        if [ "$(( total_27928 == 0 ))" != 0 ]; then
            eprintf_colored__2457_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__2497_v0 
            ret_xyl_file3119_v0=""
            return 0
        fi
        colored_primary__2557_v0 "${current_path_27909}"
        local header_27930="${ret_colored_primary2557_v0}"
        remove_current_line__2507_v0 
        chooser_begin__3097_v0 "${total_27928}" "${page_size_27906}" "${header_27930}" "${cursor_27904}" 0 -1
        local need_page_28017=1
        while :
        do
            if [ "${need_page_28017}" != 0 ]; then
                local page_28018=()
                chooser_page_start__3098_v0 
                local start_28019="${ret_chooser_page_start3098_v0}"
                chooser_page_count__3099_v0 
                local count_28022="${ret_chooser_page_count3099_v0}"
                local __range_start_28023="${start_28019}"
                local __range_end_28023="$(( start_28019 + count_28022 ))"
                local __dir_28023=$(( ${__range_start_28023} <= ${__range_end_28023} ? 1 : -1 ))
                for (( i_28023=${__range_start_28023}; i_28023 * ${__dir_28023} < ${__range_end_28023} * ${__dir_28023}; i_28023+=${__dir_28023} )); do
                    format_entry_display__3118_v0 "${names_27921[${i_28023}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_27922[${i_28023}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_27923[${i_28023}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3118_v0__90_30="${ret_format_entry_display3118_v0}"
                    local array_580=("${ret_format_entry_display3118_v0__90_30}")
                    page_28018+=("${array_580[@]}")
done
                chooser_set_page__3100_v0 page_28018[@]
            fi
            chooser_step__3106_v0 
            local step_28085="${ret_chooser_step3106_v0}"
            if [ "$(( step_28085 == __CHOOSER_DONE_154 ))" != 0 ]; then
                break
            fi
            need_page_28017="$(( step_28085 == __CHOOSER_NEED_PAGE_153 ))"
        done
        chooser_selected__3107_v0 
        local selected_idx_28086="${ret_chooser_selected3107_v0}"
        chooser_end__3109_v0 
        local name_28090="${names_27921[${selected_idx_28086}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_28091="${types_27922[${selected_idx_28086}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_28090}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__2541_v0 "${current_path_27909}"
            current_path_27909="${ret_get_parent_dir2541_v0}"
        elif [ "$([ "_${file_type_28091}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__2540_v0 "${current_path_27909}" "${name_28090}"
            current_path_27909="${ret_path_join2540_v0}"
            normalize_path__2539_v0 "${current_path_27909}"
            current_path_27909="${ret_normalize_path2539_v0}"
        elif [ "$([ "_${file_type_28091}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_28096="${targets_27923[${selected_idx_28086}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_28097="${target_28096}"
            starts_with__22_v0 "${target_28096}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__2540_v0 "${current_path_27909}" "${target_28096}"
                target_path_28097="${ret_path_join2540_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_28097}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_27909="${target_path_28097}"
                normalize_path__2539_v0 "${current_path_27909}"
                current_path_27909="${ret_normalize_path2539_v0}"
            else
                stty_unlock__2497_v0 
                path_join__2540_v0 "${current_path_27909}" "${name_28090}"
                ret_xyl_file3119_v0="${ret_path_join2540_v0}"
                return 0
            fi
        else
            stty_unlock__2497_v0 
            path_join__2540_v0 "${current_path_27909}" "${name_28090}"
            ret_xyl_file3119_v0="${ret_path_join2540_v0}"
            return 0
        fi
    done
    stty_unlock__2497_v0 
    ret_xyl_file3119_v0=""
    return 0
}

# print_file_help()
print_file_help__3219_v0() {
    local usage_27821=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2515_v0 usage_27821[@]
    printf '%s\n' ""
    colored_primary__2557_v0 "file"
    local ret_colored_primary2557_v0__8_20="${ret_colored_primary2557_v0}"
    local title_27858=("${ret_colored_primary2557_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2515_v0 title_27858[@]
    printf '%s\n' ""
    colored_secondary__2558_v0 "Arguments:"
    local ret_colored_secondary2558_v0__11_12="${ret_colored_secondary2558_v0}"
    local array_583=()
    printf__128_v0 "${ret_colored_secondary2558_v0__11_12}""
" array_583[@]
    local arg_names_27860=("[<path>]")
    local arg_texts_27861=("Starting directory path")
    local arg_notes_27862=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2690_v0 arg_names_27860[@] arg_texts_27861[@] arg_notes_27862[@] 20
    printf '%s\n' ""
    colored_secondary__2558_v0 "Flags:"
    local ret_colored_secondary2558_v0__18_12="${ret_colored_secondary2558_v0}"
    local array_587=()
    printf__128_v0 "${ret_colored_secondary2558_v0__18_12}""
" array_587[@]
    local names_27895=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_27896=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_27897=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2690_v0 names_27895[@] texts_27896[@] notes_27897[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3277_v0() {
    local parameters_27815=("${!1}")
    local cursor_27816="> "
    local start_path_27817=""
    local show_hidden_27818=0
    local page_size_27819=10
    local __length_594=("${parameters_27815[@]}")
    local slice_upper_593="${#__length_594[@]}"
    local slice_offset_595=2
    local slice_offset_595=$((${slice_offset_595} > 0 ? ${slice_offset_595} : 0))
    local slice_length_596="$(( slice_upper_593 - slice_offset_595 ))"
    local slice_length_596=$((${slice_length_596} > 0 ? ${slice_length_596} : 0))
    for param_27820 in "${parameters_27815[@]:${slice_offset_595}:${slice_length_596}}"; do
        starts_with__22_v0 "${param_27820}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27820}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27820}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27820}" != "_-h" ]; echo $?) || $([ "_${param_27820}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3219_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_597="--cursor="
            slice__24_v0 "${param_27820}" "${#__length_597}" 0
            cursor_27816="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_598="--path="
            slice__24_v0 "${param_27820}" "${#__length_598}" 0
            start_path_27817="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_27820}" != "_-a" ]; echo $?) || $([ "_${param_27820}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_27818=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_599="--page-size="
            slice__24_v0 "${param_27820}" "${#__length_599}" 0
            local value_27898="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27898}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2457_v0 "ERROR: Invalid page-size value: ""${value_27898}""
" 31
                exit 1
            fi
            page_size_27819="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_27817="${param_27820}"
        fi
    done
    xyl_file__3119_v0 "${start_path_27817}" "${cursor_27816}" "${show_hidden_27818}" "${page_size_27819}"
    ret_execute_file3277_v0="${ret_xyl_file3119_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_175="0.1.0"
__AMBER_VERSION_176="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__3279_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__162_v0 "Error: " 91
        local array_600=("")
        eprintf__161_v0 "bc is not installed. Please install bc to use xylitol.
" array_600[@]
        local array_601=("")
        eprintf__161_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_601[@]
        local array_602=("")
        eprintf__161_v0 "  For Fedora: sudo dnf install bc
" array_602[@]
        local array_603=("")
        eprintf__161_v0 "  For Arch Linux: sudo pacman -S bc
" array_603[@]
        ret_check_prerequirements3279_v0=0
        return 0
    fi
    ret_check_prerequirements3279_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__3280_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_177=("$0" "$@")
trap_cleanup__3280_v0 
check_prerequirements__3279_v0 
ret_check_prerequirements3279_v0__32_12="${ret_check_prerequirements3279_v0}"
if [ "$(( ! ret_check_prerequirements3279_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_605=("${args_177[@]}")
if [ "$(( ${#__length_605[@]} < 2 ))" != 0 ]; then
    print_help__552_v0 
    exit 0
fi
command_1539="${args_177[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1539}" != "_help" ]; echo $?) || $([ "_${command_1539}" != "_--help" ]; echo $?) )) || $([ "_${command_1539}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__552_v0 
elif [ "$([ "_${command_1539}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1095_v0 args_177[@]
    ret_execute_input1095_v0__48_18="${ret_execute_input1095_v0}"
    printf '%s\n' "${ret_execute_input1095_v0__48_18}"
elif [ "$([ "_${command_1539}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1761_v0 args_177[@]
    ret_execute_choose1761_v0__51_18="${ret_execute_choose1761_v0}"
    printf '%s\n' "${ret_execute_choose1761_v0__51_18}"
elif [ "$([ "_${command_1539}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2338_v0 args_177[@]
    result_18492="${ret_execute_confirm2338_v0}"
    if [ "$([ "_${result_18492}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1539}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3277_v0 args_177[@]
    ret_execute_file3277_v0__61_18="${ret_execute_file3277_v0}"
    printf '%s\n' "${ret_execute_file3277_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1539}" != "_version" ]; echo $?) || $([ "_${command_1539}" != "_--version" ]; echo $?) )) || $([ "_${command_1539}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__262_v0 "xylitol.sh"
    ret_colored_primary262_v0__64_20="${ret_colored_primary262_v0}"
    array_606=()
    printf__128_v0 "${ret_colored_primary262_v0__64_20}" array_606[@]
    array_607=()
    printf__128_v0 " version: " array_607[@]
    colored_accent__264_v0 "${__VERSION_175}"
    ret_colored_accent264_v0__66_20="${ret_colored_accent264_v0}"
    array_608=()
    printf__128_v0 "${ret_colored_accent264_v0__66_20}" array_608[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_176}" 90
else
    print_help__552_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1539}""'" 91
fi
