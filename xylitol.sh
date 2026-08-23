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
    local text_1351="${1}"
    local delimiter_1352="${2}"
    local result_1353=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1352}" read -rd '' -A result_1353 < <(printf %s "$text_1351")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1352}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1353+=("$REPLY"); done < <(echo "$text_1351")
            __status=$?
        else
            IFS="${delimiter_1352}" read -rd '' -a result_1353 < <(printf %s "$text_1351")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1352}" read -rd '' -a result_1353 < <(printf %s "$text_1351")
        __status=$?
    fi
    ret_split4_v0=("${result_1353[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_16575=("${!1}")
    local delimiter_16576="${2}"
    local command_1
    command_1="$(IFS="${delimiter_16576}" ; printf "%s
" "${list_16575[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1355="${1}"
    [ -n "${text_1355}" ] && [ "${text_1355}" -eq "${text_1355}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1355}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_2900="${1}"
    local prefix_2901="${2}"
    [[ "${text_2900}" == "${prefix_2901}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1433="${1}"
    local index_1434="${2}"
    local length_1435="${3}"
    local result_1436=""
    if [ "$(( length_1435 == 0 ))" != 0 ]; then
        local __length_2="${text_1433}"
        length_1435="$(( ${#__length_2} - index_1434 ))"
    fi
    if [ "$(( length_1435 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1436}"
        return 0
    fi
    result_1436="${text_1433: ${index_1434}: ${length_1435}}"
    __status=$?
    ret_slice24_v0="${result_1436}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_18571="${1}"
    local pad_18572="${2}"
    local length_18573="${3}"
    local __length_3="${text_18571}"
    if [ "$(( length_18573 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_18571}"
        return 0
    fi
    local __length_4="${text_18571}"
    local pad_len_18574="$(( length_18573 - ${#__length_4} ))"
    local padding_18575=""
    printf -v padding_18575 "%${pad_len_18574}s" ""
    __status=$?
    padding_18575="${padding_18575// /${pad_18572}}"
    __status=$?
    ret_lpad27_v0="${padding_18575}""${text_18571}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1413="${1}"
    local pad_1414="${2}"
    local length_1415="${3}"
    local __length_5="${text_1413}"
    if [ "$(( length_1415 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1413}"
        return 0
    fi
    local __length_6="${text_1413}"
    local pad_len_1416="$(( length_1415 - ${#__length_6} ))"
    local padding_1417=""
    printf -v padding_1417 "%${pad_len_1416}s" ""
    __status=$?
    padding_1417="${padding_1417// /${pad_1414}}"
    __status=$?
    ret_rpad28_v0="${text_1413}""${padding_1417}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_18565="${1}"
    local pad_18566="${2}"
    local length_18567="${3}"
    local __length_7="${text_18565}"
    local text_length_18568="${#__length_7}"
    if [ "$(( length_18567 <= text_length_18568 ))" != 0 ]; then
        ret_cpad29_v0="${text_18565}"
        return 0
    fi
    local total_padding_18569="$(( length_18567 - text_length_18568 ))"
    local left_padding_length_18570="$(( text_length_18568 + $(( total_padding_18569 / 2 )) ))"
    lpad__27_v0 "${text_18565}" "${pad_18566}" "${left_padding_length_18570}"
    local left_padded_18576="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_18576}" "${pad_18566}" "${length_18567}"
    local center_padded_18577="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_18577}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_28240="${1}"
    [ -d "${path_28240}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1378="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1378}")"
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
" "${(P)name_1378}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1378}")"
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
    local format_1375="${1}"
    local args_1376=("${!2}")
    args_1376=("${format_1375}" "${args_1376[@]}")
    __status=$?
    printf "${args_1376[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1388="${1}"
    local args_1389=("${!2}")
    args_1389=("${format_1388}" "${args_1389[@]}")
    __status=$?
    printf "${args_1389[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1385="${1}"
    local color_1386="${2}"
    local color_code_1387=0
        color_code_1387="${color_1386}"
    local array_11=("${message_1385}")
    printf__128_v1 "\\x1b[${color_code_1387}m%s\\x1b[0m
" array_11[@]
}

# printf_colored(message: Text, color: Int)
printf_colored__160_v0() {
    local message_28243="${1}"
    local color_28244="${2}"
    # Prints a text with a specified color.
    local array_12=("${message_28243}")
    printf__128_v1 "\\x1b[${color_28244}m%s\\x1b[0m" array_12[@]
}

# eprintf(format: Text, args: [Text])
eprintf__161_v0() {
    local format_166="${1}"
    local args_167=("${!2}")
    args_167=("${format_166}" "${args_167[@]}")
    __status=$?
    printf "${args_167[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__162_v0() {
    local message_164="${1}"
    local color_165="${2}"
    # Prints an error message with a specified color.
    local array_13=("${message_164}")
    eprintf__161_v0 "\\x1b[${color_165}m%s\\x1b[0m" array_13[@]
}

# colored(message: Text, color: Int)
colored__176_v0() {
    local message_1431="${1}"
    local color_1432="${2}"
    # Returns a text wrapped in color codes.
    ret_colored176_v0="\\x1b[${color_1432}m""${message_1431}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_3="None"
# perl_available()
perl_available__201_v0() {
    if [ "$([ "_${_perl_state_3}" != "_None" ]; echo $?)" != 0 ]; then
        local command_14
        command_14="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_1371
        disabled_1371="$([ "_${command_14}" != "_No" ]; echo $?)"
        local command_15
        command_15="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_1372
        found_1372="$(( $(( ! disabled_1371 )) && $([ "_${command_15}" != "_0" ]; echo $?) ))"
        _perl_state_3="$(if [ "${found_1372}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available201_v0="$([ "_${_perl_state_3}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__202_v0() {
    local text_1370="${1}"
    perl_available__201_v0 
    local ret_perl_available201_v0__22_12="${ret_perl_available201_v0}"
    if [ "$(( ! ret_perl_available201_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width202_v0=''
        return 1
    fi
    local command_16
    command_16="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1370}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width202_v0=''
        return "${__status}"
    fi
    local width_str_1373="${command_16}"
    parse_int__13_v0 "${width_str_1373}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width202_v0=''
        return "${__status}"
    fi
    local width_1374="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width202_v0="${width_1374}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__232_v0() {
    local text_1363="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_17
    command_17="$([[ "${text_1363}" == *$'\x1b'* || "${text_1363}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1364="${command_17}"
    ret_has_ansi_escape232_v0="$([ "_${has_escape_1364}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__234_v0() {
    local text_1366="${1}"
    local command_18
    command_18="$(printf "%s" "${text_1366}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi234_v0="${command_18}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__235_v0() {
    local text_1368="${1}"
    local command_19
    command_19="$(printf "%s" "${text_1368}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1369="${command_19}"
    ret_is_all_ascii235_v0="$([ "_${result_1369}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__236_v0() {
    local text_1365="${1}"
    strip_ansi__234_v0 "${text_1365}"
    local stripped_1367="${ret_strip_ansi234_v0}"
    # Check if text is all ASCII
    is_all_ascii__235_v0 "${stripped_1367}"
    local ret_is_all_ascii235_v0__36_12="${ret_is_all_ascii235_v0}"
    if [ "$(( ! ret_is_all_ascii235_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__202_v0 "${stripped_1367}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_20="${stripped_1367}"
            ret_get_visible_len236_v0="${#__length_20}"
            return 0
        fi
        ret_get_visible_len236_v0="${ret_perl_get_cjk_width202_v0}"
        return 0
    else
        local __length_21="${stripped_1367}"
        ret_get_visible_len236_v0="${#__length_21}"
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
store_term_size__247_v0() {
    local size_1350="${1}"
    if [ "$([ "_${size_1350}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size247_v0=0
        return 0
    fi
    split__4_v0 "${size_1350}" " "
    local parts_1354=("${ret_split4_v0[@]}")
    local __length_23=("${parts_1354[@]}")
    if [ "$(( ${#__length_23[@]} != 2 ))" != 0 ]; then
        ret_store_term_size247_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1354[1]?"Index out of bounds (at src/utils/./term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1354[0]?"Index out of bounds (at src/utils/./term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_5=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size247_v0=1
    return 0
}

# query_term_size()
query_term_size__248_v0() {
    local command_25
    command_25="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1357="${command_25}"
    store_term_size__247_v0 "${size_1357}"
    ret_query_term_size248_v0="${ret_store_term_size247_v0}"
    return 0
}

# stty_term_size()
stty_term_size__249_v0() {
    local command_26
    command_26="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1349="${command_26}"
    store_term_size__247_v0 "${size_1349}"
    ret_stty_term_size249_v0="${ret_store_term_size247_v0}"
    return 0
}

# get_term_size()
get_term_size__250_v0() {
    stty_term_size__249_v0 
    local detected_1356="${ret_stty_term_size249_v0}"
    if [ "$(( ! detected_1356 ))" != 0 ]; then
        query_term_size__248_v0 
        detected_1356="${ret_query_term_size248_v0}"
    fi
    _got_term_size_4=1
}

# term_width()
term_width__252_v0() {
    if [ "$(( ! _got_term_size_4 ))" != 0 ]; then
        get_term_size__250_v0 
    fi
    ret_term_width252_v0="${_term_size_5[0]?"Index out of bounds (at src/utils/./term.ab:93:23)"}"
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__255_v0() {
    local pending_1428="${1}"
    local line_1429="${2}"
    local note_at_1430="${3}"
    if [ "$(( note_at_1430 < 0 ))" != 0 ]; then
        local array_27=()
        printf__128_v0 "${pending_1428}""${line_1429}""
" array_27[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1430 == 0 ))" != 0 ]; then
        colored__176_v0 "${line_1429}" 90
        local ret_colored176_v0__13_40="${ret_colored176_v0}"
        local array_28=()
        printf__128_v0 "${pending_1428}""${ret_colored176_v0__13_40}""
" array_28[@]
    else
        slice__24_v0 "${line_1429}" 0 "${note_at_1430}"
        local ret_slice24_v0__14_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1429}" "${note_at_1430}" 0
        local ret_slice24_v0__14_66="${ret_slice24_v0}"
        colored__176_v0 "${ret_slice24_v0__14_66}" 90
        local ret_colored176_v0__14_58="${ret_colored176_v0}"
        local array_29=()
        printf__128_v0 "${pending_1428}""${ret_slice24_v0__14_32}""${ret_colored176_v0__14_58}""
" array_29[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__256_v0() {
    local names_1401=("${!1}")
    local texts_1402=("${!2}")
    local notes_1403=("${!3}")
    local min_name_width_1404="${4}"
    local __length_30=("${names_1401[@]}")
    local count_1405="${#__length_30[@]}"
    local name_width_1406="${min_name_width_1404}"
    local __range_start_1407=0
    local __range_end_1407="${count_1405}"
    local __dir_1407=$(( ${__range_start_1407} <= ${__range_end_1407} ? 1 : -1 ))
    for (( i_1407=${__range_start_1407}; i_1407 * ${__dir_1407} < ${__range_end_1407} * ${__dir_1407}; i_1407+=${__dir_1407} )); do
        local __length_31="${names_1401[${i_1407}]?"Index out of bounds (at src/utils/layout.ab:29:33)"}"
        local width_1408="${#__length_31}"
        if [ "$(( width_1408 > name_width_1406 ))" != 0 ]; then
            name_width_1406="${width_1408}"
        fi
done
    term_width__252_v0 
    local width_1409="${ret_term_width252_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1410="$(( name_width_1406 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1411="$(( $(( width_1409 - indent_1410 )) < 24 ))"
    if [ "${stacked_1411}" != 0 ]; then
        indent_1410=6
    fi
    local avail_1412="$(( width_1409 - indent_1410 ))"
    rpad__28_v0 "" " " "${indent_1410}"
    local blank_1418="${ret_rpad28_v0}"
    local __range_start_1419=0
    local __range_end_1419="${count_1405}"
    local __dir_1419=$(( ${__range_start_1419} <= ${__range_end_1419} ? 1 : -1 ))
    for (( i_1419=${__range_start_1419}; i_1419 * ${__dir_1419} < ${__range_end_1419} * ${__dir_1419}; i_1419+=${__dir_1419} )); do
        local pending_1420="${blank_1418}"
        if [ "${stacked_1411}" != 0 ]; then
            local array_32=()
            printf__128_v0 "  ""${names_1401[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:49:33)"}""
" array_32[@]
        else
            rpad__28_v0 "  ""${names_1401[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:51:41)"}" " " "${indent_1410}"
            local ret_rpad28_v0__51_23="${ret_rpad28_v0}"
            pending_1420="${ret_rpad28_v0__51_23}"
        fi
        split__4_v0 "${texts_1402[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:53:33)"}" " "
        local ret_split4_v0__53_21=("${ret_split4_v0[@]}")
        local words_1421=("${ret_split4_v0__53_21[@]}")
        local __length_33=("${words_1421[@]}")
        local note_start_1422="${#__length_33[@]}"
        if [ "$([ "_${notes_1403[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:55:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_34="${notes_1403[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:58:26)"}"
            if [ "$(( ${#__length_34} > avail_1412 ))" != 0 ]; then
                split__4_v0 "${notes_1403[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:59:38)"}" " "
                local ret_split4_v0__59_26=("${ret_split4_v0[@]}")
                words_1421+=("${ret_split4_v0__59_26[@]}")
            else
                local array_35=("${notes_1403[${i_1419}]?"Index out of bounds (at src/utils/layout.ab:61:33)"}")
                words_1421+=("${array_35[@]}")
            fi
        fi
        local line_1423=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1424=-1
        local __range_start_1425=0
        local __length_36=("${words_1421[@]}")
        local __range_end_1425="${#__length_36[@]}"
        local __dir_1425=$(( ${__range_start_1425} <= ${__range_end_1425} ? 1 : -1 ))
        for (( j_1425=${__range_start_1425}; j_1425 * ${__dir_1425} < ${__range_end_1425} * ${__dir_1425}; j_1425+=${__dir_1425} )); do
            local word_1426="${words_1421[${j_1425}]?"Index out of bounds (at src/utils/layout.ab:71:32)"}"
            local candidate_1427
            candidate_1427="$(if [ "$([ "_${line_1423}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1426}"; else echo "${line_1423}"" ""${word_1426}"; fi)"
            local __length_37="${candidate_1427}"
            if [ "$(( $(( ${#__length_37} > avail_1412 )) && $([ "_${line_1423}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__255_v0 "${pending_1420}" "${line_1423}" "${note_at_1424}"
                pending_1420="${blank_1418}"
                line_1423="${word_1426}"
                note_at_1424="$(if [ "$(( j_1425 >= note_start_1422 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1425 >= note_start_1422 )) && $(( note_at_1424 < 0 )) ))" != 0 ]; then
                    local __length_38="${candidate_1427}"
                    local __length_39="${word_1426}"
                    note_at_1424="$(( ${#__length_38} - ${#__length_39} ))"
                fi
                line_1423="${candidate_1427}"
            fi
done
        print_help_line__255_v0 "${pending_1420}" "${line_1423}" "${note_at_1424}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__257_v0() {
    local pieces_1348=("${!1}")
    term_width__252_v0 
    local width_1358="${ret_term_width252_v0}"
    local line_1359=""
    local line_len_1360=0
    for piece_1361 in "${pieces_1348[@]}"; do
        local __length_42="${piece_1361}"
        local piece_len_1362="${#__length_42}"
        has_ansi_escape__232_v0 "${piece_1361}"
        local ret_has_ansi_escape232_v0__100_12="${ret_has_ansi_escape232_v0}"
        if [ "${ret_has_ansi_escape232_v0__100_12}" != 0 ]; then
            get_visible_len__236_v0 "${piece_1361}"
            piece_len_1362="${ret_get_visible_len236_v0}"
        fi
        if [ "$([ "_${line_1359}" != "_" ]; echo $?)" != 0 ]; then
            line_1359="${piece_1361}"
            line_len_1360="${piece_len_1362}"
        elif [ "$(( $(( $(( line_len_1360 + 1 )) + piece_len_1362 )) > width_1358 ))" != 0 ]; then
            local array_43=()
            printf__128_v0 "${line_1359}""
" array_43[@]
            line_1359="${piece_1361}"
            line_len_1360="${piece_len_1362}"
        else
            line_1359+=" ""${piece_1361}"
            line_len_1360="$(( line_len_1360 + $(( 1 + piece_len_1362 )) ))"
        fi
    done
    if [ "$([ "_${line_1359}" == "_" ]; echo $?)" != 0 ]; then
        local array_44=()
        printf__128_v0 "${line_1359}""
" array_44[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
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
# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_11="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_12=0
_primary_color_13=(3 207 159 92)
_secondary_color_14=(3 118 206 94)
_accent_color_15=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__305_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1395="${ret_env_var_get120_v0}"
    _supports_truecolor_11="$(if [ "$([ "_${config_1395}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor305_v0="$([ "_${_supports_truecolor_11}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__306_v0() {
    local message_1390="${1}"
    local r_1391="${2}"
    local g_1392="${3}"
    local b_1393="${4}"
    local fallback_1394="${5}"
    if [ "$([ "_${_supports_truecolor_11}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb306_v0="\\x1b[38;2;${r_1391};${g_1392};${b_1393}m""${message_1390}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_11}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__305_v0 
        local ret_get_supports_truecolor305_v0__45_17="${ret_get_supports_truecolor305_v0}"
        if [ "${ret_get_supports_truecolor305_v0__45_17}" != 0 ]; then
            ret_colored_rgb306_v0="\\x1b[38;2;${r_1391};${g_1392};${b_1393}m""${message_1390}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1394 == 0 ))" != 0 ]; then
            ret_colored_rgb306_v0="${message_1390}"
            return 0
        else
            ret_colored_rgb306_v0="\\x1b[${fallback_1394}m""${message_1390}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1394 == 0 ))" != 0 ]; then
            ret_colored_rgb306_v0="${message_1390}"
            return 0
        fi
        ret_colored_rgb306_v0="\\x1b[${fallback_1394}m""${message_1390}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__308_v0() {
    if [ "$(( ! _got_xylitol_colors_12 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1379="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1379}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1379}" ";"
            local parts_1380=("${ret_split4_v0[@]}")
            local __length_49=("${parts_1380[@]}")
            if [ "$(( ${#__length_49[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1380[0]?"Index out of bounds (at src/utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1380[1]?"Index out of bounds (at src/utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1380[2]?"Index out of bounds (at src/utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1380[3]?"Index out of bounds (at src/utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_13=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1381="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1381}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1381}" ";"
            local parts_1382=("${ret_split4_v0[@]}")
            local __length_51=("${parts_1382[@]}")
            if [ "$(( ${#__length_51[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1382[0]?"Index out of bounds (at src/utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1382[1]?"Index out of bounds (at src/utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1382[2]?"Index out of bounds (at src/utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1382[3]?"Index out of bounds (at src/utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_14=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1383="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1383}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1383}" ";"
            local parts_1384=("${ret_split4_v0[@]}")
            local __length_53=("${parts_1384[@]}")
            if [ "$(( ${#__length_53[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1384[0]?"Index out of bounds (at src/utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1384[1]?"Index out of bounds (at src/utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1384[2]?"Index out of bounds (at src/utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1384[3]?"Index out of bounds (at src/utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors308_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_15=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_12=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__309_v0() {
    inner_get_xylitol_colors__308_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_12=1
}

# colored_primary(message: Text)
colored_primary__310_v0() {
    local message_1377="${1}"
    if [ "$(( ! _got_xylitol_colors_12 ))" != 0 ]; then
        get_xylitol_colors__309_v0 
    fi
    colored_rgb__306_v0 "${message_1377}" "${_primary_color_13[0]?"Index out of bounds (at src/utils/truecolor.ab:159:48)"}" "${_primary_color_13[1]?"Index out of bounds (at src/utils/truecolor.ab:159:67)"}" "${_primary_color_13[2]?"Index out of bounds (at src/utils/truecolor.ab:159:86)"}" "${_primary_color_13[3]?"Index out of bounds (at src/utils/truecolor.ab:159:105)"}"
    ret_colored_primary310_v0="${ret_colored_rgb306_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__311_v0() {
    local message_1397="${1}"
    if [ "$(( ! _got_xylitol_colors_12 ))" != 0 ]; then
        get_xylitol_colors__309_v0 
    fi
    colored_rgb__306_v0 "${message_1397}" "${_secondary_color_14[0]?"Index out of bounds (at src/utils/truecolor.ab:166:50)"}" "${_secondary_color_14[1]?"Index out of bounds (at src/utils/truecolor.ab:166:71)"}" "${_secondary_color_14[2]?"Index out of bounds (at src/utils/truecolor.ab:166:92)"}" "${_secondary_color_14[3]?"Index out of bounds (at src/utils/truecolor.ab:166:113)"}"
    ret_colored_secondary311_v0="${ret_colored_rgb306_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__312_v0() {
    local message_1443="${1}"
    if [ "$(( ! _got_xylitol_colors_12 ))" != 0 ]; then
        get_xylitol_colors__309_v0 
    fi
    colored_rgb__306_v0 "${message_1443}" "${_accent_color_15[0]?"Index out of bounds (at src/utils/truecolor.ab:173:47)"}" "${_accent_color_15[1]?"Index out of bounds (at src/utils/truecolor.ab:173:65)"}" "${_accent_color_15[2]?"Index out of bounds (at src/utils/truecolor.ab:173:83)"}" "${_accent_color_15[3]?"Index out of bounds (at src/utils/truecolor.ab:173:101)"}"
    ret_colored_accent312_v0="${ret_colored_rgb306_v0}"
    return 0
}

# Facade over the helper modules, so every caller keeps importing one path.
# print_help()
print_help__480_v0() {
    local usage_1347=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__257_v0 usage_1347[@]
    printf '%s\n' ""
    colored_primary__310_v0 "Xylitol"
    local ret_colored_primary310_v0__9_21="${ret_colored_primary310_v0}"
    colored_primary__310_v0 "fresh"
    local ret_colored_primary310_v0__10_34="${ret_colored_primary310_v0}"
    local title_1396=("\\x1b[1m""${ret_colored_primary310_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary310_v0__10_34}" "shell" "scripts.")
    print_wrapped__257_v0 title_1396[@]
    printf '%s\n' ""
    colored_secondary__311_v0 "Flags:"
    local ret_colored_secondary311_v0__14_12="${ret_colored_secondary311_v0}"
    local array_57=()
    printf__128_v0 "${ret_colored_secondary311_v0__14_12}""
" array_57[@]
    local flag_names_1398=("-h, --help" "-v, --version")
    local flag_texts_1399=("Show this help message" "Show version information")
    local flag_notes_1400=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__256_v0 flag_names_1398[@] flag_texts_1399[@] flag_notes_1400[@] 13
    printf '%s\n' ""
    colored_secondary__311_v0 "Commands:"
    local ret_colored_secondary311_v0__21_12="${ret_colored_secondary311_v0}"
    local array_61=()
    printf__128_v0 "${ret_colored_secondary311_v0__21_12}""
" array_61[@]
    local cmd_names_1437=("input" "choose" "confirm" "file")
    local cmd_texts_1438=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1439=("" "" "" "")
    render_help_entries__256_v0 cmd_names_1437[@] cmd_texts_1438[@] cmd_notes_1439[@] 13
    printf '%s\n' ""
    colored_secondary__311_v0 "Envs:"
    local ret_colored_secondary311_v0__32_12="${ret_colored_secondary311_v0}"
    local array_65=()
    printf__128_v0 "${ret_colored_secondary311_v0__32_12}""
" array_65[@]
    local env_names_1440=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1441=("Use Perl for CJK / Optimization" "Use 24-bit color instead of the terminal palette" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1442=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: No)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__256_v0 env_names_1440[@] env_texts_1441[@] env_notes_1442[@] 0
    printf '%s\n' ""
    colored_accent__312_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent312_v0__57_16="${ret_colored_accent312_v0}"
    local footer_1444=("Run" "${ret_colored_accent312_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__257_v0 footer_1444[@]
}

# math_floor(number: Int)
math_floor__561_v0() {
    local number_2985="${1}"
    local command_70
    command_70="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_2985}")"
    __status=$?
    ret_math_floor561_v0="${command_70}"
    return 0
}

# math_ceil(number: Int)
math_ceil__562_v0() {
    local number_2984="${1}"
    math_floor__561_v0 "${number_2984}"
    local ret_math_floor561_v0__52_12="${ret_math_floor561_v0}"
    ret_math_ceil562_v0="$(( ret_math_floor561_v0__52_12 + 1 ))"
    return 0
}

# get_char()
get_char__570_v0() {
    local command_71
    command_71="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_2979="${command_71}"
    ret_get_char570_v0="${char_2979}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__573_v0() {
    local format_2949="${1}"
    local args_2950=("${!2}")
    args_2950=("${format_2949}" "${args_2950[@]}")
    __status=$?
    printf "${args_2950[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__574_v0() {
    local message_2977="${1}"
    local color_2978="${2}"
    # Prints an error message with a specified color.
    local array_72=("${message_2977}")
    eprintf__573_v0 "\\x1b[${color_2978}m%s\\x1b[0m" array_72[@]
}

# eprintf(format: Text, args: [Text])
eprintf__586_v0() {
    local format_2953="${1}"
    local args_2954=("${!2}")
    args_2954=("${format_2953}" "${args_2954[@]}")
    __status=$?
    printf "${args_2954[@]}" >&2
    __status=$?
}

# colored(message: Text, color: Int)
colored__588_v0() {
    local message_2898="${1}"
    local color_2899="${2}"
    # Returns a text wrapped in color codes.
    ret_colored588_v0="\\x1b[${color_2899}m""${message_2898}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__590_v0() {
    local cnt_2980="${1}"
    if [ "$(( cnt_2980 > 0 ))" != 0 ]; then
        local array_73=("")
        eprintf__586_v0 "\\x1b[${cnt_2980}D\\x1b[K" array_73[@]
    fi
}

# remove_line(cnt: Int)
remove_line__591_v0() {
    local cnt_2988="${1}"
    if [ "$(( cnt_2988 > 0 ))" != 0 ]; then
        local sequence_2989=""
        local __range_start_2990=0
        local __range_end_2990="${cnt_2988}"
        local __dir_2990=$(( ${__range_start_2990} <= ${__range_end_2990} ? 1 : -1 ))
        for (( ____2990=${__range_start_2990}; ____2990 * ${__dir_2990} < ${__range_end_2990} * ${__dir_2990}; ____2990+=${__dir_2990} )); do
            sequence_2989+="\\x1b[2K\\x1b[1A"
done
        local array_74=("")
        eprintf__586_v0 "${sequence_2989}" array_74[@]
    fi
    local array_75=("")
    eprintf__586_v0 "\\x1b[G" array_75[@]
}

# remove_current_line()
remove_current_line__592_v0() {
    local array_76=("")
    eprintf__586_v0 "\\x1b[2K\\x1b[G" array_76[@]
}

# new_line(cnt: Int)
new_line__594_v0() {
    local cnt_2951="${1}"
    local __range_start_2952=0
    local __range_end_2952="${cnt_2951}"
    local __dir_2952=$(( ${__range_start_2952} <= ${__range_end_2952} ? 1 : -1 ))
    for (( ____2952=${__range_start_2952}; ____2952 * ${__dir_2952} < ${__range_end_2952} * ${__dir_2952}; ____2952+=${__dir_2952} )); do
        local array_77=("")
        eprintf__586_v0 "
" array_77[@]
done
}

# go_up(cnt: Int)
go_up__595_v0() {
    local cnt_2974="${1}"
    local array_78=("")
    eprintf__586_v0 "\\x1b[${cnt_2974}A" array_78[@]
}

# go_down(cnt: Int)
go_down__596_v0() {
    local cnt_2987="${1}"
    local array_79=("")
    eprintf__586_v0 "\\x1b[${cnt_2987}B" array_79[@]
}

# move the cursor up or down `cnt` lines.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_18="None"
# perl_available()
perl_available__613_v0() {
    if [ "$([ "_${_perl_state_18}" != "_None" ]; echo $?)" != 0 ]; then
        local command_80
        command_80="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_2851
        disabled_2851="$([ "_${command_80}" != "_No" ]; echo $?)"
        local command_81
        command_81="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_2852
        found_2852="$(( $(( ! disabled_2851 )) && $([ "_${command_81}" != "_0" ]; echo $?) ))"
        _perl_state_18="$(if [ "${found_2852}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available613_v0="$([ "_${_perl_state_18}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__614_v0() {
    local text_2850="${1}"
    perl_available__613_v0 
    local ret_perl_available613_v0__22_12="${ret_perl_available613_v0}"
    if [ "$(( ! ret_perl_available613_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width614_v0=''
        return 1
    fi
    local command_82
    command_82="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2850}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width614_v0=''
        return "${__status}"
    fi
    local width_str_2853="${command_82}"
    parse_int__13_v0 "${width_str_2853}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width614_v0=''
        return "${__status}"
    fi
    local width_2854="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width614_v0="${width_2854}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__615_v0() {
    local text_2931="${1}"
    local max_width_2932="${2}"
    perl_available__613_v0 
    local ret_perl_available613_v0__33_12="${ret_perl_available613_v0}"
    if [ "$(( ! ret_perl_available613_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk615_v0=''
        return 1
    fi
    local command_83
    command_83="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_2931}" ${max_width_2932} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk615_v0=''
        return "${__status}"
    fi
    local result_2933="${command_83}"
    ret_perl_truncate_cjk615_v0="${result_2933}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__619_v0() {
    local text_2902="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_84
    command_84="$([[ "${text_2902}" == *$'\x1b'* || "${text_2902}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2903="${command_84}"
    ret_has_ansi_escape619_v0="$([ "_${has_escape_2903}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__620_v0() {
    local text_2904="${1}"
    local command_85
    command_85="$(printf '%s' "${text_2904}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi620_v0="${command_85}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__621_v0() {
    local text_2921="${1}"
    local command_86
    command_86="$(printf "%s" "${text_2921}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi621_v0="${command_86}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__622_v0() {
    local text_2923="${1}"
    local command_87
    command_87="$(printf "%s" "${text_2923}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2924="${command_87}"
    ret_is_all_ascii622_v0="$([ "_${result_2924}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__623_v0() {
    local text_2920="${1}"
    strip_ansi__621_v0 "${text_2920}"
    local stripped_2922="${ret_strip_ansi621_v0}"
    # Check if text is all ASCII
    is_all_ascii__622_v0 "${stripped_2922}"
    local ret_is_all_ascii622_v0__36_12="${ret_is_all_ascii622_v0}"
    if [ "$(( ! ret_is_all_ascii622_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__614_v0 "${stripped_2922}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_88="${stripped_2922}"
            ret_get_visible_len623_v0="${#__length_88}"
            return 0
        fi
        ret_get_visible_len623_v0="${ret_perl_get_cjk_width614_v0}"
        return 0
    else
        local __length_89="${stripped_2922}"
        ret_get_visible_len623_v0="${#__length_89}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__624_v0() {
    local text_2928="${1}"
    local max_width_2929="${2}"
    get_visible_len__623_v0 "${text_2928}"
    local visible_len_2930="${ret_get_visible_len623_v0}"
    if [ "$(( visible_len_2930 <= max_width_2929 ))" != 0 ]; then
        ret_truncate_text624_v0="${text_2928}"
        return 0
    fi
    is_all_ascii__622_v0 "${text_2928}"
    local ret_is_all_ascii622_v0__53_12="${ret_is_all_ascii622_v0}"
    if [ "$(( ! ret_is_all_ascii622_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__615_v0 "${text_2928}" "${max_width_2929}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_2928}" | cut -c1-${max_width_2929}
            __status=$?
        fi
        ret_truncate_text624_v0="${ret_perl_truncate_cjk615_v0}"
        return 0
    fi
    local command_90
    command_90="$(printf "%s" "${text_2928}" | cut -c1-${max_width_2929})"
    __status=$?
    ret_truncate_text624_v0="${command_90}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__625_v0() {
    local text_2926="${1}"
    local max_width_2927="${2}"
    has_ansi_escape__619_v0 "${text_2926}"
    local ret_has_ansi_escape619_v0__65_12="${ret_has_ansi_escape619_v0}"
    if [ "$(( ! ret_has_ansi_escape619_v0__65_12 ))" != 0 ]; then
        truncate_text__624_v0 "${text_2926}" "${max_width_2927}"
        ret_truncate_ansi625_v0="${ret_truncate_text624_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_91
    command_91="$([[ "${text_2926}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_2934="${command_91}"
    # Replace \x1b[ with newline, then split
    local command_92
    command_92="$(t="${text_2926}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_2935="${command_92}"
    split__4_v0 "${replaced_2935}" "
"
    local parts_2936=("${ret_split4_v0[@]}")
    local result_2937=""
    local remaining_width_2938="${max_width_2927}"
    local __range_start_2939=0
    local __length_93=("${parts_2936[@]}")
    local __range_end_2939="${#__length_93[@]}"
    local __dir_2939=$(( ${__range_start_2939} <= ${__range_end_2939} ? 1 : -1 ))
    for (( idx_2939=${__range_start_2939}; idx_2939 * ${__dir_2939} < ${__range_end_2939} * ${__dir_2939}; idx_2939+=${__dir_2939} )); do
        local part_2940="${parts_2936[${idx_2939}]?"Index out of bounds (at src/./input/../utils/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_2939 == 0 )) && $([ "_${starts_with_ansi_2934}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_2940}" == "_" ]; echo $?) && $(( remaining_width_2938 > 0 )) ))" != 0 ]; then
                truncate_text__624_v0 "${part_2940}" "${remaining_width_2938}"
                local ret_truncate_text624_v0__87_35="${ret_truncate_text624_v0}"
                local truncated_2941="${ret_truncate_text624_v0__87_35}"
                result_2937+="${truncated_2941}"
                get_visible_len__623_v0 "${truncated_2941}"
                local ret_get_visible_len623_v0__89_36="${ret_get_visible_len623_v0}"
                remaining_width_2938="$(( remaining_width_2938 - ret_get_visible_len623_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_94
            command_94="$(__p="${part_2940}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_2942="${command_94}"
            if [ "$([ "_${m_idx_2942}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_95
                command_95="$(__p="${part_2940}"; printf "%s" "${__p:0:${m_idx_2942}}")"
                __status=$?
                local ansi_params_2943="${command_95}"
                result_2937+="\\x1b[""${ansi_params_2943}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_2942}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_2944="${ret_parse_int13_v0__100_41}"
                local text_start_2945="$(( m_idx_num_2944 + 1 ))"
                local command_96
                command_96="$(__p="${part_2940}"; printf "%s" "${__p:${text_start_2945}}")"
                __status=$?
                local text_part_2946="${command_96}"
                if [ "$(( $([ "_${text_part_2946}" == "_" ]; echo $?) && $(( remaining_width_2938 > 0 )) ))" != 0 ]; then
                    truncate_text__624_v0 "${text_part_2946}" "${remaining_width_2938}"
                    local ret_truncate_text624_v0__104_39="${ret_truncate_text624_v0}"
                    local truncated_2947="${ret_truncate_text624_v0__104_39}"
                    result_2937+="${truncated_2947}"
                    get_visible_len__623_v0 "${truncated_2947}"
                    local ret_get_visible_len623_v0__106_40="${ret_get_visible_len623_v0}"
                    remaining_width_2938="$(( remaining_width_2938 - ret_get_visible_len623_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_2940}" == "_" ]; echo $?) && $(( remaining_width_2938 > 0 )) ))" != 0 ]; then
                    truncate_text__624_v0 "${part_2940}" "${remaining_width_2938}"
                    local ret_truncate_text624_v0__111_39="${ret_truncate_text624_v0}"
                    local truncated_2948="${ret_truncate_text624_v0__111_39}"
                    result_2937+="${truncated_2948}"
                    get_visible_len__623_v0 "${truncated_2948}"
                    local ret_get_visible_len623_v0__113_40="${ret_get_visible_len623_v0}"
                    remaining_width_2938="$(( remaining_width_2938 - ret_get_visible_len623_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi625_v0="${result_2937}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__626_v0() {
    local text_2918="${1}"
    local max_width_2919="${2}"
    get_visible_len__623_v0 "${text_2918}"
    local visible_len_2925="${ret_get_visible_len623_v0}"
    if [ "$(( visible_len_2925 <= max_width_2919 ))" != 0 ]; then
        ret_cutoff_text626_v0="${text_2918}"
        return 0
    fi
    truncate_ansi__625_v0 "${text_2918}" "$(( max_width_2919 - 3 ))"
    local ret_truncate_ansi625_v0__129_12="${ret_truncate_ansi625_v0}"
    ret_cutoff_text626_v0="${ret_truncate_ansi625_v0__129_12}""..."
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__644_v0() {
    local text_2843="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_97
    command_97="$([[ "${text_2843}" == *$'\x1b'* || "${text_2843}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2844="${command_97}"
    ret_has_ansi_escape644_v0="$([ "_${has_escape_2844}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__646_v0() {
    local text_2846="${1}"
    local command_98
    command_98="$(printf "%s" "${text_2846}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi646_v0="${command_98}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__647_v0() {
    local text_2848="${1}"
    local command_99
    command_99="$(printf "%s" "${text_2848}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2849="${command_99}"
    ret_is_all_ascii647_v0="$([ "_${result_2849}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__648_v0() {
    local text_2845="${1}"
    strip_ansi__646_v0 "${text_2845}"
    local stripped_2847="${ret_strip_ansi646_v0}"
    # Check if text is all ASCII
    is_all_ascii__647_v0 "${stripped_2847}"
    local ret_is_all_ascii647_v0__36_12="${ret_is_all_ascii647_v0}"
    if [ "$(( ! ret_is_all_ascii647_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__614_v0 "${stripped_2847}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_100="${stripped_2847}"
            ret_get_visible_len648_v0="${#__length_100}"
            return 0
        fi
        ret_get_visible_len648_v0="${ret_perl_get_cjk_width614_v0}"
        return 0
    else
        local __length_101="${stripped_2847}"
        ret_get_visible_len648_v0="${#__length_101}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_19=0
_term_size_20=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__659_v0() {
    local size_2834="${1}"
    if [ "$([ "_${size_2834}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size659_v0=0
        return 0
    fi
    split__4_v0 "${size_2834}" " "
    local parts_2835=("${ret_split4_v0[@]}")
    local __length_103=("${parts_2835[@]}")
    if [ "$(( ${#__length_103[@]} != 2 ))" != 0 ]; then
        ret_store_term_size659_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2835[1]?"Index out of bounds (at src/./input/../utils/./term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2835[0]?"Index out of bounds (at src/./input/../utils/./term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_20=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size659_v0=1
    return 0
}

# query_term_size()
query_term_size__660_v0() {
    local command_105
    command_105="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2837="${command_105}"
    store_term_size__659_v0 "${size_2837}"
    ret_query_term_size660_v0="${ret_store_term_size659_v0}"
    return 0
}

# stty_term_size()
stty_term_size__661_v0() {
    local command_106
    command_106="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2833="${command_106}"
    store_term_size__659_v0 "${size_2833}"
    ret_stty_term_size661_v0="${ret_store_term_size659_v0}"
    return 0
}

# get_term_size()
get_term_size__662_v0() {
    stty_term_size__661_v0 
    local detected_2836="${ret_stty_term_size661_v0}"
    if [ "$(( ! detected_2836 ))" != 0 ]; then
        query_term_size__660_v0 
        detected_2836="${ret_query_term_size660_v0}"
    fi
    _got_term_size_19=1
}

# term_width()
term_width__664_v0() {
    if [ "$(( ! _got_term_size_19 ))" != 0 ]; then
        get_term_size__662_v0 
    fi
    ret_term_width664_v0="${_term_size_20[0]?"Index out of bounds (at src/./input/../utils/./term.ab:93:23)"}"
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__667_v0() {
    local pending_2895="${1}"
    local line_2896="${2}"
    local note_at_2897="${3}"
    if [ "$(( note_at_2897 < 0 ))" != 0 ]; then
        local array_107=()
        printf__128_v0 "${pending_2895}""${line_2896}""
" array_107[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_2897 == 0 ))" != 0 ]; then
        colored__588_v0 "${line_2896}" 90
        local ret_colored588_v0__13_40="${ret_colored588_v0}"
        local array_108=()
        printf__128_v0 "${pending_2895}""${ret_colored588_v0__13_40}""
" array_108[@]
    else
        slice__24_v0 "${line_2896}" 0 "${note_at_2897}"
        local ret_slice24_v0__14_32="${ret_slice24_v0}"
        slice__24_v0 "${line_2896}" "${note_at_2897}" 0
        local ret_slice24_v0__14_66="${ret_slice24_v0}"
        colored__588_v0 "${ret_slice24_v0__14_66}" 90
        local ret_colored588_v0__14_58="${ret_colored588_v0}"
        local array_109=()
        printf__128_v0 "${pending_2895}""${ret_slice24_v0__14_32}""${ret_colored588_v0__14_58}""
" array_109[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__668_v0() {
    local names_2873=("${!1}")
    local texts_2874=("${!2}")
    local notes_2875=("${!3}")
    local min_name_width_2876="${4}"
    local __length_110=("${names_2873[@]}")
    local count_2877="${#__length_110[@]}"
    local name_width_2878="${min_name_width_2876}"
    local __range_start_2879=0
    local __range_end_2879="${count_2877}"
    local __dir_2879=$(( ${__range_start_2879} <= ${__range_end_2879} ? 1 : -1 ))
    for (( i_2879=${__range_start_2879}; i_2879 * ${__dir_2879} < ${__range_end_2879} * ${__dir_2879}; i_2879+=${__dir_2879} )); do
        local __length_111="${names_2873[${i_2879}]?"Index out of bounds (at src/./input/../utils/layout.ab:29:33)"}"
        local width_2880="${#__length_111}"
        if [ "$(( width_2880 > name_width_2878 ))" != 0 ]; then
            name_width_2878="${width_2880}"
        fi
done
    term_width__664_v0 
    local width_2881="${ret_term_width664_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2882="$(( name_width_2878 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2883="$(( $(( width_2881 - indent_2882 )) < 24 ))"
    if [ "${stacked_2883}" != 0 ]; then
        indent_2882=6
    fi
    local avail_2884="$(( width_2881 - indent_2882 ))"
    rpad__28_v0 "" " " "${indent_2882}"
    local blank_2885="${ret_rpad28_v0}"
    local __range_start_2886=0
    local __range_end_2886="${count_2877}"
    local __dir_2886=$(( ${__range_start_2886} <= ${__range_end_2886} ? 1 : -1 ))
    for (( i_2886=${__range_start_2886}; i_2886 * ${__dir_2886} < ${__range_end_2886} * ${__dir_2886}; i_2886+=${__dir_2886} )); do
        local pending_2887="${blank_2885}"
        if [ "${stacked_2883}" != 0 ]; then
            local array_112=()
            printf__128_v0 "  ""${names_2873[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:49:33)"}""
" array_112[@]
        else
            rpad__28_v0 "  ""${names_2873[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:51:41)"}" " " "${indent_2882}"
            local ret_rpad28_v0__51_23="${ret_rpad28_v0}"
            pending_2887="${ret_rpad28_v0__51_23}"
        fi
        split__4_v0 "${texts_2874[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:53:33)"}" " "
        local ret_split4_v0__53_21=("${ret_split4_v0[@]}")
        local words_2888=("${ret_split4_v0__53_21[@]}")
        local __length_113=("${words_2888[@]}")
        local note_start_2889="${#__length_113[@]}"
        if [ "$([ "_${notes_2875[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:55:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_114="${notes_2875[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:58:26)"}"
            if [ "$(( ${#__length_114} > avail_2884 ))" != 0 ]; then
                split__4_v0 "${notes_2875[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:59:38)"}" " "
                local ret_split4_v0__59_26=("${ret_split4_v0[@]}")
                words_2888+=("${ret_split4_v0__59_26[@]}")
            else
                local array_115=("${notes_2875[${i_2886}]?"Index out of bounds (at src/./input/../utils/layout.ab:61:33)"}")
                words_2888+=("${array_115[@]}")
            fi
        fi
        local line_2890=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2891=-1
        local __range_start_2892=0
        local __length_116=("${words_2888[@]}")
        local __range_end_2892="${#__length_116[@]}"
        local __dir_2892=$(( ${__range_start_2892} <= ${__range_end_2892} ? 1 : -1 ))
        for (( j_2892=${__range_start_2892}; j_2892 * ${__dir_2892} < ${__range_end_2892} * ${__dir_2892}; j_2892+=${__dir_2892} )); do
            local word_2893="${words_2888[${j_2892}]?"Index out of bounds (at src/./input/../utils/layout.ab:71:32)"}"
            local candidate_2894
            candidate_2894="$(if [ "$([ "_${line_2890}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2893}"; else echo "${line_2890}"" ""${word_2893}"; fi)"
            local __length_117="${candidate_2894}"
            if [ "$(( $(( ${#__length_117} > avail_2884 )) && $([ "_${line_2890}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__667_v0 "${pending_2887}" "${line_2890}" "${note_at_2891}"
                pending_2887="${blank_2885}"
                line_2890="${word_2893}"
                note_at_2891="$(if [ "$(( j_2892 >= note_start_2889 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2892 >= note_start_2889 )) && $(( note_at_2891 < 0 )) ))" != 0 ]; then
                    local __length_118="${candidate_2894}"
                    local __length_119="${word_2893}"
                    note_at_2891="$(( ${#__length_118} - ${#__length_119} ))"
                fi
                line_2890="${candidate_2894}"
            fi
done
        print_help_line__667_v0 "${pending_2887}" "${line_2890}" "${note_at_2891}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__669_v0() {
    local pieces_2832=("${!1}")
    term_width__664_v0 
    local width_2838="${ret_term_width664_v0}"
    local line_2839=""
    local line_len_2840=0
    for piece_2841 in "${pieces_2832[@]}"; do
        local __length_122="${piece_2841}"
        local piece_len_2842="${#__length_122}"
        has_ansi_escape__644_v0 "${piece_2841}"
        local ret_has_ansi_escape644_v0__100_12="${ret_has_ansi_escape644_v0}"
        if [ "${ret_has_ansi_escape644_v0__100_12}" != 0 ]; then
            get_visible_len__648_v0 "${piece_2841}"
            piece_len_2842="${ret_get_visible_len648_v0}"
        fi
        if [ "$([ "_${line_2839}" != "_" ]; echo $?)" != 0 ]; then
            line_2839="${piece_2841}"
            line_len_2840="${piece_len_2842}"
        elif [ "$(( $(( $(( line_len_2840 + 1 )) + piece_len_2842 )) > width_2838 ))" != 0 ]; then
            local array_123=()
            printf__128_v0 "${line_2839}""
" array_123[@]
            line_2839="${piece_2841}"
            line_len_2840="${piece_len_2842}"
        else
            line_2839+=" ""${piece_2841}"
            line_len_2840="$(( line_len_2840 + $(( 1 + piece_len_2842 )) ))"
        fi
    done
    if [ "$([ "_${line_2839}" == "_" ]; echo $?)" != 0 ]; then
        local array_124=()
        printf__128_v0 "${line_2839}""
" array_124[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_24=0
_term_size_25=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__698_v0() {
    local command_126
    command_126="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_2910="${command_126}"
    parse_int__13_v0 "${count_2910}"
    __status=$?
    ret_stty_count698_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__699_v0() {
    stty_count__698_v0 
    local count_num_2911="${ret_stty_count698_v0}"
    if [ "$(( count_num_2911 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2911="$(( count_num_2911 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2911}
    __status=$?
}

# stty_unlock()
stty_unlock__700_v0() {
    stty_count__698_v0 
    local count_num_2982="${ret_stty_count698_v0}"
    if [ "$(( count_num_2982 > 0 ))" != 0 ]; then
        count_num_2982="$(( count_num_2982 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2982}
        __status=$?
        if [ "$(( count_num_2982 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__701_v0() {
    local size_2913="${1}"
    if [ "$([ "_${size_2913}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size701_v0=0
        return 0
    fi
    split__4_v0 "${size_2913}" " "
    local parts_2914=("${ret_split4_v0[@]}")
    local __length_127=("${parts_2914[@]}")
    if [ "$(( ${#__length_127[@]} != 2 ))" != 0 ]; then
        ret_store_term_size701_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2914[1]?"Index out of bounds (at src/./input/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2914[0]?"Index out of bounds (at src/./input/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_25=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size701_v0=1
    return 0
}

# query_term_size()
query_term_size__702_v0() {
    local command_129
    command_129="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2916="${command_129}"
    store_term_size__701_v0 "${size_2916}"
    ret_query_term_size702_v0="${ret_store_term_size701_v0}"
    return 0
}

# stty_term_size()
stty_term_size__703_v0() {
    local command_130
    command_130="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2912="${command_130}"
    store_term_size__701_v0 "${size_2912}"
    ret_stty_term_size703_v0="${ret_store_term_size701_v0}"
    return 0
}

# get_term_size()
get_term_size__704_v0() {
    stty_term_size__703_v0 
    local detected_2915="${ret_stty_term_size703_v0}"
    if [ "$(( ! detected_2915 ))" != 0 ]; then
        query_term_size__702_v0 
        detected_2915="${ret_query_term_size702_v0}"
    fi
    _got_term_size_24=1
}

# term_width()
term_width__706_v0() {
    if [ "$(( ! _got_term_size_24 ))" != 0 ]; then
        get_term_size__704_v0 
    fi
    ret_term_width706_v0="${_term_size_25[0]?"Index out of bounds (at src/./input/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_26="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_27=0
_primary_color_28=(3 207 159 92)
_secondary_color_29=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__717_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_2867="${ret_env_var_get120_v0}"
    _supports_truecolor_26="$(if [ "$([ "_${config_2867}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor717_v0="$([ "_${_supports_truecolor_26}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__718_v0() {
    local message_2862="${1}"
    local r_2863="${2}"
    local g_2864="${3}"
    local b_2865="${4}"
    local fallback_2866="${5}"
    if [ "$([ "_${_supports_truecolor_26}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb718_v0="\\x1b[38;2;${r_2863};${g_2864};${b_2865}m""${message_2862}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_26}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__717_v0 
        local ret_get_supports_truecolor717_v0__45_17="${ret_get_supports_truecolor717_v0}"
        if [ "${ret_get_supports_truecolor717_v0__45_17}" != 0 ]; then
            ret_colored_rgb718_v0="\\x1b[38;2;${r_2863};${g_2864};${b_2865}m""${message_2862}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2866 == 0 ))" != 0 ]; then
            ret_colored_rgb718_v0="${message_2862}"
            return 0
        else
            ret_colored_rgb718_v0="\\x1b[${fallback_2866}m""${message_2862}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2866 == 0 ))" != 0 ]; then
            ret_colored_rgb718_v0="${message_2862}"
            return 0
        fi
        ret_colored_rgb718_v0="\\x1b[${fallback_2866}m""${message_2862}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__720_v0() {
    if [ "$(( ! _got_xylitol_colors_27 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2856="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2856}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2856}" ";"
            local parts_2857=("${ret_split4_v0[@]}")
            local __length_134=("${parts_2857[@]}")
            if [ "$(( ${#__length_134[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2857[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2857[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2857[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2857[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_28=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2858="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2858}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2858}" ";"
            local parts_2859=("${ret_split4_v0[@]}")
            local __length_136=("${parts_2859[@]}")
            if [ "$(( ${#__length_136[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2859[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2859[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2859[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2859[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_29=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2860="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2860}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2860}" ";"
            local parts_2861=("${ret_split4_v0[@]}")
            local __length_138=("${parts_2861[@]}")
            if [ "$(( ${#__length_138[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2861[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2861[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2861[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2861[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors720_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_27=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__721_v0() {
    inner_get_xylitol_colors__720_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_27=1
}

# colored_primary(message: Text)
colored_primary__722_v0() {
    local message_2855="${1}"
    if [ "$(( ! _got_xylitol_colors_27 ))" != 0 ]; then
        get_xylitol_colors__721_v0 
    fi
    colored_rgb__718_v0 "${message_2855}" "${_primary_color_28[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:48)"}" "${_primary_color_28[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:67)"}" "${_primary_color_28[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:86)"}" "${_primary_color_28[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary722_v0="${ret_colored_rgb718_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__723_v0() {
    local message_2869="${1}"
    if [ "$(( ! _got_xylitol_colors_27 ))" != 0 ]; then
        get_xylitol_colors__721_v0 
    fi
    colored_rgb__718_v0 "${message_2869}" "${_secondary_color_29[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:50)"}" "${_secondary_color_29[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:71)"}" "${_secondary_color_29[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:92)"}" "${_secondary_color_29[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary723_v0="${ret_colored_rgb718_v0}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__741_v0() {
    local format_2963="${1}"
    local args_2964=("${!2}")
    args_2964=("${format_2963}" "${args_2964[@]}")
    __status=$?
    printf "${args_2964[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__742_v0() {
    local message_2961="${1}"
    local color_2962="${2}"
    # Prints an error message with a specified color.
    local array_140=("${message_2961}")
    eprintf__741_v0 "\\x1b[${color_2962}m%s\\x1b[0m" array_140[@]
}

# colored(message: Text, color: Int)
colored__743_v0() {
    local message_2965="${1}"
    local color_2966="${2}"
    # Returns a text wrapped in color codes.
    ret_colored743_v0="\\x1b[${color_2966}m""${message_2965}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__747_v0() {
    local items_2955=("${!1}")
    local total_len_2956="${2}"
    local term_width_2957="${3}"
    local separator_2958=" • "
    local separator_len_2959=3
    # Fast path: no truncation needed
    if [ "$(( total_len_2956 <= term_width_2957 ))" != 0 ]; then
        local iter_2960=0
        while :
        do
            local __length_141=("${items_2955[@]}")
            if [ "$(( iter_2960 >= ${#__length_141[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_2960 > 0 ))" != 0 ]; then
                eprintf_colored__742_v0 "${separator_2958}" 90
            fi
            colored__743_v0 "${items_2955[$(( iter_2960 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored743_v0__23_41="${ret_colored743_v0}"
            local array_142=("")
            eprintf__741_v0 "${items_2955[${iter_2960}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored743_v0__23_41}" array_142[@]
            iter_2960="$(( iter_2960 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_2967=0
        local first_2968=1
        local iter_2969=0
        while :
        do
            local __length_143=("${items_2955[@]}")
            if [ "$(( iter_2969 >= ${#__length_143[@]} ))" != 0 ]; then
                break
            fi
            local key_2970="${items_2955[${iter_2969}]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:35:31)"}"
            local action_2971="${items_2955[$(( iter_2969 + 1 ))]?"Index out of bounds (at src/./input/../utils/widget/tooltip.ab:36:34)"}"
            local __length_144="${key_2970}"
            local __length_145="${action_2971}"
            local part_len_2972="$(( $(( ${#__length_144} + 1 )) + ${#__length_145} ))"
            local needed_2973="${part_len_2972}"
            if [ "$(( ! first_2968 ))" != 0 ]; then
                needed_2973="$(( needed_2973 + separator_len_2959 ))"
            fi
            if [ "$(( $(( current_len_2967 + needed_2973 )) > term_width_2957 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_2968 ))" != 0 ]; then
                eprintf_colored__742_v0 "${separator_2958}" 90
            fi
            colored__743_v0 "${action_2971}" 2
            local ret_colored743_v0__51_33="${ret_colored743_v0}"
            local array_146=("")
            eprintf__741_v0 "${key_2970}"" ""${ret_colored743_v0__51_33}" array_146[@]
            current_len_2967="$(( current_len_2967 + needed_2973 ))"
            first_2968=0
            iter_2969="$(( iter_2969 + 2 ))"
        done
    fi
}

# Facade over the helper modules, so every caller keeps importing one path.
# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__799_v0() {
    local prompt_2906="${1}"
    local placeholder_2907="${2}"
    local header_2908="${3}"
    local password_2909="${4}"
    stty_lock__699_v0 
    term_width__706_v0 
    local term_width_2917="${ret_term_width706_v0}"
    if [ "$([ "_${header_2908}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__626_v0 "${header_2908}" "${term_width_2917}"
        local ret_cutoff_text626_v0__25_17="${ret_cutoff_text626_v0}"
        local array_147=("")
        eprintf__573_v0 "${ret_cutoff_text626_v0__25_17}""
" array_147[@]
    fi
    new_line__594_v0 2
    # "enter submit" = 12
    local array_148=("enter" "submit")
    render_tooltip__747_v0 array_148[@] 12 "${term_width_2917}"
    go_up__595_v0 2
    local array_149=("")
    eprintf__573_v0 "\\x1b[G" array_149[@]
    # Showing the placeholder means swallowing the first keypress to know when
    # to erase it, and only `read -i` can hand that character back. Shells
    # without it skip the placeholder rather than lose what was typed.
    local command_150
    command_150="$([ "${EXEC_SHELL_VERSION[0]}" -ge 4 ] && echo 1 || echo 0)"
    __status=$?
    local can_preset_2975="${command_150}"
    local char_2976=""
    local array_151=("")
    eprintf__573_v0 "${prompt_2906}" array_151[@]
    if [ "$([ "_${can_preset_2975}" != "_1" ]; echo $?)" != 0 ]; then
        eprintf_colored__574_v0 "${placeholder_2907}" 90
        get_char__570_v0 
        char_2976="${ret_get_char570_v0}"
        local __length_152="${placeholder_2907}"
        remove__590_v0 "$(( ${#__length_152} + 1 ))"
    fi
    local __length_153="${prompt_2906}"
    remove__590_v0 "${#__length_153}"
    local text_2981=""
    if [ "$(( ! password_2909 ))" != 0 ]; then
        stty_unlock__700_v0 
        local command_154
        command_154="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -e -i "${char_2976}" -p "${prompt_2906}" text < /dev/tty; else read -e -p "${prompt_2906}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2981="${command_154}"
    else
        stty_unlock__700_v0 
        local command_155
        command_155="$(if [ "${EXEC_SHELL_VERSION[0]}" -ge 4 ]; then read -es -i "${char_2976}" -p "${prompt_2906}" text < /dev/tty; else read -es -p "${prompt_2906}" text < /dev/tty; fi; printf "%s" "$text")"
        __status=$?
        text_2981="${command_155}"
    fi
    stty_lock__699_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__623_v0 "${prompt_2906}""${text_2981}"
    local input_display_len_2983="${ret_get_visible_len623_v0}"
    math_ceil__562_v0 "$(( input_display_len_2983 / term_width_2917 ))"
    local input_lines_2986="${ret_math_ceil562_v0}"
    if [ "$(( input_lines_2986 < 3 ))" != 0 ]; then
        go_down__596_v0 "$(( 2 - input_lines_2986 ))"
        remove_line__591_v0 2
        remove_current_line__592_v0 
    fi
    if [ "$(( input_lines_2986 >= 3 ))" != 0 ]; then
        remove_line__591_v0 "${input_lines_2986}"
    fi
    if [ "$([ "_${header_2908}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__591_v0 1
        remove_current_line__592_v0 
    fi
    stty_unlock__700_v0 
    ret_xyl_input799_v0="${text_2981}"
    return 0
}

# print_input_help()
print_input_help__893_v0() {
    local usage_2831=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__669_v0 usage_2831[@]
    printf '%s\n' ""
    colored_primary__722_v0 "input"
    local ret_colored_primary722_v0__8_20="${ret_colored_primary722_v0}"
    local title_2868=("${ret_colored_primary722_v0__8_20}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__669_v0 title_2868[@]
    printf '%s\n' ""
    colored_secondary__723_v0 "Flags:"
    local ret_colored_secondary723_v0__11_12="${ret_colored_secondary723_v0}"
    local array_158=()
    printf__128_v0 "${ret_colored_secondary723_v0__11_12}""
" array_158[@]
    local names_2870=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2871=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2872=("" "(default: 'Type here...', needs Bash 4.0)" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__668_v0 names_2870[@] texts_2871[@] notes_2872[@] 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__945_v0() {
    local parameters_2825=("${!1}")
    local prompt_2826="> "
    local placeholder_2827="Type here..."
    local header_2828=""
    local password_2829=0
    for param_2830 in "${parameters_2825[@]}"; do
        if [ "$(( $([ "_${param_2830}" != "_-h" ]; echo $?) || $([ "_${param_2830}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__893_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2830}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_164="--prompt="
            slice__24_v0 "${param_2830}" "${#__length_164}" 0
            prompt_2826="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2830}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_165="--placeholder="
            slice__24_v0 "${param_2830}" "${#__length_165}" 0
            placeholder_2827="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2830}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_166="--header="
            slice__24_v0 "${param_2830}" "${#__length_166}" 0
            header_2828="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2830}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2829=1
        fi
    done
    has_ansi_escape__619_v0 "${header_2828}"
    local ret_has_ansi_escape619_v0__31_44="${ret_has_ansi_escape619_v0}"
    escape_ansi__620_v0 "${header_2828}"
    local ret_escape_ansi620_v0__31_73="${ret_escape_ansi620_v0}"
    colored_primary__722_v0 "${header_2828}"
    local ret_colored_primary722_v0__31_111="${ret_colored_primary722_v0}"
    local display_header_2905
    display_header_2905="$(if [ "$(( $([ "_${header_2828}" != "_" ]; echo $?) || ret_has_ansi_escape619_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi620_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary722_v0__31_111}"; fi)"
    xyl_input__799_v0 "${prompt_2826}" "${placeholder_2827}" "${display_header_2905}" "${password_2829}"
    ret_execute_input945_v0="${ret_xyl_input799_v0}"
    return 0
}

# get_key()
get_key__1026_v0() {
    local command_167
    command_167="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16548="${command_167}"
    if [ "$([ "_${var_16548}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1026_v0="UP"
        return 0
    elif [ "$([ "_${var_16548}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1026_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16548}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1026_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16548}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1026_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16548}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1026_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16548}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1026_v0="INPUT"
        return 0
    else
        ret_get_key1026_v0="${var_16548}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1028_v0() {
    local format_16437="${1}"
    local args_16438=("${!2}")
    args_16438=("${format_16437}" "${args_16438[@]}")
    __status=$?
    printf "${args_16438[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1029_v0() {
    local message_16435="${1}"
    local color_16436="${2}"
    # Prints an error message with a specified color.
    local array_168=("${message_16435}")
    eprintf__1028_v0 "\\x1b[${color_16436}m%s\\x1b[0m" array_168[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1041_v0() {
    local format_16458="${1}"
    local args_16459=("${!2}")
    args_16459=("${format_16458}" "${args_16459[@]}")
    __status=$?
    printf "${args_16459[@]}" >&2
    __status=$?
}

# colored(message: Text, color: Int)
colored__1043_v0() {
    local message_16429="${1}"
    local color_16430="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1043_v0="\\x1b[${color_16430}m""${message_16429}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1046_v0() {
    local cnt_16545="${1}"
    if [ "$(( cnt_16545 > 0 ))" != 0 ]; then
        local sequence_16546=""
        local __range_start_16547=0
        local __range_end_16547="${cnt_16545}"
        local __dir_16547=$(( ${__range_start_16547} <= ${__range_end_16547} ? 1 : -1 ))
        for (( ____16547=${__range_start_16547}; ____16547 * ${__dir_16547} < ${__range_end_16547} * ${__dir_16547}; ____16547+=${__dir_16547} )); do
            sequence_16546+="\\x1b[2K\\x1b[1A"
done
        local array_169=("")
        eprintf__1041_v0 "${sequence_16546}" array_169[@]
    fi
    local array_170=("")
    eprintf__1041_v0 "\\x1b[G" array_170[@]
}

# remove_current_line()
remove_current_line__1047_v0() {
    local array_171=("")
    eprintf__1041_v0 "\\x1b[2K\\x1b[G" array_171[@]
}

# print_blank(cnt: Int)
print_blank__1048_v0() {
    local cnt_16536="${1}"
    printf '%*s' "${cnt_16536}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1049_v0() {
    local cnt_16499="${1}"
    local __range_start_16500=0
    local __range_end_16500="${cnt_16499}"
    local __dir_16500=$(( ${__range_start_16500} <= ${__range_end_16500} ? 1 : -1 ))
    for (( ____16500=${__range_start_16500}; ____16500 * ${__dir_16500} < ${__range_end_16500} * ${__dir_16500}; ____16500+=${__dir_16500} )); do
        local array_172=("")
        eprintf__1041_v0 "
" array_172[@]
done
}

# go_up(cnt: Int)
go_up__1050_v0() {
    local cnt_16520="${1}"
    local array_173=("")
    eprintf__1041_v0 "\\x1b[${cnt_16520}A" array_173[@]
}

# go_down(cnt: Int)
go_down__1051_v0() {
    local cnt_16557="${1}"
    local array_174=("")
    eprintf__1041_v0 "\\x1b[${cnt_16557}B" array_174[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1052_v0() {
    local cnt_16566="${1}"
    if [ "$(( cnt_16566 > 0 ))" != 0 ]; then
        go_down__1051_v0 "${cnt_16566}"
    else
        go_up__1050_v0 "$(( - cnt_16566 ))"
    fi
}

# hide_cursor()
hide_cursor__1053_v0() {
    local array_175=("")
    eprintf__1041_v0 "\\x1b[?25l" array_175[@]
}

# show_cursor()
show_cursor__1054_v0() {
    local array_176=("")
    eprintf__1041_v0 "\\x1b[?25h" array_176[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_34="None"
# perl_available()
perl_available__1068_v0() {
    if [ "$([ "_${_perl_state_34}" != "_None" ]; echo $?)" != 0 ]; then
        local command_177
        command_177="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_16395
        disabled_16395="$([ "_${command_177}" != "_No" ]; echo $?)"
        local command_178
        command_178="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_16396
        found_16396="$(( $(( ! disabled_16395 )) && $([ "_${command_178}" != "_0" ]; echo $?) ))"
        _perl_state_34="$(if [ "${found_16396}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1068_v0="$([ "_${_perl_state_34}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1069_v0() {
    local text_16394="${1}"
    perl_available__1068_v0 
    local ret_perl_available1068_v0__22_12="${ret_perl_available1068_v0}"
    if [ "$(( ! ret_perl_available1068_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1069_v0=''
        return 1
    fi
    local command_179
    command_179="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16394}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1069_v0=''
        return "${__status}"
    fi
    local width_str_16397="${command_179}"
    parse_int__13_v0 "${width_str_16397}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1069_v0=''
        return "${__status}"
    fi
    local width_16398="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1069_v0="${width_16398}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1070_v0() {
    local text_16480="${1}"
    local max_width_16481="${2}"
    perl_available__1068_v0 
    local ret_perl_available1068_v0__33_12="${ret_perl_available1068_v0}"
    if [ "$(( ! ret_perl_available1068_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1070_v0=''
        return 1
    fi
    local command_180
    command_180="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16480}" ${max_width_16481} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1070_v0=''
        return "${__status}"
    fi
    local result_16482="${command_180}"
    ret_perl_truncate_cjk1070_v0="${result_16482}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1074_v0() {
    local text_16440="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_181
    command_181="$([[ "${text_16440}" == *$'\x1b'* || "${text_16440}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16441="${command_181}"
    ret_has_ansi_escape1074_v0="$([ "_${has_escape_16441}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1075_v0() {
    local text_16442="${1}"
    local command_182
    command_182="$(printf '%s' "${text_16442}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1075_v0="${command_182}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1076_v0() {
    local text_16470="${1}"
    local command_183
    command_183="$(printf "%s" "${text_16470}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1076_v0="${command_183}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1077_v0() {
    local text_16472="${1}"
    local command_184
    command_184="$(printf "%s" "${text_16472}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16473="${command_184}"
    ret_is_all_ascii1077_v0="$([ "_${result_16473}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1078_v0() {
    local text_16469="${1}"
    strip_ansi__1076_v0 "${text_16469}"
    local stripped_16471="${ret_strip_ansi1076_v0}"
    # Check if text is all ASCII
    is_all_ascii__1077_v0 "${stripped_16471}"
    local ret_is_all_ascii1077_v0__36_12="${ret_is_all_ascii1077_v0}"
    if [ "$(( ! ret_is_all_ascii1077_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1069_v0 "${stripped_16471}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_185="${stripped_16471}"
            ret_get_visible_len1078_v0="${#__length_185}"
            return 0
        fi
        ret_get_visible_len1078_v0="${ret_perl_get_cjk_width1069_v0}"
        return 0
    else
        local __length_186="${stripped_16471}"
        ret_get_visible_len1078_v0="${#__length_186}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1079_v0() {
    local text_16477="${1}"
    local max_width_16478="${2}"
    get_visible_len__1078_v0 "${text_16477}"
    local visible_len_16479="${ret_get_visible_len1078_v0}"
    if [ "$(( visible_len_16479 <= max_width_16478 ))" != 0 ]; then
        ret_truncate_text1079_v0="${text_16477}"
        return 0
    fi
    is_all_ascii__1077_v0 "${text_16477}"
    local ret_is_all_ascii1077_v0__53_12="${ret_is_all_ascii1077_v0}"
    if [ "$(( ! ret_is_all_ascii1077_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1070_v0 "${text_16477}" "${max_width_16478}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16477}" | cut -c1-${max_width_16478}
            __status=$?
        fi
        ret_truncate_text1079_v0="${ret_perl_truncate_cjk1070_v0}"
        return 0
    fi
    local command_187
    command_187="$(printf "%s" "${text_16477}" | cut -c1-${max_width_16478})"
    __status=$?
    ret_truncate_text1079_v0="${command_187}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1080_v0() {
    local text_16475="${1}"
    local max_width_16476="${2}"
    has_ansi_escape__1074_v0 "${text_16475}"
    local ret_has_ansi_escape1074_v0__65_12="${ret_has_ansi_escape1074_v0}"
    if [ "$(( ! ret_has_ansi_escape1074_v0__65_12 ))" != 0 ]; then
        truncate_text__1079_v0 "${text_16475}" "${max_width_16476}"
        ret_truncate_ansi1080_v0="${ret_truncate_text1079_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_188
    command_188="$([[ "${text_16475}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16483="${command_188}"
    # Replace \x1b[ with newline, then split
    local command_189
    command_189="$(t="${text_16475}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16484="${command_189}"
    split__4_v0 "${replaced_16484}" "
"
    local parts_16485=("${ret_split4_v0[@]}")
    local result_16486=""
    local remaining_width_16487="${max_width_16476}"
    local __range_start_16488=0
    local __length_190=("${parts_16485[@]}")
    local __range_end_16488="${#__length_190[@]}"
    local __dir_16488=$(( ${__range_start_16488} <= ${__range_end_16488} ? 1 : -1 ))
    for (( idx_16488=${__range_start_16488}; idx_16488 * ${__dir_16488} < ${__range_end_16488} * ${__dir_16488}; idx_16488+=${__dir_16488} )); do
        local part_16489="${parts_16485[${idx_16488}]?"Index out of bounds (at src/./choose/../utils/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16488 == 0 )) && $([ "_${starts_with_ansi_16483}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16489}" == "_" ]; echo $?) && $(( remaining_width_16487 > 0 )) ))" != 0 ]; then
                truncate_text__1079_v0 "${part_16489}" "${remaining_width_16487}"
                local ret_truncate_text1079_v0__87_35="${ret_truncate_text1079_v0}"
                local truncated_16490="${ret_truncate_text1079_v0__87_35}"
                result_16486+="${truncated_16490}"
                get_visible_len__1078_v0 "${truncated_16490}"
                local ret_get_visible_len1078_v0__89_36="${ret_get_visible_len1078_v0}"
                remaining_width_16487="$(( remaining_width_16487 - ret_get_visible_len1078_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_191
            command_191="$(__p="${part_16489}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16491="${command_191}"
            if [ "$([ "_${m_idx_16491}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_192
                command_192="$(__p="${part_16489}"; printf "%s" "${__p:0:${m_idx_16491}}")"
                __status=$?
                local ansi_params_16492="${command_192}"
                result_16486+="\\x1b[""${ansi_params_16492}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16491}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_16493="${ret_parse_int13_v0__100_41}"
                local text_start_16494="$(( m_idx_num_16493 + 1 ))"
                local command_193
                command_193="$(__p="${part_16489}"; printf "%s" "${__p:${text_start_16494}}")"
                __status=$?
                local text_part_16495="${command_193}"
                if [ "$(( $([ "_${text_part_16495}" == "_" ]; echo $?) && $(( remaining_width_16487 > 0 )) ))" != 0 ]; then
                    truncate_text__1079_v0 "${text_part_16495}" "${remaining_width_16487}"
                    local ret_truncate_text1079_v0__104_39="${ret_truncate_text1079_v0}"
                    local truncated_16496="${ret_truncate_text1079_v0__104_39}"
                    result_16486+="${truncated_16496}"
                    get_visible_len__1078_v0 "${truncated_16496}"
                    local ret_get_visible_len1078_v0__106_40="${ret_get_visible_len1078_v0}"
                    remaining_width_16487="$(( remaining_width_16487 - ret_get_visible_len1078_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16489}" == "_" ]; echo $?) && $(( remaining_width_16487 > 0 )) ))" != 0 ]; then
                    truncate_text__1079_v0 "${part_16489}" "${remaining_width_16487}"
                    local ret_truncate_text1079_v0__111_39="${ret_truncate_text1079_v0}"
                    local truncated_16497="${ret_truncate_text1079_v0__111_39}"
                    result_16486+="${truncated_16497}"
                    get_visible_len__1078_v0 "${truncated_16497}"
                    local ret_get_visible_len1078_v0__113_40="${ret_get_visible_len1078_v0}"
                    remaining_width_16487="$(( remaining_width_16487 - ret_get_visible_len1078_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1080_v0="${result_16486}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1081_v0() {
    local text_16467="${1}"
    local max_width_16468="${2}"
    get_visible_len__1078_v0 "${text_16467}"
    local visible_len_16474="${ret_get_visible_len1078_v0}"
    if [ "$(( visible_len_16474 <= max_width_16468 ))" != 0 ]; then
        ret_cutoff_text1081_v0="${text_16467}"
        return 0
    fi
    truncate_ansi__1080_v0 "${text_16467}" "$(( max_width_16468 - 3 ))"
    local ret_truncate_ansi1080_v0__129_12="${ret_truncate_ansi1080_v0}"
    ret_cutoff_text1081_v0="${ret_truncate_ansi1080_v0__129_12}""..."
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1099_v0() {
    local text_16387="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_194
    command_194="$([[ "${text_16387}" == *$'\x1b'* || "${text_16387}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16388="${command_194}"
    ret_has_ansi_escape1099_v0="$([ "_${has_escape_16388}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1101_v0() {
    local text_16390="${1}"
    local command_195
    command_195="$(printf "%s" "${text_16390}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1101_v0="${command_195}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1102_v0() {
    local text_16392="${1}"
    local command_196
    command_196="$(printf "%s" "${text_16392}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16393="${command_196}"
    ret_is_all_ascii1102_v0="$([ "_${result_16393}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1103_v0() {
    local text_16389="${1}"
    strip_ansi__1101_v0 "${text_16389}"
    local stripped_16391="${ret_strip_ansi1101_v0}"
    # Check if text is all ASCII
    is_all_ascii__1102_v0 "${stripped_16391}"
    local ret_is_all_ascii1102_v0__36_12="${ret_is_all_ascii1102_v0}"
    if [ "$(( ! ret_is_all_ascii1102_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1069_v0 "${stripped_16391}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_197="${stripped_16391}"
            ret_get_visible_len1103_v0="${#__length_197}"
            return 0
        fi
        ret_get_visible_len1103_v0="${ret_perl_get_cjk_width1069_v0}"
        return 0
    else
        local __length_198="${stripped_16391}"
        ret_get_visible_len1103_v0="${#__length_198}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_35=0
_term_size_36=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__1114_v0() {
    local size_16378="${1}"
    if [ "$([ "_${size_16378}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1114_v0=0
        return 0
    fi
    split__4_v0 "${size_16378}" " "
    local parts_16379=("${ret_split4_v0[@]}")
    local __length_200=("${parts_16379[@]}")
    if [ "$(( ${#__length_200[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1114_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16379[1]?"Index out of bounds (at src/./choose/../utils/./term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16379[0]?"Index out of bounds (at src/./choose/../utils/./term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_36=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1114_v0=1
    return 0
}

# query_term_size()
query_term_size__1115_v0() {
    local command_202
    command_202="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16381="${command_202}"
    store_term_size__1114_v0 "${size_16381}"
    ret_query_term_size1115_v0="${ret_store_term_size1114_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1116_v0() {
    local command_203
    command_203="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16377="${command_203}"
    store_term_size__1114_v0 "${size_16377}"
    ret_stty_term_size1116_v0="${ret_store_term_size1114_v0}"
    return 0
}

# get_term_size()
get_term_size__1117_v0() {
    stty_term_size__1116_v0 
    local detected_16380="${ret_stty_term_size1116_v0}"
    if [ "$(( ! detected_16380 ))" != 0 ]; then
        query_term_size__1115_v0 
        detected_16380="${ret_query_term_size1115_v0}"
    fi
    _got_term_size_35=1
}

# term_width()
term_width__1119_v0() {
    if [ "$(( ! _got_term_size_35 ))" != 0 ]; then
        get_term_size__1117_v0 
    fi
    ret_term_width1119_v0="${_term_size_36[0]?"Index out of bounds (at src/./choose/../utils/./term.ab:93:23)"}"
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1122_v0() {
    local pending_16426="${1}"
    local line_16427="${2}"
    local note_at_16428="${3}"
    if [ "$(( note_at_16428 < 0 ))" != 0 ]; then
        local array_204=()
        printf__128_v0 "${pending_16426}""${line_16427}""
" array_204[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16428 == 0 ))" != 0 ]; then
        colored__1043_v0 "${line_16427}" 90
        local ret_colored1043_v0__13_40="${ret_colored1043_v0}"
        local array_205=()
        printf__128_v0 "${pending_16426}""${ret_colored1043_v0__13_40}""
" array_205[@]
    else
        slice__24_v0 "${line_16427}" 0 "${note_at_16428}"
        local ret_slice24_v0__14_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16427}" "${note_at_16428}" 0
        local ret_slice24_v0__14_66="${ret_slice24_v0}"
        colored__1043_v0 "${ret_slice24_v0__14_66}" 90
        local ret_colored1043_v0__14_58="${ret_colored1043_v0}"
        local array_206=()
        printf__128_v0 "${pending_16426}""${ret_slice24_v0__14_32}""${ret_colored1043_v0__14_58}""
" array_206[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1123_v0() {
    local names_16404=("${!1}")
    local texts_16405=("${!2}")
    local notes_16406=("${!3}")
    local min_name_width_16407="${4}"
    local __length_207=("${names_16404[@]}")
    local count_16408="${#__length_207[@]}"
    local name_width_16409="${min_name_width_16407}"
    local __range_start_16410=0
    local __range_end_16410="${count_16408}"
    local __dir_16410=$(( ${__range_start_16410} <= ${__range_end_16410} ? 1 : -1 ))
    for (( i_16410=${__range_start_16410}; i_16410 * ${__dir_16410} < ${__range_end_16410} * ${__dir_16410}; i_16410+=${__dir_16410} )); do
        local __length_208="${names_16404[${i_16410}]?"Index out of bounds (at src/./choose/../utils/layout.ab:29:33)"}"
        local width_16411="${#__length_208}"
        if [ "$(( width_16411 > name_width_16409 ))" != 0 ]; then
            name_width_16409="${width_16411}"
        fi
done
    term_width__1119_v0 
    local width_16412="${ret_term_width1119_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16413="$(( name_width_16409 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16414="$(( $(( width_16412 - indent_16413 )) < 24 ))"
    if [ "${stacked_16414}" != 0 ]; then
        indent_16413=6
    fi
    local avail_16415="$(( width_16412 - indent_16413 ))"
    rpad__28_v0 "" " " "${indent_16413}"
    local blank_16416="${ret_rpad28_v0}"
    local __range_start_16417=0
    local __range_end_16417="${count_16408}"
    local __dir_16417=$(( ${__range_start_16417} <= ${__range_end_16417} ? 1 : -1 ))
    for (( i_16417=${__range_start_16417}; i_16417 * ${__dir_16417} < ${__range_end_16417} * ${__dir_16417}; i_16417+=${__dir_16417} )); do
        local pending_16418="${blank_16416}"
        if [ "${stacked_16414}" != 0 ]; then
            local array_209=()
            printf__128_v0 "  ""${names_16404[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:49:33)"}""
" array_209[@]
        else
            rpad__28_v0 "  ""${names_16404[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:51:41)"}" " " "${indent_16413}"
            local ret_rpad28_v0__51_23="${ret_rpad28_v0}"
            pending_16418="${ret_rpad28_v0__51_23}"
        fi
        split__4_v0 "${texts_16405[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:53:33)"}" " "
        local ret_split4_v0__53_21=("${ret_split4_v0[@]}")
        local words_16419=("${ret_split4_v0__53_21[@]}")
        local __length_210=("${words_16419[@]}")
        local note_start_16420="${#__length_210[@]}"
        if [ "$([ "_${notes_16406[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:55:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_211="${notes_16406[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:58:26)"}"
            if [ "$(( ${#__length_211} > avail_16415 ))" != 0 ]; then
                split__4_v0 "${notes_16406[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:59:38)"}" " "
                local ret_split4_v0__59_26=("${ret_split4_v0[@]}")
                words_16419+=("${ret_split4_v0__59_26[@]}")
            else
                local array_212=("${notes_16406[${i_16417}]?"Index out of bounds (at src/./choose/../utils/layout.ab:61:33)"}")
                words_16419+=("${array_212[@]}")
            fi
        fi
        local line_16421=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16422=-1
        local __range_start_16423=0
        local __length_213=("${words_16419[@]}")
        local __range_end_16423="${#__length_213[@]}"
        local __dir_16423=$(( ${__range_start_16423} <= ${__range_end_16423} ? 1 : -1 ))
        for (( j_16423=${__range_start_16423}; j_16423 * ${__dir_16423} < ${__range_end_16423} * ${__dir_16423}; j_16423+=${__dir_16423} )); do
            local word_16424="${words_16419[${j_16423}]?"Index out of bounds (at src/./choose/../utils/layout.ab:71:32)"}"
            local candidate_16425
            candidate_16425="$(if [ "$([ "_${line_16421}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16424}"; else echo "${line_16421}"" ""${word_16424}"; fi)"
            local __length_214="${candidate_16425}"
            if [ "$(( $(( ${#__length_214} > avail_16415 )) && $([ "_${line_16421}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1122_v0 "${pending_16418}" "${line_16421}" "${note_at_16422}"
                pending_16418="${blank_16416}"
                line_16421="${word_16424}"
                note_at_16422="$(if [ "$(( j_16423 >= note_start_16420 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16423 >= note_start_16420 )) && $(( note_at_16422 < 0 )) ))" != 0 ]; then
                    local __length_215="${candidate_16425}"
                    local __length_216="${word_16424}"
                    note_at_16422="$(( ${#__length_215} - ${#__length_216} ))"
                fi
                line_16421="${candidate_16425}"
            fi
done
        print_help_line__1122_v0 "${pending_16418}" "${line_16421}" "${note_at_16422}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1124_v0() {
    local pieces_16376=("${!1}")
    term_width__1119_v0 
    local width_16382="${ret_term_width1119_v0}"
    local line_16383=""
    local line_len_16384=0
    for piece_16385 in "${pieces_16376[@]}"; do
        local __length_219="${piece_16385}"
        local piece_len_16386="${#__length_219}"
        has_ansi_escape__1099_v0 "${piece_16385}"
        local ret_has_ansi_escape1099_v0__100_12="${ret_has_ansi_escape1099_v0}"
        if [ "${ret_has_ansi_escape1099_v0__100_12}" != 0 ]; then
            get_visible_len__1103_v0 "${piece_16385}"
            piece_len_16386="${ret_get_visible_len1103_v0}"
        fi
        if [ "$([ "_${line_16383}" != "_" ]; echo $?)" != 0 ]; then
            line_16383="${piece_16385}"
            line_len_16384="${piece_len_16386}"
        elif [ "$(( $(( $(( line_len_16384 + 1 )) + piece_len_16386 )) > width_16382 ))" != 0 ]; then
            local array_220=()
            printf__128_v0 "${line_16383}""
" array_220[@]
            line_16383="${piece_16385}"
            line_len_16384="${piece_len_16386}"
        else
            line_16383+=" ""${piece_16385}"
            line_len_16384="$(( line_len_16384 + $(( 1 + piece_len_16386 )) ))"
        fi
    done
    if [ "$([ "_${line_16383}" == "_" ]; echo $?)" != 0 ]; then
        local array_221=()
        printf__128_v0 "${line_16383}""
" array_221[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_40=0
_term_size_41=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1153_v0() {
    local command_223
    command_223="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_16456="${command_223}"
    parse_int__13_v0 "${count_16456}"
    __status=$?
    ret_stty_count1153_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1154_v0() {
    stty_count__1153_v0 
    local count_num_16457="${ret_stty_count1153_v0}"
    if [ "$(( count_num_16457 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16457="$(( count_num_16457 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16457}
    __status=$?
}

# stty_unlock()
stty_unlock__1155_v0() {
    stty_count__1153_v0 
    local count_num_16570="${ret_stty_count1153_v0}"
    if [ "$(( count_num_16570 > 0 ))" != 0 ]; then
        count_num_16570="$(( count_num_16570 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16570}
        __status=$?
        if [ "$(( count_num_16570 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1156_v0() {
    local size_16461="${1}"
    if [ "$([ "_${size_16461}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1156_v0=0
        return 0
    fi
    split__4_v0 "${size_16461}" " "
    local parts_16462=("${ret_split4_v0[@]}")
    local __length_224=("${parts_16462[@]}")
    if [ "$(( ${#__length_224[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1156_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16462[1]?"Index out of bounds (at src/./choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16462[0]?"Index out of bounds (at src/./choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_41=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1156_v0=1
    return 0
}

# query_term_size()
query_term_size__1157_v0() {
    local command_226
    command_226="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16464="${command_226}"
    store_term_size__1156_v0 "${size_16464}"
    ret_query_term_size1157_v0="${ret_store_term_size1156_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1158_v0() {
    local command_227
    command_227="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16460="${command_227}"
    store_term_size__1156_v0 "${size_16460}"
    ret_stty_term_size1158_v0="${ret_store_term_size1156_v0}"
    return 0
}

# get_term_size()
get_term_size__1159_v0() {
    stty_term_size__1158_v0 
    local detected_16463="${ret_stty_term_size1158_v0}"
    if [ "$(( ! detected_16463 ))" != 0 ]; then
        query_term_size__1157_v0 
        detected_16463="${ret_query_term_size1157_v0}"
    fi
    _got_term_size_40=1
}

# term_width()
term_width__1161_v0() {
    if [ "$(( ! _got_term_size_40 ))" != 0 ]; then
        get_term_size__1159_v0 
    fi
    ret_term_width1161_v0="${_term_size_41[0]?"Index out of bounds (at src/./choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__1162_v0() {
    if [ "$(( ! _got_term_size_40 ))" != 0 ]; then
        get_term_size__1159_v0 
    fi
    ret_term_height1162_v0="${_term_size_41[1]?"Index out of bounds (at src/./choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_42="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_43=0
_primary_color_44=(3 207 159 92)
_secondary_color_45=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1172_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_16366="${ret_env_var_get120_v0}"
    _supports_truecolor_42="$(if [ "$([ "_${config_16366}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1172_v0="$([ "_${_supports_truecolor_42}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1173_v0() {
    local message_16361="${1}"
    local r_16362="${2}"
    local g_16363="${3}"
    local b_16364="${4}"
    local fallback_16365="${5}"
    if [ "$([ "_${_supports_truecolor_42}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1173_v0="\\x1b[38;2;${r_16362};${g_16363};${b_16364}m""${message_16361}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_42}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1172_v0 
        local ret_get_supports_truecolor1172_v0__45_17="${ret_get_supports_truecolor1172_v0}"
        if [ "${ret_get_supports_truecolor1172_v0__45_17}" != 0 ]; then
            ret_colored_rgb1173_v0="\\x1b[38;2;${r_16362};${g_16363};${b_16364}m""${message_16361}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16365 == 0 ))" != 0 ]; then
            ret_colored_rgb1173_v0="${message_16361}"
            return 0
        else
            ret_colored_rgb1173_v0="\\x1b[${fallback_16365}m""${message_16361}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16365 == 0 ))" != 0 ]; then
            ret_colored_rgb1173_v0="${message_16361}"
            return 0
        fi
        ret_colored_rgb1173_v0="\\x1b[${fallback_16365}m""${message_16361}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1175_v0() {
    if [ "$(( ! _got_xylitol_colors_43 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16355="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16355}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16355}" ";"
            local parts_16356=("${ret_split4_v0[@]}")
            local __length_231=("${parts_16356[@]}")
            if [ "$(( ${#__length_231[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16356[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16356[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16356[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16356[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_44=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16357="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16357}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16357}" ";"
            local parts_16358=("${ret_split4_v0[@]}")
            local __length_233=("${parts_16358[@]}")
            if [ "$(( ${#__length_233[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16358[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16358[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16358[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16358[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_45=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16359="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16359}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16359}" ";"
            local parts_16360=("${ret_split4_v0[@]}")
            local __length_235=("${parts_16360[@]}")
            if [ "$(( ${#__length_235[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16360[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16360[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16360[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16360[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1175_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_43=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1176_v0() {
    inner_get_xylitol_colors__1175_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_43=1
}

# colored_primary(message: Text)
colored_primary__1177_v0() {
    local message_16354="${1}"
    if [ "$(( ! _got_xylitol_colors_43 ))" != 0 ]; then
        get_xylitol_colors__1176_v0 
    fi
    colored_rgb__1173_v0 "${message_16354}" "${_primary_color_44[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:48)"}" "${_primary_color_44[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:67)"}" "${_primary_color_44[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:86)"}" "${_primary_color_44[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1177_v0="${ret_colored_rgb1173_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1178_v0() {
    local message_16400="${1}"
    if [ "$(( ! _got_xylitol_colors_43 ))" != 0 ]; then
        get_xylitol_colors__1176_v0 
    fi
    colored_rgb__1173_v0 "${message_16400}" "${_secondary_color_45[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_45[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_45[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_45[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1178_v0="${ret_colored_rgb1173_v0}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1196_v0() {
    local format_16509="${1}"
    local args_16510=("${!2}")
    args_16510=("${format_16509}" "${args_16510[@]}")
    __status=$?
    printf "${args_16510[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1197_v0() {
    local message_16507="${1}"
    local color_16508="${2}"
    # Prints an error message with a specified color.
    local array_237=("${message_16507}")
    eprintf__1196_v0 "\\x1b[${color_16508}m%s\\x1b[0m" array_237[@]
}

# colored(message: Text, color: Int)
colored__1198_v0() {
    local message_16511="${1}"
    local color_16512="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1198_v0="\\x1b[${color_16512}m""${message_16511}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1202_v0() {
    local items_16501=("${!1}")
    local total_len_16502="${2}"
    local term_width_16503="${3}"
    local separator_16504=" • "
    local separator_len_16505=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16502 <= term_width_16503 ))" != 0 ]; then
        local iter_16506=0
        while :
        do
            local __length_238=("${items_16501[@]}")
            if [ "$(( iter_16506 >= ${#__length_238[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16506 > 0 ))" != 0 ]; then
                eprintf_colored__1197_v0 "${separator_16504}" 90
            fi
            colored__1198_v0 "${items_16501[$(( iter_16506 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1198_v0__23_41="${ret_colored1198_v0}"
            local array_239=("")
            eprintf__1196_v0 "${items_16501[${iter_16506}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1198_v0__23_41}" array_239[@]
            iter_16506="$(( iter_16506 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16513=0
        local first_16514=1
        local iter_16515=0
        while :
        do
            local __length_240=("${items_16501[@]}")
            if [ "$(( iter_16515 >= ${#__length_240[@]} ))" != 0 ]; then
                break
            fi
            local key_16516="${items_16501[${iter_16515}]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_16517="${items_16501[$(( iter_16515 + 1 ))]?"Index out of bounds (at src/./choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_241="${key_16516}"
            local __length_242="${action_16517}"
            local part_len_16518="$(( $(( ${#__length_241} + 1 )) + ${#__length_242} ))"
            local needed_16519="${part_len_16518}"
            if [ "$(( ! first_16514 ))" != 0 ]; then
                needed_16519="$(( needed_16519 + separator_len_16505 ))"
            fi
            if [ "$(( $(( current_len_16513 + needed_16519 )) > term_width_16503 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16514 ))" != 0 ]; then
                eprintf_colored__1197_v0 "${separator_16504}" 90
            fi
            colored__1198_v0 "${action_16517}" 2
            local ret_colored1198_v0__51_33="${ret_colored1198_v0}"
            local array_243=("")
            eprintf__1196_v0 "${key_16516}"" ""${ret_colored1198_v0__51_33}" array_243[@]
            current_len_16513="$(( current_len_16513 + needed_16519 ))"
            first_16514=0
            iter_16515="$(( iter_16515 + 2 ))"
        done
    fi
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
__CHOOSER_CONTINUE_49=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_50=1
# The user confirmed the selection.
__CHOOSER_DONE_51=2
_total_52=0
_page_size_53=10
_display_count_54=0
_total_pages_55=1
_current_page_56=0
_selected_57=0
_cursor_58="> "
_multi_59=0
_limit_60=-1
_term_width_61=80
_has_header_62=0
_page_63=()
_page_count_64=0
_checked_65=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_66=0
_first_render_67=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_68=0
# render_single_page()
render_single_page__1351_v0() {
    local __length_246="${_cursor_58}"
    local cursor_len_16539="${#__length_246}"
    local max_option_width_16540="$(( $(( _term_width_61 - cursor_len_16539 )) - 1 ))"
    local __range_start_16541=0
    local __range_end_16541="${_page_count_64}"
    local __dir_16541=$(( ${__range_start_16541} <= ${__range_end_16541} ? 1 : -1 ))
    for (( i_16541=${__range_start_16541}; i_16541 * ${__dir_16541} < ${__range_end_16541} * ${__dir_16541}; i_16541+=${__dir_16541} )); do
        cutoff_text__1081_v0 "${_page_63[${i_16541}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_16540}"
        local ret_cutoff_text1081_v0__48_27="${ret_cutoff_text1081_v0}"
        local truncated_16542="${ret_cutoff_text1081_v0__48_27}"
        if [ "$(( i_16541 == _selected_57 ))" != 0 ]; then
            colored_secondary__1178_v0 "${_cursor_58}""${truncated_16542}""
"
            local ret_colored_secondary1178_v0__50_21="${ret_colored_secondary1178_v0}"
            local array_247=("")
            eprintf__1028_v0 "${ret_colored_secondary1178_v0__50_21}" array_247[@]
        else
            print_blank__1048_v0 "${cursor_len_16539}"
            local array_248=("")
            eprintf__1028_v0 "${truncated_16542}""
" array_248[@]
        fi
done
    local remaining_slots_16543="$(( _display_count_54 - _page_count_64 ))"
    if [ "$(( remaining_slots_16543 > 0 ))" != 0 ]; then
        local __range_start_16544=0
        local __range_end_16544="${remaining_slots_16543}"
        local __dir_16544=$(( ${__range_start_16544} <= ${__range_end_16544} ? 1 : -1 ))
        for (( ____16544=${__range_start_16544}; ____16544 * ${__dir_16544} < ${__range_end_16544} * ${__dir_16544}; ____16544+=${__dir_16544} )); do
            local array_249=("")
            eprintf__1028_v0 "\\x1b[K
" array_249[@]
done
    fi
}

# render_multi_page()
render_multi_page__1352_v0() {
    local __length_250="${_cursor_58}"
    local cursor_len_16529="${#__length_250}"
    local max_option_width_16530="$(( $(( _term_width_61 - cursor_len_16529 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1357_v0 
    local page_start_16531="${ret_chooser_page_start1357_v0}"
    local __range_start_16532=0
    local __range_end_16532="${_page_count_64}"
    local __dir_16532=$(( ${__range_start_16532} <= ${__range_end_16532} ? 1 : -1 ))
    for (( i_16532=${__range_start_16532}; i_16532 * ${__dir_16532} < ${__range_end_16532} * ${__dir_16532}; i_16532+=${__dir_16532} )); do
        local global_idx_16533="$(( page_start_16531 + i_16532 ))"
        local check_mark_16534
        check_mark_16534="$(if [ "${_checked_65[${global_idx_16533}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1081_v0 "${_page_63[${i_16532}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_16530}"
        local ret_cutoff_text1081_v0__71_27="${ret_cutoff_text1081_v0}"
        local truncated_16535="${ret_cutoff_text1081_v0__71_27}"
        if [ "$(( i_16532 == _selected_57 ))" != 0 ]; then
            colored_secondary__1178_v0 "${_cursor_58}""${check_mark_16534}""${truncated_16535}""
"
            local ret_colored_secondary1178_v0__73_37="${ret_colored_secondary1178_v0}"
            local array_251=("")
            eprintf__1028_v0 "${ret_colored_secondary1178_v0__73_37}" array_251[@]
        elif [ "${_checked_65[${global_idx_16533}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1048_v0 "${cursor_len_16529}"
            colored_secondary__1178_v0 "${check_mark_16534}""${truncated_16535}""
"
            local ret_colored_secondary1178_v0__76_25="${ret_colored_secondary1178_v0}"
            local array_252=("")
            eprintf__1028_v0 "${ret_colored_secondary1178_v0__76_25}" array_252[@]
        else
            print_blank__1048_v0 "${cursor_len_16529}"
            local array_253=("")
            eprintf__1028_v0 "${check_mark_16534}""${truncated_16535}""
" array_253[@]
        fi
done
    local remaining_slots_16537="$(( _display_count_54 - _page_count_64 ))"
    if [ "$(( remaining_slots_16537 > 0 ))" != 0 ]; then
        local __range_start_16538=0
        local __range_end_16538="${remaining_slots_16537}"
        local __dir_16538=$(( ${__range_start_16538} <= ${__range_end_16538} ? 1 : -1 ))
        for (( ____16538=${__range_start_16538}; ____16538 * ${__dir_16538} < ${__range_end_16538} * ${__dir_16538}; ____16538+=${__dir_16538} )); do
            local array_254=("")
            eprintf__1028_v0 "\\x1b[K
" array_254[@]
done
    fi
}

# render_page()
render_page__1353_v0() {
    if [ "${_multi_59}" != 0 ]; then
        render_multi_page__1352_v0 
    else
        render_single_page__1351_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1354_v0() {
    if [ "$(( _total_pages_55 > 1 ))" != 0 ]; then
        local array_255=("")
        eprintf__1028_v0 "\\x1b[G\\x1b[K" array_255[@]
        eprintf_colored__1029_v0 "Page $(( _current_page_56 + 1 ))/${_total_pages_55}" 90
        local array_256=("")
        eprintf__1028_v0 "\\x1b[G" array_256[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1355_v0() {
    if [ "$(( ! _multi_59 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_55 > 1 ))" != 0 ]; then
            local array_257=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1202_v0 array_257[@] 36 "${_term_width_61}"
        else
            local array_258=("↑↓" "select" "enter" "confirm")
            render_tooltip__1202_v0 array_258[@] 25 "${_term_width_61}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_55 > 1 )) && $(( _limit_60 < 0 )) ))" != 0 ]; then
            local array_259=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1202_v0 array_259[@] 55 "${_term_width_61}"
        elif [ "$(( _total_pages_55 > 1 ))" != 0 ]; then
            local array_260=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1202_v0 array_260[@] 47 "${_term_width_61}"
        elif [ "$(( _limit_60 < 0 ))" != 0 ]; then
            local array_261=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1202_v0 array_261[@] 44 "${_term_width_61}"
        else
            local array_262=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1202_v0 array_262[@] 36 "${_term_width_61}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1356_v0() {
    local total_16450="${1}"
    local page_size_16451="${2}"
    local header_16452="${3}"
    local cursor_16453="${4}"
    local multi_16454="${5}"
    local limit_16455="${6}"
    _total_52="${total_16450}"
    _cursor_58="${cursor_16453}"
    _multi_59="${multi_16454}"
    _limit_60="${limit_16455}"
    _current_page_56=0
    _selected_57=0
    _first_render_67=1
    _up_paged_68=0
    _checked_count_66=0
    _has_header_62="$([ "_${header_16452}" == "_" ]; echo $?)"
    stty_lock__1154_v0 
    hide_cursor__1053_v0 
    term_width__1161_v0 
    _term_width_61="${ret_term_width1161_v0}"
    term_height__1162_v0 
    local term_height_16465="${ret_term_height1162_v0}"
    local max_page_size_16466
    max_page_size_16466="$(( term_height_16465 - $(if [ "${_has_header_62}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_53="${page_size_16451}"
    if [ "$(( _page_size_53 > max_page_size_16466 ))" != 0 ]; then
        _page_size_53="${max_page_size_16466}"
    fi
    if [ "${_has_header_62}" != 0 ]; then
        cutoff_text__1081_v0 "${header_16452}" "${_term_width_61}"
        local ret_cutoff_text1081_v0__157_17="${ret_cutoff_text1081_v0}"
        local array_263=("")
        eprintf__1028_v0 "${ret_cutoff_text1081_v0__157_17}""
" array_263[@]
    fi
    math_floor__561_v0 "$(( $(( $(( total_16450 + _page_size_53 )) - 1 )) / _page_size_53 ))"
    _total_pages_55="${ret_math_floor561_v0}"
    _display_count_54="${_page_size_53}"
    if [ "$(( total_16450 < _page_size_53 ))" != 0 ]; then
        _display_count_54="${total_16450}"
    fi
    if [ "${multi_16454}" != 0 ]; then
        _checked_65=()
        local __range_start_16498=0
        local __range_end_16498="${total_16450}"
        local __dir_16498=$(( ${__range_start_16498} <= ${__range_end_16498} ? 1 : -1 ))
        for (( ____16498=${__range_start_16498}; ____16498 * ${__dir_16498} < ${__range_end_16498} * ${__dir_16498}; ____16498+=${__dir_16498} )); do
            local array_265=(0)
            _checked_65+=("${array_265[@]}")
done
    fi
    new_line__1049_v0 "${_display_count_54}"
    local array_266=("")
    eprintf__1028_v0 "\\x1b[G" array_266[@]
    if [ "$(( _total_pages_55 > 1 ))" != 0 ]; then
        eprintf_colored__1029_v0 "Page $(( _current_page_56 + 1 ))/${_total_pages_55}" 90
    fi
    new_line__1049_v0 1
    render_tooltip_line__1355_v0 
    go_up__1050_v0 "$(( _display_count_54 + 1 ))"
    local array_267=("")
    eprintf__1028_v0 "\\x1b[G" array_267[@]
}

# chooser_page_start()
chooser_page_start__1357_v0() {
    ret_chooser_page_start1357_v0="$(( _current_page_56 * _page_size_53 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1358_v0() {
    chooser_page_start__1357_v0 
    local start_16524="${ret_chooser_page_start1357_v0}"
    local end_16525="$(( start_16524 + _page_size_53 ))"
    if [ "$(( end_16525 > _total_52 ))" != 0 ]; then
        end_16525="${_total_52}"
    fi
    ret_chooser_page_count1358_v0="$(( end_16525 - start_16524 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1359_v0() {
    local page_16528=("${!1}")
    _page_63=("${page_16528[@]}")
    local __length_268=("${page_16528[@]}")
    _page_count_64="${#__length_268[@]}"
    if [ "${_first_render_67}" != 0 ]; then
        _first_render_67=0
        render_page__1353_v0 
    else
        if [ "${_up_paged_68}" != 0 ]; then
            _selected_57="$(( _page_count_64 - 1 ))"
            _up_paged_68=0
        fi
        go_up__1050_v0 1
        remove_line__1046_v0 "$(( _display_count_54 - 1 ))"
        remove_current_line__1047_v0 
        local array_269=("")
        eprintf__1028_v0 "\\x1b[G" array_269[@]
        render_page__1353_v0 
        render_page_indicator__1354_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1360_v0() {
    local prev_selected_16560="${1}"
    chooser_page_start__1357_v0 
    local page_start_16561="${ret_chooser_page_start1357_v0}"
    local check_width_16562
    check_width_16562="$(if [ "${_multi_59}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_270="${_cursor_58}"
    local max_option_width_16563="$(( $(( _term_width_61 - ${#__length_270} )) - check_width_16562 ))"
    go_up__1050_v0 "$(( _display_count_54 - prev_selected_16560 ))"
    local array_271=("")
    eprintf__1028_v0 "\\x1b[K" array_271[@]
    local __length_272="${_cursor_58}"
    print_blank__1048_v0 "${#__length_272}"
    if [ "${_multi_59}" != 0 ]; then
        local was_checked_16564="${_checked_65[$(( page_start_16561 + prev_selected_16560 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1081_v0 "${_page_63[${prev_selected_16560}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_16563}"
        local ret_cutoff_text1081_v0__232_63="${ret_cutoff_text1081_v0}"
        local prev_line_16565
        prev_line_16565="$(if [ "${was_checked_16564}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1081_v0__232_63}"
        if [ "${was_checked_16564}" != 0 ]; then
            colored_secondary__1178_v0 "${prev_line_16565}"
            local ret_colored_secondary1178_v0__234_21="${ret_colored_secondary1178_v0}"
            local array_273=("")
            eprintf__1028_v0 "${ret_colored_secondary1178_v0__234_21}" array_273[@]
        else
            local array_274=("")
            eprintf__1028_v0 "${prev_line_16565}" array_274[@]
        fi
    else
        cutoff_text__1081_v0 "${_page_63[${prev_selected_16560}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_16563}"
        local ret_cutoff_text1081_v0__239_17="${ret_cutoff_text1081_v0}"
        local array_275=("")
        eprintf__1028_v0 "${ret_cutoff_text1081_v0__239_17}" array_275[@]
    fi
    go_up_or_down__1052_v0 "$(( _selected_57 - prev_selected_16560 ))"
    local array_276=("")
    eprintf__1028_v0 "\\x1b[G" array_276[@]
    local array_277=("")
    eprintf__1028_v0 "\\x1b[K" array_277[@]
    local mark_16567
    mark_16567="$(if [ "${_multi_59}" != 0 ]; then echo "$(if [ "${_checked_65[$(( page_start_16561 + _selected_57 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1081_v0 "${_page_63[${_selected_57}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_16563}"
    local ret_cutoff_text1081_v0__246_48="${ret_cutoff_text1081_v0}"
    colored_secondary__1178_v0 "${_cursor_58}""${mark_16567}""${ret_cutoff_text1081_v0__246_48}"
    local ret_colored_secondary1178_v0__246_13="${ret_colored_secondary1178_v0}"
    local array_278=("")
    eprintf__1028_v0 "${ret_colored_secondary1178_v0__246_13}" array_278[@]
    go_down__1051_v0 "$(( _display_count_54 - _selected_57 ))"
    local array_279=("")
    eprintf__1028_v0 "\\x1b[G" array_279[@]
}

# redraw_current_line()
redraw_current_line__1361_v0() {
    chooser_page_start__1357_v0 
    local page_start_16554="${ret_chooser_page_start1357_v0}"
    local __length_280="${_cursor_58}"
    local max_option_width_16555="$(( $(( _term_width_61 - ${#__length_280} )) - 3 ))"
    go_up__1050_v0 "$(( _display_count_54 - _selected_57 ))"
    local array_281=("")
    eprintf__1028_v0 "\\x1b[G" array_281[@]
    local array_282=("")
    eprintf__1028_v0 "\\x1b[K" array_282[@]
    local check_mark_16556
    check_mark_16556="$(if [ "${_checked_65[$(( page_start_16554 + _selected_57 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1081_v0 "${_page_63[${_selected_57}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_16555}"
    local ret_cutoff_text1081_v0__260_54="${ret_cutoff_text1081_v0}"
    colored_secondary__1178_v0 "${_cursor_58}""${check_mark_16556}""${ret_cutoff_text1081_v0__260_54}"
    local ret_colored_secondary1178_v0__260_13="${ret_colored_secondary1178_v0}"
    local array_283=("")
    eprintf__1028_v0 "${ret_colored_secondary1178_v0__260_13}" array_283[@]
    go_down__1051_v0 "$(( _display_count_54 - _selected_57 ))"
    local array_284=("")
    eprintf__1028_v0 "\\x1b[G" array_284[@]
}

# chooser_step()
chooser_step__1362_v0() {
    get_key__1026_v0 
    local key_16549="${ret_get_key1026_v0}"
    local prev_selected_16550="${_selected_57}"
    local prev_page_16551="${_current_page_56}"
    chooser_page_start__1357_v0 
    local page_start_16552="${ret_chooser_page_start1357_v0}"
    _up_paged_68=0
    if [ "$(( $([ "_${key_16549}" != "_UP" ]; echo $?) || $([ "_${key_16549}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_57 == 0 )) && $(( _total_pages_55 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_56 > 0 ))" != 0 ]; then
                _current_page_56="$(( _current_page_56 - 1 ))"
            else
                _current_page_56="$(( _total_pages_55 - 1 ))"
            fi
            _up_paged_68=1
        elif [ "$(( _selected_57 == 0 ))" != 0 ]; then
            _selected_57="$(( _page_count_64 - 1 ))"
        else
            _selected_57="$(( _selected_57 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_16549}" != "_DOWN" ]; echo $?) || $([ "_${key_16549}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_57 == $(( _page_count_64 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_56 < $(( _total_pages_55 - 1 )) ))" != 0 ]; then
                _current_page_56="$(( _current_page_56 + 1 ))"
            else
                _current_page_56=0
            fi
            _selected_57=0
        else
            _selected_57="$(( _selected_57 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_16549}" != "_LEFT" ]; echo $?) || $([ "_${key_16549}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_56 > 0 ))" != 0 ]; then
            _current_page_56="$(( _current_page_56 - 1 ))"
        fi
        _selected_57=0
    elif [ "$(( $([ "_${key_16549}" != "_RIGHT" ]; echo $?) || $([ "_${key_16549}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_56 < $(( _total_pages_55 - 1 )) ))" != 0 ]; then
            _current_page_56="$(( _current_page_56 + 1 ))"
            _selected_57=0
        else
            _selected_57="$(( _page_count_64 - 1 ))"
        fi
    elif [ "$(( _multi_59 && $(( $([ "_${key_16549}" != "_x" ]; echo $?) || $([ "_${key_16549}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_16553="$(( page_start_16552 + _selected_57 ))"
        if [ "${_checked_65[${global_selected_16553}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_65["${global_selected_16553}"]=0
            _checked_count_66="$(( _checked_count_66 - 1 ))"
        elif [ "$(( $(( _limit_60 < 0 )) || $(( _checked_count_66 < _limit_60 )) ))" != 0 ]; then
            _checked_65["${global_selected_16553}"]=1
            _checked_count_66="$(( _checked_count_66 + 1 ))"
        else
            ret_chooser_step1362_v0="${__CHOOSER_CONTINUE_49}"
            return 0
        fi
        redraw_current_line__1361_v0 
        ret_chooser_step1362_v0="${__CHOOSER_CONTINUE_49}"
        return 0
    elif [ "$(( $(( _multi_59 && $(( $([ "_${key_16549}" != "_a" ]; echo $?) || $([ "_${key_16549}" != "_A" ]; echo $?) )) )) && $(( _limit_60 < 0 )) ))" != 0 ]; then
        local all_checked_16558="$(( _checked_count_66 == _total_52 ))"
        local __range_start_16559=0
        local __range_end_16559="${_total_52}"
        local __dir_16559=$(( ${__range_start_16559} <= ${__range_end_16559} ? 1 : -1 ))
        for (( i_16559=${__range_start_16559}; i_16559 * ${__dir_16559} < ${__range_end_16559} * ${__dir_16559}; i_16559+=${__dir_16559} )); do
            _checked_65["${i_16559}"]="$(( ! all_checked_16558 ))"
done
        _checked_count_66="$(if [ "${all_checked_16558}" != 0 ]; then echo 0; else echo "${_total_52}"; fi)"
        go_up__1050_v0 "${_display_count_54}"
        local array_285=("")
        eprintf__1028_v0 "\\x1b[G" array_285[@]
        render_page__1353_v0 
        ret_chooser_step1362_v0="${__CHOOSER_CONTINUE_49}"
        return 0
    elif [ "$([ "_${key_16549}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1362_v0="${__CHOOSER_DONE_51}"
        return 0
    else
        ret_chooser_step1362_v0="${__CHOOSER_CONTINUE_49}"
        return 0
    fi
    if [ "$(( prev_page_16551 != _current_page_56 ))" != 0 ]; then
        ret_chooser_step1362_v0="${__CHOOSER_NEED_PAGE_50}"
        return 0
    fi
    if [ "$(( prev_selected_16550 != _selected_57 ))" != 0 ]; then
        redraw_selection__1360_v0 "${prev_selected_16550}"
    fi
    ret_chooser_step1362_v0="${__CHOOSER_CONTINUE_49}"
    return 0
}

# chooser_selected()
chooser_selected__1363_v0() {
    chooser_page_start__1357_v0 
    local ret_chooser_page_start1357_v0__362_12="${ret_chooser_page_start1357_v0}"
    ret_chooser_selected1363_v0="$(( ret_chooser_page_start1357_v0__362_12 + _selected_57 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1364_v0() {
    local index_16573="${1}"
    ret_chooser_is_checked1364_v0="${_checked_65[${index_16573}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1365_v0() {
    local total_lines_16569="$(( _display_count_54 + 2 ))"
    if [ "${_has_header_62}" != 0 ]; then
        total_lines_16569="$(( total_lines_16569 + 1 ))"
    fi
    go_down__1051_v0 1
    remove_line__1046_v0 "$(( total_lines_16569 - 1 ))"
    remove_current_line__1047_v0 
    stty_unlock__1155_v0 
    show_cursor__1054_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1374_v0() {
    local options_16577=("${!1}")
    local cursor_16578="${2}"
    local header_16579="${3}"
    local page_size_16580="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_286=("${options_16577[@]}")
    local total_16581="${#__length_286[@]}"
    if [ "$(( total_16581 == 0 ))" != 0 ]; then
        eprintf_colored__1029_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1356_v0 "${total_16581}" "${page_size_16580}" "${header_16579}" "${cursor_16578}" 0 -1
    local need_page_16582=1
    while :
    do
        if [ "${need_page_16582}" != 0 ]; then
            local page_16583=()
            chooser_page_start__1357_v0 
            local start_16584="${ret_chooser_page_start1357_v0}"
            chooser_page_count__1358_v0 
            local count_16585="${ret_chooser_page_count1358_v0}"
            local __range_start_16586="${start_16584}"
            local __range_end_16586="$(( start_16584 + count_16585 ))"
            local __dir_16586=$(( ${__range_start_16586} <= ${__range_end_16586} ? 1 : -1 ))
            for (( i_16586=${__range_start_16586}; i_16586 * ${__dir_16586} < ${__range_end_16586} * ${__dir_16586}; i_16586+=${__dir_16586} )); do
                local array_288=("${options_16577[${i_16586}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_16583+=("${array_288[@]}")
done
            chooser_set_page__1359_v0 page_16583[@]
        fi
        chooser_step__1362_v0 
        local step_16587="${ret_chooser_step1362_v0}"
        if [ "$(( step_16587 == __CHOOSER_DONE_51 ))" != 0 ]; then
            break
        fi
        need_page_16582="$(( step_16587 == __CHOOSER_NEED_PAGE_50 ))"
    done
    chooser_selected__1363_v0 
    local selected_16588="${ret_chooser_selected1363_v0}"
    chooser_end__1365_v0 
    ret_xyl_choose1374_v0="${options_16577[${selected_16588}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1375_v0() {
    local options_16444=("${!1}")
    local cursor_16445="${2}"
    local header_16446="${3}"
    local limit_16447="${4}"
    local page_size_16448="${5}"
    local __length_289=("${options_16444[@]}")
    local total_16449="${#__length_289[@]}"
    if [ "$(( total_16449 == 0 ))" != 0 ]; then
        eprintf_colored__1029_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1375_v0=()
        return 0
    fi
    chooser_begin__1356_v0 "${total_16449}" "${page_size_16448}" "${header_16446}" "${cursor_16445}" 1 "${limit_16447}"
    local need_page_16521=1
    while :
    do
        if [ "${need_page_16521}" != 0 ]; then
            local page_16522=()
            chooser_page_start__1357_v0 
            local start_16523="${ret_chooser_page_start1357_v0}"
            chooser_page_count__1358_v0 
            local count_16526="${ret_chooser_page_count1358_v0}"
            local __range_start_16527="${start_16523}"
            local __range_end_16527="$(( start_16523 + count_16526 ))"
            local __dir_16527=$(( ${__range_start_16527} <= ${__range_end_16527} ? 1 : -1 ))
            for (( i_16527=${__range_start_16527}; i_16527 * ${__dir_16527} < ${__range_end_16527} * ${__dir_16527}; i_16527+=${__dir_16527} )); do
                local array_292=("${options_16444[${i_16527}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_16522+=("${array_292[@]}")
done
            chooser_set_page__1359_v0 page_16522[@]
        fi
        chooser_step__1362_v0 
        local step_16568="${ret_chooser_step1362_v0}"
        if [ "$(( step_16568 == __CHOOSER_DONE_51 ))" != 0 ]; then
            break
        fi
        need_page_16521="$(( step_16568 == __CHOOSER_NEED_PAGE_50 ))"
    done
    chooser_end__1365_v0 
    local result_16571=()
    local __range_start_16572=0
    local __range_end_16572="${total_16449}"
    local __dir_16572=$(( ${__range_start_16572} <= ${__range_end_16572} ? 1 : -1 ))
    for (( i_16572=${__range_start_16572}; i_16572 * ${__dir_16572} < ${__range_end_16572} * ${__dir_16572}; i_16572+=${__dir_16572} )); do
        chooser_is_checked__1364_v0 "${i_16572}"
        local ret_chooser_is_checked1364_v0__93_12="${ret_chooser_is_checked1364_v0}"
        if [ "${ret_chooser_is_checked1364_v0__93_12}" != 0 ]; then
            local array_294=("${options_16444[${i_16572}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_16571+=("${array_294[@]}")
        fi
done
    ret_xyl_multi_choose1375_v0=("${result_16571[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1470_v0() {
    local usage_16375=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1124_v0 usage_16375[@]
    printf '%s\n' ""
    colored_primary__1177_v0 "choose"
    local ret_colored_primary1177_v0__8_20="${ret_colored_primary1177_v0}"
    local title_16399=("${ret_colored_primary1177_v0__8_20}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1124_v0 title_16399[@]
    printf '%s\n' ""
    colored_secondary__1178_v0 "Arguments:"
    local ret_colored_secondary1178_v0__11_12="${ret_colored_secondary1178_v0}"
    local array_297=()
    printf__128_v0 "${ret_colored_secondary1178_v0__11_12}""
" array_297[@]
    local arg_names_16401=("[<options> ...]")
    local arg_texts_16402=("List of options to choose from")
    local arg_notes_16403=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1123_v0 arg_names_16401[@] arg_texts_16402[@] arg_notes_16403[@] 20
    printf '%s\n' ""
    colored_secondary__1178_v0 "Flags:"
    local ret_colored_secondary1178_v0__18_12="${ret_colored_secondary1178_v0}"
    local array_301=()
    printf__128_v0 "${ret_colored_secondary1178_v0__18_12}""
" array_301[@]
    local names_16431=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_16432=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_16433=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1123_v0 names_16431[@] texts_16432[@] notes_16433[@] 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1522_v0() {
    local options_16368=()
    local command_306
    command_306="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_16369="${command_306}"
    if [ "$([ "_${is_tty_16369}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_16368+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1522_v0=("${options_16368[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1523_v0() {
    local parameters_16352=("${!1}")
    local cursor_16353="> "
    colored_primary__1177_v0 "Choose: "
    local ret_colored_primary1177_v0__17_30="${ret_colored_primary1177_v0}"
    local header_16367="\\x1b[1m""${ret_colored_primary1177_v0__17_30}"
    read_stdin_options__1522_v0 
    local options_16370=("${ret_read_stdin_options1522_v0[@]}")
    local multi_16371=0
    local limit_16372=-1
    local page_size_16373=10
    local __length_310=("${parameters_16352[@]}")
    local slice_upper_309="${#__length_310[@]}"
    local slice_offset_311=2
    local slice_offset_311=$((${slice_offset_311} > 0 ? ${slice_offset_311} : 0))
    local slice_length_312="$(( slice_upper_309 - slice_offset_311 ))"
    local slice_length_312=$((${slice_length_312} > 0 ? ${slice_length_312} : 0))
    for param_16374 in "${parameters_16352[@]:${slice_offset_311}:${slice_length_312}}"; do
        starts_with__22_v0 "${param_16374}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16374}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16374}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16374}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16374}" != "_-h" ]; echo $?) || $([ "_${param_16374}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1470_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_313="--cursor="
            slice__24_v0 "${param_16374}" "${#__length_313}" 0
            cursor_16353="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_314="--header="
            slice__24_v0 "${param_16374}" "${#__length_314}" 0
            header_16367="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_315="--limit="
            slice__24_v0 "${param_16374}" "${#__length_315}" 0
            local value_16434="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16434}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1029_v0 "ERROR: Invalid limit value: ""${value_16434}""
" 31
                exit 1
            fi
            limit_16372="${ret_parse_int13_v0}"
            multi_16371=1
        elif [ "$([ "_${param_16374}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_16371=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_316="--page-size="
            slice__24_v0 "${param_16374}" "${#__length_316}" 0
            local value_16439="${ret_slice24_v0}"
            parse_int__13_v0 "${value_16439}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1029_v0 "ERROR: Invalid page-size value: ""${value_16439}""
" 31
                exit 1
            fi
            page_size_16373="${ret_parse_int13_v0}"
        else
            options_16370+=("${param_16374}")
        fi
    done
    has_ansi_escape__1074_v0 "${header_16367}"
    local ret_has_ansi_escape1074_v0__59_44="${ret_has_ansi_escape1074_v0}"
    escape_ansi__1075_v0 "${header_16367}"
    local ret_escape_ansi1075_v0__59_73="${ret_escape_ansi1075_v0}"
    colored_primary__1177_v0 "${header_16367}"
    local ret_colored_primary1177_v0__59_111="${ret_colored_primary1177_v0}"
    local display_header_16443
    display_header_16443="$(if [ "$(( $([ "_${header_16367}" != "_" ]; echo $?) || ret_has_ansi_escape1074_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1075_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1177_v0__59_111}"; fi)"
    if [ "${multi_16371}" != 0 ]; then
        xyl_multi_choose__1375_v0 options_16370[@] "${cursor_16353}" "${display_header_16443}" "${limit_16372}" "${page_size_16373}"
        local results_16574=("${ret_xyl_multi_choose1375_v0[@]}")
        join__7_v0 results_16574[@] "
"
        ret_execute_choose1523_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1374_v0 options_16370[@] "${cursor_16353}" "${display_header_16443}" "${page_size_16373}"
    ret_execute_choose1523_v0="${ret_xyl_choose1374_v0}"
    return 0
}

# get_key()
get_key__1647_v0() {
    local command_318
    command_318="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_18608="${command_318}"
    if [ "$([ "_${var_18608}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1647_v0="UP"
        return 0
    elif [ "$([ "_${var_18608}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1647_v0="DOWN"
        return 0
    elif [ "$([ "_${var_18608}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1647_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_18608}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1647_v0="LEFT"
        return 0
    elif [ "$([ "_${var_18608}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1647_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_18608}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1647_v0="INPUT"
        return 0
    else
        ret_get_key1647_v0="${var_18608}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1649_v0() {
    local format_18512="${1}"
    local args_18513=("${!2}")
    args_18513=("${format_18512}" "${args_18513[@]}")
    __status=$?
    printf "${args_18513[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1650_v0() {
    local message_18510="${1}"
    local color_18511="${2}"
    # Prints an error message with a specified color.
    local array_319=("${message_18510}")
    eprintf__1649_v0 "\\x1b[${color_18511}m%s\\x1b[0m" array_319[@]
}

# eprintf(format: Text, args: [Text])
eprintf__1662_v0() {
    local format_18522="${1}"
    local args_18523=("${!2}")
    args_18523=("${format_18522}" "${args_18523[@]}")
    __status=$?
    printf "${args_18523[@]}" >&2
    __status=$?
}

# colored(message: Text, color: Int)
colored__1664_v0() {
    local message_18507="${1}"
    local color_18508="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1664_v0="\\x1b[${color_18508}m""${message_18507}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1667_v0() {
    local cnt_18612="${1}"
    if [ "$(( cnt_18612 > 0 ))" != 0 ]; then
        local sequence_18613=""
        local __range_start_18614=0
        local __range_end_18614="${cnt_18612}"
        local __dir_18614=$(( ${__range_start_18614} <= ${__range_end_18614} ? 1 : -1 ))
        for (( ____18614=${__range_start_18614}; ____18614 * ${__dir_18614} < ${__range_end_18614} * ${__dir_18614}; ____18614+=${__dir_18614} )); do
            sequence_18613+="\\x1b[2K\\x1b[1A"
done
        local array_320=("")
        eprintf__1662_v0 "${sequence_18613}" array_320[@]
    fi
    local array_321=("")
    eprintf__1662_v0 "\\x1b[G" array_321[@]
}

# remove_current_line()
remove_current_line__1668_v0() {
    local array_322=("")
    eprintf__1662_v0 "\\x1b[2K\\x1b[G" array_322[@]
}

# go_up(cnt: Int)
go_up__1671_v0() {
    local cnt_18607="${1}"
    local array_323=("")
    eprintf__1662_v0 "\\x1b[${cnt_18607}A" array_323[@]
}

# go_down(cnt: Int)
go_down__1672_v0() {
    local cnt_18611="${1}"
    local array_324=("")
    eprintf__1662_v0 "\\x1b[${cnt_18611}B" array_324[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1674_v0() {
    local array_325=("")
    eprintf__1662_v0 "\\x1b[?25l" array_325[@]
}

# show_cursor()
show_cursor__1675_v0() {
    local array_326=("")
    eprintf__1662_v0 "\\x1b[?25h" array_326[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_74="None"
# perl_available()
perl_available__1689_v0() {
    if [ "$([ "_${_perl_state_74}" != "_None" ]; echo $?)" != 0 ]; then
        local command_327
        command_327="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_18473
        disabled_18473="$([ "_${command_327}" != "_No" ]; echo $?)"
        local command_328
        command_328="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_18474
        found_18474="$(( $(( ! disabled_18473 )) && $([ "_${command_328}" != "_0" ]; echo $?) ))"
        _perl_state_74="$(if [ "${found_18474}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available1689_v0="$([ "_${_perl_state_74}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1690_v0() {
    local text_18472="${1}"
    perl_available__1689_v0 
    local ret_perl_available1689_v0__22_12="${ret_perl_available1689_v0}"
    if [ "$(( ! ret_perl_available1689_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width1690_v0=''
        return 1
    fi
    local command_329
    command_329="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_18472}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1690_v0=''
        return "${__status}"
    fi
    local width_str_18475="${command_329}"
    parse_int__13_v0 "${width_str_18475}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1690_v0=''
        return "${__status}"
    fi
    local width_18476="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1690_v0="${width_18476}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1691_v0() {
    local text_18543="${1}"
    local max_width_18544="${2}"
    perl_available__1689_v0 
    local ret_perl_available1689_v0__33_12="${ret_perl_available1689_v0}"
    if [ "$(( ! ret_perl_available1689_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk1691_v0=''
        return 1
    fi
    local command_330
    command_330="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_18543}" ${max_width_18544} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1691_v0=''
        return "${__status}"
    fi
    local result_18545="${command_330}"
    ret_perl_truncate_cjk1691_v0="${result_18545}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1695_v0() {
    local text_18514="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_331
    command_331="$([[ "${text_18514}" == *$'\x1b'* || "${text_18514}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18515="${command_331}"
    ret_has_ansi_escape1695_v0="$([ "_${has_escape_18515}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1696_v0() {
    local text_18516="${1}"
    local command_332
    command_332="$(printf '%s' "${text_18516}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1696_v0="${command_332}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1697_v0() {
    local text_18533="${1}"
    local command_333
    command_333="$(printf "%s" "${text_18533}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1697_v0="${command_333}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1698_v0() {
    local text_18535="${1}"
    local command_334
    command_334="$(printf "%s" "${text_18535}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18536="${command_334}"
    ret_is_all_ascii1698_v0="$([ "_${result_18536}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1699_v0() {
    local text_18532="${1}"
    strip_ansi__1697_v0 "${text_18532}"
    local stripped_18534="${ret_strip_ansi1697_v0}"
    # Check if text is all ASCII
    is_all_ascii__1698_v0 "${stripped_18534}"
    local ret_is_all_ascii1698_v0__36_12="${ret_is_all_ascii1698_v0}"
    if [ "$(( ! ret_is_all_ascii1698_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1690_v0 "${stripped_18534}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_335="${stripped_18534}"
            ret_get_visible_len1699_v0="${#__length_335}"
            return 0
        fi
        ret_get_visible_len1699_v0="${ret_perl_get_cjk_width1690_v0}"
        return 0
    else
        local __length_336="${stripped_18534}"
        ret_get_visible_len1699_v0="${#__length_336}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1700_v0() {
    local text_18540="${1}"
    local max_width_18541="${2}"
    get_visible_len__1699_v0 "${text_18540}"
    local visible_len_18542="${ret_get_visible_len1699_v0}"
    if [ "$(( visible_len_18542 <= max_width_18541 ))" != 0 ]; then
        ret_truncate_text1700_v0="${text_18540}"
        return 0
    fi
    is_all_ascii__1698_v0 "${text_18540}"
    local ret_is_all_ascii1698_v0__53_12="${ret_is_all_ascii1698_v0}"
    if [ "$(( ! ret_is_all_ascii1698_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__1691_v0 "${text_18540}" "${max_width_18541}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_18540}" | cut -c1-${max_width_18541}
            __status=$?
        fi
        ret_truncate_text1700_v0="${ret_perl_truncate_cjk1691_v0}"
        return 0
    fi
    local command_337
    command_337="$(printf "%s" "${text_18540}" | cut -c1-${max_width_18541})"
    __status=$?
    ret_truncate_text1700_v0="${command_337}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1701_v0() {
    local text_18538="${1}"
    local max_width_18539="${2}"
    has_ansi_escape__1695_v0 "${text_18538}"
    local ret_has_ansi_escape1695_v0__65_12="${ret_has_ansi_escape1695_v0}"
    if [ "$(( ! ret_has_ansi_escape1695_v0__65_12 ))" != 0 ]; then
        truncate_text__1700_v0 "${text_18538}" "${max_width_18539}"
        ret_truncate_ansi1701_v0="${ret_truncate_text1700_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_338
    command_338="$([[ "${text_18538}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_18546="${command_338}"
    # Replace \x1b[ with newline, then split
    local command_339
    command_339="$(t="${text_18538}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_18547="${command_339}"
    split__4_v0 "${replaced_18547}" "
"
    local parts_18548=("${ret_split4_v0[@]}")
    local result_18549=""
    local remaining_width_18550="${max_width_18539}"
    local __range_start_18551=0
    local __length_340=("${parts_18548[@]}")
    local __range_end_18551="${#__length_340[@]}"
    local __dir_18551=$(( ${__range_start_18551} <= ${__range_end_18551} ? 1 : -1 ))
    for (( idx_18551=${__range_start_18551}; idx_18551 * ${__dir_18551} < ${__range_end_18551} * ${__dir_18551}; idx_18551+=${__dir_18551} )); do
        local part_18552="${parts_18548[${idx_18551}]?"Index out of bounds (at src/./confirm/../utils/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_18551 == 0 )) && $([ "_${starts_with_ansi_18546}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_18552}" == "_" ]; echo $?) && $(( remaining_width_18550 > 0 )) ))" != 0 ]; then
                truncate_text__1700_v0 "${part_18552}" "${remaining_width_18550}"
                local ret_truncate_text1700_v0__87_35="${ret_truncate_text1700_v0}"
                local truncated_18553="${ret_truncate_text1700_v0__87_35}"
                result_18549+="${truncated_18553}"
                get_visible_len__1699_v0 "${truncated_18553}"
                local ret_get_visible_len1699_v0__89_36="${ret_get_visible_len1699_v0}"
                remaining_width_18550="$(( remaining_width_18550 - ret_get_visible_len1699_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_341
            command_341="$(__p="${part_18552}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_18554="${command_341}"
            if [ "$([ "_${m_idx_18554}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_342
                command_342="$(__p="${part_18552}"; printf "%s" "${__p:0:${m_idx_18554}}")"
                __status=$?
                local ansi_params_18555="${command_342}"
                result_18549+="\\x1b[""${ansi_params_18555}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_18554}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_18556="${ret_parse_int13_v0__100_41}"
                local text_start_18557="$(( m_idx_num_18556 + 1 ))"
                local command_343
                command_343="$(__p="${part_18552}"; printf "%s" "${__p:${text_start_18557}}")"
                __status=$?
                local text_part_18558="${command_343}"
                if [ "$(( $([ "_${text_part_18558}" == "_" ]; echo $?) && $(( remaining_width_18550 > 0 )) ))" != 0 ]; then
                    truncate_text__1700_v0 "${text_part_18558}" "${remaining_width_18550}"
                    local ret_truncate_text1700_v0__104_39="${ret_truncate_text1700_v0}"
                    local truncated_18559="${ret_truncate_text1700_v0__104_39}"
                    result_18549+="${truncated_18559}"
                    get_visible_len__1699_v0 "${truncated_18559}"
                    local ret_get_visible_len1699_v0__106_40="${ret_get_visible_len1699_v0}"
                    remaining_width_18550="$(( remaining_width_18550 - ret_get_visible_len1699_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_18552}" == "_" ]; echo $?) && $(( remaining_width_18550 > 0 )) ))" != 0 ]; then
                    truncate_text__1700_v0 "${part_18552}" "${remaining_width_18550}"
                    local ret_truncate_text1700_v0__111_39="${ret_truncate_text1700_v0}"
                    local truncated_18560="${ret_truncate_text1700_v0__111_39}"
                    result_18549+="${truncated_18560}"
                    get_visible_len__1699_v0 "${truncated_18560}"
                    local ret_get_visible_len1699_v0__113_40="${ret_get_visible_len1699_v0}"
                    remaining_width_18550="$(( remaining_width_18550 - ret_get_visible_len1699_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1701_v0="${result_18549}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1702_v0() {
    local text_18530="${1}"
    local max_width_18531="${2}"
    get_visible_len__1699_v0 "${text_18530}"
    local visible_len_18537="${ret_get_visible_len1699_v0}"
    if [ "$(( visible_len_18537 <= max_width_18531 ))" != 0 ]; then
        ret_cutoff_text1702_v0="${text_18530}"
        return 0
    fi
    truncate_ansi__1701_v0 "${text_18530}" "$(( max_width_18531 - 3 ))"
    local ret_truncate_ansi1701_v0__129_12="${ret_truncate_ansi1701_v0}"
    ret_cutoff_text1702_v0="${ret_truncate_ansi1701_v0__129_12}""..."
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__1720_v0() {
    local text_18465="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_344
    command_344="$([[ "${text_18465}" == *$'\x1b'* || "${text_18465}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_18466="${command_344}"
    ret_has_ansi_escape1720_v0="$([ "_${has_escape_18466}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1722_v0() {
    local text_18468="${1}"
    local command_345
    command_345="$(printf "%s" "${text_18468}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1722_v0="${command_345}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1723_v0() {
    local text_18470="${1}"
    local command_346
    command_346="$(printf "%s" "${text_18470}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_18471="${command_346}"
    ret_is_all_ascii1723_v0="$([ "_${result_18471}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1724_v0() {
    local text_18467="${1}"
    strip_ansi__1722_v0 "${text_18467}"
    local stripped_18469="${ret_strip_ansi1722_v0}"
    # Check if text is all ASCII
    is_all_ascii__1723_v0 "${stripped_18469}"
    local ret_is_all_ascii1723_v0__36_12="${ret_is_all_ascii1723_v0}"
    if [ "$(( ! ret_is_all_ascii1723_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1690_v0 "${stripped_18469}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_347="${stripped_18469}"
            ret_get_visible_len1724_v0="${#__length_347}"
            return 0
        fi
        ret_get_visible_len1724_v0="${ret_perl_get_cjk_width1690_v0}"
        return 0
    else
        local __length_348="${stripped_18469}"
        ret_get_visible_len1724_v0="${#__length_348}"
        return 0
    fi
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_75=0
_term_size_76=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__1735_v0() {
    local size_18456="${1}"
    if [ "$([ "_${size_18456}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1735_v0=0
        return 0
    fi
    split__4_v0 "${size_18456}" " "
    local parts_18457=("${ret_split4_v0[@]}")
    local __length_350=("${parts_18457[@]}")
    if [ "$(( ${#__length_350[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1735_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18457[1]?"Index out of bounds (at src/./confirm/../utils/./term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18457[0]?"Index out of bounds (at src/./confirm/../utils/./term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_76=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1735_v0=1
    return 0
}

# query_term_size()
query_term_size__1736_v0() {
    local command_352
    command_352="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18459="${command_352}"
    store_term_size__1735_v0 "${size_18459}"
    ret_query_term_size1736_v0="${ret_store_term_size1735_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1737_v0() {
    local command_353
    command_353="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18455="${command_353}"
    store_term_size__1735_v0 "${size_18455}"
    ret_stty_term_size1737_v0="${ret_store_term_size1735_v0}"
    return 0
}

# get_term_size()
get_term_size__1738_v0() {
    stty_term_size__1737_v0 
    local detected_18458="${ret_stty_term_size1737_v0}"
    if [ "$(( ! detected_18458 ))" != 0 ]; then
        query_term_size__1736_v0 
        detected_18458="${ret_query_term_size1736_v0}"
    fi
    _got_term_size_75=1
}

# term_width()
term_width__1740_v0() {
    if [ "$(( ! _got_term_size_75 ))" != 0 ]; then
        get_term_size__1738_v0 
    fi
    ret_term_width1740_v0="${_term_size_76[0]?"Index out of bounds (at src/./confirm/../utils/./term.ab:93:23)"}"
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1743_v0() {
    local pending_18504="${1}"
    local line_18505="${2}"
    local note_at_18506="${3}"
    if [ "$(( note_at_18506 < 0 ))" != 0 ]; then
        local array_354=()
        printf__128_v0 "${pending_18504}""${line_18505}""
" array_354[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_18506 == 0 ))" != 0 ]; then
        colored__1664_v0 "${line_18505}" 90
        local ret_colored1664_v0__13_40="${ret_colored1664_v0}"
        local array_355=()
        printf__128_v0 "${pending_18504}""${ret_colored1664_v0__13_40}""
" array_355[@]
    else
        slice__24_v0 "${line_18505}" 0 "${note_at_18506}"
        local ret_slice24_v0__14_32="${ret_slice24_v0}"
        slice__24_v0 "${line_18505}" "${note_at_18506}" 0
        local ret_slice24_v0__14_66="${ret_slice24_v0}"
        colored__1664_v0 "${ret_slice24_v0__14_66}" 90
        local ret_colored1664_v0__14_58="${ret_colored1664_v0}"
        local array_356=()
        printf__128_v0 "${pending_18504}""${ret_slice24_v0__14_32}""${ret_colored1664_v0__14_58}""
" array_356[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1744_v0() {
    local names_18482=("${!1}")
    local texts_18483=("${!2}")
    local notes_18484=("${!3}")
    local min_name_width_18485="${4}"
    local __length_357=("${names_18482[@]}")
    local count_18486="${#__length_357[@]}"
    local name_width_18487="${min_name_width_18485}"
    local __range_start_18488=0
    local __range_end_18488="${count_18486}"
    local __dir_18488=$(( ${__range_start_18488} <= ${__range_end_18488} ? 1 : -1 ))
    for (( i_18488=${__range_start_18488}; i_18488 * ${__dir_18488} < ${__range_end_18488} * ${__dir_18488}; i_18488+=${__dir_18488} )); do
        local __length_358="${names_18482[${i_18488}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:29:33)"}"
        local width_18489="${#__length_358}"
        if [ "$(( width_18489 > name_width_18487 ))" != 0 ]; then
            name_width_18487="${width_18489}"
        fi
done
    term_width__1740_v0 
    local width_18490="${ret_term_width1740_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_18491="$(( name_width_18487 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_18492="$(( $(( width_18490 - indent_18491 )) < 24 ))"
    if [ "${stacked_18492}" != 0 ]; then
        indent_18491=6
    fi
    local avail_18493="$(( width_18490 - indent_18491 ))"
    rpad__28_v0 "" " " "${indent_18491}"
    local blank_18494="${ret_rpad28_v0}"
    local __range_start_18495=0
    local __range_end_18495="${count_18486}"
    local __dir_18495=$(( ${__range_start_18495} <= ${__range_end_18495} ? 1 : -1 ))
    for (( i_18495=${__range_start_18495}; i_18495 * ${__dir_18495} < ${__range_end_18495} * ${__dir_18495}; i_18495+=${__dir_18495} )); do
        local pending_18496="${blank_18494}"
        if [ "${stacked_18492}" != 0 ]; then
            local array_359=()
            printf__128_v0 "  ""${names_18482[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:49:33)"}""
" array_359[@]
        else
            rpad__28_v0 "  ""${names_18482[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:51:41)"}" " " "${indent_18491}"
            local ret_rpad28_v0__51_23="${ret_rpad28_v0}"
            pending_18496="${ret_rpad28_v0__51_23}"
        fi
        split__4_v0 "${texts_18483[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:53:33)"}" " "
        local ret_split4_v0__53_21=("${ret_split4_v0[@]}")
        local words_18497=("${ret_split4_v0__53_21[@]}")
        local __length_360=("${words_18497[@]}")
        local note_start_18498="${#__length_360[@]}"
        if [ "$([ "_${notes_18484[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:55:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_361="${notes_18484[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:58:26)"}"
            if [ "$(( ${#__length_361} > avail_18493 ))" != 0 ]; then
                split__4_v0 "${notes_18484[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:59:38)"}" " "
                local ret_split4_v0__59_26=("${ret_split4_v0[@]}")
                words_18497+=("${ret_split4_v0__59_26[@]}")
            else
                local array_362=("${notes_18484[${i_18495}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:61:33)"}")
                words_18497+=("${array_362[@]}")
            fi
        fi
        local line_18499=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_18500=-1
        local __range_start_18501=0
        local __length_363=("${words_18497[@]}")
        local __range_end_18501="${#__length_363[@]}"
        local __dir_18501=$(( ${__range_start_18501} <= ${__range_end_18501} ? 1 : -1 ))
        for (( j_18501=${__range_start_18501}; j_18501 * ${__dir_18501} < ${__range_end_18501} * ${__dir_18501}; j_18501+=${__dir_18501} )); do
            local word_18502="${words_18497[${j_18501}]?"Index out of bounds (at src/./confirm/../utils/layout.ab:71:32)"}"
            local candidate_18503
            candidate_18503="$(if [ "$([ "_${line_18499}" != "_" ]; echo $?)" != 0 ]; then echo "${word_18502}"; else echo "${line_18499}"" ""${word_18502}"; fi)"
            local __length_364="${candidate_18503}"
            if [ "$(( $(( ${#__length_364} > avail_18493 )) && $([ "_${line_18499}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1743_v0 "${pending_18496}" "${line_18499}" "${note_at_18500}"
                pending_18496="${blank_18494}"
                line_18499="${word_18502}"
                note_at_18500="$(if [ "$(( j_18501 >= note_start_18498 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_18501 >= note_start_18498 )) && $(( note_at_18500 < 0 )) ))" != 0 ]; then
                    local __length_365="${candidate_18503}"
                    local __length_366="${word_18502}"
                    note_at_18500="$(( ${#__length_365} - ${#__length_366} ))"
                fi
                line_18499="${candidate_18503}"
            fi
done
        print_help_line__1743_v0 "${pending_18496}" "${line_18499}" "${note_at_18500}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1745_v0() {
    local pieces_18454=("${!1}")
    term_width__1740_v0 
    local width_18460="${ret_term_width1740_v0}"
    local line_18461=""
    local line_len_18462=0
    for piece_18463 in "${pieces_18454[@]}"; do
        local __length_369="${piece_18463}"
        local piece_len_18464="${#__length_369}"
        has_ansi_escape__1720_v0 "${piece_18463}"
        local ret_has_ansi_escape1720_v0__100_12="${ret_has_ansi_escape1720_v0}"
        if [ "${ret_has_ansi_escape1720_v0__100_12}" != 0 ]; then
            get_visible_len__1724_v0 "${piece_18463}"
            piece_len_18464="${ret_get_visible_len1724_v0}"
        fi
        if [ "$([ "_${line_18461}" != "_" ]; echo $?)" != 0 ]; then
            line_18461="${piece_18463}"
            line_len_18462="${piece_len_18464}"
        elif [ "$(( $(( $(( line_len_18462 + 1 )) + piece_len_18464 )) > width_18460 ))" != 0 ]; then
            local array_370=()
            printf__128_v0 "${line_18461}""
" array_370[@]
            line_18461="${piece_18463}"
            line_len_18462="${piece_len_18464}"
        else
            line_18461+=" ""${piece_18463}"
            line_len_18462="$(( line_len_18462 + $(( 1 + piece_len_18464 )) ))"
        fi
    done
    if [ "$([ "_${line_18461}" == "_" ]; echo $?)" != 0 ]; then
        local array_371=()
        printf__128_v0 "${line_18461}""
" array_371[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_80=0
_term_size_81=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1774_v0() {
    local command_373
    command_373="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_18520="${command_373}"
    parse_int__13_v0 "${count_18520}"
    __status=$?
    ret_stty_count1774_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1775_v0() {
    stty_count__1774_v0 
    local count_num_18521="${ret_stty_count1774_v0}"
    if [ "$(( count_num_18521 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_18521="$(( count_num_18521 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18521}
    __status=$?
}

# stty_unlock()
stty_unlock__1776_v0() {
    stty_count__1774_v0 
    local count_num_18615="${ret_stty_count1774_v0}"
    if [ "$(( count_num_18615 > 0 ))" != 0 ]; then
        count_num_18615="$(( count_num_18615 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_18615}
        __status=$?
        if [ "$(( count_num_18615 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1777_v0() {
    local size_18525="${1}"
    if [ "$([ "_${size_18525}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1777_v0=0
        return 0
    fi
    split__4_v0 "${size_18525}" " "
    local parts_18526=("${ret_split4_v0[@]}")
    local __length_374=("${parts_18526[@]}")
    if [ "$(( ${#__length_374[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1777_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_18526[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_18526[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_81=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1777_v0=1
    return 0
}

# query_term_size()
query_term_size__1778_v0() {
    local command_376
    command_376="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_18528="${command_376}"
    store_term_size__1777_v0 "${size_18528}"
    ret_query_term_size1778_v0="${ret_store_term_size1777_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1779_v0() {
    local command_377
    command_377="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_18524="${command_377}"
    store_term_size__1777_v0 "${size_18524}"
    ret_stty_term_size1779_v0="${ret_store_term_size1777_v0}"
    return 0
}

# get_term_size()
get_term_size__1780_v0() {
    stty_term_size__1779_v0 
    local detected_18527="${ret_stty_term_size1779_v0}"
    if [ "$(( ! detected_18527 ))" != 0 ]; then
        query_term_size__1778_v0 
        detected_18527="${ret_query_term_size1778_v0}"
    fi
    _got_term_size_80=1
}

# term_width()
term_width__1782_v0() {
    if [ "$(( ! _got_term_size_80 ))" != 0 ]; then
        get_term_size__1780_v0 
    fi
    ret_term_width1782_v0="${_term_size_81[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_82="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_83=0
_primary_color_84=(3 207 159 92)
_secondary_color_85=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1793_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_18449="${ret_env_var_get120_v0}"
    _supports_truecolor_82="$(if [ "$([ "_${config_18449}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1793_v0="$([ "_${_supports_truecolor_82}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1794_v0() {
    local message_18444="${1}"
    local r_18445="${2}"
    local g_18446="${3}"
    local b_18447="${4}"
    local fallback_18448="${5}"
    if [ "$([ "_${_supports_truecolor_82}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1794_v0="\\x1b[38;2;${r_18445};${g_18446};${b_18447}m""${message_18444}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_82}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1793_v0 
        local ret_get_supports_truecolor1793_v0__45_17="${ret_get_supports_truecolor1793_v0}"
        if [ "${ret_get_supports_truecolor1793_v0__45_17}" != 0 ]; then
            ret_colored_rgb1794_v0="\\x1b[38;2;${r_18445};${g_18446};${b_18447}m""${message_18444}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_18448 == 0 ))" != 0 ]; then
            ret_colored_rgb1794_v0="${message_18444}"
            return 0
        else
            ret_colored_rgb1794_v0="\\x1b[${fallback_18448}m""${message_18444}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_18448 == 0 ))" != 0 ]; then
            ret_colored_rgb1794_v0="${message_18444}"
            return 0
        fi
        ret_colored_rgb1794_v0="\\x1b[${fallback_18448}m""${message_18444}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1795_v0() {
    local message_18582="${1}"
    local r_18583="${2}"
    local g_18584="${3}"
    local b_18585="${4}"
    local fallback_18586="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_18587="${fallback_18586}"
    if [ "$(( $(( fallback_18586 >= 30 )) && $(( fallback_18586 <= 37 )) ))" != 0 ]; then
        bg_fallback_18587="$(( fallback_18586 + 10 ))"
    fi
    if [ "$(( $(( fallback_18586 >= 90 )) && $(( fallback_18586 <= 97 )) ))" != 0 ]; then
        bg_fallback_18587="$(( fallback_18586 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_82}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1795_v0="\\x1b[48;2;${r_18583};${g_18584};${b_18585}m""${message_18582}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_82}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1793_v0 
        local ret_get_supports_truecolor1793_v0__87_17="${ret_get_supports_truecolor1793_v0}"
        if [ "${ret_get_supports_truecolor1793_v0__87_17}" != 0 ]; then
            ret_background_rgb1795_v0="\\x1b[48;2;${r_18583};${g_18584};${b_18585}m""${message_18582}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_18587 == 0 ))" != 0 ]; then
            ret_background_rgb1795_v0="${message_18582}"
            return 0
        else
            ret_background_rgb1795_v0="\\x1b[${bg_fallback_18587}m""${message_18582}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_18587 == 0 ))" != 0 ]; then
            ret_background_rgb1795_v0="${message_18582}"
            return 0
        fi
        ret_background_rgb1795_v0="\\x1b[${bg_fallback_18587}m""${message_18582}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1796_v0() {
    if [ "$(( ! _got_xylitol_colors_83 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_18438="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_18438}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_18438}" ";"
            local parts_18439=("${ret_split4_v0[@]}")
            local __length_381=("${parts_18439[@]}")
            if [ "$(( ${#__length_381[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18439[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18439[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18439[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18439[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_84=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_18440="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_18440}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_18440}" ";"
            local parts_18441=("${ret_split4_v0[@]}")
            local __length_383=("${parts_18441[@]}")
            if [ "$(( ${#__length_383[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18441[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18441[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18441[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18441[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_85=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_18442="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_18442}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_18442}" ";"
            local parts_18443=("${ret_split4_v0[@]}")
            local __length_385=("${parts_18443[@]}")
            if [ "$(( ${#__length_385[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_18443[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18443[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18443[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_18443[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1796_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_83=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1797_v0() {
    inner_get_xylitol_colors__1796_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_83=1
}

# colored_primary(message: Text)
colored_primary__1798_v0() {
    local message_18437="${1}"
    if [ "$(( ! _got_xylitol_colors_83 ))" != 0 ]; then
        get_xylitol_colors__1797_v0 
    fi
    colored_rgb__1794_v0 "${message_18437}" "${_primary_color_84[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:48)"}" "${_primary_color_84[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:67)"}" "${_primary_color_84[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:86)"}" "${_primary_color_84[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary1798_v0="${ret_colored_rgb1794_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1799_v0() {
    local message_18478="${1}"
    if [ "$(( ! _got_xylitol_colors_83 ))" != 0 ]; then
        get_xylitol_colors__1797_v0 
    fi
    colored_rgb__1794_v0 "${message_18478}" "${_secondary_color_85[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:50)"}" "${_secondary_color_85[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:71)"}" "${_secondary_color_85[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:92)"}" "${_secondary_color_85[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary1799_v0="${ret_colored_rgb1794_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1802_v0() {
    local message_18581="${1}"
    if [ "$(( ! _got_xylitol_colors_83 ))" != 0 ]; then
        get_xylitol_colors__1797_v0 
    fi
    background_rgb__1795_v0 "${message_18581}" "${_secondary_color_85[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:53)"}" "${_secondary_color_85[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:74)"}" "${_secondary_color_85[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:95)"}" "${_secondary_color_85[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:187:116)"}"
    ret_background_secondary1802_v0="${ret_background_rgb1795_v0}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__1817_v0() {
    local format_18596="${1}"
    local args_18597=("${!2}")
    args_18597=("${format_18596}" "${args_18597[@]}")
    __status=$?
    printf "${args_18597[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1818_v0() {
    local message_18594="${1}"
    local color_18595="${2}"
    # Prints an error message with a specified color.
    local array_387=("${message_18594}")
    eprintf__1817_v0 "\\x1b[${color_18595}m%s\\x1b[0m" array_387[@]
}

# colored(message: Text, color: Int)
colored__1819_v0() {
    local message_18598="${1}"
    local color_18599="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1819_v0="\\x1b[${color_18599}m""${message_18598}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1823_v0() {
    local items_18588=("${!1}")
    local total_len_18589="${2}"
    local term_width_18590="${3}"
    local separator_18591=" • "
    local separator_len_18592=3
    # Fast path: no truncation needed
    if [ "$(( total_len_18589 <= term_width_18590 ))" != 0 ]; then
        local iter_18593=0
        while :
        do
            local __length_388=("${items_18588[@]}")
            if [ "$(( iter_18593 >= ${#__length_388[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_18593 > 0 ))" != 0 ]; then
                eprintf_colored__1818_v0 "${separator_18591}" 90
            fi
            colored__1819_v0 "${items_18588[$(( iter_18593 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored1819_v0__23_41="${ret_colored1819_v0}"
            local array_389=("")
            eprintf__1817_v0 "${items_18588[${iter_18593}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored1819_v0__23_41}" array_389[@]
            iter_18593="$(( iter_18593 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_18600=0
        local first_18601=1
        local iter_18602=0
        while :
        do
            local __length_390=("${items_18588[@]}")
            if [ "$(( iter_18602 >= ${#__length_390[@]} ))" != 0 ]; then
                break
            fi
            local key_18603="${items_18588[${iter_18602}]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:35:31)"}"
            local action_18604="${items_18588[$(( iter_18602 + 1 ))]?"Index out of bounds (at src/./confirm/../utils/widget/tooltip.ab:36:34)"}"
            local __length_391="${key_18603}"
            local __length_392="${action_18604}"
            local part_len_18605="$(( $(( ${#__length_391} + 1 )) + ${#__length_392} ))"
            local needed_18606="${part_len_18605}"
            if [ "$(( ! first_18601 ))" != 0 ]; then
                needed_18606="$(( needed_18606 + separator_len_18592 ))"
            fi
            if [ "$(( $(( current_len_18600 + needed_18606 )) > term_width_18590 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_18601 ))" != 0 ]; then
                eprintf_colored__1818_v0 "${separator_18591}" 90
            fi
            colored__1819_v0 "${action_18604}" 2
            local ret_colored1819_v0__51_33="${ret_colored1819_v0}"
            local array_393=("")
            eprintf__1817_v0 "${key_18603}"" ""${ret_colored1819_v0__51_33}" array_393[@]
            current_len_18600="$(( current_len_18600 + needed_18606 ))"
            first_18601=0
            iter_18602="$(( iter_18602 + 2 ))"
        done
    fi
}

# Facade over the helper modules, so every caller keeps importing one path.
# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1875_v0() {
    local selected_18562="${1}"
    local term_width_18563="${2}"
    local small_18564="$(( term_width_18563 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_18564}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_18578="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_18564}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_18579="${ret_cpad29_v0}"
    local gap_18580
    gap_18580="$(if [ "${small_18564}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_394=("")
    eprintf__1649_v0 " " array_394[@]
    if [ "${selected_18562}" != 0 ]; then
        # Yes selected
        background_secondary__1802_v0 "${yes_label_18578}"
        local ret_background_secondary1802_v0__16_30="${ret_background_secondary1802_v0}"
        local array_395=("")
        eprintf__1649_v0 "\\x1b[97m""${ret_background_secondary1802_v0__16_30}" array_395[@]
        local array_396=("")
        eprintf__1649_v0 "${gap_18580}" array_396[@]
        # No not selected (dim)
        local array_397=("")
        eprintf__1649_v0 "\\x1b[49;37m""${no_label_18579}""\\x1b[0m" array_397[@]
    else
        # No selected
        local array_398=("")
        eprintf__1649_v0 "\\x1b[49;37m""${yes_label_18578}""\\x1b[0m" array_398[@]
        local array_399=("")
        eprintf__1649_v0 "${gap_18580}" array_399[@]
        background_secondary__1802_v0 "${no_label_18579}"
        local ret_background_secondary1802_v0__24_30="${ret_background_secondary1802_v0}"
        local array_400=("")
        eprintf__1649_v0 "\\x1b[97m""${ret_background_secondary1802_v0__24_30}" array_400[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1876_v0() {
    local header_18518="${1}"
    local default_yes_18519="${2}"
    stty_lock__1775_v0 
    hide_cursor__1674_v0 
    term_width__1782_v0 
    local term_width_18529="${ret_term_width1782_v0}"
    if [ "$([ "_${header_18518}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1702_v0 "${header_18518}" "${term_width_18529}"
        local ret_cutoff_text1702_v0__46_17="${ret_cutoff_text1702_v0}"
        local array_401=("")
        eprintf__1649_v0 "${ret_cutoff_text1702_v0__46_17}""

" array_401[@]
    fi
    local selected_18561="${default_yes_18519}"
    # Render initial options
    render_confirm_options__1875_v0 "${selected_18561}" "${term_width_18529}"
    local array_402=("")
    eprintf__1649_v0 "

" array_402[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_403=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1823_v0 array_403[@] 40 "${term_width_18529}"
    go_up__1671_v0 2
    while :
    do
        get_key__1647_v0 
        local key_18609="${ret_get_key1647_v0}"
        if [ "$(( $(( $(( $([ "_${key_18609}" != "_LEFT" ]; echo $?) || $([ "_${key_18609}" != "_h" ]; echo $?) )) || $([ "_${key_18609}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_18609}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_18561}" != 0 ]; then
                selected_18561=0
                local array_404=("")
                eprintf__1649_v0 "\\x1b[G\\x1b[K" array_404[@]
                render_confirm_options__1875_v0 "${selected_18561}" "${term_width_18529}"
            elif [ "$(( ! selected_18561 ))" != 0 ]; then
                selected_18561=1
                local array_405=("")
                eprintf__1649_v0 "\\x1b[G\\x1b[K" array_405[@]
                render_confirm_options__1875_v0 "${selected_18561}" "${term_width_18529}"
            fi
        elif [ "$(( $([ "_${key_18609}" != "_y" ]; echo $?) || $([ "_${key_18609}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_18561=1
            break
        elif [ "$(( $([ "_${key_18609}" != "_n" ]; echo $?) || $([ "_${key_18609}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_18561=0
            break
        elif [ "$([ "_${key_18609}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_18610=4
    if [ "$([ "_${header_18518}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_18610="$(( total_lines_18610 + 1 ))"
    fi
    go_down__1672_v0 2
    remove_line__1667_v0 "$(( total_lines_18610 - 1 ))"
    remove_current_line__1668_v0 
    stty_unlock__1776_v0 
    show_cursor__1675_v0 
    ret_xyl_confirm1876_v0="${selected_18561}"
    return 0
}

# print_confirm_help()
print_confirm_help__1970_v0() {
    local usage_18453=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1745_v0 usage_18453[@]
    printf '%s\n' ""
    colored_primary__1798_v0 "confirm"
    local ret_colored_primary1798_v0__8_20="${ret_colored_primary1798_v0}"
    local title_18477=("${ret_colored_primary1798_v0__8_20}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1745_v0 title_18477[@]
    printf '%s\n' ""
    colored_secondary__1799_v0 "Flags:"
    local ret_colored_secondary1799_v0__11_12="${ret_colored_secondary1799_v0}"
    local array_408=()
    printf__128_v0 "${ret_colored_secondary1799_v0__11_12}""
" array_408[@]
    local names_18479=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_18480=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_18481=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__1744_v0 names_18479[@] texts_18480[@] notes_18481[@] 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__2022_v0() {
    local parameters_18436=("${!1}")
    colored_primary__1798_v0 "Are you sure?"
    local ret_colored_primary1798_v0__9_30="${ret_colored_primary1798_v0}"
    local header_18450="\\x1b[1m""${ret_colored_primary1798_v0__9_30}"
    local default_yes_18451=1
    for param_18452 in "${parameters_18436[@]}"; do
        starts_with__22_v0 "${param_18452}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_18452}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_18452}" != "_-h" ]; echo $?) || $([ "_${param_18452}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1970_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_414="--header="
            slice__24_v0 "${param_18452}" "${#__length_414}" 0
            header_18450="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_415="--default="
            slice__24_v0 "${param_18452}" "${#__length_415}" 0
            local value_18509="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_18509}" != "_yes" ]; echo $?) || $([ "_${value_18509}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_18451=1
            elif [ "$(( $([ "_${value_18509}" != "_no" ]; echo $?) || $([ "_${value_18509}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_18451=0
            else
                eprintf_colored__1650_v0 "ERROR: Invalid default value: ""${value_18509}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1695_v0 "${header_18450}"
    local ret_has_ansi_escape1695_v0__35_44="${ret_has_ansi_escape1695_v0}"
    escape_ansi__1696_v0 "${header_18450}"
    local ret_escape_ansi1696_v0__35_73="${ret_escape_ansi1696_v0}"
    colored_primary__1798_v0 "${header_18450}"
    local ret_colored_primary1798_v0__35_111="${ret_colored_primary1798_v0}"
    local display_header_18517
    display_header_18517="$(if [ "$(( $([ "_${header_18450}" != "_" ]; echo $?) || ret_has_ansi_escape1695_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1696_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1798_v0__35_111}"; fi)"
    xyl_confirm__1876_v0 "${display_header_18517}" "${default_yes_18451}"
    local result_18616="${ret_xyl_confirm1876_v0}"
    ret_execute_confirm2022_v0="$(if [ "${result_18616}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2140_v0() {
    local format_28050="${1}"
    local args_28051=("${!2}")
    args_28051=("${format_28050}" "${args_28051[@]}")
    __status=$?
    printf "${args_28051[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2141_v0() {
    local message_28048="${1}"
    local color_28049="${2}"
    # Prints an error message with a specified color.
    local array_416=("${message_28048}")
    eprintf__2140_v0 "\\x1b[${color_28049}m%s\\x1b[0m" array_416[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2153_v0() {
    local format_28080="${1}"
    local args_28081=("${!2}")
    args_28081=("${format_28080}" "${args_28081[@]}")
    __status=$?
    printf "${args_28081[@]}" >&2
    __status=$?
}

# colored(message: Text, color: Int)
colored__2155_v0() {
    local message_28042="${1}"
    local color_28043="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2155_v0="\\x1b[${color_28043}m""${message_28042}""\\x1b[0m"
    return 0
}

# remove_current_line()
remove_current_line__2159_v0() {
    local array_417=("")
    eprintf__2153_v0 "\\x1b[2K\\x1b[G" array_417[@]
}

# move the cursor up or down `cnt` lines.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_90="None"
# perl_available()
perl_available__2180_v0() {
    if [ "$([ "_${_perl_state_90}" != "_None" ]; echo $?)" != 0 ]; then
        local command_418
        command_418="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_27995
        disabled_27995="$([ "_${command_418}" != "_No" ]; echo $?)"
        local command_419
        command_419="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_27996
        found_27996="$(( $(( ! disabled_27995 )) && $([ "_${command_419}" != "_0" ]; echo $?) ))"
        _perl_state_90="$(if [ "${found_27996}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2180_v0="$([ "_${_perl_state_90}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2181_v0() {
    local text_27994="${1}"
    perl_available__2180_v0 
    local ret_perl_available2180_v0__22_12="${ret_perl_available2180_v0}"
    if [ "$(( ! ret_perl_available2180_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2181_v0=''
        return 1
    fi
    local command_420
    command_420="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_27994}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2181_v0=''
        return "${__status}"
    fi
    local width_str_27997="${command_420}"
    parse_int__13_v0 "${width_str_27997}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2181_v0=''
        return "${__status}"
    fi
    local width_27998="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2181_v0="${width_27998}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2211_v0() {
    local text_27987="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_421
    command_421="$([[ "${text_27987}" == *$'\x1b'* || "${text_27987}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_27988="${command_421}"
    ret_has_ansi_escape2211_v0="$([ "_${has_escape_27988}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2213_v0() {
    local text_27990="${1}"
    local command_422
    command_422="$(printf "%s" "${text_27990}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2213_v0="${command_422}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2214_v0() {
    local text_27992="${1}"
    local command_423
    command_423="$(printf "%s" "${text_27992}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_27993="${command_423}"
    ret_is_all_ascii2214_v0="$([ "_${result_27993}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2215_v0() {
    local text_27989="${1}"
    strip_ansi__2213_v0 "${text_27989}"
    local stripped_27991="${ret_strip_ansi2213_v0}"
    # Check if text is all ASCII
    is_all_ascii__2214_v0 "${stripped_27991}"
    local ret_is_all_ascii2214_v0__36_12="${ret_is_all_ascii2214_v0}"
    if [ "$(( ! ret_is_all_ascii2214_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2181_v0 "${stripped_27991}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_424="${stripped_27991}"
            ret_get_visible_len2215_v0="${#__length_424}"
            return 0
        fi
        ret_get_visible_len2215_v0="${ret_perl_get_cjk_width2181_v0}"
        return 0
    else
        local __length_425="${stripped_27991}"
        ret_get_visible_len2215_v0="${#__length_425}"
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
# store_term_size(size: Text)
store_term_size__2226_v0() {
    local size_27978="${1}"
    if [ "$([ "_${size_27978}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2226_v0=0
        return 0
    fi
    split__4_v0 "${size_27978}" " "
    local parts_27979=("${ret_split4_v0[@]}")
    local __length_427=("${parts_27979[@]}")
    if [ "$(( ${#__length_427[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2226_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_27979[1]?"Index out of bounds (at src/./file/../utils/./term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_27979[0]?"Index out of bounds (at src/./file/../utils/./term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_92=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size2226_v0=1
    return 0
}

# query_term_size()
query_term_size__2227_v0() {
    local command_429
    command_429="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_27981="${command_429}"
    store_term_size__2226_v0 "${size_27981}"
    ret_query_term_size2227_v0="${ret_store_term_size2226_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2228_v0() {
    local command_430
    command_430="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_27977="${command_430}"
    store_term_size__2226_v0 "${size_27977}"
    ret_stty_term_size2228_v0="${ret_store_term_size2226_v0}"
    return 0
}

# get_term_size()
get_term_size__2229_v0() {
    stty_term_size__2228_v0 
    local detected_27980="${ret_stty_term_size2228_v0}"
    if [ "$(( ! detected_27980 ))" != 0 ]; then
        query_term_size__2227_v0 
        detected_27980="${ret_query_term_size2227_v0}"
    fi
    _got_term_size_91=1
}

# term_width()
term_width__2231_v0() {
    if [ "$(( ! _got_term_size_91 ))" != 0 ]; then
        get_term_size__2229_v0 
    fi
    ret_term_width2231_v0="${_term_size_92[0]?"Index out of bounds (at src/./file/../utils/./term.ab:93:23)"}"
    return 0
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2234_v0() {
    local pending_28039="${1}"
    local line_28040="${2}"
    local note_at_28041="${3}"
    if [ "$(( note_at_28041 < 0 ))" != 0 ]; then
        local array_431=()
        printf__128_v0 "${pending_28039}""${line_28040}""
" array_431[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_28041 == 0 ))" != 0 ]; then
        colored__2155_v0 "${line_28040}" 90
        local ret_colored2155_v0__13_40="${ret_colored2155_v0}"
        local array_432=()
        printf__128_v0 "${pending_28039}""${ret_colored2155_v0__13_40}""
" array_432[@]
    else
        slice__24_v0 "${line_28040}" 0 "${note_at_28041}"
        local ret_slice24_v0__14_32="${ret_slice24_v0}"
        slice__24_v0 "${line_28040}" "${note_at_28041}" 0
        local ret_slice24_v0__14_66="${ret_slice24_v0}"
        colored__2155_v0 "${ret_slice24_v0__14_66}" 90
        local ret_colored2155_v0__14_58="${ret_colored2155_v0}"
        local array_433=()
        printf__128_v0 "${pending_28039}""${ret_slice24_v0__14_32}""${ret_colored2155_v0__14_58}""
" array_433[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2235_v0() {
    local names_28017=("${!1}")
    local texts_28018=("${!2}")
    local notes_28019=("${!3}")
    local min_name_width_28020="${4}"
    local __length_434=("${names_28017[@]}")
    local count_28021="${#__length_434[@]}"
    local name_width_28022="${min_name_width_28020}"
    local __range_start_28023=0
    local __range_end_28023="${count_28021}"
    local __dir_28023=$(( ${__range_start_28023} <= ${__range_end_28023} ? 1 : -1 ))
    for (( i_28023=${__range_start_28023}; i_28023 * ${__dir_28023} < ${__range_end_28023} * ${__dir_28023}; i_28023+=${__dir_28023} )); do
        local __length_435="${names_28017[${i_28023}]?"Index out of bounds (at src/./file/../utils/layout.ab:29:33)"}"
        local width_28024="${#__length_435}"
        if [ "$(( width_28024 > name_width_28022 ))" != 0 ]; then
            name_width_28022="${width_28024}"
        fi
done
    term_width__2231_v0 
    local width_28025="${ret_term_width2231_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_28026="$(( name_width_28022 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_28027="$(( $(( width_28025 - indent_28026 )) < 24 ))"
    if [ "${stacked_28027}" != 0 ]; then
        indent_28026=6
    fi
    local avail_28028="$(( width_28025 - indent_28026 ))"
    rpad__28_v0 "" " " "${indent_28026}"
    local blank_28029="${ret_rpad28_v0}"
    local __range_start_28030=0
    local __range_end_28030="${count_28021}"
    local __dir_28030=$(( ${__range_start_28030} <= ${__range_end_28030} ? 1 : -1 ))
    for (( i_28030=${__range_start_28030}; i_28030 * ${__dir_28030} < ${__range_end_28030} * ${__dir_28030}; i_28030+=${__dir_28030} )); do
        local pending_28031="${blank_28029}"
        if [ "${stacked_28027}" != 0 ]; then
            local array_436=()
            printf__128_v0 "  ""${names_28017[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:49:33)"}""
" array_436[@]
        else
            rpad__28_v0 "  ""${names_28017[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:51:41)"}" " " "${indent_28026}"
            local ret_rpad28_v0__51_23="${ret_rpad28_v0}"
            pending_28031="${ret_rpad28_v0__51_23}"
        fi
        split__4_v0 "${texts_28018[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:53:33)"}" " "
        local ret_split4_v0__53_21=("${ret_split4_v0[@]}")
        local words_28032=("${ret_split4_v0__53_21[@]}")
        local __length_437=("${words_28032[@]}")
        local note_start_28033="${#__length_437[@]}"
        if [ "$([ "_${notes_28019[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:55:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_438="${notes_28019[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:58:26)"}"
            if [ "$(( ${#__length_438} > avail_28028 ))" != 0 ]; then
                split__4_v0 "${notes_28019[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:59:38)"}" " "
                local ret_split4_v0__59_26=("${ret_split4_v0[@]}")
                words_28032+=("${ret_split4_v0__59_26[@]}")
            else
                local array_439=("${notes_28019[${i_28030}]?"Index out of bounds (at src/./file/../utils/layout.ab:61:33)"}")
                words_28032+=("${array_439[@]}")
            fi
        fi
        local line_28034=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_28035=-1
        local __range_start_28036=0
        local __length_440=("${words_28032[@]}")
        local __range_end_28036="${#__length_440[@]}"
        local __dir_28036=$(( ${__range_start_28036} <= ${__range_end_28036} ? 1 : -1 ))
        for (( j_28036=${__range_start_28036}; j_28036 * ${__dir_28036} < ${__range_end_28036} * ${__dir_28036}; j_28036+=${__dir_28036} )); do
            local word_28037="${words_28032[${j_28036}]?"Index out of bounds (at src/./file/../utils/layout.ab:71:32)"}"
            local candidate_28038
            candidate_28038="$(if [ "$([ "_${line_28034}" != "_" ]; echo $?)" != 0 ]; then echo "${word_28037}"; else echo "${line_28034}"" ""${word_28037}"; fi)"
            local __length_441="${candidate_28038}"
            if [ "$(( $(( ${#__length_441} > avail_28028 )) && $([ "_${line_28034}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2234_v0 "${pending_28031}" "${line_28034}" "${note_at_28035}"
                pending_28031="${blank_28029}"
                line_28034="${word_28037}"
                note_at_28035="$(if [ "$(( j_28036 >= note_start_28033 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_28036 >= note_start_28033 )) && $(( note_at_28035 < 0 )) ))" != 0 ]; then
                    local __length_442="${candidate_28038}"
                    local __length_443="${word_28037}"
                    note_at_28035="$(( ${#__length_442} - ${#__length_443} ))"
                fi
                line_28034="${candidate_28038}"
            fi
done
        print_help_line__2234_v0 "${pending_28031}" "${line_28034}" "${note_at_28035}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__2236_v0() {
    local pieces_27976=("${!1}")
    term_width__2231_v0 
    local width_27982="${ret_term_width2231_v0}"
    local line_27983=""
    local line_len_27984=0
    for piece_27985 in "${pieces_27976[@]}"; do
        local __length_446="${piece_27985}"
        local piece_len_27986="${#__length_446}"
        has_ansi_escape__2211_v0 "${piece_27985}"
        local ret_has_ansi_escape2211_v0__100_12="${ret_has_ansi_escape2211_v0}"
        if [ "${ret_has_ansi_escape2211_v0__100_12}" != 0 ]; then
            get_visible_len__2215_v0 "${piece_27985}"
            piece_len_27986="${ret_get_visible_len2215_v0}"
        fi
        if [ "$([ "_${line_27983}" != "_" ]; echo $?)" != 0 ]; then
            line_27983="${piece_27985}"
            line_len_27984="${piece_len_27986}"
        elif [ "$(( $(( $(( line_len_27984 + 1 )) + piece_len_27986 )) > width_27982 ))" != 0 ]; then
            local array_447=()
            printf__128_v0 "${line_27983}""
" array_447[@]
            line_27983="${piece_27985}"
            line_len_27984="${piece_len_27986}"
        else
            line_27983+=" ""${piece_27985}"
            line_len_27984="$(( line_len_27984 + $(( 1 + piece_len_27986 )) ))"
        fi
    done
    if [ "$([ "_${line_27983}" == "_" ]; echo $?)" != 0 ]; then
        local array_448=()
        printf__128_v0 "${line_27983}""
" array_448[@]
    fi
}

# How many elements one entry takes up in `get_directory_entries`.
__ENTRY_STRIDE_93=3
# get_directory_entries(path: Text)
get_directory_entries__2244_v0() {
    local path_28061="${1}"
    local __ls_path_449="${path_28061}"
    __ls_path_449="${__ls_path_449//\\/\\\\}"
    (( 1 )) && __ls_all_449="-A" || __ls_all_449=""
    (( 0 )) && __ls_rec_449="-R" || __ls_rec_449=""
    local __ls_449=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_449 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_449} ${__ls_rec_449} ${__ls_path_449}
    __status=$?
    );
    local names_28062=("${__ls_449[@]}")
    local command_450
    command_450="$(LC_ALL=C ls -lA "${path_28061}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_28063="${command_450}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_451
    command_451="$(LC_ALL=C ls -lA "${path_28061}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_28064="${command_451}"
    split__4_v0 "${types_output_28063}" "
"
    local types_28065=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_28064}" "
"
    local targets_28066=("${ret_split4_v0[@]}")
    local entries_28067=()
    local __range_start_28068=0
    local __length_453=("${names_28062[@]}")
    local __range_end_28068="${#__length_453[@]}"
    local __dir_28068=$(( ${__range_start_28068} <= ${__range_end_28068} ? 1 : -1 ))
    for (( i_28068=${__range_start_28068}; i_28068 * ${__dir_28068} < ${__range_end_28068} * ${__dir_28068}; i_28068+=${__dir_28068} )); do
        local array_454=("${names_28062[${i_28068}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:27)"}")
        entries_28067+=("${array_454[@]}")
        local array_455=("${types_28065[${i_28068}]?"Index out of bounds (at src/./file/../utils/fs.ab:30:27)"}")
        entries_28067+=("${array_455[@]}")
        slice__24_v0 "${targets_28066[${i_28068}]?"Index out of bounds (at src/./file/../utils/fs.ab:31:35)"}" 1 0
        local ret_slice24_v0__31_21="${ret_slice24_v0}"
        local array_456=("${ret_slice24_v0__31_21}")
        entries_28067+=("${array_456[@]}")
done
    ret_get_directory_entries2244_v0=("${entries_28067[@]}")
    return 0
}

# get_cwd()
get_cwd__2245_v0() {
    local command_457
    command_457="$(pwd)"
    __status=$?
    ret_get_cwd2245_v0="${command_457}"
    return 0
}

# normalize_path(path: Text)
normalize_path__2246_v0() {
    local path_28059="${1}"
    local command_458
    command_458="$(cd "${path_28059}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_28060="${command_458}"
    if [ "$([ "_${normalized_28060}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path2246_v0="${path_28059}"
        return 0
    fi
    ret_normalize_path2246_v0="${normalized_28060}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__2247_v0() {
    local base_28236="${1}"
    local child_28237="${2}"
    if [ "$([ "_${base_28236}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join2247_v0="/""${child_28237}"
        return 0
    fi
    ret_path_join2247_v0="${base_28236}""/""${child_28237}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__2248_v0() {
    local path_28234="${1}"
    local command_459
    command_459="$(dirname "${path_28234}")"
    __status=$?
    local parent_28235="${command_459}"
    ret_get_parent_dir2248_v0="${parent_28235}"
    return 0
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
# stty_count()
stty_count__2265_v0() {
    local command_461
    command_461="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_28056="${command_461}"
    parse_int__13_v0 "${count_28056}"
    __status=$?
    ret_stty_count2265_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2266_v0() {
    stty_count__2265_v0 
    local count_num_28057="${ret_stty_count2265_v0}"
    if [ "$(( count_num_28057 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_28057="$(( count_num_28057 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28057}
    __status=$?
}

# stty_unlock()
stty_unlock__2267_v0() {
    stty_count__2265_v0 
    local count_num_28078="${ret_stty_count2265_v0}"
    if [ "$(( count_num_28078 > 0 ))" != 0 ]; then
        count_num_28078="$(( count_num_28078 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28078}
        __status=$?
        if [ "$(( count_num_28078 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_98="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_99=0
_primary_color_100=(3 207 159 92)
_secondary_color_101=(3 118 206 94)
_accent_color_102=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__2284_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_28011="${ret_env_var_get120_v0}"
    _supports_truecolor_98="$(if [ "$([ "_${config_28011}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2284_v0="$([ "_${_supports_truecolor_98}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2285_v0() {
    local message_28006="${1}"
    local r_28007="${2}"
    local g_28008="${3}"
    local b_28009="${4}"
    local fallback_28010="${5}"
    if [ "$([ "_${_supports_truecolor_98}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2285_v0="\\x1b[38;2;${r_28007};${g_28008};${b_28009}m""${message_28006}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_98}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2284_v0 
        local ret_get_supports_truecolor2284_v0__45_17="${ret_get_supports_truecolor2284_v0}"
        if [ "${ret_get_supports_truecolor2284_v0__45_17}" != 0 ]; then
            ret_colored_rgb2285_v0="\\x1b[38;2;${r_28007};${g_28008};${b_28009}m""${message_28006}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_28010 == 0 ))" != 0 ]; then
            ret_colored_rgb2285_v0="${message_28006}"
            return 0
        else
            ret_colored_rgb2285_v0="\\x1b[${fallback_28010}m""${message_28006}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_28010 == 0 ))" != 0 ]; then
            ret_colored_rgb2285_v0="${message_28006}"
            return 0
        fi
        ret_colored_rgb2285_v0="\\x1b[${fallback_28010}m""${message_28006}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2287_v0() {
    if [ "$(( ! _got_xylitol_colors_99 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_28000="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_28000}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_28000}" ";"
            local parts_28001=("${ret_split4_v0[@]}")
            local __length_465=("${parts_28001[@]}")
            if [ "$(( ${#__length_465[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28001[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28001[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28001[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28001[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
                _primary_color_100=("${ret_parse_int13_v0__110_21}" "${ret_parse_int13_v0__111_21}" "${ret_parse_int13_v0__112_21}" "${ret_parse_int13_v0__113_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_28002="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_28002}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_28002}" ";"
            local parts_28003=("${ret_split4_v0[@]}")
            local __length_467=("${parts_28003[@]}")
            if [ "$(( ${#__length_467[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28003[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28003[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28003[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28003[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_101=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_28004="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_28004}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_28004}" ";"
            local parts_28005=("${ret_split4_v0[@]}")
            local __length_469=("${parts_28005[@]}")
            if [ "$(( ${#__length_469[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28005[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28005[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28005[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28005[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2287_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
                _accent_color_102=("${ret_parse_int13_v0__136_21}" "${ret_parse_int13_v0__137_21}" "${ret_parse_int13_v0__138_21}" "${ret_parse_int13_v0__139_21}")
            fi
        fi
        _got_xylitol_colors_99=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2288_v0() {
    inner_get_xylitol_colors__2287_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_99=1
}

# colored_primary(message: Text)
colored_primary__2289_v0() {
    local message_27999="${1}"
    if [ "$(( ! _got_xylitol_colors_99 ))" != 0 ]; then
        get_xylitol_colors__2288_v0 
    fi
    colored_rgb__2285_v0 "${message_27999}" "${_primary_color_100[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:48)"}" "${_primary_color_100[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:67)"}" "${_primary_color_100[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:86)"}" "${_primary_color_100[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:159:105)"}"
    ret_colored_primary2289_v0="${ret_colored_rgb2285_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2290_v0() {
    local message_28013="${1}"
    if [ "$(( ! _got_xylitol_colors_99 ))" != 0 ]; then
        get_xylitol_colors__2288_v0 
    fi
    colored_rgb__2285_v0 "${message_28013}" "${_secondary_color_101[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:50)"}" "${_secondary_color_101[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:71)"}" "${_secondary_color_101[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:92)"}" "${_secondary_color_101[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2290_v0="${ret_colored_rgb2285_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2291_v0() {
    local message_28174="${1}"
    if [ "$(( ! _got_xylitol_colors_99 ))" != 0 ]; then
        get_xylitol_colors__2288_v0 
    fi
    colored_rgb__2285_v0 "${message_28174}" "${_accent_color_102[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:47)"}" "${_accent_color_102[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:65)"}" "${_accent_color_102[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:83)"}" "${_accent_color_102[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:173:101)"}"
    ret_colored_accent2291_v0="${ret_colored_rgb2285_v0}"
    return 0
}

# Facade over the helper modules, so every caller keeps importing one path.
# get_key()
get_key__2415_v0() {
    local command_471
    command_471="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_28208="${command_471}"
    if [ "$([ "_${var_28208}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2415_v0="UP"
        return 0
    elif [ "$([ "_${var_28208}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2415_v0="DOWN"
        return 0
    elif [ "$([ "_${var_28208}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2415_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_28208}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2415_v0="LEFT"
        return 0
    elif [ "$([ "_${var_28208}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2415_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_28208}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2415_v0="INPUT"
        return 0
    else
        ret_get_key2415_v0="${var_28208}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2417_v0() {
    local format_28137="${1}"
    local args_28138=("${!2}")
    args_28138=("${format_28137}" "${args_28138[@]}")
    __status=$?
    printf "${args_28138[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2418_v0() {
    local message_28142="${1}"
    local color_28143="${2}"
    # Prints an error message with a specified color.
    local array_472=("${message_28142}")
    eprintf__2417_v0 "\\x1b[${color_28143}m%s\\x1b[0m" array_472[@]
}

# eprintf(format: Text, args: [Text])
eprintf__2430_v0() {
    local format_28090="${1}"
    local args_28091=("${!2}")
    args_28091=("${format_28090}" "${args_28091[@]}")
    __status=$?
    printf "${args_28091[@]}" >&2
    __status=$?
}

# remove_line(cnt: Int)
remove_line__2435_v0() {
    local cnt_28205="${1}"
    if [ "$(( cnt_28205 > 0 ))" != 0 ]; then
        local sequence_28206=""
        local __range_start_28207=0
        local __range_end_28207="${cnt_28205}"
        local __dir_28207=$(( ${__range_start_28207} <= ${__range_end_28207} ? 1 : -1 ))
        for (( ____28207=${__range_start_28207}; ____28207 * ${__dir_28207} < ${__range_end_28207} * ${__dir_28207}; ____28207+=${__dir_28207} )); do
            sequence_28206+="\\x1b[2K\\x1b[1A"
done
        local array_473=("")
        eprintf__2430_v0 "${sequence_28206}" array_473[@]
    fi
    local array_474=("")
    eprintf__2430_v0 "\\x1b[G" array_474[@]
}

# remove_current_line()
remove_current_line__2436_v0() {
    local array_475=("")
    eprintf__2430_v0 "\\x1b[2K\\x1b[G" array_475[@]
}

# print_blank(cnt: Int)
print_blank__2437_v0() {
    local cnt_28196="${1}"
    printf '%*s' "${cnt_28196}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2438_v0() {
    local cnt_28140="${1}"
    local __range_start_28141=0
    local __range_end_28141="${cnt_28140}"
    local __dir_28141=$(( ${__range_start_28141} <= ${__range_end_28141} ? 1 : -1 ))
    for (( ____28141=${__range_start_28141}; ____28141 * ${__dir_28141} < ${__range_end_28141} * ${__dir_28141}; ____28141+=${__dir_28141} )); do
        local array_476=("")
        eprintf__2430_v0 "
" array_476[@]
done
}

# go_up(cnt: Int)
go_up__2439_v0() {
    local cnt_28163="${1}"
    local array_477=("")
    eprintf__2430_v0 "\\x1b[${cnt_28163}A" array_477[@]
}

# go_down(cnt: Int)
go_down__2440_v0() {
    local cnt_28217="${1}"
    local array_478=("")
    eprintf__2430_v0 "\\x1b[${cnt_28217}B" array_478[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2441_v0() {
    local cnt_28226="${1}"
    if [ "$(( cnt_28226 > 0 ))" != 0 ]; then
        go_down__2440_v0 "${cnt_28226}"
    else
        go_up__2439_v0 "$(( - cnt_28226 ))"
    fi
}

# hide_cursor()
hide_cursor__2442_v0() {
    local array_479=("")
    eprintf__2430_v0 "\\x1b[?25l" array_479[@]
}

# show_cursor()
show_cursor__2443_v0() {
    local array_480=("")
    eprintf__2430_v0 "\\x1b[?25h" array_480[@]
}

# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
_perl_state_104="None"
# perl_available()
perl_available__2457_v0() {
    if [ "$([ "_${_perl_state_104}" != "_None" ]; echo $?)" != 0 ]; then
        local command_481
        command_481="$(echo "$XYLITOL_USE_PERL")"
        __status=$?
        local disabled_28107
        disabled_28107="$([ "_${command_481}" != "_No" ]; echo $?)"
        local command_482
        command_482="$(command -v perl > /dev/null && echo 0 || echo 1)"
        __status=$?
        local found_28108
        found_28108="$(( $(( ! disabled_28107 )) && $([ "_${command_482}" != "_0" ]; echo $?) ))"
        _perl_state_104="$(if [ "${found_28108}" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    fi
    ret_perl_available2457_v0="$([ "_${_perl_state_104}" != "_Yes" ]; echo $?)"
    return 0
}

# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2458_v0() {
    local text_28106="${1}"
    perl_available__2457_v0 
    local ret_perl_available2457_v0__22_12="${ret_perl_available2457_v0}"
    if [ "$(( ! ret_perl_available2457_v0__22_12 ))" != 0 ]; then
        ret_perl_get_cjk_width2458_v0=''
        return 1
    fi
    local command_483
    command_483="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_28106}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2458_v0=''
        return "${__status}"
    fi
    local width_str_28109="${command_483}"
    parse_int__13_v0 "${width_str_28109}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2458_v0=''
        return "${__status}"
    fi
    local width_28110="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2458_v0="${width_28110}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2459_v0() {
    local text_28119="${1}"
    local max_width_28120="${2}"
    perl_available__2457_v0 
    local ret_perl_available2457_v0__33_12="${ret_perl_available2457_v0}"
    if [ "$(( ! ret_perl_available2457_v0__33_12 ))" != 0 ]; then
        ret_perl_truncate_cjk2459_v0=''
        return 1
    fi
    local command_484
    command_484="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_28119}" ${max_width_28120} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2459_v0=''
        return "${__status}"
    fi
    local result_28121="${command_484}"
    ret_perl_truncate_cjk2459_v0="${result_28121}"
    return 0
}

# has_ansi_escape(text: Text)
has_ansi_escape__2463_v0() {
    local text_28114="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_485
    command_485="$([[ "${text_28114}" == *$'\x1b'* || "${text_28114}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_28115="${command_485}"
    ret_has_ansi_escape2463_v0="$([ "_${has_escape_28115}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2465_v0() {
    local text_28102="${1}"
    local command_486
    command_486="$(printf "%s" "${text_28102}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2465_v0="${command_486}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2466_v0() {
    local text_28104="${1}"
    local command_487
    command_487="$(printf "%s" "${text_28104}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_28105="${command_487}"
    ret_is_all_ascii2466_v0="$([ "_${result_28105}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2467_v0() {
    local text_28101="${1}"
    strip_ansi__2465_v0 "${text_28101}"
    local stripped_28103="${ret_strip_ansi2465_v0}"
    # Check if text is all ASCII
    is_all_ascii__2466_v0 "${stripped_28103}"
    local ret_is_all_ascii2466_v0__36_12="${ret_is_all_ascii2466_v0}"
    if [ "$(( ! ret_is_all_ascii2466_v0__36_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2458_v0 "${stripped_28103}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_488="${stripped_28103}"
            ret_get_visible_len2467_v0="${#__length_488}"
            return 0
        fi
        ret_get_visible_len2467_v0="${ret_perl_get_cjk_width2458_v0}"
        return 0
    else
        local __length_489="${stripped_28103}"
        ret_get_visible_len2467_v0="${#__length_489}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2468_v0() {
    local text_28116="${1}"
    local max_width_28117="${2}"
    get_visible_len__2467_v0 "${text_28116}"
    local visible_len_28118="${ret_get_visible_len2467_v0}"
    if [ "$(( visible_len_28118 <= max_width_28117 ))" != 0 ]; then
        ret_truncate_text2468_v0="${text_28116}"
        return 0
    fi
    is_all_ascii__2466_v0 "${text_28116}"
    local ret_is_all_ascii2466_v0__53_12="${ret_is_all_ascii2466_v0}"
    if [ "$(( ! ret_is_all_ascii2466_v0__53_12 ))" != 0 ]; then
        perl_truncate_cjk__2459_v0 "${text_28116}" "${max_width_28117}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_28116}" | cut -c1-${max_width_28117}
            __status=$?
        fi
        ret_truncate_text2468_v0="${ret_perl_truncate_cjk2459_v0}"
        return 0
    fi
    local command_490
    command_490="$(printf "%s" "${text_28116}" | cut -c1-${max_width_28117})"
    __status=$?
    ret_truncate_text2468_v0="${command_490}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2469_v0() {
    local text_28112="${1}"
    local max_width_28113="${2}"
    has_ansi_escape__2463_v0 "${text_28112}"
    local ret_has_ansi_escape2463_v0__65_12="${ret_has_ansi_escape2463_v0}"
    if [ "$(( ! ret_has_ansi_escape2463_v0__65_12 ))" != 0 ]; then
        truncate_text__2468_v0 "${text_28112}" "${max_width_28113}"
        ret_truncate_ansi2469_v0="${ret_truncate_text2468_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_491
    command_491="$([[ "${text_28112}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_28122="${command_491}"
    # Replace \x1b[ with newline, then split
    local command_492
    command_492="$(t="${text_28112}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_28123="${command_492}"
    split__4_v0 "${replaced_28123}" "
"
    local parts_28124=("${ret_split4_v0[@]}")
    local result_28125=""
    local remaining_width_28126="${max_width_28113}"
    local __range_start_28127=0
    local __length_493=("${parts_28124[@]}")
    local __range_end_28127="${#__length_493[@]}"
    local __dir_28127=$(( ${__range_start_28127} <= ${__range_end_28127} ? 1 : -1 ))
    for (( idx_28127=${__range_start_28127}; idx_28127 * ${__dir_28127} < ${__range_end_28127} * ${__dir_28127}; idx_28127+=${__dir_28127} )); do
        local part_28128="${parts_28124[${idx_28127}]?"Index out of bounds (at src/./file/../choose/../utils/ansi.ab:80:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_28127 == 0 )) && $([ "_${starts_with_ansi_28122}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_28128}" == "_" ]; echo $?) && $(( remaining_width_28126 > 0 )) ))" != 0 ]; then
                truncate_text__2468_v0 "${part_28128}" "${remaining_width_28126}"
                local ret_truncate_text2468_v0__87_35="${ret_truncate_text2468_v0}"
                local truncated_28129="${ret_truncate_text2468_v0__87_35}"
                result_28125+="${truncated_28129}"
                get_visible_len__2467_v0 "${truncated_28129}"
                local ret_get_visible_len2467_v0__89_36="${ret_get_visible_len2467_v0}"
                remaining_width_28126="$(( remaining_width_28126 - ret_get_visible_len2467_v0__89_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_494
            command_494="$(__p="${part_28128}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_28130="${command_494}"
            if [ "$([ "_${m_idx_28130}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_495
                command_495="$(__p="${part_28128}"; printf "%s" "${__p:0:${m_idx_28130}}")"
                __status=$?
                local ansi_params_28131="${command_495}"
                result_28125+="\\x1b[""${ansi_params_28131}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_28130}"
                __status=$?
                local ret_parse_int13_v0__100_41="${ret_parse_int13_v0}"
                local m_idx_num_28132="${ret_parse_int13_v0__100_41}"
                local text_start_28133="$(( m_idx_num_28132 + 1 ))"
                local command_496
                command_496="$(__p="${part_28128}"; printf "%s" "${__p:${text_start_28133}}")"
                __status=$?
                local text_part_28134="${command_496}"
                if [ "$(( $([ "_${text_part_28134}" == "_" ]; echo $?) && $(( remaining_width_28126 > 0 )) ))" != 0 ]; then
                    truncate_text__2468_v0 "${text_part_28134}" "${remaining_width_28126}"
                    local ret_truncate_text2468_v0__104_39="${ret_truncate_text2468_v0}"
                    local truncated_28135="${ret_truncate_text2468_v0__104_39}"
                    result_28125+="${truncated_28135}"
                    get_visible_len__2467_v0 "${truncated_28135}"
                    local ret_get_visible_len2467_v0__106_40="${ret_get_visible_len2467_v0}"
                    remaining_width_28126="$(( remaining_width_28126 - ret_get_visible_len2467_v0__106_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_28128}" == "_" ]; echo $?) && $(( remaining_width_28126 > 0 )) ))" != 0 ]; then
                    truncate_text__2468_v0 "${part_28128}" "${remaining_width_28126}"
                    local ret_truncate_text2468_v0__111_39="${ret_truncate_text2468_v0}"
                    local truncated_28136="${ret_truncate_text2468_v0__111_39}"
                    result_28125+="${truncated_28136}"
                    get_visible_len__2467_v0 "${truncated_28136}"
                    local ret_get_visible_len2467_v0__113_40="${ret_get_visible_len2467_v0}"
                    remaining_width_28126="$(( remaining_width_28126 - ret_get_visible_len2467_v0__113_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2469_v0="${result_28125}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2470_v0() {
    local text_28099="${1}"
    local max_width_28100="${2}"
    get_visible_len__2467_v0 "${text_28099}"
    local visible_len_28111="${ret_get_visible_len2467_v0}"
    if [ "$(( visible_len_28111 <= max_width_28100 ))" != 0 ]; then
        ret_cutoff_text2470_v0="${text_28099}"
        return 0
    fi
    truncate_ansi__2469_v0 "${text_28099}" "$(( max_width_28100 - 3 ))"
    local ret_truncate_ansi2469_v0__129_12="${ret_truncate_ansi2469_v0}"
    ret_cutoff_text2470_v0="${ret_truncate_ansi2469_v0__129_12}""..."
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# How many elements one entry takes up in `get_directory_entries`.
# Perl Extensions Utilities
# "None" until the first call decides, then "Yes" or "No".
# 
# Deciding eagerly would spawn two subshells every time this module is loaded,
# which the compiler does once per import path spelling.
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_110=0
_term_size_111=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2542_v0() {
    local command_499
    command_499="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_28088="${command_499}"
    parse_int__13_v0 "${count_28088}"
    __status=$?
    ret_stty_count2542_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2543_v0() {
    stty_count__2542_v0 
    local count_num_28089="${ret_stty_count2542_v0}"
    if [ "$(( count_num_28089 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_28089="$(( count_num_28089 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28089}
    __status=$?
}

# stty_unlock()
stty_unlock__2544_v0() {
    stty_count__2542_v0 
    local count_num_28231="${ret_stty_count2542_v0}"
    if [ "$(( count_num_28231 > 0 ))" != 0 ]; then
        count_num_28231="$(( count_num_28231 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_28231}
        __status=$?
        if [ "$(( count_num_28231 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2545_v0() {
    local size_28093="${1}"
    if [ "$([ "_${size_28093}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2545_v0=0
        return 0
    fi
    split__4_v0 "${size_28093}" " "
    local parts_28094=("${ret_split4_v0[@]}")
    local __length_500=("${parts_28094[@]}")
    if [ "$(( ${#__length_500[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2545_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_28094[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_28094[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_111=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size2545_v0=1
    return 0
}

# query_term_size()
query_term_size__2546_v0() {
    local command_502
    command_502="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 1 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_28096="${command_502}"
    store_term_size__2545_v0 "${size_28096}"
    ret_query_term_size2546_v0="${ret_store_term_size2545_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2547_v0() {
    local command_503
    command_503="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_28092="${command_503}"
    store_term_size__2545_v0 "${size_28092}"
    ret_stty_term_size2547_v0="${ret_store_term_size2545_v0}"
    return 0
}

# get_term_size()
get_term_size__2548_v0() {
    stty_term_size__2547_v0 
    local detected_28095="${ret_stty_term_size2547_v0}"
    if [ "$(( ! detected_28095 ))" != 0 ]; then
        query_term_size__2546_v0 
        detected_28095="${ret_query_term_size2546_v0}"
    fi
    _got_term_size_110=1
}

# term_width()
term_width__2550_v0() {
    if [ "$(( ! _got_term_size_110 ))" != 0 ]; then
        get_term_size__2548_v0 
    fi
    ret_term_width2550_v0="${_term_size_111[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__2551_v0() {
    if [ "$(( ! _got_term_size_110 ))" != 0 ]; then
        get_term_size__2548_v0 
    fi
    ret_term_height2551_v0="${_term_size_111[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_112="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_113=0
_secondary_color_115=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2561_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_28195="${ret_env_var_get120_v0}"
    _supports_truecolor_112="$(if [ "$([ "_${config_28195}" != "_Yes" ]; echo $?)" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2561_v0="$([ "_${_supports_truecolor_112}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2562_v0() {
    local message_28190="${1}"
    local r_28191="${2}"
    local g_28192="${3}"
    local b_28193="${4}"
    local fallback_28194="${5}"
    if [ "$([ "_${_supports_truecolor_112}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2562_v0="\\x1b[38;2;${r_28191};${g_28192};${b_28193}m""${message_28190}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_112}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2561_v0 
        local ret_get_supports_truecolor2561_v0__45_17="${ret_get_supports_truecolor2561_v0}"
        if [ "${ret_get_supports_truecolor2561_v0__45_17}" != 0 ]; then
            ret_colored_rgb2562_v0="\\x1b[38;2;${r_28191};${g_28192};${b_28193}m""${message_28190}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_28194 == 0 ))" != 0 ]; then
            ret_colored_rgb2562_v0="${message_28190}"
            return 0
        else
            ret_colored_rgb2562_v0="\\x1b[${fallback_28194}m""${message_28190}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_28194 == 0 ))" != 0 ]; then
            ret_colored_rgb2562_v0="${message_28190}"
            return 0
        fi
        ret_colored_rgb2562_v0="\\x1b[${fallback_28194}m""${message_28190}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2564_v0() {
    if [ "$(( ! _got_xylitol_colors_113 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_28184="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_28184}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_28184}" ";"
            local parts_28185=("${ret_split4_v0[@]}")
            local __length_507=("${parts_28185[@]}")
            if [ "$(( ${#__length_507[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28185[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:110:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__110_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28185[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:111:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__111_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28185[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:112:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__112_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28185[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:113:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__113_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_28186="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_28186}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_28186}" ";"
            local parts_28187=("${ret_split4_v0[@]}")
            local __length_509=("${parts_28187[@]}")
            if [ "$(( ${#__length_509[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28187[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:123:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__123_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28187[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:124:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__124_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28187[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:125:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__125_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28187[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:126:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__126_21="${ret_parse_int13_v0}"
                _secondary_color_115=("${ret_parse_int13_v0__123_21}" "${ret_parse_int13_v0__124_21}" "${ret_parse_int13_v0__125_21}" "${ret_parse_int13_v0__126_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_28188="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_28188}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_28188}" ";"
            local parts_28189=("${ret_split4_v0[@]}")
            local __length_511=("${parts_28189[@]}")
            if [ "$(( ${#__length_511[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_28189[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:136:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__136_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28189[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:137:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__137_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28189[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:138:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__138_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_28189[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:139:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2564_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__139_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_113=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2565_v0() {
    inner_get_xylitol_colors__2564_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_113=1
}

# colored_secondary(message: Text)
colored_secondary__2567_v0() {
    local message_28183="${1}"
    if [ "$(( ! _got_xylitol_colors_113 ))" != 0 ]; then
        get_xylitol_colors__2565_v0 
    fi
    colored_rgb__2562_v0 "${message_28183}" "${_secondary_color_115[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:50)"}" "${_secondary_color_115[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:71)"}" "${_secondary_color_115[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:92)"}" "${_secondary_color_115[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:166:113)"}"
    ret_colored_secondary2567_v0="${ret_colored_rgb2562_v0}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__2585_v0() {
    local format_28152="${1}"
    local args_28153=("${!2}")
    args_28153=("${format_28152}" "${args_28153[@]}")
    __status=$?
    printf "${args_28153[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2586_v0() {
    local message_28150="${1}"
    local color_28151="${2}"
    # Prints an error message with a specified color.
    local array_513=("${message_28150}")
    eprintf__2585_v0 "\\x1b[${color_28151}m%s\\x1b[0m" array_513[@]
}

# colored(message: Text, color: Int)
colored__2587_v0() {
    local message_28154="${1}"
    local color_28155="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2587_v0="\\x1b[${color_28155}m""${message_28154}""\\x1b[0m"
    return 0
}

# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2591_v0() {
    local items_28144=("${!1}")
    local total_len_28145="${2}"
    local term_width_28146="${3}"
    local separator_28147=" • "
    local separator_len_28148=3
    # Fast path: no truncation needed
    if [ "$(( total_len_28145 <= term_width_28146 ))" != 0 ]; then
        local iter_28149=0
        while :
        do
            local __length_514=("${items_28144[@]}")
            if [ "$(( iter_28149 >= ${#__length_514[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_28149 > 0 ))" != 0 ]; then
                eprintf_colored__2586_v0 "${separator_28147}" 90
            fi
            colored__2587_v0 "${items_28144[$(( iter_28149 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:55)"}" 2
            local ret_colored2587_v0__23_41="${ret_colored2587_v0}"
            local array_515=("")
            eprintf__2585_v0 "${items_28144[${iter_28149}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:23:27)"}"" ""${ret_colored2587_v0__23_41}" array_515[@]
            iter_28149="$(( iter_28149 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_28156=0
        local first_28157=1
        local iter_28158=0
        while :
        do
            local __length_516=("${items_28144[@]}")
            if [ "$(( iter_28158 >= ${#__length_516[@]} ))" != 0 ]; then
                break
            fi
            local key_28159="${items_28144[${iter_28158}]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:35:31)"}"
            local action_28160="${items_28144[$(( iter_28158 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils/widget/tooltip.ab:36:34)"}"
            local __length_517="${key_28159}"
            local __length_518="${action_28160}"
            local part_len_28161="$(( $(( ${#__length_517} + 1 )) + ${#__length_518} ))"
            local needed_28162="${part_len_28161}"
            if [ "$(( ! first_28157 ))" != 0 ]; then
                needed_28162="$(( needed_28162 + separator_len_28148 ))"
            fi
            if [ "$(( $(( current_len_28156 + needed_28162 )) > term_width_28146 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_28157 ))" != 0 ]; then
                eprintf_colored__2586_v0 "${separator_28147}" 90
            fi
            colored__2587_v0 "${action_28160}" 2
            local ret_colored2587_v0__51_33="${ret_colored2587_v0}"
            local array_519=("")
            eprintf__2585_v0 "${key_28159}"" ""${ret_colored2587_v0__51_33}" array_519[@]
            current_len_28156="$(( current_len_28156 + needed_28162 ))"
            first_28157=0
            iter_28158="$(( iter_28158 + 2 ))"
        done
    fi
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
__CHOOSER_CONTINUE_118=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_119=1
# The user confirmed the selection.
__CHOOSER_DONE_120=2
_total_121=0
_page_size_122=10
_display_count_123=0
_total_pages_124=1
_current_page_125=0
_selected_126=0
_cursor_127="> "
_multi_128=0
_limit_129=-1
_term_width_130=80
_has_header_131=0
_page_132=()
_page_count_133=0
_checked_134=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_135=0
_first_render_136=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_137=0
# render_single_page()
render_single_page__2643_v0() {
    local __length_522="${_cursor_127}"
    local cursor_len_28199="${#__length_522}"
    local max_option_width_28200="$(( $(( _term_width_130 - cursor_len_28199 )) - 1 ))"
    local __range_start_28201=0
    local __range_end_28201="${_page_count_133}"
    local __dir_28201=$(( ${__range_start_28201} <= ${__range_end_28201} ? 1 : -1 ))
    for (( i_28201=${__range_start_28201}; i_28201 * ${__dir_28201} < ${__range_end_28201} * ${__dir_28201}; i_28201+=${__dir_28201} )); do
        cutoff_text__2470_v0 "${_page_132[${i_28201}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_28200}"
        local ret_cutoff_text2470_v0__48_27="${ret_cutoff_text2470_v0}"
        local truncated_28202="${ret_cutoff_text2470_v0__48_27}"
        if [ "$(( i_28201 == _selected_126 ))" != 0 ]; then
            colored_secondary__2567_v0 "${_cursor_127}""${truncated_28202}""
"
            local ret_colored_secondary2567_v0__50_21="${ret_colored_secondary2567_v0}"
            local array_523=("")
            eprintf__2417_v0 "${ret_colored_secondary2567_v0__50_21}" array_523[@]
        else
            print_blank__2437_v0 "${cursor_len_28199}"
            local array_524=("")
            eprintf__2417_v0 "${truncated_28202}""
" array_524[@]
        fi
done
    local remaining_slots_28203="$(( _display_count_123 - _page_count_133 ))"
    if [ "$(( remaining_slots_28203 > 0 ))" != 0 ]; then
        local __range_start_28204=0
        local __range_end_28204="${remaining_slots_28203}"
        local __dir_28204=$(( ${__range_start_28204} <= ${__range_end_28204} ? 1 : -1 ))
        for (( ____28204=${__range_start_28204}; ____28204 * ${__dir_28204} < ${__range_end_28204} * ${__dir_28204}; ____28204+=${__dir_28204} )); do
            local array_525=("")
            eprintf__2417_v0 "\\x1b[K
" array_525[@]
done
    fi
}

# render_multi_page()
render_multi_page__2644_v0() {
    local __length_526="${_cursor_127}"
    local cursor_len_28176="${#__length_526}"
    local max_option_width_28177="$(( $(( _term_width_130 - cursor_len_28176 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2649_v0 
    local page_start_28178="${ret_chooser_page_start2649_v0}"
    local __range_start_28179=0
    local __range_end_28179="${_page_count_133}"
    local __dir_28179=$(( ${__range_start_28179} <= ${__range_end_28179} ? 1 : -1 ))
    for (( i_28179=${__range_start_28179}; i_28179 * ${__dir_28179} < ${__range_end_28179} * ${__dir_28179}; i_28179+=${__dir_28179} )); do
        local global_idx_28180="$(( page_start_28178 + i_28179 ))"
        local check_mark_28181
        check_mark_28181="$(if [ "${_checked_134[${global_idx_28180}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2470_v0 "${_page_132[${i_28179}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_28177}"
        local ret_cutoff_text2470_v0__71_27="${ret_cutoff_text2470_v0}"
        local truncated_28182="${ret_cutoff_text2470_v0__71_27}"
        if [ "$(( i_28179 == _selected_126 ))" != 0 ]; then
            colored_secondary__2567_v0 "${_cursor_127}""${check_mark_28181}""${truncated_28182}""
"
            local ret_colored_secondary2567_v0__73_37="${ret_colored_secondary2567_v0}"
            local array_527=("")
            eprintf__2417_v0 "${ret_colored_secondary2567_v0__73_37}" array_527[@]
        elif [ "${_checked_134[${global_idx_28180}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2437_v0 "${cursor_len_28176}"
            colored_secondary__2567_v0 "${check_mark_28181}""${truncated_28182}""
"
            local ret_colored_secondary2567_v0__76_25="${ret_colored_secondary2567_v0}"
            local array_528=("")
            eprintf__2417_v0 "${ret_colored_secondary2567_v0__76_25}" array_528[@]
        else
            print_blank__2437_v0 "${cursor_len_28176}"
            local array_529=("")
            eprintf__2417_v0 "${check_mark_28181}""${truncated_28182}""
" array_529[@]
        fi
done
    local remaining_slots_28197="$(( _display_count_123 - _page_count_133 ))"
    if [ "$(( remaining_slots_28197 > 0 ))" != 0 ]; then
        local __range_start_28198=0
        local __range_end_28198="${remaining_slots_28197}"
        local __dir_28198=$(( ${__range_start_28198} <= ${__range_end_28198} ? 1 : -1 ))
        for (( ____28198=${__range_start_28198}; ____28198 * ${__dir_28198} < ${__range_end_28198} * ${__dir_28198}; ____28198+=${__dir_28198} )); do
            local array_530=("")
            eprintf__2417_v0 "\\x1b[K
" array_530[@]
done
    fi
}

# render_page()
render_page__2645_v0() {
    if [ "${_multi_128}" != 0 ]; then
        render_multi_page__2644_v0 
    else
        render_single_page__2643_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2646_v0() {
    if [ "$(( _total_pages_124 > 1 ))" != 0 ]; then
        local array_531=("")
        eprintf__2417_v0 "\\x1b[G\\x1b[K" array_531[@]
        eprintf_colored__2418_v0 "Page $(( _current_page_125 + 1 ))/${_total_pages_124}" 90
        local array_532=("")
        eprintf__2417_v0 "\\x1b[G" array_532[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2647_v0() {
    if [ "$(( ! _multi_128 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_124 > 1 ))" != 0 ]; then
            local array_533=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2591_v0 array_533[@] 36 "${_term_width_130}"
        else
            local array_534=("↑↓" "select" "enter" "confirm")
            render_tooltip__2591_v0 array_534[@] 25 "${_term_width_130}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_124 > 1 )) && $(( _limit_129 < 0 )) ))" != 0 ]; then
            local array_535=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2591_v0 array_535[@] 55 "${_term_width_130}"
        elif [ "$(( _total_pages_124 > 1 ))" != 0 ]; then
            local array_536=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2591_v0 array_536[@] 47 "${_term_width_130}"
        elif [ "$(( _limit_129 < 0 ))" != 0 ]; then
            local array_537=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2591_v0 array_537[@] 44 "${_term_width_130}"
        else
            local array_538=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2591_v0 array_538[@] 36 "${_term_width_130}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2648_v0() {
    local total_28082="${1}"
    local page_size_28083="${2}"
    local header_28084="${3}"
    local cursor_28085="${4}"
    local multi_28086="${5}"
    local limit_28087="${6}"
    _total_121="${total_28082}"
    _cursor_127="${cursor_28085}"
    _multi_128="${multi_28086}"
    _limit_129="${limit_28087}"
    _current_page_125=0
    _selected_126=0
    _first_render_136=1
    _up_paged_137=0
    _checked_count_135=0
    _has_header_131="$([ "_${header_28084}" == "_" ]; echo $?)"
    stty_lock__2543_v0 
    hide_cursor__2442_v0 
    term_width__2550_v0 
    _term_width_130="${ret_term_width2550_v0}"
    term_height__2551_v0 
    local term_height_28097="${ret_term_height2551_v0}"
    local max_page_size_28098
    max_page_size_28098="$(( term_height_28097 - $(if [ "${_has_header_131}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_122="${page_size_28083}"
    if [ "$(( _page_size_122 > max_page_size_28098 ))" != 0 ]; then
        _page_size_122="${max_page_size_28098}"
    fi
    if [ "${_has_header_131}" != 0 ]; then
        cutoff_text__2470_v0 "${header_28084}" "${_term_width_130}"
        local ret_cutoff_text2470_v0__157_17="${ret_cutoff_text2470_v0}"
        local array_539=("")
        eprintf__2417_v0 "${ret_cutoff_text2470_v0__157_17}""
" array_539[@]
    fi
    math_floor__561_v0 "$(( $(( $(( total_28082 + _page_size_122 )) - 1 )) / _page_size_122 ))"
    _total_pages_124="${ret_math_floor561_v0}"
    _display_count_123="${_page_size_122}"
    if [ "$(( total_28082 < _page_size_122 ))" != 0 ]; then
        _display_count_123="${total_28082}"
    fi
    if [ "${multi_28086}" != 0 ]; then
        _checked_134=()
        local __range_start_28139=0
        local __range_end_28139="${total_28082}"
        local __dir_28139=$(( ${__range_start_28139} <= ${__range_end_28139} ? 1 : -1 ))
        for (( ____28139=${__range_start_28139}; ____28139 * ${__dir_28139} < ${__range_end_28139} * ${__dir_28139}; ____28139+=${__dir_28139} )); do
            local array_541=(0)
            _checked_134+=("${array_541[@]}")
done
    fi
    new_line__2438_v0 "${_display_count_123}"
    local array_542=("")
    eprintf__2417_v0 "\\x1b[G" array_542[@]
    if [ "$(( _total_pages_124 > 1 ))" != 0 ]; then
        eprintf_colored__2418_v0 "Page $(( _current_page_125 + 1 ))/${_total_pages_124}" 90
    fi
    new_line__2438_v0 1
    render_tooltip_line__2647_v0 
    go_up__2439_v0 "$(( _display_count_123 + 1 ))"
    local array_543=("")
    eprintf__2417_v0 "\\x1b[G" array_543[@]
}

# chooser_page_start()
chooser_page_start__2649_v0() {
    ret_chooser_page_start2649_v0="$(( _current_page_125 * _page_size_122 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2650_v0() {
    chooser_page_start__2649_v0 
    local start_28167="${ret_chooser_page_start2649_v0}"
    local end_28168="$(( start_28167 + _page_size_122 ))"
    if [ "$(( end_28168 > _total_121 ))" != 0 ]; then
        end_28168="${_total_121}"
    fi
    ret_chooser_page_count2650_v0="$(( end_28168 - start_28167 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2651_v0() {
    local page_28175=("${!1}")
    _page_132=("${page_28175[@]}")
    local __length_544=("${page_28175[@]}")
    _page_count_133="${#__length_544[@]}"
    if [ "${_first_render_136}" != 0 ]; then
        _first_render_136=0
        render_page__2645_v0 
    else
        if [ "${_up_paged_137}" != 0 ]; then
            _selected_126="$(( _page_count_133 - 1 ))"
            _up_paged_137=0
        fi
        go_up__2439_v0 1
        remove_line__2435_v0 "$(( _display_count_123 - 1 ))"
        remove_current_line__2436_v0 
        local array_545=("")
        eprintf__2417_v0 "\\x1b[G" array_545[@]
        render_page__2645_v0 
        render_page_indicator__2646_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2652_v0() {
    local prev_selected_28220="${1}"
    chooser_page_start__2649_v0 
    local page_start_28221="${ret_chooser_page_start2649_v0}"
    local check_width_28222
    check_width_28222="$(if [ "${_multi_128}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_546="${_cursor_127}"
    local max_option_width_28223="$(( $(( _term_width_130 - ${#__length_546} )) - check_width_28222 ))"
    go_up__2439_v0 "$(( _display_count_123 - prev_selected_28220 ))"
    local array_547=("")
    eprintf__2417_v0 "\\x1b[K" array_547[@]
    local __length_548="${_cursor_127}"
    print_blank__2437_v0 "${#__length_548}"
    if [ "${_multi_128}" != 0 ]; then
        local was_checked_28224="${_checked_134[$(( page_start_28221 + prev_selected_28220 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2470_v0 "${_page_132[${prev_selected_28220}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_28223}"
        local ret_cutoff_text2470_v0__232_63="${ret_cutoff_text2470_v0}"
        local prev_line_28225
        prev_line_28225="$(if [ "${was_checked_28224}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2470_v0__232_63}"
        if [ "${was_checked_28224}" != 0 ]; then
            colored_secondary__2567_v0 "${prev_line_28225}"
            local ret_colored_secondary2567_v0__234_21="${ret_colored_secondary2567_v0}"
            local array_549=("")
            eprintf__2417_v0 "${ret_colored_secondary2567_v0__234_21}" array_549[@]
        else
            local array_550=("")
            eprintf__2417_v0 "${prev_line_28225}" array_550[@]
        fi
    else
        cutoff_text__2470_v0 "${_page_132[${prev_selected_28220}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_28223}"
        local ret_cutoff_text2470_v0__239_17="${ret_cutoff_text2470_v0}"
        local array_551=("")
        eprintf__2417_v0 "${ret_cutoff_text2470_v0__239_17}" array_551[@]
    fi
    go_up_or_down__2441_v0 "$(( _selected_126 - prev_selected_28220 ))"
    local array_552=("")
    eprintf__2417_v0 "\\x1b[G" array_552[@]
    local array_553=("")
    eprintf__2417_v0 "\\x1b[K" array_553[@]
    local mark_28227
    mark_28227="$(if [ "${_multi_128}" != 0 ]; then echo "$(if [ "${_checked_134[$(( page_start_28221 + _selected_126 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2470_v0 "${_page_132[${_selected_126}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_28223}"
    local ret_cutoff_text2470_v0__246_48="${ret_cutoff_text2470_v0}"
    colored_secondary__2567_v0 "${_cursor_127}""${mark_28227}""${ret_cutoff_text2470_v0__246_48}"
    local ret_colored_secondary2567_v0__246_13="${ret_colored_secondary2567_v0}"
    local array_554=("")
    eprintf__2417_v0 "${ret_colored_secondary2567_v0__246_13}" array_554[@]
    go_down__2440_v0 "$(( _display_count_123 - _selected_126 ))"
    local array_555=("")
    eprintf__2417_v0 "\\x1b[G" array_555[@]
}

# redraw_current_line()
redraw_current_line__2653_v0() {
    chooser_page_start__2649_v0 
    local page_start_28214="${ret_chooser_page_start2649_v0}"
    local __length_556="${_cursor_127}"
    local max_option_width_28215="$(( $(( _term_width_130 - ${#__length_556} )) - 3 ))"
    go_up__2439_v0 "$(( _display_count_123 - _selected_126 ))"
    local array_557=("")
    eprintf__2417_v0 "\\x1b[G" array_557[@]
    local array_558=("")
    eprintf__2417_v0 "\\x1b[K" array_558[@]
    local check_mark_28216
    check_mark_28216="$(if [ "${_checked_134[$(( page_start_28214 + _selected_126 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2470_v0 "${_page_132[${_selected_126}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_28215}"
    local ret_cutoff_text2470_v0__260_54="${ret_cutoff_text2470_v0}"
    colored_secondary__2567_v0 "${_cursor_127}""${check_mark_28216}""${ret_cutoff_text2470_v0__260_54}"
    local ret_colored_secondary2567_v0__260_13="${ret_colored_secondary2567_v0}"
    local array_559=("")
    eprintf__2417_v0 "${ret_colored_secondary2567_v0__260_13}" array_559[@]
    go_down__2440_v0 "$(( _display_count_123 - _selected_126 ))"
    local array_560=("")
    eprintf__2417_v0 "\\x1b[G" array_560[@]
}

# chooser_step()
chooser_step__2654_v0() {
    get_key__2415_v0 
    local key_28209="${ret_get_key2415_v0}"
    local prev_selected_28210="${_selected_126}"
    local prev_page_28211="${_current_page_125}"
    chooser_page_start__2649_v0 
    local page_start_28212="${ret_chooser_page_start2649_v0}"
    _up_paged_137=0
    if [ "$(( $([ "_${key_28209}" != "_UP" ]; echo $?) || $([ "_${key_28209}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_126 == 0 )) && $(( _total_pages_124 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_125 > 0 ))" != 0 ]; then
                _current_page_125="$(( _current_page_125 - 1 ))"
            else
                _current_page_125="$(( _total_pages_124 - 1 ))"
            fi
            _up_paged_137=1
        elif [ "$(( _selected_126 == 0 ))" != 0 ]; then
            _selected_126="$(( _page_count_133 - 1 ))"
        else
            _selected_126="$(( _selected_126 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_28209}" != "_DOWN" ]; echo $?) || $([ "_${key_28209}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_126 == $(( _page_count_133 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_125 < $(( _total_pages_124 - 1 )) ))" != 0 ]; then
                _current_page_125="$(( _current_page_125 + 1 ))"
            else
                _current_page_125=0
            fi
            _selected_126=0
        else
            _selected_126="$(( _selected_126 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_28209}" != "_LEFT" ]; echo $?) || $([ "_${key_28209}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_125 > 0 ))" != 0 ]; then
            _current_page_125="$(( _current_page_125 - 1 ))"
        fi
        _selected_126=0
    elif [ "$(( $([ "_${key_28209}" != "_RIGHT" ]; echo $?) || $([ "_${key_28209}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_125 < $(( _total_pages_124 - 1 )) ))" != 0 ]; then
            _current_page_125="$(( _current_page_125 + 1 ))"
            _selected_126=0
        else
            _selected_126="$(( _page_count_133 - 1 ))"
        fi
    elif [ "$(( _multi_128 && $(( $([ "_${key_28209}" != "_x" ]; echo $?) || $([ "_${key_28209}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_28213="$(( page_start_28212 + _selected_126 ))"
        if [ "${_checked_134[${global_selected_28213}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_134["${global_selected_28213}"]=0
            _checked_count_135="$(( _checked_count_135 - 1 ))"
        elif [ "$(( $(( _limit_129 < 0 )) || $(( _checked_count_135 < _limit_129 )) ))" != 0 ]; then
            _checked_134["${global_selected_28213}"]=1
            _checked_count_135="$(( _checked_count_135 + 1 ))"
        else
            ret_chooser_step2654_v0="${__CHOOSER_CONTINUE_118}"
            return 0
        fi
        redraw_current_line__2653_v0 
        ret_chooser_step2654_v0="${__CHOOSER_CONTINUE_118}"
        return 0
    elif [ "$(( $(( _multi_128 && $(( $([ "_${key_28209}" != "_a" ]; echo $?) || $([ "_${key_28209}" != "_A" ]; echo $?) )) )) && $(( _limit_129 < 0 )) ))" != 0 ]; then
        local all_checked_28218="$(( _checked_count_135 == _total_121 ))"
        local __range_start_28219=0
        local __range_end_28219="${_total_121}"
        local __dir_28219=$(( ${__range_start_28219} <= ${__range_end_28219} ? 1 : -1 ))
        for (( i_28219=${__range_start_28219}; i_28219 * ${__dir_28219} < ${__range_end_28219} * ${__dir_28219}; i_28219+=${__dir_28219} )); do
            _checked_134["${i_28219}"]="$(( ! all_checked_28218 ))"
done
        _checked_count_135="$(if [ "${all_checked_28218}" != 0 ]; then echo 0; else echo "${_total_121}"; fi)"
        go_up__2439_v0 "${_display_count_123}"
        local array_561=("")
        eprintf__2417_v0 "\\x1b[G" array_561[@]
        render_page__2645_v0 
        ret_chooser_step2654_v0="${__CHOOSER_CONTINUE_118}"
        return 0
    elif [ "$([ "_${key_28209}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2654_v0="${__CHOOSER_DONE_120}"
        return 0
    else
        ret_chooser_step2654_v0="${__CHOOSER_CONTINUE_118}"
        return 0
    fi
    if [ "$(( prev_page_28211 != _current_page_125 ))" != 0 ]; then
        ret_chooser_step2654_v0="${__CHOOSER_NEED_PAGE_119}"
        return 0
    fi
    if [ "$(( prev_selected_28210 != _selected_126 ))" != 0 ]; then
        redraw_selection__2652_v0 "${prev_selected_28210}"
    fi
    ret_chooser_step2654_v0="${__CHOOSER_CONTINUE_118}"
    return 0
}

# chooser_selected()
chooser_selected__2655_v0() {
    chooser_page_start__2649_v0 
    local ret_chooser_page_start2649_v0__362_12="${ret_chooser_page_start2649_v0}"
    ret_chooser_selected2655_v0="$(( ret_chooser_page_start2649_v0__362_12 + _selected_126 ))"
    return 0
}

# chooser_end()
chooser_end__2657_v0() {
    local total_lines_28230="$(( _display_count_123 + 2 ))"
    if [ "${_has_header_131}" != 0 ]; then
        total_lines_28230="$(( total_lines_28230 + 1 ))"
    fi
    go_down__2440_v0 1
    remove_line__2435_v0 "$(( total_lines_28230 - 1 ))"
    remove_current_line__2436_v0 
    stty_unlock__2544_v0 
    show_cursor__2443_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2666_v0() {
    local name_28171="${1}"
    local file_type_28172="${2}"
    local target_28173="${3}"
    if [ "$([ "_${file_type_28172}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2289_v0 "/"
        local ret_colored_primary2289_v0__10_23="${ret_colored_primary2289_v0}"
        ret_format_entry_display2666_v0="${name_28171}""${ret_colored_primary2289_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_28172}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2291_v0 " > "
        local ret_colored_accent2291_v0__13_23="${ret_colored_accent2291_v0}"
        colored_primary__2289_v0 "${target_28173}"
        local ret_colored_primary2289_v0__13_47="${ret_colored_primary2289_v0}"
        ret_format_entry_display2666_v0="${name_28171}""${ret_colored_accent2291_v0__13_23}""${ret_colored_primary2289_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2666_v0="${name_28171}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2667_v0() {
    local start_path_28052="${1}"
    local cursor_28053="${2}"
    local show_hidden_28054="${3}"
    local page_size_28055="${4}"
    stty_lock__2266_v0 
    # Initialize current path
    local current_path_28058="${start_path_28052}"
    if [ "$([ "_${current_path_28058}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__2245_v0 
        current_path_28058="${ret_get_cwd2245_v0}"
    fi
    normalize_path__2246_v0 "${current_path_28058}"
    current_path_28058="${ret_normalize_path2246_v0}"
    while :
    do
        colored_primary__2289_v0 "Loading files..."
        local ret_colored_primary2289_v0__41_17="${ret_colored_primary2289_v0}"
        local array_562=("")
        eprintf__2140_v0 "${ret_colored_primary2289_v0__41_17}" array_562[@]
        get_directory_entries__2244_v0 "${current_path_28058}"
        local listed_28069=("${ret_get_directory_entries2244_v0[@]}")
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_28070=()
        local types_28071=()
        local targets_28072=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_28058}" == "_/" ]; echo $?)" != 0 ]; then
            names_28070+=("..")
            types_28071+=("d")
            targets_28072+=("")
        fi
        local __length_569=("${listed_28069[@]}")
        local listed_count_28073="$(( ${#__length_569[@]} / __ENTRY_STRIDE_93 ))"
        local __range_start_28074=0
        local __range_end_28074="${listed_count_28073}"
        local __dir_28074=$(( ${__range_start_28074} <= ${__range_end_28074} ? 1 : -1 ))
        for (( i_28074=${__range_start_28074}; i_28074 * ${__dir_28074} < ${__range_end_28074} * ${__dir_28074}; i_28074+=${__dir_28074} )); do
            local at_28075="$(( i_28074 * __ENTRY_STRIDE_93 ))"
            local name_28076="${listed_28069[${at_28075}]?"Index out of bounds (at src/./file/./mod.ab:62:33)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_28076}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_28054 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            local array_570=("${name_28076}")
            names_28070+=("${array_570[@]}")
            local array_571=("${listed_28069[$(( at_28075 + 1 ))]?"Index out of bounds (at src/./file/./mod.ab:68:30)"}")
            types_28071+=("${array_571[@]}")
            local array_572=("${listed_28069[$(( at_28075 + 2 ))]?"Index out of bounds (at src/./file/./mod.ab:69:32)"}")
            targets_28072+=("${array_572[@]}")
done
        local __length_573=("${names_28070[@]}")
        local total_28077="${#__length_573[@]}"
        if [ "$(( total_28077 == 0 ))" != 0 ]; then
            eprintf_colored__2141_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__2267_v0 
            ret_xyl_file2667_v0=""
            return 0
        fi
        colored_primary__2289_v0 "${current_path_28058}"
        local header_28079="${ret_colored_primary2289_v0}"
        remove_current_line__2159_v0 
        chooser_begin__2648_v0 "${total_28077}" "${page_size_28055}" "${header_28079}" "${cursor_28053}" 0 -1
        local need_page_28164=1
        while :
        do
            if [ "${need_page_28164}" != 0 ]; then
                local page_28165=()
                chooser_page_start__2649_v0 
                local start_28166="${ret_chooser_page_start2649_v0}"
                chooser_page_count__2650_v0 
                local count_28169="${ret_chooser_page_count2650_v0}"
                local __range_start_28170="${start_28166}"
                local __range_end_28170="$(( start_28166 + count_28169 ))"
                local __dir_28170=$(( ${__range_start_28170} <= ${__range_end_28170} ? 1 : -1 ))
                for (( i_28170=${__range_start_28170}; i_28170 * ${__dir_28170} < ${__range_end_28170} * ${__dir_28170}; i_28170+=${__dir_28170} )); do
                    format_entry_display__2666_v0 "${names_28070[${i_28170}]?"Index out of bounds (at src/./file/./mod.ab:90:57)"}" "${types_28071[${i_28170}]?"Index out of bounds (at src/./file/./mod.ab:90:67)"}" "${targets_28072[${i_28170}]?"Index out of bounds (at src/./file/./mod.ab:90:79)"}"
                    local ret_format_entry_display2666_v0__90_30="${ret_format_entry_display2666_v0}"
                    local array_575=("${ret_format_entry_display2666_v0__90_30}")
                    page_28165+=("${array_575[@]}")
done
                chooser_set_page__2651_v0 page_28165[@]
            fi
            chooser_step__2654_v0 
            local step_28228="${ret_chooser_step2654_v0}"
            if [ "$(( step_28228 == __CHOOSER_DONE_120 ))" != 0 ]; then
                break
            fi
            need_page_28164="$(( step_28228 == __CHOOSER_NEED_PAGE_119 ))"
        done
        chooser_selected__2655_v0 
        local selected_idx_28229="${ret_chooser_selected2655_v0}"
        chooser_end__2657_v0 
        local name_28232="${names_28070[${selected_idx_28229}]?"Index out of bounds (at src/./file/./mod.ab:103:28)"}"
        local file_type_28233="${types_28071[${selected_idx_28229}]?"Index out of bounds (at src/./file/./mod.ab:104:33)"}"
        if [ "$([ "_${name_28232}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__2248_v0 "${current_path_28058}"
            current_path_28058="${ret_get_parent_dir2248_v0}"
        elif [ "$([ "_${file_type_28233}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__2247_v0 "${current_path_28058}" "${name_28232}"
            current_path_28058="${ret_path_join2247_v0}"
            normalize_path__2246_v0 "${current_path_28058}"
            current_path_28058="${ret_normalize_path2246_v0}"
        elif [ "$([ "_${file_type_28233}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_28238="${targets_28072[${selected_idx_28229}]?"Index out of bounds (at src/./file/./mod.ab:116:40)"}"
            local target_path_28239="${target_28238}"
            starts_with__22_v0 "${target_28238}" "/"
            local ret_starts_with22_v0__118_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__118_24 ))" != 0 ]; then
                path_join__2247_v0 "${current_path_28058}" "${target_28238}"
                target_path_28239="${ret_path_join2247_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_28239}"
            local ret_dir_exists38_v0__122_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__122_20}" != 0 ]; then
                current_path_28058="${target_path_28239}"
                normalize_path__2246_v0 "${current_path_28058}"
                current_path_28058="${ret_normalize_path2246_v0}"
            else
                stty_unlock__2267_v0 
                path_join__2247_v0 "${current_path_28058}" "${name_28232}"
                ret_xyl_file2667_v0="${ret_path_join2247_v0}"
                return 0
            fi
        else
            stty_unlock__2267_v0 
            path_join__2247_v0 "${current_path_28058}" "${name_28232}"
            ret_xyl_file2667_v0="${ret_path_join2247_v0}"
            return 0
        fi
    done
    stty_unlock__2267_v0 
    ret_xyl_file2667_v0=""
    return 0
}

# print_file_help()
print_file_help__2761_v0() {
    local usage_27975=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2236_v0 usage_27975[@]
    printf '%s\n' ""
    colored_primary__2289_v0 "file"
    local ret_colored_primary2289_v0__8_20="${ret_colored_primary2289_v0}"
    local title_28012=("${ret_colored_primary2289_v0__8_20}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2236_v0 title_28012[@]
    printf '%s\n' ""
    colored_secondary__2290_v0 "Arguments:"
    local ret_colored_secondary2290_v0__11_12="${ret_colored_secondary2290_v0}"
    local array_578=()
    printf__128_v0 "${ret_colored_secondary2290_v0__11_12}""
" array_578[@]
    local arg_names_28014=("[<path>]")
    local arg_texts_28015=("Starting directory path")
    local arg_notes_28016=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2235_v0 arg_names_28014[@] arg_texts_28015[@] arg_notes_28016[@] 20
    printf '%s\n' ""
    colored_secondary__2290_v0 "Flags:"
    local ret_colored_secondary2290_v0__18_12="${ret_colored_secondary2290_v0}"
    local array_582=()
    printf__128_v0 "${ret_colored_secondary2290_v0__18_12}""
" array_582[@]
    local names_28044=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_28045=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_28046=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2235_v0 names_28044[@] texts_28045[@] notes_28046[@] 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2813_v0() {
    local parameters_27969=("${!1}")
    local cursor_27970="> "
    local start_path_27971=""
    local show_hidden_27972=0
    local page_size_27973=10
    local __length_589=("${parameters_27969[@]}")
    local slice_upper_588="${#__length_589[@]}"
    local slice_offset_590=2
    local slice_offset_590=$((${slice_offset_590} > 0 ? ${slice_offset_590} : 0))
    local slice_length_591="$(( slice_upper_588 - slice_offset_590 ))"
    local slice_length_591=$((${slice_length_591} > 0 ? ${slice_length_591} : 0))
    for param_27974 in "${parameters_27969[@]:${slice_offset_590}:${slice_length_591}}"; do
        starts_with__22_v0 "${param_27974}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27974}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_27974}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_27974}" != "_-h" ]; echo $?) || $([ "_${param_27974}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2761_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_592="--cursor="
            slice__24_v0 "${param_27974}" "${#__length_592}" 0
            cursor_27970="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_593="--path="
            slice__24_v0 "${param_27974}" "${#__length_593}" 0
            start_path_27971="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_27974}" != "_-a" ]; echo $?) || $([ "_${param_27974}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_27972=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_594="--page-size="
            slice__24_v0 "${param_27974}" "${#__length_594}" 0
            local value_28047="${ret_slice24_v0}"
            parse_int__13_v0 "${value_28047}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2141_v0 "ERROR: Invalid page-size value: ""${value_28047}""
" 31
                exit 1
            fi
            page_size_27973="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_27971="${param_27974}"
        fi
    done
    xyl_file__2667_v0 "${start_path_27971}" "${cursor_27970}" "${show_hidden_27972}" "${page_size_27973}"
    ret_execute_file2813_v0="${ret_xyl_file2667_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_143="0.1.0"
__AMBER_VERSION_144="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2815_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__162_v0 "Error: " 91
        local array_595=("")
        eprintf__161_v0 "bc is not installed. Please install bc to use xylitol.
" array_595[@]
        local array_596=("")
        eprintf__161_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_596[@]
        local array_597=("")
        eprintf__161_v0 "  For Fedora: sudo dnf install bc
" array_597[@]
        local array_598=("")
        eprintf__161_v0 "  For Arch Linux: sudo pacman -S bc
" array_598[@]
        ret_check_prerequirements2815_v0=0
        return 0
    fi
    ret_check_prerequirements2815_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2816_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_145=("$0" "$@")
trap_cleanup__2816_v0 
check_prerequirements__2815_v0 
ret_check_prerequirements2815_v0__32_12="${ret_check_prerequirements2815_v0}"
if [ "$(( ! ret_check_prerequirements2815_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_600=("${args_145[@]}")
if [ "$(( ${#__length_600[@]} < 2 ))" != 0 ]; then
    print_help__480_v0 
    exit 0
fi
command_1445="${args_145[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1445}" != "_help" ]; echo $?) || $([ "_${command_1445}" != "_--help" ]; echo $?) )) || $([ "_${command_1445}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__480_v0 
elif [ "$([ "_${command_1445}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__945_v0 args_145[@]
    ret_execute_input945_v0__48_18="${ret_execute_input945_v0}"
    printf '%s\n' "${ret_execute_input945_v0__48_18}"
elif [ "$([ "_${command_1445}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1523_v0 args_145[@]
    ret_execute_choose1523_v0__51_18="${ret_execute_choose1523_v0}"
    printf '%s\n' "${ret_execute_choose1523_v0__51_18}"
elif [ "$([ "_${command_1445}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__2022_v0 args_145[@]
    result_18617="${ret_execute_confirm2022_v0}"
    if [ "$([ "_${result_18617}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1445}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2813_v0 args_145[@]
    ret_execute_file2813_v0__61_18="${ret_execute_file2813_v0}"
    printf '%s\n' "${ret_execute_file2813_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1445}" != "_version" ]; echo $?) || $([ "_${command_1445}" != "_--version" ]; echo $?) )) || $([ "_${command_1445}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__310_v0 "xylitol.sh"
    ret_colored_primary310_v0__64_20="${ret_colored_primary310_v0}"
    array_601=()
    printf__128_v0 "${ret_colored_primary310_v0__64_20}" array_601[@]
    array_602=()
    printf__128_v0 " version: " array_602[@]
    colored_accent__312_v0 "${__VERSION_143}"
    ret_colored_accent312_v0__66_20="${ret_colored_accent312_v0}"
    array_603=()
    printf__128_v0 "${ret_colored_accent312_v0__66_20}" array_603[@]
    printf '%s\n' ""
    printf_colored__160_v0 "written in Amber: " 90
    printf_colored__160_v0 "  ""${__AMBER_VERSION_144}" 90
else
    print_help__480_v0 
    printf_colored__160_v0 "ERROR: Unknown command '""${command_1445}""'" 91
fi
