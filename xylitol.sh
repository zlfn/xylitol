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
    local text_1319="${1}"
    local delimiter_1320="${2}"
    local result_1321=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1320}" read -rd '' -A result_1321 < <(printf %s "$text_1319")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_1320}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_1321+=("$REPLY"); done < <(echo "$text_1319")
            __status=$?
        else
            IFS="${delimiter_1320}" read -rd '' -a result_1321 < <(printf %s "$text_1319")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_1320}" read -rd '' -a result_1321 < <(printf %s "$text_1319")
        __status=$?
    fi
    ret_split4_v0=("${result_1321[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_14793=("${!1}")
    local delimiter_14794="${2}"
    local command_1
    command_1="$(IFS="${delimiter_14794}" ; printf "%s
" "${list_14793[*]}")"
    __status=$?
    ret_join7_v0="${command_1}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_1323="${1}"
    [ -n "${text_1323}" ] && [ "${text_1323}" -eq "${text_1323}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_1323}"
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_2706="${1}"
    local prefix_2707="${2}"
    [[ "${text_2706}" == "${prefix_2707}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_1400="${1}"
    local index_1401="${2}"
    local length_1402="${3}"
    local result_1403=""
    if [ "$(( length_1402 == 0 ))" != 0 ]; then
        local __length_2="${text_1400}"
        length_1402="$(( ${#__length_2} - index_1401 ))"
    fi
    if [ "$(( length_1402 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_1403}"
        return 0
    fi
    result_1403="${text_1400: ${index_1401}: ${length_1402}}"
    __status=$?
    ret_slice24_v0="${result_1403}"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_16637="${1}"
    local pad_16638="${2}"
    local length_16639="${3}"
    local __length_3="${text_16637}"
    if [ "$(( length_16639 <= ${#__length_3} ))" != 0 ]; then
        ret_lpad27_v0="${text_16637}"
        return 0
    fi
    local __length_4="${text_16637}"
    local pad_len_16640="$(( length_16639 - ${#__length_4} ))"
    local padding_16641=""
    printf -v padding_16641 "%${pad_len_16640}s" ""
    __status=$?
    padding_16641="${padding_16641// /${pad_16638}}"
    __status=$?
    ret_lpad27_v0="${padding_16641}""${text_16637}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_1380="${1}"
    local pad_1381="${2}"
    local length_1382="${3}"
    local __length_5="${text_1380}"
    if [ "$(( length_1382 <= ${#__length_5} ))" != 0 ]; then
        ret_rpad28_v0="${text_1380}"
        return 0
    fi
    local __length_6="${text_1380}"
    local pad_len_1383="$(( length_1382 - ${#__length_6} ))"
    local padding_1384=""
    printf -v padding_1384 "%${pad_len_1383}s" ""
    __status=$?
    padding_1384="${padding_1384// /${pad_1381}}"
    __status=$?
    ret_rpad28_v0="${text_1380}""${padding_1384}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_16631="${1}"
    local pad_16632="${2}"
    local length_16633="${3}"
    local __length_7="${text_16631}"
    local text_length_16634="${#__length_7}"
    if [ "$(( length_16633 <= text_length_16634 ))" != 0 ]; then
        ret_cpad29_v0="${text_16631}"
        return 0
    fi
    local total_padding_16635="$(( length_16633 - text_length_16634 ))"
    local left_padding_length_16636="$(( text_length_16634 + $(( total_padding_16635 / 2 )) ))"
    lpad__27_v0 "${text_16631}" "${pad_16632}" "${left_padding_length_16636}"
    local left_padded_16642="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_16642}" "${pad_16632}" "${length_16633}"
    local center_padded_16643="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_16643}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_25290="${1}"
    [ -d "${path_25290}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_1344="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_8
        command_8="$(printf "%s
" "${!name_1344}")"
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
" "${(P)name_1344}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_9}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_10
        command_10="$(eval "echo \${$name_1344}")"
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
    local format_1341="${1}"
    local args_1342=("${!2}")
    args_1342=("${format_1341}" "${args_1342[@]}")
    __status=$?
    printf "${args_1342[@]}"
    __status=$?
}

# printf(format: Text, args: [Text])
printf__128_v1() {
    local format_1354="${1}"
    local args_1355=("${!2}")
    args_1355=("${format_1354}" "${args_1355[@]}")
    __status=$?
    printf "${args_1355[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_1351="${1}"
    local color_1352="${2}"
    local color_code_1353=0
        color_code_1353="${color_1352}"
    local array_11=("${message_1351}")
    printf__128_v1 "\\x1b[${color_code_1353}m%s\\x1b[0m
" array_11[@]
}

# Perl Extensions Utilities
command_12="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_3="$([ "_${command_12}" != "_No" ]; echo $?)"
command_13="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_4="$(( $(( ! _perl_disabled_3 )) && $([ "_${command_13}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__210_v0() {
    local text_1338="${1}"
    if [ "$(( ! _perl_available_4 ))" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return 1
    fi
    local command_14
    command_14="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_1338}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return "${__status}"
    fi
    local width_str_1339="${command_14}"
    parse_int__13_v0 "${width_str_1339}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width210_v0=''
        return "${__status}"
    fi
    local width_1340="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width210_v0="${width_1340}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_5=0
_term_size_6=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# store_term_size(size: Text)
store_term_size__221_v0() {
    local size_1318="${1}"
    if [ "$([ "_${size_1318}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size221_v0=0
        return 0
    fi
    split__4_v0 "${size_1318}" " "
    local parts_1322=("${ret_split4_v0[@]}")
    local __length_16=("${parts_1322[@]}")
    if [ "$(( ${#__length_16[@]} != 2 ))" != 0 ]; then
        ret_store_term_size221_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_1322[1]?"Index out of bounds (at src/utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_1322[0]?"Index out of bounds (at src/utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_6=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size221_v0=1
    return 0
}

# query_term_size()
query_term_size__222_v0() {
    local command_18
    command_18="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_1325="${command_18}"
    store_term_size__221_v0 "${size_1325}"
    ret_query_term_size222_v0="${ret_store_term_size221_v0}"
    return 0
}

# stty_term_size()
stty_term_size__223_v0() {
    local command_19
    command_19="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_1317="${command_19}"
    store_term_size__221_v0 "${size_1317}"
    ret_stty_term_size223_v0="${ret_store_term_size221_v0}"
    return 0
}

# get_term_size()
get_term_size__224_v0() {
    stty_term_size__223_v0 
    local detected_1324="${ret_stty_term_size223_v0}"
    if [ "$(( ! detected_1324 ))" != 0 ]; then
        query_term_size__222_v0 
        detected_1324="${ret_query_term_size222_v0}"
    fi
    _got_term_size_5=1
}

# term_width()
term_width__226_v0() {
    if [ "$(( ! _got_term_size_5 ))" != 0 ]; then
        get_term_size__224_v0 
    fi
    ret_term_width226_v0="${_term_size_6[0]?"Index out of bounds (at src/utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_7="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_8=0
_primary_color_9=(3 207 159 92)
_secondary_color_10=(3 118 206 94)
_accent_color_11=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__237_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_1361="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_1361}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor237_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor237_v0=0
        return 0
    fi
    local colorterm_1362="${ret_env_var_get120_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_1362}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_1362}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor237_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__238_v0() {
    local message_1356="${1}"
    local r_1357="${2}"
    local g_1358="${3}"
    local b_1359="${4}"
    local fallback_1360="${5}"
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb238_v0="\\x1b[38;2;${r_1357};${g_1358};${b_1359}m""${message_1356}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__237_v0 
        local ret_get_supports_truecolor237_v0__50_17="${ret_get_supports_truecolor237_v0}"
        if [ "${ret_get_supports_truecolor237_v0__50_17}" != 0 ]; then
            ret_colored_rgb238_v0="\\x1b[38;2;${r_1357};${g_1358};${b_1359}m""${message_1356}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_1360 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_1356}"
            return 0
        else
            ret_colored_rgb238_v0="\\x1b[${fallback_1360}m""${message_1356}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_1360 == 0 ))" != 0 ]; then
            ret_colored_rgb238_v0="${message_1356}"
            return 0
        fi
        ret_colored_rgb238_v0="\\x1b[${fallback_1360}m""${message_1356}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__240_v0() {
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_1345="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_1345}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_1345}" ";"
            local parts_1346=("${ret_split4_v0[@]}")
            local __length_23=("${parts_1346[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1346[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1346[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1346[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1346[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_9=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_1347="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_1347}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_1347}" ";"
            local parts_1348=("${ret_split4_v0[@]}")
            local __length_25=("${parts_1348[@]}")
            if [ "$(( ${#__length_25[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1348[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1348[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1348[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1348[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_10=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_1349="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_1349}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_1349}" ";"
            local parts_1350=("${ret_split4_v0[@]}")
            local __length_27=("${parts_1350[@]}")
            if [ "$(( ${#__length_27[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_1350[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1350[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1350[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_1350[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors240_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_11=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_8=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__241_v0() {
    inner_get_xylitol_colors__240_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_8=1
}

# colored_primary(message: Text)
colored_primary__242_v0() {
    local message_1343="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1343}" "${_primary_color_9[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_9[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_9[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_9[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary242_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__243_v0() {
    local message_1364="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1364}" "${_secondary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary243_v0="${ret_colored_rgb238_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__244_v0() {
    local message_1410="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__241_v0 
    fi
    colored_rgb__238_v0 "${message_1410}" "${_accent_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent244_v0="${ret_colored_rgb238_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__259_v0() {
    local message_25293="${1}"
    local color_25294="${2}"
    # Prints a text with a specified color.
    local array_29=("${message_25293}")
    printf__128_v1 "\\x1b[${color_25294}m%s\\x1b[0m" array_29[@]
}

# eprintf(format: Text, args: [Text])
eprintf__260_v0() {
    local format_126="${1}"
    local args_127=("${!2}")
    args_127=("${format_126}" "${args_127[@]}")
    __status=$?
    printf "${args_127[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__261_v0() {
    local message_124="${1}"
    local color_125="${2}"
    # Prints an error message with a specified color.
    local array_30=("${message_124}")
    eprintf__260_v0 "\\x1b[${color_125}m%s\\x1b[0m" array_30[@]
}

# colored(message: Text, color: Int)
colored__262_v0() {
    local message_1398="${1}"
    local color_1399="${2}"
    # Returns a text wrapped in color codes.
    ret_colored262_v0="\\x1b[${color_1399}m""${message_1398}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__273_v0() {
    local text_1331="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_31
    command_31="$([[ "${text_1331}" == *$'\x1b'* || "${text_1331}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_1332="${command_31}"
    ret_has_ansi_escape273_v0="$([ "_${has_escape_1332}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__275_v0() {
    local text_1334="${1}"
    local command_32
    command_32="$(printf "%s" "${text_1334}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi275_v0="${command_32}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__276_v0() {
    local text_1336="${1}"
    local command_33
    command_33="$(printf "%s" "${text_1336}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_1337="${command_33}"
    ret_is_all_ascii276_v0="$([ "_${result_1337}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__277_v0() {
    local text_1333="${1}"
    strip_ansi__275_v0 "${text_1333}"
    local stripped_1335="${ret_strip_ansi275_v0}"
    # Check if text is all ASCII
    is_all_ascii__276_v0 "${stripped_1335}"
    local ret_is_all_ascii276_v0__150_12="${ret_is_all_ascii276_v0}"
    if [ "$(( ! ret_is_all_ascii276_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__210_v0 "${stripped_1335}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_34="${stripped_1335}"
            ret_get_visible_len277_v0="${#__length_34}"
            return 0
        fi
        ret_get_visible_len277_v0="${ret_perl_get_cjk_width210_v0}"
        return 0
    else
        local __length_35="${stripped_1335}"
        ret_get_visible_len277_v0="${#__length_35}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__282_v0() {
    local pending_1395="${1}"
    local line_1396="${2}"
    local note_at_1397="${3}"
    if [ "$(( note_at_1397 < 0 ))" != 0 ]; then
        local array_36=()
        printf__128_v0 "${pending_1395}""${line_1396}""
" array_36[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_1397 == 0 ))" != 0 ]; then
        colored__262_v0 "${line_1396}" 90
        local ret_colored262_v0__310_40="${ret_colored262_v0}"
        local array_37=()
        printf__128_v0 "${pending_1395}""${ret_colored262_v0__310_40}""
" array_37[@]
    else
        slice__24_v0 "${line_1396}" 0 "${note_at_1397}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_1396}" "${note_at_1397}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__262_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored262_v0__311_58="${ret_colored262_v0}"
        local array_38=()
        printf__128_v0 "${pending_1395}""${ret_slice24_v0__311_32}""${ret_colored262_v0__311_58}""
" array_38[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__283_v0() {
    local -n names_1368="${1}"
    local -n texts_1369="${2}"
    local -n notes_1370="${3}"
    local min_name_width_1371="${4}"
    local __length_39=("${names_1368[@]}")
    local count_1372="${#__length_39[@]}"
    local name_width_1373="${min_name_width_1371}"
    local __range_start_1374=0
    local __range_end_1374="${count_1372}"
    local __dir_1374=$(( ${__range_start_1374} <= ${__range_end_1374} ? 1 : -1 ))
    for (( i_1374=${__range_start_1374}; i_1374 * ${__dir_1374} < ${__range_end_1374} * ${__dir_1374}; i_1374+=${__dir_1374} )); do
        local __length_40="${names_1368[${i_1374}]?"Index out of bounds (at src/./utils.ab:326:33)"}"
        local width_1375="${#__length_40}"
        if [ "$(( width_1375 > name_width_1373 ))" != 0 ]; then
            name_width_1373="${width_1375}"
        fi
done
    term_width__226_v0 
    local width_1376="${ret_term_width226_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_1377="$(( name_width_1373 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_1378="$(( $(( width_1376 - indent_1377 )) < 24 ))"
    if [ "${stacked_1378}" != 0 ]; then
        indent_1377=6
    fi
    local avail_1379="$(( width_1376 - indent_1377 ))"
    rpad__28_v0 "" " " "${indent_1377}"
    local blank_1385="${ret_rpad28_v0}"
    local __range_start_1386=0
    local __range_end_1386="${count_1372}"
    local __dir_1386=$(( ${__range_start_1386} <= ${__range_end_1386} ? 1 : -1 ))
    for (( i_1386=${__range_start_1386}; i_1386 * ${__dir_1386} < ${__range_end_1386} * ${__dir_1386}; i_1386+=${__dir_1386} )); do
        local pending_1387="${blank_1385}"
        if [ "${stacked_1378}" != 0 ]; then
            local array_41=()
            printf__128_v0 "  ""${names_1368[${i_1386}]?"Index out of bounds (at src/./utils.ab:346:33)"}""
" array_41[@]
        else
            rpad__28_v0 "  ""${names_1368[${i_1386}]?"Index out of bounds (at src/./utils.ab:348:41)"}" " " "${indent_1377}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_1387="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_1369[${i_1386}]?"Index out of bounds (at src/./utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_1388=("${ret_split4_v0__350_21[@]}")
        local __length_42=("${words_1388[@]}")
        local note_start_1389="${#__length_42[@]}"
        if [ "$([ "_${notes_1370[${i_1386}]?"Index out of bounds (at src/./utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_43="${notes_1370[${i_1386}]?"Index out of bounds (at src/./utils.ab:355:26)"}"
            if [ "$(( ${#__length_43} > avail_1379 ))" != 0 ]; then
                split__4_v0 "${notes_1370[${i_1386}]?"Index out of bounds (at src/./utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_1388+=("${ret_split4_v0__356_26[@]}")
            else
                local array_44=("${notes_1370[${i_1386}]?"Index out of bounds (at src/./utils.ab:358:33)"}")
                words_1388+=("${array_44[@]}")
            fi
        fi
        local line_1390=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_1391=-1
        local __range_start_1392=0
        local __length_45=("${words_1388[@]}")
        local __range_end_1392="${#__length_45[@]}"
        local __dir_1392=$(( ${__range_start_1392} <= ${__range_end_1392} ? 1 : -1 ))
        for (( j_1392=${__range_start_1392}; j_1392 * ${__dir_1392} < ${__range_end_1392} * ${__dir_1392}; j_1392+=${__dir_1392} )); do
            local word_1393="${words_1388[${j_1392}]?"Index out of bounds (at src/./utils.ab:368:32)"}"
            local candidate_1394
            candidate_1394="$(if [ "$([ "_${line_1390}" != "_" ]; echo $?)" != 0 ]; then echo "${word_1393}"; else echo "${line_1390}"" ""${word_1393}"; fi)"
            local __length_46="${candidate_1394}"
            if [ "$(( $(( ${#__length_46} > avail_1379 )) && $([ "_${line_1390}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__282_v0 "${pending_1387}" "${line_1390}" "${note_at_1391}"
                pending_1387="${blank_1385}"
                line_1390="${word_1393}"
                note_at_1391="$(if [ "$(( j_1392 >= note_start_1389 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_1392 >= note_start_1389 )) && $(( note_at_1391 < 0 )) ))" != 0 ]; then
                    local __length_47="${candidate_1394}"
                    local __length_48="${word_1393}"
                    note_at_1391="$(( ${#__length_47} - ${#__length_48} ))"
                fi
                line_1390="${candidate_1394}"
            fi
done
        print_help_line__282_v0 "${pending_1387}" "${line_1390}" "${note_at_1391}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__284_v0() {
    local -n pieces_1316="${1}"
    term_width__226_v0 
    local width_1326="${ret_term_width226_v0}"
    local line_1327=""
    local line_len_1328=0
    for piece_1329 in "${pieces_1316[@]}"; do
        local __length_51="${piece_1329}"
        local piece_len_1330="${#__length_51}"
        has_ansi_escape__273_v0 "${piece_1329}"
        local ret_has_ansi_escape273_v0__397_12="${ret_has_ansi_escape273_v0}"
        if [ "${ret_has_ansi_escape273_v0__397_12}" != 0 ]; then
            get_visible_len__277_v0 "${piece_1329}"
            piece_len_1330="${ret_get_visible_len277_v0}"
        fi
        if [ "$([ "_${line_1327}" != "_" ]; echo $?)" != 0 ]; then
            line_1327="${piece_1329}"
            line_len_1328="${piece_len_1330}"
        elif [ "$(( $(( $(( line_len_1328 + 1 )) + piece_len_1330 )) > width_1326 ))" != 0 ]; then
            local array_52=()
            printf__128_v0 "${line_1327}""
" array_52[@]
            line_1327="${piece_1329}"
            line_len_1328="${piece_len_1330}"
        else
            line_1327+=" ""${piece_1329}"
            line_len_1328="$(( line_len_1328 + $(( 1 + piece_len_1330 )) ))"
        fi
    done
    if [ "$([ "_${line_1327}" == "_" ]; echo $?)" != 0 ]; then
        local array_53=()
        printf__128_v0 "${line_1327}""
" array_53[@]
    fi
}

# print_help()
print_help__428_v0() {
    local usage_1315=("Usage:" "./xylitol.sh" "<command>" "[flags]")
    print_wrapped__284_v0 "usage_1315"
    printf '%s\n' ""
    colored_primary__242_v0 "Xylitol"
    local ret_colored_primary242_v0__9_21="${ret_colored_primary242_v0}"
    colored_primary__242_v0 "fresh"
    local ret_colored_primary242_v0__10_34="${ret_colored_primary242_v0}"
    local title_1363=("\\x1b[1m""${ret_colored_primary242_v0__9_21}" "-" "A" "tool" "for" "${ret_colored_primary242_v0__10_34}" "shell" "scripts.")
    print_wrapped__284_v0 "title_1363"
    printf '%s\n' ""
    colored_secondary__243_v0 "Flags:"
    local ret_colored_secondary243_v0__14_12="${ret_colored_secondary243_v0}"
    local array_56=()
    printf__128_v0 "${ret_colored_secondary243_v0__14_12}""
" array_56[@]
    local flag_names_1365=("-h, --help" "-v, --version")
    local flag_texts_1366=("Show this help message" "Show version information")
    local flag_notes_1367=("" "")
    # 13 keeps this section on the same column as Commands below.
    render_help_entries__283_v0 "flag_names_1365" "flag_texts_1366" "flag_notes_1367" 13
    printf '%s\n' ""
    colored_secondary__243_v0 "Commands:"
    local ret_colored_secondary243_v0__21_12="${ret_colored_secondary243_v0}"
    local array_60=()
    printf__128_v0 "${ret_colored_secondary243_v0__21_12}""
" array_60[@]
    local cmd_names_1404=("input" "choose" "confirm" "file")
    local cmd_texts_1405=("Prompt for some input" "Choose from a list of options" "Prompt for a yes/no confirmation" "Browse filesystem and select a file")
    local cmd_notes_1406=("" "" "" "")
    render_help_entries__283_v0 "cmd_names_1404" "cmd_texts_1405" "cmd_notes_1406" 13
    printf '%s\n' ""
    colored_secondary__243_v0 "Envs:"
    local ret_colored_secondary243_v0__32_12="${ret_colored_secondary243_v0}"
    local array_64=()
    printf__128_v0 "${ret_colored_secondary243_v0__32_12}""
" array_64[@]
    local env_names_1407=("\$XYLITOL_USE_PERL" "\$XYLITOL_TRUECOLOR" "\$XYLITOL_PRIMARY_COLOR" "\$XYLITOL_SECONDARY_COLOR" "\$XYLITOL_ACCENT_COLOR")
    local env_texts_1408=("Use Perl for CJK / Optimization" "Enable 24-bit truecolor support" "Set the primary color" "Set the secondary color" "Set the accent color")
    local env_notes_1409=("(\"Yes\" or \"No\", default: Yes)" "(\"Yes\" or \"No\", default: Yes)" "(default: 3;207;159;92)" "(default: 3;118;206;94)" "(default: 234;72;121;95)")
    render_help_entries__283_v0 "env_names_1407" "env_texts_1408" "env_notes_1409" 0
    printf '%s\n' ""
    colored_accent__244_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent244_v0__57_16="${ret_colored_accent244_v0}"
    local footer_1411=("Run" "${ret_colored_accent244_v0__57_16}" "for" "more" "information" "on" "a" "command.")
    print_wrapped__284_v0 "footer_1411"
}

# math_floor(number: Int)
math_floor__509_v0() {
    local number_2770="${1}"
    local command_69
    command_69="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_2770}")"
    __status=$?
    ret_math_floor509_v0="${command_69}"
    return 0
}

# math_ceil(number: Int)
math_ceil__510_v0() {
    local number_2769="${1}"
    math_floor__509_v0 "${number_2769}"
    local ret_math_floor509_v0__52_12="${ret_math_floor509_v0}"
    ret_math_ceil510_v0="$(( ret_math_floor509_v0__52_12 + 1 ))"
    return 0
}

# Perl Extensions Utilities
command_70="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_12="$([ "_${command_70}" != "_No" ]; echo $?)"
command_71="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_13="$(( $(( ! _perl_disabled_12 )) && $([ "_${command_71}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__570_v0() {
    local text_2657="${1}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return 1
    fi
    local command_72
    command_72="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2657}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return "${__status}"
    fi
    local width_str_2658="${command_72}"
    parse_int__13_v0 "${width_str_2658}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width570_v0=''
        return "${__status}"
    fi
    local width_2659="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width570_v0="${width_2659}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__571_v0() {
    local text_2725="${1}"
    local max_width_2726="${2}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_truncate_cjk571_v0=''
        return 1
    fi
    local command_73
    command_73="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_2725}" ${max_width_2726} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk571_v0=''
        return "${__status}"
    fi
    local result_2727="${command_73}"
    ret_perl_truncate_cjk571_v0="${result_2727}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_14=0
_term_size_15=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__578_v0() {
    local command_75
    command_75="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_2714="${command_75}"
    parse_int__13_v0 "${count_2714}"
    __status=$?
    ret_stty_count578_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__579_v0() {
    stty_count__578_v0 
    local count_num_2715="${ret_stty_count578_v0}"
    if [ "$(( count_num_2715 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2715="$(( count_num_2715 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2715}
    __status=$?
}

# stty_unlock()
stty_unlock__580_v0() {
    stty_count__578_v0 
    local count_num_2767="${ret_stty_count578_v0}"
    if [ "$(( count_num_2767 > 0 ))" != 0 ]; then
        count_num_2767="$(( count_num_2767 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2767}
        __status=$?
        if [ "$(( count_num_2767 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__581_v0() {
    local size_2641="${1}"
    if [ "$([ "_${size_2641}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size581_v0=0
        return 0
    fi
    split__4_v0 "${size_2641}" " "
    local parts_2642=("${ret_split4_v0[@]}")
    local __length_76=("${parts_2642[@]}")
    if [ "$(( ${#__length_76[@]} != 2 ))" != 0 ]; then
        ret_store_term_size581_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_2642[1]?"Index out of bounds (at src/./input/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_2642[0]?"Index out of bounds (at src/./input/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_15=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size581_v0=1
    return 0
}

# query_term_size()
query_term_size__582_v0() {
    local command_78
    command_78="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_2644="${command_78}"
    store_term_size__581_v0 "${size_2644}"
    ret_query_term_size582_v0="${ret_store_term_size581_v0}"
    return 0
}

# stty_term_size()
stty_term_size__583_v0() {
    local command_79
    command_79="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_2640="${command_79}"
    store_term_size__581_v0 "${size_2640}"
    ret_stty_term_size583_v0="${ret_store_term_size581_v0}"
    return 0
}

# get_term_size()
get_term_size__584_v0() {
    stty_term_size__583_v0 
    local detected_2643="${ret_stty_term_size583_v0}"
    if [ "$(( ! detected_2643 ))" != 0 ]; then
        query_term_size__582_v0 
        detected_2643="${ret_query_term_size582_v0}"
    fi
    _got_term_size_14=1
}

# term_width()
term_width__586_v0() {
    if [ "$(( ! _got_term_size_14 ))" != 0 ]; then
        get_term_size__584_v0 
    fi
    ret_term_width586_v0="${_term_size_15[0]?"Index out of bounds (at src/./input/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_16="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_17=0
_primary_color_18=(3 207 159 92)
_secondary_color_19=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__597_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_2672="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_2672}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor597_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor597_v0=0
        return 0
    fi
    local colorterm_2673="${ret_env_var_get120_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_2673}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_2673}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor597_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__598_v0() {
    local message_2667="${1}"
    local r_2668="${2}"
    local g_2669="${3}"
    local b_2670="${4}"
    local fallback_2671="${5}"
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb598_v0="\\x1b[38;2;${r_2668};${g_2669};${b_2670}m""${message_2667}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__597_v0 
        local ret_get_supports_truecolor597_v0__50_17="${ret_get_supports_truecolor597_v0}"
        if [ "${ret_get_supports_truecolor597_v0__50_17}" != 0 ]; then
            ret_colored_rgb598_v0="\\x1b[38;2;${r_2668};${g_2669};${b_2670}m""${message_2667}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2671 == 0 ))" != 0 ]; then
            ret_colored_rgb598_v0="${message_2667}"
            return 0
        else
            ret_colored_rgb598_v0="\\x1b[${fallback_2671}m""${message_2667}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2671 == 0 ))" != 0 ]; then
            ret_colored_rgb598_v0="${message_2667}"
            return 0
        fi
        ret_colored_rgb598_v0="\\x1b[${fallback_2671}m""${message_2667}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__600_v0() {
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_2661="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2661}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2661}" ";"
            local parts_2662=("${ret_split4_v0[@]}")
            local __length_83=("${parts_2662[@]}")
            if [ "$(( ${#__length_83[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2662[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2662[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2662[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2662[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_18=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_2663="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2663}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2663}" ";"
            local parts_2664=("${ret_split4_v0[@]}")
            local __length_85=("${parts_2664[@]}")
            if [ "$(( ${#__length_85[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2664[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2664[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2664[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2664[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_19=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_2665="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2665}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2665}" ";"
            local parts_2666=("${ret_split4_v0[@]}")
            local __length_87=("${parts_2666[@]}")
            if [ "$(( ${#__length_87[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2666[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2666[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2666[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2666[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors600_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__601_v0() {
    inner_get_xylitol_colors__600_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

# colored_primary(message: Text)
colored_primary__602_v0() {
    local message_2660="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__601_v0 
    fi
    colored_rgb__598_v0 "${message_2660}" "${_primary_color_18[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_18[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_18[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_18[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary602_v0="${ret_colored_rgb598_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__603_v0() {
    local message_2675="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__601_v0 
    fi
    colored_rgb__598_v0 "${message_2675}" "${_secondary_color_19[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_19[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_19[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_19[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary603_v0="${ret_colored_rgb598_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__617_v0() {
    local command_89
    command_89="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_2763="${command_89}"
    ret_get_char617_v0="${char_2763}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__620_v0() {
    local format_2743="${1}"
    local args_2744=("${!2}")
    args_2744=("${format_2743}" "${args_2744[@]}")
    __status=$?
    printf "${args_2744[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__621_v0() {
    local message_2753="${1}"
    local color_2754="${2}"
    # Prints an error message with a specified color.
    local array_90=("${message_2753}")
    eprintf__620_v0 "\\x1b[${color_2754}m%s\\x1b[0m" array_90[@]
}

# colored(message: Text, color: Int)
colored__622_v0() {
    local message_2704="${1}"
    local color_2705="${2}"
    # Returns a text wrapped in color codes.
    ret_colored622_v0="\\x1b[${color_2705}m""${message_2704}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__623_v0() {
    local cnt_2765="${1}"
    if [ "$(( cnt_2765 > 0 ))" != 0 ]; then
        local array_91=("")
        eprintf__620_v0 "\\x1b[${cnt_2765}D\\x1b[K" array_91[@]
    fi
}

# remove_line(cnt: Int)
remove_line__624_v0() {
    local cnt_2773="${1}"
    if [ "$(( cnt_2773 > 0 ))" != 0 ]; then
        local sequence_2774=""
        local __range_start_2775=0
        local __range_end_2775="${cnt_2773}"
        local __dir_2775=$(( ${__range_start_2775} <= ${__range_end_2775} ? 1 : -1 ))
        for (( ____2775=${__range_start_2775}; ____2775 * ${__dir_2775} < ${__range_end_2775} * ${__dir_2775}; ____2775+=${__dir_2775} )); do
            sequence_2774+="\\x1b[2K\\x1b[1A"
done
        local array_92=("")
        eprintf__620_v0 "${sequence_2774}" array_92[@]
    fi
    local array_93=("")
    eprintf__620_v0 "\\x1b[G" array_93[@]
}

# remove_current_line()
remove_current_line__625_v0() {
    local array_94=("")
    eprintf__620_v0 "\\x1b[2K\\x1b[G" array_94[@]
}

# new_line(cnt: Int)
new_line__627_v0() {
    local cnt_2745="${1}"
    local __range_start_2746=0
    local __range_end_2746="${cnt_2745}"
    local __dir_2746=$(( ${__range_start_2746} <= ${__range_end_2746} ? 1 : -1 ))
    for (( ____2746=${__range_start_2746}; ____2746 * ${__dir_2746} < ${__range_end_2746} * ${__dir_2746}; ____2746+=${__dir_2746} )); do
        local array_95=("")
        eprintf__620_v0 "
" array_95[@]
done
}

# go_up(cnt: Int)
go_up__628_v0() {
    local cnt_2762="${1}"
    local array_96=("")
    eprintf__620_v0 "\\x1b[${cnt_2762}A" array_96[@]
}

# go_down(cnt: Int)
go_down__629_v0() {
    local cnt_2772="${1}"
    local array_97=("")
    eprintf__620_v0 "\\x1b[${cnt_2772}B" array_97[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__633_v0() {
    local text_2650="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_98
    command_98="$([[ "${text_2650}" == *$'\x1b'* || "${text_2650}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2651="${command_98}"
    ret_has_ansi_escape633_v0="$([ "_${has_escape_2651}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__634_v0() {
    local text_2708="${1}"
    local command_99
    command_99="$(printf '%s' "${text_2708}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi634_v0="${command_99}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__635_v0() {
    local text_2653="${1}"
    local command_100
    command_100="$(printf "%s" "${text_2653}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi635_v0="${command_100}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__636_v0() {
    local text_2655="${1}"
    local command_101
    command_101="$(printf "%s" "${text_2655}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2656="${command_101}"
    ret_is_all_ascii636_v0="$([ "_${result_2656}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__637_v0() {
    local text_2652="${1}"
    strip_ansi__635_v0 "${text_2652}"
    local stripped_2654="${ret_strip_ansi635_v0}"
    # Check if text is all ASCII
    is_all_ascii__636_v0 "${stripped_2654}"
    local ret_is_all_ascii636_v0__150_12="${ret_is_all_ascii636_v0}"
    if [ "$(( ! ret_is_all_ascii636_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__570_v0 "${stripped_2654}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_102="${stripped_2654}"
            ret_get_visible_len637_v0="${#__length_102}"
            return 0
        fi
        ret_get_visible_len637_v0="${ret_perl_get_cjk_width570_v0}"
        return 0
    else
        local __length_103="${stripped_2654}"
        ret_get_visible_len637_v0="${#__length_103}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__638_v0() {
    local text_2722="${1}"
    local max_width_2723="${2}"
    get_visible_len__637_v0 "${text_2722}"
    local visible_len_2724="${ret_get_visible_len637_v0}"
    if [ "$(( visible_len_2724 <= max_width_2723 ))" != 0 ]; then
        ret_truncate_text638_v0="${text_2722}"
        return 0
    fi
    is_all_ascii__636_v0 "${text_2722}"
    local ret_is_all_ascii636_v0__167_12="${ret_is_all_ascii636_v0}"
    if [ "$(( ! ret_is_all_ascii636_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__571_v0 "${text_2722}" "${max_width_2723}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_2722}" | cut -c1-${max_width_2723}
            __status=$?
        fi
        ret_truncate_text638_v0="${ret_perl_truncate_cjk571_v0}"
        return 0
    fi
    local command_104
    command_104="$(printf "%s" "${text_2722}" | cut -c1-${max_width_2723})"
    __status=$?
    ret_truncate_text638_v0="${command_104}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__639_v0() {
    local text_2720="${1}"
    local max_width_2721="${2}"
    has_ansi_escape__633_v0 "${text_2720}"
    local ret_has_ansi_escape633_v0__179_12="${ret_has_ansi_escape633_v0}"
    if [ "$(( ! ret_has_ansi_escape633_v0__179_12 ))" != 0 ]; then
        truncate_text__638_v0 "${text_2720}" "${max_width_2721}"
        ret_truncate_ansi639_v0="${ret_truncate_text638_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_105
    command_105="$([[ "${text_2720}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_2728="${command_105}"
    # Replace \x1b[ with newline, then split
    local command_106
    command_106="$(t="${text_2720}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_2729="${command_106}"
    split__4_v0 "${replaced_2729}" "
"
    local parts_2730=("${ret_split4_v0[@]}")
    local result_2731=""
    local remaining_width_2732="${max_width_2721}"
    local __range_start_2733=0
    local __length_107=("${parts_2730[@]}")
    local __range_end_2733="${#__length_107[@]}"
    local __dir_2733=$(( ${__range_start_2733} <= ${__range_end_2733} ? 1 : -1 ))
    for (( idx_2733=${__range_start_2733}; idx_2733 * ${__dir_2733} < ${__range_end_2733} * ${__dir_2733}; idx_2733+=${__dir_2733} )); do
        local part_2734="${parts_2730[${idx_2733}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_2733 == 0 )) && $([ "_${starts_with_ansi_2728}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_2734}" == "_" ]; echo $?) && $(( remaining_width_2732 > 0 )) ))" != 0 ]; then
                truncate_text__638_v0 "${part_2734}" "${remaining_width_2732}"
                local ret_truncate_text638_v0__201_35="${ret_truncate_text638_v0}"
                local truncated_2735="${ret_truncate_text638_v0__201_35}"
                result_2731+="${truncated_2735}"
                get_visible_len__637_v0 "${truncated_2735}"
                local ret_get_visible_len637_v0__203_36="${ret_get_visible_len637_v0}"
                remaining_width_2732="$(( remaining_width_2732 - ret_get_visible_len637_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_108
            command_108="$(__p="${part_2734}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_2736="${command_108}"
            if [ "$([ "_${m_idx_2736}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_109
                command_109="$(__p="${part_2734}"; printf "%s" "${__p:0:${m_idx_2736}}")"
                __status=$?
                local ansi_params_2737="${command_109}"
                result_2731+="\\x1b[""${ansi_params_2737}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_2736}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_2738="${ret_parse_int13_v0__214_41}"
                local text_start_2739="$(( m_idx_num_2738 + 1 ))"
                local command_110
                command_110="$(__p="${part_2734}"; printf "%s" "${__p:${text_start_2739}}")"
                __status=$?
                local text_part_2740="${command_110}"
                if [ "$(( $([ "_${text_part_2740}" == "_" ]; echo $?) && $(( remaining_width_2732 > 0 )) ))" != 0 ]; then
                    truncate_text__638_v0 "${text_part_2740}" "${remaining_width_2732}"
                    local ret_truncate_text638_v0__218_39="${ret_truncate_text638_v0}"
                    local truncated_2741="${ret_truncate_text638_v0__218_39}"
                    result_2731+="${truncated_2741}"
                    get_visible_len__637_v0 "${truncated_2741}"
                    local ret_get_visible_len637_v0__220_40="${ret_get_visible_len637_v0}"
                    remaining_width_2732="$(( remaining_width_2732 - ret_get_visible_len637_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_2734}" == "_" ]; echo $?) && $(( remaining_width_2732 > 0 )) ))" != 0 ]; then
                    truncate_text__638_v0 "${part_2734}" "${remaining_width_2732}"
                    local ret_truncate_text638_v0__225_39="${ret_truncate_text638_v0}"
                    local truncated_2742="${ret_truncate_text638_v0__225_39}"
                    result_2731+="${truncated_2742}"
                    get_visible_len__637_v0 "${truncated_2742}"
                    local ret_get_visible_len637_v0__227_40="${ret_get_visible_len637_v0}"
                    remaining_width_2732="$(( remaining_width_2732 - ret_get_visible_len637_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi639_v0="${result_2731}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__640_v0() {
    local text_2717="${1}"
    local max_width_2718="${2}"
    get_visible_len__637_v0 "${text_2717}"
    local visible_len_2719="${ret_get_visible_len637_v0}"
    if [ "$(( visible_len_2719 <= max_width_2718 ))" != 0 ]; then
        ret_cutoff_text640_v0="${text_2717}"
        return 0
    fi
    truncate_ansi__639_v0 "${text_2717}" "$(( max_width_2718 - 3 ))"
    local ret_truncate_ansi639_v0__243_12="${ret_truncate_ansi639_v0}"
    ret_cutoff_text640_v0="${ret_truncate_ansi639_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__641_v0() {
    local items_2747=("${!1}")
    local total_len_2748="${2}"
    local term_width_2749="${3}"
    local separator_2750=" • "
    local separator_len_2751=3
    # Fast path: no truncation needed
    if [ "$(( total_len_2748 <= term_width_2749 ))" != 0 ]; then
        local iter_2752=0
        while :
        do
            local __length_111=("${items_2747[@]}")
            if [ "$(( iter_2752 >= ${#__length_111[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_2752 > 0 ))" != 0 ]; then
                eprintf_colored__621_v0 "${separator_2750}" 90
            fi
            colored__622_v0 "${items_2747[$(( iter_2752 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored622_v0__268_41="${ret_colored622_v0}"
            local array_112=("")
            eprintf__620_v0 "${items_2747[${iter_2752}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored622_v0__268_41}" array_112[@]
            iter_2752="$(( iter_2752 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_2755=0
        local first_2756=1
        local iter_2757=0
        while :
        do
            local __length_113=("${items_2747[@]}")
            if [ "$(( iter_2757 >= ${#__length_113[@]} ))" != 0 ]; then
                break
            fi
            local key_2758="${items_2747[${iter_2757}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_2759="${items_2747[$(( iter_2757 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_114="${key_2758}"
            local __length_115="${action_2759}"
            local part_len_2760="$(( $(( ${#__length_114} + 1 )) + ${#__length_115} ))"
            local needed_2761="${part_len_2760}"
            if [ "$(( ! first_2756 ))" != 0 ]; then
                needed_2761="$(( needed_2761 + separator_len_2751 ))"
            fi
            if [ "$(( $(( current_len_2755 + needed_2761 )) > term_width_2749 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_2756 ))" != 0 ]; then
                eprintf_colored__621_v0 "${separator_2750}" 90
            fi
            colored__622_v0 "${action_2759}" 2
            local ret_colored622_v0__296_33="${ret_colored622_v0}"
            local array_116=("")
            eprintf__620_v0 "${key_2758}"" ""${ret_colored622_v0__296_33}" array_116[@]
            current_len_2755="$(( current_len_2755 + needed_2761 ))"
            first_2756=0
            iter_2757="$(( iter_2757 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__642_v0() {
    local pending_2701="${1}"
    local line_2702="${2}"
    local note_at_2703="${3}"
    if [ "$(( note_at_2703 < 0 ))" != 0 ]; then
        local array_117=()
        printf__128_v0 "${pending_2701}""${line_2702}""
" array_117[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_2703 == 0 ))" != 0 ]; then
        colored__622_v0 "${line_2702}" 90
        local ret_colored622_v0__310_40="${ret_colored622_v0}"
        local array_118=()
        printf__128_v0 "${pending_2701}""${ret_colored622_v0__310_40}""
" array_118[@]
    else
        slice__24_v0 "${line_2702}" 0 "${note_at_2703}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_2702}" "${note_at_2703}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__622_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored622_v0__311_58="${ret_colored622_v0}"
        local array_119=()
        printf__128_v0 "${pending_2701}""${ret_slice24_v0__311_32}""${ret_colored622_v0__311_58}""
" array_119[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__643_v0() {
    local -n names_2679="${1}"
    local -n texts_2680="${2}"
    local -n notes_2681="${3}"
    local min_name_width_2682="${4}"
    local __length_120=("${names_2679[@]}")
    local count_2683="${#__length_120[@]}"
    local name_width_2684="${min_name_width_2682}"
    local __range_start_2685=0
    local __range_end_2685="${count_2683}"
    local __dir_2685=$(( ${__range_start_2685} <= ${__range_end_2685} ? 1 : -1 ))
    for (( i_2685=${__range_start_2685}; i_2685 * ${__dir_2685} < ${__range_end_2685} * ${__dir_2685}; i_2685+=${__dir_2685} )); do
        local __length_121="${names_2679[${i_2685}]?"Index out of bounds (at src/./input/../utils.ab:326:33)"}"
        local width_2686="${#__length_121}"
        if [ "$(( width_2686 > name_width_2684 ))" != 0 ]; then
            name_width_2684="${width_2686}"
        fi
done
    term_width__586_v0 
    local width_2687="${ret_term_width586_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_2688="$(( name_width_2684 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_2689="$(( $(( width_2687 - indent_2688 )) < 24 ))"
    if [ "${stacked_2689}" != 0 ]; then
        indent_2688=6
    fi
    local avail_2690="$(( width_2687 - indent_2688 ))"
    rpad__28_v0 "" " " "${indent_2688}"
    local blank_2691="${ret_rpad28_v0}"
    local __range_start_2692=0
    local __range_end_2692="${count_2683}"
    local __dir_2692=$(( ${__range_start_2692} <= ${__range_end_2692} ? 1 : -1 ))
    for (( i_2692=${__range_start_2692}; i_2692 * ${__dir_2692} < ${__range_end_2692} * ${__dir_2692}; i_2692+=${__dir_2692} )); do
        local pending_2693="${blank_2691}"
        if [ "${stacked_2689}" != 0 ]; then
            local array_122=()
            printf__128_v0 "  ""${names_2679[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:346:33)"}""
" array_122[@]
        else
            rpad__28_v0 "  ""${names_2679[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:348:41)"}" " " "${indent_2688}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_2693="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_2680[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_2694=("${ret_split4_v0__350_21[@]}")
        local __length_123=("${words_2694[@]}")
        local note_start_2695="${#__length_123[@]}"
        if [ "$([ "_${notes_2681[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_124="${notes_2681[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_124} > avail_2690 ))" != 0 ]; then
                split__4_v0 "${notes_2681[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_2694+=("${ret_split4_v0__356_26[@]}")
            else
                local array_125=("${notes_2681[${i_2692}]?"Index out of bounds (at src/./input/../utils.ab:358:33)"}")
                words_2694+=("${array_125[@]}")
            fi
        fi
        local line_2696=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_2697=-1
        local __range_start_2698=0
        local __length_126=("${words_2694[@]}")
        local __range_end_2698="${#__length_126[@]}"
        local __dir_2698=$(( ${__range_start_2698} <= ${__range_end_2698} ? 1 : -1 ))
        for (( j_2698=${__range_start_2698}; j_2698 * ${__dir_2698} < ${__range_end_2698} * ${__dir_2698}; j_2698+=${__dir_2698} )); do
            local word_2699="${words_2694[${j_2698}]?"Index out of bounds (at src/./input/../utils.ab:368:32)"}"
            local candidate_2700
            candidate_2700="$(if [ "$([ "_${line_2696}" != "_" ]; echo $?)" != 0 ]; then echo "${word_2699}"; else echo "${line_2696}"" ""${word_2699}"; fi)"
            local __length_127="${candidate_2700}"
            if [ "$(( $(( ${#__length_127} > avail_2690 )) && $([ "_${line_2696}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__642_v0 "${pending_2693}" "${line_2696}" "${note_at_2697}"
                pending_2693="${blank_2691}"
                line_2696="${word_2699}"
                note_at_2697="$(if [ "$(( j_2698 >= note_start_2695 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_2698 >= note_start_2695 )) && $(( note_at_2697 < 0 )) ))" != 0 ]; then
                    local __length_128="${candidate_2700}"
                    local __length_129="${word_2699}"
                    note_at_2697="$(( ${#__length_128} - ${#__length_129} ))"
                fi
                line_2696="${candidate_2700}"
            fi
done
        print_help_line__642_v0 "${pending_2693}" "${line_2696}" "${note_at_2697}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__644_v0() {
    local -n pieces_2639="${1}"
    term_width__586_v0 
    local width_2645="${ret_term_width586_v0}"
    local line_2646=""
    local line_len_2647=0
    for piece_2648 in "${pieces_2639[@]}"; do
        local __length_132="${piece_2648}"
        local piece_len_2649="${#__length_132}"
        has_ansi_escape__633_v0 "${piece_2648}"
        local ret_has_ansi_escape633_v0__397_12="${ret_has_ansi_escape633_v0}"
        if [ "${ret_has_ansi_escape633_v0__397_12}" != 0 ]; then
            get_visible_len__637_v0 "${piece_2648}"
            piece_len_2649="${ret_get_visible_len637_v0}"
        fi
        if [ "$([ "_${line_2646}" != "_" ]; echo $?)" != 0 ]; then
            line_2646="${piece_2648}"
            line_len_2647="${piece_len_2649}"
        elif [ "$(( $(( $(( line_len_2647 + 1 )) + piece_len_2649 )) > width_2645 ))" != 0 ]; then
            local array_133=()
            printf__128_v0 "${line_2646}""
" array_133[@]
            line_2646="${piece_2648}"
            line_len_2647="${piece_len_2649}"
        else
            line_2646+=" ""${piece_2648}"
            line_len_2647="$(( line_len_2647 + $(( 1 + piece_len_2649 )) ))"
        fi
    done
    if [ "$([ "_${line_2646}" == "_" ]; echo $?)" != 0 ]; then
        local array_134=()
        printf__128_v0 "${line_2646}""
" array_134[@]
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__695_v0() {
    local prompt_2710="${1}"
    local placeholder_2711="${2}"
    local header_2712="${3}"
    local password_2713="${4}"
    stty_lock__579_v0 
    term_width__586_v0 
    local term_width_2716="${ret_term_width586_v0}"
    if [ "$([ "_${header_2712}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__640_v0 "${header_2712}" "${term_width_2716}"
        local ret_cutoff_text640_v0__23_17="${ret_cutoff_text640_v0}"
        local array_135=("")
        eprintf__620_v0 "${ret_cutoff_text640_v0__23_17}""
" array_135[@]
    fi
    new_line__627_v0 2
    # "enter submit" = 12
    local array_136=("enter" "submit")
    render_tooltip__641_v0 array_136[@] 12 "${term_width_2716}"
    go_up__628_v0 2
    local array_137=("")
    eprintf__620_v0 "\\x1b[G" array_137[@]
    local array_138=("")
    eprintf__620_v0 "${prompt_2710}" array_138[@]
    eprintf_colored__621_v0 "${placeholder_2711}" 90
    get_char__617_v0 
    local char_2764="${ret_get_char617_v0}"
    local __length_139="${prompt_2710}"
    remove__623_v0 "${#__length_139}"
    local __length_140="${placeholder_2711}"
    remove__623_v0 "$(( ${#__length_140} + 1 ))"
    local text_2766=""
    if [ "$(( ! password_2713 ))" != 0 ]; then
        stty_unlock__580_v0 
        local command_141
        command_141="$(read -e -i ${char_2764} -p "${prompt_2710}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_2766="${command_141}"
    else
        stty_unlock__580_v0 
        local command_142
        command_142="$(read -es -i ${char_2764} -p "${prompt_2710}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_2766="${command_142}"
    fi
    stty_lock__579_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__637_v0 "${prompt_2710}""${text_2766}"
    local input_display_len_2768="${ret_get_visible_len637_v0}"
    math_ceil__510_v0 "$(( input_display_len_2768 / term_width_2716 ))"
    local input_lines_2771="${ret_math_ceil510_v0}"
    if [ "$(( input_lines_2771 < 3 ))" != 0 ]; then
        go_down__629_v0 "$(( 2 - input_lines_2771 ))"
        remove_line__624_v0 2
        remove_current_line__625_v0 
    fi
    if [ "$(( input_lines_2771 >= 3 ))" != 0 ]; then
        remove_line__624_v0 "${input_lines_2771}"
    fi
    if [ "$([ "_${header_2712}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__624_v0 1
        remove_current_line__625_v0 
    fi
    stty_unlock__580_v0 
    ret_xyl_input695_v0="${text_2766}"
    return 0
}

# print_input_help()
print_input_help__789_v0() {
    local usage_2638=("Usage:" "./xylitol.sh" "input" "[flags]")
    print_wrapped__644_v0 "usage_2638"
    printf '%s\n' ""
    colored_primary__602_v0 "input"
    local ret_colored_primary602_v0__8_18="${ret_colored_primary602_v0}"
    local title_2674=("${ret_colored_primary602_v0__8_18}" "-" "Prompt" "for" "some" "input" "from" "the" "user.")
    print_wrapped__644_v0 "title_2674"
    printf '%s\n' ""
    colored_secondary__603_v0 "Flags:"
    local ret_colored_secondary603_v0__11_12="${ret_colored_secondary603_v0}"
    local array_145=()
    printf__128_v0 "${ret_colored_secondary603_v0__11_12}""
" array_145[@]
    local names_2676=("-h, --help" "--placeholder=\"<text>\"" "--prompt=\"<text>\"" "--header=\"<text>\"" "--password")
    local texts_2677=("Show this help message" "Set the placeholder text" "Set the prompt text" "Set a header text to display above the prompt" "Hide input (for password entry)")
    local notes_2678=("" "(default: 'Type here...')" "(default: '> ')" "(ANSI escape supported)" "")
    render_help_entries__643_v0 "names_2676" "texts_2677" "notes_2678" 0
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__841_v0() {
    local parameters_2632=("${!1}")
    local prompt_2633="> "
    local placeholder_2634="Type here..."
    local header_2635=""
    local password_2636=0
    for param_2637 in "${parameters_2632[@]}"; do
        if [ "$(( $([ "_${param_2637}" != "_-h" ]; echo $?) || $([ "_${param_2637}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_input_help__789_v0 
            exit 0
        fi
        starts_with__22_v0 "${param_2637}" "--prompt="
        local ret_starts_with22_v0__17_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__17_12}" != 0 ]; then
            local __length_151="--prompt="
            slice__24_v0 "${param_2637}" "${#__length_151}" 0
            prompt_2633="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2637}" "--placeholder="
        local ret_starts_with22_v0__20_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__20_12}" != 0 ]; then
            local __length_152="--placeholder="
            slice__24_v0 "${param_2637}" "${#__length_152}" 0
            placeholder_2634="${ret_slice24_v0}"
        fi
        starts_with__22_v0 "${param_2637}" "--header="
        local ret_starts_with22_v0__23_12="${ret_starts_with22_v0}"
        if [ "${ret_starts_with22_v0__23_12}" != 0 ]; then
            local __length_153="--header="
            slice__24_v0 "${param_2637}" "${#__length_153}" 0
            header_2635="${ret_slice24_v0}"
        fi
        if [ "$([ "_${param_2637}" != "_--password" ]; echo $?)" != 0 ]; then
            password_2636=1
        fi
    done
    has_ansi_escape__633_v0 "${header_2635}"
    local ret_has_ansi_escape633_v0__31_44="${ret_has_ansi_escape633_v0}"
    escape_ansi__634_v0 "${header_2635}"
    local ret_escape_ansi634_v0__31_73="${ret_escape_ansi634_v0}"
    colored_primary__602_v0 "${header_2635}"
    local ret_colored_primary602_v0__31_111="${ret_colored_primary602_v0}"
    local display_header_2709
    display_header_2709="$(if [ "$(( $([ "_${header_2635}" != "_" ]; echo $?) || ret_has_ansi_escape633_v0__31_44 ))" != 0 ]; then echo "${ret_escape_ansi634_v0__31_73}"; else echo "\\x1b[1m""${ret_colored_primary602_v0__31_111}"; fi)"
    xyl_input__695_v0 "${prompt_2633}" "${placeholder_2634}" "${display_header_2709}" "${password_2636}"
    ret_execute_input841_v0="${ret_xyl_input695_v0}"
    return 0
}

# Perl Extensions Utilities
command_154="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_154}" != "_No" ]; echo $?)"
command_155="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! _perl_disabled_21 )) && $([ "_${command_155}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__973_v0() {
    local text_14634="${1}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return 1
    fi
    local command_156
    command_156="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_14634}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return "${__status}"
    fi
    local width_str_14635="${command_156}"
    parse_int__13_v0 "${width_str_14635}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width973_v0=''
        return "${__status}"
    fi
    local width_14636="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width973_v0="${width_14636}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__974_v0() {
    local text_14704="${1}"
    local max_width_14705="${2}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_truncate_cjk974_v0=''
        return 1
    fi
    local command_157
    command_157="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_14704}" ${max_width_14705} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk974_v0=''
        return "${__status}"
    fi
    local result_14706="${command_157}"
    ret_perl_truncate_cjk974_v0="${result_14706}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_23=0
_term_size_24=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__981_v0() {
    local command_159
    command_159="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_14692="${command_159}"
    parse_int__13_v0 "${count_14692}"
    __status=$?
    ret_stty_count981_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__982_v0() {
    stty_count__981_v0 
    local count_num_14693="${ret_stty_count981_v0}"
    if [ "$(( count_num_14693 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_14693="$(( count_num_14693 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14693}
    __status=$?
}

# stty_unlock()
stty_unlock__983_v0() {
    stty_count__981_v0 
    local count_num_14788="${ret_stty_count981_v0}"
    if [ "$(( count_num_14788 > 0 ))" != 0 ]; then
        count_num_14788="$(( count_num_14788 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_14788}
        __status=$?
        if [ "$(( count_num_14788 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__984_v0() {
    local size_14618="${1}"
    if [ "$([ "_${size_14618}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size984_v0=0
        return 0
    fi
    split__4_v0 "${size_14618}" " "
    local parts_14619=("${ret_split4_v0[@]}")
    local __length_160=("${parts_14619[@]}")
    if [ "$(( ${#__length_160[@]} != 2 ))" != 0 ]; then
        ret_store_term_size984_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_14619[1]?"Index out of bounds (at src/./choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_14619[0]?"Index out of bounds (at src/./choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_24=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size984_v0=1
    return 0
}

# query_term_size()
query_term_size__985_v0() {
    local command_162
    command_162="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_14621="${command_162}"
    store_term_size__984_v0 "${size_14621}"
    ret_query_term_size985_v0="${ret_store_term_size984_v0}"
    return 0
}

# stty_term_size()
stty_term_size__986_v0() {
    local command_163
    command_163="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_14617="${command_163}"
    store_term_size__984_v0 "${size_14617}"
    ret_stty_term_size986_v0="${ret_store_term_size984_v0}"
    return 0
}

# get_term_size()
get_term_size__987_v0() {
    stty_term_size__986_v0 
    local detected_14620="${ret_stty_term_size986_v0}"
    if [ "$(( ! detected_14620 ))" != 0 ]; then
        query_term_size__985_v0 
        detected_14620="${ret_query_term_size985_v0}"
    fi
    _got_term_size_23=1
}

# term_width()
term_width__989_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__987_v0 
    fi
    ret_term_width989_v0="${_term_size_24[0]?"Index out of bounds (at src/./choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__990_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__987_v0 
    fi
    ret_term_height990_v0="${_term_size_24[1]?"Index out of bounds (at src/./choose/../utils/term.ab:101:23)"}"
    return 0
}

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
get_supports_truecolor__1000_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_14605="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_14605}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor1000_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor1000_v0=0
        return 0
    fi
    local colorterm_14606="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_14606}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_14606}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1000_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1001_v0() {
    local message_14600="${1}"
    local r_14601="${2}"
    local g_14602="${3}"
    local b_14603="${4}"
    local fallback_14604="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1001_v0="\\x1b[38;2;${r_14601};${g_14602};${b_14603}m""${message_14600}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1000_v0 
        local ret_get_supports_truecolor1000_v0__50_17="${ret_get_supports_truecolor1000_v0}"
        if [ "${ret_get_supports_truecolor1000_v0__50_17}" != 0 ]; then
            ret_colored_rgb1001_v0="\\x1b[38;2;${r_14601};${g_14602};${b_14603}m""${message_14600}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_14604 == 0 ))" != 0 ]; then
            ret_colored_rgb1001_v0="${message_14600}"
            return 0
        else
            ret_colored_rgb1001_v0="\\x1b[${fallback_14604}m""${message_14600}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_14604 == 0 ))" != 0 ]; then
            ret_colored_rgb1001_v0="${message_14600}"
            return 0
        fi
        ret_colored_rgb1001_v0="\\x1b[${fallback_14604}m""${message_14600}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1003_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_14594="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_14594}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_14594}" ";"
            local parts_14595=("${ret_split4_v0[@]}")
            local __length_167=("${parts_14595[@]}")
            if [ "$(( ${#__length_167[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14595[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14595[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14595[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14595[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_27=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_14596="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_14596}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_14596}" ";"
            local parts_14597=("${ret_split4_v0[@]}")
            local __length_169=("${parts_14597[@]}")
            if [ "$(( ${#__length_169[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14597[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14597[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14597[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14597[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_28=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_14598="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_14598}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_14598}" ";"
            local parts_14599=("${ret_split4_v0[@]}")
            local __length_171=("${parts_14599[@]}")
            if [ "$(( ${#__length_171[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_14599[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14599[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14599[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_14599[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1003_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1004_v0() {
    inner_get_xylitol_colors__1003_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__1005_v0() {
    local message_14593="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__1004_v0 
    fi
    colored_rgb__1001_v0 "${message_14593}" "${_primary_color_27[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1005_v0="${ret_colored_rgb1001_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1006_v0() {
    local message_14638="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__1004_v0 
    fi
    colored_rgb__1001_v0 "${message_14638}" "${_secondary_color_28[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1006_v0="${ret_colored_rgb1001_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1021_v0() {
    local command_173
    command_173="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_14766="${command_173}"
    if [ "$([ "_${var_14766}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="UP"
        return 0
    elif [ "$([ "_${var_14766}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="DOWN"
        return 0
    elif [ "$([ "_${var_14766}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_14766}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="LEFT"
        return 0
    elif [ "$([ "_${var_14766}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_14766}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1021_v0="INPUT"
        return 0
    else
        ret_get_key1021_v0="${var_14766}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1023_v0() {
    local format_14675="${1}"
    local args_14676=("${!2}")
    args_14676=("${format_14675}" "${args_14676[@]}")
    __status=$?
    printf "${args_14676[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1024_v0() {
    local message_14673="${1}"
    local color_14674="${2}"
    # Prints an error message with a specified color.
    local array_174=("${message_14673}")
    eprintf__1023_v0 "\\x1b[${color_14674}m%s\\x1b[0m" array_174[@]
}

# colored(message: Text, color: Int)
colored__1025_v0() {
    local message_14667="${1}"
    local color_14668="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1025_v0="\\x1b[${color_14668}m""${message_14667}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1027_v0() {
    local cnt_14763="${1}"
    if [ "$(( cnt_14763 > 0 ))" != 0 ]; then
        local sequence_14764=""
        local __range_start_14765=0
        local __range_end_14765="${cnt_14763}"
        local __dir_14765=$(( ${__range_start_14765} <= ${__range_end_14765} ? 1 : -1 ))
        for (( ____14765=${__range_start_14765}; ____14765 * ${__dir_14765} < ${__range_end_14765} * ${__dir_14765}; ____14765+=${__dir_14765} )); do
            sequence_14764+="\\x1b[2K\\x1b[1A"
done
        local array_175=("")
        eprintf__1023_v0 "${sequence_14764}" array_175[@]
    fi
    local array_176=("")
    eprintf__1023_v0 "\\x1b[G" array_176[@]
}

# remove_current_line()
remove_current_line__1028_v0() {
    local array_177=("")
    eprintf__1023_v0 "\\x1b[2K\\x1b[G" array_177[@]
}

# print_blank(cnt: Int)
print_blank__1029_v0() {
    local cnt_14754="${1}"
    printf '%*s' "${cnt_14754}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1030_v0() {
    local cnt_14723="${1}"
    local __range_start_14724=0
    local __range_end_14724="${cnt_14723}"
    local __dir_14724=$(( ${__range_start_14724} <= ${__range_end_14724} ? 1 : -1 ))
    for (( ____14724=${__range_start_14724}; ____14724 * ${__dir_14724} < ${__range_end_14724} * ${__dir_14724}; ____14724+=${__dir_14724} )); do
        local array_178=("")
        eprintf__1023_v0 "
" array_178[@]
done
}

# go_up(cnt: Int)
go_up__1031_v0() {
    local cnt_14738="${1}"
    local array_179=("")
    eprintf__1023_v0 "\\x1b[${cnt_14738}A" array_179[@]
}

# go_down(cnt: Int)
go_down__1032_v0() {
    local cnt_14775="${1}"
    local array_180=("")
    eprintf__1023_v0 "\\x1b[${cnt_14775}B" array_180[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1033_v0() {
    local cnt_14784="${1}"
    if [ "$(( cnt_14784 > 0 ))" != 0 ]; then
        go_down__1032_v0 "${cnt_14784}"
    else
        go_up__1031_v0 "$(( - cnt_14784 ))"
    fi
}

# hide_cursor()
hide_cursor__1034_v0() {
    local array_181=("")
    eprintf__1023_v0 "\\x1b[?25l" array_181[@]
}

# show_cursor()
show_cursor__1035_v0() {
    local array_182=("")
    eprintf__1023_v0 "\\x1b[?25h" array_182[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1036_v0() {
    local text_14627="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_183
    command_183="$([[ "${text_14627}" == *$'\x1b'* || "${text_14627}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_14628="${command_183}"
    ret_has_ansi_escape1036_v0="$([ "_${has_escape_14628}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1037_v0() {
    local text_14678="${1}"
    local command_184
    command_184="$(printf '%s' "${text_14678}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1037_v0="${command_184}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1038_v0() {
    local text_14630="${1}"
    local command_185
    command_185="$(printf "%s" "${text_14630}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1038_v0="${command_185}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1039_v0() {
    local text_14632="${1}"
    local command_186
    command_186="$(printf "%s" "${text_14632}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_14633="${command_186}"
    ret_is_all_ascii1039_v0="$([ "_${result_14633}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1040_v0() {
    local text_14629="${1}"
    strip_ansi__1038_v0 "${text_14629}"
    local stripped_14631="${ret_strip_ansi1038_v0}"
    # Check if text is all ASCII
    is_all_ascii__1039_v0 "${stripped_14631}"
    local ret_is_all_ascii1039_v0__150_12="${ret_is_all_ascii1039_v0}"
    if [ "$(( ! ret_is_all_ascii1039_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__973_v0 "${stripped_14631}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_187="${stripped_14631}"
            ret_get_visible_len1040_v0="${#__length_187}"
            return 0
        fi
        ret_get_visible_len1040_v0="${ret_perl_get_cjk_width973_v0}"
        return 0
    else
        local __length_188="${stripped_14631}"
        ret_get_visible_len1040_v0="${#__length_188}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1041_v0() {
    local text_14701="${1}"
    local max_width_14702="${2}"
    get_visible_len__1040_v0 "${text_14701}"
    local visible_len_14703="${ret_get_visible_len1040_v0}"
    if [ "$(( visible_len_14703 <= max_width_14702 ))" != 0 ]; then
        ret_truncate_text1041_v0="${text_14701}"
        return 0
    fi
    is_all_ascii__1039_v0 "${text_14701}"
    local ret_is_all_ascii1039_v0__167_12="${ret_is_all_ascii1039_v0}"
    if [ "$(( ! ret_is_all_ascii1039_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__974_v0 "${text_14701}" "${max_width_14702}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_14701}" | cut -c1-${max_width_14702}
            __status=$?
        fi
        ret_truncate_text1041_v0="${ret_perl_truncate_cjk974_v0}"
        return 0
    fi
    local command_189
    command_189="$(printf "%s" "${text_14701}" | cut -c1-${max_width_14702})"
    __status=$?
    ret_truncate_text1041_v0="${command_189}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1042_v0() {
    local text_14699="${1}"
    local max_width_14700="${2}"
    has_ansi_escape__1036_v0 "${text_14699}"
    local ret_has_ansi_escape1036_v0__179_12="${ret_has_ansi_escape1036_v0}"
    if [ "$(( ! ret_has_ansi_escape1036_v0__179_12 ))" != 0 ]; then
        truncate_text__1041_v0 "${text_14699}" "${max_width_14700}"
        ret_truncate_ansi1042_v0="${ret_truncate_text1041_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_190
    command_190="$([[ "${text_14699}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_14707="${command_190}"
    # Replace \x1b[ with newline, then split
    local command_191
    command_191="$(t="${text_14699}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_14708="${command_191}"
    split__4_v0 "${replaced_14708}" "
"
    local parts_14709=("${ret_split4_v0[@]}")
    local result_14710=""
    local remaining_width_14711="${max_width_14700}"
    local __range_start_14712=0
    local __length_192=("${parts_14709[@]}")
    local __range_end_14712="${#__length_192[@]}"
    local __dir_14712=$(( ${__range_start_14712} <= ${__range_end_14712} ? 1 : -1 ))
    for (( idx_14712=${__range_start_14712}; idx_14712 * ${__dir_14712} < ${__range_end_14712} * ${__dir_14712}; idx_14712+=${__dir_14712} )); do
        local part_14713="${parts_14709[${idx_14712}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_14712 == 0 )) && $([ "_${starts_with_ansi_14707}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_14713}" == "_" ]; echo $?) && $(( remaining_width_14711 > 0 )) ))" != 0 ]; then
                truncate_text__1041_v0 "${part_14713}" "${remaining_width_14711}"
                local ret_truncate_text1041_v0__201_35="${ret_truncate_text1041_v0}"
                local truncated_14714="${ret_truncate_text1041_v0__201_35}"
                result_14710+="${truncated_14714}"
                get_visible_len__1040_v0 "${truncated_14714}"
                local ret_get_visible_len1040_v0__203_36="${ret_get_visible_len1040_v0}"
                remaining_width_14711="$(( remaining_width_14711 - ret_get_visible_len1040_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_193
            command_193="$(__p="${part_14713}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_14715="${command_193}"
            if [ "$([ "_${m_idx_14715}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_194
                command_194="$(__p="${part_14713}"; printf "%s" "${__p:0:${m_idx_14715}}")"
                __status=$?
                local ansi_params_14716="${command_194}"
                result_14710+="\\x1b[""${ansi_params_14716}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_14715}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_14717="${ret_parse_int13_v0__214_41}"
                local text_start_14718="$(( m_idx_num_14717 + 1 ))"
                local command_195
                command_195="$(__p="${part_14713}"; printf "%s" "${__p:${text_start_14718}}")"
                __status=$?
                local text_part_14719="${command_195}"
                if [ "$(( $([ "_${text_part_14719}" == "_" ]; echo $?) && $(( remaining_width_14711 > 0 )) ))" != 0 ]; then
                    truncate_text__1041_v0 "${text_part_14719}" "${remaining_width_14711}"
                    local ret_truncate_text1041_v0__218_39="${ret_truncate_text1041_v0}"
                    local truncated_14720="${ret_truncate_text1041_v0__218_39}"
                    result_14710+="${truncated_14720}"
                    get_visible_len__1040_v0 "${truncated_14720}"
                    local ret_get_visible_len1040_v0__220_40="${ret_get_visible_len1040_v0}"
                    remaining_width_14711="$(( remaining_width_14711 - ret_get_visible_len1040_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_14713}" == "_" ]; echo $?) && $(( remaining_width_14711 > 0 )) ))" != 0 ]; then
                    truncate_text__1041_v0 "${part_14713}" "${remaining_width_14711}"
                    local ret_truncate_text1041_v0__225_39="${ret_truncate_text1041_v0}"
                    local truncated_14721="${ret_truncate_text1041_v0__225_39}"
                    result_14710+="${truncated_14721}"
                    get_visible_len__1040_v0 "${truncated_14721}"
                    local ret_get_visible_len1040_v0__227_40="${ret_get_visible_len1040_v0}"
                    remaining_width_14711="$(( remaining_width_14711 - ret_get_visible_len1040_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1042_v0="${result_14710}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1043_v0() {
    local text_14696="${1}"
    local max_width_14697="${2}"
    get_visible_len__1040_v0 "${text_14696}"
    local visible_len_14698="${ret_get_visible_len1040_v0}"
    if [ "$(( visible_len_14698 <= max_width_14697 ))" != 0 ]; then
        ret_cutoff_text1043_v0="${text_14696}"
        return 0
    fi
    truncate_ansi__1042_v0 "${text_14696}" "$(( max_width_14697 - 3 ))"
    local ret_truncate_ansi1042_v0__243_12="${ret_truncate_ansi1042_v0}"
    ret_cutoff_text1043_v0="${ret_truncate_ansi1042_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1044_v0() {
    local items_14725=("${!1}")
    local total_len_14726="${2}"
    local term_width_14727="${3}"
    local separator_14728=" • "
    local separator_len_14729=3
    # Fast path: no truncation needed
    if [ "$(( total_len_14726 <= term_width_14727 ))" != 0 ]; then
        local iter_14730=0
        while :
        do
            local __length_196=("${items_14725[@]}")
            if [ "$(( iter_14730 >= ${#__length_196[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_14730 > 0 ))" != 0 ]; then
                eprintf_colored__1024_v0 "${separator_14728}" 90
            fi
            colored__1025_v0 "${items_14725[$(( iter_14730 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1025_v0__268_41="${ret_colored1025_v0}"
            local array_197=("")
            eprintf__1023_v0 "${items_14725[${iter_14730}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1025_v0__268_41}" array_197[@]
            iter_14730="$(( iter_14730 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_14731=0
        local first_14732=1
        local iter_14733=0
        while :
        do
            local __length_198=("${items_14725[@]}")
            if [ "$(( iter_14733 >= ${#__length_198[@]} ))" != 0 ]; then
                break
            fi
            local key_14734="${items_14725[${iter_14733}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_14735="${items_14725[$(( iter_14733 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_199="${key_14734}"
            local __length_200="${action_14735}"
            local part_len_14736="$(( $(( ${#__length_199} + 1 )) + ${#__length_200} ))"
            local needed_14737="${part_len_14736}"
            if [ "$(( ! first_14732 ))" != 0 ]; then
                needed_14737="$(( needed_14737 + separator_len_14729 ))"
            fi
            if [ "$(( $(( current_len_14731 + needed_14737 )) > term_width_14727 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_14732 ))" != 0 ]; then
                eprintf_colored__1024_v0 "${separator_14728}" 90
            fi
            colored__1025_v0 "${action_14735}" 2
            local ret_colored1025_v0__296_33="${ret_colored1025_v0}"
            local array_201=("")
            eprintf__1023_v0 "${key_14734}"" ""${ret_colored1025_v0__296_33}" array_201[@]
            current_len_14731="$(( current_len_14731 + needed_14737 ))"
            first_14732=0
            iter_14733="$(( iter_14733 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1045_v0() {
    local pending_14664="${1}"
    local line_14665="${2}"
    local note_at_14666="${3}"
    if [ "$(( note_at_14666 < 0 ))" != 0 ]; then
        local array_202=()
        printf__128_v0 "${pending_14664}""${line_14665}""
" array_202[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_14666 == 0 ))" != 0 ]; then
        colored__1025_v0 "${line_14665}" 90
        local ret_colored1025_v0__310_40="${ret_colored1025_v0}"
        local array_203=()
        printf__128_v0 "${pending_14664}""${ret_colored1025_v0__310_40}""
" array_203[@]
    else
        slice__24_v0 "${line_14665}" 0 "${note_at_14666}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_14665}" "${note_at_14666}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1025_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1025_v0__311_58="${ret_colored1025_v0}"
        local array_204=()
        printf__128_v0 "${pending_14664}""${ret_slice24_v0__311_32}""${ret_colored1025_v0__311_58}""
" array_204[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1046_v0() {
    local -n names_14642="${1}"
    local -n texts_14643="${2}"
    local -n notes_14644="${3}"
    local min_name_width_14645="${4}"
    local __length_205=("${names_14642[@]}")
    local count_14646="${#__length_205[@]}"
    local name_width_14647="${min_name_width_14645}"
    local __range_start_14648=0
    local __range_end_14648="${count_14646}"
    local __dir_14648=$(( ${__range_start_14648} <= ${__range_end_14648} ? 1 : -1 ))
    for (( i_14648=${__range_start_14648}; i_14648 * ${__dir_14648} < ${__range_end_14648} * ${__dir_14648}; i_14648+=${__dir_14648} )); do
        local __length_206="${names_14642[${i_14648}]?"Index out of bounds (at src/./choose/../utils.ab:326:33)"}"
        local width_14649="${#__length_206}"
        if [ "$(( width_14649 > name_width_14647 ))" != 0 ]; then
            name_width_14647="${width_14649}"
        fi
done
    term_width__989_v0 
    local width_14650="${ret_term_width989_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_14651="$(( name_width_14647 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_14652="$(( $(( width_14650 - indent_14651 )) < 24 ))"
    if [ "${stacked_14652}" != 0 ]; then
        indent_14651=6
    fi
    local avail_14653="$(( width_14650 - indent_14651 ))"
    rpad__28_v0 "" " " "${indent_14651}"
    local blank_14654="${ret_rpad28_v0}"
    local __range_start_14655=0
    local __range_end_14655="${count_14646}"
    local __dir_14655=$(( ${__range_start_14655} <= ${__range_end_14655} ? 1 : -1 ))
    for (( i_14655=${__range_start_14655}; i_14655 * ${__dir_14655} < ${__range_end_14655} * ${__dir_14655}; i_14655+=${__dir_14655} )); do
        local pending_14656="${blank_14654}"
        if [ "${stacked_14652}" != 0 ]; then
            local array_207=()
            printf__128_v0 "  ""${names_14642[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:346:33)"}""
" array_207[@]
        else
            rpad__28_v0 "  ""${names_14642[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:348:41)"}" " " "${indent_14651}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_14656="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_14643[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_14657=("${ret_split4_v0__350_21[@]}")
        local __length_208=("${words_14657[@]}")
        local note_start_14658="${#__length_208[@]}"
        if [ "$([ "_${notes_14644[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_209="${notes_14644[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_209} > avail_14653 ))" != 0 ]; then
                split__4_v0 "${notes_14644[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_14657+=("${ret_split4_v0__356_26[@]}")
            else
                local array_210=("${notes_14644[${i_14655}]?"Index out of bounds (at src/./choose/../utils.ab:358:33)"}")
                words_14657+=("${array_210[@]}")
            fi
        fi
        local line_14659=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_14660=-1
        local __range_start_14661=0
        local __length_211=("${words_14657[@]}")
        local __range_end_14661="${#__length_211[@]}"
        local __dir_14661=$(( ${__range_start_14661} <= ${__range_end_14661} ? 1 : -1 ))
        for (( j_14661=${__range_start_14661}; j_14661 * ${__dir_14661} < ${__range_end_14661} * ${__dir_14661}; j_14661+=${__dir_14661} )); do
            local word_14662="${words_14657[${j_14661}]?"Index out of bounds (at src/./choose/../utils.ab:368:32)"}"
            local candidate_14663
            candidate_14663="$(if [ "$([ "_${line_14659}" != "_" ]; echo $?)" != 0 ]; then echo "${word_14662}"; else echo "${line_14659}"" ""${word_14662}"; fi)"
            local __length_212="${candidate_14663}"
            if [ "$(( $(( ${#__length_212} > avail_14653 )) && $([ "_${line_14659}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1045_v0 "${pending_14656}" "${line_14659}" "${note_at_14660}"
                pending_14656="${blank_14654}"
                line_14659="${word_14662}"
                note_at_14660="$(if [ "$(( j_14661 >= note_start_14658 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_14661 >= note_start_14658 )) && $(( note_at_14660 < 0 )) ))" != 0 ]; then
                    local __length_213="${candidate_14663}"
                    local __length_214="${word_14662}"
                    note_at_14660="$(( ${#__length_213} - ${#__length_214} ))"
                fi
                line_14659="${candidate_14663}"
            fi
done
        print_help_line__1045_v0 "${pending_14656}" "${line_14659}" "${note_at_14660}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1047_v0() {
    local -n pieces_14616="${1}"
    term_width__989_v0 
    local width_14622="${ret_term_width989_v0}"
    local line_14623=""
    local line_len_14624=0
    for piece_14625 in "${pieces_14616[@]}"; do
        local __length_217="${piece_14625}"
        local piece_len_14626="${#__length_217}"
        has_ansi_escape__1036_v0 "${piece_14625}"
        local ret_has_ansi_escape1036_v0__397_12="${ret_has_ansi_escape1036_v0}"
        if [ "${ret_has_ansi_escape1036_v0__397_12}" != 0 ]; then
            get_visible_len__1040_v0 "${piece_14625}"
            piece_len_14626="${ret_get_visible_len1040_v0}"
        fi
        if [ "$([ "_${line_14623}" != "_" ]; echo $?)" != 0 ]; then
            line_14623="${piece_14625}"
            line_len_14624="${piece_len_14626}"
        elif [ "$(( $(( $(( line_len_14624 + 1 )) + piece_len_14626 )) > width_14622 ))" != 0 ]; then
            local array_218=()
            printf__128_v0 "${line_14623}""
" array_218[@]
            line_14623="${piece_14625}"
            line_len_14624="${piece_len_14626}"
        else
            line_14623+=" ""${piece_14625}"
            line_len_14624="$(( line_len_14624 + $(( 1 + piece_len_14626 )) ))"
        fi
    done
    if [ "$([ "_${line_14623}" == "_" ]; echo $?)" != 0 ]; then
        local array_219=()
        printf__128_v0 "${line_14623}""
" array_219[@]
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
__CHOOSER_CONTINUE_30=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_31=1
# The user confirmed the selection.
__CHOOSER_DONE_32=2
_total_33=0
_page_size_34=10
_display_count_35=0
_total_pages_36=1
_current_page_37=0
_selected_38=0
_cursor_39="> "
_multi_40=0
_limit_41=-1
_term_width_42=80
_has_header_43=0
_page_44=()
_page_count_45=0
_checked_46=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_47=0
_first_render_48=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_49=0
# render_single_page()
render_single_page__1195_v0() {
    local __length_222="${_cursor_39}"
    local cursor_len_14757="${#__length_222}"
    local max_option_width_14758="$(( $(( _term_width_42 - cursor_len_14757 )) - 1 ))"
    local __range_start_14759=0
    local __range_end_14759="${_page_count_45}"
    local __dir_14759=$(( ${__range_start_14759} <= ${__range_end_14759} ? 1 : -1 ))
    for (( i_14759=${__range_start_14759}; i_14759 * ${__dir_14759} < ${__range_end_14759} * ${__dir_14759}; i_14759+=${__dir_14759} )); do
        cutoff_text__1043_v0 "${_page_44[${i_14759}]?"Index out of bounds (at src/./choose/./engine.ab:48:45)"}" "${max_option_width_14758}"
        local ret_cutoff_text1043_v0__48_27="${ret_cutoff_text1043_v0}"
        local truncated_14760="${ret_cutoff_text1043_v0__48_27}"
        if [ "$(( i_14759 == _selected_38 ))" != 0 ]; then
            colored_secondary__1006_v0 "${_cursor_39}""${truncated_14760}""
"
            local ret_colored_secondary1006_v0__50_21="${ret_colored_secondary1006_v0}"
            local array_223=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__50_21}" array_223[@]
        else
            print_blank__1029_v0 "${cursor_len_14757}"
            local array_224=("")
            eprintf__1023_v0 "${truncated_14760}""
" array_224[@]
        fi
done
    local remaining_slots_14761="$(( _display_count_35 - _page_count_45 ))"
    if [ "$(( remaining_slots_14761 > 0 ))" != 0 ]; then
        local __range_start_14762=0
        local __range_end_14762="${remaining_slots_14761}"
        local __dir_14762=$(( ${__range_start_14762} <= ${__range_end_14762} ? 1 : -1 ))
        for (( ____14762=${__range_start_14762}; ____14762 * ${__dir_14762} < ${__range_end_14762} * ${__dir_14762}; ____14762+=${__dir_14762} )); do
            local array_225=("")
            eprintf__1023_v0 "\\x1b[K
" array_225[@]
done
    fi
}

# render_multi_page()
render_multi_page__1196_v0() {
    local __length_226="${_cursor_39}"
    local cursor_len_14747="${#__length_226}"
    local max_option_width_14748="$(( $(( _term_width_42 - cursor_len_14747 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__1201_v0 
    local page_start_14749="${ret_chooser_page_start1201_v0}"
    local __range_start_14750=0
    local __range_end_14750="${_page_count_45}"
    local __dir_14750=$(( ${__range_start_14750} <= ${__range_end_14750} ? 1 : -1 ))
    for (( i_14750=${__range_start_14750}; i_14750 * ${__dir_14750} < ${__range_end_14750} * ${__dir_14750}; i_14750+=${__dir_14750} )); do
        local global_idx_14751="$(( page_start_14749 + i_14750 ))"
        local check_mark_14752
        check_mark_14752="$(if [ "${_checked_46[${global_idx_14751}]?"Index out of bounds (at src/./choose/./engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1043_v0 "${_page_44[${i_14750}]?"Index out of bounds (at src/./choose/./engine.ab:71:45)"}" "${max_option_width_14748}"
        local ret_cutoff_text1043_v0__71_27="${ret_cutoff_text1043_v0}"
        local truncated_14753="${ret_cutoff_text1043_v0__71_27}"
        if [ "$(( i_14750 == _selected_38 ))" != 0 ]; then
            colored_secondary__1006_v0 "${_cursor_39}""${check_mark_14752}""${truncated_14753}""
"
            local ret_colored_secondary1006_v0__73_37="${ret_colored_secondary1006_v0}"
            local array_227=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__73_37}" array_227[@]
        elif [ "${_checked_46[${global_idx_14751}]?"Index out of bounds (at src/./choose/./engine.ab:74:22)"}" != 0 ]; then
            print_blank__1029_v0 "${cursor_len_14747}"
            colored_secondary__1006_v0 "${check_mark_14752}""${truncated_14753}""
"
            local ret_colored_secondary1006_v0__76_25="${ret_colored_secondary1006_v0}"
            local array_228=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__76_25}" array_228[@]
        else
            print_blank__1029_v0 "${cursor_len_14747}"
            local array_229=("")
            eprintf__1023_v0 "${check_mark_14752}""${truncated_14753}""
" array_229[@]
        fi
done
    local remaining_slots_14755="$(( _display_count_35 - _page_count_45 ))"
    if [ "$(( remaining_slots_14755 > 0 ))" != 0 ]; then
        local __range_start_14756=0
        local __range_end_14756="${remaining_slots_14755}"
        local __dir_14756=$(( ${__range_start_14756} <= ${__range_end_14756} ? 1 : -1 ))
        for (( ____14756=${__range_start_14756}; ____14756 * ${__dir_14756} < ${__range_end_14756} * ${__dir_14756}; ____14756+=${__dir_14756} )); do
            local array_230=("")
            eprintf__1023_v0 "\\x1b[K
" array_230[@]
done
    fi
}

# render_page()
render_page__1197_v0() {
    if [ "${_multi_40}" != 0 ]; then
        render_multi_page__1196_v0 
    else
        render_single_page__1195_v0 
    fi
}

# render_page_indicator()
render_page_indicator__1198_v0() {
    if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
        local array_231=("")
        eprintf__1023_v0 "\\x1b[G\\x1b[K" array_231[@]
        eprintf_colored__1024_v0 "Page $(( _current_page_37 + 1 ))/${_total_pages_36}" 90
        local array_232=("")
        eprintf__1023_v0 "\\x1b[G" array_232[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__1199_v0() {
    if [ "$(( ! _multi_40 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
            local array_233=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__1044_v0 array_233[@] 36 "${_term_width_42}"
        else
            local array_234=("↑↓" "select" "enter" "confirm")
            render_tooltip__1044_v0 array_234[@] 25 "${_term_width_42}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_36 > 1 )) && $(( _limit_41 < 0 )) ))" != 0 ]; then
            local array_235=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__1044_v0 array_235[@] 55 "${_term_width_42}"
        elif [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
            local array_236=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__1044_v0 array_236[@] 47 "${_term_width_42}"
        elif [ "$(( _limit_41 < 0 ))" != 0 ]; then
            local array_237=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__1044_v0 array_237[@] 44 "${_term_width_42}"
        else
            local array_238=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__1044_v0 array_238[@] 36 "${_term_width_42}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__1200_v0() {
    local total_14686="${1}"
    local page_size_14687="${2}"
    local header_14688="${3}"
    local cursor_14689="${4}"
    local multi_14690="${5}"
    local limit_14691="${6}"
    _total_33="${total_14686}"
    _cursor_39="${cursor_14689}"
    _multi_40="${multi_14690}"
    _limit_41="${limit_14691}"
    _current_page_37=0
    _selected_38=0
    _first_render_48=1
    _up_paged_49=0
    _checked_count_47=0
    _has_header_43="$([ "_${header_14688}" == "_" ]; echo $?)"
    stty_lock__982_v0 
    hide_cursor__1034_v0 
    term_width__989_v0 
    _term_width_42="${ret_term_width989_v0}"
    term_height__990_v0 
    local term_height_14694="${ret_term_height990_v0}"
    local max_page_size_14695
    max_page_size_14695="$(( term_height_14694 - $(if [ "${_has_header_43}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_34="${page_size_14687}"
    if [ "$(( _page_size_34 > max_page_size_14695 ))" != 0 ]; then
        _page_size_34="${max_page_size_14695}"
    fi
    if [ "${_has_header_43}" != 0 ]; then
        cutoff_text__1043_v0 "${header_14688}" "${_term_width_42}"
        local ret_cutoff_text1043_v0__157_17="${ret_cutoff_text1043_v0}"
        local array_239=("")
        eprintf__1023_v0 "${ret_cutoff_text1043_v0__157_17}""
" array_239[@]
    fi
    math_floor__509_v0 "$(( $(( $(( total_14686 + _page_size_34 )) - 1 )) / _page_size_34 ))"
    _total_pages_36="${ret_math_floor509_v0}"
    _display_count_35="${_page_size_34}"
    if [ "$(( total_14686 < _page_size_34 ))" != 0 ]; then
        _display_count_35="${total_14686}"
    fi
    if [ "${multi_14690}" != 0 ]; then
        _checked_46=()
        local __range_start_14722=0
        local __range_end_14722="${total_14686}"
        local __dir_14722=$(( ${__range_start_14722} <= ${__range_end_14722} ? 1 : -1 ))
        for (( ____14722=${__range_start_14722}; ____14722 * ${__dir_14722} < ${__range_end_14722} * ${__dir_14722}; ____14722+=${__dir_14722} )); do
            local array_241=(0)
            _checked_46+=("${array_241[@]}")
done
    fi
    new_line__1030_v0 "${_display_count_35}"
    local array_242=("")
    eprintf__1023_v0 "\\x1b[G" array_242[@]
    if [ "$(( _total_pages_36 > 1 ))" != 0 ]; then
        eprintf_colored__1024_v0 "Page $(( _current_page_37 + 1 ))/${_total_pages_36}" 90
    fi
    new_line__1030_v0 1
    render_tooltip_line__1199_v0 
    go_up__1031_v0 "$(( _display_count_35 + 1 ))"
    local array_243=("")
    eprintf__1023_v0 "\\x1b[G" array_243[@]
}

# chooser_page_start()
chooser_page_start__1201_v0() {
    ret_chooser_page_start1201_v0="$(( _current_page_37 * _page_size_34 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__1202_v0() {
    chooser_page_start__1201_v0 
    local start_14742="${ret_chooser_page_start1201_v0}"
    local end_14743="$(( start_14742 + _page_size_34 ))"
    if [ "$(( end_14743 > _total_33 ))" != 0 ]; then
        end_14743="${_total_33}"
    fi
    ret_chooser_page_count1202_v0="$(( end_14743 - start_14742 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__1203_v0() {
    local -n page_14746="${1}"
    _page_44=("${page_14746[@]}")
    local __length_244=("${page_14746[@]}")
    _page_count_45="${#__length_244[@]}"
    if [ "${_first_render_48}" != 0 ]; then
        _first_render_48=0
        render_page__1197_v0 
    else
        if [ "${_up_paged_49}" != 0 ]; then
            _selected_38="$(( _page_count_45 - 1 ))"
            _up_paged_49=0
        fi
        go_up__1031_v0 1
        remove_line__1027_v0 "$(( _display_count_35 - 1 ))"
        remove_current_line__1028_v0 
        local array_245=("")
        eprintf__1023_v0 "\\x1b[G" array_245[@]
        render_page__1197_v0 
        render_page_indicator__1198_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__1204_v0() {
    local prev_selected_14778="${1}"
    chooser_page_start__1201_v0 
    local page_start_14779="${ret_chooser_page_start1201_v0}"
    local check_width_14780
    check_width_14780="$(if [ "${_multi_40}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_246="${_cursor_39}"
    local max_option_width_14781="$(( $(( _term_width_42 - ${#__length_246} )) - check_width_14780 ))"
    go_up__1031_v0 "$(( _display_count_35 - prev_selected_14778 ))"
    local array_247=("")
    eprintf__1023_v0 "\\x1b[K" array_247[@]
    local __length_248="${_cursor_39}"
    print_blank__1029_v0 "${#__length_248}"
    if [ "${_multi_40}" != 0 ]; then
        local was_checked_14782="${_checked_46[$(( page_start_14779 + prev_selected_14778 ))]?"Index out of bounds (at src/./choose/./engine.ab:231:38)"}"
        cutoff_text__1043_v0 "${_page_44[${prev_selected_14778}]?"Index out of bounds (at src/./choose/./engine.ab:232:81)"}" "${max_option_width_14781}"
        local ret_cutoff_text1043_v0__232_63="${ret_cutoff_text1043_v0}"
        local prev_line_14783
        prev_line_14783="$(if [ "${was_checked_14782}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text1043_v0__232_63}"
        if [ "${was_checked_14782}" != 0 ]; then
            colored_secondary__1006_v0 "${prev_line_14783}"
            local ret_colored_secondary1006_v0__234_21="${ret_colored_secondary1006_v0}"
            local array_249=("")
            eprintf__1023_v0 "${ret_colored_secondary1006_v0__234_21}" array_249[@]
        else
            local array_250=("")
            eprintf__1023_v0 "${prev_line_14783}" array_250[@]
        fi
    else
        cutoff_text__1043_v0 "${_page_44[${prev_selected_14778}]?"Index out of bounds (at src/./choose/./engine.ab:239:35)"}" "${max_option_width_14781}"
        local ret_cutoff_text1043_v0__239_17="${ret_cutoff_text1043_v0}"
        local array_251=("")
        eprintf__1023_v0 "${ret_cutoff_text1043_v0__239_17}" array_251[@]
    fi
    go_up_or_down__1033_v0 "$(( _selected_38 - prev_selected_14778 ))"
    local array_252=("")
    eprintf__1023_v0 "\\x1b[G" array_252[@]
    local array_253=("")
    eprintf__1023_v0 "\\x1b[K" array_253[@]
    local mark_14785
    mark_14785="$(if [ "${_multi_40}" != 0 ]; then echo "$(if [ "${_checked_46[$(( page_start_14779 + _selected_38 ))]?"Index out of bounds (at src/./choose/./engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__1043_v0 "${_page_44[${_selected_38}]?"Index out of bounds (at src/./choose/./engine.ab:246:66)"}" "${max_option_width_14781}"
    local ret_cutoff_text1043_v0__246_48="${ret_cutoff_text1043_v0}"
    colored_secondary__1006_v0 "${_cursor_39}""${mark_14785}""${ret_cutoff_text1043_v0__246_48}"
    local ret_colored_secondary1006_v0__246_13="${ret_colored_secondary1006_v0}"
    local array_254=("")
    eprintf__1023_v0 "${ret_colored_secondary1006_v0__246_13}" array_254[@]
    go_down__1032_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_255=("")
    eprintf__1023_v0 "\\x1b[G" array_255[@]
}

# redraw_current_line()
redraw_current_line__1205_v0() {
    chooser_page_start__1201_v0 
    local page_start_14772="${ret_chooser_page_start1201_v0}"
    local __length_256="${_cursor_39}"
    local max_option_width_14773="$(( $(( _term_width_42 - ${#__length_256} )) - 3 ))"
    go_up__1031_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_257=("")
    eprintf__1023_v0 "\\x1b[G" array_257[@]
    local array_258=("")
    eprintf__1023_v0 "\\x1b[K" array_258[@]
    local check_mark_14774
    check_mark_14774="$(if [ "${_checked_46[$(( page_start_14772 + _selected_38 ))]?"Index out of bounds (at src/./choose/./engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__1043_v0 "${_page_44[${_selected_38}]?"Index out of bounds (at src/./choose/./engine.ab:260:72)"}" "${max_option_width_14773}"
    local ret_cutoff_text1043_v0__260_54="${ret_cutoff_text1043_v0}"
    colored_secondary__1006_v0 "${_cursor_39}""${check_mark_14774}""${ret_cutoff_text1043_v0__260_54}"
    local ret_colored_secondary1006_v0__260_13="${ret_colored_secondary1006_v0}"
    local array_259=("")
    eprintf__1023_v0 "${ret_colored_secondary1006_v0__260_13}" array_259[@]
    go_down__1032_v0 "$(( _display_count_35 - _selected_38 ))"
    local array_260=("")
    eprintf__1023_v0 "\\x1b[G" array_260[@]
}

# chooser_step()
chooser_step__1206_v0() {
    get_key__1021_v0 
    local key_14767="${ret_get_key1021_v0}"
    local prev_selected_14768="${_selected_38}"
    local prev_page_14769="${_current_page_37}"
    chooser_page_start__1201_v0 
    local page_start_14770="${ret_chooser_page_start1201_v0}"
    _up_paged_49=0
    if [ "$(( $([ "_${key_14767}" != "_UP" ]; echo $?) || $([ "_${key_14767}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_38 == 0 )) && $(( _total_pages_36 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_37 > 0 ))" != 0 ]; then
                _current_page_37="$(( _current_page_37 - 1 ))"
            else
                _current_page_37="$(( _total_pages_36 - 1 ))"
            fi
            _up_paged_49=1
        elif [ "$(( _selected_38 == 0 ))" != 0 ]; then
            _selected_38="$(( _page_count_45 - 1 ))"
        else
            _selected_38="$(( _selected_38 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_14767}" != "_DOWN" ]; echo $?) || $([ "_${key_14767}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_38 == $(( _page_count_45 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_37 < $(( _total_pages_36 - 1 )) ))" != 0 ]; then
                _current_page_37="$(( _current_page_37 + 1 ))"
            else
                _current_page_37=0
            fi
            _selected_38=0
        else
            _selected_38="$(( _selected_38 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_14767}" != "_LEFT" ]; echo $?) || $([ "_${key_14767}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_37 > 0 ))" != 0 ]; then
            _current_page_37="$(( _current_page_37 - 1 ))"
        fi
        _selected_38=0
    elif [ "$(( $([ "_${key_14767}" != "_RIGHT" ]; echo $?) || $([ "_${key_14767}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_37 < $(( _total_pages_36 - 1 )) ))" != 0 ]; then
            _current_page_37="$(( _current_page_37 + 1 ))"
            _selected_38=0
        else
            _selected_38="$(( _page_count_45 - 1 ))"
        fi
    elif [ "$(( _multi_40 && $(( $([ "_${key_14767}" != "_x" ]; echo $?) || $([ "_${key_14767}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_14771="$(( page_start_14770 + _selected_38 ))"
        if [ "${_checked_46[${global_selected_14771}]?"Index out of bounds (at src/./choose/./engine.ab:321:26)"}" != 0 ]; then
            _checked_46["${global_selected_14771}"]=0
            _checked_count_47="$(( _checked_count_47 - 1 ))"
        elif [ "$(( $(( _limit_41 < 0 )) || $(( _checked_count_47 < _limit_41 )) ))" != 0 ]; then
            _checked_46["${global_selected_14771}"]=1
            _checked_count_47="$(( _checked_count_47 + 1 ))"
        else
            ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_30}"
            return 0
        fi
        redraw_current_line__1205_v0 
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    elif [ "$(( $(( _multi_40 && $(( $([ "_${key_14767}" != "_a" ]; echo $?) || $([ "_${key_14767}" != "_A" ]; echo $?) )) )) && $(( _limit_41 < 0 )) ))" != 0 ]; then
        local all_checked_14776="$(( _checked_count_47 == _total_33 ))"
        local __range_start_14777=0
        local __range_end_14777="${_total_33}"
        local __dir_14777=$(( ${__range_start_14777} <= ${__range_end_14777} ? 1 : -1 ))
        for (( i_14777=${__range_start_14777}; i_14777 * ${__dir_14777} < ${__range_end_14777} * ${__dir_14777}; i_14777+=${__dir_14777} )); do
            _checked_46["${i_14777}"]="$(( ! all_checked_14776 ))"
done
        _checked_count_47="$(if [ "${all_checked_14776}" != 0 ]; then echo 0; else echo "${_total_33}"; fi)"
        go_up__1031_v0 "${_display_count_35}"
        local array_261=("")
        eprintf__1023_v0 "\\x1b[G" array_261[@]
        render_page__1197_v0 
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    elif [ "$([ "_${key_14767}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step1206_v0="${__CHOOSER_DONE_32}"
        return 0
    else
        ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_30}"
        return 0
    fi
    if [ "$(( prev_page_14769 != _current_page_37 ))" != 0 ]; then
        ret_chooser_step1206_v0="${__CHOOSER_NEED_PAGE_31}"
        return 0
    fi
    if [ "$(( prev_selected_14768 != _selected_38 ))" != 0 ]; then
        redraw_selection__1204_v0 "${prev_selected_14768}"
    fi
    ret_chooser_step1206_v0="${__CHOOSER_CONTINUE_30}"
    return 0
}

# chooser_selected()
chooser_selected__1207_v0() {
    chooser_page_start__1201_v0 
    local ret_chooser_page_start1201_v0__362_12="${ret_chooser_page_start1201_v0}"
    ret_chooser_selected1207_v0="$(( ret_chooser_page_start1201_v0__362_12 + _selected_38 ))"
    return 0
}

# chooser_is_checked(index: Int)
chooser_is_checked__1208_v0() {
    local index_14791="${1}"
    ret_chooser_is_checked1208_v0="${_checked_46[${index_14791}]?"Index out of bounds (at src/./choose/./engine.ab:367:21)"}"
    return 0
}

# chooser_end()
chooser_end__1209_v0() {
    local total_lines_14787="$(( _display_count_35 + 2 ))"
    if [ "${_has_header_43}" != 0 ]; then
        total_lines_14787="$(( total_lines_14787 + 1 ))"
    fi
    go_down__1032_v0 1
    remove_line__1027_v0 "$(( total_lines_14787 - 1 ))"
    remove_current_line__1028_v0 
    stty_unlock__983_v0 
    show_cursor__1035_v0 
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1218_v0() {
    local -n options_14795="${1}"
    local cursor_14796="${2}"
    local header_14797="${3}"
    local page_size_14798="${4}"
    # `len` copies the whole array, so the count is taken once and reused.
    local __length_262=("${options_14795[@]}")
    local total_14799="${#__length_262[@]}"
    if [ "$(( total_14799 == 0 ))" != 0 ]; then
        eprintf_colored__1024_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    chooser_begin__1200_v0 "${total_14799}" "${page_size_14798}" "${header_14797}" "${cursor_14796}" 0 -1
    local need_page_14800=1
    while :
    do
        if [ "${need_page_14800}" != 0 ]; then
            local page_14801=()
            chooser_page_start__1201_v0 
            local start_14802="${ret_chooser_page_start1201_v0}"
            chooser_page_count__1202_v0 
            local count_14803="${ret_chooser_page_count1202_v0}"
            local __range_start_14804="${start_14802}"
            local __range_end_14804="$(( start_14802 + count_14803 ))"
            local __dir_14804=$(( ${__range_start_14804} <= ${__range_end_14804} ? 1 : -1 ))
            for (( i_14804=${__range_start_14804}; i_14804 * ${__dir_14804} < ${__range_end_14804} * ${__dir_14804}; i_14804+=${__dir_14804} )); do
                local array_264=("${options_14795[${i_14804}]?"Index out of bounds (at src/./choose/./mod.ab:33:34)"}")
                page_14801+=("${array_264[@]}")
done
            chooser_set_page__1203_v0 "page_14801"
        fi
        chooser_step__1206_v0 
        local step_14805="${ret_chooser_step1206_v0}"
        if [ "$(( step_14805 == __CHOOSER_DONE_32 ))" != 0 ]; then
            break
        fi
        need_page_14800="$(( step_14805 == __CHOOSER_NEED_PAGE_31 ))"
    done
    chooser_selected__1207_v0 
    local selected_14806="${ret_chooser_selected1207_v0}"
    chooser_end__1209_v0 
    ret_xyl_choose1218_v0="${options_14795[${selected_14806}]?"Index out of bounds (at src/./choose/./mod.ab:46:20)"}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1219_v0() {
    local -n options_14680="${1}"
    local cursor_14681="${2}"
    local header_14682="${3}"
    local limit_14683="${4}"
    local page_size_14684="${5}"
    local __length_265=("${options_14680[@]}")
    local total_14685="${#__length_265[@]}"
    if [ "$(( total_14685 == 0 ))" != 0 ]; then
        eprintf_colored__1024_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1219_v0=()
        return 0
    fi
    chooser_begin__1200_v0 "${total_14685}" "${page_size_14684}" "${header_14682}" "${cursor_14681}" 1 "${limit_14683}"
    local need_page_14739=1
    while :
    do
        if [ "${need_page_14739}" != 0 ]; then
            local page_14740=()
            chooser_page_start__1201_v0 
            local start_14741="${ret_chooser_page_start1201_v0}"
            chooser_page_count__1202_v0 
            local count_14744="${ret_chooser_page_count1202_v0}"
            local __range_start_14745="${start_14741}"
            local __range_end_14745="$(( start_14741 + count_14744 ))"
            local __dir_14745=$(( ${__range_start_14745} <= ${__range_end_14745} ? 1 : -1 ))
            for (( i_14745=${__range_start_14745}; i_14745 * ${__dir_14745} < ${__range_end_14745} * ${__dir_14745}; i_14745+=${__dir_14745} )); do
                local array_268=("${options_14680[${i_14745}]?"Index out of bounds (at src/./choose/./mod.ab:78:34)"}")
                page_14740+=("${array_268[@]}")
done
            chooser_set_page__1203_v0 "page_14740"
        fi
        chooser_step__1206_v0 
        local step_14786="${ret_chooser_step1206_v0}"
        if [ "$(( step_14786 == __CHOOSER_DONE_32 ))" != 0 ]; then
            break
        fi
        need_page_14739="$(( step_14786 == __CHOOSER_NEED_PAGE_31 ))"
    done
    chooser_end__1209_v0 
    local result_14789=()
    local __range_start_14790=0
    local __range_end_14790="${total_14685}"
    local __dir_14790=$(( ${__range_start_14790} <= ${__range_end_14790} ? 1 : -1 ))
    for (( i_14790=${__range_start_14790}; i_14790 * ${__dir_14790} < ${__range_end_14790} * ${__dir_14790}; i_14790+=${__dir_14790} )); do
        chooser_is_checked__1208_v0 "${i_14790}"
        local ret_chooser_is_checked1208_v0__93_12="${ret_chooser_is_checked1208_v0}"
        if [ "${ret_chooser_is_checked1208_v0__93_12}" != 0 ]; then
            local array_270=("${options_14680[${i_14790}]?"Index out of bounds (at src/./choose/./mod.ab:94:32)"}")
            result_14789+=("${array_270[@]}")
        fi
done
    ret_xyl_multi_choose1219_v0=("${result_14789[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1314_v0() {
    local usage_14615=("Usage:" "./xylitol.sh" "choose" "[<options>" "...]" "[flags]")
    print_wrapped__1047_v0 "usage_14615"
    printf '%s\n' ""
    colored_primary__1005_v0 "choose"
    local ret_colored_primary1005_v0__8_18="${ret_colored_primary1005_v0}"
    local title_14637=("${ret_colored_primary1005_v0__8_18}" "-" "Choose" "from" "a" "list" "of" "options.")
    print_wrapped__1047_v0 "title_14637"
    printf '%s\n' ""
    colored_secondary__1006_v0 "Arguments:"
    local ret_colored_secondary1006_v0__11_12="${ret_colored_secondary1006_v0}"
    local array_273=()
    printf__128_v0 "${ret_colored_secondary1006_v0__11_12}""
" array_273[@]
    local arg_names_14639=("[<options> ...]")
    local arg_texts_14640=("List of options to choose from")
    local arg_notes_14641=("")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__1046_v0 "arg_names_14639" "arg_texts_14640" "arg_notes_14641" 20
    printf '%s\n' ""
    colored_secondary__1006_v0 "Flags:"
    local ret_colored_secondary1006_v0__18_12="${ret_colored_secondary1006_v0}"
    local array_277=()
    printf__128_v0 "${ret_colored_secondary1006_v0__18_12}""
" array_277[@]
    local names_14669=("-h, --help" "--limit=<number>" "--no-limit" "--cursor=\"<text>\"" "--header=\"<text>\"" "--page-size=<number>")
    local texts_14670=("Show this help message" "Enable multi-selection mode with a limit of selections" "Enable multi-selection mode with no limit" "Set the cursor text" "Set a header text to display above the options" "Set the number of options per page")
    local notes_14671=("" "" "" "(default: '> ')" "(ANSI escape supported)" "(default: 10)")
    render_help_entries__1046_v0 "names_14669" "texts_14670" "notes_14671" 0
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1366_v0() {
    local options_14608=()
    local command_282
    command_282="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_14609="${command_282}"
    if [ "$([ "_${is_tty_14609}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_14608+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1366_v0=("${options_14608[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1367_v0() {
    local parameters_14591=("${!1}")
    local cursor_14592="> "
    colored_primary__1005_v0 "Choose: "
    local ret_colored_primary1005_v0__17_30="${ret_colored_primary1005_v0}"
    local header_14607="\\x1b[1m""${ret_colored_primary1005_v0__17_30}"
    read_stdin_options__1366_v0 
    local options_14610=("${ret_read_stdin_options1366_v0[@]}")
    local multi_14611=0
    local limit_14612=-1
    local page_size_14613=10
    local __length_286=("${parameters_14591[@]}")
    local slice_upper_285="${#__length_286[@]}"
    local slice_offset_287=2
    local slice_offset_287=$((${slice_offset_287} > 0 ? ${slice_offset_287} : 0))
    local slice_length_288="$(( slice_upper_285 - slice_offset_287 ))"
    local slice_length_288=$((${slice_length_288} > 0 ? ${slice_length_288} : 0))
    for param_14614 in "${parameters_14591[@]:${slice_offset_287}:${slice_length_288}}"; do
        starts_with__22_v0 "${param_14614}" "--cursor="
        local ret_starts_with22_v0__29_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14614}" "--header="
        local ret_starts_with22_v0__32_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14614}" "--limit="
        local ret_starts_with22_v0__35_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_14614}" "--page-size="
        local ret_starts_with22_v0__46_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_14614}" != "_-h" ]; echo $?) || $([ "_${param_14614}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_choose_help__1314_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__29_13}" != 0 ]; then
            local __length_289="--cursor="
            slice__24_v0 "${param_14614}" "${#__length_289}" 0
            cursor_14592="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__32_13}" != 0 ]; then
            local __length_290="--header="
            slice__24_v0 "${param_14614}" "${#__length_290}" 0
            header_14607="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__35_13}" != 0 ]; then
            local __length_291="--limit="
            slice__24_v0 "${param_14614}" "${#__length_291}" 0
            local value_14672="${ret_slice24_v0}"
            parse_int__13_v0 "${value_14672}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1024_v0 "ERROR: Invalid limit value: ""${value_14672}""
" 31
                exit 1
            fi
            limit_14612="${ret_parse_int13_v0}"
            multi_14611=1
        elif [ "$([ "_${param_14614}" != "_--no-limit" ]; echo $?)" != 0 ]; then
            multi_14611=1
        elif [ "${ret_starts_with22_v0__46_13}" != 0 ]; then
            local __length_292="--page-size="
            slice__24_v0 "${param_14614}" "${#__length_292}" 0
            local value_14677="${ret_slice24_v0}"
            parse_int__13_v0 "${value_14677}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1024_v0 "ERROR: Invalid page-size value: ""${value_14677}""
" 31
                exit 1
            fi
            page_size_14613="${ret_parse_int13_v0}"
        else
            options_14610+=("${param_14614}")
        fi
    done
    has_ansi_escape__1036_v0 "${header_14607}"
    local ret_has_ansi_escape1036_v0__59_44="${ret_has_ansi_escape1036_v0}"
    escape_ansi__1037_v0 "${header_14607}"
    local ret_escape_ansi1037_v0__59_73="${ret_escape_ansi1037_v0}"
    colored_primary__1005_v0 "${header_14607}"
    local ret_colored_primary1005_v0__59_111="${ret_colored_primary1005_v0}"
    local display_header_14679
    display_header_14679="$(if [ "$(( $([ "_${header_14607}" != "_" ]; echo $?) || ret_has_ansi_escape1036_v0__59_44 ))" != 0 ]; then echo "${ret_escape_ansi1037_v0__59_73}"; else echo "\\x1b[1m""${ret_colored_primary1005_v0__59_111}"; fi)"
    if [ "${multi_14611}" != 0 ]; then
        xyl_multi_choose__1219_v0 "options_14610" "${cursor_14592}" "${display_header_14679}" "${limit_14612}" "${page_size_14613}"
        local results_14792=("${ret_xyl_multi_choose1219_v0[@]}")
        join__7_v0 results_14792[@] "
"
        ret_execute_choose1367_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1218_v0 "options_14610" "${cursor_14592}" "${display_header_14679}" "${page_size_14613}"
    ret_execute_choose1367_v0="${ret_xyl_choose1218_v0}"
    return 0
}

# Perl Extensions Utilities
command_294="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_53="$([ "_${command_294}" != "_No" ]; echo $?)"
command_295="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_54="$(( $(( ! _perl_disabled_53 )) && $([ "_${command_295}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1542_v0() {
    local text_16554="${1}"
    if [ "$(( ! _perl_available_54 ))" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return 1
    fi
    local command_296
    command_296="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_16554}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return "${__status}"
    fi
    local width_str_16555="${command_296}"
    parse_int__13_v0 "${width_str_16555}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1542_v0=''
        return "${__status}"
    fi
    local width_16556="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1542_v0="${width_16556}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1543_v0() {
    local text_16609="${1}"
    local max_width_16610="${2}"
    if [ "$(( ! _perl_available_54 ))" != 0 ]; then
        ret_perl_truncate_cjk1543_v0=''
        return 1
    fi
    local command_297
    command_297="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_16609}" ${max_width_16610} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1543_v0=''
        return "${__status}"
    fi
    local result_16611="${command_297}"
    ret_perl_truncate_cjk1543_v0="${result_16611}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_55=0
_term_size_56=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1550_v0() {
    local command_299
    command_299="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_16598="${command_299}"
    parse_int__13_v0 "${count_16598}"
    __status=$?
    ret_stty_count1550_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1551_v0() {
    stty_count__1550_v0 
    local count_num_16599="${ret_stty_count1550_v0}"
    if [ "$(( count_num_16599 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_16599="$(( count_num_16599 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16599}
    __status=$?
}

# stty_unlock()
stty_unlock__1552_v0() {
    stty_count__1550_v0 
    local count_num_16675="${ret_stty_count1550_v0}"
    if [ "$(( count_num_16675 > 0 ))" != 0 ]; then
        count_num_16675="$(( count_num_16675 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_16675}
        __status=$?
        if [ "$(( count_num_16675 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1553_v0() {
    local size_16538="${1}"
    if [ "$([ "_${size_16538}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1553_v0=0
        return 0
    fi
    split__4_v0 "${size_16538}" " "
    local parts_16539=("${ret_split4_v0[@]}")
    local __length_300=("${parts_16539[@]}")
    if [ "$(( ${#__length_300[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1553_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_16539[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_16539[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_56=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1553_v0=1
    return 0
}

# query_term_size()
query_term_size__1554_v0() {
    local command_302
    command_302="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_16541="${command_302}"
    store_term_size__1553_v0 "${size_16541}"
    ret_query_term_size1554_v0="${ret_store_term_size1553_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1555_v0() {
    local command_303
    command_303="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_16537="${command_303}"
    store_term_size__1553_v0 "${size_16537}"
    ret_stty_term_size1555_v0="${ret_store_term_size1553_v0}"
    return 0
}

# get_term_size()
get_term_size__1556_v0() {
    stty_term_size__1555_v0 
    local detected_16540="${ret_stty_term_size1555_v0}"
    if [ "$(( ! detected_16540 ))" != 0 ]; then
        query_term_size__1554_v0 
        detected_16540="${ret_query_term_size1554_v0}"
    fi
    _got_term_size_55=1
}

# term_width()
term_width__1558_v0() {
    if [ "$(( ! _got_term_size_55 ))" != 0 ]; then
        get_term_size__1556_v0 
    fi
    ret_term_width1558_v0="${_term_size_56[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_57="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_58=0
_primary_color_59=(3 207 159 92)
_secondary_color_60=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1569_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_16530="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_16530}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_57="No"
        ret_get_supports_truecolor1569_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_57="No"
        ret_get_supports_truecolor1569_v0=0
        return 0
    fi
    local colorterm_16531="${ret_env_var_get120_v0}"
    _supports_truecolor_57="$(if [ "$(( $([ "_${colorterm_16531}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_16531}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1569_v0="$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1570_v0() {
    local message_16525="${1}"
    local r_16526="${2}"
    local g_16527="${3}"
    local b_16528="${4}"
    local fallback_16529="${5}"
    if [ "$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1570_v0="\\x1b[38;2;${r_16526};${g_16527};${b_16528}m""${message_16525}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_57}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1569_v0 
        local ret_get_supports_truecolor1569_v0__50_17="${ret_get_supports_truecolor1569_v0}"
        if [ "${ret_get_supports_truecolor1569_v0__50_17}" != 0 ]; then
            ret_colored_rgb1570_v0="\\x1b[38;2;${r_16526};${g_16527};${b_16528}m""${message_16525}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_16529 == 0 ))" != 0 ]; then
            ret_colored_rgb1570_v0="${message_16525}"
            return 0
        else
            ret_colored_rgb1570_v0="\\x1b[${fallback_16529}m""${message_16525}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_16529 == 0 ))" != 0 ]; then
            ret_colored_rgb1570_v0="${message_16525}"
            return 0
        fi
        ret_colored_rgb1570_v0="\\x1b[${fallback_16529}m""${message_16525}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1571_v0() {
    local message_16648="${1}"
    local r_16649="${2}"
    local g_16650="${3}"
    local b_16651="${4}"
    local fallback_16652="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_16653="${fallback_16652}"
    if [ "$(( $(( fallback_16652 >= 30 )) && $(( fallback_16652 <= 37 )) ))" != 0 ]; then
        bg_fallback_16653="$(( fallback_16652 + 10 ))"
    fi
    if [ "$(( $(( fallback_16652 >= 90 )) && $(( fallback_16652 <= 97 )) ))" != 0 ]; then
        bg_fallback_16653="$(( fallback_16652 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_57}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1571_v0="\\x1b[48;2;${r_16649};${g_16650};${b_16651}m""${message_16648}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_57}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1569_v0 
        local ret_get_supports_truecolor1569_v0__92_17="${ret_get_supports_truecolor1569_v0}"
        if [ "${ret_get_supports_truecolor1569_v0__92_17}" != 0 ]; then
            ret_background_rgb1571_v0="\\x1b[48;2;${r_16649};${g_16650};${b_16651}m""${message_16648}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_16653 == 0 ))" != 0 ]; then
            ret_background_rgb1571_v0="${message_16648}"
            return 0
        else
            ret_background_rgb1571_v0="\\x1b[${bg_fallback_16653}m""${message_16648}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_16653 == 0 ))" != 0 ]; then
            ret_background_rgb1571_v0="${message_16648}"
            return 0
        fi
        ret_background_rgb1571_v0="\\x1b[${bg_fallback_16653}m""${message_16648}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1572_v0() {
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_16519="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_16519}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_16519}" ";"
            local parts_16520=("${ret_split4_v0[@]}")
            local __length_307=("${parts_16520[@]}")
            if [ "$(( ${#__length_307[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16520[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16520[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16520[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16520[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_59=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_16521="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_16521}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_16521}" ";"
            local parts_16522=("${ret_split4_v0[@]}")
            local __length_309=("${parts_16522[@]}")
            if [ "$(( ${#__length_309[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16522[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16522[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16522[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16522[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_60=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_16523="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_16523}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_16523}" ";"
            local parts_16524=("${ret_split4_v0[@]}")
            local __length_311=("${parts_16524[@]}")
            if [ "$(( ${#__length_311[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_16524[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16524[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16524[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_16524[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1572_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_58=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1573_v0() {
    inner_get_xylitol_colors__1572_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_58=1
}

# colored_primary(message: Text)
colored_primary__1574_v0() {
    local message_16518="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    colored_rgb__1570_v0 "${message_16518}" "${_primary_color_59[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_59[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_59[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_59[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1574_v0="${ret_colored_rgb1570_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1575_v0() {
    local message_16558="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    colored_rgb__1570_v0 "${message_16558}" "${_secondary_color_60[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_60[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_60[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_60[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1575_v0="${ret_colored_rgb1570_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1578_v0() {
    local message_16647="${1}"
    if [ "$(( ! _got_xylitol_colors_58 ))" != 0 ]; then
        get_xylitol_colors__1573_v0 
    fi
    background_rgb__1571_v0 "${message_16647}" "${_secondary_color_60[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_60[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_60[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_60[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1578_v0="${ret_background_rgb1571_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1590_v0() {
    local command_313
    command_313="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_16668="${command_313}"
    if [ "$([ "_${var_16668}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="UP"
        return 0
    elif [ "$([ "_${var_16668}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="DOWN"
        return 0
    elif [ "$([ "_${var_16668}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_16668}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="LEFT"
        return 0
    elif [ "$([ "_${var_16668}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_16668}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1590_v0="INPUT"
        return 0
    else
        ret_get_key1590_v0="${var_16668}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1592_v0() {
    local format_16592="${1}"
    local args_16593=("${!2}")
    args_16593=("${format_16592}" "${args_16593[@]}")
    __status=$?
    printf "${args_16593[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1593_v0() {
    local message_16590="${1}"
    local color_16591="${2}"
    # Prints an error message with a specified color.
    local array_314=("${message_16590}")
    eprintf__1592_v0 "\\x1b[${color_16591}m%s\\x1b[0m" array_314[@]
}

# colored(message: Text, color: Int)
colored__1594_v0() {
    local message_16587="${1}"
    local color_16588="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1594_v0="\\x1b[${color_16588}m""${message_16587}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1596_v0() {
    local cnt_16672="${1}"
    if [ "$(( cnt_16672 > 0 ))" != 0 ]; then
        local sequence_16673=""
        local __range_start_16674=0
        local __range_end_16674="${cnt_16672}"
        local __dir_16674=$(( ${__range_start_16674} <= ${__range_end_16674} ? 1 : -1 ))
        for (( ____16674=${__range_start_16674}; ____16674 * ${__dir_16674} < ${__range_end_16674} * ${__dir_16674}; ____16674+=${__dir_16674} )); do
            sequence_16673+="\\x1b[2K\\x1b[1A"
done
        local array_315=("")
        eprintf__1592_v0 "${sequence_16673}" array_315[@]
    fi
    local array_316=("")
    eprintf__1592_v0 "\\x1b[G" array_316[@]
}

# remove_current_line()
remove_current_line__1597_v0() {
    local array_317=("")
    eprintf__1592_v0 "\\x1b[2K\\x1b[G" array_317[@]
}

# go_up(cnt: Int)
go_up__1600_v0() {
    local cnt_16667="${1}"
    local array_318=("")
    eprintf__1592_v0 "\\x1b[${cnt_16667}A" array_318[@]
}

# go_down(cnt: Int)
go_down__1601_v0() {
    local cnt_16671="${1}"
    local array_319=("")
    eprintf__1592_v0 "\\x1b[${cnt_16671}B" array_319[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1603_v0() {
    local array_320=("")
    eprintf__1592_v0 "\\x1b[?25l" array_320[@]
}

# show_cursor()
show_cursor__1604_v0() {
    local array_321=("")
    eprintf__1592_v0 "\\x1b[?25h" array_321[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1605_v0() {
    local text_16547="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_322
    command_322="$([[ "${text_16547}" == *$'\x1b'* || "${text_16547}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_16548="${command_322}"
    ret_has_ansi_escape1605_v0="$([ "_${has_escape_16548}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1606_v0() {
    local text_16594="${1}"
    local command_323
    command_323="$(printf '%s' "${text_16594}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1606_v0="${command_323}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1607_v0() {
    local text_16550="${1}"
    local command_324
    command_324="$(printf "%s" "${text_16550}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1607_v0="${command_324}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1608_v0() {
    local text_16552="${1}"
    local command_325
    command_325="$(printf "%s" "${text_16552}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_16553="${command_325}"
    ret_is_all_ascii1608_v0="$([ "_${result_16553}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1609_v0() {
    local text_16549="${1}"
    strip_ansi__1607_v0 "${text_16549}"
    local stripped_16551="${ret_strip_ansi1607_v0}"
    # Check if text is all ASCII
    is_all_ascii__1608_v0 "${stripped_16551}"
    local ret_is_all_ascii1608_v0__150_12="${ret_is_all_ascii1608_v0}"
    if [ "$(( ! ret_is_all_ascii1608_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1542_v0 "${stripped_16551}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_326="${stripped_16551}"
            ret_get_visible_len1609_v0="${#__length_326}"
            return 0
        fi
        ret_get_visible_len1609_v0="${ret_perl_get_cjk_width1542_v0}"
        return 0
    else
        local __length_327="${stripped_16551}"
        ret_get_visible_len1609_v0="${#__length_327}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1610_v0() {
    local text_16606="${1}"
    local max_width_16607="${2}"
    get_visible_len__1609_v0 "${text_16606}"
    local visible_len_16608="${ret_get_visible_len1609_v0}"
    if [ "$(( visible_len_16608 <= max_width_16607 ))" != 0 ]; then
        ret_truncate_text1610_v0="${text_16606}"
        return 0
    fi
    is_all_ascii__1608_v0 "${text_16606}"
    local ret_is_all_ascii1608_v0__167_12="${ret_is_all_ascii1608_v0}"
    if [ "$(( ! ret_is_all_ascii1608_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1543_v0 "${text_16606}" "${max_width_16607}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_16606}" | cut -c1-${max_width_16607}
            __status=$?
        fi
        ret_truncate_text1610_v0="${ret_perl_truncate_cjk1543_v0}"
        return 0
    fi
    local command_328
    command_328="$(printf "%s" "${text_16606}" | cut -c1-${max_width_16607})"
    __status=$?
    ret_truncate_text1610_v0="${command_328}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1611_v0() {
    local text_16604="${1}"
    local max_width_16605="${2}"
    has_ansi_escape__1605_v0 "${text_16604}"
    local ret_has_ansi_escape1605_v0__179_12="${ret_has_ansi_escape1605_v0}"
    if [ "$(( ! ret_has_ansi_escape1605_v0__179_12 ))" != 0 ]; then
        truncate_text__1610_v0 "${text_16604}" "${max_width_16605}"
        ret_truncate_ansi1611_v0="${ret_truncate_text1610_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_329
    command_329="$([[ "${text_16604}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_16612="${command_329}"
    # Replace \x1b[ with newline, then split
    local command_330
    command_330="$(t="${text_16604}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_16613="${command_330}"
    split__4_v0 "${replaced_16613}" "
"
    local parts_16614=("${ret_split4_v0[@]}")
    local result_16615=""
    local remaining_width_16616="${max_width_16605}"
    local __range_start_16617=0
    local __length_331=("${parts_16614[@]}")
    local __range_end_16617="${#__length_331[@]}"
    local __dir_16617=$(( ${__range_start_16617} <= ${__range_end_16617} ? 1 : -1 ))
    for (( idx_16617=${__range_start_16617}; idx_16617 * ${__dir_16617} < ${__range_end_16617} * ${__dir_16617}; idx_16617+=${__dir_16617} )); do
        local part_16618="${parts_16614[${idx_16617}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_16617 == 0 )) && $([ "_${starts_with_ansi_16612}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_16618}" == "_" ]; echo $?) && $(( remaining_width_16616 > 0 )) ))" != 0 ]; then
                truncate_text__1610_v0 "${part_16618}" "${remaining_width_16616}"
                local ret_truncate_text1610_v0__201_35="${ret_truncate_text1610_v0}"
                local truncated_16619="${ret_truncate_text1610_v0__201_35}"
                result_16615+="${truncated_16619}"
                get_visible_len__1609_v0 "${truncated_16619}"
                local ret_get_visible_len1609_v0__203_36="${ret_get_visible_len1609_v0}"
                remaining_width_16616="$(( remaining_width_16616 - ret_get_visible_len1609_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_332
            command_332="$(__p="${part_16618}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_16620="${command_332}"
            if [ "$([ "_${m_idx_16620}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_333
                command_333="$(__p="${part_16618}"; printf "%s" "${__p:0:${m_idx_16620}}")"
                __status=$?
                local ansi_params_16621="${command_333}"
                result_16615+="\\x1b[""${ansi_params_16621}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_16620}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_16622="${ret_parse_int13_v0__214_41}"
                local text_start_16623="$(( m_idx_num_16622 + 1 ))"
                local command_334
                command_334="$(__p="${part_16618}"; printf "%s" "${__p:${text_start_16623}}")"
                __status=$?
                local text_part_16624="${command_334}"
                if [ "$(( $([ "_${text_part_16624}" == "_" ]; echo $?) && $(( remaining_width_16616 > 0 )) ))" != 0 ]; then
                    truncate_text__1610_v0 "${text_part_16624}" "${remaining_width_16616}"
                    local ret_truncate_text1610_v0__218_39="${ret_truncate_text1610_v0}"
                    local truncated_16625="${ret_truncate_text1610_v0__218_39}"
                    result_16615+="${truncated_16625}"
                    get_visible_len__1609_v0 "${truncated_16625}"
                    local ret_get_visible_len1609_v0__220_40="${ret_get_visible_len1609_v0}"
                    remaining_width_16616="$(( remaining_width_16616 - ret_get_visible_len1609_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_16618}" == "_" ]; echo $?) && $(( remaining_width_16616 > 0 )) ))" != 0 ]; then
                    truncate_text__1610_v0 "${part_16618}" "${remaining_width_16616}"
                    local ret_truncate_text1610_v0__225_39="${ret_truncate_text1610_v0}"
                    local truncated_16626="${ret_truncate_text1610_v0__225_39}"
                    result_16615+="${truncated_16626}"
                    get_visible_len__1609_v0 "${truncated_16626}"
                    local ret_get_visible_len1609_v0__227_40="${ret_get_visible_len1609_v0}"
                    remaining_width_16616="$(( remaining_width_16616 - ret_get_visible_len1609_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1611_v0="${result_16615}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1612_v0() {
    local text_16601="${1}"
    local max_width_16602="${2}"
    get_visible_len__1609_v0 "${text_16601}"
    local visible_len_16603="${ret_get_visible_len1609_v0}"
    if [ "$(( visible_len_16603 <= max_width_16602 ))" != 0 ]; then
        ret_cutoff_text1612_v0="${text_16601}"
        return 0
    fi
    truncate_ansi__1611_v0 "${text_16601}" "$(( max_width_16602 - 3 ))"
    local ret_truncate_ansi1611_v0__243_12="${ret_truncate_ansi1611_v0}"
    ret_cutoff_text1612_v0="${ret_truncate_ansi1611_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1613_v0() {
    local items_16654=("${!1}")
    local total_len_16655="${2}"
    local term_width_16656="${3}"
    local separator_16657=" • "
    local separator_len_16658=3
    # Fast path: no truncation needed
    if [ "$(( total_len_16655 <= term_width_16656 ))" != 0 ]; then
        local iter_16659=0
        while :
        do
            local __length_335=("${items_16654[@]}")
            if [ "$(( iter_16659 >= ${#__length_335[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_16659 > 0 ))" != 0 ]; then
                eprintf_colored__1593_v0 "${separator_16657}" 90
            fi
            colored__1594_v0 "${items_16654[$(( iter_16659 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1594_v0__268_41="${ret_colored1594_v0}"
            local array_336=("")
            eprintf__1592_v0 "${items_16654[${iter_16659}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1594_v0__268_41}" array_336[@]
            iter_16659="$(( iter_16659 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_16660=0
        local first_16661=1
        local iter_16662=0
        while :
        do
            local __length_337=("${items_16654[@]}")
            if [ "$(( iter_16662 >= ${#__length_337[@]} ))" != 0 ]; then
                break
            fi
            local key_16663="${items_16654[${iter_16662}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_16664="${items_16654[$(( iter_16662 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_338="${key_16663}"
            local __length_339="${action_16664}"
            local part_len_16665="$(( $(( ${#__length_338} + 1 )) + ${#__length_339} ))"
            local needed_16666="${part_len_16665}"
            if [ "$(( ! first_16661 ))" != 0 ]; then
                needed_16666="$(( needed_16666 + separator_len_16658 ))"
            fi
            if [ "$(( $(( current_len_16660 + needed_16666 )) > term_width_16656 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_16661 ))" != 0 ]; then
                eprintf_colored__1593_v0 "${separator_16657}" 90
            fi
            colored__1594_v0 "${action_16664}" 2
            local ret_colored1594_v0__296_33="${ret_colored1594_v0}"
            local array_340=("")
            eprintf__1592_v0 "${key_16663}"" ""${ret_colored1594_v0__296_33}" array_340[@]
            current_len_16660="$(( current_len_16660 + needed_16666 ))"
            first_16661=0
            iter_16662="$(( iter_16662 + 2 ))"
        done
    fi
}

# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__1614_v0() {
    local pending_16584="${1}"
    local line_16585="${2}"
    local note_at_16586="${3}"
    if [ "$(( note_at_16586 < 0 ))" != 0 ]; then
        local array_341=()
        printf__128_v0 "${pending_16584}""${line_16585}""
" array_341[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_16586 == 0 ))" != 0 ]; then
        colored__1594_v0 "${line_16585}" 90
        local ret_colored1594_v0__310_40="${ret_colored1594_v0}"
        local array_342=()
        printf__128_v0 "${pending_16584}""${ret_colored1594_v0__310_40}""
" array_342[@]
    else
        slice__24_v0 "${line_16585}" 0 "${note_at_16586}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_16585}" "${note_at_16586}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__1594_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored1594_v0__311_58="${ret_colored1594_v0}"
        local array_343=()
        printf__128_v0 "${pending_16584}""${ret_slice24_v0__311_32}""${ret_colored1594_v0__311_58}""
" array_343[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__1615_v0() {
    local -n names_16562="${1}"
    local -n texts_16563="${2}"
    local -n notes_16564="${3}"
    local min_name_width_16565="${4}"
    local __length_344=("${names_16562[@]}")
    local count_16566="${#__length_344[@]}"
    local name_width_16567="${min_name_width_16565}"
    local __range_start_16568=0
    local __range_end_16568="${count_16566}"
    local __dir_16568=$(( ${__range_start_16568} <= ${__range_end_16568} ? 1 : -1 ))
    for (( i_16568=${__range_start_16568}; i_16568 * ${__dir_16568} < ${__range_end_16568} * ${__dir_16568}; i_16568+=${__dir_16568} )); do
        local __length_345="${names_16562[${i_16568}]?"Index out of bounds (at src/./confirm/../utils.ab:326:33)"}"
        local width_16569="${#__length_345}"
        if [ "$(( width_16569 > name_width_16567 ))" != 0 ]; then
            name_width_16567="${width_16569}"
        fi
done
    term_width__1558_v0 
    local width_16570="${ret_term_width1558_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_16571="$(( name_width_16567 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_16572="$(( $(( width_16570 - indent_16571 )) < 24 ))"
    if [ "${stacked_16572}" != 0 ]; then
        indent_16571=6
    fi
    local avail_16573="$(( width_16570 - indent_16571 ))"
    rpad__28_v0 "" " " "${indent_16571}"
    local blank_16574="${ret_rpad28_v0}"
    local __range_start_16575=0
    local __range_end_16575="${count_16566}"
    local __dir_16575=$(( ${__range_start_16575} <= ${__range_end_16575} ? 1 : -1 ))
    for (( i_16575=${__range_start_16575}; i_16575 * ${__dir_16575} < ${__range_end_16575} * ${__dir_16575}; i_16575+=${__dir_16575} )); do
        local pending_16576="${blank_16574}"
        if [ "${stacked_16572}" != 0 ]; then
            local array_346=()
            printf__128_v0 "  ""${names_16562[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:346:33)"}""
" array_346[@]
        else
            rpad__28_v0 "  ""${names_16562[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:348:41)"}" " " "${indent_16571}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_16576="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_16563[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_16577=("${ret_split4_v0__350_21[@]}")
        local __length_347=("${words_16577[@]}")
        local note_start_16578="${#__length_347[@]}"
        if [ "$([ "_${notes_16564[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_348="${notes_16564[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_348} > avail_16573 ))" != 0 ]; then
                split__4_v0 "${notes_16564[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_16577+=("${ret_split4_v0__356_26[@]}")
            else
                local array_349=("${notes_16564[${i_16575}]?"Index out of bounds (at src/./confirm/../utils.ab:358:33)"}")
                words_16577+=("${array_349[@]}")
            fi
        fi
        local line_16579=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_16580=-1
        local __range_start_16581=0
        local __length_350=("${words_16577[@]}")
        local __range_end_16581="${#__length_350[@]}"
        local __dir_16581=$(( ${__range_start_16581} <= ${__range_end_16581} ? 1 : -1 ))
        for (( j_16581=${__range_start_16581}; j_16581 * ${__dir_16581} < ${__range_end_16581} * ${__dir_16581}; j_16581+=${__dir_16581} )); do
            local word_16582="${words_16577[${j_16581}]?"Index out of bounds (at src/./confirm/../utils.ab:368:32)"}"
            local candidate_16583
            candidate_16583="$(if [ "$([ "_${line_16579}" != "_" ]; echo $?)" != 0 ]; then echo "${word_16582}"; else echo "${line_16579}"" ""${word_16582}"; fi)"
            local __length_351="${candidate_16583}"
            if [ "$(( $(( ${#__length_351} > avail_16573 )) && $([ "_${line_16579}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__1614_v0 "${pending_16576}" "${line_16579}" "${note_at_16580}"
                pending_16576="${blank_16574}"
                line_16579="${word_16582}"
                note_at_16580="$(if [ "$(( j_16581 >= note_start_16578 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_16581 >= note_start_16578 )) && $(( note_at_16580 < 0 )) ))" != 0 ]; then
                    local __length_352="${candidate_16583}"
                    local __length_353="${word_16582}"
                    note_at_16580="$(( ${#__length_352} - ${#__length_353} ))"
                fi
                line_16579="${candidate_16583}"
            fi
done
        print_help_line__1614_v0 "${pending_16576}" "${line_16579}" "${note_at_16580}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__1616_v0() {
    local -n pieces_16536="${1}"
    term_width__1558_v0 
    local width_16542="${ret_term_width1558_v0}"
    local line_16543=""
    local line_len_16544=0
    for piece_16545 in "${pieces_16536[@]}"; do
        local __length_356="${piece_16545}"
        local piece_len_16546="${#__length_356}"
        has_ansi_escape__1605_v0 "${piece_16545}"
        local ret_has_ansi_escape1605_v0__397_12="${ret_has_ansi_escape1605_v0}"
        if [ "${ret_has_ansi_escape1605_v0__397_12}" != 0 ]; then
            get_visible_len__1609_v0 "${piece_16545}"
            piece_len_16546="${ret_get_visible_len1609_v0}"
        fi
        if [ "$([ "_${line_16543}" != "_" ]; echo $?)" != 0 ]; then
            line_16543="${piece_16545}"
            line_len_16544="${piece_len_16546}"
        elif [ "$(( $(( $(( line_len_16544 + 1 )) + piece_len_16546 )) > width_16542 ))" != 0 ]; then
            local array_357=()
            printf__128_v0 "${line_16543}""
" array_357[@]
            line_16543="${piece_16545}"
            line_len_16544="${piece_len_16546}"
        else
            line_16543+=" ""${piece_16545}"
            line_len_16544="$(( line_len_16544 + $(( 1 + piece_len_16546 )) ))"
        fi
    done
    if [ "$([ "_${line_16543}" == "_" ]; echo $?)" != 0 ]; then
        local array_358=()
        printf__128_v0 "${line_16543}""
" array_358[@]
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1667_v0() {
    local selected_16628="${1}"
    local term_width_16629="${2}"
    local small_16630="$(( term_width_16629 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_16630}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_16644="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_16630}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_16645="${ret_cpad29_v0}"
    local gap_16646
    gap_16646="$(if [ "${small_16630}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_359=("")
    eprintf__1592_v0 " " array_359[@]
    if [ "${selected_16628}" != 0 ]; then
        # Yes selected
        background_secondary__1578_v0 "${yes_label_16644}"
        local ret_background_secondary1578_v0__16_30="${ret_background_secondary1578_v0}"
        local array_360=("")
        eprintf__1592_v0 "\\x1b[97m""${ret_background_secondary1578_v0__16_30}" array_360[@]
        local array_361=("")
        eprintf__1592_v0 "${gap_16646}" array_361[@]
        # No not selected (dim)
        local array_362=("")
        eprintf__1592_v0 "\\x1b[49;37m""${no_label_16645}""\\x1b[0m" array_362[@]
    else
        # No selected
        local array_363=("")
        eprintf__1592_v0 "\\x1b[49;37m""${yes_label_16644}""\\x1b[0m" array_363[@]
        local array_364=("")
        eprintf__1592_v0 "${gap_16646}" array_364[@]
        background_secondary__1578_v0 "${no_label_16645}"
        local ret_background_secondary1578_v0__24_30="${ret_background_secondary1578_v0}"
        local array_365=("")
        eprintf__1592_v0 "\\x1b[97m""${ret_background_secondary1578_v0__24_30}" array_365[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1668_v0() {
    local header_16596="${1}"
    local default_yes_16597="${2}"
    stty_lock__1551_v0 
    hide_cursor__1603_v0 
    term_width__1558_v0 
    local term_width_16600="${ret_term_width1558_v0}"
    if [ "$([ "_${header_16596}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1612_v0 "${header_16596}" "${term_width_16600}"
        local ret_cutoff_text1612_v0__46_17="${ret_cutoff_text1612_v0}"
        local array_366=("")
        eprintf__1592_v0 "${ret_cutoff_text1612_v0__46_17}""

" array_366[@]
    fi
    local selected_16627="${default_yes_16597}"
    # Render initial options
    render_confirm_options__1667_v0 "${selected_16627}" "${term_width_16600}"
    local array_367=("")
    eprintf__1592_v0 "

" array_367[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_368=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1613_v0 array_368[@] 40 "${term_width_16600}"
    go_up__1600_v0 2
    while :
    do
        get_key__1590_v0 
        local key_16669="${ret_get_key1590_v0}"
        if [ "$(( $(( $(( $([ "_${key_16669}" != "_LEFT" ]; echo $?) || $([ "_${key_16669}" != "_h" ]; echo $?) )) || $([ "_${key_16669}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_16669}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_16627}" != 0 ]; then
                selected_16627=0
                local array_369=("")
                eprintf__1592_v0 "\\x1b[G\\x1b[K" array_369[@]
                render_confirm_options__1667_v0 "${selected_16627}" "${term_width_16600}"
            elif [ "$(( ! selected_16627 ))" != 0 ]; then
                selected_16627=1
                local array_370=("")
                eprintf__1592_v0 "\\x1b[G\\x1b[K" array_370[@]
                render_confirm_options__1667_v0 "${selected_16627}" "${term_width_16600}"
            fi
        elif [ "$(( $([ "_${key_16669}" != "_y" ]; echo $?) || $([ "_${key_16669}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_16627=1
            break
        elif [ "$(( $([ "_${key_16669}" != "_n" ]; echo $?) || $([ "_${key_16669}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_16627=0
            break
        elif [ "$([ "_${key_16669}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_16670=4
    if [ "$([ "_${header_16596}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_16670="$(( total_lines_16670 + 1 ))"
    fi
    go_down__1601_v0 2
    remove_line__1596_v0 "$(( total_lines_16670 - 1 ))"
    remove_current_line__1597_v0 
    stty_unlock__1552_v0 
    show_cursor__1604_v0 
    ret_xyl_confirm1668_v0="${selected_16627}"
    return 0
}

# print_confirm_help()
print_confirm_help__1762_v0() {
    local usage_16535=("Usage:" "./xylitol.sh" "confirm" "[flags]")
    print_wrapped__1616_v0 "usage_16535"
    printf '%s\n' ""
    colored_primary__1574_v0 "confirm"
    local ret_colored_primary1574_v0__8_18="${ret_colored_primary1574_v0}"
    local title_16557=("${ret_colored_primary1574_v0__8_18}" "-" "Display" "a" "Yes/No" "confirmation" "dialog.")
    print_wrapped__1616_v0 "title_16557"
    printf '%s\n' ""
    colored_secondary__1575_v0 "Flags:"
    local ret_colored_secondary1575_v0__11_12="${ret_colored_secondary1575_v0}"
    local array_373=()
    printf__128_v0 "${ret_colored_secondary1575_v0__11_12}""
" array_373[@]
    local names_16559=("-h, --help" "--header=\"<text>\"" "--default=<yes|no>")
    local texts_16560=("Show this help message" "Set a header text to display above the options" "Set the default selection")
    local notes_16561=("" "(ANSI escape supported)" "(default: yes)")
    render_help_entries__1615_v0 "names_16559" "texts_16560" "notes_16561" 0
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1814_v0() {
    local parameters_16517=("${!1}")
    colored_primary__1574_v0 "Are you sure?"
    local ret_colored_primary1574_v0__9_30="${ret_colored_primary1574_v0}"
    local header_16532="\\x1b[1m""${ret_colored_primary1574_v0__9_30}"
    local default_yes_16533=1
    for param_16534 in "${parameters_16517[@]}"; do
        starts_with__22_v0 "${param_16534}" "--header="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_16534}" "--default="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_16534}" != "_-h" ]; echo $?) || $([ "_${param_16534}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_confirm_help__1762_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_379="--header="
            slice__24_v0 "${param_16534}" "${#__length_379}" 0
            header_16532="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_380="--default="
            slice__24_v0 "${param_16534}" "${#__length_380}" 0
            local value_16589="${ret_slice24_v0}"
            if [ "$(( $([ "_${value_16589}" != "_yes" ]; echo $?) || $([ "_${value_16589}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_16533=1
            elif [ "$(( $([ "_${value_16589}" != "_no" ]; echo $?) || $([ "_${value_16589}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_16533=0
            else
                eprintf_colored__1593_v0 "ERROR: Invalid default value: ""${value_16589}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1605_v0 "${header_16532}"
    local ret_has_ansi_escape1605_v0__35_44="${ret_has_ansi_escape1605_v0}"
    escape_ansi__1606_v0 "${header_16532}"
    local ret_escape_ansi1606_v0__35_73="${ret_escape_ansi1606_v0}"
    colored_primary__1574_v0 "${header_16532}"
    local ret_colored_primary1574_v0__35_111="${ret_colored_primary1574_v0}"
    local display_header_16595
    display_header_16595="$(if [ "$(( $([ "_${header_16532}" != "_" ]; echo $?) || ret_has_ansi_escape1605_v0__35_44 ))" != 0 ]; then echo "${ret_escape_ansi1606_v0__35_73}"; else echo "\\x1b[1m""${ret_colored_primary1574_v0__35_111}"; fi)"
    xyl_confirm__1668_v0 "${display_header_16595}" "${default_yes_16533}"
    local result_16676="${ret_xyl_confirm1668_v0}"
    ret_execute_confirm1814_v0="$(if [ "${result_16676}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# get_directory_entries(path: Text, names: [Text], types: [Text], targets: [Text])
get_directory_entries__1969_v0() {
    local path_25124="${1}"
    local -n names_25125="${2}"
    local -n types_25126="${3}"
    local -n targets_25127="${4}"
    local __ls_path_381="${path_25124}"
    __ls_path_381="${__ls_path_381//\\/\\\\}"
    (( 1 )) && __ls_all_381="-A" || __ls_all_381=""
    (( 0 )) && __ls_rec_381="-R" || __ls_rec_381=""
    local __ls_381=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_381 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_381} ${__ls_rec_381} ${__ls_path_381}
    __status=$?
    );
    names_25125+=("${__ls_381[@]}")
    local command_382
    command_382="$(LC_ALL=C ls -lA "${path_25124}" 2>/dev/null | tail -n +2 | sed 's/^\(.\).*/\1/')"
    __status=$?
    local types_output_25128="${command_382}"
    # The blanking expression runs first, otherwise it would also match the
    # already rewritten target of a symbolic link. Every line is then given a
    # leading ":" because `split` treats newlines as whitespace and would
    # collapse the empty lines that non-link entries produce.
    local command_383
    command_383="$(LC_ALL=C ls -lA "${path_25124}" 2>/dev/null | tail -n +2 | sed -e '/^l/!s/.*//' -e '/^l/s/.* -> //' -e 's/^/:/')"
    __status=$?
    local targets_output_25129="${command_383}"
    split__4_v0 "${types_output_25128}" "
"
    types_25126+=("${ret_split4_v0[@]}")
    split__4_v0 "${targets_output_25129}" "
"
    local ret_split4_v0__21_19=("${ret_split4_v0[@]}")
    for marked_25130 in "${ret_split4_v0__21_19[@]}"; do
        slice__24_v0 "${marked_25130}" 1 0
        local ret_slice24_v0__22_21="${ret_slice24_v0}"
        targets_25127+=("${ret_slice24_v0__22_21}")
    done
}

# get_cwd()
get_cwd__1970_v0() {
    local command_387
    command_387="$(pwd)"
    __status=$?
    ret_get_cwd1970_v0="${command_387}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1971_v0() {
    local path_25119="${1}"
    local command_388
    command_388="$(cd "${path_25119}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_25120="${command_388}"
    if [ "$([ "_${normalized_25120}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1971_v0="${path_25119}"
        return 0
    fi
    ret_normalize_path1971_v0="${normalized_25120}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1972_v0() {
    local base_25286="${1}"
    local child_25287="${2}"
    if [ "$([ "_${base_25286}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1972_v0="/""${child_25287}"
        return 0
    fi
    ret_path_join1972_v0="${base_25286}""/""${child_25287}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1973_v0() {
    local path_25284="${1}"
    local command_389
    command_389="$(dirname "${path_25284}")"
    __status=$?
    local parent_25285="${command_389}"
    ret_get_parent_dir1973_v0="${parent_25285}"
    return 0
}

# Perl Extensions Utilities
command_390="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_62="$([ "_${command_390}" != "_No" ]; echo $?)"
command_391="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_63="$(( $(( ! _perl_disabled_62 )) && $([ "_${command_391}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1981_v0() {
    local text_25055="${1}"
    if [ "$(( ! _perl_available_63 ))" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return 1
    fi
    local command_392
    command_392="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_25055}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return "${__status}"
    fi
    local width_str_25056="${command_392}"
    parse_int__13_v0 "${width_str_25056}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1981_v0=''
        return "${__status}"
    fi
    local width_25057="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1981_v0="${width_25057}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_64=0
_term_size_65=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__1989_v0() {
    local command_394
    command_394="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_25116="${command_394}"
    parse_int__13_v0 "${count_25116}"
    __status=$?
    ret_stty_count1989_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__1990_v0() {
    stty_count__1989_v0 
    local count_num_25117="${ret_stty_count1989_v0}"
    if [ "$(( count_num_25117 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_25117="$(( count_num_25117 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25117}
    __status=$?
}

# stty_unlock()
stty_unlock__1991_v0() {
    stty_count__1989_v0 
    local count_num_25137="${ret_stty_count1989_v0}"
    if [ "$(( count_num_25137 > 0 ))" != 0 ]; then
        count_num_25137="$(( count_num_25137 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25137}
        __status=$?
        if [ "$(( count_num_25137 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__1992_v0() {
    local size_25039="${1}"
    if [ "$([ "_${size_25039}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size1992_v0=0
        return 0
    fi
    split__4_v0 "${size_25039}" " "
    local parts_25040=("${ret_split4_v0[@]}")
    local __length_395=("${parts_25040[@]}")
    if [ "$(( ${#__length_395[@]} != 2 ))" != 0 ]; then
        ret_store_term_size1992_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_25040[1]?"Index out of bounds (at src/./file/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_25040[0]?"Index out of bounds (at src/./file/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_65=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size1992_v0=1
    return 0
}

# query_term_size()
query_term_size__1993_v0() {
    local command_397
    command_397="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_25042="${command_397}"
    store_term_size__1992_v0 "${size_25042}"
    ret_query_term_size1993_v0="${ret_store_term_size1992_v0}"
    return 0
}

# stty_term_size()
stty_term_size__1994_v0() {
    local command_398
    command_398="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_25038="${command_398}"
    store_term_size__1992_v0 "${size_25038}"
    ret_stty_term_size1994_v0="${ret_store_term_size1992_v0}"
    return 0
}

# get_term_size()
get_term_size__1995_v0() {
    stty_term_size__1994_v0 
    local detected_25041="${ret_stty_term_size1994_v0}"
    if [ "$(( ! detected_25041 ))" != 0 ]; then
        query_term_size__1993_v0 
        detected_25041="${ret_query_term_size1993_v0}"
    fi
    _got_term_size_64=1
}

# term_width()
term_width__1997_v0() {
    if [ "$(( ! _got_term_size_64 ))" != 0 ]; then
        get_term_size__1995_v0 
    fi
    ret_term_width1997_v0="${_term_size_65[0]?"Index out of bounds (at src/./file/../utils/term.ab:93:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_66="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_67=0
_primary_color_68=(3 207 159 92)
_secondary_color_69=(3 118 206 94)
_accent_color_70=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__2008_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_25070="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_25070}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_66="No"
        ret_get_supports_truecolor2008_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_66="No"
        ret_get_supports_truecolor2008_v0=0
        return 0
    fi
    local colorterm_25071="${ret_env_var_get120_v0}"
    _supports_truecolor_66="$(if [ "$(( $([ "_${colorterm_25071}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_25071}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2008_v0="$([ "_${_supports_truecolor_66}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2009_v0() {
    local message_25065="${1}"
    local r_25066="${2}"
    local g_25067="${3}"
    local b_25068="${4}"
    local fallback_25069="${5}"
    if [ "$([ "_${_supports_truecolor_66}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2009_v0="\\x1b[38;2;${r_25066};${g_25067};${b_25068}m""${message_25065}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_66}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2008_v0 
        local ret_get_supports_truecolor2008_v0__50_17="${ret_get_supports_truecolor2008_v0}"
        if [ "${ret_get_supports_truecolor2008_v0__50_17}" != 0 ]; then
            ret_colored_rgb2009_v0="\\x1b[38;2;${r_25066};${g_25067};${b_25068}m""${message_25065}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_25069 == 0 ))" != 0 ]; then
            ret_colored_rgb2009_v0="${message_25065}"
            return 0
        else
            ret_colored_rgb2009_v0="\\x1b[${fallback_25069}m""${message_25065}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_25069 == 0 ))" != 0 ]; then
            ret_colored_rgb2009_v0="${message_25065}"
            return 0
        fi
        ret_colored_rgb2009_v0="\\x1b[${fallback_25069}m""${message_25065}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2011_v0() {
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_25059="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_25059}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_25059}" ";"
            local parts_25060=("${ret_split4_v0[@]}")
            local __length_402=("${parts_25060[@]}")
            if [ "$(( ${#__length_402[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25060[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25060[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25060[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25060[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_68=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_25061="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_25061}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_25061}" ";"
            local parts_25062=("${ret_split4_v0[@]}")
            local __length_404=("${parts_25062[@]}")
            if [ "$(( ${#__length_404[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25062[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25062[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25062[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25062[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_69=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_25063="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_25063}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_25063}" ";"
            local parts_25064=("${ret_split4_v0[@]}")
            local __length_406=("${parts_25064[@]}")
            if [ "$(( ${#__length_406[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25064[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25064[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25064[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25064[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2011_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_70=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_67=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2012_v0() {
    inner_get_xylitol_colors__2011_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_67=1
}

# colored_primary(message: Text)
colored_primary__2013_v0() {
    local message_25058="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25058}" "${_primary_color_68[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_68[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_68[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_68[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary2013_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__2014_v0() {
    local message_25073="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25073}" "${_secondary_color_69[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_69[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_69[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_69[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2014_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__2015_v0() {
    local message_25223="${1}"
    if [ "$(( ! _got_xylitol_colors_67 ))" != 0 ]; then
        get_xylitol_colors__2012_v0 
    fi
    colored_rgb__2009_v0 "${message_25223}" "${_accent_color_70[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_70[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_70[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_70[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent2015_v0="${ret_colored_rgb2009_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__2031_v0() {
    local format_25110="${1}"
    local args_25111=("${!2}")
    args_25111=("${format_25110}" "${args_25111[@]}")
    __status=$?
    printf "${args_25111[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2032_v0() {
    local message_25108="${1}"
    local color_25109="${2}"
    # Prints an error message with a specified color.
    local array_408=("${message_25108}")
    eprintf__2031_v0 "\\x1b[${color_25109}m%s\\x1b[0m" array_408[@]
}

# colored(message: Text, color: Int)
colored__2033_v0() {
    local message_25102="${1}"
    local color_25103="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2033_v0="\\x1b[${color_25103}m""${message_25102}""\\x1b[0m"
    return 0
}

# remove_current_line()
remove_current_line__2036_v0() {
    local array_409=("")
    eprintf__2031_v0 "\\x1b[2K\\x1b[G" array_409[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2044_v0() {
    local text_25048="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_410
    command_410="$([[ "${text_25048}" == *$'\x1b'* || "${text_25048}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_25049="${command_410}"
    ret_has_ansi_escape2044_v0="$([ "_${has_escape_25049}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2046_v0() {
    local text_25051="${1}"
    local command_411
    command_411="$(printf "%s" "${text_25051}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2046_v0="${command_411}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2047_v0() {
    local text_25053="${1}"
    local command_412
    command_412="$(printf "%s" "${text_25053}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_25054="${command_412}"
    ret_is_all_ascii2047_v0="$([ "_${result_25054}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2048_v0() {
    local text_25050="${1}"
    strip_ansi__2046_v0 "${text_25050}"
    local stripped_25052="${ret_strip_ansi2046_v0}"
    # Check if text is all ASCII
    is_all_ascii__2047_v0 "${stripped_25052}"
    local ret_is_all_ascii2047_v0__150_12="${ret_is_all_ascii2047_v0}"
    if [ "$(( ! ret_is_all_ascii2047_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1981_v0 "${stripped_25052}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_413="${stripped_25052}"
            ret_get_visible_len2048_v0="${#__length_413}"
            return 0
        fi
        ret_get_visible_len2048_v0="${ret_perl_get_cjk_width1981_v0}"
        return 0
    else
        local __length_414="${stripped_25052}"
        ret_get_visible_len2048_v0="${#__length_414}"
        return 0
    fi
}

# // Application Utilities /////
# print_help_line(pending: Text, line: Text, note_at: Int)
print_help_line__2053_v0() {
    local pending_25099="${1}"
    local line_25100="${2}"
    local note_at_25101="${3}"
    if [ "$(( note_at_25101 < 0 ))" != 0 ]; then
        local array_415=()
        printf__128_v0 "${pending_25099}""${line_25100}""
" array_415[@]
    # A length of zero means "to the end" in `slice`, so a line that is
    # all note has to be handled on its own.
    elif [ "$(( note_at_25101 == 0 ))" != 0 ]; then
        colored__2033_v0 "${line_25100}" 90
        local ret_colored2033_v0__310_40="${ret_colored2033_v0}"
        local array_416=()
        printf__128_v0 "${pending_25099}""${ret_colored2033_v0__310_40}""
" array_416[@]
    else
        slice__24_v0 "${line_25100}" 0 "${note_at_25101}"
        local ret_slice24_v0__311_32="${ret_slice24_v0}"
        slice__24_v0 "${line_25100}" "${note_at_25101}" 0
        local ret_slice24_v0__311_66="${ret_slice24_v0}"
        colored__2033_v0 "${ret_slice24_v0__311_66}" 90
        local ret_colored2033_v0__311_58="${ret_colored2033_v0}"
        local array_417=()
        printf__128_v0 "${pending_25099}""${ret_slice24_v0__311_32}""${ret_colored2033_v0__311_58}""
" array_417[@]
    fi
}

# render_help_entries(names: [Text], texts: [Text], notes: [Text], min_name_width: Int)
render_help_entries__2054_v0() {
    local -n names_25077="${1}"
    local -n texts_25078="${2}"
    local -n notes_25079="${3}"
    local min_name_width_25080="${4}"
    local __length_418=("${names_25077[@]}")
    local count_25081="${#__length_418[@]}"
    local name_width_25082="${min_name_width_25080}"
    local __range_start_25083=0
    local __range_end_25083="${count_25081}"
    local __dir_25083=$(( ${__range_start_25083} <= ${__range_end_25083} ? 1 : -1 ))
    for (( i_25083=${__range_start_25083}; i_25083 * ${__dir_25083} < ${__range_end_25083} * ${__dir_25083}; i_25083+=${__dir_25083} )); do
        local __length_419="${names_25077[${i_25083}]?"Index out of bounds (at src/./file/../utils.ab:326:33)"}"
        local width_25084="${#__length_419}"
        if [ "$(( width_25084 > name_width_25082 ))" != 0 ]; then
            name_width_25082="${width_25084}"
        fi
done
    term_width__1997_v0 
    local width_25085="${ret_term_width1997_v0}"
    # Two spaces of margin, then three between a name and its description.
    local indent_25086="$(( name_width_25082 + 5 ))"
    # Once the description column gets too narrow to read, stop putting the
    # description beside the name and place it underneath instead.
    local stacked_25087="$(( $(( width_25085 - indent_25086 )) < 24 ))"
    if [ "${stacked_25087}" != 0 ]; then
        indent_25086=6
    fi
    local avail_25088="$(( width_25085 - indent_25086 ))"
    rpad__28_v0 "" " " "${indent_25086}"
    local blank_25089="${ret_rpad28_v0}"
    local __range_start_25090=0
    local __range_end_25090="${count_25081}"
    local __dir_25090=$(( ${__range_start_25090} <= ${__range_end_25090} ? 1 : -1 ))
    for (( i_25090=${__range_start_25090}; i_25090 * ${__dir_25090} < ${__range_end_25090} * ${__dir_25090}; i_25090+=${__dir_25090} )); do
        local pending_25091="${blank_25089}"
        if [ "${stacked_25087}" != 0 ]; then
            local array_420=()
            printf__128_v0 "  ""${names_25077[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:346:33)"}""
" array_420[@]
        else
            rpad__28_v0 "  ""${names_25077[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:348:41)"}" " " "${indent_25086}"
            local ret_rpad28_v0__348_23="${ret_rpad28_v0}"
            pending_25091="${ret_rpad28_v0__348_23}"
        fi
        split__4_v0 "${texts_25078[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:350:33)"}" " "
        local ret_split4_v0__350_21=("${ret_split4_v0[@]}")
        local words_25092=("${ret_split4_v0__350_21[@]}")
        local __length_421=("${words_25092[@]}")
        local note_start_25093="${#__length_421[@]}"
        if [ "$([ "_${notes_25079[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:352:18)"}" == "_" ]; echo $?)" != 0 ]; then
            # A note reads badly when split, so it moves between lines whole
            # unless it is too long to ever fit on one.
            local __length_422="${notes_25079[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:355:26)"}"
            if [ "$(( ${#__length_422} > avail_25088 ))" != 0 ]; then
                split__4_v0 "${notes_25079[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:356:38)"}" " "
                local ret_split4_v0__356_26=("${ret_split4_v0[@]}")
                words_25092+=("${ret_split4_v0__356_26[@]}")
            else
                local array_423=("${notes_25079[${i_25090}]?"Index out of bounds (at src/./file/../utils.ab:358:33)"}")
                words_25092+=("${array_423[@]}")
            fi
        fi
        local line_25094=""
        # Where the note begins on the line being built, so it can be dimmed
        # after wrapping decides how much of it fits. -1 while there is none.
        local note_at_25095=-1
        local __range_start_25096=0
        local __length_424=("${words_25092[@]}")
        local __range_end_25096="${#__length_424[@]}"
        local __dir_25096=$(( ${__range_start_25096} <= ${__range_end_25096} ? 1 : -1 ))
        for (( j_25096=${__range_start_25096}; j_25096 * ${__dir_25096} < ${__range_end_25096} * ${__dir_25096}; j_25096+=${__dir_25096} )); do
            local word_25097="${words_25092[${j_25096}]?"Index out of bounds (at src/./file/../utils.ab:368:32)"}"
            local candidate_25098
            candidate_25098="$(if [ "$([ "_${line_25094}" != "_" ]; echo $?)" != 0 ]; then echo "${word_25097}"; else echo "${line_25094}"" ""${word_25097}"; fi)"
            local __length_425="${candidate_25098}"
            if [ "$(( $(( ${#__length_425} > avail_25088 )) && $([ "_${line_25094}" == "_" ]; echo $?) ))" != 0 ]; then
                print_help_line__2053_v0 "${pending_25091}" "${line_25094}" "${note_at_25095}"
                pending_25091="${blank_25089}"
                line_25094="${word_25097}"
                note_at_25095="$(if [ "$(( j_25096 >= note_start_25093 ))" != 0 ]; then echo 0; else echo -1; fi)"
            else
                if [ "$(( $(( j_25096 >= note_start_25093 )) && $(( note_at_25095 < 0 )) ))" != 0 ]; then
                    local __length_426="${candidate_25098}"
                    local __length_427="${word_25097}"
                    note_at_25095="$(( ${#__length_426} - ${#__length_427} ))"
                fi
                line_25094="${candidate_25098}"
            fi
done
        print_help_line__2053_v0 "${pending_25091}" "${line_25094}" "${note_at_25095}"
done
}

# print_wrapped(pieces: [Text])
print_wrapped__2055_v0() {
    local -n pieces_25037="${1}"
    term_width__1997_v0 
    local width_25043="${ret_term_width1997_v0}"
    local line_25044=""
    local line_len_25045=0
    for piece_25046 in "${pieces_25037[@]}"; do
        local __length_430="${piece_25046}"
        local piece_len_25047="${#__length_430}"
        has_ansi_escape__2044_v0 "${piece_25046}"
        local ret_has_ansi_escape2044_v0__397_12="${ret_has_ansi_escape2044_v0}"
        if [ "${ret_has_ansi_escape2044_v0__397_12}" != 0 ]; then
            get_visible_len__2048_v0 "${piece_25046}"
            piece_len_25047="${ret_get_visible_len2048_v0}"
        fi
        if [ "$([ "_${line_25044}" != "_" ]; echo $?)" != 0 ]; then
            line_25044="${piece_25046}"
            line_len_25045="${piece_len_25047}"
        elif [ "$(( $(( $(( line_len_25045 + 1 )) + piece_len_25047 )) > width_25043 ))" != 0 ]; then
            local array_431=()
            printf__128_v0 "${line_25044}""
" array_431[@]
            line_25044="${piece_25046}"
            line_len_25045="${piece_len_25047}"
        else
            line_25044+=" ""${piece_25046}"
            line_len_25045="$(( line_len_25045 + $(( 1 + piece_len_25047 )) ))"
        fi
    done
    if [ "$([ "_${line_25044}" == "_" ]; echo $?)" != 0 ]; then
        local array_432=()
        printf__128_v0 "${line_25044}""
" array_432[@]
    fi
}

# Perl Extensions Utilities
command_433="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_71="$([ "_${command_433}" != "_No" ]; echo $?)"
command_434="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_72="$(( $(( ! _perl_disabled_71 )) && $([ "_${command_434}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2206_v0() {
    local text_25163="${1}"
    if [ "$(( ! _perl_available_72 ))" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return 1
    fi
    local command_435
    command_435="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_25163}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return "${__status}"
    fi
    local width_str_25164="${command_435}"
    parse_int__13_v0 "${width_str_25164}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2206_v0=''
        return "${__status}"
    fi
    local width_25165="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2206_v0="${width_25165}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2207_v0() {
    local text_25174="${1}"
    local max_width_25175="${2}"
    if [ "$(( ! _perl_available_72 ))" != 0 ]; then
        ret_perl_truncate_cjk2207_v0=''
        return 1
    fi
    local command_436
    command_436="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_25174}" ${max_width_25175} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2207_v0=''
        return "${__status}"
    fi
    local result_25176="${command_436}"
    ret_perl_truncate_cjk2207_v0="${result_25176}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_73=0
_term_size_74=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_count()
stty_count__2214_v0() {
    local command_438
    command_438="$(c="${XYLITOL_RUNTIME_STTY_COUNT:-0}"; [[ "$c" =~ ^[0-9]+$ ]] && echo "$c" || echo 0)"
    __status=$?
    local count_25145="${command_438}"
    parse_int__13_v0 "${count_25145}"
    __status=$?
    ret_stty_count2214_v0="${ret_parse_int13_v0}"
    return 0
}

# stty_lock()
stty_lock__2215_v0() {
    stty_count__2214_v0 
    local count_num_25146="${ret_stty_count2214_v0}"
    if [ "$(( count_num_25146 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_25146="$(( count_num_25146 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25146}
    __status=$?
}

# stty_unlock()
stty_unlock__2216_v0() {
    stty_count__2214_v0 
    local count_num_25281="${ret_stty_count2214_v0}"
    if [ "$(( count_num_25281 > 0 ))" != 0 ]; then
        count_num_25281="$(( count_num_25281 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_25281}
        __status=$?
        if [ "$(( count_num_25281 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# store_term_size(size: Text)
store_term_size__2217_v0() {
    local size_25150="${1}"
    if [ "$([ "_${size_25150}" != "_" ]; echo $?)" != 0 ]; then
        ret_store_term_size2217_v0=0
        return 0
    fi
    split__4_v0 "${size_25150}" " "
    local parts_25151=("${ret_split4_v0[@]}")
    local __length_439=("${parts_25151[@]}")
    if [ "$(( ${#__length_439[@]} != 2 ))" != 0 ]; then
        ret_store_term_size2217_v0=0
        return 0
    fi
    parse_int__13_v0 "${parts_25151[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:41)"}"
    __status=$?
    local ret_parse_int13_v0__50_25="${ret_parse_int13_v0}"
    parse_int__13_v0 "${parts_25151[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:50:68)"}"
    __status=$?
    local ret_parse_int13_v0__50_52="${ret_parse_int13_v0}"
    _term_size_74=("${ret_parse_int13_v0__50_25}" "${ret_parse_int13_v0__50_52}")
    ret_store_term_size2217_v0=1
    return 0
}

# query_term_size()
query_term_size__2218_v0() {
    local command_441
    command_441="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; [[ "$height" =~ ^[1-9][0-9]*$ && "$width" =~ ^[1-9][0-9]*$ ]] && echo "$height $width")"
    __status=$?
    local size_25153="${command_441}"
    store_term_size__2217_v0 "${size_25153}"
    ret_query_term_size2218_v0="${ret_store_term_size2217_v0}"
    return 0
}

# stty_term_size()
stty_term_size__2219_v0() {
    local command_442
    command_442="$(read -r rows cols < <(stty size < /dev/tty 2>/dev/null); [[ "$rows" =~ ^[1-9][0-9]*$ && "$cols" =~ ^[1-9][0-9]*$ ]] && echo "$rows $cols")"
    __status=$?
    local size_25149="${command_442}"
    store_term_size__2217_v0 "${size_25149}"
    ret_stty_term_size2219_v0="${ret_store_term_size2217_v0}"
    return 0
}

# get_term_size()
get_term_size__2220_v0() {
    stty_term_size__2219_v0 
    local detected_25152="${ret_stty_term_size2219_v0}"
    if [ "$(( ! detected_25152 ))" != 0 ]; then
        query_term_size__2218_v0 
        detected_25152="${ret_query_term_size2218_v0}"
    fi
    _got_term_size_73=1
}

# term_width()
term_width__2222_v0() {
    if [ "$(( ! _got_term_size_73 ))" != 0 ]; then
        get_term_size__2220_v0 
    fi
    ret_term_width2222_v0="${_term_size_74[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:93:23)"}"
    return 0
}

# term_height()
term_height__2223_v0() {
    if [ "$(( ! _got_term_size_73 ))" != 0 ]; then
        get_term_size__2220_v0 
    fi
    ret_term_height2223_v0="${_term_size_74[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_75="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_76=0
_secondary_color_78=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2233_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    local config_25244="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_25244}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_75="No"
        ret_get_supports_truecolor2233_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_75="No"
        ret_get_supports_truecolor2233_v0=0
        return 0
    fi
    local colorterm_25245="${ret_env_var_get120_v0}"
    _supports_truecolor_75="$(if [ "$(( $([ "_${colorterm_25245}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_25245}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2233_v0="$([ "_${_supports_truecolor_75}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2234_v0() {
    local message_25239="${1}"
    local r_25240="${2}"
    local g_25241="${3}"
    local b_25242="${4}"
    local fallback_25243="${5}"
    if [ "$([ "_${_supports_truecolor_75}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2234_v0="\\x1b[38;2;${r_25240};${g_25241};${b_25242}m""${message_25239}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_75}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2233_v0 
        local ret_get_supports_truecolor2233_v0__50_17="${ret_get_supports_truecolor2233_v0}"
        if [ "${ret_get_supports_truecolor2233_v0__50_17}" != 0 ]; then
            ret_colored_rgb2234_v0="\\x1b[38;2;${r_25240};${g_25241};${b_25242}m""${message_25239}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_25243 == 0 ))" != 0 ]; then
            ret_colored_rgb2234_v0="${message_25239}"
            return 0
        else
            ret_colored_rgb2234_v0="\\x1b[${fallback_25243}m""${message_25239}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_25243 == 0 ))" != 0 ]; then
            ret_colored_rgb2234_v0="${message_25239}"
            return 0
        fi
        ret_colored_rgb2234_v0="\\x1b[${fallback_25243}m""${message_25239}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2236_v0() {
    if [ "$(( ! _got_xylitol_colors_76 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        local primary_env_25233="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_25233}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_25233}" ";"
            local parts_25234=("${ret_split4_v0[@]}")
            local __length_446=("${parts_25234[@]}")
            if [ "$(( ${#__length_446[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25234[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25234[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25234[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25234[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        local secondary_env_25235="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_25235}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_25235}" ";"
            local parts_25236=("${ret_split4_v0[@]}")
            local __length_448=("${parts_25236[@]}")
            if [ "$(( ${#__length_448[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25236[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25236[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25236[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25236[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_78=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        local accent_env_25237="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_25237}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_25237}" ";"
            local parts_25238=("${ret_split4_v0[@]}")
            local __length_450=("${parts_25238[@]}")
            if [ "$(( ${#__length_450[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_25238[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25238[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25238[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_25238[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2236_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_76=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2237_v0() {
    inner_get_xylitol_colors__2236_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_76=1
}

# colored_secondary(message: Text)
colored_secondary__2239_v0() {
    local message_25232="${1}"
    if [ "$(( ! _got_xylitol_colors_76 ))" != 0 ]; then
        get_xylitol_colors__2237_v0 
    fi
    colored_rgb__2234_v0 "${message_25232}" "${_secondary_color_78[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_78[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_78[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_78[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2239_v0="${ret_colored_rgb2234_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2254_v0() {
    local command_452
    command_452="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_25258="${command_452}"
    if [ "$([ "_${var_25258}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="UP"
        return 0
    elif [ "$([ "_${var_25258}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="DOWN"
        return 0
    elif [ "$([ "_${var_25258}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_25258}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="LEFT"
        return 0
    elif [ "$([ "_${var_25258}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_25258}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2254_v0="INPUT"
        return 0
    else
        ret_get_key2254_v0="${var_25258}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2256_v0() {
    local format_25147="${1}"
    local args_25148=("${!2}")
    args_25148=("${format_25147}" "${args_25148[@]}")
    __status=$?
    printf "${args_25148[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2257_v0() {
    local message_25195="${1}"
    local color_25196="${2}"
    # Prints an error message with a specified color.
    local array_453=("${message_25195}")
    eprintf__2256_v0 "\\x1b[${color_25196}m%s\\x1b[0m" array_453[@]
}

# colored(message: Text, color: Int)
colored__2258_v0() {
    local message_25203="${1}"
    local color_25204="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2258_v0="\\x1b[${color_25204}m""${message_25203}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2260_v0() {
    local cnt_25255="${1}"
    if [ "$(( cnt_25255 > 0 ))" != 0 ]; then
        local sequence_25256=""
        local __range_start_25257=0
        local __range_end_25257="${cnt_25255}"
        local __dir_25257=$(( ${__range_start_25257} <= ${__range_end_25257} ? 1 : -1 ))
        for (( ____25257=${__range_start_25257}; ____25257 * ${__dir_25257} < ${__range_end_25257} * ${__dir_25257}; ____25257+=${__dir_25257} )); do
            sequence_25256+="\\x1b[2K\\x1b[1A"
done
        local array_454=("")
        eprintf__2256_v0 "${sequence_25256}" array_454[@]
    fi
    local array_455=("")
    eprintf__2256_v0 "\\x1b[G" array_455[@]
}

# remove_current_line()
remove_current_line__2261_v0() {
    local array_456=("")
    eprintf__2256_v0 "\\x1b[2K\\x1b[G" array_456[@]
}

# print_blank(cnt: Int)
print_blank__2262_v0() {
    local cnt_25246="${1}"
    printf '%*s' "${cnt_25246}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2263_v0() {
    local cnt_25193="${1}"
    local __range_start_25194=0
    local __range_end_25194="${cnt_25193}"
    local __dir_25194=$(( ${__range_start_25194} <= ${__range_end_25194} ? 1 : -1 ))
    for (( ____25194=${__range_start_25194}; ____25194 * ${__dir_25194} < ${__range_end_25194} * ${__dir_25194}; ____25194+=${__dir_25194} )); do
        local array_457=("")
        eprintf__2256_v0 "
" array_457[@]
done
}

# go_up(cnt: Int)
go_up__2264_v0() {
    local cnt_25212="${1}"
    local array_458=("")
    eprintf__2256_v0 "\\x1b[${cnt_25212}A" array_458[@]
}

# go_down(cnt: Int)
go_down__2265_v0() {
    local cnt_25267="${1}"
    local array_459=("")
    eprintf__2256_v0 "\\x1b[${cnt_25267}B" array_459[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2266_v0() {
    local cnt_25276="${1}"
    if [ "$(( cnt_25276 > 0 ))" != 0 ]; then
        go_down__2265_v0 "${cnt_25276}"
    else
        go_up__2264_v0 "$(( - cnt_25276 ))"
    fi
}

# hide_cursor()
hide_cursor__2267_v0() {
    local array_460=("")
    eprintf__2256_v0 "\\x1b[?25l" array_460[@]
}

# show_cursor()
show_cursor__2268_v0() {
    local array_461=("")
    eprintf__2256_v0 "\\x1b[?25h" array_461[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2269_v0() {
    local text_25169="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_462
    command_462="$([[ "${text_25169}" == *$'\x1b'* || "${text_25169}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_25170="${command_462}"
    ret_has_ansi_escape2269_v0="$([ "_${has_escape_25170}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2271_v0() {
    local text_25159="${1}"
    local command_463
    command_463="$(printf "%s" "${text_25159}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2271_v0="${command_463}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2272_v0() {
    local text_25161="${1}"
    local command_464
    command_464="$(printf "%s" "${text_25161}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_25162="${command_464}"
    ret_is_all_ascii2272_v0="$([ "_${result_25162}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2273_v0() {
    local text_25158="${1}"
    strip_ansi__2271_v0 "${text_25158}"
    local stripped_25160="${ret_strip_ansi2271_v0}"
    # Check if text is all ASCII
    is_all_ascii__2272_v0 "${stripped_25160}"
    local ret_is_all_ascii2272_v0__150_12="${ret_is_all_ascii2272_v0}"
    if [ "$(( ! ret_is_all_ascii2272_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2206_v0 "${stripped_25160}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_465="${stripped_25160}"
            ret_get_visible_len2273_v0="${#__length_465}"
            return 0
        fi
        ret_get_visible_len2273_v0="${ret_perl_get_cjk_width2206_v0}"
        return 0
    else
        local __length_466="${stripped_25160}"
        ret_get_visible_len2273_v0="${#__length_466}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2274_v0() {
    local text_25171="${1}"
    local max_width_25172="${2}"
    get_visible_len__2273_v0 "${text_25171}"
    local visible_len_25173="${ret_get_visible_len2273_v0}"
    if [ "$(( visible_len_25173 <= max_width_25172 ))" != 0 ]; then
        ret_truncate_text2274_v0="${text_25171}"
        return 0
    fi
    is_all_ascii__2272_v0 "${text_25171}"
    local ret_is_all_ascii2272_v0__167_12="${ret_is_all_ascii2272_v0}"
    if [ "$(( ! ret_is_all_ascii2272_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2207_v0 "${text_25171}" "${max_width_25172}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_25171}" | cut -c1-${max_width_25172}
            __status=$?
        fi
        ret_truncate_text2274_v0="${ret_perl_truncate_cjk2207_v0}"
        return 0
    fi
    local command_467
    command_467="$(printf "%s" "${text_25171}" | cut -c1-${max_width_25172})"
    __status=$?
    ret_truncate_text2274_v0="${command_467}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2275_v0() {
    local text_25167="${1}"
    local max_width_25168="${2}"
    has_ansi_escape__2269_v0 "${text_25167}"
    local ret_has_ansi_escape2269_v0__179_12="${ret_has_ansi_escape2269_v0}"
    if [ "$(( ! ret_has_ansi_escape2269_v0__179_12 ))" != 0 ]; then
        truncate_text__2274_v0 "${text_25167}" "${max_width_25168}"
        ret_truncate_ansi2275_v0="${ret_truncate_text2274_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_468
    command_468="$([[ "${text_25167}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_25177="${command_468}"
    # Replace \x1b[ with newline, then split
    local command_469
    command_469="$(t="${text_25167}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_25178="${command_469}"
    split__4_v0 "${replaced_25178}" "
"
    local parts_25179=("${ret_split4_v0[@]}")
    local result_25180=""
    local remaining_width_25181="${max_width_25168}"
    local __range_start_25182=0
    local __length_470=("${parts_25179[@]}")
    local __range_end_25182="${#__length_470[@]}"
    local __dir_25182=$(( ${__range_start_25182} <= ${__range_end_25182} ? 1 : -1 ))
    for (( idx_25182=${__range_start_25182}; idx_25182 * ${__dir_25182} < ${__range_end_25182} * ${__dir_25182}; idx_25182+=${__dir_25182} )); do
        local part_25183="${parts_25179[${idx_25182}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_25182 == 0 )) && $([ "_${starts_with_ansi_25177}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_25183}" == "_" ]; echo $?) && $(( remaining_width_25181 > 0 )) ))" != 0 ]; then
                truncate_text__2274_v0 "${part_25183}" "${remaining_width_25181}"
                local ret_truncate_text2274_v0__201_35="${ret_truncate_text2274_v0}"
                local truncated_25184="${ret_truncate_text2274_v0__201_35}"
                result_25180+="${truncated_25184}"
                get_visible_len__2273_v0 "${truncated_25184}"
                local ret_get_visible_len2273_v0__203_36="${ret_get_visible_len2273_v0}"
                remaining_width_25181="$(( remaining_width_25181 - ret_get_visible_len2273_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_471
            command_471="$(__p="${part_25183}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_25185="${command_471}"
            if [ "$([ "_${m_idx_25185}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_472
                command_472="$(__p="${part_25183}"; printf "%s" "${__p:0:${m_idx_25185}}")"
                __status=$?
                local ansi_params_25186="${command_472}"
                result_25180+="\\x1b[""${ansi_params_25186}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_25185}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_25187="${ret_parse_int13_v0__214_41}"
                local text_start_25188="$(( m_idx_num_25187 + 1 ))"
                local command_473
                command_473="$(__p="${part_25183}"; printf "%s" "${__p:${text_start_25188}}")"
                __status=$?
                local text_part_25189="${command_473}"
                if [ "$(( $([ "_${text_part_25189}" == "_" ]; echo $?) && $(( remaining_width_25181 > 0 )) ))" != 0 ]; then
                    truncate_text__2274_v0 "${text_part_25189}" "${remaining_width_25181}"
                    local ret_truncate_text2274_v0__218_39="${ret_truncate_text2274_v0}"
                    local truncated_25190="${ret_truncate_text2274_v0__218_39}"
                    result_25180+="${truncated_25190}"
                    get_visible_len__2273_v0 "${truncated_25190}"
                    local ret_get_visible_len2273_v0__220_40="${ret_get_visible_len2273_v0}"
                    remaining_width_25181="$(( remaining_width_25181 - ret_get_visible_len2273_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_25183}" == "_" ]; echo $?) && $(( remaining_width_25181 > 0 )) ))" != 0 ]; then
                    truncate_text__2274_v0 "${part_25183}" "${remaining_width_25181}"
                    local ret_truncate_text2274_v0__225_39="${ret_truncate_text2274_v0}"
                    local truncated_25191="${ret_truncate_text2274_v0__225_39}"
                    result_25180+="${truncated_25191}"
                    get_visible_len__2273_v0 "${truncated_25191}"
                    local ret_get_visible_len2273_v0__227_40="${ret_get_visible_len2273_v0}"
                    remaining_width_25181="$(( remaining_width_25181 - ret_get_visible_len2273_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2275_v0="${result_25180}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2276_v0() {
    local text_25156="${1}"
    local max_width_25157="${2}"
    get_visible_len__2273_v0 "${text_25156}"
    local visible_len_25166="${ret_get_visible_len2273_v0}"
    if [ "$(( visible_len_25166 <= max_width_25157 ))" != 0 ]; then
        ret_cutoff_text2276_v0="${text_25156}"
        return 0
    fi
    truncate_ansi__2275_v0 "${text_25156}" "$(( max_width_25157 - 3 ))"
    local ret_truncate_ansi2275_v0__243_12="${ret_truncate_ansi2275_v0}"
    ret_cutoff_text2276_v0="${ret_truncate_ansi2275_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2277_v0() {
    local items_25197=("${!1}")
    local total_len_25198="${2}"
    local term_width_25199="${3}"
    local separator_25200=" • "
    local separator_len_25201=3
    # Fast path: no truncation needed
    if [ "$(( total_len_25198 <= term_width_25199 ))" != 0 ]; then
        local iter_25202=0
        while :
        do
            local __length_474=("${items_25197[@]}")
            if [ "$(( iter_25202 >= ${#__length_474[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_25202 > 0 ))" != 0 ]; then
                eprintf_colored__2257_v0 "${separator_25200}" 90
            fi
            colored__2258_v0 "${items_25197[$(( iter_25202 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2258_v0__268_41="${ret_colored2258_v0}"
            local array_475=("")
            eprintf__2256_v0 "${items_25197[${iter_25202}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2258_v0__268_41}" array_475[@]
            iter_25202="$(( iter_25202 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_25205=0
        local first_25206=1
        local iter_25207=0
        while :
        do
            local __length_476=("${items_25197[@]}")
            if [ "$(( iter_25207 >= ${#__length_476[@]} ))" != 0 ]; then
                break
            fi
            local key_25208="${items_25197[${iter_25207}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_25209="${items_25197[$(( iter_25207 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_477="${key_25208}"
            local __length_478="${action_25209}"
            local part_len_25210="$(( $(( ${#__length_477} + 1 )) + ${#__length_478} ))"
            local needed_25211="${part_len_25210}"
            if [ "$(( ! first_25206 ))" != 0 ]; then
                needed_25211="$(( needed_25211 + separator_len_25201 ))"
            fi
            if [ "$(( $(( current_len_25205 + needed_25211 )) > term_width_25199 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_25206 ))" != 0 ]; then
                eprintf_colored__2257_v0 "${separator_25200}" 90
            fi
            colored__2258_v0 "${action_25209}" 2
            local ret_colored2258_v0__296_33="${ret_colored2258_v0}"
            local array_479=("")
            eprintf__2256_v0 "${key_25208}"" ""${ret_colored2258_v0__296_33}" array_479[@]
            current_len_25205="$(( current_len_25205 + needed_25211 ))"
            first_25206=0
            iter_25207="$(( iter_25207 + 2 ))"
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
__CHOOSER_CONTINUE_80=0
# The page changed and the engine needs its labels before it can draw.
__CHOOSER_NEED_PAGE_81=1
# The user confirmed the selection.
__CHOOSER_DONE_82=2
_total_83=0
_page_size_84=10
_display_count_85=0
_total_pages_86=1
_current_page_87=0
_selected_88=0
_cursor_89="> "
_multi_90=0
_limit_91=-1
_term_width_92=80
_has_header_93=0
_page_94=()
_page_count_95=0
_checked_96=()
# Tracked alongside `_checked` because counting it on every keypress would
# walk the whole list, and `or` evaluates both of its operands.
_checked_count_97=0
_first_render_98=1
# Set when moving up off the top of a page. The cursor belongs on the last
# item of the previous page, but its length is only known once the caller
# has handed over that page, so `chooser_set_page` finishes the move.
_up_paged_99=0
# render_single_page()
render_single_page__2331_v0() {
    local __length_482="${_cursor_89}"
    local cursor_len_25249="${#__length_482}"
    local max_option_width_25250="$(( $(( _term_width_92 - cursor_len_25249 )) - 1 ))"
    local __range_start_25251=0
    local __range_end_25251="${_page_count_95}"
    local __dir_25251=$(( ${__range_start_25251} <= ${__range_end_25251} ? 1 : -1 ))
    for (( i_25251=${__range_start_25251}; i_25251 * ${__dir_25251} < ${__range_end_25251} * ${__dir_25251}; i_25251+=${__dir_25251} )); do
        cutoff_text__2276_v0 "${_page_94[${i_25251}]?"Index out of bounds (at src/./file/../choose/engine.ab:48:45)"}" "${max_option_width_25250}"
        local ret_cutoff_text2276_v0__48_27="${ret_cutoff_text2276_v0}"
        local truncated_25252="${ret_cutoff_text2276_v0__48_27}"
        if [ "$(( i_25251 == _selected_88 ))" != 0 ]; then
            colored_secondary__2239_v0 "${_cursor_89}""${truncated_25252}""
"
            local ret_colored_secondary2239_v0__50_21="${ret_colored_secondary2239_v0}"
            local array_483=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__50_21}" array_483[@]
        else
            print_blank__2262_v0 "${cursor_len_25249}"
            local array_484=("")
            eprintf__2256_v0 "${truncated_25252}""
" array_484[@]
        fi
done
    local remaining_slots_25253="$(( _display_count_85 - _page_count_95 ))"
    if [ "$(( remaining_slots_25253 > 0 ))" != 0 ]; then
        local __range_start_25254=0
        local __range_end_25254="${remaining_slots_25253}"
        local __dir_25254=$(( ${__range_start_25254} <= ${__range_end_25254} ? 1 : -1 ))
        for (( ____25254=${__range_start_25254}; ____25254 * ${__dir_25254} < ${__range_end_25254} * ${__dir_25254}; ____25254+=${__dir_25254} )); do
            local array_485=("")
            eprintf__2256_v0 "\\x1b[K
" array_485[@]
done
    fi
}

# render_multi_page()
render_multi_page__2332_v0() {
    local __length_486="${_cursor_89}"
    local cursor_len_25225="${#__length_486}"
    local max_option_width_25226="$(( $(( _term_width_92 - cursor_len_25225 )) - 3 ))"
    # 2 for check mark
    chooser_page_start__2337_v0 
    local page_start_25227="${ret_chooser_page_start2337_v0}"
    local __range_start_25228=0
    local __range_end_25228="${_page_count_95}"
    local __dir_25228=$(( ${__range_start_25228} <= ${__range_end_25228} ? 1 : -1 ))
    for (( i_25228=${__range_start_25228}; i_25228 * ${__dir_25228} < ${__range_end_25228} * ${__dir_25228}; i_25228+=${__dir_25228} )); do
        local global_idx_25229="$(( page_start_25227 + i_25228 ))"
        local check_mark_25230
        check_mark_25230="$(if [ "${_checked_96[${global_idx_25229}]?"Index out of bounds (at src/./file/../choose/engine.ab:70:37)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__2276_v0 "${_page_94[${i_25228}]?"Index out of bounds (at src/./file/../choose/engine.ab:71:45)"}" "${max_option_width_25226}"
        local ret_cutoff_text2276_v0__71_27="${ret_cutoff_text2276_v0}"
        local truncated_25231="${ret_cutoff_text2276_v0__71_27}"
        if [ "$(( i_25228 == _selected_88 ))" != 0 ]; then
            colored_secondary__2239_v0 "${_cursor_89}""${check_mark_25230}""${truncated_25231}""
"
            local ret_colored_secondary2239_v0__73_37="${ret_colored_secondary2239_v0}"
            local array_487=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__73_37}" array_487[@]
        elif [ "${_checked_96[${global_idx_25229}]?"Index out of bounds (at src/./file/../choose/engine.ab:74:22)"}" != 0 ]; then
            print_blank__2262_v0 "${cursor_len_25225}"
            colored_secondary__2239_v0 "${check_mark_25230}""${truncated_25231}""
"
            local ret_colored_secondary2239_v0__76_25="${ret_colored_secondary2239_v0}"
            local array_488=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__76_25}" array_488[@]
        else
            print_blank__2262_v0 "${cursor_len_25225}"
            local array_489=("")
            eprintf__2256_v0 "${check_mark_25230}""${truncated_25231}""
" array_489[@]
        fi
done
    local remaining_slots_25247="$(( _display_count_85 - _page_count_95 ))"
    if [ "$(( remaining_slots_25247 > 0 ))" != 0 ]; then
        local __range_start_25248=0
        local __range_end_25248="${remaining_slots_25247}"
        local __dir_25248=$(( ${__range_start_25248} <= ${__range_end_25248} ? 1 : -1 ))
        for (( ____25248=${__range_start_25248}; ____25248 * ${__dir_25248} < ${__range_end_25248} * ${__dir_25248}; ____25248+=${__dir_25248} )); do
            local array_490=("")
            eprintf__2256_v0 "\\x1b[K
" array_490[@]
done
    fi
}

# render_page()
render_page__2333_v0() {
    if [ "${_multi_90}" != 0 ]; then
        render_multi_page__2332_v0 
    else
        render_single_page__2331_v0 
    fi
}

# render_page_indicator()
render_page_indicator__2334_v0() {
    if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
        local array_491=("")
        eprintf__2256_v0 "\\x1b[G\\x1b[K" array_491[@]
        eprintf_colored__2257_v0 "Page $(( _current_page_87 + 1 ))/${_total_pages_86}" 90
        local array_492=("")
        eprintf__2256_v0 "\\x1b[G" array_492[@]
    fi
}

# render_tooltip_line()
render_tooltip_line__2335_v0() {
    if [ "$(( ! _multi_90 ))" != 0 ]; then
        # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
        # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
            local array_493=("↑↓" "select" "←→" "page" "enter" "confirm")
            render_tooltip__2277_v0 array_493[@] 36 "${_term_width_92}"
        else
            local array_494=("↑↓" "select" "enter" "confirm")
            render_tooltip__2277_v0 array_494[@] 25 "${_term_width_92}"
        fi
    else
        # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
        # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
        # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
        # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
        if [ "$(( $(( _total_pages_86 > 1 )) && $(( _limit_91 < 0 )) ))" != 0 ]; then
            local array_495=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
            render_tooltip__2277_v0 array_495[@] 55 "${_term_width_92}"
        elif [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
            local array_496=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
            render_tooltip__2277_v0 array_496[@] 47 "${_term_width_92}"
        elif [ "$(( _limit_91 < 0 ))" != 0 ]; then
            local array_497=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
            render_tooltip__2277_v0 array_497[@] 44 "${_term_width_92}"
        else
            local array_498=("↑↓" "select" "x" "toggle" "enter" "confirm")
            render_tooltip__2277_v0 array_498[@] 36 "${_term_width_92}"
        fi
    fi
}

# chooser_begin(total: Int, page_size: Int, header: Text, cursor: Text, multi: Bool, limit: Int)
chooser_begin__2336_v0() {
    local total_25139="${1}"
    local page_size_25140="${2}"
    local header_25141="${3}"
    local cursor_25142="${4}"
    local multi_25143="${5}"
    local limit_25144="${6}"
    _total_83="${total_25139}"
    _cursor_89="${cursor_25142}"
    _multi_90="${multi_25143}"
    _limit_91="${limit_25144}"
    _current_page_87=0
    _selected_88=0
    _first_render_98=1
    _up_paged_99=0
    _checked_count_97=0
    _has_header_93="$([ "_${header_25141}" == "_" ]; echo $?)"
    stty_lock__2215_v0 
    hide_cursor__2267_v0 
    term_width__2222_v0 
    _term_width_92="${ret_term_width2222_v0}"
    term_height__2223_v0 
    local term_height_25154="${ret_term_height2223_v0}"
    local max_page_size_25155
    max_page_size_25155="$(( term_height_25154 - $(if [ "${_has_header_93}" != 0 ]; then echo 3; else echo 2; fi) ))"
    _page_size_84="${page_size_25140}"
    if [ "$(( _page_size_84 > max_page_size_25155 ))" != 0 ]; then
        _page_size_84="${max_page_size_25155}"
    fi
    if [ "${_has_header_93}" != 0 ]; then
        cutoff_text__2276_v0 "${header_25141}" "${_term_width_92}"
        local ret_cutoff_text2276_v0__157_17="${ret_cutoff_text2276_v0}"
        local array_499=("")
        eprintf__2256_v0 "${ret_cutoff_text2276_v0__157_17}""
" array_499[@]
    fi
    math_floor__509_v0 "$(( $(( $(( total_25139 + _page_size_84 )) - 1 )) / _page_size_84 ))"
    _total_pages_86="${ret_math_floor509_v0}"
    _display_count_85="${_page_size_84}"
    if [ "$(( total_25139 < _page_size_84 ))" != 0 ]; then
        _display_count_85="${total_25139}"
    fi
    if [ "${multi_25143}" != 0 ]; then
        _checked_96=()
        local __range_start_25192=0
        local __range_end_25192="${total_25139}"
        local __dir_25192=$(( ${__range_start_25192} <= ${__range_end_25192} ? 1 : -1 ))
        for (( ____25192=${__range_start_25192}; ____25192 * ${__dir_25192} < ${__range_end_25192} * ${__dir_25192}; ____25192+=${__dir_25192} )); do
            local array_501=(0)
            _checked_96+=("${array_501[@]}")
done
    fi
    new_line__2263_v0 "${_display_count_85}"
    local array_502=("")
    eprintf__2256_v0 "\\x1b[G" array_502[@]
    if [ "$(( _total_pages_86 > 1 ))" != 0 ]; then
        eprintf_colored__2257_v0 "Page $(( _current_page_87 + 1 ))/${_total_pages_86}" 90
    fi
    new_line__2263_v0 1
    render_tooltip_line__2335_v0 
    go_up__2264_v0 "$(( _display_count_85 + 1 ))"
    local array_503=("")
    eprintf__2256_v0 "\\x1b[G" array_503[@]
}

# chooser_page_start()
chooser_page_start__2337_v0() {
    ret_chooser_page_start2337_v0="$(( _current_page_87 * _page_size_84 ))"
    return 0
}

# chooser_page_count()
chooser_page_count__2338_v0() {
    chooser_page_start__2337_v0 
    local start_25216="${ret_chooser_page_start2337_v0}"
    local end_25217="$(( start_25216 + _page_size_84 ))"
    if [ "$(( end_25217 > _total_83 ))" != 0 ]; then
        end_25217="${_total_83}"
    fi
    ret_chooser_page_count2338_v0="$(( end_25217 - start_25216 ))"
    return 0
}

# chooser_set_page(page: [Text])
chooser_set_page__2339_v0() {
    local -n page_25224="${1}"
    _page_94=("${page_25224[@]}")
    local __length_504=("${page_25224[@]}")
    _page_count_95="${#__length_504[@]}"
    if [ "${_first_render_98}" != 0 ]; then
        _first_render_98=0
        render_page__2333_v0 
    else
        if [ "${_up_paged_99}" != 0 ]; then
            _selected_88="$(( _page_count_95 - 1 ))"
            _up_paged_99=0
        fi
        go_up__2264_v0 1
        remove_line__2260_v0 "$(( _display_count_85 - 1 ))"
        remove_current_line__2261_v0 
        local array_505=("")
        eprintf__2256_v0 "\\x1b[G" array_505[@]
        render_page__2333_v0 
        render_page_indicator__2334_v0 
    fi
}

# redraw_selection(prev_selected: Int)
redraw_selection__2340_v0() {
    local prev_selected_25270="${1}"
    chooser_page_start__2337_v0 
    local page_start_25271="${ret_chooser_page_start2337_v0}"
    local check_width_25272
    check_width_25272="$(if [ "${_multi_90}" != 0 ]; then echo 3; else echo 1; fi)"
    local __length_506="${_cursor_89}"
    local max_option_width_25273="$(( $(( _term_width_92 - ${#__length_506} )) - check_width_25272 ))"
    go_up__2264_v0 "$(( _display_count_85 - prev_selected_25270 ))"
    local array_507=("")
    eprintf__2256_v0 "\\x1b[K" array_507[@]
    local __length_508="${_cursor_89}"
    print_blank__2262_v0 "${#__length_508}"
    if [ "${_multi_90}" != 0 ]; then
        local was_checked_25274="${_checked_96[$(( page_start_25271 + prev_selected_25270 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:231:38)"}"
        cutoff_text__2276_v0 "${_page_94[${prev_selected_25270}]?"Index out of bounds (at src/./file/../choose/engine.ab:232:81)"}" "${max_option_width_25273}"
        local ret_cutoff_text2276_v0__232_63="${ret_cutoff_text2276_v0}"
        local prev_line_25275
        prev_line_25275="$(if [ "${was_checked_25274}" != 0 ]; then echo "✓ "; else echo "• "; fi)""${ret_cutoff_text2276_v0__232_63}"
        if [ "${was_checked_25274}" != 0 ]; then
            colored_secondary__2239_v0 "${prev_line_25275}"
            local ret_colored_secondary2239_v0__234_21="${ret_colored_secondary2239_v0}"
            local array_509=("")
            eprintf__2256_v0 "${ret_colored_secondary2239_v0__234_21}" array_509[@]
        else
            local array_510=("")
            eprintf__2256_v0 "${prev_line_25275}" array_510[@]
        fi
    else
        cutoff_text__2276_v0 "${_page_94[${prev_selected_25270}]?"Index out of bounds (at src/./file/../choose/engine.ab:239:35)"}" "${max_option_width_25273}"
        local ret_cutoff_text2276_v0__239_17="${ret_cutoff_text2276_v0}"
        local array_511=("")
        eprintf__2256_v0 "${ret_cutoff_text2276_v0__239_17}" array_511[@]
    fi
    go_up_or_down__2266_v0 "$(( _selected_88 - prev_selected_25270 ))"
    local array_512=("")
    eprintf__2256_v0 "\\x1b[G" array_512[@]
    local array_513=("")
    eprintf__2256_v0 "\\x1b[K" array_513[@]
    local mark_25277
    mark_25277="$(if [ "${_multi_90}" != 0 ]; then echo "$(if [ "${_checked_96[$(( page_start_25271 + _selected_88 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:245:40)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"; else echo ""; fi)"
    cutoff_text__2276_v0 "${_page_94[${_selected_88}]?"Index out of bounds (at src/./file/../choose/engine.ab:246:66)"}" "${max_option_width_25273}"
    local ret_cutoff_text2276_v0__246_48="${ret_cutoff_text2276_v0}"
    colored_secondary__2239_v0 "${_cursor_89}""${mark_25277}""${ret_cutoff_text2276_v0__246_48}"
    local ret_colored_secondary2239_v0__246_13="${ret_colored_secondary2239_v0}"
    local array_514=("")
    eprintf__2256_v0 "${ret_colored_secondary2239_v0__246_13}" array_514[@]
    go_down__2265_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_515=("")
    eprintf__2256_v0 "\\x1b[G" array_515[@]
}

# redraw_current_line()
redraw_current_line__2341_v0() {
    chooser_page_start__2337_v0 
    local page_start_25264="${ret_chooser_page_start2337_v0}"
    local __length_516="${_cursor_89}"
    local max_option_width_25265="$(( $(( _term_width_92 - ${#__length_516} )) - 3 ))"
    go_up__2264_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_517=("")
    eprintf__2256_v0 "\\x1b[G" array_517[@]
    local array_518=("")
    eprintf__2256_v0 "\\x1b[K" array_518[@]
    local check_mark_25266
    check_mark_25266="$(if [ "${_checked_96[$(( page_start_25264 + _selected_88 ))]?"Index out of bounds (at src/./file/../choose/engine.ab:259:33)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
    cutoff_text__2276_v0 "${_page_94[${_selected_88}]?"Index out of bounds (at src/./file/../choose/engine.ab:260:72)"}" "${max_option_width_25265}"
    local ret_cutoff_text2276_v0__260_54="${ret_cutoff_text2276_v0}"
    colored_secondary__2239_v0 "${_cursor_89}""${check_mark_25266}""${ret_cutoff_text2276_v0__260_54}"
    local ret_colored_secondary2239_v0__260_13="${ret_colored_secondary2239_v0}"
    local array_519=("")
    eprintf__2256_v0 "${ret_colored_secondary2239_v0__260_13}" array_519[@]
    go_down__2265_v0 "$(( _display_count_85 - _selected_88 ))"
    local array_520=("")
    eprintf__2256_v0 "\\x1b[G" array_520[@]
}

# chooser_step()
chooser_step__2342_v0() {
    get_key__2254_v0 
    local key_25259="${ret_get_key2254_v0}"
    local prev_selected_25260="${_selected_88}"
    local prev_page_25261="${_current_page_87}"
    chooser_page_start__2337_v0 
    local page_start_25262="${ret_chooser_page_start2337_v0}"
    _up_paged_99=0
    if [ "$(( $([ "_${key_25259}" != "_UP" ]; echo $?) || $([ "_${key_25259}" != "_k" ]; echo $?) ))" != 0 ]; then
        if [ "$(( $(( _selected_88 == 0 )) && $(( _total_pages_86 > 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_87 > 0 ))" != 0 ]; then
                _current_page_87="$(( _current_page_87 - 1 ))"
            else
                _current_page_87="$(( _total_pages_86 - 1 ))"
            fi
            _up_paged_99=1
        elif [ "$(( _selected_88 == 0 ))" != 0 ]; then
            _selected_88="$(( _page_count_95 - 1 ))"
        else
            _selected_88="$(( _selected_88 - 1 ))"
        fi
    elif [ "$(( $([ "_${key_25259}" != "_DOWN" ]; echo $?) || $([ "_${key_25259}" != "_j" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _selected_88 == $(( _page_count_95 - 1 )) ))" != 0 ]; then
            if [ "$(( _current_page_87 < $(( _total_pages_86 - 1 )) ))" != 0 ]; then
                _current_page_87="$(( _current_page_87 + 1 ))"
            else
                _current_page_87=0
            fi
            _selected_88=0
        else
            _selected_88="$(( _selected_88 + 1 ))"
        fi
    elif [ "$(( $([ "_${key_25259}" != "_LEFT" ]; echo $?) || $([ "_${key_25259}" != "_h" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_87 > 0 ))" != 0 ]; then
            _current_page_87="$(( _current_page_87 - 1 ))"
        fi
        _selected_88=0
    elif [ "$(( $([ "_${key_25259}" != "_RIGHT" ]; echo $?) || $([ "_${key_25259}" != "_l" ]; echo $?) ))" != 0 ]; then
        if [ "$(( _current_page_87 < $(( _total_pages_86 - 1 )) ))" != 0 ]; then
            _current_page_87="$(( _current_page_87 + 1 ))"
            _selected_88=0
        else
            _selected_88="$(( _page_count_95 - 1 ))"
        fi
    elif [ "$(( _multi_90 && $(( $([ "_${key_25259}" != "_x" ]; echo $?) || $([ "_${key_25259}" != "_X" ]; echo $?) )) ))" != 0 ]; then
        local global_selected_25263="$(( page_start_25262 + _selected_88 ))"
        if [ "${_checked_96[${global_selected_25263}]?"Index out of bounds (at src/./file/../choose/engine.ab:321:26)"}" != 0 ]; then
            _checked_96["${global_selected_25263}"]=0
            _checked_count_97="$(( _checked_count_97 - 1 ))"
        elif [ "$(( $(( _limit_91 < 0 )) || $(( _checked_count_97 < _limit_91 )) ))" != 0 ]; then
            _checked_96["${global_selected_25263}"]=1
            _checked_count_97="$(( _checked_count_97 + 1 ))"
        else
            ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_80}"
            return 0
        fi
        redraw_current_line__2341_v0 
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    elif [ "$(( $(( _multi_90 && $(( $([ "_${key_25259}" != "_a" ]; echo $?) || $([ "_${key_25259}" != "_A" ]; echo $?) )) )) && $(( _limit_91 < 0 )) ))" != 0 ]; then
        local all_checked_25268="$(( _checked_count_97 == _total_83 ))"
        local __range_start_25269=0
        local __range_end_25269="${_total_83}"
        local __dir_25269=$(( ${__range_start_25269} <= ${__range_end_25269} ? 1 : -1 ))
        for (( i_25269=${__range_start_25269}; i_25269 * ${__dir_25269} < ${__range_end_25269} * ${__dir_25269}; i_25269+=${__dir_25269} )); do
            _checked_96["${i_25269}"]="$(( ! all_checked_25268 ))"
done
        _checked_count_97="$(if [ "${all_checked_25268}" != 0 ]; then echo 0; else echo "${_total_83}"; fi)"
        go_up__2264_v0 "${_display_count_85}"
        local array_521=("")
        eprintf__2256_v0 "\\x1b[G" array_521[@]
        render_page__2333_v0 
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    elif [ "$([ "_${key_25259}" != "_INPUT" ]; echo $?)" != 0 ]; then
        ret_chooser_step2342_v0="${__CHOOSER_DONE_82}"
        return 0
    else
        ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_80}"
        return 0
    fi
    if [ "$(( prev_page_25261 != _current_page_87 ))" != 0 ]; then
        ret_chooser_step2342_v0="${__CHOOSER_NEED_PAGE_81}"
        return 0
    fi
    if [ "$(( prev_selected_25260 != _selected_88 ))" != 0 ]; then
        redraw_selection__2340_v0 "${prev_selected_25260}"
    fi
    ret_chooser_step2342_v0="${__CHOOSER_CONTINUE_80}"
    return 0
}

# chooser_selected()
chooser_selected__2343_v0() {
    chooser_page_start__2337_v0 
    local ret_chooser_page_start2337_v0__362_12="${ret_chooser_page_start2337_v0}"
    ret_chooser_selected2343_v0="$(( ret_chooser_page_start2337_v0__362_12 + _selected_88 ))"
    return 0
}

# chooser_end()
chooser_end__2345_v0() {
    local total_lines_25280="$(( _display_count_85 + 2 ))"
    if [ "${_has_header_93}" != 0 ]; then
        total_lines_25280="$(( total_lines_25280 + 1 ))"
    fi
    go_down__2265_v0 1
    remove_line__2260_v0 "$(( total_lines_25280 - 1 ))"
    remove_current_line__2261_v0 
    stty_unlock__2216_v0 
    show_cursor__2268_v0 
}

# format_entry_display(name: Text, file_type: Text, target: Text)
format_entry_display__2354_v0() {
    local name_25220="${1}"
    local file_type_25221="${2}"
    local target_25222="${3}"
    if [ "$([ "_${file_type_25221}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__2013_v0 "/"
        local ret_colored_primary2013_v0__10_23="${ret_colored_primary2013_v0}"
        ret_format_entry_display2354_v0="${name_25220}""${ret_colored_primary2013_v0__10_23}"
        return 0
    fi
    if [ "$([ "_${file_type_25221}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__2015_v0 " > "
        local ret_colored_accent2015_v0__13_23="${ret_colored_accent2015_v0}"
        colored_primary__2013_v0 "${target_25222}"
        local ret_colored_primary2013_v0__13_47="${ret_colored_primary2013_v0}"
        ret_format_entry_display2354_v0="${name_25220}""${ret_colored_accent2015_v0__13_23}""${ret_colored_primary2013_v0__13_47}"
        return 0
    fi
    ret_format_entry_display2354_v0="${name_25220}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2355_v0() {
    local start_path_25112="${1}"
    local cursor_25113="${2}"
    local show_hidden_25114="${3}"
    local page_size_25115="${4}"
    stty_lock__1990_v0 
    # Initialize current path
    local current_path_25118="${start_path_25112}"
    if [ "$([ "_${current_path_25118}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1970_v0 
        current_path_25118="${ret_get_cwd1970_v0}"
    fi
    normalize_path__1971_v0 "${current_path_25118}"
    current_path_25118="${ret_normalize_path1971_v0}"
    while :
    do
        colored_primary__2013_v0 "Loading files..."
        local ret_colored_primary2013_v0__41_17="${ret_colored_primary2013_v0}"
        local array_522=("")
        eprintf__2031_v0 "${ret_colored_primary2013_v0__41_17}" array_522[@]
        # Get directory entries
        local listed_names_25121=()
        local listed_types_25122=()
        local listed_targets_25123=()
        get_directory_entries__1969_v0 "${current_path_25118}" "listed_names_25121" "listed_types_25122" "listed_targets_25123"
        # No display text is built here. The loop below formats one page at a
        # time, so a directory with thousands of entries only formats the
        # handful that are on screen.
        local names_25131=()
        local types_25132=()
        local targets_25133=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_25118}" == "_/" ]; echo $?)" != 0 ]; then
            names_25131+=("..")
            types_25132+=("d")
            targets_25133+=("")
        fi
        local __range_start_25134=0
        local __length_532=("${listed_names_25121[@]}")
        local __range_end_25134="${#__length_532[@]}"
        local __dir_25134=$(( ${__range_start_25134} <= ${__range_end_25134} ? 1 : -1 ))
        for (( i_25134=${__range_start_25134}; i_25134 * ${__dir_25134} < ${__range_end_25134} * ${__dir_25134}; i_25134+=${__dir_25134} )); do
            local name_25135="${listed_names_25121[${i_25134}]?"Index out of bounds (at src/./file/./mod.ab:64:39)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_25135}" "."
            local ret_starts_with22_v0__66_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_25114 )) && ret_starts_with22_v0__66_36 ))" != 0 ]; then
                continue
            fi
            local array_533=("${name_25135}")
            names_25131+=("${array_533[@]}")
            local array_534=("${listed_types_25122[${i_25134}]?"Index out of bounds (at src/./file/./mod.ab:70:36)"}")
            types_25132+=("${array_534[@]}")
            local array_535=("${listed_targets_25123[${i_25134}]?"Index out of bounds (at src/./file/./mod.ab:71:40)"}")
            targets_25133+=("${array_535[@]}")
done
        local __length_536=("${names_25131[@]}")
        local total_25136="${#__length_536[@]}"
        if [ "$(( total_25136 == 0 ))" != 0 ]; then
            eprintf_colored__2032_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1991_v0 
            ret_xyl_file2355_v0=""
            return 0
        fi
        colored_primary__2013_v0 "${current_path_25118}"
        local header_25138="${ret_colored_primary2013_v0}"
        remove_current_line__2036_v0 
        chooser_begin__2336_v0 "${total_25136}" "${page_size_25115}" "${header_25138}" "${cursor_25113}" 0 -1
        local need_page_25213=1
        while :
        do
            if [ "${need_page_25213}" != 0 ]; then
                local page_25214=()
                chooser_page_start__2337_v0 
                local start_25215="${ret_chooser_page_start2337_v0}"
                chooser_page_count__2338_v0 
                local count_25218="${ret_chooser_page_count2338_v0}"
                local __range_start_25219="${start_25215}"
                local __range_end_25219="$(( start_25215 + count_25218 ))"
                local __dir_25219=$(( ${__range_start_25219} <= ${__range_end_25219} ? 1 : -1 ))
                for (( i_25219=${__range_start_25219}; i_25219 * ${__dir_25219} < ${__range_end_25219} * ${__dir_25219}; i_25219+=${__dir_25219} )); do
                    format_entry_display__2354_v0 "${names_25131[${i_25219}]?"Index out of bounds (at src/./file/./mod.ab:92:57)"}" "${types_25132[${i_25219}]?"Index out of bounds (at src/./file/./mod.ab:92:67)"}" "${targets_25133[${i_25219}]?"Index out of bounds (at src/./file/./mod.ab:92:79)"}"
                    local ret_format_entry_display2354_v0__92_30="${ret_format_entry_display2354_v0}"
                    local array_538=("${ret_format_entry_display2354_v0__92_30}")
                    page_25214+=("${array_538[@]}")
done
                chooser_set_page__2339_v0 "page_25214"
            fi
            chooser_step__2342_v0 
            local step_25278="${ret_chooser_step2342_v0}"
            if [ "$(( step_25278 == __CHOOSER_DONE_82 ))" != 0 ]; then
                break
            fi
            need_page_25213="$(( step_25278 == __CHOOSER_NEED_PAGE_81 ))"
        done
        chooser_selected__2343_v0 
        local selected_idx_25279="${ret_chooser_selected2343_v0}"
        chooser_end__2345_v0 
        local name_25282="${names_25131[${selected_idx_25279}]?"Index out of bounds (at src/./file/./mod.ab:105:28)"}"
        local file_type_25283="${types_25132[${selected_idx_25279}]?"Index out of bounds (at src/./file/./mod.ab:106:33)"}"
        if [ "$([ "_${name_25282}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1973_v0 "${current_path_25118}"
            current_path_25118="${ret_get_parent_dir1973_v0}"
        elif [ "$([ "_${file_type_25283}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1972_v0 "${current_path_25118}" "${name_25282}"
            current_path_25118="${ret_path_join1972_v0}"
            normalize_path__1971_v0 "${current_path_25118}"
            current_path_25118="${ret_normalize_path1971_v0}"
        elif [ "$([ "_${file_type_25283}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_25288="${targets_25133[${selected_idx_25279}]?"Index out of bounds (at src/./file/./mod.ab:118:40)"}"
            local target_path_25289="${target_25288}"
            starts_with__22_v0 "${target_25288}" "/"
            local ret_starts_with22_v0__120_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__120_24 ))" != 0 ]; then
                path_join__1972_v0 "${current_path_25118}" "${target_25288}"
                target_path_25289="${ret_path_join1972_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_25289}"
            local ret_dir_exists38_v0__124_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__124_20}" != 0 ]; then
                current_path_25118="${target_path_25289}"
                normalize_path__1971_v0 "${current_path_25118}"
                current_path_25118="${ret_normalize_path1971_v0}"
            else
                stty_unlock__1991_v0 
                path_join__1972_v0 "${current_path_25118}" "${name_25282}"
                ret_xyl_file2355_v0="${ret_path_join1972_v0}"
                return 0
            fi
        else
            stty_unlock__1991_v0 
            path_join__1972_v0 "${current_path_25118}" "${name_25282}"
            ret_xyl_file2355_v0="${ret_path_join1972_v0}"
            return 0
        fi
    done
    stty_unlock__1991_v0 
    ret_xyl_file2355_v0=""
    return 0
}

# print_file_help()
print_file_help__2449_v0() {
    local usage_25036=("Usage:" "./xylitol.sh" "file" "[<path>]" "[flags]")
    print_wrapped__2055_v0 "usage_25036"
    printf '%s\n' ""
    colored_primary__2013_v0 "file"
    local ret_colored_primary2013_v0__8_18="${ret_colored_primary2013_v0}"
    local title_25072=("${ret_colored_primary2013_v0__8_18}" "-" "Browse" "filesystem" "and" "select" "a" "file.")
    print_wrapped__2055_v0 "title_25072"
    printf '%s\n' ""
    colored_secondary__2014_v0 "Arguments:"
    local ret_colored_secondary2014_v0__11_12="${ret_colored_secondary2014_v0}"
    local array_541=()
    printf__128_v0 "${ret_colored_secondary2014_v0__11_12}""
" array_541[@]
    local arg_names_25074=("[<path>]")
    local arg_texts_25075=("Starting directory path")
    local arg_notes_25076=("(default: current directory)")
    # 20 keeps this section on the same column as Flags below.
    render_help_entries__2054_v0 "arg_names_25074" "arg_texts_25075" "arg_notes_25076" 20
    printf '%s\n' ""
    colored_secondary__2014_v0 "Flags:"
    local ret_colored_secondary2014_v0__18_12="${ret_colored_secondary2014_v0}"
    local array_545=()
    printf__128_v0 "${ret_colored_secondary2014_v0__18_12}""
" array_545[@]
    local names_25104=("-h, --help" "-a, --all" "--cursor=\"<text>\"" "--path=\"<path>\"" "--page-size=<number>")
    local texts_25105=("Show this help message" "Show hidden files" "Set the cursor text" "Set the starting directory path" "Set the number of entries per page")
    local notes_25106=("" "" "(default: '> ')" "" "(default: 10)")
    render_help_entries__2054_v0 "names_25104" "texts_25105" "notes_25106" 0
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2501_v0() {
    local parameters_25030=("${!1}")
    local cursor_25031="> "
    local start_path_25032=""
    local show_hidden_25033=0
    local page_size_25034=10
    local __length_552=("${parameters_25030[@]}")
    local slice_upper_551="${#__length_552[@]}"
    local slice_offset_553=2
    local slice_offset_553=$((${slice_offset_553} > 0 ? ${slice_offset_553} : 0))
    local slice_length_554="$(( slice_upper_551 - slice_offset_553 ))"
    local slice_length_554=$((${slice_length_554} > 0 ? ${slice_length_554} : 0))
    for param_25035 in "${parameters_25030[@]:${slice_offset_553}:${slice_length_554}}"; do
        starts_with__22_v0 "${param_25035}" "--cursor="
        local ret_starts_with22_v0__18_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_25035}" "--path="
        local ret_starts_with22_v0__21_13="${ret_starts_with22_v0}"
        starts_with__22_v0 "${param_25035}" "--page-size="
        local ret_starts_with22_v0__27_13="${ret_starts_with22_v0}"
        if [ "$(( $([ "_${param_25035}" != "_-h" ]; echo $?) || $([ "_${param_25035}" != "_--help" ]; echo $?) ))" != 0 ]; then
            print_file_help__2449_v0 
            exit 0
        elif [ "${ret_starts_with22_v0__18_13}" != 0 ]; then
            local __length_555="--cursor="
            slice__24_v0 "${param_25035}" "${#__length_555}" 0
            cursor_25031="${ret_slice24_v0}"
        elif [ "${ret_starts_with22_v0__21_13}" != 0 ]; then
            local __length_556="--path="
            slice__24_v0 "${param_25035}" "${#__length_556}" 0
            start_path_25032="${ret_slice24_v0}"
        elif [ "$(( $([ "_${param_25035}" != "_-a" ]; echo $?) || $([ "_${param_25035}" != "_--all" ]; echo $?) ))" != 0 ]; then
            show_hidden_25033=1
        elif [ "${ret_starts_with22_v0__27_13}" != 0 ]; then
            local __length_557="--page-size="
            slice__24_v0 "${param_25035}" "${#__length_557}" 0
            local value_25107="${ret_slice24_v0}"
            parse_int__13_v0 "${value_25107}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__2032_v0 "ERROR: Invalid page-size value: ""${value_25107}""
" 31
                exit 1
            fi
            page_size_25034="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_25032="${param_25035}"
        fi
    done
    xyl_file__2355_v0 "${start_path_25032}" "${cursor_25031}" "${show_hidden_25033}" "${page_size_25034}"
    ret_execute_file2501_v0="${ret_xyl_file2355_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_103="0.1.0"
__AMBER_VERSION_104="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2503_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__261_v0 "Error: " 91
        local array_558=("")
        eprintf__260_v0 "bc is not installed. Please install bc to use xylitol.
" array_558[@]
        local array_559=("")
        eprintf__260_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_559[@]
        local array_560=("")
        eprintf__260_v0 "  For Fedora: sudo dnf install bc
" array_560[@]
        local array_561=("")
        eprintf__260_v0 "  For Arch Linux: sudo pacman -S bc
" array_561[@]
        ret_check_prerequirements2503_v0=0
        return 0
    fi
    ret_check_prerequirements2503_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2504_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_105=("$0" "$@")
trap_cleanup__2504_v0 
check_prerequirements__2503_v0 
ret_check_prerequirements2503_v0__32_12="${ret_check_prerequirements2503_v0}"
if [ "$(( ! ret_check_prerequirements2503_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_563=("${args_105[@]}")
if [ "$(( ${#__length_563[@]} < 2 ))" != 0 ]; then
    print_help__428_v0 
    exit 0
fi
command_1412="${args_105[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_1412}" != "_help" ]; echo $?) || $([ "_${command_1412}" != "_--help" ]; echo $?) )) || $([ "_${command_1412}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__428_v0 
elif [ "$([ "_${command_1412}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__841_v0 args_105[@]
    ret_execute_input841_v0__48_18="${ret_execute_input841_v0}"
    printf '%s\n' "${ret_execute_input841_v0__48_18}"
elif [ "$([ "_${command_1412}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1367_v0 args_105[@]
    ret_execute_choose1367_v0__51_18="${ret_execute_choose1367_v0}"
    printf '%s\n' "${ret_execute_choose1367_v0__51_18}"
elif [ "$([ "_${command_1412}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1814_v0 args_105[@]
    result_16677="${ret_execute_confirm1814_v0}"
    if [ "$([ "_${result_16677}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_1412}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2501_v0 args_105[@]
    ret_execute_file2501_v0__61_18="${ret_execute_file2501_v0}"
    printf '%s\n' "${ret_execute_file2501_v0__61_18}"
elif [ "$(( $(( $([ "_${command_1412}" != "_version" ]; echo $?) || $([ "_${command_1412}" != "_--version" ]; echo $?) )) || $([ "_${command_1412}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__242_v0 "xylitol.sh"
    ret_colored_primary242_v0__64_20="${ret_colored_primary242_v0}"
    array_564=()
    printf__128_v0 "${ret_colored_primary242_v0__64_20}" array_564[@]
    array_565=()
    printf__128_v0 " version: " array_565[@]
    colored_accent__244_v0 "${__VERSION_103}"
    ret_colored_accent244_v0__66_20="${ret_colored_accent244_v0}"
    array_566=()
    printf__128_v0 "${ret_colored_accent244_v0__66_20}" array_566[@]
    printf '%s\n' ""
    printf_colored__259_v0 "written in Amber: " 90
    printf_colored__259_v0 "  ""${__AMBER_VERSION_104}" 90
else
    print_help__428_v0 
    printf_colored__259_v0 "ERROR: Unknown command '""${command_1412}""'" 91
fi
