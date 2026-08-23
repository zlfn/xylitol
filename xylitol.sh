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
    local list_18125=("${!1}")
    local delimiter_18126="${2}"
    local command_1
    command_1="$(IFS="${delimiter_18126}" ; printf "%s
" "${list_18125[*]}")"
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
    local text_3196="${1}"
    local prefix_3197="${2}"
    [[ "${text_3196}" == "${prefix_3197}"* ]]
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
    local text_29668="${1}"
    local pad_29669="${2}"
    local length_29670="${3}"
    local __length_3="${text_29668}"
    if [ "$(( length_29670 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_29668}"
        return 0
    fi
    local __length_4="${text_29668}"
    local pad_len_29671="$(( length_29670 - ${#__length_4} ))"
    local padding_29672=""
    printf -v padding_29672 "%${pad_len_29671}s" ""
    __status=$?
    padding_29672="${padding_29672// /${pad_29669}}"
    __status=$?
    ret_lpad27_v0="${padding_29672}""${text_29668}"
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
    local text_29662="${1}"
    local pad_29663="${2}"
    local length_29664="${3}"
    local __length_7="${text_29662}"
    local text_length_29665="${#__length_7}"
    if [ "$(( length_29664 <= text_length_29665 ))" != 0 ]; then
        ret_cpad29_v0="${text_29662}"
        return 0
    fi
    local total_padding_29666="$(( length_29664 - text_length_29665 ))"
    local left_padding_length_29667="$(( text_length_29665 + $(( total_padding_29666 / 2 )) ))"
    lpad__27_v0 "${text_29662}" "${pad_29663}" "${left_padding_length_29667}"
    local left_padded_29673="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_29673}" "${pad_29663}" "${length_29664}"
    local center_padded_29674="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_29674}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_40327="${1}"
    [ -d "${path_40327}" ]
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
    local message_40330="${1}"
    local color_40331="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_40330}")
    printf__128_v1 "\\x1b[${color_40331}m%s\\x1b[0m" array_12[@]
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
    local number_3282="${1}"
    local command_76
    command_76="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_3282}")"
    __status=$?
    ret_math_floor636_v0="${command_76}"
    return 0
}

# math_ceil(number: Int)
math_ceil__637_v0() {
    local number_3281="${1}"
    math_floor__636_v0 "${number_3281}"
    local ret_math_floor636_v0__52_12="${ret_math_floor636_v0}"
    ret_math_ceil637_v0="$(( ret_math_floor636_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__645_v0() {
    local command_77
    command_77="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3276="${command_77}"
    ret_get_char645_v0="${char_3276}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__648_v0() {
    local format_3248="${1}"
    local args_3249=("${!2}")
    args_3249=("${format_3248}" "${args_3249[@]}")
    __status=$?
    printf "${args_3249[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__649_v0() {
    local message_3274="${1}"
    local color_3275="${2}"
    # Prints an error message with a specified color.
    local array_78=("${message_3274}")
    eprintf__648_v0 "\\x1b[${color_3275}m%s\\x1b[0m" array_78[@]
}

# eprintf(format: Text, args: [Text])
eprintf__664_v0() {
    local format_3252="${1}"
    local args_3253=("${!2}")
    args_3253=("${format_3252}" "${args_3253[@]}")
    __status=$?
    printf "${args_3253[@]}" >&2
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
        local disabled_3142
        disabled_3142="$([ "_${command_79}" != "_No" ]; echo $?)"
        local command_80
        command_80="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3143
        found_3143="$(( $(( ! disabled_3142 )) && $([ "_${command_80}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_3143}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available671_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__672_v0() {
    local text_3141="${1}"
    perl_available__671_v0 
    local ret_perl_available671_v0__19_12="${ret_perl_available671_v0}"
    if [ "$(( ! ret_perl_available671_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return 1
    fi
    local command_81
    command_81="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3141}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return "${__status}"
    fi
    local width_str_3144="${command_81}"
    parse_int__13_v0 "${width_str_3144}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width672_v0=''
        return "${__status}"
    fi
    local width_3145="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width672_v0="${width_3145}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__677_v0() {
    local text_3131="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_82
    command_82="$([[ "${text_3131}" == *$'\x1b'* || "${text_3131}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3132="${command_82}"
    ret_has_ansi_escape677_v0="$([ "_${has_escape_3132}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__679_v0() {
    local text_3137="${1}"
    local command_83
    command_83="$(printf "%s" "${text_3137}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi679_v0="${command_83}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__680_v0() {
    local text_3139="${1}"
    local command_84
    command_84="$(printf "%s" "${text_3139}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3140="${command_84}"
    ret_is_all_ascii680_v0="$([ "_${result_3140}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__681_v0() {
    local text_3134="${1}"
    local command_85
    command_85="$(LC_ALL=C; __t="${text_3134}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3135="${command_85}"
    parse_int__13_v0 "${measured_3135}"
    __status=$?
    ret_plain_len681_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__682_v0() {
    local text_3133="${1}"
    plain_len__681_v0 "${text_3133}"
    local plain_3136="${ret_plain_len681_v0}"
    if [ "$(( plain_3136 >= 0 ))" != 0 ]; then
        ret_get_visible_len682_v0="${plain_3136}"
        return 0
    fi
    strip_ansi__679_v0 "${text_3133}"
    local stripped_3138="${ret_strip_ansi679_v0}"
    is_all_ascii__680_v0 "${stripped_3138}"
    local ret_is_all_ascii680_v0__46_12="${ret_is_all_ascii680_v0}"
    if [ "$(( ! ret_is_all_ascii680_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__672_v0 "${stripped_3138}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_86="${stripped_3138}"
            ret_get_visible_len682_v0="${#__length_86}"
            return 0
        fi
        ret_get_visible_len682_v0="${ret_perl_get_cjk_width672_v0}"
        return 0
    fi
    local __length_87="${stripped_3138}"
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
    local count_3206="${command_89}"
    parse_int__13_v0 "${count_3206}"
    __status=$?
    ret_stty_count688_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__689_v0() {
    stty_count__688_v0 
    local count_num_3207="${ret_stty_count688_v0}"
    if [ "$(( count_num_3207 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_3207="$(( count_num_3207 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3207}
    __status=$?
}

# stty_unlock()
stty_unlock__690_v0() {
    stty_count__688_v0 
    local count_num_3279="${ret_stty_count688_v0}"
    if [ "$(( count_num_3279 > 0 ))" != 0 ]; then
        count_num_3279="$(( count_num_3279 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3279}
        __status=$?
        if [ "$(( count_num_3279 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__691_v0() {
    local size_3122="${1}"
    if [ "$([ "_${size_3122}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size691_v0=0
        return 0
    fi
    split__4_v0 "${size_3122}" " "
    local parts_3123=("${ret_split4_v0[@]}")
    local __length_90=("${parts_3123[@]}")
    if [ "$(( ${#__length_90[@]} != 2 ))" != 0 ]; then
        ret_store_term_size691_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3123[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3123[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
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
    local size_3125="${command_92}"
    store_term_size__691_v0 "${size_3125}"
    ret_query_term_size692_v0="${ret_store_term_size691_v0}"
    return 0
}

# stty_term_size()
stty_term_size__693_v0() {
    local command_93
    command_93="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3121="${command_93}"
    store_term_size__691_v0 "${size_3121}"
    ret_stty_term_size693_v0="${ret_store_term_size691_v0}"
    return 0
}

# get_term_size()
get_term_size__694_v0() {
    stty_term_size__693_v0 
    local detected_3124="${ret_stty_term_size693_v0}"
    if [ "$(( ! detected_3124 ))" != 0 ]; then
        query_term_size__692_v0 
        detected_3124="${ret_query_term_size692_v0}"
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
    local cnt_3277="${1}"
    if [ "$(( cnt_3277 > 0 ))" != 0 ]; then
        local array_94=("")
        eprintf__664_v0 "\\x1b[${cnt_3277}D\\x1b[K" array_94[@]
    fi
}

# remove_line(cnt: Int)
remove_line__699_v0() {
    local cnt_3285="${1}"
    if [ "$(( cnt_3285 > 0 ))" != 0 ]; then
        local sequence_3286=""
        local __range_start_3287=0
        local __range_end_3287="${cnt_3285}"
        local __dir_3287=$(( ${__range_start_3287} <= ${__range_end_3287} ? 1 : -1 ))
        for (( ____3287=${__range_start_3287}; ____3287 * ${__dir_3287} < ${__range_end_3287} * ${__dir_3287}; ____3287+=${__dir_3287} )); do
            sequence_3286+="\\x1b[2K\\x1b[1A"
done
        local array_95=("")
        eprintf__664_v0 "${sequence_3286}" array_95[@]
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
    local cnt_3250="${1}"
    local __range_start_3251=0
    local __range_end_3251="${cnt_3250}"
    local __dir_3251=$(( ${__range_start_3251} <= ${__range_end_3251} ? 1 : -1 ))
    for (( ____3251=${__range_start_3251}; ____3251 * ${__dir_3251} < ${__range_end_3251} * ${__dir_3251}; ____3251+=${__dir_3251} )); do
        local array_98=("")
        eprintf__664_v0 "
" array_98[@]
done
}

# go_up(cnt: Int)
go_up__703_v0() {
    local cnt_3271="${1}"
    local array_99=("")
    eprintf__664_v0 "\\x1b[${cnt_3271}A" array_99[@]
}

# go_down(cnt: Int)
go_down__704_v0() {
    local cnt_3284="${1}"
    local array_100=("")
    eprintf__664_v0 "\\x1b[${cnt_3284}B" array_100[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__708_v0() {
    local pieces_3120=("${!1}")
    term_width__696_v0 
    local width_3126="${ret_term_width696_v0}"
    local line_3127=""
    local line_len_3128=0
    for piece_3129 in "${pieces_3120[@]}"; do
        local __length_103="${piece_3129}"
        local piece_len_3130="${#__length_103}"
        has_ansi_escape__677_v0 "${piece_3129}"
        local ret_has_ansi_escape677_v0__186_12="${ret_has_ansi_escape677_v0}"
        if [ "${ret_has_ansi_escape677_v0__186_12}" != 0 ]; then
            get_visible_len__682_v0 "${piece_3129}"
            piece_len_3130="${ret_get_visible_len682_v0}"
        fi
        if [ "$([ "_${line_3127}" != "_" ]; echo $?)" != 0 ]; then
            line_3127="${piece_3129}"
            line_len_3128="${piece_len_3130}"
        elif [ "$(( $(( $(( line_len_3128 + 1 )) + piece_len_3130 )) > width_3126 ))" != 0 ]; then
            local array_104=()
            printf__128_v0 "${line_3127}""
" array_104[@]
            line_3127="${piece_3129}"
            line_len_3128="${piece_len_3130}"
        else
            line_3127+=" ""${piece_3129}"
            line_len_3128="$(( line_len_3128 + $(( 1 + piece_len_3130 )) ))"
        fi
    done
    if [ "$([ "_${line_3127}" == "_" ]; echo $?)" != 0 ]; then
        local array_105=()
        printf__128_v0 "${line_3127}""
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
    local config_3158="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_3158}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor745_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__746_v0() {
    local message_3153="${1}"
    local r_3154="${2}"
    local g_3155="${3}"
    local b_3156="${4}"
    local fallback_3157="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb746_v0="\\x1b[38;2;${r_3154};${g_3155};${b_3156}m""${message_3153}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__745_v0 
        local ret_get_supports_truecolor745_v0__45_17="${ret_get_supports_truecolor745_v0}"
        if [ "${ret_get_supports_truecolor745_v0__45_17}" != 0 ]; then
            ret_colored_rgb746_v0="\\x1b[38;2;${r_3154};${g_3155};${b_3156}m""${message_3153}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_3157 == 0 ))" != 0 ]; then
            ret_colored_rgb746_v0="${message_3153}"
            return 0
        else
            ret_colored_rgb746_v0="\\x1b[${fallback_3157}m""${message_3153}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_3157 == 0 ))" != 0 ]; then
            ret_colored_rgb746_v0="${message_3153}"
            return 0
        fi
        ret_colored_rgb746_v0="\\x1b[${fallback_3157}m""${message_3153}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__748_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_3147="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_3147}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_3147}" ";"
            local parts_3148=("${ret_split4_v0[@]}")
            local __length_109=("${parts_3148[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3148[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3148[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_3149="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_3149}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_3149}" ";"
            local parts_3150=("${ret_split4_v0[@]}")
            local __length_111=("${parts_3150[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3150[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3150[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3150[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3150[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_3151="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_3151}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_3151}" ";"
            local parts_3152=("${ret_split4_v0[@]}")
            local __length_113=("${parts_3152[@]}")
            if [ "$(( ${#__length_113[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3152[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3152[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3152[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors748_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3152[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
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
    local message_3146="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__749_v0 
    fi
    colored_rgb__746_v0 "${message_3146}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary750_v0="${ret_colored_rgb746_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__751_v0() {
    local message_3160="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__749_v0 
    fi
    colored_rgb__746_v0 "${message_3160}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
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
        local disabled_3220
        disabled_3220="$([ "_${command_115}" != "_No" ]; echo $?)"
        local command_116
        command_116="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3221
        found_3221="$(( $(( ! disabled_3220 )) && $([ "_${command_116}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3221}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available768_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__769_v0() {
    local text_3219="${1}"
    perl_available__768_v0 
    local ret_perl_available768_v0__19_12="${ret_perl_available768_v0}"
    if [ "$(( ! ret_perl_available768_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return 1
    fi
    local command_117
    command_117="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3219}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return "${__status}"
    fi
    local width_str_3222="${command_117}"
    parse_int__13_v0 "${width_str_3222}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width769_v0=''
        return "${__status}"
    fi
    local width_3223="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width769_v0="${width_3223}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__770_v0() {
    local text_3230="${1}"
    local max_width_3231="${2}"
    perl_available__768_v0 
    local ret_perl_available768_v0__30_12="${ret_perl_available768_v0}"
    if [ "$(( ! ret_perl_available768_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk770_v0=''
        return 1
    fi
    local command_118
    command_118="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3230}" ${max_width_3231} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk770_v0=''
        return "${__status}"
    fi
    local result_3232="${command_118}"
    ret_perl_truncate_cjk770_v0="${result_3232}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__774_v0() {
    local text_3198="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_119
    command_119="$([[ "${text_3198}" == *$'\x1b'* || "${text_3198}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3199="${command_119}"
    ret_has_ansi_escape774_v0="$([ "_${has_escape_3199}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__775_v0() {
    local text_3200="${1}"
    local command_120
    command_120="$(printf '%s' "${text_3200}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi775_v0="${command_120}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__776_v0() {
    local text_3215="${1}"
    local command_121
    command_121="$(printf "%s" "${text_3215}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi776_v0="${command_121}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__777_v0() {
    local text_3217="${1}"
    local command_122
    command_122="$(printf "%s" "${text_3217}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3218="${command_122}"
    ret_is_all_ascii777_v0="$([ "_${result_3218}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__778_v0() {
    local text_3212="${1}"
    local command_123
    command_123="$(LC_ALL=C; __t="${text_3212}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3213="${command_123}"
    parse_int__13_v0 "${measured_3213}"
    __status=$?
    ret_plain_len778_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__779_v0() {
    local text_3211="${1}"
    plain_len__778_v0 "${text_3211}"
    local plain_3214="${ret_plain_len778_v0}"
    if [ "$(( plain_3214 >= 0 ))" != 0 ]; then
        ret_get_visible_len779_v0="${plain_3214}"
        return 0
    fi
    strip_ansi__776_v0 "${text_3211}"
    local stripped_3216="${ret_strip_ansi776_v0}"
    is_all_ascii__777_v0 "${stripped_3216}"
    local ret_is_all_ascii777_v0__46_12="${ret_is_all_ascii777_v0}"
    if [ "$(( ! ret_is_all_ascii777_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__769_v0 "${stripped_3216}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_124="${stripped_3216}"
            ret_get_visible_len779_v0="${#__length_124}"
            return 0
        fi
        ret_get_visible_len779_v0="${ret_perl_get_cjk_width769_v0}"
        return 0
    fi
    local __length_125="${stripped_3216}"
    ret_get_visible_len779_v0="${#__length_125}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__780_v0() {
    local text_3227="${1}"
    local max_width_3228="${2}"
    get_visible_len__779_v0 "${text_3227}"
    local visible_len_3229="${ret_get_visible_len779_v0}"
    if [ "$(( visible_len_3229 <= max_width_3228 ))" != 0 ]; then
        ret_truncate_text780_v0="${text_3227}"
        return 0
    fi
    is_all_ascii__777_v0 "${text_3227}"
    local ret_is_all_ascii777_v0__61_12="${ret_is_all_ascii777_v0}"
    if [ "$(( ! ret_is_all_ascii777_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__770_v0 "${text_3227}" "${max_width_3228}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3227}" | cut -c1-${max_width_3228}
            __status=$?
        fi
        ret_truncate_text780_v0="${ret_perl_truncate_cjk770_v0}"
        return 0
    fi
    local command_126
    command_126="$(printf "%s" "${text_3227}" | cut -c1-${max_width_3228})"
    __status=$?
    ret_truncate_text780_v0="${command_126}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__781_v0() {
    local text_3225="${1}"
    local max_width_3226="${2}"
    has_ansi_escape__774_v0 "${text_3225}"
    local ret_has_ansi_escape774_v0__73_12="${ret_has_ansi_escape774_v0}"
    if [ "$(( ! ret_has_ansi_escape774_v0__73_12 ))" != 0 ]; then
        truncate_text__780_v0 "${text_3225}" "${max_width_3226}"
        ret_truncate_ansi781_v0="${ret_truncate_text780_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_127
    command_127="$([[ "${text_3225}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3233="${command_127}"
    # Replace \x1b[ with newline, then split
    local command_128
    command_128="$(t="${text_3225}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3234="${command_128}"
    split__4_v0 "${replaced_3234}" "
"
    local parts_3235=("${ret_split4_v0[@]}")
    local result_3236=""
    local remaining_width_3237="${max_width_3226}"
    local __range_start_3238=0
    local __length_129=("${parts_3235[@]}")
    local __range_end_3238="${#__length_129[@]}"
    local __dir_3238=$(( ${__range_start_3238} <= ${__range_end_3238} ? 1 : -1 ))
    for (( idx_3238=${__range_start_3238}; idx_3238 * ${__dir_3238} < ${__range_end_3238} * ${__dir_3238}; idx_3238+=${__dir_3238} )); do
        local part_3239="${parts_3235[${idx_3238}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3238 == 0 )) && $([ "_${starts_with_ansi_3233}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3239}" == "_" ]; echo $?) && $(( remaining_width_3237 > 0 )) ))" != 0 ]; then
                truncate_text__780_v0 "${part_3239}" "${remaining_width_3237}"
                local ret_truncate_text780_v0__95_35="${ret_truncate_text780_v0}"
                local truncated_3240="${ret_truncate_text780_v0__95_35}"
                result_3236+="${truncated_3240}"
                get_visible_len__779_v0 "${truncated_3240}"
                local ret_get_visible_len779_v0__97_36="${ret_get_visible_len779_v0}"
                remaining_width_3237="$(( remaining_width_3237 - ret_get_visible_len779_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_130
            command_130="$(__p="${part_3239}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3241="${command_130}"
            if [ "$([ "_${m_idx_3241}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_131
                command_131="$(__p="${part_3239}"; printf "%s" "${__p:0:${m_idx_3241}}")"
                __status=$?
                local ansi_params_3242="${command_131}"
                result_3236+="\\x1b[""${ansi_params_3242}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3241}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_3243="${ret_parse_int13_v0__108_41}"
                local text_start_3244="$(( m_idx_num_3243 + 1 ))"
                local command_132
                command_132="$(__p="${part_3239}"; printf "%s" "${__p:${text_start_3244}}")"
                __status=$?
                local text_part_3245="${command_132}"
                if [ "$(( $([ "_${text_part_3245}" == "_" ]; echo $?) && $(( remaining_width_3237 > 0 )) ))" != 0 ]; then
                    truncate_text__780_v0 "${text_part_3245}" "${remaining_width_3237}"
                    local ret_truncate_text780_v0__112_39="${ret_truncate_text780_v0}"
                    local truncated_3246="${ret_truncate_text780_v0__112_39}"
                    result_3236+="${truncated_3246}"
                    get_visible_len__779_v0 "${truncated_3246}"
                    local ret_get_visible_len779_v0__114_40="${ret_get_visible_len779_v0}"
                    remaining_width_3237="$(( remaining_width_3237 - ret_get_visible_len779_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3239}" == "_" ]; echo $?) && $(( remaining_width_3237 > 0 )) ))" != 0 ]; then
                    truncate_text__780_v0 "${part_3239}" "${remaining_width_3237}"
                    local ret_truncate_text780_v0__119_39="${ret_truncate_text780_v0}"
                    local truncated_3247="${ret_truncate_text780_v0__119_39}"
                    result_3236+="${truncated_3247}"
                    get_visible_len__779_v0 "${truncated_3247}"
                    local ret_get_visible_len779_v0__121_40="${ret_get_visible_len779_v0}"
                    remaining_width_3237="$(( remaining_width_3237 - ret_get_visible_len779_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi781_v0="${result_3236}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__782_v0() {
    local text_3209="${1}"
    local max_width_3210="${2}"
    get_visible_len__779_v0 "${text_3209}"
    local visible_len_3224="${ret_get_visible_len779_v0}"
    if [ "$(( visible_len_3224 <= max_width_3210 ))" != 0 ]; then
        ret_cutoff_text782_v0="${text_3209}"
        return 0
    fi
    truncate_ansi__781_v0 "${text_3209}" "$(( max_width_3210 - 3 ))"
    local ret_truncate_ansi781_v0__137_12="${ret_truncate_ansi781_v0}"
    ret_cutoff_text782_v0="${ret_truncate_ansi781_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__803_v0() {
    local format_3262="${1}"
    local args_3263=("${!2}")
    args_3263=("${format_3262}" "${args_3263[@]}")
    __status=$?
    printf "${args_3263[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__804_v0() {
    local message_3260="${1}"
    local color_3261="${2}"
    # Prints an error message with a specified color.
    local array_133=("${message_3260}")
    eprintf__803_v0 "\\x1b[${color_3261}m%s\\x1b[0m" array_133[@]
}

# colored(message: Text, color: Int)
colored__805_v0() {
    local message_3194="${1}"
    local color_3195="${2}"
    # Returns a text wrapped in color codes.
    ret_colored805_v0="\\x1b[${color_3195}m""${message_3194}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__809_v0() {
    local items_3254=("${!1}")
    local total_len_3255="${2}"
    local term_width_3256="${3}"
    local separator_3257=" • "
    local separator_len_3258=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3255 <= term_width_3256 ))" != 0 ]; then
        local iter_3259=0
        while :
        do
            local __length_134=("${items_3254[@]}")
            if [ "$(( iter_3259 >= ${#__length_134[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3259 > 0 ))" != 0 ]; then
                eprintf_colored__804_v0 "${separator_3257}" 90
            fi
            colored__805_v0 "${items_3254[$(( iter_3259 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored805_v0__23_41="${ret_colored805_v0}"
            local array_135=("")
            eprintf__803_v0 "${items_3254[${iter_3259}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored805_v0__23_41}" array_135[@]
            iter_3259="$(( iter_3259 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3264=0
        local first_3265=1
        local iter_3266=0
        while :
        do
            local __length_136=("${items_3254[@]}")
            if [ "$(( iter_3266 >= ${#__length_136[@]} ))" != 0 ]; then
                break
            fi
            local key_3267="${items_3254[${iter_3266}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3268="${items_3254[$(( iter_3266 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_137="${key_3267}"
            local __length_138="${action_3268}"
            local part_len_3269="$(( $(( ${#__length_137} + 1 )) + ${#__length_138} ))"
            local needed_3270="${part_len_3269}"
            if [ "$(( ! first_3265 ))" != 0 ]; then
                needed_3270="$(( needed_3270 + separator_len_3258 ))"
            fi
            if [ "$(( $(( current_len_3264 + needed_3270 )) > term_width_3256 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3265 ))" != 0 ]; then
                eprintf_colored__804_v0 "${separator_3257}" 90
            fi
            colored__805_v0 "${action_3268}" 2
            local ret_colored805_v0__51_33="${ret_colored805_v0}"
            local array_139=("")
            eprintf__803_v0 "${key_3267}"" ""${ret_colored805_v0__51_33}" array_139[@]
            current_len_3264="$(( current_len_3264 + needed_3270 ))"
            first_3265=0
            iter_3266="$(( iter_3266 + 2 ))"
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
    local size_3173="${1}"
    if [ "$([ "_${size_3173}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size846_v0=0
        return 0
    fi
    split__4_v0 "${size_3173}" " "
    local parts_3174=("${ret_split4_v0[@]}")
    local __length_141=("${parts_3174[@]}")
    if [ "$(( ${#__length_141[@]} != 2 ))" != 0 ]; then
        ret_store_term_size846_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3174[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3174[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
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
    local size_3176="${command_143}"
    store_term_size__846_v0 "${size_3176}"
    ret_query_term_size847_v0="${ret_store_term_size846_v0}"
    return 0
}

# stty_term_size()
stty_term_size__848_v0() {
    local command_144
    command_144="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3172="${command_144}"
    store_term_size__846_v0 "${size_3172}"
    ret_stty_term_size848_v0="${ret_store_term_size846_v0}"
    return 0
}

# get_term_size()
get_term_size__849_v0() {
    stty_term_size__848_v0 
    local detected_3175="${ret_stty_term_size848_v0}"
    if [ "$(( ! detected_3175 ))" != 0 ]; then
        query_term_size__847_v0 
        detected_3175="${ret_query_term_size847_v0}"
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
    local pending_3191="${1}"
    local line_3192="${2}"
    local note_at_3193="${3}"
    if [ "$(( note_at_3193 < 0 ))" != 0 ]; then
        local array_146=()
        printf__128_v0 "${pending_3191}""${line_3192}""
" array_146[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3193 == 0 ))" != 0 ]; then
        colored__805_v0 "${line_3192}" 90
        local ret_colored805_v0__12_40="${ret_colored805_v0}"
        local array_147=()
        printf__128_v0 "${pending_3191}""${ret_colored805_v0__12_40}""
" array_147[@]
    else
        slice__24_v0 "${line_3192}" 0 "${note_at_3193}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3192}" "${note_at_3193}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__805_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored805_v0__13_58="${ret_colored805_v0}"
        local array_148=()
        printf__128_v0 "${pending_3191}""${ret_slice24_v0__13_32}""${ret_colored805_v0__13_58}""
" array_148[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__885_v0() {
    local names_3164=("${!1}")
    local texts_3165=("${!2}")
    local notes_3166=("${!3}")
    local min_name_width_3167="${4}"
    local __length_149=("${names_3164[@]}")
    local count_3168="${#__length_149[@]}"
    local name_width_3169="${min_name_width_3167}"
    local __range_start_3170=0
    local __range_end_3170="${count_3168}"
    local __dir_3170=$(( ${__range_start_3170} <= ${__range_end_3170} ? 1 : -1 ))
    for (( i_3170=${__range_start_3170}; i_3170 * ${__dir_3170} < ${__range_end_3170} * ${__dir_3170}; i_3170+=${__dir_3170} )); do
        local __length_150="${names_3164[${i_3170}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_3171="${#__length_150}"
        if [ "$(( width_3171 > name_width_3169 ))" != 0 ]; then
            name_width_3169="${width_3171}"
        fi
done
    term_width__851_v0 
    local width_3177="${ret_term_width851_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_3178="$(( name_width_3169 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_3179="$(( $(( width_3177 - indent_3178 )) < 24 ))"
    if [ "${stacked_3179}" != 0 ]; then
        indent_3178=6
    fi
    local avail_3180="$(( width_3177 - indent_3178 ))"
    rpad__28_v0 "" " " "${indent_3178}"
    local blank_3181="${ret_rpad28_v0}"
    local __range_start_3182=0
    local __range_end_3182="${count_3168}"
    local __dir_3182=$(( ${__range_start_3182} <= ${__range_end_3182} ? 1 : -1 ))
    for (( i_3182=${__range_start_3182}; i_3182 * ${__dir_3182} < ${__range_end_3182} * ${__dir_3182}; i_3182+=${__dir_3182} )); do
        local pending_3183="${blank_3181}"
        if [ "${stacked_3179}" != 0 ]; then
            local array_151=()
            printf__128_v0 "  ""${names_3164[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_151[@]
        else
            rpad__28_v0 "  ""${names_3164[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_3178}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_3183="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_3165[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_3184=("${ret_split4_v0__52_21[@]}")
        local __length_152=("${words_3184[@]}")
        local note_start_3185="${#__length_152[@]}"
        if [ "$([ "_${notes_3166[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_153="${notes_3166[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_153} > avail_3180 ))" != 0 ]; then
                split__4_v0 "${notes_3166[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_3184+=("${ret_split4_v0__58_26[@]}")
            else
                local array_154=("${notes_3166[${i_3182}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_3184+=("${array_154[@]}")
            fi
        fi
        local line_3186=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_3187=-1
        local __range_start_3188=0
        local __length_155=("${words_3184[@]}")
        local __range_end_3188="${#__length_155[@]}"
        local __dir_3188=$(( ${__range_start_3188} <= ${__range_end_3188} ? 1 : -1 ))
        for (( j_3188=${__range_start_3188}; j_3188 * ${__dir_3188} < ${__range_end_3188} * ${__dir_3188}; j_3188+=${__dir_3188} )); do
            local word_3189="${words_3184[${j_3188}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_3190
            candidate_3190="$(if [ "$([ "_${line_3186}" != "_" ]; echo $?)" != 0 ]; then echo "${word_3189}"; else echo "${line_3186}"" ""${word_3189}"; fi)"
            local __length_156="${candidate_3190}"
            if [ "$(( $(( ${#__length_156} > avail_3180 )) && $([ "_${line_3186}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__884_v0 "${pending_3183}" "${line_3186}" "${note_at_3187}"
                pending_3183="${blank_3181}"
                line_3186="${word_3189}"
                note_at_3187="$(if [ "$(( j_3188 >= note_start_3185 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_3188 >= note_start_3185 )) && $(( note_at_3187 < 0 )) ))" != 0 ]; then
                    local __length_157="${candidate_3190}"
                    local __length_158="${word_3189}"
                    note_at_3187="$(( ${#__length_157} - ${#__length_158} ))"
                fi
                line_3186="${candidate_3190}"
            fi
done
        print_help_line__884_v0 "${pending_3183}" "${line_3186}" "${note_at_3187}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__943_v0() {
    local prompt_3202="${1}"
    local placeholder_3203="${2}"
    local header_3204="${3}"
    local password_3205="${4}"
    stty_lock__689_v0 
    term_width__696_v0 
    local term_width_3208="${ret_term_width696_v0}"
    if [ "$([ "_${header_3204}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__782_v0 "${header_3204}" "${term_width_3208}"
        local ret_cutoff_text782_v0__25_17="${ret_cutoff_text782_v0}"
        local array_159=("")
        eprintf__648_v0 "${ret_cutoff_text782_v0__25_17}""
" array_159[@]
    fi
    new_line__702_v0 2
    # "enter submit" = 12
    local array_160=("enter" "submit")
    render_tooltip__809_v0 array_160[@] 12 "${term_width_3208}"
    go_up__703_v0 2
    local array_161=("")
    eprintf__648_v0 "\\x1b[G" array_161[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_162
    command_162="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3272="${command_162}"
    local char_3273=""
    local array_163=("")
    eprintf__648_v0 "${prompt_3202}" array_163[@]
    if [ "$([ "_${can_preset_3272}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__649_v0 "${placeholder_3203}" 90
        get_char__645_v0 
        char_3273="${ret_get_char645_v0}"
        local __length_164="${placeholder_3203}"
        remove__698_v0 "$(( ${#__length_164} + 1 ))"
    fi
    local __length_165="${prompt_3202}"
    remove__698_v0 "${#__length_165}"
    local text_3278=""
    if [ "$(( ! password_3205 ))" != 0 ]; then
        stty_unlock__690_v0 
        local command_166
        command_166="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3273}" -p "${prompt_3202}" text < /dev/tty; else read -e -p "${prompt_3202}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3278="${command_166}"
    else
        stty_unlock__690_v0 
        local command_167
        command_167="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3273}" -p "${prompt_3202}" text < /dev/tty; else read -es -p "${prompt_3202}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3278="${command_167}"
    fi
    stty_lock__689_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__779_v0 "${prompt_3202}""${text_3278}"
    local input_display_len_3280="${ret_get_visible_len779_v0}"
    math_ceil__637_v0 "$(( input_display_len_3280 / term_width_3208 ))"
    local input_lines_3283="${ret_math_ceil637_v0}"
    if [ "$(( input_lines_3283 < 3 ))" != 0 ]; then
        go_down__704_v0 "$(( 2 - input_lines_3283 ))"
        remove_line__699_v0 2
        remove_current_line__700_v0 
    fi
    if [ "$(( input_lines_3283 >= 3 ))" != 0 ]; then
        remove_line__699_v0 "${input_lines_3283}"
    fi
    if [ "$([ "_${header_3204}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__699_v0 1
        remove_current_line__700_v0 
    fi
    stty_unlock__690_v0 
    ret_xyl_input943_v0="${text_3278}"
    return 0
}

# print_input_help()
print_input_help__1043_v0() {
    local usage_3119=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__708_v0 usage_3119[@]
    printf '%s\n' ""
    colored_primary__750_v0 "input"
    local ret_colored_primary750_v0__8_20="${ret_colored_primary750_v0}"
    local title_3159=("${ret_colored_primary750_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__708_v0 title_3159[@]
    printf '%s\n' ""
    colored_secondary__751_v0 "Flags:"
    local ret_colored_secondary751_v0__11_12="${ret_colored_secondary751_v0}"
    local array_170=()
    printf__128_v0 "${ret_colored_secondary751_v0__11_12}""
" array_170[@]
    local names_3161=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_3162=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_3163=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__885_v0 names_3161[@] texts_3162[@] notes_3163[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1101_v0() {
    local parameters_3113=("${!1}")
    local prompt_3114="> "
    local placeholder_3115="Type here..."
    local header_3116=""
    local password_3117=0
    for param_3118 in "${parameters_3113[@]}"; do
        if [ "$(( $([ "_${param_3118}" != "_-h" ]; echo $?) || $([ "_${param_3118}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1043_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_3118}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_176="--prompt="
            slice__24_v0 "${param_3118}" "${#__length_176}" 0
            prompt_3114="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3118}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_177="--placeholder="
            slice__24_v0 "${param_3118}" "${#__length_177}" 0
            placeholder_3115="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3118}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_178="--header="
            slice__24_v0 "${param_3118}" "${#__length_178}" 0
            header_3116="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_3118}" != "_--password" ]; echo $?)" != 0 ]; then
            password_3117=1
        fi
    done
    has_ansi_escape__774_v0 "${header_3116}"
    local ret_has_ansi_escape774_v0__31_44="${ret_has_ansi_escape774_v0}"
    escape_ansi__775_v0 "${header_3116}"
    local ret_escape_ansi775_v0__31_73="${ret_escape_ansi775_v0}"
    colored_primary__750_v0 "${header_3116}"
    local ret_colored_primary750_v0__31_111="${ret_colored_primary750_v0}"
    local display_header_3201
    display_header_3201="$(if [ "$(( $([ "_${header_3116}" != "_" ]; echo $?) || ret_has_ansi_escape774_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi775_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary750_v0__31_111}"; fi)"
    xyl_input__943_v0 "${prompt_3114}" "${placeholder_3115}" "${display_header_3201}" "${password_3117}"
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
    local format_17980="${1}"
    local args_17981=("${!2}")
    args_17981=("${format_17980}" "${args_17981[@]}")
    __status=$?
    printf "${args_17981[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1185_v0() {
    local message_17978="${1}"
    local color_17979="${2}"
    # Prints an error message with a specified color.
    local array_180=("${message_17978}")
    eprintf__1184_v0 "\\x1b[${color_17979}m%s\\x1b[0m" array_180[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1200_v0() {
    local format_18001="${1}"
    local args_18002=("${!2}")
    args_18002=("${format_18001}" "${args_18002[@]}")
    __status=$?
    printf "${args_18002[@]}" >&2
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
        local disabled_17933
        disabled_17933="$([ "_${command_181}" != "_No" ]; echo $?)"
        local command_182
        command_182="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_17934
        found_17934="$(( $(( ! disabled_17933 )) && $([ "_${command_182}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_17934}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1207_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1208_v0() {
    local text_17932="${1}"
    perl_available__1207_v0 
    local ret_perl_available1207_v0__19_12="${ret_perl_available1207_v0}"
    if [ "$(( ! ret_perl_available1207_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return 1
    fi
    local command_183
    command_183="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_17932}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return "${__status}"
    fi
    local width_str_17935="${command_183}"
    parse_int__13_v0 "${width_str_17935}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1208_v0=''
        return "${__status}"
    fi
    local width_17936="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1208_v0="${width_17936}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1213_v0() {
    local text_17922="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_184
    command_184="$([[ "${text_17922}" == *$'\x1b'* || "${text_17922}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17923="${command_184}"
    ret_has_ansi_escape1213_v0="$([ "_${has_escape_17923}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1215_v0() {
    local text_17928="${1}"
    local command_185
    command_185="$(printf "%s" "${text_17928}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1215_v0="${command_185}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1216_v0() {
    local text_17930="${1}"
    local command_186
    command_186="$(printf "%s" "${text_17930}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_17931="${command_186}"
    ret_is_all_ascii1216_v0="$([ "_${result_17931}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1217_v0() {
    local text_17925="${1}"
    local command_187
    command_187="$(LC_ALL=C; __t="${text_17925}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_17926="${command_187}"
    parse_int__13_v0 "${measured_17926}"
    __status=$?
    ret_plain_len1217_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1218_v0() {
    local text_17924="${1}"
    plain_len__1217_v0 "${text_17924}"
    local plain_17927="${ret_plain_len1217_v0}"
    if [ "$(( plain_17927 >= 0 ))" != 0 ]; then
        ret_get_visible_len1218_v0="${plain_17927}"
        return 0
    fi
    strip_ansi__1215_v0 "${text_17924}"
    local stripped_17929="${ret_strip_ansi1215_v0}"
    is_all_ascii__1216_v0 "${stripped_17929}"
    local ret_is_all_ascii1216_v0__46_12="${ret_is_all_ascii1216_v0}"
    if [ "$(( ! ret_is_all_ascii1216_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1208_v0 "${stripped_17929}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_188="${stripped_17929}"
            ret_get_visible_len1218_v0="${#__length_188}"
            return 0
        fi
        ret_get_visible_len1218_v0="${ret_perl_get_cjk_width1208_v0}"
        return 0
    fi
    local __length_189="${stripped_17929}"
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
    local count_17999="${command_191}"
    parse_int__13_v0 "${count_17999}"
    __status=$?
    ret_stty_count1224_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1225_v0() {
    stty_count__1224_v0 
    local count_num_18000="${ret_stty_count1224_v0}"
    if [ "$(( count_num_18000 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_18000="$(( count_num_18000 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18000}
    __status=$?
}

# stty_unlock()
stty_unlock__1226_v0() {
    stty_count__1224_v0 
    local count_num_18120="${ret_stty_count1224_v0}"
    if [ "$(( count_num_18120 > 0 ))" != 0 ]; then
        count_num_18120="$(( count_num_18120 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18120}
        __status=$?
        if [ "$(( count_num_18120 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1227_v0() {
    local size_17913="${1}"
    if [ "$([ "_${size_17913}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1227_v0=0
        return 0
    fi
    split__4_v0 "${size_17913}" " "
    local parts_17914=("${ret_split4_v0[@]}")
    local __length_192=("${parts_17914[@]}")
    if [ "$(( ${#__length_192[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1227_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17914[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17914[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
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
    local size_17916="${command_194}"
    store_term_size__1227_v0 "${size_17916}"
    ret_query_term_size1228_v0="${ret_store_term_size1227_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1229_v0() {
    local command_195
    command_195="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17912="${command_195}"
    store_term_size__1227_v0 "${size_17912}"
    ret_stty_term_size1229_v0="${ret_store_term_size1227_v0}"
    return 0
}

# get_term_size()
get_term_size__1230_v0() {
    stty_term_size__1229_v0 
    local detected_17915="${ret_stty_term_size1229_v0}"
    if [ "$(( ! detected_17915 ))" != 0 ]; then
        query_term_size__1228_v0 
        detected_17915="${ret_query_term_size1228_v0}"
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
    local cnt_18092="${1}"
    if [ "$(( cnt_18092 > 0 ))" != 0 ]; then
        local sequence_18093=""
        local __range_start_18094=0
        local __range_end_18094="${cnt_18092}"
        local __dir_18094=$(( ${__range_start_18094} <= ${__range_end_18094} ? 1 : -1 ))
        for (( ____18094=${__range_start_18094}; ____18094 * ${__dir_18094} < ${__range_end_18094} * ${__dir_18094}; ____18094+=${__dir_18094} )); do
            sequence_18093+="\\x1b[2K\\x1b[1A"
done
        local array_196=("")
        eprintf__1200_v0 "${sequence_18093}" array_196[@]
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
    local cnt_18083="${1}"
    printf '%*s' "${cnt_18083}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1238_v0() {
    local cnt_18047="${1}"
    local __range_start_18048=0
    local __range_end_18048="${cnt_18047}"
    local __dir_18048=$(( ${__range_start_18048} <= ${__range_end_18048} ? 1 : -1 ))
    for (( ____18048=${__range_start_18048}; ____18048 * ${__dir_18048} < ${__range_end_18048} * ${__dir_18048}; ____18048+=${__dir_18048} )); do
        local array_199=("")
        eprintf__1200_v0 "
" array_199[@]
done
}

# go_up(cnt: Int)
go_up__1239_v0() {
    local cnt_18066="${1}"
    local array_200=("")
    eprintf__1200_v0 "\\x1b[${cnt_18066}A" array_200[@]
}

# go_down(cnt: Int)
go_down__1240_v0() {
    local cnt_18119="${1}"
    local array_201=("")
    eprintf__1200_v0 "\\x1b[${cnt_18119}B" array_201[@]
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
    local pieces_17911=("${!1}")
    term_width__1232_v0 
    local width_17917="${ret_term_width1232_v0}"
    local line_17918=""
    local line_len_17919=0
    for piece_17920 in "${pieces_17911[@]}"; do
        local __length_206="${piece_17920}"
        local piece_len_17921="${#__length_206}"
        has_ansi_escape__1213_v0 "${piece_17920}"
        local ret_has_ansi_escape1213_v0__186_12="${ret_has_ansi_escape1213_v0}"
        if [ "${ret_has_ansi_escape1213_v0__186_12}" != 0 ]; then
            get_visible_len__1218_v0 "${piece_17920}"
            piece_len_17921="${ret_get_visible_len1218_v0}"
        fi
        if [ "$([ "_${line_17918}" != "_" ]; echo $?)" != 0 ]; then
            line_17918="${piece_17920}"
            line_len_17919="${piece_len_17921}"
        elif [ "$(( $(( $(( line_len_17919 + 1 )) + piece_len_17921 )) > width_17917 ))" != 0 ]; then
            local array_207=()
            printf__128_v0 "${line_17918}""
" array_207[@]
            line_17918="${piece_17920}"
            line_len_17919="${piece_len_17921}"
        else
            line_17918+=" ""${piece_17920}"
            line_len_17919="$(( line_len_17919 + $(( 1 + piece_len_17921 )) ))"
        fi
    done
    if [ "$([ "_${line_17918}" == "_" ]; echo $?)" != 0 ]; then
        local array_208=()
        printf__128_v0 "${line_17918}""
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
    local config_17901="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_17901}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1281_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1282_v0() {
    local message_17896="${1}"
    local r_17897="${2}"
    local g_17898="${3}"
    local b_17899="${4}"
    local fallback_17900="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1282_v0="\\x1b[38;2;${r_17897};${g_17898};${b_17899}m""${message_17896}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1281_v0 
        local ret_get_supports_truecolor1281_v0__45_17="${ret_get_supports_truecolor1281_v0}"
        if [ "${ret_get_supports_truecolor1281_v0__45_17}" != 0 ]; then
            ret_colored_rgb1282_v0="\\x1b[38;2;${r_17897};${g_17898};${b_17899}m""${message_17896}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_17900 == 0 ))" != 0 ]; then
            ret_colored_rgb1282_v0="${message_17896}"
            return 0
        else
            ret_colored_rgb1282_v0="\\x1b[${fallback_17900}m""${message_17896}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_17900 == 0 ))" != 0 ]; then
            ret_colored_rgb1282_v0="${message_17896}"
            return 0
        fi
        ret_colored_rgb1282_v0="\\x1b[${fallback_17900}m""${message_17896}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1284_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_17890="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_17890}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_17890}" ";"
            local parts_17891=("${ret_split4_v0[@]}")
            local __length_212=("${parts_17891[@]}")
            if [ "$(( ${#__length_212[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17891[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17891[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_17892="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_17892}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_17892}" ";"
            local parts_17893=("${ret_split4_v0[@]}")
            local __length_214=("${parts_17893[@]}")
            if [ "$(( ${#__length_214[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17893[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17893[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17893[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17893[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_17894="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_17894}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_17894}" ";"
            local parts_17895=("${ret_split4_v0[@]}")
            local __length_216=("${parts_17895[@]}")
            if [ "$(( ${#__length_216[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17895[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17895[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17895[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1284_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17895[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
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
    local message_17889="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1285_v0 
    fi
    colored_rgb__1282_v0 "${message_17889}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1286_v0="${ret_colored_rgb1282_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1287_v0() {
    local message_17938="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1285_v0 
    fi
    colored_rgb__1282_v0 "${message_17938}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
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
        local disabled_18016
        disabled_18016="$([ "_${command_218}" != "_No" ]; echo $?)"
        local command_219
        command_219="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18017
        found_18017="$(( $(( ! disabled_18016 )) && $([ "_${command_219}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_18017}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1304_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1305_v0() {
    local text_18015="${1}"
    perl_available__1304_v0 
    local ret_perl_available1304_v0__19_12="${ret_perl_available1304_v0}"
    if [ "$(( ! ret_perl_available1304_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return 1
    fi
    local command_220
    command_220="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18015}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return "${__status}"
    fi
    local width_str_18018="${command_220}"
    parse_int__13_v0 "${width_str_18018}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1305_v0=''
        return "${__status}"
    fi
    local width_18019="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1305_v0="${width_18019}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1306_v0() {
    local text_18026="${1}"
    local max_width_18027="${2}"
    perl_available__1304_v0 
    local ret_perl_available1304_v0__30_12="${ret_perl_available1304_v0}"
    if [ "$(( ! ret_perl_available1304_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1306_v0=''
        return 1
    fi
    local command_221
    command_221="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18026}" ${max_width_18027} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1306_v0=''
        return "${__status}"
    fi
    local result_18028="${command_221}"
    ret_perl_truncate_cjk1306_v0="${result_18028}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1310_v0() {
    local text_17983="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_222
    command_222="$([[ "${text_17983}" == *$'\x1b'* || "${text_17983}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17984="${command_222}"
    ret_has_ansi_escape1310_v0="$([ "_${has_escape_17984}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1311_v0() {
    local text_17985="${1}"
    local command_223
    command_223="$(printf '%s' "${text_17985}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1311_v0="${command_223}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1312_v0() {
    local text_18011="${1}"
    local command_224
    command_224="$(printf "%s" "${text_18011}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1312_v0="${command_224}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1313_v0() {
    local text_18013="${1}"
    local command_225
    command_225="$(printf "%s" "${text_18013}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18014="${command_225}"
    ret_is_all_ascii1313_v0="$([ "_${result_18014}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1314_v0() {
    local text_18008="${1}"
    local command_226
    command_226="$(LC_ALL=C; __t="${text_18008}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_18009="${command_226}"
    parse_int__13_v0 "${measured_18009}"
    __status=$?
    ret_plain_len1314_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1315_v0() {
    local text_18007="${1}"
    plain_len__1314_v0 "${text_18007}"
    local plain_18010="${ret_plain_len1314_v0}"
    if [ "$(( plain_18010 >= 0 ))" != 0 ]; then
        ret_get_visible_len1315_v0="${plain_18010}"
        return 0
    fi
    strip_ansi__1312_v0 "${text_18007}"
    local stripped_18012="${ret_strip_ansi1312_v0}"
    is_all_ascii__1313_v0 "${stripped_18012}"
    local ret_is_all_ascii1313_v0__46_12="${ret_is_all_ascii1313_v0}"
    if [ "$(( ! ret_is_all_ascii1313_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1305_v0 "${stripped_18012}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_227="${stripped_18012}"
            ret_get_visible_len1315_v0="${#__length_227}"
            return 0
        fi
        ret_get_visible_len1315_v0="${ret_perl_get_cjk_width1305_v0}"
        return 0
    fi
    local __length_228="${stripped_18012}"
    ret_get_visible_len1315_v0="${#__length_228}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1316_v0() {
    local text_18023="${1}"
    local max_width_18024="${2}"
    get_visible_len__1315_v0 "${text_18023}"
    local visible_len_18025="${ret_get_visible_len1315_v0}"
    if [ "$(( visible_len_18025 <= max_width_18024 ))" != 0 ]; then
        ret_truncate_text1316_v0="${text_18023}"
        return 0
    fi
    is_all_ascii__1313_v0 "${text_18023}"
    local ret_is_all_ascii1313_v0__61_12="${ret_is_all_ascii1313_v0}"
    if [ "$(( ! ret_is_all_ascii1313_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1306_v0 "${text_18023}" "${max_width_18024}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18023}" | cut -c1-${max_width_18024}
            __status=$?
        fi
        ret_truncate_text1316_v0="${ret_perl_truncate_cjk1306_v0}"
        return 0
    fi
    local command_229
    command_229="$(printf "%s" "${text_18023}" | cut -c1-${max_width_18024})"
    __status=$?
    ret_truncate_text1316_v0="${command_229}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1317_v0() {
    local text_18021="${1}"
    local max_width_18022="${2}"
    has_ansi_escape__1310_v0 "${text_18021}"
    local ret_has_ansi_escape1310_v0__73_12="${ret_has_ansi_escape1310_v0}"
    if [ "$(( ! ret_has_ansi_escape1310_v0__73_12 ))" != 0 ]; then
        truncate_text__1316_v0 "${text_18021}" "${max_width_18022}"
        ret_truncate_ansi1317_v0="${ret_truncate_text1316_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_230
    command_230="$([[ "${text_18021}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18029="${command_230}"
    # Replace \x1b[ with newline, then split
    local command_231
    command_231="$(t="${text_18021}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18030="${command_231}"
    split__4_v0 "${replaced_18030}" "
"
    local parts_18031=("${ret_split4_v0[@]}")
    local result_18032=""
    local remaining_width_18033="${max_width_18022}"
    local __range_start_18034=0
    local __length_232=("${parts_18031[@]}")
    local __range_end_18034="${#__length_232[@]}"
    local __dir_18034=$(( ${__range_start_18034} <= ${__range_end_18034} ? 1 : -1 ))
    for (( idx_18034=${__range_start_18034}; idx_18034 * ${__dir_18034} < ${__range_end_18034} * ${__dir_18034}; idx_18034+=${__dir_18034} )); do
        local part_18035="${parts_18031[${idx_18034}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18034 == 0 )) && $([ "_${starts_with_ansi_18029}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18035}" == "_" ]; echo $?) && $(( remaining_width_18033 > 0 )) ))" != 0 ]; then
                truncate_text__1316_v0 "${part_18035}" "${remaining_width_18033}"
                local ret_truncate_text1316_v0__95_35="${ret_truncate_text1316_v0}"
                local truncated_18036="${ret_truncate_text1316_v0__95_35}"
                result_18032+="${truncated_18036}"
                get_visible_len__1315_v0 "${truncated_18036}"
                local ret_get_visible_len1315_v0__97_36="${ret_get_visible_len1315_v0}"
                remaining_width_18033="$(( remaining_width_18033 - ret_get_visible_len1315_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_233
            command_233="$(__p="${part_18035}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18037="${command_233}"
            if [ "$([ "_${m_idx_18037}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_234
                command_234="$(__p="${part_18035}"; printf "%s" "${__p:0:${m_idx_18037}}")"
                __status=$?
                local ansi_params_18038="${command_234}"
                result_18032+="\\x1b[""${ansi_params_18038}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18037}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_18039="${ret_parse_int13_v0__108_41}"
                local text_start_18040="$(( m_idx_num_18039 + 1 ))"
                local command_235
                command_235="$(__p="${part_18035}"; printf "%s" "${__p:${text_start_18040}}")"
                __status=$?
                local text_part_18041="${command_235}"
                if [ "$(( $([ "_${text_part_18041}" == "_" ]; echo $?) && $(( remaining_width_18033 > 0 )) ))" != 0 ]; then
                    truncate_text__1316_v0 "${text_part_18041}" "${remaining_width_18033}"
                    local ret_truncate_text1316_v0__112_39="${ret_truncate_text1316_v0}"
                    local truncated_18042="${ret_truncate_text1316_v0__112_39}"
                    result_18032+="${truncated_18042}"
                    get_visible_len__1315_v0 "${truncated_18042}"
                    local ret_get_visible_len1315_v0__114_40="${ret_get_visible_len1315_v0}"
                    remaining_width_18033="$(( remaining_width_18033 - ret_get_visible_len1315_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18035}" == "_" ]; echo $?) && $(( remaining_width_18033 > 0 )) ))" != 0 ]; then
                    truncate_text__1316_v0 "${part_18035}" "${remaining_width_18033}"
                    local ret_truncate_text1316_v0__119_39="${ret_truncate_text1316_v0}"
                    local truncated_18043="${ret_truncate_text1316_v0__119_39}"
                    result_18032+="${truncated_18043}"
                    get_visible_len__1315_v0 "${truncated_18043}"
                    local ret_get_visible_len1315_v0__121_40="${ret_get_visible_len1315_v0}"
                    remaining_width_18033="$(( remaining_width_18033 - ret_get_visible_len1315_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1317_v0="${result_18032}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1318_v0() {
    local text_18005="${1}"
    local max_width_18006="${2}"
    get_visible_len__1315_v0 "${text_18005}"
    local visible_len_18020="${ret_get_visible_len1315_v0}"
    if [ "$(( visible_len_18020 <= max_width_18006 ))" != 0 ]; then
        ret_cutoff_text1318_v0="${text_18005}"
        return 0
    fi
    truncate_ansi__1317_v0 "${text_18005}" "$(( max_width_18006 - 3 ))"
    local ret_truncate_ansi1317_v0__137_12="${ret_truncate_ansi1317_v0}"
    ret_cutoff_text1318_v0="${ret_truncate_ansi1317_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1339_v0() {
    local format_18057="${1}"
    local args_18058=("${!2}")
    args_18058=("${format_18057}" "${args_18058[@]}")
    __status=$?
    printf "${args_18058[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1340_v0() {
    local message_18055="${1}"
    local color_18056="${2}"
    # Prints an error message with a specified color.
    local array_236=("${message_18055}")
    eprintf__1339_v0 "\\x1b[${color_18056}m%s\\x1b[0m" array_236[@]
}

# colored(message: Text, color: Int)
colored__1341_v0() {
    local message_17972="${1}"
    local color_17973="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1341_v0="\\x1b[${color_17973}m""${message_17972}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1345_v0() {
    local items_18049=("${!1}")
    local total_len_18050="${2}"
    local term_width_18051="${3}"
    local separator_18052=" • "
    local separator_len_18053=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18050 <= term_width_18051 ))" != 0 ]; then
        local iter_18054=0
        while :
        do
            local __length_237=("${items_18049[@]}")
            if [ "$(( iter_18054 >= ${#__length_237[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18054 > 0 ))" != 0 ]; then
                eprintf_colored__1340_v0 "${separator_18052}" 90
            fi
            colored__1341_v0 "${items_18049[$(( iter_18054 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1341_v0__23_41="${ret_colored1341_v0}"
            local array_238=("")
            eprintf__1339_v0 "${items_18049[${iter_18054}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1341_v0__23_41}" array_238[@]
            iter_18054="$(( iter_18054 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18059=0
        local first_18060=1
        local iter_18061=0
        while :
        do
            local __length_239=("${items_18049[@]}")
            if [ "$(( iter_18061 >= ${#__length_239[@]} ))" != 0 ]; then
                break
            fi
            local key_18062="${items_18049[${iter_18061}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_18063="${items_18049[$(( iter_18061 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_240="${key_18062}"
            local __length_241="${action_18063}"
            local part_len_18064="$(( $(( ${#__length_240} + 1 )) + ${#__length_241} ))"
            local needed_18065="${part_len_18064}"
            if [ "$(( ! first_18060 ))" != 0 ]; then
                needed_18065="$(( needed_18065 + separator_len_18053 ))"
            fi
            if [ "$(( $(( current_len_18059 + needed_18065 )) > term_width_18051 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18060 ))" != 0 ]; then
                eprintf_colored__1340_v0 "${separator_18052}" 90
            fi
            colored__1341_v0 "${action_18063}" 2
            local ret_colored1341_v0__51_33="${ret_colored1341_v0}"
            local array_242=("")
            eprintf__1339_v0 "${key_18062}"" ""${ret_colored1341_v0__51_33}" array_242[@]
            current_len_18059="$(( current_len_18059 + needed_18065 ))"
            first_18060=0
            iter_18061="$(( iter_18061 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1355_v0() {
    local format_18108="${1}"
    local args_18109=("${!2}")
    args_18109=("${format_18108}" "${args_18109[@]}")
    __status=$?
    printf "${args_18109[@]}" >&2
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
    local size_17951="${1}"
    if [ "$([ "_${size_17951}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1382_v0=0
        return 0
    fi
    split__4_v0 "${size_17951}" " "
    local parts_17952=("${ret_split4_v0[@]}")
    local __length_244=("${parts_17952[@]}")
    if [ "$(( ${#__length_244[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1382_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17952[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17952[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
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
    local size_17954="${command_246}"
    store_term_size__1382_v0 "${size_17954}"
    ret_query_term_size1383_v0="${ret_store_term_size1382_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1384_v0() {
    local command_247
    command_247="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17950="${command_247}"
    store_term_size__1382_v0 "${size_17950}"
    ret_stty_term_size1384_v0="${ret_store_term_size1382_v0}"
    return 0
}

# get_term_size()
get_term_size__1385_v0() {
    stty_term_size__1384_v0 
    local detected_17953="${ret_stty_term_size1384_v0}"
    if [ "$(( ! detected_17953 ))" != 0 ]; then
        query_term_size__1383_v0 
        detected_17953="${ret_query_term_size1383_v0}"
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
    local cnt_18107="${1}"
    local array_248=("")
    eprintf__1355_v0 "\\x1b[${cnt_18107}A" array_248[@]
}

# go_down(cnt: Int)
go_down__1395_v0() {
    local cnt_18110="${1}"
    local array_249=("")
    eprintf__1355_v0 "\\x1b[${cnt_18110}B" array_249[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1402_v0() {
    local display_count_18104="${1}"
    local index_18105="${2}"
    local line_18106="${3}"
    go_up__1394_v0 "$(( display_count_18104 - index_18105 ))"
    local array_250=("")
    eprintf__1339_v0 "\\x1b[G\\x1b[K" array_250[@]
    local array_251=("")
    eprintf__1339_v0 "${line_18106}" array_251[@]
    go_down__1395_v0 "$(( display_count_18104 - index_18105 ))"
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
    local total_18044="${1}"
    local limit_18045="${2}"
    _checked_61=()
    local __range_start_18046=0
    local __range_end_18046="${total_18044}"
    local __dir_18046=$(( ${__range_start_18046} <= ${__range_end_18046} ? 1 : -1 ))
    for (( ____18046=${__range_start_18046}; ____18046 * ${__dir_18046} < ${__range_end_18046} * ${__dir_18046}; ____18046+=${__dir_18046} )); do
        local array_255=(0)
        _checked_61+=("${array_255[@]}")
done
    _count_62=0
    _total_63="${total_18044}"
    _limit_64="${limit_18045}"
}

# checked_is(index: Int)
checked_is__1405_v0() {
    local index_18080="${1}"
    ret_checked_is1405_v0="${_checked_61[${index_18080}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1407_v0() {
    local index_18099="${1}"
    if [ "${_checked_61[${index_18099}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_61["${index_18099}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1407_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1407_v0=0
        return 0
    fi
    _checked_61["${index_18099}"]=1
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
    local was_all_18111="$(( _count_62 == _total_63 ))"
    local __range_start_18112=0
    local __range_end_18112="${_total_63}"
    local __dir_18112=$(( ${__range_start_18112} <= ${__range_end_18112} ? 1 : -1 ))
    for (( i_18112=${__range_start_18112}; i_18112 * ${__dir_18112} < ${__range_end_18112} * ${__dir_18112}; i_18112+=${__dir_18112} )); do
        _checked_61["${i_18112}"]="$(( ! was_all_18111 ))"
done
    if [ "${was_all_18111}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1408_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1420_v0() {
    local pending_17969="${1}"
    local line_17970="${2}"
    local note_at_17971="${3}"
    if [ "$(( note_at_17971 < 0 ))" != 0 ]; then
        local array_256=()
        printf__128_v0 "${pending_17969}""${line_17970}""
" array_256[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_17971 == 0 ))" != 0 ]; then
        colored__1341_v0 "${line_17970}" 90
        local ret_colored1341_v0__12_40="${ret_colored1341_v0}"
        local array_257=()
        printf__128_v0 "${pending_17969}""${ret_colored1341_v0__12_40}""
" array_257[@]
    else
        slice__24_v0 "${line_17970}" 0 "${note_at_17971}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_17970}" "${note_at_17971}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1341_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1341_v0__13_58="${ret_colored1341_v0}"
        local array_258=()
        printf__128_v0 "${pending_17969}""${ret_slice24_v0__13_32}""${ret_colored1341_v0__13_58}""
" array_258[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1421_v0() {
    local names_17942=("${!1}")
    local texts_17943=("${!2}")
    local notes_17944=("${!3}")
    local min_name_width_17945="${4}"
    local __length_259=("${names_17942[@]}")
    local count_17946="${#__length_259[@]}"
    local name_width_17947="${min_name_width_17945}"
    local __range_start_17948=0
    local __range_end_17948="${count_17946}"
    local __dir_17948=$(( ${__range_start_17948} <= ${__range_end_17948} ? 1 : -1 ))
    for (( i_17948=${__range_start_17948}; i_17948 * ${__dir_17948} < ${__range_end_17948} * ${__dir_17948}; i_17948+=${__dir_17948} )); do
        local __length_260="${names_17942[${i_17948}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_17949="${#__length_260}"
        if [ "$(( width_17949 > name_width_17947 ))" != 0 ]; then
            name_width_17947="${width_17949}"
        fi
done
    term_width__1387_v0 
    local width_17955="${ret_term_width1387_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_17956="$(( name_width_17947 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_17957="$(( $(( width_17955 - indent_17956 )) < 24 ))"
    if [ "${stacked_17957}" != 0 ]; then
        indent_17956=6
    fi
    local avail_17958="$(( width_17955 - indent_17956 ))"
    rpad__28_v0 "" " " "${indent_17956}"
    local blank_17959="${ret_rpad28_v0}"
    local __range_start_17960=0
    local __range_end_17960="${count_17946}"
    local __dir_17960=$(( ${__range_start_17960} <= ${__range_end_17960} ? 1 : -1 ))
    for (( i_17960=${__range_start_17960}; i_17960 * ${__dir_17960} < ${__range_end_17960} * ${__dir_17960}; i_17960+=${__dir_17960} )); do
        local pending_17961="${blank_17959}"
        if [ "${stacked_17957}" != 0 ]; then
            local array_261=()
            printf__128_v0 "  ""${names_17942[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_261[@]
        else
            rpad__28_v0 "  ""${names_17942[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_17956}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_17961="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_17943[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_17962=("${ret_split4_v0__52_21[@]}")
        local __length_262=("${words_17962[@]}")
        local note_start_17963="${#__length_262[@]}"
        if [ "$([ "_${notes_17944[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_263="${notes_17944[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_263} > avail_17958 ))" != 0 ]; then
                split__4_v0 "${notes_17944[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_17962+=("${ret_split4_v0__58_26[@]}")
            else
                local array_264=("${notes_17944[${i_17960}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_17962+=("${array_264[@]}")
            fi
        fi
        local line_17964=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_17965=-1
        local __range_start_17966=0
        local __length_265=("${words_17962[@]}")
        local __range_end_17966="${#__length_265[@]}"
        local __dir_17966=$(( ${__range_start_17966} <= ${__range_end_17966} ? 1 : -1 ))
        for (( j_17966=${__range_start_17966}; j_17966 * ${__dir_17966} < ${__range_end_17966} * ${__dir_17966}; j_17966+=${__dir_17966} )); do
            local word_17967="${words_17962[${j_17966}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_17968
            candidate_17968="$(if [ "$([ "_${line_17964}" != "_" ]; echo $?)" != 0 ]; then echo "${word_17967}"; else echo "${line_17964}"" ""${word_17967}"; fi)"
            local __length_266="${candidate_17968}"
            if [ "$(( $(( ${#__length_266} > avail_17958 )) && $([ "_${line_17964}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1420_v0 "${pending_17961}" "${line_17964}" "${note_at_17965}"
                pending_17961="${blank_17959}"
                line_17964="${word_17967}"
                note_at_17965="$(if [ "$(( j_17966 >= note_start_17963 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_17966 >= note_start_17963 )) && $(( note_at_17965 < 0 )) ))" != 0 ]; then
                    local __length_267="${candidate_17968}"
                    local __length_268="${word_17967}"
                    note_at_17965="$(( ${#__length_267} - ${#__length_268} ))"
                fi
                line_17964="${candidate_17968}"
            fi
done
        print_help_line__1420_v0 "${pending_17961}" "${line_17964}" "${note_at_17965}"
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
    local cursor_len_18086="${#__length_270}"
    local max_option_width_18087="$(( $(( _term_width_79 - cursor_len_18086 )) - 1 ))"
    local __range_start_18088=0
    local __range_end_18088="${_page_count_82}"
    local __dir_18088=$(( ${__range_start_18088} <= ${__range_end_18088} ? 1 : -1 ))
    for (( i_18088=${__range_start_18088}; i_18088 * ${__dir_18088} < ${__range_end_18088} * ${__dir_18088}; i_18088+=${__dir_18088} )); do
        cutoff_text__1318_v0 "${_page_81[${i_18088}]?"Index out of bounds (at src/./choose/./engine.ab:45:45)"}" "${max_option_width_18087}"
        local ret_cutoff_text1318_v0__45_27="${ret_cutoff_text1318_v0}"
        local truncated_18089="${ret_cutoff_text1318_v0__45_27}"
        if [ "$(( i_18088 == _selected_75 ))" != 0 ]; then
            colored_secondary__1287_v0 "${_cursor_76}""${truncated_18089}""
"
            local ret_colored_secondary1287_v0__47_21="${ret_colored_secondary1287_v0}"
            local array_271=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__47_21}" array_271[@]
        else
            print_blank__1237_v0 "${cursor_len_18086}"
            local array_272=("")
            eprintf__1184_v0 "${truncated_18089}""
" array_272[@]
        fi
done
    local remaining_slots_18090="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18090 > 0 ))" != 0 ]; then
        local __range_start_18091=0
        local __range_end_18091="${remaining_slots_18090}"
        local __dir_18091=$(( ${__range_start_18091} <= ${__range_end_18091} ? 1 : -1 ))
        for (( ____18091=${__range_start_18091}; ____18091 * ${__dir_18091} < ${__range_end_18091} * ${__dir_18091}; ____18091+=${__dir_18091} )); do
            local array_273=("")
            eprintf__1184_v0 "\\x1b[K
" array_273[@]
done
    fi
}

# render_multi_page()
render_multi_page__1584_v0() {
    local __length_274="${_cursor_76}"
    local cursor_len_18075="${#__length_274}"
    local max_option_width_18076="$(( $(( _term_width_79 - cursor_len_18075 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1589_v0 
    local page_start_18077="${ret_chooser_page_start1589_v0}"
    local __range_start_18078=0
    local __range_end_18078="${_page_count_82}"
    local __dir_18078=$(( ${__range_start_18078} <= ${__range_end_18078} ? 1 : -1 ))
    for (( i_18078=${__range_start_18078}; i_18078 * ${__dir_18078} < ${__range_end_18078} * ${__dir_18078}; i_18078+=${__dir_18078} )); do
        local global_idx_18079="$(( page_start_18077 + i_18078 ))"
        checked_is__1405_v0 "${global_idx_18079}"
        local ret_checked_is1405_v0__67_28="${ret_checked_is1405_v0}"
        local check_mark_18081
        check_mark_18081="$(if [ "${ret_checked_is1405_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1318_v0 "${_page_81[${i_18078}]?"Index out of bounds (at src/./choose/./engine.ab:68:45)"}" "${max_option_width_18076}"
        local ret_cutoff_text1318_v0__68_27="${ret_cutoff_text1318_v0}"
        local truncated_18082="${ret_cutoff_text1318_v0__68_27}"
        checked_is__1405_v0 "${global_idx_18079}"
        local ret_checked_is1405_v0__71_13="${ret_checked_is1405_v0}"
        if [ "$(( i_18078 == _selected_75 ))" != 0 ]; then
            colored_secondary__1287_v0 "${_cursor_76}""${check_mark_18081}""${truncated_18082}""
"
            local ret_colored_secondary1287_v0__70_37="${ret_colored_secondary1287_v0}"
            local array_275=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__70_37}" array_275[@]
        elif [ "${ret_checked_is1405_v0__71_13}" != 0 ]; then
            print_blank__1237_v0 "${cursor_len_18075}"
            colored_secondary__1287_v0 "${check_mark_18081}""${truncated_18082}""
"
            local ret_colored_secondary1287_v0__73_25="${ret_colored_secondary1287_v0}"
            local array_276=("")
            eprintf__1184_v0 "${ret_colored_secondary1287_v0__73_25}" array_276[@]
        else
            print_blank__1237_v0 "${cursor_len_18075}"
            local array_277=("")
            eprintf__1184_v0 "${check_mark_18081}""${truncated_18082}""
" array_277[@]
        fi
done
    local remaining_slots_18084="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18084 > 0 ))" != 0 ]; then
        local __range_start_18085=0
        local __range_end_18085="${remaining_slots_18084}"
        local __dir_18085=$(( ${__range_start_18085} <= ${__range_end_18085} ? 1 : -1 ))
        for (( ____18085=${__range_start_18085}; ____18085 * ${__dir_18085} < ${__range_end_18085} * ${__dir_18085}; ____18085+=${__dir_18085} )); do
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
    local total_17993="${1}"
    local page_size_17994="${2}"
    local header_17995="${3}"
    local cursor_17996="${4}"
    local multi_17997="${5}"
    local limit_17998="${6}"
    _total_70="${total_17993}"
    _cursor_76="${cursor_17996}"
    _multi_77="${multi_17997}"
    _limit_78="${limit_17998}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_17995}" == "_" ]; echo $?)"
    stty_lock__1225_v0 
    hide_cursor__1242_v0 
    term_width__1232_v0 
    _term_width_79="${ret_term_width1232_v0}"
    term_height__1233_v0 
    local term_height_18003="${ret_term_height1233_v0}"
    local max_page_size_18004
    max_page_size_18004="$(( term_height_18003 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_17994}"
    if [ "$(( _page_size_71 > max_page_size_18004 ))" != 0 ]; then
        _page_size_71="${max_page_size_18004}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1318_v0 "${header_17995}" "${_term_width_79}"
        local ret_cutoff_text1318_v0__153_17="${ret_cutoff_text1318_v0}"
        local array_287=("")
        eprintf__1184_v0 "${ret_cutoff_text1318_v0__153_17}""
" array_287[@]
    fi
    math_floor__636_v0 "$(( $(( $(( total_17993 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _total_pages_73="${ret_math_floor636_v0}"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_17993 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_17993}"
    fi
    if [ "${multi_17997}" != 0 ]; then
        checked_init__1404_v0 "${total_17993}" "${limit_17998}"
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
    local start_18070="${ret_chooser_page_start1589_v0}"
    local end_18071="$(( start_18070 + _page_size_71 ))"
    if [ "$(( end_18071 > _total_70 ))" != 0 ]; then
        end_18071="${_total_70}"
    fi
    ret_chooser_page_count1590_v0="$(( end_18071 - start_18070 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1591_v0() {
    local page_18074=("${!1}")
    _page_81=("${page_18074[@]}")
    local __length_290=("${page_18074[@]}")
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
    local check_width_18101
    check_width_18101="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_292="${_cursor_76}"
    ret_option_width1592_v0="$(( $(( _term_width_79 - ${#__length_292} )) - check_width_18101 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1593_v0() {
    local index_18114="${1}"
    local __length_293="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_293}"
    local blank_18115="${ret_rpad28_v0}"
    option_width__1592_v0 
    local ret_option_width1592_v0__224_49="${ret_option_width1592_v0}"
    cutoff_text__1318_v0 "${_page_81[${index_18114}]?"Index out of bounds (at src/./choose/./engine.ab:224:41)"}" "${ret_option_width1592_v0__224_49}"
    local truncated_18116="${ret_cutoff_text1318_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1593_v0="${blank_18115}""${truncated_18116}"
        return 0
    fi
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__228_19="${ret_chooser_page_start1589_v0}"
    checked_is__1405_v0 "$(( ret_chooser_page_start1589_v0__228_19 + index_18114 ))"
    local ret_checked_is1405_v0__228_8="${ret_checked_is1405_v0}"
    if [ "${ret_checked_is1405_v0__228_8}" != 0 ]; then
        colored_secondary__1287_v0 "✓ ""${truncated_18116}"
        local ret_colored_secondary1287_v0__229_24="${ret_colored_secondary1287_v0}"
        ret_unselected_line1593_v0="${blank_18115}""${ret_colored_secondary1287_v0__229_24}"
        return 0
    fi
    ret_unselected_line1593_v0="${blank_18115}""• ""${truncated_18116}"
    return 0
}

# selected_line(index: Int)
selected_line__1594_v0() {
    local index_18100="${1}"
    option_width__1592_v0 
    local ret_option_width1592_v0__236_49="${ret_option_width1592_v0}"
    cutoff_text__1318_v0 "${_page_81[${index_18100}]?"Index out of bounds (at src/./choose/./engine.ab:236:41)"}" "${ret_option_width1592_v0__236_49}"
    local truncated_18102="${ret_cutoff_text1318_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1287_v0 "${_cursor_76}""${truncated_18102}"
        ret_selected_line1594_v0="${ret_colored_secondary1287_v0}"
        return 0
    fi
    chooser_page_start__1589_v0 
    local ret_chooser_page_start1589_v0__240_29="${ret_chooser_page_start1589_v0}"
    checked_is__1405_v0 "$(( ret_chooser_page_start1589_v0__240_29 + index_18100 ))"
    local ret_checked_is1405_v0__240_18="${ret_checked_is1405_v0}"
    local mark_18103
    mark_18103="$(if [ "${ret_checked_is1405_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1287_v0 "${_cursor_76}""${mark_18103}""${truncated_18102}"
    ret_selected_line1594_v0="${ret_colored_secondary1287_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1595_v0() {
    local prev_selected_18113="${1}"
    unselected_line__1593_v0 "${prev_selected_18113}"
    local ret_unselected_line1593_v0__247_47="${ret_unselected_line1593_v0}"
    redraw_row__1402_v0 "${_display_count_72}" "${prev_selected_18113}" "${ret_unselected_line1593_v0__247_47}"
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
    local key_18095="${ret_get_key1182_v0}"
    local prev_selected_18096="${_selected_75}"
    local prev_page_18097="${_current_page_74}"
    chooser_page_start__1589_v0 
    local page_start_18098="${ret_chooser_page_start1589_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_18095}" != "_UP" ]; echo $?) || $([ "_${key_18095}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18095}" != "_DOWN" ]; echo $?) || $([ "_${key_18095}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18095}" != "_LEFT" ]; echo $?) || $([ "_${key_18095}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_18095}" != "_RIGHT" ]; echo $?) || $([ "_${key_18095}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $(( $([ "_${key_18095}" != "_x" ]; echo $?) || $([ "_${key_18095}" != "_X" ]; echo $?) )) || $([ "_${key_18095}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1407_v0 "$(( page_start_18098 + _selected_75 ))"
        local ret_checked_toggle1407_v0__310_16="${ret_checked_toggle1407_v0}"
        if [ "${ret_checked_toggle1407_v0__310_16}" != 0 ]; then
            redraw_current_line__1596_v0 
        fi
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $(( $([ "_${key_18095}" != "_a" ]; echo $?) || $([ "_${key_18095}" != "_A" ]; echo $?) )) || $([ "_${key_18095}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18095}" != "_INPUT" ]; echo $?) || $([ "_${key_18095}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step1597_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1597_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_18097 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1597_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_18096 != _selected_75 ))" != 0 ]; then
        redraw_selection__1595_v0 "${prev_selected_18096}"
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
    local index_18123="${1}"
    checked_is__1405_v0 "${index_18123}"
    ret_chooser_is_checked1599_v0="${ret_checked_is1405_v0}"
    return 0
}

# chooser_end()
chooser_end__1600_v0() {
    local total_lines_18118="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_18118="$(( total_lines_18118 + 1 ))"
    fi
    go_down__1240_v0 1
    remove_line__1235_v0 "$(( total_lines_18118 - 1 ))"
    remove_current_line__1236_v0 
    stty_unlock__1226_v0 
    show_cursor__1243_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1609_v0() {
    local options_18127=("${!1}")
    local cursor_18128="${2}"
    local header_18129="${3}"
    local page_size_18130="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_295=("${options_18127[@]}")
    local total_18131="${#__length_295[@]}"
    if [ "$(( total_18131 == 0 ))" != 0 ]; then
        eprintf_colored__1185_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1588_v0 "${total_18131}" "${page_size_18130}" "${header_18129}" "${cursor_18128}" 0 -1
    local need_page_18132=1
    while :
    do
        if [ "${need_page_18132}" != 0 ]; then
            local page_18133=()
            chooser_page_start__1589_v0 
            local start_18134="${ret_chooser_page_start1589_v0}"
            chooser_page_count__1590_v0 
            local count_18135="${ret_chooser_page_count1590_v0}"
            local __range_start_18136="${start_18134}"
            local __range_end_18136="$(( start_18134 + count_18135 ))"
            local __dir_18136=$(( ${__range_start_18136} <= ${__range_end_18136} ? 1 : -1 ))
            for (( i_18136=${__range_start_18136}; i_18136 * ${__dir_18136} < ${__range_end_18136} * ${__dir_18136}; i_18136+=${__dir_18136} )); do
                local array_297=("${options_18127[${i_18136}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_18133+=("${array_297[@]}")
done
            chooser_set_page__1591_v0 page_18133[@]
        fi
        chooser_step__1597_v0 
        local step_18137="${ret_chooser_step1597_v0}"
        if [ "$(( step_18137 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18132="$(( step_18137 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1598_v0 
    local selected_18138="${ret_chooser_selected1598_v0}"
    chooser_end__1600_v0 
    ret_xyl_choose1609_v0="${options_18127[${selected_18138}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1610_v0() {
    local options_17987=("${!1}")
    local cursor_17988="${2}"
    local header_17989="${3}"
    local limit_17990="${4}"
    local page_size_17991="${5}"
    local __length_298=("${options_17987[@]}")
    local total_17992="${#__length_298[@]}"
    if [ "$(( total_17992 == 0 ))" != 0 ]; then
        eprintf_colored__1185_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1610_v0=()
        return 0
    fi
    chooser_begin__1588_v0 "${total_17992}" "${page_size_17991}" "${header_17989}" "${cursor_17988}" 1 "${limit_17990}"
    local need_page_18067=1
    while :
    do
        if [ "${need_page_18067}" != 0 ]; then
            local page_18068=()
            chooser_page_start__1589_v0 
            local start_18069="${ret_chooser_page_start1589_v0}"
            chooser_page_count__1590_v0 
            local count_18072="${ret_chooser_page_count1590_v0}"
            local __range_start_18073="${start_18069}"
            local __range_end_18073="$(( start_18069 + count_18072 ))"
            local __dir_18073=$(( ${__range_start_18073} <= ${__range_end_18073} ? 1 : -1 ))
            for (( i_18073=${__range_start_18073}; i_18073 * ${__dir_18073} < ${__range_end_18073} * ${__dir_18073}; i_18073+=${__dir_18073} )); do
                local array_301=("${options_17987[${i_18073}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_18068+=("${array_301[@]}")
done
            chooser_set_page__1591_v0 page_18068[@]
        fi
        chooser_step__1597_v0 
        local step_18117="${ret_chooser_step1597_v0}"
        if [ "$(( step_18117 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18067="$(( step_18117 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1600_v0 
    local result_18121=()
    local __range_start_18122=0
    local __range_end_18122="${total_17992}"
    local __dir_18122=$(( ${__range_start_18122} <= ${__range_end_18122} ? 1 : -1 ))
    for (( i_18122=${__range_start_18122}; i_18122 * ${__dir_18122} < ${__range_end_18122} * ${__dir_18122}; i_18122+=${__dir_18122} )); do
        chooser_is_checked__1599_v0 "${i_18122}"
        local ret_chooser_is_checked1599_v0__93_12="${ret_chooser_is_checked1599_v0}"
        if [ "${ret_chooser_is_checked1599_v0__93_12}" != 0 ]; then
            local array_303=("${options_17987[${i_18122}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_18121+=("${array_303[@]}")
        fi
done
    ret_xyl_multi_choose1610_v0=("${result_18121[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1711_v0() {
    local usage_17910=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1244_v0 usage_17910[@]
    printf '%s\n' ""
    colored_primary__1286_v0 "choose"
    local ret_colored_primary1286_v0__8_20="${ret_colored_primary1286_v0}"
    local title_17937=("${ret_colored_primary1286_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1244_v0 title_17937[@]
    printf '%s\n' ""
    colored_secondary__1287_v0 "Arguments:"
    local ret_colored_secondary1287_v0__11_12="${ret_colored_secondary1287_v0}"
    local array_306=()
    printf__128_v0 "${ret_colored_secondary1287_v0__11_12}""
" array_306[@]
    local arg_names_17939=("[<options> ...]")
    local arg_texts_17940=("List of options to choose from")
    local arg_notes_17941=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1421_v0 arg_names_17939[@] arg_texts_17940[@] arg_notes_17941[@] 20
    printf '%s\n' ""
    colored_secondary__1287_v0 "Flags:"
    local ret_colored_secondary1287_v0__18_12="${ret_colored_secondary1287_v0}"
    local array_310=()
    printf__128_v0 "${ret_colored_secondary1287_v0__18_12}""
" array_310[@]
    local names_17974=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_17975=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_17976=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1421_v0 names_17974[@] texts_17975[@] notes_17976[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1769_v0() {
    local options_17903=()
    local command_315
    command_315="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_17904="${command_315}"
    if [ "$([ "_${is_tty_17904}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_17903+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1769_v0=("${options_17903[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1770_v0() {
    local parameters_17887=("${!1}")
    local cursor_17888="> "
    colored_primary__1286_v0 "Choose: "
    local ret_colored_primary1286_v0__17_30="${ret_colored_primary1286_v0}"
    local header_17902="\\x1b[1m""${ret_colored_primary1286_v0__17_30}"
    read_stdin_options__1769_v0 
    local options_17905=("${ret_read_stdin_options1769_v0[@]}")
    local multi_17906=0
    local limit_17907=-1
    local page_size_17908=10
    local __length_319=("${parameters_17887[@]}")
    local slice_upper_318="${#__length_319[@]}"
    local slice_offset_320=2
    local slice_offset_320=$((${slice_offset_320} > 0 ? ${slice_offset_320} : 0))
    local slice_length_321="$(( slice_upper_318 - slice_offset_320 ))"
    local slice_length_321=$((${slice_length_321} > 0 ? ${slice_length_321} : 0))
    for param_17909 in "${parameters_17887[@]:${slice_offset_320}:${slice_length_321}}"; do
        starts_with__22_v0 "${param_17909}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17909}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17909}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17909}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_17909}" != "_-h" ]; echo $?) || $([ "_${param_17909}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1711_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_322="--cursor="
            slice__24_v0 "${param_17909}" "${#__length_322}" 0
            cursor_17888="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_323="--header="
            slice__24_v0 "${param_17909}" "${#__length_323}" 0
            header_17902="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_324="--limit="
            slice__24_v0 "${param_17909}" "${#__length_324}" 0
            local value_17977="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17977}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1185_v0 "ERROR: Invalid limit value: ""${value_17977}""
" 31
                exit 1
            fi
            limit_17907="${ret_parse_int13_v0}"
            multi_17906=1
        elif [ "$([ "_${param_17909}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_17906=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_325="--page-size="
            slice__24_v0 "${param_17909}" "${#__length_325}" 0
            local value_17982="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17982}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1185_v0 "ERROR: Invalid page-size value: ""${value_17982}""
" 31
                exit 1
            fi
            page_size_17908="${ret_parse_int13_v0}"
        else
            options_17905+=("${param_17909}")
        fi
    done
    has_ansi_escape__1310_v0 "${header_17902}"
    local ret_has_ansi_escape1310_v0__59_44="${ret_has_ansi_escape1310_v0}"
    escape_ansi__1311_v0 "${header_17902}"
    local ret_escape_ansi1311_v0__59_73="${ret_escape_ansi1311_v0}"
    colored_primary__1286_v0 "${header_17902}"
    local ret_colored_primary1286_v0__59_111="${ret_colored_primary1286_v0}"
    local display_header_17986
    display_header_17986="$(if [ "$(( $([ "_${header_17902}" != "_" ]; echo $?) || ret_has_ansi_escape1310_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1311_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1286_v0__59_111}"; fi)"
    if [ "${multi_17906}" != 0 ]; then
        xyl_multi_choose__1610_v0 options_17905[@] "${cursor_17888}" "${display_header_17986}" "${limit_17907}" "${page_size_17908}"
        local results_18124=("${ret_xyl_multi_choose1610_v0[@]}")
        join__7_v0 results_18124[@] "
"
        ret_execute_choose1770_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1609_v0 options_17905[@] "${cursor_17888}" "${display_header_17986}" "${page_size_17908}"
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
    local format_27430="${1}"
    local args_27431=("${!2}")
    args_27431=("${format_27430}" "${args_27431[@]}")
    __status=$?
    printf "${args_27431[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1858_v0() {
    local message_27428="${1}"
    local color_27429="${2}"
    # Prints an error message with a specified color.
    local array_328=("${message_27428}")
    eprintf__1857_v0 "\\x1b[${color_27429}m%s\\x1b[0m" array_328[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1873_v0() {
    local format_27448="${1}"
    local args_27449=("${!2}")
    args_27449=("${format_27448}" "${args_27449[@]}")
    __status=$?
    printf "${args_27449[@]}" >&2
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
        local disabled_27373
        disabled_27373="$([ "_${command_329}" != "_No" ]; echo $?)"
        local command_330
        command_330="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27374
        found_27374="$(( $(( ! disabled_27373 )) && $([ "_${command_330}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_27374}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1880_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1881_v0() {
    local text_27372="${1}"
    perl_available__1880_v0 
    local ret_perl_available1880_v0__19_12="${ret_perl_available1880_v0}"
    if [ "$(( ! ret_perl_available1880_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return 1
    fi
    local command_331
    command_331="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27372}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return "${__status}"
    fi
    local width_str_27375="${command_331}"
    parse_int__13_v0 "${width_str_27375}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1881_v0=''
        return "${__status}"
    fi
    local width_27376="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1881_v0="${width_27376}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1886_v0() {
    local text_27362="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_332
    command_332="$([[ "${text_27362}" == *$'\x1b'* || "${text_27362}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27363="${command_332}"
    ret_has_ansi_escape1886_v0="$([ "_${has_escape_27363}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1888_v0() {
    local text_27368="${1}"
    local command_333
    command_333="$(printf "%s" "${text_27368}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1888_v0="${command_333}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1889_v0() {
    local text_27370="${1}"
    local command_334
    command_334="$(printf "%s" "${text_27370}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27371="${command_334}"
    ret_is_all_ascii1889_v0="$([ "_${result_27371}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1890_v0() {
    local text_27365="${1}"
    local command_335
    command_335="$(LC_ALL=C; __t="${text_27365}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27366="${command_335}"
    parse_int__13_v0 "${measured_27366}"
    __status=$?
    ret_plain_len1890_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1891_v0() {
    local text_27364="${1}"
    plain_len__1890_v0 "${text_27364}"
    local plain_27367="${ret_plain_len1890_v0}"
    if [ "$(( plain_27367 >= 0 ))" != 0 ]; then
        ret_get_visible_len1891_v0="${plain_27367}"
        return 0
    fi
    strip_ansi__1888_v0 "${text_27364}"
    local stripped_27369="${ret_strip_ansi1888_v0}"
    is_all_ascii__1889_v0 "${stripped_27369}"
    local ret_is_all_ascii1889_v0__46_12="${ret_is_all_ascii1889_v0}"
    if [ "$(( ! ret_is_all_ascii1889_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1881_v0 "${stripped_27369}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_336="${stripped_27369}"
            ret_get_visible_len1891_v0="${#__length_336}"
            return 0
        fi
        ret_get_visible_len1891_v0="${ret_perl_get_cjk_width1881_v0}"
        return 0
    fi
    local __length_337="${stripped_27369}"
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
    local count_27446="${command_339}"
    parse_int__13_v0 "${count_27446}"
    __status=$?
    ret_stty_count1897_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1898_v0() {
    stty_count__1897_v0 
    local count_num_27447="${ret_stty_count1897_v0}"
    if [ "$(( count_num_27447 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_27447="$(( count_num_27447 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27447}
    __status=$?
}

# stty_unlock()
stty_unlock__1899_v0() {
    stty_count__1897_v0 
    local count_num_27548="${ret_stty_count1897_v0}"
    if [ "$(( count_num_27548 > 0 ))" != 0 ]; then
        count_num_27548="$(( count_num_27548 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27548}
        __status=$?
        if [ "$(( count_num_27548 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1900_v0() {
    local size_27353="${1}"
    if [ "$([ "_${size_27353}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1900_v0=0
        return 0
    fi
    split__4_v0 "${size_27353}" " "
    local parts_27354=("${ret_split4_v0[@]}")
    local __length_340=("${parts_27354[@]}")
    if [ "$(( ${#__length_340[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1900_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27354[1]?"Index out of bounds (at src/./filter/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27354[0]?"Index out of bounds (at src/./filter/../utils/term.ab:53:68)"}"
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
    local size_27356="${command_342}"
    store_term_size__1900_v0 "${size_27356}"
    ret_query_term_size1901_v0="${ret_store_term_size1900_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1902_v0() {
    local command_343
    command_343="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27352="${command_343}"
    store_term_size__1900_v0 "${size_27352}"
    ret_stty_term_size1902_v0="${ret_store_term_size1900_v0}"
    return 0
}

# get_term_size()
get_term_size__1903_v0() {
    stty_term_size__1902_v0 
    local detected_27355="${ret_stty_term_size1902_v0}"
    if [ "$(( ! detected_27355 ))" != 0 ]; then
        query_term_size__1901_v0 
        detected_27355="${ret_query_term_size1901_v0}"
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
    local cnt_27545="${1}"
    if [ "$(( cnt_27545 > 0 ))" != 0 ]; then
        local sequence_27546=""
        local __range_start_27547=0
        local __range_end_27547="${cnt_27545}"
        local __dir_27547=$(( ${__range_start_27547} <= ${__range_end_27547} ? 1 : -1 ))
        for (( ____27547=${__range_start_27547}; ____27547 * ${__dir_27547} < ${__range_end_27547} * ${__dir_27547}; ____27547+=${__dir_27547} )); do
            sequence_27546+="\\x1b[2K\\x1b[1A"
done
        local array_344=("")
        eprintf__1873_v0 "${sequence_27546}" array_344[@]
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
    local cnt_27494="${1}"
    local __range_start_27495=0
    local __range_end_27495="${cnt_27494}"
    local __dir_27495=$(( ${__range_start_27495} <= ${__range_end_27495} ? 1 : -1 ))
    for (( ____27495=${__range_start_27495}; ____27495 * ${__dir_27495} < ${__range_end_27495} * ${__dir_27495}; ____27495+=${__dir_27495} )); do
        local array_347=("")
        eprintf__1873_v0 "
" array_347[@]
done
}

# go_up(cnt: Int)
go_up__1912_v0() {
    local cnt_27513="${1}"
    local array_348=("")
    eprintf__1873_v0 "\\x1b[${cnt_27513}A" array_348[@]
}

# go_down(cnt: Int)
go_down__1913_v0() {
    local cnt_27527="${1}"
    local array_349=("")
    eprintf__1873_v0 "\\x1b[${cnt_27527}B" array_349[@]
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
    local pieces_27351=("${!1}")
    term_width__1905_v0 
    local width_27357="${ret_term_width1905_v0}"
    local line_27358=""
    local line_len_27359=0
    for piece_27360 in "${pieces_27351[@]}"; do
        local __length_354="${piece_27360}"
        local piece_len_27361="${#__length_354}"
        has_ansi_escape__1886_v0 "${piece_27360}"
        local ret_has_ansi_escape1886_v0__186_12="${ret_has_ansi_escape1886_v0}"
        if [ "${ret_has_ansi_escape1886_v0__186_12}" != 0 ]; then
            get_visible_len__1891_v0 "${piece_27360}"
            piece_len_27361="${ret_get_visible_len1891_v0}"
        fi
        if [ "$([ "_${line_27358}" != "_" ]; echo $?)" != 0 ]; then
            line_27358="${piece_27360}"
            line_len_27359="${piece_len_27361}"
        elif [ "$(( $(( $(( line_len_27359 + 1 )) + piece_len_27361 )) > width_27357 ))" != 0 ]; then
            local array_355=()
            printf__128_v0 "${line_27358}""
" array_355[@]
            line_27358="${piece_27360}"
            line_len_27359="${piece_len_27361}"
        else
            line_27358+=" ""${piece_27360}"
            line_len_27359="$(( line_len_27359 + $(( 1 + piece_len_27361 )) ))"
        fi
    done
    if [ "$([ "_${line_27358}" == "_" ]; echo $?)" != 0 ]; then
        local array_356=()
        printf__128_v0 "${line_27358}""
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
    local config_27389="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_27389}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1954_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1955_v0() {
    local message_27384="${1}"
    local r_27385="${2}"
    local g_27386="${3}"
    local b_27387="${4}"
    local fallback_27388="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1955_v0="\\x1b[38;2;${r_27385};${g_27386};${b_27387}m""${message_27384}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1954_v0 
        local ret_get_supports_truecolor1954_v0__45_17="${ret_get_supports_truecolor1954_v0}"
        if [ "${ret_get_supports_truecolor1954_v0__45_17}" != 0 ]; then
            ret_colored_rgb1955_v0="\\x1b[38;2;${r_27385};${g_27386};${b_27387}m""${message_27384}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27388 == 0 ))" != 0 ]; then
            ret_colored_rgb1955_v0="${message_27384}"
            return 0
        else
            ret_colored_rgb1955_v0="\\x1b[${fallback_27388}m""${message_27384}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27388 == 0 ))" != 0 ]; then
            ret_colored_rgb1955_v0="${message_27384}"
            return 0
        fi
        ret_colored_rgb1955_v0="\\x1b[${fallback_27388}m""${message_27384}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1957_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27378="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27378}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27378}" ";"
            local parts_27379=("${ret_split4_v0[@]}")
            local __length_360=("${parts_27379[@]}")
            if [ "$(( ${#__length_360[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27379[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27379[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_27380="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27380}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27380}" ";"
            local parts_27381=("${ret_split4_v0[@]}")
            local __length_362=("${parts_27381[@]}")
            if [ "$(( ${#__length_362[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27381[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27381[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27381[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27381[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_27382="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27382}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27382}" ";"
            local parts_27383=("${ret_split4_v0[@]}")
            local __length_364=("${parts_27383[@]}")
            if [ "$(( ${#__length_364[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27383[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27383[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27383[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1957_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27383[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:139:37)"}"
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
    local message_27377="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1958_v0 
    fi
    colored_rgb__1955_v0 "${message_27377}" "${_primary_color_97[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1959_v0="${ret_colored_rgb1955_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1960_v0() {
    local message_27391="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1958_v0 
    fi
    colored_rgb__1955_v0 "${message_27391}" "${_secondary_color_98[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:113)"}"
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
        local disabled_27466
        disabled_27466="$([ "_${command_366}" != "_No" ]; echo $?)"
        local command_367
        command_367="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27467
        found_27467="$(( $(( ! disabled_27466 )) && $([ "_${command_367}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_27467}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1977_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1978_v0() {
    local text_27465="${1}"
    perl_available__1977_v0 
    local ret_perl_available1977_v0__19_12="${ret_perl_available1977_v0}"
    if [ "$(( ! ret_perl_available1977_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return 1
    fi
    local command_368
    command_368="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27465}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return "${__status}"
    fi
    local width_str_27468="${command_368}"
    parse_int__13_v0 "${width_str_27468}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1978_v0=''
        return "${__status}"
    fi
    local width_27469="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1978_v0="${width_27469}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1979_v0() {
    local text_27476="${1}"
    local max_width_27477="${2}"
    perl_available__1977_v0 
    local ret_perl_available1977_v0__30_12="${ret_perl_available1977_v0}"
    if [ "$(( ! ret_perl_available1977_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1979_v0=''
        return 1
    fi
    local command_369
    command_369="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27476}" ${max_width_27477} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1979_v0=''
        return "${__status}"
    fi
    local result_27478="${command_369}"
    ret_perl_truncate_cjk1979_v0="${result_27478}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1983_v0() {
    local text_27433="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_370
    command_370="$([[ "${text_27433}" == *$'\x1b'* || "${text_27433}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27434="${command_370}"
    ret_has_ansi_escape1983_v0="$([ "_${has_escape_27434}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1984_v0() {
    local text_27435="${1}"
    local command_371
    command_371="$(printf '%s' "${text_27435}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1984_v0="${command_371}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1985_v0() {
    local text_27461="${1}"
    local command_372
    command_372="$(printf "%s" "${text_27461}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1985_v0="${command_372}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1986_v0() {
    local text_27463="${1}"
    local command_373
    command_373="$(printf "%s" "${text_27463}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27464="${command_373}"
    ret_is_all_ascii1986_v0="$([ "_${result_27464}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1987_v0() {
    local text_27458="${1}"
    local command_374
    command_374="$(LC_ALL=C; __t="${text_27458}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27459="${command_374}"
    parse_int__13_v0 "${measured_27459}"
    __status=$?
    ret_plain_len1987_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1988_v0() {
    local text_27457="${1}"
    plain_len__1987_v0 "${text_27457}"
    local plain_27460="${ret_plain_len1987_v0}"
    if [ "$(( plain_27460 >= 0 ))" != 0 ]; then
        ret_get_visible_len1988_v0="${plain_27460}"
        return 0
    fi
    strip_ansi__1985_v0 "${text_27457}"
    local stripped_27462="${ret_strip_ansi1985_v0}"
    is_all_ascii__1986_v0 "${stripped_27462}"
    local ret_is_all_ascii1986_v0__46_12="${ret_is_all_ascii1986_v0}"
    if [ "$(( ! ret_is_all_ascii1986_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1978_v0 "${stripped_27462}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_375="${stripped_27462}"
            ret_get_visible_len1988_v0="${#__length_375}"
            return 0
        fi
        ret_get_visible_len1988_v0="${ret_perl_get_cjk_width1978_v0}"
        return 0
    fi
    local __length_376="${stripped_27462}"
    ret_get_visible_len1988_v0="${#__length_376}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1989_v0() {
    local text_27473="${1}"
    local max_width_27474="${2}"
    get_visible_len__1988_v0 "${text_27473}"
    local visible_len_27475="${ret_get_visible_len1988_v0}"
    if [ "$(( visible_len_27475 <= max_width_27474 ))" != 0 ]; then
        ret_truncate_text1989_v0="${text_27473}"
        return 0
    fi
    is_all_ascii__1986_v0 "${text_27473}"
    local ret_is_all_ascii1986_v0__61_12="${ret_is_all_ascii1986_v0}"
    if [ "$(( ! ret_is_all_ascii1986_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1979_v0 "${text_27473}" "${max_width_27474}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27473}" | cut -c1-${max_width_27474}
            __status=$?
        fi
        ret_truncate_text1989_v0="${ret_perl_truncate_cjk1979_v0}"
        return 0
    fi
    local command_377
    command_377="$(printf "%s" "${text_27473}" | cut -c1-${max_width_27474})"
    __status=$?
    ret_truncate_text1989_v0="${command_377}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1990_v0() {
    local text_27471="${1}"
    local max_width_27472="${2}"
    has_ansi_escape__1983_v0 "${text_27471}"
    local ret_has_ansi_escape1983_v0__73_12="${ret_has_ansi_escape1983_v0}"
    if [ "$(( ! ret_has_ansi_escape1983_v0__73_12 ))" != 0 ]; then
        truncate_text__1989_v0 "${text_27471}" "${max_width_27472}"
        ret_truncate_ansi1990_v0="${ret_truncate_text1989_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_378
    command_378="$([[ "${text_27471}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27479="${command_378}"
    # Replace \x1b[ with newline, then split
    local command_379
    command_379="$(t="${text_27471}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27480="${command_379}"
    split__4_v0 "${replaced_27480}" "
"
    local parts_27481=("${ret_split4_v0[@]}")
    local result_27482=""
    local remaining_width_27483="${max_width_27472}"
    local __range_start_27484=0
    local __length_380=("${parts_27481[@]}")
    local __range_end_27484="${#__length_380[@]}"
    local __dir_27484=$(( ${__range_start_27484} <= ${__range_end_27484} ? 1 : -1 ))
    for (( idx_27484=${__range_start_27484}; idx_27484 * ${__dir_27484} < ${__range_end_27484} * ${__dir_27484}; idx_27484+=${__dir_27484} )); do
        local part_27485="${parts_27481[${idx_27484}]?"Index out of bounds (at src/./filter/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27484 == 0 )) && $([ "_${starts_with_ansi_27479}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27485}" == "_" ]; echo $?) && $(( remaining_width_27483 > 0 )) ))" != 0 ]; then
                truncate_text__1989_v0 "${part_27485}" "${remaining_width_27483}"
                local ret_truncate_text1989_v0__95_35="${ret_truncate_text1989_v0}"
                local truncated_27486="${ret_truncate_text1989_v0__95_35}"
                result_27482+="${truncated_27486}"
                get_visible_len__1988_v0 "${truncated_27486}"
                local ret_get_visible_len1988_v0__97_36="${ret_get_visible_len1988_v0}"
                remaining_width_27483="$(( remaining_width_27483 - ret_get_visible_len1988_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_381
            command_381="$(__p="${part_27485}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27487="${command_381}"
            if [ "$([ "_${m_idx_27487}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_382
                command_382="$(__p="${part_27485}"; printf "%s" "${__p:0:${m_idx_27487}}")"
                __status=$?
                local ansi_params_27488="${command_382}"
                result_27482+="\\x1b[""${ansi_params_27488}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27487}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_27489="${ret_parse_int13_v0__108_41}"
                local text_start_27490="$(( m_idx_num_27489 + 1 ))"
                local command_383
                command_383="$(__p="${part_27485}"; printf "%s" "${__p:${text_start_27490}}")"
                __status=$?
                local text_part_27491="${command_383}"
                if [ "$(( $([ "_${text_part_27491}" == "_" ]; echo $?) && $(( remaining_width_27483 > 0 )) ))" != 0 ]; then
                    truncate_text__1989_v0 "${text_part_27491}" "${remaining_width_27483}"
                    local ret_truncate_text1989_v0__112_39="${ret_truncate_text1989_v0}"
                    local truncated_27492="${ret_truncate_text1989_v0__112_39}"
                    result_27482+="${truncated_27492}"
                    get_visible_len__1988_v0 "${truncated_27492}"
                    local ret_get_visible_len1988_v0__114_40="${ret_get_visible_len1988_v0}"
                    remaining_width_27483="$(( remaining_width_27483 - ret_get_visible_len1988_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27485}" == "_" ]; echo $?) && $(( remaining_width_27483 > 0 )) ))" != 0 ]; then
                    truncate_text__1989_v0 "${part_27485}" "${remaining_width_27483}"
                    local ret_truncate_text1989_v0__119_39="${ret_truncate_text1989_v0}"
                    local truncated_27493="${ret_truncate_text1989_v0__119_39}"
                    result_27482+="${truncated_27493}"
                    get_visible_len__1988_v0 "${truncated_27493}"
                    local ret_get_visible_len1988_v0__121_40="${ret_get_visible_len1988_v0}"
                    remaining_width_27483="$(( remaining_width_27483 - ret_get_visible_len1988_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1990_v0="${result_27482}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1991_v0() {
    local text_27455="${1}"
    local max_width_27456="${2}"
    get_visible_len__1988_v0 "${text_27455}"
    local visible_len_27470="${ret_get_visible_len1988_v0}"
    if [ "$(( visible_len_27470 <= max_width_27456 ))" != 0 ]; then
        ret_cutoff_text1991_v0="${text_27455}"
        return 0
    fi
    truncate_ansi__1990_v0 "${text_27455}" "$(( max_width_27456 - 3 ))"
    local ret_truncate_ansi1990_v0__137_12="${ret_truncate_ansi1990_v0}"
    ret_cutoff_text1991_v0="${ret_truncate_ansi1990_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2012_v0() {
    local format_27504="${1}"
    local args_27505=("${!2}")
    args_27505=("${format_27504}" "${args_27505[@]}")
    __status=$?
    printf "${args_27505[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2013_v0() {
    local message_27502="${1}"
    local color_27503="${2}"
    # Prints an error message with a specified color.
    local array_384=("${message_27502}")
    eprintf__2012_v0 "\\x1b[${color_27503}m%s\\x1b[0m" array_384[@]
}

# colored(message: Text, color: Int)
colored__2014_v0() {
    local message_27422="${1}"
    local color_27423="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2014_v0="\\x1b[${color_27423}m""${message_27422}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2018_v0() {
    local items_27496=("${!1}")
    local total_len_27497="${2}"
    local term_width_27498="${3}"
    local separator_27499=" • "
    local separator_len_27500=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27497 <= term_width_27498 ))" != 0 ]; then
        local iter_27501=0
        while :
        do
            local __length_385=("${items_27496[@]}")
            if [ "$(( iter_27501 >= ${#__length_385[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_27501 > 0 ))" != 0 ]; then
                eprintf_colored__2013_v0 "${separator_27499}" 90
            fi
            colored__2014_v0 "${items_27496[$(( iter_27501 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2014_v0__23_41="${ret_colored2014_v0}"
            local array_386=("")
            eprintf__2012_v0 "${items_27496[${iter_27501}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2014_v0__23_41}" array_386[@]
            iter_27501="$(( iter_27501 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_27506=0
        local first_27507=1
        local iter_27508=0
        while :
        do
            local __length_387=("${items_27496[@]}")
            if [ "$(( iter_27508 >= ${#__length_387[@]} ))" != 0 ]; then
                break
            fi
            local key_27509="${items_27496[${iter_27508}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:35:31)"}"
            local action_27510="${items_27496[$(( iter_27508 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:36:34)"}"
            local __length_388="${key_27509}"
            local __length_389="${action_27510}"
            local part_len_27511="$(( $(( ${#__length_388} + 1 )) + ${#__length_389} ))"
            local needed_27512="${part_len_27511}"
            if [ "$(( ! first_27507 ))" != 0 ]; then
                needed_27512="$(( needed_27512 + separator_len_27500 ))"
            fi
            if [ "$(( $(( current_len_27506 + needed_27512 )) > term_width_27498 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_27507 ))" != 0 ]; then
                eprintf_colored__2013_v0 "${separator_27499}" 90
            fi
            colored__2014_v0 "${action_27510}" 2
            local ret_colored2014_v0__51_33="${ret_colored2014_v0}"
            local array_390=("")
            eprintf__2012_v0 "${key_27509}"" ""${ret_colored2014_v0__51_33}" array_390[@]
            current_len_27506="$(( current_len_27506 + needed_27512 ))"
            first_27507=0
            iter_27508="$(( iter_27508 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2028_v0() {
    local format_27537="${1}"
    local args_27538=("${!2}")
    args_27538=("${format_27537}" "${args_27538[@]}")
    __status=$?
    printf "${args_27538[@]}" >&2
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
    local size_27401="${1}"
    if [ "$([ "_${size_27401}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2055_v0=0
        return 0
    fi
    split__4_v0 "${size_27401}" " "
    local parts_27402=("${ret_split4_v0[@]}")
    local __length_392=("${parts_27402[@]}")
    if [ "$(( ${#__length_392[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2055_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27402[1]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27402[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:68)"}"
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
    local size_27404="${command_394}"
    store_term_size__2055_v0 "${size_27404}"
    ret_query_term_size2056_v0="${ret_store_term_size2055_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2057_v0() {
    local command_395
    command_395="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27400="${command_395}"
    store_term_size__2055_v0 "${size_27400}"
    ret_stty_term_size2057_v0="${ret_store_term_size2055_v0}"
    return 0
}

# get_term_size()
get_term_size__2058_v0() {
    stty_term_size__2057_v0 
    local detected_27403="${ret_stty_term_size2057_v0}"
    if [ "$(( ! detected_27403 ))" != 0 ]; then
        query_term_size__2056_v0 
        detected_27403="${ret_query_term_size2056_v0}"
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
    local cnt_27536="${1}"
    local array_396=("")
    eprintf__2028_v0 "\\x1b[${cnt_27536}A" array_396[@]
}

# go_down(cnt: Int)
go_down__2068_v0() {
    local cnt_27539="${1}"
    local array_397=("")
    eprintf__2028_v0 "\\x1b[${cnt_27539}B" array_397[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__2075_v0() {
    local display_count_27533="${1}"
    local index_27534="${2}"
    local line_27535="${3}"
    go_up__2067_v0 "$(( display_count_27533 - index_27534 ))"
    local array_398=("")
    eprintf__2012_v0 "\\x1b[G\\x1b[K" array_398[@]
    local array_399=("")
    eprintf__2012_v0 "${line_27535}" array_399[@]
    go_down__2068_v0 "$(( display_count_27533 - index_27534 ))"
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
    local total_27451="${1}"
    local limit_27452="${2}"
    _checked_105=()
    local __range_start_27453=0
    local __range_end_27453="${total_27451}"
    local __dir_27453=$(( ${__range_start_27453} <= ${__range_end_27453} ? 1 : -1 ))
    for (( ____27453=${__range_start_27453}; ____27453 * ${__dir_27453} < ${__range_end_27453} * ${__dir_27453}; ____27453+=${__dir_27453} )); do
        local array_403=(0)
        _checked_105+=("${array_403[@]}")
done
    _count_106=0
    _total_107="${total_27451}"
    _limit_108="${limit_27452}"
}

# checked_is(index: Int)
checked_is__2078_v0() {
    local index_27523="${1}"
    ret_checked_is2078_v0="${_checked_105[${index_27523}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_count()
checked_count__2079_v0() {
    ret_checked_count2079_v0="${_count_106}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__2080_v0() {
    local index_27540="${1}"
    if [ "${_checked_105[${index_27540}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_105["${index_27540}"]=0
        _count_106="$(( _count_106 - 1 ))"
        ret_checked_toggle2080_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_108 >= 0 )) && $(( _count_106 >= _limit_108 )) ))" != 0 ]; then
        ret_checked_toggle2080_v0=0
        return 0
    fi
    _checked_105["${index_27540}"]=1
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
    local was_all_27541="$(( _count_106 == _total_107 ))"
    local __range_start_27542=0
    local __range_end_27542="${_total_107}"
    local __dir_27542=$(( ${__range_start_27542} <= ${__range_end_27542} ? 1 : -1 ))
    for (( i_27542=${__range_start_27542}; i_27542 * ${__dir_27542} < ${__range_end_27542} * ${__dir_27542}; i_27542+=${__dir_27542} )); do
        _checked_105["${i_27542}"]="$(( ! was_all_27541 ))"
done
    if [ "${was_all_27541}" != 0 ]; then
        _count_106=0
    else
        _count_106="${_total_107}"
    fi
    ret_checked_all2081_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2093_v0() {
    local pending_27419="${1}"
    local line_27420="${2}"
    local note_at_27421="${3}"
    if [ "$(( note_at_27421 < 0 ))" != 0 ]; then
        local array_404=()
        printf__128_v0 "${pending_27419}""${line_27420}""
" array_404[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27421 == 0 ))" != 0 ]; then
        colored__2014_v0 "${line_27420}" 90
        local ret_colored2014_v0__12_40="${ret_colored2014_v0}"
        local array_405=()
        printf__128_v0 "${pending_27419}""${ret_colored2014_v0__12_40}""
" array_405[@]
    else
        slice__24_v0 "${line_27420}" 0 "${note_at_27421}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27420}" "${note_at_27421}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2014_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2014_v0__13_58="${ret_colored2014_v0}"
        local array_406=()
        printf__128_v0 "${pending_27419}""${ret_slice24_v0__13_32}""${ret_colored2014_v0__13_58}""
" array_406[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2094_v0() {
    local names_27392=("${!1}")
    local texts_27393=("${!2}")
    local notes_27394=("${!3}")
    local min_name_width_27395="${4}"
    local __length_407=("${names_27392[@]}")
    local count_27396="${#__length_407[@]}"
    local name_width_27397="${min_name_width_27395}"
    local __range_start_27398=0
    local __range_end_27398="${count_27396}"
    local __dir_27398=$(( ${__range_start_27398} <= ${__range_end_27398} ? 1 : -1 ))
    for (( i_27398=${__range_start_27398}; i_27398 * ${__dir_27398} < ${__range_end_27398} * ${__dir_27398}; i_27398+=${__dir_27398} )); do
        local __length_408="${names_27392[${i_27398}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:28:33)"}"
        local width_27399="${#__length_408}"
        if [ "$(( width_27399 > name_width_27397 ))" != 0 ]; then
            name_width_27397="${width_27399}"
        fi
done
    term_width__2060_v0 
    local width_27405="${ret_term_width2060_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27406="$(( name_width_27397 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27407="$(( $(( width_27405 - indent_27406 )) < 24 ))"
    if [ "${stacked_27407}" != 0 ]; then
        indent_27406=6
    fi
    local avail_27408="$(( width_27405 - indent_27406 ))"
    rpad__28_v0 "" " " "${indent_27406}"
    local blank_27409="${ret_rpad28_v0}"
    local __range_start_27410=0
    local __range_end_27410="${count_27396}"
    local __dir_27410=$(( ${__range_start_27410} <= ${__range_end_27410} ? 1 : -1 ))
    for (( i_27410=${__range_start_27410}; i_27410 * ${__dir_27410} < ${__range_end_27410} * ${__dir_27410}; i_27410+=${__dir_27410} )); do
        local pending_27411="${blank_27409}"
        if [ "${stacked_27407}" != 0 ]; then
            local array_409=()
            printf__128_v0 "  ""${names_27392[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:48:33)"}""
" array_409[@]
        else
            rpad__28_v0 "  ""${names_27392[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:50:41)"}" " " "${indent_27406}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_27411="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_27393[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_27412=("${ret_split4_v0__52_21[@]}")
        local __length_410=("${words_27412[@]}")
        local note_start_27413="${#__length_410[@]}"
        if [ "$([ "_${notes_27394[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_411="${notes_27394[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_411} > avail_27408 ))" != 0 ]; then
                split__4_v0 "${notes_27394[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_27412+=("${ret_split4_v0__58_26[@]}")
            else
                local array_412=("${notes_27394[${i_27410}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:60:33)"}")
                words_27412+=("${array_412[@]}")
            fi
        fi
        local line_27414=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27415=-1
        local __range_start_27416=0
        local __length_413=("${words_27412[@]}")
        local __range_end_27416="${#__length_413[@]}"
        local __dir_27416=$(( ${__range_start_27416} <= ${__range_end_27416} ? 1 : -1 ))
        for (( j_27416=${__range_start_27416}; j_27416 * ${__dir_27416} < ${__range_end_27416} * ${__dir_27416}; j_27416+=${__dir_27416} )); do
            local word_27417="${words_27412[${j_27416}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:70:32)"}"
            local candidate_27418
            candidate_27418="$(if [ "$([ "_${line_27414}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27417}"; else echo "${line_27414}"" ""${word_27417}"; fi)"
            local __length_414="${candidate_27418}"
            if [ "$(( $(( ${#__length_414} > avail_27408 )) && $([ "_${line_27414}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2093_v0 "${pending_27411}" "${line_27414}" "${note_at_27415}"
                pending_27411="${blank_27409}"
                line_27414="${word_27417}"
                note_at_27415="$(if [ "$(( j_27416 >= note_start_27413 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27416 >= note_start_27413 )) && $(( note_at_27415 < 0 )) ))" != 0 ]; then
                    local __length_415="${candidate_27418}"
                    local __length_416="${word_27417}"
                    note_at_27415="$(( ${#__length_415} - ${#__length_416} ))"
                fi
                line_27414="${candidate_27418}"
            fi
done
        print_help_line__2093_v0 "${pending_27411}" "${line_27414}" "${note_at_27415}"
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
    local raw_27454="${command_419}"
    if [ "$([ "_${raw_27454}" != "_" ]; echo $?)" != 0 ]; then
        _matches_112=()
    else
        split__4_v0 "${raw_27454}" " "
        _matches_112=("${ret_split4_v0[@]}")
    fi
    local __length_421=("${_matches_112[@]}")
    _match_count_113="${#__length_421[@]}"
    _offset_119=0
    _sel_120=0
}

# visible_count()
visible_count__2153_v0() {
    local count_27514="$(( _match_count_113 - _offset_119 ))"
    if [ "$(( count_27514 > _height_118 ))" != 0 ]; then
        count_27514="${_height_118}"
    fi
    if [ "$(( count_27514 < 0 ))" != 0 ]; then
        count_27514=0
    fi
    ret_visible_count2153_v0="${count_27514}"
    return 0
}

# option_index(row: Int)
option_index__2154_v0() {
    local row_27519="${1}"
    parse_int__13_v0 "${_matches_112[$(( _offset_119 + row_27519 ))]?"Index out of bounds (at src/./filter/./mod.ab:52:37)"}"
    __status=$?
    ret_option_index2154_v0="${ret_parse_int13_v0}"
    return 0
}

# option_width()
option_width__2155_v0() {
    local check_width_27520
    check_width_27520="$(if [ "${_multi_121}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_422="${_cursor_117}"
    ret_option_width2155_v0="$(( $(( _term_width_123 - ${#__length_422} )) - check_width_27520 ))"
    return 0
}

# row_line(row: Int, highlighted: Bool)
row_line__2156_v0() {
    local row_27517="${1}"
    local highlighted_27518="${2}"
    option_index__2154_v0 "${row_27517}"
    local ret_option_index2154_v0__61_44="${ret_option_index2154_v0}"
    option_width__2155_v0 
    local ret_option_width2155_v0__61_64="${ret_option_width2155_v0}"
    cutoff_text__1991_v0 "${_options_110[${ret_option_index2154_v0__61_44}]?"Index out of bounds (at src/./filter/./mod.ab:61:44)"}" "${ret_option_width2155_v0__61_64}"
    local truncated_27521="${ret_cutoff_text1991_v0}"
    local __length_423="${_cursor_117}"
    rpad__28_v0 "" " " "${#__length_423}"
    local blank_27522="${ret_rpad28_v0}"
    if [ "$(( ! _multi_121 ))" != 0 ]; then
        if [ "${highlighted_27518}" != 0 ]; then
            colored_secondary__1960_v0 "${_cursor_117}""${truncated_27521}"
            ret_row_line2156_v0="${ret_colored_secondary1960_v0}"
            return 0
        fi
        ret_row_line2156_v0="${blank_27522}""${truncated_27521}"
        return 0
    fi
    option_index__2154_v0 "${row_27517}"
    local ret_option_index2154_v0__69_31="${ret_option_index2154_v0}"
    checked_is__2078_v0 "${ret_option_index2154_v0__69_31}"
    local ticked_27524="${ret_checked_is2078_v0}"
    local mark_27525
    mark_27525="$(if [ "${ticked_27524}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    if [ "${highlighted_27518}" != 0 ]; then
        colored_secondary__1960_v0 "${_cursor_117}""${mark_27525}""${truncated_27521}"
        ret_row_line2156_v0="${ret_colored_secondary1960_v0}"
        return 0
    fi
    if [ "${ticked_27524}" != 0 ]; then
        colored_secondary__1960_v0 "${mark_27525}""${truncated_27521}"
        local ret_colored_secondary1960_v0__75_24="${ret_colored_secondary1960_v0}"
        ret_row_line2156_v0="${blank_27522}""${ret_colored_secondary1960_v0__75_24}"
        return 0
    fi
    ret_row_line2156_v0="${blank_27522}""${mark_27525}""${truncated_27521}"
    return 0
}

# render_rows()
render_rows__2157_v0() {
    visible_count__2153_v0 
    local count_27515="${ret_visible_count2153_v0}"
    go_up__1912_v0 "${_height_118}"
    local array_424=("")
    eprintf__1857_v0 "\\x1b[G" array_424[@]
    local __range_start_27516=0
    local __range_end_27516="${count_27515}"
    local __dir_27516=$(( ${__range_start_27516} <= ${__range_end_27516} ? 1 : -1 ))
    for (( row_27516=${__range_start_27516}; row_27516 * ${__dir_27516} < ${__range_end_27516} * ${__dir_27516}; row_27516+=${__dir_27516} )); do
        row_line__2156_v0 "${row_27516}" "$(( row_27516 == _sel_120 ))"
        local ret_row_line2156_v0__86_28="${ret_row_line2156_v0}"
        local array_425=("")
        eprintf__1857_v0 "\\x1b[K""${ret_row_line2156_v0__86_28}""
" array_425[@]
done
    local __range_start_27526="${count_27515}"
    local __range_end_27526="${_height_118}"
    local __dir_27526=$(( ${__range_start_27526} <= ${__range_end_27526} ? 1 : -1 ))
    for (( ____27526=${__range_start_27526}; ____27526 * ${__dir_27526} < ${__range_end_27526} * ${__dir_27526}; ____27526+=${__dir_27526} )); do
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
    local step_27529="${1}"
    visible_count__2153_v0 
    local count_27530="${ret_visible_count2153_v0}"
    if [ "$(( count_27530 == 0 ))" != 0 ]; then
        ret_move_selection2161_v0=0
        return 0
    fi
    local next_27531="$(( _sel_120 + step_27529 ))"
    if [ "$(( $(( next_27531 >= 0 )) && $(( next_27531 < count_27530 )) ))" != 0 ]; then
        local prev_27532="${_sel_120}"
        _sel_120="${next_27531}"
        row_line__2156_v0 "${prev_27532}" 0
        local ret_row_line2156_v0__132_35="${ret_row_line2156_v0}"
        redraw_row__2075_v0 "${_height_118}" "${prev_27532}" "${ret_row_line2156_v0__132_35}"
        row_line__2156_v0 "${_sel_120}" 1
        local ret_row_line2156_v0__133_35="${ret_row_line2156_v0}"
        redraw_row__2075_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2156_v0__133_35}"
        ret_move_selection2161_v0=0
        return 0
    fi
    if [ "$(( $(( next_27531 < 0 )) && $(( _offset_119 > 0 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 - 1 ))"
        ret_move_selection2161_v0=1
        return 0
    fi
    if [ "$(( $(( next_27531 >= count_27530 )) && $(( $(( _offset_119 + _height_118 )) < _match_count_113 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 + 1 ))"
        ret_move_selection2161_v0=1
        return 0
    fi
    ret_move_selection2161_v0=0
    return 0
}

# xyl_filter(options: [Text], prompt: Text, placeholder: Text, header: Text, cursor: Text, multi: Bool, limit: Int, height: Int)
xyl_filter__2162_v0() {
    local options_27437=("${!1}")
    local prompt_27438="${2}"
    local placeholder_27439="${3}"
    local header_27440="${4}"
    local cursor_27441="${5}"
    local multi_27442="${6}"
    local limit_27443="${7}"
    local height_27444="${8}"
    local __length_437=("${options_27437[@]}")
    local total_27445="${#__length_437[@]}"
    if [ "$(( total_27445 == 0 ))" != 0 ]; then
        eprintf_colored__1858_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    _options_110=("${options_27437[@]}")
    _option_count_111="${total_27445}"
    _query_114=""
    _prompt_116="${prompt_27438}"
    _placeholder_115="${placeholder_27439}"
    _cursor_117="${cursor_27441}"
    _multi_121="${multi_27442}"
    _has_header_122="$([ "_${header_27440}" == "_" ]; echo $?)"
    _offset_119=0
    _sel_120=0
    stty_lock__1898_v0 
    hide_cursor__1915_v0 
    term_width__1905_v0 
    _term_width_123="${ret_term_width1905_v0}"
    term_height__1906_v0 
    local ret_term_height1906_v0__189_24="${ret_term_height1906_v0}"
    local max_height_27450
    max_height_27450="$(( ret_term_height1906_v0__189_24 - $(if [ "${_has_header_122}" != 0 ]; then echo 4; else echo 3; fi) ))"
    _height_118="${height_27444}"
    if [ "$(( _height_118 > max_height_27450 ))" != 0 ]; then
        _height_118="${max_height_27450}"
    fi
    if [ "$(( _height_118 < 1 ))" != 0 ]; then
        _height_118=1
    fi
    if [ "${multi_27442}" != 0 ]; then
        checked_init__2077_v0 "${total_27445}" "${limit_27443}"
    fi
    refresh_matches__2152_v0 
    if [ "${_has_header_122}" != 0 ]; then
        cutoff_text__1991_v0 "${header_27440}" "${_term_width_123}"
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
        local key_27528="${ret_get_key1855_v0}"
        if [ "$([ "_${key_27528}" != "_INPUT" ]; echo $?)" != 0 ]; then
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
        elif [ "$([ "_${key_27528}" != "_UP" ]; echo $?)" != 0 ]; then
            move_selection__2161_v0 -1
            local ret_move_selection2161_v0__231_20="${ret_move_selection2161_v0}"
            if [ "${ret_move_selection2161_v0__231_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$([ "_${key_27528}" != "_DOWN" ]; echo $?)" != 0 ]; then
            move_selection__2161_v0 1
            local ret_move_selection2161_v0__236_20="${ret_move_selection2161_v0}"
            if [ "${ret_move_selection2161_v0__236_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27528}" != "_TAB" ]; echo $?) ))" != 0 ]; then
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
        elif [ "$(( _multi_121 && $([ "_${key_27528}" != "_CTRL_A" ]; echo $?) ))" != 0 ]; then
            checked_all__2081_v0 
            local ret_checked_all2081_v0__248_20="${ret_checked_all2081_v0}"
            if [ "${ret_checked_all2081_v0__248_20}" != 0 ]; then
                render_rows__2157_v0 
            fi
        elif [ "$([ "_${key_27528}" != "_BACKSPACE" ]; echo $?)" != 0 ]; then
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
            local typed_27543="${key_27528}"
            if [ "$([ "_${key_27528}" != "_SPACE" ]; echo $?)" != 0 ]; then
                typed_27543=" "
            fi
            local __length_442="${typed_27543}"
            if [ "$(( ${#__length_442} == 1 ))" != 0 ]; then
                _query_114+="${typed_27543}"
                refresh_matches__2152_v0 
                render_rows__2157_v0 
                render_query__2158_v0 
                render_count__2159_v0 
            fi
        fi
    done
    local total_lines_27544="$(( _height_118 + 3 ))"
    if [ "${_has_header_122}" != 0 ]; then
        total_lines_27544="$(( total_lines_27544 + 1 ))"
    fi
    go_down__1913_v0 1
    remove_line__1908_v0 "$(( total_lines_27544 - 1 ))"
    remove_current_line__1909_v0 
    stty_unlock__1899_v0 
    show_cursor__1916_v0 
    local result_27549=()
    if [ "${_multi_121}" != 0 ]; then
        local __range_start_27550=0
        local __range_end_27550="${total_27445}"
        local __dir_27550=$(( ${__range_start_27550} <= ${__range_end_27550} ? 1 : -1 ))
        for (( i_27550=${__range_start_27550}; i_27550 * ${__dir_27550} < ${__range_end_27550} * ${__dir_27550}; i_27550+=${__dir_27550} )); do
            checked_is__2078_v0 "${i_27550}"
            local ret_checked_is2078_v0__294_16="${ret_checked_is2078_v0}"
            if [ "${ret_checked_is2078_v0__294_16}" != 0 ]; then
                local array_444=("${_options_110[${i_27550}]?"Index out of bounds (at src/./filter/./mod.ab:295:37)"}")
                result_27549+=("${array_444[@]}")
            fi
done
        ret_xyl_filter2162_v0=("${result_27549[@]}")
        return 0
    fi
    visible_count__2153_v0 
    local ret_visible_count2153_v0__300_8="${ret_visible_count2153_v0}"
    if [ "$(( ret_visible_count2153_v0__300_8 > 0 ))" != 0 ]; then
        option_index__2154_v0 "${_sel_120}"
        local ret_option_index2154_v0__301_29="${ret_option_index2154_v0}"
        result_27549+=("${_options_110[${ret_option_index2154_v0__301_29}]?"Index out of bounds (at src/./filter/./mod.ab:301:29)"}")
    fi
    ret_xyl_filter2162_v0=("${result_27549[@]}")
    return 0
}

# print_filter_help()
print_filter_help__2262_v0() {
    local usage_27350=("Usage:" "./xylitol.sh" "filter" "[<options>" "...]" "[flags]")
    print_wrapped__1917_v0 usage_27350[@]
    printf '%s\n' ""
    colored_primary__1959_v0 "filter"
    local ret_colored_primary1959_v0__8_20="${ret_colored_primary1959_v0}"
    local title_27390=("${ret_colored_primary1959_v0__8_20}" "-" "Pick" "from" "a" "list" "narrowed" "by" "typing.")
    print_wrapped__1917_v0 title_27390[@]
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
    local names_27424=("-h, --help" "--limit=<number>" "--no-limit" "--prompt=\"<text>\"" "--placeholder=\"<text>\"" "--cursor=\"<text>\"" "--header=\"<text>\"" "--height=<number>")
    local texts_27425=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the text shown in front of the query" "Set the text shown while the query is empty" "Set the cursor text" "Set a header text to display above the query" "Set the number of options shown at once")
    local notes_27426=("" "" "" "(default: '/ ')" "(default: 'Filter...')" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__2094_v0 names_27424[@] texts_27425[@] notes_27426[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__2320_v0() {
    local options_27343=()
    local command_457
    command_457="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_27344="${command_457}"
    if [ "$([ "_${is_tty_27344}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_27343+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options2320_v0=("${options_27343[@]}")
    return 0
}

# execute_filter(parameters: [Text])
execute_filter__2321_v0() {
    local parameters_27338=("${!1}")
    local cursor_27339="> "
    local prompt_27340="/ "
    local placeholder_27341="Filter..."
    local header_27342=""
    read_stdin_options__2320_v0 
    local options_27345=("${ret_read_stdin_options2320_v0[@]}")
    local multi_27346=0
    local limit_27347=-1
    local height_27348=10
    local __length_461=("${parameters_27338[@]}")
    local slice_upper_460="${#__length_461[@]}"
    local slice_offset_462=2
    local slice_offset_462=$((${slice_offset_462} > 0 ? ${slice_offset_462} : 0))
    local slice_length_463="$(( slice_upper_460 - slice_offset_462 ))"
    local slice_length_463=$((${slice_length_463} > 0 ? ${slice_length_463} : 0))
    for param_27349 in "${parameters_27338[@]:${slice_offset_462}:${slice_length_463}}"; do
        starts_with__22_v0 "${param_27349}" "--cursor="
        local ret_starts_with22_v0__31_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27349}" "--prompt="
        local ret_starts_with22_v0__34_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27349}" "--placeholder="
        local ret_starts_with22_v0__37_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27349}" "--header="
        local ret_starts_with22_v0__40_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27349}" "--limit="
        local ret_starts_with22_v0__43_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27349}" "--height="
        local ret_starts_with22_v0__54_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27349}" != "_-h" ]; echo $?) || $([ "_${param_27349}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_filter_help__2262_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__31_13}" != 0 ]; then
            local __length_464="--cursor="
            slice__24_v0 "${param_27349}" "${#__length_464}" 0
            cursor_27339="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__34_13}" != 0 ]; then
            local __length_465="--prompt="
            slice__24_v0 "${param_27349}" "${#__length_465}" 0
            prompt_27340="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__37_13}" != 0 ]; then
            local __length_466="--placeholder="
            slice__24_v0 "${param_27349}" "${#__length_466}" 0
            placeholder_27341="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__40_13}" != 0 ]; then
            local __length_467="--header="
            slice__24_v0 "${param_27349}" "${#__length_467}" 0
            header_27342="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__43_13}" != 0 ]; then
            local __length_468="--limit="
            slice__24_v0 "${param_27349}" "${#__length_468}" 0
            local value_27427="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27427}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1858_v0 "ERROR: Invalid limit value: ""${value_27427}""
" 31
                exit 1
            fi
            limit_27347="${ret_parse_int13_v0}"
            multi_27346=1
        elif [ "$([ "_${param_27349}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_27346=1
        elif [ "${ret_starts_with22_v0__54_13}" != 0 ]; then
            local __length_469="--height="
            slice__24_v0 "${param_27349}" "${#__length_469}" 0
            local value_27432="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27432}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1858_v0 "ERROR: Invalid height value: ""${value_27432}""
" 31
                exit 1
            fi
            height_27348="${ret_parse_int13_v0}"
        else
            options_27345+=("${param_27349}")
        fi
    done
    has_ansi_escape__1983_v0 "${header_27342}"
    local ret_has_ansi_escape1983_v0__67_44="${ret_has_ansi_escape1983_v0}"
    escape_ansi__1984_v0 "${header_27342}"
    local ret_escape_ansi1984_v0__67_73="${ret_escape_ansi1984_v0}"
    colored_primary__1959_v0 "${header_27342}"
    local ret_colored_primary1959_v0__67_111="${ret_colored_primary1959_v0}"
    local display_header_27436
    display_header_27436="$(if [ "$(( $([ "_${header_27342}" != "_" ]; echo $?) || ret_has_ansi_escape1983_v0__67_44 ))" != 0 ]; then echo "${ret_escape_ansi1984_v0__67_73}"; else echo "\\x1b[1m""${ret_colored_primary1959_v0__67_111}"; fi)"
    xyl_filter__2162_v0 options_27345[@] "${prompt_27340}" "${placeholder_27341}" "${display_header_27436}" "${cursor_27339}" "${multi_27346}" "${limit_27347}" "${height_27348}"
    local results_27551=("${ret_xyl_filter2162_v0[@]}")
    join__7_v0 results_27551[@] "
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
    local format_29606="${1}"
    local args_29607=("${!2}")
    args_29607=("${format_29606}" "${args_29607[@]}")
    __status=$?
    printf "${args_29607[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2448_v0() {
    local message_29604="${1}"
    local color_29605="${2}"
    # Prints an error message with a specified color.
    local array_472=("${message_29604}")
    eprintf__2447_v0 "\\x1b[${color_29605}m%s\\x1b[0m" array_472[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2463_v0() {
    local format_29616="${1}"
    local args_29617=("${!2}")
    args_29617=("${format_29616}" "${args_29617[@]}")
    __status=$?
    printf "${args_29617[@]}" >&2
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
        local disabled_29562
        disabled_29562="$([ "_${command_473}" != "_No" ]; echo $?)"
        local command_474
        command_474="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29563
        found_29563="$(( $(( ! disabled_29562 )) && $([ "_${command_474}" != "_0" ]; echo $?) ))"
        _perl_state_126="$(if [ "${found_29563}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2470_v0="$([ "_${_perl_state_126}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2471_v0() {
    local text_29561="${1}"
    perl_available__2470_v0 
    local ret_perl_available2470_v0__19_12="${ret_perl_available2470_v0}"
    if [ "$(( ! ret_perl_available2470_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return 1
    fi
    local command_475
    command_475="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29561}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return "${__status}"
    fi
    local width_str_29564="${command_475}"
    parse_int__13_v0 "${width_str_29564}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2471_v0=''
        return "${__status}"
    fi
    local width_29565="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2471_v0="${width_29565}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2476_v0() {
    local text_29551="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_476
    command_476="$([[ "${text_29551}" == *$'\x1b'* || "${text_29551}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29552="${command_476}"
    ret_has_ansi_escape2476_v0="$([ "_${has_escape_29552}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2478_v0() {
    local text_29557="${1}"
    local command_477
    command_477="$(printf "%s" "${text_29557}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2478_v0="${command_477}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2479_v0() {
    local text_29559="${1}"
    local command_478
    command_478="$(printf "%s" "${text_29559}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29560="${command_478}"
    ret_is_all_ascii2479_v0="$([ "_${result_29560}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2480_v0() {
    local text_29554="${1}"
    local command_479
    command_479="$(LC_ALL=C; __t="${text_29554}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29555="${command_479}"
    parse_int__13_v0 "${measured_29555}"
    __status=$?
    ret_plain_len2480_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2481_v0() {
    local text_29553="${1}"
    plain_len__2480_v0 "${text_29553}"
    local plain_29556="${ret_plain_len2480_v0}"
    if [ "$(( plain_29556 >= 0 ))" != 0 ]; then
        ret_get_visible_len2481_v0="${plain_29556}"
        return 0
    fi
    strip_ansi__2478_v0 "${text_29553}"
    local stripped_29558="${ret_strip_ansi2478_v0}"
    is_all_ascii__2479_v0 "${stripped_29558}"
    local ret_is_all_ascii2479_v0__46_12="${ret_is_all_ascii2479_v0}"
    if [ "$(( ! ret_is_all_ascii2479_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2471_v0 "${stripped_29558}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_480="${stripped_29558}"
            ret_get_visible_len2481_v0="${#__length_480}"
            return 0
        fi
        ret_get_visible_len2481_v0="${ret_perl_get_cjk_width2471_v0}"
        return 0
    fi
    local __length_481="${stripped_29558}"
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
    local count_29614="${command_483}"
    parse_int__13_v0 "${count_29614}"
    __status=$?
    ret_stty_count2487_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2488_v0() {
    stty_count__2487_v0 
    local count_num_29615="${ret_stty_count2487_v0}"
    if [ "$(( count_num_29615 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_29615="$(( count_num_29615 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29615}
    __status=$?
}

# stty_unlock()
stty_unlock__2489_v0() {
    stty_count__2487_v0 
    local count_num_29709="${ret_stty_count2487_v0}"
    if [ "$(( count_num_29709 > 0 ))" != 0 ]; then
        count_num_29709="$(( count_num_29709 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29709}
        __status=$?
        if [ "$(( count_num_29709 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2490_v0() {
    local size_29542="${1}"
    if [ "$([ "_${size_29542}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2490_v0=0
        return 0
    fi
    split__4_v0 "${size_29542}" " "
    local parts_29543=("${ret_split4_v0[@]}")
    local __length_484=("${parts_29543[@]}")
    if [ "$(( ${#__length_484[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2490_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29543[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29543[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
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
    local size_29545="${command_486}"
    store_term_size__2490_v0 "${size_29545}"
    ret_query_term_size2491_v0="${ret_store_term_size2490_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2492_v0() {
    local command_487
    command_487="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29541="${command_487}"
    store_term_size__2490_v0 "${size_29541}"
    ret_stty_term_size2492_v0="${ret_store_term_size2490_v0}"
    return 0
}

# get_term_size()
get_term_size__2493_v0() {
    stty_term_size__2492_v0 
    local detected_29544="${ret_stty_term_size2492_v0}"
    if [ "$(( ! detected_29544 ))" != 0 ]; then
        query_term_size__2491_v0 
        detected_29544="${ret_query_term_size2491_v0}"
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
    local cnt_29706="${1}"
    if [ "$(( cnt_29706 > 0 ))" != 0 ]; then
        local sequence_29707=""
        local __range_start_29708=0
        local __range_end_29708="${cnt_29706}"
        local __dir_29708=$(( ${__range_start_29708} <= ${__range_end_29708} ? 1 : -1 ))
        for (( ____29708=${__range_start_29708}; ____29708 * ${__dir_29708} < ${__range_end_29708} * ${__dir_29708}; ____29708+=${__dir_29708} )); do
            sequence_29707+="\\x1b[2K\\x1b[1A"
done
        local array_488=("")
        eprintf__2463_v0 "${sequence_29707}" array_488[@]
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
    local cnt_29702="${1}"
    local array_491=("")
    eprintf__2463_v0 "\\x1b[${cnt_29702}A" array_491[@]
}

# go_down(cnt: Int)
go_down__2503_v0() {
    local cnt_29705="${1}"
    local array_492=("")
    eprintf__2463_v0 "\\x1b[${cnt_29705}B" array_492[@]
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
    local pieces_29540=("${!1}")
    term_width__2495_v0 
    local width_29546="${ret_term_width2495_v0}"
    local line_29547=""
    local line_len_29548=0
    for piece_29549 in "${pieces_29540[@]}"; do
        local __length_497="${piece_29549}"
        local piece_len_29550="${#__length_497}"
        has_ansi_escape__2476_v0 "${piece_29549}"
        local ret_has_ansi_escape2476_v0__186_12="${ret_has_ansi_escape2476_v0}"
        if [ "${ret_has_ansi_escape2476_v0__186_12}" != 0 ]; then
            get_visible_len__2481_v0 "${piece_29549}"
            piece_len_29550="${ret_get_visible_len2481_v0}"
        fi
        if [ "$([ "_${line_29547}" != "_" ]; echo $?)" != 0 ]; then
            line_29547="${piece_29549}"
            line_len_29548="${piece_len_29550}"
        elif [ "$(( $(( $(( line_len_29548 + 1 )) + piece_len_29550 )) > width_29546 ))" != 0 ]; then
            local array_498=()
            printf__128_v0 "${line_29547}""
" array_498[@]
            line_29547="${piece_29549}"
            line_len_29548="${piece_len_29550}"
        else
            line_29547+=" ""${piece_29549}"
            line_len_29548="$(( line_len_29548 + $(( 1 + piece_len_29550 )) ))"
        fi
    done
    if [ "$([ "_${line_29547}" == "_" ]; echo $?)" != 0 ]; then
        local array_499=()
        printf__128_v0 "${line_29547}""
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
    local config_29535="${ret_env_var_get120_v0}"
    _supports_truecolor_131="$(if [ "$([ "_${config_29535}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2544_v0="$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2545_v0() {
    local message_29530="${1}"
    local r_29531="${2}"
    local g_29532="${3}"
    local b_29533="${4}"
    local fallback_29534="${5}"
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2545_v0="\\x1b[38;2;${r_29531};${g_29532};${b_29533}m""${message_29530}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2544_v0 
        local ret_get_supports_truecolor2544_v0__45_17="${ret_get_supports_truecolor2544_v0}"
        if [ "${ret_get_supports_truecolor2544_v0__45_17}" != 0 ]; then
            ret_colored_rgb2545_v0="\\x1b[38;2;${r_29531};${g_29532};${b_29533}m""${message_29530}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_29534 == 0 ))" != 0 ]; then
            ret_colored_rgb2545_v0="${message_29530}"
            return 0
        else
            ret_colored_rgb2545_v0="\\x1b[${fallback_29534}m""${message_29530}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_29534 == 0 ))" != 0 ]; then
            ret_colored_rgb2545_v0="${message_29530}"
            return 0
        fi
        ret_colored_rgb2545_v0="\\x1b[${fallback_29534}m""${message_29530}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__2546_v0() {
    local message_29679="${1}"
    local r_29680="${2}"
    local g_29681="${3}"
    local b_29682="${4}"
    local fallback_29683="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_29684="${fallback_29683}"
    if [ "$(( $(( fallback_29683 >= 30 )) && $(( fallback_29683 <= 37 )) ))" != 0 ]; then
        bg_fallback_29684="$(( fallback_29683 + 10 ))"
    fi
    if [ "$(( $(( fallback_29683 >= 90 )) && $(( fallback_29683 <= 97 )) ))" != 0 ]; then
        bg_fallback_29684="$(( fallback_29683 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb2546_v0="\\x1b[48;2;${r_29680};${g_29681};${b_29682}m""${message_29679}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2544_v0 
        local ret_get_supports_truecolor2544_v0__87_17="${ret_get_supports_truecolor2544_v0}"
        if [ "${ret_get_supports_truecolor2544_v0__87_17}" != 0 ]; then
            ret_background_rgb2546_v0="\\x1b[48;2;${r_29680};${g_29681};${b_29682}m""${message_29679}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_29684 == 0 ))" != 0 ]; then
            ret_background_rgb2546_v0="${message_29679}"
            return 0
        else
            ret_background_rgb2546_v0="\\x1b[${bg_fallback_29684}m""${message_29679}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_29684 == 0 ))" != 0 ]; then
            ret_background_rgb2546_v0="${message_29679}"
            return 0
        fi
        ret_background_rgb2546_v0="\\x1b[${bg_fallback_29684}m""${message_29679}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2547_v0() {
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_29524="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_29524}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_29524}" ";"
            local parts_29525=("${ret_split4_v0[@]}")
            local __length_503=("${parts_29525[@]}")
            if [ "$(( ${#__length_503[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29525[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29525[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_29526="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_29526}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_29526}" ";"
            local parts_29527=("${ret_split4_v0[@]}")
            local __length_505=("${parts_29527[@]}")
            if [ "$(( ${#__length_505[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29527[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29527[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29527[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29527[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_29528="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_29528}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_29528}" ";"
            local parts_29529=("${ret_split4_v0[@]}")
            local __length_507=("${parts_29529[@]}")
            if [ "$(( ${#__length_507[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29529[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29529[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29529[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2547_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29529[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
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
    local message_29523="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    colored_rgb__2545_v0 "${message_29523}" "${_primary_color_133[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_133[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_133[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_133[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2549_v0="${ret_colored_rgb2545_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2550_v0() {
    local message_29567="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    colored_rgb__2545_v0 "${message_29567}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2550_v0="${ret_colored_rgb2545_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__2553_v0() {
    local message_29678="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2548_v0 
    fi
    background_rgb__2546_v0 "${message_29678}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
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
        local disabled_29630
        disabled_29630="$([ "_${command_509}" != "_No" ]; echo $?)"
        local command_510
        command_510="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29631
        found_29631="$(( $(( ! disabled_29630 )) && $([ "_${command_510}" != "_0" ]; echo $?) ))"
        _perl_state_136="$(if [ "${found_29631}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2567_v0="$([ "_${_perl_state_136}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2568_v0() {
    local text_29629="${1}"
    perl_available__2567_v0 
    local ret_perl_available2567_v0__19_12="${ret_perl_available2567_v0}"
    if [ "$(( ! ret_perl_available2567_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return 1
    fi
    local command_511
    command_511="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29629}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return "${__status}"
    fi
    local width_str_29632="${command_511}"
    parse_int__13_v0 "${width_str_29632}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2568_v0=''
        return "${__status}"
    fi
    local width_29633="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2568_v0="${width_29633}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2569_v0() {
    local text_29640="${1}"
    local max_width_29641="${2}"
    perl_available__2567_v0 
    local ret_perl_available2567_v0__30_12="${ret_perl_available2567_v0}"
    if [ "$(( ! ret_perl_available2567_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2569_v0=''
        return 1
    fi
    local command_512
    command_512="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_29640}" ${max_width_29641} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2569_v0=''
        return "${__status}"
    fi
    local result_29642="${command_512}"
    ret_perl_truncate_cjk2569_v0="${result_29642}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2573_v0() {
    local text_29608="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_513
    command_513="$([[ "${text_29608}" == *$'\x1b'* || "${text_29608}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29609="${command_513}"
    ret_has_ansi_escape2573_v0="$([ "_${has_escape_29609}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2574_v0() {
    local text_29610="${1}"
    local command_514
    command_514="$(printf '%s' "${text_29610}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2574_v0="${command_514}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2575_v0() {
    local text_29625="${1}"
    local command_515
    command_515="$(printf "%s" "${text_29625}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2575_v0="${command_515}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2576_v0() {
    local text_29627="${1}"
    local command_516
    command_516="$(printf "%s" "${text_29627}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29628="${command_516}"
    ret_is_all_ascii2576_v0="$([ "_${result_29628}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2577_v0() {
    local text_29622="${1}"
    local command_517
    command_517="$(LC_ALL=C; __t="${text_29622}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29623="${command_517}"
    parse_int__13_v0 "${measured_29623}"
    __status=$?
    ret_plain_len2577_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2578_v0() {
    local text_29621="${1}"
    plain_len__2577_v0 "${text_29621}"
    local plain_29624="${ret_plain_len2577_v0}"
    if [ "$(( plain_29624 >= 0 ))" != 0 ]; then
        ret_get_visible_len2578_v0="${plain_29624}"
        return 0
    fi
    strip_ansi__2575_v0 "${text_29621}"
    local stripped_29626="${ret_strip_ansi2575_v0}"
    is_all_ascii__2576_v0 "${stripped_29626}"
    local ret_is_all_ascii2576_v0__46_12="${ret_is_all_ascii2576_v0}"
    if [ "$(( ! ret_is_all_ascii2576_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2568_v0 "${stripped_29626}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_518="${stripped_29626}"
            ret_get_visible_len2578_v0="${#__length_518}"
            return 0
        fi
        ret_get_visible_len2578_v0="${ret_perl_get_cjk_width2568_v0}"
        return 0
    fi
    local __length_519="${stripped_29626}"
    ret_get_visible_len2578_v0="${#__length_519}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2579_v0() {
    local text_29637="${1}"
    local max_width_29638="${2}"
    get_visible_len__2578_v0 "${text_29637}"
    local visible_len_29639="${ret_get_visible_len2578_v0}"
    if [ "$(( visible_len_29639 <= max_width_29638 ))" != 0 ]; then
        ret_truncate_text2579_v0="${text_29637}"
        return 0
    fi
    is_all_ascii__2576_v0 "${text_29637}"
    local ret_is_all_ascii2576_v0__61_12="${ret_is_all_ascii2576_v0}"
    if [ "$(( ! ret_is_all_ascii2576_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__2569_v0 "${text_29637}" "${max_width_29638}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_29637}" | cut -c1-${max_width_29638}
            __status=$?
        fi
        ret_truncate_text2579_v0="${ret_perl_truncate_cjk2569_v0}"
        return 0
    fi
    local command_520
    command_520="$(printf "%s" "${text_29637}" | cut -c1-${max_width_29638})"
    __status=$?
    ret_truncate_text2579_v0="${command_520}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2580_v0() {
    local text_29635="${1}"
    local max_width_29636="${2}"
    has_ansi_escape__2573_v0 "${text_29635}"
    local ret_has_ansi_escape2573_v0__73_12="${ret_has_ansi_escape2573_v0}"
    if [ "$(( ! ret_has_ansi_escape2573_v0__73_12 ))" != 0 ]; then
        truncate_text__2579_v0 "${text_29635}" "${max_width_29636}"
        ret_truncate_ansi2580_v0="${ret_truncate_text2579_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_521
    command_521="$([[ "${text_29635}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_29643="${command_521}"
    # Replace \x1b[ with newline, then split
    local command_522
    command_522="$(t="${text_29635}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_29644="${command_522}"
    split__4_v0 "${replaced_29644}" "
"
    local parts_29645=("${ret_split4_v0[@]}")
    local result_29646=""
    local remaining_width_29647="${max_width_29636}"
    local __range_start_29648=0
    local __length_523=("${parts_29645[@]}")
    local __range_end_29648="${#__length_523[@]}"
    local __dir_29648=$(( ${__range_start_29648} <= ${__range_end_29648} ? 1 : -1 ))
    for (( idx_29648=${__range_start_29648}; idx_29648 * ${__dir_29648} < ${__range_end_29648} * ${__dir_29648}; idx_29648+=${__dir_29648} )); do
        local part_29649="${parts_29645[${idx_29648}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_29648 == 0 )) && $([ "_${starts_with_ansi_29643}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_29649}" == "_" ]; echo $?) && $(( remaining_width_29647 > 0 )) ))" != 0 ]; then
                truncate_text__2579_v0 "${part_29649}" "${remaining_width_29647}"
                local ret_truncate_text2579_v0__95_35="${ret_truncate_text2579_v0}"
                local truncated_29650="${ret_truncate_text2579_v0__95_35}"
                result_29646+="${truncated_29650}"
                get_visible_len__2578_v0 "${truncated_29650}"
                local ret_get_visible_len2578_v0__97_36="${ret_get_visible_len2578_v0}"
                remaining_width_29647="$(( remaining_width_29647 - ret_get_visible_len2578_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_524
            command_524="$(__p="${part_29649}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_29651="${command_524}"
            if [ "$([ "_${m_idx_29651}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_525
                command_525="$(__p="${part_29649}"; printf "%s" "${__p:0:${m_idx_29651}}")"
                __status=$?
                local ansi_params_29652="${command_525}"
                result_29646+="\\x1b[""${ansi_params_29652}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_29651}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_29653="${ret_parse_int13_v0__108_41}"
                local text_start_29654="$(( m_idx_num_29653 + 1 ))"
                local command_526
                command_526="$(__p="${part_29649}"; printf "%s" "${__p:${text_start_29654}}")"
                __status=$?
                local text_part_29655="${command_526}"
                if [ "$(( $([ "_${text_part_29655}" == "_" ]; echo $?) && $(( remaining_width_29647 > 0 )) ))" != 0 ]; then
                    truncate_text__2579_v0 "${text_part_29655}" "${remaining_width_29647}"
                    local ret_truncate_text2579_v0__112_39="${ret_truncate_text2579_v0}"
                    local truncated_29656="${ret_truncate_text2579_v0__112_39}"
                    result_29646+="${truncated_29656}"
                    get_visible_len__2578_v0 "${truncated_29656}"
                    local ret_get_visible_len2578_v0__114_40="${ret_get_visible_len2578_v0}"
                    remaining_width_29647="$(( remaining_width_29647 - ret_get_visible_len2578_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_29649}" == "_" ]; echo $?) && $(( remaining_width_29647 > 0 )) ))" != 0 ]; then
                    truncate_text__2579_v0 "${part_29649}" "${remaining_width_29647}"
                    local ret_truncate_text2579_v0__119_39="${ret_truncate_text2579_v0}"
                    local truncated_29657="${ret_truncate_text2579_v0__119_39}"
                    result_29646+="${truncated_29657}"
                    get_visible_len__2578_v0 "${truncated_29657}"
                    local ret_get_visible_len2578_v0__121_40="${ret_get_visible_len2578_v0}"
                    remaining_width_29647="$(( remaining_width_29647 - ret_get_visible_len2578_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2580_v0="${result_29646}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2581_v0() {
    local text_29619="${1}"
    local max_width_29620="${2}"
    get_visible_len__2578_v0 "${text_29619}"
    local visible_len_29634="${ret_get_visible_len2578_v0}"
    if [ "$(( visible_len_29634 <= max_width_29620 ))" != 0 ]; then
        ret_cutoff_text2581_v0="${text_29619}"
        return 0
    fi
    truncate_ansi__2580_v0 "${text_29619}" "$(( max_width_29620 - 3 ))"
    local ret_truncate_ansi2580_v0__137_12="${ret_truncate_ansi2580_v0}"
    ret_cutoff_text2581_v0="${ret_truncate_ansi2580_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2602_v0() {
    local format_29693="${1}"
    local args_29694=("${!2}")
    args_29694=("${format_29693}" "${args_29694[@]}")
    __status=$?
    printf "${args_29694[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2603_v0() {
    local message_29691="${1}"
    local color_29692="${2}"
    # Prints an error message with a specified color.
    local array_527=("${message_29691}")
    eprintf__2602_v0 "\\x1b[${color_29692}m%s\\x1b[0m" array_527[@]
}

# colored(message: Text, color: Int)
colored__2604_v0() {
    local message_29601="${1}"
    local color_29602="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2604_v0="\\x1b[${color_29602}m""${message_29601}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2608_v0() {
    local items_29685=("${!1}")
    local total_len_29686="${2}"
    local term_width_29687="${3}"
    local separator_29688=" • "
    local separator_len_29689=3
    # Fast path: no truncation needed
    if [ "$(( total_len_29686 <= term_width_29687 ))" != 0 ]; then
        local iter_29690=0
        while :
        do
            local __length_528=("${items_29685[@]}")
            if [ "$(( iter_29690 >= ${#__length_528[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_29690 > 0 ))" != 0 ]; then
                eprintf_colored__2603_v0 "${separator_29688}" 90
            fi
            colored__2604_v0 "${items_29685[$(( iter_29690 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2604_v0__23_41="${ret_colored2604_v0}"
            local array_529=("")
            eprintf__2602_v0 "${items_29685[${iter_29690}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2604_v0__23_41}" array_529[@]
            iter_29690="$(( iter_29690 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_29695=0
        local first_29696=1
        local iter_29697=0
        while :
        do
            local __length_530=("${items_29685[@]}")
            if [ "$(( iter_29697 >= ${#__length_530[@]} ))" != 0 ]; then
                break
            fi
            local key_29698="${items_29685[${iter_29697}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_29699="${items_29685[$(( iter_29697 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_531="${key_29698}"
            local __length_532="${action_29699}"
            local part_len_29700="$(( $(( ${#__length_531} + 1 )) + ${#__length_532} ))"
            local needed_29701="${part_len_29700}"
            if [ "$(( ! first_29696 ))" != 0 ]; then
                needed_29701="$(( needed_29701 + separator_len_29689 ))"
            fi
            if [ "$(( $(( current_len_29695 + needed_29701 )) > term_width_29687 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_29696 ))" != 0 ]; then
                eprintf_colored__2603_v0 "${separator_29688}" 90
            fi
            colored__2604_v0 "${action_29699}" 2
            local ret_colored2604_v0__51_33="${ret_colored2604_v0}"
            local array_533=("")
            eprintf__2602_v0 "${key_29698}"" ""${ret_colored2604_v0__51_33}" array_533[@]
            current_len_29695="$(( current_len_29695 + needed_29701 ))"
            first_29696=0
            iter_29697="$(( iter_29697 + 2 ))"
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
    local size_29580="${1}"
    if [ "$([ "_${size_29580}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2645_v0=0
        return 0
    fi
    split__4_v0 "${size_29580}" " "
    local parts_29581=("${ret_split4_v0[@]}")
    local __length_535=("${parts_29581[@]}")
    if [ "$(( ${#__length_535[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2645_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29581[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29581[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
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
    local size_29583="${command_537}"
    store_term_size__2645_v0 "${size_29583}"
    ret_query_term_size2646_v0="${ret_store_term_size2645_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2647_v0() {
    local command_538
    command_538="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29579="${command_538}"
    store_term_size__2645_v0 "${size_29579}"
    ret_stty_term_size2647_v0="${ret_store_term_size2645_v0}"
    return 0
}

# get_term_size()
get_term_size__2648_v0() {
    stty_term_size__2647_v0 
    local detected_29582="${ret_stty_term_size2647_v0}"
    if [ "$(( ! detected_29582 ))" != 0 ]; then
        query_term_size__2646_v0 
        detected_29582="${ret_query_term_size2646_v0}"
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
    local pending_29598="${1}"
    local line_29599="${2}"
    local note_at_29600="${3}"
    if [ "$(( note_at_29600 < 0 ))" != 0 ]; then
        local array_540=()
        printf__128_v0 "${pending_29598}""${line_29599}""
" array_540[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_29600 == 0 ))" != 0 ]; then
        colored__2604_v0 "${line_29599}" 90
        local ret_colored2604_v0__12_40="${ret_colored2604_v0}"
        local array_541=()
        printf__128_v0 "${pending_29598}""${ret_colored2604_v0__12_40}""
" array_541[@]
    else
        slice__24_v0 "${line_29599}" 0 "${note_at_29600}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_29599}" "${note_at_29600}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2604_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2604_v0__13_58="${ret_colored2604_v0}"
        local array_542=()
        printf__128_v0 "${pending_29598}""${ret_slice24_v0__13_32}""${ret_colored2604_v0__13_58}""
" array_542[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2684_v0() {
    local names_29571=("${!1}")
    local texts_29572=("${!2}")
    local notes_29573=("${!3}")
    local min_name_width_29574="${4}"
    local __length_543=("${names_29571[@]}")
    local count_29575="${#__length_543[@]}"
    local name_width_29576="${min_name_width_29574}"
    local __range_start_29577=0
    local __range_end_29577="${count_29575}"
    local __dir_29577=$(( ${__range_start_29577} <= ${__range_end_29577} ? 1 : -1 ))
    for (( i_29577=${__range_start_29577}; i_29577 * ${__dir_29577} < ${__range_end_29577} * ${__dir_29577}; i_29577+=${__dir_29577} )); do
        local __length_544="${names_29571[${i_29577}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_29578="${#__length_544}"
        if [ "$(( width_29578 > name_width_29576 ))" != 0 ]; then
            name_width_29576="${width_29578}"
        fi
done
    term_width__2650_v0 
    local width_29584="${ret_term_width2650_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_29585="$(( name_width_29576 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_29586="$(( $(( width_29584 - indent_29585 )) < 24 ))"
    if [ "${stacked_29586}" != 0 ]; then
        indent_29585=6
    fi
    local avail_29587="$(( width_29584 - indent_29585 ))"
    rpad__28_v0 "" " " "${indent_29585}"
    local blank_29588="${ret_rpad28_v0}"
    local __range_start_29589=0
    local __range_end_29589="${count_29575}"
    local __dir_29589=$(( ${__range_start_29589} <= ${__range_end_29589} ? 1 : -1 ))
    for (( i_29589=${__range_start_29589}; i_29589 * ${__dir_29589} < ${__range_end_29589} * ${__dir_29589}; i_29589+=${__dir_29589} )); do
        local pending_29590="${blank_29588}"
        if [ "${stacked_29586}" != 0 ]; then
            local array_545=()
            printf__128_v0 "  ""${names_29571[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_545[@]
        else
            rpad__28_v0 "  ""${names_29571[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_29585}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_29590="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_29572[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_29591=("${ret_split4_v0__52_21[@]}")
        local __length_546=("${words_29591[@]}")
        local note_start_29592="${#__length_546[@]}"
        if [ "$([ "_${notes_29573[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_547="${notes_29573[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_547} > avail_29587 ))" != 0 ]; then
                split__4_v0 "${notes_29573[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_29591+=("${ret_split4_v0__58_26[@]}")
            else
                local array_548=("${notes_29573[${i_29589}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_29591+=("${array_548[@]}")
            fi
        fi
        local line_29593=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_29594=-1
        local __range_start_29595=0
        local __length_549=("${words_29591[@]}")
        local __range_end_29595="${#__length_549[@]}"
        local __dir_29595=$(( ${__range_start_29595} <= ${__range_end_29595} ? 1 : -1 ))
        for (( j_29595=${__range_start_29595}; j_29595 * ${__dir_29595} < ${__range_end_29595} * ${__dir_29595}; j_29595+=${__dir_29595} )); do
            local word_29596="${words_29591[${j_29595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_29597
            candidate_29597="$(if [ "$([ "_${line_29593}" != "_" ]; echo $?)" != 0 ]; then echo "${word_29596}"; else echo "${line_29593}"" ""${word_29596}"; fi)"
            local __length_550="${candidate_29597}"
            if [ "$(( $(( ${#__length_550} > avail_29587 )) && $([ "_${line_29593}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2683_v0 "${pending_29590}" "${line_29593}" "${note_at_29594}"
                pending_29590="${blank_29588}"
                line_29593="${word_29596}"
                note_at_29594="$(if [ "$(( j_29595 >= note_start_29592 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_29595 >= note_start_29592 )) && $(( note_at_29594 < 0 )) ))" != 0 ]; then
                    local __length_551="${candidate_29597}"
                    local __length_552="${word_29596}"
                    note_at_29594="$(( ${#__length_551} - ${#__length_552} ))"
                fi
                line_29593="${candidate_29597}"
            fi
done
        print_help_line__2683_v0 "${pending_29590}" "${line_29593}" "${note_at_29594}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2742_v0() {
    local selected_29659="${1}"
    local term_width_29660="${2}"
    local small_29661="$(( term_width_29660 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_29661}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_29675="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_29661}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_29676="${ret_cpad29_v0}"
    local gap_29677
    gap_29677="$(if [ "${small_29661}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_553=("")
    eprintf__2447_v0 " " array_553[@]
    if [ "${selected_29659}" != 0 ]; then
        # Yes selected
        background_secondary__2553_v0 "${yes_label_29675}"
        local ret_background_secondary2553_v0__16_30="${ret_background_secondary2553_v0}"
        local array_554=("")
        eprintf__2447_v0 "\\x1b[97m""${ret_background_secondary2553_v0__16_30}" array_554[@]
        local array_555=("")
        eprintf__2447_v0 "${gap_29677}" array_555[@]
        # No not selected (dim)
        local array_556=("")
        eprintf__2447_v0 "\\x1b[49;37m""${no_label_29676}""\\x1b[0m" array_556[@]
    else
        # No selected
        local array_557=("")
        eprintf__2447_v0 "\\x1b[49;37m""${yes_label_29675}""\\x1b[0m" array_557[@]
        local array_558=("")
        eprintf__2447_v0 "${gap_29677}" array_558[@]
        background_secondary__2553_v0 "${no_label_29676}"
        local ret_background_secondary2553_v0__24_30="${ret_background_secondary2553_v0}"
        local array_559=("")
        eprintf__2447_v0 "\\x1b[97m""${ret_background_secondary2553_v0__24_30}" array_559[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2743_v0() {
    local header_29612="${1}"
    local default_yes_29613="${2}"
    stty_lock__2488_v0 
    hide_cursor__2505_v0 
    term_width__2495_v0 
    local term_width_29618="${ret_term_width2495_v0}"
    if [ "$([ "_${header_29612}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2581_v0 "${header_29612}" "${term_width_29618}"
        local ret_cutoff_text2581_v0__46_17="${ret_cutoff_text2581_v0}"
        local array_560=("")
        eprintf__2447_v0 "${ret_cutoff_text2581_v0__46_17}""

" array_560[@]
    fi
    local selected_29658="${default_yes_29613}"
    # Render initial options
    render_confirm_options__2742_v0 "${selected_29658}" "${term_width_29618}"
    local array_561=("")
    eprintf__2447_v0 "

" array_561[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_562=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2608_v0 array_562[@] 40 "${term_width_29618}"
    go_up__2502_v0 2
    while :
    do
        get_key__2445_v0 
        local key_29703="${ret_get_key2445_v0}"
        if [ "$(( $(( $(( $([ "_${key_29703}" != "_LEFT" ]; echo $?) || $([ "_${key_29703}" != "_h" ]; echo $?) )) || $([ "_${key_29703}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_29703}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_29658}" != 0 ]; then
                selected_29658=0
                local array_563=("")
                eprintf__2447_v0 "\\x1b[G\\x1b[K" array_563[@]
                render_confirm_options__2742_v0 "${selected_29658}" "${term_width_29618}"
            elif [ "$(( ! selected_29658 ))" != 0 ]; then
                selected_29658=1
                local array_564=("")
                eprintf__2447_v0 "\\x1b[G\\x1b[K" array_564[@]
                render_confirm_options__2742_v0 "${selected_29658}" "${term_width_29618}"
            fi
        elif [ "$(( $([ "_${key_29703}" != "_y" ]; echo $?) || $([ "_${key_29703}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_29658=1
            break
        elif [ "$(( $([ "_${key_29703}" != "_n" ]; echo $?) || $([ "_${key_29703}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_29658=0
            break
        elif [ "$(( $([ "_${key_29703}" != "_INPUT" ]; echo $?) || $([ "_${key_29703}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_29704=4
    if [ "$([ "_${header_29612}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_29704="$(( total_lines_29704 + 1 ))"
    fi
    go_down__2503_v0 2
    remove_line__2498_v0 "$(( total_lines_29704 - 1 ))"
    remove_current_line__2499_v0 
    stty_unlock__2489_v0 
    show_cursor__2506_v0 
    ret_xyl_confirm2743_v0="${selected_29658}"
    return 0
}

# print_confirm_help()
print_confirm_help__2843_v0() {
    local usage_29539=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__2507_v0 usage_29539[@]
    printf '%s\n' ""
    colored_primary__2549_v0 "confirm"
    local ret_colored_primary2549_v0__8_20="${ret_colored_primary2549_v0}"
    local title_29566=("${ret_colored_primary2549_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__2507_v0 title_29566[@]
    printf '%s\n' ""
    colored_secondary__2550_v0 "Flags:"
    local ret_colored_secondary2550_v0__11_12="${ret_colored_secondary2550_v0}"
    local array_567=()
    printf__128_v0 "${ret_colored_secondary2550_v0__11_12}""
" array_567[@]
    local names_29568=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_29569=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_29570=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2684_v0 names_29568[@] texts_29569[@] notes_29570[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2901_v0() {
    local parameters_29522=("${!1}")
    colored_primary__2549_v0 "Are you sure?"
    local ret_colored_primary2549_v0__9_30="${ret_colored_primary2549_v0}"
    local header_29536="\\x1b[1m""${ret_colored_primary2549_v0__9_30}"
    local default_yes_29537=1
    for param_29538 in "${parameters_29522[@]}"; do
        starts_with__22_v0 "${param_29538}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_29538}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_29538}" != "_-h" ]; echo $?) || $([ "_${param_29538}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2843_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_573="--header="
            slice__24_v0 "${param_29538}" "${#__length_573}" 0
            header_29536="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_574="--default="
            slice__24_v0 "${param_29538}" "${#__length_574}" 0
            local value_29603="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_29603}" != "_yes" ]; echo $?) || $([ "_${value_29603}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_29537=1
            elif [ "$(( $([ "_${value_29603}" != "_no" ]; echo $?) || $([ "_${value_29603}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_29537=0
            else
                eprintf_colored__2448_v0 "ERROR: Invalid default value: ""${value_29603}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2573_v0 "${header_29536}"
    local ret_has_ansi_escape2573_v0__35_44="${ret_has_ansi_escape2573_v0}"
    escape_ansi__2574_v0 "${header_29536}"
    local ret_escape_ansi2574_v0__35_73="${ret_escape_ansi2574_v0}"
    colored_primary__2549_v0 "${header_29536}"
    local ret_colored_primary2549_v0__35_111="${ret_colored_primary2549_v0}"
    local display_header_29611
    display_header_29611="$(if [ "$(( $([ "_${header_29536}" != "_" ]; echo $?) || ret_has_ansi_escape2573_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2574_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary2549_v0__35_111}"; fi)"
    xyl_confirm__2743_v0 "${display_header_29611}" "${default_yes_29537}"
    local result_29710="${ret_xyl_confirm2743_v0}"
    ret_execute_confirm2901_v0="$(if [ "${result_29710}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3019_v0() {
    local format_40128="${1}"
    local args_40129=("${!2}")
    args_40129=("${format_40128}" "${args_40129[@]}")
    __status=$?
    printf "${args_40129[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3020_v0() {
    local message_40126="${1}"
    local color_40127="${2}"
    # Prints an error message with a specified color.
    local array_575=("${message_40126}")
    eprintf__3019_v0 "\\x1b[${color_40127}m%s\\x1b[0m" array_575[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3035_v0() {
    local format_40158="${1}"
    local args_40159=("${!2}")
    args_40159=("${format_40158}" "${args_40159[@]}")
    __status=$?
    printf "${args_40159[@]}" >&2
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
        local disabled_40068
        disabled_40068="$([ "_${command_576}" != "_No" ]; echo $?)"
        local command_577
        command_577="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40069
        found_40069="$(( $(( ! disabled_40068 )) && $([ "_${command_577}" != "_0" ]; echo $?) ))"
        _perl_state_148="$(if [ "${found_40069}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3042_v0="$([ "_${_perl_state_148}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3043_v0() {
    local text_40067="${1}"
    perl_available__3042_v0 
    local ret_perl_available3042_v0__19_12="${ret_perl_available3042_v0}"
    if [ "$(( ! ret_perl_available3042_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return 1
    fi
    local command_578
    command_578="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40067}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return "${__status}"
    fi
    local width_str_40070="${command_578}"
    parse_int__13_v0 "${width_str_40070}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3043_v0=''
        return "${__status}"
    fi
    local width_40071="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3043_v0="${width_40071}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3048_v0() {
    local text_40057="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_579
    command_579="$([[ "${text_40057}" == *$'\x1b'* || "${text_40057}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40058="${command_579}"
    ret_has_ansi_escape3048_v0="$([ "_${has_escape_40058}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3050_v0() {
    local text_40063="${1}"
    local command_580
    command_580="$(printf "%s" "${text_40063}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3050_v0="${command_580}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3051_v0() {
    local text_40065="${1}"
    local command_581
    command_581="$(printf "%s" "${text_40065}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40066="${command_581}"
    ret_is_all_ascii3051_v0="$([ "_${result_40066}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3052_v0() {
    local text_40060="${1}"
    local command_582
    command_582="$(LC_ALL=C; __t="${text_40060}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40061="${command_582}"
    parse_int__13_v0 "${measured_40061}"
    __status=$?
    ret_plain_len3052_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3053_v0() {
    local text_40059="${1}"
    plain_len__3052_v0 "${text_40059}"
    local plain_40062="${ret_plain_len3052_v0}"
    if [ "$(( plain_40062 >= 0 ))" != 0 ]; then
        ret_get_visible_len3053_v0="${plain_40062}"
        return 0
    fi
    strip_ansi__3050_v0 "${text_40059}"
    local stripped_40064="${ret_strip_ansi3050_v0}"
    is_all_ascii__3051_v0 "${stripped_40064}"
    local ret_is_all_ascii3051_v0__46_12="${ret_is_all_ascii3051_v0}"
    if [ "$(( ! ret_is_all_ascii3051_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3043_v0 "${stripped_40064}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_583="${stripped_40064}"
            ret_get_visible_len3053_v0="${#__length_583}"
            return 0
        fi
        ret_get_visible_len3053_v0="${ret_perl_get_cjk_width3043_v0}"
        return 0
    fi
    local __length_584="${stripped_40064}"
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
    local count_40134="${command_586}"
    parse_int__13_v0 "${count_40134}"
    __status=$?
    ret_stty_count3059_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3060_v0() {
    stty_count__3059_v0 
    local count_num_40135="${ret_stty_count3059_v0}"
    if [ "$(( count_num_40135 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40135="$(( count_num_40135 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40135}
    __status=$?
}

# stty_unlock()
stty_unlock__3061_v0() {
    stty_count__3059_v0 
    local count_num_40156="${ret_stty_count3059_v0}"
    if [ "$(( count_num_40156 > 0 ))" != 0 ]; then
        count_num_40156="$(( count_num_40156 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40156}
        __status=$?
        if [ "$(( count_num_40156 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3062_v0() {
    local size_40048="${1}"
    if [ "$([ "_${size_40048}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3062_v0=0
        return 0
    fi
    split__4_v0 "${size_40048}" " "
    local parts_40049=("${ret_split4_v0[@]}")
    local __length_587=("${parts_40049[@]}")
    if [ "$(( ${#__length_587[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3062_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40049[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40049[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
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
    local size_40051="${command_589}"
    store_term_size__3062_v0 "${size_40051}"
    ret_query_term_size3063_v0="${ret_store_term_size3062_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3064_v0() {
    local command_590
    command_590="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40047="${command_590}"
    store_term_size__3062_v0 "${size_40047}"
    ret_stty_term_size3064_v0="${ret_store_term_size3062_v0}"
    return 0
}

# get_term_size()
get_term_size__3065_v0() {
    stty_term_size__3064_v0 
    local detected_40050="${ret_stty_term_size3064_v0}"
    if [ "$(( ! detected_40050 ))" != 0 ]; then
        query_term_size__3063_v0 
        detected_40050="${ret_query_term_size3063_v0}"
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
    local pieces_40046=("${!1}")
    term_width__3067_v0 
    local width_40052="${ret_term_width3067_v0}"
    local line_40053=""
    local line_len_40054=0
    for piece_40055 in "${pieces_40046[@]}"; do
        local __length_594="${piece_40055}"
        local piece_len_40056="${#__length_594}"
        has_ansi_escape__3048_v0 "${piece_40055}"
        local ret_has_ansi_escape3048_v0__186_12="${ret_has_ansi_escape3048_v0}"
        if [ "${ret_has_ansi_escape3048_v0__186_12}" != 0 ]; then
            get_visible_len__3053_v0 "${piece_40055}"
            piece_len_40056="${ret_get_visible_len3053_v0}"
        fi
        if [ "$([ "_${line_40053}" != "_" ]; echo $?)" != 0 ]; then
            line_40053="${piece_40055}"
            line_len_40054="${piece_len_40056}"
        elif [ "$(( $(( $(( line_len_40054 + 1 )) + piece_len_40056 )) > width_40052 ))" != 0 ]; then
            local array_595=()
            printf__128_v0 "${line_40053}""
" array_595[@]
            line_40053="${piece_40055}"
            line_len_40054="${piece_len_40056}"
        else
            line_40053+=" ""${piece_40055}"
            line_len_40054="$(( line_len_40054 + $(( 1 + piece_len_40056 )) ))"
        fi
    done
    if [ "$([ "_${line_40053}" == "_" ]; echo $?)" != 0 ]; then
        local array_596=()
        printf__128_v0 "${line_40053}""
" array_596[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_151=3
# get_directory_entries(path: Text)
get_directory_entries__3101_v0() {
    local path_40139="${1}"
    local __ls_path_597="${path_40139}"
    __ls_path_597="${__ls_path_597//\\/\\\\}"
    (( 1 )) && __ls_all_597="-A" || __ls_all_597=""
    (( 0 )) && __ls_rec_597="-R" || __ls_rec_597=""
    local __ls_597=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_597 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_597} ${__ls_rec_597} ${__ls_path_597}
    __status=$?
    );
    local names_40140=("${__ls_597[@]}")
    local command_598
    command_598="$(LC_ALL=C ls -lA "${path_40139}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_40141="${command_598}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_599
    command_599="$(LC_ALL=C ls -lA "${path_40139}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_40142="${command_599}"
    split__4_v0 "${types_output_40141}" "
"
    local types_40143=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_40142}" "
"
    local targets_40144=("${ret_split4_v0[@]}")
    local entries_40145=()
    local __range_start_40146=0
    local __length_601=("${names_40140[@]}")
    local __range_end_40146="${#__length_601[@]}"
    local __dir_40146=$(( ${__range_start_40146} <= ${__range_end_40146} ? 1 : -1 ))
    for (( i_40146=${__range_start_40146}; i_40146 * ${__dir_40146} < ${__range_end_40146} * ${__dir_40146}; i_40146+=${__dir_40146} )); do
        local array_602=("${names_40140[${i_40146}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_40145+=("${array_602[@]}")
        local array_603=("${types_40143[${i_40146}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_40145+=("${array_603[@]}")
        slice__24_v0 "${targets_40144[${i_40146}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_604=("${ret_slice24_v0__31_21}")
        entries_40145+=("${array_604[@]}")
done
    ret_get_directory_entries3101_v0=("${entries_40145[@]}")
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
    local path_40137="${1}"
    local command_606
    command_606="$(cd "${path_40137}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_40138="${command_606}"
    if [ "$([ "_${normalized_40138}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path3103_v0="${path_40137}"
        return 0
    fi
    ret_normalize_path3103_v0="${normalized_40138}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__3104_v0() {
    local base_40323="${1}"
    local child_40324="${2}"
    if [ "$([ "_${base_40323}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join3104_v0="/""${child_40324}"
        return 0
    fi
    ret_path_join3104_v0="${base_40323}""/""${child_40324}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__3105_v0() {
    local path_40321="${1}"
    local command_607
    command_607="$(dirname "${path_40321}")"
    __status=$?
    local parent_40322="${command_607}"
    ret_get_parent_dir3105_v0="${parent_40322}"
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
    local config_40084="${ret_env_var_get120_v0}"
    _supports_truecolor_153="$(if [ "$([ "_${config_40084}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3116_v0="$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3117_v0() {
    local message_40079="${1}"
    local r_40080="${2}"
    local g_40081="${3}"
    local b_40082="${4}"
    local fallback_40083="${5}"
    if [ "$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3117_v0="\\x1b[38;2;${r_40080};${g_40081};${b_40082}m""${message_40079}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_153}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3116_v0 
        local ret_get_supports_truecolor3116_v0__45_17="${ret_get_supports_truecolor3116_v0}"
        if [ "${ret_get_supports_truecolor3116_v0__45_17}" != 0 ]; then
            ret_colored_rgb3117_v0="\\x1b[38;2;${r_40080};${g_40081};${b_40082}m""${message_40079}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40083 == 0 ))" != 0 ]; then
            ret_colored_rgb3117_v0="${message_40079}"
            return 0
        else
            ret_colored_rgb3117_v0="\\x1b[${fallback_40083}m""${message_40079}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40083 == 0 ))" != 0 ]; then
            ret_colored_rgb3117_v0="${message_40079}"
            return 0
        fi
        ret_colored_rgb3117_v0="\\x1b[${fallback_40083}m""${message_40079}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3119_v0() {
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40073="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40073}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40073}" ";"
            local parts_40074=("${ret_split4_v0[@]}")
            local __length_611=("${parts_40074[@]}")
            if [ "$(( ${#__length_611[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40074[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40074[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_40075="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40075}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40075}" ";"
            local parts_40076=("${ret_split4_v0[@]}")
            local __length_613=("${parts_40076[@]}")
            if [ "$(( ${#__length_613[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40076[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40076[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40076[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40076[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_40077="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40077}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40077}" ";"
            local parts_40078=("${ret_split4_v0[@]}")
            local __length_615=("${parts_40078[@]}")
            if [ "$(( ${#__length_615[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40078[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40078[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40078[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3119_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40078[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
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
    local message_40072="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40072}" "${_primary_color_155[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_155[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_155[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_155[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary3121_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__3122_v0() {
    local message_40086="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40086}" "${_secondary_color_156[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_156[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_156[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_156[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3122_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__3123_v0() {
    local message_40257="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3120_v0 
    fi
    colored_rgb__3117_v0 "${message_40257}" "${_accent_color_157[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_157[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_157[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_157[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent3123_v0="${ret_colored_rgb3117_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__3176_v0() {
    local message_40120="${1}"
    local color_40121="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3176_v0="\\x1b[${color_40121}m""${message_40120}""\\x1b[0m"
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
    local size_40099="${1}"
    if [ "$([ "_${size_40099}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3217_v0=0
        return 0
    fi
    split__4_v0 "${size_40099}" " "
    local parts_40100=("${ret_split4_v0[@]}")
    local __length_618=("${parts_40100[@]}")
    if [ "$(( ${#__length_618[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40100[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40100[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
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
    local size_40102="${command_620}"
    store_term_size__3217_v0 "${size_40102}"
    ret_query_term_size3218_v0="${ret_store_term_size3217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3219_v0() {
    local command_621
    command_621="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40098="${command_621}"
    store_term_size__3217_v0 "${size_40098}"
    ret_stty_term_size3219_v0="${ret_store_term_size3217_v0}"
    return 0
}

# get_term_size()
get_term_size__3220_v0() {
    stty_term_size__3219_v0 
    local detected_40101="${ret_stty_term_size3219_v0}"
    if [ "$(( ! detected_40101 ))" != 0 ]; then
        query_term_size__3218_v0 
        detected_40101="${ret_query_term_size3218_v0}"
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
    local pending_40117="${1}"
    local line_40118="${2}"
    local note_at_40119="${3}"
    if [ "$(( note_at_40119 < 0 ))" != 0 ]; then
        local array_623=()
        printf__128_v0 "${pending_40117}""${line_40118}""
" array_623[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_40119 == 0 ))" != 0 ]; then
        colored__3176_v0 "${line_40118}" 90
        local ret_colored3176_v0__12_40="${ret_colored3176_v0}"
        local array_624=()
        printf__128_v0 "${pending_40117}""${ret_colored3176_v0__12_40}""
" array_624[@]
    else
        slice__24_v0 "${line_40118}" 0 "${note_at_40119}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_40118}" "${note_at_40119}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__3176_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored3176_v0__13_58="${ret_colored3176_v0}"
        local array_625=()
        printf__128_v0 "${pending_40117}""${ret_slice24_v0__13_32}""${ret_colored3176_v0__13_58}""
" array_625[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__3256_v0() {
    local names_40090=("${!1}")
    local texts_40091=("${!2}")
    local notes_40092=("${!3}")
    local min_name_width_40093="${4}"
    local __length_626=("${names_40090[@]}")
    local count_40094="${#__length_626[@]}"
    local name_width_40095="${min_name_width_40093}"
    local __range_start_40096=0
    local __range_end_40096="${count_40094}"
    local __dir_40096=$(( ${__range_start_40096} <= ${__range_end_40096} ? 1 : -1 ))
    for (( i_40096=${__range_start_40096}; i_40096 * ${__dir_40096} < ${__range_end_40096} * ${__dir_40096}; i_40096+=${__dir_40096} )); do
        local __length_627="${names_40090[${i_40096}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_40097="${#__length_627}"
        if [ "$(( width_40097 > name_width_40095 ))" != 0 ]; then
            name_width_40095="${width_40097}"
        fi
done
    term_width__3222_v0 
    local width_40103="${ret_term_width3222_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_40104="$(( name_width_40095 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_40105="$(( $(( width_40103 - indent_40104 )) < 24 ))"
    if [ "${stacked_40105}" != 0 ]; then
        indent_40104=6
    fi
    local avail_40106="$(( width_40103 - indent_40104 ))"
    rpad__28_v0 "" " " "${indent_40104}"
    local blank_40107="${ret_rpad28_v0}"
    local __range_start_40108=0
    local __range_end_40108="${count_40094}"
    local __dir_40108=$(( ${__range_start_40108} <= ${__range_end_40108} ? 1 : -1 ))
    for (( i_40108=${__range_start_40108}; i_40108 * ${__dir_40108} < ${__range_end_40108} * ${__dir_40108}; i_40108+=${__dir_40108} )); do
        local pending_40109="${blank_40107}"
        if [ "${stacked_40105}" != 0 ]; then
            local array_628=()
            printf__128_v0 "  ""${names_40090[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_628[@]
        else
            rpad__28_v0 "  ""${names_40090[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_40104}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_40109="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_40091[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_40110=("${ret_split4_v0__52_21[@]}")
        local __length_629=("${words_40110[@]}")
        local note_start_40111="${#__length_629[@]}"
        if [ "$([ "_${notes_40092[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_630="${notes_40092[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_630} > avail_40106 ))" != 0 ]; then
                split__4_v0 "${notes_40092[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_40110+=("${ret_split4_v0__58_26[@]}")
            else
                local array_631=("${notes_40092[${i_40108}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_40110+=("${array_631[@]}")
            fi
        fi
        local line_40112=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_40113=-1
        local __range_start_40114=0
        local __length_632=("${words_40110[@]}")
        local __range_end_40114="${#__length_632[@]}"
        local __dir_40114=$(( ${__range_start_40114} <= ${__range_end_40114} ? 1 : -1 ))
        for (( j_40114=${__range_start_40114}; j_40114 * ${__dir_40114} < ${__range_end_40114} * ${__dir_40114}; j_40114+=${__dir_40114} )); do
            local word_40115="${words_40110[${j_40114}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_40116
            candidate_40116="$(if [ "$([ "_${line_40112}" != "_" ]; echo $?)" != 0 ]; then echo "${word_40115}"; else echo "${line_40112}"" ""${word_40115}"; fi)"
            local __length_633="${candidate_40116}"
            if [ "$(( $(( ${#__length_633} > avail_40106 )) && $([ "_${line_40112}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__3255_v0 "${pending_40109}" "${line_40112}" "${note_at_40113}"
                pending_40109="${blank_40107}"
                line_40112="${word_40115}"
                note_at_40113="$(if [ "$(( j_40114 >= note_start_40111 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_40114 >= note_start_40111 )) && $(( note_at_40113 < 0 )) ))" != 0 ]; then
                    local __length_634="${candidate_40116}"
                    local __length_635="${word_40115}"
                    note_at_40113="$(( ${#__length_634} - ${#__length_635} ))"
                fi
                line_40112="${candidate_40116}"
            fi
done
        print_help_line__3255_v0 "${pending_40109}" "${line_40112}" "${note_at_40113}"
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
    local format_40218="${1}"
    local args_40219=("${!2}")
    args_40219=("${format_40218}" "${args_40219[@]}")
    __status=$?
    printf "${args_40219[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3367_v0() {
    local message_40225="${1}"
    local color_40226="${2}"
    # Prints an error message with a specified color.
    local array_637=("${message_40225}")
    eprintf__3366_v0 "\\x1b[${color_40226}m%s\\x1b[0m" array_637[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3382_v0() {
    local format_40168="${1}"
    local args_40169=("${!2}")
    args_40169=("${format_40168}" "${args_40169[@]}")
    __status=$?
    printf "${args_40169[@]}" >&2
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
    local count_40166="${command_639}"
    parse_int__13_v0 "${count_40166}"
    __status=$?
    ret_stty_count3406_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3407_v0() {
    stty_count__3406_v0 
    local count_num_40167="${ret_stty_count3406_v0}"
    if [ "$(( count_num_40167 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40167="$(( count_num_40167 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40167}
    __status=$?
}

# stty_unlock()
stty_unlock__3408_v0() {
    stty_count__3406_v0 
    local count_num_40318="${ret_stty_count3406_v0}"
    if [ "$(( count_num_40318 > 0 ))" != 0 ]; then
        count_num_40318="$(( count_num_40318 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40318}
        __status=$?
        if [ "$(( count_num_40318 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3409_v0() {
    local size_40171="${1}"
    if [ "$([ "_${size_40171}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3409_v0=0
        return 0
    fi
    split__4_v0 "${size_40171}" " "
    local parts_40172=("${ret_split4_v0[@]}")
    local __length_640=("${parts_40172[@]}")
    if [ "$(( ${#__length_640[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3409_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40172[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40172[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
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
    local size_40174="${command_642}"
    store_term_size__3409_v0 "${size_40174}"
    ret_query_term_size3410_v0="${ret_store_term_size3409_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3411_v0() {
    local command_643
    command_643="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40170="${command_643}"
    store_term_size__3409_v0 "${size_40170}"
    ret_stty_term_size3411_v0="${ret_store_term_size3409_v0}"
    return 0
}

# get_term_size()
get_term_size__3412_v0() {
    stty_term_size__3411_v0 
    local detected_40173="${ret_stty_term_size3411_v0}"
    if [ "$(( ! detected_40173 ))" != 0 ]; then
        query_term_size__3410_v0 
        detected_40173="${ret_query_term_size3410_v0}"
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
    local cnt_40289="${1}"
    if [ "$(( cnt_40289 > 0 ))" != 0 ]; then
        local sequence_40290=""
        local __range_start_40291=0
        local __range_end_40291="${cnt_40289}"
        local __dir_40291=$(( ${__range_start_40291} <= ${__range_end_40291} ? 1 : -1 ))
        for (( ____40291=${__range_start_40291}; ____40291 * ${__dir_40291} < ${__range_end_40291} * ${__dir_40291}; ____40291+=${__dir_40291} )); do
            sequence_40290+="\\x1b[2K\\x1b[1A"
done
        local array_644=("")
        eprintf__3382_v0 "${sequence_40290}" array_644[@]
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
    local cnt_40280="${1}"
    printf '%*s' "${cnt_40280}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__3420_v0() {
    local cnt_40223="${1}"
    local __range_start_40224=0
    local __range_end_40224="${cnt_40223}"
    local __dir_40224=$(( ${__range_start_40224} <= ${__range_end_40224} ? 1 : -1 ))
    for (( ____40224=${__range_start_40224}; ____40224 * ${__dir_40224} < ${__range_end_40224} * ${__dir_40224}; ____40224+=${__dir_40224} )); do
        local array_647=("")
        eprintf__3382_v0 "
" array_647[@]
done
}

# go_up(cnt: Int)
go_up__3421_v0() {
    local cnt_40246="${1}"
    local array_648=("")
    eprintf__3382_v0 "\\x1b[${cnt_40246}A" array_648[@]
}

# go_down(cnt: Int)
go_down__3422_v0() {
    local cnt_40317="${1}"
    local array_649=("")
    eprintf__3382_v0 "\\x1b[${cnt_40317}B" array_649[@]
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
    local config_40279="${ret_env_var_get120_v0}"
    _supports_truecolor_173="$(if [ "$([ "_${config_40279}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3463_v0="$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3464_v0() {
    local message_40274="${1}"
    local r_40275="${2}"
    local g_40276="${3}"
    local b_40277="${4}"
    local fallback_40278="${5}"
    if [ "$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3464_v0="\\x1b[38;2;${r_40275};${g_40276};${b_40277}m""${message_40274}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_173}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3463_v0 
        local ret_get_supports_truecolor3463_v0__45_17="${ret_get_supports_truecolor3463_v0}"
        if [ "${ret_get_supports_truecolor3463_v0__45_17}" != 0 ]; then
            ret_colored_rgb3464_v0="\\x1b[38;2;${r_40275};${g_40276};${b_40277}m""${message_40274}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40278 == 0 ))" != 0 ]; then
            ret_colored_rgb3464_v0="${message_40274}"
            return 0
        else
            ret_colored_rgb3464_v0="\\x1b[${fallback_40278}m""${message_40274}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40278 == 0 ))" != 0 ]; then
            ret_colored_rgb3464_v0="${message_40274}"
            return 0
        fi
        ret_colored_rgb3464_v0="\\x1b[${fallback_40278}m""${message_40274}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3466_v0() {
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40268="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40268}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40268}" ";"
            local parts_40269=("${ret_split4_v0[@]}")
            local __length_655=("${parts_40269[@]}")
            if [ "$(( ${#__length_655[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40269[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40269[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
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
        local secondary_env_40270="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40270}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40270}" ";"
            local parts_40271=("${ret_split4_v0[@]}")
            local __length_657=("${parts_40271[@]}")
            if [ "$(( ${#__length_657[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40271[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40271[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40271[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40271[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
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
        local accent_env_40272="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40272}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40272}" ";"
            local parts_40273=("${ret_split4_v0[@]}")
            local __length_659=("${parts_40273[@]}")
            if [ "$(( ${#__length_659[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40273[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40273[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40273[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3466_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40273[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
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
    local message_40267="${1}"
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        get_xylitol_colors__3467_v0 
    fi
    colored_rgb__3464_v0 "${message_40267}" "${_secondary_color_176[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_176[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_176[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_176[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
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
        local disabled_40188
        disabled_40188="$([ "_${command_661}" != "_No" ]; echo $?)"
        local command_662
        command_662="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40189
        found_40189="$(( $(( ! disabled_40188 )) && $([ "_${command_662}" != "_0" ]; echo $?) ))"
        _perl_state_178="$(if [ "${found_40189}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3486_v0="$([ "_${_perl_state_178}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3487_v0() {
    local text_40187="${1}"
    perl_available__3486_v0 
    local ret_perl_available3486_v0__19_12="${ret_perl_available3486_v0}"
    if [ "$(( ! ret_perl_available3486_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return 1
    fi
    local command_663
    command_663="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40187}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return "${__status}"
    fi
    local width_str_40190="${command_663}"
    parse_int__13_v0 "${width_str_40190}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3487_v0=''
        return "${__status}"
    fi
    local width_40191="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3487_v0="${width_40191}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__3488_v0() {
    local text_40200="${1}"
    local max_width_40201="${2}"
    perl_available__3486_v0 
    local ret_perl_available3486_v0__30_12="${ret_perl_available3486_v0}"
    if [ "$(( ! ret_perl_available3486_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk3488_v0=''
        return 1
    fi
    local command_664
    command_664="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_40200}" ${max_width_40201} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk3488_v0=''
        return "${__status}"
    fi
    local result_40202="${command_664}"
    ret_perl_truncate_cjk3488_v0="${result_40202}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3492_v0() {
    local text_40195="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_665
    command_665="$([[ "${text_40195}" == *$'\x1b'* || "${text_40195}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40196="${command_665}"
    ret_has_ansi_escape3492_v0="$([ "_${has_escape_40196}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3494_v0() {
    local text_40183="${1}"
    local command_666
    command_666="$(printf "%s" "${text_40183}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3494_v0="${command_666}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3495_v0() {
    local text_40185="${1}"
    local command_667
    command_667="$(printf "%s" "${text_40185}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40186="${command_667}"
    ret_is_all_ascii3495_v0="$([ "_${result_40186}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3496_v0() {
    local text_40180="${1}"
    local command_668
    command_668="$(LC_ALL=C; __t="${text_40180}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40181="${command_668}"
    parse_int__13_v0 "${measured_40181}"
    __status=$?
    ret_plain_len3496_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3497_v0() {
    local text_40179="${1}"
    plain_len__3496_v0 "${text_40179}"
    local plain_40182="${ret_plain_len3496_v0}"
    if [ "$(( plain_40182 >= 0 ))" != 0 ]; then
        ret_get_visible_len3497_v0="${plain_40182}"
        return 0
    fi
    strip_ansi__3494_v0 "${text_40179}"
    local stripped_40184="${ret_strip_ansi3494_v0}"
    is_all_ascii__3495_v0 "${stripped_40184}"
    local ret_is_all_ascii3495_v0__46_12="${ret_is_all_ascii3495_v0}"
    if [ "$(( ! ret_is_all_ascii3495_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3487_v0 "${stripped_40184}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_669="${stripped_40184}"
            ret_get_visible_len3497_v0="${#__length_669}"
            return 0
        fi
        ret_get_visible_len3497_v0="${ret_perl_get_cjk_width3487_v0}"
        return 0
    fi
    local __length_670="${stripped_40184}"
    ret_get_visible_len3497_v0="${#__length_670}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__3498_v0() {
    local text_40197="${1}"
    local max_width_40198="${2}"
    get_visible_len__3497_v0 "${text_40197}"
    local visible_len_40199="${ret_get_visible_len3497_v0}"
    if [ "$(( visible_len_40199 <= max_width_40198 ))" != 0 ]; then
        ret_truncate_text3498_v0="${text_40197}"
        return 0
    fi
    is_all_ascii__3495_v0 "${text_40197}"
    local ret_is_all_ascii3495_v0__61_12="${ret_is_all_ascii3495_v0}"
    if [ "$(( ! ret_is_all_ascii3495_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__3488_v0 "${text_40197}" "${max_width_40198}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_40197}" | cut -c1-${max_width_40198}
            __status=$?
        fi
        ret_truncate_text3498_v0="${ret_perl_truncate_cjk3488_v0}"
        return 0
    fi
    local command_671
    command_671="$(printf "%s" "${text_40197}" | cut -c1-${max_width_40198})"
    __status=$?
    ret_truncate_text3498_v0="${command_671}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__3499_v0() {
    local text_40193="${1}"
    local max_width_40194="${2}"
    has_ansi_escape__3492_v0 "${text_40193}"
    local ret_has_ansi_escape3492_v0__73_12="${ret_has_ansi_escape3492_v0}"
    if [ "$(( ! ret_has_ansi_escape3492_v0__73_12 ))" != 0 ]; then
        truncate_text__3498_v0 "${text_40193}" "${max_width_40194}"
        ret_truncate_ansi3499_v0="${ret_truncate_text3498_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_672
    command_672="$([[ "${text_40193}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_40203="${command_672}"
    # Replace \x1b[ with newline, then split
    local command_673
    command_673="$(t="${text_40193}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_40204="${command_673}"
    split__4_v0 "${replaced_40204}" "
"
    local parts_40205=("${ret_split4_v0[@]}")
    local result_40206=""
    local remaining_width_40207="${max_width_40194}"
    local __range_start_40208=0
    local __length_674=("${parts_40205[@]}")
    local __range_end_40208="${#__length_674[@]}"
    local __dir_40208=$(( ${__range_start_40208} <= ${__range_end_40208} ? 1 : -1 ))
    for (( idx_40208=${__range_start_40208}; idx_40208 * ${__dir_40208} < ${__range_end_40208} * ${__dir_40208}; idx_40208+=${__dir_40208} )); do
        local part_40209="${parts_40205[${idx_40208}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_40208 == 0 )) && $([ "_${starts_with_ansi_40203}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_40209}" == "_" ]; echo $?) && $(( remaining_width_40207 > 0 )) ))" != 0 ]; then
                truncate_text__3498_v0 "${part_40209}" "${remaining_width_40207}"
                local ret_truncate_text3498_v0__95_35="${ret_truncate_text3498_v0}"
                local truncated_40210="${ret_truncate_text3498_v0__95_35}"
                result_40206+="${truncated_40210}"
                get_visible_len__3497_v0 "${truncated_40210}"
                local ret_get_visible_len3497_v0__97_36="${ret_get_visible_len3497_v0}"
                remaining_width_40207="$(( remaining_width_40207 - ret_get_visible_len3497_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_675
            command_675="$(__p="${part_40209}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_40211="${command_675}"
            if [ "$([ "_${m_idx_40211}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_676
                command_676="$(__p="${part_40209}"; printf "%s" "${__p:0:${m_idx_40211}}")"
                __status=$?
                local ansi_params_40212="${command_676}"
                result_40206+="\\x1b[""${ansi_params_40212}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_40211}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_40213="${ret_parse_int13_v0__108_41}"
                local text_start_40214="$(( m_idx_num_40213 + 1 ))"
                local command_677
                command_677="$(__p="${part_40209}"; printf "%s" "${__p:${text_start_40214}}")"
                __status=$?
                local text_part_40215="${command_677}"
                if [ "$(( $([ "_${text_part_40215}" == "_" ]; echo $?) && $(( remaining_width_40207 > 0 )) ))" != 0 ]; then
                    truncate_text__3498_v0 "${text_part_40215}" "${remaining_width_40207}"
                    local ret_truncate_text3498_v0__112_39="${ret_truncate_text3498_v0}"
                    local truncated_40216="${ret_truncate_text3498_v0__112_39}"
                    result_40206+="${truncated_40216}"
                    get_visible_len__3497_v0 "${truncated_40216}"
                    local ret_get_visible_len3497_v0__114_40="${ret_get_visible_len3497_v0}"
                    remaining_width_40207="$(( remaining_width_40207 - ret_get_visible_len3497_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_40209}" == "_" ]; echo $?) && $(( remaining_width_40207 > 0 )) ))" != 0 ]; then
                    truncate_text__3498_v0 "${part_40209}" "${remaining_width_40207}"
                    local ret_truncate_text3498_v0__119_39="${ret_truncate_text3498_v0}"
                    local truncated_40217="${ret_truncate_text3498_v0__119_39}"
                    result_40206+="${truncated_40217}"
                    get_visible_len__3497_v0 "${truncated_40217}"
                    local ret_get_visible_len3497_v0__121_40="${ret_get_visible_len3497_v0}"
                    remaining_width_40207="$(( remaining_width_40207 - ret_get_visible_len3497_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi3499_v0="${result_40206}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__3500_v0() {
    local text_40177="${1}"
    local max_width_40178="${2}"
    get_visible_len__3497_v0 "${text_40177}"
    local visible_len_40192="${ret_get_visible_len3497_v0}"
    if [ "$(( visible_len_40192 <= max_width_40178 ))" != 0 ]; then
        ret_cutoff_text3500_v0="${text_40177}"
        return 0
    fi
    truncate_ansi__3499_v0 "${text_40177}" "$(( max_width_40178 - 3 ))"
    local ret_truncate_ansi3499_v0__137_12="${ret_truncate_ansi3499_v0}"
    ret_cutoff_text3500_v0="${ret_truncate_ansi3499_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__3521_v0() {
    local format_40235="${1}"
    local args_40236=("${!2}")
    args_40236=("${format_40235}" "${args_40236[@]}")
    __status=$?
    printf "${args_40236[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3522_v0() {
    local message_40233="${1}"
    local color_40234="${2}"
    # Prints an error message with a specified color.
    local array_678=("${message_40233}")
    eprintf__3521_v0 "\\x1b[${color_40234}m%s\\x1b[0m" array_678[@]
}

# colored(message: Text, color: Int)
colored__3523_v0() {
    local message_40237="${1}"
    local color_40238="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3523_v0="\\x1b[${color_40238}m""${message_40237}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__3527_v0() {
    local items_40227=("${!1}")
    local total_len_40228="${2}"
    local term_width_40229="${3}"
    local separator_40230=" • "
    local separator_len_40231=3
    # Fast path: no truncation needed
    if [ "$(( total_len_40228 <= term_width_40229 ))" != 0 ]; then
        local iter_40232=0
        while :
        do
            local __length_679=("${items_40227[@]}")
            if [ "$(( iter_40232 >= ${#__length_679[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_40232 > 0 ))" != 0 ]; then
                eprintf_colored__3522_v0 "${separator_40230}" 90
            fi
            colored__3523_v0 "${items_40227[$(( iter_40232 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored3523_v0__23_41="${ret_colored3523_v0}"
            local array_680=("")
            eprintf__3521_v0 "${items_40227[${iter_40232}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored3523_v0__23_41}" array_680[@]
            iter_40232="$(( iter_40232 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_40239=0
        local first_40240=1
        local iter_40241=0
        while :
        do
            local __length_681=("${items_40227[@]}")
            if [ "$(( iter_40241 >= ${#__length_681[@]} ))" != 0 ]; then
                break
            fi
            local key_40242="${items_40227[${iter_40241}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_40243="${items_40227[$(( iter_40241 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_682="${key_40242}"
            local __length_683="${action_40243}"
            local part_len_40244="$(( $(( ${#__length_682} + 1 )) + ${#__length_683} ))"
            local needed_40245="${part_len_40244}"
            if [ "$(( ! first_40240 ))" != 0 ]; then
                needed_40245="$(( needed_40245 + separator_len_40231 ))"
            fi
            if [ "$(( $(( current_len_40239 + needed_40245 )) > term_width_40229 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_40240 ))" != 0 ]; then
                eprintf_colored__3522_v0 "${separator_40230}" 90
            fi
            colored__3523_v0 "${action_40243}" 2
            local ret_colored3523_v0__51_33="${ret_colored3523_v0}"
            local array_684=("")
            eprintf__3521_v0 "${key_40242}"" ""${ret_colored3523_v0__51_33}" array_684[@]
            current_len_40239="$(( current_len_40239 + needed_40245 ))"
            first_40240=0
            iter_40241="$(( iter_40241 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__3537_v0() {
    local format_40305="${1}"
    local args_40306=("${!2}")
    args_40306=("${format_40305}" "${args_40306[@]}")
    __status=$?
    printf "${args_40306[@]}" >&2
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
    local cnt_40304="${1}"
    local array_686=("")
    eprintf__3537_v0 "\\x1b[${cnt_40304}A" array_686[@]
}

# go_down(cnt: Int)
go_down__3577_v0() {
    local cnt_40307="${1}"
    local array_687=("")
    eprintf__3537_v0 "\\x1b[${cnt_40307}B" array_687[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3584_v0() {
    local display_count_40301="${1}"
    local index_40302="${2}"
    local line_40303="${3}"
    go_up__3576_v0 "$(( display_count_40301 - index_40302 ))"
    local array_688=("")
    eprintf__3521_v0 "\\x1b[G\\x1b[K" array_688[@]
    local array_689=("")
    eprintf__3521_v0 "${line_40303}" array_689[@]
    go_down__3577_v0 "$(( display_count_40301 - index_40302 ))"
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
    local total_40220="${1}"
    local limit_40221="${2}"
    _checked_183=()
    local __range_start_40222=0
    local __range_end_40222="${total_40220}"
    local __dir_40222=$(( ${__range_start_40222} <= ${__range_end_40222} ? 1 : -1 ))
    for (( ____40222=${__range_start_40222}; ____40222 * ${__dir_40222} < ${__range_end_40222} * ${__dir_40222}; ____40222+=${__dir_40222} )); do
        local array_693=(0)
        _checked_183+=("${array_693[@]}")
done
    _count_184=0
    _total_185="${total_40220}"
    _limit_186="${limit_40221}"
}

# checked_is(index: Int)
checked_is__3587_v0() {
    local index_40264="${1}"
    ret_checked_is3587_v0="${_checked_183[${index_40264}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3589_v0() {
    local index_40296="${1}"
    if [ "${_checked_183[${index_40296}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_183["${index_40296}"]=0
        _count_184="$(( _count_184 - 1 ))"
        ret_checked_toggle3589_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_186 >= 0 )) && $(( _count_184 >= _limit_186 )) ))" != 0 ]; then
        ret_checked_toggle3589_v0=0
        return 0
    fi
    _checked_183["${index_40296}"]=1
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
    local was_all_40308="$(( _count_184 == _total_185 ))"
    local __range_start_40309=0
    local __range_end_40309="${_total_185}"
    local __dir_40309=$(( ${__range_start_40309} <= ${__range_end_40309} ? 1 : -1 ))
    for (( i_40309=${__range_start_40309}; i_40309 * ${__dir_40309} < ${__range_end_40309} * ${__dir_40309}; i_40309+=${__dir_40309} )); do
        _checked_183["${i_40309}"]="$(( ! was_all_40308 ))"
done
    if [ "${was_all_40308}" != 0 ]; then
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
    local cursor_len_40283="${#__length_695}"
    local max_option_width_40284="$(( $(( _term_width_200 - cursor_len_40283 )) - 1 ))"
    local __range_start_40285=0
    local __range_end_40285="${_page_count_203}"
    local __dir_40285=$(( ${__range_start_40285} <= ${__range_end_40285} ? 1 : -1 ))
    for (( i_40285=${__range_start_40285}; i_40285 * ${__dir_40285} < ${__range_end_40285} * ${__dir_40285}; i_40285+=${__dir_40285} )); do
        cutoff_text__3500_v0 "${_page_202[${i_40285}]?"Index out of bounds (at src/./file/../choose/engine.ab:45:45)"}" "${max_option_width_40284}"
        local ret_cutoff_text3500_v0__45_27="${ret_cutoff_text3500_v0}"
        local truncated_40286="${ret_cutoff_text3500_v0__45_27}"
        if [ "$(( i_40285 == _selected_196 ))" != 0 ]; then
            colored_secondary__3469_v0 "${_cursor_197}""${truncated_40286}""
"
            local ret_colored_secondary3469_v0__47_21="${ret_colored_secondary3469_v0}"
            local array_696=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__47_21}" array_696[@]
        else
            print_blank__3419_v0 "${cursor_len_40283}"
            local array_697=("")
            eprintf__3366_v0 "${truncated_40286}""
" array_697[@]
        fi
done
    local remaining_slots_40287="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40287 > 0 ))" != 0 ]; then
        local __range_start_40288=0
        local __range_end_40288="${remaining_slots_40287}"
        local __dir_40288=$(( ${__range_start_40288} <= ${__range_end_40288} ? 1 : -1 ))
        for (( ____40288=${__range_start_40288}; ____40288 * ${__dir_40288} < ${__range_end_40288} * ${__dir_40288}; ____40288+=${__dir_40288} )); do
            local array_698=("")
            eprintf__3366_v0 "\\x1b[K
" array_698[@]
done
    fi
}

# render_multi_page()
render_multi_page__3662_v0() {
    local __length_699="${_cursor_197}"
    local cursor_len_40259="${#__length_699}"
    local max_option_width_40260="$(( $(( _term_width_200 - cursor_len_40259 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3667_v0 
    local page_start_40261="${ret_chooser_page_start3667_v0}"
    local __range_start_40262=0
    local __range_end_40262="${_page_count_203}"
    local __dir_40262=$(( ${__range_start_40262} <= ${__range_end_40262} ? 1 : -1 ))
    for (( i_40262=${__range_start_40262}; i_40262 * ${__dir_40262} < ${__range_end_40262} * ${__dir_40262}; i_40262+=${__dir_40262} )); do
        local global_idx_40263="$(( page_start_40261 + i_40262 ))"
        checked_is__3587_v0 "${global_idx_40263}"
        local ret_checked_is3587_v0__67_28="${ret_checked_is3587_v0}"
        local check_mark_40265
        check_mark_40265="$(if [ "${ret_checked_is3587_v0__67_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__3500_v0 "${_page_202[${i_40262}]?"Index out of bounds (at src/./file/../choose/engine.ab:68:45)"}" "${max_option_width_40260}"
        local ret_cutoff_text3500_v0__68_27="${ret_cutoff_text3500_v0}"
        local truncated_40266="${ret_cutoff_text3500_v0__68_27}"
        checked_is__3587_v0 "${global_idx_40263}"
        local ret_checked_is3587_v0__71_13="${ret_checked_is3587_v0}"
        if [ "$(( i_40262 == _selected_196 ))" != 0 ]; then
            colored_secondary__3469_v0 "${_cursor_197}""${check_mark_40265}""${truncated_40266}""
"
            local ret_colored_secondary3469_v0__70_37="${ret_colored_secondary3469_v0}"
            local array_700=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__70_37}" array_700[@]
        elif [ "${ret_checked_is3587_v0__71_13}" != 0 ]; then
            print_blank__3419_v0 "${cursor_len_40259}"
            colored_secondary__3469_v0 "${check_mark_40265}""${truncated_40266}""
"
            local ret_colored_secondary3469_v0__73_25="${ret_colored_secondary3469_v0}"
            local array_701=("")
            eprintf__3366_v0 "${ret_colored_secondary3469_v0__73_25}" array_701[@]
        else
            print_blank__3419_v0 "${cursor_len_40259}"
            local array_702=("")
            eprintf__3366_v0 "${check_mark_40265}""${truncated_40266}""
" array_702[@]
        fi
done
    local remaining_slots_40281="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40281 > 0 ))" != 0 ]; then
        local __range_start_40282=0
        local __range_end_40282="${remaining_slots_40281}"
        local __dir_40282=$(( ${__range_start_40282} <= ${__range_end_40282} ? 1 : -1 ))
        for (( ____40282=${__range_start_40282}; ____40282 * ${__dir_40282} < ${__range_end_40282} * ${__dir_40282}; ____40282+=${__dir_40282} )); do
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
    local total_40160="${1}"
    local page_size_40161="${2}"
    local header_40162="${3}"
    local cursor_40163="${4}"
    local multi_40164="${5}"
    local limit_40165="${6}"
    _total_191="${total_40160}"
    _cursor_197="${cursor_40163}"
    _multi_198="${multi_40164}"
    _limit_199="${limit_40165}"
    _current_page_195=0
    _selected_196=0
    _first_render_204=1
    _up_paged_205=0
    _has_header_201="$([ "_${header_40162}" == "_" ]; echo $?)"
    stty_lock__3407_v0 
    hide_cursor__3424_v0 
    term_width__3414_v0 
    _term_width_200="${ret_term_width3414_v0}"
    term_height__3415_v0 
    local term_height_40175="${ret_term_height3415_v0}"
    local max_page_size_40176
    max_page_size_40176="$(( term_height_40175 - $(if [ "${_has_header_201}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_192="${page_size_40161}"
    if [ "$(( _page_size_192 > max_page_size_40176 ))" != 0 ]; then
        _page_size_192="${max_page_size_40176}"
    fi
    if [ "${_has_header_201}" != 0 ]; then
        cutoff_text__3500_v0 "${header_40162}" "${_term_width_200}"
        local ret_cutoff_text3500_v0__153_17="${ret_cutoff_text3500_v0}"
        local array_712=("")
        eprintf__3366_v0 "${ret_cutoff_text3500_v0__153_17}""
" array_712[@]
    fi
    math_floor__636_v0 "$(( $(( $(( total_40160 + _page_size_192 )) - 1 )) / _page_size_192 ))"
    _total_pages_194="${ret_math_floor636_v0}"
    _display_count_193="${_page_size_192}"
    if [ "$(( total_40160 < _page_size_192 ))" != 0 ]; then
        _display_count_193="${total_40160}"
    fi
    if [ "${multi_40164}" != 0 ]; then
        checked_init__3586_v0 "${total_40160}" "${limit_40165}"
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
    local start_40250="${ret_chooser_page_start3667_v0}"
    local end_40251="$(( start_40250 + _page_size_192 ))"
    if [ "$(( end_40251 > _total_191 ))" != 0 ]; then
        end_40251="${_total_191}"
    fi
    ret_chooser_page_count3668_v0="$(( end_40251 - start_40250 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3669_v0() {
    local page_40258=("${!1}")
    _page_202=("${page_40258[@]}")
    local __length_715=("${page_40258[@]}")
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
    local check_width_40298
    check_width_40298="$(if [ "${_multi_198}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_717="${_cursor_197}"
    ret_option_width3670_v0="$(( $(( _term_width_200 - ${#__length_717} )) - check_width_40298 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3671_v0() {
    local index_40311="${1}"
    local __length_718="${_cursor_197}"
    rpad__28_v0 "" " " "${#__length_718}"
    local blank_40312="${ret_rpad28_v0}"
    option_width__3670_v0 
    local ret_option_width3670_v0__224_49="${ret_option_width3670_v0}"
    cutoff_text__3500_v0 "${_page_202[${index_40311}]?"Index out of bounds (at src/./file/../choose/engine.ab:224:41)"}" "${ret_option_width3670_v0__224_49}"
    local truncated_40313="${ret_cutoff_text3500_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        ret_unselected_line3671_v0="${blank_40312}""${truncated_40313}"
        return 0
    fi
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__228_19="${ret_chooser_page_start3667_v0}"
    checked_is__3587_v0 "$(( ret_chooser_page_start3667_v0__228_19 + index_40311 ))"
    local ret_checked_is3587_v0__228_8="${ret_checked_is3587_v0}"
    if [ "${ret_checked_is3587_v0__228_8}" != 0 ]; then
        colored_secondary__3469_v0 "✓ ""${truncated_40313}"
        local ret_colored_secondary3469_v0__229_24="${ret_colored_secondary3469_v0}"
        ret_unselected_line3671_v0="${blank_40312}""${ret_colored_secondary3469_v0__229_24}"
        return 0
    fi
    ret_unselected_line3671_v0="${blank_40312}""• ""${truncated_40313}"
    return 0
}

# selected_line(index: Int)
selected_line__3672_v0() {
    local index_40297="${1}"
    option_width__3670_v0 
    local ret_option_width3670_v0__236_49="${ret_option_width3670_v0}"
    cutoff_text__3500_v0 "${_page_202[${index_40297}]?"Index out of bounds (at src/./file/../choose/engine.ab:236:41)"}" "${ret_option_width3670_v0__236_49}"
    local truncated_40299="${ret_cutoff_text3500_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        colored_secondary__3469_v0 "${_cursor_197}""${truncated_40299}"
        ret_selected_line3672_v0="${ret_colored_secondary3469_v0}"
        return 0
    fi
    chooser_page_start__3667_v0 
    local ret_chooser_page_start3667_v0__240_29="${ret_chooser_page_start3667_v0}"
    checked_is__3587_v0 "$(( ret_chooser_page_start3667_v0__240_29 + index_40297 ))"
    local ret_checked_is3587_v0__240_18="${ret_checked_is3587_v0}"
    local mark_40300
    mark_40300="$(if [ "${ret_checked_is3587_v0__240_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__3469_v0 "${_cursor_197}""${mark_40300}""${truncated_40299}"
    ret_selected_line3672_v0="${ret_colored_secondary3469_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3673_v0() {
    local prev_selected_40310="${1}"
    unselected_line__3671_v0 "${prev_selected_40310}"
    local ret_unselected_line3671_v0__247_47="${ret_unselected_line3671_v0}"
    redraw_row__3584_v0 "${_display_count_193}" "${prev_selected_40310}" "${ret_unselected_line3671_v0__247_47}"
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
    local key_40292="${ret_get_key3364_v0}"
    local prev_selected_40293="${_selected_196}"
    local prev_page_40294="${_current_page_195}"
    chooser_page_start__3667_v0 
    local page_start_40295="${ret_chooser_page_start3667_v0}"
    _up_paged_205=0
    if [ "$(( $([ "_${key_40292}" != "_UP" ]; echo $?) || $([ "_${key_40292}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40292}" != "_DOWN" ]; echo $?) || $([ "_${key_40292}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40292}" != "_LEFT" ]; echo $?) || $([ "_${key_40292}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 > 0 ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 - 1 ))"
        fi
        _selected_196=0
    elif [ "$(( $([ "_${key_40292}" != "_RIGHT" ]; echo $?) || $([ "_${key_40292}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 < $(( _total_pages_194 - 1 )) ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 + 1 ))"
            _selected_196=0
        else
            _selected_196="$(( _page_count_203 - 1 ))"
        fi
    elif [ "$(( _multi_198 && $(( $(( $([ "_${key_40292}" != "_x" ]; echo $?) || $([ "_${key_40292}" != "_X" ]; echo $?) )) || $([ "_${key_40292}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3589_v0 "$(( page_start_40295 + _selected_196 ))"
        local ret_checked_toggle3589_v0__310_16="${ret_checked_toggle3589_v0}"
        if [ "${ret_checked_toggle3589_v0__310_16}" != 0 ]; then
            redraw_current_line__3674_v0 
        fi
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $(( _multi_198 && $(( $(( $([ "_${key_40292}" != "_a" ]; echo $?) || $([ "_${key_40292}" != "_A" ]; echo $?) )) || $([ "_${key_40292}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40292}" != "_INPUT" ]; echo $?) || $([ "_${key_40292}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step3675_v0="${__CHOOSER_DONE_190}"
        return 0
    else
        ret_chooser_step3675_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    fi
    if [ "$(( prev_page_40294 != _current_page_195 ))" != 0 ]; then
        ret_chooser_step3675_v0="${__CHOOSER_NEED_PAGE_189}"
        return 0
    fi
    if [ "$(( prev_selected_40293 != _selected_196 ))" != 0 ]; then
        redraw_selection__3673_v0 "${prev_selected_40293}"
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
    local total_lines_40316="$(( _display_count_193 + 2 ))"
    if [ "${_has_header_201}" != 0 ]; then
        total_lines_40316="$(( total_lines_40316 + 1 ))"
    fi
    go_down__3422_v0 1
    remove_line__3417_v0 "$(( total_lines_40316 - 1 ))"
    remove_current_line__3418_v0 
    stty_unlock__3408_v0 
    show_cursor__3425_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3687_v0() {
    local name_40254="${1}"
    local file_type_40255="${2}"
    local target_40256="${3}"
    if [ "$([ "_${file_type_40255}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__3121_v0 "/"
        local ret_colored_primary3121_v0__10_23="${ret_colored_primary3121_v0}"
        ret_format_entry_display3687_v0="${name_40254}""${ret_colored_primary3121_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_40255}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__3123_v0 " > "
        local ret_colored_accent3123_v0__13_23="${ret_colored_accent3123_v0}"
        colored_primary__3121_v0 "${target_40256}"
        local ret_colored_primary3121_v0__13_47="${ret_colored_primary3121_v0}"
        ret_format_entry_display3687_v0="${name_40254}""${ret_colored_accent3123_v0__13_23}""${ret_colored_primary3121_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3687_v0="${name_40254}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3688_v0() {
    local start_path_40130="${1}"
    local cursor_40131="${2}"
    local show_hidden_40132="${3}"
    local page_size_40133="${4}"
    stty_lock__3060_v0 
    # Initialize current path
    local current_path_40136="${start_path_40130}"
    if [ "$([ "_${current_path_40136}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__3102_v0 
        current_path_40136="${ret_get_cwd3102_v0}"
    fi
    normalize_path__3103_v0 "${current_path_40136}"
    current_path_40136="${ret_normalize_path3103_v0}"
    while :
    do
        colored_primary__3121_v0 "Loading files..."
        local ret_colored_primary3121_v0__41_17="${ret_colored_primary3121_v0}"
        local array_720=("")
        eprintf__3019_v0 "${ret_colored_primary3121_v0__41_17}" array_720[@]
        get_directory_entries__3101_v0 "${current_path_40136}"
        local listed_40147=("${ret_get_directory_entries3101_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_40148=()
        local types_40149=()
        local targets_40150=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_40136}" == "_/" ]; echo $?)" != 0 ]; then
            names_40148+=("..")
            types_40149+=("d")
            targets_40150+=("")
        fi
        local __length_727=("${listed_40147[@]}")
        local listed_count_40151="$(( ${#__length_727[@]} / __ENTRY_STRIDE_151 ))"
        local __range_start_40152=0
        local __range_end_40152="${listed_count_40151}"
        local __dir_40152=$(( ${__range_start_40152} <= ${__range_end_40152} ? 1 : -1 ))
        for (( i_40152=${__range_start_40152}; i_40152 * ${__dir_40152} < ${__range_end_40152} * ${__dir_40152}; i_40152+=${__dir_40152} )); do
            local at_40153="$(( i_40152 * __ENTRY_STRIDE_151 ))"
            local name_40154="${listed_40147[${at_40153}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_40154}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_40132 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_728=("${name_40154}")
            names_40148+=("${array_728[@]}")
            local array_729=("${listed_40147[$(( at_40153 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_40149+=("${array_729[@]}")
            local array_730=("${listed_40147[$(( at_40153 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_40150+=("${array_730[@]}")
done
        local __length_731=("${names_40148[@]}")
        local total_40155="${#__length_731[@]}"
        if [ "$(( total_40155 == 0 ))" != 0 ]; then
            eprintf_colored__3020_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__3061_v0 
            ret_xyl_file3688_v0=""
            return 0
        fi
        colored_primary__3121_v0 "${current_path_40136}"
        local header_40157="${ret_colored_primary3121_v0}"
        remove_current_line__3071_v0 
        chooser_begin__3666_v0 "${total_40155}" "${page_size_40133}" "${header_40157}" "${cursor_40131}" 0 -1
        local need_page_40247=1
        while :
        do
            if [ "${need_page_40247}" != 0 ]; then
                local page_40248=()
                chooser_page_start__3667_v0 
                local start_40249="${ret_chooser_page_start3667_v0}"
                chooser_page_count__3668_v0 
                local count_40252="${ret_chooser_page_count3668_v0}"
                local __range_start_40253="${start_40249}"
                local __range_end_40253="$(( start_40249 + count_40252 ))"
                local __dir_40253=$(( ${__range_start_40253} <= ${__range_end_40253} ? 1 : -1 ))
                for (( i_40253=${__range_start_40253}; i_40253 * ${__dir_40253} < ${__range_end_40253} * ${__dir_40253}; i_40253+=${__dir_40253} )); do
                    format_entry_display__3687_v0 "${names_40148[${i_40253}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_40149[${i_40253}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_40150[${i_40253}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3687_v0__90_30="${ret_format_entry_display3687_v0}"
                    local array_733=("${ret_format_entry_display3687_v0__90_30}")
                    page_40248+=("${array_733[@]}")
done
                chooser_set_page__3669_v0 page_40248[@]
            fi
            chooser_step__3675_v0 
            local step_40314="${ret_chooser_step3675_v0}"
            if [ "$(( step_40314 == __CHOOSER_DONE_190 ))" != 0 ]; then
                break
            fi
            need_page_40247="$(( step_40314 == __CHOOSER_NEED_PAGE_189 ))"
        done
        chooser_selected__3676_v0 
        local selected_idx_40315="${ret_chooser_selected3676_v0}"
        chooser_end__3678_v0 
        local name_40319="${names_40148[${selected_idx_40315}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_40320="${types_40149[${selected_idx_40315}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_40319}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__3105_v0 "${current_path_40136}"
            current_path_40136="${ret_get_parent_dir3105_v0}"
        elif [ "$([ "_${file_type_40320}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__3104_v0 "${current_path_40136}" "${name_40319}"
            current_path_40136="${ret_path_join3104_v0}"
            normalize_path__3103_v0 "${current_path_40136}"
            current_path_40136="${ret_normalize_path3103_v0}"
        elif [ "$([ "_${file_type_40320}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_40325="${targets_40150[${selected_idx_40315}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_40326="${target_40325}"
            starts_with__22_v0 "${target_40325}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__3104_v0 "${current_path_40136}" "${target_40325}"
                target_path_40326="${ret_path_join3104_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_40326}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_40136="${target_path_40326}"
                normalize_path__3103_v0 "${current_path_40136}"
                current_path_40136="${ret_normalize_path3103_v0}"
            else
                stty_unlock__3061_v0 
                path_join__3104_v0 "${current_path_40136}" "${name_40319}"
                ret_xyl_file3688_v0="${ret_path_join3104_v0}"
                return 0
            fi
        else
            stty_unlock__3061_v0 
            path_join__3104_v0 "${current_path_40136}" "${name_40319}"
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
    local usage_40045=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__3079_v0 usage_40045[@]
    printf '%s\n' ""
    colored_primary__3121_v0 "file"
    local ret_colored_primary3121_v0__8_20="${ret_colored_primary3121_v0}"
    local title_40085=("${ret_colored_primary3121_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__3079_v0 title_40085[@]
    printf '%s\n' ""
    colored_secondary__3122_v0 "Arguments:"
    local ret_colored_secondary3122_v0__11_12="${ret_colored_secondary3122_v0}"
    local array_736=()
    printf__128_v0 "${ret_colored_secondary3122_v0__11_12}""
" array_736[@]
    local arg_names_40087=("[<path>]")
    local arg_texts_40088=("Starting directory path")
    local arg_notes_40089=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__3256_v0 arg_names_40087[@] arg_texts_40088[@] arg_notes_40089[@] 20
    printf '%s\n' ""
    colored_secondary__3122_v0 "Flags:"
    local ret_colored_secondary3122_v0__18_12="${ret_colored_secondary3122_v0}"
    local array_740=()
    printf__128_v0 "${ret_colored_secondary3122_v0__18_12}""
" array_740[@]
    local names_40122=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_40123=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_40124=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__3256_v0 names_40122[@] texts_40123[@] notes_40124[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3846_v0() {
    local parameters_40039=("${!1}")
    local cursor_40040="> "
    local start_path_40041=""
    local show_hidden_40042=0
    local page_size_40043=10
    local __length_747=("${parameters_40039[@]}")
    local slice_upper_746="${#__length_747[@]}"
    local slice_offset_748=2
    local slice_offset_748=$((${slice_offset_748} > 0 ? ${slice_offset_748} : 0))
    local slice_length_749="$(( slice_upper_746 - slice_offset_748 ))"
    local slice_length_749=$((${slice_length_749} > 0 ? ${slice_length_749} : 0))
    for param_40044 in "${parameters_40039[@]:${slice_offset_748}:${slice_length_749}}"; do
        starts_with__22_v0 "${param_40044}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40044}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40044}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_40044}" != "_-h" ]; echo $?) || $([ "_${param_40044}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3788_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_750="--cursor="
            slice__24_v0 "${param_40044}" "${#__length_750}" 0
            cursor_40040="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_751="--path="
            slice__24_v0 "${param_40044}" "${#__length_751}" 0
            start_path_40041="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_40044}" != "_-a" ]; echo $?) || $([ "_${param_40044}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_40042=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_752="--page-size="
            slice__24_v0 "${param_40044}" "${#__length_752}" 0
            local value_40125="${ret_slice24_v0}"
            parse_int__13_v0 "${value_40125}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__3020_v0 "ERROR: Invalid page-size value: ""${value_40125}""
" 31
                exit 1
            fi
            page_size_40043="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_40041="${param_40044}"
        fi
    done
    xyl_file__3688_v0 "${start_path_40041}" "${cursor_40040}" "${show_hidden_40042}" "${page_size_40043}"
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
    result_29711="${ret_execute_confirm2901_v0}"
    if [ "$([ "_${result_29711}" != "_yes" ]; echo $?)" != 0 ]; then
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
