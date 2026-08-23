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
    local text_1474="${1}"
    local delimiter_1475="${2}"
    local result_1476=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1475}" read -rd '' -A result_1476 < <(printf %s "$text_1474")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1475}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1476+=("$REPLY"); done < <(echo "$text_1474")
            __status=$?
        else
            IFS="${delimiter_1475}" read -rd '' -a result_1476 < <(printf %s "$text_1474")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1475}" read -rd '' -a result_1476 < <(printf %s "$text_1474")
        __status=$?
    fi
    ret_split4_v0=("${result_1476[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_16469=("${!1}")
    local delimiter_16470="${2}"
    local command_1
    command_1="$(IFS="${delimiter_16470}" ; printf "%s
" "${list_16469[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1478="${1}"
    [ -n "${text_1478}" ] && [ "${text_1478}" -eq "${text_1478}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1478}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_3038="${1}"
    local prefix_3039="${2}"
    [[ "${text_3038}" == "${prefix_3039}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1561="${1}"
    local index_1562="${2}"
    local length_1563="${3}"
    local result_1564=""
    if [ "$(( length_1563 == 0 ))" != 0 ]; then
        local __length_2="${text_1561}"
        length_1563="$(( ${#__length_2} - index_1562 ))"
    fi
    if [ "$(( length_1563 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1564}"
        return 0
    fi
    result_1564="${text_1561: ${index_1562}: ${length_1563}}"
    __status=$?
    ret_slice24_v0="${result_1564}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_26966="${1}"
    local pad_26967="${2}"
    local length_26968="${3}"
    local __length_3="${text_26966}"
    if [ "$(( length_26968 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_26966}"
        return 0
    fi
    local __length_4="${text_26966}"
    local pad_len_26969="$(( length_26968 - ${#__length_4} ))"
    local padding_26970=""
    printf -v padding_26970 "%${pad_len_26969}s" ""
    __status=$?
    padding_26970="${padding_26970// /${pad_26967}}"
    __status=$?
    ret_lpad27_v0="${padding_26970}""${text_26966}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1541="${1}"
    local pad_1542="${2}"
    local length_1543="${3}"
    local __length_5="${text_1541}"
    if [ "$(( length_1543 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1541}"
        return 0
    fi
    local __length_6="${text_1541}"
    local pad_len_1544="$(( length_1543 - ${#__length_6} ))"
    local padding_1545=""
    printf -v padding_1545 "%${pad_len_1544}s" ""
    __status=$?
    padding_1545="${padding_1545// /${pad_1542}}"
    __status=$?
    ret_rpad28_v0="${text_1541}""${padding_1545}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_26960="${1}"
    local pad_26961="${2}"
    local length_26962="${3}"
    local __length_7="${text_26960}"
    local text_length_26963="${#__length_7}"
    if [ "$(( length_26962 <= text_length_26963 ))" != 0 ]; then
        ret_cpad29_v0="${text_26960}"
        return 0
    fi
    local total_padding_26964="$(( length_26962 - text_length_26963 ))"
    local left_padding_length_26965="$(( text_length_26963 + $(( total_padding_26964 / 2 )) ))"
    lpad__27_v0 "${text_26960}" "${pad_26961}" "${left_padding_length_26965}"
    local left_padded_26971="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_26971}" "${pad_26961}" "${length_26962}"
    local center_padded_26972="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_26972}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_36610="${1}"
    [ -d "${path_36610}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1501="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1501}")"
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
" "${(P)name_1501}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1501}")"
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
    local format_1498="${1}"
    local args_1499=("${!2}")
    args_1499=("${format_1498}" "${args_1499[@]}")
    __status=$?
    printf "${args_1499[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1511="${1}"
    local args_1512=("${!2}")
    args_1512=("${format_1511}" "${args_1512[@]}")
    __status=$?
    printf "${args_1512[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1508="${1}"
    local color_1509="${2}"
    local color_code_1510=0
        color_code_1510="${color_1509}"
    local array_11=("${message_1508}")
    printf__128_v1 "\\x1b[${color_code_1510}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_36613="${1}"
    local color_36614="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_36613}")
    printf__128_v1 "\\x1b[${color_36614}m%s\\x1b[0m" array_12[@]
}

# eprintf(format: Text, args: [Text])
eprintf__161_v0() {
    local format_232="${1}"
    local args_233=("${!2}")
    args_233=("${format_232}" "${args_233[@]}")
    __status=$?
    printf "${args_233[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__162_v0() {
    local message_230="${1}"
    local color_231="${2}"
    # Prints an error message with a specified color.
    local array_13=("${message_230}")
    eprintf__161_v0 "\\x1b[${color_231}m%s\\x1b[0m" array_13[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_3="None"
# perl_available()
perl_available__184_v0() {
    if [ "$([ "_${_perl_state_3}" != "_None" ]; echo $?)" != 0 ]; then
        local command_14
        command_14="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_1494
        disabled_1494="$([ "_${command_14}" != "_No" ]; echo $?)"
        local command_15
        command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1495
        found_1495="$(( $(( ! disabled_1494 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1495}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available184_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__185_v0() {
    local text_1493="${1}"
    perl_available__184_v0 
    local ret_perl_available184_v0__19_12="${ret_perl_available184_v0}"
    if [ "$(( ! ret_perl_available184_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return 1
    fi
    local command_16
    command_16="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1493}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_str_1496="${command_16}"
    parse_int__13_v0 "${width_str_1496}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_1497="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width185_v0="${width_1497}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__190_v0() {
    local text_1486="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_17
    command_17="$([[ "${text_1486}" == *$'\x1b'* || "${text_1486}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1487="${command_17}"
    ret_has_ansi_escape190_v0="$([ "_${has_escape_1487}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__192_v0() {
    local text_1489="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1489}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi192_v0="${command_18}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__193_v0() {
    local text_1491="${1}"
    local command_19
    command_19="$(printf "%s" "${text_1491}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1492="${command_19}"
    ret_is_all_ascii193_v0="$([ "_${result_1492}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__194_v0() {
    local text_1488="${1}"
    strip_ansi__192_v0 "${text_1488}"
    local stripped_1490="${ret_strip_ansi192_v0}"
    # Check if text is all ASCII
    is_all_ascii__193_v0 "${stripped_1490}"
    local ret_is_all_ascii193_v0__36_12="${ret_is_all_ascii193_v0}"
    if [ "$(( ! ret_is_all_ascii193_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__185_v0 "${stripped_1490}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_20="${stripped_1490}"
            ret_get_visible_len194_v0="${#__length_20}"
            return 0
        fi
        ret_get_visible_len194_v0="${ret_perl_get_cjk_width185_v0}"
        return 0
    else
        local __length_21="${stripped_1490}"
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
    local size_1473="${1}"
    if [ "$([ "_${size_1473}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size203_v0=0
        return 0
    fi
    split__4_v0 "${size_1473}" " "
    local parts_1477=("${ret_split4_v0[@]}")
    local __length_23=("${parts_1477[@]}")
    if [ "$(( ${#__length_23[@]} != 2 ))" != 0 ]; then
        ret_store_term_size203_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1477[1]?"Index out of bounds (at src/utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1477[0]?"Index out of bounds (at src/utils/term.ab:53:68)"}"
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
    local size_1480="${command_25}"
    store_term_size__203_v0 "${size_1480}"
    ret_query_term_size204_v0="${ret_store_term_size203_v0}"
    return 0
}

# stty_term_size()
stty_term_size__205_v0() {
    local command_26
    command_26="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1472="${command_26}"
    store_term_size__203_v0 "${size_1472}"
    ret_stty_term_size205_v0="${ret_store_term_size203_v0}"
    return 0
}

# get_term_size()
get_term_size__206_v0() {
    stty_term_size__205_v0 
    local detected_1479="${ret_stty_term_size205_v0}"
    if [ "$(( ! detected_1479 ))" != 0 ]; then
        query_term_size__204_v0 
        detected_1479="${ret_query_term_size204_v0}"
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
    local pieces_1471=("${!1}")
    term_width__208_v0 
    local width_1481="${ret_term_width208_v0}"
    local line_1482=""
    local line_len_1483=0
    for piece_1484 in "${pieces_1471[@]}"; do
        local __length_29="${piece_1484}"
        local piece_len_1485="${#__length_29}"
        has_ansi_escape__190_v0 "${piece_1484}"
        local ret_has_ansi_escape190_v0__186_12="${ret_has_ansi_escape190_v0}"
        if [ "${ret_has_ansi_escape190_v0__186_12}" != 0 ]; then
            get_visible_len__194_v0 "${piece_1484}"
            piece_len_1485="${ret_get_visible_len194_v0}"
        fi
        if [ "$([ "_${line_1482}" != "_" ]; echo $?)" != 0 ]; then
            line_1482="${piece_1484}"
            line_len_1483="${piece_len_1485}"
        elif [ "$(( $(( $(( line_len_1483 + 1 )) + piece_len_1485 )) > width_1481 ))" != 0 ]; then
            local array_30=()
            printf__128_v0 "${line_1482}""
" array_30[@]
            line_1482="${piece_1484}"
            line_len_1483="${piece_len_1485}"
        else
            line_1482+=" ""${piece_1484}"
            line_len_1483="$(( line_len_1483 + $(( 1 + piece_len_1485 )) ))"
        fi
    done
    if [ "$([ "_${line_1482}" == "_" ]; echo $?)" != 0 ]; then
        local array_31=()
        printf__128_v0 "${line_1482}""
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
    local config_1518="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1518}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor257_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__258_v0() {
    local message_1513="${1}"
    local r_1514="${2}"
    local g_1515="${3}"
    local b_1516="${4}"
    local fallback_1517="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb258_v0="\\x1b[38;2;${r_1514};${g_1515};${b_1516}m""${message_1513}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__257_v0 
        local ret_get_supports_truecolor257_v0__45_17="${ret_get_supports_truecolor257_v0}"
        if [ "${ret_get_supports_truecolor257_v0__45_17}" != 0 ]; then
            ret_colored_rgb258_v0="\\x1b[38;2;${r_1514};${g_1515};${b_1516}m""${message_1513}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1517 == 0 ))" != 0 ]; then
            ret_colored_rgb258_v0="${message_1513}"
            return 0
        else
            ret_colored_rgb258_v0="\\x1b[${fallback_1517}m""${message_1513}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1517 == 0 ))" != 0 ]; then
            ret_colored_rgb258_v0="${message_1513}"
            return 0
        fi
        ret_colored_rgb258_v0="\\x1b[${fallback_1517}m""${message_1513}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__260_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1502="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1502}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1502}" ";"
            local parts_1503=("${ret_split4_v0[@]}")
            local __length_35=("${parts_1503[@]}")
            if [ "$(( ${#__length_35[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1503[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1503[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1503[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1503[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
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
        local secondary_env_1504="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1504}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1504}" ";"
            local parts_1505=("${ret_split4_v0[@]}")
            local __length_37=("${parts_1505[@]}")
            if [ "$(( ${#__length_37[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1505[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1505[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1505[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1505[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
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
        local accent_env_1506="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1506}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1506}" ";"
            local parts_1507=("${ret_split4_v0[@]}")
            local __length_39=("${parts_1507[@]}")
            if [ "$(( ${#__length_39[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1507[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1507[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1507[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1507[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
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
    local message_1500="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1500}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary262_v0="${ret_colored_rgb258_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__263_v0() {
    local message_1520="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1520}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary263_v0="${ret_colored_rgb258_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__264_v0() {
    local message_1571="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1571}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent264_v0="${ret_colored_rgb258_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__316_v0() {
    local message_1559="${1}"
    local color_1560="${2}"
    # Returns a text wrapped in color codes.
    ret_colored316_v0="\\x1b[${color_1560}m""${message_1559}""\\x1b[0m"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_16=0
_term_size_17=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__356_v0() {
    local size_1533="${1}"
    if [ "$([ "_${size_1533}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size356_v0=0
        return 0
    fi
    split__4_v0 "${size_1533}" " "
    local parts_1534=("${ret_split4_v0[@]}")
    local __length_42=("${parts_1534[@]}")
    if [ "$(( ${#__length_42[@]} != 2 ))" != 0 ]; then
        ret_store_term_size356_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1534[1]?"Index out of bounds (at src/utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1534[0]?"Index out of bounds (at src/utils/widget/../term.ab:53:68)"}"
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
    local size_1536="${command_44}"
    store_term_size__356_v0 "${size_1536}"
    ret_query_term_size357_v0="${ret_store_term_size356_v0}"
    return 0
}

# stty_term_size()
stty_term_size__358_v0() {
    local command_45
    command_45="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1532="${command_45}"
    store_term_size__356_v0 "${size_1532}"
    ret_stty_term_size358_v0="${ret_store_term_size356_v0}"
    return 0
}

# get_term_size()
get_term_size__359_v0() {
    stty_term_size__358_v0 
    local detected_1535="${ret_stty_term_size358_v0}"
    if [ "$(( ! detected_1535 ))" != 0 ]; then
        query_term_size__357_v0 
        detected_1535="${ret_query_term_size357_v0}"
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
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__394_v0() {
    local pending_1556="${1}"
    local line_1557="${2}"
    local note_at_1558="${3}"
    if [ "$(( note_at_1558 < 0 ))" != 0 ]; then
        local array_47=()
        printf__128_v0 "${pending_1556}""${line_1557}""
" array_47[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1558 == 0 ))" != 0 ]; then
        colored__316_v0 "${line_1557}" 90
        local ret_colored316_v0__12_40="${ret_colored316_v0}"
        local array_48=()
        printf__128_v0 "${pending_1556}""${ret_colored316_v0__12_40}""
" array_48[@]
    else
        slice__24_v0 "${line_1557}" 0 "${note_at_1558}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1557}" "${note_at_1558}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__316_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored316_v0__13_58="${ret_colored316_v0}"
        local array_49=()
        printf__128_v0 "${pending_1556}""${ret_slice24_v0__13_32}""${ret_colored316_v0__13_58}""
" array_49[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__395_v0() {
    local names_1524=("${!1}")
    local texts_1525=("${!2}")
    local notes_1526=("${!3}")
    local min_name_width_1527="${4}"
    local __length_50=("${names_1524[@]}")
    local count_1528="${#__length_50[@]}"
    local name_width_1529="${min_name_width_1527}"
    local __range_start_1530=0
    local __range_end_1530="${count_1528}"
    local __dir_1530=$(( ${__range_start_1530} <= ${__range_end_1530} ? 1 : -1 ))
    for (( i_1530=${__range_start_1530}; i_1530 * ${__dir_1530} < ${__range_end_1530} * ${__dir_1530}; i_1530+=${__dir_1530} )); do
        local __length_51="${names_1524[${i_1530}]?"Index out of bounds (at src/utils/widget/help.ab:28:33)"}"
        local width_1531="${#__length_51}"
        if [ "$(( width_1531 > name_width_1529 ))" != 0 ]; then
            name_width_1529="${width_1531}"
        fi
done
    term_width__361_v0 
    local width_1537="${ret_term_width361_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1538="$(( name_width_1529 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1539="$(( $(( width_1537 - indent_1538 )) < 24 ))"
    if [ "${stacked_1539}" != 0 ]; then
        indent_1538=6
    fi
    local avail_1540="$(( width_1537 - indent_1538 ))"
    rpad__28_v0 "" " " "${indent_1538}"
    local blank_1546="${ret_rpad28_v0}"
    local __range_start_1547=0
    local __range_end_1547="${count_1528}"
    local __dir_1547=$(( ${__range_start_1547} <= ${__range_end_1547} ? 1 : -1 ))
    for (( i_1547=${__range_start_1547}; i_1547 * ${__dir_1547} < ${__range_end_1547} * ${__dir_1547}; i_1547+=${__dir_1547} )); do
        local pending_1548="${blank_1546}"
        if [ "${stacked_1539}" != 0 ]; then
            local array_52=()
            printf__128_v0 "  ""${names_1524[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:48:33)"}""
" array_52[@]
        else
            rpad__28_v0 "  ""${names_1524[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:50:41)"}" " " "${indent_1538}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_1548="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_1525[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_1549=("${ret_split4_v0__52_21[@]}")
        local __length_53=("${words_1549[@]}")
        local note_start_1550="${#__length_53[@]}"
        if [ "$([ "_${notes_1526[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_54="${notes_1526[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_54} > avail_1540 ))" != 0 ]; then
                split__4_v0 "${notes_1526[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_1549+=("${ret_split4_v0__58_26[@]}")
            else
                local array_55=("${notes_1526[${i_1547}]?"Index out of bounds (at src/utils/widget/help.ab:60:33)"}")
                words_1549+=("${array_55[@]}")
            fi
        fi
        local line_1551=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1552=-1
        local __range_start_1553=0
        local __length_56=("${words_1549[@]}")
        local __range_end_1553="${#__length_56[@]}"
        local __dir_1553=$(( ${__range_start_1553} <= ${__range_end_1553} ? 1 : -1 ))
        for (( j_1553=${__range_start_1553}; j_1553 * ${__dir_1553} < ${__range_end_1553} * ${__dir_1553}; j_1553+=${__dir_1553} )); do
            local word_1554="${words_1549[${j_1553}]?"Index out of bounds (at src/utils/widget/help.ab:70:32)"}"
            local candidate_1555
            candidate_1555="$(if [ "$([ "_${line_1551}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1554}"; else echo "${line_1551}"" ""${word_1554}"; fi)"
            local __length_57="${candidate_1555}"
            if [ "$(( $(( ${#__length_57} > avail_1540 )) && $([ "_${line_1551}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__394_v0 "${pending_1548}" "${line_1551}" "${note_at_1552}"
                pending_1548="${blank_1546}"
                line_1551="${word_1554}"
                note_at_1552="$(if [ "$(( j_1553 >= note_start_1550 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1553 >= note_start_1550 )) && $(( note_at_1552 < 0 )) ))" != 0 ]; then
                    local __length_58="${candidate_1555}"
                    local __length_59="${word_1554}"
                    note_at_1552="$(( ${#__length_58} - ${#__length_59} ))"
                fi
                line_1551="${candidate_1555}"
            fi
done
        print_help_line__394_v0 "${pending_1548}" "${line_1551}" "${note_at_1552}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__552_v0() {
    local usage_1470=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__220_v0 usage_1470[@]
    printf '%s\n' ""
    colored_primary__262_v0 "Xylitol"
    local ret_colored_primary262_v0__9_21="${ret_colored_primary262_v0}"
    colored_primary__262_v0 "fresh"
    local ret_colored_primary262_v0__10_34="${ret_colored_primary262_v0}"
    local title_1519=("\\x1b[1m""${ret_colored_primary262_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary262_v0__10_34}" "shell" "scripts.")
    print_wrapped__220_v0 title_1519[@]
    printf '%s\n' ""
    colored_secondary__263_v0 "Flags:"
    local ret_colored_secondary263_v0__14_12="${ret_colored_secondary263_v0}"
    local array_62=()
    printf__128_v0 "${ret_colored_secondary263_v0__14_12}""
" array_62[@]
    local flag_names_1521=("-h, --help" "-v, --version")
    local flag_texts_1522=("Show this help message" "Show version information")
    local flag_notes_1523=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__395_v0 flag_names_1521[@] flag_texts_1522[@] flag_notes_1523[@] 13
    printf '%s\n' ""
    colored_secondary__263_v0 "Commands:"
    local ret_colored_secondary263_v0__21_12="${ret_colored_secondary263_v0}"
    local array_66=()
    printf__128_v0 "${ret_colored_secondary263_v0__21_12}""
" array_66[@]
    local cmd_names_1565=("input" "choose" "filter" "confirm" "file")
    local cmd_texts_1566=("Prompt for some input" "Choose from a list of options" "Pick from a list narrowed by typing" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1567=("" "" "" "" "")
    render_help_entries__395_v0 cmd_names_1565[@] cmd_texts_1566[@] cmd_notes_1567[@] 13
    printf '%s\n' ""
    colored_secondary__263_v0 "Envs:"
    local ret_colored_secondary263_v0__33_12="${ret_colored_secondary263_v0}"
    local array_70=()
    printf__128_v0 "${ret_colored_secondary263_v0__33_12}""
" array_70[@]
    local env_names_1568=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1569=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1570=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__395_v0 env_names_1568[@] env_texts_1569[@] env_notes_1570[@] 0
    printf '%s\n' ""
    colored_accent__264_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent264_v0__58_16="${ret_colored_accent264_v0}"
    local footer_1572=("Run" "${ret_colored_accent264_v0__58_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__220_v0 footer_1572[@]
}

# math_floor(number: Int)
math_floor__633_v0() {
    local number_3121="${1}"
    local command_75
    command_75="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_3121}")"
    __status=$?
    ret_math_floor633_v0="${command_75}"
    return 0
}

# math_ceil(number: Int)
math_ceil__634_v0() {
    local number_3120="${1}"
    math_floor__633_v0 "${number_3120}"
    local ret_math_floor633_v0__52_12="${ret_math_floor633_v0}"
    ret_math_ceil634_v0="$(( ret_math_floor633_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__642_v0() {
    local command_76
    command_76="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3115="${command_76}"
    ret_get_char642_v0="${char_3115}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__645_v0() {
    local format_3087="${1}"
    local args_3088=("${!2}")
    args_3088=("${format_3087}" "${args_3088[@]}")
    __status=$?
    printf "${args_3088[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__646_v0() {
    local message_3113="${1}"
    local color_3114="${2}"
    # Prints an error message with a specified color.
    local array_77=("${message_3113}")
    eprintf__645_v0 "\\x1b[${color_3114}m%s\\x1b[0m" array_77[@]
}

# eprintf(format: Text, args: [Text])
eprintf__661_v0() {
    local format_3091="${1}"
    local args_3092=("${!2}")
    args_3092=("${format_3091}" "${args_3092[@]}")
    __status=$?
    printf "${args_3092[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_24="None"
# perl_available()
perl_available__668_v0() {
    if [ "$([ "_${_perl_state_24}" != "_None" ]; echo $?)" != 0 ]; then
        local command_78
        command_78="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_2984
        disabled_2984="$([ "_${command_78}" != "_No" ]; echo $?)"
        local command_79
        command_79="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_2985
        found_2985="$(( $(( ! disabled_2984 )) && $([ "_${command_79}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_2985}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available668_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__669_v0() {
    local text_2983="${1}"
    perl_available__668_v0 
    local ret_perl_available668_v0__19_12="${ret_perl_available668_v0}"
    if [ "$(( ! ret_perl_available668_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width669_v0=''
        return 1
    fi
    local command_80
    command_80="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2983}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width669_v0=''
        return "${__status}"
    fi
    local width_str_2986="${command_80}"
    parse_int__13_v0 "${width_str_2986}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width669_v0=''
        return "${__status}"
    fi
    local width_2987="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width669_v0="${width_2987}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__674_v0() {
    local text_2976="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_81
    command_81="$([[ "${text_2976}" == *$'\x1b'* || "${text_2976}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2977="${command_81}"
    ret_has_ansi_escape674_v0="$([ "_${has_escape_2977}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__676_v0() {
    local text_2979="${1}"
    local command_82
    command_82="$(printf "%s" "${text_2979}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi676_v0="${command_82}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__677_v0() {
    local text_2981="${1}"
    local command_83
    command_83="$(printf "%s" "${text_2981}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2982="${command_83}"
    ret_is_all_ascii677_v0="$([ "_${result_2982}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__678_v0() {
    local text_2978="${1}"
    strip_ansi__676_v0 "${text_2978}"
    local stripped_2980="${ret_strip_ansi676_v0}"
    # Check if text is all ASCII
    is_all_ascii__677_v0 "${stripped_2980}"
    local ret_is_all_ascii677_v0__36_12="${ret_is_all_ascii677_v0}"
    if [ "$(( ! ret_is_all_ascii677_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__669_v0 "${stripped_2980}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_84="${stripped_2980}"
            ret_get_visible_len678_v0="${#__length_84}"
            return 0
        fi
        ret_get_visible_len678_v0="${ret_perl_get_cjk_width669_v0}"
        return 0
    else
        local __length_85="${stripped_2980}"
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
    local count_3048="${command_87}"
    parse_int__13_v0 "${count_3048}"
    __status=$?
    ret_stty_count684_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__685_v0() {
    stty_count__684_v0 
    local count_num_3049="${ret_stty_count684_v0}"
    if [ "$(( count_num_3049 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_3049="$(( count_num_3049 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3049}
    __status=$?
}

# stty_unlock()
stty_unlock__686_v0() {
    stty_count__684_v0 
    local count_num_3118="${ret_stty_count684_v0}"
    if [ "$(( count_num_3118 > 0 ))" != 0 ]; then
        count_num_3118="$(( count_num_3118 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3118}
        __status=$?
        if [ "$(( count_num_3118 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__687_v0() {
    local size_2967="${1}"
    if [ "$([ "_${size_2967}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size687_v0=0
        return 0
    fi
    split__4_v0 "${size_2967}" " "
    local parts_2968=("${ret_split4_v0[@]}")
    local __length_88=("${parts_2968[@]}")
    if [ "$(( ${#__length_88[@]} != 2 ))" != 0 ]; then
        ret_store_term_size687_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2968[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2968[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
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
    local size_2970="${command_90}"
    store_term_size__687_v0 "${size_2970}"
    ret_query_term_size688_v0="${ret_store_term_size687_v0}"
    return 0
}

# stty_term_size()
stty_term_size__689_v0() {
    local command_91
    command_91="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2966="${command_91}"
    store_term_size__687_v0 "${size_2966}"
    ret_stty_term_size689_v0="${ret_store_term_size687_v0}"
    return 0
}

# get_term_size()
get_term_size__690_v0() {
    stty_term_size__689_v0 
    local detected_2969="${ret_stty_term_size689_v0}"
    if [ "$(( ! detected_2969 ))" != 0 ]; then
        query_term_size__688_v0 
        detected_2969="${ret_query_term_size688_v0}"
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
    local cnt_3116="${1}"
    if [ "$(( cnt_3116 > 0 ))" != 0 ]; then
        local array_92=("")
        eprintf__661_v0 "\\x1b[${cnt_3116}D\\x1b[K" array_92[@]
    fi
}

# remove_line(cnt: Int)
remove_line__695_v0() {
    local cnt_3124="${1}"
    if [ "$(( cnt_3124 > 0 ))" != 0 ]; then
        local sequence_3125=""
        local __range_start_3126=0
        local __range_end_3126="${cnt_3124}"
        local __dir_3126=$(( ${__range_start_3126} <= ${__range_end_3126} ? 1 : -1 ))
        for (( ____3126=${__range_start_3126}; ____3126 * ${__dir_3126} < ${__range_end_3126} * ${__dir_3126}; ____3126+=${__dir_3126} )); do
            sequence_3125+="\\x1b[2K\\x1b[1A"
done
        local array_93=("")
        eprintf__661_v0 "${sequence_3125}" array_93[@]
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
    local cnt_3089="${1}"
    local __range_start_3090=0
    local __range_end_3090="${cnt_3089}"
    local __dir_3090=$(( ${__range_start_3090} <= ${__range_end_3090} ? 1 : -1 ))
    for (( ____3090=${__range_start_3090}; ____3090 * ${__dir_3090} < ${__range_end_3090} * ${__dir_3090}; ____3090+=${__dir_3090} )); do
        local array_96=("")
        eprintf__661_v0 "
" array_96[@]
done
}

# go_up(cnt: Int)
go_up__699_v0() {
    local cnt_3110="${1}"
    local array_97=("")
    eprintf__661_v0 "\\x1b[${cnt_3110}A" array_97[@]
}

# go_down(cnt: Int)
go_down__700_v0() {
    local cnt_3123="${1}"
    local array_98=("")
    eprintf__661_v0 "\\x1b[${cnt_3123}B" array_98[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__704_v0() {
    local pieces_2965=("${!1}")
    term_width__692_v0 
    local width_2971="${ret_term_width692_v0}"
    local line_2972=""
    local line_len_2973=0
    for piece_2974 in "${pieces_2965[@]}"; do
        local __length_101="${piece_2974}"
        local piece_len_2975="${#__length_101}"
        has_ansi_escape__674_v0 "${piece_2974}"
        local ret_has_ansi_escape674_v0__186_12="${ret_has_ansi_escape674_v0}"
        if [ "${ret_has_ansi_escape674_v0__186_12}" != 0 ]; then
            get_visible_len__678_v0 "${piece_2974}"
            piece_len_2975="${ret_get_visible_len678_v0}"
        fi
        if [ "$([ "_${line_2972}" != "_" ]; echo $?)" != 0 ]; then
            line_2972="${piece_2974}"
            line_len_2973="${piece_len_2975}"
        elif [ "$(( $(( $(( line_len_2973 + 1 )) + piece_len_2975 )) > width_2971 ))" != 0 ]; then
            local array_102=()
            printf__128_v0 "${line_2972}""
" array_102[@]
            line_2972="${piece_2974}"
            line_len_2973="${piece_len_2975}"
        else
            line_2972+=" ""${piece_2974}"
            line_len_2973="$(( line_len_2973 + $(( 1 + piece_len_2975 )) ))"
        fi
    done
    if [ "$([ "_${line_2972}" == "_" ]; echo $?)" != 0 ]; then
        local array_103=()
        printf__128_v0 "${line_2972}""
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
    local config_3000="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_3000}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor741_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__742_v0() {
    local message_2995="${1}"
    local r_2996="${2}"
    local g_2997="${3}"
    local b_2998="${4}"
    local fallback_2999="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb742_v0="\\x1b[38;2;${r_2996};${g_2997};${b_2998}m""${message_2995}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__741_v0 
        local ret_get_supports_truecolor741_v0__45_17="${ret_get_supports_truecolor741_v0}"
        if [ "${ret_get_supports_truecolor741_v0__45_17}" != 0 ]; then
            ret_colored_rgb742_v0="\\x1b[38;2;${r_2996};${g_2997};${b_2998}m""${message_2995}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2999 == 0 ))" != 0 ]; then
            ret_colored_rgb742_v0="${message_2995}"
            return 0
        else
            ret_colored_rgb742_v0="\\x1b[${fallback_2999}m""${message_2995}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2999 == 0 ))" != 0 ]; then
            ret_colored_rgb742_v0="${message_2995}"
            return 0
        fi
        ret_colored_rgb742_v0="\\x1b[${fallback_2999}m""${message_2995}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__744_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2989="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2989}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2989}" ";"
            local parts_2990=("${ret_split4_v0[@]}")
            local __length_107=("${parts_2990[@]}")
            if [ "$(( ${#__length_107[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2990[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2990[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2990[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2990[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_2991="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2991}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2991}" ";"
            local parts_2992=("${ret_split4_v0[@]}")
            local __length_109=("${parts_2992[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2992[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2992[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2992[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2992[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_2993="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2993}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2993}" ";"
            local parts_2994=("${ret_split4_v0[@]}")
            local __length_111=("${parts_2994[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2994[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2994[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2994[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors744_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2994[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
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
    local message_2988="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__745_v0 
    fi
    colored_rgb__742_v0 "${message_2988}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary746_v0="${ret_colored_rgb742_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__747_v0() {
    local message_3002="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__745_v0 
    fi
    colored_rgb__742_v0 "${message_3002}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary747_v0="${ret_colored_rgb742_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_34="None"
# perl_available()
perl_available__764_v0() {
    if [ "$([ "_${_perl_state_34}" != "_None" ]; echo $?)" != 0 ]; then
        local command_113
        command_113="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3059
        disabled_3059="$([ "_${command_113}" != "_No" ]; echo $?)"
        local command_114
        command_114="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3060
        found_3060="$(( $(( ! disabled_3059 )) && $([ "_${command_114}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3060}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available764_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__765_v0() {
    local text_3058="${1}"
    perl_available__764_v0 
    local ret_perl_available764_v0__19_12="${ret_perl_available764_v0}"
    if [ "$(( ! ret_perl_available764_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width765_v0=''
        return 1
    fi
    local command_115
    command_115="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3058}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width765_v0=''
        return "${__status}"
    fi
    local width_str_3061="${command_115}"
    parse_int__13_v0 "${width_str_3061}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width765_v0=''
        return "${__status}"
    fi
    local width_3062="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width765_v0="${width_3062}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__766_v0() {
    local text_3069="${1}"
    local max_width_3070="${2}"
    perl_available__764_v0 
    local ret_perl_available764_v0__30_12="${ret_perl_available764_v0}"
    if [ "$(( ! ret_perl_available764_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk766_v0=''
        return 1
    fi
    local command_116
    command_116="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3069}" ${max_width_3070} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk766_v0=''
        return "${__status}"
    fi
    local result_3071="${command_116}"
    ret_perl_truncate_cjk766_v0="${result_3071}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__770_v0() {
    local text_3040="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_117
    command_117="$([[ "${text_3040}" == *$'\x1b'* || "${text_3040}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3041="${command_117}"
    ret_has_ansi_escape770_v0="$([ "_${has_escape_3041}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__771_v0() {
    local text_3042="${1}"
    local command_118
    command_118="$(printf '%s' "${text_3042}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi771_v0="${command_118}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__772_v0() {
    local text_3054="${1}"
    local command_119
    command_119="$(printf "%s" "${text_3054}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi772_v0="${command_119}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__773_v0() {
    local text_3056="${1}"
    local command_120
    command_120="$(printf "%s" "${text_3056}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3057="${command_120}"
    ret_is_all_ascii773_v0="$([ "_${result_3057}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__774_v0() {
    local text_3053="${1}"
    strip_ansi__772_v0 "${text_3053}"
    local stripped_3055="${ret_strip_ansi772_v0}"
    # Check if text is all ASCII
    is_all_ascii__773_v0 "${stripped_3055}"
    local ret_is_all_ascii773_v0__36_12="${ret_is_all_ascii773_v0}"
    if [ "$(( ! ret_is_all_ascii773_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__765_v0 "${stripped_3055}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_121="${stripped_3055}"
            ret_get_visible_len774_v0="${#__length_121}"
            return 0
        fi
        ret_get_visible_len774_v0="${ret_perl_get_cjk_width765_v0}"
        return 0
    else
        local __length_122="${stripped_3055}"
        ret_get_visible_len774_v0="${#__length_122}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__775_v0() {
    local text_3066="${1}"
    local max_width_3067="${2}"
    get_visible_len__774_v0 "${text_3066}"
    local visible_len_3068="${ret_get_visible_len774_v0}"
    if [ "$(( visible_len_3068 <= max_width_3067 ))" != 0 ]; then
        ret_truncate_text775_v0="${text_3066}"
        return 0
    fi
    is_all_ascii__773_v0 "${text_3066}"
    local ret_is_all_ascii773_v0__53_12="${ret_is_all_ascii773_v0}"
    if [ "$(( ! ret_is_all_ascii773_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__766_v0 "${text_3066}" "${max_width_3067}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3066}" | cut -c1-${max_width_3067}
            __status=$?
        fi
        ret_truncate_text775_v0="${ret_perl_truncate_cjk766_v0}"
        return 0
    fi
    local command_123
    command_123="$(printf "%s" "${text_3066}" | cut -c1-${max_width_3067})"
    __status=$?
    ret_truncate_text775_v0="${command_123}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__776_v0() {
    local text_3064="${1}"
    local max_width_3065="${2}"
    has_ansi_escape__770_v0 "${text_3064}"
    local ret_has_ansi_escape770_v0__65_12="${ret_has_ansi_escape770_v0}"
    if [ "$(( ! ret_has_ansi_escape770_v0__65_12 ))" != 0 ]; then
        truncate_text__775_v0 "${text_3064}" "${max_width_3065}"
        ret_truncate_ansi776_v0="${ret_truncate_text775_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_124
    command_124="$([[ "${text_3064}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3072="${command_124}"
    # Replace \x1b[ with newline, then split
    local command_125
    command_125="$(t="${text_3064}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3073="${command_125}"
    split__4_v0 "${replaced_3073}" "
"
    local parts_3074=("${ret_split4_v0[@]}")
    local result_3075=""
    local remaining_width_3076="${max_width_3065}"
    local __range_start_3077=0
    local __length_126=("${parts_3074[@]}")
    local __range_end_3077="${#__length_126[@]}"
    local __dir_3077=$(( ${__range_start_3077} <= ${__range_end_3077} ? 1 : -1 ))
    for (( idx_3077=${__range_start_3077}; idx_3077 * ${__dir_3077} < ${__range_end_3077} * ${__dir_3077}; idx_3077+=${__dir_3077} )); do
        local part_3078="${parts_3074[${idx_3077}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3077 == 0 )) && $([ "_${starts_with_ansi_3072}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3078}" == "_" ]; echo $?) && $(( remaining_width_3076 > 0 )) ))" != 0 ]; then
                truncate_text__775_v0 "${part_3078}" "${remaining_width_3076}"
                local ret_truncate_text775_v0__87_35="${ret_truncate_text775_v0}"
                local truncated_3079="${ret_truncate_text775_v0__87_35}"
                result_3075+="${truncated_3079}"
                get_visible_len__774_v0 "${truncated_3079}"
                local ret_get_visible_len774_v0__89_36="${ret_get_visible_len774_v0}"
                remaining_width_3076="$(( remaining_width_3076 - ret_get_visible_len774_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_127
            command_127="$(__p="${part_3078}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3080="${command_127}"
            if [ "$([ "_${m_idx_3080}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_128
                command_128="$(__p="${part_3078}"; printf "%s" "${__p:0:${m_idx_3080}}")"
                __status=$?
                local ansi_params_3081="${command_128}"
                result_3075+="\\x1b[""${ansi_params_3081}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3080}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_3082="${ret_parse_int13_v0__100_41}"
                local text_start_3083="$(( m_idx_num_3082 + 1 ))"
                local command_129
                command_129="$(__p="${part_3078}"; printf "%s" "${__p:${text_start_3083}}")"
                __status=$?
                local text_part_3084="${command_129}"
                if [ "$(( $([ "_${text_part_3084}" == "_" ]; echo $?) && $(( remaining_width_3076 > 0 )) ))" != 0 ]; then
                    truncate_text__775_v0 "${text_part_3084}" "${remaining_width_3076}"
                    local ret_truncate_text775_v0__104_39="${ret_truncate_text775_v0}"
                    local truncated_3085="${ret_truncate_text775_v0__104_39}"
                    result_3075+="${truncated_3085}"
                    get_visible_len__774_v0 "${truncated_3085}"
                    local ret_get_visible_len774_v0__106_40="${ret_get_visible_len774_v0}"
                    remaining_width_3076="$(( remaining_width_3076 - ret_get_visible_len774_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3078}" == "_" ]; echo $?) && $(( remaining_width_3076 > 0 )) ))" != 0 ]; then
                    truncate_text__775_v0 "${part_3078}" "${remaining_width_3076}"
                    local ret_truncate_text775_v0__111_39="${ret_truncate_text775_v0}"
                    local truncated_3086="${ret_truncate_text775_v0__111_39}"
                    result_3075+="${truncated_3086}"
                    get_visible_len__774_v0 "${truncated_3086}"
                    local ret_get_visible_len774_v0__113_40="${ret_get_visible_len774_v0}"
                    remaining_width_3076="$(( remaining_width_3076 - ret_get_visible_len774_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi776_v0="${result_3075}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__777_v0() {
    local text_3051="${1}"
    local max_width_3052="${2}"
    get_visible_len__774_v0 "${text_3051}"
    local visible_len_3063="${ret_get_visible_len774_v0}"
    if [ "$(( visible_len_3063 <= max_width_3052 ))" != 0 ]; then
        ret_cutoff_text777_v0="${text_3051}"
        return 0
    fi
    truncate_ansi__776_v0 "${text_3051}" "$(( max_width_3052 - 3 ))"
    local ret_truncate_ansi776_v0__129_12="${ret_truncate_ansi776_v0}"
    ret_cutoff_text777_v0="${ret_truncate_ansi776_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__798_v0() {
    local format_3101="${1}"
    local args_3102=("${!2}")
    args_3102=("${format_3101}" "${args_3102[@]}")
    __status=$?
    printf "${args_3102[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__799_v0() {
    local message_3099="${1}"
    local color_3100="${2}"
    # Prints an error message with a specified color.
    local array_130=("${message_3099}")
    eprintf__798_v0 "\\x1b[${color_3100}m%s\\x1b[0m" array_130[@]
}

# colored(message: Text, color: Int)
colored__800_v0() {
    local message_3036="${1}"
    local color_3037="${2}"
    # Returns a text wrapped in color codes.
    ret_colored800_v0="\\x1b[${color_3037}m""${message_3036}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__804_v0() {
    local items_3093=("${!1}")
    local total_len_3094="${2}"
    local term_width_3095="${3}"
    local separator_3096=" • "
    local separator_len_3097=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3094 <= term_width_3095 ))" != 0 ]; then
        local iter_3098=0
        while :
        do
            local __length_131=("${items_3093[@]}")
            if [ "$(( iter_3098 >= ${#__length_131[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3098 > 0 ))" != 0 ]; then
                eprintf_colored__799_v0 "${separator_3096}" 90
            fi
            colored__800_v0 "${items_3093[$(( iter_3098 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored800_v0__23_41="${ret_colored800_v0}"
            local array_132=("")
            eprintf__798_v0 "${items_3093[${iter_3098}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored800_v0__23_41}" array_132[@]
            iter_3098="$(( iter_3098 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3103=0
        local first_3104=1
        local iter_3105=0
        while :
        do
            local __length_133=("${items_3093[@]}")
            if [ "$(( iter_3105 >= ${#__length_133[@]} ))" != 0 ]; then
                break
            fi
            local key_3106="${items_3093[${iter_3105}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3107="${items_3093[$(( iter_3105 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_134="${key_3106}"
            local __length_135="${action_3107}"
            local part_len_3108="$(( $(( ${#__length_134} + 1 )) + ${#__length_135} ))"
            local needed_3109="${part_len_3108}"
            if [ "$(( ! first_3104 ))" != 0 ]; then
                needed_3109="$(( needed_3109 + separator_len_3097 ))"
            fi
            if [ "$(( $(( current_len_3103 + needed_3109 )) > term_width_3095 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3104 ))" != 0 ]; then
                eprintf_colored__799_v0 "${separator_3096}" 90
            fi
            colored__800_v0 "${action_3107}" 2
            local ret_colored800_v0__51_33="${ret_colored800_v0}"
            local array_136=("")
            eprintf__798_v0 "${key_3106}"" ""${ret_colored800_v0__51_33}" array_136[@]
            current_len_3103="$(( current_len_3103 + needed_3109 ))"
            first_3104=0
            iter_3105="$(( iter_3105 + 2 ))"
        done
    fi
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_37=0
_term_size_38=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__840_v0() {
    local size_3015="${1}"
    if [ "$([ "_${size_3015}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size840_v0=0
        return 0
    fi
    split__4_v0 "${size_3015}" " "
    local parts_3016=("${ret_split4_v0[@]}")
    local __length_138=("${parts_3016[@]}")
    if [ "$(( ${#__length_138[@]} != 2 ))" != 0 ]; then
        ret_store_term_size840_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3016[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3016[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
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
    local size_3018="${command_140}"
    store_term_size__840_v0 "${size_3018}"
    ret_query_term_size841_v0="${ret_store_term_size840_v0}"
    return 0
}

# stty_term_size()
stty_term_size__842_v0() {
    local command_141
    command_141="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3014="${command_141}"
    store_term_size__840_v0 "${size_3014}"
    ret_stty_term_size842_v0="${ret_store_term_size840_v0}"
    return 0
}

# get_term_size()
get_term_size__843_v0() {
    stty_term_size__842_v0 
    local detected_3017="${ret_stty_term_size842_v0}"
    if [ "$(( ! detected_3017 ))" != 0 ]; then
        query_term_size__841_v0 
        detected_3017="${ret_query_term_size841_v0}"
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
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__878_v0() {
    local pending_3033="${1}"
    local line_3034="${2}"
    local note_at_3035="${3}"
    if [ "$(( note_at_3035 < 0 ))" != 0 ]; then
        local array_143=()
        printf__128_v0 "${pending_3033}""${line_3034}""
" array_143[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3035 == 0 ))" != 0 ]; then
        colored__800_v0 "${line_3034}" 90
        local ret_colored800_v0__12_40="${ret_colored800_v0}"
        local array_144=()
        printf__128_v0 "${pending_3033}""${ret_colored800_v0__12_40}""
" array_144[@]
    else
        slice__24_v0 "${line_3034}" 0 "${note_at_3035}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3034}" "${note_at_3035}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__800_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored800_v0__13_58="${ret_colored800_v0}"
        local array_145=()
        printf__128_v0 "${pending_3033}""${ret_slice24_v0__13_32}""${ret_colored800_v0__13_58}""
" array_145[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__879_v0() {
    local names_3006=("${!1}")
    local texts_3007=("${!2}")
    local notes_3008=("${!3}")
    local min_name_width_3009="${4}"
    local __length_146=("${names_3006[@]}")
    local count_3010="${#__length_146[@]}"
    local name_width_3011="${min_name_width_3009}"
    local __range_start_3012=0
    local __range_end_3012="${count_3010}"
    local __dir_3012=$(( ${__range_start_3012} <= ${__range_end_3012} ? 1 : -1 ))
    for (( i_3012=${__range_start_3012}; i_3012 * ${__dir_3012} < ${__range_end_3012} * ${__dir_3012}; i_3012+=${__dir_3012} )); do
        local __length_147="${names_3006[${i_3012}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_3013="${#__length_147}"
        if [ "$(( width_3013 > name_width_3011 ))" != 0 ]; then
            name_width_3011="${width_3013}"
        fi
done
    term_width__845_v0 
    local width_3019="${ret_term_width845_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_3020="$(( name_width_3011 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_3021="$(( $(( width_3019 - indent_3020 )) < 24 ))"
    if [ "${stacked_3021}" != 0 ]; then
        indent_3020=6
    fi
    local avail_3022="$(( width_3019 - indent_3020 ))"
    rpad__28_v0 "" " " "${indent_3020}"
    local blank_3023="${ret_rpad28_v0}"
    local __range_start_3024=0
    local __range_end_3024="${count_3010}"
    local __dir_3024=$(( ${__range_start_3024} <= ${__range_end_3024} ? 1 : -1 ))
    for (( i_3024=${__range_start_3024}; i_3024 * ${__dir_3024} < ${__range_end_3024} * ${__dir_3024}; i_3024+=${__dir_3024} )); do
        local pending_3025="${blank_3023}"
        if [ "${stacked_3021}" != 0 ]; then
            local array_148=()
            printf__128_v0 "  ""${names_3006[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_148[@]
        else
            rpad__28_v0 "  ""${names_3006[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_3020}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_3025="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_3007[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_3026=("${ret_split4_v0__52_21[@]}")
        local __length_149=("${words_3026[@]}")
        local note_start_3027="${#__length_149[@]}"
        if [ "$([ "_${notes_3008[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_150="${notes_3008[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_150} > avail_3022 ))" != 0 ]; then
                split__4_v0 "${notes_3008[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_3026+=("${ret_split4_v0__58_26[@]}")
            else
                local array_151=("${notes_3008[${i_3024}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_3026+=("${array_151[@]}")
            fi
        fi
        local line_3028=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_3029=-1
        local __range_start_3030=0
        local __length_152=("${words_3026[@]}")
        local __range_end_3030="${#__length_152[@]}"
        local __dir_3030=$(( ${__range_start_3030} <= ${__range_end_3030} ? 1 : -1 ))
        for (( j_3030=${__range_start_3030}; j_3030 * ${__dir_3030} < ${__range_end_3030} * ${__dir_3030}; j_3030+=${__dir_3030} )); do
            local word_3031="${words_3026[${j_3030}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_3032
            candidate_3032="$(if [ "$([ "_${line_3028}" != "_" ]; echo $?)" != 0 ]; then echo "${word_3031}"; else echo "${line_3028}"" ""${word_3031}"; fi)"
            local __length_153="${candidate_3032}"
            if [ "$(( $(( ${#__length_153} > avail_3022 )) && $([ "_${line_3028}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__878_v0 "${pending_3025}" "${line_3028}" "${note_at_3029}"
                pending_3025="${blank_3023}"
                line_3028="${word_3031}"
                note_at_3029="$(if [ "$(( j_3030 >= note_start_3027 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_3030 >= note_start_3027 )) && $(( note_at_3029 < 0 )) ))" != 0 ]; then
                    local __length_154="${candidate_3032}"
                    local __length_155="${word_3031}"
                    note_at_3029="$(( ${#__length_154} - ${#__length_155} ))"
                fi
                line_3028="${candidate_3032}"
            fi
done
        print_help_line__878_v0 "${pending_3025}" "${line_3028}" "${note_at_3029}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__937_v0() {
    local prompt_3044="${1}"
    local placeholder_3045="${2}"
    local header_3046="${3}"
    local password_3047="${4}"
    stty_lock__685_v0 
    term_width__692_v0 
    local term_width_3050="${ret_term_width692_v0}"
    if [ "$([ "_${header_3046}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__777_v0 "${header_3046}" "${term_width_3050}"
        local ret_cutoff_text777_v0__25_17="${ret_cutoff_text777_v0}"
        local array_156=("")
        eprintf__645_v0 "${ret_cutoff_text777_v0__25_17}""
" array_156[@]
    fi
    new_line__698_v0 2
    # "enter submit" = 12
    local array_157=("enter" "submit")
    render_tooltip__804_v0 array_157[@] 12 "${term_width_3050}"
    go_up__699_v0 2
    local array_158=("")
    eprintf__645_v0 "\\x1b[G" array_158[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_159
    command_159="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3111="${command_159}"
    local char_3112=""
    local array_160=("")
    eprintf__645_v0 "${prompt_3044}" array_160[@]
    if [ "$([ "_${can_preset_3111}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__646_v0 "${placeholder_3045}" 90
        get_char__642_v0 
        char_3112="${ret_get_char642_v0}"
        local __length_161="${placeholder_3045}"
        remove__694_v0 "$(( ${#__length_161} + 1 ))"
    fi
    local __length_162="${prompt_3044}"
    remove__694_v0 "${#__length_162}"
    local text_3117=""
    if [ "$(( ! password_3047 ))" != 0 ]; then
        stty_unlock__686_v0 
        local command_163
        command_163="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3112}" -p "${prompt_3044}" text < /dev/tty; else read -e -p "${prompt_3044}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3117="${command_163}"
    else
        stty_unlock__686_v0 
        local command_164
        command_164="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3112}" -p "${prompt_3044}" text < /dev/tty; else read -es -p "${prompt_3044}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3117="${command_164}"
    fi
    stty_lock__685_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__774_v0 "${prompt_3044}""${text_3117}"
    local input_display_len_3119="${ret_get_visible_len774_v0}"
    math_ceil__634_v0 "$(( input_display_len_3119 / term_width_3050 ))"
    local input_lines_3122="${ret_math_ceil634_v0}"
    if [ "$(( input_lines_3122 < 3 ))" != 0 ]; then
        go_down__700_v0 "$(( 2 - input_lines_3122 ))"
        remove_line__695_v0 2
        remove_current_line__696_v0 
    fi
    if [ "$(( input_lines_3122 >= 3 ))" != 0 ]; then
        remove_line__695_v0 "${input_lines_3122}"
    fi
    if [ "$([ "_${header_3046}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__695_v0 1
        remove_current_line__696_v0 
    fi
    stty_unlock__686_v0 
    ret_xyl_input937_v0="${text_3117}"
    return 0
}

# print_input_help()
print_input_help__1037_v0() {
    local usage_2964=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__704_v0 usage_2964[@]
    printf '%s\n' ""
    colored_primary__746_v0 "input"
    local ret_colored_primary746_v0__8_20="${ret_colored_primary746_v0}"
    local title_3001=("${ret_colored_primary746_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__704_v0 title_3001[@]
    printf '%s\n' ""
    colored_secondary__747_v0 "Flags:"
    local ret_colored_secondary747_v0__11_12="${ret_colored_secondary747_v0}"
    local array_167=()
    printf__128_v0 "${ret_colored_secondary747_v0__11_12}""
" array_167[@]
    local names_3003=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_3004=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_3005=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__879_v0 names_3003[@] texts_3004[@] notes_3005[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1095_v0() {
    local parameters_2958=("${!1}")
    local prompt_2959="> "
    local placeholder_2960="Type here..."
    local header_2961=""
    local password_2962=0
    for param_2963 in "${parameters_2958[@]}"; do
        if [ "$(( $([ "_${param_2963}" != "_-h" ]; echo $?) || $([ "_${param_2963}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1037_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2963}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_173="--prompt="
            slice__24_v0 "${param_2963}" "${#__length_173}" 0
            prompt_2959="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2963}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_174="--placeholder="
            slice__24_v0 "${param_2963}" "${#__length_174}" 0
            placeholder_2960="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2963}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_175="--header="
            slice__24_v0 "${param_2963}" "${#__length_175}" 0
            header_2961="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2963}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2962=1
        fi
    done
    has_ansi_escape__770_v0 "${header_2961}"
    local ret_has_ansi_escape770_v0__31_44="${ret_has_ansi_escape770_v0}"
    escape_ansi__771_v0 "${header_2961}"
    local ret_escape_ansi771_v0__31_73="${ret_escape_ansi771_v0}"
    colored_primary__746_v0 "${header_2961}"
    local ret_colored_primary746_v0__31_111="${ret_colored_primary746_v0}"
    local display_header_3043
    display_header_3043="$(if [ "$(( $([ "_${header_2961}" != "_" ]; echo $?) || ret_has_ansi_escape770_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi771_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary746_v0__31_111}"; fi)"
    xyl_input__937_v0 "${prompt_2959}" "${placeholder_2960}" "${display_header_3043}" "${password_2962}"
    ret_execute_input1095_v0="${ret_xyl_input937_v0}"
    return 0
}

# get_key()
get_key__1176_v0() {
    local command_176
    command_176="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1176_v0="${command_176}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1178_v0() {
    local format_16327="${1}"
    local args_16328=("${!2}")
    args_16328=("${format_16327}" "${args_16328[@]}")
    __status=$?
    printf "${args_16328[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1179_v0() {
    local message_16325="${1}"
    local color_16326="${2}"
    # Prints an error message with a specified color.
    local array_177=("${message_16325}")
    eprintf__1178_v0 "\\x1b[${color_16326}m%s\\x1b[0m" array_177[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1194_v0() {
    local format_16348="${1}"
    local args_16349=("${!2}")
    args_16349=("${format_16348}" "${args_16349[@]}")
    __status=$?
    printf "${args_16349[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_46="None"
# perl_available()
perl_available__1201_v0() {
    if [ "$([ "_${_perl_state_46}" != "_None" ]; echo $?)" != 0 ]; then
        local command_178
        command_178="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16280
        disabled_16280="$([ "_${command_178}" != "_No" ]; echo $?)"
        local command_179
        command_179="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16281
        found_16281="$(( $(( ! disabled_16280 )) && $([ "_${command_179}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_16281}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1201_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1202_v0() {
    local text_16279="${1}"
    perl_available__1201_v0 
    local ret_perl_available1201_v0__19_12="${ret_perl_available1201_v0}"
    if [ "$(( ! ret_perl_available1201_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1202_v0=''
        return 1
    fi
    local command_180
    command_180="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16279}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1202_v0=''
        return "${__status}"
    fi
    local width_str_16282="${command_180}"
    parse_int__13_v0 "${width_str_16282}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1202_v0=''
        return "${__status}"
    fi
    local width_16283="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1202_v0="${width_16283}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1207_v0() {
    local text_16272="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_181
    command_181="$([[ "${text_16272}" == *$'\x1b'* || "${text_16272}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16273="${command_181}"
    ret_has_ansi_escape1207_v0="$([ "_${has_escape_16273}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1209_v0() {
    local text_16275="${1}"
    local command_182
    command_182="$(printf "%s" "${text_16275}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1209_v0="${command_182}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1210_v0() {
    local text_16277="${1}"
    local command_183
    command_183="$(printf "%s" "${text_16277}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16278="${command_183}"
    ret_is_all_ascii1210_v0="$([ "_${result_16278}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1211_v0() {
    local text_16274="${1}"
    strip_ansi__1209_v0 "${text_16274}"
    local stripped_16276="${ret_strip_ansi1209_v0}"
    # Check if text is all ASCII
    is_all_ascii__1210_v0 "${stripped_16276}"
    local ret_is_all_ascii1210_v0__36_12="${ret_is_all_ascii1210_v0}"
    if [ "$(( ! ret_is_all_ascii1210_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1202_v0 "${stripped_16276}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_184="${stripped_16276}"
            ret_get_visible_len1211_v0="${#__length_184}"
            return 0
        fi
        ret_get_visible_len1211_v0="${ret_perl_get_cjk_width1202_v0}"
        return 0
    else
        local __length_185="${stripped_16276}"
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
    local count_16346="${command_187}"
    parse_int__13_v0 "${count_16346}"
    __status=$?
    ret_stty_count1217_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1218_v0() {
    stty_count__1217_v0 
    local count_num_16347="${ret_stty_count1217_v0}"
    if [ "$(( count_num_16347 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_16347="$(( count_num_16347 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16347}
    __status=$?
}

# stty_unlock()
stty_unlock__1219_v0() {
    stty_count__1217_v0 
    local count_num_16464="${ret_stty_count1217_v0}"
    if [ "$(( count_num_16464 > 0 ))" != 0 ]; then
        count_num_16464="$(( count_num_16464 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16464}
        __status=$?
        if [ "$(( count_num_16464 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1220_v0() {
    local size_16263="${1}"
    if [ "$([ "_${size_16263}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1220_v0=0
        return 0
    fi
    split__4_v0 "${size_16263}" " "
    local parts_16264=("${ret_split4_v0[@]}")
    local __length_188=("${parts_16264[@]}")
    if [ "$(( ${#__length_188[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1220_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16264[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16264[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
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
    local size_16266="${command_190}"
    store_term_size__1220_v0 "${size_16266}"
    ret_query_term_size1221_v0="${ret_store_term_size1220_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1222_v0() {
    local command_191
    command_191="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16262="${command_191}"
    store_term_size__1220_v0 "${size_16262}"
    ret_stty_term_size1222_v0="${ret_store_term_size1220_v0}"
    return 0
}

# get_term_size()
get_term_size__1223_v0() {
    stty_term_size__1222_v0 
    local detected_16265="${ret_stty_term_size1222_v0}"
    if [ "$(( ! detected_16265 ))" != 0 ]; then
        query_term_size__1221_v0 
        detected_16265="${ret_query_term_size1221_v0}"
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
    local cnt_16436="${1}"
    if [ "$(( cnt_16436 > 0 ))" != 0 ]; then
        local sequence_16437=""
        local __range_start_16438=0
        local __range_end_16438="${cnt_16436}"
        local __dir_16438=$(( ${__range_start_16438} <= ${__range_end_16438} ? 1 : -1 ))
        for (( ____16438=${__range_start_16438}; ____16438 * ${__dir_16438} < ${__range_end_16438} * ${__dir_16438}; ____16438+=${__dir_16438} )); do
            sequence_16437+="\\x1b[2K\\x1b[1A"
done
        local array_192=("")
        eprintf__1194_v0 "${sequence_16437}" array_192[@]
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
    local cnt_16427="${1}"
    printf '%*s' "${cnt_16427}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1231_v0() {
    local cnt_16391="${1}"
    local __range_start_16392=0
    local __range_end_16392="${cnt_16391}"
    local __dir_16392=$(( ${__range_start_16392} <= ${__range_end_16392} ? 1 : -1 ))
    for (( ____16392=${__range_start_16392}; ____16392 * ${__dir_16392} < ${__range_end_16392} * ${__dir_16392}; ____16392+=${__dir_16392} )); do
        local array_195=("")
        eprintf__1194_v0 "
" array_195[@]
done
}

# go_up(cnt: Int)
go_up__1232_v0() {
    local cnt_16410="${1}"
    local array_196=("")
    eprintf__1194_v0 "\\x1b[${cnt_16410}A" array_196[@]
}

# go_down(cnt: Int)
go_down__1233_v0() {
    local cnt_16463="${1}"
    local array_197=("")
    eprintf__1194_v0 "\\x1b[${cnt_16463}B" array_197[@]
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
    local pieces_16261=("${!1}")
    term_width__1225_v0 
    local width_16267="${ret_term_width1225_v0}"
    local line_16268=""
    local line_len_16269=0
    for piece_16270 in "${pieces_16261[@]}"; do
        local __length_202="${piece_16270}"
        local piece_len_16271="${#__length_202}"
        has_ansi_escape__1207_v0 "${piece_16270}"
        local ret_has_ansi_escape1207_v0__186_12="${ret_has_ansi_escape1207_v0}"
        if [ "${ret_has_ansi_escape1207_v0__186_12}" != 0 ]; then
            get_visible_len__1211_v0 "${piece_16270}"
            piece_len_16271="${ret_get_visible_len1211_v0}"
        fi
        if [ "$([ "_${line_16268}" != "_" ]; echo $?)" != 0 ]; then
            line_16268="${piece_16270}"
            line_len_16269="${piece_len_16271}"
        elif [ "$(( $(( $(( line_len_16269 + 1 )) + piece_len_16271 )) > width_16267 ))" != 0 ]; then
            local array_203=()
            printf__128_v0 "${line_16268}""
" array_203[@]
            line_16268="${piece_16270}"
            line_len_16269="${piece_len_16271}"
        else
            line_16268+=" ""${piece_16270}"
            line_len_16269="$(( line_len_16269 + $(( 1 + piece_len_16271 )) ))"
        fi
    done
    if [ "$([ "_${line_16268}" == "_" ]; echo $?)" != 0 ]; then
        local array_204=()
        printf__128_v0 "${line_16268}""
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
    local config_16251="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_16251}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1274_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1275_v0() {
    local message_16246="${1}"
    local r_16247="${2}"
    local g_16248="${3}"
    local b_16249="${4}"
    local fallback_16250="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1275_v0="\\x1b[38;2;${r_16247};${g_16248};${b_16249}m""${message_16246}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1274_v0 
        local ret_get_supports_truecolor1274_v0__45_17="${ret_get_supports_truecolor1274_v0}"
        if [ "${ret_get_supports_truecolor1274_v0__45_17}" != 0 ]; then
            ret_colored_rgb1275_v0="\\x1b[38;2;${r_16247};${g_16248};${b_16249}m""${message_16246}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16250 == 0 ))" != 0 ]; then
            ret_colored_rgb1275_v0="${message_16246}"
            return 0
        else
            ret_colored_rgb1275_v0="\\x1b[${fallback_16250}m""${message_16246}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16250 == 0 ))" != 0 ]; then
            ret_colored_rgb1275_v0="${message_16246}"
            return 0
        fi
        ret_colored_rgb1275_v0="\\x1b[${fallback_16250}m""${message_16246}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1277_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16240="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16240}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16240}" ";"
            local parts_16241=("${ret_split4_v0[@]}")
            local __length_208=("${parts_16241[@]}")
            if [ "$(( ${#__length_208[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16241[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16241[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16241[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16241[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_16242="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16242}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16242}" ";"
            local parts_16243=("${ret_split4_v0[@]}")
            local __length_210=("${parts_16243[@]}")
            if [ "$(( ${#__length_210[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16243[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16243[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16243[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16243[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_16244="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16244}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16244}" ";"
            local parts_16245=("${ret_split4_v0[@]}")
            local __length_212=("${parts_16245[@]}")
            if [ "$(( ${#__length_212[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16245[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16245[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16245[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1277_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16245[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
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
    local message_16239="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1278_v0 
    fi
    colored_rgb__1275_v0 "${message_16239}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1279_v0="${ret_colored_rgb1275_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1280_v0() {
    local message_16285="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1278_v0 
    fi
    colored_rgb__1275_v0 "${message_16285}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1280_v0="${ret_colored_rgb1275_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_56="None"
# perl_available()
perl_available__1297_v0() {
    if [ "$([ "_${_perl_state_56}" != "_None" ]; echo $?)" != 0 ]; then
        local command_214
        command_214="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16360
        disabled_16360="$([ "_${command_214}" != "_No" ]; echo $?)"
        local command_215
        command_215="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16361
        found_16361="$(( $(( ! disabled_16360 )) && $([ "_${command_215}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_16361}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1297_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1298_v0() {
    local text_16359="${1}"
    perl_available__1297_v0 
    local ret_perl_available1297_v0__19_12="${ret_perl_available1297_v0}"
    if [ "$(( ! ret_perl_available1297_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1298_v0=''
        return 1
    fi
    local command_216
    command_216="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16359}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1298_v0=''
        return "${__status}"
    fi
    local width_str_16362="${command_216}"
    parse_int__13_v0 "${width_str_16362}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1298_v0=''
        return "${__status}"
    fi
    local width_16363="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1298_v0="${width_16363}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1299_v0() {
    local text_16370="${1}"
    local max_width_16371="${2}"
    perl_available__1297_v0 
    local ret_perl_available1297_v0__30_12="${ret_perl_available1297_v0}"
    if [ "$(( ! ret_perl_available1297_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1299_v0=''
        return 1
    fi
    local command_217
    command_217="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16370}" ${max_width_16371} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1299_v0=''
        return "${__status}"
    fi
    local result_16372="${command_217}"
    ret_perl_truncate_cjk1299_v0="${result_16372}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1303_v0() {
    local text_16330="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_218
    command_218="$([[ "${text_16330}" == *$'\x1b'* || "${text_16330}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16331="${command_218}"
    ret_has_ansi_escape1303_v0="$([ "_${has_escape_16331}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1304_v0() {
    local text_16332="${1}"
    local command_219
    command_219="$(printf '%s' "${text_16332}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1304_v0="${command_219}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1305_v0() {
    local text_16355="${1}"
    local command_220
    command_220="$(printf "%s" "${text_16355}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1305_v0="${command_220}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1306_v0() {
    local text_16357="${1}"
    local command_221
    command_221="$(printf "%s" "${text_16357}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16358="${command_221}"
    ret_is_all_ascii1306_v0="$([ "_${result_16358}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1307_v0() {
    local text_16354="${1}"
    strip_ansi__1305_v0 "${text_16354}"
    local stripped_16356="${ret_strip_ansi1305_v0}"
    # Check if text is all ASCII
    is_all_ascii__1306_v0 "${stripped_16356}"
    local ret_is_all_ascii1306_v0__36_12="${ret_is_all_ascii1306_v0}"
    if [ "$(( ! ret_is_all_ascii1306_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1298_v0 "${stripped_16356}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_222="${stripped_16356}"
            ret_get_visible_len1307_v0="${#__length_222}"
            return 0
        fi
        ret_get_visible_len1307_v0="${ret_perl_get_cjk_width1298_v0}"
        return 0
    else
        local __length_223="${stripped_16356}"
        ret_get_visible_len1307_v0="${#__length_223}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1308_v0() {
    local text_16367="${1}"
    local max_width_16368="${2}"
    get_visible_len__1307_v0 "${text_16367}"
    local visible_len_16369="${ret_get_visible_len1307_v0}"
    if [ "$(( visible_len_16369 <= max_width_16368 ))" != 0 ]; then
        ret_truncate_text1308_v0="${text_16367}"
        return 0
    fi
    is_all_ascii__1306_v0 "${text_16367}"
    local ret_is_all_ascii1306_v0__53_12="${ret_is_all_ascii1306_v0}"
    if [ "$(( ! ret_is_all_ascii1306_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1299_v0 "${text_16367}" "${max_width_16368}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16367}" | cut -c1-${max_width_16368}
            __status=$?
        fi
        ret_truncate_text1308_v0="${ret_perl_truncate_cjk1299_v0}"
        return 0
    fi
    local command_224
    command_224="$(printf "%s" "${text_16367}" | cut -c1-${max_width_16368})"
    __status=$?
    ret_truncate_text1308_v0="${command_224}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1309_v0() {
    local text_16365="${1}"
    local max_width_16366="${2}"
    has_ansi_escape__1303_v0 "${text_16365}"
    local ret_has_ansi_escape1303_v0__65_12="${ret_has_ansi_escape1303_v0}"
    if [ "$(( ! ret_has_ansi_escape1303_v0__65_12 ))" != 0 ]; then
        truncate_text__1308_v0 "${text_16365}" "${max_width_16366}"
        ret_truncate_ansi1309_v0="${ret_truncate_text1308_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_225
    command_225="$([[ "${text_16365}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16373="${command_225}"
    # Replace \x1b[ with newline, then split
    local command_226
    command_226="$(t="${text_16365}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16374="${command_226}"
    split__4_v0 "${replaced_16374}" "
"
    local parts_16375=("${ret_split4_v0[@]}")
    local result_16376=""
    local remaining_width_16377="${max_width_16366}"
    local __range_start_16378=0
    local __length_227=("${parts_16375[@]}")
    local __range_end_16378="${#__length_227[@]}"
    local __dir_16378=$(( ${__range_start_16378} <= ${__range_end_16378} ? 1 : -1 ))
    for (( idx_16378=${__range_start_16378}; idx_16378 * ${__dir_16378} < ${__range_end_16378} * ${__dir_16378}; idx_16378+=${__dir_16378} )); do
        local part_16379="${parts_16375[${idx_16378}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16378 == 0 )) && $([ "_${starts_with_ansi_16373}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16379}" == "_" ]; echo $?) && $(( remaining_width_16377 > 0 )) ))" != 0 ]; then
                truncate_text__1308_v0 "${part_16379}" "${remaining_width_16377}"
                local ret_truncate_text1308_v0__87_35="${ret_truncate_text1308_v0}"
                local truncated_16380="${ret_truncate_text1308_v0__87_35}"
                result_16376+="${truncated_16380}"
                get_visible_len__1307_v0 "${truncated_16380}"
                local ret_get_visible_len1307_v0__89_36="${ret_get_visible_len1307_v0}"
                remaining_width_16377="$(( remaining_width_16377 - ret_get_visible_len1307_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_228
            command_228="$(__p="${part_16379}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16381="${command_228}"
            if [ "$([ "_${m_idx_16381}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_229
                command_229="$(__p="${part_16379}"; printf "%s" "${__p:0:${m_idx_16381}}")"
                __status=$?
                local ansi_params_16382="${command_229}"
                result_16376+="\\x1b[""${ansi_params_16382}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16381}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_16383="${ret_parse_int13_v0__100_41}"
                local text_start_16384="$(( m_idx_num_16383 + 1 ))"
                local command_230
                command_230="$(__p="${part_16379}"; printf "%s" "${__p:${text_start_16384}}")"
                __status=$?
                local text_part_16385="${command_230}"
                if [ "$(( $([ "_${text_part_16385}" == "_" ]; echo $?) && $(( remaining_width_16377 > 0 )) ))" != 0 ]; then
                    truncate_text__1308_v0 "${text_part_16385}" "${remaining_width_16377}"
                    local ret_truncate_text1308_v0__104_39="${ret_truncate_text1308_v0}"
                    local truncated_16386="${ret_truncate_text1308_v0__104_39}"
                    result_16376+="${truncated_16386}"
                    get_visible_len__1307_v0 "${truncated_16386}"
                    local ret_get_visible_len1307_v0__106_40="${ret_get_visible_len1307_v0}"
                    remaining_width_16377="$(( remaining_width_16377 - ret_get_visible_len1307_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16379}" == "_" ]; echo $?) && $(( remaining_width_16377 > 0 )) ))" != 0 ]; then
                    truncate_text__1308_v0 "${part_16379}" "${remaining_width_16377}"
                    local ret_truncate_text1308_v0__111_39="${ret_truncate_text1308_v0}"
                    local truncated_16387="${ret_truncate_text1308_v0__111_39}"
                    result_16376+="${truncated_16387}"
                    get_visible_len__1307_v0 "${truncated_16387}"
                    local ret_get_visible_len1307_v0__113_40="${ret_get_visible_len1307_v0}"
                    remaining_width_16377="$(( remaining_width_16377 - ret_get_visible_len1307_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1309_v0="${result_16376}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1310_v0() {
    local text_16352="${1}"
    local max_width_16353="${2}"
    get_visible_len__1307_v0 "${text_16352}"
    local visible_len_16364="${ret_get_visible_len1307_v0}"
    if [ "$(( visible_len_16364 <= max_width_16353 ))" != 0 ]; then
        ret_cutoff_text1310_v0="${text_16352}"
        return 0
    fi
    truncate_ansi__1309_v0 "${text_16352}" "$(( max_width_16353 - 3 ))"
    local ret_truncate_ansi1309_v0__129_12="${ret_truncate_ansi1309_v0}"
    ret_cutoff_text1310_v0="${ret_truncate_ansi1309_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1331_v0() {
    local format_16401="${1}"
    local args_16402=("${!2}")
    args_16402=("${format_16401}" "${args_16402[@]}")
    __status=$?
    printf "${args_16402[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1332_v0() {
    local message_16399="${1}"
    local color_16400="${2}"
    # Prints an error message with a specified color.
    local array_231=("${message_16399}")
    eprintf__1331_v0 "\\x1b[${color_16400}m%s\\x1b[0m" array_231[@]
}

# colored(message: Text, color: Int)
colored__1333_v0() {
    local message_16319="${1}"
    local color_16320="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1333_v0="\\x1b[${color_16320}m""${message_16319}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1337_v0() {
    local items_16393=("${!1}")
    local total_len_16394="${2}"
    local term_width_16395="${3}"
    local separator_16396=" • "
    local separator_len_16397=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16394 <= term_width_16395 ))" != 0 ]; then
        local iter_16398=0
        while :
        do
            local __length_232=("${items_16393[@]}")
            if [ "$(( iter_16398 >= ${#__length_232[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16398 > 0 ))" != 0 ]; then
                eprintf_colored__1332_v0 "${separator_16396}" 90
            fi
            colored__1333_v0 "${items_16393[$(( iter_16398 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1333_v0__23_41="${ret_colored1333_v0}"
            local array_233=("")
            eprintf__1331_v0 "${items_16393[${iter_16398}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1333_v0__23_41}" array_233[@]
            iter_16398="$(( iter_16398 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16403=0
        local first_16404=1
        local iter_16405=0
        while :
        do
            local __length_234=("${items_16393[@]}")
            if [ "$(( iter_16405 >= ${#__length_234[@]} ))" != 0 ]; then
                break
            fi
            local key_16406="${items_16393[${iter_16405}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_16407="${items_16393[$(( iter_16405 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_235="${key_16406}"
            local __length_236="${action_16407}"
            local part_len_16408="$(( $(( ${#__length_235} + 1 )) + ${#__length_236} ))"
            local needed_16409="${part_len_16408}"
            if [ "$(( ! first_16404 ))" != 0 ]; then
                needed_16409="$(( needed_16409 + separator_len_16397 ))"
            fi
            if [ "$(( $(( current_len_16403 + needed_16409 )) > term_width_16395 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16404 ))" != 0 ]; then
                eprintf_colored__1332_v0 "${separator_16396}" 90
            fi
            colored__1333_v0 "${action_16407}" 2
            local ret_colored1333_v0__51_33="${ret_colored1333_v0}"
            local array_237=("")
            eprintf__1331_v0 "${key_16406}"" ""${ret_colored1333_v0__51_33}" array_237[@]
            current_len_16403="$(( current_len_16403 + needed_16409 ))"
            first_16404=0
            iter_16405="$(( iter_16405 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1347_v0() {
    local format_16452="${1}"
    local args_16453=("${!2}")
    args_16453=("${format_16452}" "${args_16453[@]}")
    __status=$?
    printf "${args_16453[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_59=0
_term_size_60=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__1373_v0() {
    local size_16298="${1}"
    if [ "$([ "_${size_16298}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1373_v0=0
        return 0
    fi
    split__4_v0 "${size_16298}" " "
    local parts_16299=("${ret_split4_v0[@]}")
    local __length_239=("${parts_16299[@]}")
    if [ "$(( ${#__length_239[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1373_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16299[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16299[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
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
    local size_16301="${command_241}"
    store_term_size__1373_v0 "${size_16301}"
    ret_query_term_size1374_v0="${ret_store_term_size1373_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1375_v0() {
    local command_242
    command_242="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16297="${command_242}"
    store_term_size__1373_v0 "${size_16297}"
    ret_stty_term_size1375_v0="${ret_store_term_size1373_v0}"
    return 0
}

# get_term_size()
get_term_size__1376_v0() {
    stty_term_size__1375_v0 
    local detected_16300="${ret_stty_term_size1375_v0}"
    if [ "$(( ! detected_16300 ))" != 0 ]; then
        query_term_size__1374_v0 
        detected_16300="${ret_query_term_size1374_v0}"
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
    local cnt_16451="${1}"
    local array_243=("")
    eprintf__1347_v0 "\\x1b[${cnt_16451}A" array_243[@]
}

# go_down(cnt: Int)
go_down__1386_v0() {
    local cnt_16454="${1}"
    local array_244=("")
    eprintf__1347_v0 "\\x1b[${cnt_16454}B" array_244[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1393_v0() {
    local display_count_16448="${1}"
    local index_16449="${2}"
    local line_16450="${3}"
    go_up__1385_v0 "$(( display_count_16448 - index_16449 ))"
    local array_245=("")
    eprintf__1331_v0 "\\x1b[G\\x1b[K" array_245[@]
    local array_246=("")
    eprintf__1331_v0 "${line_16450}" array_246[@]
    go_down__1386_v0 "$(( display_count_16448 - index_16449 ))"
    local array_247=("")
    eprintf__1331_v0 "\\x1b[G" array_247[@]
}

# Which items of a multi-select widget are ticked.
_checked_61=()
_count_62=0
_total_63=0
_limit_64=-1
# checked_init(total: Int, limit: Int)
checked_init__1395_v0() {
    local total_16388="${1}"
    local limit_16389="${2}"
    _checked_61=()
    local __range_start_16390=0
    local __range_end_16390="${total_16388}"
    local __dir_16390=$(( ${__range_start_16390} <= ${__range_end_16390} ? 1 : -1 ))
    for (( ____16390=${__range_start_16390}; ____16390 * ${__dir_16390} < ${__range_end_16390} * ${__dir_16390}; ____16390+=${__dir_16390} )); do
        local array_250=(0)
        _checked_61+=("${array_250[@]}")
done
    _count_62=0
    _total_63="${total_16388}"
    _limit_64="${limit_16389}"
}

# checked_is(index: Int)
checked_is__1396_v0() {
    local index_16424="${1}"
    ret_checked_is1396_v0="${_checked_61[${index_16424}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1398_v0() {
    local index_16443="${1}"
    if [ "${_checked_61[${index_16443}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_61["${index_16443}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1398_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1398_v0=0
        return 0
    fi
    _checked_61["${index_16443}"]=1
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
    local was_all_16455="$(( _count_62 == _total_63 ))"
    local __range_start_16456=0
    local __range_end_16456="${_total_63}"
    local __dir_16456=$(( ${__range_start_16456} <= ${__range_end_16456} ? 1 : -1 ))
    for (( i_16456=${__range_start_16456}; i_16456 * ${__dir_16456} < ${__range_end_16456} * ${__dir_16456}; i_16456+=${__dir_16456} )); do
        _checked_61["${i_16456}"]="$(( ! was_all_16455 ))"
done
    if [ "${was_all_16455}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1399_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1411_v0() {
    local pending_16316="${1}"
    local line_16317="${2}"
    local note_at_16318="${3}"
    if [ "$(( note_at_16318 < 0 ))" != 0 ]; then
        local array_251=()
        printf__128_v0 "${pending_16316}""${line_16317}""
" array_251[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16318 == 0 ))" != 0 ]; then
        colored__1333_v0 "${line_16317}" 90
        local ret_colored1333_v0__12_40="${ret_colored1333_v0}"
        local array_252=()
        printf__128_v0 "${pending_16316}""${ret_colored1333_v0__12_40}""
" array_252[@]
    else
        slice__24_v0 "${line_16317}" 0 "${note_at_16318}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16317}" "${note_at_16318}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1333_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1333_v0__13_58="${ret_colored1333_v0}"
        local array_253=()
        printf__128_v0 "${pending_16316}""${ret_slice24_v0__13_32}""${ret_colored1333_v0__13_58}""
" array_253[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1412_v0() {
    local names_16289=("${!1}")
    local texts_16290=("${!2}")
    local notes_16291=("${!3}")
    local min_name_width_16292="${4}"
    local __length_254=("${names_16289[@]}")
    local count_16293="${#__length_254[@]}"
    local name_width_16294="${min_name_width_16292}"
    local __range_start_16295=0
    local __range_end_16295="${count_16293}"
    local __dir_16295=$(( ${__range_start_16295} <= ${__range_end_16295} ? 1 : -1 ))
    for (( i_16295=${__range_start_16295}; i_16295 * ${__dir_16295} < ${__range_end_16295} * ${__dir_16295}; i_16295+=${__dir_16295} )); do
        local __length_255="${names_16289[${i_16295}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_16296="${#__length_255}"
        if [ "$(( width_16296 > name_width_16294 ))" != 0 ]; then
            name_width_16294="${width_16296}"
        fi
done
    term_width__1378_v0 
    local width_16302="${ret_term_width1378_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16303="$(( name_width_16294 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16304="$(( $(( width_16302 - indent_16303 )) < 24 ))"
    if [ "${stacked_16304}" != 0 ]; then
        indent_16303=6
    fi
    local avail_16305="$(( width_16302 - indent_16303 ))"
    rpad__28_v0 "" " " "${indent_16303}"
    local blank_16306="${ret_rpad28_v0}"
    local __range_start_16307=0
    local __range_end_16307="${count_16293}"
    local __dir_16307=$(( ${__range_start_16307} <= ${__range_end_16307} ? 1 : -1 ))
    for (( i_16307=${__range_start_16307}; i_16307 * ${__dir_16307} < ${__range_end_16307} * ${__dir_16307}; i_16307+=${__dir_16307} )); do
        local pending_16308="${blank_16306}"
        if [ "${stacked_16304}" != 0 ]; then
            local array_256=()
            printf__128_v0 "  ""${names_16289[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_256[@]
        else
            rpad__28_v0 "  ""${names_16289[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_16303}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_16308="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_16290[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_16309=("${ret_split4_v0__52_21[@]}")
        local __length_257=("${words_16309[@]}")
        local note_start_16310="${#__length_257[@]}"
        if [ "$([ "_${notes_16291[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_258="${notes_16291[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_258} > avail_16305 ))" != 0 ]; then
                split__4_v0 "${notes_16291[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_16309+=("${ret_split4_v0__58_26[@]}")
            else
                local array_259=("${notes_16291[${i_16307}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_16309+=("${array_259[@]}")
            fi
        fi
        local line_16311=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16312=-1
        local __range_start_16313=0
        local __length_260=("${words_16309[@]}")
        local __range_end_16313="${#__length_260[@]}"
        local __dir_16313=$(( ${__range_start_16313} <= ${__range_end_16313} ? 1 : -1 ))
        for (( j_16313=${__range_start_16313}; j_16313 * ${__dir_16313} < ${__range_end_16313} * ${__dir_16313}; j_16313+=${__dir_16313} )); do
            local word_16314="${words_16309[${j_16313}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_16315
            candidate_16315="$(if [ "$([ "_${line_16311}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16314}"; else echo "${line_16311}"" ""${word_16314}"; fi)"
            local __length_261="${candidate_16315}"
            if [ "$(( $(( ${#__length_261} > avail_16305 )) && $([ "_${line_16311}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1411_v0 "${pending_16308}" "${line_16311}" "${note_at_16312}"
                pending_16308="${blank_16306}"
                line_16311="${word_16314}"
                note_at_16312="$(if [ "$(( j_16313 >= note_start_16310 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16313 >= note_start_16310 )) && $(( note_at_16312 < 0 )) ))" != 0 ]; then
                    local __length_262="${candidate_16315}"
                    local __length_263="${word_16314}"
                    note_at_16312="$(( ${#__length_262} - ${#__length_263} ))"
                fi
                line_16311="${candidate_16315}"
            fi
done
        print_help_line__1411_v0 "${pending_16308}" "${line_16311}" "${note_at_16312}"
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
    local cursor_len_16430="${#__length_265}"
    local max_option_width_16431="$(( $(( _term_width_79 - cursor_len_16430 )) - 1 ))"
    local __range_start_16432=0
    local __range_end_16432="${_page_count_82}"
    local __dir_16432=$(( ${__range_start_16432} <= ${__range_end_16432} ? 1 : -1 ))
    for (( i_16432=${__range_start_16432}; i_16432 * ${__dir_16432} < ${__range_end_16432} * ${__dir_16432}; i_16432+=${__dir_16432} )); do
        cutoff_text__1310_v0 "${_page_81[${i_16432}]?"Index out of bounds (at src/./choose/./engine.ab:45:45)"}" "${max_option_width_16431}"
        local ret_cutoff_text1310_v0__45_27="${ret_cutoff_text1310_v0}"
        local truncated_16433="${ret_cutoff_text1310_v0__45_27}"
        if [ "$(( i_16432 == _selected_75 ))" != 0 ]; then
            colored_secondary__1280_v0 "${_cursor_76}""${truncated_16433}""
"
            local ret_colored_secondary1280_v0__47_21="${ret_colored_secondary1280_v0}"
            local array_266=("")
            eprintf__1178_v0 "${ret_colored_secondary1280_v0__47_21}" array_266[@]
        else
            print_blank__1230_v0 "${cursor_len_16430}"
            local array_267=("")
            eprintf__1178_v0 "${truncated_16433}""
" array_267[@]
        fi
done
    local remaining_slots_16434="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_16434 > 0 ))" != 0 ]; then
        local __range_start_16435=0
        local __range_end_16435="${remaining_slots_16434}"
        local __dir_16435=$(( ${__range_start_16435} <= ${__range_end_16435} ? 1 : -1 ))
        for (( ____16435=${__range_start_16435}; ____16435 * ${__dir_16435} < ${__range_end_16435} * ${__dir_16435}; ____16435+=${__dir_16435} )); do
            local array_268=("")
            eprintf__1178_v0 "\\x1b[K
" array_268[@]
done
    fi
}

# render_multi_page()
render_multi_page__1575_v0() {
    local __length_269="${_cursor_76}"
    local cursor_len_16419="${#__length_269}"
    local max_option_width_16420="$(( $(( _term_width_79 - cursor_len_16419 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1580_v0 
    local page_start_16421="${ret_chooser_page_start1580_v0}"
    local __range_start_16422=0
    local __range_end_16422="${_page_count_82}"
    local __dir_16422=$(( ${__range_start_16422} <= ${__range_end_16422} ? 1 : -1 ))
    for (( i_16422=${__range_start_16422}; i_16422 * ${__dir_16422} < ${__range_end_16422} * ${__dir_16422}; i_16422+=${__dir_16422} )); do
        local global_idx_16423="$(( page_start_16421 + i_16422 ))"
        checked_is__1396_v0 "${global_idx_16423}"
        local ret_checked_is1396_v0__67_28="${ret_checked_is1396_v0}"
        local check_mark_16425
        check_mark_16425="$(if [ "${ret_checked_is1396_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1310_v0 "${_page_81[${i_16422}]?"Index out of bounds (at src/./choose/./engine.ab:68:45)"}" "${max_option_width_16420}"
        local ret_cutoff_text1310_v0__68_27="${ret_cutoff_text1310_v0}"
        local truncated_16426="${ret_cutoff_text1310_v0__68_27}"
        checked_is__1396_v0 "${global_idx_16423}"
        local ret_checked_is1396_v0__71_13="${ret_checked_is1396_v0}"
        if [ "$(( i_16422 == _selected_75 ))" != 0 ]; then
            colored_secondary__1280_v0 "${_cursor_76}""${check_mark_16425}""${truncated_16426}""
"
            local ret_colored_secondary1280_v0__70_37="${ret_colored_secondary1280_v0}"
            local array_270=("")
            eprintf__1178_v0 "${ret_colored_secondary1280_v0__70_37}" array_270[@]
        elif [ "${ret_checked_is1396_v0__71_13}" != 0 ]; then
            print_blank__1230_v0 "${cursor_len_16419}"
            colored_secondary__1280_v0 "${check_mark_16425}""${truncated_16426}""
"
            local ret_colored_secondary1280_v0__73_25="${ret_colored_secondary1280_v0}"
            local array_271=("")
            eprintf__1178_v0 "${ret_colored_secondary1280_v0__73_25}" array_271[@]
        else
            print_blank__1230_v0 "${cursor_len_16419}"
            local array_272=("")
            eprintf__1178_v0 "${check_mark_16425}""${truncated_16426}""
" array_272[@]
        fi
done
    local remaining_slots_16428="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_16428 > 0 ))" != 0 ]; then
        local __range_start_16429=0
        local __range_end_16429="${remaining_slots_16428}"
        local __dir_16429=$(( ${__range_start_16429} <= ${__range_end_16429} ? 1 : -1 ))
        for (( ____16429=${__range_start_16429}; ____16429 * ${__dir_16429} < ${__range_end_16429} * ${__dir_16429}; ____16429+=${__dir_16429} )); do
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
    local total_16340="${1}"
    local page_size_16341="${2}"
    local header_16342="${3}"
    local cursor_16343="${4}"
    local multi_16344="${5}"
    local limit_16345="${6}"
    _total_70="${total_16340}"
    _cursor_76="${cursor_16343}"
    _multi_77="${multi_16344}"
    _limit_78="${limit_16345}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_16342}" == "_" ]; echo $?)"
    stty_lock__1218_v0 
    hide_cursor__1235_v0 
    term_width__1225_v0 
    _term_width_79="${ret_term_width1225_v0}"
    term_height__1226_v0 
    local term_height_16350="${ret_term_height1226_v0}"
    local max_page_size_16351
    max_page_size_16351="$(( term_height_16350 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_16341}"
    if [ "$(( _page_size_71 > max_page_size_16351 ))" != 0 ]; then
        _page_size_71="${max_page_size_16351}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1310_v0 "${header_16342}" "${_term_width_79}"
        local ret_cutoff_text1310_v0__153_17="${ret_cutoff_text1310_v0}"
        local array_282=("")
        eprintf__1178_v0 "${ret_cutoff_text1310_v0__153_17}""
" array_282[@]
    fi
    math_floor__633_v0 "$(( $(( $(( total_16340 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _total_pages_73="${ret_math_floor633_v0}"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_16340 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_16340}"
    fi
    if [ "${multi_16344}" != 0 ]; then
        checked_init__1395_v0 "${total_16340}" "${limit_16345}"
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
    local start_16414="${ret_chooser_page_start1580_v0}"
    local end_16415="$(( start_16414 + _page_size_71 ))"
    if [ "$(( end_16415 > _total_70 ))" != 0 ]; then
        end_16415="${_total_70}"
    fi
    ret_chooser_page_count1581_v0="$(( end_16415 - start_16414 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1582_v0() {
    local page_16418=("${!1}")
    _page_81=("${page_16418[@]}")
    local __length_285=("${page_16418[@]}")
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
    local check_width_16445
    check_width_16445="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_287="${_cursor_76}"
    ret_option_width1583_v0="$(( $(( _term_width_79 - ${#__length_287} )) - check_width_16445 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1584_v0() {
    local index_16458="${1}"
    local __length_288="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_288}"
    local blank_16459="${ret_rpad28_v0}"
    option_width__1583_v0 
    local ret_option_width1583_v0__224_49="${ret_option_width1583_v0}"
    cutoff_text__1310_v0 "${_page_81[${index_16458}]?"Index out of bounds (at src/./choose/./engine.ab:224:41)"}" "${ret_option_width1583_v0__224_49}"
    local truncated_16460="${ret_cutoff_text1310_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1584_v0="${blank_16459}""${truncated_16460}"
        return 0
    fi
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__228_19="${ret_chooser_page_start1580_v0}"
    checked_is__1396_v0 "$(( ret_chooser_page_start1580_v0__228_19 + index_16458 ))"
    local ret_checked_is1396_v0__228_8="${ret_checked_is1396_v0}"
    if [ "${ret_checked_is1396_v0__228_8}" != 0 ]; then
        colored_secondary__1280_v0 "✓ ""${truncated_16460}"
        local ret_colored_secondary1280_v0__229_24="${ret_colored_secondary1280_v0}"
        ret_unselected_line1584_v0="${blank_16459}""${ret_colored_secondary1280_v0__229_24}"
        return 0
    fi
    ret_unselected_line1584_v0="${blank_16459}""• ""${truncated_16460}"
    return 0
}

# selected_line(index: Int)
selected_line__1585_v0() {
    local index_16444="${1}"
    option_width__1583_v0 
    local ret_option_width1583_v0__236_49="${ret_option_width1583_v0}"
    cutoff_text__1310_v0 "${_page_81[${index_16444}]?"Index out of bounds (at src/./choose/./engine.ab:236:41)"}" "${ret_option_width1583_v0__236_49}"
    local truncated_16446="${ret_cutoff_text1310_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1280_v0 "${_cursor_76}""${truncated_16446}"
        ret_selected_line1585_v0="${ret_colored_secondary1280_v0}"
        return 0
    fi
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__240_29="${ret_chooser_page_start1580_v0}"
    checked_is__1396_v0 "$(( ret_chooser_page_start1580_v0__240_29 + index_16444 ))"
    local ret_checked_is1396_v0__240_18="${ret_checked_is1396_v0}"
    local mark_16447
    mark_16447="$(if [ "${ret_checked_is1396_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1280_v0 "${_cursor_76}""${mark_16447}""${truncated_16446}"
    ret_selected_line1585_v0="${ret_colored_secondary1280_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1586_v0() {
    local prev_selected_16457="${1}"
    unselected_line__1584_v0 "${prev_selected_16457}"
    local ret_unselected_line1584_v0__247_47="${ret_unselected_line1584_v0}"
    redraw_row__1393_v0 "${_display_count_72}" "${prev_selected_16457}" "${ret_unselected_line1584_v0__247_47}"
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
    local key_16439="${ret_get_key1176_v0}"
    local prev_selected_16440="${_selected_75}"
    local prev_page_16441="${_current_page_74}"
    chooser_page_start__1580_v0 
    local page_start_16442="${ret_chooser_page_start1580_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_16439}" != "_UP" ]; echo $?) || $([ "_${key_16439}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_16439}" != "_DOWN" ]; echo $?) || $([ "_${key_16439}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_16439}" != "_LEFT" ]; echo $?) || $([ "_${key_16439}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_16439}" != "_RIGHT" ]; echo $?) || $([ "_${key_16439}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $(( $([ "_${key_16439}" != "_x" ]; echo $?) || $([ "_${key_16439}" != "_X" ]; echo $?) )) || $([ "_${key_16439}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1398_v0 "$(( page_start_16442 + _selected_75 ))"
        local ret_checked_toggle1398_v0__310_16="${ret_checked_toggle1398_v0}"
        if [ "${ret_checked_toggle1398_v0__310_16}" != 0 ]; then
            redraw_current_line__1587_v0 
        fi
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $(( $([ "_${key_16439}" != "_a" ]; echo $?) || $([ "_${key_16439}" != "_A" ]; echo $?) )) || $([ "_${key_16439}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_16439}" != "_INPUT" ]; echo $?) || $([ "_${key_16439}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step1588_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_16441 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1588_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_16440 != _selected_75 ))" != 0 ]; then
        redraw_selection__1586_v0 "${prev_selected_16440}"
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
    local index_16467="${1}"
    checked_is__1396_v0 "${index_16467}"
    ret_chooser_is_checked1590_v0="${ret_checked_is1396_v0}"
    return 0
}

# chooser_end()
chooser_end__1591_v0() {
    local total_lines_16462="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_16462="$(( total_lines_16462 + 1 ))"
    fi
    go_down__1233_v0 1
    remove_line__1228_v0 "$(( total_lines_16462 - 1 ))"
    remove_current_line__1229_v0 
    stty_unlock__1219_v0 
    show_cursor__1236_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1600_v0() {
    local options_16471=("${!1}")
    local cursor_16472="${2}"
    local header_16473="${3}"
    local page_size_16474="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_290=("${options_16471[@]}")
    local total_16475="${#__length_290[@]}"
    if [ "$(( total_16475 == 0 ))" != 0 ]; then
        eprintf_colored__1179_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1579_v0 "${total_16475}" "${page_size_16474}" "${header_16473}" "${cursor_16472}" 0 -1
    local need_page_16476=1
    while :
    do
        if [ "${need_page_16476}" != 0 ]; then
            local page_16477=()
            chooser_page_start__1580_v0 
            local start_16478="${ret_chooser_page_start1580_v0}"
            chooser_page_count__1581_v0 
            local count_16479="${ret_chooser_page_count1581_v0}"
            local __range_start_16480="${start_16478}"
            local __range_end_16480="$(( start_16478 + count_16479 ))"
            local __dir_16480=$(( ${__range_start_16480} <= ${__range_end_16480} ? 1 : -1 ))
            for (( i_16480=${__range_start_16480}; i_16480 * ${__dir_16480} < ${__range_end_16480} * ${__dir_16480}; i_16480+=${__dir_16480} )); do
                local array_292=("${options_16471[${i_16480}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_16477+=("${array_292[@]}")
done
            chooser_set_page__1582_v0 page_16477[@]
        fi
        chooser_step__1588_v0 
        local step_16481="${ret_chooser_step1588_v0}"
        if [ "$(( step_16481 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_16476="$(( step_16481 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1589_v0 
    local selected_16482="${ret_chooser_selected1589_v0}"
    chooser_end__1591_v0 
    ret_xyl_choose1600_v0="${options_16471[${selected_16482}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1601_v0() {
    local options_16334=("${!1}")
    local cursor_16335="${2}"
    local header_16336="${3}"
    local limit_16337="${4}"
    local page_size_16338="${5}"
    local __length_293=("${options_16334[@]}")
    local total_16339="${#__length_293[@]}"
    if [ "$(( total_16339 == 0 ))" != 0 ]; then
        eprintf_colored__1179_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1601_v0=()
        return 0
    fi
    chooser_begin__1579_v0 "${total_16339}" "${page_size_16338}" "${header_16336}" "${cursor_16335}" 1 "${limit_16337}"
    local need_page_16411=1
    while :
    do
        if [ "${need_page_16411}" != 0 ]; then
            local page_16412=()
            chooser_page_start__1580_v0 
            local start_16413="${ret_chooser_page_start1580_v0}"
            chooser_page_count__1581_v0 
            local count_16416="${ret_chooser_page_count1581_v0}"
            local __range_start_16417="${start_16413}"
            local __range_end_16417="$(( start_16413 + count_16416 ))"
            local __dir_16417=$(( ${__range_start_16417} <= ${__range_end_16417} ? 1 : -1 ))
            for (( i_16417=${__range_start_16417}; i_16417 * ${__dir_16417} < ${__range_end_16417} * ${__dir_16417}; i_16417+=${__dir_16417} )); do
                local array_296=("${options_16334[${i_16417}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_16412+=("${array_296[@]}")
done
            chooser_set_page__1582_v0 page_16412[@]
        fi
        chooser_step__1588_v0 
        local step_16461="${ret_chooser_step1588_v0}"
        if [ "$(( step_16461 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_16411="$(( step_16461 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1591_v0 
    local result_16465=()
    local __range_start_16466=0
    local __range_end_16466="${total_16339}"
    local __dir_16466=$(( ${__range_start_16466} <= ${__range_end_16466} ? 1 : -1 ))
    for (( i_16466=${__range_start_16466}; i_16466 * ${__dir_16466} < ${__range_end_16466} * ${__dir_16466}; i_16466+=${__dir_16466} )); do
        chooser_is_checked__1590_v0 "${i_16466}"
        local ret_chooser_is_checked1590_v0__93_12="${ret_chooser_is_checked1590_v0}"
        if [ "${ret_chooser_is_checked1590_v0__93_12}" != 0 ]; then
            local array_298=("${options_16334[${i_16466}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_16465+=("${array_298[@]}")
        fi
done
    ret_xyl_multi_choose1601_v0=("${result_16465[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1702_v0() {
    local usage_16260=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1237_v0 usage_16260[@]
    printf '%s\n' ""
    colored_primary__1279_v0 "choose"
    local ret_colored_primary1279_v0__8_20="${ret_colored_primary1279_v0}"
    local title_16284=("${ret_colored_primary1279_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1237_v0 title_16284[@]
    printf '%s\n' ""
    colored_secondary__1280_v0 "Arguments:"
    local ret_colored_secondary1280_v0__11_12="${ret_colored_secondary1280_v0}"
    local array_301=()
    printf__128_v0 "${ret_colored_secondary1280_v0__11_12}""
" array_301[@]
    local arg_names_16286=("[<options> ...]")
    local arg_texts_16287=("List of options to choose from")
    local arg_notes_16288=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1412_v0 arg_names_16286[@] arg_texts_16287[@] arg_notes_16288[@] 20
    printf '%s\n' ""
    colored_secondary__1280_v0 "Flags:"
    local ret_colored_secondary1280_v0__18_12="${ret_colored_secondary1280_v0}"
    local array_305=()
    printf__128_v0 "${ret_colored_secondary1280_v0__18_12}""
" array_305[@]
    local names_16321=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_16322=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_16323=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1412_v0 names_16321[@] texts_16322[@] notes_16323[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1760_v0() {
    local options_16253=()
    local command_310
    command_310="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_16254="${command_310}"
    if [ "$([ "_${is_tty_16254}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_16253+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1760_v0=("${options_16253[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1761_v0() {
    local parameters_16237=("${!1}")
    local cursor_16238="> "
    colored_primary__1279_v0 "Choose: "
    local ret_colored_primary1279_v0__17_30="${ret_colored_primary1279_v0}"
    local header_16252="\\x1b[1m""${ret_colored_primary1279_v0__17_30}"
    read_stdin_options__1760_v0 
    local options_16255=("${ret_read_stdin_options1760_v0[@]}")
    local multi_16256=0
    local limit_16257=-1
    local page_size_16258=10
    local __length_314=("${parameters_16237[@]}")
    local slice_upper_313="${#__length_314[@]}"
    local slice_offset_315=2
    local slice_offset_315=$((${slice_offset_315} > 0 ? ${slice_offset_315} : 0))
    local slice_length_316="$(( slice_upper_313 - slice_offset_315 ))"
    local slice_length_316=$((${slice_length_316} > 0 ? ${slice_length_316} : 0))
    for param_16259 in "${parameters_16237[@]:${slice_offset_315}:${slice_length_316}}"; do
        starts_with__22_v0 "${param_16259}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16259}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16259}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16259}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16259}" != "_-h" ]; echo $?) || $([ "_${param_16259}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1702_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_317="--cursor="
            slice__24_v0 "${param_16259}" "${#__length_317}" 0
            cursor_16238="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_318="--header="
            slice__24_v0 "${param_16259}" "${#__length_318}" 0
            header_16252="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_319="--limit="
            slice__24_v0 "${param_16259}" "${#__length_319}" 0
            local value_16324="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16324}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1179_v0 "ERROR: Invalid limit value: ""${value_16324}""
" 31
                exit 1
            fi
            limit_16257="${ret_parse_int13_v0}"
            multi_16256=1
        elif [ "$([ "_${param_16259}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_16256=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_320="--page-size="
            slice__24_v0 "${param_16259}" "${#__length_320}" 0
            local value_16329="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16329}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1179_v0 "ERROR: Invalid page-size value: ""${value_16329}""
" 31
                exit 1
            fi
            page_size_16258="${ret_parse_int13_v0}"
        else
            options_16255+=("${param_16259}")
        fi
    done
    has_ansi_escape__1303_v0 "${header_16252}"
    local ret_has_ansi_escape1303_v0__59_44="${ret_has_ansi_escape1303_v0}"
    escape_ansi__1304_v0 "${header_16252}"
    local ret_escape_ansi1304_v0__59_73="${ret_escape_ansi1304_v0}"
    colored_primary__1279_v0 "${header_16252}"
    local ret_colored_primary1279_v0__59_111="${ret_colored_primary1279_v0}"
    local display_header_16333
    display_header_16333="$(if [ "$(( $([ "_${header_16252}" != "_" ]; echo $?) || ret_has_ansi_escape1303_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1304_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1279_v0__59_111}"; fi)"
    if [ "${multi_16256}" != 0 ]; then
        xyl_multi_choose__1601_v0 options_16255[@] "${cursor_16238}" "${display_header_16333}" "${limit_16257}" "${page_size_16258}"
        local results_16468=("${ret_xyl_multi_choose1601_v0[@]}")
        join__7_v0 results_16468[@] "
"
        ret_execute_choose1761_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1600_v0 options_16255[@] "${cursor_16238}" "${display_header_16333}" "${page_size_16258}"
    ret_execute_choose1761_v0="${ret_xyl_choose1600_v0}"
    return 0
}

# get_key()
get_key__1846_v0() {
    local command_322
    command_322="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1846_v0="${command_322}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1848_v0() {
    local format_24858="${1}"
    local args_24859=("${!2}")
    args_24859=("${format_24858}" "${args_24859[@]}")
    __status=$?
    printf "${args_24859[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1849_v0() {
    local message_24856="${1}"
    local color_24857="${2}"
    # Prints an error message with a specified color.
    local array_323=("${message_24856}")
    eprintf__1848_v0 "\\x1b[${color_24857}m%s\\x1b[0m" array_323[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1864_v0() {
    local format_24876="${1}"
    local args_24877=("${!2}")
    args_24877=("${format_24876}" "${args_24877[@]}")
    __status=$?
    printf "${args_24877[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_90="None"
# perl_available()
perl_available__1871_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_324
        command_324="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_24801
        disabled_24801="$([ "_${command_324}" != "_No" ]; echo $?)"
        local command_325
        command_325="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_24802
        found_24802="$(( $(( ! disabled_24801 )) && $([ "_${command_325}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_24802}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1871_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1872_v0() {
    local text_24800="${1}"
    perl_available__1871_v0 
    local ret_perl_available1871_v0__19_12="${ret_perl_available1871_v0}"
    if [ "$(( ! ret_perl_available1871_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1872_v0=''
        return 1
    fi
    local command_326
    command_326="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_24800}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1872_v0=''
        return "${__status}"
    fi
    local width_str_24803="${command_326}"
    parse_int__13_v0 "${width_str_24803}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1872_v0=''
        return "${__status}"
    fi
    local width_24804="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1872_v0="${width_24804}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1877_v0() {
    local text_24793="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_327
    command_327="$([[ "${text_24793}" == *$'\x1b'* || "${text_24793}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_24794="${command_327}"
    ret_has_ansi_escape1877_v0="$([ "_${has_escape_24794}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1879_v0() {
    local text_24796="${1}"
    local command_328
    command_328="$(printf "%s" "${text_24796}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1879_v0="${command_328}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1880_v0() {
    local text_24798="${1}"
    local command_329
    command_329="$(printf "%s" "${text_24798}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_24799="${command_329}"
    ret_is_all_ascii1880_v0="$([ "_${result_24799}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1881_v0() {
    local text_24795="${1}"
    strip_ansi__1879_v0 "${text_24795}"
    local stripped_24797="${ret_strip_ansi1879_v0}"
    # Check if text is all ASCII
    is_all_ascii__1880_v0 "${stripped_24797}"
    local ret_is_all_ascii1880_v0__36_12="${ret_is_all_ascii1880_v0}"
    if [ "$(( ! ret_is_all_ascii1880_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1872_v0 "${stripped_24797}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_330="${stripped_24797}"
            ret_get_visible_len1881_v0="${#__length_330}"
            return 0
        fi
        ret_get_visible_len1881_v0="${ret_perl_get_cjk_width1872_v0}"
        return 0
    else
        local __length_331="${stripped_24797}"
        ret_get_visible_len1881_v0="${#__length_331}"
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
stty_count__1887_v0() {
    local command_333
    command_333="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_24874="${command_333}"
    parse_int__13_v0 "${count_24874}"
    __status=$?
    ret_stty_count1887_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1888_v0() {
    stty_count__1887_v0 
    local count_num_24875="${ret_stty_count1887_v0}"
    if [ "$(( count_num_24875 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_24875="$(( count_num_24875 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_24875}
    __status=$?
}

# stty_unlock()
stty_unlock__1889_v0() {
    stty_count__1887_v0 
    local count_num_24973="${ret_stty_count1887_v0}"
    if [ "$(( count_num_24973 > 0 ))" != 0 ]; then
        count_num_24973="$(( count_num_24973 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_24973}
        __status=$?
        if [ "$(( count_num_24973 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1890_v0() {
    local size_24784="${1}"
    if [ "$([ "_${size_24784}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1890_v0=0
        return 0
    fi
    split__4_v0 "${size_24784}" " "
    local parts_24785=("${ret_split4_v0[@]}")
    local __length_334=("${parts_24785[@]}")
    if [ "$(( ${#__length_334[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1890_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_24785[1]?"Index out of bounds (at src/./filter/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_24785[0]?"Index out of bounds (at src/./filter/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_92=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1890_v0=1
    return 0
}

# query_term_size()
query_term_size__1891_v0() {
    local command_336
    command_336="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_24787="${command_336}"
    store_term_size__1890_v0 "${size_24787}"
    ret_query_term_size1891_v0="${ret_store_term_size1890_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1892_v0() {
    local command_337
    command_337="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_24783="${command_337}"
    store_term_size__1890_v0 "${size_24783}"
    ret_stty_term_size1892_v0="${ret_store_term_size1890_v0}"
    return 0
}

# get_term_size()
get_term_size__1893_v0() {
    stty_term_size__1892_v0 
    local detected_24786="${ret_stty_term_size1892_v0}"
    if [ "$(( ! detected_24786 ))" != 0 ]; then
        query_term_size__1891_v0 
        detected_24786="${ret_query_term_size1891_v0}"
    fi
    _got_term_size_91=1
}

# term_width()
term_width__1895_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1893_v0 
    fi
    ret_term_width1895_v0="${_term_size_92[0]?"Index out of bounds (at src/./filter/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1896_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1893_v0 
    fi
    ret_term_height1896_v0="${_term_size_92[1]?"Index out of bounds (at src/./filter/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1898_v0() {
    local cnt_24970="${1}"
    if [ "$(( cnt_24970 > 0 ))" != 0 ]; then
        local sequence_24971=""
        local __range_start_24972=0
        local __range_end_24972="${cnt_24970}"
        local __dir_24972=$(( ${__range_start_24972} <= ${__range_end_24972} ? 1 : -1 ))
        for (( ____24972=${__range_start_24972}; ____24972 * ${__dir_24972} < ${__range_end_24972} * ${__dir_24972}; ____24972+=${__dir_24972} )); do
            sequence_24971+="\\x1b[2K\\x1b[1A"
done
        local array_338=("")
        eprintf__1864_v0 "${sequence_24971}" array_338[@]
    fi
    local array_339=("")
    eprintf__1864_v0 "\\x1b[G" array_339[@]
}

# remove_current_line()
remove_current_line__1899_v0() {
    local array_340=("")
    eprintf__1864_v0 "\\x1b[2K\\x1b[G" array_340[@]
}

# new_line(cnt: Int)
new_line__1901_v0() {
    local cnt_24919="${1}"
    local __range_start_24920=0
    local __range_end_24920="${cnt_24919}"
    local __dir_24920=$(( ${__range_start_24920} <= ${__range_end_24920} ? 1 : -1 ))
    for (( ____24920=${__range_start_24920}; ____24920 * ${__dir_24920} < ${__range_end_24920} * ${__dir_24920}; ____24920+=${__dir_24920} )); do
        local array_341=("")
        eprintf__1864_v0 "
" array_341[@]
done
}

# go_up(cnt: Int)
go_up__1902_v0() {
    local cnt_24938="${1}"
    local array_342=("")
    eprintf__1864_v0 "\\x1b[${cnt_24938}A" array_342[@]
}

# go_down(cnt: Int)
go_down__1903_v0() {
    local cnt_24952="${1}"
    local array_343=("")
    eprintf__1864_v0 "\\x1b[${cnt_24952}B" array_343[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1905_v0() {
    local array_344=("")
    eprintf__1864_v0 "\\x1b[?25l" array_344[@]
}

# show_cursor()
show_cursor__1906_v0() {
    local array_345=("")
    eprintf__1864_v0 "\\x1b[?25h" array_345[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1907_v0() {
    local pieces_24782=("${!1}")
    term_width__1895_v0 
    local width_24788="${ret_term_width1895_v0}"
    local line_24789=""
    local line_len_24790=0
    for piece_24791 in "${pieces_24782[@]}"; do
        local __length_348="${piece_24791}"
        local piece_len_24792="${#__length_348}"
        has_ansi_escape__1877_v0 "${piece_24791}"
        local ret_has_ansi_escape1877_v0__186_12="${ret_has_ansi_escape1877_v0}"
        if [ "${ret_has_ansi_escape1877_v0__186_12}" != 0 ]; then
            get_visible_len__1881_v0 "${piece_24791}"
            piece_len_24792="${ret_get_visible_len1881_v0}"
        fi
        if [ "$([ "_${line_24789}" != "_" ]; echo $?)" != 0 ]; then
            line_24789="${piece_24791}"
            line_len_24790="${piece_len_24792}"
        elif [ "$(( $(( $(( line_len_24790 + 1 )) + piece_len_24792 )) > width_24788 ))" != 0 ]; then
            local array_349=()
            printf__128_v0 "${line_24789}""
" array_349[@]
            line_24789="${piece_24791}"
            line_len_24790="${piece_len_24792}"
        else
            line_24789+=" ""${piece_24791}"
            line_len_24790="$(( line_len_24790 + $(( 1 + piece_len_24792 )) ))"
        fi
    done
    if [ "$([ "_${line_24789}" == "_" ]; echo $?)" != 0 ]; then
        local array_350=()
        printf__128_v0 "${line_24789}""
" array_350[@]
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
get_supports_truecolor__1944_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_24817="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_24817}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1944_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1945_v0() {
    local message_24812="${1}"
    local r_24813="${2}"
    local g_24814="${3}"
    local b_24815="${4}"
    local fallback_24816="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1945_v0="\\x1b[38;2;${r_24813};${g_24814};${b_24815}m""${message_24812}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1944_v0 
        local ret_get_supports_truecolor1944_v0__45_17="${ret_get_supports_truecolor1944_v0}"
        if [ "${ret_get_supports_truecolor1944_v0__45_17}" != 0 ]; then
            ret_colored_rgb1945_v0="\\x1b[38;2;${r_24813};${g_24814};${b_24815}m""${message_24812}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_24816 == 0 ))" != 0 ]; then
            ret_colored_rgb1945_v0="${message_24812}"
            return 0
        else
            ret_colored_rgb1945_v0="\\x1b[${fallback_24816}m""${message_24812}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_24816 == 0 ))" != 0 ]; then
            ret_colored_rgb1945_v0="${message_24812}"
            return 0
        fi
        ret_colored_rgb1945_v0="\\x1b[${fallback_24816}m""${message_24812}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1947_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_24806="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_24806}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_24806}" ";"
            local parts_24807=("${ret_split4_v0[@]}")
            local __length_354=("${parts_24807[@]}")
            if [ "$(( ${#__length_354[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_24807[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24807[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24807[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24807[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_97=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_24808="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_24808}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_24808}" ";"
            local parts_24809=("${ret_split4_v0[@]}")
            local __length_356=("${parts_24809[@]}")
            if [ "$(( ${#__length_356[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_24809[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24809[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24809[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24809[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_98=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_24810="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_24810}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_24810}" ";"
            local parts_24811=("${ret_split4_v0[@]}")
            local __length_358=("${parts_24811[@]}")
            if [ "$(( ${#__length_358[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_24811[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24811[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24811[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_24811[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1947_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_96=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1948_v0() {
    inner_get_xylitol_colors__1947_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_96=1
}

# colored_primary(message: Text)
colored_primary__1949_v0() {
    local message_24805="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1948_v0 
    fi
    colored_rgb__1945_v0 "${message_24805}" "${_primary_color_97[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1949_v0="${ret_colored_rgb1945_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1950_v0() {
    local message_24819="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1948_v0 
    fi
    colored_rgb__1945_v0 "${message_24819}" "${_secondary_color_98[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1950_v0="${ret_colored_rgb1945_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_100="None"
# perl_available()
perl_available__1967_v0() {
    if [ "$([ "_${_perl_state_100}" != "_None" ]; echo $?)" != 0 ]; then
        local command_360
        command_360="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_24891
        disabled_24891="$([ "_${command_360}" != "_No" ]; echo $?)"
        local command_361
        command_361="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_24892
        found_24892="$(( $(( ! disabled_24891 )) && $([ "_${command_361}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_24892}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1967_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1968_v0() {
    local text_24890="${1}"
    perl_available__1967_v0 
    local ret_perl_available1967_v0__19_12="${ret_perl_available1967_v0}"
    if [ "$(( ! ret_perl_available1967_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1968_v0=''
        return 1
    fi
    local command_362
    command_362="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_24890}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1968_v0=''
        return "${__status}"
    fi
    local width_str_24893="${command_362}"
    parse_int__13_v0 "${width_str_24893}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1968_v0=''
        return "${__status}"
    fi
    local width_24894="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1968_v0="${width_24894}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1969_v0() {
    local text_24901="${1}"
    local max_width_24902="${2}"
    perl_available__1967_v0 
    local ret_perl_available1967_v0__30_12="${ret_perl_available1967_v0}"
    if [ "$(( ! ret_perl_available1967_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1969_v0=''
        return 1
    fi
    local command_363
    command_363="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_24901}" ${max_width_24902} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1969_v0=''
        return "${__status}"
    fi
    local result_24903="${command_363}"
    ret_perl_truncate_cjk1969_v0="${result_24903}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1973_v0() {
    local text_24861="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_364
    command_364="$([[ "${text_24861}" == *$'\x1b'* || "${text_24861}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_24862="${command_364}"
    ret_has_ansi_escape1973_v0="$([ "_${has_escape_24862}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1974_v0() {
    local text_24863="${1}"
    local command_365
    command_365="$(printf '%s' "${text_24863}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1974_v0="${command_365}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1975_v0() {
    local text_24886="${1}"
    local command_366
    command_366="$(printf "%s" "${text_24886}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1975_v0="${command_366}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1976_v0() {
    local text_24888="${1}"
    local command_367
    command_367="$(printf "%s" "${text_24888}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_24889="${command_367}"
    ret_is_all_ascii1976_v0="$([ "_${result_24889}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1977_v0() {
    local text_24885="${1}"
    strip_ansi__1975_v0 "${text_24885}"
    local stripped_24887="${ret_strip_ansi1975_v0}"
    # Check if text is all ASCII
    is_all_ascii__1976_v0 "${stripped_24887}"
    local ret_is_all_ascii1976_v0__36_12="${ret_is_all_ascii1976_v0}"
    if [ "$(( ! ret_is_all_ascii1976_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1968_v0 "${stripped_24887}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_368="${stripped_24887}"
            ret_get_visible_len1977_v0="${#__length_368}"
            return 0
        fi
        ret_get_visible_len1977_v0="${ret_perl_get_cjk_width1968_v0}"
        return 0
    else
        local __length_369="${stripped_24887}"
        ret_get_visible_len1977_v0="${#__length_369}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1978_v0() {
    local text_24898="${1}"
    local max_width_24899="${2}"
    get_visible_len__1977_v0 "${text_24898}"
    local visible_len_24900="${ret_get_visible_len1977_v0}"
    if [ "$(( visible_len_24900 <= max_width_24899 ))" != 0 ]; then
        ret_truncate_text1978_v0="${text_24898}"
        return 0
    fi
    is_all_ascii__1976_v0 "${text_24898}"
    local ret_is_all_ascii1976_v0__53_12="${ret_is_all_ascii1976_v0}"
    if [ "$(( ! ret_is_all_ascii1976_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1969_v0 "${text_24898}" "${max_width_24899}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_24898}" | cut -c1-${max_width_24899}
            __status=$?
        fi
        ret_truncate_text1978_v0="${ret_perl_truncate_cjk1969_v0}"
        return 0
    fi
    local command_370
    command_370="$(printf "%s" "${text_24898}" | cut -c1-${max_width_24899})"
    __status=$?
    ret_truncate_text1978_v0="${command_370}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1979_v0() {
    local text_24896="${1}"
    local max_width_24897="${2}"
    has_ansi_escape__1973_v0 "${text_24896}"
    local ret_has_ansi_escape1973_v0__65_12="${ret_has_ansi_escape1973_v0}"
    if [ "$(( ! ret_has_ansi_escape1973_v0__65_12 ))" != 0 ]; then
        truncate_text__1978_v0 "${text_24896}" "${max_width_24897}"
        ret_truncate_ansi1979_v0="${ret_truncate_text1978_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_371
    command_371="$([[ "${text_24896}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_24904="${command_371}"
    # Replace \x1b[ with newline, then split
    local command_372
    command_372="$(t="${text_24896}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_24905="${command_372}"
    split__4_v0 "${replaced_24905}" "
"
    local parts_24906=("${ret_split4_v0[@]}")
    local result_24907=""
    local remaining_width_24908="${max_width_24897}"
    local __range_start_24909=0
    local __length_373=("${parts_24906[@]}")
    local __range_end_24909="${#__length_373[@]}"
    local __dir_24909=$(( ${__range_start_24909} <= ${__range_end_24909} ? 1 : -1 ))
    for (( idx_24909=${__range_start_24909}; idx_24909 * ${__dir_24909} < ${__range_end_24909} * ${__dir_24909}; idx_24909+=${__dir_24909} )); do
        local part_24910="${parts_24906[${idx_24909}]?"Index out of bounds (at src/./filter/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_24909 == 0 )) && $([ "_${starts_with_ansi_24904}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_24910}" == "_" ]; echo $?) && $(( remaining_width_24908 > 0 )) ))" != 0 ]; then
                truncate_text__1978_v0 "${part_24910}" "${remaining_width_24908}"
                local ret_truncate_text1978_v0__87_35="${ret_truncate_text1978_v0}"
                local truncated_24911="${ret_truncate_text1978_v0__87_35}"
                result_24907+="${truncated_24911}"
                get_visible_len__1977_v0 "${truncated_24911}"
                local ret_get_visible_len1977_v0__89_36="${ret_get_visible_len1977_v0}"
                remaining_width_24908="$(( remaining_width_24908 - ret_get_visible_len1977_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_374
            command_374="$(__p="${part_24910}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_24912="${command_374}"
            if [ "$([ "_${m_idx_24912}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_375
                command_375="$(__p="${part_24910}"; printf "%s" "${__p:0:${m_idx_24912}}")"
                __status=$?
                local ansi_params_24913="${command_375}"
                result_24907+="\\x1b[""${ansi_params_24913}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_24912}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_24914="${ret_parse_int13_v0__100_41}"
                local text_start_24915="$(( m_idx_num_24914 + 1 ))"
                local command_376
                command_376="$(__p="${part_24910}"; printf "%s" "${__p:${text_start_24915}}")"
                __status=$?
                local text_part_24916="${command_376}"
                if [ "$(( $([ "_${text_part_24916}" == "_" ]; echo $?) && $(( remaining_width_24908 > 0 )) ))" != 0 ]; then
                    truncate_text__1978_v0 "${text_part_24916}" "${remaining_width_24908}"
                    local ret_truncate_text1978_v0__104_39="${ret_truncate_text1978_v0}"
                    local truncated_24917="${ret_truncate_text1978_v0__104_39}"
                    result_24907+="${truncated_24917}"
                    get_visible_len__1977_v0 "${truncated_24917}"
                    local ret_get_visible_len1977_v0__106_40="${ret_get_visible_len1977_v0}"
                    remaining_width_24908="$(( remaining_width_24908 - ret_get_visible_len1977_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_24910}" == "_" ]; echo $?) && $(( remaining_width_24908 > 0 )) ))" != 0 ]; then
                    truncate_text__1978_v0 "${part_24910}" "${remaining_width_24908}"
                    local ret_truncate_text1978_v0__111_39="${ret_truncate_text1978_v0}"
                    local truncated_24918="${ret_truncate_text1978_v0__111_39}"
                    result_24907+="${truncated_24918}"
                    get_visible_len__1977_v0 "${truncated_24918}"
                    local ret_get_visible_len1977_v0__113_40="${ret_get_visible_len1977_v0}"
                    remaining_width_24908="$(( remaining_width_24908 - ret_get_visible_len1977_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1979_v0="${result_24907}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1980_v0() {
    local text_24883="${1}"
    local max_width_24884="${2}"
    get_visible_len__1977_v0 "${text_24883}"
    local visible_len_24895="${ret_get_visible_len1977_v0}"
    if [ "$(( visible_len_24895 <= max_width_24884 ))" != 0 ]; then
        ret_cutoff_text1980_v0="${text_24883}"
        return 0
    fi
    truncate_ansi__1979_v0 "${text_24883}" "$(( max_width_24884 - 3 ))"
    local ret_truncate_ansi1979_v0__129_12="${ret_truncate_ansi1979_v0}"
    ret_cutoff_text1980_v0="${ret_truncate_ansi1979_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2001_v0() {
    local format_24929="${1}"
    local args_24930=("${!2}")
    args_24930=("${format_24929}" "${args_24930[@]}")
    __status=$?
    printf "${args_24930[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2002_v0() {
    local message_24927="${1}"
    local color_24928="${2}"
    # Prints an error message with a specified color.
    local array_377=("${message_24927}")
    eprintf__2001_v0 "\\x1b[${color_24928}m%s\\x1b[0m" array_377[@]
}

# colored(message: Text, color: Int)
colored__2003_v0() {
    local message_24850="${1}"
    local color_24851="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2003_v0="\\x1b[${color_24851}m""${message_24850}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2007_v0() {
    local items_24921=("${!1}")
    local total_len_24922="${2}"
    local term_width_24923="${3}"
    local separator_24924=" • "
    local separator_len_24925=3
    # Fast path: no truncation needed
    if [ "$(( total_len_24922 <= term_width_24923 ))" != 0 ]; then
        local iter_24926=0
        while :
        do
            local __length_378=("${items_24921[@]}")
            if [ "$(( iter_24926 >= ${#__length_378[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_24926 > 0 ))" != 0 ]; then
                eprintf_colored__2002_v0 "${separator_24924}" 90
            fi
            colored__2003_v0 "${items_24921[$(( iter_24926 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2003_v0__23_41="${ret_colored2003_v0}"
            local array_379=("")
            eprintf__2001_v0 "${items_24921[${iter_24926}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2003_v0__23_41}" array_379[@]
            iter_24926="$(( iter_24926 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_24931=0
        local first_24932=1
        local iter_24933=0
        while :
        do
            local __length_380=("${items_24921[@]}")
            if [ "$(( iter_24933 >= ${#__length_380[@]} ))" != 0 ]; then
                break
            fi
            local key_24934="${items_24921[${iter_24933}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:35:31)"}"
            local action_24935="${items_24921[$(( iter_24933 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:36:34)"}"
            local __length_381="${key_24934}"
            local __length_382="${action_24935}"
            local part_len_24936="$(( $(( ${#__length_381} + 1 )) + ${#__length_382} ))"
            local needed_24937="${part_len_24936}"
            if [ "$(( ! first_24932 ))" != 0 ]; then
                needed_24937="$(( needed_24937 + separator_len_24925 ))"
            fi
            if [ "$(( $(( current_len_24931 + needed_24937 )) > term_width_24923 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_24932 ))" != 0 ]; then
                eprintf_colored__2002_v0 "${separator_24924}" 90
            fi
            colored__2003_v0 "${action_24935}" 2
            local ret_colored2003_v0__51_33="${ret_colored2003_v0}"
            local array_383=("")
            eprintf__2001_v0 "${key_24934}"" ""${ret_colored2003_v0__51_33}" array_383[@]
            current_len_24931="$(( current_len_24931 + needed_24937 ))"
            first_24932=0
            iter_24933="$(( iter_24933 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2017_v0() {
    local format_24962="${1}"
    local args_24963=("${!2}")
    args_24963=("${format_24962}" "${args_24963[@]}")
    __status=$?
    printf "${args_24963[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_103=0
_term_size_104=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__2043_v0() {
    local size_24829="${1}"
    if [ "$([ "_${size_24829}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2043_v0=0
        return 0
    fi
    split__4_v0 "${size_24829}" " "
    local parts_24830=("${ret_split4_v0[@]}")
    local __length_385=("${parts_24830[@]}")
    if [ "$(( ${#__length_385[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2043_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_24830[1]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_24830[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_104=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2043_v0=1
    return 0
}

# query_term_size()
query_term_size__2044_v0() {
    local command_387
    command_387="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_24832="${command_387}"
    store_term_size__2043_v0 "${size_24832}"
    ret_query_term_size2044_v0="${ret_store_term_size2043_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2045_v0() {
    local command_388
    command_388="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_24828="${command_388}"
    store_term_size__2043_v0 "${size_24828}"
    ret_stty_term_size2045_v0="${ret_store_term_size2043_v0}"
    return 0
}

# get_term_size()
get_term_size__2046_v0() {
    stty_term_size__2045_v0 
    local detected_24831="${ret_stty_term_size2045_v0}"
    if [ "$(( ! detected_24831 ))" != 0 ]; then
        query_term_size__2044_v0 
        detected_24831="${ret_query_term_size2044_v0}"
    fi
    _got_term_size_103=1
}

# term_width()
term_width__2048_v0() {
    if [ "$(( ! _got_term_size_103 ))" != 0 ]; then
        get_term_size__2046_v0 
    fi
    ret_term_width2048_v0="${_term_size_104[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__2055_v0() {
    local cnt_24961="${1}"
    local array_389=("")
    eprintf__2017_v0 "\\x1b[${cnt_24961}A" array_389[@]
}

# go_down(cnt: Int)
go_down__2056_v0() {
    local cnt_24964="${1}"
    local array_390=("")
    eprintf__2017_v0 "\\x1b[${cnt_24964}B" array_390[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__2063_v0() {
    local display_count_24958="${1}"
    local index_24959="${2}"
    local line_24960="${3}"
    go_up__2055_v0 "$(( display_count_24958 - index_24959 ))"
    local array_391=("")
    eprintf__2001_v0 "\\x1b[G\\x1b[K" array_391[@]
    local array_392=("")
    eprintf__2001_v0 "${line_24960}" array_392[@]
    go_down__2056_v0 "$(( display_count_24958 - index_24959 ))"
    local array_393=("")
    eprintf__2001_v0 "\\x1b[G" array_393[@]
}

# Which items of a multi-select widget are ticked.
_checked_105=()
_count_106=0
_total_107=0
_limit_108=-1
# checked_init(total: Int, limit: Int)
checked_init__2065_v0() {
    local total_24879="${1}"
    local limit_24880="${2}"
    _checked_105=()
    local __range_start_24881=0
    local __range_end_24881="${total_24879}"
    local __dir_24881=$(( ${__range_start_24881} <= ${__range_end_24881} ? 1 : -1 ))
    for (( ____24881=${__range_start_24881}; ____24881 * ${__dir_24881} < ${__range_end_24881} * ${__dir_24881}; ____24881+=${__dir_24881} )); do
        local array_396=(0)
        _checked_105+=("${array_396[@]}")
done
    _count_106=0
    _total_107="${total_24879}"
    _limit_108="${limit_24880}"
}

# checked_is(index: Int)
checked_is__2066_v0() {
    local index_24948="${1}"
    ret_checked_is2066_v0="${_checked_105[${index_24948}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_count()
checked_count__2067_v0() {
    ret_checked_count2067_v0="${_count_106}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__2068_v0() {
    local index_24965="${1}"
    if [ "${_checked_105[${index_24965}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_105["${index_24965}"]=0
        _count_106="$(( _count_106 - 1 ))"
        ret_checked_toggle2068_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_108 >= 0 )) && $(( _count_106 >= _limit_108 )) ))" != 0 ]; then
        ret_checked_toggle2068_v0=0
        return 0
    fi
    _checked_105["${index_24965}"]=1
    _count_106="$(( _count_106 + 1 ))"
    ret_checked_toggle2068_v0=1
    return 0
}

# checked_all()
checked_all__2069_v0() {
    if [ "$(( _limit_108 >= 0 ))" != 0 ]; then
        ret_checked_all2069_v0=0
        return 0
    fi
    local was_all_24966="$(( _count_106 == _total_107 ))"
    local __range_start_24967=0
    local __range_end_24967="${_total_107}"
    local __dir_24967=$(( ${__range_start_24967} <= ${__range_end_24967} ? 1 : -1 ))
    for (( i_24967=${__range_start_24967}; i_24967 * ${__dir_24967} < ${__range_end_24967} * ${__dir_24967}; i_24967+=${__dir_24967} )); do
        _checked_105["${i_24967}"]="$(( ! was_all_24966 ))"
done
    if [ "${was_all_24966}" != 0 ]; then
        _count_106=0
    else
        _count_106="${_total_107}"
    fi
    ret_checked_all2069_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2081_v0() {
    local pending_24847="${1}"
    local line_24848="${2}"
    local note_at_24849="${3}"
    if [ "$(( note_at_24849 < 0 ))" != 0 ]; then
        local array_397=()
        printf__128_v0 "${pending_24847}""${line_24848}""
" array_397[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_24849 == 0 ))" != 0 ]; then
        colored__2003_v0 "${line_24848}" 90
        local ret_colored2003_v0__12_40="${ret_colored2003_v0}"
        local array_398=()
        printf__128_v0 "${pending_24847}""${ret_colored2003_v0__12_40}""
" array_398[@]
    else
        slice__24_v0 "${line_24848}" 0 "${note_at_24849}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_24848}" "${note_at_24849}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2003_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2003_v0__13_58="${ret_colored2003_v0}"
        local array_399=()
        printf__128_v0 "${pending_24847}""${ret_slice24_v0__13_32}""${ret_colored2003_v0__13_58}""
" array_399[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2082_v0() {
    local names_24820=("${!1}")
    local texts_24821=("${!2}")
    local notes_24822=("${!3}")
    local min_name_width_24823="${4}"
    local __length_400=("${names_24820[@]}")
    local count_24824="${#__length_400[@]}"
    local name_width_24825="${min_name_width_24823}"
    local __range_start_24826=0
    local __range_end_24826="${count_24824}"
    local __dir_24826=$(( ${__range_start_24826} <= ${__range_end_24826} ? 1 : -1 ))
    for (( i_24826=${__range_start_24826}; i_24826 * ${__dir_24826} < ${__range_end_24826} * ${__dir_24826}; i_24826+=${__dir_24826} )); do
        local __length_401="${names_24820[${i_24826}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:28:33)"}"
        local width_24827="${#__length_401}"
        if [ "$(( width_24827 > name_width_24825 ))" != 0 ]; then
            name_width_24825="${width_24827}"
        fi
done
    term_width__2048_v0 
    local width_24833="${ret_term_width2048_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_24834="$(( name_width_24825 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_24835="$(( $(( width_24833 - indent_24834 )) < 24 ))"
    if [ "${stacked_24835}" != 0 ]; then
        indent_24834=6
    fi
    local avail_24836="$(( width_24833 - indent_24834 ))"
    rpad__28_v0 "" " " "${indent_24834}"
    local blank_24837="${ret_rpad28_v0}"
    local __range_start_24838=0
    local __range_end_24838="${count_24824}"
    local __dir_24838=$(( ${__range_start_24838} <= ${__range_end_24838} ? 1 : -1 ))
    for (( i_24838=${__range_start_24838}; i_24838 * ${__dir_24838} < ${__range_end_24838} * ${__dir_24838}; i_24838+=${__dir_24838} )); do
        local pending_24839="${blank_24837}"
        if [ "${stacked_24835}" != 0 ]; then
            local array_402=()
            printf__128_v0 "  ""${names_24820[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:48:33)"}""
" array_402[@]
        else
            rpad__28_v0 "  ""${names_24820[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:50:41)"}" " " "${indent_24834}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_24839="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_24821[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_24840=("${ret_split4_v0__52_21[@]}")
        local __length_403=("${words_24840[@]}")
        local note_start_24841="${#__length_403[@]}"
        if [ "$([ "_${notes_24822[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_404="${notes_24822[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_404} > avail_24836 ))" != 0 ]; then
                split__4_v0 "${notes_24822[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_24840+=("${ret_split4_v0__58_26[@]}")
            else
                local array_405=("${notes_24822[${i_24838}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:60:33)"}")
                words_24840+=("${array_405[@]}")
            fi
        fi
        local line_24842=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_24843=-1
        local __range_start_24844=0
        local __length_406=("${words_24840[@]}")
        local __range_end_24844="${#__length_406[@]}"
        local __dir_24844=$(( ${__range_start_24844} <= ${__range_end_24844} ? 1 : -1 ))
        for (( j_24844=${__range_start_24844}; j_24844 * ${__dir_24844} < ${__range_end_24844} * ${__dir_24844}; j_24844+=${__dir_24844} )); do
            local word_24845="${words_24840[${j_24844}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:70:32)"}"
            local candidate_24846
            candidate_24846="$(if [ "$([ "_${line_24842}" != "_" ]; echo $?)" != 0 ]; then echo "${word_24845}"; else echo "${line_24842}"" ""${word_24845}"; fi)"
            local __length_407="${candidate_24846}"
            if [ "$(( $(( ${#__length_407} > avail_24836 )) && $([ "_${line_24842}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2081_v0 "${pending_24839}" "${line_24842}" "${note_at_24843}"
                pending_24839="${blank_24837}"
                line_24842="${word_24845}"
                note_at_24843="$(if [ "$(( j_24844 >= note_start_24841 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_24844 >= note_start_24841 )) && $(( note_at_24843 < 0 )) ))" != 0 ]; then
                    local __length_408="${candidate_24846}"
                    local __length_409="${word_24845}"
                    note_at_24843="$(( ${#__length_408} - ${#__length_409} ))"
                fi
                line_24842="${candidate_24846}"
            fi
done
        print_help_line__2081_v0 "${pending_24839}" "${line_24842}" "${note_at_24843}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
_options_110=()
# Positions in `_options` that the query keeps, as text so that no parsing
# happens until a row is drawn.
_matches_111=()
_query_112=""
_placeholder_113=""
_prompt_114="> "
_cursor_115="> "
_height_116=10
# First match shown, so the window scrolls without repaging.
_offset_117=0
# Highlighted row inside the window.
_sel_118=0
_multi_119=0
_has_header_120=0
_term_width_121=80
# refresh_matches()
refresh_matches__2140_v0() {
    local command_412
    command_412="$(shopt -s nocasematch; __r=""; __i=0; for __it in "${_options_110[@]}"; do case "$__it" in (*"${_query_112}"*) __r="$__r $__i";; esac; __i=$((__i+1)); done; printf '%s' "${__r# }")"
    __status=$?
    local raw_24882="${command_412}"
    if [ "$([ "_${raw_24882}" != "_" ]; echo $?)" != 0 ]; then
        _matches_111=()
    else
        split__4_v0 "${raw_24882}" " "
        _matches_111=("${ret_split4_v0[@]}")
    fi
    _offset_117=0
    _sel_118=0
}

# visible_count()
visible_count__2141_v0() {
    local __length_414=("${_matches_111[@]}")
    local count_24939="$(( ${#__length_414[@]} - _offset_117 ))"
    if [ "$(( count_24939 > _height_116 ))" != 0 ]; then
        count_24939="${_height_116}"
    fi
    if [ "$(( count_24939 < 0 ))" != 0 ]; then
        count_24939=0
    fi
    ret_visible_count2141_v0="${count_24939}"
    return 0
}

# option_index(row: Int)
option_index__2142_v0() {
    local row_24944="${1}"
    parse_int__13_v0 "${_matches_111[$(( _offset_117 + row_24944 ))]?"Index out of bounds (at src/./filter/./mod.ab:48:37)"}"
    __status=$?
    ret_option_index2142_v0="${ret_parse_int13_v0}"
    return 0
}

# option_width()
option_width__2143_v0() {
    local check_width_24945
    check_width_24945="$(if [ "${_multi_119}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_415="${_cursor_115}"
    ret_option_width2143_v0="$(( $(( _term_width_121 - ${#__length_415} )) - check_width_24945 ))"
    return 0
}

# row_line(row: Int, highlighted: Bool)
row_line__2144_v0() {
    local row_24942="${1}"
    local highlighted_24943="${2}"
    option_index__2142_v0 "${row_24942}"
    local ret_option_index2142_v0__57_44="${ret_option_index2142_v0}"
    option_width__2143_v0 
    local ret_option_width2143_v0__57_64="${ret_option_width2143_v0}"
    cutoff_text__1980_v0 "${_options_110[${ret_option_index2142_v0__57_44}]?"Index out of bounds (at src/./filter/./mod.ab:57:44)"}" "${ret_option_width2143_v0__57_64}"
    local truncated_24946="${ret_cutoff_text1980_v0}"
    local __length_416="${_cursor_115}"
    rpad__28_v0 "" " " "${#__length_416}"
    local blank_24947="${ret_rpad28_v0}"
    if [ "$(( ! _multi_119 ))" != 0 ]; then
        if [ "${highlighted_24943}" != 0 ]; then
            colored_secondary__1950_v0 "${_cursor_115}""${truncated_24946}"
            ret_row_line2144_v0="${ret_colored_secondary1950_v0}"
            return 0
        fi
        ret_row_line2144_v0="${blank_24947}""${truncated_24946}"
        return 0
    fi
    option_index__2142_v0 "${row_24942}"
    local ret_option_index2142_v0__65_31="${ret_option_index2142_v0}"
    checked_is__2066_v0 "${ret_option_index2142_v0__65_31}"
    local ticked_24949="${ret_checked_is2066_v0}"
    local mark_24950
    mark_24950="$(if [ "${ticked_24949}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    if [ "${highlighted_24943}" != 0 ]; then
        colored_secondary__1950_v0 "${_cursor_115}""${mark_24950}""${truncated_24946}"
        ret_row_line2144_v0="${ret_colored_secondary1950_v0}"
        return 0
    fi
    if [ "${ticked_24949}" != 0 ]; then
        colored_secondary__1950_v0 "${mark_24950}""${truncated_24946}"
        local ret_colored_secondary1950_v0__71_24="${ret_colored_secondary1950_v0}"
        ret_row_line2144_v0="${blank_24947}""${ret_colored_secondary1950_v0__71_24}"
        return 0
    fi
    ret_row_line2144_v0="${blank_24947}""${mark_24950}""${truncated_24946}"
    return 0
}

# render_rows()
render_rows__2145_v0() {
    visible_count__2141_v0 
    local count_24940="${ret_visible_count2141_v0}"
    go_up__1902_v0 "${_height_116}"
    local array_417=("")
    eprintf__1848_v0 "\\x1b[G" array_417[@]
    local __range_start_24941=0
    local __range_end_24941="${count_24940}"
    local __dir_24941=$(( ${__range_start_24941} <= ${__range_end_24941} ? 1 : -1 ))
    for (( row_24941=${__range_start_24941}; row_24941 * ${__dir_24941} < ${__range_end_24941} * ${__dir_24941}; row_24941+=${__dir_24941} )); do
        row_line__2144_v0 "${row_24941}" "$(( row_24941 == _sel_118 ))"
        local ret_row_line2144_v0__82_28="${ret_row_line2144_v0}"
        local array_418=("")
        eprintf__1848_v0 "\\x1b[K""${ret_row_line2144_v0__82_28}""
" array_418[@]
done
    local __range_start_24951="${count_24940}"
    local __range_end_24951="${_height_116}"
    local __dir_24951=$(( ${__range_start_24951} <= ${__range_end_24951} ? 1 : -1 ))
    for (( ____24951=${__range_start_24951}; ____24951 * ${__dir_24951} < ${__range_end_24951} * ${__dir_24951}; ____24951+=${__dir_24951} )); do
        local array_419=("")
        eprintf__1848_v0 "\\x1b[K
" array_419[@]
done
    local array_420=("")
    eprintf__1848_v0 "\\x1b[G" array_420[@]
}

# render_query()
render_query__2146_v0() {
    go_up__1902_v0 "$(( _height_116 + 1 ))"
    local array_421=("")
    eprintf__1848_v0 "\\x1b[G\\x1b[K" array_421[@]
    colored_secondary__1950_v0 "${_prompt_114}"
    local ret_colored_secondary1950_v0__93_13="${ret_colored_secondary1950_v0}"
    local array_422=("")
    eprintf__1848_v0 "${ret_colored_secondary1950_v0__93_13}" array_422[@]
    if [ "$([ "_${_query_112}" != "_" ]; echo $?)" != 0 ]; then
        eprintf_colored__1849_v0 "${_placeholder_113}" 90
    else
        local __length_423="${_prompt_114}"
        cutoff_text__1980_v0 "${_query_112}" "$(( _term_width_121 - ${#__length_423} ))"
        local ret_cutoff_text1980_v0__97_17="${ret_cutoff_text1980_v0}"
        local array_424=("")
        eprintf__1848_v0 "${ret_cutoff_text1980_v0__97_17}" array_424[@]
    fi
    go_down__1903_v0 "$(( _height_116 + 1 ))"
    local array_425=("")
    eprintf__1848_v0 "\\x1b[G" array_425[@]
}

# render_count()
render_count__2147_v0() {
    local array_426=("")
    eprintf__1848_v0 "\\x1b[K" array_426[@]
    local __length_427=("${_matches_111[@]}")
    local __length_428=("${_options_110[@]}")
    eprintf_colored__1849_v0 "${#__length_427[@]}/${#__length_428[@]}" 90
    local array_429=("")
    eprintf__1848_v0 "\\x1b[G" array_429[@]
}

# render_tooltip_line()
render_tooltip_line__2148_v0() {
    if [ "${_multi_119}" != 0 ]; then
        local array_430=("↑↓" "select" "tab" "toggle" "ctrl-a" "all" "enter" "confirm")
        render_tooltip__2007_v0 array_430[@] 51 "${_term_width_121}"
    else
        local array_431=("↑↓" "select" "enter" "confirm")
        render_tooltip__2007_v0 array_431[@] 25 "${_term_width_121}"
    fi
}

# move_selection(step: Int)
move_selection__2149_v0() {
    local step_24954="${1}"
    visible_count__2141_v0 
    local count_24955="${ret_visible_count2141_v0}"
    if [ "$(( count_24955 == 0 ))" != 0 ]; then
        ret_move_selection2149_v0=0
        return 0
    fi
    local next_24956="$(( _sel_118 + step_24954 ))"
    if [ "$(( $(( next_24956 >= 0 )) && $(( next_24956 < count_24955 )) ))" != 0 ]; then
        local prev_24957="${_sel_118}"
        _sel_118="${next_24956}"
        row_line__2144_v0 "${prev_24957}" 0
        local ret_row_line2144_v0__128_35="${ret_row_line2144_v0}"
        redraw_row__2063_v0 "${_height_116}" "${prev_24957}" "${ret_row_line2144_v0__128_35}"
        row_line__2144_v0 "${_sel_118}" 1
        local ret_row_line2144_v0__129_35="${ret_row_line2144_v0}"
        redraw_row__2063_v0 "${_height_116}" "${_sel_118}" "${ret_row_line2144_v0__129_35}"
        ret_move_selection2149_v0=0
        return 0
    fi
    if [ "$(( $(( next_24956 < 0 )) && $(( _offset_117 > 0 )) ))" != 0 ]; then
        _offset_117="$(( _offset_117 - 1 ))"
        ret_move_selection2149_v0=1
        return 0
    fi
    local __length_432=("${_matches_111[@]}")
    if [ "$(( $(( next_24956 >= count_24955 )) && $(( $(( _offset_117 + _height_116 )) < ${#__length_432[@]} )) ))" != 0 ]; then
        _offset_117="$(( _offset_117 + 1 ))"
        ret_move_selection2149_v0=1
        return 0
    fi
    ret_move_selection2149_v0=0
    return 0
}

# xyl_filter(options: [Text], prompt: Text, placeholder: Text, header: Text, cursor: Text, multi: Bool, limit: Int, height: Int)
xyl_filter__2150_v0() {
    local options_24865=("${!1}")
    local prompt_24866="${2}"
    local placeholder_24867="${3}"
    local header_24868="${4}"
    local cursor_24869="${5}"
    local multi_24870="${6}"
    local limit_24871="${7}"
    local height_24872="${8}"
    local __length_433=("${options_24865[@]}")
    local total_24873="${#__length_433[@]}"
    if [ "$(( total_24873 == 0 ))" != 0 ]; then
        eprintf_colored__1849_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    _options_110=("${options_24865[@]}")
    _query_112=""
    _prompt_114="${prompt_24866}"
    _placeholder_113="${placeholder_24867}"
    _cursor_115="${cursor_24869}"
    _multi_119="${multi_24870}"
    _has_header_120="$([ "_${header_24868}" == "_" ]; echo $?)"
    _offset_117=0
    _sel_118=0
    stty_lock__1888_v0 
    hide_cursor__1905_v0 
    term_width__1895_v0 
    _term_width_121="${ret_term_width1895_v0}"
    # Header, query, count and tooltip take four of the terminal's lines.
    term_height__1896_v0 
    local ret_term_height1896_v0__185_24="${ret_term_height1896_v0}"
    local max_height_24878
    max_height_24878="$(( ret_term_height1896_v0__185_24 - $(if [ "${_has_header_120}" != 0 ]; then echo 4; else echo 3; fi) ))"
    _height_116="${height_24872}"
    if [ "$(( _height_116 > max_height_24878 ))" != 0 ]; then
        _height_116="${max_height_24878}"
    fi
    if [ "$(( _height_116 < 1 ))" != 0 ]; then
        _height_116=1
    fi
    if [ "${multi_24870}" != 0 ]; then
        checked_init__2065_v0 "${total_24873}" "${limit_24871}"
    fi
    refresh_matches__2140_v0 
    if [ "${_has_header_120}" != 0 ]; then
        cutoff_text__1980_v0 "${header_24868}" "${_term_width_121}"
        local ret_cutoff_text1980_v0__200_17="${ret_cutoff_text1980_v0}"
        local array_434=("")
        eprintf__1848_v0 "${ret_cutoff_text1980_v0__200_17}""
" array_434[@]
    fi
    new_line__1901_v0 1
    new_line__1901_v0 "${_height_116}"
    render_count__2147_v0 
    new_line__1901_v0 1
    render_tooltip_line__2148_v0 
    go_up__1902_v0 1
    local array_435=("")
    eprintf__1848_v0 "\\x1b[G" array_435[@]
    render_rows__2145_v0 
    render_query__2146_v0 
    while :
    do
        get_key__1846_v0 
        local key_24953="${ret_get_key1846_v0}"
        if [ "$([ "_${key_24953}" != "_INPUT" ]; echo $?)" != 0 ]; then
            visible_count__2141_v0 
            local ret_visible_count2141_v0__217_20="${ret_visible_count2141_v0}"
            if [ "$(( ret_visible_count2141_v0__217_20 > 0 ))" != 0 ]; then
                break
            fi
            # Nothing matches, so there is nothing to hand back. Multi mode
            # still confirms what is already ticked, otherwise a query that
            # matches nothing would trap the user.
            if [ "${_multi_119}" != 0 ]; then
                checked_count__2067_v0 
                local ret_checked_count2067_v0__224_24="${ret_checked_count2067_v0}"
                if [ "$(( ret_checked_count2067_v0__224_24 > 0 ))" != 0 ]; then
                    break
                fi
            fi
        elif [ "$([ "_${key_24953}" != "_UP" ]; echo $?)" != 0 ]; then
            move_selection__2149_v0 -1
            local ret_move_selection2149_v0__230_20="${ret_move_selection2149_v0}"
            if [ "${ret_move_selection2149_v0__230_20}" != 0 ]; then
                render_rows__2145_v0 
            fi
        elif [ "$([ "_${key_24953}" != "_DOWN" ]; echo $?)" != 0 ]; then
            move_selection__2149_v0 1
            local ret_move_selection2149_v0__235_20="${ret_move_selection2149_v0}"
            if [ "${ret_move_selection2149_v0__235_20}" != 0 ]; then
                render_rows__2145_v0 
            fi
        elif [ "$(( _multi_119 && $([ "_${key_24953}" != "_TAB" ]; echo $?) ))" != 0 ]; then
            visible_count__2141_v0 
            local ret_visible_count2141_v0__240_20="${ret_visible_count2141_v0}"
            if [ "$(( ret_visible_count2141_v0__240_20 > 0 ))" != 0 ]; then
                option_index__2142_v0 "${_sel_118}"
                local ret_option_index2142_v0__241_39="${ret_option_index2142_v0}"
                checked_toggle__2068_v0 "${ret_option_index2142_v0__241_39}"
                local ret_checked_toggle2068_v0__241_24="${ret_checked_toggle2068_v0}"
                if [ "${ret_checked_toggle2068_v0__241_24}" != 0 ]; then
                    row_line__2144_v0 "${_sel_118}" 1
                    local ret_row_line2144_v0__242_51="${ret_row_line2144_v0}"
                    redraw_row__2063_v0 "${_height_116}" "${_sel_118}" "${ret_row_line2144_v0__242_51}"
                fi
            fi
        elif [ "$(( _multi_119 && $([ "_${key_24953}" != "_CTRL_A" ]; echo $?) ))" != 0 ]; then
            checked_all__2069_v0 
            local ret_checked_all2069_v0__247_20="${ret_checked_all2069_v0}"
            if [ "${ret_checked_all2069_v0__247_20}" != 0 ]; then
                render_rows__2145_v0 
            fi
        elif [ "$([ "_${key_24953}" != "_BACKSPACE" ]; echo $?)" != 0 ]; then
            if [ "$([ "_${_query_112}" == "_" ]; echo $?)" != 0 ]; then
                # A length of zero means "to the end" in `slice`, so the
                # last character left has to be dropped on its own.
                local __length_436="${_query_112}"
                if [ "$(( ${#__length_436} == 1 ))" != 0 ]; then
                    _query_112=""
                else
                    local __length_437="${_query_112}"
                    slice__24_v0 "${_query_112}" 0 "$(( ${#__length_437} - 1 ))"
                    _query_112="${ret_slice24_v0}"
                fi
                refresh_matches__2140_v0 
                render_rows__2145_v0 
                render_query__2146_v0 
                render_count__2147_v0 
            fi
        else
            local typed_24968="${key_24953}"
            if [ "$([ "_${key_24953}" != "_SPACE" ]; echo $?)" != 0 ]; then
                typed_24968=" "
            fi
            local __length_438="${typed_24968}"
            if [ "$(( ${#__length_438} == 1 ))" != 0 ]; then
                _query_112+="${typed_24968}"
                refresh_matches__2140_v0 
                render_rows__2145_v0 
                render_query__2146_v0 
                render_count__2147_v0 
            fi
        fi
    done
    local total_lines_24969="$(( _height_116 + 3 ))"
    if [ "${_has_header_120}" != 0 ]; then
        total_lines_24969="$(( total_lines_24969 + 1 ))"
    fi
    go_down__1903_v0 1
    remove_line__1898_v0 "$(( total_lines_24969 - 1 ))"
    remove_current_line__1899_v0 
    stty_unlock__1889_v0 
    show_cursor__1906_v0 
    local result_24974=()
    if [ "${_multi_119}" != 0 ]; then
        local __range_start_24975=0
        local __range_end_24975="${total_24873}"
        local __dir_24975=$(( ${__range_start_24975} <= ${__range_end_24975} ? 1 : -1 ))
        for (( i_24975=${__range_start_24975}; i_24975 * ${__dir_24975} < ${__range_end_24975} * ${__dir_24975}; i_24975+=${__dir_24975} )); do
            checked_is__2066_v0 "${i_24975}"
            local ret_checked_is2066_v0__295_16="${ret_checked_is2066_v0}"
            if [ "${ret_checked_is2066_v0__295_16}" != 0 ]; then
                local array_440=("${_options_110[${i_24975}]?"Index out of bounds (at src/./filter/./mod.ab:296:37)"}")
                result_24974+=("${array_440[@]}")
            fi
done
        ret_xyl_filter2150_v0=("${result_24974[@]}")
        return 0
    fi
    visible_count__2141_v0 
    local ret_visible_count2141_v0__301_8="${ret_visible_count2141_v0}"
    if [ "$(( ret_visible_count2141_v0__301_8 > 0 ))" != 0 ]; then
        option_index__2142_v0 "${_sel_118}"
        local ret_option_index2142_v0__302_29="${ret_option_index2142_v0}"
        result_24974+=("${_options_110[${ret_option_index2142_v0__302_29}]?"Index out of bounds (at src/./filter/./mod.ab:302:29)"}")
    fi
    ret_xyl_filter2150_v0=("${result_24974[@]}")
    return 0
}

# print_filter_help()
print_filter_help__2250_v0() {
    local usage_24781=("Usage:" "./xylitol.sh" "filter" "[<options>" "...]" "[flags]")
    print_wrapped__1907_v0 usage_24781[@]
    printf '%s\n' ""
    colored_primary__1949_v0 "filter"
    local ret_colored_primary1949_v0__8_20="${ret_colored_primary1949_v0}"
    local title_24818=("${ret_colored_primary1949_v0__8_20}" "-" "Pick" "from" "a" "list" "narrowed" "by" "typing.")
    print_wrapped__1907_v0 title_24818[@]
    printf '%s\n' ""
    colored_secondary__1950_v0 "Arguments:"
    local ret_colored_secondary1950_v0__11_12="${ret_colored_secondary1950_v0}"
    local array_444=()
    printf__128_v0 "${ret_colored_secondary1950_v0__11_12}""
" array_444[@]
    local array_445=("[<options> ...]")
    local array_446=("List of options to pick from")
    local array_447=("")
    render_help_entries__2082_v0 array_445[@] array_446[@] array_447[@] 20
    printf '%s\n' ""
    colored_secondary__1950_v0 "Flags:"
    local ret_colored_secondary1950_v0__14_12="${ret_colored_secondary1950_v0}"
    local array_448=()
    printf__128_v0 "${ret_colored_secondary1950_v0__14_12}""
" array_448[@]
    local names_24852=("-h, --help" "--limit=<number>" "--no-limit" "--prompt=\"<text>\"" "--placeholder=\"<text>\"" "--cursor=\"<text>\"" "--header=\"<text>\"" "--height=<number>")
    local texts_24853=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the text shown in front of the query" "Set the text shown while the query is empty" "Set the cursor text" "Set a header text to display above the query" "Set the number of options shown at once")
    local notes_24854=("" "" "" "(default: '> ')" "(default: 'Filter...')" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__2082_v0 names_24852[@] texts_24853[@] notes_24854[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__2308_v0() {
    local options_24774=()
    local command_453
    command_453="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_24775="${command_453}"
    if [ "$([ "_${is_tty_24775}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_24774+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options2308_v0=("${options_24774[@]}")
    return 0
}

# execute_filter(parameters: [Text])
execute_filter__2309_v0() {
    local parameters_24769=("${!1}")
    local cursor_24770="> "
    local prompt_24771="> "
    local placeholder_24772="Filter..."
    local header_24773=""
    read_stdin_options__2308_v0 
    local options_24776=("${ret_read_stdin_options2308_v0[@]}")
    local multi_24777=0
    local limit_24778=-1
    local height_24779=10
    local __length_457=("${parameters_24769[@]}")
    local slice_upper_456="${#__length_457[@]}"
    local slice_offset_458=2
    local slice_offset_458=$((${slice_offset_458} > 0 ? ${slice_offset_458} : 0))
    local slice_length_459="$(( slice_upper_456 - slice_offset_458 ))"
    local slice_length_459=$((${slice_length_459} > 0 ? ${slice_length_459} : 0))
    for param_24780 in "${parameters_24769[@]:${slice_offset_458}:${slice_length_459}}"; do
        starts_with__22_v0 "${param_24780}" "--cursor="
        local ret_starts_with22_v0__31_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24780}" "--prompt="
        local ret_starts_with22_v0__34_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24780}" "--placeholder="
        local ret_starts_with22_v0__37_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24780}" "--header="
        local ret_starts_with22_v0__40_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24780}" "--limit="
        local ret_starts_with22_v0__43_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_24780}" "--height="
        local ret_starts_with22_v0__54_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_24780}" != "_-h" ]; echo $?) || $([ "_${param_24780}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_filter_help__2250_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__31_13}" != 0 ]; then
            local __length_460="--cursor="
            slice__24_v0 "${param_24780}" "${#__length_460}" 0
            cursor_24770="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__34_13}" != 0 ]; then
            local __length_461="--prompt="
            slice__24_v0 "${param_24780}" "${#__length_461}" 0
            prompt_24771="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__37_13}" != 0 ]; then
            local __length_462="--placeholder="
            slice__24_v0 "${param_24780}" "${#__length_462}" 0
            placeholder_24772="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__40_13}" != 0 ]; then
            local __length_463="--header="
            slice__24_v0 "${param_24780}" "${#__length_463}" 0
            header_24773="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__43_13}" != 0 ]; then
            local __length_464="--limit="
            slice__24_v0 "${param_24780}" "${#__length_464}" 0
            local value_24855="${ret_slice24_v0}"
            parse_int__13_v0 "${value_24855}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1849_v0 "ERROR: Invalid limit value: ""${value_24855}""
" 31
                exit 1
            fi
            limit_24778="${ret_parse_int13_v0}"
            multi_24777=1
        elif [ "$([ "_${param_24780}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_24777=1
        elif [ "${ret_starts_with22_v0__54_13}" != 0 ]; then
            local __length_465="--height="
            slice__24_v0 "${param_24780}" "${#__length_465}" 0
            local value_24860="${ret_slice24_v0}"
            parse_int__13_v0 "${value_24860}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1849_v0 "ERROR: Invalid height value: ""${value_24860}""
" 31
                exit 1
            fi
            height_24779="${ret_parse_int13_v0}"
        else
            options_24776+=("${param_24780}")
        fi
    done
    has_ansi_escape__1973_v0 "${header_24773}"
    local ret_has_ansi_escape1973_v0__67_44="${ret_has_ansi_escape1973_v0}"
    escape_ansi__1974_v0 "${header_24773}"
    local ret_escape_ansi1974_v0__67_73="${ret_escape_ansi1974_v0}"
    colored_primary__1949_v0 "${header_24773}"
    local ret_colored_primary1949_v0__67_111="${ret_colored_primary1949_v0}"
    local display_header_24864
    display_header_24864="$(if [ "$(( $([ "_${header_24773}" != "_" ]; echo $?) || ret_has_ansi_escape1973_v0__67_44 ))" != 0 ]; then echo "${ret_escape_ansi1974_v0__67_73}"; else echo "\\x1b[1m""${ret_colored_primary1949_v0__67_111}"; fi)"
    xyl_filter__2150_v0 options_24776[@] "${prompt_24771}" "${placeholder_24772}" "${display_header_24864}" "${cursor_24770}" "${multi_24777}" "${limit_24778}" "${height_24779}"
    local results_24976=("${ret_xyl_filter2150_v0[@]}")
    join__7_v0 results_24976[@] "
"
    ret_execute_filter2309_v0="${ret_join7_v0}"
    return 0
}

# get_key()
get_key__2433_v0() {
    local command_467
    command_467="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key2433_v0="${command_467}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2435_v0() {
    local format_26907="${1}"
    local args_26908=("${!2}")
    args_26908=("${format_26907}" "${args_26908[@]}")
    __status=$?
    printf "${args_26908[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2436_v0() {
    local message_26905="${1}"
    local color_26906="${2}"
    # Prints an error message with a specified color.
    local array_468=("${message_26905}")
    eprintf__2435_v0 "\\x1b[${color_26906}m%s\\x1b[0m" array_468[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2451_v0() {
    local format_26917="${1}"
    local args_26918=("${!2}")
    args_26918=("${format_26917}" "${args_26918[@]}")
    __status=$?
    printf "${args_26918[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_124="None"
# perl_available()
perl_available__2458_v0() {
    if [ "$([ "_${_perl_state_124}" != "_None" ]; echo $?)" != 0 ]; then
        local command_469
        command_469="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_26863
        disabled_26863="$([ "_${command_469}" != "_No" ]; echo $?)"
        local command_470
        command_470="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_26864
        found_26864="$(( $(( ! disabled_26863 )) && $([ "_${command_470}" != "_0" ]; echo $?) ))"
        _perl_state_124="$(if [ "${found_26864}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2458_v0="$([ "_${_perl_state_124}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2459_v0() {
    local text_26862="${1}"
    perl_available__2458_v0 
    local ret_perl_available2458_v0__19_12="${ret_perl_available2458_v0}"
    if [ "$(( ! ret_perl_available2458_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2459_v0=''
        return 1
    fi
    local command_471
    command_471="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_26862}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2459_v0=''
        return "${__status}"
    fi
    local width_str_26865="${command_471}"
    parse_int__13_v0 "${width_str_26865}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2459_v0=''
        return "${__status}"
    fi
    local width_26866="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2459_v0="${width_26866}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2464_v0() {
    local text_26855="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_472
    command_472="$([[ "${text_26855}" == *$'\x1b'* || "${text_26855}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_26856="${command_472}"
    ret_has_ansi_escape2464_v0="$([ "_${has_escape_26856}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2466_v0() {
    local text_26858="${1}"
    local command_473
    command_473="$(printf "%s" "${text_26858}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2466_v0="${command_473}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2467_v0() {
    local text_26860="${1}"
    local command_474
    command_474="$(printf "%s" "${text_26860}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_26861="${command_474}"
    ret_is_all_ascii2467_v0="$([ "_${result_26861}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2468_v0() {
    local text_26857="${1}"
    strip_ansi__2466_v0 "${text_26857}"
    local stripped_26859="${ret_strip_ansi2466_v0}"
    # Check if text is all ASCII
    is_all_ascii__2467_v0 "${stripped_26859}"
    local ret_is_all_ascii2467_v0__36_12="${ret_is_all_ascii2467_v0}"
    if [ "$(( ! ret_is_all_ascii2467_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2459_v0 "${stripped_26859}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_475="${stripped_26859}"
            ret_get_visible_len2468_v0="${#__length_475}"
            return 0
        fi
        ret_get_visible_len2468_v0="${ret_perl_get_cjk_width2459_v0}"
        return 0
    else
        local __length_476="${stripped_26859}"
        ret_get_visible_len2468_v0="${#__length_476}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_125=0
_term_size_126=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2474_v0() {
    local command_478
    command_478="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_26915="${command_478}"
    parse_int__13_v0 "${count_26915}"
    __status=$?
    ret_stty_count2474_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2475_v0() {
    stty_count__2474_v0 
    local count_num_26916="${ret_stty_count2474_v0}"
    if [ "$(( count_num_26916 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_26916="$(( count_num_26916 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_26916}
    __status=$?
}

# stty_unlock()
stty_unlock__2476_v0() {
    stty_count__2474_v0 
    local count_num_27007="${ret_stty_count2474_v0}"
    if [ "$(( count_num_27007 > 0 ))" != 0 ]; then
        count_num_27007="$(( count_num_27007 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27007}
        __status=$?
        if [ "$(( count_num_27007 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2477_v0() {
    local size_26846="${1}"
    if [ "$([ "_${size_26846}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2477_v0=0
        return 0
    fi
    split__4_v0 "${size_26846}" " "
    local parts_26847=("${ret_split4_v0[@]}")
    local __length_479=("${parts_26847[@]}")
    if [ "$(( ${#__length_479[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2477_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_26847[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_26847[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_126=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2477_v0=1
    return 0
}

# query_term_size()
query_term_size__2478_v0() {
    local command_481
    command_481="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_26849="${command_481}"
    store_term_size__2477_v0 "${size_26849}"
    ret_query_term_size2478_v0="${ret_store_term_size2477_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2479_v0() {
    local command_482
    command_482="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_26845="${command_482}"
    store_term_size__2477_v0 "${size_26845}"
    ret_stty_term_size2479_v0="${ret_store_term_size2477_v0}"
    return 0
}

# get_term_size()
get_term_size__2480_v0() {
    stty_term_size__2479_v0 
    local detected_26848="${ret_stty_term_size2479_v0}"
    if [ "$(( ! detected_26848 ))" != 0 ]; then
        query_term_size__2478_v0 
        detected_26848="${ret_query_term_size2478_v0}"
    fi
    _got_term_size_125=1
}

# term_width()
term_width__2482_v0() {
    if [ "$(( ! _got_term_size_125 ))" != 0 ]; then
        get_term_size__2480_v0 
    fi
    ret_term_width2482_v0="${_term_size_126[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2485_v0() {
    local cnt_27004="${1}"
    if [ "$(( cnt_27004 > 0 ))" != 0 ]; then
        local sequence_27005=""
        local __range_start_27006=0
        local __range_end_27006="${cnt_27004}"
        local __dir_27006=$(( ${__range_start_27006} <= ${__range_end_27006} ? 1 : -1 ))
        for (( ____27006=${__range_start_27006}; ____27006 * ${__dir_27006} < ${__range_end_27006} * ${__dir_27006}; ____27006+=${__dir_27006} )); do
            sequence_27005+="\\x1b[2K\\x1b[1A"
done
        local array_483=("")
        eprintf__2451_v0 "${sequence_27005}" array_483[@]
    fi
    local array_484=("")
    eprintf__2451_v0 "\\x1b[G" array_484[@]
}

# remove_current_line()
remove_current_line__2486_v0() {
    local array_485=("")
    eprintf__2451_v0 "\\x1b[2K\\x1b[G" array_485[@]
}

# go_up(cnt: Int)
go_up__2489_v0() {
    local cnt_27000="${1}"
    local array_486=("")
    eprintf__2451_v0 "\\x1b[${cnt_27000}A" array_486[@]
}

# go_down(cnt: Int)
go_down__2490_v0() {
    local cnt_27003="${1}"
    local array_487=("")
    eprintf__2451_v0 "\\x1b[${cnt_27003}B" array_487[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__2492_v0() {
    local array_488=("")
    eprintf__2451_v0 "\\x1b[?25l" array_488[@]
}

# show_cursor()
show_cursor__2493_v0() {
    local array_489=("")
    eprintf__2451_v0 "\\x1b[?25h" array_489[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__2494_v0() {
    local pieces_26844=("${!1}")
    term_width__2482_v0 
    local width_26850="${ret_term_width2482_v0}"
    local line_26851=""
    local line_len_26852=0
    for piece_26853 in "${pieces_26844[@]}"; do
        local __length_492="${piece_26853}"
        local piece_len_26854="${#__length_492}"
        has_ansi_escape__2464_v0 "${piece_26853}"
        local ret_has_ansi_escape2464_v0__186_12="${ret_has_ansi_escape2464_v0}"
        if [ "${ret_has_ansi_escape2464_v0__186_12}" != 0 ]; then
            get_visible_len__2468_v0 "${piece_26853}"
            piece_len_26854="${ret_get_visible_len2468_v0}"
        fi
        if [ "$([ "_${line_26851}" != "_" ]; echo $?)" != 0 ]; then
            line_26851="${piece_26853}"
            line_len_26852="${piece_len_26854}"
        elif [ "$(( $(( $(( line_len_26852 + 1 )) + piece_len_26854 )) > width_26850 ))" != 0 ]; then
            local array_493=()
            printf__128_v0 "${line_26851}""
" array_493[@]
            line_26851="${piece_26853}"
            line_len_26852="${piece_len_26854}"
        else
            line_26851+=" ""${piece_26853}"
            line_len_26852="$(( line_len_26852 + $(( 1 + piece_len_26854 )) ))"
        fi
    done
    if [ "$([ "_${line_26851}" == "_" ]; echo $?)" != 0 ]; then
        local array_494=()
        printf__128_v0 "${line_26851}""
" array_494[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_129="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_130=0
_primary_color_131=(3 207 159 92)
_secondary_color_132=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2531_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_26839="${ret_env_var_get120_v0}"
    _supports_truecolor_129="$(if [ "$([ "_${config_26839}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2531_v0="$([ "_${_supports_truecolor_129}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2532_v0() {
    local message_26834="${1}"
    local r_26835="${2}"
    local g_26836="${3}"
    local b_26837="${4}"
    local fallback_26838="${5}"
    if [ "$([ "_${_supports_truecolor_129}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2532_v0="\\x1b[38;2;${r_26835};${g_26836};${b_26837}m""${message_26834}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_129}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2531_v0 
        local ret_get_supports_truecolor2531_v0__45_17="${ret_get_supports_truecolor2531_v0}"
        if [ "${ret_get_supports_truecolor2531_v0__45_17}" != 0 ]; then
            ret_colored_rgb2532_v0="\\x1b[38;2;${r_26835};${g_26836};${b_26837}m""${message_26834}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_26838 == 0 ))" != 0 ]; then
            ret_colored_rgb2532_v0="${message_26834}"
            return 0
        else
            ret_colored_rgb2532_v0="\\x1b[${fallback_26838}m""${message_26834}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_26838 == 0 ))" != 0 ]; then
            ret_colored_rgb2532_v0="${message_26834}"
            return 0
        fi
        ret_colored_rgb2532_v0="\\x1b[${fallback_26838}m""${message_26834}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__2533_v0() {
    local message_26977="${1}"
    local r_26978="${2}"
    local g_26979="${3}"
    local b_26980="${4}"
    local fallback_26981="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_26982="${fallback_26981}"
    if [ "$(( $(( fallback_26981 >= 30 )) && $(( fallback_26981 <= 37 )) ))" != 0 ]; then
        bg_fallback_26982="$(( fallback_26981 + 10 ))"
    fi
    if [ "$(( $(( fallback_26981 >= 90 )) && $(( fallback_26981 <= 97 )) ))" != 0 ]; then
        bg_fallback_26982="$(( fallback_26981 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_129}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb2533_v0="\\x1b[48;2;${r_26978};${g_26979};${b_26980}m""${message_26977}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_129}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2531_v0 
        local ret_get_supports_truecolor2531_v0__87_17="${ret_get_supports_truecolor2531_v0}"
        if [ "${ret_get_supports_truecolor2531_v0__87_17}" != 0 ]; then
            ret_background_rgb2533_v0="\\x1b[48;2;${r_26978};${g_26979};${b_26980}m""${message_26977}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_26982 == 0 ))" != 0 ]; then
            ret_background_rgb2533_v0="${message_26977}"
            return 0
        else
            ret_background_rgb2533_v0="\\x1b[${bg_fallback_26982}m""${message_26977}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_26982 == 0 ))" != 0 ]; then
            ret_background_rgb2533_v0="${message_26977}"
            return 0
        fi
        ret_background_rgb2533_v0="\\x1b[${bg_fallback_26982}m""${message_26977}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2534_v0() {
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_26828="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_26828}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_26828}" ";"
            local parts_26829=("${ret_split4_v0[@]}")
            local __length_498=("${parts_26829[@]}")
            if [ "$(( ${#__length_498[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_26829[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26829[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26829[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26829[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_131=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_26830="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_26830}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_26830}" ";"
            local parts_26831=("${ret_split4_v0[@]}")
            local __length_500=("${parts_26831[@]}")
            if [ "$(( ${#__length_500[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_26831[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26831[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26831[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26831[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_132=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_26832="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_26832}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_26832}" ";"
            local parts_26833=("${ret_split4_v0[@]}")
            local __length_502=("${parts_26833[@]}")
            if [ "$(( ${#__length_502[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_26833[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26833[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26833[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_26833[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2534_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_130=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2535_v0() {
    inner_get_xylitol_colors__2534_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_130=1
}

# colored_primary(message: Text)
colored_primary__2536_v0() {
    local message_26827="${1}"
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        get_xylitol_colors__2535_v0 
    fi
    colored_rgb__2532_v0 "${message_26827}" "${_primary_color_131[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_131[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_131[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_131[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2536_v0="${ret_colored_rgb2532_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2537_v0() {
    local message_26868="${1}"
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        get_xylitol_colors__2535_v0 
    fi
    colored_rgb__2532_v0 "${message_26868}" "${_secondary_color_132[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_132[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_132[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_132[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2537_v0="${ret_colored_rgb2532_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__2540_v0() {
    local message_26976="${1}"
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        get_xylitol_colors__2535_v0 
    fi
    background_rgb__2533_v0 "${message_26976}" "${_secondary_color_132[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_132[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_132[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_132[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary2540_v0="${ret_background_rgb2533_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_134="None"
# perl_available()
perl_available__2554_v0() {
    if [ "$([ "_${_perl_state_134}" != "_None" ]; echo $?)" != 0 ]; then
        local command_504
        command_504="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_26928
        disabled_26928="$([ "_${command_504}" != "_No" ]; echo $?)"
        local command_505
        command_505="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_26929
        found_26929="$(( $(( ! disabled_26928 )) && $([ "_${command_505}" != "_0" ]; echo $?) ))"
        _perl_state_134="$(if [ "${found_26929}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2554_v0="$([ "_${_perl_state_134}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2555_v0() {
    local text_26927="${1}"
    perl_available__2554_v0 
    local ret_perl_available2554_v0__19_12="${ret_perl_available2554_v0}"
    if [ "$(( ! ret_perl_available2554_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2555_v0=''
        return 1
    fi
    local command_506
    command_506="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_26927}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2555_v0=''
        return "${__status}"
    fi
    local width_str_26930="${command_506}"
    parse_int__13_v0 "${width_str_26930}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2555_v0=''
        return "${__status}"
    fi
    local width_26931="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2555_v0="${width_26931}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2556_v0() {
    local text_26938="${1}"
    local max_width_26939="${2}"
    perl_available__2554_v0 
    local ret_perl_available2554_v0__30_12="${ret_perl_available2554_v0}"
    if [ "$(( ! ret_perl_available2554_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2556_v0=''
        return 1
    fi
    local command_507
    command_507="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_26938}" ${max_width_26939} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2556_v0=''
        return "${__status}"
    fi
    local result_26940="${command_507}"
    ret_perl_truncate_cjk2556_v0="${result_26940}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2560_v0() {
    local text_26909="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_508
    command_508="$([[ "${text_26909}" == *$'\x1b'* || "${text_26909}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_26910="${command_508}"
    ret_has_ansi_escape2560_v0="$([ "_${has_escape_26910}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2561_v0() {
    local text_26911="${1}"
    local command_509
    command_509="$(printf '%s' "${text_26911}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2561_v0="${command_509}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2562_v0() {
    local text_26923="${1}"
    local command_510
    command_510="$(printf "%s" "${text_26923}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2562_v0="${command_510}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2563_v0() {
    local text_26925="${1}"
    local command_511
    command_511="$(printf "%s" "${text_26925}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_26926="${command_511}"
    ret_is_all_ascii2563_v0="$([ "_${result_26926}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2564_v0() {
    local text_26922="${1}"
    strip_ansi__2562_v0 "${text_26922}"
    local stripped_26924="${ret_strip_ansi2562_v0}"
    # Check if text is all ASCII
    is_all_ascii__2563_v0 "${stripped_26924}"
    local ret_is_all_ascii2563_v0__36_12="${ret_is_all_ascii2563_v0}"
    if [ "$(( ! ret_is_all_ascii2563_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2555_v0 "${stripped_26924}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_512="${stripped_26924}"
            ret_get_visible_len2564_v0="${#__length_512}"
            return 0
        fi
        ret_get_visible_len2564_v0="${ret_perl_get_cjk_width2555_v0}"
        return 0
    else
        local __length_513="${stripped_26924}"
        ret_get_visible_len2564_v0="${#__length_513}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2565_v0() {
    local text_26935="${1}"
    local max_width_26936="${2}"
    get_visible_len__2564_v0 "${text_26935}"
    local visible_len_26937="${ret_get_visible_len2564_v0}"
    if [ "$(( visible_len_26937 <= max_width_26936 ))" != 0 ]; then
        ret_truncate_text2565_v0="${text_26935}"
        return 0
    fi
    is_all_ascii__2563_v0 "${text_26935}"
    local ret_is_all_ascii2563_v0__53_12="${ret_is_all_ascii2563_v0}"
    if [ "$(( ! ret_is_all_ascii2563_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__2556_v0 "${text_26935}" "${max_width_26936}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_26935}" | cut -c1-${max_width_26936}
            __status=$?
        fi
        ret_truncate_text2565_v0="${ret_perl_truncate_cjk2556_v0}"
        return 0
    fi
    local command_514
    command_514="$(printf "%s" "${text_26935}" | cut -c1-${max_width_26936})"
    __status=$?
    ret_truncate_text2565_v0="${command_514}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2566_v0() {
    local text_26933="${1}"
    local max_width_26934="${2}"
    has_ansi_escape__2560_v0 "${text_26933}"
    local ret_has_ansi_escape2560_v0__65_12="${ret_has_ansi_escape2560_v0}"
    if [ "$(( ! ret_has_ansi_escape2560_v0__65_12 ))" != 0 ]; then
        truncate_text__2565_v0 "${text_26933}" "${max_width_26934}"
        ret_truncate_ansi2566_v0="${ret_truncate_text2565_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_515
    command_515="$([[ "${text_26933}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_26941="${command_515}"
    # Replace \x1b[ with newline, then split
    local command_516
    command_516="$(t="${text_26933}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_26942="${command_516}"
    split__4_v0 "${replaced_26942}" "
"
    local parts_26943=("${ret_split4_v0[@]}")
    local result_26944=""
    local remaining_width_26945="${max_width_26934}"
    local __range_start_26946=0
    local __length_517=("${parts_26943[@]}")
    local __range_end_26946="${#__length_517[@]}"
    local __dir_26946=$(( ${__range_start_26946} <= ${__range_end_26946} ? 1 : -1 ))
    for (( idx_26946=${__range_start_26946}; idx_26946 * ${__dir_26946} < ${__range_end_26946} * ${__dir_26946}; idx_26946+=${__dir_26946} )); do
        local part_26947="${parts_26943[${idx_26946}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_26946 == 0 )) && $([ "_${starts_with_ansi_26941}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_26947}" == "_" ]; echo $?) && $(( remaining_width_26945 > 0 )) ))" != 0 ]; then
                truncate_text__2565_v0 "${part_26947}" "${remaining_width_26945}"
                local ret_truncate_text2565_v0__87_35="${ret_truncate_text2565_v0}"
                local truncated_26948="${ret_truncate_text2565_v0__87_35}"
                result_26944+="${truncated_26948}"
                get_visible_len__2564_v0 "${truncated_26948}"
                local ret_get_visible_len2564_v0__89_36="${ret_get_visible_len2564_v0}"
                remaining_width_26945="$(( remaining_width_26945 - ret_get_visible_len2564_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_518
            command_518="$(__p="${part_26947}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_26949="${command_518}"
            if [ "$([ "_${m_idx_26949}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_519
                command_519="$(__p="${part_26947}"; printf "%s" "${__p:0:${m_idx_26949}}")"
                __status=$?
                local ansi_params_26950="${command_519}"
                result_26944+="\\x1b[""${ansi_params_26950}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_26949}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_26951="${ret_parse_int13_v0__100_41}"
                local text_start_26952="$(( m_idx_num_26951 + 1 ))"
                local command_520
                command_520="$(__p="${part_26947}"; printf "%s" "${__p:${text_start_26952}}")"
                __status=$?
                local text_part_26953="${command_520}"
                if [ "$(( $([ "_${text_part_26953}" == "_" ]; echo $?) && $(( remaining_width_26945 > 0 )) ))" != 0 ]; then
                    truncate_text__2565_v0 "${text_part_26953}" "${remaining_width_26945}"
                    local ret_truncate_text2565_v0__104_39="${ret_truncate_text2565_v0}"
                    local truncated_26954="${ret_truncate_text2565_v0__104_39}"
                    result_26944+="${truncated_26954}"
                    get_visible_len__2564_v0 "${truncated_26954}"
                    local ret_get_visible_len2564_v0__106_40="${ret_get_visible_len2564_v0}"
                    remaining_width_26945="$(( remaining_width_26945 - ret_get_visible_len2564_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_26947}" == "_" ]; echo $?) && $(( remaining_width_26945 > 0 )) ))" != 0 ]; then
                    truncate_text__2565_v0 "${part_26947}" "${remaining_width_26945}"
                    local ret_truncate_text2565_v0__111_39="${ret_truncate_text2565_v0}"
                    local truncated_26955="${ret_truncate_text2565_v0__111_39}"
                    result_26944+="${truncated_26955}"
                    get_visible_len__2564_v0 "${truncated_26955}"
                    local ret_get_visible_len2564_v0__113_40="${ret_get_visible_len2564_v0}"
                    remaining_width_26945="$(( remaining_width_26945 - ret_get_visible_len2564_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2566_v0="${result_26944}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2567_v0() {
    local text_26920="${1}"
    local max_width_26921="${2}"
    get_visible_len__2564_v0 "${text_26920}"
    local visible_len_26932="${ret_get_visible_len2564_v0}"
    if [ "$(( visible_len_26932 <= max_width_26921 ))" != 0 ]; then
        ret_cutoff_text2567_v0="${text_26920}"
        return 0
    fi
    truncate_ansi__2566_v0 "${text_26920}" "$(( max_width_26921 - 3 ))"
    local ret_truncate_ansi2566_v0__129_12="${ret_truncate_ansi2566_v0}"
    ret_cutoff_text2567_v0="${ret_truncate_ansi2566_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2588_v0() {
    local format_26991="${1}"
    local args_26992=("${!2}")
    args_26992=("${format_26991}" "${args_26992[@]}")
    __status=$?
    printf "${args_26992[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2589_v0() {
    local message_26989="${1}"
    local color_26990="${2}"
    # Prints an error message with a specified color.
    local array_521=("${message_26989}")
    eprintf__2588_v0 "\\x1b[${color_26990}m%s\\x1b[0m" array_521[@]
}

# colored(message: Text, color: Int)
colored__2590_v0() {
    local message_26902="${1}"
    local color_26903="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2590_v0="\\x1b[${color_26903}m""${message_26902}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2594_v0() {
    local items_26983=("${!1}")
    local total_len_26984="${2}"
    local term_width_26985="${3}"
    local separator_26986=" • "
    local separator_len_26987=3
    # Fast path: no truncation needed
    if [ "$(( total_len_26984 <= term_width_26985 ))" != 0 ]; then
        local iter_26988=0
        while :
        do
            local __length_522=("${items_26983[@]}")
            if [ "$(( iter_26988 >= ${#__length_522[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_26988 > 0 ))" != 0 ]; then
                eprintf_colored__2589_v0 "${separator_26986}" 90
            fi
            colored__2590_v0 "${items_26983[$(( iter_26988 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2590_v0__23_41="${ret_colored2590_v0}"
            local array_523=("")
            eprintf__2588_v0 "${items_26983[${iter_26988}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2590_v0__23_41}" array_523[@]
            iter_26988="$(( iter_26988 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_26993=0
        local first_26994=1
        local iter_26995=0
        while :
        do
            local __length_524=("${items_26983[@]}")
            if [ "$(( iter_26995 >= ${#__length_524[@]} ))" != 0 ]; then
                break
            fi
            local key_26996="${items_26983[${iter_26995}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_26997="${items_26983[$(( iter_26995 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_525="${key_26996}"
            local __length_526="${action_26997}"
            local part_len_26998="$(( $(( ${#__length_525} + 1 )) + ${#__length_526} ))"
            local needed_26999="${part_len_26998}"
            if [ "$(( ! first_26994 ))" != 0 ]; then
                needed_26999="$(( needed_26999 + separator_len_26987 ))"
            fi
            if [ "$(( $(( current_len_26993 + needed_26999 )) > term_width_26985 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_26994 ))" != 0 ]; then
                eprintf_colored__2589_v0 "${separator_26986}" 90
            fi
            colored__2590_v0 "${action_26997}" 2
            local ret_colored2590_v0__51_33="${ret_colored2590_v0}"
            local array_527=("")
            eprintf__2588_v0 "${key_26996}"" ""${ret_colored2590_v0__51_33}" array_527[@]
            current_len_26993="$(( current_len_26993 + needed_26999 ))"
            first_26994=0
            iter_26995="$(( iter_26995 + 2 ))"
        done
    fi
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_137=0
_term_size_138=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__2630_v0() {
    local size_26881="${1}"
    if [ "$([ "_${size_26881}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2630_v0=0
        return 0
    fi
    split__4_v0 "${size_26881}" " "
    local parts_26882=("${ret_split4_v0[@]}")
    local __length_529=("${parts_26882[@]}")
    if [ "$(( ${#__length_529[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2630_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_26882[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_26882[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_138=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2630_v0=1
    return 0
}

# query_term_size()
query_term_size__2631_v0() {
    local command_531
    command_531="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_26884="${command_531}"
    store_term_size__2630_v0 "${size_26884}"
    ret_query_term_size2631_v0="${ret_store_term_size2630_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2632_v0() {
    local command_532
    command_532="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_26880="${command_532}"
    store_term_size__2630_v0 "${size_26880}"
    ret_stty_term_size2632_v0="${ret_store_term_size2630_v0}"
    return 0
}

# get_term_size()
get_term_size__2633_v0() {
    stty_term_size__2632_v0 
    local detected_26883="${ret_stty_term_size2632_v0}"
    if [ "$(( ! detected_26883 ))" != 0 ]; then
        query_term_size__2631_v0 
        detected_26883="${ret_query_term_size2631_v0}"
    fi
    _got_term_size_137=1
}

# term_width()
term_width__2635_v0() {
    if [ "$(( ! _got_term_size_137 ))" != 0 ]; then
        get_term_size__2633_v0 
    fi
    ret_term_width2635_v0="${_term_size_138[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2668_v0() {
    local pending_26899="${1}"
    local line_26900="${2}"
    local note_at_26901="${3}"
    if [ "$(( note_at_26901 < 0 ))" != 0 ]; then
        local array_534=()
        printf__128_v0 "${pending_26899}""${line_26900}""
" array_534[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_26901 == 0 ))" != 0 ]; then
        colored__2590_v0 "${line_26900}" 90
        local ret_colored2590_v0__12_40="${ret_colored2590_v0}"
        local array_535=()
        printf__128_v0 "${pending_26899}""${ret_colored2590_v0__12_40}""
" array_535[@]
    else
        slice__24_v0 "${line_26900}" 0 "${note_at_26901}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_26900}" "${note_at_26901}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2590_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2590_v0__13_58="${ret_colored2590_v0}"
        local array_536=()
        printf__128_v0 "${pending_26899}""${ret_slice24_v0__13_32}""${ret_colored2590_v0__13_58}""
" array_536[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2669_v0() {
    local names_26872=("${!1}")
    local texts_26873=("${!2}")
    local notes_26874=("${!3}")
    local min_name_width_26875="${4}"
    local __length_537=("${names_26872[@]}")
    local count_26876="${#__length_537[@]}"
    local name_width_26877="${min_name_width_26875}"
    local __range_start_26878=0
    local __range_end_26878="${count_26876}"
    local __dir_26878=$(( ${__range_start_26878} <= ${__range_end_26878} ? 1 : -1 ))
    for (( i_26878=${__range_start_26878}; i_26878 * ${__dir_26878} < ${__range_end_26878} * ${__dir_26878}; i_26878+=${__dir_26878} )); do
        local __length_538="${names_26872[${i_26878}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_26879="${#__length_538}"
        if [ "$(( width_26879 > name_width_26877 ))" != 0 ]; then
            name_width_26877="${width_26879}"
        fi
done
    term_width__2635_v0 
    local width_26885="${ret_term_width2635_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_26886="$(( name_width_26877 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_26887="$(( $(( width_26885 - indent_26886 )) < 24 ))"
    if [ "${stacked_26887}" != 0 ]; then
        indent_26886=6
    fi
    local avail_26888="$(( width_26885 - indent_26886 ))"
    rpad__28_v0 "" " " "${indent_26886}"
    local blank_26889="${ret_rpad28_v0}"
    local __range_start_26890=0
    local __range_end_26890="${count_26876}"
    local __dir_26890=$(( ${__range_start_26890} <= ${__range_end_26890} ? 1 : -1 ))
    for (( i_26890=${__range_start_26890}; i_26890 * ${__dir_26890} < ${__range_end_26890} * ${__dir_26890}; i_26890+=${__dir_26890} )); do
        local pending_26891="${blank_26889}"
        if [ "${stacked_26887}" != 0 ]; then
            local array_539=()
            printf__128_v0 "  ""${names_26872[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_539[@]
        else
            rpad__28_v0 "  ""${names_26872[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_26886}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_26891="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_26873[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_26892=("${ret_split4_v0__52_21[@]}")
        local __length_540=("${words_26892[@]}")
        local note_start_26893="${#__length_540[@]}"
        if [ "$([ "_${notes_26874[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_541="${notes_26874[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_541} > avail_26888 ))" != 0 ]; then
                split__4_v0 "${notes_26874[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_26892+=("${ret_split4_v0__58_26[@]}")
            else
                local array_542=("${notes_26874[${i_26890}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_26892+=("${array_542[@]}")
            fi
        fi
        local line_26894=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_26895=-1
        local __range_start_26896=0
        local __length_543=("${words_26892[@]}")
        local __range_end_26896="${#__length_543[@]}"
        local __dir_26896=$(( ${__range_start_26896} <= ${__range_end_26896} ? 1 : -1 ))
        for (( j_26896=${__range_start_26896}; j_26896 * ${__dir_26896} < ${__range_end_26896} * ${__dir_26896}; j_26896+=${__dir_26896} )); do
            local word_26897="${words_26892[${j_26896}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_26898
            candidate_26898="$(if [ "$([ "_${line_26894}" != "_" ]; echo $?)" != 0 ]; then echo "${word_26897}"; else echo "${line_26894}"" ""${word_26897}"; fi)"
            local __length_544="${candidate_26898}"
            if [ "$(( $(( ${#__length_544} > avail_26888 )) && $([ "_${line_26894}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2668_v0 "${pending_26891}" "${line_26894}" "${note_at_26895}"
                pending_26891="${blank_26889}"
                line_26894="${word_26897}"
                note_at_26895="$(if [ "$(( j_26896 >= note_start_26893 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_26896 >= note_start_26893 )) && $(( note_at_26895 < 0 )) ))" != 0 ]; then
                    local __length_545="${candidate_26898}"
                    local __length_546="${word_26897}"
                    note_at_26895="$(( ${#__length_545} - ${#__length_546} ))"
                fi
                line_26894="${candidate_26898}"
            fi
done
        print_help_line__2668_v0 "${pending_26891}" "${line_26894}" "${note_at_26895}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2727_v0() {
    local selected_26957="${1}"
    local term_width_26958="${2}"
    local small_26959="$(( term_width_26958 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_26959}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_26973="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_26959}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_26974="${ret_cpad29_v0}"
    local gap_26975
    gap_26975="$(if [ "${small_26959}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_547=("")
    eprintf__2435_v0 " " array_547[@]
    if [ "${selected_26957}" != 0 ]; then
        # Yes selected
        background_secondary__2540_v0 "${yes_label_26973}"
        local ret_background_secondary2540_v0__16_30="${ret_background_secondary2540_v0}"
        local array_548=("")
        eprintf__2435_v0 "\\x1b[97m""${ret_background_secondary2540_v0__16_30}" array_548[@]
        local array_549=("")
        eprintf__2435_v0 "${gap_26975}" array_549[@]
        # No not selected (dim)
        local array_550=("")
        eprintf__2435_v0 "\\x1b[49;37m""${no_label_26974}""\\x1b[0m" array_550[@]
    else
        # No selected
        local array_551=("")
        eprintf__2435_v0 "\\x1b[49;37m""${yes_label_26973}""\\x1b[0m" array_551[@]
        local array_552=("")
        eprintf__2435_v0 "${gap_26975}" array_552[@]
        background_secondary__2540_v0 "${no_label_26974}"
        local ret_background_secondary2540_v0__24_30="${ret_background_secondary2540_v0}"
        local array_553=("")
        eprintf__2435_v0 "\\x1b[97m""${ret_background_secondary2540_v0__24_30}" array_553[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2728_v0() {
    local header_26913="${1}"
    local default_yes_26914="${2}"
    stty_lock__2475_v0 
    hide_cursor__2492_v0 
    term_width__2482_v0 
    local term_width_26919="${ret_term_width2482_v0}"
    if [ "$([ "_${header_26913}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2567_v0 "${header_26913}" "${term_width_26919}"
        local ret_cutoff_text2567_v0__46_17="${ret_cutoff_text2567_v0}"
        local array_554=("")
        eprintf__2435_v0 "${ret_cutoff_text2567_v0__46_17}""

" array_554[@]
    fi
    local selected_26956="${default_yes_26914}"
    # Render initial options
    render_confirm_options__2727_v0 "${selected_26956}" "${term_width_26919}"
    local array_555=("")
    eprintf__2435_v0 "

" array_555[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_556=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2594_v0 array_556[@] 40 "${term_width_26919}"
    go_up__2489_v0 2
    while :
    do
        get_key__2433_v0 
        local key_27001="${ret_get_key2433_v0}"
        if [ "$(( $(( $(( $([ "_${key_27001}" != "_LEFT" ]; echo $?) || $([ "_${key_27001}" != "_h" ]; echo $?) )) || $([ "_${key_27001}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_27001}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_26956}" != 0 ]; then
                selected_26956=0
                local array_557=("")
                eprintf__2435_v0 "\\x1b[G\\x1b[K" array_557[@]
                render_confirm_options__2727_v0 "${selected_26956}" "${term_width_26919}"
            elif [ "$(( ! selected_26956 ))" != 0 ]; then
                selected_26956=1
                local array_558=("")
                eprintf__2435_v0 "\\x1b[G\\x1b[K" array_558[@]
                render_confirm_options__2727_v0 "${selected_26956}" "${term_width_26919}"
            fi
        elif [ "$(( $([ "_${key_27001}" != "_y" ]; echo $?) || $([ "_${key_27001}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_26956=1
            break
        elif [ "$(( $([ "_${key_27001}" != "_n" ]; echo $?) || $([ "_${key_27001}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_26956=0
            break
        elif [ "$(( $([ "_${key_27001}" != "_INPUT" ]; echo $?) || $([ "_${key_27001}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_27002=4
    if [ "$([ "_${header_26913}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_27002="$(( total_lines_27002 + 1 ))"
    fi
    go_down__2490_v0 2
    remove_line__2485_v0 "$(( total_lines_27002 - 1 ))"
    remove_current_line__2486_v0 
    stty_unlock__2476_v0 
    show_cursor__2493_v0 
    ret_xyl_confirm2728_v0="${selected_26956}"
    return 0
}

# print_confirm_help()
print_confirm_help__2828_v0() {
    local usage_26843=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__2494_v0 usage_26843[@]
    printf '%s\n' ""
    colored_primary__2536_v0 "confirm"
    local ret_colored_primary2536_v0__8_20="${ret_colored_primary2536_v0}"
    local title_26867=("${ret_colored_primary2536_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__2494_v0 title_26867[@]
    printf '%s\n' ""
    colored_secondary__2537_v0 "Flags:"
    local ret_colored_secondary2537_v0__11_12="${ret_colored_secondary2537_v0}"
    local array_561=()
    printf__128_v0 "${ret_colored_secondary2537_v0__11_12}""
" array_561[@]
    local names_26869=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_26870=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_26871=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2669_v0 names_26869[@] texts_26870[@] notes_26871[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2886_v0() {
    local parameters_26826=("${!1}")
    colored_primary__2536_v0 "Are you sure?"
    local ret_colored_primary2536_v0__9_30="${ret_colored_primary2536_v0}"
    local header_26840="\\x1b[1m""${ret_colored_primary2536_v0__9_30}"
    local default_yes_26841=1
    for param_26842 in "${parameters_26826[@]}"; do
        starts_with__22_v0 "${param_26842}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_26842}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_26842}" != "_-h" ]; echo $?) || $([ "_${param_26842}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2828_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_567="--header="
            slice__24_v0 "${param_26842}" "${#__length_567}" 0
            header_26840="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_568="--default="
            slice__24_v0 "${param_26842}" "${#__length_568}" 0
            local value_26904="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_26904}" != "_yes" ]; echo $?) || $([ "_${value_26904}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_26841=1
            elif [ "$(( $([ "_${value_26904}" != "_no" ]; echo $?) || $([ "_${value_26904}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_26841=0
            else
                eprintf_colored__2436_v0 "ERROR: Invalid default value: ""${value_26904}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2560_v0 "${header_26840}"
    local ret_has_ansi_escape2560_v0__35_44="${ret_has_ansi_escape2560_v0}"
    escape_ansi__2561_v0 "${header_26840}"
    local ret_escape_ansi2561_v0__35_73="${ret_escape_ansi2561_v0}"
    colored_primary__2536_v0 "${header_26840}"
    local ret_colored_primary2536_v0__35_111="${ret_colored_primary2536_v0}"
    local display_header_26912
    display_header_26912="$(if [ "$(( $([ "_${header_26840}" != "_" ]; echo $?) || ret_has_ansi_escape2560_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2561_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary2536_v0__35_111}"; fi)"
    xyl_confirm__2728_v0 "${display_header_26912}" "${default_yes_26841}"
    local result_27008="${ret_xyl_confirm2728_v0}"
    ret_execute_confirm2886_v0="$(if [ "${result_27008}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3004_v0() {
    local format_36414="${1}"
    local args_36415=("${!2}")
    args_36415=("${format_36414}" "${args_36415[@]}")
    __status=$?
    printf "${args_36415[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3005_v0() {
    local message_36412="${1}"
    local color_36413="${2}"
    # Prints an error message with a specified color.
    local array_569=("${message_36412}")
    eprintf__3004_v0 "\\x1b[${color_36413}m%s\\x1b[0m" array_569[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3020_v0() {
    local format_36444="${1}"
    local args_36445=("${!2}")
    args_36445=("${format_36444}" "${args_36445[@]}")
    __status=$?
    printf "${args_36445[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_146="None"
# perl_available()
perl_available__3027_v0() {
    if [ "$([ "_${_perl_state_146}" != "_None" ]; echo $?)" != 0 ]; then
        local command_570
        command_570="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_36354
        disabled_36354="$([ "_${command_570}" != "_No" ]; echo $?)"
        local command_571
        command_571="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_36355
        found_36355="$(( $(( ! disabled_36354 )) && $([ "_${command_571}" != "_0" ]; echo $?) ))"
        _perl_state_146="$(if [ "${found_36355}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3027_v0="$([ "_${_perl_state_146}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3028_v0() {
    local text_36353="${1}"
    perl_available__3027_v0 
    local ret_perl_available3027_v0__19_12="${ret_perl_available3027_v0}"
    if [ "$(( ! ret_perl_available3027_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3028_v0=''
        return 1
    fi
    local command_572
    command_572="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_36353}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3028_v0=''
        return "${__status}"
    fi
    local width_str_36356="${command_572}"
    parse_int__13_v0 "${width_str_36356}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3028_v0=''
        return "${__status}"
    fi
    local width_36357="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3028_v0="${width_36357}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3033_v0() {
    local text_36346="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_573
    command_573="$([[ "${text_36346}" == *$'\x1b'* || "${text_36346}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_36347="${command_573}"
    ret_has_ansi_escape3033_v0="$([ "_${has_escape_36347}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3035_v0() {
    local text_36349="${1}"
    local command_574
    command_574="$(printf "%s" "${text_36349}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3035_v0="${command_574}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3036_v0() {
    local text_36351="${1}"
    local command_575
    command_575="$(printf "%s" "${text_36351}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_36352="${command_575}"
    ret_is_all_ascii3036_v0="$([ "_${result_36352}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3037_v0() {
    local text_36348="${1}"
    strip_ansi__3035_v0 "${text_36348}"
    local stripped_36350="${ret_strip_ansi3035_v0}"
    # Check if text is all ASCII
    is_all_ascii__3036_v0 "${stripped_36350}"
    local ret_is_all_ascii3036_v0__36_12="${ret_is_all_ascii3036_v0}"
    if [ "$(( ! ret_is_all_ascii3036_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__3028_v0 "${stripped_36350}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_576="${stripped_36350}"
            ret_get_visible_len3037_v0="${#__length_576}"
            return 0
        fi
        ret_get_visible_len3037_v0="${ret_perl_get_cjk_width3028_v0}"
        return 0
    else
        local __length_577="${stripped_36350}"
        ret_get_visible_len3037_v0="${#__length_577}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_147=0
_term_size_148=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__3043_v0() {
    local command_579
    command_579="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_36420="${command_579}"
    parse_int__13_v0 "${count_36420}"
    __status=$?
    ret_stty_count3043_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3044_v0() {
    stty_count__3043_v0 
    local count_num_36421="${ret_stty_count3043_v0}"
    if [ "$(( count_num_36421 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_36421="$(( count_num_36421 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_36421}
    __status=$?
}

# stty_unlock()
stty_unlock__3045_v0() {
    stty_count__3043_v0 
    local count_num_36442="${ret_stty_count3043_v0}"
    if [ "$(( count_num_36442 > 0 ))" != 0 ]; then
        count_num_36442="$(( count_num_36442 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_36442}
        __status=$?
        if [ "$(( count_num_36442 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3046_v0() {
    local size_36337="${1}"
    if [ "$([ "_${size_36337}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3046_v0=0
        return 0
    fi
    split__4_v0 "${size_36337}" " "
    local parts_36338=("${ret_split4_v0[@]}")
    local __length_580=("${parts_36338[@]}")
    if [ "$(( ${#__length_580[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3046_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_36338[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_36338[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_148=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3046_v0=1
    return 0
}

# query_term_size()
query_term_size__3047_v0() {
    local command_582
    command_582="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_36340="${command_582}"
    store_term_size__3046_v0 "${size_36340}"
    ret_query_term_size3047_v0="${ret_store_term_size3046_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3048_v0() {
    local command_583
    command_583="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_36336="${command_583}"
    store_term_size__3046_v0 "${size_36336}"
    ret_stty_term_size3048_v0="${ret_store_term_size3046_v0}"
    return 0
}

# get_term_size()
get_term_size__3049_v0() {
    stty_term_size__3048_v0 
    local detected_36339="${ret_stty_term_size3048_v0}"
    if [ "$(( ! detected_36339 ))" != 0 ]; then
        query_term_size__3047_v0 
        detected_36339="${ret_query_term_size3047_v0}"
    fi
    _got_term_size_147=1
}

# term_width()
term_width__3051_v0() {
    if [ "$(( ! _got_term_size_147 ))" != 0 ]; then
        get_term_size__3049_v0 
    fi
    ret_term_width3051_v0="${_term_size_148[0]?"Index out of bounds (at src/./file/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__3055_v0() {
    local array_584=("")
    eprintf__3020_v0 "\\x1b[2K\\x1b[G" array_584[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__3063_v0() {
    local pieces_36335=("${!1}")
    term_width__3051_v0 
    local width_36341="${ret_term_width3051_v0}"
    local line_36342=""
    local line_len_36343=0
    for piece_36344 in "${pieces_36335[@]}"; do
        local __length_587="${piece_36344}"
        local piece_len_36345="${#__length_587}"
        has_ansi_escape__3033_v0 "${piece_36344}"
        local ret_has_ansi_escape3033_v0__186_12="${ret_has_ansi_escape3033_v0}"
        if [ "${ret_has_ansi_escape3033_v0__186_12}" != 0 ]; then
            get_visible_len__3037_v0 "${piece_36344}"
            piece_len_36345="${ret_get_visible_len3037_v0}"
        fi
        if [ "$([ "_${line_36342}" != "_" ]; echo $?)" != 0 ]; then
            line_36342="${piece_36344}"
            line_len_36343="${piece_len_36345}"
        elif [ "$(( $(( $(( line_len_36343 + 1 )) + piece_len_36345 )) > width_36341 ))" != 0 ]; then
            local array_588=()
            printf__128_v0 "${line_36342}""
" array_588[@]
            line_36342="${piece_36344}"
            line_len_36343="${piece_len_36345}"
        else
            line_36342+=" ""${piece_36344}"
            line_len_36343="$(( line_len_36343 + $(( 1 + piece_len_36345 )) ))"
        fi
    done
    if [ "$([ "_${line_36342}" == "_" ]; echo $?)" != 0 ]; then
        local array_589=()
        printf__128_v0 "${line_36342}""
" array_589[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_149=3
# get_directory_entries(path: Text)
get_directory_entries__3085_v0() {
    local path_36425="${1}"
    local __ls_path_590="${path_36425}"
    __ls_path_590="${__ls_path_590//\\/\\\\}"
    (( 1 )) && __ls_all_590="-A" || __ls_all_590=""
    (( 0 )) && __ls_rec_590="-R" || __ls_rec_590=""
    local __ls_590=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_590 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_590} ${__ls_rec_590} ${__ls_path_590}
    __status=$?
    );
    local names_36426=("${__ls_590[@]}")
    local command_591
    command_591="$(LC_ALL=C ls -lA "${path_36425}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_36427="${command_591}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_592
    command_592="$(LC_ALL=C ls -lA "${path_36425}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_36428="${command_592}"
    split__4_v0 "${types_output_36427}" "
"
    local types_36429=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_36428}" "
"
    local targets_36430=("${ret_split4_v0[@]}")
    local entries_36431=()
    local __range_start_36432=0
    local __length_594=("${names_36426[@]}")
    local __range_end_36432="${#__length_594[@]}"
    local __dir_36432=$(( ${__range_start_36432} <= ${__range_end_36432} ? 1 : -1 ))
    for (( i_36432=${__range_start_36432}; i_36432 * ${__dir_36432} < ${__range_end_36432} * ${__dir_36432}; i_36432+=${__dir_36432} )); do
        local array_595=("${names_36426[${i_36432}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_36431+=("${array_595[@]}")
        local array_596=("${types_36429[${i_36432}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_36431+=("${array_596[@]}")
        slice__24_v0 "${targets_36430[${i_36432}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_597=("${ret_slice24_v0__31_21}")
        entries_36431+=("${array_597[@]}")
done
    ret_get_directory_entries3085_v0=("${entries_36431[@]}")
    return 0
}

# get_cwd()
get_cwd__3086_v0() {
    local command_598
    command_598="$(pwd)"
    __status=$?
    ret_get_cwd3086_v0="${command_598}"
    return 0
}

# normalize_path(path: Text)
normalize_path__3087_v0() {
    local path_36423="${1}"
    local command_599
    command_599="$(cd "${path_36423}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_36424="${command_599}"
    if [ "$([ "_${normalized_36424}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path3087_v0="${path_36423}"
        return 0
    fi
    ret_normalize_path3087_v0="${normalized_36424}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__3088_v0() {
    local base_36606="${1}"
    local child_36607="${2}"
    if [ "$([ "_${base_36606}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join3088_v0="/""${child_36607}"
        return 0
    fi
    ret_path_join3088_v0="${base_36606}""/""${child_36607}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__3089_v0() {
    local path_36604="${1}"
    local command_600
    command_600="$(dirname "${path_36604}")"
    __status=$?
    local parent_36605="${command_600}"
    ret_get_parent_dir3089_v0="${parent_36605}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_151="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_152=0
_primary_color_153=(3 207 159 92)
_secondary_color_154=(3 118 206 94)
_accent_color_155=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__3100_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_36370="${ret_env_var_get120_v0}"
    _supports_truecolor_151="$(if [ "$([ "_${config_36370}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3100_v0="$([ "_${_supports_truecolor_151}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3101_v0() {
    local message_36365="${1}"
    local r_36366="${2}"
    local g_36367="${3}"
    local b_36368="${4}"
    local fallback_36369="${5}"
    if [ "$([ "_${_supports_truecolor_151}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3101_v0="\\x1b[38;2;${r_36366};${g_36367};${b_36368}m""${message_36365}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_151}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3100_v0 
        local ret_get_supports_truecolor3100_v0__45_17="${ret_get_supports_truecolor3100_v0}"
        if [ "${ret_get_supports_truecolor3100_v0__45_17}" != 0 ]; then
            ret_colored_rgb3101_v0="\\x1b[38;2;${r_36366};${g_36367};${b_36368}m""${message_36365}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_36369 == 0 ))" != 0 ]; then
            ret_colored_rgb3101_v0="${message_36365}"
            return 0
        else
            ret_colored_rgb3101_v0="\\x1b[${fallback_36369}m""${message_36365}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_36369 == 0 ))" != 0 ]; then
            ret_colored_rgb3101_v0="${message_36365}"
            return 0
        fi
        ret_colored_rgb3101_v0="\\x1b[${fallback_36369}m""${message_36365}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3103_v0() {
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_36359="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_36359}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_36359}" ";"
            local parts_36360=("${ret_split4_v0[@]}")
            local __length_604=("${parts_36360[@]}")
            if [ "$(( ${#__length_604[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_36360[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36360[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36360[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36360[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_153=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_36361="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_36361}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_36361}" ";"
            local parts_36362=("${ret_split4_v0[@]}")
            local __length_606=("${parts_36362[@]}")
            if [ "$(( ${#__length_606[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_36362[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36362[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36362[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36362[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_154=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_36363="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_36363}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_36363}" ";"
            local parts_36364=("${ret_split4_v0[@]}")
            local __length_608=("${parts_36364[@]}")
            if [ "$(( ${#__length_608[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_36364[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36364[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36364[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36364[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3103_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_155=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_152=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3104_v0() {
    inner_get_xylitol_colors__3103_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_152=1
}

# colored_primary(message: Text)
colored_primary__3105_v0() {
    local message_36358="${1}"
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        get_xylitol_colors__3104_v0 
    fi
    colored_rgb__3101_v0 "${message_36358}" "${_primary_color_153[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_153[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_153[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_153[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary3105_v0="${ret_colored_rgb3101_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__3106_v0() {
    local message_36372="${1}"
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        get_xylitol_colors__3104_v0 
    fi
    colored_rgb__3101_v0 "${message_36372}" "${_secondary_color_154[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_154[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_154[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_154[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3106_v0="${ret_colored_rgb3101_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__3107_v0() {
    local message_36540="${1}"
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        get_xylitol_colors__3104_v0 
    fi
    colored_rgb__3101_v0 "${message_36540}" "${_accent_color_155[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_155[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_155[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_155[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent3107_v0="${ret_colored_rgb3101_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__3159_v0() {
    local message_36406="${1}"
    local color_36407="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3159_v0="\\x1b[${color_36407}m""${message_36406}""\\x1b[0m"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_159=0
_term_size_160=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__3199_v0() {
    local size_36385="${1}"
    if [ "$([ "_${size_36385}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3199_v0=0
        return 0
    fi
    split__4_v0 "${size_36385}" " "
    local parts_36386=("${ret_split4_v0[@]}")
    local __length_611=("${parts_36386[@]}")
    if [ "$(( ${#__length_611[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3199_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_36386[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_36386[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_160=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3199_v0=1
    return 0
}

# query_term_size()
query_term_size__3200_v0() {
    local command_613
    command_613="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_36388="${command_613}"
    store_term_size__3199_v0 "${size_36388}"
    ret_query_term_size3200_v0="${ret_store_term_size3199_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3201_v0() {
    local command_614
    command_614="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_36384="${command_614}"
    store_term_size__3199_v0 "${size_36384}"
    ret_stty_term_size3201_v0="${ret_store_term_size3199_v0}"
    return 0
}

# get_term_size()
get_term_size__3202_v0() {
    stty_term_size__3201_v0 
    local detected_36387="${ret_stty_term_size3201_v0}"
    if [ "$(( ! detected_36387 ))" != 0 ]; then
        query_term_size__3200_v0 
        detected_36387="${ret_query_term_size3200_v0}"
    fi
    _got_term_size_159=1
}

# term_width()
term_width__3204_v0() {
    if [ "$(( ! _got_term_size_159 ))" != 0 ]; then
        get_term_size__3202_v0 
    fi
    ret_term_width3204_v0="${_term_size_160[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__3237_v0() {
    local pending_36403="${1}"
    local line_36404="${2}"
    local note_at_36405="${3}"
    if [ "$(( note_at_36405 < 0 ))" != 0 ]; then
        local array_616=()
        printf__128_v0 "${pending_36403}""${line_36404}""
" array_616[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_36405 == 0 ))" != 0 ]; then
        colored__3159_v0 "${line_36404}" 90
        local ret_colored3159_v0__12_40="${ret_colored3159_v0}"
        local array_617=()
        printf__128_v0 "${pending_36403}""${ret_colored3159_v0__12_40}""
" array_617[@]
    else
        slice__24_v0 "${line_36404}" 0 "${note_at_36405}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_36404}" "${note_at_36405}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__3159_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored3159_v0__13_58="${ret_colored3159_v0}"
        local array_618=()
        printf__128_v0 "${pending_36403}""${ret_slice24_v0__13_32}""${ret_colored3159_v0__13_58}""
" array_618[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__3238_v0() {
    local names_36376=("${!1}")
    local texts_36377=("${!2}")
    local notes_36378=("${!3}")
    local min_name_width_36379="${4}"
    local __length_619=("${names_36376[@]}")
    local count_36380="${#__length_619[@]}"
    local name_width_36381="${min_name_width_36379}"
    local __range_start_36382=0
    local __range_end_36382="${count_36380}"
    local __dir_36382=$(( ${__range_start_36382} <= ${__range_end_36382} ? 1 : -1 ))
    for (( i_36382=${__range_start_36382}; i_36382 * ${__dir_36382} < ${__range_end_36382} * ${__dir_36382}; i_36382+=${__dir_36382} )); do
        local __length_620="${names_36376[${i_36382}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_36383="${#__length_620}"
        if [ "$(( width_36383 > name_width_36381 ))" != 0 ]; then
            name_width_36381="${width_36383}"
        fi
done
    term_width__3204_v0 
    local width_36389="${ret_term_width3204_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_36390="$(( name_width_36381 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_36391="$(( $(( width_36389 - indent_36390 )) < 24 ))"
    if [ "${stacked_36391}" != 0 ]; then
        indent_36390=6
    fi
    local avail_36392="$(( width_36389 - indent_36390 ))"
    rpad__28_v0 "" " " "${indent_36390}"
    local blank_36393="${ret_rpad28_v0}"
    local __range_start_36394=0
    local __range_end_36394="${count_36380}"
    local __dir_36394=$(( ${__range_start_36394} <= ${__range_end_36394} ? 1 : -1 ))
    for (( i_36394=${__range_start_36394}; i_36394 * ${__dir_36394} < ${__range_end_36394} * ${__dir_36394}; i_36394+=${__dir_36394} )); do
        local pending_36395="${blank_36393}"
        if [ "${stacked_36391}" != 0 ]; then
            local array_621=()
            printf__128_v0 "  ""${names_36376[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_621[@]
        else
            rpad__28_v0 "  ""${names_36376[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_36390}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_36395="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_36377[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_36396=("${ret_split4_v0__52_21[@]}")
        local __length_622=("${words_36396[@]}")
        local note_start_36397="${#__length_622[@]}"
        if [ "$([ "_${notes_36378[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_623="${notes_36378[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_623} > avail_36392 ))" != 0 ]; then
                split__4_v0 "${notes_36378[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_36396+=("${ret_split4_v0__58_26[@]}")
            else
                local array_624=("${notes_36378[${i_36394}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_36396+=("${array_624[@]}")
            fi
        fi
        local line_36398=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_36399=-1
        local __range_start_36400=0
        local __length_625=("${words_36396[@]}")
        local __range_end_36400="${#__length_625[@]}"
        local __dir_36400=$(( ${__range_start_36400} <= ${__range_end_36400} ? 1 : -1 ))
        for (( j_36400=${__range_start_36400}; j_36400 * ${__dir_36400} < ${__range_end_36400} * ${__dir_36400}; j_36400+=${__dir_36400} )); do
            local word_36401="${words_36396[${j_36400}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_36402
            candidate_36402="$(if [ "$([ "_${line_36398}" != "_" ]; echo $?)" != 0 ]; then echo "${word_36401}"; else echo "${line_36398}"" ""${word_36401}"; fi)"
            local __length_626="${candidate_36402}"
            if [ "$(( $(( ${#__length_626} > avail_36392 )) && $([ "_${line_36398}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__3237_v0 "${pending_36395}" "${line_36398}" "${note_at_36399}"
                pending_36395="${blank_36393}"
                line_36398="${word_36401}"
                note_at_36399="$(if [ "$(( j_36400 >= note_start_36397 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_36400 >= note_start_36397 )) && $(( note_at_36399 < 0 )) ))" != 0 ]; then
                    local __length_627="${candidate_36402}"
                    local __length_628="${word_36401}"
                    note_at_36399="$(( ${#__length_627} - ${#__length_628} ))"
                fi
                line_36398="${candidate_36402}"
            fi
done
        print_help_line__3237_v0 "${pending_36395}" "${line_36398}" "${note_at_36399}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__3346_v0() {
    local command_629
    command_629="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key3346_v0="${command_629}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3348_v0() {
    local format_36501="${1}"
    local args_36502=("${!2}")
    args_36502=("${format_36501}" "${args_36502[@]}")
    __status=$?
    printf "${args_36502[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3349_v0() {
    local message_36508="${1}"
    local color_36509="${2}"
    # Prints an error message with a specified color.
    local array_630=("${message_36508}")
    eprintf__3348_v0 "\\x1b[${color_36509}m%s\\x1b[0m" array_630[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3364_v0() {
    local format_36454="${1}"
    local args_36455=("${!2}")
    args_36455=("${format_36454}" "${args_36455[@]}")
    __status=$?
    printf "${args_36455[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_167=0
_term_size_168=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__3387_v0() {
    local command_632
    command_632="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_36452="${command_632}"
    parse_int__13_v0 "${count_36452}"
    __status=$?
    ret_stty_count3387_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3388_v0() {
    stty_count__3387_v0 
    local count_num_36453="${ret_stty_count3387_v0}"
    if [ "$(( count_num_36453 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_36453="$(( count_num_36453 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_36453}
    __status=$?
}

# stty_unlock()
stty_unlock__3389_v0() {
    stty_count__3387_v0 
    local count_num_36601="${ret_stty_count3387_v0}"
    if [ "$(( count_num_36601 > 0 ))" != 0 ]; then
        count_num_36601="$(( count_num_36601 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_36601}
        __status=$?
        if [ "$(( count_num_36601 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3390_v0() {
    local size_36457="${1}"
    if [ "$([ "_${size_36457}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3390_v0=0
        return 0
    fi
    split__4_v0 "${size_36457}" " "
    local parts_36458=("${ret_split4_v0[@]}")
    local __length_633=("${parts_36458[@]}")
    if [ "$(( ${#__length_633[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3390_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_36458[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_36458[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_168=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3390_v0=1
    return 0
}

# query_term_size()
query_term_size__3391_v0() {
    local command_635
    command_635="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_36460="${command_635}"
    store_term_size__3390_v0 "${size_36460}"
    ret_query_term_size3391_v0="${ret_store_term_size3390_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3392_v0() {
    local command_636
    command_636="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_36456="${command_636}"
    store_term_size__3390_v0 "${size_36456}"
    ret_stty_term_size3392_v0="${ret_store_term_size3390_v0}"
    return 0
}

# get_term_size()
get_term_size__3393_v0() {
    stty_term_size__3392_v0 
    local detected_36459="${ret_stty_term_size3392_v0}"
    if [ "$(( ! detected_36459 ))" != 0 ]; then
        query_term_size__3391_v0 
        detected_36459="${ret_query_term_size3391_v0}"
    fi
    _got_term_size_167=1
}

# term_width()
term_width__3395_v0() {
    if [ "$(( ! _got_term_size_167 ))" != 0 ]; then
        get_term_size__3393_v0 
    fi
    ret_term_width3395_v0="${_term_size_168[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__3396_v0() {
    if [ "$(( ! _got_term_size_167 ))" != 0 ]; then
        get_term_size__3393_v0 
    fi
    ret_term_height3396_v0="${_term_size_168[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__3398_v0() {
    local cnt_36572="${1}"
    if [ "$(( cnt_36572 > 0 ))" != 0 ]; then
        local sequence_36573=""
        local __range_start_36574=0
        local __range_end_36574="${cnt_36572}"
        local __dir_36574=$(( ${__range_start_36574} <= ${__range_end_36574} ? 1 : -1 ))
        for (( ____36574=${__range_start_36574}; ____36574 * ${__dir_36574} < ${__range_end_36574} * ${__dir_36574}; ____36574+=${__dir_36574} )); do
            sequence_36573+="\\x1b[2K\\x1b[1A"
done
        local array_637=("")
        eprintf__3364_v0 "${sequence_36573}" array_637[@]
    fi
    local array_638=("")
    eprintf__3364_v0 "\\x1b[G" array_638[@]
}

# remove_current_line()
remove_current_line__3399_v0() {
    local array_639=("")
    eprintf__3364_v0 "\\x1b[2K\\x1b[G" array_639[@]
}

# print_blank(cnt: Int)
print_blank__3400_v0() {
    local cnt_36563="${1}"
    printf '%*s' "${cnt_36563}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__3401_v0() {
    local cnt_36506="${1}"
    local __range_start_36507=0
    local __range_end_36507="${cnt_36506}"
    local __dir_36507=$(( ${__range_start_36507} <= ${__range_end_36507} ? 1 : -1 ))
    for (( ____36507=${__range_start_36507}; ____36507 * ${__dir_36507} < ${__range_end_36507} * ${__dir_36507}; ____36507+=${__dir_36507} )); do
        local array_640=("")
        eprintf__3364_v0 "
" array_640[@]
done
}

# go_up(cnt: Int)
go_up__3402_v0() {
    local cnt_36529="${1}"
    local array_641=("")
    eprintf__3364_v0 "\\x1b[${cnt_36529}A" array_641[@]
}

# go_down(cnt: Int)
go_down__3403_v0() {
    local cnt_36600="${1}"
    local array_642=("")
    eprintf__3364_v0 "\\x1b[${cnt_36600}B" array_642[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__3405_v0() {
    local array_643=("")
    eprintf__3364_v0 "\\x1b[?25l" array_643[@]
}

# show_cursor()
show_cursor__3406_v0() {
    local array_644=("")
    eprintf__3364_v0 "\\x1b[?25h" array_644[@]
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_171="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_172=0
_secondary_color_174=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__3444_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_36562="${ret_env_var_get120_v0}"
    _supports_truecolor_171="$(if [ "$([ "_${config_36562}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3444_v0="$([ "_${_supports_truecolor_171}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3445_v0() {
    local message_36557="${1}"
    local r_36558="${2}"
    local g_36559="${3}"
    local b_36560="${4}"
    local fallback_36561="${5}"
    if [ "$([ "_${_supports_truecolor_171}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3445_v0="\\x1b[38;2;${r_36558};${g_36559};${b_36560}m""${message_36557}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_171}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3444_v0 
        local ret_get_supports_truecolor3444_v0__45_17="${ret_get_supports_truecolor3444_v0}"
        if [ "${ret_get_supports_truecolor3444_v0__45_17}" != 0 ]; then
            ret_colored_rgb3445_v0="\\x1b[38;2;${r_36558};${g_36559};${b_36560}m""${message_36557}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_36561 == 0 ))" != 0 ]; then
            ret_colored_rgb3445_v0="${message_36557}"
            return 0
        else
            ret_colored_rgb3445_v0="\\x1b[${fallback_36561}m""${message_36557}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_36561 == 0 ))" != 0 ]; then
            ret_colored_rgb3445_v0="${message_36557}"
            return 0
        fi
        ret_colored_rgb3445_v0="\\x1b[${fallback_36561}m""${message_36557}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3447_v0() {
    if [ "$(( ! _got_xylitol_colors_172 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_36551="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_36551}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_36551}" ";"
            local parts_36552=("${ret_split4_v0[@]}")
            local __length_648=("${parts_36552[@]}")
            if [ "$(( ${#__length_648[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_36552[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36552[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36552[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36552[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_36553="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_36553}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_36553}" ";"
            local parts_36554=("${ret_split4_v0[@]}")
            local __length_650=("${parts_36554[@]}")
            if [ "$(( ${#__length_650[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_36554[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36554[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36554[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36554[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_174=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_36555="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_36555}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_36555}" ";"
            local parts_36556=("${ret_split4_v0[@]}")
            local __length_652=("${parts_36556[@]}")
            if [ "$(( ${#__length_652[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_36556[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36556[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36556[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_36556[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3447_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_172=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3448_v0() {
    inner_get_xylitol_colors__3447_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_172=1
}

# colored_secondary(message: Text)
colored_secondary__3450_v0() {
    local message_36550="${1}"
    if [ "$(( ! _got_xylitol_colors_172 ))" != 0 ]; then
        get_xylitol_colors__3448_v0 
    fi
    colored_rgb__3445_v0 "${message_36550}" "${_secondary_color_174[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_174[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_174[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_174[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3450_v0="${ret_colored_rgb3445_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_176="None"
# perl_available()
perl_available__3467_v0() {
    if [ "$([ "_${_perl_state_176}" != "_None" ]; echo $?)" != 0 ]; then
        local command_654
        command_654="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_36471
        disabled_36471="$([ "_${command_654}" != "_No" ]; echo $?)"
        local command_655
        command_655="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_36472
        found_36472="$(( $(( ! disabled_36471 )) && $([ "_${command_655}" != "_0" ]; echo $?) ))"
        _perl_state_176="$(if [ "${found_36472}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3467_v0="$([ "_${_perl_state_176}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3468_v0() {
    local text_36470="${1}"
    perl_available__3467_v0 
    local ret_perl_available3467_v0__19_12="${ret_perl_available3467_v0}"
    if [ "$(( ! ret_perl_available3467_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3468_v0=''
        return 1
    fi
    local command_656
    command_656="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_36470}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3468_v0=''
        return "${__status}"
    fi
    local width_str_36473="${command_656}"
    parse_int__13_v0 "${width_str_36473}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3468_v0=''
        return "${__status}"
    fi
    local width_36474="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3468_v0="${width_36474}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__3469_v0() {
    local text_36483="${1}"
    local max_width_36484="${2}"
    perl_available__3467_v0 
    local ret_perl_available3467_v0__30_12="${ret_perl_available3467_v0}"
    if [ "$(( ! ret_perl_available3467_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk3469_v0=''
        return 1
    fi
    local command_657
    command_657="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_36483}" ${max_width_36484} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk3469_v0=''
        return "${__status}"
    fi
    local result_36485="${command_657}"
    ret_perl_truncate_cjk3469_v0="${result_36485}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3473_v0() {
    local text_36478="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_658
    command_658="$([[ "${text_36478}" == *$'\x1b'* || "${text_36478}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_36479="${command_658}"
    ret_has_ansi_escape3473_v0="$([ "_${has_escape_36479}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3475_v0() {
    local text_36466="${1}"
    local command_659
    command_659="$(printf "%s" "${text_36466}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3475_v0="${command_659}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3476_v0() {
    local text_36468="${1}"
    local command_660
    command_660="$(printf "%s" "${text_36468}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_36469="${command_660}"
    ret_is_all_ascii3476_v0="$([ "_${result_36469}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3477_v0() {
    local text_36465="${1}"
    strip_ansi__3475_v0 "${text_36465}"
    local stripped_36467="${ret_strip_ansi3475_v0}"
    # Check if text is all ASCII
    is_all_ascii__3476_v0 "${stripped_36467}"
    local ret_is_all_ascii3476_v0__36_12="${ret_is_all_ascii3476_v0}"
    if [ "$(( ! ret_is_all_ascii3476_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__3468_v0 "${stripped_36467}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_661="${stripped_36467}"
            ret_get_visible_len3477_v0="${#__length_661}"
            return 0
        fi
        ret_get_visible_len3477_v0="${ret_perl_get_cjk_width3468_v0}"
        return 0
    else
        local __length_662="${stripped_36467}"
        ret_get_visible_len3477_v0="${#__length_662}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__3478_v0() {
    local text_36480="${1}"
    local max_width_36481="${2}"
    get_visible_len__3477_v0 "${text_36480}"
    local visible_len_36482="${ret_get_visible_len3477_v0}"
    if [ "$(( visible_len_36482 <= max_width_36481 ))" != 0 ]; then
        ret_truncate_text3478_v0="${text_36480}"
        return 0
    fi
    is_all_ascii__3476_v0 "${text_36480}"
    local ret_is_all_ascii3476_v0__53_12="${ret_is_all_ascii3476_v0}"
    if [ "$(( ! ret_is_all_ascii3476_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__3469_v0 "${text_36480}" "${max_width_36481}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_36480}" | cut -c1-${max_width_36481}
            __status=$?
        fi
        ret_truncate_text3478_v0="${ret_perl_truncate_cjk3469_v0}"
        return 0
    fi
    local command_663
    command_663="$(printf "%s" "${text_36480}" | cut -c1-${max_width_36481})"
    __status=$?
    ret_truncate_text3478_v0="${command_663}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__3479_v0() {
    local text_36476="${1}"
    local max_width_36477="${2}"
    has_ansi_escape__3473_v0 "${text_36476}"
    local ret_has_ansi_escape3473_v0__65_12="${ret_has_ansi_escape3473_v0}"
    if [ "$(( ! ret_has_ansi_escape3473_v0__65_12 ))" != 0 ]; then
        truncate_text__3478_v0 "${text_36476}" "${max_width_36477}"
        ret_truncate_ansi3479_v0="${ret_truncate_text3478_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_664
    command_664="$([[ "${text_36476}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_36486="${command_664}"
    # Replace \x1b[ with newline, then split
    local command_665
    command_665="$(t="${text_36476}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_36487="${command_665}"
    split__4_v0 "${replaced_36487}" "
"
    local parts_36488=("${ret_split4_v0[@]}")
    local result_36489=""
    local remaining_width_36490="${max_width_36477}"
    local __range_start_36491=0
    local __length_666=("${parts_36488[@]}")
    local __range_end_36491="${#__length_666[@]}"
    local __dir_36491=$(( ${__range_start_36491} <= ${__range_end_36491} ? 1 : -1 ))
    for (( idx_36491=${__range_start_36491}; idx_36491 * ${__dir_36491} < ${__range_end_36491} * ${__dir_36491}; idx_36491+=${__dir_36491} )); do
        local part_36492="${parts_36488[${idx_36491}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_36491 == 0 )) && $([ "_${starts_with_ansi_36486}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_36492}" == "_" ]; echo $?) && $(( remaining_width_36490 > 0 )) ))" != 0 ]; then
                truncate_text__3478_v0 "${part_36492}" "${remaining_width_36490}"
                local ret_truncate_text3478_v0__87_35="${ret_truncate_text3478_v0}"
                local truncated_36493="${ret_truncate_text3478_v0__87_35}"
                result_36489+="${truncated_36493}"
                get_visible_len__3477_v0 "${truncated_36493}"
                local ret_get_visible_len3477_v0__89_36="${ret_get_visible_len3477_v0}"
                remaining_width_36490="$(( remaining_width_36490 - ret_get_visible_len3477_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_667
            command_667="$(__p="${part_36492}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_36494="${command_667}"
            if [ "$([ "_${m_idx_36494}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_668
                command_668="$(__p="${part_36492}"; printf "%s" "${__p:0:${m_idx_36494}}")"
                __status=$?
                local ansi_params_36495="${command_668}"
                result_36489+="\\x1b[""${ansi_params_36495}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_36494}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_36496="${ret_parse_int13_v0__100_41}"
                local text_start_36497="$(( m_idx_num_36496 + 1 ))"
                local command_669
                command_669="$(__p="${part_36492}"; printf "%s" "${__p:${text_start_36497}}")"
                __status=$?
                local text_part_36498="${command_669}"
                if [ "$(( $([ "_${text_part_36498}" == "_" ]; echo $?) && $(( remaining_width_36490 > 0 )) ))" != 0 ]; then
                    truncate_text__3478_v0 "${text_part_36498}" "${remaining_width_36490}"
                    local ret_truncate_text3478_v0__104_39="${ret_truncate_text3478_v0}"
                    local truncated_36499="${ret_truncate_text3478_v0__104_39}"
                    result_36489+="${truncated_36499}"
                    get_visible_len__3477_v0 "${truncated_36499}"
                    local ret_get_visible_len3477_v0__106_40="${ret_get_visible_len3477_v0}"
                    remaining_width_36490="$(( remaining_width_36490 - ret_get_visible_len3477_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_36492}" == "_" ]; echo $?) && $(( remaining_width_36490 > 0 )) ))" != 0 ]; then
                    truncate_text__3478_v0 "${part_36492}" "${remaining_width_36490}"
                    local ret_truncate_text3478_v0__111_39="${ret_truncate_text3478_v0}"
                    local truncated_36500="${ret_truncate_text3478_v0__111_39}"
                    result_36489+="${truncated_36500}"
                    get_visible_len__3477_v0 "${truncated_36500}"
                    local ret_get_visible_len3477_v0__113_40="${ret_get_visible_len3477_v0}"
                    remaining_width_36490="$(( remaining_width_36490 - ret_get_visible_len3477_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi3479_v0="${result_36489}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__3480_v0() {
    local text_36463="${1}"
    local max_width_36464="${2}"
    get_visible_len__3477_v0 "${text_36463}"
    local visible_len_36475="${ret_get_visible_len3477_v0}"
    if [ "$(( visible_len_36475 <= max_width_36464 ))" != 0 ]; then
        ret_cutoff_text3480_v0="${text_36463}"
        return 0
    fi
    truncate_ansi__3479_v0 "${text_36463}" "$(( max_width_36464 - 3 ))"
    local ret_truncate_ansi3479_v0__129_12="${ret_truncate_ansi3479_v0}"
    ret_cutoff_text3480_v0="${ret_truncate_ansi3479_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__3501_v0() {
    local format_36518="${1}"
    local args_36519=("${!2}")
    args_36519=("${format_36518}" "${args_36519[@]}")
    __status=$?
    printf "${args_36519[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3502_v0() {
    local message_36516="${1}"
    local color_36517="${2}"
    # Prints an error message with a specified color.
    local array_670=("${message_36516}")
    eprintf__3501_v0 "\\x1b[${color_36517}m%s\\x1b[0m" array_670[@]
}

# colored(message: Text, color: Int)
colored__3503_v0() {
    local message_36520="${1}"
    local color_36521="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3503_v0="\\x1b[${color_36521}m""${message_36520}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__3507_v0() {
    local items_36510=("${!1}")
    local total_len_36511="${2}"
    local term_width_36512="${3}"
    local separator_36513=" • "
    local separator_len_36514=3
    # Fast path: no truncation needed
    if [ "$(( total_len_36511 <= term_width_36512 ))" != 0 ]; then
        local iter_36515=0
        while :
        do
            local __length_671=("${items_36510[@]}")
            if [ "$(( iter_36515 >= ${#__length_671[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_36515 > 0 ))" != 0 ]; then
                eprintf_colored__3502_v0 "${separator_36513}" 90
            fi
            colored__3503_v0 "${items_36510[$(( iter_36515 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored3503_v0__23_41="${ret_colored3503_v0}"
            local array_672=("")
            eprintf__3501_v0 "${items_36510[${iter_36515}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored3503_v0__23_41}" array_672[@]
            iter_36515="$(( iter_36515 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_36522=0
        local first_36523=1
        local iter_36524=0
        while :
        do
            local __length_673=("${items_36510[@]}")
            if [ "$(( iter_36524 >= ${#__length_673[@]} ))" != 0 ]; then
                break
            fi
            local key_36525="${items_36510[${iter_36524}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_36526="${items_36510[$(( iter_36524 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_674="${key_36525}"
            local __length_675="${action_36526}"
            local part_len_36527="$(( $(( ${#__length_674} + 1 )) + ${#__length_675} ))"
            local needed_36528="${part_len_36527}"
            if [ "$(( ! first_36523 ))" != 0 ]; then
                needed_36528="$(( needed_36528 + separator_len_36514 ))"
            fi
            if [ "$(( $(( current_len_36522 + needed_36528 )) > term_width_36512 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_36523 ))" != 0 ]; then
                eprintf_colored__3502_v0 "${separator_36513}" 90
            fi
            colored__3503_v0 "${action_36526}" 2
            local ret_colored3503_v0__51_33="${ret_colored3503_v0}"
            local array_676=("")
            eprintf__3501_v0 "${key_36525}"" ""${ret_colored3503_v0__51_33}" array_676[@]
            current_len_36522="$(( current_len_36522 + needed_36528 ))"
            first_36523=0
            iter_36524="$(( iter_36524 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__3517_v0() {
    local format_36588="${1}"
    local args_36589=("${!2}")
    args_36589=("${format_36588}" "${args_36589[@]}")
    __status=$?
    printf "${args_36589[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# // Cursor /////
# go_up(cnt: Int)
go_up__3555_v0() {
    local cnt_36587="${1}"
    local array_678=("")
    eprintf__3517_v0 "\\x1b[${cnt_36587}A" array_678[@]
}

# go_down(cnt: Int)
go_down__3556_v0() {
    local cnt_36590="${1}"
    local array_679=("")
    eprintf__3517_v0 "\\x1b[${cnt_36590}B" array_679[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3563_v0() {
    local display_count_36584="${1}"
    local index_36585="${2}"
    local line_36586="${3}"
    go_up__3555_v0 "$(( display_count_36584 - index_36585 ))"
    local array_680=("")
    eprintf__3501_v0 "\\x1b[G\\x1b[K" array_680[@]
    local array_681=("")
    eprintf__3501_v0 "${line_36586}" array_681[@]
    go_down__3556_v0 "$(( display_count_36584 - index_36585 ))"
    local array_682=("")
    eprintf__3501_v0 "\\x1b[G" array_682[@]
}

# Which items of a multi-select widget are ticked.
_checked_181=()
_count_182=0
_total_183=0
_limit_184=-1
# checked_init(total: Int, limit: Int)
checked_init__3565_v0() {
    local total_36503="${1}"
    local limit_36504="${2}"
    _checked_181=()
    local __range_start_36505=0
    local __range_end_36505="${total_36503}"
    local __dir_36505=$(( ${__range_start_36505} <= ${__range_end_36505} ? 1 : -1 ))
    for (( ____36505=${__range_start_36505}; ____36505 * ${__dir_36505} < ${__range_end_36505} * ${__dir_36505}; ____36505+=${__dir_36505} )); do
        local array_685=(0)
        _checked_181+=("${array_685[@]}")
done
    _count_182=0
    _total_183="${total_36503}"
    _limit_184="${limit_36504}"
}

# checked_is(index: Int)
checked_is__3566_v0() {
    local index_36547="${1}"
    ret_checked_is3566_v0="${_checked_181[${index_36547}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3568_v0() {
    local index_36579="${1}"
    if [ "${_checked_181[${index_36579}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_181["${index_36579}"]=0
        _count_182="$(( _count_182 - 1 ))"
        ret_checked_toggle3568_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_184 >= 0 )) && $(( _count_182 >= _limit_184 )) ))" != 0 ]; then
        ret_checked_toggle3568_v0=0
        return 0
    fi
    _checked_181["${index_36579}"]=1
    _count_182="$(( _count_182 + 1 ))"
    ret_checked_toggle3568_v0=1
    return 0
}

# checked_all()
checked_all__3569_v0() {
    if [ "$(( _limit_184 >= 0 ))" != 0 ]; then
        ret_checked_all3569_v0=0
        return 0
    fi
    local was_all_36591="$(( _count_182 == _total_183 ))"
    local __range_start_36592=0
    local __range_end_36592="${_total_183}"
    local __dir_36592=$(( ${__range_start_36592} <= ${__range_end_36592} ? 1 : -1 ))
    for (( i_36592=${__range_start_36592}; i_36592 * ${__dir_36592} < ${__range_end_36592} * ${__dir_36592}; i_36592+=${__dir_36592} )); do
        _checked_181["${i_36592}"]="$(( ! was_all_36591 ))"
done
    if [ "${was_all_36591}" != 0 ]; then
        _count_182=0
    else
        _count_182="${_total_183}"
    fi
    ret_checked_all3569_v0=1
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
__CHOOSER_CONTINUE_186=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_187=1
# The user confirmed the selection.
__CHOOSER_DONE_188=2
_total_189=0
_page_size_190=10
_display_count_191=0
_total_pages_192=1
_current_page_193=0
_selected_194=0
_cursor_195="> "
_multi_196=0
_limit_197=-1
_term_width_198=80
_has_header_199=0
_page_200=()
_page_count_201=0
_first_render_202=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_203=0
# render_single_page()
render_single_page__3640_v0() {
    local __length_687="${_cursor_195}"
    local cursor_len_36566="${#__length_687}"
    local max_option_width_36567="$(( $(( _term_width_198 - cursor_len_36566 )) - 1 ))"
    local __range_start_36568=0
    local __range_end_36568="${_page_count_201}"
    local __dir_36568=$(( ${__range_start_36568} <= ${__range_end_36568} ? 1 : -1 ))
    for (( i_36568=${__range_start_36568}; i_36568 * ${__dir_36568} < ${__range_end_36568} * ${__dir_36568}; i_36568+=${__dir_36568} )); do
        cutoff_text__3480_v0 "${_page_200[${i_36568}]?"Index out of bounds (at src/./file/../choose/engine.ab:45:45)"}" "${max_option_width_36567}"
        local ret_cutoff_text3480_v0__45_27="${ret_cutoff_text3480_v0}"
        local truncated_36569="${ret_cutoff_text3480_v0__45_27}"
        if [ "$(( i_36568 == _selected_194 ))" != 0 ]; then
            colored_secondary__3450_v0 "${_cursor_195}""${truncated_36569}""
"
            local ret_colored_secondary3450_v0__47_21="${ret_colored_secondary3450_v0}"
            local array_688=("")
            eprintf__3348_v0 "${ret_colored_secondary3450_v0__47_21}" array_688[@]
        else
            print_blank__3400_v0 "${cursor_len_36566}"
            local array_689=("")
            eprintf__3348_v0 "${truncated_36569}""
" array_689[@]
        fi
done
    local remaining_slots_36570="$(( _display_count_191 - _page_count_201 ))"
    if [ "$(( remaining_slots_36570 > 0 ))" != 0 ]; then
        local __range_start_36571=0
        local __range_end_36571="${remaining_slots_36570}"
        local __dir_36571=$(( ${__range_start_36571} <= ${__range_end_36571} ? 1 : -1 ))
        for (( ____36571=${__range_start_36571}; ____36571 * ${__dir_36571} < ${__range_end_36571} * ${__dir_36571}; ____36571+=${__dir_36571} )); do
            local array_690=("")
            eprintf__3348_v0 "\\x1b[K
" array_690[@]
done
    fi
}

# render_multi_page()
render_multi_page__3641_v0() {
    local __length_691="${_cursor_195}"
    local cursor_len_36542="${#__length_691}"
    local max_option_width_36543="$(( $(( _term_width_198 - cursor_len_36542 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3646_v0 
    local page_start_36544="${ret_chooser_page_start3646_v0}"
    local __range_start_36545=0
    local __range_end_36545="${_page_count_201}"
    local __dir_36545=$(( ${__range_start_36545} <= ${__range_end_36545} ? 1 : -1 ))
    for (( i_36545=${__range_start_36545}; i_36545 * ${__dir_36545} < ${__range_end_36545} * ${__dir_36545}; i_36545+=${__dir_36545} )); do
        local global_idx_36546="$(( page_start_36544 + i_36545 ))"
        checked_is__3566_v0 "${global_idx_36546}"
        local ret_checked_is3566_v0__67_28="${ret_checked_is3566_v0}"
        local check_mark_36548
        check_mark_36548="$(if [ "${ret_checked_is3566_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__3480_v0 "${_page_200[${i_36545}]?"Index out of bounds (at src/./file/../choose/engine.ab:68:45)"}" "${max_option_width_36543}"
        local ret_cutoff_text3480_v0__68_27="${ret_cutoff_text3480_v0}"
        local truncated_36549="${ret_cutoff_text3480_v0__68_27}"
        checked_is__3566_v0 "${global_idx_36546}"
        local ret_checked_is3566_v0__71_13="${ret_checked_is3566_v0}"
        if [ "$(( i_36545 == _selected_194 ))" != 0 ]; then
            colored_secondary__3450_v0 "${_cursor_195}""${check_mark_36548}""${truncated_36549}""
"
            local ret_colored_secondary3450_v0__70_37="${ret_colored_secondary3450_v0}"
            local array_692=("")
            eprintf__3348_v0 "${ret_colored_secondary3450_v0__70_37}" array_692[@]
        elif [ "${ret_checked_is3566_v0__71_13}" != 0 ]; then
            print_blank__3400_v0 "${cursor_len_36542}"
            colored_secondary__3450_v0 "${check_mark_36548}""${truncated_36549}""
"
            local ret_colored_secondary3450_v0__73_25="${ret_colored_secondary3450_v0}"
            local array_693=("")
            eprintf__3348_v0 "${ret_colored_secondary3450_v0__73_25}" array_693[@]
        else
            print_blank__3400_v0 "${cursor_len_36542}"
            local array_694=("")
            eprintf__3348_v0 "${check_mark_36548}""${truncated_36549}""
" array_694[@]
        fi
done
    local remaining_slots_36564="$(( _display_count_191 - _page_count_201 ))"
    if [ "$(( remaining_slots_36564 > 0 ))" != 0 ]; then
        local __range_start_36565=0
        local __range_end_36565="${remaining_slots_36564}"
        local __dir_36565=$(( ${__range_start_36565} <= ${__range_end_36565} ? 1 : -1 ))
        for (( ____36565=${__range_start_36565}; ____36565 * ${__dir_36565} < ${__range_end_36565} * ${__dir_36565}; ____36565+=${__dir_36565} )); do
            local array_695=("")
            eprintf__3348_v0 "\\x1b[K
" array_695[@]
done
    fi
}

# render_page()
render_page__3642_v0() {
    if [ "${_multi_196}" != 0 ]; then
        render_multi_page__3641_v0 
    else
        render_single_page__3640_v0 
    fi
}

# render_page_indicator()
render_page_indicator__3643_v0() {
    if [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
        local array_696=("")
        eprintf__3348_v0 "\\x1b[G\\x1b[K" array_696[@]
        eprintf_colored__3349_v0 "Page $(( _current_page_193 + 1 ))/${_total_pages_192}" 90
        local array_697=("")
        eprintf__3348_v0 "\\x1b[G" array_697[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__3644_v0() {
    if [ "$(( ! _multi_196 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
            local array_698=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__3507_v0 array_698[@] 36 "${_term_width_198}"
        else
            local array_699=("↑↓" "select" "enter" "confirm")
            render_tooltip__3507_v0 array_699[@] 25 "${_term_width_198}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_192 > 1 )) && $(( _limit_197 < 0 )) ))" != 0 ]; then
            local array_700=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__3507_v0 array_700[@] 55 "${_term_width_198}"
        elif [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
            local array_701=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__3507_v0 array_701[@] 47 "${_term_width_198}"
        elif [ "$(( _limit_197 < 0 ))" != 0 ]; then
            local array_702=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__3507_v0 array_702[@] 44 "${_term_width_198}"
        else
            local array_703=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__3507_v0 array_703[@] 36 "${_term_width_198}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__3645_v0() {
    local total_36446="${1}"
    local page_size_36447="${2}"
    local header_36448="${3}"
    local cursor_36449="${4}"
    local multi_36450="${5}"
    local limit_36451="${6}"
    _total_189="${total_36446}"
    _cursor_195="${cursor_36449}"
    _multi_196="${multi_36450}"
    _limit_197="${limit_36451}"
    _current_page_193=0
    _selected_194=0
    _first_render_202=1
    _up_paged_203=0
    _has_header_199="$([ "_${header_36448}" == "_" ]; echo $?)"
    stty_lock__3388_v0 
    hide_cursor__3405_v0 
    term_width__3395_v0 
    _term_width_198="${ret_term_width3395_v0}"
    term_height__3396_v0 
    local term_height_36461="${ret_term_height3396_v0}"
    local max_page_size_36462
    max_page_size_36462="$(( term_height_36461 - $(if [ "${_has_header_199}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_190="${page_size_36447}"
    if [ "$(( _page_size_190 > max_page_size_36462 ))" != 0 ]; then
        _page_size_190="${max_page_size_36462}"
    fi
    if [ "${_has_header_199}" != 0 ]; then
        cutoff_text__3480_v0 "${header_36448}" "${_term_width_198}"
        local ret_cutoff_text3480_v0__153_17="${ret_cutoff_text3480_v0}"
        local array_704=("")
        eprintf__3348_v0 "${ret_cutoff_text3480_v0__153_17}""
" array_704[@]
    fi
    math_floor__633_v0 "$(( $(( $(( total_36446 + _page_size_190 )) - 1 )) / _page_size_190 ))"
    _total_pages_192="${ret_math_floor633_v0}"
    _display_count_191="${_page_size_190}"
    if [ "$(( total_36446 < _page_size_190 ))" != 0 ]; then
        _display_count_191="${total_36446}"
    fi
    if [ "${multi_36450}" != 0 ]; then
        checked_init__3565_v0 "${total_36446}" "${limit_36451}"
    fi
    new_line__3401_v0 "${_display_count_191}"
    local array_705=("")
    eprintf__3348_v0 "\\x1b[G" array_705[@]
    if [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
        eprintf_colored__3349_v0 "Page $(( _current_page_193 + 1 ))/${_total_pages_192}" 90
    fi
    new_line__3401_v0 1
    render_tooltip_line__3644_v0 
    go_up__3402_v0 "$(( _display_count_191 + 1 ))"
    local array_706=("")
    eprintf__3348_v0 "\\x1b[G" array_706[@]
}

# chooser_page_start()
chooser_page_start__3646_v0() {
    ret_chooser_page_start3646_v0="$(( _current_page_193 * _page_size_190 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__3647_v0() {
    chooser_page_start__3646_v0 
    local start_36533="${ret_chooser_page_start3646_v0}"
    local end_36534="$(( start_36533 + _page_size_190 ))"
    if [ "$(( end_36534 > _total_189 ))" != 0 ]; then
        end_36534="${_total_189}"
    fi
    ret_chooser_page_count3647_v0="$(( end_36534 - start_36533 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3648_v0() {
    local page_36541=("${!1}")
    _page_200=("${page_36541[@]}")
    local __length_707=("${page_36541[@]}")
    _page_count_201="${#__length_707[@]}"
    if [ "${_first_render_202}" != 0 ]; then
        _first_render_202=0
        render_page__3642_v0 
    else
        if [ "${_up_paged_203}" != 0 ]; then
            _selected_194="$(( _page_count_201 - 1 ))"
            _up_paged_203=0
        fi
        go_up__3402_v0 1
        remove_line__3398_v0 "$(( _display_count_191 - 1 ))"
        remove_current_line__3399_v0 
        local array_708=("")
        eprintf__3348_v0 "\\x1b[G" array_708[@]
        render_page__3642_v0 
        render_page_indicator__3643_v0 
    fi
}

# option_width()
option_width__3649_v0() {
    local check_width_36581
    check_width_36581="$(if [ "${_multi_196}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_709="${_cursor_195}"
    ret_option_width3649_v0="$(( $(( _term_width_198 - ${#__length_709} )) - check_width_36581 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3650_v0() {
    local index_36594="${1}"
    local __length_710="${_cursor_195}"
    rpad__28_v0 "" " " "${#__length_710}"
    local blank_36595="${ret_rpad28_v0}"
    option_width__3649_v0 
    local ret_option_width3649_v0__224_49="${ret_option_width3649_v0}"
    cutoff_text__3480_v0 "${_page_200[${index_36594}]?"Index out of bounds (at src/./file/../choose/engine.ab:224:41)"}" "${ret_option_width3649_v0__224_49}"
    local truncated_36596="${ret_cutoff_text3480_v0}"
    if [ "$(( ! _multi_196 ))" != 0 ]; then
        ret_unselected_line3650_v0="${blank_36595}""${truncated_36596}"
        return 0
    fi
    chooser_page_start__3646_v0 
    local ret_chooser_page_start3646_v0__228_19="${ret_chooser_page_start3646_v0}"
    checked_is__3566_v0 "$(( ret_chooser_page_start3646_v0__228_19 + index_36594 ))"
    local ret_checked_is3566_v0__228_8="${ret_checked_is3566_v0}"
    if [ "${ret_checked_is3566_v0__228_8}" != 0 ]; then
        colored_secondary__3450_v0 "✓ ""${truncated_36596}"
        local ret_colored_secondary3450_v0__229_24="${ret_colored_secondary3450_v0}"
        ret_unselected_line3650_v0="${blank_36595}""${ret_colored_secondary3450_v0__229_24}"
        return 0
    fi
    ret_unselected_line3650_v0="${blank_36595}""• ""${truncated_36596}"
    return 0
}

# selected_line(index: Int)
selected_line__3651_v0() {
    local index_36580="${1}"
    option_width__3649_v0 
    local ret_option_width3649_v0__236_49="${ret_option_width3649_v0}"
    cutoff_text__3480_v0 "${_page_200[${index_36580}]?"Index out of bounds (at src/./file/../choose/engine.ab:236:41)"}" "${ret_option_width3649_v0__236_49}"
    local truncated_36582="${ret_cutoff_text3480_v0}"
    if [ "$(( ! _multi_196 ))" != 0 ]; then
        colored_secondary__3450_v0 "${_cursor_195}""${truncated_36582}"
        ret_selected_line3651_v0="${ret_colored_secondary3450_v0}"
        return 0
    fi
    chooser_page_start__3646_v0 
    local ret_chooser_page_start3646_v0__240_29="${ret_chooser_page_start3646_v0}"
    checked_is__3566_v0 "$(( ret_chooser_page_start3646_v0__240_29 + index_36580 ))"
    local ret_checked_is3566_v0__240_18="${ret_checked_is3566_v0}"
    local mark_36583
    mark_36583="$(if [ "${ret_checked_is3566_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__3450_v0 "${_cursor_195}""${mark_36583}""${truncated_36582}"
    ret_selected_line3651_v0="${ret_colored_secondary3450_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3652_v0() {
    local prev_selected_36593="${1}"
    unselected_line__3650_v0 "${prev_selected_36593}"
    local ret_unselected_line3650_v0__247_47="${ret_unselected_line3650_v0}"
    redraw_row__3563_v0 "${_display_count_191}" "${prev_selected_36593}" "${ret_unselected_line3650_v0__247_47}"
    selected_line__3651_v0 "${_selected_194}"
    local ret_selected_line3651_v0__248_43="${ret_selected_line3651_v0}"
    redraw_row__3563_v0 "${_display_count_191}" "${_selected_194}" "${ret_selected_line3651_v0__248_43}"
}

# redraw_current_line()
redraw_current_line__3653_v0() {
    selected_line__3651_v0 "${_selected_194}"
    local ret_selected_line3651_v0__253_43="${ret_selected_line3651_v0}"
    redraw_row__3563_v0 "${_display_count_191}" "${_selected_194}" "${ret_selected_line3651_v0__253_43}"
}

# chooser_step()
chooser_step__3654_v0() {
    get_key__3346_v0 
    local key_36575="${ret_get_key3346_v0}"
    local prev_selected_36576="${_selected_194}"
    local prev_page_36577="${_current_page_193}"
    chooser_page_start__3646_v0 
    local page_start_36578="${ret_chooser_page_start3646_v0}"
    _up_paged_203=0
    if [ "$(( $([ "_${key_36575}" != "_UP" ]; echo $?) || $([ "_${key_36575}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_194 == 0 )) && $(( _total_pages_192 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_193 > 0 ))" != 0 ]; then
                _current_page_193="$(( _current_page_193 - 1 ))"
            else
                _current_page_193="$(( _total_pages_192 - 1 ))"
            fi
            _up_paged_203=1
        elif [ "$(( _selected_194 == 0 ))" != 0 ]; then
            _selected_194="$(( _page_count_201 - 1 ))"
        else
            _selected_194="$(( _selected_194 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_36575}" != "_DOWN" ]; echo $?) || $([ "_${key_36575}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_194 == $(( _page_count_201 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_193 < $(( _total_pages_192 - 1 )) ))" != 0 ]; then
                _current_page_193="$(( _current_page_193 + 1 ))"
            else
                _current_page_193=0
            fi
            _selected_194=0
        else
            _selected_194="$(( _selected_194 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_36575}" != "_LEFT" ]; echo $?) || $([ "_${key_36575}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_193 > 0 ))" != 0 ]; then
            _current_page_193="$(( _current_page_193 - 1 ))"
        fi
        _selected_194=0
    elif [ "$(( $([ "_${key_36575}" != "_RIGHT" ]; echo $?) || $([ "_${key_36575}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_193 < $(( _total_pages_192 - 1 )) ))" != 0 ]; then
            _current_page_193="$(( _current_page_193 + 1 ))"
            _selected_194=0
        else
            _selected_194="$(( _page_count_201 - 1 ))"
        fi
    elif [ "$(( _multi_196 && $(( $(( $([ "_${key_36575}" != "_x" ]; echo $?) || $([ "_${key_36575}" != "_X" ]; echo $?) )) || $([ "_${key_36575}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3568_v0 "$(( page_start_36578 + _selected_194 ))"
        local ret_checked_toggle3568_v0__310_16="${ret_checked_toggle3568_v0}"
        if [ "${ret_checked_toggle3568_v0__310_16}" != 0 ]; then
            redraw_current_line__3653_v0 
        fi
        ret_chooser_step3654_v0="${__CHOOSER_CONTINUE_186}"
        return 0
    elif [ "$(( $(( _multi_196 && $(( $(( $([ "_${key_36575}" != "_a" ]; echo $?) || $([ "_${key_36575}" != "_A" ]; echo $?) )) || $([ "_${key_36575}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_197 < 0 )) ))" != 0 ]; then
        checked_all__3569_v0 
        local ret_checked_all3569_v0__316_16="${ret_checked_all3569_v0}"
        if [ "${ret_checked_all3569_v0__316_16}" != 0 ]; then
            go_up__3402_v0 "${_display_count_191}"
            local array_711=("")
            eprintf__3348_v0 "\\x1b[G" array_711[@]
            render_page__3642_v0 
        fi
        ret_chooser_step3654_v0="${__CHOOSER_CONTINUE_186}"
        return 0
    elif [ "$(( $([ "_${key_36575}" != "_INPUT" ]; echo $?) || $([ "_${key_36575}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step3654_v0="${__CHOOSER_DONE_188}"
        return 0
    else
        ret_chooser_step3654_v0="${__CHOOSER_CONTINUE_186}"
        return 0
    fi
    if [ "$(( prev_page_36577 != _current_page_193 ))" != 0 ]; then
        ret_chooser_step3654_v0="${__CHOOSER_NEED_PAGE_187}"
        return 0
    fi
    if [ "$(( prev_selected_36576 != _selected_194 ))" != 0 ]; then
        redraw_selection__3652_v0 "${prev_selected_36576}"
    fi
    ret_chooser_step3654_v0="${__CHOOSER_CONTINUE_186}"
    return 0
}

# chooser_selected()
chooser_selected__3655_v0() {
    chooser_page_start__3646_v0 
    local ret_chooser_page_start3646_v0__340_12="${ret_chooser_page_start3646_v0}"
    ret_chooser_selected3655_v0="$(( ret_chooser_page_start3646_v0__340_12 + _selected_194 ))"
    return 0
}

# chooser_end()
chooser_end__3657_v0() {
    local total_lines_36599="$(( _display_count_191 + 2 ))"
    if [ "${_has_header_199}" != 0 ]; then
        total_lines_36599="$(( total_lines_36599 + 1 ))"
    fi
    go_down__3403_v0 1
    remove_line__3398_v0 "$(( total_lines_36599 - 1 ))"
    remove_current_line__3399_v0 
    stty_unlock__3389_v0 
    show_cursor__3406_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3666_v0() {
    local name_36537="${1}"
    local file_type_36538="${2}"
    local target_36539="${3}"
    if [ "$([ "_${file_type_36538}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__3105_v0 "/"
        local ret_colored_primary3105_v0__10_23="${ret_colored_primary3105_v0}"
        ret_format_entry_display3666_v0="${name_36537}""${ret_colored_primary3105_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_36538}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__3107_v0 " > "
        local ret_colored_accent3107_v0__13_23="${ret_colored_accent3107_v0}"
        colored_primary__3105_v0 "${target_36539}"
        local ret_colored_primary3105_v0__13_47="${ret_colored_primary3105_v0}"
        ret_format_entry_display3666_v0="${name_36537}""${ret_colored_accent3107_v0__13_23}""${ret_colored_primary3105_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3666_v0="${name_36537}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3667_v0() {
    local start_path_36416="${1}"
    local cursor_36417="${2}"
    local show_hidden_36418="${3}"
    local page_size_36419="${4}"
    stty_lock__3044_v0 
    # Initialize current path
    local current_path_36422="${start_path_36416}"
    if [ "$([ "_${current_path_36422}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__3086_v0 
        current_path_36422="${ret_get_cwd3086_v0}"
    fi
    normalize_path__3087_v0 "${current_path_36422}"
    current_path_36422="${ret_normalize_path3087_v0}"
    while :
    do
        colored_primary__3105_v0 "Loading files..."
        local ret_colored_primary3105_v0__41_17="${ret_colored_primary3105_v0}"
        local array_712=("")
        eprintf__3004_v0 "${ret_colored_primary3105_v0__41_17}" array_712[@]
        get_directory_entries__3085_v0 "${current_path_36422}"
        local listed_36433=("${ret_get_directory_entries3085_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_36434=()
        local types_36435=()
        local targets_36436=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_36422}" == "_/" ]; echo $?)" != 0 ]; then
            names_36434+=("..")
            types_36435+=("d")
            targets_36436+=("")
        fi
        local __length_719=("${listed_36433[@]}")
        local listed_count_36437="$(( ${#__length_719[@]} / __ENTRY_STRIDE_149 ))"
        local __range_start_36438=0
        local __range_end_36438="${listed_count_36437}"
        local __dir_36438=$(( ${__range_start_36438} <= ${__range_end_36438} ? 1 : -1 ))
        for (( i_36438=${__range_start_36438}; i_36438 * ${__dir_36438} < ${__range_end_36438} * ${__dir_36438}; i_36438+=${__dir_36438} )); do
            local at_36439="$(( i_36438 * __ENTRY_STRIDE_149 ))"
            local name_36440="${listed_36433[${at_36439}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_36440}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_36418 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_720=("${name_36440}")
            names_36434+=("${array_720[@]}")
            local array_721=("${listed_36433[$(( at_36439 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_36435+=("${array_721[@]}")
            local array_722=("${listed_36433[$(( at_36439 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_36436+=("${array_722[@]}")
done
        local __length_723=("${names_36434[@]}")
        local total_36441="${#__length_723[@]}"
        if [ "$(( total_36441 == 0 ))" != 0 ]; then
            eprintf_colored__3005_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__3045_v0 
            ret_xyl_file3667_v0=""
            return 0
        fi
        colored_primary__3105_v0 "${current_path_36422}"
        local header_36443="${ret_colored_primary3105_v0}"
        remove_current_line__3055_v0 
        chooser_begin__3645_v0 "${total_36441}" "${page_size_36419}" "${header_36443}" "${cursor_36417}" 0 -1
        local need_page_36530=1
        while :
        do
            if [ "${need_page_36530}" != 0 ]; then
                local page_36531=()
                chooser_page_start__3646_v0 
                local start_36532="${ret_chooser_page_start3646_v0}"
                chooser_page_count__3647_v0 
                local count_36535="${ret_chooser_page_count3647_v0}"
                local __range_start_36536="${start_36532}"
                local __range_end_36536="$(( start_36532 + count_36535 ))"
                local __dir_36536=$(( ${__range_start_36536} <= ${__range_end_36536} ? 1 : -1 ))
                for (( i_36536=${__range_start_36536}; i_36536 * ${__dir_36536} < ${__range_end_36536} * ${__dir_36536}; i_36536+=${__dir_36536} )); do
                    format_entry_display__3666_v0 "${names_36434[${i_36536}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_36435[${i_36536}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_36436[${i_36536}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3666_v0__90_30="${ret_format_entry_display3666_v0}"
                    local array_725=("${ret_format_entry_display3666_v0__90_30}")
                    page_36531+=("${array_725[@]}")
done
                chooser_set_page__3648_v0 page_36531[@]
            fi
            chooser_step__3654_v0 
            local step_36597="${ret_chooser_step3654_v0}"
            if [ "$(( step_36597 == __CHOOSER_DONE_188 ))" != 0 ]; then
                break
            fi
            need_page_36530="$(( step_36597 == __CHOOSER_NEED_PAGE_187 ))"
        done
        chooser_selected__3655_v0 
        local selected_idx_36598="${ret_chooser_selected3655_v0}"
        chooser_end__3657_v0 
        local name_36602="${names_36434[${selected_idx_36598}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_36603="${types_36435[${selected_idx_36598}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_36602}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__3089_v0 "${current_path_36422}"
            current_path_36422="${ret_get_parent_dir3089_v0}"
        elif [ "$([ "_${file_type_36603}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__3088_v0 "${current_path_36422}" "${name_36602}"
            current_path_36422="${ret_path_join3088_v0}"
            normalize_path__3087_v0 "${current_path_36422}"
            current_path_36422="${ret_normalize_path3087_v0}"
        elif [ "$([ "_${file_type_36603}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_36608="${targets_36436[${selected_idx_36598}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_36609="${target_36608}"
            starts_with__22_v0 "${target_36608}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__3088_v0 "${current_path_36422}" "${target_36608}"
                target_path_36609="${ret_path_join3088_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_36609}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_36422="${target_path_36609}"
                normalize_path__3087_v0 "${current_path_36422}"
                current_path_36422="${ret_normalize_path3087_v0}"
            else
                stty_unlock__3045_v0 
                path_join__3088_v0 "${current_path_36422}" "${name_36602}"
                ret_xyl_file3667_v0="${ret_path_join3088_v0}"
                return 0
            fi
        else
            stty_unlock__3045_v0 
            path_join__3088_v0 "${current_path_36422}" "${name_36602}"
            ret_xyl_file3667_v0="${ret_path_join3088_v0}"
            return 0
        fi
    done
    stty_unlock__3045_v0 
    ret_xyl_file3667_v0=""
    return 0
}

# print_file_help()
print_file_help__3767_v0() {
    local usage_36334=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__3063_v0 usage_36334[@]
    printf '%s\n' ""
    colored_primary__3105_v0 "file"
    local ret_colored_primary3105_v0__8_20="${ret_colored_primary3105_v0}"
    local title_36371=("${ret_colored_primary3105_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__3063_v0 title_36371[@]
    printf '%s\n' ""
    colored_secondary__3106_v0 "Arguments:"
    local ret_colored_secondary3106_v0__11_12="${ret_colored_secondary3106_v0}"
    local array_728=()
    printf__128_v0 "${ret_colored_secondary3106_v0__11_12}""
" array_728[@]
    local arg_names_36373=("[<path>]")
    local arg_texts_36374=("Starting directory path")
    local arg_notes_36375=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__3238_v0 arg_names_36373[@] arg_texts_36374[@] arg_notes_36375[@] 20
    printf '%s\n' ""
    colored_secondary__3106_v0 "Flags:"
    local ret_colored_secondary3106_v0__18_12="${ret_colored_secondary3106_v0}"
    local array_732=()
    printf__128_v0 "${ret_colored_secondary3106_v0__18_12}""
" array_732[@]
    local names_36408=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_36409=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_36410=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__3238_v0 names_36408[@] texts_36409[@] notes_36410[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3825_v0() {
    local parameters_36328=("${!1}")
    local cursor_36329="> "
    local start_path_36330=""
    local show_hidden_36331=0
    local page_size_36332=10
    local __length_739=("${parameters_36328[@]}")
    local slice_upper_738="${#__length_739[@]}"
    local slice_offset_740=2
    local slice_offset_740=$((${slice_offset_740} > 0 ? ${slice_offset_740} : 0))
    local slice_length_741="$(( slice_upper_738 - slice_offset_740 ))"
    local slice_length_741=$((${slice_length_741} > 0 ? ${slice_length_741} : 0))
    for param_36333 in "${parameters_36328[@]:${slice_offset_740}:${slice_length_741}}"; do
        starts_with__22_v0 "${param_36333}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_36333}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_36333}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_36333}" != "_-h" ]; echo $?) || $([ "_${param_36333}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3767_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_742="--cursor="
            slice__24_v0 "${param_36333}" "${#__length_742}" 0
            cursor_36329="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_743="--path="
            slice__24_v0 "${param_36333}" "${#__length_743}" 0
            start_path_36330="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_36333}" != "_-a" ]; echo $?) || $([ "_${param_36333}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_36331=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_744="--page-size="
            slice__24_v0 "${param_36333}" "${#__length_744}" 0
            local value_36411="${ret_slice24_v0}"
            parse_int__13_v0 "${value_36411}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__3005_v0 "ERROR: Invalid page-size value: ""${value_36411}""
" 31
                exit 1
            fi
            page_size_36332="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_36330="${param_36333}"
        fi
    done
    xyl_file__3667_v0 "${start_path_36330}" "${cursor_36329}" "${show_hidden_36331}" "${page_size_36332}"
    ret_execute_file3825_v0="${ret_xyl_file3667_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_209="0.1.0"
__AMBER_VERSION_210="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__3827_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__162_v0 "Error: " 91
        local array_745=("")
        eprintf__161_v0 "bc is not installed. Please install bc to use xylitol.
" array_745[@]
        local array_746=("")
        eprintf__161_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_746[@]
        local array_747=("")
        eprintf__161_v0 "  For Fedora: sudo dnf install bc
" array_747[@]
        local array_748=("")
        eprintf__161_v0 "  For Arch Linux: sudo pacman -S bc
" array_748[@]
        ret_check_prerequirements3827_v0=0
        return 0
    fi
    ret_check_prerequirements3827_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__3828_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo icanon < /dev/tty' EXIT
    __status=$?
}

typeset -r args_211=("$0" "$@")
trap_cleanup__3828_v0 
check_prerequirements__3827_v0 
ret_check_prerequirements3827_v0__33_12="${ret_check_prerequirements3827_v0}"
if [ "$(( ! ret_check_prerequirements3827_v0__33_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_750=("${args_211[@]}")
if [ "$(( ${#__length_750[@]} < 2 ))" != 0 ]; then
    print_help__552_v0 
    exit 0
fi
command_1573="${args_211[1]?"Index out of bounds (at src/main.ab:42:26)"}"
if [ "$(( $(( $([ "_${command_1573}" != "_help" ]; echo $?) || $([ "_${command_1573}" != "_--help" ]; echo $?) )) || $([ "_${command_1573}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__552_v0 
elif [ "$([ "_${command_1573}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1095_v0 args_211[@]
    ret_execute_input1095_v0__49_18="${ret_execute_input1095_v0}"
    printf '%s\n' "${ret_execute_input1095_v0__49_18}"
elif [ "$([ "_${command_1573}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1761_v0 args_211[@]
    ret_execute_choose1761_v0__52_18="${ret_execute_choose1761_v0}"
    printf '%s\n' "${ret_execute_choose1761_v0__52_18}"
elif [ "$([ "_${command_1573}" != "_filter" ]; echo $?)" != 0 ]; then
    execute_filter__2309_v0 args_211[@]
    ret_execute_filter2309_v0__55_18="${ret_execute_filter2309_v0}"
    printf '%s\n' "${ret_execute_filter2309_v0__55_18}"
elif [ "$([ "_${command_1573}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2886_v0 args_211[@]
    result_27009="${ret_execute_confirm2886_v0}"
    if [ "$([ "_${result_27009}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1573}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3825_v0 args_211[@]
    ret_execute_file3825_v0__65_18="${ret_execute_file3825_v0}"
    printf '%s\n' "${ret_execute_file3825_v0__65_18}"
elif [ "$(( $(( $([ "_${command_1573}" != "_version" ]; echo $?) || $([ "_${command_1573}" != "_--version" ]; echo $?) )) || $([ "_${command_1573}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__262_v0 "xylitol.sh"
    ret_colored_primary262_v0__68_20="${ret_colored_primary262_v0}"
    array_751=()
    printf__128_v0 "${ret_colored_primary262_v0__68_20}" array_751[@]
    array_752=()
    printf__128_v0 " version: " array_752[@]
    colored_accent__264_v0 "${__VERSION_209}"
    ret_colored_accent264_v0__70_20="${ret_colored_accent264_v0}"
    array_753=()
    printf__128_v0 "${ret_colored_accent264_v0__70_20}" array_753[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_210}" 90
else
    print_help__552_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1573}""'" 91
fi
