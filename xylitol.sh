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
    local list_18168=("${!1}")
    local delimiter_18169="${2}"
    local command_1
    command_1="$(IFS="${delimiter_18169}" ; printf "%s
" "${list_18168[*]}")"
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
    local text_3197="${1}"
    local prefix_3198="${2}"
    [[ "${text_3197}" == "${prefix_3198}"* ]]
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
    local text_29759="${1}"
    local pad_29760="${2}"
    local length_29761="${3}"
    local __length_3="${text_29759}"
    if [ "$(( length_29761 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_29759}"
        return 0
    fi
    local __length_4="${text_29759}"
    local pad_len_29762="$(( length_29761 - ${#__length_4} ))"
    local padding_29763=""
    printf -v padding_29763 "%${pad_len_29762}s" ""
    __status=$?
    padding_29763="${padding_29763// /${pad_29760}}"
    __status=$?
    ret_lpad27_v0="${padding_29763}""${text_29759}"
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
    local text_29753="${1}"
    local pad_29754="${2}"
    local length_29755="${3}"
    local __length_7="${text_29753}"
    local text_length_29756="${#__length_7}"
    if [ "$(( length_29755 <= text_length_29756 ))" != 0 ]; then
        ret_cpad29_v0="${text_29753}"
        return 0
    fi
    local total_padding_29757="$(( length_29755 - text_length_29756 ))"
    local left_padding_length_29758="$(( text_length_29756 + $(( total_padding_29757 / 2 )) ))"
    lpad__27_v0 "${text_29753}" "${pad_29754}" "${left_padding_length_29758}"
    local left_padded_29764="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_29764}" "${pad_29754}" "${length_29755}"
    local center_padded_29765="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_29765}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_40472="${1}"
    [ -d "${path_40472}" ]
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
    local message_40475="${1}"
    local color_40476="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_40475}")
    printf__128_v1 "\\x1b[${color_40476}m%s\\x1b[0m" array_12[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_3="None"
# perl_available()
perl_available__185_v0() {
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
    ret_perl_available185_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__186_v0() {
    local text_1499="${1}"
    perl_available__185_v0 
    local ret_perl_available185_v0__19_12="${ret_perl_available185_v0}"
    if [ "$(( ! ret_perl_available185_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width186_v0=''
        return 1
    fi
    local command_15
    command_15="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1499}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width186_v0=''
        return "${__status}"
    fi
    local width_str_1502="${command_15}"
    parse_int__13_v0 "${width_str_1502}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width186_v0=''
        return "${__status}"
    fi
    local width_1503="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width186_v0="${width_1503}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__191_v0() {
    local text_1489="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_16
    command_16="$([[ "${text_1489}" == *$'\x1b'* || "${text_1489}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1490="${command_16}"
    ret_has_ansi_escape191_v0="$([ "_${has_escape_1490}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__193_v0() {
    local text_1495="${1}"
    local command_17
    command_17="$(printf "%s" "${text_1495}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi193_v0="${command_17}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__194_v0() {
    local text_1497="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1497}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1498="${command_18}"
    ret_is_all_ascii194_v0="$([ "_${result_1498}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__195_v0() {
    local text_1492="${1}"
    local command_19
    command_19="$(LC_ALL=C; __t="${text_1492}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_1493="${command_19}"
    parse_int__13_v0 "${measured_1493}"
    __status=$?
    ret_plain_len195_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__196_v0() {
    local text_1491="${1}"
    plain_len__195_v0 "${text_1491}"
    local plain_1494="${ret_plain_len195_v0}"
    if [ "$(( plain_1494 >= 0 ))" != 0 ]; then
        ret_get_visible_len196_v0="${plain_1494}"
        return 0
    fi
    strip_ansi__193_v0 "${text_1491}"
    local stripped_1496="${ret_strip_ansi193_v0}"
    is_all_ascii__194_v0 "${stripped_1496}"
    local ret_is_all_ascii194_v0__46_12="${ret_is_all_ascii194_v0}"
    if [ "$(( ! ret_is_all_ascii194_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__186_v0 "${stripped_1496}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_20="${stripped_1496}"
            ret_get_visible_len196_v0="${#__length_20}"
            return 0
        fi
        ret_get_visible_len196_v0="${ret_perl_get_cjk_width186_v0}"
        return 0
    fi
    local __length_21="${stripped_1496}"
    ret_get_visible_len196_v0="${#__length_21}"
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
store_term_size__205_v0() {
    local size_1476="${1}"
    if [ "$([ "_${size_1476}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size205_v0=0
        return 0
    fi
    split__4_v0 "${size_1476}" " "
    local parts_1480=("${ret_split4_v0[@]}")
    local __length_23=("${parts_1480[@]}")
    if [ "$(( ${#__length_23[@]} != 2 ))" != 0 ]; then
        ret_store_term_size205_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1480[1]?"Index out of bounds (at src/utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1480[0]?"Index out of bounds (at src/utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_5=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size205_v0=1
    return 0
}

# query_term_size()
query_term_size__206_v0() {
    local command_25
    command_25="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1483="${command_25}"
    store_term_size__205_v0 "${size_1483}"
    ret_query_term_size206_v0="${ret_store_term_size205_v0}"
    return 0
}

# stty_term_size()
stty_term_size__207_v0() {
    local command_26
    command_26="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1475="${command_26}"
    store_term_size__205_v0 "${size_1475}"
    ret_stty_term_size207_v0="${ret_store_term_size205_v0}"
    return 0
}

# get_term_size()
get_term_size__208_v0() {
    stty_term_size__207_v0 
    local detected_1482="${ret_stty_term_size207_v0}"
    if [ "$(( ! detected_1482 ))" != 0 ]; then
        query_term_size__206_v0 
        detected_1482="${ret_query_term_size206_v0}"
    fi
    _got_term_size_4=1
}

# term_width()
term_width__210_v0() {
    if [ "$(( ! _got_term_size_4 ))" != 0 ]; then
        get_term_size__208_v0 
    fi
    ret_term_width210_v0="${_term_size_5[0]?"Index out of bounds (at src/utils/term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__222_v0() {
    local pieces_1474=("${!1}")
    term_width__210_v0 
    local width_1484="${ret_term_width210_v0}"
    local line_1485=""
    local line_len_1486=0
    for piece_1487 in "${pieces_1474[@]}"; do
        local __length_29="${piece_1487}"
        local piece_len_1488="${#__length_29}"
        has_ansi_escape__191_v0 "${piece_1487}"
        local ret_has_ansi_escape191_v0__190_12="${ret_has_ansi_escape191_v0}"
        if [ "${ret_has_ansi_escape191_v0__190_12}" != 0 ]; then
            get_visible_len__196_v0 "${piece_1487}"
            piece_len_1488="${ret_get_visible_len196_v0}"
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
get_supports_truecolor__259_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1524="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1524}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor259_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__260_v0() {
    local message_1519="${1}"
    local r_1520="${2}"
    local g_1521="${3}"
    local b_1522="${4}"
    local fallback_1523="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb260_v0="\\x1b[38;2;${r_1520};${g_1521};${b_1522}m""${message_1519}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__259_v0 
        local ret_get_supports_truecolor259_v0__45_17="${ret_get_supports_truecolor259_v0}"
        if [ "${ret_get_supports_truecolor259_v0__45_17}" != 0 ]; then
            ret_colored_rgb260_v0="\\x1b[38;2;${r_1520};${g_1521};${b_1522}m""${message_1519}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1523 == 0 ))" != 0 ]; then
            ret_colored_rgb260_v0="${message_1519}"
            return 0
        else
            ret_colored_rgb260_v0="\\x1b[${fallback_1523}m""${message_1519}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1523 == 0 ))" != 0 ]; then
            ret_colored_rgb260_v0="${message_1519}"
            return 0
        fi
        ret_colored_rgb260_v0="\\x1b[${fallback_1523}m""${message_1519}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__262_v0() {
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
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1509[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1509[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1509[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
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
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1511[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1511[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1511[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
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
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1513[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1513[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1513[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors262_v0=''
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
get_xylitol_colors__263_v0() {
    inner_get_xylitol_colors__262_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_9=1
}

# colored_primary(message: Text)
colored_primary__264_v0() {
    local message_1506="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__263_v0 
    fi
    colored_rgb__260_v0 "${message_1506}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary264_v0="${ret_colored_rgb260_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__265_v0() {
    local message_1526="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__263_v0 
    fi
    colored_rgb__260_v0 "${message_1526}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary265_v0="${ret_colored_rgb260_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__266_v0() {
    local message_1577="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__263_v0 
    fi
    colored_rgb__260_v0 "${message_1577}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent266_v0="${ret_colored_rgb260_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__319_v0() {
    local message_1565="${1}"
    local color_1566="${2}"
    # Returns a text wrapped in color codes.
    ret_colored319_v0="\\x1b[${color_1566}m""${message_1565}""\\x1b[0m"
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
store_term_size__361_v0() {
    local size_1539="${1}"
    if [ "$([ "_${size_1539}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size361_v0=0
        return 0
    fi
    split__4_v0 "${size_1539}" " "
    local parts_1540=("${ret_split4_v0[@]}")
    local __length_42=("${parts_1540[@]}")
    if [ "$(( ${#__length_42[@]} != 2 ))" != 0 ]; then
        ret_store_term_size361_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1540[1]?"Index out of bounds (at src/utils/widget/../term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1540[0]?"Index out of bounds (at src/utils/widget/../term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_17=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size361_v0=1
    return 0
}

# query_term_size()
query_term_size__362_v0() {
    local command_44
    command_44="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1542="${command_44}"
    store_term_size__361_v0 "${size_1542}"
    ret_query_term_size362_v0="${ret_store_term_size361_v0}"
    return 0
}

# stty_term_size()
stty_term_size__363_v0() {
    local command_45
    command_45="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1538="${command_45}"
    store_term_size__361_v0 "${size_1538}"
    ret_stty_term_size363_v0="${ret_store_term_size361_v0}"
    return 0
}

# get_term_size()
get_term_size__364_v0() {
    stty_term_size__363_v0 
    local detected_1541="${ret_stty_term_size363_v0}"
    if [ "$(( ! detected_1541 ))" != 0 ]; then
        query_term_size__362_v0 
        detected_1541="${ret_query_term_size362_v0}"
    fi
    _got_term_size_16=1
}

# term_width()
term_width__366_v0() {
    if [ "$(( ! _got_term_size_16 ))" != 0 ]; then
        get_term_size__364_v0 
    fi
    ret_term_width366_v0="${_term_size_17[0]?"Index out of bounds (at src/utils/widget/../term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__399_v0() {
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
        colored__319_v0 "${line_1563}" 90
        local ret_colored319_v0__12_40="${ret_colored319_v0}"
        local array_48=()
        printf__128_v0 "${pending_1562}""${ret_colored319_v0__12_40}""
" array_48[@]
    else
        slice__24_v0 "${line_1563}" 0 "${note_at_1564}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1563}" "${note_at_1564}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__319_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored319_v0__13_58="${ret_colored319_v0}"
        local array_49=()
        printf__128_v0 "${pending_1562}""${ret_slice24_v0__13_32}""${ret_colored319_v0__13_58}""
" array_49[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__400_v0() {
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
    term_width__366_v0 
    local width_1543="${ret_term_width366_v0}"
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
                print_help_line__399_v0 "${pending_1554}" "${line_1557}" "${note_at_1558}"
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
        print_help_line__399_v0 "${pending_1554}" "${line_1557}" "${note_at_1558}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__557_v0() {
    local usage_1473=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__222_v0 usage_1473[@]
    printf '%s\n' ""
    colored_primary__264_v0 "Xylitol"
    local ret_colored_primary264_v0__9_21="${ret_colored_primary264_v0}"
    colored_primary__264_v0 "fresh"
    local ret_colored_primary264_v0__10_34="${ret_colored_primary264_v0}"
    local title_1525=("\\x1b[1m""${ret_colored_primary264_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary264_v0__10_34}" "shell" "scripts.")
    print_wrapped__222_v0 title_1525[@]
    printf '%s\n' ""
    colored_secondary__265_v0 "Flags:"
    local ret_colored_secondary265_v0__14_12="${ret_colored_secondary265_v0}"
    local array_62=()
    printf__128_v0 "${ret_colored_secondary265_v0__14_12}""
" array_62[@]
    local flag_names_1527=("-h, --help" "-v, --version")
    local flag_texts_1528=("Show this help message" "Show version information")
    local flag_notes_1529=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__400_v0 flag_names_1527[@] flag_texts_1528[@] flag_notes_1529[@] 13
    printf '%s\n' ""
    colored_secondary__265_v0 "Commands:"
    local ret_colored_secondary265_v0__21_12="${ret_colored_secondary265_v0}"
    local array_66=()
    printf__128_v0 "${ret_colored_secondary265_v0__21_12}""
" array_66[@]
    local cmd_names_1571=("input" "choose" "filter" "confirm" "file")
    local cmd_texts_1572=("Prompt for some input" "Choose from a list of options" "Pick from a list narrowed by typing" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1573=("" "" "" "" "")
    render_help_entries__400_v0 cmd_names_1571[@] cmd_texts_1572[@] cmd_notes_1573[@] 13
    printf '%s\n' ""
    colored_secondary__265_v0 "Envs:"
    local ret_colored_secondary265_v0__33_12="${ret_colored_secondary265_v0}"
    local array_70=()
    printf__128_v0 "${ret_colored_secondary265_v0__33_12}""
" array_70[@]
    local env_names_1574=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1575=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1576=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__400_v0 env_names_1574[@] env_texts_1575[@] env_notes_1576[@] 0
    printf '%s\n' ""
    colored_accent__266_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent266_v0__58_16="${ret_colored_accent266_v0}"
    local footer_1578=("Run" "${ret_colored_accent266_v0__58_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__222_v0 footer_1578[@]
}

# get_char()
get_char__637_v0() {
    local command_75
    command_75="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3279="${command_75}"
    ret_get_char637_v0="${char_3279}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__640_v0() {
    local format_3253="${1}"
    local args_3254=("${!2}")
    args_3254=("${format_3253}" "${args_3254[@]}")
    __status=$?
    printf "${args_3254[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__641_v0() {
    local message_3277="${1}"
    local color_3278="${2}"
    # Prints an error message with a specified color.
    local array_76=("${message_3277}")
    eprintf__640_v0 "\\x1b[${color_3278}m%s\\x1b[0m" array_76[@]
}

# eprintf(format: Text, args: [Text])
eprintf__656_v0() {
    local format_3211="${1}"
    local args_3212=("${!2}")
    args_3212=("${format_3211}" "${args_3212[@]}")
    __status=$?
    printf "${args_3212[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__657_v0() {
    local message_3209="${1}"
    local color_3210="${2}"
    # Prints an error message with a specified color.
    local array_77=("${message_3209}")
    eprintf__656_v0 "\\x1b[${color_3210}m%s\\x1b[0m" array_77[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_24="None"
# perl_available()
perl_available__664_v0() {
    if [ "$([ "_${_perl_state_24}" != "_None" ]; echo $?)" != 0 ]; then
        local command_78
        command_78="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3143
        disabled_3143="$([ "_${command_78}" != "_No" ]; echo $?)"
        local command_79
        command_79="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3144
        found_3144="$(( $(( ! disabled_3143 )) && $([ "_${command_79}" != "_0" ]; echo $?) ))"
        _perl_state_24="$(if [ "${found_3144}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available664_v0="$([ "_${_perl_state_24}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__665_v0() {
    local text_3142="${1}"
    perl_available__664_v0 
    local ret_perl_available664_v0__19_12="${ret_perl_available664_v0}"
    if [ "$(( ! ret_perl_available664_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width665_v0=''
        return 1
    fi
    local command_80
    command_80="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3142}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width665_v0=''
        return "${__status}"
    fi
    local width_str_3145="${command_80}"
    parse_int__13_v0 "${width_str_3145}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width665_v0=''
        return "${__status}"
    fi
    local width_3146="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width665_v0="${width_3146}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__670_v0() {
    local text_3132="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_81
    command_81="$([[ "${text_3132}" == *$'\x1b'* || "${text_3132}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3133="${command_81}"
    ret_has_ansi_escape670_v0="$([ "_${has_escape_3133}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__672_v0() {
    local text_3138="${1}"
    local command_82
    command_82="$(printf "%s" "${text_3138}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi672_v0="${command_82}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__673_v0() {
    local text_3140="${1}"
    local command_83
    command_83="$(printf "%s" "${text_3140}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3141="${command_83}"
    ret_is_all_ascii673_v0="$([ "_${result_3141}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__674_v0() {
    local text_3135="${1}"
    local command_84
    command_84="$(LC_ALL=C; __t="${text_3135}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3136="${command_84}"
    parse_int__13_v0 "${measured_3136}"
    __status=$?
    ret_plain_len674_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__675_v0() {
    local text_3134="${1}"
    plain_len__674_v0 "${text_3134}"
    local plain_3137="${ret_plain_len674_v0}"
    if [ "$(( plain_3137 >= 0 ))" != 0 ]; then
        ret_get_visible_len675_v0="${plain_3137}"
        return 0
    fi
    strip_ansi__672_v0 "${text_3134}"
    local stripped_3139="${ret_strip_ansi672_v0}"
    is_all_ascii__673_v0 "${stripped_3139}"
    local ret_is_all_ascii673_v0__46_12="${ret_is_all_ascii673_v0}"
    if [ "$(( ! ret_is_all_ascii673_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__665_v0 "${stripped_3139}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_85="${stripped_3139}"
            ret_get_visible_len675_v0="${#__length_85}"
            return 0
        fi
        ret_get_visible_len675_v0="${ret_perl_get_cjk_width665_v0}"
        return 0
    fi
    local __length_86="${stripped_3139}"
    ret_get_visible_len675_v0="${#__length_86}"
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
stty_count__681_v0() {
    local command_88
    command_88="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_3207="${command_88}"
    parse_int__13_v0 "${count_3207}"
    __status=$?
    ret_stty_count681_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__682_v0() {
    stty_count__681_v0 
    local count_num_3208="${ret_stty_count681_v0}"
    if [ "$(( count_num_3208 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 2>/dev/null < /dev/tty
        __status=$?
        if [ "${__status}" != 0 ]; then
            eprintf_colored__657_v0 "Error: " 91
            local array_89=("")
            eprintf__656_v0 "xylitol needs a terminal, and /dev/tty is not available here.
" array_89[@]
            exit 1
        fi
    fi
    count_num_3208="$(( count_num_3208 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3208}
    __status=$?
}

# stty_unlock()
stty_unlock__683_v0() {
    stty_count__681_v0 
    local count_num_3282="${ret_stty_count681_v0}"
    if [ "$(( count_num_3282 > 0 ))" != 0 ]; then
        count_num_3282="$(( count_num_3282 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3282}
        __status=$?
        if [ "$(( count_num_3282 == 0 ))" != 0 ]; then
            stty echo icanon 2>/dev/null < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__684_v0() {
    local size_3123="${1}"
    if [ "$([ "_${size_3123}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size684_v0=0
        return 0
    fi
    split__4_v0 "${size_3123}" " "
    local parts_3124=("${ret_split4_v0[@]}")
    local __length_90=("${parts_3124[@]}")
    if [ "$(( ${#__length_90[@]} != 2 ))" != 0 ]; then
        ret_store_term_size684_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3124[1]?"Index out of bounds (at src/./input/../utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3124[0]?"Index out of bounds (at src/./input/../utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_26=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size684_v0=1
    return 0
}

# query_term_size()
query_term_size__685_v0() {
    local command_92
    command_92="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_3126="${command_92}"
    store_term_size__684_v0 "${size_3126}"
    ret_query_term_size685_v0="${ret_store_term_size684_v0}"
    return 0
}

# stty_term_size()
stty_term_size__686_v0() {
    local command_93
    command_93="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3122="${command_93}"
    store_term_size__684_v0 "${size_3122}"
    ret_stty_term_size686_v0="${ret_store_term_size684_v0}"
    return 0
}

# get_term_size()
get_term_size__687_v0() {
    stty_term_size__686_v0 
    local detected_3125="${ret_stty_term_size686_v0}"
    if [ "$(( ! detected_3125 ))" != 0 ]; then
        query_term_size__685_v0 
        detected_3125="${ret_query_term_size685_v0}"
    fi
    _got_term_size_25=1
}

# term_width()
term_width__689_v0() {
    if [ "$(( ! _got_term_size_25 ))" != 0 ]; then
        get_term_size__687_v0 
    fi
    ret_term_width689_v0="${_term_size_26[0]?"Index out of bounds (at src/./input/../utils/term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# remove(cnt: Int)
remove__691_v0() {
    local cnt_3280="${1}"
    if [ "$(( cnt_3280 > 0 ))" != 0 ]; then
        local array_94=("")
        eprintf__656_v0 "\\x1b[${cnt_3280}D\\x1b[K" array_94[@]
    fi
}

# remove_line(cnt: Int)
remove_line__692_v0() {
    local cnt_3286="${1}"
    if [ "$(( cnt_3286 > 0 ))" != 0 ]; then
        local sequence_3287=""
        local __range_start_3288=0
        local __range_end_3288="${cnt_3286}"
        local __dir_3288=$(( ${__range_start_3288} <= ${__range_end_3288} ? 1 : -1 ))
        for (( ____3288=${__range_start_3288}; ____3288 * ${__dir_3288} < ${__range_end_3288} * ${__dir_3288}; ____3288+=${__dir_3288} )); do
            sequence_3287+="\\x1b[2K\\x1b[1A"
done
        local array_95=("")
        eprintf__656_v0 "${sequence_3287}" array_95[@]
    fi
    local array_96=("")
    eprintf__656_v0 "\\x1b[G" array_96[@]
}

# remove_current_line()
remove_current_line__693_v0() {
    local array_97=("")
    eprintf__656_v0 "\\x1b[2K\\x1b[G" array_97[@]
}

# new_line(cnt: Int)
new_line__695_v0() {
    local cnt_3255="${1}"
    local __range_start_3256=0
    local __range_end_3256="${cnt_3255}"
    local __dir_3256=$(( ${__range_start_3256} <= ${__range_end_3256} ? 1 : -1 ))
    for (( ____3256=${__range_start_3256}; ____3256 * ${__dir_3256} < ${__range_end_3256} * ${__dir_3256}; ____3256+=${__dir_3256} )); do
        local array_98=("")
        eprintf__656_v0 "
" array_98[@]
done
}

# go_up(cnt: Int)
go_up__696_v0() {
    local cnt_3274="${1}"
    local array_99=("")
    eprintf__656_v0 "\\x1b[${cnt_3274}A" array_99[@]
}

# go_down(cnt: Int)
go_down__697_v0() {
    local cnt_3285="${1}"
    local array_100=("")
    eprintf__656_v0 "\\x1b[${cnt_3285}B" array_100[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__701_v0() {
    local pieces_3121=("${!1}")
    term_width__689_v0 
    local width_3127="${ret_term_width689_v0}"
    local line_3128=""
    local line_len_3129=0
    for piece_3130 in "${pieces_3121[@]}"; do
        local __length_103="${piece_3130}"
        local piece_len_3131="${#__length_103}"
        has_ansi_escape__670_v0 "${piece_3130}"
        local ret_has_ansi_escape670_v0__190_12="${ret_has_ansi_escape670_v0}"
        if [ "${ret_has_ansi_escape670_v0__190_12}" != 0 ]; then
            get_visible_len__675_v0 "${piece_3130}"
            piece_len_3131="${ret_get_visible_len675_v0}"
        fi
        if [ "$([ "_${line_3128}" != "_" ]; echo $?)" != 0 ]; then
            line_3128="${piece_3130}"
            line_len_3129="${piece_len_3131}"
        elif [ "$(( $(( $(( line_len_3129 + 1 )) + piece_len_3131 )) > width_3127 ))" != 0 ]; then
            local array_104=()
            printf__128_v0 "${line_3128}""
" array_104[@]
            line_3128="${piece_3130}"
            line_len_3129="${piece_len_3131}"
        else
            line_3128+=" ""${piece_3130}"
            line_len_3129="$(( line_len_3129 + $(( 1 + piece_len_3131 )) ))"
        fi
    done
    if [ "$([ "_${line_3128}" == "_" ]; echo $?)" != 0 ]; then
        local array_105=()
        printf__128_v0 "${line_3128}""
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
get_supports_truecolor__738_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_3159="${ret_env_var_get120_v0}"
    _supports_truecolor_29="$(if [ "$([ "_${config_3159}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor738_v0="$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__739_v0() {
    local message_3154="${1}"
    local r_3155="${2}"
    local g_3156="${3}"
    local b_3157="${4}"
    local fallback_3158="${5}"
    if [ "$([ "_${_supports_truecolor_29}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb739_v0="\\x1b[38;2;${r_3155};${g_3156};${b_3157}m""${message_3154}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_29}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__738_v0 
        local ret_get_supports_truecolor738_v0__45_17="${ret_get_supports_truecolor738_v0}"
        if [ "${ret_get_supports_truecolor738_v0__45_17}" != 0 ]; then
            ret_colored_rgb739_v0="\\x1b[38;2;${r_3155};${g_3156};${b_3157}m""${message_3154}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_3158 == 0 ))" != 0 ]; then
            ret_colored_rgb739_v0="${message_3154}"
            return 0
        else
            ret_colored_rgb739_v0="\\x1b[${fallback_3158}m""${message_3154}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_3158 == 0 ))" != 0 ]; then
            ret_colored_rgb739_v0="${message_3154}"
            return 0
        fi
        ret_colored_rgb739_v0="\\x1b[${fallback_3158}m""${message_3154}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__741_v0() {
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_3148="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_3148}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_3148}" ";"
            local parts_3149=("${ret_split4_v0[@]}")
            local __length_109=("${parts_3149[@]}")
            if [ "$(( ${#__length_109[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3149[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3149[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3149[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3149[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_31=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_3150="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_3150}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_3150}" ";"
            local parts_3151=("${ret_split4_v0[@]}")
            local __length_111=("${parts_3151[@]}")
            if [ "$(( ${#__length_111[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3151[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3151[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3151[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3151[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_32=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_3152="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_3152}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_3152}" ";"
            local parts_3153=("${ret_split4_v0[@]}")
            local __length_113=("${parts_3153[@]}")
            if [ "$(( ${#__length_113[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_3153[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3153[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3153[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_3153[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_30=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__742_v0() {
    inner_get_xylitol_colors__741_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_30=1
}

# colored_primary(message: Text)
colored_primary__743_v0() {
    local message_3147="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__742_v0 
    fi
    colored_rgb__739_v0 "${message_3147}" "${_primary_color_31[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_31[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_31[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_31[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary743_v0="${ret_colored_rgb739_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__744_v0() {
    local message_3161="${1}"
    if [ "$(( ! _got_xylitol_colors_30 ))" != 0 ]; then
        get_xylitol_colors__742_v0 
    fi
    colored_rgb__739_v0 "${message_3161}" "${_secondary_color_32[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_32[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_32[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_32[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary744_v0="${ret_colored_rgb739_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_34="None"
# perl_available()
perl_available__761_v0() {
    if [ "$([ "_${_perl_state_34}" != "_None" ]; echo $?)" != 0 ]; then
        local command_115
        command_115="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3225
        disabled_3225="$([ "_${command_115}" != "_No" ]; echo $?)"
        local command_116
        command_116="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3226
        found_3226="$(( $(( ! disabled_3225 )) && $([ "_${command_116}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_3226}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available761_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__762_v0() {
    local text_3224="${1}"
    perl_available__761_v0 
    local ret_perl_available761_v0__19_12="${ret_perl_available761_v0}"
    if [ "$(( ! ret_perl_available761_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width762_v0=''
        return 1
    fi
    local command_117
    command_117="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3224}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width762_v0=''
        return "${__status}"
    fi
    local width_str_3227="${command_117}"
    parse_int__13_v0 "${width_str_3227}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width762_v0=''
        return "${__status}"
    fi
    local width_3228="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width762_v0="${width_3228}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__763_v0() {
    local text_3235="${1}"
    local max_width_3236="${2}"
    perl_available__761_v0 
    local ret_perl_available761_v0__30_12="${ret_perl_available761_v0}"
    if [ "$(( ! ret_perl_available761_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk763_v0=''
        return 1
    fi
    local command_118
    command_118="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3235}" ${max_width_3236} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk763_v0=''
        return "${__status}"
    fi
    local result_3237="${command_118}"
    ret_perl_truncate_cjk763_v0="${result_3237}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__767_v0() {
    local text_3199="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_119
    command_119="$([[ "${text_3199}" == *$'\x1b'* || "${text_3199}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_3200="${command_119}"
    ret_has_ansi_escape767_v0="$([ "_${has_escape_3200}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__768_v0() {
    local text_3201="${1}"
    local command_120
    command_120="$(printf '%s' "${text_3201}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi768_v0="${command_120}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__769_v0() {
    local text_3220="${1}"
    local command_121
    command_121="$(printf "%s" "${text_3220}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi769_v0="${command_121}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__770_v0() {
    local text_3222="${1}"
    local command_122
    command_122="$(printf "%s" "${text_3222}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3223="${command_122}"
    ret_is_all_ascii770_v0="$([ "_${result_3223}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__771_v0() {
    local text_3217="${1}"
    local command_123
    command_123="$(LC_ALL=C; __t="${text_3217}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_3218="${command_123}"
    parse_int__13_v0 "${measured_3218}"
    __status=$?
    ret_plain_len771_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__772_v0() {
    local text_3216="${1}"
    plain_len__771_v0 "${text_3216}"
    local plain_3219="${ret_plain_len771_v0}"
    if [ "$(( plain_3219 >= 0 ))" != 0 ]; then
        ret_get_visible_len772_v0="${plain_3219}"
        return 0
    fi
    strip_ansi__769_v0 "${text_3216}"
    local stripped_3221="${ret_strip_ansi769_v0}"
    is_all_ascii__770_v0 "${stripped_3221}"
    local ret_is_all_ascii770_v0__46_12="${ret_is_all_ascii770_v0}"
    if [ "$(( ! ret_is_all_ascii770_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__762_v0 "${stripped_3221}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_124="${stripped_3221}"
            ret_get_visible_len772_v0="${#__length_124}"
            return 0
        fi
        ret_get_visible_len772_v0="${ret_perl_get_cjk_width762_v0}"
        return 0
    fi
    local __length_125="${stripped_3221}"
    ret_get_visible_len772_v0="${#__length_125}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__773_v0() {
    local text_3232="${1}"
    local max_width_3233="${2}"
    get_visible_len__772_v0 "${text_3232}"
    local visible_len_3234="${ret_get_visible_len772_v0}"
    if [ "$(( visible_len_3234 <= max_width_3233 ))" != 0 ]; then
        ret_truncate_text773_v0="${text_3232}"
        return 0
    fi
    is_all_ascii__770_v0 "${text_3232}"
    local ret_is_all_ascii770_v0__61_12="${ret_is_all_ascii770_v0}"
    if [ "$(( ! ret_is_all_ascii770_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__763_v0 "${text_3232}" "${max_width_3233}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3232}" | cut -c1-${max_width_3233}
            __status=$?
        fi
        ret_truncate_text773_v0="${ret_perl_truncate_cjk763_v0}"
        return 0
    fi
    local command_126
    command_126="$(printf "%s" "${text_3232}" | cut -c1-${max_width_3233})"
    __status=$?
    ret_truncate_text773_v0="${command_126}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__774_v0() {
    local text_3230="${1}"
    local max_width_3231="${2}"
    has_ansi_escape__767_v0 "${text_3230}"
    local ret_has_ansi_escape767_v0__73_12="${ret_has_ansi_escape767_v0}"
    if [ "$(( ! ret_has_ansi_escape767_v0__73_12 ))" != 0 ]; then
        truncate_text__773_v0 "${text_3230}" "${max_width_3231}"
        ret_truncate_ansi774_v0="${ret_truncate_text773_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_127
    command_127="$([[ "${text_3230}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3238="${command_127}"
    # Replace \x1b[ with newline, then split
    local command_128
    command_128="$(t="${text_3230}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3239="${command_128}"
    split__4_v0 "${replaced_3239}" "
"
    local parts_3240=("${ret_split4_v0[@]}")
    local result_3241=""
    local remaining_width_3242="${max_width_3231}"
    local __range_start_3243=0
    local __length_129=("${parts_3240[@]}")
    local __range_end_3243="${#__length_129[@]}"
    local __dir_3243=$(( ${__range_start_3243} <= ${__range_end_3243} ? 1 : -1 ))
    for (( idx_3243=${__range_start_3243}; idx_3243 * ${__dir_3243} < ${__range_end_3243} * ${__dir_3243}; idx_3243+=${__dir_3243} )); do
        local part_3244="${parts_3240[${idx_3243}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3243 == 0 )) && $([ "_${starts_with_ansi_3238}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3244}" == "_" ]; echo $?) && $(( remaining_width_3242 > 0 )) ))" != 0 ]; then
                truncate_text__773_v0 "${part_3244}" "${remaining_width_3242}"
                local ret_truncate_text773_v0__95_35="${ret_truncate_text773_v0}"
                local truncated_3245="${ret_truncate_text773_v0__95_35}"
                result_3241+="${truncated_3245}"
                get_visible_len__772_v0 "${truncated_3245}"
                local ret_get_visible_len772_v0__97_36="${ret_get_visible_len772_v0}"
                remaining_width_3242="$(( remaining_width_3242 - ret_get_visible_len772_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_130
            command_130="$(__p="${part_3244}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3246="${command_130}"
            if [ "$([ "_${m_idx_3246}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_131
                command_131="$(__p="${part_3244}"; printf "%s" "${__p:0:${m_idx_3246}}")"
                __status=$?
                local ansi_params_3247="${command_131}"
                result_3241+="\\x1b[""${ansi_params_3247}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3246}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_3248="${ret_parse_int13_v0__108_41}"
                local text_start_3249="$(( m_idx_num_3248 + 1 ))"
                local command_132
                command_132="$(__p="${part_3244}"; printf "%s" "${__p:${text_start_3249}}")"
                __status=$?
                local text_part_3250="${command_132}"
                if [ "$(( $([ "_${text_part_3250}" == "_" ]; echo $?) && $(( remaining_width_3242 > 0 )) ))" != 0 ]; then
                    truncate_text__773_v0 "${text_part_3250}" "${remaining_width_3242}"
                    local ret_truncate_text773_v0__112_39="${ret_truncate_text773_v0}"
                    local truncated_3251="${ret_truncate_text773_v0__112_39}"
                    result_3241+="${truncated_3251}"
                    get_visible_len__772_v0 "${truncated_3251}"
                    local ret_get_visible_len772_v0__114_40="${ret_get_visible_len772_v0}"
                    remaining_width_3242="$(( remaining_width_3242 - ret_get_visible_len772_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3244}" == "_" ]; echo $?) && $(( remaining_width_3242 > 0 )) ))" != 0 ]; then
                    truncate_text__773_v0 "${part_3244}" "${remaining_width_3242}"
                    local ret_truncate_text773_v0__119_39="${ret_truncate_text773_v0}"
                    local truncated_3252="${ret_truncate_text773_v0__119_39}"
                    result_3241+="${truncated_3252}"
                    get_visible_len__772_v0 "${truncated_3252}"
                    local ret_get_visible_len772_v0__121_40="${ret_get_visible_len772_v0}"
                    remaining_width_3242="$(( remaining_width_3242 - ret_get_visible_len772_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi774_v0="${result_3241}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__775_v0() {
    local text_3214="${1}"
    local max_width_3215="${2}"
    get_visible_len__772_v0 "${text_3214}"
    local visible_len_3229="${ret_get_visible_len772_v0}"
    if [ "$(( visible_len_3229 <= max_width_3215 ))" != 0 ]; then
        ret_cutoff_text775_v0="${text_3214}"
        return 0
    fi
    truncate_ansi__774_v0 "${text_3214}" "$(( max_width_3215 - 3 ))"
    local ret_truncate_ansi774_v0__137_12="${ret_truncate_ansi774_v0}"
    ret_cutoff_text775_v0="${ret_truncate_ansi774_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__796_v0() {
    local format_3265="${1}"
    local args_3266=("${!2}")
    args_3266=("${format_3265}" "${args_3266[@]}")
    __status=$?
    printf "${args_3266[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__797_v0() {
    local message_3263="${1}"
    local color_3264="${2}"
    # Prints an error message with a specified color.
    local array_133=("${message_3263}")
    eprintf__796_v0 "\\x1b[${color_3264}m%s\\x1b[0m" array_133[@]
}

# colored(message: Text, color: Int)
colored__798_v0() {
    local message_3195="${1}"
    local color_3196="${2}"
    # Returns a text wrapped in color codes.
    ret_colored798_v0="\\x1b[${color_3196}m""${message_3195}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__802_v0() {
    local items_3257=("${!1}")
    local total_len_3258="${2}"
    local term_width_3259="${3}"
    local separator_3260=" • "
    local separator_len_3261=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3258 <= term_width_3259 ))" != 0 ]; then
        local iter_3262=0
        while :
        do
            local __length_134=("${items_3257[@]}")
            if [ "$(( iter_3262 >= ${#__length_134[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3262 > 0 ))" != 0 ]; then
                eprintf_colored__797_v0 "${separator_3260}" 90
            fi
            colored__798_v0 "${items_3257[$(( iter_3262 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored798_v0__23_41="${ret_colored798_v0}"
            local array_135=("")
            eprintf__796_v0 "${items_3257[${iter_3262}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored798_v0__23_41}" array_135[@]
            iter_3262="$(( iter_3262 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3267=0
        local first_3268=1
        local iter_3269=0
        while :
        do
            local __length_136=("${items_3257[@]}")
            if [ "$(( iter_3269 >= ${#__length_136[@]} ))" != 0 ]; then
                break
            fi
            local key_3270="${items_3257[${iter_3269}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3271="${items_3257[$(( iter_3269 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_137="${key_3270}"
            local __length_138="${action_3271}"
            local part_len_3272="$(( $(( ${#__length_137} + 1 )) + ${#__length_138} ))"
            local needed_3273="${part_len_3272}"
            if [ "$(( ! first_3268 ))" != 0 ]; then
                needed_3273="$(( needed_3273 + separator_len_3261 ))"
            fi
            if [ "$(( $(( current_len_3267 + needed_3273 )) > term_width_3259 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3268 ))" != 0 ]; then
                eprintf_colored__797_v0 "${separator_3260}" 90
            fi
            colored__798_v0 "${action_3271}" 2
            local ret_colored798_v0__51_33="${ret_colored798_v0}"
            local array_139=("")
            eprintf__796_v0 "${key_3270}"" ""${ret_colored798_v0__51_33}" array_139[@]
            current_len_3267="$(( current_len_3267 + needed_3273 ))"
            first_3268=0
            iter_3269="$(( iter_3269 + 2 ))"
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
    local size_3174="${1}"
    if [ "$([ "_${size_3174}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size840_v0=0
        return 0
    fi
    split__4_v0 "${size_3174}" " "
    local parts_3175=("${ret_split4_v0[@]}")
    local __length_141=("${parts_3175[@]}")
    if [ "$(( ${#__length_141[@]} != 2 ))" != 0 ]; then
        ret_store_term_size840_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_3175[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_3175[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_38=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size840_v0=1
    return 0
}

# query_term_size()
query_term_size__841_v0() {
    local command_143
    command_143="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_3177="${command_143}"
    store_term_size__840_v0 "${size_3177}"
    ret_query_term_size841_v0="${ret_store_term_size840_v0}"
    return 0
}

# stty_term_size()
stty_term_size__842_v0() {
    local command_144
    command_144="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_3173="${command_144}"
    store_term_size__840_v0 "${size_3173}"
    ret_stty_term_size842_v0="${ret_store_term_size840_v0}"
    return 0
}

# get_term_size()
get_term_size__843_v0() {
    stty_term_size__842_v0 
    local detected_3176="${ret_stty_term_size842_v0}"
    if [ "$(( ! detected_3176 ))" != 0 ]; then
        query_term_size__841_v0 
        detected_3176="${ret_query_term_size841_v0}"
    fi
    _got_term_size_37=1
}

# term_width()
term_width__845_v0() {
    if [ "$(( ! _got_term_size_37 ))" != 0 ]; then
        get_term_size__843_v0 
    fi
    ret_term_width845_v0="${_term_size_38[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__878_v0() {
    local pending_3192="${1}"
    local line_3193="${2}"
    local note_at_3194="${3}"
    if [ "$(( note_at_3194 < 0 ))" != 0 ]; then
        local array_146=()
        printf__128_v0 "${pending_3192}""${line_3193}""
" array_146[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_3194 == 0 ))" != 0 ]; then
        colored__798_v0 "${line_3193}" 90
        local ret_colored798_v0__12_40="${ret_colored798_v0}"
        local array_147=()
        printf__128_v0 "${pending_3192}""${ret_colored798_v0__12_40}""
" array_147[@]
    else
        slice__24_v0 "${line_3193}" 0 "${note_at_3194}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_3193}" "${note_at_3194}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__798_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored798_v0__13_58="${ret_colored798_v0}"
        local array_148=()
        printf__128_v0 "${pending_3192}""${ret_slice24_v0__13_32}""${ret_colored798_v0__13_58}""
" array_148[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__879_v0() {
    local names_3165=("${!1}")
    local texts_3166=("${!2}")
    local notes_3167=("${!3}")
    local min_name_width_3168="${4}"
    local __length_149=("${names_3165[@]}")
    local count_3169="${#__length_149[@]}"
    local name_width_3170="${min_name_width_3168}"
    local __range_start_3171=0
    local __range_end_3171="${count_3169}"
    local __dir_3171=$(( ${__range_start_3171} <= ${__range_end_3171} ? 1 : -1 ))
    for (( i_3171=${__range_start_3171}; i_3171 * ${__dir_3171} < ${__range_end_3171} * ${__dir_3171}; i_3171+=${__dir_3171} )); do
        local __length_150="${names_3165[${i_3171}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_3172="${#__length_150}"
        if [ "$(( width_3172 > name_width_3170 ))" != 0 ]; then
            name_width_3170="${width_3172}"
        fi
done
    term_width__845_v0 
    local width_3178="${ret_term_width845_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_3179="$(( name_width_3170 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_3180="$(( $(( width_3178 - indent_3179 )) < 24 ))"
    if [ "${stacked_3180}" != 0 ]; then
        indent_3179=6
    fi
    local avail_3181="$(( width_3178 - indent_3179 ))"
    rpad__28_v0 "" " " "${indent_3179}"
    local blank_3182="${ret_rpad28_v0}"
    local __range_start_3183=0
    local __range_end_3183="${count_3169}"
    local __dir_3183=$(( ${__range_start_3183} <= ${__range_end_3183} ? 1 : -1 ))
    for (( i_3183=${__range_start_3183}; i_3183 * ${__dir_3183} < ${__range_end_3183} * ${__dir_3183}; i_3183+=${__dir_3183} )); do
        local pending_3184="${blank_3182}"
        if [ "${stacked_3180}" != 0 ]; then
            local array_151=()
            printf__128_v0 "  ""${names_3165[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_151[@]
        else
            rpad__28_v0 "  ""${names_3165[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_3179}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_3184="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_3166[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_3185=("${ret_split4_v0__52_21[@]}")
        local __length_152=("${words_3185[@]}")
        local note_start_3186="${#__length_152[@]}"
        if [ "$([ "_${notes_3167[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_153="${notes_3167[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_153} > avail_3181 ))" != 0 ]; then
                split__4_v0 "${notes_3167[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_3185+=("${ret_split4_v0__58_26[@]}")
            else
                local array_154=("${notes_3167[${i_3183}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_3185+=("${array_154[@]}")
            fi
        fi
        local line_3187=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_3188=-1
        local __range_start_3189=0
        local __length_155=("${words_3185[@]}")
        local __range_end_3189="${#__length_155[@]}"
        local __dir_3189=$(( ${__range_start_3189} <= ${__range_end_3189} ? 1 : -1 ))
        for (( j_3189=${__range_start_3189}; j_3189 * ${__dir_3189} < ${__range_end_3189} * ${__dir_3189}; j_3189+=${__dir_3189} )); do
            local word_3190="${words_3185[${j_3189}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_3191
            candidate_3191="$(if [ "$([ "_${line_3187}" != "_" ]; echo $?)" != 0 ]; then echo "${word_3190}"; else echo "${line_3187}"" ""${word_3190}"; fi)"
            local __length_156="${candidate_3191}"
            if [ "$(( $(( ${#__length_156} > avail_3181 )) && $([ "_${line_3187}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__878_v0 "${pending_3184}" "${line_3187}" "${note_at_3188}"
                pending_3184="${blank_3182}"
                line_3187="${word_3190}"
                note_at_3188="$(if [ "$(( j_3189 >= note_start_3186 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_3189 >= note_start_3186 )) && $(( note_at_3188 < 0 )) ))" != 0 ]; then
                    local __length_157="${candidate_3191}"
                    local __length_158="${word_3190}"
                    note_at_3188="$(( ${#__length_157} - ${#__length_158} ))"
                fi
                line_3187="${candidate_3191}"
            fi
done
        print_help_line__878_v0 "${pending_3184}" "${line_3187}" "${note_at_3188}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__937_v0() {
    local prompt_3203="${1}"
    local placeholder_3204="${2}"
    local header_3205="${3}"
    local password_3206="${4}"
    stty_lock__682_v0 
    term_width__689_v0 
    local term_width_3213="${ret_term_width689_v0}"
    if [ "$([ "_${header_3205}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__775_v0 "${header_3205}" "${term_width_3213}"
        local ret_cutoff_text775_v0__24_17="${ret_cutoff_text775_v0}"
        local array_159=("")
        eprintf__640_v0 "${ret_cutoff_text775_v0__24_17}""
" array_159[@]
    fi
    new_line__695_v0 2
    # "enter submit" = 12
    local array_160=("enter" "submit")
    render_tooltip__802_v0 array_160[@] 12 "${term_width_3213}"
    go_up__696_v0 2
    local array_161=("")
    eprintf__640_v0 "\\x1b[G" array_161[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_162
    command_162="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3275="${command_162}"
    local char_3276=""
    local array_163=("")
    eprintf__640_v0 "${prompt_3203}" array_163[@]
    if [ "$([ "_${can_preset_3275}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__641_v0 "${placeholder_3204}" 90
        get_char__637_v0 
        char_3276="${ret_get_char637_v0}"
        local __length_164="${placeholder_3204}"
        remove__691_v0 "$(( ${#__length_164} + 1 ))"
    fi
    local __length_165="${prompt_3203}"
    remove__691_v0 "${#__length_165}"
    local text_3281=""
    if [ "$(( ! password_3206 ))" != 0 ]; then
        stty_unlock__683_v0 
        local command_166
        command_166="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3276}" -p "${prompt_3203}" text < /dev/tty; else read -e -p "${prompt_3203}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3281="${command_166}"
        stty_lock__682_v0 
    else
        local command_167
        command_167="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3276}" -p "${prompt_3203}" text < /dev/tty; else read -es -p "${prompt_3203}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3281="${command_167}"
    fi
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__772_v0 "${prompt_3203}""${text_3281}"
    local input_display_len_3283="${ret_get_visible_len772_v0}"
    local input_lines_3284="$(( $(( $(( input_display_len_3283 + term_width_3213 )) - 1 )) / term_width_3213 ))"
    if [ "$(( input_lines_3284 < 1 ))" != 0 ]; then
        input_lines_3284=1
    fi
    if [ "$(( input_lines_3284 < 3 ))" != 0 ]; then
        go_down__697_v0 "$(( 2 - input_lines_3284 ))"
        remove_line__692_v0 2
        remove_current_line__693_v0 
    fi
    if [ "$(( input_lines_3284 >= 3 ))" != 0 ]; then
        remove_line__692_v0 "${input_lines_3284}"
    fi
    if [ "$([ "_${header_3205}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__692_v0 1
        remove_current_line__693_v0 
    fi
    stty_unlock__683_v0 
    ret_xyl_input937_v0="${text_3281}"
    return 0
}

# print_input_help()
print_input_help__1037_v0() {
    local usage_3120=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__701_v0 usage_3120[@]
    printf '%s\n' ""
    colored_primary__743_v0 "input"
    local ret_colored_primary743_v0__8_20="${ret_colored_primary743_v0}"
    local title_3160=("${ret_colored_primary743_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__701_v0 title_3160[@]
    printf '%s\n' ""
    colored_secondary__744_v0 "Flags:"
    local ret_colored_secondary744_v0__11_12="${ret_colored_secondary744_v0}"
    local array_170=()
    printf__128_v0 "${ret_colored_secondary744_v0__11_12}""
" array_170[@]
    local names_3162=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_3163=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_3164=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__879_v0 names_3162[@] texts_3163[@] notes_3164[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1095_v0() {
    local parameters_3114=("${!1}")
    local prompt_3115="> "
    local placeholder_3116="Type here..."
    local header_3117=""
    local password_3118=0
    for param_3119 in "${parameters_3114[@]}"; do
        if [ "$(( $([ "_${param_3119}" != "_-h" ]; echo $?) || $([ "_${param_3119}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__1037_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_3119}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_176="--prompt="
            slice__24_v0 "${param_3119}" "${#__length_176}" 0
            prompt_3115="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3119}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_177="--placeholder="
            slice__24_v0 "${param_3119}" "${#__length_177}" 0
            placeholder_3116="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_3119}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_178="--header="
            slice__24_v0 "${param_3119}" "${#__length_178}" 0
            header_3117="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_3119}" != "_--password" ]; echo $?)" != 0 ]; then
            password_3118=1
        fi
    done
    has_ansi_escape__767_v0 "${header_3117}"
    local ret_has_ansi_escape767_v0__31_44="${ret_has_ansi_escape767_v0}"
    escape_ansi__768_v0 "${header_3117}"
    local ret_escape_ansi768_v0__31_73="${ret_escape_ansi768_v0}"
    colored_primary__743_v0 "${header_3117}"
    local ret_colored_primary743_v0__31_111="${ret_colored_primary743_v0}"
    local display_header_3202
    display_header_3202="$(if [ "$(( $([ "_${header_3117}" != "_" ]; echo $?) || ret_has_ansi_escape767_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi768_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary743_v0__31_111}"; fi)"
    xyl_input__937_v0 "${prompt_3115}" "${placeholder_3116}" "${display_header_3202}" "${password_3118}"
    ret_execute_input1095_v0="${ret_xyl_input937_v0}"
    return 0
}

# get_key()
get_key__1176_v0() {
    local command_179
    command_179="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1176_v0="${command_179}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1178_v0() {
    local format_18021="${1}"
    local args_18022=("${!2}")
    args_18022=("${format_18021}" "${args_18022[@]}")
    __status=$?
    printf "${args_18022[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1179_v0() {
    local message_18019="${1}"
    local color_18020="${2}"
    # Prints an error message with a specified color.
    local array_180=("${message_18019}")
    eprintf__1178_v0 "\\x1b[${color_18020}m%s\\x1b[0m" array_180[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1194_v0() {
    local format_18044="${1}"
    local args_18045=("${!2}")
    args_18045=("${format_18044}" "${args_18045[@]}")
    __status=$?
    printf "${args_18045[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1195_v0() {
    local message_18042="${1}"
    local color_18043="${2}"
    # Prints an error message with a specified color.
    local array_181=("${message_18042}")
    eprintf__1194_v0 "\\x1b[${color_18043}m%s\\x1b[0m" array_181[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_46="None"
# perl_available()
perl_available__1202_v0() {
    if [ "$([ "_${_perl_state_46}" != "_None" ]; echo $?)" != 0 ]; then
        local command_182
        command_182="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_17974
        disabled_17974="$([ "_${command_182}" != "_No" ]; echo $?)"
        local command_183
        command_183="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_17975
        found_17975="$(( $(( ! disabled_17974 )) && $([ "_${command_183}" != "_0" ]; echo $?) ))"
        _perl_state_46="$(if [ "${found_17975}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1202_v0="$([ "_${_perl_state_46}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1203_v0() {
    local text_17973="${1}"
    perl_available__1202_v0 
    local ret_perl_available1202_v0__19_12="${ret_perl_available1202_v0}"
    if [ "$(( ! ret_perl_available1202_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1203_v0=''
        return 1
    fi
    local command_184
    command_184="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_17973}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1203_v0=''
        return "${__status}"
    fi
    local width_str_17976="${command_184}"
    parse_int__13_v0 "${width_str_17976}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1203_v0=''
        return "${__status}"
    fi
    local width_17977="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1203_v0="${width_17977}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1208_v0() {
    local text_17963="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_185
    command_185="$([[ "${text_17963}" == *$'\x1b'* || "${text_17963}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_17964="${command_185}"
    ret_has_ansi_escape1208_v0="$([ "_${has_escape_17964}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1210_v0() {
    local text_17969="${1}"
    local command_186
    command_186="$(printf "%s" "${text_17969}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1210_v0="${command_186}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1211_v0() {
    local text_17971="${1}"
    local command_187
    command_187="$(printf "%s" "${text_17971}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_17972="${command_187}"
    ret_is_all_ascii1211_v0="$([ "_${result_17972}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1212_v0() {
    local text_17966="${1}"
    local command_188
    command_188="$(LC_ALL=C; __t="${text_17966}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_17967="${command_188}"
    parse_int__13_v0 "${measured_17967}"
    __status=$?
    ret_plain_len1212_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1213_v0() {
    local text_17965="${1}"
    plain_len__1212_v0 "${text_17965}"
    local plain_17968="${ret_plain_len1212_v0}"
    if [ "$(( plain_17968 >= 0 ))" != 0 ]; then
        ret_get_visible_len1213_v0="${plain_17968}"
        return 0
    fi
    strip_ansi__1210_v0 "${text_17965}"
    local stripped_17970="${ret_strip_ansi1210_v0}"
    is_all_ascii__1211_v0 "${stripped_17970}"
    local ret_is_all_ascii1211_v0__46_12="${ret_is_all_ascii1211_v0}"
    if [ "$(( ! ret_is_all_ascii1211_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1203_v0 "${stripped_17970}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_189="${stripped_17970}"
            ret_get_visible_len1213_v0="${#__length_189}"
            return 0
        fi
        ret_get_visible_len1213_v0="${ret_perl_get_cjk_width1203_v0}"
        return 0
    fi
    local __length_190="${stripped_17970}"
    ret_get_visible_len1213_v0="${#__length_190}"
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
stty_count__1219_v0() {
    local command_192
    command_192="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_18040="${command_192}"
    parse_int__13_v0 "${count_18040}"
    __status=$?
    ret_stty_count1219_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1220_v0() {
    stty_count__1219_v0 
    local count_num_18041="${ret_stty_count1219_v0}"
    if [ "$(( count_num_18041 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 2>/dev/null < /dev/tty
        __status=$?
        if [ "${__status}" != 0 ]; then
            eprintf_colored__1195_v0 "Error: " 91
            local array_193=("")
            eprintf__1194_v0 "xylitol needs a terminal, and /dev/tty is not available here.
" array_193[@]
            exit 1
        fi
    fi
    count_num_18041="$(( count_num_18041 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18041}
    __status=$?
}

# stty_unlock()
stty_unlock__1221_v0() {
    stty_count__1219_v0 
    local count_num_18163="${ret_stty_count1219_v0}"
    if [ "$(( count_num_18163 > 0 ))" != 0 ]; then
        count_num_18163="$(( count_num_18163 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18163}
        __status=$?
        if [ "$(( count_num_18163 == 0 ))" != 0 ]; then
            stty echo icanon 2>/dev/null < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1222_v0() {
    local size_17954="${1}"
    if [ "$([ "_${size_17954}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1222_v0=0
        return 0
    fi
    split__4_v0 "${size_17954}" " "
    local parts_17955=("${ret_split4_v0[@]}")
    local __length_194=("${parts_17955[@]}")
    if [ "$(( ${#__length_194[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1222_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17955[1]?"Index out of bounds (at src/./choose/../utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17955[0]?"Index out of bounds (at src/./choose/../utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_48=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size1222_v0=1
    return 0
}

# query_term_size()
query_term_size__1223_v0() {
    local command_196
    command_196="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_17957="${command_196}"
    store_term_size__1222_v0 "${size_17957}"
    ret_query_term_size1223_v0="${ret_store_term_size1222_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1224_v0() {
    local command_197
    command_197="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17953="${command_197}"
    store_term_size__1222_v0 "${size_17953}"
    ret_stty_term_size1224_v0="${ret_store_term_size1222_v0}"
    return 0
}

# get_term_size()
get_term_size__1225_v0() {
    stty_term_size__1224_v0 
    local detected_17956="${ret_stty_term_size1224_v0}"
    if [ "$(( ! detected_17956 ))" != 0 ]; then
        query_term_size__1223_v0 
        detected_17956="${ret_query_term_size1223_v0}"
    fi
    _got_term_size_47=1
}

# term_width()
term_width__1227_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1225_v0 
    fi
    ret_term_width1227_v0="${_term_size_48[0]?"Index out of bounds (at src/./choose/../utils/term.ab:100:23)"}"
    return 0
}

# term_height()
term_height__1228_v0() {
    if [ "$(( ! _got_term_size_47 ))" != 0 ]; then
        get_term_size__1225_v0 
    fi
    ret_term_height1228_v0="${_term_size_48[1]?"Index out of bounds (at src/./choose/../utils/term.ab:108:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1230_v0() {
    local cnt_18135="${1}"
    if [ "$(( cnt_18135 > 0 ))" != 0 ]; then
        local sequence_18136=""
        local __range_start_18137=0
        local __range_end_18137="${cnt_18135}"
        local __dir_18137=$(( ${__range_start_18137} <= ${__range_end_18137} ? 1 : -1 ))
        for (( ____18137=${__range_start_18137}; ____18137 * ${__dir_18137} < ${__range_end_18137} * ${__dir_18137}; ____18137+=${__dir_18137} )); do
            sequence_18136+="\\x1b[2K\\x1b[1A"
done
        local array_198=("")
        eprintf__1194_v0 "${sequence_18136}" array_198[@]
    fi
    local array_199=("")
    eprintf__1194_v0 "\\x1b[G" array_199[@]
}

# remove_current_line()
remove_current_line__1231_v0() {
    local array_200=("")
    eprintf__1194_v0 "\\x1b[2K\\x1b[G" array_200[@]
}

# print_blank(cnt: Int)
print_blank__1232_v0() {
    local cnt_18126="${1}"
    printf '%*s' "${cnt_18126}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1233_v0() {
    local cnt_18090="${1}"
    local __range_start_18091=0
    local __range_end_18091="${cnt_18090}"
    local __dir_18091=$(( ${__range_start_18091} <= ${__range_end_18091} ? 1 : -1 ))
    for (( ____18091=${__range_start_18091}; ____18091 * ${__dir_18091} < ${__range_end_18091} * ${__dir_18091}; ____18091+=${__dir_18091} )); do
        local array_201=("")
        eprintf__1194_v0 "
" array_201[@]
done
}

# go_up(cnt: Int)
go_up__1234_v0() {
    local cnt_18109="${1}"
    local array_202=("")
    eprintf__1194_v0 "\\x1b[${cnt_18109}A" array_202[@]
}

# go_down(cnt: Int)
go_down__1235_v0() {
    local cnt_18162="${1}"
    local array_203=("")
    eprintf__1194_v0 "\\x1b[${cnt_18162}B" array_203[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1237_v0() {
    local array_204=("")
    eprintf__1194_v0 "\\x1b[?25l" array_204[@]
}

# show_cursor()
show_cursor__1238_v0() {
    local array_205=("")
    eprintf__1194_v0 "\\x1b[?25h" array_205[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1239_v0() {
    local pieces_17952=("${!1}")
    term_width__1227_v0 
    local width_17958="${ret_term_width1227_v0}"
    local line_17959=""
    local line_len_17960=0
    for piece_17961 in "${pieces_17952[@]}"; do
        local __length_208="${piece_17961}"
        local piece_len_17962="${#__length_208}"
        has_ansi_escape__1208_v0 "${piece_17961}"
        local ret_has_ansi_escape1208_v0__190_12="${ret_has_ansi_escape1208_v0}"
        if [ "${ret_has_ansi_escape1208_v0__190_12}" != 0 ]; then
            get_visible_len__1213_v0 "${piece_17961}"
            piece_len_17962="${ret_get_visible_len1213_v0}"
        fi
        if [ "$([ "_${line_17959}" != "_" ]; echo $?)" != 0 ]; then
            line_17959="${piece_17961}"
            line_len_17960="${piece_len_17962}"
        elif [ "$(( $(( $(( line_len_17960 + 1 )) + piece_len_17962 )) > width_17958 ))" != 0 ]; then
            local array_209=()
            printf__128_v0 "${line_17959}""
" array_209[@]
            line_17959="${piece_17961}"
            line_len_17960="${piece_len_17962}"
        else
            line_17959+=" ""${piece_17961}"
            line_len_17960="$(( line_len_17960 + $(( 1 + piece_len_17962 )) ))"
        fi
    done
    if [ "$([ "_${line_17959}" == "_" ]; echo $?)" != 0 ]; then
        local array_210=()
        printf__128_v0 "${line_17959}""
" array_210[@]
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
get_supports_truecolor__1276_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_17942="${ret_env_var_get120_v0}"
    _supports_truecolor_51="$(if [ "$([ "_${config_17942}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1276_v0="$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1277_v0() {
    local message_17937="${1}"
    local r_17938="${2}"
    local g_17939="${3}"
    local b_17940="${4}"
    local fallback_17941="${5}"
    if [ "$([ "_${_supports_truecolor_51}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1277_v0="\\x1b[38;2;${r_17938};${g_17939};${b_17940}m""${message_17937}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_51}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1276_v0 
        local ret_get_supports_truecolor1276_v0__45_17="${ret_get_supports_truecolor1276_v0}"
        if [ "${ret_get_supports_truecolor1276_v0__45_17}" != 0 ]; then
            ret_colored_rgb1277_v0="\\x1b[38;2;${r_17938};${g_17939};${b_17940}m""${message_17937}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_17941 == 0 ))" != 0 ]; then
            ret_colored_rgb1277_v0="${message_17937}"
            return 0
        else
            ret_colored_rgb1277_v0="\\x1b[${fallback_17941}m""${message_17937}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_17941 == 0 ))" != 0 ]; then
            ret_colored_rgb1277_v0="${message_17937}"
            return 0
        fi
        ret_colored_rgb1277_v0="\\x1b[${fallback_17941}m""${message_17937}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1279_v0() {
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_17931="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_17931}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_17931}" ";"
            local parts_17932=("${ret_split4_v0[@]}")
            local __length_214=("${parts_17932[@]}")
            if [ "$(( ${#__length_214[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17932[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17932[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17932[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17932[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_53=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_17933="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_17933}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_17933}" ";"
            local parts_17934=("${ret_split4_v0[@]}")
            local __length_216=("${parts_17934[@]}")
            if [ "$(( ${#__length_216[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17934[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17934[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17934[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17934[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_54=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_17935="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_17935}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_17935}" ";"
            local parts_17936=("${ret_split4_v0[@]}")
            local __length_218=("${parts_17936[@]}")
            if [ "$(( ${#__length_218[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_17936[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17936[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17936[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_17936[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1279_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_52=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1280_v0() {
    inner_get_xylitol_colors__1279_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_52=1
}

# colored_primary(message: Text)
colored_primary__1281_v0() {
    local message_17930="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1280_v0 
    fi
    colored_rgb__1277_v0 "${message_17930}" "${_primary_color_53[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_53[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_53[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_53[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1281_v0="${ret_colored_rgb1277_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1282_v0() {
    local message_17979="${1}"
    if [ "$(( ! _got_xylitol_colors_52 ))" != 0 ]; then
        get_xylitol_colors__1280_v0 
    fi
    colored_rgb__1277_v0 "${message_17979}" "${_secondary_color_54[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_54[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_54[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_54[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1282_v0="${ret_colored_rgb1277_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_56="None"
# perl_available()
perl_available__1299_v0() {
    if [ "$([ "_${_perl_state_56}" != "_None" ]; echo $?)" != 0 ]; then
        local command_220
        command_220="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18059
        disabled_18059="$([ "_${command_220}" != "_No" ]; echo $?)"
        local command_221
        command_221="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18060
        found_18060="$(( $(( ! disabled_18059 )) && $([ "_${command_221}" != "_0" ]; echo $?) ))"
        _perl_state_56="$(if [ "${found_18060}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1299_v0="$([ "_${_perl_state_56}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1300_v0() {
    local text_18058="${1}"
    perl_available__1299_v0 
    local ret_perl_available1299_v0__19_12="${ret_perl_available1299_v0}"
    if [ "$(( ! ret_perl_available1299_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1300_v0=''
        return 1
    fi
    local command_222
    command_222="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18058}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1300_v0=''
        return "${__status}"
    fi
    local width_str_18061="${command_222}"
    parse_int__13_v0 "${width_str_18061}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1300_v0=''
        return "${__status}"
    fi
    local width_18062="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1300_v0="${width_18062}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1301_v0() {
    local text_18069="${1}"
    local max_width_18070="${2}"
    perl_available__1299_v0 
    local ret_perl_available1299_v0__30_12="${ret_perl_available1299_v0}"
    if [ "$(( ! ret_perl_available1299_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1301_v0=''
        return 1
    fi
    local command_223
    command_223="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18069}" ${max_width_18070} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1301_v0=''
        return "${__status}"
    fi
    local result_18071="${command_223}"
    ret_perl_truncate_cjk1301_v0="${result_18071}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1305_v0() {
    local text_18024="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_224
    command_224="$([[ "${text_18024}" == *$'\x1b'* || "${text_18024}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18025="${command_224}"
    ret_has_ansi_escape1305_v0="$([ "_${has_escape_18025}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1306_v0() {
    local text_18026="${1}"
    local command_225
    command_225="$(printf '%s' "${text_18026}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1306_v0="${command_225}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1307_v0() {
    local text_18054="${1}"
    local command_226
    command_226="$(printf "%s" "${text_18054}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1307_v0="${command_226}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1308_v0() {
    local text_18056="${1}"
    local command_227
    command_227="$(printf "%s" "${text_18056}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18057="${command_227}"
    ret_is_all_ascii1308_v0="$([ "_${result_18057}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1309_v0() {
    local text_18051="${1}"
    local command_228
    command_228="$(LC_ALL=C; __t="${text_18051}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_18052="${command_228}"
    parse_int__13_v0 "${measured_18052}"
    __status=$?
    ret_plain_len1309_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1310_v0() {
    local text_18050="${1}"
    plain_len__1309_v0 "${text_18050}"
    local plain_18053="${ret_plain_len1309_v0}"
    if [ "$(( plain_18053 >= 0 ))" != 0 ]; then
        ret_get_visible_len1310_v0="${plain_18053}"
        return 0
    fi
    strip_ansi__1307_v0 "${text_18050}"
    local stripped_18055="${ret_strip_ansi1307_v0}"
    is_all_ascii__1308_v0 "${stripped_18055}"
    local ret_is_all_ascii1308_v0__46_12="${ret_is_all_ascii1308_v0}"
    if [ "$(( ! ret_is_all_ascii1308_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1300_v0 "${stripped_18055}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_229="${stripped_18055}"
            ret_get_visible_len1310_v0="${#__length_229}"
            return 0
        fi
        ret_get_visible_len1310_v0="${ret_perl_get_cjk_width1300_v0}"
        return 0
    fi
    local __length_230="${stripped_18055}"
    ret_get_visible_len1310_v0="${#__length_230}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1311_v0() {
    local text_18066="${1}"
    local max_width_18067="${2}"
    get_visible_len__1310_v0 "${text_18066}"
    local visible_len_18068="${ret_get_visible_len1310_v0}"
    if [ "$(( visible_len_18068 <= max_width_18067 ))" != 0 ]; then
        ret_truncate_text1311_v0="${text_18066}"
        return 0
    fi
    is_all_ascii__1308_v0 "${text_18066}"
    local ret_is_all_ascii1308_v0__61_12="${ret_is_all_ascii1308_v0}"
    if [ "$(( ! ret_is_all_ascii1308_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1301_v0 "${text_18066}" "${max_width_18067}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18066}" | cut -c1-${max_width_18067}
            __status=$?
        fi
        ret_truncate_text1311_v0="${ret_perl_truncate_cjk1301_v0}"
        return 0
    fi
    local command_231
    command_231="$(printf "%s" "${text_18066}" | cut -c1-${max_width_18067})"
    __status=$?
    ret_truncate_text1311_v0="${command_231}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1312_v0() {
    local text_18064="${1}"
    local max_width_18065="${2}"
    has_ansi_escape__1305_v0 "${text_18064}"
    local ret_has_ansi_escape1305_v0__73_12="${ret_has_ansi_escape1305_v0}"
    if [ "$(( ! ret_has_ansi_escape1305_v0__73_12 ))" != 0 ]; then
        truncate_text__1311_v0 "${text_18064}" "${max_width_18065}"
        ret_truncate_ansi1312_v0="${ret_truncate_text1311_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_232
    command_232="$([[ "${text_18064}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18072="${command_232}"
    # Replace \x1b[ with newline, then split
    local command_233
    command_233="$(t="${text_18064}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18073="${command_233}"
    split__4_v0 "${replaced_18073}" "
"
    local parts_18074=("${ret_split4_v0[@]}")
    local result_18075=""
    local remaining_width_18076="${max_width_18065}"
    local __range_start_18077=0
    local __length_234=("${parts_18074[@]}")
    local __range_end_18077="${#__length_234[@]}"
    local __dir_18077=$(( ${__range_start_18077} <= ${__range_end_18077} ? 1 : -1 ))
    for (( idx_18077=${__range_start_18077}; idx_18077 * ${__dir_18077} < ${__range_end_18077} * ${__dir_18077}; idx_18077+=${__dir_18077} )); do
        local part_18078="${parts_18074[${idx_18077}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18077 == 0 )) && $([ "_${starts_with_ansi_18072}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18078}" == "_" ]; echo $?) && $(( remaining_width_18076 > 0 )) ))" != 0 ]; then
                truncate_text__1311_v0 "${part_18078}" "${remaining_width_18076}"
                local ret_truncate_text1311_v0__95_35="${ret_truncate_text1311_v0}"
                local truncated_18079="${ret_truncate_text1311_v0__95_35}"
                result_18075+="${truncated_18079}"
                get_visible_len__1310_v0 "${truncated_18079}"
                local ret_get_visible_len1310_v0__97_36="${ret_get_visible_len1310_v0}"
                remaining_width_18076="$(( remaining_width_18076 - ret_get_visible_len1310_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_235
            command_235="$(__p="${part_18078}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18080="${command_235}"
            if [ "$([ "_${m_idx_18080}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_236
                command_236="$(__p="${part_18078}"; printf "%s" "${__p:0:${m_idx_18080}}")"
                __status=$?
                local ansi_params_18081="${command_236}"
                result_18075+="\\x1b[""${ansi_params_18081}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18080}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_18082="${ret_parse_int13_v0__108_41}"
                local text_start_18083="$(( m_idx_num_18082 + 1 ))"
                local command_237
                command_237="$(__p="${part_18078}"; printf "%s" "${__p:${text_start_18083}}")"
                __status=$?
                local text_part_18084="${command_237}"
                if [ "$(( $([ "_${text_part_18084}" == "_" ]; echo $?) && $(( remaining_width_18076 > 0 )) ))" != 0 ]; then
                    truncate_text__1311_v0 "${text_part_18084}" "${remaining_width_18076}"
                    local ret_truncate_text1311_v0__112_39="${ret_truncate_text1311_v0}"
                    local truncated_18085="${ret_truncate_text1311_v0__112_39}"
                    result_18075+="${truncated_18085}"
                    get_visible_len__1310_v0 "${truncated_18085}"
                    local ret_get_visible_len1310_v0__114_40="${ret_get_visible_len1310_v0}"
                    remaining_width_18076="$(( remaining_width_18076 - ret_get_visible_len1310_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18078}" == "_" ]; echo $?) && $(( remaining_width_18076 > 0 )) ))" != 0 ]; then
                    truncate_text__1311_v0 "${part_18078}" "${remaining_width_18076}"
                    local ret_truncate_text1311_v0__119_39="${ret_truncate_text1311_v0}"
                    local truncated_18086="${ret_truncate_text1311_v0__119_39}"
                    result_18075+="${truncated_18086}"
                    get_visible_len__1310_v0 "${truncated_18086}"
                    local ret_get_visible_len1310_v0__121_40="${ret_get_visible_len1310_v0}"
                    remaining_width_18076="$(( remaining_width_18076 - ret_get_visible_len1310_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1312_v0="${result_18075}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1313_v0() {
    local text_18048="${1}"
    local max_width_18049="${2}"
    get_visible_len__1310_v0 "${text_18048}"
    local visible_len_18063="${ret_get_visible_len1310_v0}"
    if [ "$(( visible_len_18063 <= max_width_18049 ))" != 0 ]; then
        ret_cutoff_text1313_v0="${text_18048}"
        return 0
    fi
    truncate_ansi__1312_v0 "${text_18048}" "$(( max_width_18049 - 3 ))"
    local ret_truncate_ansi1312_v0__137_12="${ret_truncate_ansi1312_v0}"
    ret_cutoff_text1313_v0="${ret_truncate_ansi1312_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__1334_v0() {
    local format_18100="${1}"
    local args_18101=("${!2}")
    args_18101=("${format_18100}" "${args_18101[@]}")
    __status=$?
    printf "${args_18101[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1335_v0() {
    local message_18098="${1}"
    local color_18099="${2}"
    # Prints an error message with a specified color.
    local array_238=("${message_18098}")
    eprintf__1334_v0 "\\x1b[${color_18099}m%s\\x1b[0m" array_238[@]
}

# colored(message: Text, color: Int)
colored__1336_v0() {
    local message_18013="${1}"
    local color_18014="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1336_v0="\\x1b[${color_18014}m""${message_18013}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1340_v0() {
    local items_18092=("${!1}")
    local total_len_18093="${2}"
    local term_width_18094="${3}"
    local separator_18095=" • "
    local separator_len_18096=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18093 <= term_width_18094 ))" != 0 ]; then
        local iter_18097=0
        while :
        do
            local __length_239=("${items_18092[@]}")
            if [ "$(( iter_18097 >= ${#__length_239[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18097 > 0 ))" != 0 ]; then
                eprintf_colored__1335_v0 "${separator_18095}" 90
            fi
            colored__1336_v0 "${items_18092[$(( iter_18097 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1336_v0__23_41="${ret_colored1336_v0}"
            local array_240=("")
            eprintf__1334_v0 "${items_18092[${iter_18097}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1336_v0__23_41}" array_240[@]
            iter_18097="$(( iter_18097 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18102=0
        local first_18103=1
        local iter_18104=0
        while :
        do
            local __length_241=("${items_18092[@]}")
            if [ "$(( iter_18104 >= ${#__length_241[@]} ))" != 0 ]; then
                break
            fi
            local key_18105="${items_18092[${iter_18104}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_18106="${items_18092[$(( iter_18104 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_242="${key_18105}"
            local __length_243="${action_18106}"
            local part_len_18107="$(( $(( ${#__length_242} + 1 )) + ${#__length_243} ))"
            local needed_18108="${part_len_18107}"
            if [ "$(( ! first_18103 ))" != 0 ]; then
                needed_18108="$(( needed_18108 + separator_len_18096 ))"
            fi
            if [ "$(( $(( current_len_18102 + needed_18108 )) > term_width_18094 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18103 ))" != 0 ]; then
                eprintf_colored__1335_v0 "${separator_18095}" 90
            fi
            colored__1336_v0 "${action_18106}" 2
            local ret_colored1336_v0__51_33="${ret_colored1336_v0}"
            local array_244=("")
            eprintf__1334_v0 "${key_18105}"" ""${ret_colored1336_v0__51_33}" array_244[@]
            current_len_18102="$(( current_len_18102 + needed_18108 ))"
            first_18103=0
            iter_18104="$(( iter_18104 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1350_v0() {
    local format_18151="${1}"
    local args_18152=("${!2}")
    args_18152=("${format_18151}" "${args_18152[@]}")
    __status=$?
    printf "${args_18152[@]}" >&2
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
store_term_size__1378_v0() {
    local size_17992="${1}"
    if [ "$([ "_${size_17992}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1378_v0=0
        return 0
    fi
    split__4_v0 "${size_17992}" " "
    local parts_17993=("${ret_split4_v0[@]}")
    local __length_246=("${parts_17993[@]}")
    if [ "$(( ${#__length_246[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1378_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_17993[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_17993[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_60=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size1378_v0=1
    return 0
}

# query_term_size()
query_term_size__1379_v0() {
    local command_248
    command_248="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_17995="${command_248}"
    store_term_size__1378_v0 "${size_17995}"
    ret_query_term_size1379_v0="${ret_store_term_size1378_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1380_v0() {
    local command_249
    command_249="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_17991="${command_249}"
    store_term_size__1378_v0 "${size_17991}"
    ret_stty_term_size1380_v0="${ret_store_term_size1378_v0}"
    return 0
}

# get_term_size()
get_term_size__1381_v0() {
    stty_term_size__1380_v0 
    local detected_17994="${ret_stty_term_size1380_v0}"
    if [ "$(( ! detected_17994 ))" != 0 ]; then
        query_term_size__1379_v0 
        detected_17994="${ret_query_term_size1379_v0}"
    fi
    _got_term_size_59=1
}

# term_width()
term_width__1383_v0() {
    if [ "$(( ! _got_term_size_59 ))" != 0 ]; then
        get_term_size__1381_v0 
    fi
    ret_term_width1383_v0="${_term_size_60[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__1390_v0() {
    local cnt_18150="${1}"
    local array_250=("")
    eprintf__1350_v0 "\\x1b[${cnt_18150}A" array_250[@]
}

# go_down(cnt: Int)
go_down__1391_v0() {
    local cnt_18153="${1}"
    local array_251=("")
    eprintf__1350_v0 "\\x1b[${cnt_18153}B" array_251[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__1398_v0() {
    local display_count_18147="${1}"
    local index_18148="${2}"
    local line_18149="${3}"
    go_up__1390_v0 "$(( display_count_18147 - index_18148 ))"
    local array_252=("")
    eprintf__1334_v0 "\\x1b[G\\x1b[K" array_252[@]
    local array_253=("")
    eprintf__1334_v0 "${line_18149}" array_253[@]
    go_down__1391_v0 "$(( display_count_18147 - index_18148 ))"
    local array_254=("")
    eprintf__1334_v0 "\\x1b[G" array_254[@]
}

# Which items of a multi-select widget are ticked.
_checked_61=()
_count_62=0
_total_63=0
_limit_64=-1
# checked_init(total: Int, limit: Int)
checked_init__1400_v0() {
    local total_18087="${1}"
    local limit_18088="${2}"
    _checked_61=()
    local __range_start_18089=0
    local __range_end_18089="${total_18087}"
    local __dir_18089=$(( ${__range_start_18089} <= ${__range_end_18089} ? 1 : -1 ))
    for (( ____18089=${__range_start_18089}; ____18089 * ${__dir_18089} < ${__range_end_18089} * ${__dir_18089}; ____18089+=${__dir_18089} )); do
        local array_257=(0)
        _checked_61+=("${array_257[@]}")
done
    _count_62=0
    _total_63="${total_18087}"
    _limit_64="${limit_18088}"
}

# checked_is(index: Int)
checked_is__1401_v0() {
    local index_18123="${1}"
    ret_checked_is1401_v0="${_checked_61[${index_18123}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__1403_v0() {
    local index_18142="${1}"
    if [ "${_checked_61[${index_18142}]?"Index out of bounds (at src/./choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_61["${index_18142}"]=0
        _count_62="$(( _count_62 - 1 ))"
        ret_checked_toggle1403_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_64 >= 0 )) && $(( _count_62 >= _limit_64 )) ))" != 0 ]; then
        ret_checked_toggle1403_v0=0
        return 0
    fi
    _checked_61["${index_18142}"]=1
    _count_62="$(( _count_62 + 1 ))"
    ret_checked_toggle1403_v0=1
    return 0
}

# checked_all()
checked_all__1404_v0() {
    if [ "$(( _limit_64 >= 0 ))" != 0 ]; then
        ret_checked_all1404_v0=0
        return 0
    fi
    local was_all_18154="$(( _count_62 == _total_63 ))"
    local __range_start_18155=0
    local __range_end_18155="${_total_63}"
    local __dir_18155=$(( ${__range_start_18155} <= ${__range_end_18155} ? 1 : -1 ))
    for (( i_18155=${__range_start_18155}; i_18155 * ${__dir_18155} < ${__range_end_18155} * ${__dir_18155}; i_18155+=${__dir_18155} )); do
        _checked_61["${i_18155}"]="$(( ! was_all_18154 ))"
done
    if [ "${was_all_18154}" != 0 ]; then
        _count_62=0
    else
        _count_62="${_total_63}"
    fi
    ret_checked_all1404_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1416_v0() {
    local pending_18010="${1}"
    local line_18011="${2}"
    local note_at_18012="${3}"
    if [ "$(( note_at_18012 < 0 ))" != 0 ]; then
        local array_258=()
        printf__128_v0 "${pending_18010}""${line_18011}""
" array_258[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_18012 == 0 ))" != 0 ]; then
        colored__1336_v0 "${line_18011}" 90
        local ret_colored1336_v0__12_40="${ret_colored1336_v0}"
        local array_259=()
        printf__128_v0 "${pending_18010}""${ret_colored1336_v0__12_40}""
" array_259[@]
    else
        slice__24_v0 "${line_18011}" 0 "${note_at_18012}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_18011}" "${note_at_18012}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1336_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1336_v0__13_58="${ret_colored1336_v0}"
        local array_260=()
        printf__128_v0 "${pending_18010}""${ret_slice24_v0__13_32}""${ret_colored1336_v0__13_58}""
" array_260[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1417_v0() {
    local names_17983=("${!1}")
    local texts_17984=("${!2}")
    local notes_17985=("${!3}")
    local min_name_width_17986="${4}"
    local __length_261=("${names_17983[@]}")
    local count_17987="${#__length_261[@]}"
    local name_width_17988="${min_name_width_17986}"
    local __range_start_17989=0
    local __range_end_17989="${count_17987}"
    local __dir_17989=$(( ${__range_start_17989} <= ${__range_end_17989} ? 1 : -1 ))
    for (( i_17989=${__range_start_17989}; i_17989 * ${__dir_17989} < ${__range_end_17989} * ${__dir_17989}; i_17989+=${__dir_17989} )); do
        local __length_262="${names_17983[${i_17989}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_17990="${#__length_262}"
        if [ "$(( width_17990 > name_width_17988 ))" != 0 ]; then
            name_width_17988="${width_17990}"
        fi
done
    term_width__1383_v0 
    local width_17996="${ret_term_width1383_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_17997="$(( name_width_17988 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_17998="$(( $(( width_17996 - indent_17997 )) < 24 ))"
    if [ "${stacked_17998}" != 0 ]; then
        indent_17997=6
    fi
    local avail_17999="$(( width_17996 - indent_17997 ))"
    rpad__28_v0 "" " " "${indent_17997}"
    local blank_18000="${ret_rpad28_v0}"
    local __range_start_18001=0
    local __range_end_18001="${count_17987}"
    local __dir_18001=$(( ${__range_start_18001} <= ${__range_end_18001} ? 1 : -1 ))
    for (( i_18001=${__range_start_18001}; i_18001 * ${__dir_18001} < ${__range_end_18001} * ${__dir_18001}; i_18001+=${__dir_18001} )); do
        local pending_18002="${blank_18000}"
        if [ "${stacked_17998}" != 0 ]; then
            local array_263=()
            printf__128_v0 "  ""${names_17983[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_263[@]
        else
            rpad__28_v0 "  ""${names_17983[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_17997}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_18002="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_17984[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_18003=("${ret_split4_v0__52_21[@]}")
        local __length_264=("${words_18003[@]}")
        local note_start_18004="${#__length_264[@]}"
        if [ "$([ "_${notes_17985[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_265="${notes_17985[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_265} > avail_17999 ))" != 0 ]; then
                split__4_v0 "${notes_17985[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_18003+=("${ret_split4_v0__58_26[@]}")
            else
                local array_266=("${notes_17985[${i_18001}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_18003+=("${array_266[@]}")
            fi
        fi
        local line_18005=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_18006=-1
        local __range_start_18007=0
        local __length_267=("${words_18003[@]}")
        local __range_end_18007="${#__length_267[@]}"
        local __dir_18007=$(( ${__range_start_18007} <= ${__range_end_18007} ? 1 : -1 ))
        for (( j_18007=${__range_start_18007}; j_18007 * ${__dir_18007} < ${__range_end_18007} * ${__dir_18007}; j_18007+=${__dir_18007} )); do
            local word_18008="${words_18003[${j_18007}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_18009
            candidate_18009="$(if [ "$([ "_${line_18005}" != "_" ]; echo $?)" != 0 ]; then echo "${word_18008}"; else echo "${line_18005}"" ""${word_18008}"; fi)"
            local __length_268="${candidate_18009}"
            if [ "$(( $(( ${#__length_268} > avail_17999 )) && $([ "_${line_18005}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1416_v0 "${pending_18002}" "${line_18005}" "${note_at_18006}"
                pending_18002="${blank_18000}"
                line_18005="${word_18008}"
                note_at_18006="$(if [ "$(( j_18007 >= note_start_18004 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_18007 >= note_start_18004 )) && $(( note_at_18006 < 0 )) ))" != 0 ]; then
                    local __length_269="${candidate_18009}"
                    local __length_270="${word_18008}"
                    note_at_18006="$(( ${#__length_269} - ${#__length_270} ))"
                fi
                line_18005="${candidate_18009}"
            fi
done
        print_help_line__1416_v0 "${pending_18002}" "${line_18005}" "${note_at_18006}"
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
    local __length_272="${_cursor_76}"
    local cursor_len_18129="${#__length_272}"
    local max_option_width_18130="$(( $(( _term_width_79 - cursor_len_18129 )) - 1 ))"
    local __range_start_18131=0
    local __range_end_18131="${_page_count_82}"
    local __dir_18131=$(( ${__range_start_18131} <= ${__range_end_18131} ? 1 : -1 ))
    for (( i_18131=${__range_start_18131}; i_18131 * ${__dir_18131} < ${__range_end_18131} * ${__dir_18131}; i_18131+=${__dir_18131} )); do
        cutoff_text__1313_v0 "${_page_81[${i_18131}]?"Index out of bounds (at src/./choose/./engine.ab:44:45)"}" "${max_option_width_18130}"
        local ret_cutoff_text1313_v0__44_27="${ret_cutoff_text1313_v0}"
        local truncated_18132="${ret_cutoff_text1313_v0__44_27}"
        if [ "$(( i_18131 == _selected_75 ))" != 0 ]; then
            colored_secondary__1282_v0 "${_cursor_76}""${truncated_18132}""
"
            local ret_colored_secondary1282_v0__46_21="${ret_colored_secondary1282_v0}"
            local array_273=("")
            eprintf__1178_v0 "${ret_colored_secondary1282_v0__46_21}" array_273[@]
        else
            print_blank__1232_v0 "${cursor_len_18129}"
            local array_274=("")
            eprintf__1178_v0 "${truncated_18132}""
" array_274[@]
        fi
done
    local remaining_slots_18133="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18133 > 0 ))" != 0 ]; then
        local __range_start_18134=0
        local __range_end_18134="${remaining_slots_18133}"
        local __dir_18134=$(( ${__range_start_18134} <= ${__range_end_18134} ? 1 : -1 ))
        for (( ____18134=${__range_start_18134}; ____18134 * ${__dir_18134} < ${__range_end_18134} * ${__dir_18134}; ____18134+=${__dir_18134} )); do
            local array_275=("")
            eprintf__1178_v0 "\\x1b[K
" array_275[@]
done
    fi
}

# render_multi_page()
render_multi_page__1575_v0() {
    local __length_276="${_cursor_76}"
    local cursor_len_18118="${#__length_276}"
    local max_option_width_18119="$(( $(( _term_width_79 - cursor_len_18118 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1580_v0 
    local page_start_18120="${ret_chooser_page_start1580_v0}"
    local __range_start_18121=0
    local __range_end_18121="${_page_count_82}"
    local __dir_18121=$(( ${__range_start_18121} <= ${__range_end_18121} ? 1 : -1 ))
    for (( i_18121=${__range_start_18121}; i_18121 * ${__dir_18121} < ${__range_end_18121} * ${__dir_18121}; i_18121+=${__dir_18121} )); do
        local global_idx_18122="$(( page_start_18120 + i_18121 ))"
        checked_is__1401_v0 "${global_idx_18122}"
        local ret_checked_is1401_v0__66_28="${ret_checked_is1401_v0}"
        local check_mark_18124
        check_mark_18124="$(if [ "${ret_checked_is1401_v0__66_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1313_v0 "${_page_81[${i_18121}]?"Index out of bounds (at src/./choose/./engine.ab:67:45)"}" "${max_option_width_18119}"
        local ret_cutoff_text1313_v0__67_27="${ret_cutoff_text1313_v0}"
        local truncated_18125="${ret_cutoff_text1313_v0__67_27}"
        checked_is__1401_v0 "${global_idx_18122}"
        local ret_checked_is1401_v0__70_13="${ret_checked_is1401_v0}"
        if [ "$(( i_18121 == _selected_75 ))" != 0 ]; then
            colored_secondary__1282_v0 "${_cursor_76}""${check_mark_18124}""${truncated_18125}""
"
            local ret_colored_secondary1282_v0__69_37="${ret_colored_secondary1282_v0}"
            local array_277=("")
            eprintf__1178_v0 "${ret_colored_secondary1282_v0__69_37}" array_277[@]
        elif [ "${ret_checked_is1401_v0__70_13}" != 0 ]; then
            print_blank__1232_v0 "${cursor_len_18118}"
            colored_secondary__1282_v0 "${check_mark_18124}""${truncated_18125}""
"
            local ret_colored_secondary1282_v0__72_25="${ret_colored_secondary1282_v0}"
            local array_278=("")
            eprintf__1178_v0 "${ret_colored_secondary1282_v0__72_25}" array_278[@]
        else
            print_blank__1232_v0 "${cursor_len_18118}"
            local array_279=("")
            eprintf__1178_v0 "${check_mark_18124}""${truncated_18125}""
" array_279[@]
        fi
done
    local remaining_slots_18127="$(( _display_count_72 - _page_count_82 ))"
    if [ "$(( remaining_slots_18127 > 0 ))" != 0 ]; then
        local __range_start_18128=0
        local __range_end_18128="${remaining_slots_18127}"
        local __dir_18128=$(( ${__range_start_18128} <= ${__range_end_18128} ? 1 : -1 ))
        for (( ____18128=${__range_start_18128}; ____18128 * ${__dir_18128} < ${__range_end_18128} * ${__dir_18128}; ____18128+=${__dir_18128} )); do
            local array_280=("")
            eprintf__1178_v0 "\\x1b[K
" array_280[@]
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
        local array_281=("")
        eprintf__1178_v0 "\\x1b[G\\x1b[K" array_281[@]
        eprintf_colored__1179_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
        local array_282=("")
        eprintf__1178_v0 "\\x1b[G" array_282[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1578_v0() {
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_283=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1340_v0 array_283[@] 36 "${_term_width_79}"
        else
            local array_284=("↑↓" "select" "enter" "confirm")
            render_tooltip__1340_v0 array_284[@] 25 "${_term_width_79}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_73 > 1 )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
            local array_285=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1340_v0 array_285[@] 55 "${_term_width_79}"
        elif [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
            local array_286=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1340_v0 array_286[@] 47 "${_term_width_79}"
        elif [ "$(( _limit_78 < 0 ))" != 0 ]; then
            local array_287=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1340_v0 array_287[@] 44 "${_term_width_79}"
        else
            local array_288=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1340_v0 array_288[@] 36 "${_term_width_79}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1579_v0() {
    local total_18034="${1}"
    local page_size_18035="${2}"
    local header_18036="${3}"
    local cursor_18037="${4}"
    local multi_18038="${5}"
    local limit_18039="${6}"
    _total_70="${total_18034}"
    _cursor_76="${cursor_18037}"
    _multi_77="${multi_18038}"
    _limit_78="${limit_18039}"
    _current_page_74=0
    _selected_75=0
    _first_render_83=1
    _up_paged_84=0
    _has_header_80="$([ "_${header_18036}" == "_" ]; echo $?)"
    stty_lock__1220_v0 
    hide_cursor__1237_v0 
    term_width__1227_v0 
    _term_width_79="${ret_term_width1227_v0}"
    term_height__1228_v0 
    local term_height_18046="${ret_term_height1228_v0}"
    local max_page_size_18047
    max_page_size_18047="$(( term_height_18046 - $(if [ "${_has_header_80}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_71="${page_size_18035}"
    if [ "$(( _page_size_71 > max_page_size_18047 ))" != 0 ]; then
        _page_size_71="${max_page_size_18047}"
    fi
    if [ "${_has_header_80}" != 0 ]; then
        cutoff_text__1313_v0 "${header_18036}" "${_term_width_79}"
        local ret_cutoff_text1313_v0__152_17="${ret_cutoff_text1313_v0}"
        local array_289=("")
        eprintf__1178_v0 "${ret_cutoff_text1313_v0__152_17}""
" array_289[@]
    fi
    _total_pages_73="$(( $(( $(( total_18034 + _page_size_71 )) - 1 )) / _page_size_71 ))"
    _display_count_72="${_page_size_71}"
    if [ "$(( total_18034 < _page_size_71 ))" != 0 ]; then
        _display_count_72="${total_18034}"
    fi
    if [ "${multi_18038}" != 0 ]; then
        checked_init__1400_v0 "${total_18034}" "${limit_18039}"
    fi
    new_line__1233_v0 "${_display_count_72}"
    local array_290=("")
    eprintf__1178_v0 "\\x1b[G" array_290[@]
    if [ "$(( _total_pages_73 > 1 ))" != 0 ]; then
        eprintf_colored__1179_v0 "Page $(( _current_page_74 + 1 ))/${_total_pages_73}" 90
    fi
    new_line__1233_v0 1
    render_tooltip_line__1578_v0 
    go_up__1234_v0 "$(( _display_count_72 + 1 ))"
    local array_291=("")
    eprintf__1178_v0 "\\x1b[G" array_291[@]
}

# chooser_page_start()
chooser_page_start__1580_v0() {
    ret_chooser_page_start1580_v0="$(( _current_page_74 * _page_size_71 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1581_v0() {
    chooser_page_start__1580_v0 
    local start_18113="${ret_chooser_page_start1580_v0}"
    local end_18114="$(( start_18113 + _page_size_71 ))"
    if [ "$(( end_18114 > _total_70 ))" != 0 ]; then
        end_18114="${_total_70}"
    fi
    ret_chooser_page_count1581_v0="$(( end_18114 - start_18113 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1582_v0() {
    local page_18117=("${!1}")
    _page_81=("${page_18117[@]}")
    local __length_292=("${page_18117[@]}")
    _page_count_82="${#__length_292[@]}"
    if [ "${_first_render_83}" != 0 ]; then
        _first_render_83=0
        render_page__1576_v0 
    else
        if [ "${_up_paged_84}" != 0 ]; then
            _selected_75="$(( _page_count_82 - 1 ))"
            _up_paged_84=0
        fi
        go_up__1234_v0 1
        remove_line__1230_v0 "$(( _display_count_72 - 1 ))"
        remove_current_line__1231_v0 
        local array_293=("")
        eprintf__1178_v0 "\\x1b[G" array_293[@]
        render_page__1576_v0 
        render_page_indicator__1577_v0 
    fi
}

# option_width()
option_width__1583_v0() {
    local check_width_18144
    check_width_18144="$(if [ "${_multi_77}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_294="${_cursor_76}"
    ret_option_width1583_v0="$(( $(( _term_width_79 - ${#__length_294} )) - check_width_18144 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__1584_v0() {
    local index_18157="${1}"
    local __length_295="${_cursor_76}"
    rpad__28_v0 "" " " "${#__length_295}"
    local blank_18158="${ret_rpad28_v0}"
    option_width__1583_v0 
    local ret_option_width1583_v0__223_49="${ret_option_width1583_v0}"
    cutoff_text__1313_v0 "${_page_81[${index_18157}]?"Index out of bounds (at src/./choose/./engine.ab:223:41)"}" "${ret_option_width1583_v0__223_49}"
    local truncated_18159="${ret_cutoff_text1313_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        ret_unselected_line1584_v0="${blank_18158}""${truncated_18159}"
        return 0
    fi
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__227_19="${ret_chooser_page_start1580_v0}"
    checked_is__1401_v0 "$(( ret_chooser_page_start1580_v0__227_19 + index_18157 ))"
    local ret_checked_is1401_v0__227_8="${ret_checked_is1401_v0}"
    if [ "${ret_checked_is1401_v0__227_8}" != 0 ]; then
        colored_secondary__1282_v0 "✓ ""${truncated_18159}"
        local ret_colored_secondary1282_v0__228_24="${ret_colored_secondary1282_v0}"
        ret_unselected_line1584_v0="${blank_18158}""${ret_colored_secondary1282_v0__228_24}"
        return 0
    fi
    ret_unselected_line1584_v0="${blank_18158}""• ""${truncated_18159}"
    return 0
}

# selected_line(index: Int)
selected_line__1585_v0() {
    local index_18143="${1}"
    option_width__1583_v0 
    local ret_option_width1583_v0__235_49="${ret_option_width1583_v0}"
    cutoff_text__1313_v0 "${_page_81[${index_18143}]?"Index out of bounds (at src/./choose/./engine.ab:235:41)"}" "${ret_option_width1583_v0__235_49}"
    local truncated_18145="${ret_cutoff_text1313_v0}"
    if [ "$(( ! _multi_77 ))" != 0 ]; then
        colored_secondary__1282_v0 "${_cursor_76}""${truncated_18145}"
        ret_selected_line1585_v0="${ret_colored_secondary1282_v0}"
        return 0
    fi
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__239_29="${ret_chooser_page_start1580_v0}"
    checked_is__1401_v0 "$(( ret_chooser_page_start1580_v0__239_29 + index_18143 ))"
    local ret_checked_is1401_v0__239_18="${ret_checked_is1401_v0}"
    local mark_18146
    mark_18146="$(if [ "${ret_checked_is1401_v0__239_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__1282_v0 "${_cursor_76}""${mark_18146}""${truncated_18145}"
    ret_selected_line1585_v0="${ret_colored_secondary1282_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__1586_v0() {
    local prev_selected_18156="${1}"
    unselected_line__1584_v0 "${prev_selected_18156}"
    local ret_unselected_line1584_v0__246_47="${ret_unselected_line1584_v0}"
    redraw_row__1398_v0 "${_display_count_72}" "${prev_selected_18156}" "${ret_unselected_line1584_v0__246_47}"
    selected_line__1585_v0 "${_selected_75}"
    local ret_selected_line1585_v0__247_43="${ret_selected_line1585_v0}"
    redraw_row__1398_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1585_v0__247_43}"
}

# redraw_current_line()
redraw_current_line__1587_v0() {
    selected_line__1585_v0 "${_selected_75}"
    local ret_selected_line1585_v0__252_43="${ret_selected_line1585_v0}"
    redraw_row__1398_v0 "${_display_count_72}" "${_selected_75}" "${ret_selected_line1585_v0__252_43}"
}

# chooser_step()
chooser_step__1588_v0() {
    get_key__1176_v0 
    local key_18138="${ret_get_key1176_v0}"
    local prev_selected_18139="${_selected_75}"
    local prev_page_18140="${_current_page_74}"
    chooser_page_start__1580_v0 
    local page_start_18141="${ret_chooser_page_start1580_v0}"
    _up_paged_84=0
    if [ "$(( $([ "_${key_18138}" != "_UP" ]; echo $?) || $([ "_${key_18138}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18138}" != "_DOWN" ]; echo $?) || $([ "_${key_18138}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_18138}" != "_LEFT" ]; echo $?) || $([ "_${key_18138}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 > 0 ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 - 1 ))"
        fi
        _selected_75=0
    elif [ "$(( $([ "_${key_18138}" != "_RIGHT" ]; echo $?) || $([ "_${key_18138}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_74 < $(( _total_pages_73 - 1 )) ))" != 0 ]; then
            _current_page_74="$(( _current_page_74 + 1 ))"
            _selected_75=0
        else
            _selected_75="$(( _page_count_82 - 1 ))"
        fi
    elif [ "$(( _multi_77 && $(( $(( $([ "_${key_18138}" != "_x" ]; echo $?) || $([ "_${key_18138}" != "_X" ]; echo $?) )) || $([ "_${key_18138}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__1403_v0 "$(( page_start_18141 + _selected_75 ))"
        local ret_checked_toggle1403_v0__309_16="${ret_checked_toggle1403_v0}"
        if [ "${ret_checked_toggle1403_v0__309_16}" != 0 ]; then
            redraw_current_line__1587_v0 
        fi
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $(( _multi_77 && $(( $(( $([ "_${key_18138}" != "_a" ]; echo $?) || $([ "_${key_18138}" != "_A" ]; echo $?) )) || $([ "_${key_18138}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_78 < 0 )) ))" != 0 ]; then
        checked_all__1404_v0 
        local ret_checked_all1404_v0__315_16="${ret_checked_all1404_v0}"
        if [ "${ret_checked_all1404_v0__315_16}" != 0 ]; then
            go_up__1234_v0 "${_display_count_72}"
            local array_296=("")
            eprintf__1178_v0 "\\x1b[G" array_296[@]
            render_page__1576_v0 
        fi
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    elif [ "$(( $([ "_${key_18138}" != "_INPUT" ]; echo $?) || $([ "_${key_18138}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step1588_v0="${__CHOOSER_DONE_69}"
        return 0
    else
        ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
        return 0
    fi
    if [ "$(( prev_page_18140 != _current_page_74 ))" != 0 ]; then
        ret_chooser_step1588_v0="${__CHOOSER_NEED_PAGE_68}"
        return 0
    fi
    if [ "$(( prev_selected_18139 != _selected_75 ))" != 0 ]; then
        redraw_selection__1586_v0 "${prev_selected_18139}"
    fi
    ret_chooser_step1588_v0="${__CHOOSER_CONTINUE_67}"
    return 0
}

# chooser_selected()
chooser_selected__1589_v0() {
    chooser_page_start__1580_v0 
    local ret_chooser_page_start1580_v0__339_12="${ret_chooser_page_start1580_v0}"
    ret_chooser_selected1589_v0="$(( ret_chooser_page_start1580_v0__339_12 + _selected_75 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1590_v0() {
    local index_18166="${1}"
    checked_is__1401_v0 "${index_18166}"
    ret_chooser_is_checked1590_v0="${ret_checked_is1401_v0}"
    return 0
}

# chooser_end()
chooser_end__1591_v0() {
    local total_lines_18161="$(( _display_count_72 + 2 ))"
    if [ "${_has_header_80}" != 0 ]; then
        total_lines_18161="$(( total_lines_18161 + 1 ))"
    fi
    go_down__1235_v0 1
    remove_line__1230_v0 "$(( total_lines_18161 - 1 ))"
    remove_current_line__1231_v0 
    stty_unlock__1221_v0 
    show_cursor__1238_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1600_v0() {
    local options_18170=("${!1}")
    local cursor_18171="${2}"
    local header_18172="${3}"
    local page_size_18173="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_297=("${options_18170[@]}")
    local total_18174="${#__length_297[@]}"
    if [ "$(( total_18174 == 0 ))" != 0 ]; then
        eprintf_colored__1179_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1579_v0 "${total_18174}" "${page_size_18173}" "${header_18172}" "${cursor_18171}" 0 -1
    local need_page_18175=1
    while :
    do
        if [ "${need_page_18175}" != 0 ]; then
            local page_18176=()
            chooser_page_start__1580_v0 
            local start_18177="${ret_chooser_page_start1580_v0}"
            chooser_page_count__1581_v0 
            local count_18178="${ret_chooser_page_count1581_v0}"
            local __range_start_18179="${start_18177}"
            local __range_end_18179="$(( start_18177 + count_18178 ))"
            local __dir_18179=$(( ${__range_start_18179} <= ${__range_end_18179} ? 1 : -1 ))
            for (( i_18179=${__range_start_18179}; i_18179 * ${__dir_18179} < ${__range_end_18179} * ${__dir_18179}; i_18179+=${__dir_18179} )); do
                local array_299=("${options_18170[${i_18179}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_18176+=("${array_299[@]}")
done
            chooser_set_page__1582_v0 page_18176[@]
        fi
        chooser_step__1588_v0 
        local step_18180="${ret_chooser_step1588_v0}"
        if [ "$(( step_18180 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18175="$(( step_18180 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_selected__1589_v0 
    local selected_18181="${ret_chooser_selected1589_v0}"
    chooser_end__1591_v0 
    ret_xyl_choose1600_v0="${options_18170[${selected_18181}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1601_v0() {
    local options_18028=("${!1}")
    local cursor_18029="${2}"
    local header_18030="${3}"
    local limit_18031="${4}"
    local page_size_18032="${5}"
    local __length_300=("${options_18028[@]}")
    local total_18033="${#__length_300[@]}"
    if [ "$(( total_18033 == 0 ))" != 0 ]; then
        eprintf_colored__1179_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1601_v0=()
        return 0
    fi
    chooser_begin__1579_v0 "${total_18033}" "${page_size_18032}" "${header_18030}" "${cursor_18029}" 1 "${limit_18031}"
    local need_page_18110=1
    while :
    do
        if [ "${need_page_18110}" != 0 ]; then
            local page_18111=()
            chooser_page_start__1580_v0 
            local start_18112="${ret_chooser_page_start1580_v0}"
            chooser_page_count__1581_v0 
            local count_18115="${ret_chooser_page_count1581_v0}"
            local __range_start_18116="${start_18112}"
            local __range_end_18116="$(( start_18112 + count_18115 ))"
            local __dir_18116=$(( ${__range_start_18116} <= ${__range_end_18116} ? 1 : -1 ))
            for (( i_18116=${__range_start_18116}; i_18116 * ${__dir_18116} < ${__range_end_18116} * ${__dir_18116}; i_18116+=${__dir_18116} )); do
                local array_303=("${options_18028[${i_18116}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_18111+=("${array_303[@]}")
done
            chooser_set_page__1582_v0 page_18111[@]
        fi
        chooser_step__1588_v0 
        local step_18160="${ret_chooser_step1588_v0}"
        if [ "$(( step_18160 == __CHOOSER_DONE_69 ))" != 0 ]; then
            break
        fi
        need_page_18110="$(( step_18160 == __CHOOSER_NEED_PAGE_68 ))"
    done
    chooser_end__1591_v0 
    local result_18164=()
    local __range_start_18165=0
    local __range_end_18165="${total_18033}"
    local __dir_18165=$(( ${__range_start_18165} <= ${__range_end_18165} ? 1 : -1 ))
    for (( i_18165=${__range_start_18165}; i_18165 * ${__dir_18165} < ${__range_end_18165} * ${__dir_18165}; i_18165+=${__dir_18165} )); do
        chooser_is_checked__1590_v0 "${i_18165}"
        local ret_chooser_is_checked1590_v0__93_12="${ret_chooser_is_checked1590_v0}"
        if [ "${ret_chooser_is_checked1590_v0__93_12}" != 0 ]; then
            local array_305=("${options_18028[${i_18165}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_18164+=("${array_305[@]}")
        fi
done
    ret_xyl_multi_choose1601_v0=("${result_18164[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1702_v0() {
    local usage_17951=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1239_v0 usage_17951[@]
    printf '%s\n' ""
    colored_primary__1281_v0 "choose"
    local ret_colored_primary1281_v0__8_20="${ret_colored_primary1281_v0}"
    local title_17978=("${ret_colored_primary1281_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1239_v0 title_17978[@]
    printf '%s\n' ""
    colored_secondary__1282_v0 "Arguments:"
    local ret_colored_secondary1282_v0__11_12="${ret_colored_secondary1282_v0}"
    local array_308=()
    printf__128_v0 "${ret_colored_secondary1282_v0__11_12}""
" array_308[@]
    local arg_names_17980=("[<options> ...]")
    local arg_texts_17981=("List of options to choose from")
    local arg_notes_17982=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1417_v0 arg_names_17980[@] arg_texts_17981[@] arg_notes_17982[@] 20
    printf '%s\n' ""
    colored_secondary__1282_v0 "Flags:"
    local ret_colored_secondary1282_v0__18_12="${ret_colored_secondary1282_v0}"
    local array_312=()
    printf__128_v0 "${ret_colored_secondary1282_v0__18_12}""
" array_312[@]
    local names_18015=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_18016=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_18017=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1417_v0 names_18015[@] texts_18016[@] notes_18017[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1760_v0() {
    local options_17944=()
    local command_317
    command_317="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_17945="${command_317}"
    if [ "$([ "_${is_tty_17945}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_17944+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1760_v0=("${options_17944[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1761_v0() {
    local parameters_17928=("${!1}")
    local cursor_17929="> "
    colored_primary__1281_v0 "Choose: "
    local ret_colored_primary1281_v0__17_30="${ret_colored_primary1281_v0}"
    local header_17943="\\x1b[1m""${ret_colored_primary1281_v0__17_30}"
    read_stdin_options__1760_v0 
    local options_17946=("${ret_read_stdin_options1760_v0[@]}")
    local multi_17947=0
    local limit_17948=-1
    local page_size_17949=10
    local __length_321=("${parameters_17928[@]}")
    local slice_upper_320="${#__length_321[@]}"
    local slice_offset_322=2
    local slice_offset_322=$((${slice_offset_322} > 0 ? ${slice_offset_322} : 0))
    local slice_length_323="$(( slice_upper_320 - slice_offset_322 ))"
    local slice_length_323=$((${slice_length_323} > 0 ? ${slice_length_323} : 0))
    for param_17950 in "${parameters_17928[@]:${slice_offset_322}:${slice_length_323}}"; do
        starts_with__22_v0 "${param_17950}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17950}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17950}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_17950}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_17950}" != "_-h" ]; echo $?) || $([ "_${param_17950}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1702_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_324="--cursor="
            slice__24_v0 "${param_17950}" "${#__length_324}" 0
            cursor_17929="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_325="--header="
            slice__24_v0 "${param_17950}" "${#__length_325}" 0
            header_17943="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_326="--limit="
            slice__24_v0 "${param_17950}" "${#__length_326}" 0
            local value_18018="${ret_slice24_v0}"
            parse_int__13_v0 "${value_18018}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1179_v0 "ERROR: Invalid limit value: ""${value_18018}""
" 31
                exit 1
            fi
            limit_17948="${ret_parse_int13_v0}"
            multi_17947=1
        elif [ "$([ "_${param_17950}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_17947=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_327="--page-size="
            slice__24_v0 "${param_17950}" "${#__length_327}" 0
            local value_18023="${ret_slice24_v0}"
            parse_int__13_v0 "${value_18023}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1179_v0 "ERROR: Invalid page-size value: ""${value_18023}""
" 31
                exit 1
            fi
            page_size_17949="${ret_parse_int13_v0}"
        else
            options_17946+=("${param_17950}")
        fi
    done
    has_ansi_escape__1305_v0 "${header_17943}"
    local ret_has_ansi_escape1305_v0__59_44="${ret_has_ansi_escape1305_v0}"
    escape_ansi__1306_v0 "${header_17943}"
    local ret_escape_ansi1306_v0__59_73="${ret_escape_ansi1306_v0}"
    colored_primary__1281_v0 "${header_17943}"
    local ret_colored_primary1281_v0__59_111="${ret_colored_primary1281_v0}"
    local display_header_18027
    display_header_18027="$(if [ "$(( $([ "_${header_17943}" != "_" ]; echo $?) || ret_has_ansi_escape1305_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1306_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1281_v0__59_111}"; fi)"
    if [ "${multi_17947}" != 0 ]; then
        xyl_multi_choose__1601_v0 options_17946[@] "${cursor_17929}" "${display_header_18027}" "${limit_17948}" "${page_size_17949}"
        local results_18167=("${ret_xyl_multi_choose1601_v0[@]}")
        join__7_v0 results_18167[@] "
"
        ret_execute_choose1761_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1600_v0 options_17946[@] "${cursor_17929}" "${display_header_18027}" "${page_size_17949}"
    ret_execute_choose1761_v0="${ret_xyl_choose1600_v0}"
    return 0
}

# get_key()
get_key__1846_v0() {
    local command_329
    command_329="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key1846_v0="${command_329}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1848_v0() {
    local format_27495="${1}"
    local args_27496=("${!2}")
    args_27496=("${format_27495}" "${args_27496[@]}")
    __status=$?
    printf "${args_27496[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1849_v0() {
    local message_27493="${1}"
    local color_27494="${2}"
    # Prints an error message with a specified color.
    local array_330=("${message_27493}")
    eprintf__1848_v0 "\\x1b[${color_27494}m%s\\x1b[0m" array_330[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1864_v0() {
    local format_27515="${1}"
    local args_27516=("${!2}")
    args_27516=("${format_27515}" "${args_27516[@]}")
    __status=$?
    printf "${args_27516[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1865_v0() {
    local message_27513="${1}"
    local color_27514="${2}"
    # Prints an error message with a specified color.
    local array_331=("${message_27513}")
    eprintf__1864_v0 "\\x1b[${color_27514}m%s\\x1b[0m" array_331[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_90="None"
# perl_available()
perl_available__1872_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_332
        command_332="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27438
        disabled_27438="$([ "_${command_332}" != "_No" ]; echo $?)"
        local command_333
        command_333="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27439
        found_27439="$(( $(( ! disabled_27438 )) && $([ "_${command_333}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_27439}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1872_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1873_v0() {
    local text_27437="${1}"
    perl_available__1872_v0 
    local ret_perl_available1872_v0__19_12="${ret_perl_available1872_v0}"
    if [ "$(( ! ret_perl_available1872_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1873_v0=''
        return 1
    fi
    local command_334
    command_334="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27437}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1873_v0=''
        return "${__status}"
    fi
    local width_str_27440="${command_334}"
    parse_int__13_v0 "${width_str_27440}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1873_v0=''
        return "${__status}"
    fi
    local width_27441="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1873_v0="${width_27441}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1878_v0() {
    local text_27427="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_335
    command_335="$([[ "${text_27427}" == *$'\x1b'* || "${text_27427}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27428="${command_335}"
    ret_has_ansi_escape1878_v0="$([ "_${has_escape_27428}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1880_v0() {
    local text_27433="${1}"
    local command_336
    command_336="$(printf "%s" "${text_27433}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1880_v0="${command_336}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1881_v0() {
    local text_27435="${1}"
    local command_337
    command_337="$(printf "%s" "${text_27435}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27436="${command_337}"
    ret_is_all_ascii1881_v0="$([ "_${result_27436}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1882_v0() {
    local text_27430="${1}"
    local command_338
    command_338="$(LC_ALL=C; __t="${text_27430}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27431="${command_338}"
    parse_int__13_v0 "${measured_27431}"
    __status=$?
    ret_plain_len1882_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1883_v0() {
    local text_27429="${1}"
    plain_len__1882_v0 "${text_27429}"
    local plain_27432="${ret_plain_len1882_v0}"
    if [ "$(( plain_27432 >= 0 ))" != 0 ]; then
        ret_get_visible_len1883_v0="${plain_27432}"
        return 0
    fi
    strip_ansi__1880_v0 "${text_27429}"
    local stripped_27434="${ret_strip_ansi1880_v0}"
    is_all_ascii__1881_v0 "${stripped_27434}"
    local ret_is_all_ascii1881_v0__46_12="${ret_is_all_ascii1881_v0}"
    if [ "$(( ! ret_is_all_ascii1881_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1873_v0 "${stripped_27434}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_339="${stripped_27434}"
            ret_get_visible_len1883_v0="${#__length_339}"
            return 0
        fi
        ret_get_visible_len1883_v0="${ret_perl_get_cjk_width1873_v0}"
        return 0
    fi
    local __length_340="${stripped_27434}"
    ret_get_visible_len1883_v0="${#__length_340}"
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
stty_count__1889_v0() {
    local command_342
    command_342="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_27511="${command_342}"
    parse_int__13_v0 "${count_27511}"
    __status=$?
    ret_stty_count1889_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1890_v0() {
    stty_count__1889_v0 
    local count_num_27512="${ret_stty_count1889_v0}"
    if [ "$(( count_num_27512 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 2>/dev/null < /dev/tty
        __status=$?
        if [ "${__status}" != 0 ]; then
            eprintf_colored__1865_v0 "Error: " 91
            local array_343=("")
            eprintf__1864_v0 "xylitol needs a terminal, and /dev/tty is not available here.
" array_343[@]
            exit 1
        fi
    fi
    count_num_27512="$(( count_num_27512 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27512}
    __status=$?
}

# stty_unlock()
stty_unlock__1891_v0() {
    stty_count__1889_v0 
    local count_num_27615="${ret_stty_count1889_v0}"
    if [ "$(( count_num_27615 > 0 ))" != 0 ]; then
        count_num_27615="$(( count_num_27615 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_27615}
        __status=$?
        if [ "$(( count_num_27615 == 0 ))" != 0 ]; then
            stty echo icanon 2>/dev/null < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1892_v0() {
    local size_27418="${1}"
    if [ "$([ "_${size_27418}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1892_v0=0
        return 0
    fi
    split__4_v0 "${size_27418}" " "
    local parts_27419=("${ret_split4_v0[@]}")
    local __length_344=("${parts_27419[@]}")
    if [ "$(( ${#__length_344[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1892_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27419[1]?"Index out of bounds (at src/./filter/../utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27419[0]?"Index out of bounds (at src/./filter/../utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_92=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size1892_v0=1
    return 0
}

# query_term_size()
query_term_size__1893_v0() {
    local command_346
    command_346="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27421="${command_346}"
    store_term_size__1892_v0 "${size_27421}"
    ret_query_term_size1893_v0="${ret_store_term_size1892_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1894_v0() {
    local command_347
    command_347="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27417="${command_347}"
    store_term_size__1892_v0 "${size_27417}"
    ret_stty_term_size1894_v0="${ret_store_term_size1892_v0}"
    return 0
}

# get_term_size()
get_term_size__1895_v0() {
    stty_term_size__1894_v0 
    local detected_27420="${ret_stty_term_size1894_v0}"
    if [ "$(( ! detected_27420 ))" != 0 ]; then
        query_term_size__1893_v0 
        detected_27420="${ret_query_term_size1893_v0}"
    fi
    _got_term_size_91=1
}

# term_width()
term_width__1897_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1895_v0 
    fi
    ret_term_width1897_v0="${_term_size_92[0]?"Index out of bounds (at src/./filter/../utils/term.ab:100:23)"}"
    return 0
}

# term_height()
term_height__1898_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__1895_v0 
    fi
    ret_term_height1898_v0="${_term_size_92[1]?"Index out of bounds (at src/./filter/../utils/term.ab:108:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1900_v0() {
    local cnt_27612="${1}"
    if [ "$(( cnt_27612 > 0 ))" != 0 ]; then
        local sequence_27613=""
        local __range_start_27614=0
        local __range_end_27614="${cnt_27612}"
        local __dir_27614=$(( ${__range_start_27614} <= ${__range_end_27614} ? 1 : -1 ))
        for (( ____27614=${__range_start_27614}; ____27614 * ${__dir_27614} < ${__range_end_27614} * ${__dir_27614}; ____27614+=${__dir_27614} )); do
            sequence_27613+="\\x1b[2K\\x1b[1A"
done
        local array_348=("")
        eprintf__1864_v0 "${sequence_27613}" array_348[@]
    fi
    local array_349=("")
    eprintf__1864_v0 "\\x1b[G" array_349[@]
}

# remove_current_line()
remove_current_line__1901_v0() {
    local array_350=("")
    eprintf__1864_v0 "\\x1b[2K\\x1b[G" array_350[@]
}

# new_line(cnt: Int)
new_line__1903_v0() {
    local cnt_27561="${1}"
    local __range_start_27562=0
    local __range_end_27562="${cnt_27561}"
    local __dir_27562=$(( ${__range_start_27562} <= ${__range_end_27562} ? 1 : -1 ))
    for (( ____27562=${__range_start_27562}; ____27562 * ${__dir_27562} < ${__range_end_27562} * ${__dir_27562}; ____27562+=${__dir_27562} )); do
        local array_351=("")
        eprintf__1864_v0 "
" array_351[@]
done
}

# go_up(cnt: Int)
go_up__1904_v0() {
    local cnt_27580="${1}"
    local array_352=("")
    eprintf__1864_v0 "\\x1b[${cnt_27580}A" array_352[@]
}

# go_down(cnt: Int)
go_down__1905_v0() {
    local cnt_27594="${1}"
    local array_353=("")
    eprintf__1864_v0 "\\x1b[${cnt_27594}B" array_353[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1907_v0() {
    local array_354=("")
    eprintf__1864_v0 "\\x1b[?25l" array_354[@]
}

# show_cursor()
show_cursor__1908_v0() {
    local array_355=("")
    eprintf__1864_v0 "\\x1b[?25h" array_355[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1909_v0() {
    local pieces_27416=("${!1}")
    term_width__1897_v0 
    local width_27422="${ret_term_width1897_v0}"
    local line_27423=""
    local line_len_27424=0
    for piece_27425 in "${pieces_27416[@]}"; do
        local __length_358="${piece_27425}"
        local piece_len_27426="${#__length_358}"
        has_ansi_escape__1878_v0 "${piece_27425}"
        local ret_has_ansi_escape1878_v0__190_12="${ret_has_ansi_escape1878_v0}"
        if [ "${ret_has_ansi_escape1878_v0__190_12}" != 0 ]; then
            get_visible_len__1883_v0 "${piece_27425}"
            piece_len_27426="${ret_get_visible_len1883_v0}"
        fi
        if [ "$([ "_${line_27423}" != "_" ]; echo $?)" != 0 ]; then
            line_27423="${piece_27425}"
            line_len_27424="${piece_len_27426}"
        elif [ "$(( $(( $(( line_len_27424 + 1 )) + piece_len_27426 )) > width_27422 ))" != 0 ]; then
            local array_359=()
            printf__128_v0 "${line_27423}""
" array_359[@]
            line_27423="${piece_27425}"
            line_len_27424="${piece_len_27426}"
        else
            line_27423+=" ""${piece_27425}"
            line_len_27424="$(( line_len_27424 + $(( 1 + piece_len_27426 )) ))"
        fi
    done
    if [ "$([ "_${line_27423}" == "_" ]; echo $?)" != 0 ]; then
        local array_360=()
        printf__128_v0 "${line_27423}""
" array_360[@]
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
get_supports_truecolor__1946_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_27454="${ret_env_var_get120_v0}"
    _supports_truecolor_95="$(if [ "$([ "_${config_27454}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1946_v0="$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1947_v0() {
    local message_27449="${1}"
    local r_27450="${2}"
    local g_27451="${3}"
    local b_27452="${4}"
    local fallback_27453="${5}"
    if [ "$([ "_${_supports_truecolor_95}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1947_v0="\\x1b[38;2;${r_27450};${g_27451};${b_27452}m""${message_27449}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_95}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1946_v0 
        local ret_get_supports_truecolor1946_v0__45_17="${ret_get_supports_truecolor1946_v0}"
        if [ "${ret_get_supports_truecolor1946_v0__45_17}" != 0 ]; then
            ret_colored_rgb1947_v0="\\x1b[38;2;${r_27450};${g_27451};${b_27452}m""${message_27449}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_27453 == 0 ))" != 0 ]; then
            ret_colored_rgb1947_v0="${message_27449}"
            return 0
        else
            ret_colored_rgb1947_v0="\\x1b[${fallback_27453}m""${message_27449}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_27453 == 0 ))" != 0 ]; then
            ret_colored_rgb1947_v0="${message_27449}"
            return 0
        fi
        ret_colored_rgb1947_v0="\\x1b[${fallback_27453}m""${message_27449}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1949_v0() {
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_27443="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_27443}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_27443}" ";"
            local parts_27444=("${ret_split4_v0[@]}")
            local __length_364=("${parts_27444[@]}")
            if [ "$(( ${#__length_364[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27444[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27444[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27444[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27444[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_97=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_27445="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_27445}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_27445}" ";"
            local parts_27446=("${ret_split4_v0[@]}")
            local __length_366=("${parts_27446[@]}")
            if [ "$(( ${#__length_366[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27446[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27446[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27446[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27446[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_98=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_27447="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_27447}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_27447}" ";"
            local parts_27448=("${ret_split4_v0[@]}")
            local __length_368=("${parts_27448[@]}")
            if [ "$(( ${#__length_368[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_27448[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27448[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27448[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_27448[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1949_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_96=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1950_v0() {
    inner_get_xylitol_colors__1949_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_96=1
}

# colored_primary(message: Text)
colored_primary__1951_v0() {
    local message_27442="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1950_v0 
    fi
    colored_rgb__1947_v0 "${message_27442}" "${_primary_color_97[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:48)"}" "${_primary_color_97[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:67)"}" "${_primary_color_97[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:86)"}" "${_primary_color_97[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1951_v0="${ret_colored_rgb1947_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1952_v0() {
    local message_27456="${1}"
    if [ "$(( ! _got_xylitol_colors_96 ))" != 0 ]; then
        get_xylitol_colors__1950_v0 
    fi
    colored_rgb__1947_v0 "${message_27456}" "${_secondary_color_98[0]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:50)"}" "${_secondary_color_98[1]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:71)"}" "${_secondary_color_98[2]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:92)"}" "${_secondary_color_98[3]?"Index out of bounds (at src/./filter/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1952_v0="${ret_colored_rgb1947_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_100="None"
# perl_available()
perl_available__1969_v0() {
    if [ "$([ "_${_perl_state_100}" != "_None" ]; echo $?)" != 0 ]; then
        local command_370
        command_370="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27533
        disabled_27533="$([ "_${command_370}" != "_No" ]; echo $?)"
        local command_371
        command_371="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27534
        found_27534="$(( $(( ! disabled_27533 )) && $([ "_${command_371}" != "_0" ]; echo $?) ))"
        _perl_state_100="$(if [ "${found_27534}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1969_v0="$([ "_${_perl_state_100}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1970_v0() {
    local text_27532="${1}"
    perl_available__1969_v0 
    local ret_perl_available1969_v0__19_12="${ret_perl_available1969_v0}"
    if [ "$(( ! ret_perl_available1969_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1970_v0=''
        return 1
    fi
    local command_372
    command_372="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27532}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1970_v0=''
        return "${__status}"
    fi
    local width_str_27535="${command_372}"
    parse_int__13_v0 "${width_str_27535}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1970_v0=''
        return "${__status}"
    fi
    local width_27536="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1970_v0="${width_27536}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1971_v0() {
    local text_27543="${1}"
    local max_width_27544="${2}"
    perl_available__1969_v0 
    local ret_perl_available1969_v0__30_12="${ret_perl_available1969_v0}"
    if [ "$(( ! ret_perl_available1969_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1971_v0=''
        return 1
    fi
    local command_373
    command_373="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_27543}" ${max_width_27544} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1971_v0=''
        return "${__status}"
    fi
    local result_27545="${command_373}"
    ret_perl_truncate_cjk1971_v0="${result_27545}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1975_v0() {
    local text_27498="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_374
    command_374="$([[ "${text_27498}" == *$'\x1b'* || "${text_27498}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27499="${command_374}"
    ret_has_ansi_escape1975_v0="$([ "_${has_escape_27499}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1976_v0() {
    local text_27500="${1}"
    local command_375
    command_375="$(printf '%s' "${text_27500}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1976_v0="${command_375}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1977_v0() {
    local text_27528="${1}"
    local command_376
    command_376="$(printf "%s" "${text_27528}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1977_v0="${command_376}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1978_v0() {
    local text_27530="${1}"
    local command_377
    command_377="$(printf "%s" "${text_27530}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27531="${command_377}"
    ret_is_all_ascii1978_v0="$([ "_${result_27531}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__1979_v0() {
    local text_27525="${1}"
    local command_378
    command_378="$(LC_ALL=C; __t="${text_27525}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_27526="${command_378}"
    parse_int__13_v0 "${measured_27526}"
    __status=$?
    ret_plain_len1979_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1980_v0() {
    local text_27524="${1}"
    plain_len__1979_v0 "${text_27524}"
    local plain_27527="${ret_plain_len1979_v0}"
    if [ "$(( plain_27527 >= 0 ))" != 0 ]; then
        ret_get_visible_len1980_v0="${plain_27527}"
        return 0
    fi
    strip_ansi__1977_v0 "${text_27524}"
    local stripped_27529="${ret_strip_ansi1977_v0}"
    is_all_ascii__1978_v0 "${stripped_27529}"
    local ret_is_all_ascii1978_v0__46_12="${ret_is_all_ascii1978_v0}"
    if [ "$(( ! ret_is_all_ascii1978_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__1970_v0 "${stripped_27529}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_379="${stripped_27529}"
            ret_get_visible_len1980_v0="${#__length_379}"
            return 0
        fi
        ret_get_visible_len1980_v0="${ret_perl_get_cjk_width1970_v0}"
        return 0
    fi
    local __length_380="${stripped_27529}"
    ret_get_visible_len1980_v0="${#__length_380}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1981_v0() {
    local text_27540="${1}"
    local max_width_27541="${2}"
    get_visible_len__1980_v0 "${text_27540}"
    local visible_len_27542="${ret_get_visible_len1980_v0}"
    if [ "$(( visible_len_27542 <= max_width_27541 ))" != 0 ]; then
        ret_truncate_text1981_v0="${text_27540}"
        return 0
    fi
    is_all_ascii__1978_v0 "${text_27540}"
    local ret_is_all_ascii1978_v0__61_12="${ret_is_all_ascii1978_v0}"
    if [ "$(( ! ret_is_all_ascii1978_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__1971_v0 "${text_27540}" "${max_width_27541}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_27540}" | cut -c1-${max_width_27541}
            __status=$?
        fi
        ret_truncate_text1981_v0="${ret_perl_truncate_cjk1971_v0}"
        return 0
    fi
    local command_381
    command_381="$(printf "%s" "${text_27540}" | cut -c1-${max_width_27541})"
    __status=$?
    ret_truncate_text1981_v0="${command_381}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1982_v0() {
    local text_27538="${1}"
    local max_width_27539="${2}"
    has_ansi_escape__1975_v0 "${text_27538}"
    local ret_has_ansi_escape1975_v0__73_12="${ret_has_ansi_escape1975_v0}"
    if [ "$(( ! ret_has_ansi_escape1975_v0__73_12 ))" != 0 ]; then
        truncate_text__1981_v0 "${text_27538}" "${max_width_27539}"
        ret_truncate_ansi1982_v0="${ret_truncate_text1981_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_382
    command_382="$([[ "${text_27538}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_27546="${command_382}"
    # Replace \x1b[ with newline, then split
    local command_383
    command_383="$(t="${text_27538}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_27547="${command_383}"
    split__4_v0 "${replaced_27547}" "
"
    local parts_27548=("${ret_split4_v0[@]}")
    local result_27549=""
    local remaining_width_27550="${max_width_27539}"
    local __range_start_27551=0
    local __length_384=("${parts_27548[@]}")
    local __range_end_27551="${#__length_384[@]}"
    local __dir_27551=$(( ${__range_start_27551} <= ${__range_end_27551} ? 1 : -1 ))
    for (( idx_27551=${__range_start_27551}; idx_27551 * ${__dir_27551} < ${__range_end_27551} * ${__dir_27551}; idx_27551+=${__dir_27551} )); do
        local part_27552="${parts_27548[${idx_27551}]?"Index out of bounds (at src/./filter/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_27551 == 0 )) && $([ "_${starts_with_ansi_27546}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_27552}" == "_" ]; echo $?) && $(( remaining_width_27550 > 0 )) ))" != 0 ]; then
                truncate_text__1981_v0 "${part_27552}" "${remaining_width_27550}"
                local ret_truncate_text1981_v0__95_35="${ret_truncate_text1981_v0}"
                local truncated_27553="${ret_truncate_text1981_v0__95_35}"
                result_27549+="${truncated_27553}"
                get_visible_len__1980_v0 "${truncated_27553}"
                local ret_get_visible_len1980_v0__97_36="${ret_get_visible_len1980_v0}"
                remaining_width_27550="$(( remaining_width_27550 - ret_get_visible_len1980_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_385
            command_385="$(__p="${part_27552}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_27554="${command_385}"
            if [ "$([ "_${m_idx_27554}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_386
                command_386="$(__p="${part_27552}"; printf "%s" "${__p:0:${m_idx_27554}}")"
                __status=$?
                local ansi_params_27555="${command_386}"
                result_27549+="\\x1b[""${ansi_params_27555}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_27554}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_27556="${ret_parse_int13_v0__108_41}"
                local text_start_27557="$(( m_idx_num_27556 + 1 ))"
                local command_387
                command_387="$(__p="${part_27552}"; printf "%s" "${__p:${text_start_27557}}")"
                __status=$?
                local text_part_27558="${command_387}"
                if [ "$(( $([ "_${text_part_27558}" == "_" ]; echo $?) && $(( remaining_width_27550 > 0 )) ))" != 0 ]; then
                    truncate_text__1981_v0 "${text_part_27558}" "${remaining_width_27550}"
                    local ret_truncate_text1981_v0__112_39="${ret_truncate_text1981_v0}"
                    local truncated_27559="${ret_truncate_text1981_v0__112_39}"
                    result_27549+="${truncated_27559}"
                    get_visible_len__1980_v0 "${truncated_27559}"
                    local ret_get_visible_len1980_v0__114_40="${ret_get_visible_len1980_v0}"
                    remaining_width_27550="$(( remaining_width_27550 - ret_get_visible_len1980_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_27552}" == "_" ]; echo $?) && $(( remaining_width_27550 > 0 )) ))" != 0 ]; then
                    truncate_text__1981_v0 "${part_27552}" "${remaining_width_27550}"
                    local ret_truncate_text1981_v0__119_39="${ret_truncate_text1981_v0}"
                    local truncated_27560="${ret_truncate_text1981_v0__119_39}"
                    result_27549+="${truncated_27560}"
                    get_visible_len__1980_v0 "${truncated_27560}"
                    local ret_get_visible_len1980_v0__121_40="${ret_get_visible_len1980_v0}"
                    remaining_width_27550="$(( remaining_width_27550 - ret_get_visible_len1980_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1982_v0="${result_27549}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1983_v0() {
    local text_27522="${1}"
    local max_width_27523="${2}"
    get_visible_len__1980_v0 "${text_27522}"
    local visible_len_27537="${ret_get_visible_len1980_v0}"
    if [ "$(( visible_len_27537 <= max_width_27523 ))" != 0 ]; then
        ret_cutoff_text1983_v0="${text_27522}"
        return 0
    fi
    truncate_ansi__1982_v0 "${text_27522}" "$(( max_width_27523 - 3 ))"
    local ret_truncate_ansi1982_v0__137_12="${ret_truncate_ansi1982_v0}"
    ret_cutoff_text1983_v0="${ret_truncate_ansi1982_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2004_v0() {
    local format_27571="${1}"
    local args_27572=("${!2}")
    args_27572=("${format_27571}" "${args_27572[@]}")
    __status=$?
    printf "${args_27572[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2005_v0() {
    local message_27569="${1}"
    local color_27570="${2}"
    # Prints an error message with a specified color.
    local array_388=("${message_27569}")
    eprintf__2004_v0 "\\x1b[${color_27570}m%s\\x1b[0m" array_388[@]
}

# colored(message: Text, color: Int)
colored__2006_v0() {
    local message_27487="${1}"
    local color_27488="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2006_v0="\\x1b[${color_27488}m""${message_27487}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2010_v0() {
    local items_27563=("${!1}")
    local total_len_27564="${2}"
    local term_width_27565="${3}"
    local separator_27566=" • "
    local separator_len_27567=3
    # Fast path: no truncation needed
    if [ "$(( total_len_27564 <= term_width_27565 ))" != 0 ]; then
        local iter_27568=0
        while :
        do
            local __length_389=("${items_27563[@]}")
            if [ "$(( iter_27568 >= ${#__length_389[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_27568 > 0 ))" != 0 ]; then
                eprintf_colored__2005_v0 "${separator_27566}" 90
            fi
            colored__2006_v0 "${items_27563[$(( iter_27568 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2006_v0__23_41="${ret_colored2006_v0}"
            local array_390=("")
            eprintf__2004_v0 "${items_27563[${iter_27568}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2006_v0__23_41}" array_390[@]
            iter_27568="$(( iter_27568 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_27573=0
        local first_27574=1
        local iter_27575=0
        while :
        do
            local __length_391=("${items_27563[@]}")
            if [ "$(( iter_27575 >= ${#__length_391[@]} ))" != 0 ]; then
                break
            fi
            local key_27576="${items_27563[${iter_27575}]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:35:31)"}"
            local action_27577="${items_27563[$(( iter_27575 + 1 ))]?"Index out of bounds (at src/./filter/../utils/widget/tooltip.ab:36:34)"}"
            local __length_392="${key_27576}"
            local __length_393="${action_27577}"
            local part_len_27578="$(( $(( ${#__length_392} + 1 )) + ${#__length_393} ))"
            local needed_27579="${part_len_27578}"
            if [ "$(( ! first_27574 ))" != 0 ]; then
                needed_27579="$(( needed_27579 + separator_len_27567 ))"
            fi
            if [ "$(( $(( current_len_27573 + needed_27579 )) > term_width_27565 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_27574 ))" != 0 ]; then
                eprintf_colored__2005_v0 "${separator_27566}" 90
            fi
            colored__2006_v0 "${action_27577}" 2
            local ret_colored2006_v0__51_33="${ret_colored2006_v0}"
            local array_394=("")
            eprintf__2004_v0 "${key_27576}"" ""${ret_colored2006_v0__51_33}" array_394[@]
            current_len_27573="$(( current_len_27573 + needed_27579 ))"
            first_27574=0
            iter_27575="$(( iter_27575 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2020_v0() {
    local format_27604="${1}"
    local args_27605=("${!2}")
    args_27605=("${format_27604}" "${args_27605[@]}")
    __status=$?
    printf "${args_27605[@]}" >&2
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
store_term_size__2048_v0() {
    local size_27466="${1}"
    if [ "$([ "_${size_27466}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2048_v0=0
        return 0
    fi
    split__4_v0 "${size_27466}" " "
    local parts_27467=("${ret_split4_v0[@]}")
    local __length_396=("${parts_27467[@]}")
    if [ "$(( ${#__length_396[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2048_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27467[1]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27467[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_104=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size2048_v0=1
    return 0
}

# query_term_size()
query_term_size__2049_v0() {
    local command_398
    command_398="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27469="${command_398}"
    store_term_size__2048_v0 "${size_27469}"
    ret_query_term_size2049_v0="${ret_store_term_size2048_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2050_v0() {
    local command_399
    command_399="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27465="${command_399}"
    store_term_size__2048_v0 "${size_27465}"
    ret_stty_term_size2050_v0="${ret_store_term_size2048_v0}"
    return 0
}

# get_term_size()
get_term_size__2051_v0() {
    stty_term_size__2050_v0 
    local detected_27468="${ret_stty_term_size2050_v0}"
    if [ "$(( ! detected_27468 ))" != 0 ]; then
        query_term_size__2049_v0 
        detected_27468="${ret_query_term_size2049_v0}"
    fi
    _got_term_size_103=1
}

# term_width()
term_width__2053_v0() {
    if [ "$(( ! _got_term_size_103 ))" != 0 ]; then
        get_term_size__2051_v0 
    fi
    ret_term_width2053_v0="${_term_size_104[0]?"Index out of bounds (at src/./filter/../utils/widget/../term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# go_up(cnt: Int)
go_up__2060_v0() {
    local cnt_27603="${1}"
    local array_400=("")
    eprintf__2020_v0 "\\x1b[${cnt_27603}A" array_400[@]
}

# go_down(cnt: Int)
go_down__2061_v0() {
    local cnt_27606="${1}"
    local array_401=("")
    eprintf__2020_v0 "\\x1b[${cnt_27606}B" array_401[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__2068_v0() {
    local display_count_27600="${1}"
    local index_27601="${2}"
    local line_27602="${3}"
    go_up__2060_v0 "$(( display_count_27600 - index_27601 ))"
    local array_402=("")
    eprintf__2004_v0 "\\x1b[G\\x1b[K" array_402[@]
    local array_403=("")
    eprintf__2004_v0 "${line_27602}" array_403[@]
    go_down__2061_v0 "$(( display_count_27600 - index_27601 ))"
    local array_404=("")
    eprintf__2004_v0 "\\x1b[G" array_404[@]
}

# Which items of a multi-select widget are ticked.
_checked_105=()
_count_106=0
_total_107=0
_limit_108=-1
# checked_init(total: Int, limit: Int)
checked_init__2070_v0() {
    local total_27518="${1}"
    local limit_27519="${2}"
    _checked_105=()
    local __range_start_27520=0
    local __range_end_27520="${total_27518}"
    local __dir_27520=$(( ${__range_start_27520} <= ${__range_end_27520} ? 1 : -1 ))
    for (( ____27520=${__range_start_27520}; ____27520 * ${__dir_27520} < ${__range_end_27520} * ${__dir_27520}; ____27520+=${__dir_27520} )); do
        local array_407=(0)
        _checked_105+=("${array_407[@]}")
done
    _count_106=0
    _total_107="${total_27518}"
    _limit_108="${limit_27519}"
}

# checked_is(index: Int)
checked_is__2071_v0() {
    local index_27590="${1}"
    ret_checked_is2071_v0="${_checked_105[${index_27590}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_count()
checked_count__2072_v0() {
    ret_checked_count2072_v0="${_count_106}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__2073_v0() {
    local index_27607="${1}"
    if [ "${_checked_105[${index_27607}]?"Index out of bounds (at src/./filter/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_105["${index_27607}"]=0
        _count_106="$(( _count_106 - 1 ))"
        ret_checked_toggle2073_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_108 >= 0 )) && $(( _count_106 >= _limit_108 )) ))" != 0 ]; then
        ret_checked_toggle2073_v0=0
        return 0
    fi
    _checked_105["${index_27607}"]=1
    _count_106="$(( _count_106 + 1 ))"
    ret_checked_toggle2073_v0=1
    return 0
}

# checked_all()
checked_all__2074_v0() {
    if [ "$(( _limit_108 >= 0 ))" != 0 ]; then
        ret_checked_all2074_v0=0
        return 0
    fi
    local was_all_27608="$(( _count_106 == _total_107 ))"
    local __range_start_27609=0
    local __range_end_27609="${_total_107}"
    local __dir_27609=$(( ${__range_start_27609} <= ${__range_end_27609} ? 1 : -1 ))
    for (( i_27609=${__range_start_27609}; i_27609 * ${__dir_27609} < ${__range_end_27609} * ${__dir_27609}; i_27609+=${__dir_27609} )); do
        _checked_105["${i_27609}"]="$(( ! was_all_27608 ))"
done
    if [ "${was_all_27608}" != 0 ]; then
        _count_106=0
    else
        _count_106="${_total_107}"
    fi
    ret_checked_all2074_v0=1
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2086_v0() {
    local pending_27484="${1}"
    local line_27485="${2}"
    local note_at_27486="${3}"
    if [ "$(( note_at_27486 < 0 ))" != 0 ]; then
        local array_408=()
        printf__128_v0 "${pending_27484}""${line_27485}""
" array_408[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_27486 == 0 ))" != 0 ]; then
        colored__2006_v0 "${line_27485}" 90
        local ret_colored2006_v0__12_40="${ret_colored2006_v0}"
        local array_409=()
        printf__128_v0 "${pending_27484}""${ret_colored2006_v0__12_40}""
" array_409[@]
    else
        slice__24_v0 "${line_27485}" 0 "${note_at_27486}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_27485}" "${note_at_27486}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2006_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2006_v0__13_58="${ret_colored2006_v0}"
        local array_410=()
        printf__128_v0 "${pending_27484}""${ret_slice24_v0__13_32}""${ret_colored2006_v0__13_58}""
" array_410[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2087_v0() {
    local names_27457=("${!1}")
    local texts_27458=("${!2}")
    local notes_27459=("${!3}")
    local min_name_width_27460="${4}"
    local __length_411=("${names_27457[@]}")
    local count_27461="${#__length_411[@]}"
    local name_width_27462="${min_name_width_27460}"
    local __range_start_27463=0
    local __range_end_27463="${count_27461}"
    local __dir_27463=$(( ${__range_start_27463} <= ${__range_end_27463} ? 1 : -1 ))
    for (( i_27463=${__range_start_27463}; i_27463 * ${__dir_27463} < ${__range_end_27463} * ${__dir_27463}; i_27463+=${__dir_27463} )); do
        local __length_412="${names_27457[${i_27463}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:28:33)"}"
        local width_27464="${#__length_412}"
        if [ "$(( width_27464 > name_width_27462 ))" != 0 ]; then
            name_width_27462="${width_27464}"
        fi
done
    term_width__2053_v0 
    local width_27470="${ret_term_width2053_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_27471="$(( name_width_27462 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_27472="$(( $(( width_27470 - indent_27471 )) < 24 ))"
    if [ "${stacked_27472}" != 0 ]; then
        indent_27471=6
    fi
    local avail_27473="$(( width_27470 - indent_27471 ))"
    rpad__28_v0 "" " " "${indent_27471}"
    local blank_27474="${ret_rpad28_v0}"
    local __range_start_27475=0
    local __range_end_27475="${count_27461}"
    local __dir_27475=$(( ${__range_start_27475} <= ${__range_end_27475} ? 1 : -1 ))
    for (( i_27475=${__range_start_27475}; i_27475 * ${__dir_27475} < ${__range_end_27475} * ${__dir_27475}; i_27475+=${__dir_27475} )); do
        local pending_27476="${blank_27474}"
        if [ "${stacked_27472}" != 0 ]; then
            local array_413=()
            printf__128_v0 "  ""${names_27457[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:48:33)"}""
" array_413[@]
        else
            rpad__28_v0 "  ""${names_27457[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:50:41)"}" " " "${indent_27471}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_27476="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_27458[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_27477=("${ret_split4_v0__52_21[@]}")
        local __length_414=("${words_27477[@]}")
        local note_start_27478="${#__length_414[@]}"
        if [ "$([ "_${notes_27459[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_415="${notes_27459[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_415} > avail_27473 ))" != 0 ]; then
                split__4_v0 "${notes_27459[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_27477+=("${ret_split4_v0__58_26[@]}")
            else
                local array_416=("${notes_27459[${i_27475}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:60:33)"}")
                words_27477+=("${array_416[@]}")
            fi
        fi
        local line_27479=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_27480=-1
        local __range_start_27481=0
        local __length_417=("${words_27477[@]}")
        local __range_end_27481="${#__length_417[@]}"
        local __dir_27481=$(( ${__range_start_27481} <= ${__range_end_27481} ? 1 : -1 ))
        for (( j_27481=${__range_start_27481}; j_27481 * ${__dir_27481} < ${__range_end_27481} * ${__dir_27481}; j_27481+=${__dir_27481} )); do
            local word_27482="${words_27477[${j_27481}]?"Index out of bounds (at src/./filter/../utils/widget/help.ab:70:32)"}"
            local candidate_27483
            candidate_27483="$(if [ "$([ "_${line_27479}" != "_" ]; echo $?)" != 0 ]; then echo "${word_27482}"; else echo "${line_27479}"" ""${word_27482}"; fi)"
            local __length_418="${candidate_27483}"
            if [ "$(( $(( ${#__length_418} > avail_27473 )) && $([ "_${line_27479}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2086_v0 "${pending_27476}" "${line_27479}" "${note_at_27480}"
                pending_27476="${blank_27474}"
                line_27479="${word_27482}"
                note_at_27480="$(if [ "$(( j_27481 >= note_start_27478 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_27481 >= note_start_27478 )) && $(( note_at_27480 < 0 )) ))" != 0 ]; then
                    local __length_419="${candidate_27483}"
                    local __length_420="${word_27482}"
                    note_at_27480="$(( ${#__length_419} - ${#__length_420} ))"
                fi
                line_27479="${candidate_27483}"
            fi
done
        print_help_line__2086_v0 "${pending_27476}" "${line_27479}" "${note_at_27480}"
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
refresh_matches__2145_v0() {
    local command_423
    command_423="$(shopt -s nocasematch; __e=""; __p=""; __s=""; __i=0; for __it in "${_options_110[@]}"; do case "$__it" in ("${_query_114}") __e="$__e $__i";; ("${_query_114}"*) __p="$__p $__i";; (*"${_query_114}"*) __s="$__s $__i";; esac; __i=$((__i+1)); done; __a="$__e$__p$__s"; printf '%s' "${__a# }")"
    __status=$?
    local raw_27521="${command_423}"
    if [ "$([ "_${raw_27521}" != "_" ]; echo $?)" != 0 ]; then
        _matches_112=()
    else
        split__4_v0 "${raw_27521}" " "
        _matches_112=("${ret_split4_v0[@]}")
    fi
    local __length_425=("${_matches_112[@]}")
    _match_count_113="${#__length_425[@]}"
    _offset_119=0
    _sel_120=0
}

# visible_count()
visible_count__2146_v0() {
    local count_27581="$(( _match_count_113 - _offset_119 ))"
    if [ "$(( count_27581 > _height_118 ))" != 0 ]; then
        count_27581="${_height_118}"
    fi
    if [ "$(( count_27581 < 0 ))" != 0 ]; then
        count_27581=0
    fi
    ret_visible_count2146_v0="${count_27581}"
    return 0
}

# option_index(row: Int)
option_index__2147_v0() {
    local row_27586="${1}"
    parse_int__13_v0 "${_matches_112[$(( _offset_119 + row_27586 ))]?"Index out of bounds (at src/./filter/./mod.ab:52:37)"}"
    __status=$?
    ret_option_index2147_v0="${ret_parse_int13_v0}"
    return 0
}

# option_width()
option_width__2148_v0() {
    local check_width_27587
    check_width_27587="$(if [ "${_multi_121}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_426="${_cursor_117}"
    ret_option_width2148_v0="$(( $(( _term_width_123 - ${#__length_426} )) - check_width_27587 ))"
    return 0
}

# row_line(row: Int, highlighted: Bool)
row_line__2149_v0() {
    local row_27584="${1}"
    local highlighted_27585="${2}"
    option_index__2147_v0 "${row_27584}"
    local ret_option_index2147_v0__61_44="${ret_option_index2147_v0}"
    option_width__2148_v0 
    local ret_option_width2148_v0__61_64="${ret_option_width2148_v0}"
    cutoff_text__1983_v0 "${_options_110[${ret_option_index2147_v0__61_44}]?"Index out of bounds (at src/./filter/./mod.ab:61:44)"}" "${ret_option_width2148_v0__61_64}"
    local truncated_27588="${ret_cutoff_text1983_v0}"
    local __length_427="${_cursor_117}"
    rpad__28_v0 "" " " "${#__length_427}"
    local blank_27589="${ret_rpad28_v0}"
    if [ "$(( ! _multi_121 ))" != 0 ]; then
        if [ "${highlighted_27585}" != 0 ]; then
            colored_secondary__1952_v0 "${_cursor_117}""${truncated_27588}"
            ret_row_line2149_v0="${ret_colored_secondary1952_v0}"
            return 0
        fi
        ret_row_line2149_v0="${blank_27589}""${truncated_27588}"
        return 0
    fi
    option_index__2147_v0 "${row_27584}"
    local ret_option_index2147_v0__69_31="${ret_option_index2147_v0}"
    checked_is__2071_v0 "${ret_option_index2147_v0__69_31}"
    local ticked_27591="${ret_checked_is2071_v0}"
    local mark_27592
    mark_27592="$(if [ "${ticked_27591}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    if [ "${highlighted_27585}" != 0 ]; then
        colored_secondary__1952_v0 "${_cursor_117}""${mark_27592}""${truncated_27588}"
        ret_row_line2149_v0="${ret_colored_secondary1952_v0}"
        return 0
    fi
    if [ "${ticked_27591}" != 0 ]; then
        colored_secondary__1952_v0 "${mark_27592}""${truncated_27588}"
        local ret_colored_secondary1952_v0__75_24="${ret_colored_secondary1952_v0}"
        ret_row_line2149_v0="${blank_27589}""${ret_colored_secondary1952_v0__75_24}"
        return 0
    fi
    ret_row_line2149_v0="${blank_27589}""${mark_27592}""${truncated_27588}"
    return 0
}

# render_rows()
render_rows__2150_v0() {
    visible_count__2146_v0 
    local count_27582="${ret_visible_count2146_v0}"
    go_up__1904_v0 "${_height_118}"
    local array_428=("")
    eprintf__1848_v0 "\\x1b[G" array_428[@]
    local __range_start_27583=0
    local __range_end_27583="${count_27582}"
    local __dir_27583=$(( ${__range_start_27583} <= ${__range_end_27583} ? 1 : -1 ))
    for (( row_27583=${__range_start_27583}; row_27583 * ${__dir_27583} < ${__range_end_27583} * ${__dir_27583}; row_27583+=${__dir_27583} )); do
        row_line__2149_v0 "${row_27583}" "$(( row_27583 == _sel_120 ))"
        local ret_row_line2149_v0__86_28="${ret_row_line2149_v0}"
        local array_429=("")
        eprintf__1848_v0 "\\x1b[K""${ret_row_line2149_v0__86_28}""
" array_429[@]
done
    local __range_start_27593="${count_27582}"
    local __range_end_27593="${_height_118}"
    local __dir_27593=$(( ${__range_start_27593} <= ${__range_end_27593} ? 1 : -1 ))
    for (( ____27593=${__range_start_27593}; ____27593 * ${__dir_27593} < ${__range_end_27593} * ${__dir_27593}; ____27593+=${__dir_27593} )); do
        local array_430=("")
        eprintf__1848_v0 "\\x1b[K
" array_430[@]
done
    local array_431=("")
    eprintf__1848_v0 "\\x1b[G" array_431[@]
}

# render_query()
render_query__2151_v0() {
    go_up__1904_v0 "$(( _height_118 + 1 ))"
    local array_432=("")
    eprintf__1848_v0 "\\x1b[G\\x1b[K" array_432[@]
    colored_primary__1951_v0 "${_prompt_116}"
    local ret_colored_primary1951_v0__97_13="${ret_colored_primary1951_v0}"
    local array_433=("")
    eprintf__1848_v0 "${ret_colored_primary1951_v0__97_13}" array_433[@]
    if [ "$([ "_${_query_114}" != "_" ]; echo $?)" != 0 ]; then
        eprintf_colored__1849_v0 "${_placeholder_115}" 90
    else
        local __length_434="${_prompt_116}"
        cutoff_text__1983_v0 "${_query_114}" "$(( _term_width_123 - ${#__length_434} ))"
        local ret_cutoff_text1983_v0__101_17="${ret_cutoff_text1983_v0}"
        local array_435=("")
        eprintf__1848_v0 "${ret_cutoff_text1983_v0__101_17}" array_435[@]
    fi
    go_down__1905_v0 "$(( _height_118 + 1 ))"
    local array_436=("")
    eprintf__1848_v0 "\\x1b[G" array_436[@]
}

# render_count()
render_count__2152_v0() {
    local array_437=("")
    eprintf__1848_v0 "\\x1b[G\\x1b[K" array_437[@]
    eprintf_colored__1849_v0 "${_match_count_113}/${_option_count_111}" 90
    local array_438=("")
    eprintf__1848_v0 "\\x1b[G" array_438[@]
}

# render_tooltip_line()
render_tooltip_line__2153_v0() {
    if [ "${_multi_121}" != 0 ]; then
        local array_439=("↑↓" "select" "tab" "toggle" "ctrl-a" "all" "enter" "confirm")
        render_tooltip__2010_v0 array_439[@] 51 "${_term_width_123}"
    else
        local array_440=("↑↓" "select" "enter" "confirm")
        render_tooltip__2010_v0 array_440[@] 25 "${_term_width_123}"
    fi
}

# move_selection(step: Int)
move_selection__2154_v0() {
    local step_27596="${1}"
    visible_count__2146_v0 
    local count_27597="${ret_visible_count2146_v0}"
    if [ "$(( count_27597 == 0 ))" != 0 ]; then
        ret_move_selection2154_v0=0
        return 0
    fi
    local next_27598="$(( _sel_120 + step_27596 ))"
    if [ "$(( $(( next_27598 >= 0 )) && $(( next_27598 < count_27597 )) ))" != 0 ]; then
        local prev_27599="${_sel_120}"
        _sel_120="${next_27598}"
        row_line__2149_v0 "${prev_27599}" 0
        local ret_row_line2149_v0__132_35="${ret_row_line2149_v0}"
        redraw_row__2068_v0 "${_height_118}" "${prev_27599}" "${ret_row_line2149_v0__132_35}"
        row_line__2149_v0 "${_sel_120}" 1
        local ret_row_line2149_v0__133_35="${ret_row_line2149_v0}"
        redraw_row__2068_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2149_v0__133_35}"
        ret_move_selection2154_v0=0
        return 0
    fi
    if [ "$(( $(( next_27598 < 0 )) && $(( _offset_119 > 0 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 - 1 ))"
        ret_move_selection2154_v0=1
        return 0
    fi
    if [ "$(( $(( next_27598 >= count_27597 )) && $(( $(( _offset_119 + _height_118 )) < _match_count_113 )) ))" != 0 ]; then
        _offset_119="$(( _offset_119 + 1 ))"
        ret_move_selection2154_v0=1
        return 0
    fi
    ret_move_selection2154_v0=0
    return 0
}

# xyl_filter(options: [Text], prompt: Text, placeholder: Text, header: Text, cursor: Text, multi: Bool, limit: Int, height: Int)
xyl_filter__2155_v0() {
    local options_27502=("${!1}")
    local prompt_27503="${2}"
    local placeholder_27504="${3}"
    local header_27505="${4}"
    local cursor_27506="${5}"
    local multi_27507="${6}"
    local limit_27508="${7}"
    local height_27509="${8}"
    local __length_441=("${options_27502[@]}")
    local total_27510="${#__length_441[@]}"
    if [ "$(( total_27510 == 0 ))" != 0 ]; then
        eprintf_colored__1849_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    _options_110=("${options_27502[@]}")
    _option_count_111="${total_27510}"
    _query_114=""
    _prompt_116="${prompt_27503}"
    _placeholder_115="${placeholder_27504}"
    _cursor_117="${cursor_27506}"
    _multi_121="${multi_27507}"
    _has_header_122="$([ "_${header_27505}" == "_" ]; echo $?)"
    _offset_119=0
    _sel_120=0
    stty_lock__1890_v0 
    hide_cursor__1907_v0 
    term_width__1897_v0 
    _term_width_123="${ret_term_width1897_v0}"
    term_height__1898_v0 
    local ret_term_height1898_v0__189_24="${ret_term_height1898_v0}"
    local max_height_27517
    max_height_27517="$(( ret_term_height1898_v0__189_24 - $(if [ "${_has_header_122}" != 0 ]; then echo 4; else echo 3; fi) ))"
    _height_118="${height_27509}"
    if [ "$(( _height_118 > max_height_27517 ))" != 0 ]; then
        _height_118="${max_height_27517}"
    fi
    if [ "$(( _height_118 < 1 ))" != 0 ]; then
        _height_118=1
    fi
    if [ "${multi_27507}" != 0 ]; then
        checked_init__2070_v0 "${total_27510}" "${limit_27508}"
    fi
    refresh_matches__2145_v0 
    if [ "${_has_header_122}" != 0 ]; then
        cutoff_text__1983_v0 "${header_27505}" "${_term_width_123}"
        local ret_cutoff_text1983_v0__204_17="${ret_cutoff_text1983_v0}"
        local array_442=("")
        eprintf__1848_v0 "${ret_cutoff_text1983_v0__204_17}""
" array_442[@]
    fi
    new_line__1903_v0 1
    new_line__1903_v0 "${_height_118}"
    render_count__2152_v0 
    new_line__1903_v0 1
    render_tooltip_line__2153_v0 
    go_up__1904_v0 1
    local array_443=("")
    eprintf__1848_v0 "\\x1b[G" array_443[@]
    render_rows__2150_v0 
    render_query__2151_v0 
    while :
    do
        get_key__1846_v0 
        local key_27595="${ret_get_key1846_v0}"
        if [ "$([ "_${key_27595}" != "_INPUT" ]; echo $?)" != 0 ]; then
            visible_count__2146_v0 
            local ret_visible_count2146_v0__221_20="${ret_visible_count2146_v0}"
            if [ "$(( ret_visible_count2146_v0__221_20 > 0 ))" != 0 ]; then
                break
            fi
            if [ "${_multi_121}" != 0 ]; then
                checked_count__2072_v0 
                local ret_checked_count2072_v0__225_24="${ret_checked_count2072_v0}"
                if [ "$(( ret_checked_count2072_v0__225_24 > 0 ))" != 0 ]; then
                    break
                fi
            fi
        elif [ "$([ "_${key_27595}" != "_UP" ]; echo $?)" != 0 ]; then
            move_selection__2154_v0 -1
            local ret_move_selection2154_v0__231_20="${ret_move_selection2154_v0}"
            if [ "${ret_move_selection2154_v0__231_20}" != 0 ]; then
                render_rows__2150_v0 
            fi
        elif [ "$([ "_${key_27595}" != "_DOWN" ]; echo $?)" != 0 ]; then
            move_selection__2154_v0 1
            local ret_move_selection2154_v0__236_20="${ret_move_selection2154_v0}"
            if [ "${ret_move_selection2154_v0__236_20}" != 0 ]; then
                render_rows__2150_v0 
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27595}" != "_TAB" ]; echo $?) ))" != 0 ]; then
            visible_count__2146_v0 
            local ret_visible_count2146_v0__241_20="${ret_visible_count2146_v0}"
            if [ "$(( ret_visible_count2146_v0__241_20 > 0 ))" != 0 ]; then
                option_index__2147_v0 "${_sel_120}"
                local ret_option_index2147_v0__242_39="${ret_option_index2147_v0}"
                checked_toggle__2073_v0 "${ret_option_index2147_v0__242_39}"
                local ret_checked_toggle2073_v0__242_24="${ret_checked_toggle2073_v0}"
                if [ "${ret_checked_toggle2073_v0__242_24}" != 0 ]; then
                    row_line__2149_v0 "${_sel_120}" 1
                    local ret_row_line2149_v0__243_51="${ret_row_line2149_v0}"
                    redraw_row__2068_v0 "${_height_118}" "${_sel_120}" "${ret_row_line2149_v0__243_51}"
                fi
            fi
        elif [ "$(( _multi_121 && $([ "_${key_27595}" != "_CTRL_A" ]; echo $?) ))" != 0 ]; then
            checked_all__2074_v0 
            local ret_checked_all2074_v0__248_20="${ret_checked_all2074_v0}"
            if [ "${ret_checked_all2074_v0__248_20}" != 0 ]; then
                render_rows__2150_v0 
            fi
        elif [ "$([ "_${key_27595}" != "_BACKSPACE" ]; echo $?)" != 0 ]; then
            if [ "$([ "_${_query_114}" == "_" ]; echo $?)" != 0 ]; then
                local __length_444="${_query_114}"
                if [ "$(( ${#__length_444} == 1 ))" != 0 ]; then
                    _query_114=""
                else
                    local __length_445="${_query_114}"
                    slice__24_v0 "${_query_114}" 0 "$(( ${#__length_445} - 1 ))"
                    _query_114="${ret_slice24_v0}"
                fi
                refresh_matches__2145_v0 
                render_rows__2150_v0 
                render_query__2151_v0 
                render_count__2152_v0 
            fi
        else
            local typed_27610="${key_27595}"
            if [ "$([ "_${key_27595}" != "_SPACE" ]; echo $?)" != 0 ]; then
                typed_27610=" "
            fi
            local __length_446="${typed_27610}"
            if [ "$(( ${#__length_446} == 1 ))" != 0 ]; then
                _query_114+="${typed_27610}"
                refresh_matches__2145_v0 
                render_rows__2150_v0 
                render_query__2151_v0 
                render_count__2152_v0 
            fi
        fi
    done
    local total_lines_27611="$(( _height_118 + 3 ))"
    if [ "${_has_header_122}" != 0 ]; then
        total_lines_27611="$(( total_lines_27611 + 1 ))"
    fi
    go_down__1905_v0 1
    remove_line__1900_v0 "$(( total_lines_27611 - 1 ))"
    remove_current_line__1901_v0 
    stty_unlock__1891_v0 
    show_cursor__1908_v0 
    local result_27616=()
    if [ "${_multi_121}" != 0 ]; then
        local __range_start_27617=0
        local __range_end_27617="${total_27510}"
        local __dir_27617=$(( ${__range_start_27617} <= ${__range_end_27617} ? 1 : -1 ))
        for (( i_27617=${__range_start_27617}; i_27617 * ${__dir_27617} < ${__range_end_27617} * ${__dir_27617}; i_27617+=${__dir_27617} )); do
            checked_is__2071_v0 "${i_27617}"
            local ret_checked_is2071_v0__294_16="${ret_checked_is2071_v0}"
            if [ "${ret_checked_is2071_v0__294_16}" != 0 ]; then
                local array_448=("${_options_110[${i_27617}]?"Index out of bounds (at src/./filter/./mod.ab:295:37)"}")
                result_27616+=("${array_448[@]}")
            fi
done
        ret_xyl_filter2155_v0=("${result_27616[@]}")
        return 0
    fi
    visible_count__2146_v0 
    local ret_visible_count2146_v0__300_8="${ret_visible_count2146_v0}"
    if [ "$(( ret_visible_count2146_v0__300_8 > 0 ))" != 0 ]; then
        option_index__2147_v0 "${_sel_120}"
        local ret_option_index2147_v0__301_29="${ret_option_index2147_v0}"
        result_27616+=("${_options_110[${ret_option_index2147_v0__301_29}]?"Index out of bounds (at src/./filter/./mod.ab:301:29)"}")
    fi
    ret_xyl_filter2155_v0=("${result_27616[@]}")
    return 0
}

# print_filter_help()
print_filter_help__2255_v0() {
    local usage_27415=("Usage:" "./xylitol.sh" "filter" "[<options>" "...]" "[flags]")
    print_wrapped__1909_v0 usage_27415[@]
    printf '%s\n' ""
    colored_primary__1951_v0 "filter"
    local ret_colored_primary1951_v0__8_20="${ret_colored_primary1951_v0}"
    local title_27455=("${ret_colored_primary1951_v0__8_20}" "-" "Pick" "from" "a" "list" "narrowed" "by" "typing.")
    print_wrapped__1909_v0 title_27455[@]
    printf '%s\n' ""
    colored_secondary__1952_v0 "Arguments:"
    local ret_colored_secondary1952_v0__11_12="${ret_colored_secondary1952_v0}"
    local array_452=()
    printf__128_v0 "${ret_colored_secondary1952_v0__11_12}""
" array_452[@]
    local array_453=("[<options> ...]")
    local array_454=("List of options to pick from")
    local array_455=("")
    render_help_entries__2087_v0 array_453[@] array_454[@] array_455[@] 20
    printf '%s\n' ""
    colored_secondary__1952_v0 "Flags:"
    local ret_colored_secondary1952_v0__14_12="${ret_colored_secondary1952_v0}"
    local array_456=()
    printf__128_v0 "${ret_colored_secondary1952_v0__14_12}""
" array_456[@]
    local names_27489=("-h, --help" "--limit=<number>" "--no-limit" "--prompt=\"<text>\"" "--placeholder=\"<text>\"" "--cursor=\"<text>\"" "--header=\"<text>\"" "--height=<number>")
    local texts_27490=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the text shown in front of the query" "Set the text shown while the query is empty" "Set the cursor text" "Set a header text to display above the query" "Set the number of options shown at once")
    local notes_27491=("" "" "" "(default: '/ ')" "(default: 'Filter...')" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__2087_v0 names_27489[@] texts_27490[@] notes_27491[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__2313_v0() {
    local options_27408=()
    local command_461
    command_461="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_27409="${command_461}"
    if [ "$([ "_${is_tty_27409}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_27408+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options2313_v0=("${options_27408[@]}")
    return 0
}

# execute_filter(parameters: [Text])
execute_filter__2314_v0() {
    local parameters_27403=("${!1}")
    local cursor_27404="> "
    local prompt_27405="/ "
    local placeholder_27406="Filter..."
    local header_27407=""
    read_stdin_options__2313_v0 
    local options_27410=("${ret_read_stdin_options2313_v0[@]}")
    local multi_27411=0
    local limit_27412=-1
    local height_27413=10
    local __length_465=("${parameters_27403[@]}")
    local slice_upper_464="${#__length_465[@]}"
    local slice_offset_466=2
    local slice_offset_466=$((${slice_offset_466} > 0 ? ${slice_offset_466} : 0))
    local slice_length_467="$(( slice_upper_464 - slice_offset_466 ))"
    local slice_length_467=$((${slice_length_467} > 0 ? ${slice_length_467} : 0))
    for param_27414 in "${parameters_27403[@]:${slice_offset_466}:${slice_length_467}}"; do
        starts_with__22_v0 "${param_27414}" "--cursor="
        local ret_starts_with22_v0__31_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27414}" "--prompt="
        local ret_starts_with22_v0__34_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27414}" "--placeholder="
        local ret_starts_with22_v0__37_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27414}" "--header="
        local ret_starts_with22_v0__40_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27414}" "--limit="
        local ret_starts_with22_v0__43_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27414}" "--height="
        local ret_starts_with22_v0__54_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27414}" != "_-h" ]; echo $?) || $([ "_${param_27414}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_filter_help__2255_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__31_13}" != 0 ]; then
            local __length_468="--cursor="
            slice__24_v0 "${param_27414}" "${#__length_468}" 0
            cursor_27404="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__34_13}" != 0 ]; then
            local __length_469="--prompt="
            slice__24_v0 "${param_27414}" "${#__length_469}" 0
            prompt_27405="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__37_13}" != 0 ]; then
            local __length_470="--placeholder="
            slice__24_v0 "${param_27414}" "${#__length_470}" 0
            placeholder_27406="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__40_13}" != 0 ]; then
            local __length_471="--header="
            slice__24_v0 "${param_27414}" "${#__length_471}" 0
            header_27407="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__43_13}" != 0 ]; then
            local __length_472="--limit="
            slice__24_v0 "${param_27414}" "${#__length_472}" 0
            local value_27492="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27492}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1849_v0 "ERROR: Invalid limit value: ""${value_27492}""
" 31
                exit 1
            fi
            limit_27412="${ret_parse_int13_v0}"
            multi_27411=1
        elif [ "$([ "_${param_27414}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_27411=1
        elif [ "${ret_starts_with22_v0__54_13}" != 0 ]; then
            local __length_473="--height="
            slice__24_v0 "${param_27414}" "${#__length_473}" 0
            local value_27497="${ret_slice24_v0}"
            parse_int__13_v0 "${value_27497}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1849_v0 "ERROR: Invalid height value: ""${value_27497}""
" 31
                exit 1
            fi
            height_27413="${ret_parse_int13_v0}"
        else
            options_27410+=("${param_27414}")
        fi
    done
    has_ansi_escape__1975_v0 "${header_27407}"
    local ret_has_ansi_escape1975_v0__67_44="${ret_has_ansi_escape1975_v0}"
    escape_ansi__1976_v0 "${header_27407}"
    local ret_escape_ansi1976_v0__67_73="${ret_escape_ansi1976_v0}"
    colored_primary__1951_v0 "${header_27407}"
    local ret_colored_primary1951_v0__67_111="${ret_colored_primary1951_v0}"
    local display_header_27501
    display_header_27501="$(if [ "$(( $([ "_${header_27407}" != "_" ]; echo $?) || ret_has_ansi_escape1975_v0__67_44 ))" != 0 ]; then echo "${ret_escape_ansi1976_v0__67_73}"; else echo "\\x1b[1m""${ret_colored_primary1951_v0__67_111}"; fi)"
    xyl_filter__2155_v0 options_27410[@] "${prompt_27405}" "${placeholder_27406}" "${display_header_27501}" "${cursor_27404}" "${multi_27411}" "${limit_27412}" "${height_27413}"
    local results_27618=("${ret_xyl_filter2155_v0[@]}")
    join__7_v0 results_27618[@] "
"
    ret_execute_filter2314_v0="${ret_join7_v0}"
    return 0
}

# get_key()
get_key__2438_v0() {
    local command_475
    command_475="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key2438_v0="${command_475}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2440_v0() {
    local format_29695="${1}"
    local args_29696=("${!2}")
    args_29696=("${format_29695}" "${args_29696[@]}")
    __status=$?
    printf "${args_29696[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2441_v0() {
    local message_29693="${1}"
    local color_29694="${2}"
    # Prints an error message with a specified color.
    local array_476=("${message_29693}")
    eprintf__2440_v0 "\\x1b[${color_29694}m%s\\x1b[0m" array_476[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2456_v0() {
    local format_29707="${1}"
    local args_29708=("${!2}")
    args_29708=("${format_29707}" "${args_29708[@]}")
    __status=$?
    printf "${args_29708[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2457_v0() {
    local message_29705="${1}"
    local color_29706="${2}"
    # Prints an error message with a specified color.
    local array_477=("${message_29705}")
    eprintf__2456_v0 "\\x1b[${color_29706}m%s\\x1b[0m" array_477[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_126="None"
# perl_available()
perl_available__2464_v0() {
    if [ "$([ "_${_perl_state_126}" != "_None" ]; echo $?)" != 0 ]; then
        local command_478
        command_478="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29651
        disabled_29651="$([ "_${command_478}" != "_No" ]; echo $?)"
        local command_479
        command_479="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29652
        found_29652="$(( $(( ! disabled_29651 )) && $([ "_${command_479}" != "_0" ]; echo $?) ))"
        _perl_state_126="$(if [ "${found_29652}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2464_v0="$([ "_${_perl_state_126}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2465_v0() {
    local text_29650="${1}"
    perl_available__2464_v0 
    local ret_perl_available2464_v0__19_12="${ret_perl_available2464_v0}"
    if [ "$(( ! ret_perl_available2464_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2465_v0=''
        return 1
    fi
    local command_480
    command_480="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29650}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2465_v0=''
        return "${__status}"
    fi
    local width_str_29653="${command_480}"
    parse_int__13_v0 "${width_str_29653}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2465_v0=''
        return "${__status}"
    fi
    local width_29654="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2465_v0="${width_29654}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2470_v0() {
    local text_29640="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_481
    command_481="$([[ "${text_29640}" == *$'\x1b'* || "${text_29640}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29641="${command_481}"
    ret_has_ansi_escape2470_v0="$([ "_${has_escape_29641}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2472_v0() {
    local text_29646="${1}"
    local command_482
    command_482="$(printf "%s" "${text_29646}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2472_v0="${command_482}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2473_v0() {
    local text_29648="${1}"
    local command_483
    command_483="$(printf "%s" "${text_29648}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29649="${command_483}"
    ret_is_all_ascii2473_v0="$([ "_${result_29649}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2474_v0() {
    local text_29643="${1}"
    local command_484
    command_484="$(LC_ALL=C; __t="${text_29643}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29644="${command_484}"
    parse_int__13_v0 "${measured_29644}"
    __status=$?
    ret_plain_len2474_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2475_v0() {
    local text_29642="${1}"
    plain_len__2474_v0 "${text_29642}"
    local plain_29645="${ret_plain_len2474_v0}"
    if [ "$(( plain_29645 >= 0 ))" != 0 ]; then
        ret_get_visible_len2475_v0="${plain_29645}"
        return 0
    fi
    strip_ansi__2472_v0 "${text_29642}"
    local stripped_29647="${ret_strip_ansi2472_v0}"
    is_all_ascii__2473_v0 "${stripped_29647}"
    local ret_is_all_ascii2473_v0__46_12="${ret_is_all_ascii2473_v0}"
    if [ "$(( ! ret_is_all_ascii2473_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2465_v0 "${stripped_29647}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_485="${stripped_29647}"
            ret_get_visible_len2475_v0="${#__length_485}"
            return 0
        fi
        ret_get_visible_len2475_v0="${ret_perl_get_cjk_width2465_v0}"
        return 0
    fi
    local __length_486="${stripped_29647}"
    ret_get_visible_len2475_v0="${#__length_486}"
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
stty_count__2481_v0() {
    local command_488
    command_488="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_29703="${command_488}"
    parse_int__13_v0 "${count_29703}"
    __status=$?
    ret_stty_count2481_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2482_v0() {
    stty_count__2481_v0 
    local count_num_29704="${ret_stty_count2481_v0}"
    if [ "$(( count_num_29704 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 2>/dev/null < /dev/tty
        __status=$?
        if [ "${__status}" != 0 ]; then
            eprintf_colored__2457_v0 "Error: " 91
            local array_489=("")
            eprintf__2456_v0 "xylitol needs a terminal, and /dev/tty is not available here.
" array_489[@]
            exit 1
        fi
    fi
    count_num_29704="$(( count_num_29704 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29704}
    __status=$?
}

# stty_unlock()
stty_unlock__2483_v0() {
    stty_count__2481_v0 
    local count_num_29800="${ret_stty_count2481_v0}"
    if [ "$(( count_num_29800 > 0 ))" != 0 ]; then
        count_num_29800="$(( count_num_29800 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_29800}
        __status=$?
        if [ "$(( count_num_29800 == 0 ))" != 0 ]; then
            stty echo icanon 2>/dev/null < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2484_v0() {
    local size_29631="${1}"
    if [ "$([ "_${size_29631}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2484_v0=0
        return 0
    fi
    split__4_v0 "${size_29631}" " "
    local parts_29632=("${ret_split4_v0[@]}")
    local __length_490=("${parts_29632[@]}")
    if [ "$(( ${#__length_490[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2484_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29632[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29632[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_128=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size2484_v0=1
    return 0
}

# query_term_size()
query_term_size__2485_v0() {
    local command_492
    command_492="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29634="${command_492}"
    store_term_size__2484_v0 "${size_29634}"
    ret_query_term_size2485_v0="${ret_store_term_size2484_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2486_v0() {
    local command_493
    command_493="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29630="${command_493}"
    store_term_size__2484_v0 "${size_29630}"
    ret_stty_term_size2486_v0="${ret_store_term_size2484_v0}"
    return 0
}

# get_term_size()
get_term_size__2487_v0() {
    stty_term_size__2486_v0 
    local detected_29633="${ret_stty_term_size2486_v0}"
    if [ "$(( ! detected_29633 ))" != 0 ]; then
        query_term_size__2485_v0 
        detected_29633="${ret_query_term_size2485_v0}"
    fi
    _got_term_size_127=1
}

# term_width()
term_width__2489_v0() {
    if [ "$(( ! _got_term_size_127 ))" != 0 ]; then
        get_term_size__2487_v0 
    fi
    ret_term_width2489_v0="${_term_size_128[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2492_v0() {
    local cnt_29797="${1}"
    if [ "$(( cnt_29797 > 0 ))" != 0 ]; then
        local sequence_29798=""
        local __range_start_29799=0
        local __range_end_29799="${cnt_29797}"
        local __dir_29799=$(( ${__range_start_29799} <= ${__range_end_29799} ? 1 : -1 ))
        for (( ____29799=${__range_start_29799}; ____29799 * ${__dir_29799} < ${__range_end_29799} * ${__dir_29799}; ____29799+=${__dir_29799} )); do
            sequence_29798+="\\x1b[2K\\x1b[1A"
done
        local array_494=("")
        eprintf__2456_v0 "${sequence_29798}" array_494[@]
    fi
    local array_495=("")
    eprintf__2456_v0 "\\x1b[G" array_495[@]
}

# remove_current_line()
remove_current_line__2493_v0() {
    local array_496=("")
    eprintf__2456_v0 "\\x1b[2K\\x1b[G" array_496[@]
}

# go_up(cnt: Int)
go_up__2496_v0() {
    local cnt_29793="${1}"
    local array_497=("")
    eprintf__2456_v0 "\\x1b[${cnt_29793}A" array_497[@]
}

# go_down(cnt: Int)
go_down__2497_v0() {
    local cnt_29796="${1}"
    local array_498=("")
    eprintf__2456_v0 "\\x1b[${cnt_29796}B" array_498[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__2499_v0() {
    local array_499=("")
    eprintf__2456_v0 "\\x1b[?25l" array_499[@]
}

# show_cursor()
show_cursor__2500_v0() {
    local array_500=("")
    eprintf__2456_v0 "\\x1b[?25h" array_500[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__2501_v0() {
    local pieces_29629=("${!1}")
    term_width__2489_v0 
    local width_29635="${ret_term_width2489_v0}"
    local line_29636=""
    local line_len_29637=0
    for piece_29638 in "${pieces_29629[@]}"; do
        local __length_503="${piece_29638}"
        local piece_len_29639="${#__length_503}"
        has_ansi_escape__2470_v0 "${piece_29638}"
        local ret_has_ansi_escape2470_v0__190_12="${ret_has_ansi_escape2470_v0}"
        if [ "${ret_has_ansi_escape2470_v0__190_12}" != 0 ]; then
            get_visible_len__2475_v0 "${piece_29638}"
            piece_len_29639="${ret_get_visible_len2475_v0}"
        fi
        if [ "$([ "_${line_29636}" != "_" ]; echo $?)" != 0 ]; then
            line_29636="${piece_29638}"
            line_len_29637="${piece_len_29639}"
        elif [ "$(( $(( $(( line_len_29637 + 1 )) + piece_len_29639 )) > width_29635 ))" != 0 ]; then
            local array_504=()
            printf__128_v0 "${line_29636}""
" array_504[@]
            line_29636="${piece_29638}"
            line_len_29637="${piece_len_29639}"
        else
            line_29636+=" ""${piece_29638}"
            line_len_29637="$(( line_len_29637 + $(( 1 + piece_len_29639 )) ))"
        fi
    done
    if [ "$([ "_${line_29636}" == "_" ]; echo $?)" != 0 ]; then
        local array_505=()
        printf__128_v0 "${line_29636}""
" array_505[@]
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
get_supports_truecolor__2538_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_29624="${ret_env_var_get120_v0}"
    _supports_truecolor_131="$(if [ "$([ "_${config_29624}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2538_v0="$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2539_v0() {
    local message_29619="${1}"
    local r_29620="${2}"
    local g_29621="${3}"
    local b_29622="${4}"
    local fallback_29623="${5}"
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2539_v0="\\x1b[38;2;${r_29620};${g_29621};${b_29622}m""${message_29619}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2538_v0 
        local ret_get_supports_truecolor2538_v0__45_17="${ret_get_supports_truecolor2538_v0}"
        if [ "${ret_get_supports_truecolor2538_v0__45_17}" != 0 ]; then
            ret_colored_rgb2539_v0="\\x1b[38;2;${r_29620};${g_29621};${b_29622}m""${message_29619}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_29623 == 0 ))" != 0 ]; then
            ret_colored_rgb2539_v0="${message_29619}"
            return 0
        else
            ret_colored_rgb2539_v0="\\x1b[${fallback_29623}m""${message_29619}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_29623 == 0 ))" != 0 ]; then
            ret_colored_rgb2539_v0="${message_29619}"
            return 0
        fi
        ret_colored_rgb2539_v0="\\x1b[${fallback_29623}m""${message_29619}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__2540_v0() {
    local message_29770="${1}"
    local r_29771="${2}"
    local g_29772="${3}"
    local b_29773="${4}"
    local fallback_29774="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_29775="${fallback_29774}"
    if [ "$(( $(( fallback_29774 >= 30 )) && $(( fallback_29774 <= 37 )) ))" != 0 ]; then
        bg_fallback_29775="$(( fallback_29774 + 10 ))"
    fi
    if [ "$(( $(( fallback_29774 >= 90 )) && $(( fallback_29774 <= 97 )) ))" != 0 ]; then
        bg_fallback_29775="$(( fallback_29774 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_131}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb2540_v0="\\x1b[48;2;${r_29771};${g_29772};${b_29773}m""${message_29770}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_131}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2538_v0 
        local ret_get_supports_truecolor2538_v0__87_17="${ret_get_supports_truecolor2538_v0}"
        if [ "${ret_get_supports_truecolor2538_v0__87_17}" != 0 ]; then
            ret_background_rgb2540_v0="\\x1b[48;2;${r_29771};${g_29772};${b_29773}m""${message_29770}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_29775 == 0 ))" != 0 ]; then
            ret_background_rgb2540_v0="${message_29770}"
            return 0
        else
            ret_background_rgb2540_v0="\\x1b[${bg_fallback_29775}m""${message_29770}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_29775 == 0 ))" != 0 ]; then
            ret_background_rgb2540_v0="${message_29770}"
            return 0
        fi
        ret_background_rgb2540_v0="\\x1b[${bg_fallback_29775}m""${message_29770}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2541_v0() {
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_29613="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_29613}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_29613}" ";"
            local parts_29614=("${ret_split4_v0[@]}")
            local __length_509=("${parts_29614[@]}")
            if [ "$(( ${#__length_509[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29614[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29614[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29614[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29614[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_133=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_29615="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_29615}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_29615}" ";"
            local parts_29616=("${ret_split4_v0[@]}")
            local __length_511=("${parts_29616[@]}")
            if [ "$(( ${#__length_511[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29616[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29616[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29616[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29616[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_134=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_29617="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_29617}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_29617}" ";"
            local parts_29618=("${ret_split4_v0[@]}")
            local __length_513=("${parts_29618[@]}")
            if [ "$(( ${#__length_513[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_29618[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29618[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29618[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_29618[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2541_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_132=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2542_v0() {
    inner_get_xylitol_colors__2541_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_132=1
}

# colored_primary(message: Text)
colored_primary__2543_v0() {
    local message_29612="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2542_v0 
    fi
    colored_rgb__2539_v0 "${message_29612}" "${_primary_color_133[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_133[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_133[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_133[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2543_v0="${ret_colored_rgb2539_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2544_v0() {
    local message_29656="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2542_v0 
    fi
    colored_rgb__2539_v0 "${message_29656}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2544_v0="${ret_colored_rgb2539_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__2547_v0() {
    local message_29769="${1}"
    if [ "$(( ! _got_xylitol_colors_132 ))" != 0 ]; then
        get_xylitol_colors__2542_v0 
    fi
    background_rgb__2540_v0 "${message_29769}" "${_secondary_color_134[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_134[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_134[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_134[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary2547_v0="${ret_background_rgb2540_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_136="None"
# perl_available()
perl_available__2561_v0() {
    if [ "$([ "_${_perl_state_136}" != "_None" ]; echo $?)" != 0 ]; then
        local command_515
        command_515="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_29721
        disabled_29721="$([ "_${command_515}" != "_No" ]; echo $?)"
        local command_516
        command_516="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_29722
        found_29722="$(( $(( ! disabled_29721 )) && $([ "_${command_516}" != "_0" ]; echo $?) ))"
        _perl_state_136="$(if [ "${found_29722}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2561_v0="$([ "_${_perl_state_136}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2562_v0() {
    local text_29720="${1}"
    perl_available__2561_v0 
    local ret_perl_available2561_v0__19_12="${ret_perl_available2561_v0}"
    if [ "$(( ! ret_perl_available2561_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2562_v0=''
        return 1
    fi
    local command_517
    command_517="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_29720}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2562_v0=''
        return "${__status}"
    fi
    local width_str_29723="${command_517}"
    parse_int__13_v0 "${width_str_29723}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2562_v0=''
        return "${__status}"
    fi
    local width_29724="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2562_v0="${width_29724}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2563_v0() {
    local text_29731="${1}"
    local max_width_29732="${2}"
    perl_available__2561_v0 
    local ret_perl_available2561_v0__30_12="${ret_perl_available2561_v0}"
    if [ "$(( ! ret_perl_available2561_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2563_v0=''
        return 1
    fi
    local command_518
    command_518="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_29731}" ${max_width_29732} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2563_v0=''
        return "${__status}"
    fi
    local result_29733="${command_518}"
    ret_perl_truncate_cjk2563_v0="${result_29733}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2567_v0() {
    local text_29697="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_519
    command_519="$([[ "${text_29697}" == *$'\x1b'* || "${text_29697}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_29698="${command_519}"
    ret_has_ansi_escape2567_v0="$([ "_${has_escape_29698}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__2568_v0() {
    local text_29699="${1}"
    local command_520
    command_520="$(printf '%s' "${text_29699}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi2568_v0="${command_520}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2569_v0() {
    local text_29716="${1}"
    local command_521
    command_521="$(printf "%s" "${text_29716}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2569_v0="${command_521}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2570_v0() {
    local text_29718="${1}"
    local command_522
    command_522="$(printf "%s" "${text_29718}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_29719="${command_522}"
    ret_is_all_ascii2570_v0="$([ "_${result_29719}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__2571_v0() {
    local text_29713="${1}"
    local command_523
    command_523="$(LC_ALL=C; __t="${text_29713}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_29714="${command_523}"
    parse_int__13_v0 "${measured_29714}"
    __status=$?
    ret_plain_len2571_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2572_v0() {
    local text_29712="${1}"
    plain_len__2571_v0 "${text_29712}"
    local plain_29715="${ret_plain_len2571_v0}"
    if [ "$(( plain_29715 >= 0 ))" != 0 ]; then
        ret_get_visible_len2572_v0="${plain_29715}"
        return 0
    fi
    strip_ansi__2569_v0 "${text_29712}"
    local stripped_29717="${ret_strip_ansi2569_v0}"
    is_all_ascii__2570_v0 "${stripped_29717}"
    local ret_is_all_ascii2570_v0__46_12="${ret_is_all_ascii2570_v0}"
    if [ "$(( ! ret_is_all_ascii2570_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__2562_v0 "${stripped_29717}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_524="${stripped_29717}"
            ret_get_visible_len2572_v0="${#__length_524}"
            return 0
        fi
        ret_get_visible_len2572_v0="${ret_perl_get_cjk_width2562_v0}"
        return 0
    fi
    local __length_525="${stripped_29717}"
    ret_get_visible_len2572_v0="${#__length_525}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2573_v0() {
    local text_29728="${1}"
    local max_width_29729="${2}"
    get_visible_len__2572_v0 "${text_29728}"
    local visible_len_29730="${ret_get_visible_len2572_v0}"
    if [ "$(( visible_len_29730 <= max_width_29729 ))" != 0 ]; then
        ret_truncate_text2573_v0="${text_29728}"
        return 0
    fi
    is_all_ascii__2570_v0 "${text_29728}"
    local ret_is_all_ascii2570_v0__61_12="${ret_is_all_ascii2570_v0}"
    if [ "$(( ! ret_is_all_ascii2570_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__2563_v0 "${text_29728}" "${max_width_29729}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_29728}" | cut -c1-${max_width_29729}
            __status=$?
        fi
        ret_truncate_text2573_v0="${ret_perl_truncate_cjk2563_v0}"
        return 0
    fi
    local command_526
    command_526="$(printf "%s" "${text_29728}" | cut -c1-${max_width_29729})"
    __status=$?
    ret_truncate_text2573_v0="${command_526}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2574_v0() {
    local text_29726="${1}"
    local max_width_29727="${2}"
    has_ansi_escape__2567_v0 "${text_29726}"
    local ret_has_ansi_escape2567_v0__73_12="${ret_has_ansi_escape2567_v0}"
    if [ "$(( ! ret_has_ansi_escape2567_v0__73_12 ))" != 0 ]; then
        truncate_text__2573_v0 "${text_29726}" "${max_width_29727}"
        ret_truncate_ansi2574_v0="${ret_truncate_text2573_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_527
    command_527="$([[ "${text_29726}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_29734="${command_527}"
    # Replace \x1b[ with newline, then split
    local command_528
    command_528="$(t="${text_29726}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_29735="${command_528}"
    split__4_v0 "${replaced_29735}" "
"
    local parts_29736=("${ret_split4_v0[@]}")
    local result_29737=""
    local remaining_width_29738="${max_width_29727}"
    local __range_start_29739=0
    local __length_529=("${parts_29736[@]}")
    local __range_end_29739="${#__length_529[@]}"
    local __dir_29739=$(( ${__range_start_29739} <= ${__range_end_29739} ? 1 : -1 ))
    for (( idx_29739=${__range_start_29739}; idx_29739 * ${__dir_29739} < ${__range_end_29739} * ${__dir_29739}; idx_29739+=${__dir_29739} )); do
        local part_29740="${parts_29736[${idx_29739}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_29739 == 0 )) && $([ "_${starts_with_ansi_29734}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_29740}" == "_" ]; echo $?) && $(( remaining_width_29738 > 0 )) ))" != 0 ]; then
                truncate_text__2573_v0 "${part_29740}" "${remaining_width_29738}"
                local ret_truncate_text2573_v0__95_35="${ret_truncate_text2573_v0}"
                local truncated_29741="${ret_truncate_text2573_v0__95_35}"
                result_29737+="${truncated_29741}"
                get_visible_len__2572_v0 "${truncated_29741}"
                local ret_get_visible_len2572_v0__97_36="${ret_get_visible_len2572_v0}"
                remaining_width_29738="$(( remaining_width_29738 - ret_get_visible_len2572_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_530
            command_530="$(__p="${part_29740}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_29742="${command_530}"
            if [ "$([ "_${m_idx_29742}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_531
                command_531="$(__p="${part_29740}"; printf "%s" "${__p:0:${m_idx_29742}}")"
                __status=$?
                local ansi_params_29743="${command_531}"
                result_29737+="\\x1b[""${ansi_params_29743}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_29742}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_29744="${ret_parse_int13_v0__108_41}"
                local text_start_29745="$(( m_idx_num_29744 + 1 ))"
                local command_532
                command_532="$(__p="${part_29740}"; printf "%s" "${__p:${text_start_29745}}")"
                __status=$?
                local text_part_29746="${command_532}"
                if [ "$(( $([ "_${text_part_29746}" == "_" ]; echo $?) && $(( remaining_width_29738 > 0 )) ))" != 0 ]; then
                    truncate_text__2573_v0 "${text_part_29746}" "${remaining_width_29738}"
                    local ret_truncate_text2573_v0__112_39="${ret_truncate_text2573_v0}"
                    local truncated_29747="${ret_truncate_text2573_v0__112_39}"
                    result_29737+="${truncated_29747}"
                    get_visible_len__2572_v0 "${truncated_29747}"
                    local ret_get_visible_len2572_v0__114_40="${ret_get_visible_len2572_v0}"
                    remaining_width_29738="$(( remaining_width_29738 - ret_get_visible_len2572_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_29740}" == "_" ]; echo $?) && $(( remaining_width_29738 > 0 )) ))" != 0 ]; then
                    truncate_text__2573_v0 "${part_29740}" "${remaining_width_29738}"
                    local ret_truncate_text2573_v0__119_39="${ret_truncate_text2573_v0}"
                    local truncated_29748="${ret_truncate_text2573_v0__119_39}"
                    result_29737+="${truncated_29748}"
                    get_visible_len__2572_v0 "${truncated_29748}"
                    local ret_get_visible_len2572_v0__121_40="${ret_get_visible_len2572_v0}"
                    remaining_width_29738="$(( remaining_width_29738 - ret_get_visible_len2572_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2574_v0="${result_29737}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2575_v0() {
    local text_29710="${1}"
    local max_width_29711="${2}"
    get_visible_len__2572_v0 "${text_29710}"
    local visible_len_29725="${ret_get_visible_len2572_v0}"
    if [ "$(( visible_len_29725 <= max_width_29711 ))" != 0 ]; then
        ret_cutoff_text2575_v0="${text_29710}"
        return 0
    fi
    truncate_ansi__2574_v0 "${text_29710}" "$(( max_width_29711 - 3 ))"
    local ret_truncate_ansi2574_v0__137_12="${ret_truncate_ansi2574_v0}"
    ret_cutoff_text2575_v0="${ret_truncate_ansi2574_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__2596_v0() {
    local format_29784="${1}"
    local args_29785=("${!2}")
    args_29785=("${format_29784}" "${args_29785[@]}")
    __status=$?
    printf "${args_29785[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2597_v0() {
    local message_29782="${1}"
    local color_29783="${2}"
    # Prints an error message with a specified color.
    local array_533=("${message_29782}")
    eprintf__2596_v0 "\\x1b[${color_29783}m%s\\x1b[0m" array_533[@]
}

# colored(message: Text, color: Int)
colored__2598_v0() {
    local message_29690="${1}"
    local color_29691="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2598_v0="\\x1b[${color_29691}m""${message_29690}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2602_v0() {
    local items_29776=("${!1}")
    local total_len_29777="${2}"
    local term_width_29778="${3}"
    local separator_29779=" • "
    local separator_len_29780=3
    # Fast path: no truncation needed
    if [ "$(( total_len_29777 <= term_width_29778 ))" != 0 ]; then
        local iter_29781=0
        while :
        do
            local __length_534=("${items_29776[@]}")
            if [ "$(( iter_29781 >= ${#__length_534[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_29781 > 0 ))" != 0 ]; then
                eprintf_colored__2597_v0 "${separator_29779}" 90
            fi
            colored__2598_v0 "${items_29776[$(( iter_29781 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2598_v0__23_41="${ret_colored2598_v0}"
            local array_535=("")
            eprintf__2596_v0 "${items_29776[${iter_29781}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2598_v0__23_41}" array_535[@]
            iter_29781="$(( iter_29781 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_29786=0
        local first_29787=1
        local iter_29788=0
        while :
        do
            local __length_536=("${items_29776[@]}")
            if [ "$(( iter_29788 >= ${#__length_536[@]} ))" != 0 ]; then
                break
            fi
            local key_29789="${items_29776[${iter_29788}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_29790="${items_29776[$(( iter_29788 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_537="${key_29789}"
            local __length_538="${action_29790}"
            local part_len_29791="$(( $(( ${#__length_537} + 1 )) + ${#__length_538} ))"
            local needed_29792="${part_len_29791}"
            if [ "$(( ! first_29787 ))" != 0 ]; then
                needed_29792="$(( needed_29792 + separator_len_29780 ))"
            fi
            if [ "$(( $(( current_len_29786 + needed_29792 )) > term_width_29778 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_29787 ))" != 0 ]; then
                eprintf_colored__2597_v0 "${separator_29779}" 90
            fi
            colored__2598_v0 "${action_29790}" 2
            local ret_colored2598_v0__51_33="${ret_colored2598_v0}"
            local array_539=("")
            eprintf__2596_v0 "${key_29789}"" ""${ret_colored2598_v0__51_33}" array_539[@]
            current_len_29786="$(( current_len_29786 + needed_29792 ))"
            first_29787=0
            iter_29788="$(( iter_29788 + 2 ))"
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
store_term_size__2640_v0() {
    local size_29669="${1}"
    if [ "$([ "_${size_29669}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2640_v0=0
        return 0
    fi
    split__4_v0 "${size_29669}" " "
    local parts_29670=("${ret_split4_v0[@]}")
    local __length_541=("${parts_29670[@]}")
    if [ "$(( ${#__length_541[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2640_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_29670[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_29670[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_140=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size2640_v0=1
    return 0
}

# query_term_size()
query_term_size__2641_v0() {
    local command_543
    command_543="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_29672="${command_543}"
    store_term_size__2640_v0 "${size_29672}"
    ret_query_term_size2641_v0="${ret_store_term_size2640_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2642_v0() {
    local command_544
    command_544="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_29668="${command_544}"
    store_term_size__2640_v0 "${size_29668}"
    ret_stty_term_size2642_v0="${ret_store_term_size2640_v0}"
    return 0
}

# get_term_size()
get_term_size__2643_v0() {
    stty_term_size__2642_v0 
    local detected_29671="${ret_stty_term_size2642_v0}"
    if [ "$(( ! detected_29671 ))" != 0 ]; then
        query_term_size__2641_v0 
        detected_29671="${ret_query_term_size2641_v0}"
    fi
    _got_term_size_139=1
}

# term_width()
term_width__2645_v0() {
    if [ "$(( ! _got_term_size_139 ))" != 0 ]; then
        get_term_size__2643_v0 
    fi
    ret_term_width2645_v0="${_term_size_140[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2678_v0() {
    local pending_29687="${1}"
    local line_29688="${2}"
    local note_at_29689="${3}"
    if [ "$(( note_at_29689 < 0 ))" != 0 ]; then
        local array_546=()
        printf__128_v0 "${pending_29687}""${line_29688}""
" array_546[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_29689 == 0 ))" != 0 ]; then
        colored__2598_v0 "${line_29688}" 90
        local ret_colored2598_v0__12_40="${ret_colored2598_v0}"
        local array_547=()
        printf__128_v0 "${pending_29687}""${ret_colored2598_v0__12_40}""
" array_547[@]
    else
        slice__24_v0 "${line_29688}" 0 "${note_at_29689}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_29688}" "${note_at_29689}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2598_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2598_v0__13_58="${ret_colored2598_v0}"
        local array_548=()
        printf__128_v0 "${pending_29687}""${ret_slice24_v0__13_32}""${ret_colored2598_v0__13_58}""
" array_548[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2679_v0() {
    local names_29660=("${!1}")
    local texts_29661=("${!2}")
    local notes_29662=("${!3}")
    local min_name_width_29663="${4}"
    local __length_549=("${names_29660[@]}")
    local count_29664="${#__length_549[@]}"
    local name_width_29665="${min_name_width_29663}"
    local __range_start_29666=0
    local __range_end_29666="${count_29664}"
    local __dir_29666=$(( ${__range_start_29666} <= ${__range_end_29666} ? 1 : -1 ))
    for (( i_29666=${__range_start_29666}; i_29666 * ${__dir_29666} < ${__range_end_29666} * ${__dir_29666}; i_29666+=${__dir_29666} )); do
        local __length_550="${names_29660[${i_29666}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_29667="${#__length_550}"
        if [ "$(( width_29667 > name_width_29665 ))" != 0 ]; then
            name_width_29665="${width_29667}"
        fi
done
    term_width__2645_v0 
    local width_29673="${ret_term_width2645_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_29674="$(( name_width_29665 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_29675="$(( $(( width_29673 - indent_29674 )) < 24 ))"
    if [ "${stacked_29675}" != 0 ]; then
        indent_29674=6
    fi
    local avail_29676="$(( width_29673 - indent_29674 ))"
    rpad__28_v0 "" " " "${indent_29674}"
    local blank_29677="${ret_rpad28_v0}"
    local __range_start_29678=0
    local __range_end_29678="${count_29664}"
    local __dir_29678=$(( ${__range_start_29678} <= ${__range_end_29678} ? 1 : -1 ))
    for (( i_29678=${__range_start_29678}; i_29678 * ${__dir_29678} < ${__range_end_29678} * ${__dir_29678}; i_29678+=${__dir_29678} )); do
        local pending_29679="${blank_29677}"
        if [ "${stacked_29675}" != 0 ]; then
            local array_551=()
            printf__128_v0 "  ""${names_29660[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_551[@]
        else
            rpad__28_v0 "  ""${names_29660[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_29674}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_29679="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_29661[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_29680=("${ret_split4_v0__52_21[@]}")
        local __length_552=("${words_29680[@]}")
        local note_start_29681="${#__length_552[@]}"
        if [ "$([ "_${notes_29662[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_553="${notes_29662[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_553} > avail_29676 ))" != 0 ]; then
                split__4_v0 "${notes_29662[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_29680+=("${ret_split4_v0__58_26[@]}")
            else
                local array_554=("${notes_29662[${i_29678}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_29680+=("${array_554[@]}")
            fi
        fi
        local line_29682=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_29683=-1
        local __range_start_29684=0
        local __length_555=("${words_29680[@]}")
        local __range_end_29684="${#__length_555[@]}"
        local __dir_29684=$(( ${__range_start_29684} <= ${__range_end_29684} ? 1 : -1 ))
        for (( j_29684=${__range_start_29684}; j_29684 * ${__dir_29684} < ${__range_end_29684} * ${__dir_29684}; j_29684+=${__dir_29684} )); do
            local word_29685="${words_29680[${j_29684}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_29686
            candidate_29686="$(if [ "$([ "_${line_29682}" != "_" ]; echo $?)" != 0 ]; then echo "${word_29685}"; else echo "${line_29682}"" ""${word_29685}"; fi)"
            local __length_556="${candidate_29686}"
            if [ "$(( $(( ${#__length_556} > avail_29676 )) && $([ "_${line_29682}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2678_v0 "${pending_29679}" "${line_29682}" "${note_at_29683}"
                pending_29679="${blank_29677}"
                line_29682="${word_29685}"
                note_at_29683="$(if [ "$(( j_29684 >= note_start_29681 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_29684 >= note_start_29681 )) && $(( note_at_29683 < 0 )) ))" != 0 ]; then
                    local __length_557="${candidate_29686}"
                    local __length_558="${word_29685}"
                    note_at_29683="$(( ${#__length_557} - ${#__length_558} ))"
                fi
                line_29682="${candidate_29686}"
            fi
done
        print_help_line__2678_v0 "${pending_29679}" "${line_29682}" "${note_at_29683}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2737_v0() {
    local selected_29750="${1}"
    local term_width_29751="${2}"
    local small_29752="$(( term_width_29751 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_29752}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_29766="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_29752}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_29767="${ret_cpad29_v0}"
    local gap_29768
    gap_29768="$(if [ "${small_29752}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_559=("")
    eprintf__2440_v0 " " array_559[@]
    if [ "${selected_29750}" != 0 ]; then
        # Yes selected
        background_secondary__2547_v0 "${yes_label_29766}"
        local ret_background_secondary2547_v0__16_30="${ret_background_secondary2547_v0}"
        local array_560=("")
        eprintf__2440_v0 "\\x1b[97m""${ret_background_secondary2547_v0__16_30}" array_560[@]
        local array_561=("")
        eprintf__2440_v0 "${gap_29768}" array_561[@]
        # No not selected (dim)
        local array_562=("")
        eprintf__2440_v0 "\\x1b[49;37m""${no_label_29767}""\\x1b[0m" array_562[@]
    else
        # No selected
        local array_563=("")
        eprintf__2440_v0 "\\x1b[49;37m""${yes_label_29766}""\\x1b[0m" array_563[@]
        local array_564=("")
        eprintf__2440_v0 "${gap_29768}" array_564[@]
        background_secondary__2547_v0 "${no_label_29767}"
        local ret_background_secondary2547_v0__24_30="${ret_background_secondary2547_v0}"
        local array_565=("")
        eprintf__2440_v0 "\\x1b[97m""${ret_background_secondary2547_v0__24_30}" array_565[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2738_v0() {
    local header_29701="${1}"
    local default_yes_29702="${2}"
    stty_lock__2482_v0 
    hide_cursor__2499_v0 
    term_width__2489_v0 
    local term_width_29709="${ret_term_width2489_v0}"
    if [ "$([ "_${header_29701}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2575_v0 "${header_29701}" "${term_width_29709}"
        local ret_cutoff_text2575_v0__46_17="${ret_cutoff_text2575_v0}"
        local array_566=("")
        eprintf__2440_v0 "${ret_cutoff_text2575_v0__46_17}""

" array_566[@]
    fi
    local selected_29749="${default_yes_29702}"
    # Render initial options
    render_confirm_options__2737_v0 "${selected_29749}" "${term_width_29709}"
    local array_567=("")
    eprintf__2440_v0 "

" array_567[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_568=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__2602_v0 array_568[@] 40 "${term_width_29709}"
    go_up__2496_v0 2
    while :
    do
        get_key__2438_v0 
        local key_29794="${ret_get_key2438_v0}"
        if [ "$(( $(( $(( $([ "_${key_29794}" != "_LEFT" ]; echo $?) || $([ "_${key_29794}" != "_h" ]; echo $?) )) || $([ "_${key_29794}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_29794}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_29749}" != 0 ]; then
                selected_29749=0
                local array_569=("")
                eprintf__2440_v0 "\\x1b[G\\x1b[K" array_569[@]
                render_confirm_options__2737_v0 "${selected_29749}" "${term_width_29709}"
            elif [ "$(( ! selected_29749 ))" != 0 ]; then
                selected_29749=1
                local array_570=("")
                eprintf__2440_v0 "\\x1b[G\\x1b[K" array_570[@]
                render_confirm_options__2737_v0 "${selected_29749}" "${term_width_29709}"
            fi
        elif [ "$(( $([ "_${key_29794}" != "_y" ]; echo $?) || $([ "_${key_29794}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_29749=1
            break
        elif [ "$(( $([ "_${key_29794}" != "_n" ]; echo $?) || $([ "_${key_29794}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_29749=0
            break
        elif [ "$(( $([ "_${key_29794}" != "_INPUT" ]; echo $?) || $([ "_${key_29794}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_29795=4
    if [ "$([ "_${header_29701}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_29795="$(( total_lines_29795 + 1 ))"
    fi
    go_down__2497_v0 2
    remove_line__2492_v0 "$(( total_lines_29795 - 1 ))"
    remove_current_line__2493_v0 
    stty_unlock__2483_v0 
    show_cursor__2500_v0 
    ret_xyl_confirm2738_v0="${selected_29749}"
    return 0
}

# print_confirm_help()
print_confirm_help__2838_v0() {
    local usage_29628=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__2501_v0 usage_29628[@]
    printf '%s\n' ""
    colored_primary__2543_v0 "confirm"
    local ret_colored_primary2543_v0__8_20="${ret_colored_primary2543_v0}"
    local title_29655=("${ret_colored_primary2543_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__2501_v0 title_29655[@]
    printf '%s\n' ""
    colored_secondary__2544_v0 "Flags:"
    local ret_colored_secondary2544_v0__11_12="${ret_colored_secondary2544_v0}"
    local array_573=()
    printf__128_v0 "${ret_colored_secondary2544_v0__11_12}""
" array_573[@]
    local names_29657=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_29658=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_29659=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2679_v0 names_29657[@] texts_29658[@] notes_29659[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2896_v0() {
    local parameters_29611=("${!1}")
    colored_primary__2543_v0 "Are you sure?"
    local ret_colored_primary2543_v0__9_30="${ret_colored_primary2543_v0}"
    local header_29625="\\x1b[1m""${ret_colored_primary2543_v0__9_30}"
    local default_yes_29626=1
    for param_29627 in "${parameters_29611[@]}"; do
        starts_with__22_v0 "${param_29627}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_29627}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_29627}" != "_-h" ]; echo $?) || $([ "_${param_29627}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2838_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_579="--header="
            slice__24_v0 "${param_29627}" "${#__length_579}" 0
            header_29625="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_580="--default="
            slice__24_v0 "${param_29627}" "${#__length_580}" 0
            local value_29692="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_29692}" != "_yes" ]; echo $?) || $([ "_${value_29692}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_29626=1
            elif [ "$(( $([ "_${value_29692}" != "_no" ]; echo $?) || $([ "_${value_29692}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_29626=0
            else
                eprintf_colored__2441_v0 "ERROR: Invalid default value: ""${value_29692}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__2567_v0 "${header_29625}"
    local ret_has_ansi_escape2567_v0__35_44="${ret_has_ansi_escape2567_v0}"
    escape_ansi__2568_v0 "${header_29625}"
    local ret_escape_ansi2568_v0__35_73="${ret_escape_ansi2568_v0}"
    colored_primary__2543_v0 "${header_29625}"
    local ret_colored_primary2543_v0__35_111="${ret_colored_primary2543_v0}"
    local display_header_29700
    display_header_29700="$(if [ "$(( $([ "_${header_29625}" != "_" ]; echo $?) || ret_has_ansi_escape2567_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi2568_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary2543_v0__35_111}"; fi)"
    xyl_confirm__2738_v0 "${display_header_29700}" "${default_yes_29626}"
    local result_29801="${ret_xyl_confirm2738_v0}"
    ret_execute_confirm2896_v0="$(if [ "${result_29801}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3014_v0() {
    local format_40269="${1}"
    local args_40270=("${!2}")
    args_40270=("${format_40269}" "${args_40270[@]}")
    __status=$?
    printf "${args_40270[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3015_v0() {
    local message_40267="${1}"
    local color_40268="${2}"
    # Prints an error message with a specified color.
    local array_581=("${message_40267}")
    eprintf__3014_v0 "\\x1b[${color_40268}m%s\\x1b[0m" array_581[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3030_v0() {
    local format_40279="${1}"
    local args_40280=("${!2}")
    args_40280=("${format_40279}" "${args_40280[@]}")
    __status=$?
    printf "${args_40280[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3031_v0() {
    local message_40277="${1}"
    local color_40278="${2}"
    # Prints an error message with a specified color.
    local array_582=("${message_40277}")
    eprintf__3030_v0 "\\x1b[${color_40278}m%s\\x1b[0m" array_582[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_148="None"
# perl_available()
perl_available__3038_v0() {
    if [ "$([ "_${_perl_state_148}" != "_None" ]; echo $?)" != 0 ]; then
        local command_583
        command_583="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40209
        disabled_40209="$([ "_${command_583}" != "_No" ]; echo $?)"
        local command_584
        command_584="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40210
        found_40210="$(( $(( ! disabled_40209 )) && $([ "_${command_584}" != "_0" ]; echo $?) ))"
        _perl_state_148="$(if [ "${found_40210}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3038_v0="$([ "_${_perl_state_148}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3039_v0() {
    local text_40208="${1}"
    perl_available__3038_v0 
    local ret_perl_available3038_v0__19_12="${ret_perl_available3038_v0}"
    if [ "$(( ! ret_perl_available3038_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3039_v0=''
        return 1
    fi
    local command_585
    command_585="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40208}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3039_v0=''
        return "${__status}"
    fi
    local width_str_40211="${command_585}"
    parse_int__13_v0 "${width_str_40211}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3039_v0=''
        return "${__status}"
    fi
    local width_40212="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3039_v0="${width_40212}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3044_v0() {
    local text_40198="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_586
    command_586="$([[ "${text_40198}" == *$'\x1b'* || "${text_40198}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40199="${command_586}"
    ret_has_ansi_escape3044_v0="$([ "_${has_escape_40199}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3046_v0() {
    local text_40204="${1}"
    local command_587
    command_587="$(printf "%s" "${text_40204}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3046_v0="${command_587}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3047_v0() {
    local text_40206="${1}"
    local command_588
    command_588="$(printf "%s" "${text_40206}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40207="${command_588}"
    ret_is_all_ascii3047_v0="$([ "_${result_40207}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3048_v0() {
    local text_40201="${1}"
    local command_589
    command_589="$(LC_ALL=C; __t="${text_40201}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40202="${command_589}"
    parse_int__13_v0 "${measured_40202}"
    __status=$?
    ret_plain_len3048_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3049_v0() {
    local text_40200="${1}"
    plain_len__3048_v0 "${text_40200}"
    local plain_40203="${ret_plain_len3048_v0}"
    if [ "$(( plain_40203 >= 0 ))" != 0 ]; then
        ret_get_visible_len3049_v0="${plain_40203}"
        return 0
    fi
    strip_ansi__3046_v0 "${text_40200}"
    local stripped_40205="${ret_strip_ansi3046_v0}"
    is_all_ascii__3047_v0 "${stripped_40205}"
    local ret_is_all_ascii3047_v0__46_12="${ret_is_all_ascii3047_v0}"
    if [ "$(( ! ret_is_all_ascii3047_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3039_v0 "${stripped_40205}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_590="${stripped_40205}"
            ret_get_visible_len3049_v0="${#__length_590}"
            return 0
        fi
        ret_get_visible_len3049_v0="${ret_perl_get_cjk_width3039_v0}"
        return 0
    fi
    local __length_591="${stripped_40205}"
    ret_get_visible_len3049_v0="${#__length_591}"
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
stty_count__3055_v0() {
    local command_593
    command_593="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40275="${command_593}"
    parse_int__13_v0 "${count_40275}"
    __status=$?
    ret_stty_count3055_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3056_v0() {
    stty_count__3055_v0 
    local count_num_40276="${ret_stty_count3055_v0}"
    if [ "$(( count_num_40276 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 2>/dev/null < /dev/tty
        __status=$?
        if [ "${__status}" != 0 ]; then
            eprintf_colored__3031_v0 "Error: " 91
            local array_594=("")
            eprintf__3030_v0 "xylitol needs a terminal, and /dev/tty is not available here.
" array_594[@]
            exit 1
        fi
    fi
    count_num_40276="$(( count_num_40276 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40276}
    __status=$?
}

# stty_unlock()
stty_unlock__3057_v0() {
    stty_count__3055_v0 
    local count_num_40301="${ret_stty_count3055_v0}"
    if [ "$(( count_num_40301 > 0 ))" != 0 ]; then
        count_num_40301="$(( count_num_40301 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40301}
        __status=$?
        if [ "$(( count_num_40301 == 0 ))" != 0 ]; then
            stty echo icanon 2>/dev/null < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3058_v0() {
    local size_40189="${1}"
    if [ "$([ "_${size_40189}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3058_v0=0
        return 0
    fi
    split__4_v0 "${size_40189}" " "
    local parts_40190=("${ret_split4_v0[@]}")
    local __length_595=("${parts_40190[@]}")
    if [ "$(( ${#__length_595[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3058_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40190[1]?"Index out of bounds (at src/./file/../utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40190[0]?"Index out of bounds (at src/./file/../utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_150=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size3058_v0=1
    return 0
}

# query_term_size()
query_term_size__3059_v0() {
    local command_597
    command_597="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40192="${command_597}"
    store_term_size__3058_v0 "${size_40192}"
    ret_query_term_size3059_v0="${ret_store_term_size3058_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3060_v0() {
    local command_598
    command_598="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40188="${command_598}"
    store_term_size__3058_v0 "${size_40188}"
    ret_stty_term_size3060_v0="${ret_store_term_size3058_v0}"
    return 0
}

# get_term_size()
get_term_size__3061_v0() {
    stty_term_size__3060_v0 
    local detected_40191="${ret_stty_term_size3060_v0}"
    if [ "$(( ! detected_40191 ))" != 0 ]; then
        query_term_size__3059_v0 
        detected_40191="${ret_query_term_size3059_v0}"
    fi
    _got_term_size_149=1
}

# term_width()
term_width__3063_v0() {
    if [ "$(( ! _got_term_size_149 ))" != 0 ]; then
        get_term_size__3061_v0 
    fi
    ret_term_width3063_v0="${_term_size_150[0]?"Index out of bounds (at src/./file/../utils/term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__3067_v0() {
    local array_599=("")
    eprintf__3030_v0 "\\x1b[2K\\x1b[G" array_599[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__3075_v0() {
    local pieces_40187=("${!1}")
    term_width__3063_v0 
    local width_40193="${ret_term_width3063_v0}"
    local line_40194=""
    local line_len_40195=0
    for piece_40196 in "${pieces_40187[@]}"; do
        local __length_602="${piece_40196}"
        local piece_len_40197="${#__length_602}"
        has_ansi_escape__3044_v0 "${piece_40196}"
        local ret_has_ansi_escape3044_v0__190_12="${ret_has_ansi_escape3044_v0}"
        if [ "${ret_has_ansi_escape3044_v0__190_12}" != 0 ]; then
            get_visible_len__3049_v0 "${piece_40196}"
            piece_len_40197="${ret_get_visible_len3049_v0}"
        fi
        if [ "$([ "_${line_40194}" != "_" ]; echo $?)" != 0 ]; then
            line_40194="${piece_40196}"
            line_len_40195="${piece_len_40197}"
        elif [ "$(( $(( $(( line_len_40195 + 1 )) + piece_len_40197 )) > width_40193 ))" != 0 ]; then
            local array_603=()
            printf__128_v0 "${line_40194}""
" array_603[@]
            line_40194="${piece_40196}"
            line_len_40195="${piece_len_40197}"
        else
            line_40194+=" ""${piece_40196}"
            line_len_40195="$(( line_len_40195 + $(( 1 + piece_len_40197 )) ))"
        fi
    done
    if [ "$([ "_${line_40194}" == "_" ]; echo $?)" != 0 ]; then
        local array_604=()
        printf__128_v0 "${line_40194}""
" array_604[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_151=3
# get_directory_entries(path: Text)
get_directory_entries__3097_v0() {
    local path_40284="${1}"
    local __ls_path_605="${path_40284}"
    __ls_path_605="${__ls_path_605//\\/\\\\}"
    (( 1 )) && __ls_all_605="-A" || __ls_all_605=""
    (( 0 )) && __ls_rec_605="-R" || __ls_rec_605=""
    local __ls_605=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_605 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_605} ${__ls_rec_605} ${__ls_path_605}
    __status=$?
    );
    local names_40285=("${__ls_605[@]}")
    local command_606
    command_606="$(LC_ALL=C ls -lA "${path_40284}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_40286="${command_606}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_607
    command_607="$(LC_ALL=C ls -lA "${path_40284}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_40287="${command_607}"
    split__4_v0 "${types_output_40286}" "
"
    local types_40288=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_40287}" "
"
    local targets_40289=("${ret_split4_v0[@]}")
    local entries_40290=()
    local __range_start_40291=0
    local __length_609=("${names_40285[@]}")
    local __range_end_40291="${#__length_609[@]}"
    local __dir_40291=$(( ${__range_start_40291} <= ${__range_end_40291} ? 1 : -1 ))
    for (( i_40291=${__range_start_40291}; i_40291 * ${__dir_40291} < ${__range_end_40291} * ${__dir_40291}; i_40291+=${__dir_40291} )); do
        local array_610=("${names_40285[${i_40291}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_40290+=("${array_610[@]}")
        local array_611=("${types_40288[${i_40291}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_40290+=("${array_611[@]}")
        slice__24_v0 "${targets_40289[${i_40291}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_612=("${ret_slice24_v0__31_21}")
        entries_40290+=("${array_612[@]}")
done
    ret_get_directory_entries3097_v0=("${entries_40290[@]}")
    return 0
}

# get_cwd()
get_cwd__3098_v0() {
    local command_613
    command_613="$(pwd)"
    __status=$?
    ret_get_cwd3098_v0="${command_613}"
    return 0
}

# normalize_path(path: Text)
normalize_path__3099_v0() {
    local path_40282="${1}"
    local command_614
    command_614="$(cd "${path_40282}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_40283="${command_614}"
    if [ "$([ "_${normalized_40283}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path3099_v0="${path_40282}"
        return 0
    fi
    ret_normalize_path3099_v0="${normalized_40283}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__3100_v0() {
    local base_40468="${1}"
    local child_40469="${2}"
    if [ "$([ "_${base_40468}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join3100_v0="/""${child_40469}"
        return 0
    fi
    ret_path_join3100_v0="${base_40468}""/""${child_40469}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__3101_v0() {
    local path_40466="${1}"
    local command_615
    command_615="$(dirname "${path_40466}")"
    __status=$?
    local parent_40467="${command_615}"
    ret_get_parent_dir3101_v0="${parent_40467}"
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
get_supports_truecolor__3112_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40225="${ret_env_var_get120_v0}"
    _supports_truecolor_153="$(if [ "$([ "_${config_40225}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3112_v0="$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3113_v0() {
    local message_40220="${1}"
    local r_40221="${2}"
    local g_40222="${3}"
    local b_40223="${4}"
    local fallback_40224="${5}"
    if [ "$([ "_${_supports_truecolor_153}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3113_v0="\\x1b[38;2;${r_40221};${g_40222};${b_40223}m""${message_40220}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_153}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3112_v0 
        local ret_get_supports_truecolor3112_v0__45_17="${ret_get_supports_truecolor3112_v0}"
        if [ "${ret_get_supports_truecolor3112_v0__45_17}" != 0 ]; then
            ret_colored_rgb3113_v0="\\x1b[38;2;${r_40221};${g_40222};${b_40223}m""${message_40220}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40224 == 0 ))" != 0 ]; then
            ret_colored_rgb3113_v0="${message_40220}"
            return 0
        else
            ret_colored_rgb3113_v0="\\x1b[${fallback_40224}m""${message_40220}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40224 == 0 ))" != 0 ]; then
            ret_colored_rgb3113_v0="${message_40220}"
            return 0
        fi
        ret_colored_rgb3113_v0="\\x1b[${fallback_40224}m""${message_40220}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3115_v0() {
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40214="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40214}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40214}" ";"
            local parts_40215=("${ret_split4_v0[@]}")
            local __length_619=("${parts_40215[@]}")
            if [ "$(( ${#__length_619[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40215[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40215[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40215[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40215[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_155=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40216="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40216}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40216}" ";"
            local parts_40217=("${ret_split4_v0[@]}")
            local __length_621=("${parts_40217[@]}")
            if [ "$(( ${#__length_621[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40217[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40217[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40217[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40217[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_156=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40218="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40218}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40218}" ";"
            local parts_40219=("${ret_split4_v0[@]}")
            local __length_623=("${parts_40219[@]}")
            if [ "$(( ${#__length_623[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40219[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40219[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40219[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40219[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3115_v0=''
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
get_xylitol_colors__3116_v0() {
    inner_get_xylitol_colors__3115_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_154=1
}

# colored_primary(message: Text)
colored_primary__3117_v0() {
    local message_40213="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3116_v0 
    fi
    colored_rgb__3113_v0 "${message_40213}" "${_primary_color_155[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_155[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_155[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_155[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary3117_v0="${ret_colored_rgb3113_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__3118_v0() {
    local message_40227="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3116_v0 
    fi
    colored_rgb__3113_v0 "${message_40227}" "${_secondary_color_156[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_156[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_156[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_156[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3118_v0="${ret_colored_rgb3113_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__3119_v0() {
    local message_40402="${1}"
    if [ "$(( ! _got_xylitol_colors_154 ))" != 0 ]; then
        get_xylitol_colors__3116_v0 
    fi
    colored_rgb__3113_v0 "${message_40402}" "${_accent_color_157[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_157[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_157[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_157[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent3119_v0="${ret_colored_rgb3113_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# colored(message: Text, color: Int)
colored__3172_v0() {
    local message_40261="${1}"
    local color_40262="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3172_v0="\\x1b[${color_40262}m""${message_40261}""\\x1b[0m"
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
store_term_size__3214_v0() {
    local size_40240="${1}"
    if [ "$([ "_${size_40240}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3214_v0=0
        return 0
    fi
    split__4_v0 "${size_40240}" " "
    local parts_40241=("${ret_split4_v0[@]}")
    local __length_626=("${parts_40241[@]}")
    if [ "$(( ${#__length_626[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3214_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40241[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40241[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_162=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size3214_v0=1
    return 0
}

# query_term_size()
query_term_size__3215_v0() {
    local command_628
    command_628="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40243="${command_628}"
    store_term_size__3214_v0 "${size_40243}"
    ret_query_term_size3215_v0="${ret_store_term_size3214_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3216_v0() {
    local command_629
    command_629="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40239="${command_629}"
    store_term_size__3214_v0 "${size_40239}"
    ret_stty_term_size3216_v0="${ret_store_term_size3214_v0}"
    return 0
}

# get_term_size()
get_term_size__3217_v0() {
    stty_term_size__3216_v0 
    local detected_40242="${ret_stty_term_size3216_v0}"
    if [ "$(( ! detected_40242 ))" != 0 ]; then
        query_term_size__3215_v0 
        detected_40242="${ret_query_term_size3215_v0}"
    fi
    _got_term_size_161=1
}

# term_width()
term_width__3219_v0() {
    if [ "$(( ! _got_term_size_161 ))" != 0 ]; then
        get_term_size__3217_v0 
    fi
    ret_term_width3219_v0="${_term_size_162[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:100:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# Which items of a multi-select widget are ticked.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__3252_v0() {
    local pending_40258="${1}"
    local line_40259="${2}"
    local note_at_40260="${3}"
    if [ "$(( note_at_40260 < 0 ))" != 0 ]; then
        local array_631=()
        printf__128_v0 "${pending_40258}""${line_40259}""
" array_631[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_40260 == 0 ))" != 0 ]; then
        colored__3172_v0 "${line_40259}" 90
        local ret_colored3172_v0__12_40="${ret_colored3172_v0}"
        local array_632=()
        printf__128_v0 "${pending_40258}""${ret_colored3172_v0__12_40}""
" array_632[@]
    else
        slice__24_v0 "${line_40259}" 0 "${note_at_40260}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_40259}" "${note_at_40260}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__3172_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored3172_v0__13_58="${ret_colored3172_v0}"
        local array_633=()
        printf__128_v0 "${pending_40258}""${ret_slice24_v0__13_32}""${ret_colored3172_v0__13_58}""
" array_633[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__3253_v0() {
    local names_40231=("${!1}")
    local texts_40232=("${!2}")
    local notes_40233=("${!3}")
    local min_name_width_40234="${4}"
    local __length_634=("${names_40231[@]}")
    local count_40235="${#__length_634[@]}"
    local name_width_40236="${min_name_width_40234}"
    local __range_start_40237=0
    local __range_end_40237="${count_40235}"
    local __dir_40237=$(( ${__range_start_40237} <= ${__range_end_40237} ? 1 : -1 ))
    for (( i_40237=${__range_start_40237}; i_40237 * ${__dir_40237} < ${__range_end_40237} * ${__dir_40237}; i_40237+=${__dir_40237} )); do
        local __length_635="${names_40231[${i_40237}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_40238="${#__length_635}"
        if [ "$(( width_40238 > name_width_40236 ))" != 0 ]; then
            name_width_40236="${width_40238}"
        fi
done
    term_width__3219_v0 
    local width_40244="${ret_term_width3219_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_40245="$(( name_width_40236 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_40246="$(( $(( width_40244 - indent_40245 )) < 24 ))"
    if [ "${stacked_40246}" != 0 ]; then
        indent_40245=6
    fi
    local avail_40247="$(( width_40244 - indent_40245 ))"
    rpad__28_v0 "" " " "${indent_40245}"
    local blank_40248="${ret_rpad28_v0}"
    local __range_start_40249=0
    local __range_end_40249="${count_40235}"
    local __dir_40249=$(( ${__range_start_40249} <= ${__range_end_40249} ? 1 : -1 ))
    for (( i_40249=${__range_start_40249}; i_40249 * ${__dir_40249} < ${__range_end_40249} * ${__dir_40249}; i_40249+=${__dir_40249} )); do
        local pending_40250="${blank_40248}"
        if [ "${stacked_40246}" != 0 ]; then
            local array_636=()
            printf__128_v0 "  ""${names_40231[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_636[@]
        else
            rpad__28_v0 "  ""${names_40231[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_40245}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_40250="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_40232[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_40251=("${ret_split4_v0__52_21[@]}")
        local __length_637=("${words_40251[@]}")
        local note_start_40252="${#__length_637[@]}"
        if [ "$([ "_${notes_40233[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_638="${notes_40233[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_638} > avail_40247 ))" != 0 ]; then
                split__4_v0 "${notes_40233[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_40251+=("${ret_split4_v0__58_26[@]}")
            else
                local array_639=("${notes_40233[${i_40249}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_40251+=("${array_639[@]}")
            fi
        fi
        local line_40253=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_40254=-1
        local __range_start_40255=0
        local __length_640=("${words_40251[@]}")
        local __range_end_40255="${#__length_640[@]}"
        local __dir_40255=$(( ${__range_start_40255} <= ${__range_end_40255} ? 1 : -1 ))
        for (( j_40255=${__range_start_40255}; j_40255 * ${__dir_40255} < ${__range_end_40255} * ${__dir_40255}; j_40255+=${__dir_40255} )); do
            local word_40256="${words_40251[${j_40255}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_40257
            candidate_40257="$(if [ "$([ "_${line_40253}" != "_" ]; echo $?)" != 0 ]; then echo "${word_40256}"; else echo "${line_40253}"" ""${word_40256}"; fi)"
            local __length_641="${candidate_40257}"
            if [ "$(( $(( ${#__length_641} > avail_40247 )) && $([ "_${line_40253}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__3252_v0 "${pending_40250}" "${line_40253}" "${note_at_40254}"
                pending_40250="${blank_40248}"
                line_40253="${word_40256}"
                note_at_40254="$(if [ "$(( j_40255 >= note_start_40252 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_40255 >= note_start_40252 )) && $(( note_at_40254 < 0 )) ))" != 0 ]; then
                    local __length_642="${candidate_40257}"
                    local __length_643="${word_40256}"
                    note_at_40254="$(( ${#__length_642} - ${#__length_643} ))"
                fi
                line_40253="${candidate_40257}"
            fi
done
        print_help_line__3252_v0 "${pending_40250}" "${line_40253}" "${note_at_40254}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__3356_v0() {
    local command_644
    command_644="$(IFS= read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then IFS= read -rsn2 r < /dev/tty; k+=$r; fi; case "$k" in ($'\e[A') printf UP;; ($'\e[B') printf DOWN;; ($'\e[C') printf RIGHT;; ($'\e[D') printf LEFT;; ($'\177') printf BACKSPACE;; ($'	') printf TAB;; ($'\001') printf CTRL_A;; (' ') printf SPACE;; ('') printf INPUT;; (*) printf '%s' "$k";; esac)"
    __status=$?
    ret_get_key3356_v0="${command_644}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__3358_v0() {
    local format_40363="${1}"
    local args_40364=("${!2}")
    args_40364=("${format_40363}" "${args_40364[@]}")
    __status=$?
    printf "${args_40364[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3359_v0() {
    local message_40370="${1}"
    local color_40371="${2}"
    # Prints an error message with a specified color.
    local array_645=("${message_40370}")
    eprintf__3358_v0 "\\x1b[${color_40371}m%s\\x1b[0m" array_645[@]
}

# eprintf(format: Text, args: [Text])
eprintf__3374_v0() {
    local format_40313="${1}"
    local args_40314=("${!2}")
    args_40314=("${format_40313}" "${args_40314[@]}")
    __status=$?
    printf "${args_40314[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3375_v0() {
    local message_40311="${1}"
    local color_40312="${2}"
    # Prints an error message with a specified color.
    local array_646=("${message_40311}")
    eprintf__3374_v0 "\\x1b[${color_40312}m%s\\x1b[0m" array_646[@]
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
stty_count__3399_v0() {
    local command_648
    command_648="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_40309="${command_648}"
    parse_int__13_v0 "${count_40309}"
    __status=$?
    ret_stty_count3399_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__3400_v0() {
    stty_count__3399_v0 
    local count_num_40310="${ret_stty_count3399_v0}"
    if [ "$(( count_num_40310 == 0 ))" != 0 ]; then
        stty -echo -icanon min 1 time 0 2>/dev/null < /dev/tty
        __status=$?
        if [ "${__status}" != 0 ]; then
            eprintf_colored__3375_v0 "Error: " 91
            local array_649=("")
            eprintf__3374_v0 "xylitol needs a terminal, and /dev/tty is not available here.
" array_649[@]
            exit 1
        fi
    fi
    count_num_40310="$(( count_num_40310 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40310}
    __status=$?
}

# stty_unlock()
stty_unlock__3401_v0() {
    stty_count__3399_v0 
    local count_num_40463="${ret_stty_count3399_v0}"
    if [ "$(( count_num_40463 > 0 ))" != 0 ]; then
        count_num_40463="$(( count_num_40463 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_40463}
        __status=$?
        if [ "$(( count_num_40463 == 0 ))" != 0 ]; then
            stty echo icanon 2>/dev/null < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__3402_v0() {
    local size_40316="${1}"
    if [ "$([ "_${size_40316}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size3402_v0=0
        return 0
    fi
    split__4_v0 "${size_40316}" " "
    local parts_40317=("${ret_split4_v0[@]}")
    local __length_650=("${parts_40317[@]}")
    if [ "$(( ${#__length_650[@]} != 2 ))" != 0 ]; then
        ret_store_term_size3402_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_40317[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:57:41)"}"
    __status=$?
    local ret_parse_int13_v0__57_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_40317[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:57:68)"}"
    __status=$?
    local ret_parse_int13_v0__57_52="${ret_parse_int13_v0}"
    _term_size_170=("${ret_parse_int13_v0__57_25}" "${ret_parse_int13_v0__57_52}")
    ret_store_term_size3402_v0=1
    return 0
}

# query_term_size()
query_term_size__3403_v0() {
    local command_652
    command_652="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_40319="${command_652}"
    store_term_size__3402_v0 "${size_40319}"
    ret_query_term_size3403_v0="${ret_store_term_size3402_v0}"
    return 0
}

# stty_term_size()
stty_term_size__3404_v0() {
    local command_653
    command_653="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_40315="${command_653}"
    store_term_size__3402_v0 "${size_40315}"
    ret_stty_term_size3404_v0="${ret_store_term_size3402_v0}"
    return 0
}

# get_term_size()
get_term_size__3405_v0() {
    stty_term_size__3404_v0 
    local detected_40318="${ret_stty_term_size3404_v0}"
    if [ "$(( ! detected_40318 ))" != 0 ]; then
        query_term_size__3403_v0 
        detected_40318="${ret_query_term_size3403_v0}"
    fi
    _got_term_size_169=1
}

# term_width()
term_width__3407_v0() {
    if [ "$(( ! _got_term_size_169 ))" != 0 ]; then
        get_term_size__3405_v0 
    fi
    ret_term_width3407_v0="${_term_size_170[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:100:23)"}"
    return 0
}

# term_height()
term_height__3408_v0() {
    if [ "$(( ! _got_term_size_169 ))" != 0 ]; then
        get_term_size__3405_v0 
    fi
    ret_term_height3408_v0="${_term_size_170[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:108:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__3410_v0() {
    local cnt_40434="${1}"
    if [ "$(( cnt_40434 > 0 ))" != 0 ]; then
        local sequence_40435=""
        local __range_start_40436=0
        local __range_end_40436="${cnt_40434}"
        local __dir_40436=$(( ${__range_start_40436} <= ${__range_end_40436} ? 1 : -1 ))
        for (( ____40436=${__range_start_40436}; ____40436 * ${__dir_40436} < ${__range_end_40436} * ${__dir_40436}; ____40436+=${__dir_40436} )); do
            sequence_40435+="\\x1b[2K\\x1b[1A"
done
        local array_654=("")
        eprintf__3374_v0 "${sequence_40435}" array_654[@]
    fi
    local array_655=("")
    eprintf__3374_v0 "\\x1b[G" array_655[@]
}

# remove_current_line()
remove_current_line__3411_v0() {
    local array_656=("")
    eprintf__3374_v0 "\\x1b[2K\\x1b[G" array_656[@]
}

# print_blank(cnt: Int)
print_blank__3412_v0() {
    local cnt_40425="${1}"
    printf '%*s' "${cnt_40425}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__3413_v0() {
    local cnt_40368="${1}"
    local __range_start_40369=0
    local __range_end_40369="${cnt_40368}"
    local __dir_40369=$(( ${__range_start_40369} <= ${__range_end_40369} ? 1 : -1 ))
    for (( ____40369=${__range_start_40369}; ____40369 * ${__dir_40369} < ${__range_end_40369} * ${__dir_40369}; ____40369+=${__dir_40369} )); do
        local array_657=("")
        eprintf__3374_v0 "
" array_657[@]
done
}

# go_up(cnt: Int)
go_up__3414_v0() {
    local cnt_40391="${1}"
    local array_658=("")
    eprintf__3374_v0 "\\x1b[${cnt_40391}A" array_658[@]
}

# go_down(cnt: Int)
go_down__3415_v0() {
    local cnt_40462="${1}"
    local array_659=("")
    eprintf__3374_v0 "\\x1b[${cnt_40462}B" array_659[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__3417_v0() {
    local array_660=("")
    eprintf__3374_v0 "\\x1b[?25l" array_660[@]
}

# show_cursor()
show_cursor__3418_v0() {
    local array_661=("")
    eprintf__3374_v0 "\\x1b[?25h" array_661[@]
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
get_supports_truecolor__3456_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_40424="${ret_env_var_get120_v0}"
    _supports_truecolor_173="$(if [ "$([ "_${config_40424}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor3456_v0="$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__3457_v0() {
    local message_40419="${1}"
    local r_40420="${2}"
    local g_40421="${3}"
    local b_40422="${4}"
    local fallback_40423="${5}"
    if [ "$([ "_${_supports_truecolor_173}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb3457_v0="\\x1b[38;2;${r_40420};${g_40421};${b_40422}m""${message_40419}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_173}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__3456_v0 
        local ret_get_supports_truecolor3456_v0__45_17="${ret_get_supports_truecolor3456_v0}"
        if [ "${ret_get_supports_truecolor3456_v0__45_17}" != 0 ]; then
            ret_colored_rgb3457_v0="\\x1b[38;2;${r_40420};${g_40421};${b_40422}m""${message_40419}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_40423 == 0 ))" != 0 ]; then
            ret_colored_rgb3457_v0="${message_40419}"
            return 0
        else
            ret_colored_rgb3457_v0="\\x1b[${fallback_40423}m""${message_40419}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_40423 == 0 ))" != 0 ]; then
            ret_colored_rgb3457_v0="${message_40419}"
            return 0
        fi
        ret_colored_rgb3457_v0="\\x1b[${fallback_40423}m""${message_40419}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__3459_v0() {
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_40413="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_40413}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_40413}" ";"
            local parts_40414=("${ret_split4_v0[@]}")
            local __length_665=("${parts_40414[@]}")
            if [ "$(( ${#__length_665[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40414[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40414[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40414[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40414[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_40415="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_40415}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_40415}" ";"
            local parts_40416=("${ret_split4_v0[@]}")
            local __length_667=("${parts_40416[@]}")
            if [ "$(( ${#__length_667[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40416[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40416[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40416[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40416[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_176=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_40417="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_40417}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_40417}" ";"
            local parts_40418=("${ret_split4_v0[@]}")
            local __length_669=("${parts_40418[@]}")
            if [ "$(( ${#__length_669[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_40418[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40418[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40418[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_40418[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors3459_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_174=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__3460_v0() {
    inner_get_xylitol_colors__3459_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_174=1
}

# colored_secondary(message: Text)
colored_secondary__3462_v0() {
    local message_40412="${1}"
    if [ "$(( ! _got_xylitol_colors_174 ))" != 0 ]; then
        get_xylitol_colors__3460_v0 
    fi
    colored_rgb__3457_v0 "${message_40412}" "${_secondary_color_176[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_176[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_176[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_176[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary3462_v0="${ret_colored_rgb3457_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
_perl_state_178="None"
# perl_available()
perl_available__3479_v0() {
    if [ "$([ "_${_perl_state_178}" != "_None" ]; echo $?)" != 0 ]; then
        local command_671
        command_671="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_40333
        disabled_40333="$([ "_${command_671}" != "_No" ]; echo $?)"
        local command_672
        command_672="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_40334
        found_40334="$(( $(( ! disabled_40333 )) && $([ "_${command_672}" != "_0" ]; echo $?) ))"
        _perl_state_178="$(if [ "${found_40334}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available3479_v0="$([ "_${_perl_state_178}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__3480_v0() {
    local text_40332="${1}"
    perl_available__3479_v0 
    local ret_perl_available3479_v0__19_12="${ret_perl_available3479_v0}"
    if [ "$(( ! ret_perl_available3479_v0__19_12 ))" != 0 ]; then
        ret_perl_get_cjk_width3480_v0=''
        return 1
    fi
    local command_673
    command_673="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_40332}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3480_v0=''
        return "${__status}"
    fi
    local width_str_40335="${command_673}"
    parse_int__13_v0 "${width_str_40335}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width3480_v0=''
        return "${__status}"
    fi
    local width_40336="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width3480_v0="${width_40336}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__3481_v0() {
    local text_40345="${1}"
    local max_width_40346="${2}"
    perl_available__3479_v0 
    local ret_perl_available3479_v0__30_12="${ret_perl_available3479_v0}"
    if [ "$(( ! ret_perl_available3479_v0__30_12 ))" != 0 ]; then
        ret_perl_truncate_cjk3481_v0=''
        return 1
    fi
    local command_674
    command_674="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_40345}" ${max_width_40346} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk3481_v0=''
        return "${__status}"
    fi
    local result_40347="${command_674}"
    ret_perl_truncate_cjk3481_v0="${result_40347}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__3485_v0() {
    local text_40340="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_675
    command_675="$([[ "${text_40340}" == *$'\x1b'* || "${text_40340}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_40341="${command_675}"
    ret_has_ansi_escape3485_v0="$([ "_${has_escape_40341}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__3487_v0() {
    local text_40328="${1}"
    local command_676
    command_676="$(printf "%s" "${text_40328}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi3487_v0="${command_676}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__3488_v0() {
    local text_40330="${1}"
    local command_677
    command_677="$(printf "%s" "${text_40330}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_40331="${command_677}"
    ret_is_all_ascii3488_v0="$([ "_${result_40331}" != "_0" ]; echo $?)"
    return 0
}

# plain_len(text: Text)
plain_len__3489_v0() {
    local text_40325="${1}"
    local command_678
    command_678="$(LC_ALL=C; __t="${text_40325}"; case "$__t" in (*[!\ -~]*) echo -1;; (*'\x1b['*) echo -1;; (*) echo "${#__t}";; esac)"
    __status=$?
    local measured_40326="${command_678}"
    parse_int__13_v0 "${measured_40326}"
    __status=$?
    ret_plain_len3489_v0="${ret_parse_int13_v0}"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__3490_v0() {
    local text_40324="${1}"
    plain_len__3489_v0 "${text_40324}"
    local plain_40327="${ret_plain_len3489_v0}"
    if [ "$(( plain_40327 >= 0 ))" != 0 ]; then
        ret_get_visible_len3490_v0="${plain_40327}"
        return 0
    fi
    strip_ansi__3487_v0 "${text_40324}"
    local stripped_40329="${ret_strip_ansi3487_v0}"
    is_all_ascii__3488_v0 "${stripped_40329}"
    local ret_is_all_ascii3488_v0__46_12="${ret_is_all_ascii3488_v0}"
    if [ "$(( ! ret_is_all_ascii3488_v0__46_12 ))" != 0 ]; then
        perl_get_cjk_width__3480_v0 "${stripped_40329}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_679="${stripped_40329}"
            ret_get_visible_len3490_v0="${#__length_679}"
            return 0
        fi
        ret_get_visible_len3490_v0="${ret_perl_get_cjk_width3480_v0}"
        return 0
    fi
    local __length_680="${stripped_40329}"
    ret_get_visible_len3490_v0="${#__length_680}"
    return 0
}

# truncate_text(text: Text, max_width: Int)
truncate_text__3491_v0() {
    local text_40342="${1}"
    local max_width_40343="${2}"
    get_visible_len__3490_v0 "${text_40342}"
    local visible_len_40344="${ret_get_visible_len3490_v0}"
    if [ "$(( visible_len_40344 <= max_width_40343 ))" != 0 ]; then
        ret_truncate_text3491_v0="${text_40342}"
        return 0
    fi
    is_all_ascii__3488_v0 "${text_40342}"
    local ret_is_all_ascii3488_v0__61_12="${ret_is_all_ascii3488_v0}"
    if [ "$(( ! ret_is_all_ascii3488_v0__61_12 ))" != 0 ]; then
        perl_truncate_cjk__3481_v0 "${text_40342}" "${max_width_40343}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_40342}" | cut -c1-${max_width_40343}
            __status=$?
        fi
        ret_truncate_text3491_v0="${ret_perl_truncate_cjk3481_v0}"
        return 0
    fi
    local command_681
    command_681="$(printf "%s" "${text_40342}" | cut -c1-${max_width_40343})"
    __status=$?
    ret_truncate_text3491_v0="${command_681}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__3492_v0() {
    local text_40338="${1}"
    local max_width_40339="${2}"
    has_ansi_escape__3485_v0 "${text_40338}"
    local ret_has_ansi_escape3485_v0__73_12="${ret_has_ansi_escape3485_v0}"
    if [ "$(( ! ret_has_ansi_escape3485_v0__73_12 ))" != 0 ]; then
        truncate_text__3491_v0 "${text_40338}" "${max_width_40339}"
        ret_truncate_ansi3492_v0="${ret_truncate_text3491_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_682
    command_682="$([[ "${text_40338}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_40348="${command_682}"
    # Replace \x1b[ with newline, then split
    local command_683
    command_683="$(t="${text_40338}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_40349="${command_683}"
    split__4_v0 "${replaced_40349}" "
"
    local parts_40350=("${ret_split4_v0[@]}")
    local result_40351=""
    local remaining_width_40352="${max_width_40339}"
    local __range_start_40353=0
    local __length_684=("${parts_40350[@]}")
    local __range_end_40353="${#__length_684[@]}"
    local __dir_40353=$(( ${__range_start_40353} <= ${__range_end_40353} ? 1 : -1 ))
    for (( idx_40353=${__range_start_40353}; idx_40353 * ${__dir_40353} < ${__range_end_40353} * ${__dir_40353}; idx_40353+=${__dir_40353} )); do
        local part_40354="${parts_40350[${idx_40353}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:88:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_40353 == 0 )) && $([ "_${starts_with_ansi_40348}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_40354}" == "_" ]; echo $?) && $(( remaining_width_40352 > 0 )) ))" != 0 ]; then
                truncate_text__3491_v0 "${part_40354}" "${remaining_width_40352}"
                local ret_truncate_text3491_v0__95_35="${ret_truncate_text3491_v0}"
                local truncated_40355="${ret_truncate_text3491_v0__95_35}"
                result_40351+="${truncated_40355}"
                get_visible_len__3490_v0 "${truncated_40355}"
                local ret_get_visible_len3490_v0__97_36="${ret_get_visible_len3490_v0}"
                remaining_width_40352="$(( remaining_width_40352 - ret_get_visible_len3490_v0__97_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_685
            command_685="$(__p="${part_40354}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_40356="${command_685}"
            if [ "$([ "_${m_idx_40356}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_686
                command_686="$(__p="${part_40354}"; printf "%s" "${__p:0:${m_idx_40356}}")"
                __status=$?
                local ansi_params_40357="${command_686}"
                result_40351+="\\x1b[""${ansi_params_40357}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_40356}"
                __status=$?
                local ret_parse_int13_v0__108_41="${ret_parse_int13_v0}"
                local m_idx_num_40358="${ret_parse_int13_v0__108_41}"
                local text_start_40359="$(( m_idx_num_40358 + 1 ))"
                local command_687
                command_687="$(__p="${part_40354}"; printf "%s" "${__p:${text_start_40359}}")"
                __status=$?
                local text_part_40360="${command_687}"
                if [ "$(( $([ "_${text_part_40360}" == "_" ]; echo $?) && $(( remaining_width_40352 > 0 )) ))" != 0 ]; then
                    truncate_text__3491_v0 "${text_part_40360}" "${remaining_width_40352}"
                    local ret_truncate_text3491_v0__112_39="${ret_truncate_text3491_v0}"
                    local truncated_40361="${ret_truncate_text3491_v0__112_39}"
                    result_40351+="${truncated_40361}"
                    get_visible_len__3490_v0 "${truncated_40361}"
                    local ret_get_visible_len3490_v0__114_40="${ret_get_visible_len3490_v0}"
                    remaining_width_40352="$(( remaining_width_40352 - ret_get_visible_len3490_v0__114_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_40354}" == "_" ]; echo $?) && $(( remaining_width_40352 > 0 )) ))" != 0 ]; then
                    truncate_text__3491_v0 "${part_40354}" "${remaining_width_40352}"
                    local ret_truncate_text3491_v0__119_39="${ret_truncate_text3491_v0}"
                    local truncated_40362="${ret_truncate_text3491_v0__119_39}"
                    result_40351+="${truncated_40362}"
                    get_visible_len__3490_v0 "${truncated_40362}"
                    local ret_get_visible_len3490_v0__121_40="${ret_get_visible_len3490_v0}"
                    remaining_width_40352="$(( remaining_width_40352 - ret_get_visible_len3490_v0__121_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi3492_v0="${result_40351}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__3493_v0() {
    local text_40322="${1}"
    local max_width_40323="${2}"
    get_visible_len__3490_v0 "${text_40322}"
    local visible_len_40337="${ret_get_visible_len3490_v0}"
    if [ "$(( visible_len_40337 <= max_width_40323 ))" != 0 ]; then
        ret_cutoff_text3493_v0="${text_40322}"
        return 0
    fi
    truncate_ansi__3492_v0 "${text_40322}" "$(( max_width_40323 - 3 ))"
    local ret_truncate_ansi3492_v0__137_12="${ret_truncate_ansi3492_v0}"
    ret_cutoff_text3493_v0="${ret_truncate_ansi3492_v0__137_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# eprintf(format: Text, args: [Text])
eprintf__3514_v0() {
    local format_40380="${1}"
    local args_40381=("${!2}")
    args_40381=("${format_40380}" "${args_40381[@]}")
    __status=$?
    printf "${args_40381[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__3515_v0() {
    local message_40378="${1}"
    local color_40379="${2}"
    # Prints an error message with a specified color.
    local array_688=("${message_40378}")
    eprintf__3514_v0 "\\x1b[${color_40379}m%s\\x1b[0m" array_688[@]
}

# colored(message: Text, color: Int)
colored__3516_v0() {
    local message_40382="${1}"
    local color_40383="${2}"
    # Returns a text wrapped in color codes.
    ret_colored3516_v0="\\x1b[${color_40383}m""${message_40382}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__3520_v0() {
    local items_40372=("${!1}")
    local total_len_40373="${2}"
    local term_width_40374="${3}"
    local separator_40375=" • "
    local separator_len_40376=3
    # Fast path: no truncation needed
    if [ "$(( total_len_40373 <= term_width_40374 ))" != 0 ]; then
        local iter_40377=0
        while :
        do
            local __length_689=("${items_40372[@]}")
            if [ "$(( iter_40377 >= ${#__length_689[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_40377 > 0 ))" != 0 ]; then
                eprintf_colored__3515_v0 "${separator_40375}" 90
            fi
            colored__3516_v0 "${items_40372[$(( iter_40377 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored3516_v0__23_41="${ret_colored3516_v0}"
            local array_690=("")
            eprintf__3514_v0 "${items_40372[${iter_40377}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored3516_v0__23_41}" array_690[@]
            iter_40377="$(( iter_40377 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_40384=0
        local first_40385=1
        local iter_40386=0
        while :
        do
            local __length_691=("${items_40372[@]}")
            if [ "$(( iter_40386 >= ${#__length_691[@]} ))" != 0 ]; then
                break
            fi
            local key_40387="${items_40372[${iter_40386}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_40388="${items_40372[$(( iter_40386 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_692="${key_40387}"
            local __length_693="${action_40388}"
            local part_len_40389="$(( $(( ${#__length_692} + 1 )) + ${#__length_693} ))"
            local needed_40390="${part_len_40389}"
            if [ "$(( ! first_40385 ))" != 0 ]; then
                needed_40390="$(( needed_40390 + separator_len_40376 ))"
            fi
            if [ "$(( $(( current_len_40384 + needed_40390 )) > term_width_40374 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_40385 ))" != 0 ]; then
                eprintf_colored__3515_v0 "${separator_40375}" 90
            fi
            colored__3516_v0 "${action_40388}" 2
            local ret_colored3516_v0__51_33="${ret_colored3516_v0}"
            local array_694=("")
            eprintf__3514_v0 "${key_40387}"" ""${ret_colored3516_v0__51_33}" array_694[@]
            current_len_40384="$(( current_len_40384 + needed_40390 ))"
            first_40385=0
            iter_40386="$(( iter_40386 + 2 ))"
        done
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__3530_v0() {
    local format_40450="${1}"
    local args_40451=("${!2}")
    args_40451=("${format_40450}" "${args_40451[@]}")
    __status=$?
    printf "${args_40451[@]}" >&2
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
go_up__3570_v0() {
    local cnt_40449="${1}"
    local array_696=("")
    eprintf__3530_v0 "\\x1b[${cnt_40449}A" array_696[@]
}

# go_down(cnt: Int)
go_down__3571_v0() {
    local cnt_40452="${1}"
    local array_697=("")
    eprintf__3530_v0 "\\x1b[${cnt_40452}B" array_697[@]
}

# move the cursor up or down `cnt` lines.
# redraw_row(display_count: Int, index: Int, line: Text)
redraw_row__3578_v0() {
    local display_count_40446="${1}"
    local index_40447="${2}"
    local line_40448="${3}"
    go_up__3570_v0 "$(( display_count_40446 - index_40447 ))"
    local array_698=("")
    eprintf__3514_v0 "\\x1b[G\\x1b[K" array_698[@]
    local array_699=("")
    eprintf__3514_v0 "${line_40448}" array_699[@]
    go_down__3571_v0 "$(( display_count_40446 - index_40447 ))"
    local array_700=("")
    eprintf__3514_v0 "\\x1b[G" array_700[@]
}

# Which items of a multi-select widget are ticked.
_checked_183=()
_count_184=0
_total_185=0
_limit_186=-1
# checked_init(total: Int, limit: Int)
checked_init__3580_v0() {
    local total_40365="${1}"
    local limit_40366="${2}"
    _checked_183=()
    local __range_start_40367=0
    local __range_end_40367="${total_40365}"
    local __dir_40367=$(( ${__range_start_40367} <= ${__range_end_40367} ? 1 : -1 ))
    for (( ____40367=${__range_start_40367}; ____40367 * ${__dir_40367} < ${__range_end_40367} * ${__dir_40367}; ____40367+=${__dir_40367} )); do
        local array_703=(0)
        _checked_183+=("${array_703[@]}")
done
    _count_184=0
    _total_185="${total_40365}"
    _limit_186="${limit_40366}"
}

# checked_is(index: Int)
checked_is__3581_v0() {
    local index_40409="${1}"
    ret_checked_is3581_v0="${_checked_183[${index_40409}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:19:21)"}"
    return 0
}

# checked_toggle(index: Int)
checked_toggle__3583_v0() {
    local index_40441="${1}"
    if [ "${_checked_183[${index_40441}]?"Index out of bounds (at src/./file/../choose/../utils/widget/checked.ab:29:17)"}" != 0 ]; then
        _checked_183["${index_40441}"]=0
        _count_184="$(( _count_184 - 1 ))"
        ret_checked_toggle3583_v0=1
        return 0
    fi
    if [ "$(( $(( _limit_186 >= 0 )) && $(( _count_184 >= _limit_186 )) ))" != 0 ]; then
        ret_checked_toggle3583_v0=0
        return 0
    fi
    _checked_183["${index_40441}"]=1
    _count_184="$(( _count_184 + 1 ))"
    ret_checked_toggle3583_v0=1
    return 0
}

# checked_all()
checked_all__3584_v0() {
    if [ "$(( _limit_186 >= 0 ))" != 0 ]; then
        ret_checked_all3584_v0=0
        return 0
    fi
    local was_all_40453="$(( _count_184 == _total_185 ))"
    local __range_start_40454=0
    local __range_end_40454="${_total_185}"
    local __dir_40454=$(( ${__range_start_40454} <= ${__range_end_40454} ? 1 : -1 ))
    for (( i_40454=${__range_start_40454}; i_40454 * ${__dir_40454} < ${__range_end_40454} * ${__dir_40454}; i_40454+=${__dir_40454} )); do
        _checked_183["${i_40454}"]="$(( ! was_all_40453 ))"
done
    if [ "${was_all_40453}" != 0 ]; then
        _count_184=0
    else
        _count_184="${_total_185}"
    fi
    ret_checked_all3584_v0=1
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
render_single_page__3655_v0() {
    local __length_705="${_cursor_197}"
    local cursor_len_40428="${#__length_705}"
    local max_option_width_40429="$(( $(( _term_width_200 - cursor_len_40428 )) - 1 ))"
    local __range_start_40430=0
    local __range_end_40430="${_page_count_203}"
    local __dir_40430=$(( ${__range_start_40430} <= ${__range_end_40430} ? 1 : -1 ))
    for (( i_40430=${__range_start_40430}; i_40430 * ${__dir_40430} < ${__range_end_40430} * ${__dir_40430}; i_40430+=${__dir_40430} )); do
        cutoff_text__3493_v0 "${_page_202[${i_40430}]?"Index out of bounds (at src/./file/../choose/engine.ab:44:45)"}" "${max_option_width_40429}"
        local ret_cutoff_text3493_v0__44_27="${ret_cutoff_text3493_v0}"
        local truncated_40431="${ret_cutoff_text3493_v0__44_27}"
        if [ "$(( i_40430 == _selected_196 ))" != 0 ]; then
            colored_secondary__3462_v0 "${_cursor_197}""${truncated_40431}""
"
            local ret_colored_secondary3462_v0__46_21="${ret_colored_secondary3462_v0}"
            local array_706=("")
            eprintf__3358_v0 "${ret_colored_secondary3462_v0__46_21}" array_706[@]
        else
            print_blank__3412_v0 "${cursor_len_40428}"
            local array_707=("")
            eprintf__3358_v0 "${truncated_40431}""
" array_707[@]
        fi
done
    local remaining_slots_40432="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40432 > 0 ))" != 0 ]; then
        local __range_start_40433=0
        local __range_end_40433="${remaining_slots_40432}"
        local __dir_40433=$(( ${__range_start_40433} <= ${__range_end_40433} ? 1 : -1 ))
        for (( ____40433=${__range_start_40433}; ____40433 * ${__dir_40433} < ${__range_end_40433} * ${__dir_40433}; ____40433+=${__dir_40433} )); do
            local array_708=("")
            eprintf__3358_v0 "\\x1b[K
" array_708[@]
done
    fi
}

# render_multi_page()
render_multi_page__3656_v0() {
    local __length_709="${_cursor_197}"
    local cursor_len_40404="${#__length_709}"
    local max_option_width_40405="$(( $(( _term_width_200 - cursor_len_40404 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__3661_v0 
    local page_start_40406="${ret_chooser_page_start3661_v0}"
    local __range_start_40407=0
    local __range_end_40407="${_page_count_203}"
    local __dir_40407=$(( ${__range_start_40407} <= ${__range_end_40407} ? 1 : -1 ))
    for (( i_40407=${__range_start_40407}; i_40407 * ${__dir_40407} < ${__range_end_40407} * ${__dir_40407}; i_40407+=${__dir_40407} )); do
        local global_idx_40408="$(( page_start_40406 + i_40407 ))"
        checked_is__3581_v0 "${global_idx_40408}"
        local ret_checked_is3581_v0__66_28="${ret_checked_is3581_v0}"
        local check_mark_40410
        check_mark_40410="$(if [ "${ret_checked_is3581_v0__66_28}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__3493_v0 "${_page_202[${i_40407}]?"Index out of bounds (at src/./file/../choose/engine.ab:67:45)"}" "${max_option_width_40405}"
        local ret_cutoff_text3493_v0__67_27="${ret_cutoff_text3493_v0}"
        local truncated_40411="${ret_cutoff_text3493_v0__67_27}"
        checked_is__3581_v0 "${global_idx_40408}"
        local ret_checked_is3581_v0__70_13="${ret_checked_is3581_v0}"
        if [ "$(( i_40407 == _selected_196 ))" != 0 ]; then
            colored_secondary__3462_v0 "${_cursor_197}""${check_mark_40410}""${truncated_40411}""
"
            local ret_colored_secondary3462_v0__69_37="${ret_colored_secondary3462_v0}"
            local array_710=("")
            eprintf__3358_v0 "${ret_colored_secondary3462_v0__69_37}" array_710[@]
        elif [ "${ret_checked_is3581_v0__70_13}" != 0 ]; then
            print_blank__3412_v0 "${cursor_len_40404}"
            colored_secondary__3462_v0 "${check_mark_40410}""${truncated_40411}""
"
            local ret_colored_secondary3462_v0__72_25="${ret_colored_secondary3462_v0}"
            local array_711=("")
            eprintf__3358_v0 "${ret_colored_secondary3462_v0__72_25}" array_711[@]
        else
            print_blank__3412_v0 "${cursor_len_40404}"
            local array_712=("")
            eprintf__3358_v0 "${check_mark_40410}""${truncated_40411}""
" array_712[@]
        fi
done
    local remaining_slots_40426="$(( _display_count_193 - _page_count_203 ))"
    if [ "$(( remaining_slots_40426 > 0 ))" != 0 ]; then
        local __range_start_40427=0
        local __range_end_40427="${remaining_slots_40426}"
        local __dir_40427=$(( ${__range_start_40427} <= ${__range_end_40427} ? 1 : -1 ))
        for (( ____40427=${__range_start_40427}; ____40427 * ${__dir_40427} < ${__range_end_40427} * ${__dir_40427}; ____40427+=${__dir_40427} )); do
            local array_713=("")
            eprintf__3358_v0 "\\x1b[K
" array_713[@]
done
    fi
}

# render_page()
render_page__3657_v0() {
    if [ "${_multi_198}" != 0 ]; then
        render_multi_page__3656_v0 
    else
        render_single_page__3655_v0 
    fi
}

# render_page_indicator()
render_page_indicator__3658_v0() {
    if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
        local array_714=("")
        eprintf__3358_v0 "\\x1b[G\\x1b[K" array_714[@]
        eprintf_colored__3359_v0 "Page $(( _current_page_195 + 1 ))/${_total_pages_194}" 90
        local array_715=("")
        eprintf__3358_v0 "\\x1b[G" array_715[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__3659_v0() {
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
            local array_716=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__3520_v0 array_716[@] 36 "${_term_width_200}"
        else
            local array_717=("↑↓" "select" "enter" "confirm")
            render_tooltip__3520_v0 array_717[@] 25 "${_term_width_200}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_194 > 1 )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
            local array_718=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__3520_v0 array_718[@] 55 "${_term_width_200}"
        elif [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
            local array_719=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__3520_v0 array_719[@] 47 "${_term_width_200}"
        elif [ "$(( _limit_199 < 0 ))" != 0 ]; then
            local array_720=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__3520_v0 array_720[@] 44 "${_term_width_200}"
        else
            local array_721=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__3520_v0 array_721[@] 36 "${_term_width_200}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__3660_v0() {
    local total_40303="${1}"
    local page_size_40304="${2}"
    local header_40305="${3}"
    local cursor_40306="${4}"
    local multi_40307="${5}"
    local limit_40308="${6}"
    _total_191="${total_40303}"
    _cursor_197="${cursor_40306}"
    _multi_198="${multi_40307}"
    _limit_199="${limit_40308}"
    _current_page_195=0
    _selected_196=0
    _first_render_204=1
    _up_paged_205=0
    _has_header_201="$([ "_${header_40305}" == "_" ]; echo $?)"
    stty_lock__3400_v0 
    hide_cursor__3417_v0 
    term_width__3407_v0 
    _term_width_200="${ret_term_width3407_v0}"
    term_height__3408_v0 
    local term_height_40320="${ret_term_height3408_v0}"
    local max_page_size_40321
    max_page_size_40321="$(( term_height_40320 - $(if [ "${_has_header_201}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_192="${page_size_40304}"
    if [ "$(( _page_size_192 > max_page_size_40321 ))" != 0 ]; then
        _page_size_192="${max_page_size_40321}"
    fi
    if [ "${_has_header_201}" != 0 ]; then
        cutoff_text__3493_v0 "${header_40305}" "${_term_width_200}"
        local ret_cutoff_text3493_v0__152_17="${ret_cutoff_text3493_v0}"
        local array_722=("")
        eprintf__3358_v0 "${ret_cutoff_text3493_v0__152_17}""
" array_722[@]
    fi
    _total_pages_194="$(( $(( $(( total_40303 + _page_size_192 )) - 1 )) / _page_size_192 ))"
    _display_count_193="${_page_size_192}"
    if [ "$(( total_40303 < _page_size_192 ))" != 0 ]; then
        _display_count_193="${total_40303}"
    fi
    if [ "${multi_40307}" != 0 ]; then
        checked_init__3580_v0 "${total_40303}" "${limit_40308}"
    fi
    new_line__3413_v0 "${_display_count_193}"
    local array_723=("")
    eprintf__3358_v0 "\\x1b[G" array_723[@]
    if [ "$(( _total_pages_194 > 1 ))" != 0 ]; then
        eprintf_colored__3359_v0 "Page $(( _current_page_195 + 1 ))/${_total_pages_194}" 90
    fi
    new_line__3413_v0 1
    render_tooltip_line__3659_v0 
    go_up__3414_v0 "$(( _display_count_193 + 1 ))"
    local array_724=("")
    eprintf__3358_v0 "\\x1b[G" array_724[@]
}

# chooser_page_start()
chooser_page_start__3661_v0() {
    ret_chooser_page_start3661_v0="$(( _current_page_195 * _page_size_192 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__3662_v0() {
    chooser_page_start__3661_v0 
    local start_40395="${ret_chooser_page_start3661_v0}"
    local end_40396="$(( start_40395 + _page_size_192 ))"
    if [ "$(( end_40396 > _total_191 ))" != 0 ]; then
        end_40396="${_total_191}"
    fi
    ret_chooser_page_count3662_v0="$(( end_40396 - start_40395 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__3663_v0() {
    local page_40403=("${!1}")
    _page_202=("${page_40403[@]}")
    local __length_725=("${page_40403[@]}")
    _page_count_203="${#__length_725[@]}"
    if [ "${_first_render_204}" != 0 ]; then
        _first_render_204=0
        render_page__3657_v0 
    else
        if [ "${_up_paged_205}" != 0 ]; then
            _selected_196="$(( _page_count_203 - 1 ))"
            _up_paged_205=0
        fi
        go_up__3414_v0 1
        remove_line__3410_v0 "$(( _display_count_193 - 1 ))"
        remove_current_line__3411_v0 
        local array_726=("")
        eprintf__3358_v0 "\\x1b[G" array_726[@]
        render_page__3657_v0 
        render_page_indicator__3658_v0 
    fi
}

# option_width()
option_width__3664_v0() {
    local check_width_40443
    check_width_40443="$(if [ "${_multi_198}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_727="${_cursor_197}"
    ret_option_width3664_v0="$(( $(( _term_width_200 - ${#__length_727} )) - check_width_40443 ))"
    return 0
}

# unselected_line(index: Int)
unselected_line__3665_v0() {
    local index_40456="${1}"
    local __length_728="${_cursor_197}"
    rpad__28_v0 "" " " "${#__length_728}"
    local blank_40457="${ret_rpad28_v0}"
    option_width__3664_v0 
    local ret_option_width3664_v0__223_49="${ret_option_width3664_v0}"
    cutoff_text__3493_v0 "${_page_202[${index_40456}]?"Index out of bounds (at src/./file/../choose/engine.ab:223:41)"}" "${ret_option_width3664_v0__223_49}"
    local truncated_40458="${ret_cutoff_text3493_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        ret_unselected_line3665_v0="${blank_40457}""${truncated_40458}"
        return 0
    fi
    chooser_page_start__3661_v0 
    local ret_chooser_page_start3661_v0__227_19="${ret_chooser_page_start3661_v0}"
    checked_is__3581_v0 "$(( ret_chooser_page_start3661_v0__227_19 + index_40456 ))"
    local ret_checked_is3581_v0__227_8="${ret_checked_is3581_v0}"
    if [ "${ret_checked_is3581_v0__227_8}" != 0 ]; then
        colored_secondary__3462_v0 "✓ ""${truncated_40458}"
        local ret_colored_secondary3462_v0__228_24="${ret_colored_secondary3462_v0}"
        ret_unselected_line3665_v0="${blank_40457}""${ret_colored_secondary3462_v0__228_24}"
        return 0
    fi
    ret_unselected_line3665_v0="${blank_40457}""• ""${truncated_40458}"
    return 0
}

# selected_line(index: Int)
selected_line__3666_v0() {
    local index_40442="${1}"
    option_width__3664_v0 
    local ret_option_width3664_v0__235_49="${ret_option_width3664_v0}"
    cutoff_text__3493_v0 "${_page_202[${index_40442}]?"Index out of bounds (at src/./file/../choose/engine.ab:235:41)"}" "${ret_option_width3664_v0__235_49}"
    local truncated_40444="${ret_cutoff_text3493_v0}"
    if [ "$(( ! _multi_198 ))" != 0 ]; then
        colored_secondary__3462_v0 "${_cursor_197}""${truncated_40444}"
        ret_selected_line3666_v0="${ret_colored_secondary3462_v0}"
        return 0
    fi
    chooser_page_start__3661_v0 
    local ret_chooser_page_start3661_v0__239_29="${ret_chooser_page_start3661_v0}"
    checked_is__3581_v0 "$(( ret_chooser_page_start3661_v0__239_29 + index_40442 ))"
    local ret_checked_is3581_v0__239_18="${ret_checked_is3581_v0}"
    local mark_40445
    mark_40445="$(if [ "${ret_checked_is3581_v0__239_18}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    colored_secondary__3462_v0 "${_cursor_197}""${mark_40445}""${truncated_40444}"
    ret_selected_line3666_v0="${ret_colored_secondary3462_v0}"
    return 0
}

# redraw_selection(prev_selected: Int)
redraw_selection__3667_v0() {
    local prev_selected_40455="${1}"
    unselected_line__3665_v0 "${prev_selected_40455}"
    local ret_unselected_line3665_v0__246_47="${ret_unselected_line3665_v0}"
    redraw_row__3578_v0 "${_display_count_193}" "${prev_selected_40455}" "${ret_unselected_line3665_v0__246_47}"
    selected_line__3666_v0 "${_selected_196}"
    local ret_selected_line3666_v0__247_43="${ret_selected_line3666_v0}"
    redraw_row__3578_v0 "${_display_count_193}" "${_selected_196}" "${ret_selected_line3666_v0__247_43}"
}

# redraw_current_line()
redraw_current_line__3668_v0() {
    selected_line__3666_v0 "${_selected_196}"
    local ret_selected_line3666_v0__252_43="${ret_selected_line3666_v0}"
    redraw_row__3578_v0 "${_display_count_193}" "${_selected_196}" "${ret_selected_line3666_v0__252_43}"
}

# chooser_step()
chooser_step__3669_v0() {
    get_key__3356_v0 
    local key_40437="${ret_get_key3356_v0}"
    local prev_selected_40438="${_selected_196}"
    local prev_page_40439="${_current_page_195}"
    chooser_page_start__3661_v0 
    local page_start_40440="${ret_chooser_page_start3661_v0}"
    _up_paged_205=0
    if [ "$(( $([ "_${key_40437}" != "_UP" ]; echo $?) || $([ "_${key_40437}" != "_k" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40437}" != "_DOWN" ]; echo $?) || $([ "_${key_40437}" != "_j" ]; echo $?) ))" != 0 ]; then
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
    elif [ "$(( $([ "_${key_40437}" != "_LEFT" ]; echo $?) || $([ "_${key_40437}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 > 0 ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 - 1 ))"
        fi
        _selected_196=0
    elif [ "$(( $([ "_${key_40437}" != "_RIGHT" ]; echo $?) || $([ "_${key_40437}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_195 < $(( _total_pages_194 - 1 )) ))" != 0 ]; then
            _current_page_195="$(( _current_page_195 + 1 ))"
            _selected_196=0
        else
            _selected_196="$(( _page_count_203 - 1 ))"
        fi
    elif [ "$(( _multi_198 && $(( $(( $([ "_${key_40437}" != "_x" ]; echo $?) || $([ "_${key_40437}" != "_X" ]; echo $?) )) || $([ "_${key_40437}" != "_TAB" ]; echo $?) )) ))" != 0 ]; then
        checked_toggle__3583_v0 "$(( page_start_40440 + _selected_196 ))"
        local ret_checked_toggle3583_v0__309_16="${ret_checked_toggle3583_v0}"
        if [ "${ret_checked_toggle3583_v0__309_16}" != 0 ]; then
            redraw_current_line__3668_v0 
        fi
        ret_chooser_step3669_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $(( _multi_198 && $(( $(( $([ "_${key_40437}" != "_a" ]; echo $?) || $([ "_${key_40437}" != "_A" ]; echo $?) )) || $([ "_${key_40437}" != "_CTRL_A" ]; echo $?) )) )) && $(( _limit_199 < 0 )) ))" != 0 ]; then
        checked_all__3584_v0 
        local ret_checked_all3584_v0__315_16="${ret_checked_all3584_v0}"
        if [ "${ret_checked_all3584_v0__315_16}" != 0 ]; then
            go_up__3414_v0 "${_display_count_193}"
            local array_729=("")
            eprintf__3358_v0 "\\x1b[G" array_729[@]
            render_page__3657_v0 
        fi
        ret_chooser_step3669_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    elif [ "$(( $([ "_${key_40437}" != "_INPUT" ]; echo $?) || $([ "_${key_40437}" != "_SPACE" ]; echo $?) ))" != 0 ]; then
        ret_chooser_step3669_v0="${__CHOOSER_DONE_190}"
        return 0
    else
        ret_chooser_step3669_v0="${__CHOOSER_CONTINUE_188}"
        return 0
    fi
    if [ "$(( prev_page_40439 != _current_page_195 ))" != 0 ]; then
        ret_chooser_step3669_v0="${__CHOOSER_NEED_PAGE_189}"
        return 0
    fi
    if [ "$(( prev_selected_40438 != _selected_196 ))" != 0 ]; then
        redraw_selection__3667_v0 "${prev_selected_40438}"
    fi
    ret_chooser_step3669_v0="${__CHOOSER_CONTINUE_188}"
    return 0
}

# chooser_selected()
chooser_selected__3670_v0() {
    chooser_page_start__3661_v0 
    local ret_chooser_page_start3661_v0__339_12="${ret_chooser_page_start3661_v0}"
    ret_chooser_selected3670_v0="$(( ret_chooser_page_start3661_v0__339_12 + _selected_196 ))"
    return 0
}

# chooser_end()
chooser_end__3672_v0() {
    local total_lines_40461="$(( _display_count_193 + 2 ))"
    if [ "${_has_header_201}" != 0 ]; then
        total_lines_40461="$(( total_lines_40461 + 1 ))"
    fi
    go_down__3415_v0 1
    remove_line__3410_v0 "$(( total_lines_40461 - 1 ))"
    remove_current_line__3411_v0 
    stty_unlock__3401_v0 
    show_cursor__3418_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__3681_v0() {
    local name_40399="${1}"
    local file_type_40400="${2}"
    local target_40401="${3}"
    if [ "$([ "_${file_type_40400}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__3117_v0 "/"
        local ret_colored_primary3117_v0__10_23="${ret_colored_primary3117_v0}"
        ret_format_entry_display3681_v0="${name_40399}""${ret_colored_primary3117_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_40400}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__3119_v0 " > "
        local ret_colored_accent3119_v0__13_23="${ret_colored_accent3119_v0}"
        colored_primary__3117_v0 "${target_40401}"
        local ret_colored_primary3117_v0__13_47="${ret_colored_primary3117_v0}"
        ret_format_entry_display3681_v0="${name_40399}""${ret_colored_accent3119_v0__13_23}""${ret_colored_primary3117_v0__13_47}"
        return 0
    fi
    ret_format_entry_display3681_v0="${name_40399}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__3682_v0() {
    local start_path_40271="${1}"
    local cursor_40272="${2}"
    local show_hidden_40273="${3}"
    local page_size_40274="${4}"
    stty_lock__3056_v0 
    # Initialize current path
    local current_path_40281="${start_path_40271}"
    if [ "$([ "_${current_path_40281}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__3098_v0 
        current_path_40281="${ret_get_cwd3098_v0}"
    fi
    normalize_path__3099_v0 "${current_path_40281}"
    current_path_40281="${ret_normalize_path3099_v0}"
    while :
    do
        colored_primary__3117_v0 "Loading files..."
        local ret_colored_primary3117_v0__41_17="${ret_colored_primary3117_v0}"
        local array_730=("")
        eprintf__3014_v0 "${ret_colored_primary3117_v0__41_17}" array_730[@]
        get_directory_entries__3097_v0 "${current_path_40281}"
        local listed_40292=("${ret_get_directory_entries3097_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_40293=()
        local types_40294=()
        local targets_40295=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_40281}" == "_/" ]; echo $?)" != 0 ]; then
            names_40293+=("..")
            types_40294+=("d")
            targets_40295+=("")
        fi
        local __length_737=("${listed_40292[@]}")
        local listed_count_40296="$(( ${#__length_737[@]} / __ENTRY_STRIDE_151 ))"
        local __range_start_40297=0
        local __range_end_40297="${listed_count_40296}"
        local __dir_40297=$(( ${__range_start_40297} <= ${__range_end_40297} ? 1 : -1 ))
        for (( i_40297=${__range_start_40297}; i_40297 * ${__dir_40297} < ${__range_end_40297} * ${__dir_40297}; i_40297+=${__dir_40297} )); do
            local at_40298="$(( i_40297 * __ENTRY_STRIDE_151 ))"
            local name_40299="${listed_40292[${at_40298}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_40299}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_40273 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_738=("${name_40299}")
            names_40293+=("${array_738[@]}")
            local array_739=("${listed_40292[$(( at_40298 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_40294+=("${array_739[@]}")
            local array_740=("${listed_40292[$(( at_40298 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_40295+=("${array_740[@]}")
done
        local __length_741=("${names_40293[@]}")
        local total_40300="${#__length_741[@]}"
        if [ "$(( total_40300 == 0 ))" != 0 ]; then
            eprintf_colored__3015_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__3057_v0 
            ret_xyl_file3682_v0=""
            return 0
        fi
        colored_primary__3117_v0 "${current_path_40281}"
        local header_40302="${ret_colored_primary3117_v0}"
        remove_current_line__3067_v0 
        chooser_begin__3660_v0 "${total_40300}" "${page_size_40274}" "${header_40302}" "${cursor_40272}" 0 -1
        local need_page_40392=1
        while :
        do
            if [ "${need_page_40392}" != 0 ]; then
                local page_40393=()
                chooser_page_start__3661_v0 
                local start_40394="${ret_chooser_page_start3661_v0}"
                chooser_page_count__3662_v0 
                local count_40397="${ret_chooser_page_count3662_v0}"
                local __range_start_40398="${start_40394}"
                local __range_end_40398="$(( start_40394 + count_40397 ))"
                local __dir_40398=$(( ${__range_start_40398} <= ${__range_end_40398} ? 1 : -1 ))
                for (( i_40398=${__range_start_40398}; i_40398 * ${__dir_40398} < ${__range_end_40398} * ${__dir_40398}; i_40398+=${__dir_40398} )); do
                    format_entry_display__3681_v0 "${names_40293[${i_40398}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_40294[${i_40398}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_40295[${i_40398}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display3681_v0__90_30="${ret_format_entry_display3681_v0}"
                    local array_743=("${ret_format_entry_display3681_v0__90_30}")
                    page_40393+=("${array_743[@]}")
done
                chooser_set_page__3663_v0 page_40393[@]
            fi
            chooser_step__3669_v0 
            local step_40459="${ret_chooser_step3669_v0}"
            if [ "$(( step_40459 == __CHOOSER_DONE_190 ))" != 0 ]; then
                break
            fi
            need_page_40392="$(( step_40459 == __CHOOSER_NEED_PAGE_189 ))"
        done
        chooser_selected__3670_v0 
        local selected_idx_40460="${ret_chooser_selected3670_v0}"
        chooser_end__3672_v0 
        local name_40464="${names_40293[${selected_idx_40460}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_40465="${types_40294[${selected_idx_40460}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_40464}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__3101_v0 "${current_path_40281}"
            current_path_40281="${ret_get_parent_dir3101_v0}"
        elif [ "$([ "_${file_type_40465}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__3100_v0 "${current_path_40281}" "${name_40464}"
            current_path_40281="${ret_path_join3100_v0}"
            normalize_path__3099_v0 "${current_path_40281}"
            current_path_40281="${ret_normalize_path3099_v0}"
        elif [ "$([ "_${file_type_40465}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_40470="${targets_40295[${selected_idx_40460}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_40471="${target_40470}"
            starts_with__22_v0 "${target_40470}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__3100_v0 "${current_path_40281}" "${target_40470}"
                target_path_40471="${ret_path_join3100_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_40471}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_40281="${target_path_40471}"
                normalize_path__3099_v0 "${current_path_40281}"
                current_path_40281="${ret_normalize_path3099_v0}"
            else
                stty_unlock__3057_v0 
                path_join__3100_v0 "${current_path_40281}" "${name_40464}"
                ret_xyl_file3682_v0="${ret_path_join3100_v0}"
                return 0
            fi
        else
            stty_unlock__3057_v0 
            path_join__3100_v0 "${current_path_40281}" "${name_40464}"
            ret_xyl_file3682_v0="${ret_path_join3100_v0}"
            return 0
        fi
    done
    stty_unlock__3057_v0 
    ret_xyl_file3682_v0=""
    return 0
}

# print_file_help()
print_file_help__3782_v0() {
    local usage_40186=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__3075_v0 usage_40186[@]
    printf '%s\n' ""
    colored_primary__3117_v0 "file"
    local ret_colored_primary3117_v0__8_20="${ret_colored_primary3117_v0}"
    local title_40226=("${ret_colored_primary3117_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__3075_v0 title_40226[@]
    printf '%s\n' ""
    colored_secondary__3118_v0 "Arguments:"
    local ret_colored_secondary3118_v0__11_12="${ret_colored_secondary3118_v0}"
    local array_746=()
    printf__128_v0 "${ret_colored_secondary3118_v0__11_12}""
" array_746[@]
    local arg_names_40228=("[<path>]")
    local arg_texts_40229=("Starting directory path")
    local arg_notes_40230=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__3253_v0 arg_names_40228[@] arg_texts_40229[@] arg_notes_40230[@] 20
    printf '%s\n' ""
    colored_secondary__3118_v0 "Flags:"
    local ret_colored_secondary3118_v0__18_12="${ret_colored_secondary3118_v0}"
    local array_750=()
    printf__128_v0 "${ret_colored_secondary3118_v0__18_12}""
" array_750[@]
    local names_40263=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_40264=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_40265=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__3253_v0 names_40263[@] texts_40264[@] notes_40265[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3840_v0() {
    local parameters_40180=("${!1}")
    local cursor_40181="> "
    local start_path_40182=""
    local show_hidden_40183=0
    local page_size_40184=10
    local __length_757=("${parameters_40180[@]}")
    local slice_upper_756="${#__length_757[@]}"
    local slice_offset_758=2
    local slice_offset_758=$((${slice_offset_758} > 0 ? ${slice_offset_758} : 0))
    local slice_length_759="$(( slice_upper_756 - slice_offset_758 ))"
    local slice_length_759=$((${slice_length_759} > 0 ? ${slice_length_759} : 0))
    for param_40185 in "${parameters_40180[@]:${slice_offset_758}:${slice_length_759}}"; do
        starts_with__22_v0 "${param_40185}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40185}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_40185}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_40185}" != "_-h" ]; echo $?) || $([ "_${param_40185}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3782_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_760="--cursor="
            slice__24_v0 "${param_40185}" "${#__length_760}" 0
            cursor_40181="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_761="--path="
            slice__24_v0 "${param_40185}" "${#__length_761}" 0
            start_path_40182="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_40185}" != "_-a" ]; echo $?) || $([ "_${param_40185}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_40183=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_762="--page-size="
            slice__24_v0 "${param_40185}" "${#__length_762}" 0
            local value_40266="${ret_slice24_v0}"
            parse_int__13_v0 "${value_40266}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__3015_v0 "ERROR: Invalid page-size value: ""${value_40266}""
" 31
                exit 1
            fi
            page_size_40184="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_40182="${param_40185}"
        fi
    done
    xyl_file__3682_v0 "${start_path_40182}" "${cursor_40181}" "${show_hidden_40183}" "${page_size_40184}"
    ret_execute_file3840_v0="${ret_xyl_file3682_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_211="0.1.0"
__AMBER_VERSION_212="0.6.0-alpha"
# trap_cleanup()
trap_cleanup__3842_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo icanon 2>/dev/null < /dev/tty' EXIT
    __status=$?
}

typeset -r args_213=("$0" "$@")
trap_cleanup__3842_v0 
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_764=("${args_213[@]}")
if [ "$(( ${#__length_764[@]} < 2 ))" != 0 ]; then
    print_help__557_v0 
    exit 0
fi
command_1579="${args_213[1]?"Index out of bounds (at src/main.ab:29:26)"}"
if [ "$(( $(( $([ "_${command_1579}" != "_help" ]; echo $?) || $([ "_${command_1579}" != "_--help" ]; echo $?) )) || $([ "_${command_1579}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__557_v0 
elif [ "$([ "_${command_1579}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1095_v0 args_213[@]
    ret_execute_input1095_v0__36_18="${ret_execute_input1095_v0}"
    printf '%s\n' "${ret_execute_input1095_v0__36_18}"
elif [ "$([ "_${command_1579}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1761_v0 args_213[@]
    ret_execute_choose1761_v0__39_18="${ret_execute_choose1761_v0}"
    printf '%s\n' "${ret_execute_choose1761_v0__39_18}"
elif [ "$([ "_${command_1579}" != "_filter" ]; echo $?)" != 0 ]; then
    execute_filter__2314_v0 args_213[@]
    ret_execute_filter2314_v0__42_18="${ret_execute_filter2314_v0}"
    printf '%s\n' "${ret_execute_filter2314_v0__42_18}"
elif [ "$([ "_${command_1579}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2896_v0 args_213[@]
    result_29802="${ret_execute_confirm2896_v0}"
    if [ "$([ "_${result_29802}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1579}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3840_v0 args_213[@]
    ret_execute_file3840_v0__52_18="${ret_execute_file3840_v0}"
    printf '%s\n' "${ret_execute_file3840_v0__52_18}"
elif [ "$(( $(( $([ "_${command_1579}" != "_version" ]; echo $?) || $([ "_${command_1579}" != "_--version" ]; echo $?) )) || $([ "_${command_1579}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__264_v0 "xylitol.sh"
    ret_colored_primary264_v0__55_20="${ret_colored_primary264_v0}"
    array_765=()
    printf__128_v0 "${ret_colored_primary264_v0__55_20}" array_765[@]
    array_766=()
    printf__128_v0 " version: " array_766[@]
    colored_accent__266_v0 "${__VERSION_211}"
    ret_colored_accent266_v0__57_20="${ret_colored_accent266_v0}"
    array_767=()
    printf__128_v0 "${ret_colored_accent266_v0__57_20}" array_767[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_212}" 90
else
    print_help__557_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1579}""'" 91
fi
