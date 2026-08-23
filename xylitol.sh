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
    local text_1499="${1}"
    local delimiter_1500="${2}"
    local result_1501=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1500}" read -rd '' -A result_1501 < <(printf %s "$text_1499")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1500}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1501+=("$REPLY"); done < <(echo "$text_1499")
            __status=$?
        else
            IFS="${delimiter_1500}" read -rd '' -a result_1501 < <(printf %s "$text_1499")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1500}" read -rd '' -a result_1501 < <(printf %s "$text_1499")
        __status=$?
    fi
    ret_split4_v0=("${result_1501[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_18121=("${!1}")
    local delimiter_18122="${2}"
    local command_1
    command_1="$(IFS="${delimiter_18122}" ; printf "%s
" "${list_18121[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1503="${1}"
    [ -n "${text_1503}" ] && [ "${text_1503}" -eq "${text_1503}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1503}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_3192="${1}"
    local prefix_3193="${2}"
    [[ "${text_3192}" == "${prefix_3193}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1589="${1}"
    local index_1590="${2}"
    local length_1591="${3}"
    local result_1592=""
    if [ "$(( length_1591 == 0 ))" != 0 ]; then
        local __length_2="${text_1589}"
        length_1591="$(( ${#__length_2} - index_1590 ))"
    fi
    if [ "$(( length_1591 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1592}"
        return 0
    fi
    result_1592="${text_1589: ${index_1590}: ${length_1591}}"
    __status=$?
    ret_slice24_v0="${result_1592}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_29664="${1}"
    local pad_29665="${2}"
    local length_29666="${3}"
    local __length_3="${text_29664}"
    if [ "$(( length_29666 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_29664}"
        return 0
    fi
    local __length_4="${text_29664}"
    local pad_len_29667="$(( length_29666 - ${#__length_4} ))"
    local padding_29668=""
    printf -v padding_29668 "%${pad_len_29667}s" ""
    __status=$?
    padding_29668="${padding_29668// /${pad_29665}}"
    __status=$?
    ret_lpad27_v0="${padding_29668}""${text_29664}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1569="${1}"
    local pad_1570="${2}"
    local length_1571="${3}"
    local __length_5="${text_1569}"
    if [ "$(( length_1571 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1569}"
        return 0
    fi
    local __length_6="${text_1569}"
    local pad_len_1572="$(( length_1571 - ${#__length_6} ))"
    local padding_1573=""
    printf -v padding_1573 "%${pad_len_1572}s" ""
    __status=$?
    padding_1573="${padding_1573// /${pad_1570}}"
    __status=$?
    ret_rpad28_v0="${text_1569}""${padding_1573}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_29658="${1}"
    local pad_29659="${2}"
    local length_29660="${3}"
    local __length_7="${text_29658}"
    local text_length_29661="${#__length_7}"
    if [ "$(( length_29660 <= text_length_29661 ))" != 0 ]; then
        ret_cpad29_v0="${text_29658}"
        return 0
    fi
    local total_padding_29662="$(( length_29660 - text_length_29661 ))"
    local left_padding_length_29663="$(( text_length_29661 + $(( total_padding_29662 / 2 )) ))"
    lpad__27_v0 "${text_29658}" "${pad_29659}" "${left_padding_length_29663}"
    local left_padded_29669="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_29669}" "${pad_29659}" "${length_29660}"
    local center_padded_29670="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_29670}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_40323="${1}"
    [ -d "${path_40323}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1529="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1529}")"
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
" "${(P)name_1529}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1529}")"
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
    local format_1526="${1}"
    local args_1527=("${!2}")
    args_1527=("${format_1526}" "${args_1527[@]}")
    __status=$?
    printf "${args_1527[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1539="${1}"
    local args_1540=("${!2}")
    args_1540=("${format_1539}" "${args_1540[@]}")
    __status=$?
    printf "${args_1540[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1536="${1}"
    local color_1537="${2}"
    local color_code_1538=0
        color_code_1538="${color_1537}"
    local array_11=("${message_1536}")
    printf__128_v1 "\\x1b[${color_code_1538}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_40326="${1}"
    local color_40327="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_40326}")
    printf__128_v1 "\\x1b[${color_40327}m%s\\x1b[0m" array_12[@]
}

# eprintf(format: Text, args: [Text])
eprintf__161_v0() {
    local format_234="${1}"
    local args_235=("${!2}")
    args_235=("${format_234}" "${args_235[@]}")
    __status=$?
    printf "${args_235[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__162_v0() {
    local message_232="${1}"
    local color_233="${2}"
    # Prints an error message with a specified color.
    local array_13=("${message_232}")
    eprintf__161_v0 "\\x1b[${color_233}m%s\\x1b[0m" array_13[@]
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
        local disabled_1522
        disabled_1522="$([ "_${command_14}" != "_No" ]; echo $?)"
        local command_15
        command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1523
        found_1523="$(( $(( ! disabled_1522 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1523}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available184_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__185_v0() {
    local text_1521="${1}"
    perl_available__184_v0 
    local ret_perl_available184_v0__19_12="${ret_perl_available184_v0}"
    if [ "$(( ! ret_perl_available184_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return 1
    fi
    local command_16
    command_16="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1521}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_str_1524="${command_16}"
    parse_int__13_v0 "${width_str_1524}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_1525="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width185_v0="${width_1525}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__190_v0() {
    local text_1511="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_17
    command_17="$([[ "${text_1511}" == *$'\x1b'* || "${text_1511}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1512="${command_17}"
    ret_has_ansi_escape190_v0="$([ "_${has_escape_1512}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__192_v0() {
    local text_1517="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1517}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi192_v0="${command_18}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__193_v0() {
    local text_1519="${1}"
    local command_19
    command_19="$(printf "%s" "${text_1519}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1520="${command_19}"
    ret_is_all_ascii193_v0="$([ "_${result_1520}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__194_v0() {
    local text_1514="${1}"
    local command_20
    command_20="$(LC_ALL=C; __t="${text_1514}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_1515="${command_20}"
    parse_int__13_v0 "${measured_1515}"
    __status=$?
    ret_plain_len194_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__195_v0() {
    local text_1513="${1}"
    plain_len__194_v0 "${text_1513}"
    local plain_1516="${ret_plain_len194_v0}"
    if [ "$(( plain_1516 >= 0 ))" != 0 ]; then
        ret_get_visible_len195_v0="${plain_1516}"
        return 0
    fi
    strip_ansi__192_v0 "${text_1513}"
    local stripped_1518="${ret_strip_ansi192_v0}"
    is_all_ascii__193_v0 "${stripped_1518}"
    local ret_is_all_ascii193_v0__46_12="${ret_is_all_ascii193_v0}"
    if [ "$(( ! ret_is_all_ascii193_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__185_v0 "${stripped_1518}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_21="${stripped_1518}"
            ret_get_visible_len195_v0="${#__length_21}"
            return 0
        fi
        ret_get_visible_len195_v0="${ret_perl_get_cjk_width185_v0}"
        return 0
    fi
    local __length_22="${stripped_1518}"
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
    local size_1498="${1}"
    if [ "$([ "_${size_1498}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size204_v0=0
        return 0
    fi
    split__4_v0 "${size_1498}" " "
    local parts_1502=("${ret_split4_v0[@]}")
    local __length_24=("${parts_1502[@]}")
    if [ "$(( ${#__length_24[@]} != 2 ))" != 0 ]; then
        ret_store_term_size204_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1502[1]?"Index out of bounds (at src/utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1502[0]?"Index out of bounds (at src/utils/term.ab:53:68)"}"
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
    local size_1505="${command_26}"
    store_term_size__204_v0 "${size_1505}"
    ret_query_term_size205_v0="${ret_store_term_size204_v0}"
    return 0
}

# stty_term_size()
stty_term_size__206_v0() {
    local command_27
    command_27="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1497="${command_27}"
    store_term_size__204_v0 "${size_1497}"
    ret_stty_term_size206_v0="${ret_store_term_size204_v0}"
    return 0
}

# get_term_size()
get_term_size__207_v0() {
    stty_term_size__206_v0 
    local detected_1504="${ret_stty_term_size206_v0}"
    if [ "$(( ! detected_1504 ))" != 0 ]; then
        query_term_size__205_v0 
        detected_1504="${ret_query_term_size205_v0}"
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
    local pieces_1496=("${!1}")
    term_width__209_v0 
    local width_1506="${ret_term_width209_v0}"
    local line_1507=""
    local line_len_1508=0
    for piece_1509 in "${pieces_1496[@]}"; do
        local __length_30="${piece_1509}"
        local piece_len_1510="${#__length_30}"
        has_ansi_escape__190_v0 "${piece_1509}"
        local ret_has_ansi_escape190_v0__186_12="${ret_has_ansi_escape190_v0}"
        if [ "${ret_has_ansi_escape190_v0__186_12}" != 0 ]; then
            get_visible_len__195_v0 "${piece_1509}"
            piece_len_1510="${ret_get_visible_len195_v0}"
        fi
        if [ "$([ "_${line_1507}" != "_" ]; echo $?)" != 0 ]; then
            line_1507="${piece_1509}"
            line_len_1508="${piece_len_1510}"
        elif [ "$(( $(( $(( line_len_1508 + 1 )) + piece_len_1510 )) > width_1506 ))" != 0 ]; then
            local array_31=()
            printf__128_v0 "${line_1507}""
" array_31[@]
            line_1507="${piece_1509}"
            line_len_1508="${piece_len_1510}"
        else
            line_1507+=" ""${piece_1509}"
            line_len_1508="$(( line_len_1508 + $(( 1 + piece_len_1510 )) ))"
        fi
    done
    if [ "$([ "_${line_1507}" == "_" ]; echo $?)" != 0 ]; then
        local array_32=()
        printf__128_v0 "${line_1507}""
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
    local config_1546="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1546}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor258_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__259_v0() {
    local message_1541="${1}"
    local r_1542="${2}"
    local g_1543="${3}"
    local b_1544="${4}"
    local fallback_1545="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb259_v0="\\x1b[38;2;${r_1542};${g_1543};${b_1544}m""${message_1541}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__258_v0 
        local ret_get_supports_truecolor258_v0__45_17="${ret_get_supports_truecolor258_v0}"
        if [ "${ret_get_supports_truecolor258_v0__45_17}" != 0 ]; then
            ret_colored_rgb259_v0="\\x1b[38;2;${r_1542};${g_1543};${b_1544}m""${message_1541}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1545 == 0 ))" != 0 ]; then
            ret_colored_rgb259_v0="${message_1541}"
            return 0
        else
            ret_colored_rgb259_v0="\\x1b[${fallback_1545}m""${message_1541}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1545 == 0 ))" != 0 ]; then
            ret_colored_rgb259_v0="${message_1541}"
            return 0
        fi
        ret_colored_rgb259_v0="\\x1b[${fallback_1545}m""${message_1541}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__261_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1530="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1530}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1530}" ";"
            local parts_1531=("${ret_split4_v0[@]}")
            local __length_36=("${parts_1531[@]}")
            if [ "$(( ${#__length_36[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1531[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1531[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1531[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1531[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
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
        local secondary_env_1532="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1532}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1532}" ";"
            local parts_1533=("${ret_split4_v0[@]}")
            local __length_38=("${parts_1533[@]}")
            if [ "$(( ${#__length_38[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1533[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1533[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1533[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1533[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
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
        local accent_env_1534="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1534}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1534}" ";"
            local parts_1535=("${ret_split4_v0[@]}")
            local __length_40=("${parts_1535[@]}")
            if [ "$(( ${#__length_40[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1535[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1535[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1535[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1535[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
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
    local message_1528="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1528}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary263_v0="${ret_colored_rgb259_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__264_v0() {
    local message_1548="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1548}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary264_v0="${ret_colored_rgb259_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__265_v0() {
    local message_1599="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1599}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent265_v0="${ret_colored_rgb259_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__318_v0() {
    local message_1587="${1}"
    local color_1588="${2}"
    # Returns a text wrapped in color codes.
    ret_colored318_v0="\\x1b[${color_1588}m""${message_1587}""\\x1b[0m"
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
    local size_1561="${1}"
    if [ "$([ "_${size_1561}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size359_v0=0
        return 0
    fi
    split__4_v0 "${size_1561}" " "
    local parts_1562=("${ret_split4_v0[@]}")
    local __length_43=("${parts_1562[@]}")
    if [ "$(( ${#__length_43[@]} != 2 ))" != 0 ]; then
        ret_store_term_size359_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1562[1]?"Index out of bounds (at src/utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1562[0]?"Index out of bounds (at src/utils/widget/../term.ab:53:68)"}"
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
    local size_1564="${command_45}"
    store_term_size__359_v0 "${size_1564}"
    ret_query_term_size360_v0="${ret_store_term_size359_v0}"
    return 0
}

# stty_term_size()
stty_term_size__361_v0() {
    local command_46
    command_46="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1560="${command_46}"
    store_term_size__359_v0 "${size_1560}"
    ret_stty_term_size361_v0="${ret_store_term_size359_v0}"
    return 0
}

# get_term_size()
get_term_size__362_v0() {
    stty_term_size__361_v0 
    local detected_1563="${ret_stty_term_size361_v0}"
    if [ "$(( ! detected_1563 ))" != 0 ]; then
        query_term_size__360_v0 
        detected_1563="${ret_query_term_size360_v0}"
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
    local pending_1584="${1}"
    local line_1585="${2}"
    local note_at_1586="${3}"
    if [ "$(( note_at_1586 < 0 ))" != 0 ]; then
        local array_48=()
        printf__128_v0 "${pending_1584}""${line_1585}""
" array_48[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1586 == 0 ))" != 0 ]; then
        colored__318_v0 "${line_1585}" 90
        local ret_colored318_v0__12_40="${ret_colored318_v0}"
        local array_49=()
        printf__128_v0 "${pending_1584}""${ret_colored318_v0__12_40}""
" array_49[@]
    else
        slice__24_v0 "${line_1585}" 0 "${note_at_1586}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1585}" "${note_at_1586}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__318_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored318_v0__13_58="${ret_colored318_v0}"
        local array_50=()
        printf__128_v0 "${pending_1584}""${ret_slice24_v0__13_32}""${ret_colored318_v0__13_58}""
" array_50[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__398_v0() {
    local names_1552=("${!1}")
    local texts_1553=("${!2}")
    local notes_1554=("${!3}")
    local min_name_width_1555="${4}"
    local __length_51=("${names_1552[@]}")
    local count_1556="${#__length_51[@]}"
    local name_width_1557="${min_name_width_1555}"
    local __range_start_1558=0
    local __range_end_1558="${count_1556}"
    local __dir_1558=$(( ${__range_start_1558} <= ${__range_end_1558} ? 1 : -1 ))
    for (( i_1558=${__range_start_1558}; i_1558 * ${__dir_1558} < ${__range_end_1558} * ${__dir_1558}; i_1558+=${__dir_1558} )); do
        local __length_52="${names_1552[${i_1558}]?"Index out of bounds (at src/utils/widget/help.ab:28:33)"}"
        local width_1559="${#__length_52}"
        if [ "$(( width_1559 > name_width_1557 ))" != 0 ]; then
            name_width_1557="${width_1559}"
        fi
done
    term_width__364_v0 
    local width_1565="${ret_term_width364_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1566="$(( name_width_1557 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1567="$(( $(( width_1565 - indent_1566 )) < 24 ))"
    if [ "${stacked_1567}" != 0 ]; then
        indent_1566=6
    fi
    local avail_1568="$(( width_1565 - indent_1566 ))"
    rpad__28_v0 "" " " "${indent_1566}"
    local blank_1574="${ret_rpad28_v0}"
    local __range_start_1575=0
    local __range_end_1575="${count_1556}"
    local __dir_1575=$(( ${__range_start_1575} <= ${__range_end_1575} ? 1 : -1 ))
    for (( i_1575=${__range_start_1575}; i_1575 * ${__dir_1575} < ${__range_end_1575} * ${__dir_1575}; i_1575+=${__dir_1575} )); do
        local pending_1576="${blank_1574}"
        if [ "${stacked_1567}" != 0 ]; then
            local array_53=()
            printf__128_v0 "  ""${names_1552[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:48:33)"}""
" array_53[@]
        else
            rpad__28_v0 "  ""${names_1552[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:50:41)"}" " " "${indent_1566}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_1576="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_1553[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_1577=("${ret_split4_v0__52_21[@]}")
        local __length_54=("${words_1577[@]}")
        local note_start_1578="${#__length_54[@]}"
        if [ "$([ "_${notes_1554[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_55="${notes_1554[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_55} > avail_1568 ))" != 0 ]; then
                split__4_v0 "${notes_1554[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_1577+=("${ret_split4_v0__58_26[@]}")
            else
                local array_56=("${notes_1554[${i_1575}]?"Index out of bounds (at src/utils/widget/help.ab:60:33)"}")
                words_1577+=("${array_56[@]}")
            fi
        fi
        local line_1579=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1580=-1
        local __range_start_1581=0
        local __length_57=("${words_1577[@]}")
        local __range_end_1581="${#__length_57[@]}"
        local __dir_1581=$(( ${__range_start_1581} <= ${__range_end_1581} ? 1 : -1 ))
        for (( j_1581=${__range_start_1581}; j_1581 * ${__dir_1581} < ${__range_end_1581} * ${__dir_1581}; j_1581+=${__dir_1581} )); do
            local word_1582="${words_1577[${j_1581}]?"Index out of bounds (at src/utils/widget/help.ab:70:32)"}"
            local candidate_1583
            candidate_1583="$(if [ "$([ "_${line_1579}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1582}"; else echo "${line_1579}"" ""${word_1582}"; fi)"
            local __length_58="${candidate_1583}"
            if [ "$(( $(( ${#__length_58} > avail_1568 )) && $([ "_${line_1579}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__397_v0 "${pending_1576}" "${line_1579}" "${note_at_1580}"
                pending_1576="${blank_1574}"
                line_1579="${word_1582}"
                note_at_1580="$(if [ "$(( j_1581 >= note_start_1578 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1581 >= note_start_1578 )) && $(( note_at_1580 < 0 )) ))" != 0 ]; then
                    local __length_59="${candidate_1583}"
                    local __length_60="${word_1582}"
                    note_at_1580="$(( ${#__length_59} - ${#__length_60} ))"
                fi
                line_1579="${candidate_1583}"
            fi
done
        print_help_line__397_v0 "${pending_1576}" "${line_1579}" "${note_at_1580}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__555_v0() {
    local usage_1495=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__221_v0 usage_1495[@]
    printf '%s\n' ""
    colored_primary__263_v0 "Xylitol"
    local ret_colored_primary263_v0__9_21="${ret_colored_primary263_v0}"
    colored_primary__263_v0 "fresh"
    local ret_colored_primary263_v0__10_34="${ret_colored_primary263_v0}"
    local title_1547=("\\x1b[1m""${ret_colored_primary263_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary263_v0__10_34}" "shell" "scripts.")
    print_wrapped__221_v0 title_1547[@]
    printf '%s\n' ""
    colored_secondary__264_v0 "Flags:"
    local ret_colored_secondary264_v0__14_12="${ret_colored_secondary264_v0}"
    local array_63=()
    printf__128_v0 "${ret_colored_secondary264_v0__14_12}""
" array_63[@]
    local flag_names_1549=("-h, --help" "-v, --version")
    local flag_texts_1550=("Show this help message" "Show version information")
    local flag_notes_1551=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__398_v0 flag_names_1549[@] flag_texts_1550[@] flag_notes_1551[@] 13
    printf '%s\n' ""
    colored_secondary__264_v0 "Commands:"
    local ret_colored_secondary264_v0__21_12="${ret_colored_secondary264_v0}"
    local array_67=()
    printf__128_v0 "${ret_colored_secondary264_v0__21_12}""
" array_67[@]
    local cmd_names_1593=("input" "choose" "filter" "confirm" "file")
    local cmd_texts_1594=("Prompt for some input" "Choose from a list of options" "Pick from a list narrowed by typing" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1595=("" "" "" "" "")
    render_help_entries__398_v0 cmd_names_1593[@] cmd_texts_1594[@] cmd_notes_1595[@] 13
    printf '%s\n' ""
    colored_secondary__264_v0 "Envs:"
    local ret_colored_secondary264_v0__33_12="${ret_colored_secondary264_v0}"
    local array_71=()
    printf__128_v0 "${ret_colored_secondary264_v0__33_12}""
" array_71[@]
    local env_names_1596=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1597=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1598=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__398_v0 env_names_1596[@] env_texts_1597[@] env_notes_1598[@] 0
    printf '%s\n' ""
    colored_accent__265_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent265_v0__58_16="${ret_colored_accent265_v0}"
    local footer_1600=("Run" "${ret_colored_accent265_v0__58_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__221_v0 footer_1600[@]
}

# math_floor(number: Int)
math_floor__636_v0() {
    local number_3278="${1}"
    local command_76
    command_76="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_3278}")"
    __status=$?
    ret_math_floor636_v0="${command_76}"
    return 0
}

# math_ceil(number: Int)
math_ceil__637_v0() {
    local number_3277="${1}"
    math_floor__636_v0 "${number_3277}"
    local ret_math_floor636_v0__52_12="${ret_math_floor636_v0}"
    ret_math_ceil637_v0="$(( ret_math_floor636_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__645_v0() {
    local command_77
    command_77="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3272="${command_77}"
    ret_get_char645_v0="${char_3272}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__648_v0() {
    local format_3244="${1}"
    local args_3245=("${!2}")
    args_3245=("${format_3244}" "${args_3245[@]}")
    __status=$?
    printf "${args_3245[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__649_v0() {
    local message_3270="${1}"
    local color_3271="${2}"
    # Prints an error message with a specified color.
    local array_78=("${message_3270}")
    eprintf__648_v0 "\\x1b[${color_3271}m%s\\x1b[0m" array_78[@]
}

# eprintf(format: Text, args: [Text])
eprintf__664_v0() {
    local format_3248="${1}"
    local args_3249=("${!2}")
    args_3249=("${format_3248}" "${args_3249[@]}")
    __status=$?
    printf "${args_3249[@]}" >&2
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
        local disabled_3138
        disabled_3138="$([ "_${command_79}" != "_No" ]; echo $?)"
        local command_80
        command_80="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3139
        found_3139="$(( $(( ! disabled_3138 )) && $([ "_${command_80}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_3139}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available671_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__672_v0() {
    local text_3137="${1}"
    perl_available__671_v0 
    local ret_perl_available671_v0__19_12="${ret_perl_available671_v0}"
    if [ "$(( ! ret_perl_available671_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return 1
    fi
    local command_81
    command_81="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3137}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return "${__status}"
    fi
    local width_str_3140="${command_81}"
    parse_int__13_v0 "${width_str_3140}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return "${__status}"
    fi
    local width_3141="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width672_v0="${width_3141}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__677_v0() {
    local text_3127="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_82
    command_82="$([[ "${text_3127}" == *$'\x1b'* || "${text_3127}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3128="${command_82}"
    ret_has_ansi_escape677_v0="$([ "_${has_escape_3128}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__679_v0() {
    local text_3133="${1}"
    local command_83
    command_83="$(printf "%s" "${text_3133}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi679_v0="${command_83}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__680_v0() {
    local text_3135="${1}"
    local command_84
    command_84="$(printf "%s" "${text_3135}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3136="${command_84}"
    ret_is_all_ascii680_v0="$([ "_${result_3136}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__681_v0() {
    local text_3130="${1}"
    local command_85
    command_85="$(LC_ALL=C; __t="${text_3130}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3131="${command_85}"
    parse_int__13_v0 "${measured_3131}"
    __status=$?
    ret_plain_len681_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__682_v0() {
    local text_3129="${1}"
    plain_len__681_v0 "${text_3129}"
    local plain_3132="${ret_plain_len681_v0}"
    if [ "$(( plain_3132 >= 0 ))" != 0 ]; then
        ret_get_visible_len682_v0="${plain_3132}"
        return 0
    fi
    strip_ansi__679_v0 "${text_3129}"
    local stripped_3134="${ret_strip_ansi679_v0}"
    is_all_ascii__680_v0 "${stripped_3134}"
    local ret_is_all_ascii680_v0__46_12="${ret_is_all_ascii680_v0}"
    if [ "$(( ! ret_is_all_ascii680_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__672_v0 "${stripped_3134}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_86="${stripped_3134}"
            ret_get_visible_len682_v0="${#__length_86}"
            return 0
        fi
        ret_get_visible_len682_v0="${ret_perl_get_cjk_width672_v0}"
        return 0
    fi
    local __length_87="${stripped_3134}"
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
    local count_3202="${command_89}"
    parse_int__13_v0 "${count_3202}"
    __status=$?
    ret_stty_count688_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__689_v0() {
    stty_count__688_v0 
    local count_num_3203="${ret_stty_count688_v0}"
    if [ "$(( count_num_3203 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_3203="$(( count_num_3203 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3203}
    __status=$?
}

# stty_unlock()
stty_unlock__690_v0() {
    stty_count__688_v0 
    local count_num_3275="${ret_stty_count688_v0}"
    if [ "$(( count_num_3275 > 0 ))" != 0 ]; then
        count_num_3275="$(( count_num_3275 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3275}
        __status=$?
        if [ "$(( count_num_3275 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__691_v0() {
    local size_3118="${1}"
    if [ "$([ "_${size_3118}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size691_v0=0
        return 0
    fi
    split__4_v0 "${size_3118}" " "
    local parts_3119=("${ret_split4_v0[@]}")
    local __length_90=("${parts_3119[@]}")
    if [ "$(( ${#__length_90[@]} != 2 ))" != 0 ]; then
        ret_store_term_size691_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3119[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3119[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
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
    local size_3121="${command_92}"
    store_term_size__691_v0 "${size_3121}"
    ret_query_term_size692_v0="${ret_store_term_size691_v0}"
    return 0
}

# stty_term_size()
stty_term_size__693_v0() {
    local command_93
    command_93="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3117="${command_93}"
    store_term_size__691_v0 "${size_3117}"
    ret_stty_term_size693_v0="${ret_store_term_size691_v0}"
    return 0
}

# get_term_size()
get_term_size__694_v0() {
    stty_term_size__693_v0 
    local detected_3120="${ret_stty_term_size693_v0}"
    if [ "$(( ! detected_3120 ))" != 0 ]; then
        query_term_size__692_v0 
        detected_3120="${ret_query_term_size692_v0}"
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
    local cnt_3273="${1}"
    if [ "$(( cnt_3273 > 0 ))" != 0 ]; then
        local array_94=("")
        eprintf__664_v0 "\\x1b[${cnt_3273}D\\x1b[K" array_94[@]
    fi
}

# remove_line(cnt: Int)
remove_line__699_v0() {
    local cnt_3281="${1}"
    if [ "$(( cnt_3281 > 0 ))" != 0 ]; then
        local sequence_3282=""
        local __range_start_3283=0
        local __range_end_3283="${cnt_3281}"
        local __dir_3283=$(( ${__range_start_3283} <= ${__range_end_3283} ? 1 : -1 ))
        for (( ____3283=${__range_start_3283}; ____3283 * ${__dir_3283} < ${__range_end_3283} * ${__dir_3283}; ____3283+=${__dir_3283} )); do
            sequence_3282+="\\x1b[2K\\x1b[1A"
done
        local array_95=("")
        eprintf__664_v0 "${sequence_3282}" array_95[@]
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
    local cnt_3246="${1}"
    local __range_start_3247=0
    local __range_end_3247="${cnt_3246}"
    local __dir_3247=$(( ${__range_start_3247} <= ${__range_end_3247} ? 1 : -1 ))
    for (( ____3247=${__range_start_3247}; ____3247 * ${__dir_3247} < ${__range_end_3247} * ${__dir_3247}; ____3247+=${__dir_3247} )); do
        local array_98=("")
        eprintf__664_v0 "
" array_98[@]
done
}

# go_up(cnt: Int)
go_up__703_v0() {
    local cnt_3267="${1}"
    local array_99=("")
    eprintf__664_v0 "\\x1b[${cnt_3267}A" array_99[@]
}

# go_down(cnt: Int)
go_down__704_v0() {
    local cnt_3280="${1}"
    local array_100=("")
    eprintf__664_v0 "\\x1b[${cnt_3280}B" array_100[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__708_v0() {
    local pieces_3116=("${!1}")
    term_width__696_v0 
    local width_3122="${ret_term_width696_v0}"
    local line_3123=""
    local line_len_3124=0
    for piece_3125 in "${pieces_3116[@]}"; do
        local __length_103="${piece_3125}"
        local piece_len_3126="${#__length_103}"
        has_ansi_escape__677_v0 "${piece_3125}"
        local ret_has_ansi_escape677_v0__186_12="${ret_has_ansi_escape677_v0}"
        if [ "${ret_has_ansi_escape677_v0__186_12}" != 0 ]; then
            get_visible_len__682_v0 "${piece_3125}"
            piece_len_3126="${ret_get_visible_len682_v0}"
        fi
        if [ "$([ "_${line_3123}" != "_" ]; echo $?)" != 0 ]; then
            line_3123="${piece_3125}"
            line_len_3124="${piece_len_3126}"
        elif [ "$(( $(( $(( line_len_3124 + 1 )) + piece_len_3126 )) > width_3122 ))" != 0 ]; then
            local array_104=()
            printf__128_v0 "${line_3123}""
" array_104[@]
            line_3123="${piece_3125}"
            line_len_3124="${piece_len_3126}"
        else
            line_3123+=" ""${piece_3125}"
            line_len_3124="$(( line_len_3124 + $(( 1 + piece_len_3126 )) ))"
        fi
    done
    if [ "$([ "_${line_3123}" == "_" ]; echo $?)" != 0 ]; then
        local array_105=()
        printf__128_v0 "${line_3123}""
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
    local config_3154="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_3154}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor745_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__746_v0() {
    local message_3149="${1}"
    local r_3150="${2}"
    local g_3151="${3}"
    local b_3152="${4}"
    local fallback_3153="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb746_v0="\\x1b[38;2;${r_3150};${g_3151};${b_3152}m""${message_3149}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__745_v0 
        local ret_get_supports_truecolor745_v0__45_17="${ret_get_supports_truecolor745_v0}"
        if [ "${ret_get_supports_truecolor745_v0__45_17}" != 0 ]; then
            ret_colored_rgb746_v0="\\x1b[38;2;${r_3150};${g_3151};${b_3152}m""${message_3149}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_3153 == 0 ))" != 0 ]; then
            ret_colored_rgb746_v0="${message_3149}"
            return 0
        else
            ret_colored_rgb746_v0="\\x1b[${fallback_3153}m""${message_3149}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_3153 == 0 ))" != 0 ]; then
            ret_colored_rgb746_v0="${message_3149}"
            return 0
        fi
        ret_colored_rgb746_v0="\\x1b[${fallback_3153}m""${message_3149}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__748_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_3143="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_3143}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_3143}" ";"
            local parts_3144=("${ret_split4_v0[@]}")
            local __length_109=("${parts_3144[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3144[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3144[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3144[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3144[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_3145="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_3145}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_3145}" ";"
            local parts_3146=("${ret_split4_v0[@]}")
            local __length_111=("${parts_3146[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3146[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3146[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3146[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3146[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_3147="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_3147}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_3147}" ";"
            local parts_3148=("${ret_split4_v0[@]}")
            local __length_113=("${parts_3148[@]}")
            if [ "$(( ${#__length_113[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3148[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
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
    local message_3142="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__749_v0 
    fi
    colored_rgb__746_v0 "${message_3142}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary750_v0="${ret_colored_rgb746_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__751_v0() {
    local message_3156="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__749_v0 
    fi
    colored_rgb__746_v0 "${message_3156}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
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
        local disabled_3216
        disabled_3216="$([ "_${command_115}" != "_No" ]; echo $?)"
        local command_116
        command_116="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3217
        found_3217="$(( $(( ! disabled_3216 )) && $([ "_${command_116}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3217}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available768_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__769_v0() {
    local text_3215="${1}"
    perl_available__768_v0 
    local ret_perl_available768_v0__19_12="${ret_perl_available768_v0}"
    if [ "$(( ! ret_perl_available768_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return 1
    fi
    local command_117
    command_117="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3215}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return "${__status}"
    fi
    local width_str_3218="${command_117}"
    parse_int__13_v0 "${width_str_3218}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return "${__status}"
    fi
    local width_3219="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width769_v0="${width_3219}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__770_v0() {
    local text_3226="${1}"
    local max_width_3227="${2}"
    perl_available__768_v0 
    local ret_perl_available768_v0__30_12="${ret_perl_available768_v0}"
    if [ "$(( ! ret_perl_available768_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk770_v0=''
        return 1
    fi
    local command_118
    command_118="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3226}" ${max_width_3227} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk770_v0=''
        return "${__status}"
    fi
    local result_3228="${command_118}"
    ret_perl_truncate_cjk770_v0="${result_3228}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__774_v0() {
    local text_3194="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_119
    command_119="$([[ "${text_3194}" == *$'\x1b'* || "${text_3194}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3195="${command_119}"
    ret_has_ansi_escape774_v0="$([ "_${has_escape_3195}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__775_v0() {
    local text_3196="${1}"
    local command_120
    command_120="$(printf '%s' "${text_3196}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi775_v0="${command_120}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__776_v0() {
    local text_3211="${1}"
    local command_121
    command_121="$(printf "%s" "${text_3211}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi776_v0="${command_121}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__777_v0() {
    local text_3213="${1}"
    local command_122
    command_122="$(printf "%s" "${text_3213}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3214="${command_122}"
    ret_is_all_ascii777_v0="$([ "_${result_3214}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__778_v0() {
    local text_3208="${1}"
    local command_123
    command_123="$(LC_ALL=C; __t="${text_3208}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3209="${command_123}"
    parse_int__13_v0 "${measured_3209}"
    __status=$?
    ret_plain_len778_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__779_v0() {
    local text_3207="${1}"
    plain_len__778_v0 "${text_3207}"
    local plain_3210="${ret_plain_len778_v0}"
    if [ "$(( plain_3210 >= 0 ))" != 0 ]; then
        ret_get_visible_len779_v0="${plain_3210}"
        return 0
    fi
    strip_ansi__776_v0 "${text_3207}"
    local stripped_3212="${ret_strip_ansi776_v0}"
    is_all_ascii__777_v0 "${stripped_3212}"
    local ret_is_all_ascii777_v0__46_12="${ret_is_all_ascii777_v0}"
    if [ "$(( ! ret_is_all_ascii777_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__769_v0 "${stripped_3212}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_124="${stripped_3212}"
            ret_get_visible_len779_v0="${#__length_124}"
            return 0
        fi
        ret_get_visible_len779_v0="${ret_perl_get_cjk_width769_v0}"
        return 0
    fi
    local __length_125="${stripped_3212}"
    ret_get_visible_len779_v0="${#__length_125}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__780_v0() {
    local text_3223="${1}"
    local max_width_3224="${2}"
    get_visible_len__779_v0 "${text_3223}"
    local visible_len_3225="${ret_get_visible_len779_v0}"
    if [ "$(( visible_len_3225 <= max_width_3224 ))" != 0 ]; then
        ret_truncate_text780_v0="${text_3223}"
        return 0
    fi
    is_all_ascii__777_v0 "${text_3223}"
    local ret_is_all_ascii777_v0__61_12="${ret_is_all_ascii777_v0}"
    if [ "$(( ! ret_is_all_ascii777_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__770_v0 "${text_3223}" "${max_width_3224}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3223}" | cut -c1-${max_width_3224}
            __status=$?
        fi
        ret_truncate_text780_v0="${ret_perl_truncate_cjk770_v0}"
        return 0
    fi
    local command_126
    command_126="$(printf "%s" "${text_3223}" | cut -c1-${max_width_3224})"
    __status=$?
    ret_truncate_text780_v0="${command_126}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__781_v0() {
    local text_3221="${1}"
    local max_width_3222="${2}"
    has_ansi_escape__774_v0 "${text_3221}"
    local ret_has_ansi_escape774_v0__73_12="${ret_has_ansi_escape774_v0}"
    if [ "$(( ! ret_has_ansi_escape774_v0__73_12 ))" != 0 ]; then
        truncate_text__780_v0 "${text_3221}" "${max_width_3222}"
        ret_truncate_ansi781_v0="${ret_truncate_text780_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_127
    command_127="$([[ "${text_3221}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3229="${command_127}"
    # Replace \x1b[ with newline, then split
    local command_128
    command_128="$(t="${text_3221}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3230="${command_128}"
    split__4_v0 "${replaced_3230}" "
"
    local parts_3231=("${ret_split4_v0[@]}")
    local result_3232=""
    local remaining_width_3233="${max_width_3222}"
    local __range_start_3234=0
    local __length_129=("${parts_3231[@]}")
    local __range_end_3234="${#__length_129[@]}"
    local __dir_3234=$(( ${__range_start_3234} <= ${__range_end_3234} ? 1 : -1 ))
    for (( idx_3234=${__range_start_3234}; idx_3234 * ${__dir_3234} < ${__range_end_3234} * ${__dir_3234}; idx_3234+=${__dir_3234} )); do
        local part_3235="${parts_3231[${idx_3234}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3234 == 0 )) && $([ "_${starts_with_ansi_3229}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3235}" == "_" ]; echo $?) && $(( remaining_width_3233 > 0 )) ))" != 0 ]; then
                truncate_text__780_v0 "${part_3235}" "${remaining_width_3233}"
                local ret_truncate_text780_v0__95_35="${ret_truncate_text780_v0}"
                local truncated_3236="${ret_truncate_text780_v0__95_35}"
                result_3232+="${truncated_3236}"
                get_visible_len__779_v0 "${truncated_3236}"
                local ret_get_visible_len779_v0__97_36="${ret_get_visible_len779_v0}"
                remaining_width_3233="$(( remaining_width_3233 - ret_get_visible_len779_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_130
            command_130="$(__p="${part_3235}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3237="${command_130}"
            if [ "$([ "_${m_idx_3237}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_131
                command_131="$(__p="${part_3235}"; printf "%s" "${__p:0:${m_idx_3237}}")"
                __status=$?
                local ansi_params_3238="${command_131}"
                result_3232+="\\x1b[""${ansi_params_3238}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3237}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_3239="${ret_parse_int13_v0__108_41}"
                local text_start_3240="$(( m_idx_num_3239 + 1 ))"
                local command_132
                command_132="$(__p="${part_3235}"; printf "%s" "${__p:${text_start_3240}}")"
                __status=$?
                local text_part_3241="${command_132}"
                if [ "$(( $([ "_${text_part_3241}" == "_" ]; echo $?) && $(( remaining_width_3233 > 0 )) ))" != 0 ]; then
                    truncate_text__780_v0 "${text_part_3241}" "${remaining_width_3233}"
                    local ret_truncate_text780_v0__112_39="${ret_truncate_text780_v0}"
                    local truncated_3242="${ret_truncate_text780_v0__112_39}"
                    result_3232+="${truncated_3242}"
                    get_visible_len__779_v0 "${truncated_3242}"
                    local ret_get_visible_len779_v0__114_40="${ret_get_visible_len779_v0}"
                    remaining_width_3233="$(( remaining_width_3233 - ret_get_visible_len779_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3235}" == "_" ]; echo $?) && $(( remaining_width_3233 > 0 )) ))" != 0 ]; then
                    truncate_text__780_v0 "${part_3235}" "${remaining_width_3233}"
                    local ret_truncate_text780_v0__119_39="${ret_truncate_text780_v0}"
                    local truncated_3243="${ret_truncate_text780_v0__119_39}"
                    result_3232+="${truncated_3243}"
                    get_visible_len__779_v0 "${truncated_3243}"
                    local ret_get_visible_len779_v0__121_40="${ret_get_visible_len779_v0}"
                    remaining_width_3233="$(( remaining_width_3233 - ret_get_visible_len779_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi781_v0="${result_3232}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__782_v0() {
    local text_3205="${1}"
    local max_width_3206="${2}"
    get_visible_len__779_v0 "${text_3205}"
    local visible_len_3220="${ret_get_visible_len779_v0}"
    if [ "$(( visible_len_3220 <= max_width_3206 ))" != 0 ]; then
        ret_cutoff_text782_v0="${text_3205}"
        return 0
    fi
    truncate_ansi__781_v0 "${text_3205}" "$(( max_width_3206 - 3 ))"
    local ret_truncate_ansi781_v0__137_12="${ret_truncate_ansi781_v0}"
    ret_cutoff_text782_v0="${ret_truncate_ansi781_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__803_v0() {
    local format_3258="${1}"
    local args_3259=("${!2}")
    args_3259=("${format_3258}" "${args_3259[@]}")
    __status=$?
    printf "${args_3259[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__804_v0() {
    local message_3256="${1}"
    local color_3257="${2}"
    # Prints an error message with a specified color.
    local array_133=("${message_3256}")
    eprintf__803_v0 "\\x1b[${color_3257}m%s\\x1b[0m" array_133[@]
}

# colored(message: Text, color: Int)
colored__805_v0() {
    local message_3190="${1}"
    local color_3191="${2}"
    # Returns a text wrapped in color codes.
    ret_colored805_v0="\\x1b[${color_3191}m""${message_3190}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__809_v0() {
    local items_3250=("${!1}")
    local total_len_3251="${2}"
    local term_width_3252="${3}"
    local separator_3253=" • "
    local separator_len_3254=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3251 <= term_width_3252 ))" != 0 ]; then
        local iter_3255=0
        while :
        do
            local __length_134=("${items_3250[@]}")
            if [ "$(( iter_3255 >= ${#__length_134[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3255 > 0 ))" != 0 ]; then
                eprintf_colored__804_v0 "${separator_3253}" 90
            fi
            colored__805_v0 "${items_3250[$(( iter_3255 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored805_v0__23_41="${ret_colored805_v0}"
            local array_135=("")
            eprintf__803_v0 "${items_3250[${iter_3255}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored805_v0__23_41}" array_135[@]
            iter_3255="$(( iter_3255 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3260=0
        local first_3261=1
        local iter_3262=0
        while :
        do
            local __length_136=("${items_3250[@]}")
            if [ "$(( iter_3262 >= ${#__length_136[@]} ))" != 0 ]; then
                break
            fi
            local key_3263="${items_3250[${iter_3262}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3264="${items_3250[$(( iter_3262 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_137="${key_3263}"
            local __length_138="${action_3264}"
            local part_len_3265="$(( $(( ${#__length_137} + 1 )) + ${#__length_138} ))"
            local needed_3266="${part_len_3265}"
            if [ "$(( ! first_3261 ))" != 0 ]; then
                needed_3266="$(( needed_3266 + separator_len_3254 ))"
            fi
            if [ "$(( $(( current_len_3260 + needed_3266 )) > term_width_3252 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3261 ))" != 0 ]; then
                eprintf_colored__804_v0 "${separator_3253}" 90
            fi
            colored__805_v0 "${action_3264}" 2
            local ret_colored805_v0__51_33="${ret_colored805_v0}"
            local array_139=("")
            eprintf__803_v0 "${key_3263}"" ""${ret_colored805_v0__51_33}" array_139[@]
            current_len_3260="$(( current_len_3260 + needed_3266 ))"
            first_3261=0
            iter_3262="$(( iter_3262 + 2 ))"
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
    local size_3169="${1}"
    if [ "$([ "_${size_3169}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size846_v0=0
        return 0
    fi
    split__4_v0 "${size_3169}" " "
    local parts_3170=("${ret_split4_v0[@]}")
    local __length_141=("${parts_3170[@]}")
    if [ "$(( ${#__length_141[@]} != 2 ))" != 0 ]; then
        ret_store_term_size846_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3170[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3170[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
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
    local size_3172="${command_143}"
    store_term_size__846_v0 "${size_3172}"
    ret_query_term_size847_v0="${ret_store_term_size846_v0}"
    return 0
}

# stty_term_size()
stty_term_size__848_v0() {
    local command_144
    command_144="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3168="${command_144}"
    store_term_size__846_v0 "${size_3168}"
    ret_stty_term_size848_v0="${ret_store_term_size846_v0}"
    return 0
}

# get_term_size()
get_term_size__849_v0() {
    stty_term_size__848_v0 
    local detected_3171="${ret_stty_term_size848_v0}"
    if [ "$(( ! detected_3171 ))" != 0 ]; then
        query_term_size__847_v0 
        detected_3171="${ret_query_term_size847_v0}"
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
    local pending_3187="${1}"
    local line_3188="${2}"
    local note_at_3189="${3}"
    if [ "$(( note_at_3189 < 0 ))" != 0 ]; then
        local array_146=()
        printf__128_v0 "${pending_3187}""${line_3188}""
" array_146[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3189 == 0 ))" != 0 ]; then
        colored__805_v0 "${line_3188}" 90
        local ret_colored805_v0__12_40="${ret_colored805_v0}"
        local array_147=()
        printf__128_v0 "${pending_3187}""${ret_colored805_v0__12_40}""
" array_147[@]
    else
        slice__24_v0 "${line_3188}" 0 "${note_at_3189}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3188}" "${note_at_3189}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__805_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored805_v0__13_58="${ret_colored805_v0}"
        local array_148=()
        printf__128_v0 "${pending_3187}""${ret_slice24_v0__13_32}""${ret_colored805_v0__13_58}""
" array_148[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__885_v0() {
    local names_3160=("${!1}")
    local texts_3161=("${!2}")
    local notes_3162=("${!3}")
    local min_name_width_3163="${4}"
    local __length_149=("${names_3160[@]}")
    local count_3164="${#__length_149[@]}"
    local name_width_3165="${min_name_width_3163}"
    local __range_start_3166=0
    local __range_end_3166="${count_3164}"
    local __dir_3166=$(( ${__range_start_3166} <= ${__range_end_3166} ? 1 : -1 ))
    for (( i_3166=${__range_start_3166}; i_3166 * ${__dir_3166} < ${__range_end_3166} * ${__dir_3166}; i_3166+=${__dir_3166} )); do
        local __length_150="${names_3160[${i_3166}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_3167="${#__length_150}"
        if [ "$(( width_3167 > name_width_3165 ))" != 0 ]; then
            name_width_3165="${width_3167}"
        fi
done
    term_width__851_v0 
    local width_3173="${ret_term_width851_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_3174="$(( name_width_3165 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_3175="$(( $(( width_3173 - indent_3174 )) < 24 ))"
    if [ "${stacked_3175}" != 0 ]; then
        indent_3174=6
    fi
    local avail_3176="$(( width_3173 - indent_3174 ))"
    rpad__28_v0 "" " " "${indent_3174}"
    local blank_3177="${ret_rpad28_v0}"
    local __range_start_3178=0
    local __range_end_3178="${count_3164}"
    local __dir_3178=$(( ${__range_start_3178} <= ${__range_end_3178} ? 1 : -1 ))
    for (( i_3178=${__range_start_3178}; i_3178 * ${__dir_3178} < ${__range_end_3178} * ${__dir_3178}; i_3178+=${__dir_3178} )); do
        local pending_3179="${blank_3177}"
        if [ "${stacked_3175}" != 0 ]; then
            local array_151=()
            printf__128_v0 "  ""${names_3160[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_151[@]
        else
            rpad__28_v0 "  ""${names_3160[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_3174}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_3179="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_3161[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_3180=("${ret_split4_v0__52_21[@]}")
        local __length_152=("${words_3180[@]}")
        local note_start_3181="${#__length_152[@]}"
        if [ "$([ "_${notes_3162[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_153="${notes_3162[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_153} > avail_3176 ))" != 0 ]; then
                split__4_v0 "${notes_3162[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_3180+=("${ret_split4_v0__58_26[@]}")
            else
                local array_154=("${notes_3162[${i_3178}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_3180+=("${array_154[@]}")
            fi
        fi
        local line_3182=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_3183=-1
        local __range_start_3184=0
        local __length_155=("${words_3180[@]}")
        local __range_end_3184="${#__length_155[@]}"
        local __dir_3184=$(( ${__range_start_3184} <= ${__range_end_3184} ? 1 : -1 ))
        for (( j_3184=${__range_start_3184}; j_3184 * ${__dir_3184} < ${__range_end_3184} * ${__dir_3184}; j_3184+=${__dir_3184} )); do
            local word_3185="${words_3180[${j_3184}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_3186
            candidate_3186="$(if [ "$([ "_${line_3182}" != "_" ]; echo $?)" != 0 ]; then echo "${word_3185}"; else echo "${line_3182}"" ""${word_3185}"; fi)"
            local __length_156="${candidate_3186}"
            if [ "$(( $(( ${#__length_156} > avail_3176 )) && $([ "_${line_3182}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__884_v0 "${pending_3179}" "${line_3182}" "${note_at_3183}"
                pending_3179="${blank_3177}"
                line_3182="${word_3185}"
                note_at_3183="$(if [ "$(( j_3184 >= note_start_3181 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_3184 >= note_start_3181 )) && $(( note_at_3183 < 0 )) ))" != 0 ]; then
                    local __length_157="${candidate_3186}"
                    local __length_158="${word_3185}"
                    note_at_3183="$(( ${#__length_157} - ${#__length_158} ))"
                fi
                line_3182="${candidate_3186}"
            fi
done
        print_help_line__884_v0 "${pending_3179}" "${line_3182}" "${note_at_3183}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__943_v0() {
    local prompt_3198="${1}"
    local placeholder_3199="${2}"
    local header_3200="${3}"
    local password_3201="${4}"
    stty_lock__689_v0 
    term_width__696_v0 
    local term_width_3204="${ret_term_width696_v0}"
    if [ "$([ "_${header_3200}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__782_v0 "${header_3200}" "${term_width_3204}"
        local ret_cutoff_text782_v0__25_17="${ret_cutoff_text782_v0}"
        local array_159=("")
        eprintf__648_v0 "${ret_cutoff_text782_v0__25_17}""
" array_159[@]
    fi
    new_line__702_v0 2
    # "enter submit" = 12
    local array_160=("enter" "submit")
    render_tooltip__809_v0 array_160[@] 12 "${term_width_3204}"
    go_up__703_v0 2
    local array_161=("")
    eprintf__648_v0 "\\x1b[G" array_161[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_162
    command_162="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3268="${command_162}"
    local char_3269=""
    local array_163=("")
    eprintf__648_v0 "${prompt_3198}" array_163[@]
    if [ "$([ "_${can_preset_3268}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__649_v0 "${placeholder_3199}" 90
        get_char__645_v0 
        char_3269="${ret_get_char645_v0}"
        local __length_164="${placeholder_3199}"
        remove__698_v0 "$(( ${#__length_164} + 1 ))"
    fi
    local __length_165="${prompt_3198}"
    remove__698_v0 "${#__length_165}"
    local text_3274=""
    if [ "$(( ! password_3201 ))" != 0 ]; then
        stty_unlock__690_v0 
        local command_166
        command_166="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3269}" -p "${prompt_3198}" text < /dev/tty; else read -e -p "${prompt_3198}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3274="${command_166}"
        stty_lock__689_v0 
    else
        local command_167
        command_167="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3269}" -p "${prompt_3198}" text < /dev/tty; else read -es -p "${prompt_3198}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3274="${command_167}"
    fi
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__779_v0 "${prompt_3198}""${text_3274}"
    local input_display_len_3276="${ret_get_visible_len779_v0}"
    math_ceil__637_v0 "$(( input_display_len_3276 / term_width_3204 ))"
    local input_lines_3279="${ret_math_ceil637_v0}"
    if [ "$(( input_lines_3279 < 3 ))" != 0 ]; then
        go_down__704_v0 "$(( 2 - input_lines_3279 ))"
        remove_line__699_v0 2
        remove_current_line__700_v0 
    fi
    if [ "$(( input_lines_3279 >= 3 ))" != 0 ]; then
        remove_line__699_v0 "${input_lines_3279}"
    fi
    if [ "$([ "_${header_3200}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__699_v0 1
        remove_current_line__700_v0 
    fi
    stty_unlock__690_v0 
    ret_xyl_input943_v0="${text_3274}"
    return 0
}

# print_input_help()
print_input_help__1043_v0() {
    local usage_3115=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__708_v0 usage_3115[@]
    printf '%s\n' ""
    colored_primary__750_v0 "input"
    local ret_colored_primary750_v0__8_20="${ret_colored_primary750_v0}"
    local title_3155=("${ret_colored_primary750_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__708_v0 title_3155[@]
    printf '%s\n' ""
    colored_secondary__751_v0 "Flags:"
    local ret_colored_secondary751_v0__11_12="${ret_colored_secondary751_v0}"
    local array_170=()
    printf__128_v0 "${ret_colored_secondary751_v0__11_12}""
" array_170[@]
    local names_3157=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_3158=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_3159=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__885_v0 names_3157[@] texts_3158[@] notes_3159[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1101_v0() {
    local parameters_3109=("${!1}")
    local prompt_3110="> "
    local placeholder_3111="Type here..."
    local header_3112=""
    local password_3113=0
    for param_3114 in "${parameters_3109[@]}"; do
        if [ "$(( $([ "_${param_3114}" != "_-h" ]; echo $?) || $([ "_${param_3114}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1043_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_3114}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_176="--prompt="
            slice__24_v0 "${param_3114}" "${#__length_176}" 0
            prompt_3110="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3114}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_177="--placeholder="
            slice__24_v0 "${param_3114}" "${#__length_177}" 0
            placeholder_3111="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3114}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_178="--header="
            slice__24_v0 "${param_3114}" "${#__length_178}" 0
            header_3112="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_3114}" != "_--password" ]; echo $?)" != 0 ]; then
            password_3113=1
        fi
    done
    has_ansi_escape__774_v0 "${header_3112}"
    local ret_has_ansi_escape774_v0__31_44="${ret_has_ansi_escape774_v0}"
    escape_ansi__775_v0 "${header_3112}"
    local ret_escape_ansi775_v0__31_73="${ret_escape_ansi775_v0}"
    colored_primary__750_v0 "${header_3112}"
    local ret_colored_primary750_v0__31_111="${ret_colored_primary750_v0}"
    local display_header_3197
    display_header_3197="$(if [ "$(( $([ "_${header_3112}" != "_" ]; echo $?) || ret_has_ansi_escape774_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi775_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary750_v0__31_111}"; fi)"
    xyl_input__943_v0 "${prompt_3110}" "${placeholder_3111}" "${display_header_3197}" "${password_3113}"
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
    local format_17976="${1}"
    local args_17977=("${!2}")
    args_17977=("${format_17976}" "${args_17977[@]}")
    __status=$?
    printf "${args_17977[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1185_v0() {
    local message_17974="${1}"
    local color_17975="${2}"
    # Prints an error message with a specified color.
    local array_180=("${message_17974}")
    eprintf__1184_v0 "\\x1b[${color_17975}m%s\\x1b[0m" array_180[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1200_v0() {
    local format_17997="${1}"
    local args_17998=("${!2}")
    args_17998=("${format_17997}" "${args_17998[@]}")
    __status=$?
    printf "${args_17998[@]}" >&2
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
        local disabled_17929
        disabled_17929="$([ "_${command_181}" != "_No" ]; echo $?)"
        local command_182
        command_182="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_17930
        found_17930="$(( $(( ! disabled_17929 )) && $([ "_${command_182}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_17930}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1207_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1208_v0() {
    local text_17928="${1}"
    perl_available__1207_v0 
    local ret_perl_available1207_v0__19_12="${ret_perl_available1207_v0}"
    if [ "$(( ! ret_perl_available1207_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return 1
    fi
    local command_183
    command_183="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_17928}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return "${__status}"
    fi
    local width_str_17931="${command_183}"
    parse_int__13_v0 "${width_str_17931}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return "${__status}"
    fi
    local width_17932="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1208_v0="${width_17932}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1213_v0() {
    local text_17918="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_184
    command_184="$([[ "${text_17918}" == *$'\x1b'* || "${text_17918}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17919="${command_184}"
    ret_has_ansi_escape1213_v0="$([ "_${has_escape_17919}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1215_v0() {
    local text_17924="${1}"
    local command_185
    command_185="$(printf "%s" "${text_17924}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1215_v0="${command_185}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1216_v0() {
    local text_17926="${1}"
    local command_186
    command_186="$(printf "%s" "${text_17926}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_17927="${command_186}"
    ret_is_all_ascii1216_v0="$([ "_${result_17927}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1217_v0() {
    local text_17921="${1}"
    local command_187
    command_187="$(LC_ALL=C; __t="${text_17921}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_17922="${command_187}"
    parse_int__13_v0 "${measured_17922}"
    __status=$?
    ret_plain_len1217_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1218_v0() {
    local text_17920="${1}"
    plain_len__1217_v0 "${text_17920}"
    local plain_17923="${ret_plain_len1217_v0}"
    if [ "$(( plain_17923 >= 0 ))" != 0 ]; then
        ret_get_visible_len1218_v0="${plain_17923}"
        return 0
    fi
    strip_ansi__1215_v0 "${text_17920}"
    local stripped_17925="${ret_strip_ansi1215_v0}"
    is_all_ascii__1216_v0 "${stripped_17925}"
    local ret_is_all_ascii1216_v0__46_12="${ret_is_all_ascii1216_v0}"
    if [ "$(( ! ret_is_all_ascii1216_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1208_v0 "${stripped_17925}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_188="${stripped_17925}"
            ret_get_visible_len1218_v0="${#__length_188}"
            return 0
        fi
        ret_get_visible_len1218_v0="${ret_perl_get_cjk_width1208_v0}"
        return 0
    fi
    local __length_189="${stripped_17925}"
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
    local count_17995="${command_191}"
    parse_int__13_v0 "${count_17995}"
    __status=$?
    ret_stty_count1224_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1225_v0() {
    stty_count__1224_v0 
    local count_num_17996="${ret_stty_count1224_v0}"
    if [ "$(( count_num_17996 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_17996="$(( count_num_17996 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_17996}
    __status=$?
}

# stty_unlock()
stty_unlock__1226_v0() {
    stty_count__1224_v0 
    local count_num_18116="${ret_stty_count1224_v0}"
    if [ "$(( count_num_18116 > 0 ))" != 0 ]; then
        count_num_18116="$(( count_num_18116 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18116}
        __status=$?
        if [ "$(( count_num_18116 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1227_v0() {
    local size_17909="${1}"
    if [ "$([ "_${size_17909}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1227_v0=0
        return 0
    fi
    split__4_v0 "${size_17909}" " "
    local parts_17910=("${ret_split4_v0[@]}")
    local __length_192=("${parts_17910[@]}")
    if [ "$(( ${#__length_192[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1227_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17910[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17910[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
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
    local size_17912="${command_194}"
    store_term_size__1227_v0 "${size_17912}"
    ret_query_term_size1228_v0="${ret_store_term_size1227_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1229_v0() {
    local command_195
    command_195="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17908="${command_195}"
    store_term_size__1227_v0 "${size_17908}"
    ret_stty_term_size1229_v0="${ret_store_term_size1227_v0}"
    return 0
}

# get_term_size()
get_term_size__1230_v0() {
    stty_term_size__1229_v0 
    local detected_17911="${ret_stty_term_size1229_v0}"
    if [ "$(( ! detected_17911 ))" != 0 ]; then
        query_term_size__1228_v0 
        detected_17911="${ret_query_term_size1228_v0}"
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
    local cnt_18088="${1}"
    if [ "$(( cnt_18088 > 0 ))" != 0 ]; then
        local sequence_18089=""
        local __range_start_18090=0
        local __range_end_18090="${cnt_18088}"
        local __dir_18090=$(( ${__range_start_18090} <= ${__range_end_18090} ? 1 : -1 ))
        for (( ____18090=${__range_start_18090}; ____18090 * ${__dir_18090} < ${__range_end_18090} * ${__dir_18090}; ____18090+=${__dir_18090} )); do
            sequence_18089+="\\x1b[2K\\x1b[1A"
done
        local array_196=("")
        eprintf__1200_v0 "${sequence_18089}" array_196[@]
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
    local cnt_18079="${1}"
    printf '%*s' "${cnt_18079}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1238_v0() {
    local cnt_18043="${1}"
    local __range_start_18044=0
    local __range_end_18044="${cnt_18043}"
    local __dir_18044=$(( ${__range_start_18044} <= ${__range_end_18044} ? 1 : -1 ))
    for (( ____18044=${__range_start_18044}; ____18044 * ${__dir_18044} < ${__range_end_18044} * ${__dir_18044}; ____18044+=${__dir_18044} )); do
        local array_199=("")
        eprintf__1200_v0 "
" array_199[@]
done
}

# go_up(cnt: Int)
go_up__1239_v0() {
    local cnt_18062="${1}"
    local array_200=("")
    eprintf__1200_v0 "\\x1b[${cnt_18062}A" array_200[@]
}

# go_down(cnt: Int)
go_down__1240_v0() {
    local cnt_18115="${1}"
    local array_201=("")
    eprintf__1200_v0 "\\x1b[${cnt_18115}B" array_201[@]
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
    local pieces_17907=("${!1}")
    term_width__1232_v0 
    local width_17913="${ret_term_width1232_v0}"
    local line_17914=""
    local line_len_17915=0
    for piece_17916 in "${pieces_17907[@]}"; do
        local __length_206="${piece_17916}"
        local piece_len_17917="${#__length_206}"
        has_ansi_escape__1213_v0 "${piece_17916}"
        local ret_has_ansi_escape1213_v0__186_12="${ret_has_ansi_escape1213_v0}"
        if [ "${ret_has_ansi_escape1213_v0__186_12}" != 0 ]; then
            get_visible_len__1218_v0 "${piece_17916}"
            piece_len_17917="${ret_get_visible_len1218_v0}"
        fi
        if [ "$([ "_${line_17914}" != "_" ]; echo $?)" != 0 ]; then
            line_17914="${piece_17916}"
            line_len_17915="${piece_len_17917}"
        elif [ "$(( $(( $(( line_len_17915 + 1 )) + piece_len_17917 )) > width_17913 ))" != 0 ]; then
            local array_207=()
            printf__128_v0 "${line_17914}""
" array_207[@]
            line_17914="${piece_17916}"
            line_len_17915="${piece_len_17917}"
        else
            line_17914+=" ""${piece_17916}"
            line_len_17915="$(( line_len_17915 + $(( 1 + piece_len_17917 )) ))"
        fi
    done
    if [ "$([ "_${line_17914}" == "_" ]; echo $?)" != 0 ]; then
        local array_208=()
        printf__128_v0 "${line_17914}""
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
    local config_17897="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_17897}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1281_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1282_v0() {
    local message_17892="${1}"
    local r_17893="${2}"
    local g_17894="${3}"
    local b_17895="${4}"
    local fallback_17896="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1282_v0="\\x1b[38;2;${r_17893};${g_17894};${b_17895}m""${message_17892}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1281_v0 
        local ret_get_supports_truecolor1281_v0__45_17="${ret_get_supports_truecolor1281_v0}"
        if [ "${ret_get_supports_truecolor1281_v0__45_17}" != 0 ]; then
            ret_colored_rgb1282_v0="\\x1b[38;2;${r_17893};${g_17894};${b_17895}m""${message_17892}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_17896 == 0 ))" != 0 ]; then
            ret_colored_rgb1282_v0="${message_17892}"
            return 0
        else
            ret_colored_rgb1282_v0="\\x1b[${fallback_17896}m""${message_17892}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_17896 == 0 ))" != 0 ]; then
            ret_colored_rgb1282_v0="${message_17892}"
            return 0
        fi
        ret_colored_rgb1282_v0="\\x1b[${fallback_17896}m""${message_17892}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1284_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_17886="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_17886}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_17886}" ";"
            local parts_17887=("${ret_split4_v0[@]}")
            local __length_212=("${parts_17887[@]}")
            if [ "$(( ${#__length_212[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17887[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17887[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17887[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17887[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_17888="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_17888}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_17888}" ";"
            local parts_17889=("${ret_split4_v0[@]}")
            local __length_214=("${parts_17889[@]}")
            if [ "$(( ${#__length_214[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17889[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17889[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17889[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17889[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_17890="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_17890}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_17890}" ";"
            local parts_17891=("${ret_split4_v0[@]}")
            local __length_216=("${parts_17891[@]}")
            if [ "$(( ${#__length_216[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17891[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
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
    local message_17885="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1285_v0 
    fi
    colored_rgb__1282_v0 "${message_17885}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1286_v0="${ret_colored_rgb1282_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1287_v0() {
    local message_17934="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1285_v0 
    fi
    colored_rgb__1282_v0 "${message_17934}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
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
        local disabled_18012
        disabled_18012="$([ "_${command_218}" != "_No" ]; echo $?)"
        local command_219
        command_219="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18013
        found_18013="$(( $(( ! disabled_18012 )) && $([ "_${command_219}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_18013}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1304_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1305_v0() {
    local text_18011="${1}"
    perl_available__1304_v0 
    local ret_perl_available1304_v0__19_12="${ret_perl_available1304_v0}"
    if [ "$(( ! ret_perl_available1304_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return 1
    fi
    local command_220
    command_220="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18011}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return "${__status}"
    fi
    local width_str_18014="${command_220}"
    parse_int__13_v0 "${width_str_18014}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return "${__status}"
    fi
    local width_18015="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1305_v0="${width_18015}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1306_v0() {
    local text_18022="${1}"
    local max_width_18023="${2}"
    perl_available__1304_v0 
    local ret_perl_available1304_v0__30_12="${ret_perl_available1304_v0}"
    if [ "$(( ! ret_perl_available1304_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1306_v0=''
        return 1
    fi
    local command_221
    command_221="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18022}" ${max_width_18023} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1306_v0=''
        return "${__status}"
    fi
    local result_18024="${command_221}"
    ret_perl_truncate_cjk1306_v0="${result_18024}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1310_v0() {
    local text_17979="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_222
    command_222="$([[ "${text_17979}" == *$'\x1b'* || "${text_17979}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17980="${command_222}"
    ret_has_ansi_escape1310_v0="$([ "_${has_escape_17980}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1311_v0() {
    local text_17981="${1}"
    local command_223
    command_223="$(printf '%s' "${text_17981}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1311_v0="${command_223}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1312_v0() {
    local text_18007="${1}"
    local command_224
    command_224="$(printf "%s" "${text_18007}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1312_v0="${command_224}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1313_v0() {
    local text_18009="${1}"
    local command_225
    command_225="$(printf "%s" "${text_18009}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18010="${command_225}"
    ret_is_all_ascii1313_v0="$([ "_${result_18010}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1314_v0() {
    local text_18004="${1}"
    local command_226
    command_226="$(LC_ALL=C; __t="${text_18004}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_18005="${command_226}"
    parse_int__13_v0 "${measured_18005}"
    __status=$?
    ret_plain_len1314_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1315_v0() {
    local text_18003="${1}"
    plain_len__1314_v0 "${text_18003}"
    local plain_18006="${ret_plain_len1314_v0}"
    if [ "$(( plain_18006 >= 0 ))" != 0 ]; then
        ret_get_visible_len1315_v0="${plain_18006}"
        return 0
    fi
    strip_ansi__1312_v0 "${text_18003}"
    local stripped_18008="${ret_strip_ansi1312_v0}"
    is_all_ascii__1313_v0 "${stripped_18008}"
    local ret_is_all_ascii1313_v0__46_12="${ret_is_all_ascii1313_v0}"
    if [ "$(( ! ret_is_all_ascii1313_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1305_v0 "${stripped_18008}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_227="${stripped_18008}"
            ret_get_visible_len1315_v0="${#__length_227}"
            return 0
        fi
        ret_get_visible_len1315_v0="${ret_perl_get_cjk_width1305_v0}"
        return 0
    fi
    local __length_228="${stripped_18008}"
    ret_get_visible_len1315_v0="${#__length_228}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1316_v0() {
    local text_18019="${1}"
    local max_width_18020="${2}"
    get_visible_len__1315_v0 "${text_18019}"
    local visible_len_18021="${ret_get_visible_len1315_v0}"
    if [ "$(( visible_len_18021 <= max_width_18020 ))" != 0 ]; then
        ret_truncate_text1316_v0="${text_18019}"
        return 0
    fi
    is_all_ascii__1313_v0 "${text_18019}"
    local ret_is_all_ascii1313_v0__61_12="${ret_is_all_ascii1313_v0}"
    if [ "$(( ! ret_is_all_ascii1313_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1306_v0 "${text_18019}" "${max_width_18020}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18019}" | cut -c1-${max_width_18020}
            __status=$?
        fi
        ret_truncate_text1316_v0="${ret_perl_truncate_cjk1306_v0}"
        return 0
    fi
    local command_229
    command_229="$(printf "%s" "${text_18019}" | cut -c1-${max_width_18020})"
    __status=$?
    ret_truncate_text1316_v0="${command_229}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1317_v0() {
    local text_18017="${1}"
    local max_width_18018="${2}"
    has_ansi_escape__1310_v0 "${text_18017}"
    local ret_has_ansi_escape1310_v0__73_12="${ret_has_ansi_escape1310_v0}"
    if [ "$(( ! ret_has_ansi_escape1310_v0__73_12 ))" != 0 ]; then
        truncate_text__1316_v0 "${text_18017}" "${max_width_18018}"
        ret_truncate_ansi1317_v0="${ret_truncate_text1316_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_230
    command_230="$([[ "${text_18017}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18025="${command_230}"
    # Replace \x1b[ with newline, then split
    local command_231
    command_231="$(t="${text_18017}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18026="${command_231}"
    split__4_v0 "${replaced_18026}" "
"
    local parts_18027=("${ret_split4_v0[@]}")
    local result_18028=""
    local remaining_width_18029="${max_width_18018}"
    local __range_start_18030=0
    local __length_232=("${parts_18027[@]}")
    local __range_end_18030="${#__length_232[@]}"
    local __dir_18030=$(( ${__range_start_18030} <= ${__range_end_18030} ? 1 : -1 ))
    for (( idx_18030=${__range_start_18030}; idx_18030 * ${__dir_18030} < ${__range_end_18030} * ${__dir_18030}; idx_18030+=${__dir_18030} )); do
        local part_18031="${parts_18027[${idx_18030}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18030 == 0 )) && $([ "_${starts_with_ansi_18025}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18031}" == "_" ]; echo $?) && $(( remaining_width_18029 > 0 )) ))" != 0 ]; then
                truncate_text__1316_v0 "${part_18031}" "${remaining_width_18029}"
                local ret_truncate_text1316_v0__95_35="${ret_truncate_text1316_v0}"
                local truncated_18032="${ret_truncate_text1316_v0__95_35}"
                result_18028+="${truncated_18032}"
                get_visible_len__1315_v0 "${truncated_18032}"
                local ret_get_visible_len1315_v0__97_36="${ret_get_visible_len1315_v0}"
                remaining_width_18029="$(( remaining_width_18029 - ret_get_visible_len1315_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_233
            command_233="$(__p="${part_18031}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18033="${command_233}"
            if [ "$([ "_${m_idx_18033}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_234
                command_234="$(__p="${part_18031}"; printf "%s" "${__p:0:${m_idx_18033}}")"
                __status=$?
                local ansi_params_18034="${command_234}"
                result_18028+="\\x1b[""${ansi_params_18034}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18033}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_18035="${ret_parse_int13_v0__108_41}"
                local text_start_18036="$(( m_idx_num_18035 + 1 ))"
                local command_235
                command_235="$(__p="${part_18031}"; printf "%s" "${__p:${text_start_18036}}")"
                __status=$?
                local text_part_18037="${command_235}"
                if [ "$(( $([ "_${text_part_18037}" == "_" ]; echo $?) && $(( remaining_width_18029 > 0 )) ))" != 0 ]; then
                    truncate_text__1316_v0 "${text_part_18037}" "${remaining_width_18029}"
                    local ret_truncate_text1316_v0__112_39="${ret_truncate_text1316_v0}"
                    local truncated_18038="${ret_truncate_text1316_v0__112_39}"
                    result_18028+="${truncated_18038}"
                    get_visible_len__1315_v0 "${truncated_18038}"
                    local ret_get_visible_len1315_v0__114_40="${ret_get_visible_len1315_v0}"
                    remaining_width_18029="$(( remaining_width_18029 - ret_get_visible_len1315_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18031}" == "_" ]; echo $?) && $(( remaining_width_18029 > 0 )) ))" != 0 ]; then
                    truncate_text__1316_v0 "${part_18031}" "${remaining_width_18029}"
                    local ret_truncate_text1316_v0__119_39="${ret_truncate_text1316_v0}"
                    local truncated_18039="${ret_truncate_text1316_v0__119_39}"
                    result_18028+="${truncated_18039}"
                    get_visible_len__1315_v0 "${truncated_18039}"
                    local ret_get_visible_len1315_v0__121_40="${ret_get_visible_len1315_v0}"
                    remaining_width_18029="$(( remaining_width_18029 - ret_get_visible_len1315_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1317_v0="${result_18028}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1318_v0() {
    local text_18001="${1}"
    local max_width_18002="${2}"
    get_visible_len__1315_v0 "${text_18001}"
    local visible_len_18016="${ret_get_visible_len1315_v0}"
    if [ "$(( visible_len_18016 <= max_width_18002 ))" != 0 ]; then
        ret_cutoff_text1318_v0="${text_18001}"
        return 0
    fi
    truncate_ansi__1317_v0 "${text_18001}" "$(( max_width_18002 - 3 ))"
    local ret_truncate_ansi1317_v0__137_12="${ret_truncate_ansi1317_v0}"
    ret_cutoff_text1318_v0="${ret_truncate_ansi1317_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1339_v0() {
    local format_18053="${1}"
    local args_18054=("${!2}")
    args_18054=("${format_18053}" "${args_18054[@]}")
    __status=$?
    printf "${args_18054[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1340_v0() {
    local message_18051="${1}"
    local color_18052="${2}"
    # Prints an error message with a specified color.
    local array_236=("${message_18051}")
    eprintf__1339_v0 "\\x1b[${color_18052}m%s\\x1b[0m" array_236[@]
}

# colored(message: Text, color: Int)
colored__1341_v0() {
    local message_17968="${1}"
    local color_17969="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1341_v0="\\x1b[${color_17969}m""${message_17968}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1345_v0() {
    local items_18045=("${!1}")
    local total_len_18046="${2}"
    local term_width_18047="${3}"
    local separator_18048=" • "
    local separator_len_18049=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18046 <= term_width_18047 ))" != 0 ]; then
        local iter_18050=0
        while :
        do
            local __length_237=("${items_18045[@]}")
            if [ "$(( iter_18050 >= ${#__length_237[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18050 > 0 ))" != 0 ]; then
                eprintf_colored__1340_v0 "${separator_18048}" 90
            fi
            colored__1341_v0 "${items_18045[$(( iter_18050 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1341_v0__23_41="${ret_colored1341_v0}"
            local array_238=("")
            eprintf__1339_v0 "${items_18045[${iter_18050}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1341_v0__23_41}" array_238[@]
            iter_18050="$(( iter_18050 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18055=0
        local first_18056=1
        local iter_18057=0
        while :
        do
            local __length_239=("${items_18045[@]}")
            if [ "$(( iter_18057 >= ${#__length_239[@]} ))" != 0 ]; then
                break
            fi
            local key_18058="${items_18045[${iter_18057}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_18059="${items_18045[$(( iter_18057 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_240="${key_18058}"
            local __length_241="${action_18059}"
            local part_len_18060="$(( $(( ${#__length_240} + 1 )) + ${#__length_241} ))"
            local needed_18061="${part_len_18060}"
            if [ "$(( ! first_18056 ))" != 0 ]; then
                needed_18061="$(( needed_18061 + separator_len_18049 ))"
            fi
            if [ "$(( $(( current_len_18055 + needed_18061 )) > term_width_18047 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18056 ))" != 0 ]; then
                eprintf_colored__1340_v0 "${separator_18048}" 90
            fi
            colored__1341_v0 "${action_18059}" 2
            local ret_colored1341_v0__51_33="${ret_colored1341_v0}"
            local array_242=("")
            eprintf__1339_v0 "${key_18058}"" ""${ret_colored1341_v0__51_33}" array_242[@]
            current_len_18055="$(( current_len_18055 + needed_18061 ))"
            first_18056=0
            iter_18057="$(( iter_18057 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1355_v0() {
    local format_18104="${1}"
    local args_18105=("${!2}")
    args_18105=("${format_18104}" "${args_18105[@]}")
    __status=$?
    printf "${args_18105[@]}" >&2
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
    local size_17947="${1}"
    if [ "$([ "_${size_17947}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1382_v0=0
        return 0
    fi
    split__4_v0 "${size_17947}" " "
    local parts_17948=("${ret_split4_v0[@]}")
    local __length_244=("${parts_17948[@]}")
    if [ "$(( ${#__length_244[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1382_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17948[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17948[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
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
    local size_17950="${command_246}"
    store_term_size__1382_v0 "${size_17950}"
    ret_query_term_size1383_v0="${ret_store_term_size1382_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1384_v0() {
    local command_247
    command_247="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17946="${command_247}"
    store_term_size__1382_v0 "${size_17946}"
    ret_stty_term_size1384_v0="${ret_store_term_size1382_v0}"
    return 0
}

# get_term_size()
get_term_size__1385_v0() {
    stty_term_size__1384_v0 
    local detected_17949="${ret_stty_term_size1384_v0}"
    if [ "$(( ! detected_17949 ))" != 0 ]; then
        query_term_size__1383_v0 
        detected_17949="${ret_query_term_size1383_v0}"
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
    local cnt_18103="${1}"
    local array_248=("")
    eprintf__1355_v0 "\\x1b[${cnt_18103}A" array_248[@]
}

# go_down(cnt: Int)
go_down__1395_v0() {
    local cnt_18106="${1}"
    local array_249=("")
    eprintf__1355_v0 "\\x1b[${cnt_18106}B" array_249[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1402_v0() {
    local display_count_18100="${1}"
    local index_18101="${2}"
    local line_18102="${3}"
    go_up__1394_v0 "$(( display_count_18100 - index_18101 ))"
    local array_250=("")
    eprintf__1339_v0 "\\x1b[G\\x1b[K" array_250[@]
    local array_251=("")
    eprintf__1339_v0 "${line_18102}" array_251[@]
    go_down__1395_v0 "$(( display_count_18100 - index_18101 ))"
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
    local total_18040="${1}"
    local limit_18041="${2}"
    _checked_61=()
    local __range_start_18042=0
    local __range_end_18042="${total_18040}"
    local __dir_18042=$(( ${__range_start_18042} <= ${__range_end_18042} ? 1 : -1 ))
    for (( ____18042=${__range_start_18042}; ____18042 * ${__dir_18042} < ${__range_end_18042} * ${__dir_18042}; ____18042+=${__dir_18042} )); do
        local array_255=(0)
        _checked_61+=("${array_255[@]}")
done
    _count_62=0
    _total_63="${total_18040}"
    _limit_64="${limit_18041}"
}

# checked_is(index: Int)
checked_is__1405_v0() {
    local index_18076="${1}"
    ret_checked_is1405_v0="${_checked_61[${index_18076}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1407_v0() {
    local index_18095="${1}"
    if [ "${_checked_61[${index_18095}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_61["${index_18095}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1407_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1407_v0=0
        return 0
    fi
    _checked_61["${index_18095}"]=1
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
    local was_all_18107="$(( _count_62 == _total_63 ))"
    local __range_start_18108=0
    local __range_end_18108="${_total_63}"
    local __dir_18108=$(( ${__range_start_18108} <= ${__range_end_18108} ? 1 : -1 ))
    for (( i_18108=${__range_start_18108}; i_18108 * ${__dir_18108} < ${__range_end_18108} * ${__dir_18108}; i_18108+=${__dir_18108} )); do
        _checked_61["${i_18108}"]="$(( ! was_all_18107 ))"
done
    if [ "${was_all_18107}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1408_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1420_v0() {
    local pending_17965="${1}"
    local line_17966="${2}"
    local note_at_17967="${3}"
    if [ "$(( note_at_17967 < 0 ))" != 0 ]; then
        local array_256=()
        printf__128_v0 "${pending_17965}""${line_17966}""
" array_256[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_17967 == 0 ))" != 0 ]; then
        colored__1341_v0 "${line_17966}" 90
        local ret_colored1341_v0__12_40="${ret_colored1341_v0}"
        local array_257=()
        printf__128_v0 "${pending_17965}""${ret_colored1341_v0__12_40}""
" array_257[@]
    else
        slice__24_v0 "${line_17966}" 0 "${note_at_17967}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_17966}" "${note_at_17967}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1341_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1341_v0__13_58="${ret_colored1341_v0}"
        local array_258=()
        printf__128_v0 "${pending_17965}""${ret_slice24_v0__13_32}""${ret_colored1341_v0__13_58}""
" array_258[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1421_v0() {
    local names_17938=("${!1}")
    local texts_17939=("${!2}")
    local notes_17940=("${!3}")
    local min_name_width_17941="${4}"
    local __length_259=("${names_17938[@]}")
    local count_17942="${#__length_259[@]}"
    local name_width_17943="${min_name_width_17941}"
    local __range_start_17944=0
    local __range_end_17944="${count_17942}"
    local __dir_17944=$(( ${__range_start_17944} <= ${__range_end_17944} ? 1 : -1 ))
    for (( i_17944=${__range_start_17944}; i_17944 * ${__dir_17944} < ${__range_end_17944} * ${__dir_17944}; i_17944+=${__dir_17944} )); do
        local __length_260="${names_17938[${i_17944}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_17945="${#__length_260}"
        if [ "$(( width_17945 > name_width_17943 ))" != 0 ]; then
            name_width_17943="${width_17945}"
        fi
done
    term_width__1387_v0 
    local width_17951="${ret_term_width1387_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_17952="$(( name_width_17943 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_17953="$(( $(( width_17951 - indent_17952 )) < 24 ))"
    if [ "${stacked_17953}" != 0 ]; then
        indent_17952=6
    fi
    local avail_17954="$(( width_17951 - indent_17952 ))"
    rpad__28_v0 "" " " "${indent_17952}"
    local blank_17955="${ret_rpad28_v0}"
    local __range_start_17956=0
    local __range_end_17956="${count_17942}"
    local __dir_17956=$(( ${__range_start_17956} <= ${__range_end_17956} ? 1 : -1 ))
    for (( i_17956=${__range_start_17956}; i_17956 * ${__dir_17956} < ${__range_end_17956} * ${__dir_17956}; i_17956+=${__dir_17956} )); do
        local pending_17957="${blank_17955}"
        if [ "${stacked_17953}" != 0 ]; then
            local array_261=()
            printf__128_v0 "  ""${names_17938[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_261[@]
        else
            rpad__28_v0 "  ""${names_17938[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_17952}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_17957="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_17939[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_17958=("${ret_split4_v0__52_21[@]}")
        local __length_262=("${words_17958[@]}")
        local note_start_17959="${#__length_262[@]}"
        if [ "$([ "_${notes_17940[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_263="${notes_17940[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_263} > avail_17954 ))" != 0 ]; then
                split__4_v0 "${notes_17940[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_17958+=("${ret_split4_v0__58_26[@]}")
            else
                local array_264=("${notes_17940[${i_17956}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_17958+=("${array_264[@]}")
            fi
        fi
        local line_17960=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_17961=-1
        local __range_start_17962=0
        local __length_265=("${words_17958[@]}")
        local __range_end_17962="${#__length_265[@]}"
        local __dir_17962=$(( ${__range_start_17962} <= ${__range_end_17962} ? 1 : -1 ))
        for (( j_17962=${__range_start_17962}; j_17962 * ${__dir_17962} < ${__range_end_17962} * ${__dir_17962}; j_17962+=${__dir_17962} )); do
            local word_17963="${words_17958[${j_17962}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_17964
            candidate_17964="$(if [ "$([ "_${line_17960}" != "_" ]; echo $?)" != 0 ]; then echo "${word_17963}"; else echo "${line_17960}"" ""${word_17963}"; fi)"
            local __length_266="${candidate_17964}"
            if [ "$(( $(( ${#__length_266} > avail_17954 )) && $([ "_${line_17960}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1420_v0 "${pending_17957}" "${line_17960}" "${note_at_17961}"
                pending_17957="${blank_17955}"
                line_17960="${word_17963}"
                note_at_17961="$(if [ "$(( j_17962 >= note_start_17959 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_17962 >= note_start_17959 )) && $(( note_at_17961 < 0 )) ))" != 0 ]; then
                    local __length_267="${candidate_17964}"
                    local __length_268="${word_17963}"
                    note_at_17961="$(( ${#__length_267} - ${#__length_268} ))"
                fi
                line_17960="${candidate_17964}"
            fi
done
        print_help_line__1420_v0 "${pending_17957}" "${line_17960}" "${note_at_17961}"
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
    local cursor_len_18082="${#__length_270}"
    local max_option_width_18083="$(( $(( _term_width_79 - cursor_len_18082 )) - 1 ))"
    local __range_start_18084=0
    local __range_end_18084="${_page_count_82}"
    local __dir_18084=$(( ${__range_start_18084} <= ${__range_end_18084} ? 1 : -1 ))
    for (( i_18084=${__range_start_18084}; i_18084 * ${__dir_18084} < ${__range_end_18084} * ${__dir_18084}; i_18084+=${__dir_18084} )); do
        cutoff_text__1318_v0 "${_page_81[${i_18084}]?"Index out of bounds (at src/./choose/./engine.ab:45:45)"}" "${max_option_width_18083}"
        local ret_cutoff_text1318_v0__45_27="${ret_cutoff_text1318_v0}"
        local truncated_18085="${ret_cutoff_text1318_v0__45_27}"
        if [ "$(( i_18084 == _selected_75 ))" != 0 ]; then
            colored_secondary__1287_v0 "${_cursor_76}""${truncated_18085}""
"
            local ret_colored_secondary1287_v0__47_21="${ret_colored_secondary1287_v0}"
            local array_271=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__47_21}" array_271[@]
        else
            print_blank__1237_v0 "${cursor_len_18082}"
            local array_272=("")
            eprintf__1184_v0 "${truncated_18085}""
" array_272[@]
        fi
done
    local remaining_slots_18086="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18086 > 0 ))" != 0 ]; then
        local __range_start_18087=0
        local __range_end_18087="${remaining_slots_18086}"
        local __dir_18087=$(( ${__range_start_18087} <= ${__range_end_18087} ? 1 : -1 ))
        for (( ____18087=${__range_start_18087}; ____18087 * ${__dir_18087} < ${__range_end_18087} * ${__dir_18087}; ____18087+=${__dir_18087} )); do
            local array_273=("")
            eprintf__1184_v0 "\\x1b[K
" array_273[@]
done
    fi
}

# render_multi_page()
render_multi_page__1584_v0() {
    local __length_274="${_cursor_76}"
    local cursor_len_18071="${#__length_274}"
    local max_option_width_18072="$(( $(( _term_width_79 - cursor_len_18071 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1589_v0 
    local page_start_18073="${ret_chooser_page_start1589_v0}"
    local __range_start_18074=0
    local __range_end_18074="${_page_count_82}"
    local __dir_18074=$(( ${__range_start_18074} <= ${__range_end_18074} ? 1 : -1 ))
    for (( i_18074=${__range_start_18074}; i_18074 * ${__dir_18074} < ${__range_end_18074} * ${__dir_18074}; i_18074+=${__dir_18074} )); do
        local global_idx_18075="$(( page_start_18073 + i_18074 ))"
        checked_is__1405_v0 "${global_idx_18075}"
        local ret_checked_is1405_v0__67_28="${ret_checked_is1405_v0}"
        local check_mark_18077
        check_mark_18077="$(if [ "${ret_checked_is1405_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1318_v0 "${_page_81[${i_18074}]?"Index out of bounds (at src/./choose/./engine.ab:68:45)"}" "${max_option_width_18072}"
        local ret_cutoff_text1318_v0__68_27="${ret_cutoff_text1318_v0}"
        local truncated_18078="${ret_cutoff_text1318_v0__68_27}"
        checked_is__1405_v0 "${global_idx_18075}"
        local ret_checked_is1405_v0__71_13="${ret_checked_is1405_v0}"
        if [ "$(( i_18074 == _selected_75 ))" != 0 ]; then
            colored_secondary__1287_v0 "${_cursor_76}""${check_mark_18077}""${truncated_18078}""
"
            local ret_colored_secondary1287_v0__70_37="${ret_colored_secondary1287_v0}"
            local array_275=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__70_37}" array_275[@]
        elif [ "${ret_checked_is1405_v0__71_13}" != 0 ]; then
            print_blank__1237_v0 "${cursor_len_18071}"
            colored_secondary__1287_v0 "${check_mark_18077}""${truncated_18078}""
"
            local ret_colored_secondary1287_v0__73_25="${ret_colored_secondary1287_v0}"
            local array_276=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__73_25}" array_276[@]
        else
            print_blank__1237_v0 "${cursor_len_18071}"
            local array_277=("")
            eprintf__1184_v0 "${check_mark_18077}""${truncated_18078}""
" array_277[@]
        fi
done
    local remaining_slots_18080="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18080 > 0 ))" != 0 ]; then
        local __range_start_18081=0
        local __range_end_18081="${remaining_slots_18080}"
        local __dir_18081=$(( ${__range_start_18081} <= ${__range_end_18081} ? 1 : -1 ))
        for (( ____18081=${__range_start_18081}; ____18081 * ${__dir_18081} < ${__range_end_18081} * ${__dir_18081}; ____18081+=${__dir_18081} )); do
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
    local total_17989="${1}"
    local page_size_17990="${2}"
    local header_17991="${3}"
    local cursor_17992="${4}"
    local multi_17993="${5}"
    local limit_17994="${6}"
    _total_70="${total_17989}"
    _cursor_76="${cursor_17992}"
    _multi_77="${multi_17993}"
    _limit_78="${limit_17994}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_17991}" == "_" ]; echo $?)"
    stty_lock__1225_v0 
    hide_cursor__1242_v0 
    term_width__1232_v0 
    _term_width_79="${ret_term_width1232_v0}"
    term_height__1233_v0 
    local term_height_17999="${ret_term_height1233_v0}"
    local max_page_size_18000
    max_page_size_18000="$(( term_height_17999 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_17990}"
    if [ "$(( _page_size_71 > max_page_size_18000 ))" != 0 ]; then
        _page_size_71="${max_page_size_18000}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1318_v0 "${header_17991}" "${_term_width_79}"
        local ret_cutoff_text1318_v0__153_17="${ret_cutoff_text1318_v0}"
        local array_287=("")
        eprintf__1184_v0 "${ret_cutoff_text1318_v0__153_17}""
" array_287[@]
    fi
    math_floor__636_v0 "$(( $(( $(( total_17989 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _total_pages_73="${ret_math_floor636_v0}"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_17989 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_17989}"
    fi
    if [ "${multi_17993}" != 0 ]; then
        checked_init__1404_v0 "${total_17989}" "${limit_17994}"
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
    local start_18066="${ret_chooser_page_start1589_v0}"
    local end_18067="$(( start_18066 + _page_size_71 ))"
    if [ "$(( end_18067 > _total_70 ))" != 0 ]; then
        end_18067="${_total_70}"
    fi
    ret_chooser_page_count1590_v0="$(( end_18067 - start_18066 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1591_v0() {
    local page_18070=("${!1}")
    _page_81=("${page_18070[@]}")
    local __length_290=("${page_18070[@]}")
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
    local check_width_18097
    check_width_18097="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_292="${_cursor_76}"
    ret_option_width1592_v0="$(( $(( _term_width_79 - ${#__length_292} )) - check_width_18097 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1593_v0() {
    local index_18110="${1}"
    local __length_293="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_293}"
    local blank_18111="${ret_rpad28_v0}"
    option_width__1592_v0 
    local ret_option_width1592_v0__224_49="${ret_option_width1592_v0}"
    cutoff_text__1318_v0 "${_page_81[${index_18110}]?"Index out of bounds (at src/./choose/./engine.ab:224:41)"}" "${ret_option_width1592_v0__224_49}"
    local truncated_18112="${ret_cutoff_text1318_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1593_v0="${blank_18111}""${truncated_18112}"
        return 0
    fi
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__228_19="${ret_chooser_page_start1589_v0}"
    checked_is__1405_v0 "$(( ret_chooser_page_start1589_v0__228_19 + index_18110 ))"
    local ret_checked_is1405_v0__228_8="${ret_checked_is1405_v0}"
    if [ "${ret_checked_is1405_v0__228_8}" != 0 ]; then
        colored_secondary__1287_v0 "✓ ""${truncated_18112}"
        local ret_colored_secondary1287_v0__229_24="${ret_colored_secondary1287_v0}"
        ret_unselected_line1593_v0="${blank_18111}""${ret_colored_secondary1287_v0__229_24}"
        return 0
    fi
    ret_unselected_line1593_v0="${blank_18111}""• ""${truncated_18112}"
    return 0
}

# selected_line(index: Int)
selected_line__1594_v0() {
    local index_18096="${1}"
    option_width__1592_v0 
    local ret_option_width1592_v0__236_49="${ret_option_width1592_v0}"
    cutoff_text__1318_v0 "${_page_81[${index_18096}]?"Index out of bounds (at src/./choose/./engine.ab:236:41)"}" "${ret_option_width1592_v0__236_49}"
    local truncated_18098="${ret_cutoff_text1318_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1287_v0 "${_cursor_76}""${truncated_18098}"
        ret_selected_line1594_v0="${ret_colored_secondary1287_v0}"
        return 0
    fi
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__240_29="${ret_chooser_page_start1589_v0}"
    checked_is__1405_v0 "$(( ret_chooser_page_start1589_v0__240_29 + index_18096 ))"
    local ret_checked_is1405_v0__240_18="${ret_checked_is1405_v0}"
    local mark_18099
    mark_18099="$(if [ "${ret_checked_is1405_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1287_v0 "${_cursor_76}""${mark_18099}""${truncated_18098}"
    ret_selected_line1594_v0="${ret_colored_secondary1287_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1595_v0() {
    local prev_selected_18109="${1}"
    unselected_line__1593_v0 "${prev_selected_18109}"
    local ret_unselected_line1593_v0__247_47="${ret_unselected_line1593_v0}"
    redraw_row__1402_v0 "${_display_count_72}" "${prev_selected_18109}" "${ret_unselected_line1593_v0__247_47}"
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
    local key_18091="${ret_get_key1182_v0}"
    local prev_selected_18092="${_selected_75}"
    local prev_page_18093="${_current_page_74}"
    chooser_page_start__1589_v0 
    local page_start_18094="${ret_chooser_page_start1589_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_18091}" != "_UP" ]; echo $?) || $([ "_${key_18091}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18091}" != "_DOWN" ]; echo $?) || $([ "_${key_18091}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18091}" != "_LEFT" ]; echo $?) || $([ "_${key_18091}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_18091}" != "_RIGHT" ]; echo $?) || $([ "_${key_18091}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $(( $([ "_${key_18091}" != "_x" ]; echo $?) || $([ "_${key_18091}" != "_X" ]; echo $?) )) || $([ "_${key_18091}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1407_v0 "$(( page_start_18094 + _selected_75 ))"
        local ret_checked_toggle1407_v0__310_16="${ret_checked_toggle1407_v0}"
        if [ "${ret_checked_toggle1407_v0__310_16}" != 0 ]; then
            redraw_current_line__1596_v0 
        fi
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $(( $([ "_${key_18091}" != "_a" ]; echo $?) || $([ "_${key_18091}" != "_A" ]; echo $?) )) || $([ "_${key_18091}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18091}" != "_INPUT" ]; echo $?) || $([ "_${key_18091}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step1597_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_18093 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1597_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_18092 != _selected_75 ))" != 0 ]; then
        redraw_selection__1595_v0 "${prev_selected_18092}"
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
    local index_18119="${1}"
    checked_is__1405_v0 "${index_18119}"
    ret_chooser_is_checked1599_v0="${ret_checked_is1405_v0}"
    return 0
}

# chooser_end()
chooser_end__1600_v0() {
    local total_lines_18114="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_18114="$(( total_lines_18114 + 1 ))"
    fi
    go_down__1240_v0 1
    remove_line__1235_v0 "$(( total_lines_18114 - 1 ))"
    remove_current_line__1236_v0 
    stty_unlock__1226_v0 
    show_cursor__1243_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1609_v0() {
    local options_18123=("${!1}")
    local cursor_18124="${2}"
    local header_18125="${3}"
    local page_size_18126="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_295=("${options_18123[@]}")
    local total_18127="${#__length_295[@]}"
    if [ "$(( total_18127 == 0 ))" != 0 ]; then
        eprintf_colored__1185_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1588_v0 "${total_18127}" "${page_size_18126}" "${header_18125}" "${cursor_18124}" 0 -1
    local need_page_18128=1
    while :
    do
        if [ "${need_page_18128}" != 0 ]; then
            local page_18129=()
            chooser_page_start__1589_v0 
            local start_18130="${ret_chooser_page_start1589_v0}"
            chooser_page_count__1590_v0 
            local count_18131="${ret_chooser_page_count1590_v0}"
            local __range_start_18132="${start_18130}"
            local __range_end_18132="$(( start_18130 + count_18131 ))"
            local __dir_18132=$(( ${__range_start_18132} <= ${__range_end_18132} ? 1 : -1 ))
            for (( i_18132=${__range_start_18132}; i_18132 * ${__dir_18132} < ${__range_end_18132} * ${__dir_18132}; i_18132+=${__dir_18132} )); do
                local array_297=("${options_18123[${i_18132}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_18129+=("${array_297[@]}")
done
            chooser_set_page__1591_v0 page_18129[@]
        fi
        chooser_step__1597_v0 
        local step_18133="${ret_chooser_step1597_v0}"
        if [ "$(( step_18133 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18128="$(( step_18133 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1598_v0 
    local selected_18134="${ret_chooser_selected1598_v0}"
    chooser_end__1600_v0 
    ret_xyl_choose1609_v0="${options_18123[${selected_18134}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1610_v0() {
    local options_17983=("${!1}")
    local cursor_17984="${2}"
    local header_17985="${3}"
    local limit_17986="${4}"
    local page_size_17987="${5}"
    local __length_298=("${options_17983[@]}")
    local total_17988="${#__length_298[@]}"
    if [ "$(( total_17988 == 0 ))" != 0 ]; then
        eprintf_colored__1185_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1610_v0=()
        return 0
    fi
    chooser_begin__1588_v0 "${total_17988}" "${page_size_17987}" "${header_17985}" "${cursor_17984}" 1 "${limit_17986}"
    local need_page_18063=1
    while :
    do
        if [ "${need_page_18063}" != 0 ]; then
            local page_18064=()
            chooser_page_start__1589_v0 
            local start_18065="${ret_chooser_page_start1589_v0}"
            chooser_page_count__1590_v0 
            local count_18068="${ret_chooser_page_count1590_v0}"
            local __range_start_18069="${start_18065}"
            local __range_end_18069="$(( start_18065 + count_18068 ))"
            local __dir_18069=$(( ${__range_start_18069} <= ${__range_end_18069} ? 1 : -1 ))
            for (( i_18069=${__range_start_18069}; i_18069 * ${__dir_18069} < ${__range_end_18069} * ${__dir_18069}; i_18069+=${__dir_18069} )); do
                local array_301=("${options_17983[${i_18069}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_18064+=("${array_301[@]}")
done
            chooser_set_page__1591_v0 page_18064[@]
        fi
        chooser_step__1597_v0 
        local step_18113="${ret_chooser_step1597_v0}"
        if [ "$(( step_18113 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18063="$(( step_18113 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1600_v0 
    local result_18117=()
    local __range_start_18118=0
    local __range_end_18118="${total_17988}"
    local __dir_18118=$(( ${__range_start_18118} <= ${__range_end_18118} ? 1 : -1 ))
    for (( i_18118=${__range_start_18118}; i_18118 * ${__dir_18118} < ${__range_end_18118} * ${__dir_18118}; i_18118+=${__dir_18118} )); do
        chooser_is_checked__1599_v0 "${i_18118}"
        local ret_chooser_is_checked1599_v0__93_12="${ret_chooser_is_checked1599_v0}"
        if [ "${ret_chooser_is_checked1599_v0__93_12}" != 0 ]; then
            local array_303=("${options_17983[${i_18118}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_18117+=("${array_303[@]}")
        fi
done
    ret_xyl_multi_choose1610_v0=("${result_18117[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1711_v0() {
    local usage_17906=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1244_v0 usage_17906[@]
    printf '%s\n' ""
    colored_primary__1286_v0 "choose"
    local ret_colored_primary1286_v0__8_20="${ret_colored_primary1286_v0}"
    local title_17933=("${ret_colored_primary1286_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1244_v0 title_17933[@]
    printf '%s\n' ""
    colored_secondary__1287_v0 "Arguments:"
    local ret_colored_secondary1287_v0__11_12="${ret_colored_secondary1287_v0}"
    local array_306=()
    printf__128_v0 "${ret_colored_secondary1287_v0__11_12}""
" array_306[@]
    local arg_names_17935=("[<options> ...]")
    local arg_texts_17936=("List of options to choose from")
    local arg_notes_17937=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1421_v0 arg_names_17935[@] arg_texts_17936[@] arg_notes_17937[@] 20
    printf '%s\n' ""
    colored_secondary__1287_v0 "Flags:"
    local ret_colored_secondary1287_v0__18_12="${ret_colored_secondary1287_v0}"
    local array_310=()
    printf__128_v0 "${ret_colored_secondary1287_v0__18_12}""
" array_310[@]
    local names_17970=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_17971=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_17972=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1421_v0 names_17970[@] texts_17971[@] notes_17972[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1769_v0() {
    local options_17899=()
    local command_315
    command_315="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_17900="${command_315}"
    if [ "$([ "_${is_tty_17900}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_17899+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1769_v0=("${options_17899[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1770_v0() {
    local parameters_17883=("${!1}")
    local cursor_17884="> "
    colored_primary__1286_v0 "Choose: "
    local ret_colored_primary1286_v0__17_30="${ret_colored_primary1286_v0}"
    local header_17898="\\x1b[1m""${ret_colored_primary1286_v0__17_30}"
    read_stdin_options__1769_v0 
    local options_17901=("${ret_read_stdin_options1769_v0[@]}")
    local multi_17902=0
    local limit_17903=-1
    local page_size_17904=10
    local __length_319=("${parameters_17883[@]}")
    local slice_upper_318="${#__length_319[@]}"
    local slice_offset_320=2
    local slice_offset_320=$((${slice_offset_320} > 0 ? ${slice_offset_320} : 0))
    local slice_length_321="$(( slice_upper_318 - slice_offset_320 ))"
    local slice_length_321=$((${slice_length_321} > 0 ? ${slice_length_321} : 0))
    for param_17905 in "${parameters_17883[@]:${slice_offset_320}:${slice_length_321}}"; do
        starts_with__22_v0 "${param_17905}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17905}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17905}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17905}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_17905}" != "_-h" ]; echo $?) || $([ "_${param_17905}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1711_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_322="--cursor="
            slice__24_v0 "${param_17905}" "${#__length_322}" 0
            cursor_17884="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_323="--header="
            slice__24_v0 "${param_17905}" "${#__length_323}" 0
            header_17898="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_324="--limit="
            slice__24_v0 "${param_17905}" "${#__length_324}" 0
            local value_17973="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17973}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1185_v0 "ERROR: Invalid limit value: ""${value_17973}""
" 31
                exit 1
            fi
            limit_17903="${ret_parse_int13_v0}"
            multi_17902=1
        elif [ "$([ "_${param_17905}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_17902=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_325="--page-size="
            slice__24_v0 "${param_17905}" "${#__length_325}" 0
            local value_17978="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17978}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1185_v0 "ERROR: Invalid page-size value: ""${value_17978}""
" 31
                exit 1
            fi
            page_size_17904="${ret_parse_int13_v0}"
        else
            options_17901+=("${param_17905}")
        fi
    done
    has_ansi_escape__1310_v0 "${header_17898}"
    local ret_has_ansi_escape1310_v0__59_44="${ret_has_ansi_escape1310_v0}"
    escape_ansi__1311_v0 "${header_17898}"
    local ret_escape_ansi1311_v0__59_73="${ret_escape_ansi1311_v0}"
    colored_primary__1286_v0 "${header_17898}"
    local ret_colored_primary1286_v0__59_111="${ret_colored_primary1286_v0}"
    local display_header_17982
    display_header_17982="$(if [ "$(( $([ "_${header_17898}" != "_" ]; echo $?) || ret_has_ansi_escape1310_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1311_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1286_v0__59_111}"; fi)"
    if [ "${multi_17902}" != 0 ]; then
        xyl_multi_choose__1610_v0 options_17901[@] "${cursor_17884}" "${display_header_17982}" "${limit_17903}" "${page_size_17904}"
        local results_18120=("${ret_xyl_multi_choose1610_v0[@]}")
        join__7_v0 results_18120[@] "
"
        ret_execute_choose1770_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1609_v0 options_17901[@] "${cursor_17884}" "${display_header_17982}" "${page_size_17904}"
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
    local format_27426="${1}"
    local args_27427=("${!2}")
    args_27427=("${format_27426}" "${args_27427[@]}")
    __status=$?
    printf "${args_27427[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1858_v0() {
    local message_27424="${1}"
    local color_27425="${2}"
    # Prints an error message with a specified color.
    local array_328=("${message_27424}")
    eprintf__1857_v0 "\\x1b[${color_27425}m%s\\x1b[0m" array_328[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1873_v0() {
    local format_27444="${1}"
    local args_27445=("${!2}")
    args_27445=("${format_27444}" "${args_27445[@]}")
    __status=$?
    printf "${args_27445[@]}" >&2
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
        local disabled_27369
        disabled_27369="$([ "_${command_329}" != "_No" ]; echo $?)"
        local command_330
        command_330="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27370
        found_27370="$(( $(( ! disabled_27369 )) && $([ "_${command_330}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_27370}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1880_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1881_v0() {
    local text_27368="${1}"
    perl_available__1880_v0 
    local ret_perl_available1880_v0__19_12="${ret_perl_available1880_v0}"
    if [ "$(( ! ret_perl_available1880_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return 1
    fi
    local command_331
    command_331="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27368}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return "${__status}"
    fi
    local width_str_27371="${command_331}"
    parse_int__13_v0 "${width_str_27371}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return "${__status}"
    fi
    local width_27372="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1881_v0="${width_27372}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1886_v0() {
    local text_27358="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_332
    command_332="$([[ "${text_27358}" == *$'\x1b'* || "${text_27358}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27359="${command_332}"
    ret_has_ansi_escape1886_v0="$([ "_${has_escape_27359}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1888_v0() {
    local text_27364="${1}"
    local command_333
    command_333="$(printf "%s" "${text_27364}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1888_v0="${command_333}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1889_v0() {
    local text_27366="${1}"
    local command_334
    command_334="$(printf "%s" "${text_27366}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27367="${command_334}"
    ret_is_all_ascii1889_v0="$([ "_${result_27367}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1890_v0() {
    local text_27361="${1}"
    local command_335
    command_335="$(LC_ALL=C; __t="${text_27361}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27362="${command_335}"
    parse_int__13_v0 "${measured_27362}"
    __status=$?
    ret_plain_len1890_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1891_v0() {
    local text_27360="${1}"
    plain_len__1890_v0 "${text_27360}"
    local plain_27363="${ret_plain_len1890_v0}"
    if [ "$(( plain_27363 >= 0 ))" != 0 ]; then
        ret_get_visible_len1891_v0="${plain_27363}"
        return 0
    fi
    strip_ansi__1888_v0 "${text_27360}"
    local stripped_27365="${ret_strip_ansi1888_v0}"
    is_all_ascii__1889_v0 "${stripped_27365}"
    local ret_is_all_ascii1889_v0__46_12="${ret_is_all_ascii1889_v0}"
    if [ "$(( ! ret_is_all_ascii1889_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1881_v0 "${stripped_27365}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_336="${stripped_27365}"
            ret_get_visible_len1891_v0="${#__length_336}"
            return 0
        fi
        ret_get_visible_len1891_v0="${ret_perl_get_cjk_width1881_v0}"
        return 0
    fi
    local __length_337="${stripped_27365}"
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
    local count_27442="${command_339}"
    parse_int__13_v0 "${count_27442}"
    __status=$?
    ret_stty_count1897_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1898_v0() {
    stty_count__1897_v0 
    local count_num_27443="${ret_stty_count1897_v0}"
    if [ "$(( count_num_27443 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_27443="$(( count_num_27443 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27443}
    __status=$?
}

# stty_unlock()
stty_unlock__1899_v0() {
    stty_count__1897_v0 
    local count_num_27544="${ret_stty_count1897_v0}"
    if [ "$(( count_num_27544 > 0 ))" != 0 ]; then
        count_num_27544="$(( count_num_27544 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27544}
        __status=$?
        if [ "$(( count_num_27544 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1900_v0() {
    local size_27349="${1}"
    if [ "$([ "_${size_27349}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1900_v0=0
        return 0
    fi
    split__4_v0 "${size_27349}" " "
    local parts_27350=("${ret_split4_v0[@]}")
    local __length_340=("${parts_27350[@]}")
    if [ "$(( ${#__length_340[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1900_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27350[1]?"Index out of bounds (at src/./filter/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27350[0]?"Index out of bounds (at src/./filter/../utils/term.ab:53:68)"}"
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
    local size_27352="${command_342}"
    store_term_size__1900_v0 "${size_27352}"
    ret_query_term_size1901_v0="${ret_store_term_size1900_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1902_v0() {
    local command_343
    command_343="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27348="${command_343}"
    store_term_size__1900_v0 "${size_27348}"
    ret_stty_term_size1902_v0="${ret_store_term_size1900_v0}"
    return 0
}

# get_term_size()
get_term_size__1903_v0() {
    stty_term_size__1902_v0 
    local detected_27351="${ret_stty_term_size1902_v0}"
    if [ "$(( ! detected_27351 ))" != 0 ]; then
        query_term_size__1901_v0 
        detected_27351="${ret_query_term_size1901_v0}"
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
    local cnt_27541="${1}"
    if [ "$(( cnt_27541 > 0 ))" != 0 ]; then
        local sequence_27542=""
        local __range_start_27543=0
        local __range_end_27543="${cnt_27541}"
        local __dir_27543=$(( ${__range_start_27543} <= ${__range_end_27543} ? 1 : -1 ))
        for (( ____27543=${__range_start_27543}; ____27543 * ${__dir_27543} < ${__range_end_27543} * ${__dir_27543}; ____27543+=${__dir_27543} )); do
            sequence_27542+="\\x1b[2K\\x1b[1A"
done
        local array_344=("")
        eprintf__1873_v0 "${sequence_27542}" array_344[@]
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
    local cnt_27490="${1}"
    local __range_start_27491=0
    local __range_end_27491="${cnt_27490}"
    local __dir_27491=$(( ${__range_start_27491} <= ${__range_end_27491} ? 1 : -1 ))
    for (( ____27491=${__range_start_27491}; ____27491 * ${__dir_27491} < ${__range_end_27491} * ${__dir_27491}; ____27491+=${__dir_27491} )); do
        local array_347=("")
        eprintf__1873_v0 "
" array_347[@]
done
}

# go_up(cnt: Int)
go_up__1912_v0() {
    local cnt_27509="${1}"
    local array_348=("")
    eprintf__1873_v0 "\\x1b[${cnt_27509}A" array_348[@]
}

# go_down(cnt: Int)
go_down__1913_v0() {
    local cnt_27523="${1}"
    local array_349=("")
    eprintf__1873_v0 "\\x1b[${cnt_27523}B" array_349[@]
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
    local pieces_27347=("${!1}")
    term_width__1905_v0 
    local width_27353="${ret_term_width1905_v0}"
    local line_27354=""
    local line_len_27355=0
    for piece_27356 in "${pieces_27347[@]}"; do
        local __length_354="${piece_27356}"
        local piece_len_27357="${#__length_354}"
        has_ansi_escape__1886_v0 "${piece_27356}"
        local ret_has_ansi_escape1886_v0__186_12="${ret_has_ansi_escape1886_v0}"
        if [ "${ret_has_ansi_escape1886_v0__186_12}" != 0 ]; then
            get_visible_len__1891_v0 "${piece_27356}"
            piece_len_27357="${ret_get_visible_len1891_v0}"
        fi
        if [ "$([ "_${line_27354}" != "_" ]; echo $?)" != 0 ]; then
            line_27354="${piece_27356}"
            line_len_27355="${piece_len_27357}"
        elif [ "$(( $(( $(( line_len_27355 + 1 )) + piece_len_27357 )) > width_27353 ))" != 0 ]; then
            local array_355=()
            printf__128_v0 "${line_27354}""
" array_355[@]
            line_27354="${piece_27356}"
            line_len_27355="${piece_len_27357}"
        else
            line_27354+=" ""${piece_27356}"
            line_len_27355="$(( line_len_27355 + $(( 1 + piece_len_27357 )) ))"
        fi
    done
    if [ "$([ "_${line_27354}" == "_" ]; echo $?)" != 0 ]; then
        local array_356=()
        printf__128_v0 "${line_27354}""
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
    local config_27385="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_27385}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1954_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1955_v0() {
    local message_27380="${1}"
    local r_27381="${2}"
    local g_27382="${3}"
    local b_27383="${4}"
    local fallback_27384="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1955_v0="\\x1b[38;2;${r_27381};${g_27382};${b_27383}m""${message_27380}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1954_v0 
        local ret_get_supports_truecolor1954_v0__45_17="${ret_get_supports_truecolor1954_v0}"
        if [ "${ret_get_supports_truecolor1954_v0__45_17}" != 0 ]; then
            ret_colored_rgb1955_v0="\\x1b[38;2;${r_27381};${g_27382};${b_27383}m""${message_27380}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27384 == 0 ))" != 0 ]; then
            ret_colored_rgb1955_v0="${message_27380}"
            return 0
        else
            ret_colored_rgb1955_v0="\\x1b[${fallback_27384}m""${message_27380}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27384 == 0 ))" != 0 ]; then
            ret_colored_rgb1955_v0="${message_27380}"
            return 0
        fi
        ret_colored_rgb1955_v0="\\x1b[${fallback_27384}m""${message_27380}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1957_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27374="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27374}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27374}" ";"
            local parts_27375=("${ret_split4_v0[@]}")
            local __length_360=("${parts_27375[@]}")
            if [ "$(( ${#__length_360[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27375[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27375[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27375[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27375[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_27376="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27376}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27376}" ";"
            local parts_27377=("${ret_split4_v0[@]}")
            local __length_362=("${parts_27377[@]}")
            if [ "$(( ${#__length_362[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27377[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27377[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27377[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27377[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_27378="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27378}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27378}" ";"
            local parts_27379=("${ret_split4_v0[@]}")
            local __length_364=("${parts_27379[@]}")
            if [ "$(( ${#__length_364[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27379[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:139:37)"}"
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
    local message_27373="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1958_v0 
    fi
    colored_rgb__1955_v0 "${message_27373}" "${_primary_color_97[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1959_v0="${ret_colored_rgb1955_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1960_v0() {
    local message_27387="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1958_v0 
    fi
    colored_rgb__1955_v0 "${message_27387}" "${_secondary_color_98[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:113)"}"
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
        local disabled_27462
        disabled_27462="$([ "_${command_366}" != "_No" ]; echo $?)"
        local command_367
        command_367="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27463
        found_27463="$(( $(( ! disabled_27462 )) && $([ "_${command_367}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_27463}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1977_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1978_v0() {
    local text_27461="${1}"
    perl_available__1977_v0 
    local ret_perl_available1977_v0__19_12="${ret_perl_available1977_v0}"
    if [ "$(( ! ret_perl_available1977_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return 1
    fi
    local command_368
    command_368="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27461}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return "${__status}"
    fi
    local width_str_27464="${command_368}"
    parse_int__13_v0 "${width_str_27464}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return "${__status}"
    fi
    local width_27465="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1978_v0="${width_27465}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1979_v0() {
    local text_27472="${1}"
    local max_width_27473="${2}"
    perl_available__1977_v0 
    local ret_perl_available1977_v0__30_12="${ret_perl_available1977_v0}"
    if [ "$(( ! ret_perl_available1977_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1979_v0=''
        return 1
    fi
    local command_369
    command_369="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27472}" ${max_width_27473} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1979_v0=''
        return "${__status}"
    fi
    local result_27474="${command_369}"
    ret_perl_truncate_cjk1979_v0="${result_27474}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1983_v0() {
    local text_27429="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_370
    command_370="$([[ "${text_27429}" == *$'\x1b'* || "${text_27429}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27430="${command_370}"
    ret_has_ansi_escape1983_v0="$([ "_${has_escape_27430}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1984_v0() {
    local text_27431="${1}"
    local command_371
    command_371="$(printf '%s' "${text_27431}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1984_v0="${command_371}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1985_v0() {
    local text_27457="${1}"
    local command_372
    command_372="$(printf "%s" "${text_27457}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1985_v0="${command_372}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1986_v0() {
    local text_27459="${1}"
    local command_373
    command_373="$(printf "%s" "${text_27459}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27460="${command_373}"
    ret_is_all_ascii1986_v0="$([ "_${result_27460}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1987_v0() {
    local text_27454="${1}"
    local command_374
    command_374="$(LC_ALL=C; __t="${text_27454}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27455="${command_374}"
    parse_int__13_v0 "${measured_27455}"
    __status=$?
    ret_plain_len1987_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1988_v0() {
    local text_27453="${1}"
    plain_len__1987_v0 "${text_27453}"
    local plain_27456="${ret_plain_len1987_v0}"
    if [ "$(( plain_27456 >= 0 ))" != 0 ]; then
        ret_get_visible_len1988_v0="${plain_27456}"
        return 0
    fi
    strip_ansi__1985_v0 "${text_27453}"
    local stripped_27458="${ret_strip_ansi1985_v0}"
    is_all_ascii__1986_v0 "${stripped_27458}"
    local ret_is_all_ascii1986_v0__46_12="${ret_is_all_ascii1986_v0}"
    if [ "$(( ! ret_is_all_ascii1986_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1978_v0 "${stripped_27458}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_375="${stripped_27458}"
            ret_get_visible_len1988_v0="${#__length_375}"
            return 0
        fi
        ret_get_visible_len1988_v0="${ret_perl_get_cjk_width1978_v0}"
        return 0
    fi
    local __length_376="${stripped_27458}"
    ret_get_visible_len1988_v0="${#__length_376}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1989_v0() {
    local text_27469="${1}"
    local max_width_27470="${2}"
    get_visible_len__1988_v0 "${text_27469}"
    local visible_len_27471="${ret_get_visible_len1988_v0}"
    if [ "$(( visible_len_27471 <= max_width_27470 ))" != 0 ]; then
        ret_truncate_text1989_v0="${text_27469}"
        return 0
    fi
    is_all_ascii__1986_v0 "${text_27469}"
    local ret_is_all_ascii1986_v0__61_12="${ret_is_all_ascii1986_v0}"
    if [ "$(( ! ret_is_all_ascii1986_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1979_v0 "${text_27469}" "${max_width_27470}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27469}" | cut -c1-${max_width_27470}
            __status=$?
        fi
        ret_truncate_text1989_v0="${ret_perl_truncate_cjk1979_v0}"
        return 0
    fi
    local command_377
    command_377="$(printf "%s" "${text_27469}" | cut -c1-${max_width_27470})"
    __status=$?
    ret_truncate_text1989_v0="${command_377}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1990_v0() {
    local text_27467="${1}"
    local max_width_27468="${2}"
    has_ansi_escape__1983_v0 "${text_27467}"
    local ret_has_ansi_escape1983_v0__73_12="${ret_has_ansi_escape1983_v0}"
    if [ "$(( ! ret_has_ansi_escape1983_v0__73_12 ))" != 0 ]; then
        truncate_text__1989_v0 "${text_27467}" "${max_width_27468}"
        ret_truncate_ansi1990_v0="${ret_truncate_text1989_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_378
    command_378="$([[ "${text_27467}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27475="${command_378}"
    # Replace \x1b[ with newline, then split
    local command_379
    command_379="$(t="${text_27467}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27476="${command_379}"
    split__4_v0 "${replaced_27476}" "
"
    local parts_27477=("${ret_split4_v0[@]}")
    local result_27478=""
    local remaining_width_27479="${max_width_27468}"
    local __range_start_27480=0
    local __length_380=("${parts_27477[@]}")
    local __range_end_27480="${#__length_380[@]}"
    local __dir_27480=$(( ${__range_start_27480} <= ${__range_end_27480} ? 1 : -1 ))
    for (( idx_27480=${__range_start_27480}; idx_27480 * ${__dir_27480} < ${__range_end_27480} * ${__dir_27480}; idx_27480+=${__dir_27480} )); do
        local part_27481="${parts_27477[${idx_27480}]?"Index out of bounds (at src/./filter/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27480 == 0 )) && $([ "_${starts_with_ansi_27475}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27481}" == "_" ]; echo $?) && $(( remaining_width_27479 > 0 )) ))" != 0 ]; then
                truncate_text__1989_v0 "${part_27481}" "${remaining_width_27479}"
                local ret_truncate_text1989_v0__95_35="${ret_truncate_text1989_v0}"
                local truncated_27482="${ret_truncate_text1989_v0__95_35}"
                result_27478+="${truncated_27482}"
                get_visible_len__1988_v0 "${truncated_27482}"
                local ret_get_visible_len1988_v0__97_36="${ret_get_visible_len1988_v0}"
                remaining_width_27479="$(( remaining_width_27479 - ret_get_visible_len1988_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_381
            command_381="$(__p="${part_27481}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27483="${command_381}"
            if [ "$([ "_${m_idx_27483}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_382
                command_382="$(__p="${part_27481}"; printf "%s" "${__p:0:${m_idx_27483}}")"
                __status=$?
                local ansi_params_27484="${command_382}"
                result_27478+="\\x1b[""${ansi_params_27484}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27483}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_27485="${ret_parse_int13_v0__108_41}"
                local text_start_27486="$(( m_idx_num_27485 + 1 ))"
                local command_383
                command_383="$(__p="${part_27481}"; printf "%s" "${__p:${text_start_27486}}")"
                __status=$?
                local text_part_27487="${command_383}"
                if [ "$(( $([ "_${text_part_27487}" == "_" ]; echo $?) && $(( remaining_width_27479 > 0 )) ))" != 0 ]; then
                    truncate_text__1989_v0 "${text_part_27487}" "${remaining_width_27479}"
                    local ret_truncate_text1989_v0__112_39="${ret_truncate_text1989_v0}"
                    local truncated_27488="${ret_truncate_text1989_v0__112_39}"
                    result_27478+="${truncated_27488}"
                    get_visible_len__1988_v0 "${truncated_27488}"
                    local ret_get_visible_len1988_v0__114_40="${ret_get_visible_len1988_v0}"
                    remaining_width_27479="$(( remaining_width_27479 - ret_get_visible_len1988_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27481}" == "_" ]; echo $?) && $(( remaining_width_27479 > 0 )) ))" != 0 ]; then
                    truncate_text__1989_v0 "${part_27481}" "${remaining_width_27479}"
                    local ret_truncate_text1989_v0__119_39="${ret_truncate_text1989_v0}"
                    local truncated_27489="${ret_truncate_text1989_v0__119_39}"
                    result_27478+="${truncated_27489}"
                    get_visible_len__1988_v0 "${truncated_27489}"
                    local ret_get_visible_len1988_v0__121_40="${ret_get_visible_len1988_v0}"
                    remaining_width_27479="$(( remaining_width_27479 - ret_get_visible_len1988_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1990_v0="${result_27478}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1991_v0() {
    local text_27451="${1}"
    local max_width_27452="${2}"
    get_visible_len__1988_v0 "${text_27451}"
    local visible_len_27466="${ret_get_visible_len1988_v0}"
    if [ "$(( visible_len_27466 <= max_width_27452 ))" != 0 ]; then
        ret_cutoff_text1991_v0="${text_27451}"
        return 0
    fi
    truncate_ansi__1990_v0 "${text_27451}" "$(( max_width_27452 - 3 ))"
    local ret_truncate_ansi1990_v0__137_12="${ret_truncate_ansi1990_v0}"
    ret_cutoff_text1991_v0="${ret_truncate_ansi1990_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2012_v0() {
    local format_27500="${1}"
    local args_27501=("${!2}")
    args_27501=("${format_27500}" "${args_27501[@]}")
    __status=$?
    printf "${args_27501[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2013_v0() {
    local message_27498="${1}"
    local color_27499="${2}"
    # Prints an error message with a specified color.
    local array_384=("${message_27498}")
    eprintf__2012_v0 "\\x1b[${color_27499}m%s\\x1b[0m" array_384[@]
}

# colored(message: Text, color: Int)
colored__2014_v0() {
    local message_27418="${1}"
    local color_27419="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2014_v0="\\x1b[${color_27419}m""${message_27418}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2018_v0() {
    local items_27492=("${!1}")
    local total_len_27493="${2}"
    local term_width_27494="${3}"
    local separator_27495=" • "
    local separator_len_27496=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27493 <= term_width_27494 ))" != 0 ]; then
        local iter_27497=0
        while :
        do
            local __length_385=("${items_27492[@]}")
            if [ "$(( iter_27497 >= ${#__length_385[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_27497 > 0 ))" != 0 ]; then
                eprintf_colored__2013_v0 "${separator_27495}" 90
            fi
            colored__2014_v0 "${items_27492[$(( iter_27497 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2014_v0__23_41="${ret_colored2014_v0}"
            local array_386=("")
            eprintf__2012_v0 "${items_27492[${iter_27497}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2014_v0__23_41}" array_386[@]
            iter_27497="$(( iter_27497 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_27502=0
        local first_27503=1
        local iter_27504=0
        while :
        do
            local __length_387=("${items_27492[@]}")
            if [ "$(( iter_27504 >= ${#__length_387[@]} ))" != 0 ]; then
                break
            fi
            local key_27505="${items_27492[${iter_27504}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:35:31)"}"
            local action_27506="${items_27492[$(( iter_27504 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:36:34)"}"
            local __length_388="${key_27505}"
            local __length_389="${action_27506}"
            local part_len_27507="$(( $(( ${#__length_388} + 1 )) + ${#__length_389} ))"
            local needed_27508="${part_len_27507}"
            if [ "$(( ! first_27503 ))" != 0 ]; then
                needed_27508="$(( needed_27508 + separator_len_27496 ))"
            fi
            if [ "$(( $(( current_len_27502 + needed_27508 )) > term_width_27494 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_27503 ))" != 0 ]; then
                eprintf_colored__2013_v0 "${separator_27495}" 90
            fi
            colored__2014_v0 "${action_27506}" 2
            local ret_colored2014_v0__51_33="${ret_colored2014_v0}"
            local array_390=("")
            eprintf__2012_v0 "${key_27505}"" ""${ret_colored2014_v0__51_33}" array_390[@]
            current_len_27502="$(( current_len_27502 + needed_27508 ))"
            first_27503=0
            iter_27504="$(( iter_27504 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2028_v0() {
    local format_27533="${1}"
    local args_27534=("${!2}")
    args_27534=("${format_27533}" "${args_27534[@]}")
    __status=$?
    printf "${args_27534[@]}" >&2
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
    local size_27397="${1}"
    if [ "$([ "_${size_27397}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2055_v0=0
        return 0
    fi
    split__4_v0 "${size_27397}" " "
    local parts_27398=("${ret_split4_v0[@]}")
    local __length_392=("${parts_27398[@]}")
    if [ "$(( ${#__length_392[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2055_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27398[1]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27398[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:68)"}"
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
    local size_27400="${command_394}"
    store_term_size__2055_v0 "${size_27400}"
    ret_query_term_size2056_v0="${ret_store_term_size2055_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2057_v0() {
    local command_395
    command_395="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27396="${command_395}"
    store_term_size__2055_v0 "${size_27396}"
    ret_stty_term_size2057_v0="${ret_store_term_size2055_v0}"
    return 0
}

# get_term_size()
get_term_size__2058_v0() {
    stty_term_size__2057_v0 
    local detected_27399="${ret_stty_term_size2057_v0}"
    if [ "$(( ! detected_27399 ))" != 0 ]; then
        query_term_size__2056_v0 
        detected_27399="${ret_query_term_size2056_v0}"
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
    local cnt_27532="${1}"
    local array_396=("")
    eprintf__2028_v0 "\\x1b[${cnt_27532}A" array_396[@]
}

# go_down(cnt: Int)
go_down__2068_v0() {
    local cnt_27535="${1}"
    local array_397=("")
    eprintf__2028_v0 "\\x1b[${cnt_27535}B" array_397[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__2075_v0() {
    local display_count_27529="${1}"
    local index_27530="${2}"
    local line_27531="${3}"
    go_up__2067_v0 "$(( display_count_27529 - index_27530 ))"
    local array_398=("")
    eprintf__2012_v0 "\\x1b[G\\x1b[K" array_398[@]
    local array_399=("")
    eprintf__2012_v0 "${line_27531}" array_399[@]
    go_down__2068_v0 "$(( display_count_27529 - index_27530 ))"
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
    local total_27447="${1}"
    local limit_27448="${2}"
    _checked_105=()
    local __range_start_27449=0
    local __range_end_27449="${total_27447}"
    local __dir_27449=$(( ${__range_start_27449} <= ${__range_end_27449} ? 1 : -1 ))
    for (( ____27449=${__range_start_27449}; ____27449 * ${__dir_27449} < ${__range_end_27449} * ${__dir_27449}; ____27449+=${__dir_27449} )); do
        local array_403=(0)
        _checked_105+=("${array_403[@]}")
done
    _count_106=0
    _total_107="${total_27447}"
    _limit_108="${limit_27448}"
}

# checked_is(index: Int)
checked_is__2078_v0() {
    local index_27519="${1}"
    ret_checked_is2078_v0="${_checked_105[${index_27519}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_count()
checked_count__2079_v0() {
    ret_checked_count2079_v0="${_count_106}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__2080_v0() {
    local index_27536="${1}"
    if [ "${_checked_105[${index_27536}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_105["${index_27536}"]=0
        _count_106="$(( _count_106 - 1 ))"
        ret_checked_toggle2080_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_108 >= 0 )) && $(( _count_106 >= _limit_108 )) ))" != 0 ]; then
        ret_checked_toggle2080_v0=0
        return 0
    fi
    _checked_105["${index_27536}"]=1
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
    local was_all_27537="$(( _count_106 == _total_107 ))"
    local __range_start_27538=0
    local __range_end_27538="${_total_107}"
    local __dir_27538=$(( ${__range_start_27538} <= ${__range_end_27538} ? 1 : -1 ))
    for (( i_27538=${__range_start_27538}; i_27538 * ${__dir_27538} < ${__range_end_27538} * ${__dir_27538}; i_27538+=${__dir_27538} )); do
        _checked_105["${i_27538}"]="$(( ! was_all_27537 ))"
done
    if [ "${was_all_27537}" != 0 ]; then
        _count_106=0
    else
        _count_106="${_total_107}"
    fi
    ret_checked_all2081_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2093_v0() {
    local pending_27415="${1}"
    local line_27416="${2}"
    local note_at_27417="${3}"
    if [ "$(( note_at_27417 < 0 ))" != 0 ]; then
        local array_404=()
        printf__128_v0 "${pending_27415}""${line_27416}""
" array_404[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27417 == 0 ))" != 0 ]; then
        colored__2014_v0 "${line_27416}" 90
        local ret_colored2014_v0__12_40="${ret_colored2014_v0}"
        local array_405=()
        printf__128_v0 "${pending_27415}""${ret_colored2014_v0__12_40}""
" array_405[@]
    else
        slice__24_v0 "${line_27416}" 0 "${note_at_27417}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27416}" "${note_at_27417}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2014_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2014_v0__13_58="${ret_colored2014_v0}"
        local array_406=()
        printf__128_v0 "${pending_27415}""${ret_slice24_v0__13_32}""${ret_colored2014_v0__13_58}""
" array_406[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2094_v0() {
    local names_27388=("${!1}")
    local texts_27389=("${!2}")
    local notes_27390=("${!3}")
    local min_name_width_27391="${4}"
    local __length_407=("${names_27388[@]}")
    local count_27392="${#__length_407[@]}"
    local name_width_27393="${min_name_width_27391}"
    local __range_start_27394=0
    local __range_end_27394="${count_27392}"
    local __dir_27394=$(( ${__range_start_27394} <= ${__range_end_27394} ? 1 : -1 ))
    for (( i_27394=${__range_start_27394}; i_27394 * ${__dir_27394} < ${__range_end_27394} * ${__dir_27394}; i_27394+=${__dir_27394} )); do
        local __length_408="${names_27388[${i_27394}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:28:33)"}"
        local width_27395="${#__length_408}"
        if [ "$(( width_27395 > name_width_27393 ))" != 0 ]; then
            name_width_27393="${width_27395}"
        fi
done
    term_width__2060_v0 
    local width_27401="${ret_term_width2060_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27402="$(( name_width_27393 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27403="$(( $(( width_27401 - indent_27402 )) < 24 ))"
    if [ "${stacked_27403}" != 0 ]; then
        indent_27402=6
    fi
    local avail_27404="$(( width_27401 - indent_27402 ))"
    rpad__28_v0 "" " " "${indent_27402}"
    local blank_27405="${ret_rpad28_v0}"
    local __range_start_27406=0
    local __range_end_27406="${count_27392}"
    local __dir_27406=$(( ${__range_start_27406} <= ${__range_end_27406} ? 1 : -1 ))
    for (( i_27406=${__range_start_27406}; i_27406 * ${__dir_27406} < ${__range_end_27406} * ${__dir_27406}; i_27406+=${__dir_27406} )); do
        local pending_27407="${blank_27405}"
        if [ "${stacked_27403}" != 0 ]; then
            local array_409=()
            printf__128_v0 "  ""${names_27388[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:48:33)"}""
" array_409[@]
        else
            rpad__28_v0 "  ""${names_27388[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:50:41)"}" " " "${indent_27402}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_27407="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_27389[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_27408=("${ret_split4_v0__52_21[@]}")
        local __length_410=("${words_27408[@]}")
        local note_start_27409="${#__length_410[@]}"
        if [ "$([ "_${notes_27390[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_411="${notes_27390[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_411} > avail_27404 ))" != 0 ]; then
                split__4_v0 "${notes_27390[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_27408+=("${ret_split4_v0__58_26[@]}")
            else
                local array_412=("${notes_27390[${i_27406}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:60:33)"}")
                words_27408+=("${array_412[@]}")
            fi
        fi
        local line_27410=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27411=-1
        local __range_start_27412=0
        local __length_413=("${words_27408[@]}")
        local __range_end_27412="${#__length_413[@]}"
        local __dir_27412=$(( ${__range_start_27412} <= ${__range_end_27412} ? 1 : -1 ))
        for (( j_27412=${__range_start_27412}; j_27412 * ${__dir_27412} < ${__range_end_27412} * ${__dir_27412}; j_27412+=${__dir_27412} )); do
            local word_27413="${words_27408[${j_27412}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:70:32)"}"
            local candidate_27414
            candidate_27414="$(if [ "$([ "_${line_27410}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27413}"; else echo "${line_27410}"" ""${word_27413}"; fi)"
            local __length_414="${candidate_27414}"
            if [ "$(( $(( ${#__length_414} > avail_27404 )) && $([ "_${line_27410}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2093_v0 "${pending_27407}" "${line_27410}" "${note_at_27411}"
                pending_27407="${blank_27405}"
                line_27410="${word_27413}"
                note_at_27411="$(if [ "$(( j_27412 >= note_start_27409 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27412 >= note_start_27409 )) && $(( note_at_27411 < 0 )) ))" != 0 ]; then
                    local __length_415="${candidate_27414}"
                    local __length_416="${word_27413}"
                    note_at_27411="$(( ${#__length_415} - ${#__length_416} ))"
                fi
                line_27410="${candidate_27414}"
            fi
done
        print_help_line__2093_v0 "${pending_27407}" "${line_27410}" "${note_at_27411}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
_options_110=()
_option_count_111=0
# Positions in `_options` that the query keeps.
_matches_112=()
# Held apart from `_matches` because `len` copies the array it is given.
_match_count_113=0
_query_114=""
_placeholder_115=""
_prompt_116="/ "
_cursor_117="> "
_height_118=10
# First match shown.
_offset_119=0
# Highlighted row inside the window.
_sel_120=0
_multi_121=0
_has_header_122=0
_term_width_123=80
# refresh_matches()
refresh_matches__2152_v0() {
    local command_419
    command_419="$(shopt -s nocasematch; __e=""; __p=""; __s=""; __i=0; for __it in "${_options_110[@]}"; do case "$__it" in ("${_query_114}") __e="$__e $__i";; ("${_query_114}"*) __p="$__p $__i";; (*"${_query_114}"*) __s="$__s $__i";; esac; __i=$((__i+1)); done; __a="$__e$__p$__s"; printf '%s' "${__a# }")"
    __status=$?
    local raw_27450="${command_419}"
    if [ "$([ "_${raw_27450}" != "_" ]; echo $?)" != 0 ]; then
        _matches_112=()
    else
        split__4_v0 "${raw_27450}" " "
        _matches_112=("${ret_split4_v0[@]}")
    fi
    local __length_421=("${_matches_112[@]}")
    _match_count_113="${#__length_421[@]}"
    _offset_119=0
    _sel_120=0
}

# visible_count()
visible_count__2153_v0() {
    local count_27510="$(( _match_count_113 - _offset_119 ))"
    if [ "$(( count_27510 > _height_118 ))" != 0 ]; then
        count_27510="${_height_118}"
    fi
    if [ "$(( count_27510 < 0 ))" != 0 ]; then
        count_27510=0
    fi
    ret_visible_count2153_v0="${count_27510}"
    return 0
}

# option_index(row: Int)
option_index__2154_v0() {
    local row_27515="${1}"
    parse_int__13_v0 "${_matches_112[$(( _offset_119 + row_27515 ))]?"Index out of bounds (at src/./filter/./mod.ab:52:37)"}"
    __status=$?
    ret_option_index2154_v0="${ret_parse_int13_v0}"
    return 0
}

# option_width()
option_width__2155_v0() {
    local check_width_27516
    check_width_27516="$(if [ "${_multi_121}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_422="${_cursor_117}"
    ret_option_width2155_v0="$(( $(( _term_width_123 - ${#__length_422} )) - check_width_27516 ))"
    return 0
}

# row_line(row: Int, highlighted: Bool)
row_line__2156_v0() {
    local row_27513="${1}"
    local highlighted_27514="${2}"
    option_index__2154_v0 "${row_27513}"
    local ret_option_index2154_v0__61_44="${ret_option_index2154_v0}"
    option_width__2155_v0 
    local ret_option_width2155_v0__61_64="${ret_option_width2155_v0}"
    cutoff_text__1991_v0 "${_options_110[${ret_option_index2154_v0__61_44}]?"Index out of bounds (at src/./filter/./mod.ab:61:44)"}" "${ret_option_width2155_v0__61_64}"
    local truncated_27517="${ret_cutoff_text1991_v0}"
    local __length_423="${_cursor_117}"
    rpad__28_v0 "" " " "${#__length_423}"
    local blank_27518="${ret_rpad28_v0}"
    if [ "$(( ! _multi_121 ))" != 0 ]; then
        if [ "${highlighted_27514}" != 0 ]; then
            colored_secondary__1960_v0 "${_cursor_117}""${truncated_27517}"
            ret_row_line2156_v0="${ret_colored_secondary1960_v0}"
            return 0
        fi
        ret_row_line2156_v0="${blank_27518}""${truncated_27517}"
        return 0
    fi
    option_index__2154_v0 "${row_27513}"
    local ret_option_index2154_v0__69_31="${ret_option_index2154_v0}"
    checked_is__2078_v0 "${ret_option_index2154_v0__69_31}"
    local ticked_27520="${ret_checked_is2078_v0}"
    local mark_27521
    mark_27521="$(if [ "${ticked_27520}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    if [ "${highlighted_27514}" != 0 ]; then
        colored_secondary__1960_v0 "${_cursor_117}""${mark_27521}""${truncated_27517}"
        ret_row_line2156_v0="${ret_colored_secondary1960_v0}"
        return 0
    fi
    if [ "${ticked_27520}" != 0 ]; then
        colored_secondary__1960_v0 "${mark_27521}""${truncated_27517}"
        local ret_colored_secondary1960_v0__75_24="${ret_colored_secondary1960_v0}"
        ret_row_line2156_v0="${blank_27518}""${ret_colored_secondary1960_v0__75_24}"
        return 0
    fi
    ret_row_line2156_v0="${blank_27518}""${mark_27521}""${truncated_27517}"
    return 0
}

# render_rows()
render_rows__2157_v0() {
    visible_count__2153_v0 
    local count_27511="${ret_visible_count2153_v0}"
    go_up__1912_v0 "${_height_118}"
    local array_424=("")
    eprintf__1857_v0 "\\x1b[G" array_424[@]
    local __range_start_27512=0
    local __range_end_27512="${count_27511}"
    local __dir_27512=$(( ${__range_start_27512} <= ${__range_end_27512} ? 1 : -1 ))
    for (( row_27512=${__range_start_27512}; row_27512 * ${__dir_27512} < ${__range_end_27512} * ${__dir_27512}; row_27512+=${__dir_27512} )); do
        row_line__2156_v0 "${row_27512}" "$(( row_27512 == _sel_120 ))"
        local ret_row_line2156_v0__86_28="${ret_row_line2156_v0}"
        local array_425=("")
        eprintf__1857_v0 "\\x1b[K""${ret_row_line2156_v0__86_28}""
" array_425[@]
done
    local __range_start_27522="${count_27511}"
    local __range_end_27522="${_height_118}"
    local __dir_27522=$(( ${__range_start_27522} <= ${__range_end_27522} ? 1 : -1 ))
    for (( ____27522=${__range_start_27522}; ____27522 * ${__dir_27522} < ${__range_end_27522} * ${__dir_27522}; ____27522+=${__dir_27522} )); do
        local array_426=("")
        eprintf__1857_v0 "\\x1b[K
" array_426[@]
done
    local array_427=("")
    eprintf__1857_v0 "\\x1b[G" array_427[@]
}

# render_query()
render_query__2158_v0() {
    go_up__1912_v0 "$(( _height_118 + 1 ))"
    local array_428=("")
    eprintf__1857_v0 "\\x1b[G\\x1b[K" array_428[@]
    colored_primary__1959_v0 "${_prompt_116}"
    local ret_colored_primary1959_v0__97_13="${ret_colored_primary1959_v0}"
    local array_429=("")
    eprintf__1857_v0 "${ret_colored_primary1959_v0__97_13}" array_429[@]
    if [ "$([ "_${_query_114}" != "_" ]; echo $?)" != 0 ]; then
        eprintf_colored__1858_v0 "${_placeholder_115}" 90
    else
        local __length_430="${_prompt_116}"
        cutoff_text__1991_v0 "${_query_114}" "$(( _term_width_123 - ${#__length_430} ))"
        local ret_cutoff_text1991_v0__101_17="${ret_cutoff_text1991_v0}"
        local array_431=("")
        eprintf__1857_v0 "${ret_cutoff_text1991_v0__101_17}" array_431[@]
    fi
    go_down__1913_v0 "$(( _height_118 + 1 ))"
    local array_432=("")
    eprintf__1857_v0 "\\x1b[G" array_432[@]
}

# render_count()
render_count__2159_v0() {
    local array_433=("")
    eprintf__1857_v0 "\\x1b[G\\x1b[K" array_433[@]
    eprintf_colored__1858_v0 "${_match_count_113}/${_option_count_111}" 90
    local array_434=("")
    eprintf__1857_v0 "\\x1b[G" array_434[@]
}

# render_tooltip_line()
render_tooltip_line__2160_v0() {
    if [ "${_multi_121}" != 0 ]; then
        local array_435=("↑↓" "select" "tab" "toggle" "ctrl-a" "all" "enter" "confirm")
        render_tooltip__2018_v0 array_435[@] 51 "${_term_width_123}"
    else
        local array_436=("↑↓" "select" "enter" "confirm")
        render_tooltip__2018_v0 array_436[@] 25 "${_term_width_123}"
    fi
}

# move_selection(step: Int)
move_selection__2161_v0() {
    local step_27525="${1}"
    visible_count__2153_v0 
    local count_27526="${ret_visible_count2153_v0}"
    if [ "$(( count_27526 == 0 ))" != 0 ]; then
        ret_move_selection2161_v0=0
        return 0
    fi
    local next_27527="$(( _sel_120 + step_27525 ))"
    if [ "$(( $(( next_27527 >= 0 )) && $(( next_27527 < count_27526 )) ))" != 0 ]; then
        local prev_27528="${_sel_120}"
        _sel_120="${next_27527}"
        row_line__2156_v0 "${prev_27528}" 0
        local ret_row_line2156_v0__132_35="${ret_row_line2156_v0}"
        redraw_row__2075_v0 "${_height_118}" "${prev_27528}" "${ret_row_line2156_v0__132_35}"
        row_line__2156_v0 "${_sel_120}" 1
        local ret_row_line2156_v0__133_35="${ret_row_line2156_v0}"
        redraw_row__2075_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2156_v0__133_35}"
        ret_move_selection2161_v0=0
        return 0
    fi
    if [ "$(( $(( next_27527 < 0 )) && $(( _offset_119 > 0 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 - 1 ))"
        ret_move_selection2161_v0=1
        return 0
    fi
    if [ "$(( $(( next_27527 >= count_27526 )) && $(( $(( _offset_119 + _height_118 )) < _match_count_113 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 + 1 ))"
        ret_move_selection2161_v0=1
        return 0
    fi
    ret_move_selection2161_v0=0
    return 0
}

# xyl_filter(options: [Text], prompt: Text, placeholder: Text, header: Text, cursor: Text, multi: Bool, limit: Int, height: Int)
xyl_filter__2162_v0() {
    local options_27433=("${!1}")
    local prompt_27434="${2}"
    local placeholder_27435="${3}"
    local header_27436="${4}"
    local cursor_27437="${5}"
    local multi_27438="${6}"
    local limit_27439="${7}"
    local height_27440="${8}"
    local __length_437=("${options_27433[@]}")
    local total_27441="${#__length_437[@]}"
    if [ "$(( total_27441 == 0 ))" != 0 ]; then
        eprintf_colored__1858_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    _options_110=("${options_27433[@]}")
    _option_count_111="${total_27441}"
    _query_114=""
    _prompt_116="${prompt_27434}"
    _placeholder_115="${placeholder_27435}"
    _cursor_117="${cursor_27437}"
    _multi_121="${multi_27438}"
    _has_header_122="$([ "_${header_27436}" == "_" ]; echo $?)"
    _offset_119=0
    _sel_120=0
    stty_lock__1898_v0 
    hide_cursor__1915_v0 
    term_width__1905_v0 
    _term_width_123="${ret_term_width1905_v0}"
    term_height__1906_v0 
    local ret_term_height1906_v0__189_24="${ret_term_height1906_v0}"
    local max_height_27446
    max_height_27446="$(( ret_term_height1906_v0__189_24 - $(if [ "${_has_header_122}" != 0 ]; then echo 4; else echo 3; fi) ))"
    _height_118="${height_27440}"
    if [ "$(( _height_118 > max_height_27446 ))" != 0 ]; then
        _height_118="${max_height_27446}"
    fi
    if [ "$(( _height_118 < 1 ))" != 0 ]; then
        _height_118=1
    fi
    if [ "${multi_27438}" != 0 ]; then
        checked_init__2077_v0 "${total_27441}" "${limit_27439}"
    fi
    refresh_matches__2152_v0 
    if [ "${_has_header_122}" != 0 ]; then
        cutoff_text__1991_v0 "${header_27436}" "${_term_width_123}"
        local ret_cutoff_text1991_v0__204_17="${ret_cutoff_text1991_v0}"
        local array_438=("")
        eprintf__1857_v0 "${ret_cutoff_text1991_v0__204_17}""
" array_438[@]
    fi
    new_line__1911_v0 1
    new_line__1911_v0 "${_height_118}"
    render_count__2159_v0 
    new_line__1911_v0 1
    render_tooltip_line__2160_v0 
    go_up__1912_v0 1
    local array_439=("")
    eprintf__1857_v0 "\\x1b[G" array_439[@]
    render_rows__2157_v0 
    render_query__2158_v0 
    while :
    do
        get_key__1855_v0 
        local key_27524="${ret_get_key1855_v0}"
        if [ "$([ "_${key_27524}" != "_INPUT" ]; echo $?)" != 0 ]; then
            visible_count__2153_v0 
            local ret_visible_count2153_v0__221_20="${ret_visible_count2153_v0}"
            if [ "$(( ret_visible_count2153_v0__221_20 > 0 ))" != 0 ]; then
                break
            fi
            if [ "${_multi_121}" != 0 ]; then
                checked_count__2079_v0 
                local ret_checked_count2079_v0__225_24="${ret_checked_count2079_v0}"
                if [ "$(( ret_checked_count2079_v0__225_24 > 0 ))" != 0 ]; then
                    break
                fi
            fi
        elif [ "$([ "_${key_27524}" != "_UP" ]; echo $?)" != 0 ]; then
            move_selection__2161_v0 -1
            local ret_move_selection2161_v0__231_20="${ret_move_selection2161_v0}"
            if [ "${ret_move_selection2161_v0__231_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$([ "_${key_27524}" != "_DOWN" ]; echo $?)" != 0 ]; then
            move_selection__2161_v0 1
            local ret_move_selection2161_v0__236_20="${ret_move_selection2161_v0}"
            if [ "${ret_move_selection2161_v0__236_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27524}" != "_TAB" ]; echo $?) ))" != 0 ]; then
            visible_count__2153_v0 
            local ret_visible_count2153_v0__241_20="${ret_visible_count2153_v0}"
            if [ "$(( ret_visible_count2153_v0__241_20 > 0 ))" != 0 ]; then
                option_index__2154_v0 "${_sel_120}"
                local ret_option_index2154_v0__242_39="${ret_option_index2154_v0}"
                checked_toggle__2080_v0 "${ret_option_index2154_v0__242_39}"
                local ret_checked_toggle2080_v0__242_24="${ret_checked_toggle2080_v0}"
                if [ "${ret_checked_toggle2080_v0__242_24}" != 0 ]; then
                    row_line__2156_v0 "${_sel_120}" 1
                    local ret_row_line2156_v0__243_51="${ret_row_line2156_v0}"
                    redraw_row__2075_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2156_v0__243_51}"
                fi
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27524}" != "_CTRL_A" ]; echo $?) ))" != 0 ]; then
            checked_all__2081_v0 
            local ret_checked_all2081_v0__248_20="${ret_checked_all2081_v0}"
            if [ "${ret_checked_all2081_v0__248_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$([ "_${key_27524}" != "_BACKSPACE" ]; echo $?)" != 0 ]; then
            if [ "$([ "_${_query_114}" == "_" ]; echo $?)" != 0 ]; then
                local __length_440="${_query_114}"
                if [ "$(( ${#__length_440} == 1 ))" != 0 ]; then
                    _query_114=""
                else
                    local __length_441="${_query_114}"
                    slice__24_v0 "${_query_114}" 0 "$(( ${#__length_441} - 1 ))"
                    _query_114="${ret_slice24_v0}"
                fi
                refresh_matches__2152_v0 
                render_rows__2157_v0 
                render_query__2158_v0 
                render_count__2159_v0 
            fi
        else
            local typed_27539="${key_27524}"
            if [ "$([ "_${key_27524}" != "_SPACE" ]; echo $?)" != 0 ]; then
                typed_27539=" "
            fi
            local __length_442="${typed_27539}"
            if [ "$(( ${#__length_442} == 1 ))" != 0 ]; then
                _query_114+="${typed_27539}"
                refresh_matches__2152_v0 
                render_rows__2157_v0 
                render_query__2158_v0 
                render_count__2159_v0 
            fi
        fi
    done
    local total_lines_27540="$(( _height_118 + 3 ))"
    if [ "${_has_header_122}" != 0 ]; then
        total_lines_27540="$(( total_lines_27540 + 1 ))"
    fi
    go_down__1913_v0 1
    remove_line__1908_v0 "$(( total_lines_27540 - 1 ))"
    remove_current_line__1909_v0 
    stty_unlock__1899_v0 
    show_cursor__1916_v0 
    local result_27545=()
    if [ "${_multi_121}" != 0 ]; then
        local __range_start_27546=0
        local __range_end_27546="${total_27441}"
        local __dir_27546=$(( ${__range_start_27546} <= ${__range_end_27546} ? 1 : -1 ))
        for (( i_27546=${__range_start_27546}; i_27546 * ${__dir_27546} < ${__range_end_27546} * ${__dir_27546}; i_27546+=${__dir_27546} )); do
            checked_is__2078_v0 "${i_27546}"
            local ret_checked_is2078_v0__294_16="${ret_checked_is2078_v0}"
            if [ "${ret_checked_is2078_v0__294_16}" != 0 ]; then
                local array_444=("${_options_110[${i_27546}]?"Index out of bounds (at src/./filter/./mod.ab:295:37)"}")
                result_27545+=("${array_444[@]}")
            fi
done
        ret_xyl_filter2162_v0=("${result_27545[@]}")
        return 0
    fi
    visible_count__2153_v0 
    local ret_visible_count2153_v0__300_8="${ret_visible_count2153_v0}"
    if [ "$(( ret_visible_count2153_v0__300_8 > 0 ))" != 0 ]; then
        option_index__2154_v0 "${_sel_120}"
        local ret_option_index2154_v0__301_29="${ret_option_index2154_v0}"
        result_27545+=("${_options_110[${ret_option_index2154_v0__301_29}]?"Index out of bounds (at src/./filter/./mod.ab:301:29)"}")
    fi
    ret_xyl_filter2162_v0=("${result_27545[@]}")
    return 0
}

# print_filter_help()
print_filter_help__2262_v0() {
    local usage_27346=("Usage:" "./xylitol.sh" "filter" "[<options>" "...]" "[flags]")
    print_wrapped__1917_v0 usage_27346[@]
    printf '%s\n' ""
    colored_primary__1959_v0 "filter"
    local ret_colored_primary1959_v0__8_20="${ret_colored_primary1959_v0}"
    local title_27386=("${ret_colored_primary1959_v0__8_20}" "-" "Pick" "from" "a" "list" "narrowed" "by" "typing.")
    print_wrapped__1917_v0 title_27386[@]
    printf '%s\n' ""
    colored_secondary__1960_v0 "Arguments:"
    local ret_colored_secondary1960_v0__11_12="${ret_colored_secondary1960_v0}"
    local array_448=()
    printf__128_v0 "${ret_colored_secondary1960_v0__11_12}""
" array_448[@]
    local array_449=("[<options> ...]")
    local array_450=("List of options to pick from")
    local array_451=("")
    render_help_entries__2094_v0 array_449[@] array_450[@] array_451[@] 20
    printf '%s\n' ""
    colored_secondary__1960_v0 "Flags:"
    local ret_colored_secondary1960_v0__14_12="${ret_colored_secondary1960_v0}"
    local array_452=()
    printf__128_v0 "${ret_colored_secondary1960_v0__14_12}""
" array_452[@]
    local names_27420=("-h, --help" "--limit=<number>" "--no-limit" "--prompt=\"<text>\"" "--placeholder=\"<text>\"" "--cursor=\"<text>\"" "--header=\"<text>\"" "--height=<number>")
    local texts_27421=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the text shown in front of the query" "Set the text shown while the query is empty" "Set the cursor text" "Set a header text to display above the query" "Set the number of options shown at once")
    local notes_27422=("" "" "" "(default: '/ ')" "(default: 'Filter...')" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__2094_v0 names_27420[@] texts_27421[@] notes_27422[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__2320_v0() {
    local options_27339=()
    local command_457
    command_457="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_27340="${command_457}"
    if [ "$([ "_${is_tty_27340}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_27339+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options2320_v0=("${options_27339[@]}")
    return 0
}

# execute_filter(parameters: [Text])
execute_filter__2321_v0() {
    local parameters_27334=("${!1}")
    local cursor_27335="> "
    local prompt_27336="/ "
    local placeholder_27337="Filter..."
    local header_27338=""
    read_stdin_options__2320_v0 
    local options_27341=("${ret_read_stdin_options2320_v0[@]}")
    local multi_27342=0
    local limit_27343=-1
    local height_27344=10
    local __length_461=("${parameters_27334[@]}")
    local slice_upper_460="${#__length_461[@]}"
    local slice_offset_462=2
    local slice_offset_462=$((${slice_offset_462} > 0 ? ${slice_offset_462} : 0))
    local slice_length_463="$(( slice_upper_460 - slice_offset_462 ))"
    local slice_length_463=$((${slice_length_463} > 0 ? ${slice_length_463} : 0))
    for param_27345 in "${parameters_27334[@]:${slice_offset_462}:${slice_length_463}}"; do
        starts_with__22_v0 "${param_27345}" "--cursor="
        local ret_starts_with22_v0__31_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27345}" "--prompt="
        local ret_starts_with22_v0__34_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27345}" "--placeholder="
        local ret_starts_with22_v0__37_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27345}" "--header="
        local ret_starts_with22_v0__40_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27345}" "--limit="
        local ret_starts_with22_v0__43_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27345}" "--height="
        local ret_starts_with22_v0__54_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27345}" != "_-h" ]; echo $?) || $([ "_${param_27345}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_filter_help__2262_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__31_13}" != 0 ]; then
            local __length_464="--cursor="
            slice__24_v0 "${param_27345}" "${#__length_464}" 0
            cursor_27335="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__34_13}" != 0 ]; then
            local __length_465="--prompt="
            slice__24_v0 "${param_27345}" "${#__length_465}" 0
            prompt_27336="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__37_13}" != 0 ]; then
            local __length_466="--placeholder="
            slice__24_v0 "${param_27345}" "${#__length_466}" 0
            placeholder_27337="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__40_13}" != 0 ]; then
            local __length_467="--header="
            slice__24_v0 "${param_27345}" "${#__length_467}" 0
            header_27338="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__43_13}" != 0 ]; then
            local __length_468="--limit="
            slice__24_v0 "${param_27345}" "${#__length_468}" 0
            local value_27423="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27423}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1858_v0 "ERROR: Invalid limit value: ""${value_27423}""
" 31
                exit 1
            fi
            limit_27343="${ret_parse_int13_v0}"
            multi_27342=1
        elif [ "$([ "_${param_27345}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_27342=1
        elif [ "${ret_starts_with22_v0__54_13}" != 0 ]; then
            local __length_469="--height="
            slice__24_v0 "${param_27345}" "${#__length_469}" 0
            local value_27428="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27428}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1858_v0 "ERROR: Invalid height value: ""${value_27428}""
" 31
                exit 1
            fi
            height_27344="${ret_parse_int13_v0}"
        else
            options_27341+=("${param_27345}")
        fi
    done
    has_ansi_escape__1983_v0 "${header_27338}"
    local ret_has_ansi_escape1983_v0__67_44="${ret_has_ansi_escape1983_v0}"
    escape_ansi__1984_v0 "${header_27338}"
    local ret_escape_ansi1984_v0__67_73="${ret_escape_ansi1984_v0}"
    colored_primary__1959_v0 "${header_27338}"
    local ret_colored_primary1959_v0__67_111="${ret_colored_primary1959_v0}"
    local display_header_27432
    display_header_27432="$(if [ "$(( $([ "_${header_27338}" != "_" ]; echo $?) || ret_has_ansi_escape1983_v0__67_44 ))" != 0 ]; then echo "${ret_escape_ansi1984_v0__67_73}"; else echo "\\x1b[1m""${ret_colored_primary1959_v0__67_111}"; fi)"
    xyl_filter__2162_v0 options_27341[@] "${prompt_27336}" "${placeholder_27337}" "${display_header_27432}" "${cursor_27335}" "${multi_27342}" "${limit_27343}" "${height_27344}"
    local results_27547=("${ret_xyl_filter2162_v0[@]}")
    join__7_v0 results_27547[@] "
"
    ret_execute_filter2321_v0="${ret_join7_v0}"
    return 0
}

# get_key()
get_key__2445_v0() {
    local command_471
    command_471="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key2445_v0="${command_471}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2447_v0() {
    local format_29602="${1}"
    local args_29603=("${!2}")
    args_29603=("${format_29602}" "${args_29603[@]}")
    __status=$?
    printf "${args_29603[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2448_v0() {
    local message_29600="${1}"
    local color_29601="${2}"
    # Prints an error message with a specified color.
    local array_472=("${message_29600}")
    eprintf__2447_v0 "\\x1b[${color_29601}m%s\\x1b[0m" array_472[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2463_v0() {
    local format_29612="${1}"
    local args_29613=("${!2}")
    args_29613=("${format_29612}" "${args_29613[@]}")
    __status=$?
    printf "${args_29613[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_126="None"
# perl_available()
perl_available__2470_v0() {
    if [ "$([ "_${_perl_state_126}" != "_None" ]; echo $?)" != 0 ]; then
        local command_473
        command_473="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29558
        disabled_29558="$([ "_${command_473}" != "_No" ]; echo $?)"
        local command_474
        command_474="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29559
        found_29559="$(( $(( ! disabled_29558 )) && $([ "_${command_474}" != "_0" ]; echo $?) ))"
        _perl_state_126="$(if [ "${found_29559}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2470_v0="$([ "_${_perl_state_126}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2471_v0() {
    local text_29557="${1}"
    perl_available__2470_v0 
    local ret_perl_available2470_v0__19_12="${ret_perl_available2470_v0}"
    if [ "$(( ! ret_perl_available2470_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return 1
    fi
    local command_475
    command_475="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29557}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return "${__status}"
    fi
    local width_str_29560="${command_475}"
    parse_int__13_v0 "${width_str_29560}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return "${__status}"
    fi
    local width_29561="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2471_v0="${width_29561}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2476_v0() {
    local text_29547="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_476
    command_476="$([[ "${text_29547}" == *$'\x1b'* || "${text_29547}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29548="${command_476}"
    ret_has_ansi_escape2476_v0="$([ "_${has_escape_29548}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2478_v0() {
    local text_29553="${1}"
    local command_477
    command_477="$(printf "%s" "${text_29553}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2478_v0="${command_477}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2479_v0() {
    local text_29555="${1}"
    local command_478
    command_478="$(printf "%s" "${text_29555}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29556="${command_478}"
    ret_is_all_ascii2479_v0="$([ "_${result_29556}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2480_v0() {
    local text_29550="${1}"
    local command_479
    command_479="$(LC_ALL=C; __t="${text_29550}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29551="${command_479}"
    parse_int__13_v0 "${measured_29551}"
    __status=$?
    ret_plain_len2480_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2481_v0() {
    local text_29549="${1}"
    plain_len__2480_v0 "${text_29549}"
    local plain_29552="${ret_plain_len2480_v0}"
    if [ "$(( plain_29552 >= 0 ))" != 0 ]; then
        ret_get_visible_len2481_v0="${plain_29552}"
        return 0
    fi
    strip_ansi__2478_v0 "${text_29549}"
    local stripped_29554="${ret_strip_ansi2478_v0}"
    is_all_ascii__2479_v0 "${stripped_29554}"
    local ret_is_all_ascii2479_v0__46_12="${ret_is_all_ascii2479_v0}"
    if [ "$(( ! ret_is_all_ascii2479_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2471_v0 "${stripped_29554}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_480="${stripped_29554}"
            ret_get_visible_len2481_v0="${#__length_480}"
            return 0
        fi
        ret_get_visible_len2481_v0="${ret_perl_get_cjk_width2471_v0}"
        return 0
    fi
    local __length_481="${stripped_29554}"
    ret_get_visible_len2481_v0="${#__length_481}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_127=0
_term_size_128=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2487_v0() {
    local command_483
    command_483="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_29610="${command_483}"
    parse_int__13_v0 "${count_29610}"
    __status=$?
    ret_stty_count2487_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2488_v0() {
    stty_count__2487_v0 
    local count_num_29611="${ret_stty_count2487_v0}"
    if [ "$(( count_num_29611 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_29611="$(( count_num_29611 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29611}
    __status=$?
}

# stty_unlock()
stty_unlock__2489_v0() {
    stty_count__2487_v0 
    local count_num_29705="${ret_stty_count2487_v0}"
    if [ "$(( count_num_29705 > 0 ))" != 0 ]; then
        count_num_29705="$(( count_num_29705 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29705}
        __status=$?
        if [ "$(( count_num_29705 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2490_v0() {
    local size_29538="${1}"
    if [ "$([ "_${size_29538}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2490_v0=0
        return 0
    fi
    split__4_v0 "${size_29538}" " "
    local parts_29539=("${ret_split4_v0[@]}")
    local __length_484=("${parts_29539[@]}")
    if [ "$(( ${#__length_484[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2490_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29539[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29539[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_128=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2490_v0=1
    return 0
}

# query_term_size()
query_term_size__2491_v0() {
    local command_486
    command_486="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29541="${command_486}"
    store_term_size__2490_v0 "${size_29541}"
    ret_query_term_size2491_v0="${ret_store_term_size2490_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2492_v0() {
    local command_487
    command_487="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29537="${command_487}"
    store_term_size__2490_v0 "${size_29537}"
    ret_stty_term_size2492_v0="${ret_store_term_size2490_v0}"
    return 0
}

# get_term_size()
get_term_size__2493_v0() {
    stty_term_size__2492_v0 
    local detected_29540="${ret_stty_term_size2492_v0}"
    if [ "$(( ! detected_29540 ))" != 0 ]; then
        query_term_size__2491_v0 
        detected_29540="${ret_query_term_size2491_v0}"
    fi
    _got_term_size_127=1
}

# term_width()
term_width__2495_v0() {
    if [ "$(( ! _got_term_size_127 ))" != 0 ]; then
        get_term_size__2493_v0 
    fi
    ret_term_width2495_v0="${_term_size_128[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2498_v0() {
    local cnt_29702="${1}"
    if [ "$(( cnt_29702 > 0 ))" != 0 ]; then
        local sequence_29703=""
        local __range_start_29704=0
        local __range_end_29704="${cnt_29702}"
        local __dir_29704=$(( ${__range_start_29704} <= ${__range_end_29704} ? 1 : -1 ))
        for (( ____29704=${__range_start_29704}; ____29704 * ${__dir_29704} < ${__range_end_29704} * ${__dir_29704}; ____29704+=${__dir_29704} )); do
            sequence_29703+="\\x1b[2K\\x1b[1A"
done
        local array_488=("")
        eprintf__2463_v0 "${sequence_29703}" array_488[@]
    fi
    local array_489=("")
    eprintf__2463_v0 "\\x1b[G" array_489[@]
}

# remove_current_line()
remove_current_line__2499_v0() {
    local array_490=("")
    eprintf__2463_v0 "\\x1b[2K\\x1b[G" array_490[@]
}

# go_up(cnt: Int)
go_up__2502_v0() {
    local cnt_29698="${1}"
    local array_491=("")
    eprintf__2463_v0 "\\x1b[${cnt_29698}A" array_491[@]
}

# go_down(cnt: Int)
go_down__2503_v0() {
    local cnt_29701="${1}"
    local array_492=("")
    eprintf__2463_v0 "\\x1b[${cnt_29701}B" array_492[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__2505_v0() {
    local array_493=("")
    eprintf__2463_v0 "\\x1b[?25l" array_493[@]
}

# show_cursor()
show_cursor__2506_v0() {
    local array_494=("")
    eprintf__2463_v0 "\\x1b[?25h" array_494[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__2507_v0() {
    local pieces_29536=("${!1}")
    term_width__2495_v0 
    local width_29542="${ret_term_width2495_v0}"
    local line_29543=""
    local line_len_29544=0
    for piece_29545 in "${pieces_29536[@]}"; do
        local __length_497="${piece_29545}"
        local piece_len_29546="${#__length_497}"
        has_ansi_escape__2476_v0 "${piece_29545}"
        local ret_has_ansi_escape2476_v0__186_12="${ret_has_ansi_escape2476_v0}"
        if [ "${ret_has_ansi_escape2476_v0__186_12}" != 0 ]; then
            get_visible_len__2481_v0 "${piece_29545}"
            piece_len_29546="${ret_get_visible_len2481_v0}"
        fi
        if [ "$([ "_${line_29543}" != "_" ]; echo $?)" != 0 ]; then
            line_29543="${piece_29545}"
            line_len_29544="${piece_len_29546}"
        elif [ "$(( $(( $(( line_len_29544 + 1 )) + piece_len_29546 )) > width_29542 ))" != 0 ]; then
            local array_498=()
            printf__128_v0 "${line_29543}""
" array_498[@]
            line_29543="${piece_29545}"
            line_len_29544="${piece_len_29546}"
        else
            line_29543+=" ""${piece_29545}"
            line_len_29544="$(( line_len_29544 + $(( 1 + piece_len_29546 )) ))"
        fi
    done
    if [ "$([ "_${line_29543}" == "_" ]; echo $?)" != 0 ]; then
        local array_499=()
        printf__128_v0 "${line_29543}""
" array_499[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_131="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_132=0
_primary_color_133=(3 207 159 92)
_secondary_color_134=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2544_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_29531="${ret_env_var_get120_v0}"
    _supports_truecolor_131="$(if [ "$([ "_${config_29531}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2544_v0="$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2545_v0() {
    local message_29526="${1}"
    local r_29527="${2}"
    local g_29528="${3}"
    local b_29529="${4}"
    local fallback_29530="${5}"
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2545_v0="\\x1b[38;2;${r_29527};${g_29528};${b_29529}m""${message_29526}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2544_v0 
        local ret_get_supports_truecolor2544_v0__45_17="${ret_get_supports_truecolor2544_v0}"
        if [ "${ret_get_supports_truecolor2544_v0__45_17}" != 0 ]; then
            ret_colored_rgb2545_v0="\\x1b[38;2;${r_29527};${g_29528};${b_29529}m""${message_29526}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_29530 == 0 ))" != 0 ]; then
            ret_colored_rgb2545_v0="${message_29526}"
            return 0
        else
            ret_colored_rgb2545_v0="\\x1b[${fallback_29530}m""${message_29526}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_29530 == 0 ))" != 0 ]; then
            ret_colored_rgb2545_v0="${message_29526}"
            return 0
        fi
        ret_colored_rgb2545_v0="\\x1b[${fallback_29530}m""${message_29526}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__2546_v0() {
    local message_29675="${1}"
    local r_29676="${2}"
    local g_29677="${3}"
    local b_29678="${4}"
    local fallback_29679="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_29680="${fallback_29679}"
    if [ "$(( $(( fallback_29679 >= 30 )) && $(( fallback_29679 <= 37 )) ))" != 0 ]; then
        bg_fallback_29680="$(( fallback_29679 + 10 ))"
    fi
    if [ "$(( $(( fallback_29679 >= 90 )) && $(( fallback_29679 <= 97 )) ))" != 0 ]; then
        bg_fallback_29680="$(( fallback_29679 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb2546_v0="\\x1b[48;2;${r_29676};${g_29677};${b_29678}m""${message_29675}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2544_v0 
        local ret_get_supports_truecolor2544_v0__87_17="${ret_get_supports_truecolor2544_v0}"
        if [ "${ret_get_supports_truecolor2544_v0__87_17}" != 0 ]; then
            ret_background_rgb2546_v0="\\x1b[48;2;${r_29676};${g_29677};${b_29678}m""${message_29675}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_29680 == 0 ))" != 0 ]; then
            ret_background_rgb2546_v0="${message_29675}"
            return 0
        else
            ret_background_rgb2546_v0="\\x1b[${bg_fallback_29680}m""${message_29675}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_29680 == 0 ))" != 0 ]; then
            ret_background_rgb2546_v0="${message_29675}"
            return 0
        fi
        ret_background_rgb2546_v0="\\x1b[${bg_fallback_29680}m""${message_29675}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2547_v0() {
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_29520="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_29520}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_29520}" ";"
            local parts_29521=("${ret_split4_v0[@]}")
            local __length_503=("${parts_29521[@]}")
            if [ "$(( ${#__length_503[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29521[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29521[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29521[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29521[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_133=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_29522="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_29522}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_29522}" ";"
            local parts_29523=("${ret_split4_v0[@]}")
            local __length_505=("${parts_29523[@]}")
            if [ "$(( ${#__length_505[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29523[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29523[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29523[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29523[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_134=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_29524="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_29524}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_29524}" ";"
            local parts_29525=("${ret_split4_v0[@]}")
            local __length_507=("${parts_29525[@]}")
            if [ "$(( ${#__length_507[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29525[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_132=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2548_v0() {
    inner_get_xylitol_colors__2547_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_132=1
}

# colored_primary(message: Text)
colored_primary__2549_v0() {
    local message_29519="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    colored_rgb__2545_v0 "${message_29519}" "${_primary_color_133[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_133[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_133[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_133[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2549_v0="${ret_colored_rgb2545_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2550_v0() {
    local message_29563="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    colored_rgb__2545_v0 "${message_29563}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2550_v0="${ret_colored_rgb2545_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__2553_v0() {
    local message_29674="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    background_rgb__2546_v0 "${message_29674}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary2553_v0="${ret_background_rgb2546_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_136="None"
# perl_available()
perl_available__2567_v0() {
    if [ "$([ "_${_perl_state_136}" != "_None" ]; echo $?)" != 0 ]; then
        local command_509
        command_509="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29626
        disabled_29626="$([ "_${command_509}" != "_No" ]; echo $?)"
        local command_510
        command_510="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29627
        found_29627="$(( $(( ! disabled_29626 )) && $([ "_${command_510}" != "_0" ]; echo $?) ))"
        _perl_state_136="$(if [ "${found_29627}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2567_v0="$([ "_${_perl_state_136}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2568_v0() {
    local text_29625="${1}"
    perl_available__2567_v0 
    local ret_perl_available2567_v0__19_12="${ret_perl_available2567_v0}"
    if [ "$(( ! ret_perl_available2567_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return 1
    fi
    local command_511
    command_511="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29625}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return "${__status}"
    fi
    local width_str_29628="${command_511}"
    parse_int__13_v0 "${width_str_29628}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return "${__status}"
    fi
    local width_29629="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2568_v0="${width_29629}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2569_v0() {
    local text_29636="${1}"
    local max_width_29637="${2}"
    perl_available__2567_v0 
    local ret_perl_available2567_v0__30_12="${ret_perl_available2567_v0}"
    if [ "$(( ! ret_perl_available2567_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2569_v0=''
        return 1
    fi
    local command_512
    command_512="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_29636}" ${max_width_29637} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2569_v0=''
        return "${__status}"
    fi
    local result_29638="${command_512}"
    ret_perl_truncate_cjk2569_v0="${result_29638}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2573_v0() {
    local text_29604="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_513
    command_513="$([[ "${text_29604}" == *$'\x1b'* || "${text_29604}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29605="${command_513}"
    ret_has_ansi_escape2573_v0="$([ "_${has_escape_29605}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2574_v0() {
    local text_29606="${1}"
    local command_514
    command_514="$(printf '%s' "${text_29606}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2574_v0="${command_514}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2575_v0() {
    local text_29621="${1}"
    local command_515
    command_515="$(printf "%s" "${text_29621}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2575_v0="${command_515}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2576_v0() {
    local text_29623="${1}"
    local command_516
    command_516="$(printf "%s" "${text_29623}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29624="${command_516}"
    ret_is_all_ascii2576_v0="$([ "_${result_29624}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2577_v0() {
    local text_29618="${1}"
    local command_517
    command_517="$(LC_ALL=C; __t="${text_29618}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29619="${command_517}"
    parse_int__13_v0 "${measured_29619}"
    __status=$?
    ret_plain_len2577_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2578_v0() {
    local text_29617="${1}"
    plain_len__2577_v0 "${text_29617}"
    local plain_29620="${ret_plain_len2577_v0}"
    if [ "$(( plain_29620 >= 0 ))" != 0 ]; then
        ret_get_visible_len2578_v0="${plain_29620}"
        return 0
    fi
    strip_ansi__2575_v0 "${text_29617}"
    local stripped_29622="${ret_strip_ansi2575_v0}"
    is_all_ascii__2576_v0 "${stripped_29622}"
    local ret_is_all_ascii2576_v0__46_12="${ret_is_all_ascii2576_v0}"
    if [ "$(( ! ret_is_all_ascii2576_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2568_v0 "${stripped_29622}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_518="${stripped_29622}"
            ret_get_visible_len2578_v0="${#__length_518}"
            return 0
        fi
        ret_get_visible_len2578_v0="${ret_perl_get_cjk_width2568_v0}"
        return 0
    fi
    local __length_519="${stripped_29622}"
    ret_get_visible_len2578_v0="${#__length_519}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2579_v0() {
    local text_29633="${1}"
    local max_width_29634="${2}"
    get_visible_len__2578_v0 "${text_29633}"
    local visible_len_29635="${ret_get_visible_len2578_v0}"
    if [ "$(( visible_len_29635 <= max_width_29634 ))" != 0 ]; then
        ret_truncate_text2579_v0="${text_29633}"
        return 0
    fi
    is_all_ascii__2576_v0 "${text_29633}"
    local ret_is_all_ascii2576_v0__61_12="${ret_is_all_ascii2576_v0}"
    if [ "$(( ! ret_is_all_ascii2576_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__2569_v0 "${text_29633}" "${max_width_29634}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_29633}" | cut -c1-${max_width_29634}
            __status=$?
        fi
        ret_truncate_text2579_v0="${ret_perl_truncate_cjk2569_v0}"
        return 0
    fi
    local command_520
    command_520="$(printf "%s" "${text_29633}" | cut -c1-${max_width_29634})"
    __status=$?
    ret_truncate_text2579_v0="${command_520}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2580_v0() {
    local text_29631="${1}"
    local max_width_29632="${2}"
    has_ansi_escape__2573_v0 "${text_29631}"
    local ret_has_ansi_escape2573_v0__73_12="${ret_has_ansi_escape2573_v0}"
    if [ "$(( ! ret_has_ansi_escape2573_v0__73_12 ))" != 0 ]; then
        truncate_text__2579_v0 "${text_29631}" "${max_width_29632}"
        ret_truncate_ansi2580_v0="${ret_truncate_text2579_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_521
    command_521="$([[ "${text_29631}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_29639="${command_521}"
    # Replace \x1b[ with newline, then split
    local command_522
    command_522="$(t="${text_29631}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_29640="${command_522}"
    split__4_v0 "${replaced_29640}" "
"
    local parts_29641=("${ret_split4_v0[@]}")
    local result_29642=""
    local remaining_width_29643="${max_width_29632}"
    local __range_start_29644=0
    local __length_523=("${parts_29641[@]}")
    local __range_end_29644="${#__length_523[@]}"
    local __dir_29644=$(( ${__range_start_29644} <= ${__range_end_29644} ? 1 : -1 ))
    for (( idx_29644=${__range_start_29644}; idx_29644 * ${__dir_29644} < ${__range_end_29644} * ${__dir_29644}; idx_29644+=${__dir_29644} )); do
        local part_29645="${parts_29641[${idx_29644}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_29644 == 0 )) && $([ "_${starts_with_ansi_29639}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_29645}" == "_" ]; echo $?) && $(( remaining_width_29643 > 0 )) ))" != 0 ]; then
                truncate_text__2579_v0 "${part_29645}" "${remaining_width_29643}"
                local ret_truncate_text2579_v0__95_35="${ret_truncate_text2579_v0}"
                local truncated_29646="${ret_truncate_text2579_v0__95_35}"
                result_29642+="${truncated_29646}"
                get_visible_len__2578_v0 "${truncated_29646}"
                local ret_get_visible_len2578_v0__97_36="${ret_get_visible_len2578_v0}"
                remaining_width_29643="$(( remaining_width_29643 - ret_get_visible_len2578_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_524
            command_524="$(__p="${part_29645}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_29647="${command_524}"
            if [ "$([ "_${m_idx_29647}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_525
                command_525="$(__p="${part_29645}"; printf "%s" "${__p:0:${m_idx_29647}}")"
                __status=$?
                local ansi_params_29648="${command_525}"
                result_29642+="\\x1b[""${ansi_params_29648}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_29647}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_29649="${ret_parse_int13_v0__108_41}"
                local text_start_29650="$(( m_idx_num_29649 + 1 ))"
                local command_526
                command_526="$(__p="${part_29645}"; printf "%s" "${__p:${text_start_29650}}")"
                __status=$?
                local text_part_29651="${command_526}"
                if [ "$(( $([ "_${text_part_29651}" == "_" ]; echo $?) && $(( remaining_width_29643 > 0 )) ))" != 0 ]; then
                    truncate_text__2579_v0 "${text_part_29651}" "${remaining_width_29643}"
                    local ret_truncate_text2579_v0__112_39="${ret_truncate_text2579_v0}"
                    local truncated_29652="${ret_truncate_text2579_v0__112_39}"
                    result_29642+="${truncated_29652}"
                    get_visible_len__2578_v0 "${truncated_29652}"
                    local ret_get_visible_len2578_v0__114_40="${ret_get_visible_len2578_v0}"
                    remaining_width_29643="$(( remaining_width_29643 - ret_get_visible_len2578_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_29645}" == "_" ]; echo $?) && $(( remaining_width_29643 > 0 )) ))" != 0 ]; then
                    truncate_text__2579_v0 "${part_29645}" "${remaining_width_29643}"
                    local ret_truncate_text2579_v0__119_39="${ret_truncate_text2579_v0}"
                    local truncated_29653="${ret_truncate_text2579_v0__119_39}"
                    result_29642+="${truncated_29653}"
                    get_visible_len__2578_v0 "${truncated_29653}"
                    local ret_get_visible_len2578_v0__121_40="${ret_get_visible_len2578_v0}"
                    remaining_width_29643="$(( remaining_width_29643 - ret_get_visible_len2578_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2580_v0="${result_29642}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2581_v0() {
    local text_29615="${1}"
    local max_width_29616="${2}"
    get_visible_len__2578_v0 "${text_29615}"
    local visible_len_29630="${ret_get_visible_len2578_v0}"
    if [ "$(( visible_len_29630 <= max_width_29616 ))" != 0 ]; then
        ret_cutoff_text2581_v0="${text_29615}"
        return 0
    fi
    truncate_ansi__2580_v0 "${text_29615}" "$(( max_width_29616 - 3 ))"
    local ret_truncate_ansi2580_v0__137_12="${ret_truncate_ansi2580_v0}"
    ret_cutoff_text2581_v0="${ret_truncate_ansi2580_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2602_v0() {
    local format_29689="${1}"
    local args_29690=("${!2}")
    args_29690=("${format_29689}" "${args_29690[@]}")
    __status=$?
    printf "${args_29690[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2603_v0() {
    local message_29687="${1}"
    local color_29688="${2}"
    # Prints an error message with a specified color.
    local array_527=("${message_29687}")
    eprintf__2602_v0 "\\x1b[${color_29688}m%s\\x1b[0m" array_527[@]
}

# colored(message: Text, color: Int)
colored__2604_v0() {
    local message_29597="${1}"
    local color_29598="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2604_v0="\\x1b[${color_29598}m""${message_29597}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2608_v0() {
    local items_29681=("${!1}")
    local total_len_29682="${2}"
    local term_width_29683="${3}"
    local separator_29684=" • "
    local separator_len_29685=3
    # Fast path: no truncation needed
    if [ "$(( total_len_29682 <= term_width_29683 ))" != 0 ]; then
        local iter_29686=0
        while :
        do
            local __length_528=("${items_29681[@]}")
            if [ "$(( iter_29686 >= ${#__length_528[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_29686 > 0 ))" != 0 ]; then
                eprintf_colored__2603_v0 "${separator_29684}" 90
            fi
            colored__2604_v0 "${items_29681[$(( iter_29686 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2604_v0__23_41="${ret_colored2604_v0}"
            local array_529=("")
            eprintf__2602_v0 "${items_29681[${iter_29686}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2604_v0__23_41}" array_529[@]
            iter_29686="$(( iter_29686 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_29691=0
        local first_29692=1
        local iter_29693=0
        while :
        do
            local __length_530=("${items_29681[@]}")
            if [ "$(( iter_29693 >= ${#__length_530[@]} ))" != 0 ]; then
                break
            fi
            local key_29694="${items_29681[${iter_29693}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_29695="${items_29681[$(( iter_29693 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_531="${key_29694}"
            local __length_532="${action_29695}"
            local part_len_29696="$(( $(( ${#__length_531} + 1 )) + ${#__length_532} ))"
            local needed_29697="${part_len_29696}"
            if [ "$(( ! first_29692 ))" != 0 ]; then
                needed_29697="$(( needed_29697 + separator_len_29685 ))"
            fi
            if [ "$(( $(( current_len_29691 + needed_29697 )) > term_width_29683 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_29692 ))" != 0 ]; then
                eprintf_colored__2603_v0 "${separator_29684}" 90
            fi
            colored__2604_v0 "${action_29695}" 2
            local ret_colored2604_v0__51_33="${ret_colored2604_v0}"
            local array_533=("")
            eprintf__2602_v0 "${key_29694}"" ""${ret_colored2604_v0__51_33}" array_533[@]
            current_len_29691="$(( current_len_29691 + needed_29697 ))"
            first_29692=0
            iter_29693="$(( iter_29693 + 2 ))"
        done
    fi
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_139=0
_term_size_140=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__2645_v0() {
    local size_29576="${1}"
    if [ "$([ "_${size_29576}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2645_v0=0
        return 0
    fi
    split__4_v0 "${size_29576}" " "
    local parts_29577=("${ret_split4_v0[@]}")
    local __length_535=("${parts_29577[@]}")
    if [ "$(( ${#__length_535[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2645_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29577[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29577[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_140=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2645_v0=1
    return 0
}

# query_term_size()
query_term_size__2646_v0() {
    local command_537
    command_537="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29579="${command_537}"
    store_term_size__2645_v0 "${size_29579}"
    ret_query_term_size2646_v0="${ret_store_term_size2645_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2647_v0() {
    local command_538
    command_538="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29575="${command_538}"
    store_term_size__2645_v0 "${size_29575}"
    ret_stty_term_size2647_v0="${ret_store_term_size2645_v0}"
    return 0
}

# get_term_size()
get_term_size__2648_v0() {
    stty_term_size__2647_v0 
    local detected_29578="${ret_stty_term_size2647_v0}"
    if [ "$(( ! detected_29578 ))" != 0 ]; then
        query_term_size__2646_v0 
        detected_29578="${ret_query_term_size2646_v0}"
    fi
    _got_term_size_139=1
}

# term_width()
term_width__2650_v0() {
    if [ "$(( ! _got_term_size_139 ))" != 0 ]; then
        get_term_size__2648_v0 
    fi
    ret_term_width2650_v0="${_term_size_140[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2683_v0() {
    local pending_29594="${1}"
    local line_29595="${2}"
    local note_at_29596="${3}"
    if [ "$(( note_at_29596 < 0 ))" != 0 ]; then
        local array_540=()
        printf__128_v0 "${pending_29594}""${line_29595}""
" array_540[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_29596 == 0 ))" != 0 ]; then
        colored__2604_v0 "${line_29595}" 90
        local ret_colored2604_v0__12_40="${ret_colored2604_v0}"
        local array_541=()
        printf__128_v0 "${pending_29594}""${ret_colored2604_v0__12_40}""
" array_541[@]
    else
        slice__24_v0 "${line_29595}" 0 "${note_at_29596}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_29595}" "${note_at_29596}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2604_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2604_v0__13_58="${ret_colored2604_v0}"
        local array_542=()
        printf__128_v0 "${pending_29594}""${ret_slice24_v0__13_32}""${ret_colored2604_v0__13_58}""
" array_542[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2684_v0() {
    local names_29567=("${!1}")
    local texts_29568=("${!2}")
    local notes_29569=("${!3}")
    local min_name_width_29570="${4}"
    local __length_543=("${names_29567[@]}")
    local count_29571="${#__length_543[@]}"
    local name_width_29572="${min_name_width_29570}"
    local __range_start_29573=0
    local __range_end_29573="${count_29571}"
    local __dir_29573=$(( ${__range_start_29573} <= ${__range_end_29573} ? 1 : -1 ))
    for (( i_29573=${__range_start_29573}; i_29573 * ${__dir_29573} < ${__range_end_29573} * ${__dir_29573}; i_29573+=${__dir_29573} )); do
        local __length_544="${names_29567[${i_29573}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_29574="${#__length_544}"
        if [ "$(( width_29574 > name_width_29572 ))" != 0 ]; then
            name_width_29572="${width_29574}"
        fi
done
    term_width__2650_v0 
    local width_29580="${ret_term_width2650_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_29581="$(( name_width_29572 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_29582="$(( $(( width_29580 - indent_29581 )) < 24 ))"
    if [ "${stacked_29582}" != 0 ]; then
        indent_29581=6
    fi
    local avail_29583="$(( width_29580 - indent_29581 ))"
    rpad__28_v0 "" " " "${indent_29581}"
    local blank_29584="${ret_rpad28_v0}"
    local __range_start_29585=0
    local __range_end_29585="${count_29571}"
    local __dir_29585=$(( ${__range_start_29585} <= ${__range_end_29585} ? 1 : -1 ))
    for (( i_29585=${__range_start_29585}; i_29585 * ${__dir_29585} < ${__range_end_29585} * ${__dir_29585}; i_29585+=${__dir_29585} )); do
        local pending_29586="${blank_29584}"
        if [ "${stacked_29582}" != 0 ]; then
            local array_545=()
            printf__128_v0 "  ""${names_29567[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_545[@]
        else
            rpad__28_v0 "  ""${names_29567[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_29581}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_29586="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_29568[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_29587=("${ret_split4_v0__52_21[@]}")
        local __length_546=("${words_29587[@]}")
        local note_start_29588="${#__length_546[@]}"
        if [ "$([ "_${notes_29569[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_547="${notes_29569[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_547} > avail_29583 ))" != 0 ]; then
                split__4_v0 "${notes_29569[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_29587+=("${ret_split4_v0__58_26[@]}")
            else
                local array_548=("${notes_29569[${i_29585}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_29587+=("${array_548[@]}")
            fi
        fi
        local line_29589=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_29590=-1
        local __range_start_29591=0
        local __length_549=("${words_29587[@]}")
        local __range_end_29591="${#__length_549[@]}"
        local __dir_29591=$(( ${__range_start_29591} <= ${__range_end_29591} ? 1 : -1 ))
        for (( j_29591=${__range_start_29591}; j_29591 * ${__dir_29591} < ${__range_end_29591} * ${__dir_29591}; j_29591+=${__dir_29591} )); do
            local word_29592="${words_29587[${j_29591}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_29593
            candidate_29593="$(if [ "$([ "_${line_29589}" != "_" ]; echo $?)" != 0 ]; then echo "${word_29592}"; else echo "${line_29589}"" ""${word_29592}"; fi)"
            local __length_550="${candidate_29593}"
            if [ "$(( $(( ${#__length_550} > avail_29583 )) && $([ "_${line_29589}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2683_v0 "${pending_29586}" "${line_29589}" "${note_at_29590}"
                pending_29586="${blank_29584}"
                line_29589="${word_29592}"
                note_at_29590="$(if [ "$(( j_29591 >= note_start_29588 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_29591 >= note_start_29588 )) && $(( note_at_29590 < 0 )) ))" != 0 ]; then
                    local __length_551="${candidate_29593}"
                    local __length_552="${word_29592}"
                    note_at_29590="$(( ${#__length_551} - ${#__length_552} ))"
                fi
                line_29589="${candidate_29593}"
            fi
done
        print_help_line__2683_v0 "${pending_29586}" "${line_29589}" "${note_at_29590}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2742_v0() {
    local selected_29655="${1}"
    local term_width_29656="${2}"
    local small_29657="$(( term_width_29656 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_29657}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_29671="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_29657}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_29672="${ret_cpad29_v0}"
    local gap_29673
    gap_29673="$(if [ "${small_29657}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_553=("")
    eprintf__2447_v0 " " array_553[@]
    if [ "${selected_29655}" != 0 ]; then
        # Yes selected
        background_secondary__2553_v0 "${yes_label_29671}"
        local ret_background_secondary2553_v0__16_30="${ret_background_secondary2553_v0}"
        local array_554=("")
        eprintf__2447_v0 "\\x1b[97m""${ret_background_secondary2553_v0__16_30}" array_554[@]
        local array_555=("")
        eprintf__2447_v0 "${gap_29673}" array_555[@]
        # No not selected (dim)
        local array_556=("")
        eprintf__2447_v0 "\\x1b[49;37m""${no_label_29672}""\\x1b[0m" array_556[@]
    else
        # No selected
        local array_557=("")
        eprintf__2447_v0 "\\x1b[49;37m""${yes_label_29671}""\\x1b[0m" array_557[@]
        local array_558=("")
        eprintf__2447_v0 "${gap_29673}" array_558[@]
        background_secondary__2553_v0 "${no_label_29672}"
        local ret_background_secondary2553_v0__24_30="${ret_background_secondary2553_v0}"
        local array_559=("")
        eprintf__2447_v0 "\\x1b[97m""${ret_background_secondary2553_v0__24_30}" array_559[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2743_v0() {
    local header_29608="${1}"
    local default_yes_29609="${2}"
    stty_lock__2488_v0 
    hide_cursor__2505_v0 
    term_width__2495_v0 
    local term_width_29614="${ret_term_width2495_v0}"
    if [ "$([ "_${header_29608}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2581_v0 "${header_29608}" "${term_width_29614}"
        local ret_cutoff_text2581_v0__46_17="${ret_cutoff_text2581_v0}"
        local array_560=("")
        eprintf__2447_v0 "${ret_cutoff_text2581_v0__46_17}""

" array_560[@]
    fi
    local selected_29654="${default_yes_29609}"
    # Render initial options
    render_confirm_options__2742_v0 "${selected_29654}" "${term_width_29614}"
    local array_561=("")
    eprintf__2447_v0 "

" array_561[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_562=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2608_v0 array_562[@] 40 "${term_width_29614}"
    go_up__2502_v0 2
    while :
    do
        get_key__2445_v0 
        local key_29699="${ret_get_key2445_v0}"
        if [ "$(( $(( $(( $([ "_${key_29699}" != "_LEFT" ]; echo $?) || $([ "_${key_29699}" != "_h" ]; echo $?) )) || $([ "_${key_29699}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_29699}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_29654}" != 0 ]; then
                selected_29654=0
                local array_563=("")
                eprintf__2447_v0 "\\x1b[G\\x1b[K" array_563[@]
                render_confirm_options__2742_v0 "${selected_29654}" "${term_width_29614}"
            elif [ "$(( ! selected_29654 ))" != 0 ]; then
                selected_29654=1
                local array_564=("")
                eprintf__2447_v0 "\\x1b[G\\x1b[K" array_564[@]
                render_confirm_options__2742_v0 "${selected_29654}" "${term_width_29614}"
            fi
        elif [ "$(( $([ "_${key_29699}" != "_y" ]; echo $?) || $([ "_${key_29699}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_29654=1
            break
        elif [ "$(( $([ "_${key_29699}" != "_n" ]; echo $?) || $([ "_${key_29699}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_29654=0
            break
        elif [ "$(( $([ "_${key_29699}" != "_INPUT" ]; echo $?) || $([ "_${key_29699}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_29700=4
    if [ "$([ "_${header_29608}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_29700="$(( total_lines_29700 + 1 ))"
    fi
    go_down__2503_v0 2
    remove_line__2498_v0 "$(( total_lines_29700 - 1 ))"
    remove_current_line__2499_v0 
    stty_unlock__2489_v0 
    show_cursor__2506_v0 
    ret_xyl_confirm2743_v0="${selected_29654}"
    return 0
}

# print_confirm_help()
print_confirm_help__2843_v0() {
    local usage_29535=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__2507_v0 usage_29535[@]
    printf '%s\n' ""
    colored_primary__2549_v0 "confirm"
    local ret_colored_primary2549_v0__8_20="${ret_colored_primary2549_v0}"
    local title_29562=("${ret_colored_primary2549_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__2507_v0 title_29562[@]
    printf '%s\n' ""
    colored_secondary__2550_v0 "Flags:"
    local ret_colored_secondary2550_v0__11_12="${ret_colored_secondary2550_v0}"
    local array_567=()
    printf__128_v0 "${ret_colored_secondary2550_v0__11_12}""
" array_567[@]
    local names_29564=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_29565=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_29566=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2684_v0 names_29564[@] texts_29565[@] notes_29566[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2901_v0() {
    local parameters_29518=("${!1}")
    colored_primary__2549_v0 "Are you sure?"
    local ret_colored_primary2549_v0__9_30="${ret_colored_primary2549_v0}"
    local header_29532="\\x1b[1m""${ret_colored_primary2549_v0__9_30}"
    local default_yes_29533=1
    for param_29534 in "${parameters_29518[@]}"; do
        starts_with__22_v0 "${param_29534}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_29534}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_29534}" != "_-h" ]; echo $?) || $([ "_${param_29534}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2843_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_573="--header="
            slice__24_v0 "${param_29534}" "${#__length_573}" 0
            header_29532="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_574="--default="
            slice__24_v0 "${param_29534}" "${#__length_574}" 0
            local value_29599="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_29599}" != "_yes" ]; echo $?) || $([ "_${value_29599}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_29533=1
            elif [ "$(( $([ "_${value_29599}" != "_no" ]; echo $?) || $([ "_${value_29599}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_29533=0
            else
                eprintf_colored__2448_v0 "ERROR: Invalid default value: ""${value_29599}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2573_v0 "${header_29532}"
    local ret_has_ansi_escape2573_v0__35_44="${ret_has_ansi_escape2573_v0}"
    escape_ansi__2574_v0 "${header_29532}"
    local ret_escape_ansi2574_v0__35_73="${ret_escape_ansi2574_v0}"
    colored_primary__2549_v0 "${header_29532}"
    local ret_colored_primary2549_v0__35_111="${ret_colored_primary2549_v0}"
    local display_header_29607
    display_header_29607="$(if [ "$(( $([ "_${header_29532}" != "_" ]; echo $?) || ret_has_ansi_escape2573_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2574_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary2549_v0__35_111}"; fi)"
    xyl_confirm__2743_v0 "${display_header_29607}" "${default_yes_29533}"
    local result_29706="${ret_xyl_confirm2743_v0}"
    ret_execute_confirm2901_v0="$(if [ "${result_29706}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3019_v0() {
    local format_40124="${1}"
    local args_40125=("${!2}")
    args_40125=("${format_40124}" "${args_40125[@]}")
    __status=$?
    printf "${args_40125[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3020_v0() {
    local message_40122="${1}"
    local color_40123="${2}"
    # Prints an error message with a specified color.
    local array_575=("${message_40122}")
    eprintf__3019_v0 "\\x1b[${color_40123}m%s\\x1b[0m" array_575[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3035_v0() {
    local format_40154="${1}"
    local args_40155=("${!2}")
    args_40155=("${format_40154}" "${args_40155[@]}")
    __status=$?
    printf "${args_40155[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_148="None"
# perl_available()
perl_available__3042_v0() {
    if [ "$([ "_${_perl_state_148}" != "_None" ]; echo $?)" != 0 ]; then
        local command_576
        command_576="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40064
        disabled_40064="$([ "_${command_576}" != "_No" ]; echo $?)"
        local command_577
        command_577="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40065
        found_40065="$(( $(( ! disabled_40064 )) && $([ "_${command_577}" != "_0" ]; echo $?) ))"
        _perl_state_148="$(if [ "${found_40065}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3042_v0="$([ "_${_perl_state_148}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3043_v0() {
    local text_40063="${1}"
    perl_available__3042_v0 
    local ret_perl_available3042_v0__19_12="${ret_perl_available3042_v0}"
    if [ "$(( ! ret_perl_available3042_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return 1
    fi
    local command_578
    command_578="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40063}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return "${__status}"
    fi
    local width_str_40066="${command_578}"
    parse_int__13_v0 "${width_str_40066}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return "${__status}"
    fi
    local width_40067="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3043_v0="${width_40067}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3048_v0() {
    local text_40053="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_579
    command_579="$([[ "${text_40053}" == *$'\x1b'* || "${text_40053}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40054="${command_579}"
    ret_has_ansi_escape3048_v0="$([ "_${has_escape_40054}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3050_v0() {
    local text_40059="${1}"
    local command_580
    command_580="$(printf "%s" "${text_40059}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3050_v0="${command_580}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3051_v0() {
    local text_40061="${1}"
    local command_581
    command_581="$(printf "%s" "${text_40061}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40062="${command_581}"
    ret_is_all_ascii3051_v0="$([ "_${result_40062}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3052_v0() {
    local text_40056="${1}"
    local command_582
    command_582="$(LC_ALL=C; __t="${text_40056}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40057="${command_582}"
    parse_int__13_v0 "${measured_40057}"
    __status=$?
    ret_plain_len3052_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3053_v0() {
    local text_40055="${1}"
    plain_len__3052_v0 "${text_40055}"
    local plain_40058="${ret_plain_len3052_v0}"
    if [ "$(( plain_40058 >= 0 ))" != 0 ]; then
        ret_get_visible_len3053_v0="${plain_40058}"
        return 0
    fi
    strip_ansi__3050_v0 "${text_40055}"
    local stripped_40060="${ret_strip_ansi3050_v0}"
    is_all_ascii__3051_v0 "${stripped_40060}"
    local ret_is_all_ascii3051_v0__46_12="${ret_is_all_ascii3051_v0}"
    if [ "$(( ! ret_is_all_ascii3051_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3043_v0 "${stripped_40060}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_583="${stripped_40060}"
            ret_get_visible_len3053_v0="${#__length_583}"
            return 0
        fi
        ret_get_visible_len3053_v0="${ret_perl_get_cjk_width3043_v0}"
        return 0
    fi
    local __length_584="${stripped_40060}"
    ret_get_visible_len3053_v0="${#__length_584}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_149=0
_term_size_150=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__3059_v0() {
    local command_586
    command_586="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40130="${command_586}"
    parse_int__13_v0 "${count_40130}"
    __status=$?
    ret_stty_count3059_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3060_v0() {
    stty_count__3059_v0 
    local count_num_40131="${ret_stty_count3059_v0}"
    if [ "$(( count_num_40131 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40131="$(( count_num_40131 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40131}
    __status=$?
}

# stty_unlock()
stty_unlock__3061_v0() {
    stty_count__3059_v0 
    local count_num_40152="${ret_stty_count3059_v0}"
    if [ "$(( count_num_40152 > 0 ))" != 0 ]; then
        count_num_40152="$(( count_num_40152 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40152}
        __status=$?
        if [ "$(( count_num_40152 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3062_v0() {
    local size_40044="${1}"
    if [ "$([ "_${size_40044}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3062_v0=0
        return 0
    fi
    split__4_v0 "${size_40044}" " "
    local parts_40045=("${ret_split4_v0[@]}")
    local __length_587=("${parts_40045[@]}")
    if [ "$(( ${#__length_587[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3062_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40045[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40045[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_150=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3062_v0=1
    return 0
}

# query_term_size()
query_term_size__3063_v0() {
    local command_589
    command_589="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40047="${command_589}"
    store_term_size__3062_v0 "${size_40047}"
    ret_query_term_size3063_v0="${ret_store_term_size3062_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3064_v0() {
    local command_590
    command_590="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40043="${command_590}"
    store_term_size__3062_v0 "${size_40043}"
    ret_stty_term_size3064_v0="${ret_store_term_size3062_v0}"
    return 0
}

# get_term_size()
get_term_size__3065_v0() {
    stty_term_size__3064_v0 
    local detected_40046="${ret_stty_term_size3064_v0}"
    if [ "$(( ! detected_40046 ))" != 0 ]; then
        query_term_size__3063_v0 
        detected_40046="${ret_query_term_size3063_v0}"
    fi
    _got_term_size_149=1
}

# term_width()
term_width__3067_v0() {
    if [ "$(( ! _got_term_size_149 ))" != 0 ]; then
        get_term_size__3065_v0 
    fi
    ret_term_width3067_v0="${_term_size_150[0]?"Index out of bounds (at src/./file/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__3071_v0() {
    local array_591=("")
    eprintf__3035_v0 "\\x1b[2K\\x1b[G" array_591[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__3079_v0() {
    local pieces_40042=("${!1}")
    term_width__3067_v0 
    local width_40048="${ret_term_width3067_v0}"
    local line_40049=""
    local line_len_40050=0
    for piece_40051 in "${pieces_40042[@]}"; do
        local __length_594="${piece_40051}"
        local piece_len_40052="${#__length_594}"
        has_ansi_escape__3048_v0 "${piece_40051}"
        local ret_has_ansi_escape3048_v0__186_12="${ret_has_ansi_escape3048_v0}"
        if [ "${ret_has_ansi_escape3048_v0__186_12}" != 0 ]; then
            get_visible_len__3053_v0 "${piece_40051}"
            piece_len_40052="${ret_get_visible_len3053_v0}"
        fi
        if [ "$([ "_${line_40049}" != "_" ]; echo $?)" != 0 ]; then
            line_40049="${piece_40051}"
            line_len_40050="${piece_len_40052}"
        elif [ "$(( $(( $(( line_len_40050 + 1 )) + piece_len_40052 )) > width_40048 ))" != 0 ]; then
            local array_595=()
            printf__128_v0 "${line_40049}""
" array_595[@]
            line_40049="${piece_40051}"
            line_len_40050="${piece_len_40052}"
        else
            line_40049+=" ""${piece_40051}"
            line_len_40050="$(( line_len_40050 + $(( 1 + piece_len_40052 )) ))"
        fi
    done
    if [ "$([ "_${line_40049}" == "_" ]; echo $?)" != 0 ]; then
        local array_596=()
        printf__128_v0 "${line_40049}""
" array_596[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_151=3
# get_directory_entries(path: Text)
get_directory_entries__3101_v0() {
    local path_40135="${1}"
    local __ls_path_597="${path_40135}"
    __ls_path_597="${__ls_path_597//\\/\\\\}"
    (( 1 )) && __ls_all_597="-A" || __ls_all_597=""
    (( 0 )) && __ls_rec_597="-R" || __ls_rec_597=""
    local __ls_597=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_597 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_597} ${__ls_rec_597} ${__ls_path_597}
    __status=$?
    );
    local names_40136=("${__ls_597[@]}")
    local command_598
    command_598="$(LC_ALL=C ls -lA "${path_40135}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_40137="${command_598}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_599
    command_599="$(LC_ALL=C ls -lA "${path_40135}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_40138="${command_599}"
    split__4_v0 "${types_output_40137}" "
"
    local types_40139=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_40138}" "
"
    local targets_40140=("${ret_split4_v0[@]}")
    local entries_40141=()
    local __range_start_40142=0
    local __length_601=("${names_40136[@]}")
    local __range_end_40142="${#__length_601[@]}"
    local __dir_40142=$(( ${__range_start_40142} <= ${__range_end_40142} ? 1 : -1 ))
    for (( i_40142=${__range_start_40142}; i_40142 * ${__dir_40142} < ${__range_end_40142} * ${__dir_40142}; i_40142+=${__dir_40142} )); do
        local array_602=("${names_40136[${i_40142}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_40141+=("${array_602[@]}")
        local array_603=("${types_40139[${i_40142}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_40141+=("${array_603[@]}")
        slice__24_v0 "${targets_40140[${i_40142}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_604=("${ret_slice24_v0__31_21}")
        entries_40141+=("${array_604[@]}")
done
    ret_get_directory_entries3101_v0=("${entries_40141[@]}")
    return 0
}

# get_cwd()
get_cwd__3102_v0() {
    local command_605
    command_605="$(pwd)"
    __status=$?
    ret_get_cwd3102_v0="${command_605}"
    return 0
}

# normalize_path(path: Text)
normalize_path__3103_v0() {
    local path_40133="${1}"
    local command_606
    command_606="$(cd "${path_40133}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_40134="${command_606}"
    if [ "$([ "_${normalized_40134}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path3103_v0="${path_40133}"
        return 0
    fi
    ret_normalize_path3103_v0="${normalized_40134}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__3104_v0() {
    local base_40319="${1}"
    local child_40320="${2}"
    if [ "$([ "_${base_40319}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join3104_v0="/""${child_40320}"
        return 0
    fi
    ret_path_join3104_v0="${base_40319}""/""${child_40320}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__3105_v0() {
    local path_40317="${1}"
    local command_607
    command_607="$(dirname "${path_40317}")"
    __status=$?
    local parent_40318="${command_607}"
    ret_get_parent_dir3105_v0="${parent_40318}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_153="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_154=0
_primary_color_155=(3 207 159 92)
_secondary_color_156=(3 118 206 94)
_accent_color_157=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__3116_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40080="${ret_env_var_get120_v0}"
    _supports_truecolor_153="$(if [ "$([ "_${config_40080}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3116_v0="$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3117_v0() {
    local message_40075="${1}"
    local r_40076="${2}"
    local g_40077="${3}"
    local b_40078="${4}"
    local fallback_40079="${5}"
    if [ "$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3117_v0="\\x1b[38;2;${r_40076};${g_40077};${b_40078}m""${message_40075}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_153}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3116_v0 
        local ret_get_supports_truecolor3116_v0__45_17="${ret_get_supports_truecolor3116_v0}"
        if [ "${ret_get_supports_truecolor3116_v0__45_17}" != 0 ]; then
            ret_colored_rgb3117_v0="\\x1b[38;2;${r_40076};${g_40077};${b_40078}m""${message_40075}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40079 == 0 ))" != 0 ]; then
            ret_colored_rgb3117_v0="${message_40075}"
            return 0
        else
            ret_colored_rgb3117_v0="\\x1b[${fallback_40079}m""${message_40075}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40079 == 0 ))" != 0 ]; then
            ret_colored_rgb3117_v0="${message_40075}"
            return 0
        fi
        ret_colored_rgb3117_v0="\\x1b[${fallback_40079}m""${message_40075}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3119_v0() {
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40069="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40069}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40069}" ";"
            local parts_40070=("${ret_split4_v0[@]}")
            local __length_611=("${parts_40070[@]}")
            if [ "$(( ${#__length_611[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40070[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40070[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40070[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40070[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_155=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40071="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40071}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40071}" ";"
            local parts_40072=("${ret_split4_v0[@]}")
            local __length_613=("${parts_40072[@]}")
            if [ "$(( ${#__length_613[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40072[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40072[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40072[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40072[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_156=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40073="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40073}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40073}" ";"
            local parts_40074=("${ret_split4_v0[@]}")
            local __length_615=("${parts_40074[@]}")
            if [ "$(( ${#__length_615[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40074[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_157=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_154=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3120_v0() {
    inner_get_xylitol_colors__3119_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_154=1
}

# colored_primary(message: Text)
colored_primary__3121_v0() {
    local message_40068="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40068}" "${_primary_color_155[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_155[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_155[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_155[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary3121_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__3122_v0() {
    local message_40082="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40082}" "${_secondary_color_156[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_156[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_156[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_156[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3122_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__3123_v0() {
    local message_40253="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40253}" "${_accent_color_157[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_157[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_157[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_157[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent3123_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__3176_v0() {
    local message_40116="${1}"
    local color_40117="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3176_v0="\\x1b[${color_40117}m""${message_40116}""\\x1b[0m"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_161=0
_term_size_162=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__3217_v0() {
    local size_40095="${1}"
    if [ "$([ "_${size_40095}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3217_v0=0
        return 0
    fi
    split__4_v0 "${size_40095}" " "
    local parts_40096=("${ret_split4_v0[@]}")
    local __length_618=("${parts_40096[@]}")
    if [ "$(( ${#__length_618[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40096[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40096[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_162=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3217_v0=1
    return 0
}

# query_term_size()
query_term_size__3218_v0() {
    local command_620
    command_620="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40098="${command_620}"
    store_term_size__3217_v0 "${size_40098}"
    ret_query_term_size3218_v0="${ret_store_term_size3217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3219_v0() {
    local command_621
    command_621="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40094="${command_621}"
    store_term_size__3217_v0 "${size_40094}"
    ret_stty_term_size3219_v0="${ret_store_term_size3217_v0}"
    return 0
}

# get_term_size()
get_term_size__3220_v0() {
    stty_term_size__3219_v0 
    local detected_40097="${ret_stty_term_size3219_v0}"
    if [ "$(( ! detected_40097 ))" != 0 ]; then
        query_term_size__3218_v0 
        detected_40097="${ret_query_term_size3218_v0}"
    fi
    _got_term_size_161=1
}

# term_width()
term_width__3222_v0() {
    if [ "$(( ! _got_term_size_161 ))" != 0 ]; then
        get_term_size__3220_v0 
    fi
    ret_term_width3222_v0="${_term_size_162[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__3255_v0() {
    local pending_40113="${1}"
    local line_40114="${2}"
    local note_at_40115="${3}"
    if [ "$(( note_at_40115 < 0 ))" != 0 ]; then
        local array_623=()
        printf__128_v0 "${pending_40113}""${line_40114}""
" array_623[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_40115 == 0 ))" != 0 ]; then
        colored__3176_v0 "${line_40114}" 90
        local ret_colored3176_v0__12_40="${ret_colored3176_v0}"
        local array_624=()
        printf__128_v0 "${pending_40113}""${ret_colored3176_v0__12_40}""
" array_624[@]
    else
        slice__24_v0 "${line_40114}" 0 "${note_at_40115}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_40114}" "${note_at_40115}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__3176_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored3176_v0__13_58="${ret_colored3176_v0}"
        local array_625=()
        printf__128_v0 "${pending_40113}""${ret_slice24_v0__13_32}""${ret_colored3176_v0__13_58}""
" array_625[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__3256_v0() {
    local names_40086=("${!1}")
    local texts_40087=("${!2}")
    local notes_40088=("${!3}")
    local min_name_width_40089="${4}"
    local __length_626=("${names_40086[@]}")
    local count_40090="${#__length_626[@]}"
    local name_width_40091="${min_name_width_40089}"
    local __range_start_40092=0
    local __range_end_40092="${count_40090}"
    local __dir_40092=$(( ${__range_start_40092} <= ${__range_end_40092} ? 1 : -1 ))
    for (( i_40092=${__range_start_40092}; i_40092 * ${__dir_40092} < ${__range_end_40092} * ${__dir_40092}; i_40092+=${__dir_40092} )); do
        local __length_627="${names_40086[${i_40092}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_40093="${#__length_627}"
        if [ "$(( width_40093 > name_width_40091 ))" != 0 ]; then
            name_width_40091="${width_40093}"
        fi
done
    term_width__3222_v0 
    local width_40099="${ret_term_width3222_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_40100="$(( name_width_40091 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_40101="$(( $(( width_40099 - indent_40100 )) < 24 ))"
    if [ "${stacked_40101}" != 0 ]; then
        indent_40100=6
    fi
    local avail_40102="$(( width_40099 - indent_40100 ))"
    rpad__28_v0 "" " " "${indent_40100}"
    local blank_40103="${ret_rpad28_v0}"
    local __range_start_40104=0
    local __range_end_40104="${count_40090}"
    local __dir_40104=$(( ${__range_start_40104} <= ${__range_end_40104} ? 1 : -1 ))
    for (( i_40104=${__range_start_40104}; i_40104 * ${__dir_40104} < ${__range_end_40104} * ${__dir_40104}; i_40104+=${__dir_40104} )); do
        local pending_40105="${blank_40103}"
        if [ "${stacked_40101}" != 0 ]; then
            local array_628=()
            printf__128_v0 "  ""${names_40086[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_628[@]
        else
            rpad__28_v0 "  ""${names_40086[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_40100}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_40105="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_40087[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_40106=("${ret_split4_v0__52_21[@]}")
        local __length_629=("${words_40106[@]}")
        local note_start_40107="${#__length_629[@]}"
        if [ "$([ "_${notes_40088[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_630="${notes_40088[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_630} > avail_40102 ))" != 0 ]; then
                split__4_v0 "${notes_40088[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_40106+=("${ret_split4_v0__58_26[@]}")
            else
                local array_631=("${notes_40088[${i_40104}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_40106+=("${array_631[@]}")
            fi
        fi
        local line_40108=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_40109=-1
        local __range_start_40110=0
        local __length_632=("${words_40106[@]}")
        local __range_end_40110="${#__length_632[@]}"
        local __dir_40110=$(( ${__range_start_40110} <= ${__range_end_40110} ? 1 : -1 ))
        for (( j_40110=${__range_start_40110}; j_40110 * ${__dir_40110} < ${__range_end_40110} * ${__dir_40110}; j_40110+=${__dir_40110} )); do
            local word_40111="${words_40106[${j_40110}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_40112
            candidate_40112="$(if [ "$([ "_${line_40108}" != "_" ]; echo $?)" != 0 ]; then echo "${word_40111}"; else echo "${line_40108}"" ""${word_40111}"; fi)"
            local __length_633="${candidate_40112}"
            if [ "$(( $(( ${#__length_633} > avail_40102 )) && $([ "_${line_40108}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__3255_v0 "${pending_40105}" "${line_40108}" "${note_at_40109}"
                pending_40105="${blank_40103}"
                line_40108="${word_40111}"
                note_at_40109="$(if [ "$(( j_40110 >= note_start_40107 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_40110 >= note_start_40107 )) && $(( note_at_40109 < 0 )) ))" != 0 ]; then
                    local __length_634="${candidate_40112}"
                    local __length_635="${word_40111}"
                    note_at_40109="$(( ${#__length_634} - ${#__length_635} ))"
                fi
                line_40108="${candidate_40112}"
            fi
done
        print_help_line__3255_v0 "${pending_40105}" "${line_40108}" "${note_at_40109}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__3364_v0() {
    local command_636
    command_636="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key3364_v0="${command_636}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3366_v0() {
    local format_40214="${1}"
    local args_40215=("${!2}")
    args_40215=("${format_40214}" "${args_40215[@]}")
    __status=$?
    printf "${args_40215[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3367_v0() {
    local message_40221="${1}"
    local color_40222="${2}"
    # Prints an error message with a specified color.
    local array_637=("${message_40221}")
    eprintf__3366_v0 "\\x1b[${color_40222}m%s\\x1b[0m" array_637[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3382_v0() {
    local format_40164="${1}"
    local args_40165=("${!2}")
    args_40165=("${format_40164}" "${args_40165[@]}")
    __status=$?
    printf "${args_40165[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_169=0
_term_size_170=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__3406_v0() {
    local command_639
    command_639="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40162="${command_639}"
    parse_int__13_v0 "${count_40162}"
    __status=$?
    ret_stty_count3406_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3407_v0() {
    stty_count__3406_v0 
    local count_num_40163="${ret_stty_count3406_v0}"
    if [ "$(( count_num_40163 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40163="$(( count_num_40163 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40163}
    __status=$?
}

# stty_unlock()
stty_unlock__3408_v0() {
    stty_count__3406_v0 
    local count_num_40314="${ret_stty_count3406_v0}"
    if [ "$(( count_num_40314 > 0 ))" != 0 ]; then
        count_num_40314="$(( count_num_40314 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40314}
        __status=$?
        if [ "$(( count_num_40314 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3409_v0() {
    local size_40167="${1}"
    if [ "$([ "_${size_40167}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3409_v0=0
        return 0
    fi
    split__4_v0 "${size_40167}" " "
    local parts_40168=("${ret_split4_v0[@]}")
    local __length_640=("${parts_40168[@]}")
    if [ "$(( ${#__length_640[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3409_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40168[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40168[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_170=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3409_v0=1
    return 0
}

# query_term_size()
query_term_size__3410_v0() {
    local command_642
    command_642="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40170="${command_642}"
    store_term_size__3409_v0 "${size_40170}"
    ret_query_term_size3410_v0="${ret_store_term_size3409_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3411_v0() {
    local command_643
    command_643="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40166="${command_643}"
    store_term_size__3409_v0 "${size_40166}"
    ret_stty_term_size3411_v0="${ret_store_term_size3409_v0}"
    return 0
}

# get_term_size()
get_term_size__3412_v0() {
    stty_term_size__3411_v0 
    local detected_40169="${ret_stty_term_size3411_v0}"
    if [ "$(( ! detected_40169 ))" != 0 ]; then
        query_term_size__3410_v0 
        detected_40169="${ret_query_term_size3410_v0}"
    fi
    _got_term_size_169=1
}

# term_width()
term_width__3414_v0() {
    if [ "$(( ! _got_term_size_169 ))" != 0 ]; then
        get_term_size__3412_v0 
    fi
    ret_term_width3414_v0="${_term_size_170[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__3415_v0() {
    if [ "$(( ! _got_term_size_169 ))" != 0 ]; then
        get_term_size__3412_v0 
    fi
    ret_term_height3415_v0="${_term_size_170[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__3417_v0() {
    local cnt_40285="${1}"
    if [ "$(( cnt_40285 > 0 ))" != 0 ]; then
        local sequence_40286=""
        local __range_start_40287=0
        local __range_end_40287="${cnt_40285}"
        local __dir_40287=$(( ${__range_start_40287} <= ${__range_end_40287} ? 1 : -1 ))
        for (( ____40287=${__range_start_40287}; ____40287 * ${__dir_40287} < ${__range_end_40287} * ${__dir_40287}; ____40287+=${__dir_40287} )); do
            sequence_40286+="\\x1b[2K\\x1b[1A"
done
        local array_644=("")
        eprintf__3382_v0 "${sequence_40286}" array_644[@]
    fi
    local array_645=("")
    eprintf__3382_v0 "\\x1b[G" array_645[@]
}

# remove_current_line()
remove_current_line__3418_v0() {
    local array_646=("")
    eprintf__3382_v0 "\\x1b[2K\\x1b[G" array_646[@]
}

# print_blank(cnt: Int)
print_blank__3419_v0() {
    local cnt_40276="${1}"
    printf '%*s' "${cnt_40276}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__3420_v0() {
    local cnt_40219="${1}"
    local __range_start_40220=0
    local __range_end_40220="${cnt_40219}"
    local __dir_40220=$(( ${__range_start_40220} <= ${__range_end_40220} ? 1 : -1 ))
    for (( ____40220=${__range_start_40220}; ____40220 * ${__dir_40220} < ${__range_end_40220} * ${__dir_40220}; ____40220+=${__dir_40220} )); do
        local array_647=("")
        eprintf__3382_v0 "
" array_647[@]
done
}

# go_up(cnt: Int)
go_up__3421_v0() {
    local cnt_40242="${1}"
    local array_648=("")
    eprintf__3382_v0 "\\x1b[${cnt_40242}A" array_648[@]
}

# go_down(cnt: Int)
go_down__3422_v0() {
    local cnt_40313="${1}"
    local array_649=("")
    eprintf__3382_v0 "\\x1b[${cnt_40313}B" array_649[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__3424_v0() {
    local array_650=("")
    eprintf__3382_v0 "\\x1b[?25l" array_650[@]
}

# show_cursor()
show_cursor__3425_v0() {
    local array_651=("")
    eprintf__3382_v0 "\\x1b[?25h" array_651[@]
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_173="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_174=0
_secondary_color_176=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__3463_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40275="${ret_env_var_get120_v0}"
    _supports_truecolor_173="$(if [ "$([ "_${config_40275}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3463_v0="$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3464_v0() {
    local message_40270="${1}"
    local r_40271="${2}"
    local g_40272="${3}"
    local b_40273="${4}"
    local fallback_40274="${5}"
    if [ "$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3464_v0="\\x1b[38;2;${r_40271};${g_40272};${b_40273}m""${message_40270}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_173}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3463_v0 
        local ret_get_supports_truecolor3463_v0__45_17="${ret_get_supports_truecolor3463_v0}"
        if [ "${ret_get_supports_truecolor3463_v0__45_17}" != 0 ]; then
            ret_colored_rgb3464_v0="\\x1b[38;2;${r_40271};${g_40272};${b_40273}m""${message_40270}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40274 == 0 ))" != 0 ]; then
            ret_colored_rgb3464_v0="${message_40270}"
            return 0
        else
            ret_colored_rgb3464_v0="\\x1b[${fallback_40274}m""${message_40270}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40274 == 0 ))" != 0 ]; then
            ret_colored_rgb3464_v0="${message_40270}"
            return 0
        fi
        ret_colored_rgb3464_v0="\\x1b[${fallback_40274}m""${message_40270}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3466_v0() {
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40264="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40264}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40264}" ";"
            local parts_40265=("${ret_split4_v0[@]}")
            local __length_655=("${parts_40265[@]}")
            if [ "$(( ${#__length_655[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40265[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40265[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40265[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40265[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_40266="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40266}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40266}" ";"
            local parts_40267=("${ret_split4_v0[@]}")
            local __length_657=("${parts_40267[@]}")
            if [ "$(( ${#__length_657[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40267[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40267[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40267[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40267[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_176=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40268="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40268}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40268}" ";"
            local parts_40269=("${ret_split4_v0[@]}")
            local __length_659=("${parts_40269[@]}")
            if [ "$(( ${#__length_659[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40269[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_174=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3467_v0() {
    inner_get_xylitol_colors__3466_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_174=1
}

# colored_secondary(message: Text)
colored_secondary__3469_v0() {
    local message_40263="${1}"
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        get_xylitol_colors__3467_v0 
    fi
    colored_rgb__3464_v0 "${message_40263}" "${_secondary_color_176[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_176[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_176[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_176[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3469_v0="${ret_colored_rgb3464_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_178="None"
# perl_available()
perl_available__3486_v0() {
    if [ "$([ "_${_perl_state_178}" != "_None" ]; echo $?)" != 0 ]; then
        local command_661
        command_661="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40184
        disabled_40184="$([ "_${command_661}" != "_No" ]; echo $?)"
        local command_662
        command_662="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40185
        found_40185="$(( $(( ! disabled_40184 )) && $([ "_${command_662}" != "_0" ]; echo $?) ))"
        _perl_state_178="$(if [ "${found_40185}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3486_v0="$([ "_${_perl_state_178}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3487_v0() {
    local text_40183="${1}"
    perl_available__3486_v0 
    local ret_perl_available3486_v0__19_12="${ret_perl_available3486_v0}"
    if [ "$(( ! ret_perl_available3486_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return 1
    fi
    local command_663
    command_663="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40183}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return "${__status}"
    fi
    local width_str_40186="${command_663}"
    parse_int__13_v0 "${width_str_40186}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return "${__status}"
    fi
    local width_40187="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3487_v0="${width_40187}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__3488_v0() {
    local text_40196="${1}"
    local max_width_40197="${2}"
    perl_available__3486_v0 
    local ret_perl_available3486_v0__30_12="${ret_perl_available3486_v0}"
    if [ "$(( ! ret_perl_available3486_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk3488_v0=''
        return 1
    fi
    local command_664
    command_664="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_40196}" ${max_width_40197} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk3488_v0=''
        return "${__status}"
    fi
    local result_40198="${command_664}"
    ret_perl_truncate_cjk3488_v0="${result_40198}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3492_v0() {
    local text_40191="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_665
    command_665="$([[ "${text_40191}" == *$'\x1b'* || "${text_40191}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40192="${command_665}"
    ret_has_ansi_escape3492_v0="$([ "_${has_escape_40192}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3494_v0() {
    local text_40179="${1}"
    local command_666
    command_666="$(printf "%s" "${text_40179}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3494_v0="${command_666}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3495_v0() {
    local text_40181="${1}"
    local command_667
    command_667="$(printf "%s" "${text_40181}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40182="${command_667}"
    ret_is_all_ascii3495_v0="$([ "_${result_40182}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3496_v0() {
    local text_40176="${1}"
    local command_668
    command_668="$(LC_ALL=C; __t="${text_40176}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40177="${command_668}"
    parse_int__13_v0 "${measured_40177}"
    __status=$?
    ret_plain_len3496_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3497_v0() {
    local text_40175="${1}"
    plain_len__3496_v0 "${text_40175}"
    local plain_40178="${ret_plain_len3496_v0}"
    if [ "$(( plain_40178 >= 0 ))" != 0 ]; then
        ret_get_visible_len3497_v0="${plain_40178}"
        return 0
    fi
    strip_ansi__3494_v0 "${text_40175}"
    local stripped_40180="${ret_strip_ansi3494_v0}"
    is_all_ascii__3495_v0 "${stripped_40180}"
    local ret_is_all_ascii3495_v0__46_12="${ret_is_all_ascii3495_v0}"
    if [ "$(( ! ret_is_all_ascii3495_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3487_v0 "${stripped_40180}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_669="${stripped_40180}"
            ret_get_visible_len3497_v0="${#__length_669}"
            return 0
        fi
        ret_get_visible_len3497_v0="${ret_perl_get_cjk_width3487_v0}"
        return 0
    fi
    local __length_670="${stripped_40180}"
    ret_get_visible_len3497_v0="${#__length_670}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__3498_v0() {
    local text_40193="${1}"
    local max_width_40194="${2}"
    get_visible_len__3497_v0 "${text_40193}"
    local visible_len_40195="${ret_get_visible_len3497_v0}"
    if [ "$(( visible_len_40195 <= max_width_40194 ))" != 0 ]; then
        ret_truncate_text3498_v0="${text_40193}"
        return 0
    fi
    is_all_ascii__3495_v0 "${text_40193}"
    local ret_is_all_ascii3495_v0__61_12="${ret_is_all_ascii3495_v0}"
    if [ "$(( ! ret_is_all_ascii3495_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__3488_v0 "${text_40193}" "${max_width_40194}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_40193}" | cut -c1-${max_width_40194}
            __status=$?
        fi
        ret_truncate_text3498_v0="${ret_perl_truncate_cjk3488_v0}"
        return 0
    fi
    local command_671
    command_671="$(printf "%s" "${text_40193}" | cut -c1-${max_width_40194})"
    __status=$?
    ret_truncate_text3498_v0="${command_671}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__3499_v0() {
    local text_40189="${1}"
    local max_width_40190="${2}"
    has_ansi_escape__3492_v0 "${text_40189}"
    local ret_has_ansi_escape3492_v0__73_12="${ret_has_ansi_escape3492_v0}"
    if [ "$(( ! ret_has_ansi_escape3492_v0__73_12 ))" != 0 ]; then
        truncate_text__3498_v0 "${text_40189}" "${max_width_40190}"
        ret_truncate_ansi3499_v0="${ret_truncate_text3498_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_672
    command_672="$([[ "${text_40189}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_40199="${command_672}"
    # Replace \x1b[ with newline, then split
    local command_673
    command_673="$(t="${text_40189}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_40200="${command_673}"
    split__4_v0 "${replaced_40200}" "
"
    local parts_40201=("${ret_split4_v0[@]}")
    local result_40202=""
    local remaining_width_40203="${max_width_40190}"
    local __range_start_40204=0
    local __length_674=("${parts_40201[@]}")
    local __range_end_40204="${#__length_674[@]}"
    local __dir_40204=$(( ${__range_start_40204} <= ${__range_end_40204} ? 1 : -1 ))
    for (( idx_40204=${__range_start_40204}; idx_40204 * ${__dir_40204} < ${__range_end_40204} * ${__dir_40204}; idx_40204+=${__dir_40204} )); do
        local part_40205="${parts_40201[${idx_40204}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_40204 == 0 )) && $([ "_${starts_with_ansi_40199}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_40205}" == "_" ]; echo $?) && $(( remaining_width_40203 > 0 )) ))" != 0 ]; then
                truncate_text__3498_v0 "${part_40205}" "${remaining_width_40203}"
                local ret_truncate_text3498_v0__95_35="${ret_truncate_text3498_v0}"
                local truncated_40206="${ret_truncate_text3498_v0__95_35}"
                result_40202+="${truncated_40206}"
                get_visible_len__3497_v0 "${truncated_40206}"
                local ret_get_visible_len3497_v0__97_36="${ret_get_visible_len3497_v0}"
                remaining_width_40203="$(( remaining_width_40203 - ret_get_visible_len3497_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_675
            command_675="$(__p="${part_40205}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_40207="${command_675}"
            if [ "$([ "_${m_idx_40207}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_676
                command_676="$(__p="${part_40205}"; printf "%s" "${__p:0:${m_idx_40207}}")"
                __status=$?
                local ansi_params_40208="${command_676}"
                result_40202+="\\x1b[""${ansi_params_40208}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_40207}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_40209="${ret_parse_int13_v0__108_41}"
                local text_start_40210="$(( m_idx_num_40209 + 1 ))"
                local command_677
                command_677="$(__p="${part_40205}"; printf "%s" "${__p:${text_start_40210}}")"
                __status=$?
                local text_part_40211="${command_677}"
                if [ "$(( $([ "_${text_part_40211}" == "_" ]; echo $?) && $(( remaining_width_40203 > 0 )) ))" != 0 ]; then
                    truncate_text__3498_v0 "${text_part_40211}" "${remaining_width_40203}"
                    local ret_truncate_text3498_v0__112_39="${ret_truncate_text3498_v0}"
                    local truncated_40212="${ret_truncate_text3498_v0__112_39}"
                    result_40202+="${truncated_40212}"
                    get_visible_len__3497_v0 "${truncated_40212}"
                    local ret_get_visible_len3497_v0__114_40="${ret_get_visible_len3497_v0}"
                    remaining_width_40203="$(( remaining_width_40203 - ret_get_visible_len3497_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_40205}" == "_" ]; echo $?) && $(( remaining_width_40203 > 0 )) ))" != 0 ]; then
                    truncate_text__3498_v0 "${part_40205}" "${remaining_width_40203}"
                    local ret_truncate_text3498_v0__119_39="${ret_truncate_text3498_v0}"
                    local truncated_40213="${ret_truncate_text3498_v0__119_39}"
                    result_40202+="${truncated_40213}"
                    get_visible_len__3497_v0 "${truncated_40213}"
                    local ret_get_visible_len3497_v0__121_40="${ret_get_visible_len3497_v0}"
                    remaining_width_40203="$(( remaining_width_40203 - ret_get_visible_len3497_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi3499_v0="${result_40202}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__3500_v0() {
    local text_40173="${1}"
    local max_width_40174="${2}"
    get_visible_len__3497_v0 "${text_40173}"
    local visible_len_40188="${ret_get_visible_len3497_v0}"
    if [ "$(( visible_len_40188 <= max_width_40174 ))" != 0 ]; then
        ret_cutoff_text3500_v0="${text_40173}"
        return 0
    fi
    truncate_ansi__3499_v0 "${text_40173}" "$(( max_width_40174 - 3 ))"
    local ret_truncate_ansi3499_v0__137_12="${ret_truncate_ansi3499_v0}"
    ret_cutoff_text3500_v0="${ret_truncate_ansi3499_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__3521_v0() {
    local format_40231="${1}"
    local args_40232=("${!2}")
    args_40232=("${format_40231}" "${args_40232[@]}")
    __status=$?
    printf "${args_40232[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3522_v0() {
    local message_40229="${1}"
    local color_40230="${2}"
    # Prints an error message with a specified color.
    local array_678=("${message_40229}")
    eprintf__3521_v0 "\\x1b[${color_40230}m%s\\x1b[0m" array_678[@]
}

# colored(message: Text, color: Int)
colored__3523_v0() {
    local message_40233="${1}"
    local color_40234="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3523_v0="\\x1b[${color_40234}m""${message_40233}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__3527_v0() {
    local items_40223=("${!1}")
    local total_len_40224="${2}"
    local term_width_40225="${3}"
    local separator_40226=" • "
    local separator_len_40227=3
    # Fast path: no truncation needed
    if [ "$(( total_len_40224 <= term_width_40225 ))" != 0 ]; then
        local iter_40228=0
        while :
        do
            local __length_679=("${items_40223[@]}")
            if [ "$(( iter_40228 >= ${#__length_679[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_40228 > 0 ))" != 0 ]; then
                eprintf_colored__3522_v0 "${separator_40226}" 90
            fi
            colored__3523_v0 "${items_40223[$(( iter_40228 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored3523_v0__23_41="${ret_colored3523_v0}"
            local array_680=("")
            eprintf__3521_v0 "${items_40223[${iter_40228}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored3523_v0__23_41}" array_680[@]
            iter_40228="$(( iter_40228 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_40235=0
        local first_40236=1
        local iter_40237=0
        while :
        do
            local __length_681=("${items_40223[@]}")
            if [ "$(( iter_40237 >= ${#__length_681[@]} ))" != 0 ]; then
                break
            fi
            local key_40238="${items_40223[${iter_40237}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_40239="${items_40223[$(( iter_40237 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_682="${key_40238}"
            local __length_683="${action_40239}"
            local part_len_40240="$(( $(( ${#__length_682} + 1 )) + ${#__length_683} ))"
            local needed_40241="${part_len_40240}"
            if [ "$(( ! first_40236 ))" != 0 ]; then
                needed_40241="$(( needed_40241 + separator_len_40227 ))"
            fi
            if [ "$(( $(( current_len_40235 + needed_40241 )) > term_width_40225 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_40236 ))" != 0 ]; then
                eprintf_colored__3522_v0 "${separator_40226}" 90
            fi
            colored__3523_v0 "${action_40239}" 2
            local ret_colored3523_v0__51_33="${ret_colored3523_v0}"
            local array_684=("")
            eprintf__3521_v0 "${key_40238}"" ""${ret_colored3523_v0__51_33}" array_684[@]
            current_len_40235="$(( current_len_40235 + needed_40241 ))"
            first_40236=0
            iter_40237="$(( iter_40237 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__3537_v0() {
    local format_40301="${1}"
    local args_40302=("${!2}")
    args_40302=("${format_40301}" "${args_40302[@]}")
    __status=$?
    printf "${args_40302[@]}" >&2
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
    local cnt_40300="${1}"
    local array_686=("")
    eprintf__3537_v0 "\\x1b[${cnt_40300}A" array_686[@]
}

# go_down(cnt: Int)
go_down__3577_v0() {
    local cnt_40303="${1}"
    local array_687=("")
    eprintf__3537_v0 "\\x1b[${cnt_40303}B" array_687[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3584_v0() {
    local display_count_40297="${1}"
    local index_40298="${2}"
    local line_40299="${3}"
    go_up__3576_v0 "$(( display_count_40297 - index_40298 ))"
    local array_688=("")
    eprintf__3521_v0 "\\x1b[G\\x1b[K" array_688[@]
    local array_689=("")
    eprintf__3521_v0 "${line_40299}" array_689[@]
    go_down__3577_v0 "$(( display_count_40297 - index_40298 ))"
    local array_690=("")
    eprintf__3521_v0 "\\x1b[G" array_690[@]
}

# Which items of a multi-select widget are ticked.
_checked_183=()
_count_184=0
_total_185=0
_limit_186=-1
# checked_init(total: Int, limit: Int)
checked_init__3586_v0() {
    local total_40216="${1}"
    local limit_40217="${2}"
    _checked_183=()
    local __range_start_40218=0
    local __range_end_40218="${total_40216}"
    local __dir_40218=$(( ${__range_start_40218} <= ${__range_end_40218} ? 1 : -1 ))
    for (( ____40218=${__range_start_40218}; ____40218 * ${__dir_40218} < ${__range_end_40218} * ${__dir_40218}; ____40218+=${__dir_40218} )); do
        local array_693=(0)
        _checked_183+=("${array_693[@]}")
done
    _count_184=0
    _total_185="${total_40216}"
    _limit_186="${limit_40217}"
}

# checked_is(index: Int)
checked_is__3587_v0() {
    local index_40260="${1}"
    ret_checked_is3587_v0="${_checked_183[${index_40260}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3589_v0() {
    local index_40292="${1}"
    if [ "${_checked_183[${index_40292}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_183["${index_40292}"]=0
        _count_184="$(( _count_184 - 1 ))"
        ret_checked_toggle3589_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_186 >= 0 )) && $(( _count_184 >= _limit_186 )) ))" != 0 ]; then
        ret_checked_toggle3589_v0=0
        return 0
    fi
    _checked_183["${index_40292}"]=1
    _count_184="$(( _count_184 + 1 ))"
    ret_checked_toggle3589_v0=1
    return 0
}

# checked_all()
checked_all__3590_v0() {
    if [ "$(( _limit_186 >= 0 ))" != 0 ]; then
        ret_checked_all3590_v0=0
        return 0
    fi
    local was_all_40304="$(( _count_184 == _total_185 ))"
    local __range_start_40305=0
    local __range_end_40305="${_total_185}"
    local __dir_40305=$(( ${__range_start_40305} <= ${__range_end_40305} ? 1 : -1 ))
    for (( i_40305=${__range_start_40305}; i_40305 * ${__dir_40305} < ${__range_end_40305} * ${__dir_40305}; i_40305+=${__dir_40305} )); do
        _checked_183["${i_40305}"]="$(( ! was_all_40304 ))"
done
    if [ "${was_all_40304}" != 0 ]; then
        _count_184=0
    else
        _count_184="${_total_185}"
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
__CHOOSER_CONTINUE_188=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_189=1
# The user confirmed the selection.
__CHOOSER_DONE_190=2
_total_191=0
_page_size_192=10
_display_count_193=0
_total_pages_194=1
_current_page_195=0
_selected_196=0
_cursor_197="> "
_multi_198=0
_limit_199=-1
_term_width_200=80
_has_header_201=0
_page_202=()
_page_count_203=0
_first_render_204=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_205=0
# render_single_page()
render_single_page__3661_v0() {
    local __length_695="${_cursor_197}"
    local cursor_len_40279="${#__length_695}"
    local max_option_width_40280="$(( $(( _term_width_200 - cursor_len_40279 )) - 1 ))"
    local __range_start_40281=0
    local __range_end_40281="${_page_count_203}"
    local __dir_40281=$(( ${__range_start_40281} <= ${__range_end_40281} ? 1 : -1 ))
    for (( i_40281=${__range_start_40281}; i_40281 * ${__dir_40281} < ${__range_end_40281} * ${__dir_40281}; i_40281+=${__dir_40281} )); do
        cutoff_text__3500_v0 "${_page_202[${i_40281}]?"Index out of bounds (at src/./file/../choose/engine.ab:45:45)"}" "${max_option_width_40280}"
        local ret_cutoff_text3500_v0__45_27="${ret_cutoff_text3500_v0}"
        local truncated_40282="${ret_cutoff_text3500_v0__45_27}"
        if [ "$(( i_40281 == _selected_196 ))" != 0 ]; then
            colored_secondary__3469_v0 "${_cursor_197}""${truncated_40282}""
"
            local ret_colored_secondary3469_v0__47_21="${ret_colored_secondary3469_v0}"
            local array_696=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__47_21}" array_696[@]
        else
            print_blank__3419_v0 "${cursor_len_40279}"
            local array_697=("")
            eprintf__3366_v0 "${truncated_40282}""
" array_697[@]
        fi
done
    local remaining_slots_40283="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40283 > 0 ))" != 0 ]; then
        local __range_start_40284=0
        local __range_end_40284="${remaining_slots_40283}"
        local __dir_40284=$(( ${__range_start_40284} <= ${__range_end_40284} ? 1 : -1 ))
        for (( ____40284=${__range_start_40284}; ____40284 * ${__dir_40284} < ${__range_end_40284} * ${__dir_40284}; ____40284+=${__dir_40284} )); do
            local array_698=("")
            eprintf__3366_v0 "\\x1b[K
" array_698[@]
done
    fi
}

# render_multi_page()
render_multi_page__3662_v0() {
    local __length_699="${_cursor_197}"
    local cursor_len_40255="${#__length_699}"
    local max_option_width_40256="$(( $(( _term_width_200 - cursor_len_40255 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3667_v0 
    local page_start_40257="${ret_chooser_page_start3667_v0}"
    local __range_start_40258=0
    local __range_end_40258="${_page_count_203}"
    local __dir_40258=$(( ${__range_start_40258} <= ${__range_end_40258} ? 1 : -1 ))
    for (( i_40258=${__range_start_40258}; i_40258 * ${__dir_40258} < ${__range_end_40258} * ${__dir_40258}; i_40258+=${__dir_40258} )); do
        local global_idx_40259="$(( page_start_40257 + i_40258 ))"
        checked_is__3587_v0 "${global_idx_40259}"
        local ret_checked_is3587_v0__67_28="${ret_checked_is3587_v0}"
        local check_mark_40261
        check_mark_40261="$(if [ "${ret_checked_is3587_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__3500_v0 "${_page_202[${i_40258}]?"Index out of bounds (at src/./file/../choose/engine.ab:68:45)"}" "${max_option_width_40256}"
        local ret_cutoff_text3500_v0__68_27="${ret_cutoff_text3500_v0}"
        local truncated_40262="${ret_cutoff_text3500_v0__68_27}"
        checked_is__3587_v0 "${global_idx_40259}"
        local ret_checked_is3587_v0__71_13="${ret_checked_is3587_v0}"
        if [ "$(( i_40258 == _selected_196 ))" != 0 ]; then
            colored_secondary__3469_v0 "${_cursor_197}""${check_mark_40261}""${truncated_40262}""
"
            local ret_colored_secondary3469_v0__70_37="${ret_colored_secondary3469_v0}"
            local array_700=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__70_37}" array_700[@]
        elif [ "${ret_checked_is3587_v0__71_13}" != 0 ]; then
            print_blank__3419_v0 "${cursor_len_40255}"
            colored_secondary__3469_v0 "${check_mark_40261}""${truncated_40262}""
"
            local ret_colored_secondary3469_v0__73_25="${ret_colored_secondary3469_v0}"
            local array_701=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__73_25}" array_701[@]
        else
            print_blank__3419_v0 "${cursor_len_40255}"
            local array_702=("")
            eprintf__3366_v0 "${check_mark_40261}""${truncated_40262}""
" array_702[@]
        fi
done
    local remaining_slots_40277="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40277 > 0 ))" != 0 ]; then
        local __range_start_40278=0
        local __range_end_40278="${remaining_slots_40277}"
        local __dir_40278=$(( ${__range_start_40278} <= ${__range_end_40278} ? 1 : -1 ))
        for (( ____40278=${__range_start_40278}; ____40278 * ${__dir_40278} < ${__range_end_40278} * ${__dir_40278}; ____40278+=${__dir_40278} )); do
            local array_703=("")
            eprintf__3366_v0 "\\x1b[K
" array_703[@]
done
    fi
}

# render_page()
render_page__3663_v0() {
    if [ "${_multi_198}" != 0 ]; then
        render_multi_page__3662_v0 
    else
        render_single_page__3661_v0 
    fi
}

# render_page_indicator()
render_page_indicator__3664_v0() {
    if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
        local array_704=("")
        eprintf__3366_v0 "\\x1b[G\\x1b[K" array_704[@]
        eprintf_colored__3367_v0 "Page $(( _current_page_195 + 1 ))/${_total_pages_194}" 90
        local array_705=("")
        eprintf__3366_v0 "\\x1b[G" array_705[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__3665_v0() {
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
            local array_706=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__3527_v0 array_706[@] 36 "${_term_width_200}"
        else
            local array_707=("↑↓" "select" "enter" "confirm")
            render_tooltip__3527_v0 array_707[@] 25 "${_term_width_200}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_194 > 1 )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
            local array_708=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__3527_v0 array_708[@] 55 "${_term_width_200}"
        elif [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
            local array_709=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__3527_v0 array_709[@] 47 "${_term_width_200}"
        elif [ "$(( _limit_199 < 0 ))" != 0 ]; then
            local array_710=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__3527_v0 array_710[@] 44 "${_term_width_200}"
        else
            local array_711=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__3527_v0 array_711[@] 36 "${_term_width_200}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__3666_v0() {
    local total_40156="${1}"
    local page_size_40157="${2}"
    local header_40158="${3}"
    local cursor_40159="${4}"
    local multi_40160="${5}"
    local limit_40161="${6}"
    _total_191="${total_40156}"
    _cursor_197="${cursor_40159}"
    _multi_198="${multi_40160}"
    _limit_199="${limit_40161}"
    _current_page_195=0
    _selected_196=0
    _first_render_204=1
    _up_paged_205=0
    _has_header_201="$([ "_${header_40158}" == "_" ]; echo $?)"
    stty_lock__3407_v0 
    hide_cursor__3424_v0 
    term_width__3414_v0 
    _term_width_200="${ret_term_width3414_v0}"
    term_height__3415_v0 
    local term_height_40171="${ret_term_height3415_v0}"
    local max_page_size_40172
    max_page_size_40172="$(( term_height_40171 - $(if [ "${_has_header_201}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_192="${page_size_40157}"
    if [ "$(( _page_size_192 > max_page_size_40172 ))" != 0 ]; then
        _page_size_192="${max_page_size_40172}"
    fi
    if [ "${_has_header_201}" != 0 ]; then
        cutoff_text__3500_v0 "${header_40158}" "${_term_width_200}"
        local ret_cutoff_text3500_v0__153_17="${ret_cutoff_text3500_v0}"
        local array_712=("")
        eprintf__3366_v0 "${ret_cutoff_text3500_v0__153_17}""
" array_712[@]
    fi
    math_floor__636_v0 "$(( $(( $(( total_40156 + _page_size_192 )) - 1 )) / _page_size_192 ))"
    _total_pages_194="${ret_math_floor636_v0}"
    _display_count_193="${_page_size_192}"
    if [ "$(( total_40156 < _page_size_192 ))" != 0 ]; then
        _display_count_193="${total_40156}"
    fi
    if [ "${multi_40160}" != 0 ]; then
        checked_init__3586_v0 "${total_40156}" "${limit_40161}"
    fi
    new_line__3420_v0 "${_display_count_193}"
    local array_713=("")
    eprintf__3366_v0 "\\x1b[G" array_713[@]
    if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
        eprintf_colored__3367_v0 "Page $(( _current_page_195 + 1 ))/${_total_pages_194}" 90
    fi
    new_line__3420_v0 1
    render_tooltip_line__3665_v0 
    go_up__3421_v0 "$(( _display_count_193 + 1 ))"
    local array_714=("")
    eprintf__3366_v0 "\\x1b[G" array_714[@]
}

# chooser_page_start()
chooser_page_start__3667_v0() {
    ret_chooser_page_start3667_v0="$(( _current_page_195 * _page_size_192 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__3668_v0() {
    chooser_page_start__3667_v0 
    local start_40246="${ret_chooser_page_start3667_v0}"
    local end_40247="$(( start_40246 + _page_size_192 ))"
    if [ "$(( end_40247 > _total_191 ))" != 0 ]; then
        end_40247="${_total_191}"
    fi
    ret_chooser_page_count3668_v0="$(( end_40247 - start_40246 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3669_v0() {
    local page_40254=("${!1}")
    _page_202=("${page_40254[@]}")
    local __length_715=("${page_40254[@]}")
    _page_count_203="${#__length_715[@]}"
    if [ "${_first_render_204}" != 0 ]; then
        _first_render_204=0
        render_page__3663_v0 
    else
        if [ "${_up_paged_205}" != 0 ]; then
            _selected_196="$(( _page_count_203 - 1 ))"
            _up_paged_205=0
        fi
        go_up__3421_v0 1
        remove_line__3417_v0 "$(( _display_count_193 - 1 ))"
        remove_current_line__3418_v0 
        local array_716=("")
        eprintf__3366_v0 "\\x1b[G" array_716[@]
        render_page__3663_v0 
        render_page_indicator__3664_v0 
    fi
}

# option_width()
option_width__3670_v0() {
    local check_width_40294
    check_width_40294="$(if [ "${_multi_198}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_717="${_cursor_197}"
    ret_option_width3670_v0="$(( $(( _term_width_200 - ${#__length_717} )) - check_width_40294 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3671_v0() {
    local index_40307="${1}"
    local __length_718="${_cursor_197}"
    rpad__28_v0 "" " " "${#__length_718}"
    local blank_40308="${ret_rpad28_v0}"
    option_width__3670_v0 
    local ret_option_width3670_v0__224_49="${ret_option_width3670_v0}"
    cutoff_text__3500_v0 "${_page_202[${index_40307}]?"Index out of bounds (at src/./file/../choose/engine.ab:224:41)"}" "${ret_option_width3670_v0__224_49}"
    local truncated_40309="${ret_cutoff_text3500_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        ret_unselected_line3671_v0="${blank_40308}""${truncated_40309}"
        return 0
    fi
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__228_19="${ret_chooser_page_start3667_v0}"
    checked_is__3587_v0 "$(( ret_chooser_page_start3667_v0__228_19 + index_40307 ))"
    local ret_checked_is3587_v0__228_8="${ret_checked_is3587_v0}"
    if [ "${ret_checked_is3587_v0__228_8}" != 0 ]; then
        colored_secondary__3469_v0 "✓ ""${truncated_40309}"
        local ret_colored_secondary3469_v0__229_24="${ret_colored_secondary3469_v0}"
        ret_unselected_line3671_v0="${blank_40308}""${ret_colored_secondary3469_v0__229_24}"
        return 0
    fi
    ret_unselected_line3671_v0="${blank_40308}""• ""${truncated_40309}"
    return 0
}

# selected_line(index: Int)
selected_line__3672_v0() {
    local index_40293="${1}"
    option_width__3670_v0 
    local ret_option_width3670_v0__236_49="${ret_option_width3670_v0}"
    cutoff_text__3500_v0 "${_page_202[${index_40293}]?"Index out of bounds (at src/./file/../choose/engine.ab:236:41)"}" "${ret_option_width3670_v0__236_49}"
    local truncated_40295="${ret_cutoff_text3500_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        colored_secondary__3469_v0 "${_cursor_197}""${truncated_40295}"
        ret_selected_line3672_v0="${ret_colored_secondary3469_v0}"
        return 0
    fi
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__240_29="${ret_chooser_page_start3667_v0}"
    checked_is__3587_v0 "$(( ret_chooser_page_start3667_v0__240_29 + index_40293 ))"
    local ret_checked_is3587_v0__240_18="${ret_checked_is3587_v0}"
    local mark_40296
    mark_40296="$(if [ "${ret_checked_is3587_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__3469_v0 "${_cursor_197}""${mark_40296}""${truncated_40295}"
    ret_selected_line3672_v0="${ret_colored_secondary3469_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3673_v0() {
    local prev_selected_40306="${1}"
    unselected_line__3671_v0 "${prev_selected_40306}"
    local ret_unselected_line3671_v0__247_47="${ret_unselected_line3671_v0}"
    redraw_row__3584_v0 "${_display_count_193}" "${prev_selected_40306}" "${ret_unselected_line3671_v0__247_47}"
    selected_line__3672_v0 "${_selected_196}"
    local ret_selected_line3672_v0__248_43="${ret_selected_line3672_v0}"
    redraw_row__3584_v0 "${_display_count_193}" "${_selected_196}" "${ret_selected_line3672_v0__248_43}"
}

# redraw_current_line()
redraw_current_line__3674_v0() {
    selected_line__3672_v0 "${_selected_196}"
    local ret_selected_line3672_v0__253_43="${ret_selected_line3672_v0}"
    redraw_row__3584_v0 "${_display_count_193}" "${_selected_196}" "${ret_selected_line3672_v0__253_43}"
}

# chooser_step()
chooser_step__3675_v0() {
    get_key__3364_v0 
    local key_40288="${ret_get_key3364_v0}"
    local prev_selected_40289="${_selected_196}"
    local prev_page_40290="${_current_page_195}"
    chooser_page_start__3667_v0 
    local page_start_40291="${ret_chooser_page_start3667_v0}"
    _up_paged_205=0
    if [ "$(( $([ "_${key_40288}" != "_UP" ]; echo $?) || $([ "_${key_40288}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_196 == 0 )) && $(( _total_pages_194 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_195 > 0 ))" != 0 ]; then
                _current_page_195="$(( _current_page_195 - 1 ))"
            else
                _current_page_195="$(( _total_pages_194 - 1 ))"
            fi
            _up_paged_205=1
        elif [ "$(( _selected_196 == 0 ))" != 0 ]; then
            _selected_196="$(( _page_count_203 - 1 ))"
        else
            _selected_196="$(( _selected_196 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_40288}" != "_DOWN" ]; echo $?) || $([ "_${key_40288}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_196 == $(( _page_count_203 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_195 < $(( _total_pages_194 - 1 )) ))" != 0 ]; then
                _current_page_195="$(( _current_page_195 + 1 ))"
            else
                _current_page_195=0
            fi
            _selected_196=0
        else
            _selected_196="$(( _selected_196 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_40288}" != "_LEFT" ]; echo $?) || $([ "_${key_40288}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 > 0 ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 - 1 ))"
        fi
        _selected_196=0
    elif [ "$(( $([ "_${key_40288}" != "_RIGHT" ]; echo $?) || $([ "_${key_40288}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 < $(( _total_pages_194 - 1 )) ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 + 1 ))"
            _selected_196=0
        else
            _selected_196="$(( _page_count_203 - 1 ))"
        fi
    elif [ "$(( _multi_198 && $(( $(( $([ "_${key_40288}" != "_x" ]; echo $?) || $([ "_${key_40288}" != "_X" ]; echo $?) )) || $([ "_${key_40288}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3589_v0 "$(( page_start_40291 + _selected_196 ))"
        local ret_checked_toggle3589_v0__310_16="${ret_checked_toggle3589_v0}"
        if [ "${ret_checked_toggle3589_v0__310_16}" != 0 ]; then
            redraw_current_line__3674_v0 
        fi
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $(( _multi_198 && $(( $(( $([ "_${key_40288}" != "_a" ]; echo $?) || $([ "_${key_40288}" != "_A" ]; echo $?) )) || $([ "_${key_40288}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
        checked_all__3590_v0 
        local ret_checked_all3590_v0__316_16="${ret_checked_all3590_v0}"
        if [ "${ret_checked_all3590_v0__316_16}" != 0 ]; then
            go_up__3421_v0 "${_display_count_193}"
            local array_719=("")
            eprintf__3366_v0 "\\x1b[G" array_719[@]
            render_page__3663_v0 
        fi
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $([ "_${key_40288}" != "_INPUT" ]; echo $?) || $([ "_${key_40288}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step3675_v0="${__CHOOSER_DONE_190}"
        return 0
    else
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    fi
    if [ "$(( prev_page_40290 != _current_page_195 ))" != 0 ]; then
        ret_chooser_step3675_v0="${__CHOOSER_NEED_PAGE_189}"
        return 0
    fi
    if [ "$(( prev_selected_40289 != _selected_196 ))" != 0 ]; then
        redraw_selection__3673_v0 "${prev_selected_40289}"
    fi
    ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_188}"
    return 0
}

# chooser_selected()
chooser_selected__3676_v0() {
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__340_12="${ret_chooser_page_start3667_v0}"
    ret_chooser_selected3676_v0="$(( ret_chooser_page_start3667_v0__340_12 + _selected_196 ))"
    return 0
}

# chooser_end()
chooser_end__3678_v0() {
    local total_lines_40312="$(( _display_count_193 + 2 ))"
    if [ "${_has_header_201}" != 0 ]; then
        total_lines_40312="$(( total_lines_40312 + 1 ))"
    fi
    go_down__3422_v0 1
    remove_line__3417_v0 "$(( total_lines_40312 - 1 ))"
    remove_current_line__3418_v0 
    stty_unlock__3408_v0 
    show_cursor__3425_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3687_v0() {
    local name_40250="${1}"
    local file_type_40251="${2}"
    local target_40252="${3}"
    if [ "$([ "_${file_type_40251}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__3121_v0 "/"
        local ret_colored_primary3121_v0__10_23="${ret_colored_primary3121_v0}"
        ret_format_entry_display3687_v0="${name_40250}""${ret_colored_primary3121_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_40251}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__3123_v0 " > "
        local ret_colored_accent3123_v0__13_23="${ret_colored_accent3123_v0}"
        colored_primary__3121_v0 "${target_40252}"
        local ret_colored_primary3121_v0__13_47="${ret_colored_primary3121_v0}"
        ret_format_entry_display3687_v0="${name_40250}""${ret_colored_accent3123_v0__13_23}""${ret_colored_primary3121_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3687_v0="${name_40250}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3688_v0() {
    local start_path_40126="${1}"
    local cursor_40127="${2}"
    local show_hidden_40128="${3}"
    local page_size_40129="${4}"
    stty_lock__3060_v0 
    # Initialize current path
    local current_path_40132="${start_path_40126}"
    if [ "$([ "_${current_path_40132}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__3102_v0 
        current_path_40132="${ret_get_cwd3102_v0}"
    fi
    normalize_path__3103_v0 "${current_path_40132}"
    current_path_40132="${ret_normalize_path3103_v0}"
    while :
    do
        colored_primary__3121_v0 "Loading files..."
        local ret_colored_primary3121_v0__41_17="${ret_colored_primary3121_v0}"
        local array_720=("")
        eprintf__3019_v0 "${ret_colored_primary3121_v0__41_17}" array_720[@]
        get_directory_entries__3101_v0 "${current_path_40132}"
        local listed_40143=("${ret_get_directory_entries3101_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_40144=()
        local types_40145=()
        local targets_40146=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_40132}" == "_/" ]; echo $?)" != 0 ]; then
            names_40144+=("..")
            types_40145+=("d")
            targets_40146+=("")
        fi
        local __length_727=("${listed_40143[@]}")
        local listed_count_40147="$(( ${#__length_727[@]} / __ENTRY_STRIDE_151 ))"
        local __range_start_40148=0
        local __range_end_40148="${listed_count_40147}"
        local __dir_40148=$(( ${__range_start_40148} <= ${__range_end_40148} ? 1 : -1 ))
        for (( i_40148=${__range_start_40148}; i_40148 * ${__dir_40148} < ${__range_end_40148} * ${__dir_40148}; i_40148+=${__dir_40148} )); do
            local at_40149="$(( i_40148 * __ENTRY_STRIDE_151 ))"
            local name_40150="${listed_40143[${at_40149}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_40150}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_40128 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_728=("${name_40150}")
            names_40144+=("${array_728[@]}")
            local array_729=("${listed_40143[$(( at_40149 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_40145+=("${array_729[@]}")
            local array_730=("${listed_40143[$(( at_40149 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_40146+=("${array_730[@]}")
done
        local __length_731=("${names_40144[@]}")
        local total_40151="${#__length_731[@]}"
        if [ "$(( total_40151 == 0 ))" != 0 ]; then
            eprintf_colored__3020_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__3061_v0 
            ret_xyl_file3688_v0=""
            return 0
        fi
        colored_primary__3121_v0 "${current_path_40132}"
        local header_40153="${ret_colored_primary3121_v0}"
        remove_current_line__3071_v0 
        chooser_begin__3666_v0 "${total_40151}" "${page_size_40129}" "${header_40153}" "${cursor_40127}" 0 -1
        local need_page_40243=1
        while :
        do
            if [ "${need_page_40243}" != 0 ]; then
                local page_40244=()
                chooser_page_start__3667_v0 
                local start_40245="${ret_chooser_page_start3667_v0}"
                chooser_page_count__3668_v0 
                local count_40248="${ret_chooser_page_count3668_v0}"
                local __range_start_40249="${start_40245}"
                local __range_end_40249="$(( start_40245 + count_40248 ))"
                local __dir_40249=$(( ${__range_start_40249} <= ${__range_end_40249} ? 1 : -1 ))
                for (( i_40249=${__range_start_40249}; i_40249 * ${__dir_40249} < ${__range_end_40249} * ${__dir_40249}; i_40249+=${__dir_40249} )); do
                    format_entry_display__3687_v0 "${names_40144[${i_40249}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_40145[${i_40249}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_40146[${i_40249}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3687_v0__90_30="${ret_format_entry_display3687_v0}"
                    local array_733=("${ret_format_entry_display3687_v0__90_30}")
                    page_40244+=("${array_733[@]}")
done
                chooser_set_page__3669_v0 page_40244[@]
            fi
            chooser_step__3675_v0 
            local step_40310="${ret_chooser_step3675_v0}"
            if [ "$(( step_40310 == __CHOOSER_DONE_190 ))" != 0 ]; then
                break
            fi
            need_page_40243="$(( step_40310 == __CHOOSER_NEED_PAGE_189 ))"
        done
        chooser_selected__3676_v0 
        local selected_idx_40311="${ret_chooser_selected3676_v0}"
        chooser_end__3678_v0 
        local name_40315="${names_40144[${selected_idx_40311}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_40316="${types_40145[${selected_idx_40311}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_40315}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__3105_v0 "${current_path_40132}"
            current_path_40132="${ret_get_parent_dir3105_v0}"
        elif [ "$([ "_${file_type_40316}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__3104_v0 "${current_path_40132}" "${name_40315}"
            current_path_40132="${ret_path_join3104_v0}"
            normalize_path__3103_v0 "${current_path_40132}"
            current_path_40132="${ret_normalize_path3103_v0}"
        elif [ "$([ "_${file_type_40316}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_40321="${targets_40146[${selected_idx_40311}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_40322="${target_40321}"
            starts_with__22_v0 "${target_40321}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__3104_v0 "${current_path_40132}" "${target_40321}"
                target_path_40322="${ret_path_join3104_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_40322}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_40132="${target_path_40322}"
                normalize_path__3103_v0 "${current_path_40132}"
                current_path_40132="${ret_normalize_path3103_v0}"
            else
                stty_unlock__3061_v0 
                path_join__3104_v0 "${current_path_40132}" "${name_40315}"
                ret_xyl_file3688_v0="${ret_path_join3104_v0}"
                return 0
            fi
        else
            stty_unlock__3061_v0 
            path_join__3104_v0 "${current_path_40132}" "${name_40315}"
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
    local usage_40041=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__3079_v0 usage_40041[@]
    printf '%s\n' ""
    colored_primary__3121_v0 "file"
    local ret_colored_primary3121_v0__8_20="${ret_colored_primary3121_v0}"
    local title_40081=("${ret_colored_primary3121_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__3079_v0 title_40081[@]
    printf '%s\n' ""
    colored_secondary__3122_v0 "Arguments:"
    local ret_colored_secondary3122_v0__11_12="${ret_colored_secondary3122_v0}"
    local array_736=()
    printf__128_v0 "${ret_colored_secondary3122_v0__11_12}""
" array_736[@]
    local arg_names_40083=("[<path>]")
    local arg_texts_40084=("Starting directory path")
    local arg_notes_40085=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__3256_v0 arg_names_40083[@] arg_texts_40084[@] arg_notes_40085[@] 20
    printf '%s\n' ""
    colored_secondary__3122_v0 "Flags:"
    local ret_colored_secondary3122_v0__18_12="${ret_colored_secondary3122_v0}"
    local array_740=()
    printf__128_v0 "${ret_colored_secondary3122_v0__18_12}""
" array_740[@]
    local names_40118=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_40119=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_40120=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__3256_v0 names_40118[@] texts_40119[@] notes_40120[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3846_v0() {
    local parameters_40035=("${!1}")
    local cursor_40036="> "
    local start_path_40037=""
    local show_hidden_40038=0
    local page_size_40039=10
    local __length_747=("${parameters_40035[@]}")
    local slice_upper_746="${#__length_747[@]}"
    local slice_offset_748=2
    local slice_offset_748=$((${slice_offset_748} > 0 ? ${slice_offset_748} : 0))
    local slice_length_749="$(( slice_upper_746 - slice_offset_748 ))"
    local slice_length_749=$((${slice_length_749} > 0 ? ${slice_length_749} : 0))
    for param_40040 in "${parameters_40035[@]:${slice_offset_748}:${slice_length_749}}"; do
        starts_with__22_v0 "${param_40040}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40040}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40040}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_40040}" != "_-h" ]; echo $?) || $([ "_${param_40040}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3788_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_750="--cursor="
            slice__24_v0 "${param_40040}" "${#__length_750}" 0
            cursor_40036="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_751="--path="
            slice__24_v0 "${param_40040}" "${#__length_751}" 0
            start_path_40037="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_40040}" != "_-a" ]; echo $?) || $([ "_${param_40040}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_40038=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_752="--page-size="
            slice__24_v0 "${param_40040}" "${#__length_752}" 0
            local value_40121="${ret_slice24_v0}"
            parse_int__13_v0 "${value_40121}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__3020_v0 "ERROR: Invalid page-size value: ""${value_40121}""
" 31
                exit 1
            fi
            page_size_40039="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_40037="${param_40040}"
        fi
    done
    xyl_file__3688_v0 "${start_path_40037}" "${cursor_40036}" "${show_hidden_40038}" "${page_size_40039}"
    ret_execute_file3846_v0="${ret_xyl_file3688_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_211="0.1.0"
__AMBER_VERSION_212="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__3848_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__162_v0 "Error: " 91
        local array_753=("")
        eprintf__161_v0 "bc is not installed. Please install bc to use xylitol.
" array_753[@]
        local array_754=("")
        eprintf__161_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_754[@]
        local array_755=("")
        eprintf__161_v0 "  For Fedora: sudo dnf install bc
" array_755[@]
        local array_756=("")
        eprintf__161_v0 "  For Arch Linux: sudo pacman -S bc
" array_756[@]
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

typeset -r args_213=("$0" "$@")
trap_cleanup__3849_v0 
check_prerequirements__3848_v0 
ret_check_prerequirements3848_v0__33_12="${ret_check_prerequirements3848_v0}"
if [ "$(( ! ret_check_prerequirements3848_v0__33_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_758=("${args_213[@]}")
if [ "$(( ${#__length_758[@]} < 2 ))" != 0 ]; then
    print_help__555_v0 
    exit 0
fi
command_1601="${args_213[1]?"Index out of bounds (at src/main.ab:42:26)"}"
if [ "$(( $(( $([ "_${command_1601}" != "_help" ]; echo $?) || $([ "_${command_1601}" != "_--help" ]; echo $?) )) || $([ "_${command_1601}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__555_v0 
elif [ "$([ "_${command_1601}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1101_v0 args_213[@]
    ret_execute_input1101_v0__49_18="${ret_execute_input1101_v0}"
    printf '%s\n' "${ret_execute_input1101_v0__49_18}"
elif [ "$([ "_${command_1601}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1770_v0 args_213[@]
    ret_execute_choose1770_v0__52_18="${ret_execute_choose1770_v0}"
    printf '%s\n' "${ret_execute_choose1770_v0__52_18}"
elif [ "$([ "_${command_1601}" != "_filter" ]; echo $?)" != 0 ]; then
    execute_filter__2321_v0 args_213[@]
    ret_execute_filter2321_v0__55_18="${ret_execute_filter2321_v0}"
    printf '%s\n' "${ret_execute_filter2321_v0__55_18}"
elif [ "$([ "_${command_1601}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2901_v0 args_213[@]
    result_29707="${ret_execute_confirm2901_v0}"
    if [ "$([ "_${result_29707}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1601}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3846_v0 args_213[@]
    ret_execute_file3846_v0__65_18="${ret_execute_file3846_v0}"
    printf '%s\n' "${ret_execute_file3846_v0__65_18}"
elif [ "$(( $(( $([ "_${command_1601}" != "_version" ]; echo $?) || $([ "_${command_1601}" != "_--version" ]; echo $?) )) || $([ "_${command_1601}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__263_v0 "xylitol.sh"
    ret_colored_primary263_v0__68_20="${ret_colored_primary263_v0}"
    array_759=()
    printf__128_v0 "${ret_colored_primary263_v0__68_20}" array_759[@]
    array_760=()
    printf__128_v0 " version: " array_760[@]
    colored_accent__265_v0 "${__VERSION_211}"
    ret_colored_accent265_v0__70_20="${ret_colored_accent265_v0}"
    array_761=()
    printf__128_v0 "${ret_colored_accent265_v0__70_20}" array_761[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_212}" 90
else
    print_help__555_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1601}""'" 91
fi
