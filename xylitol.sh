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
    local text_1420="${1}"
    local delimiter_1421="${2}"
    local result_1422=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1421}" read -rd '' -A result_1422 < <(printf %s "$text_1420")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1421}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1422+=("$REPLY"); done < <(echo "$text_1420")
            __status=$?
        else
            IFS="${delimiter_1421}" read -rd '' -a result_1422 < <(printf %s "$text_1420")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1421}" read -rd '' -a result_1422 < <(printf %s "$text_1420")
        __status=$?
    fi
    ret_split4_v0=("${result_1422[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_16665=("${!1}")
    local delimiter_16666="${2}"
    local command_1
    command_1="$(IFS="${delimiter_16666}" ; printf "%s
" "${list_16665[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1424="${1}"
    [ -n "${text_1424}" ] && [ "${text_1424}" -eq "${text_1424}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1424}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_2984="${1}"
    local prefix_2985="${2}"
    [[ "${text_2984}" == "${prefix_2985}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1507="${1}"
    local index_1508="${2}"
    local length_1509="${3}"
    local result_1510=""
    if [ "$(( length_1509 == 0 ))" != 0 ]; then
        local __length_2="${text_1507}"
        length_1509="$(( ${#__length_2} - index_1508 ))"
    fi
    if [ "$(( length_1509 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1510}"
        return 0
    fi
    result_1510="${text_1507: ${index_1508}: ${length_1509}}"
    __status=$?
    ret_slice24_v0="${result_1510}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_18671="${1}"
    local pad_18672="${2}"
    local length_18673="${3}"
    local __length_3="${text_18671}"
    if [ "$(( length_18673 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_18671}"
        return 0
    fi
    local __length_4="${text_18671}"
    local pad_len_18674="$(( length_18673 - ${#__length_4} ))"
    local padding_18675=""
    printf -v padding_18675 "%${pad_len_18674}s" ""
    __status=$?
    padding_18675="${padding_18675// /${pad_18672}}"
    __status=$?
    ret_lpad27_v0="${padding_18675}""${text_18671}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1487="${1}"
    local pad_1488="${2}"
    local length_1489="${3}"
    local __length_5="${text_1487}"
    if [ "$(( length_1489 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1487}"
        return 0
    fi
    local __length_6="${text_1487}"
    local pad_len_1490="$(( length_1489 - ${#__length_6} ))"
    local padding_1491=""
    printf -v padding_1491 "%${pad_len_1490}s" ""
    __status=$?
    padding_1491="${padding_1491// /${pad_1488}}"
    __status=$?
    ret_rpad28_v0="${text_1487}""${padding_1491}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_18665="${1}"
    local pad_18666="${2}"
    local length_18667="${3}"
    local __length_7="${text_18665}"
    local text_length_18668="${#__length_7}"
    if [ "$(( length_18667 <= text_length_18668 ))" != 0 ]; then
        ret_cpad29_v0="${text_18665}"
        return 0
    fi
    local total_padding_18669="$(( length_18667 - text_length_18668 ))"
    local left_padding_length_18670="$(( text_length_18668 + $(( total_padding_18669 / 2 )) ))"
    lpad__27_v0 "${text_18665}" "${pad_18666}" "${left_padding_length_18670}"
    local left_padded_18676="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_18676}" "${pad_18666}" "${length_18667}"
    local center_padded_18677="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_18677}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_28365="${1}"
    [ -d "${path_28365}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1447="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1447}")"
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
" "${(P)name_1447}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1447}")"
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
    local format_1444="${1}"
    local args_1445=("${!2}")
    args_1445=("${format_1444}" "${args_1445[@]}")
    __status=$?
    printf "${args_1445[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1457="${1}"
    local args_1458=("${!2}")
    args_1458=("${format_1457}" "${args_1458[@]}")
    __status=$?
    printf "${args_1458[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1454="${1}"
    local color_1455="${2}"
    local color_code_1456=0
        color_code_1456="${color_1455}"
    local array_11=("${message_1454}")
    printf__128_v1 "\\x1b[${color_code_1456}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_28368="${1}"
    local color_28369="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_28368}")
    printf__128_v1 "\\x1b[${color_28369}m%s\\x1b[0m" array_12[@]
}

# eprintf(format: Text, args: [Text])
eprintf__161_v0() {
    local format_178="${1}"
    local args_179=("${!2}")
    args_179=("${format_178}" "${args_179[@]}")
    __status=$?
    printf "${args_179[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__162_v0() {
    local message_176="${1}"
    local color_177="${2}"
    # Prints an error message with a specified color.
    local array_13=("${message_176}")
    eprintf__161_v0 "\\x1b[${color_177}m%s\\x1b[0m" array_13[@]
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
        local disabled_1440
        disabled_1440="$([ "_${command_14}" != "_No" ]; echo $?)"
        local command_15
        command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1441
        found_1441="$(( $(( ! disabled_1440 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1441}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available184_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__185_v0() {
    local text_1439="${1}"
    perl_available__184_v0 
    local ret_perl_available184_v0__22_12="${ret_perl_available184_v0}"
    if [ "$(( ! ret_perl_available184_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return 1
    fi
    local command_16
    command_16="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1439}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_str_1442="${command_16}"
    parse_int__13_v0 "${width_str_1442}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width185_v0=''
        return "${__status}"
    fi
    local width_1443="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width185_v0="${width_1443}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__190_v0() {
    local text_1432="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_17
    command_17="$([[ "${text_1432}" == *$'\x1b'* || "${text_1432}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1433="${command_17}"
    ret_has_ansi_escape190_v0="$([ "_${has_escape_1433}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__192_v0() {
    local text_1435="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1435}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi192_v0="${command_18}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__193_v0() {
    local text_1437="${1}"
    local command_19
    command_19="$(printf "%s" "${text_1437}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1438="${command_19}"
    ret_is_all_ascii193_v0="$([ "_${result_1438}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__194_v0() {
    local text_1434="${1}"
    strip_ansi__192_v0 "${text_1434}"
    local stripped_1436="${ret_strip_ansi192_v0}"
    # Check if text is all ASCII
    is_all_ascii__193_v0 "${stripped_1436}"
    local ret_is_all_ascii193_v0__36_12="${ret_is_all_ascii193_v0}"
    if [ "$(( ! ret_is_all_ascii193_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__185_v0 "${stripped_1436}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_20="${stripped_1436}"
            ret_get_visible_len194_v0="${#__length_20}"
            return 0
        fi
        ret_get_visible_len194_v0="${ret_perl_get_cjk_width185_v0}"
        return 0
    else
        local __length_21="${stripped_1436}"
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
    local size_1419="${1}"
    if [ "$([ "_${size_1419}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size203_v0=0
        return 0
    fi
    split__4_v0 "${size_1419}" " "
    local parts_1423=("${ret_split4_v0[@]}")
    local __length_23=("${parts_1423[@]}")
    if [ "$(( ${#__length_23[@]} != 2 ))" != 0 ]; then
        ret_store_term_size203_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1423[1]?"Index out of bounds (at src/utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1423[0]?"Index out of bounds (at src/utils/term.ab:53:68)"}"
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
    local size_1426="${command_25}"
    store_term_size__203_v0 "${size_1426}"
    ret_query_term_size204_v0="${ret_store_term_size203_v0}"
    return 0
}

# stty_term_size()
stty_term_size__205_v0() {
    local command_26
    command_26="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1418="${command_26}"
    store_term_size__203_v0 "${size_1418}"
    ret_stty_term_size205_v0="${ret_store_term_size203_v0}"
    return 0
}

# get_term_size()
get_term_size__206_v0() {
    stty_term_size__205_v0 
    local detected_1425="${ret_stty_term_size205_v0}"
    if [ "$(( ! detected_1425 ))" != 0 ]; then
        query_term_size__204_v0 
        detected_1425="${ret_query_term_size204_v0}"
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
    local pieces_1417=("${!1}")
    term_width__208_v0 
    local width_1427="${ret_term_width208_v0}"
    local line_1428=""
    local line_len_1429=0
    for piece_1430 in "${pieces_1417[@]}"; do
        local __length_29="${piece_1430}"
        local piece_len_1431="${#__length_29}"
        has_ansi_escape__190_v0 "${piece_1430}"
        local ret_has_ansi_escape190_v0__186_12="${ret_has_ansi_escape190_v0}"
        if [ "${ret_has_ansi_escape190_v0__186_12}" != 0 ]; then
            get_visible_len__194_v0 "${piece_1430}"
            piece_len_1431="${ret_get_visible_len194_v0}"
        fi
        if [ "$([ "_${line_1428}" != "_" ]; echo $?)" != 0 ]; then
            line_1428="${piece_1430}"
            line_len_1429="${piece_len_1431}"
        elif [ "$(( $(( $(( line_len_1429 + 1 )) + piece_len_1431 )) > width_1427 ))" != 0 ]; then
            local array_30=()
            printf__128_v0 "${line_1428}""
" array_30[@]
            line_1428="${piece_1430}"
            line_len_1429="${piece_len_1431}"
        else
            line_1428+=" ""${piece_1430}"
            line_len_1429="$(( line_len_1429 + $(( 1 + piece_len_1431 )) ))"
        fi
    done
    if [ "$([ "_${line_1428}" == "_" ]; echo $?)" != 0 ]; then
        local array_31=()
        printf__128_v0 "${line_1428}""
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
    local config_1464="${ret_env_var_get120_v0}"
    _supports_truecolor_8="$(if [ "$([ "_${config_1464}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor257_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__258_v0() {
    local message_1459="${1}"
    local r_1460="${2}"
    local g_1461="${3}"
    local b_1462="${4}"
    local fallback_1463="${5}"
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb258_v0="\\x1b[38;2;${r_1460};${g_1461};${b_1462}m""${message_1459}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__257_v0 
        local ret_get_supports_truecolor257_v0__45_17="${ret_get_supports_truecolor257_v0}"
        if [ "${ret_get_supports_truecolor257_v0__45_17}" != 0 ]; then
            ret_colored_rgb258_v0="\\x1b[38;2;${r_1460};${g_1461};${b_1462}m""${message_1459}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1463 == 0 ))" != 0 ]; then
            ret_colored_rgb258_v0="${message_1459}"
            return 0
        else
            ret_colored_rgb258_v0="\\x1b[${fallback_1463}m""${message_1459}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1463 == 0 ))" != 0 ]; then
            ret_colored_rgb258_v0="${message_1459}"
            return 0
        fi
        ret_colored_rgb258_v0="\\x1b[${fallback_1463}m""${message_1459}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__260_v0() {
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1448="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1448}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1448}" ";"
            local parts_1449=("${ret_split4_v0[@]}")
            local __length_35=("${parts_1449[@]}")
            if [ "$(( ${#__length_35[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1449[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1449[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1449[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1449[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
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
        local secondary_env_1450="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1450}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1450}" ";"
            local parts_1451=("${ret_split4_v0[@]}")
            local __length_37=("${parts_1451[@]}")
            if [ "$(( ${#__length_37[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1451[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1451[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1451[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1451[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
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
        local accent_env_1452="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1452}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1452}" ";"
            local parts_1453=("${ret_split4_v0[@]}")
            local __length_39=("${parts_1453[@]}")
            if [ "$(( ${#__length_39[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1453[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1453[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1453[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors260_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1453[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
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
    local message_1446="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1446}" "${_primary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary262_v0="${ret_colored_rgb258_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__263_v0() {
    local message_1466="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1466}" "${_secondary_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary263_v0="${ret_colored_rgb258_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__264_v0() {
    local message_1517="${1}"
    if [ "$(( ! _got_xylitol_colors_9 ))" != 0 ]; then
        get_xylitol_colors__261_v0 
    fi
    colored_rgb__258_v0 "${message_1517}" "${_accent_color_12[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_12[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_12[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_12[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
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
    local message_1505="${1}"
    local color_1506="${2}"
    # Returns a text wrapped in color codes.
    ret_colored316_v0="\\x1b[${color_1506}m""${message_1505}""\\x1b[0m"
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
store_term_size__360_v0() {
    local size_1479="${1}"
    if [ "$([ "_${size_1479}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size360_v0=0
        return 0
    fi
    split__4_v0 "${size_1479}" " "
    local parts_1480=("${ret_split4_v0[@]}")
    local __length_42=("${parts_1480[@]}")
    if [ "$(( ${#__length_42[@]} != 2 ))" != 0 ]; then
        ret_store_term_size360_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1480[1]?"Index out of bounds (at src/utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1480[0]?"Index out of bounds (at src/utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_17=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size360_v0=1
    return 0
}

# query_term_size()
query_term_size__361_v0() {
    local command_44
    command_44="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1482="${command_44}"
    store_term_size__360_v0 "${size_1482}"
    ret_query_term_size361_v0="${ret_store_term_size360_v0}"
    return 0
}

# stty_term_size()
stty_term_size__362_v0() {
    local command_45
    command_45="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1478="${command_45}"
    store_term_size__360_v0 "${size_1478}"
    ret_stty_term_size362_v0="${ret_store_term_size360_v0}"
    return 0
}

# get_term_size()
get_term_size__363_v0() {
    stty_term_size__362_v0 
    local detected_1481="${ret_stty_term_size362_v0}"
    if [ "$(( ! detected_1481 ))" != 0 ]; then
        query_term_size__361_v0 
        detected_1481="${ret_query_term_size361_v0}"
    fi
    _got_term_size_16=1
}

# term_width()
term_width__365_v0() {
    if [ "$(( ! _got_term_size_16 ))" != 0 ]; then
        get_term_size__363_v0 
    fi
    ret_term_width365_v0="${_term_size_17[0]?"Index out of bounds (at src/utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__379_v0() {
    local pending_1502="${1}"
    local line_1503="${2}"
    local note_at_1504="${3}"
    if [ "$(( note_at_1504 < 0 ))" != 0 ]; then
        local array_46=()
        printf__128_v0 "${pending_1502}""${line_1503}""
" array_46[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1504 == 0 ))" != 0 ]; then
        colored__316_v0 "${line_1503}" 90
        local ret_colored316_v0__12_40="${ret_colored316_v0}"
        local array_47=()
        printf__128_v0 "${pending_1502}""${ret_colored316_v0__12_40}""
" array_47[@]
    else
        slice__24_v0 "${line_1503}" 0 "${note_at_1504}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1503}" "${note_at_1504}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__316_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored316_v0__13_58="${ret_colored316_v0}"
        local array_48=()
        printf__128_v0 "${pending_1502}""${ret_slice24_v0__13_32}""${ret_colored316_v0__13_58}""
" array_48[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__380_v0() {
    local names_1470=("${!1}")
    local texts_1471=("${!2}")
    local notes_1472=("${!3}")
    local min_name_width_1473="${4}"
    local __length_49=("${names_1470[@]}")
    local count_1474="${#__length_49[@]}"
    local name_width_1475="${min_name_width_1473}"
    local __range_start_1476=0
    local __range_end_1476="${count_1474}"
    local __dir_1476=$(( ${__range_start_1476} <= ${__range_end_1476} ? 1 : -1 ))
    for (( i_1476=${__range_start_1476}; i_1476 * ${__dir_1476} < ${__range_end_1476} * ${__dir_1476}; i_1476+=${__dir_1476} )); do
        local __length_50="${names_1470[${i_1476}]?"Index out of bounds (at src/utils/widget/help.ab:28:33)"}"
        local width_1477="${#__length_50}"
        if [ "$(( width_1477 > name_width_1475 ))" != 0 ]; then
            name_width_1475="${width_1477}"
        fi
done
    term_width__365_v0 
    local width_1483="${ret_term_width365_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1484="$(( name_width_1475 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1485="$(( $(( width_1483 - indent_1484 )) < 24 ))"
    if [ "${stacked_1485}" != 0 ]; then
        indent_1484=6
    fi
    local avail_1486="$(( width_1483 - indent_1484 ))"
    rpad__28_v0 "" " " "${indent_1484}"
    local blank_1492="${ret_rpad28_v0}"
    local __range_start_1493=0
    local __range_end_1493="${count_1474}"
    local __dir_1493=$(( ${__range_start_1493} <= ${__range_end_1493} ? 1 : -1 ))
    for (( i_1493=${__range_start_1493}; i_1493 * ${__dir_1493} < ${__range_end_1493} * ${__dir_1493}; i_1493+=${__dir_1493} )); do
        local pending_1494="${blank_1492}"
        if [ "${stacked_1485}" != 0 ]; then
            local array_51=()
            printf__128_v0 "  ""${names_1470[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:48:33)"}""
" array_51[@]
        else
            rpad__28_v0 "  ""${names_1470[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:50:41)"}" " " "${indent_1484}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_1494="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_1471[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_1495=("${ret_split4_v0__52_21[@]}")
        local __length_52=("${words_1495[@]}")
        local note_start_1496="${#__length_52[@]}"
        if [ "$([ "_${notes_1472[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_53="${notes_1472[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_53} > avail_1486 ))" != 0 ]; then
                split__4_v0 "${notes_1472[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_1495+=("${ret_split4_v0__58_26[@]}")
            else
                local array_54=("${notes_1472[${i_1493}]?"Index out of bounds (at src/utils/widget/help.ab:60:33)"}")
                words_1495+=("${array_54[@]}")
            fi
        fi
        local line_1497=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1498=-1
        local __range_start_1499=0
        local __length_55=("${words_1495[@]}")
        local __range_end_1499="${#__length_55[@]}"
        local __dir_1499=$(( ${__range_start_1499} <= ${__range_end_1499} ? 1 : -1 ))
        for (( j_1499=${__range_start_1499}; j_1499 * ${__dir_1499} < ${__range_end_1499} * ${__dir_1499}; j_1499+=${__dir_1499} )); do
            local word_1500="${words_1495[${j_1499}]?"Index out of bounds (at src/utils/widget/help.ab:70:32)"}"
            local candidate_1501
            candidate_1501="$(if [ "$([ "_${line_1497}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1500}"; else echo "${line_1497}"" ""${word_1500}"; fi)"
            local __length_56="${candidate_1501}"
            if [ "$(( $(( ${#__length_56} > avail_1486 )) && $([ "_${line_1497}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__379_v0 "${pending_1494}" "${line_1497}" "${note_at_1498}"
                pending_1494="${blank_1492}"
                line_1497="${word_1500}"
                note_at_1498="$(if [ "$(( j_1499 >= note_start_1496 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1499 >= note_start_1496 )) && $(( note_at_1498 < 0 )) ))" != 0 ]; then
                    local __length_57="${candidate_1501}"
                    local __length_58="${word_1500}"
                    note_at_1498="$(( ${#__length_57} - ${#__length_58} ))"
                fi
                line_1497="${candidate_1501}"
            fi
done
        print_help_line__379_v0 "${pending_1494}" "${line_1497}" "${note_at_1498}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__525_v0() {
    local usage_1416=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__220_v0 usage_1416[@]
    printf '%s\n' ""
    colored_primary__262_v0 "Xylitol"
    local ret_colored_primary262_v0__9_21="${ret_colored_primary262_v0}"
    colored_primary__262_v0 "fresh"
    local ret_colored_primary262_v0__10_34="${ret_colored_primary262_v0}"
    local title_1465=("\\x1b[1m""${ret_colored_primary262_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary262_v0__10_34}" "shell" "scripts.")
    print_wrapped__220_v0 title_1465[@]
    printf '%s\n' ""
    colored_secondary__263_v0 "Flags:"
    local ret_colored_secondary263_v0__14_12="${ret_colored_secondary263_v0}"
    local array_61=()
    printf__128_v0 "${ret_colored_secondary263_v0__14_12}""
" array_61[@]
    local flag_names_1467=("-h, --help" "-v, --version")
    local flag_texts_1468=("Show this help message" "Show version information")
    local flag_notes_1469=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__380_v0 flag_names_1467[@] flag_texts_1468[@] flag_notes_1469[@] 13
    printf '%s\n' ""
    colored_secondary__263_v0 "Commands:"
    local ret_colored_secondary263_v0__21_12="${ret_colored_secondary263_v0}"
    local array_65=()
    printf__128_v0 "${ret_colored_secondary263_v0__21_12}""
" array_65[@]
    local cmd_names_1511=("input" "choose" "confirm" "file")
    local cmd_texts_1512=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1513=("" "" "" "")
    render_help_entries__380_v0 cmd_names_1511[@] cmd_texts_1512[@] cmd_notes_1513[@] 13
    printf '%s\n' ""
    colored_secondary__263_v0 "Envs:"
    local ret_colored_secondary263_v0__32_12="${ret_colored_secondary263_v0}"
    local array_69=()
    printf__128_v0 "${ret_colored_secondary263_v0__32_12}""
" array_69[@]
    local env_names_1514=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1515=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1516=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__380_v0 env_names_1514[@] env_texts_1515[@] env_notes_1516[@] 0
    printf '%s\n' ""
    colored_accent__264_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent264_v0__57_16="${ret_colored_accent264_v0}"
    local footer_1518=("Run" "${ret_colored_accent264_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__220_v0 footer_1518[@]
}

# math_floor(number: Int)
math_floor__606_v0() {
    local number_3067="${1}"
    local command_74
    command_74="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_3067}")"
    __status=$?
    ret_math_floor606_v0="${command_74}"
    return 0
}

# math_ceil(number: Int)
math_ceil__607_v0() {
    local number_3066="${1}"
    math_floor__606_v0 "${number_3066}"
    local ret_math_floor606_v0__52_12="${ret_math_floor606_v0}"
    ret_math_ceil607_v0="$(( ret_math_floor606_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__615_v0() {
    local command_75
    command_75="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_3061="${command_75}"
    ret_get_char615_v0="${char_3061}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__618_v0() {
    local format_3033="${1}"
    local args_3034=("${!2}")
    args_3034=("${format_3033}" "${args_3034[@]}")
    __status=$?
    printf "${args_3034[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__619_v0() {
    local message_3059="${1}"
    local color_3060="${2}"
    # Prints an error message with a specified color.
    local array_76=("${message_3059}")
    eprintf__618_v0 "\\x1b[${color_3060}m%s\\x1b[0m" array_76[@]
}

# eprintf(format: Text, args: [Text])
eprintf__634_v0() {
    local format_3037="${1}"
    local args_3038=("${!2}")
    args_3038=("${format_3037}" "${args_3038[@]}")
    __status=$?
    printf "${args_3038[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_20="None"
# perl_available()
perl_available__641_v0() {
    if [ "$([ "_${_perl_state_20}" != "_None" ]; echo $?)" != 0 ]; then
        local command_77
        command_77="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_2930
        disabled_2930="$([ "_${command_77}" != "_No" ]; echo $?)"
        local command_78
        command_78="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_2931
        found_2931="$(( $(( ! disabled_2930 )) && $([ "_${command_78}" != "_0" ]; echo $?) ))"
        _perl_state_20="$(if [ "${found_2931}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available641_v0="$([ "_${_perl_state_20}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__642_v0() {
    local text_2929="${1}"
    perl_available__641_v0 
    local ret_perl_available641_v0__22_12="${ret_perl_available641_v0}"
    if [ "$(( ! ret_perl_available641_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width642_v0=''
        return 1
    fi
    local command_79
    command_79="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2929}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width642_v0=''
        return "${__status}"
    fi
    local width_str_2932="${command_79}"
    parse_int__13_v0 "${width_str_2932}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width642_v0=''
        return "${__status}"
    fi
    local width_2933="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width642_v0="${width_2933}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__647_v0() {
    local text_2922="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_80
    command_80="$([[ "${text_2922}" == *$'\x1b'* || "${text_2922}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2923="${command_80}"
    ret_has_ansi_escape647_v0="$([ "_${has_escape_2923}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__649_v0() {
    local text_2925="${1}"
    local command_81
    command_81="$(printf "%s" "${text_2925}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi649_v0="${command_81}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__650_v0() {
    local text_2927="${1}"
    local command_82
    command_82="$(printf "%s" "${text_2927}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2928="${command_82}"
    ret_is_all_ascii650_v0="$([ "_${result_2928}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__651_v0() {
    local text_2924="${1}"
    strip_ansi__649_v0 "${text_2924}"
    local stripped_2926="${ret_strip_ansi649_v0}"
    # Check if text is all ASCII
    is_all_ascii__650_v0 "${stripped_2926}"
    local ret_is_all_ascii650_v0__36_12="${ret_is_all_ascii650_v0}"
    if [ "$(( ! ret_is_all_ascii650_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__642_v0 "${stripped_2926}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_83="${stripped_2926}"
            ret_get_visible_len651_v0="${#__length_83}"
            return 0
        fi
        ret_get_visible_len651_v0="${ret_perl_get_cjk_width642_v0}"
        return 0
    else
        local __length_84="${stripped_2926}"
        ret_get_visible_len651_v0="${#__length_84}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_21=0
_term_size_22=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__657_v0() {
    local command_86
    command_86="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_2994="${command_86}"
    parse_int__13_v0 "${count_2994}"
    __status=$?
    ret_stty_count657_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__658_v0() {
    stty_count__657_v0 
    local count_num_2995="${ret_stty_count657_v0}"
    if [ "$(( count_num_2995 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2995="$(( count_num_2995 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2995}
    __status=$?
}

# stty_unlock()
stty_unlock__659_v0() {
    stty_count__657_v0 
    local count_num_3064="${ret_stty_count657_v0}"
    if [ "$(( count_num_3064 > 0 ))" != 0 ]; then
        count_num_3064="$(( count_num_3064 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_3064}
        __status=$?
        if [ "$(( count_num_3064 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__660_v0() {
    local size_2913="${1}"
    if [ "$([ "_${size_2913}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size660_v0=0
        return 0
    fi
    split__4_v0 "${size_2913}" " "
    local parts_2914=("${ret_split4_v0[@]}")
    local __length_87=("${parts_2914[@]}")
    if [ "$(( ${#__length_87[@]} != 2 ))" != 0 ]; then
        ret_store_term_size660_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2914[1]?"Index out of bounds (at src/./input/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2914[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_22=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size660_v0=1
    return 0
}

# query_term_size()
query_term_size__661_v0() {
    local command_89
    command_89="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2916="${command_89}"
    store_term_size__660_v0 "${size_2916}"
    ret_query_term_size661_v0="${ret_store_term_size660_v0}"
    return 0
}

# stty_term_size()
stty_term_size__662_v0() {
    local command_90
    command_90="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2912="${command_90}"
    store_term_size__660_v0 "${size_2912}"
    ret_stty_term_size662_v0="${ret_store_term_size660_v0}"
    return 0
}

# get_term_size()
get_term_size__663_v0() {
    stty_term_size__662_v0 
    local detected_2915="${ret_stty_term_size662_v0}"
    if [ "$(( ! detected_2915 ))" != 0 ]; then
        query_term_size__661_v0 
        detected_2915="${ret_query_term_size661_v0}"
    fi
    _got_term_size_21=1
}

# term_width()
term_width__665_v0() {
    if [ "$(( ! _got_term_size_21 ))" != 0 ]; then
        get_term_size__663_v0 
    fi
    ret_term_width665_v0="${_term_size_22[0]?"Index out of bounds (at src/./input/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove(cnt: Int)
remove__667_v0() {
    local cnt_3062="${1}"
    if [ "$(( cnt_3062 > 0 ))" != 0 ]; then
        local array_91=("")
        eprintf__634_v0 "\\x1b[${cnt_3062}D\\x1b[K" array_91[@]
    fi
}

# remove_line(cnt: Int)
remove_line__668_v0() {
    local cnt_3070="${1}"
    if [ "$(( cnt_3070 > 0 ))" != 0 ]; then
        local sequence_3071=""
        local __range_start_3072=0
        local __range_end_3072="${cnt_3070}"
        local __dir_3072=$(( ${__range_start_3072} <= ${__range_end_3072} ? 1 : -1 ))
        for (( ____3072=${__range_start_3072}; ____3072 * ${__dir_3072} < ${__range_end_3072} * ${__dir_3072}; ____3072+=${__dir_3072} )); do
            sequence_3071+="\\x1b[2K\\x1b[1A"
done
        local array_92=("")
        eprintf__634_v0 "${sequence_3071}" array_92[@]
    fi
    local array_93=("")
    eprintf__634_v0 "\\x1b[G" array_93[@]
}

# remove_current_line()
remove_current_line__669_v0() {
    local array_94=("")
    eprintf__634_v0 "\\x1b[2K\\x1b[G" array_94[@]
}

# new_line(cnt: Int)
new_line__671_v0() {
    local cnt_3035="${1}"
    local __range_start_3036=0
    local __range_end_3036="${cnt_3035}"
    local __dir_3036=$(( ${__range_start_3036} <= ${__range_end_3036} ? 1 : -1 ))
    for (( ____3036=${__range_start_3036}; ____3036 * ${__dir_3036} < ${__range_end_3036} * ${__dir_3036}; ____3036+=${__dir_3036} )); do
        local array_95=("")
        eprintf__634_v0 "
" array_95[@]
done
}

# go_up(cnt: Int)
go_up__672_v0() {
    local cnt_3056="${1}"
    local array_96=("")
    eprintf__634_v0 "\\x1b[${cnt_3056}A" array_96[@]
}

# go_down(cnt: Int)
go_down__673_v0() {
    local cnt_3069="${1}"
    local array_97=("")
    eprintf__634_v0 "\\x1b[${cnt_3069}B" array_97[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__677_v0() {
    local pieces_2911=("${!1}")
    term_width__665_v0 
    local width_2917="${ret_term_width665_v0}"
    local line_2918=""
    local line_len_2919=0
    for piece_2920 in "${pieces_2911[@]}"; do
        local __length_100="${piece_2920}"
        local piece_len_2921="${#__length_100}"
        has_ansi_escape__647_v0 "${piece_2920}"
        local ret_has_ansi_escape647_v0__186_12="${ret_has_ansi_escape647_v0}"
        if [ "${ret_has_ansi_escape647_v0__186_12}" != 0 ]; then
            get_visible_len__651_v0 "${piece_2920}"
            piece_len_2921="${ret_get_visible_len651_v0}"
        fi
        if [ "$([ "_${line_2918}" != "_" ]; echo $?)" != 0 ]; then
            line_2918="${piece_2920}"
            line_len_2919="${piece_len_2921}"
        elif [ "$(( $(( $(( line_len_2919 + 1 )) + piece_len_2921 )) > width_2917 ))" != 0 ]; then
            local array_101=()
            printf__128_v0 "${line_2918}""
" array_101[@]
            line_2918="${piece_2920}"
            line_len_2919="${piece_len_2921}"
        else
            line_2918+=" ""${piece_2920}"
            line_len_2919="$(( line_len_2919 + $(( 1 + piece_len_2921 )) ))"
        fi
    done
    if [ "$([ "_${line_2918}" == "_" ]; echo $?)" != 0 ]; then
        local array_102=()
        printf__128_v0 "${line_2918}""
" array_102[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_25="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_26=0
_primary_color_27=(3 207 159 92)
_secondary_color_28=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__714_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_2946="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$([ "_${config_2946}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor714_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__715_v0() {
    local message_2941="${1}"
    local r_2942="${2}"
    local g_2943="${3}"
    local b_2944="${4}"
    local fallback_2945="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb715_v0="\\x1b[38;2;${r_2942};${g_2943};${b_2944}m""${message_2941}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__714_v0 
        local ret_get_supports_truecolor714_v0__45_17="${ret_get_supports_truecolor714_v0}"
        if [ "${ret_get_supports_truecolor714_v0__45_17}" != 0 ]; then
            ret_colored_rgb715_v0="\\x1b[38;2;${r_2942};${g_2943};${b_2944}m""${message_2941}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2945 == 0 ))" != 0 ]; then
            ret_colored_rgb715_v0="${message_2941}"
            return 0
        else
            ret_colored_rgb715_v0="\\x1b[${fallback_2945}m""${message_2941}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2945 == 0 ))" != 0 ]; then
            ret_colored_rgb715_v0="${message_2941}"
            return 0
        fi
        ret_colored_rgb715_v0="\\x1b[${fallback_2945}m""${message_2941}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__717_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2935="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2935}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2935}" ";"
            local parts_2936=("${ret_split4_v0[@]}")
            local __length_106=("${parts_2936[@]}")
            if [ "$(( ${#__length_106[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2936[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2936[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2936[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2936[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_27=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2937="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2937}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2937}" ";"
            local parts_2938=("${ret_split4_v0[@]}")
            local __length_108=("${parts_2938[@]}")
            if [ "$(( ${#__length_108[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2938[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2938[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2938[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2938[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_28=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2939="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2939}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2939}" ";"
            local parts_2940=("${ret_split4_v0[@]}")
            local __length_110=("${parts_2940[@]}")
            if [ "$(( ${#__length_110[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2940[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2940[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2940[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2940[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors717_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__718_v0() {
    inner_get_xylitol_colors__717_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__719_v0() {
    local message_2934="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__718_v0 
    fi
    colored_rgb__715_v0 "${message_2934}" "${_primary_color_27[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary719_v0="${ret_colored_rgb715_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__720_v0() {
    local message_2948="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__718_v0 
    fi
    colored_rgb__715_v0 "${message_2948}" "${_secondary_color_28[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary720_v0="${ret_colored_rgb715_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_30="None"
# perl_available()
perl_available__737_v0() {
    if [ "$([ "_${_perl_state_30}" != "_None" ]; echo $?)" != 0 ]; then
        local command_112
        command_112="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_3005
        disabled_3005="$([ "_${command_112}" != "_No" ]; echo $?)"
        local command_113
        command_113="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_3006
        found_3006="$(( $(( ! disabled_3005 )) && $([ "_${command_113}" != "_0" ]; echo $?) ))"
        _perl_state_30="$(if [ "${found_3006}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available737_v0="$([ "_${_perl_state_30}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__738_v0() {
    local text_3004="${1}"
    perl_available__737_v0 
    local ret_perl_available737_v0__22_12="${ret_perl_available737_v0}"
    if [ "$(( ! ret_perl_available737_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width738_v0=''
        return 1
    fi
    local command_114
    command_114="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_3004}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width738_v0=''
        return "${__status}"
    fi
    local width_str_3007="${command_114}"
    parse_int__13_v0 "${width_str_3007}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width738_v0=''
        return "${__status}"
    fi
    local width_3008="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width738_v0="${width_3008}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__739_v0() {
    local text_3015="${1}"
    local max_width_3016="${2}"
    perl_available__737_v0 
    local ret_perl_available737_v0__33_12="${ret_perl_available737_v0}"
    if [ "$(( ! ret_perl_available737_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk739_v0=''
        return 1
    fi
    local command_115
    command_115="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_3015}" ${max_width_3016} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk739_v0=''
        return "${__status}"
    fi
    local result_3017="${command_115}"
    ret_perl_truncate_cjk739_v0="${result_3017}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__743_v0() {
    local text_2986="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_116
    command_116="$([[ "${text_2986}" == *$'\x1b'* || "${text_2986}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2987="${command_116}"
    ret_has_ansi_escape743_v0="$([ "_${has_escape_2987}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__744_v0() {
    local text_2988="${1}"
    local command_117
    command_117="$(printf '%s' "${text_2988}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi744_v0="${command_117}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__745_v0() {
    local text_3000="${1}"
    local command_118
    command_118="$(printf "%s" "${text_3000}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi745_v0="${command_118}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__746_v0() {
    local text_3002="${1}"
    local command_119
    command_119="$(printf "%s" "${text_3002}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_3003="${command_119}"
    ret_is_all_ascii746_v0="$([ "_${result_3003}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__747_v0() {
    local text_2999="${1}"
    strip_ansi__745_v0 "${text_2999}"
    local stripped_3001="${ret_strip_ansi745_v0}"
    # Check if text is all ASCII
    is_all_ascii__746_v0 "${stripped_3001}"
    local ret_is_all_ascii746_v0__36_12="${ret_is_all_ascii746_v0}"
    if [ "$(( ! ret_is_all_ascii746_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__738_v0 "${stripped_3001}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_120="${stripped_3001}"
            ret_get_visible_len747_v0="${#__length_120}"
            return 0
        fi
        ret_get_visible_len747_v0="${ret_perl_get_cjk_width738_v0}"
        return 0
    else
        local __length_121="${stripped_3001}"
        ret_get_visible_len747_v0="${#__length_121}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__748_v0() {
    local text_3012="${1}"
    local max_width_3013="${2}"
    get_visible_len__747_v0 "${text_3012}"
    local visible_len_3014="${ret_get_visible_len747_v0}"
    if [ "$(( visible_len_3014 <= max_width_3013 ))" != 0 ]; then
        ret_truncate_text748_v0="${text_3012}"
        return 0
    fi
    is_all_ascii__746_v0 "${text_3012}"
    local ret_is_all_ascii746_v0__53_12="${ret_is_all_ascii746_v0}"
    if [ "$(( ! ret_is_all_ascii746_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__739_v0 "${text_3012}" "${max_width_3013}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_3012}" | cut -c1-${max_width_3013}
            __status=$?
        fi
        ret_truncate_text748_v0="${ret_perl_truncate_cjk739_v0}"
        return 0
    fi
    local command_122
    command_122="$(printf "%s" "${text_3012}" | cut -c1-${max_width_3013})"
    __status=$?
    ret_truncate_text748_v0="${command_122}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__749_v0() {
    local text_3010="${1}"
    local max_width_3011="${2}"
    has_ansi_escape__743_v0 "${text_3010}"
    local ret_has_ansi_escape743_v0__65_12="${ret_has_ansi_escape743_v0}"
    if [ "$(( ! ret_has_ansi_escape743_v0__65_12 ))" != 0 ]; then
        truncate_text__748_v0 "${text_3010}" "${max_width_3011}"
        ret_truncate_ansi749_v0="${ret_truncate_text748_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_123
    command_123="$([[ "${text_3010}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_3018="${command_123}"
    # Replace \x1b[ with newline, then split
    local command_124
    command_124="$(t="${text_3010}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_3019="${command_124}"
    split__4_v0 "${replaced_3019}" "
"
    local parts_3020=("${ret_split4_v0[@]}")
    local result_3021=""
    local remaining_width_3022="${max_width_3011}"
    local __range_start_3023=0
    local __length_125=("${parts_3020[@]}")
    local __range_end_3023="${#__length_125[@]}"
    local __dir_3023=$(( ${__range_start_3023} <= ${__range_end_3023} ? 1 : -1 ))
    for (( idx_3023=${__range_start_3023}; idx_3023 * ${__dir_3023} < ${__range_end_3023} * ${__dir_3023}; idx_3023+=${__dir_3023} )); do
        local part_3024="${parts_3020[${idx_3023}]?"Index out of bounds (at src/./input/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_3023 == 0 )) && $([ "_${starts_with_ansi_3018}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_3024}" == "_" ]; echo $?) && $(( remaining_width_3022 > 0 )) ))" != 0 ]; then
                truncate_text__748_v0 "${part_3024}" "${remaining_width_3022}"
                local ret_truncate_text748_v0__87_35="${ret_truncate_text748_v0}"
                local truncated_3025="${ret_truncate_text748_v0__87_35}"
                result_3021+="${truncated_3025}"
                get_visible_len__747_v0 "${truncated_3025}"
                local ret_get_visible_len747_v0__89_36="${ret_get_visible_len747_v0}"
                remaining_width_3022="$(( remaining_width_3022 - ret_get_visible_len747_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_126
            command_126="$(__p="${part_3024}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_3026="${command_126}"
            if [ "$([ "_${m_idx_3026}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_127
                command_127="$(__p="${part_3024}"; printf "%s" "${__p:0:${m_idx_3026}}")"
                __status=$?
                local ansi_params_3027="${command_127}"
                result_3021+="\\x1b[""${ansi_params_3027}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_3026}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_3028="${ret_parse_int13_v0__100_41}"
                local text_start_3029="$(( m_idx_num_3028 + 1 ))"
                local command_128
                command_128="$(__p="${part_3024}"; printf "%s" "${__p:${text_start_3029}}")"
                __status=$?
                local text_part_3030="${command_128}"
                if [ "$(( $([ "_${text_part_3030}" == "_" ]; echo $?) && $(( remaining_width_3022 > 0 )) ))" != 0 ]; then
                    truncate_text__748_v0 "${text_part_3030}" "${remaining_width_3022}"
                    local ret_truncate_text748_v0__104_39="${ret_truncate_text748_v0}"
                    local truncated_3031="${ret_truncate_text748_v0__104_39}"
                    result_3021+="${truncated_3031}"
                    get_visible_len__747_v0 "${truncated_3031}"
                    local ret_get_visible_len747_v0__106_40="${ret_get_visible_len747_v0}"
                    remaining_width_3022="$(( remaining_width_3022 - ret_get_visible_len747_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_3024}" == "_" ]; echo $?) && $(( remaining_width_3022 > 0 )) ))" != 0 ]; then
                    truncate_text__748_v0 "${part_3024}" "${remaining_width_3022}"
                    local ret_truncate_text748_v0__111_39="${ret_truncate_text748_v0}"
                    local truncated_3032="${ret_truncate_text748_v0__111_39}"
                    result_3021+="${truncated_3032}"
                    get_visible_len__747_v0 "${truncated_3032}"
                    local ret_get_visible_len747_v0__113_40="${ret_get_visible_len747_v0}"
                    remaining_width_3022="$(( remaining_width_3022 - ret_get_visible_len747_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi749_v0="${result_3021}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__750_v0() {
    local text_2997="${1}"
    local max_width_2998="${2}"
    get_visible_len__747_v0 "${text_2997}"
    local visible_len_3009="${ret_get_visible_len747_v0}"
    if [ "$(( visible_len_3009 <= max_width_2998 ))" != 0 ]; then
        ret_cutoff_text750_v0="${text_2997}"
        return 0
    fi
    truncate_ansi__749_v0 "${text_2997}" "$(( max_width_2998 - 3 ))"
    local ret_truncate_ansi749_v0__129_12="${ret_truncate_ansi749_v0}"
    ret_cutoff_text750_v0="${ret_truncate_ansi749_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__771_v0() {
    local format_3047="${1}"
    local args_3048=("${!2}")
    args_3048=("${format_3047}" "${args_3048[@]}")
    __status=$?
    printf "${args_3048[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__772_v0() {
    local message_3045="${1}"
    local color_3046="${2}"
    # Prints an error message with a specified color.
    local array_129=("${message_3045}")
    eprintf__771_v0 "\\x1b[${color_3046}m%s\\x1b[0m" array_129[@]
}

# colored(message: Text, color: Int)
colored__773_v0() {
    local message_2982="${1}"
    local color_2983="${2}"
    # Returns a text wrapped in color codes.
    ret_colored773_v0="\\x1b[${color_2983}m""${message_2982}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__777_v0() {
    local items_3039=("${!1}")
    local total_len_3040="${2}"
    local term_width_3041="${3}"
    local separator_3042=" • "
    local separator_len_3043=3
    # Fast path: no truncation needed
    if [ "$(( total_len_3040 <= term_width_3041 ))" != 0 ]; then
        local iter_3044=0
        while :
        do
            local __length_130=("${items_3039[@]}")
            if [ "$(( iter_3044 >= ${#__length_130[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_3044 > 0 ))" != 0 ]; then
                eprintf_colored__772_v0 "${separator_3042}" 90
            fi
            colored__773_v0 "${items_3039[$(( iter_3044 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored773_v0__23_41="${ret_colored773_v0}"
            local array_131=("")
            eprintf__771_v0 "${items_3039[${iter_3044}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored773_v0__23_41}" array_131[@]
            iter_3044="$(( iter_3044 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_3049=0
        local first_3050=1
        local iter_3051=0
        while :
        do
            local __length_132=("${items_3039[@]}")
            if [ "$(( iter_3051 >= ${#__length_132[@]} ))" != 0 ]; then
                break
            fi
            local key_3052="${items_3039[${iter_3051}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_3053="${items_3039[$(( iter_3051 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_133="${key_3052}"
            local __length_134="${action_3053}"
            local part_len_3054="$(( $(( ${#__length_133} + 1 )) + ${#__length_134} ))"
            local needed_3055="${part_len_3054}"
            if [ "$(( ! first_3050 ))" != 0 ]; then
                needed_3055="$(( needed_3055 + separator_len_3043 ))"
            fi
            if [ "$(( $(( current_len_3049 + needed_3055 )) > term_width_3041 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_3050 ))" != 0 ]; then
                eprintf_colored__772_v0 "${separator_3042}" 90
            fi
            colored__773_v0 "${action_3053}" 2
            local ret_colored773_v0__51_33="${ret_colored773_v0}"
            local array_135=("")
            eprintf__771_v0 "${key_3052}"" ""${ret_colored773_v0__51_33}" array_135[@]
            current_len_3049="$(( current_len_3049 + needed_3055 ))"
            first_3050=0
            iter_3051="$(( iter_3051 + 2 ))"
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
_got_term_size_33=0
_term_size_34=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__817_v0() {
    local size_2961="${1}"
    if [ "$([ "_${size_2961}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size817_v0=0
        return 0
    fi
    split__4_v0 "${size_2961}" " "
    local parts_2962=("${ret_split4_v0[@]}")
    local __length_137=("${parts_2962[@]}")
    if [ "$(( ${#__length_137[@]} != 2 ))" != 0 ]; then
        ret_store_term_size817_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2962[1]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2962[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_34=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size817_v0=1
    return 0
}

# query_term_size()
query_term_size__818_v0() {
    local command_139
    command_139="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2964="${command_139}"
    store_term_size__817_v0 "${size_2964}"
    ret_query_term_size818_v0="${ret_store_term_size817_v0}"
    return 0
}

# stty_term_size()
stty_term_size__819_v0() {
    local command_140
    command_140="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2960="${command_140}"
    store_term_size__817_v0 "${size_2960}"
    ret_stty_term_size819_v0="${ret_store_term_size817_v0}"
    return 0
}

# get_term_size()
get_term_size__820_v0() {
    stty_term_size__819_v0 
    local detected_2963="${ret_stty_term_size819_v0}"
    if [ "$(( ! detected_2963 ))" != 0 ]; then
        query_term_size__818_v0 
        detected_2963="${ret_query_term_size818_v0}"
    fi
    _got_term_size_33=1
}

# term_width()
term_width__822_v0() {
    if [ "$(( ! _got_term_size_33 ))" != 0 ]; then
        get_term_size__820_v0 
    fi
    ret_term_width822_v0="${_term_size_34[0]?"Index out of bounds (at src/./input/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__836_v0() {
    local pending_2979="${1}"
    local line_2980="${2}"
    local note_at_2981="${3}"
    if [ "$(( note_at_2981 < 0 ))" != 0 ]; then
        local array_141=()
        printf__128_v0 "${pending_2979}""${line_2980}""
" array_141[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_2981 == 0 ))" != 0 ]; then
        colored__773_v0 "${line_2980}" 90
        local ret_colored773_v0__12_40="${ret_colored773_v0}"
        local array_142=()
        printf__128_v0 "${pending_2979}""${ret_colored773_v0__12_40}""
" array_142[@]
    else
        slice__24_v0 "${line_2980}" 0 "${note_at_2981}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_2980}" "${note_at_2981}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__773_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored773_v0__13_58="${ret_colored773_v0}"
        local array_143=()
        printf__128_v0 "${pending_2979}""${ret_slice24_v0__13_32}""${ret_colored773_v0__13_58}""
" array_143[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__837_v0() {
    local names_2952=("${!1}")
    local texts_2953=("${!2}")
    local notes_2954=("${!3}")
    local min_name_width_2955="${4}"
    local __length_144=("${names_2952[@]}")
    local count_2956="${#__length_144[@]}"
    local name_width_2957="${min_name_width_2955}"
    local __range_start_2958=0
    local __range_end_2958="${count_2956}"
    local __dir_2958=$(( ${__range_start_2958} <= ${__range_end_2958} ? 1 : -1 ))
    for (( i_2958=${__range_start_2958}; i_2958 * ${__dir_2958} < ${__range_end_2958} * ${__dir_2958}; i_2958+=${__dir_2958} )); do
        local __length_145="${names_2952[${i_2958}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:28:33)"}"
        local width_2959="${#__length_145}"
        if [ "$(( width_2959 > name_width_2957 ))" != 0 ]; then
            name_width_2957="${width_2959}"
        fi
done
    term_width__822_v0 
    local width_2965="${ret_term_width822_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2966="$(( name_width_2957 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2967="$(( $(( width_2965 - indent_2966 )) < 24 ))"
    if [ "${stacked_2967}" != 0 ]; then
        indent_2966=6
    fi
    local avail_2968="$(( width_2965 - indent_2966 ))"
    rpad__28_v0 "" " " "${indent_2966}"
    local blank_2969="${ret_rpad28_v0}"
    local __range_start_2970=0
    local __range_end_2970="${count_2956}"
    local __dir_2970=$(( ${__range_start_2970} <= ${__range_end_2970} ? 1 : -1 ))
    for (( i_2970=${__range_start_2970}; i_2970 * ${__dir_2970} < ${__range_end_2970} * ${__dir_2970}; i_2970+=${__dir_2970} )); do
        local pending_2971="${blank_2969}"
        if [ "${stacked_2967}" != 0 ]; then
            local array_146=()
            printf__128_v0 "  ""${names_2952[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:48:33)"}""
" array_146[@]
        else
            rpad__28_v0 "  ""${names_2952[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:50:41)"}" " " "${indent_2966}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_2971="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_2953[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_2972=("${ret_split4_v0__52_21[@]}")
        local __length_147=("${words_2972[@]}")
        local note_start_2973="${#__length_147[@]}"
        if [ "$([ "_${notes_2954[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_148="${notes_2954[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_148} > avail_2968 ))" != 0 ]; then
                split__4_v0 "${notes_2954[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_2972+=("${ret_split4_v0__58_26[@]}")
            else
                local array_149=("${notes_2954[${i_2970}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:60:33)"}")
                words_2972+=("${array_149[@]}")
            fi
        fi
        local line_2974=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2975=-1
        local __range_start_2976=0
        local __length_150=("${words_2972[@]}")
        local __range_end_2976="${#__length_150[@]}"
        local __dir_2976=$(( ${__range_start_2976} <= ${__range_end_2976} ? 1 : -1 ))
        for (( j_2976=${__range_start_2976}; j_2976 * ${__dir_2976} < ${__range_end_2976} * ${__dir_2976}; j_2976+=${__dir_2976} )); do
            local word_2977="${words_2972[${j_2976}]?"Index out of bounds (at src/./input/../utils/widget/help.ab:70:32)"}"
            local candidate_2978
            candidate_2978="$(if [ "$([ "_${line_2974}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2977}"; else echo "${line_2974}"" ""${word_2977}"; fi)"
            local __length_151="${candidate_2978}"
            if [ "$(( $(( ${#__length_151} > avail_2968 )) && $([ "_${line_2974}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__836_v0 "${pending_2971}" "${line_2974}" "${note_at_2975}"
                pending_2971="${blank_2969}"
                line_2974="${word_2977}"
                note_at_2975="$(if [ "$(( j_2976 >= note_start_2973 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2976 >= note_start_2973 )) && $(( note_at_2975 < 0 )) ))" != 0 ]; then
                    local __length_152="${candidate_2978}"
                    local __length_153="${word_2977}"
                    note_at_2975="$(( ${#__length_152} - ${#__length_153} ))"
                fi
                line_2974="${candidate_2978}"
            fi
done
        print_help_line__836_v0 "${pending_2971}" "${line_2974}" "${note_at_2975}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__889_v0() {
    local prompt_2990="${1}"
    local placeholder_2991="${2}"
    local header_2992="${3}"
    local password_2993="${4}"
    stty_lock__658_v0 
    term_width__665_v0 
    local term_width_2996="${ret_term_width665_v0}"
    if [ "$([ "_${header_2992}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__750_v0 "${header_2992}" "${term_width_2996}"
        local ret_cutoff_text750_v0__25_17="${ret_cutoff_text750_v0}"
        local array_154=("")
        eprintf__618_v0 "${ret_cutoff_text750_v0__25_17}""
" array_154[@]
    fi
    new_line__671_v0 2
    # "enter submit" = 12
    local array_155=("enter" "submit")
    render_tooltip__777_v0 array_155[@] 12 "${term_width_2996}"
    go_up__672_v0 2
    local array_156=("")
    eprintf__618_v0 "\\x1b[G" array_156[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_157
    command_157="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_3057="${command_157}"
    local char_3058=""
    local array_158=("")
    eprintf__618_v0 "${prompt_2990}" array_158[@]
    if [ "$([ "_${can_preset_3057}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__619_v0 "${placeholder_2991}" 90
        get_char__615_v0 
        char_3058="${ret_get_char615_v0}"
        local __length_159="${placeholder_2991}"
        remove__667_v0 "$(( ${#__length_159} + 1 ))"
    fi
    local __length_160="${prompt_2990}"
    remove__667_v0 "${#__length_160}"
    local text_3063=""
    if [ "$(( ! password_2993 ))" != 0 ]; then
        stty_unlock__659_v0 
        local command_161
        command_161="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_3058}" -p "${prompt_2990}" text < /dev/tty; else read -e -p "${prompt_2990}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3063="${command_161}"
    else
        stty_unlock__659_v0 
        local command_162
        command_162="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_3058}" -p "${prompt_2990}" text < /dev/tty; else read -es -p "${prompt_2990}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_3063="${command_162}"
    fi
    stty_lock__658_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__747_v0 "${prompt_2990}""${text_3063}"
    local input_display_len_3065="${ret_get_visible_len747_v0}"
    math_ceil__607_v0 "$(( input_display_len_3065 / term_width_2996 ))"
    local input_lines_3068="${ret_math_ceil607_v0}"
    if [ "$(( input_lines_3068 < 3 ))" != 0 ]; then
        go_down__673_v0 "$(( 2 - input_lines_3068 ))"
        remove_line__668_v0 2
        remove_current_line__669_v0 
    fi
    if [ "$(( input_lines_3068 >= 3 ))" != 0 ]; then
        remove_line__668_v0 "${input_lines_3068}"
    fi
    if [ "$([ "_${header_2992}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__668_v0 1
        remove_current_line__669_v0 
    fi
    stty_unlock__659_v0 
    ret_xyl_input889_v0="${text_3063}"
    return 0
}

# print_input_help()
print_input_help__983_v0() {
    local usage_2910=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__677_v0 usage_2910[@]
    printf '%s\n' ""
    colored_primary__719_v0 "input"
    local ret_colored_primary719_v0__8_20="${ret_colored_primary719_v0}"
    local title_2947=("${ret_colored_primary719_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__677_v0 title_2947[@]
    printf '%s\n' ""
    colored_secondary__720_v0 "Flags:"
    local ret_colored_secondary720_v0__11_12="${ret_colored_secondary720_v0}"
    local array_165=()
    printf__128_v0 "${ret_colored_secondary720_v0__11_12}""
" array_165[@]
    local names_2949=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2950=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2951=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__837_v0 names_2949[@] texts_2950[@] notes_2951[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__1035_v0() {
    local parameters_2904=("${!1}")
    local prompt_2905="> "
    local placeholder_2906="Type here..."
    local header_2907=""
    local password_2908=0
    for param_2909 in "${parameters_2904[@]}"; do
        if [ "$(( $([ "_${param_2909}" != "_-h" ]; echo $?) || $([ "_${param_2909}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__983_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2909}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_171="--prompt="
            slice__24_v0 "${param_2909}" "${#__length_171}" 0
            prompt_2905="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2909}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_172="--placeholder="
            slice__24_v0 "${param_2909}" "${#__length_172}" 0
            placeholder_2906="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2909}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_173="--header="
            slice__24_v0 "${param_2909}" "${#__length_173}" 0
            header_2907="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2909}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2908=1
        fi
    done
    has_ansi_escape__743_v0 "${header_2907}"
    local ret_has_ansi_escape743_v0__31_44="${ret_has_ansi_escape743_v0}"
    escape_ansi__744_v0 "${header_2907}"
    local ret_escape_ansi744_v0__31_73="${ret_escape_ansi744_v0}"
    colored_primary__719_v0 "${header_2907}"
    local ret_colored_primary719_v0__31_111="${ret_colored_primary719_v0}"
    local display_header_2989
    display_header_2989="$(if [ "$(( $([ "_${header_2907}" != "_" ]; echo $?) || ret_has_ansi_escape743_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi744_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary719_v0__31_111}"; fi)"
    xyl_input__889_v0 "${prompt_2905}" "${placeholder_2906}" "${display_header_2989}" "${password_2908}"
    ret_execute_input1035_v0="${ret_xyl_input889_v0}"
    return 0
}

# get_key()
get_key__1116_v0() {
    local command_174
    command_174="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16638="${command_174}"
    if [ "$([ "_${var_16638}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1116_v0="UP"
        return 0
    elif [ "$([ "_${var_16638}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1116_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16638}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1116_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16638}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1116_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16638}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1116_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16638}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1116_v0="INPUT"
        return 0
    else
        ret_get_key1116_v0="${var_16638}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1118_v0() {
    local format_16529="${1}"
    local args_16530=("${!2}")
    args_16530=("${format_16529}" "${args_16530[@]}")
    __status=$?
    printf "${args_16530[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1119_v0() {
    local message_16527="${1}"
    local color_16528="${2}"
    # Prints an error message with a specified color.
    local array_175=("${message_16527}")
    eprintf__1118_v0 "\\x1b[${color_16528}m%s\\x1b[0m" array_175[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1134_v0() {
    local format_16550="${1}"
    local args_16551=("${!2}")
    args_16551=("${format_16550}" "${args_16551[@]}")
    __status=$?
    printf "${args_16551[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_38="None"
# perl_available()
perl_available__1141_v0() {
    if [ "$([ "_${_perl_state_38}" != "_None" ]; echo $?)" != 0 ]; then
        local command_176
        command_176="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16482
        disabled_16482="$([ "_${command_176}" != "_No" ]; echo $?)"
        local command_177
        command_177="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16483
        found_16483="$(( $(( ! disabled_16482 )) && $([ "_${command_177}" != "_0" ]; echo $?) ))"
        _perl_state_38="$(if [ "${found_16483}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1141_v0="$([ "_${_perl_state_38}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1142_v0() {
    local text_16481="${1}"
    perl_available__1141_v0 
    local ret_perl_available1141_v0__22_12="${ret_perl_available1141_v0}"
    if [ "$(( ! ret_perl_available1141_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1142_v0=''
        return 1
    fi
    local command_178
    command_178="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16481}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1142_v0=''
        return "${__status}"
    fi
    local width_str_16484="${command_178}"
    parse_int__13_v0 "${width_str_16484}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1142_v0=''
        return "${__status}"
    fi
    local width_16485="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1142_v0="${width_16485}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1147_v0() {
    local text_16474="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_179
    command_179="$([[ "${text_16474}" == *$'\x1b'* || "${text_16474}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16475="${command_179}"
    ret_has_ansi_escape1147_v0="$([ "_${has_escape_16475}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1149_v0() {
    local text_16477="${1}"
    local command_180
    command_180="$(printf "%s" "${text_16477}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1149_v0="${command_180}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1150_v0() {
    local text_16479="${1}"
    local command_181
    command_181="$(printf "%s" "${text_16479}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16480="${command_181}"
    ret_is_all_ascii1150_v0="$([ "_${result_16480}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1151_v0() {
    local text_16476="${1}"
    strip_ansi__1149_v0 "${text_16476}"
    local stripped_16478="${ret_strip_ansi1149_v0}"
    # Check if text is all ASCII
    is_all_ascii__1150_v0 "${stripped_16478}"
    local ret_is_all_ascii1150_v0__36_12="${ret_is_all_ascii1150_v0}"
    if [ "$(( ! ret_is_all_ascii1150_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1142_v0 "${stripped_16478}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_182="${stripped_16478}"
            ret_get_visible_len1151_v0="${#__length_182}"
            return 0
        fi
        ret_get_visible_len1151_v0="${ret_perl_get_cjk_width1142_v0}"
        return 0
    else
        local __length_183="${stripped_16478}"
        ret_get_visible_len1151_v0="${#__length_183}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_39=0
_term_size_40=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1157_v0() {
    local command_185
    command_185="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_16548="${command_185}"
    parse_int__13_v0 "${count_16548}"
    __status=$?
    ret_stty_count1157_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1158_v0() {
    stty_count__1157_v0 
    local count_num_16549="${ret_stty_count1157_v0}"
    if [ "$(( count_num_16549 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16549="$(( count_num_16549 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16549}
    __status=$?
}

# stty_unlock()
stty_unlock__1159_v0() {
    stty_count__1157_v0 
    local count_num_16660="${ret_stty_count1157_v0}"
    if [ "$(( count_num_16660 > 0 ))" != 0 ]; then
        count_num_16660="$(( count_num_16660 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16660}
        __status=$?
        if [ "$(( count_num_16660 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1160_v0() {
    local size_16465="${1}"
    if [ "$([ "_${size_16465}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1160_v0=0
        return 0
    fi
    split__4_v0 "${size_16465}" " "
    local parts_16466=("${ret_split4_v0[@]}")
    local __length_186=("${parts_16466[@]}")
    if [ "$(( ${#__length_186[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1160_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16466[1]?"Index out of bounds (at src/./choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16466[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_40=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1160_v0=1
    return 0
}

# query_term_size()
query_term_size__1161_v0() {
    local command_188
    command_188="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16468="${command_188}"
    store_term_size__1160_v0 "${size_16468}"
    ret_query_term_size1161_v0="${ret_store_term_size1160_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1162_v0() {
    local command_189
    command_189="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16464="${command_189}"
    store_term_size__1160_v0 "${size_16464}"
    ret_stty_term_size1162_v0="${ret_store_term_size1160_v0}"
    return 0
}

# get_term_size()
get_term_size__1163_v0() {
    stty_term_size__1162_v0 
    local detected_16467="${ret_stty_term_size1162_v0}"
    if [ "$(( ! detected_16467 ))" != 0 ]; then
        query_term_size__1161_v0 
        detected_16467="${ret_query_term_size1161_v0}"
    fi
    _got_term_size_39=1
}

# term_width()
term_width__1165_v0() {
    if [ "$(( ! _got_term_size_39 ))" != 0 ]; then
        get_term_size__1163_v0 
    fi
    ret_term_width1165_v0="${_term_size_40[0]?"Index out of bounds (at src/./choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__1166_v0() {
    if [ "$(( ! _got_term_size_39 ))" != 0 ]; then
        get_term_size__1163_v0 
    fi
    ret_term_height1166_v0="${_term_size_40[1]?"Index out of bounds (at src/./choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1168_v0() {
    local cnt_16635="${1}"
    if [ "$(( cnt_16635 > 0 ))" != 0 ]; then
        local sequence_16636=""
        local __range_start_16637=0
        local __range_end_16637="${cnt_16635}"
        local __dir_16637=$(( ${__range_start_16637} <= ${__range_end_16637} ? 1 : -1 ))
        for (( ____16637=${__range_start_16637}; ____16637 * ${__dir_16637} < ${__range_end_16637} * ${__dir_16637}; ____16637+=${__dir_16637} )); do
            sequence_16636+="\\x1b[2K\\x1b[1A"
done
        local array_190=("")
        eprintf__1134_v0 "${sequence_16636}" array_190[@]
    fi
    local array_191=("")
    eprintf__1134_v0 "\\x1b[G" array_191[@]
}

# remove_current_line()
remove_current_line__1169_v0() {
    local array_192=("")
    eprintf__1134_v0 "\\x1b[2K\\x1b[G" array_192[@]
}

# print_blank(cnt: Int)
print_blank__1170_v0() {
    local cnt_16626="${1}"
    printf '%*s' "${cnt_16626}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1171_v0() {
    local cnt_16591="${1}"
    local __range_start_16592=0
    local __range_end_16592="${cnt_16591}"
    local __dir_16592=$(( ${__range_start_16592} <= ${__range_end_16592} ? 1 : -1 ))
    for (( ____16592=${__range_start_16592}; ____16592 * ${__dir_16592} < ${__range_end_16592} * ${__dir_16592}; ____16592+=${__dir_16592} )); do
        local array_193=("")
        eprintf__1134_v0 "
" array_193[@]
done
}

# go_up(cnt: Int)
go_up__1172_v0() {
    local cnt_16610="${1}"
    local array_194=("")
    eprintf__1134_v0 "\\x1b[${cnt_16610}A" array_194[@]
}

# go_down(cnt: Int)
go_down__1173_v0() {
    local cnt_16647="${1}"
    local array_195=("")
    eprintf__1134_v0 "\\x1b[${cnt_16647}B" array_195[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1174_v0() {
    local cnt_16656="${1}"
    if [ "$(( cnt_16656 > 0 ))" != 0 ]; then
        go_down__1173_v0 "${cnt_16656}"
    else
        go_up__1172_v0 "$(( - cnt_16656 ))"
    fi
}

# hide_cursor()
hide_cursor__1175_v0() {
    local array_196=("")
    eprintf__1134_v0 "\\x1b[?25l" array_196[@]
}

# show_cursor()
show_cursor__1176_v0() {
    local array_197=("")
    eprintf__1134_v0 "\\x1b[?25h" array_197[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1177_v0() {
    local pieces_16463=("${!1}")
    term_width__1165_v0 
    local width_16469="${ret_term_width1165_v0}"
    local line_16470=""
    local line_len_16471=0
    for piece_16472 in "${pieces_16463[@]}"; do
        local __length_200="${piece_16472}"
        local piece_len_16473="${#__length_200}"
        has_ansi_escape__1147_v0 "${piece_16472}"
        local ret_has_ansi_escape1147_v0__186_12="${ret_has_ansi_escape1147_v0}"
        if [ "${ret_has_ansi_escape1147_v0__186_12}" != 0 ]; then
            get_visible_len__1151_v0 "${piece_16472}"
            piece_len_16473="${ret_get_visible_len1151_v0}"
        fi
        if [ "$([ "_${line_16470}" != "_" ]; echo $?)" != 0 ]; then
            line_16470="${piece_16472}"
            line_len_16471="${piece_len_16473}"
        elif [ "$(( $(( $(( line_len_16471 + 1 )) + piece_len_16473 )) > width_16469 ))" != 0 ]; then
            local array_201=()
            printf__128_v0 "${line_16470}""
" array_201[@]
            line_16470="${piece_16472}"
            line_len_16471="${piece_len_16473}"
        else
            line_16470+=" ""${piece_16472}"
            line_len_16471="$(( line_len_16471 + $(( 1 + piece_len_16473 )) ))"
        fi
    done
    if [ "$([ "_${line_16470}" == "_" ]; echo $?)" != 0 ]; then
        local array_202=()
        printf__128_v0 "${line_16470}""
" array_202[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_43="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_44=0
_primary_color_45=(3 207 159 92)
_secondary_color_46=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1214_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_16453="${ret_env_var_get120_v0}"
    _supports_truecolor_43="$(if [ "$([ "_${config_16453}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1214_v0="$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1215_v0() {
    local message_16448="${1}"
    local r_16449="${2}"
    local g_16450="${3}"
    local b_16451="${4}"
    local fallback_16452="${5}"
    if [ "$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1215_v0="\\x1b[38;2;${r_16449};${g_16450};${b_16451}m""${message_16448}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_43}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1214_v0 
        local ret_get_supports_truecolor1214_v0__45_17="${ret_get_supports_truecolor1214_v0}"
        if [ "${ret_get_supports_truecolor1214_v0__45_17}" != 0 ]; then
            ret_colored_rgb1215_v0="\\x1b[38;2;${r_16449};${g_16450};${b_16451}m""${message_16448}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16452 == 0 ))" != 0 ]; then
            ret_colored_rgb1215_v0="${message_16448}"
            return 0
        else
            ret_colored_rgb1215_v0="\\x1b[${fallback_16452}m""${message_16448}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16452 == 0 ))" != 0 ]; then
            ret_colored_rgb1215_v0="${message_16448}"
            return 0
        fi
        ret_colored_rgb1215_v0="\\x1b[${fallback_16452}m""${message_16448}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1217_v0() {
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16442="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16442}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16442}" ";"
            local parts_16443=("${ret_split4_v0[@]}")
            local __length_206=("${parts_16443[@]}")
            if [ "$(( ${#__length_206[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16443[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16443[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16443[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16443[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_45=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16444="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16444}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16444}" ";"
            local parts_16445=("${ret_split4_v0[@]}")
            local __length_208=("${parts_16445[@]}")
            if [ "$(( ${#__length_208[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16445[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16445[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16445[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16445[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_46=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16446="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16446}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16446}" ";"
            local parts_16447=("${ret_split4_v0[@]}")
            local __length_210=("${parts_16447[@]}")
            if [ "$(( ${#__length_210[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16447[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16447[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16447[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16447[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1217_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_44=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1218_v0() {
    inner_get_xylitol_colors__1217_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_44=1
}

# colored_primary(message: Text)
colored_primary__1219_v0() {
    local message_16441="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1218_v0 
    fi
    colored_rgb__1215_v0 "${message_16441}" "${_primary_color_45[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_45[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_45[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_45[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1219_v0="${ret_colored_rgb1215_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1220_v0() {
    local message_16487="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1218_v0 
    fi
    colored_rgb__1215_v0 "${message_16487}" "${_secondary_color_46[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_46[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_46[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_46[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1220_v0="${ret_colored_rgb1215_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_48="None"
# perl_available()
perl_available__1237_v0() {
    if [ "$([ "_${_perl_state_48}" != "_None" ]; echo $?)" != 0 ]; then
        local command_212
        command_212="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16562
        disabled_16562="$([ "_${command_212}" != "_No" ]; echo $?)"
        local command_213
        command_213="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16563
        found_16563="$(( $(( ! disabled_16562 )) && $([ "_${command_213}" != "_0" ]; echo $?) ))"
        _perl_state_48="$(if [ "${found_16563}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1237_v0="$([ "_${_perl_state_48}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1238_v0() {
    local text_16561="${1}"
    perl_available__1237_v0 
    local ret_perl_available1237_v0__22_12="${ret_perl_available1237_v0}"
    if [ "$(( ! ret_perl_available1237_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1238_v0=''
        return 1
    fi
    local command_214
    command_214="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16561}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1238_v0=''
        return "${__status}"
    fi
    local width_str_16564="${command_214}"
    parse_int__13_v0 "${width_str_16564}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1238_v0=''
        return "${__status}"
    fi
    local width_16565="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1238_v0="${width_16565}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1239_v0() {
    local text_16572="${1}"
    local max_width_16573="${2}"
    perl_available__1237_v0 
    local ret_perl_available1237_v0__33_12="${ret_perl_available1237_v0}"
    if [ "$(( ! ret_perl_available1237_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1239_v0=''
        return 1
    fi
    local command_215
    command_215="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16572}" ${max_width_16573} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1239_v0=''
        return "${__status}"
    fi
    local result_16574="${command_215}"
    ret_perl_truncate_cjk1239_v0="${result_16574}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1243_v0() {
    local text_16532="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_216
    command_216="$([[ "${text_16532}" == *$'\x1b'* || "${text_16532}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16533="${command_216}"
    ret_has_ansi_escape1243_v0="$([ "_${has_escape_16533}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1244_v0() {
    local text_16534="${1}"
    local command_217
    command_217="$(printf '%s' "${text_16534}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1244_v0="${command_217}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1245_v0() {
    local text_16557="${1}"
    local command_218
    command_218="$(printf "%s" "${text_16557}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1245_v0="${command_218}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1246_v0() {
    local text_16559="${1}"
    local command_219
    command_219="$(printf "%s" "${text_16559}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16560="${command_219}"
    ret_is_all_ascii1246_v0="$([ "_${result_16560}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1247_v0() {
    local text_16556="${1}"
    strip_ansi__1245_v0 "${text_16556}"
    local stripped_16558="${ret_strip_ansi1245_v0}"
    # Check if text is all ASCII
    is_all_ascii__1246_v0 "${stripped_16558}"
    local ret_is_all_ascii1246_v0__36_12="${ret_is_all_ascii1246_v0}"
    if [ "$(( ! ret_is_all_ascii1246_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1238_v0 "${stripped_16558}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_220="${stripped_16558}"
            ret_get_visible_len1247_v0="${#__length_220}"
            return 0
        fi
        ret_get_visible_len1247_v0="${ret_perl_get_cjk_width1238_v0}"
        return 0
    else
        local __length_221="${stripped_16558}"
        ret_get_visible_len1247_v0="${#__length_221}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1248_v0() {
    local text_16569="${1}"
    local max_width_16570="${2}"
    get_visible_len__1247_v0 "${text_16569}"
    local visible_len_16571="${ret_get_visible_len1247_v0}"
    if [ "$(( visible_len_16571 <= max_width_16570 ))" != 0 ]; then
        ret_truncate_text1248_v0="${text_16569}"
        return 0
    fi
    is_all_ascii__1246_v0 "${text_16569}"
    local ret_is_all_ascii1246_v0__53_12="${ret_is_all_ascii1246_v0}"
    if [ "$(( ! ret_is_all_ascii1246_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1239_v0 "${text_16569}" "${max_width_16570}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16569}" | cut -c1-${max_width_16570}
            __status=$?
        fi
        ret_truncate_text1248_v0="${ret_perl_truncate_cjk1239_v0}"
        return 0
    fi
    local command_222
    command_222="$(printf "%s" "${text_16569}" | cut -c1-${max_width_16570})"
    __status=$?
    ret_truncate_text1248_v0="${command_222}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1249_v0() {
    local text_16567="${1}"
    local max_width_16568="${2}"
    has_ansi_escape__1243_v0 "${text_16567}"
    local ret_has_ansi_escape1243_v0__65_12="${ret_has_ansi_escape1243_v0}"
    if [ "$(( ! ret_has_ansi_escape1243_v0__65_12 ))" != 0 ]; then
        truncate_text__1248_v0 "${text_16567}" "${max_width_16568}"
        ret_truncate_ansi1249_v0="${ret_truncate_text1248_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_223
    command_223="$([[ "${text_16567}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16575="${command_223}"
    # Replace \x1b[ with newline, then split
    local command_224
    command_224="$(t="${text_16567}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16576="${command_224}"
    split__4_v0 "${replaced_16576}" "
"
    local parts_16577=("${ret_split4_v0[@]}")
    local result_16578=""
    local remaining_width_16579="${max_width_16568}"
    local __range_start_16580=0
    local __length_225=("${parts_16577[@]}")
    local __range_end_16580="${#__length_225[@]}"
    local __dir_16580=$(( ${__range_start_16580} <= ${__range_end_16580} ? 1 : -1 ))
    for (( idx_16580=${__range_start_16580}; idx_16580 * ${__dir_16580} < ${__range_end_16580} * ${__dir_16580}; idx_16580+=${__dir_16580} )); do
        local part_16581="${parts_16577[${idx_16580}]?"Index out of bounds (at src/./choose/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16580 == 0 )) && $([ "_${starts_with_ansi_16575}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16581}" == "_" ]; echo $?) && $(( remaining_width_16579 > 0 )) ))" != 0 ]; then
                truncate_text__1248_v0 "${part_16581}" "${remaining_width_16579}"
                local ret_truncate_text1248_v0__87_35="${ret_truncate_text1248_v0}"
                local truncated_16582="${ret_truncate_text1248_v0__87_35}"
                result_16578+="${truncated_16582}"
                get_visible_len__1247_v0 "${truncated_16582}"
                local ret_get_visible_len1247_v0__89_36="${ret_get_visible_len1247_v0}"
                remaining_width_16579="$(( remaining_width_16579 - ret_get_visible_len1247_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_226
            command_226="$(__p="${part_16581}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16583="${command_226}"
            if [ "$([ "_${m_idx_16583}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_227
                command_227="$(__p="${part_16581}"; printf "%s" "${__p:0:${m_idx_16583}}")"
                __status=$?
                local ansi_params_16584="${command_227}"
                result_16578+="\\x1b[""${ansi_params_16584}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16583}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_16585="${ret_parse_int13_v0__100_41}"
                local text_start_16586="$(( m_idx_num_16585 + 1 ))"
                local command_228
                command_228="$(__p="${part_16581}"; printf "%s" "${__p:${text_start_16586}}")"
                __status=$?
                local text_part_16587="${command_228}"
                if [ "$(( $([ "_${text_part_16587}" == "_" ]; echo $?) && $(( remaining_width_16579 > 0 )) ))" != 0 ]; then
                    truncate_text__1248_v0 "${text_part_16587}" "${remaining_width_16579}"
                    local ret_truncate_text1248_v0__104_39="${ret_truncate_text1248_v0}"
                    local truncated_16588="${ret_truncate_text1248_v0__104_39}"
                    result_16578+="${truncated_16588}"
                    get_visible_len__1247_v0 "${truncated_16588}"
                    local ret_get_visible_len1247_v0__106_40="${ret_get_visible_len1247_v0}"
                    remaining_width_16579="$(( remaining_width_16579 - ret_get_visible_len1247_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16581}" == "_" ]; echo $?) && $(( remaining_width_16579 > 0 )) ))" != 0 ]; then
                    truncate_text__1248_v0 "${part_16581}" "${remaining_width_16579}"
                    local ret_truncate_text1248_v0__111_39="${ret_truncate_text1248_v0}"
                    local truncated_16589="${ret_truncate_text1248_v0__111_39}"
                    result_16578+="${truncated_16589}"
                    get_visible_len__1247_v0 "${truncated_16589}"
                    local ret_get_visible_len1247_v0__113_40="${ret_get_visible_len1247_v0}"
                    remaining_width_16579="$(( remaining_width_16579 - ret_get_visible_len1247_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1249_v0="${result_16578}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1250_v0() {
    local text_16554="${1}"
    local max_width_16555="${2}"
    get_visible_len__1247_v0 "${text_16554}"
    local visible_len_16566="${ret_get_visible_len1247_v0}"
    if [ "$(( visible_len_16566 <= max_width_16555 ))" != 0 ]; then
        ret_cutoff_text1250_v0="${text_16554}"
        return 0
    fi
    truncate_ansi__1249_v0 "${text_16554}" "$(( max_width_16555 - 3 ))"
    local ret_truncate_ansi1249_v0__129_12="${ret_truncate_ansi1249_v0}"
    ret_cutoff_text1250_v0="${ret_truncate_ansi1249_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__1271_v0() {
    local format_16601="${1}"
    local args_16602=("${!2}")
    args_16602=("${format_16601}" "${args_16602[@]}")
    __status=$?
    printf "${args_16602[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1272_v0() {
    local message_16599="${1}"
    local color_16600="${2}"
    # Prints an error message with a specified color.
    local array_229=("${message_16599}")
    eprintf__1271_v0 "\\x1b[${color_16600}m%s\\x1b[0m" array_229[@]
}

# colored(message: Text, color: Int)
colored__1273_v0() {
    local message_16521="${1}"
    local color_16522="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1273_v0="\\x1b[${color_16522}m""${message_16521}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1277_v0() {
    local items_16593=("${!1}")
    local total_len_16594="${2}"
    local term_width_16595="${3}"
    local separator_16596=" • "
    local separator_len_16597=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16594 <= term_width_16595 ))" != 0 ]; then
        local iter_16598=0
        while :
        do
            local __length_230=("${items_16593[@]}")
            if [ "$(( iter_16598 >= ${#__length_230[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16598 > 0 ))" != 0 ]; then
                eprintf_colored__1272_v0 "${separator_16596}" 90
            fi
            colored__1273_v0 "${items_16593[$(( iter_16598 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1273_v0__23_41="${ret_colored1273_v0}"
            local array_231=("")
            eprintf__1271_v0 "${items_16593[${iter_16598}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1273_v0__23_41}" array_231[@]
            iter_16598="$(( iter_16598 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16603=0
        local first_16604=1
        local iter_16605=0
        while :
        do
            local __length_232=("${items_16593[@]}")
            if [ "$(( iter_16605 >= ${#__length_232[@]} ))" != 0 ]; then
                break
            fi
            local key_16606="${items_16593[${iter_16605}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_16607="${items_16593[$(( iter_16605 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_233="${key_16606}"
            local __length_234="${action_16607}"
            local part_len_16608="$(( $(( ${#__length_233} + 1 )) + ${#__length_234} ))"
            local needed_16609="${part_len_16608}"
            if [ "$(( ! first_16604 ))" != 0 ]; then
                needed_16609="$(( needed_16609 + separator_len_16597 ))"
            fi
            if [ "$(( $(( current_len_16603 + needed_16609 )) > term_width_16595 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16604 ))" != 0 ]; then
                eprintf_colored__1272_v0 "${separator_16596}" 90
            fi
            colored__1273_v0 "${action_16607}" 2
            local ret_colored1273_v0__51_33="${ret_colored1273_v0}"
            local array_235=("")
            eprintf__1271_v0 "${key_16606}"" ""${ret_colored1273_v0__51_33}" array_235[@]
            current_len_16603="$(( current_len_16603 + needed_16609 ))"
            first_16604=0
            iter_16605="$(( iter_16605 + 2 ))"
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
_got_term_size_51=0
_term_size_52=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__1317_v0() {
    local size_16500="${1}"
    if [ "$([ "_${size_16500}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1317_v0=0
        return 0
    fi
    split__4_v0 "${size_16500}" " "
    local parts_16501=("${ret_split4_v0[@]}")
    local __length_237=("${parts_16501[@]}")
    if [ "$(( ${#__length_237[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1317_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16501[1]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16501[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_52=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1317_v0=1
    return 0
}

# query_term_size()
query_term_size__1318_v0() {
    local command_239
    command_239="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16503="${command_239}"
    store_term_size__1317_v0 "${size_16503}"
    ret_query_term_size1318_v0="${ret_store_term_size1317_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1319_v0() {
    local command_240
    command_240="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16499="${command_240}"
    store_term_size__1317_v0 "${size_16499}"
    ret_stty_term_size1319_v0="${ret_store_term_size1317_v0}"
    return 0
}

# get_term_size()
get_term_size__1320_v0() {
    stty_term_size__1319_v0 
    local detected_16502="${ret_stty_term_size1319_v0}"
    if [ "$(( ! detected_16502 ))" != 0 ]; then
        query_term_size__1318_v0 
        detected_16502="${ret_query_term_size1318_v0}"
    fi
    _got_term_size_51=1
}

# term_width()
term_width__1322_v0() {
    if [ "$(( ! _got_term_size_51 ))" != 0 ]; then
        get_term_size__1320_v0 
    fi
    ret_term_width1322_v0="${_term_size_52[0]?"Index out of bounds (at src/./choose/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1336_v0() {
    local pending_16518="${1}"
    local line_16519="${2}"
    local note_at_16520="${3}"
    if [ "$(( note_at_16520 < 0 ))" != 0 ]; then
        local array_241=()
        printf__128_v0 "${pending_16518}""${line_16519}""
" array_241[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16520 == 0 ))" != 0 ]; then
        colored__1273_v0 "${line_16519}" 90
        local ret_colored1273_v0__12_40="${ret_colored1273_v0}"
        local array_242=()
        printf__128_v0 "${pending_16518}""${ret_colored1273_v0__12_40}""
" array_242[@]
    else
        slice__24_v0 "${line_16519}" 0 "${note_at_16520}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16519}" "${note_at_16520}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1273_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1273_v0__13_58="${ret_colored1273_v0}"
        local array_243=()
        printf__128_v0 "${pending_16518}""${ret_slice24_v0__13_32}""${ret_colored1273_v0__13_58}""
" array_243[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1337_v0() {
    local names_16491=("${!1}")
    local texts_16492=("${!2}")
    local notes_16493=("${!3}")
    local min_name_width_16494="${4}"
    local __length_244=("${names_16491[@]}")
    local count_16495="${#__length_244[@]}"
    local name_width_16496="${min_name_width_16494}"
    local __range_start_16497=0
    local __range_end_16497="${count_16495}"
    local __dir_16497=$(( ${__range_start_16497} <= ${__range_end_16497} ? 1 : -1 ))
    for (( i_16497=${__range_start_16497}; i_16497 * ${__dir_16497} < ${__range_end_16497} * ${__dir_16497}; i_16497+=${__dir_16497} )); do
        local __length_245="${names_16491[${i_16497}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:28:33)"}"
        local width_16498="${#__length_245}"
        if [ "$(( width_16498 > name_width_16496 ))" != 0 ]; then
            name_width_16496="${width_16498}"
        fi
done
    term_width__1322_v0 
    local width_16504="${ret_term_width1322_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16505="$(( name_width_16496 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16506="$(( $(( width_16504 - indent_16505 )) < 24 ))"
    if [ "${stacked_16506}" != 0 ]; then
        indent_16505=6
    fi
    local avail_16507="$(( width_16504 - indent_16505 ))"
    rpad__28_v0 "" " " "${indent_16505}"
    local blank_16508="${ret_rpad28_v0}"
    local __range_start_16509=0
    local __range_end_16509="${count_16495}"
    local __dir_16509=$(( ${__range_start_16509} <= ${__range_end_16509} ? 1 : -1 ))
    for (( i_16509=${__range_start_16509}; i_16509 * ${__dir_16509} < ${__range_end_16509} * ${__dir_16509}; i_16509+=${__dir_16509} )); do
        local pending_16510="${blank_16508}"
        if [ "${stacked_16506}" != 0 ]; then
            local array_246=()
            printf__128_v0 "  ""${names_16491[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:48:33)"}""
" array_246[@]
        else
            rpad__28_v0 "  ""${names_16491[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:50:41)"}" " " "${indent_16505}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_16510="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_16492[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_16511=("${ret_split4_v0__52_21[@]}")
        local __length_247=("${words_16511[@]}")
        local note_start_16512="${#__length_247[@]}"
        if [ "$([ "_${notes_16493[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_248="${notes_16493[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_248} > avail_16507 ))" != 0 ]; then
                split__4_v0 "${notes_16493[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_16511+=("${ret_split4_v0__58_26[@]}")
            else
                local array_249=("${notes_16493[${i_16509}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:60:33)"}")
                words_16511+=("${array_249[@]}")
            fi
        fi
        local line_16513=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16514=-1
        local __range_start_16515=0
        local __length_250=("${words_16511[@]}")
        local __range_end_16515="${#__length_250[@]}"
        local __dir_16515=$(( ${__range_start_16515} <= ${__range_end_16515} ? 1 : -1 ))
        for (( j_16515=${__range_start_16515}; j_16515 * ${__dir_16515} < ${__range_end_16515} * ${__dir_16515}; j_16515+=${__dir_16515} )); do
            local word_16516="${words_16511[${j_16515}]?"Index out of bounds (at src/./choose/../utils/widget/help.ab:70:32)"}"
            local candidate_16517
            candidate_16517="$(if [ "$([ "_${line_16513}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16516}"; else echo "${line_16513}"" ""${word_16516}"; fi)"
            local __length_251="${candidate_16517}"
            if [ "$(( $(( ${#__length_251} > avail_16507 )) && $([ "_${line_16513}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1336_v0 "${pending_16510}" "${line_16513}" "${note_at_16514}"
                pending_16510="${blank_16508}"
                line_16513="${word_16516}"
                note_at_16514="$(if [ "$(( j_16515 >= note_start_16512 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16515 >= note_start_16512 )) && $(( note_at_16514 < 0 )) ))" != 0 ]; then
                    local __length_252="${candidate_16517}"
                    local __length_253="${word_16516}"
                    note_at_16514="$(( ${#__length_252} - ${#__length_253} ))"
                fi
                line_16513="${candidate_16517}"
            fi
done
        print_help_line__1336_v0 "${pending_16510}" "${line_16513}" "${note_at_16514}"
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
__CHOOSER_CONTINUE_55=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_56=1
# The user confirmed the selection.
__CHOOSER_DONE_57=2
_total_58=0
_page_size_59=10
_display_count_60=0
_total_pages_61=1
_current_page_62=0
_selected_63=0
_cursor_64="> "
_multi_65=0
_limit_66=-1
_term_width_67=80
_has_header_68=0
_page_69=()
_page_count_70=0
_checked_71=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_72=0
_first_render_73=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_74=0
# render_single_page()
render_single_page__1486_v0() {
    local __length_256="${_cursor_64}"
    local cursor_len_16629="${#__length_256}"
    local max_option_width_16630="$(( $(( _term_width_67 - cursor_len_16629 )) - 1 ))"
    local __range_start_16631=0
    local __range_end_16631="${_page_count_70}"
    local __dir_16631=$(( ${__range_start_16631} <= ${__range_end_16631} ? 1 : -1 ))
    for (( i_16631=${__range_start_16631}; i_16631 * ${__dir_16631} < ${__range_end_16631} * ${__dir_16631}; i_16631+=${__dir_16631} )); do
        cutoff_text__1250_v0 "${_page_69[${i_16631}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_16630}"
        local ret_cutoff_text1250_v0__48_27="${ret_cutoff_text1250_v0}"
        local truncated_16632="${ret_cutoff_text1250_v0__48_27}"
        if [ "$(( i_16631 == _selected_63 ))" != 0 ]; then
            colored_secondary__1220_v0 "${_cursor_64}""${truncated_16632}""
"
            local ret_colored_secondary1220_v0__50_21="${ret_colored_secondary1220_v0}"
            local array_257=("")
            eprintf__1118_v0 "${ret_colored_secondary1220_v0__50_21}" array_257[@]
        else
            print_blank__1170_v0 "${cursor_len_16629}"
            local array_258=("")
            eprintf__1118_v0 "${truncated_16632}""
" array_258[@]
        fi
done
    local remaining_slots_16633="$(( _display_count_60 - _page_count_70 ))"
    if [ "$(( remaining_slots_16633 > 0 ))" != 0 ]; then
        local __range_start_16634=0
        local __range_end_16634="${remaining_slots_16633}"
        local __dir_16634=$(( ${__range_start_16634} <= ${__range_end_16634} ? 1 : -1 ))
        for (( ____16634=${__range_start_16634}; ____16634 * ${__dir_16634} < ${__range_end_16634} * ${__dir_16634}; ____16634+=${__dir_16634} )); do
            local array_259=("")
            eprintf__1118_v0 "\\x1b[K
" array_259[@]
done
    fi
}

# render_multi_page()
render_multi_page__1487_v0() {
    local __length_260="${_cursor_64}"
    local cursor_len_16619="${#__length_260}"
    local max_option_width_16620="$(( $(( _term_width_67 - cursor_len_16619 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1492_v0 
    local page_start_16621="${ret_chooser_page_start1492_v0}"
    local __range_start_16622=0
    local __range_end_16622="${_page_count_70}"
    local __dir_16622=$(( ${__range_start_16622} <= ${__range_end_16622} ? 1 : -1 ))
    for (( i_16622=${__range_start_16622}; i_16622 * ${__dir_16622} < ${__range_end_16622} * ${__dir_16622}; i_16622+=${__dir_16622} )); do
        local global_idx_16623="$(( page_start_16621 + i_16622 ))"
        local check_mark_16624
        check_mark_16624="$(if [ "${_checked_71[${global_idx_16623}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1250_v0 "${_page_69[${i_16622}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_16620}"
        local ret_cutoff_text1250_v0__71_27="${ret_cutoff_text1250_v0}"
        local truncated_16625="${ret_cutoff_text1250_v0__71_27}"
        if [ "$(( i_16622 == _selected_63 ))" != 0 ]; then
            colored_secondary__1220_v0 "${_cursor_64}""${check_mark_16624}""${truncated_16625}""
"
            local ret_colored_secondary1220_v0__73_37="${ret_colored_secondary1220_v0}"
            local array_261=("")
            eprintf__1118_v0 "${ret_colored_secondary1220_v0__73_37}" array_261[@]
        elif [ "${_checked_71[${global_idx_16623}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1170_v0 "${cursor_len_16619}"
            colored_secondary__1220_v0 "${check_mark_16624}""${truncated_16625}""
"
            local ret_colored_secondary1220_v0__76_25="${ret_colored_secondary1220_v0}"
            local array_262=("")
            eprintf__1118_v0 "${ret_colored_secondary1220_v0__76_25}" array_262[@]
        else
            print_blank__1170_v0 "${cursor_len_16619}"
            local array_263=("")
            eprintf__1118_v0 "${check_mark_16624}""${truncated_16625}""
" array_263[@]
        fi
done
    local remaining_slots_16627="$(( _display_count_60 - _page_count_70 ))"
    if [ "$(( remaining_slots_16627 > 0 ))" != 0 ]; then
        local __range_start_16628=0
        local __range_end_16628="${remaining_slots_16627}"
        local __dir_16628=$(( ${__range_start_16628} <= ${__range_end_16628} ? 1 : -1 ))
        for (( ____16628=${__range_start_16628}; ____16628 * ${__dir_16628} < ${__range_end_16628} * ${__dir_16628}; ____16628+=${__dir_16628} )); do
            local array_264=("")
            eprintf__1118_v0 "\\x1b[K
" array_264[@]
done
    fi
}

# render_page()
render_page__1488_v0() {
    if [ "${_multi_65}" != 0 ]; then
        render_multi_page__1487_v0 
    else
        render_single_page__1486_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1489_v0() {
    if [ "$(( _total_pages_61 > 1 ))" != 0 ]; then
        local array_265=("")
        eprintf__1118_v0 "\\x1b[G\\x1b[K" array_265[@]
        eprintf_colored__1119_v0 "Page $(( _current_page_62 + 1 ))/${_total_pages_61}" 90
        local array_266=("")
        eprintf__1118_v0 "\\x1b[G" array_266[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1490_v0() {
    if [ "$(( ! _multi_65 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_61 > 1 ))" != 0 ]; then
            local array_267=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1277_v0 array_267[@] 36 "${_term_width_67}"
        else
            local array_268=("↑↓" "select" "enter" "confirm")
            render_tooltip__1277_v0 array_268[@] 25 "${_term_width_67}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_61 > 1 )) && $(( _limit_66 < 0 )) ))" != 0 ]; then
            local array_269=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1277_v0 array_269[@] 55 "${_term_width_67}"
        elif [ "$(( _total_pages_61 > 1 ))" != 0 ]; then
            local array_270=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1277_v0 array_270[@] 47 "${_term_width_67}"
        elif [ "$(( _limit_66 < 0 ))" != 0 ]; then
            local array_271=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1277_v0 array_271[@] 44 "${_term_width_67}"
        else
            local array_272=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1277_v0 array_272[@] 36 "${_term_width_67}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1491_v0() {
    local total_16542="${1}"
    local page_size_16543="${2}"
    local header_16544="${3}"
    local cursor_16545="${4}"
    local multi_16546="${5}"
    local limit_16547="${6}"
    _total_58="${total_16542}"
    _cursor_64="${cursor_16545}"
    _multi_65="${multi_16546}"
    _limit_66="${limit_16547}"
    _current_page_62=0
    _selected_63=0
    _first_render_73=1
    _up_paged_74=0
    _checked_count_72=0
    _has_header_68="$([ "_${header_16544}" == "_" ]; echo $?)"
    stty_lock__1158_v0 
    hide_cursor__1175_v0 
    term_width__1165_v0 
    _term_width_67="${ret_term_width1165_v0}"
    term_height__1166_v0 
    local term_height_16552="${ret_term_height1166_v0}"
    local max_page_size_16553
    max_page_size_16553="$(( term_height_16552 - $(if [ "${_has_header_68}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_59="${page_size_16543}"
    if [ "$(( _page_size_59 > max_page_size_16553 ))" != 0 ]; then
        _page_size_59="${max_page_size_16553}"
    fi
    if [ "${_has_header_68}" != 0 ]; then
        cutoff_text__1250_v0 "${header_16544}" "${_term_width_67}"
        local ret_cutoff_text1250_v0__157_17="${ret_cutoff_text1250_v0}"
        local array_273=("")
        eprintf__1118_v0 "${ret_cutoff_text1250_v0__157_17}""
" array_273[@]
    fi
    math_floor__606_v0 "$(( $(( $(( total_16542 + _page_size_59 )) - 1 )) / _page_size_59 ))"
    _total_pages_61="${ret_math_floor606_v0}"
    _display_count_60="${_page_size_59}"
    if [ "$(( total_16542 < _page_size_59 ))" != 0 ]; then
        _display_count_60="${total_16542}"
    fi
    if [ "${multi_16546}" != 0 ]; then
        _checked_71=()
        local __range_start_16590=0
        local __range_end_16590="${total_16542}"
        local __dir_16590=$(( ${__range_start_16590} <= ${__range_end_16590} ? 1 : -1 ))
        for (( ____16590=${__range_start_16590}; ____16590 * ${__dir_16590} < ${__range_end_16590} * ${__dir_16590}; ____16590+=${__dir_16590} )); do
            local array_275=(0)
            _checked_71+=("${array_275[@]}")
done
    fi
    new_line__1171_v0 "${_display_count_60}"
    local array_276=("")
    eprintf__1118_v0 "\\x1b[G" array_276[@]
    if [ "$(( _total_pages_61 > 1 ))" != 0 ]; then
        eprintf_colored__1119_v0 "Page $(( _current_page_62 + 1 ))/${_total_pages_61}" 90
    fi
    new_line__1171_v0 1
    render_tooltip_line__1490_v0 
    go_up__1172_v0 "$(( _display_count_60 + 1 ))"
    local array_277=("")
    eprintf__1118_v0 "\\x1b[G" array_277[@]
}

# chooser_page_start()
chooser_page_start__1492_v0() {
    ret_chooser_page_start1492_v0="$(( _current_page_62 * _page_size_59 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1493_v0() {
    chooser_page_start__1492_v0 
    local start_16614="${ret_chooser_page_start1492_v0}"
    local end_16615="$(( start_16614 + _page_size_59 ))"
    if [ "$(( end_16615 > _total_58 ))" != 0 ]; then
        end_16615="${_total_58}"
    fi
    ret_chooser_page_count1493_v0="$(( end_16615 - start_16614 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1494_v0() {
    local page_16618=("${!1}")
    _page_69=("${page_16618[@]}")
    local __length_278=("${page_16618[@]}")
    _page_count_70="${#__length_278[@]}"
    if [ "${_first_render_73}" != 0 ]; then
        _first_render_73=0
        render_page__1488_v0 
    else
        if [ "${_up_paged_74}" != 0 ]; then
            _selected_63="$(( _page_count_70 - 1 ))"
            _up_paged_74=0
        fi
        go_up__1172_v0 1
        remove_line__1168_v0 "$(( _display_count_60 - 1 ))"
        remove_current_line__1169_v0 
        local array_279=("")
        eprintf__1118_v0 "\\x1b[G" array_279[@]
        render_page__1488_v0 
        render_page_indicator__1489_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1495_v0() {
    local prev_selected_16650="${1}"
    chooser_page_start__1492_v0 
    local page_start_16651="${ret_chooser_page_start1492_v0}"
    local check_width_16652
    check_width_16652="$(if [ "${_multi_65}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_280="${_cursor_64}"
    local max_option_width_16653="$(( $(( _term_width_67 - ${#__length_280} )) - check_width_16652 ))"
    go_up__1172_v0 "$(( _display_count_60 - prev_selected_16650 ))"
    local array_281=("")
    eprintf__1118_v0 "\\x1b[K" array_281[@]
    local __length_282="${_cursor_64}"
    print_blank__1170_v0 "${#__length_282}"
    if [ "${_multi_65}" != 0 ]; then
        local was_checked_16654="${_checked_71[$(( page_start_16651 + prev_selected_16650 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1250_v0 "${_page_69[${prev_selected_16650}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_16653}"
        local ret_cutoff_text1250_v0__232_63="${ret_cutoff_text1250_v0}"
        local prev_line_16655
        prev_line_16655="$(if [ "${was_checked_16654}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1250_v0__232_63}"
        if [ "${was_checked_16654}" != 0 ]; then
            colored_secondary__1220_v0 "${prev_line_16655}"
            local ret_colored_secondary1220_v0__234_21="${ret_colored_secondary1220_v0}"
            local array_283=("")
            eprintf__1118_v0 "${ret_colored_secondary1220_v0__234_21}" array_283[@]
        else
            local array_284=("")
            eprintf__1118_v0 "${prev_line_16655}" array_284[@]
        fi
    else
        cutoff_text__1250_v0 "${_page_69[${prev_selected_16650}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_16653}"
        local ret_cutoff_text1250_v0__239_17="${ret_cutoff_text1250_v0}"
        local array_285=("")
        eprintf__1118_v0 "${ret_cutoff_text1250_v0__239_17}" array_285[@]
    fi
    go_up_or_down__1174_v0 "$(( _selected_63 - prev_selected_16650 ))"
    local array_286=("")
    eprintf__1118_v0 "\\x1b[G" array_286[@]
    local array_287=("")
    eprintf__1118_v0 "\\x1b[K" array_287[@]
    local mark_16657
    mark_16657="$(if [ "${_multi_65}" != 0 ]; then echo "$(if [ "${_checked_71[$(( page_start_16651 + _selected_63 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1250_v0 "${_page_69[${_selected_63}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_16653}"
    local ret_cutoff_text1250_v0__246_48="${ret_cutoff_text1250_v0}"
    colored_secondary__1220_v0 "${_cursor_64}""${mark_16657}""${ret_cutoff_text1250_v0__246_48}"
    local ret_colored_secondary1220_v0__246_13="${ret_colored_secondary1220_v0}"
    local array_288=("")
    eprintf__1118_v0 "${ret_colored_secondary1220_v0__246_13}" array_288[@]
    go_down__1173_v0 "$(( _display_count_60 - _selected_63 ))"
    local array_289=("")
    eprintf__1118_v0 "\\x1b[G" array_289[@]
}

# redraw_current_line()
redraw_current_line__1496_v0() {
    chooser_page_start__1492_v0 
    local page_start_16644="${ret_chooser_page_start1492_v0}"
    local __length_290="${_cursor_64}"
    local max_option_width_16645="$(( $(( _term_width_67 - ${#__length_290} )) - 3 ))"
    go_up__1172_v0 "$(( _display_count_60 - _selected_63 ))"
    local array_291=("")
    eprintf__1118_v0 "\\x1b[G" array_291[@]
    local array_292=("")
    eprintf__1118_v0 "\\x1b[K" array_292[@]
    local check_mark_16646
    check_mark_16646="$(if [ "${_checked_71[$(( page_start_16644 + _selected_63 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1250_v0 "${_page_69[${_selected_63}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_16645}"
    local ret_cutoff_text1250_v0__260_54="${ret_cutoff_text1250_v0}"
    colored_secondary__1220_v0 "${_cursor_64}""${check_mark_16646}""${ret_cutoff_text1250_v0__260_54}"
    local ret_colored_secondary1220_v0__260_13="${ret_colored_secondary1220_v0}"
    local array_293=("")
    eprintf__1118_v0 "${ret_colored_secondary1220_v0__260_13}" array_293[@]
    go_down__1173_v0 "$(( _display_count_60 - _selected_63 ))"
    local array_294=("")
    eprintf__1118_v0 "\\x1b[G" array_294[@]
}

# chooser_step()
chooser_step__1497_v0() {
    get_key__1116_v0 
    local key_16639="${ret_get_key1116_v0}"
    local prev_selected_16640="${_selected_63}"
    local prev_page_16641="${_current_page_62}"
    chooser_page_start__1492_v0 
    local page_start_16642="${ret_chooser_page_start1492_v0}"
    _up_paged_74=0
    if [ "$(( $([ "_${key_16639}" != "_UP" ]; echo $?) || $([ "_${key_16639}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_63 == 0 )) && $(( _total_pages_61 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_62 > 0 ))" != 0 ]; then
                _current_page_62="$(( _current_page_62 - 1 ))"
            else
                _current_page_62="$(( _total_pages_61 - 1 ))"
            fi
            _up_paged_74=1
        elif [ "$(( _selected_63 == 0 ))" != 0 ]; then
            _selected_63="$(( _page_count_70 - 1 ))"
        else
            _selected_63="$(( _selected_63 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_16639}" != "_DOWN" ]; echo $?) || $([ "_${key_16639}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_63 == $(( _page_count_70 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_62 < $(( _total_pages_61 - 1 )) ))" != 0 ]; then
                _current_page_62="$(( _current_page_62 + 1 ))"
            else
                _current_page_62=0
            fi
            _selected_63=0
        else
            _selected_63="$(( _selected_63 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_16639}" != "_LEFT" ]; echo $?) || $([ "_${key_16639}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_62 > 0 ))" != 0 ]; then
            _current_page_62="$(( _current_page_62 - 1 ))"
        fi
        _selected_63=0
    elif [ "$(( $([ "_${key_16639}" != "_RIGHT" ]; echo $?) || $([ "_${key_16639}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_62 < $(( _total_pages_61 - 1 )) ))" != 0 ]; then
            _current_page_62="$(( _current_page_62 + 1 ))"
            _selected_63=0
        else
            _selected_63="$(( _page_count_70 - 1 ))"
        fi
    elif [ "$(( _multi_65 && $(( $([ "_${key_16639}" != "_x" ]; echo $?) || $([ "_${key_16639}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_16643="$(( page_start_16642 + _selected_63 ))"
        if [ "${_checked_71[${global_selected_16643}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_71["${global_selected_16643}"]=0
            _checked_count_72="$(( _checked_count_72 - 1 ))"
        elif [ "$(( $(( _limit_66 < 0 )) || $(( _checked_count_72 < _limit_66 )) ))" != 0 ]; then
            _checked_71["${global_selected_16643}"]=1
            _checked_count_72="$(( _checked_count_72 + 1 ))"
        else
            ret_chooser_step1497_v0="${__CHOOSER_CONTINUE_55}"
            return 0
        fi
        redraw_current_line__1496_v0 
        ret_chooser_step1497_v0="${__CHOOSER_CONTINUE_55}"
        return 0
    elif [ "$(( $(( _multi_65 && $(( $([ "_${key_16639}" != "_a" ]; echo $?) || $([ "_${key_16639}" != "_A" ]; echo $?) )) )) && $(( _limit_66 < 0 )) ))" != 0 ]; then
        local all_checked_16648="$(( _checked_count_72 == _total_58 ))"
        local __range_start_16649=0
        local __range_end_16649="${_total_58}"
        local __dir_16649=$(( ${__range_start_16649} <= ${__range_end_16649} ? 1 : -1 ))
        for (( i_16649=${__range_start_16649}; i_16649 * ${__dir_16649} < ${__range_end_16649} * ${__dir_16649}; i_16649+=${__dir_16649} )); do
            _checked_71["${i_16649}"]="$(( ! all_checked_16648 ))"
done
        _checked_count_72="$(if [ "${all_checked_16648}" != 0 ]; then echo 0; else echo "${_total_58}"; fi)"
        go_up__1172_v0 "${_display_count_60}"
        local array_295=("")
        eprintf__1118_v0 "\\x1b[G" array_295[@]
        render_page__1488_v0 
        ret_chooser_step1497_v0="${__CHOOSER_CONTINUE_55}"
        return 0
    elif [ "$([ "_${key_16639}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1497_v0="${__CHOOSER_DONE_57}"
        return 0
    else
        ret_chooser_step1497_v0="${__CHOOSER_CONTINUE_55}"
        return 0
    fi
    if [ "$(( prev_page_16641 != _current_page_62 ))" != 0 ]; then
        ret_chooser_step1497_v0="${__CHOOSER_NEED_PAGE_56}"
        return 0
    fi
    if [ "$(( prev_selected_16640 != _selected_63 ))" != 0 ]; then
        redraw_selection__1495_v0 "${prev_selected_16640}"
    fi
    ret_chooser_step1497_v0="${__CHOOSER_CONTINUE_55}"
    return 0
}

# chooser_selected()
chooser_selected__1498_v0() {
    chooser_page_start__1492_v0 
    local ret_chooser_page_start1492_v0__362_12="${ret_chooser_page_start1492_v0}"
    ret_chooser_selected1498_v0="$(( ret_chooser_page_start1492_v0__362_12 + _selected_63 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1499_v0() {
    local index_16663="${1}"
    ret_chooser_is_checked1499_v0="${_checked_71[${index_16663}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1500_v0() {
    local total_lines_16659="$(( _display_count_60 + 2 ))"
    if [ "${_has_header_68}" != 0 ]; then
        total_lines_16659="$(( total_lines_16659 + 1 ))"
    fi
    go_down__1173_v0 1
    remove_line__1168_v0 "$(( total_lines_16659 - 1 ))"
    remove_current_line__1169_v0 
    stty_unlock__1159_v0 
    show_cursor__1176_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1509_v0() {
    local options_16667=("${!1}")
    local cursor_16668="${2}"
    local header_16669="${3}"
    local page_size_16670="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_296=("${options_16667[@]}")
    local total_16671="${#__length_296[@]}"
    if [ "$(( total_16671 == 0 ))" != 0 ]; then
        eprintf_colored__1119_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1491_v0 "${total_16671}" "${page_size_16670}" "${header_16669}" "${cursor_16668}" 0 -1
    local need_page_16672=1
    while :
    do
        if [ "${need_page_16672}" != 0 ]; then
            local page_16673=()
            chooser_page_start__1492_v0 
            local start_16674="${ret_chooser_page_start1492_v0}"
            chooser_page_count__1493_v0 
            local count_16675="${ret_chooser_page_count1493_v0}"
            local __range_start_16676="${start_16674}"
            local __range_end_16676="$(( start_16674 + count_16675 ))"
            local __dir_16676=$(( ${__range_start_16676} <= ${__range_end_16676} ? 1 : -1 ))
            for (( i_16676=${__range_start_16676}; i_16676 * ${__dir_16676} < ${__range_end_16676} * ${__dir_16676}; i_16676+=${__dir_16676} )); do
                local array_298=("${options_16667[${i_16676}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_16673+=("${array_298[@]}")
done
            chooser_set_page__1494_v0 page_16673[@]
        fi
        chooser_step__1497_v0 
        local step_16677="${ret_chooser_step1497_v0}"
        if [ "$(( step_16677 == __CHOOSER_DONE_57 ))" != 0 ]; then
            break
        fi
        need_page_16672="$(( step_16677 == __CHOOSER_NEED_PAGE_56 ))"
    done
    chooser_selected__1498_v0 
    local selected_16678="${ret_chooser_selected1498_v0}"
    chooser_end__1500_v0 
    ret_xyl_choose1509_v0="${options_16667[${selected_16678}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1510_v0() {
    local options_16536=("${!1}")
    local cursor_16537="${2}"
    local header_16538="${3}"
    local limit_16539="${4}"
    local page_size_16540="${5}"
    local __length_299=("${options_16536[@]}")
    local total_16541="${#__length_299[@]}"
    if [ "$(( total_16541 == 0 ))" != 0 ]; then
        eprintf_colored__1119_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1510_v0=()
        return 0
    fi
    chooser_begin__1491_v0 "${total_16541}" "${page_size_16540}" "${header_16538}" "${cursor_16537}" 1 "${limit_16539}"
    local need_page_16611=1
    while :
    do
        if [ "${need_page_16611}" != 0 ]; then
            local page_16612=()
            chooser_page_start__1492_v0 
            local start_16613="${ret_chooser_page_start1492_v0}"
            chooser_page_count__1493_v0 
            local count_16616="${ret_chooser_page_count1493_v0}"
            local __range_start_16617="${start_16613}"
            local __range_end_16617="$(( start_16613 + count_16616 ))"
            local __dir_16617=$(( ${__range_start_16617} <= ${__range_end_16617} ? 1 : -1 ))
            for (( i_16617=${__range_start_16617}; i_16617 * ${__dir_16617} < ${__range_end_16617} * ${__dir_16617}; i_16617+=${__dir_16617} )); do
                local array_302=("${options_16536[${i_16617}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_16612+=("${array_302[@]}")
done
            chooser_set_page__1494_v0 page_16612[@]
        fi
        chooser_step__1497_v0 
        local step_16658="${ret_chooser_step1497_v0}"
        if [ "$(( step_16658 == __CHOOSER_DONE_57 ))" != 0 ]; then
            break
        fi
        need_page_16611="$(( step_16658 == __CHOOSER_NEED_PAGE_56 ))"
    done
    chooser_end__1500_v0 
    local result_16661=()
    local __range_start_16662=0
    local __range_end_16662="${total_16541}"
    local __dir_16662=$(( ${__range_start_16662} <= ${__range_end_16662} ? 1 : -1 ))
    for (( i_16662=${__range_start_16662}; i_16662 * ${__dir_16662} < ${__range_end_16662} * ${__dir_16662}; i_16662+=${__dir_16662} )); do
        chooser_is_checked__1499_v0 "${i_16662}"
        local ret_chooser_is_checked1499_v0__93_12="${ret_chooser_is_checked1499_v0}"
        if [ "${ret_chooser_is_checked1499_v0__93_12}" != 0 ]; then
            local array_304=("${options_16536[${i_16662}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_16661+=("${array_304[@]}")
        fi
done
    ret_xyl_multi_choose1510_v0=("${result_16661[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1605_v0() {
    local usage_16462=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1177_v0 usage_16462[@]
    printf '%s\n' ""
    colored_primary__1219_v0 "choose"
    local ret_colored_primary1219_v0__8_20="${ret_colored_primary1219_v0}"
    local title_16486=("${ret_colored_primary1219_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1177_v0 title_16486[@]
    printf '%s\n' ""
    colored_secondary__1220_v0 "Arguments:"
    local ret_colored_secondary1220_v0__11_12="${ret_colored_secondary1220_v0}"
    local array_307=()
    printf__128_v0 "${ret_colored_secondary1220_v0__11_12}""
" array_307[@]
    local arg_names_16488=("[<options> ...]")
    local arg_texts_16489=("List of options to choose from")
    local arg_notes_16490=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1337_v0 arg_names_16488[@] arg_texts_16489[@] arg_notes_16490[@] 20
    printf '%s\n' ""
    colored_secondary__1220_v0 "Flags:"
    local ret_colored_secondary1220_v0__18_12="${ret_colored_secondary1220_v0}"
    local array_311=()
    printf__128_v0 "${ret_colored_secondary1220_v0__18_12}""
" array_311[@]
    local names_16523=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_16524=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_16525=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1337_v0 names_16523[@] texts_16524[@] notes_16525[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1657_v0() {
    local options_16455=()
    local command_316
    command_316="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_16456="${command_316}"
    if [ "$([ "_${is_tty_16456}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_16455+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1657_v0=("${options_16455[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1658_v0() {
    local parameters_16439=("${!1}")
    local cursor_16440="> "
    colored_primary__1219_v0 "Choose: "
    local ret_colored_primary1219_v0__17_30="${ret_colored_primary1219_v0}"
    local header_16454="\\x1b[1m""${ret_colored_primary1219_v0__17_30}"
    read_stdin_options__1657_v0 
    local options_16457=("${ret_read_stdin_options1657_v0[@]}")
    local multi_16458=0
    local limit_16459=-1
    local page_size_16460=10
    local __length_320=("${parameters_16439[@]}")
    local slice_upper_319="${#__length_320[@]}"
    local slice_offset_321=2
    local slice_offset_321=$((${slice_offset_321} > 0 ? ${slice_offset_321} : 0))
    local slice_length_322="$(( slice_upper_319 - slice_offset_321 ))"
    local slice_length_322=$((${slice_length_322} > 0 ? ${slice_length_322} : 0))
    for param_16461 in "${parameters_16439[@]:${slice_offset_321}:${slice_length_322}}"; do
        starts_with__22_v0 "${param_16461}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16461}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16461}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16461}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16461}" != "_-h" ]; echo $?) || $([ "_${param_16461}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1605_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_323="--cursor="
            slice__24_v0 "${param_16461}" "${#__length_323}" 0
            cursor_16440="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_324="--header="
            slice__24_v0 "${param_16461}" "${#__length_324}" 0
            header_16454="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_325="--limit="
            slice__24_v0 "${param_16461}" "${#__length_325}" 0
            local value_16526="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16526}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1119_v0 "ERROR: Invalid limit value: ""${value_16526}""
" 31
                exit 1
            fi
            limit_16459="${ret_parse_int13_v0}"
            multi_16458=1
        elif [ "$([ "_${param_16461}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_16458=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_326="--page-size="
            slice__24_v0 "${param_16461}" "${#__length_326}" 0
            local value_16531="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16531}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1119_v0 "ERROR: Invalid page-size value: ""${value_16531}""
" 31
                exit 1
            fi
            page_size_16460="${ret_parse_int13_v0}"
        else
            options_16457+=("${param_16461}")
        fi
    done
    has_ansi_escape__1243_v0 "${header_16454}"
    local ret_has_ansi_escape1243_v0__59_44="${ret_has_ansi_escape1243_v0}"
    escape_ansi__1244_v0 "${header_16454}"
    local ret_escape_ansi1244_v0__59_73="${ret_escape_ansi1244_v0}"
    colored_primary__1219_v0 "${header_16454}"
    local ret_colored_primary1219_v0__59_111="${ret_colored_primary1219_v0}"
    local display_header_16535
    display_header_16535="$(if [ "$(( $([ "_${header_16454}" != "_" ]; echo $?) || ret_has_ansi_escape1243_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1244_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1219_v0__59_111}"; fi)"
    if [ "${multi_16458}" != 0 ]; then
        xyl_multi_choose__1510_v0 options_16457[@] "${cursor_16440}" "${display_header_16535}" "${limit_16459}" "${page_size_16460}"
        local results_16664=("${ret_xyl_multi_choose1510_v0[@]}")
        join__7_v0 results_16664[@] "
"
        ret_execute_choose1658_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1509_v0 options_16457[@] "${cursor_16440}" "${display_header_16535}" "${page_size_16460}"
    ret_execute_choose1658_v0="${ret_xyl_choose1509_v0}"
    return 0
}

# get_key()
get_key__1782_v0() {
    local command_328
    command_328="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_18706="${command_328}"
    if [ "$([ "_${var_18706}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1782_v0="UP"
        return 0
    elif [ "$([ "_${var_18706}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1782_v0="DOWN"
        return 0
    elif [ "$([ "_${var_18706}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1782_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_18706}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1782_v0="LEFT"
        return 0
    elif [ "$([ "_${var_18706}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1782_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_18706}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1782_v0="INPUT"
        return 0
    else
        ret_get_key1782_v0="${var_18706}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1784_v0() {
    local format_18612="${1}"
    local args_18613=("${!2}")
    args_18613=("${format_18612}" "${args_18613[@]}")
    __status=$?
    printf "${args_18613[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1785_v0() {
    local message_18610="${1}"
    local color_18611="${2}"
    # Prints an error message with a specified color.
    local array_329=("${message_18610}")
    eprintf__1784_v0 "\\x1b[${color_18611}m%s\\x1b[0m" array_329[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1800_v0() {
    local format_18622="${1}"
    local args_18623=("${!2}")
    args_18623=("${format_18622}" "${args_18623[@]}")
    __status=$?
    printf "${args_18623[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_80="None"
# perl_available()
perl_available__1807_v0() {
    if [ "$([ "_${_perl_state_80}" != "_None" ]; echo $?)" != 0 ]; then
        local command_330
        command_330="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18568
        disabled_18568="$([ "_${command_330}" != "_No" ]; echo $?)"
        local command_331
        command_331="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18569
        found_18569="$(( $(( ! disabled_18568 )) && $([ "_${command_331}" != "_0" ]; echo $?) ))"
        _perl_state_80="$(if [ "${found_18569}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1807_v0="$([ "_${_perl_state_80}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1808_v0() {
    local text_18567="${1}"
    perl_available__1807_v0 
    local ret_perl_available1807_v0__22_12="${ret_perl_available1807_v0}"
    if [ "$(( ! ret_perl_available1807_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1808_v0=''
        return 1
    fi
    local command_332
    command_332="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18567}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1808_v0=''
        return "${__status}"
    fi
    local width_str_18570="${command_332}"
    parse_int__13_v0 "${width_str_18570}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1808_v0=''
        return "${__status}"
    fi
    local width_18571="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1808_v0="${width_18571}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1813_v0() {
    local text_18560="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_333
    command_333="$([[ "${text_18560}" == *$'\x1b'* || "${text_18560}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18561="${command_333}"
    ret_has_ansi_escape1813_v0="$([ "_${has_escape_18561}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1815_v0() {
    local text_18563="${1}"
    local command_334
    command_334="$(printf "%s" "${text_18563}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1815_v0="${command_334}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1816_v0() {
    local text_18565="${1}"
    local command_335
    command_335="$(printf "%s" "${text_18565}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18566="${command_335}"
    ret_is_all_ascii1816_v0="$([ "_${result_18566}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1817_v0() {
    local text_18562="${1}"
    strip_ansi__1815_v0 "${text_18562}"
    local stripped_18564="${ret_strip_ansi1815_v0}"
    # Check if text is all ASCII
    is_all_ascii__1816_v0 "${stripped_18564}"
    local ret_is_all_ascii1816_v0__36_12="${ret_is_all_ascii1816_v0}"
    if [ "$(( ! ret_is_all_ascii1816_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1808_v0 "${stripped_18564}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_336="${stripped_18564}"
            ret_get_visible_len1817_v0="${#__length_336}"
            return 0
        fi
        ret_get_visible_len1817_v0="${ret_perl_get_cjk_width1808_v0}"
        return 0
    else
        local __length_337="${stripped_18564}"
        ret_get_visible_len1817_v0="${#__length_337}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_81=0
_term_size_82=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1823_v0() {
    local command_339
    command_339="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_18620="${command_339}"
    parse_int__13_v0 "${count_18620}"
    __status=$?
    ret_stty_count1823_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1824_v0() {
    stty_count__1823_v0 
    local count_num_18621="${ret_stty_count1823_v0}"
    if [ "$(( count_num_18621 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_18621="$(( count_num_18621 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18621}
    __status=$?
}

# stty_unlock()
stty_unlock__1825_v0() {
    stty_count__1823_v0 
    local count_num_18713="${ret_stty_count1823_v0}"
    if [ "$(( count_num_18713 > 0 ))" != 0 ]; then
        count_num_18713="$(( count_num_18713 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18713}
        __status=$?
        if [ "$(( count_num_18713 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1826_v0() {
    local size_18551="${1}"
    if [ "$([ "_${size_18551}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1826_v0=0
        return 0
    fi
    split__4_v0 "${size_18551}" " "
    local parts_18552=("${ret_split4_v0[@]}")
    local __length_340=("${parts_18552[@]}")
    if [ "$(( ${#__length_340[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1826_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18552[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18552[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_82=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1826_v0=1
    return 0
}

# query_term_size()
query_term_size__1827_v0() {
    local command_342
    command_342="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18554="${command_342}"
    store_term_size__1826_v0 "${size_18554}"
    ret_query_term_size1827_v0="${ret_store_term_size1826_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1828_v0() {
    local command_343
    command_343="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18550="${command_343}"
    store_term_size__1826_v0 "${size_18550}"
    ret_stty_term_size1828_v0="${ret_store_term_size1826_v0}"
    return 0
}

# get_term_size()
get_term_size__1829_v0() {
    stty_term_size__1828_v0 
    local detected_18553="${ret_stty_term_size1828_v0}"
    if [ "$(( ! detected_18553 ))" != 0 ]; then
        query_term_size__1827_v0 
        detected_18553="${ret_query_term_size1827_v0}"
    fi
    _got_term_size_81=1
}

# term_width()
term_width__1831_v0() {
    if [ "$(( ! _got_term_size_81 ))" != 0 ]; then
        get_term_size__1829_v0 
    fi
    ret_term_width1831_v0="${_term_size_82[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__1834_v0() {
    local cnt_18710="${1}"
    if [ "$(( cnt_18710 > 0 ))" != 0 ]; then
        local sequence_18711=""
        local __range_start_18712=0
        local __range_end_18712="${cnt_18710}"
        local __dir_18712=$(( ${__range_start_18712} <= ${__range_end_18712} ? 1 : -1 ))
        for (( ____18712=${__range_start_18712}; ____18712 * ${__dir_18712} < ${__range_end_18712} * ${__dir_18712}; ____18712+=${__dir_18712} )); do
            sequence_18711+="\\x1b[2K\\x1b[1A"
done
        local array_344=("")
        eprintf__1800_v0 "${sequence_18711}" array_344[@]
    fi
    local array_345=("")
    eprintf__1800_v0 "\\x1b[G" array_345[@]
}

# remove_current_line()
remove_current_line__1835_v0() {
    local array_346=("")
    eprintf__1800_v0 "\\x1b[2K\\x1b[G" array_346[@]
}

# go_up(cnt: Int)
go_up__1838_v0() {
    local cnt_18705="${1}"
    local array_347=("")
    eprintf__1800_v0 "\\x1b[${cnt_18705}A" array_347[@]
}

# go_down(cnt: Int)
go_down__1839_v0() {
    local cnt_18709="${1}"
    local array_348=("")
    eprintf__1800_v0 "\\x1b[${cnt_18709}B" array_348[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1841_v0() {
    local array_349=("")
    eprintf__1800_v0 "\\x1b[?25l" array_349[@]
}

# show_cursor()
show_cursor__1842_v0() {
    local array_350=("")
    eprintf__1800_v0 "\\x1b[?25h" array_350[@]
}

# print_wrapped(pieces: [Text])
print_wrapped__1843_v0() {
    local pieces_18549=("${!1}")
    term_width__1831_v0 
    local width_18555="${ret_term_width1831_v0}"
    local line_18556=""
    local line_len_18557=0
    for piece_18558 in "${pieces_18549[@]}"; do
        local __length_353="${piece_18558}"
        local piece_len_18559="${#__length_353}"
        has_ansi_escape__1813_v0 "${piece_18558}"
        local ret_has_ansi_escape1813_v0__186_12="${ret_has_ansi_escape1813_v0}"
        if [ "${ret_has_ansi_escape1813_v0__186_12}" != 0 ]; then
            get_visible_len__1817_v0 "${piece_18558}"
            piece_len_18559="${ret_get_visible_len1817_v0}"
        fi
        if [ "$([ "_${line_18556}" != "_" ]; echo $?)" != 0 ]; then
            line_18556="${piece_18558}"
            line_len_18557="${piece_len_18559}"
        elif [ "$(( $(( $(( line_len_18557 + 1 )) + piece_len_18559 )) > width_18555 ))" != 0 ]; then
            local array_354=()
            printf__128_v0 "${line_18556}""
" array_354[@]
            line_18556="${piece_18558}"
            line_len_18557="${piece_len_18559}"
        else
            line_18556+=" ""${piece_18558}"
            line_len_18557="$(( line_len_18557 + $(( 1 + piece_len_18559 )) ))"
        fi
    done
    if [ "$([ "_${line_18556}" == "_" ]; echo $?)" != 0 ]; then
        local array_355=()
        printf__128_v0 "${line_18556}""
" array_355[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_85="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_86=0
_primary_color_87=(3 207 159 92)
_secondary_color_88=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1880_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_18544="${ret_env_var_get120_v0}"
    _supports_truecolor_85="$(if [ "$([ "_${config_18544}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1880_v0="$([ "_${_supports_truecolor_85}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1881_v0() {
    local message_18539="${1}"
    local r_18540="${2}"
    local g_18541="${3}"
    local b_18542="${4}"
    local fallback_18543="${5}"
    if [ "$([ "_${_supports_truecolor_85}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1881_v0="\\x1b[38;2;${r_18540};${g_18541};${b_18542}m""${message_18539}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_85}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1880_v0 
        local ret_get_supports_truecolor1880_v0__45_17="${ret_get_supports_truecolor1880_v0}"
        if [ "${ret_get_supports_truecolor1880_v0__45_17}" != 0 ]; then
            ret_colored_rgb1881_v0="\\x1b[38;2;${r_18540};${g_18541};${b_18542}m""${message_18539}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_18543 == 0 ))" != 0 ]; then
            ret_colored_rgb1881_v0="${message_18539}"
            return 0
        else
            ret_colored_rgb1881_v0="\\x1b[${fallback_18543}m""${message_18539}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_18543 == 0 ))" != 0 ]; then
            ret_colored_rgb1881_v0="${message_18539}"
            return 0
        fi
        ret_colored_rgb1881_v0="\\x1b[${fallback_18543}m""${message_18539}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1882_v0() {
    local message_18682="${1}"
    local r_18683="${2}"
    local g_18684="${3}"
    local b_18685="${4}"
    local fallback_18686="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_18687="${fallback_18686}"
    if [ "$(( $(( fallback_18686 >= 30 )) && $(( fallback_18686 <= 37 )) ))" != 0 ]; then
        bg_fallback_18687="$(( fallback_18686 + 10 ))"
    fi
    if [ "$(( $(( fallback_18686 >= 90 )) && $(( fallback_18686 <= 97 )) ))" != 0 ]; then
        bg_fallback_18687="$(( fallback_18686 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_85}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1882_v0="\\x1b[48;2;${r_18683};${g_18684};${b_18685}m""${message_18682}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_85}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1880_v0 
        local ret_get_supports_truecolor1880_v0__87_17="${ret_get_supports_truecolor1880_v0}"
        if [ "${ret_get_supports_truecolor1880_v0__87_17}" != 0 ]; then
            ret_background_rgb1882_v0="\\x1b[48;2;${r_18683};${g_18684};${b_18685}m""${message_18682}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_18687 == 0 ))" != 0 ]; then
            ret_background_rgb1882_v0="${message_18682}"
            return 0
        else
            ret_background_rgb1882_v0="\\x1b[${bg_fallback_18687}m""${message_18682}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_18687 == 0 ))" != 0 ]; then
            ret_background_rgb1882_v0="${message_18682}"
            return 0
        fi
        ret_background_rgb1882_v0="\\x1b[${bg_fallback_18687}m""${message_18682}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1883_v0() {
    if [ "$(( ! _got_xylitol_colors_86 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_18533="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_18533}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_18533}" ";"
            local parts_18534=("${ret_split4_v0[@]}")
            local __length_359=("${parts_18534[@]}")
            if [ "$(( ${#__length_359[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18534[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18534[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18534[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18534[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_87=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_18535="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_18535}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_18535}" ";"
            local parts_18536=("${ret_split4_v0[@]}")
            local __length_361=("${parts_18536[@]}")
            if [ "$(( ${#__length_361[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18536[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18536[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18536[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18536[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_88=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_18537="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_18537}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_18537}" ";"
            local parts_18538=("${ret_split4_v0[@]}")
            local __length_363=("${parts_18538[@]}")
            if [ "$(( ${#__length_363[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18538[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18538[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18538[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18538[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1883_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_86=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1884_v0() {
    inner_get_xylitol_colors__1883_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_86=1
}

# colored_primary(message: Text)
colored_primary__1885_v0() {
    local message_18532="${1}"
    if [ "$(( ! _got_xylitol_colors_86 ))" != 0 ]; then
        get_xylitol_colors__1884_v0 
    fi
    colored_rgb__1881_v0 "${message_18532}" "${_primary_color_87[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_87[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_87[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_87[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1885_v0="${ret_colored_rgb1881_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1886_v0() {
    local message_18573="${1}"
    if [ "$(( ! _got_xylitol_colors_86 ))" != 0 ]; then
        get_xylitol_colors__1884_v0 
    fi
    colored_rgb__1881_v0 "${message_18573}" "${_secondary_color_88[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_88[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_88[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_88[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1886_v0="${ret_colored_rgb1881_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1889_v0() {
    local message_18681="${1}"
    if [ "$(( ! _got_xylitol_colors_86 ))" != 0 ]; then
        get_xylitol_colors__1884_v0 
    fi
    background_rgb__1882_v0 "${message_18681}" "${_secondary_color_88[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_88[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_88[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_88[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary1889_v0="${ret_background_rgb1882_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_90="None"
# perl_available()
perl_available__1903_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_365
        command_365="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18633
        disabled_18633="$([ "_${command_365}" != "_No" ]; echo $?)"
        local command_366
        command_366="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18634
        found_18634="$(( $(( ! disabled_18633 )) && $([ "_${command_366}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_18634}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1903_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1904_v0() {
    local text_18632="${1}"
    perl_available__1903_v0 
    local ret_perl_available1903_v0__22_12="${ret_perl_available1903_v0}"
    if [ "$(( ! ret_perl_available1903_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1904_v0=''
        return 1
    fi
    local command_367
    command_367="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18632}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1904_v0=''
        return "${__status}"
    fi
    local width_str_18635="${command_367}"
    parse_int__13_v0 "${width_str_18635}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1904_v0=''
        return "${__status}"
    fi
    local width_18636="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1904_v0="${width_18636}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1905_v0() {
    local text_18643="${1}"
    local max_width_18644="${2}"
    perl_available__1903_v0 
    local ret_perl_available1903_v0__33_12="${ret_perl_available1903_v0}"
    if [ "$(( ! ret_perl_available1903_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1905_v0=''
        return 1
    fi
    local command_368
    command_368="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18643}" ${max_width_18644} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1905_v0=''
        return "${__status}"
    fi
    local result_18645="${command_368}"
    ret_perl_truncate_cjk1905_v0="${result_18645}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1909_v0() {
    local text_18614="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_369
    command_369="$([[ "${text_18614}" == *$'\x1b'* || "${text_18614}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18615="${command_369}"
    ret_has_ansi_escape1909_v0="$([ "_${has_escape_18615}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1910_v0() {
    local text_18616="${1}"
    local command_370
    command_370="$(printf '%s' "${text_18616}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1910_v0="${command_370}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1911_v0() {
    local text_18628="${1}"
    local command_371
    command_371="$(printf "%s" "${text_18628}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1911_v0="${command_371}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1912_v0() {
    local text_18630="${1}"
    local command_372
    command_372="$(printf "%s" "${text_18630}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18631="${command_372}"
    ret_is_all_ascii1912_v0="$([ "_${result_18631}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1913_v0() {
    local text_18627="${1}"
    strip_ansi__1911_v0 "${text_18627}"
    local stripped_18629="${ret_strip_ansi1911_v0}"
    # Check if text is all ASCII
    is_all_ascii__1912_v0 "${stripped_18629}"
    local ret_is_all_ascii1912_v0__36_12="${ret_is_all_ascii1912_v0}"
    if [ "$(( ! ret_is_all_ascii1912_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1904_v0 "${stripped_18629}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_373="${stripped_18629}"
            ret_get_visible_len1913_v0="${#__length_373}"
            return 0
        fi
        ret_get_visible_len1913_v0="${ret_perl_get_cjk_width1904_v0}"
        return 0
    else
        local __length_374="${stripped_18629}"
        ret_get_visible_len1913_v0="${#__length_374}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1914_v0() {
    local text_18640="${1}"
    local max_width_18641="${2}"
    get_visible_len__1913_v0 "${text_18640}"
    local visible_len_18642="${ret_get_visible_len1913_v0}"
    if [ "$(( visible_len_18642 <= max_width_18641 ))" != 0 ]; then
        ret_truncate_text1914_v0="${text_18640}"
        return 0
    fi
    is_all_ascii__1912_v0 "${text_18640}"
    local ret_is_all_ascii1912_v0__53_12="${ret_is_all_ascii1912_v0}"
    if [ "$(( ! ret_is_all_ascii1912_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1905_v0 "${text_18640}" "${max_width_18641}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18640}" | cut -c1-${max_width_18641}
            __status=$?
        fi
        ret_truncate_text1914_v0="${ret_perl_truncate_cjk1905_v0}"
        return 0
    fi
    local command_375
    command_375="$(printf "%s" "${text_18640}" | cut -c1-${max_width_18641})"
    __status=$?
    ret_truncate_text1914_v0="${command_375}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1915_v0() {
    local text_18638="${1}"
    local max_width_18639="${2}"
    has_ansi_escape__1909_v0 "${text_18638}"
    local ret_has_ansi_escape1909_v0__65_12="${ret_has_ansi_escape1909_v0}"
    if [ "$(( ! ret_has_ansi_escape1909_v0__65_12 ))" != 0 ]; then
        truncate_text__1914_v0 "${text_18638}" "${max_width_18639}"
        ret_truncate_ansi1915_v0="${ret_truncate_text1914_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_376
    command_376="$([[ "${text_18638}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18646="${command_376}"
    # Replace \x1b[ with newline, then split
    local command_377
    command_377="$(t="${text_18638}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18647="${command_377}"
    split__4_v0 "${replaced_18647}" "
"
    local parts_18648=("${ret_split4_v0[@]}")
    local result_18649=""
    local remaining_width_18650="${max_width_18639}"
    local __range_start_18651=0
    local __length_378=("${parts_18648[@]}")
    local __range_end_18651="${#__length_378[@]}"
    local __dir_18651=$(( ${__range_start_18651} <= ${__range_end_18651} ? 1 : -1 ))
    for (( idx_18651=${__range_start_18651}; idx_18651 * ${__dir_18651} < ${__range_end_18651} * ${__dir_18651}; idx_18651+=${__dir_18651} )); do
        local part_18652="${parts_18648[${idx_18651}]?"Index out of bounds (at src/./confirm/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18651 == 0 )) && $([ "_${starts_with_ansi_18646}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18652}" == "_" ]; echo $?) && $(( remaining_width_18650 > 0 )) ))" != 0 ]; then
                truncate_text__1914_v0 "${part_18652}" "${remaining_width_18650}"
                local ret_truncate_text1914_v0__87_35="${ret_truncate_text1914_v0}"
                local truncated_18653="${ret_truncate_text1914_v0__87_35}"
                result_18649+="${truncated_18653}"
                get_visible_len__1913_v0 "${truncated_18653}"
                local ret_get_visible_len1913_v0__89_36="${ret_get_visible_len1913_v0}"
                remaining_width_18650="$(( remaining_width_18650 - ret_get_visible_len1913_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_379
            command_379="$(__p="${part_18652}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18654="${command_379}"
            if [ "$([ "_${m_idx_18654}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_380
                command_380="$(__p="${part_18652}"; printf "%s" "${__p:0:${m_idx_18654}}")"
                __status=$?
                local ansi_params_18655="${command_380}"
                result_18649+="\\x1b[""${ansi_params_18655}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18654}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_18656="${ret_parse_int13_v0__100_41}"
                local text_start_18657="$(( m_idx_num_18656 + 1 ))"
                local command_381
                command_381="$(__p="${part_18652}"; printf "%s" "${__p:${text_start_18657}}")"
                __status=$?
                local text_part_18658="${command_381}"
                if [ "$(( $([ "_${text_part_18658}" == "_" ]; echo $?) && $(( remaining_width_18650 > 0 )) ))" != 0 ]; then
                    truncate_text__1914_v0 "${text_part_18658}" "${remaining_width_18650}"
                    local ret_truncate_text1914_v0__104_39="${ret_truncate_text1914_v0}"
                    local truncated_18659="${ret_truncate_text1914_v0__104_39}"
                    result_18649+="${truncated_18659}"
                    get_visible_len__1913_v0 "${truncated_18659}"
                    local ret_get_visible_len1913_v0__106_40="${ret_get_visible_len1913_v0}"
                    remaining_width_18650="$(( remaining_width_18650 - ret_get_visible_len1913_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18652}" == "_" ]; echo $?) && $(( remaining_width_18650 > 0 )) ))" != 0 ]; then
                    truncate_text__1914_v0 "${part_18652}" "${remaining_width_18650}"
                    local ret_truncate_text1914_v0__111_39="${ret_truncate_text1914_v0}"
                    local truncated_18660="${ret_truncate_text1914_v0__111_39}"
                    result_18649+="${truncated_18660}"
                    get_visible_len__1913_v0 "${truncated_18660}"
                    local ret_get_visible_len1913_v0__113_40="${ret_get_visible_len1913_v0}"
                    remaining_width_18650="$(( remaining_width_18650 - ret_get_visible_len1913_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1915_v0="${result_18649}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1916_v0() {
    local text_18625="${1}"
    local max_width_18626="${2}"
    get_visible_len__1913_v0 "${text_18625}"
    local visible_len_18637="${ret_get_visible_len1913_v0}"
    if [ "$(( visible_len_18637 <= max_width_18626 ))" != 0 ]; then
        ret_cutoff_text1916_v0="${text_18625}"
        return 0
    fi
    truncate_ansi__1915_v0 "${text_18625}" "$(( max_width_18626 - 3 ))"
    local ret_truncate_ansi1915_v0__129_12="${ret_truncate_ansi1915_v0}"
    ret_cutoff_text1916_v0="${ret_truncate_ansi1915_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__1937_v0() {
    local format_18696="${1}"
    local args_18697=("${!2}")
    args_18697=("${format_18696}" "${args_18697[@]}")
    __status=$?
    printf "${args_18697[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1938_v0() {
    local message_18694="${1}"
    local color_18695="${2}"
    # Prints an error message with a specified color.
    local array_382=("${message_18694}")
    eprintf__1937_v0 "\\x1b[${color_18695}m%s\\x1b[0m" array_382[@]
}

# colored(message: Text, color: Int)
colored__1939_v0() {
    local message_18607="${1}"
    local color_18608="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1939_v0="\\x1b[${color_18608}m""${message_18607}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1943_v0() {
    local items_18688=("${!1}")
    local total_len_18689="${2}"
    local term_width_18690="${3}"
    local separator_18691=" • "
    local separator_len_18692=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18689 <= term_width_18690 ))" != 0 ]; then
        local iter_18693=0
        while :
        do
            local __length_383=("${items_18688[@]}")
            if [ "$(( iter_18693 >= ${#__length_383[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18693 > 0 ))" != 0 ]; then
                eprintf_colored__1938_v0 "${separator_18691}" 90
            fi
            colored__1939_v0 "${items_18688[$(( iter_18693 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1939_v0__23_41="${ret_colored1939_v0}"
            local array_384=("")
            eprintf__1937_v0 "${items_18688[${iter_18693}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1939_v0__23_41}" array_384[@]
            iter_18693="$(( iter_18693 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18698=0
        local first_18699=1
        local iter_18700=0
        while :
        do
            local __length_385=("${items_18688[@]}")
            if [ "$(( iter_18700 >= ${#__length_385[@]} ))" != 0 ]; then
                break
            fi
            local key_18701="${items_18688[${iter_18700}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_18702="${items_18688[$(( iter_18700 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_386="${key_18701}"
            local __length_387="${action_18702}"
            local part_len_18703="$(( $(( ${#__length_386} + 1 )) + ${#__length_387} ))"
            local needed_18704="${part_len_18703}"
            if [ "$(( ! first_18699 ))" != 0 ]; then
                needed_18704="$(( needed_18704 + separator_len_18692 ))"
            fi
            if [ "$(( $(( current_len_18698 + needed_18704 )) > term_width_18690 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18699 ))" != 0 ]; then
                eprintf_colored__1938_v0 "${separator_18691}" 90
            fi
            colored__1939_v0 "${action_18702}" 2
            local ret_colored1939_v0__51_33="${ret_colored1939_v0}"
            local array_388=("")
            eprintf__1937_v0 "${key_18701}"" ""${ret_colored1939_v0__51_33}" array_388[@]
            current_len_18698="$(( current_len_18698 + needed_18704 ))"
            first_18699=0
            iter_18700="$(( iter_18700 + 2 ))"
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
_got_term_size_93=0
_term_size_94=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__1983_v0() {
    local size_18586="${1}"
    if [ "$([ "_${size_18586}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1983_v0=0
        return 0
    fi
    split__4_v0 "${size_18586}" " "
    local parts_18587=("${ret_split4_v0[@]}")
    local __length_390=("${parts_18587[@]}")
    if [ "$(( ${#__length_390[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1983_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18587[1]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18587[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_94=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size1983_v0=1
    return 0
}

# query_term_size()
query_term_size__1984_v0() {
    local command_392
    command_392="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18589="${command_392}"
    store_term_size__1983_v0 "${size_18589}"
    ret_query_term_size1984_v0="${ret_store_term_size1983_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1985_v0() {
    local command_393
    command_393="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18585="${command_393}"
    store_term_size__1983_v0 "${size_18585}"
    ret_stty_term_size1985_v0="${ret_store_term_size1983_v0}"
    return 0
}

# get_term_size()
get_term_size__1986_v0() {
    stty_term_size__1985_v0 
    local detected_18588="${ret_stty_term_size1985_v0}"
    if [ "$(( ! detected_18588 ))" != 0 ]; then
        query_term_size__1984_v0 
        detected_18588="${ret_query_term_size1984_v0}"
    fi
    _got_term_size_93=1
}

# term_width()
term_width__1988_v0() {
    if [ "$(( ! _got_term_size_93 ))" != 0 ]; then
        get_term_size__1986_v0 
    fi
    ret_term_width1988_v0="${_term_size_94[0]?"Index out of bounds (at src/./confirm/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2002_v0() {
    local pending_18604="${1}"
    local line_18605="${2}"
    local note_at_18606="${3}"
    if [ "$(( note_at_18606 < 0 ))" != 0 ]; then
        local array_394=()
        printf__128_v0 "${pending_18604}""${line_18605}""
" array_394[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_18606 == 0 ))" != 0 ]; then
        colored__1939_v0 "${line_18605}" 90
        local ret_colored1939_v0__12_40="${ret_colored1939_v0}"
        local array_395=()
        printf__128_v0 "${pending_18604}""${ret_colored1939_v0__12_40}""
" array_395[@]
    else
        slice__24_v0 "${line_18605}" 0 "${note_at_18606}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_18605}" "${note_at_18606}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__1939_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored1939_v0__13_58="${ret_colored1939_v0}"
        local array_396=()
        printf__128_v0 "${pending_18604}""${ret_slice24_v0__13_32}""${ret_colored1939_v0__13_58}""
" array_396[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2003_v0() {
    local names_18577=("${!1}")
    local texts_18578=("${!2}")
    local notes_18579=("${!3}")
    local min_name_width_18580="${4}"
    local __length_397=("${names_18577[@]}")
    local count_18581="${#__length_397[@]}"
    local name_width_18582="${min_name_width_18580}"
    local __range_start_18583=0
    local __range_end_18583="${count_18581}"
    local __dir_18583=$(( ${__range_start_18583} <= ${__range_end_18583} ? 1 : -1 ))
    for (( i_18583=${__range_start_18583}; i_18583 * ${__dir_18583} < ${__range_end_18583} * ${__dir_18583}; i_18583+=${__dir_18583} )); do
        local __length_398="${names_18577[${i_18583}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:28:33)"}"
        local width_18584="${#__length_398}"
        if [ "$(( width_18584 > name_width_18582 ))" != 0 ]; then
            name_width_18582="${width_18584}"
        fi
done
    term_width__1988_v0 
    local width_18590="${ret_term_width1988_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_18591="$(( name_width_18582 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_18592="$(( $(( width_18590 - indent_18591 )) < 24 ))"
    if [ "${stacked_18592}" != 0 ]; then
        indent_18591=6
    fi
    local avail_18593="$(( width_18590 - indent_18591 ))"
    rpad__28_v0 "" " " "${indent_18591}"
    local blank_18594="${ret_rpad28_v0}"
    local __range_start_18595=0
    local __range_end_18595="${count_18581}"
    local __dir_18595=$(( ${__range_start_18595} <= ${__range_end_18595} ? 1 : -1 ))
    for (( i_18595=${__range_start_18595}; i_18595 * ${__dir_18595} < ${__range_end_18595} * ${__dir_18595}; i_18595+=${__dir_18595} )); do
        local pending_18596="${blank_18594}"
        if [ "${stacked_18592}" != 0 ]; then
            local array_399=()
            printf__128_v0 "  ""${names_18577[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:48:33)"}""
" array_399[@]
        else
            rpad__28_v0 "  ""${names_18577[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:50:41)"}" " " "${indent_18591}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_18596="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_18578[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_18597=("${ret_split4_v0__52_21[@]}")
        local __length_400=("${words_18597[@]}")
        local note_start_18598="${#__length_400[@]}"
        if [ "$([ "_${notes_18579[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_401="${notes_18579[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_401} > avail_18593 ))" != 0 ]; then
                split__4_v0 "${notes_18579[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_18597+=("${ret_split4_v0__58_26[@]}")
            else
                local array_402=("${notes_18579[${i_18595}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:60:33)"}")
                words_18597+=("${array_402[@]}")
            fi
        fi
        local line_18599=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_18600=-1
        local __range_start_18601=0
        local __length_403=("${words_18597[@]}")
        local __range_end_18601="${#__length_403[@]}"
        local __dir_18601=$(( ${__range_start_18601} <= ${__range_end_18601} ? 1 : -1 ))
        for (( j_18601=${__range_start_18601}; j_18601 * ${__dir_18601} < ${__range_end_18601} * ${__dir_18601}; j_18601+=${__dir_18601} )); do
            local word_18602="${words_18597[${j_18601}]?"Index out of bounds (at src/./confirm/../utils/widget/help.ab:70:32)"}"
            local candidate_18603
            candidate_18603="$(if [ "$([ "_${line_18599}" != "_" ]; echo $?)" != 0 ]; then echo "${word_18602}"; else echo "${line_18599}"" ""${word_18602}"; fi)"
            local __length_404="${candidate_18603}"
            if [ "$(( $(( ${#__length_404} > avail_18593 )) && $([ "_${line_18599}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2002_v0 "${pending_18596}" "${line_18599}" "${note_at_18600}"
                pending_18596="${blank_18594}"
                line_18599="${word_18602}"
                note_at_18600="$(if [ "$(( j_18601 >= note_start_18598 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_18601 >= note_start_18598 )) && $(( note_at_18600 < 0 )) ))" != 0 ]; then
                    local __length_405="${candidate_18603}"
                    local __length_406="${word_18602}"
                    note_at_18600="$(( ${#__length_405} - ${#__length_406} ))"
                fi
                line_18599="${candidate_18603}"
            fi
done
        print_help_line__2002_v0 "${pending_18596}" "${line_18599}" "${note_at_18600}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__2055_v0() {
    local selected_18662="${1}"
    local term_width_18663="${2}"
    local small_18664="$(( term_width_18663 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_18664}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_18678="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_18664}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_18679="${ret_cpad29_v0}"
    local gap_18680
    gap_18680="$(if [ "${small_18664}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_407=("")
    eprintf__1784_v0 " " array_407[@]
    if [ "${selected_18662}" != 0 ]; then
        # Yes selected
        background_secondary__1889_v0 "${yes_label_18678}"
        local ret_background_secondary1889_v0__16_30="${ret_background_secondary1889_v0}"
        local array_408=("")
        eprintf__1784_v0 "\\x1b[97m""${ret_background_secondary1889_v0__16_30}" array_408[@]
        local array_409=("")
        eprintf__1784_v0 "${gap_18680}" array_409[@]
        # No not selected (dim)
        local array_410=("")
        eprintf__1784_v0 "\\x1b[49;37m""${no_label_18679}""\\x1b[0m" array_410[@]
    else
        # No selected
        local array_411=("")
        eprintf__1784_v0 "\\x1b[49;37m""${yes_label_18678}""\\x1b[0m" array_411[@]
        local array_412=("")
        eprintf__1784_v0 "${gap_18680}" array_412[@]
        background_secondary__1889_v0 "${no_label_18679}"
        local ret_background_secondary1889_v0__24_30="${ret_background_secondary1889_v0}"
        local array_413=("")
        eprintf__1784_v0 "\\x1b[97m""${ret_background_secondary1889_v0__24_30}" array_413[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__2056_v0() {
    local header_18618="${1}"
    local default_yes_18619="${2}"
    stty_lock__1824_v0 
    hide_cursor__1841_v0 
    term_width__1831_v0 
    local term_width_18624="${ret_term_width1831_v0}"
    if [ "$([ "_${header_18618}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1916_v0 "${header_18618}" "${term_width_18624}"
        local ret_cutoff_text1916_v0__46_17="${ret_cutoff_text1916_v0}"
        local array_414=("")
        eprintf__1784_v0 "${ret_cutoff_text1916_v0__46_17}""

" array_414[@]
    fi
    local selected_18661="${default_yes_18619}"
    # Render initial options
    render_confirm_options__2055_v0 "${selected_18661}" "${term_width_18624}"
    local array_415=("")
    eprintf__1784_v0 "

" array_415[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_416=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1943_v0 array_416[@] 40 "${term_width_18624}"
    go_up__1838_v0 2
    while :
    do
        get_key__1782_v0 
        local key_18707="${ret_get_key1782_v0}"
        if [ "$(( $(( $(( $([ "_${key_18707}" != "_LEFT" ]; echo $?) || $([ "_${key_18707}" != "_h" ]; echo $?) )) || $([ "_${key_18707}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_18707}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_18661}" != 0 ]; then
                selected_18661=0
                local array_417=("")
                eprintf__1784_v0 "\\x1b[G\\x1b[K" array_417[@]
                render_confirm_options__2055_v0 "${selected_18661}" "${term_width_18624}"
            elif [ "$(( ! selected_18661 ))" != 0 ]; then
                selected_18661=1
                local array_418=("")
                eprintf__1784_v0 "\\x1b[G\\x1b[K" array_418[@]
                render_confirm_options__2055_v0 "${selected_18661}" "${term_width_18624}"
            fi
        elif [ "$(( $([ "_${key_18707}" != "_y" ]; echo $?) || $([ "_${key_18707}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_18661=1
            break
        elif [ "$(( $([ "_${key_18707}" != "_n" ]; echo $?) || $([ "_${key_18707}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_18661=0
            break
        elif [ "$([ "_${key_18707}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_18708=4
    if [ "$([ "_${header_18618}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_18708="$(( total_lines_18708 + 1 ))"
    fi
    go_down__1839_v0 2
    remove_line__1834_v0 "$(( total_lines_18708 - 1 ))"
    remove_current_line__1835_v0 
    stty_unlock__1825_v0 
    show_cursor__1842_v0 
    ret_xyl_confirm2056_v0="${selected_18661}"
    return 0
}

# print_confirm_help()
print_confirm_help__2150_v0() {
    local usage_18548=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1843_v0 usage_18548[@]
    printf '%s\n' ""
    colored_primary__1885_v0 "confirm"
    local ret_colored_primary1885_v0__8_20="${ret_colored_primary1885_v0}"
    local title_18572=("${ret_colored_primary1885_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1843_v0 title_18572[@]
    printf '%s\n' ""
    colored_secondary__1886_v0 "Flags:"
    local ret_colored_secondary1886_v0__11_12="${ret_colored_secondary1886_v0}"
    local array_421=()
    printf__128_v0 "${ret_colored_secondary1886_v0__11_12}""
" array_421[@]
    local names_18574=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_18575=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_18576=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__2003_v0 names_18574[@] texts_18575[@] notes_18576[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2202_v0() {
    local parameters_18531=("${!1}")
    colored_primary__1885_v0 "Are you sure?"
    local ret_colored_primary1885_v0__9_30="${ret_colored_primary1885_v0}"
    local header_18545="\\x1b[1m""${ret_colored_primary1885_v0__9_30}"
    local default_yes_18546=1
    for param_18547 in "${parameters_18531[@]}"; do
        starts_with__22_v0 "${param_18547}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_18547}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_18547}" != "_-h" ]; echo $?) || $([ "_${param_18547}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__2150_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_427="--header="
            slice__24_v0 "${param_18547}" "${#__length_427}" 0
            header_18545="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_428="--default="
            slice__24_v0 "${param_18547}" "${#__length_428}" 0
            local value_18609="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_18609}" != "_yes" ]; echo $?) || $([ "_${value_18609}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_18546=1
            elif [ "$(( $([ "_${value_18609}" != "_no" ]; echo $?) || $([ "_${value_18609}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_18546=0
            else
                eprintf_colored__1785_v0 "ERROR: Invalid default value: ""${value_18609}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1909_v0 "${header_18545}"
    local ret_has_ansi_escape1909_v0__35_44="${ret_has_ansi_escape1909_v0}"
    escape_ansi__1910_v0 "${header_18545}"
    local ret_escape_ansi1910_v0__35_73="${ret_escape_ansi1910_v0}"
    colored_primary__1885_v0 "${header_18545}"
    local ret_colored_primary1885_v0__35_111="${ret_colored_primary1885_v0}"
    local display_header_18617
    display_header_18617="$(if [ "$(( $([ "_${header_18545}" != "_" ]; echo $?) || ret_has_ansi_escape1909_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1910_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1885_v0__35_111}"; fi)"
    xyl_confirm__2056_v0 "${display_header_18617}" "${default_yes_18546}"
    local result_18714="${ret_xyl_confirm2056_v0}"
    ret_execute_confirm2202_v0="$(if [ "${result_18714}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2320_v0() {
    local format_28175="${1}"
    local args_28176=("${!2}")
    args_28176=("${format_28175}" "${args_28176[@]}")
    __status=$?
    printf "${args_28176[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2321_v0() {
    local message_28173="${1}"
    local color_28174="${2}"
    # Prints an error message with a specified color.
    local array_429=("${message_28173}")
    eprintf__2320_v0 "\\x1b[${color_28174}m%s\\x1b[0m" array_429[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2336_v0() {
    local format_28205="${1}"
    local args_28206=("${!2}")
    args_28206=("${format_28205}" "${args_28206[@]}")
    __status=$?
    printf "${args_28206[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_98="None"
# perl_available()
perl_available__2343_v0() {
    if [ "$([ "_${_perl_state_98}" != "_None" ]; echo $?)" != 0 ]; then
        local command_430
        command_430="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_28115
        disabled_28115="$([ "_${command_430}" != "_No" ]; echo $?)"
        local command_431
        command_431="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_28116
        found_28116="$(( $(( ! disabled_28115 )) && $([ "_${command_431}" != "_0" ]; echo $?) ))"
        _perl_state_98="$(if [ "${found_28116}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2343_v0="$([ "_${_perl_state_98}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2344_v0() {
    local text_28114="${1}"
    perl_available__2343_v0 
    local ret_perl_available2343_v0__22_12="${ret_perl_available2343_v0}"
    if [ "$(( ! ret_perl_available2343_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2344_v0=''
        return 1
    fi
    local command_432
    command_432="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_28114}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2344_v0=''
        return "${__status}"
    fi
    local width_str_28117="${command_432}"
    parse_int__13_v0 "${width_str_28117}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2344_v0=''
        return "${__status}"
    fi
    local width_28118="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2344_v0="${width_28118}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2349_v0() {
    local text_28107="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_433
    command_433="$([[ "${text_28107}" == *$'\x1b'* || "${text_28107}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_28108="${command_433}"
    ret_has_ansi_escape2349_v0="$([ "_${has_escape_28108}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2351_v0() {
    local text_28110="${1}"
    local command_434
    command_434="$(printf "%s" "${text_28110}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2351_v0="${command_434}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2352_v0() {
    local text_28112="${1}"
    local command_435
    command_435="$(printf "%s" "${text_28112}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_28113="${command_435}"
    ret_is_all_ascii2352_v0="$([ "_${result_28113}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2353_v0() {
    local text_28109="${1}"
    strip_ansi__2351_v0 "${text_28109}"
    local stripped_28111="${ret_strip_ansi2351_v0}"
    # Check if text is all ASCII
    is_all_ascii__2352_v0 "${stripped_28111}"
    local ret_is_all_ascii2352_v0__36_12="${ret_is_all_ascii2352_v0}"
    if [ "$(( ! ret_is_all_ascii2352_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2344_v0 "${stripped_28111}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_436="${stripped_28111}"
            ret_get_visible_len2353_v0="${#__length_436}"
            return 0
        fi
        ret_get_visible_len2353_v0="${ret_perl_get_cjk_width2344_v0}"
        return 0
    else
        local __length_437="${stripped_28111}"
        ret_get_visible_len2353_v0="${#__length_437}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_99=0
_term_size_100=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2359_v0() {
    local command_439
    command_439="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_28181="${command_439}"
    parse_int__13_v0 "${count_28181}"
    __status=$?
    ret_stty_count2359_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2360_v0() {
    stty_count__2359_v0 
    local count_num_28182="${ret_stty_count2359_v0}"
    if [ "$(( count_num_28182 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_28182="$(( count_num_28182 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28182}
    __status=$?
}

# stty_unlock()
stty_unlock__2361_v0() {
    stty_count__2359_v0 
    local count_num_28203="${ret_stty_count2359_v0}"
    if [ "$(( count_num_28203 > 0 ))" != 0 ]; then
        count_num_28203="$(( count_num_28203 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28203}
        __status=$?
        if [ "$(( count_num_28203 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2362_v0() {
    local size_28098="${1}"
    if [ "$([ "_${size_28098}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2362_v0=0
        return 0
    fi
    split__4_v0 "${size_28098}" " "
    local parts_28099=("${ret_split4_v0[@]}")
    local __length_440=("${parts_28099[@]}")
    if [ "$(( ${#__length_440[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2362_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_28099[1]?"Index out of bounds (at src/./file/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_28099[0]?"Index out of bounds (at src/./file/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_100=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2362_v0=1
    return 0
}

# query_term_size()
query_term_size__2363_v0() {
    local command_442
    command_442="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_28101="${command_442}"
    store_term_size__2362_v0 "${size_28101}"
    ret_query_term_size2363_v0="${ret_store_term_size2362_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2364_v0() {
    local command_443
    command_443="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_28097="${command_443}"
    store_term_size__2362_v0 "${size_28097}"
    ret_stty_term_size2364_v0="${ret_store_term_size2362_v0}"
    return 0
}

# get_term_size()
get_term_size__2365_v0() {
    stty_term_size__2364_v0 
    local detected_28100="${ret_stty_term_size2364_v0}"
    if [ "$(( ! detected_28100 ))" != 0 ]; then
        query_term_size__2363_v0 
        detected_28100="${ret_query_term_size2363_v0}"
    fi
    _got_term_size_99=1
}

# term_width()
term_width__2367_v0() {
    if [ "$(( ! _got_term_size_99 ))" != 0 ]; then
        get_term_size__2365_v0 
    fi
    ret_term_width2367_v0="${_term_size_100[0]?"Index out of bounds (at src/./file/../utils/term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# remove_current_line()
remove_current_line__2371_v0() {
    local array_444=("")
    eprintf__2336_v0 "\\x1b[2K\\x1b[G" array_444[@]
}

# move the cursor up or down `cnt` lines.
# print_wrapped(pieces: [Text])
print_wrapped__2379_v0() {
    local pieces_28096=("${!1}")
    term_width__2367_v0 
    local width_28102="${ret_term_width2367_v0}"
    local line_28103=""
    local line_len_28104=0
    for piece_28105 in "${pieces_28096[@]}"; do
        local __length_447="${piece_28105}"
        local piece_len_28106="${#__length_447}"
        has_ansi_escape__2349_v0 "${piece_28105}"
        local ret_has_ansi_escape2349_v0__186_12="${ret_has_ansi_escape2349_v0}"
        if [ "${ret_has_ansi_escape2349_v0__186_12}" != 0 ]; then
            get_visible_len__2353_v0 "${piece_28105}"
            piece_len_28106="${ret_get_visible_len2353_v0}"
        fi
        if [ "$([ "_${line_28103}" != "_" ]; echo $?)" != 0 ]; then
            line_28103="${piece_28105}"
            line_len_28104="${piece_len_28106}"
        elif [ "$(( $(( $(( line_len_28104 + 1 )) + piece_len_28106 )) > width_28102 ))" != 0 ]; then
            local array_448=()
            printf__128_v0 "${line_28103}""
" array_448[@]
            line_28103="${piece_28105}"
            line_len_28104="${piece_len_28106}"
        else
            line_28103+=" ""${piece_28105}"
            line_len_28104="$(( line_len_28104 + $(( 1 + piece_len_28106 )) ))"
        fi
    done
    if [ "$([ "_${line_28103}" == "_" ]; echo $?)" != 0 ]; then
        local array_449=()
        printf__128_v0 "${line_28103}""
" array_449[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_101=3
# get_directory_entries(path: Text)
get_directory_entries__2401_v0() {
    local path_28186="${1}"
    local __ls_path_450="${path_28186}"
    __ls_path_450="${__ls_path_450//\\/\\\\}"
    (( 1 )) && __ls_all_450="-A" || __ls_all_450=""
    (( 0 )) && __ls_rec_450="-R" || __ls_rec_450=""
    local __ls_450=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_450 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_450} ${__ls_rec_450} ${__ls_path_450}
    __status=$?
    );
    local names_28187=("${__ls_450[@]}")
    local command_451
    command_451="$(LC_ALL=C ls -lA "${path_28186}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_28188="${command_451}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_452
    command_452="$(LC_ALL=C ls -lA "${path_28186}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_28189="${command_452}"
    split__4_v0 "${types_output_28188}" "
"
    local types_28190=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_28189}" "
"
    local targets_28191=("${ret_split4_v0[@]}")
    local entries_28192=()
    local __range_start_28193=0
    local __length_454=("${names_28187[@]}")
    local __range_end_28193="${#__length_454[@]}"
    local __dir_28193=$(( ${__range_start_28193} <= ${__range_end_28193} ? 1 : -1 ))
    for (( i_28193=${__range_start_28193}; i_28193 * ${__dir_28193} < ${__range_end_28193} * ${__dir_28193}; i_28193+=${__dir_28193} )); do
        local array_455=("${names_28187[${i_28193}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_28192+=("${array_455[@]}")
        local array_456=("${types_28190[${i_28193}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_28192+=("${array_456[@]}")
        slice__24_v0 "${targets_28191[${i_28193}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_457=("${ret_slice24_v0__31_21}")
        entries_28192+=("${array_457[@]}")
done
    ret_get_directory_entries2401_v0=("${entries_28192[@]}")
    return 0
}

# get_cwd()
get_cwd__2402_v0() {
    local command_458
    command_458="$(pwd)"
    __status=$?
    ret_get_cwd2402_v0="${command_458}"
    return 0
}

# normalize_path(path: Text)
normalize_path__2403_v0() {
    local path_28184="${1}"
    local command_459
    command_459="$(cd "${path_28184}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_28185="${command_459}"
    if [ "$([ "_${normalized_28185}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path2403_v0="${path_28184}"
        return 0
    fi
    ret_normalize_path2403_v0="${normalized_28185}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__2404_v0() {
    local base_28361="${1}"
    local child_28362="${2}"
    if [ "$([ "_${base_28361}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join2404_v0="/""${child_28362}"
        return 0
    fi
    ret_path_join2404_v0="${base_28361}""/""${child_28362}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__2405_v0() {
    local path_28359="${1}"
    local command_460
    command_460="$(dirname "${path_28359}")"
    __status=$?
    local parent_28360="${command_460}"
    ret_get_parent_dir2405_v0="${parent_28360}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_103="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_104=0
_primary_color_105=(3 207 159 92)
_secondary_color_106=(3 118 206 94)
_accent_color_107=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__2416_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_28131="${ret_env_var_get120_v0}"
    _supports_truecolor_103="$(if [ "$([ "_${config_28131}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2416_v0="$([ "_${_supports_truecolor_103}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2417_v0() {
    local message_28126="${1}"
    local r_28127="${2}"
    local g_28128="${3}"
    local b_28129="${4}"
    local fallback_28130="${5}"
    if [ "$([ "_${_supports_truecolor_103}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2417_v0="\\x1b[38;2;${r_28127};${g_28128};${b_28129}m""${message_28126}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_103}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2416_v0 
        local ret_get_supports_truecolor2416_v0__45_17="${ret_get_supports_truecolor2416_v0}"
        if [ "${ret_get_supports_truecolor2416_v0__45_17}" != 0 ]; then
            ret_colored_rgb2417_v0="\\x1b[38;2;${r_28127};${g_28128};${b_28129}m""${message_28126}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_28130 == 0 ))" != 0 ]; then
            ret_colored_rgb2417_v0="${message_28126}"
            return 0
        else
            ret_colored_rgb2417_v0="\\x1b[${fallback_28130}m""${message_28126}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_28130 == 0 ))" != 0 ]; then
            ret_colored_rgb2417_v0="${message_28126}"
            return 0
        fi
        ret_colored_rgb2417_v0="\\x1b[${fallback_28130}m""${message_28126}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2419_v0() {
    if [ "$(( ! _got_xylitol_colors_104 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_28120="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_28120}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_28120}" ";"
            local parts_28121=("${ret_split4_v0[@]}")
            local __length_464=("${parts_28121[@]}")
            if [ "$(( ${#__length_464[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28121[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28121[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28121[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28121[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_105=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_28122="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_28122}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_28122}" ";"
            local parts_28123=("${ret_split4_v0[@]}")
            local __length_466=("${parts_28123[@]}")
            if [ "$(( ${#__length_466[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28123[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28123[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28123[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28123[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_106=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_28124="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_28124}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_28124}" ";"
            local parts_28125=("${ret_split4_v0[@]}")
            local __length_468=("${parts_28125[@]}")
            if [ "$(( ${#__length_468[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28125[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28125[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28125[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28125[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2419_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_107=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_104=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2420_v0() {
    inner_get_xylitol_colors__2419_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_104=1
}

# colored_primary(message: Text)
colored_primary__2421_v0() {
    local message_28119="${1}"
    if [ "$(( ! _got_xylitol_colors_104 ))" != 0 ]; then
        get_xylitol_colors__2420_v0 
    fi
    colored_rgb__2417_v0 "${message_28119}" "${_primary_color_105[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_105[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_105[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_105[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2421_v0="${ret_colored_rgb2417_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2422_v0() {
    local message_28133="${1}"
    if [ "$(( ! _got_xylitol_colors_104 ))" != 0 ]; then
        get_xylitol_colors__2420_v0 
    fi
    colored_rgb__2417_v0 "${message_28133}" "${_secondary_color_106[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_106[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_106[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_106[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2422_v0="${ret_colored_rgb2417_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2423_v0() {
    local message_28299="${1}"
    if [ "$(( ! _got_xylitol_colors_104 ))" != 0 ]; then
        get_xylitol_colors__2420_v0 
    fi
    colored_rgb__2417_v0 "${message_28299}" "${_accent_color_107[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_107[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_107[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_107[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent2423_v0="${ret_colored_rgb2417_v0}"
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
colored__2475_v0() {
    local message_28167="${1}"
    local color_28168="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2475_v0="\\x1b[${color_28168}m""${message_28167}""\\x1b[0m"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_111=0
_term_size_112=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__2519_v0() {
    local size_28146="${1}"
    if [ "$([ "_${size_28146}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2519_v0=0
        return 0
    fi
    split__4_v0 "${size_28146}" " "
    local parts_28147=("${ret_split4_v0[@]}")
    local __length_471=("${parts_28147[@]}")
    if [ "$(( ${#__length_471[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2519_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_28147[1]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_28147[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_112=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2519_v0=1
    return 0
}

# query_term_size()
query_term_size__2520_v0() {
    local command_473
    command_473="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_28149="${command_473}"
    store_term_size__2519_v0 "${size_28149}"
    ret_query_term_size2520_v0="${ret_store_term_size2519_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2521_v0() {
    local command_474
    command_474="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_28145="${command_474}"
    store_term_size__2519_v0 "${size_28145}"
    ret_stty_term_size2521_v0="${ret_store_term_size2519_v0}"
    return 0
}

# get_term_size()
get_term_size__2522_v0() {
    stty_term_size__2521_v0 
    local detected_28148="${ret_stty_term_size2521_v0}"
    if [ "$(( ! detected_28148 ))" != 0 ]; then
        query_term_size__2520_v0 
        detected_28148="${ret_query_term_size2520_v0}"
    fi
    _got_term_size_111=1
}

# term_width()
term_width__2524_v0() {
    if [ "$(( ! _got_term_size_111 ))" != 0 ]; then
        get_term_size__2522_v0 
    fi
    ret_term_width2524_v0="${_term_size_112[0]?"Index out of bounds (at src/./file/../utils/widget/../term.ab:96:23)"}"
    return 0
}

# // Cursor /////
# move the cursor up or down `cnt` lines.
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2538_v0() {
    local pending_28164="${1}"
    local line_28165="${2}"
    local note_at_28166="${3}"
    if [ "$(( note_at_28166 < 0 ))" != 0 ]; then
        local array_475=()
        printf__128_v0 "${pending_28164}""${line_28165}""
" array_475[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_28166 == 0 ))" != 0 ]; then
        colored__2475_v0 "${line_28165}" 90
        local ret_colored2475_v0__12_40="${ret_colored2475_v0}"
        local array_476=()
        printf__128_v0 "${pending_28164}""${ret_colored2475_v0__12_40}""
" array_476[@]
    else
        slice__24_v0 "${line_28165}" 0 "${note_at_28166}"
        local ret_slice24_v0__13_32="${ret_slice24_v0}"
        slice__24_v0 "${line_28165}" "${note_at_28166}" 0
        local ret_slice24_v0__13_66="${ret_slice24_v0}"
        colored__2475_v0 "${ret_slice24_v0__13_66}" 90
        local ret_colored2475_v0__13_58="${ret_colored2475_v0}"
        local array_477=()
        printf__128_v0 "${pending_28164}""${ret_slice24_v0__13_32}""${ret_colored2475_v0__13_58}""
" array_477[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2539_v0() {
    local names_28137=("${!1}")
    local texts_28138=("${!2}")
    local notes_28139=("${!3}")
    local min_name_width_28140="${4}"
    local __length_478=("${names_28137[@]}")
    local count_28141="${#__length_478[@]}"
    local name_width_28142="${min_name_width_28140}"
    local __range_start_28143=0
    local __range_end_28143="${count_28141}"
    local __dir_28143=$(( ${__range_start_28143} <= ${__range_end_28143} ? 1 : -1 ))
    for (( i_28143=${__range_start_28143}; i_28143 * ${__dir_28143} < ${__range_end_28143} * ${__dir_28143}; i_28143+=${__dir_28143} )); do
        local __length_479="${names_28137[${i_28143}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:28:33)"}"
        local width_28144="${#__length_479}"
        if [ "$(( width_28144 > name_width_28142 ))" != 0 ]; then
            name_width_28142="${width_28144}"
        fi
done
    term_width__2524_v0 
    local width_28150="${ret_term_width2524_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_28151="$(( name_width_28142 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_28152="$(( $(( width_28150 - indent_28151 )) < 24 ))"
    if [ "${stacked_28152}" != 0 ]; then
        indent_28151=6
    fi
    local avail_28153="$(( width_28150 - indent_28151 ))"
    rpad__28_v0 "" " " "${indent_28151}"
    local blank_28154="${ret_rpad28_v0}"
    local __range_start_28155=0
    local __range_end_28155="${count_28141}"
    local __dir_28155=$(( ${__range_start_28155} <= ${__range_end_28155} ? 1 : -1 ))
    for (( i_28155=${__range_start_28155}; i_28155 * ${__dir_28155} < ${__range_end_28155} * ${__dir_28155}; i_28155+=${__dir_28155} )); do
        local pending_28156="${blank_28154}"
        if [ "${stacked_28152}" != 0 ]; then
            local array_480=()
            printf__128_v0 "  ""${names_28137[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:48:33)"}""
" array_480[@]
        else
            rpad__28_v0 "  ""${names_28137[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:50:41)"}" " " "${indent_28151}"
            local ret_rpad28_v0__50_23="${ret_rpad28_v0}"
            pending_28156="${ret_rpad28_v0__50_23}"
        fi
        split__4_v0 "${texts_28138[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:52:33)"}" " "
        local ret_split4_v0__52_21=("${ret_split4_v0[@]}")
        local words_28157=("${ret_split4_v0__52_21[@]}")
        local __length_481=("${words_28157[@]}")
        local note_start_28158="${#__length_481[@]}"
        if [ "$([ "_${notes_28139[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:54:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_482="${notes_28139[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:57:26)"}"
            if [ "$(( ${#__length_482} > avail_28153 ))" != 0 ]; then
                split__4_v0 "${notes_28139[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:58:38)"}" " "
                local ret_split4_v0__58_26=("${ret_split4_v0[@]}")
                words_28157+=("${ret_split4_v0__58_26[@]}")
            else
                local array_483=("${notes_28139[${i_28155}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:60:33)"}")
                words_28157+=("${array_483[@]}")
            fi
        fi
        local line_28159=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_28160=-1
        local __range_start_28161=0
        local __length_484=("${words_28157[@]}")
        local __range_end_28161="${#__length_484[@]}"
        local __dir_28161=$(( ${__range_start_28161} <= ${__range_end_28161} ? 1 : -1 ))
        for (( j_28161=${__range_start_28161}; j_28161 * ${__dir_28161} < ${__range_end_28161} * ${__dir_28161}; j_28161+=${__dir_28161} )); do
            local word_28162="${words_28157[${j_28161}]?"Index out of bounds (at src/./file/../utils/widget/help.ab:70:32)"}"
            local candidate_28163
            candidate_28163="$(if [ "$([ "_${line_28159}" != "_" ]; echo $?)" != 0 ]; then echo "${word_28162}"; else echo "${line_28159}"" ""${word_28162}"; fi)"
            local __length_485="${candidate_28163}"
            if [ "$(( $(( ${#__length_485} > avail_28153 )) && $([ "_${line_28159}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2538_v0 "${pending_28156}" "${line_28159}" "${note_at_28160}"
                pending_28156="${blank_28154}"
                line_28159="${word_28162}"
                note_at_28160="$(if [ "$(( j_28161 >= note_start_28158 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_28161 >= note_start_28158 )) && $(( note_at_28160 < 0 )) ))" != 0 ]; then
                    local __length_486="${candidate_28163}"
                    local __length_487="${word_28162}"
                    note_at_28160="$(( ${#__length_486} - ${#__length_487} ))"
                fi
                line_28159="${candidate_28163}"
            fi
done
        print_help_line__2538_v0 "${pending_28156}" "${line_28159}" "${note_at_28160}"
done
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__2640_v0() {
    local command_488
    command_488="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_28333="${command_488}"
    if [ "$([ "_${var_28333}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2640_v0="UP"
        return 0
    elif [ "$([ "_${var_28333}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2640_v0="DOWN"
        return 0
    elif [ "$([ "_${var_28333}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2640_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_28333}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2640_v0="LEFT"
        return 0
    elif [ "$([ "_${var_28333}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2640_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_28333}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2640_v0="INPUT"
        return 0
    else
        ret_get_key2640_v0="${var_28333}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2642_v0() {
    local format_28262="${1}"
    local args_28263=("${!2}")
    args_28263=("${format_28262}" "${args_28263[@]}")
    __status=$?
    printf "${args_28263[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2643_v0() {
    local message_28267="${1}"
    local color_28268="${2}"
    # Prints an error message with a specified color.
    local array_489=("${message_28267}")
    eprintf__2642_v0 "\\x1b[${color_28268}m%s\\x1b[0m" array_489[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2658_v0() {
    local format_28215="${1}"
    local args_28216=("${!2}")
    args_28216=("${format_28215}" "${args_28216[@]}")
    __status=$?
    printf "${args_28216[@]}" >&2
    __status=$?
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_115=0
_term_size_116=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2681_v0() {
    local command_491
    command_491="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_28213="${command_491}"
    parse_int__13_v0 "${count_28213}"
    __status=$?
    ret_stty_count2681_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2682_v0() {
    stty_count__2681_v0 
    local count_num_28214="${ret_stty_count2681_v0}"
    if [ "$(( count_num_28214 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_28214="$(( count_num_28214 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28214}
    __status=$?
}

# stty_unlock()
stty_unlock__2683_v0() {
    stty_count__2681_v0 
    local count_num_28356="${ret_stty_count2681_v0}"
    if [ "$(( count_num_28356 > 0 ))" != 0 ]; then
        count_num_28356="$(( count_num_28356 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28356}
        __status=$?
        if [ "$(( count_num_28356 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2684_v0() {
    local size_28218="${1}"
    if [ "$([ "_${size_28218}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2684_v0=0
        return 0
    fi
    split__4_v0 "${size_28218}" " "
    local parts_28219=("${ret_split4_v0[@]}")
    local __length_492=("${parts_28219[@]}")
    if [ "$(( ${#__length_492[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2684_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_28219[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:41)"}"
    __status=$?
    local ret_parse_int13_v0__53_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_28219[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:68)"}"
    __status=$?
    local ret_parse_int13_v0__53_52="${ret_parse_int13_v0}"
    _term_size_116=("${ret_parse_int13_v0__53_25}" "${ret_parse_int13_v0__53_52}")
    ret_store_term_size2684_v0=1
    return 0
}

# query_term_size()
query_term_size__2685_v0() {
    local command_494
    command_494="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_28221="${command_494}"
    store_term_size__2684_v0 "${size_28221}"
    ret_query_term_size2685_v0="${ret_store_term_size2684_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2686_v0() {
    local command_495
    command_495="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_28217="${command_495}"
    store_term_size__2684_v0 "${size_28217}"
    ret_stty_term_size2686_v0="${ret_store_term_size2684_v0}"
    return 0
}

# get_term_size()
get_term_size__2687_v0() {
    stty_term_size__2686_v0 
    local detected_28220="${ret_stty_term_size2686_v0}"
    if [ "$(( ! detected_28220 ))" != 0 ]; then
        query_term_size__2685_v0 
        detected_28220="${ret_query_term_size2685_v0}"
    fi
    _got_term_size_115=1
}

# term_width()
term_width__2689_v0() {
    if [ "$(( ! _got_term_size_115 ))" != 0 ]; then
        get_term_size__2687_v0 
    fi
    ret_term_width2689_v0="${_term_size_116[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:96:23)"}"
    return 0
}

# term_height()
term_height__2690_v0() {
    if [ "$(( ! _got_term_size_115 ))" != 0 ]; then
        get_term_size__2687_v0 
    fi
    ret_term_height2690_v0="${_term_size_116[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:104:23)"}"
    return 0
}

# // Cursor /////
# remove_line(cnt: Int)
remove_line__2692_v0() {
    local cnt_28330="${1}"
    if [ "$(( cnt_28330 > 0 ))" != 0 ]; then
        local sequence_28331=""
        local __range_start_28332=0
        local __range_end_28332="${cnt_28330}"
        local __dir_28332=$(( ${__range_start_28332} <= ${__range_end_28332} ? 1 : -1 ))
        for (( ____28332=${__range_start_28332}; ____28332 * ${__dir_28332} < ${__range_end_28332} * ${__dir_28332}; ____28332+=${__dir_28332} )); do
            sequence_28331+="\\x1b[2K\\x1b[1A"
done
        local array_496=("")
        eprintf__2658_v0 "${sequence_28331}" array_496[@]
    fi
    local array_497=("")
    eprintf__2658_v0 "\\x1b[G" array_497[@]
}

# remove_current_line()
remove_current_line__2693_v0() {
    local array_498=("")
    eprintf__2658_v0 "\\x1b[2K\\x1b[G" array_498[@]
}

# print_blank(cnt: Int)
print_blank__2694_v0() {
    local cnt_28321="${1}"
    printf '%*s' "${cnt_28321}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2695_v0() {
    local cnt_28265="${1}"
    local __range_start_28266=0
    local __range_end_28266="${cnt_28265}"
    local __dir_28266=$(( ${__range_start_28266} <= ${__range_end_28266} ? 1 : -1 ))
    for (( ____28266=${__range_start_28266}; ____28266 * ${__dir_28266} < ${__range_end_28266} * ${__dir_28266}; ____28266+=${__dir_28266} )); do
        local array_499=("")
        eprintf__2658_v0 "
" array_499[@]
done
}

# go_up(cnt: Int)
go_up__2696_v0() {
    local cnt_28288="${1}"
    local array_500=("")
    eprintf__2658_v0 "\\x1b[${cnt_28288}A" array_500[@]
}

# go_down(cnt: Int)
go_down__2697_v0() {
    local cnt_28342="${1}"
    local array_501=("")
    eprintf__2658_v0 "\\x1b[${cnt_28342}B" array_501[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2698_v0() {
    local cnt_28351="${1}"
    if [ "$(( cnt_28351 > 0 ))" != 0 ]; then
        go_down__2697_v0 "${cnt_28351}"
    else
        go_up__2696_v0 "$(( - cnt_28351 ))"
    fi
}

# hide_cursor()
hide_cursor__2699_v0() {
    local array_502=("")
    eprintf__2658_v0 "\\x1b[?25l" array_502[@]
}

# show_cursor()
show_cursor__2700_v0() {
    local array_503=("")
    eprintf__2658_v0 "\\x1b[?25h" array_503[@]
}

# How many elements one entry takes up in `get_directory_entries`.
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_119="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_120=0
_secondary_color_122=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2738_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_28320="${ret_env_var_get120_v0}"
    _supports_truecolor_119="$(if [ "$([ "_${config_28320}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2738_v0="$([ "_${_supports_truecolor_119}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2739_v0() {
    local message_28315="${1}"
    local r_28316="${2}"
    local g_28317="${3}"
    local b_28318="${4}"
    local fallback_28319="${5}"
    if [ "$([ "_${_supports_truecolor_119}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2739_v0="\\x1b[38;2;${r_28316};${g_28317};${b_28318}m""${message_28315}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_119}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2738_v0 
        local ret_get_supports_truecolor2738_v0__45_17="${ret_get_supports_truecolor2738_v0}"
        if [ "${ret_get_supports_truecolor2738_v0__45_17}" != 0 ]; then
            ret_colored_rgb2739_v0="\\x1b[38;2;${r_28316};${g_28317};${b_28318}m""${message_28315}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_28319 == 0 ))" != 0 ]; then
            ret_colored_rgb2739_v0="${message_28315}"
            return 0
        else
            ret_colored_rgb2739_v0="\\x1b[${fallback_28319}m""${message_28315}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_28319 == 0 ))" != 0 ]; then
            ret_colored_rgb2739_v0="${message_28315}"
            return 0
        fi
        ret_colored_rgb2739_v0="\\x1b[${fallback_28319}m""${message_28315}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2741_v0() {
    if [ "$(( ! _got_xylitol_colors_120 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_28309="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_28309}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_28309}" ";"
            local parts_28310=("${ret_split4_v0[@]}")
            local __length_507=("${parts_28310[@]}")
            if [ "$(( ${#__length_507[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28310[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28310[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28310[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28310[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_28311="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_28311}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_28311}" ";"
            local parts_28312=("${ret_split4_v0[@]}")
            local __length_509=("${parts_28312[@]}")
            if [ "$(( ${#__length_509[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28312[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28312[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28312[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28312[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_122=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_28313="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_28313}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_28313}" ";"
            local parts_28314=("${ret_split4_v0[@]}")
            local __length_511=("${parts_28314[@]}")
            if [ "$(( ${#__length_511[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28314[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28314[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28314[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28314[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2741_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_120=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2742_v0() {
    inner_get_xylitol_colors__2741_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_120=1
}

# colored_secondary(message: Text)
colored_secondary__2744_v0() {
    local message_28308="${1}"
    if [ "$(( ! _got_xylitol_colors_120 ))" != 0 ]; then
        get_xylitol_colors__2742_v0 
    fi
    colored_rgb__2739_v0 "${message_28308}" "${_secondary_color_122[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_122[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_122[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_122[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2744_v0="${ret_colored_rgb2739_v0}"
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_124="None"
# perl_available()
perl_available__2761_v0() {
    if [ "$([ "_${_perl_state_124}" != "_None" ]; echo $?)" != 0 ]; then
        local command_513
        command_513="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_28232
        disabled_28232="$([ "_${command_513}" != "_No" ]; echo $?)"
        local command_514
        command_514="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_28233
        found_28233="$(( $(( ! disabled_28232 )) && $([ "_${command_514}" != "_0" ]; echo $?) ))"
        _perl_state_124="$(if [ "${found_28233}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2761_v0="$([ "_${_perl_state_124}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2762_v0() {
    local text_28231="${1}"
    perl_available__2761_v0 
    local ret_perl_available2761_v0__22_12="${ret_perl_available2761_v0}"
    if [ "$(( ! ret_perl_available2761_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2762_v0=''
        return 1
    fi
    local command_515
    command_515="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_28231}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2762_v0=''
        return "${__status}"
    fi
    local width_str_28234="${command_515}"
    parse_int__13_v0 "${width_str_28234}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2762_v0=''
        return "${__status}"
    fi
    local width_28235="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2762_v0="${width_28235}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2763_v0() {
    local text_28244="${1}"
    local max_width_28245="${2}"
    perl_available__2761_v0 
    local ret_perl_available2761_v0__33_12="${ret_perl_available2761_v0}"
    if [ "$(( ! ret_perl_available2761_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2763_v0=''
        return 1
    fi
    local command_516
    command_516="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_28244}" ${max_width_28245} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2763_v0=''
        return "${__status}"
    fi
    local result_28246="${command_516}"
    ret_perl_truncate_cjk2763_v0="${result_28246}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2767_v0() {
    local text_28239="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_517
    command_517="$([[ "${text_28239}" == *$'\x1b'* || "${text_28239}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_28240="${command_517}"
    ret_has_ansi_escape2767_v0="$([ "_${has_escape_28240}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2769_v0() {
    local text_28227="${1}"
    local command_518
    command_518="$(printf "%s" "${text_28227}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2769_v0="${command_518}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2770_v0() {
    local text_28229="${1}"
    local command_519
    command_519="$(printf "%s" "${text_28229}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_28230="${command_519}"
    ret_is_all_ascii2770_v0="$([ "_${result_28230}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2771_v0() {
    local text_28226="${1}"
    strip_ansi__2769_v0 "${text_28226}"
    local stripped_28228="${ret_strip_ansi2769_v0}"
    # Check if text is all ASCII
    is_all_ascii__2770_v0 "${stripped_28228}"
    local ret_is_all_ascii2770_v0__36_12="${ret_is_all_ascii2770_v0}"
    if [ "$(( ! ret_is_all_ascii2770_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2762_v0 "${stripped_28228}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_520="${stripped_28228}"
            ret_get_visible_len2771_v0="${#__length_520}"
            return 0
        fi
        ret_get_visible_len2771_v0="${ret_perl_get_cjk_width2762_v0}"
        return 0
    else
        local __length_521="${stripped_28228}"
        ret_get_visible_len2771_v0="${#__length_521}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2772_v0() {
    local text_28241="${1}"
    local max_width_28242="${2}"
    get_visible_len__2771_v0 "${text_28241}"
    local visible_len_28243="${ret_get_visible_len2771_v0}"
    if [ "$(( visible_len_28243 <= max_width_28242 ))" != 0 ]; then
        ret_truncate_text2772_v0="${text_28241}"
        return 0
    fi
    is_all_ascii__2770_v0 "${text_28241}"
    local ret_is_all_ascii2770_v0__53_12="${ret_is_all_ascii2770_v0}"
    if [ "$(( ! ret_is_all_ascii2770_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__2763_v0 "${text_28241}" "${max_width_28242}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_28241}" | cut -c1-${max_width_28242}
            __status=$?
        fi
        ret_truncate_text2772_v0="${ret_perl_truncate_cjk2763_v0}"
        return 0
    fi
    local command_522
    command_522="$(printf "%s" "${text_28241}" | cut -c1-${max_width_28242})"
    __status=$?
    ret_truncate_text2772_v0="${command_522}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2773_v0() {
    local text_28237="${1}"
    local max_width_28238="${2}"
    has_ansi_escape__2767_v0 "${text_28237}"
    local ret_has_ansi_escape2767_v0__65_12="${ret_has_ansi_escape2767_v0}"
    if [ "$(( ! ret_has_ansi_escape2767_v0__65_12 ))" != 0 ]; then
        truncate_text__2772_v0 "${text_28237}" "${max_width_28238}"
        ret_truncate_ansi2773_v0="${ret_truncate_text2772_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_523
    command_523="$([[ "${text_28237}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_28247="${command_523}"
    # Replace \x1b[ with newline, then split
    local command_524
    command_524="$(t="${text_28237}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_28248="${command_524}"
    split__4_v0 "${replaced_28248}" "
"
    local parts_28249=("${ret_split4_v0[@]}")
    local result_28250=""
    local remaining_width_28251="${max_width_28238}"
    local __range_start_28252=0
    local __length_525=("${parts_28249[@]}")
    local __range_end_28252="${#__length_525[@]}"
    local __dir_28252=$(( ${__range_start_28252} <= ${__range_end_28252} ? 1 : -1 ))
    for (( idx_28252=${__range_start_28252}; idx_28252 * ${__dir_28252} < ${__range_end_28252} * ${__dir_28252}; idx_28252+=${__dir_28252} )); do
        local part_28253="${parts_28249[${idx_28252}]?"Index out of bounds (at src/./file/../choose/../utils/text/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_28252 == 0 )) && $([ "_${starts_with_ansi_28247}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_28253}" == "_" ]; echo $?) && $(( remaining_width_28251 > 0 )) ))" != 0 ]; then
                truncate_text__2772_v0 "${part_28253}" "${remaining_width_28251}"
                local ret_truncate_text2772_v0__87_35="${ret_truncate_text2772_v0}"
                local truncated_28254="${ret_truncate_text2772_v0__87_35}"
                result_28250+="${truncated_28254}"
                get_visible_len__2771_v0 "${truncated_28254}"
                local ret_get_visible_len2771_v0__89_36="${ret_get_visible_len2771_v0}"
                remaining_width_28251="$(( remaining_width_28251 - ret_get_visible_len2771_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_526
            command_526="$(__p="${part_28253}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_28255="${command_526}"
            if [ "$([ "_${m_idx_28255}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_527
                command_527="$(__p="${part_28253}"; printf "%s" "${__p:0:${m_idx_28255}}")"
                __status=$?
                local ansi_params_28256="${command_527}"
                result_28250+="\\x1b[""${ansi_params_28256}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_28255}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_28257="${ret_parse_int13_v0__100_41}"
                local text_start_28258="$(( m_idx_num_28257 + 1 ))"
                local command_528
                command_528="$(__p="${part_28253}"; printf "%s" "${__p:${text_start_28258}}")"
                __status=$?
                local text_part_28259="${command_528}"
                if [ "$(( $([ "_${text_part_28259}" == "_" ]; echo $?) && $(( remaining_width_28251 > 0 )) ))" != 0 ]; then
                    truncate_text__2772_v0 "${text_part_28259}" "${remaining_width_28251}"
                    local ret_truncate_text2772_v0__104_39="${ret_truncate_text2772_v0}"
                    local truncated_28260="${ret_truncate_text2772_v0__104_39}"
                    result_28250+="${truncated_28260}"
                    get_visible_len__2771_v0 "${truncated_28260}"
                    local ret_get_visible_len2771_v0__106_40="${ret_get_visible_len2771_v0}"
                    remaining_width_28251="$(( remaining_width_28251 - ret_get_visible_len2771_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_28253}" == "_" ]; echo $?) && $(( remaining_width_28251 > 0 )) ))" != 0 ]; then
                    truncate_text__2772_v0 "${part_28253}" "${remaining_width_28251}"
                    local ret_truncate_text2772_v0__111_39="${ret_truncate_text2772_v0}"
                    local truncated_28261="${ret_truncate_text2772_v0__111_39}"
                    result_28250+="${truncated_28261}"
                    get_visible_len__2771_v0 "${truncated_28261}"
                    local ret_get_visible_len2771_v0__113_40="${ret_get_visible_len2771_v0}"
                    remaining_width_28251="$(( remaining_width_28251 - ret_get_visible_len2771_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2773_v0="${result_28250}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2774_v0() {
    local text_28224="${1}"
    local max_width_28225="${2}"
    get_visible_len__2771_v0 "${text_28224}"
    local visible_len_28236="${ret_get_visible_len2771_v0}"
    if [ "$(( visible_len_28236 <= max_width_28225 ))" != 0 ]; then
        ret_cutoff_text2774_v0="${text_28224}"
        return 0
    fi
    truncate_ansi__2773_v0 "${text_28224}" "$(( max_width_28225 - 3 ))"
    local ret_truncate_ansi2773_v0__129_12="${ret_truncate_ansi2773_v0}"
    ret_cutoff_text2774_v0="${ret_truncate_ansi2773_v0__129_12}""..."
    return 0
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# eprintf(format: Text, args: [Text])
eprintf__2795_v0() {
    local format_28277="${1}"
    local args_28278=("${!2}")
    args_28278=("${format_28277}" "${args_28278[@]}")
    __status=$?
    printf "${args_28278[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2796_v0() {
    local message_28275="${1}"
    local color_28276="${2}"
    # Prints an error message with a specified color.
    local array_529=("${message_28275}")
    eprintf__2795_v0 "\\x1b[${color_28276}m%s\\x1b[0m" array_529[@]
}

# colored(message: Text, color: Int)
colored__2797_v0() {
    local message_28279="${1}"
    local color_28280="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2797_v0="\\x1b[${color_28280}m""${message_28279}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2801_v0() {
    local items_28269=("${!1}")
    local total_len_28270="${2}"
    local term_width_28271="${3}"
    local separator_28272=" • "
    local separator_len_28273=3
    # Fast path: no truncation needed
    if [ "$(( total_len_28270 <= term_width_28271 ))" != 0 ]; then
        local iter_28274=0
        while :
        do
            local __length_530=("${items_28269[@]}")
            if [ "$(( iter_28274 >= ${#__length_530[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_28274 > 0 ))" != 0 ]; then
                eprintf_colored__2796_v0 "${separator_28272}" 90
            fi
            colored__2797_v0 "${items_28269[$(( iter_28274 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2797_v0__23_41="${ret_colored2797_v0}"
            local array_531=("")
            eprintf__2795_v0 "${items_28269[${iter_28274}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2797_v0__23_41}" array_531[@]
            iter_28274="$(( iter_28274 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_28281=0
        local first_28282=1
        local iter_28283=0
        while :
        do
            local __length_532=("${items_28269[@]}")
            if [ "$(( iter_28283 >= ${#__length_532[@]} ))" != 0 ]; then
                break
            fi
            local key_28284="${items_28269[${iter_28283}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_28285="${items_28269[$(( iter_28283 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_533="${key_28284}"
            local __length_534="${action_28285}"
            local part_len_28286="$(( $(( ${#__length_533} + 1 )) + ${#__length_534} ))"
            local needed_28287="${part_len_28286}"
            if [ "$(( ! first_28282 ))" != 0 ]; then
                needed_28287="$(( needed_28287 + separator_len_28273 ))"
            fi
            if [ "$(( $(( current_len_28281 + needed_28287 )) > term_width_28271 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_28282 ))" != 0 ]; then
                eprintf_colored__2796_v0 "${separator_28272}" 90
            fi
            colored__2797_v0 "${action_28285}" 2
            local ret_colored2797_v0__51_33="${ret_colored2797_v0}"
            local array_535=("")
            eprintf__2795_v0 "${key_28284}"" ""${ret_colored2797_v0__51_33}" array_535[@]
            current_len_28281="$(( current_len_28281 + needed_28287 ))"
            first_28282=0
            iter_28283="$(( iter_28283 + 2 ))"
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
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# // Cursor /////
# move the cursor up or down `cnt` lines.
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
__CHOOSER_CONTINUE_130=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_131=1
# The user confirmed the selection.
__CHOOSER_DONE_132=2
_total_133=0
_page_size_134=10
_display_count_135=0
_total_pages_136=1
_current_page_137=0
_selected_138=0
_cursor_139="> "
_multi_140=0
_limit_141=-1
_term_width_142=80
_has_header_143=0
_page_144=()
_page_count_145=0
_checked_146=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_147=0
_first_render_148=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_149=0
# render_single_page()
render_single_page__2913_v0() {
    local __length_539="${_cursor_139}"
    local cursor_len_28324="${#__length_539}"
    local max_option_width_28325="$(( $(( _term_width_142 - cursor_len_28324 )) - 1 ))"
    local __range_start_28326=0
    local __range_end_28326="${_page_count_145}"
    local __dir_28326=$(( ${__range_start_28326} <= ${__range_end_28326} ? 1 : -1 ))
    for (( i_28326=${__range_start_28326}; i_28326 * ${__dir_28326} < ${__range_end_28326} * ${__dir_28326}; i_28326+=${__dir_28326} )); do
        cutoff_text__2774_v0 "${_page_144[${i_28326}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_28325}"
        local ret_cutoff_text2774_v0__48_27="${ret_cutoff_text2774_v0}"
        local truncated_28327="${ret_cutoff_text2774_v0__48_27}"
        if [ "$(( i_28326 == _selected_138 ))" != 0 ]; then
            colored_secondary__2744_v0 "${_cursor_139}""${truncated_28327}""
"
            local ret_colored_secondary2744_v0__50_21="${ret_colored_secondary2744_v0}"
            local array_540=("")
            eprintf__2642_v0 "${ret_colored_secondary2744_v0__50_21}" array_540[@]
        else
            print_blank__2694_v0 "${cursor_len_28324}"
            local array_541=("")
            eprintf__2642_v0 "${truncated_28327}""
" array_541[@]
        fi
done
    local remaining_slots_28328="$(( _display_count_135 - _page_count_145 ))"
    if [ "$(( remaining_slots_28328 > 0 ))" != 0 ]; then
        local __range_start_28329=0
        local __range_end_28329="${remaining_slots_28328}"
        local __dir_28329=$(( ${__range_start_28329} <= ${__range_end_28329} ? 1 : -1 ))
        for (( ____28329=${__range_start_28329}; ____28329 * ${__dir_28329} < ${__range_end_28329} * ${__dir_28329}; ____28329+=${__dir_28329} )); do
            local array_542=("")
            eprintf__2642_v0 "\\x1b[K
" array_542[@]
done
    fi
}

# render_multi_page()
render_multi_page__2914_v0() {
    local __length_543="${_cursor_139}"
    local cursor_len_28301="${#__length_543}"
    local max_option_width_28302="$(( $(( _term_width_142 - cursor_len_28301 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2919_v0 
    local page_start_28303="${ret_chooser_page_start2919_v0}"
    local __range_start_28304=0
    local __range_end_28304="${_page_count_145}"
    local __dir_28304=$(( ${__range_start_28304} <= ${__range_end_28304} ? 1 : -1 ))
    for (( i_28304=${__range_start_28304}; i_28304 * ${__dir_28304} < ${__range_end_28304} * ${__dir_28304}; i_28304+=${__dir_28304} )); do
        local global_idx_28305="$(( page_start_28303 + i_28304 ))"
        local check_mark_28306
        check_mark_28306="$(if [ "${_checked_146[${global_idx_28305}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2774_v0 "${_page_144[${i_28304}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_28302}"
        local ret_cutoff_text2774_v0__71_27="${ret_cutoff_text2774_v0}"
        local truncated_28307="${ret_cutoff_text2774_v0__71_27}"
        if [ "$(( i_28304 == _selected_138 ))" != 0 ]; then
            colored_secondary__2744_v0 "${_cursor_139}""${check_mark_28306}""${truncated_28307}""
"
            local ret_colored_secondary2744_v0__73_37="${ret_colored_secondary2744_v0}"
            local array_544=("")
            eprintf__2642_v0 "${ret_colored_secondary2744_v0__73_37}" array_544[@]
        elif [ "${_checked_146[${global_idx_28305}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2694_v0 "${cursor_len_28301}"
            colored_secondary__2744_v0 "${check_mark_28306}""${truncated_28307}""
"
            local ret_colored_secondary2744_v0__76_25="${ret_colored_secondary2744_v0}"
            local array_545=("")
            eprintf__2642_v0 "${ret_colored_secondary2744_v0__76_25}" array_545[@]
        else
            print_blank__2694_v0 "${cursor_len_28301}"
            local array_546=("")
            eprintf__2642_v0 "${check_mark_28306}""${truncated_28307}""
" array_546[@]
        fi
done
    local remaining_slots_28322="$(( _display_count_135 - _page_count_145 ))"
    if [ "$(( remaining_slots_28322 > 0 ))" != 0 ]; then
        local __range_start_28323=0
        local __range_end_28323="${remaining_slots_28322}"
        local __dir_28323=$(( ${__range_start_28323} <= ${__range_end_28323} ? 1 : -1 ))
        for (( ____28323=${__range_start_28323}; ____28323 * ${__dir_28323} < ${__range_end_28323} * ${__dir_28323}; ____28323+=${__dir_28323} )); do
            local array_547=("")
            eprintf__2642_v0 "\\x1b[K
" array_547[@]
done
    fi
}

# render_page()
render_page__2915_v0() {
    if [ "${_multi_140}" != 0 ]; then
        render_multi_page__2914_v0 
    else
        render_single_page__2913_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2916_v0() {
    if [ "$(( _total_pages_136 > 1 ))" != 0 ]; then
        local array_548=("")
        eprintf__2642_v0 "\\x1b[G\\x1b[K" array_548[@]
        eprintf_colored__2643_v0 "Page $(( _current_page_137 + 1 ))/${_total_pages_136}" 90
        local array_549=("")
        eprintf__2642_v0 "\\x1b[G" array_549[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2917_v0() {
    if [ "$(( ! _multi_140 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_136 > 1 ))" != 0 ]; then
            local array_550=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2801_v0 array_550[@] 36 "${_term_width_142}"
        else
            local array_551=("↑↓" "select" "enter" "confirm")
            render_tooltip__2801_v0 array_551[@] 25 "${_term_width_142}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_136 > 1 )) && $(( _limit_141 < 0 )) ))" != 0 ]; then
            local array_552=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2801_v0 array_552[@] 55 "${_term_width_142}"
        elif [ "$(( _total_pages_136 > 1 ))" != 0 ]; then
            local array_553=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2801_v0 array_553[@] 47 "${_term_width_142}"
        elif [ "$(( _limit_141 < 0 ))" != 0 ]; then
            local array_554=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2801_v0 array_554[@] 44 "${_term_width_142}"
        else
            local array_555=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2801_v0 array_555[@] 36 "${_term_width_142}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2918_v0() {
    local total_28207="${1}"
    local page_size_28208="${2}"
    local header_28209="${3}"
    local cursor_28210="${4}"
    local multi_28211="${5}"
    local limit_28212="${6}"
    _total_133="${total_28207}"
    _cursor_139="${cursor_28210}"
    _multi_140="${multi_28211}"
    _limit_141="${limit_28212}"
    _current_page_137=0
    _selected_138=0
    _first_render_148=1
    _up_paged_149=0
    _checked_count_147=0
    _has_header_143="$([ "_${header_28209}" == "_" ]; echo $?)"
    stty_lock__2682_v0 
    hide_cursor__2699_v0 
    term_width__2689_v0 
    _term_width_142="${ret_term_width2689_v0}"
    term_height__2690_v0 
    local term_height_28222="${ret_term_height2690_v0}"
    local max_page_size_28223
    max_page_size_28223="$(( term_height_28222 - $(if [ "${_has_header_143}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_134="${page_size_28208}"
    if [ "$(( _page_size_134 > max_page_size_28223 ))" != 0 ]; then
        _page_size_134="${max_page_size_28223}"
    fi
    if [ "${_has_header_143}" != 0 ]; then
        cutoff_text__2774_v0 "${header_28209}" "${_term_width_142}"
        local ret_cutoff_text2774_v0__157_17="${ret_cutoff_text2774_v0}"
        local array_556=("")
        eprintf__2642_v0 "${ret_cutoff_text2774_v0__157_17}""
" array_556[@]
    fi
    math_floor__606_v0 "$(( $(( $(( total_28207 + _page_size_134 )) - 1 )) / _page_size_134 ))"
    _total_pages_136="${ret_math_floor606_v0}"
    _display_count_135="${_page_size_134}"
    if [ "$(( total_28207 < _page_size_134 ))" != 0 ]; then
        _display_count_135="${total_28207}"
    fi
    if [ "${multi_28211}" != 0 ]; then
        _checked_146=()
        local __range_start_28264=0
        local __range_end_28264="${total_28207}"
        local __dir_28264=$(( ${__range_start_28264} <= ${__range_end_28264} ? 1 : -1 ))
        for (( ____28264=${__range_start_28264}; ____28264 * ${__dir_28264} < ${__range_end_28264} * ${__dir_28264}; ____28264+=${__dir_28264} )); do
            local array_558=(0)
            _checked_146+=("${array_558[@]}")
done
    fi
    new_line__2695_v0 "${_display_count_135}"
    local array_559=("")
    eprintf__2642_v0 "\\x1b[G" array_559[@]
    if [ "$(( _total_pages_136 > 1 ))" != 0 ]; then
        eprintf_colored__2643_v0 "Page $(( _current_page_137 + 1 ))/${_total_pages_136}" 90
    fi
    new_line__2695_v0 1
    render_tooltip_line__2917_v0 
    go_up__2696_v0 "$(( _display_count_135 + 1 ))"
    local array_560=("")
    eprintf__2642_v0 "\\x1b[G" array_560[@]
}

# chooser_page_start()
chooser_page_start__2919_v0() {
    ret_chooser_page_start2919_v0="$(( _current_page_137 * _page_size_134 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2920_v0() {
    chooser_page_start__2919_v0 
    local start_28292="${ret_chooser_page_start2919_v0}"
    local end_28293="$(( start_28292 + _page_size_134 ))"
    if [ "$(( end_28293 > _total_133 ))" != 0 ]; then
        end_28293="${_total_133}"
    fi
    ret_chooser_page_count2920_v0="$(( end_28293 - start_28292 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2921_v0() {
    local page_28300=("${!1}")
    _page_144=("${page_28300[@]}")
    local __length_561=("${page_28300[@]}")
    _page_count_145="${#__length_561[@]}"
    if [ "${_first_render_148}" != 0 ]; then
        _first_render_148=0
        render_page__2915_v0 
    else
        if [ "${_up_paged_149}" != 0 ]; then
            _selected_138="$(( _page_count_145 - 1 ))"
            _up_paged_149=0
        fi
        go_up__2696_v0 1
        remove_line__2692_v0 "$(( _display_count_135 - 1 ))"
        remove_current_line__2693_v0 
        local array_562=("")
        eprintf__2642_v0 "\\x1b[G" array_562[@]
        render_page__2915_v0 
        render_page_indicator__2916_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2922_v0() {
    local prev_selected_28345="${1}"
    chooser_page_start__2919_v0 
    local page_start_28346="${ret_chooser_page_start2919_v0}"
    local check_width_28347
    check_width_28347="$(if [ "${_multi_140}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_563="${_cursor_139}"
    local max_option_width_28348="$(( $(( _term_width_142 - ${#__length_563} )) - check_width_28347 ))"
    go_up__2696_v0 "$(( _display_count_135 - prev_selected_28345 ))"
    local array_564=("")
    eprintf__2642_v0 "\\x1b[K" array_564[@]
    local __length_565="${_cursor_139}"
    print_blank__2694_v0 "${#__length_565}"
    if [ "${_multi_140}" != 0 ]; then
        local was_checked_28349="${_checked_146[$(( page_start_28346 + prev_selected_28345 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2774_v0 "${_page_144[${prev_selected_28345}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_28348}"
        local ret_cutoff_text2774_v0__232_63="${ret_cutoff_text2774_v0}"
        local prev_line_28350
        prev_line_28350="$(if [ "${was_checked_28349}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2774_v0__232_63}"
        if [ "${was_checked_28349}" != 0 ]; then
            colored_secondary__2744_v0 "${prev_line_28350}"
            local ret_colored_secondary2744_v0__234_21="${ret_colored_secondary2744_v0}"
            local array_566=("")
            eprintf__2642_v0 "${ret_colored_secondary2744_v0__234_21}" array_566[@]
        else
            local array_567=("")
            eprintf__2642_v0 "${prev_line_28350}" array_567[@]
        fi
    else
        cutoff_text__2774_v0 "${_page_144[${prev_selected_28345}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_28348}"
        local ret_cutoff_text2774_v0__239_17="${ret_cutoff_text2774_v0}"
        local array_568=("")
        eprintf__2642_v0 "${ret_cutoff_text2774_v0__239_17}" array_568[@]
    fi
    go_up_or_down__2698_v0 "$(( _selected_138 - prev_selected_28345 ))"
    local array_569=("")
    eprintf__2642_v0 "\\x1b[G" array_569[@]
    local array_570=("")
    eprintf__2642_v0 "\\x1b[K" array_570[@]
    local mark_28352
    mark_28352="$(if [ "${_multi_140}" != 0 ]; then echo "$(if [ "${_checked_146[$(( page_start_28346 + _selected_138 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2774_v0 "${_page_144[${_selected_138}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_28348}"
    local ret_cutoff_text2774_v0__246_48="${ret_cutoff_text2774_v0}"
    colored_secondary__2744_v0 "${_cursor_139}""${mark_28352}""${ret_cutoff_text2774_v0__246_48}"
    local ret_colored_secondary2744_v0__246_13="${ret_colored_secondary2744_v0}"
    local array_571=("")
    eprintf__2642_v0 "${ret_colored_secondary2744_v0__246_13}" array_571[@]
    go_down__2697_v0 "$(( _display_count_135 - _selected_138 ))"
    local array_572=("")
    eprintf__2642_v0 "\\x1b[G" array_572[@]
}

# redraw_current_line()
redraw_current_line__2923_v0() {
    chooser_page_start__2919_v0 
    local page_start_28339="${ret_chooser_page_start2919_v0}"
    local __length_573="${_cursor_139}"
    local max_option_width_28340="$(( $(( _term_width_142 - ${#__length_573} )) - 3 ))"
    go_up__2696_v0 "$(( _display_count_135 - _selected_138 ))"
    local array_574=("")
    eprintf__2642_v0 "\\x1b[G" array_574[@]
    local array_575=("")
    eprintf__2642_v0 "\\x1b[K" array_575[@]
    local check_mark_28341
    check_mark_28341="$(if [ "${_checked_146[$(( page_start_28339 + _selected_138 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2774_v0 "${_page_144[${_selected_138}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_28340}"
    local ret_cutoff_text2774_v0__260_54="${ret_cutoff_text2774_v0}"
    colored_secondary__2744_v0 "${_cursor_139}""${check_mark_28341}""${ret_cutoff_text2774_v0__260_54}"
    local ret_colored_secondary2744_v0__260_13="${ret_colored_secondary2744_v0}"
    local array_576=("")
    eprintf__2642_v0 "${ret_colored_secondary2744_v0__260_13}" array_576[@]
    go_down__2697_v0 "$(( _display_count_135 - _selected_138 ))"
    local array_577=("")
    eprintf__2642_v0 "\\x1b[G" array_577[@]
}

# chooser_step()
chooser_step__2924_v0() {
    get_key__2640_v0 
    local key_28334="${ret_get_key2640_v0}"
    local prev_selected_28335="${_selected_138}"
    local prev_page_28336="${_current_page_137}"
    chooser_page_start__2919_v0 
    local page_start_28337="${ret_chooser_page_start2919_v0}"
    _up_paged_149=0
    if [ "$(( $([ "_${key_28334}" != "_UP" ]; echo $?) || $([ "_${key_28334}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_138 == 0 )) && $(( _total_pages_136 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_137 > 0 ))" != 0 ]; then
                _current_page_137="$(( _current_page_137 - 1 ))"
            else
                _current_page_137="$(( _total_pages_136 - 1 ))"
            fi
            _up_paged_149=1
        elif [ "$(( _selected_138 == 0 ))" != 0 ]; then
            _selected_138="$(( _page_count_145 - 1 ))"
        else
            _selected_138="$(( _selected_138 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_28334}" != "_DOWN" ]; echo $?) || $([ "_${key_28334}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_138 == $(( _page_count_145 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_137 < $(( _total_pages_136 - 1 )) ))" != 0 ]; then
                _current_page_137="$(( _current_page_137 + 1 ))"
            else
                _current_page_137=0
            fi
            _selected_138=0
        else
            _selected_138="$(( _selected_138 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_28334}" != "_LEFT" ]; echo $?) || $([ "_${key_28334}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_137 > 0 ))" != 0 ]; then
            _current_page_137="$(( _current_page_137 - 1 ))"
        fi
        _selected_138=0
    elif [ "$(( $([ "_${key_28334}" != "_RIGHT" ]; echo $?) || $([ "_${key_28334}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_137 < $(( _total_pages_136 - 1 )) ))" != 0 ]; then
            _current_page_137="$(( _current_page_137 + 1 ))"
            _selected_138=0
        else
            _selected_138="$(( _page_count_145 - 1 ))"
        fi
    elif [ "$(( _multi_140 && $(( $([ "_${key_28334}" != "_x" ]; echo $?) || $([ "_${key_28334}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_28338="$(( page_start_28337 + _selected_138 ))"
        if [ "${_checked_146[${global_selected_28338}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_146["${global_selected_28338}"]=0
            _checked_count_147="$(( _checked_count_147 - 1 ))"
        elif [ "$(( $(( _limit_141 < 0 )) || $(( _checked_count_147 < _limit_141 )) ))" != 0 ]; then
            _checked_146["${global_selected_28338}"]=1
            _checked_count_147="$(( _checked_count_147 + 1 ))"
        else
            ret_chooser_step2924_v0="${__CHOOSER_CONTINUE_130}"
            return 0
        fi
        redraw_current_line__2923_v0 
        ret_chooser_step2924_v0="${__CHOOSER_CONTINUE_130}"
        return 0
    elif [ "$(( $(( _multi_140 && $(( $([ "_${key_28334}" != "_a" ]; echo $?) || $([ "_${key_28334}" != "_A" ]; echo $?) )) )) && $(( _limit_141 < 0 )) ))" != 0 ]; then
        local all_checked_28343="$(( _checked_count_147 == _total_133 ))"
        local __range_start_28344=0
        local __range_end_28344="${_total_133}"
        local __dir_28344=$(( ${__range_start_28344} <= ${__range_end_28344} ? 1 : -1 ))
        for (( i_28344=${__range_start_28344}; i_28344 * ${__dir_28344} < ${__range_end_28344} * ${__dir_28344}; i_28344+=${__dir_28344} )); do
            _checked_146["${i_28344}"]="$(( ! all_checked_28343 ))"
done
        _checked_count_147="$(if [ "${all_checked_28343}" != 0 ]; then echo 0; else echo "${_total_133}"; fi)"
        go_up__2696_v0 "${_display_count_135}"
        local array_578=("")
        eprintf__2642_v0 "\\x1b[G" array_578[@]
        render_page__2915_v0 
        ret_chooser_step2924_v0="${__CHOOSER_CONTINUE_130}"
        return 0
    elif [ "$([ "_${key_28334}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2924_v0="${__CHOOSER_DONE_132}"
        return 0
    else
        ret_chooser_step2924_v0="${__CHOOSER_CONTINUE_130}"
        return 0
    fi
    if [ "$(( prev_page_28336 != _current_page_137 ))" != 0 ]; then
        ret_chooser_step2924_v0="${__CHOOSER_NEED_PAGE_131}"
        return 0
    fi
    if [ "$(( prev_selected_28335 != _selected_138 ))" != 0 ]; then
        redraw_selection__2922_v0 "${prev_selected_28335}"
    fi
    ret_chooser_step2924_v0="${__CHOOSER_CONTINUE_130}"
    return 0
}

# chooser_selected()
chooser_selected__2925_v0() {
    chooser_page_start__2919_v0 
    local ret_chooser_page_start2919_v0__362_12="${ret_chooser_page_start2919_v0}"
    ret_chooser_selected2925_v0="$(( ret_chooser_page_start2919_v0__362_12 + _selected_138 ))"
    return 0
}

# chooser_end()
chooser_end__2927_v0() {
    local total_lines_28355="$(( _display_count_135 + 2 ))"
    if [ "${_has_header_143}" != 0 ]; then
        total_lines_28355="$(( total_lines_28355 + 1 ))"
    fi
    go_down__2697_v0 1
    remove_line__2692_v0 "$(( total_lines_28355 - 1 ))"
    remove_current_line__2693_v0 
    stty_unlock__2683_v0 
    show_cursor__2700_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2936_v0() {
    local name_28296="${1}"
    local file_type_28297="${2}"
    local target_28298="${3}"
    if [ "$([ "_${file_type_28297}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2421_v0 "/"
        local ret_colored_primary2421_v0__10_23="${ret_colored_primary2421_v0}"
        ret_format_entry_display2936_v0="${name_28296}""${ret_colored_primary2421_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_28297}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2423_v0 " > "
        local ret_colored_accent2423_v0__13_23="${ret_colored_accent2423_v0}"
        colored_primary__2421_v0 "${target_28298}"
        local ret_colored_primary2421_v0__13_47="${ret_colored_primary2421_v0}"
        ret_format_entry_display2936_v0="${name_28296}""${ret_colored_accent2423_v0__13_23}""${ret_colored_primary2421_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2936_v0="${name_28296}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2937_v0() {
    local start_path_28177="${1}"
    local cursor_28178="${2}"
    local show_hidden_28179="${3}"
    local page_size_28180="${4}"
    stty_lock__2360_v0 
    # Initialize current path
    local current_path_28183="${start_path_28177}"
    if [ "$([ "_${current_path_28183}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__2402_v0 
        current_path_28183="${ret_get_cwd2402_v0}"
    fi
    normalize_path__2403_v0 "${current_path_28183}"
    current_path_28183="${ret_normalize_path2403_v0}"
    while :
    do
        colored_primary__2421_v0 "Loading files..."
        local ret_colored_primary2421_v0__41_17="${ret_colored_primary2421_v0}"
        local array_579=("")
        eprintf__2320_v0 "${ret_colored_primary2421_v0__41_17}" array_579[@]
        get_directory_entries__2401_v0 "${current_path_28183}"
        local listed_28194=("${ret_get_directory_entries2401_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_28195=()
        local types_28196=()
        local targets_28197=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_28183}" == "_/" ]; echo $?)" != 0 ]; then
            names_28195+=("..")
            types_28196+=("d")
            targets_28197+=("")
        fi
        local __length_586=("${listed_28194[@]}")
        local listed_count_28198="$(( ${#__length_586[@]} / __ENTRY_STRIDE_101 ))"
        local __range_start_28199=0
        local __range_end_28199="${listed_count_28198}"
        local __dir_28199=$(( ${__range_start_28199} <= ${__range_end_28199} ? 1 : -1 ))
        for (( i_28199=${__range_start_28199}; i_28199 * ${__dir_28199} < ${__range_end_28199} * ${__dir_28199}; i_28199+=${__dir_28199} )); do
            local at_28200="$(( i_28199 * __ENTRY_STRIDE_101 ))"
            local name_28201="${listed_28194[${at_28200}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_28201}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_28179 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_587=("${name_28201}")
            names_28195+=("${array_587[@]}")
            local array_588=("${listed_28194[$(( at_28200 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_28196+=("${array_588[@]}")
            local array_589=("${listed_28194[$(( at_28200 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_28197+=("${array_589[@]}")
done
        local __length_590=("${names_28195[@]}")
        local total_28202="${#__length_590[@]}"
        if [ "$(( total_28202 == 0 ))" != 0 ]; then
            eprintf_colored__2321_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__2361_v0 
            ret_xyl_file2937_v0=""
            return 0
        fi
        colored_primary__2421_v0 "${current_path_28183}"
        local header_28204="${ret_colored_primary2421_v0}"
        remove_current_line__2371_v0 
        chooser_begin__2918_v0 "${total_28202}" "${page_size_28180}" "${header_28204}" "${cursor_28178}" 0 -1
        local need_page_28289=1
        while :
        do
            if [ "${need_page_28289}" != 0 ]; then
                local page_28290=()
                chooser_page_start__2919_v0 
                local start_28291="${ret_chooser_page_start2919_v0}"
                chooser_page_count__2920_v0 
                local count_28294="${ret_chooser_page_count2920_v0}"
                local __range_start_28295="${start_28291}"
                local __range_end_28295="$(( start_28291 + count_28294 ))"
                local __dir_28295=$(( ${__range_start_28295} <= ${__range_end_28295} ? 1 : -1 ))
                for (( i_28295=${__range_start_28295}; i_28295 * ${__dir_28295} < ${__range_end_28295} * ${__dir_28295}; i_28295+=${__dir_28295} )); do
                    format_entry_display__2936_v0 "${names_28195[${i_28295}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_28196[${i_28295}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_28197[${i_28295}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display2936_v0__90_30="${ret_format_entry_display2936_v0}"
                    local array_592=("${ret_format_entry_display2936_v0__90_30}")
                    page_28290+=("${array_592[@]}")
done
                chooser_set_page__2921_v0 page_28290[@]
            fi
            chooser_step__2924_v0 
            local step_28353="${ret_chooser_step2924_v0}"
            if [ "$(( step_28353 == __CHOOSER_DONE_132 ))" != 0 ]; then
                break
            fi
            need_page_28289="$(( step_28353 == __CHOOSER_NEED_PAGE_131 ))"
        done
        chooser_selected__2925_v0 
        local selected_idx_28354="${ret_chooser_selected2925_v0}"
        chooser_end__2927_v0 
        local name_28357="${names_28195[${selected_idx_28354}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_28358="${types_28196[${selected_idx_28354}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_28357}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__2405_v0 "${current_path_28183}"
            current_path_28183="${ret_get_parent_dir2405_v0}"
        elif [ "$([ "_${file_type_28358}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__2404_v0 "${current_path_28183}" "${name_28357}"
            current_path_28183="${ret_path_join2404_v0}"
            normalize_path__2403_v0 "${current_path_28183}"
            current_path_28183="${ret_normalize_path2403_v0}"
        elif [ "$([ "_${file_type_28358}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_28363="${targets_28197[${selected_idx_28354}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_28364="${target_28363}"
            starts_with__22_v0 "${target_28363}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__2404_v0 "${current_path_28183}" "${target_28363}"
                target_path_28364="${ret_path_join2404_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_28364}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_28183="${target_path_28364}"
                normalize_path__2403_v0 "${current_path_28183}"
                current_path_28183="${ret_normalize_path2403_v0}"
            else
                stty_unlock__2361_v0 
                path_join__2404_v0 "${current_path_28183}" "${name_28357}"
                ret_xyl_file2937_v0="${ret_path_join2404_v0}"
                return 0
            fi
        else
            stty_unlock__2361_v0 
            path_join__2404_v0 "${current_path_28183}" "${name_28357}"
            ret_xyl_file2937_v0="${ret_path_join2404_v0}"
            return 0
        fi
    done
    stty_unlock__2361_v0 
    ret_xyl_file2937_v0=""
    return 0
}

# print_file_help()
print_file_help__3031_v0() {
    local usage_28095=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2379_v0 usage_28095[@]
    printf '%s\n' ""
    colored_primary__2421_v0 "file"
    local ret_colored_primary2421_v0__8_20="${ret_colored_primary2421_v0}"
    local title_28132=("${ret_colored_primary2421_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2379_v0 title_28132[@]
    printf '%s\n' ""
    colored_secondary__2422_v0 "Arguments:"
    local ret_colored_secondary2422_v0__11_12="${ret_colored_secondary2422_v0}"
    local array_595=()
    printf__128_v0 "${ret_colored_secondary2422_v0__11_12}""
" array_595[@]
    local arg_names_28134=("[<path>]")
    local arg_texts_28135=("Starting directory path")
    local arg_notes_28136=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2539_v0 arg_names_28134[@] arg_texts_28135[@] arg_notes_28136[@] 20
    printf '%s\n' ""
    colored_secondary__2422_v0 "Flags:"
    local ret_colored_secondary2422_v0__18_12="${ret_colored_secondary2422_v0}"
    local array_599=()
    printf__128_v0 "${ret_colored_secondary2422_v0__18_12}""
" array_599[@]
    local names_28169=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_28170=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_28171=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2539_v0 names_28169[@] texts_28170[@] notes_28171[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__3083_v0() {
    local parameters_28089=("${!1}")
    local cursor_28090="> "
    local start_path_28091=""
    local show_hidden_28092=0
    local page_size_28093=10
    local __length_606=("${parameters_28089[@]}")
    local slice_upper_605="${#__length_606[@]}"
    local slice_offset_607=2
    local slice_offset_607=$((${slice_offset_607} > 0 ? ${slice_offset_607} : 0))
    local slice_length_608="$(( slice_upper_605 - slice_offset_607 ))"
    local slice_length_608=$((${slice_length_608} > 0 ? ${slice_length_608} : 0))
    for param_28094 in "${parameters_28089[@]:${slice_offset_607}:${slice_length_608}}"; do
        starts_with__22_v0 "${param_28094}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_28094}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_28094}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_28094}" != "_-h" ]; echo $?) || $([ "_${param_28094}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__3031_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_609="--cursor="
            slice__24_v0 "${param_28094}" "${#__length_609}" 0
            cursor_28090="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_610="--path="
            slice__24_v0 "${param_28094}" "${#__length_610}" 0
            start_path_28091="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_28094}" != "_-a" ]; echo $?) || $([ "_${param_28094}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_28092=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_611="--page-size="
            slice__24_v0 "${param_28094}" "${#__length_611}" 0
            local value_28172="${ret_slice24_v0}"
            parse_int__13_v0 "${value_28172}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2321_v0 "ERROR: Invalid page-size value: ""${value_28172}""
" 31
                exit 1
            fi
            page_size_28093="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_28091="${param_28094}"
        fi
    done
    xyl_file__2937_v0 "${start_path_28091}" "${cursor_28090}" "${show_hidden_28092}" "${page_size_28093}"
    ret_execute_file3083_v0="${ret_xyl_file2937_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_155="0.1.0"
__AMBER_VERSION_156="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__3085_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__162_v0 "Error: " 91
        local array_612=("")
        eprintf__161_v0 "bc is not installed. Please install bc to use xylitol.
" array_612[@]
        local array_613=("")
        eprintf__161_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_613[@]
        local array_614=("")
        eprintf__161_v0 "  For Fedora: sudo dnf install bc
" array_614[@]
        local array_615=("")
        eprintf__161_v0 "  For Arch Linux: sudo pacman -S bc
" array_615[@]
        ret_check_prerequirements3085_v0=0
        return 0
    fi
    ret_check_prerequirements3085_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__3086_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_157=("$0" "$@")
trap_cleanup__3086_v0 
check_prerequirements__3085_v0 
ret_check_prerequirements3085_v0__32_12="${ret_check_prerequirements3085_v0}"
if [ "$(( ! ret_check_prerequirements3085_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_617=("${args_157[@]}")
if [ "$(( ${#__length_617[@]} < 2 ))" != 0 ]; then
    print_help__525_v0 
    exit 0
fi
command_1519="${args_157[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1519}" != "_help" ]; echo $?) || $([ "_${command_1519}" != "_--help" ]; echo $?) )) || $([ "_${command_1519}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__525_v0 
elif [ "$([ "_${command_1519}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__1035_v0 args_157[@]
    ret_execute_input1035_v0__48_18="${ret_execute_input1035_v0}"
    printf '%s\n' "${ret_execute_input1035_v0__48_18}"
elif [ "$([ "_${command_1519}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1658_v0 args_157[@]
    ret_execute_choose1658_v0__51_18="${ret_execute_choose1658_v0}"
    printf '%s\n' "${ret_execute_choose1658_v0__51_18}"
elif [ "$([ "_${command_1519}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2202_v0 args_157[@]
    result_18715="${ret_execute_confirm2202_v0}"
    if [ "$([ "_${result_18715}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1519}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__3083_v0 args_157[@]
    ret_execute_file3083_v0__61_18="${ret_execute_file3083_v0}"
    printf '%s\n' "${ret_execute_file3083_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1519}" != "_version" ]; echo $?) || $([ "_${command_1519}" != "_--version" ]; echo $?) )) || $([ "_${command_1519}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__262_v0 "xylitol.sh"
    ret_colored_primary262_v0__64_20="${ret_colored_primary262_v0}"
    array_618=()
    printf__128_v0 "${ret_colored_primary262_v0__64_20}" array_618[@]
    array_619=()
    printf__128_v0 " version: " array_619[@]
    colored_accent__264_v0 "${__VERSION_155}"
    ret_colored_accent264_v0__66_20="${ret_colored_accent264_v0}"
    array_620=()
    printf__128_v0 "${ret_colored_accent264_v0__66_20}" array_620[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_156}" 90
else
    print_help__525_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1519}""'" 91
fi
