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
    local text_1497="${1}"
    local delimiter_1498="${2}"
    local result_1499=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1498}" read -rd '' -A result_1499 < <(printf %s "$text_1497")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1498}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1499+=("$REPLY"); done < <(echo "$text_1497")
            __status=$?
        else
            IFS="${delimiter_1498}" read -rd '' -a result_1499 < <(printf %s "$text_1497")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1498}" read -rd '' -a result_1499 < <(printf %s "$text_1497")
        __status=$?
    fi
    ret_split4_v0=("${result_1499[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_18123=("${!1}")
    local delimiter_18124="${2}"
    local command_1
    command_1="$(IFS="${delimiter_18124}" ; printf "%s
" "${list_18123[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1501="${1}"
    [ -n "${text_1501}" ] && [ "${text_1501}" -eq "${text_1501}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1501}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_3194="${1}"
    local prefix_3195="${2}"
    [[ "${text_3194}" == "${prefix_3195}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1587="${1}"
    local index_1588="${2}"
    local length_1589="${3}"
    local result_1590=""
    if [ "$(( length_1589 == 0 ))" != 0 ]; then
        local __length_2="${text_1587}"
        length_1589="$(( ${#__length_2} - index_1588 ))"
    fi
    if [ "$(( length_1589 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1590}"
        return 0
    fi
    result_1590="${text_1587: ${index_1588}: ${length_1589}}"
    __status=$?
    ret_slice24_v0="${result_1590}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_29666="${1}"
    local pad_29667="${2}"
    local length_29668="${3}"
    local __length_3="${text_29666}"
    if [ "$(( length_29668 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_29666}"
        return 0
    fi
    local __length_4="${text_29666}"
    local pad_len_29669="$(( length_29668 - ${#__length_4} ))"
    local padding_29670=""
    printf -v padding_29670 "%${pad_len_29669}s" ""
    __status=$?
    padding_29670="${padding_29670// /${pad_29667}}"
    __status=$?
    ret_lpad27_v0="${padding_29670}""${text_29666}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1567="${1}"
    local pad_1568="${2}"
    local length_1569="${3}"
    local __length_5="${text_1567}"
    if [ "$(( length_1569 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1567}"
        return 0
    fi
    local __length_6="${text_1567}"
    local pad_len_1570="$(( length_1569 - ${#__length_6} ))"
    local padding_1571=""
    printf -v padding_1571 "%${pad_len_1570}s" ""
    __status=$?
    padding_1571="${padding_1571// /${pad_1568}}"
    __status=$?
    ret_rpad28_v0="${text_1567}""${padding_1571}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_29660="${1}"
    local pad_29661="${2}"
    local length_29662="${3}"
    local __length_7="${text_29660}"
    local text_length_29663="${#__length_7}"
    if [ "$(( length_29662 <= text_length_29663 ))" != 0 ]; then
        ret_cpad29_v0="${text_29660}"
        return 0
    fi
    local total_padding_29664="$(( length_29662 - text_length_29663 ))"
    local left_padding_length_29665="$(( text_length_29663 + $(( total_padding_29664 / 2 )) ))"
    lpad__27_v0 "${text_29660}" "${pad_29661}" "${left_padding_length_29665}"
    local left_padded_29671="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_29671}" "${pad_29661}" "${length_29662}"
    local center_padded_29672="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_29672}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_40325="${1}"
    [ -d "${path_40325}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1527="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1527}")"
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
" "${(P)name_1527}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1527}")"
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
    local format_1524="${1}"
    local args_1525=("${!2}")
    args_1525=("${format_1524}" "${args_1525[@]}")
    __status=$?
    printf "${args_1525[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1537="${1}"
    local args_1538=("${!2}")
    args_1538=("${format_1537}" "${args_1538[@]}")
    __status=$?
    printf "${args_1538[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1534="${1}"
    local color_1535="${2}"
    local color_code_1536=0
        color_code_1536="${color_1535}"
    local array_11=("${message_1534}")
    printf__128_v1 "\\x1b[${color_code_1536}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_40328="${1}"
    local color_40329="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_40328}")
    printf__128_v1 "\\x1b[${color_40329}m%s\\x1b[0m" array_12[@]
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
        local disabled_1520
        disabled_1520="$([ "_${command_14}" != "_No" ]; echo $?)"
        local command_15
        command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1521
        found_1521="$(( $(( ! disabled_1520 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1521}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available184_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__185_v0() {
    local text_1519="${1}"
    perl_available__184_v0 
    local ret_perl_available184_v0__19_12="${ret_perl_available184_v0}"
    if [ "$(( ! ret_perl_available184_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return 1
    fi
    local command_16
    command_16="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1519}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_str_1522="${command_16}"
    parse_int__13_v0 "${width_str_1522}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_1523="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width185_v0="${width_1523}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__190_v0() {
    local text_1509="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_17
    command_17="$([[ "${text_1509}" == *$'\x1b'* || "${text_1509}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1510="${command_17}"
    ret_has_ansi_escape190_v0="$([ "_${has_escape_1510}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__192_v0() {
    local text_1515="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1515}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi192_v0="${command_18}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__193_v0() {
    local text_1517="${1}"
    local command_19
    command_19="$(printf "%s" "${text_1517}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1518="${command_19}"
    ret_is_all_ascii193_v0="$([ "_${result_1518}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__194_v0() {
    local text_1512="${1}"
    local command_20
    command_20="$(LC_ALL=C; __t="${text_1512}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_1513="${command_20}"
    parse_int__13_v0 "${measured_1513}"
    __status=$?
    ret_plain_len194_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__195_v0() {
    local text_1511="${1}"
    plain_len__194_v0 "${text_1511}"
    local plain_1514="${ret_plain_len194_v0}"
    if [ "$(( plain_1514 >= 0 ))" != 0 ]; then
        ret_get_visible_len195_v0="${plain_1514}"
        return 0
    fi
    strip_ansi__192_v0 "${text_1511}"
    local stripped_1516="${ret_strip_ansi192_v0}"
    is_all_ascii__193_v0 "${stripped_1516}"
    local ret_is_all_ascii193_v0__46_12="${ret_is_all_ascii193_v0}"
    if [ "$(( ! ret_is_all_ascii193_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__185_v0 "${stripped_1516}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_21="${stripped_1516}"
            ret_get_visible_len195_v0="${#__length_21}"
            return 0
        fi
        ret_get_visible_len195_v0="${ret_perl_get_cjk_width185_v0}"
        return 0
    fi
    local __length_22="${stripped_1516}"
    ret_get_visible_len195_v0="${#__length_22}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_4=0
_term_size_5=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__204_v0() {
    local size_1496="${1}"
    if [ "$([ "_${size_1496}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size204_v0=0
        return 0
    fi
    split__4_v0 "${size_1496}" " "
    local parts_1500=("${ret_split4_v0[@]}")
    local __length_24=("${parts_1500[@]}")
    if [ "$(( ${#__length_24[@]} != 2 ))" != 0 ]; then
        ret_store_term_size204_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1500[1]?"Index out of bounds (at src/utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1500[0]?"Index out of bounds (at src/utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_5=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size204_v0=1
    return 0
}

# query_term_size()
query_term_size__205_v0() {
    local command_26
    command_26="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1503="${command_26}"
    store_term_size__204_v0 "${size_1503}"
    ret_query_term_size205_v0="${ret_store_term_size204_v0}"
    return 0
}

# stty_term_size()
stty_term_size__206_v0() {
    local command_27
    command_27="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1495="${command_27}"
    store_term_size__204_v0 "${size_1495}"
    ret_stty_term_size206_v0="${ret_store_term_size204_v0}"
    return 0
}

# get_term_size()
get_term_size__207_v0() {
    stty_term_size__206_v0 
    local detected_1502="${ret_stty_term_size206_v0}"
    if [ "$(( ! detected_1502 ))" != 0 ]; then
        query_term_size__205_v0 
        detected_1502="${ret_query_term_size205_v0}"
    fi
    _got_term_size_4=1
}

# term_width()
term_width__209_v0() {
    if [ "$(( ! _got_term_size_4 ))" != 0 ]; then
        get_term_size__207_v0 
    fi
    ret_term_width209_v0="${_term_size_5[0]?"Index out of bounds (at src/utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__221_v0() {
    local pieces_1494=("${!1}")
    term_width__209_v0 
    local width_1504="${ret_term_width209_v0}"
    local line_1505=""
    local line_len_1506=0
    for piece_1507 in "${pieces_1494[@]}"; do
        local __length_30="${piece_1507}"
        local piece_len_1508="${#__length_30}"
        has_ansi_escape__190_v0 "${piece_1507}"
        local ret_has_ansi_escape190_v0__186_12="${ret_has_ansi_escape190_v0}"
        if [ "${ret_has_ansi_escape190_v0__186_12}" != 0 ]; then
            get_visible_len__195_v0 "${piece_1507}"
            piece_len_1508="${ret_get_visible_len195_v0}"
        fi
        if [ "$([ "_${line_1505}" != "_" ]; echo $?)" != 0 ]; then
            line_1505="${piece_1507}"
            line_len_1506="${piece_len_1508}"
        elif [ "$(( $(( $(( line_len_1506 + 1 )) + piece_len_1508 )) > width_1504 ))" != 0 ]; then
            local array_31=()
            printf__128_v0 "${line_1505}""
" array_31[@]
            line_1505="${piece_1507}"
            line_len_1506="${piece_len_1508}"
        else
            line_1505+=" ""${piece_1507}"
            line_len_1506="$(( line_len_1506 + $(( 1 + piece_len_1508 )) ))"
        fi
    done
    if [ "$([ "_${line_1505}" == "_" ]; echo $?)" != 0 ]; then
        local array_32=()
        printf__128_v0 "${line_1505}""
" array_32[@]
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
get_supports_truecolor__258_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1544="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1544}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor258_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__259_v0() {
    local message_1539="${1}"
    local r_1540="${2}"
    local g_1541="${3}"
    local b_1542="${4}"
    local fallback_1543="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb259_v0="\\x1b[38;2;${r_1540};${g_1541};${b_1542}m""${message_1539}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__258_v0 
        local ret_get_supports_truecolor258_v0__45_17="${ret_get_supports_truecolor258_v0}"
        if [ "${ret_get_supports_truecolor258_v0__45_17}" != 0 ]; then
            ret_colored_rgb259_v0="\\x1b[38;2;${r_1540};${g_1541};${b_1542}m""${message_1539}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1543 == 0 ))" != 0 ]; then
            ret_colored_rgb259_v0="${message_1539}"
            return 0
        else
            ret_colored_rgb259_v0="\\x1b[${fallback_1543}m""${message_1539}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1543 == 0 ))" != 0 ]; then
            ret_colored_rgb259_v0="${message_1539}"
            return 0
        fi
        ret_colored_rgb259_v0="\\x1b[${fallback_1543}m""${message_1539}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__261_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1528="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1528}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1528}" ";"
            local parts_1529=("${ret_split4_v0[@]}")
            local __length_36=("${parts_1529[@]}")
            if [ "$(( ${#__length_36[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1529[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1529[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1529[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1529[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_10=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1530="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1530}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1530}" ";"
            local parts_1531=("${ret_split4_v0[@]}")
            local __length_38=("${parts_1531[@]}")
            if [ "$(( ${#__length_38[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1531[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1531[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1531[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1531[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_11=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1532="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1532}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1532}" ";"
            local parts_1533=("${ret_split4_v0[@]}")
            local __length_40=("${parts_1533[@]}")
            if [ "$(( ${#__length_40[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1533[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1533[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1533[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1533[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
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
get_xylitol_colors__262_v0() {
    inner_get_xylitol_colors__261_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_9=1
}

# colored_primary(message: Text)
colored_primary__263_v0() {
    local message_1526="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1526}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary263_v0="${ret_colored_rgb259_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__264_v0() {
    local message_1546="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1546}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary264_v0="${ret_colored_rgb259_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__265_v0() {
    local message_1597="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1597}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent265_v0="${ret_colored_rgb259_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__318_v0() {
    local message_1585="${1}"
    local color_1586="${2}"
    # Returns a text wrapped in color codes.
    ret_colored318_v0="\\x1b[${color_1586}m""${message_1585}""\\x1b[0m"
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
store_term_size__359_v0() {
    local size_1559="${1}"
    if [ "$([ "_${size_1559}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size359_v0=0
        return 0
    fi
    split__4_v0 "${size_1559}" " "
    local parts_1560=("${ret_split4_v0[@]}")
    local __length_43=("${parts_1560[@]}")
    if [ "$(( ${#__length_43[@]} != 2 ))" != 0 ]; then
        ret_store_term_size359_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1560[1]?"Index out of bounds (at src/utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1560[0]?"Index out of bounds (at src/utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_17=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size359_v0=1
    return 0
}

# query_term_size()
query_term_size__360_v0() {
    local command_45
    command_45="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1562="${command_45}"
    store_term_size__359_v0 "${size_1562}"
    ret_query_term_size360_v0="${ret_store_term_size359_v0}"
    return 0
}

# stty_term_size()
stty_term_size__361_v0() {
    local command_46
    command_46="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1558="${command_46}"
    store_term_size__359_v0 "${size_1558}"
    ret_stty_term_size361_v0="${ret_store_term_size359_v0}"
    return 0
}

# get_term_size()
get_term_size__362_v0() {
    stty_term_size__361_v0 
    local detected_1561="${ret_stty_term_size361_v0}"
    if [ "$(( ! detected_1561 ))" != 0 ]; then
        query_term_size__360_v0 
        detected_1561="${ret_query_term_size360_v0}"
    fi
    _got_term_size_16=1
}

# term_width()
term_width__364_v0() {
    if [ "$(( ! _got_term_size_16 ))" != 0 ]; then
        get_term_size__362_v0 
    fi
    ret_term_width364_v0="${_term_size_17[0]?"Index out of bounds (at src/utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__397_v0() {
    local pending_1582="${1}"
    local line_1583="${2}"
    local note_at_1584="${3}"
    if [ "$(( note_at_1584 < 0 ))" != 0 ]; then
        local array_48=()
        printf__128_v0 "${pending_1582}""${line_1583}""
" array_48[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1584 == 0 ))" != 0 ]; then
        colored__318_v0 "${line_1583}" 90
        local ret_colored318_v0__12_40="${ret_colored318_v0}"
        local array_49=()
        printf__128_v0 "${pending_1582}""${ret_colored318_v0__12_40}""
" array_49[@]
    else
        slice__24_v0 "${line_1583}" 0 "${note_at_1584}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1583}" "${note_at_1584}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__318_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored318_v0__13_58="${ret_colored318_v0}"
        local array_50=()
        printf__128_v0 "${pending_1582}""${ret_slice24_v0__13_32}""${ret_colored318_v0__13_58}""
" array_50[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__398_v0() {
    local names_1550=("${!1}")
    local texts_1551=("${!2}")
    local notes_1552=("${!3}")
    local min_name_width_1553="${4}"
    local __length_51=("${names_1550[@]}")
    local count_1554="${#__length_51[@]}"
    local name_width_1555="${min_name_width_1553}"
    local __range_start_1556=0
    local __range_end_1556="${count_1554}"
    local __dir_1556=$(( ${__range_start_1556} <= ${__range_end_1556} ? 1 : -1 ))
    for (( i_1556=${__range_start_1556}; i_1556 * ${__dir_1556} < ${__range_end_1556} * ${__dir_1556}; i_1556+=${__dir_1556} )); do
        local __length_52="${names_1550[${i_1556}]?"Index out of bounds (at src/utils/widget/help.ab:28:33)"}"
        local width_1557="${#__length_52}"
        if [ "$(( width_1557 > name_width_1555 ))" != 0 ]; then
            name_width_1555="${width_1557}"
        fi
done
    term_width__364_v0 
    local width_1563="${ret_term_width364_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1564="$(( name_width_1555 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1565="$(( $(( width_1563 - indent_1564 )) < 24 ))"
    if [ "${stacked_1565}" != 0 ]; then
        indent_1564=6
    fi
    local avail_1566="$(( width_1563 - indent_1564 ))"
    rpad__28_v0 "" " " "${indent_1564}"
    local blank_1572="${ret_rpad28_v0}"
    local __range_start_1573=0
    local __range_end_1573="${count_1554}"
    local __dir_1573=$(( ${__range_start_1573} <= ${__range_end_1573} ? 1 : -1 ))
    for (( i_1573=${__range_start_1573}; i_1573 * ${__dir_1573} < ${__range_end_1573} * ${__dir_1573}; i_1573+=${__dir_1573} )); do
        local pending_1574="${blank_1572}"
        if [ "${stacked_1565}" != 0 ]; then
            local array_53=()
            printf__128_v0 "  ""${names_1550[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:48:33)"}""
" array_53[@]
        else
            rpad__28_v0 "  ""${names_1550[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:50:41)"}" " " "${indent_1564}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_1574="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_1551[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_1575=("${ret_split4_v0__52_21[@]}")
        local __length_54=("${words_1575[@]}")
        local note_start_1576="${#__length_54[@]}"
        if [ "$([ "_${notes_1552[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_55="${notes_1552[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_55} > avail_1566 ))" != 0 ]; then
                split__4_v0 "${notes_1552[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_1575+=("${ret_split4_v0__58_26[@]}")
            else
                local array_56=("${notes_1552[${i_1573}]?"Index out of bounds (at src/utils/widget/help.ab:60:33)"}")
                words_1575+=("${array_56[@]}")
            fi
        fi
        local line_1577=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1578=-1
        local __range_start_1579=0
        local __length_57=("${words_1575[@]}")
        local __range_end_1579="${#__length_57[@]}"
        local __dir_1579=$(( ${__range_start_1579} <= ${__range_end_1579} ? 1 : -1 ))
        for (( j_1579=${__range_start_1579}; j_1579 * ${__dir_1579} < ${__range_end_1579} * ${__dir_1579}; j_1579+=${__dir_1579} )); do
            local word_1580="${words_1575[${j_1579}]?"Index out of bounds (at src/utils/widget/help.ab:70:32)"}"
            local candidate_1581
            candidate_1581="$(if [ "$([ "_${line_1577}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1580}"; else echo "${line_1577}"" ""${word_1580}"; fi)"
            local __length_58="${candidate_1581}"
            if [ "$(( $(( ${#__length_58} > avail_1566 )) && $([ "_${line_1577}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__397_v0 "${pending_1574}" "${line_1577}" "${note_at_1578}"
                pending_1574="${blank_1572}"
                line_1577="${word_1580}"
                note_at_1578="$(if [ "$(( j_1579 >= note_start_1576 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1579 >= note_start_1576 )) && $(( note_at_1578 < 0 )) ))" != 0 ]; then
                    local __length_59="${candidate_1581}"
                    local __length_60="${word_1580}"
                    note_at_1578="$(( ${#__length_59} - ${#__length_60} ))"
                fi
                line_1577="${candidate_1581}"
            fi
done
        print_help_line__397_v0 "${pending_1574}" "${line_1577}" "${note_at_1578}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__555_v0() {
    local usage_1493=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__221_v0 usage_1493[@]
    printf '%s\n' ""
    colored_primary__263_v0 "Xylitol"
    local ret_colored_primary263_v0__9_21="${ret_colored_primary263_v0}"
    colored_primary__263_v0 "fresh"
    local ret_colored_primary263_v0__10_34="${ret_colored_primary263_v0}"
    local title_1545=("\\x1b[1m""${ret_colored_primary263_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary263_v0__10_34}" "shell" "scripts.")
    print_wrapped__221_v0 title_1545[@]
    printf '%s\n' ""
    colored_secondary__264_v0 "Flags:"
    local ret_colored_secondary264_v0__14_12="${ret_colored_secondary264_v0}"
    local array_63=()
    printf__128_v0 "${ret_colored_secondary264_v0__14_12}""
" array_63[@]
    local flag_names_1547=("-h, --help" "-v, --version")
    local flag_texts_1548=("Show this help message" "Show version information")
    local flag_notes_1549=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__398_v0 flag_names_1547[@] flag_texts_1548[@] flag_notes_1549[@] 13
    printf '%s\n' ""
    colored_secondary__264_v0 "Commands:"
    local ret_colored_secondary264_v0__21_12="${ret_colored_secondary264_v0}"
    local array_67=()
    printf__128_v0 "${ret_colored_secondary264_v0__21_12}""
" array_67[@]
    local cmd_names_1591=("input" "choose" "filter" "confirm" "file")
    local cmd_texts_1592=("Prompt for some input" "Choose from a list of options" "Pick from a list narrowed by typing" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1593=("" "" "" "" "")
    render_help_entries__398_v0 cmd_names_1591[@] cmd_texts_1592[@] cmd_notes_1593[@] 13
    printf '%s\n' ""
    colored_secondary__264_v0 "Envs:"
    local ret_colored_secondary264_v0__33_12="${ret_colored_secondary264_v0}"
    local array_71=()
    printf__128_v0 "${ret_colored_secondary264_v0__33_12}""
" array_71[@]
    local env_names_1594=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1595=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1596=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__398_v0 env_names_1594[@] env_texts_1595[@] env_notes_1596[@] 0
    printf '%s\n' ""
    colored_accent__265_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent265_v0__58_16="${ret_colored_accent265_v0}"
    local footer_1598=("Run" "${ret_colored_accent265_v0__58_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__221_v0 footer_1598[@]
}

# math_floor(number: Int)
math_floor__636_v0() {
    local number_3280="${1}"
    local command_76
    command_76="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_3280}")"
    __status=$?
    ret_math_floor636_v0="${command_76}"
    return 0
}

# math_ceil(number: Int)
math_ceil__637_v0() {
    local number_3279="${1}"
    math_floor__636_v0 "${number_3279}"
    local ret_math_floor636_v0__52_12="${ret_math_floor636_v0}"
    ret_math_ceil637_v0="$(( ret_math_floor636_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__645_v0() {
    local command_77
    command_77="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3274="${command_77}"
    ret_get_char645_v0="${char_3274}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__648_v0() {
    local format_3246="${1}"
    local args_3247=("${!2}")
    args_3247=("${format_3246}" "${args_3247[@]}")
    __status=$?
    printf "${args_3247[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__649_v0() {
    local message_3272="${1}"
    local color_3273="${2}"
    # Prints an error message with a specified color.
    local array_78=("${message_3272}")
    eprintf__648_v0 "\\x1b[${color_3273}m%s\\x1b[0m" array_78[@]
}

# eprintf(format: Text, args: [Text])
eprintf__664_v0() {
    local format_3250="${1}"
    local args_3251=("${!2}")
    args_3251=("${format_3250}" "${args_3251[@]}")
    __status=$?
    printf "${args_3251[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_24="None"
# perl_available()
perl_available__671_v0() {
    if [ "$([ "_${_perl_state_24}" != "_None" ]; echo $?)" != 0 ]; then
        local command_79
        command_79="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3140
        disabled_3140="$([ "_${command_79}" != "_No" ]; echo $?)"
        local command_80
        command_80="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3141
        found_3141="$(( $(( ! disabled_3140 )) && $([ "_${command_80}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_3141}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available671_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__672_v0() {
    local text_3139="${1}"
    perl_available__671_v0 
    local ret_perl_available671_v0__19_12="${ret_perl_available671_v0}"
    if [ "$(( ! ret_perl_available671_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return 1
    fi
    local command_81
    command_81="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3139}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return "${__status}"
    fi
    local width_str_3142="${command_81}"
    parse_int__13_v0 "${width_str_3142}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return "${__status}"
    fi
    local width_3143="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width672_v0="${width_3143}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__677_v0() {
    local text_3129="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_82
    command_82="$([[ "${text_3129}" == *$'\x1b'* || "${text_3129}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3130="${command_82}"
    ret_has_ansi_escape677_v0="$([ "_${has_escape_3130}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__679_v0() {
    local text_3135="${1}"
    local command_83
    command_83="$(printf "%s" "${text_3135}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi679_v0="${command_83}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__680_v0() {
    local text_3137="${1}"
    local command_84
    command_84="$(printf "%s" "${text_3137}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3138="${command_84}"
    ret_is_all_ascii680_v0="$([ "_${result_3138}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__681_v0() {
    local text_3132="${1}"
    local command_85
    command_85="$(LC_ALL=C; __t="${text_3132}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3133="${command_85}"
    parse_int__13_v0 "${measured_3133}"
    __status=$?
    ret_plain_len681_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__682_v0() {
    local text_3131="${1}"
    plain_len__681_v0 "${text_3131}"
    local plain_3134="${ret_plain_len681_v0}"
    if [ "$(( plain_3134 >= 0 ))" != 0 ]; then
        ret_get_visible_len682_v0="${plain_3134}"
        return 0
    fi
    strip_ansi__679_v0 "${text_3131}"
    local stripped_3136="${ret_strip_ansi679_v0}"
    is_all_ascii__680_v0 "${stripped_3136}"
    local ret_is_all_ascii680_v0__46_12="${ret_is_all_ascii680_v0}"
    if [ "$(( ! ret_is_all_ascii680_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__672_v0 "${stripped_3136}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_86="${stripped_3136}"
            ret_get_visible_len682_v0="${#__length_86}"
            return 0
        fi
        ret_get_visible_len682_v0="${ret_perl_get_cjk_width672_v0}"
        return 0
    fi
    local __length_87="${stripped_3136}"
    ret_get_visible_len682_v0="${#__length_87}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_25=0
_term_size_26=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__688_v0() {
    local command_89
    command_89="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_3204="${command_89}"
    parse_int__13_v0 "${count_3204}"
    __status=$?
    ret_stty_count688_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__689_v0() {
    stty_count__688_v0 
    local count_num_3205="${ret_stty_count688_v0}"
    if [ "$(( count_num_3205 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_3205="$(( count_num_3205 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3205}
    __status=$?
}

# stty_unlock()
stty_unlock__690_v0() {
    stty_count__688_v0 
    local count_num_3277="${ret_stty_count688_v0}"
    if [ "$(( count_num_3277 > 0 ))" != 0 ]; then
        count_num_3277="$(( count_num_3277 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3277}
        __status=$?
        if [ "$(( count_num_3277 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__691_v0() {
    local size_3120="${1}"
    if [ "$([ "_${size_3120}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size691_v0=0
        return 0
    fi
    split__4_v0 "${size_3120}" " "
    local parts_3121=("${ret_split4_v0[@]}")
    local __length_90=("${parts_3121[@]}")
    if [ "$(( ${#__length_90[@]} != 2 ))" != 0 ]; then
        ret_store_term_size691_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3121[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3121[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_26=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size691_v0=1
    return 0
}

# query_term_size()
query_term_size__692_v0() {
    local command_92
    command_92="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_3123="${command_92}"
    store_term_size__691_v0 "${size_3123}"
    ret_query_term_size692_v0="${ret_store_term_size691_v0}"
    return 0
}

# stty_term_size()
stty_term_size__693_v0() {
    local command_93
    command_93="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3119="${command_93}"
    store_term_size__691_v0 "${size_3119}"
    ret_stty_term_size693_v0="${ret_store_term_size691_v0}"
    return 0
}

# get_term_size()
get_term_size__694_v0() {
    stty_term_size__693_v0 
    local detected_3122="${ret_stty_term_size693_v0}"
    if [ "$(( ! detected_3122 ))" != 0 ]; then
        query_term_size__692_v0 
        detected_3122="${ret_query_term_size692_v0}"
    fi
    _got_term_size_25=1
}

# term_width()
term_width__696_v0() {
    if [ "$(( ! _got_term_size_25 ))" != 0 ]; then
        get_term_size__694_v0 
    fi
    ret_term_width696_v0="${_term_size_26[0]?"Index out of bounds (at src/./input/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove(cnt: Int)
remove__698_v0() {
    local cnt_3275="${1}"
    if [ "$(( cnt_3275 > 0 ))" != 0 ]; then
        local array_94=("")
        eprintf__664_v0 "\\x1b[${cnt_3275}D\\x1b[K" array_94[@]
    fi
}

# remove_line(cnt: Int)
remove_line__699_v0() {
    local cnt_3283="${1}"
    if [ "$(( cnt_3283 > 0 ))" != 0 ]; then
        local sequence_3284=""
        local __range_start_3285=0
        local __range_end_3285="${cnt_3283}"
        local __dir_3285=$(( ${__range_start_3285} <= ${__range_end_3285} ? 1 : -1 ))
        for (( ____3285=${__range_start_3285}; ____3285 * ${__dir_3285} < ${__range_end_3285} * ${__dir_3285}; ____3285+=${__dir_3285} )); do
            sequence_3284+="\\x1b[2K\\x1b[1A"
done
        local array_95=("")
        eprintf__664_v0 "${sequence_3284}" array_95[@]
    fi
    local array_96=("")
    eprintf__664_v0 "\\x1b[G" array_96[@]
}

# remove_current_line()
remove_current_line__700_v0() {
    local array_97=("")
    eprintf__664_v0 "\\x1b[2K\\x1b[G" array_97[@]
}

# new_line(cnt: Int)
new_line__702_v0() {
    local cnt_3248="${1}"
    local __range_start_3249=0
    local __range_end_3249="${cnt_3248}"
    local __dir_3249=$(( ${__range_start_3249} <= ${__range_end_3249} ? 1 : -1 ))
    for (( ____3249=${__range_start_3249}; ____3249 * ${__dir_3249} < ${__range_end_3249} * ${__dir_3249}; ____3249+=${__dir_3249} )); do
        local array_98=("")
        eprintf__664_v0 "
" array_98[@]
done
}

# go_up(cnt: Int)
go_up__703_v0() {
    local cnt_3269="${1}"
    local array_99=("")
    eprintf__664_v0 "\\x1b[${cnt_3269}A" array_99[@]
}

# go_down(cnt: Int)
go_down__704_v0() {
    local cnt_3282="${1}"
    local array_100=("")
    eprintf__664_v0 "\\x1b[${cnt_3282}B" array_100[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__708_v0() {
    local pieces_3118=("${!1}")
    term_width__696_v0 
    local width_3124="${ret_term_width696_v0}"
    local line_3125=""
    local line_len_3126=0
    for piece_3127 in "${pieces_3118[@]}"; do
        local __length_103="${piece_3127}"
        local piece_len_3128="${#__length_103}"
        has_ansi_escape__677_v0 "${piece_3127}"
        local ret_has_ansi_escape677_v0__186_12="${ret_has_ansi_escape677_v0}"
        if [ "${ret_has_ansi_escape677_v0__186_12}" != 0 ]; then
            get_visible_len__682_v0 "${piece_3127}"
            piece_len_3128="${ret_get_visible_len682_v0}"
        fi
        if [ "$([ "_${line_3125}" != "_" ]; echo $?)" != 0 ]; then
            line_3125="${piece_3127}"
            line_len_3126="${piece_len_3128}"
        elif [ "$(( $(( $(( line_len_3126 + 1 )) + piece_len_3128 )) > width_3124 ))" != 0 ]; then
            local array_104=()
            printf__128_v0 "${line_3125}""
" array_104[@]
            line_3125="${piece_3127}"
            line_len_3126="${piece_len_3128}"
        else
            line_3125+=" ""${piece_3127}"
            line_len_3126="$(( line_len_3126 + $(( 1 + piece_len_3128 )) ))"
        fi
    done
    if [ "$([ "_${line_3125}" == "_" ]; echo $?)" != 0 ]; then
        local array_105=()
        printf__128_v0 "${line_3125}""
" array_105[@]
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
get_supports_truecolor__745_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_3156="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_3156}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor745_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__746_v0() {
    local message_3151="${1}"
    local r_3152="${2}"
    local g_3153="${3}"
    local b_3154="${4}"
    local fallback_3155="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb746_v0="\\x1b[38;2;${r_3152};${g_3153};${b_3154}m""${message_3151}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__745_v0 
        local ret_get_supports_truecolor745_v0__45_17="${ret_get_supports_truecolor745_v0}"
        if [ "${ret_get_supports_truecolor745_v0__45_17}" != 0 ]; then
            ret_colored_rgb746_v0="\\x1b[38;2;${r_3152};${g_3153};${b_3154}m""${message_3151}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_3155 == 0 ))" != 0 ]; then
            ret_colored_rgb746_v0="${message_3151}"
            return 0
        else
            ret_colored_rgb746_v0="\\x1b[${fallback_3155}m""${message_3151}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_3155 == 0 ))" != 0 ]; then
            ret_colored_rgb746_v0="${message_3151}"
            return 0
        fi
        ret_colored_rgb746_v0="\\x1b[${fallback_3155}m""${message_3151}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__748_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_3145="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_3145}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_3145}" ";"
            local parts_3146=("${ret_split4_v0[@]}")
            local __length_109=("${parts_3146[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3146[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3146[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3146[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3146[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_31=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_3147="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_3147}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_3147}" ";"
            local parts_3148=("${ret_split4_v0[@]}")
            local __length_111=("${parts_3148[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3148[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_32=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_3149="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_3149}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_3149}" ";"
            local parts_3150=("${ret_split4_v0[@]}")
            local __length_113=("${parts_3150[@]}")
            if [ "$(( ${#__length_113[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3150[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3150[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3150[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3150[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_30=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__749_v0() {
    inner_get_xylitol_colors__748_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_30=1
}

# colored_primary(message: Text)
colored_primary__750_v0() {
    local message_3144="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__749_v0 
    fi
    colored_rgb__746_v0 "${message_3144}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary750_v0="${ret_colored_rgb746_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__751_v0() {
    local message_3158="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__749_v0 
    fi
    colored_rgb__746_v0 "${message_3158}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary751_v0="${ret_colored_rgb746_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_34="None"
# perl_available()
perl_available__768_v0() {
    if [ "$([ "_${_perl_state_34}" != "_None" ]; echo $?)" != 0 ]; then
        local command_115
        command_115="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3218
        disabled_3218="$([ "_${command_115}" != "_No" ]; echo $?)"
        local command_116
        command_116="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3219
        found_3219="$(( $(( ! disabled_3218 )) && $([ "_${command_116}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3219}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available768_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__769_v0() {
    local text_3217="${1}"
    perl_available__768_v0 
    local ret_perl_available768_v0__19_12="${ret_perl_available768_v0}"
    if [ "$(( ! ret_perl_available768_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return 1
    fi
    local command_117
    command_117="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3217}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return "${__status}"
    fi
    local width_str_3220="${command_117}"
    parse_int__13_v0 "${width_str_3220}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return "${__status}"
    fi
    local width_3221="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width769_v0="${width_3221}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__770_v0() {
    local text_3228="${1}"
    local max_width_3229="${2}"
    perl_available__768_v0 
    local ret_perl_available768_v0__30_12="${ret_perl_available768_v0}"
    if [ "$(( ! ret_perl_available768_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk770_v0=''
        return 1
    fi
    local command_118
    command_118="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3228}" ${max_width_3229} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk770_v0=''
        return "${__status}"
    fi
    local result_3230="${command_118}"
    ret_perl_truncate_cjk770_v0="${result_3230}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__774_v0() {
    local text_3196="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_119
    command_119="$([[ "${text_3196}" == *$'\x1b'* || "${text_3196}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3197="${command_119}"
    ret_has_ansi_escape774_v0="$([ "_${has_escape_3197}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__775_v0() {
    local text_3198="${1}"
    local command_120
    command_120="$(printf '%s' "${text_3198}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi775_v0="${command_120}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__776_v0() {
    local text_3213="${1}"
    local command_121
    command_121="$(printf "%s" "${text_3213}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi776_v0="${command_121}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__777_v0() {
    local text_3215="${1}"
    local command_122
    command_122="$(printf "%s" "${text_3215}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3216="${command_122}"
    ret_is_all_ascii777_v0="$([ "_${result_3216}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__778_v0() {
    local text_3210="${1}"
    local command_123
    command_123="$(LC_ALL=C; __t="${text_3210}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3211="${command_123}"
    parse_int__13_v0 "${measured_3211}"
    __status=$?
    ret_plain_len778_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__779_v0() {
    local text_3209="${1}"
    plain_len__778_v0 "${text_3209}"
    local plain_3212="${ret_plain_len778_v0}"
    if [ "$(( plain_3212 >= 0 ))" != 0 ]; then
        ret_get_visible_len779_v0="${plain_3212}"
        return 0
    fi
    strip_ansi__776_v0 "${text_3209}"
    local stripped_3214="${ret_strip_ansi776_v0}"
    is_all_ascii__777_v0 "${stripped_3214}"
    local ret_is_all_ascii777_v0__46_12="${ret_is_all_ascii777_v0}"
    if [ "$(( ! ret_is_all_ascii777_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__769_v0 "${stripped_3214}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_124="${stripped_3214}"
            ret_get_visible_len779_v0="${#__length_124}"
            return 0
        fi
        ret_get_visible_len779_v0="${ret_perl_get_cjk_width769_v0}"
        return 0
    fi
    local __length_125="${stripped_3214}"
    ret_get_visible_len779_v0="${#__length_125}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__780_v0() {
    local text_3225="${1}"
    local max_width_3226="${2}"
    get_visible_len__779_v0 "${text_3225}"
    local visible_len_3227="${ret_get_visible_len779_v0}"
    if [ "$(( visible_len_3227 <= max_width_3226 ))" != 0 ]; then
        ret_truncate_text780_v0="${text_3225}"
        return 0
    fi
    is_all_ascii__777_v0 "${text_3225}"
    local ret_is_all_ascii777_v0__61_12="${ret_is_all_ascii777_v0}"
    if [ "$(( ! ret_is_all_ascii777_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__770_v0 "${text_3225}" "${max_width_3226}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3225}" | cut -c1-${max_width_3226}
            __status=$?
        fi
        ret_truncate_text780_v0="${ret_perl_truncate_cjk770_v0}"
        return 0
    fi
    local command_126
    command_126="$(printf "%s" "${text_3225}" | cut -c1-${max_width_3226})"
    __status=$?
    ret_truncate_text780_v0="${command_126}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__781_v0() {
    local text_3223="${1}"
    local max_width_3224="${2}"
    has_ansi_escape__774_v0 "${text_3223}"
    local ret_has_ansi_escape774_v0__73_12="${ret_has_ansi_escape774_v0}"
    if [ "$(( ! ret_has_ansi_escape774_v0__73_12 ))" != 0 ]; then
        truncate_text__780_v0 "${text_3223}" "${max_width_3224}"
        ret_truncate_ansi781_v0="${ret_truncate_text780_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_127
    command_127="$([[ "${text_3223}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3231="${command_127}"
    # Replace \x1b[ with newline, then split
    local command_128
    command_128="$(t="${text_3223}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3232="${command_128}"
    split__4_v0 "${replaced_3232}" "
"
    local parts_3233=("${ret_split4_v0[@]}")
    local result_3234=""
    local remaining_width_3235="${max_width_3224}"
    local __range_start_3236=0
    local __length_129=("${parts_3233[@]}")
    local __range_end_3236="${#__length_129[@]}"
    local __dir_3236=$(( ${__range_start_3236} <= ${__range_end_3236} ? 1 : -1 ))
    for (( idx_3236=${__range_start_3236}; idx_3236 * ${__dir_3236} < ${__range_end_3236} * ${__dir_3236}; idx_3236+=${__dir_3236} )); do
        local part_3237="${parts_3233[${idx_3236}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3236 == 0 )) && $([ "_${starts_with_ansi_3231}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3237}" == "_" ]; echo $?) && $(( remaining_width_3235 > 0 )) ))" != 0 ]; then
                truncate_text__780_v0 "${part_3237}" "${remaining_width_3235}"
                local ret_truncate_text780_v0__95_35="${ret_truncate_text780_v0}"
                local truncated_3238="${ret_truncate_text780_v0__95_35}"
                result_3234+="${truncated_3238}"
                get_visible_len__779_v0 "${truncated_3238}"
                local ret_get_visible_len779_v0__97_36="${ret_get_visible_len779_v0}"
                remaining_width_3235="$(( remaining_width_3235 - ret_get_visible_len779_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_130
            command_130="$(__p="${part_3237}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3239="${command_130}"
            if [ "$([ "_${m_idx_3239}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_131
                command_131="$(__p="${part_3237}"; printf "%s" "${__p:0:${m_idx_3239}}")"
                __status=$?
                local ansi_params_3240="${command_131}"
                result_3234+="\\x1b[""${ansi_params_3240}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3239}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_3241="${ret_parse_int13_v0__108_41}"
                local text_start_3242="$(( m_idx_num_3241 + 1 ))"
                local command_132
                command_132="$(__p="${part_3237}"; printf "%s" "${__p:${text_start_3242}}")"
                __status=$?
                local text_part_3243="${command_132}"
                if [ "$(( $([ "_${text_part_3243}" == "_" ]; echo $?) && $(( remaining_width_3235 > 0 )) ))" != 0 ]; then
                    truncate_text__780_v0 "${text_part_3243}" "${remaining_width_3235}"
                    local ret_truncate_text780_v0__112_39="${ret_truncate_text780_v0}"
                    local truncated_3244="${ret_truncate_text780_v0__112_39}"
                    result_3234+="${truncated_3244}"
                    get_visible_len__779_v0 "${truncated_3244}"
                    local ret_get_visible_len779_v0__114_40="${ret_get_visible_len779_v0}"
                    remaining_width_3235="$(( remaining_width_3235 - ret_get_visible_len779_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3237}" == "_" ]; echo $?) && $(( remaining_width_3235 > 0 )) ))" != 0 ]; then
                    truncate_text__780_v0 "${part_3237}" "${remaining_width_3235}"
                    local ret_truncate_text780_v0__119_39="${ret_truncate_text780_v0}"
                    local truncated_3245="${ret_truncate_text780_v0__119_39}"
                    result_3234+="${truncated_3245}"
                    get_visible_len__779_v0 "${truncated_3245}"
                    local ret_get_visible_len779_v0__121_40="${ret_get_visible_len779_v0}"
                    remaining_width_3235="$(( remaining_width_3235 - ret_get_visible_len779_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi781_v0="${result_3234}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__782_v0() {
    local text_3207="${1}"
    local max_width_3208="${2}"
    get_visible_len__779_v0 "${text_3207}"
    local visible_len_3222="${ret_get_visible_len779_v0}"
    if [ "$(( visible_len_3222 <= max_width_3208 ))" != 0 ]; then
        ret_cutoff_text782_v0="${text_3207}"
        return 0
    fi
    truncate_ansi__781_v0 "${text_3207}" "$(( max_width_3208 - 3 ))"
    local ret_truncate_ansi781_v0__137_12="${ret_truncate_ansi781_v0}"
    ret_cutoff_text782_v0="${ret_truncate_ansi781_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__803_v0() {
    local format_3260="${1}"
    local args_3261=("${!2}")
    args_3261=("${format_3260}" "${args_3261[@]}")
    __status=$?
    printf "${args_3261[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__804_v0() {
    local message_3258="${1}"
    local color_3259="${2}"
    # Prints an error message with a specified color.
    local array_133=("${message_3258}")
    eprintf__803_v0 "\\x1b[${color_3259}m%s\\x1b[0m" array_133[@]
}

# colored(message: Text, color: Int)
colored__805_v0() {
    local message_3192="${1}"
    local color_3193="${2}"
    # Returns a text wrapped in color codes.
    ret_colored805_v0="\\x1b[${color_3193}m""${message_3192}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__809_v0() {
    local items_3252=("${!1}")
    local total_len_3253="${2}"
    local term_width_3254="${3}"
    local separator_3255=" • "
    local separator_len_3256=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3253 <= term_width_3254 ))" != 0 ]; then
        local iter_3257=0
        while :
        do
            local __length_134=("${items_3252[@]}")
            if [ "$(( iter_3257 >= ${#__length_134[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3257 > 0 ))" != 0 ]; then
                eprintf_colored__804_v0 "${separator_3255}" 90
            fi
            colored__805_v0 "${items_3252[$(( iter_3257 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored805_v0__23_41="${ret_colored805_v0}"
            local array_135=("")
            eprintf__803_v0 "${items_3252[${iter_3257}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored805_v0__23_41}" array_135[@]
            iter_3257="$(( iter_3257 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3262=0
        local first_3263=1
        local iter_3264=0
        while :
        do
            local __length_136=("${items_3252[@]}")
            if [ "$(( iter_3264 >= ${#__length_136[@]} ))" != 0 ]; then
                break
            fi
            local key_3265="${items_3252[${iter_3264}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3266="${items_3252[$(( iter_3264 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_137="${key_3265}"
            local __length_138="${action_3266}"
            local part_len_3267="$(( $(( ${#__length_137} + 1 )) + ${#__length_138} ))"
            local needed_3268="${part_len_3267}"
            if [ "$(( ! first_3263 ))" != 0 ]; then
                needed_3268="$(( needed_3268 + separator_len_3256 ))"
            fi
            if [ "$(( $(( current_len_3262 + needed_3268 )) > term_width_3254 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3263 ))" != 0 ]; then
                eprintf_colored__804_v0 "${separator_3255}" 90
            fi
            colored__805_v0 "${action_3266}" 2
            local ret_colored805_v0__51_33="${ret_colored805_v0}"
            local array_139=("")
            eprintf__803_v0 "${key_3265}"" ""${ret_colored805_v0__51_33}" array_139[@]
            current_len_3262="$(( current_len_3262 + needed_3268 ))"
            first_3263=0
            iter_3264="$(( iter_3264 + 2 ))"
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
store_term_size__846_v0() {
    local size_3171="${1}"
    if [ "$([ "_${size_3171}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size846_v0=0
        return 0
    fi
    split__4_v0 "${size_3171}" " "
    local parts_3172=("${ret_split4_v0[@]}")
    local __length_141=("${parts_3172[@]}")
    if [ "$(( ${#__length_141[@]} != 2 ))" != 0 ]; then
        ret_store_term_size846_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3172[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3172[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_38=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size846_v0=1
    return 0
}

# query_term_size()
query_term_size__847_v0() {
    local command_143
    command_143="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_3174="${command_143}"
    store_term_size__846_v0 "${size_3174}"
    ret_query_term_size847_v0="${ret_store_term_size846_v0}"
    return 0
}

# stty_term_size()
stty_term_size__848_v0() {
    local command_144
    command_144="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3170="${command_144}"
    store_term_size__846_v0 "${size_3170}"
    ret_stty_term_size848_v0="${ret_store_term_size846_v0}"
    return 0
}

# get_term_size()
get_term_size__849_v0() {
    stty_term_size__848_v0 
    local detected_3173="${ret_stty_term_size848_v0}"
    if [ "$(( ! detected_3173 ))" != 0 ]; then
        query_term_size__847_v0 
        detected_3173="${ret_query_term_size847_v0}"
    fi
    _got_term_size_37=1
}

# term_width()
term_width__851_v0() {
    if [ "$(( ! _got_term_size_37 ))" != 0 ]; then
        get_term_size__849_v0 
    fi
    ret_term_width851_v0="${_term_size_38[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__884_v0() {
    local pending_3189="${1}"
    local line_3190="${2}"
    local note_at_3191="${3}"
    if [ "$(( note_at_3191 < 0 ))" != 0 ]; then
        local array_146=()
        printf__128_v0 "${pending_3189}""${line_3190}""
" array_146[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3191 == 0 ))" != 0 ]; then
        colored__805_v0 "${line_3190}" 90
        local ret_colored805_v0__12_40="${ret_colored805_v0}"
        local array_147=()
        printf__128_v0 "${pending_3189}""${ret_colored805_v0__12_40}""
" array_147[@]
    else
        slice__24_v0 "${line_3190}" 0 "${note_at_3191}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3190}" "${note_at_3191}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__805_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored805_v0__13_58="${ret_colored805_v0}"
        local array_148=()
        printf__128_v0 "${pending_3189}""${ret_slice24_v0__13_32}""${ret_colored805_v0__13_58}""
" array_148[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__885_v0() {
    local names_3162=("${!1}")
    local texts_3163=("${!2}")
    local notes_3164=("${!3}")
    local min_name_width_3165="${4}"
    local __length_149=("${names_3162[@]}")
    local count_3166="${#__length_149[@]}"
    local name_width_3167="${min_name_width_3165}"
    local __range_start_3168=0
    local __range_end_3168="${count_3166}"
    local __dir_3168=$(( ${__range_start_3168} <= ${__range_end_3168} ? 1 : -1 ))
    for (( i_3168=${__range_start_3168}; i_3168 * ${__dir_3168} < ${__range_end_3168} * ${__dir_3168}; i_3168+=${__dir_3168} )); do
        local __length_150="${names_3162[${i_3168}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_3169="${#__length_150}"
        if [ "$(( width_3169 > name_width_3167 ))" != 0 ]; then
            name_width_3167="${width_3169}"
        fi
done
    term_width__851_v0 
    local width_3175="${ret_term_width851_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_3176="$(( name_width_3167 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_3177="$(( $(( width_3175 - indent_3176 )) < 24 ))"
    if [ "${stacked_3177}" != 0 ]; then
        indent_3176=6
    fi
    local avail_3178="$(( width_3175 - indent_3176 ))"
    rpad__28_v0 "" " " "${indent_3176}"
    local blank_3179="${ret_rpad28_v0}"
    local __range_start_3180=0
    local __range_end_3180="${count_3166}"
    local __dir_3180=$(( ${__range_start_3180} <= ${__range_end_3180} ? 1 : -1 ))
    for (( i_3180=${__range_start_3180}; i_3180 * ${__dir_3180} < ${__range_end_3180} * ${__dir_3180}; i_3180+=${__dir_3180} )); do
        local pending_3181="${blank_3179}"
        if [ "${stacked_3177}" != 0 ]; then
            local array_151=()
            printf__128_v0 "  ""${names_3162[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_151[@]
        else
            rpad__28_v0 "  ""${names_3162[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_3176}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_3181="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_3163[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_3182=("${ret_split4_v0__52_21[@]}")
        local __length_152=("${words_3182[@]}")
        local note_start_3183="${#__length_152[@]}"
        if [ "$([ "_${notes_3164[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_153="${notes_3164[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_153} > avail_3178 ))" != 0 ]; then
                split__4_v0 "${notes_3164[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_3182+=("${ret_split4_v0__58_26[@]}")
            else
                local array_154=("${notes_3164[${i_3180}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_3182+=("${array_154[@]}")
            fi
        fi
        local line_3184=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_3185=-1
        local __range_start_3186=0
        local __length_155=("${words_3182[@]}")
        local __range_end_3186="${#__length_155[@]}"
        local __dir_3186=$(( ${__range_start_3186} <= ${__range_end_3186} ? 1 : -1 ))
        for (( j_3186=${__range_start_3186}; j_3186 * ${__dir_3186} < ${__range_end_3186} * ${__dir_3186}; j_3186+=${__dir_3186} )); do
            local word_3187="${words_3182[${j_3186}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_3188
            candidate_3188="$(if [ "$([ "_${line_3184}" != "_" ]; echo $?)" != 0 ]; then echo "${word_3187}"; else echo "${line_3184}"" ""${word_3187}"; fi)"
            local __length_156="${candidate_3188}"
            if [ "$(( $(( ${#__length_156} > avail_3178 )) && $([ "_${line_3184}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__884_v0 "${pending_3181}" "${line_3184}" "${note_at_3185}"
                pending_3181="${blank_3179}"
                line_3184="${word_3187}"
                note_at_3185="$(if [ "$(( j_3186 >= note_start_3183 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_3186 >= note_start_3183 )) && $(( note_at_3185 < 0 )) ))" != 0 ]; then
                    local __length_157="${candidate_3188}"
                    local __length_158="${word_3187}"
                    note_at_3185="$(( ${#__length_157} - ${#__length_158} ))"
                fi
                line_3184="${candidate_3188}"
            fi
done
        print_help_line__884_v0 "${pending_3181}" "${line_3184}" "${note_at_3185}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__943_v0() {
    local prompt_3200="${1}"
    local placeholder_3201="${2}"
    local header_3202="${3}"
    local password_3203="${4}"
    stty_lock__689_v0 
    term_width__696_v0 
    local term_width_3206="${ret_term_width696_v0}"
    if [ "$([ "_${header_3202}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__782_v0 "${header_3202}" "${term_width_3206}"
        local ret_cutoff_text782_v0__25_17="${ret_cutoff_text782_v0}"
        local array_159=("")
        eprintf__648_v0 "${ret_cutoff_text782_v0__25_17}""
" array_159[@]
    fi
    new_line__702_v0 2
    # "enter submit" = 12
    local array_160=("enter" "submit")
    render_tooltip__809_v0 array_160[@] 12 "${term_width_3206}"
    go_up__703_v0 2
    local array_161=("")
    eprintf__648_v0 "\\x1b[G" array_161[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_162
    command_162="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3270="${command_162}"
    local char_3271=""
    local array_163=("")
    eprintf__648_v0 "${prompt_3200}" array_163[@]
    if [ "$([ "_${can_preset_3270}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__649_v0 "${placeholder_3201}" 90
        get_char__645_v0 
        char_3271="${ret_get_char645_v0}"
        local __length_164="${placeholder_3201}"
        remove__698_v0 "$(( ${#__length_164} + 1 ))"
    fi
    local __length_165="${prompt_3200}"
    remove__698_v0 "${#__length_165}"
    local text_3276=""
    if [ "$(( ! password_3203 ))" != 0 ]; then
        stty_unlock__690_v0 
        local command_166
        command_166="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3271}" -p "${prompt_3200}" text < /dev/tty; else read -e -p "${prompt_3200}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3276="${command_166}"
    else
        stty_unlock__690_v0 
        local command_167
        command_167="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3271}" -p "${prompt_3200}" text < /dev/tty; else read -es -p "${prompt_3200}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3276="${command_167}"
    fi
    stty_lock__689_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__779_v0 "${prompt_3200}""${text_3276}"
    local input_display_len_3278="${ret_get_visible_len779_v0}"
    math_ceil__637_v0 "$(( input_display_len_3278 / term_width_3206 ))"
    local input_lines_3281="${ret_math_ceil637_v0}"
    if [ "$(( input_lines_3281 < 3 ))" != 0 ]; then
        go_down__704_v0 "$(( 2 - input_lines_3281 ))"
        remove_line__699_v0 2
        remove_current_line__700_v0 
    fi
    if [ "$(( input_lines_3281 >= 3 ))" != 0 ]; then
        remove_line__699_v0 "${input_lines_3281}"
    fi
    if [ "$([ "_${header_3202}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__699_v0 1
        remove_current_line__700_v0 
    fi
    stty_unlock__690_v0 
    ret_xyl_input943_v0="${text_3276}"
    return 0
}

# print_input_help()
print_input_help__1043_v0() {
    local usage_3117=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__708_v0 usage_3117[@]
    printf '%s\n' ""
    colored_primary__750_v0 "input"
    local ret_colored_primary750_v0__8_20="${ret_colored_primary750_v0}"
    local title_3157=("${ret_colored_primary750_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__708_v0 title_3157[@]
    printf '%s\n' ""
    colored_secondary__751_v0 "Flags:"
    local ret_colored_secondary751_v0__11_12="${ret_colored_secondary751_v0}"
    local array_170=()
    printf__128_v0 "${ret_colored_secondary751_v0__11_12}""
" array_170[@]
    local names_3159=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_3160=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_3161=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__885_v0 names_3159[@] texts_3160[@] notes_3161[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1101_v0() {
    local parameters_3111=("${!1}")
    local prompt_3112="> "
    local placeholder_3113="Type here..."
    local header_3114=""
    local password_3115=0
    for param_3116 in "${parameters_3111[@]}"; do
        if [ "$(( $([ "_${param_3116}" != "_-h" ]; echo $?) || $([ "_${param_3116}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1043_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_3116}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_176="--prompt="
            slice__24_v0 "${param_3116}" "${#__length_176}" 0
            prompt_3112="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3116}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_177="--placeholder="
            slice__24_v0 "${param_3116}" "${#__length_177}" 0
            placeholder_3113="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3116}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_178="--header="
            slice__24_v0 "${param_3116}" "${#__length_178}" 0
            header_3114="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_3116}" != "_--password" ]; echo $?)" != 0 ]; then
            password_3115=1
        fi
    done
    has_ansi_escape__774_v0 "${header_3114}"
    local ret_has_ansi_escape774_v0__31_44="${ret_has_ansi_escape774_v0}"
    escape_ansi__775_v0 "${header_3114}"
    local ret_escape_ansi775_v0__31_73="${ret_escape_ansi775_v0}"
    colored_primary__750_v0 "${header_3114}"
    local ret_colored_primary750_v0__31_111="${ret_colored_primary750_v0}"
    local display_header_3199
    display_header_3199="$(if [ "$(( $([ "_${header_3114}" != "_" ]; echo $?) || ret_has_ansi_escape774_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi775_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary750_v0__31_111}"; fi)"
    xyl_input__943_v0 "${prompt_3112}" "${placeholder_3113}" "${display_header_3199}" "${password_3115}"
    ret_execute_input1101_v0="${ret_xyl_input943_v0}"
    return 0
}

# get_key()
get_key__1182_v0() {
    local command_179
    command_179="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1182_v0="${command_179}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1184_v0() {
    local format_17978="${1}"
    local args_17979=("${!2}")
    args_17979=("${format_17978}" "${args_17979[@]}")
    __status=$?
    printf "${args_17979[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1185_v0() {
    local message_17976="${1}"
    local color_17977="${2}"
    # Prints an error message with a specified color.
    local array_180=("${message_17976}")
    eprintf__1184_v0 "\\x1b[${color_17977}m%s\\x1b[0m" array_180[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1200_v0() {
    local format_17999="${1}"
    local args_18000=("${!2}")
    args_18000=("${format_17999}" "${args_18000[@]}")
    __status=$?
    printf "${args_18000[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_46="None"
# perl_available()
perl_available__1207_v0() {
    if [ "$([ "_${_perl_state_46}" != "_None" ]; echo $?)" != 0 ]; then
        local command_181
        command_181="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_17931
        disabled_17931="$([ "_${command_181}" != "_No" ]; echo $?)"
        local command_182
        command_182="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_17932
        found_17932="$(( $(( ! disabled_17931 )) && $([ "_${command_182}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_17932}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1207_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1208_v0() {
    local text_17930="${1}"
    perl_available__1207_v0 
    local ret_perl_available1207_v0__19_12="${ret_perl_available1207_v0}"
    if [ "$(( ! ret_perl_available1207_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return 1
    fi
    local command_183
    command_183="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_17930}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return "${__status}"
    fi
    local width_str_17933="${command_183}"
    parse_int__13_v0 "${width_str_17933}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return "${__status}"
    fi
    local width_17934="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1208_v0="${width_17934}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1213_v0() {
    local text_17920="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_184
    command_184="$([[ "${text_17920}" == *$'\x1b'* || "${text_17920}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17921="${command_184}"
    ret_has_ansi_escape1213_v0="$([ "_${has_escape_17921}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1215_v0() {
    local text_17926="${1}"
    local command_185
    command_185="$(printf "%s" "${text_17926}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1215_v0="${command_185}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1216_v0() {
    local text_17928="${1}"
    local command_186
    command_186="$(printf "%s" "${text_17928}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_17929="${command_186}"
    ret_is_all_ascii1216_v0="$([ "_${result_17929}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1217_v0() {
    local text_17923="${1}"
    local command_187
    command_187="$(LC_ALL=C; __t="${text_17923}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_17924="${command_187}"
    parse_int__13_v0 "${measured_17924}"
    __status=$?
    ret_plain_len1217_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1218_v0() {
    local text_17922="${1}"
    plain_len__1217_v0 "${text_17922}"
    local plain_17925="${ret_plain_len1217_v0}"
    if [ "$(( plain_17925 >= 0 ))" != 0 ]; then
        ret_get_visible_len1218_v0="${plain_17925}"
        return 0
    fi
    strip_ansi__1215_v0 "${text_17922}"
    local stripped_17927="${ret_strip_ansi1215_v0}"
    is_all_ascii__1216_v0 "${stripped_17927}"
    local ret_is_all_ascii1216_v0__46_12="${ret_is_all_ascii1216_v0}"
    if [ "$(( ! ret_is_all_ascii1216_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1208_v0 "${stripped_17927}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_188="${stripped_17927}"
            ret_get_visible_len1218_v0="${#__length_188}"
            return 0
        fi
        ret_get_visible_len1218_v0="${ret_perl_get_cjk_width1208_v0}"
        return 0
    fi
    local __length_189="${stripped_17927}"
    ret_get_visible_len1218_v0="${#__length_189}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_47=0
_term_size_48=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1224_v0() {
    local command_191
    command_191="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_17997="${command_191}"
    parse_int__13_v0 "${count_17997}"
    __status=$?
    ret_stty_count1224_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1225_v0() {
    stty_count__1224_v0 
    local count_num_17998="${ret_stty_count1224_v0}"
    if [ "$(( count_num_17998 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_17998="$(( count_num_17998 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_17998}
    __status=$?
}

# stty_unlock()
stty_unlock__1226_v0() {
    stty_count__1224_v0 
    local count_num_18118="${ret_stty_count1224_v0}"
    if [ "$(( count_num_18118 > 0 ))" != 0 ]; then
        count_num_18118="$(( count_num_18118 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18118}
        __status=$?
        if [ "$(( count_num_18118 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1227_v0() {
    local size_17911="${1}"
    if [ "$([ "_${size_17911}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1227_v0=0
        return 0
    fi
    split__4_v0 "${size_17911}" " "
    local parts_17912=("${ret_split4_v0[@]}")
    local __length_192=("${parts_17912[@]}")
    if [ "$(( ${#__length_192[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1227_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17912[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17912[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_48=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1227_v0=1
    return 0
}

# query_term_size()
query_term_size__1228_v0() {
    local command_194
    command_194="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_17914="${command_194}"
    store_term_size__1227_v0 "${size_17914}"
    ret_query_term_size1228_v0="${ret_store_term_size1227_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1229_v0() {
    local command_195
    command_195="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17910="${command_195}"
    store_term_size__1227_v0 "${size_17910}"
    ret_stty_term_size1229_v0="${ret_store_term_size1227_v0}"
    return 0
}

# get_term_size()
get_term_size__1230_v0() {
    stty_term_size__1229_v0 
    local detected_17913="${ret_stty_term_size1229_v0}"
    if [ "$(( ! detected_17913 ))" != 0 ]; then
        query_term_size__1228_v0 
        detected_17913="${ret_query_term_size1228_v0}"
    fi
    _got_term_size_47=1
}

# term_width()
term_width__1232_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1230_v0 
    fi
    ret_term_width1232_v0="${_term_size_48[0]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1233_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1230_v0 
    fi
    ret_term_height1233_v0="${_term_size_48[1]?"Index out of bounds (at src/./choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1235_v0() {
    local cnt_18090="${1}"
    if [ "$(( cnt_18090 > 0 ))" != 0 ]; then
        local sequence_18091=""
        local __range_start_18092=0
        local __range_end_18092="${cnt_18090}"
        local __dir_18092=$(( ${__range_start_18092} <= ${__range_end_18092} ? 1 : -1 ))
        for (( ____18092=${__range_start_18092}; ____18092 * ${__dir_18092} < ${__range_end_18092} * ${__dir_18092}; ____18092+=${__dir_18092} )); do
            sequence_18091+="\\x1b[2K\\x1b[1A"
done
        local array_196=("")
        eprintf__1200_v0 "${sequence_18091}" array_196[@]
    fi
    local array_197=("")
    eprintf__1200_v0 "\\x1b[G" array_197[@]
}

# remove_current_line()
remove_current_line__1236_v0() {
    local array_198=("")
    eprintf__1200_v0 "\\x1b[2K\\x1b[G" array_198[@]
}

# print_blank(cnt: Int)
print_blank__1237_v0() {
    local cnt_18081="${1}"
    printf '%*s' "${cnt_18081}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1238_v0() {
    local cnt_18045="${1}"
    local __range_start_18046=0
    local __range_end_18046="${cnt_18045}"
    local __dir_18046=$(( ${__range_start_18046} <= ${__range_end_18046} ? 1 : -1 ))
    for (( ____18046=${__range_start_18046}; ____18046 * ${__dir_18046} < ${__range_end_18046} * ${__dir_18046}; ____18046+=${__dir_18046} )); do
        local array_199=("")
        eprintf__1200_v0 "
" array_199[@]
done
}

# go_up(cnt: Int)
go_up__1239_v0() {
    local cnt_18064="${1}"
    local array_200=("")
    eprintf__1200_v0 "\\x1b[${cnt_18064}A" array_200[@]
}

# go_down(cnt: Int)
go_down__1240_v0() {
    local cnt_18117="${1}"
    local array_201=("")
    eprintf__1200_v0 "\\x1b[${cnt_18117}B" array_201[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1242_v0() {
    local array_202=("")
    eprintf__1200_v0 "\\x1b[?25l" array_202[@]
}

# show_cursor()
show_cursor__1243_v0() {
    local array_203=("")
    eprintf__1200_v0 "\\x1b[?25h" array_203[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1244_v0() {
    local pieces_17909=("${!1}")
    term_width__1232_v0 
    local width_17915="${ret_term_width1232_v0}"
    local line_17916=""
    local line_len_17917=0
    for piece_17918 in "${pieces_17909[@]}"; do
        local __length_206="${piece_17918}"
        local piece_len_17919="${#__length_206}"
        has_ansi_escape__1213_v0 "${piece_17918}"
        local ret_has_ansi_escape1213_v0__186_12="${ret_has_ansi_escape1213_v0}"
        if [ "${ret_has_ansi_escape1213_v0__186_12}" != 0 ]; then
            get_visible_len__1218_v0 "${piece_17918}"
            piece_len_17919="${ret_get_visible_len1218_v0}"
        fi
        if [ "$([ "_${line_17916}" != "_" ]; echo $?)" != 0 ]; then
            line_17916="${piece_17918}"
            line_len_17917="${piece_len_17919}"
        elif [ "$(( $(( $(( line_len_17917 + 1 )) + piece_len_17919 )) > width_17915 ))" != 0 ]; then
            local array_207=()
            printf__128_v0 "${line_17916}""
" array_207[@]
            line_17916="${piece_17918}"
            line_len_17917="${piece_len_17919}"
        else
            line_17916+=" ""${piece_17918}"
            line_len_17917="$(( line_len_17917 + $(( 1 + piece_len_17919 )) ))"
        fi
    done
    if [ "$([ "_${line_17916}" == "_" ]; echo $?)" != 0 ]; then
        local array_208=()
        printf__128_v0 "${line_17916}""
" array_208[@]
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
get_supports_truecolor__1281_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_17899="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_17899}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1281_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1282_v0() {
    local message_17894="${1}"
    local r_17895="${2}"
    local g_17896="${3}"
    local b_17897="${4}"
    local fallback_17898="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1282_v0="\\x1b[38;2;${r_17895};${g_17896};${b_17897}m""${message_17894}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1281_v0 
        local ret_get_supports_truecolor1281_v0__45_17="${ret_get_supports_truecolor1281_v0}"
        if [ "${ret_get_supports_truecolor1281_v0__45_17}" != 0 ]; then
            ret_colored_rgb1282_v0="\\x1b[38;2;${r_17895};${g_17896};${b_17897}m""${message_17894}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_17898 == 0 ))" != 0 ]; then
            ret_colored_rgb1282_v0="${message_17894}"
            return 0
        else
            ret_colored_rgb1282_v0="\\x1b[${fallback_17898}m""${message_17894}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_17898 == 0 ))" != 0 ]; then
            ret_colored_rgb1282_v0="${message_17894}"
            return 0
        fi
        ret_colored_rgb1282_v0="\\x1b[${fallback_17898}m""${message_17894}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1284_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_17888="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_17888}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_17888}" ";"
            local parts_17889=("${ret_split4_v0[@]}")
            local __length_212=("${parts_17889[@]}")
            if [ "$(( ${#__length_212[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17889[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17889[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17889[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17889[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_53=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_17890="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_17890}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_17890}" ";"
            local parts_17891=("${ret_split4_v0[@]}")
            local __length_214=("${parts_17891[@]}")
            if [ "$(( ${#__length_214[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17891[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_54=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_17892="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_17892}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_17892}" ";"
            local parts_17893=("${ret_split4_v0[@]}")
            local __length_216=("${parts_17893[@]}")
            if [ "$(( ${#__length_216[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17893[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17893[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17893[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17893[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_52=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1285_v0() {
    inner_get_xylitol_colors__1284_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_52=1
}

# colored_primary(message: Text)
colored_primary__1286_v0() {
    local message_17887="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1285_v0 
    fi
    colored_rgb__1282_v0 "${message_17887}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1286_v0="${ret_colored_rgb1282_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1287_v0() {
    local message_17936="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1285_v0 
    fi
    colored_rgb__1282_v0 "${message_17936}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1287_v0="${ret_colored_rgb1282_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_56="None"
# perl_available()
perl_available__1304_v0() {
    if [ "$([ "_${_perl_state_56}" != "_None" ]; echo $?)" != 0 ]; then
        local command_218
        command_218="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18014
        disabled_18014="$([ "_${command_218}" != "_No" ]; echo $?)"
        local command_219
        command_219="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18015
        found_18015="$(( $(( ! disabled_18014 )) && $([ "_${command_219}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_18015}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1304_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1305_v0() {
    local text_18013="${1}"
    perl_available__1304_v0 
    local ret_perl_available1304_v0__19_12="${ret_perl_available1304_v0}"
    if [ "$(( ! ret_perl_available1304_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return 1
    fi
    local command_220
    command_220="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18013}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return "${__status}"
    fi
    local width_str_18016="${command_220}"
    parse_int__13_v0 "${width_str_18016}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return "${__status}"
    fi
    local width_18017="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1305_v0="${width_18017}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1306_v0() {
    local text_18024="${1}"
    local max_width_18025="${2}"
    perl_available__1304_v0 
    local ret_perl_available1304_v0__30_12="${ret_perl_available1304_v0}"
    if [ "$(( ! ret_perl_available1304_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1306_v0=''
        return 1
    fi
    local command_221
    command_221="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18024}" ${max_width_18025} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1306_v0=''
        return "${__status}"
    fi
    local result_18026="${command_221}"
    ret_perl_truncate_cjk1306_v0="${result_18026}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1310_v0() {
    local text_17981="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_222
    command_222="$([[ "${text_17981}" == *$'\x1b'* || "${text_17981}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17982="${command_222}"
    ret_has_ansi_escape1310_v0="$([ "_${has_escape_17982}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1311_v0() {
    local text_17983="${1}"
    local command_223
    command_223="$(printf '%s' "${text_17983}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1311_v0="${command_223}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1312_v0() {
    local text_18009="${1}"
    local command_224
    command_224="$(printf "%s" "${text_18009}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1312_v0="${command_224}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1313_v0() {
    local text_18011="${1}"
    local command_225
    command_225="$(printf "%s" "${text_18011}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18012="${command_225}"
    ret_is_all_ascii1313_v0="$([ "_${result_18012}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1314_v0() {
    local text_18006="${1}"
    local command_226
    command_226="$(LC_ALL=C; __t="${text_18006}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_18007="${command_226}"
    parse_int__13_v0 "${measured_18007}"
    __status=$?
    ret_plain_len1314_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1315_v0() {
    local text_18005="${1}"
    plain_len__1314_v0 "${text_18005}"
    local plain_18008="${ret_plain_len1314_v0}"
    if [ "$(( plain_18008 >= 0 ))" != 0 ]; then
        ret_get_visible_len1315_v0="${plain_18008}"
        return 0
    fi
    strip_ansi__1312_v0 "${text_18005}"
    local stripped_18010="${ret_strip_ansi1312_v0}"
    is_all_ascii__1313_v0 "${stripped_18010}"
    local ret_is_all_ascii1313_v0__46_12="${ret_is_all_ascii1313_v0}"
    if [ "$(( ! ret_is_all_ascii1313_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1305_v0 "${stripped_18010}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_227="${stripped_18010}"
            ret_get_visible_len1315_v0="${#__length_227}"
            return 0
        fi
        ret_get_visible_len1315_v0="${ret_perl_get_cjk_width1305_v0}"
        return 0
    fi
    local __length_228="${stripped_18010}"
    ret_get_visible_len1315_v0="${#__length_228}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1316_v0() {
    local text_18021="${1}"
    local max_width_18022="${2}"
    get_visible_len__1315_v0 "${text_18021}"
    local visible_len_18023="${ret_get_visible_len1315_v0}"
    if [ "$(( visible_len_18023 <= max_width_18022 ))" != 0 ]; then
        ret_truncate_text1316_v0="${text_18021}"
        return 0
    fi
    is_all_ascii__1313_v0 "${text_18021}"
    local ret_is_all_ascii1313_v0__61_12="${ret_is_all_ascii1313_v0}"
    if [ "$(( ! ret_is_all_ascii1313_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1306_v0 "${text_18021}" "${max_width_18022}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18021}" | cut -c1-${max_width_18022}
            __status=$?
        fi
        ret_truncate_text1316_v0="${ret_perl_truncate_cjk1306_v0}"
        return 0
    fi
    local command_229
    command_229="$(printf "%s" "${text_18021}" | cut -c1-${max_width_18022})"
    __status=$?
    ret_truncate_text1316_v0="${command_229}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1317_v0() {
    local text_18019="${1}"
    local max_width_18020="${2}"
    has_ansi_escape__1310_v0 "${text_18019}"
    local ret_has_ansi_escape1310_v0__73_12="${ret_has_ansi_escape1310_v0}"
    if [ "$(( ! ret_has_ansi_escape1310_v0__73_12 ))" != 0 ]; then
        truncate_text__1316_v0 "${text_18019}" "${max_width_18020}"
        ret_truncate_ansi1317_v0="${ret_truncate_text1316_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_230
    command_230="$([[ "${text_18019}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18027="${command_230}"
    # Replace \x1b[ with newline, then split
    local command_231
    command_231="$(t="${text_18019}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18028="${command_231}"
    split__4_v0 "${replaced_18028}" "
"
    local parts_18029=("${ret_split4_v0[@]}")
    local result_18030=""
    local remaining_width_18031="${max_width_18020}"
    local __range_start_18032=0
    local __length_232=("${parts_18029[@]}")
    local __range_end_18032="${#__length_232[@]}"
    local __dir_18032=$(( ${__range_start_18032} <= ${__range_end_18032} ? 1 : -1 ))
    for (( idx_18032=${__range_start_18032}; idx_18032 * ${__dir_18032} < ${__range_end_18032} * ${__dir_18032}; idx_18032+=${__dir_18032} )); do
        local part_18033="${parts_18029[${idx_18032}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18032 == 0 )) && $([ "_${starts_with_ansi_18027}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18033}" == "_" ]; echo $?) && $(( remaining_width_18031 > 0 )) ))" != 0 ]; then
                truncate_text__1316_v0 "${part_18033}" "${remaining_width_18031}"
                local ret_truncate_text1316_v0__95_35="${ret_truncate_text1316_v0}"
                local truncated_18034="${ret_truncate_text1316_v0__95_35}"
                result_18030+="${truncated_18034}"
                get_visible_len__1315_v0 "${truncated_18034}"
                local ret_get_visible_len1315_v0__97_36="${ret_get_visible_len1315_v0}"
                remaining_width_18031="$(( remaining_width_18031 - ret_get_visible_len1315_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_233
            command_233="$(__p="${part_18033}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18035="${command_233}"
            if [ "$([ "_${m_idx_18035}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_234
                command_234="$(__p="${part_18033}"; printf "%s" "${__p:0:${m_idx_18035}}")"
                __status=$?
                local ansi_params_18036="${command_234}"
                result_18030+="\\x1b[""${ansi_params_18036}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18035}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_18037="${ret_parse_int13_v0__108_41}"
                local text_start_18038="$(( m_idx_num_18037 + 1 ))"
                local command_235
                command_235="$(__p="${part_18033}"; printf "%s" "${__p:${text_start_18038}}")"
                __status=$?
                local text_part_18039="${command_235}"
                if [ "$(( $([ "_${text_part_18039}" == "_" ]; echo $?) && $(( remaining_width_18031 > 0 )) ))" != 0 ]; then
                    truncate_text__1316_v0 "${text_part_18039}" "${remaining_width_18031}"
                    local ret_truncate_text1316_v0__112_39="${ret_truncate_text1316_v0}"
                    local truncated_18040="${ret_truncate_text1316_v0__112_39}"
                    result_18030+="${truncated_18040}"
                    get_visible_len__1315_v0 "${truncated_18040}"
                    local ret_get_visible_len1315_v0__114_40="${ret_get_visible_len1315_v0}"
                    remaining_width_18031="$(( remaining_width_18031 - ret_get_visible_len1315_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18033}" == "_" ]; echo $?) && $(( remaining_width_18031 > 0 )) ))" != 0 ]; then
                    truncate_text__1316_v0 "${part_18033}" "${remaining_width_18031}"
                    local ret_truncate_text1316_v0__119_39="${ret_truncate_text1316_v0}"
                    local truncated_18041="${ret_truncate_text1316_v0__119_39}"
                    result_18030+="${truncated_18041}"
                    get_visible_len__1315_v0 "${truncated_18041}"
                    local ret_get_visible_len1315_v0__121_40="${ret_get_visible_len1315_v0}"
                    remaining_width_18031="$(( remaining_width_18031 - ret_get_visible_len1315_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1317_v0="${result_18030}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1318_v0() {
    local text_18003="${1}"
    local max_width_18004="${2}"
    get_visible_len__1315_v0 "${text_18003}"
    local visible_len_18018="${ret_get_visible_len1315_v0}"
    if [ "$(( visible_len_18018 <= max_width_18004 ))" != 0 ]; then
        ret_cutoff_text1318_v0="${text_18003}"
        return 0
    fi
    truncate_ansi__1317_v0 "${text_18003}" "$(( max_width_18004 - 3 ))"
    local ret_truncate_ansi1317_v0__137_12="${ret_truncate_ansi1317_v0}"
    ret_cutoff_text1318_v0="${ret_truncate_ansi1317_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1339_v0() {
    local format_18055="${1}"
    local args_18056=("${!2}")
    args_18056=("${format_18055}" "${args_18056[@]}")
    __status=$?
    printf "${args_18056[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1340_v0() {
    local message_18053="${1}"
    local color_18054="${2}"
    # Prints an error message with a specified color.
    local array_236=("${message_18053}")
    eprintf__1339_v0 "\\x1b[${color_18054}m%s\\x1b[0m" array_236[@]
}

# colored(message: Text, color: Int)
colored__1341_v0() {
    local message_17970="${1}"
    local color_17971="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1341_v0="\\x1b[${color_17971}m""${message_17970}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1345_v0() {
    local items_18047=("${!1}")
    local total_len_18048="${2}"
    local term_width_18049="${3}"
    local separator_18050=" • "
    local separator_len_18051=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18048 <= term_width_18049 ))" != 0 ]; then
        local iter_18052=0
        while :
        do
            local __length_237=("${items_18047[@]}")
            if [ "$(( iter_18052 >= ${#__length_237[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18052 > 0 ))" != 0 ]; then
                eprintf_colored__1340_v0 "${separator_18050}" 90
            fi
            colored__1341_v0 "${items_18047[$(( iter_18052 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1341_v0__23_41="${ret_colored1341_v0}"
            local array_238=("")
            eprintf__1339_v0 "${items_18047[${iter_18052}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1341_v0__23_41}" array_238[@]
            iter_18052="$(( iter_18052 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18057=0
        local first_18058=1
        local iter_18059=0
        while :
        do
            local __length_239=("${items_18047[@]}")
            if [ "$(( iter_18059 >= ${#__length_239[@]} ))" != 0 ]; then
                break
            fi
            local key_18060="${items_18047[${iter_18059}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_18061="${items_18047[$(( iter_18059 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_240="${key_18060}"
            local __length_241="${action_18061}"
            local part_len_18062="$(( $(( ${#__length_240} + 1 )) + ${#__length_241} ))"
            local needed_18063="${part_len_18062}"
            if [ "$(( ! first_18058 ))" != 0 ]; then
                needed_18063="$(( needed_18063 + separator_len_18051 ))"
            fi
            if [ "$(( $(( current_len_18057 + needed_18063 )) > term_width_18049 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18058 ))" != 0 ]; then
                eprintf_colored__1340_v0 "${separator_18050}" 90
            fi
            colored__1341_v0 "${action_18061}" 2
            local ret_colored1341_v0__51_33="${ret_colored1341_v0}"
            local array_242=("")
            eprintf__1339_v0 "${key_18060}"" ""${ret_colored1341_v0__51_33}" array_242[@]
            current_len_18057="$(( current_len_18057 + needed_18063 ))"
            first_18058=0
            iter_18059="$(( iter_18059 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1355_v0() {
    local format_18106="${1}"
    local args_18107=("${!2}")
    args_18107=("${format_18106}" "${args_18107[@]}")
    __status=$?
    printf "${args_18107[@]}" >&2
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
store_term_size__1382_v0() {
    local size_17949="${1}"
    if [ "$([ "_${size_17949}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1382_v0=0
        return 0
    fi
    split__4_v0 "${size_17949}" " "
    local parts_17950=("${ret_split4_v0[@]}")
    local __length_244=("${parts_17950[@]}")
    if [ "$(( ${#__length_244[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1382_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17950[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17950[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_60=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1382_v0=1
    return 0
}

# query_term_size()
query_term_size__1383_v0() {
    local command_246
    command_246="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_17952="${command_246}"
    store_term_size__1382_v0 "${size_17952}"
    ret_query_term_size1383_v0="${ret_store_term_size1382_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1384_v0() {
    local command_247
    command_247="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17948="${command_247}"
    store_term_size__1382_v0 "${size_17948}"
    ret_stty_term_size1384_v0="${ret_store_term_size1382_v0}"
    return 0
}

# get_term_size()
get_term_size__1385_v0() {
    stty_term_size__1384_v0 
    local detected_17951="${ret_stty_term_size1384_v0}"
    if [ "$(( ! detected_17951 ))" != 0 ]; then
        query_term_size__1383_v0 
        detected_17951="${ret_query_term_size1383_v0}"
    fi
    _got_term_size_59=1
}

# term_width()
term_width__1387_v0() {
    if [ "$(( ! _got_term_size_59 ))" != 0 ]; then
        get_term_size__1385_v0 
    fi
    ret_term_width1387_v0="${_term_size_60[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__1394_v0() {
    local cnt_18105="${1}"
    local array_248=("")
    eprintf__1355_v0 "\\x1b[${cnt_18105}A" array_248[@]
}

# go_down(cnt: Int)
go_down__1395_v0() {
    local cnt_18108="${1}"
    local array_249=("")
    eprintf__1355_v0 "\\x1b[${cnt_18108}B" array_249[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1402_v0() {
    local display_count_18102="${1}"
    local index_18103="${2}"
    local line_18104="${3}"
    go_up__1394_v0 "$(( display_count_18102 - index_18103 ))"
    local array_250=("")
    eprintf__1339_v0 "\\x1b[G\\x1b[K" array_250[@]
    local array_251=("")
    eprintf__1339_v0 "${line_18104}" array_251[@]
    go_down__1395_v0 "$(( display_count_18102 - index_18103 ))"
    local array_252=("")
    eprintf__1339_v0 "\\x1b[G" array_252[@]
}

# Which items of a multi-select widget are ticked.
_checked_61=()
_count_62=0
_total_63=0
_limit_64=-1
# checked_init(total: Int, limit: Int)
checked_init__1404_v0() {
    local total_18042="${1}"
    local limit_18043="${2}"
    _checked_61=()
    local __range_start_18044=0
    local __range_end_18044="${total_18042}"
    local __dir_18044=$(( ${__range_start_18044} <= ${__range_end_18044} ? 1 : -1 ))
    for (( ____18044=${__range_start_18044}; ____18044 * ${__dir_18044} < ${__range_end_18044} * ${__dir_18044}; ____18044+=${__dir_18044} )); do
        local array_255=(0)
        _checked_61+=("${array_255[@]}")
done
    _count_62=0
    _total_63="${total_18042}"
    _limit_64="${limit_18043}"
}

# checked_is(index: Int)
checked_is__1405_v0() {
    local index_18078="${1}"
    ret_checked_is1405_v0="${_checked_61[${index_18078}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1407_v0() {
    local index_18097="${1}"
    if [ "${_checked_61[${index_18097}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_61["${index_18097}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1407_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1407_v0=0
        return 0
    fi
    _checked_61["${index_18097}"]=1
    _count_62="$(( _count_62 + 1 ))"
    ret_checked_toggle1407_v0=1
    return 0
}

# checked_all()
checked_all__1408_v0() {
    if [ "$(( _limit_64 >= 0 ))" != 0 ]; then
        ret_checked_all1408_v0=0
        return 0
    fi
    local was_all_18109="$(( _count_62 == _total_63 ))"
    local __range_start_18110=0
    local __range_end_18110="${_total_63}"
    local __dir_18110=$(( ${__range_start_18110} <= ${__range_end_18110} ? 1 : -1 ))
    for (( i_18110=${__range_start_18110}; i_18110 * ${__dir_18110} < ${__range_end_18110} * ${__dir_18110}; i_18110+=${__dir_18110} )); do
        _checked_61["${i_18110}"]="$(( ! was_all_18109 ))"
done
    if [ "${was_all_18109}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1408_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1420_v0() {
    local pending_17967="${1}"
    local line_17968="${2}"
    local note_at_17969="${3}"
    if [ "$(( note_at_17969 < 0 ))" != 0 ]; then
        local array_256=()
        printf__128_v0 "${pending_17967}""${line_17968}""
" array_256[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_17969 == 0 ))" != 0 ]; then
        colored__1341_v0 "${line_17968}" 90
        local ret_colored1341_v0__12_40="${ret_colored1341_v0}"
        local array_257=()
        printf__128_v0 "${pending_17967}""${ret_colored1341_v0__12_40}""
" array_257[@]
    else
        slice__24_v0 "${line_17968}" 0 "${note_at_17969}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_17968}" "${note_at_17969}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1341_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1341_v0__13_58="${ret_colored1341_v0}"
        local array_258=()
        printf__128_v0 "${pending_17967}""${ret_slice24_v0__13_32}""${ret_colored1341_v0__13_58}""
" array_258[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1421_v0() {
    local names_17940=("${!1}")
    local texts_17941=("${!2}")
    local notes_17942=("${!3}")
    local min_name_width_17943="${4}"
    local __length_259=("${names_17940[@]}")
    local count_17944="${#__length_259[@]}"
    local name_width_17945="${min_name_width_17943}"
    local __range_start_17946=0
    local __range_end_17946="${count_17944}"
    local __dir_17946=$(( ${__range_start_17946} <= ${__range_end_17946} ? 1 : -1 ))
    for (( i_17946=${__range_start_17946}; i_17946 * ${__dir_17946} < ${__range_end_17946} * ${__dir_17946}; i_17946+=${__dir_17946} )); do
        local __length_260="${names_17940[${i_17946}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_17947="${#__length_260}"
        if [ "$(( width_17947 > name_width_17945 ))" != 0 ]; then
            name_width_17945="${width_17947}"
        fi
done
    term_width__1387_v0 
    local width_17953="${ret_term_width1387_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_17954="$(( name_width_17945 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_17955="$(( $(( width_17953 - indent_17954 )) < 24 ))"
    if [ "${stacked_17955}" != 0 ]; then
        indent_17954=6
    fi
    local avail_17956="$(( width_17953 - indent_17954 ))"
    rpad__28_v0 "" " " "${indent_17954}"
    local blank_17957="${ret_rpad28_v0}"
    local __range_start_17958=0
    local __range_end_17958="${count_17944}"
    local __dir_17958=$(( ${__range_start_17958} <= ${__range_end_17958} ? 1 : -1 ))
    for (( i_17958=${__range_start_17958}; i_17958 * ${__dir_17958} < ${__range_end_17958} * ${__dir_17958}; i_17958+=${__dir_17958} )); do
        local pending_17959="${blank_17957}"
        if [ "${stacked_17955}" != 0 ]; then
            local array_261=()
            printf__128_v0 "  ""${names_17940[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_261[@]
        else
            rpad__28_v0 "  ""${names_17940[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_17954}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_17959="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_17941[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_17960=("${ret_split4_v0__52_21[@]}")
        local __length_262=("${words_17960[@]}")
        local note_start_17961="${#__length_262[@]}"
        if [ "$([ "_${notes_17942[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_263="${notes_17942[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_263} > avail_17956 ))" != 0 ]; then
                split__4_v0 "${notes_17942[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_17960+=("${ret_split4_v0__58_26[@]}")
            else
                local array_264=("${notes_17942[${i_17958}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_17960+=("${array_264[@]}")
            fi
        fi
        local line_17962=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_17963=-1
        local __range_start_17964=0
        local __length_265=("${words_17960[@]}")
        local __range_end_17964="${#__length_265[@]}"
        local __dir_17964=$(( ${__range_start_17964} <= ${__range_end_17964} ? 1 : -1 ))
        for (( j_17964=${__range_start_17964}; j_17964 * ${__dir_17964} < ${__range_end_17964} * ${__dir_17964}; j_17964+=${__dir_17964} )); do
            local word_17965="${words_17960[${j_17964}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_17966
            candidate_17966="$(if [ "$([ "_${line_17962}" != "_" ]; echo $?)" != 0 ]; then echo "${word_17965}"; else echo "${line_17962}"" ""${word_17965}"; fi)"
            local __length_266="${candidate_17966}"
            if [ "$(( $(( ${#__length_266} > avail_17956 )) && $([ "_${line_17962}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1420_v0 "${pending_17959}" "${line_17962}" "${note_at_17963}"
                pending_17959="${blank_17957}"
                line_17962="${word_17965}"
                note_at_17963="$(if [ "$(( j_17964 >= note_start_17961 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_17964 >= note_start_17961 )) && $(( note_at_17963 < 0 )) ))" != 0 ]; then
                    local __length_267="${candidate_17966}"
                    local __length_268="${word_17965}"
                    note_at_17963="$(( ${#__length_267} - ${#__length_268} ))"
                fi
                line_17962="${candidate_17966}"
            fi
done
        print_help_line__1420_v0 "${pending_17959}" "${line_17962}" "${note_at_17963}"
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
render_single_page__1583_v0() {
    local __length_270="${_cursor_76}"
    local cursor_len_18084="${#__length_270}"
    local max_option_width_18085="$(( $(( _term_width_79 - cursor_len_18084 )) - 1 ))"
    local __range_start_18086=0
    local __range_end_18086="${_page_count_82}"
    local __dir_18086=$(( ${__range_start_18086} <= ${__range_end_18086} ? 1 : -1 ))
    for (( i_18086=${__range_start_18086}; i_18086 * ${__dir_18086} < ${__range_end_18086} * ${__dir_18086}; i_18086+=${__dir_18086} )); do
        cutoff_text__1318_v0 "${_page_81[${i_18086}]?"Index out of bounds (at src/./choose/./engine.ab:45:45)"}" "${max_option_width_18085}"
        local ret_cutoff_text1318_v0__45_27="${ret_cutoff_text1318_v0}"
        local truncated_18087="${ret_cutoff_text1318_v0__45_27}"
        if [ "$(( i_18086 == _selected_75 ))" != 0 ]; then
            colored_secondary__1287_v0 "${_cursor_76}""${truncated_18087}""
"
            local ret_colored_secondary1287_v0__47_21="${ret_colored_secondary1287_v0}"
            local array_271=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__47_21}" array_271[@]
        else
            print_blank__1237_v0 "${cursor_len_18084}"
            local array_272=("")
            eprintf__1184_v0 "${truncated_18087}""
" array_272[@]
        fi
done
    local remaining_slots_18088="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18088 > 0 ))" != 0 ]; then
        local __range_start_18089=0
        local __range_end_18089="${remaining_slots_18088}"
        local __dir_18089=$(( ${__range_start_18089} <= ${__range_end_18089} ? 1 : -1 ))
        for (( ____18089=${__range_start_18089}; ____18089 * ${__dir_18089} < ${__range_end_18089} * ${__dir_18089}; ____18089+=${__dir_18089} )); do
            local array_273=("")
            eprintf__1184_v0 "\\x1b[K
" array_273[@]
done
    fi
}

# render_multi_page()
render_multi_page__1584_v0() {
    local __length_274="${_cursor_76}"
    local cursor_len_18073="${#__length_274}"
    local max_option_width_18074="$(( $(( _term_width_79 - cursor_len_18073 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1589_v0 
    local page_start_18075="${ret_chooser_page_start1589_v0}"
    local __range_start_18076=0
    local __range_end_18076="${_page_count_82}"
    local __dir_18076=$(( ${__range_start_18076} <= ${__range_end_18076} ? 1 : -1 ))
    for (( i_18076=${__range_start_18076}; i_18076 * ${__dir_18076} < ${__range_end_18076} * ${__dir_18076}; i_18076+=${__dir_18076} )); do
        local global_idx_18077="$(( page_start_18075 + i_18076 ))"
        checked_is__1405_v0 "${global_idx_18077}"
        local ret_checked_is1405_v0__67_28="${ret_checked_is1405_v0}"
        local check_mark_18079
        check_mark_18079="$(if [ "${ret_checked_is1405_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1318_v0 "${_page_81[${i_18076}]?"Index out of bounds (at src/./choose/./engine.ab:68:45)"}" "${max_option_width_18074}"
        local ret_cutoff_text1318_v0__68_27="${ret_cutoff_text1318_v0}"
        local truncated_18080="${ret_cutoff_text1318_v0__68_27}"
        checked_is__1405_v0 "${global_idx_18077}"
        local ret_checked_is1405_v0__71_13="${ret_checked_is1405_v0}"
        if [ "$(( i_18076 == _selected_75 ))" != 0 ]; then
            colored_secondary__1287_v0 "${_cursor_76}""${check_mark_18079}""${truncated_18080}""
"
            local ret_colored_secondary1287_v0__70_37="${ret_colored_secondary1287_v0}"
            local array_275=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__70_37}" array_275[@]
        elif [ "${ret_checked_is1405_v0__71_13}" != 0 ]; then
            print_blank__1237_v0 "${cursor_len_18073}"
            colored_secondary__1287_v0 "${check_mark_18079}""${truncated_18080}""
"
            local ret_colored_secondary1287_v0__73_25="${ret_colored_secondary1287_v0}"
            local array_276=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__73_25}" array_276[@]
        else
            print_blank__1237_v0 "${cursor_len_18073}"
            local array_277=("")
            eprintf__1184_v0 "${check_mark_18079}""${truncated_18080}""
" array_277[@]
        fi
done
    local remaining_slots_18082="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18082 > 0 ))" != 0 ]; then
        local __range_start_18083=0
        local __range_end_18083="${remaining_slots_18082}"
        local __dir_18083=$(( ${__range_start_18083} <= ${__range_end_18083} ? 1 : -1 ))
        for (( ____18083=${__range_start_18083}; ____18083 * ${__dir_18083} < ${__range_end_18083} * ${__dir_18083}; ____18083+=${__dir_18083} )); do
            local array_278=("")
            eprintf__1184_v0 "\\x1b[K
" array_278[@]
done
    fi
}

# render_page()
render_page__1585_v0() {
    if [ "${_multi_77}" != 0 ]; then
        render_multi_page__1584_v0 
    else
        render_single_page__1583_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1586_v0() {
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        local array_279=("")
        eprintf__1184_v0 "\\x1b[G\\x1b[K" array_279[@]
        eprintf_colored__1185_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
        local array_280=("")
        eprintf__1184_v0 "\\x1b[G" array_280[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1587_v0() {
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_281=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1345_v0 array_281[@] 36 "${_term_width_79}"
        else
            local array_282=("↑↓" "select" "enter" "confirm")
            render_tooltip__1345_v0 array_282[@] 25 "${_term_width_79}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_73 > 1 )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
            local array_283=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1345_v0 array_283[@] 55 "${_term_width_79}"
        elif [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_284=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1345_v0 array_284[@] 47 "${_term_width_79}"
        elif [ "$(( _limit_78 < 0 ))" != 0 ]; then
            local array_285=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1345_v0 array_285[@] 44 "${_term_width_79}"
        else
            local array_286=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1345_v0 array_286[@] 36 "${_term_width_79}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1588_v0() {
    local total_17991="${1}"
    local page_size_17992="${2}"
    local header_17993="${3}"
    local cursor_17994="${4}"
    local multi_17995="${5}"
    local limit_17996="${6}"
    _total_70="${total_17991}"
    _cursor_76="${cursor_17994}"
    _multi_77="${multi_17995}"
    _limit_78="${limit_17996}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_17993}" == "_" ]; echo $?)"
    stty_lock__1225_v0 
    hide_cursor__1242_v0 
    term_width__1232_v0 
    _term_width_79="${ret_term_width1232_v0}"
    term_height__1233_v0 
    local term_height_18001="${ret_term_height1233_v0}"
    local max_page_size_18002
    max_page_size_18002="$(( term_height_18001 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_17992}"
    if [ "$(( _page_size_71 > max_page_size_18002 ))" != 0 ]; then
        _page_size_71="${max_page_size_18002}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1318_v0 "${header_17993}" "${_term_width_79}"
        local ret_cutoff_text1318_v0__153_17="${ret_cutoff_text1318_v0}"
        local array_287=("")
        eprintf__1184_v0 "${ret_cutoff_text1318_v0__153_17}""
" array_287[@]
    fi
    math_floor__636_v0 "$(( $(( $(( total_17991 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _total_pages_73="${ret_math_floor636_v0}"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_17991 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_17991}"
    fi
    if [ "${multi_17995}" != 0 ]; then
        checked_init__1404_v0 "${total_17991}" "${limit_17996}"
    fi
    new_line__1238_v0 "${_display_count_72}"
    local array_288=("")
    eprintf__1184_v0 "\\x1b[G" array_288[@]
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        eprintf_colored__1185_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
    fi
    new_line__1238_v0 1
    render_tooltip_line__1587_v0 
    go_up__1239_v0 "$(( _display_count_72 + 1 ))"
    local array_289=("")
    eprintf__1184_v0 "\\x1b[G" array_289[@]
}

# chooser_page_start()
chooser_page_start__1589_v0() {
    ret_chooser_page_start1589_v0="$(( _current_page_74 * _page_size_71 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1590_v0() {
    chooser_page_start__1589_v0 
    local start_18068="${ret_chooser_page_start1589_v0}"
    local end_18069="$(( start_18068 + _page_size_71 ))"
    if [ "$(( end_18069 > _total_70 ))" != 0 ]; then
        end_18069="${_total_70}"
    fi
    ret_chooser_page_count1590_v0="$(( end_18069 - start_18068 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1591_v0() {
    local page_18072=("${!1}")
    _page_81=("${page_18072[@]}")
    local __length_290=("${page_18072[@]}")
    _page_count_82="${#__length_290[@]}"
    if [ "${_first_render_83}" != 0 ]; then
        _first_render_83=0
        render_page__1585_v0 
    else
        if [ "${_up_paged_84}" != 0 ]; then
            _selected_75="$(( _page_count_82 - 1 ))"
            _up_paged_84=0
        fi
        go_up__1239_v0 1
        remove_line__1235_v0 "$(( _display_count_72 - 1 ))"
        remove_current_line__1236_v0 
        local array_291=("")
        eprintf__1184_v0 "\\x1b[G" array_291[@]
        render_page__1585_v0 
        render_page_indicator__1586_v0 
    fi
}

# option_width()
option_width__1592_v0() {
    local check_width_18099
    check_width_18099="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_292="${_cursor_76}"
    ret_option_width1592_v0="$(( $(( _term_width_79 - ${#__length_292} )) - check_width_18099 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1593_v0() {
    local index_18112="${1}"
    local __length_293="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_293}"
    local blank_18113="${ret_rpad28_v0}"
    option_width__1592_v0 
    local ret_option_width1592_v0__224_49="${ret_option_width1592_v0}"
    cutoff_text__1318_v0 "${_page_81[${index_18112}]?"Index out of bounds (at src/./choose/./engine.ab:224:41)"}" "${ret_option_width1592_v0__224_49}"
    local truncated_18114="${ret_cutoff_text1318_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1593_v0="${blank_18113}""${truncated_18114}"
        return 0
    fi
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__228_19="${ret_chooser_page_start1589_v0}"
    checked_is__1405_v0 "$(( ret_chooser_page_start1589_v0__228_19 + index_18112 ))"
    local ret_checked_is1405_v0__228_8="${ret_checked_is1405_v0}"
    if [ "${ret_checked_is1405_v0__228_8}" != 0 ]; then
        colored_secondary__1287_v0 "✓ ""${truncated_18114}"
        local ret_colored_secondary1287_v0__229_24="${ret_colored_secondary1287_v0}"
        ret_unselected_line1593_v0="${blank_18113}""${ret_colored_secondary1287_v0__229_24}"
        return 0
    fi
    ret_unselected_line1593_v0="${blank_18113}""• ""${truncated_18114}"
    return 0
}

# selected_line(index: Int)
selected_line__1594_v0() {
    local index_18098="${1}"
    option_width__1592_v0 
    local ret_option_width1592_v0__236_49="${ret_option_width1592_v0}"
    cutoff_text__1318_v0 "${_page_81[${index_18098}]?"Index out of bounds (at src/./choose/./engine.ab:236:41)"}" "${ret_option_width1592_v0__236_49}"
    local truncated_18100="${ret_cutoff_text1318_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1287_v0 "${_cursor_76}""${truncated_18100}"
        ret_selected_line1594_v0="${ret_colored_secondary1287_v0}"
        return 0
    fi
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__240_29="${ret_chooser_page_start1589_v0}"
    checked_is__1405_v0 "$(( ret_chooser_page_start1589_v0__240_29 + index_18098 ))"
    local ret_checked_is1405_v0__240_18="${ret_checked_is1405_v0}"
    local mark_18101
    mark_18101="$(if [ "${ret_checked_is1405_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1287_v0 "${_cursor_76}""${mark_18101}""${truncated_18100}"
    ret_selected_line1594_v0="${ret_colored_secondary1287_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1595_v0() {
    local prev_selected_18111="${1}"
    unselected_line__1593_v0 "${prev_selected_18111}"
    local ret_unselected_line1593_v0__247_47="${ret_unselected_line1593_v0}"
    redraw_row__1402_v0 "${_display_count_72}" "${prev_selected_18111}" "${ret_unselected_line1593_v0__247_47}"
    selected_line__1594_v0 "${_selected_75}"
    local ret_selected_line1594_v0__248_43="${ret_selected_line1594_v0}"
    redraw_row__1402_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1594_v0__248_43}"
}

# redraw_current_line()
redraw_current_line__1596_v0() {
    selected_line__1594_v0 "${_selected_75}"
    local ret_selected_line1594_v0__253_43="${ret_selected_line1594_v0}"
    redraw_row__1402_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1594_v0__253_43}"
}

# chooser_step()
chooser_step__1597_v0() {
    get_key__1182_v0 
    local key_18093="${ret_get_key1182_v0}"
    local prev_selected_18094="${_selected_75}"
    local prev_page_18095="${_current_page_74}"
    chooser_page_start__1589_v0 
    local page_start_18096="${ret_chooser_page_start1589_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_18093}" != "_UP" ]; echo $?) || $([ "_${key_18093}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18093}" != "_DOWN" ]; echo $?) || $([ "_${key_18093}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18093}" != "_LEFT" ]; echo $?) || $([ "_${key_18093}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_18093}" != "_RIGHT" ]; echo $?) || $([ "_${key_18093}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $(( $([ "_${key_18093}" != "_x" ]; echo $?) || $([ "_${key_18093}" != "_X" ]; echo $?) )) || $([ "_${key_18093}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1407_v0 "$(( page_start_18096 + _selected_75 ))"
        local ret_checked_toggle1407_v0__310_16="${ret_checked_toggle1407_v0}"
        if [ "${ret_checked_toggle1407_v0__310_16}" != 0 ]; then
            redraw_current_line__1596_v0 
        fi
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $(( $([ "_${key_18093}" != "_a" ]; echo $?) || $([ "_${key_18093}" != "_A" ]; echo $?) )) || $([ "_${key_18093}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
        checked_all__1408_v0 
        local ret_checked_all1408_v0__316_16="${ret_checked_all1408_v0}"
        if [ "${ret_checked_all1408_v0__316_16}" != 0 ]; then
            go_up__1239_v0 "${_display_count_72}"
            local array_294=("")
            eprintf__1184_v0 "\\x1b[G" array_294[@]
            render_page__1585_v0 
        fi
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $([ "_${key_18093}" != "_INPUT" ]; echo $?) || $([ "_${key_18093}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step1597_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_18095 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1597_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_18094 != _selected_75 ))" != 0 ]; then
        redraw_selection__1595_v0 "${prev_selected_18094}"
    fi
    ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
    return 0
}

# chooser_selected()
chooser_selected__1598_v0() {
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__340_12="${ret_chooser_page_start1589_v0}"
    ret_chooser_selected1598_v0="$(( ret_chooser_page_start1589_v0__340_12 + _selected_75 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1599_v0() {
    local index_18121="${1}"
    checked_is__1405_v0 "${index_18121}"
    ret_chooser_is_checked1599_v0="${ret_checked_is1405_v0}"
    return 0
}

# chooser_end()
chooser_end__1600_v0() {
    local total_lines_18116="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_18116="$(( total_lines_18116 + 1 ))"
    fi
    go_down__1240_v0 1
    remove_line__1235_v0 "$(( total_lines_18116 - 1 ))"
    remove_current_line__1236_v0 
    stty_unlock__1226_v0 
    show_cursor__1243_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1609_v0() {
    local options_18125=("${!1}")
    local cursor_18126="${2}"
    local header_18127="${3}"
    local page_size_18128="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_295=("${options_18125[@]}")
    local total_18129="${#__length_295[@]}"
    if [ "$(( total_18129 == 0 ))" != 0 ]; then
        eprintf_colored__1185_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1588_v0 "${total_18129}" "${page_size_18128}" "${header_18127}" "${cursor_18126}" 0 -1
    local need_page_18130=1
    while :
    do
        if [ "${need_page_18130}" != 0 ]; then
            local page_18131=()
            chooser_page_start__1589_v0 
            local start_18132="${ret_chooser_page_start1589_v0}"
            chooser_page_count__1590_v0 
            local count_18133="${ret_chooser_page_count1590_v0}"
            local __range_start_18134="${start_18132}"
            local __range_end_18134="$(( start_18132 + count_18133 ))"
            local __dir_18134=$(( ${__range_start_18134} <= ${__range_end_18134} ? 1 : -1 ))
            for (( i_18134=${__range_start_18134}; i_18134 * ${__dir_18134} < ${__range_end_18134} * ${__dir_18134}; i_18134+=${__dir_18134} )); do
                local array_297=("${options_18125[${i_18134}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_18131+=("${array_297[@]}")
done
            chooser_set_page__1591_v0 page_18131[@]
        fi
        chooser_step__1597_v0 
        local step_18135="${ret_chooser_step1597_v0}"
        if [ "$(( step_18135 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18130="$(( step_18135 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1598_v0 
    local selected_18136="${ret_chooser_selected1598_v0}"
    chooser_end__1600_v0 
    ret_xyl_choose1609_v0="${options_18125[${selected_18136}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1610_v0() {
    local options_17985=("${!1}")
    local cursor_17986="${2}"
    local header_17987="${3}"
    local limit_17988="${4}"
    local page_size_17989="${5}"
    local __length_298=("${options_17985[@]}")
    local total_17990="${#__length_298[@]}"
    if [ "$(( total_17990 == 0 ))" != 0 ]; then
        eprintf_colored__1185_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1610_v0=()
        return 0
    fi
    chooser_begin__1588_v0 "${total_17990}" "${page_size_17989}" "${header_17987}" "${cursor_17986}" 1 "${limit_17988}"
    local need_page_18065=1
    while :
    do
        if [ "${need_page_18065}" != 0 ]; then
            local page_18066=()
            chooser_page_start__1589_v0 
            local start_18067="${ret_chooser_page_start1589_v0}"
            chooser_page_count__1590_v0 
            local count_18070="${ret_chooser_page_count1590_v0}"
            local __range_start_18071="${start_18067}"
            local __range_end_18071="$(( start_18067 + count_18070 ))"
            local __dir_18071=$(( ${__range_start_18071} <= ${__range_end_18071} ? 1 : -1 ))
            for (( i_18071=${__range_start_18071}; i_18071 * ${__dir_18071} < ${__range_end_18071} * ${__dir_18071}; i_18071+=${__dir_18071} )); do
                local array_301=("${options_17985[${i_18071}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_18066+=("${array_301[@]}")
done
            chooser_set_page__1591_v0 page_18066[@]
        fi
        chooser_step__1597_v0 
        local step_18115="${ret_chooser_step1597_v0}"
        if [ "$(( step_18115 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18065="$(( step_18115 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1600_v0 
    local result_18119=()
    local __range_start_18120=0
    local __range_end_18120="${total_17990}"
    local __dir_18120=$(( ${__range_start_18120} <= ${__range_end_18120} ? 1 : -1 ))
    for (( i_18120=${__range_start_18120}; i_18120 * ${__dir_18120} < ${__range_end_18120} * ${__dir_18120}; i_18120+=${__dir_18120} )); do
        chooser_is_checked__1599_v0 "${i_18120}"
        local ret_chooser_is_checked1599_v0__93_12="${ret_chooser_is_checked1599_v0}"
        if [ "${ret_chooser_is_checked1599_v0__93_12}" != 0 ]; then
            local array_303=("${options_17985[${i_18120}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_18119+=("${array_303[@]}")
        fi
done
    ret_xyl_multi_choose1610_v0=("${result_18119[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1711_v0() {
    local usage_17908=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1244_v0 usage_17908[@]
    printf '%s\n' ""
    colored_primary__1286_v0 "choose"
    local ret_colored_primary1286_v0__8_20="${ret_colored_primary1286_v0}"
    local title_17935=("${ret_colored_primary1286_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1244_v0 title_17935[@]
    printf '%s\n' ""
    colored_secondary__1287_v0 "Arguments:"
    local ret_colored_secondary1287_v0__11_12="${ret_colored_secondary1287_v0}"
    local array_306=()
    printf__128_v0 "${ret_colored_secondary1287_v0__11_12}""
" array_306[@]
    local arg_names_17937=("[<options> ...]")
    local arg_texts_17938=("List of options to choose from")
    local arg_notes_17939=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1421_v0 arg_names_17937[@] arg_texts_17938[@] arg_notes_17939[@] 20
    printf '%s\n' ""
    colored_secondary__1287_v0 "Flags:"
    local ret_colored_secondary1287_v0__18_12="${ret_colored_secondary1287_v0}"
    local array_310=()
    printf__128_v0 "${ret_colored_secondary1287_v0__18_12}""
" array_310[@]
    local names_17972=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_17973=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_17974=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1421_v0 names_17972[@] texts_17973[@] notes_17974[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1769_v0() {
    local options_17901=()
    local command_315
    command_315="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_17902="${command_315}"
    if [ "$([ "_${is_tty_17902}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_17901+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1769_v0=("${options_17901[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1770_v0() {
    local parameters_17885=("${!1}")
    local cursor_17886="> "
    colored_primary__1286_v0 "Choose: "
    local ret_colored_primary1286_v0__17_30="${ret_colored_primary1286_v0}"
    local header_17900="\\x1b[1m""${ret_colored_primary1286_v0__17_30}"
    read_stdin_options__1769_v0 
    local options_17903=("${ret_read_stdin_options1769_v0[@]}")
    local multi_17904=0
    local limit_17905=-1
    local page_size_17906=10
    local __length_319=("${parameters_17885[@]}")
    local slice_upper_318="${#__length_319[@]}"
    local slice_offset_320=2
    local slice_offset_320=$((${slice_offset_320} > 0 ? ${slice_offset_320} : 0))
    local slice_length_321="$(( slice_upper_318 - slice_offset_320 ))"
    local slice_length_321=$((${slice_length_321} > 0 ? ${slice_length_321} : 0))
    for param_17907 in "${parameters_17885[@]:${slice_offset_320}:${slice_length_321}}"; do
        starts_with__22_v0 "${param_17907}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17907}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17907}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17907}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_17907}" != "_-h" ]; echo $?) || $([ "_${param_17907}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1711_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_322="--cursor="
            slice__24_v0 "${param_17907}" "${#__length_322}" 0
            cursor_17886="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_323="--header="
            slice__24_v0 "${param_17907}" "${#__length_323}" 0
            header_17900="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_324="--limit="
            slice__24_v0 "${param_17907}" "${#__length_324}" 0
            local value_17975="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17975}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1185_v0 "ERROR: Invalid limit value: ""${value_17975}""
" 31
                exit 1
            fi
            limit_17905="${ret_parse_int13_v0}"
            multi_17904=1
        elif [ "$([ "_${param_17907}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_17904=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_325="--page-size="
            slice__24_v0 "${param_17907}" "${#__length_325}" 0
            local value_17980="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17980}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1185_v0 "ERROR: Invalid page-size value: ""${value_17980}""
" 31
                exit 1
            fi
            page_size_17906="${ret_parse_int13_v0}"
        else
            options_17903+=("${param_17907}")
        fi
    done
    has_ansi_escape__1310_v0 "${header_17900}"
    local ret_has_ansi_escape1310_v0__59_44="${ret_has_ansi_escape1310_v0}"
    escape_ansi__1311_v0 "${header_17900}"
    local ret_escape_ansi1311_v0__59_73="${ret_escape_ansi1311_v0}"
    colored_primary__1286_v0 "${header_17900}"
    local ret_colored_primary1286_v0__59_111="${ret_colored_primary1286_v0}"
    local display_header_17984
    display_header_17984="$(if [ "$(( $([ "_${header_17900}" != "_" ]; echo $?) || ret_has_ansi_escape1310_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1311_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1286_v0__59_111}"; fi)"
    if [ "${multi_17904}" != 0 ]; then
        xyl_multi_choose__1610_v0 options_17903[@] "${cursor_17886}" "${display_header_17984}" "${limit_17905}" "${page_size_17906}"
        local results_18122=("${ret_xyl_multi_choose1610_v0[@]}")
        join__7_v0 results_18122[@] "
"
        ret_execute_choose1770_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1609_v0 options_17903[@] "${cursor_17886}" "${display_header_17984}" "${page_size_17906}"
    ret_execute_choose1770_v0="${ret_xyl_choose1609_v0}"
    return 0
}

# get_key()
get_key__1855_v0() {
    local command_327
    command_327="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1855_v0="${command_327}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1857_v0() {
    local format_27428="${1}"
    local args_27429=("${!2}")
    args_27429=("${format_27428}" "${args_27429[@]}")
    __status=$?
    printf "${args_27429[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1858_v0() {
    local message_27426="${1}"
    local color_27427="${2}"
    # Prints an error message with a specified color.
    local array_328=("${message_27426}")
    eprintf__1857_v0 "\\x1b[${color_27427}m%s\\x1b[0m" array_328[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1873_v0() {
    local format_27446="${1}"
    local args_27447=("${!2}")
    args_27447=("${format_27446}" "${args_27447[@]}")
    __status=$?
    printf "${args_27447[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_90="None"
# perl_available()
perl_available__1880_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_329
        command_329="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27371
        disabled_27371="$([ "_${command_329}" != "_No" ]; echo $?)"
        local command_330
        command_330="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27372
        found_27372="$(( $(( ! disabled_27371 )) && $([ "_${command_330}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_27372}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1880_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1881_v0() {
    local text_27370="${1}"
    perl_available__1880_v0 
    local ret_perl_available1880_v0__19_12="${ret_perl_available1880_v0}"
    if [ "$(( ! ret_perl_available1880_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return 1
    fi
    local command_331
    command_331="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27370}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return "${__status}"
    fi
    local width_str_27373="${command_331}"
    parse_int__13_v0 "${width_str_27373}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return "${__status}"
    fi
    local width_27374="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1881_v0="${width_27374}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1886_v0() {
    local text_27360="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_332
    command_332="$([[ "${text_27360}" == *$'\x1b'* || "${text_27360}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27361="${command_332}"
    ret_has_ansi_escape1886_v0="$([ "_${has_escape_27361}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1888_v0() {
    local text_27366="${1}"
    local command_333
    command_333="$(printf "%s" "${text_27366}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1888_v0="${command_333}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1889_v0() {
    local text_27368="${1}"
    local command_334
    command_334="$(printf "%s" "${text_27368}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27369="${command_334}"
    ret_is_all_ascii1889_v0="$([ "_${result_27369}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1890_v0() {
    local text_27363="${1}"
    local command_335
    command_335="$(LC_ALL=C; __t="${text_27363}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27364="${command_335}"
    parse_int__13_v0 "${measured_27364}"
    __status=$?
    ret_plain_len1890_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1891_v0() {
    local text_27362="${1}"
    plain_len__1890_v0 "${text_27362}"
    local plain_27365="${ret_plain_len1890_v0}"
    if [ "$(( plain_27365 >= 0 ))" != 0 ]; then
        ret_get_visible_len1891_v0="${plain_27365}"
        return 0
    fi
    strip_ansi__1888_v0 "${text_27362}"
    local stripped_27367="${ret_strip_ansi1888_v0}"
    is_all_ascii__1889_v0 "${stripped_27367}"
    local ret_is_all_ascii1889_v0__46_12="${ret_is_all_ascii1889_v0}"
    if [ "$(( ! ret_is_all_ascii1889_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1881_v0 "${stripped_27367}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_336="${stripped_27367}"
            ret_get_visible_len1891_v0="${#__length_336}"
            return 0
        fi
        ret_get_visible_len1891_v0="${ret_perl_get_cjk_width1881_v0}"
        return 0
    fi
    local __length_337="${stripped_27367}"
    ret_get_visible_len1891_v0="${#__length_337}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_91=0
_term_size_92=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1897_v0() {
    local command_339
    command_339="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27444="${command_339}"
    parse_int__13_v0 "${count_27444}"
    __status=$?
    ret_stty_count1897_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1898_v0() {
    stty_count__1897_v0 
    local count_num_27445="${ret_stty_count1897_v0}"
    if [ "$(( count_num_27445 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_27445="$(( count_num_27445 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27445}
    __status=$?
}

# stty_unlock()
stty_unlock__1899_v0() {
    stty_count__1897_v0 
    local count_num_27546="${ret_stty_count1897_v0}"
    if [ "$(( count_num_27546 > 0 ))" != 0 ]; then
        count_num_27546="$(( count_num_27546 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27546}
        __status=$?
        if [ "$(( count_num_27546 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1900_v0() {
    local size_27351="${1}"
    if [ "$([ "_${size_27351}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1900_v0=0
        return 0
    fi
    split__4_v0 "${size_27351}" " "
    local parts_27352=("${ret_split4_v0[@]}")
    local __length_340=("${parts_27352[@]}")
    if [ "$(( ${#__length_340[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1900_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27352[1]?"Index out of bounds (at src/./filter/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27352[0]?"Index out of bounds (at src/./filter/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_92=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1900_v0=1
    return 0
}

# query_term_size()
query_term_size__1901_v0() {
    local command_342
    command_342="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27354="${command_342}"
    store_term_size__1900_v0 "${size_27354}"
    ret_query_term_size1901_v0="${ret_store_term_size1900_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1902_v0() {
    local command_343
    command_343="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27350="${command_343}"
    store_term_size__1900_v0 "${size_27350}"
    ret_stty_term_size1902_v0="${ret_store_term_size1900_v0}"
    return 0
}

# get_term_size()
get_term_size__1903_v0() {
    stty_term_size__1902_v0 
    local detected_27353="${ret_stty_term_size1902_v0}"
    if [ "$(( ! detected_27353 ))" != 0 ]; then
        query_term_size__1901_v0 
        detected_27353="${ret_query_term_size1901_v0}"
    fi
    _got_term_size_91=1
}

# term_width()
term_width__1905_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1903_v0 
    fi
    ret_term_width1905_v0="${_term_size_92[0]?"Index out of bounds (at src/./filter/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1906_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1903_v0 
    fi
    ret_term_height1906_v0="${_term_size_92[1]?"Index out of bounds (at src/./filter/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1908_v0() {
    local cnt_27543="${1}"
    if [ "$(( cnt_27543 > 0 ))" != 0 ]; then
        local sequence_27544=""
        local __range_start_27545=0
        local __range_end_27545="${cnt_27543}"
        local __dir_27545=$(( ${__range_start_27545} <= ${__range_end_27545} ? 1 : -1 ))
        for (( ____27545=${__range_start_27545}; ____27545 * ${__dir_27545} < ${__range_end_27545} * ${__dir_27545}; ____27545+=${__dir_27545} )); do
            sequence_27544+="\\x1b[2K\\x1b[1A"
done
        local array_344=("")
        eprintf__1873_v0 "${sequence_27544}" array_344[@]
    fi
    local array_345=("")
    eprintf__1873_v0 "\\x1b[G" array_345[@]
}

# remove_current_line()
remove_current_line__1909_v0() {
    local array_346=("")
    eprintf__1873_v0 "\\x1b[2K\\x1b[G" array_346[@]
}

# new_line(cnt: Int)
new_line__1911_v0() {
    local cnt_27492="${1}"
    local __range_start_27493=0
    local __range_end_27493="${cnt_27492}"
    local __dir_27493=$(( ${__range_start_27493} <= ${__range_end_27493} ? 1 : -1 ))
    for (( ____27493=${__range_start_27493}; ____27493 * ${__dir_27493} < ${__range_end_27493} * ${__dir_27493}; ____27493+=${__dir_27493} )); do
        local array_347=("")
        eprintf__1873_v0 "
" array_347[@]
done
}

# go_up(cnt: Int)
go_up__1912_v0() {
    local cnt_27511="${1}"
    local array_348=("")
    eprintf__1873_v0 "\\x1b[${cnt_27511}A" array_348[@]
}

# go_down(cnt: Int)
go_down__1913_v0() {
    local cnt_27525="${1}"
    local array_349=("")
    eprintf__1873_v0 "\\x1b[${cnt_27525}B" array_349[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1915_v0() {
    local array_350=("")
    eprintf__1873_v0 "\\x1b[?25l" array_350[@]
}

# show_cursor()
show_cursor__1916_v0() {
    local array_351=("")
    eprintf__1873_v0 "\\x1b[?25h" array_351[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1917_v0() {
    local pieces_27349=("${!1}")
    term_width__1905_v0 
    local width_27355="${ret_term_width1905_v0}"
    local line_27356=""
    local line_len_27357=0
    for piece_27358 in "${pieces_27349[@]}"; do
        local __length_354="${piece_27358}"
        local piece_len_27359="${#__length_354}"
        has_ansi_escape__1886_v0 "${piece_27358}"
        local ret_has_ansi_escape1886_v0__186_12="${ret_has_ansi_escape1886_v0}"
        if [ "${ret_has_ansi_escape1886_v0__186_12}" != 0 ]; then
            get_visible_len__1891_v0 "${piece_27358}"
            piece_len_27359="${ret_get_visible_len1891_v0}"
        fi
        if [ "$([ "_${line_27356}" != "_" ]; echo $?)" != 0 ]; then
            line_27356="${piece_27358}"
            line_len_27357="${piece_len_27359}"
        elif [ "$(( $(( $(( line_len_27357 + 1 )) + piece_len_27359 )) > width_27355 ))" != 0 ]; then
            local array_355=()
            printf__128_v0 "${line_27356}""
" array_355[@]
            line_27356="${piece_27358}"
            line_len_27357="${piece_len_27359}"
        else
            line_27356+=" ""${piece_27358}"
            line_len_27357="$(( line_len_27357 + $(( 1 + piece_len_27359 )) ))"
        fi
    done
    if [ "$([ "_${line_27356}" == "_" ]; echo $?)" != 0 ]; then
        local array_356=()
        printf__128_v0 "${line_27356}""
" array_356[@]
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
get_supports_truecolor__1954_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_27387="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_27387}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1954_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1955_v0() {
    local message_27382="${1}"
    local r_27383="${2}"
    local g_27384="${3}"
    local b_27385="${4}"
    local fallback_27386="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1955_v0="\\x1b[38;2;${r_27383};${g_27384};${b_27385}m""${message_27382}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1954_v0 
        local ret_get_supports_truecolor1954_v0__45_17="${ret_get_supports_truecolor1954_v0}"
        if [ "${ret_get_supports_truecolor1954_v0__45_17}" != 0 ]; then
            ret_colored_rgb1955_v0="\\x1b[38;2;${r_27383};${g_27384};${b_27385}m""${message_27382}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27386 == 0 ))" != 0 ]; then
            ret_colored_rgb1955_v0="${message_27382}"
            return 0
        else
            ret_colored_rgb1955_v0="\\x1b[${fallback_27386}m""${message_27382}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27386 == 0 ))" != 0 ]; then
            ret_colored_rgb1955_v0="${message_27382}"
            return 0
        fi
        ret_colored_rgb1955_v0="\\x1b[${fallback_27386}m""${message_27382}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1957_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27376="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27376}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27376}" ";"
            local parts_27377=("${ret_split4_v0[@]}")
            local __length_360=("${parts_27377[@]}")
            if [ "$(( ${#__length_360[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27377[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27377[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27377[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27377[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_97=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_27378="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27378}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27378}" ";"
            local parts_27379=("${ret_split4_v0[@]}")
            local __length_362=("${parts_27379[@]}")
            if [ "$(( ${#__length_362[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27379[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_98=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_27380="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27380}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27380}" ";"
            local parts_27381=("${ret_split4_v0[@]}")
            local __length_364=("${parts_27381[@]}")
            if [ "$(( ${#__length_364[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27381[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27381[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27381[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27381[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_96=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1958_v0() {
    inner_get_xylitol_colors__1957_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_96=1
}

# colored_primary(message: Text)
colored_primary__1959_v0() {
    local message_27375="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1958_v0 
    fi
    colored_rgb__1955_v0 "${message_27375}" "${_primary_color_97[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1959_v0="${ret_colored_rgb1955_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1960_v0() {
    local message_27389="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1958_v0 
    fi
    colored_rgb__1955_v0 "${message_27389}" "${_secondary_color_98[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1960_v0="${ret_colored_rgb1955_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_100="None"
# perl_available()
perl_available__1977_v0() {
    if [ "$([ "_${_perl_state_100}" != "_None" ]; echo $?)" != 0 ]; then
        local command_366
        command_366="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27464
        disabled_27464="$([ "_${command_366}" != "_No" ]; echo $?)"
        local command_367
        command_367="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27465
        found_27465="$(( $(( ! disabled_27464 )) && $([ "_${command_367}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_27465}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1977_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1978_v0() {
    local text_27463="${1}"
    perl_available__1977_v0 
    local ret_perl_available1977_v0__19_12="${ret_perl_available1977_v0}"
    if [ "$(( ! ret_perl_available1977_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return 1
    fi
    local command_368
    command_368="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27463}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return "${__status}"
    fi
    local width_str_27466="${command_368}"
    parse_int__13_v0 "${width_str_27466}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return "${__status}"
    fi
    local width_27467="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1978_v0="${width_27467}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1979_v0() {
    local text_27474="${1}"
    local max_width_27475="${2}"
    perl_available__1977_v0 
    local ret_perl_available1977_v0__30_12="${ret_perl_available1977_v0}"
    if [ "$(( ! ret_perl_available1977_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1979_v0=''
        return 1
    fi
    local command_369
    command_369="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27474}" ${max_width_27475} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1979_v0=''
        return "${__status}"
    fi
    local result_27476="${command_369}"
    ret_perl_truncate_cjk1979_v0="${result_27476}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1983_v0() {
    local text_27431="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_370
    command_370="$([[ "${text_27431}" == *$'\x1b'* || "${text_27431}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27432="${command_370}"
    ret_has_ansi_escape1983_v0="$([ "_${has_escape_27432}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1984_v0() {
    local text_27433="${1}"
    local command_371
    command_371="$(printf '%s' "${text_27433}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1984_v0="${command_371}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1985_v0() {
    local text_27459="${1}"
    local command_372
    command_372="$(printf "%s" "${text_27459}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1985_v0="${command_372}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1986_v0() {
    local text_27461="${1}"
    local command_373
    command_373="$(printf "%s" "${text_27461}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27462="${command_373}"
    ret_is_all_ascii1986_v0="$([ "_${result_27462}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1987_v0() {
    local text_27456="${1}"
    local command_374
    command_374="$(LC_ALL=C; __t="${text_27456}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27457="${command_374}"
    parse_int__13_v0 "${measured_27457}"
    __status=$?
    ret_plain_len1987_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1988_v0() {
    local text_27455="${1}"
    plain_len__1987_v0 "${text_27455}"
    local plain_27458="${ret_plain_len1987_v0}"
    if [ "$(( plain_27458 >= 0 ))" != 0 ]; then
        ret_get_visible_len1988_v0="${plain_27458}"
        return 0
    fi
    strip_ansi__1985_v0 "${text_27455}"
    local stripped_27460="${ret_strip_ansi1985_v0}"
    is_all_ascii__1986_v0 "${stripped_27460}"
    local ret_is_all_ascii1986_v0__46_12="${ret_is_all_ascii1986_v0}"
    if [ "$(( ! ret_is_all_ascii1986_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1978_v0 "${stripped_27460}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_375="${stripped_27460}"
            ret_get_visible_len1988_v0="${#__length_375}"
            return 0
        fi
        ret_get_visible_len1988_v0="${ret_perl_get_cjk_width1978_v0}"
        return 0
    fi
    local __length_376="${stripped_27460}"
    ret_get_visible_len1988_v0="${#__length_376}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1989_v0() {
    local text_27471="${1}"
    local max_width_27472="${2}"
    get_visible_len__1988_v0 "${text_27471}"
    local visible_len_27473="${ret_get_visible_len1988_v0}"
    if [ "$(( visible_len_27473 <= max_width_27472 ))" != 0 ]; then
        ret_truncate_text1989_v0="${text_27471}"
        return 0
    fi
    is_all_ascii__1986_v0 "${text_27471}"
    local ret_is_all_ascii1986_v0__61_12="${ret_is_all_ascii1986_v0}"
    if [ "$(( ! ret_is_all_ascii1986_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1979_v0 "${text_27471}" "${max_width_27472}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27471}" | cut -c1-${max_width_27472}
            __status=$?
        fi
        ret_truncate_text1989_v0="${ret_perl_truncate_cjk1979_v0}"
        return 0
    fi
    local command_377
    command_377="$(printf "%s" "${text_27471}" | cut -c1-${max_width_27472})"
    __status=$?
    ret_truncate_text1989_v0="${command_377}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1990_v0() {
    local text_27469="${1}"
    local max_width_27470="${2}"
    has_ansi_escape__1983_v0 "${text_27469}"
    local ret_has_ansi_escape1983_v0__73_12="${ret_has_ansi_escape1983_v0}"
    if [ "$(( ! ret_has_ansi_escape1983_v0__73_12 ))" != 0 ]; then
        truncate_text__1989_v0 "${text_27469}" "${max_width_27470}"
        ret_truncate_ansi1990_v0="${ret_truncate_text1989_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_378
    command_378="$([[ "${text_27469}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27477="${command_378}"
    # Replace \x1b[ with newline, then split
    local command_379
    command_379="$(t="${text_27469}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27478="${command_379}"
    split__4_v0 "${replaced_27478}" "
"
    local parts_27479=("${ret_split4_v0[@]}")
    local result_27480=""
    local remaining_width_27481="${max_width_27470}"
    local __range_start_27482=0
    local __length_380=("${parts_27479[@]}")
    local __range_end_27482="${#__length_380[@]}"
    local __dir_27482=$(( ${__range_start_27482} <= ${__range_end_27482} ? 1 : -1 ))
    for (( idx_27482=${__range_start_27482}; idx_27482 * ${__dir_27482} < ${__range_end_27482} * ${__dir_27482}; idx_27482+=${__dir_27482} )); do
        local part_27483="${parts_27479[${idx_27482}]?"Index out of bounds (at src/./filter/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27482 == 0 )) && $([ "_${starts_with_ansi_27477}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27483}" == "_" ]; echo $?) && $(( remaining_width_27481 > 0 )) ))" != 0 ]; then
                truncate_text__1989_v0 "${part_27483}" "${remaining_width_27481}"
                local ret_truncate_text1989_v0__95_35="${ret_truncate_text1989_v0}"
                local truncated_27484="${ret_truncate_text1989_v0__95_35}"
                result_27480+="${truncated_27484}"
                get_visible_len__1988_v0 "${truncated_27484}"
                local ret_get_visible_len1988_v0__97_36="${ret_get_visible_len1988_v0}"
                remaining_width_27481="$(( remaining_width_27481 - ret_get_visible_len1988_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_381
            command_381="$(__p="${part_27483}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27485="${command_381}"
            if [ "$([ "_${m_idx_27485}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_382
                command_382="$(__p="${part_27483}"; printf "%s" "${__p:0:${m_idx_27485}}")"
                __status=$?
                local ansi_params_27486="${command_382}"
                result_27480+="\\x1b[""${ansi_params_27486}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27485}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_27487="${ret_parse_int13_v0__108_41}"
                local text_start_27488="$(( m_idx_num_27487 + 1 ))"
                local command_383
                command_383="$(__p="${part_27483}"; printf "%s" "${__p:${text_start_27488}}")"
                __status=$?
                local text_part_27489="${command_383}"
                if [ "$(( $([ "_${text_part_27489}" == "_" ]; echo $?) && $(( remaining_width_27481 > 0 )) ))" != 0 ]; then
                    truncate_text__1989_v0 "${text_part_27489}" "${remaining_width_27481}"
                    local ret_truncate_text1989_v0__112_39="${ret_truncate_text1989_v0}"
                    local truncated_27490="${ret_truncate_text1989_v0__112_39}"
                    result_27480+="${truncated_27490}"
                    get_visible_len__1988_v0 "${truncated_27490}"
                    local ret_get_visible_len1988_v0__114_40="${ret_get_visible_len1988_v0}"
                    remaining_width_27481="$(( remaining_width_27481 - ret_get_visible_len1988_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27483}" == "_" ]; echo $?) && $(( remaining_width_27481 > 0 )) ))" != 0 ]; then
                    truncate_text__1989_v0 "${part_27483}" "${remaining_width_27481}"
                    local ret_truncate_text1989_v0__119_39="${ret_truncate_text1989_v0}"
                    local truncated_27491="${ret_truncate_text1989_v0__119_39}"
                    result_27480+="${truncated_27491}"
                    get_visible_len__1988_v0 "${truncated_27491}"
                    local ret_get_visible_len1988_v0__121_40="${ret_get_visible_len1988_v0}"
                    remaining_width_27481="$(( remaining_width_27481 - ret_get_visible_len1988_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1990_v0="${result_27480}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1991_v0() {
    local text_27453="${1}"
    local max_width_27454="${2}"
    get_visible_len__1988_v0 "${text_27453}"
    local visible_len_27468="${ret_get_visible_len1988_v0}"
    if [ "$(( visible_len_27468 <= max_width_27454 ))" != 0 ]; then
        ret_cutoff_text1991_v0="${text_27453}"
        return 0
    fi
    truncate_ansi__1990_v0 "${text_27453}" "$(( max_width_27454 - 3 ))"
    local ret_truncate_ansi1990_v0__137_12="${ret_truncate_ansi1990_v0}"
    ret_cutoff_text1991_v0="${ret_truncate_ansi1990_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2012_v0() {
    local format_27502="${1}"
    local args_27503=("${!2}")
    args_27503=("${format_27502}" "${args_27503[@]}")
    __status=$?
    printf "${args_27503[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2013_v0() {
    local message_27500="${1}"
    local color_27501="${2}"
    # Prints an error message with a specified color.
    local array_384=("${message_27500}")
    eprintf__2012_v0 "\\x1b[${color_27501}m%s\\x1b[0m" array_384[@]
}

# colored(message: Text, color: Int)
colored__2014_v0() {
    local message_27420="${1}"
    local color_27421="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2014_v0="\\x1b[${color_27421}m""${message_27420}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2018_v0() {
    local items_27494=("${!1}")
    local total_len_27495="${2}"
    local term_width_27496="${3}"
    local separator_27497=" • "
    local separator_len_27498=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27495 <= term_width_27496 ))" != 0 ]; then
        local iter_27499=0
        while :
        do
            local __length_385=("${items_27494[@]}")
            if [ "$(( iter_27499 >= ${#__length_385[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_27499 > 0 ))" != 0 ]; then
                eprintf_colored__2013_v0 "${separator_27497}" 90
            fi
            colored__2014_v0 "${items_27494[$(( iter_27499 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2014_v0__23_41="${ret_colored2014_v0}"
            local array_386=("")
            eprintf__2012_v0 "${items_27494[${iter_27499}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2014_v0__23_41}" array_386[@]
            iter_27499="$(( iter_27499 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_27504=0
        local first_27505=1
        local iter_27506=0
        while :
        do
            local __length_387=("${items_27494[@]}")
            if [ "$(( iter_27506 >= ${#__length_387[@]} ))" != 0 ]; then
                break
            fi
            local key_27507="${items_27494[${iter_27506}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:35:31)"}"
            local action_27508="${items_27494[$(( iter_27506 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:36:34)"}"
            local __length_388="${key_27507}"
            local __length_389="${action_27508}"
            local part_len_27509="$(( $(( ${#__length_388} + 1 )) + ${#__length_389} ))"
            local needed_27510="${part_len_27509}"
            if [ "$(( ! first_27505 ))" != 0 ]; then
                needed_27510="$(( needed_27510 + separator_len_27498 ))"
            fi
            if [ "$(( $(( current_len_27504 + needed_27510 )) > term_width_27496 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_27505 ))" != 0 ]; then
                eprintf_colored__2013_v0 "${separator_27497}" 90
            fi
            colored__2014_v0 "${action_27508}" 2
            local ret_colored2014_v0__51_33="${ret_colored2014_v0}"
            local array_390=("")
            eprintf__2012_v0 "${key_27507}"" ""${ret_colored2014_v0__51_33}" array_390[@]
            current_len_27504="$(( current_len_27504 + needed_27510 ))"
            first_27505=0
            iter_27506="$(( iter_27506 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2028_v0() {
    local format_27535="${1}"
    local args_27536=("${!2}")
    args_27536=("${format_27535}" "${args_27536[@]}")
    __status=$?
    printf "${args_27536[@]}" >&2
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
store_term_size__2055_v0() {
    local size_27399="${1}"
    if [ "$([ "_${size_27399}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2055_v0=0
        return 0
    fi
    split__4_v0 "${size_27399}" " "
    local parts_27400=("${ret_split4_v0[@]}")
    local __length_392=("${parts_27400[@]}")
    if [ "$(( ${#__length_392[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2055_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27400[1]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27400[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_104=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2055_v0=1
    return 0
}

# query_term_size()
query_term_size__2056_v0() {
    local command_394
    command_394="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27402="${command_394}"
    store_term_size__2055_v0 "${size_27402}"
    ret_query_term_size2056_v0="${ret_store_term_size2055_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2057_v0() {
    local command_395
    command_395="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27398="${command_395}"
    store_term_size__2055_v0 "${size_27398}"
    ret_stty_term_size2057_v0="${ret_store_term_size2055_v0}"
    return 0
}

# get_term_size()
get_term_size__2058_v0() {
    stty_term_size__2057_v0 
    local detected_27401="${ret_stty_term_size2057_v0}"
    if [ "$(( ! detected_27401 ))" != 0 ]; then
        query_term_size__2056_v0 
        detected_27401="${ret_query_term_size2056_v0}"
    fi
    _got_term_size_103=1
}

# term_width()
term_width__2060_v0() {
    if [ "$(( ! _got_term_size_103 ))" != 0 ]; then
        get_term_size__2058_v0 
    fi
    ret_term_width2060_v0="${_term_size_104[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__2067_v0() {
    local cnt_27534="${1}"
    local array_396=("")
    eprintf__2028_v0 "\\x1b[${cnt_27534}A" array_396[@]
}

# go_down(cnt: Int)
go_down__2068_v0() {
    local cnt_27537="${1}"
    local array_397=("")
    eprintf__2028_v0 "\\x1b[${cnt_27537}B" array_397[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__2075_v0() {
    local display_count_27531="${1}"
    local index_27532="${2}"
    local line_27533="${3}"
    go_up__2067_v0 "$(( display_count_27531 - index_27532 ))"
    local array_398=("")
    eprintf__2012_v0 "\\x1b[G\\x1b[K" array_398[@]
    local array_399=("")
    eprintf__2012_v0 "${line_27533}" array_399[@]
    go_down__2068_v0 "$(( display_count_27531 - index_27532 ))"
    local array_400=("")
    eprintf__2012_v0 "\\x1b[G" array_400[@]
}

# Which items of a multi-select widget are ticked.
_checked_105=()
_count_106=0
_total_107=0
_limit_108=-1
# checked_init(total: Int, limit: Int)
checked_init__2077_v0() {
    local total_27449="${1}"
    local limit_27450="${2}"
    _checked_105=()
    local __range_start_27451=0
    local __range_end_27451="${total_27449}"
    local __dir_27451=$(( ${__range_start_27451} <= ${__range_end_27451} ? 1 : -1 ))
    for (( ____27451=${__range_start_27451}; ____27451 * ${__dir_27451} < ${__range_end_27451} * ${__dir_27451}; ____27451+=${__dir_27451} )); do
        local array_403=(0)
        _checked_105+=("${array_403[@]}")
done
    _count_106=0
    _total_107="${total_27449}"
    _limit_108="${limit_27450}"
}

# checked_is(index: Int)
checked_is__2078_v0() {
    local index_27521="${1}"
    ret_checked_is2078_v0="${_checked_105[${index_27521}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_count()
checked_count__2079_v0() {
    ret_checked_count2079_v0="${_count_106}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__2080_v0() {
    local index_27538="${1}"
    if [ "${_checked_105[${index_27538}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_105["${index_27538}"]=0
        _count_106="$(( _count_106 - 1 ))"
        ret_checked_toggle2080_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_108 >= 0 )) && $(( _count_106 >= _limit_108 )) ))" != 0 ]; then
        ret_checked_toggle2080_v0=0
        return 0
    fi
    _checked_105["${index_27538}"]=1
    _count_106="$(( _count_106 + 1 ))"
    ret_checked_toggle2080_v0=1
    return 0
}

# checked_all()
checked_all__2081_v0() {
    if [ "$(( _limit_108 >= 0 ))" != 0 ]; then
        ret_checked_all2081_v0=0
        return 0
    fi
    local was_all_27539="$(( _count_106 == _total_107 ))"
    local __range_start_27540=0
    local __range_end_27540="${_total_107}"
    local __dir_27540=$(( ${__range_start_27540} <= ${__range_end_27540} ? 1 : -1 ))
    for (( i_27540=${__range_start_27540}; i_27540 * ${__dir_27540} < ${__range_end_27540} * ${__dir_27540}; i_27540+=${__dir_27540} )); do
        _checked_105["${i_27540}"]="$(( ! was_all_27539 ))"
done
    if [ "${was_all_27539}" != 0 ]; then
        _count_106=0
    else
        _count_106="${_total_107}"
    fi
    ret_checked_all2081_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2093_v0() {
    local pending_27417="${1}"
    local line_27418="${2}"
    local note_at_27419="${3}"
    if [ "$(( note_at_27419 < 0 ))" != 0 ]; then
        local array_404=()
        printf__128_v0 "${pending_27417}""${line_27418}""
" array_404[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27419 == 0 ))" != 0 ]; then
        colored__2014_v0 "${line_27418}" 90
        local ret_colored2014_v0__12_40="${ret_colored2014_v0}"
        local array_405=()
        printf__128_v0 "${pending_27417}""${ret_colored2014_v0__12_40}""
" array_405[@]
    else
        slice__24_v0 "${line_27418}" 0 "${note_at_27419}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27418}" "${note_at_27419}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2014_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2014_v0__13_58="${ret_colored2014_v0}"
        local array_406=()
        printf__128_v0 "${pending_27417}""${ret_slice24_v0__13_32}""${ret_colored2014_v0__13_58}""
" array_406[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2094_v0() {
    local names_27390=("${!1}")
    local texts_27391=("${!2}")
    local notes_27392=("${!3}")
    local min_name_width_27393="${4}"
    local __length_407=("${names_27390[@]}")
    local count_27394="${#__length_407[@]}"
    local name_width_27395="${min_name_width_27393}"
    local __range_start_27396=0
    local __range_end_27396="${count_27394}"
    local __dir_27396=$(( ${__range_start_27396} <= ${__range_end_27396} ? 1 : -1 ))
    for (( i_27396=${__range_start_27396}; i_27396 * ${__dir_27396} < ${__range_end_27396} * ${__dir_27396}; i_27396+=${__dir_27396} )); do
        local __length_408="${names_27390[${i_27396}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:28:33)"}"
        local width_27397="${#__length_408}"
        if [ "$(( width_27397 > name_width_27395 ))" != 0 ]; then
            name_width_27395="${width_27397}"
        fi
done
    term_width__2060_v0 
    local width_27403="${ret_term_width2060_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27404="$(( name_width_27395 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27405="$(( $(( width_27403 - indent_27404 )) < 24 ))"
    if [ "${stacked_27405}" != 0 ]; then
        indent_27404=6
    fi
    local avail_27406="$(( width_27403 - indent_27404 ))"
    rpad__28_v0 "" " " "${indent_27404}"
    local blank_27407="${ret_rpad28_v0}"
    local __range_start_27408=0
    local __range_end_27408="${count_27394}"
    local __dir_27408=$(( ${__range_start_27408} <= ${__range_end_27408} ? 1 : -1 ))
    for (( i_27408=${__range_start_27408}; i_27408 * ${__dir_27408} < ${__range_end_27408} * ${__dir_27408}; i_27408+=${__dir_27408} )); do
        local pending_27409="${blank_27407}"
        if [ "${stacked_27405}" != 0 ]; then
            local array_409=()
            printf__128_v0 "  ""${names_27390[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:48:33)"}""
" array_409[@]
        else
            rpad__28_v0 "  ""${names_27390[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:50:41)"}" " " "${indent_27404}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_27409="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_27391[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_27410=("${ret_split4_v0__52_21[@]}")
        local __length_410=("${words_27410[@]}")
        local note_start_27411="${#__length_410[@]}"
        if [ "$([ "_${notes_27392[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_411="${notes_27392[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_411} > avail_27406 ))" != 0 ]; then
                split__4_v0 "${notes_27392[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_27410+=("${ret_split4_v0__58_26[@]}")
            else
                local array_412=("${notes_27392[${i_27408}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:60:33)"}")
                words_27410+=("${array_412[@]}")
            fi
        fi
        local line_27412=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27413=-1
        local __range_start_27414=0
        local __length_413=("${words_27410[@]}")
        local __range_end_27414="${#__length_413[@]}"
        local __dir_27414=$(( ${__range_start_27414} <= ${__range_end_27414} ? 1 : -1 ))
        for (( j_27414=${__range_start_27414}; j_27414 * ${__dir_27414} < ${__range_end_27414} * ${__dir_27414}; j_27414+=${__dir_27414} )); do
            local word_27415="${words_27410[${j_27414}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:70:32)"}"
            local candidate_27416
            candidate_27416="$(if [ "$([ "_${line_27412}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27415}"; else echo "${line_27412}"" ""${word_27415}"; fi)"
            local __length_414="${candidate_27416}"
            if [ "$(( $(( ${#__length_414} > avail_27406 )) && $([ "_${line_27412}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2093_v0 "${pending_27409}" "${line_27412}" "${note_at_27413}"
                pending_27409="${blank_27407}"
                line_27412="${word_27415}"
                note_at_27413="$(if [ "$(( j_27414 >= note_start_27411 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27414 >= note_start_27411 )) && $(( note_at_27413 < 0 )) ))" != 0 ]; then
                    local __length_415="${candidate_27416}"
                    local __length_416="${word_27415}"
                    note_at_27413="$(( ${#__length_415} - ${#__length_416} ))"
                fi
                line_27412="${candidate_27416}"
            fi
done
        print_help_line__2093_v0 "${pending_27409}" "${line_27412}" "${note_at_27413}"
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
refresh_matches__2152_v0() {
    local command_419
    command_419="$(shopt -s nocasematch; __r=""; __i=0; for __it in "${_options_110[@]}"; do case "$__it" in (*"${_query_112}"*) __r="$__r $__i";; esac; __i=$((__i+1)); done; printf '%s' "${__r# }")"
    __status=$?
    local raw_27452="${command_419}"
    if [ "$([ "_${raw_27452}" != "_" ]; echo $?)" != 0 ]; then
        _matches_111=()
    else
        split__4_v0 "${raw_27452}" " "
        _matches_111=("${ret_split4_v0[@]}")
    fi
    _offset_117=0
    _sel_118=0
}

# visible_count()
visible_count__2153_v0() {
    local __length_421=("${_matches_111[@]}")
    local count_27512="$(( ${#__length_421[@]} - _offset_117 ))"
    if [ "$(( count_27512 > _height_116 ))" != 0 ]; then
        count_27512="${_height_116}"
    fi
    if [ "$(( count_27512 < 0 ))" != 0 ]; then
        count_27512=0
    fi
    ret_visible_count2153_v0="${count_27512}"
    return 0
}

# option_index(row: Int)
option_index__2154_v0() {
    local row_27517="${1}"
    parse_int__13_v0 "${_matches_111[$(( _offset_117 + row_27517 ))]?"Index out of bounds (at src/./filter/./mod.ab:48:37)"}"
    __status=$?
    ret_option_index2154_v0="${ret_parse_int13_v0}"
    return 0
}

# option_width()
option_width__2155_v0() {
    local check_width_27518
    check_width_27518="$(if [ "${_multi_119}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_422="${_cursor_115}"
    ret_option_width2155_v0="$(( $(( _term_width_121 - ${#__length_422} )) - check_width_27518 ))"
    return 0
}

# row_line(row: Int, highlighted: Bool)
row_line__2156_v0() {
    local row_27515="${1}"
    local highlighted_27516="${2}"
    option_index__2154_v0 "${row_27515}"
    local ret_option_index2154_v0__57_44="${ret_option_index2154_v0}"
    option_width__2155_v0 
    local ret_option_width2155_v0__57_64="${ret_option_width2155_v0}"
    cutoff_text__1991_v0 "${_options_110[${ret_option_index2154_v0__57_44}]?"Index out of bounds (at src/./filter/./mod.ab:57:44)"}" "${ret_option_width2155_v0__57_64}"
    local truncated_27519="${ret_cutoff_text1991_v0}"
    local __length_423="${_cursor_115}"
    rpad__28_v0 "" " " "${#__length_423}"
    local blank_27520="${ret_rpad28_v0}"
    if [ "$(( ! _multi_119 ))" != 0 ]; then
        if [ "${highlighted_27516}" != 0 ]; then
            colored_secondary__1960_v0 "${_cursor_115}""${truncated_27519}"
            ret_row_line2156_v0="${ret_colored_secondary1960_v0}"
            return 0
        fi
        ret_row_line2156_v0="${blank_27520}""${truncated_27519}"
        return 0
    fi
    option_index__2154_v0 "${row_27515}"
    local ret_option_index2154_v0__65_31="${ret_option_index2154_v0}"
    checked_is__2078_v0 "${ret_option_index2154_v0__65_31}"
    local ticked_27522="${ret_checked_is2078_v0}"
    local mark_27523
    mark_27523="$(if [ "${ticked_27522}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    if [ "${highlighted_27516}" != 0 ]; then
        colored_secondary__1960_v0 "${_cursor_115}""${mark_27523}""${truncated_27519}"
        ret_row_line2156_v0="${ret_colored_secondary1960_v0}"
        return 0
    fi
    if [ "${ticked_27522}" != 0 ]; then
        colored_secondary__1960_v0 "${mark_27523}""${truncated_27519}"
        local ret_colored_secondary1960_v0__71_24="${ret_colored_secondary1960_v0}"
        ret_row_line2156_v0="${blank_27520}""${ret_colored_secondary1960_v0__71_24}"
        return 0
    fi
    ret_row_line2156_v0="${blank_27520}""${mark_27523}""${truncated_27519}"
    return 0
}

# render_rows()
render_rows__2157_v0() {
    visible_count__2153_v0 
    local count_27513="${ret_visible_count2153_v0}"
    go_up__1912_v0 "${_height_116}"
    local array_424=("")
    eprintf__1857_v0 "\\x1b[G" array_424[@]
    local __range_start_27514=0
    local __range_end_27514="${count_27513}"
    local __dir_27514=$(( ${__range_start_27514} <= ${__range_end_27514} ? 1 : -1 ))
    for (( row_27514=${__range_start_27514}; row_27514 * ${__dir_27514} < ${__range_end_27514} * ${__dir_27514}; row_27514+=${__dir_27514} )); do
        row_line__2156_v0 "${row_27514}" "$(( row_27514 == _sel_118 ))"
        local ret_row_line2156_v0__82_28="${ret_row_line2156_v0}"
        local array_425=("")
        eprintf__1857_v0 "\\x1b[K""${ret_row_line2156_v0__82_28}""
" array_425[@]
done
    local __range_start_27524="${count_27513}"
    local __range_end_27524="${_height_116}"
    local __dir_27524=$(( ${__range_start_27524} <= ${__range_end_27524} ? 1 : -1 ))
    for (( ____27524=${__range_start_27524}; ____27524 * ${__dir_27524} < ${__range_end_27524} * ${__dir_27524}; ____27524+=${__dir_27524} )); do
        local array_426=("")
        eprintf__1857_v0 "\\x1b[K
" array_426[@]
done
    local array_427=("")
    eprintf__1857_v0 "\\x1b[G" array_427[@]
}

# render_query()
render_query__2158_v0() {
    go_up__1912_v0 "$(( _height_116 + 1 ))"
    local array_428=("")
    eprintf__1857_v0 "\\x1b[G\\x1b[K" array_428[@]
    colored_secondary__1960_v0 "${_prompt_114}"
    local ret_colored_secondary1960_v0__93_13="${ret_colored_secondary1960_v0}"
    local array_429=("")
    eprintf__1857_v0 "${ret_colored_secondary1960_v0__93_13}" array_429[@]
    if [ "$([ "_${_query_112}" != "_" ]; echo $?)" != 0 ]; then
        eprintf_colored__1858_v0 "${_placeholder_113}" 90
    else
        local __length_430="${_prompt_114}"
        cutoff_text__1991_v0 "${_query_112}" "$(( _term_width_121 - ${#__length_430} ))"
        local ret_cutoff_text1991_v0__97_17="${ret_cutoff_text1991_v0}"
        local array_431=("")
        eprintf__1857_v0 "${ret_cutoff_text1991_v0__97_17}" array_431[@]
    fi
    go_down__1913_v0 "$(( _height_116 + 1 ))"
    local array_432=("")
    eprintf__1857_v0 "\\x1b[G" array_432[@]
}

# render_count()
render_count__2159_v0() {
    local array_433=("")
    eprintf__1857_v0 "\\x1b[K" array_433[@]
    local __length_434=("${_matches_111[@]}")
    local __length_435=("${_options_110[@]}")
    eprintf_colored__1858_v0 "${#__length_434[@]}/${#__length_435[@]}" 90
    local array_436=("")
    eprintf__1857_v0 "\\x1b[G" array_436[@]
}

# render_tooltip_line()
render_tooltip_line__2160_v0() {
    if [ "${_multi_119}" != 0 ]; then
        local array_437=("↑↓" "select" "tab" "toggle" "ctrl-a" "all" "enter" "confirm")
        render_tooltip__2018_v0 array_437[@] 51 "${_term_width_121}"
    else
        local array_438=("↑↓" "select" "enter" "confirm")
        render_tooltip__2018_v0 array_438[@] 25 "${_term_width_121}"
    fi
}

# move_selection(step: Int)
move_selection__2161_v0() {
    local step_27527="${1}"
    visible_count__2153_v0 
    local count_27528="${ret_visible_count2153_v0}"
    if [ "$(( count_27528 == 0 ))" != 0 ]; then
        ret_move_selection2161_v0=0
        return 0
    fi
    local next_27529="$(( _sel_118 + step_27527 ))"
    if [ "$(( $(( next_27529 >= 0 )) && $(( next_27529 < count_27528 )) ))" != 0 ]; then
        local prev_27530="${_sel_118}"
        _sel_118="${next_27529}"
        row_line__2156_v0 "${prev_27530}" 0
        local ret_row_line2156_v0__128_35="${ret_row_line2156_v0}"
        redraw_row__2075_v0 "${_height_116}" "${prev_27530}" "${ret_row_line2156_v0__128_35}"
        row_line__2156_v0 "${_sel_118}" 1
        local ret_row_line2156_v0__129_35="${ret_row_line2156_v0}"
        redraw_row__2075_v0 "${_height_116}" "${_sel_118}" "${ret_row_line2156_v0__129_35}"
        ret_move_selection2161_v0=0
        return 0
    fi
    if [ "$(( $(( next_27529 < 0 )) && $(( _offset_117 > 0 )) ))" != 0 ]; then
        _offset_117="$(( _offset_117 - 1 ))"
        ret_move_selection2161_v0=1
        return 0
    fi
    local __length_439=("${_matches_111[@]}")
    if [ "$(( $(( next_27529 >= count_27528 )) && $(( $(( _offset_117 + _height_116 )) < ${#__length_439[@]} )) ))" != 0 ]; then
        _offset_117="$(( _offset_117 + 1 ))"
        ret_move_selection2161_v0=1
        return 0
    fi
    ret_move_selection2161_v0=0
    return 0
}

# xyl_filter(options: [Text], prompt: Text, placeholder: Text, header: Text, cursor: Text, multi: Bool, limit: Int, height: Int)
xyl_filter__2162_v0() {
    local options_27435=("${!1}")
    local prompt_27436="${2}"
    local placeholder_27437="${3}"
    local header_27438="${4}"
    local cursor_27439="${5}"
    local multi_27440="${6}"
    local limit_27441="${7}"
    local height_27442="${8}"
    local __length_440=("${options_27435[@]}")
    local total_27443="${#__length_440[@]}"
    if [ "$(( total_27443 == 0 ))" != 0 ]; then
        eprintf_colored__1858_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    _options_110=("${options_27435[@]}")
    _query_112=""
    _prompt_114="${prompt_27436}"
    _placeholder_113="${placeholder_27437}"
    _cursor_115="${cursor_27439}"
    _multi_119="${multi_27440}"
    _has_header_120="$([ "_${header_27438}" == "_" ]; echo $?)"
    _offset_117=0
    _sel_118=0
    stty_lock__1898_v0 
    hide_cursor__1915_v0 
    term_width__1905_v0 
    _term_width_121="${ret_term_width1905_v0}"
    # Header, query, count and tooltip take four of the terminal's lines.
    term_height__1906_v0 
    local ret_term_height1906_v0__185_24="${ret_term_height1906_v0}"
    local max_height_27448
    max_height_27448="$(( ret_term_height1906_v0__185_24 - $(if [ "${_has_header_120}" != 0 ]; then echo 4; else echo 3; fi) ))"
    _height_116="${height_27442}"
    if [ "$(( _height_116 > max_height_27448 ))" != 0 ]; then
        _height_116="${max_height_27448}"
    fi
    if [ "$(( _height_116 < 1 ))" != 0 ]; then
        _height_116=1
    fi
    if [ "${multi_27440}" != 0 ]; then
        checked_init__2077_v0 "${total_27443}" "${limit_27441}"
    fi
    refresh_matches__2152_v0 
    if [ "${_has_header_120}" != 0 ]; then
        cutoff_text__1991_v0 "${header_27438}" "${_term_width_121}"
        local ret_cutoff_text1991_v0__200_17="${ret_cutoff_text1991_v0}"
        local array_441=("")
        eprintf__1857_v0 "${ret_cutoff_text1991_v0__200_17}""
" array_441[@]
    fi
    new_line__1911_v0 1
    new_line__1911_v0 "${_height_116}"
    render_count__2159_v0 
    new_line__1911_v0 1
    render_tooltip_line__2160_v0 
    go_up__1912_v0 1
    local array_442=("")
    eprintf__1857_v0 "\\x1b[G" array_442[@]
    render_rows__2157_v0 
    render_query__2158_v0 
    while :
    do
        get_key__1855_v0 
        local key_27526="${ret_get_key1855_v0}"
        if [ "$([ "_${key_27526}" != "_INPUT" ]; echo $?)" != 0 ]; then
            visible_count__2153_v0 
            local ret_visible_count2153_v0__217_20="${ret_visible_count2153_v0}"
            if [ "$(( ret_visible_count2153_v0__217_20 > 0 ))" != 0 ]; then
                break
            fi
            # Nothing matches, so there is nothing to hand back. Multi mode
            # still confirms what is already ticked, otherwise a query that
            # matches nothing would trap the user.
            if [ "${_multi_119}" != 0 ]; then
                checked_count__2079_v0 
                local ret_checked_count2079_v0__224_24="${ret_checked_count2079_v0}"
                if [ "$(( ret_checked_count2079_v0__224_24 > 0 ))" != 0 ]; then
                    break
                fi
            fi
        elif [ "$([ "_${key_27526}" != "_UP" ]; echo $?)" != 0 ]; then
            move_selection__2161_v0 -1
            local ret_move_selection2161_v0__230_20="${ret_move_selection2161_v0}"
            if [ "${ret_move_selection2161_v0__230_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$([ "_${key_27526}" != "_DOWN" ]; echo $?)" != 0 ]; then
            move_selection__2161_v0 1
            local ret_move_selection2161_v0__235_20="${ret_move_selection2161_v0}"
            if [ "${ret_move_selection2161_v0__235_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$(( _multi_119 && $([ "_${key_27526}" != "_TAB" ]; echo $?) ))" != 0 ]; then
            visible_count__2153_v0 
            local ret_visible_count2153_v0__240_20="${ret_visible_count2153_v0}"
            if [ "$(( ret_visible_count2153_v0__240_20 > 0 ))" != 0 ]; then
                option_index__2154_v0 "${_sel_118}"
                local ret_option_index2154_v0__241_39="${ret_option_index2154_v0}"
                checked_toggle__2080_v0 "${ret_option_index2154_v0__241_39}"
                local ret_checked_toggle2080_v0__241_24="${ret_checked_toggle2080_v0}"
                if [ "${ret_checked_toggle2080_v0__241_24}" != 0 ]; then
                    row_line__2156_v0 "${_sel_118}" 1
                    local ret_row_line2156_v0__242_51="${ret_row_line2156_v0}"
                    redraw_row__2075_v0 "${_height_116}" "${_sel_118}" "${ret_row_line2156_v0__242_51}"
                fi
            fi
        elif [ "$(( _multi_119 && $([ "_${key_27526}" != "_CTRL_A" ]; echo $?) ))" != 0 ]; then
            checked_all__2081_v0 
            local ret_checked_all2081_v0__247_20="${ret_checked_all2081_v0}"
            if [ "${ret_checked_all2081_v0__247_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$([ "_${key_27526}" != "_BACKSPACE" ]; echo $?)" != 0 ]; then
            if [ "$([ "_${_query_112}" == "_" ]; echo $?)" != 0 ]; then
                # A length of zero means "to the end" in `slice`, so the
                # last character left has to be dropped on its own.
                local __length_443="${_query_112}"
                if [ "$(( ${#__length_443} == 1 ))" != 0 ]; then
                    _query_112=""
                else
                    local __length_444="${_query_112}"
                    slice__24_v0 "${_query_112}" 0 "$(( ${#__length_444} - 1 ))"
                    _query_112="${ret_slice24_v0}"
                fi
                refresh_matches__2152_v0 
                render_rows__2157_v0 
                render_query__2158_v0 
                render_count__2159_v0 
            fi
        else
            local typed_27541="${key_27526}"
            if [ "$([ "_${key_27526}" != "_SPACE" ]; echo $?)" != 0 ]; then
                typed_27541=" "
            fi
            local __length_445="${typed_27541}"
            if [ "$(( ${#__length_445} == 1 ))" != 0 ]; then
                _query_112+="${typed_27541}"
                refresh_matches__2152_v0 
                render_rows__2157_v0 
                render_query__2158_v0 
                render_count__2159_v0 
            fi
        fi
    done
    local total_lines_27542="$(( _height_116 + 3 ))"
    if [ "${_has_header_120}" != 0 ]; then
        total_lines_27542="$(( total_lines_27542 + 1 ))"
    fi
    go_down__1913_v0 1
    remove_line__1908_v0 "$(( total_lines_27542 - 1 ))"
    remove_current_line__1909_v0 
    stty_unlock__1899_v0 
    show_cursor__1916_v0 
    local result_27547=()
    if [ "${_multi_119}" != 0 ]; then
        local __range_start_27548=0
        local __range_end_27548="${total_27443}"
        local __dir_27548=$(( ${__range_start_27548} <= ${__range_end_27548} ? 1 : -1 ))
        for (( i_27548=${__range_start_27548}; i_27548 * ${__dir_27548} < ${__range_end_27548} * ${__dir_27548}; i_27548+=${__dir_27548} )); do
            checked_is__2078_v0 "${i_27548}"
            local ret_checked_is2078_v0__295_16="${ret_checked_is2078_v0}"
            if [ "${ret_checked_is2078_v0__295_16}" != 0 ]; then
                local array_447=("${_options_110[${i_27548}]?"Index out of bounds (at src/./filter/./mod.ab:296:37)"}")
                result_27547+=("${array_447[@]}")
            fi
done
        ret_xyl_filter2162_v0=("${result_27547[@]}")
        return 0
    fi
    visible_count__2153_v0 
    local ret_visible_count2153_v0__301_8="${ret_visible_count2153_v0}"
    if [ "$(( ret_visible_count2153_v0__301_8 > 0 ))" != 0 ]; then
        option_index__2154_v0 "${_sel_118}"
        local ret_option_index2154_v0__302_29="${ret_option_index2154_v0}"
        result_27547+=("${_options_110[${ret_option_index2154_v0__302_29}]?"Index out of bounds (at src/./filter/./mod.ab:302:29)"}")
    fi
    ret_xyl_filter2162_v0=("${result_27547[@]}")
    return 0
}

# print_filter_help()
print_filter_help__2262_v0() {
    local usage_27348=("Usage:" "./xylitol.sh" "filter" "[<options>" "...]" "[flags]")
    print_wrapped__1917_v0 usage_27348[@]
    printf '%s\n' ""
    colored_primary__1959_v0 "filter"
    local ret_colored_primary1959_v0__8_20="${ret_colored_primary1959_v0}"
    local title_27388=("${ret_colored_primary1959_v0__8_20}" "-" "Pick" "from" "a" "list" "narrowed" "by" "typing.")
    print_wrapped__1917_v0 title_27388[@]
    printf '%s\n' ""
    colored_secondary__1960_v0 "Arguments:"
    local ret_colored_secondary1960_v0__11_12="${ret_colored_secondary1960_v0}"
    local array_451=()
    printf__128_v0 "${ret_colored_secondary1960_v0__11_12}""
" array_451[@]
    local array_452=("[<options> ...]")
    local array_453=("List of options to pick from")
    local array_454=("")
    render_help_entries__2094_v0 array_452[@] array_453[@] array_454[@] 20
    printf '%s\n' ""
    colored_secondary__1960_v0 "Flags:"
    local ret_colored_secondary1960_v0__14_12="${ret_colored_secondary1960_v0}"
    local array_455=()
    printf__128_v0 "${ret_colored_secondary1960_v0__14_12}""
" array_455[@]
    local names_27422=("-h, --help" "--limit=<number>" "--no-limit" "--prompt=\"<text>\"" "--placeholder=\"<text>\"" "--cursor=\"<text>\"" "--header=\"<text>\"" "--height=<number>")
    local texts_27423=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the text shown in front of the query" "Set the text shown while the query is empty" "Set the cursor text" "Set a header text to display above the query" "Set the number of options shown at once")
    local notes_27424=("" "" "" "(default: '> ')" "(default: 'Filter...')" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__2094_v0 names_27422[@] texts_27423[@] notes_27424[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__2320_v0() {
    local options_27341=()
    local command_460
    command_460="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_27342="${command_460}"
    if [ "$([ "_${is_tty_27342}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_27341+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options2320_v0=("${options_27341[@]}")
    return 0
}

# execute_filter(parameters: [Text])
execute_filter__2321_v0() {
    local parameters_27336=("${!1}")
    local cursor_27337="> "
    local prompt_27338="> "
    local placeholder_27339="Filter..."
    local header_27340=""
    read_stdin_options__2320_v0 
    local options_27343=("${ret_read_stdin_options2320_v0[@]}")
    local multi_27344=0
    local limit_27345=-1
    local height_27346=10
    local __length_464=("${parameters_27336[@]}")
    local slice_upper_463="${#__length_464[@]}"
    local slice_offset_465=2
    local slice_offset_465=$((${slice_offset_465} > 0 ? ${slice_offset_465} : 0))
    local slice_length_466="$(( slice_upper_463 - slice_offset_465 ))"
    local slice_length_466=$((${slice_length_466} > 0 ? ${slice_length_466} : 0))
    for param_27347 in "${parameters_27336[@]:${slice_offset_465}:${slice_length_466}}"; do
        starts_with__22_v0 "${param_27347}" "--cursor="
        local ret_starts_with22_v0__31_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27347}" "--prompt="
        local ret_starts_with22_v0__34_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27347}" "--placeholder="
        local ret_starts_with22_v0__37_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27347}" "--header="
        local ret_starts_with22_v0__40_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27347}" "--limit="
        local ret_starts_with22_v0__43_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27347}" "--height="
        local ret_starts_with22_v0__54_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27347}" != "_-h" ]; echo $?) || $([ "_${param_27347}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_filter_help__2262_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__31_13}" != 0 ]; then
            local __length_467="--cursor="
            slice__24_v0 "${param_27347}" "${#__length_467}" 0
            cursor_27337="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__34_13}" != 0 ]; then
            local __length_468="--prompt="
            slice__24_v0 "${param_27347}" "${#__length_468}" 0
            prompt_27338="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__37_13}" != 0 ]; then
            local __length_469="--placeholder="
            slice__24_v0 "${param_27347}" "${#__length_469}" 0
            placeholder_27339="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__40_13}" != 0 ]; then
            local __length_470="--header="
            slice__24_v0 "${param_27347}" "${#__length_470}" 0
            header_27340="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__43_13}" != 0 ]; then
            local __length_471="--limit="
            slice__24_v0 "${param_27347}" "${#__length_471}" 0
            local value_27425="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27425}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1858_v0 "ERROR: Invalid limit value: ""${value_27425}""
" 31
                exit 1
            fi
            limit_27345="${ret_parse_int13_v0}"
            multi_27344=1
        elif [ "$([ "_${param_27347}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_27344=1
        elif [ "${ret_starts_with22_v0__54_13}" != 0 ]; then
            local __length_472="--height="
            slice__24_v0 "${param_27347}" "${#__length_472}" 0
            local value_27430="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27430}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1858_v0 "ERROR: Invalid height value: ""${value_27430}""
" 31
                exit 1
            fi
            height_27346="${ret_parse_int13_v0}"
        else
            options_27343+=("${param_27347}")
        fi
    done
    has_ansi_escape__1983_v0 "${header_27340}"
    local ret_has_ansi_escape1983_v0__67_44="${ret_has_ansi_escape1983_v0}"
    escape_ansi__1984_v0 "${header_27340}"
    local ret_escape_ansi1984_v0__67_73="${ret_escape_ansi1984_v0}"
    colored_primary__1959_v0 "${header_27340}"
    local ret_colored_primary1959_v0__67_111="${ret_colored_primary1959_v0}"
    local display_header_27434
    display_header_27434="$(if [ "$(( $([ "_${header_27340}" != "_" ]; echo $?) || ret_has_ansi_escape1983_v0__67_44 ))" != 0 ]; then echo "${ret_escape_ansi1984_v0__67_73}"; else echo "\\x1b[1m""${ret_colored_primary1959_v0__67_111}"; fi)"
    xyl_filter__2162_v0 options_27343[@] "${prompt_27338}" "${placeholder_27339}" "${display_header_27434}" "${cursor_27337}" "${multi_27344}" "${limit_27345}" "${height_27346}"
    local results_27549=("${ret_xyl_filter2162_v0[@]}")
    join__7_v0 results_27549[@] "
"
    ret_execute_filter2321_v0="${ret_join7_v0}"
    return 0
}

# get_key()
get_key__2445_v0() {
    local command_474
    command_474="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key2445_v0="${command_474}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2447_v0() {
    local format_29604="${1}"
    local args_29605=("${!2}")
    args_29605=("${format_29604}" "${args_29605[@]}")
    __status=$?
    printf "${args_29605[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2448_v0() {
    local message_29602="${1}"
    local color_29603="${2}"
    # Prints an error message with a specified color.
    local array_475=("${message_29602}")
    eprintf__2447_v0 "\\x1b[${color_29603}m%s\\x1b[0m" array_475[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2463_v0() {
    local format_29614="${1}"
    local args_29615=("${!2}")
    args_29615=("${format_29614}" "${args_29615[@]}")
    __status=$?
    printf "${args_29615[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_124="None"
# perl_available()
perl_available__2470_v0() {
    if [ "$([ "_${_perl_state_124}" != "_None" ]; echo $?)" != 0 ]; then
        local command_476
        command_476="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29560
        disabled_29560="$([ "_${command_476}" != "_No" ]; echo $?)"
        local command_477
        command_477="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29561
        found_29561="$(( $(( ! disabled_29560 )) && $([ "_${command_477}" != "_0" ]; echo $?) ))"
        _perl_state_124="$(if [ "${found_29561}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2470_v0="$([ "_${_perl_state_124}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2471_v0() {
    local text_29559="${1}"
    perl_available__2470_v0 
    local ret_perl_available2470_v0__19_12="${ret_perl_available2470_v0}"
    if [ "$(( ! ret_perl_available2470_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return 1
    fi
    local command_478
    command_478="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29559}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return "${__status}"
    fi
    local width_str_29562="${command_478}"
    parse_int__13_v0 "${width_str_29562}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return "${__status}"
    fi
    local width_29563="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2471_v0="${width_29563}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2476_v0() {
    local text_29549="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_479
    command_479="$([[ "${text_29549}" == *$'\x1b'* || "${text_29549}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29550="${command_479}"
    ret_has_ansi_escape2476_v0="$([ "_${has_escape_29550}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2478_v0() {
    local text_29555="${1}"
    local command_480
    command_480="$(printf "%s" "${text_29555}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2478_v0="${command_480}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2479_v0() {
    local text_29557="${1}"
    local command_481
    command_481="$(printf "%s" "${text_29557}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29558="${command_481}"
    ret_is_all_ascii2479_v0="$([ "_${result_29558}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2480_v0() {
    local text_29552="${1}"
    local command_482
    command_482="$(LC_ALL=C; __t="${text_29552}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29553="${command_482}"
    parse_int__13_v0 "${measured_29553}"
    __status=$?
    ret_plain_len2480_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2481_v0() {
    local text_29551="${1}"
    plain_len__2480_v0 "${text_29551}"
    local plain_29554="${ret_plain_len2480_v0}"
    if [ "$(( plain_29554 >= 0 ))" != 0 ]; then
        ret_get_visible_len2481_v0="${plain_29554}"
        return 0
    fi
    strip_ansi__2478_v0 "${text_29551}"
    local stripped_29556="${ret_strip_ansi2478_v0}"
    is_all_ascii__2479_v0 "${stripped_29556}"
    local ret_is_all_ascii2479_v0__46_12="${ret_is_all_ascii2479_v0}"
    if [ "$(( ! ret_is_all_ascii2479_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2471_v0 "${stripped_29556}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_483="${stripped_29556}"
            ret_get_visible_len2481_v0="${#__length_483}"
            return 0
        fi
        ret_get_visible_len2481_v0="${ret_perl_get_cjk_width2471_v0}"
        return 0
    fi
    local __length_484="${stripped_29556}"
    ret_get_visible_len2481_v0="${#__length_484}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_125=0
_term_size_126=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2487_v0() {
    local command_486
    command_486="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_29612="${command_486}"
    parse_int__13_v0 "${count_29612}"
    __status=$?
    ret_stty_count2487_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2488_v0() {
    stty_count__2487_v0 
    local count_num_29613="${ret_stty_count2487_v0}"
    if [ "$(( count_num_29613 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_29613="$(( count_num_29613 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29613}
    __status=$?
}

# stty_unlock()
stty_unlock__2489_v0() {
    stty_count__2487_v0 
    local count_num_29707="${ret_stty_count2487_v0}"
    if [ "$(( count_num_29707 > 0 ))" != 0 ]; then
        count_num_29707="$(( count_num_29707 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29707}
        __status=$?
        if [ "$(( count_num_29707 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2490_v0() {
    local size_29540="${1}"
    if [ "$([ "_${size_29540}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2490_v0=0
        return 0
    fi
    split__4_v0 "${size_29540}" " "
    local parts_29541=("${ret_split4_v0[@]}")
    local __length_487=("${parts_29541[@]}")
    if [ "$(( ${#__length_487[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2490_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29541[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29541[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_126=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2490_v0=1
    return 0
}

# query_term_size()
query_term_size__2491_v0() {
    local command_489
    command_489="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29543="${command_489}"
    store_term_size__2490_v0 "${size_29543}"
    ret_query_term_size2491_v0="${ret_store_term_size2490_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2492_v0() {
    local command_490
    command_490="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29539="${command_490}"
    store_term_size__2490_v0 "${size_29539}"
    ret_stty_term_size2492_v0="${ret_store_term_size2490_v0}"
    return 0
}

# get_term_size()
get_term_size__2493_v0() {
    stty_term_size__2492_v0 
    local detected_29542="${ret_stty_term_size2492_v0}"
    if [ "$(( ! detected_29542 ))" != 0 ]; then
        query_term_size__2491_v0 
        detected_29542="${ret_query_term_size2491_v0}"
    fi
    _got_term_size_125=1
}

# term_width()
term_width__2495_v0() {
    if [ "$(( ! _got_term_size_125 ))" != 0 ]; then
        get_term_size__2493_v0 
    fi
    ret_term_width2495_v0="${_term_size_126[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2498_v0() {
    local cnt_29704="${1}"
    if [ "$(( cnt_29704 > 0 ))" != 0 ]; then
        local sequence_29705=""
        local __range_start_29706=0
        local __range_end_29706="${cnt_29704}"
        local __dir_29706=$(( ${__range_start_29706} <= ${__range_end_29706} ? 1 : -1 ))
        for (( ____29706=${__range_start_29706}; ____29706 * ${__dir_29706} < ${__range_end_29706} * ${__dir_29706}; ____29706+=${__dir_29706} )); do
            sequence_29705+="\\x1b[2K\\x1b[1A"
done
        local array_491=("")
        eprintf__2463_v0 "${sequence_29705}" array_491[@]
    fi
    local array_492=("")
    eprintf__2463_v0 "\\x1b[G" array_492[@]
}

# remove_current_line()
remove_current_line__2499_v0() {
    local array_493=("")
    eprintf__2463_v0 "\\x1b[2K\\x1b[G" array_493[@]
}

# go_up(cnt: Int)
go_up__2502_v0() {
    local cnt_29700="${1}"
    local array_494=("")
    eprintf__2463_v0 "\\x1b[${cnt_29700}A" array_494[@]
}

# go_down(cnt: Int)
go_down__2503_v0() {
    local cnt_29703="${1}"
    local array_495=("")
    eprintf__2463_v0 "\\x1b[${cnt_29703}B" array_495[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__2505_v0() {
    local array_496=("")
    eprintf__2463_v0 "\\x1b[?25l" array_496[@]
}

# show_cursor()
show_cursor__2506_v0() {
    local array_497=("")
    eprintf__2463_v0 "\\x1b[?25h" array_497[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__2507_v0() {
    local pieces_29538=("${!1}")
    term_width__2495_v0 
    local width_29544="${ret_term_width2495_v0}"
    local line_29545=""
    local line_len_29546=0
    for piece_29547 in "${pieces_29538[@]}"; do
        local __length_500="${piece_29547}"
        local piece_len_29548="${#__length_500}"
        has_ansi_escape__2476_v0 "${piece_29547}"
        local ret_has_ansi_escape2476_v0__186_12="${ret_has_ansi_escape2476_v0}"
        if [ "${ret_has_ansi_escape2476_v0__186_12}" != 0 ]; then
            get_visible_len__2481_v0 "${piece_29547}"
            piece_len_29548="${ret_get_visible_len2481_v0}"
        fi
        if [ "$([ "_${line_29545}" != "_" ]; echo $?)" != 0 ]; then
            line_29545="${piece_29547}"
            line_len_29546="${piece_len_29548}"
        elif [ "$(( $(( $(( line_len_29546 + 1 )) + piece_len_29548 )) > width_29544 ))" != 0 ]; then
            local array_501=()
            printf__128_v0 "${line_29545}""
" array_501[@]
            line_29545="${piece_29547}"
            line_len_29546="${piece_len_29548}"
        else
            line_29545+=" ""${piece_29547}"
            line_len_29546="$(( line_len_29546 + $(( 1 + piece_len_29548 )) ))"
        fi
    done
    if [ "$([ "_${line_29545}" == "_" ]; echo $?)" != 0 ]; then
        local array_502=()
        printf__128_v0 "${line_29545}""
" array_502[@]
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
get_supports_truecolor__2544_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_29533="${ret_env_var_get120_v0}"
    _supports_truecolor_129="$(if [ "$([ "_${config_29533}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2544_v0="$([ "_${_supports_truecolor_129}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2545_v0() {
    local message_29528="${1}"
    local r_29529="${2}"
    local g_29530="${3}"
    local b_29531="${4}"
    local fallback_29532="${5}"
    if [ "$([ "_${_supports_truecolor_129}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2545_v0="\\x1b[38;2;${r_29529};${g_29530};${b_29531}m""${message_29528}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_129}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2544_v0 
        local ret_get_supports_truecolor2544_v0__45_17="${ret_get_supports_truecolor2544_v0}"
        if [ "${ret_get_supports_truecolor2544_v0__45_17}" != 0 ]; then
            ret_colored_rgb2545_v0="\\x1b[38;2;${r_29529};${g_29530};${b_29531}m""${message_29528}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_29532 == 0 ))" != 0 ]; then
            ret_colored_rgb2545_v0="${message_29528}"
            return 0
        else
            ret_colored_rgb2545_v0="\\x1b[${fallback_29532}m""${message_29528}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_29532 == 0 ))" != 0 ]; then
            ret_colored_rgb2545_v0="${message_29528}"
            return 0
        fi
        ret_colored_rgb2545_v0="\\x1b[${fallback_29532}m""${message_29528}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__2546_v0() {
    local message_29677="${1}"
    local r_29678="${2}"
    local g_29679="${3}"
    local b_29680="${4}"
    local fallback_29681="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_29682="${fallback_29681}"
    if [ "$(( $(( fallback_29681 >= 30 )) && $(( fallback_29681 <= 37 )) ))" != 0 ]; then
        bg_fallback_29682="$(( fallback_29681 + 10 ))"
    fi
    if [ "$(( $(( fallback_29681 >= 90 )) && $(( fallback_29681 <= 97 )) ))" != 0 ]; then
        bg_fallback_29682="$(( fallback_29681 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_129}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb2546_v0="\\x1b[48;2;${r_29678};${g_29679};${b_29680}m""${message_29677}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_129}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2544_v0 
        local ret_get_supports_truecolor2544_v0__87_17="${ret_get_supports_truecolor2544_v0}"
        if [ "${ret_get_supports_truecolor2544_v0__87_17}" != 0 ]; then
            ret_background_rgb2546_v0="\\x1b[48;2;${r_29678};${g_29679};${b_29680}m""${message_29677}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_29682 == 0 ))" != 0 ]; then
            ret_background_rgb2546_v0="${message_29677}"
            return 0
        else
            ret_background_rgb2546_v0="\\x1b[${bg_fallback_29682}m""${message_29677}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_29682 == 0 ))" != 0 ]; then
            ret_background_rgb2546_v0="${message_29677}"
            return 0
        fi
        ret_background_rgb2546_v0="\\x1b[${bg_fallback_29682}m""${message_29677}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2547_v0() {
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_29522="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_29522}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_29522}" ";"
            local parts_29523=("${ret_split4_v0[@]}")
            local __length_506=("${parts_29523[@]}")
            if [ "$(( ${#__length_506[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29523[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29523[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29523[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29523[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_131=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_29524="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_29524}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_29524}" ";"
            local parts_29525=("${ret_split4_v0[@]}")
            local __length_508=("${parts_29525[@]}")
            if [ "$(( ${#__length_508[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29525[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_132=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_29526="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_29526}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_29526}" ";"
            local parts_29527=("${ret_split4_v0[@]}")
            local __length_510=("${parts_29527[@]}")
            if [ "$(( ${#__length_510[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29527[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29527[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29527[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29527[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_130=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2548_v0() {
    inner_get_xylitol_colors__2547_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_130=1
}

# colored_primary(message: Text)
colored_primary__2549_v0() {
    local message_29521="${1}"
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    colored_rgb__2545_v0 "${message_29521}" "${_primary_color_131[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_131[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_131[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_131[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2549_v0="${ret_colored_rgb2545_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2550_v0() {
    local message_29565="${1}"
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    colored_rgb__2545_v0 "${message_29565}" "${_secondary_color_132[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_132[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_132[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_132[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2550_v0="${ret_colored_rgb2545_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__2553_v0() {
    local message_29676="${1}"
    if [ "$(( ! _got_xylitol_colors_130 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    background_rgb__2546_v0 "${message_29676}" "${_secondary_color_132[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_132[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_132[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_132[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary2553_v0="${ret_background_rgb2546_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_134="None"
# perl_available()
perl_available__2567_v0() {
    if [ "$([ "_${_perl_state_134}" != "_None" ]; echo $?)" != 0 ]; then
        local command_512
        command_512="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29628
        disabled_29628="$([ "_${command_512}" != "_No" ]; echo $?)"
        local command_513
        command_513="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29629
        found_29629="$(( $(( ! disabled_29628 )) && $([ "_${command_513}" != "_0" ]; echo $?) ))"
        _perl_state_134="$(if [ "${found_29629}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2567_v0="$([ "_${_perl_state_134}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2568_v0() {
    local text_29627="${1}"
    perl_available__2567_v0 
    local ret_perl_available2567_v0__19_12="${ret_perl_available2567_v0}"
    if [ "$(( ! ret_perl_available2567_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return 1
    fi
    local command_514
    command_514="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29627}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return "${__status}"
    fi
    local width_str_29630="${command_514}"
    parse_int__13_v0 "${width_str_29630}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return "${__status}"
    fi
    local width_29631="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2568_v0="${width_29631}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2569_v0() {
    local text_29638="${1}"
    local max_width_29639="${2}"
    perl_available__2567_v0 
    local ret_perl_available2567_v0__30_12="${ret_perl_available2567_v0}"
    if [ "$(( ! ret_perl_available2567_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2569_v0=''
        return 1
    fi
    local command_515
    command_515="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_29638}" ${max_width_29639} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2569_v0=''
        return "${__status}"
    fi
    local result_29640="${command_515}"
    ret_perl_truncate_cjk2569_v0="${result_29640}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2573_v0() {
    local text_29606="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_516
    command_516="$([[ "${text_29606}" == *$'\x1b'* || "${text_29606}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29607="${command_516}"
    ret_has_ansi_escape2573_v0="$([ "_${has_escape_29607}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2574_v0() {
    local text_29608="${1}"
    local command_517
    command_517="$(printf '%s' "${text_29608}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2574_v0="${command_517}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2575_v0() {
    local text_29623="${1}"
    local command_518
    command_518="$(printf "%s" "${text_29623}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2575_v0="${command_518}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2576_v0() {
    local text_29625="${1}"
    local command_519
    command_519="$(printf "%s" "${text_29625}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29626="${command_519}"
    ret_is_all_ascii2576_v0="$([ "_${result_29626}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2577_v0() {
    local text_29620="${1}"
    local command_520
    command_520="$(LC_ALL=C; __t="${text_29620}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29621="${command_520}"
    parse_int__13_v0 "${measured_29621}"
    __status=$?
    ret_plain_len2577_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2578_v0() {
    local text_29619="${1}"
    plain_len__2577_v0 "${text_29619}"
    local plain_29622="${ret_plain_len2577_v0}"
    if [ "$(( plain_29622 >= 0 ))" != 0 ]; then
        ret_get_visible_len2578_v0="${plain_29622}"
        return 0
    fi
    strip_ansi__2575_v0 "${text_29619}"
    local stripped_29624="${ret_strip_ansi2575_v0}"
    is_all_ascii__2576_v0 "${stripped_29624}"
    local ret_is_all_ascii2576_v0__46_12="${ret_is_all_ascii2576_v0}"
    if [ "$(( ! ret_is_all_ascii2576_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2568_v0 "${stripped_29624}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_521="${stripped_29624}"
            ret_get_visible_len2578_v0="${#__length_521}"
            return 0
        fi
        ret_get_visible_len2578_v0="${ret_perl_get_cjk_width2568_v0}"
        return 0
    fi
    local __length_522="${stripped_29624}"
    ret_get_visible_len2578_v0="${#__length_522}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2579_v0() {
    local text_29635="${1}"
    local max_width_29636="${2}"
    get_visible_len__2578_v0 "${text_29635}"
    local visible_len_29637="${ret_get_visible_len2578_v0}"
    if [ "$(( visible_len_29637 <= max_width_29636 ))" != 0 ]; then
        ret_truncate_text2579_v0="${text_29635}"
        return 0
    fi
    is_all_ascii__2576_v0 "${text_29635}"
    local ret_is_all_ascii2576_v0__61_12="${ret_is_all_ascii2576_v0}"
    if [ "$(( ! ret_is_all_ascii2576_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__2569_v0 "${text_29635}" "${max_width_29636}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_29635}" | cut -c1-${max_width_29636}
            __status=$?
        fi
        ret_truncate_text2579_v0="${ret_perl_truncate_cjk2569_v0}"
        return 0
    fi
    local command_523
    command_523="$(printf "%s" "${text_29635}" | cut -c1-${max_width_29636})"
    __status=$?
    ret_truncate_text2579_v0="${command_523}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2580_v0() {
    local text_29633="${1}"
    local max_width_29634="${2}"
    has_ansi_escape__2573_v0 "${text_29633}"
    local ret_has_ansi_escape2573_v0__73_12="${ret_has_ansi_escape2573_v0}"
    if [ "$(( ! ret_has_ansi_escape2573_v0__73_12 ))" != 0 ]; then
        truncate_text__2579_v0 "${text_29633}" "${max_width_29634}"
        ret_truncate_ansi2580_v0="${ret_truncate_text2579_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_524
    command_524="$([[ "${text_29633}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_29641="${command_524}"
    # Replace \x1b[ with newline, then split
    local command_525
    command_525="$(t="${text_29633}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_29642="${command_525}"
    split__4_v0 "${replaced_29642}" "
"
    local parts_29643=("${ret_split4_v0[@]}")
    local result_29644=""
    local remaining_width_29645="${max_width_29634}"
    local __range_start_29646=0
    local __length_526=("${parts_29643[@]}")
    local __range_end_29646="${#__length_526[@]}"
    local __dir_29646=$(( ${__range_start_29646} <= ${__range_end_29646} ? 1 : -1 ))
    for (( idx_29646=${__range_start_29646}; idx_29646 * ${__dir_29646} < ${__range_end_29646} * ${__dir_29646}; idx_29646+=${__dir_29646} )); do
        local part_29647="${parts_29643[${idx_29646}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_29646 == 0 )) && $([ "_${starts_with_ansi_29641}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_29647}" == "_" ]; echo $?) && $(( remaining_width_29645 > 0 )) ))" != 0 ]; then
                truncate_text__2579_v0 "${part_29647}" "${remaining_width_29645}"
                local ret_truncate_text2579_v0__95_35="${ret_truncate_text2579_v0}"
                local truncated_29648="${ret_truncate_text2579_v0__95_35}"
                result_29644+="${truncated_29648}"
                get_visible_len__2578_v0 "${truncated_29648}"
                local ret_get_visible_len2578_v0__97_36="${ret_get_visible_len2578_v0}"
                remaining_width_29645="$(( remaining_width_29645 - ret_get_visible_len2578_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_527
            command_527="$(__p="${part_29647}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_29649="${command_527}"
            if [ "$([ "_${m_idx_29649}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_528
                command_528="$(__p="${part_29647}"; printf "%s" "${__p:0:${m_idx_29649}}")"
                __status=$?
                local ansi_params_29650="${command_528}"
                result_29644+="\\x1b[""${ansi_params_29650}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_29649}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_29651="${ret_parse_int13_v0__108_41}"
                local text_start_29652="$(( m_idx_num_29651 + 1 ))"
                local command_529
                command_529="$(__p="${part_29647}"; printf "%s" "${__p:${text_start_29652}}")"
                __status=$?
                local text_part_29653="${command_529}"
                if [ "$(( $([ "_${text_part_29653}" == "_" ]; echo $?) && $(( remaining_width_29645 > 0 )) ))" != 0 ]; then
                    truncate_text__2579_v0 "${text_part_29653}" "${remaining_width_29645}"
                    local ret_truncate_text2579_v0__112_39="${ret_truncate_text2579_v0}"
                    local truncated_29654="${ret_truncate_text2579_v0__112_39}"
                    result_29644+="${truncated_29654}"
                    get_visible_len__2578_v0 "${truncated_29654}"
                    local ret_get_visible_len2578_v0__114_40="${ret_get_visible_len2578_v0}"
                    remaining_width_29645="$(( remaining_width_29645 - ret_get_visible_len2578_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_29647}" == "_" ]; echo $?) && $(( remaining_width_29645 > 0 )) ))" != 0 ]; then
                    truncate_text__2579_v0 "${part_29647}" "${remaining_width_29645}"
                    local ret_truncate_text2579_v0__119_39="${ret_truncate_text2579_v0}"
                    local truncated_29655="${ret_truncate_text2579_v0__119_39}"
                    result_29644+="${truncated_29655}"
                    get_visible_len__2578_v0 "${truncated_29655}"
                    local ret_get_visible_len2578_v0__121_40="${ret_get_visible_len2578_v0}"
                    remaining_width_29645="$(( remaining_width_29645 - ret_get_visible_len2578_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2580_v0="${result_29644}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2581_v0() {
    local text_29617="${1}"
    local max_width_29618="${2}"
    get_visible_len__2578_v0 "${text_29617}"
    local visible_len_29632="${ret_get_visible_len2578_v0}"
    if [ "$(( visible_len_29632 <= max_width_29618 ))" != 0 ]; then
        ret_cutoff_text2581_v0="${text_29617}"
        return 0
    fi
    truncate_ansi__2580_v0 "${text_29617}" "$(( max_width_29618 - 3 ))"
    local ret_truncate_ansi2580_v0__137_12="${ret_truncate_ansi2580_v0}"
    ret_cutoff_text2581_v0="${ret_truncate_ansi2580_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2602_v0() {
    local format_29691="${1}"
    local args_29692=("${!2}")
    args_29692=("${format_29691}" "${args_29692[@]}")
    __status=$?
    printf "${args_29692[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2603_v0() {
    local message_29689="${1}"
    local color_29690="${2}"
    # Prints an error message with a specified color.
    local array_530=("${message_29689}")
    eprintf__2602_v0 "\\x1b[${color_29690}m%s\\x1b[0m" array_530[@]
}

# colored(message: Text, color: Int)
colored__2604_v0() {
    local message_29599="${1}"
    local color_29600="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2604_v0="\\x1b[${color_29600}m""${message_29599}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2608_v0() {
    local items_29683=("${!1}")
    local total_len_29684="${2}"
    local term_width_29685="${3}"
    local separator_29686=" • "
    local separator_len_29687=3
    # Fast path: no truncation needed
    if [ "$(( total_len_29684 <= term_width_29685 ))" != 0 ]; then
        local iter_29688=0
        while :
        do
            local __length_531=("${items_29683[@]}")
            if [ "$(( iter_29688 >= ${#__length_531[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_29688 > 0 ))" != 0 ]; then
                eprintf_colored__2603_v0 "${separator_29686}" 90
            fi
            colored__2604_v0 "${items_29683[$(( iter_29688 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2604_v0__23_41="${ret_colored2604_v0}"
            local array_532=("")
            eprintf__2602_v0 "${items_29683[${iter_29688}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2604_v0__23_41}" array_532[@]
            iter_29688="$(( iter_29688 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_29693=0
        local first_29694=1
        local iter_29695=0
        while :
        do
            local __length_533=("${items_29683[@]}")
            if [ "$(( iter_29695 >= ${#__length_533[@]} ))" != 0 ]; then
                break
            fi
            local key_29696="${items_29683[${iter_29695}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_29697="${items_29683[$(( iter_29695 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_534="${key_29696}"
            local __length_535="${action_29697}"
            local part_len_29698="$(( $(( ${#__length_534} + 1 )) + ${#__length_535} ))"
            local needed_29699="${part_len_29698}"
            if [ "$(( ! first_29694 ))" != 0 ]; then
                needed_29699="$(( needed_29699 + separator_len_29687 ))"
            fi
            if [ "$(( $(( current_len_29693 + needed_29699 )) > term_width_29685 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_29694 ))" != 0 ]; then
                eprintf_colored__2603_v0 "${separator_29686}" 90
            fi
            colored__2604_v0 "${action_29697}" 2
            local ret_colored2604_v0__51_33="${ret_colored2604_v0}"
            local array_536=("")
            eprintf__2602_v0 "${key_29696}"" ""${ret_colored2604_v0__51_33}" array_536[@]
            current_len_29693="$(( current_len_29693 + needed_29699 ))"
            first_29694=0
            iter_29695="$(( iter_29695 + 2 ))"
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
store_term_size__2645_v0() {
    local size_29578="${1}"
    if [ "$([ "_${size_29578}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2645_v0=0
        return 0
    fi
    split__4_v0 "${size_29578}" " "
    local parts_29579=("${ret_split4_v0[@]}")
    local __length_538=("${parts_29579[@]}")
    if [ "$(( ${#__length_538[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2645_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29579[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29579[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_138=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2645_v0=1
    return 0
}

# query_term_size()
query_term_size__2646_v0() {
    local command_540
    command_540="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29581="${command_540}"
    store_term_size__2645_v0 "${size_29581}"
    ret_query_term_size2646_v0="${ret_store_term_size2645_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2647_v0() {
    local command_541
    command_541="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29577="${command_541}"
    store_term_size__2645_v0 "${size_29577}"
    ret_stty_term_size2647_v0="${ret_store_term_size2645_v0}"
    return 0
}

# get_term_size()
get_term_size__2648_v0() {
    stty_term_size__2647_v0 
    local detected_29580="${ret_stty_term_size2647_v0}"
    if [ "$(( ! detected_29580 ))" != 0 ]; then
        query_term_size__2646_v0 
        detected_29580="${ret_query_term_size2646_v0}"
    fi
    _got_term_size_137=1
}

# term_width()
term_width__2650_v0() {
    if [ "$(( ! _got_term_size_137 ))" != 0 ]; then
        get_term_size__2648_v0 
    fi
    ret_term_width2650_v0="${_term_size_138[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2683_v0() {
    local pending_29596="${1}"
    local line_29597="${2}"
    local note_at_29598="${3}"
    if [ "$(( note_at_29598 < 0 ))" != 0 ]; then
        local array_543=()
        printf__128_v0 "${pending_29596}""${line_29597}""
" array_543[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_29598 == 0 ))" != 0 ]; then
        colored__2604_v0 "${line_29597}" 90
        local ret_colored2604_v0__12_40="${ret_colored2604_v0}"
        local array_544=()
        printf__128_v0 "${pending_29596}""${ret_colored2604_v0__12_40}""
" array_544[@]
    else
        slice__24_v0 "${line_29597}" 0 "${note_at_29598}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_29597}" "${note_at_29598}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2604_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2604_v0__13_58="${ret_colored2604_v0}"
        local array_545=()
        printf__128_v0 "${pending_29596}""${ret_slice24_v0__13_32}""${ret_colored2604_v0__13_58}""
" array_545[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2684_v0() {
    local names_29569=("${!1}")
    local texts_29570=("${!2}")
    local notes_29571=("${!3}")
    local min_name_width_29572="${4}"
    local __length_546=("${names_29569[@]}")
    local count_29573="${#__length_546[@]}"
    local name_width_29574="${min_name_width_29572}"
    local __range_start_29575=0
    local __range_end_29575="${count_29573}"
    local __dir_29575=$(( ${__range_start_29575} <= ${__range_end_29575} ? 1 : -1 ))
    for (( i_29575=${__range_start_29575}; i_29575 * ${__dir_29575} < ${__range_end_29575} * ${__dir_29575}; i_29575+=${__dir_29575} )); do
        local __length_547="${names_29569[${i_29575}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_29576="${#__length_547}"
        if [ "$(( width_29576 > name_width_29574 ))" != 0 ]; then
            name_width_29574="${width_29576}"
        fi
done
    term_width__2650_v0 
    local width_29582="${ret_term_width2650_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_29583="$(( name_width_29574 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_29584="$(( $(( width_29582 - indent_29583 )) < 24 ))"
    if [ "${stacked_29584}" != 0 ]; then
        indent_29583=6
    fi
    local avail_29585="$(( width_29582 - indent_29583 ))"
    rpad__28_v0 "" " " "${indent_29583}"
    local blank_29586="${ret_rpad28_v0}"
    local __range_start_29587=0
    local __range_end_29587="${count_29573}"
    local __dir_29587=$(( ${__range_start_29587} <= ${__range_end_29587} ? 1 : -1 ))
    for (( i_29587=${__range_start_29587}; i_29587 * ${__dir_29587} < ${__range_end_29587} * ${__dir_29587}; i_29587+=${__dir_29587} )); do
        local pending_29588="${blank_29586}"
        if [ "${stacked_29584}" != 0 ]; then
            local array_548=()
            printf__128_v0 "  ""${names_29569[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_548[@]
        else
            rpad__28_v0 "  ""${names_29569[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_29583}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_29588="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_29570[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_29589=("${ret_split4_v0__52_21[@]}")
        local __length_549=("${words_29589[@]}")
        local note_start_29590="${#__length_549[@]}"
        if [ "$([ "_${notes_29571[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_550="${notes_29571[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_550} > avail_29585 ))" != 0 ]; then
                split__4_v0 "${notes_29571[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_29589+=("${ret_split4_v0__58_26[@]}")
            else
                local array_551=("${notes_29571[${i_29587}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_29589+=("${array_551[@]}")
            fi
        fi
        local line_29591=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_29592=-1
        local __range_start_29593=0
        local __length_552=("${words_29589[@]}")
        local __range_end_29593="${#__length_552[@]}"
        local __dir_29593=$(( ${__range_start_29593} <= ${__range_end_29593} ? 1 : -1 ))
        for (( j_29593=${__range_start_29593}; j_29593 * ${__dir_29593} < ${__range_end_29593} * ${__dir_29593}; j_29593+=${__dir_29593} )); do
            local word_29594="${words_29589[${j_29593}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_29595
            candidate_29595="$(if [ "$([ "_${line_29591}" != "_" ]; echo $?)" != 0 ]; then echo "${word_29594}"; else echo "${line_29591}"" ""${word_29594}"; fi)"
            local __length_553="${candidate_29595}"
            if [ "$(( $(( ${#__length_553} > avail_29585 )) && $([ "_${line_29591}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2683_v0 "${pending_29588}" "${line_29591}" "${note_at_29592}"
                pending_29588="${blank_29586}"
                line_29591="${word_29594}"
                note_at_29592="$(if [ "$(( j_29593 >= note_start_29590 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_29593 >= note_start_29590 )) && $(( note_at_29592 < 0 )) ))" != 0 ]; then
                    local __length_554="${candidate_29595}"
                    local __length_555="${word_29594}"
                    note_at_29592="$(( ${#__length_554} - ${#__length_555} ))"
                fi
                line_29591="${candidate_29595}"
            fi
done
        print_help_line__2683_v0 "${pending_29588}" "${line_29591}" "${note_at_29592}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2742_v0() {
    local selected_29657="${1}"
    local term_width_29658="${2}"
    local small_29659="$(( term_width_29658 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_29659}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_29673="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_29659}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_29674="${ret_cpad29_v0}"
    local gap_29675
    gap_29675="$(if [ "${small_29659}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_556=("")
    eprintf__2447_v0 " " array_556[@]
    if [ "${selected_29657}" != 0 ]; then
        # Yes selected
        background_secondary__2553_v0 "${yes_label_29673}"
        local ret_background_secondary2553_v0__16_30="${ret_background_secondary2553_v0}"
        local array_557=("")
        eprintf__2447_v0 "\\x1b[97m""${ret_background_secondary2553_v0__16_30}" array_557[@]
        local array_558=("")
        eprintf__2447_v0 "${gap_29675}" array_558[@]
        # No not selected (dim)
        local array_559=("")
        eprintf__2447_v0 "\\x1b[49;37m""${no_label_29674}""\\x1b[0m" array_559[@]
    else
        # No selected
        local array_560=("")
        eprintf__2447_v0 "\\x1b[49;37m""${yes_label_29673}""\\x1b[0m" array_560[@]
        local array_561=("")
        eprintf__2447_v0 "${gap_29675}" array_561[@]
        background_secondary__2553_v0 "${no_label_29674}"
        local ret_background_secondary2553_v0__24_30="${ret_background_secondary2553_v0}"
        local array_562=("")
        eprintf__2447_v0 "\\x1b[97m""${ret_background_secondary2553_v0__24_30}" array_562[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2743_v0() {
    local header_29610="${1}"
    local default_yes_29611="${2}"
    stty_lock__2488_v0 
    hide_cursor__2505_v0 
    term_width__2495_v0 
    local term_width_29616="${ret_term_width2495_v0}"
    if [ "$([ "_${header_29610}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2581_v0 "${header_29610}" "${term_width_29616}"
        local ret_cutoff_text2581_v0__46_17="${ret_cutoff_text2581_v0}"
        local array_563=("")
        eprintf__2447_v0 "${ret_cutoff_text2581_v0__46_17}""

" array_563[@]
    fi
    local selected_29656="${default_yes_29611}"
    # Render initial options
    render_confirm_options__2742_v0 "${selected_29656}" "${term_width_29616}"
    local array_564=("")
    eprintf__2447_v0 "

" array_564[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_565=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2608_v0 array_565[@] 40 "${term_width_29616}"
    go_up__2502_v0 2
    while :
    do
        get_key__2445_v0 
        local key_29701="${ret_get_key2445_v0}"
        if [ "$(( $(( $(( $([ "_${key_29701}" != "_LEFT" ]; echo $?) || $([ "_${key_29701}" != "_h" ]; echo $?) )) || $([ "_${key_29701}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_29701}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_29656}" != 0 ]; then
                selected_29656=0
                local array_566=("")
                eprintf__2447_v0 "\\x1b[G\\x1b[K" array_566[@]
                render_confirm_options__2742_v0 "${selected_29656}" "${term_width_29616}"
            elif [ "$(( ! selected_29656 ))" != 0 ]; then
                selected_29656=1
                local array_567=("")
                eprintf__2447_v0 "\\x1b[G\\x1b[K" array_567[@]
                render_confirm_options__2742_v0 "${selected_29656}" "${term_width_29616}"
            fi
        elif [ "$(( $([ "_${key_29701}" != "_y" ]; echo $?) || $([ "_${key_29701}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_29656=1
            break
        elif [ "$(( $([ "_${key_29701}" != "_n" ]; echo $?) || $([ "_${key_29701}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_29656=0
            break
        elif [ "$(( $([ "_${key_29701}" != "_INPUT" ]; echo $?) || $([ "_${key_29701}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_29702=4
    if [ "$([ "_${header_29610}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_29702="$(( total_lines_29702 + 1 ))"
    fi
    go_down__2503_v0 2
    remove_line__2498_v0 "$(( total_lines_29702 - 1 ))"
    remove_current_line__2499_v0 
    stty_unlock__2489_v0 
    show_cursor__2506_v0 
    ret_xyl_confirm2743_v0="${selected_29656}"
    return 0
}

# print_confirm_help()
print_confirm_help__2843_v0() {
    local usage_29537=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__2507_v0 usage_29537[@]
    printf '%s\n' ""
    colored_primary__2549_v0 "confirm"
    local ret_colored_primary2549_v0__8_20="${ret_colored_primary2549_v0}"
    local title_29564=("${ret_colored_primary2549_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__2507_v0 title_29564[@]
    printf '%s\n' ""
    colored_secondary__2550_v0 "Flags:"
    local ret_colored_secondary2550_v0__11_12="${ret_colored_secondary2550_v0}"
    local array_570=()
    printf__128_v0 "${ret_colored_secondary2550_v0__11_12}""
" array_570[@]
    local names_29566=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_29567=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_29568=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2684_v0 names_29566[@] texts_29567[@] notes_29568[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2901_v0() {
    local parameters_29520=("${!1}")
    colored_primary__2549_v0 "Are you sure?"
    local ret_colored_primary2549_v0__9_30="${ret_colored_primary2549_v0}"
    local header_29534="\\x1b[1m""${ret_colored_primary2549_v0__9_30}"
    local default_yes_29535=1
    for param_29536 in "${parameters_29520[@]}"; do
        starts_with__22_v0 "${param_29536}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_29536}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_29536}" != "_-h" ]; echo $?) || $([ "_${param_29536}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2843_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_576="--header="
            slice__24_v0 "${param_29536}" "${#__length_576}" 0
            header_29534="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_577="--default="
            slice__24_v0 "${param_29536}" "${#__length_577}" 0
            local value_29601="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_29601}" != "_yes" ]; echo $?) || $([ "_${value_29601}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_29535=1
            elif [ "$(( $([ "_${value_29601}" != "_no" ]; echo $?) || $([ "_${value_29601}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_29535=0
            else
                eprintf_colored__2448_v0 "ERROR: Invalid default value: ""${value_29601}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2573_v0 "${header_29534}"
    local ret_has_ansi_escape2573_v0__35_44="${ret_has_ansi_escape2573_v0}"
    escape_ansi__2574_v0 "${header_29534}"
    local ret_escape_ansi2574_v0__35_73="${ret_escape_ansi2574_v0}"
    colored_primary__2549_v0 "${header_29534}"
    local ret_colored_primary2549_v0__35_111="${ret_colored_primary2549_v0}"
    local display_header_29609
    display_header_29609="$(if [ "$(( $([ "_${header_29534}" != "_" ]; echo $?) || ret_has_ansi_escape2573_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2574_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary2549_v0__35_111}"; fi)"
    xyl_confirm__2743_v0 "${display_header_29609}" "${default_yes_29535}"
    local result_29708="${ret_xyl_confirm2743_v0}"
    ret_execute_confirm2901_v0="$(if [ "${result_29708}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3019_v0() {
    local format_40126="${1}"
    local args_40127=("${!2}")
    args_40127=("${format_40126}" "${args_40127[@]}")
    __status=$?
    printf "${args_40127[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3020_v0() {
    local message_40124="${1}"
    local color_40125="${2}"
    # Prints an error message with a specified color.
    local array_578=("${message_40124}")
    eprintf__3019_v0 "\\x1b[${color_40125}m%s\\x1b[0m" array_578[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3035_v0() {
    local format_40156="${1}"
    local args_40157=("${!2}")
    args_40157=("${format_40156}" "${args_40157[@]}")
    __status=$?
    printf "${args_40157[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_146="None"
# perl_available()
perl_available__3042_v0() {
    if [ "$([ "_${_perl_state_146}" != "_None" ]; echo $?)" != 0 ]; then
        local command_579
        command_579="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40066
        disabled_40066="$([ "_${command_579}" != "_No" ]; echo $?)"
        local command_580
        command_580="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40067
        found_40067="$(( $(( ! disabled_40066 )) && $([ "_${command_580}" != "_0" ]; echo $?) ))"
        _perl_state_146="$(if [ "${found_40067}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3042_v0="$([ "_${_perl_state_146}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3043_v0() {
    local text_40065="${1}"
    perl_available__3042_v0 
    local ret_perl_available3042_v0__19_12="${ret_perl_available3042_v0}"
    if [ "$(( ! ret_perl_available3042_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return 1
    fi
    local command_581
    command_581="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40065}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return "${__status}"
    fi
    local width_str_40068="${command_581}"
    parse_int__13_v0 "${width_str_40068}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return "${__status}"
    fi
    local width_40069="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3043_v0="${width_40069}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3048_v0() {
    local text_40055="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_582
    command_582="$([[ "${text_40055}" == *$'\x1b'* || "${text_40055}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40056="${command_582}"
    ret_has_ansi_escape3048_v0="$([ "_${has_escape_40056}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3050_v0() {
    local text_40061="${1}"
    local command_583
    command_583="$(printf "%s" "${text_40061}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3050_v0="${command_583}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3051_v0() {
    local text_40063="${1}"
    local command_584
    command_584="$(printf "%s" "${text_40063}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40064="${command_584}"
    ret_is_all_ascii3051_v0="$([ "_${result_40064}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3052_v0() {
    local text_40058="${1}"
    local command_585
    command_585="$(LC_ALL=C; __t="${text_40058}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40059="${command_585}"
    parse_int__13_v0 "${measured_40059}"
    __status=$?
    ret_plain_len3052_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3053_v0() {
    local text_40057="${1}"
    plain_len__3052_v0 "${text_40057}"
    local plain_40060="${ret_plain_len3052_v0}"
    if [ "$(( plain_40060 >= 0 ))" != 0 ]; then
        ret_get_visible_len3053_v0="${plain_40060}"
        return 0
    fi
    strip_ansi__3050_v0 "${text_40057}"
    local stripped_40062="${ret_strip_ansi3050_v0}"
    is_all_ascii__3051_v0 "${stripped_40062}"
    local ret_is_all_ascii3051_v0__46_12="${ret_is_all_ascii3051_v0}"
    if [ "$(( ! ret_is_all_ascii3051_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3043_v0 "${stripped_40062}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_586="${stripped_40062}"
            ret_get_visible_len3053_v0="${#__length_586}"
            return 0
        fi
        ret_get_visible_len3053_v0="${ret_perl_get_cjk_width3043_v0}"
        return 0
    fi
    local __length_587="${stripped_40062}"
    ret_get_visible_len3053_v0="${#__length_587}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_147=0
_term_size_148=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__3059_v0() {
    local command_589
    command_589="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40132="${command_589}"
    parse_int__13_v0 "${count_40132}"
    __status=$?
    ret_stty_count3059_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3060_v0() {
    stty_count__3059_v0 
    local count_num_40133="${ret_stty_count3059_v0}"
    if [ "$(( count_num_40133 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40133="$(( count_num_40133 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40133}
    __status=$?
}

# stty_unlock()
stty_unlock__3061_v0() {
    stty_count__3059_v0 
    local count_num_40154="${ret_stty_count3059_v0}"
    if [ "$(( count_num_40154 > 0 ))" != 0 ]; then
        count_num_40154="$(( count_num_40154 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40154}
        __status=$?
        if [ "$(( count_num_40154 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3062_v0() {
    local size_40046="${1}"
    if [ "$([ "_${size_40046}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3062_v0=0
        return 0
    fi
    split__4_v0 "${size_40046}" " "
    local parts_40047=("${ret_split4_v0[@]}")
    local __length_590=("${parts_40047[@]}")
    if [ "$(( ${#__length_590[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3062_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40047[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40047[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_148=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3062_v0=1
    return 0
}

# query_term_size()
query_term_size__3063_v0() {
    local command_592
    command_592="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40049="${command_592}"
    store_term_size__3062_v0 "${size_40049}"
    ret_query_term_size3063_v0="${ret_store_term_size3062_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3064_v0() {
    local command_593
    command_593="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40045="${command_593}"
    store_term_size__3062_v0 "${size_40045}"
    ret_stty_term_size3064_v0="${ret_store_term_size3062_v0}"
    return 0
}

# get_term_size()
get_term_size__3065_v0() {
    stty_term_size__3064_v0 
    local detected_40048="${ret_stty_term_size3064_v0}"
    if [ "$(( ! detected_40048 ))" != 0 ]; then
        query_term_size__3063_v0 
        detected_40048="${ret_query_term_size3063_v0}"
    fi
    _got_term_size_147=1
}

# term_width()
term_width__3067_v0() {
    if [ "$(( ! _got_term_size_147 ))" != 0 ]; then
        get_term_size__3065_v0 
    fi
    ret_term_width3067_v0="${_term_size_148[0]?"Index out of bounds (at src/./file/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__3071_v0() {
    local array_594=("")
    eprintf__3035_v0 "\\x1b[2K\\x1b[G" array_594[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__3079_v0() {
    local pieces_40044=("${!1}")
    term_width__3067_v0 
    local width_40050="${ret_term_width3067_v0}"
    local line_40051=""
    local line_len_40052=0
    for piece_40053 in "${pieces_40044[@]}"; do
        local __length_597="${piece_40053}"
        local piece_len_40054="${#__length_597}"
        has_ansi_escape__3048_v0 "${piece_40053}"
        local ret_has_ansi_escape3048_v0__186_12="${ret_has_ansi_escape3048_v0}"
        if [ "${ret_has_ansi_escape3048_v0__186_12}" != 0 ]; then
            get_visible_len__3053_v0 "${piece_40053}"
            piece_len_40054="${ret_get_visible_len3053_v0}"
        fi
        if [ "$([ "_${line_40051}" != "_" ]; echo $?)" != 0 ]; then
            line_40051="${piece_40053}"
            line_len_40052="${piece_len_40054}"
        elif [ "$(( $(( $(( line_len_40052 + 1 )) + piece_len_40054 )) > width_40050 ))" != 0 ]; then
            local array_598=()
            printf__128_v0 "${line_40051}""
" array_598[@]
            line_40051="${piece_40053}"
            line_len_40052="${piece_len_40054}"
        else
            line_40051+=" ""${piece_40053}"
            line_len_40052="$(( line_len_40052 + $(( 1 + piece_len_40054 )) ))"
        fi
    done
    if [ "$([ "_${line_40051}" == "_" ]; echo $?)" != 0 ]; then
        local array_599=()
        printf__128_v0 "${line_40051}""
" array_599[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_149=3
# get_directory_entries(path: Text)
get_directory_entries__3101_v0() {
    local path_40137="${1}"
    local __ls_path_600="${path_40137}"
    __ls_path_600="${__ls_path_600//\\/\\\\}"
    (( 1 )) && __ls_all_600="-A" || __ls_all_600=""
    (( 0 )) && __ls_rec_600="-R" || __ls_rec_600=""
    local __ls_600=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_600 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_600} ${__ls_rec_600} ${__ls_path_600}
    __status=$?
    );
    local names_40138=("${__ls_600[@]}")
    local command_601
    command_601="$(LC_ALL=C ls -lA "${path_40137}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_40139="${command_601}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_602
    command_602="$(LC_ALL=C ls -lA "${path_40137}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_40140="${command_602}"
    split__4_v0 "${types_output_40139}" "
"
    local types_40141=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_40140}" "
"
    local targets_40142=("${ret_split4_v0[@]}")
    local entries_40143=()
    local __range_start_40144=0
    local __length_604=("${names_40138[@]}")
    local __range_end_40144="${#__length_604[@]}"
    local __dir_40144=$(( ${__range_start_40144} <= ${__range_end_40144} ? 1 : -1 ))
    for (( i_40144=${__range_start_40144}; i_40144 * ${__dir_40144} < ${__range_end_40144} * ${__dir_40144}; i_40144+=${__dir_40144} )); do
        local array_605=("${names_40138[${i_40144}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_40143+=("${array_605[@]}")
        local array_606=("${types_40141[${i_40144}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_40143+=("${array_606[@]}")
        slice__24_v0 "${targets_40142[${i_40144}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_607=("${ret_slice24_v0__31_21}")
        entries_40143+=("${array_607[@]}")
done
    ret_get_directory_entries3101_v0=("${entries_40143[@]}")
    return 0
}

# get_cwd()
get_cwd__3102_v0() {
    local command_608
    command_608="$(pwd)"
    __status=$?
    ret_get_cwd3102_v0="${command_608}"
    return 0
}

# normalize_path(path: Text)
normalize_path__3103_v0() {
    local path_40135="${1}"
    local command_609
    command_609="$(cd "${path_40135}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_40136="${command_609}"
    if [ "$([ "_${normalized_40136}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path3103_v0="${path_40135}"
        return 0
    fi
    ret_normalize_path3103_v0="${normalized_40136}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__3104_v0() {
    local base_40321="${1}"
    local child_40322="${2}"
    if [ "$([ "_${base_40321}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join3104_v0="/""${child_40322}"
        return 0
    fi
    ret_path_join3104_v0="${base_40321}""/""${child_40322}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__3105_v0() {
    local path_40319="${1}"
    local command_610
    command_610="$(dirname "${path_40319}")"
    __status=$?
    local parent_40320="${command_610}"
    ret_get_parent_dir3105_v0="${parent_40320}"
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
get_supports_truecolor__3116_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40082="${ret_env_var_get120_v0}"
    _supports_truecolor_151="$(if [ "$([ "_${config_40082}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3116_v0="$([ "_${_supports_truecolor_151}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3117_v0() {
    local message_40077="${1}"
    local r_40078="${2}"
    local g_40079="${3}"
    local b_40080="${4}"
    local fallback_40081="${5}"
    if [ "$([ "_${_supports_truecolor_151}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3117_v0="\\x1b[38;2;${r_40078};${g_40079};${b_40080}m""${message_40077}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_151}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3116_v0 
        local ret_get_supports_truecolor3116_v0__45_17="${ret_get_supports_truecolor3116_v0}"
        if [ "${ret_get_supports_truecolor3116_v0__45_17}" != 0 ]; then
            ret_colored_rgb3117_v0="\\x1b[38;2;${r_40078};${g_40079};${b_40080}m""${message_40077}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40081 == 0 ))" != 0 ]; then
            ret_colored_rgb3117_v0="${message_40077}"
            return 0
        else
            ret_colored_rgb3117_v0="\\x1b[${fallback_40081}m""${message_40077}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40081 == 0 ))" != 0 ]; then
            ret_colored_rgb3117_v0="${message_40077}"
            return 0
        fi
        ret_colored_rgb3117_v0="\\x1b[${fallback_40081}m""${message_40077}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3119_v0() {
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40071="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40071}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40071}" ";"
            local parts_40072=("${ret_split4_v0[@]}")
            local __length_614=("${parts_40072[@]}")
            if [ "$(( ${#__length_614[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40072[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40072[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40072[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40072[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_153=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40073="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40073}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40073}" ";"
            local parts_40074=("${ret_split4_v0[@]}")
            local __length_616=("${parts_40074[@]}")
            if [ "$(( ${#__length_616[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40074[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_154=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40075="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40075}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40075}" ";"
            local parts_40076=("${ret_split4_v0[@]}")
            local __length_618=("${parts_40076[@]}")
            if [ "$(( ${#__length_618[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40076[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40076[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40076[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40076[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
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
get_xylitol_colors__3120_v0() {
    inner_get_xylitol_colors__3119_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_152=1
}

# colored_primary(message: Text)
colored_primary__3121_v0() {
    local message_40070="${1}"
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40070}" "${_primary_color_153[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_153[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_153[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_153[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary3121_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__3122_v0() {
    local message_40084="${1}"
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40084}" "${_secondary_color_154[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_154[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_154[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_154[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3122_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__3123_v0() {
    local message_40255="${1}"
    if [ "$(( ! _got_xylitol_colors_152 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40255}" "${_accent_color_155[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_155[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_155[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_155[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent3123_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__3176_v0() {
    local message_40118="${1}"
    local color_40119="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3176_v0="\\x1b[${color_40119}m""${message_40118}""\\x1b[0m"
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
store_term_size__3217_v0() {
    local size_40097="${1}"
    if [ "$([ "_${size_40097}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3217_v0=0
        return 0
    fi
    split__4_v0 "${size_40097}" " "
    local parts_40098=("${ret_split4_v0[@]}")
    local __length_621=("${parts_40098[@]}")
    if [ "$(( ${#__length_621[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40098[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40098[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_160=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3217_v0=1
    return 0
}

# query_term_size()
query_term_size__3218_v0() {
    local command_623
    command_623="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40100="${command_623}"
    store_term_size__3217_v0 "${size_40100}"
    ret_query_term_size3218_v0="${ret_store_term_size3217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3219_v0() {
    local command_624
    command_624="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40096="${command_624}"
    store_term_size__3217_v0 "${size_40096}"
    ret_stty_term_size3219_v0="${ret_store_term_size3217_v0}"
    return 0
}

# get_term_size()
get_term_size__3220_v0() {
    stty_term_size__3219_v0 
    local detected_40099="${ret_stty_term_size3219_v0}"
    if [ "$(( ! detected_40099 ))" != 0 ]; then
        query_term_size__3218_v0 
        detected_40099="${ret_query_term_size3218_v0}"
    fi
    _got_term_size_159=1
}

# term_width()
term_width__3222_v0() {
    if [ "$(( ! _got_term_size_159 ))" != 0 ]; then
        get_term_size__3220_v0 
    fi
    ret_term_width3222_v0="${_term_size_160[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__3255_v0() {
    local pending_40115="${1}"
    local line_40116="${2}"
    local note_at_40117="${3}"
    if [ "$(( note_at_40117 < 0 ))" != 0 ]; then
        local array_626=()
        printf__128_v0 "${pending_40115}""${line_40116}""
" array_626[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_40117 == 0 ))" != 0 ]; then
        colored__3176_v0 "${line_40116}" 90
        local ret_colored3176_v0__12_40="${ret_colored3176_v0}"
        local array_627=()
        printf__128_v0 "${pending_40115}""${ret_colored3176_v0__12_40}""
" array_627[@]
    else
        slice__24_v0 "${line_40116}" 0 "${note_at_40117}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_40116}" "${note_at_40117}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__3176_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored3176_v0__13_58="${ret_colored3176_v0}"
        local array_628=()
        printf__128_v0 "${pending_40115}""${ret_slice24_v0__13_32}""${ret_colored3176_v0__13_58}""
" array_628[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__3256_v0() {
    local names_40088=("${!1}")
    local texts_40089=("${!2}")
    local notes_40090=("${!3}")
    local min_name_width_40091="${4}"
    local __length_629=("${names_40088[@]}")
    local count_40092="${#__length_629[@]}"
    local name_width_40093="${min_name_width_40091}"
    local __range_start_40094=0
    local __range_end_40094="${count_40092}"
    local __dir_40094=$(( ${__range_start_40094} <= ${__range_end_40094} ? 1 : -1 ))
    for (( i_40094=${__range_start_40094}; i_40094 * ${__dir_40094} < ${__range_end_40094} * ${__dir_40094}; i_40094+=${__dir_40094} )); do
        local __length_630="${names_40088[${i_40094}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_40095="${#__length_630}"
        if [ "$(( width_40095 > name_width_40093 ))" != 0 ]; then
            name_width_40093="${width_40095}"
        fi
done
    term_width__3222_v0 
    local width_40101="${ret_term_width3222_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_40102="$(( name_width_40093 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_40103="$(( $(( width_40101 - indent_40102 )) < 24 ))"
    if [ "${stacked_40103}" != 0 ]; then
        indent_40102=6
    fi
    local avail_40104="$(( width_40101 - indent_40102 ))"
    rpad__28_v0 "" " " "${indent_40102}"
    local blank_40105="${ret_rpad28_v0}"
    local __range_start_40106=0
    local __range_end_40106="${count_40092}"
    local __dir_40106=$(( ${__range_start_40106} <= ${__range_end_40106} ? 1 : -1 ))
    for (( i_40106=${__range_start_40106}; i_40106 * ${__dir_40106} < ${__range_end_40106} * ${__dir_40106}; i_40106+=${__dir_40106} )); do
        local pending_40107="${blank_40105}"
        if [ "${stacked_40103}" != 0 ]; then
            local array_631=()
            printf__128_v0 "  ""${names_40088[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_631[@]
        else
            rpad__28_v0 "  ""${names_40088[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_40102}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_40107="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_40089[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_40108=("${ret_split4_v0__52_21[@]}")
        local __length_632=("${words_40108[@]}")
        local note_start_40109="${#__length_632[@]}"
        if [ "$([ "_${notes_40090[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_633="${notes_40090[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_633} > avail_40104 ))" != 0 ]; then
                split__4_v0 "${notes_40090[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_40108+=("${ret_split4_v0__58_26[@]}")
            else
                local array_634=("${notes_40090[${i_40106}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_40108+=("${array_634[@]}")
            fi
        fi
        local line_40110=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_40111=-1
        local __range_start_40112=0
        local __length_635=("${words_40108[@]}")
        local __range_end_40112="${#__length_635[@]}"
        local __dir_40112=$(( ${__range_start_40112} <= ${__range_end_40112} ? 1 : -1 ))
        for (( j_40112=${__range_start_40112}; j_40112 * ${__dir_40112} < ${__range_end_40112} * ${__dir_40112}; j_40112+=${__dir_40112} )); do
            local word_40113="${words_40108[${j_40112}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_40114
            candidate_40114="$(if [ "$([ "_${line_40110}" != "_" ]; echo $?)" != 0 ]; then echo "${word_40113}"; else echo "${line_40110}"" ""${word_40113}"; fi)"
            local __length_636="${candidate_40114}"
            if [ "$(( $(( ${#__length_636} > avail_40104 )) && $([ "_${line_40110}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__3255_v0 "${pending_40107}" "${line_40110}" "${note_at_40111}"
                pending_40107="${blank_40105}"
                line_40110="${word_40113}"
                note_at_40111="$(if [ "$(( j_40112 >= note_start_40109 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_40112 >= note_start_40109 )) && $(( note_at_40111 < 0 )) ))" != 0 ]; then
                    local __length_637="${candidate_40114}"
                    local __length_638="${word_40113}"
                    note_at_40111="$(( ${#__length_637} - ${#__length_638} ))"
                fi
                line_40110="${candidate_40114}"
            fi
done
        print_help_line__3255_v0 "${pending_40107}" "${line_40110}" "${note_at_40111}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__3364_v0() {
    local command_639
    command_639="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key3364_v0="${command_639}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3366_v0() {
    local format_40216="${1}"
    local args_40217=("${!2}")
    args_40217=("${format_40216}" "${args_40217[@]}")
    __status=$?
    printf "${args_40217[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3367_v0() {
    local message_40223="${1}"
    local color_40224="${2}"
    # Prints an error message with a specified color.
    local array_640=("${message_40223}")
    eprintf__3366_v0 "\\x1b[${color_40224}m%s\\x1b[0m" array_640[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3382_v0() {
    local format_40166="${1}"
    local args_40167=("${!2}")
    args_40167=("${format_40166}" "${args_40167[@]}")
    __status=$?
    printf "${args_40167[@]}" >&2
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
stty_count__3406_v0() {
    local command_642
    command_642="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40164="${command_642}"
    parse_int__13_v0 "${count_40164}"
    __status=$?
    ret_stty_count3406_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3407_v0() {
    stty_count__3406_v0 
    local count_num_40165="${ret_stty_count3406_v0}"
    if [ "$(( count_num_40165 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40165="$(( count_num_40165 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40165}
    __status=$?
}

# stty_unlock()
stty_unlock__3408_v0() {
    stty_count__3406_v0 
    local count_num_40316="${ret_stty_count3406_v0}"
    if [ "$(( count_num_40316 > 0 ))" != 0 ]; then
        count_num_40316="$(( count_num_40316 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40316}
        __status=$?
        if [ "$(( count_num_40316 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3409_v0() {
    local size_40169="${1}"
    if [ "$([ "_${size_40169}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3409_v0=0
        return 0
    fi
    split__4_v0 "${size_40169}" " "
    local parts_40170=("${ret_split4_v0[@]}")
    local __length_643=("${parts_40170[@]}")
    if [ "$(( ${#__length_643[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3409_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40170[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40170[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_168=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3409_v0=1
    return 0
}

# query_term_size()
query_term_size__3410_v0() {
    local command_645
    command_645="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40172="${command_645}"
    store_term_size__3409_v0 "${size_40172}"
    ret_query_term_size3410_v0="${ret_store_term_size3409_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3411_v0() {
    local command_646
    command_646="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40168="${command_646}"
    store_term_size__3409_v0 "${size_40168}"
    ret_stty_term_size3411_v0="${ret_store_term_size3409_v0}"
    return 0
}

# get_term_size()
get_term_size__3412_v0() {
    stty_term_size__3411_v0 
    local detected_40171="${ret_stty_term_size3411_v0}"
    if [ "$(( ! detected_40171 ))" != 0 ]; then
        query_term_size__3410_v0 
        detected_40171="${ret_query_term_size3410_v0}"
    fi
    _got_term_size_167=1
}

# term_width()
term_width__3414_v0() {
    if [ "$(( ! _got_term_size_167 ))" != 0 ]; then
        get_term_size__3412_v0 
    fi
    ret_term_width3414_v0="${_term_size_168[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__3415_v0() {
    if [ "$(( ! _got_term_size_167 ))" != 0 ]; then
        get_term_size__3412_v0 
    fi
    ret_term_height3415_v0="${_term_size_168[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__3417_v0() {
    local cnt_40287="${1}"
    if [ "$(( cnt_40287 > 0 ))" != 0 ]; then
        local sequence_40288=""
        local __range_start_40289=0
        local __range_end_40289="${cnt_40287}"
        local __dir_40289=$(( ${__range_start_40289} <= ${__range_end_40289} ? 1 : -1 ))
        for (( ____40289=${__range_start_40289}; ____40289 * ${__dir_40289} < ${__range_end_40289} * ${__dir_40289}; ____40289+=${__dir_40289} )); do
            sequence_40288+="\\x1b[2K\\x1b[1A"
done
        local array_647=("")
        eprintf__3382_v0 "${sequence_40288}" array_647[@]
    fi
    local array_648=("")
    eprintf__3382_v0 "\\x1b[G" array_648[@]
}

# remove_current_line()
remove_current_line__3418_v0() {
    local array_649=("")
    eprintf__3382_v0 "\\x1b[2K\\x1b[G" array_649[@]
}

# print_blank(cnt: Int)
print_blank__3419_v0() {
    local cnt_40278="${1}"
    printf '%*s' "${cnt_40278}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__3420_v0() {
    local cnt_40221="${1}"
    local __range_start_40222=0
    local __range_end_40222="${cnt_40221}"
    local __dir_40222=$(( ${__range_start_40222} <= ${__range_end_40222} ? 1 : -1 ))
    for (( ____40222=${__range_start_40222}; ____40222 * ${__dir_40222} < ${__range_end_40222} * ${__dir_40222}; ____40222+=${__dir_40222} )); do
        local array_650=("")
        eprintf__3382_v0 "
" array_650[@]
done
}

# go_up(cnt: Int)
go_up__3421_v0() {
    local cnt_40244="${1}"
    local array_651=("")
    eprintf__3382_v0 "\\x1b[${cnt_40244}A" array_651[@]
}

# go_down(cnt: Int)
go_down__3422_v0() {
    local cnt_40315="${1}"
    local array_652=("")
    eprintf__3382_v0 "\\x1b[${cnt_40315}B" array_652[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__3424_v0() {
    local array_653=("")
    eprintf__3382_v0 "\\x1b[?25l" array_653[@]
}

# show_cursor()
show_cursor__3425_v0() {
    local array_654=("")
    eprintf__3382_v0 "\\x1b[?25h" array_654[@]
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
get_supports_truecolor__3463_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40277="${ret_env_var_get120_v0}"
    _supports_truecolor_171="$(if [ "$([ "_${config_40277}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3463_v0="$([ "_${_supports_truecolor_171}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3464_v0() {
    local message_40272="${1}"
    local r_40273="${2}"
    local g_40274="${3}"
    local b_40275="${4}"
    local fallback_40276="${5}"
    if [ "$([ "_${_supports_truecolor_171}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3464_v0="\\x1b[38;2;${r_40273};${g_40274};${b_40275}m""${message_40272}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_171}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3463_v0 
        local ret_get_supports_truecolor3463_v0__45_17="${ret_get_supports_truecolor3463_v0}"
        if [ "${ret_get_supports_truecolor3463_v0__45_17}" != 0 ]; then
            ret_colored_rgb3464_v0="\\x1b[38;2;${r_40273};${g_40274};${b_40275}m""${message_40272}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40276 == 0 ))" != 0 ]; then
            ret_colored_rgb3464_v0="${message_40272}"
            return 0
        else
            ret_colored_rgb3464_v0="\\x1b[${fallback_40276}m""${message_40272}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40276 == 0 ))" != 0 ]; then
            ret_colored_rgb3464_v0="${message_40272}"
            return 0
        fi
        ret_colored_rgb3464_v0="\\x1b[${fallback_40276}m""${message_40272}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3466_v0() {
    if [ "$(( ! _got_xylitol_colors_172 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40266="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40266}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40266}" ";"
            local parts_40267=("${ret_split4_v0[@]}")
            local __length_658=("${parts_40267[@]}")
            if [ "$(( ${#__length_658[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40267[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40267[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40267[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40267[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40268="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40268}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40268}" ";"
            local parts_40269=("${ret_split4_v0[@]}")
            local __length_660=("${parts_40269[@]}")
            if [ "$(( ${#__length_660[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40269[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_174=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40270="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40270}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40270}" ";"
            local parts_40271=("${ret_split4_v0[@]}")
            local __length_662=("${parts_40271[@]}")
            if [ "$(( ${#__length_662[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40271[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40271[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40271[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40271[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_172=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3467_v0() {
    inner_get_xylitol_colors__3466_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_172=1
}

# colored_secondary(message: Text)
colored_secondary__3469_v0() {
    local message_40265="${1}"
    if [ "$(( ! _got_xylitol_colors_172 ))" != 0 ]; then
        get_xylitol_colors__3467_v0 
    fi
    colored_rgb__3464_v0 "${message_40265}" "${_secondary_color_174[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_174[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_174[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_174[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3469_v0="${ret_colored_rgb3464_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_176="None"
# perl_available()
perl_available__3486_v0() {
    if [ "$([ "_${_perl_state_176}" != "_None" ]; echo $?)" != 0 ]; then
        local command_664
        command_664="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40186
        disabled_40186="$([ "_${command_664}" != "_No" ]; echo $?)"
        local command_665
        command_665="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40187
        found_40187="$(( $(( ! disabled_40186 )) && $([ "_${command_665}" != "_0" ]; echo $?) ))"
        _perl_state_176="$(if [ "${found_40187}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3486_v0="$([ "_${_perl_state_176}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3487_v0() {
    local text_40185="${1}"
    perl_available__3486_v0 
    local ret_perl_available3486_v0__19_12="${ret_perl_available3486_v0}"
    if [ "$(( ! ret_perl_available3486_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return 1
    fi
    local command_666
    command_666="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40185}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return "${__status}"
    fi
    local width_str_40188="${command_666}"
    parse_int__13_v0 "${width_str_40188}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return "${__status}"
    fi
    local width_40189="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3487_v0="${width_40189}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__3488_v0() {
    local text_40198="${1}"
    local max_width_40199="${2}"
    perl_available__3486_v0 
    local ret_perl_available3486_v0__30_12="${ret_perl_available3486_v0}"
    if [ "$(( ! ret_perl_available3486_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk3488_v0=''
        return 1
    fi
    local command_667
    command_667="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_40198}" ${max_width_40199} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk3488_v0=''
        return "${__status}"
    fi
    local result_40200="${command_667}"
    ret_perl_truncate_cjk3488_v0="${result_40200}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3492_v0() {
    local text_40193="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_668
    command_668="$([[ "${text_40193}" == *$'\x1b'* || "${text_40193}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40194="${command_668}"
    ret_has_ansi_escape3492_v0="$([ "_${has_escape_40194}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3494_v0() {
    local text_40181="${1}"
    local command_669
    command_669="$(printf "%s" "${text_40181}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3494_v0="${command_669}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3495_v0() {
    local text_40183="${1}"
    local command_670
    command_670="$(printf "%s" "${text_40183}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40184="${command_670}"
    ret_is_all_ascii3495_v0="$([ "_${result_40184}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3496_v0() {
    local text_40178="${1}"
    local command_671
    command_671="$(LC_ALL=C; __t="${text_40178}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40179="${command_671}"
    parse_int__13_v0 "${measured_40179}"
    __status=$?
    ret_plain_len3496_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3497_v0() {
    local text_40177="${1}"
    plain_len__3496_v0 "${text_40177}"
    local plain_40180="${ret_plain_len3496_v0}"
    if [ "$(( plain_40180 >= 0 ))" != 0 ]; then
        ret_get_visible_len3497_v0="${plain_40180}"
        return 0
    fi
    strip_ansi__3494_v0 "${text_40177}"
    local stripped_40182="${ret_strip_ansi3494_v0}"
    is_all_ascii__3495_v0 "${stripped_40182}"
    local ret_is_all_ascii3495_v0__46_12="${ret_is_all_ascii3495_v0}"
    if [ "$(( ! ret_is_all_ascii3495_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3487_v0 "${stripped_40182}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_672="${stripped_40182}"
            ret_get_visible_len3497_v0="${#__length_672}"
            return 0
        fi
        ret_get_visible_len3497_v0="${ret_perl_get_cjk_width3487_v0}"
        return 0
    fi
    local __length_673="${stripped_40182}"
    ret_get_visible_len3497_v0="${#__length_673}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__3498_v0() {
    local text_40195="${1}"
    local max_width_40196="${2}"
    get_visible_len__3497_v0 "${text_40195}"
    local visible_len_40197="${ret_get_visible_len3497_v0}"
    if [ "$(( visible_len_40197 <= max_width_40196 ))" != 0 ]; then
        ret_truncate_text3498_v0="${text_40195}"
        return 0
    fi
    is_all_ascii__3495_v0 "${text_40195}"
    local ret_is_all_ascii3495_v0__61_12="${ret_is_all_ascii3495_v0}"
    if [ "$(( ! ret_is_all_ascii3495_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__3488_v0 "${text_40195}" "${max_width_40196}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_40195}" | cut -c1-${max_width_40196}
            __status=$?
        fi
        ret_truncate_text3498_v0="${ret_perl_truncate_cjk3488_v0}"
        return 0
    fi
    local command_674
    command_674="$(printf "%s" "${text_40195}" | cut -c1-${max_width_40196})"
    __status=$?
    ret_truncate_text3498_v0="${command_674}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__3499_v0() {
    local text_40191="${1}"
    local max_width_40192="${2}"
    has_ansi_escape__3492_v0 "${text_40191}"
    local ret_has_ansi_escape3492_v0__73_12="${ret_has_ansi_escape3492_v0}"
    if [ "$(( ! ret_has_ansi_escape3492_v0__73_12 ))" != 0 ]; then
        truncate_text__3498_v0 "${text_40191}" "${max_width_40192}"
        ret_truncate_ansi3499_v0="${ret_truncate_text3498_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_675
    command_675="$([[ "${text_40191}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_40201="${command_675}"
    # Replace \x1b[ with newline, then split
    local command_676
    command_676="$(t="${text_40191}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_40202="${command_676}"
    split__4_v0 "${replaced_40202}" "
"
    local parts_40203=("${ret_split4_v0[@]}")
    local result_40204=""
    local remaining_width_40205="${max_width_40192}"
    local __range_start_40206=0
    local __length_677=("${parts_40203[@]}")
    local __range_end_40206="${#__length_677[@]}"
    local __dir_40206=$(( ${__range_start_40206} <= ${__range_end_40206} ? 1 : -1 ))
    for (( idx_40206=${__range_start_40206}; idx_40206 * ${__dir_40206} < ${__range_end_40206} * ${__dir_40206}; idx_40206+=${__dir_40206} )); do
        local part_40207="${parts_40203[${idx_40206}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_40206 == 0 )) && $([ "_${starts_with_ansi_40201}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_40207}" == "_" ]; echo $?) && $(( remaining_width_40205 > 0 )) ))" != 0 ]; then
                truncate_text__3498_v0 "${part_40207}" "${remaining_width_40205}"
                local ret_truncate_text3498_v0__95_35="${ret_truncate_text3498_v0}"
                local truncated_40208="${ret_truncate_text3498_v0__95_35}"
                result_40204+="${truncated_40208}"
                get_visible_len__3497_v0 "${truncated_40208}"
                local ret_get_visible_len3497_v0__97_36="${ret_get_visible_len3497_v0}"
                remaining_width_40205="$(( remaining_width_40205 - ret_get_visible_len3497_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_678
            command_678="$(__p="${part_40207}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_40209="${command_678}"
            if [ "$([ "_${m_idx_40209}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_679
                command_679="$(__p="${part_40207}"; printf "%s" "${__p:0:${m_idx_40209}}")"
                __status=$?
                local ansi_params_40210="${command_679}"
                result_40204+="\\x1b[""${ansi_params_40210}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_40209}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_40211="${ret_parse_int13_v0__108_41}"
                local text_start_40212="$(( m_idx_num_40211 + 1 ))"
                local command_680
                command_680="$(__p="${part_40207}"; printf "%s" "${__p:${text_start_40212}}")"
                __status=$?
                local text_part_40213="${command_680}"
                if [ "$(( $([ "_${text_part_40213}" == "_" ]; echo $?) && $(( remaining_width_40205 > 0 )) ))" != 0 ]; then
                    truncate_text__3498_v0 "${text_part_40213}" "${remaining_width_40205}"
                    local ret_truncate_text3498_v0__112_39="${ret_truncate_text3498_v0}"
                    local truncated_40214="${ret_truncate_text3498_v0__112_39}"
                    result_40204+="${truncated_40214}"
                    get_visible_len__3497_v0 "${truncated_40214}"
                    local ret_get_visible_len3497_v0__114_40="${ret_get_visible_len3497_v0}"
                    remaining_width_40205="$(( remaining_width_40205 - ret_get_visible_len3497_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_40207}" == "_" ]; echo $?) && $(( remaining_width_40205 > 0 )) ))" != 0 ]; then
                    truncate_text__3498_v0 "${part_40207}" "${remaining_width_40205}"
                    local ret_truncate_text3498_v0__119_39="${ret_truncate_text3498_v0}"
                    local truncated_40215="${ret_truncate_text3498_v0__119_39}"
                    result_40204+="${truncated_40215}"
                    get_visible_len__3497_v0 "${truncated_40215}"
                    local ret_get_visible_len3497_v0__121_40="${ret_get_visible_len3497_v0}"
                    remaining_width_40205="$(( remaining_width_40205 - ret_get_visible_len3497_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi3499_v0="${result_40204}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__3500_v0() {
    local text_40175="${1}"
    local max_width_40176="${2}"
    get_visible_len__3497_v0 "${text_40175}"
    local visible_len_40190="${ret_get_visible_len3497_v0}"
    if [ "$(( visible_len_40190 <= max_width_40176 ))" != 0 ]; then
        ret_cutoff_text3500_v0="${text_40175}"
        return 0
    fi
    truncate_ansi__3499_v0 "${text_40175}" "$(( max_width_40176 - 3 ))"
    local ret_truncate_ansi3499_v0__137_12="${ret_truncate_ansi3499_v0}"
    ret_cutoff_text3500_v0="${ret_truncate_ansi3499_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__3521_v0() {
    local format_40233="${1}"
    local args_40234=("${!2}")
    args_40234=("${format_40233}" "${args_40234[@]}")
    __status=$?
    printf "${args_40234[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3522_v0() {
    local message_40231="${1}"
    local color_40232="${2}"
    # Prints an error message with a specified color.
    local array_681=("${message_40231}")
    eprintf__3521_v0 "\\x1b[${color_40232}m%s\\x1b[0m" array_681[@]
}

# colored(message: Text, color: Int)
colored__3523_v0() {
    local message_40235="${1}"
    local color_40236="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3523_v0="\\x1b[${color_40236}m""${message_40235}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__3527_v0() {
    local items_40225=("${!1}")
    local total_len_40226="${2}"
    local term_width_40227="${3}"
    local separator_40228=" • "
    local separator_len_40229=3
    # Fast path: no truncation needed
    if [ "$(( total_len_40226 <= term_width_40227 ))" != 0 ]; then
        local iter_40230=0
        while :
        do
            local __length_682=("${items_40225[@]}")
            if [ "$(( iter_40230 >= ${#__length_682[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_40230 > 0 ))" != 0 ]; then
                eprintf_colored__3522_v0 "${separator_40228}" 90
            fi
            colored__3523_v0 "${items_40225[$(( iter_40230 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored3523_v0__23_41="${ret_colored3523_v0}"
            local array_683=("")
            eprintf__3521_v0 "${items_40225[${iter_40230}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored3523_v0__23_41}" array_683[@]
            iter_40230="$(( iter_40230 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_40237=0
        local first_40238=1
        local iter_40239=0
        while :
        do
            local __length_684=("${items_40225[@]}")
            if [ "$(( iter_40239 >= ${#__length_684[@]} ))" != 0 ]; then
                break
            fi
            local key_40240="${items_40225[${iter_40239}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_40241="${items_40225[$(( iter_40239 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_685="${key_40240}"
            local __length_686="${action_40241}"
            local part_len_40242="$(( $(( ${#__length_685} + 1 )) + ${#__length_686} ))"
            local needed_40243="${part_len_40242}"
            if [ "$(( ! first_40238 ))" != 0 ]; then
                needed_40243="$(( needed_40243 + separator_len_40229 ))"
            fi
            if [ "$(( $(( current_len_40237 + needed_40243 )) > term_width_40227 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_40238 ))" != 0 ]; then
                eprintf_colored__3522_v0 "${separator_40228}" 90
            fi
            colored__3523_v0 "${action_40241}" 2
            local ret_colored3523_v0__51_33="${ret_colored3523_v0}"
            local array_687=("")
            eprintf__3521_v0 "${key_40240}"" ""${ret_colored3523_v0__51_33}" array_687[@]
            current_len_40237="$(( current_len_40237 + needed_40243 ))"
            first_40238=0
            iter_40239="$(( iter_40239 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__3537_v0() {
    local format_40303="${1}"
    local args_40304=("${!2}")
    args_40304=("${format_40303}" "${args_40304[@]}")
    __status=$?
    printf "${args_40304[@]}" >&2
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
go_up__3576_v0() {
    local cnt_40302="${1}"
    local array_689=("")
    eprintf__3537_v0 "\\x1b[${cnt_40302}A" array_689[@]
}

# go_down(cnt: Int)
go_down__3577_v0() {
    local cnt_40305="${1}"
    local array_690=("")
    eprintf__3537_v0 "\\x1b[${cnt_40305}B" array_690[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3584_v0() {
    local display_count_40299="${1}"
    local index_40300="${2}"
    local line_40301="${3}"
    go_up__3576_v0 "$(( display_count_40299 - index_40300 ))"
    local array_691=("")
    eprintf__3521_v0 "\\x1b[G\\x1b[K" array_691[@]
    local array_692=("")
    eprintf__3521_v0 "${line_40301}" array_692[@]
    go_down__3577_v0 "$(( display_count_40299 - index_40300 ))"
    local array_693=("")
    eprintf__3521_v0 "\\x1b[G" array_693[@]
}

# Which items of a multi-select widget are ticked.
_checked_181=()
_count_182=0
_total_183=0
_limit_184=-1
# checked_init(total: Int, limit: Int)
checked_init__3586_v0() {
    local total_40218="${1}"
    local limit_40219="${2}"
    _checked_181=()
    local __range_start_40220=0
    local __range_end_40220="${total_40218}"
    local __dir_40220=$(( ${__range_start_40220} <= ${__range_end_40220} ? 1 : -1 ))
    for (( ____40220=${__range_start_40220}; ____40220 * ${__dir_40220} < ${__range_end_40220} * ${__dir_40220}; ____40220+=${__dir_40220} )); do
        local array_696=(0)
        _checked_181+=("${array_696[@]}")
done
    _count_182=0
    _total_183="${total_40218}"
    _limit_184="${limit_40219}"
}

# checked_is(index: Int)
checked_is__3587_v0() {
    local index_40262="${1}"
    ret_checked_is3587_v0="${_checked_181[${index_40262}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3589_v0() {
    local index_40294="${1}"
    if [ "${_checked_181[${index_40294}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_181["${index_40294}"]=0
        _count_182="$(( _count_182 - 1 ))"
        ret_checked_toggle3589_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_184 >= 0 )) && $(( _count_182 >= _limit_184 )) ))" != 0 ]; then
        ret_checked_toggle3589_v0=0
        return 0
    fi
    _checked_181["${index_40294}"]=1
    _count_182="$(( _count_182 + 1 ))"
    ret_checked_toggle3589_v0=1
    return 0
}

# checked_all()
checked_all__3590_v0() {
    if [ "$(( _limit_184 >= 0 ))" != 0 ]; then
        ret_checked_all3590_v0=0
        return 0
    fi
    local was_all_40306="$(( _count_182 == _total_183 ))"
    local __range_start_40307=0
    local __range_end_40307="${_total_183}"
    local __dir_40307=$(( ${__range_start_40307} <= ${__range_end_40307} ? 1 : -1 ))
    for (( i_40307=${__range_start_40307}; i_40307 * ${__dir_40307} < ${__range_end_40307} * ${__dir_40307}; i_40307+=${__dir_40307} )); do
        _checked_181["${i_40307}"]="$(( ! was_all_40306 ))"
done
    if [ "${was_all_40306}" != 0 ]; then
        _count_182=0
    else
        _count_182="${_total_183}"
    fi
    ret_checked_all3590_v0=1
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
render_single_page__3661_v0() {
    local __length_698="${_cursor_195}"
    local cursor_len_40281="${#__length_698}"
    local max_option_width_40282="$(( $(( _term_width_198 - cursor_len_40281 )) - 1 ))"
    local __range_start_40283=0
    local __range_end_40283="${_page_count_201}"
    local __dir_40283=$(( ${__range_start_40283} <= ${__range_end_40283} ? 1 : -1 ))
    for (( i_40283=${__range_start_40283}; i_40283 * ${__dir_40283} < ${__range_end_40283} * ${__dir_40283}; i_40283+=${__dir_40283} )); do
        cutoff_text__3500_v0 "${_page_200[${i_40283}]?"Index out of bounds (at src/./file/../choose/engine.ab:45:45)"}" "${max_option_width_40282}"
        local ret_cutoff_text3500_v0__45_27="${ret_cutoff_text3500_v0}"
        local truncated_40284="${ret_cutoff_text3500_v0__45_27}"
        if [ "$(( i_40283 == _selected_194 ))" != 0 ]; then
            colored_secondary__3469_v0 "${_cursor_195}""${truncated_40284}""
"
            local ret_colored_secondary3469_v0__47_21="${ret_colored_secondary3469_v0}"
            local array_699=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__47_21}" array_699[@]
        else
            print_blank__3419_v0 "${cursor_len_40281}"
            local array_700=("")
            eprintf__3366_v0 "${truncated_40284}""
" array_700[@]
        fi
done
    local remaining_slots_40285="$(( _display_count_191 - _page_count_201 ))"
    if [ "$(( remaining_slots_40285 > 0 ))" != 0 ]; then
        local __range_start_40286=0
        local __range_end_40286="${remaining_slots_40285}"
        local __dir_40286=$(( ${__range_start_40286} <= ${__range_end_40286} ? 1 : -1 ))
        for (( ____40286=${__range_start_40286}; ____40286 * ${__dir_40286} < ${__range_end_40286} * ${__dir_40286}; ____40286+=${__dir_40286} )); do
            local array_701=("")
            eprintf__3366_v0 "\\x1b[K
" array_701[@]
done
    fi
}

# render_multi_page()
render_multi_page__3662_v0() {
    local __length_702="${_cursor_195}"
    local cursor_len_40257="${#__length_702}"
    local max_option_width_40258="$(( $(( _term_width_198 - cursor_len_40257 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3667_v0 
    local page_start_40259="${ret_chooser_page_start3667_v0}"
    local __range_start_40260=0
    local __range_end_40260="${_page_count_201}"
    local __dir_40260=$(( ${__range_start_40260} <= ${__range_end_40260} ? 1 : -1 ))
    for (( i_40260=${__range_start_40260}; i_40260 * ${__dir_40260} < ${__range_end_40260} * ${__dir_40260}; i_40260+=${__dir_40260} )); do
        local global_idx_40261="$(( page_start_40259 + i_40260 ))"
        checked_is__3587_v0 "${global_idx_40261}"
        local ret_checked_is3587_v0__67_28="${ret_checked_is3587_v0}"
        local check_mark_40263
        check_mark_40263="$(if [ "${ret_checked_is3587_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__3500_v0 "${_page_200[${i_40260}]?"Index out of bounds (at src/./file/../choose/engine.ab:68:45)"}" "${max_option_width_40258}"
        local ret_cutoff_text3500_v0__68_27="${ret_cutoff_text3500_v0}"
        local truncated_40264="${ret_cutoff_text3500_v0__68_27}"
        checked_is__3587_v0 "${global_idx_40261}"
        local ret_checked_is3587_v0__71_13="${ret_checked_is3587_v0}"
        if [ "$(( i_40260 == _selected_194 ))" != 0 ]; then
            colored_secondary__3469_v0 "${_cursor_195}""${check_mark_40263}""${truncated_40264}""
"
            local ret_colored_secondary3469_v0__70_37="${ret_colored_secondary3469_v0}"
            local array_703=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__70_37}" array_703[@]
        elif [ "${ret_checked_is3587_v0__71_13}" != 0 ]; then
            print_blank__3419_v0 "${cursor_len_40257}"
            colored_secondary__3469_v0 "${check_mark_40263}""${truncated_40264}""
"
            local ret_colored_secondary3469_v0__73_25="${ret_colored_secondary3469_v0}"
            local array_704=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__73_25}" array_704[@]
        else
            print_blank__3419_v0 "${cursor_len_40257}"
            local array_705=("")
            eprintf__3366_v0 "${check_mark_40263}""${truncated_40264}""
" array_705[@]
        fi
done
    local remaining_slots_40279="$(( _display_count_191 - _page_count_201 ))"
    if [ "$(( remaining_slots_40279 > 0 ))" != 0 ]; then
        local __range_start_40280=0
        local __range_end_40280="${remaining_slots_40279}"
        local __dir_40280=$(( ${__range_start_40280} <= ${__range_end_40280} ? 1 : -1 ))
        for (( ____40280=${__range_start_40280}; ____40280 * ${__dir_40280} < ${__range_end_40280} * ${__dir_40280}; ____40280+=${__dir_40280} )); do
            local array_706=("")
            eprintf__3366_v0 "\\x1b[K
" array_706[@]
done
    fi
}

# render_page()
render_page__3663_v0() {
    if [ "${_multi_196}" != 0 ]; then
        render_multi_page__3662_v0 
    else
        render_single_page__3661_v0 
    fi
}

# render_page_indicator()
render_page_indicator__3664_v0() {
    if [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
        local array_707=("")
        eprintf__3366_v0 "\\x1b[G\\x1b[K" array_707[@]
        eprintf_colored__3367_v0 "Page $(( _current_page_193 + 1 ))/${_total_pages_192}" 90
        local array_708=("")
        eprintf__3366_v0 "\\x1b[G" array_708[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__3665_v0() {
    if [ "$(( ! _multi_196 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
            local array_709=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__3527_v0 array_709[@] 36 "${_term_width_198}"
        else
            local array_710=("↑↓" "select" "enter" "confirm")
            render_tooltip__3527_v0 array_710[@] 25 "${_term_width_198}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_192 > 1 )) && $(( _limit_197 < 0 )) ))" != 0 ]; then
            local array_711=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__3527_v0 array_711[@] 55 "${_term_width_198}"
        elif [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
            local array_712=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__3527_v0 array_712[@] 47 "${_term_width_198}"
        elif [ "$(( _limit_197 < 0 ))" != 0 ]; then
            local array_713=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__3527_v0 array_713[@] 44 "${_term_width_198}"
        else
            local array_714=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__3527_v0 array_714[@] 36 "${_term_width_198}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__3666_v0() {
    local total_40158="${1}"
    local page_size_40159="${2}"
    local header_40160="${3}"
    local cursor_40161="${4}"
    local multi_40162="${5}"
    local limit_40163="${6}"
    _total_189="${total_40158}"
    _cursor_195="${cursor_40161}"
    _multi_196="${multi_40162}"
    _limit_197="${limit_40163}"
    _current_page_193=0
    _selected_194=0
    _first_render_202=1
    _up_paged_203=0
    _has_header_199="$([ "_${header_40160}" == "_" ]; echo $?)"
    stty_lock__3407_v0 
    hide_cursor__3424_v0 
    term_width__3414_v0 
    _term_width_198="${ret_term_width3414_v0}"
    term_height__3415_v0 
    local term_height_40173="${ret_term_height3415_v0}"
    local max_page_size_40174
    max_page_size_40174="$(( term_height_40173 - $(if [ "${_has_header_199}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_190="${page_size_40159}"
    if [ "$(( _page_size_190 > max_page_size_40174 ))" != 0 ]; then
        _page_size_190="${max_page_size_40174}"
    fi
    if [ "${_has_header_199}" != 0 ]; then
        cutoff_text__3500_v0 "${header_40160}" "${_term_width_198}"
        local ret_cutoff_text3500_v0__153_17="${ret_cutoff_text3500_v0}"
        local array_715=("")
        eprintf__3366_v0 "${ret_cutoff_text3500_v0__153_17}""
" array_715[@]
    fi
    math_floor__636_v0 "$(( $(( $(( total_40158 + _page_size_190 )) - 1 )) / _page_size_190 ))"
    _total_pages_192="${ret_math_floor636_v0}"
    _display_count_191="${_page_size_190}"
    if [ "$(( total_40158 < _page_size_190 ))" != 0 ]; then
        _display_count_191="${total_40158}"
    fi
    if [ "${multi_40162}" != 0 ]; then
        checked_init__3586_v0 "${total_40158}" "${limit_40163}"
    fi
    new_line__3420_v0 "${_display_count_191}"
    local array_716=("")
    eprintf__3366_v0 "\\x1b[G" array_716[@]
    if [ "$(( _total_pages_192 > 1 ))" != 0 ]; then
        eprintf_colored__3367_v0 "Page $(( _current_page_193 + 1 ))/${_total_pages_192}" 90
    fi
    new_line__3420_v0 1
    render_tooltip_line__3665_v0 
    go_up__3421_v0 "$(( _display_count_191 + 1 ))"
    local array_717=("")
    eprintf__3366_v0 "\\x1b[G" array_717[@]
}

# chooser_page_start()
chooser_page_start__3667_v0() {
    ret_chooser_page_start3667_v0="$(( _current_page_193 * _page_size_190 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__3668_v0() {
    chooser_page_start__3667_v0 
    local start_40248="${ret_chooser_page_start3667_v0}"
    local end_40249="$(( start_40248 + _page_size_190 ))"
    if [ "$(( end_40249 > _total_189 ))" != 0 ]; then
        end_40249="${_total_189}"
    fi
    ret_chooser_page_count3668_v0="$(( end_40249 - start_40248 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3669_v0() {
    local page_40256=("${!1}")
    _page_200=("${page_40256[@]}")
    local __length_718=("${page_40256[@]}")
    _page_count_201="${#__length_718[@]}"
    if [ "${_first_render_202}" != 0 ]; then
        _first_render_202=0
        render_page__3663_v0 
    else
        if [ "${_up_paged_203}" != 0 ]; then
            _selected_194="$(( _page_count_201 - 1 ))"
            _up_paged_203=0
        fi
        go_up__3421_v0 1
        remove_line__3417_v0 "$(( _display_count_191 - 1 ))"
        remove_current_line__3418_v0 
        local array_719=("")
        eprintf__3366_v0 "\\x1b[G" array_719[@]
        render_page__3663_v0 
        render_page_indicator__3664_v0 
    fi
}

# option_width()
option_width__3670_v0() {
    local check_width_40296
    check_width_40296="$(if [ "${_multi_196}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_720="${_cursor_195}"
    ret_option_width3670_v0="$(( $(( _term_width_198 - ${#__length_720} )) - check_width_40296 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3671_v0() {
    local index_40309="${1}"
    local __length_721="${_cursor_195}"
    rpad__28_v0 "" " " "${#__length_721}"
    local blank_40310="${ret_rpad28_v0}"
    option_width__3670_v0 
    local ret_option_width3670_v0__224_49="${ret_option_width3670_v0}"
    cutoff_text__3500_v0 "${_page_200[${index_40309}]?"Index out of bounds (at src/./file/../choose/engine.ab:224:41)"}" "${ret_option_width3670_v0__224_49}"
    local truncated_40311="${ret_cutoff_text3500_v0}"
    if [ "$(( ! _multi_196 ))" != 0 ]; then
        ret_unselected_line3671_v0="${blank_40310}""${truncated_40311}"
        return 0
    fi
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__228_19="${ret_chooser_page_start3667_v0}"
    checked_is__3587_v0 "$(( ret_chooser_page_start3667_v0__228_19 + index_40309 ))"
    local ret_checked_is3587_v0__228_8="${ret_checked_is3587_v0}"
    if [ "${ret_checked_is3587_v0__228_8}" != 0 ]; then
        colored_secondary__3469_v0 "✓ ""${truncated_40311}"
        local ret_colored_secondary3469_v0__229_24="${ret_colored_secondary3469_v0}"
        ret_unselected_line3671_v0="${blank_40310}""${ret_colored_secondary3469_v0__229_24}"
        return 0
    fi
    ret_unselected_line3671_v0="${blank_40310}""• ""${truncated_40311}"
    return 0
}

# selected_line(index: Int)
selected_line__3672_v0() {
    local index_40295="${1}"
    option_width__3670_v0 
    local ret_option_width3670_v0__236_49="${ret_option_width3670_v0}"
    cutoff_text__3500_v0 "${_page_200[${index_40295}]?"Index out of bounds (at src/./file/../choose/engine.ab:236:41)"}" "${ret_option_width3670_v0__236_49}"
    local truncated_40297="${ret_cutoff_text3500_v0}"
    if [ "$(( ! _multi_196 ))" != 0 ]; then
        colored_secondary__3469_v0 "${_cursor_195}""${truncated_40297}"
        ret_selected_line3672_v0="${ret_colored_secondary3469_v0}"
        return 0
    fi
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__240_29="${ret_chooser_page_start3667_v0}"
    checked_is__3587_v0 "$(( ret_chooser_page_start3667_v0__240_29 + index_40295 ))"
    local ret_checked_is3587_v0__240_18="${ret_checked_is3587_v0}"
    local mark_40298
    mark_40298="$(if [ "${ret_checked_is3587_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__3469_v0 "${_cursor_195}""${mark_40298}""${truncated_40297}"
    ret_selected_line3672_v0="${ret_colored_secondary3469_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3673_v0() {
    local prev_selected_40308="${1}"
    unselected_line__3671_v0 "${prev_selected_40308}"
    local ret_unselected_line3671_v0__247_47="${ret_unselected_line3671_v0}"
    redraw_row__3584_v0 "${_display_count_191}" "${prev_selected_40308}" "${ret_unselected_line3671_v0__247_47}"
    selected_line__3672_v0 "${_selected_194}"
    local ret_selected_line3672_v0__248_43="${ret_selected_line3672_v0}"
    redraw_row__3584_v0 "${_display_count_191}" "${_selected_194}" "${ret_selected_line3672_v0__248_43}"
}

# redraw_current_line()
redraw_current_line__3674_v0() {
    selected_line__3672_v0 "${_selected_194}"
    local ret_selected_line3672_v0__253_43="${ret_selected_line3672_v0}"
    redraw_row__3584_v0 "${_display_count_191}" "${_selected_194}" "${ret_selected_line3672_v0__253_43}"
}

# chooser_step()
chooser_step__3675_v0() {
    get_key__3364_v0 
    local key_40290="${ret_get_key3364_v0}"
    local prev_selected_40291="${_selected_194}"
    local prev_page_40292="${_current_page_193}"
    chooser_page_start__3667_v0 
    local page_start_40293="${ret_chooser_page_start3667_v0}"
    _up_paged_203=0
    if [ "$(( $([ "_${key_40290}" != "_UP" ]; echo $?) || $([ "_${key_40290}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40290}" != "_DOWN" ]; echo $?) || $([ "_${key_40290}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40290}" != "_LEFT" ]; echo $?) || $([ "_${key_40290}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_193 > 0 ))" != 0 ]; then
            _current_page_193="$(( _current_page_193 - 1 ))"
        fi
        _selected_194=0
    elif [ "$(( $([ "_${key_40290}" != "_RIGHT" ]; echo $?) || $([ "_${key_40290}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_193 < $(( _total_pages_192 - 1 )) ))" != 0 ]; then
            _current_page_193="$(( _current_page_193 + 1 ))"
            _selected_194=0
        else
            _selected_194="$(( _page_count_201 - 1 ))"
        fi
    elif [ "$(( _multi_196 && $(( $(( $([ "_${key_40290}" != "_x" ]; echo $?) || $([ "_${key_40290}" != "_X" ]; echo $?) )) || $([ "_${key_40290}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3589_v0 "$(( page_start_40293 + _selected_194 ))"
        local ret_checked_toggle3589_v0__310_16="${ret_checked_toggle3589_v0}"
        if [ "${ret_checked_toggle3589_v0__310_16}" != 0 ]; then
            redraw_current_line__3674_v0 
        fi
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_186}"
        return 0
    elif [ "$(( $(( _multi_196 && $(( $(( $([ "_${key_40290}" != "_a" ]; echo $?) || $([ "_${key_40290}" != "_A" ]; echo $?) )) || $([ "_${key_40290}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_197 < 0 )) ))" != 0 ]; then
        checked_all__3590_v0 
        local ret_checked_all3590_v0__316_16="${ret_checked_all3590_v0}"
        if [ "${ret_checked_all3590_v0__316_16}" != 0 ]; then
            go_up__3421_v0 "${_display_count_191}"
            local array_722=("")
            eprintf__3366_v0 "\\x1b[G" array_722[@]
            render_page__3663_v0 
        fi
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_186}"
        return 0
    elif [ "$(( $([ "_${key_40290}" != "_INPUT" ]; echo $?) || $([ "_${key_40290}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step3675_v0="${__CHOOSER_DONE_188}"
        return 0
    else
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_186}"
        return 0
    fi
    if [ "$(( prev_page_40292 != _current_page_193 ))" != 0 ]; then
        ret_chooser_step3675_v0="${__CHOOSER_NEED_PAGE_187}"
        return 0
    fi
    if [ "$(( prev_selected_40291 != _selected_194 ))" != 0 ]; then
        redraw_selection__3673_v0 "${prev_selected_40291}"
    fi
    ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_186}"
    return 0
}

# chooser_selected()
chooser_selected__3676_v0() {
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__340_12="${ret_chooser_page_start3667_v0}"
    ret_chooser_selected3676_v0="$(( ret_chooser_page_start3667_v0__340_12 + _selected_194 ))"
    return 0
}

# chooser_end()
chooser_end__3678_v0() {
    local total_lines_40314="$(( _display_count_191 + 2 ))"
    if [ "${_has_header_199}" != 0 ]; then
        total_lines_40314="$(( total_lines_40314 + 1 ))"
    fi
    go_down__3422_v0 1
    remove_line__3417_v0 "$(( total_lines_40314 - 1 ))"
    remove_current_line__3418_v0 
    stty_unlock__3408_v0 
    show_cursor__3425_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3687_v0() {
    local name_40252="${1}"
    local file_type_40253="${2}"
    local target_40254="${3}"
    if [ "$([ "_${file_type_40253}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__3121_v0 "/"
        local ret_colored_primary3121_v0__10_23="${ret_colored_primary3121_v0}"
        ret_format_entry_display3687_v0="${name_40252}""${ret_colored_primary3121_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_40253}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__3123_v0 " > "
        local ret_colored_accent3123_v0__13_23="${ret_colored_accent3123_v0}"
        colored_primary__3121_v0 "${target_40254}"
        local ret_colored_primary3121_v0__13_47="${ret_colored_primary3121_v0}"
        ret_format_entry_display3687_v0="${name_40252}""${ret_colored_accent3123_v0__13_23}""${ret_colored_primary3121_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3687_v0="${name_40252}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3688_v0() {
    local start_path_40128="${1}"
    local cursor_40129="${2}"
    local show_hidden_40130="${3}"
    local page_size_40131="${4}"
    stty_lock__3060_v0 
    # Initialize current path
    local current_path_40134="${start_path_40128}"
    if [ "$([ "_${current_path_40134}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__3102_v0 
        current_path_40134="${ret_get_cwd3102_v0}"
    fi
    normalize_path__3103_v0 "${current_path_40134}"
    current_path_40134="${ret_normalize_path3103_v0}"
    while :
    do
        colored_primary__3121_v0 "Loading files..."
        local ret_colored_primary3121_v0__41_17="${ret_colored_primary3121_v0}"
        local array_723=("")
        eprintf__3019_v0 "${ret_colored_primary3121_v0__41_17}" array_723[@]
        get_directory_entries__3101_v0 "${current_path_40134}"
        local listed_40145=("${ret_get_directory_entries3101_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_40146=()
        local types_40147=()
        local targets_40148=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_40134}" == "_/" ]; echo $?)" != 0 ]; then
            names_40146+=("..")
            types_40147+=("d")
            targets_40148+=("")
        fi
        local __length_730=("${listed_40145[@]}")
        local listed_count_40149="$(( ${#__length_730[@]} / __ENTRY_STRIDE_149 ))"
        local __range_start_40150=0
        local __range_end_40150="${listed_count_40149}"
        local __dir_40150=$(( ${__range_start_40150} <= ${__range_end_40150} ? 1 : -1 ))
        for (( i_40150=${__range_start_40150}; i_40150 * ${__dir_40150} < ${__range_end_40150} * ${__dir_40150}; i_40150+=${__dir_40150} )); do
            local at_40151="$(( i_40150 * __ENTRY_STRIDE_149 ))"
            local name_40152="${listed_40145[${at_40151}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_40152}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_40130 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_731=("${name_40152}")
            names_40146+=("${array_731[@]}")
            local array_732=("${listed_40145[$(( at_40151 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_40147+=("${array_732[@]}")
            local array_733=("${listed_40145[$(( at_40151 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_40148+=("${array_733[@]}")
done
        local __length_734=("${names_40146[@]}")
        local total_40153="${#__length_734[@]}"
        if [ "$(( total_40153 == 0 ))" != 0 ]; then
            eprintf_colored__3020_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__3061_v0 
            ret_xyl_file3688_v0=""
            return 0
        fi
        colored_primary__3121_v0 "${current_path_40134}"
        local header_40155="${ret_colored_primary3121_v0}"
        remove_current_line__3071_v0 
        chooser_begin__3666_v0 "${total_40153}" "${page_size_40131}" "${header_40155}" "${cursor_40129}" 0 -1
        local need_page_40245=1
        while :
        do
            if [ "${need_page_40245}" != 0 ]; then
                local page_40246=()
                chooser_page_start__3667_v0 
                local start_40247="${ret_chooser_page_start3667_v0}"
                chooser_page_count__3668_v0 
                local count_40250="${ret_chooser_page_count3668_v0}"
                local __range_start_40251="${start_40247}"
                local __range_end_40251="$(( start_40247 + count_40250 ))"
                local __dir_40251=$(( ${__range_start_40251} <= ${__range_end_40251} ? 1 : -1 ))
                for (( i_40251=${__range_start_40251}; i_40251 * ${__dir_40251} < ${__range_end_40251} * ${__dir_40251}; i_40251+=${__dir_40251} )); do
                    format_entry_display__3687_v0 "${names_40146[${i_40251}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_40147[${i_40251}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_40148[${i_40251}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3687_v0__90_30="${ret_format_entry_display3687_v0}"
                    local array_736=("${ret_format_entry_display3687_v0__90_30}")
                    page_40246+=("${array_736[@]}")
done
                chooser_set_page__3669_v0 page_40246[@]
            fi
            chooser_step__3675_v0 
            local step_40312="${ret_chooser_step3675_v0}"
            if [ "$(( step_40312 == __CHOOSER_DONE_188 ))" != 0 ]; then
                break
            fi
            need_page_40245="$(( step_40312 == __CHOOSER_NEED_PAGE_187 ))"
        done
        chooser_selected__3676_v0 
        local selected_idx_40313="${ret_chooser_selected3676_v0}"
        chooser_end__3678_v0 
        local name_40317="${names_40146[${selected_idx_40313}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_40318="${types_40147[${selected_idx_40313}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_40317}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__3105_v0 "${current_path_40134}"
            current_path_40134="${ret_get_parent_dir3105_v0}"
        elif [ "$([ "_${file_type_40318}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__3104_v0 "${current_path_40134}" "${name_40317}"
            current_path_40134="${ret_path_join3104_v0}"
            normalize_path__3103_v0 "${current_path_40134}"
            current_path_40134="${ret_normalize_path3103_v0}"
        elif [ "$([ "_${file_type_40318}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_40323="${targets_40148[${selected_idx_40313}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_40324="${target_40323}"
            starts_with__22_v0 "${target_40323}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__3104_v0 "${current_path_40134}" "${target_40323}"
                target_path_40324="${ret_path_join3104_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_40324}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_40134="${target_path_40324}"
                normalize_path__3103_v0 "${current_path_40134}"
                current_path_40134="${ret_normalize_path3103_v0}"
            else
                stty_unlock__3061_v0 
                path_join__3104_v0 "${current_path_40134}" "${name_40317}"
                ret_xyl_file3688_v0="${ret_path_join3104_v0}"
                return 0
            fi
        else
            stty_unlock__3061_v0 
            path_join__3104_v0 "${current_path_40134}" "${name_40317}"
            ret_xyl_file3688_v0="${ret_path_join3104_v0}"
            return 0
        fi
    done
    stty_unlock__3061_v0 
    ret_xyl_file3688_v0=""
    return 0
}

# print_file_help()
print_file_help__3788_v0() {
    local usage_40043=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__3079_v0 usage_40043[@]
    printf '%s\n' ""
    colored_primary__3121_v0 "file"
    local ret_colored_primary3121_v0__8_20="${ret_colored_primary3121_v0}"
    local title_40083=("${ret_colored_primary3121_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__3079_v0 title_40083[@]
    printf '%s\n' ""
    colored_secondary__3122_v0 "Arguments:"
    local ret_colored_secondary3122_v0__11_12="${ret_colored_secondary3122_v0}"
    local array_739=()
    printf__128_v0 "${ret_colored_secondary3122_v0__11_12}""
" array_739[@]
    local arg_names_40085=("[<path>]")
    local arg_texts_40086=("Starting directory path")
    local arg_notes_40087=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__3256_v0 arg_names_40085[@] arg_texts_40086[@] arg_notes_40087[@] 20
    printf '%s\n' ""
    colored_secondary__3122_v0 "Flags:"
    local ret_colored_secondary3122_v0__18_12="${ret_colored_secondary3122_v0}"
    local array_743=()
    printf__128_v0 "${ret_colored_secondary3122_v0__18_12}""
" array_743[@]
    local names_40120=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_40121=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_40122=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__3256_v0 names_40120[@] texts_40121[@] notes_40122[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3846_v0() {
    local parameters_40037=("${!1}")
    local cursor_40038="> "
    local start_path_40039=""
    local show_hidden_40040=0
    local page_size_40041=10
    local __length_750=("${parameters_40037[@]}")
    local slice_upper_749="${#__length_750[@]}"
    local slice_offset_751=2
    local slice_offset_751=$((${slice_offset_751} > 0 ? ${slice_offset_751} : 0))
    local slice_length_752="$(( slice_upper_749 - slice_offset_751 ))"
    local slice_length_752=$((${slice_length_752} > 0 ? ${slice_length_752} : 0))
    for param_40042 in "${parameters_40037[@]:${slice_offset_751}:${slice_length_752}}"; do
        starts_with__22_v0 "${param_40042}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40042}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40042}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_40042}" != "_-h" ]; echo $?) || $([ "_${param_40042}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3788_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_753="--cursor="
            slice__24_v0 "${param_40042}" "${#__length_753}" 0
            cursor_40038="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_754="--path="
            slice__24_v0 "${param_40042}" "${#__length_754}" 0
            start_path_40039="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_40042}" != "_-a" ]; echo $?) || $([ "_${param_40042}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_40040=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_755="--page-size="
            slice__24_v0 "${param_40042}" "${#__length_755}" 0
            local value_40123="${ret_slice24_v0}"
            parse_int__13_v0 "${value_40123}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__3020_v0 "ERROR: Invalid page-size value: ""${value_40123}""
" 31
                exit 1
            fi
            page_size_40041="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_40039="${param_40042}"
        fi
    done
    xyl_file__3688_v0 "${start_path_40039}" "${cursor_40038}" "${show_hidden_40040}" "${page_size_40041}"
    ret_execute_file3846_v0="${ret_xyl_file3688_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_209="0.1.0"
__AMBER_VERSION_210="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__3848_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__162_v0 "Error: " 91
        local array_756=("")
        eprintf__161_v0 "bc is not installed. Please install bc to use xylitol.
" array_756[@]
        local array_757=("")
        eprintf__161_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_757[@]
        local array_758=("")
        eprintf__161_v0 "  For Fedora: sudo dnf install bc
" array_758[@]
        local array_759=("")
        eprintf__161_v0 "  For Arch Linux: sudo pacman -S bc
" array_759[@]
        ret_check_prerequirements3848_v0=0
        return 0
    fi
    ret_check_prerequirements3848_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__3849_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo icanon < /dev/tty' EXIT
    __status=$?
}

typeset -r args_211=("$0" "$@")
trap_cleanup__3849_v0 
check_prerequirements__3848_v0 
ret_check_prerequirements3848_v0__33_12="${ret_check_prerequirements3848_v0}"
if [ "$(( ! ret_check_prerequirements3848_v0__33_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_761=("${args_211[@]}")
if [ "$(( ${#__length_761[@]} < 2 ))" != 0 ]; then
    print_help__555_v0 
    exit 0
fi
command_1599="${args_211[1]?"Index out of bounds (at src/main.ab:42:26)"}"
if [ "$(( $(( $([ "_${command_1599}" != "_help" ]; echo $?) || $([ "_${command_1599}" != "_--help" ]; echo $?) )) || $([ "_${command_1599}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__555_v0 
elif [ "$([ "_${command_1599}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1101_v0 args_211[@]
    ret_execute_input1101_v0__49_18="${ret_execute_input1101_v0}"
    printf '%s\n' "${ret_execute_input1101_v0__49_18}"
elif [ "$([ "_${command_1599}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1770_v0 args_211[@]
    ret_execute_choose1770_v0__52_18="${ret_execute_choose1770_v0}"
    printf '%s\n' "${ret_execute_choose1770_v0__52_18}"
elif [ "$([ "_${command_1599}" != "_filter" ]; echo $?)" != 0 ]; then
    execute_filter__2321_v0 args_211[@]
    ret_execute_filter2321_v0__55_18="${ret_execute_filter2321_v0}"
    printf '%s\n' "${ret_execute_filter2321_v0__55_18}"
elif [ "$([ "_${command_1599}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2901_v0 args_211[@]
    result_29709="${ret_execute_confirm2901_v0}"
    if [ "$([ "_${result_29709}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1599}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3846_v0 args_211[@]
    ret_execute_file3846_v0__65_18="${ret_execute_file3846_v0}"
    printf '%s\n' "${ret_execute_file3846_v0__65_18}"
elif [ "$(( $(( $([ "_${command_1599}" != "_version" ]; echo $?) || $([ "_${command_1599}" != "_--version" ]; echo $?) )) || $([ "_${command_1599}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__263_v0 "xylitol.sh"
    ret_colored_primary263_v0__68_20="${ret_colored_primary263_v0}"
    array_762=()
    printf__128_v0 "${ret_colored_primary263_v0__68_20}" array_762[@]
    array_763=()
    printf__128_v0 " version: " array_763[@]
    colored_accent__265_v0 "${__VERSION_209}"
    ret_colored_accent265_v0__70_20="${ret_colored_accent265_v0}"
    array_764=()
    printf__128_v0 "${ret_colored_accent265_v0__70_20}" array_764[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_210}" 90
else
    print_help__555_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1599}""'" 91
fi
