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
    local text_1477="${1}"
    local delimiter_1478="${2}"
    local result_1479=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1478}" read -rd '' -A result_1479 < <(printf %s "$text_1477")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1478}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1479+=("$REPLY"); done < <(echo "$text_1477")
            __status=$?
        else
            IFS="${delimiter_1478}" read -rd '' -a result_1479 < <(printf %s "$text_1477")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1478}" read -rd '' -a result_1479 < <(printf %s "$text_1477")
        __status=$?
    fi
    ret_split4_v0=("${result_1479[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_18090=("${!1}")
    local delimiter_18091="${2}"
    local command_1
    command_1="$(IFS="${delimiter_18091}" ; printf "%s
" "${list_18090[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1481="${1}"
    [ -n "${text_1481}" ] && [ "${text_1481}" -eq "${text_1481}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1481}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_3163="${1}"
    local prefix_3164="${2}"
    [[ "${text_3163}" == "${prefix_3164}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1567="${1}"
    local index_1568="${2}"
    local length_1569="${3}"
    local result_1570=""
    if [ "$(( length_1569 == 0 ))" != 0 ]; then
        local __length_2="${text_1567}"
        length_1569="$(( ${#__length_2} - index_1568 ))"
    fi
    if [ "$(( length_1569 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1570}"
        return 0
    fi
    result_1570="${text_1567: ${index_1568}: ${length_1569}}"
    __status=$?
    ret_slice24_v0="${result_1570}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_29633="${1}"
    local pad_29634="${2}"
    local length_29635="${3}"
    local __length_3="${text_29633}"
    if [ "$(( length_29635 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_29633}"
        return 0
    fi
    local __length_4="${text_29633}"
    local pad_len_29636="$(( length_29635 - ${#__length_4} ))"
    local padding_29637=""
    printf -v padding_29637 "%${pad_len_29636}s" ""
    __status=$?
    padding_29637="${padding_29637// /${pad_29634}}"
    __status=$?
    ret_lpad27_v0="${padding_29637}""${text_29633}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1547="${1}"
    local pad_1548="${2}"
    local length_1549="${3}"
    local __length_5="${text_1547}"
    if [ "$(( length_1549 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1547}"
        return 0
    fi
    local __length_6="${text_1547}"
    local pad_len_1550="$(( length_1549 - ${#__length_6} ))"
    local padding_1551=""
    printf -v padding_1551 "%${pad_len_1550}s" ""
    __status=$?
    padding_1551="${padding_1551// /${pad_1548}}"
    __status=$?
    ret_rpad28_v0="${text_1547}""${padding_1551}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_29627="${1}"
    local pad_29628="${2}"
    local length_29629="${3}"
    local __length_7="${text_29627}"
    local text_length_29630="${#__length_7}"
    if [ "$(( length_29629 <= text_length_29630 ))" != 0 ]; then
        ret_cpad29_v0="${text_29627}"
        return 0
    fi
    local total_padding_29631="$(( length_29629 - text_length_29630 ))"
    local left_padding_length_29632="$(( text_length_29630 + $(( total_padding_29631 / 2 )) ))"
    lpad__27_v0 "${text_29627}" "${pad_29628}" "${left_padding_length_29632}"
    local left_padded_29638="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_29638}" "${pad_29628}" "${length_29629}"
    local center_padded_29639="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_29639}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_40292="${1}"
    [ -d "${path_40292}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1507="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1507}")"
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
" "${(P)name_1507}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1507}")"
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
    local format_1504="${1}"
    local args_1505=("${!2}")
    args_1505=("${format_1504}" "${args_1505[@]}")
    __status=$?
    printf "${args_1505[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1517="${1}"
    local args_1518=("${!2}")
    args_1518=("${format_1517}" "${args_1518[@]}")
    __status=$?
    printf "${args_1518[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1514="${1}"
    local color_1515="${2}"
    local color_code_1516=0
        color_code_1516="${color_1515}"
    local array_11=("${message_1514}")
    printf__128_v1 "\\x1b[${color_code_1516}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_40295="${1}"
    local color_40296="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_40295}")
    printf__128_v1 "\\x1b[${color_40296}m%s\\x1b[0m" array_12[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_3="None"
# perl_available()
perl_available__184_v0() {
    if [ "$([ "_${_perl_state_3}" != "_None" ]; echo $?)" != 0 ]; then
        local command_13
        command_13="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_1500
        disabled_1500="$([ "_${command_13}" != "_No" ]; echo $?)"
        local command_14
        command_14="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1501
        found_1501="$(( $(( ! disabled_1500 )) && $([ "_${command_14}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1501}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available184_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__185_v0() {
    local text_1499="${1}"
    perl_available__184_v0 
    local ret_perl_available184_v0__19_12="${ret_perl_available184_v0}"
    if [ "$(( ! ret_perl_available184_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return 1
    fi
    local command_15
    command_15="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1499}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_str_1502="${command_15}"
    parse_int__13_v0 "${width_str_1502}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_1503="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width185_v0="${width_1503}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__190_v0() {
    local text_1489="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_16
    command_16="$([[ "${text_1489}" == *$'\x1b'* || "${text_1489}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1490="${command_16}"
    ret_has_ansi_escape190_v0="$([ "_${has_escape_1490}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__192_v0() {
    local text_1495="${1}"
    local command_17
    command_17="$(printf "%s" "${text_1495}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi192_v0="${command_17}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__193_v0() {
    local text_1497="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1497}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1498="${command_18}"
    ret_is_all_ascii193_v0="$([ "_${result_1498}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__194_v0() {
    local text_1492="${1}"
    local command_19
    command_19="$(LC_ALL=C; __t="${text_1492}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_1493="${command_19}"
    parse_int__13_v0 "${measured_1493}"
    __status=$?
    ret_plain_len194_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__195_v0() {
    local text_1491="${1}"
    plain_len__194_v0 "${text_1491}"
    local plain_1494="${ret_plain_len194_v0}"
    if [ "$(( plain_1494 >= 0 ))" != 0 ]; then
        ret_get_visible_len195_v0="${plain_1494}"
        return 0
    fi
    strip_ansi__192_v0 "${text_1491}"
    local stripped_1496="${ret_strip_ansi192_v0}"
    is_all_ascii__193_v0 "${stripped_1496}"
    local ret_is_all_ascii193_v0__46_12="${ret_is_all_ascii193_v0}"
    if [ "$(( ! ret_is_all_ascii193_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__185_v0 "${stripped_1496}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_20="${stripped_1496}"
            ret_get_visible_len195_v0="${#__length_20}"
            return 0
        fi
        ret_get_visible_len195_v0="${ret_perl_get_cjk_width185_v0}"
        return 0
    fi
    local __length_21="${stripped_1496}"
    ret_get_visible_len195_v0="${#__length_21}"
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
    local size_1476="${1}"
    if [ "$([ "_${size_1476}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size204_v0=0
        return 0
    fi
    split__4_v0 "${size_1476}" " "
    local parts_1480=("${ret_split4_v0[@]}")
    local __length_23=("${parts_1480[@]}")
    if [ "$(( ${#__length_23[@]} != 2 ))" != 0 ]; then
        ret_store_term_size204_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1480[1]?"Index out of bounds (at src/utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1480[0]?"Index out of bounds (at src/utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_5=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size204_v0=1
    return 0
}

# query_term_size()
query_term_size__205_v0() {
    local command_25
    command_25="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1483="${command_25}"
    store_term_size__204_v0 "${size_1483}"
    ret_query_term_size205_v0="${ret_store_term_size204_v0}"
    return 0
}

# stty_term_size()
stty_term_size__206_v0() {
    local command_26
    command_26="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1475="${command_26}"
    store_term_size__204_v0 "${size_1475}"
    ret_stty_term_size206_v0="${ret_store_term_size204_v0}"
    return 0
}

# get_term_size()
get_term_size__207_v0() {
    stty_term_size__206_v0 
    local detected_1482="${ret_stty_term_size206_v0}"
    if [ "$(( ! detected_1482 ))" != 0 ]; then
        query_term_size__205_v0 
        detected_1482="${ret_query_term_size205_v0}"
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
    local pieces_1474=("${!1}")
    term_width__209_v0 
    local width_1484="${ret_term_width209_v0}"
    local line_1485=""
    local line_len_1486=0
    for piece_1487 in "${pieces_1474[@]}"; do
        local __length_29="${piece_1487}"
        local piece_len_1488="${#__length_29}"
        has_ansi_escape__190_v0 "${piece_1487}"
        local ret_has_ansi_escape190_v0__186_12="${ret_has_ansi_escape190_v0}"
        if [ "${ret_has_ansi_escape190_v0__186_12}" != 0 ]; then
            get_visible_len__195_v0 "${piece_1487}"
            piece_len_1488="${ret_get_visible_len195_v0}"
        fi
        if [ "$([ "_${line_1485}" != "_" ]; echo $?)" != 0 ]; then
            line_1485="${piece_1487}"
            line_len_1486="${piece_len_1488}"
        elif [ "$(( $(( $(( line_len_1486 + 1 )) + piece_len_1488 )) > width_1484 ))" != 0 ]; then
            local array_30=()
            printf__128_v0 "${line_1485}""
" array_30[@]
            line_1485="${piece_1487}"
            line_len_1486="${piece_len_1488}"
        else
            line_1485+=" ""${piece_1487}"
            line_len_1486="$(( line_len_1486 + $(( 1 + piece_len_1488 )) ))"
        fi
    done
    if [ "$([ "_${line_1485}" == "_" ]; echo $?)" != 0 ]; then
        local array_31=()
        printf__128_v0 "${line_1485}""
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
get_supports_truecolor__258_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1524="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1524}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor258_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__259_v0() {
    local message_1519="${1}"
    local r_1520="${2}"
    local g_1521="${3}"
    local b_1522="${4}"
    local fallback_1523="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb259_v0="\\x1b[38;2;${r_1520};${g_1521};${b_1522}m""${message_1519}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__258_v0 
        local ret_get_supports_truecolor258_v0__45_17="${ret_get_supports_truecolor258_v0}"
        if [ "${ret_get_supports_truecolor258_v0__45_17}" != 0 ]; then
            ret_colored_rgb259_v0="\\x1b[38;2;${r_1520};${g_1521};${b_1522}m""${message_1519}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1523 == 0 ))" != 0 ]; then
            ret_colored_rgb259_v0="${message_1519}"
            return 0
        else
            ret_colored_rgb259_v0="\\x1b[${fallback_1523}m""${message_1519}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1523 == 0 ))" != 0 ]; then
            ret_colored_rgb259_v0="${message_1519}"
            return 0
        fi
        ret_colored_rgb259_v0="\\x1b[${fallback_1523}m""${message_1519}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__261_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1508="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1508}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1508}" ";"
            local parts_1509=("${ret_split4_v0[@]}")
            local __length_35=("${parts_1509[@]}")
            if [ "$(( ${#__length_35[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1509[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1509[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1509[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1509[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
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
        local secondary_env_1510="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1510}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1510}" ";"
            local parts_1511=("${ret_split4_v0[@]}")
            local __length_37=("${parts_1511[@]}")
            if [ "$(( ${#__length_37[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1511[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1511[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1511[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1511[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
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
        local accent_env_1512="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1512}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1512}" ";"
            local parts_1513=("${ret_split4_v0[@]}")
            local __length_39=("${parts_1513[@]}")
            if [ "$(( ${#__length_39[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1513[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1513[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1513[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors261_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1513[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
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
    local message_1506="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1506}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary263_v0="${ret_colored_rgb259_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__264_v0() {
    local message_1526="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1526}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary264_v0="${ret_colored_rgb259_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__265_v0() {
    local message_1577="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__262_v0 
    fi
    colored_rgb__259_v0 "${message_1577}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent265_v0="${ret_colored_rgb259_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__318_v0() {
    local message_1565="${1}"
    local color_1566="${2}"
    # Returns a text wrapped in color codes.
    ret_colored318_v0="\\x1b[${color_1566}m""${message_1565}""\\x1b[0m"
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
    local size_1539="${1}"
    if [ "$([ "_${size_1539}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size359_v0=0
        return 0
    fi
    split__4_v0 "${size_1539}" " "
    local parts_1540=("${ret_split4_v0[@]}")
    local __length_42=("${parts_1540[@]}")
    if [ "$(( ${#__length_42[@]} != 2 ))" != 0 ]; then
        ret_store_term_size359_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1540[1]?"Index out of bounds (at src/utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1540[0]?"Index out of bounds (at src/utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_17=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size359_v0=1
    return 0
}

# query_term_size()
query_term_size__360_v0() {
    local command_44
    command_44="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1542="${command_44}"
    store_term_size__359_v0 "${size_1542}"
    ret_query_term_size360_v0="${ret_store_term_size359_v0}"
    return 0
}

# stty_term_size()
stty_term_size__361_v0() {
    local command_45
    command_45="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1538="${command_45}"
    store_term_size__359_v0 "${size_1538}"
    ret_stty_term_size361_v0="${ret_store_term_size359_v0}"
    return 0
}

# get_term_size()
get_term_size__362_v0() {
    stty_term_size__361_v0 
    local detected_1541="${ret_stty_term_size361_v0}"
    if [ "$(( ! detected_1541 ))" != 0 ]; then
        query_term_size__360_v0 
        detected_1541="${ret_query_term_size360_v0}"
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
    local pending_1562="${1}"
    local line_1563="${2}"
    local note_at_1564="${3}"
    if [ "$(( note_at_1564 < 0 ))" != 0 ]; then
        local array_47=()
        printf__128_v0 "${pending_1562}""${line_1563}""
" array_47[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1564 == 0 ))" != 0 ]; then
        colored__318_v0 "${line_1563}" 90
        local ret_colored318_v0__12_40="${ret_colored318_v0}"
        local array_48=()
        printf__128_v0 "${pending_1562}""${ret_colored318_v0__12_40}""
" array_48[@]
    else
        slice__24_v0 "${line_1563}" 0 "${note_at_1564}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1563}" "${note_at_1564}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__318_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored318_v0__13_58="${ret_colored318_v0}"
        local array_49=()
        printf__128_v0 "${pending_1562}""${ret_slice24_v0__13_32}""${ret_colored318_v0__13_58}""
" array_49[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__398_v0() {
    local names_1530=("${!1}")
    local texts_1531=("${!2}")
    local notes_1532=("${!3}")
    local min_name_width_1533="${4}"
    local __length_50=("${names_1530[@]}")
    local count_1534="${#__length_50[@]}"
    local name_width_1535="${min_name_width_1533}"
    local __range_start_1536=0
    local __range_end_1536="${count_1534}"
    local __dir_1536=$(( ${__range_start_1536} <= ${__range_end_1536} ? 1 : -1 ))
    for (( i_1536=${__range_start_1536}; i_1536 * ${__dir_1536} < ${__range_end_1536} * ${__dir_1536}; i_1536+=${__dir_1536} )); do
        local __length_51="${names_1530[${i_1536}]?"Index out of bounds (at src/utils/widget/help.ab:28:33)"}"
        local width_1537="${#__length_51}"
        if [ "$(( width_1537 > name_width_1535 ))" != 0 ]; then
            name_width_1535="${width_1537}"
        fi
done
    term_width__364_v0 
    local width_1543="${ret_term_width364_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1544="$(( name_width_1535 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1545="$(( $(( width_1543 - indent_1544 )) < 24 ))"
    if [ "${stacked_1545}" != 0 ]; then
        indent_1544=6
    fi
    local avail_1546="$(( width_1543 - indent_1544 ))"
    rpad__28_v0 "" " " "${indent_1544}"
    local blank_1552="${ret_rpad28_v0}"
    local __range_start_1553=0
    local __range_end_1553="${count_1534}"
    local __dir_1553=$(( ${__range_start_1553} <= ${__range_end_1553} ? 1 : -1 ))
    for (( i_1553=${__range_start_1553}; i_1553 * ${__dir_1553} < ${__range_end_1553} * ${__dir_1553}; i_1553+=${__dir_1553} )); do
        local pending_1554="${blank_1552}"
        if [ "${stacked_1545}" != 0 ]; then
            local array_52=()
            printf__128_v0 "  ""${names_1530[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:48:33)"}""
" array_52[@]
        else
            rpad__28_v0 "  ""${names_1530[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:50:41)"}" " " "${indent_1544}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_1554="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_1531[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_1555=("${ret_split4_v0__52_21[@]}")
        local __length_53=("${words_1555[@]}")
        local note_start_1556="${#__length_53[@]}"
        if [ "$([ "_${notes_1532[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_54="${notes_1532[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_54} > avail_1546 ))" != 0 ]; then
                split__4_v0 "${notes_1532[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_1555+=("${ret_split4_v0__58_26[@]}")
            else
                local array_55=("${notes_1532[${i_1553}]?"Index out of bounds (at src/utils/widget/help.ab:60:33)"}")
                words_1555+=("${array_55[@]}")
            fi
        fi
        local line_1557=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1558=-1
        local __range_start_1559=0
        local __length_56=("${words_1555[@]}")
        local __range_end_1559="${#__length_56[@]}"
        local __dir_1559=$(( ${__range_start_1559} <= ${__range_end_1559} ? 1 : -1 ))
        for (( j_1559=${__range_start_1559}; j_1559 * ${__dir_1559} < ${__range_end_1559} * ${__dir_1559}; j_1559+=${__dir_1559} )); do
            local word_1560="${words_1555[${j_1559}]?"Index out of bounds (at src/utils/widget/help.ab:70:32)"}"
            local candidate_1561
            candidate_1561="$(if [ "$([ "_${line_1557}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1560}"; else echo "${line_1557}"" ""${word_1560}"; fi)"
            local __length_57="${candidate_1561}"
            if [ "$(( $(( ${#__length_57} > avail_1546 )) && $([ "_${line_1557}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__397_v0 "${pending_1554}" "${line_1557}" "${note_at_1558}"
                pending_1554="${blank_1552}"
                line_1557="${word_1560}"
                note_at_1558="$(if [ "$(( j_1559 >= note_start_1556 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1559 >= note_start_1556 )) && $(( note_at_1558 < 0 )) ))" != 0 ]; then
                    local __length_58="${candidate_1561}"
                    local __length_59="${word_1560}"
                    note_at_1558="$(( ${#__length_58} - ${#__length_59} ))"
                fi
                line_1557="${candidate_1561}"
            fi
done
        print_help_line__397_v0 "${pending_1554}" "${line_1557}" "${note_at_1558}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__555_v0() {
    local usage_1473=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__221_v0 usage_1473[@]
    printf '%s\n' ""
    colored_primary__263_v0 "Xylitol"
    local ret_colored_primary263_v0__9_21="${ret_colored_primary263_v0}"
    colored_primary__263_v0 "fresh"
    local ret_colored_primary263_v0__10_34="${ret_colored_primary263_v0}"
    local title_1525=("\\x1b[1m""${ret_colored_primary263_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary263_v0__10_34}" "shell" "scripts.")
    print_wrapped__221_v0 title_1525[@]
    printf '%s\n' ""
    colored_secondary__264_v0 "Flags:"
    local ret_colored_secondary264_v0__14_12="${ret_colored_secondary264_v0}"
    local array_62=()
    printf__128_v0 "${ret_colored_secondary264_v0__14_12}""
" array_62[@]
    local flag_names_1527=("-h, --help" "-v, --version")
    local flag_texts_1528=("Show this help message" "Show version information")
    local flag_notes_1529=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__398_v0 flag_names_1527[@] flag_texts_1528[@] flag_notes_1529[@] 13
    printf '%s\n' ""
    colored_secondary__264_v0 "Commands:"
    local ret_colored_secondary264_v0__21_12="${ret_colored_secondary264_v0}"
    local array_66=()
    printf__128_v0 "${ret_colored_secondary264_v0__21_12}""
" array_66[@]
    local cmd_names_1571=("input" "choose" "filter" "confirm" "file")
    local cmd_texts_1572=("Prompt for some input" "Choose from a list of options" "Pick from a list narrowed by typing" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1573=("" "" "" "" "")
    render_help_entries__398_v0 cmd_names_1571[@] cmd_texts_1572[@] cmd_notes_1573[@] 13
    printf '%s\n' ""
    colored_secondary__264_v0 "Envs:"
    local ret_colored_secondary264_v0__33_12="${ret_colored_secondary264_v0}"
    local array_70=()
    printf__128_v0 "${ret_colored_secondary264_v0__33_12}""
" array_70[@]
    local env_names_1574=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1575=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1576=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__398_v0 env_names_1574[@] env_texts_1575[@] env_notes_1576[@] 0
    printf '%s\n' ""
    colored_accent__265_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent265_v0__58_16="${ret_colored_accent265_v0}"
    local footer_1578=("Run" "${ret_colored_accent265_v0__58_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__221_v0 footer_1578[@]
}

# get_char()
get_char__635_v0() {
    local command_75
    command_75="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3243="${command_75}"
    ret_get_char635_v0="${char_3243}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__638_v0() {
    local format_3215="${1}"
    local args_3216=("${!2}")
    args_3216=("${format_3215}" "${args_3216[@]}")
    __status=$?
    printf "${args_3216[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__639_v0() {
    local message_3241="${1}"
    local color_3242="${2}"
    # Prints an error message with a specified color.
    local array_76=("${message_3241}")
    eprintf__638_v0 "\\x1b[${color_3242}m%s\\x1b[0m" array_76[@]
}

# eprintf(format: Text, args: [Text])
eprintf__654_v0() {
    local format_3219="${1}"
    local args_3220=("${!2}")
    args_3220=("${format_3219}" "${args_3220[@]}")
    __status=$?
    printf "${args_3220[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_24="None"
# perl_available()
perl_available__661_v0() {
    if [ "$([ "_${_perl_state_24}" != "_None" ]; echo $?)" != 0 ]; then
        local command_77
        command_77="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3109
        disabled_3109="$([ "_${command_77}" != "_No" ]; echo $?)"
        local command_78
        command_78="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3110
        found_3110="$(( $(( ! disabled_3109 )) && $([ "_${command_78}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_3110}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available661_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__662_v0() {
    local text_3108="${1}"
    perl_available__661_v0 
    local ret_perl_available661_v0__19_12="${ret_perl_available661_v0}"
    if [ "$(( ! ret_perl_available661_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width662_v0=''
        return 1
    fi
    local command_79
    command_79="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3108}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width662_v0=''
        return "${__status}"
    fi
    local width_str_3111="${command_79}"
    parse_int__13_v0 "${width_str_3111}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width662_v0=''
        return "${__status}"
    fi
    local width_3112="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width662_v0="${width_3112}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__667_v0() {
    local text_3098="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_80
    command_80="$([[ "${text_3098}" == *$'\x1b'* || "${text_3098}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3099="${command_80}"
    ret_has_ansi_escape667_v0="$([ "_${has_escape_3099}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__669_v0() {
    local text_3104="${1}"
    local command_81
    command_81="$(printf "%s" "${text_3104}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi669_v0="${command_81}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__670_v0() {
    local text_3106="${1}"
    local command_82
    command_82="$(printf "%s" "${text_3106}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3107="${command_82}"
    ret_is_all_ascii670_v0="$([ "_${result_3107}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__671_v0() {
    local text_3101="${1}"
    local command_83
    command_83="$(LC_ALL=C; __t="${text_3101}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3102="${command_83}"
    parse_int__13_v0 "${measured_3102}"
    __status=$?
    ret_plain_len671_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__672_v0() {
    local text_3100="${1}"
    plain_len__671_v0 "${text_3100}"
    local plain_3103="${ret_plain_len671_v0}"
    if [ "$(( plain_3103 >= 0 ))" != 0 ]; then
        ret_get_visible_len672_v0="${plain_3103}"
        return 0
    fi
    strip_ansi__669_v0 "${text_3100}"
    local stripped_3105="${ret_strip_ansi669_v0}"
    is_all_ascii__670_v0 "${stripped_3105}"
    local ret_is_all_ascii670_v0__46_12="${ret_is_all_ascii670_v0}"
    if [ "$(( ! ret_is_all_ascii670_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__662_v0 "${stripped_3105}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_84="${stripped_3105}"
            ret_get_visible_len672_v0="${#__length_84}"
            return 0
        fi
        ret_get_visible_len672_v0="${ret_perl_get_cjk_width662_v0}"
        return 0
    fi
    local __length_85="${stripped_3105}"
    ret_get_visible_len672_v0="${#__length_85}"
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
stty_count__678_v0() {
    local command_87
    command_87="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_3173="${command_87}"
    parse_int__13_v0 "${count_3173}"
    __status=$?
    ret_stty_count678_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__679_v0() {
    stty_count__678_v0 
    local count_num_3174="${ret_stty_count678_v0}"
    if [ "$(( count_num_3174 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_3174="$(( count_num_3174 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3174}
    __status=$?
}

# stty_unlock()
stty_unlock__680_v0() {
    stty_count__678_v0 
    local count_num_3246="${ret_stty_count678_v0}"
    if [ "$(( count_num_3246 > 0 ))" != 0 ]; then
        count_num_3246="$(( count_num_3246 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3246}
        __status=$?
        if [ "$(( count_num_3246 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__681_v0() {
    local size_3089="${1}"
    if [ "$([ "_${size_3089}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size681_v0=0
        return 0
    fi
    split__4_v0 "${size_3089}" " "
    local parts_3090=("${ret_split4_v0[@]}")
    local __length_88=("${parts_3090[@]}")
    if [ "$(( ${#__length_88[@]} != 2 ))" != 0 ]; then
        ret_store_term_size681_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3090[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3090[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_26=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size681_v0=1
    return 0
}

# query_term_size()
query_term_size__682_v0() {
    local command_90
    command_90="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_3092="${command_90}"
    store_term_size__681_v0 "${size_3092}"
    ret_query_term_size682_v0="${ret_store_term_size681_v0}"
    return 0
}

# stty_term_size()
stty_term_size__683_v0() {
    local command_91
    command_91="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3088="${command_91}"
    store_term_size__681_v0 "${size_3088}"
    ret_stty_term_size683_v0="${ret_store_term_size681_v0}"
    return 0
}

# get_term_size()
get_term_size__684_v0() {
    stty_term_size__683_v0 
    local detected_3091="${ret_stty_term_size683_v0}"
    if [ "$(( ! detected_3091 ))" != 0 ]; then
        query_term_size__682_v0 
        detected_3091="${ret_query_term_size682_v0}"
    fi
    _got_term_size_25=1
}

# term_width()
term_width__686_v0() {
    if [ "$(( ! _got_term_size_25 ))" != 0 ]; then
        get_term_size__684_v0 
    fi
    ret_term_width686_v0="${_term_size_26[0]?"Index out of bounds (at src/./input/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove(cnt: Int)
remove__688_v0() {
    local cnt_3244="${1}"
    if [ "$(( cnt_3244 > 0 ))" != 0 ]; then
        local array_92=("")
        eprintf__654_v0 "\\x1b[${cnt_3244}D\\x1b[K" array_92[@]
    fi
}

# remove_line(cnt: Int)
remove_line__689_v0() {
    local cnt_3250="${1}"
    if [ "$(( cnt_3250 > 0 ))" != 0 ]; then
        local sequence_3251=""
        local __range_start_3252=0
        local __range_end_3252="${cnt_3250}"
        local __dir_3252=$(( ${__range_start_3252} <= ${__range_end_3252} ? 1 : -1 ))
        for (( ____3252=${__range_start_3252}; ____3252 * ${__dir_3252} < ${__range_end_3252} * ${__dir_3252}; ____3252+=${__dir_3252} )); do
            sequence_3251+="\\x1b[2K\\x1b[1A"
done
        local array_93=("")
        eprintf__654_v0 "${sequence_3251}" array_93[@]
    fi
    local array_94=("")
    eprintf__654_v0 "\\x1b[G" array_94[@]
}

# remove_current_line()
remove_current_line__690_v0() {
    local array_95=("")
    eprintf__654_v0 "\\x1b[2K\\x1b[G" array_95[@]
}

# new_line(cnt: Int)
new_line__692_v0() {
    local cnt_3217="${1}"
    local __range_start_3218=0
    local __range_end_3218="${cnt_3217}"
    local __dir_3218=$(( ${__range_start_3218} <= ${__range_end_3218} ? 1 : -1 ))
    for (( ____3218=${__range_start_3218}; ____3218 * ${__dir_3218} < ${__range_end_3218} * ${__dir_3218}; ____3218+=${__dir_3218} )); do
        local array_96=("")
        eprintf__654_v0 "
" array_96[@]
done
}

# go_up(cnt: Int)
go_up__693_v0() {
    local cnt_3238="${1}"
    local array_97=("")
    eprintf__654_v0 "\\x1b[${cnt_3238}A" array_97[@]
}

# go_down(cnt: Int)
go_down__694_v0() {
    local cnt_3249="${1}"
    local array_98=("")
    eprintf__654_v0 "\\x1b[${cnt_3249}B" array_98[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__698_v0() {
    local pieces_3087=("${!1}")
    term_width__686_v0 
    local width_3093="${ret_term_width686_v0}"
    local line_3094=""
    local line_len_3095=0
    for piece_3096 in "${pieces_3087[@]}"; do
        local __length_101="${piece_3096}"
        local piece_len_3097="${#__length_101}"
        has_ansi_escape__667_v0 "${piece_3096}"
        local ret_has_ansi_escape667_v0__186_12="${ret_has_ansi_escape667_v0}"
        if [ "${ret_has_ansi_escape667_v0__186_12}" != 0 ]; then
            get_visible_len__672_v0 "${piece_3096}"
            piece_len_3097="${ret_get_visible_len672_v0}"
        fi
        if [ "$([ "_${line_3094}" != "_" ]; echo $?)" != 0 ]; then
            line_3094="${piece_3096}"
            line_len_3095="${piece_len_3097}"
        elif [ "$(( $(( $(( line_len_3095 + 1 )) + piece_len_3097 )) > width_3093 ))" != 0 ]; then
            local array_102=()
            printf__128_v0 "${line_3094}""
" array_102[@]
            line_3094="${piece_3096}"
            line_len_3095="${piece_len_3097}"
        else
            line_3094+=" ""${piece_3096}"
            line_len_3095="$(( line_len_3095 + $(( 1 + piece_len_3097 )) ))"
        fi
    done
    if [ "$([ "_${line_3094}" == "_" ]; echo $?)" != 0 ]; then
        local array_103=()
        printf__128_v0 "${line_3094}""
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
get_supports_truecolor__735_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_3125="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_3125}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor735_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__736_v0() {
    local message_3120="${1}"
    local r_3121="${2}"
    local g_3122="${3}"
    local b_3123="${4}"
    local fallback_3124="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb736_v0="\\x1b[38;2;${r_3121};${g_3122};${b_3123}m""${message_3120}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__735_v0 
        local ret_get_supports_truecolor735_v0__45_17="${ret_get_supports_truecolor735_v0}"
        if [ "${ret_get_supports_truecolor735_v0__45_17}" != 0 ]; then
            ret_colored_rgb736_v0="\\x1b[38;2;${r_3121};${g_3122};${b_3123}m""${message_3120}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_3124 == 0 ))" != 0 ]; then
            ret_colored_rgb736_v0="${message_3120}"
            return 0
        else
            ret_colored_rgb736_v0="\\x1b[${fallback_3124}m""${message_3120}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_3124 == 0 ))" != 0 ]; then
            ret_colored_rgb736_v0="${message_3120}"
            return 0
        fi
        ret_colored_rgb736_v0="\\x1b[${fallback_3124}m""${message_3120}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__738_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_3114="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_3114}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_3114}" ";"
            local parts_3115=("${ret_split4_v0[@]}")
            local __length_107=("${parts_3115[@]}")
            if [ "$(( ${#__length_107[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3115[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3115[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3115[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3115[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_31=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_3116="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_3116}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_3116}" ";"
            local parts_3117=("${ret_split4_v0[@]}")
            local __length_109=("${parts_3117[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3117[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3117[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3117[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3117[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_32=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_3118="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_3118}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_3118}" ";"
            local parts_3119=("${ret_split4_v0[@]}")
            local __length_111=("${parts_3119[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3119[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3119[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3119[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3119[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors738_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_30=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__739_v0() {
    inner_get_xylitol_colors__738_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_30=1
}

# colored_primary(message: Text)
colored_primary__740_v0() {
    local message_3113="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__739_v0 
    fi
    colored_rgb__736_v0 "${message_3113}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary740_v0="${ret_colored_rgb736_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__741_v0() {
    local message_3127="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__739_v0 
    fi
    colored_rgb__736_v0 "${message_3127}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary741_v0="${ret_colored_rgb736_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_34="None"
# perl_available()
perl_available__758_v0() {
    if [ "$([ "_${_perl_state_34}" != "_None" ]; echo $?)" != 0 ]; then
        local command_113
        command_113="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3187
        disabled_3187="$([ "_${command_113}" != "_No" ]; echo $?)"
        local command_114
        command_114="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3188
        found_3188="$(( $(( ! disabled_3187 )) && $([ "_${command_114}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3188}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available758_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__759_v0() {
    local text_3186="${1}"
    perl_available__758_v0 
    local ret_perl_available758_v0__19_12="${ret_perl_available758_v0}"
    if [ "$(( ! ret_perl_available758_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width759_v0=''
        return 1
    fi
    local command_115
    command_115="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3186}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width759_v0=''
        return "${__status}"
    fi
    local width_str_3189="${command_115}"
    parse_int__13_v0 "${width_str_3189}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width759_v0=''
        return "${__status}"
    fi
    local width_3190="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width759_v0="${width_3190}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__760_v0() {
    local text_3197="${1}"
    local max_width_3198="${2}"
    perl_available__758_v0 
    local ret_perl_available758_v0__30_12="${ret_perl_available758_v0}"
    if [ "$(( ! ret_perl_available758_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk760_v0=''
        return 1
    fi
    local command_116
    command_116="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3197}" ${max_width_3198} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk760_v0=''
        return "${__status}"
    fi
    local result_3199="${command_116}"
    ret_perl_truncate_cjk760_v0="${result_3199}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__764_v0() {
    local text_3165="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_117
    command_117="$([[ "${text_3165}" == *$'\x1b'* || "${text_3165}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3166="${command_117}"
    ret_has_ansi_escape764_v0="$([ "_${has_escape_3166}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__765_v0() {
    local text_3167="${1}"
    local command_118
    command_118="$(printf '%s' "${text_3167}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi765_v0="${command_118}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__766_v0() {
    local text_3182="${1}"
    local command_119
    command_119="$(printf "%s" "${text_3182}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi766_v0="${command_119}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__767_v0() {
    local text_3184="${1}"
    local command_120
    command_120="$(printf "%s" "${text_3184}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3185="${command_120}"
    ret_is_all_ascii767_v0="$([ "_${result_3185}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__768_v0() {
    local text_3179="${1}"
    local command_121
    command_121="$(LC_ALL=C; __t="${text_3179}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3180="${command_121}"
    parse_int__13_v0 "${measured_3180}"
    __status=$?
    ret_plain_len768_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__769_v0() {
    local text_3178="${1}"
    plain_len__768_v0 "${text_3178}"
    local plain_3181="${ret_plain_len768_v0}"
    if [ "$(( plain_3181 >= 0 ))" != 0 ]; then
        ret_get_visible_len769_v0="${plain_3181}"
        return 0
    fi
    strip_ansi__766_v0 "${text_3178}"
    local stripped_3183="${ret_strip_ansi766_v0}"
    is_all_ascii__767_v0 "${stripped_3183}"
    local ret_is_all_ascii767_v0__46_12="${ret_is_all_ascii767_v0}"
    if [ "$(( ! ret_is_all_ascii767_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__759_v0 "${stripped_3183}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_122="${stripped_3183}"
            ret_get_visible_len769_v0="${#__length_122}"
            return 0
        fi
        ret_get_visible_len769_v0="${ret_perl_get_cjk_width759_v0}"
        return 0
    fi
    local __length_123="${stripped_3183}"
    ret_get_visible_len769_v0="${#__length_123}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__770_v0() {
    local text_3194="${1}"
    local max_width_3195="${2}"
    get_visible_len__769_v0 "${text_3194}"
    local visible_len_3196="${ret_get_visible_len769_v0}"
    if [ "$(( visible_len_3196 <= max_width_3195 ))" != 0 ]; then
        ret_truncate_text770_v0="${text_3194}"
        return 0
    fi
    is_all_ascii__767_v0 "${text_3194}"
    local ret_is_all_ascii767_v0__61_12="${ret_is_all_ascii767_v0}"
    if [ "$(( ! ret_is_all_ascii767_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__760_v0 "${text_3194}" "${max_width_3195}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3194}" | cut -c1-${max_width_3195}
            __status=$?
        fi
        ret_truncate_text770_v0="${ret_perl_truncate_cjk760_v0}"
        return 0
    fi
    local command_124
    command_124="$(printf "%s" "${text_3194}" | cut -c1-${max_width_3195})"
    __status=$?
    ret_truncate_text770_v0="${command_124}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__771_v0() {
    local text_3192="${1}"
    local max_width_3193="${2}"
    has_ansi_escape__764_v0 "${text_3192}"
    local ret_has_ansi_escape764_v0__73_12="${ret_has_ansi_escape764_v0}"
    if [ "$(( ! ret_has_ansi_escape764_v0__73_12 ))" != 0 ]; then
        truncate_text__770_v0 "${text_3192}" "${max_width_3193}"
        ret_truncate_ansi771_v0="${ret_truncate_text770_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_125
    command_125="$([[ "${text_3192}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3200="${command_125}"
    # Replace \x1b[ with newline, then split
    local command_126
    command_126="$(t="${text_3192}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3201="${command_126}"
    split__4_v0 "${replaced_3201}" "
"
    local parts_3202=("${ret_split4_v0[@]}")
    local result_3203=""
    local remaining_width_3204="${max_width_3193}"
    local __range_start_3205=0
    local __length_127=("${parts_3202[@]}")
    local __range_end_3205="${#__length_127[@]}"
    local __dir_3205=$(( ${__range_start_3205} <= ${__range_end_3205} ? 1 : -1 ))
    for (( idx_3205=${__range_start_3205}; idx_3205 * ${__dir_3205} < ${__range_end_3205} * ${__dir_3205}; idx_3205+=${__dir_3205} )); do
        local part_3206="${parts_3202[${idx_3205}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3205 == 0 )) && $([ "_${starts_with_ansi_3200}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3206}" == "_" ]; echo $?) && $(( remaining_width_3204 > 0 )) ))" != 0 ]; then
                truncate_text__770_v0 "${part_3206}" "${remaining_width_3204}"
                local ret_truncate_text770_v0__95_35="${ret_truncate_text770_v0}"
                local truncated_3207="${ret_truncate_text770_v0__95_35}"
                result_3203+="${truncated_3207}"
                get_visible_len__769_v0 "${truncated_3207}"
                local ret_get_visible_len769_v0__97_36="${ret_get_visible_len769_v0}"
                remaining_width_3204="$(( remaining_width_3204 - ret_get_visible_len769_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_128
            command_128="$(__p="${part_3206}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3208="${command_128}"
            if [ "$([ "_${m_idx_3208}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_129
                command_129="$(__p="${part_3206}"; printf "%s" "${__p:0:${m_idx_3208}}")"
                __status=$?
                local ansi_params_3209="${command_129}"
                result_3203+="\\x1b[""${ansi_params_3209}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3208}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_3210="${ret_parse_int13_v0__108_41}"
                local text_start_3211="$(( m_idx_num_3210 + 1 ))"
                local command_130
                command_130="$(__p="${part_3206}"; printf "%s" "${__p:${text_start_3211}}")"
                __status=$?
                local text_part_3212="${command_130}"
                if [ "$(( $([ "_${text_part_3212}" == "_" ]; echo $?) && $(( remaining_width_3204 > 0 )) ))" != 0 ]; then
                    truncate_text__770_v0 "${text_part_3212}" "${remaining_width_3204}"
                    local ret_truncate_text770_v0__112_39="${ret_truncate_text770_v0}"
                    local truncated_3213="${ret_truncate_text770_v0__112_39}"
                    result_3203+="${truncated_3213}"
                    get_visible_len__769_v0 "${truncated_3213}"
                    local ret_get_visible_len769_v0__114_40="${ret_get_visible_len769_v0}"
                    remaining_width_3204="$(( remaining_width_3204 - ret_get_visible_len769_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3206}" == "_" ]; echo $?) && $(( remaining_width_3204 > 0 )) ))" != 0 ]; then
                    truncate_text__770_v0 "${part_3206}" "${remaining_width_3204}"
                    local ret_truncate_text770_v0__119_39="${ret_truncate_text770_v0}"
                    local truncated_3214="${ret_truncate_text770_v0__119_39}"
                    result_3203+="${truncated_3214}"
                    get_visible_len__769_v0 "${truncated_3214}"
                    local ret_get_visible_len769_v0__121_40="${ret_get_visible_len769_v0}"
                    remaining_width_3204="$(( remaining_width_3204 - ret_get_visible_len769_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi771_v0="${result_3203}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__772_v0() {
    local text_3176="${1}"
    local max_width_3177="${2}"
    get_visible_len__769_v0 "${text_3176}"
    local visible_len_3191="${ret_get_visible_len769_v0}"
    if [ "$(( visible_len_3191 <= max_width_3177 ))" != 0 ]; then
        ret_cutoff_text772_v0="${text_3176}"
        return 0
    fi
    truncate_ansi__771_v0 "${text_3176}" "$(( max_width_3177 - 3 ))"
    local ret_truncate_ansi771_v0__137_12="${ret_truncate_ansi771_v0}"
    ret_cutoff_text772_v0="${ret_truncate_ansi771_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__793_v0() {
    local format_3229="${1}"
    local args_3230=("${!2}")
    args_3230=("${format_3229}" "${args_3230[@]}")
    __status=$?
    printf "${args_3230[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__794_v0() {
    local message_3227="${1}"
    local color_3228="${2}"
    # Prints an error message with a specified color.
    local array_131=("${message_3227}")
    eprintf__793_v0 "\\x1b[${color_3228}m%s\\x1b[0m" array_131[@]
}

# colored(message: Text, color: Int)
colored__795_v0() {
    local message_3161="${1}"
    local color_3162="${2}"
    # Returns a text wrapped in color codes.
    ret_colored795_v0="\\x1b[${color_3162}m""${message_3161}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__799_v0() {
    local items_3221=("${!1}")
    local total_len_3222="${2}"
    local term_width_3223="${3}"
    local separator_3224=" • "
    local separator_len_3225=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3222 <= term_width_3223 ))" != 0 ]; then
        local iter_3226=0
        while :
        do
            local __length_132=("${items_3221[@]}")
            if [ "$(( iter_3226 >= ${#__length_132[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3226 > 0 ))" != 0 ]; then
                eprintf_colored__794_v0 "${separator_3224}" 90
            fi
            colored__795_v0 "${items_3221[$(( iter_3226 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored795_v0__23_41="${ret_colored795_v0}"
            local array_133=("")
            eprintf__793_v0 "${items_3221[${iter_3226}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored795_v0__23_41}" array_133[@]
            iter_3226="$(( iter_3226 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3231=0
        local first_3232=1
        local iter_3233=0
        while :
        do
            local __length_134=("${items_3221[@]}")
            if [ "$(( iter_3233 >= ${#__length_134[@]} ))" != 0 ]; then
                break
            fi
            local key_3234="${items_3221[${iter_3233}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3235="${items_3221[$(( iter_3233 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_135="${key_3234}"
            local __length_136="${action_3235}"
            local part_len_3236="$(( $(( ${#__length_135} + 1 )) + ${#__length_136} ))"
            local needed_3237="${part_len_3236}"
            if [ "$(( ! first_3232 ))" != 0 ]; then
                needed_3237="$(( needed_3237 + separator_len_3225 ))"
            fi
            if [ "$(( $(( current_len_3231 + needed_3237 )) > term_width_3223 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3232 ))" != 0 ]; then
                eprintf_colored__794_v0 "${separator_3224}" 90
            fi
            colored__795_v0 "${action_3235}" 2
            local ret_colored795_v0__51_33="${ret_colored795_v0}"
            local array_137=("")
            eprintf__793_v0 "${key_3234}"" ""${ret_colored795_v0__51_33}" array_137[@]
            current_len_3231="$(( current_len_3231 + needed_3237 ))"
            first_3232=0
            iter_3233="$(( iter_3233 + 2 ))"
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
store_term_size__836_v0() {
    local size_3140="${1}"
    if [ "$([ "_${size_3140}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size836_v0=0
        return 0
    fi
    split__4_v0 "${size_3140}" " "
    local parts_3141=("${ret_split4_v0[@]}")
    local __length_139=("${parts_3141[@]}")
    if [ "$(( ${#__length_139[@]} != 2 ))" != 0 ]; then
        ret_store_term_size836_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3141[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3141[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_38=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size836_v0=1
    return 0
}

# query_term_size()
query_term_size__837_v0() {
    local command_141
    command_141="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_3143="${command_141}"
    store_term_size__836_v0 "${size_3143}"
    ret_query_term_size837_v0="${ret_store_term_size836_v0}"
    return 0
}

# stty_term_size()
stty_term_size__838_v0() {
    local command_142
    command_142="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3139="${command_142}"
    store_term_size__836_v0 "${size_3139}"
    ret_stty_term_size838_v0="${ret_store_term_size836_v0}"
    return 0
}

# get_term_size()
get_term_size__839_v0() {
    stty_term_size__838_v0 
    local detected_3142="${ret_stty_term_size838_v0}"
    if [ "$(( ! detected_3142 ))" != 0 ]; then
        query_term_size__837_v0 
        detected_3142="${ret_query_term_size837_v0}"
    fi
    _got_term_size_37=1
}

# term_width()
term_width__841_v0() {
    if [ "$(( ! _got_term_size_37 ))" != 0 ]; then
        get_term_size__839_v0 
    fi
    ret_term_width841_v0="${_term_size_38[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__874_v0() {
    local pending_3158="${1}"
    local line_3159="${2}"
    local note_at_3160="${3}"
    if [ "$(( note_at_3160 < 0 ))" != 0 ]; then
        local array_144=()
        printf__128_v0 "${pending_3158}""${line_3159}""
" array_144[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3160 == 0 ))" != 0 ]; then
        colored__795_v0 "${line_3159}" 90
        local ret_colored795_v0__12_40="${ret_colored795_v0}"
        local array_145=()
        printf__128_v0 "${pending_3158}""${ret_colored795_v0__12_40}""
" array_145[@]
    else
        slice__24_v0 "${line_3159}" 0 "${note_at_3160}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3159}" "${note_at_3160}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__795_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored795_v0__13_58="${ret_colored795_v0}"
        local array_146=()
        printf__128_v0 "${pending_3158}""${ret_slice24_v0__13_32}""${ret_colored795_v0__13_58}""
" array_146[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__875_v0() {
    local names_3131=("${!1}")
    local texts_3132=("${!2}")
    local notes_3133=("${!3}")
    local min_name_width_3134="${4}"
    local __length_147=("${names_3131[@]}")
    local count_3135="${#__length_147[@]}"
    local name_width_3136="${min_name_width_3134}"
    local __range_start_3137=0
    local __range_end_3137="${count_3135}"
    local __dir_3137=$(( ${__range_start_3137} <= ${__range_end_3137} ? 1 : -1 ))
    for (( i_3137=${__range_start_3137}; i_3137 * ${__dir_3137} < ${__range_end_3137} * ${__dir_3137}; i_3137+=${__dir_3137} )); do
        local __length_148="${names_3131[${i_3137}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_3138="${#__length_148}"
        if [ "$(( width_3138 > name_width_3136 ))" != 0 ]; then
            name_width_3136="${width_3138}"
        fi
done
    term_width__841_v0 
    local width_3144="${ret_term_width841_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_3145="$(( name_width_3136 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_3146="$(( $(( width_3144 - indent_3145 )) < 24 ))"
    if [ "${stacked_3146}" != 0 ]; then
        indent_3145=6
    fi
    local avail_3147="$(( width_3144 - indent_3145 ))"
    rpad__28_v0 "" " " "${indent_3145}"
    local blank_3148="${ret_rpad28_v0}"
    local __range_start_3149=0
    local __range_end_3149="${count_3135}"
    local __dir_3149=$(( ${__range_start_3149} <= ${__range_end_3149} ? 1 : -1 ))
    for (( i_3149=${__range_start_3149}; i_3149 * ${__dir_3149} < ${__range_end_3149} * ${__dir_3149}; i_3149+=${__dir_3149} )); do
        local pending_3150="${blank_3148}"
        if [ "${stacked_3146}" != 0 ]; then
            local array_149=()
            printf__128_v0 "  ""${names_3131[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_149[@]
        else
            rpad__28_v0 "  ""${names_3131[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_3145}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_3150="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_3132[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_3151=("${ret_split4_v0__52_21[@]}")
        local __length_150=("${words_3151[@]}")
        local note_start_3152="${#__length_150[@]}"
        if [ "$([ "_${notes_3133[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_151="${notes_3133[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_151} > avail_3147 ))" != 0 ]; then
                split__4_v0 "${notes_3133[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_3151+=("${ret_split4_v0__58_26[@]}")
            else
                local array_152=("${notes_3133[${i_3149}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_3151+=("${array_152[@]}")
            fi
        fi
        local line_3153=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_3154=-1
        local __range_start_3155=0
        local __length_153=("${words_3151[@]}")
        local __range_end_3155="${#__length_153[@]}"
        local __dir_3155=$(( ${__range_start_3155} <= ${__range_end_3155} ? 1 : -1 ))
        for (( j_3155=${__range_start_3155}; j_3155 * ${__dir_3155} < ${__range_end_3155} * ${__dir_3155}; j_3155+=${__dir_3155} )); do
            local word_3156="${words_3151[${j_3155}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_3157
            candidate_3157="$(if [ "$([ "_${line_3153}" != "_" ]; echo $?)" != 0 ]; then echo "${word_3156}"; else echo "${line_3153}"" ""${word_3156}"; fi)"
            local __length_154="${candidate_3157}"
            if [ "$(( $(( ${#__length_154} > avail_3147 )) && $([ "_${line_3153}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__874_v0 "${pending_3150}" "${line_3153}" "${note_at_3154}"
                pending_3150="${blank_3148}"
                line_3153="${word_3156}"
                note_at_3154="$(if [ "$(( j_3155 >= note_start_3152 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_3155 >= note_start_3152 )) && $(( note_at_3154 < 0 )) ))" != 0 ]; then
                    local __length_155="${candidate_3157}"
                    local __length_156="${word_3156}"
                    note_at_3154="$(( ${#__length_155} - ${#__length_156} ))"
                fi
                line_3153="${candidate_3157}"
            fi
done
        print_help_line__874_v0 "${pending_3150}" "${line_3153}" "${note_at_3154}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__933_v0() {
    local prompt_3169="${1}"
    local placeholder_3170="${2}"
    local header_3171="${3}"
    local password_3172="${4}"
    stty_lock__679_v0 
    term_width__686_v0 
    local term_width_3175="${ret_term_width686_v0}"
    if [ "$([ "_${header_3171}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__772_v0 "${header_3171}" "${term_width_3175}"
        local ret_cutoff_text772_v0__24_17="${ret_cutoff_text772_v0}"
        local array_157=("")
        eprintf__638_v0 "${ret_cutoff_text772_v0__24_17}""
" array_157[@]
    fi
    new_line__692_v0 2
    # "enter submit" = 12
    local array_158=("enter" "submit")
    render_tooltip__799_v0 array_158[@] 12 "${term_width_3175}"
    go_up__693_v0 2
    local array_159=("")
    eprintf__638_v0 "\\x1b[G" array_159[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_160
    command_160="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3239="${command_160}"
    local char_3240=""
    local array_161=("")
    eprintf__638_v0 "${prompt_3169}" array_161[@]
    if [ "$([ "_${can_preset_3239}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__639_v0 "${placeholder_3170}" 90
        get_char__635_v0 
        char_3240="${ret_get_char635_v0}"
        local __length_162="${placeholder_3170}"
        remove__688_v0 "$(( ${#__length_162} + 1 ))"
    fi
    local __length_163="${prompt_3169}"
    remove__688_v0 "${#__length_163}"
    local text_3245=""
    if [ "$(( ! password_3172 ))" != 0 ]; then
        stty_unlock__680_v0 
        local command_164
        command_164="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3240}" -p "${prompt_3169}" text < /dev/tty; else read -e -p "${prompt_3169}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3245="${command_164}"
        stty_lock__679_v0 
    else
        local command_165
        command_165="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3240}" -p "${prompt_3169}" text < /dev/tty; else read -es -p "${prompt_3169}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3245="${command_165}"
    fi
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__769_v0 "${prompt_3169}""${text_3245}"
    local input_display_len_3247="${ret_get_visible_len769_v0}"
    local input_lines_3248="$(( $(( $(( input_display_len_3247 + term_width_3175 )) - 1 )) / term_width_3175 ))"
    if [ "$(( input_lines_3248 < 1 ))" != 0 ]; then
        input_lines_3248=1
    fi
    if [ "$(( input_lines_3248 < 3 ))" != 0 ]; then
        go_down__694_v0 "$(( 2 - input_lines_3248 ))"
        remove_line__689_v0 2
        remove_current_line__690_v0 
    fi
    if [ "$(( input_lines_3248 >= 3 ))" != 0 ]; then
        remove_line__689_v0 "${input_lines_3248}"
    fi
    if [ "$([ "_${header_3171}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__689_v0 1
        remove_current_line__690_v0 
    fi
    stty_unlock__680_v0 
    ret_xyl_input933_v0="${text_3245}"
    return 0
}

# print_input_help()
print_input_help__1033_v0() {
    local usage_3086=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__698_v0 usage_3086[@]
    printf '%s\n' ""
    colored_primary__740_v0 "input"
    local ret_colored_primary740_v0__8_20="${ret_colored_primary740_v0}"
    local title_3126=("${ret_colored_primary740_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__698_v0 title_3126[@]
    printf '%s\n' ""
    colored_secondary__741_v0 "Flags:"
    local ret_colored_secondary741_v0__11_12="${ret_colored_secondary741_v0}"
    local array_168=()
    printf__128_v0 "${ret_colored_secondary741_v0__11_12}""
" array_168[@]
    local names_3128=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_3129=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_3130=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__875_v0 names_3128[@] texts_3129[@] notes_3130[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1091_v0() {
    local parameters_3080=("${!1}")
    local prompt_3081="> "
    local placeholder_3082="Type here..."
    local header_3083=""
    local password_3084=0
    for param_3085 in "${parameters_3080[@]}"; do
        if [ "$(( $([ "_${param_3085}" != "_-h" ]; echo $?) || $([ "_${param_3085}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1033_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_3085}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_174="--prompt="
            slice__24_v0 "${param_3085}" "${#__length_174}" 0
            prompt_3081="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3085}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_175="--placeholder="
            slice__24_v0 "${param_3085}" "${#__length_175}" 0
            placeholder_3082="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3085}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_176="--header="
            slice__24_v0 "${param_3085}" "${#__length_176}" 0
            header_3083="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_3085}" != "_--password" ]; echo $?)" != 0 ]; then
            password_3084=1
        fi
    done
    has_ansi_escape__764_v0 "${header_3083}"
    local ret_has_ansi_escape764_v0__31_44="${ret_has_ansi_escape764_v0}"
    escape_ansi__765_v0 "${header_3083}"
    local ret_escape_ansi765_v0__31_73="${ret_escape_ansi765_v0}"
    colored_primary__740_v0 "${header_3083}"
    local ret_colored_primary740_v0__31_111="${ret_colored_primary740_v0}"
    local display_header_3168
    display_header_3168="$(if [ "$(( $([ "_${header_3083}" != "_" ]; echo $?) || ret_has_ansi_escape764_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi765_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary740_v0__31_111}"; fi)"
    xyl_input__933_v0 "${prompt_3081}" "${placeholder_3082}" "${display_header_3168}" "${password_3084}"
    ret_execute_input1091_v0="${ret_xyl_input933_v0}"
    return 0
}

# get_key()
get_key__1172_v0() {
    local command_177
    command_177="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1172_v0="${command_177}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1174_v0() {
    local format_17945="${1}"
    local args_17946=("${!2}")
    args_17946=("${format_17945}" "${args_17946[@]}")
    __status=$?
    printf "${args_17946[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1175_v0() {
    local message_17943="${1}"
    local color_17944="${2}"
    # Prints an error message with a specified color.
    local array_178=("${message_17943}")
    eprintf__1174_v0 "\\x1b[${color_17944}m%s\\x1b[0m" array_178[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1190_v0() {
    local format_17966="${1}"
    local args_17967=("${!2}")
    args_17967=("${format_17966}" "${args_17967[@]}")
    __status=$?
    printf "${args_17967[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_46="None"
# perl_available()
perl_available__1197_v0() {
    if [ "$([ "_${_perl_state_46}" != "_None" ]; echo $?)" != 0 ]; then
        local command_179
        command_179="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_17898
        disabled_17898="$([ "_${command_179}" != "_No" ]; echo $?)"
        local command_180
        command_180="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_17899
        found_17899="$(( $(( ! disabled_17898 )) && $([ "_${command_180}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_17899}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1197_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1198_v0() {
    local text_17897="${1}"
    perl_available__1197_v0 
    local ret_perl_available1197_v0__19_12="${ret_perl_available1197_v0}"
    if [ "$(( ! ret_perl_available1197_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1198_v0=''
        return 1
    fi
    local command_181
    command_181="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_17897}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1198_v0=''
        return "${__status}"
    fi
    local width_str_17900="${command_181}"
    parse_int__13_v0 "${width_str_17900}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1198_v0=''
        return "${__status}"
    fi
    local width_17901="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1198_v0="${width_17901}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1203_v0() {
    local text_17887="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_182
    command_182="$([[ "${text_17887}" == *$'\x1b'* || "${text_17887}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17888="${command_182}"
    ret_has_ansi_escape1203_v0="$([ "_${has_escape_17888}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1205_v0() {
    local text_17893="${1}"
    local command_183
    command_183="$(printf "%s" "${text_17893}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1205_v0="${command_183}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1206_v0() {
    local text_17895="${1}"
    local command_184
    command_184="$(printf "%s" "${text_17895}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_17896="${command_184}"
    ret_is_all_ascii1206_v0="$([ "_${result_17896}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1207_v0() {
    local text_17890="${1}"
    local command_185
    command_185="$(LC_ALL=C; __t="${text_17890}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_17891="${command_185}"
    parse_int__13_v0 "${measured_17891}"
    __status=$?
    ret_plain_len1207_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1208_v0() {
    local text_17889="${1}"
    plain_len__1207_v0 "${text_17889}"
    local plain_17892="${ret_plain_len1207_v0}"
    if [ "$(( plain_17892 >= 0 ))" != 0 ]; then
        ret_get_visible_len1208_v0="${plain_17892}"
        return 0
    fi
    strip_ansi__1205_v0 "${text_17889}"
    local stripped_17894="${ret_strip_ansi1205_v0}"
    is_all_ascii__1206_v0 "${stripped_17894}"
    local ret_is_all_ascii1206_v0__46_12="${ret_is_all_ascii1206_v0}"
    if [ "$(( ! ret_is_all_ascii1206_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1198_v0 "${stripped_17894}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_186="${stripped_17894}"
            ret_get_visible_len1208_v0="${#__length_186}"
            return 0
        fi
        ret_get_visible_len1208_v0="${ret_perl_get_cjk_width1198_v0}"
        return 0
    fi
    local __length_187="${stripped_17894}"
    ret_get_visible_len1208_v0="${#__length_187}"
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
stty_count__1214_v0() {
    local command_189
    command_189="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_17964="${command_189}"
    parse_int__13_v0 "${count_17964}"
    __status=$?
    ret_stty_count1214_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1215_v0() {
    stty_count__1214_v0 
    local count_num_17965="${ret_stty_count1214_v0}"
    if [ "$(( count_num_17965 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_17965="$(( count_num_17965 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_17965}
    __status=$?
}

# stty_unlock()
stty_unlock__1216_v0() {
    stty_count__1214_v0 
    local count_num_18085="${ret_stty_count1214_v0}"
    if [ "$(( count_num_18085 > 0 ))" != 0 ]; then
        count_num_18085="$(( count_num_18085 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18085}
        __status=$?
        if [ "$(( count_num_18085 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1217_v0() {
    local size_17878="${1}"
    if [ "$([ "_${size_17878}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1217_v0=0
        return 0
    fi
    split__4_v0 "${size_17878}" " "
    local parts_17879=("${ret_split4_v0[@]}")
    local __length_190=("${parts_17879[@]}")
    if [ "$(( ${#__length_190[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17879[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17879[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_48=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1217_v0=1
    return 0
}

# query_term_size()
query_term_size__1218_v0() {
    local command_192
    command_192="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_17881="${command_192}"
    store_term_size__1217_v0 "${size_17881}"
    ret_query_term_size1218_v0="${ret_store_term_size1217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1219_v0() {
    local command_193
    command_193="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17877="${command_193}"
    store_term_size__1217_v0 "${size_17877}"
    ret_stty_term_size1219_v0="${ret_store_term_size1217_v0}"
    return 0
}

# get_term_size()
get_term_size__1220_v0() {
    stty_term_size__1219_v0 
    local detected_17880="${ret_stty_term_size1219_v0}"
    if [ "$(( ! detected_17880 ))" != 0 ]; then
        query_term_size__1218_v0 
        detected_17880="${ret_query_term_size1218_v0}"
    fi
    _got_term_size_47=1
}

# term_width()
term_width__1222_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1220_v0 
    fi
    ret_term_width1222_v0="${_term_size_48[0]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1223_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1220_v0 
    fi
    ret_term_height1223_v0="${_term_size_48[1]?"Index out of bounds (at src/./choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1225_v0() {
    local cnt_18057="${1}"
    if [ "$(( cnt_18057 > 0 ))" != 0 ]; then
        local sequence_18058=""
        local __range_start_18059=0
        local __range_end_18059="${cnt_18057}"
        local __dir_18059=$(( ${__range_start_18059} <= ${__range_end_18059} ? 1 : -1 ))
        for (( ____18059=${__range_start_18059}; ____18059 * ${__dir_18059} < ${__range_end_18059} * ${__dir_18059}; ____18059+=${__dir_18059} )); do
            sequence_18058+="\\x1b[2K\\x1b[1A"
done
        local array_194=("")
        eprintf__1190_v0 "${sequence_18058}" array_194[@]
    fi
    local array_195=("")
    eprintf__1190_v0 "\\x1b[G" array_195[@]
}

# remove_current_line()
remove_current_line__1226_v0() {
    local array_196=("")
    eprintf__1190_v0 "\\x1b[2K\\x1b[G" array_196[@]
}

# print_blank(cnt: Int)
print_blank__1227_v0() {
    local cnt_18048="${1}"
    printf '%*s' "${cnt_18048}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1228_v0() {
    local cnt_18012="${1}"
    local __range_start_18013=0
    local __range_end_18013="${cnt_18012}"
    local __dir_18013=$(( ${__range_start_18013} <= ${__range_end_18013} ? 1 : -1 ))
    for (( ____18013=${__range_start_18013}; ____18013 * ${__dir_18013} < ${__range_end_18013} * ${__dir_18013}; ____18013+=${__dir_18013} )); do
        local array_197=("")
        eprintf__1190_v0 "
" array_197[@]
done
}

# go_up(cnt: Int)
go_up__1229_v0() {
    local cnt_18031="${1}"
    local array_198=("")
    eprintf__1190_v0 "\\x1b[${cnt_18031}A" array_198[@]
}

# go_down(cnt: Int)
go_down__1230_v0() {
    local cnt_18084="${1}"
    local array_199=("")
    eprintf__1190_v0 "\\x1b[${cnt_18084}B" array_199[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1232_v0() {
    local array_200=("")
    eprintf__1190_v0 "\\x1b[?25l" array_200[@]
}

# show_cursor()
show_cursor__1233_v0() {
    local array_201=("")
    eprintf__1190_v0 "\\x1b[?25h" array_201[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1234_v0() {
    local pieces_17876=("${!1}")
    term_width__1222_v0 
    local width_17882="${ret_term_width1222_v0}"
    local line_17883=""
    local line_len_17884=0
    for piece_17885 in "${pieces_17876[@]}"; do
        local __length_204="${piece_17885}"
        local piece_len_17886="${#__length_204}"
        has_ansi_escape__1203_v0 "${piece_17885}"
        local ret_has_ansi_escape1203_v0__186_12="${ret_has_ansi_escape1203_v0}"
        if [ "${ret_has_ansi_escape1203_v0__186_12}" != 0 ]; then
            get_visible_len__1208_v0 "${piece_17885}"
            piece_len_17886="${ret_get_visible_len1208_v0}"
        fi
        if [ "$([ "_${line_17883}" != "_" ]; echo $?)" != 0 ]; then
            line_17883="${piece_17885}"
            line_len_17884="${piece_len_17886}"
        elif [ "$(( $(( $(( line_len_17884 + 1 )) + piece_len_17886 )) > width_17882 ))" != 0 ]; then
            local array_205=()
            printf__128_v0 "${line_17883}""
" array_205[@]
            line_17883="${piece_17885}"
            line_len_17884="${piece_len_17886}"
        else
            line_17883+=" ""${piece_17885}"
            line_len_17884="$(( line_len_17884 + $(( 1 + piece_len_17886 )) ))"
        fi
    done
    if [ "$([ "_${line_17883}" == "_" ]; echo $?)" != 0 ]; then
        local array_206=()
        printf__128_v0 "${line_17883}""
" array_206[@]
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
get_supports_truecolor__1271_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_17866="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_17866}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1271_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1272_v0() {
    local message_17861="${1}"
    local r_17862="${2}"
    local g_17863="${3}"
    local b_17864="${4}"
    local fallback_17865="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1272_v0="\\x1b[38;2;${r_17862};${g_17863};${b_17864}m""${message_17861}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1271_v0 
        local ret_get_supports_truecolor1271_v0__45_17="${ret_get_supports_truecolor1271_v0}"
        if [ "${ret_get_supports_truecolor1271_v0__45_17}" != 0 ]; then
            ret_colored_rgb1272_v0="\\x1b[38;2;${r_17862};${g_17863};${b_17864}m""${message_17861}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_17865 == 0 ))" != 0 ]; then
            ret_colored_rgb1272_v0="${message_17861}"
            return 0
        else
            ret_colored_rgb1272_v0="\\x1b[${fallback_17865}m""${message_17861}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_17865 == 0 ))" != 0 ]; then
            ret_colored_rgb1272_v0="${message_17861}"
            return 0
        fi
        ret_colored_rgb1272_v0="\\x1b[${fallback_17865}m""${message_17861}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1274_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_17855="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_17855}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_17855}" ";"
            local parts_17856=("${ret_split4_v0[@]}")
            local __length_210=("${parts_17856[@]}")
            if [ "$(( ${#__length_210[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17856[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17856[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17856[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17856[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_53=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_17857="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_17857}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_17857}" ";"
            local parts_17858=("${ret_split4_v0[@]}")
            local __length_212=("${parts_17858[@]}")
            if [ "$(( ${#__length_212[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17858[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17858[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17858[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17858[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_54=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_17859="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_17859}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_17859}" ";"
            local parts_17860=("${ret_split4_v0[@]}")
            local __length_214=("${parts_17860[@]}")
            if [ "$(( ${#__length_214[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17860[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17860[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17860[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17860[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1274_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_52=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1275_v0() {
    inner_get_xylitol_colors__1274_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_52=1
}

# colored_primary(message: Text)
colored_primary__1276_v0() {
    local message_17854="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1275_v0 
    fi
    colored_rgb__1272_v0 "${message_17854}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1276_v0="${ret_colored_rgb1272_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1277_v0() {
    local message_17903="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1275_v0 
    fi
    colored_rgb__1272_v0 "${message_17903}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1277_v0="${ret_colored_rgb1272_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_56="None"
# perl_available()
perl_available__1294_v0() {
    if [ "$([ "_${_perl_state_56}" != "_None" ]; echo $?)" != 0 ]; then
        local command_216
        command_216="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_17981
        disabled_17981="$([ "_${command_216}" != "_No" ]; echo $?)"
        local command_217
        command_217="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_17982
        found_17982="$(( $(( ! disabled_17981 )) && $([ "_${command_217}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_17982}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1294_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1295_v0() {
    local text_17980="${1}"
    perl_available__1294_v0 
    local ret_perl_available1294_v0__19_12="${ret_perl_available1294_v0}"
    if [ "$(( ! ret_perl_available1294_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1295_v0=''
        return 1
    fi
    local command_218
    command_218="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_17980}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1295_v0=''
        return "${__status}"
    fi
    local width_str_17983="${command_218}"
    parse_int__13_v0 "${width_str_17983}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1295_v0=''
        return "${__status}"
    fi
    local width_17984="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1295_v0="${width_17984}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1296_v0() {
    local text_17991="${1}"
    local max_width_17992="${2}"
    perl_available__1294_v0 
    local ret_perl_available1294_v0__30_12="${ret_perl_available1294_v0}"
    if [ "$(( ! ret_perl_available1294_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1296_v0=''
        return 1
    fi
    local command_219
    command_219="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_17991}" ${max_width_17992} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1296_v0=''
        return "${__status}"
    fi
    local result_17993="${command_219}"
    ret_perl_truncate_cjk1296_v0="${result_17993}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1300_v0() {
    local text_17948="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_220
    command_220="$([[ "${text_17948}" == *$'\x1b'* || "${text_17948}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17949="${command_220}"
    ret_has_ansi_escape1300_v0="$([ "_${has_escape_17949}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1301_v0() {
    local text_17950="${1}"
    local command_221
    command_221="$(printf '%s' "${text_17950}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1301_v0="${command_221}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1302_v0() {
    local text_17976="${1}"
    local command_222
    command_222="$(printf "%s" "${text_17976}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1302_v0="${command_222}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1303_v0() {
    local text_17978="${1}"
    local command_223
    command_223="$(printf "%s" "${text_17978}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_17979="${command_223}"
    ret_is_all_ascii1303_v0="$([ "_${result_17979}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1304_v0() {
    local text_17973="${1}"
    local command_224
    command_224="$(LC_ALL=C; __t="${text_17973}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_17974="${command_224}"
    parse_int__13_v0 "${measured_17974}"
    __status=$?
    ret_plain_len1304_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1305_v0() {
    local text_17972="${1}"
    plain_len__1304_v0 "${text_17972}"
    local plain_17975="${ret_plain_len1304_v0}"
    if [ "$(( plain_17975 >= 0 ))" != 0 ]; then
        ret_get_visible_len1305_v0="${plain_17975}"
        return 0
    fi
    strip_ansi__1302_v0 "${text_17972}"
    local stripped_17977="${ret_strip_ansi1302_v0}"
    is_all_ascii__1303_v0 "${stripped_17977}"
    local ret_is_all_ascii1303_v0__46_12="${ret_is_all_ascii1303_v0}"
    if [ "$(( ! ret_is_all_ascii1303_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1295_v0 "${stripped_17977}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_225="${stripped_17977}"
            ret_get_visible_len1305_v0="${#__length_225}"
            return 0
        fi
        ret_get_visible_len1305_v0="${ret_perl_get_cjk_width1295_v0}"
        return 0
    fi
    local __length_226="${stripped_17977}"
    ret_get_visible_len1305_v0="${#__length_226}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1306_v0() {
    local text_17988="${1}"
    local max_width_17989="${2}"
    get_visible_len__1305_v0 "${text_17988}"
    local visible_len_17990="${ret_get_visible_len1305_v0}"
    if [ "$(( visible_len_17990 <= max_width_17989 ))" != 0 ]; then
        ret_truncate_text1306_v0="${text_17988}"
        return 0
    fi
    is_all_ascii__1303_v0 "${text_17988}"
    local ret_is_all_ascii1303_v0__61_12="${ret_is_all_ascii1303_v0}"
    if [ "$(( ! ret_is_all_ascii1303_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1296_v0 "${text_17988}" "${max_width_17989}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_17988}" | cut -c1-${max_width_17989}
            __status=$?
        fi
        ret_truncate_text1306_v0="${ret_perl_truncate_cjk1296_v0}"
        return 0
    fi
    local command_227
    command_227="$(printf "%s" "${text_17988}" | cut -c1-${max_width_17989})"
    __status=$?
    ret_truncate_text1306_v0="${command_227}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1307_v0() {
    local text_17986="${1}"
    local max_width_17987="${2}"
    has_ansi_escape__1300_v0 "${text_17986}"
    local ret_has_ansi_escape1300_v0__73_12="${ret_has_ansi_escape1300_v0}"
    if [ "$(( ! ret_has_ansi_escape1300_v0__73_12 ))" != 0 ]; then
        truncate_text__1306_v0 "${text_17986}" "${max_width_17987}"
        ret_truncate_ansi1307_v0="${ret_truncate_text1306_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_228
    command_228="$([[ "${text_17986}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_17994="${command_228}"
    # Replace \x1b[ with newline, then split
    local command_229
    command_229="$(t="${text_17986}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_17995="${command_229}"
    split__4_v0 "${replaced_17995}" "
"
    local parts_17996=("${ret_split4_v0[@]}")
    local result_17997=""
    local remaining_width_17998="${max_width_17987}"
    local __range_start_17999=0
    local __length_230=("${parts_17996[@]}")
    local __range_end_17999="${#__length_230[@]}"
    local __dir_17999=$(( ${__range_start_17999} <= ${__range_end_17999} ? 1 : -1 ))
    for (( idx_17999=${__range_start_17999}; idx_17999 * ${__dir_17999} < ${__range_end_17999} * ${__dir_17999}; idx_17999+=${__dir_17999} )); do
        local part_18000="${parts_17996[${idx_17999}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_17999 == 0 )) && $([ "_${starts_with_ansi_17994}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18000}" == "_" ]; echo $?) && $(( remaining_width_17998 > 0 )) ))" != 0 ]; then
                truncate_text__1306_v0 "${part_18000}" "${remaining_width_17998}"
                local ret_truncate_text1306_v0__95_35="${ret_truncate_text1306_v0}"
                local truncated_18001="${ret_truncate_text1306_v0__95_35}"
                result_17997+="${truncated_18001}"
                get_visible_len__1305_v0 "${truncated_18001}"
                local ret_get_visible_len1305_v0__97_36="${ret_get_visible_len1305_v0}"
                remaining_width_17998="$(( remaining_width_17998 - ret_get_visible_len1305_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_231
            command_231="$(__p="${part_18000}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18002="${command_231}"
            if [ "$([ "_${m_idx_18002}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_232
                command_232="$(__p="${part_18000}"; printf "%s" "${__p:0:${m_idx_18002}}")"
                __status=$?
                local ansi_params_18003="${command_232}"
                result_17997+="\\x1b[""${ansi_params_18003}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18002}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_18004="${ret_parse_int13_v0__108_41}"
                local text_start_18005="$(( m_idx_num_18004 + 1 ))"
                local command_233
                command_233="$(__p="${part_18000}"; printf "%s" "${__p:${text_start_18005}}")"
                __status=$?
                local text_part_18006="${command_233}"
                if [ "$(( $([ "_${text_part_18006}" == "_" ]; echo $?) && $(( remaining_width_17998 > 0 )) ))" != 0 ]; then
                    truncate_text__1306_v0 "${text_part_18006}" "${remaining_width_17998}"
                    local ret_truncate_text1306_v0__112_39="${ret_truncate_text1306_v0}"
                    local truncated_18007="${ret_truncate_text1306_v0__112_39}"
                    result_17997+="${truncated_18007}"
                    get_visible_len__1305_v0 "${truncated_18007}"
                    local ret_get_visible_len1305_v0__114_40="${ret_get_visible_len1305_v0}"
                    remaining_width_17998="$(( remaining_width_17998 - ret_get_visible_len1305_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18000}" == "_" ]; echo $?) && $(( remaining_width_17998 > 0 )) ))" != 0 ]; then
                    truncate_text__1306_v0 "${part_18000}" "${remaining_width_17998}"
                    local ret_truncate_text1306_v0__119_39="${ret_truncate_text1306_v0}"
                    local truncated_18008="${ret_truncate_text1306_v0__119_39}"
                    result_17997+="${truncated_18008}"
                    get_visible_len__1305_v0 "${truncated_18008}"
                    local ret_get_visible_len1305_v0__121_40="${ret_get_visible_len1305_v0}"
                    remaining_width_17998="$(( remaining_width_17998 - ret_get_visible_len1305_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1307_v0="${result_17997}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1308_v0() {
    local text_17970="${1}"
    local max_width_17971="${2}"
    get_visible_len__1305_v0 "${text_17970}"
    local visible_len_17985="${ret_get_visible_len1305_v0}"
    if [ "$(( visible_len_17985 <= max_width_17971 ))" != 0 ]; then
        ret_cutoff_text1308_v0="${text_17970}"
        return 0
    fi
    truncate_ansi__1307_v0 "${text_17970}" "$(( max_width_17971 - 3 ))"
    local ret_truncate_ansi1307_v0__137_12="${ret_truncate_ansi1307_v0}"
    ret_cutoff_text1308_v0="${ret_truncate_ansi1307_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1329_v0() {
    local format_18022="${1}"
    local args_18023=("${!2}")
    args_18023=("${format_18022}" "${args_18023[@]}")
    __status=$?
    printf "${args_18023[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1330_v0() {
    local message_18020="${1}"
    local color_18021="${2}"
    # Prints an error message with a specified color.
    local array_234=("${message_18020}")
    eprintf__1329_v0 "\\x1b[${color_18021}m%s\\x1b[0m" array_234[@]
}

# colored(message: Text, color: Int)
colored__1331_v0() {
    local message_17937="${1}"
    local color_17938="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1331_v0="\\x1b[${color_17938}m""${message_17937}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1335_v0() {
    local items_18014=("${!1}")
    local total_len_18015="${2}"
    local term_width_18016="${3}"
    local separator_18017=" • "
    local separator_len_18018=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18015 <= term_width_18016 ))" != 0 ]; then
        local iter_18019=0
        while :
        do
            local __length_235=("${items_18014[@]}")
            if [ "$(( iter_18019 >= ${#__length_235[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18019 > 0 ))" != 0 ]; then
                eprintf_colored__1330_v0 "${separator_18017}" 90
            fi
            colored__1331_v0 "${items_18014[$(( iter_18019 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1331_v0__23_41="${ret_colored1331_v0}"
            local array_236=("")
            eprintf__1329_v0 "${items_18014[${iter_18019}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1331_v0__23_41}" array_236[@]
            iter_18019="$(( iter_18019 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18024=0
        local first_18025=1
        local iter_18026=0
        while :
        do
            local __length_237=("${items_18014[@]}")
            if [ "$(( iter_18026 >= ${#__length_237[@]} ))" != 0 ]; then
                break
            fi
            local key_18027="${items_18014[${iter_18026}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_18028="${items_18014[$(( iter_18026 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_238="${key_18027}"
            local __length_239="${action_18028}"
            local part_len_18029="$(( $(( ${#__length_238} + 1 )) + ${#__length_239} ))"
            local needed_18030="${part_len_18029}"
            if [ "$(( ! first_18025 ))" != 0 ]; then
                needed_18030="$(( needed_18030 + separator_len_18018 ))"
            fi
            if [ "$(( $(( current_len_18024 + needed_18030 )) > term_width_18016 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18025 ))" != 0 ]; then
                eprintf_colored__1330_v0 "${separator_18017}" 90
            fi
            colored__1331_v0 "${action_18028}" 2
            local ret_colored1331_v0__51_33="${ret_colored1331_v0}"
            local array_240=("")
            eprintf__1329_v0 "${key_18027}"" ""${ret_colored1331_v0__51_33}" array_240[@]
            current_len_18024="$(( current_len_18024 + needed_18030 ))"
            first_18025=0
            iter_18026="$(( iter_18026 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1345_v0() {
    local format_18073="${1}"
    local args_18074=("${!2}")
    args_18074=("${format_18073}" "${args_18074[@]}")
    __status=$?
    printf "${args_18074[@]}" >&2
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
store_term_size__1372_v0() {
    local size_17916="${1}"
    if [ "$([ "_${size_17916}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1372_v0=0
        return 0
    fi
    split__4_v0 "${size_17916}" " "
    local parts_17917=("${ret_split4_v0[@]}")
    local __length_242=("${parts_17917[@]}")
    if [ "$(( ${#__length_242[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1372_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17917[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17917[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_60=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1372_v0=1
    return 0
}

# query_term_size()
query_term_size__1373_v0() {
    local command_244
    command_244="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_17919="${command_244}"
    store_term_size__1372_v0 "${size_17919}"
    ret_query_term_size1373_v0="${ret_store_term_size1372_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1374_v0() {
    local command_245
    command_245="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17915="${command_245}"
    store_term_size__1372_v0 "${size_17915}"
    ret_stty_term_size1374_v0="${ret_store_term_size1372_v0}"
    return 0
}

# get_term_size()
get_term_size__1375_v0() {
    stty_term_size__1374_v0 
    local detected_17918="${ret_stty_term_size1374_v0}"
    if [ "$(( ! detected_17918 ))" != 0 ]; then
        query_term_size__1373_v0 
        detected_17918="${ret_query_term_size1373_v0}"
    fi
    _got_term_size_59=1
}

# term_width()
term_width__1377_v0() {
    if [ "$(( ! _got_term_size_59 ))" != 0 ]; then
        get_term_size__1375_v0 
    fi
    ret_term_width1377_v0="${_term_size_60[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__1384_v0() {
    local cnt_18072="${1}"
    local array_246=("")
    eprintf__1345_v0 "\\x1b[${cnt_18072}A" array_246[@]
}

# go_down(cnt: Int)
go_down__1385_v0() {
    local cnt_18075="${1}"
    local array_247=("")
    eprintf__1345_v0 "\\x1b[${cnt_18075}B" array_247[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1392_v0() {
    local display_count_18069="${1}"
    local index_18070="${2}"
    local line_18071="${3}"
    go_up__1384_v0 "$(( display_count_18069 - index_18070 ))"
    local array_248=("")
    eprintf__1329_v0 "\\x1b[G\\x1b[K" array_248[@]
    local array_249=("")
    eprintf__1329_v0 "${line_18071}" array_249[@]
    go_down__1385_v0 "$(( display_count_18069 - index_18070 ))"
    local array_250=("")
    eprintf__1329_v0 "\\x1b[G" array_250[@]
}

# Which items of a multi-select widget are ticked.
_checked_61=()
_count_62=0
_total_63=0
_limit_64=-1
# checked_init(total: Int, limit: Int)
checked_init__1394_v0() {
    local total_18009="${1}"
    local limit_18010="${2}"
    _checked_61=()
    local __range_start_18011=0
    local __range_end_18011="${total_18009}"
    local __dir_18011=$(( ${__range_start_18011} <= ${__range_end_18011} ? 1 : -1 ))
    for (( ____18011=${__range_start_18011}; ____18011 * ${__dir_18011} < ${__range_end_18011} * ${__dir_18011}; ____18011+=${__dir_18011} )); do
        local array_253=(0)
        _checked_61+=("${array_253[@]}")
done
    _count_62=0
    _total_63="${total_18009}"
    _limit_64="${limit_18010}"
}

# checked_is(index: Int)
checked_is__1395_v0() {
    local index_18045="${1}"
    ret_checked_is1395_v0="${_checked_61[${index_18045}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1397_v0() {
    local index_18064="${1}"
    if [ "${_checked_61[${index_18064}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_61["${index_18064}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1397_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1397_v0=0
        return 0
    fi
    _checked_61["${index_18064}"]=1
    _count_62="$(( _count_62 + 1 ))"
    ret_checked_toggle1397_v0=1
    return 0
}

# checked_all()
checked_all__1398_v0() {
    if [ "$(( _limit_64 >= 0 ))" != 0 ]; then
        ret_checked_all1398_v0=0
        return 0
    fi
    local was_all_18076="$(( _count_62 == _total_63 ))"
    local __range_start_18077=0
    local __range_end_18077="${_total_63}"
    local __dir_18077=$(( ${__range_start_18077} <= ${__range_end_18077} ? 1 : -1 ))
    for (( i_18077=${__range_start_18077}; i_18077 * ${__dir_18077} < ${__range_end_18077} * ${__dir_18077}; i_18077+=${__dir_18077} )); do
        _checked_61["${i_18077}"]="$(( ! was_all_18076 ))"
done
    if [ "${was_all_18076}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1398_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1410_v0() {
    local pending_17934="${1}"
    local line_17935="${2}"
    local note_at_17936="${3}"
    if [ "$(( note_at_17936 < 0 ))" != 0 ]; then
        local array_254=()
        printf__128_v0 "${pending_17934}""${line_17935}""
" array_254[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_17936 == 0 ))" != 0 ]; then
        colored__1331_v0 "${line_17935}" 90
        local ret_colored1331_v0__12_40="${ret_colored1331_v0}"
        local array_255=()
        printf__128_v0 "${pending_17934}""${ret_colored1331_v0__12_40}""
" array_255[@]
    else
        slice__24_v0 "${line_17935}" 0 "${note_at_17936}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_17935}" "${note_at_17936}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1331_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1331_v0__13_58="${ret_colored1331_v0}"
        local array_256=()
        printf__128_v0 "${pending_17934}""${ret_slice24_v0__13_32}""${ret_colored1331_v0__13_58}""
" array_256[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1411_v0() {
    local names_17907=("${!1}")
    local texts_17908=("${!2}")
    local notes_17909=("${!3}")
    local min_name_width_17910="${4}"
    local __length_257=("${names_17907[@]}")
    local count_17911="${#__length_257[@]}"
    local name_width_17912="${min_name_width_17910}"
    local __range_start_17913=0
    local __range_end_17913="${count_17911}"
    local __dir_17913=$(( ${__range_start_17913} <= ${__range_end_17913} ? 1 : -1 ))
    for (( i_17913=${__range_start_17913}; i_17913 * ${__dir_17913} < ${__range_end_17913} * ${__dir_17913}; i_17913+=${__dir_17913} )); do
        local __length_258="${names_17907[${i_17913}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_17914="${#__length_258}"
        if [ "$(( width_17914 > name_width_17912 ))" != 0 ]; then
            name_width_17912="${width_17914}"
        fi
done
    term_width__1377_v0 
    local width_17920="${ret_term_width1377_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_17921="$(( name_width_17912 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_17922="$(( $(( width_17920 - indent_17921 )) < 24 ))"
    if [ "${stacked_17922}" != 0 ]; then
        indent_17921=6
    fi
    local avail_17923="$(( width_17920 - indent_17921 ))"
    rpad__28_v0 "" " " "${indent_17921}"
    local blank_17924="${ret_rpad28_v0}"
    local __range_start_17925=0
    local __range_end_17925="${count_17911}"
    local __dir_17925=$(( ${__range_start_17925} <= ${__range_end_17925} ? 1 : -1 ))
    for (( i_17925=${__range_start_17925}; i_17925 * ${__dir_17925} < ${__range_end_17925} * ${__dir_17925}; i_17925+=${__dir_17925} )); do
        local pending_17926="${blank_17924}"
        if [ "${stacked_17922}" != 0 ]; then
            local array_259=()
            printf__128_v0 "  ""${names_17907[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_259[@]
        else
            rpad__28_v0 "  ""${names_17907[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_17921}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_17926="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_17908[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_17927=("${ret_split4_v0__52_21[@]}")
        local __length_260=("${words_17927[@]}")
        local note_start_17928="${#__length_260[@]}"
        if [ "$([ "_${notes_17909[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_261="${notes_17909[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_261} > avail_17923 ))" != 0 ]; then
                split__4_v0 "${notes_17909[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_17927+=("${ret_split4_v0__58_26[@]}")
            else
                local array_262=("${notes_17909[${i_17925}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_17927+=("${array_262[@]}")
            fi
        fi
        local line_17929=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_17930=-1
        local __range_start_17931=0
        local __length_263=("${words_17927[@]}")
        local __range_end_17931="${#__length_263[@]}"
        local __dir_17931=$(( ${__range_start_17931} <= ${__range_end_17931} ? 1 : -1 ))
        for (( j_17931=${__range_start_17931}; j_17931 * ${__dir_17931} < ${__range_end_17931} * ${__dir_17931}; j_17931+=${__dir_17931} )); do
            local word_17932="${words_17927[${j_17931}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_17933
            candidate_17933="$(if [ "$([ "_${line_17929}" != "_" ]; echo $?)" != 0 ]; then echo "${word_17932}"; else echo "${line_17929}"" ""${word_17932}"; fi)"
            local __length_264="${candidate_17933}"
            if [ "$(( $(( ${#__length_264} > avail_17923 )) && $([ "_${line_17929}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1410_v0 "${pending_17926}" "${line_17929}" "${note_at_17930}"
                pending_17926="${blank_17924}"
                line_17929="${word_17932}"
                note_at_17930="$(if [ "$(( j_17931 >= note_start_17928 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_17931 >= note_start_17928 )) && $(( note_at_17930 < 0 )) ))" != 0 ]; then
                    local __length_265="${candidate_17933}"
                    local __length_266="${word_17932}"
                    note_at_17930="$(( ${#__length_265} - ${#__length_266} ))"
                fi
                line_17929="${candidate_17933}"
            fi
done
        print_help_line__1410_v0 "${pending_17926}" "${line_17929}" "${note_at_17930}"
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
render_single_page__1568_v0() {
    local __length_268="${_cursor_76}"
    local cursor_len_18051="${#__length_268}"
    local max_option_width_18052="$(( $(( _term_width_79 - cursor_len_18051 )) - 1 ))"
    local __range_start_18053=0
    local __range_end_18053="${_page_count_82}"
    local __dir_18053=$(( ${__range_start_18053} <= ${__range_end_18053} ? 1 : -1 ))
    for (( i_18053=${__range_start_18053}; i_18053 * ${__dir_18053} < ${__range_end_18053} * ${__dir_18053}; i_18053+=${__dir_18053} )); do
        cutoff_text__1308_v0 "${_page_81[${i_18053}]?"Index out of bounds (at src/./choose/./engine.ab:44:45)"}" "${max_option_width_18052}"
        local ret_cutoff_text1308_v0__44_27="${ret_cutoff_text1308_v0}"
        local truncated_18054="${ret_cutoff_text1308_v0__44_27}"
        if [ "$(( i_18053 == _selected_75 ))" != 0 ]; then
            colored_secondary__1277_v0 "${_cursor_76}""${truncated_18054}""
"
            local ret_colored_secondary1277_v0__46_21="${ret_colored_secondary1277_v0}"
            local array_269=("")
            eprintf__1174_v0 "${ret_colored_secondary1277_v0__46_21}" array_269[@]
        else
            print_blank__1227_v0 "${cursor_len_18051}"
            local array_270=("")
            eprintf__1174_v0 "${truncated_18054}""
" array_270[@]
        fi
done
    local remaining_slots_18055="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18055 > 0 ))" != 0 ]; then
        local __range_start_18056=0
        local __range_end_18056="${remaining_slots_18055}"
        local __dir_18056=$(( ${__range_start_18056} <= ${__range_end_18056} ? 1 : -1 ))
        for (( ____18056=${__range_start_18056}; ____18056 * ${__dir_18056} < ${__range_end_18056} * ${__dir_18056}; ____18056+=${__dir_18056} )); do
            local array_271=("")
            eprintf__1174_v0 "\\x1b[K
" array_271[@]
done
    fi
}

# render_multi_page()
render_multi_page__1569_v0() {
    local __length_272="${_cursor_76}"
    local cursor_len_18040="${#__length_272}"
    local max_option_width_18041="$(( $(( _term_width_79 - cursor_len_18040 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1574_v0 
    local page_start_18042="${ret_chooser_page_start1574_v0}"
    local __range_start_18043=0
    local __range_end_18043="${_page_count_82}"
    local __dir_18043=$(( ${__range_start_18043} <= ${__range_end_18043} ? 1 : -1 ))
    for (( i_18043=${__range_start_18043}; i_18043 * ${__dir_18043} < ${__range_end_18043} * ${__dir_18043}; i_18043+=${__dir_18043} )); do
        local global_idx_18044="$(( page_start_18042 + i_18043 ))"
        checked_is__1395_v0 "${global_idx_18044}"
        local ret_checked_is1395_v0__66_28="${ret_checked_is1395_v0}"
        local check_mark_18046
        check_mark_18046="$(if [ "${ret_checked_is1395_v0__66_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1308_v0 "${_page_81[${i_18043}]?"Index out of bounds (at src/./choose/./engine.ab:67:45)"}" "${max_option_width_18041}"
        local ret_cutoff_text1308_v0__67_27="${ret_cutoff_text1308_v0}"
        local truncated_18047="${ret_cutoff_text1308_v0__67_27}"
        checked_is__1395_v0 "${global_idx_18044}"
        local ret_checked_is1395_v0__70_13="${ret_checked_is1395_v0}"
        if [ "$(( i_18043 == _selected_75 ))" != 0 ]; then
            colored_secondary__1277_v0 "${_cursor_76}""${check_mark_18046}""${truncated_18047}""
"
            local ret_colored_secondary1277_v0__69_37="${ret_colored_secondary1277_v0}"
            local array_273=("")
            eprintf__1174_v0 "${ret_colored_secondary1277_v0__69_37}" array_273[@]
        elif [ "${ret_checked_is1395_v0__70_13}" != 0 ]; then
            print_blank__1227_v0 "${cursor_len_18040}"
            colored_secondary__1277_v0 "${check_mark_18046}""${truncated_18047}""
"
            local ret_colored_secondary1277_v0__72_25="${ret_colored_secondary1277_v0}"
            local array_274=("")
            eprintf__1174_v0 "${ret_colored_secondary1277_v0__72_25}" array_274[@]
        else
            print_blank__1227_v0 "${cursor_len_18040}"
            local array_275=("")
            eprintf__1174_v0 "${check_mark_18046}""${truncated_18047}""
" array_275[@]
        fi
done
    local remaining_slots_18049="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18049 > 0 ))" != 0 ]; then
        local __range_start_18050=0
        local __range_end_18050="${remaining_slots_18049}"
        local __dir_18050=$(( ${__range_start_18050} <= ${__range_end_18050} ? 1 : -1 ))
        for (( ____18050=${__range_start_18050}; ____18050 * ${__dir_18050} < ${__range_end_18050} * ${__dir_18050}; ____18050+=${__dir_18050} )); do
            local array_276=("")
            eprintf__1174_v0 "\\x1b[K
" array_276[@]
done
    fi
}

# render_page()
render_page__1570_v0() {
    if [ "${_multi_77}" != 0 ]; then
        render_multi_page__1569_v0 
    else
        render_single_page__1568_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1571_v0() {
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        local array_277=("")
        eprintf__1174_v0 "\\x1b[G\\x1b[K" array_277[@]
        eprintf_colored__1175_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
        local array_278=("")
        eprintf__1174_v0 "\\x1b[G" array_278[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1572_v0() {
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_279=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1335_v0 array_279[@] 36 "${_term_width_79}"
        else
            local array_280=("↑↓" "select" "enter" "confirm")
            render_tooltip__1335_v0 array_280[@] 25 "${_term_width_79}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_73 > 1 )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
            local array_281=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1335_v0 array_281[@] 55 "${_term_width_79}"
        elif [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_282=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1335_v0 array_282[@] 47 "${_term_width_79}"
        elif [ "$(( _limit_78 < 0 ))" != 0 ]; then
            local array_283=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1335_v0 array_283[@] 44 "${_term_width_79}"
        else
            local array_284=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1335_v0 array_284[@] 36 "${_term_width_79}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1573_v0() {
    local total_17958="${1}"
    local page_size_17959="${2}"
    local header_17960="${3}"
    local cursor_17961="${4}"
    local multi_17962="${5}"
    local limit_17963="${6}"
    _total_70="${total_17958}"
    _cursor_76="${cursor_17961}"
    _multi_77="${multi_17962}"
    _limit_78="${limit_17963}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_17960}" == "_" ]; echo $?)"
    stty_lock__1215_v0 
    hide_cursor__1232_v0 
    term_width__1222_v0 
    _term_width_79="${ret_term_width1222_v0}"
    term_height__1223_v0 
    local term_height_17968="${ret_term_height1223_v0}"
    local max_page_size_17969
    max_page_size_17969="$(( term_height_17968 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_17959}"
    if [ "$(( _page_size_71 > max_page_size_17969 ))" != 0 ]; then
        _page_size_71="${max_page_size_17969}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1308_v0 "${header_17960}" "${_term_width_79}"
        local ret_cutoff_text1308_v0__152_17="${ret_cutoff_text1308_v0}"
        local array_285=("")
        eprintf__1174_v0 "${ret_cutoff_text1308_v0__152_17}""
" array_285[@]
    fi
    _total_pages_73="$(( $(( $(( total_17958 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_17958 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_17958}"
    fi
    if [ "${multi_17962}" != 0 ]; then
        checked_init__1394_v0 "${total_17958}" "${limit_17963}"
    fi
    new_line__1228_v0 "${_display_count_72}"
    local array_286=("")
    eprintf__1174_v0 "\\x1b[G" array_286[@]
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        eprintf_colored__1175_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
    fi
    new_line__1228_v0 1
    render_tooltip_line__1572_v0 
    go_up__1229_v0 "$(( _display_count_72 + 1 ))"
    local array_287=("")
    eprintf__1174_v0 "\\x1b[G" array_287[@]
}

# chooser_page_start()
chooser_page_start__1574_v0() {
    ret_chooser_page_start1574_v0="$(( _current_page_74 * _page_size_71 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1575_v0() {
    chooser_page_start__1574_v0 
    local start_18035="${ret_chooser_page_start1574_v0}"
    local end_18036="$(( start_18035 + _page_size_71 ))"
    if [ "$(( end_18036 > _total_70 ))" != 0 ]; then
        end_18036="${_total_70}"
    fi
    ret_chooser_page_count1575_v0="$(( end_18036 - start_18035 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1576_v0() {
    local page_18039=("${!1}")
    _page_81=("${page_18039[@]}")
    local __length_288=("${page_18039[@]}")
    _page_count_82="${#__length_288[@]}"
    if [ "${_first_render_83}" != 0 ]; then
        _first_render_83=0
        render_page__1570_v0 
    else
        if [ "${_up_paged_84}" != 0 ]; then
            _selected_75="$(( _page_count_82 - 1 ))"
            _up_paged_84=0
        fi
        go_up__1229_v0 1
        remove_line__1225_v0 "$(( _display_count_72 - 1 ))"
        remove_current_line__1226_v0 
        local array_289=("")
        eprintf__1174_v0 "\\x1b[G" array_289[@]
        render_page__1570_v0 
        render_page_indicator__1571_v0 
    fi
}

# option_width()
option_width__1577_v0() {
    local check_width_18066
    check_width_18066="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_290="${_cursor_76}"
    ret_option_width1577_v0="$(( $(( _term_width_79 - ${#__length_290} )) - check_width_18066 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1578_v0() {
    local index_18079="${1}"
    local __length_291="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_291}"
    local blank_18080="${ret_rpad28_v0}"
    option_width__1577_v0 
    local ret_option_width1577_v0__223_49="${ret_option_width1577_v0}"
    cutoff_text__1308_v0 "${_page_81[${index_18079}]?"Index out of bounds (at src/./choose/./engine.ab:223:41)"}" "${ret_option_width1577_v0__223_49}"
    local truncated_18081="${ret_cutoff_text1308_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1578_v0="${blank_18080}""${truncated_18081}"
        return 0
    fi
    chooser_page_start__1574_v0 
    local ret_chooser_page_start1574_v0__227_19="${ret_chooser_page_start1574_v0}"
    checked_is__1395_v0 "$(( ret_chooser_page_start1574_v0__227_19 + index_18079 ))"
    local ret_checked_is1395_v0__227_8="${ret_checked_is1395_v0}"
    if [ "${ret_checked_is1395_v0__227_8}" != 0 ]; then
        colored_secondary__1277_v0 "✓ ""${truncated_18081}"
        local ret_colored_secondary1277_v0__228_24="${ret_colored_secondary1277_v0}"
        ret_unselected_line1578_v0="${blank_18080}""${ret_colored_secondary1277_v0__228_24}"
        return 0
    fi
    ret_unselected_line1578_v0="${blank_18080}""• ""${truncated_18081}"
    return 0
}

# selected_line(index: Int)
selected_line__1579_v0() {
    local index_18065="${1}"
    option_width__1577_v0 
    local ret_option_width1577_v0__235_49="${ret_option_width1577_v0}"
    cutoff_text__1308_v0 "${_page_81[${index_18065}]?"Index out of bounds (at src/./choose/./engine.ab:235:41)"}" "${ret_option_width1577_v0__235_49}"
    local truncated_18067="${ret_cutoff_text1308_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1277_v0 "${_cursor_76}""${truncated_18067}"
        ret_selected_line1579_v0="${ret_colored_secondary1277_v0}"
        return 0
    fi
    chooser_page_start__1574_v0 
    local ret_chooser_page_start1574_v0__239_29="${ret_chooser_page_start1574_v0}"
    checked_is__1395_v0 "$(( ret_chooser_page_start1574_v0__239_29 + index_18065 ))"
    local ret_checked_is1395_v0__239_18="${ret_checked_is1395_v0}"
    local mark_18068
    mark_18068="$(if [ "${ret_checked_is1395_v0__239_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1277_v0 "${_cursor_76}""${mark_18068}""${truncated_18067}"
    ret_selected_line1579_v0="${ret_colored_secondary1277_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1580_v0() {
    local prev_selected_18078="${1}"
    unselected_line__1578_v0 "${prev_selected_18078}"
    local ret_unselected_line1578_v0__246_47="${ret_unselected_line1578_v0}"
    redraw_row__1392_v0 "${_display_count_72}" "${prev_selected_18078}" "${ret_unselected_line1578_v0__246_47}"
    selected_line__1579_v0 "${_selected_75}"
    local ret_selected_line1579_v0__247_43="${ret_selected_line1579_v0}"
    redraw_row__1392_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1579_v0__247_43}"
}

# redraw_current_line()
redraw_current_line__1581_v0() {
    selected_line__1579_v0 "${_selected_75}"
    local ret_selected_line1579_v0__252_43="${ret_selected_line1579_v0}"
    redraw_row__1392_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1579_v0__252_43}"
}

# chooser_step()
chooser_step__1582_v0() {
    get_key__1172_v0 
    local key_18060="${ret_get_key1172_v0}"
    local prev_selected_18061="${_selected_75}"
    local prev_page_18062="${_current_page_74}"
    chooser_page_start__1574_v0 
    local page_start_18063="${ret_chooser_page_start1574_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_18060}" != "_UP" ]; echo $?) || $([ "_${key_18060}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18060}" != "_DOWN" ]; echo $?) || $([ "_${key_18060}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18060}" != "_LEFT" ]; echo $?) || $([ "_${key_18060}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_18060}" != "_RIGHT" ]; echo $?) || $([ "_${key_18060}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $(( $([ "_${key_18060}" != "_x" ]; echo $?) || $([ "_${key_18060}" != "_X" ]; echo $?) )) || $([ "_${key_18060}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1397_v0 "$(( page_start_18063 + _selected_75 ))"
        local ret_checked_toggle1397_v0__309_16="${ret_checked_toggle1397_v0}"
        if [ "${ret_checked_toggle1397_v0__309_16}" != 0 ]; then
            redraw_current_line__1581_v0 
        fi
        ret_chooser_step1582_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $(( $([ "_${key_18060}" != "_a" ]; echo $?) || $([ "_${key_18060}" != "_A" ]; echo $?) )) || $([ "_${key_18060}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
        checked_all__1398_v0 
        local ret_checked_all1398_v0__315_16="${ret_checked_all1398_v0}"
        if [ "${ret_checked_all1398_v0__315_16}" != 0 ]; then
            go_up__1229_v0 "${_display_count_72}"
            local array_292=("")
            eprintf__1174_v0 "\\x1b[G" array_292[@]
            render_page__1570_v0 
        fi
        ret_chooser_step1582_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $([ "_${key_18060}" != "_INPUT" ]; echo $?) || $([ "_${key_18060}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step1582_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1582_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_18062 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1582_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_18061 != _selected_75 ))" != 0 ]; then
        redraw_selection__1580_v0 "${prev_selected_18061}"
    fi
    ret_chooser_step1582_v0="${__CHOOSER_CONTINUE_67}"
    return 0
}

# chooser_selected()
chooser_selected__1583_v0() {
    chooser_page_start__1574_v0 
    local ret_chooser_page_start1574_v0__339_12="${ret_chooser_page_start1574_v0}"
    ret_chooser_selected1583_v0="$(( ret_chooser_page_start1574_v0__339_12 + _selected_75 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1584_v0() {
    local index_18088="${1}"
    checked_is__1395_v0 "${index_18088}"
    ret_chooser_is_checked1584_v0="${ret_checked_is1395_v0}"
    return 0
}

# chooser_end()
chooser_end__1585_v0() {
    local total_lines_18083="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_18083="$(( total_lines_18083 + 1 ))"
    fi
    go_down__1230_v0 1
    remove_line__1225_v0 "$(( total_lines_18083 - 1 ))"
    remove_current_line__1226_v0 
    stty_unlock__1216_v0 
    show_cursor__1233_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1594_v0() {
    local options_18092=("${!1}")
    local cursor_18093="${2}"
    local header_18094="${3}"
    local page_size_18095="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_293=("${options_18092[@]}")
    local total_18096="${#__length_293[@]}"
    if [ "$(( total_18096 == 0 ))" != 0 ]; then
        eprintf_colored__1175_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1573_v0 "${total_18096}" "${page_size_18095}" "${header_18094}" "${cursor_18093}" 0 -1
    local need_page_18097=1
    while :
    do
        if [ "${need_page_18097}" != 0 ]; then
            local page_18098=()
            chooser_page_start__1574_v0 
            local start_18099="${ret_chooser_page_start1574_v0}"
            chooser_page_count__1575_v0 
            local count_18100="${ret_chooser_page_count1575_v0}"
            local __range_start_18101="${start_18099}"
            local __range_end_18101="$(( start_18099 + count_18100 ))"
            local __dir_18101=$(( ${__range_start_18101} <= ${__range_end_18101} ? 1 : -1 ))
            for (( i_18101=${__range_start_18101}; i_18101 * ${__dir_18101} < ${__range_end_18101} * ${__dir_18101}; i_18101+=${__dir_18101} )); do
                local array_295=("${options_18092[${i_18101}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_18098+=("${array_295[@]}")
done
            chooser_set_page__1576_v0 page_18098[@]
        fi
        chooser_step__1582_v0 
        local step_18102="${ret_chooser_step1582_v0}"
        if [ "$(( step_18102 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18097="$(( step_18102 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1583_v0 
    local selected_18103="${ret_chooser_selected1583_v0}"
    chooser_end__1585_v0 
    ret_xyl_choose1594_v0="${options_18092[${selected_18103}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1595_v0() {
    local options_17952=("${!1}")
    local cursor_17953="${2}"
    local header_17954="${3}"
    local limit_17955="${4}"
    local page_size_17956="${5}"
    local __length_296=("${options_17952[@]}")
    local total_17957="${#__length_296[@]}"
    if [ "$(( total_17957 == 0 ))" != 0 ]; then
        eprintf_colored__1175_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1595_v0=()
        return 0
    fi
    chooser_begin__1573_v0 "${total_17957}" "${page_size_17956}" "${header_17954}" "${cursor_17953}" 1 "${limit_17955}"
    local need_page_18032=1
    while :
    do
        if [ "${need_page_18032}" != 0 ]; then
            local page_18033=()
            chooser_page_start__1574_v0 
            local start_18034="${ret_chooser_page_start1574_v0}"
            chooser_page_count__1575_v0 
            local count_18037="${ret_chooser_page_count1575_v0}"
            local __range_start_18038="${start_18034}"
            local __range_end_18038="$(( start_18034 + count_18037 ))"
            local __dir_18038=$(( ${__range_start_18038} <= ${__range_end_18038} ? 1 : -1 ))
            for (( i_18038=${__range_start_18038}; i_18038 * ${__dir_18038} < ${__range_end_18038} * ${__dir_18038}; i_18038+=${__dir_18038} )); do
                local array_299=("${options_17952[${i_18038}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_18033+=("${array_299[@]}")
done
            chooser_set_page__1576_v0 page_18033[@]
        fi
        chooser_step__1582_v0 
        local step_18082="${ret_chooser_step1582_v0}"
        if [ "$(( step_18082 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18032="$(( step_18082 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1585_v0 
    local result_18086=()
    local __range_start_18087=0
    local __range_end_18087="${total_17957}"
    local __dir_18087=$(( ${__range_start_18087} <= ${__range_end_18087} ? 1 : -1 ))
    for (( i_18087=${__range_start_18087}; i_18087 * ${__dir_18087} < ${__range_end_18087} * ${__dir_18087}; i_18087+=${__dir_18087} )); do
        chooser_is_checked__1584_v0 "${i_18087}"
        local ret_chooser_is_checked1584_v0__93_12="${ret_chooser_is_checked1584_v0}"
        if [ "${ret_chooser_is_checked1584_v0__93_12}" != 0 ]; then
            local array_301=("${options_17952[${i_18087}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_18086+=("${array_301[@]}")
        fi
done
    ret_xyl_multi_choose1595_v0=("${result_18086[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1696_v0() {
    local usage_17875=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1234_v0 usage_17875[@]
    printf '%s\n' ""
    colored_primary__1276_v0 "choose"
    local ret_colored_primary1276_v0__8_20="${ret_colored_primary1276_v0}"
    local title_17902=("${ret_colored_primary1276_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1234_v0 title_17902[@]
    printf '%s\n' ""
    colored_secondary__1277_v0 "Arguments:"
    local ret_colored_secondary1277_v0__11_12="${ret_colored_secondary1277_v0}"
    local array_304=()
    printf__128_v0 "${ret_colored_secondary1277_v0__11_12}""
" array_304[@]
    local arg_names_17904=("[<options> ...]")
    local arg_texts_17905=("List of options to choose from")
    local arg_notes_17906=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1411_v0 arg_names_17904[@] arg_texts_17905[@] arg_notes_17906[@] 20
    printf '%s\n' ""
    colored_secondary__1277_v0 "Flags:"
    local ret_colored_secondary1277_v0__18_12="${ret_colored_secondary1277_v0}"
    local array_308=()
    printf__128_v0 "${ret_colored_secondary1277_v0__18_12}""
" array_308[@]
    local names_17939=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_17940=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_17941=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1411_v0 names_17939[@] texts_17940[@] notes_17941[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1754_v0() {
    local options_17868=()
    local command_313
    command_313="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_17869="${command_313}"
    if [ "$([ "_${is_tty_17869}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_17868+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1754_v0=("${options_17868[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1755_v0() {
    local parameters_17852=("${!1}")
    local cursor_17853="> "
    colored_primary__1276_v0 "Choose: "
    local ret_colored_primary1276_v0__17_30="${ret_colored_primary1276_v0}"
    local header_17867="\\x1b[1m""${ret_colored_primary1276_v0__17_30}"
    read_stdin_options__1754_v0 
    local options_17870=("${ret_read_stdin_options1754_v0[@]}")
    local multi_17871=0
    local limit_17872=-1
    local page_size_17873=10
    local __length_317=("${parameters_17852[@]}")
    local slice_upper_316="${#__length_317[@]}"
    local slice_offset_318=2
    local slice_offset_318=$((${slice_offset_318} > 0 ? ${slice_offset_318} : 0))
    local slice_length_319="$(( slice_upper_316 - slice_offset_318 ))"
    local slice_length_319=$((${slice_length_319} > 0 ? ${slice_length_319} : 0))
    for param_17874 in "${parameters_17852[@]:${slice_offset_318}:${slice_length_319}}"; do
        starts_with__22_v0 "${param_17874}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17874}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17874}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17874}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_17874}" != "_-h" ]; echo $?) || $([ "_${param_17874}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1696_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_320="--cursor="
            slice__24_v0 "${param_17874}" "${#__length_320}" 0
            cursor_17853="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_321="--header="
            slice__24_v0 "${param_17874}" "${#__length_321}" 0
            header_17867="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_322="--limit="
            slice__24_v0 "${param_17874}" "${#__length_322}" 0
            local value_17942="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17942}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1175_v0 "ERROR: Invalid limit value: ""${value_17942}""
" 31
                exit 1
            fi
            limit_17872="${ret_parse_int13_v0}"
            multi_17871=1
        elif [ "$([ "_${param_17874}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_17871=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_323="--page-size="
            slice__24_v0 "${param_17874}" "${#__length_323}" 0
            local value_17947="${ret_slice24_v0}"
            parse_int__13_v0 "${value_17947}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1175_v0 "ERROR: Invalid page-size value: ""${value_17947}""
" 31
                exit 1
            fi
            page_size_17873="${ret_parse_int13_v0}"
        else
            options_17870+=("${param_17874}")
        fi
    done
    has_ansi_escape__1300_v0 "${header_17867}"
    local ret_has_ansi_escape1300_v0__59_44="${ret_has_ansi_escape1300_v0}"
    escape_ansi__1301_v0 "${header_17867}"
    local ret_escape_ansi1301_v0__59_73="${ret_escape_ansi1301_v0}"
    colored_primary__1276_v0 "${header_17867}"
    local ret_colored_primary1276_v0__59_111="${ret_colored_primary1276_v0}"
    local display_header_17951
    display_header_17951="$(if [ "$(( $([ "_${header_17867}" != "_" ]; echo $?) || ret_has_ansi_escape1300_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1301_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1276_v0__59_111}"; fi)"
    if [ "${multi_17871}" != 0 ]; then
        xyl_multi_choose__1595_v0 options_17870[@] "${cursor_17853}" "${display_header_17951}" "${limit_17872}" "${page_size_17873}"
        local results_18089=("${ret_xyl_multi_choose1595_v0[@]}")
        join__7_v0 results_18089[@] "
"
        ret_execute_choose1755_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1594_v0 options_17870[@] "${cursor_17853}" "${display_header_17951}" "${page_size_17873}"
    ret_execute_choose1755_v0="${ret_xyl_choose1594_v0}"
    return 0
}

# get_key()
get_key__1840_v0() {
    local command_325
    command_325="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1840_v0="${command_325}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1842_v0() {
    local format_27395="${1}"
    local args_27396=("${!2}")
    args_27396=("${format_27395}" "${args_27396[@]}")
    __status=$?
    printf "${args_27396[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1843_v0() {
    local message_27393="${1}"
    local color_27394="${2}"
    # Prints an error message with a specified color.
    local array_326=("${message_27393}")
    eprintf__1842_v0 "\\x1b[${color_27394}m%s\\x1b[0m" array_326[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1858_v0() {
    local format_27413="${1}"
    local args_27414=("${!2}")
    args_27414=("${format_27413}" "${args_27414[@]}")
    __status=$?
    printf "${args_27414[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_90="None"
# perl_available()
perl_available__1865_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_327
        command_327="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27338
        disabled_27338="$([ "_${command_327}" != "_No" ]; echo $?)"
        local command_328
        command_328="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27339
        found_27339="$(( $(( ! disabled_27338 )) && $([ "_${command_328}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_27339}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1865_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1866_v0() {
    local text_27337="${1}"
    perl_available__1865_v0 
    local ret_perl_available1865_v0__19_12="${ret_perl_available1865_v0}"
    if [ "$(( ! ret_perl_available1865_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1866_v0=''
        return 1
    fi
    local command_329
    command_329="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27337}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1866_v0=''
        return "${__status}"
    fi
    local width_str_27340="${command_329}"
    parse_int__13_v0 "${width_str_27340}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1866_v0=''
        return "${__status}"
    fi
    local width_27341="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1866_v0="${width_27341}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1871_v0() {
    local text_27327="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_330
    command_330="$([[ "${text_27327}" == *$'\x1b'* || "${text_27327}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27328="${command_330}"
    ret_has_ansi_escape1871_v0="$([ "_${has_escape_27328}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1873_v0() {
    local text_27333="${1}"
    local command_331
    command_331="$(printf "%s" "${text_27333}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1873_v0="${command_331}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1874_v0() {
    local text_27335="${1}"
    local command_332
    command_332="$(printf "%s" "${text_27335}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27336="${command_332}"
    ret_is_all_ascii1874_v0="$([ "_${result_27336}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1875_v0() {
    local text_27330="${1}"
    local command_333
    command_333="$(LC_ALL=C; __t="${text_27330}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27331="${command_333}"
    parse_int__13_v0 "${measured_27331}"
    __status=$?
    ret_plain_len1875_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1876_v0() {
    local text_27329="${1}"
    plain_len__1875_v0 "${text_27329}"
    local plain_27332="${ret_plain_len1875_v0}"
    if [ "$(( plain_27332 >= 0 ))" != 0 ]; then
        ret_get_visible_len1876_v0="${plain_27332}"
        return 0
    fi
    strip_ansi__1873_v0 "${text_27329}"
    local stripped_27334="${ret_strip_ansi1873_v0}"
    is_all_ascii__1874_v0 "${stripped_27334}"
    local ret_is_all_ascii1874_v0__46_12="${ret_is_all_ascii1874_v0}"
    if [ "$(( ! ret_is_all_ascii1874_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1866_v0 "${stripped_27334}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_334="${stripped_27334}"
            ret_get_visible_len1876_v0="${#__length_334}"
            return 0
        fi
        ret_get_visible_len1876_v0="${ret_perl_get_cjk_width1866_v0}"
        return 0
    fi
    local __length_335="${stripped_27334}"
    ret_get_visible_len1876_v0="${#__length_335}"
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
stty_count__1882_v0() {
    local command_337
    command_337="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27411="${command_337}"
    parse_int__13_v0 "${count_27411}"
    __status=$?
    ret_stty_count1882_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1883_v0() {
    stty_count__1882_v0 
    local count_num_27412="${ret_stty_count1882_v0}"
    if [ "$(( count_num_27412 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_27412="$(( count_num_27412 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27412}
    __status=$?
}

# stty_unlock()
stty_unlock__1884_v0() {
    stty_count__1882_v0 
    local count_num_27513="${ret_stty_count1882_v0}"
    if [ "$(( count_num_27513 > 0 ))" != 0 ]; then
        count_num_27513="$(( count_num_27513 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27513}
        __status=$?
        if [ "$(( count_num_27513 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1885_v0() {
    local size_27318="${1}"
    if [ "$([ "_${size_27318}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1885_v0=0
        return 0
    fi
    split__4_v0 "${size_27318}" " "
    local parts_27319=("${ret_split4_v0[@]}")
    local __length_338=("${parts_27319[@]}")
    if [ "$(( ${#__length_338[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1885_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27319[1]?"Index out of bounds (at src/./filter/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27319[0]?"Index out of bounds (at src/./filter/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_92=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1885_v0=1
    return 0
}

# query_term_size()
query_term_size__1886_v0() {
    local command_340
    command_340="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27321="${command_340}"
    store_term_size__1885_v0 "${size_27321}"
    ret_query_term_size1886_v0="${ret_store_term_size1885_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1887_v0() {
    local command_341
    command_341="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27317="${command_341}"
    store_term_size__1885_v0 "${size_27317}"
    ret_stty_term_size1887_v0="${ret_store_term_size1885_v0}"
    return 0
}

# get_term_size()
get_term_size__1888_v0() {
    stty_term_size__1887_v0 
    local detected_27320="${ret_stty_term_size1887_v0}"
    if [ "$(( ! detected_27320 ))" != 0 ]; then
        query_term_size__1886_v0 
        detected_27320="${ret_query_term_size1886_v0}"
    fi
    _got_term_size_91=1
}

# term_width()
term_width__1890_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1888_v0 
    fi
    ret_term_width1890_v0="${_term_size_92[0]?"Index out of bounds (at src/./filter/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1891_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1888_v0 
    fi
    ret_term_height1891_v0="${_term_size_92[1]?"Index out of bounds (at src/./filter/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1893_v0() {
    local cnt_27510="${1}"
    if [ "$(( cnt_27510 > 0 ))" != 0 ]; then
        local sequence_27511=""
        local __range_start_27512=0
        local __range_end_27512="${cnt_27510}"
        local __dir_27512=$(( ${__range_start_27512} <= ${__range_end_27512} ? 1 : -1 ))
        for (( ____27512=${__range_start_27512}; ____27512 * ${__dir_27512} < ${__range_end_27512} * ${__dir_27512}; ____27512+=${__dir_27512} )); do
            sequence_27511+="\\x1b[2K\\x1b[1A"
done
        local array_342=("")
        eprintf__1858_v0 "${sequence_27511}" array_342[@]
    fi
    local array_343=("")
    eprintf__1858_v0 "\\x1b[G" array_343[@]
}

# remove_current_line()
remove_current_line__1894_v0() {
    local array_344=("")
    eprintf__1858_v0 "\\x1b[2K\\x1b[G" array_344[@]
}

# new_line(cnt: Int)
new_line__1896_v0() {
    local cnt_27459="${1}"
    local __range_start_27460=0
    local __range_end_27460="${cnt_27459}"
    local __dir_27460=$(( ${__range_start_27460} <= ${__range_end_27460} ? 1 : -1 ))
    for (( ____27460=${__range_start_27460}; ____27460 * ${__dir_27460} < ${__range_end_27460} * ${__dir_27460}; ____27460+=${__dir_27460} )); do
        local array_345=("")
        eprintf__1858_v0 "
" array_345[@]
done
}

# go_up(cnt: Int)
go_up__1897_v0() {
    local cnt_27478="${1}"
    local array_346=("")
    eprintf__1858_v0 "\\x1b[${cnt_27478}A" array_346[@]
}

# go_down(cnt: Int)
go_down__1898_v0() {
    local cnt_27492="${1}"
    local array_347=("")
    eprintf__1858_v0 "\\x1b[${cnt_27492}B" array_347[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1900_v0() {
    local array_348=("")
    eprintf__1858_v0 "\\x1b[?25l" array_348[@]
}

# show_cursor()
show_cursor__1901_v0() {
    local array_349=("")
    eprintf__1858_v0 "\\x1b[?25h" array_349[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1902_v0() {
    local pieces_27316=("${!1}")
    term_width__1890_v0 
    local width_27322="${ret_term_width1890_v0}"
    local line_27323=""
    local line_len_27324=0
    for piece_27325 in "${pieces_27316[@]}"; do
        local __length_352="${piece_27325}"
        local piece_len_27326="${#__length_352}"
        has_ansi_escape__1871_v0 "${piece_27325}"
        local ret_has_ansi_escape1871_v0__186_12="${ret_has_ansi_escape1871_v0}"
        if [ "${ret_has_ansi_escape1871_v0__186_12}" != 0 ]; then
            get_visible_len__1876_v0 "${piece_27325}"
            piece_len_27326="${ret_get_visible_len1876_v0}"
        fi
        if [ "$([ "_${line_27323}" != "_" ]; echo $?)" != 0 ]; then
            line_27323="${piece_27325}"
            line_len_27324="${piece_len_27326}"
        elif [ "$(( $(( $(( line_len_27324 + 1 )) + piece_len_27326 )) > width_27322 ))" != 0 ]; then
            local array_353=()
            printf__128_v0 "${line_27323}""
" array_353[@]
            line_27323="${piece_27325}"
            line_len_27324="${piece_len_27326}"
        else
            line_27323+=" ""${piece_27325}"
            line_len_27324="$(( line_len_27324 + $(( 1 + piece_len_27326 )) ))"
        fi
    done
    if [ "$([ "_${line_27323}" == "_" ]; echo $?)" != 0 ]; then
        local array_354=()
        printf__128_v0 "${line_27323}""
" array_354[@]
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
get_supports_truecolor__1939_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_27354="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_27354}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1939_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1940_v0() {
    local message_27349="${1}"
    local r_27350="${2}"
    local g_27351="${3}"
    local b_27352="${4}"
    local fallback_27353="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1940_v0="\\x1b[38;2;${r_27350};${g_27351};${b_27352}m""${message_27349}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1939_v0 
        local ret_get_supports_truecolor1939_v0__45_17="${ret_get_supports_truecolor1939_v0}"
        if [ "${ret_get_supports_truecolor1939_v0__45_17}" != 0 ]; then
            ret_colored_rgb1940_v0="\\x1b[38;2;${r_27350};${g_27351};${b_27352}m""${message_27349}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27353 == 0 ))" != 0 ]; then
            ret_colored_rgb1940_v0="${message_27349}"
            return 0
        else
            ret_colored_rgb1940_v0="\\x1b[${fallback_27353}m""${message_27349}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27353 == 0 ))" != 0 ]; then
            ret_colored_rgb1940_v0="${message_27349}"
            return 0
        fi
        ret_colored_rgb1940_v0="\\x1b[${fallback_27353}m""${message_27349}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1942_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27343="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27343}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27343}" ";"
            local parts_27344=("${ret_split4_v0[@]}")
            local __length_358=("${parts_27344[@]}")
            if [ "$(( ${#__length_358[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27344[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27344[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27344[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27344[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_97=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_27345="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27345}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27345}" ";"
            local parts_27346=("${ret_split4_v0[@]}")
            local __length_360=("${parts_27346[@]}")
            if [ "$(( ${#__length_360[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27346[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27346[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27346[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27346[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_98=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_27347="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27347}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27347}" ";"
            local parts_27348=("${ret_split4_v0[@]}")
            local __length_362=("${parts_27348[@]}")
            if [ "$(( ${#__length_362[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27348[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27348[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27348[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27348[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1942_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_96=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1943_v0() {
    inner_get_xylitol_colors__1942_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_96=1
}

# colored_primary(message: Text)
colored_primary__1944_v0() {
    local message_27342="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1943_v0 
    fi
    colored_rgb__1940_v0 "${message_27342}" "${_primary_color_97[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1944_v0="${ret_colored_rgb1940_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1945_v0() {
    local message_27356="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1943_v0 
    fi
    colored_rgb__1940_v0 "${message_27356}" "${_secondary_color_98[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1945_v0="${ret_colored_rgb1940_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_100="None"
# perl_available()
perl_available__1962_v0() {
    if [ "$([ "_${_perl_state_100}" != "_None" ]; echo $?)" != 0 ]; then
        local command_364
        command_364="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27431
        disabled_27431="$([ "_${command_364}" != "_No" ]; echo $?)"
        local command_365
        command_365="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27432
        found_27432="$(( $(( ! disabled_27431 )) && $([ "_${command_365}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_27432}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1962_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1963_v0() {
    local text_27430="${1}"
    perl_available__1962_v0 
    local ret_perl_available1962_v0__19_12="${ret_perl_available1962_v0}"
    if [ "$(( ! ret_perl_available1962_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1963_v0=''
        return 1
    fi
    local command_366
    command_366="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27430}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1963_v0=''
        return "${__status}"
    fi
    local width_str_27433="${command_366}"
    parse_int__13_v0 "${width_str_27433}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1963_v0=''
        return "${__status}"
    fi
    local width_27434="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1963_v0="${width_27434}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1964_v0() {
    local text_27441="${1}"
    local max_width_27442="${2}"
    perl_available__1962_v0 
    local ret_perl_available1962_v0__30_12="${ret_perl_available1962_v0}"
    if [ "$(( ! ret_perl_available1962_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1964_v0=''
        return 1
    fi
    local command_367
    command_367="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27441}" ${max_width_27442} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1964_v0=''
        return "${__status}"
    fi
    local result_27443="${command_367}"
    ret_perl_truncate_cjk1964_v0="${result_27443}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1968_v0() {
    local text_27398="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_368
    command_368="$([[ "${text_27398}" == *$'\x1b'* || "${text_27398}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27399="${command_368}"
    ret_has_ansi_escape1968_v0="$([ "_${has_escape_27399}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1969_v0() {
    local text_27400="${1}"
    local command_369
    command_369="$(printf '%s' "${text_27400}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1969_v0="${command_369}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1970_v0() {
    local text_27426="${1}"
    local command_370
    command_370="$(printf "%s" "${text_27426}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1970_v0="${command_370}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1971_v0() {
    local text_27428="${1}"
    local command_371
    command_371="$(printf "%s" "${text_27428}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27429="${command_371}"
    ret_is_all_ascii1971_v0="$([ "_${result_27429}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1972_v0() {
    local text_27423="${1}"
    local command_372
    command_372="$(LC_ALL=C; __t="${text_27423}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27424="${command_372}"
    parse_int__13_v0 "${measured_27424}"
    __status=$?
    ret_plain_len1972_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1973_v0() {
    local text_27422="${1}"
    plain_len__1972_v0 "${text_27422}"
    local plain_27425="${ret_plain_len1972_v0}"
    if [ "$(( plain_27425 >= 0 ))" != 0 ]; then
        ret_get_visible_len1973_v0="${plain_27425}"
        return 0
    fi
    strip_ansi__1970_v0 "${text_27422}"
    local stripped_27427="${ret_strip_ansi1970_v0}"
    is_all_ascii__1971_v0 "${stripped_27427}"
    local ret_is_all_ascii1971_v0__46_12="${ret_is_all_ascii1971_v0}"
    if [ "$(( ! ret_is_all_ascii1971_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1963_v0 "${stripped_27427}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_373="${stripped_27427}"
            ret_get_visible_len1973_v0="${#__length_373}"
            return 0
        fi
        ret_get_visible_len1973_v0="${ret_perl_get_cjk_width1963_v0}"
        return 0
    fi
    local __length_374="${stripped_27427}"
    ret_get_visible_len1973_v0="${#__length_374}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1974_v0() {
    local text_27438="${1}"
    local max_width_27439="${2}"
    get_visible_len__1973_v0 "${text_27438}"
    local visible_len_27440="${ret_get_visible_len1973_v0}"
    if [ "$(( visible_len_27440 <= max_width_27439 ))" != 0 ]; then
        ret_truncate_text1974_v0="${text_27438}"
        return 0
    fi
    is_all_ascii__1971_v0 "${text_27438}"
    local ret_is_all_ascii1971_v0__61_12="${ret_is_all_ascii1971_v0}"
    if [ "$(( ! ret_is_all_ascii1971_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1964_v0 "${text_27438}" "${max_width_27439}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27438}" | cut -c1-${max_width_27439}
            __status=$?
        fi
        ret_truncate_text1974_v0="${ret_perl_truncate_cjk1964_v0}"
        return 0
    fi
    local command_375
    command_375="$(printf "%s" "${text_27438}" | cut -c1-${max_width_27439})"
    __status=$?
    ret_truncate_text1974_v0="${command_375}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1975_v0() {
    local text_27436="${1}"
    local max_width_27437="${2}"
    has_ansi_escape__1968_v0 "${text_27436}"
    local ret_has_ansi_escape1968_v0__73_12="${ret_has_ansi_escape1968_v0}"
    if [ "$(( ! ret_has_ansi_escape1968_v0__73_12 ))" != 0 ]; then
        truncate_text__1974_v0 "${text_27436}" "${max_width_27437}"
        ret_truncate_ansi1975_v0="${ret_truncate_text1974_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_376
    command_376="$([[ "${text_27436}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27444="${command_376}"
    # Replace \x1b[ with newline, then split
    local command_377
    command_377="$(t="${text_27436}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27445="${command_377}"
    split__4_v0 "${replaced_27445}" "
"
    local parts_27446=("${ret_split4_v0[@]}")
    local result_27447=""
    local remaining_width_27448="${max_width_27437}"
    local __range_start_27449=0
    local __length_378=("${parts_27446[@]}")
    local __range_end_27449="${#__length_378[@]}"
    local __dir_27449=$(( ${__range_start_27449} <= ${__range_end_27449} ? 1 : -1 ))
    for (( idx_27449=${__range_start_27449}; idx_27449 * ${__dir_27449} < ${__range_end_27449} * ${__dir_27449}; idx_27449+=${__dir_27449} )); do
        local part_27450="${parts_27446[${idx_27449}]?"Index out of bounds (at src/./filter/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27449 == 0 )) && $([ "_${starts_with_ansi_27444}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27450}" == "_" ]; echo $?) && $(( remaining_width_27448 > 0 )) ))" != 0 ]; then
                truncate_text__1974_v0 "${part_27450}" "${remaining_width_27448}"
                local ret_truncate_text1974_v0__95_35="${ret_truncate_text1974_v0}"
                local truncated_27451="${ret_truncate_text1974_v0__95_35}"
                result_27447+="${truncated_27451}"
                get_visible_len__1973_v0 "${truncated_27451}"
                local ret_get_visible_len1973_v0__97_36="${ret_get_visible_len1973_v0}"
                remaining_width_27448="$(( remaining_width_27448 - ret_get_visible_len1973_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_379
            command_379="$(__p="${part_27450}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27452="${command_379}"
            if [ "$([ "_${m_idx_27452}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_380
                command_380="$(__p="${part_27450}"; printf "%s" "${__p:0:${m_idx_27452}}")"
                __status=$?
                local ansi_params_27453="${command_380}"
                result_27447+="\\x1b[""${ansi_params_27453}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27452}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_27454="${ret_parse_int13_v0__108_41}"
                local text_start_27455="$(( m_idx_num_27454 + 1 ))"
                local command_381
                command_381="$(__p="${part_27450}"; printf "%s" "${__p:${text_start_27455}}")"
                __status=$?
                local text_part_27456="${command_381}"
                if [ "$(( $([ "_${text_part_27456}" == "_" ]; echo $?) && $(( remaining_width_27448 > 0 )) ))" != 0 ]; then
                    truncate_text__1974_v0 "${text_part_27456}" "${remaining_width_27448}"
                    local ret_truncate_text1974_v0__112_39="${ret_truncate_text1974_v0}"
                    local truncated_27457="${ret_truncate_text1974_v0__112_39}"
                    result_27447+="${truncated_27457}"
                    get_visible_len__1973_v0 "${truncated_27457}"
                    local ret_get_visible_len1973_v0__114_40="${ret_get_visible_len1973_v0}"
                    remaining_width_27448="$(( remaining_width_27448 - ret_get_visible_len1973_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27450}" == "_" ]; echo $?) && $(( remaining_width_27448 > 0 )) ))" != 0 ]; then
                    truncate_text__1974_v0 "${part_27450}" "${remaining_width_27448}"
                    local ret_truncate_text1974_v0__119_39="${ret_truncate_text1974_v0}"
                    local truncated_27458="${ret_truncate_text1974_v0__119_39}"
                    result_27447+="${truncated_27458}"
                    get_visible_len__1973_v0 "${truncated_27458}"
                    local ret_get_visible_len1973_v0__121_40="${ret_get_visible_len1973_v0}"
                    remaining_width_27448="$(( remaining_width_27448 - ret_get_visible_len1973_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1975_v0="${result_27447}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1976_v0() {
    local text_27420="${1}"
    local max_width_27421="${2}"
    get_visible_len__1973_v0 "${text_27420}"
    local visible_len_27435="${ret_get_visible_len1973_v0}"
    if [ "$(( visible_len_27435 <= max_width_27421 ))" != 0 ]; then
        ret_cutoff_text1976_v0="${text_27420}"
        return 0
    fi
    truncate_ansi__1975_v0 "${text_27420}" "$(( max_width_27421 - 3 ))"
    local ret_truncate_ansi1975_v0__137_12="${ret_truncate_ansi1975_v0}"
    ret_cutoff_text1976_v0="${ret_truncate_ansi1975_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1997_v0() {
    local format_27469="${1}"
    local args_27470=("${!2}")
    args_27470=("${format_27469}" "${args_27470[@]}")
    __status=$?
    printf "${args_27470[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1998_v0() {
    local message_27467="${1}"
    local color_27468="${2}"
    # Prints an error message with a specified color.
    local array_382=("${message_27467}")
    eprintf__1997_v0 "\\x1b[${color_27468}m%s\\x1b[0m" array_382[@]
}

# colored(message: Text, color: Int)
colored__1999_v0() {
    local message_27387="${1}"
    local color_27388="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1999_v0="\\x1b[${color_27388}m""${message_27387}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2003_v0() {
    local items_27461=("${!1}")
    local total_len_27462="${2}"
    local term_width_27463="${3}"
    local separator_27464=" • "
    local separator_len_27465=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27462 <= term_width_27463 ))" != 0 ]; then
        local iter_27466=0
        while :
        do
            local __length_383=("${items_27461[@]}")
            if [ "$(( iter_27466 >= ${#__length_383[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_27466 > 0 ))" != 0 ]; then
                eprintf_colored__1998_v0 "${separator_27464}" 90
            fi
            colored__1999_v0 "${items_27461[$(( iter_27466 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1999_v0__23_41="${ret_colored1999_v0}"
            local array_384=("")
            eprintf__1997_v0 "${items_27461[${iter_27466}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1999_v0__23_41}" array_384[@]
            iter_27466="$(( iter_27466 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_27471=0
        local first_27472=1
        local iter_27473=0
        while :
        do
            local __length_385=("${items_27461[@]}")
            if [ "$(( iter_27473 >= ${#__length_385[@]} ))" != 0 ]; then
                break
            fi
            local key_27474="${items_27461[${iter_27473}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:35:31)"}"
            local action_27475="${items_27461[$(( iter_27473 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:36:34)"}"
            local __length_386="${key_27474}"
            local __length_387="${action_27475}"
            local part_len_27476="$(( $(( ${#__length_386} + 1 )) + ${#__length_387} ))"
            local needed_27477="${part_len_27476}"
            if [ "$(( ! first_27472 ))" != 0 ]; then
                needed_27477="$(( needed_27477 + separator_len_27465 ))"
            fi
            if [ "$(( $(( current_len_27471 + needed_27477 )) > term_width_27463 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_27472 ))" != 0 ]; then
                eprintf_colored__1998_v0 "${separator_27464}" 90
            fi
            colored__1999_v0 "${action_27475}" 2
            local ret_colored1999_v0__51_33="${ret_colored1999_v0}"
            local array_388=("")
            eprintf__1997_v0 "${key_27474}"" ""${ret_colored1999_v0__51_33}" array_388[@]
            current_len_27471="$(( current_len_27471 + needed_27477 ))"
            first_27472=0
            iter_27473="$(( iter_27473 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2013_v0() {
    local format_27502="${1}"
    local args_27503=("${!2}")
    args_27503=("${format_27502}" "${args_27503[@]}")
    __status=$?
    printf "${args_27503[@]}" >&2
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
store_term_size__2040_v0() {
    local size_27366="${1}"
    if [ "$([ "_${size_27366}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2040_v0=0
        return 0
    fi
    split__4_v0 "${size_27366}" " "
    local parts_27367=("${ret_split4_v0[@]}")
    local __length_390=("${parts_27367[@]}")
    if [ "$(( ${#__length_390[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2040_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27367[1]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27367[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_104=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2040_v0=1
    return 0
}

# query_term_size()
query_term_size__2041_v0() {
    local command_392
    command_392="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27369="${command_392}"
    store_term_size__2040_v0 "${size_27369}"
    ret_query_term_size2041_v0="${ret_store_term_size2040_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2042_v0() {
    local command_393
    command_393="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27365="${command_393}"
    store_term_size__2040_v0 "${size_27365}"
    ret_stty_term_size2042_v0="${ret_store_term_size2040_v0}"
    return 0
}

# get_term_size()
get_term_size__2043_v0() {
    stty_term_size__2042_v0 
    local detected_27368="${ret_stty_term_size2042_v0}"
    if [ "$(( ! detected_27368 ))" != 0 ]; then
        query_term_size__2041_v0 
        detected_27368="${ret_query_term_size2041_v0}"
    fi
    _got_term_size_103=1
}

# term_width()
term_width__2045_v0() {
    if [ "$(( ! _got_term_size_103 ))" != 0 ]; then
        get_term_size__2043_v0 
    fi
    ret_term_width2045_v0="${_term_size_104[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__2052_v0() {
    local cnt_27501="${1}"
    local array_394=("")
    eprintf__2013_v0 "\\x1b[${cnt_27501}A" array_394[@]
}

# go_down(cnt: Int)
go_down__2053_v0() {
    local cnt_27504="${1}"
    local array_395=("")
    eprintf__2013_v0 "\\x1b[${cnt_27504}B" array_395[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__2060_v0() {
    local display_count_27498="${1}"
    local index_27499="${2}"
    local line_27500="${3}"
    go_up__2052_v0 "$(( display_count_27498 - index_27499 ))"
    local array_396=("")
    eprintf__1997_v0 "\\x1b[G\\x1b[K" array_396[@]
    local array_397=("")
    eprintf__1997_v0 "${line_27500}" array_397[@]
    go_down__2053_v0 "$(( display_count_27498 - index_27499 ))"
    local array_398=("")
    eprintf__1997_v0 "\\x1b[G" array_398[@]
}

# Which items of a multi-select widget are ticked.
_checked_105=()
_count_106=0
_total_107=0
_limit_108=-1
# checked_init(total: Int, limit: Int)
checked_init__2062_v0() {
    local total_27416="${1}"
    local limit_27417="${2}"
    _checked_105=()
    local __range_start_27418=0
    local __range_end_27418="${total_27416}"
    local __dir_27418=$(( ${__range_start_27418} <= ${__range_end_27418} ? 1 : -1 ))
    for (( ____27418=${__range_start_27418}; ____27418 * ${__dir_27418} < ${__range_end_27418} * ${__dir_27418}; ____27418+=${__dir_27418} )); do
        local array_401=(0)
        _checked_105+=("${array_401[@]}")
done
    _count_106=0
    _total_107="${total_27416}"
    _limit_108="${limit_27417}"
}

# checked_is(index: Int)
checked_is__2063_v0() {
    local index_27488="${1}"
    ret_checked_is2063_v0="${_checked_105[${index_27488}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_count()
checked_count__2064_v0() {
    ret_checked_count2064_v0="${_count_106}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__2065_v0() {
    local index_27505="${1}"
    if [ "${_checked_105[${index_27505}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_105["${index_27505}"]=0
        _count_106="$(( _count_106 - 1 ))"
        ret_checked_toggle2065_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_108 >= 0 )) && $(( _count_106 >= _limit_108 )) ))" != 0 ]; then
        ret_checked_toggle2065_v0=0
        return 0
    fi
    _checked_105["${index_27505}"]=1
    _count_106="$(( _count_106 + 1 ))"
    ret_checked_toggle2065_v0=1
    return 0
}

# checked_all()
checked_all__2066_v0() {
    if [ "$(( _limit_108 >= 0 ))" != 0 ]; then
        ret_checked_all2066_v0=0
        return 0
    fi
    local was_all_27506="$(( _count_106 == _total_107 ))"
    local __range_start_27507=0
    local __range_end_27507="${_total_107}"
    local __dir_27507=$(( ${__range_start_27507} <= ${__range_end_27507} ? 1 : -1 ))
    for (( i_27507=${__range_start_27507}; i_27507 * ${__dir_27507} < ${__range_end_27507} * ${__dir_27507}; i_27507+=${__dir_27507} )); do
        _checked_105["${i_27507}"]="$(( ! was_all_27506 ))"
done
    if [ "${was_all_27506}" != 0 ]; then
        _count_106=0
    else
        _count_106="${_total_107}"
    fi
    ret_checked_all2066_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2078_v0() {
    local pending_27384="${1}"
    local line_27385="${2}"
    local note_at_27386="${3}"
    if [ "$(( note_at_27386 < 0 ))" != 0 ]; then
        local array_402=()
        printf__128_v0 "${pending_27384}""${line_27385}""
" array_402[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27386 == 0 ))" != 0 ]; then
        colored__1999_v0 "${line_27385}" 90
        local ret_colored1999_v0__12_40="${ret_colored1999_v0}"
        local array_403=()
        printf__128_v0 "${pending_27384}""${ret_colored1999_v0__12_40}""
" array_403[@]
    else
        slice__24_v0 "${line_27385}" 0 "${note_at_27386}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27385}" "${note_at_27386}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1999_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1999_v0__13_58="${ret_colored1999_v0}"
        local array_404=()
        printf__128_v0 "${pending_27384}""${ret_slice24_v0__13_32}""${ret_colored1999_v0__13_58}""
" array_404[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2079_v0() {
    local names_27357=("${!1}")
    local texts_27358=("${!2}")
    local notes_27359=("${!3}")
    local min_name_width_27360="${4}"
    local __length_405=("${names_27357[@]}")
    local count_27361="${#__length_405[@]}"
    local name_width_27362="${min_name_width_27360}"
    local __range_start_27363=0
    local __range_end_27363="${count_27361}"
    local __dir_27363=$(( ${__range_start_27363} <= ${__range_end_27363} ? 1 : -1 ))
    for (( i_27363=${__range_start_27363}; i_27363 * ${__dir_27363} < ${__range_end_27363} * ${__dir_27363}; i_27363+=${__dir_27363} )); do
        local __length_406="${names_27357[${i_27363}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:28:33)"}"
        local width_27364="${#__length_406}"
        if [ "$(( width_27364 > name_width_27362 ))" != 0 ]; then
            name_width_27362="${width_27364}"
        fi
done
    term_width__2045_v0 
    local width_27370="${ret_term_width2045_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27371="$(( name_width_27362 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27372="$(( $(( width_27370 - indent_27371 )) < 24 ))"
    if [ "${stacked_27372}" != 0 ]; then
        indent_27371=6
    fi
    local avail_27373="$(( width_27370 - indent_27371 ))"
    rpad__28_v0 "" " " "${indent_27371}"
    local blank_27374="${ret_rpad28_v0}"
    local __range_start_27375=0
    local __range_end_27375="${count_27361}"
    local __dir_27375=$(( ${__range_start_27375} <= ${__range_end_27375} ? 1 : -1 ))
    for (( i_27375=${__range_start_27375}; i_27375 * ${__dir_27375} < ${__range_end_27375} * ${__dir_27375}; i_27375+=${__dir_27375} )); do
        local pending_27376="${blank_27374}"
        if [ "${stacked_27372}" != 0 ]; then
            local array_407=()
            printf__128_v0 "  ""${names_27357[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:48:33)"}""
" array_407[@]
        else
            rpad__28_v0 "  ""${names_27357[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:50:41)"}" " " "${indent_27371}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_27376="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_27358[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_27377=("${ret_split4_v0__52_21[@]}")
        local __length_408=("${words_27377[@]}")
        local note_start_27378="${#__length_408[@]}"
        if [ "$([ "_${notes_27359[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_409="${notes_27359[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_409} > avail_27373 ))" != 0 ]; then
                split__4_v0 "${notes_27359[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_27377+=("${ret_split4_v0__58_26[@]}")
            else
                local array_410=("${notes_27359[${i_27375}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:60:33)"}")
                words_27377+=("${array_410[@]}")
            fi
        fi
        local line_27379=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27380=-1
        local __range_start_27381=0
        local __length_411=("${words_27377[@]}")
        local __range_end_27381="${#__length_411[@]}"
        local __dir_27381=$(( ${__range_start_27381} <= ${__range_end_27381} ? 1 : -1 ))
        for (( j_27381=${__range_start_27381}; j_27381 * ${__dir_27381} < ${__range_end_27381} * ${__dir_27381}; j_27381+=${__dir_27381} )); do
            local word_27382="${words_27377[${j_27381}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:70:32)"}"
            local candidate_27383
            candidate_27383="$(if [ "$([ "_${line_27379}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27382}"; else echo "${line_27379}"" ""${word_27382}"; fi)"
            local __length_412="${candidate_27383}"
            if [ "$(( $(( ${#__length_412} > avail_27373 )) && $([ "_${line_27379}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2078_v0 "${pending_27376}" "${line_27379}" "${note_at_27380}"
                pending_27376="${blank_27374}"
                line_27379="${word_27382}"
                note_at_27380="$(if [ "$(( j_27381 >= note_start_27378 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27381 >= note_start_27378 )) && $(( note_at_27380 < 0 )) ))" != 0 ]; then
                    local __length_413="${candidate_27383}"
                    local __length_414="${word_27382}"
                    note_at_27380="$(( ${#__length_413} - ${#__length_414} ))"
                fi
                line_27379="${candidate_27383}"
            fi
done
        print_help_line__2078_v0 "${pending_27376}" "${line_27379}" "${note_at_27380}"
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
refresh_matches__2137_v0() {
    local command_417
    command_417="$(shopt -s nocasematch; __e=""; __p=""; __s=""; __i=0; for __it in "${_options_110[@]}"; do case "$__it" in ("${_query_114}") __e="$__e $__i";; ("${_query_114}"*) __p="$__p $__i";; (*"${_query_114}"*) __s="$__s $__i";; esac; __i=$((__i+1)); done; __a="$__e$__p$__s"; printf '%s' "${__a# }")"
    __status=$?
    local raw_27419="${command_417}"
    if [ "$([ "_${raw_27419}" != "_" ]; echo $?)" != 0 ]; then
        _matches_112=()
    else
        split__4_v0 "${raw_27419}" " "
        _matches_112=("${ret_split4_v0[@]}")
    fi
    local __length_419=("${_matches_112[@]}")
    _match_count_113="${#__length_419[@]}"
    _offset_119=0
    _sel_120=0
}

# visible_count()
visible_count__2138_v0() {
    local count_27479="$(( _match_count_113 - _offset_119 ))"
    if [ "$(( count_27479 > _height_118 ))" != 0 ]; then
        count_27479="${_height_118}"
    fi
    if [ "$(( count_27479 < 0 ))" != 0 ]; then
        count_27479=0
    fi
    ret_visible_count2138_v0="${count_27479}"
    return 0
}

# option_index(row: Int)
option_index__2139_v0() {
    local row_27484="${1}"
    parse_int__13_v0 "${_matches_112[$(( _offset_119 + row_27484 ))]?"Index out of bounds (at src/./filter/./mod.ab:52:37)"}"
    __status=$?
    ret_option_index2139_v0="${ret_parse_int13_v0}"
    return 0
}

# option_width()
option_width__2140_v0() {
    local check_width_27485
    check_width_27485="$(if [ "${_multi_121}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_420="${_cursor_117}"
    ret_option_width2140_v0="$(( $(( _term_width_123 - ${#__length_420} )) - check_width_27485 ))"
    return 0
}

# row_line(row: Int, highlighted: Bool)
row_line__2141_v0() {
    local row_27482="${1}"
    local highlighted_27483="${2}"
    option_index__2139_v0 "${row_27482}"
    local ret_option_index2139_v0__61_44="${ret_option_index2139_v0}"
    option_width__2140_v0 
    local ret_option_width2140_v0__61_64="${ret_option_width2140_v0}"
    cutoff_text__1976_v0 "${_options_110[${ret_option_index2139_v0__61_44}]?"Index out of bounds (at src/./filter/./mod.ab:61:44)"}" "${ret_option_width2140_v0__61_64}"
    local truncated_27486="${ret_cutoff_text1976_v0}"
    local __length_421="${_cursor_117}"
    rpad__28_v0 "" " " "${#__length_421}"
    local blank_27487="${ret_rpad28_v0}"
    if [ "$(( ! _multi_121 ))" != 0 ]; then
        if [ "${highlighted_27483}" != 0 ]; then
            colored_secondary__1945_v0 "${_cursor_117}""${truncated_27486}"
            ret_row_line2141_v0="${ret_colored_secondary1945_v0}"
            return 0
        fi
        ret_row_line2141_v0="${blank_27487}""${truncated_27486}"
        return 0
    fi
    option_index__2139_v0 "${row_27482}"
    local ret_option_index2139_v0__69_31="${ret_option_index2139_v0}"
    checked_is__2063_v0 "${ret_option_index2139_v0__69_31}"
    local ticked_27489="${ret_checked_is2063_v0}"
    local mark_27490
    mark_27490="$(if [ "${ticked_27489}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    if [ "${highlighted_27483}" != 0 ]; then
        colored_secondary__1945_v0 "${_cursor_117}""${mark_27490}""${truncated_27486}"
        ret_row_line2141_v0="${ret_colored_secondary1945_v0}"
        return 0
    fi
    if [ "${ticked_27489}" != 0 ]; then
        colored_secondary__1945_v0 "${mark_27490}""${truncated_27486}"
        local ret_colored_secondary1945_v0__75_24="${ret_colored_secondary1945_v0}"
        ret_row_line2141_v0="${blank_27487}""${ret_colored_secondary1945_v0__75_24}"
        return 0
    fi
    ret_row_line2141_v0="${blank_27487}""${mark_27490}""${truncated_27486}"
    return 0
}

# render_rows()
render_rows__2142_v0() {
    visible_count__2138_v0 
    local count_27480="${ret_visible_count2138_v0}"
    go_up__1897_v0 "${_height_118}"
    local array_422=("")
    eprintf__1842_v0 "\\x1b[G" array_422[@]
    local __range_start_27481=0
    local __range_end_27481="${count_27480}"
    local __dir_27481=$(( ${__range_start_27481} <= ${__range_end_27481} ? 1 : -1 ))
    for (( row_27481=${__range_start_27481}; row_27481 * ${__dir_27481} < ${__range_end_27481} * ${__dir_27481}; row_27481+=${__dir_27481} )); do
        row_line__2141_v0 "${row_27481}" "$(( row_27481 == _sel_120 ))"
        local ret_row_line2141_v0__86_28="${ret_row_line2141_v0}"
        local array_423=("")
        eprintf__1842_v0 "\\x1b[K""${ret_row_line2141_v0__86_28}""
" array_423[@]
done
    local __range_start_27491="${count_27480}"
    local __range_end_27491="${_height_118}"
    local __dir_27491=$(( ${__range_start_27491} <= ${__range_end_27491} ? 1 : -1 ))
    for (( ____27491=${__range_start_27491}; ____27491 * ${__dir_27491} < ${__range_end_27491} * ${__dir_27491}; ____27491+=${__dir_27491} )); do
        local array_424=("")
        eprintf__1842_v0 "\\x1b[K
" array_424[@]
done
    local array_425=("")
    eprintf__1842_v0 "\\x1b[G" array_425[@]
}

# render_query()
render_query__2143_v0() {
    go_up__1897_v0 "$(( _height_118 + 1 ))"
    local array_426=("")
    eprintf__1842_v0 "\\x1b[G\\x1b[K" array_426[@]
    colored_primary__1944_v0 "${_prompt_116}"
    local ret_colored_primary1944_v0__97_13="${ret_colored_primary1944_v0}"
    local array_427=("")
    eprintf__1842_v0 "${ret_colored_primary1944_v0__97_13}" array_427[@]
    if [ "$([ "_${_query_114}" != "_" ]; echo $?)" != 0 ]; then
        eprintf_colored__1843_v0 "${_placeholder_115}" 90
    else
        local __length_428="${_prompt_116}"
        cutoff_text__1976_v0 "${_query_114}" "$(( _term_width_123 - ${#__length_428} ))"
        local ret_cutoff_text1976_v0__101_17="${ret_cutoff_text1976_v0}"
        local array_429=("")
        eprintf__1842_v0 "${ret_cutoff_text1976_v0__101_17}" array_429[@]
    fi
    go_down__1898_v0 "$(( _height_118 + 1 ))"
    local array_430=("")
    eprintf__1842_v0 "\\x1b[G" array_430[@]
}

# render_count()
render_count__2144_v0() {
    local array_431=("")
    eprintf__1842_v0 "\\x1b[G\\x1b[K" array_431[@]
    eprintf_colored__1843_v0 "${_match_count_113}/${_option_count_111}" 90
    local array_432=("")
    eprintf__1842_v0 "\\x1b[G" array_432[@]
}

# render_tooltip_line()
render_tooltip_line__2145_v0() {
    if [ "${_multi_121}" != 0 ]; then
        local array_433=("↑↓" "select" "tab" "toggle" "ctrl-a" "all" "enter" "confirm")
        render_tooltip__2003_v0 array_433[@] 51 "${_term_width_123}"
    else
        local array_434=("↑↓" "select" "enter" "confirm")
        render_tooltip__2003_v0 array_434[@] 25 "${_term_width_123}"
    fi
}

# move_selection(step: Int)
move_selection__2146_v0() {
    local step_27494="${1}"
    visible_count__2138_v0 
    local count_27495="${ret_visible_count2138_v0}"
    if [ "$(( count_27495 == 0 ))" != 0 ]; then
        ret_move_selection2146_v0=0
        return 0
    fi
    local next_27496="$(( _sel_120 + step_27494 ))"
    if [ "$(( $(( next_27496 >= 0 )) && $(( next_27496 < count_27495 )) ))" != 0 ]; then
        local prev_27497="${_sel_120}"
        _sel_120="${next_27496}"
        row_line__2141_v0 "${prev_27497}" 0
        local ret_row_line2141_v0__132_35="${ret_row_line2141_v0}"
        redraw_row__2060_v0 "${_height_118}" "${prev_27497}" "${ret_row_line2141_v0__132_35}"
        row_line__2141_v0 "${_sel_120}" 1
        local ret_row_line2141_v0__133_35="${ret_row_line2141_v0}"
        redraw_row__2060_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2141_v0__133_35}"
        ret_move_selection2146_v0=0
        return 0
    fi
    if [ "$(( $(( next_27496 < 0 )) && $(( _offset_119 > 0 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 - 1 ))"
        ret_move_selection2146_v0=1
        return 0
    fi
    if [ "$(( $(( next_27496 >= count_27495 )) && $(( $(( _offset_119 + _height_118 )) < _match_count_113 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 + 1 ))"
        ret_move_selection2146_v0=1
        return 0
    fi
    ret_move_selection2146_v0=0
    return 0
}

# xyl_filter(options: [Text], prompt: Text, placeholder: Text, header: Text, cursor: Text, multi: Bool, limit: Int, height: Int)
xyl_filter__2147_v0() {
    local options_27402=("${!1}")
    local prompt_27403="${2}"
    local placeholder_27404="${3}"
    local header_27405="${4}"
    local cursor_27406="${5}"
    local multi_27407="${6}"
    local limit_27408="${7}"
    local height_27409="${8}"
    local __length_435=("${options_27402[@]}")
    local total_27410="${#__length_435[@]}"
    if [ "$(( total_27410 == 0 ))" != 0 ]; then
        eprintf_colored__1843_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    _options_110=("${options_27402[@]}")
    _option_count_111="${total_27410}"
    _query_114=""
    _prompt_116="${prompt_27403}"
    _placeholder_115="${placeholder_27404}"
    _cursor_117="${cursor_27406}"
    _multi_121="${multi_27407}"
    _has_header_122="$([ "_${header_27405}" == "_" ]; echo $?)"
    _offset_119=0
    _sel_120=0
    stty_lock__1883_v0 
    hide_cursor__1900_v0 
    term_width__1890_v0 
    _term_width_123="${ret_term_width1890_v0}"
    term_height__1891_v0 
    local ret_term_height1891_v0__189_24="${ret_term_height1891_v0}"
    local max_height_27415
    max_height_27415="$(( ret_term_height1891_v0__189_24 - $(if [ "${_has_header_122}" != 0 ]; then echo 4; else echo 3; fi) ))"
    _height_118="${height_27409}"
    if [ "$(( _height_118 > max_height_27415 ))" != 0 ]; then
        _height_118="${max_height_27415}"
    fi
    if [ "$(( _height_118 < 1 ))" != 0 ]; then
        _height_118=1
    fi
    if [ "${multi_27407}" != 0 ]; then
        checked_init__2062_v0 "${total_27410}" "${limit_27408}"
    fi
    refresh_matches__2137_v0 
    if [ "${_has_header_122}" != 0 ]; then
        cutoff_text__1976_v0 "${header_27405}" "${_term_width_123}"
        local ret_cutoff_text1976_v0__204_17="${ret_cutoff_text1976_v0}"
        local array_436=("")
        eprintf__1842_v0 "${ret_cutoff_text1976_v0__204_17}""
" array_436[@]
    fi
    new_line__1896_v0 1
    new_line__1896_v0 "${_height_118}"
    render_count__2144_v0 
    new_line__1896_v0 1
    render_tooltip_line__2145_v0 
    go_up__1897_v0 1
    local array_437=("")
    eprintf__1842_v0 "\\x1b[G" array_437[@]
    render_rows__2142_v0 
    render_query__2143_v0 
    while :
    do
        get_key__1840_v0 
        local key_27493="${ret_get_key1840_v0}"
        if [ "$([ "_${key_27493}" != "_INPUT" ]; echo $?)" != 0 ]; then
            visible_count__2138_v0 
            local ret_visible_count2138_v0__221_20="${ret_visible_count2138_v0}"
            if [ "$(( ret_visible_count2138_v0__221_20 > 0 ))" != 0 ]; then
                break
            fi
            if [ "${_multi_121}" != 0 ]; then
                checked_count__2064_v0 
                local ret_checked_count2064_v0__225_24="${ret_checked_count2064_v0}"
                if [ "$(( ret_checked_count2064_v0__225_24 > 0 ))" != 0 ]; then
                    break
                fi
            fi
        elif [ "$([ "_${key_27493}" != "_UP" ]; echo $?)" != 0 ]; then
            move_selection__2146_v0 -1
            local ret_move_selection2146_v0__231_20="${ret_move_selection2146_v0}"
            if [ "${ret_move_selection2146_v0__231_20}" != 0 ]; then
                render_rows__2142_v0 
            fi
        elif [ "$([ "_${key_27493}" != "_DOWN" ]; echo $?)" != 0 ]; then
            move_selection__2146_v0 1
            local ret_move_selection2146_v0__236_20="${ret_move_selection2146_v0}"
            if [ "${ret_move_selection2146_v0__236_20}" != 0 ]; then
                render_rows__2142_v0 
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27493}" != "_TAB" ]; echo $?) ))" != 0 ]; then
            visible_count__2138_v0 
            local ret_visible_count2138_v0__241_20="${ret_visible_count2138_v0}"
            if [ "$(( ret_visible_count2138_v0__241_20 > 0 ))" != 0 ]; then
                option_index__2139_v0 "${_sel_120}"
                local ret_option_index2139_v0__242_39="${ret_option_index2139_v0}"
                checked_toggle__2065_v0 "${ret_option_index2139_v0__242_39}"
                local ret_checked_toggle2065_v0__242_24="${ret_checked_toggle2065_v0}"
                if [ "${ret_checked_toggle2065_v0__242_24}" != 0 ]; then
                    row_line__2141_v0 "${_sel_120}" 1
                    local ret_row_line2141_v0__243_51="${ret_row_line2141_v0}"
                    redraw_row__2060_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2141_v0__243_51}"
                fi
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27493}" != "_CTRL_A" ]; echo $?) ))" != 0 ]; then
            checked_all__2066_v0 
            local ret_checked_all2066_v0__248_20="${ret_checked_all2066_v0}"
            if [ "${ret_checked_all2066_v0__248_20}" != 0 ]; then
                render_rows__2142_v0 
            fi
        elif [ "$([ "_${key_27493}" != "_BACKSPACE" ]; echo $?)" != 0 ]; then
            if [ "$([ "_${_query_114}" == "_" ]; echo $?)" != 0 ]; then
                local __length_438="${_query_114}"
                if [ "$(( ${#__length_438} == 1 ))" != 0 ]; then
                    _query_114=""
                else
                    local __length_439="${_query_114}"
                    slice__24_v0 "${_query_114}" 0 "$(( ${#__length_439} - 1 ))"
                    _query_114="${ret_slice24_v0}"
                fi
                refresh_matches__2137_v0 
                render_rows__2142_v0 
                render_query__2143_v0 
                render_count__2144_v0 
            fi
        else
            local typed_27508="${key_27493}"
            if [ "$([ "_${key_27493}" != "_SPACE" ]; echo $?)" != 0 ]; then
                typed_27508=" "
            fi
            local __length_440="${typed_27508}"
            if [ "$(( ${#__length_440} == 1 ))" != 0 ]; then
                _query_114+="${typed_27508}"
                refresh_matches__2137_v0 
                render_rows__2142_v0 
                render_query__2143_v0 
                render_count__2144_v0 
            fi
        fi
    done
    local total_lines_27509="$(( _height_118 + 3 ))"
    if [ "${_has_header_122}" != 0 ]; then
        total_lines_27509="$(( total_lines_27509 + 1 ))"
    fi
    go_down__1898_v0 1
    remove_line__1893_v0 "$(( total_lines_27509 - 1 ))"
    remove_current_line__1894_v0 
    stty_unlock__1884_v0 
    show_cursor__1901_v0 
    local result_27514=()
    if [ "${_multi_121}" != 0 ]; then
        local __range_start_27515=0
        local __range_end_27515="${total_27410}"
        local __dir_27515=$(( ${__range_start_27515} <= ${__range_end_27515} ? 1 : -1 ))
        for (( i_27515=${__range_start_27515}; i_27515 * ${__dir_27515} < ${__range_end_27515} * ${__dir_27515}; i_27515+=${__dir_27515} )); do
            checked_is__2063_v0 "${i_27515}"
            local ret_checked_is2063_v0__294_16="${ret_checked_is2063_v0}"
            if [ "${ret_checked_is2063_v0__294_16}" != 0 ]; then
                local array_442=("${_options_110[${i_27515}]?"Index out of bounds (at src/./filter/./mod.ab:295:37)"}")
                result_27514+=("${array_442[@]}")
            fi
done
        ret_xyl_filter2147_v0=("${result_27514[@]}")
        return 0
    fi
    visible_count__2138_v0 
    local ret_visible_count2138_v0__300_8="${ret_visible_count2138_v0}"
    if [ "$(( ret_visible_count2138_v0__300_8 > 0 ))" != 0 ]; then
        option_index__2139_v0 "${_sel_120}"
        local ret_option_index2139_v0__301_29="${ret_option_index2139_v0}"
        result_27514+=("${_options_110[${ret_option_index2139_v0__301_29}]?"Index out of bounds (at src/./filter/./mod.ab:301:29)"}")
    fi
    ret_xyl_filter2147_v0=("${result_27514[@]}")
    return 0
}

# print_filter_help()
print_filter_help__2247_v0() {
    local usage_27315=("Usage:" "./xylitol.sh" "filter" "[<options>" "...]" "[flags]")
    print_wrapped__1902_v0 usage_27315[@]
    printf '%s\n' ""
    colored_primary__1944_v0 "filter"
    local ret_colored_primary1944_v0__8_20="${ret_colored_primary1944_v0}"
    local title_27355=("${ret_colored_primary1944_v0__8_20}" "-" "Pick" "from" "a" "list" "narrowed" "by" "typing.")
    print_wrapped__1902_v0 title_27355[@]
    printf '%s\n' ""
    colored_secondary__1945_v0 "Arguments:"
    local ret_colored_secondary1945_v0__11_12="${ret_colored_secondary1945_v0}"
    local array_446=()
    printf__128_v0 "${ret_colored_secondary1945_v0__11_12}""
" array_446[@]
    local array_447=("[<options> ...]")
    local array_448=("List of options to pick from")
    local array_449=("")
    render_help_entries__2079_v0 array_447[@] array_448[@] array_449[@] 20
    printf '%s\n' ""
    colored_secondary__1945_v0 "Flags:"
    local ret_colored_secondary1945_v0__14_12="${ret_colored_secondary1945_v0}"
    local array_450=()
    printf__128_v0 "${ret_colored_secondary1945_v0__14_12}""
" array_450[@]
    local names_27389=("-h, --help" "--limit=<number>" "--no-limit" "--prompt=\"<text>\"" "--placeholder=\"<text>\"" "--cursor=\"<text>\"" "--header=\"<text>\"" "--height=<number>")
    local texts_27390=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the text shown in front of the query" "Set the text shown while the query is empty" "Set the cursor text" "Set a header text to display above the query" "Set the number of options shown at once")
    local notes_27391=("" "" "" "(default: '/ ')" "(default: 'Filter...')" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__2079_v0 names_27389[@] texts_27390[@] notes_27391[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__2305_v0() {
    local options_27308=()
    local command_455
    command_455="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_27309="${command_455}"
    if [ "$([ "_${is_tty_27309}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_27308+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options2305_v0=("${options_27308[@]}")
    return 0
}

# execute_filter(parameters: [Text])
execute_filter__2306_v0() {
    local parameters_27303=("${!1}")
    local cursor_27304="> "
    local prompt_27305="/ "
    local placeholder_27306="Filter..."
    local header_27307=""
    read_stdin_options__2305_v0 
    local options_27310=("${ret_read_stdin_options2305_v0[@]}")
    local multi_27311=0
    local limit_27312=-1
    local height_27313=10
    local __length_459=("${parameters_27303[@]}")
    local slice_upper_458="${#__length_459[@]}"
    local slice_offset_460=2
    local slice_offset_460=$((${slice_offset_460} > 0 ? ${slice_offset_460} : 0))
    local slice_length_461="$(( slice_upper_458 - slice_offset_460 ))"
    local slice_length_461=$((${slice_length_461} > 0 ? ${slice_length_461} : 0))
    for param_27314 in "${parameters_27303[@]:${slice_offset_460}:${slice_length_461}}"; do
        starts_with__22_v0 "${param_27314}" "--cursor="
        local ret_starts_with22_v0__31_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27314}" "--prompt="
        local ret_starts_with22_v0__34_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27314}" "--placeholder="
        local ret_starts_with22_v0__37_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27314}" "--header="
        local ret_starts_with22_v0__40_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27314}" "--limit="
        local ret_starts_with22_v0__43_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27314}" "--height="
        local ret_starts_with22_v0__54_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27314}" != "_-h" ]; echo $?) || $([ "_${param_27314}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_filter_help__2247_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__31_13}" != 0 ]; then
            local __length_462="--cursor="
            slice__24_v0 "${param_27314}" "${#__length_462}" 0
            cursor_27304="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__34_13}" != 0 ]; then
            local __length_463="--prompt="
            slice__24_v0 "${param_27314}" "${#__length_463}" 0
            prompt_27305="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__37_13}" != 0 ]; then
            local __length_464="--placeholder="
            slice__24_v0 "${param_27314}" "${#__length_464}" 0
            placeholder_27306="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__40_13}" != 0 ]; then
            local __length_465="--header="
            slice__24_v0 "${param_27314}" "${#__length_465}" 0
            header_27307="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__43_13}" != 0 ]; then
            local __length_466="--limit="
            slice__24_v0 "${param_27314}" "${#__length_466}" 0
            local value_27392="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27392}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1843_v0 "ERROR: Invalid limit value: ""${value_27392}""
" 31
                exit 1
            fi
            limit_27312="${ret_parse_int13_v0}"
            multi_27311=1
        elif [ "$([ "_${param_27314}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_27311=1
        elif [ "${ret_starts_with22_v0__54_13}" != 0 ]; then
            local __length_467="--height="
            slice__24_v0 "${param_27314}" "${#__length_467}" 0
            local value_27397="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27397}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1843_v0 "ERROR: Invalid height value: ""${value_27397}""
" 31
                exit 1
            fi
            height_27313="${ret_parse_int13_v0}"
        else
            options_27310+=("${param_27314}")
        fi
    done
    has_ansi_escape__1968_v0 "${header_27307}"
    local ret_has_ansi_escape1968_v0__67_44="${ret_has_ansi_escape1968_v0}"
    escape_ansi__1969_v0 "${header_27307}"
    local ret_escape_ansi1969_v0__67_73="${ret_escape_ansi1969_v0}"
    colored_primary__1944_v0 "${header_27307}"
    local ret_colored_primary1944_v0__67_111="${ret_colored_primary1944_v0}"
    local display_header_27401
    display_header_27401="$(if [ "$(( $([ "_${header_27307}" != "_" ]; echo $?) || ret_has_ansi_escape1968_v0__67_44 ))" != 0 ]; then echo "${ret_escape_ansi1969_v0__67_73}"; else echo "\\x1b[1m""${ret_colored_primary1944_v0__67_111}"; fi)"
    xyl_filter__2147_v0 options_27310[@] "${prompt_27305}" "${placeholder_27306}" "${display_header_27401}" "${cursor_27304}" "${multi_27311}" "${limit_27312}" "${height_27313}"
    local results_27516=("${ret_xyl_filter2147_v0[@]}")
    join__7_v0 results_27516[@] "
"
    ret_execute_filter2306_v0="${ret_join7_v0}"
    return 0
}

# get_key()
get_key__2430_v0() {
    local command_469
    command_469="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key2430_v0="${command_469}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2432_v0() {
    local format_29571="${1}"
    local args_29572=("${!2}")
    args_29572=("${format_29571}" "${args_29572[@]}")
    __status=$?
    printf "${args_29572[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2433_v0() {
    local message_29569="${1}"
    local color_29570="${2}"
    # Prints an error message with a specified color.
    local array_470=("${message_29569}")
    eprintf__2432_v0 "\\x1b[${color_29570}m%s\\x1b[0m" array_470[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2448_v0() {
    local format_29581="${1}"
    local args_29582=("${!2}")
    args_29582=("${format_29581}" "${args_29582[@]}")
    __status=$?
    printf "${args_29582[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_126="None"
# perl_available()
perl_available__2455_v0() {
    if [ "$([ "_${_perl_state_126}" != "_None" ]; echo $?)" != 0 ]; then
        local command_471
        command_471="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29527
        disabled_29527="$([ "_${command_471}" != "_No" ]; echo $?)"
        local command_472
        command_472="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29528
        found_29528="$(( $(( ! disabled_29527 )) && $([ "_${command_472}" != "_0" ]; echo $?) ))"
        _perl_state_126="$(if [ "${found_29528}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2455_v0="$([ "_${_perl_state_126}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2456_v0() {
    local text_29526="${1}"
    perl_available__2455_v0 
    local ret_perl_available2455_v0__19_12="${ret_perl_available2455_v0}"
    if [ "$(( ! ret_perl_available2455_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2456_v0=''
        return 1
    fi
    local command_473
    command_473="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29526}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2456_v0=''
        return "${__status}"
    fi
    local width_str_29529="${command_473}"
    parse_int__13_v0 "${width_str_29529}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2456_v0=''
        return "${__status}"
    fi
    local width_29530="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2456_v0="${width_29530}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2461_v0() {
    local text_29516="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_474
    command_474="$([[ "${text_29516}" == *$'\x1b'* || "${text_29516}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29517="${command_474}"
    ret_has_ansi_escape2461_v0="$([ "_${has_escape_29517}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2463_v0() {
    local text_29522="${1}"
    local command_475
    command_475="$(printf "%s" "${text_29522}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2463_v0="${command_475}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2464_v0() {
    local text_29524="${1}"
    local command_476
    command_476="$(printf "%s" "${text_29524}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29525="${command_476}"
    ret_is_all_ascii2464_v0="$([ "_${result_29525}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2465_v0() {
    local text_29519="${1}"
    local command_477
    command_477="$(LC_ALL=C; __t="${text_29519}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29520="${command_477}"
    parse_int__13_v0 "${measured_29520}"
    __status=$?
    ret_plain_len2465_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2466_v0() {
    local text_29518="${1}"
    plain_len__2465_v0 "${text_29518}"
    local plain_29521="${ret_plain_len2465_v0}"
    if [ "$(( plain_29521 >= 0 ))" != 0 ]; then
        ret_get_visible_len2466_v0="${plain_29521}"
        return 0
    fi
    strip_ansi__2463_v0 "${text_29518}"
    local stripped_29523="${ret_strip_ansi2463_v0}"
    is_all_ascii__2464_v0 "${stripped_29523}"
    local ret_is_all_ascii2464_v0__46_12="${ret_is_all_ascii2464_v0}"
    if [ "$(( ! ret_is_all_ascii2464_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2456_v0 "${stripped_29523}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_478="${stripped_29523}"
            ret_get_visible_len2466_v0="${#__length_478}"
            return 0
        fi
        ret_get_visible_len2466_v0="${ret_perl_get_cjk_width2456_v0}"
        return 0
    fi
    local __length_479="${stripped_29523}"
    ret_get_visible_len2466_v0="${#__length_479}"
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
stty_count__2472_v0() {
    local command_481
    command_481="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_29579="${command_481}"
    parse_int__13_v0 "${count_29579}"
    __status=$?
    ret_stty_count2472_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2473_v0() {
    stty_count__2472_v0 
    local count_num_29580="${ret_stty_count2472_v0}"
    if [ "$(( count_num_29580 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_29580="$(( count_num_29580 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29580}
    __status=$?
}

# stty_unlock()
stty_unlock__2474_v0() {
    stty_count__2472_v0 
    local count_num_29674="${ret_stty_count2472_v0}"
    if [ "$(( count_num_29674 > 0 ))" != 0 ]; then
        count_num_29674="$(( count_num_29674 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29674}
        __status=$?
        if [ "$(( count_num_29674 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2475_v0() {
    local size_29507="${1}"
    if [ "$([ "_${size_29507}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2475_v0=0
        return 0
    fi
    split__4_v0 "${size_29507}" " "
    local parts_29508=("${ret_split4_v0[@]}")
    local __length_482=("${parts_29508[@]}")
    if [ "$(( ${#__length_482[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2475_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29508[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29508[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_128=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2475_v0=1
    return 0
}

# query_term_size()
query_term_size__2476_v0() {
    local command_484
    command_484="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29510="${command_484}"
    store_term_size__2475_v0 "${size_29510}"
    ret_query_term_size2476_v0="${ret_store_term_size2475_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2477_v0() {
    local command_485
    command_485="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29506="${command_485}"
    store_term_size__2475_v0 "${size_29506}"
    ret_stty_term_size2477_v0="${ret_store_term_size2475_v0}"
    return 0
}

# get_term_size()
get_term_size__2478_v0() {
    stty_term_size__2477_v0 
    local detected_29509="${ret_stty_term_size2477_v0}"
    if [ "$(( ! detected_29509 ))" != 0 ]; then
        query_term_size__2476_v0 
        detected_29509="${ret_query_term_size2476_v0}"
    fi
    _got_term_size_127=1
}

# term_width()
term_width__2480_v0() {
    if [ "$(( ! _got_term_size_127 ))" != 0 ]; then
        get_term_size__2478_v0 
    fi
    ret_term_width2480_v0="${_term_size_128[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2483_v0() {
    local cnt_29671="${1}"
    if [ "$(( cnt_29671 > 0 ))" != 0 ]; then
        local sequence_29672=""
        local __range_start_29673=0
        local __range_end_29673="${cnt_29671}"
        local __dir_29673=$(( ${__range_start_29673} <= ${__range_end_29673} ? 1 : -1 ))
        for (( ____29673=${__range_start_29673}; ____29673 * ${__dir_29673} < ${__range_end_29673} * ${__dir_29673}; ____29673+=${__dir_29673} )); do
            sequence_29672+="\\x1b[2K\\x1b[1A"
done
        local array_486=("")
        eprintf__2448_v0 "${sequence_29672}" array_486[@]
    fi
    local array_487=("")
    eprintf__2448_v0 "\\x1b[G" array_487[@]
}

# remove_current_line()
remove_current_line__2484_v0() {
    local array_488=("")
    eprintf__2448_v0 "\\x1b[2K\\x1b[G" array_488[@]
}

# go_up(cnt: Int)
go_up__2487_v0() {
    local cnt_29667="${1}"
    local array_489=("")
    eprintf__2448_v0 "\\x1b[${cnt_29667}A" array_489[@]
}

# go_down(cnt: Int)
go_down__2488_v0() {
    local cnt_29670="${1}"
    local array_490=("")
    eprintf__2448_v0 "\\x1b[${cnt_29670}B" array_490[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__2490_v0() {
    local array_491=("")
    eprintf__2448_v0 "\\x1b[?25l" array_491[@]
}

# show_cursor()
show_cursor__2491_v0() {
    local array_492=("")
    eprintf__2448_v0 "\\x1b[?25h" array_492[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__2492_v0() {
    local pieces_29505=("${!1}")
    term_width__2480_v0 
    local width_29511="${ret_term_width2480_v0}"
    local line_29512=""
    local line_len_29513=0
    for piece_29514 in "${pieces_29505[@]}"; do
        local __length_495="${piece_29514}"
        local piece_len_29515="${#__length_495}"
        has_ansi_escape__2461_v0 "${piece_29514}"
        local ret_has_ansi_escape2461_v0__186_12="${ret_has_ansi_escape2461_v0}"
        if [ "${ret_has_ansi_escape2461_v0__186_12}" != 0 ]; then
            get_visible_len__2466_v0 "${piece_29514}"
            piece_len_29515="${ret_get_visible_len2466_v0}"
        fi
        if [ "$([ "_${line_29512}" != "_" ]; echo $?)" != 0 ]; then
            line_29512="${piece_29514}"
            line_len_29513="${piece_len_29515}"
        elif [ "$(( $(( $(( line_len_29513 + 1 )) + piece_len_29515 )) > width_29511 ))" != 0 ]; then
            local array_496=()
            printf__128_v0 "${line_29512}""
" array_496[@]
            line_29512="${piece_29514}"
            line_len_29513="${piece_len_29515}"
        else
            line_29512+=" ""${piece_29514}"
            line_len_29513="$(( line_len_29513 + $(( 1 + piece_len_29515 )) ))"
        fi
    done
    if [ "$([ "_${line_29512}" == "_" ]; echo $?)" != 0 ]; then
        local array_497=()
        printf__128_v0 "${line_29512}""
" array_497[@]
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
get_supports_truecolor__2529_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_29500="${ret_env_var_get120_v0}"
    _supports_truecolor_131="$(if [ "$([ "_${config_29500}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2529_v0="$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2530_v0() {
    local message_29495="${1}"
    local r_29496="${2}"
    local g_29497="${3}"
    local b_29498="${4}"
    local fallback_29499="${5}"
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2530_v0="\\x1b[38;2;${r_29496};${g_29497};${b_29498}m""${message_29495}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2529_v0 
        local ret_get_supports_truecolor2529_v0__45_17="${ret_get_supports_truecolor2529_v0}"
        if [ "${ret_get_supports_truecolor2529_v0__45_17}" != 0 ]; then
            ret_colored_rgb2530_v0="\\x1b[38;2;${r_29496};${g_29497};${b_29498}m""${message_29495}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_29499 == 0 ))" != 0 ]; then
            ret_colored_rgb2530_v0="${message_29495}"
            return 0
        else
            ret_colored_rgb2530_v0="\\x1b[${fallback_29499}m""${message_29495}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_29499 == 0 ))" != 0 ]; then
            ret_colored_rgb2530_v0="${message_29495}"
            return 0
        fi
        ret_colored_rgb2530_v0="\\x1b[${fallback_29499}m""${message_29495}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__2531_v0() {
    local message_29644="${1}"
    local r_29645="${2}"
    local g_29646="${3}"
    local b_29647="${4}"
    local fallback_29648="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_29649="${fallback_29648}"
    if [ "$(( $(( fallback_29648 >= 30 )) && $(( fallback_29648 <= 37 )) ))" != 0 ]; then
        bg_fallback_29649="$(( fallback_29648 + 10 ))"
    fi
    if [ "$(( $(( fallback_29648 >= 90 )) && $(( fallback_29648 <= 97 )) ))" != 0 ]; then
        bg_fallback_29649="$(( fallback_29648 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb2531_v0="\\x1b[48;2;${r_29645};${g_29646};${b_29647}m""${message_29644}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2529_v0 
        local ret_get_supports_truecolor2529_v0__87_17="${ret_get_supports_truecolor2529_v0}"
        if [ "${ret_get_supports_truecolor2529_v0__87_17}" != 0 ]; then
            ret_background_rgb2531_v0="\\x1b[48;2;${r_29645};${g_29646};${b_29647}m""${message_29644}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_29649 == 0 ))" != 0 ]; then
            ret_background_rgb2531_v0="${message_29644}"
            return 0
        else
            ret_background_rgb2531_v0="\\x1b[${bg_fallback_29649}m""${message_29644}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_29649 == 0 ))" != 0 ]; then
            ret_background_rgb2531_v0="${message_29644}"
            return 0
        fi
        ret_background_rgb2531_v0="\\x1b[${bg_fallback_29649}m""${message_29644}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2532_v0() {
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_29489="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_29489}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_29489}" ";"
            local parts_29490=("${ret_split4_v0[@]}")
            local __length_501=("${parts_29490[@]}")
            if [ "$(( ${#__length_501[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29490[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29490[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29490[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29490[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_133=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_29491="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_29491}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_29491}" ";"
            local parts_29492=("${ret_split4_v0[@]}")
            local __length_503=("${parts_29492[@]}")
            if [ "$(( ${#__length_503[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29492[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29492[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29492[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29492[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_134=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_29493="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_29493}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_29493}" ";"
            local parts_29494=("${ret_split4_v0[@]}")
            local __length_505=("${parts_29494[@]}")
            if [ "$(( ${#__length_505[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29494[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29494[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29494[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29494[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2532_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_132=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2533_v0() {
    inner_get_xylitol_colors__2532_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_132=1
}

# colored_primary(message: Text)
colored_primary__2534_v0() {
    local message_29488="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2533_v0 
    fi
    colored_rgb__2530_v0 "${message_29488}" "${_primary_color_133[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_133[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_133[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_133[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2534_v0="${ret_colored_rgb2530_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2535_v0() {
    local message_29532="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2533_v0 
    fi
    colored_rgb__2530_v0 "${message_29532}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2535_v0="${ret_colored_rgb2530_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__2538_v0() {
    local message_29643="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2533_v0 
    fi
    background_rgb__2531_v0 "${message_29643}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary2538_v0="${ret_background_rgb2531_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_136="None"
# perl_available()
perl_available__2552_v0() {
    if [ "$([ "_${_perl_state_136}" != "_None" ]; echo $?)" != 0 ]; then
        local command_507
        command_507="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29595
        disabled_29595="$([ "_${command_507}" != "_No" ]; echo $?)"
        local command_508
        command_508="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29596
        found_29596="$(( $(( ! disabled_29595 )) && $([ "_${command_508}" != "_0" ]; echo $?) ))"
        _perl_state_136="$(if [ "${found_29596}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2552_v0="$([ "_${_perl_state_136}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2553_v0() {
    local text_29594="${1}"
    perl_available__2552_v0 
    local ret_perl_available2552_v0__19_12="${ret_perl_available2552_v0}"
    if [ "$(( ! ret_perl_available2552_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2553_v0=''
        return 1
    fi
    local command_509
    command_509="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29594}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2553_v0=''
        return "${__status}"
    fi
    local width_str_29597="${command_509}"
    parse_int__13_v0 "${width_str_29597}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2553_v0=''
        return "${__status}"
    fi
    local width_29598="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2553_v0="${width_29598}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2554_v0() {
    local text_29605="${1}"
    local max_width_29606="${2}"
    perl_available__2552_v0 
    local ret_perl_available2552_v0__30_12="${ret_perl_available2552_v0}"
    if [ "$(( ! ret_perl_available2552_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2554_v0=''
        return 1
    fi
    local command_510
    command_510="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_29605}" ${max_width_29606} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2554_v0=''
        return "${__status}"
    fi
    local result_29607="${command_510}"
    ret_perl_truncate_cjk2554_v0="${result_29607}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2558_v0() {
    local text_29573="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_511
    command_511="$([[ "${text_29573}" == *$'\x1b'* || "${text_29573}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29574="${command_511}"
    ret_has_ansi_escape2558_v0="$([ "_${has_escape_29574}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2559_v0() {
    local text_29575="${1}"
    local command_512
    command_512="$(printf '%s' "${text_29575}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2559_v0="${command_512}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2560_v0() {
    local text_29590="${1}"
    local command_513
    command_513="$(printf "%s" "${text_29590}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2560_v0="${command_513}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2561_v0() {
    local text_29592="${1}"
    local command_514
    command_514="$(printf "%s" "${text_29592}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29593="${command_514}"
    ret_is_all_ascii2561_v0="$([ "_${result_29593}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2562_v0() {
    local text_29587="${1}"
    local command_515
    command_515="$(LC_ALL=C; __t="${text_29587}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29588="${command_515}"
    parse_int__13_v0 "${measured_29588}"
    __status=$?
    ret_plain_len2562_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2563_v0() {
    local text_29586="${1}"
    plain_len__2562_v0 "${text_29586}"
    local plain_29589="${ret_plain_len2562_v0}"
    if [ "$(( plain_29589 >= 0 ))" != 0 ]; then
        ret_get_visible_len2563_v0="${plain_29589}"
        return 0
    fi
    strip_ansi__2560_v0 "${text_29586}"
    local stripped_29591="${ret_strip_ansi2560_v0}"
    is_all_ascii__2561_v0 "${stripped_29591}"
    local ret_is_all_ascii2561_v0__46_12="${ret_is_all_ascii2561_v0}"
    if [ "$(( ! ret_is_all_ascii2561_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2553_v0 "${stripped_29591}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_516="${stripped_29591}"
            ret_get_visible_len2563_v0="${#__length_516}"
            return 0
        fi
        ret_get_visible_len2563_v0="${ret_perl_get_cjk_width2553_v0}"
        return 0
    fi
    local __length_517="${stripped_29591}"
    ret_get_visible_len2563_v0="${#__length_517}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2564_v0() {
    local text_29602="${1}"
    local max_width_29603="${2}"
    get_visible_len__2563_v0 "${text_29602}"
    local visible_len_29604="${ret_get_visible_len2563_v0}"
    if [ "$(( visible_len_29604 <= max_width_29603 ))" != 0 ]; then
        ret_truncate_text2564_v0="${text_29602}"
        return 0
    fi
    is_all_ascii__2561_v0 "${text_29602}"
    local ret_is_all_ascii2561_v0__61_12="${ret_is_all_ascii2561_v0}"
    if [ "$(( ! ret_is_all_ascii2561_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__2554_v0 "${text_29602}" "${max_width_29603}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_29602}" | cut -c1-${max_width_29603}
            __status=$?
        fi
        ret_truncate_text2564_v0="${ret_perl_truncate_cjk2554_v0}"
        return 0
    fi
    local command_518
    command_518="$(printf "%s" "${text_29602}" | cut -c1-${max_width_29603})"
    __status=$?
    ret_truncate_text2564_v0="${command_518}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2565_v0() {
    local text_29600="${1}"
    local max_width_29601="${2}"
    has_ansi_escape__2558_v0 "${text_29600}"
    local ret_has_ansi_escape2558_v0__73_12="${ret_has_ansi_escape2558_v0}"
    if [ "$(( ! ret_has_ansi_escape2558_v0__73_12 ))" != 0 ]; then
        truncate_text__2564_v0 "${text_29600}" "${max_width_29601}"
        ret_truncate_ansi2565_v0="${ret_truncate_text2564_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_519
    command_519="$([[ "${text_29600}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_29608="${command_519}"
    # Replace \x1b[ with newline, then split
    local command_520
    command_520="$(t="${text_29600}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_29609="${command_520}"
    split__4_v0 "${replaced_29609}" "
"
    local parts_29610=("${ret_split4_v0[@]}")
    local result_29611=""
    local remaining_width_29612="${max_width_29601}"
    local __range_start_29613=0
    local __length_521=("${parts_29610[@]}")
    local __range_end_29613="${#__length_521[@]}"
    local __dir_29613=$(( ${__range_start_29613} <= ${__range_end_29613} ? 1 : -1 ))
    for (( idx_29613=${__range_start_29613}; idx_29613 * ${__dir_29613} < ${__range_end_29613} * ${__dir_29613}; idx_29613+=${__dir_29613} )); do
        local part_29614="${parts_29610[${idx_29613}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_29613 == 0 )) && $([ "_${starts_with_ansi_29608}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_29614}" == "_" ]; echo $?) && $(( remaining_width_29612 > 0 )) ))" != 0 ]; then
                truncate_text__2564_v0 "${part_29614}" "${remaining_width_29612}"
                local ret_truncate_text2564_v0__95_35="${ret_truncate_text2564_v0}"
                local truncated_29615="${ret_truncate_text2564_v0__95_35}"
                result_29611+="${truncated_29615}"
                get_visible_len__2563_v0 "${truncated_29615}"
                local ret_get_visible_len2563_v0__97_36="${ret_get_visible_len2563_v0}"
                remaining_width_29612="$(( remaining_width_29612 - ret_get_visible_len2563_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_522
            command_522="$(__p="${part_29614}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_29616="${command_522}"
            if [ "$([ "_${m_idx_29616}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_523
                command_523="$(__p="${part_29614}"; printf "%s" "${__p:0:${m_idx_29616}}")"
                __status=$?
                local ansi_params_29617="${command_523}"
                result_29611+="\\x1b[""${ansi_params_29617}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_29616}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_29618="${ret_parse_int13_v0__108_41}"
                local text_start_29619="$(( m_idx_num_29618 + 1 ))"
                local command_524
                command_524="$(__p="${part_29614}"; printf "%s" "${__p:${text_start_29619}}")"
                __status=$?
                local text_part_29620="${command_524}"
                if [ "$(( $([ "_${text_part_29620}" == "_" ]; echo $?) && $(( remaining_width_29612 > 0 )) ))" != 0 ]; then
                    truncate_text__2564_v0 "${text_part_29620}" "${remaining_width_29612}"
                    local ret_truncate_text2564_v0__112_39="${ret_truncate_text2564_v0}"
                    local truncated_29621="${ret_truncate_text2564_v0__112_39}"
                    result_29611+="${truncated_29621}"
                    get_visible_len__2563_v0 "${truncated_29621}"
                    local ret_get_visible_len2563_v0__114_40="${ret_get_visible_len2563_v0}"
                    remaining_width_29612="$(( remaining_width_29612 - ret_get_visible_len2563_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_29614}" == "_" ]; echo $?) && $(( remaining_width_29612 > 0 )) ))" != 0 ]; then
                    truncate_text__2564_v0 "${part_29614}" "${remaining_width_29612}"
                    local ret_truncate_text2564_v0__119_39="${ret_truncate_text2564_v0}"
                    local truncated_29622="${ret_truncate_text2564_v0__119_39}"
                    result_29611+="${truncated_29622}"
                    get_visible_len__2563_v0 "${truncated_29622}"
                    local ret_get_visible_len2563_v0__121_40="${ret_get_visible_len2563_v0}"
                    remaining_width_29612="$(( remaining_width_29612 - ret_get_visible_len2563_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2565_v0="${result_29611}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2566_v0() {
    local text_29584="${1}"
    local max_width_29585="${2}"
    get_visible_len__2563_v0 "${text_29584}"
    local visible_len_29599="${ret_get_visible_len2563_v0}"
    if [ "$(( visible_len_29599 <= max_width_29585 ))" != 0 ]; then
        ret_cutoff_text2566_v0="${text_29584}"
        return 0
    fi
    truncate_ansi__2565_v0 "${text_29584}" "$(( max_width_29585 - 3 ))"
    local ret_truncate_ansi2565_v0__137_12="${ret_truncate_ansi2565_v0}"
    ret_cutoff_text2566_v0="${ret_truncate_ansi2565_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2587_v0() {
    local format_29658="${1}"
    local args_29659=("${!2}")
    args_29659=("${format_29658}" "${args_29659[@]}")
    __status=$?
    printf "${args_29659[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2588_v0() {
    local message_29656="${1}"
    local color_29657="${2}"
    # Prints an error message with a specified color.
    local array_525=("${message_29656}")
    eprintf__2587_v0 "\\x1b[${color_29657}m%s\\x1b[0m" array_525[@]
}

# colored(message: Text, color: Int)
colored__2589_v0() {
    local message_29566="${1}"
    local color_29567="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2589_v0="\\x1b[${color_29567}m""${message_29566}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2593_v0() {
    local items_29650=("${!1}")
    local total_len_29651="${2}"
    local term_width_29652="${3}"
    local separator_29653=" • "
    local separator_len_29654=3
    # Fast path: no truncation needed
    if [ "$(( total_len_29651 <= term_width_29652 ))" != 0 ]; then
        local iter_29655=0
        while :
        do
            local __length_526=("${items_29650[@]}")
            if [ "$(( iter_29655 >= ${#__length_526[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_29655 > 0 ))" != 0 ]; then
                eprintf_colored__2588_v0 "${separator_29653}" 90
            fi
            colored__2589_v0 "${items_29650[$(( iter_29655 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2589_v0__23_41="${ret_colored2589_v0}"
            local array_527=("")
            eprintf__2587_v0 "${items_29650[${iter_29655}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2589_v0__23_41}" array_527[@]
            iter_29655="$(( iter_29655 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_29660=0
        local first_29661=1
        local iter_29662=0
        while :
        do
            local __length_528=("${items_29650[@]}")
            if [ "$(( iter_29662 >= ${#__length_528[@]} ))" != 0 ]; then
                break
            fi
            local key_29663="${items_29650[${iter_29662}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_29664="${items_29650[$(( iter_29662 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_529="${key_29663}"
            local __length_530="${action_29664}"
            local part_len_29665="$(( $(( ${#__length_529} + 1 )) + ${#__length_530} ))"
            local needed_29666="${part_len_29665}"
            if [ "$(( ! first_29661 ))" != 0 ]; then
                needed_29666="$(( needed_29666 + separator_len_29654 ))"
            fi
            if [ "$(( $(( current_len_29660 + needed_29666 )) > term_width_29652 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_29661 ))" != 0 ]; then
                eprintf_colored__2588_v0 "${separator_29653}" 90
            fi
            colored__2589_v0 "${action_29664}" 2
            local ret_colored2589_v0__51_33="${ret_colored2589_v0}"
            local array_531=("")
            eprintf__2587_v0 "${key_29663}"" ""${ret_colored2589_v0__51_33}" array_531[@]
            current_len_29660="$(( current_len_29660 + needed_29666 ))"
            first_29661=0
            iter_29662="$(( iter_29662 + 2 ))"
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
store_term_size__2630_v0() {
    local size_29545="${1}"
    if [ "$([ "_${size_29545}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2630_v0=0
        return 0
    fi
    split__4_v0 "${size_29545}" " "
    local parts_29546=("${ret_split4_v0[@]}")
    local __length_533=("${parts_29546[@]}")
    if [ "$(( ${#__length_533[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2630_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29546[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29546[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_140=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2630_v0=1
    return 0
}

# query_term_size()
query_term_size__2631_v0() {
    local command_535
    command_535="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29548="${command_535}"
    store_term_size__2630_v0 "${size_29548}"
    ret_query_term_size2631_v0="${ret_store_term_size2630_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2632_v0() {
    local command_536
    command_536="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29544="${command_536}"
    store_term_size__2630_v0 "${size_29544}"
    ret_stty_term_size2632_v0="${ret_store_term_size2630_v0}"
    return 0
}

# get_term_size()
get_term_size__2633_v0() {
    stty_term_size__2632_v0 
    local detected_29547="${ret_stty_term_size2632_v0}"
    if [ "$(( ! detected_29547 ))" != 0 ]; then
        query_term_size__2631_v0 
        detected_29547="${ret_query_term_size2631_v0}"
    fi
    _got_term_size_139=1
}

# term_width()
term_width__2635_v0() {
    if [ "$(( ! _got_term_size_139 ))" != 0 ]; then
        get_term_size__2633_v0 
    fi
    ret_term_width2635_v0="${_term_size_140[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2668_v0() {
    local pending_29563="${1}"
    local line_29564="${2}"
    local note_at_29565="${3}"
    if [ "$(( note_at_29565 < 0 ))" != 0 ]; then
        local array_538=()
        printf__128_v0 "${pending_29563}""${line_29564}""
" array_538[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_29565 == 0 ))" != 0 ]; then
        colored__2589_v0 "${line_29564}" 90
        local ret_colored2589_v0__12_40="${ret_colored2589_v0}"
        local array_539=()
        printf__128_v0 "${pending_29563}""${ret_colored2589_v0__12_40}""
" array_539[@]
    else
        slice__24_v0 "${line_29564}" 0 "${note_at_29565}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_29564}" "${note_at_29565}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2589_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2589_v0__13_58="${ret_colored2589_v0}"
        local array_540=()
        printf__128_v0 "${pending_29563}""${ret_slice24_v0__13_32}""${ret_colored2589_v0__13_58}""
" array_540[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2669_v0() {
    local names_29536=("${!1}")
    local texts_29537=("${!2}")
    local notes_29538=("${!3}")
    local min_name_width_29539="${4}"
    local __length_541=("${names_29536[@]}")
    local count_29540="${#__length_541[@]}"
    local name_width_29541="${min_name_width_29539}"
    local __range_start_29542=0
    local __range_end_29542="${count_29540}"
    local __dir_29542=$(( ${__range_start_29542} <= ${__range_end_29542} ? 1 : -1 ))
    for (( i_29542=${__range_start_29542}; i_29542 * ${__dir_29542} < ${__range_end_29542} * ${__dir_29542}; i_29542+=${__dir_29542} )); do
        local __length_542="${names_29536[${i_29542}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_29543="${#__length_542}"
        if [ "$(( width_29543 > name_width_29541 ))" != 0 ]; then
            name_width_29541="${width_29543}"
        fi
done
    term_width__2635_v0 
    local width_29549="${ret_term_width2635_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_29550="$(( name_width_29541 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_29551="$(( $(( width_29549 - indent_29550 )) < 24 ))"
    if [ "${stacked_29551}" != 0 ]; then
        indent_29550=6
    fi
    local avail_29552="$(( width_29549 - indent_29550 ))"
    rpad__28_v0 "" " " "${indent_29550}"
    local blank_29553="${ret_rpad28_v0}"
    local __range_start_29554=0
    local __range_end_29554="${count_29540}"
    local __dir_29554=$(( ${__range_start_29554} <= ${__range_end_29554} ? 1 : -1 ))
    for (( i_29554=${__range_start_29554}; i_29554 * ${__dir_29554} < ${__range_end_29554} * ${__dir_29554}; i_29554+=${__dir_29554} )); do
        local pending_29555="${blank_29553}"
        if [ "${stacked_29551}" != 0 ]; then
            local array_543=()
            printf__128_v0 "  ""${names_29536[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_543[@]
        else
            rpad__28_v0 "  ""${names_29536[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_29550}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_29555="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_29537[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_29556=("${ret_split4_v0__52_21[@]}")
        local __length_544=("${words_29556[@]}")
        local note_start_29557="${#__length_544[@]}"
        if [ "$([ "_${notes_29538[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_545="${notes_29538[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_545} > avail_29552 ))" != 0 ]; then
                split__4_v0 "${notes_29538[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_29556+=("${ret_split4_v0__58_26[@]}")
            else
                local array_546=("${notes_29538[${i_29554}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_29556+=("${array_546[@]}")
            fi
        fi
        local line_29558=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_29559=-1
        local __range_start_29560=0
        local __length_547=("${words_29556[@]}")
        local __range_end_29560="${#__length_547[@]}"
        local __dir_29560=$(( ${__range_start_29560} <= ${__range_end_29560} ? 1 : -1 ))
        for (( j_29560=${__range_start_29560}; j_29560 * ${__dir_29560} < ${__range_end_29560} * ${__dir_29560}; j_29560+=${__dir_29560} )); do
            local word_29561="${words_29556[${j_29560}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_29562
            candidate_29562="$(if [ "$([ "_${line_29558}" != "_" ]; echo $?)" != 0 ]; then echo "${word_29561}"; else echo "${line_29558}"" ""${word_29561}"; fi)"
            local __length_548="${candidate_29562}"
            if [ "$(( $(( ${#__length_548} > avail_29552 )) && $([ "_${line_29558}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2668_v0 "${pending_29555}" "${line_29558}" "${note_at_29559}"
                pending_29555="${blank_29553}"
                line_29558="${word_29561}"
                note_at_29559="$(if [ "$(( j_29560 >= note_start_29557 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_29560 >= note_start_29557 )) && $(( note_at_29559 < 0 )) ))" != 0 ]; then
                    local __length_549="${candidate_29562}"
                    local __length_550="${word_29561}"
                    note_at_29559="$(( ${#__length_549} - ${#__length_550} ))"
                fi
                line_29558="${candidate_29562}"
            fi
done
        print_help_line__2668_v0 "${pending_29555}" "${line_29558}" "${note_at_29559}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2727_v0() {
    local selected_29624="${1}"
    local term_width_29625="${2}"
    local small_29626="$(( term_width_29625 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_29626}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_29640="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_29626}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_29641="${ret_cpad29_v0}"
    local gap_29642
    gap_29642="$(if [ "${small_29626}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_551=("")
    eprintf__2432_v0 " " array_551[@]
    if [ "${selected_29624}" != 0 ]; then
        # Yes selected
        background_secondary__2538_v0 "${yes_label_29640}"
        local ret_background_secondary2538_v0__16_30="${ret_background_secondary2538_v0}"
        local array_552=("")
        eprintf__2432_v0 "\\x1b[97m""${ret_background_secondary2538_v0__16_30}" array_552[@]
        local array_553=("")
        eprintf__2432_v0 "${gap_29642}" array_553[@]
        # No not selected (dim)
        local array_554=("")
        eprintf__2432_v0 "\\x1b[49;37m""${no_label_29641}""\\x1b[0m" array_554[@]
    else
        # No selected
        local array_555=("")
        eprintf__2432_v0 "\\x1b[49;37m""${yes_label_29640}""\\x1b[0m" array_555[@]
        local array_556=("")
        eprintf__2432_v0 "${gap_29642}" array_556[@]
        background_secondary__2538_v0 "${no_label_29641}"
        local ret_background_secondary2538_v0__24_30="${ret_background_secondary2538_v0}"
        local array_557=("")
        eprintf__2432_v0 "\\x1b[97m""${ret_background_secondary2538_v0__24_30}" array_557[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2728_v0() {
    local header_29577="${1}"
    local default_yes_29578="${2}"
    stty_lock__2473_v0 
    hide_cursor__2490_v0 
    term_width__2480_v0 
    local term_width_29583="${ret_term_width2480_v0}"
    if [ "$([ "_${header_29577}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2566_v0 "${header_29577}" "${term_width_29583}"
        local ret_cutoff_text2566_v0__46_17="${ret_cutoff_text2566_v0}"
        local array_558=("")
        eprintf__2432_v0 "${ret_cutoff_text2566_v0__46_17}""

" array_558[@]
    fi
    local selected_29623="${default_yes_29578}"
    # Render initial options
    render_confirm_options__2727_v0 "${selected_29623}" "${term_width_29583}"
    local array_559=("")
    eprintf__2432_v0 "

" array_559[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_560=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2593_v0 array_560[@] 40 "${term_width_29583}"
    go_up__2487_v0 2
    while :
    do
        get_key__2430_v0 
        local key_29668="${ret_get_key2430_v0}"
        if [ "$(( $(( $(( $([ "_${key_29668}" != "_LEFT" ]; echo $?) || $([ "_${key_29668}" != "_h" ]; echo $?) )) || $([ "_${key_29668}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_29668}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_29623}" != 0 ]; then
                selected_29623=0
                local array_561=("")
                eprintf__2432_v0 "\\x1b[G\\x1b[K" array_561[@]
                render_confirm_options__2727_v0 "${selected_29623}" "${term_width_29583}"
            elif [ "$(( ! selected_29623 ))" != 0 ]; then
                selected_29623=1
                local array_562=("")
                eprintf__2432_v0 "\\x1b[G\\x1b[K" array_562[@]
                render_confirm_options__2727_v0 "${selected_29623}" "${term_width_29583}"
            fi
        elif [ "$(( $([ "_${key_29668}" != "_y" ]; echo $?) || $([ "_${key_29668}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_29623=1
            break
        elif [ "$(( $([ "_${key_29668}" != "_n" ]; echo $?) || $([ "_${key_29668}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_29623=0
            break
        elif [ "$(( $([ "_${key_29668}" != "_INPUT" ]; echo $?) || $([ "_${key_29668}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_29669=4
    if [ "$([ "_${header_29577}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_29669="$(( total_lines_29669 + 1 ))"
    fi
    go_down__2488_v0 2
    remove_line__2483_v0 "$(( total_lines_29669 - 1 ))"
    remove_current_line__2484_v0 
    stty_unlock__2474_v0 
    show_cursor__2491_v0 
    ret_xyl_confirm2728_v0="${selected_29623}"
    return 0
}

# print_confirm_help()
print_confirm_help__2828_v0() {
    local usage_29504=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__2492_v0 usage_29504[@]
    printf '%s\n' ""
    colored_primary__2534_v0 "confirm"
    local ret_colored_primary2534_v0__8_20="${ret_colored_primary2534_v0}"
    local title_29531=("${ret_colored_primary2534_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__2492_v0 title_29531[@]
    printf '%s\n' ""
    colored_secondary__2535_v0 "Flags:"
    local ret_colored_secondary2535_v0__11_12="${ret_colored_secondary2535_v0}"
    local array_565=()
    printf__128_v0 "${ret_colored_secondary2535_v0__11_12}""
" array_565[@]
    local names_29533=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_29534=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_29535=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2669_v0 names_29533[@] texts_29534[@] notes_29535[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2886_v0() {
    local parameters_29487=("${!1}")
    colored_primary__2534_v0 "Are you sure?"
    local ret_colored_primary2534_v0__9_30="${ret_colored_primary2534_v0}"
    local header_29501="\\x1b[1m""${ret_colored_primary2534_v0__9_30}"
    local default_yes_29502=1
    for param_29503 in "${parameters_29487[@]}"; do
        starts_with__22_v0 "${param_29503}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_29503}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_29503}" != "_-h" ]; echo $?) || $([ "_${param_29503}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2828_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_571="--header="
            slice__24_v0 "${param_29503}" "${#__length_571}" 0
            header_29501="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_572="--default="
            slice__24_v0 "${param_29503}" "${#__length_572}" 0
            local value_29568="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_29568}" != "_yes" ]; echo $?) || $([ "_${value_29568}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_29502=1
            elif [ "$(( $([ "_${value_29568}" != "_no" ]; echo $?) || $([ "_${value_29568}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_29502=0
            else
                eprintf_colored__2433_v0 "ERROR: Invalid default value: ""${value_29568}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2558_v0 "${header_29501}"
    local ret_has_ansi_escape2558_v0__35_44="${ret_has_ansi_escape2558_v0}"
    escape_ansi__2559_v0 "${header_29501}"
    local ret_escape_ansi2559_v0__35_73="${ret_escape_ansi2559_v0}"
    colored_primary__2534_v0 "${header_29501}"
    local ret_colored_primary2534_v0__35_111="${ret_colored_primary2534_v0}"
    local display_header_29576
    display_header_29576="$(if [ "$(( $([ "_${header_29501}" != "_" ]; echo $?) || ret_has_ansi_escape2558_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2559_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary2534_v0__35_111}"; fi)"
    xyl_confirm__2728_v0 "${display_header_29576}" "${default_yes_29502}"
    local result_29675="${ret_xyl_confirm2728_v0}"
    ret_execute_confirm2886_v0="$(if [ "${result_29675}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3004_v0() {
    local format_40093="${1}"
    local args_40094=("${!2}")
    args_40094=("${format_40093}" "${args_40094[@]}")
    __status=$?
    printf "${args_40094[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3005_v0() {
    local message_40091="${1}"
    local color_40092="${2}"
    # Prints an error message with a specified color.
    local array_573=("${message_40091}")
    eprintf__3004_v0 "\\x1b[${color_40092}m%s\\x1b[0m" array_573[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3020_v0() {
    local format_40123="${1}"
    local args_40124=("${!2}")
    args_40124=("${format_40123}" "${args_40124[@]}")
    __status=$?
    printf "${args_40124[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_148="None"
# perl_available()
perl_available__3027_v0() {
    if [ "$([ "_${_perl_state_148}" != "_None" ]; echo $?)" != 0 ]; then
        local command_574
        command_574="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40033
        disabled_40033="$([ "_${command_574}" != "_No" ]; echo $?)"
        local command_575
        command_575="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40034
        found_40034="$(( $(( ! disabled_40033 )) && $([ "_${command_575}" != "_0" ]; echo $?) ))"
        _perl_state_148="$(if [ "${found_40034}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3027_v0="$([ "_${_perl_state_148}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3028_v0() {
    local text_40032="${1}"
    perl_available__3027_v0 
    local ret_perl_available3027_v0__19_12="${ret_perl_available3027_v0}"
    if [ "$(( ! ret_perl_available3027_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3028_v0=''
        return 1
    fi
    local command_576
    command_576="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40032}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3028_v0=''
        return "${__status}"
    fi
    local width_str_40035="${command_576}"
    parse_int__13_v0 "${width_str_40035}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3028_v0=''
        return "${__status}"
    fi
    local width_40036="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3028_v0="${width_40036}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3033_v0() {
    local text_40022="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_577
    command_577="$([[ "${text_40022}" == *$'\x1b'* || "${text_40022}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40023="${command_577}"
    ret_has_ansi_escape3033_v0="$([ "_${has_escape_40023}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3035_v0() {
    local text_40028="${1}"
    local command_578
    command_578="$(printf "%s" "${text_40028}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3035_v0="${command_578}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3036_v0() {
    local text_40030="${1}"
    local command_579
    command_579="$(printf "%s" "${text_40030}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40031="${command_579}"
    ret_is_all_ascii3036_v0="$([ "_${result_40031}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3037_v0() {
    local text_40025="${1}"
    local command_580
    command_580="$(LC_ALL=C; __t="${text_40025}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40026="${command_580}"
    parse_int__13_v0 "${measured_40026}"
    __status=$?
    ret_plain_len3037_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3038_v0() {
    local text_40024="${1}"
    plain_len__3037_v0 "${text_40024}"
    local plain_40027="${ret_plain_len3037_v0}"
    if [ "$(( plain_40027 >= 0 ))" != 0 ]; then
        ret_get_visible_len3038_v0="${plain_40027}"
        return 0
    fi
    strip_ansi__3035_v0 "${text_40024}"
    local stripped_40029="${ret_strip_ansi3035_v0}"
    is_all_ascii__3036_v0 "${stripped_40029}"
    local ret_is_all_ascii3036_v0__46_12="${ret_is_all_ascii3036_v0}"
    if [ "$(( ! ret_is_all_ascii3036_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3028_v0 "${stripped_40029}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_581="${stripped_40029}"
            ret_get_visible_len3038_v0="${#__length_581}"
            return 0
        fi
        ret_get_visible_len3038_v0="${ret_perl_get_cjk_width3028_v0}"
        return 0
    fi
    local __length_582="${stripped_40029}"
    ret_get_visible_len3038_v0="${#__length_582}"
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
stty_count__3044_v0() {
    local command_584
    command_584="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40099="${command_584}"
    parse_int__13_v0 "${count_40099}"
    __status=$?
    ret_stty_count3044_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3045_v0() {
    stty_count__3044_v0 
    local count_num_40100="${ret_stty_count3044_v0}"
    if [ "$(( count_num_40100 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40100="$(( count_num_40100 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40100}
    __status=$?
}

# stty_unlock()
stty_unlock__3046_v0() {
    stty_count__3044_v0 
    local count_num_40121="${ret_stty_count3044_v0}"
    if [ "$(( count_num_40121 > 0 ))" != 0 ]; then
        count_num_40121="$(( count_num_40121 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40121}
        __status=$?
        if [ "$(( count_num_40121 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3047_v0() {
    local size_40013="${1}"
    if [ "$([ "_${size_40013}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3047_v0=0
        return 0
    fi
    split__4_v0 "${size_40013}" " "
    local parts_40014=("${ret_split4_v0[@]}")
    local __length_585=("${parts_40014[@]}")
    if [ "$(( ${#__length_585[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3047_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40014[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40014[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_150=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3047_v0=1
    return 0
}

# query_term_size()
query_term_size__3048_v0() {
    local command_587
    command_587="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40016="${command_587}"
    store_term_size__3047_v0 "${size_40016}"
    ret_query_term_size3048_v0="${ret_store_term_size3047_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3049_v0() {
    local command_588
    command_588="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40012="${command_588}"
    store_term_size__3047_v0 "${size_40012}"
    ret_stty_term_size3049_v0="${ret_store_term_size3047_v0}"
    return 0
}

# get_term_size()
get_term_size__3050_v0() {
    stty_term_size__3049_v0 
    local detected_40015="${ret_stty_term_size3049_v0}"
    if [ "$(( ! detected_40015 ))" != 0 ]; then
        query_term_size__3048_v0 
        detected_40015="${ret_query_term_size3048_v0}"
    fi
    _got_term_size_149=1
}

# term_width()
term_width__3052_v0() {
    if [ "$(( ! _got_term_size_149 ))" != 0 ]; then
        get_term_size__3050_v0 
    fi
    ret_term_width3052_v0="${_term_size_150[0]?"Index out of bounds (at src/./file/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__3056_v0() {
    local array_589=("")
    eprintf__3020_v0 "\\x1b[2K\\x1b[G" array_589[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__3064_v0() {
    local pieces_40011=("${!1}")
    term_width__3052_v0 
    local width_40017="${ret_term_width3052_v0}"
    local line_40018=""
    local line_len_40019=0
    for piece_40020 in "${pieces_40011[@]}"; do
        local __length_592="${piece_40020}"
        local piece_len_40021="${#__length_592}"
        has_ansi_escape__3033_v0 "${piece_40020}"
        local ret_has_ansi_escape3033_v0__186_12="${ret_has_ansi_escape3033_v0}"
        if [ "${ret_has_ansi_escape3033_v0__186_12}" != 0 ]; then
            get_visible_len__3038_v0 "${piece_40020}"
            piece_len_40021="${ret_get_visible_len3038_v0}"
        fi
        if [ "$([ "_${line_40018}" != "_" ]; echo $?)" != 0 ]; then
            line_40018="${piece_40020}"
            line_len_40019="${piece_len_40021}"
        elif [ "$(( $(( $(( line_len_40019 + 1 )) + piece_len_40021 )) > width_40017 ))" != 0 ]; then
            local array_593=()
            printf__128_v0 "${line_40018}""
" array_593[@]
            line_40018="${piece_40020}"
            line_len_40019="${piece_len_40021}"
        else
            line_40018+=" ""${piece_40020}"
            line_len_40019="$(( line_len_40019 + $(( 1 + piece_len_40021 )) ))"
        fi
    done
    if [ "$([ "_${line_40018}" == "_" ]; echo $?)" != 0 ]; then
        local array_594=()
        printf__128_v0 "${line_40018}""
" array_594[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_151=3
# get_directory_entries(path: Text)
get_directory_entries__3086_v0() {
    local path_40104="${1}"
    local __ls_path_595="${path_40104}"
    __ls_path_595="${__ls_path_595//\\/\\\\}"
    (( 1 )) && __ls_all_595="-A" || __ls_all_595=""
    (( 0 )) && __ls_rec_595="-R" || __ls_rec_595=""
    local __ls_595=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_595 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_595} ${__ls_rec_595} ${__ls_path_595}
    __status=$?
    );
    local names_40105=("${__ls_595[@]}")
    local command_596
    command_596="$(LC_ALL=C ls -lA "${path_40104}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_40106="${command_596}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_597
    command_597="$(LC_ALL=C ls -lA "${path_40104}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_40107="${command_597}"
    split__4_v0 "${types_output_40106}" "
"
    local types_40108=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_40107}" "
"
    local targets_40109=("${ret_split4_v0[@]}")
    local entries_40110=()
    local __range_start_40111=0
    local __length_599=("${names_40105[@]}")
    local __range_end_40111="${#__length_599[@]}"
    local __dir_40111=$(( ${__range_start_40111} <= ${__range_end_40111} ? 1 : -1 ))
    for (( i_40111=${__range_start_40111}; i_40111 * ${__dir_40111} < ${__range_end_40111} * ${__dir_40111}; i_40111+=${__dir_40111} )); do
        local array_600=("${names_40105[${i_40111}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_40110+=("${array_600[@]}")
        local array_601=("${types_40108[${i_40111}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_40110+=("${array_601[@]}")
        slice__24_v0 "${targets_40109[${i_40111}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_602=("${ret_slice24_v0__31_21}")
        entries_40110+=("${array_602[@]}")
done
    ret_get_directory_entries3086_v0=("${entries_40110[@]}")
    return 0
}

# get_cwd()
get_cwd__3087_v0() {
    local command_603
    command_603="$(pwd)"
    __status=$?
    ret_get_cwd3087_v0="${command_603}"
    return 0
}

# normalize_path(path: Text)
normalize_path__3088_v0() {
    local path_40102="${1}"
    local command_604
    command_604="$(cd "${path_40102}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_40103="${command_604}"
    if [ "$([ "_${normalized_40103}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path3088_v0="${path_40102}"
        return 0
    fi
    ret_normalize_path3088_v0="${normalized_40103}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__3089_v0() {
    local base_40288="${1}"
    local child_40289="${2}"
    if [ "$([ "_${base_40288}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join3089_v0="/""${child_40289}"
        return 0
    fi
    ret_path_join3089_v0="${base_40288}""/""${child_40289}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__3090_v0() {
    local path_40286="${1}"
    local command_605
    command_605="$(dirname "${path_40286}")"
    __status=$?
    local parent_40287="${command_605}"
    ret_get_parent_dir3090_v0="${parent_40287}"
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
get_supports_truecolor__3101_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40049="${ret_env_var_get120_v0}"
    _supports_truecolor_153="$(if [ "$([ "_${config_40049}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3101_v0="$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3102_v0() {
    local message_40044="${1}"
    local r_40045="${2}"
    local g_40046="${3}"
    local b_40047="${4}"
    local fallback_40048="${5}"
    if [ "$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3102_v0="\\x1b[38;2;${r_40045};${g_40046};${b_40047}m""${message_40044}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_153}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3101_v0 
        local ret_get_supports_truecolor3101_v0__45_17="${ret_get_supports_truecolor3101_v0}"
        if [ "${ret_get_supports_truecolor3101_v0__45_17}" != 0 ]; then
            ret_colored_rgb3102_v0="\\x1b[38;2;${r_40045};${g_40046};${b_40047}m""${message_40044}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40048 == 0 ))" != 0 ]; then
            ret_colored_rgb3102_v0="${message_40044}"
            return 0
        else
            ret_colored_rgb3102_v0="\\x1b[${fallback_40048}m""${message_40044}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40048 == 0 ))" != 0 ]; then
            ret_colored_rgb3102_v0="${message_40044}"
            return 0
        fi
        ret_colored_rgb3102_v0="\\x1b[${fallback_40048}m""${message_40044}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3104_v0() {
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40038="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40038}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40038}" ";"
            local parts_40039=("${ret_split4_v0[@]}")
            local __length_609=("${parts_40039[@]}")
            if [ "$(( ${#__length_609[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40039[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40039[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40039[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40039[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_155=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40040="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40040}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40040}" ";"
            local parts_40041=("${ret_split4_v0[@]}")
            local __length_611=("${parts_40041[@]}")
            if [ "$(( ${#__length_611[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40041[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40041[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40041[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40041[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_156=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40042="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40042}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40042}" ";"
            local parts_40043=("${ret_split4_v0[@]}")
            local __length_613=("${parts_40043[@]}")
            if [ "$(( ${#__length_613[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40043[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40043[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40043[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40043[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3104_v0=''
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
get_xylitol_colors__3105_v0() {
    inner_get_xylitol_colors__3104_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_154=1
}

# colored_primary(message: Text)
colored_primary__3106_v0() {
    local message_40037="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3105_v0 
    fi
    colored_rgb__3102_v0 "${message_40037}" "${_primary_color_155[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_155[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_155[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_155[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary3106_v0="${ret_colored_rgb3102_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__3107_v0() {
    local message_40051="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3105_v0 
    fi
    colored_rgb__3102_v0 "${message_40051}" "${_secondary_color_156[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_156[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_156[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_156[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3107_v0="${ret_colored_rgb3102_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__3108_v0() {
    local message_40222="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3105_v0 
    fi
    colored_rgb__3102_v0 "${message_40222}" "${_accent_color_157[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_157[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_157[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_157[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent3108_v0="${ret_colored_rgb3102_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__3161_v0() {
    local message_40085="${1}"
    local color_40086="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3161_v0="\\x1b[${color_40086}m""${message_40085}""\\x1b[0m"
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
store_term_size__3202_v0() {
    local size_40064="${1}"
    if [ "$([ "_${size_40064}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3202_v0=0
        return 0
    fi
    split__4_v0 "${size_40064}" " "
    local parts_40065=("${ret_split4_v0[@]}")
    local __length_616=("${parts_40065[@]}")
    if [ "$(( ${#__length_616[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3202_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40065[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40065[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_162=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3202_v0=1
    return 0
}

# query_term_size()
query_term_size__3203_v0() {
    local command_618
    command_618="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40067="${command_618}"
    store_term_size__3202_v0 "${size_40067}"
    ret_query_term_size3203_v0="${ret_store_term_size3202_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3204_v0() {
    local command_619
    command_619="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40063="${command_619}"
    store_term_size__3202_v0 "${size_40063}"
    ret_stty_term_size3204_v0="${ret_store_term_size3202_v0}"
    return 0
}

# get_term_size()
get_term_size__3205_v0() {
    stty_term_size__3204_v0 
    local detected_40066="${ret_stty_term_size3204_v0}"
    if [ "$(( ! detected_40066 ))" != 0 ]; then
        query_term_size__3203_v0 
        detected_40066="${ret_query_term_size3203_v0}"
    fi
    _got_term_size_161=1
}

# term_width()
term_width__3207_v0() {
    if [ "$(( ! _got_term_size_161 ))" != 0 ]; then
        get_term_size__3205_v0 
    fi
    ret_term_width3207_v0="${_term_size_162[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__3240_v0() {
    local pending_40082="${1}"
    local line_40083="${2}"
    local note_at_40084="${3}"
    if [ "$(( note_at_40084 < 0 ))" != 0 ]; then
        local array_621=()
        printf__128_v0 "${pending_40082}""${line_40083}""
" array_621[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_40084 == 0 ))" != 0 ]; then
        colored__3161_v0 "${line_40083}" 90
        local ret_colored3161_v0__12_40="${ret_colored3161_v0}"
        local array_622=()
        printf__128_v0 "${pending_40082}""${ret_colored3161_v0__12_40}""
" array_622[@]
    else
        slice__24_v0 "${line_40083}" 0 "${note_at_40084}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_40083}" "${note_at_40084}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__3161_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored3161_v0__13_58="${ret_colored3161_v0}"
        local array_623=()
        printf__128_v0 "${pending_40082}""${ret_slice24_v0__13_32}""${ret_colored3161_v0__13_58}""
" array_623[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__3241_v0() {
    local names_40055=("${!1}")
    local texts_40056=("${!2}")
    local notes_40057=("${!3}")
    local min_name_width_40058="${4}"
    local __length_624=("${names_40055[@]}")
    local count_40059="${#__length_624[@]}"
    local name_width_40060="${min_name_width_40058}"
    local __range_start_40061=0
    local __range_end_40061="${count_40059}"
    local __dir_40061=$(( ${__range_start_40061} <= ${__range_end_40061} ? 1 : -1 ))
    for (( i_40061=${__range_start_40061}; i_40061 * ${__dir_40061} < ${__range_end_40061} * ${__dir_40061}; i_40061+=${__dir_40061} )); do
        local __length_625="${names_40055[${i_40061}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_40062="${#__length_625}"
        if [ "$(( width_40062 > name_width_40060 ))" != 0 ]; then
            name_width_40060="${width_40062}"
        fi
done
    term_width__3207_v0 
    local width_40068="${ret_term_width3207_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_40069="$(( name_width_40060 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_40070="$(( $(( width_40068 - indent_40069 )) < 24 ))"
    if [ "${stacked_40070}" != 0 ]; then
        indent_40069=6
    fi
    local avail_40071="$(( width_40068 - indent_40069 ))"
    rpad__28_v0 "" " " "${indent_40069}"
    local blank_40072="${ret_rpad28_v0}"
    local __range_start_40073=0
    local __range_end_40073="${count_40059}"
    local __dir_40073=$(( ${__range_start_40073} <= ${__range_end_40073} ? 1 : -1 ))
    for (( i_40073=${__range_start_40073}; i_40073 * ${__dir_40073} < ${__range_end_40073} * ${__dir_40073}; i_40073+=${__dir_40073} )); do
        local pending_40074="${blank_40072}"
        if [ "${stacked_40070}" != 0 ]; then
            local array_626=()
            printf__128_v0 "  ""${names_40055[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_626[@]
        else
            rpad__28_v0 "  ""${names_40055[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_40069}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_40074="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_40056[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_40075=("${ret_split4_v0__52_21[@]}")
        local __length_627=("${words_40075[@]}")
        local note_start_40076="${#__length_627[@]}"
        if [ "$([ "_${notes_40057[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_628="${notes_40057[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_628} > avail_40071 ))" != 0 ]; then
                split__4_v0 "${notes_40057[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_40075+=("${ret_split4_v0__58_26[@]}")
            else
                local array_629=("${notes_40057[${i_40073}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_40075+=("${array_629[@]}")
            fi
        fi
        local line_40077=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_40078=-1
        local __range_start_40079=0
        local __length_630=("${words_40075[@]}")
        local __range_end_40079="${#__length_630[@]}"
        local __dir_40079=$(( ${__range_start_40079} <= ${__range_end_40079} ? 1 : -1 ))
        for (( j_40079=${__range_start_40079}; j_40079 * ${__dir_40079} < ${__range_end_40079} * ${__dir_40079}; j_40079+=${__dir_40079} )); do
            local word_40080="${words_40075[${j_40079}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_40081
            candidate_40081="$(if [ "$([ "_${line_40077}" != "_" ]; echo $?)" != 0 ]; then echo "${word_40080}"; else echo "${line_40077}"" ""${word_40080}"; fi)"
            local __length_631="${candidate_40081}"
            if [ "$(( $(( ${#__length_631} > avail_40071 )) && $([ "_${line_40077}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__3240_v0 "${pending_40074}" "${line_40077}" "${note_at_40078}"
                pending_40074="${blank_40072}"
                line_40077="${word_40080}"
                note_at_40078="$(if [ "$(( j_40079 >= note_start_40076 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_40079 >= note_start_40076 )) && $(( note_at_40078 < 0 )) ))" != 0 ]; then
                    local __length_632="${candidate_40081}"
                    local __length_633="${word_40080}"
                    note_at_40078="$(( ${#__length_632} - ${#__length_633} ))"
                fi
                line_40077="${candidate_40081}"
            fi
done
        print_help_line__3240_v0 "${pending_40074}" "${line_40077}" "${note_at_40078}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__3344_v0() {
    local command_634
    command_634="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key3344_v0="${command_634}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3346_v0() {
    local format_40183="${1}"
    local args_40184=("${!2}")
    args_40184=("${format_40183}" "${args_40184[@]}")
    __status=$?
    printf "${args_40184[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3347_v0() {
    local message_40190="${1}"
    local color_40191="${2}"
    # Prints an error message with a specified color.
    local array_635=("${message_40190}")
    eprintf__3346_v0 "\\x1b[${color_40191}m%s\\x1b[0m" array_635[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3362_v0() {
    local format_40133="${1}"
    local args_40134=("${!2}")
    args_40134=("${format_40133}" "${args_40134[@]}")
    __status=$?
    printf "${args_40134[@]}" >&2
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
stty_count__3386_v0() {
    local command_637
    command_637="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40131="${command_637}"
    parse_int__13_v0 "${count_40131}"
    __status=$?
    ret_stty_count3386_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3387_v0() {
    stty_count__3386_v0 
    local count_num_40132="${ret_stty_count3386_v0}"
    if [ "$(( count_num_40132 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 < /dev/tty
        __status=$?
    fi
    count_num_40132="$(( count_num_40132 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40132}
    __status=$?
}

# stty_unlock()
stty_unlock__3388_v0() {
    stty_count__3386_v0 
    local count_num_40283="${ret_stty_count3386_v0}"
    if [ "$(( count_num_40283 > 0 ))" != 0 ]; then
        count_num_40283="$(( count_num_40283 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40283}
        __status=$?
        if [ "$(( count_num_40283 == 0 ))" != 0 ]; then
            stty echo icanon < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3389_v0() {
    local size_40136="${1}"
    if [ "$([ "_${size_40136}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3389_v0=0
        return 0
    fi
    split__4_v0 "${size_40136}" " "
    local parts_40137=("${ret_split4_v0[@]}")
    local __length_638=("${parts_40137[@]}")
    if [ "$(( ${#__length_638[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3389_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40137[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40137[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_170=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size3389_v0=1
    return 0
}

# query_term_size()
query_term_size__3390_v0() {
    local command_640
    command_640="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40139="${command_640}"
    store_term_size__3389_v0 "${size_40139}"
    ret_query_term_size3390_v0="${ret_store_term_size3389_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3391_v0() {
    local command_641
    command_641="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40135="${command_641}"
    store_term_size__3389_v0 "${size_40135}"
    ret_stty_term_size3391_v0="${ret_store_term_size3389_v0}"
    return 0
}

# get_term_size()
get_term_size__3392_v0() {
    stty_term_size__3391_v0 
    local detected_40138="${ret_stty_term_size3391_v0}"
    if [ "$(( ! detected_40138 ))" != 0 ]; then
        query_term_size__3390_v0 
        detected_40138="${ret_query_term_size3390_v0}"
    fi
    _got_term_size_169=1
}

# term_width()
term_width__3394_v0() {
    if [ "$(( ! _got_term_size_169 ))" != 0 ]; then
        get_term_size__3392_v0 
    fi
    ret_term_width3394_v0="${_term_size_170[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__3395_v0() {
    if [ "$(( ! _got_term_size_169 ))" != 0 ]; then
        get_term_size__3392_v0 
    fi
    ret_term_height3395_v0="${_term_size_170[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__3397_v0() {
    local cnt_40254="${1}"
    if [ "$(( cnt_40254 > 0 ))" != 0 ]; then
        local sequence_40255=""
        local __range_start_40256=0
        local __range_end_40256="${cnt_40254}"
        local __dir_40256=$(( ${__range_start_40256} <= ${__range_end_40256} ? 1 : -1 ))
        for (( ____40256=${__range_start_40256}; ____40256 * ${__dir_40256} < ${__range_end_40256} * ${__dir_40256}; ____40256+=${__dir_40256} )); do
            sequence_40255+="\\x1b[2K\\x1b[1A"
done
        local array_642=("")
        eprintf__3362_v0 "${sequence_40255}" array_642[@]
    fi
    local array_643=("")
    eprintf__3362_v0 "\\x1b[G" array_643[@]
}

# remove_current_line()
remove_current_line__3398_v0() {
    local array_644=("")
    eprintf__3362_v0 "\\x1b[2K\\x1b[G" array_644[@]
}

# print_blank(cnt: Int)
print_blank__3399_v0() {
    local cnt_40245="${1}"
    printf '%*s' "${cnt_40245}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__3400_v0() {
    local cnt_40188="${1}"
    local __range_start_40189=0
    local __range_end_40189="${cnt_40188}"
    local __dir_40189=$(( ${__range_start_40189} <= ${__range_end_40189} ? 1 : -1 ))
    for (( ____40189=${__range_start_40189}; ____40189 * ${__dir_40189} < ${__range_end_40189} * ${__dir_40189}; ____40189+=${__dir_40189} )); do
        local array_645=("")
        eprintf__3362_v0 "
" array_645[@]
done
}

# go_up(cnt: Int)
go_up__3401_v0() {
    local cnt_40211="${1}"
    local array_646=("")
    eprintf__3362_v0 "\\x1b[${cnt_40211}A" array_646[@]
}

# go_down(cnt: Int)
go_down__3402_v0() {
    local cnt_40282="${1}"
    local array_647=("")
    eprintf__3362_v0 "\\x1b[${cnt_40282}B" array_647[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__3404_v0() {
    local array_648=("")
    eprintf__3362_v0 "\\x1b[?25l" array_648[@]
}

# show_cursor()
show_cursor__3405_v0() {
    local array_649=("")
    eprintf__3362_v0 "\\x1b[?25h" array_649[@]
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
get_supports_truecolor__3443_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40244="${ret_env_var_get120_v0}"
    _supports_truecolor_173="$(if [ "$([ "_${config_40244}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3443_v0="$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3444_v0() {
    local message_40239="${1}"
    local r_40240="${2}"
    local g_40241="${3}"
    local b_40242="${4}"
    local fallback_40243="${5}"
    if [ "$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3444_v0="\\x1b[38;2;${r_40240};${g_40241};${b_40242}m""${message_40239}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_173}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3443_v0 
        local ret_get_supports_truecolor3443_v0__45_17="${ret_get_supports_truecolor3443_v0}"
        if [ "${ret_get_supports_truecolor3443_v0__45_17}" != 0 ]; then
            ret_colored_rgb3444_v0="\\x1b[38;2;${r_40240};${g_40241};${b_40242}m""${message_40239}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40243 == 0 ))" != 0 ]; then
            ret_colored_rgb3444_v0="${message_40239}"
            return 0
        else
            ret_colored_rgb3444_v0="\\x1b[${fallback_40243}m""${message_40239}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40243 == 0 ))" != 0 ]; then
            ret_colored_rgb3444_v0="${message_40239}"
            return 0
        fi
        ret_colored_rgb3444_v0="\\x1b[${fallback_40243}m""${message_40239}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3446_v0() {
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40233="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40233}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40233}" ";"
            local parts_40234=("${ret_split4_v0[@]}")
            local __length_653=("${parts_40234[@]}")
            if [ "$(( ${#__length_653[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40234[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40234[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40234[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40234[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40235="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40235}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40235}" ";"
            local parts_40236=("${ret_split4_v0[@]}")
            local __length_655=("${parts_40236[@]}")
            if [ "$(( ${#__length_655[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40236[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40236[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40236[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40236[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_176=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40237="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40237}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40237}" ";"
            local parts_40238=("${ret_split4_v0[@]}")
            local __length_657=("${parts_40238[@]}")
            if [ "$(( ${#__length_657[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40238[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40238[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40238[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40238[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3446_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_174=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3447_v0() {
    inner_get_xylitol_colors__3446_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_174=1
}

# colored_secondary(message: Text)
colored_secondary__3449_v0() {
    local message_40232="${1}"
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        get_xylitol_colors__3447_v0 
    fi
    colored_rgb__3444_v0 "${message_40232}" "${_secondary_color_176[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_176[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_176[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_176[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3449_v0="${ret_colored_rgb3444_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_178="None"
# perl_available()
perl_available__3466_v0() {
    if [ "$([ "_${_perl_state_178}" != "_None" ]; echo $?)" != 0 ]; then
        local command_659
        command_659="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40153
        disabled_40153="$([ "_${command_659}" != "_No" ]; echo $?)"
        local command_660
        command_660="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40154
        found_40154="$(( $(( ! disabled_40153 )) && $([ "_${command_660}" != "_0" ]; echo $?) ))"
        _perl_state_178="$(if [ "${found_40154}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3466_v0="$([ "_${_perl_state_178}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3467_v0() {
    local text_40152="${1}"
    perl_available__3466_v0 
    local ret_perl_available3466_v0__19_12="${ret_perl_available3466_v0}"
    if [ "$(( ! ret_perl_available3466_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3467_v0=''
        return 1
    fi
    local command_661
    command_661="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40152}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3467_v0=''
        return "${__status}"
    fi
    local width_str_40155="${command_661}"
    parse_int__13_v0 "${width_str_40155}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3467_v0=''
        return "${__status}"
    fi
    local width_40156="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3467_v0="${width_40156}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__3468_v0() {
    local text_40165="${1}"
    local max_width_40166="${2}"
    perl_available__3466_v0 
    local ret_perl_available3466_v0__30_12="${ret_perl_available3466_v0}"
    if [ "$(( ! ret_perl_available3466_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk3468_v0=''
        return 1
    fi
    local command_662
    command_662="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_40165}" ${max_width_40166} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk3468_v0=''
        return "${__status}"
    fi
    local result_40167="${command_662}"
    ret_perl_truncate_cjk3468_v0="${result_40167}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3472_v0() {
    local text_40160="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_663
    command_663="$([[ "${text_40160}" == *$'\x1b'* || "${text_40160}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40161="${command_663}"
    ret_has_ansi_escape3472_v0="$([ "_${has_escape_40161}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3474_v0() {
    local text_40148="${1}"
    local command_664
    command_664="$(printf "%s" "${text_40148}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3474_v0="${command_664}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3475_v0() {
    local text_40150="${1}"
    local command_665
    command_665="$(printf "%s" "${text_40150}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40151="${command_665}"
    ret_is_all_ascii3475_v0="$([ "_${result_40151}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3476_v0() {
    local text_40145="${1}"
    local command_666
    command_666="$(LC_ALL=C; __t="${text_40145}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40146="${command_666}"
    parse_int__13_v0 "${measured_40146}"
    __status=$?
    ret_plain_len3476_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3477_v0() {
    local text_40144="${1}"
    plain_len__3476_v0 "${text_40144}"
    local plain_40147="${ret_plain_len3476_v0}"
    if [ "$(( plain_40147 >= 0 ))" != 0 ]; then
        ret_get_visible_len3477_v0="${plain_40147}"
        return 0
    fi
    strip_ansi__3474_v0 "${text_40144}"
    local stripped_40149="${ret_strip_ansi3474_v0}"
    is_all_ascii__3475_v0 "${stripped_40149}"
    local ret_is_all_ascii3475_v0__46_12="${ret_is_all_ascii3475_v0}"
    if [ "$(( ! ret_is_all_ascii3475_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3467_v0 "${stripped_40149}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_667="${stripped_40149}"
            ret_get_visible_len3477_v0="${#__length_667}"
            return 0
        fi
        ret_get_visible_len3477_v0="${ret_perl_get_cjk_width3467_v0}"
        return 0
    fi
    local __length_668="${stripped_40149}"
    ret_get_visible_len3477_v0="${#__length_668}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__3478_v0() {
    local text_40162="${1}"
    local max_width_40163="${2}"
    get_visible_len__3477_v0 "${text_40162}"
    local visible_len_40164="${ret_get_visible_len3477_v0}"
    if [ "$(( visible_len_40164 <= max_width_40163 ))" != 0 ]; then
        ret_truncate_text3478_v0="${text_40162}"
        return 0
    fi
    is_all_ascii__3475_v0 "${text_40162}"
    local ret_is_all_ascii3475_v0__61_12="${ret_is_all_ascii3475_v0}"
    if [ "$(( ! ret_is_all_ascii3475_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__3468_v0 "${text_40162}" "${max_width_40163}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_40162}" | cut -c1-${max_width_40163}
            __status=$?
        fi
        ret_truncate_text3478_v0="${ret_perl_truncate_cjk3468_v0}"
        return 0
    fi
    local command_669
    command_669="$(printf "%s" "${text_40162}" | cut -c1-${max_width_40163})"
    __status=$?
    ret_truncate_text3478_v0="${command_669}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__3479_v0() {
    local text_40158="${1}"
    local max_width_40159="${2}"
    has_ansi_escape__3472_v0 "${text_40158}"
    local ret_has_ansi_escape3472_v0__73_12="${ret_has_ansi_escape3472_v0}"
    if [ "$(( ! ret_has_ansi_escape3472_v0__73_12 ))" != 0 ]; then
        truncate_text__3478_v0 "${text_40158}" "${max_width_40159}"
        ret_truncate_ansi3479_v0="${ret_truncate_text3478_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_670
    command_670="$([[ "${text_40158}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_40168="${command_670}"
    # Replace \x1b[ with newline, then split
    local command_671
    command_671="$(t="${text_40158}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_40169="${command_671}"
    split__4_v0 "${replaced_40169}" "
"
    local parts_40170=("${ret_split4_v0[@]}")
    local result_40171=""
    local remaining_width_40172="${max_width_40159}"
    local __range_start_40173=0
    local __length_672=("${parts_40170[@]}")
    local __range_end_40173="${#__length_672[@]}"
    local __dir_40173=$(( ${__range_start_40173} <= ${__range_end_40173} ? 1 : -1 ))
    for (( idx_40173=${__range_start_40173}; idx_40173 * ${__dir_40173} < ${__range_end_40173} * ${__dir_40173}; idx_40173+=${__dir_40173} )); do
        local part_40174="${parts_40170[${idx_40173}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_40173 == 0 )) && $([ "_${starts_with_ansi_40168}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_40174}" == "_" ]; echo $?) && $(( remaining_width_40172 > 0 )) ))" != 0 ]; then
                truncate_text__3478_v0 "${part_40174}" "${remaining_width_40172}"
                local ret_truncate_text3478_v0__95_35="${ret_truncate_text3478_v0}"
                local truncated_40175="${ret_truncate_text3478_v0__95_35}"
                result_40171+="${truncated_40175}"
                get_visible_len__3477_v0 "${truncated_40175}"
                local ret_get_visible_len3477_v0__97_36="${ret_get_visible_len3477_v0}"
                remaining_width_40172="$(( remaining_width_40172 - ret_get_visible_len3477_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_673
            command_673="$(__p="${part_40174}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_40176="${command_673}"
            if [ "$([ "_${m_idx_40176}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_674
                command_674="$(__p="${part_40174}"; printf "%s" "${__p:0:${m_idx_40176}}")"
                __status=$?
                local ansi_params_40177="${command_674}"
                result_40171+="\\x1b[""${ansi_params_40177}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_40176}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_40178="${ret_parse_int13_v0__108_41}"
                local text_start_40179="$(( m_idx_num_40178 + 1 ))"
                local command_675
                command_675="$(__p="${part_40174}"; printf "%s" "${__p:${text_start_40179}}")"
                __status=$?
                local text_part_40180="${command_675}"
                if [ "$(( $([ "_${text_part_40180}" == "_" ]; echo $?) && $(( remaining_width_40172 > 0 )) ))" != 0 ]; then
                    truncate_text__3478_v0 "${text_part_40180}" "${remaining_width_40172}"
                    local ret_truncate_text3478_v0__112_39="${ret_truncate_text3478_v0}"
                    local truncated_40181="${ret_truncate_text3478_v0__112_39}"
                    result_40171+="${truncated_40181}"
                    get_visible_len__3477_v0 "${truncated_40181}"
                    local ret_get_visible_len3477_v0__114_40="${ret_get_visible_len3477_v0}"
                    remaining_width_40172="$(( remaining_width_40172 - ret_get_visible_len3477_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_40174}" == "_" ]; echo $?) && $(( remaining_width_40172 > 0 )) ))" != 0 ]; then
                    truncate_text__3478_v0 "${part_40174}" "${remaining_width_40172}"
                    local ret_truncate_text3478_v0__119_39="${ret_truncate_text3478_v0}"
                    local truncated_40182="${ret_truncate_text3478_v0__119_39}"
                    result_40171+="${truncated_40182}"
                    get_visible_len__3477_v0 "${truncated_40182}"
                    local ret_get_visible_len3477_v0__121_40="${ret_get_visible_len3477_v0}"
                    remaining_width_40172="$(( remaining_width_40172 - ret_get_visible_len3477_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi3479_v0="${result_40171}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__3480_v0() {
    local text_40142="${1}"
    local max_width_40143="${2}"
    get_visible_len__3477_v0 "${text_40142}"
    local visible_len_40157="${ret_get_visible_len3477_v0}"
    if [ "$(( visible_len_40157 <= max_width_40143 ))" != 0 ]; then
        ret_cutoff_text3480_v0="${text_40142}"
        return 0
    fi
    truncate_ansi__3479_v0 "${text_40142}" "$(( max_width_40143 - 3 ))"
    local ret_truncate_ansi3479_v0__137_12="${ret_truncate_ansi3479_v0}"
    ret_cutoff_text3480_v0="${ret_truncate_ansi3479_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__3501_v0() {
    local format_40200="${1}"
    local args_40201=("${!2}")
    args_40201=("${format_40200}" "${args_40201[@]}")
    __status=$?
    printf "${args_40201[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3502_v0() {
    local message_40198="${1}"
    local color_40199="${2}"
    # Prints an error message with a specified color.
    local array_676=("${message_40198}")
    eprintf__3501_v0 "\\x1b[${color_40199}m%s\\x1b[0m" array_676[@]
}

# colored(message: Text, color: Int)
colored__3503_v0() {
    local message_40202="${1}"
    local color_40203="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3503_v0="\\x1b[${color_40203}m""${message_40202}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__3507_v0() {
    local items_40192=("${!1}")
    local total_len_40193="${2}"
    local term_width_40194="${3}"
    local separator_40195=" • "
    local separator_len_40196=3
    # Fast path: no truncation needed
    if [ "$(( total_len_40193 <= term_width_40194 ))" != 0 ]; then
        local iter_40197=0
        while :
        do
            local __length_677=("${items_40192[@]}")
            if [ "$(( iter_40197 >= ${#__length_677[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_40197 > 0 ))" != 0 ]; then
                eprintf_colored__3502_v0 "${separator_40195}" 90
            fi
            colored__3503_v0 "${items_40192[$(( iter_40197 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored3503_v0__23_41="${ret_colored3503_v0}"
            local array_678=("")
            eprintf__3501_v0 "${items_40192[${iter_40197}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored3503_v0__23_41}" array_678[@]
            iter_40197="$(( iter_40197 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_40204=0
        local first_40205=1
        local iter_40206=0
        while :
        do
            local __length_679=("${items_40192[@]}")
            if [ "$(( iter_40206 >= ${#__length_679[@]} ))" != 0 ]; then
                break
            fi
            local key_40207="${items_40192[${iter_40206}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_40208="${items_40192[$(( iter_40206 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_680="${key_40207}"
            local __length_681="${action_40208}"
            local part_len_40209="$(( $(( ${#__length_680} + 1 )) + ${#__length_681} ))"
            local needed_40210="${part_len_40209}"
            if [ "$(( ! first_40205 ))" != 0 ]; then
                needed_40210="$(( needed_40210 + separator_len_40196 ))"
            fi
            if [ "$(( $(( current_len_40204 + needed_40210 )) > term_width_40194 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_40205 ))" != 0 ]; then
                eprintf_colored__3502_v0 "${separator_40195}" 90
            fi
            colored__3503_v0 "${action_40208}" 2
            local ret_colored3503_v0__51_33="${ret_colored3503_v0}"
            local array_682=("")
            eprintf__3501_v0 "${key_40207}"" ""${ret_colored3503_v0__51_33}" array_682[@]
            current_len_40204="$(( current_len_40204 + needed_40210 ))"
            first_40205=0
            iter_40206="$(( iter_40206 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__3517_v0() {
    local format_40270="${1}"
    local args_40271=("${!2}")
    args_40271=("${format_40270}" "${args_40271[@]}")
    __status=$?
    printf "${args_40271[@]}" >&2
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
go_up__3556_v0() {
    local cnt_40269="${1}"
    local array_684=("")
    eprintf__3517_v0 "\\x1b[${cnt_40269}A" array_684[@]
}

# go_down(cnt: Int)
go_down__3557_v0() {
    local cnt_40272="${1}"
    local array_685=("")
    eprintf__3517_v0 "\\x1b[${cnt_40272}B" array_685[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3564_v0() {
    local display_count_40266="${1}"
    local index_40267="${2}"
    local line_40268="${3}"
    go_up__3556_v0 "$(( display_count_40266 - index_40267 ))"
    local array_686=("")
    eprintf__3501_v0 "\\x1b[G\\x1b[K" array_686[@]
    local array_687=("")
    eprintf__3501_v0 "${line_40268}" array_687[@]
    go_down__3557_v0 "$(( display_count_40266 - index_40267 ))"
    local array_688=("")
    eprintf__3501_v0 "\\x1b[G" array_688[@]
}

# Which items of a multi-select widget are ticked.
_checked_183=()
_count_184=0
_total_185=0
_limit_186=-1
# checked_init(total: Int, limit: Int)
checked_init__3566_v0() {
    local total_40185="${1}"
    local limit_40186="${2}"
    _checked_183=()
    local __range_start_40187=0
    local __range_end_40187="${total_40185}"
    local __dir_40187=$(( ${__range_start_40187} <= ${__range_end_40187} ? 1 : -1 ))
    for (( ____40187=${__range_start_40187}; ____40187 * ${__dir_40187} < ${__range_end_40187} * ${__dir_40187}; ____40187+=${__dir_40187} )); do
        local array_691=(0)
        _checked_183+=("${array_691[@]}")
done
    _count_184=0
    _total_185="${total_40185}"
    _limit_186="${limit_40186}"
}

# checked_is(index: Int)
checked_is__3567_v0() {
    local index_40229="${1}"
    ret_checked_is3567_v0="${_checked_183[${index_40229}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3569_v0() {
    local index_40261="${1}"
    if [ "${_checked_183[${index_40261}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_183["${index_40261}"]=0
        _count_184="$(( _count_184 - 1 ))"
        ret_checked_toggle3569_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_186 >= 0 )) && $(( _count_184 >= _limit_186 )) ))" != 0 ]; then
        ret_checked_toggle3569_v0=0
        return 0
    fi
    _checked_183["${index_40261}"]=1
    _count_184="$(( _count_184 + 1 ))"
    ret_checked_toggle3569_v0=1
    return 0
}

# checked_all()
checked_all__3570_v0() {
    if [ "$(( _limit_186 >= 0 ))" != 0 ]; then
        ret_checked_all3570_v0=0
        return 0
    fi
    local was_all_40273="$(( _count_184 == _total_185 ))"
    local __range_start_40274=0
    local __range_end_40274="${_total_185}"
    local __dir_40274=$(( ${__range_start_40274} <= ${__range_end_40274} ? 1 : -1 ))
    for (( i_40274=${__range_start_40274}; i_40274 * ${__dir_40274} < ${__range_end_40274} * ${__dir_40274}; i_40274+=${__dir_40274} )); do
        _checked_183["${i_40274}"]="$(( ! was_all_40273 ))"
done
    if [ "${was_all_40273}" != 0 ]; then
        _count_184=0
    else
        _count_184="${_total_185}"
    fi
    ret_checked_all3570_v0=1
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
render_single_page__3641_v0() {
    local __length_693="${_cursor_197}"
    local cursor_len_40248="${#__length_693}"
    local max_option_width_40249="$(( $(( _term_width_200 - cursor_len_40248 )) - 1 ))"
    local __range_start_40250=0
    local __range_end_40250="${_page_count_203}"
    local __dir_40250=$(( ${__range_start_40250} <= ${__range_end_40250} ? 1 : -1 ))
    for (( i_40250=${__range_start_40250}; i_40250 * ${__dir_40250} < ${__range_end_40250} * ${__dir_40250}; i_40250+=${__dir_40250} )); do
        cutoff_text__3480_v0 "${_page_202[${i_40250}]?"Index out of bounds (at src/./file/../choose/engine.ab:44:45)"}" "${max_option_width_40249}"
        local ret_cutoff_text3480_v0__44_27="${ret_cutoff_text3480_v0}"
        local truncated_40251="${ret_cutoff_text3480_v0__44_27}"
        if [ "$(( i_40250 == _selected_196 ))" != 0 ]; then
            colored_secondary__3449_v0 "${_cursor_197}""${truncated_40251}""
"
            local ret_colored_secondary3449_v0__46_21="${ret_colored_secondary3449_v0}"
            local array_694=("")
            eprintf__3346_v0 "${ret_colored_secondary3449_v0__46_21}" array_694[@]
        else
            print_blank__3399_v0 "${cursor_len_40248}"
            local array_695=("")
            eprintf__3346_v0 "${truncated_40251}""
" array_695[@]
        fi
done
    local remaining_slots_40252="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40252 > 0 ))" != 0 ]; then
        local __range_start_40253=0
        local __range_end_40253="${remaining_slots_40252}"
        local __dir_40253=$(( ${__range_start_40253} <= ${__range_end_40253} ? 1 : -1 ))
        for (( ____40253=${__range_start_40253}; ____40253 * ${__dir_40253} < ${__range_end_40253} * ${__dir_40253}; ____40253+=${__dir_40253} )); do
            local array_696=("")
            eprintf__3346_v0 "\\x1b[K
" array_696[@]
done
    fi
}

# render_multi_page()
render_multi_page__3642_v0() {
    local __length_697="${_cursor_197}"
    local cursor_len_40224="${#__length_697}"
    local max_option_width_40225="$(( $(( _term_width_200 - cursor_len_40224 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3647_v0 
    local page_start_40226="${ret_chooser_page_start3647_v0}"
    local __range_start_40227=0
    local __range_end_40227="${_page_count_203}"
    local __dir_40227=$(( ${__range_start_40227} <= ${__range_end_40227} ? 1 : -1 ))
    for (( i_40227=${__range_start_40227}; i_40227 * ${__dir_40227} < ${__range_end_40227} * ${__dir_40227}; i_40227+=${__dir_40227} )); do
        local global_idx_40228="$(( page_start_40226 + i_40227 ))"
        checked_is__3567_v0 "${global_idx_40228}"
        local ret_checked_is3567_v0__66_28="${ret_checked_is3567_v0}"
        local check_mark_40230
        check_mark_40230="$(if [ "${ret_checked_is3567_v0__66_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__3480_v0 "${_page_202[${i_40227}]?"Index out of bounds (at src/./file/../choose/engine.ab:67:45)"}" "${max_option_width_40225}"
        local ret_cutoff_text3480_v0__67_27="${ret_cutoff_text3480_v0}"
        local truncated_40231="${ret_cutoff_text3480_v0__67_27}"
        checked_is__3567_v0 "${global_idx_40228}"
        local ret_checked_is3567_v0__70_13="${ret_checked_is3567_v0}"
        if [ "$(( i_40227 == _selected_196 ))" != 0 ]; then
            colored_secondary__3449_v0 "${_cursor_197}""${check_mark_40230}""${truncated_40231}""
"
            local ret_colored_secondary3449_v0__69_37="${ret_colored_secondary3449_v0}"
            local array_698=("")
            eprintf__3346_v0 "${ret_colored_secondary3449_v0__69_37}" array_698[@]
        elif [ "${ret_checked_is3567_v0__70_13}" != 0 ]; then
            print_blank__3399_v0 "${cursor_len_40224}"
            colored_secondary__3449_v0 "${check_mark_40230}""${truncated_40231}""
"
            local ret_colored_secondary3449_v0__72_25="${ret_colored_secondary3449_v0}"
            local array_699=("")
            eprintf__3346_v0 "${ret_colored_secondary3449_v0__72_25}" array_699[@]
        else
            print_blank__3399_v0 "${cursor_len_40224}"
            local array_700=("")
            eprintf__3346_v0 "${check_mark_40230}""${truncated_40231}""
" array_700[@]
        fi
done
    local remaining_slots_40246="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40246 > 0 ))" != 0 ]; then
        local __range_start_40247=0
        local __range_end_40247="${remaining_slots_40246}"
        local __dir_40247=$(( ${__range_start_40247} <= ${__range_end_40247} ? 1 : -1 ))
        for (( ____40247=${__range_start_40247}; ____40247 * ${__dir_40247} < ${__range_end_40247} * ${__dir_40247}; ____40247+=${__dir_40247} )); do
            local array_701=("")
            eprintf__3346_v0 "\\x1b[K
" array_701[@]
done
    fi
}

# render_page()
render_page__3643_v0() {
    if [ "${_multi_198}" != 0 ]; then
        render_multi_page__3642_v0 
    else
        render_single_page__3641_v0 
    fi
}

# render_page_indicator()
render_page_indicator__3644_v0() {
    if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
        local array_702=("")
        eprintf__3346_v0 "\\x1b[G\\x1b[K" array_702[@]
        eprintf_colored__3347_v0 "Page $(( _current_page_195 + 1 ))/${_total_pages_194}" 90
        local array_703=("")
        eprintf__3346_v0 "\\x1b[G" array_703[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__3645_v0() {
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
            local array_704=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__3507_v0 array_704[@] 36 "${_term_width_200}"
        else
            local array_705=("↑↓" "select" "enter" "confirm")
            render_tooltip__3507_v0 array_705[@] 25 "${_term_width_200}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_194 > 1 )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
            local array_706=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__3507_v0 array_706[@] 55 "${_term_width_200}"
        elif [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
            local array_707=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__3507_v0 array_707[@] 47 "${_term_width_200}"
        elif [ "$(( _limit_199 < 0 ))" != 0 ]; then
            local array_708=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__3507_v0 array_708[@] 44 "${_term_width_200}"
        else
            local array_709=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__3507_v0 array_709[@] 36 "${_term_width_200}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__3646_v0() {
    local total_40125="${1}"
    local page_size_40126="${2}"
    local header_40127="${3}"
    local cursor_40128="${4}"
    local multi_40129="${5}"
    local limit_40130="${6}"
    _total_191="${total_40125}"
    _cursor_197="${cursor_40128}"
    _multi_198="${multi_40129}"
    _limit_199="${limit_40130}"
    _current_page_195=0
    _selected_196=0
    _first_render_204=1
    _up_paged_205=0
    _has_header_201="$([ "_${header_40127}" == "_" ]; echo $?)"
    stty_lock__3387_v0 
    hide_cursor__3404_v0 
    term_width__3394_v0 
    _term_width_200="${ret_term_width3394_v0}"
    term_height__3395_v0 
    local term_height_40140="${ret_term_height3395_v0}"
    local max_page_size_40141
    max_page_size_40141="$(( term_height_40140 - $(if [ "${_has_header_201}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_192="${page_size_40126}"
    if [ "$(( _page_size_192 > max_page_size_40141 ))" != 0 ]; then
        _page_size_192="${max_page_size_40141}"
    fi
    if [ "${_has_header_201}" != 0 ]; then
        cutoff_text__3480_v0 "${header_40127}" "${_term_width_200}"
        local ret_cutoff_text3480_v0__152_17="${ret_cutoff_text3480_v0}"
        local array_710=("")
        eprintf__3346_v0 "${ret_cutoff_text3480_v0__152_17}""
" array_710[@]
    fi
    _total_pages_194="$(( $(( $(( total_40125 + _page_size_192 )) - 1 )) / _page_size_192 ))"
    _display_count_193="${_page_size_192}"
    if [ "$(( total_40125 < _page_size_192 ))" != 0 ]; then
        _display_count_193="${total_40125}"
    fi
    if [ "${multi_40129}" != 0 ]; then
        checked_init__3566_v0 "${total_40125}" "${limit_40130}"
    fi
    new_line__3400_v0 "${_display_count_193}"
    local array_711=("")
    eprintf__3346_v0 "\\x1b[G" array_711[@]
    if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
        eprintf_colored__3347_v0 "Page $(( _current_page_195 + 1 ))/${_total_pages_194}" 90
    fi
    new_line__3400_v0 1
    render_tooltip_line__3645_v0 
    go_up__3401_v0 "$(( _display_count_193 + 1 ))"
    local array_712=("")
    eprintf__3346_v0 "\\x1b[G" array_712[@]
}

# chooser_page_start()
chooser_page_start__3647_v0() {
    ret_chooser_page_start3647_v0="$(( _current_page_195 * _page_size_192 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__3648_v0() {
    chooser_page_start__3647_v0 
    local start_40215="${ret_chooser_page_start3647_v0}"
    local end_40216="$(( start_40215 + _page_size_192 ))"
    if [ "$(( end_40216 > _total_191 ))" != 0 ]; then
        end_40216="${_total_191}"
    fi
    ret_chooser_page_count3648_v0="$(( end_40216 - start_40215 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3649_v0() {
    local page_40223=("${!1}")
    _page_202=("${page_40223[@]}")
    local __length_713=("${page_40223[@]}")
    _page_count_203="${#__length_713[@]}"
    if [ "${_first_render_204}" != 0 ]; then
        _first_render_204=0
        render_page__3643_v0 
    else
        if [ "${_up_paged_205}" != 0 ]; then
            _selected_196="$(( _page_count_203 - 1 ))"
            _up_paged_205=0
        fi
        go_up__3401_v0 1
        remove_line__3397_v0 "$(( _display_count_193 - 1 ))"
        remove_current_line__3398_v0 
        local array_714=("")
        eprintf__3346_v0 "\\x1b[G" array_714[@]
        render_page__3643_v0 
        render_page_indicator__3644_v0 
    fi
}

# option_width()
option_width__3650_v0() {
    local check_width_40263
    check_width_40263="$(if [ "${_multi_198}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_715="${_cursor_197}"
    ret_option_width3650_v0="$(( $(( _term_width_200 - ${#__length_715} )) - check_width_40263 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3651_v0() {
    local index_40276="${1}"
    local __length_716="${_cursor_197}"
    rpad__28_v0 "" " " "${#__length_716}"
    local blank_40277="${ret_rpad28_v0}"
    option_width__3650_v0 
    local ret_option_width3650_v0__223_49="${ret_option_width3650_v0}"
    cutoff_text__3480_v0 "${_page_202[${index_40276}]?"Index out of bounds (at src/./file/../choose/engine.ab:223:41)"}" "${ret_option_width3650_v0__223_49}"
    local truncated_40278="${ret_cutoff_text3480_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        ret_unselected_line3651_v0="${blank_40277}""${truncated_40278}"
        return 0
    fi
    chooser_page_start__3647_v0 
    local ret_chooser_page_start3647_v0__227_19="${ret_chooser_page_start3647_v0}"
    checked_is__3567_v0 "$(( ret_chooser_page_start3647_v0__227_19 + index_40276 ))"
    local ret_checked_is3567_v0__227_8="${ret_checked_is3567_v0}"
    if [ "${ret_checked_is3567_v0__227_8}" != 0 ]; then
        colored_secondary__3449_v0 "✓ ""${truncated_40278}"
        local ret_colored_secondary3449_v0__228_24="${ret_colored_secondary3449_v0}"
        ret_unselected_line3651_v0="${blank_40277}""${ret_colored_secondary3449_v0__228_24}"
        return 0
    fi
    ret_unselected_line3651_v0="${blank_40277}""• ""${truncated_40278}"
    return 0
}

# selected_line(index: Int)
selected_line__3652_v0() {
    local index_40262="${1}"
    option_width__3650_v0 
    local ret_option_width3650_v0__235_49="${ret_option_width3650_v0}"
    cutoff_text__3480_v0 "${_page_202[${index_40262}]?"Index out of bounds (at src/./file/../choose/engine.ab:235:41)"}" "${ret_option_width3650_v0__235_49}"
    local truncated_40264="${ret_cutoff_text3480_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        colored_secondary__3449_v0 "${_cursor_197}""${truncated_40264}"
        ret_selected_line3652_v0="${ret_colored_secondary3449_v0}"
        return 0
    fi
    chooser_page_start__3647_v0 
    local ret_chooser_page_start3647_v0__239_29="${ret_chooser_page_start3647_v0}"
    checked_is__3567_v0 "$(( ret_chooser_page_start3647_v0__239_29 + index_40262 ))"
    local ret_checked_is3567_v0__239_18="${ret_checked_is3567_v0}"
    local mark_40265
    mark_40265="$(if [ "${ret_checked_is3567_v0__239_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__3449_v0 "${_cursor_197}""${mark_40265}""${truncated_40264}"
    ret_selected_line3652_v0="${ret_colored_secondary3449_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3653_v0() {
    local prev_selected_40275="${1}"
    unselected_line__3651_v0 "${prev_selected_40275}"
    local ret_unselected_line3651_v0__246_47="${ret_unselected_line3651_v0}"
    redraw_row__3564_v0 "${_display_count_193}" "${prev_selected_40275}" "${ret_unselected_line3651_v0__246_47}"
    selected_line__3652_v0 "${_selected_196}"
    local ret_selected_line3652_v0__247_43="${ret_selected_line3652_v0}"
    redraw_row__3564_v0 "${_display_count_193}" "${_selected_196}" "${ret_selected_line3652_v0__247_43}"
}

# redraw_current_line()
redraw_current_line__3654_v0() {
    selected_line__3652_v0 "${_selected_196}"
    local ret_selected_line3652_v0__252_43="${ret_selected_line3652_v0}"
    redraw_row__3564_v0 "${_display_count_193}" "${_selected_196}" "${ret_selected_line3652_v0__252_43}"
}

# chooser_step()
chooser_step__3655_v0() {
    get_key__3344_v0 
    local key_40257="${ret_get_key3344_v0}"
    local prev_selected_40258="${_selected_196}"
    local prev_page_40259="${_current_page_195}"
    chooser_page_start__3647_v0 
    local page_start_40260="${ret_chooser_page_start3647_v0}"
    _up_paged_205=0
    if [ "$(( $([ "_${key_40257}" != "_UP" ]; echo $?) || $([ "_${key_40257}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40257}" != "_DOWN" ]; echo $?) || $([ "_${key_40257}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40257}" != "_LEFT" ]; echo $?) || $([ "_${key_40257}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 > 0 ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 - 1 ))"
        fi
        _selected_196=0
    elif [ "$(( $([ "_${key_40257}" != "_RIGHT" ]; echo $?) || $([ "_${key_40257}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 < $(( _total_pages_194 - 1 )) ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 + 1 ))"
            _selected_196=0
        else
            _selected_196="$(( _page_count_203 - 1 ))"
        fi
    elif [ "$(( _multi_198 && $(( $(( $([ "_${key_40257}" != "_x" ]; echo $?) || $([ "_${key_40257}" != "_X" ]; echo $?) )) || $([ "_${key_40257}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3569_v0 "$(( page_start_40260 + _selected_196 ))"
        local ret_checked_toggle3569_v0__309_16="${ret_checked_toggle3569_v0}"
        if [ "${ret_checked_toggle3569_v0__309_16}" != 0 ]; then
            redraw_current_line__3654_v0 
        fi
        ret_chooser_step3655_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $(( _multi_198 && $(( $(( $([ "_${key_40257}" != "_a" ]; echo $?) || $([ "_${key_40257}" != "_A" ]; echo $?) )) || $([ "_${key_40257}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
        checked_all__3570_v0 
        local ret_checked_all3570_v0__315_16="${ret_checked_all3570_v0}"
        if [ "${ret_checked_all3570_v0__315_16}" != 0 ]; then
            go_up__3401_v0 "${_display_count_193}"
            local array_717=("")
            eprintf__3346_v0 "\\x1b[G" array_717[@]
            render_page__3643_v0 
        fi
        ret_chooser_step3655_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $([ "_${key_40257}" != "_INPUT" ]; echo $?) || $([ "_${key_40257}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step3655_v0="${__CHOOSER_DONE_190}"
        return 0
    else
        ret_chooser_step3655_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    fi
    if [ "$(( prev_page_40259 != _current_page_195 ))" != 0 ]; then
        ret_chooser_step3655_v0="${__CHOOSER_NEED_PAGE_189}"
        return 0
    fi
    if [ "$(( prev_selected_40258 != _selected_196 ))" != 0 ]; then
        redraw_selection__3653_v0 "${prev_selected_40258}"
    fi
    ret_chooser_step3655_v0="${__CHOOSER_CONTINUE_188}"
    return 0
}

# chooser_selected()
chooser_selected__3656_v0() {
    chooser_page_start__3647_v0 
    local ret_chooser_page_start3647_v0__339_12="${ret_chooser_page_start3647_v0}"
    ret_chooser_selected3656_v0="$(( ret_chooser_page_start3647_v0__339_12 + _selected_196 ))"
    return 0
}

# chooser_end()
chooser_end__3658_v0() {
    local total_lines_40281="$(( _display_count_193 + 2 ))"
    if [ "${_has_header_201}" != 0 ]; then
        total_lines_40281="$(( total_lines_40281 + 1 ))"
    fi
    go_down__3402_v0 1
    remove_line__3397_v0 "$(( total_lines_40281 - 1 ))"
    remove_current_line__3398_v0 
    stty_unlock__3388_v0 
    show_cursor__3405_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3667_v0() {
    local name_40219="${1}"
    local file_type_40220="${2}"
    local target_40221="${3}"
    if [ "$([ "_${file_type_40220}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__3106_v0 "/"
        local ret_colored_primary3106_v0__10_23="${ret_colored_primary3106_v0}"
        ret_format_entry_display3667_v0="${name_40219}""${ret_colored_primary3106_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_40220}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__3108_v0 " > "
        local ret_colored_accent3108_v0__13_23="${ret_colored_accent3108_v0}"
        colored_primary__3106_v0 "${target_40221}"
        local ret_colored_primary3106_v0__13_47="${ret_colored_primary3106_v0}"
        ret_format_entry_display3667_v0="${name_40219}""${ret_colored_accent3108_v0__13_23}""${ret_colored_primary3106_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3667_v0="${name_40219}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3668_v0() {
    local start_path_40095="${1}"
    local cursor_40096="${2}"
    local show_hidden_40097="${3}"
    local page_size_40098="${4}"
    stty_lock__3045_v0 
    # Initialize current path
    local current_path_40101="${start_path_40095}"
    if [ "$([ "_${current_path_40101}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__3087_v0 
        current_path_40101="${ret_get_cwd3087_v0}"
    fi
    normalize_path__3088_v0 "${current_path_40101}"
    current_path_40101="${ret_normalize_path3088_v0}"
    while :
    do
        colored_primary__3106_v0 "Loading files..."
        local ret_colored_primary3106_v0__41_17="${ret_colored_primary3106_v0}"
        local array_718=("")
        eprintf__3004_v0 "${ret_colored_primary3106_v0__41_17}" array_718[@]
        get_directory_entries__3086_v0 "${current_path_40101}"
        local listed_40112=("${ret_get_directory_entries3086_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_40113=()
        local types_40114=()
        local targets_40115=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_40101}" == "_/" ]; echo $?)" != 0 ]; then
            names_40113+=("..")
            types_40114+=("d")
            targets_40115+=("")
        fi
        local __length_725=("${listed_40112[@]}")
        local listed_count_40116="$(( ${#__length_725[@]} / __ENTRY_STRIDE_151 ))"
        local __range_start_40117=0
        local __range_end_40117="${listed_count_40116}"
        local __dir_40117=$(( ${__range_start_40117} <= ${__range_end_40117} ? 1 : -1 ))
        for (( i_40117=${__range_start_40117}; i_40117 * ${__dir_40117} < ${__range_end_40117} * ${__dir_40117}; i_40117+=${__dir_40117} )); do
            local at_40118="$(( i_40117 * __ENTRY_STRIDE_151 ))"
            local name_40119="${listed_40112[${at_40118}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_40119}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_40097 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_726=("${name_40119}")
            names_40113+=("${array_726[@]}")
            local array_727=("${listed_40112[$(( at_40118 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_40114+=("${array_727[@]}")
            local array_728=("${listed_40112[$(( at_40118 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_40115+=("${array_728[@]}")
done
        local __length_729=("${names_40113[@]}")
        local total_40120="${#__length_729[@]}"
        if [ "$(( total_40120 == 0 ))" != 0 ]; then
            eprintf_colored__3005_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__3046_v0 
            ret_xyl_file3668_v0=""
            return 0
        fi
        colored_primary__3106_v0 "${current_path_40101}"
        local header_40122="${ret_colored_primary3106_v0}"
        remove_current_line__3056_v0 
        chooser_begin__3646_v0 "${total_40120}" "${page_size_40098}" "${header_40122}" "${cursor_40096}" 0 -1
        local need_page_40212=1
        while :
        do
            if [ "${need_page_40212}" != 0 ]; then
                local page_40213=()
                chooser_page_start__3647_v0 
                local start_40214="${ret_chooser_page_start3647_v0}"
                chooser_page_count__3648_v0 
                local count_40217="${ret_chooser_page_count3648_v0}"
                local __range_start_40218="${start_40214}"
                local __range_end_40218="$(( start_40214 + count_40217 ))"
                local __dir_40218=$(( ${__range_start_40218} <= ${__range_end_40218} ? 1 : -1 ))
                for (( i_40218=${__range_start_40218}; i_40218 * ${__dir_40218} < ${__range_end_40218} * ${__dir_40218}; i_40218+=${__dir_40218} )); do
                    format_entry_display__3667_v0 "${names_40113[${i_40218}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_40114[${i_40218}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_40115[${i_40218}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3667_v0__90_30="${ret_format_entry_display3667_v0}"
                    local array_731=("${ret_format_entry_display3667_v0__90_30}")
                    page_40213+=("${array_731[@]}")
done
                chooser_set_page__3649_v0 page_40213[@]
            fi
            chooser_step__3655_v0 
            local step_40279="${ret_chooser_step3655_v0}"
            if [ "$(( step_40279 == __CHOOSER_DONE_190 ))" != 0 ]; then
                break
            fi
            need_page_40212="$(( step_40279 == __CHOOSER_NEED_PAGE_189 ))"
        done
        chooser_selected__3656_v0 
        local selected_idx_40280="${ret_chooser_selected3656_v0}"
        chooser_end__3658_v0 
        local name_40284="${names_40113[${selected_idx_40280}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_40285="${types_40114[${selected_idx_40280}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_40284}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__3090_v0 "${current_path_40101}"
            current_path_40101="${ret_get_parent_dir3090_v0}"
        elif [ "$([ "_${file_type_40285}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__3089_v0 "${current_path_40101}" "${name_40284}"
            current_path_40101="${ret_path_join3089_v0}"
            normalize_path__3088_v0 "${current_path_40101}"
            current_path_40101="${ret_normalize_path3088_v0}"
        elif [ "$([ "_${file_type_40285}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_40290="${targets_40115[${selected_idx_40280}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_40291="${target_40290}"
            starts_with__22_v0 "${target_40290}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__3089_v0 "${current_path_40101}" "${target_40290}"
                target_path_40291="${ret_path_join3089_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_40291}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_40101="${target_path_40291}"
                normalize_path__3088_v0 "${current_path_40101}"
                current_path_40101="${ret_normalize_path3088_v0}"
            else
                stty_unlock__3046_v0 
                path_join__3089_v0 "${current_path_40101}" "${name_40284}"
                ret_xyl_file3668_v0="${ret_path_join3089_v0}"
                return 0
            fi
        else
            stty_unlock__3046_v0 
            path_join__3089_v0 "${current_path_40101}" "${name_40284}"
            ret_xyl_file3668_v0="${ret_path_join3089_v0}"
            return 0
        fi
    done
    stty_unlock__3046_v0 
    ret_xyl_file3668_v0=""
    return 0
}

# print_file_help()
print_file_help__3768_v0() {
    local usage_40010=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__3064_v0 usage_40010[@]
    printf '%s\n' ""
    colored_primary__3106_v0 "file"
    local ret_colored_primary3106_v0__8_20="${ret_colored_primary3106_v0}"
    local title_40050=("${ret_colored_primary3106_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__3064_v0 title_40050[@]
    printf '%s\n' ""
    colored_secondary__3107_v0 "Arguments:"
    local ret_colored_secondary3107_v0__11_12="${ret_colored_secondary3107_v0}"
    local array_734=()
    printf__128_v0 "${ret_colored_secondary3107_v0__11_12}""
" array_734[@]
    local arg_names_40052=("[<path>]")
    local arg_texts_40053=("Starting directory path")
    local arg_notes_40054=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__3241_v0 arg_names_40052[@] arg_texts_40053[@] arg_notes_40054[@] 20
    printf '%s\n' ""
    colored_secondary__3107_v0 "Flags:"
    local ret_colored_secondary3107_v0__18_12="${ret_colored_secondary3107_v0}"
    local array_738=()
    printf__128_v0 "${ret_colored_secondary3107_v0__18_12}""
" array_738[@]
    local names_40087=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_40088=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_40089=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__3241_v0 names_40087[@] texts_40088[@] notes_40089[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3826_v0() {
    local parameters_40004=("${!1}")
    local cursor_40005="> "
    local start_path_40006=""
    local show_hidden_40007=0
    local page_size_40008=10
    local __length_745=("${parameters_40004[@]}")
    local slice_upper_744="${#__length_745[@]}"
    local slice_offset_746=2
    local slice_offset_746=$((${slice_offset_746} > 0 ? ${slice_offset_746} : 0))
    local slice_length_747="$(( slice_upper_744 - slice_offset_746 ))"
    local slice_length_747=$((${slice_length_747} > 0 ? ${slice_length_747} : 0))
    for param_40009 in "${parameters_40004[@]:${slice_offset_746}:${slice_length_747}}"; do
        starts_with__22_v0 "${param_40009}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40009}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40009}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_40009}" != "_-h" ]; echo $?) || $([ "_${param_40009}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3768_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_748="--cursor="
            slice__24_v0 "${param_40009}" "${#__length_748}" 0
            cursor_40005="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_749="--path="
            slice__24_v0 "${param_40009}" "${#__length_749}" 0
            start_path_40006="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_40009}" != "_-a" ]; echo $?) || $([ "_${param_40009}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_40007=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_750="--page-size="
            slice__24_v0 "${param_40009}" "${#__length_750}" 0
            local value_40090="${ret_slice24_v0}"
            parse_int__13_v0 "${value_40090}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__3005_v0 "ERROR: Invalid page-size value: ""${value_40090}""
" 31
                exit 1
            fi
            page_size_40008="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_40006="${param_40009}"
        fi
    done
    xyl_file__3668_v0 "${start_path_40006}" "${cursor_40005}" "${show_hidden_40007}" "${page_size_40008}"
    ret_execute_file3826_v0="${ret_xyl_file3668_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_211="0.1.0"
__AMBER_VERSION_212="0.6.0-alpha"
# trap_cleanup()
trap_cleanup__3828_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo icanon < /dev/tty' EXIT
    __status=$?
}

typeset -r args_213=("$0" "$@")
trap_cleanup__3828_v0 
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_752=("${args_213[@]}")
if [ "$(( ${#__length_752[@]} < 2 ))" != 0 ]; then
    print_help__555_v0 
    exit 0
fi
command_1579="${args_213[1]?"Index out of bounds (at src/main.ab:29:26)"}"
if [ "$(( $(( $([ "_${command_1579}" != "_help" ]; echo $?) || $([ "_${command_1579}" != "_--help" ]; echo $?) )) || $([ "_${command_1579}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__555_v0 
elif [ "$([ "_${command_1579}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1091_v0 args_213[@]
    ret_execute_input1091_v0__36_18="${ret_execute_input1091_v0}"
    printf '%s\n' "${ret_execute_input1091_v0__36_18}"
elif [ "$([ "_${command_1579}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1755_v0 args_213[@]
    ret_execute_choose1755_v0__39_18="${ret_execute_choose1755_v0}"
    printf '%s\n' "${ret_execute_choose1755_v0__39_18}"
elif [ "$([ "_${command_1579}" != "_filter" ]; echo $?)" != 0 ]; then
    execute_filter__2306_v0 args_213[@]
    ret_execute_filter2306_v0__42_18="${ret_execute_filter2306_v0}"
    printf '%s\n' "${ret_execute_filter2306_v0__42_18}"
elif [ "$([ "_${command_1579}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2886_v0 args_213[@]
    result_29676="${ret_execute_confirm2886_v0}"
    if [ "$([ "_${result_29676}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1579}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3826_v0 args_213[@]
    ret_execute_file3826_v0__52_18="${ret_execute_file3826_v0}"
    printf '%s\n' "${ret_execute_file3826_v0__52_18}"
elif [ "$(( $(( $([ "_${command_1579}" != "_version" ]; echo $?) || $([ "_${command_1579}" != "_--version" ]; echo $?) )) || $([ "_${command_1579}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__263_v0 "xylitol.sh"
    ret_colored_primary263_v0__55_20="${ret_colored_primary263_v0}"
    array_753=()
    printf__128_v0 "${ret_colored_primary263_v0__55_20}" array_753[@]
    array_754=()
    printf__128_v0 " version: " array_754[@]
    colored_accent__265_v0 "${__VERSION_211}"
    ret_colored_accent265_v0__57_20="${ret_colored_accent265_v0}"
    array_755=()
    printf__128_v0 "${ret_colored_accent265_v0__57_20}" array_755[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_212}" 90
else
    print_help__555_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1579}""'" 91
fi
